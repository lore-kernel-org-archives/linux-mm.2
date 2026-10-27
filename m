Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8AC4606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 00:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EQuEHoOJ
Received: by kanga.kvack.org (Postfix)
	id 9CBA06B05B0; Mon, 26 Oct 2026 20:22:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2BD6B05B2; Mon, 26 Oct 2026 20:22:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9026B05B3; Mon, 26 Oct 2026 20:22:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 475E66B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:22:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6125A8561
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:22:12 +0000 (UTC)
X-FDA: 85366504104.01.3340D49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id D5B3C140008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:22:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EQuEHoOJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf26.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793060530;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dj9hHvxNkjYtSpXBGFtHGe77J7NemQ/gBsneJ2zk6X0=;
	b=yzOmCJPdFt4EBgfM2sPJFVQiZK42SWzTMKFnoFJcYmk/L9Qc+jjYIM0v1l118aaqAtdcs0
	nmQN5yjSg0PbibsPLpaEOwDZfKlH4VN53iKid1J61V0Tp/RNiQu1Tjg8cpuo9f+xAaDBXf
	cnQe1YZJ5XIeZ/1pSD2/oO3jk9ectto=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EQuEHoOJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf26.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793060530;
	b=5MgRUva3cdwHAp7Olft2WIqOJjzoWAc1NwtGW9i690XsH1mxHdMS5H6J2FKL5gI3xkXjhG
	zQAP7128Rm0m53q6EfQ83VrNBonQInychm9gBT+9OaHTCaXMGDJwJmYEmWYxCoDDVMungc
	sOH+NIdwqASlUTcgb12bVbXhOf6y9Pg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A3FF600CB;
	Tue, 27 Oct 2026 00:22:10 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793060529;
	b=pmXLRoKJk4Kcxsjch1bsOP3li4OGc2B6mEUbuujizWc7Z/bI00ISOMRZh/+q0iQqVyyA
	 vxByluNHRT7+0cUIknvAVJV4vky0Navu4MdPeIViS5QZ0cdfVJxu+hUrC6lK11RVZg91A
	 00jSFfnDwSQFrLnVUfSS89PUDQR+tVuMCz5mJ0vcdXw1CVGXg8INXLFvdxjmHHkEnzkqa
	 dxS3VUxBamA/UBaDDaxdvPEAbxMOXhNYHhwK4c338l8dfbT6mqTov06ruJFzCdGo1LOEY
	 GWaOnHuCfsnEvcJbMlv1Vmn0V9LVA/iM7YXZV1D1aT6/Blx+fwX6UFVU7xA93glR1ZA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793060529;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=dj9hHvxNkjYtSpXBGFtHGe77J7NemQ/gBsneJ2zk6X0=;
	b=r2zGGJngxToUVKuCrn+e1WUoQRqtjoopoYnqgqBBrKmesG1P+WTN688GFJ3y+V48bany
	 +MGdEPXZnyOtLzcJNYBTB3Valeom2wiow8ZVEeyzCuM6SHTgzg60GRVf3ol8GedhKpd/7
	 5uqTz03t7uEPccVp1qdLFstz+EVzXDtPQR6QFI2jwyv215jC25n//mlFV1PTFerhgy0Li
	 gxPcK8Fy6+Ci+JwR5FPuuDQ1y1pT1D5XOGZWd0XmAphroqstllQ7gxog6Dyc5FVme/ywp
	 4kOJMSMK6QL0lFTHVydnOw4Pm8uIw0a/gZcHDUkVImqAPL9/Mpqyit9kG/gMuf6sAOg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1072B1F01825;
	Tue, 27 Oct 2026 00:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793060529;
	bh=dj9hHvxNkjYtSpXBGFtHGe77J7NemQ/gBsneJ2zk6X0=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=EQuEHoOJrBTqeJZYoBji7j6QC5XEFymna965i+o404L2Qb2A9oRxyfQ+W51PF1vTi
	 Y3QAyGUfxAXO/4eKghKFs9fPdXDji9Or3cpplzhg5EV+UjhQ6QVUVSHed6gICpFuPQ
	 eibpUHDjT+rWrvJ7ClIvd2Y2qOffRu/wIwhFMGGJp45J3dcmSPOTM8nY2lhFLLyeZC
	 RX8k6DowEEpv3Rdbu71Hw8olMtQS3v3tg38HhRQ/rDq03NKlKjMdcXjtBhuwudN8X/
	 ngEVQcJxgoRZALvX4wkMThPvtZCwtQC09E7OAtwCzAawmR6ZQkKWJiKpqDDKvpnTvl
	 tExzOMUqh1YWg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9485F44EFB;
	Tue, 27 Oct 2026 00:22:08 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Mon, 26 Oct 2026 20:22:08 -0400
Subject: [PATCH] mm/huge_memory: fix deferred split list corruption on
 partial unmap
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261026-thpsplit-careful-v1-1-d357d70fd6f4@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWM3QpAQBBGX0Vzbcuun+RV5II1GIltZ0nJuxtcf
 Bfnq3MuYPSEDFV0gceDmLZVQMcR2KldR1TUC4NJTKFlKkyO3UJB2dbjsC8q6U1m0zQ3pUYQzcl
 N55esm59572a04e3AfT9m52FudAAAAA==
X-Change-ID: 20261026-thpsplit-careful-0d24c335281e
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793060528; l=3512;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=pha4OdGyQ4NhPNP6DwAJZ4oCpNywbxpPmtNX7GrzxYg=;
 b=7VLNDgQ+nZmJUOOibAGbpRr7p9F168Ou6+p4nEc/G93b4pqw8pWPnPlMgvVFQTGz6iyrewo/L
 4GdrnZhQHbvD4bFiU5sRRUQ/3dA35CBBwyWMP1eXYox+kR2PP+Myazg
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D5B3C140008
X-Stat-Signature: kzqzwq6x6dwqccripj4rd9an9znikpeu
X-Spam-Status: No, score=-24.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793060530-26714
X-HE-Meta: U2FsdGVkX1+UJDjlGgl9wp3uY3Amcn2czuv5xTqO3RBfVm4+LOrw654Y0QjpmNnGm+C+QIk+BSw6OMu8zakF1dWgD9Aihq6y1v6/uzWXXZZC3nDa7SH9L8vDOB9kDdFYIY0NpzK6k7jegmbF9No0eSr9NjQNCPNK1ftcrgooJEuaLp17E3PY50kAkTmEwxJo1C4t5aR5tcvjRYIR1UyhZKvDLyAMuCJI/qmQ/aamCHt2ojJzc3Ee87Fco15c3SAwHVR6egIS/e9+1UQqTAJq75hoPlQIhhpxZYOmW20BN+0KIgcslAEqd6Kv7XHUroLngODyqyFJlEsdru+K8GHBxy+equG5uMe303NxubNKCjCjgkIgVT5cuUwdvWV9jGvrhxQr7Udqrp2frpu4lgOkuA2FxKZN5LJjITT8eXDX7G9zCOJ0ha/UuPewQg6yGi4B0OM+2xOWc9S/+gIPD20MDtBL18JyWDQS4vj+zbV+Man4hPRWhF3wUnHy+q05KZy0lcaSc+fcmohv2Q9X0h8h7XOtqys5PSjcrYVB7/D9+tWd+ncG1QprAqihQ/E/ibfzUyqIY6tiiF6B5Dvgmj4j/kMTuhqdlkP8g66UPhe81A2zs7n8a0UT8iJXKB914vqzL1CvZgcZ2JhrLT46c0Ydl2NTgaxPEsIYw1Ga5cyKlLk/mGsiQ3OzUtUizBXElnpet2j7n436C9LdDyBE880Qa+kPUq/oAsJ4ULz9jLRA/m04hWKqkILnFBqHy70wi8rU8pqeq61S/LIzU4/LkKnTSIeMvNK3ATYE+XR3GTnbHeTUbbOtjYDApYeFAde/MJ5ka4m+VOMSFowY+qdzeTeUv0fuq02ITOqGzy6GPKx6b6u+gz9xTpsOXWP0nZXSsMhe66AJlejbn0Pra/idHejki4ALk8UH/SKaS6keV2LTQDvMdHFGjoc+1oQR4zxlgW1zIRwvJqYb6vk4xbWD2/3
 nxib2Cff
 yAtD9ogNelOskyfML+e7fY6zC/9eGz0RKZ1qRr51dqUAAE9yh/GTKBDDEo+GQ0z2WLKXoJNRi9kTfTyXzcaN0N06eGxNhz/OF6/KxPwVRIUk1gzqEhYPATbQqSIGjquhfIzLWTMzOdKuKNM7a0zQHFrorLZvCpa1Ie86YMBpmx438kFTO0lVXqMAeM3jJOkfKTdNEFzs7absBoTUK3xrB1IPYEJ+c0dr/vhpLYtzW21bJ8JnmTkimcUPyD8XTAyPyDWfNX1OTB7N/DuyjTPZMay1zqKxkyuwp/BcBbQcKlygA0lpnqp3ckl+oemnMjM3zIj20EgHSWkigJ5QZGVgRuI1n1mgyzrVVmaQHudkWVbmACMlfOosbji0/QFXQpisGlierqoD3L9gLPG2OZ0CMiMCCGcJqaLtcI89/Keq5mazv0FspeO/GGC/ZzS4zGYcC7aeHdxpRX/s22cL3ggfgBEagkp5PkV6kmvcxbrTa29LZd00J7o9BrJUi5ByzbPdX17ziUeqfSzlzHYlxtDWxww2W0uRbCvKTPjr2kVnYYnjo15Vc1T8xyqwvDwqmSauzHT3I57c3Pu4uo2Qm2H0aB/So4LmkWb+rjR+o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mani Tofigh <mt4022@columbia.edu>

When a THP is partially unmapped while the deferred split shrinker is
scanning it, the deferred split list can end up corrupted.  With
CONFIG_DEBUG_LIST, freeing the folio later reports:

  [  523.871401] list_del corruption. prev->next should be ffd40000005e0090, but was ffd4000000500090. (prev=ffd40000005e0090)
  [  523.871412] WARNING: lib/list_debug.c:62 at __list_del_entry_valid_or_report+0x177/0x220, CPU#0: thpsplit/63
  ...
  [  523.900715] Call Trace:
  [  523.901753]  __list_lru_del+0x5f/0x220
  [  523.902588]  __folio_unqueue_deferred_split+0x238/0x520
  ...

Without CONFIG_DEBUG_LIST, the list is left pointing at the folio
after it has been freed.

Since commit fafaeceb89a5 ("mm: switch deferred split shrinker to
list_lru"), deferred_split_scan() moves the folios it scans onto a
private list under the list_lru lock, drops the lock, and then removes
each folio from that list with list_del_init(), which sets
entry->next = entry and then entry->prev = entry.  Another task may
in the meantime partially unmap the same folio and call
deferred_split_folio(), which queues it only if list_empty() reports
it as not queued, and list_empty() reads only entry->next.  If that
happens between the two stores, the folio is queued again, and the
store to entry->prev that follows breaks the new link:

  Task A (shrinker)                     Task B (partial unmap)
  -----------------                     ----------------------
  list_del_init(entry)
    entry->next = entry
                                        deferred_split_folio()
                                          list_empty(entry) is true
                                          list_add_tail(entry)
    entry->prev = entry
    /* overwrites the prev link that
       list_add_tail() just set */

Use list_del_init_careful() instead.  It sets entry->prev first and
then entry->next with smp_store_release(), so once list_empty() sees
the entry as empty, the shrinker has finished writing to it.

The reproducer repeatedly faults in THPs and partially unmaps them
while the deferred split shrinker, run through
/proc/sys/vm/drop_caches on the same CPU, is scanning them.  This bug
was found and replayed using a deterministic hypervisor currently
under development, but the non-deterministic C reproducer can
typically trigger it in the 10-500s time range.  With the fix, nothing
is triggered after 1800 seconds.

Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
Reproducer: https://github.com/manitofigh/thpsplit-repro/blob/main/thpsplit.c
---
 mm/huge_memory.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1e5d68acf62a..f4f7d757a310 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4668,7 +4668,11 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 		bool did_split = false;
 		bool underused = false;
 
-		list_del_init(&folio->_deferred_list);
+		/*
+		 * deferred_split_folio() may queue the folio again as soon as
+		 * list_empty() in __list_lru_add() sees it empty.
+		 */
+		list_del_init_careful(&folio->_deferred_list);
 
 		if (!folio_test_partially_mapped(folio)) {
 			/*

---
base-commit: e9011a65d78258901ba123c5f522bef26d29902f
change-id: 20261026-thpsplit-careful-0d24c335281e

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>



