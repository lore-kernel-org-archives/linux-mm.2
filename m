Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87777E8537A
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 15:55:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286996B0005; Fri,  3 Apr 2026 11:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 237756B0089; Fri,  3 Apr 2026 11:55:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174C56B008A; Fri,  3 Apr 2026 11:55:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0AE746B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:55:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55A82BAE26
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 15:55:35 +0000 (UTC)
X-FDA: 84617694630.23.947663B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A0BC840006
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 15:55:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m5wGlcuD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775231733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJC7K6bxB0oKWm16VStvKz69Kihq0uA4Zt3nuTbhQFM=;
	b=LuRlj6Mcd3QfiPHFM7HZwZ+rQQKveeEg5IgeIghDsymoyLVMRe+mshFw/bLWeJsBJijFXZ
	IqVmeg1tvJSv7np0zg6fVA4Q7jzUfURrYiiqaTMZ9cVoi84+dmaaX/7GgZ/0tGIgcPFbv4
	lN6wFh2FyPfsPnwUhH+bQJBsqYeVSBY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775231733; a=rsa-sha256;
	cv=none;
	b=LSA4n6Ka5AthiackefEp+A5RmN30RGzagPtt2Dihv532LTwgAJkEkuHEqaaeOjnGk+Qj09
	r/CTVNIKEgOGz1r+YhN7kjYi0xRVI1p78jvOvZqiDJmEb7quTotuNQ5RlQkzs7hgS+PATu
	71pYMoPpjgHKU/cVsGhrK/ay/OtF2Wg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m5wGlcuD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F605423CA;
	Fri,  3 Apr 2026 15:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D1DC19421;
	Fri,  3 Apr 2026 15:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775231732;
	bh=35zDWu2wx/9bCgEmtX9C9yeqHPmuELOVI34fAibz50w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5wGlcuDkRVhAWhsidqFtu41cD2ec26NkSP9vokXUafjFY+fSNVIdEP+obwOp7mYT
	 7ySHIol3/nFQI4a2lHU6B13jWfivtsmVOMccVxStaTi6OO/F8VnG9s2bSgRHYwE1R4
	 Q82EnuYDmTDOGfD8gN02SrPRCPzAvxFy7Dbjjm8ZYaYaOt+VvY4ZKCGqjcYaqsusVG
	 lHU2txyH4qWsNFROjrtoD7GyxxlAketkaGqDoAttPHFR3XOUR5Fe6NGnmn9WeTZUT0
	 fR/45hOsuzZMMvoRMZqvJA64PYaXnx108TDOGInGrR56u24BaGMc1eN8EkBFRBy0s9
	 IeEjwwX1dZvlQ==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	yanquanmin1@huawei.com
Subject: Re: (sashiko review) [PATCH v3 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Fri,  3 Apr 2026 08:55:29 -0700
Message-ID: <20260403155530.64647-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260403083125.5654-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A0BC840006
X-Stat-Signature: pzpjchp8ekpo7iw1seeuq3se4iukxsji
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775231733-513576
X-HE-Meta: U2FsdGVkX19oV5b7gOIArYaTrhKGKxmTYvo+xrZu7+BlcCAsriEwEVa8KfDGI1MTyFDcnoc1MFOPkPGj+y+aAKcaI5yMVwa4jw9vdqgj14DbKhv0JH6pbxxxQyvT928I8xRRhE4ppcjHF+AVLCF3VnhpOQoxmTNchTRFUnjf37sxXlZuYMd6cXLm4fO/YOKHdrNh1Tj+SiG2AeXU+PAFI3Qh/uLaYrGYtk0+Ouw6UNJMg0E1XTaJW9eq0QFMIWltOSmQFSvQ+IbZTzHXmfPwNPgR40uDDf4OH0d8qs7+gPvDVpH06RxDLij4Mrl8Ki2HdWoIQJ7jLdhxOx7h4FiFWCoZfC9PiEt2vQgGp6NjX0U04hRCSG8H38OffniVQIiGlom37XC6hHnZUlspH+kvQ2GUomjnvli2zAbBC4i8W2+1TK3OSrsEkYYqsbJvT6kgLdMuk6KqtXpkuosdnNVS3+lp6pyiMT/0fB8PHvGEJDjJolVB5bxVVIyfnSAx9dRZMc2XN/SVs8IlxoWMUrWZMeWTeXLScgONiJR8PwHygBlVbLUwRs/nMlE2/gzZnLZCCwe/q6YhROZpMplCkbNGmh/l/buV/sFGktVsL698YSUR2IBqzeLA+ORi0nBgNsE7fP0CL8vKPfdVhnC5G+Ly6mlbAmPFZMUCwHeGWrQldb17FRlPHgm2qBjOflc5Z+nUDg8/MARHzxP8h8kGVUbjynGVzLJz5Kjn3qffi5yiZ2vEuN7O14rOUBwqeXckqBO92XN3cJvctRTwqg3rmEFoXY9n8UpjxkIPv5K+BnNrS8zO8elGt9JT6+PunHrqxfZJc4yf6VR3xkHGpfk4BD5cMzGsgNRuGj+un9CRH9NFeeUugLToo9snKAqjCEb1R8awP80NaYpYZk2QgV2BqguwPipzyREtBdJuq0l4pdxsqYpAsIWTPVpvvtdSRD8q1EcjDK/D1l1zEfTFrmuRM98
 zCY1gMjL
 SQTI0bVclVZGlnf0Pi1x0Ha1PJQctfyDqz8T3IeipK58NFOU25V6EahwuIxtvznF0qGRH51ETXDD2tsKXdv8EVdoQ2pSOXihHZldVZeZUMAV0hlOs7PtOPiAZtqVjGr874KoNyDu/4fSG9OR5zEj/LNQP7eHIx71YMOYyB86MhoBUpb0JG46+9b3gW3k2qoEKxFdIpBtCD9RffzGhGd+tcnimZcNouuhLfnpXaRvewWa3442uismmp6TkaviahzVa2S9ilFfPmohJjPmhaMcI5kTgamq8AZCs3kRjhHvUCnCNy6gIu11ZbpjTenpcfILl0C0j3/1NjnPvgYRpyZcUYzKskrzKFu8w62ds0t7oNL1zlkw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Liew,


I recently learned not everyone is interested [1] in sashiko review.  So when
I sharing sashiko review, I now try to drop recipients who are not necessarily
interested in the review.  My choices at the moment is the author of the patch,
maintainers of the subsystem, and the mailing lists of the subsystem.

So if I was sharing this review, I would dropped stable@ and yanquanmin1@ from
the Cc list.

Please consider doing similar when you share sashiko review.

Everyone including myself is learning how to use sashiko well, so it could be
confusing.  Sorry about that.  I'm planning to make a guideline for sashiko
review usage in DAMON subsystem, and update hkml to embed it, hoping that to
help reducing some of the confusion.

Anyway, seems sashiko found no blockers for this patch.

On Fri,  3 Apr 2026 16:31:25 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260403052837.58063-2-aethernet65535@gmail.com
> # start of sashiko.dev inline review
> commit 525a0116b6d91612e679b30ae84e489a7540edbf
> Author: Liew Rui Yan <aethernet65535@gmail.com>
> 
> mm/damon/lru_sort: validate min_region_size to be power of 2
> 
> This commit adds an early check in damon_lru_sort_apply_parameters() to
> ensure min_region_sz is a power of 2. This prevents kdamond from unexpectedly
> terminating when given an invalid addr_unit.
> 
> > diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> > index 554559d729760..3fd176ef9d9c1 100644
> > --- a/mm/damon/lru_sort.c
> > +++ b/mm/damon/lru_sort.c
> > @@ -294,6 +294,11 @@ static int damon_lru_sort_apply_parameters(void)
> >  	param_ctx->addr_unit = addr_unit;
> >  	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
> >  
> > +	if (!is_power_of_2(param_ctx->min_region_sz)) {
> > +		err = -EINVAL;
> > +		goto out;
> > +	}
> > +
> 
> Instead of adding this early check here, could this be resolved by fixing
> the stateless validation in damon_commit_ctx() directly?
> 
> Looking at damon_commit_ctx(), it currently sets dst->maybe_corrupted = true
> before checking if src->min_region_sz is a power of 2:
> 
> int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
> {
> 	int err;
> 
> 	dst->maybe_corrupted = true;
> 	if (!is_power_of_2(src->min_region_sz))
> 		return -EINVAL;
> ...
> }
> 
> When this validation fails, it leaves the active context marked as corrupted
> without making any state changes, which causes the kdamond thread to terminate
> permanently. Moving the stateless is_power_of_2() check above
> dst->maybe_corrupted = true would resolve the regression for all current and
> future callers without requiring duplicated validation logic at every
> call site.

We discussed this before, and decided not to add the check for now.

Keeping this behavior also makes the expectation for callers simpler:
damon_commit_ctx() failure always means kdamond will be terminated.

> 
> Does this missing validation also affect mm/damon/sysfs.c?
> 
> When a user starts DAMON via state_store() -> damon_sysfs_turn_damon_on(),
> the code calls damon_sysfs_build_ctx(). This calculates min_region_sz and
> then directly calls damon_start(), bypassing damon_commit_ctx() entirely.
> 
> Because this bypasses the is_power_of_2() checks, kdamond can actively run
> with a non-power-of-2 min_region_sz. Core DAMON operations like
> damon_set_regions() use ALIGN() and ALIGN_DOWN() with min_region_sz, which
> perform bitwise masking that requires the alignment parameter to be a
> power of 2.
> 
> Could this allow userspace to trigger incorrect address boundaries, massive
> unsigned underflows, or infinite loops during region splitting?

Good catch, but none of this patch's business.  I will work on this.

> 
> >  	if (!damon_lru_sort_mon_attrs.sample_interval) {
> >  		err = -EINVAL;
> >  		goto out;
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260403052837.58063-2-aethernet65535@gmail.com

[1] https://lore.kernel.org/20260331043441.67196-1-sj@kernel.org


Thanks,
SJ

[...]

