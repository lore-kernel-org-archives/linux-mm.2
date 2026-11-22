Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A563606A33A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=EuHyVgS0
Received: by kanga.kvack.org (Postfix)
	id 0EB886B05B4; Sun, 22 Nov 2026 13:45:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096456B05B5; Sun, 22 Nov 2026 13:45:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78806B05B6; Sun, 22 Nov 2026 13:45:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6D9D6B05B4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:00 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2204A1A070A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:00 +0000 (UTC)
X-FDA: 85463631960.08.9764F1B
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5F66E1C0006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:44:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=EuHyVgS0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3KDgDawoKCAUoymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3KDgDawoKCAUoymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373098;
	b=6CAIBFMF4iFvSMFBm8CG10dXECQYGjT061YzKX/M9MQm1QBXPAFOldFh47HdCCnyH/7C5Q
	u9jkdbChDmr256HohxxYsw8DKMNNMCWfrCKnPtV+13ksdlv/KQOogCUAQ9NJK4JL5j4EWi
	t6RF1RQthlnM2Mp/BcZTDflr0pF76zg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u826aq6QgFuLwy4ZUNvGuXRkf41ETeakzXxIgVKKh+Q=;
	b=omSTxncnmX8oo3/1GvCgSGQLszPv+mHP6kBkyChjidC/HdfMj72OvtzjAmQQBSo7rRT23H
	7julUMnRo0IZnhj2e2zqG3w2F3AtZCQCJpV+DAgXchuiiqQf6AMSmX6vRCYJWJGif9vsAl
	jWNil9ALcUvxBlZSOV09GywvUWAU1wM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=EuHyVgS0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3KDgDawoKCAUoymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3KDgDawoKCAUoymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b42c3dba96so2996132a91.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373097; x=1795977897; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u826aq6QgFuLwy4ZUNvGuXRkf41ETeakzXxIgVKKh+Q=;
        b=EuHyVgS02+Z8VSjiIrco1XuV/aZNTQY/b0qhGs9lO55JlKmKUWMMJ8opFF4uaGmd/J
         If/DSxnSba9L+oKaLcBLuhrkgcNnhLehdXoGvRkGflcLV8783tNjY0WvX2Glnin1YS2T
         g+ETxH55t8qL3DxeYbXshTjjB57o8Bf7nKJZ5+c8/4DRoAcSNnC/LgmWoGt9ag4QZCVr
         9FbWbVCGMFtF6M5oX+GQhfSR0KOzm4H7Oyyb/1VWU3KgwDncKNgw3M8RUmEnlfiOAaw9
         R4/pZk6RSAy5h9Ra4qGtxTHlG+PjIVU7h0c+C8e3aVkD1rO+7iGXHVU/5BVXGLPC638W
         BHvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373097; x=1795977897;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u826aq6QgFuLwy4ZUNvGuXRkf41ETeakzXxIgVKKh+Q=;
        b=0w79294Us5SmLgIOlgH6xuPV/KW/ICAQ3xjPOutbVNPfvst+3yZkkfxv8nZGKMzVPN
         xOIc0lEtagxxHzyNfSuA1srH8+0SxpyvlS+lL8q/+Q6UrScWKeR2C1QkuVa7I+5pMLhi
         nMngxQA/+6qzgVfGP3kpoqWbASwvgGhaAh8k6kSXj0KNo6icM8UnB2bBqUwFw43dFR+b
         Zt6Z95Q9XXecExDwNwZkrp2hoKGgzQQD+XT7rOPLPNbpYNYdi2AotsbNIMI6FKHbtSFU
         a2y4YdPXx1hzcwKPWk+piGohwGtNld+LvU8UnjszeVdUXluCn7TXQ71eTs27A/jS8XKS
         yjog==
X-Forwarded-Encrypted: i=1; AL+hErFtVRS5sxttr5L6MRm4Yw5mz8hzwgHGX1YXHkbOXVBOelvke4CH2K7NQj7MWLLuGEtGcXh3L3LdHg==@kvack.org
X-Gm-Message-State: APuU4Z/J1nQc/ouQ4soClkpaHxCWW/EWXkw4GXvPa3bWZClpnFeEHFKx
	aBO/JoQjX9+OlNPY9dd7LRCBwCZz74hLzkdumcYqYkesfVygtR0o0VWEYdAl9lARdaTFIXHrB/n
	1EtYazHWqBqdlZTrXa7UZyA==
X-Received: from pjrn1.prod.google.com ([2002:a17:90a:b801:b0:3ac:3bb4:e960])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3f43:b0:3b4:1621:ba74 with SMTP id 98e67ed59e1d1-3b41c8fe3a5mr9462380a91.17.1795373096769;
 Sun, 22 Nov 2026 10:44:56 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:35 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-2-jthoughton@google.com>
Subject: [PATCH v3 01/19] arm64/pgtable: Clear AF with LDCLR on supported systems
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5F66E1C0006
X-Stat-Signature: 8acfi3r1kske7n75ak9585ba16qht9ik
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795373098-70500
X-HE-Meta: U2FsdGVkX1/+xW94zVsZ3q7d4AB7zKPEZuQpZnN2E7Paw2m+G5Sv+ZF5n2YbvcG4Q26jYqc4gZy+ZHI7Spx9J0HPPnn2zfB6cWFqBzYpV5g04zoHXXB+Rjxd16+Pi9JcSYg8BlnIZYY0j5cINjXu5oQDG8H2CGClYeua/53Lwz0JsnKzyuUB74TMG10/gCEk+LicUiQy1s8l12WGbhS0jPBwLh25v23rBVmqqd8N6gxvbPqaPNAjEcO1V06ay59hqyFEUfU62mIzHffoX/1AbdMqo0KXu8ZmBdqiu3JPPzMCF8Y8ebVhpXsNo8nPCkMPx7CWizk0JFhft1Ivgo0e+wSIh9w1pVhFZjL8S8+XoMiPMO/8CtXEmNfKECvO/4A7WhjpNpELhsOLNenrxaZ7+MmtjLOUz36gN0Z89houSRAYuAhas95DjDmtLegoR/P8Lt2rIgLxA/3q2bmcbD1i4kZSu7HFKC1ANF8EvaFO36ESeQsnTpemoS74Cyyjbh7VpGYsBkn3/TN38Jv6E5entWAtJhBwJBDaFQwiHx+qdFuy41oySS2GGEddee3rEppu5qQ8SmbkgaVmeVhPIZr+Xvfv+Rx+lOtjTOBBZ7eAJ66dhIsr/sI48B555divxKp1agcmEQFSGYOScZ74msXweMqu0Yu9I7I4BQBzya/2ZtHpkGZoe406LVg2Kin2Thf1+E6KUZxLWiOIzO6CetVPW1OA16WEZfDXL7erKK9oQ2ZHMKQiEXkQ5LqtlnENZoPWF8nqIhRN3BXw1ch++TUdOrACgzVAEv6ocHrXxeQ1YO4gWj6QIqcqyYfHKYHsPLUTFmNdcUUpjCOgmN35zxEqwVHAyhQ677B5j6X+ZyGSAA5TxHho9S8G7xXhHzTXlNHQaDnkqPC38pPi+0KaQ9m7zDOEUWLXmA3k7mTMR/Ohk/mCI3be2QhotZIQNQVkLQMZGXnvcJqw70Nh/576Yra
 H7WobpCT
 BC8AAc5mBTC1TEnFe1tye3IuWlncp+Xs3Y/i1WK2EvkBfNMbbXr4oxNG0WYw0Fupf/1jzBFQFOd+RBMHyAhwNPzA/SAA7D9x8KVz29ySulPbAXtLFoWFID8s+0ZshApKf1zguYFcphlTA0Qg5sQZpqRfEho0q3W708+Jy/tiBo+D0ACm/8xoqTv2TrpszHpee70oOZx56RunWjN284UFCMl7lZaIQAytTSDgaEv9VJ3+4DI5BMy7cTYszlfiNAtgttJTCZ8Q60Q3IBxfQuQSVFgEMLUyytssh3RQy4bjREVZVn9O6pqyt2fjiJpSJo1EcRPEgxj494/IKtnp8snF5cU80L3CRfdTmEXbsG+DUTByb5jlqMTOzWUeMVq2vXDEekt/cULlHv/0srYMvdrMpW8e+gDPRIFLjmhNoxmiLu4fYwbhn0k+YnJIrwq0CIm49s7MOF+FB+15pmSszdSp701aQm2JFgJthzugF9U9Qovf4zGcHudRYjtn83h2rsDm8XoKl0xuyxLRMmZX+8uiohEaP+iwUpSuNRWS+WRw5gFR4wpzeYFZ/ow+SJr4oclMjPQaHKPvHxnymOgVdD6OYZJwc6inHIVgsIwv6I0kQMYUQyVYC1LIg55kuPgorp/wzQbGmiNDd18EpKFCMsNIhZ5rbddQ93eAxqQkuuy4H/v6J9nw65A/jS9IDG9q+BycM85WukB3/euzlf8qlL8+3pVDbV0Zzt8uJpaR3KmjsOV9xFV2kBlg9R9hIWZBt/aQ99+kU+UKA9KwRZ+6TAVykWa+Kli8Vyrbm1JFgXr7svPnqhV8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace the cmpxchg loop with atomic64_fetch_andnot_relaxed, which, on
systems with LSE atomics, should end up as LDCLR.

This is somewhat overdue. In recent versions of the architecture, if a
system supports FEAT_LSE, forward progress guarantees for exclusive
monitors and cmpxchg loops are relaxed.

Mechanically, I would love to write test_and_clear_bit_relaxed(), but no
such function exists (test_and_clear_bit() has full ordering, which is
also undesirable). Implementing test_and_clear_bit_relaxed() properly is
a pretty large change; use atomic64 instead, as pte_t contains a u64.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/include/asm/pgtable.h | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index ce51c1b9be22..4285b7e7a6a7 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1252,17 +1252,11 @@ static inline void __pte_clear(struct mm_struct *mm,
 static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
 		unsigned long address, pte_t *ptep)
 {
-	pte_t old_pte, pte;
+	atomic64_t *pteval = (atomic64_t *)&pte_val(*ptep);
+	s64 af_mask = PTE_AF;
 
-	pte = __ptep_get(ptep);
-	do {
-		old_pte = pte;
-		pte = pte_mkold(pte);
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
-					       pte_val(old_pte), pte_val(pte));
-	} while (pte_val(pte) != pte_val(old_pte));
-
-	return pte_young(pte);
+	/* Atomically clear PTE_AF, checking that it was set before. */
+	return af_mask & atomic64_fetch_andnot_relaxed(af_mask, pteval);
 }
 
 static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma,
-- 
2.56.1.809.ga0b61035b5-goog


