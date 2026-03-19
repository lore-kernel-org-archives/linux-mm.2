Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42CA71088E5C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 01:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FDEF6B0398; Wed, 18 Mar 2026 21:23:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987EF6B039A; Wed, 18 Mar 2026 21:23:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84FBE6B039B; Wed, 18 Mar 2026 21:23:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 70B056B0398
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:23:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0211DB79D4
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:23:46 +0000 (UTC)
X-FDA: 84561065694.06.30FA692
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5B8151C0014
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:23:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sAPuipFm;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773883425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4i70lYE3ikT4bXpejDfgyhVGs8FhJBQxEetpbIWUIXg=;
	b=LJlQm6VjvLEq4uuZ5hmbO5YMCFIXDktdOxysRL2RswHGovNpK39oDokxiwmXFaeFHKUKxd
	q133mZo0COdMCLQ8+uTFEGm+p8z8SqGnTcWxfognE/GXEZ5nAuQSPunt/wMTbYmTbQEDSX
	7r0r/dibgkTsUgpPylzbcwqgtsUphVc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sAPuipFm;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773883425; a=rsa-sha256;
	cv=none;
	b=V4Q+B7IBxc6cGYWdfiAL8+Ezyd//Y1XDkkI9e9zih2Ms7kbQbsWg75sw4+M0ZffPavh3Lr
	YAp0EbiIoG2x7jaomUuTQcI+mquHZB0iApoM7H3qTIDXhi+U593ZemeZ5urk3paUyU4IYJ
	naBhoOWwIICWj+UU3Q6Ai9qG87kElP8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A04FA6011F;
	Thu, 19 Mar 2026 01:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378E1C19421;
	Thu, 19 Mar 2026 01:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773883424;
	bh=/3AxX6eVbCyH06Y2eez24hjlaPrieJrSqToGepAelaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAPuipFmfUEcAW7WnCMY3N6M4TDhtF3TymnzjXk/rla5o2MsX7IL2lqcXX6jJ8VEd
	 /pURuC7PZKRb+F7HL4g0B6lG5N7CBdBfz4K8Jay0Onx2pyKE4rTqYFQ0I1jadKaQzp
	 Y7lIKnql0orZ6fl4UDGmJnI9a+JzzLY6L86lEklxgmDTKEmfDCJSVi++aR8vtzZ93D
	 8rMlZ5YhSaxMNmYtFNmp4V89oaAMN0P8GnWIHTUkgVl8qVGWyqntr8BvSmHJYvqS4r
	 /semblQTA00WzDuRfTC+b+aSG2brsc06AA3t9fH8N8YR49ZU+9ktS8J9xsc7AQlgTl
	 O7tPyceFmgeNg==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [Question] mm/damon: min_nr_regions constraint and inconsistent error handling
Date: Wed, 18 Mar 2026 18:23:36 -0700
Message-ID: <20260319012337.96726-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260318153731.97470-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4pw4d4q85wg6dt5kgrkdbizahcbm7c1p
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B8151C0014
X-HE-Tag: 1773883425-529584
X-HE-Meta: U2FsdGVkX1+5zravIDhFPlmBZI66ybhNz+pVswXjT3D/evVzPGfAOp+LjLfU0Xivm+30IbVW93l6kFb6EBwqRYfG6SAtK9b55EUbBRjMMl5j2xvvyHghNQ0RAzttQGKrkINPfVkD61PpgDoTBajXkJV0V1GEUn3p6z0ZxqDWDKh4Ttw9zp8rpey9yosJSaT/+Pm1fAGzFgdZZbD4vKFuN1+wEqysqjD0xINGjtnxxvnoc8968iSKCz/5a16aKdM2TUD8xYNQH8qj31imTfbOQV/QJYhDJYQua7GUUhSXEOEAr9SdJoxYinJxeWi5matFdJKm1IvfTRmwE+6sWQkDDwGJSPCJsMeKu4LWpeX56KlV5i96pXJCBwECNB9yuozDlCoHlEKu5rcF3FMxcrQ4+GkddM9Ewj9Sq5qGbH1BzQWpuZ0BcwWbA7SAiAeo8q/BTeUwgVtSw4u4+C4IlV3r2D9X3aZ9Gr6dyAWcOV6+Me5CpdRlhnqfMJMeBsJgg95aHtsoPW0PJ2gJQE1ypiae2sDYPmLHGEckwaLmobOgcR28Q020N4Czhr85yZCZBN1mEvNp0m/91wYCRq4msD1l3k7CKBojggdO9iDWNgu3Lwxpr/2WwXC4a5GoiJILeoFcquRxteZuYx4NJleJNlhEEVAXwGtIaOIvIzE4o6Ek6kzQE1YA1r5C0um55h4BokWtrxBGf0uzlLzFfCL9PRPve/95WcLy2eB6E9lQKOOqGBDfzLInSSQ/c7R+HPq3+Xef5ZQm5ugu7KSizVSUMOWcZq43qf6jvELob6oGAE+2ZBdVl1ZUe87KW7egI1MwMOoWgInllYMnMGGfzLfnNXoop4HdQMt++Ci4+rxyhs26GsTrPWL/vGy8llkFf3FYHXMMOSqbTVwb2Fch5whFC96GeVlmoIYnwTI9BJKeLb4woOV1SRpwuV6aWbK+pUJmWk4NfpRs13qzh7rN2zrZHlA
 Uc4pZvEY
 nTpEcFftcYOUybnsYk642vDaYl+LSFx+6ndv1sF0nPR7nLGlsnuUnW8fWDJRu9xs4y9syge+dFKxQWLVG2T9KUs4QWqcC8qol/0COc7eXQfWDvYLAx7blY/fuz8rrXtjScIJC1nIVH40DdgcpLwxLxNjiDwRLY7CVOYtxTYmudqiRoHpADu1BBxCKC8WNz3e3fzF0/V+IQWZJHw9jv6/UN8hwWKISMGJd5P5UkaXWd3DStLGuo7JYdqG4I1EopNdOta3CGrmeI+RjdYAeQXFKgE/0ClSHxTD4z52v0n5UQ/0SQAek8+meGd63u8DUpyAKaD/1V+dUFgu3ONcAzig3tNsYFPk11TY8PaBJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liew,

On Wed, 18 Mar 2026 23:37:31 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> TL;DR
> =====
> 1. Why does DAMON require min_nr_regions >= 3? Is there a technical
>    rationale?
> 2. Could we improve error reporting when sysfs parameter validation
>    fails? Or document it?
> 3. [Bug?] DAMON_LRU_SORT doesn't disable itself when commit_inputs fails,
>    contrary to documentation.

Thank you for nice questions, I will reply below in line.

> 
> Details below. Happy to help with patches if helpful.
> 
> Details
> =======
> 
> 1. Error feedback for min_nr_regions validation
> -----------------------------------------------
> 
> While configuring DAMON_LRU_SORT via sysfs, I noticed that setting
> 'min_nr_regions' to a value < 3 (e.g., 1) succeeds at write time, but
> the error only appears later when writing 'Y' to the 'enabled' file,
> which returns -EINVAL.
> 
> Since multiple parameters (intervals, watermarks, etc.) are often
> configured together, a generic -EINVAL at enablement makes it difficult
> to identify which specific parameter violated constraints.
> 
> Code reference: mm/damon/core.c:damon_set_attrs()
> 
>     if (attrs->min_nr_regions < 3)
>         return -EINVAL;
> 
> Question:
> 1. What is the design rationale for requiring min_nr_regions >= 3? (eg.,
>    algorithmic requirements, sampling accuracy, etc.)

The initial version of DAMON was supporting only 'vaddr' operation set.  And
'vaddr' is designed to have at least three regions, for the two large unmapped
areas on normal virtual address spaces.  Hence we enforced min_nr_regions to be
three or larger.

There is no real reason to keep it for 'fvaddr' and 'paddr'.  Maybe we can lift
the restriction for 'fvaddr' and 'paddr' operation sets.  But, we found no real
reason to lift it, either.  As a result, the restriction is still there.  If
you find a reason to lift the restriction, please feel free to let me know, or
send patches for that.

The VMA-based target address range construction desgin doc [1] should explain
more details about the two large unmapped areas.  Please feel free to ask more
clarifications if it doesn't give you enough details.

> 2. Would it be acceptable to improve user feedback? For example:
>    - Document this lower bound explicitly in
>      Documentation/admin-guide/mm/damon/lru_sort.rst

Yes, I think this is a nice idea.  Maybe adding a comment on damon_set_attrs(),
or additional sentences to 'Monitoring' section of design.rst [2] would be
appropriate.

>    - Add pr_warn()/pr_debug() in damon_set_attrs() to log which
>      parameter failed validation and why

I'd like to be cautious about adding logging, as it might be a spam.  I'd
prefer making it documented well.  Then, users could find what is wrong.

> 
> I believe clearer errors or document would make DAMON tuning more
> intuitive for sysadmins and developers.

I agree, the documentation should be helpful.

> 
> ---
> 
> 2. Potential inconsistency in DAMON_LRU_SORT error handling
> -----------------------------------------------------------
> 
> The documentation [1] states:
> > "If invalid parameters are found while the re-reading, DAMON_LRU_SORT
>  will be disabled."
> 
> However, testing on v7.0-rc4 shows that when commit_inputs fails (e.g.,
> due to min_nr_regions < 3):
> - The 'enabled' parameter remains 'Y'
> - The kdamond thread continues running
> 
> This behavior may confuse users who expect the module to safely disable
> itself upon configuration errors. Should commit_inputs failures trigger
> an explicit disable (enabled=N)?

Nice finding!  In short, it is an intended behavior, but the document is
outdated.

In the past, the documentation was correct.  When a wrong input is committed,
DAMON_LRU_SORT was stopped.  That's because it was using damon_callback, which
is now removed [3].  The callback was executed inside DAMON main loop, and when
the callback returns an error, the loop was broken.  As a result, DAMON
execution was stopped.  DAMON_LRU_SORT was setting the parameter inside the
callback, and was returning an error when the parameter is invalid.  Hence the
behavior was documented as you noticed.

Commit a30969436428 ("mm/damon/lru_sort: use damon_commit_ctx()") changed
the behavior.  It changed DAMON_LRU_SORT to use damon_call() instead of
damon_callback.  Because damon_call()'s callback function failure doesn't stop
DAMON, the current behavior is made.

Still, committing wrong DAMON_LRU_SORT parameters returns an error to the user.
Hence user can notify it was failed.  The invalid parameters are not really be
committed to DAMON, so DAMON continues running with valid parameters.  So this
is technically speaking a visible user behavior change.  But we believed it is
ok because we were unable to expect users who depend on the old behavior.  I
think I discussed this somewhere, but I cannot find the link right now...

> 
> Reproduction steps:
> -------------------
> VM: virtme-ng 1.40 (x86_64)
> Kernel: v7.0-rc4
> 
>     cd /sys/module/damon_lru_sort/parameters
>     cat enabled 
>     N
> 
>     # Initial setup - works fine
>     echo 65535 > max_nr_regions 
>     echo 3 > min_nr_regions 
>     echo Y > enabled 
>     cat kdamond_pid 
>     91
> 
>     # Observed behavior:
>     echo 1 > min_nr_regions 
>     echo Y > commit_inputs 

I believe the above command should returned an error.  If not, please let me
know.

>     cat kdamond_pid 
>     91
>     cat enabled 
>     Y
> 
>     # [kdamond.0] still alive
>     ps aux | rg "kdamond"
>     root        91  0.0  0.0      0     0 ?        I    22:03   0:00 [kdamond.0]
> 
> If this is confirmed as unintended behavior, I'd be glad to help
> investigate and submit a fix.

So, this is an intended behavior.  But the document is outdated.  It would be
nice if you could send a patch for fixing the document.

Also, if you know users who depend on the old behavior and therefore hoping the
old behavior back, please let me know.

> 
> ---
> 
> Thanks for your time reviewing this!

Thank you for sharing your findings and questions!

> 
> Best regards,
> Rui Yan
> 
> [1] https://docs.kernel.org/admin-guide/mm/damon/lru_sort.html
> 
> [...]

[1] https://docs.kernel.org/mm/damon/design.html#vma-based-target-address-range-construction
[2] https://docs.kernel.org/mm/damon/design.html#monitoring
[3] commit 5add26c0a186 ("mm/damon/core: remove damon_callback")


Thanks,
SJ

