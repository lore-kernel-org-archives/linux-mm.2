Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92277606A320
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 01:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PB1WW2ZF
Received: by kanga.kvack.org (Postfix)
	id 7A2BE6B00EF; Sun,  8 Nov 2026 20:01:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751966B05B0; Sun,  8 Nov 2026 20:01:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F226B05B3; Sun,  8 Nov 2026 20:01:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35D806B00EF
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:01:01 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BEB080595
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:01:00 +0000 (UTC)
X-FDA: 85413776280.17.41AFCC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5E0F62000C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:00:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PB1WW2ZF;
	spf=pass (imf31.hostedemail.com: domain of devnull+daejun7.park.samsung.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+daejun7.park.samsung.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794186058;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XhmctGYt1NLuOmkkJo8KoaAOSF5MQcdoV7paVt7iNJ8=;
	b=YPQShVrMvXyHuk5EerbfauMrzQC/8g+8dwxqNLqGj6T7NzNvarakNIYeyxcjEU7LelmC5V
	3Qe2zTssVpCt0VxyAW3kVsxfnqKMlAyV3pGk/hfKe1VC0ZKaZS7ykM6wkeO1RU938mFGXW
	TBPlr+7i/U7NOJYnug/t4l2lBdc19c4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794186058;
	b=eWJ0ecSo6GjXDh0XmT5IPDLnrFVfL0v+p6ExpQ+IuRjJqoaDojxsWa4coGAUYhHgIPZ2h8
	NBEgfBRr9ErkqvqSvjh6/iRi0Ax4agL+Vhs/C0rMhCqVDgvKztoSEgLxh2dSIn56kqCHbX
	YnwsvNFGFZVEOo3JYhkYAYpWZXGWPVU=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PB1WW2ZF;
	spf=pass (imf31.hostedemail.com: domain of devnull+daejun7.park.samsung.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+daejun7.park.samsung.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 84D77439C7;
	Mon,  9 Nov 2026 01:00:57 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794186057;
	b=nJDUpUTrr6PveLW4puvohSYpbQ3zKqO5hLw3gpcHN+TnPkLQtwHJiNHVWeAUAPYglIuw
	 6VHW7hZhbXkJzrbGIUiCdzDgBHqwsi01ECTkpwmd0TCGfrd9PBcflHT8tKz7eBkcskk8E
	 PZJkrCesuIGclRFSslTaRPVe+WG1bRPi0vjRQKDXsbDuV7BWVZryN+tzESCunNf8n3Vqg
	 C+wOY0VbQM2Te7hvV4eLXYCbp8xn4XYa2l2iw30hNamoRZKWe2CLKBzT277qHjyLAI6ko
	 io0TnnIJHvZtoL45q7dK456MdYSBcsxmeA7nG6N2SfhRWpOVbBWUXt5EIbSdXAvXYWw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794186057;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=XhmctGYt1NLuOmkkJo8KoaAOSF5MQcdoV7paVt7iNJ8=;
	b=LnM+/HzCQ0q1YRz5rvDz/aeZOjy++w2ARzUDaIv0IyC9XiE9xrqjSKWgsWEOByk0Z4cS
	 GhqEevGEc3LDF3+2aIpnA/c35QoauP8jswKqvLKeN0D3HkAjIOnmAFkWlgL4vDPhwSAha
	 suvK2Sx63iKNplnsAtJ/pdSFoxmYfEFXMaqaM+PMUQma7HesUu4E2a/1h0LRBWWni1cwi
	 2VuUohQYaCzfoOskOVF4ui2QZsk2gKJVUZIINQbcOOvlc+DAqxJe7sjWohh58V6oe0EKP
	 xjb9b25aM/BNzZQImEgyi9lrWBcPA0jPG/Xmupwu5vteJ0QJabZriJa5vU33uR9iYWA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A34DF1F0089F;
	Mon,  9 Nov 2026 01:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794186057;
	bh=XhmctGYt1NLuOmkkJo8KoaAOSF5MQcdoV7paVt7iNJ8=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=PB1WW2ZFBpGVIAphSviNgdlZGQzscS+VBrNvGHlnVxEPn5B/2b6YyoJpl2U91/Y81
	 EeTbaMrBx1b6Df/mhvEJSk+4+GHwtNbKcvMd61MxehrJ7x1tZA2HLot0Xu9QI5Nn9b
	 ajmoKkjh1QGItA/d/RbCobqidVbko3sRKlqreFFdBOsyLso1BpnG3pYuS/AGge0oQ6
	 tGQZ40BXmY2uErQXU9luvhaaMa7OQcA1f0nCDkiW9JiNwqnjFffm0RlKvtauTABxhm
	 wJAUsgCITYpJzxFuSVVnPPLaasNvW27cZal7KCTSjEa/BrOw6HvvEdZasARCfk4cnp
	 mWY+ubBLJeZKg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 046CB481D0;
	Mon,  9 Nov 2026 01:00:56 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Mon, 09 Nov 2026 10:00:56 +0900
Subject: [PATCH v3] mm/readahead: align the async window in
 page_cache_ra_order()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261109-mm-readahead-async-align-v3-1-1567d87b1858@samsung.com>
X-B4-Tracking: v=1; b=H4sIAEcb8WoC/33NTQrCMBAF4KuUrI3kpw3GlfcQF9NJ2gZMKokGS
 +ndTYsgLpSBgfdgvplJstHZRI7VTKLNLrkxlCB3FcEBQm+pMyUTwYTiTGjqPY0WDAxlUUhTQAp
 X1wdqa81baZArUKSc36Lt3HOjz5eSB5fuY5y2T5mv7RuV7DeaOS3DtLGgDg3v8JTAp0fo9zh6s
 rJZfKhi/aFEoVCiZDW2CI3+ppZleQG2u9AdDQEAAA==
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: Ryan Roberts <ryan.roberts@arm.com>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794186055; l=6482;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=TvHvnVH31GT9hKp4I2jjZznNd6BXKJMMPl//bejzAgQ=;
 b=vhzld0CvUYOjFuiyUmo53Sq4vh0jPPHbl8KqVFO/yzG4x4ECknVS/IZ9cgypWuOoHMcBLWp7r
 abZeA1MYs/EBimBM2+CCk/xDQNgRZsO3vOqBSnTEHVoicXHBfc2Q3Os
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: c8ayeuejedinwuq7c45utsdsprm6dikc
X-Rspamd-Queue-Id: 5E0F62000C
X-Rspam-User: 
X-HE-Tag: 1794186058-859945
X-HE-Meta: U2FsdGVkX1+x5eSn8j5Oi/uhL4qRDKN6ALEqk6inHr6m+uQPnennhrgH+tyQ6OHXX2hOqyRCqVAB9tQTKEkGhKRyP9ZatJujbMLTsAGS+4ezkCibZ8/IjP1fwXN7zyffo3j7xeyritRDiwBQIvpkiC2vQDt+vx2xOSRRVP3krTy03fAjuzwAc8KLyFbp3BHrtyA3wZu9EmxBpA6zzfKi2TyfaN0vTQ1v+cp0GvRLwEkN/IZOXE3Tzw3kGphbQAc7fSUPQFp17Q7GJMKBjoFObxPIr/JLK4nPWQJ9dl14BH7BqXVSQ7Bd+51B154wSlJeqZY53Br3Q4hwQcbt/iKkNnGpBwD3nrUDl77N6SV59cLYtdv0IEelAXven9iaeI1FpKDBI4qoV77jawsF2vmF1oAAGaRVFwrmGRbfYVAZV9SCxuY78Uymmgp1biElKkZuQ4oNvt982TeWxlzxPo24vfnxM0O1z+iXHbPLZ+Pd6K/CemNPUmVg0QO5ZLxZS9z1xtVeYTHxLUjBclxCDnlPANkXBNfkE6Zwq3regFiMmvxUqoHEdCpNxFuzFdudoo6EEn97eMtDpJNXuf8NiPV2qhUCUFLHQ+jhk3CkkAlpWNWFj89K8PCjlmcv+aPkN/AO1whs5eRI1GSFu51ZCKgZUsnpwZFPHTJTxWyV5A29IBrkzFWNFn8t3F41CJCjvOv/3FzNyK+ELM8P3E/yOXrxY0R0Mh0b2d339mN9F/5EeigB5w0NgkzQMmQDB4lvAVVZvzgYkmfBgh7hsdF/6By2VsMEBmLoilfgxE/+YNYklpPr8k8BedXrA3BnC1oy6+smWNw7D73zlslWdcaxkXopCLF7WekQw+FjHimlcWTBSAMnr6BixcFuUteGMFi2orK/iDrCwqUfrC7QmtPH0kqptZ3nOmib0s/AabfTxTic8UfaZnoZG1WL766KbC2xGJhcUaG3dti4JGQOkYsG2XH
 WKxDOMLm
 uVkjd6qZAfp9WNCpA1LhMYphSMvfmv6UY8G7kmu5v2kmoSLtypzBEmcEaXMWuzHsszu/qi1Ozykr9A+F+rYhrOl+ecf2Z5A9yZaB4TUVkZ/fzzXIjbo7YdGQfS+qSkXHt/pjXCP3t8+VXCyTBYU1JyVnKdAlWcEC9SAnz8O1bQUMVuMgCwh8WbjKAgTQPXIu4j2Xymi9ZPlS/2iFODNhnCsUeDx48UGZ+H6rhQBC2ipTcbqztShH4UCI0w3Y+isKWN4vT+URXgBHAf22TZKy/o2Lm9IZVM5+sFIdekfjKJmwBhcv6/zXtlFvQdOqKKobpgM21jIOQffMlptx1tluo070juggbRb+hU/1Xjy8JHnrqobDmJvbyCIAUmTIMkz+XAKSlhJ4AEjVqco5bLUjxI2U6gBQjLtWwY5o4B/5CFUDCQxvIG7qRkJ6X3lxO/7Gytyr+fR2BvW3wwxWCKXlseJPZPwGDf2iA6XgeGgbZyCNS0LkZDyssoar7M6C6Eb2/UScvjDh4LjnK6Z6VVlr97eqxWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Daejun Park <daejun7.park@samsung.com>

page_cache_async_ra() rounds each window end down to a folio boundary
before page_cache_ra_order() picks the folio order. A window that
starts just below a boundary shrinks to a few pages.

Let page_cache_ra_order() end the window instead. 1 MiB reads after a
4 KiB read (read_ahead_kb=128, max_sectors_kb=512) take 0.121 s
instead of 0.237 s.

Windows that start halfway into their largest folio, or are not a
multiple of it, can end shorter. 512 KiB reads from offset 384 KiB
take 0.183 s instead of 0.162 s.

Fixes: 18ebe55a9236 ("mm/readahead: terminate async readahead on natural boundary")
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Changes in v3:
End the window in the allocation loop of page_cache_ra_order(), as Jan
suggested. Testing his sketch led to three changes:

1. Stop when the rest of the window is no larger than the last folio,
   not only when it is smaller. A window that starts halfway into a
   folio then ends on a folio boundary. 4 KiB reads (read_ahead_kb=128)
   keep 4094 order-5 folios as before, instead of 8190 of order 4, and
   the 1 MiB reads above reach order 7.

2. Test the order before the EOF loop lowers it, which the first
   change needs. With min_order > 0 the loop then also stops before a
   min-order folio past the window end.

3. Do not cut a window that reaches EOF. It has no PG_readahead
   marker, so the cut tail would be read synchronously (92 instead of
   50 sync readaheads over 50 cold files).

Windows of mappings without large folios are no longer trimmed.

Result for the 1 MiB reads above (512 MiB file): 1021 of 1039 folios
are order 7, against none of 9721 before.

Costs, with max_sectors_kb=2048 unless noted:

1. Reads larger than ra_pages that start inside a folio lose I/O size.
   2 MiB reads from 44 KiB (read_ahead_kb=64) take 508 device reads,
   266 before, in the same time.

2. Change 1 adds to this when a window starts halfway into a folio.
   In these cases it does not raise the folio order, and the window
   stays at the cut size until EOF.
   - 512 KiB reads from 384 KiB: 0.183 s, 0.162 s before (0.126 s
     with Jan's sketch).
   - 64 KiB-block XFS on a buffered loop file (max_sectors_kb=1280;
     the backing file's readahead runs this code too), 256 KiB reads
     after a 4 KiB read: 0.304 s, 0.19-0.25 s before (0.186 s with
     Jan's sketch).

3. A window that is not a multiple of its largest folio loses its tail
   on every trigger.
   - read_ahead_kb=768, 128 KiB reads: 0.130 s instead of 0.115 s.
   - 768 KiB reads (max_sectors_kb=1024): 0.125 s instead of 0.117 s.
   - USB 2.0 storage (read_ahead_kb=240), in simulation: 87% more
     device reads.
   - md RAID with 3 data disks (read_ahead_kb=3072): 506 instead of
     342 device reads with max_sectors_kb=1536 (simulation), 260
     instead of 342 with 2048 (measured).

No stable backport is requested. QEMU guest, XFS on emulated NVMe,
cold cache, 4 KiB pages, medians of 10 to 45 runs. Also run with
KASAN, lockdep and DEBUG_VM.
---
 include/linux/pagemap.h |  1 +
 mm/readahead.c          | 26 ++++++++++++++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

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
index 6e55632902..46bee515aa 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -491,6 +491,8 @@ void page_cache_ra_order(struct readahead_control *ractl,
 	int err = 0;
 	gfp_t gfp = readahead_gfp_mask(mapping);
 	unsigned int new_order = ra->order;
+	bool align_end = false;
+	unsigned long last_nr = 0;
 
 	trace_page_cache_ra_order(mapping->host, start, ra);
 	if (!mapping_large_folio_support(mapping)) {
@@ -501,6 +503,8 @@ void page_cache_ra_order(struct readahead_control *ractl,
 	if (limit > index + ra->size - 1) {
 		limit = index + ra->size - 1;
 		mark = index + ra->size - ra->async_size;
+		/* Only a window that ends before EOF may be cut short */
+		align_end = ractl->_align_end;
 	} else {
 		/* We've reached the end, so don't set a readahead marker. */
 		mark = ULONG_MAX;
@@ -529,6 +533,19 @@ void page_cache_ra_order(struct readahead_control *ractl,
 		/* Align with smaller pages if needed */
 		if (index & ((1UL << order) - 1))
 			order = __ffs(index);
+		/*
+		 * The caller lets us cut the window short. Stop at the
+		 * first folio that does not fit before the window end,
+		 * once the rest of the window is no larger than the folio
+		 * added last. The next window then starts on a boundary
+		 * of that folio.
+		 */
+		if (align_end && index + (1UL << order) - 1 > limit &&
+		    limit - index < last_nr) {
+			ra->size = index - start;
+			ra->async_size = min(ra->async_size, ra->size);
+			break;
+		}
 		/* Don't allocate pages past EOF */
 		while (order > min_order && index + (1UL << order) - 1 > limit)
 			order--;
@@ -536,6 +553,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 		if (err)
 			break;
 		index += 1UL << order;
+		last_nr = 1UL << order;
 	}
 
 	read_pages(ractl);
@@ -656,7 +674,7 @@ void page_cache_async_ra(struct readahead_control *ractl,
 	unsigned long max_pages;
 	struct file_ra_state *ra = ractl->ra;
 	pgoff_t index = readahead_index(ractl);
-	pgoff_t expected, start, end, aligned_end, align;
+	pgoff_t expected, start;
 
 	/* no readahead */
 	if (!ra->ra_pages)
@@ -710,13 +728,9 @@ void page_cache_async_ra(struct readahead_control *ractl,
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
base-commit: b95f8bb86713c860ce8536d22a988b949b884d5f
change-id: 20261029-mm-readahead-async-align-e491b3dc16a6

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>



