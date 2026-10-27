Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E096E606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oSiNfkNt
Received: by kanga.kvack.org (Postfix)
	id DCD0A6B06DF; Tue, 27 Oct 2026 08:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7DF36B06E1; Tue, 27 Oct 2026 08:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6C9E6B06E2; Tue, 27 Oct 2026 08:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A45286B06DF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:12:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F43BA09D8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:12:11 +0000 (UTC)
X-FDA: 85368293262.06.4403BD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4109C18000D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:12:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oSiNfkNt;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793103129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=myKKudY9AElKYbxGQePv2vddrjcLrdPLn2/PF00unVI=;
	b=jI68bErQ8yIf877gQPjYv8pIlAiZxHwxvXpkiam6Hzsk5obOWbaUdDPYbi302osm4OaUlq
	FxzsoYa8KxD8E2bUMdGPRuszJvdDWZfuoNKPQlGvfl5q7D1QsDXBJ9wIwwCMnCoX+r6pkE
	LSsShduXdMi5E5kzWw+kMBZZ1e5q2GU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oSiNfkNt;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793103129;
	b=3CELWLtL4JtGL/oUMzqKSD/KrQP/0DuP0lsHUMr5J6LBLOBzgQ2HXsSKDu669m1Cg+j2Uf
	nDrqrD4jdZZMBNdfFWY5JuwbKxoC/95jeh4/NX/0AMMiiq1ybQuWnI4O16EzRVc0zV6X55
	wTlzWyQp3Fib/FoMnRYqlZRpuh61S7w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D688260052;
	Tue, 27 Oct 2026 12:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCD91F01828;
	Tue, 27 Oct 2026 12:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793103128;
	bh=myKKudY9AElKYbxGQePv2vddrjcLrdPLn2/PF00unVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oSiNfkNto50HpECdbPp4NGFleAT0D4SKsshX0uko2eZJB6zT8GrhvZwDORPPoZO1O
	 xoMmi1MpobaU3S1/V3e1SmWrZ0sIdU9VZAY254h7KadNFc2qru+jwsxPh8U9Mz/RrZ
	 Wxg/DC7xiRSwJzmvunn4aTQ0QSZUbzym4BgCXVM5LuzT05n8iPNoLmbR0Q4U1upEmP
	 UwzgCRwi4tXRk2uHvnq8umLXgXztSStFIN8ua3QCCmb9yOc6Uoci2uANmdgPQBkNJG
	 zLvBMYa8SsQH2rWgRIY6DJ6IaXFHB+5HQZg+2LjMmMrrnkvcydWyIe5d2rOxPC+92N
	 gCafwxHFsOckQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id B3BBC198004A;
	Tue, 27 Oct 2026 08:11:58 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 27 Oct 2026 08:12:04 -0400
X-ME-Sender: <xms:DpXgapG0meWIN0OM66ofji3vvc4hNVtH0drLydv1KcNIs3ErsZpJ8g>
    <xme:DpXgassn_lZcNXJFSd8gXX8QhsKHGrp27KDHGK01N2lkLJsMN-kA-SA6sBTv8Mneb
    CuMRL_aJzmPFEkIodcySUV_VxtN9HCoV6CjJbVJGzh5hDgWtimhgNeM>
X-ME-Received: <xmr:DpXgatl5ve32KSZ52FWmLf7pa8yRPvWx_n5HehD8GDPXoMiFRmAlNElLDRM>
X-ME-Proxy-Cause: dmFkZTGe5tge3hMEKwWY8gQags5EmqESoYDA0+zWY7IvA1d+/F6MsE3Cn1soB2gZC+4C8m
    AmdeqR6xBlYdjHkIi1+xb2TKsxTiKKv5qUEaP5dpCSOsLFN98khIIpouApYCUZ9iaewTN0
    hT1CmGkfdX9omvnjCFWDGuofhrU50LyeRF23rClfUeUbjui0PU0B5qFKnfogAY0cVw9+6O
    4l2HB0vw+6RGJXa4SsnIhqMXtV9Neg0umvLPylEUbt52l2DRcdcEZf56++DvuebVy5KRjg
    xa8UyxviWzWUZZykb0Fnka1ej9fCGRTSjDsN4tbCgsE4rWbtQ4MqGo2ev5BggJ27hNHiEV
    L8ibXBG14E1YD9USjV1AJkkSV08UoWz2qtU7PPRmtKgS3ApkHJBirZCYH0ppodUqAdwlIL
    69W31hE/Gs9Y/AZ5W/Z5yKU8cWSN6msM6P2mpNzDLiMPFopbpJ7fKurotK6JPMvwtTzs+x
    CceVUI8VFllI706r169j/JZsf045pQEb/pwr7oaouDKNI3rsdfX0ZepQ2zVHs4CQOk6zY/
    VugIsLjXQosrDDGEfECKAx0oj4ODRX5noTPyeL3FIjBHTxHUsQjH8ohCl1+RbkTNnO/dqR
    jw1e2R++h7DvurnnFSeIGznQ/jdZjSoxnKgmRQCZrUCh5beAl3uD4bGaZQuQ
X-ME-Proxy: <xmx:DpXgasQ1EyxtRBs4tFiKL8tb9Hn_Y9_cB9p6DEQ5SXWv7itXQGBAwQ>
    <xmx:DpXgav7Y_iwdhRD6lPwDAiYjYRymzwiWwL5vNpdSwH-mETNsjZ8Y6Q>
    <xmx:DpXgamlH7FICF6lnNILH3u5xidPa-NkHHRAF8lynadF3sQqtQ870lg>
    <xmx:DpXgal5jGenzwm1UO_iCp-fS1b4AlC1TALorVMgfcXv_uVLHSAwGbg>
    <xmx:DpXgapx4HHMRpaZzmToEh90JxUkL7hrk0zETU6mAek0gaMBujEKHWGps>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Oct 2026 08:11:57 -0400 (EDT)
Date: Tue, 27 Oct 2026 12:11:56 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, xu.xin@linux.dev, 
	chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, jglisse@redhat.com, 
	aarcange@redhat.com, peterx@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bobbypowers@gmail.com, bgeffon@google.com, 
	dplotnikov@virtuozzo.com, dgilbert@redhat.com, hughd@google.com, hannes@cmpxchg.org, 
	cracauer@cons.org, mcfadden8@llnl.gov, gokhale2@llnl.gov, mgorman@suse.de, 
	mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@openvz.org, riel@redhat.com, 
	shli@fb.com, jthoughton@google.com, corbet@lwn.net, pbonzini@redhat.com, 
	seanjc@google.com, sj@kernel.org, ziy@nvidia.com, stable@vger.kernel.org, 
	samarth.colleges@gmail.com, med08elkadiri@gmail.com
Subject: Re: [PATCH] mm/ksm: fix userfaultfd protection during merge and
 unmerge
Message-ID: <auCTv9O6F1JPyOAu@thinkstation>
References: <20261026130054.91461-1-lance.yang@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026130054.91461-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4109C18000D
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 65pjua7oekn3zpdcb9gmidqs8xiuyqmz
X-HE-Tag: 1793103129-587159
X-HE-Meta: U2FsdGVkX19gKOSdsyXzI+QLV0J/iHpkREgqoLHhHN7FER3uOYVnjJDq2E8ZYrzZ/mqNYAiisnuJAmzx+BcdRi9/e2rLIIawPC9PMr/ToCQfivzRZbsSdR4VoMBvJ/vZeIvB1jZEtgb4rJcpB6CKh94ZpmpLBYWjcwubzdJ6UvV2j1nG37u83iCSlVyBg1IGR9kgKPjtCrt8KDdAGW3h9NXk0CzBDwm4FX7mbp1OftLGWdAUj7JhlhAF1xHuealmi9KRpG+apwnedkNUVSzE0ORGnSlrun9ZG83FdICgBVck7p6WTGdGPjUSRRD4MUACqHPOxG+JiV0yXTJskt/WYm6BnWchmDUtHFA6I43HWV2YMp/UHbMj4VsvG6zkArlLiqitHllF2ELwlCx/LxliiM0nqYV5+Qw3iMwmchSfdjU7dRlnurqsJWPF1Lt22zYGKKrMiRhOIIR8KvXHjjze5GEZQokVNgt6IoQMVsI2TZDrzZmp52lFBds2HxgziDveLByQwFrzveSVPPHdGQBx42Zxjhb3J9Dic+mYL0QPbICF6CnUOB6dVdOTWmSQwPgdHPri8i8LljT/t8CmCK836pJb4ScPHqIx3azkW7QzS+V67/hlsMjF0wzT1iWVnTOwhYS38fu0DEFeqQMVKqCwelz1hivLS8iyuQ8lhMHJpY8SoffVt8DS+IY1gdygK2AMpKSf7iS9uNOjrn+emnxJr9u4PfAvq6AKyI/0UIzTiEEM055nDfE4WrpYgk5+v93VkKVHGTJdG9xYvmTqoWAMBtQDDsoLiJKQxz90KEPjBycRXd78eE7IVpwKJ0xWm0HQDgf0H+0MBwaxfBUmv1ZdEbLLmL6bdt6+5WBa57qu7xxJIOv7FqWssJPKP6mfZ4XDT9W9oKGyCmiEsXD3wIBondUgve12KSih22c4i8Z6wibVdWvHri4yFNBejMlLvsXxdCyL5GVZlC0VL0eeb8I
 S5eiuO1+
 /OC2Vjx26Un6dC6UOSOJ67d8eQTgab/RwSYgpihMTlXlM6sJqommiAxe1ibMwrW06cBMY+W27ROwG36d89zxpztrriTbauSf2A/Ntq8tiXA/Gbr3ZIpfibHhsj9p6utSoAJRyz94rjlhFYNy7gMcb1U+ScjGDFpeOkvqbd6apHFsFPhPF5Kx28rTkn0CksvU4fGcG3mYvTKyeuObSRIzeznHmhB1GzVmGXxpMScYZruRSSPxtRrIPDeDlF6yY9upQIABZJJUBUKpV4LgonFVnU4gbi1geNHgzU4R1CKjmb+8uF89Sntodr2/j9l71IjODRD8kKJA/3WN0+AhG3BXYZamCbIFf/59GIEAJfuqU3N8z5PW8KtiBIhfxLwwknaYvUuX/EAzBmLpIoxA6/TtnkeOvIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 09:00:54PM +0800, Lance Yang wrote:
> KSM loses userfaultfd protection when replace_page() builds a new PTE
> from vma->vm_page_prot. Dropping its uffd bit lets a subsequent write go
> through ordinary COW instead of userfaultfd write protection handling. For
> RWP, a merged page also becomes readable without faulting.
> 
> Keeping the uffd bit and restoring PAGE_NONE fixes merging, but we also
> have to handle unmerging. An existing KSM page can be protected with RWP
> before MADV_UNMERGEABLE, so unmerging already needs fixing independently
> of preserving RWP during merging.
> 
> Unsharing replaces a shared page with a private one and should leave
> userfaultfd protection in place, as do_wp_page() already does for write
> protection. Currently, an unshare fault reaches do_uffd_rwp() before it
> can proceed to do_wp_page().
> 
> - With synchronous RWP, handle_userfault() returns VM_FAULT_SIGBUS.
>   break_ksm() then reports success with a KSM page still merged.
> 
> - With asynchronous RWP, protection is cleared before unsharing.
> 
> Preserve the uffd bit when merging, and restore PAGE_NONE for RWP. Let
> FAULT_FLAG_UNSHARE skip RWP fault handling and keep PAGE_NONE on each
> private copy as well. Unsharing can then complete with RWP still armed
> for a subsequent access.
> 
> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
> Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
> Link: https://lore.kernel.org/all/20261019010934.697895-1-samarth.colleges@gmail.com/
> Link: https://lore.kernel.org/all/20261020055518.36087-1-lance.yang@linux.dev/
> Cc: stable@vger.kernel.org
> Co-developed-by: Samarth Narang <samarth.colleges@gmail.com>
> Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

Thanks for fixing this:

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

> @@ -1463,9 +1464,14 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
>  		dec_mm_counter(mm, MM_ANONPAGES);
>  	}
>  
> -	/* Preserve soft-dirty when replacing the page. */
> +	/* Preserve soft-dirty and uffd protection when replacing the page. */

Small nit: the period at the end of a single-line comment looks odd to
me. Am I the only one?

If you are going to respin the patch for some reason, maybe drop it?

>  	if (pte_soft_dirty(orig_pte))
>  		newpte = pte_mksoft_dirty(newpte);
> +	if (pte_uffd(orig_pte)) {
> +		newpte = pte_mkuffd(newpte);
> +		if (userfaultfd_rwp(vma))
> +			newpte = pte_modify(newpte, PAGE_NONE);
> +	}
>  
>  	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
>  	/*

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

