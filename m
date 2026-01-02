Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E641FA3741
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 14:39:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02AE6B0088; Fri,  2 Jan 2026 09:39:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1046B0089; Fri,  2 Jan 2026 09:39:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BCCF6B008A; Fri,  2 Jan 2026 09:39:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5806B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 09:39:56 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3808D1A0390
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 14:39:56 +0000 (UTC)
X-FDA: 84287283192.24.0B9398B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B0B2820003
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 14:39:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RXgNzwE1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767364794; a=rsa-sha256;
	cv=none;
	b=GYSGpxBSaoHsYTjCYxJiigLgWtXR887XFfYewrAvAzw2wGHDdvsxN96ZRUksWh8ahS8pVd
	t6TEa97gcx2WqUlHNVEyI1uWFF0S0YD4AQrJRl4NEfU353UiJAzsqa+R7oqv2OGCy8fbcC
	0fTVdDTFznErd27Y6mS/3yLvP814R3A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RXgNzwE1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767364794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZ7bttNFq8mEFSC+woqAoH+Q6JWLvlflVgFuk+TD6cI=;
	b=GEzoU6dULewvO36KFiTZvJWyYFOXxE6XAP+hmvXLyc9fPPQa/adZx/7gP74NlwaALNRrTM
	IZWbXR5MOawHYCXI5YULh0M76gMi7IaPgLIAUFauLb7Ol02wQ5n9adRpwAEV1SEWzIVX4d
	3tSH4wj5Zwp/ttTrzbALfpWQiArlCXQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 19D9C60017;
	Fri,  2 Jan 2026 14:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388D9C116B1;
	Fri,  2 Jan 2026 14:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767364793;
	bh=NFZVoW1OohheL/BZDD6iCVBR2TX6b8zaD6eMYXzwGC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXgNzwE1SI2gpupR21FN6yuKt9r1m+RG+oRnu4dmMGaqYzlROAwmSbKIxdJyAAY8y
	 A2qostlhny+u7wwk9+qnCK+iHV6Rg8x6+vkCkqvPsZRE5WGcs7IvAuD5aNxb9+aKsU
	 tja4L1XojxOxK6owOsA+H09OrqC91aszlbF2o8Zuog9sxHD4Ywd3pkvuMAwJQb3wKC
	 nvKbyPM13uaCtR4yArs7ZCrEx1iCFkdIwrjaRPyordGYipEg/86e5AVKfFq5eRy5A0
	 FTCyCwWMNQUSUQCHwYB3pVrP/KA+5xQXztKFWvrX9wF9inBePMp1gFnnpCQM/1tvMn
	 qrSiKGdQVvMlg==
From: SeongJae Park <sj@kernel.org>
To: Pavel Butsykin <pbutsykin@cloudlinux.com>
Cc: SeongJae Park <sj@kernel.org>,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/zswap: fix error pointer free in zswap_cpu_comp_prepare()
Date: Fri,  2 Jan 2026 06:39:44 -0800
Message-ID: <20260102143945.52356-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <baefc4db-2e2f-4b20-b44c-eeaadfaa1c1e@cloudlinux.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B0B2820003
X-Rspamd-Server: rspam03
X-Stat-Signature: 47a1uixcuq1q658utjsdsty1mdinag6h
X-Rspam-User: 
X-HE-Tag: 1767364794-536232
X-HE-Meta: U2FsdGVkX1/YYx4YWpBmkMrkE5kNIa9oymUi6bihcY9io4dPYltblrfOWARuDuECsSQOy6Ax+/XfAzlvK0ciiGMLOFhyZnThZpD2Rp9h4W9/S9z3ce4NMPhwJGc9wa6UfhPJ2f9fK/dY2hvDY31Db5CpWkTeOKFOdQqbRzPzFMsuR8voDYcw+n7LEWyAw9tG6sss1HCG5G6SRFu9jWX1Q+kS27IEtmu/yNEjAn3OdiD4gNFKUJbF9F/4lsM2fSRrA+oeVQepzLBYzrBWt+/8cwnh9bQmNGTcH0zukD4bUBdaH3MyQtDDTdYsDyTVC0vfFWdODN4nOmFYZ0r0TzQqUKYHNzP7HDQFsnPMnxFIvF1r2YjNSo50gfLeHOOzGsaYo/Zw/OZ8HhZ9QEqWyPRNRlJ4KI4jLAxB+/5r3MYlkUp51vRCCXlI29rIDsElXR9AdFyVc7t84fQpgoGI2cj2QxDobkMu7mIATX48JfeurLdHSnp6XiHckSPUMPMZSWVFsl2woKNhLTOMhm6mim4XD2PeXX+nhG5IethsXQaU5qYJ5UDFMdNdzm0kcS8N6OvoEhtxcVECW0iRl3TaXj8F2qX1xf73AGNoqPbfzghN2Rx5ORQMJh4iF7esAOJAdB1Yl+Ow/+gfGWGTOHbfnL62S6CKcSJzvpg6wrkrPoG0EZ1yRutjylhDNKFbb4fYAprNSMyXJa506rr6ly9yLsjwfYeMHj3WH/4duu/XbigD9vU73iRz9RHMpH80Xufvxdr8HHjZlzs4RnEr9q16+AnB6DwQNpnkdOoaJbiRf3Qexh4phwhMOqkdX18+nWo9weR4vu2qrSbfTWb662dtPem5M24fxTgJinTZAfsTzry0SHTub8e6aA9iP1kX7P7VTTusRWYmRn3lcFnfh9tzfjVOZAG0OH1dsKM/yBXtirj8pAtR+UcessemCJLdyfOI/RwXYktGBwG/M21sco3+r7W
 wzI4yWLP
 EZOo0MzLqaLT3HTHuvQHdOBZi75DxGwPVkAu7Zm30+IUH1cg/FY83a0/ClFcbHiZ7e/4R8O8HhW9WZOCp/hGpDthcuRo0L2wsDModdQlBEyhxcBt864iRg6tZtKaVRXPjR21f7TTF9bENxgsZZi6s74F7nn6uhxHmNrGV4osMFHXToZ3uXOXylLichanueEUcfmz/WR7C9V8tlKHdL9vKhg3WePpgktWOBxbapg4/uoi5RBkxIBmYZqdjfBVO07/SWWQRxEFrovj4fo81d0kmMYtoaeuF5Qwkh/Xrr9yS5HQvd0X//zqS9WCESY8OsVZa3kIhtqfz0yDwhAQ2FVeOnyiVgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2 Jan 2026 10:51:01 +0400 Pavel Butsykin <pbutsykin@cloudlinux.com> wrote:

> On 1/1/26 04:32, SeongJae Park wrote:
> > On Wed, 31 Dec 2025 11:46:38 +0400 Pavel Butsykin <pbutsykin@cloudlinux.com> wrote:
> > 
> >> crypto_alloc_acomp_node() may return ERR_PTR(), but the fail path checks
> >> only for NULL and can pass an error pointer to crypto_free_acomp().
> >> Use IS_ERR_OR_NULL() to only free valid acomp instances.
> >>
> >> Fixes: 779b9955f643 ("mm: zswap: move allocations during CPU init outside the lock")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Pavel Butsykin <pbutsykin@cloudlinux.com>
> >> ---
> >>   mm/zswap.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/mm/zswap.c b/mm/zswap.c
> >> index 5d0f8b13a958..ac9b7a60736b 100644
> >> --- a/mm/zswap.c
> >> +++ b/mm/zswap.c
> >> @@ -787,7 +787,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
> >>   	return 0;
> >>   
> >>   fail:
> >> -	if (acomp)
> >> +	if (!IS_ERR_OR_NULL(acomp))
> >>   		crypto_free_acomp(acomp);
> >>   	kfree(buffer);
> >>   	return ret;
> > 
> > I understand you are keeping NULL case to keep the old behavior.  But, seems
> > the case cannot happen to me for following reasons.
> > 
> > First of all, the old NULL check was only for crypto_alloc_acomp_node()
> > failure.  But crypto_alloc_acomp_node() seems not returning NULL, to by breif
> > look of the code.  And the failure check of crypto_alloc_acomp_node() is
> > actually doing only IS_ERR() check.
> > 
> > So, it seems IS_ERR() here is enough.  Or, if I missed a case that
> > crypto_alloc_acomp_node() returns NULL, the above crypto_alloc_acomp_node()
> > failure check should be updated to use IS_ERR_OR_NULL()?
> > 
> 
> We have 'goto fail;' right before crypto_alloc_acomp_node() for the case 
> where kmalloc_node fails to allocate memory. In that case, 'acomp' will 
> still be initialized to NULL.

Ah, you are right.  Thank you for fixing this.  Please feel free to add

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

