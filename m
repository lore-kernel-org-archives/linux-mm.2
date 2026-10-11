Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74A18CA9EBD
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 13:24:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 367C16B008C; Sun, 11 Oct 2026 09:24:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319136B0092; Sun, 11 Oct 2026 09:24:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20EE06B0095; Sun, 11 Oct 2026 09:24:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9C746B008C
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 09:24:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E12D7120975
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 13:24:20 +0000 (UTC)
X-FDA: 85310414280.29.DAFB76E
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id 375BD180005
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 13:24:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ScNss685;
	spf=pass (imf06.hostedemail.com: domain of samarth.colleges@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=samarth.colleges@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791725059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2oNkZjunzzMVyG3EOfIOytuskDXyogdyyjCDaj7C0Eg=;
	b=GAYJea9QFbe7myioeCT6bU2bg5EgzFVCk1MMG9eavBFKeKzS35sXZYEUwnwWbcON0i5iwi
	WJV4vrWnArYars/hTp8e0OGIoDZS/Sq2qvXJemjOjbKcDtYn6brVRXhZaAOdx8HfaeygAM
	uvpOCXz2787wXD/2Qhcqh9MfhyF2Omw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ScNss685;
	spf=pass (imf06.hostedemail.com: domain of samarth.colleges@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=samarth.colleges@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791725059;
	b=CwePY4Hp1dkYP+f7RQEMgO4rAG4InQ6n4x3KwcTYtNdcF+QoJbQ+zBW3X1nO+3+/QuF0yW
	CqX+SwrRP2Bg2qGPJDPzT8PqyyZfh/YymXRYSM7boV077g2Ii36dZgj1BXfzfxWkUaAiaZ
	YhMj0qSo/CmoIcui0w2ttJTnnxoWeC4=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ab60ff4273so940760a91.0
        for <linux-mm@kvack.org>; Sun, 11 Oct 2026 06:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791725058; x=1792329858; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2oNkZjunzzMVyG3EOfIOytuskDXyogdyyjCDaj7C0Eg=;
        b=ScNss685GioXxMN41MKAIL3vPi+gegfqXjPQyhM5oCTh2n7QetLVLdthAYbYovbgMT
         v18I6cAvQfLqJXjQYSrANRFgnFFABtquWf1E1wvEjOnv2GsVKxryThENNtAii0M3h15L
         8TU/deo3N8RVkRts6ltExptyOZkVRjYWW3jHSjyopMxCnuEdgFp0CXFwhjgykk0zsJpL
         RqRPoPKykzp8UT0SisPcFPPYesGHtYD+dvp0pmpuAH4bBKFbpofkeX+FZMKI+49qcJRU
         9FWnMEhTV8G3DeaB4LizpG48Cf6MiLxCFkYKhr7U8V1FY5OiS0MxWQn72GlJSlz5nTIR
         qFPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791725058; x=1792329858;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2oNkZjunzzMVyG3EOfIOytuskDXyogdyyjCDaj7C0Eg=;
        b=J0z4ZQprz7QXOcuHoDANxzADC8VYtZ7ZkgmGPw5xVgxkIHxiSf8QZCY9jSivByoDqL
         8sngnssXG8OkihuYo57dwABUpQdRQYWUv6NpJ/n+KQ6hfTsQqN8sTQSmzct5UVosZJzl
         VnNVlFw7jeA9mXuXTvNRz2GWt3rvHD31gfoOD9a5qviQMBVwyk6FgO5YiY3vbVRFOaT8
         m5qX9sTHWatiDTa2h0pAYqw0AsU8dw3JNqRPBfHBTTBRoKXJtvDfg0I7lca9q6hneq1L
         Z41QXsGPv/iPba5FZSAEZXehY8QipxkCak3nY3ZIPPhk17wMQIuShPkVGzBr8CCNK5e1
         2sSA==
X-Forwarded-Encrypted: i=1; AKwUvBxcHItF71YS3KxvNTNeSDk17kf6NPRLjfKFXRuCExbXib+uJW4eXvX6qBeiOQWmUUp+MN7i+rHxnw==@kvack.org
X-Gm-Message-State: AFq9FYJNzhbQNQmL0HOzgQLvjQcSWqnrojv4UD/ialQpCG4OS+eiGPm3
	KlvJIytkupQ1pDAcd3mGxieUKt1mmuvUSafojIx7zJywT1da29FOUzxg
X-Gm-Gg: AYBFou0iZKxLO+Yr0t2cpcCXeQVDCJpoPjTbYSztoFoTKmoREz0ELrvP6Tq7hIahhH7
	Jbkpcpf2qqMpkbKAFnqsZkAb4RAaAmTyNYFE1s3nkqUwyYvdPR3a/iYVQ5UbQ7dXsPTb9kBRNi2
	nAl1bqhNX5VumXnMQWkZF9b2P5S0RnAZpzKdaP7o/y+95PwE/uK9MW8VG09EGhQFZN1P1jFxEEX
	V+/9vlKRZYzVh9+o8CLiPnnRPJVXDsWeH1eCUJ2WTswzVKXnYS+caWq3B0CJFIWArV1mDMrrDiT
	gv3wgu0d4sPVAJMJ0HFF8JzRCkCUK2WQF4ReNGIMHHDt41rfaSq9nuTUQ7ts5yR1kOFlW3BWEQt
	OzZSQduqSFV101q7oLveEP3efIr/QmcjhsC1syhqm8nXc7vxqIqgbhvH7y9WStoOHuAM/qFSWZA
	T/D4dW4QprmkOi1fi0zPpCbCWgR32L3JqnBYuKDIuxlBvW7HqmTxvt08dk8ED6Z6VciaDiFnFvw
	Fea4aVaBLs65SQJi2S4YZixah0KqjY4/uYovMGFEDd4A/XMdKCAq2j6
X-Received: by 2002:a17:90a:d2c7:b0:39d:f4a8:75ef with SMTP id 98e67ed59e1d1-3ab3a33da74mr6165030a91.1.1791725057957;
        Sun, 11 Oct 2026 06:24:17 -0700 (PDT)
Received: from 1u1g-b650-0212.nvidia.com ([72.25.70.131])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab396620e2sm7595259a91.3.2026.10.11.06.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 06:24:17 -0700 (PDT)
From: samarth.colleges@gmail.com
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org
Cc: vbabka@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Samarth Narang <samarth.colleges@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/madvise: keep the hardware dirty bit in MADV_COLD's THP path
Date: Sun, 11 Oct 2026 06:22:27 -0700
Message-ID: <20261011132227.413217-1-samarth.colleges@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 375BD180005
X-Rspam-User: 
X-Stat-Signature: 413i5yi7ahgxmkzxw1npwr7eg5oqfq3x
X-HE-Tag: 1791725059-17250
X-HE-Meta: U2FsdGVkX1+lTVomnUFeRxrBGIoy1rs1cXQmWS13EzFDr7Hf5r1IQM46BOT8J0No1tOKYmXfW9gKUNm5AkmGoU5vE7OyvHFCZhW6Jv64oC6bMQhqXP36jK9IudS7DBVwNvAmQfjGLsFjDA9XBbZJnGKAcUUVkl9fQS/ZH6XyaAJMIaVlNAUHxJmGxNrXPMIE+GS6NRl4GR2Dkv5dn5m3nQeU46sYtFK7FPUAl0ScOB+K1BeMloannJWoqyf3nq0kHtrbfxFk2BHJg9wPqic/n4rjiyJhqNtMfXkjww/hA/vzHgKuB3oZnr4HqijgvWDWFryPnnzXgyqA+RBQYucpct+AegZ7KiqBPmEofnlX0EDsThcgKUG+6mBIxRA/qRbBJjW+6fCC+9+UGBTXMOiBk649deazBbdchFtQy/9KAFyDK7bUSKO9i8tEro8HVLamwRgBS94aDPFQYS6Zm6TCsmr9ndUDVj6OSrYaJV0irka5Z00kKNW9pY5iwv9IlxpIi+6GEhQMoLam7tSsIIa51OP1Wyci10tDXHIH+LV51ozPMRR8SAHgNDklNPY9mjBNNaz6Y5ThUXn9I8LwNzePmffFiTwm/9d4tCCUVixrrwgWSizuznx5SSuisa+psRxHQi0R9DumfVISocL7C21AmudFpaB+WHikKj8wySj0hXny34gBMIbStHGGfXXBnrqBFQhTa6mRII9+xUsPYqnXjCV+O2G7QxdsfxQONCZqfcnQuE/usI7/LWIPeXeC9/Hk06n+Ekfd9vX6KFgEM6cXuPP1KJs639Zir8ObPCSwv4tfo8Z+gh7XYBHElvNC/QS5EJDJUE5c1m1jJFNzNAWT1BvQLc5MJNv3+LMYoYQMQZ6IHj/6npceE74bXNwxZ8qRkja1ztcK2PoEpEftHLrEnZzcoKinZtqGRGc/pA1jo2DoEBrraRQ2wuj/ydNilPS48E9v7qvVjIowI3YsYDm
 IZC/N1BI
 7238dvbBpaNamES0U8H+7yFx+0kJDHdb4MO89SM5PJ61EYkorxXjgdzC2naF4rZvI77OM0DMHQaiq6MDz0Mecq1K86D1tLbNz//lYOs/qV77vMKwRzaRtVgjJ1G6flLfEl4AKH5ePU48CrTskq1GttsaEMztKTZP+QTb/Hoac7Ki0pVukTVqSmu/XKa3zpNdUVFl8QW2q3xBCBP5z7D8f1nL1Nnyvhvtt3aFDdfIPZbpAO2KLWv8Iec+Tfn2uu+zOMVbgxFgHcINarzoP5j56NSNOe1ICTVt3fjwNh+V++FfaTyP2Pv0uGFif97MIIf79HT9bP5ChumabH2X3LbBrALZCUgtmxT2iK8TDqXAqxQcQMHDMN8n95rjWB66PRbwKLSsdLxOzG9UEwTeHadL35g2WJZehKdT5/AySC8tUXxpqRkSPwHw7MgliZGxHYuhzMfJ1c17LPnROb1JWx7JkJg3QCxGKmouRcVNHXQq79BzSnboMLV36GznfCfrDB6ZOGqP+CSqBiRfW2lzmK+y1QOUiLSfLnnCCWlXXCBHxUnDDcrVQxdIVyPR82g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Samarth Narang <samarth.colleges@gmail.com>

For a young, PMD-mapped THP, madvise_cold_or_pageout_pte_range() handles
MADV_COLD by reading orig_pmd = *pmd, calling pmdp_invalidate(),
discarding its return value, and writing back pmd_mkold(orig_pmd):

	if (!pageout && pmd_young(orig_pmd)) {
		pmdp_invalidate(vma, addr, pmd);
		orig_pmd = pmd_mkold(orig_pmd);
		set_pmd_at(mm, addr, pmd, orig_pmd);
		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
	}

pmdp_invalidate() atomically clears the present bit and returns the PMD
as it was in the page table at that instant.  A store from another CPU
that lands after orig_pmd is read but before the invalidate sets the
hardware dirty bit in the live entry.  Because the written-back value is
derived from the stale orig_pmd, that dirty bit is erased.

If the THP had been marked lazyfree (MADV_FREE), reclaim later finds a
clean PMD and a clean folio and discards it rather than swapping it out
(__discard_anon_folio_pmd_locked()).  The store is then silently lost: a
subsequent read returns stale/zero data, although the MADV_FREE contract
is that a write after the advice call cancels the free.

pmdp_invalidate() returns the pre-invalidate entry precisely so callers
can carry the accessed/dirty bits hardware may have set concurrently
(d52605d7cb30).  change_huge_pmd() and set_pmd_migration_entry()
(8a8683ad9ba4) already do this; the MADV_COLD path does not.  Rebuild
orig_pmd from the returned entry.

Reproduced unprivileged on x86-64: a 2 MiB anon THP is marked MADV_FREE,
then MADV_COLD races a store from another CPU, then MADV_PAGEOUT; the
stored byte reads back zero.  On current mainline built and booted under
KVM, the race lost 131 of 8000 stores before this patch and 0 of 8000
after; a store-before-COLD control and a MADV_NORMAL control lose none.

Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
Cc: stable@vger.kernel.org
Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
---
 mm/madvise.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -426,8 +426,14 @@
 		}
 
 		if (!pageout && pmd_young(orig_pmd)) {
-			pmdp_invalidate(vma, addr, pmd);
-			orig_pmd = pmd_mkold(orig_pmd);
+			/*
+			 * Rebuild from the entry pmdp_invalidate() exchanged
+			 * out, not from orig_pmd: hardware may have set the
+			 * dirty bit since orig_pmd was read, and a MADV_FREE'd
+			 * (lazyfree) THP whose dirty bit is lost is discarded
+			 * by reclaim, silently dropping the store.
+			 */
+			orig_pmd = pmd_mkold(pmdp_invalidate(vma, addr, pmd));
 
 			set_pmd_at(mm, addr, pmd, orig_pmd);
 			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
-- 
2.40.0

