Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16132FA0C3B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76B296B0092; Wed, 15 Apr 2026 02:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C216B0093; Wed, 15 Apr 2026 02:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 658C56B0095; Wed, 15 Apr 2026 02:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 525066B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:59:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB28516045E
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:59:23 +0000 (UTC)
X-FDA: 84659889006.17.DA20D3B
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2D70440004
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:59:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776236362; a=rsa-sha256;
	cv=none;
	b=RnOyzJvrgPwctSE7UtJFPeJazh38tkekhJt6bYziNtoav9VR0/9tGVhucwpgGWVwMmIQ5u
	908dPbIMSJ8q2smz4j/4RZzv3XfmGCgJvt2GqW3jqhsyXlXV0RunvmJciT4+y9DnoUgGkL
	0HJz39dDqXxpXdEbBK6l/ypR+5/NXbY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776236362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4cycmBmatrnCWRvdzG28xMg794YYKWzuy6LwUqRuvQc=;
	b=GmidbrQHTmbIWfBpRbjFqwTwpqlfMsMoBcvVszUSgGaORIo1X/UhLNUW9CKvW//5AvlhzP
	xgJv9YI5v+1nnGPrPB9e8NhjBaQR5JD9CJThEFDCDc0xkqJa/3iDfJt5GeuJY0mN7zGp+T
	t4a/tS6RiQpFSaYWMqM6IRxJx95BkqQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8250268BFE; Wed, 15 Apr 2026 08:59:16 +0200 (CEST)
Date: Wed, 15 Apr 2026 08:59:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>, Gao Xiang <hsiangkao@linux.alibaba.com>,
	Dave Chinner <dgc@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Sandeep Dhavale <dhavale@google.com>,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
Message-ID: <20260415065916.GA28634@lst.de>
References: <20260409160243.1008358-1-hch@lst.de> <20260409160243.1008358-9-hch@lst.de> <adl1iqhldFvJwSw-@dread> <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com> <ad2RKNo2FGhpzJQp@dread> <a7a74185-df02-4906-a0ec-f87e2394aa5f@linux.alibaba.com> <20260415055552.GD26893@lst.de> <20260415063051.H3zA99Qh@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415063051.H3zA99Qh@linutronix.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D70440004
X-Stat-Signature: k1w6oy3ju84pag4dykbk41y7mq94ibgr
X-HE-Tag: 1776236361-770565
X-HE-Meta: U2FsdGVkX1+IH9larFAR1jVd4ZYDYDnNP5Qh+7uX02THggVXBSEGppejceScZbYmkcZbvr0OMefhP9AdB540VmJj7E+udAVzjMPUBOCHavkM2YYWATmtQpxWuFP0++R7nVcXivdO5gyY7DUkfcPb/gAtc6OIk8oKj+WPsRIiZo4UZHzlxcxORfb4P/jUScvuyVPJa/+HouVftrfjuZBsDTcVkHpw743q12hqtL0rE78tpHXTskBOiZQigSvZqc6X09JgSZn4aUOaaDzYS/ZCIPXgarAAH7oepsQ7LgOzjbcaQUub6W23H0h72qhoQ2mxgw/reQqHAIlDGi04XejyEVWWIiGGO0nfJgVi6iZEWPhlc1UVff/RtQt+KXEjy9h9t3ouibJWv+38kt5Cl5TEskgc0e+NiZ1O6yroQ3vAJyzusJadOr0TZF/ThOSeLP7u9fwALNgLR+F5pyN7q89IoSy++1RvL966zOd3V2Q4VgyUFr7zhD06y3dqvxDkTdpKuVDAq2czQjilEKaiux+n7wM/RiGrVEKeMhUYfuUsIN3ZzZHwr0q/u2z6VUjrkDgeroTAn3ZNwKWYV/kKQy/rIsjw1fgU+O/9ByFhN0CR0+PykE0EfGa37F+26wQmEkghK4KjW7kLI47An+T7XXjj6rbIp0Z8vfpH+b4RGMYl1X8tJH2SXF0RfkGE7qAihv3uOuYGNoTryU1VISccMPRSqyl7tTi/+gNJQBJbs/3Vupso+OccddDm6CiTobJEosr4I086fs3p7EkkgA5hZCB7wsgFqkbRMI3y5BmumKzd5ExXKZsUtNAVUIL/HpVjepV4FybWVozfaipsyPL4mAGIK9IqCfMdHzlBdv2nw3MpSHT3hknQBpIMU+jsThLq7guRJIdsviUgl4CS/TSnGmuHR1DrB0tXEpVkHz811S/QkKRuNRBPNGN/fLMwoYABuHrwMmnvOF6ufAjJmePnuI4
 cD4SrtgO
 fKl1tsBdxNryPX9nKa7SrfW534AbJM4XsTP3NpG3VE7FT7EYIxyZgDmcNEpSblm3bCo09aY1fxAmbAqdU5M30wt9lTv+3ah3Ws9T61no5CptqK4DVc/NZh7Or7ljBh5WDCdO7sre6YbpnUL0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 08:30:51AM +0200, Sebastian Andrzej Siewior wrote:
> Not sure why I ended up here

Because this is very similar to ksoftirqd and softirq.c doesn't have a
maintainer, and you were the last one doing substantial changes to it.
And you're also very knowledgeable about PREEMPT_RT, which has a bit of
a history of low-latency user context helpers :)


