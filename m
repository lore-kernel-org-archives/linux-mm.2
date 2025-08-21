Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04E05CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 21:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DE548E0063; Thu, 21 Aug 2025 17:41:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48DCD8E0056; Thu, 21 Aug 2025 17:41:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 354DC8E0063; Thu, 21 Aug 2025 17:41:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3938E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:41:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C135CBA018
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:41:55 +0000 (UTC)
X-FDA: 83802087390.15.F7E8475
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0536C20004
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:41:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fZvB6nlq;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755812514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eIFS0csaB1k7FOeyUy61obVUEGBpqFFKCT2cPJmBt1c=;
	b=ct6h0Nf9kK85P1fjJb0P4u21xWDkp48mEggS3dwMON4ymVY5HeRVaSpONHIHSybnLkU0zl
	vweDfLxXOF5XvCmlUzOmWNiU+j5xsPSFnqzLjPXbGToO/bHZxwSaUBKidXFCeTEO4Bxdpr
	Cp4zCIbfaimDxN/d+9Cv+kK3l0wxHE0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fZvB6nlq;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755812514; a=rsa-sha256;
	cv=none;
	b=OJJRwp4cnerVO9B+UrHNCDHcxAZ7m1SE/9NHufCLYFGzr+UrURt4i39a6koHnLFz9jVBVj
	6n+br7gWcH9ql/8cvVItvyGvoDXtmF/lSq/cQrAQggK6CfktxI+239oyXmooHxVysCIWfj
	F3I2MaTgZq+6oEkdyu0TI9w6WyR38e8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 1C93A5C5D72;
	Thu, 21 Aug 2025 21:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8962AC4CEEB;
	Thu, 21 Aug 2025 21:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755812512;
	bh=dN2haf/5HOTLTD8G28EiqnCMdgRUmDTwnhod7N/s36k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZvB6nlq1xfjgHLIGy2a+G5b3O1Vf62M+K3G0ySm9RFVhVvORhyqGntOIHjF2lyWq
	 CWD0h1c9HfC/YrcxGWGFKBRLIEmwWOhcAEoUnnFAES7bj/ZaQoOSZDIaRvVERvj6B/
	 jpwjmyqTh3ZrH/HGWqqw2WT/YwSPUQIj+ZUA07AzkzH0TpRESnpETMzjltIUSjhKD7
	 MAIfCiwHW9Ho/WdX5yxqi69kkBSvlnBnkIkOIetdrRHwmHSQnVPaLlZAZN4fsgT4eW
	 G3NUAf10RQpWUg18T/hTt/2U+H+c548KnRu/lwyBzf8koyJL6QLiXVBvfBGMelm7db
	 bfq7/OBLD1Xuw==
From: SeongJae Park <sj@kernel.org>
To: Chris Li <chrisl@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Thu, 21 Aug 2025 14:41:50 -0700
Message-Id: <20250821214150.1911-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAF8kJuO7vQS3TB34dDZ6reTfeDpfSL9CNQqEwZWjZsGdhirs7Q@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0536C20004
X-Stat-Signature: 6wi9cfwyxdjd16j5xajumwbpotanh3w1
X-Rspam-User: 
X-HE-Tag: 1755812513-2403
X-HE-Meta: U2FsdGVkX1958FZMCByJ9sYiNBoXT8LoAFnMGJYNTx0uBGsI++fgZiOoQccU7pxujRTjeEI2Ojc48bU82MHqQRAfIybHfKQ7tGs1oAZVT2Ur879NHGsrEmADzXB1vzWUfYI9sAjMvmVtiEObJpXbKJ/zSzbZjk//akjdoywV96+egqRBcF/S4jKt5Zn3tZ6VBVQ0acfrY0tpBBOSIiSzWrG8yfXuBFKnVrUH3fOmWOMrFDOrwvcrNyS64FAbe3IglRUBrWPbEFy2cEksFlAruNaT+GuZTwCP3EAfd9AEJmu5xxnXztk5vwVkQP6l/0k0Kk93Z9P26ogVCqaTwkUgZyhyWGNMmRJRqv3+kz6dUWnPaOMEt/yZzPeA4vegKsultUtZMpUjScMZJn7m4OEideJ2Ktu6PBA0eKv5HH/5sgJwQMOaHn5SsBSLq8YSrchTzt8Rmt8uYX4+XnY3vjehGMSLeUV4DohWUGO8SoIGE+4BRRyErA3PiGY0GbV0UK9tPUo55Nu+7II83OqCWStlXk6LPZ5ulVAwmPo+EbYumA1Una0y22RHpY3QEgBBJI7QIPVBw4qz6UbnuHloiNmOQPzMuZP3fK1hZo2qhQqaLFFFhKxQbrpMGhK17ZK2Slxfcf72UQQmV0aD/WZWeCC0lziVEaLoG/MBXTcodEz4yjBqTfbil1a475ghH2TCvClp1g2yD/KOCNzWhrFSyjNy8WIb9jXOiJhUHOVpsr4QnM8uc2H1OEKkSLYA+BFJPHj95OKEeWiqSMdCmylNbYLsjTGSWK+3abEP49JMbs2F0U7S8YITtKBt2aDfYWnNMbXefZ7Iey9k26+c5iWG/+1HynwXim6LrskdhKtX2KUbvCCeWCk8pz2YCm2d5I4m7pjT9fpATMcrgxykDPLZekiup4hWcFWayuqWyGGYx2mbJmaNyaMcXKBB1b92RH4BM5PEse70GU3Gc5ptVXWi69Q
 Pyxn99fd
 T2QqU+e8NG7EAWUsGnqM1x+PZOH22tbgkywWyT+IyDCB19NFjH4/+EeqBxUYL5/1/ynFyNdNCRPmn9X56H5yG0X5H8wdTb2YsCeyZ/J0gkWY6oTnZysNYeR9v69Ze2QZ5NpMu5flnO9aNcP22Tp+PVERdy4iVHioAjcaQqccsG0dylKoNrXt0POXh0ZVzLAbwdBKDc6YvbMTzE4Sdbu5SeyXD1mKy2kKjBcXp2aVvbupfCghEJ2INzT0ra8RrPg2d1j3kW5LmxrFx0CglQJPx/6/vXGlQ/9YX+ghxqizCJi1odp+7xQ2PQKMbcjTXdT2z4NG5gG2JqcWW7Yv7WQCErFuuqlUEIT1sXd8MNCKkU2gnpp4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 14:21:11 -0700 Chris Li <chrisl@kernel.org> wrote:

> On Tue, Aug 19, 2025 at 12:34 PM SeongJae Park <sj@kernel.org> wrote:
[...]
> > Historically, writeback disabling was introduced partially as a way to
> > solve the LRU order issue.  Yosry pointed out[4] this is still suboptimal
> > when the incompressible pages are cold, since the incompressible pages
> > will continuously be tried to be zswapped out, and burn CPU cycles for
> > compression attempts that will anyway fail.  One imaginable solution for
> > the problem is reusing the swapped-out page and its struct page to store
> > in the zswap pool.  But that's out of the scope of this patch.
> >
> > [1] https://github.com/sjp38/eval_zswap/blob/master/run.sh
> > [2] https://lore.kernel.org/20231017003519.1426574-3-nphamcs@gmail.com
> > [3] https://lore.kernel.org/20240706022523.1104080-6-flintglass@gmail.com
> > [4] https://lore.kernel.org/CAJD7tkZXS-UJVAFfvxJ0nNgTzWBiqepPYA4hEozi01_qktkitg@mail.gmail.com
[...]
> > +       /*
> > +        * If a page cannot be compressed into a size smaller than PAGE_SIZE,
> > +        * save the content as is without a compression, to keep the LRU order
> > +        * of writebacks.  If writeback is disabled, reject the page since it
> > +        * only adds metadata overhead.  swap_writeout() will put the page back
> > +        * to the active LRU list in the case.
> > +        */
> > +       if (comp_ret || !dlen) {
> 
> Looks good other than the feedback provided by Barry as well. Need to
> handle the -ENOSPC.
> Other errors will depend on your plan to drop this counter or not. I
> will wait for your next version.

Ack.  The next version will keep -ENOSPC comp_ret value so that
reject_compress_poor counter is not broken, like I replied to Barry.

> 
> 
> > +               zswap_crypto_compress_fail++;
> > +               dlen = PAGE_SIZE;
> > +       }
> > +       if (dlen >= PAGE_SIZE) {
> > +               if (!mem_cgroup_zswap_writeback_enabled(
> > +                                       folio_memcg(page_folio(page)))) {
> > +                       comp_ret = -EINVAL;
> > +                       goto unlock;
> I saw you mention this in the cover letter, so just to confirm we are
> on the same page. Current patch still has the issue [4] of write back
> disabled cases, the incompressible page will stay in the page LRU and
> possibly attempt to reclaim over and over again, right?

You are correct.  This patch is not making a change for writeback disabled
cases.


Thanks,
SJ

[...]

