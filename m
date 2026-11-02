Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0113E60A263C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=A7rQE586
Received: by kanga.kvack.org (Postfix)
	id 23D866B05BD; Mon,  2 Nov 2026 06:22:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ED5B6B05BE; Mon,  2 Nov 2026 06:22:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08E906B05BF; Mon,  2 Nov 2026 06:22:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE5726B05BD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:22:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 85B341A0C5D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:16 +0000 (UTC)
X-FDA: 85389940272.02.7DC1E49
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id B1D56C0006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=A7rQE586;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1XXfVIkNP4nITGpfyLSUIpM9B8UBbVvkEA7ohODjLRw=;
	b=7C73Dn0NmO0g6hvcZ6l2dh0qn6XOwB0XxDcxDFBwMyDIYZRP/suCIkZFejJE2efcBZbSJj
	PQV7YaSgtqL94l/Uz8uw4ffGutykKjfEzXVdT3KGrkV9sF+iDzxq+8fsy92o2NxYYeB23S
	CuTShHQtdq0YLjzvjrLvG7xJw+Fnl2g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=A7rQE586;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618534;
	b=il6+lyLjv77NoP06UHjnd/bIOcygMPYvVIuBUvzxhvlqnBziwmrgcbvpMOgiuRNSafh6vW
	RGN1MQfYWFwClpFGKT06Ee/PjVxwa7IN/caJ84gVHXL5AZvLQT+EcFjYXp1HkYmIvWXGbC
	tbz+0QLdo1vK3oN60bEEVs7iGULV/bw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C90D9293B;
	Mon,  2 Nov 2026 03:22:10 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D99E73F632;
	Mon,  2 Nov 2026 03:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618533; bh=evfeL7lk1yM+NSCKYrKsUpK8FtfFqKH2c2v1uANMiZA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=A7rQE586SxmeYhdbuDjgGojrf+yFdXKkVJvIWE3/CkvAh47B/hi7pieq8pgJx6OPd
	 7+IdQ9YxhSeIZpcu39Tq98FmLu1Q3ge8+e61N66fuaQUSiCZLJB7SxbfiAp/g9FEqC
	 pD/C97hYRDBX9CkJO435UP1+7vyxZpzRkF237Vvg=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:19 +0000
Subject: [PATCH RESEND v2 06/21] mm/pgtable: define (pgd|p4d|pud)_leaf()
 for folded page tables
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-6-78840b2ec73c@arm.com>
References: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
In-Reply-To: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2651; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=MsUi6fKiy4C8DH1qxUfB7PhJ8/xMmbWjYscC+NJ7HZ8=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HIxIVd8yfHE+3CA9LTpZi1gUI+XMCzgs5U2Q
 BHJBi3iXj+JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyMQAKCRBt1cPRWsUx
 M/V2C/9ItyCxgxlMh10fHR69tVgw9EuphM40QYD/mSrn4nLbxqXwGeoRCXJD/CQZjbzhVqNLqD8
 4pI+P8VaiZD1ROaf98yDqlm38MdDfJo/nXweMu2XCSuy8bvJOZ5akdNLIqOCNL/Kky/4vAvfA7y
 g/DN2CQi8iHcZmgFZENpatEkLXDT+irkdH/T8momUPL2iU/gMe9+PBe83/sjStUInekkPY+48fS
 tQ4YbgN0JI0jsnh5HfL7yHY0zHyLhvoIlmUPykZRIofr+KodLXQYFHAKOkD2khVIs/r2bFJxKJM
 7EZ9zMN52ptWFsHpkIIDhVoEnRhnj2vRlH6U7Y8kV9ZSGk2CzFCTZuWrT3cGyiZ4sRJ2z/gLRS+
 DXMtq/JtOP08ZaADSQRymmkYRKA9PLkrAtBZXZKwEO/gg81uxE4KT+wj8pXddgbXPnOWNxmpGA0
 MxTCMq+1KtHR5HFt8aTkW7OiLozCLtwsA62FVhYXV48+piX5IjzAgVxuzgBp34DGCh8VI=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Queue-Id: B1D56C0006
X-Rspam-User: 
X-Stat-Signature: sj7hf56bbqyr6eyzgsbmy8h5xkjwncss
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793618534-558914
X-HE-Meta: U2FsdGVkX1+QprqU+tAfn4cQUHNODDyg8vDNoItozx3/KaNekH8gKEvDUlVu+Onsi2e1hKU5e1cOJzlaxtJdjezseCOd0USo9gsgB9D7VfVpq3qVI8CNGUM65HJCSFx1l3bXkqSBlH/DORqIpF/AnFU3LnLWFDfbzu0yCIDznpE39skNd4EJAo8RyqEF2pmo3mKI0rDzzLWSo2bPfHYoxPVcg9UH7F/Mr7zCcZ1cZa9UZp7iqrIJ8uD4l7w9ZF+NGxrEigidgIht/HrrrWjA2yoqhB+bpKf4DK0lf7H0htAVV3Hdx2ddkLmjZjW0N/bsy4zYXWe0VayUsdrn7R9YLqY0EUPMbBbumg+4U/M71VvsyJUyhTT2RDjEMl0XIcUfuI9415ScTfrluubjs/H6OR1x+oBYSmBF5vKiK02lpm4zeE1C5rh9u3PFr6XnXB0gCZuEPPJep0mNxpabbhknswjYd7aSV0KGfrQ5Ql1yjcra6yEsusuNLLpPGFX0Rna2+OaaCSU+bQDY9s8njIatPJ4IhdRtMhrZnDn3ad9geTroL4l6L8U3ddwSp7X4JBqlgUQ0cG3kW9qFH5f3xkLLE8vWNGMPVy6VJmWYNIyHSq+tNh+ibbTFNcoGJBrzPZ2yd5KQ/KxWNUwS3ZmQpx/iGjWhP8acubmKKOAcnV5hDVrg3wXmx169l/RH9mDTX3Zou8ALoiIsH93wjr/oWL579Hikvc1bj2ipRtRRptoBBoZ7N5EjBNjWktZQhGatluXl7qC3WsVs7FKP2I7ahVStuYLrcI2enUfvoiR4+xH/m/oR/QF137qtF5ao9+Umy+8Rp7aW3BJCHe5XRnlTpKvomSY2xMJ4SHyZ/mDa1YYBziiMF8O9TueJO3M/GhhR000nxVj8wdvWs+fBtwDXfeyKfoelsapTEUIJhd0DO/EuMFU6iQLFbpR7uMG1rD0vBhjt8b5kqq1Tgqmb40CARZV
 3C0itQe6
 W45JgVzP6W39m6apxxvvQGaDRdVZTiLF9KO3koBpFONMz0apxyJ7Oa2rOIGJujDWIIoC4pkgqfrCdU04U1wi6UU8oPVFU/fkga94qaV6T+vcFiz34ckHYfkPCktuxxA/Y8Wql/bvYM7J6X1/P1gCP9OhC8Ll35SBgfxQJuldthOH+gTfcEvBrjld4eGoyT2CNhpBiX6gct1QhC6aFPimtboRt5kHq41+kanmf8MaRxQlPNemheEdNbiCIFyFroJQQUdTAV71eor5nyTE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 1cf739ee38aa1..c6a5a43899b50 100644
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
index ff4235cf84d77..4e5aaf253b6a5 100644
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
index eedee8e3ad68f..6c9bca78047c4 100644
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


