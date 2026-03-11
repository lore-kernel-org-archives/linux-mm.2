Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B50A9112583A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 14:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF8DA6B0005; Wed, 11 Mar 2026 10:32:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9EC66B008A; Wed, 11 Mar 2026 10:32:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7E306B008C; Wed, 11 Mar 2026 10:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 852256B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:32:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19AFB160252
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:32:17 +0000 (UTC)
X-FDA: 84534022314.28.85C1852
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 517A340013
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:32:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JSfKl12r;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773239535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8WECP0H9VH2h4LVxm3WQgl5uQgRsas867JB1DI7kZGk=;
	b=0fmkejOv2wEznkZhg/MkZ6jvG34vMArqsYBNFg/+8NQ1hoI/VNSz8em5mnD3nM5uLsLmVW
	9SsoLIL6hZRHb42PfH/5MO8do5xop+NPe8FVcQDcCGkz4iL6nMbICXl3pVwf/hUfMo/IRN
	75uIRc2gzcLgRwJyo6/uv/whwCB5qMo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JSfKl12r;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773239535; a=rsa-sha256;
	cv=none;
	b=Spt2zWjf6ybEkozrq9doo+JCiVhkQXDm8BFL1WSXjv5waU1Uu2GgXLntJSisYsehbEVIWZ
	h3N8lLzqkIK9Knbb9XQPi9PfR4rdYm0OUnYQ8pJcKClGLT4x5h0F/kg0/0Nqy5OyzW0QnP
	nt3YbJ8ytpUp6vC5gl5RIB/4k/sB880=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43C9340ADD;
	Wed, 11 Mar 2026 14:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F0BC4CEF7;
	Wed, 11 Mar 2026 14:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773239534;
	bh=pAJnkE02U++SCDFnIRPdCudeLD7FWR/QDkiyqw4OeSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSfKl12rdKbyzdw1l2LDF1qw+RCEx1P7A0VJCwSeMZCBQ2nTD6Ioi5s/X1yCFhzCU
	 w7eboHQt3W5KjRMKLg71cjf6SKm8scbu084kgMTy2WFSERKVFJy+eKbnhjTgm0CoFi
	 fD4DF0liz/vqTD6ul4ZEH1FwCcS7+6DBtZ20uo4LtlNCG8msLiJmBBDu3Cjwf27VKS
	 1pT64VOzVvi8Gy1eSJ8sF8tKg0bK+DxmPRlwKdLptvma0DP9zyv+1Ztd+4uml24JEB
	 CksE6mSFSDJhYXK0HSGB3GyZ/2TUEHS1esNFUgEcTsVInI/62LCSR1jVe9E8SwjaZ8
	 ESrGnH5op5clw==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] mm/damon: New module with hot application detection
Date: Wed, 11 Mar 2026 07:32:06 -0700
Message-ID: <20260311143207.96707-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2895abe3-96f7-4428-8161-a8223ec758b7@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zp57w3ybou9ghdjun6s574cune5qjjsy
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 517A340013
X-HE-Tag: 1773239535-805351
X-HE-Meta: U2FsdGVkX1+WNAHTAegIrG89obdy8hM+YcG+gwUTY33soSeEUYrdiG9OM4U05Rj6d8JfACVMMajHDHgnjuNdaPJ0CtpADZmAXScn3m4gRcx7kdoZLig2kn7oDnvzTjuF4gOCskYO239tTrmi3Sp475FdaQZdhKEWFA1XgsDh0R7fXvACgr5eQkm+xO93lTL26u51AA1jLhoU5YeMixc3F10MxlVs1dTbs3FmAaOEb+QHcBPUsgrRnY8OfXvCB7F5vu8iW98e3KS6M5R0OT6hiLghLGaJEKRZwY2rXd+6mA47uyeaIXZlq4lxfZVWPqYeF3IhiHIODTzw+jQ7x/YWhm2LTKj4dQUDxgwTlR04i1QEw+B0RXdRJL4uWaLUc50GcQRLoERa13LurIr3VND9RRcgJ1GXYqwOLfl4zAtcznfbVHZ2ozEYwWRAh4QKhT6LH4H1bjNhJI0zbf13cy3xy3m3bq3MMm7q+CMAKpO/tiR7ENxbQMXHJnIgpNSLm/ykPNuCoO/A3uPCyi6iZTre1F9rblI9h2TCOq7WZsE34VNdR4zZ/JcAACGPjpG2lCljuQ6gqeL4rMKzagLedtjgLnlRzt3JdbwuZ4mul89SZ7YhZR63UQDhoCdxf4fAV/lnRqnZOHUbnnked9riHIurVvYTcOtWmTDUV9HKZ5Jdlhpk0vna+0xtPZ2PloiKuS/lwaYlIhEbqAXTxc7+W3ktchw/HCzidP9ARIS2hDyvlGdhmceMO7PBMUSycq83tt9/32IBrq23gewXawB/HxJT+T3tcOK1l2iNLSI2G30b60A2tAxdP7O8eqRxER/UXPpk9DB3T1r6df62CrC/qXYG6+cEebfSt41FyXfQZ6AI/GFMEk3OqEjEQt9DaZ7+5Idm90nT9n5RV37tM2JacLv3O2chIdxd6kP5jmjC2zZF5HRSxTBuWNyk35Qt08zKUGAwVG7Rez/uS5LFeKVaJ8B
 o+gsaFQ0
 nSSeqqMn+6/S/nR3dI4qhN0QMAS+J2JONJVVdR3jyeu2gxXcVtg6775/9PpIhjNj2pmM7Cs2KBtrQYdPBdI1wnUcS9CvJiyboL3giAlpmWrAN/hw2HqyxoCdRq9ON3VY1T4cGCiq+2MyhJ4KvMNo2/l9Nb1nBDWTQlEIJoEFkIQUN2hX1iTNbKwyAMT2QghoZM8GHKNDq9VOuTLB0Ac1wh6WwMgT+vn9bApXjHhgvd6jHcAUQXK3vWE2LB7/zxXChk0idNi5aATnnVnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 16:45:06 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 3/11/2026 7:11 AM, SeongJae Park wrote:
> > On Tue, 10 Mar 2026 16:24:19 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> > 
> > I'd like to discuss about this in a high level, but I'd like to do that on the
> > cover letter.  To this patch, I'm therefore adding comments for only details
> > that stand out immeadiately to me.
> 
> I will update the cover letter to add more details for the next version.
> 
> >>
> >> 1. It first launches a new kthread called damon_dynamic. This thread
> >> will behave as a supervisor, launching new kdamond threads for all
> >> the processes we want to montiored. The tasks are sorted
> >> by utime delta. For the top N tasks, a new kdamond thread will be
> >> launched.
> > 
> > If I read the cover letter and the code of this patch correctly, seems the last
> > two sentences of the above paragraph is outdated.  Please correct me if I'm
> > wrong.
> 
> Correct, I forgot to delete it.

Thank you for confirming that, and accepting my suggestions below.  Most of
your answers to my comments make sense, so I'm cutting most of the part except
places where I want to clarify my points or answer your questions below.

[...]
> >> +};
> >> +DEFINE_DAMON_MODULES_DAMOS_TIME_QUOTA(damon_hugepage_quota);
> >> +
> >> +static struct damos_watermarks damon_hugepage_wmarks = {
> >> +	.metric = DAMOS_WMARK_FREE_MEM_RATE,
> >> +	.interval = 5000000, /* 5 seconds */
> >> +	.high = 900, /* 90 percent */
> >> +	.mid = 800, /* 80 percent */
> >> +	.low = 50, /* 5 percent */
> >> +};
> >> +DEFINE_DAMON_MODULES_WMARKS_PARAMS(damon_hugepage_wmarks);
> > 
> > In the RFC v1 discussion, you also mentioned you will remove the above, but
> > seems it is forgotten?
> > 
> > Also, my understadning of your reply on the previous discussion was that you
> > don't really want to use watermarks in this module, and therefore you want to
> > remove it.  Am I correct?  If I'm not, maybe I'm still not understanding the
> > intention of the watermarks.  Can you please enlighten me?
> 
> Since I refactored heavily the previous code, I forgot to delete this bit.
> I will remove it now.

Thank you for clarifying this :)

> 
> >> +
> >> +static struct damon_attrs damon_hugepage_mon_attrs = {
> >> +	.sample_interval = 5000, /* 5 ms */
> >> +	.aggr_interval = 100000, /* 100 ms */
> >> +	.ops_update_interval = 0,
> > 
> > Is ops_update_interval = 0 really your intention?
> 
> I didn't think about it. I will set it to 60 seconds, as in other modules.

Sounds good.

When 'vaddr' operation set is used, for every ops_update_interval, 'vaddr'
updates monitoring target regions boundary to cover all virtual address
mappings.  If it is '0', it will do the update on every iteration of the
kdamond main loop.  It can result in unnecessary overhead.  So I was asking the
above question.  Setting it to 60 seconds sounds good to me.

[...]
> >> +	err = damon_modules_new_ctx_target(&param_ctx, &param_target,
> >> +					   DAMON_OPS_VADDR);
> >> +	if (err)
> >> +		return err;
> > 
> > You should deallocate param_ctx before returning the error.
> 
> Not sure about this. As far as I know, damon_modules_new_paddr_ctx_target
> will destroy the context in case there is an error. In fact, reclaim and 
> lru_sort modules just return error when damon_modules_new_paddr_ctx_target
> fails, no cleanup used.

You're correct, I was trying to comment only below, but somehow confused the
place.  Sorry for the confusion.

[...]
> >> +
> >> +		list_for_each_entry_safe(monitored_task, tmp, monitored_tasks, list) {
> > 
> > Please wrap lines for the 80 columns limit.
> 
> Interesting, when check it, i was less than 80 columns. Even if I copy this line
> and paste it into any text editor, I still get less than 80 characters.

Oh, you must be correct.  Maybe my mailing tool was showing it incorrectly.
Please keep it as is if it doesn't exceed 80 columns.

Thanks,
SJ

[...]

