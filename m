Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D181CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 569928E00AD; Mon,  3 Nov 2025 11:57:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51AD88E0057; Mon,  3 Nov 2025 11:57:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409408E00AD; Mon,  3 Nov 2025 11:57:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2CF7C8E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:57:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CEA351601C5
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:57:33 +0000 (UTC)
X-FDA: 84069901986.10.8B89A76
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1FA381C000C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:57:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b5oNCpeX;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762189052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKtfTX6p+YHeic6n4Wv3jNDv9OpjNDhge2Ceh/S4hIY=;
	b=wvjac/bI9Q3R/gWFYURXqmwqVcFVLVaE75k4RMRKdyTV4UGFRH6pg0UErWcgoObGcw9zYJ
	ykSK0L0kNNBTcW7llYn79TfvJV+57erfJzaanV99gum+N+P1f0CmTd561qATZzxqT5IU0X
	oRumjZc1Y5HIp6RLyHtNXvMUl4AyHWg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b5oNCpeX;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762189052; a=rsa-sha256;
	cv=none;
	b=ZQL8FctPQxB5tsyYUdrLmiEV6XDTU+zRLBOjb4/HpGcixGWaW+XUp9E60sCCvER1W0p3Lu
	C3RUqVMArBstw2mYPEozb3jY5Q20/DjJHh5KhmAkGjMVtQOLPybmgIJ5/E3SAEC0bzvYHN
	gSDB0isO+WjR328y4N2Os39ctkFh2ok=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 86A4460139;
	Mon,  3 Nov 2025 16:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564D7C4CEE7;
	Mon,  3 Nov 2025 16:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762189051;
	bh=UXbyL0c4gAKXyaDUG6J01Z7qz3xy2A7gPJAePIXHk4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b5oNCpeXpk2uZyGZqBHEsvT/hu0avc8wvFDKDf/GNIctuNY4LZzu7oKF3BcrtP152
	 krdL00sj+nAvuQJ7luVVgQZBHtZLG+ESOvSYRXYtd9okIy9M1kuE4DJ8+BtrrOcay0
	 hxJtbn+ZQSFnv5Dk4evrInz5BKWwCvw9qLMCNPM5TgR9adqRa0ua75zNlC15uhXUyq
	 arfewDLc70AnhMi5JT+O/G3ShaUUNkej4oHy9sxxYAunMtwrAlnlKxfiC9kME8LDXe
	 wpfQqZFeNAEnF+mJNTKDYKMtOdbaWXl14nGiYny7DOAMOLe9+1892E8GGaFEn7AtvV
	 C8V3fDWrEBf9g==
Date: Mon, 3 Nov 2025 18:57:24 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: fix out-of-bounds access of vmalloc chunk
Message-ID: <aQje9CFnTymbkUlM@kernel.org>
References: <20251103110159.8399-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103110159.8399-1-pratyush@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1FA381C000C
X-Stat-Signature: 8kudgacakwik5jh7w48ryeikdip1msp8
X-Rspam-User: 
X-HE-Tag: 1762189052-163234
X-HE-Meta: U2FsdGVkX18rhaS/S6RLnVaSaC8rvlC4jZg/ZvHzTBfFWf40wHlIjlwLUrFFJDHhA/v8DgiJHMuUhX57pnY4RTIpOxAkFCTDm05Qx73HKSiP0pf0ItQqaZ+cSgK3AX4aS4K2ESnTZy9EQ56YSJX76Ke8bnTExjVWr1tfnirWnfW/JQlTu/9S6muizbgd3kWj/wfSua5N25VUKuYs7rWgHjSjhYubdm/dd2f0/ZPBCufIzS3Fa7kJJ+htDYs0kUZUtnyU9fbc1qWmBorDAC3wYIDaJ7pfmDPeJN3MFnMKXLWuRkF7aZVQRCxLAhGHythKhnJWIs4E/ITGiN2itkmCZHfsh1Ng8qKXgo6w9CAkSfBzV4WZ6Cc1lFADfmAE7N+UZCEr9/kSXmm5shIpc7qQ8c7TNgv4FtqP28r7Aey1PeoL2Nize+UsOjeHY6u71ktOk7Y7jg2L2sejEHs2EIytKpOkXN39Zyy+5PS688yXxjCr+lB0wRuXVOCDTUhqcbTbjYU7TiSygvnr0FUTIioZg+eFNPSHub38hCoLrZWrKIha+WEZHquG2G61ZZ9SyLIG9lfWQQWkw4oUXvreJ1OKtGtWfMRQVwdCpNPIRFmcQiRXa5wv1nGFhkbM0O5vpjyjvQp5r22ZY8Ss8Ie2u3laANc77QL9hUglVKYBFNHkNWt5yVh/nTbED8X86WlHuwpLl92MF20cg/QyKQTjEs+tf/ge5cTVpV2rWU8s+2TNgE2Mdsv3jivPq1cLDazkWFLqZ4JBeW3m2RUo4qlxdTOSVZWaVomWu/U8Zpq1yf1M8C7fphLGGx9jvEI65AEiCbadhTyz0Urrhr3asMdD6TD3J8w4USf6JxG9eZfaMLLn2/hPFUAxSYe43UeC8loiumrjqyIQfgIvrROYRSHN8Xz36suuZtWaNHqL2q47H0EWb1JXb1MjwMlRir/yUpvsXTeCYe7BXwt+U5A5dpNq6cn
 u8afNjED
 zRl1VMY06u+bUs452cRRcshEUFloQO9FS3Fy/Q70GLmO350IlLJHet8yJBG2+cXjhrM9+y2bQm8iOW9VBuuh3nAga3r6SSMqTpQ+29FS2bH7cfHQj1qpVOnHfsA8YEJ+/mkM0QUFaqqIjgqg0xIBauZIZ+vWNR2lB8mv9pq8uO4gOfbVRYie2GjjteYhcn1jPFcu2RpAGxYllef90aM9ZmB5Y4seIqF4/2aev85IyNxY0B2UcCCidNLa1cbKajplMr3eMrnu/qFM0NQQtuQVmDBcLgnEkdYoGd1oP6Gqyia8KciJMMUEpWdhchw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 12:01:57PM +0100, Pratyush Yadav wrote:
> The list of pages in a vmalloc chunk is NULL-terminated. So when looping
> through the pages in a vmalloc chunk, both kho_restore_vmalloc() and
> kho_vmalloc_unpreserve_chunk() rightly make sure to stop when
> encountering a NULL page. But when the chunk is full, the loops do not
> stop and go past the bounds of chunk->phys, resulting in out-of-bounds
> memory access, and possibly the restoration or unpreservation of an
> invalid page.
> 
> Fix this by making sure the processing of chunk stops at the end of the
> array.
> 
> Fixes: a667300bd53f2 ("kho: add support for preserving vmalloc allocations")
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> 
> Notes:
>     Commit 89a3ecca49ee8 ("kho: make sure page being restored is actually
>     from KHO") was quite helpful in catching this since kho_restore_page()
>     errored out due to missing magic number, instead of "restoring" a random
>     page and causing errors at other random places.
> 
>  kernel/kexec_handover.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index 76f0940fb4856..cc5aaa738bc50 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -869,7 +869,7 @@ static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk)
>  
>  	__kho_unpreserve(track, pfn, pfn + 1);
>  
> -	for (int i = 0; chunk->phys[i]; i++) {
> +	for (int i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
>  		pfn = PHYS_PFN(chunk->phys[i]);
>  		__kho_unpreserve(track, pfn, pfn + 1);
>  	}
> @@ -992,7 +992,7 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
>  	while (chunk) {
>  		struct page *page;
>  
> -		for (int i = 0; chunk->phys[i]; i++) {
> +		for (int i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
>  			phys_addr_t phys = chunk->phys[i];
>  
>  			if (idx + contig_pages > total_pages)
> 
> base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

