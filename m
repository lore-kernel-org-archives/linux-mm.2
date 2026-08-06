Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B85DBC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 13:59:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA33D6B0093; Thu,  6 Aug 2026 09:59:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A666B0095; Thu,  6 Aug 2026 09:59:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7536B0096; Thu,  6 Aug 2026 09:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A6756B0093
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:59:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F1E3A07B8
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:59:45 +0000 (UTC)
X-FDA: 85071002730.29.3D25F28
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7AC1E40004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:59:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CocnQO/e";
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786024783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgYt8RNCcPu1D6s4vJCxJg9Q9vbO/MH5z4jIJNXLqW0=;
	b=cpTqjMX0VGxqdMr8+GYN44v5fxExawaOhSkfgh/VLLxToYPBtuvy2kfs435xQhdQKD9t/1
	j8smd60ms6CFFsNjjeAmXIAdN3xbEXiqvN0my8rbBTEiF34rmaS7ELrVP08arN8ZJwB4k+
	LycCjWnvSlXfLJzVjVVUCOecBLPHJ68=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CocnQO/e";
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786024783;
	b=xsD5pbDr1KHwifLh5bPB9mp81S3ZHG/VufuglCVH28v3bVt6tqE7EqjyOZHq1ThMxd/UHI
	xKJBWzRVVCqVSYkGgj2Eqqmuooj4U9+LeyYwoI3b3JHGVVevh8U+a9nyVwAuD8Kx2oegPF
	Pou/T+oujrEYURkXhWnb5aWCr3ZV4iI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E870960A70;
	Thu,  6 Aug 2026 13:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB321F000E9;
	Thu,  6 Aug 2026 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786024782;
	bh=JgYt8RNCcPu1D6s4vJCxJg9Q9vbO/MH5z4jIJNXLqW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CocnQO/e5fu5Hao1GR9Ff6qlMjFfZufWuu6STHsEGTPoSaNl1oSOeMZ+r/Atx/yfI
	 ZGnBTMIPdlR2m96eyfnZCZ2LXq8/p4mI4eILOYpG7o8+OS05QU2EYKRc5nAe8jw2Ww
	 Fk4mrYFbr+shmtuMTxUpRJTFn43Nvxpc+nR6QftRB5qvFg/cT78u9qbjSzLLGYAeFz
	 6faQSzhZyTLXCox5CsSxw0tg1zociXNvhhPo1u9osAwJ0/rqCKDQtTEN/Hhd/1nUq0
	 vNkBCZih9B4kmV90hQPyZY9atnBlJkPXHQEE7lUe6nqC+fPYOb3Kq21iyf95xHmduE
	 oLUCgJ6KQG5jQ==
Date: Thu, 6 Aug 2026 14:59:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, sj@kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org, 
	jannh@google.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/huge_memory: skip zone device folios in
 madvise_free_huge_pmd()
Message-ID: <anSOvqN1_Hs190xi@lucifer>
References: <20260728194714.3713735-1-gourry@gourry.net>
 <20260728194714.3713735-3-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728194714.3713735-3-gourry@gourry.net>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7AC1E40004
X-Stat-Signature: dngezgt9z9r8p1xx67fi1j8un5sth3w5
X-HE-Tag: 1786024783-656368
X-HE-Meta: U2FsdGVkX1906grTONaXfv7i0iISnfLDb68Z72MNJsITk0qBwbWrQgWXS5QcLinvT+5qbKCIup9vA1ztacb+VMvvJ/a2teuRdeB5svTSdVhuWCMxUQ+qWA7WkQob2HPBOe7ENMzkREEbmtlEt/3gBd1QxLJaFHaE9URr6nLSCmq8EBzf8AJV/dJpy+Efle/bcIsEVSP21OAo8Rovla22w/hUPd14CZsaCcA/D/HO0jqnyWRFmPdWdaEh+k1M9fdSzrehBGwV4PvWn8duuvBR+QyZdN1B/JwYCcdprNgvVoHC30ynHOdDlOG4DJXfHe4iX8QADhxqT1J87fs4OgiOz4Fk5+4Q0N/iOlkpsqyd1KkJRd4MXhRfoFwT8ioA18EgzVqbc3+TCChjRmSpQZ1ZjwRrOa31xPax4Ll1tdlpjmkWetf/TuDeJih8bZN1q+9gWUbbCSf6JvycLvtdlOHUCQiWOcHRuwIYZMDpqV0vjnTtpSOErT2MBTiSUJiKl2xVTkg+71xUm33pzdLU+QydZlfRtdEqQZpzWmt2d9kmCXJDeRVZCwUUgSq7I4fSzlAFRgV/RBkeaE7znwUiMtsTaSpiG3NfQv0gN2G/A5AyrmWwv5L1jTN6r03MUIV5HG9RiNOFM3dudLCwAXhW2td7BHv1Dux6Q+YZIjDMjCrLXakZCdBFmxWIIy5krqb6/jR+kEGlVTLRS2f5fxLAvAFQBm6w44mKnLhwU5mFAUdDYKu7qXeZExki8tz42vMfiHUuS+ivYROFCVZxKfBYJU4aLJm9ezP4nukrWmIu29XY/WBNWJ45tKgH7hXLToWa80NfjnBNUw+s61Q54Rm2KMCrB8bswwbXAaUIrVDGhsg99ILG/vRWXCUmZ3/SGo+LTaMzE2DWc4aJDhgIE6Wf36PSAAqtvrrGIxC2gK8/NHEdnfeYrQuLwhfriFqiOB0yQYbbn/7uJBMctXdxaRH2MHM
 L35nQiYT
 2qtvYBjs4tPQbckoA+NrlIqpa7TCqfA3h4+TbTD10//E4wJUq26DcJG9W+/8bLL9te40OT8AXC1nCJqSfnnerOA4AZFUJxBEgJenLLSA367x3NGRKHw8+MovvMTJJzIclRcV/NKF5QVLUQqnf6sLK5IHOkvz1Ovn2pFGdvAArxu82cVQf2fQueIzF9ApQgOepuY/5BrAane5N1PlLdGQYJOUVhhgYGj+vymUKJu6cqL4RTQXXAQS9hZskU3+XgfQeWUqx2yIpiSqvg8if8/sRD2RrDl5zA4oGr/04lXYna6C/8g3Z6d3b8MemjsctXZZIDkqqHFDANwaI+ZvfDmTEzaPItsGwPUzPZpijcm7AIxX5opaW92E0myxeF8WdrJF0WHtJl3ZI57eDIuEJnR8W26P0x+ZtGIl4Kx+L2VfldFTeVGrYFnHPNU77ZM98x32/KmiPB7N92LG6ENM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I kinda wish he had some generalised folio handler like:

	struct folio_ops {
		int (*handle_empty_entry)(void *priv);
		int (*handle_normal_folio)(void *priv, struct folio *folio);
		int (*handle_softleaf_pte_entry)(void *priv, const pte_t *ptep);
		int (*handle_zone_folio)(void *priv, struct folio *folio);
		...
	};

Or I don't know an equivalent type of thing, as we keep having these same
patterns emerge in mm that are duplicated in a million places with slight
variations... :)

I wonder if C is expressive enough to get us to something sane though.

On Tue, Jul 28, 2026 at 03:47:12PM -0400, Gregory Price wrote:
> madvise_free_huge_pmd() resolves the folio backing a PMD via pmd_folio()
> and marks it lazyfree without checking for zone device memory.
>
> The surrounding guards do not cover every zone device case:
>  - MADV_FREE only operates on anonymous VMAs (DAX mappings are excluded)
>
>  - !pmd_present() branch rejects device-private and migration entries
>
>  - present zone device PMD (device coherent THP) is not filtered.
>    Unlike vm_normal_page_pmd(), it performs no special/pfnmap check,
>    and would be marked lazyfree here.
>
> Bail out when the folio is a zone device folio.
>
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Anyway LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/huge_memory.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 5bd8d4f59a7b..e0ffdeeb3077 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2338,6 +2338,10 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  	}
>
>  	folio = pmd_folio(orig_pmd);
> +
> +	if (folio_is_zone_device(folio))
> +		goto out;
> +
>  	/*
>  	 * If other processes are mapping this folio, we couldn't discard
>  	 * the folio unless they all do MADV_FREE so let's skip the folio.
> --
> 2.55.0
>

--
Cheers, Lorenzo

