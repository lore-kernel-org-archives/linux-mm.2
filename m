Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01580CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 12:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 681A36B008C; Thu, 28 May 2026 08:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6591B6B00AC; Thu, 28 May 2026 08:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56FA66B00AD; Thu, 28 May 2026 08:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 431A56B008C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:47:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 120331C1FED
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:47:05 +0000 (UTC)
X-FDA: 84816803610.19.E947851
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8743DC000F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:47:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=VRvy+qQy;
	spf=none (imf22.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779972423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJMsMRIF5IM+fJmVzgjQ95eujClDVXgBkFGizVuMrmE=;
	b=ro6qTE1557Zy6cpObHckhnz53yt/QwymqgJeE4ojK6y9HzH7c73uUlwkjWWCIgPpUaKCcR
	5BHDvReXtmJ12waVI5SrSXzRVeOUyGpdxgDK8XguytScxt++MttZpvL8jb8g0lQP/vccmR
	fAxYGZKsOOduNlgkGbwmzEbUwEVFTVs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=VRvy+qQy;
	spf=none (imf22.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779972423; a=rsa-sha256;
	cv=none;
	b=biCfXsCOPxDXdQaMOxfhk64B+Fq+9AhYuOrm9Jk/mCyIp9rSWd76wzS1ss5yJ+VuY2IAqj
	hMDlzukUEKxbdQFZbFgwropqOFpMkP39BcslGW1TugjZ5kmRdyt2u4cih7AOf0Uf4XhEkV
	3KVnXRDv4aZPiEIgE6YtoyvPN+tV9ns=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aJMsMRIF5IM+fJmVzgjQ95eujClDVXgBkFGizVuMrmE=; b=VRvy+qQytcj9Y0/LnhSCar+Hs6
	ejTuqQXuUViTOvoSI86pPOBpr1z5PNuQyBzccKm/ViUUcm2DVcNwWjsTcwhV2LmWf04F0Krx3Rg/w
	hB+I1hUqPGuiDfodKZn+xQrLd056cY3dAlM2YOVwTwZmIE1ryIX4IqEsyUd7E62NmtHynUFSp2Y3X
	hMkmeJeY4Fe79234wxGzhJlNXjgbl3+6NfSs8ON5YTpM05GLJ+uugMzNGlS7mvalPXyHmV9Tt5VMF
	Z9OtC0UlIQcKRky5CndvXXKtIeM7RllEs1F+STqNeE5nG2agCdwO7y+JCRaWuEPh6JJFEUb6KBrrZ
	KBk1shHQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSa8T-00000005jjr-0xnU;
	Thu, 28 May 2026 12:46:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: [PATCH 10/10] mm/vmstat: add NRSWP{IN,OUT} counters
Date: Thu, 28 May 2026 14:45:26 +0200
Message-ID: <20260528124559.2566481-11-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260528124559.2566481-1-hch@lst.de>
References: <20260528124559.2566481-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8743DC000F
X-Stat-Signature: o4euydcx7ntgnx9tcamjuqem3isdeonn
X-HE-Tag: 1779972423-170789
X-HE-Meta: U2FsdGVkX18Zx+4bWtwQZPXQhA/r8pkgwvk8Ftu2lsjoBFwpkq31RhqkIvtn3ZHYd3F7tB8ffiPy1DiEn3w66vwkV9zHVfHZIBQXk6gj/84PU2OvRgEnRWslmMXrYLPChXX/0vI4nu3hEbSdOudpMOJiLt9dQ10RW+5agMst/BxRoEQxc7U8wTpKM7VNUuBUF0P+m64c3V4mytv1h0XJfDPOGJWC9vOSK9z1zYTjvc90a3OQUcK3qSgOZdk1v5aTj/nRut9EmLbJSIbQeLzncYKo+9mokvlvMT7LzvUPmDGs9R7nyUsgvK2X4D309Lxr2D66Wm9pbf1gYPEMezOmBH1PsGHmC2VgkgFAhyv0J7jrhDaub6gbxjfEwMB/UQKkz9Prp//ns95oVxgG8I3HdgzCkST/dNNHa6d+w4aZQwP94lQ1YF55IE5rPbv7efJ2E6NANiuPX/AkuWVgLlS8+M8aO0KnynmfYs1/xkj3mjhbpjAvca5cdQ/T97aTdo/qZwjg1omAYls3E2t1zsWCcjBuuiGpaBzgKEycRXQkEHer5XkhApkm8x8Di/PwYw+mj2ggpbjaCm/FfBLUGWZHr0DN8rLGxqNFiYYEYAFC0G8J7LzhlJiEfjAylSZr9IBQ79w3Sseyo+WlGPyghWEtNmtLE8OUyoxvh+LP4h7NLUvZgT2HATjkaeFhP/Sin0znqKJFmbItQkZlu4lzHZZrVW2a7tyMyt+xQ0UEdiQWNLHfNSLe4ig/2/iw0ZMGOHTIEOevsXxcEOV1c+aR8KdVPwMMtExzutISgKDqIQUjZZNCvEwbtfy3014KabnzjnB2syJZcvk5/P3HJZ3eaEzOb38fRMsvPFkaHemvyQT1xelQKswDWB2oALLX3MCCxBD0l7l0JzG44sfDqyQk45h7hpw3yrVvqoY+636uf4I24D77pVjSZzZc0AsvlE1t3Gh/dB2FJZzPoW5HHM7Z+x/
 ERp4M7fw
 ZuPxcas8aHm0Cg96KXBeXaInX4gnkKSE8vqyx1PNnb9pOqcYx99ZjIcCsNfl8CVBZq2tQ/OhKNdB5WJSOkpQxYctvxc++mG0mDp4trf5dGyYIebx9fbdMilRY4VDySrkhb9lHo4sa1eeMfcLmj6REcnp+ACR4EmYsEI0PNcVAhJgQyuSC0A9GJ7rMJ8Ct/2BewFj6FXyiddhHBQgFbUr5Yb+cjTpcqY+c4/UFebPYQr9XrdysmSOPwh9hmZ1B6jJiQzt39ghnavj+iitxLoRirH7/SLLWMYVDeKYsDM5JBOB/AoW4wsdUTBfZLKfCZ3A8/byd6C9SWfah7ICnHeS0KpNJoddVSRkrVgsKxhR1YRSihODsVxn6/AX71DNv6mO6K7nfCG3/0wUx6Vb40OkVp126PjHg/Ur0xl/sw8P58L67x8VSY3pNBuRyL5jmm9pWJmVeBxd1QDgOsqy9kUznhhYGXZNPy92qDkY47QH3kZjbx3KCf4QrlMb8Ancb6wpGa/G9/hLdL36zbjScQ68RV0LyKDNyWnOWCAUTOvQEhvZ+8M16SCwwHB6iOY6NGb87eIvUVzyiIpk8eDXideaw80yGGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Count how many swap I/Os we cause.  Due to batching this can be
different than the currently counter number of pages written/read,
and tracking this information is useful to see how efficient the
batching is.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/vm_event_item.h | 4 ++++
 mm/page_io.c                  | 2 ++
 mm/vmstat.c                   | 6 +++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 03fe95f5a020..2628ccda076a 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -175,6 +175,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		KSTACK_REST,
 #endif
 #endif /* CONFIG_DEBUG_STACK_USAGE */
+#ifdef CONFIG_SWAP
+		NRSWPIN,
+		NRSWPOUT,
+#endif /* CONFIG_SWAP */
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/page_io.c b/mm/page_io.c
index 3947607f919d..73d486676f23 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -679,6 +679,7 @@ void swap_write_submit(struct swap_io_ctx *ctx)
 {
 	if (!ctx->sio)
 		return;
+	count_vm_events(NRSWPOUT, 1);
 	ctx->sis->ops->submit_write(ctx);
 	ctx->sio = NULL;
 	ctx->sis = NULL;
@@ -688,6 +689,7 @@ void swap_read_submit(struct swap_io_ctx *ctx)
 {
 	if (!ctx->sio)
 		return;
+	count_vm_events(NRSWPIN, 1);
 	ctx->sis->ops->submit_read(ctx);
 	ctx->sio = NULL;
 	ctx->sis = NULL;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517d..9559f3c95735 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1488,7 +1488,11 @@ const char * const vmstat_text[] = {
 #if THREAD_SIZE > 65536
 	[I(KSTACK_REST)]			= "kstack_rest",
 #endif
-#endif
+#endif /* CONFIG_DEBUG_STACK_USAGE */
+#ifdef CONFIG_SWAP
+	[I(NRSWPIN)]				= "nrswpin",
+	[I(NRSWPOUT)]				= "nrswpout",
+#endif /* CONFIG_SWAP */
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 };
-- 
2.53.0


