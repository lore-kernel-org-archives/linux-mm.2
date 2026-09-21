Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56731C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722A96B00E3; Mon, 21 Sep 2026 06:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3466B00E4; Mon, 21 Sep 2026 06:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59A9C6B00E5; Mon, 21 Sep 2026 06:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37D4E6B00E3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:56:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 989E3A0134
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:56:39 +0000 (UTC)
X-FDA: 85237466118.24.C22115C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 82365C0007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:56:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LoVIGTLg;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kp/z3MU7YGBqtXkYJdrZFPtXjtQiMfjPy6zAGRI75f8=;
	b=po0zFcdLt7GdYVYWYTovjIxBjrNcIL5cLOpvvIoHmA64kftuZkfSFTHf8kfa/EZI+DUceO
	1BE7MxXot75LZej3lj/CB3XCPGCwK8eVOG7BFQItsMgwdgIv2olsx/38I5wEyPxFXfoF7O
	E2DYe6uFdOlRahinGpvv1kyAX1Kwhmk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988197;
	b=SqCjQSxLybYkPjfFHzG3/DmMBAgL7YHzsro3bd3W0UjS7IK6HIKaTi7l7QXa+V2en+Hsa6
	C7Ia/8swJaUMuUmM1gFRQ1l1GyzjyfQwGMPUBceTZSm492LOdgE7BLrvUs9c4iaIIT13xL
	tPY6CrgN5qs6mrsFwN8EFi+tZkLKNXE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LoVIGTLg;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B0511D13;
	Mon, 21 Sep 2026 03:56:33 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B6A43F86C;
	Mon, 21 Sep 2026 03:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988196; bh=vEzrqCWaH6sVkcTMp6OI/QOpWZT9yXWBiNbXxiv6lmA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LoVIGTLgqzJ/qsqv8y1uGB4x3jrgj3tiInD07+v3on40VZbIKUJCAuRuyG/NV29tp
	 2kYvHL/ObZV5edLNO5Ve1LLYQoVIgW623hWmFpOHtD/L2MkwE2PM9UirSqKqtoX4Rd
	 H6xBWMlbZQB3YaYeY2mpGRniH91/tkMG7ynZ8B04=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:23 +0100
Subject: [PATCH 01/21] ARM: mm: make nommu pgd_t a scalar
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-1-cd40cf68242e@arm.com>
References: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
In-Reply-To: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1081; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=ODmKgHrv0SlU2okc3grPddikJ1BO4DLAINSWVDYQruI=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1LlWiizi4t012wrwJwrwJTjWi/Wb29nF79i
 J4qQoShg02JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENSwAKCRBt1cPRWsUx
 MweXDADISibCvJvF96puZBjP6/j4fMPKgIlf5MS3C5eSagiY6JFxwj3lAIkbhiPFMPYCnHBJnoL
 2GA0NpEJpJyNWbhsAV12S4u7OvsEXVxhwfJkIzZS58W9csiUCIZFEIJeeoRnQzGnOFzFUkakRVx
 qkc8XmG8/eJznmc+Dxlnulm0n2bZYi5j54S/rQd/Ikdo5m9A+FMeYf04ijW4O0svRQScvjMFPe6
 kVraASsRz5EGbbRfoH4SMzCaalxthaqxKHBUq7g+H588eoHoKXinUFv1W98H6pqtwKWe5asm+To
 Eq0zBQRFHajwr8D6LBzww0jQnu+df2It+l03o7y/78Q44wTlBaVaUJDhnjb5Pdeawtwtx9Z7aj8
 duzExW/pl4kS3fr3Qof0bszw06VRUoqAUgb0W9KH9UoDBlwrzFdOABfQtidFW/gnhWEAX7o8d6b
 xzsbDSxkRRzb2wd4Lxch76ZEGXJe1I90lQHqznhSf5wCWubXXZK8jVHUqdjrcZKH73914=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 82365C0007
X-Stat-Signature: 4a5t778kcwf1c6bju15ehfds7ystz85q
X-HE-Tag: 1789988197-800911
X-HE-Meta: U2FsdGVkX1/FSIys1DsMVXFA640DVb+lT91l+QNeEdeQeOS6ELaMQp/mxpaJsPSK8GBoN4pfzE5bxcls5pmdlsSwBJkTnNeWCIvzeKr3cNoldwrxNZWE8kkuxne0c6z5pfG0Nh6ni3kvX0v11iJKN4fSdLwmhFY4z6+8QRHrMnFAuJ42Jm/uECZcEMgXkKkcasJqfKxvI5zAka7KJOZtSVWCap+u0yJl15aR5hdlKzDxymdQJfbJ3s9HJ7LtupWZH1QnjjTy59axNijHW35j3tyrvxMy0mlZPBWUT/pq7cb0bPuUYjKQCqwCiLtu54I3+PaEXTvNfAqS7ILMCC7t/yfWCAI00H/Untx6CNzbBVALI/QuMljUH30aM/KIlZeSOj8mrNjKb67vZisOURvMEBeNX0jk/sgRNy2pCrsqFCrzFgNWleRmYsifBD+5zZsXepKf5VNrIH6AZpA3MTA/lxNHDahQ4wz8LsguJPOO8R26WyPgLdanL5yIiYiNyW2c9y4i21vpf3cV9tluc6JaLLOBId2vgFWlSlhSSPOFK6AE+xGfUobAfmbCFktod2x+gIbWFVOwcB6XATSKHWkwrl9JqOC8i8VpEiPVrh5oO5BTGtnaeGgXxOjozO9rcE0OLWVpD5JWieLppuznyHqgr1zgz73tddVTgCn1s0l2C8CzGfJQovALbJdvrrkw1MkNRTEv/KDniNy2g2imGiZbMS5Shgo1bORMoxooldMpwvNjtalTslyWw6a7ai1Eh8nqxP+nESy8+bDYV/hfy6GGznwExTa/Nl0vnMeypbAJ4pEpyefDuBNcdjxhyg5zOObnW8LRFYB7Xy7YlpS1k73dOx5RJo+rPX15XSVS+NjsWQIvQWoxdspAYBav5vEMFHnQd58Z1XICIJBdMBcCT4SNRPbt+2QPZAyjpg+euq7aFiRnipKtZ+QwmL1tqtf6pt/pxuuvLIjCBLpnCkX3SRl
 BoQj77qE
 xAK11B66u4VBl9b1at8E1UcBCjWLrfkesqbgsYt0KMGXNS/JAg0wk1Wa065iD+45qnCfv/sUDwpbvQMgkxtciLXFIBmdlVxRpwjJz6Wi5XUsSmtMBNG8PVboh97ACVxj0x0WKsfb47WVdpmF2YWqz1R69Erhl4qnOJKWFyqjFypfzgrY5xpA7tD5RqMR6FJu/eQJ96tKfCqjKKbYobX5Z3pwSRNfCrfIKg+FdbvZRgYJYv3KYyL9RrFBrJdIUa9+yfqfk4VA5bSkMbEM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

As pgd_t is returned  from a function, like pgdp_get(). pgd_t shouldn't be
an array.

There is no need to match the actual arm page tables, because with nommu
there are no page tables. It's all just in place to make the compiler
happy. Making it a scalar will make the compiler happy.

So let's just use an u32.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm/include/asm/page-nommu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/page-nommu.h b/arch/arm/include/asm/page-nommu.h
index e74415c959bea..88659b38e2364 100644
--- a/arch/arm/include/asm/page-nommu.h
+++ b/arch/arm/include/asm/page-nommu.h
@@ -18,12 +18,12 @@
  */
 typedef unsigned long pte_t;
 typedef unsigned long pmd_t;
-typedef unsigned long pgd_t[2];
+typedef unsigned long pgd_t;
 typedef unsigned long pgprot_t;
 
 #define pte_val(x)      (x)
 #define pmd_val(x)      (x)
-#define pgd_val(x)	((x)[0])
+#define pgd_val(x)      (x)
 #define pgprot_val(x)   (x)
 
 #define __pte(x)        (x)

-- 
2.43.0


