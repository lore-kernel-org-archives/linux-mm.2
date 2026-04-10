Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D999F45A0D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 23:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1716B0089; Fri, 10 Apr 2026 19:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78E86B008A; Fri, 10 Apr 2026 19:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB5A76B0092; Fri, 10 Apr 2026 19:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9CFEE6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 19:57:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59628C2212
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:57:06 +0000 (UTC)
X-FDA: 84644309652.26.163908E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C03BF12000E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:57:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OMR7nVOa;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775865424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTk0MFlRiSfeLuauJQzAezTHwA+lVl3RLb9zcxPYuLU=;
	b=1kbi5Rs1He7GSK9kgXjbY6UNLyO5ED5qw39zzWOtS9gvMNtvSJby7GWpHa9GMvQ1deO/4W
	oBnhr3n2t+EbdJbVpwQZbeZogVAWKeb/hRHPJDPbybvNVU/QfqXhKKT130Wo+GWllI3cLr
	MRNIYlyom4KCRXYWO/RTTwOIe1v0YK0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775865424; a=rsa-sha256;
	cv=none;
	b=FKtPXqFJ7AESl2uhBCASU6krSUaQjAKz4Fyu3umscskNI7x/WujGzGWQd87Q3pcKHHBbII
	MyaEEDzzhMyFeftYob1PVRbpwT15bU+5NbueYvB350cvGo7jWWUaItFwtVR27lSmV4MeWn
	e7tk0be4bymcqYrx2kzhRkVkGA+6gV0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OMR7nVOa;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 33C0D60141
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EB3C19421;
	Fri, 10 Apr 2026 23:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775865423;
	bh=fC9m9hWBDRvcsGbkiKWjW38zCbWI8Pw4SpDiXRdNZNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMR7nVOaLcyu76qAZGsocidiGrhC4s51MCUzYZ12sbxiMITE/RivK27TyYrkRnXeH
	 cncDVtNgDAEuU09utKGQWZ579oXiPu07utDkgqfsyOcia3/KjoflDf74AJ775Bdk9q
	 vJ/heVujY4VCVbCxaTfoD2NMvYuS/gTOsDyxGWvG1ZFj4xbEQcprBlZsn74/d+TqA4
	 9y6wgTMCU+dpRp8H41aJRN9CybGvNq0nSZnLRJlGUjzvIqbeDGy9XZWYwH79vGNGF7
	 zp9XZW0ueb9hY5BmaconF6bSt7cCOZUbJkYeoMsxv2EQNS0Px+fpfttmNLlrnZ7Ni5
	 63T31HqL4NPcA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v5 03/11] mm/damon/core: introduce failed region quota charge ratio
Date: Fri, 10 Apr 2026 16:56:56 -0700
Message-ID: <20260410235656.91023-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410142034.83798-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 5d4ums85rgak5rwpwjjixr98fdpz3rmi
X-Rspamd-Queue-Id: C03BF12000E
X-Rspam-User: 
X-HE-Tag: 1775865424-367058
X-HE-Meta: U2FsdGVkX1+SI2C8A+eTmIBMpl/uIJzXcnNTs0DkYngLaVhqfdcNix/VBQa7jeKvnwnL0YGLG8ZWvwH8bTLuOCxKAONieIXDJLvvbUlseCjcNSmCg+J9mwwWb680Yp0k+JvNwyF4xBeWYJh6c2/mG/8ZepsJb6ryPgzfBru/70XM5CeGX51M7lqaR9XM6/7AjxvRqOmm7eT+RMXV5xDLncZR7KEmdWK4d9zsnNK/4mm0kTF+DkDIdOuXnlw8UqvuUUGigyd0vl+h5vuHsVg3IZz5wix+4l+aEh9Hp6P0P1O6RLVGcGtWGS0yQglQa+jVHhlAhCVbRbvzkCUaeALYEcaJsUwnyDXTXEntg9a4zPHbpueTrWr5SZJfcRIzF1hY477gam34pos2tVd+m1qMFoe1cIU76wuljWCoTr9oO6WCNfuVIYejWUxG4FtixeePk7UsG9khOYfRzVwDlIP7tD6nypDYDFn3C5Y3j8LAA1qy/WwENEeqwdPLdrAkEs3oV2kGf9mhMRYwWQpMVWUTk/bs6xgn1JLx53zJqhmDMUs/fAF6koqOA28UCKzBc7h5JwzRD6mE7dFcn+fWm8Vq9Dx+F2L4PcBEci+nrUtPcjN7oysp+bxbyEA0Bvd75EcAKJ2HBBcvxPLWWnO2dYZV0/Th5TNy+htaybg8M7pr8ctnghdSQ/iL2GQqHlMwVlJSor9MhH+GlRrCAKnwvxL6CQz1U3del5VdlECitATjoFRsdJTxm0P3qNHqAiGab/t+t3pbXp2Pp20GHqYMHEEeZDg7pBdgY2Fn82P8DjCQot3oY966bhwsB0rFAZvDNy6hkbkoZ47UZqIra4MPW0ZCnboQ1cR1ml3byWGMcAcgSfS7iJR1qLk45BdeLTXf4PgqWcR1SMll2Pir4u3KmWkFXyuYCUAQ9TX82JRZiUWBn/+sXjEnpTiOrCDrtjaVoVnIAlj7cIDbe7jnFFrA5Xi
 Q25iYmPS
 NAT7VzFgsSV68n4SaskJdzt956OVKMOno8j0jtgsT6LqLGqTKCtevVon8zXcmc6pFXIS7GG2+/QTAKwrmESjGfcJ1LZJG5DNUg9cr6pDVjQMd6R802iQSzoiukhgdMAi9AJ77EchdDb+YwxexZdHA8AeGJj63Ej4c+an52D0WpdbAC8x9DhPiJpDalI6WBU0kHvyOmQ7U+I65KDRhA/iiegM113qlBMMDev23x3K0pFU2o2Ja+bO56KKZjdaM5ucMClzOWGJfutL9cqdXgPB8QjoMLGH4p2gjbXVwUbZEL9bhBSZ5VY0JAX+CRdeLnqSCNa3zReCWvD+hK2wo84KiHJWYrrIawkF3Tw+2NTHmLdMyoAH18Fu2SoJjng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko asks same question to previous one, which I decided to ignore.
My opinion is not changed.

Forwarding sashiko review in a reply format with my inline
comments below, for details of my view and doing discussions
via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260410142034.83798-4-sj@kernel.org
> # start of sashiko.dev inline review
> commit f672ea44b246c3c6bb3fac52d693ca50e48cbbac
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: introduce failed region quota charge ratio
> 
> This commit introduces a DAMON core API for setting the charge ratio for
> action-failed memory. It allows API callers to specify the ratio flexibly by
> setting a numerator and denominator.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 97b375c720251..cb8f65db0f4b9 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> [ ... ]
> > @@ -2041,6 +2043,23 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
> >  	mutex_unlock(&ctx->walk_control_lock);
> >  }
> >  
> > +static void damos_charge_quota(struct damos_quota *quota,
> > +		unsigned long sz_region, unsigned long sz_applied)
> > +{
> > +	/*
> > +	 * sz_applied could be bigger than sz_region, depending on ops
> > +	 * implementation of the action, e.g., damos_pa_pageout().  Charge only
> > +	 * the region size in the case.
> > +	 */
> > +	if (!quota->fail_charge_denom || sz_applied > sz_region)
> > +		quota->charged_sz += sz_region;
> > +	else
> > +		quota->charged_sz += sz_applied + mult_frac(
> > +				(sz_region - sz_applied),
> > +				quota->fail_charge_num,
> > +				quota->fail_charge_denom);
> 
> Can the mult_frac() calculation silently overflow on 32-bit architectures?
> 
> The sz_region parameter is an unsigned long. On 32-bit architectures, this
> means intermediate calculations in mult_frac() will be bounded to 32 bits.
> 
> If a user supplies large values (e.g., fail_charge_num = 1,000,000 and
> fail_charge_denom = 1,000,000), could the remainder multiplication exceed the
> 32-bit ULONG_MAX limit? This could under-charge the quota for failed regions,
> causing the DAMOS scheme to exceed its configured quota limits.
> 
> Additionally, can setting the failed region charge ratio to 0 (e.g.,
> fail_charge_num = 0) neutralize the DAMON time quota (ms) and cause kdamond to
> hog the CPU?
> 
> If actions consistently fail (e.g., sz_applied == 0), the total_charged_sz
> will remain 0, leading to an estimated throughput of 0. This results in the
> effective size quota (esz) being bounded to min_region_sz.
> 
> Since charged_sz remains 0, the check in damos_quota_is_full():
> 
>     return quota->esz - quota->charged_sz < min_region_sz;
> 
> would evaluate to min_region_sz - 0 < min_region_sz, which is never met.
> Does this cause DAMON to bypass the time limit and process the entire target
> address space without stopping?

Same question was asked to the previous version, and my opinion is also still
same.  I will keep this as is.

> 
> > +}
> > +
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260410142034.83798-4-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260410142034.83798-4-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

