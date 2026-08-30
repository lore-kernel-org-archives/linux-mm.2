Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A2A1C61DE6
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780056B00A5; Sun, 30 Aug 2026 03:49:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7580E6B00A6; Sun, 30 Aug 2026 03:49:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 694AC6B00A7; Sun, 30 Aug 2026 03:49:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B18D6B00A5
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:49:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6BC3A3B41
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:49:50 +0000 (UTC)
X-FDA: 85157161740.13.529B0E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 11134160002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:49:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YVy5RuRD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788076189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NrSsuZV29xVILt7z5sekPgPcSUlhKVhvtPvsz1aJgQ=;
	b=a6P/ccePCdXXFC3eR7xFEQXRkAaIVZp0ralTkegUBr4jrz///jAcOrKkRpgxfBZTWybpEF
	GWCXlTrORtQPtK/vkZAcP9pFe/3ppZIBbc7dsdE/9oY5eVTa0JXHwlmdcnW+e8bWGecqh6
	D7cVLDHMH8AtsUgubFGjgtsE2tE7ycE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YVy5RuRD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788076189;
	b=6FJaZQkTpe2NBM33Zyp4jk7Lq2xoYWNHEVKy7pHfGFJxABYObAHQeU/bjMJuin4Q2xfSqW
	gTZpWQg8BRirR9uCklsEcqfMUom6aJQ8yxGkowjYFBz32l3UXYTsAEFpBpuOvSgkRu1+Ov
	O+GvUteA/TpbofBeGXJqSuAdN5ugdqc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C79244020;
	Sun, 30 Aug 2026 07:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B737E1F000E9;
	Sun, 30 Aug 2026 07:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788076188;
	bh=4NrSsuZV29xVILt7z5sekPgPcSUlhKVhvtPvsz1aJgQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YVy5RuRDJhrAG9c9gOgOtGUONheY/iIyUzWDRWv4Ew/lBNFR2qwEW4yd4oaDrr5n/
	 ONEHQvjB4UNd/jUu/xSPGX5HSptOA+Zv8L1WrwK96G/KfXj9zRlAahVclZBId1k47T
	 lu7s+qxucogiX331Q7G5Mq8iYxh9JFuYhsgXOPuxWpwL255qmpQN50FiRZ9z1L0G9r
	 iTxxgTzu2cJEZ/3s+yUxOfX7guIl1bnaVpdBuj+JvDPJaCr+E4v/9r8CEkMKbHt/yn
	 9i1BIw3vxI6BOUmb6freBYrww0vm7Zks6+Nh0UGsIZ4XbBivpp0GYRrQecwsn5cYVb
	 zGErJk3Yo/SKg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 30 Aug 2026 10:49:38 +0300
Subject: [PATCH 2/3] serial: core: replace get_zeroed_page() with kzalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-tty-v1-2-0cbe6170649b@kernel.org>
References: <20260830-tty-v1-0-0cbe6170649b@kernel.org>
In-Reply-To: <20260830-tty-v1-0-0cbe6170649b@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 5gyu7oh5b15588b5ukqxzuqybb5o8udj
X-Rspamd-Queue-Id: 11134160002
X-HE-Tag: 1788076188-426711
X-HE-Meta: U2FsdGVkX19mjQes0ah1Nj1LWdkkUPYiaifkmtAJAds6fz1GI2QscTOnuWHRAw0DHjoPjtM4BO0P+GZgpeE77EM2fCbDsr5L+9w117/l1McB/jWcDI5vrPjGIadi1viOLQfFY2Odp0RxohulxKsy7L0SqH9bDhS9BqQF5d8tstkIyEkBmiGRO00Hk7EVHttKeAnGZV5qIOf+XiLmvcNeZUF19jciEMHTEBPxEh5Mmm+v7DYEDUqXKr2uj8VfQMZFT2beZq6aFdS4UrnZuin+/QXfNlzQLs9/ZQey0lIzsKQrgIRr3Jh8Ap2QT1eE5tB2DphOayK1ZwhrB6am9zkNsVWxaq+K/m3FquYKZM/MO2fckElD4mbdqKnkDl7Qxt4ZpRFQ5ge4mH1r26cn6dK0N0DXbGl2rBbiuxHURWCRJ3EoD5JP+JqacTl+D3X2eHZqDZk4utUNvX1KXU68g1VLh7y+ALetLuFpnbbvu3gTvNTzfTk1Bw+N1IyZ+np8b37w8UghqRy/bP+pU3SC6DTD5L5XYxn7yWJV0Epz1q0i95JlOFVgQjgrky5/1bWEJ+WWbiS5VMf4F/Qy4bYyurh3/pjDPrb5b3cr/36/SpcavLDvY3aivRXMd8HD4kUsq/agcMfLLG3y5dnZy5bzwf9LmP5Dfz7mJTxpf5VDLloUee+2oHW79jQHHhggTLioOpH8461UskrM57Bp/xLD/cutuGzPqf7omJUmo2iEuFqlgd9rQLw1r+/Vx1+cuH36g2UefxLzZTGHYzR9aorKXrZWal3sQtQKLPNd6ZOtFzUBCDA2tuwNd3ohnqXNnBSJU1/T2PnPQFnjQCMo0L56jYhcGpG/IAZCjNGuB4Nd1VYpxHU7Ly+x0/0Ud3ORs1W2uvdymg3HNSOLwR/wdqnYQa8FUsXE13zPokA/WDKAEFRUdYHJac9CVDoSDwfG7tURuPUqdes/4OLq/0g28usZWWn
 lABMlVPU
 njMpAk+KqJv7ZB8HLy7MmaIji81j4UmAdsCCw5VRDEGp5t/wE3La1k5E6vcCWFBgNNfmbvGQS7uT/NvKD1mN+miAicwBnn7dbK3IO9z61fFjkSWuibZawYOGVBMywrqO7g5Mw4So5afcHJ+TdMKwMSd7lDwWqySxMU2/lI45JklUQKwQf02N9Y9kfbYPke9XAJbtsLDfDFZuMhrLqCm90SfmFcZrQWN+nu9gmJNCXZZU/17r9Bt+iivqN2699hsKGPulgpU5l5zgJc63gf/p3PHKv1Mg95rj8YaqmT/v6SYpbuYxK3mnL5B9/8F15yYaXJNtp
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
 drivers/tty/serial/serial_core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 95774b0f1484..f12ce7d190fe 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -247,29 +247,29 @@ static int uart_alloc_xmit_buf(struct tty_port *port)
 	struct uart_state *state = container_of(port, struct uart_state, port);
 	struct uart_port *uport;
 	unsigned long flags;
-	unsigned long page;
+	unsigned char *buf;
 
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
@@ -283,7 +283,7 @@ static void uart_free_xmit_buf(struct tty_port *port)
 	char *xmit_buf;
 
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


