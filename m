Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38AB4606A32E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=kKwN8LKy
Received: by kanga.kvack.org (Postfix)
	id 3F8B46B05B5; Thu, 29 Oct 2026 17:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CEAD6B05B6; Thu, 29 Oct 2026 17:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE0F6B05B7; Thu, 29 Oct 2026 17:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 012AC6B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:00:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 40F9E40491
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:00:11 +0000 (UTC)
X-FDA: 85376881422.29.4D81BF1
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0ABA614000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:00:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=kKwN8LKy;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793307609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5tlCFNXv0zayC/VhrDsZ8YDvmdfJXzEoF9HPtNnow1Q=;
	b=YMMi2LG9WeXaVbeYpbczy/54Jlsc90djxWVIRUOEGa9OR6V0y2gR0jk2yWBJGEf/NT7e2U
	SmXhSLIXha0A1nuvH1HEHaseQdblY0uBeR5m8s2KkToCiIXRK0jIWfKhYxqq+XXEmb79+5
	ervzLmPzAdUzz5tGSgOn4eqNn0iWWbQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793307609;
	b=aoJgiPWUTilghU387NFrZmm2jqQyYi8Qvjli5afbwEVVpfsuujySxlzmSC6Pf7UAy5GQKT
	8HvZPgPWwS0BxvQdAegnF63S1BSoettK0/HJOVOCO2o+HuZ7XXEzbGUuVUYlPZcOAyQyie
	fM3J4gEsuu3566KNUkrVImsrRbSJ6So=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=kKwN8LKy;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8b13c7bb0deso482307b3.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793307608; x=1793912408; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5tlCFNXv0zayC/VhrDsZ8YDvmdfJXzEoF9HPtNnow1Q=;
        b=kKwN8LKyjA3qXnGqjbGYZTuJuGwWEfOvGhLzJcrmVMISEfqvtdLeujjssTAB5VeFLm
         klCp706Ur4ahA91LOy3yykFABbphcuF9oCpGhHwJjqNKeuiwRCBmaFuTbER4wjZNIg/r
         pEEQVx2RMvGyvVv5NWeYne3SrvwQshybJuVcCnCxBBcml4QXrabefLVKByE4+VjJi4Ux
         bkEAlXQStwIbGtpW/ntqykevp/Hd60QbJCgEnBIWKWsqaidZBGkmkQNWiswYaIPOXC+d
         DicU00oDkleZkr0a/kCz5Ei05Qt3Zw98J1jZTpLUMulChp7Ywkcuqryap4/iRTVxWoJL
         a0Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793307608; x=1793912408;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5tlCFNXv0zayC/VhrDsZ8YDvmdfJXzEoF9HPtNnow1Q=;
        b=fAe4qzanqlsCZM3qxNPDTwc+45F5w9NK0mUtf3uxHgHe1neBZG71RFDWBDM7OoKnxA
         KbmEy+4sx3HM1DEm/JMK+D3kixZLE5Fu9gdFqAvs5sJWr+n9CkvDXJht64Dy0ZU7F7Aj
         YvAMDk7QMbwLy5qLS/Mb/VSQ6K5iqdFeG4ymwOKx/+CBW7C/Kb8Bv1bYmrJBKpk3hoLA
         kWhdQrM+zDInlamJMU0NfxjvasS486rJKDeh4O9qL317sdxNgrxFUIGUujA3nC08Buk9
         NYg3MeHuXTEH5Cjv6ZpvUADLYs/h0Mr5oxirTviuCxc/eup3cVHRjWm56OubGGxikt1e
         zd/A==
X-Gm-Message-State: AFq9FYKlSZt7Abv380Se+U2Fi9B7mpDoPfPC08Ls/8bFDBwTljEhtHPc
	+jhHiVhF+K2BoNJnqh6roSySN6IwnTUonDinly3grqWKvQLyWwkUY0g6P3a9g7Vk7io=
X-Gm-Gg: AYBFou0HlRxydkrIIsUaTmVXCy+0lM6OKzWh6LkxbmPEVyxhfjp6ZIIF1GZOJ7OTQE5
	MkarwJ/qFOg6IP67VfUg4ZhX2NVrHrMu67GrEqRUnv+WUMiJHbYhKb2QmXduZnO0srTfSvXF22V
	cuiRRUk+KH8rx8g9/hqvZZBRyobkhhodyYyFlTDLIsNoVldJi4WhOtRR3I1Pf2++nLMV88b30Rb
	Y4T6iaDbxbiGY/+Pjjt5HDTf3wyXFyrwgGZkeQISeEB4O+VJ3KcpHPZFe3tendNd7fVoH2WPIEq
	R4Gt7BxnFedx/ubRuZaAxSjmclJDeCDDUCfA8QeknyjhOfC8pi4rU8r0j2/A0tTsOdK5NFI8cmi
	fI8B1ttwW6aAPVpDpB5iBLPf9Ja6Kor/Pn1pqJmbPCXtoiFKhQMNBxgs75K9F8qzhCIeE+8t3HA
	OLjOJoenY8hqljpmbljN5XEAwq8kdWDRMhbWuGKEB8gONgHH8Ut911cOs5fwJ9rrblJ+ucM99kb
	s33YOh+Gsdt76NnBviQHA0D0OXuzofuJ7QaocESWGQVbBRABQZZbLxPNRYA3UnwKZFH4DnCZrIi
	vbQJm+z8+OU4jKHfqSmW5+4TSJyn
X-Received: by 2002:a05:690c:6e84:b0:8b0:e207:34b4 with SMTP id 00721157ae682-8b2b66d04c6mr962737b3.18.1793307607821;
        Thu, 29 Oct 2026 14:00:07 -0700 (PDT)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b4b2b6d8sm1744327b3.29.2026.10.29.14.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 14:00:07 -0700 (PDT)
Date: Thu, 29 Oct 2026 17:00:03 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Chuanhua Han <hanchuanhua@oppo.com>,
	Mani Tofigh <mt4022@columbia.edu>, linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 2/3] mm/swap: account synchronous swap reads as memory
 stall
Message-ID: <auOz00OGB_8dgniC@cmpxchg.org>
References: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com>
 <20261030-swap-fixes-v1-2-73f73a59f2fc@tencent.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-swap-fixes-v1-2-73f73a59f2fc@tencent.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0ABA614000B
X-Stat-Signature: 97yo6idfw6n9gsozjipz8fsb76xgznsb
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793307608-295946
X-HE-Meta: U2FsdGVkX19lOrUY3rd+Ca56OjJzcoykI9V8vuld6TXeDU2zBKgMPL0ZH8xYcsKN5npsy/Z0gLOfzQrMMeyVhKYn3CorkmOvau6NwG6C9SZie3E+13udiGa7RBsuZC7ByTHbNT78UgUiJ8rOhedJsezlGJvodu/ANxi4ndZSuCEFBgEcukDaXI/ybguJqRb9IE25VvBkDH4gPjQzJdjK4e3l5FjFoF2gP2eWmgHS72ElMADRocchPrPVPEABRAXF36zCYqkU54LKa/TmdwGQ6SXJN9cHSZANuwcDcaKQZFKmj4UMV9WY7++HylGbtoPbpK92zDHtkPpV8VuNiOvneUQPP1vV/74MCRZytXEBAcBjLAdlLdJGpM3S7ryBdiIcbqIQKHujZxwS/u+Xukv/ZZte+v4w1CJBq9rnRmqGqmHN+S1Q/hLGgUx6QVKDizHZ+64o8zR1bKPWu0zqtWj7IC4Aoy7mVIACistj4nxTw+H3hQo2tHJ9+gAv0DfMhesnDxzmiwRNrlTfGTMlcxFdaC1pEqc6J8HYqC03ao89+GxMO/xu2Q0P55KYl+L1nPmDXchEK2/+bBsFk4T8rVqK9Lv6H0P62lef0ecsEBqpZJIc3+J/mAeBp9CL0iTc3iUdd5qwvLf2kqQEjx7JpXRQT4Wfh0mJpnb9yZxVMYVPIRxMPIuaSG+HIgcnuQGUduX1j6JLH9Xd+FE9zWyKAPvryrrghVtqboDiWJlNNytMPT4MkBBYWvDK4nHfSeW+zDbARWVODbzKiGy2OLJLC/pPpZdubU1QMvFeCYkqNkpCiwtMpf8sJZRAMvlAKOGyQU7mtf6RdqJ60h3p+F1yIPTPbktIoMvAyzZ91IHc3IXTXqKognDOO7x/aM34p9/nk2I7/OJ+UrGJOLnH/Xm7x+W3MKu7UeQMhRMEmZ3sJoCaCrnRbWV1/oaLR/ldKB1zKb0uKQpn1644g/8awQVOh8z
 GOw0Prmb
 3NLTFGhgr7AZ/5HVzxx0BKUsUzsGE+DxbNkWQOaOA4oIYQkWkY2VvJAyEaiC7tMGGWubVZ/KbQQChtyk5uVJ3xKl5TD15ch+4SPk+YM0i1Lhzd6cZFVmg9rZiAOfLm+w+yJTsEWaSTuws13iPRlrzlNsgUQX2Kl2emBqhLvcso9ShdGIVsS4s3wZcFwG2eUJdeKC594vpIhrwPT+yX/8CJfcrqGfXI6QV7cF3WdFPFuRZjQyTZlc6Z6kv+uDURxSCglMzEZMt/MjFcsP/h084lVRXFpnOPWpW+i4acuHwbGRH7jvJZDCJTUQJ7YUT2XX73NJxbr1XXPJsOPprSDcTa72AV2K3TZ4Tsktw4e8Mao7NFKQgaawFTkJZjRd4gY4vQiSwBQr4sk/bgWyOsiaTwvkpBG4JHc+A7X+MSvA6rf+9cH0MFY+0eM5YG4oqgH2HDrF+Ls5gJ/PqxYZmiukTvCYTAP/LyvCmFy9JiVs3S6NrsVkP+yoC5b7q+CEcd7et47FMnmL8buaGi28ILKc/i1qO9J3EMeq9MDhb0YmrO5ip28QgkQXRa6jboRMOLOQRfNv1YganDHB3y8zmOYttAMICGpcKXOWBy7OwCLcxO0R6N+GZAXXzEcPZevCAScXIl7Pv6/1vQKiM6Ak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 02:31:42AM +0800, Kairui Song via B4 Relay wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Swap-ins from SWP_SYNCHRONOUS_IO devices such as zram are no longer
> counted in PSI memory pressure or in the swapin and thrashing delays of
> delay accounting.  Refaults of the workingset from zram, the main input
> to userspace OOM handlers like lmkd and systemd-oomd on zram systems,
> become invisible in /proc/pressure/memory.
> 
> swap_read_folio() opens the accounting window with
> psi_memstall_enter() and delayacct_swapin_start() and, per its comment,
> means to count the submission time.  For synchronous devices the
> submission is the entire read: swap_bdev_submit_read() does
> submit_bio_wait() and completes the folio.  Since reads are batched in
> a swap_iocb, swap_read_folio() only queues the folio with
> swap_add_folio(), and the bio is submitted later by swap_read_submit()
> in the caller, e.g. swapin_sync(), after the window has been closed.
> By then the folio is uptodate and unlocked, so the fault does not wait
> on the folio lock either and the read time is not counted anywhere.
> 
> Found by code inspection; not reproduced.
> 
> Fix by submitting synchronous reads from within swap_read_folio(), as
> was done before the batching, rather than from the caller.  This gives
> up batching of readahead for synchronous devices, which do their I/O
> inline anyway, in exchange for keeping the accounting simple and in one
> place.
> 
> Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block I/O")
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Hm, this isn't a complete fix to the problem described. IO throttling
happens at submission time, so there can be significant delays on
async devices too that are no longer tracked since the culprit change.

How about keeping the accounting window open across the batch? Opens
on first read, closes on submission. A batch with at least one
workingset folio is "contaminated" and the whole sequence and
submission becomes a stall. Would need to pull the !can_merge flush
out of the batch-add function to get the accounting window right but
that seems reasonable.

Something like this:

diff --git a/include/linux/swap_ops.h b/include/linux/swap_ops.h
index 57ac6c703f68..6e45c9204482 100644
--- a/include/linux/swap_ops.h
+++ b/include/linux/swap_ops.h
@@ -17,6 +17,10 @@ struct swap_iocb {
 struct swap_io_ctx {
 	struct swap_iocb	*sio;
 	struct swap_info_struct	*sis;
+	bool			in_batch;
+	bool			workingset;
+	bool			in_thrashing;
+	unsigned long		in_memstall;
 };
 
 /*
diff --git a/mm/page_io.c b/mm/page_io.c
index c6824fcd483e..22e5ac1d298f 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -197,6 +197,19 @@ static void swap_zeromap_folio_clear(struct folio *folio)
 	swap_cluster_unlock(ci);
 }
 
+static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
+		int rw)
+{
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	struct bio_vec *last_bv = &ctx->sio->bvecs[ctx->sio->nr_bvecs - 1];
+	struct folio *prev_folio = bvec_folio(last_bv);
+	size_t prev_folio_size = folio_size(prev_folio);
+
+	if (ctx->sis != sis)
+		return false;
+	return sis->ops->can_merge(folio, prev_folio, prev_folio_size, rw);
+}
+
 /*
  * We may have stale swap cache pages in memory: notice
  * them here and get rid of the unnecessary final write.
@@ -218,6 +231,13 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 		goto out_unlock;
 	}
 
+	/*
+	 * Don't hold up a batch this folio can't join for the zero
+	 * check and possible compression. Submit it now.
+	 */
+	if (ctx->sio && !swap_can_merge(ctx, folio, WRITE))
+		swap_write_submit(ctx);
+
 	/*
 	 * Use the swap table zero mark to avoid doing IO for zero-filled
 	 * folios. The zero mark is protected by the cluster lock, which is
@@ -322,32 +342,15 @@ int sio_pool_init(void)
 	return 0;
 }
 
-static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
-		int rw)
-{
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
-	struct bio_vec *last_bv = &ctx->sio->bvecs[ctx->sio->nr_bvecs - 1];
-	struct folio *prev_folio = bvec_folio(last_bv);
-	size_t prev_folio_size = folio_size(prev_folio);
-
-	if (ctx->sis != sis)
-		return false;
-	return sis->ops->can_merge(folio, prev_folio, prev_folio_size, rw);
-}
-
+/*
+ * Callers submit a pending batch that @folio can't join before adding
+ * it, see swap_writeout() and swap_read_folio().
+ */
 static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	struct swap_iocb *sio = ctx->sio;
 
-	if (sio && !swap_can_merge(ctx, folio, rw)) {
-		if (rw == WRITE)
-			swap_write_submit(ctx);
-		else
-			swap_read_submit(ctx);
-		sio = ctx->sio;
-	}
-
 	if (!sio) {
 		ctx->sis = sis;
 		ctx->sio = sio = mempool_alloc(sio_pool, GFP_NOIO);
@@ -460,42 +463,45 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
 	bool workingset = folio_test_workingset(folio);
-	unsigned long pflags;
-	bool in_thrashing;
 
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio) && !synchronous, folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_uptodate(folio), folio);
 
+	/*
+	 * Don't hold up a batch this folio can't join for its lookup
+	 * and possible decompression. Submit it now.
+	 */
+	if (ctx->sio && !swap_can_merge(ctx, folio, READ))
+		swap_read_submit(ctx);
+
 	/*
 	 * Count submission time as memory stall and delay. When the device
 	 * is congested, or the submitting cgroup IO-throttled, submission
-	 * can be a significant part of overall IO time.
+	 * can be a significant part of overall IO time. Reads are batched
+	 * and submitted later, so the windows close in swap_read_submit().
 	 */
-	if (workingset) {
-		delayacct_thrashing_start(&in_thrashing);
-		psi_memstall_enter(&pflags);
+	if (!ctx->in_batch) {
+		delayacct_swapin_start();
+		ctx->in_batch = true;
+	}
+	if (workingset && !ctx->workingset) {
+		delayacct_thrashing_start(&ctx->in_thrashing);
+		psi_memstall_enter(&ctx->in_memstall);
+		ctx->workingset = true;
 	}
-	delayacct_swapin_start();
 
 	if (swap_read_folio_zeromap(folio)) {
 		folio_unlock(folio);
-		goto finish;
+		return;
 	}
 
 	if (zswap_load(folio) != -ENOENT)
-		goto finish;
+		return;
 
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
 	swap_add_folio(ctx, folio, READ);
-
-finish:
-	if (workingset) {
-		delayacct_thrashing_end(&in_thrashing);
-		psi_memstall_leave(&pflags);
-	}
-	delayacct_swapin_end();
 }
 
 static void swap_write_end(struct swap_iocb *sio, bool failed)
@@ -709,9 +715,19 @@ void swap_write_submit(struct swap_io_ctx *ctx)
 void swap_read_submit(struct swap_io_ctx *ctx)
 {
 	if (!ctx->sio)
-		return;
+		goto out;
 	count_vm_events(NRSWPIN, 1);
 	ctx->sis->ops->submit_read(ctx);
 	ctx->sio = NULL;
 	ctx->sis = NULL;
+out:
+	if (ctx->workingset) {
+		delayacct_thrashing_end(&ctx->in_thrashing);
+		psi_memstall_leave(&ctx->in_memstall);
+		ctx->workingset = false;
+	}
+	if (ctx->in_batch) {
+		delayacct_swapin_end();
+		ctx->in_batch = false;
+	}
 }

