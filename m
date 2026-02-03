Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FBFFE8306F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 09:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9126B6B0005; Tue,  3 Feb 2026 04:23:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8961A6B0088; Tue,  3 Feb 2026 04:23:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E0D6B0089; Tue,  3 Feb 2026 04:23:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6695A6B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 04:23:09 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0ECF1D4D45
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:23:09 +0000 (UTC)
X-FDA: 84402606498.17.44CC70C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 46A6718000C
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:23:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Er8Q2Fy+;
	spf=pass (imf24.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770110587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2KABNSDjuT+qisv8pF/NnMHycwEO8d1/r5QwUcLnk6U=;
	b=KkjpSkQXY9/H8NE/Zw7EvvLVJQkSUeOAHFvCLQzi8x9wotmG5YNwD4QySDL95AG4a/XQko
	P7jeDBLcYioYd8Mcz3zG4/X+y3jq7jMkukxVK1FIx/xtvPzZVfzW1v1cV0RckNL/g4qzjd
	XSq5tu/OB33AT3Xm69xtoX9s6jGf3sY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Er8Q2Fy+;
	spf=pass (imf24.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770110587; a=rsa-sha256;
	cv=none;
	b=VOpL6yKiW4kpecIIMt5iPRzv5zMeXorx3uxLE/qaIqXY2DtdMzJJBCrmHTf5zYXr5REYDp
	CuBdNN6YJf9xfjP65K5jA+b4maO8S3wVUpJTUWCI65+/Xu5lIRBPyFHBQcZPYda6HsFIZ/
	06AtMSIdrU1xemOphfp9CD5JzePF/MY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1ECF5433CD;
	Tue,  3 Feb 2026 09:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0277C116D0;
	Tue,  3 Feb 2026 09:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770110586;
	bh=ZVWcyVwZHUhFXo6LJeC3Z8mNCMQ6uLWORrt4JJJgWoM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Er8Q2Fy+KBEfe4dDqx7IvFyR/8sVI3aszh3mPZOyTzp9datuBbwu0YZ9Df9Wf8ADc
	 ySS90/Wy7AJ4ECljJj4WaeRjrR2Bn1BeIXI186phcK1DR79f9qCXRBERAquluZ/g+W
	 /N2qS+USjW3ZbS9W+FewcJ7UAPQouY0UXa2V//9FAj721/YnBK6QA0KM8q+pWtgHX/
	 w/v8n8+lcKW9XfRnVx9dcbv19CtapYXdGK+F1fmlfw27FJCUcOCItSz1swP1Nd7uvp
	 naMfcdk1CuXKpQ9J7SfvNnsGeW8Y3dX1q9FT7eiI8wbw7Tltd/QMpTT9ZbOkSjqh7c
	 qETKVIut85/YQ==
Date: Tue, 3 Feb 2026 09:23:00 +0000
From: Will Deacon <will@kernel.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
	zengheng4@huawei.com, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] arm64: mm: fix pass user prot to ioremap_prot in
 generic_access_phys
Message-ID: <aYG-dGzR6MuPSQBK@willie-the-truck>
References: <20260130073807.99474-1-tujinjiang@huawei.com>
 <aYC6_lSm_eJeKIcn@willie-the-truck>
 <73396cda-e12c-484f-ab84-b09e7aab8bb0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <73396cda-e12c-484f-ab84-b09e7aab8bb0@huawei.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 46A6718000C
X-Stat-Signature: fx6zwep34q33r8qmewtz3j1zsr5q94pw
X-Rspam-User: 
X-HE-Tag: 1770110587-841533
X-HE-Meta: U2FsdGVkX1/mmlJWCb56XyI1pbO5an/vujqfKZrdC0quQBkdfYBgpg+Shkbm7fNKUIFikJ3jE8ap+5UmdWTCc8v8H7HeOuEOJO/BIP4hJPNHV4NsFdqSfAWXCPjRjgQKrpxt6VcnrY2o6ej9sTn2ynexUumSqV16Joha4iD3xRKsNCsxmMQQpK/RwaUj3HdHkPk36iOn9KNfWSPEzRyzr13u25cJTqup+G9beYpLs8IMQ44Ke4o1gokseMlpYqRRolgv835UiqFHLIzYtbwpNN3YFUfjGdV5gtiHir8fgdGBD/jcaXjrjVBXx41X2xEtvbDSVYVq+LkKsn5zhhMpqdMR8ObRh36gt4Ym3VFwrPSfa9kIFn6B1DcHY0cVFWQxXbuuglzVNnC44MZ7JB/tefokAkO2rPeZngVmQW05WSatQOnTzv3xRIb4pnuol6auHDSbMPx6xKic1BtaLxni00m5R5zhDQbIaixhyXtnV85FYoHcZUHpXSAABiR8yiGBYV5Q4O2IQE4xNkLlPwxtyWHbgdCpIjLVKomaqaOmVPO+GATlNDqW65OV/vZHW5gnsn+lZgp8GDeCd4M7zk7lqHPnaoh5L1Bf9TNHrjTmQa6YbR5xWfrObcInDqS/IADHM2g/kHNQ+5raBdE5HKNtsIDsJwnt7cVOI9O+hT3JCD9ca8QuWtOK/KIXXT2fnkt7uSZc9xWZ8hNaEnN4JxP5Vzdvn8qwE0gwwK2WIL09YbTj9P+ZyqNAycNZiHh03g34l3iIbDfec1OviA+XBnqUxPhtKc9Zn7hQc1McG8x6b3OZG25jZAZCtH55lAByqfbQvNEDKNCgrXWmQucBM12USGeyO/EMHKeaSUHKG7NfBWOnyk5oLWyyqjtUWcvHZQFGnD/RXrvo8bAsxMI7c1ydLbJlULu+eOiFnQZ4bLBBmFD5bRM6f4q6doFAsCwSQovXriLkmBu+OUvdHSQgLq+
 HcqFaQNJ
 VNXNaLNdi9nWrgo1BpWdv3n8AAe3+xQj8gOjSozhtC7rs+vvU4gTdZctxc7Grj7JSRm/qTei63j0X2r1sHZM00Dix1W/WIQYZNSe9fm7IN07eJ4Y6IMA2ins7SpZwgCXW6XXRDfwPsfc+RIUZdoo7yaBwZHT3xGM6/M33eCznQHKerDHV/JCbPtHU5Np22i/670MwqlKAYPd/gJc1k+uufEwWOgSlGsbNVzlTj6N3+Ihoq/CDjIJEoKfCYQFiOkFkjNfEKXu4jJMs33yBMvBeu38wfZkDCXdKU5RmzZbgiNSqTpbjSfbSs7p9bhsBcmZr9b+9V/YvXSAfvU5OznQ3ljzHx/u3pAMO/0Yq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 11:38:15AM +0800, Jinjiang Tu wrote:
> 
> 在 2026/2/2 22:55, Will Deacon 写道:
> > On Fri, Jan 30, 2026 at 03:38:07PM +0800, Jinjiang Tu wrote:
> > > Here is a syzkaller error log:
> > >    [0000000020ffc000] pgd=080000010598d403, p4d=080000010598d403, pud=0800000125ddb403,
> > >                       pmd=080000007833c403, pte=01608000007fcfcf
> > >    Unable to handle kernel read from unreadable memory at virtual address ffff80008ea89000
> > >    KASAN: probably user-memory-access in range [0x0000000475448000-0x0000000475448007]
> > >    Mem abort info:
> > >      ESR = 0x000000009600000f
> > >      EC = 0x25: DABT (current EL), IL = 32 bits
> > >      SET = 0, FnV = 0
> > >      EA = 0, S1PTW = 0
> > >      FSC = 0x0f: level 3 permission fault
> > >    Data abort info:
> > >      ISV = 0, ISS = 0x0000000f, ISS2 = 0x00000000
> > >      CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> > >      GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> > >    swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000001244aa000
> > >    [ffff80008ea89000] pgd=100000013ffff403, p4d=100000013ffff403, pud=100000013fffe403,
> > > 		     pmd=100000010a453403, pte=01608000007fcfcf
> > >    Internal error: Oops: 000000009600000f [#1] SMP
> > >    Modules linked in: team
> > >    CPU: 1 PID: 10840 Comm: syz.9.83 Kdump: loaded Tainted: G
> > >    Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
> > >    pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > >    pc : __memcpy_fromio+0x80/0xf8
> > >    lr : generic_access_phys+0x20c/0x2b8
> > >    sp : ffff8000a0507960
> > >    x29: ffff8000a0507960 x28: 1ffff000140a0f44 x27: ffff00003833cfe0
> > >    x26: 0000000000000000 x25: 0000000000001000 x24: 0010000000000001
> > >    x23: ffff80008ea89000 x22: ffff00004ea63000 x21: 0000000000001000
> > >    x20: ffff80008ea89000 x19: ffff00004ea62000 x18: 0000000000000000
> > >    x17: 0000000000000000 x16: 0000000000000000 x15: ffff8000806f1e3c
> > >    x14: ffff8000806f1d44 x13: 0000000041b58ab3 x12: ffff7000140a0f23
> > >    x11: 1ffff000140a0f22 x10: ffff7000140a0f22 x9 : ffff800080579d24
> > >    x8 : 0000000000000004 x7 : 0000000000000003 x6 : 0000000000000001
> > >    x5 : ffff8000a0507910 x4 : ffff7000140a0f22 x3 : dfff800000000000
> > >    x2 : 0000000000001000 x1 : ffff80008ea89000 x0 : ffff00004ea62000
> > >    Call trace:
> > >      __memcpy_fromio+0x80/0xf8
> > >      generic_access_phys+0x20c/0x2b8
> > >      __access_remote_vm+0x46c/0x5b8
> > >      access_remote_vm+0x18/0x30
> > >      environ_read+0x238/0x3e8
> > >      vfs_read+0xe4/0x2b0
> > >      ksys_read+0xcc/0x178
> > >      __arm64_sys_read+0x4c/0x68
> > >      invoke_syscall+0x68/0x1a0
> > >      el0_svc_common.constprop.0+0x11c/0x150
> > >      do_el0_svc+0x38/0x50
> > >      el0_svc+0x50/0x258
> > >      el0t_64_sync_handler+0xc0/0xc8
> > >      el0t_64_sync+0x1a4/0x1a8
> > >    Code: 91002339 aa1403f7 8b190276 d503201f (f94002f8)
> > > 
> > > The local syzkaller first maps I/O address from /dev/mem to userspace,
> > > overiding the stack vma with MAP_FIXED flag. As a result, when reading
> > > /proc/$pid/environ, generic_access_phys() is called to access the region,
> > > which triggers a PAN permission-check fault and causes a kernel access
> > > fault.
> > > 
> > > The root cause is that generic_access_phys() passes a user pte to
> > > ioremap_prot(), the user pte sets PTE_USER and PTE_NG bits.  Consequently,
> > > any subsequent kernel-mode access to the remapped address raises a fault.
> > > 
> > > To fix it, define arch_mk_kernel_prot() to convert user prot to kernel
> > > prot for arm64, and call arch_mk_kernel_prot() in generic_access_phys(),
> > > so that a user prot is passed to ioremap_prot().
> > > 
> > > Fixes: 893dea9ccd08 ("arm64: Add HAVE_IOREMAP_PROT support")
> > > Signed-off-by: Zeng Heng <zengheng4@huawei.com>
> > > Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> > > ---
> > > Changes in v3:
> > >   * arch_mk_kernel_prot() always grant read/write permissions.
> > > 
> > >   arch/arm64/include/asm/io.h |  8 ++++++++
> > >   mm/memory.c                 | 12 +++++++++++-
> > >   2 files changed, 19 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> > > index 83e03abbb2ca..fe3040d59119 100644
> > > --- a/arch/arm64/include/asm/io.h
> > > +++ b/arch/arm64/include/asm/io.h
> > > @@ -267,6 +267,14 @@ int arm64_ioremap_prot_hook_register(const ioremap_prot_hook_t hook);
> > >   #define ioremap_prot ioremap_prot
> > > +#define arch_mk_kernel_prot arch_mk_kernel_prot
> > > +static inline pgprot_t arch_mk_kernel_prot(pgprot_t user_prot)
> > > +{
> > > +	ptdesc_t mem_type = pgprot_val(user_prot) & PTE_ATTRINDX_MASK;
> > > +
> > > +	return __pgprot_modify(PAGE_KERNEL, PTE_ATTRINDX_MASK, mem_type);
> > > +}
> > Do we really need another arch helper here?
> 
> For arc, powerpc, ioremap_prot() simply copy the user pte prot to the kernel page table too.
> So maybe we should fix for the two archs too, and we should define a arch helper here.
> But I'm not familiar with them.

My point is that we already have the helper: ioremap_prot(). Just fix
that for arm64 and cc the other arch maintainers if you're not sure how
to fix it for them. What we don't need to do is add an additional helper.

Will

