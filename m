Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A58EFCC9A5
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 01:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA5726B00A9; Mon,  9 Mar 2026 21:06:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66A36B00AA; Mon,  9 Mar 2026 21:06:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65C76B00AB; Mon,  9 Mar 2026 21:06:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3E06B00A9
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:06:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D9AA160442
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:06:22 +0000 (UTC)
X-FDA: 84528362604.25.DCED592
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf20.hostedemail.com (Postfix) with ESMTP id A124A1C0007
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:06:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZhJ8luCh;
	spf=pass (imf20.hostedemail.com: domain of 3i26vaQYKCHoqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3i26vaQYKCHoqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773104780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/pJjCJQTxqUtKgBQ/nXqQmMajRmz8+Q8yoKiNddz8s=;
	b=GSbs3VvTMFuHMw9oA/YAVvIiBhrlxlEk3ichzrTgPs0HYR8oFxOohEtXugLzZn/sDk9JNT
	cpsLAiUBCjD7XTYUEe8PLU6/MH2UQZSEPmhuyM1ZZ1oTOnaxm6SZXbD0QDdVJmRWcScxjp
	Dlu3qKHVVBR/hB9SksDWm/vx5lCZLWE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZhJ8luCh;
	spf=pass (imf20.hostedemail.com: domain of 3i26vaQYKCHoqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3i26vaQYKCHoqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773104780; a=rsa-sha256;
	cv=none;
	b=dbRjUH9bd+wpn7G+RdqzI4kvzAQFgmxdLVZWzbPp4rLw/KMfGJIssClXV+AIqwXfSP7NUM
	AQ2hLzpFqHqoYHbNU5OEX0mCo7baDGUnDI4oOqf0IG9N0A7AL2AUIAO2oqDBxPUCfnclVA
	EgQqQ+09IcSf0RZERyME8jEiCVShSxI=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8298b363fb6so12599165b3a.0
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 18:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773104779; x=1773709579; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O/pJjCJQTxqUtKgBQ/nXqQmMajRmz8+Q8yoKiNddz8s=;
        b=ZhJ8luChmS6aYF/k8LCqdTa14+GPRItQeWgl8MhLVtXMTleqpqwewB5dDmHKLPVRgZ
         S8zUQE7lghbsxNrQshBsYQWTIH03tHBULFXkuTwwTyflNiw6A+WrQlPSnonfplyeV619
         21gbZ6dmnysM+YH/PdnSZoAInR9m3y6fDK2zbMUf6Wu4xPTJ+0dajx0dbJV+2yrM0xqz
         lI0eMdh6c/42MGW9KskPEasUL+u8FKRfPid/iOteQP1p7jO2ecB4lEFYTWQtbsHOU5No
         VF6gAIFj5VmQWbWjK4zGW5m4phifiKDZMWe7JWOtGiS6BHt8OCxltIjZcaGDCSUA/aDY
         YhOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773104779; x=1773709579;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O/pJjCJQTxqUtKgBQ/nXqQmMajRmz8+Q8yoKiNddz8s=;
        b=hTiFmaUmJlvd43TxeNX00bZKaVQDjd9HxipgCj3jcvaExqcR+7HCST4MQ5nj+XmQx1
         fU8QUmsVwaPpVRTl1qqPlxcqRrBzbMaI+8kH/xUodBthwrSvM7dY0DQ/SyDYageNBR0S
         qiFriGiGjWgXSaMSWJ6YC68oOqfEu4OPQmL7KgTL0EWjGwsMATLloZyNt6sgu1HV5brr
         hoiBohvDYvuuRT7YiETRcaX2aOSaY4cDSR98NsQSpHs+CqhuFgpZhzSHBGuolUjY+gMJ
         R/FSY95j0Ea2SNeF580YnE814f2LkMTm90XIZGinQvYAS7zHBZ9hN3RScNDwfX2wybee
         9YTg==
X-Forwarded-Encrypted: i=1; AJvYcCVTncunHF2eyPUmMOen5rRrjrqHPn1uE9sHAvM7pNPaBSchhm1VRJzXt2zSZ7UJUHvqwYMvA7X2VQ==@kvack.org
X-Gm-Message-State: AOJu0Yw97HHZGRf8MTPZ9RKC/YdI5mwutr/0PWOpac9uCB0cYAaIYtNW
	VJcj6x4f+ek13RsCTro6cHhpR9SWkuGGp3UxLq4qZQycyzDchiQ0XhVZhAEgC51ai+GJZ7t/4uC
	JLcCzpw==
X-Received: from pfld9.prod.google.com ([2002:a05:6a00:1989:b0:7dd:8bba:6393])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3d98:b0:827:3307:170
 with SMTP id d2e1a72fcca58-829a2eaad00mr8915615b3a.37.1773104779156; Mon, 09
 Mar 2026 18:06:19 -0700 (PDT)
Date: Mon, 9 Mar 2026 18:06:17 -0700
In-Reply-To: <20260309-gmem-st-blocks-v3-2-815f03d9653e@google.com>
Mime-Version: 1.0
References: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com> <20260309-gmem-st-blocks-v3-2-815f03d9653e@google.com>
Message-ID: <aa9uiQ_KBcX7X0My@google.com>
Subject: Re: [PATCH RFC v3 2/4] KVM: guest_memfd: Set release always on
 guest_memfd mappings
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	rientjes@google.com, rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	shivankg@amd.com, michael.roth@amd.com, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: A124A1C0007
X-Stat-Signature: kcm3cqse6fmwqc6fwubu6crsd9acqrdu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773104780-681194
X-HE-Meta: U2FsdGVkX19XOgrxY8mKm+pfR17Y4KeGfXqAsmyOqRIRlB+Rd8bcIcaOgTDFHZ/yXCaI4iaJDweT7eoYiHNU9OZ2VPVKJ2jTxZ8eWVVkSOzroXta3aET24ABqMWR2QkGVAYG22hxaWtlRcpcGyc4HnkNp1NmfoI3lphxWHmN3Ea2fhzxMyaHapGTdCAt6+l/ALTnZs/k5gYUOFrlT6Dw/Ptq8dv5rpNxVFCZv2RPh9QtCdKKKHtDsXGEQUv9bzcdZa7k3zQtyEJ54qNtzIVSyA5lLfxLfac1bBFnL2HKq3dkwQHkpnVKtsTGjiVnwoRj/bUQ9srnvwV4ZyhlYxhZ5AtZ5xfL8wsBPQ4aruAkjRx8aGShEKT52AcE2zZxJESCQXBTp3HzCn2lGRWCm9lr/rgdWvtTmDoZmLvf/CcaWw0bNyv9L3+VRZlWtnuPrEIxujWKpGTwo/PV8vOFTQY0OUDcupLMqLZKe30xECZ5/XSWxqj9M6SgY4WiKsUWi9hUeXyz0jRdhAcu718jk3hdWFC5BiXa0OB44Q7kKGhQ2mUC3kdtm69oo5hnIDmJdmF2xsf1fWZi+xhBI+e8nlDZ5ia81kKVWN3bi7Gyrrd9EjlmOvwlskBvTBxDIln0+N8RVymg9jkrM1jXHkO3ZN1fQDRpBa5VUAM0zl1PwXlAmdI19Js3dEA6YnFUCgizFEy0lP7qSvdMd0ICNZa8gRp5x9icU/EgmSzhoc2MQC7xEvR8Vxe7P112pHUKYcp8Q/9C/8pvdsUVPrfQhoTVuZhQ0Q5UNGVxQBV6vZ+JkX+OTPCodHxMxtVJ4YXGC6q06+h+KWutYtY7o6Jsc/gwpGsCSnSPus73WtVbC9EhmSH2dZNYqVoRSr1X6q7Dli5AuNwVvRl6QZ13XW8W35mO5Gj7WLWeiqE56ywhlJbUp9SAXYA8UNNoGqMQahMQ9h5WOG0Lhstyl576QeundWmkt7+
 /Y01hQGO
 6EFrPKQimS8FceTgbtTK3pd1CdWJ1TZyFMA0CJtpgAvPWd3zJ8xMo+ip7Odtq1tmtxVSy+yhvMpaYg4cxR5SXhKODr8m+KdwXnzEuPI65L+P7EoBl0j9LPCGqa+aZW1sKhETz67zuVvkq/laFxAZOO3RLDwl9BJ5sTmVRh17II9gEIx38nuvFylFpdxU2XEc+GBle3w6PIuz43P1nSYumUi0mpl9FW1JRLTykVNsJKc1yIUFVwBL4paVtbvRWOjKgMv74CALlr4Xk7vxAvlvrdpDIe+7qUk85YU3F5uZxUNox5L1brmF46jO1Qiy6JFyD40y3LhEync0KgzDnPSPGcncc4qQvqNoC0U5toQqDaD2tiVz69I0IAcDwGSlF7TeqA7//uogaDVihR61Twv42ikl1r8dZyxduz365JKWqlz4bb5k/00lVXDWesRtAwwtscILyCt0k0f/huiHHqH8m1w/P5WwjYdgxwiC/jyB7aGbEfWLC/XLgA8n3oWXgSU2xFKCUaKv20Dmq03Va+fkzggxA0Bqb2V3Oa28/FtOvytdE9EvbqUFV15fAgSXRiE3QTCvYbDmEMnGfb9vRnkT6TyrnvHq3wl14TH8Ft6NFdOQi3bARBp4J3kAnAouhep5R31OdbKKbeFqRr4SF1/oBda4iQPdvJatQl9zxui8E2yOCCYcR0qIEXSx7sdr8yYE+vi0MhLKVJ0WhIxpGwm5/bOfAOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026, Ackerley Tng wrote:
> Set release always on guest_memfd mappings to enable the use of
> .invalidate_folio, which performs inode accounting for guest_memfd.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  virt/kvm/guest_memfd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 77219551056a7..8246b9fbcf832 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -607,6 +607,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	mapping_set_inaccessible(inode->i_mapping);
>  	/* Unmovable mappings are supposed to be marked unevictable as well. */
>  	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
> +	mapping_set_release_always(inode->i_mapping);

*sigh*

So... an internal AI review bot flagged setting AS_RELEASE_ALWAYS as being
potentially problematic, and I started poking around, mostly because I was
curious.  I'm pretty sure the exact scenario painted by the bot isn't possible,
but I do think a similar issue exists in at least truncate_error_folio().  Or at
least, *should* exist, but doesn't because of a different bug.

On memory error, kvm_gmem_error_folio() will get invoked via this code.  Note
the "err != 0" check.  kvm_gmem_error_folio() returns MF_DELAYED, which has an
arbitrary value of '2', and so KVM is always signalling "failure".

		int err = mapping->a_ops->error_remove_folio(mapping, folio);

		if (err != 0)
			pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
		else if (!filemap_release_folio(folio, GFP_NOIO))
			pr_info("%#lx: failed to release buffers\n", pfn);

I _think_ that's bad?  On x86, if I'm following the breadcrubs correctly, we'll
end up in this code in kill_me_maybe()

	pr_err("Memory error not recovered");
	kill_me_now(cb);

and send what I assume is a relatively useless SIGBUS and likely kill the VM.

	struct task_struct *p = container_of(ch, struct task_struct, mce_kill_me);

	p->mce_count = 0;
	force_sig(SIGBUS);

But even if that's somehow the "right" behavior, we're doing it purely by
accident.

As for this patch, if we fix that bug by returning 0, then filemap_release_folio()
is definitely reachable by at least one flow, so I think guest_memfd also needs
to implement release_folio()?


    
Full AI bot text:
--
Setting the AS_RELEASE_ALWAYS flag causes folio_needs_release() to return
true. This correctly triggers .invalidate_folio during truncation, but does
it also unintentionally expose guest_memfd folios to eviction via
posix_fadvise(POSIX_FADV_DONTNEED)?

If userspace calls posix_fadvise() on a guest_memfd file, the core mm
calls mapping_evict_folio(). Because folio_needs_release() is true, it
calls filemap_release_folio().

Since guest_memfd does not implement a .release_folio address space
operation, filemap_release_folio() falls back to calling
try_to_free_buffers(). Could this fallback cause a warning?

fs/buffer.c:try_to_free_buffers() {
	...
	/* Misconfigured folio check */
	if (WARN_ON_ONCE(!folio_buffers(folio)))
		return true;
	...
}

Because the guest_memfd folio has no private data, folio_buffers()
is NULL, which will trigger this WARN_ON_ONCE.

Furthermore, try_to_free_buffers() returns true, allowing the folio to be
removed from the page cache. Because this eviction path bypasses
truncate_cleanup_folio(), it never calls .invalidate_folio.

Does this mean inode_sub_bytes() is skipped, leaking the inode block
accounting?

Userspace could potentially trigger the warning and infinitely inflate the
inode's block count with:
    struct kvm_create_guest_memfd args = { .size = 4096 };
    int fd = ioctl(kvm_vm_fd, KVM_CREATE_GUEST_MEMFD, &args);
    fallocate(fd, 0, 0, 4096);
    posix_fadvise(fd, 0, 4096, POSIX_FADV_DONTNEED);
Should guest_memfd implement a .release_folio callback that simply
returns false to prevent these folios from being evicted?
--

