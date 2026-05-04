Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B8AFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 07:52:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581B96B008A; Mon,  4 May 2026 03:52:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532E56B008C; Mon,  4 May 2026 03:52:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470196B0092; Mon,  4 May 2026 03:52:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5226B008A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 03:52:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB2C81A0285
	for <linux-mm@kvack.org>; Mon,  4 May 2026 07:52:08 +0000 (UTC)
X-FDA: 84728969136.20.2392813
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2ECCC140004
	for <linux-mm@kvack.org>; Mon,  4 May 2026 07:52:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q0Ior458;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777881127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vljOpkt5c5uOBAYejkwsYSdPoDB/+K5jKSxoqVsIcKg=;
	b=z4+I9iF0cV65dzwaOlxuBAb7e90bAP7zTKuBjuaeHEQhxPwgP5BBkc7KnI0ujd0YxPezqT
	44KVpEWfO9Ui10idoQfgmjeGobqWv/f/Xc0363IyEdU/insDV27ADB7KrB5jWxBJEte7ip
	mO9V8B1rs9P+8Dl32xzfQZrQshibRAk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q0Ior458;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777881127; a=rsa-sha256;
	cv=none;
	b=WX6eBcRKetURHjl0m/apsCaGGOieWVKiKaJywps6dv7pPEr6pipuGDfyhruEvgkncIfCyP
	cHpQfoh0uYEiAsOy3k1FIJCcyiM+8oWzfAVu0j2SKhO1h3eZfBOrZ4LhZLXHbaASbWn7uG
	y4AYB4htYZmtcBjCjlOQ9ohPzn51yUE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9286F60008;
	Mon,  4 May 2026 07:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACBAC2BCB8;
	Mon,  4 May 2026 07:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777881126;
	bh=JAZP0VOjK8IWWwLxaA6mVGJfOv+HCV3E8PZjNZL9e48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q0Ior458+826MxxYajg8HR0bjSFxuUwS3Nf9kiAi2a/JGmfCYN8qf+G+Vry8JIdR1
	 Jx5fSuZJjo1zQEJ7jHvSGj61vq15Ouq92kAYbbiXnslEXWhuLH2f+Ui8aVdYs6P56n
	 J2Tpp7AHZzHec8lj0hq6Ej4EQ8h9DIAc4VHpYvf3vHx7z6GDYaYTZ5qWTTZRXcgKYs
	 b9pL50XSXLOBzxEtOs4rtAFI+TK2wM6NgPhaEkt4pp6HAcXhrPEuasbZ86sFD6b45F
	 kio9wDn04LWHISRVcqC2GICZIn+agnQpZ2kX9lY2s+edyQqCwDgWzbqg0jQC4PGpA4
	 amMFHz69ELOQA==
Date: Mon, 4 May 2026 09:51:54 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 02/14] mm: rename uffd-wp PTE bit macros to uffd
Message-ID: <afhQGs1Y4vwtRVEH@kernel.org>
References: <20260427114607.4068647-1-kas@kernel.org>
 <20260427114607.4068647-3-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260427114607.4068647-3-kas@kernel.org>
X-Stat-Signature: thxjjuhzu9c4yxbtbbao6dncs8zj6pj7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2ECCC140004
X-Rspam-User: 
X-HE-Tag: 1777881127-897757
X-HE-Meta: U2FsdGVkX1814d0rW1UMHxXPmkCU2jiX7k8IiDpsatIwayGlKUiy5l/PPj8gbYmXB9et+kfN6HTv3DTX63/ftA2bfedmx/aTqExnHuXNb40cMqQcmckgfmO2GmzOGXvbKNokZOVxRzHvpELk7bCJ0Yw00Y9x8+hHpTLQh/Tv13KqQOJjCdWz0gUfoWyYOyL/C55273zIv3zOmYS418LBoQ/h0avlsmUan9/R879DMqjZ8XM2DuhzEkiF7UBWD0ZRGfRk4IWSmaD5QNJy3hNlmYNvKv9I0RSRMvT5AftvZBFGch45CzNw7OXNgOnRNWgRwNn2bR/EIcglM29H1zEVgH6KQcF43CSM5J8LnjJu5AfGHE+tt/UjGh5IjeSu5Tp7G1xASJc0chEU5+/HadZDSQcHXDKh4M0Gwk2VpPO4XaTPGq3zHd3c2NiqS7LyyAsFGPKDcTPD04lCkwLvMslffJP6L7iwiAX555hFDVxkuJEVWACfvyIwb6xB46nt2G/J6rwi706hePYErxRa02Ci0VJyh/XgMK8sB4URyPjs9FkbifhnKraAQdQuHr6Q33qXfAJL7b8Tzf/JyLGNgZ9ydDcCDAxClCoY6aKp4unzJu4BXEJWAlykjQyh2n2hKBGHe4Cy64uhLIDp1C/r7N05sK60JldzoD6lRvyd3+ZkaEm7BWF7gGz+4EX9M5g41XEig02d/IopgFpiq2JXiLO/qr+6gIwZFC8AbHTDAPedUpujmmSEMvBC6l6MM35h3IRzf25kBaBQUQJFBEps9gaXR1UHn8lz7ppyielQ+70HEWjSGG0HCu/HGUTT0IxIfvAUbt8j52YSM45+O2xRv/xIh0PEZPiNH9PtAc11yTcjwOrYbxYbDxDLByUIa3k8kqzG6z+b8ElALbg8nFZPuQdKv3T43XGmvumjmgR4mxXV+TXQyoDNhvxJKYQj6NRwArbsH6xA6tt8XjfL1hBpSHK
 d5VVVZxX
 1+p2ux/rlb5ac8StpjYx9s5eXK/yRzkJYGpU9OOppXUOe8jW2fqpAQkj/31KWB7Bvs4UpTdr0CLPAM1ytnD18dwvliSLqfOJhC4eTe4usKYzphS0++BciefOHioBn+rL2+qDCExC/SNYjcnvEki9F3PfWC+thDkeU14Qi7pbAYvmu3XOQB1RbhlZheN5AegqIhdvnE9+gKt7Ty4n2x21DmGm8TZdslbpKjgQsk/Nm2KDNbipcGi/skPvh/9veFJpLhuQCYdym2akaiVRBBv5NZfQ8frwbruziIuQq8Z0zTMu74zM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 12:45:50PM +0100, Kiryl Shutsemau (Meta) wrote:
> The uffd-wp PTE bit is about to gain a second consumer: userfaultfd
> RWP will use the same bit to mark access-tracking PTEs, distinct
> from mprotect(PROT_NONE) or NUMA-hinting PTEs. WP vs RWP semantics
> come from the VMA flag; the bit is just "uffd has claimed this
> entry." Drop the "_wp" suffix from the arch-private bit macros so
> they reflect that.
> 
>   x86:   _PAGE_BIT_UFFD_WP  -> _PAGE_BIT_UFFD
>          _PAGE_UFFD_WP      -> _PAGE_UFFD
>          _PAGE_SWP_UFFD_WP  -> _PAGE_SWP_UFFD
>   arm64: PTE_UFFD_WP        -> PTE_UFFD
>          PTE_SWP_UFFD_WP    -> PTE_SWP_UFFD
>   riscv: _PAGE_UFFD_WP      -> _PAGE_UFFD
>          _PAGE_SWP_UFFD_WP  -> _PAGE_SWP_UFFD
> 
> Pure mechanical rename — no behavior change.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/arm64/include/asm/pgtable-prot.h |  8 ++++----
>  arch/arm64/include/asm/pgtable.h      | 12 ++++++------
>  arch/riscv/include/asm/pgtable-bits.h | 12 ++++++------
>  arch/riscv/include/asm/pgtable.h      | 14 +++++++-------
>  arch/x86/include/asm/pgtable.h        | 24 ++++++++++++------------
>  arch/x86/include/asm/pgtable_types.h  | 16 ++++++++--------
>  6 files changed, 43 insertions(+), 43 deletions(-)

-- 
Sincerely yours,
Mike.

