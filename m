Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9D99CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 03:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C68C58E008A; Mon, 25 Aug 2025 23:06:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18C38E0038; Mon, 25 Aug 2025 23:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0AA8E008A; Mon, 25 Aug 2025 23:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 993138E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 23:06:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1CEFC1DE168
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:06:14 +0000 (UTC)
X-FDA: 83817419868.19.FEFA4F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8A9FA80008
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:06:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u1KYSH54;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756177572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u//TJFO04Zfapo+eEPrU9YifMzUhV/eh39OW/BvrF8A=;
	b=X5Cg0Tu/BJhYro8yY12XsPkWcIgJdBHGAnKoOlhBIT7xAiUdwnGrR+AmkECrQqQMBeH93h
	5bxTvFsVBKn5XLUR7TN1NVvHQUg3HCKYoOJreTkXqI3Qkp6DGUT5FntlEnSwqrdgCIHGTy
	z0T/AzFdr573zsbtz2vTO0qVFr1CptU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756177572; a=rsa-sha256;
	cv=none;
	b=sSNt08IGc2F/+WyfJGJh3LlBgINVfPyPhDvmzsC6nL8oLHsYuR8oRAd6eknfERzrdc7kA4
	8gVjJXqgpy2fI+xD5QG0qU+6bJMTz1s55DqM3NAm+RrJk6hf/J16VqtRiXeu3lU4kNqJDA
	C1ejt97Dui5Rkqac/RKJUxJ4qLgYhH0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u1KYSH54;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B6DE2601EC;
	Tue, 26 Aug 2025 03:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE7FC4CEF1;
	Tue, 26 Aug 2025 03:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756177571;
	bh=3e4hvzpDH6EODnkYI8p9FQ9wL3jJv36ugO7+Ag6HcVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1KYSH54VdstYOlsRJ7bZRGckzrCWNXRvBKWbeYaET9GZnEar0BMrUxNQQv2UfKp0
	 UlH2DKwBqde+W/Y8njuZOdU/vZD+3O83g98NE/xqceYm6q0SR2dwe1Swl+fODTkJ7P
	 Pgc4mnskWH9RAGbDUnJatiXnHke7v8Is3VnEMpZ0HLzShRI0G9APMG3D6eBsZJ+jmi
	 2LUu8H3MGvcjxuspcag4ORR2lp9eeL+n129vez9wiFcPUyCSXVjRgBQ4cNsxJSal13
	 oekjc7lenkJOnt7w6hModY1ZLC2t+a4HBMkYNtZ1NFagqNQ1xlAYtgmRteGO/ul4fh
	 qorS4x0wx4wXA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com,
	kernel-team@meta.com
Subject: Re: [PATCH v2 04/11] mm/damon/paddr: support addr_unit for DAMOS_LRU_[DE]PRIO
Date: Mon, 25 Aug 2025 20:06:08 -0700
Message-Id: <20250826030608.44305-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250825151353.36392-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8A9FA80008
X-Stat-Signature: dn6rnn53em4c88c7k5jnf8gmzm6kscqe
X-HE-Tag: 1756177572-273673
X-HE-Meta: U2FsdGVkX1/n6cKMuvVpE3uDPUA766Y/gbHBjZQXHH1W7P6fe2qButiMw8jU8e3DzDD/rOl4gLp50yQBhKyW/vmdoah6BmGh81ZW8aiDEcFaQLqXJL7E7ONCuW2HRS4opR/142U2lkuEjv2uajQ2qP0UUffYTQt9EPyuo1U9cVSybO7Kdi/P5NIPuyRQI3oqHUtz1tjzMDXudOWQgr0FnRFdsmwAS2q8Tq69Le0yyaJd7pjhWWnl1KnIvUlUXz3Wc1OIX60LtG9qx/9jRrNLmRnGSN9RHLez4vKpl2DlDkxwSBClFJ5O8zDvLmQchiUDE9SHbYeEEl0jExMJMSIghJDZXVXx5mxABmTZVsYJ133GH60YIsaEs3Jh4c7BURXumaoL34nYLW/yr/+JtgRG9lZ2UHv1e9lLp/xi6SA4ApxjqeUycQm3LyIRi5UtflNamPYx3fDHLoI+cHfRSCZzkcMzTZEFvYBLNlz7aFG5Ns6HMTMnDQh4XVEmiZH/BsF38+pwsi26/DLstRLHE4wY08fyHoyhAV4Jg4W/9IAS2Tu+Lfn/aiPms6m8dqL2m3Uq2D4fDz21POIC25m27rN0GGNhpFAoZDB7n+PoFY4BGn9UFyB2VyVuIK4jhpL14FB/XNZ81cqGHPtYhlC81wSA2gSh0njeAVVFku952meNVk7bmrWmbG1Nf9RXQiCTVApsoGpcx95k6rKmu6KvZmr7QmAF/rLcCJpH/8oQ/3Y8EtEKzdc5kR1hNTlazTMdKCUouHXRdwV//eQrmuPjV6/4ZL+7vHCRPVqD/UgunLM0+onTwYhDe1UymHfst68Fb+Sj/8rxVXbDK787fGCR5+bHytb/zPbZ8lcpw/z3Uby3uCo3Fy4J+PagptlY6GREIWnzt5pS/2G33K2zaF7AmtNdAEBafc243wuCi3YQArM0DDXnN0DVSu2TJVi3Td7rY6soUUjjZ321YiyPs+ELlNM
 OtDqS/KB
 mwzRAgn2hyhGc0UOvoqHK18CbG79+j8tjKSZU8xLqRZHLlwBJ02oAaYegUyMTVIV/79Q+bwEVR61jWdMw4TYJhbrBQTVSkQk0jDVJGGkHtzLaFqTTPGnqxXu8W/tay2M1c2AVFEcjjO2p6Mkj6ErCquOY4sG4P45EWBcVGzVR9Oi98QBO0EyEd/wdOrHZBTjlFgwYKjME+F4H9aNTofB3LUkFSCSrbunpNGXyquDtNPPxWGR1UGWEvUFkMhVsvOp6x7C19U3hrezoeObNEGKfbj2851bPmJ//a8vIHtyidOTdfO6xLOGe9nNuIwMSnyn8QuOn3RjHZKy1kM7b4xX1oPGO9AJPydnQXaHEJSBR72HL4GgLvlfHtkQ+zZYkHGfqkepd+tVaWavin47G52Y9ahJn1r1JfuEbWDbSuEwgpTI/8RSl7Xba5bfkh/SAO7PCiiMRxIzG9+zsleg56afmnmCZdb38HzUmto6tnTXK/9a00D7AA7S+5Hztdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 Aug 2025 08:13:53 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Fri, 22 Aug 2025 17:34:12 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> 
> > From: SeongJae Park <sj@kernel.org>
> > 
> > Add support of addr_unit for DAMOS_LRU_PRIO and DAMOS_LRU_DEPRIO action
> > handling from the DAMOS operation implementation for the physical
> > address space.
> [...]
> > -	return applied * PAGE_SIZE;
> > +	return applied * PAGE_SIZE / addr_unit;
> >  }
> 
> This can cause __udivdi3 linking issue similar to the report [1] from kernel
> test robot.  Andrew, could you please add below attaching fixup?
> 
> [1] https://lore.kernel.org/oe-kbuild-all/202508241831.EKwdwXZL-lkp@intel.com/

Hi Andrew, I posted three fixups for the __udivdi3 issue, and I see you picked
two of those in mm tree.  But this one is not yet picked.  Could you please
also add this fixup to mm tree?


Thanks,
SJ

> 
> 
> Thanks,
> SJ
> 
> [...]
> 
> ==== Attachment 0 (0002-mm-damon-paddr-use-do_div-on-i386-for-damon_pa_de_ac.patch) ====
> From hackermail Thu Jan  1 00:00:00 1970
> From: SeongJae Park <sj@kernel.org>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: damon@lists.linux.dev
> Cc: kernel-team@meta.com
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Date: Mon, 25 Aug 2025 07:45:24 -0700
> Subject: [PATCH 2/3] mm/damon/paddr: use do_div() on i386 for
>          damon_pa_de_activate() return value
> 
> Otherwise, __udivdi3 linking issue happens on certain configs.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/paddr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 09c87583af6c..6fb92ecc513d 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -236,7 +236,7 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
>  		folio_put(folio);
>  	}
>  	s->last_applied = folio;
> -	return applied * PAGE_SIZE / addr_unit;
> +	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
>  }
>  
>  static unsigned long damon_pa_mark_accessed(struct damon_region *r,
> -- 
> 2.39.5

