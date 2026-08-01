Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F49C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 18:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922C46B0092; Sat,  1 Aug 2026 14:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D3986B0093; Sat,  1 Aug 2026 14:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9576B0095; Sat,  1 Aug 2026 14:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58DB56B0092
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 14:52:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB77D16036B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 18:52:06 +0000 (UTC)
X-FDA: 85053595452.17.2D441DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 27ACB2000A
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 18:52:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="XzjXVc/j";
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785610325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZiDLjfRmYxoPl7056FsC7JRYJ7y/LJyfmAsEAiZY9Hg=;
	b=TjpNaY10CsKxPNS0Mip8NZ5iZ199V19F3i6hw5OKNwzFHvKAqcCpY/7E60xSsJ8lkNEBkd
	LSo32Ke3C1sPLiRy4q3IEN0YqqjaaEDUg+GZ6rTbfaxlCtsY4y1pP1u+dtOkdVQOki8wCR
	OrNkTravpc5iDM6CCXDzPFWSf6vil18=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785610325;
	b=s870fMsN6nGZeh9Ehnv9tDMUXfulZcU5bqkwXTDSjUSvgt7ONErAchWVrgoRRbgenGVSOt
	SDmunKwTJFLz5qxoVJdXGogTuW+yfQL6e0TSt/F9MGjqKLsw+mK3CBaF4akym0x3Lyljsr
	EIXMzPfIQQc5FIWk61gT2ZEfto5yIC0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="XzjXVc/j";
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6285C402FD;
	Sat,  1 Aug 2026 18:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D29F1F00AC4;
	Sat,  1 Aug 2026 18:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785610323;
	bh=ZiDLjfRmYxoPl7056FsC7JRYJ7y/LJyfmAsEAiZY9Hg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XzjXVc/jwJuVz3QnFD0XjfMzuxZ32xtT3f1TmvjPpVplauz2DYyPcstAkirR2v6Sg
	 xkOsOI3Ffx6oafFKMISTJCPwEMFbCRihB4TPpdcI9MVOUqAGZELrqDjWfnaRBKwAim
	 Wry6QEn8JmSqkoUbL867liGgtaqECq5r/m7zO5A4=
Date: Sat, 1 Aug 2026 11:52:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Lytkin <iprintercanon@gmail.com>
Cc: linux-mm@kvack.org, urezki@gmail.com, willy@infradead.org,
 shivamkalra98@zohomail.in, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/vmalloc: make vm_struct.nr_pages an unsigned long
Message-Id: <20260801115202.ccba41ddac9f7a4f6fb1ca9f@linux-foundation.org>
In-Reply-To: <20260801114915.115224-1-iprintercanon@gmail.com>
References: <20260730130923.9e71be5f477ee3db333cf0f8@linux-foundation.org>
	<20260801114915.115224-1-iprintercanon@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 27ACB2000A
X-Stat-Signature: bmz65sjdfban6g61i71nox4kjo5nu7kq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785610325-889554
X-HE-Meta: U2FsdGVkX1+DDrLsRLQy2WircJd5fWr+xoknR1twi3fM8yRB9zUmr2tAxx9nRYZDhjkGQasHpEDteHXkNu/WMD91Reqrz47zB7VSLVgUiNV//qVRico/XNv3AcR8SeAnsaViLDqAVkXvaqRiKHk7kG/rzFAmrhMFn58dWfvee25KqI5OBbeRVdCox/SAfICtyCEAfhe4as6BkIuK+E9HUyPygSzqKLXZ6uvz8MmOZezlcEo9HwaYpnIX/HKzL2LUfR6iySybfs20r/64KnTnfgEd4VIToeYN7gyfzjxLKH1LHNS6Y6rUuYMz0X6pAc4p5Ibh0RMWpEh0qd0BNOgYiYVm3M+oDVp0FWZMSFEW17+kHAA40BN+s4Mced9F+0/B7U1kmK3bxJTOFGa4LJaTn0CJ4954WqvokoKNN7Guub2+4UnjqmLvyxyUK4F+f5cg/3KeFb8NuIx6fx6bwRrSNQc1MHq+OY8DiJq6IXJa0Z5eummvUoiEfFlG+1wraJFm92TsoKmwp36P3p+5DPrSp3A1K7wpmirVhzeL4r59j4SZsr9ZejnDO5rlyxhiJ2I9WTflurzaJRH5/QyvtG+LdYGARIUYeki/hTfdS6eOmjmD7HVymAGZQzh008jqBH1pDNIZ0glrR94/oRnpH0WzcPxzZcMo5x6W4zg9DiHgRYB1kJEXysipuM+53n9WuXOabTwpewDjBiaWhUWpp6tXHuCe9cYyGnQjeYRRtqrVC8QYOFDR3Fc7FjkckVBTskJc7QRz27whpK1Dqt/AHlruYCYdWwOBx0KCiwyVbaVbkas1e6yeqEKA4Sps4eVnRVZbXFcHduyds7OtXdT/OBOO+ZKIKnngSSRfIGlO+btFg9RnXnNz0TU9zgYPXjnEvxVfCjyVDjnuAzhc8ECUVWeFscSkPk+HxHzwRqoOddLQ6xxL5mpYVK+ozGyFI+j22rP7hEWwhDsArmtVyLBvuLT
 IFABpWgv
 bxaEj81lVcnqYMulFOaoGh45onNvP2M0dQov9uuCSIc0JNybNZKbdrM+MdKD/1wFA6p3NvBsRSBe3Mtb+zUPBuYKZIJDbDSHz7PPK73hcsu+yG0ae/23MqwgnAKUmm80bqiZVVoKlprGqrN+CBimPXa8vJOIDASI/BmlG0xuPvGt8o0QtaGvIQvBa5kgrr2ED+8G/Ww1gAG7rp0eLDwVdCUPpJARQyoFgqqgjTuAtuowNBdN+HGMn95wB3c13JOTc7tUo4mmnffMEW3Hc54SzjzAB1iZmGPdxf9M24ZfdNziZaidBPjZMpmeHA7w5Ef6xz8GPWkgplj6a/58PBNDwmwX/EVmqUn03ZdlBotb2vX0tteg5czfBsGZ2PNNyDg8ASTDy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  1 Aug 2026 14:49:15 +0300 Artem Lytkin <iprintercanon@gmail.com> wrote:

> vm_struct::nr_pages is an unsigned int, and the file keeps deriving byte
> counts from it as nr_pages << PAGE_SHIFT. A shift is evaluated in the type
> of its promoted left operand, so those are 32-bit arithmetic and wrap at
> 4 GiB of bytes, which is 2^20 pages. Every site depends on a cast being
> remembered; vmap() has one, two recent commits did not. vread_iter() then
> computes a size of zero for a 4 GiB VM_ALLOC area and /proc/kcore returns
> it as zeros while reporting a successful read, which drgn, crash or gdb
> cannot tell from real memory, and the vrealloc() grow-in-place check
> declines a request that would have fit.
> 
> Widen the field so the class of bug goes away instead of one site at a
> time. Everything feeding or consuming it widens too: vm_area_alloc_pages()
> and its accumulators, nr_small_pages, new_nr_pages and old_nr_pages, the
> index range of vm_area_free_pages(), and three page indexes that were
> plain int. Five casts go. Two prints needed fixing as well, %u in
> vmalloc_dump_obj() and %d for the unsigned field in vmalloc_info_show().
> 
> No bug report behind this, I found it reading the code. The 4 GiB wrap
> needs only a machine with over 4 GiB of memory. Neither larger threshold
> is a practical concern: 2^32 pages, where the field itself truncates, is
> 16 TiB and beyond what hardware can populate, and 2^31, where the plain
> int indexes break, is 8 TiB and larger than anything in the tree asks for.
> The int *nr cursor in the mapping path is unchanged and is separate work.
> Users outside mm/vmalloc.c need no change either. Those handing the count
> to a narrower parameter cannot drive it near 2^31, and
> kho_preserve_vmalloc() stores it into a 32-bit ABI field that still
> receives the same low bits; above 2^32 pages the truncation just moves out
> of vm_struct into that store.
> 
> sizeof(struct vm_struct) on x86-64 stays 72 bytes with
> CONFIG_HAVE_ARCH_HUGE_VMALLOC=n and goes from 72 to 80 with it enabled,
> both inside the kmalloc-96 bucket it already comes from.

Thanks.

Ulad, AI review suggests that vrealloc() has an issue handling
__GFP_ZERO.  Can you please check?

	https://sashiko.dev/#/patchset/20260801114915.115224-1-iprintercanon@gmail.com


