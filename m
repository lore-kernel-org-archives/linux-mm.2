Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED0B3CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 14:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51D756B000D; Thu,  4 Sep 2025 10:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A6FE6B000E; Thu,  4 Sep 2025 10:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3959E6B0011; Thu,  4 Sep 2025 10:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F2F16B000D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:35:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9811FC021D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:35:20 +0000 (UTC)
X-FDA: 83851815600.26.9FC5FD8
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf13.hostedemail.com (Postfix) with ESMTP id CF6A120013
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:35:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=M1wwJPsC;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=pu2X0aL+;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf13.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756996519; a=rsa-sha256;
	cv=none;
	b=ZNQNf5Xihe3yTDp/QvQXYzhbvRq1/dLsKwNG/o/J4l7IQ5ZdEhLTrJitbCeGHA/pyi2Yf7
	1xhxsXEmgPEC90XVlmM2WI8V1tMTCEXaWAyDG5Z2mQqx7J4jiy/wT6p1pi/pJzgcWgQsM0
	JBVXMA/x5Hy35cbCxgTpn3Xw09up73Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=M1wwJPsC;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=pu2X0aL+;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf13.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756996519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9oHxHHCltjtUcL2x2xKvtP9IoeX3he+q3ztHgAhmdDE=;
	b=P25owE8IAe0mpCzwEFIz4g0qaSd6kVZPEP32Nqd/Q4gvuOg5G/FnPG4g7OMwkiyyWgAjCx
	MFyNsML0g/RPfuENw5C3hXwxESSzQN8BoWL2g6XxHxdd8CX/VvJ2YvkCnmyxLWemQeVz8g
	DAR5tAYUZiDJb7Mn1Q42sRfvDJBul70=
Date: Thu, 4 Sep 2025 16:35:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1756996515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=9oHxHHCltjtUcL2x2xKvtP9IoeX3he+q3ztHgAhmdDE=;
	b=M1wwJPsCusFTFf2N1H+wAaEiMBTsGC7Ux1jxSltt/jef+niymmSaxFsJxx/FEyLK9B2XbF
	hhf1N9Alqg2W4It/0K7TTpiWbidga9FmvCNNB5KvP2T0tKCCFgdxdGL3/bAOsKiQXW6FfE
	eYNnjWxPDI1AYgh2bXwOXYtZEgyVsKmfiRC+CmmL+xJXbAHiRyTxkx7WKOrK5xSXMHuUw6
	r9U/2gQoESEAHCrCIox50NhTblLYXgusU9CuWqwquFTCzhW4YaoVD6QeyebGp6WZNDIhpj
	sHR/89xnbYKq3XkydklYSrTJEYQgwhyqWV9Xb02fPh8fQ+B3cEZe6m/uyLhwfw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1756996515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=9oHxHHCltjtUcL2x2xKvtP9IoeX3he+q3ztHgAhmdDE=;
	b=pu2X0aL+DvtHo0T9YUVGSioWR58nmu7ulRdt1wYvAmeZnRNtfkY04k+gL1KsPO+8i7IOyX
	7tiZIStO/7XfzPBg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-mm@kvack.org
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm/percpu: Add a simple double-free check for per-CPU memory
Message-ID: <20250904143514.Yk6Ap-jy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: CF6A120013
X-Stat-Signature: s9nyqdtnuexgphnpyggqjajhnbax9ut4
X-HE-Tag: 1756996518-83387
X-HE-Meta: U2FsdGVkX1+I1unMS+TlhBhcjLo4V+m5Fw3AYOcTXlJVZ0p2Y3YzF/zXIqQLoE8yoPbS/UXtpaHoe9Wsfdnr8nAgxCg0h5FCDbEsw9n4I/wAlLk1dl4xAHAlqjGSNcueRXvnvrzFHNQOdFMWAFRqUchKOwdhSUcm0tL7IdsTRytAEAtnB4uIwVoBcfbSZ001Xu7C4cGYi8TEeCBUu1Iq4VUeTDQeN7fp+besJ/y4mQVDEXsEQYi14ZU6YRXODj6TfxaEg10kGMGOp0Dw4u0XUS2T9jMUqn+uCR+LUPvseACdpNx3f3NtfImjngbK16IiGWc6TYD0RzieBk02g9N6tZ6yFkMARkyIi+JGUHNaRz/Yvb3qLH4LztkTVsNp7jssjzcCvJJtnnmqDrBtTU5XXqDcj8fWXpXeEUKyaA9n+JST2EF59WSgkCSwQ0mejPLRM/jT4YXjVbPg9rbLSr36QmsVNPIqx+vTpN36pmR1SQQDXR2wKQLRa5xrtOP3ReWl7oj7X087bRIhOs80w+4M0Xx4RDqaARTe2Y/sJXfYugdfXTTe0Itnxv4SICUh8LZBNos7QC+YOLuTkLgCme3sWgcKdS5cKQk451uT3WCfaf82f5+2XRoser+iYyYtSZmItXh4nTI6kx8LJ2ctP6taJkBwCYckvYsdMXjkryjMzTBheJLTbmUh+/TmFnaCnhnKSorpxPYpXxCYygKYafMLViFozjay00dmGcpijejxNPIB52f/xtZS3fyAtYh9tyW+D+6gXF3WW76WBTC639VQ7nYhazv1Zft3Vcy/ybo93JhBGzHaopqIs3vpPJ6Wkcb+Q/Ap3WldJ/Tu40LevQ5gJi06VrPC2bWLuhJ/NLABQRgxXIalz7WIZxGsjz+AnWn/5Jq7UDY7RriAKSBbd64fxXynvOhqTO2hL5d4QJ61ztkuVbpBJv0G4uX2HyOUavw/Dze5EZ46BjM9Ul8cKkH
 xL/QrkGj
 GbPqVza2tJ+rXxohL0NcEvVMl/s2z6fObeNOJhViVrZm1O+aCSSZbEjP/tufsILtYjk6DR7s1ElUeqY7pmvtD1UKokCFxNt1XjX0B/gezzz0rnUpYO0xSKOTDTrkQ4J4xqlfOkwTiPFVg5p5f48gVrukPlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The free path clears the allocation bits in pcpu_chunk::alloc_map. A
simple double free check would be to check if the bits, which are about
to be cleared, are already cleared.

Check if the bit is already cleared. Issue a warning and abort free in
that case.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

I managed accidentally a double free recently. This would have noticed
it. It looks low overhead so there might be no need to hide it behind a
debug switch.

 mm/percpu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index d9cbaee92b605..a2abddd85294a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1276,7 +1276,7 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int alloc_bits,
 static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
 {
 	struct pcpu_block_md *chunk_md = &chunk->chunk_md;
-	int bit_off, bits, end, oslot, freed;
+	int bit_off, bits, end, oslot, freed, free_bit;
 
 	lockdep_assert_held(&pcpu_lock);
 	pcpu_stats_area_dealloc(chunk);
@@ -1289,6 +1289,11 @@ static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
 	end = find_next_bit(chunk->bound_map, pcpu_chunk_map_bits(chunk),
 			    bit_off + 1);
 	bits = end - bit_off;
+
+	free_bit = find_next_bit(chunk->alloc_map, end, bit_off);
+	if (WARN(free_bit != bit_off, "Trying to free already free memory"))
+		return 0;
+
 	bitmap_clear(chunk->alloc_map, bit_off, bits);
 
 	freed = bits * PCPU_MIN_ALLOC_SIZE;
-- 
2.51.0


