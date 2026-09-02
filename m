Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D54BC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0926B008A; Wed,  2 Sep 2026 07:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0D56B008C; Wed,  2 Sep 2026 07:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768C46B0092; Wed,  2 Sep 2026 07:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 527E16B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:56:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C28381A01A3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:56:46 +0000 (UTC)
X-FDA: 85168670412.11.70F195A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7F6CB16000D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:56:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JWpWS3ff;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YzC+xH5kHp3mPRA/FxZbQiRwjZfaralkx9P75P+hopk=;
	b=lNvdfRnn6+R1USWm5TUstG5tZ2sCmPeF3bMv0BNJ9ytn5MdGWkBzYAifRDDUlwLVOqNqBs
	RX/rLNrg1p+X4+f335OcfBwvFJfJ/5RpcWnxxbIYXIqzrzop712EDdPXqWEokvGtV9Mokw
	pjRup7oKcu2xCn45tigFx09V8YZpY2U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JWpWS3ff;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350204;
	b=dhQh46VI4Yk8dzf4Rla85tr/I39tQVXvFomblyWvfHZ45nSdiW2kgKsTBDF78tMqJwglgk
	IR3ZrNBPk1tuO9IkO+5d8CJEtlmvYs7ZrEN6Rm36zFCK+pwsFYpjh4KxdM6yb0hc0quhVJ
	Nqd8YnoOPyh09cDUjpE5pg7+zJmuV90=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AAB7F1E32;
	Wed,  2 Sep 2026 04:56:39 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 511A93F85F;
	Wed,  2 Sep 2026 04:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350203; bh=a5z3VgCuV82F6RPeAfMv4Cs88UUw7cEiZjrKWSyb5gM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JWpWS3ffE1GLLis9po+Yz/mdLIadyKedxJ5+vnCEOzxzDhXnh6pni34o9WA3lPaY3
	 8YN4snZQJKN3Yzki8gEyuot6J5purDrlO7D076nrar2h0BRSWrEd+IKOfPbM2DjdVf
	 C07c/tMLjlLEZskvetTLzowjaVa4wJ6vh1NpkUUc=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:03 +0100
Subject: [PATCH RFC v3 01/21] ARM: mm: make nommu pgd_t a scalar
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-1-5d8f5b17c25c@arm.com>
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
In-Reply-To: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1079; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=yuk3S4RfznnTM9UkPeDtkv8dyVxIm22Z2ipCHlRDCbc=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7idg6lSNQrEggQ4WH6Gwya5B5f1/qCND8aE
 jNsah22k92JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO4gAKCRBt1cPRWsUx
 M55BDACPu7Y6d+irL9cNnQwbHZMHkOrav9grp6zTgOsqQGAkkTBo7L2FFa0BeFXUyxp8SnK6hTV
 pltmcJWh2UV8lHAWMJVNmBSoFxKABbZ9m8XUqhLr+MDF5GUzkzGjgE5bSZHsTHg3sTFNnrWOqLM
 t6BAGepWC81BIRIjXzyJ2mZ3nZT/JgD8LZcNrSbGHdYnTQTepcdZmzhnoyimCOg99vs+8L3r2fW
 1VClNEqJS2ceT73Hq6m+JDHPWRdSzaONSKJBA/eJgzMe4GJgyEHi/3jgaVAeChVBhJznjucUMlx
 Ctmk4MhHoQDs+cJQD+cBseLnlWTZObzMPF2boQvkQJcACt/xdHAj9/1Qxpdv92bznvMpJpgY8i2
 SsRO65VvkR3Noc63S6LyyXsfSSojY+ZlBv4nXOOBEzY76T2rC3NdKLBGN9Ir5YK8Qni76UOhW1o
 2LO5bQUuEe+C1ZjHBi7KB2s4NUJ2IfWaKqpVdrd6w14DRusXbtpkm3DQ6MMJrXbwyFOOY=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7F6CB16000D
X-Stat-Signature: dor6f4rduyqcwqbbh8594tixzzsn9oud
X-Rspam-User: 
X-HE-Tag: 1788350204-523567
X-HE-Meta: U2FsdGVkX18g1MDazNWhjrDaeKovLFx2V0jVOlzglaIwJsDExVZHOwkCiqCceHSp3QSMmPFx3VxxVE8GRoge2Ha8BZs/hCVBknOJSK8QMuPzPRD7BQWf9A3SSx/6V86vb3cwRdqIDV6sPpHjFtxe6bMmT2LBsvd1BTSDGEj4N2n5Jvr3abPS8E6YJkYCbk8ziAS/tS8/tZB3o6jn5D5S+3aCk/QrsM+Of+bUfeQVK7g071Q6PWeirZyT4NF+lA/NxcyNqjWfwhbcNVhElxRhLj4HniugJhBZEaD6M6OsHKCHeKrdQwYrBX6BRUgFYh7aChm12jlGbVFRMQe8r17/ZbtgY2+QINvYIS+D6Aip0aHpu6YDQOHBOx5tZypF89kskHHcxCSpz9th0YTn69XIbSR0perKtWkE77zpWciH9IxwLhwsuvwibrPyLL1DrwOzzL5bm65RS3ZzHliqDPXmBVdMEcEETV0xnNF4fqAK7DjcyYgW5c1x3xc8nK/kWjWOerV9iQhvPS55LLOL/itgH59/Ey0uYTevS9wvJ0aTg2syw8BfGvdNNd6/o1m3PZs31/G52Zr9EiFI4T2fJvJQRwXTINcq73ViDqCxyS1H2IGRUYn0An/T9k0jMU+OIJPD/Xoqr8lb+qNIAgJl5bAju4OwOvsKIjsx17AGcY8XMC0m9Qcsr86qjc3Hux8OWMW9AxLWu1NXGBUiHEr8ydg5CYfL3eBeoY+KJAYGASwYzVqhkM6GXOgwF+NY+DRIRYUj3/Q3ol2ispdUUQV1awGnHfun8a6Cfi7alcfWa4cPBWX7gipQYyeBN57+ZRnY6t+pnKvSvNG4DGZixt+csrR57ydJmRQJrvapTZ2Sh55KVmhafRwf/O3z7Je4V2hqIcNOcnw2DzIyfD66GQoQii60KBYRU17XPFUFRYJm9lmyHdBe23+SM4Wz22SfVYXrtXs+Hjr5kDfUV09wzsHEtYo
 AULr5sxY
 Tf589Fgup4FzgjDfBx7sdTS6paXJ1dBGWu3U43xBreLmcv2vsITrqs0feiHcH9eDE8/nQMGHbAP8hSX3xWYVbwg9giiLCdthHRGvfbiJ1pdocCVOrDp/aoX+qHBQ2/c3ktlhFVuRDTO7EhhaFddZnoikCBfltz1n9e8tetQiaJ2tBrBr/8cyYPlyu5/wVDCXNC+ziw4EbhcAWyoY3ctWhDVuofewjPTCtWTlS/ld7AEVbkiy8rXNO1QRKVNteDKh1SqaTinpjODZtWv8=
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
index e74415c959be..88659b38e236 100644
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


