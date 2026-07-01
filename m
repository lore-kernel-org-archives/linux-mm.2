Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF6A1C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47076B00A6; Wed,  1 Jul 2026 02:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1EC76B00AF; Wed,  1 Jul 2026 02:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D357F6B00B1; Wed,  1 Jul 2026 02:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE8536B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:23:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 215A31676C8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:23:02 +0000 (UTC)
X-FDA: 84939215004.12.6AFEA4B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7B7CDC0003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:23:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mebOUl/b";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782886980;
	b=hn10S9WrcIaSJJPKrO5B+GW4LGGRISr1Tr+qDUF3Tbyd1xdJSel4oIyEJr3il4gHrmBQcb
	JeCUUgcR50ZrBXHjkVPANLbEq6d8aUQK09HoJDXQARhk69KGKb4BwKIrXoK2zcAAdsSg1J
	Pb0wLgCREdJ2Kqi57a5rsiXMYlR5AQc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782886980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+CV7vM2cx+5CJ4FbmSzaWHO/QerFhIw/VFpB9UKLnag=;
	b=innCi211Kjcx3EZazQ8nffmGr590sSw2zpOdFKcZhR0F0JtFWB2ZNp5ebOqmrZXO0HnZUg
	91FLK32kbqMWCVPDeu8kNBymlrmvpmt3O9cyp9xgJqKjAPY1COlM3uucvLhrTgQ3IxDQEQ
	SqUZ0jRjyLsyCkOoZAmf8Jb6lqYymSE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mebOUl/b";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC4CB6001D;
	Wed,  1 Jul 2026 06:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCAF1F000E9;
	Wed,  1 Jul 2026 06:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782886979;
	bh=+CV7vM2cx+5CJ4FbmSzaWHO/QerFhIw/VFpB9UKLnag=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=mebOUl/bwwqf4S7w7kuJFeK55aOXArL3TFyTg+YwHZM0Aqo11A2cwS2qc5uyoKBt3
	 dO1KZT7hVdrx3UQSma8+4XOmo21d0bOAN1LIlAgM9Y8eOKJY0Am34vRTyrvlFkADQo
	 x2jOHdyCdZ4ScD80uScfDrZqs4dIm7ltOQlidHQ4sEnEeMHf6nhJANmcdrRyxybp9x
	 JiBCaAsNQyVRCHvCxSm8C+u/RhJQ7nrDRUq8ub8VwDsYeOka1bmYijdNL1YvAxDwRy
	 dbxGH1+8CZ5cX5Q+oodtuhxPWpU3U8Kh2r3L9QxGBPoQqcrIq4NLslPud4kI2Fins+
	 hgjq0enJu8OWw==
From: Mike Rapoport <rppt@kernel.org>
To: Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Huacai Chen <chenhuacai@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Russell King <linux@armlinux.org.uk>, 
 Will Deacon <will@kernel.org>, Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: linux-mm@kvack.org, Alexander Potapenko <glider@google.com>, 
 Alexandre Ghiti <alex@ghiti.fr>, Andrey Konovalov <andreyknvl@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
 kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
 Nicholas Piggin <npiggin@gmail.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <20260630150413.1718632-1-ekffu200098@gmail.com>
References: <20260630150413.1718632-1-ekffu200098@gmail.com>
Subject: Re: [PATCH v3 0/8] treewide: remove unnecessary invalid range
 checks in memblock iteration loops
Message-Id: <178288696837.1179975.5183177963398478769.b4-ty@b4>
Date: Wed, 01 Jul 2026 09:22:48 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Stat-Signature: 1n198tp8izwafz6ogogpg1p9aodnapfi
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7B7CDC0003
X-HE-Tag: 1782886980-680245
X-HE-Meta: U2FsdGVkX18PSufMIiR4zqxlWF68vnqMZc6d6PgDKuHRQp/uDl1q/oF3ubhcd5T8Sw63zsP6/Mw6AzjO12TglC6ESqfxdNaFSL6sm6WoQEvVQvUUNTrX53t0/vyHg8cB9autLn/0y8Ir+cu382dRko7Xp+7306RNhDqS+07sVaKTroMN/Al/khN84xViRsQI8Pro8zWxVMZfaKnk2Ix/SYWIUWOZYt3uwhUrN4eN8w1jMoi026rCsZtLx/j4gfVszyiEAigJmR6T+8+W1wUo5GagvC6JGxG7ZPIUQDtiuK8kGhCzT/ukZKgpBr/Vskh66nwXjIjrNRvLrEJqpiSAtw8+b/ifrAZaN/+ucHSg9by6pHNN8hDAB/AFas1AVqO/xUmAGGtH5/hKnR9lEbIu+HghqM0UMebLUVmj//8ZQ5SrsaiTMMIGL6xmgco+5m2yqoUFMjP2wCJa92U89hkkMZCwTGP+CYlgK19S/ALVPtGMGsBfE8a/yKRbMF1tFiTKS6G4QF/yIbR3JJR1ll0SlE3x8KrQ2cX7rIGslAWxNtmhvGRp2Mma50LDdiTIzthSa0ezKm9dYPn3i4XkTspowWUEJwQKPQw7COWmeQx/cA+GlO4sGu56c+SMy+qKOlyJiR+DNbF9MXC0UHBmFfbLJqMqsidlOougqVaDQa/EjWxITc7oA2wbG5WPY3ftYMI5FDtWphCpB2Qi9CKjRl0mg/J6tXL0N4f+dSwMiwxqv3DJfc0MtIvqLRm0vph/JZ0x/b9bWsdyD57K7PHRCQ2FPIVsuz1LXUsK0GKVN18El57JzXIfXuw3Rbaivpv96fRR7CTYtiLKXqu1T78j2u6FUuMk3jbLXyBokE/rwm3iUpYD+ay8GY07a9gUVSqJJQQSmX4wZLGmIqy/f3R6snWtq/ZK4VlunQbf2JHCGkvQOPdqjzqjtXOfY4iU2CwNOj5Sn0ngR1GVOHEWkv+Ddd6
 HO+lwrcW
 8/zS6dghKZ3nvyOp5ENzB2sbNkad3rD2uPUg0kqUl/4JgLV2Xkj68chJrg/6iOrcEvpX0dwwID/2QOxtMzU/Cr2zy1fr1C7ac+4nsN7mib4p+XVjsihvoHNES9XBOyhwudKIwNJ40j8tFoVtEBP5FtYj1RkG4T5u3ZA5XBT2h2oMIMaqhon+F4xeNusCR1YkzHwJECQaHv4oza/NipG8d79zM9xESvrodxbbG10HRAsSeB1EO2Dk1APeUDnMIfV8CqZRsCsiidUIDweYJi4U+bYEm5+mY506LHZ6jdeRUZUNvZZC57FbJ0AQ02hE+rvaGZQwv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 01 Jul 2026 00:04:05 +0900, Sang-Heon Jeon wrote:
> treewide: remove unnecessary invalid range checks in memblock iteration loops
> 
> The memblock API guarantees that for_each_mem_range() and
> for_each_mem_pfn_range() never return an invalid range, meaning start is
> always less than end.
> 
> Several memblock callers still have unnecessary invalid range checks in
> their loop bodies, so remove them.
> 
> [...]

Applied to range-checks branch of memblock.git tree, thanks!

[1/8] arm64: mm: remove unreachable invalid range check in kasan_init_shadow()
      commit: f6e6c57f2e100813be6d5882060fef81cb6f32de
[2/8] LoongArch: remove unreachable invalid range check in kasan_init()
      commit: 68d3b7d58237b8794d9343210d4c90b8381cfa96
[3/8] riscv: remove unreachable invalid range check in create_linear_mapping_page_table()
      commit: 99e60ebe108817fd48791f2cb81f1e672ad8285b
[4/8] riscv: remove unreachable invalid range check in kasan_init()
      commit: 8008f6995d0c0cf22e7b4d60e95fe14085c10f35
[5/8] ARM: remove unreachable invalid range check in kasan_init()
      commit: 3db1a9ccf9290ea3fe01aadf3bd743ef7032b24a
[6/8] powerpc64/kasan: Remove unreachable invalid range check in kasan_init_phys_region()
      commit: 21e95a4b6f34770571eeeaa6adb535efba1b7281
[7/8] mm: remove unnecessary empty range check in early_calculate_totalpages()
      commit: c6af91e48594191f62ad3c1fcc8269b1eb539ef8
[8/8] mm/hugetlb: remove unnecessary empty range check in hugetlb_bootmem_set_nodes()
      commit: 2db44dc8bdd3cfc933a3193724f4d38b03e35b80

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: range-checks

--
Sincerely yours,
Mike.



