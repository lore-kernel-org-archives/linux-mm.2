Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D7F8C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21AA6B009E; Wed,  2 Sep 2026 07:57:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF8526B009F; Wed,  2 Sep 2026 07:57:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE8B86B00A0; Wed,  2 Sep 2026 07:57:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A74546B009E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:57:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 439C41601C2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:57:24 +0000 (UTC)
X-FDA: 85168672008.21.92BF795
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7A2ADA0009
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:57:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rDhX00MP;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350242;
	b=Hm9rxDJbYGytmjvap8adUG9PcbGv+OzNjTpa+hMOSo9+VS2mqrMKpFyWnh7ePsox70gKNv
	4GVFf3HPZhzm05+6/cHsbJof7TlrJQlKItyPCbuOsexPbtFcLuofS7qSvVUfMIdBT3HyxQ
	GQ6IlZTrvnQLlR/HFr15tdA60XhQQ4Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rDhX00MP;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=chNsE8Ke7xdT/EISIe7ReMS0Ty8iViCsqBtN5SVm2ok=;
	b=7xWsbnGyj4nve+Zt0+hCqZRiApUzQT+NarXnSPzubYCyiWrIw4kWDlIBEeaHnW7lTSb3zx
	IBMSVIDxbt+ETTVnsKYSQAkq42l82cKnPxeOQaTl2FnYqkwn0sOe9KSYMtvqpWypCBJaXa
	xRimAnvqfj0BXbHUUfDtWFVpvN9hvrM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F23C61682;
	Wed,  2 Sep 2026 04:57:16 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9A6603F85F;
	Wed,  2 Sep 2026 04:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350240; bh=AEzoNqJWVGEbFZMm+Tu7vEHKp4NF/8YTbhQnUKsI3m4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=rDhX00MPIeeIR4/aNEALnSD180H0Rq4w476QmcrQalugOcR068b6Ssx4dUNN+D+7M
	 NTCmQ7okmA3nur8IK/sSj2IT8efBSr5H5MBtXxSIGdE/mWPzf/LtQtpk5//WWhwMpl
	 QDzgztTq9IwHHlxrFQT2hNqr1xsq+hTgnATXvCsM=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:08 +0100
Subject: [PATCH RFC v3 06/21] mm/pgtable: define (pgd|p4d|pud)_leaf() for
 folded page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-6-5d8f5b17c25c@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2645; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=YBS0Wsk+xkEZqH0tYrGlw8G+wUvAR+VIvzuFsaQMCdU=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7kbsa357ogNAOMBFKPrS36nRaOAW3NnTvXN
 g1Fn0QQqKWJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO5AAKCRBt1cPRWsUx
 MzDoC/9z4m8r6ojRFiRZMEOkVvdnc4vvf7uPxKhHnjXcv6Cg2C8vEkuYn9TPkuh9PTW9ENWRhzb
 yJiujsYNPfHUzu16XkVVMy03PnWyfefbhdbj6XnqppUsLXXGgnYGXwjKKguXzhGP9VZl0Xvizcc
 xs3I8jR/vRFlKh/JJxcQv+mTbY4iTYZg9PurZ/0XgJhnJ8xvns/Qv4R9fdQpKLYxo2p5gJOMlQU
 9bVt+T4JpLNiZvDYEVumcxzuFxzeQkKUGxhZ7Y3/OCO4OuGo1rE5jpU9q+IgA7ojcbXZ+gaaOjt
 cpY1tD4oA5vYqZ0r5tgWm9CnO6QEkhy7W89kmB54q27+Po92E71tEXZSOAMS6zs/IBgIIu9bF9g
 8tyrLcGNPySE/WE3c6HD5TBY6cn2nDM3GlvOEwlYAs3SLBpDTj/XOYK5rgt/2dP5snbu273q/s1
 1YrNxbGBvCWvC32W1ZWq6nQkFR/ucefGCfdA5vSU79pVeB9Z0XlfeqezSFZiqsSHq5cr4=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Stat-Signature: x1eikmwy1wa66w7e6ssqzmm4nkbjjieg
X-Rspamd-Queue-Id: 7A2ADA0009
X-Rspamd-Server: rspam06
X-HE-Tag: 1788350242-671175
X-HE-Meta: U2FsdGVkX19FBCXX0FHvNaoAEHR671G7n+ug45KqExQ6DwaQwZtfOHV+6D+j0K9JpdAKxwYOPw1bPz2wscsUa5Gg72GmXvE1uOUrNOXwfKFjioETvc5kbgnspjUxenRDtT6CqbHL7NtHV9mjEk0yT09Hzu7g1goqD2vMHL0T4gKxHGZzLtWEv9v1a+QNKw2sFYajAXRnsAbH9YuWLums7UvJdM+HwYbgmTTy2H2DPbbcEX4UCSxgAzBVVB5woJJhz2jNflFfP/1epqV+qxHXeVrzEhbR/jhnkHf5AYbGkpAj5TAEi7y+iC03qqxW+WjSwbiwtrEKDtQTvD6UAIJq4trShcIpwvxwX+8urNg46+CzO2O9qDzH5Ir7URd3/9H1AxM45kdsstPsF0nCg5XPwE8Ih0mFRwO2jsOBP/kdw5d7ptsajhw9FftehS6Yk4tovz0AYCUIfYsYWR1V/KVE/lFRQgzI3cAhcQxGugGJERetV7f+VS2vXLeyPiQLnAztNLZJjqfb7+ax2quhb8HU+I8uWu/FmOapVvihwAc2vahTg2a2EftzHLjvzLMFIVeZBftwURE6iyFLB6XxAPi/tUseDvYtyuYNMlUUBCf/MFDTb1hX+f47fRzuM7qec7ZzGeYn7CGFn3/hvvwdCkEBwii8fJ0wqYUX4yOVtozTcjukm7d7CrWl+YWUy9o5A7MQkQlNLmzo/dxoEA4xMKLKGmrwA7Ywm9T3q2ukAYtL++Fu4dN0/AKBkgIQnk6iHr0AAR/ggcnQ14GElFNY/sBZ//Pfv6sZZokK50+fsUFquE1rDIVd949SwTNyBjR9RqyNE7qugXMinkcb1cAE/sh6NSJd1jdVA99CjLTXQjs0OtmgxtSG9Dk3vDjY6vLOrLUWBTLTuxYt/BPh1Hr8zZ//vXNwIeYoZFuHDzpEflpOn1FMkkU1pdOeqQjDuYBCbSBDN9K777MB4JRWTygq6LF
 79ky9Uev
 R0C7LSi3rAqahPtz+E61zk+eGiKER43NmXZr3mTsfACCX6KDvfhIo+gFdr4h8y3biJlHmMO4gzo1nIjTPwXOuMsTIqvT00ErX6dpPShaI3ykHr12NkVBwc+ds9uIxDerpXXvhsIKTyaOVk5NlSLB4G28S6UURM5Qm5FAq2wfnhb5A4qZxyZl6K+wDGGtxXxATzrVRfPgGPqi5rs/ju2xD19WhQN63MuqpQ+I3ZSLbg+4sfSW5YzyBfBYs51X+cSB4GLyVEe7vf7vZ2u4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

Define (pgd|p4d|pud)_leaf(), hard-coding it to "false". Note
that it's missed to define pud_leaf() before, allowing architectures to
unknowingly overwrite it.

Still use static inline functions (type checking), and while at it, just
use "bool" as a return value.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/asm-generic/pgtable-nop4d.h | 3 +++
 include/asm-generic/pgtable-nopmd.h | 3 ++-
 include/asm-generic/pgtable-nopud.h | 3 +++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/pgtable-nop4d.h b/include/asm-generic/pgtable-nop4d.h
index 1cf739ee38aa..c6a5a43899b5 100644
--- a/include/asm-generic/pgtable-nop4d.h
+++ b/include/asm-generic/pgtable-nop4d.h
@@ -22,6 +22,9 @@ static inline int pgd_none(pgd_t pgd)		{ return 0; }
 static inline int pgd_bad(pgd_t pgd)		{ return 0; }
 static inline int pgd_present(pgd_t pgd)	{ return 1; }
 static inline void pgd_clear(pgd_t *pgd)	{ }
+static inline bool pgd_leaf(pgd_t pgd)		{ return false; }
+#define pgd_leaf pgd_leaf
+#define p4d_ERROR(p4d)				(pgd_ERROR((p4d).pgd))
 
 #define pgd_populate(mm, pgd, p4d)		do { } while (0)
 #define pgd_populate_safe(mm, pgd, p4d)		do { } while (0)
diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index ff4235cf84d7..4e5aaf253b6a 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -31,7 +31,8 @@ static inline int pud_none(pud_t pud)		{ return 0; }
 static inline int pud_bad(pud_t pud)		{ return 0; }
 static inline int pud_present(pud_t pud)	{ return 1; }
 static inline int pud_user(pud_t pud)		{ return 0; }
-static inline int pud_leaf(pud_t pud)		{ return 0; }
+static inline bool pud_leaf(pud_t pud)		{ return false; }
+#define pud_leaf pud_leaf
 static inline void pud_clear(pud_t *pud)	{ }
 
 #define pud_populate(mm, pmd, pte)		do { } while (0)
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index eedee8e3ad68..6c9bca78047c 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -29,6 +29,9 @@ static inline int p4d_none(p4d_t p4d)		{ return 0; }
 static inline int p4d_bad(p4d_t p4d)		{ return 0; }
 static inline int p4d_present(p4d_t p4d)	{ return 1; }
 static inline void p4d_clear(p4d_t *p4d)	{ }
+static inline bool p4d_leaf(p4d_t p4d)		{ return false; }
+#define p4d_leaf p4d_leaf
+#define pud_ERROR(pud)				(p4d_ERROR((pud).p4d))
 
 #define p4d_populate(mm, p4d, pud)		do { } while (0)
 #define p4d_populate_safe(mm, p4d, pud)		do { } while (0)

-- 
2.43.0


