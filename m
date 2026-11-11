Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8FBD606A88F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FYJ36vzk
Received: by kanga.kvack.org (Postfix)
	id E509A6B05CF; Wed, 11 Nov 2026 06:39:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01006B05D4; Wed, 11 Nov 2026 06:39:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E8F6B05CF; Wed, 11 Nov 2026 06:39:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A256A6B05CF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:39:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38FC0C02AB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:39:29 +0000 (UTC)
X-FDA: 85422642858.30.BB9A3B3
Received: from mta0.migadu.com (out-166.mta0.migadu.com [91.218.175.166])
	by imf31.hostedemail.com (Postfix) with ESMTP id 499B020005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:39:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FYJ36vzk;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.166 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794397167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ss6GPqajhnLoAGvpkwWgAL30Fbn2tVqWEm0t1Mamd/I=;
	b=0u3MHg3AILY/hnm25gm30teqiUjFp00mywRlgpz2qCCeIkEZ+U2Bqlfl21lTSKtP5uZkiE
	mWDGNcMRLBS5e80Ta88TtjQDLQZo1s/iiETvlJdMZ4NSTjO2xY6ONcBq7sVOMnuuxEVh/u
	yNxnB/EYltxPRyEsxJkErqtO5uI9omI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794397167;
	b=0jTEZkQe7W0TcY2/zzsRYH01SCBCECs9cmi6PNymuRPzYj6Z6dktM5mEubdUZc3U2Nd0YJ
	54IGLkGYLkvvrFWRLCTdzJULeA12Z2AbsUBoY3/SmU+6n2haFGkrTlzp/4yBdVsEkC5O5a
	pWIgKP6MCts5nUSd3Hwji9y69Kq/w3s=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FYJ36vzk;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.166 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PxRmG2FWyo+pFqNDGwdneDF6Wr5yBgEA/EARM77L5Wg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794397165; v=1; x=1795001965;
 b=FYJ36vzksOCCsexC4Nfc0EjBeGRz02DN2aWs5F+SXhhYb1uihrcW4LnX6Z7s7sylG5IMBCBm
 bHF7fJg2UO01tXG8ZRmWqkalW06PF9jYozU3pm4rIsnaV0yGASbqMBLttquRoIJ+iGyHLzqA8Np
 fG5mN9dypHX+/kIKrEZ8vrgc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 997e08426fbd59bb;
	Wed, 11 Nov 2026 11:39:25 +0000
X-Mizu-Trace-ID: 997e08426fbd59bb
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	liam@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: Usama Arif <usama.arif@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH 3/3] fs/proc/task_mmu: account device-private PMDs as present in smaps
Date: Wed, 11 Nov 2026 03:38:31 -0800
Message-ID: <20261111113904.650722-4-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111113904.650722-1-usama.arif@linux.dev>
References: <20261111113904.650722-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t7x5xn9sbfuro1tncb7rxengu8epsmhw
X-Rspamd-Queue-Id: 499B020005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794397167-110107
X-HE-Meta: U2FsdGVkX18UJqznoTj/zsQVI6hK3slqLrywNgb6LaLyzOCqI/gsbdEqhGhkeP0d/Cr9j8WaRadFREmddpTaPd0UVKiwlRK+aRRv4iXW1Hz/LMWCg7E9+sg9n3TxITn+K5w5/l97xdCnLbLA1oSoxsgkJYsz1DGOofVubWvWtxXvPPntol+x0YFcJDidlpiFAcHW4I6lD/7EvB/vxGjrK8r1OfX+Rvvq49D9QW8S8fOK4WazAlH7Pdbp6Bvo+SgbDQbp75P/WCwXVeWjfn88ONhqPUB5zP2ZqlkKgE4RMv8ms9FE2fBOSzAOv7Pho3MP3d4M7dHb0EaBwlsWV+AMw/QIn5guLCnd+HDoXUdy9Axq+Y0sumpfqM8LDAANkbvk+rpo1Oidc09Pe6ypzBqS6JyOyuQ+T3/vw0FbA4jgWUCe9dwb1fsmn0VUvy7Z1Rn3c086D8+pCF0aS/DuWtE0tDYa+d2JwYBCcVd731xF0vjONGA+9VXoImnm/wHwGH+GPLHX2wVZ9Akw8BRCtZbiQ9gFxCeKXfRg9AIPE5NGH5Zqj7+ZxTQ9BwnjUHmlcJndkYEkQPFRawmSWZXz365D/zOH9fwruidSxZJLN7DIMnK3gSvQhyl3E9o3xY4/KD1rLQ6UVqOpFd5/2QooyUKVZiMyVk3E6aLYWdJ9HiFeJmxDYyObUB7uYFpUdANO2ULGBuot7JfUhG5EGJISYVdBt0ytLS4vKZZLXSR+MWhnONEUg/87v6cFTZcIzyi+c7Axdg+V+t0HgPNvZl5NaHP3bDATZJ58top9h5f8KFHmKAye9Eym0LQWOahY55wJp18abWPbVxIYo3voePYyCeYmpBkvHzBMfQ3aVttVFUMXMMrrrFlDG3g4JorXluKfaJSIb2HcqENz1fi4xWboAKBWx0guQAfdRUL0aZ0/OIpddlzp9obPbaZzuUDbewnzrkEF4p6l4EY5gQb0UnLrcI7
 E17HXTjp
 5yQN/8VMODgpYeF3oeYj1tVxyGiIWUl73/S81FPeiBmDEmCCEBxisySFeQ+wqnIletBQg109z1b4ltt9QATT7HqSVsQVbniwGBMY/EFFLAE4Pcry5pxzaUwcrBOHgoSVRQ4a54YB2yJZTbnCcxln4/R+3SVeiYf5X0m3+m/GcB5LDCZnIVrjEE/H/CLgYpwUShvICfHRWsVVlYXvUaBYV7c9eCpI3kXOhCv49VwzYiDNL5d56NMEKWfsIT/GexbAYRuEq2p1I+IELsRJZh3320V6cbAPmHDG0YB7+54NKDlmpK/xa/k011dRSb4p85VFHxCWtbB+oMGQwfxx1EnAB2wzLNbSamjJ6vjIjlthmT7lIbI+IsVvb9xBSxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Device-private PMDs represent mapped pages, but smaps_pmd_entry()
passes present=false to smaps_account(). That treats them like migration
entries: mapcounts are ignored, PSS is charged in full, and exclusive
mappings are accounted as shared.

Match smaps_pte_entry() and mark device-private PMDs as present so
smaps_account() uses mapcounts for PSS and private/shared accounting.

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Cc: stable@vger.kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/proc/task_mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index c0d391186c2b8..ad97532fc1184 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1032,8 +1032,11 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	} else if (unlikely(thp_migration_supported())) {
 		const softleaf_t entry = softleaf_from_pmd(*pmd);
 
-		if (softleaf_has_pfn(entry))
+		if (softleaf_has_pfn(entry)) {
+			if (softleaf_is_device_private(entry))
+				present = true;
 			page = softleaf_to_page(entry);
+		}
 	}
 	if (IS_ERR_OR_NULL(page))
 		return;
-- 
2.53.0-Meta


