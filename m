Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC1F606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 01:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CI+VxDJ3
Received: by kanga.kvack.org (Postfix)
	id D46606B05B2; Tue,  3 Nov 2026 20:39:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEF016B05B3; Tue,  3 Nov 2026 20:39:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7EA6B05B4; Tue,  3 Nov 2026 20:39:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96E646B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:39:53 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 34B341405E3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:39:53 +0000 (UTC)
X-FDA: 85395730266.26.4943B39
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 89FB24000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:39:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CI+VxDJ3;
	spf=pass (imf27.hostedemail.com: domain of bobby.prani@gmail.com designates 209.85.222.45 as permitted sender) smtp.mailfrom=bobby.prani@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793756391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kSc7WJfr/T2uxVIbPPCpTk8TyN99fu6QCnpTLbLAcUA=;
	b=zOjC2kP0E3EyWUPoolkVF7FznvGnUiQD6r56uLMfsMmFTUPMDhmdZ0hrTqCGXdKv1j705L
	IaeNa/TJkQdmZjkIy9Z1clWOjtjVU8ortFfbVceRX4gYKcsHhZXT6E4WyP28F/SSf0Ivc1
	sinW3qi4c+WdvL4GvkJnD5m7UAvbGW8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793756391;
	b=3F7hw6YxGYq5/owefBPgDYOKk3J+2Xrvoo5Ozl36R7WFwSV7fH9IyMre/v9iHmFd8xCwnq
	bRz9MG6VSsao96wY88BxcB6bUWfUhAItX/PC8OIerlfZqL2BxlXhLl3gDVF2P+12GSdc3q
	5nrfBMrtFpcyJVmL+z+n/KxUmE5vrP4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CI+VxDJ3;
	spf=pass (imf27.hostedemail.com: domain of bobby.prani@gmail.com designates 209.85.222.45 as permitted sender) smtp.mailfrom=bobby.prani@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-98c78660542so125733241.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 17:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793756391; x=1794361191; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kSc7WJfr/T2uxVIbPPCpTk8TyN99fu6QCnpTLbLAcUA=;
        b=CI+VxDJ3tiAMTqKCvxq2ckg+SAlGwPXXO5U5zoFtE8t8rSq8E08xWJ/aey/VqzXddg
         Ujj1PeGJMDNspkL8ZwnR8mKvTC4r4fnX/sm0433tFIbEWMtZ11d0WiqgXlqLiHBo7wZY
         bsnvCGBFMU70QPjluQDjzotl8tY57/OWDTswKrXblW0rOsgbVULGjOEjbklceU1HfxrW
         IScrQibggT+534E7Mw1GO2zIr3KEQMkjaB2f2/ybaanFao8c3PvKUnBi9lfiyoi5Ol4s
         a9u4u6bzRWuXeX0BgHwK8K3vZ9/6aTy9Gs0TH3aGXNFScbq8WXvLZh7EK7LpuzQ7k2Ye
         rJNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793756391; x=1794361191;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kSc7WJfr/T2uxVIbPPCpTk8TyN99fu6QCnpTLbLAcUA=;
        b=F18GjijzrwkJgDJEVawEJZTPpSfpUJnQsI39KQtjJd+JTD/GKibCw8GrpjSaB14pHG
         /42y80C0aMdaJXn04l91463N721HIymVTC6E+bcY9bFBmMHkl2NEcnpC2IzIIVUvijAN
         Td9mMtqs3NdbHmHvJcepuN9qmeAiGrUDaQaSCdCyHYttZO6GyZK/LcLU7YxfmWjratRP
         wzRvJi7Zb7mr4XduKSD+B1SkbB41QWPkdMJH/HHLi/bnyobMQRIBT+788jN+o7ci2yaY
         AxjOw5xCxEXMU3QA+Gak91cFnb/VQ5jcfJqU7GWoBWy09Nncqg7sgDZAifQoCeFneVUW
         5g6Q==
X-Gm-Message-State: APuU4Z9Rx5xGnd6ynjeTzyDZqfk8w3RChwirKe9HH6yTxw8l/jl+89Bp
	jkZ1Jl+xkz+iB/G8OiR+naJR0PefNLxARoS+mKOjnB2iAA8f/9zHzevUfcvk8WrSeKg=
X-Gm-Gg: AYBFou1hYyLAZiYtmfTkB2E9sI8Bd780JsABo/wmvxcsLWl4u6fMx2srRf6AKbXDf5F
	i/c96PJivxYaJv0bbBM2vSFgN2SY7B0lNXdA0HPFElt2BoNIZcO+JA7d0a21dmDY/Otted8/nZB
	uDTFq6qRnCuP75LIICpnZn1b/qp6IE12o9mFaWaoc3vDb1Mmo3Y3udPoIyjk0b8CPV11VodxSat
	/4kZGja4Y7dxckiAP98fMbs9/qWgBUsCCmvgcDHbFdxg4ZIfoV1qFN/rtCio67VBh1b3GqbQ6X8
	0tM+0QOLMubwn7OuI5ZQEXnhUi0EHJTxB+R8LHw3dRzpS1WGFCa1Qb/TRirrnpRy5ut3MN1S1yv
	bZndZGMq2fTxhkDxvfshPGO5fYeNj/j9a7Il07JJFNpc1aM/6vE6gaz0OAekVW2mscLTE+CbTNZ
	Z9w4vFr2fDHO48lgeKssmBLYmtj2Fof7pyZf+oTidFQSirplBBMQ6sWrCr2QwZ69ixOwJehard9
	Y4XErfHQ9ilOTdrX/MAI6Ak6rIeywz2z1glNRPoEuZ8nXsL1w1Uv5NZM4Pm81A+JOzH+32ZKEOU
	jeqezMeZJkefPCs7Ps9zMhQRb74owKXCddylt06aFS0vqNXnwf09k3pXjPgrAVcKVw==
X-Received: by 2002:a05:7301:db8a:b0:36a:279:c93f with SMTP id 5a478bee46e88-36a423fda77mr21589967eec.33.1793755902092;
        Tue, 03 Nov 2026 17:31:42 -0800 (PST)
Received: from pranith.org (c-67-164-4-239.hsd1.ca.comcast.net. [67.164.4.239])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca394c2a3sm2149230eec.20.2026.11.03.17.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:31:41 -0800 (PST)
From: Pranith Kumar <bobby.prani@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Richard Cochran <richardcochran@gmail.com>,
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - CORE),
	linux-kernel@vger.kernel.org (open list),
	netdev@vger.kernel.org (open list:PTP HARDWARE CLOCK SUPPORT:Keyword:(?:\b|_)ptp(?:\b|_))
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [RFC PATCH] mm/rmap: use release ordering for small-folio mapcount removal
Date: Tue,  3 Nov 2026 17:31:38 -0800
Message-ID: <20261104013139.1341582-1-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: yuo4uiyd4oiqrmxbxbsswd835gru7w5t
X-Rspamd-Queue-Id: 89FB24000A
X-Rspam-User: 
X-HE-Tag: 1793756391-532612
X-HE-Meta: U2FsdGVkX1+L3Gc37hND8ZoebteyV74DQhzkpIGIj7l0ukzGdfLCwLOZ+pobbt+2qDFWC636M1lK/XMESiJC70rxeb1sn3LlW53pqdzEH+GlBvOUzxGZ0HApB8Tk3qTC+egopiyzRjFaS8sSbMNFZWMTtyV0Zsead+YI0yFLYn+amqfj3Iww3XR16TOsl5ACCA5c3jFR95LunmUYYn1Wn2OpyN1zWswEU5zD/aJzr5FMDmMoXBYSp5QzDwv6j9LX0NWTC0AV++ev+SQYnb0B8fKVKPp6xS56ijFxxZcpjmLFx3r0rIX0iPN9oYURpYTFlNvV4bwthxxzAbnjixmZ1MFR69BlZ4lXhSg54XR8qCkfhGQmK93JOLI75D4uqk4OwQ4zwlYGHlEwyMTf/CNuoKB+6mmAYniWSDOalvHmVCtnBiEqTGsSGABXJYVnCy1ZtAZnkjEHfuHUgcrz5ncLuev40imz0MoFGPORKeEOi2QnrG2Dtk+dEdUH0gGaJ7KclkBZzpZp/ExfefCus9SM15qj3axaMCTYw04irIWpV+oiR+1tP9NJvLVlU/BeIi6kTwWlde1H0Mnw0KlZ7iRpboJHyVuWKfo+kMi6LcqXQOJ55yKHiKDH204ZCOtxN/DbB5UOmex9AGljyP8xPdTyvEjsTfBqGrImaMcgmrCW3o779s5XY7d1eI170cuyNivX00z3R9a8RM20FLXjgZhcqzHtSVE96/gOmXZqQY+11kdDiYrLp5H1/JhDXfQxLJ38G3YkB6VZYIHM3ddoQ+J4C/A1B+G+hhSDGHJ+zLjRMF1Gfd4XPU8/AlY4BfA7ny5hxBEtFaUWw20k5IfqT91Ftly066iOaJNTrEMc8Er/laMZgWAaatp33OYXDSmJF0itWfZf+eAFuBE23KQf8Tx/B/zq8ax7/yc7oDiuJRmXhNBmzVPcFW65/lJOmakqNUmF45Nuof78m8VSXrUjqqd
 N/XGU4lj
 PGY0fi2PBWrUuDIdJb/bJBbzOiKw1YTnzBkvTHWsReQRa+c0p1JPqPjp+6/Bj+Bxlx62FKLUtGAhYp87HlkXXWwp/HaEC92C/s1qrcXWHKqcYG7kxD4rXcd8oFZEZqW61RYYsMg4d1dqU2WHD+Trq22ggriqqir81EcGLgS30z7b8KLyxBbDeHt7qDXFD0c6lrcOSrS5krR60wmgW222HnvjHRC2ZUVMlHm5+27zrFqFYvW5P8wnUTZv/rIYV97/3E2xzq3TcvNzIjRgIGpvmDuSRElFVLzJ9OKIIgWkCr0C0I0peJ55DuEAroHEpkV89hK457gxwmbKJI8XewqCG9IgtuDA8lgoKok37U5UY9TK7UMYY5hQXnETkIHMw3e7xdtFmQ5Z2YvZmRaUA6hZeuCa+FVbiR2s6ZQlyK07R0EIjSFp1JZtJY/Ovs14UY1hw3mG1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Removing a PTE mapping must precede lowering its folio's mapcount.
The COW path relies on this order to keep the old page from being
reused while a stale translation can still access it. The mapcount
update needs release ordering for that edge, rather than the full
ordering of atomic_add_negative().

Use atomic_add_negative_release() for non-large folios removed at PTE
level. Leave large-folio operations fully ordered; their path can
queue a partially mapped folio for deferred splitting. Update the
COW ordering comment to describe the required guarantee.

In an arm64 page map/unmap microbenchmark with 20,480 minor
faults, simulated cycles fell by 1.54%.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 mm/memory.c | 4 ++--
 mm/rmap.c   | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index b65b56fe9714..9e23c64bc743 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4158,9 +4158,9 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 			 * threads.
 			 *
 			 * The critical issue is to order this
-			 * folio_remove_rmap_pte() with the ptp_clear_flush
+			 * folio_remove_rmap_pte() with the ptep_clear_flush
 			 * above. Those stores are ordered by (if nothing else,)
-			 * the barrier present in the atomic_add_negative
+			 * the release ordering of the mapcount decrement
 			 * in folio_remove_rmap_pte();
 			 *
 			 * Then the TLB flush in ptep_clear_flush ensures that
diff --git a/mm/rmap.c b/mm/rmap.c
index 1131b76bbbc2..62e623d7563b 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1794,7 +1794,8 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 	switch (level) {
 	case PGTABLE_LEVEL_PTE:
 		if (!folio_test_large(folio)) {
-			nr = atomic_add_negative(-1, &folio->_mapcount);
+			/* Publish the PTE removal before lowering mapcount. */
+			nr = atomic_add_negative_release(-1, &folio->_mapcount);
 			break;
 		}
 
-- 
2.47.3


