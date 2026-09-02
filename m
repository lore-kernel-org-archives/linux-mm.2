Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69151C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8638B6B00A1; Wed,  2 Sep 2026 09:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833C76B00A4; Wed,  2 Sep 2026 09:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771BF6B00A6; Wed,  2 Sep 2026 09:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 56DBB6B00A1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:49:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EEE0CC01CA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:49:56 +0000 (UTC)
X-FDA: 85168955592.12.8739934
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf16.hostedemail.com (Postfix) with ESMTP id 22F63180006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:49:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf16.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788356995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=A8UEu7GAsam+uCaRH8Q/t8DNI2YcnRaB0HBr4u+qvchoQQWu5Dd91lAYpK9AgO/SuGz8vM
	Itng1izeyqfGLil3sjEtqMm6R6MRiBILLX0nCxkXAeTWN6b9LovIKCmqow9HOS4YX+IWVc
	f2MFr4Cy5k9vzqOnFFQkWcXd4iMgtHQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf16.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788356995;
	b=jrZVhi0C4IYlg2VaXSjDkv1J4eQX4njaIIEXuEG2JpSqrK/z3T/NJr3sthJbMavD9rwxhd
	YQ/3D0+WjD3nbgLkBHyLVCBofBt5PAZxDUP8DtKyhmJKmUwwW79UyX5N+iH0n+dQPSy/r8
	t5YjMZQBHgn/JMkFd257b0q3QFD3fzg=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2A61668BEB; Wed,  2 Sep 2026 15:49:51 +0200 (CEST)
Date: Wed, 2 Sep 2026 15:49:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Yu Kuai <yukuai@fygo.io>, Christoph Hellwig <hch@lst.de>,
	Tao Cui <cui.tao@linux.dev>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/3] blk-cgroup: move async bio punt state to blkcg
Message-ID: <20260902134950.GB22560@lst.de>
References: <20260823133045.970199-1-yukuai@kernel.org> <20260823133045.970199-4-yukuai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260823133045.970199-4-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: m71zk474zce54orn7xt5xytg7pgr7pny
X-Rspamd-Queue-Id: 22F63180006
X-HE-Tag: 1788356994-301918
X-HE-Meta: U2FsdGVkX19ZFtDrmlfw6WfyNprYLSnF+HjfMaSyw+CjWIp8I6T8UGVWrHVrd2H6wxJDyoIYbuX566IbZo6ilx1BpFESDWtj80uLc517yrATJ/jUo8SHZJMCu5Dx4UnTa51FRbADIfyCr0JP638QAzG7kmo3AdM09OSHVoi+yM6c0oSCJ76Pnega7j5GBd+UjyfE1wiOE77gYav58ptvg+baaKmBKH7ydCwNJaUE9fNe0NCOAph2Yk4k2RLfN9yXT80EUiepcapJIARrjFVuJ6V3kFMPkKVkv+WCTNq/kY9mX03a5iYhjsgUl5invNiGKw87UKHNjba2fqhGV8fd7yq/v0OlxLBggAWSF3sVjUMHTqYnttmS4iyFbVrdW1X3+IqO81NHInvqBOSOjg3ujfir5vWdX2ZegQ76XF9TfMF4CNphqWFY+KjExcnjC31IVcRhrFhIWn/kfV7AcWmdOmVn8EJf2mdHx/jPom6O6fvOLXqKgFEm/lJ9MoHBdiGQsoP1FYHJHg/Vm/bM66tUlh7QQDYzFlsm92J4/Kd4/a7lL4dVpOuv3deCTbKd74WFs1ypPy66ldSKra3sL7HJtWnbZ3/2PLKTaqITTRPEt6xBc939LSLkRhPj1ar8r+sYFGhv2w/0VN8JLmfJ/lDT2T39ZVEWwJp2hL60ZnxRYKRQthnzmTGFry76GzFmnJtcHOPOPR+wrGCPd9EhHkzw+fYU8Ki4fdg+EX6S6oOTURod5c41ukY1LK2dHCMbaceD+LzkSoxtJLnjhF6OojIA+tda2EPGrj8Q52lcfWjUvpqGKfio+8lkBpyLeoLC5HbE40rycTWrFNDV5sVYAD1qjHWaH+HfdoEIVwAEeJmwo17jXf2tHpyubCFocZBewH7P1Q32LUFesnfBTNRi2FRGxPGlgaOI1augYRFTGtUonEZeavGkT1+WSUh7vwzmNmZEP/SvWCjV7Wrf/kaqafI
 cIVCtcdU
 N01fJH1TMyAYyL6WarkWv1T3Oy3p+Nz786O+GXRvblsuD/FjdYkDN7sHE9eOM+9PAAXtWd4JLBYRaVsutsdi4NElLfkQo8OK48evoWDr7cyE4xIqexxflV5iLiRIYiQjHZD5ylXoW3HK4NT7g6pf18ADMf1Fo2+rhdPWZpX7aCDRvqN1mwbGNa/YP7YsqPUgL7t78lrW6xRslTI0I5cl2ez4h/Mf38gXu3xCRP40z7ozsW5XRojd8TkQL/euHd6pmIeGUuOGdZ9Z8ml8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


