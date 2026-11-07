Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E333606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HCcDT+0G
Received: by kanga.kvack.org (Postfix)
	id 508886B05CC; Sat,  7 Nov 2026 17:39:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E15A6B05CD; Sat,  7 Nov 2026 17:39:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414286B05CE; Sat,  7 Nov 2026 17:39:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15C2C6B05CC
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:39:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F0941A025E
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:39:10 +0000 (UTC)
X-FDA: 85409790060.14.26873BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C4190180002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:39:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HCcDT+0G;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794091148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XBd2FYBcaPk2XSMjlkWCU4wyPCzPsns5z6a0+wxgQxQ=;
	b=VmM4iBD75aQ/6NBKbRYCY5CDlsnMN5wecVPuA7NuZNgjXEh+pd9nyhOpIsEbM6af7FIkgQ
	oZ6MHvkWbiLOLuI+htlKcBPqwQlmKAwhjt1JJLKm71wcASvNqPS3X0DvurgSKb6o71bDSW
	mxZY70KU+F8+GWxoJYc3wMBT5NLOBm0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794091148;
	b=WJ8a1Yy455+rBHzblAmqkZZT8NYxZsy8IFiQflA2Ao0ZLPQ2eIeTRhTarkb59Sf8epPJEJ
	2OUaRvDb3O4aXG6SUb3WKolEOjca7ESqSkGnPUTnEN1u0HnNzwXe6URaq6dIDBv+Q/k9gd
	CqiLinWHEDwdLpV2X6R3wXXE65pbY8k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HCcDT+0G;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A541C41B70;
	Sat,  7 Nov 2026 22:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEB71F0089F;
	Sat,  7 Nov 2026 22:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794091147;
	bh=XBd2FYBcaPk2XSMjlkWCU4wyPCzPsns5z6a0+wxgQxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HCcDT+0GnbTtVC35bg2MEujcDKNUToAzzu/JC2oMHTUkxnHgRuaquPSvlxWT5vLC+
	 LvXtNOspfFPhxcP5VzJ6zOCxDRPRdXPaO7ip8WLixZdf22P+kXLNykH1OsYLI30Fjq
	 fVDdXLRYYL0NZTkl36lIS5u3+nCuHztP671ezDdmq8+m6Ri4CuXgjOh/1sNjXGZHP+
	 yvj2RhJGBugFX/qtBDbMurZxbrcWxz13NI/Okb6LJxvHhvEz20ttiLFxH4jOJgy03k
	 KJFQwDYS8EVwhcnCRrCb9nVNdl1a2xhXQ2Kb3ab2TkxRXgJwSR9CyxSFb5bzKJ6hWC
	 3WufiZG9rpxTA==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 6.6.y 3/3] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Sat,  7 Nov 2026 14:38:59 -0800
Message-ID: <20261107223900.331929-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-203367@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: fjat31fjxixfy9x5t7qhdd4d5xwmjw35
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C4190180002
X-Rspam-User: 
X-HE-Tag: 1794091148-273355
X-HE-Meta: U2FsdGVkX1/GogP/Lr0KHAO/SKXuRPed6hQZmFJ2sAGGdhKjov93prqg1cxiY9Q0sDNA+mzCRwJ21bwkadXOBZ9BjanGWC15yqIgjta+H1qh7aer8BFeoi7HAKbJc3c/GrWNaiVty45DKzGl9D8enoN+eIaWAu9ypDI9pX7zbXz0TgxvOVCoyqSYz341khBtjB7OVaENK9ItaN5MnQVmzCb/WXt9V/MFAGufq6huN4InKCiQe53BA/O7uvSkndgX0gnAGAl3YS5Tm0FdUl3FBvFAEFKxSobribimVIQMhpI416U6bmQOt6z34a/onIkyxfG8xz3yY+Wjlpou84/cJpk23xzWxlARHTio54K850LQCqwRlfiNFb04r6pGgMzXM0Q6cruwn8j2YUihl1iI4KCeRAzdpJpSRV88OsMvpyg0sVaxBWAh9GX1nzZ00xpQJ8kjFuF3hblg/hRL+JkHJjM7l1xDZyJocmMwwqw3wYmRmxemO8U6Kz12S8kmfRCwRJrN89evpq0vzJ8uduh8kwPHcanYGbIYBARdSIslWknpvBCkNttVmuIJqE5G6E9GgiewQdczIWK8MSjQTnAPztbYeoPqHFAAgMuPzIFSVJgUjftSWaVpdl35GAw+Ir3QYM31SL1hiGhj0+yCV7FSfAkTbqnqUcDbFdRQzzVJ29O70yk0htsl+DilFNpC/icjxilNPNdMsccxA9pO7najaYzY2TMYbyxK5jYLIPlgn3gR0AEUGhJPvafkUlkWj1pLFmn7wzlupofOcBOCUsJAzopN4yOaGlhMank6qhVCFJ288gFlBQdxiv2BsWTi8OdhWlLY1ZHnDsKKDXhfdV8WqZnAlttszbtfB38xE11SAH39qjY1GhmCdmmn2QzKZ6vUKw0kQ0uWsrteHKOsPd+WribHn223Lj0Y3D49qCuZN8N1OVEsgOs0Wk/p70zT6vnCV+sgSiAXOjA/Yujs/aE
 PMvT7N7M
 Kdv8k0Ps5ePfdLV8babUKH/87wUyGGlT8gW4YQEVnHM6sqxtomrTO5bx04XRLZR9LWSm1EhlXtRtLIG81IhnJ7d+TjyRPoHLi8YgXr8B6EksE7gaZwB3VFFRlx5KNo0pZmsPAeTFVJmVRp81o0Dx+Ra2pn8o3HVaynRycD4m923/gCSKQ+vw3gxpiHeM3NM4hveiUOWqgeFtpqLdsH3d5r8V4i7prV+wZuLyBqfgGVYck+Uk05cZD6SYBNklhOVLx7PcPnhXis+MFt/58YVxDy0S/3I+caq+4657ZmFaBV/K4ryN2x4ZJHPbjXApHSyZ+NOuW3UVYnFBqTosxRNlHsEMAqUg8AZP35Gsdr4wkFND1FAZh9Gqv/l7H5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 07 Nov 2026 22:34:54 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/damon/core: dangling pointer ABA match in
>   damos_fix_stale_charge_pointers()
> --
> 
> commit f7e621ee98abae5b2fb7828ae72ea3e96d1173fd
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: remove unreachable damos charge_{target,addr}_from
> 
> This commit adds damos_fix_stale_charge_pointers() to damos_adjust_quota() to
> reset quota->charge_target_from and quota->charge_addr_from when the target is
> no longer in the context or has no regions.
> 
> Link: https://lore.kernel.org/20261020023958.108276-1-sj@kernel.org
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 99e934a6d1ce9..61d45d40fc1d3 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -1088,6 +1088,27 @@ static void damos_set_effective_quota(struct damos_quota *quota)
> >  	quota->esz = esz;
> >  }
> >  
> > +
> > +static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
> > +		struct damos *s)
> > +{
> > +	struct damos_quota *quota;
> > +	struct damon_target *t;
> > +
> > +	quota = &s->quota;
> > +	if (!quota->charge_target_from)
> > +		return;
> > +	damon_for_each_target(t, c) {
> > +		if (t == quota->charge_target_from) {
> > +			if (damon_nr_regions(t) > 0)
> > +				return;
> > +			break;
> > +		}
> > +	}
> > +	quota->charge_target_from = NULL;
> > +	quota->charge_addr_from = 0;
> > +}
> 
> [Severity: Medium]
> Can t == quota->charge_target_from falsely match a newly allocated
> damon_target if the old one was freed and its slab slot reused before
> damos_adjust_quota() runs?
> 
> When an online commit removes a target in damon_sysfs_apply_inputs(),
> damon_sysfs_set_targets() frees the damon_target via damon_destroy_target(),
> leaving quota->charge_target_from dangling, while damon_set_attrs() advances
> s->next_apply_sis past ctx->passed_sample_intervals so kdamond_apply_schemes()
> skips damos_adjust_quota() on that cycle.  If another target is added before
> damos_adjust_quota() next runs, kmalloc() can allocate the new damon_target at
> the same address, causing damos_fix_stale_charge_pointers() to return early
> and leave the stale charge_target_from and charge_addr_from values active in
> damos_skip_charged_region().  Clearing charge_target_from and charge_addr_from
> when the target is destroyed during commit would avoid keeping a dangling
> pointer.

Good finding, but no real issue.  Occasionally starting quota charging from
unexpected target is no real issue in real DAMOS use case in my opinion.  Also,
same behavior in the mainline.  No blocker for this patch.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261107222202.331476-1-sj@kernel.org?part=3
> 


Thanks,
SJ

