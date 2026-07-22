Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61979C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C7C6B00A4; Wed, 22 Jul 2026 11:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634116B00A6; Wed, 22 Jul 2026 11:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 549B56B00AA; Wed, 22 Jul 2026 11:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C4356B00A4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:30:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A35B214020E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:30:50 +0000 (UTC)
X-FDA: 85016800260.11.EBFE520
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id A3C63A000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:30:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LnOf3bdG;
	spf=pass (imf15.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RciufHymjILq+FnYK9Q81+9UcKUt+lxu6pARl912nxM=;
	b=8anvOHYy00RCsFdkdGiLtBH6TkCprR1RzBj3sFChgelzcPMCxHjqQ0o1LXFZEmDlk0LvhS
	ucg+ooZ3EtsiFCPvtFLKE6quCZMYKfST1ze7BEu0Ud2Cfu7XFC3ofhg8c0czGTIVxA335M
	Nf3LiHdqP4+qx8l6e58knfdE3ObIs9c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734248;
	b=wYFNK+CcUtZdEF0IYVgv0OBIVqersGyQ6+gyYtOJMDLs1AmHbimHDC1bdo8XNapkLzoiuc
	hYoM7AwQC9uhJNyBj/44RK9npa+ZJ6e8zwIeN0/+XNOaqvc0PKQb0WK2EPCXG1R9FtFtIf
	JAniKLth/YK34ATtcY8TjiozrK/66NY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LnOf3bdG;
	spf=pass (imf15.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C92B1692;
	Wed, 22 Jul 2026 08:30:43 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D54C73F66F;
	Wed, 22 Jul 2026 08:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734247; bh=1TxWbr6Rxpr/d5K1ZjUMXUxW7m3hsO+YJqbH2QzQwcI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LnOf3bdGHBtoZ9/i1k15T6gHd7dFP7WuoAJk570GxSvUgd5BdOxok9HLl2YCyOHBL
	 GJxB7U5uIFfxd4a2DVlw6fjpxicCHGnU/35kh4VYvLmym+Ij0aC+RhyHruWS9eiadq
	 gW3ecxtyYk43muPXW0R4LEdqJ1kDHBQE3XVjR/zs=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:09 +0100
Subject: [PATCH RFC v2 01/20] ARM: mm: make nommu pgd_t a scalar
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-1-d9e4bad31e0a@arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
In-Reply-To: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1093; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=os/Mhoh7pmCouvRwHLkdVyqjdGpvrfvwObzVbRePc/o=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOIPcYgvYMqhwm4vdMbW1urTvtv95E4cikIjK
 9DPVoDpWPSJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiDwAKCRBt1cPRWsUx
 MxtADACQ5kPn20eoyFghflTLYxkjfk9WmMH1osH5jieI1yjfetiAaE48NyNlaslyLflmRD3m8V2
 IzZhaFDaREkU/XBda6pU7oJRJCCkiOotAMqZxAvZX/Nd0MF6rAx7hg4kBftgowX7T24YeTiwjsk
 oR97ApgGOy9jhvsswneZVWYwMRBqKQIc0YifuSw4QsQ6YxH/uVJ9RXEVXDh8eAkUNDGq/5/FHz+
 fgYUvvW/mudG8ph8NK/bi46YJTSkKJewn0uSLAvgOo8iM+Yyoh4w4jfTzWr0RB6cL+V8dwNwZfT
 8EBqdswQ7UYO8u9xGlI1ZJ+hdCIt+TpzHAZHTy/nkDt0Ierri61xOfIEpb5muzV+Ng4V3sinnMy
 LUrit2NI1caaxtzJwcEXYkYnmcSOd6eLO8crfcjPSq+mhUn3i59hVIvFOwQhgUZT4T+1nEKvBmh
 z53Y2TNgYmiKgtoqRRExR9LCqzH8L8CJiQ3bkkb9K4QZ56iY9jVjj8TiMg4dlnITDoX4w=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A3C63A000C
X-Stat-Signature: gbzejeibqrju4dw3mw689hcxxsbw6hdp
X-Rspam-User: 
X-HE-Tag: 1784734248-128232
X-HE-Meta: U2FsdGVkX18xA9rij2XMYjbQT/XPO9IYnHtqmlwdCugXNeIxyXsMSj8CwlHcACGVXq5TJk/YZZBIL04I7xTIm9MmwwjJ9r5ajcc0yuX/Stgm1rOi5O0C6iZ1MfF1Gd+dPCaJYy6W0tZB0fx/EgfivnNXz+iAqCTVMlY0dtb15UgZ7ufT1BoE3NbT+201E+H/LyR4RgDdPU8t+GAcI9E5vGIE/u28YKGVj+UEDfeFJdRyjq6mn5YhKmd17yFlM5BV9OGzT0f48fDWaGkBtwfYF1NRzoHRstBtERDX0K9pKnXf2BV6tY6fbWRho2nJTCwehxFjQ+gvD+Lzk4sveXuOjFtoc3hC8izy6oocC9UhXeGEYK9seSTBuqy1xIzVIGAAf3Re7yXNAP3c2XoLFrGks+1ls04DUKPkhuP2kLIP7pBRpMOBOyCB1sgee3RhdtdWURyUqn6J3rYIVTaqIYp1NmTKib5hjnrHbZsxRG5oNWinjIqOAOyDCNP61PReGXrzoCz2w22x2ipHuIv80ZzetFSp2e5XaFLm2MOjKCycVPn/MXU+6w5HMYhmtdz+gVsKDQaMYZt7/6xzOXW4DmT3vDZKrTgH+al8ARo1CHdyw2cp8naFAOObcwqgfiSy1Kzhd3jW7etmHZeMpZyeoYTadvIkg8CZ3PHSWLZQTD8rFhrK83nu3WFUdxQiP/oKVu4mkccZlqQ0a8U04UaN2YjASTvqs+Jd29HS3JlhSmnTnPRr9CQDca84RCUFuJnizzj2w/+tdrZIW1Z0l59yYcdLe61Uin++jTGn53rjt69SFBvBVUnBn+XqCDxMwR55yj4PY4A1WqfGqpdu5yTO1EM/QpZMlXVwV0jnGvcW8T9L0J17RV+rb5A4iGMZFUqCM2g8KFcbTaXD22RY89Ff01wE0l5tuSzDmQjhQbDd7in868agrLlDmhQEfwmNtB5t8FdGHAdhAFlL4AMsm79eqm3
 KHZPFMpY
 3fDvtjzfpBpDIowVzm5xMnZVa40hoTf0xcuPgwBkQJgP+dSEuvfZbKSKDrbI3i1Zz5W7oMCBjLrL6gcCf7buqBHmrmsSwz8BR0ljpHatZT+S4+eVkfRAIDAkgfAkZ+vIEgxSddyKd+jhI/OI09rcYxQMb38lCX2HtnLlllWhdsyn0JNY+VF1iCYw2IsCt/tCnyP+SRwdypIJHdEmOPQvq1X+0tMYg9/t0fPVJHujcQWqJRzIN4B/MhGX2lZ9OuQi13uSqr7f9xF0aqDo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

We don't want pgd_t to be an array, as it prohibits returning it from a
function, like ptep_get().

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


