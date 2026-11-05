Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DD77606A33A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GtyV4/Mu
Received: by kanga.kvack.org (Postfix)
	id D4D846B05D9; Thu,  5 Nov 2026 13:42:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D25DE6B05DA; Thu,  5 Nov 2026 13:42:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC5D6B05DB; Thu,  5 Nov 2026 13:42:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CC896B05D9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:42:01 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 39D1D1C4487
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:42:01 +0000 (UTC)
X-FDA: 85401934842.20.A67561A
Received: from mta0.migadu.com (out-10.mta0.migadu.com [91.218.175.10])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5A7DE2000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GtyV4/Mu";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.10 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EE1sb551x27Ej5Fjzi9j3H+2qleA12aesnVZEQWHbOY=;
	b=OUK6E8hGm4J6ahB3alQZXqhyfb9fQLDx6PupDVqFoUrY0wV0hLFiPEThGLIUnrCdwwYORB
	D0mHWiVX0zIM83CBNZPjjTIgY3gRMoTEKgvFGH17JcDlLnmnH/GoYGXveuCFvGrZ0iRGHj
	lio3xA+KNiml2My/QgnViGFPy3oc5oQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904119;
	b=e5cwm/9Oc/yQbPUhYwzrgR/5aVsnScw6L9f1NpcKK4CSGxUnTerBg3vAQ6baB2qeezArHC
	E2jJDG4NBz4GV/XIVjAKMpOlKQfvPFSf1uFvNp9t1NthPmQCrY5zFtrQi8KzD2Gx+utR47
	VHIp2iNDvX832Nmkz2no44aDvyxBCBw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GtyV4/Mu";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.10 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bhr39nNBlSP/jhuooBjvFn5uupn8bYHVVZDQyyfyBlM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904118; v=1; x=1794508918;
 b=GtyV4/MuKeVj46VrcoQ5xUjXP3XeFxeYMuIrS8xo4cZQdC6XoF77FcKAGcIBprrgIh5XilHP
 nWMpWO12XOvVofZrQGldNmtvLODwpy6ITHeHwAZvhvhdlF5i3ofwpuPM3rDNGkq/D4CPlHiTOzk
 72+lX0a0VuLtt5U5gP2bv+X8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id c4e779a46879f223;
	Thu, 05 Nov 2026 18:41:58 +0000
X-Mizu-Trace-ID: c4e779a46879f223
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
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v9 23/32] mm/madvise: skip PMD swap entries for MADV_COLD and MADV_PAGEOUT
Date: Thu,  5 Nov 2026 10:39:07 -0800
Message-ID: <20261105183940.2236717-24-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7o7joz4xri41crq5r18jj65dfezwp5ys
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5A7DE2000A
X-HE-Tag: 1793904119-730372
X-HE-Meta: U2FsdGVkX18d9QuyAv50G1dBzsOe4teLoqtiv5Iv+cpbSsZ/Ad3T1aptFQRqLO2vN9JHYHnX4b7YGzrk8tjJUlVMLEseWp8Yne3vIH2siFrSLntn8P4APdBfRiZxsUID/Agwl+JH/4gI+yQr9iyetP2ziwjQ0Aai8yQ4peuz3Sj2aldU0AWz3QoRyo1oS4v/POQOkPNrW4tf5Vk1bQ/TdlWMKTQeOuPS9qGNiZtSmk1QmeWLrGl5bGaK6YHVSlXREaJMIkR/bk9NgmaAbeoClNPZWFkPhF5Ov/vCyDdNLImhrmyCMPgwRL9sXjz7COAeaChd51gCCFX4F6IAlGPHVcugkLleZGyIwKCJXujtcTgS9Pjn4UWBssYYBmo08iu1oT/w5mxhe5dyM9AyX1ojR21cvn7h3P+YlfLNFvAaxQm899nirf7SBq21aloj90jlff2hGOSVUsiFBXr9aCVBuMTAqeb8ORplvTcGX9WmWH8o5SfsnNwAzqJ/+yVUBVdk6ps0tvUaBe54fatoS4mw0NPksO9fpxR+dAj0ucMSc5DX87M2nN0o9S6Zb5Kks5rAdmj5a7GNxvxV0oS+fNfsZ2ACKRBTHmoCMIH5btk4ZvDflnNvlrX0H1g6SSZTFTfPf8taENGdFZKRzkBtEu+AWeczOpYWB8WuLkjPY6/MicjkZ4kApd0NCJ1upuGhjSqysycdVAyJItQZdTUbbAjOIT2YsopSishT41lilbOR0PY47i36ss60aygf0xTsSdc/VhIQ5fiyKdl83+Jw1cW9I8yzm4TUvzz8K/XR0XZLEfuFTNDZJoQi+2rLCf4o9c5JJy5c+0fxa6+ok2Ar3wCZg70bcGCFBJtHuDISFScFRQG4/+YAkWjUenPMVLgPVeoazBXa2rVQimcrXIsBKuCX9JXgExdmhApAuTGw39ZyTI/rBjNRRoV3rbpzpmjzaBMxjQymiWrhujeyFIKp2WG
 1Xamn3Bc
 M3pf9g6zQEijp1pnKneVzTOxo2lwWE3w7DBtOBWRoWjG2mgUgp+7LmFTPxQjpkRL9rlHdqHkYhVrjCXi2li2B/8+byIxlMs55DO526pnFF6y6ac43jTiTrFrHvaIzOYymcz35yrfhXwSDFqfarbDR8NffTz2U+tePWjEQsJwZDhZKDsVmtVhxXuWSAsnR8PWbrfKyaU8xzL4N02tulUNzo2aBD/jErSG1vFwRAxUzzymSHZMgNN8VT925CC3NhboaWC2WZRExgT8t+vng7JFook2Yag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A swapped-out THP has no resident folio to deactivate or reclaim, which is
also the conclusion the PTE path reaches when it walks the swap entries and
skips every one.

madvise_cold_or_pageout_pte_range() gets there the long way round:
pmd_trans_huge() is false for a PMD swap entry, so it falls out of the huge
branch and tries to map a PTE table that a non-present PMD does not have.

The entry can also appear after that first, lockless test, so re-check
under the PMD lock; otherwise a PMD that turned into a swap entry while
pmd_trans_huge_lock() was being taken trips the VM_WARN_ON_ONCE() that
expects a migration or device-private entry.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/madvise.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 156290227c236..576707e303cf2 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -384,6 +384,15 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 					!can_do_file_pageout(vma);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	/*
+	 * Swapped-out THPs have no resident folio to deactivate or reclaim.
+	 * Avoid descending into or splitting a PMD swap entry.
+	 */
+	if (pmd_is_swap_entry(*pmd)) {
+		walk->action = ACTION_CONTINUE;
+		return 0;
+	}
+
 	if (pmd_trans_huge(*pmd)) {
 		pmd_t orig_pmd;
 		unsigned long next = pmd_addr_end(addr, end);
@@ -394,6 +403,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			return 0;
 
 		orig_pmd = *pmd;
+		if (pmd_is_swap_entry(orig_pmd))
+			goto huge_unlock;
+
 		if (unlikely(!pmd_present(orig_pmd))) {
 			VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
 					!pmd_is_device_private_entry(orig_pmd));
-- 
2.53.0-Meta


