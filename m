Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF44FCD6E49
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 16:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF0E66B0096; Sat, 30 May 2026 12:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC86C6B0098; Sat, 30 May 2026 12:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C05306B0099; Sat, 30 May 2026 12:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B10206B0096
	for <linux-mm@kvack.org>; Sat, 30 May 2026 12:52:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 735B31C1772
	for <linux-mm@kvack.org>; Sat, 30 May 2026 16:52:38 +0000 (UTC)
X-FDA: 84824679996.01.0793C91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id EB05E80010
	for <linux-mm@kvack.org>; Sat, 30 May 2026 16:52:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ErTE6kd7;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780159956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8UNb1/3qGmB4zSX8MLGFUwdcMgPk4T11baGG/hOQ7Cg=;
	b=n4xPveK3R+7HqAx04P3b4ieV/KYxioE/HLmGl4FNkq7s0coDNgqgPjGN1uR0RRheE0i/XW
	QGSlnzCsrWtIBQaqBHBmIzCmWFJv/b8MVyBqQ18atQvGhciZd6I17naKmYFZz6JRPHCmv+
	d9+3s0ac5U+PPlx4IIvHuNWaO9FPebw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ErTE6kd7;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780159956; a=rsa-sha256;
	cv=none;
	b=kYk4zRDf/jWfPmgQZ3vCsnBlWUc2FvuVXBSAQ0k6KBr1RZGJoEO4KfCEI/WH25RApNnN9J
	Cf4+ysfS/V/QnaNhyl2hZ454e52Xb/ZfFZ4nEkilNMqVAD56wsW9oORQMTW28soD2jJw1G
	tPx5wNatBaNz/m30ANfOqF/lPz91Kqk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7008660120;
	Sat, 30 May 2026 16:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE06F1F00893;
	Sat, 30 May 2026 16:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780159956;
	bh=8UNb1/3qGmB4zSX8MLGFUwdcMgPk4T11baGG/hOQ7Cg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ErTE6kd7JtWaVBDAoXu2s7i33/fLSNJOgv99y2jirEIh5FRREhKyHEBpPSt60wuGB
	 AF/SOzPfIvWwO0hK4X+wKLOyMMpot4HDZOhFrm7Sj/C3AKPURyGBLHLnNVflxDtTgB
	 dBfmMUVNRAHFI1XwUKnpoxRso8AxGDhPJwVh+jfDUkiaMr529dMx/JZ4Ossvp9Y3KS
	 hBplQJ73LWwxWvMO/09GaoCXEwwOdgi15VCVTwkzR5ITTHqJ8rlCkZCdIbRmYtOwM8
	 t4MJQK6U335Nd8iHwPDAoAaDYkjqoEojWMw8xzoyXjqqKTDiA1RqrlWDGy931gkTgu
	 EvuS8mB+7V7Ow==
Date: Sat, 30 May 2026 19:52:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
	peterx@redhat.com, david@kernel.org, surenb@google.com,
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com,
	corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com,
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com,
	sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH v5 04/18] mm: skip out-of-range bits in mk_vma_flags()
Message-ID: <ahsVyQZ5UXhJLct2@kernel.org>
References: <20260526130509.2748441-1-kirill@shutemov.name>
 <20260526130509.2748441-5-kirill@shutemov.name>
 <ahmQvfNk7S4F0LBj@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahmQvfNk7S4F0LBj@lucifer>
X-Rspamd-Server: rspam12
X-Stat-Signature: 9d9m1yzw7qtwfejbcwq7wouczannwpo6
X-Rspam-User: 
X-Rspamd-Queue-Id: EB05E80010
X-HE-Tag: 1780159956-103190
X-HE-Meta: U2FsdGVkX19Sc7amgEyy2BUnuG1/qp9e/u3AMZt+6EkKma6a4np0OoyPJkd5/N6ao7CCRvsOL+/HbgyKFQ7LLI9w9bUjR3gT84Ry2nVMbZ9vb951yCwYTHn94Jq2Y5mdM4gLYf1yGXUKOQuh1Rrw2REncX8rZqPP/CzEfzFOKJOV9hUQPlq2LvpEj8ZqwvVBuy/ixiJ5RlQiyi5vYrAKHw7mRwJVnYc/U6AuNtErHtb3vbRgSuvugrddkUzUq7eXUeU0gkW+YR36ZHfV2b0Bisrm9PPAwmwouu1QZqEKxV0ZuXAvyXzwombfSSCt4ScmF/YHSMU74ZBzE4TFpGKmWKoVG8IGXksp/pU9cHXNoSLIoUQwqQeozZxqgKAB94t6K3JFVyEKy5fTm3ZKS7ovaHOopvhPi/LH0N+5cs4lPL/LuZFJfCaTsBLHEqaURK5RqI2tY6L2yvENhUmIj5oCcKNwwTETkWx3vS7l8BBB/VQEdLE6m3smMRwOWNEsRrLtqvDYx/T/wm7Uf6IALsMPesXZLCeogr+04Wy4A6JIjSRA/Fg4sBB15FZI70XWz9kGt0y4Z7cDzo4KJxJZx0NK1mCZawrp0Rw7wZgrrqy5UBUvDLZBtxt5cT5+2w9biQ/DlsXjLN+0rE9v0K3SpB27TY/Agx1uLEJBf3A1tPzAXatoha7qbE4rvue066VylQ/y+yBnJ53OaNoquXIKVMyM7WizuLqn0U6/nkeEzyV7vFePw6n3VqNJDVKqgCKLXFxRRuJogyWD0j+T/oF7xnwwRxrN94O2V+neJZMa0ICi2AKADT/FGc9EPgIRu0452vWsgEofddWSHhTjl+CbtbgM4v9rrjBNSE14CfXzYP9HtQuXe0cqq0JVKkcEQn+dUrr6875vzgDyzNhUOic4pFWvvMpGBO75+xko/S28lRF1M45YfdEUM41svhhIEcL/GQU8Oy2NBDIu1yXtnX0p8u1
 RxdJ4ZmC
 1r6He7SG22zdyPcvlgE5iuXAQ3XhXwfrgu2Fq62XnXfx5oWwkHr6mX9YcpeIvrOdTtMLTZSEtx08e5UYJiY2C8eRpYQ+jo1Fv9rhgqPEqGVXFNvDy/t17gD3M8BHKPuJVeDJCqY0u9E5RSkvEt6pvM0r7FjhYMAiI8vGb1cQ8xcKnr71LUj7L7y1UPLmQABwXHOdj5o02I8jIPJtHAMEgmLcr0g/0Ap0McLEUcd9zDHQ2goVLj3HN+EVMDcHx2DuzDBWCDqvPgu0bdecvk0tXvAc/xkc5sRiN85HPA5aWhvHO0KLj5fo9lJDiaVPlcurSZlxyua4zguaV+xTG7rOnTixyCz4zk8fQ4OZ8Cp/HfFAv1pQz2FZJBhs3k6H+qTcVXySDC1HERA+TbfVFEE+0sJkowEFjU/PVLqbfWysVm87coQghrKQAXXjV6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 03:00:14PM +0100, Lorenzo Stoakes wrote:
> On Tue, May 26, 2026 at 02:04:52PM +0100, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> >
> > vma_flags_t is one unsigned long on 32-bit -- NUM_VMA_FLAG_BITS ==
> > BITS_PER_LONG by design, so VM_xxx-declared bits sit in the first
> > word and hit the single-long fast path. But the bit enum declares
> > some bits unconditionally above BITS_PER_LONG (VMA_UFFD_MINOR_BIT
> > == 41 today, with VM_UFFD_MINOR == VM_NONE on 32-bit so no VMA
> > actually carries the bit).
> 
> Yeah ugh.
> 
> > Passing such a bit to mk_vma_flags() goes through __set_bit(41,
> > &one_long) and writes one word past the end. The compiler folds
> > the OOB store with wraparound (1UL << (41 % 32) == bit 9) into
> > the first word. Bit 9 is already in __VMA_UFFD_FLAGS so the mask
> > happens to come out right today, but any high-numbered bit whose
> 
> That is... helpful :) but not great that this is the situation, an
> oversight, clearly! How I hate 32-bit kernels :)
> 
> > mod-BITS_PER_LONG position is otherwise unused would silently OR
> > an extra bit into the mask.
> >
> > Add VMA_NO_BIT and have DECLARE_VMA_BIT() resolve any bitnum out
> > of range to it. vma_flags_set_flag() drops negative bit values.
> > The ternary collapses at compile time, the runtime check folds
> > away when the bit is in range, and the common path is unchanged.
> 
> Hmm are you sure it does?
> 
> A key design goal was that mk_vma_flags() generates compile-time constants
> the same as if the bitmap were constructed independently.
> 
> This surely must generate code? Or at least runs a significant risk of it?

...

> A simple solution that doesn't require change to the core is to just uglify
> userfaultfd_k.h a bit with:
> 
> #ifdef HAVE_ARCH_USERFAULTFD_MINOR
> #define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT, \
> 				      VMA_UFFD_MINOR_BIT)
> #else
> #define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT)
> #endif
> 
> But of course that becomes much more horrible with your changes...
> 
> Another alternative, which I used for VMA_DROPPABLE is to add something
> like this in mm.h:
> 
> #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
> #define VM_UFFD_MINOR	INIT_VM_FLAG(UFFD_MINOR)
> +define VMA_UFFD_MINOR	mk_vma_flags(VMA_UFFD_MINOR_BIT)
> #else
> #define VM_UFFD_MINOR	VM_NONE
> +define VMA_UFFD_MINOR	EMPTY_VMA_FLAGS
> #endif

I have a PoC of yet another alternative:

https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=uffd/vm-flags

The idea there is to keep a single VMA flag, VMA_UFFD_BIT/VM_UFFD and move
all the rest into what's now struct vm_userfaultfd_ctx.

-- 
Sincerely yours,
Mike.

