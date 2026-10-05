Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA119CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 22:27:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 569006B0088; Mon,  5 Oct 2026 18:27:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519FD6B008C; Mon,  5 Oct 2026 18:27:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407F36B0092; Mon,  5 Oct 2026 18:27:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 163B26B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 18:27:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3926804C8
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 22:27:38 +0000 (UTC)
X-FDA: 85290010596.21.F4F9D1C
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf13.hostedemail.com (Postfix) with ESMTP id EB90F2000A
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 22:27:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cWfKWAVk;
	spf=pass (imf13.hostedemail.com: domain of serapheimd@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=serapheimd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791239256;
	b=dP130VjZp/lqCwcFsjdDm0aNraaB5HwE1UiR+BnQVWhtn3zBeeVoorZ46fR/AEn38wgijk
	tkv5P40c/jTBWrKrcR0ShPpW68z2fkUZOS3mrxwTf5Kbtuxxo7Qorj2GQqgkighmrWq63v
	qAYht7FVbP7rFd5wLjlHsiP8eVPyWaA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cWfKWAVk;
	spf=pass (imf13.hostedemail.com: domain of serapheimd@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=serapheimd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791239256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5SXfZIcVyEClMhDE1K+HuTBhEkNW/aofeMzBlGv0E5U=;
	b=ptFy2pPnxdzDL6MwiVGk/1MW2BOcIbmdWW/WEsn3VVUPQ9PnxL8yBGDDF7NY1j7dD7ps3S
	rXiR4BomDlL1GqWcdrifEe8OvXyvNICICQlmxLaJSdv3SCD46QHxriwZphZmKjh51YZdKa
	+os//PNWZU+Chdu/Ki6yQ3gg9w/KXB8=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccf3ca626so14994365e9.0
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 15:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791239255; x=1791844055; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5SXfZIcVyEClMhDE1K+HuTBhEkNW/aofeMzBlGv0E5U=;
        b=cWfKWAVkxhDOBTPg8cJ/TTNDbsPf9J27B0a1A4quOBm55rDWRaFhxhBKBaBZXKg9OF
         xtL236VR4gqR08Lr8D71wR+9SzOI3a4msKSGqTVe+dpcNfkA+oqzNWZhPLxk987ycuVg
         qKISadS12w47njnZCRXRCy9L0zZGXy0hXXuZ7ab8o/qisyS3k32MrfSwumZgiMqMN/wa
         r6BOq/xJoLsYqOq8Rb1lkYT0hKtgnLXVMf0gYA4O++pPwJ260Rre53k7t5YeAW53lBEO
         3IbYCaT95kIr01KDlCuI9t3IXdtq8TMh6UpEfIrGM7o3X7JxtYzWHMGB/IsH0GjLXDvb
         sNGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791239255; x=1791844055;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=5SXfZIcVyEClMhDE1K+HuTBhEkNW/aofeMzBlGv0E5U=;
        b=Dn7jXuYsHvkao9w+3BU+vTts3LjBzp0Z2R1jnXQZaYm99jMPWUHEA3RxMPHHC5clTS
         SM9ax+/L4+14CTj3EXRrrOybSRzizhnlFoKvLR3VDpnGiGMSaSWWpq3V+lTqaANpGYjj
         x7ddVKmfTe4uOoi7XIuN/v6UTES1nDaGtV5CLNKA0zfF3005jP0JbAQijgXBNc8C+5s3
         8limqPPCRItog9/ZdFER5b0rXBVNLcN46KrUCNkN5fyhd50aojTvtqlslvlSbWH/XShS
         kN2fx/eCPuBiURx14NtblYJLk7XBSc7sHb5GX0Ybu6K/MxHWsvUJEID5IdCC1mbGkDgi
         dHcg==
X-Forwarded-Encrypted: i=1; AKwUvBwn4acREHibU8zVHYTV8cT8pT2Kq5DVDXYG3R9N/g6v/R5oZ4itEINHqqbTUfhkMujCxbzG6OIGEw==@kvack.org
X-Gm-Message-State: AFuF++m9s0OeRqhyRG4RujSEfU9a4llbiEJz+ev6sLAgi8/NmJXCVV1x
	FGWWCiRQmmYIhlp+Tb7GYsnnRNkCTfdHDwuUJ5dJVuBw1JB8RV8s+neb
X-Gm-Gg: AYBFou3+AGJ8GhFC+v1fhNppMxCP7qSgdNEaSvWp47wCzbSJDmw1YPD2LmZjOgL6wJD
	ZqE5k33nAqTlNeyj42krpN9F/MSCWahNjR/PB0l9mueqZNKNnz3ASUIOycY9n1+EfD1VCWx6GC6
	NnVJ96fySx5y/yVPjVArRHYH9r9UamScVZfezAUSkPk9j6cYAe1sXg/G9SuMno26BHLJV6YKkxI
	nRhHK0Lnf5LLbtC1T/u3pnsfEse7Lob9Us1o6st+l811H9iCp/0yxeblYgfV3GJan+HMPPXfktf
	x/olUTocI8o5kL095+pqy8h+NeSV2fScZ7P1xfkbeVPnMKvrCk2oyv+9wvin/ubeX6H0XlycdCy
	kIBg6GuNjDusuXpp3zukDlHQU/rAojrSqlG2A41lOMY4ZdjZJv8OIxOlI83HzrLPFQxMoNkLuC3
	8XNAIMVXKggRRJAMm5rpOcWyPBKzVUT1P9GZqGVaAN1VyDlMzcior3UsZItMUCOZqbKOPI89J64
	UR4tYIHWxzjyYFtCVn6UTxB6qC7hJRaI7VI4bAGGdqrpi24AQWe1cam
X-Received: by 2002:a05:600c:500d:b0:4a0:1fe2:d4f1 with SMTP id 5b1f17b1804b1-4a027598d25mr205495365e9.28.1791239255321;
        Mon, 05 Oct 2026 15:27:35 -0700 (PDT)
Received: from [127.0.0.1] (230-197.cgnat.interconnect.cz. [185.100.197.230])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a178ca8127sm22346505e9.2.2026.10.05.15.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 15:27:34 -0700 (PDT)
From: Serapheim Dimitropoulos <serapheimd@gmail.com>
Date: Tue, 06 Oct 2026 00:27:19 +0200
Subject: [PATCH] mm/fadvise: skip remote LRU drains for ineligible folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261006-fadvise-lru-drain-v1-1-1e8fcf785057@coreweave.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/zWM3QrCMAxGX2Xk2kA3qFNfRbxIm9QFXJUUf2Ds3
 c0ELw/f+c4CTUylwalbwOSlTe/Vod91kCeqV0FlZxjCsO9DiFiI3RK82RPZSCtyTGMcDzEfC4P
 /HiZFP7/m+eKcyPVkVPO0lf6BecYqb9xWWNcvcckmt4kAAAA=
X-Change-ID: 20261005-fadvise-lru-drain-d5b75785c9fd
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 fujunjie <fujunjie1@qq.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Serapheim Dimitropoulos <sdimitropoulos@coreweave.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791239254; l=5993;
 i=sdimitropoulos@coreweave.com; s=20260302; h=from:subject:message-id;
 bh=xmcmt8qXwptEfsyFlOCeswfoPaIK18LLe7PFw9b7oko=;
 b=8JZENOLol5hUT5cGN3YqxX7QkVDB5zAe5dpkpMG2uXqc4lG2duh9g5NZhyWgANCUN8PrGIWJF
 4WgauIv7721BCMC2ZhtIV6uX6rMsh6Jpp5xaAPFxEMyagD6cFoqsg9h
X-Developer-Key: i=sdimitropoulos@coreweave.com; a=ed25519;
 pk=Qysvg7jaTIU0posaYFtqa5SKJlFwqzil4X0U1p1zo/g=
X-Stat-Signature: rdh7kbmf7n747gt7ojsgr44b4roaqrxr
X-Rspamd-Queue-Id: EB90F2000A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791239256-875160
X-HE-Meta: U2FsdGVkX19Zg0duhQVuo8IF9F+hdFfFYKQ2QaG6Uba6icE81JWk6MP1gvKI1vkqpi5d9gpwFcPV29zR4lTXDsQ1nrJNf51ZE3xo/gosQEl0RU2ouhKGgVdEH2EpPzwZqncFJbASMgXeOuAE3qzmljsgeGRe3GxHHjdErx0XPck1iY87hVsqWL0rgG05LKXdu3Tv4oGyKG1Lj7SV27slwaxT34OLpoUtmBd6CKOqPb46ocISG8HJNRfbAg31avFjEc+0mAyay8LAIRCVcO+u5ONrHYBrPzJirXoJTo8UyvQ6iRYTAQpFvNDc0qVLEOw3sY4qxyhoSvuFTvLVnpCOK9IYLq2XWVlEZqdBN0sR04ETVI+CjxMSRoWwaRJoWGVMtj4ofJF2krxxx7rObnLOfOR2Bv+p4Mvu6GiunSdEPGXJ/LOBud4/cLx4Zd1q2QTJS8pWxDpbjG6fdKWcem0gJ6YNdYZ6+geptelxLAUy4M3a8dns0lngwu9ypIUEFWAJ+GNL0drjXvi9OLwk+ranzDGHGUVQBcCYjeP4lWcfiOgQ9ne7h6y+nJFBhA+9Hr/vD3QMRnHn36pyhkMaryCgfoX5LOEnKs1dVr1F77TPFJJF380TWWEM54S/jt3jfuFcN01amFh5ZMnmDAeUjW9LvCzeP+962jxxHDdMS1JwAm0m4h9mUkApgd9NC4EK0mUBu8TXaGiP5527hEN5Ag0gerHCP6N3Q6LUUEj1ID2JIqJRtFoU1wLkClWqkuaXlX7JGESTwgICLM5IcCMiN4Lon+5kf+xJrcc9jTi/KQqJU6jYE3SsR3KAviPK38crEH68l8uuu8P1U2AXCIkARAKmzyMoJhMb2gBMs81UxTt3NbNl5pq2sBqZUk5Urn8P3m4qmeQpSbCDiqdV5EJoqSb4U6bV0C7kt7Q5umtLZrS/N5aPRpBb48LCDKTjY8r6kqXRHkcPqODJIQQgrk1gXIS
 otgWK331
 Jqkw7VaB4p6BlRldf5DWLUhDo0ZJFJWu0JRtZr9l1vVHaHgjLzH231mC8YsKqnrfSCMTnLeYcGr9OZLL938Lmsz5ReROSJmbJWFV/NsaOm5/4ZkjPNswEG624g3gRBWInT+rZnN1+sWPFHM/aNKvrR1VjBT9imczas9fdJ18SnuB2X/SDvOIA6+CN5bGI6mZy3pVApuEeB9tf4rzEFrVX/OraIJVyn3ngyoziFxYIq4KN9lxlk9n153Ka4hlfD/35Wobk4LU++g42JSRMUJF6LDBMuDSPqcpyhELE0wHrCeaj/SfJQuxRTFogVK3HzMWLY3mITM6cPTV08zXpw7wQT8V+3NSPKd2Wd8UmZMeSjW31+a1Bhg/yjpdNVKpgUK4cdHJUwdbSYs9J6FFgC4F2RbLGG7tus6LGMmErXcUS1vRxA8PwT0slIbtfGzww0XJuLX2eilnBLfCLPjGuYmGb2VbOmGp9mjCts4Obbn4GJHOvmC0KTtmybzCeWpURW0bb0N/u3mPUacn/d6fLjYacHUBNWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Serapheim Dimitropoulos <sdimitropoulos@coreweave.com>

POSIX_FADV_DONTNEED retries invalidation after a global LRU drain whenever
mapping_try_invalidate() reports a failed eviction. This includes failures
for mapped, dirty or writeback folios, which dropping LRU batch references
cannot make evictable while those conditions persist.

Filter those failures in mapping_try_invalidate(), while the folio is still
locked and before deactivation can enqueue another batch reference. Leave
mapping_evict_folio() and its eviction safety checks unchanged.

Use a boolean retry flag instead of a failure count: generic_fadvise() only
needs to decide whether to drain and retry once. This remains a heuristic,
not a test for remote LRU references. Preserve the retry for other failures
on clean, unmapped folios, including failures from filemap_release_folio()
and remove_mapping(), rather than limiting it to the early refcount check.

This follows the problem identified in fujunjie's earlier proposal, with
the filtering kept in mapping_try_invalidate() and a conservative fallback
for other eviction failures.

Link: https://lkml.rescloud.iu.edu/2605.0/07547.html
Link: https://lkml.iu.edu/2605.1/03284.html
Link: https://lkml.iu.edu/2605.1/03732.html
Signed-off-by: Serapheim Dimitropoulos <sdimitropoulos@coreweave.com>
---
Tested baseline and patched kernels in QEMU on ext4, XFS and OverlayFS.
For clean mapped files on each filesystem, 32 POSIX_FADV_DONTNEED calls
produced 32 lru_add_drain_all() calls before the patch and none afterwards.
A separate dirty, unmapped test using ext4 data=journal showed the same
reduction.

Cross-CPU and mixed-range tests confirmed that clean, unmapped folios were
still evicted and the global-drain fallback remained available. Writeback
and concurrent pwrite/mmap/fadvise tests also passed, with file contents
verified after fsync, eviction and refault.

Skipping the retry can miss opportunistic eviction if a folio becomes
eligible immediately afterwards; POSIX_FADV_DONTNEED remains advisory.
---
 mm/fadvise.c  | 12 ++++++------
 mm/internal.h |  2 +-
 mm/truncate.c | 22 +++++++++++++---------
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/mm/fadvise.c b/mm/fadvise.c
index b63fe2141..daf655846 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -141,7 +141,7 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 		}
 
 		if (end_index >= start_index) {
-			unsigned long nr_failed = 0;
+			bool need_drain = false;
 
 			/*
 			 * It's common to FADV_DONTNEED right after
@@ -155,14 +155,14 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 			lru_add_drain();
 
 			mapping_try_invalidate(mapping, start_index, end_index,
-					&nr_failed);
+					&need_drain);
 
 			/*
-			 * The failures may be due to the folio being
-			 * in the LRU cache of a remote CPU. Drain all
-			 * caches and try again.
+			 * Clean, unmapped folios may still have references in
+			 * remote LRU batches. Drain and retry only if a failure
+			 * might be resolved by dropping those references.
 			 */
-			if (nr_failed) {
+			if (need_drain) {
 				lru_add_drain_all();
 				invalidate_mapping_pages(mapping, start_index,
 						end_index);
diff --git a/mm/internal.h b/mm/internal.h
index 0ca863f26..1637d4275 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -628,7 +628,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 		loff_t lend, pgoff_t *pstart, pgoff_t *pend);
 long mapping_evict_folio(struct address_space *mapping, struct folio *folio);
 unsigned long mapping_try_invalidate(struct address_space *mapping,
-		pgoff_t start, pgoff_t end, unsigned long *nr_failed);
+		pgoff_t start, pgoff_t end, bool *need_drain);
 
 /**
  * folio_evictable - Test whether a folio is evictable.
diff --git a/mm/truncate.c b/mm/truncate.c
index 5b1b13cf8..42b6a1b63 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -567,13 +567,14 @@ EXPORT_SYMBOL(truncate_inode_pages_final);
  * @mapping: the address_space which holds the folios to invalidate
  * @start: the offset 'from' which to invalidate
  * @end: the offset 'to' which to invalidate (inclusive)
- * @nr_failed: How many folio invalidations failed
+ * @need_drain: Optional flag, set if a remote LRU drain may help eviction
  *
- * This function is similar to invalidate_mapping_pages(), except that it
- * returns the number of folios which could not be evicted in @nr_failed.
+ * This function is similar to invalidate_mapping_pages(), except that it can
+ * indicate whether a remote LRU drain may allow a failed eviction to succeed.
+ * Callers using @need_drain must initialize it to false before the first call.
  */
 unsigned long mapping_try_invalidate(struct address_space *mapping,
-		pgoff_t start, pgoff_t end, unsigned long *nr_failed)
+		pgoff_t start, pgoff_t end, bool *need_drain)
 {
 	pgoff_t indices[FOLIO_BATCH_SIZE];
 	struct folio_batch fbatch;
@@ -599,17 +600,20 @@ unsigned long mapping_try_invalidate(struct address_space *mapping,
 			}
 
 			ret = mapping_evict_folio(mapping, folio);
+			/*
+			 * Draining LRU batches cannot unmap a folio or clean it.
+			 * Other failures may be due to remote batch references.
+			 */
+			if (!ret && need_drain && !folio_mapped(folio) &&
+			    !folio_test_dirty(folio) && !folio_test_writeback(folio))
+				*need_drain = true;
 			folio_unlock(folio);
 			/*
 			 * Invalidation is a hint that the folio is no longer
 			 * of interest and try to speed up its reclaim.
 			 */
-			if (!ret) {
+			if (!ret)
 				deactivate_file_folio(folio);
-				/* Likely in the lru cache of a remote CPU */
-				if (nr_failed)
-					(*nr_failed)++;
-			}
 			count += ret;
 		}
 

---
base-commit: 0aaec43576cd41474a8e90c919631c0c9fc88417
change-id: 20261005-fadvise-lru-drain-d5b75785c9fd

Best regards,
-- 
Serapheim Dimitropoulos <sdimitropoulos@coreweave.com>


