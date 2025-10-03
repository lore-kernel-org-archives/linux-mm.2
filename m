Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C40CFCCA470
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 07:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C24A68E0003; Fri,  3 Oct 2025 03:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5388E0001; Fri,  3 Oct 2025 03:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B137D8E0003; Fri,  3 Oct 2025 03:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DEBC8E0001
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 03:37:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 101435AD8F
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 07:37:32 +0000 (UTC)
X-FDA: 83955997944.15.02ACC6A
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf27.hostedemail.com (Postfix) with ESMTP id 208A740002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 07:37:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf27.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759477050; a=rsa-sha256;
	cv=none;
	b=f6Cp7ImRKcylPZXPBHwBSvamNV7sQMlwQ5optgUZgYxm7k7cAkQ0qXB/KNfBw/5X2kNbc6
	w1XrPHwuSQER5PcOD9QRNp3tPsnzF2snJTFyUWxYEVqSEQo6hzmWWTpKrGOsCmi9V8HaMC
	m+7yJ5xQgXVnfDiJibqf/xrx0xERb+0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf27.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759477050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LgY/LGKDNlQsdfecD3thC34H892GdDjhZrwDbvuZQM8=;
	b=Buvn45CNZjCQS8wUB1lvHltChU6AY8puCIWFkORmjMUGMvkfGUKd31o/Y1S2mKosTijmD3
	cwMtp/6qsPGvY/OK/KJVAihy+gKPs9RxALuNyz4FvKbqSfK8yeQkh1Ym3VVWleRnuH1tnM
	c36YRuP3dHFhiMDLWpaYkXog7R/m1pU=
Received: by verein.lst.de (Postfix, from userid 2407)
	id EAF2C227AAC; Fri,  3 Oct 2025 09:37:24 +0200 (CEST)
Date: Fri, 3 Oct 2025 09:37:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: tj@kernel.org, ming.lei@redhat.com, nilay@linux.ibm.com, hch@lst.de,
	josef@toxicpanda.com, axboe@kernel.dk, akpm@linux-foundation.org,
	vgoyal@redhat.com, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, yukuai3@huawei.com, yi.zhang@huawei.com,
	yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH 08/10] blk-cgroup: remove radix_tree_preload()
Message-ID: <20251003073724.GA12933@lst.de>
References: <20250925081525.700639-1-yukuai1@huaweicloud.com> <20250925081525.700639-9-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925081525.700639-9-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 208A740002
X-Stat-Signature: 69q93ep5hu8ws31jgdsmge9oqkuaax9c
X-Rspam-User: 
X-HE-Tag: 1759477049-697685
X-HE-Meta: U2FsdGVkX18w+nhoUSQL9ovBKQ9rqWuoi79CB/pJ7lBGKtt1rIu/oCCU+aVbwk2o6cSb2sKq47/GImrEluIvWbnky5NRpMGVJFEZd7PjBUgCDuOZkxO2YXRtn907T0ED8kSy5PKb2/ClqD4JrqI9CXiOsF2MK/j0jKoFgrG9oktKc7oQmNF08RdhllMgocbAeWNhyD/+cOJa4uEmFDnNpirMak6eOXCFdELbjXNNsW42t63BZyYXNEu9Q+/nHXvZJN/jJFhXU6OUGPNRkcdrryoNs5hSwxcN3ds0pTjh/zexVHfhfam7VbwS1c5U++Ilg5EOYJdAmBu31unXRuBwLOwZAGA9kb85fiLY/8YjnbIVFw5hkhKLe/mvc4a5Try69ut/QYWBWnY9q7kTUOjOLd05mykQqBaBPwu1CfYN9Y4ngSwjFvcrMD8R6mVdadKOA3ttOAHtXlZ3Ae8GbkTC7+phNdKaRYbZ8VBz41aFOyeBDloJiplt3aqphevGH8L2+carmCYxYqB3F7YDA2xut5uOaA2rhZmyuUT5jSdVYc05k6uV2LSNjaPN7Xma7NNqJKFyuOUW9rq2mxyB4iuY8cH1eW7OHPQ7iK/xja23HdbGGs/bS6FlYpALa/VBtij5gVr1J623RJlY2p9R1zEtU5/pINxO+SJOuzMInHFLqu0dsN5RtKeEfbKqLk6sAWmfzgYA7Fn2N3BrTd8AUuZmgpscpqvX0TT9wGOBENv3hwIhPASLP85eiVB6Kry13TBCUAJpoTOjvMFMF5UYEgt2yM9o5ZAL/InbFQG0TqcsbvxPUxriL5lvTxokrbOH8iy78FY71MHZu6znZxD24lBtoJrGnDBk1lZOuCXhVNgs82sJi8Sos6CyMWVyXqAehGNQBmpSVXQ0U2yLTQ6tE9F+8lyhmGt+8sPfe1CtNqBDvWdHFGpCL6IWo7raYF4Aj3z0Hq+AVBQnJ9kWGg4omWp
 InA5GERY
 JLl6lfdrBLvFRywdz3Ol1vuv6zBop3qmeMMTrFVoNKDFxQxEZoy6PL8GhAcuxDwb0fsaAqg3eH7XIhiYbCSk5CIEC/d4Uwywd8UWKNU/h+27rWu03j2sezNbvzfedwzJjM/92v0kLd8bLwSwsCg4BFNdqhSJrTL45/jAX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 04:15:23PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Now that blkcg_mutex is used to protect blkgs, memory allocation no
> longer need to be non-blocking, this is not needed.

Btw, this might also be a good time to convert from the old radix tree
to an xarray.


