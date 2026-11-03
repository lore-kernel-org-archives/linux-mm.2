Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 297AD606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 04:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TZmV1AZg
Received: by kanga.kvack.org (Postfix)
	id 2939D6B05B6; Mon,  2 Nov 2026 23:22:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2438F6B05B9; Mon,  2 Nov 2026 23:22:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1356F6B05BC; Mon,  2 Nov 2026 23:22:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D47F36B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:22:24 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21C31160336
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:22:24 +0000 (UTC)
X-FDA: 85392511008.21.578CAEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id E947A40002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:22:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TZmV1AZg;
	spf=pass (imf12.hostedemail.com: domain of devnull+daejun7.park.samsung.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+daejun7.park.samsung.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793679742;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VtT86yEYiO4k9pYnwKVFQUHi1JvkR5cEoQoLjpTBlcs=;
	b=Q4j/JipkSylnWsTRdKSqxsMxaXvw6rQFirt/FBrTjYFoX3pPcCXVHvxW0ZwguvwaM9txOa
	ch05NrPeF6rLT1Pt17MHvCEcqa6/uY5HOGkU0IbgMM0rhOM4YYHCUamw1iHXXaLiVU8IDt
	o9mz7IPcui6ziaAckrN28+GFg8eesl4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793679742;
	b=gF3oyBjnOMTb/aDgXOwkwIqwqkiQBRVAzA4ToZWJgomrPaddHdZQjgKyAwWAm/ag7ckWPh
	VShw5nFtSQCX+0q9g03A8RT38zsgdITgD+04URc53ZKyVAw5vzm54oZAVQiwjCLdWMboXP
	9KPBvmR7Ci71Q41Ixl7UMrc6QbcQhwM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TZmV1AZg;
	spf=pass (imf12.hostedemail.com: domain of devnull+daejun7.park.samsung.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+daejun7.park.samsung.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2306440180;
	Tue,  3 Nov 2026 04:22:21 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793679741;
	b=dwKYWRfzG++UeWXGp2XiN7Sr+zvoxidrelXHyV7jNhUfEETK4QL06FXXBoZAtC/HzuNQ
	 fucQFofm0J8e0KJRefyrK9MVEDSPaDxjDlpLpReIEF4CxH65cgrioviUPHjtnbcYX+//y
	 dCX7Bx384ZcndTkbbLgn+wWPo9D3F4Img8ajwjRXp1I24cNhPBDozXjIQmG3TncZo+zEl
	 akaa78wr6ZN7xyXBRupwZqvaREGrUb4arEJQMXBO5bZEqNuf1MK91+MHvCq1b5Tsf83Rr
	 kBmdUkWTb3sdmL0m/f9ZXU4NcUE7r2Y4CSmeKQhL1feI2eHv9MBkKUqVMfNI6Ok6S0Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793679741;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=VtT86yEYiO4k9pYnwKVFQUHi1JvkR5cEoQoLjpTBlcs=;
	b=Qwa4TN1Os4ZCAoXeQszKvjIKRV34nGULR45jvaM1wVu5NVadDUdi914qm0Y5ea8koCVv
	 og3G2KEkNWdHCXWT9LF/yJjt+QRjHTbW/worZ2EAzBRQ2zwGBZ/OW7iYXXkWW350VS5SD
	 1VPD8/T5njJ3DDr2Dj2lo5yQGofRsrGQMGsLITzWTlr/B10sqmZwLlinoxG5/8tYHMa/q
	 U6/E0TxXWFY1NkDU0PFo7a90PVWE9KaAZHqBr0lt2+FzPFBxapEnrzU9azUOB95Ptev80
	 /W+ASUK/9GVeY9oqZ3uGu+KuEv9EjOTZOq1SaFEU3ndJDmI8kxzwH0NxbZVSK367uPg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7DB941F00A16;
	Tue,  3 Nov 2026 04:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793679741;
	bh=VtT86yEYiO4k9pYnwKVFQUHi1JvkR5cEoQoLjpTBlcs=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=TZmV1AZgAhqWDXfHpuNEREY9UHSJnurCzRY5QhofOXbtUGa+xAqxZQFqlENawd9bi
	 SnpJFLSMPREKpUNjGHZ4P1hgZNb5sIumx+1Z4XDEAMaBof/Qye+rSTfRGRZjnpOqm6
	 +UFl4wf1qipNGIxQtdug07giD4IHF+pGjTdViRPJn5Ry9WtVxWCGZNVo4YVp7mAUEn
	 WuKBBChXFfr7idXPipZajlajfk+9QmLjru0RPxthxeCM9a6dc7DNJUBRb+LPplB2E4
	 3Pizw2yMeQTEKWwBgGo1j5eNgSneIPE402Oox/hcDCARoj7yN4kt4/Tx6ZCx1a+AmQ
	 B2E7iirIFzFkg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D228C46798;
	Tue,  3 Nov 2026 04:22:18 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 03 Nov 2026 13:19:26 +0900
Subject: [PATCH v2] mm/readahead: align the async window in
 page_cache_ra_order()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261103-mm-readahead-async-align-v2-1-c3c304cbca59@samsung.com>
X-B4-Tracking: v=1; b=H4sIAM1g6WoC/3WNQQrCMBBFr1Jm7UiSarCuvId0MSbTdsCkkmixl
 N7dWNzKwIf34b9ZIHMSznCuFkg8SZYxFjC7CtxAsWcUXxiMMlYr02AImJg8DSWQ8hwd0l36iHx
 o9K32TluyUOaPxJ28N/W1LTxIfo5p3j5N+tv+pLX6L500llONZ7Kno+7cJVPIr9jv3RigXdf1A
 09w6YLCAAAA
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: Ryan Roberts <ryan.roberts@arm.com>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793679738; l=5655;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=Y6K49ChbLQ/vvrZa8N0/zgs6RJ3DJ7DdEewXatAf4Zw=;
 b=qkVlea5bIYUPbnzum2mHckAQvFbKLK2nD6gYINP9fYoPR6sA/KB4vBwgtLvorta6jrMUzytkA
 S58uRJ4d29DALnO40WT9tIZWXfdrNooaUG9qaTpR6qG8/e5Gs7rcYgJ
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: piojtk77pmay9wo795kdns1rkzdg4ajr
X-Rspamd-Queue-Id: E947A40002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793679741-229458
X-HE-Meta: U2FsdGVkX1+LOsfxMWdnGt2/0G6rQHBM83laJ4eA/dK2Au5bMEI2LWKNYDnWTmfxysnKz9i7TsZkzqT74N9LKONQXNYzMrCTW/whHS3uIftAivKdyJQvaB0IgI0FoGRSZAtoQuUTbkskRfrfPp0teh/GmX+zEGO5m8zqhlWqCwruw2sVFoATFrXZbep5MqAinFQVABwxaeTFeNFRrwbMCtnnNZXonA7YiviuCoIlq1FAMgTHUciwm9zzqEaeBRzbaEH+6TJPvlh86X+JsI6c68pXKTRp6+8rJHNpuq2wMyCx4A7fHHhtsqNqZedbk2+wi9qTVkFxfAtnU9jnMu/72FvB+OtLIBOTlHsdeY6Lbr3enlXFv+brKbcuANHpgF62OLpDODuW1wul4CR7oziee+9SXBMnGIH23GjM5sytKE3Eiep59U4KtTSAt+pCYl0u4zEAFuvoZcfadf68Luxh3PsWd4BTh4J+PCk3rEiRHvCVYPb7pHALJVJntuvpyUmi8EES7NJUj5i8iat4ngy1JtXa8kCU8uKuNhWVk5p6FgsWXwgWJjXuTs4K7MUGt18iV0xFGVueM1pv5oA7vG2YEzaaB/R0ZqxDUyJ5n5OjDiLtogUrtyVJs4bC7kCGu1amasJFx1p2UAh3WhqJ3OIp+zUTZqY9zIJ9mx4jrwoKoUMKz0HuMQGvda4nRdrYx9k5hjNZiI5hDH77JVnwdL0TnoYY4zH0B/7EtctVRrDJTG79nUpN0ypW0KmleaQY8T/YE267s9AUwFE74PYbtJbbwxuG8gW1bU+23d7C7J56RxoUyudHHLNGWSi4a0L4uguX8AP4dIV52Xxv+khmFeUUvpBfzrZC/XqrWPXBXMCbsq/YB0hnsjz7zi0ffT44vjeqchqK7aQBXW1aaIeUp5Mryj39nekrmIaGlaPyHDN29CLcEaDPPR/aencly+5WN9mk9ehtOZpNvL1tfCUeoSW
 3bLf4rNR
 14vO49RGDG/LCuaJba0O4wrGUoN6zzSbzii2eSu73Dlu8dKkmJ19TyVZo54a7wRsQfJkuAZvee5fg2T3zvq41h2pOskbZRMTpnJRTB/rraHxlUx81Bn9cSlViG4AFwn5tfEIcIKDNVUHXrRrx9NzRNPJBhfpuniwVYB/Esb7Wp20YmaTTPbJssJzbjvRX7XJMlSCMYfcL33KuXiz/cLYGH4Mv/sYSm71PIzjCngldXugq8VHNSR/PV5/FRTnX6Z7OgbnN1SHUFsmiPvs6l7cdIoIctMKKXyZDTyMuVZ1p4NaPZ0X+2FC6KQNsC/V5cs7hCD49lb4qLD8M6OcZ27DTwRWGumcggy9wzkvdyRXVGNio9Qgk6rhN1EWtWFjVo8aWQ4gjA219kYzCaER+MhrA0ptBUkPeai1E1kDy5rYsfp+izFafhgxJbxAnMmpzp0JYVQBvqyhvV2QiCMwc6O8xt6cdcBnClTAR2dyJs+SZKk0q4jKKuK2wNf9T7fhUEMmyK3jeFXe2HqNIhzykNOLLJTk70hA5b3VUfYJ1x6/p+MNco92gcTinZ1P0Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Daejun Park <daejun7.park@samsung.com>

page_cache_async_ra() rounds each window end down to a multiple of
1 << ra->order pages before page_cache_ra_order() clamps the folio
order. A window starting just below a boundary shrinks to a few pages.
With read_ahead_kb=128 and max_sectors_kb=512, 1 MiB reads after a
4 KiB read at offset 0 hit this on one window in three. On a 512 MiB
XFS file over QEMU NVMe (cold cache), that takes 0.251 s, 3329 device
reads, and 9721 folios (none of order 7).

Pass a flag in struct readahead_control and align the window end in
page_cache_ra_order(), stepping the order down to keep at least half of
the window. The read then takes 0.200 s, 1031 device reads, and 1039
folios (1021 of order 7).

Fixes: 18ebe55a9236 ("mm/readahead: terminate async readahead on natural boundary")
Suggested-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/747jhqta3plrrx3bfikceoltsewshdpejdei2qjpn3onnvtu3p@cptmb4phbn54
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Changes in v2:
- Pass a flag in struct readahead_control, align the async window in
  page_cache_ra_order(), and report folio order counts (Jan Kara).
- Summarize the benchmark setup and performance results in the changelog
  (Andrew Morton).

Tested on mm-new in a QEMU guest with XFS on an emulated NVMe (2 MiB
max transfer size), read_ahead_kb 128 and a cold cache, median of 5
runs (folio orders from mm_filemap_add_to_page_cache):

- max_sectors_kb 512, 1 MiB reads after a 4 KiB read at offset 0 on a
  512 MiB file: 0.251 s and 3329 device reads before, 0.200 s and 1031
  after. Folios drop from 9721 (none of order 7) to 1039 (1021 of
  order 7). Without the 4 KiB read, and with 64 KiB reads, device reads
  and device bytes stay within 0.1%.

- max_sectors_kb 256, 512 KiB reads after the 4 KiB read: 6147 device
  reads before and 2055 after. Folios drop from 15867 (none of order 6)
  to 2060 (2045 of order 6).

- max_sectors_kb 1024 or 2048, 1 MiB reads after the 4 KiB read: 1029
  and 1030 device reads. Folios drop from 2839 (766 of order 7) to 1039
  (1021 of order 7).

- max_sectors_kb 2048, 3 MiB reads after the 4 KiB read: 273 device
  reads and 315 folios (249 of order 9) before, 265 device reads and
  277 folios (252 of order 9) after.

- Non-sequential reads (max_sectors_kb 2048: random 4 KiB or 64 KiB
  reads, two interleaved streams, and 2 MiB regions at random offsets):
  device reads and device bytes stay within 0.1%.
---
 include/linux/pagemap.h |  1 +
 mm/readahead.c          | 41 +++++++++++++++++++++++++++++++----------
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 73af18a373..669d296edd 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1413,6 +1413,7 @@ struct readahead_control {
 	bool _workingset;
 	unsigned long _pflags;
 	bool _forward;
+	bool _align_end;
 };
 
 #define DEFINE_READAHEAD(ractl, f, r, m, i)				\
diff --git a/mm/readahead.c b/mm/readahead.c
index 6e55632902..959c9a7b48 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -498,6 +498,35 @@ void page_cache_ra_order(struct readahead_control *ractl,
 		goto fallback;
 	}
 
+	new_order = min(mapping_max_folio_order(mapping), new_order);
+	new_order = min_t(unsigned int, new_order, ilog2(ra->size));
+	new_order = max(new_order, min_order);
+
+	/*
+	 * The caller allows the window to shrink so that it ends on a folio
+	 * boundary, rather than ending in small folios. Keep at least half of
+	 * the window: one that starts just below a boundary would otherwise
+	 * shrink to a few pages. Use a smaller order instead.
+	 */
+	if (ractl->_align_end) {
+		pgoff_t end = start + ra->size;
+
+		while (new_order > min_order) {
+			pgoff_t aligned_end = round_down(end, 1UL << new_order);
+
+			if (aligned_end <= start)
+				break;
+			if (2 * (aligned_end - start) >= ra->size) {
+				ra->size = aligned_end - start;
+				ra->async_size = ra->size;
+				new_order = min_t(unsigned int, new_order,
+						  ilog2(ra->size));
+				break;
+			}
+			new_order--;
+		}
+	}
+
 	if (limit > index + ra->size - 1) {
 		limit = index + ra->size - 1;
 		mark = index + ra->size - ra->async_size;
@@ -506,10 +535,6 @@ void page_cache_ra_order(struct readahead_control *ractl,
 		mark = ULONG_MAX;
 	}
 
-	new_order = min(mapping_max_folio_order(mapping), new_order);
-	new_order = min_t(unsigned int, new_order, ilog2(ra->size));
-	new_order = max(new_order, min_order);
-
 	ra->order = new_order;
 
 	/* See comment in page_cache_ra_unbounded() */
@@ -656,7 +681,7 @@ void page_cache_async_ra(struct readahead_control *ractl,
 	unsigned long max_pages;
 	struct file_ra_state *ra = ractl->ra;
 	pgoff_t index = readahead_index(ractl);
-	pgoff_t expected, start, end, aligned_end, align;
+	pgoff_t expected, start;
 
 	/* no readahead */
 	if (!ra->ra_pages)
@@ -710,13 +735,9 @@ void page_cache_async_ra(struct readahead_control *ractl,
 	ra->size = get_next_ra_size(ra, max_pages);
 readit:
 	ra->order += 2;
-	align = 1UL << min(ra->order, ffs(max_pages) - 1);
-	end = ra->start + ra->size;
-	aligned_end = round_down(end, align);
-	if (aligned_end > ra->start)
-		ra->size -= end - aligned_end;
 	ra->async_size = ra->size;
 	ractl->_index = ra->start;
+	ractl->_align_end = true;
 	page_cache_ra_order(ractl, ra);
 }
 EXPORT_SYMBOL_GPL(page_cache_async_ra);

---
base-commit: 9c449f885765cf8d80b2c60b1971e774bba51a3f
change-id: 20261029-mm-readahead-async-align-e491b3dc16a6

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>



