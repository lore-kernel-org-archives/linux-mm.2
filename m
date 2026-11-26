Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FFDC606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gOIJf884
Received: by kanga.kvack.org (Postfix)
	id 34D456B0600; Thu, 26 Nov 2026 06:20:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3247B6B0601; Thu, 26 Nov 2026 06:20:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23AE86B0602; Thu, 26 Nov 2026 06:20:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07F676B0600
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:20:58 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 960AEA9073
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:20:57 +0000 (UTC)
X-FDA: 85477028154.08.8BCA63B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id DF14812000B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:20:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gOIJf884;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692056;
	b=AOYeQjL0aemdNwuzk6fEk4FWi/llIvoFnm61TU1SeOBvDuDst2BEK8RFAz8sfo03f4XvpA
	mNlMjLNl2ykRWC6WaGXBmjblI6uUd2MkJlvWARLtztcoM39XLdvDu4V7BHlRN2wuiIdLzY
	VCQVxXBZ5d9NGiecg89SiA/DgaTfqhI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MMesdoqS6IgWWnyy/lMZV01AhuTBPRWjqbmXz3+vHNk=;
	b=8qKSt1yC1SU/qYuwcE6XZESlwSiZls1xJ38HM+Mq2cuMqfeypfy6hA3AOUG6rxtLwbhtTi
	PQoHVQQhqkK313uKzdczXfCnD/Y8teEUdozbrNsWu/cSzortFP5AxPrniQe94/5J4dva3i
	7YUEvU3hkEsWc8OD9VSP3hibPMGqiDU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gOIJf884;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45FFE4374A;
	Thu, 26 Nov 2026 11:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3423A1F000D1;
	Thu, 26 Nov 2026 11:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692054;
	bh=MMesdoqS6IgWWnyy/lMZV01AhuTBPRWjqbmXz3+vHNk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gOIJf884KufaBaPzwIhw/JQosylTm2ObEX+n+dIBRN8n85W6YpVjq7ssAotO+XCJb
	 yTL4B6gPdRjtDz/3xSHiK4N+B00/PqKVy9Hbs/TF+niNS12CriahUizn4VQ3BD5VOn
	 J+iM14A0TRzeQTvx7rtgl+cn2ckJiTBVgqj/qwdF8EcqYQeaDsqOUX7rJElVd2Yi6P
	 XJO9F4VkscYC7PgN2GgWM1Wn7Nv9FQtkWqo+6V521w3Cq3S43n28pusd6yjsD3qGNb
	 o3gldwMIRC0NRUz2anmwEwh+hOlXpqGWtL2SOFGmc4CrKefHoz4Ifigh1EQqRG+fnW
	 xnlqBATFEXtXQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:53 +0200
Subject: [PATCH RFC v2 40/54] riscv: replace set_memory_rw_nx() with
 set_memory_nx() and set_memory_rw()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-40-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DF14812000B
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: c7oh7bwoeox4qxyu4x6ej96ou6it1fkb
X-HE-Tag: 1795692055-927456
X-HE-Meta: U2FsdGVkX1/+tJqNKhrUCS0n1yAJFOKZB+8vVIgMsxCtaszlaMBJZQ1q9M8L0SwkWf+mjxOaf0c5bj+Vm8guOgMxIT5Z+Vcjc5dw4/wDyRKNBDVvCG5MYGVjvwE4Ug0fRiUQ3YTdZ2BwVzvpyTRrT5RqKmWW0PNpCw/TbapjrNgNqfo9tDjr9XsRgZUSlu8bxzaUmbQNqLu4ibPAdP33oavs4z9UQ2PkDmvEMu6z2ztw/3KGNOIh3LExpK5za3kKzjzrLmjKAZ/0ogtAbMKlHv6rs3mFQ1GZBr6sBahJ5YEH0HGwcw4XOVvDyrzZKd6kBpI0bUK2A8RYcYY09N9EdAv6t48hKWiQwzHGVLp9oBnTnS4ZWReenQPu9dTxmILHgbsJJ9GPMKfQTUgqb6i4CU6fJtjHiyXprkbiVtpL4QWWh3z3NRMrxKvRIbawU4vSJn4lEggifa5XLUnb1Feh6SDXdrsFpLw1/4a9G+DCog+pmLvehczPvwbjCvSmvROAL+ntYUF1UPPwD0vNyXJ8K5xsmVJwYl0JiwtKJkFS1sCF4gZv5bo4D2AcIANxfIhJiyIl7qnXUaGL/lFNdbTunWuMD4Z+UZpLRRWB+DfX+8dCbSIyWLgHp0p8ZHdxQHL7KRQ/W0BMNv+R/i9SNcdrQREDyvkCbHDaxSMOZimZXzdw1CkyK+oVN/pPE6Gt9xwQ69AwP8THYvbztRt6hR1qrXKv+Wvuqb0ur57n9VfY76nLkaARLxN8pu3PdHnPLNJYUPBlLSmYkvl2NSSOozfm+VbFq/WeLeVfK1EIhv1l6xXNKM5qHu2JLCC+nOE3VrqUEKXCRXDM0X7NSvsmczSL3AIrcgncyfK8AwFPcocwhMbboeb60Oel2m7WuS7bRtWwvC1yp/4PejAAjMJOn0dziwoDWFM9E4gd4Q1/QlaBG7FNokn6nt7/o1J4l5Cti7HpkHFOXsytvmSHsOrdHB0
 AD0j2Vb0
 WROd9RAnE540XsQEo/oFVwUzOtumQ81orcRZ/fAYyqsWXmi+VEF8EZUTXxp+Y1rJTTpu+omAl/hJxJ3JGfNK7Q/jSsCT095QF1L33BrYv0rTp9AhCxC76MEQlu5vL+rhK1gXwIPQqlIsSQlxOXfZCYrusv2tZ6K93vMJ/FMg1K1vsc0MZ6CAbfErL1064Z4YuH+niIqQofoFWYSAs7NfYPsv5QUIxm6wPgu9zEGnEvJ2HPOglFEvRC35MO1ThAkOH0xzwtlCTlXpK48eAsfFJnbLEUDr70gUFpX+7DZ3qo9KuuK6DEjSxPd/TqsAegnC/jc8efuYL8d3xynnb41crBlH8gJYoHHZjNOsyLbYTuD/RYbwbbzDUdccqUSpOu/MiJD7WAz7QyL8b8gLPRTZ2hl2JBLtG1e1OlV9wgFHbwOtadGCrfqyBfctf7WaQTmJgswZLgp6wCBNfoo42+AaFOJU+KBSpS+tBAqw7PREXGfb3PqI7tpncPbUVCy2sGOzPQzffV90kXXNZX40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

free_initmem() is the only user of set_memory_rw_nx(). Keeping it would
require the generic set_memory() to provide an operation for riscv alone.

Make free_initmem() clear the executable bit with set_memory_nx() and then
make the range writable with set_memory_rw(), like x86 does in
free_init_pages(). In this order the init text never becomes writable and
executable.

Remove set_memory_rw_nx().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/riscv/include/asm/set_memory.h | 2 --
 arch/riscv/kernel/setup.c           | 6 +++++-
 arch/riscv/mm/pageattr.c            | 6 ------
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/include/asm/set_memory.h b/arch/riscv/include/asm/set_memory.h
index e9f9960c1947..b9a8c7033c7a 100644
--- a/arch/riscv/include/asm/set_memory.h
+++ b/arch/riscv/include/asm/set_memory.h
@@ -15,7 +15,6 @@ int set_memory_ro(unsigned long addr, int numpages);
 int set_memory_rw(unsigned long addr, int numpages);
 int set_memory_x(unsigned long addr, int numpages);
 int set_memory_nx(unsigned long addr, int numpages);
-int set_memory_rw_nx(unsigned long addr, int numpages);
 static __always_inline int set_kernel_memory(char *startp, char *endp,
 					     int (*set_memory)(unsigned long start,
 							       int num_pages))
@@ -31,7 +30,6 @@ static inline int set_memory_ro(unsigned long addr, int numpages) { return 0; }
 static inline int set_memory_rw(unsigned long addr, int numpages) { return 0; }
 static inline int set_memory_x(unsigned long addr, int numpages) { return 0; }
 static inline int set_memory_nx(unsigned long addr, int numpages) { return 0; }
-static inline int set_memory_rw_nx(unsigned long addr, int numpages) { return 0; }
 static inline int set_kernel_memory(char *startp, char *endp,
 				    int (*set_memory)(unsigned long start,
 						      int num_pages))
diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index d79f99b86033..948f0e27aebd 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -378,7 +378,11 @@ bool arch_cpu_is_hotpluggable(int cpu)
 void free_initmem(void)
 {
 	if (IS_ENABLED(CONFIG_STRICT_KERNEL_RWX)) {
-		set_kernel_memory(lm_alias(__init_begin), lm_alias(__init_end), set_memory_rw_nx);
+		/* Clear X before setting W, so that the range is never W+X */
+		set_kernel_memory(lm_alias(__init_begin), lm_alias(__init_end),
+				  set_memory_nx);
+		set_kernel_memory(lm_alias(__init_begin), lm_alias(__init_end),
+				  set_memory_rw);
 		if (IS_ENABLED(CONFIG_64BIT))
 			set_kernel_memory(__init_begin, __init_end, set_memory_nx);
 	}
diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
index 5a1a3b4473c9..433ac98234ed 100644
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -351,12 +351,6 @@ static int __set_memory(unsigned long addr, int numpages, pgprot_t set_mask,
 	return ret;
 }
 
-int set_memory_rw_nx(unsigned long addr, int numpages)
-{
-	return __set_memory(addr, numpages, __pgprot(_PAGE_READ | _PAGE_WRITE),
-			    __pgprot(_PAGE_EXEC));
-}
-
 int set_memory_ro(unsigned long addr, int numpages)
 {
 	return __set_memory(addr, numpages, __pgprot(_PAGE_READ),

-- 
2.53.0


