Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA62B606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 03:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OrAptI3I
Received: by kanga.kvack.org (Postfix)
	id F41BA6B0746; Thu, 19 Nov 2026 22:30:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF3946B0747; Thu, 19 Nov 2026 22:30:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E08FA6B0748; Thu, 19 Nov 2026 22:30:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B29256B0746
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:30:10 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E19E80C61
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:30:10 +0000 (UTC)
X-FDA: 85454068980.24.73D824C
Received: from mail-dy2-f6.google.com (mail-dy2-f6.google.com [74.125.229.6])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5A0891A0008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:30:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OrAptI3I;
	spf=pass (imf19.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.229.6 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795145408;
	b=6CqlXSlOXxeYOtwFbJCNvTHW2pAPYL/nP1mM4VMMMuDYfqhqSjjZWZ/iZ9sC7vwL605R1p
	a6kbAGafybL7bPKKVTFRn06SBnFwK4YJe6KoGHb29x9AQiJj1Ujsu6Lik9ZHOKpLqW3jrz
	S4ttNgsYdR1me70BnkJO/R6x1ud0eao=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795145408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KTndnfxJwqix05BvAkS77J9qZoQYoGc9j/m7r9xKGZc=;
	b=KaLLSNFVz/PMBcyB9dHKHyPg6sz+oIFibD+7WI6+QGRkE/gEkelN6Ilexxn9/p6AMikzxy
	4Joc+JqK+F/2ZXMfAbDclp5dUkk4hrDm7T8h7upKyHeU6PNZ4O5ZDDi4/INMtSjIRa1k80
	QhwHyssPLWAnz1Ce+L173VLcZqX9YRQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OrAptI3I;
	spf=pass (imf19.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.229.6 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy2-f6.google.com with SMTP id 5a478bee46e88-35adc681e1aso477094eec.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795145407; x=1795750207; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KTndnfxJwqix05BvAkS77J9qZoQYoGc9j/m7r9xKGZc=;
        b=OrAptI3IHZH8O36QRHOGM8qbejn4gpa67Qj0vvDcuI9fw+22rZQdjeqBfMdF/3Yi1/
         OQxWGv4+6m/uOnmZYlD3vCw+c5j2GOqgMrZhNB8z3bdZon9sMKuzHIJJDBVCFi+1f+7H
         sjJaXe9HEK4XPC9je+YeNUvng8YTQPq4P6KyNp0fQyRU7hsIINZ8uzZHsiUOmhzB2CYy
         D4BT9bgepKu336r7iPe6vxt46J/OlBjYrPaRl9KNURGmPAVUODOmxrGpHkNOrEoJ55It
         euHIwG84IFkuCXp4gwCoYDJuYIF0JVtaj4hLcMOf2AWWTbCTg2xeScOfeD8CVQKorsaV
         yiRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795145407; x=1795750207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KTndnfxJwqix05BvAkS77J9qZoQYoGc9j/m7r9xKGZc=;
        b=GmuKgcVLMgQbp/6sQeWksgujd78Npg+QwC8hVdnR6t5Qf3zKBqMiOuqPEHm6IiS5hm
         vDs9xjIXAa1B6i+lnac/WBSsZhxx2IArbUa9lFoEvv7rZtURiUhDrXmkHYMg+UNl88aP
         W5n1tFyTXB07CsRxQegdYsv3lBBfUR2iodBFISUfvx2On+kQ9PyDeBMyPuocJPruFLsu
         BmTCNprcY87EnsCd+frBch4+bpALx4Bdyv+5V0HK8+ibX504n6Q1Rlc2x8HO8S5TiiOU
         24UvpAybQZaL9Dwof3ASZMOZVz8u+25pdFeCngjpMuufUgYRABjpzAzm8jLpxLXGo4cK
         naWg==
X-Forwarded-Encrypted: i=1; AL+hErGOvkhxd/TKGZwbk2TEAQ9Oj5gt0pwxzLe1Jk0W74+0poawiiXReHtUuSKFtKUSOGH1N/Jpify3LA==@kvack.org
X-Gm-Message-State: APuU4Z8Wcjtf2Uxx+ki4AU5UlrnYs9ZjjD19svxeBQ5MKpoP6bNhe+Cq
	SZyKnxYBtXaVznhzisgZ1OBiJVNk7C1aVfsj/POctFy4n18spqAV4pzo
X-Gm-Gg: AYBFou3bEPbnXovMOUT+UCHVi9neiN9UzDd7ihxxSpBS7iDZA2KbFdWDGMPhzS32V4+
	tpfOtHretWGSZaIPCy+dgGulNSqBdJq+FPjgALscldB10856K2ldejqtU51Ji8gDd6aC5IPjjeU
	a39f7znsSlzuLeTK6Jl/TnspxTU3LMMf1QZxIiqod8jGOh2Gq5jS7NtSfukkV+U7VFRXcX7GiLb
	zIS5iGK5gDSGYLGH8y9vgm7gMN7CInk1ZHCdowlxOb9myx23KljJpXKzq22+GLmw9FNSCM2JNNT
	rURFhhnswa3QnoPlHxifLcv29kkkaJ3fCH0N81cmL3mOm/XSUcsumqh7UrkeheUNWQNwnryxHdK
	BJAoVFek+BOSzlbNFxMC25mS9suV6qhrBZ2/XWKWR5gm1XQ61796TWlZJxNtzSyQCn+MCvEHevx
	w/uymZgqyYq3L39h0/y9eNOw2DDzy5cmzXMcVmTnHeHmSR1uBiwgKaDOv9lRXRKUvhq4OEboq6S
	yJPSbWPeM4yXUT3wAEXo0QtlS+xHjERXUkhYE63EN99TZwSyakNTGgsiSjBiUn1WHHEvI0V/qAj
	nferhSsecIudwRYwNDixU5UxEOThxQQfAM17iM8YeA==
X-Received: by 2002:a05:7022:2207:b0:166:b307:5855 with SMTP id a92af1059eb24-1b556688160mr2437834c88.0.1795145406990;
        Thu, 19 Nov 2026 19:30:06 -0800 (PST)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567e644dsm4362507c88.5.2026.11.19.19.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 19:30:06 -0800 (PST)
From: Wandun Chen <chenwandun1@gmail.com>
To: david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Subject: [PATCH 1/3] mm: factor out common softleaf offset PTE batch scanning
Date: Fri, 20 Nov 2026 11:29:47 +0800
Message-ID: <20261120032949.2036731-2-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261120032949.2036731-1-chenwandun1@gmail.com>
References: <20261120032949.2036731-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q3btcxmdzmz881rno3hhud4ub3171bpx
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5A0891A0008
X-HE-Tag: 1795145408-223128
X-HE-Meta: U2FsdGVkX1+clprfZKGOMpxZFM6SA7NzfSRocdqwtsgaHAPAwQO6cQ0twUaL2EjSKb/qrdDo+j83OM3fO+dMqpyW3ou1wpFtqryFnUdWxQfzi2gcqB7GhCNExJJkUrIdfc0T/OMLrxWfKqPJN1AzY4P28doB9IYCsaLHL16QEGGoFp//3IYKgr0vuMA6OOgZPewUIRdq+/MfCmKczDov/r8Lvv7EA6IwlGzM42Ji5zONfC60fHU/rfeyt/nP0Pu9rbM4bu02D6qMLqU0CyYb6aj1qRBToNwfkhFOskhD3CIxT4g3hOxWf0UisLVAkBpw4XTp2RpmKBI4hax/NMg9AIwcOtHbrVWnNEVhXJdzNs8NuMuMRqrHPS4qLq8/FrZ8lIK3I8mPZ8zJMPyZemeQ5549ho6Odkk2SCbew5bIkiEi2tGJ5meRauxrdiLib6XOSeniqLHEr1XvUVkczrCCVSRIakSTYibBIzTPsrmZFnJnww+VupPJCUkIDl7+YvpD7+7SqcoX93ve8DJBGIb2Jua7X5lIjSmmnJsSzHFHiM4ZRMEMP1+SNJi2zSfsbM9dAaNRh1dpHvMpoV/9sG6mySfpFWtkRbkfcDyWskM/p1Tn/pjC147ShxDKNcmNVSN/Ki/w4UkK6j3k9gnP4PqRcRXpESjUTek8RN/huTRIeFHIm1KiC32RJBW/o8lJlgJVlEGA5uYiugN1dMulaRpQ51Y9LnZgePX29hKUa/RETT6ymsWe/Tu9JoGCVp6nXkaskPxG4albk4Q2LkMuugL8H5fb8kQwxZnnxdlxUSewms6SBsDSguMpV1/hkK5c5edAEZhmYJ1fYQj2ixIATpxGbkjYVPwr8zJNPp4aUaFPOq5ADzpQIah0So/HlGID5XcJWdgXZkdgvsibRHPEtW5vN+CJeoLeT8EYW3tOldLOXaSOdXiEwS90V69UE6Fp5+F2zgeGicAcql0JEZVCNIx
 qN80T9dd
 jhDA+RUpgucZMNOOvCkZIfTxoja9KDEVg8WmeKYtr3ncrYk3XDA9S12oAgPub5ijBZuqGwvtplRVLHROEC1MH7tYeq010oLYlmcAoxOEn4S2fBXtg7LF3Ji9H0dUnkVloHtIY0KrbftCve3Cpv6oyrIq1cq+qm48SGLfEuDX+o2ef6THbUrLtjK8FKMCV2GNnV0Vlkxy+rT8StEsTg6Q29O6UkKZENsBDROh6bqIe+vXContmK8lbxNT6MLVzEwCn4aD87txU0IRyu9NdCzQ0McyKUwOQnFo3T1mZ+8Lh/ji5jn9bbylFBoNRIT9WlFfPGYA6APdROmNZLO0ZQYFdFWX4mkImRtDZVbgZYldTzke3/A7YN+xiF6mlsX0cxe4slWyd5aD6CmowjleiHt9mdXAtZOi3JR0VSMbFsuSu+7K+H6ylMUYLVDs+I6dm940wduXMmfd3PuNa6NjZY5KCKkcfz8MdRb6Tcw5UqTZc3O0zpXqgwFW7ohwzT2HaSL21jC4+jroYVzMdLYtJCq1wsWnUTAq4SjlxkdVNkHCL1fyLCWEvCkbgvhOuuPG3cKi2VKfo45S4oR5YLYa3yfGa8NaBUozmy3FRx59OxlVESUwhHdmaQMwfqfOVngc5mGH/lieg0h8dGzbiRjdY9ZZbkYIaLUc91dxp7NGBmZO7JnSCCQTIGL3snoFo/ZDS/XlNKQMj8YO8eVJjV47+6V4U7cs9q3psLYAl36DT8a73ZHp6nGU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

Extract the consecutive-offset scan from swap_pte_batch() into
__softleaf_pte_batch() to prepare for migration PTE batching in a
subsequent patch.

No functional change.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
---
 mm/internal.h | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 3a1643afedc0..9f78c12882cb 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -512,29 +512,26 @@ static inline pte_t pte_next_swp_offset(pte_t pte)
 }
 
 /**
- * swap_pte_batch - detect a PTE batch for a set of contiguous swap entries
+ * __softleaf_pte_batch - detect a PTE batch for contiguous softleaf entries
  * @start_ptep: Page table pointer for the first entry.
  * @max_nr: The maximum number of table entries to consider.
  * @pte: Page table entry for the first entry.
  *
- * Detect a batch of contiguous swap entries: consecutive (non-present) PTEs
- * containing swap entries all with consecutive offsets and targeting the same
- * swap type, all with matching swp pte bits.
+ * Detect a batch of contiguous swap or migration entries: consecutive
+ * (non-present) PTEs with consecutive offsets/PFNs and the same entry type,
+ * all with matching swp pte bits.
  *
  * max_nr must be at least one and must be limited by the caller so scanning
  * cannot exceed a single page table.
  *
  * Return: the number of table entries in the batch.
  */
-static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
+static inline int __softleaf_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 {
 	pte_t expected_pte = pte_next_swp_offset(pte);
 	const pte_t *end_ptep = start_ptep + max_nr;
 	pte_t *ptep = start_ptep + 1;
 
-	VM_WARN_ON(max_nr < 1);
-	VM_WARN_ON(!softleaf_is_swap(softleaf_from_pte(pte)));
-
 	while (ptep < end_ptep) {
 		pte = ptep_get(ptep);
 
@@ -546,6 +543,15 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 
 	return ptep - start_ptep;
 }
+
+static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
+{
+	VM_WARN_ON(max_nr < 1);
+	VM_WARN_ON(!softleaf_is_swap(softleaf_from_pte(pte)));
+
+	return __softleaf_pte_batch(start_ptep, max_nr, pte);
+}
+
 #endif /* CONFIG_MMU */
 
 void __acct_reclaim_writeback(pg_data_t *pgdat, struct folio *folio,
-- 
2.43.0


