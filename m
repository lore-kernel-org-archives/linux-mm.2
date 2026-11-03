Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEE9D606A834
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JGg3YZ7Y
Received: by kanga.kvack.org (Postfix)
	id CD8D66B05C5; Tue,  3 Nov 2026 05:18:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAFC26B05C6; Tue,  3 Nov 2026 05:18:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC5656B05C7; Tue,  3 Nov 2026 05:18:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C6086B05C5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:18:17 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F5ECA037F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:18:17 +0000 (UTC)
X-FDA: 85393407834.15.2E40635
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id 445E5100005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:18:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JGg3YZ7Y;
	spf=pass (imf05.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793701095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RHjaZF/zEkaSXrLeJORF1ZXTNpz5Xq3a/jlyVJC+lRo=;
	b=291N1PNEjogJFJjzYMklSGrGHZBOrjEB5kQEupu7/+FHY4n6WR2c/NA7i+0nyB8uunzYEs
	xsWUAwcYiQpmtyhi2Q7uH7/mrpkiVIbdAyHUFehi0VdUHanoebON1jL79cHAvzyuxQOH/m
	FDBGbVR6IedASQV3bf1ihkbzOcC2BW0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793701095;
	b=UU5y6v2Mrk1HcERQNMnm7vL8PZ0cFxchL3Q9L+8ZrA5RnQvwqYHve6i2xilGLLaM4ov5h4
	M/yGmzuA1caRgIBqr6oDyRfD2xg3gnXa26WwlZn3cHYGmqcYARWk7hpQOFspDdBX5nV2Fe
	cONRVBaCtKpVQeva6pOpCCiPaXcb020=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JGg3YZ7Y;
	spf=pass (imf05.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-33fb4680717so6561568eec.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793701094; x=1794305894; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RHjaZF/zEkaSXrLeJORF1ZXTNpz5Xq3a/jlyVJC+lRo=;
        b=JGg3YZ7YMqL6mtEeV4vgaikgyqR55u1aN28OWn18o1MGrzafCfPHyzrmq/7QVbVrIx
         TMQmvSyCit+Zn/8xFdf7j+/8cXT3zLRtZ9GP+7nAD6PaxNjx1s/6x8RD1NCKFzFm0rQM
         od1oqr7DarbzN1BhprBh1+yvQ1r3WZK1yHz1nGQkhezc/IVHc2keV+MbBxMd90GW7N52
         7MkYK/UOmuVfZq4qfioC+ffP9cfeaLyPoYHI9n2nCG+zocV+qv6vbjDIY1qoofUkwEHB
         riwmKNlBPzMNYPucGfcyy1DBUsQethEk7Vwt7176Mr5DHG2vflw0U1SjFepcjcZzjGog
         jZWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793701094; x=1794305894;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RHjaZF/zEkaSXrLeJORF1ZXTNpz5Xq3a/jlyVJC+lRo=;
        b=HVzW33SFvNTujB5hESUmr72U7uVmIv9FsMWl2To+qlrmCssNGbiIGN8Kiqn5yX5rFR
         /FF81KQqJhBn23cV0CH8ypylDS7TyqtkEmUMODYBAWLLO7qjSTxAQ1AX2VhPNVSndYA5
         9vwqMUwNQ90bi+NRbXZouFjwYglG2/WzNIkDkKYqC0OkICKAdlFfS47BnQLltn47iSfo
         vBv3rVXuXnRrVYVbGRyuWg+PtNcSJDb4mvBkoGFMGklfYlXXiQjGqQO+BFtGYvL/E4B6
         9iF+MePQotH/jN6PV9FsX8qWOi5u6KQU3HH52fe33408A9Uasn7GDmsGwv89iB7gcamc
         ZUlQ==
X-Forwarded-Encrypted: i=1; AKwUvBxRsFhGlpLNgTLktTDH8Vl2jV2gloZe9x1I31jVwbyI5poeGQ/GGlobqB8q7OD5+SAn5XK4jUqPYQ==@kvack.org
X-Gm-Message-State: APuU4Z91Gyq6OBFgcppmPbwEldznYoGCxlbPn2G+fRT1KdSA6hikbWFy
	4qp0JI1NmCZrFi8cc8+/WD+RUQaHvJq8aWcDj7yMQiWaELvDdU1m6twb
X-Gm-Gg: AYBFou3uXoSdSMbAIcMVP1gxdF46uBqRC6nbxz0d1fRr9QuJdG+kL8iJWzFPMEDu6lR
	h6IO4ZeMUCNqGhKZF0N0xeWtftb6CUuOdmDwnE3Xxb1YZ9FlHuhYx5VL08sabWbwDZ3Osp9pV1c
	rTLI0Vk7dvB4Emuf8K4sh94WFnZemPkc0Pv+sxY8moLNqMuEkd0tiOENjG65Ly7FRLtNBAXmgmv
	IQSd7mB9J2ZPgejf4XQezbw96qnNm24a4pdVZmuvgWv/jgdL5qwhrWygHg/Y2MDT/f9WV56pgQ5
	+RmNk4OWuc8DY4E5V9QVhWfefHL57rUc6vW+CsyE/kW/CFJzl2PqFniliFEprZEQ1F10PoQBq3t
	Q+ej9UqLaBYe58PHjGPr8sm5Uas7fPP6dvbzqR1qW7R23ADikQWLLKY/oG1iy2yIFlHAXdGUPOF
	NLuZ8HN2EXYvEmUnTkw8/fm/WHKnVzcoM464g6CFPW/QNp8mODfWTcYvaFkKUHGeveslJBm/uvS
	4rc27CcgxZpdS2h1PTIFCTpvRR6MePSEihdb9rxx8gDTdmByFHObDEmXtzwAagc9nuSe7TzCkCV
	PHq6TaOikoaiGhP8n6zBva2ICLEJ1w==
X-Received: by 2002:a05:7301:18af:b0:36c:9b35:5d45 with SMTP id 5a478bee46e88-36c9b356dd1mr806355eec.25.1793701094017;
        Tue, 03 Nov 2026 02:18:14 -0800 (PST)
Received: from 027.. ([2409:8a20:4a5:7150:84fc:ce3c:7b09:dbca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a4291e38fsm53145387eec.15.2026.11.03.02.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 02:18:13 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v11 09/10] mm/vmalloc: map contiguous pages in batches for vmap() if possible
Date: Tue,  3 Nov 2026 18:16:57 +0800
Message-Id: <20261103101658.766905-10-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
References: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 445E5100005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: wib3audhywhm9z5eqkm4ps84mwzytwzn
X-Rspam-User: 
X-HE-Tag: 1793701095-712461
X-HE-Meta: U2FsdGVkX181x15Po6+DzTqHM4qeUPDL1aa8uRvNcLvrGyQ+aVs8ivuEfwiPy1M9wAEQHuTByDZ0gI4K8q+Bp68lG6gly1FCZXJ/apo75+iqEOc0S32h7S5LvZKtCSxk6MtrK5ZYop/yxOEvq411/SyI2ATmV67V0NCtcs3SlKGrDDDQ/VA626a6A7XMM387DP0M1yHpJYmjCUzCnPSmJUcY9C+IfnYZE21Mmz4STxgxZQqWtIhoni4h7/3WUKfYrz6j6vh3dF/Cjlf9uis4ux15A9ejX1IsnHfQHYEn3KXmWulbIqqOqFPfajojMzrCqWmaTw0qpCGr6iH5a8ah3RXLE+RPXqCSidbwEFnECAoifmlms+7yoOp1/RTAzOS1J103R9mZ683+tM/VRtQlv+svRUmI8FTUL8nKQzkYuxFAf7Ne/T0drTPIXFPrFIVhQ4twWbG0YwBiOYSJ+/sjAHsmP2y3zXV5Gt9n0qre7q6x1cqjQxu2DBMdXHhSEBkbBhP7c+z6+x5WpDtsYiOQywoxxrZ7ueowEmCdv8/n4Z9K/1x1FJ9UJqm3tupgkOng3LHaUIkknyfQWnkmTmckIQ3td+9ibsyo4JtThIKbC2KKHWqWYp7w9aHDP0v9kR1bXEepHaM0vo3XnCXRyENQupPGZLrcNBjwqvB9PIAIEg3U/kudj+YMP2zDGUWn04Cp+I0HsMB5mO8NOFyEwurwxIo9ElxybKmu/nvLJ0PU3CUIYOUu9Qw28LwBDZSBDOLTHcS1BNg7jWUsRngq5GgIO9jgxoPaAMUwCtHCsCg250SNCEwpnYxDRmwoxH57HM1EGR2kLnulwL5AVkGNDzQMhSc4vvLIxyL7b9eq8N6sGFC2Cfymo9iVH42LC8zb+34jUPMSKRw7ZiB3F9Vad8ItXA0c+hgDKSIIGMt+zGVAsJKt/PtzMEyWvn7Cz6fCYZizfnKjApVm/sTaMUTH7Wo
 beMs2WKV
 Nv8VTloD7cZgXozyRqNdxWcNLpIAyKUj16lYiT4ai9vuHwUU93vvwbdtp5ptCuysnz1cBTqWADFheJ+HOeRSSvM+DEVtEGgsmNT0/srJOuIYbBEftbgxVhh4lJMZTo4rgnZWfY3q8it8NsgRRoRjJZ+5pF3LQD/pB5GX6PM/ozu0O2ZGer7hcz2rkG0kBnmuZ4zXWwS7EKpKGM9Owf3z/olp6U3CQ2LgagxXRKJ6MRJLA/P6FluJqLo7g+jNxkis2uXqcUan+7rTTIpg/alkTRxp6jM1fqC4oPEgm93stBvM4T1XgyIzWyxivW5wrs1UXFHWumsWfqqtZdUQfVDjya4dXPe/Dp9V183o1yDMujArDS/BD20gKUpXTDSn1Ax0mLNMPLmlak5/0ma/I0J1mhUuiHGdN70rXN7b0pSRVuj92seQEj3RQZepxKJpmc51SSL7Gb6U59csBzthO6T8bOgmIrc7kRDD1EERVTqL7WnnNw5HwnPF3CS5FA1i52CTVNeyaIBAbhR2rOhQcEVSRW/ePmiMS3SyJTsPkZr5nyWNaOGPP91sBrwICmHfmWRxkqe8VhzaMr0dO5R3zAxPEWCfmHboBUjNTZI+GY29r+zVjNhs7oNrnOZaxGo4nVhTRRbar
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

In many cases, the pages passed to vmap() may include high-order
pages. For example, the systemheap often allocates pages in descending
order: order 8, then 4, then 0. Currently, vmap() iterates over every
page individually—even pages inside a high-order block are handled
one by one.

This patch detects physically contiguous pages (regardless of whether
they are compound or non-compound) by scanning with
num_pages_contiguous(), and maps them as a single contiguous block
whenever possible. The mapping order is determined by taking the
minimum of the contiguous page count and the pfn alignment, allowing
graceful degradation when pfn alignment is less than the contiguous
range.

Pages with the same page_shift are coalesced and mapped via
vmap_pages_range_noflush_walk() to avoid page table rewalk.

As users typically allocate memory in descending orders (e.g.
8 → 4 → 0), once an order-0 page is encountered, we stop scanning
for contiguous pages since subsequent pages are likely order-0 as well.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---

Sashiko review: flagged a potential NULL pointer dereference -- with
HUGE_VMAP enabled, a NULL entry in the pages array reaches
page_to_pfn()/num_pages_contiguous() in get_vmap_mapping_order() before
the WARN_ON(!page) safeguard in vmap_pages_pte_range() runs.

This is not a bug: vmap()'s contract requires the caller to pass an
array of valid pages. The WARN_ON(!page) is a defensive sanity check,
not part of the API contract -- passing NULL pages has always been a
caller bug. get_vmap_mapping_order() runs on the same pages array that
vmap() received, so a caller passing NULL pages is already broken
regardless of whether we batch.

 mm/vmalloc.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ee2c1ec4ff1f..42b3addd20f9 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3613,6 +3613,85 @@ static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
 	return arch_vmap_pte_supported_shift(size);
 }
 
+static inline int get_vmap_mapping_order(struct page **pages,
+		pgprot_t prot, unsigned int nr_pages)
+{
+	unsigned long pfn;
+	unsigned int nr_contig;
+	int order;
+
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
+		return 0;
+
+	/* Limit nr_pages by pfn alignment */
+	pfn = page_to_pfn(*pages);
+	if (pfn > 0)
+		nr_pages = min_t(size_t, nr_pages, 1UL << __ffs(pfn));
+
+	nr_contig = num_pages_contiguous(pages, nr_pages);
+	if (nr_contig < 2)
+		return 0;
+
+	order = ilog2(nr_contig);
+
+	if (vm_shift(prot, PAGE_SIZE << order) == PAGE_SHIFT)
+		return 0;
+
+	return order;
+}
+
+static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages)
+{
+	const unsigned int nr_pages = (end - addr) >> PAGE_SHIFT;
+	unsigned int prev_shift = 0, batch_idx = 0;
+	unsigned long batch_start = addr, batch_end = addr;
+	int err;
+
+	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
+					     PAGE_SHIFT, GFP_KERNEL);
+
+	if (err)
+		goto out;
+
+	for (unsigned int i = 0; i < nr_pages; ) {
+		unsigned int shift = PAGE_SHIFT +
+			get_vmap_mapping_order(pages + i, prot, nr_pages - i);
+
+		if (!i)
+			prev_shift = shift;
+
+		if (shift != prev_shift) {
+			err = vmap_pages_range_noflush_walk(batch_start, batch_end,
+					prot, pages + batch_idx, prev_shift);
+			if (err)
+				goto out;
+			prev_shift = shift;
+			batch_start = batch_end;
+			batch_idx = i;
+		}
+
+		/*
+		 * Once we fail to batch pages, we expect to fail batching
+		 * for all remaining pages, so just give up.
+		 */
+		if (shift == PAGE_SHIFT)
+			break;
+
+		batch_end += 1UL << shift;
+		i += 1U << (shift - PAGE_SHIFT);
+	}
+
+	/* Remaining */
+	if (batch_start < end)
+		err = vmap_pages_range_noflush_walk(batch_start, end, prot,
+				pages + batch_idx, prev_shift);
+
+out:
+	flush_cache_vmap(addr, end);
+	return err;
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3656,8 +3735,7 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	addr = (unsigned long)area->addr;
-	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
-				pages, PAGE_SHIFT) < 0) {
+	if (vmap_pages_range_batched(addr, addr + size, pgprot_nx(prot), pages) < 0) {
 		vunmap(area->addr);
 		return NULL;
 	}
-- 
2.34.1


