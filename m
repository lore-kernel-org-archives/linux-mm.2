Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84C23F4486A
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 13:44:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB03E6B00AD; Fri, 10 Apr 2026 09:44:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A186B00AF; Fri, 10 Apr 2026 09:44:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29106B00B6; Fri, 10 Apr 2026 09:44:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD34D6B00AD
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:44:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4013114057A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:44:57 +0000 (UTC)
X-FDA: 84642767034.16.8F699A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 76AB01C0002
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:44:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q7q5/Ot/";
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775828695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5B1rJA8qnxpXqxo2SeDhUCIere9ed16bp2lTq6SLHyE=;
	b=G9coK16bCYn6+c5SaLwC1454AMmmpZzijHcKEJRudqoQUNE47TCYRswYo61qZI9rKjURU5
	ybYIX0/SFB5cfnQaY+qU75MNLg9CBpxH1Qk8gT62vD2khVYPuPggS+8SUUpNJksKIkmEvK
	uxc47SKcoLLHJoOz/qUOK1sTa+zg/D0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q7q5/Ot/";
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775828695; a=rsa-sha256;
	cv=none;
	b=Q8FtqXoX/IIGUtv1Hy6OHSyysK/56u90JLhnu6VxwHgUTQMsI/imjFAupoMk7K581atRs7
	lBZK3cavKN4JUaUPludyfn0d+sxWHilKDujMahvBjsMTEa7RDB30pnt1x65j7pkZ0IPtiK
	UGQBBSMFNNS+ovSaueAqMSRZwLeFBv8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BD7E43B03;
	Fri, 10 Apr 2026 13:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7E5C19421;
	Fri, 10 Apr 2026 13:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775828694;
	bh=Yq0pcicllP/Ez2lgctEQ5fQ4x7hGNj+JwjVHDJE+4Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7q5/Ot/qTsyqcIE59d5XHyVIMML/BK/405Fb6R8a4WdqaON5t5jLE8b53er3DUpi
	 44Dqi2d2pfi/Sk905c8rfaCf2olrArSJfAYAU/Ltnm3H1g/e/xukTbvBg3YFn6c9kz
	 utSUvmsRm82mbuNYAdJ7M9Szb1jTKr97PaibSFf1zBkWgs5E3atDOeZpdQhTIOMG7o
	 MZMf4UrLM4uanm0F6addq/ODFaSHmwd9keVP/U23QldWj7f68nf0KTnyGEGLc4VVKw
	 fo7rq123CCCFvSkqHyHcN6i7Z5tl/NbO3MfuO+M/JWWQ1vImKeBrkyezL8V1rzWjY5
	 lmYZw8ErSySxg==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH v4 2/2] mm/damon/reclaim: validate min_region_size to be power of 2
Date: Fri, 10 Apr 2026 06:44:50 -0700
Message-ID: <20260410134451.81846-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410100822.196999-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 76AB01C0002
X-Stat-Signature: mccjxoyw45xtsqymrh1ex6k6qkw59s4a
X-Rspam-User: 
X-HE-Tag: 1775828695-929289
X-HE-Meta: U2FsdGVkX19oZf4AI6hnj/SqgLoOs/at8yQULVX7xfRerMtQAhFJylrAOrd9Zv3UyjipDs1Rtd0JvmVjdghOOOW9HR8SZaInF//JMLMG07Kbw+3AeEcP6zlKlk9woP77uy4oYtj1xqxz0npLwtekPdiaG+5HGlC50JxSpWH5O3W+/YbP54N99g7ReZ4Mp1ySwcjkSLBpfWuT+raP75K26eL1Xc/3fKkOEZ2lgmZCjucEFP+WiVagYIS4p7PqBvMqs8n9hdXYPK4PXmZ7GgufB/a58h4Nii1VNWnQK2Cv8mGTeawUSsHVfJYUG9F5AvG3Ntxpzgamj7hHZ+Ooukw5XL6F9pnuBqRgXJLfNzI0fKoFdDPb9kB761tq1sfMaZW77zw6vPJLQb8ev6VAcx/7ltqiM8gjqIr/HrEXFIboqWvb02M+Z7KVP+GvqnV6DVowS6/Y+OppqlsV57gi5N4LGpIRrWLjrEDuOLVCiMZxTWFkguh8M+VtuLKoVNMi2A9rDRlTMTGMFzcIsAiSf4FT8sVTGhSxonmLKY8Q7HWom+1hBF+U2wR4Z5EpkyiM9z8N2cxWs0BJAOWGZJDfKu66cTw4Yz/LmrIZyutPwzvTtmkA9evhO7oRYsX37tE/EOGqfX7WHWI3s7vIp4aLMM5J2nx6VOLtCNdFicPsvkqAIUIAVtbiboxNQIEx13aiEz2ELg2hNXBFqdvfurE3oOhEjv8VVXqaKvdudUJXfaNz4tACoIQsuphVQUw3IgvippywT/rtQaAshu/l7HzWUuFQR8HYSrxIY5jlCYScQ3OZIMtEx7YG06f+m5qHZJ5jepzFWJElcus0l9FpHxu1O5dew71jkqQ5F2KV3rPxAPR64HCOUGc9VtcgQwdVpKdbvEpbtzkEPcaX4RnPKSYnyC/5i+DtyNhTot9mjuDiUN9HD6Tv9pXj6pmYsI56rUU6SzsPDnR+nk+kazKeyUSXq5p
 F8mphzs2
 Db3m/oNEUbwZlxvfS6JjYgiQyeYAjz7tlRtQ2bTQFntk4GNo0cvnG1lO8H6hUpJyR+nmD+CqFuHbolR4KuBXaxffQ8t0smtGPk3qkWlnVWdTd1HwC6+u9hgOvcxuLOOaV6YfZgMr6rq5G6CkPTJmAEd4VNZ7BacoNsZA7asnqG2vHavvJv8FXn1ZXzn5xfUd8rdomlpsGLEOKj7a64GpdM6LuuSBrL9cVkBNB79QD0xRiCAtfk94M1pYaqi+jZiG/k8ghXRpOCyGApcugpK1tdUQ2JdQWSRnvmU7zRBGvM2ZrXtcM1P07IYnRaCS/AyVzxT4OpDXK8Y0/b/EdcPF8UBjo91/o3MYucrxBfgH1d3ARTO3jDEBF2jd2IWJBh9Wt33Pt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 18:08:22 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Sashiko found some issues.
> 
> Forwarding sashiko review in a reply format with my inline
> comments below, for details of my view and doing discussions
> via mails if needed.
> 
> > # review url: https://sashiko.dev/#/patchset/20260410044259.95877-3-aethernet65535@gmail.com
> > # start of sashiko.dev inline review
> > commit 7a816b41f4b321b6a513227bef0e50f3bc1e86f1
> > Author: Liew Rui Yan <aethernet65535@gmail.com>
> > 
> > mm/damon/reclaim: validate min_region_size to be power of 2
> > 
> > This commit adds an early validation in damon_reclaim_apply_parameters() to
> > check if min_region_sz is a power of 2. It attempts to prevent kdamond from
> > terminating unexpectedly by catching invalid values before they reach
> > damon_commit_ctx().
> > 
> > > diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> > > index 86da147786583..2747eef5919d1 100644
> > > --- a/mm/damon/reclaim.c
> > > +++ b/mm/damon/reclaim.c
> > > @@ -204,6 +204,11 @@ static int damon_reclaim_apply_parameters(void)
> > >  	param_ctx->addr_unit = addr_unit;
> > >  	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
> > 
> > Is it possible for a concurrent sysfs write to change addr_unit between these
> > two reads, allowing an invalid value to bypass the new validation?
> > 
> > The global variable addr_unit is read twice without READ_ONCE(), once to set
> > param_ctx->addr_unit, and again to calculate param_ctx->min_region_sz.
> > 
> > If addr_unit is changed from a non-power-of-2 to a power-of-2 between the two
> > reads, the validation below might succeed using the new value, while the
> > invalid addr_unit is committed to the active context.
> 
> I believe this is possible, because the current call to
> damon_reclaim_apply_parameters() is asynchronous and does not hold the
> 'kernel_param_lock' during execution, so this situation should be
> possible.
> 
> However, I'm still unsure whether your suggested changes should be
> included in this patch.

We already addressed this with by defining it as an expected behavior that the
user should avoid.  And the queued patch [2] from Liew will make commits
synchronous and fix this issue together for the mainline.  Let me know if I'm
missing something.

> 
> > 
> > > +	if (!is_power_of_2(param_ctx->min_region_sz)) {
> > > +		err = -EINVAL;
> > > +		goto out;
> > > +	}
> > > +
> > 
> > Does this early check mask a structural issue in the core API?
> > 
> > Looking at damon_commit_ctx() in mm/damon/core.c:
> > 
> > int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
> > {
> >         ...
> >         dst->maybe_corrupted = true;
> >         if (!is_power_of_2(src->min_region_sz))
> >                 return -EINVAL;
> >         ...
> > 
> > If a different caller passes an invalid min_region_sz, it will still trigger
> > this same trap.
> > 
> > Could the root cause be addressed by moving the maybe_corrupted flag update
> > below the validation checks inside damon_commit_ctx()?
> > 
> > Are there other ways damon_commit_ctx() could leave the context corrupted?
> > 
> > If a user dynamically enables features that require memory allocation,
> > damon_commit_ctx() calls damon_commit_schemes() which attempts to allocate
> > memory via damos_commit_quota_goals().
> > 
> > If this allocation fails with -ENOMEM, it returns an error but leaves
> > dst->maybe_corrupted = true on the active context, permanently terminating
> > kdamond.
> > 
> 
> I discussed this in my previous reply. But I realized there might have
> been some misundertanding in my previous explanation. What I wanted to
> say is that there might indeed be some issues with 'maybe_corrupted' in
> damon_commit_ctx() that need adjustment, but that's not within the scope
> of this patch.

I agree.

> 
> > Can a concurrent sysfs write cause a divide-by-zero panic in this same
> > function?
> > 
> > Looking further down in damon_reclaim_apply_parameters():
> > 
> >         if (quota_mem_pressure_us) {
> >                 goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US,
> >                                 quota_mem_pressure_us);
> > 
> > The global module parameter quota_mem_pressure_us is read twice without
> > READ_ONCE().
> > 
> > If a concurrent write changes its value to 0 immediately after the if
> > condition passes, a quota goal with a target_value of 0 is added.
> > 
> > When DAMON evaluates the quota score in damos_quota_score(), it uses the
> > macro mult_frac(goal->current_value, 10000, goal->target_value). Dividing
> > by a goal->target_value of 0 will cause a kernel panic.
> 
> I tried to reproduce this issue, but without success. 
> 
> However, based on the code, I believe the problem exists because I
> didn't find any checks preventing 'goal->target_value=0'. Please let me
> know if I've missed anything.

As I mentioned above, it is unallowed user inputs [1], and Liew's queued patch
[2] will fix this for mainline.

> 
> > 
> > A similar sequence exists for quota_autotune_feedback.
> > 
> > >  	if (!damon_reclaim_mon_attrs.aggr_interval) {
> > >  		err = -EINVAL;
> > >  		goto out;
> > >  	}
> > 
> > 
> > # end of sashiko.dev inline review
> > # review url: https://sashiko.dev/#/patchset/20260410044259.95877-3-aethernet65535@gmail.com
> 
> # hkml [1] generated a draft of this mail.  You can regenerate
> # this using below command:
> #
> #     hkml patch sashiko_dev --for_forwarding \
> #             20260410044259.95877-3-aethernet65535@gmail.com
> #
> # [1] https://github.com/sjp38/hackermail
> 
> Best regards,
> Rui Yan

[1] https://lkml.kernel.org/r/20260329153052.46657-2-sj@kernel.org
[2] https://lore.kernel.org/20260402155733.77050-4-sj@kernel.org


Thanks,
SJ

