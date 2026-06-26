Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E9FAC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 17:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7B136B00A6; Fri, 26 Jun 2026 13:46:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50176B00A8; Fri, 26 Jun 2026 13:46:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68606B00AA; Fri, 26 Jun 2026 13:46:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 903256B00A6
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:46:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 198DE8ED8B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:46:30 +0000 (UTC)
X-FDA: 84922793340.01.E1292EF
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 27665100016
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:46:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=bxEQWhB3;
	dmarc=pass (policy=none) header.from=asu.edu;
	spf=pass (imf05.hostedemail.com: domain of xmei5@asu.edu designates 209.85.210.177 as permitted sender) smtp.mailfrom=xmei5@asu.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782495988;
	b=QK5rPrcUPsbCttcf/IH5W/pkMlGHgCC6X6f/A6vakqZXgAA+9U804dIO2tg/VQgVaZh2IZ
	IVzojQArvgRJg5N7H8U1o6lu+10OtFFh5fMb+6OESFa32s8TRSP7fR9h3xwEqmTcnLAz+U
	UWD/7IrECfq4CDnBPnCqCXwAzHWfqnM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782495988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hYdU2INu7hZoMU5N3uXMCRXJgZo0rwNDYyNP33ro2pk=;
	b=SgU8W4opDMdMAyJbVW4lECZfIAo/KwO966twMHlKsE56kAOCYs/o55IhPcqeveiTAJvj2A
	lUPWmYYWJINPsUaVSJ1bIdYMrRWR6cOo5MDDBpcmW48XQEiB6fAyCHZofWpUYS9S30zBJc
	5eNhSdcPrGpKT2MuA5JMte26Gu1ku6A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=bxEQWhB3;
	dmarc=pass (policy=none) header.from=asu.edu;
	spf=pass (imf05.hostedemail.com: domain of xmei5@asu.edu designates 209.85.210.177 as permitted sender) smtp.mailfrom=xmei5@asu.edu
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-845c38dee22so656279b3a.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782495987; x=1783100787; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hYdU2INu7hZoMU5N3uXMCRXJgZo0rwNDYyNP33ro2pk=;
        b=bxEQWhB3ebp7YEmI7Fjieu2ipknLWEzhDUNVNo6Y/ndTv7ifxknEiOqXFZoiE6hMZS
         2cgTcAP5w/n3zdXGRsDz37krlD7NrqlaNBG8/DFXqsLYTL+sUVtV8TwJbuY3ouLtrCrG
         +OgXVlZXoLSOiXqI089DCod9FwEnQLrtbdwZ6LahUy3EPIgQ5lFZjllhgsfC1NmAqlic
         TO9KK5KD/g/+7oCt7iLnm0bW90OAIbW6rfc9zZmMmK7REWTxPPF0Y8Anv9L8uH4GWMfZ
         NP8x32n1nPEjFWQHU5PHbbyApcGveHN/9nCv7cUIENmtGEOsjoUYPlbU/d9wsiIurGd/
         lgcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782495987; x=1783100787;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hYdU2INu7hZoMU5N3uXMCRXJgZo0rwNDYyNP33ro2pk=;
        b=YVGyVAE6OdD7xyIG77GrDTQeeMn24C5MAEB8Uy6wGdpngoNuLbN9zP7bit0gsGdVo2
         vFgpcl9o4u0FQwTA7nq7grl9j4v83DzhQXdGReRC48zUZOuwZx3Owx9LPD+lpgy/qCsw
         p26PDM/k+ZNwZWKBU4qm4EZtvj54XkZor7OuhNlwlaMgU3BmVY+bmmqsLxIUY3wyEoJt
         dNlGZsXdoEqLGdQMJkH8UaHHXBT2e1gWpYwqDCW+jUu3sd7Buhv18s3WoNsJeZXlQ+Yw
         w4aIrTynSok60SGMjxmr4x0Gi9H/q6j++30xg92uU/GkklU1VVzz2VVmRUdb/cUX+p4t
         y0wg==
X-Forwarded-Encrypted: i=1; AFNElJ/woZkl+yzFpJO809leIDfWSIlreQKhTHNbtUaqs8z02mFzzYAUjoFS+4lycdW/W1MUciyYTlKzRQ==@kvack.org
X-Gm-Message-State: AOJu0YxhLmhtmgmT2HmhmwCVyUnK9ckLFpjDC0PumDyCyshP33uDa0dW
	55RJ+czONXz+zocA+TtZJwE+bOuV07uNRXT4/wFv0qccydM4o3XQ4UbO+uiJ5y+sgg==
X-Gm-Gg: AfdE7cm8NAqXguwTYImSscoSjZmT2fTfAarYvaX7rrLC6zKp9XTlLV+IHTyWZPXRMpo
	6ljyG5gm5miPbKUjnTnw7g5cmh9PGSw2frzi+S5aKNLOPKxEoWwO2q7iPICsX5M5XBDqPcr5MHM
	3lKsK5Un7ROM3WJ6NXKevkWYtaJ9tU5grj0hjFFhmNMp4BcR3K3dKC3nW7DXsYgRo10Q90SOT1E
	1kOjS1EuV1HaprD7tCCZGImOlWDVCK4vDdB/tg7HCGZ86vVtDoBarxrl0KPcUc6hBj7FzOmk9d2
	xNj4au/TgRyiRFM6uXagR3CF6MpeQl8BF9/EMI43t6mkGr6WtCKHIRuAHJcpgWe0pJgGyTsZnVQ
	OrYJMtbdGAHeAcA1BF7kaHC1RUTDYIyU144rixQXdQjtlQEIZG9pDtq4NkUAT2qDA7iUa3jM=
X-Received: by 2002:a05:6a00:1810:b0:845:d2e3:263b with SMTP id d2e1a72fcca58-845d2e328c9mr1122732b3a.53.1782495986902;
        Fri, 26 Jun 2026 10:46:26 -0700 (PDT)
Received: from p1 ([2607:fb90:ec0b:1b9c:b43d:8c36:8c16:36f7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845c81922fasm1650394b3a.1.2026.06.26.10.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 10:46:26 -0700 (PDT)
Date: Fri, 26 Jun 2026 10:46:23 -0700
From: Xiang Mei <xmei5@asu.edu>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, linux-hardening@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>, Tiffany Bao <tbao@asu.edu>, 
	Ruoyu Wang <fishw@asu.edu>, Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>, 
	Yan Shoshitaishvili <yans@asu.edu>
Subject: Re: [PATCH] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
Message-ID: <yu6l7zo4dmqcnho7thkf7sk42lt6xkz6uxxwxmg73x23vihlnp@pe7vdut4o2jc>
References: <20260626173444.2252041-1-xmei5@asu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626173444.2252041-1-xmei5@asu.edu>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 27665100016
X-Rspam-User: 
X-Stat-Signature: cm9xtqqw35auc9sjcrcsmih4dohqrkj6
X-HE-Tag: 1782495987-997064
X-HE-Meta: U2FsdGVkX18SKi4+H+1zt00q4OHAlXbEbIFK6mCY/mbNehe9nKyXaFuxO8u9Q9cW/NxTT3JGnb4TCG44hshOYMahIafuTm0lI1XSmW6n5NThabH5c1aAfwaJEG7d2R+patWTNvwq6iaUeLVNxrjQzipibVKAc+QwpGxKgGopwWc/RIP6DTIuZrYdkEfXMHAoEGhaVWr9jo52WBjMTXPNVhw4svP3uL6JyFvEDCaicxPzTP0fWxbZ3qnhXpi9E7GznOpGlCL3zLR7JkMp0A2R0/A1zKj1RaoBsQu0RED6KUtJ5x5xn2BKIAHcCNicpGo9lPa/RGOe5dALRmM1kdNeRdXGdWyU16/HDfZcGNFuPl1f28E96Upowk2gjSa/lJEevARPBTtKETtWhPUn2qdXaTnxJaWHLulXh3doBqc6Jq+LkVaaX11fgZUNR0CH51JIewMSlCjax2+pDl3WI8w4rMcPz4e+xkzCxiiip3rG3wp/Afos8CTFY5vAZDv4/Pl9WJHDYirFDAnKwxNQcBmf8nZJxOH6G2WMx3/Gpoe/8T5F+4n+xx4HrkVNTP+CTSX35TO6RjYtrLq1glLiQ5mSJc8HUSql6L4XKccZPc76IR7Po04OUoifxN3yVk0G/cuVoTaTnrOvLvwrkY8WOcwpXnGYbKvtE5Dew/gSx6393+cxKjGKwvxCXPIQTUdXlg0YQIpyQTa7Bi9snjsfDOQ57v93PZVg4etm6EPWzThoCRQ5nFod9B2mWRXbm/dgdcA9o7jco0K33CKisaHem6rc7K360VQnSsGx+WGiMGwFZJCrQlMsRlIab4/Uw5nIUifg0MTJrK3ohcQRizinHVxRPPL4CW/ZXAfwqgPExCw0GOJGGQJTs+JXkefIl+FvWb3QEinPEGD4VinW5pEDzfxmNBRiGZHFvux1iE5k15zlOcFUzo17RTYJVCHobzEaWyqUYyRzoS+EVfDf7rMLucC
 vumOf5yH
 h4lgvFNshURi1e+N1WPDOsV4/SoZhXzwdUmme8oFuYMpKcpfqvNlABDOTjnjmRdW4/bpzhiharqaVJI7EPpK5E7NSdoRUARA6P4mr9umfP0tWI7ObDBb2TMH9onfkAr5CK6SBkELaY65H9TtIrNFuY5DHMalMfTO4TWU41UPSJY3p1FISiZ2w/rXbJaBQzFMhGidJziCc+qiZZJmXqAafv71ij8DPKnVcPKRuprGmfcNb4yroRCiFC/FDo15v9eoDXeiZXTDF17TSR9LP7mPjNdOZ8CJ64qDkVUkkKeL+TVPTPVGmD+QZatg9RJbQbbZ0502fUjyQCW+2xS/WiNSYyfYpMtAOhq2zPtrc4d0nFc46wKU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 10:34:44AM -0700, Xiang Mei wrote:
> With CONFIG_VMAP_STACK, kernel stacks are allocated in the vmalloc area,
> which an unprivileged user can surround with attacker-controlled data by
> spraying vmap allocations adjacent to a target stack (for example via
> XDP_UMEM_REG, though other vmalloc spray paths work too). Today each
> guarded vmalloc allocation is followed by a single unmapped guard page.
> 
> A single guard page is not enough to contain the x86_64 ENTER
> instruction used as a one-instruction stack pivot. ENTER imm16, imm8
> builds a stack frame and lowers RSP by:
> 
> 	imm16 + 8 * (L + 1),  L = imm8 & 0x1f
> 
> imm16 is an unsigned 16-bit operand (ENTER never raises RSP), and L is
> in [0, 31], so the maximum displacement of a single ENTER is:
> 
> 	0xffff + 8 * 0x20 = 0x100ff bytes
> 
> That is more than enough to step off the current stack, across the
> one-page guard, and into the adjacent sprayed pages. When those pages
> contain a return sled feeding a ROP chain, reaching any ENTER gadget
> (opcode 0xc8, abundant as both intended and unintended gadgets) turns a
> control-flow hijack into full ROP execution without any register control
> at the hijack site, making it a one-gadget-style primitive that
> significantly eases exploitation. The pivot happens after the control
> transfer, so it is not constrained by CFI (kCFI/FineIBT).
> 
> Widen the guard region from one page to VMAP_GUARD_PAGES (0x11 pages,
> 0x11000 bytes), which is the smallest whole-page span exceeding the
> 0x100ff-byte maximum single-ENTER pivot. A pivot off the top of the
> stack now lands in the unmapped guard and faults, instead of in mapped,
> attacker-controlled memory. RANDOMIZE_KSTACK_OFFSET only perturbs RSP by
> a sub-page amount, so it does not change the required width.
> 
> Introduce a VMAP_GUARD_PAGES knob that defaults to a single page (no
> change for current architectures) and can be overridden per arch via
> asm/vmalloc.h, and set it to 0x11 on x86_64. This is deliberately scoped
> to x86_64: the 0x100ff bound is a property of the ENTER opcode, and ENTER
> is also a one-byte opcode (0xc8) that appears as abundant unintended
> gadgets. Other architectures (e.g. arm64) have no equivalent
> single-instruction, immediate-controlled pivot reachable as an unaligned
> unintended gadget, so they keep the one-page guard and pay no cost.
> 
> The override is gated on CONFIG_X86_64 rather than applying to all of x86:
> VMAP_STACK is selected only on x86_64, so 32-bit kernel stacks are not in
> the vmalloc area and the technique does not apply there. 32-bit x86 also
> has a far smaller vmalloc window, where widening every guarded area by 16
> pages would needlessly pressure the address space.
> 
> The guard pages are never populated, so there is no extra physical
> memory and no additional page-table population beyond the larger virtual
> span; the cost is virtual address space and vmap_area bookkeeping, which
> is negligible against the 64-bit vmalloc window. get_vm_area_size() is
> adjusted by the same VMAP_GUARD_SIZE so the usable size reported to
> callers is unchanged.
> 
> On x86 this widens the guard for all guarded vmap areas, not only thread
> stacks. ret2enter targets the stack specifically, so a narrower
> alternative is to apply the wider guard only on the thread-stack
> allocation path via a dedicated VM_ flag; we kept the change in the
> common path as defense in depth for any vmalloc-adjacent pivot target,
> but are happy to scope it to stacks if maintainers prefer.
> 
> Signed-off-by: Xiang Mei <xmei5@asu.edu>
> Signed-off-by: Jennifer Miller <jmill@asu.edu>
> ---
>  arch/x86/include/asm/vmalloc.h | 21 +++++++++++++++++++++
>  include/linux/vmalloc.h        | 16 ++++++++++++++--
>  mm/vmalloc.c                   |  2 +-
>  3 files changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmalloc.h b/arch/x86/include/asm/vmalloc.h
> index 49ce331f3ac6..2c341f398227 100644
> --- a/arch/x86/include/asm/vmalloc.h
> +++ b/arch/x86/include/asm/vmalloc.h
> @@ -5,6 +5,27 @@
>  #include <asm/page.h>
>  #include <asm/pgtable_areas.h>
>  
> +/*
> + * The x86 ENTER instruction can be used as a one-instruction stack pivot:
> + * ENTER imm16, imm8 lowers RSP by imm16 + 8 * (L + 1), L = imm8 & 0x1f.
> + * imm16 is an unsigned 16-bit operand (ENTER never raises RSP) and L is in
> + * [0, 31], so a single ENTER can lower RSP by at most
> + * 0xffff + 8 * 0x20 = 0x100ff bytes. With CONFIG_VMAP_STACK the kernel
> + * stack lives in the vmalloc area, where an unprivileged user can spray
> + * adjacent allocations; a single-page guard is too small to contain such a
> + * pivot. Use 0x11 guard pages (0x11000 bytes), the smallest whole-page
> + * span exceeding 0x100ff, so the pivot faults in the guard instead of
> + * landing in attacker-controlled memory.
> + *
> + * Restrict this to 64-bit: VMAP_STACK is selected only on x86_64, so 32-bit
> + * kernel stacks are not in the vmalloc area and the technique does not apply.
> + * 32-bit also has a far smaller vmalloc window, where a 16-page-per-area
> + * widening would needlessly pressure the address space.
> + */
> +#ifdef CONFIG_X86_64
> +#define VMAP_GUARD_PAGES	0x11
> +#endif
> +
>  #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
>  
>  #ifdef CONFIG_X86_64
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index 3b02c0c6b371..b8546e519deb 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -49,6 +49,18 @@ struct iov_iter;		/* in uio.h */
>  #define IOREMAP_MAX_ORDER	(7 + PAGE_SHIFT)	/* 128 pages */
>  #endif
>  
> +/*
> + * Number of unmapped guard pages appended to each guarded vmalloc
> + * allocation. The default is a single page; an architecture may override
> + * VMAP_GUARD_PAGES (via asm/vmalloc.h) when a wider guard is needed to
> + * contain a worst-case single-instruction stack pivot into an adjacent,
> + * attacker-controlled vmap allocation (see arch/x86 for the ENTER case).
> + */
> +#ifndef VMAP_GUARD_PAGES
> +#define VMAP_GUARD_PAGES	1
> +#endif
> +#define VMAP_GUARD_SIZE		(VMAP_GUARD_PAGES * PAGE_SIZE)
> +
>  struct vm_struct {
>  	union {
>  		struct vm_struct *next;	  /* Early registration of vm_areas. */
> @@ -236,8 +248,8 @@ int vmap_pages_range(unsigned long addr, unsigned long end, pgprot_t prot,
>  static inline size_t get_vm_area_size(const struct vm_struct *area)
>  {
>  	if (!(area->flags & VM_NO_GUARD))
> -		/* return actual size without guard page */
> -		return area->size - PAGE_SIZE;
> +		/* return actual size without guard region */
> +		return area->size - VMAP_GUARD_SIZE;
>  	else
>  		return area->size;
>  
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index bb6ae08d18f5..8bb2b3ef40a8 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3217,7 +3217,7 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
>  		return NULL;
>  
>  	if (!(flags & VM_NO_GUARD))
> -		size += PAGE_SIZE;
> +		size += VMAP_GUARD_SIZE;
>  
>  	area->flags = flags;
>  	area->caller = caller;
> -- 
> 2.43.0
>


Hi hardening team and maintainers,

This patch widens the vmalloc guard region on x86_64 to close a
class of stack-pivot primitive against CONFIG_VMAP_STACK kernels. We would
like the hardening and mm/x86 maintainers' view on whether this belongs in
the common guard path or should be scoped to thread stacks.

The description below is intentionally theoretical: it explains why a single
guard page is insufficient, without operational exploitation detail.

Background / threat model
=========================

With CONFIG_VMAP_STACK (the default on x86_64), kernel thread stacks live in
the vmalloc area, which allocates roughly linearly. In principle an
unprivileged user can place attacker-controlled vmalloc allocations near a
target stack, the vmalloc area exposes several allocation paths reachable
from userspace, so at the moment of a control-flow hijack the live stack
can be adjacent to attacker-controlled mapped pages.

Today each guarded vmalloc allocation is followed by a single unmapped guard
page. The guard relies on the assumption that a corrupted RSP cannot jump
far enough, in one step, to clear the guard and land in the next mapped
allocation. On x86_64 that assumption does not hold.

The primitive
=============

The x86_64 ENTER instruction (ENTER imm16, imm8) builds a stack frame in a
single instruction and lowers RSP by:

    imm16 + 8 * (L + 1),  L = imm8 & 0x1f

imm16 is an unsigned 16-bit operand and ENTER never raises RSP, so a single
ENTER lowers RSP by up to 0xffff + 8 * 0x20 = 0x100ff bytes, which is more than a
page. A single instruction can therefore move RSP off the current stack,
across the one-page guard, and into an adjacent vmalloc allocation.

Theoretically this matters because:

  - The displacement is attacker-chosen (via the immediates) up to 0x100ff,
    so the pivot can clear any guard narrower than that in one step.
  - ENTER is reachable as a gadget, so a pivot of this size is available
    without depending on register state at the hijack site.
  - The pivot happens after the control transfer, so it is not constrained
    by forward-edge CFI (kCFI / FineIBT).

Taken together these make it a one-gadget-style pivot that generalizes
across control-flow hijacks: because no register control is required at the
hijack site, any control-flow hijack able to reach a single ENTER gadget can
move RSP into an adjacent vmalloc allocation. The net effect is that a single
guard page is not a reliable boundary between a pivoted RSP and the next
mapped allocation on x86_64.

Because this lifts a generic primitive across control-flow hijacks rather
than easing one specific bug, we think the guard itself should be widened so
the boundary holds regardless of the originating hijack.

We have a working proof-of-concept and are happy to share it privately with
maintainers; we are keeping the offensive details off the public list.

The fix
=======

Widen the guard region from one page to the smallest whole-page span that
exceeds the worst-case single-ENTER displacement: 0x11 pages (0x11000 bytes
> 0x100ff). A pivot off the top of the stack then lands in unmapped guard
memory and faults, instead of in mapped, attacker-controlled pages.

This is scoped to x86_64 via a VMAP_GUARD_PAGES knob that defaults to one
page (no change for any other architecture) and is overridden only under
CONFIG_X86_64. The 0x100ff bound is a property of the ENTER opcode, which is
also a one-byte unintended gadget; other architectures have no equivalent
single-instruction, immediate-controlled pivot reachable as an unaligned
gadget, so they keep the one-page guard and pay no cost. VMAP_STACK is
selected only on x86_64, so 32-bit x86 is excluded as well.

Cost: the guard pages are never populated, so there is no extra physical
memory and no extra page-table population beyond the larger virtual span --
only virtual address space and vmap_area bookkeeping, negligible against the
64-bit vmalloc window. get_vm_area_size() is adjusted by the same amount so
the usable size reported to callers is unchanged.

Open question for maintainers
=============================

On x86_64 this widens the guard for all guarded vmap areas, not only thread
stacks. ret2enter targets the stack specifically, so a narrower alternative
is to apply the wider guard only on the thread-stack allocation path via a
dedicated VM_ flag. We kept it in the common path as defense in depth for any
vmalloc-adjacent pivot target, but are happy to scope it to stacks if you
prefer.

We would like to hear your feedback and suggestions.

Thanks,
Xiang
 

