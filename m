Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC1D606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 07:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G285uqat
Received: by kanga.kvack.org (Postfix)
	id 7C44B6B0B09; Fri, 23 Oct 2026 03:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772EA6B0B0A; Fri, 23 Oct 2026 03:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689116B0B0B; Fri, 23 Oct 2026 03:16:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 380C76B0B09
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:16:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8750DA033C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:16:19 +0000 (UTC)
X-FDA: 85353032478.20.2B65658
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C8F891C0006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:16:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G285uqat;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792739777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pkqrD//fnGQ72hjouszMioilp+NszrPnGIYWVd5G9RA=;
	b=ab5rNLgTooCChXLJvlPh9AT25NvrxXJsZJd+T+Hmcdjx6AGTyAFOgiQ7oXE142OAV/woGB
	7iZ/Tw8XLGilmkttMMDstclOy1iMyjmcXozvJDLb4KeL+sEnARXN+DxCIqwSE6V7Use2GN
	EGWnljRPY5+AtvFgZj9wylLPUn7HOio=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792739777;
	b=6bShJGaHVwcnNluC2vh0OsKUEYOOt9/s7j7EhfnqIgSbPKPPyqVaVAoaBoO90UPxbslVXH
	M0+sdZ7XfeED4eWqGCNbpslI2M9CAAROpid5bteNI9h5ocwAOl3TDlR8upjIMaH3TV6bTp
	3ZbUr2GYUoW8lEqjMyvlfPWjuqaFesY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G285uqat;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE88360210;
	Fri, 23 Oct 2026 07:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F771F01825;
	Fri, 23 Oct 2026 07:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792739776;
	bh=pkqrD//fnGQ72hjouszMioilp+NszrPnGIYWVd5G9RA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=G285uqatlfpZ6ocauqOB0OLsQ70I1Dgw7gK2NxUGwd/MJRYS7Y6vqNl+H7gQbGOcK
	 ftTeh0DVX4xAqez6LW/Vht3wP+DRN48+3dv2nf50i8NnbwNXWGOp2NWv7uMAtIwl/B
	 wn131MQ1wIWH1p4Fxfow5ose0tQU+YmBccoXuePJXI4+LieWBCayhLnw/BIreTaCcf
	 SGriwCo3bcjVU9kJmUHE7nBCVWx0ouoPkS0fHzvpWNGjMVD5RsT83KGen5F+L1fzOA
	 Skf1aCe4gwU8hoEyy1eTHSXTX0MTUtX/eDuHaHy8C+I0b8AklN7DahVTc92e5aUbi5
	 tIKR+bgmltb0w==
Message-ID: <8c53e58c-f7d2-4e98-8d03-7ff1163c1159@kernel.org>
Date: Fri, 23 Oct 2026 09:16:12 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mremap() fails VMA expansion when VM_MIXEDMAP is set
To: Luiz Capitulino <luizcap@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 David Hildenbrand <david@kernel.org>, Jakub Matena <matenajakub@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261023023106.515365-1-luizcap@redhat.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261023023106.515365-1-luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C8F891C0006
X-Stat-Signature: 8ddf6y6xm9pzxaomw65e1rtneg8ps841
X-Rspam-User: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792739777-343941
X-HE-Meta: U2FsdGVkX19eqzplBlWnN6khRalK3CVhxGYAof8MvLKZSA4HNYAajBRoGNWuzLMAiRRcvzQR4mlf5ged3T98iOcam6mfknKWb3b8nJsqtmY5l34gh8HQcTJdOvqE5+nHKjeF2yqMmMgcvTK+f65t4y3xjErxuTCzn+5tUZnwOKtai/cv3imPqct2tL1sAZGfYaVChr/vz/igN2HkH6MNy33vjo3wXB7/qXgHPDD/NuQrhtACOdfQV7FXtvE8laytVhC5/4qjQSaUCA/HVrPurumQ/9GSsJY9ymdQl56FFp0kyBKsCoveU154NH5UiuXlAV4C9NMsIIaecGUqkJLADYdvcx79lII8/uWXFUWeBxwlHWFhWSNdcC5PSu1SCgavNih72FOCzQfWfnhy3lhdLPEJbQEkrjYNmI31XmQIN8DvNvC8kEi8BmpkG6Zh6BmtlelrLZYHURk0a0gSOpw/NGPEPSBDW2+csya+LC3GxJqFYuYdezoFnFBlNpykrzb0VooTt8N/vkwIs5x87PFPUsyGUEVozO44uLFy+hPBCagwAbrLE6U5y4vFXONIF5y/6h1NfNA6GY+9/zq5ltUo2JFdgGq8wz/F/kjTiltHUIXgCiksQgtLcm4Oq34DYmb9+t3j4N2kd8wBNsbH9Ge6DVGWGTf65fJTpcj8xBwrgKSwr/IlNeZGnQiFfYl8coyXrBsJB+YbxqsfsUPdBvurK4Hghkeugeei+BFQmhXpPrhqszGaczpPkV59D8udNansFVSEjlA2gukTieoOON85a/YPKoZaJbkpoHaddYIr9NCjK6xMCaNlkB0T15UyRLI6z9XSBPteKAQTPnOedl93VnPfqI9/be/QxAzmk0Ti/FsL9YqCDPvcfFTqJLDV8hMVy5c7PpXSUL0Cz2HURaIH8KduDkvuCgoALKoP+rEaIvZFq/oXSss0KQ7r7Uj7uOqHXg1Hrq8qNy2jIoB3XYI
 rWtg7vVd
 wzG0Ix8WIYnlk9nmSCha7o6xJsdFBkr9LZNWN9oEcKGyVlfXZkA0oWQ4gWkjqFeyYh+6Us1bB8nJqPNdoy2IxoZK9LXTKSLD6aDrAA6s0VQjo+pcKJUyeS3dWfmzVQfjQKX7xc75PWQNByqlSO88QGCTBblpZgvaa82UfpLD7hjj0nqcp1s0iDqsv2AZJ0+efu4bCYCP2wJBSSSh8IhOe7AlUJUhgE+i5PHv3+Dq3bNS8gw+Y88LHDgozL79tbJS2r7+zFNqhDRiym/23Ejmxt+ZeLkwq64iQ8+wCuuiGSouvGah21/NqiobcBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/23/26 04:31, Luiz Capitulino wrote:
> Growing a VM_MIXEDMAP VMA with mremap(), with or without MREMAP_MAYMOVE, fails
> with -ENOMEM when the address range after the VMA is free.
> 
> This regression was introduced in v6.1 by commit ca3d76b0aa80 ("mm: add merging
> after mremap resize"). This commit changed mremap() to use vma_merge() instead
> of vma_adjust() for the expansion case. However, vma_merge() returns NULL for
> a VMA that has any of the VM_SPECIAL flags set.

Hi,

6.1 was a rather long time ago. How was it discovered just now? I.e. what
use case broke by the change and prompted creating the reproducer?

Thanks,
Vlastimil

> The issue is also present in latest Linus tree, except that the code has been
> refactored. In the current tree, the path now is expand_vma_in_place() ->
> vma_merge_extend() -> vma_merge_new_range(), which performs the check:
> 
> 	/* Special VMAs are unmergeable, also if no prev/next. */
> 	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
> 	    (!prev && !next))
> 		return NULL;
> 
> This issue was originally reproduced with an external module that sets
> VM_MIXEDMAP on a VMA because it wants to insert pages with vm_insert_page().
> However, there's at least one in-tree reproducer: tcp_mmap().
> 
> Note that commit ca3d76b0aa80 introduced other VMA expansion regressions,
> but they were caught and fixed early:
> 
> - 6f12be792fde ("mm, mremap: fix mremap() expanding vma with addr inside vma")
> - d014cd7c1c35 ("mm, mremap: fix mremap() expanding for vma's with vm_ops->close()")
> 
> Below you'll find a reproducer and an attempted fix.
> 
> Reproducer
> ==========
> 
> This reproducer was written by an LLM and uses tcp_mmap(). It reproduces
> against v6.1 and latest Linus tree (2a08195e4db5). The issue is not
> reproduced on v6.0.
> 
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <unistd.h>
> #include <errno.h>
> #include <sys/mman.h>
> #include <sys/socket.h>
> 
> int main(void)
> {
>         int fd, pagesize;
>         void *p, *ret;
> 
>         fd = socket(AF_INET, SOCK_STREAM, 0);
>         if (fd < 0) {
>                 perror("socket");
>                 return 1;
>         }
> 
>         pagesize = getpagesize();
> 
>         /* tcp_mmap() sets VM_MIXEDMAP on this vma. */
>         p = mmap(NULL, 2 * pagesize, PROT_READ, MAP_SHARED, fd, 0);
>         if (p == MAP_FAILED) {
>                 perror("mmap");
>                 return 1;
>         }
> 
>         /* Drop the upper half, so growing back into it can happen in place. */
>         if (munmap((char *)p + pagesize, pagesize)) {
>                 perror("munmap");
>                 return 1;
>         }
> 
>         errno = 0;
>         ret = mremap(p, pagesize, 2 * pagesize, MREMAP_MAYMOVE);
>         if (ret == MAP_FAILED) {
>                 printf("BUG REPRODUCED errno=%d\n", errno);
>                 return 1;
>         }
> 
>         printf("NOT REPRODUCED\n");
> 
>         return 0;
> }
> 
> Sketch fix
> ==========
> 
> In the fix below, I started with the same idea as d014cd7c1c35: on v6.1 I
> made mremap() expand VM_MIXEDMAP VMAs the same way that commit did for 
> VMAs with vm_ops->close(). Then I adapted it to the current tree. It fixes
> the reproducer and I didn't get regressions in MM kselftests nor the
> tools/testing/vma test.
> 
> However, I'm not posting this as a fix because I'm unfamiliar with the VMA
> code so I'm not confident this is the right approach.
> 
> I really don't mind someone more familiar with the code taking this over.
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index 6c35f0d775ab..ac9a0a8a4be9 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -851,9 +851,15 @@ static int commit_merge(struct vma_merge_struct *vmg)
>  	return 0;
>  }
>  
> -/* We can only remove VMAs when merging if they do not have a close hook. */
>  static bool can_merge_remove_vma(struct vm_area_struct *vma)
>  {
> +	if (vma_flags_test(&vma->flags, VMA_MIXEDMAP_BIT))
> +		return false;
> +
> +	/*
> +	 * We can only remove VMAs when merging if they do not have a
> +	 * close hook.
> +	 */
>  	return !vma->vm_ops || !vma->vm_ops->close;
>  }
>  
> @@ -1093,6 +1099,20 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
>  	return NULL;
>  }
>  
> +static bool can_merge_vma(const struct vma_merge_struct *vmg)
> +{
> +	/* VMAs without prev/next are unmergeable */
> +	if (!vmg->prev && !vmg->next)
> +		return false;
> +
> +	/* We can't merge VMA_IO, VMA_DONTEXPAND or VMA_PFNMAP */
> +	if (vma_flags_test_any(&vmg->vma_flags, VMA_IO_BIT, VMA_DONTEXPAND_BIT,
> +			       VMA_PFNMAP_BIT))
> +		return false;
> +
> +	return true;
> +}
> +
>  /*
>   * vma_merge_new_range - Attempt to merge a new VMA into address space
>   *
> @@ -1152,9 +1172,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
>  
>  	vmg->state = VMA_MERGE_NOMERGE;
>  
> -	/* Special VMAs are unmergeable, also if no prev/next. */
> -	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
> -	    (!prev && !next))
> +	if (!can_merge_vma(vmg))
>  		return NULL;
>  
>  	can_merge_left = can_vma_merge_left(vmg);
> 


