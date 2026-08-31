Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EEFBC624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 452936B009D; Mon, 31 Aug 2026 04:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DDA06B009E; Mon, 31 Aug 2026 04:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6DD6B009F; Mon, 31 Aug 2026 04:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFECD6B009D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:27:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 664D740396
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:27:59 +0000 (UTC)
X-FDA: 85160886678.29.1A40616
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id AD61F180004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:27:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cvmsrp/R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788164877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zXWRkm+Wfn8w+zGyJ3glKrxRz07Jsyoil0yx8XutPKA=;
	b=W3bYNnuecgunR9PL9lF+5t4JW5NAVPVqAq6qDv2oNG2JhO/lR6ofQ6N67nF0o43+0hsLeM
	9ELnuTv+FWmhjVlTFrQdeBRYMpPuTcX6nlBNQZti+K7zHBpyTeNiOp2PLcDIqBQr4Rx4e5
	EjKCjoU7nJ7jtW3vXHD6+c2teIv2vew=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cvmsrp/R";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788164877;
	b=EWRGdtX8U1agxT5zIRVlwPBSyjgY11nM19f/Kbn4kTpPAlbo3o+POomT0nLD7+ZsNsKr86
	Pp/MYFuv8QnvGTKXQFuFgMdIPj4euQS9SQbmAVwyWNZ8menJqPTTCI1cLqsfhDBZfF7cIM
	Wqc6qj/fnXSuKKgVJ2hYAjpkFTzaVp0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 013574018E;
	Mon, 31 Aug 2026 08:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8111F000E9;
	Mon, 31 Aug 2026 08:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788164876;
	bh=zXWRkm+Wfn8w+zGyJ3glKrxRz07Jsyoil0yx8XutPKA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cvmsrp/RtsT8dP5IEl7OA8SYmLdkon9cbY+CdI3SnhrNz8UxoqcNjnhM5aotPogw4
	 x4c0BbG5Ah8Z8fMQNLKQiJxzhGHFydk2zAfy2XqnTxF6ygIl60OpHepenBw6uX3pmg
	 voJMeFM1p2LkEqQReCFbLYObygRjiTAzotVUaTB9ltvG+XqcTuyedptECBFyTMNr7q
	 Xq2w1mD+t7r6dqp6u4lYZFv5f17A0mkIhqLyu8LRSr03mCO4VD+9g0kP4cO4pyhIoN
	 wMCcswUTo6dNqAMzYtlixVmfmnCwbtaZ56fFzT1x9MSGFbs1VQF8qI0ymt89kjktav
	 LFx1T/R8nImZw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 31 Aug 2026 11:27:44 +0300
Subject: [PATCH v2 2/3] serial: core: replace get_zeroed_page() with
 kzalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-tty-v2-2-88cd58c3c640@kernel.org>
References: <20260831-tty-v2-0-88cd58c3c640@kernel.org>
In-Reply-To: <20260831-tty-v2-0-88cd58c3c640@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.17-dev
X-Stat-Signature: i8ixwsph6phyw7hkdab5jzxx5uwrwshq
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AD61F180004
X-Rspam-User: 
X-HE-Tag: 1788164877-719213
X-HE-Meta: U2FsdGVkX1/rKTD35RCzBWk+IKRD3HVJl89xsYKZKiqsq9biJwwL3Cy+tX1juH40I3P67fpJheTDM15jh5R/yG0UjM+f7we1kbYLBxL2WQfIrytIaoSeF2Wu26fmYzieO/bzFFKCCbp0BsNWdbX//naMD7aBs5FkkwR+bmx0TwYIxB3W8iR4PaS/iBqLBQBW1c79W/t+PaaXDaJP+SxNgmh1ldsPofw4tdlAT2OKHy2nqZzuUzYwV0hBFBJhFKhWxmoB/tALfh+jKumWJf7u2Bq4h99rvpbzqA7qAJE/jCIONpS6cwRuFnn2x2KZ3seqhuVOvJdBG7AVfM5J5HeRqnq5ALTC77PSnnLfN5v4tRlnG7FckD+OZcmH/rQrWR+4Ghmpl3sX8dRx1gZCBYCFV5M9sUbwOJe1PneyYuI1L6zh/PUPJmLUybmsvz5EFB7rNv9iiUqgVQYPx84FL0++S+RS1qjVyus8nyf6WZRdKeO4QdP5MSdjtLZ1qQoORONnu1SyY+RVBJjvjoUaI3tbqCqBWWYAVBHq/ry4HJv3aaZC1L5akyp3ljdyLR853s09MmRuna0YQOkoKZeGHG7F8Ohc2Xp8pLe2j3XWprxQzFvCo6YBtOCnl6mFQNJBPFd5EMrIsiysq0x6wZseD4bIu7i6E1q1iwCohzhPeKNlc2lOihpGG881yCvRI+5b74yjqvlARfBOpg6Iim9+zs08eQIan4eMBUoz/nZAiN4a3AypDWC2ugsVzSxDveklrN8wdPhIx1ubpRiEA1JApdfLMKjT8ibB0hVqlysM4I4sZx1YgU77LmdGCLj0Dkkjpv8R/UHnlN4EARTtTTV0ejIyI5Wlz93A3jcOsjaKf1JHDS2qmqDYs1MOYA+HBwfXrP+0X+LIMWeSaw3ml6oEDdzM9A/kKgNyWoVDn/8kK+HEskQbcK4aQ0cIhrVNu20v0i4UrYN3Xo3US2fdl72Q6wF
 2zyInMu7
 0DS36mTq3NCwb+YShBB5RqiBtv6YC8qkuX08ls4SEY/8uZ5UksgiFbN8LGEn5c6zAOvvCTl8xV+r1mLgghmXNH+f3teQLGF/CzVEAAFa9ywbL7FPAzdJNSa7sgb5ws9Kx0Yh3inBxmZgDRCMiPtSjokzZVbBoxgmo4olIreL+FGhbiBnnfi27ChB22YMr/qr3/cfZEQYrp8vpsyQuAb30w0kcMlUVJl1ZYMlUi3EeSMW8J+vkvwPE3ty17oyc1ZxsMzTOr6sMAafSRzFDMIwo8yopH1A5LV4ZOKSC9mwhT9rIioUosVmMxnxmQNb/aYvdDmsS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

uart_alloc_xmit_buf() allocates the transmit buffer of a serial port. The
buffer only backs the port's kfifo, the data being sent is copied in and
out of it.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

While on it, make the local variable holding the buffer a pointer to get
rid of the casts.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/tty/serial/serial_core.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 95774b0f1484b..a72fe14f76771 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -247,29 +247,29 @@ static int uart_alloc_xmit_buf(struct tty_port *port)
 	struct uart_state *state = container_of(port, struct uart_state, port);
 	struct uart_port *uport;
 	unsigned long flags;
-	unsigned long page;
+	u8 *buf;
 
 	/*
 	 * Initialise and allocate the transmit and temporary
 	 * buffer.
 	 */
-	page = get_zeroed_page(GFP_KERNEL);
-	if (!page)
+	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buf)
 		return -ENOMEM;
 
 	uport = uart_port_ref_lock(state, &flags);
 	if (!state->port.xmit_buf) {
-		state->port.xmit_buf = (unsigned char *)page;
+		state->port.xmit_buf = buf;
 		kfifo_init(&state->port.xmit_fifo, state->port.xmit_buf,
 				PAGE_SIZE);
 		uart_port_unlock_deref(uport, flags);
 	} else {
 		uart_port_unlock_deref(uport, flags);
 		/*
-		 * Do not free() the page under the port lock, see
+		 * Do not free() the buffer under the port lock, see
 		 * uart_free_xmit_buf().
 		 */
-		free_page(page);
+		kfree(buf);
 	}
 
 	return 0;
@@ -280,10 +280,10 @@ static void uart_free_xmit_buf(struct tty_port *port)
 	struct uart_state *state = container_of(port, struct uart_state, port);
 	struct uart_port *uport;
 	unsigned long flags;
-	char *xmit_buf;
+	u8 *xmit_buf;
 
 	/*
-	 * Do not free() the transmit buffer page under the port lock since
+	 * Do not free() the transmit buffer under the port lock since
 	 * this can create various circular locking scenarios. For instance,
 	 * console driver may need to allocate/free a debug object, which
 	 * can end up in printk() recursion.
@@ -294,7 +294,7 @@ static void uart_free_xmit_buf(struct tty_port *port)
 	INIT_KFIFO(port->xmit_fifo);
 	uart_port_unlock_deref(uport, flags);
 
-	free_page((unsigned long)xmit_buf);
+	kfree(xmit_buf);
 }
 
 /*

-- 
2.53.0


