Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D071E606A334
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ys07SmHJ
Received: by kanga.kvack.org (Postfix)
	id CFD356B05BB; Thu,  5 Nov 2026 13:40:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4946B05BC; Thu,  5 Nov 2026 13:40:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12566B05BD; Thu,  5 Nov 2026 13:40:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DD466B05BB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:40:33 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21F6640C43
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:40:33 +0000 (UTC)
X-FDA: 85401931146.04.9F858E2
Received: from mta0.migadu.com (out-83.mta0.migadu.com [91.218.175.83])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4946FC0004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:40:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ys07SmHJ;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.83 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oFQCr7m3VJS53WKkGLDYfsPN+SWWbvo+wFSmzZ6dt3A=;
	b=smRUj67P/uXTKmdzyXXrEhKGOpt306/MnU4BXjYWmISdp4kRseePInHAHyTtR8TdPYY/rO
	C33dTIookzqFXg+JzhL060SmOOC1Sci3FWfzwC/WZK9m1uv2mXPDOb3Q8E5SnK7En1e8t2
	p8oKgDAMJi91dEWa6lDfKt5ij/MsSoE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ys07SmHJ;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.83 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904031;
	b=N5iZg+n+J6eNhwlSaRhgBZllrtdExQGqCAN6010s1VkjmydnUO49WVsa28TJwlo3IIObzQ
	WRwi9meBRWTKivNPsmvN5Uc7M5CTFnLXFj5Tl9QyBMQJAe901FE0YIHv7lGEgtXfuiGtxF
	EI+MT5WYFNf8qBHCcGxRLPI4iNPZmSA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=pLzdrNFS5rkH0iH7ngCOM+5sJEDVQrr95NdzUO/r4P8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904030; v=1; x=1794508830;
 b=Ys07SmHJ2H/cIoQA+Q0tN7SuPuvVLR+FtppzrUHVPEl8PTOi0RosDXZ/Bzsomf9DT900ihDI
 heprMEyH1mQBtsgkRxuMgyt0lf9tInGLxfVuO2cJcWmK6Zdf7LaJ6084VoQGmNz5kPXg7ffuouN
 fTxdXB4UKAFImREglHl+A9Xo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id ac5bc4f198cc9f78;
	Thu, 05 Nov 2026 18:40:19 +0000
X-Mizu-Trace-ID: ac5bc4f198cc9f78
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-riscv@lists.infradead.org
Subject: [PATCH v9 05/32] riscv: mm: add PMD swap-exclusive helpers
Date: Thu,  5 Nov 2026 10:38:49 -0800
Message-ID: <20261105183940.2236717-6-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8rfsizkzwb7gbsbwartf7o8pu1ymhken
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4946FC0004
X-HE-Tag: 1793904031-426944
X-HE-Meta: U2FsdGVkX1/FOuI0NN+SNUWoOsiiwP7sZv2zRJxHhyz8RiRLoQ3nRCA++/gL+rUT0tWzfy1G9ZdbYc5muisX78i4oTBpDEMtOKfS0ekWchXS0345qtLYPnvQ133l8+2uANEeXZ0+U4p7Dem4WRhWKGpTCLgdpOyzrWk/vIaOG2goUniRWSX1crBZ6Gx1krGrviEKXH30lyCNwsk2e2P2dj+MewVuQCzxWJTJXHX7y5BVUUuhdwpzcP4dGRXnlU982/66Gu+t3WGzZ0eYb5rqiTfS3TUT3/AUrGfw4vOShQbAyp8/4yvXEih/vFZCPVsCwZeNOy98z4HJVKnaBsdL1dH4f+5u/3v940gGhOoT3Ml9YzBQyjrlKyzmX8+gHgedJQ0X25kM4BvEK1/jYGmXv3FcMfwd7dIWow97ZireXgL2bIdv/vk2xIHoI6QoTpludNlzTa2X2PYeKtsG2+ZSGBGBpKRIhOsGQ1yXYhL9VUDNcnkCvARrQyX0Ob6pPf7aIGKPxVlYurNNVEF10yeSNDN/dpXbwyqSclaCntyxGQOpvbLDo6Y7EPExQDU9yigNLbXKcu94h1WvNGe8anRF05IEoKV3zCO3I+uVsnVyP9is8Emm7wrBUW1Uutr1TKSPFYl6vpIxuwZvVLRW0iYEbNvSQ4+c5gBws8EyE5kl2tzzj+KJJfLme/oPB+lRIiwqF7hlSXNLkwRGOYqMtpKWiq+ic95MQDeKGNoU7z3JaYCRLCyXuVW71MjBzVzDPlfWaDi6a5tHnZVc7AkBi67V8oXen6mdaJ5ZMMhorsz+upQikm2vWIJJNNOTwoZr1W68zit5heQJpVepSqc3snw6cS1GLnu8ZTfrHQtfVi3hJmVgbYAq5SDfi1Eeaf2NQl0ywlljntnmMdX003atCz6nsdppUSiofu7XnD+eF8fO4h9/5bzMl6e1WauqPnz9gpKz6JUrQSq76RvXw/xuHGX
 EEVkB/ig
 eD3MungfBiHBEzVBqBr+01agXNZYMOKeqIk7FA/wNjdNmFs/7Fbn0v5/35G+iJluZiSkMab25PHIKK5o9Rtj6gPMurPgUFaksgj1MzbJ0IV2e/PQyVY8IpkTHK0n6e2JH7lEuc2LFXWIB0t3hV/0TyySw3tOCbahY+CRDGEFZRLkm+iBUh+zD4AKinlJIjad4LJrYsJ9mnCBwoh8ts/JZvW63+fUgJZ2YH/N8D5kz01LG5yqFiC7U9PrKCDGTwnt0/1lQSNhj2RverP5dXoyz6bgY6XAaAN8b/GBounsoCbXWvJtlIxfRytEC3emPeU22n0Rdx9X/YfuYpChWFkdWO/zBkHztja63XwQtC+F2usQIkmBTRUhanjjZ/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Prepare for keeping a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, which makes PG_anon_exclusive have to survive in a swap
PMD and not just in a swap PTE.

riscv encodes a swap PMD exactly like a swap PTE, so the new helpers wrap
the PTE ones and reuse _PAGE_SWP_EXCLUSIVE.

Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-riscv@lists.infradead.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 2ebd5fa5adc58..fda94dba9bb3e 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1219,6 +1219,21 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 }
 
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pte_swp_exclusive(pmd_pte(pmd));
+}
+
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)));
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)));
+}
+
 #define __pmd_to_swp_entry(pmd) ((swp_entry_t) { pmd_val(pmd) })
 #define __swp_entry_to_pmd(swp) __pmd((swp).val)
 #endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
-- 
2.53.0-Meta


