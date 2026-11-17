Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF6C606A8B8
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 11:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YSm9YO4w
Received: by kanga.kvack.org (Postfix)
	id 904676B00EF; Tue, 17 Nov 2026 06:08:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5406B05B0; Tue, 17 Nov 2026 06:08:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3A76B05B1; Tue, 17 Nov 2026 06:08:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45DE56B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:08:31 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03B8C1A03AE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:08:29 +0000 (UTC)
X-FDA: 85444337580.13.182DB80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 160F1C0008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:08:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YSm9YO4w;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794913708;
	b=SZ7PyEa03eGDXGnxkOSGy8ExbD1BEO1BZ2EYP2jfy9J3g3Tn5S5Bwim2foZdE92DlK4SEe
	0gDruvEnYY0eXnC4p0HuHYD5WmoO3BtHyu2NxXaJencUzho+FwGKwNm+PjiLxgPZuvVkF1
	YJ+WdEm0R+ukllIsQjdbUb6uam5xvEI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794913708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YdKhAjlrPqsB5ZWJA75kjf0hOR5+o724DAc3k4bz9WM=;
	b=M4OnOzkT+m+3TsKRYmev1l4jCdgOxqNVIWJ/BwMevOcTyVOKwFWNG43OeUxQBIgar+gc/d
	IRUiRWYS4naGwvvEJhOTjNt9rL3rSzOFaAXC0/BcRSB14rk1B425Lj2n5qgC36RuFrbO8Q
	mB1pFzhJhl+9H6Lsh4FFQUGWF7gtv7w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YSm9YO4w;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AAF06308A;
	Tue, 17 Nov 2026 11:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FB01F000C4;
	Tue, 17 Nov 2026 11:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794913707;
	bh=YdKhAjlrPqsB5ZWJA75kjf0hOR5+o724DAc3k4bz9WM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YSm9YO4w2aPh+GuHQ3zlbH8kFIn6KEiPq3g/m8JTyz+sqhikPgHJlMRIkrNVxS85v
	 9LN5ikUDGNnvQdNVD9Yx0QaHeOvcERV05t4ezT8s8ht3FUFLqOVL1h46i41S3mSg8x
	 3CwyBjQ4Fz8wjapNG8inTytd7V5fBwQ+Qp1qk5qa/X5bQmKWSLffebuSwsl+bDekRi
	 ZDFf/tLPcFrGXaQz6wSmRcYpNg/uY4ev21f4/ZUzUz32pl7jcVES6ZQ/4AeNuf1dca
	 bzJwtNkH4Ux80E/wXJO2hRKSWB6MK+o/d7wI69Gx1K0PF2RktCnEsu5v+T8Jjhhzch
	 tv912fHnJUcUw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0DBE1198004A;
	Tue, 17 Nov 2026 06:08:17 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 17 Nov 2026 06:08:23 -0500
X-ME-Sender: <xms:oTX8au8V4nBt8GHehzG9hEqmJJ0HaqqYpvNCV17AYD01BZPOeQVoJQ>
    <xme:oTX8albihyzYQlQnLn4T8BJ1gmqebndkTGMmqke7yUKcnK4APtbn3JWjy7RmzWS1O
    903VKbw5yuGRiyo2tXIWrsFF59yQYsrhEMhXzqsAs4SpsOsB0bFlII8Cg>
X-ME-Received: <xmr:oTX8aof3KijgYivzYrK9nBnwExCT8RjMBh5aunI6IasdxrPsWMBJl7d84B0>
X-ME-Proxy-Cause: dmFkZTGX1nIRce2EM7hEBPteoZuiZssnqMFZnuwSxMXg3gdmnTZl+fiHHzX2oBNXSiJsJf
    I/e9Vst+BHtRoyhl9WMXbh0/gwYGA9PqFYtIQKVLnyIVXb7zeXkz3N6uhReUZwYIR13hrL
    T7ZKOtu8DTAvwxpGM2l/jnWnCIUE81n/1kRkdUv7Pbk4yGbDA5DNCGU9aTD2f87pwBPfTr
    rivmGIjHyKUTgsoUG2wWa17dtgrQbqrrvlenEILMaH+BW9Hs46eNWXt0bxG7yreAceLvHU
    ykd75nYuGULyxecIDhNRoWGFcA9fGbFbcVW4tk858GUqeki7QD2eIO+z0vcDAwKw/ynInP
    sWwWo9LqVy1pNvVl7TC/bdvcrBYzidU3wgTdfM7PF/ACKjYhVqJUDR4nF2WHsgIJkAgHko
    jQrg9+PgzOxv5SmLJg+FedzvnFL9reKS7CAIv5vLVs14Pm9QAsrvbDh5Y3ux770Ee6Lylf
    QHJSnA23fNSUfcqNN+j5YKQFq3fQdWYKd5Abmn08WZZrlG3Oco8F0URxA+G4rAxR94RiqJ
    2j8o0SVRMPvmI/p3bUn1elP1e6Qrm85bepxgnGGrnWYIJ8HNbKRk3RaRBGvmHndZKENqeY
    0tjgazk8jKruqR2gzfcA0Xc7V/ggyN/xuX/0HQPJJeCbrpFjE9Us76Op37bA
X-ME-Proxy: <xmx:oTX8akr9YirNVX1wT6I5G5ZjYWf3es2sMnWiTwbMdWr1ECImBZiNYQ>
    <xmx:oTX8ap-CF8l49la4aQ3MiWU8vChpmqwjhx7rwe0W7ZElJcHjBI6y7g>
    <xmx:oTX8agIyOj-Cr_Jzcwge6FSvAsEAQMzbe4chXdGLMu5ExOmtq0LsFg>
    <xmx:oTX8anPcMSoAHG1094FhYNrpeOK_1uGbri0f_Ow_pi9ufrHjqAIjRg>
    <xmx:oTX8ak_ghEYWw0nYrtaE_8lytzaka_ZeBAYsR3IPaoc6K0mVmgCaNdE_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Nov 2026 06:08:16 -0500 (EST)
Date: Tue, 17 Nov 2026 11:08:15 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com, 
	joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, matthew.brost@intel.com, 
	mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org, surenb@google.com, 
	vbabka@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/4] fs/proc/task_mmu: don't read young/dirty from a
 non-present PMD in smaps
Message-ID: <avw1Yc1W6BurgC9x@shutemov.name>
References: <20261116063624.1382944-1-usama.arif@linux.dev>
 <20261116063624.1382944-4-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116063624.1382944-4-usama.arif@linux.dev>
X-Rspamd-Queue-Id: 160F1C0008
X-Rspam-User:
X-Stat-Signature: 4ffuwqqeizcmkzyr7e5azx9m6fm69fcp
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794913707-241739
X-HE-Meta: U2FsdGVkX1/wEcy9hbwG1eM6gmrCSR9Kye+TLH5Fcnpwhpz2gEQ5pRrMtU242lKEnr6VE3e6AmlJtODem7RRie7YwG5F0XrFSSgyk6Lelzy9FDrUmtZaxj5ygjYFzE3FAiSMb5I3zqUmoxU6t1TTuNTkEvFc4tMehkuZJg3XyuBE9Dc3/EMY6AGpcY8/4g2fi8OOfkp6gKg9wcVEsm7HFZJwg+sdn1JNFwtB7rDC8HzYnKMSuJXY88VcUBlQoHYrD1gonnU7fZlwUCRmN+rEBd6G9ITi8u89wx3/tTHHxgyaUKrCjEfCqgEfOiHUlq5vNDdgRINIp5yyaIr2SBOsjXWGe9g6Trl4l/F/0X4FsQapZlczL9DRI4a0SEwvxfDunQKwF1cX+CgICOqOMGBiTw3nfNCKLLPcNaTLYkFCDhmwRlXf5hc+8l8JGQvGabeOYQrCjb5D0vO6uMvCtKo2kCwcw+0UE4FhDIuHvHmiX2dy9K23sbdBhPIr54aUYOQ+9j5cTZp/10GSrtSx7RRm8Or5+YUfiSAVYAmc+3pN/TJou/Z3i4TBWsq/G0nbE0Az6Cw8aXkfT/Y0q3dzwmI0sYMgNdIdLdXaZ5t0RwSA7gMcmivqrOe4MAPDntYogab1yeJ3qYFnh9iP4kg/cCUGsMOHpAok5fd3Rnd95wL3ADAY/a0xgAXynH6aBQfuhr5YSZWk9VpUKcCPdcDBPW6PGzIPpEj0yZznEtykgLu81/55LctzuNtXSrRSsjYBIECCCnxYAzybnzNrEW6WON8p91z2qY0ACmm5iBtKC0TIsFR8Y2oQrGG0D3kjXH8yaYVXP86DoxWF7YogsRhE1qPKYWAasbwC3tYdjkv4x2FfVvLDY5kbv/qnNPj4a8yvsC0eLIpXTQ1ih4lB8zxa8OW7jRmAdwrODuB9kzJ7px6SQ5GA50f3laM3RDwKnK5wjBSeRdTmbLDMhrzINf1N2A8
 TWwOlyGP
 xuozeDwQCDGuE63R7NV57XiCt8tiWIL2vImjeo9PWOirZdo0Y5iji5f7GG/tDIbeZiX0wrWt+rJy50hIg2RYxYUlBGIOxDbFPSlLj5lzAomT9tC+l7xJ04RZt/5gDyYe9SlOwIHLVMIfJ7kFy4eDknOWELd2R+JpiInMDl0wGcgsuXv33cuS799W4lrdTV3i5zjmYEMQ1Nu24OzPcjqVgBY4s/a5zTKTsjBg46BQY5hp7Ngo32s6c5YYdcExy8j1MwAxqmW2GcXCYnwHWb+8TwdnfonGiBJWIPmOeVopwiLe9HEAAQoIaLymNA78m1qXwZaluYwKSbvzAD3uCN+GDyZm+lXzgmfZnZhCzSk9JEVv+r68GJisTputUKmFtQyz1ydShz9kQl2C22bMsk5r20XTgrvEcd3IqFDMyYMh5i0YQprWiTUIrbZmI2b/U9M7cjHIg5P1Mk+qvtrQh0dPxsGqAIWB1Pgy6RcI4AKVPMQMN+TwD368r8RpKjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 10:34:57PM -0800, Usama Arif wrote:
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 164b4efc5e093..ad9fdcdaa2c40 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1029,13 +1029,15 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
>  	struct vm_area_struct *vma = walk->vma;
>  	bool locked = !!(vma->vm_flags & VM_LOCKED);
>  	struct page *page = NULL;
> -	bool present = false;
> +	bool present = false, young = false, dirty = false;
>  	struct folio *folio;
>  
>  	if (pmd_none(*pmd))
>  		return;
>  	if (pmd_present(*pmd)) {
>  		page = vm_normal_page_pmd(vma, addr, *pmd);
> +		young = pmd_young(*pmd);
> +		dirty = pmd_dirty(*pmd);
>  		present = true;
>  	} else if (unlikely(thp_migration_supported())) {
>  		const softleaf_t entry = softleaf_from_pmd(*pmd);

smaps_pmd_entry() dereferences pmd six times :/

Could you read it once with pmdp_get() in a separate patch before this
one, the way smaps_pte_entry() does with ptep_get()?

This patch would then only move pmd_young() and pmd_dirty() under the
present branch.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

