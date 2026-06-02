Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1D52CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 17:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4183E6B008A; Tue,  2 Jun 2026 13:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8716B008C; Tue,  2 Jun 2026 13:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DF106B0092; Tue,  2 Jun 2026 13:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D1836B008A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:23:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7590162F31
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:23:09 +0000 (UTC)
X-FDA: 84835643298.09.DBC9EEA
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id DC68C2000D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:23:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p8IkT7wf;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780420988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LuoNOAKT3xp/Mcyg5zk9iG0boykaRa5ZJsdMV4nHiMc=;
	b=ktRSJlvO/sfos0ucIeXCnN9fsWybWkHVQQ2+VHcNVgvhilpmVMCSE9K/3X/17K69zz6usc
	w6dJS+E1NokkM22rqsCbeFN5xrNoquLSCCl51nVQVFbNWjXGRaJTVmkpaHjiFjakJjgcDU
	xKM4aH6qHBIXiLygJCKL4aA8r84x/BI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p8IkT7wf;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780420988;
	b=HXdNjqfcoC+R6U7OD//IbFAJb0sh9nuRiSrfX+mKPN9kj64AbttVU8nzGATfTAE4/+ZN7X
	zDsHRRU730981lxKIuy8USGFicezqT7XGndixpSj5oLrSAV37JMHxP2YZvL4Mb0OaU7oGU
	TsaTHo65xp2Uc0Oo2kk7sFWp1HL5oVg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780420985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LuoNOAKT3xp/Mcyg5zk9iG0boykaRa5ZJsdMV4nHiMc=;
	b=p8IkT7wf60XE8WKTbHBevmxzimClhYD6p5B4fw0QOtOGyK64bWuUPbRK4Eg6XWsVoqEG7I
	n5lMoOdDR4S5f9+WFRdbAxZUNNcodgoTxJJTxa/VRi4KYaox81WY7o5bmEJQj3Y0pYDjgK
	NhqNfISEye3bBLHg7kMXBBIQ0c6ffyc=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	jannh@google.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	pfalcato@suse.de,
	vbabka@kernel.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH] mm/mincore: handle non-swap entries before !CONFIG_SWAP guard
Date: Tue,  2 Jun 2026 10:22:47 -0700
Message-ID: <20260602172247.279421-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DC68C2000D
X-Stat-Signature: ft67hiiykxrus3hd8x5wwmwgujetceq1
X-Rspam-User: 
X-HE-Tag: 1780420987-197640
X-HE-Meta: U2FsdGVkX1+B7Gr+AG4MGn0jU+9Lci541O7x1PYMFO1B0g4oKd22bRf89BE7Z3JdZhk7DbzQnHAYAhEn/5UIZitrskiEZAiw8+/cp4YIb2Z67wYlwr8u8JMxZiD37FCNZxP0raxxxF6INPI2bxXEkcY33gIypJq98sfULTu992CDNofuXrbybshJvB+lu2xpiEmP6qlQegrBjF9kuaoubZBe3oOzMtGqy/2blNOxIX3vRXvuoqet5a5l0Fb2W6X71tcLIZUfOeQWzzfDIpQTE9biDywv5QTOTyIOMjG9T+YJtAOR6PdyTz9YbqeLREXJ/EGszviACNHfLmx4DbVfdMuhwvCrJMRnNe5DrS8TCu5I8mH4wOpfq0iSTlD0hkKnP02LHrqlTDnaijo8uy7uDm0ci27sL5okTeewHr7iA9CcYNAedh4Jzn+0++5jco2ND05LFjyV1kpuYAK1UURRIDR2gz/c4tvcqu5YsxfDjf8XKgrxfH/vkjY62HrapAtZbgcFWQBj7Yniab0qw6Kv3KZ7XHw7UwnTJMWg6AA5DD0fsDQvHo8eYuS19K6IP1EQlJSH2ydK3V4iRkhU2JNm9l/v5NvObYiufworR8jK9sdtgS0y8f6bawPn26eKINKSU2HtuRMDVXxwo81Ff6Bub/+LgMysa7Rem5Grw+uLhebJW8GXwR1psjJY/f4LC4EcQYJi3a5Kf4i+VSISf00WkUmTNBsA/hhHBk2rNVLSfcfUpIbQqalsGIRIpXtNUvGKtkvJ62CuSH/HrgCiSQYUC/PCXFUZrX5q5yI++O519qdS+uK2NCGu/+oq4kcTAcbozLOpguzWc1hnUsCpSIj1GYqdT8wzphgF0lGPQZnLCakm1+D17CD4p5kFpwzlRUlOzGfiXvktl0OGbpGqt8fncbVpprH44DUxSdkkpPktklOSlz4cwOcApB1/AWA6+EZ0XUpCR2bZfVnk28qC/8q
 3b7Syh2K
 8PUZ8oL1o5k2k9wJSeG3t7pMfivrNvfjdWiPI8fAt1FwINNS9Ne28nb6Kgm1zO/VWfiTUOoArUrgzRNwNV6eFUGjlxo53p8tqstlFaLnyMi8z3uyn2pkmBpDB9io3GFYE0CII4eXnGuD/TGxFPYq5uS8cbusg1BSuWTUqYVkrZAvwM4HuA0xQyCCf2fKiErZ11m9d/l2HX7790XmophGyCh8AnIcVswkgxU26Y2Paxm4Nrlaaa/v3zz/5B4jFDi5qdkDKW3TEI7JBPx5vKBsvHhwbB8jF4LiCywP//nl5GRyyUWMRKP1/YH8FDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mincore_swap() also fields migration/hwpoison entries (and shmem
swapin-error entries), which can exist on !CONFIG_SWAP builds when
CONFIG_MIGRATION or CONFIG_MEMORY_FAILURE is enabled.  The
!IS_ENABLED(CONFIG_SWAP) guard ran before the non-swap-entry early
return, so mincore_pte_range() can spuriously WARN and report these
pages nonresident on !CONFIG_SWAP kernels.

Move the guard below the non-swap-entry check so only true swap
entries trip the WARN, and migration/hwpoison entries take the
existing "uptodate / non-shmem" path.

Fixes: 1f2052755c15 ("mm/mincore: use a helper for checking the swap cache")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
This was discovered when working on PMD swap entry series
(https://lore.kernel.org/all/20260602142537.198755-1-usama.arif@linux.dev/)
---
 mm/mincore.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index e5d13eea9234..296f2e3922b5 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -64,11 +64,6 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
 	struct folio *folio = NULL;
 	unsigned char present = 0;
 
-	if (!IS_ENABLED(CONFIG_SWAP)) {
-		WARN_ON(1);
-		return 0;
-	}
-
 	/*
 	 * Shmem mapping may contain swapin error entries, which are
 	 * absent. Page table may contain migration or hwpoison
@@ -77,6 +72,11 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
 	if (!softleaf_is_swap(entry))
 		return !shmem;
 
+	if (!IS_ENABLED(CONFIG_SWAP)) {
+		WARN_ON(1);
+		return 0;
+	}
+
 	/*
 	 * Shmem mapping lookup is lockless, so we need to grab the swap
 	 * device. mincore page table walk locks the PTL, and the swap
-- 
2.52.0


