Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB661C79F82
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 02:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AD926B00BD; Sat,  5 Sep 2026 22:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95E536B00BE; Sat,  5 Sep 2026 22:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8287A6B00BF; Sat,  5 Sep 2026 22:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5820D6B00BD
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 22:00:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D34AA80445
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 02:00:35 +0000 (UTC)
X-FDA: 85181683230.16.6B3C682
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1AB3640003
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 02:00:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=onvqGLmc;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788660034;
	b=hoXde2vMMuH4z8jrtoLi9fe5rEeBoZMreZ8aDZYHJ7xHKInFUBH4qQy6RS6IyzRfY2wOEc
	Okyd5VEzUrcGClS6Vcg4cUEoU0j26zvNze6I9mu5FKu0KiFnntxSfbKU3tZ7g0mwZAqKpg
	UGbTx8eA5IWbDbSHqoLjWUI1cvBZY0M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788660034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ohXcpCjF3E8Su2iGbnUTFcKH4Q5PX6bz9vn2jqgCP+c=;
	b=eydI2Yoc6OFfdRgHIFdYV+SrwS94wwk4t6DnMBxCNEXVg0jkw8GER05NMG+SHcYmcJQEsX
	aKnqqpu3C6FGGeNQ59zlmygGciJrzCgrglk93mGSARKRoK8HbiBGanDZ6cMm/R2sFR7M+v
	YDjCItn44egBOuZupsdNBpywcrJa+Z8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=onvqGLmc;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 54CA343C12;
	Sun,  6 Sep 2026 02:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131AD1F00A3A;
	Sun,  6 Sep 2026 02:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788660032;
	bh=ohXcpCjF3E8Su2iGbnUTFcKH4Q5PX6bz9vn2jqgCP+c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=onvqGLmcP1GLOxpEKfzU67JdQE7IDZGMsPO64h/0NSOK+RvFXdBCqD8+ofD1WBq2g
	 i6cYyIHzjygejYh8PKFLzFY7Ac5zL8dW6mlFYoHExtDtLuDxudvpRUkwCZVnaHxKoG
	 FWNotUDCuJBgzmpoHcxnORH4VODmerRMAERbMW3I=
Date: Sat, 5 Sep 2026 19:00:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Adrian =?UTF-8?Q?Barna=C5=9B?= <abarnas@google.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Alexandre Ghiti <alex@ghiti.fr>, Andy Lutomirski <luto@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Brendan Jackman
 <brendan.jackman@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, David Hildenbrand <david@kernel.org>, Gerald
 Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Len Brown <lenb@kernel.org>, Palmer Dabbelt
 <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Pavel Machek
 <pavel@kernel.org>, Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin"
 <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>, Ryan Roberts
 <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>, Thomas
 Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, Vasily
 Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>, Will Deacon
 <will@kernel.org>, x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 loongarch@lists.linux.dev
Subject: Re: [PATCH v3 0/6] arch, mm/execmem: resolve confusion about
 set_direct_map_valid_noflush()
Message-Id: <20260905190030.adf2740822e211ddc028a24a@linux-foundation.org>
In-Reply-To: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1AB3640003
X-Stat-Signature: 5d8hno4c6qeop7nih8owcizoz1j7nuqk
X-HE-Tag: 1788660033-95878
X-HE-Meta: U2FsdGVkX19fB9bXZM38roGObM/1jyBmMGCeeR5koC5lCmU9+sGjhtJCoi/R0a1oB43f9ImTYzz4Nb33cD/lmBEjckYTy0LiXt/XLFePvx85A+0GuNy52NYa3WvJxfAEWOkpcBXOWMGBd02JqlMg3rCYsdZ6NfXbSM9nfT/VRZd1kcPBe0C0QCZl5FzuKgnKCC5yXssZg+x5zAqXkxCNtxJIdTuMayRTVXbO7W/LP8xQnqngLLT1kgG0Pkt1MI67hcdgKW01yDb729aLSgPdOOC5ZcxReMw1ce2bDCktKxbR+fTsb0Oeyv6vDRibZRMDux6vHsP2RqIY67FNJ2VhydJ3pQJs0krtv+09xTf4KNnxopijjwun4RCqLPZSVJDbv4BjspFQE2HrwOUd6yZ4Ci/LMYxp8XXw/5LBtv8cmC7GpWbThH6dvvr2noZf60xCxhSd7sXap0OaaDbfXTsfL1qabKHLjNangMLBcJGYK8f//pPG2M5oTR27DWA0kTDJ1A2swZXXgZVzFwur668gTpKm4PWrQLX+cz/Nb+8z0iwvMKIFchpybbms8kxxuLn4nKKfkeTZqqRtiRY4DgWMrfA/h/Vq3XdVYhsvVSMjFtuyQaYZXAq0QRDulqhbIIwHPgazZAjCIgK9+srspuKMgsOuJly6JqUE8bp8Px4rYSXEQk+BRCMHXsu7lQZF0hWyfTBHoq7TqRANjy9jxh3ZQ/qp9Ws+04ScfGtEYa50zcqUBS1vpcc8hjtMgsOYQPW9s8hdNxi0bzVsSbGSrRTq2kPZ00pJqJuiTx9GSy03Gq7HUDa9a1ix4S7lXKD2UVCeX7LPWbN/g5E7yuI7+4WoxjyZ8O3EEeaRgrd4SGe43F0Z0XKaIEpsyGOSJTnKyiw3Cp0tiQKVNLw61z00pHv8xWO33p3jafel8RlFoiPgBHP7J/DGsc871TLFhV53RRe1aBcr5SjMDo4v/aZ8YHS
 BEoHbBFW
 GT6BM++AK3u3LbSHkvSoRAFN08VwLScWadrmhEhyVKfifmsn6FL3nWpvBZJQgd4Z9147B98Qco9CZENyfxUrpiMkrNLCiubhuO+PYyVs8HoTurVnjAHOE6rE7sJcce4saqjh6bsQsoLKnafBwI2ZKAyaGg0IS2J9lvcTZfFLW5WlWyaj49TClBXuMMjm1U+RBgXdMv1irOHkUPH8bnAlyYwLAgezNTXE5VBrmxgssCX2DhWd8VwJhe8U3KKWi0ZARtsSZssfgH7lXq62WUfC7vxp2dhJnpg87rhPTEefih3HSKZzT7bEqLbdHSQy9sd81mzM3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 03 Sep 2026 12:28:26 +0300 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> Recent discussion about implementation of execmem's ROX caches on arm64
> revealed a confusion about how set_direct_map_valid_noflush()
> implemented on different architectures.
> 
> ...
> 
> Implement these adjustments, make execmem always use VM_FLUSH_RESET_PERMS
> and revert set_direct_map_valid_noflush() changes.
> 

Thanks, I updated mm-unstable to this version.

> 
> v3 changes:
> * set VM_FLUSH_RESET_PERMS to allocated area just before flipping the
>   permissions rather than at allocation time
> 

Here's how v3 altered mm.git:


 mm/execmem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/execmem.c~b
+++ a/mm/execmem.c
@@ -36,7 +36,6 @@ static void *execmem_vmalloc(struct exec
 	unsigned long end = range->end;
 	void *p;
 
-	vm_flags |= VM_FLUSH_RESET_PERMS;
 	if (kasan)
 		vm_flags |= VM_DEFER_KMEMLEAK;
 
@@ -277,6 +276,8 @@ static void *execmem_cache_populate_allo
 	/* fill memory with instructions that will trap */
 	execmem_fill_trapping_insns(p, alloc_size);
 
+	set_vm_flush_reset_perms(p);
+
 	err = set_memory_rox((unsigned long)p, vm->nr_pages);
 	if (err)
 		goto err_free_mem;
@@ -439,6 +440,7 @@ void *execmem_alloc(enum execmem_type ty
 {
 	struct execmem_range *range = &execmem_info->ranges[type];
 	bool use_cache = range->flags & EXECMEM_ROX_CACHE;
+	unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
 	pgprot_t pgprot = range->pgprot;
 	void *p = NULL;
 
@@ -447,7 +449,7 @@ void *execmem_alloc(enum execmem_type ty
 	if (use_cache)
 		p = execmem_cache_alloc(range, size);
 	else
-		p = execmem_vmalloc(range, size, pgprot, 0);
+		p = execmem_vmalloc(range, size, pgprot, vm_flags);
 
 	return kasan_reset_tag(p);
 }
_


