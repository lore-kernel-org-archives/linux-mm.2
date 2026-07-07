Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E3E1C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F1416B00B9; Tue,  7 Jul 2026 04:28:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0B96B00BB; Tue,  7 Jul 2026 04:28:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 468BF6B00BC; Tue,  7 Jul 2026 04:28:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1BB6B00B9
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:28:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A4EF7120396
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:28:37 +0000 (UTC)
X-FDA: 84961304274.06.E5DEB9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 01990180006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:28:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dwkWD4yw;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783412916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5pdPtIHiIQoepiex1h1rTZsPNlcpN7aFZWNjXMcloL4=;
	b=B4338cDDjaXXT1d6LoJd0wFnN0BlAHFlM2vclRPMgiGlgVJOIN2RrHsrvEYyk4bXnpWnrA
	5BMD5wbzSUpe5HVyu5P3fpKB9R00NlTy5CKSGdnPYNBHfBcb0uLukc217xEmtl16rx07IT
	rPIRQkzqnBkXPirMDrA22BchL/iGgJ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783412916;
	b=5vsGvGdFJ/dHm7hvS8IqXrm0d6cN3DdaQnLd30AxMs8UfkrKHyJ9B3syFdw+MpXM9Uih+I
	XgBJyMi7eSJYbn6u5iNrSlOlIx7aZIm082ghWkt3J4yu/4xp7XAbXxkE1HdBgQ6nMHDazK
	rNAEh6da944MoW3Z4fqQYCKL1IHbo00=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dwkWD4yw;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 536EE618A8;
	Tue,  7 Jul 2026 08:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7681F000E9;
	Tue,  7 Jul 2026 08:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783412915;
	bh=5pdPtIHiIQoepiex1h1rTZsPNlcpN7aFZWNjXMcloL4=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=dwkWD4ywktM5Qi5tFg4O57t+Dqxw4Qv2nnHqcL/Cawk9UEuLb01dx0UgluOGAuLt/
	 FHpw74frxj+GAztg/Ag+SEVil5vy3oHjeHOZwU2EdE6+CsBYPTOUGfQYQq+lCHZH0D
	 NhASQTAx1yM0g9VFNCtwKNh8y4ZSGew5+5x9w12k2sduLQSOLVL1OsQoj9KDiqYu+c
	 AAK/T8ov/hvuJqjzgCJF4cAWoPF4GZwiPVBCPkCwzp5B0u5CvbX+gOZaaaI0LewPpX
	 e4ub4YpTE4g2aohbVzbCi9/Jfo/ZVHyz91kvaLlLttdJeJLdVJFbF3HMj1TAC0hLVU
	 8mI5GPU4FYnKg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH 0/4] kho: Support preserving unsplit high-order
 pages
From: Mike Rapoport <rppt@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260703020832.1731864-1-praan@google.com>
References: <20260703020832.1731864-1-praan@google.com>
Date: Tue, 07 Jul 2026 11:28:28 +0300
Message-Id: <178341290876.3292146.16538284698967245356.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 01990180006
X-Stat-Signature: 4ms5nwwnb48a1u5nh8g81ct1ix8n53r6
X-HE-Tag: 1783412915-970523
X-HE-Meta: U2FsdGVkX197Gu+sh9XYvixbLc7n2L6E06kcexCsBajMxlV0+8SXZil/YArMhXNEjM+ZxkCZoUIOzerHSXwDsfZ3UHHnJkObPK6TNMtZ/zcynvZaB2g9h6XSgHya/D9LGBlDiie4ZkN8dyvf6Mh9A3lhtPPh0rYX1bPC5ouuy0NtOGB1sJDptUJ2GLKx+TU/6gLsZ44BQCdm+WQPr5BjM5YMFlZck1/U4J0ibypNIkw0m6hBq4DczFTbh3XjRh5APnNGj2wp2INWe65ft2KbU+BIvp1Po/009fOk3MTxHkOVPtgebOd0j5wgUXgvCFEabn7ZgSxgzvvyH13g9ZbjVYyahr8gF6h+B3YRPnRNwu8ONXVY6wOQwaYqXsKNam58jpkgmEZaOooej9y7u6il0TVIyXpjrq/EmW8eUh8ZDmfYoHXmtxO68HD9PQPyjR/O0A8rQdPVgQuw8axoLsfaEgOq7nQAsgTo3XPMZfKLMAzYmMUTruqd3dCD8zN4t/VwV8sBWm2Sx66DtZrdZqTsy+VDRldFJMt1aW7uzt9XBLH7vbx3TGXZz/sWdwRaHLMuNAtHS3HjiX/FtSHTuOe+znxij1YkF54bBi7Zh5PcooAzm9REZaJvbNA8ImBN8d0KzRYr76Hs/8pKYeEs4AnAL0RJ/+++0ayxZ1l4IQqKvU8xL7mHzj2ZTi2Mj1fp8FuXacVdLpVOVroXCRYSZwDkLXhTXKCbKztmz1Yby0bvrW3tIgXdT0c5ve5cJ3fXIavNjZLT53M0zAlKYl7St91nY7Ko1Rm4/Nx3+iYtgtPBIeIlkn67475mF1ee0IvpetwiO8H1bgtEYqgPF21QneiMY+ufBGWU/svNGx3W9DlmtyCzxHlUk3rPBWJdPAc2VfRTdkOAz1ci5uTu33p3xfhCPsu3tg3xQi1j0eCHbpFZr1mzpxqoNJxzl1GkBevCoppdq4nEBl1cOmGwGIrEH3r
 JNnq3Vwn
 MIKFEYmV6W5pyDsdqRxEXRWmJ+XqagUyc8A7FXnovwacyflW8/AADmMb/tga9MJ3jcRdInOR6XNYUBUQ67QA+w/zKq5Om1KPkryUiYhO8cx5n68CJfZ6Ge0mNery4rmkALExGqLAbo3Xn/ff8vOHzE8j53JC8GLFIr+7w/r6HA4w1gE0s5WDMHDmoy5PjdzpZ2lIJg3P0XS8miEtxff7QnFXYOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> This series is required for the ongoing effort to preserve DMA allocations
> across KHO [1]. It addresses a fundamental mismatch between the current KHO
> restoration logic and adds support for high-order buddy allocations.
> 
> The Problem
> ===========
> The current KHO restore implementation treats all multi-page blocks as
> split pages during restoration, i.e. kho_restore_pages() initializes
> every 4KB page with a refcount of 1.
> 
> However, many kernel subsystems, most notably the DMA allocator (via
> dma_alloc_coherent), frequently return high-order non-compound pages.
> In this unsplit state, only the head page carries a refcount of 1,
> while all tail pages have a reference count of 0.
> 
> Consequently, when these contiguous but unsplit blocks are restored by
> KHO in the new kernel, the forced refcount of 1 on tail pages causes some
> trouble with the buddy allocator. Downstream of the eventual free path
> the __free_pages_prepare() [2] ends up calling page_expected_state() [3]
> when is_check_pages_enabled() returns true (only when CONFIG_DEBUG_VM or
> debug_pagealloc=on).
> 
> This detects the non-zero refcounts on tail pages [4] and incorrectly
> taints the kernel while leaking the pages in question.
> 
> Proposed Solution
> =================
> This series introduces a "Page Type" field to the KHO ABI to track the
> refcount pattern of the preserved pages.
> 
> 1. KHO detects the physical state (CONTIG vs SPLIT) during preservation
>    by peeking at the refcount of the second page in each buddy block.
> 
> 2. The type bit is preserved in the high bits of the KHO radix tree key
>    (Bit 63) and stashed in page->private metadata during boot.

This brings a broader question - what is the best way to deal with page
metadata. This particular case requires only a single bit and luckily we
have a few spare high bits in the radix tree key. But what if going
forward we'll need more than a few bits? Do we need a parallel data
structure for the page metadata? Or something in kho_radix_leaf in
addition to the bitmap?

I'm not saying that a generic solution for page metadata must be a part
of this series, but we definitely need to consider and better sooner
than later.

> 3. kho_restore_page() applies the correct refcount pattern based on the
>    preserved metadata.
> 
> 4. A new helper, kho_split_preserved_pages(), is provided for subsystems
>    that may need to split memory after it has already been preserved.
> 
> Considerations
> ==============
> 
> 1. A primary goal of this approach is to prevent driver/subsystem code
>    from peeking into MM internals. Drivers should not need to understand
>    the distinction between head/tail pages or compound metadata. The KHO
>    core handles this internally.
> 
> 2. To handle rare cases where a caller might wish to split a high-order
>    block after preservation, we provide kho_split_preserved_pages().

Do you have anything particular in mind?

-- 
Sincerely yours,
Mike.


