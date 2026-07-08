Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 662A8C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09596B00C2; Tue,  7 Jul 2026 23:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE37E6B00C4; Tue,  7 Jul 2026 23:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8EE6B00C5; Tue,  7 Jul 2026 23:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F99A6B00C2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BEF3590376
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:46 +0000 (UTC)
X-FDA: 84964134612.06.1CCE631
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0C000180004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iFCHvQZ6;
	spf=pass (imf16.hostedemail.com: domain of 3779NagoKCP4pznu0mnzutmuumrk.iusrot03-ssq1giq.uxm@flex--jthoughton.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3779NagoKCP4pznu0mnzutmuumrk.iusrot03-ssq1giq.uxm@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LL4AMr/kt9xgKI4EE6n4T/6niteeK43+z1sjA/ZS5rw=;
	b=Hv3ru0LIBfmL4w+Yniw8qZUzi9p2JrQ9jl1/VxowT2kbupz2cHxoVAW5k86ytEL3ge6gWk
	mn0srXqIGCw3HS10fa++rtwBkhthzqZXj8K5pxVkwh3+/NQoCo/S5kcwKoe8u7RprhM3Ap
	u7jT+RAmuU4S1stlNhIgCxgI3KF6g3o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iFCHvQZ6;
	spf=pass (imf16.hostedemail.com: domain of 3779NagoKCP4pznu0mnzutmuumrk.iusrot03-ssq1giq.uxm@flex--jthoughton.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3779NagoKCP4pznu0mnzutmuumrk.iusrot03-ssq1giq.uxm@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480305;
	b=7H2uOkGtlW8KxhQ7zjetO79khHW9GIpTrk7Su8L8Qsttuclx/0oZQklybJondXab7pS9mo
	pGbFdYRLbm83lLqPwW8WSAd8IIriiHOiJ65bL28aooXly+Fdwr4v9AYiY0Oa4q2x9vyWo8
	OrK6pTeFUX2cuJwqYNQcR+4QiCiWo9A=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2cc8bde6318so5479435ad.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480304; x=1784085104; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LL4AMr/kt9xgKI4EE6n4T/6niteeK43+z1sjA/ZS5rw=;
        b=iFCHvQZ6zjxzL3fi+jdINKpll5Bo6BJlVYbhEbTia4L1lmTkt3yg0k/7I3gcbNGsrW
         y9RkxXahYmZB0t/a3wUMHo4/TycYHFaGZgad9BX07u9L6DYOPL3kgS+EuUes4eip2d97
         WgSwFeU/Q79U4h4wW6IH5pkw5pyG9V27hwZQEckHlxSBDiS2U2cgwkveaite/9nxAM5+
         aRGW4oiJ0vD5Em/WWixH6kPPI3RAHZ4XaSIPBsfKrUOG+bWa2GbicMtBwvjtH3CGC/5w
         fCXxzkCF9W7SgiZ6KhxMhMJAU3m+OdNo7kFN6XDzSioeScHtbN04nug5mL9HnX00LzlO
         npGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480304; x=1784085104;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LL4AMr/kt9xgKI4EE6n4T/6niteeK43+z1sjA/ZS5rw=;
        b=tE19sKvQ4heHD5XeTz+E6HXA9VORpfyaQy6L7iyHuACN6s12aQDq28x7liRs+JTJu8
         Gj4TgbCynSlDij/rsfZYLBQck9ylTOw1rdGL2T8Fa3BoGJYGENM4D3bl/mOAw3TtbV3j
         afbyobXdNbganl/zAf3WrMliejgIryJfLbxi7Dg8MdHX6+b2oOnNnOfNYormnTJVrLuW
         vcglFtmyzPzNx4VsrITTz3Dk0I/mAWJobUXxUrLh/DPpdfYRKxi0K00wqwgqvIzwWYX+
         V2ju3zKkkKW9/rj653T52BG9W2eI81yQY5x1tbPnhtJ5l2rJD5bmDzyeqEzCtk9Qqykl
         OlVg==
X-Forwarded-Encrypted: i=1; AHgh+Rpol+5sa5jSqGwBXwI7ZM3ixhcXbGSVEjok2DosSUC0gIGRSLQG2/n09sahH+p+arg7sX8HZRn+UQ==@kvack.org
X-Gm-Message-State: AOJu0YxQ2oETuch2peeI1pugLaczGF7EjsU4HIM6NsT6SOx2Vavz6sZw
	teU1j9ydYuvh3LpapvlVga7Vye/k3cRq6LFEaBYSVGdoBGmg81o7kPcV6A8ifpiUCTSm+pu9/xX
	xeJB0fQiPJRAoDdE27W26Fw==
X-Received: from plad7.prod.google.com ([2002:a17:902:e147:b0:2cc:e88e:4251])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e54e:b0:2c9:e86e:aa0a with SMTP id d9443c01a7336-2ccea274c6amr6735195ad.0.1783480303733;
 Tue, 07 Jul 2026 20:11:43 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:22 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-13-jthoughton@google.com>
Subject: [PATCH 12/18] arm64: Implement try_populate_vmemmap_pmd using AF trick
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0C000180004
X-Stat-Signature: tf96rbfn89oyftrxmn1sgea7snkx1y14
X-HE-Tag: 1783480304-949004
X-HE-Meta: U2FsdGVkX1+mzuFjZfqB9wIFqjJihRvK/mrNP58qWsLGqNk5qLoh1vbTTFuF4eNx5UPz+aXIGt1bUtKzJVGkrLhcOJZXGli/7VDTtJCyr/K+s6zNbvFESr9gnHvFQhmmHsPF7MY1TyTtVdZALyxWkpnPM6pq2ZMiJIS/djRWXW6Pdw4TcI0h2tdIoLWAEbUuR1ylxgvot6MUEr0Lehm/SG6ip7z/1mm0L6oikW4gUQxfn2QX2txVSryAA8scQp7t0bRCb7ASj3hm5S8v7dQw1Ew3o6cNIAmel/PqZxR8ZbajRBiq8tiO7P0xQ8wkiEUQYCBAzT5FWtOxuceqIgEJj7slODOcHAfFKlVwLHRbu78P7EcfwRdC/VfXTV3bExjrj2gGpavQn33w+3x7mBJNAROEUeyRXGzxu/tIKexshG/nmx5FqIkts2hYsmASpUbD+Qpk1qT+hRpAxFpAATwG1Cp4nhAV4pO+7LwDOO2J5i6Wpeo8By3ztkXn839RytnKX/m66xFLiKFt/K9BgXusgiUXc5wK/dWNSZxTMbJmk4tWyk8W6pdhSnnR6Ti50vFwy6i81Rfdve1qjwlvlNIPvVDeUBU6B16aIukTDslGWe/jO32NHKVCPRTCVXIsm4HwrWRXtl/R0G79feho9aDnIeQczlHQaYL+D1j/4k9nWktuvwZ6wuksfLPZxn4ja21f7sQTo4hgT0/xN74cPSRXVq2mBVQpWRb4QOq9h2pxPFlMCiE+b4WAOi9siygvYl7HQyKcQIZv0yP8uzXNSVWaSZHcS84J50DMwD6TppJ58DD2oJw5opjVGTbcqzZodrv4WDTErq5OLWtgbOGAMVmxg3GR8npjH6JOqsOR7tMqomCWF2fOnm6KZs700I/mdPrC11seIjov/AbjNkafp4aRPwb7ynnfeRK4xW2fU1nCAgodFW1wF1wW/Z5k8pelJtEwJuHODSRLUHM/tIflY8y
 oNJnspOZ
 pBsrC9px4X9wCq1brfuAEbRfQaNZb2JEQ5dcWXtMGRJb4Ub/H84UzM02acwYxt9i5dY3aLeM55crPoz5FbSpU0HThjH1RWyYUrESIctoM4nNtj1OINZVCQzITZ+zfBCxitaanWmhLhHwXGvJpu7oyNpzF+9pNxZZ/L1tuQ/JWfF9aur8D3jdsxkUt5q/mUfpYkaIFa2zM/fjib1NWeeK9/tXZ9mfFsJ+V5Ah18HP4wfu0e41gt76hUUw3eyVtNSLH/74vBdFYdY7Ox/d3c05+Z3ppdFrJbmIE9EVDg8dtlyLHv5na85Z2KH9UUjocdSOW3vSMqVf3eMkPvCpjlLFtzQRHoFUujJ+y/3TOXhPrwQ0dXbASo77Z1qPx7yLXfgkqiMulCQevf26srqn4FeMhJC5c8PcIh29w5b1KkDFIYCfs1lQe9mIUKT2cRfu3pJUSRoZBesL9lDf9EfCR3I2B7oP054+4XNLZKdYb5SGoruQPaWTOzjA2LnZyisen32qW17cXcvSR1Qf4S/snHorcYyrgvBZaraCgZPyBmIkPzDJ1LToeaPL38KhZOJR2AzRfv7YDVd7CH+K3xRCOujlAD9XByHTdJBs7B2VEeE9WKBpR9sOo3ymFUs4Nc6SwLNKZMfMOUQEiJBVvdxsDELoRG1Z24Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This routine is to be used for updating in-use, leaf-level PMDs in the
vmemmap without introducing a window where vmemmap accesses might fault.

Implementing this on arm64 requires some care: use the same access flag
trick that is used for vmemmap PTE updates. HAFT is not needed and the
TLB flushing routine remains identical, as we are not overwriting a
non-leaf PMD.

For systems that support BBML2_NOABORT, there is no need to use the AF
trick.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/include/asm/pgalloc.h | 51 ++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
index c8946250d431..26b05f8b70cd 100644
--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -125,9 +125,54 @@ pmd_populate(struct mm_struct *mm, pmd_t *pmdp, pgtable_t ptep)
 static inline int try_populate_vmemmap_pmd(pmd_t *pmdp, pte_t *pgtable,
 					   unsigned long addr)
 {
-	/* BBML2_NOABORT is required. Its presence has been checked. */
-	pmd_populate_kernel(&init_mm, pmdp, pgtable);
-	return 0;
+	const int max_attempts = 16;
+	int attempts = 0;
+	pmd_t old_pmd, new_pmd;
+
+	if (!system_supports_hvo())
+		return -EOPNOTSUPP;
+
+	if (system_supports_bbml2_noabort()) {
+		/*
+		 * BBML2_NOABORT allows block->table transitions if the PTEs
+		 * underneath do not conflict with existing, potentially cached
+		 * translations.
+		 */
+		pmd_populate_kernel(&init_mm, pmdp, pgtable);
+		return 0;
+	}
+
+	new_pmd = __pmd(__phys_to_pmd_val(__pa(pgtable)) |
+			PMD_TYPE_TABLE | PMD_TABLE_AF | PMD_TABLE_UXN);
+
+	old_pmd = pmdp_get(pmdp);
+
+	do {
+		if (WARN_ON_ONCE(!pmd_valid(old_pmd)))
+			return -EINVAL;
+
+		if (WARN_ON_ONCE(!pmd_leaf(old_pmd)))
+			return -EINVAL;
+
+		/* We should never get a contiguous PMD here. */
+		if (WARN_ON_ONCE(pmd_cont(old_pmd)))
+			return -EINVAL;
+
+		if (pmd_young(old_pmd)) {
+			/* __ptep_clear_young() returns the overwritten PTE */
+			old_pmd = pte_pmd(pte_mkold(__ptep_clear_young((pte_t *)pmdp)));
+
+			flush_tlb_kernel_range(addr, addr + PMD_SIZE);
+		}
+	/*
+	 * Translations without AF cannot be cached, so we can replace
+	 * them without BBM.
+	 */
+	} while (!try_cmpxchg_relaxed(&pmd_val(*pmdp), &pmd_val(old_pmd),
+				      pmd_val(new_pmd)) &&
+		 ++attempts < max_attempts);
+
+	return attempts == max_attempts ? -EAGAIN : 0;
 }
 
 #endif
-- 
2.55.0.795.g602f6c329a-goog


