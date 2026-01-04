Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E4ACC2A069
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 19:25:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E7826B00A0; Sun,  4 Jan 2026 14:25:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494D86B00A1; Sun,  4 Jan 2026 14:25:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34CA66B00A2; Sun,  4 Jan 2026 14:25:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 212F96B00A0
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 14:25:18 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83040141305
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 19:25:17 +0000 (UTC)
X-FDA: 84295259874.02.8ABBE64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id CB7731C0002
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 19:25:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mP7Tqgp2;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767554715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C/7TQQhZhUdludtJRXOTPr/sPmzsgarrDd/VfJla7mE=;
	b=O0JA6G4lvULFMLxHWhy5gZB4WTa0VArN5VJLddoek1Q2ilQD9Qfc6kCuxsYpUcT309C8k4
	A79LyBWCWAf/VUZPIYTfNW1B64tQ/WhnbcnhaLxNkhIpoVsJshSdgKlSQrnLuU4yWljkj/
	PXQFEjuJaMGZMU3ce2wksdK3rHOf1ts=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mP7Tqgp2;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767554715; a=rsa-sha256;
	cv=none;
	b=q5QVLiHp668ftni8CI5vciwuTWmQLq57Gq6tv0u/Nvtd2MLzaBjPAbpKSbO6+Q7UFE8EbX
	y3jwufs8siwgPFlAu/LDSb4tIShmusJQf24LIbOhMHSwMykygx9XXjsrpr6jXJhjku9RRY
	3rb+IzozZeP8Hjk7UKkaGmosZLoiDI0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BBB516000A;
	Sun,  4 Jan 2026 19:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F721C4CEF7;
	Sun,  4 Jan 2026 19:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767554714;
	bh=e57x6itIcSze2g42091hjwd01f/XzLmARCcIvAJgGfo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mP7Tqgp2gM5XcDjI4Xu3ICL26krzmLkrkoqqXSC7+7qAFmJP9mmOZ3N9z/pCtKIO1
	 IynUk0zcHKTPeUgq1QuHlGgkXtyfkSesuWILrpmKT4Gsp3Ps6ENCy7WAc4B5zGtY7W
	 FlqgAasuxyKyCybqbxmVhuAmGOZAfTm9v6r81bXdTUJ32tHFn0uBSE9UIJmdy7MyvH
	 vzY9W3Z3iACpTEmOzjrNrVPnOVup+7kv0xWzMRy2EUG9xnc76Nk2ss38Lqgjm1FXv1
	 OhnBfSz042Tzl4yRgDlhBz3+mhFRTvrogd4B0hf2brAaB3vmN3bF5tEE95FEW4i0zV
	 FALSRmEj9Ptqg==
Message-ID: <dc6a1474-70b4-47d5-b07d-a012b2c37b95@kernel.org>
Date: Sun, 4 Jan 2026 20:25:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted
 merge
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>
References: <20260102205520.986725-1-lorenzo.stoakes@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260102205520.986725-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: krabkg4otozeim5z6u6ez8xooewsb4a9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CB7731C0002
X-HE-Tag: 1767554715-471361
X-HE-Meta: U2FsdGVkX187HfR4GP6XoBWuimSxk11baZ3bTDPnpdmRF5RAg26vuDzwZv/E6Y5JoayG4i/gwumYGcHMhL6VAleKIeu9rUWWgi+uu1RjOYRjmpYrVj1T7zkQCOY5sDdh/NrkkcOWTtAITFBSWCi4dsZ4P2RMqzHcU/43Hz7tJGUAxgz5eLppujUidXc6sgAqcb2OkT73yZ6MsiOuS3+53KA13J7A0BWKvj/soBHpeYfX+2hYGI0Bf19z26tKWwnIt395XnSn79+j63cQhL12DnFM9zWQaCutyAddsqGBmvXAS5F2Qy3x+7gEj3h+S31lETCSBK0JlHYrxi15ohorYARkD5Vf6HI5lOl7q8WSXZqwbr6mN7DhlNf1pSqBes0D6zsZiQeBjVBfz/wguNvNqlAhJLRUHzcMq9gUN5/6i6/s/U0aXodh4c1irqQ5DNOEs3oTrzagspmeIsSLAfrDW2YDFJnzr4f5DHk2eYBd2pInVK8bjSZjm8dwJe/AthvPudqt4jPBfs/ResMTLPKVXe6bY1QD9bEIZiOSqyWNTk1QiiCp77KAhzcsSBs6jUeNsk7q4ZV3dKOStMzlozSpJ3iybFqjdpr3XPbaOaGvJRi7Ag6jz96ppWBFtKbGIhqYWJJ/f+xoXN039L/UwOiGbqJrkmh10xaykiLOu4tDB2DKcCY0B7Sep8sEFu1PZ2Tr4h4nmrqJUvd1IgSmgtp5eAvJJ0Uq5oXyp0TmCtrEakQTRq1bSMfTQvI2US7n0Z70dPYfocy0PH7gcRZ3Ypr5znxi5zx2WkuJum7AQRCXQXgf7FfrJ+LJzI/776Dw4VcQ43w1Muz+3esu8fEcEtEjtCpwUDZzznNzvuq0KFZNasGgvuM3VJsdqrrmJ1h3xrpA3OQFTD31EEMYeOaGDeaGW9sTqXLyXiGzqt/EirByKMiNGd3SHyUKL2SjVyZOgjDtQ48a9UhwLbK2IOLGitO
 wLLduEeq
 wchpjSv953Af5m7pQBUfG/LgsmitqAECAKMSbysG6MohnjELfciQ0NaVIOAfcb4WpL0X5jqfyrp5k63H0zWxvio0TNWXxF9BvWKyTvwSXC2lXVLk1jpNIqajjfRZ8YkesrSygaddfwJT8/oAuyk4FZT9NUDTX7/7bId9zcOOOZuQYlogFITfMIwqP52HS6zGtZgRpHr7GQdXI9AI72LhrfrYkWMq4qg/pta9FwfnKxBJgK5rGolOIvBER4eycmUKgmb20Y1fmgBBiT5/JvDOQR9HwzmLVBy0pLNyTVrgVRjMdUwy1+2nY7UZyWmUvZiNrkTVqWBf2qId8ZjnIsiEs9xsbP2ROEdG8eIw1LjVYx7wu+dFSJCP/FwBb35+r/Z6108rEUxlbmelOVtgqXYRQPWPx7SBMV/nkEzpSGmLzOpIJpBM4RYAMB6kSKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/2/26 21:55, Lorenzo Stoakes wrote:
> Commit 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA
> merges") introduced the ability to merge previously unavailable VMA merge
> scenarios.
> 
> The key piece of logic introduced was the ability to merge a faulted VMA
> immediately next to an unfaulted VMA, which relies upon dup_anon_vma() to
> correctly handle anon_vma state.
> 
> In the case of the merge of an existing VMA (that is changing properties of
> a VMA and then merging if those properties are shared by adjacent VMAs),
> dup_anon_vma() is invoked correctly.
> 
> However in the case of the merge of a new VMA, a corner case peculiar to
> mremap() was missed.
> 
> The issue is that vma_expand() only performs dup_anon_vma() if the target
> (the VMA that will ultimately become the merged VMA): is not the next VMA,
> i.e. the one that appears after the range in which the new VMA is to be
> established.
> 
> A key insight here is that in all other cases other than mremap(), a new
> VMA merge either expands an existing VMA, meaning that the target VMA will
> be that VMA, or would have anon_vma be NULL.
> 
> Specifically:
> 
> * __mmap_region() - no anon_vma in place, initial mapping.
> * do_brk_flags() - expanding an existing VMA.
> * vma_merge_extend() - expanding an existing VMA.
> * relocate_vma_down() - no anon_vma in place, initial mapping.
> 
> In addition, we are in the unique situation of needing to duplicate
> anon_vma state from a VMA that is neither the previous or next VMA being
> merged with.
> 
> To account for this, introduce a new field in struct vma_merge_struct
> specifically for the mremap() case, and update vma_expand() to explicitly
> check for this case and invoke dup_anon_vma() to ensure anon_vma state is
> correctly propagated.
> 
> This issue can be observed most directly by invoked mremap() to move around
> a VMA and cause this kind of merge with the MREMAP_DONTUNMAP flag
> specified.
> 
> This will result in unlink_anon_vmas() being called after failing to
> duplicate anon_vma state to the target VMA, which results in the anon_vma
> itself being freed with folios still possessing dangling pointers to the
> anon_vma and thus a use-after-free bug.

Makes sense to me.

> 
> This bug was discovered via a syzbot report, which this patch resolves.
> 
> The following program reproduces the issue (and is fixed by this patch):
> 
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <sys/mman.h>
> 
> #define RESERVED_PGS	(100)
> #define VMA_A_PGS	(10)
> #define VMA_B_PGS	(10)
> #define NUM_ITERS	(1000)
> 
> static void trigger_bug(void)
> {
> 	unsigned long page_size = sysconf(_SC_PAGE_SIZE);
> 	char *reserved, *ptr_a, *ptr_b;
> 
> 	/*
> 	 * The goal here is to achieve:
> 	 *
> 	 * mremap() with MREMAP_DONTUNMAP such that A and B merge:
> 	 *
> 	 *      |-------------------------|
> 	 *      |                         |
> 	 *      |    |-----------|   |---------|
> 	 *      v    | unfaulted |   | faulted |
> 	 *           |-----------|   |---------|
> 	 *                 B              A
> 	 *
> 	 * Then unmap VMA A to trigger the bug.
> 	 */
> 
> 	/* Reserve a region of memory to operate in. */
> 	reserved = mmap(NULL, RESERVED_PGS * page_size, PROT_NONE,
> 			MAP_PRIVATE | MAP_ANON, -1, 0);
> 	if (reserved == MAP_FAILED) {
> 		perror("mmap reserved");
> 		exit(EXIT_FAILURE);
> 	}
> 
> 	/* Map VMA A into place. */
> 	ptr_a = mmap(&reserved[page_size], VMA_A_PGS * page_size,
> 		     PROT_READ | PROT_WRITE,
> 		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
> 	if (ptr_a == MAP_FAILED) {
> 		perror("mmap VMA A");
> 		exit(EXIT_FAILURE);
> 	}
> 	/* Fault it in. */
> 	ptr_a[0] = 'x';
> 
> 	/*
> 	 * Now move it out of the way so we can place VMA B in position,
> 	 * unfaulted.
> 	 */
> 	ptr_a = mremap(ptr_a, VMA_A_PGS * page_size, VMA_A_PGS * page_size,
> 		       MREMAP_FIXED | MREMAP_MAYMOVE, &reserved[50 * page_size]);
> 	if (ptr_a == MAP_FAILED) {
> 		perror("mremap VMA A out of the way");
> 		exit(EXIT_FAILURE);
> 	}
> 
> 	/* Map VMA B into place. */
> 	ptr_b = mmap(&reserved[page_size + VMA_A_PGS * page_size],
> 		     VMA_B_PGS * page_size, PROT_READ | PROT_WRITE,
> 		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
> 	if (ptr_b == MAP_FAILED) {
> 		perror("mmap VMA B");
> 		exit(EXIT_FAILURE);
> 	}
> 
> 	/* Now move VMA A into position w/MREMAP_DONTUNMAP + free anon_vma. */
> 	ptr_a = mremap(ptr_a, VMA_A_PGS * page_size, VMA_A_PGS * page_size,
> 		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
> 		       &reserved[page_size]);
> 	if (ptr_a == MAP_FAILED) {
> 		perror("mremap VMA A with MREMAP_DONTUNMAP");
> 		exit(EXIT_FAILURE);
> 	}
> 
> 	/* Finally, unmap VMA A which should trigger the bug. */
> 	munmap(ptr_a, VMA_A_PGS * page_size);
> 
> 	/* Cleanup in case bug didn't trigger sufficiently visibly... */
> 	munmap(reserved, RESERVED_PGS * page_size);
> }
> 
> int main(void)
> {
> 	int i;
> 
> 	for (i = 0; i < NUM_ITERS; i++)
> 		trigger_bug();

Just wondering, why do we have to loop, I would have thought that this would
trigger deterministically.

> 
> 	return EXIT_SUCCESS;
> }
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
> Reported-by: syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/694a2745.050a0220.19928e.0017.GAE@google.com/
> Cc: stable@kernel.org

I was wondering whether this commit actually fixes older reports that Jann
mentioned in his commit a222439e1e27 ("mm/rmap: add anon_vma lifetime debug check").

     [1] https://lore.kernel.org/r/67abaeaf.050a0220.110943.0041.GAE@google.com
     [2] https://lore.kernel.org/r/67a76f33.050a0220.3d72c.0028.GAE@google.com


But 879bca0a2c4f went into v6.16, but [1] and [2] are against v6.14.

So naturally I wonder, could it be that we had a bug even before 879bca0a2c4f that
resulted in similar symptoms?

Option (1): [1] and [2] are already fixed

Option (2): [1] and [2] are still broken

Option (3): [1] and [2] would be fixed by your patch as well

But we don't even have reproducers, so [1] and [2] could just be a side-effect of
another bug, maybe.



> ---
>   mm/vma.c | 58 ++++++++++++++++++++++++++++++++++++++++++--------------
>   mm/vma.h |  3 +++
>   2 files changed, 47 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index 6377aa290a27..2268f518a89b 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -1130,26 +1130,50 @@ int vma_expand(struct vma_merge_struct *vmg)
>   	mmap_assert_write_locked(vmg->mm);
> 
>   	vma_start_write(target);
> -	if (next && (target != next) && (vmg->end == next->vm_end)) {
> +	if (next && vmg->end == next->vm_end) {
> +		struct vm_area_struct *copied_from = vmg->copied_from;
>   		int ret;
> 
> -		sticky_flags |= next->vm_flags & VM_STICKY;
> -		remove_next = true;
> -		/* This should already have been checked by this point. */
> -		VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
> -		vma_start_write(next);
> -		/*
> -		 * In this case we don't report OOM, so vmg->give_up_on_mm is
> -		 * safe.
> -		 */
> -		ret = dup_anon_vma(target, next, &anon_dup);
> -		if (ret)
> -			return ret;
> +		if (target != next) {
> +			sticky_flags |= next->vm_flags & VM_STICKY;
> +			remove_next = true;
> +			/* This should already have been checked by this point. */
> +			VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
> +			vma_start_write(next);
> +			/*
> +			 * In this case we don't report OOM, so vmg->give_up_on_mm is
> +			 * safe.
> +			 */
> +			ret = dup_anon_vma(target, next, &anon_dup);
> +			if (ret)
> +				return ret;
> +		} else if (copied_from) {
> +			vma_start_write(next);
> +
> +			/*
> +			 * We are copying from a VMA (i.e. mremap()'ing) to
> +			 * next, and thus must ensure that either anon_vma's are
> +			 * already compatible (in which case this call is a nop)
> +			 * or all anon_vma state is propagated to next
> +			 */
> +			ret = dup_anon_vma(next, copied_from, &anon_dup);
> +			if (ret)
> +				return ret;
> +		} else {
> +			/* In no other case may the anon_vma differ. */
> +			VM_WARN_ON_VMG(target->anon_vma != next->anon_vma, vmg);
> +		}


No expert on that code, but looks reasonable to me.

Wondering whether we want to pull the  vma_start_write(next) before the loop
(for the warn we certainly don't care).

-- 
Cheers

David

