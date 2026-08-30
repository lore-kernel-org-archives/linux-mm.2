Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A153C61DE2
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5817B6B009D; Sun, 30 Aug 2026 03:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532446B009F; Sun, 30 Aug 2026 03:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424856B00A0; Sun, 30 Aug 2026 03:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10E616B009D
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:48:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E79FA027C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:48:15 +0000 (UTC)
X-FDA: 85157157750.14.4A0943B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B3439140007
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:48:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MITK9vI0;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788076093;
	b=fLXtF7jHFgwuL8+E8Wni6J0hGkelw65UcDi5AOQvQMmg34CJXC+OYe2NGubAmqXknqxD69
	PTpLqEuhoq3YTRd2764yf2axktNvh3y7dOfHvPusyOK8Qkl3cS27PMCmETYsMIbqdlQata
	GDTkuxwXAWyaOi83xN400nYFV1Q4Rao=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788076093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=38jl+dsC2EM5o3wlTYxKA9vi8q2Wl79pFO6QzTnvIhE=;
	b=2FWy73J4bAL6a41LelIoCq4zDCxbOBlJ8u6c2Sg2QH6WRJ1vpMWTILOEEwjx4tjXV78tqn
	TUykPxqS1KIvAGyMJ1c5c2o7BwUuK1l3BnL7q2z1hoe4fCeMok95p8ZhyrGmdiKTUpKCXV
	XBdOWKibhIBw5tMXTic5EmOm7h25CGA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MITK9vI0;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D1A243C8C;
	Sun, 30 Aug 2026 07:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1FF1F00A3D;
	Sun, 30 Aug 2026 07:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788076092;
	bh=38jl+dsC2EM5o3wlTYxKA9vi8q2Wl79pFO6QzTnvIhE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MITK9vI0TqCwtGzG/5NMmeWpLrvyxDEIRP5gcuykrnjJ8pC3e+zwNDgzgR7zvRtLU
	 KIzQKgJMT9sNr5suPtvvhbWU/cROpvKy18evTNfnEXuj1IZyDAqWfI4lgUkIp0DZha
	 ciw9wYDeDuB2aHMYJUyfKdodFjmUGsXMvoQQ6UFn1UIGvnuSh0429/xcIJLYDiSMeE
	 VlLLt/omlbjjYeDJc6JWI8dSpj7U6b/541bhnYGQGVYvMSzU6VT7VvnrjrNKct2d+m
	 /GEswHY8ZS366BC6EBjVsqmNvbQ0/G81R4uGCcBP0y0kVpcd9ISRxxu4KKOgC/ZbP4
	 aLDP1Kl/ay2AQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 30 Aug 2026 10:47:59 +0300
Subject: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
In-Reply-To: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>, 
 Eli Billauer <eli.billauer@gmail.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Michal Simek <michal.simek@amd.com>, Ritu Agarwal <rituagar@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B3439140007
X-Stat-Signature: p8dggc1nygs7uabt9ws6mtot4gqpa4o1
X-HE-Tag: 1788076093-771724
X-HE-Meta: U2FsdGVkX19H+wsDDNXbX0TpmnEyRwu8Py2zn2iWg840uaNUuLGY2qshzv/hRL7aprySvlS66B3MehZ1Lay2d5r9MlKp+ODScazYloQT0nHnxInvEtImDCA7WS1dui0G/5KmeJLj5UEYTTGbrAqDqMmwPlrVYAfhZMAsI0ahH1OCTCdJcUrRu/g2LxnZIm3VA9ySMmd9IR53RDz5Z6Cq3J3S8ltONkUSGUSEZZ03P/HxInyI9NiI1Cat1UyEfESPSbeT5LISfkyMtS4YADUklKyNQB4xuA8zhueHAoHOnOQH+BSd5th+6MRd315NaMnqW3l0RmLjKl1meQ6IFiglKgFXiIFbSe9/ugXaPz2Gm+fphIh+nC9VeT49oXiNOit6bdXUdDO8O09TBh3e1I+ak7VeKAVKg7P2PUDq2OezRtvV+joMQAteyhNCfWzEeU+48a2av25Abij78cNd9XSKCm5C3ebwti7IwkHO6jZBMS10fRrGRW/sohKodC2Dnl6WpPPLCJs0TvBwJJocOt7dtnHqVsecewbitPNh1dL0xuMK6G1TLu87eUHJAWKkcSREjfVsyFEtkwak8U9fgouC6GY1EtDx4B+ZVvoHikF0CW/p/25CJWCcAutnXk8FEnnB12spQFFSlHUzLuX54NvcvMRWGFD9QMB5cw/Z/T+KJhupXALRlS/bGH86e30n4c+4sTbqzGoCG8s1N9NyFo1UN73ukOMCyReNsnipUUIhKVvgPdlEkcOy0CoNM9ypgjBPSndnbT0CvaRAjriCeR6P51AZnMvG5K5zIpTdGEbHWKWKk6/2coWRYLVIeUpp0WkWgJlopwlu4I9edLTrWTcjJct1isaIg3H2eCWHdKN7Bf/ebcu8y/yMl7tGNFWUa20VSRXp1sIBNR0/WQ/MZllvt4/6KRJ1Ia3ZY+58ftUAnInrZSBmsVmOjAZRmIsmYbUTSg8TRxAom3Q5Ma/d0S/
 xEDKy1mY
 OUYKuhwBaXJ9K+TEhvg3r61e1H1zThzA28oB5WrOTfEfAJBA/72vI2PfLS9mhElHPxn8za/PUtXgsRaoN2RzVQfqTws1Io+6S0/OznBxNrKoF+0vOalwGr1S2IfJklYDwglqyB4WC8LU2h+EsfqEU/A5ZHxiHZjyJr3dxlEEuvwAYV/4zBhM4K7/MKqUhJ4abWROqmfr31qmjYiQD3L/92hoxioYvH20hTG09A/kvHnnnrzJhkstsrNFyGWoZ93lYvipL8XDepqzYUQUMZHJHNCFoV2o585Okkks2hnWEnsuwh1iv/5/9UXdvcFIVNhOfcZDrjZbFt0zdMvm1m0X9pjqy1hi1bLoFgBMMt02E7EANCAeJOYqdtQhjDlOoiSr/kEliqXSyHOIieok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fifo_init() allocates the buffers backing the software FIFO and
endpoint_alloc() allocates the transfer buffers of a USB endpoint.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Since kmalloc() does not need the allocation order, ask it for the buffer
sizes the driver already tracks and drop the now unused order fields. For
a FIFO smaller than a page this also stops rounding the allocation up to
PAGE_SIZE.

Replace use of __get_free_pages() with kmalloc() and free_pages() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/char/xillybus/xillyusb.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/char/xillybus/xillyusb.c b/drivers/char/xillybus/xillyusb.c
index 34e7ad3bcab3..193e2a5b599e 100644
--- a/drivers/char/xillybus/xillyusb.c
+++ b/drivers/char/xillybus/xillyusb.c
@@ -71,7 +71,6 @@ struct xillyfifo {
 	unsigned int bufsize; /* In bytes, always a power of 2 */
 	unsigned int bufnum;
 	unsigned int size; /* Lazy: Equals bufsize * bufnum */
-	unsigned int buf_order;
 
 	int fill; /* Number of bytes in the FIFO */
 	spinlock_t lock;
@@ -95,7 +94,6 @@ struct xillyusb_endpoint {
 	struct list_head filled_buffers;
 	spinlock_t buffers_lock; /* protect these two lists */
 
-	unsigned int order;
 	unsigned int buffer_size;
 
 	unsigned int fill_mask;
@@ -370,7 +368,6 @@ static int fifo_init(struct xillyfifo *fifo,
 		     unsigned int log2_size)
 {
 	unsigned int log2_bufnum;
-	unsigned int buf_order;
 	int i;
 
 	unsigned int log2_fifo_buf_size;
@@ -380,18 +377,14 @@ static int fifo_init(struct xillyfifo *fifo,
 
 	if (log2_size > log2_fifo_buf_size) {
 		log2_bufnum = log2_size - log2_fifo_buf_size;
-		buf_order = fifo_buf_order;
 		fifo->bufsize = 1 << log2_fifo_buf_size;
 	} else {
 		log2_bufnum = 0;
-		buf_order = (log2_size > PAGE_SHIFT) ?
-			log2_size - PAGE_SHIFT : 0;
 		fifo->bufsize = 1 << log2_size;
 	}
 
 	fifo->bufnum = 1 << log2_bufnum;
 	fifo->size = fifo->bufnum * fifo->bufsize;
-	fifo->buf_order = buf_order;
 
 	fifo->mem = kmalloc_array(fifo->bufnum, sizeof(void *), GFP_KERNEL);
 
@@ -399,8 +392,7 @@ static int fifo_init(struct xillyfifo *fifo,
 		return -ENOMEM;
 
 	for (i = 0; i < fifo->bufnum; i++) {
-		fifo->mem[i] = (void *)
-			__get_free_pages(GFP_KERNEL, buf_order);
+		fifo->mem[i] = kmalloc(fifo->bufsize, GFP_KERNEL);
 
 		if (!fifo->mem[i])
 			goto memfail;
@@ -417,7 +409,7 @@ static int fifo_init(struct xillyfifo *fifo,
 
 memfail:
 	for (i--; i >= 0; i--)
-		free_pages((unsigned long)fifo->mem[i], buf_order);
+		kfree(fifo->mem[i]);
 
 	kfree(fifo->mem);
 	fifo->mem = NULL;
@@ -438,7 +430,7 @@ static void fifo_mem_release(struct xillyfifo *fifo)
 		return;
 
 	for (i = 0; i < fifo->bufnum; i++)
-		free_pages((unsigned long)fifo->mem[i], fifo->buf_order);
+		kfree(fifo->mem[i]);
 
 	kfree(fifo->mem);
 }
@@ -477,7 +469,7 @@ static void endpoint_dealloc(struct xillyusb_endpoint *ep)
 		struct xillybuffer *xb =
 			list_entry(this, struct xillybuffer, entry);
 
-		free_pages((unsigned long)xb->buf, ep->order);
+		kfree(xb->buf);
 		kfree(xb);
 	}
 
@@ -509,8 +501,7 @@ static struct xillyusb_endpoint
 	init_usb_anchor(&ep->anchor);
 	INIT_WORK(&ep->workitem, work);
 
-	ep->order = order;
-	ep->buffer_size =  1 << (PAGE_SHIFT + order);
+	ep->buffer_size = 1 << (PAGE_SHIFT + order);
 	ep->outstanding_urbs = 0;
 	ep->drained = true;
 	ep->wake_on_drain = false;
@@ -520,7 +511,6 @@ static struct xillyusb_endpoint
 
 	for (i = 0; i < bufnum; i++) {
 		struct xillybuffer *xb;
-		unsigned long addr;
 
 		xb = kzalloc_obj(*xb);
 
@@ -529,15 +519,14 @@ static struct xillyusb_endpoint
 			return NULL;
 		}
 
-		addr = __get_free_pages(GFP_KERNEL, order);
+		xb->buf = kmalloc(ep->buffer_size, GFP_KERNEL);
 
-		if (!addr) {
+		if (!xb->buf) {
 			kfree(xb);
 			endpoint_dealloc(ep);
 			return NULL;
 		}
 
-		xb->buf = (void *)addr;
 		xb->ep = ep;
 		list_add_tail(&xb->entry, &ep->buffers);
 	}

-- 
2.53.0


