Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88620C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FCA76B00E9; Mon, 21 Sep 2026 06:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ACE96B00EA; Mon, 21 Sep 2026 06:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C796B00EB; Mon, 21 Sep 2026 06:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 336186B00E9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:57:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 971C4140138
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:57:10 +0000 (UTC)
X-FDA: 85237467420.13.674C202
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4BF5D80008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:57:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OBFz6Z+R;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988227;
	b=jP0qS5u7RiQG+Nmmn6q7huvN/+sUN+PKFE/gFrCQo+cC+cBoERTcIO9MlTjKbJX8B18deS
	tHa+LdYpruHF34qODORTdN3XTNWdSNglbxiRS16kbiHqxqNwlN1TpQnvNpPuPxo0gMAvcH
	isjGFcmnXlvlN3709IAZUuYESvv+XA8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OBFz6Z+R;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JqJcyBohCCmTzbrZNGYTNNTZHJuSiPVln17AJPhHdQk=;
	b=hK5acpxUNqzBeSB9RYy5rV0JBW8UMmUD1HobtgJMA2J2E4HeWrW8gcxYo5UqUAc4GkLoYU
	xbITQT6dnH3rjs/OvZEnyt1aAdeNjC4hnRRoeZ0iOdDN5hkOfSloBoI6hvkYFSlVpJMLCB
	rhE4UQdV7lVAiuPt5GkLQIhW4l+LgBQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E62EB1570;
	Mon, 21 Sep 2026 03:57:02 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 563473F86C;
	Mon, 21 Sep 2026 03:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988226; bh=t0SkgFkvYDykWTdwPClx+wiQRsFxgewU3m4qBQArb9Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=OBFz6Z+Raz7I8ibgsDiaiNLTnQsX4oLEoKjZPRodWantEpoXhmxG8yAOCFS64FQx6
	 TnSa1uoOW4JI3vs3idHKAZLQrb2k4cp73AJbVjUGApg0VIpLWNjF8iXjbLwLCJOMOP
	 KH6BsKk5W9konyiN3h+HCCs6a4q5K9z2QxYNfnPk=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:27 +0100
Subject: [PATCH 05/21] MIPS: mm: define pud_leaf() only when PUD exists
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-5-cd40cf68242e@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=952; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=yLp6pLFkEq1XlBsrO8HJPn9OYitILCqfI5l0JaR3PzY=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1NTZ/a+wId/oXop6nBRx7GoTqL9a7Er/mVm
 I4zdOrs16GJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENTQAKCRBt1cPRWsUx
 M7A5C/9647RRGO+Rm053IZPrkfpK1qoCf6h7h++dBQM7iWcjgmIysinuJZ/9flN7m3N7/8s0k1F
 Qg8UBSKcYxAPzyP7KMXSKbC6blVlpHWz3kExm+/5ZAnSr3JetwJGEw0WoHg0g85dvAd2y+KV0nj
 fcMLKAxYW9EKQIqMG7nuATB+F1lWeLPWUKEeZ5Xr3zYvC2diB9VgvhinADx3ajrN78j7ASV1xes
 7//vZ8p602dtxNE82CTR6O3KYyUFHq7mNoysyRhtRvpNYl2Ts3NfvwNVO6vCLxhNLIIYu7s2mAc
 n2FreTnlSvWWzFZQfZrm8tZrPteyXRjmWvqXceNsbR4SJYTafBHwQjLRLGhy8+k1iRjDqguBSwy
 LsoRrK1Q0udKYrD3CKiy34mvfTgVS17T60Z0/lwKClICrmLYbw/pQoCMDwpPvb9abrZB8uyEsZG
 4+DpL7SndbO4XS1cejsKbd6M7jig6sw/xhWPdMK/bJQQY3QqubKCQrarXnjeyHzIhJkqw=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4BF5D80008
X-Rspam-User: 
X-Stat-Signature: gqsgu76u36sqgbc8ousqax36km34rx59
X-HE-Tag: 1789988227-682464
X-HE-Meta: U2FsdGVkX19I4JG5k9uaCJwJgz6xt1sGHPTsF8fgCNMG6nIdpqfrFeYibHJMlNPJJ9X29b7oNKmAJZaU93tbfTTdIaoaQirO2nzJ/yc4WtgW0vA/W0SdQjtql3Y1aID277PKr6MtNhjOdHTKOhS0On76bvpcnRH7TvrX42eXvc2BGOHjuoMbVNZGQVml15eKf1flXrrEgkWzveEmCKO0/MV97KYtRBtOCIy37qQkSL6EUwCmLnDby0FTi4EfevRZnN/kzNIYiqQaYGDOizdnsfhUtqcNlTvvZJm65WD4i97XmdpvsRWD0crxJo/b1MfqT0ZGFROJj6oqO312lWF0VRAjBN9lBBEKgQKgE7wxhyDxYfxl9C0DyZsmtGVAVNqiKZZZ0/8SIbj5qD1IHSohhMz4CrBKNjOFCR5+pXTDTf6bKl21n8+tYIpud2x7j/Q2MaJk9/Y5ROmu5DLxepgy7bGk5SkG8lDVNXM6+yKbN7qeLLLuU+AIL20+y2atpzLusmDzjdvEV6AH64ETK4MNOkKSBf0ugqf53xqcBBDMvOdEriwTnwDsnQ7t7N1Rz7229c7WrFPSqCcf3m13qZbFMXvzytWt/STtMa6lm5T7ymIleeN3ba2pQkWvJ/s+QOvSsAcKhHded4nunbTjAZMof3eMLWGo9yFC0HpOlpccSm4vTIevyCXcO9GJDkYnFraOtCekeV41QFhiolzyM1e7hshySkJfyqqKIFNK4WJqSFOJQQeQ8WmpvUa7sNuRAFqNqJKYOaCE57VyWsYLJ6bjSJnkZlA5KIjoGk1l3in5twYGjTWv+KfWodNwWSbOT6oNCG67gRSo+q4Wlu8lxSevr6XBOriDQLF0EW9tkNyHzWi+ukB71yLsLZDHTx/mmU4shhVAiNTlNlatmHm6KIS3j/hKBUj0tQyjnsVYZbJVn7hTgSjY761iTnDVP7yZd4qBH3sGPKMbwpzjpbdJeM3
 NeX8WyGs
 QvkLRqpy9X8HCuvjvRSSi0HqN3DZ4eTX2aR5bSdPJEEiwQj/nM8SpemnjWhln85mtWQ+b6pajPAEuJFdzcUQmlrY1M9zyvAoNYmQhkppMUEdsf6rHSBPoXEQp/Jv2ly5m/i9WYAxlWTnNKhyfLuAOjO4tuSknC2BTqxAOizgQMqwLaTZrbeCKLbDimch4Ky6fRF9W4YCQ6nsxjVgedGFJawjSOKfT5POotWW/HjrjZVMwrU9ePZNMfbFGMERE9Ms3JsWtE5tjbMM0HGg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

In include/asm-generic/pgtable-nopmd.h, pud_leaf() has hardcoded
to return false as inline function, but it misses the "define pud_leaf"
part.

To prepare for fixing that, define pud_leaf() only when
__PAGETABLE_PMD_FOLDED isn't defined.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/mips/include/asm/pgtable.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index fa7b935f947ca..151f4d15bd12b 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -745,8 +745,10 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 
 #ifdef _PAGE_HUGE
 #define pmd_leaf(pmd)	((pmd_val(pmd) & _PAGE_HUGE) != 0)
+#ifndef __PAGETABLE_PMD_FOLDED
 #define pud_leaf(pud)	((pud_val(pud) & _PAGE_HUGE) != 0)
 #endif
+#endif
 
 #define gup_fast_permitted(start, end)	(!cpu_has_dc_aliases)
 

-- 
2.43.0


