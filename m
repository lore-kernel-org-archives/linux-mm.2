Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3719C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6742D6B00AB; Tue, 28 Jul 2026 20:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64B8A6B00AC; Tue, 28 Jul 2026 20:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ECB36B00AD; Tue, 28 Jul 2026 20:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 241186B00AB
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B324D1A0462
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:16 +0000 (UTC)
X-FDA: 85039945032.15.A75C401
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B7C21160003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uLKM2SaM;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285314;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aFtPFsB4ZapTTaXU1usUvlaLrI0G0jqwvDMsN62tdwc=;
	b=SKqOWnoEAkV7kWv0Oib8rRNLvbGPUJpHqRy3ZM0MUoc1n87QxxdOR2KXslCAqJ/+4mtpoa
	wLY+ira2qc3Fxt3LlsLkp7rqeGKPo0gJHDSeS/1ALxuzST8IMwJdOmezozmTbC2D39w9Kg
	FanEHUHGVLyCNPvLsaj0d4HudtLro/g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285314;
	b=AIFONxvhsz7HGdOZlJ9AdoXX6Mxwdf8pQqB5dMoAP99pnsTOEqE4jyBBCJTUzoiN6ddDzm
	Vb4NOhdqbVXp1MjD8PwgDObPaqVhOfROjnj8S9bAX4eYUjX1IkKN4UjcbyuxaV5DqHgsXT
	iLt03DdYEGr+S2Hm/5JbqAKHqHY+lNQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uLKM2SaM;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AB08451DD;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC195C4AF61;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285309;
	bh=8P2+/T9m6/t7l+sEVyKZYHunwUno4+zhgzh3aLZIyqs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=uLKM2SaM4YHqF7GDIZnsMF5pflobvR0FKZyyDy06tLX/TSP3Ir/RAvWE5utou3yd3
	 JNjIYUjdPJoh28psi//w39BHjSz9z1QhZWKJ5A64mPC591AFVFxgw+iVecKbki9iSV
	 zVbUmUjWTbiD1vLi4p+Xo0yjNL5PDYcdZtKSjbZaTSZ9E5pp6gwTVv6wsgijC0q2ca
	 WTF3wCiBku5/H3TcoVyjL0QpY3LeshoEZVvnh2XeL2i75eLYaslXhEj/2PmlrhvqZ7
	 T82Rhif2b39dnxUYCbkhrSttS6gIM8PTiAeCMvlxtMOXpm1rcKJCHoAY0jaEekh3dW
	 PWcmrsz39hTCA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B34C54F5B;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:13 -0700
Subject: [PATCH v9 14/41] mm: swap: Introduce lru_add_drain_progressive()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-14-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=2983;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=z1k7bYULkqVrzF37fMOsSzxA45ibiL0mHnNKZDzJmd4=;
 b=TM3b/13YyGrFO85K9kaTUS8mgpgnU4Y/aXT5M33Ug87O/Lo9F++1+AEIN2PUps1BAHuyg7UuP
 9q+hhwykKs8C0S2KklFGsxHRwALYYGPR3CNE+OCsczlAkk2peNgz2fe
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B7C21160003
X-Stat-Signature: 39ihxs4dt17cqyuqae99hqtyruwuoee8
X-Rspam-User: 
X-HE-Tag: 1785285314-157543
X-HE-Meta: U2FsdGVkX19IeXmAMVfiTbHCJ6SHDDKUwxqr+5/eqk8sxZdb4SC7UhlUeivszpIz2MENm/Dq0I2cYYOUI8Mb/0mXd2nJESWxjuNBNXsF0DuYVMRGTO37n3RiFsBisbixD+gZXfPKGZJN3aiX9DRudUiMVAecgFufoPlmMdFHz0IubShbtEy/s01GshbWamQxopKCjyMz6M+6qltTYnGXs3V4fgDpk3fH1CzaQkW+nT2XknvesfCPj/Cm71SDrixKnSwL0LPKX3vcKsI8MRrs0MbP7jY2ICytbv+4ySaRLLgyP/eA+4C+ja/wyIKlEJoIbMTuEPtFMMSeRidcK2WmN+hUKpp/QsfHH7pPo6U3fx9E7TmpxbRT1l07elT+P0a9IHBsVZgpIpLy5RXgwksr2eH6MAZhsqmPCBLf/GXkmJP0uQQ0HfGEtz4unwgvCEzC2OOO1FKwLRXTQXfa8yFKu6yfn1gdS8bltTlEgMidK5xJefQ+tPSnPMWvRsfJPf9S0CXG0SzrG+DrZgOndvs6F6Ro2xg79+AFsvGjjfpkXktKjNxhM2iYKVE9hPwf//tGisCxdKQEp2IL6iB84sCrPQnOHYf+dtZJO1NDCY9tOq1NJzt0RzHjBkOwL33e9FmwitIHiYg/7Udr++Xfe3uIpu4D1oiURC8K+ZBlz3ZBZNWbfVr+d8EPxZ/Ht9uQvIh+J7N9Fna0KsyMcFaZalt0LGbF8Mqg2E6qLjJx4qnzu0XfPV6fcchXkrntZWZu8z9fOLrZumzJaTXAecAVvfC7rCNu9rW8GlYnBjnwHKWsOuguOF3OjB8PSLAUk/BtJAiaq0JvfiMXYoBACrmoPTCq9OcfbuJjPBpmNikqYg04qvvsUxSQyOI+S8ZQaolwaykD5WDd2qfGRkDngakH4HWG7llqtQOX2Ca/w47bYZZJOSY6cRXYq03buZjHV2mpS5x/2OabRs/uu1VKWCQ+7K5
 dOqqxO0k
 60N4hCYMTVfL20I9UOtVoWJ9rNpx0lE4lynwYT3YHWvKnRYRmPG1YlwXjirs+g53s/BBhbAt6MW9opcFpLEcEHD6fYiKwqE2RWxD5/pOBqqMPUNC4L5bpsjC4ouKU5hrcGqxigbszmybX5QdyXz+tmm6Qe2sMX2GmCrHLxVzT2IqN4uAJZ432hL5plr0UL9c1/Ty4cl4ZTt2Fi5ZdU3/Shzm1ANDcyL+6+Pq+Ofx/nxXLG4aF4FN7O2pC31HgJpV9A6fHSVDh+FuRmcEqfgw01yU1Fi8iayADvrkb2fSh03thhAyrK+NLyHq+tvGjgmNQYXuDtzJlux6ZT5eufuiOmJCYCo4SGXw++lljsk2evrrP82JvrCRpCRmbc6JBqO7qONB4OoMVns/BFeQdmMA2NlE7IOJlkxPrtNzy0gQPEiX/RVLq2UMGaYVrTuKkgNXT27gI9W4RRKIi89pIi+lJtJ/OBolE2tem3ggoNJy9Ok0seKlCeTysblb+SjcGEcKhe6588CxI6tRTxs45yOSihG2y7xqPZ4FGyxPl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Extract the progressive LRU drain retry logic from
collect_longterm_unpinnable_folios() into a reusable helper,
lru_add_drain_progressive().

When attempting to isolate folios that may still reside in per-CPU folio
batches, draining is escalated progressively:

1. State 0: Call lru_add_drain() to flush local CPU batches.
2. State 1: Call lru_add_drain_all() to flush all CPU batches.
3. State >= 2: Return false to stop retrying.

Refactor collect_longterm_unpinnable_folios() to use this new helper.

The helper will be used by KVM's guest_memfd in a later patch.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/swap.h |  2 ++
 mm/gup.c             | 19 ++++++-------------
 mm/swap.c            | 15 +++++++++++++++
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8f0f68e245baa..cd54f73f34f39 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -344,6 +344,8 @@ extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
 extern void lru_add_drain_cpu_zone(struct zone *zone);
 extern void lru_add_drain_all(void);
+bool lru_add_drain_progressive(int *drain_state);
+
 void folio_deactivate(struct folio *folio);
 void folio_mark_lazyfree(struct folio *folio);
 extern void swap_setup(void);
diff --git a/mm/gup.c b/mm/gup.c
index 0692119b79043..5f00435e2c635 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2268,7 +2268,7 @@ static unsigned long collect_longterm_unpinnable_folios(
 {
 	unsigned long collected = 0;
 	struct folio *folio;
-	int drained = 0;
+	int drain_state = 0;
 	long i = 0;
 
 	for (folio = pofs_get_folio(pofs, i); folio;
@@ -2287,18 +2287,11 @@ static unsigned long collect_longterm_unpinnable_folios(
 			continue;
 		}
 
-		if (drained == 0 && folio_may_be_lru_cached(folio) &&
-				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
-			lru_add_drain();
-			drained = 1;
-		}
-		if (drained == 1 && folio_may_be_lru_cached(folio) &&
-				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
-			lru_add_drain_all();
-			drained = 2;
-		}
+		while (folio_may_be_lru_cached(folio) &&
+		       folio_ref_count(folio) !=
+		       folio_expected_ref_count(folio) + 1 &&
+		       lru_add_drain_progressive(&drain_state))
+			;
 
 		if (!folio_isolate_lru(folio))
 			continue;
diff --git a/mm/swap.c b/mm/swap.c
index 588f50d8f1a8c..0f9465d31fe52 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -950,6 +950,21 @@ void lru_add_drain_all(void)
 }
 #endif /* CONFIG_SMP */
 
+bool lru_add_drain_progressive(int *drain_state)
+{
+	if (*drain_state == 0) {
+		lru_add_drain();
+		*drain_state = 1;
+		return true;
+	}
+	if (*drain_state == 1) {
+		lru_add_drain_all();
+		*drain_state = 2;
+		return true;
+	}
+	return false;
+}
+
 atomic_t lru_disable_count = ATOMIC_INIT(0);
 
 /*

-- 
2.55.0.508.g3f0d502094-goog



