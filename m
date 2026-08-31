Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 538D2C624C2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 452CA6B008A; Mon, 31 Aug 2026 04:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403C76B009B; Mon, 31 Aug 2026 04:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 319A26B009D; Mon, 31 Aug 2026 04:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E20AE6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:27:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D5E9140436
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:27:56 +0000 (UTC)
X-FDA: 85160886552.10.1C20D2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B7AF71C0007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:27:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PBOjheqg;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788164874;
	b=uuonBTNX5qI3S/5ZWIYPrigkAOoAEvV3kMXMazj2solx+ggdD6m4dv58GG8IulKoUqHEDr
	ZumgOslvC5xLsqjhisOy0eqBg4TXdCyYYLS1Z+CIP3Q3vUFdfUb92zRvLOyRPo+V1YF9uQ
	8vYxmVkB4TIIZnuUp9dpnX/Oo1Sha30=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PBOjheqg;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788164874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y4bH+/WtPEyRU+oBNZLJOMfju4/GbiOfv2EYcWlAxs4=;
	b=fqYFpfd4AIFSMomHreTDiMJJuD+VePLIRZ89wQGxgVJ5t1eQoZCsjJZGiVqv7bWe0H8UAr
	C4Rbci/t+zhXYO0rmri47ArsQX4q5orcMsCnkaGwclr16HkcTCFfutD216dzPo29b7S9yz
	AcnmoKJFS0eiCymq+ErJCoSY3aBPFyY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DEF2344505;
	Mon, 31 Aug 2026 08:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396651F00A3D;
	Mon, 31 Aug 2026 08:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788164873;
	bh=Y4bH+/WtPEyRU+oBNZLJOMfju4/GbiOfv2EYcWlAxs4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PBOjheqgZU2//8wt0aikBUBXJMoEdiXNgcruw0QaK+0mHSMz2A20L9Y+wS1TTqm2a
	 cB8k9NDiAwOE3FQpU0Wtkxhy3pX5eP8uV5RGROxVtznX4ozJ+fAOLG5A4gsGTtqEKV
	 2UX8sigBGUWxIVY2UXRFD645QP2a5kYSEjZbVx+BMbo4LUxTUoPDxH2heA4H95HwVw
	 TCUE9QXm/lvmvJMvNdEvR4thgz5vc19pAXHDblSxIDmsO3hr4ILc8mb/dhEX4njQst
	 xfZu6qdT+dVUxHz88Xxdx6uh7GVre1GhlxHhvGcHq48YCNkqtgmkg4M8cHiIDZDg7j
	 ujirBHwtexgYw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 31 Aug 2026 11:27:43 +0300
Subject: [PATCH v2 1/3] tty: port: replace get_zeroed_page() with kzalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-tty-v2-1-88cd58c3c640@kernel.org>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B7AF71C0007
X-Stat-Signature: 6frgnisa8uhg1hynqqm6as3ntuerjyfw
X-Rspam-User: 
X-HE-Tag: 1788164874-803548
X-HE-Meta: U2FsdGVkX1/nSfcoDNKO7YYVgqNs3tYTolVCX+ygh4kI37/4KQv1IbX1/KhUS/BN6bcsVU+0HmFOOOpO3GPxHsPcyJfvgsbUR6T3QUWnMvbN71qvIHSrovxCuwMg+4EHfyUI84TKRWEo06PsRj5LxP9yzNeuOTQrZF9ZmDWbldTJvDUF2jnNF1vfrOxHPrbmV7j5CMN+qK5OQLnwTDrCffRcDv8TKOGiHJ1ALjvp8CE/t+Fe3P6y0N7LsKa2aKv8VKzUWim3p7Qys5lF2Kp/zE21xzQeWF0ZQqmRaK7gVuW+Dc+WAGzpyn5FzV8FfCT8TPNDqXIDRgbgtpgmk9mYmO8MBcVk+TmC+bzpvBnuPiehQiz3PvviY//z384E7pZcq5dT/rTpngyt8171aeqBJ25QldVtvCf2qClY4to3JTwStcCFS/aXbNfRrEhRCHa9IIz2ybKMroivnA/5wWyl0saNKZOaRyb2VZhLkgJW2HlP10JC+9lolwZU0StGggqYDYej7zlxNgyA+oN5Bzyi35yYzedu2z2ALZLJaB1y8BxeJb0ycqjQeKfhCOlFjnL+8cuTwt7wGZG7OGp7m58UAUFjLmML8rZeBoh8sIVSEukbuxvZ9z3/IhnDMrJJddua3tp3aSF/OZ3qpnPQ6+sPRXw9jbO0b1UFrg7RUKVJaqCGQeqe1yP4jHz50eZcL/WMeh+Y4Zb+lv7bgjDbX/px0DK9Zx9/re/PNW7qnLNUjRgUD3tDv6+xkLci7kkC3WFTXOALxc7Mgr3RSA014enJaGur0e2VFGWBnhTLQ43ku1/MnvtNNKgS8RJimOTyvahuohYeeb+jbHcX0IuMYO3Wkzm5pD461/uaqX7Ef9+vbRqa1rJOaGPCtMGN1paZz/ruo1Qs9TKLzsErKZgm8Z0/PqPp7GZHajxYFqdsXhgbvvW6YqxcyXMeGXVtv4SnGvqlti3IB0WgxxWi2Gp7DFr
 F6IP3vxc
 f+D2/VxSfOCx8C+AvbAObyPMeMXJOMQD3Rx6F06i2ZKdO1m+EwLun+eKwZBggQIbnoMTaDjY42Vt77/cv5VZhBNn07MGrmxeX4o90NCFqMuqwoghtQvcGh8dnBeFMdJwkrsBYowQzF5Gx4LJOXAmsIfEALIdNxFwmCi3REvxMj0kDYSnYy0PzU5ESMToheg6hyw29vKlGcFocwAqxEvN5RCa6QK+F8639ft75GsaI2M06UDH5PiABPicuJrNEqT6yD3Wt1/qCa4UfqNzaujCwSXFek6m7o90XxV90kQucly+pQqLmjTRebrZ/Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tty_port_alloc_xmit_buf() allocates the transmit buffer of a tty port. The
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

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/tty/tty_port.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 54359310e293c..44122921fc45b 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -240,13 +240,13 @@ EXPORT_SYMBOL_GPL(tty_port_unregister_device);
 
 int tty_port_alloc_xmit_buf(struct tty_port *port)
 {
-	/* We may sleep in get_zeroed_page() */
+	/* We may sleep in kzalloc() */
 	guard(mutex)(&port->buf_mutex);
 
 	if (port->xmit_buf)
 		return 0;
 
-	port->xmit_buf = (u8 *)get_zeroed_page(GFP_KERNEL);
+	port->xmit_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (port->xmit_buf == NULL)
 		return -ENOMEM;
 
@@ -259,7 +259,7 @@ EXPORT_SYMBOL(tty_port_alloc_xmit_buf);
 void tty_port_free_xmit_buf(struct tty_port *port)
 {
 	guard(mutex)(&port->buf_mutex);
-	free_page((unsigned long)port->xmit_buf);
+	kfree(port->xmit_buf);
 	port->xmit_buf = NULL;
 	INIT_KFIFO(port->xmit_fifo);
 }
@@ -288,7 +288,7 @@ static void tty_port_destructor(struct kref *kref)
 	/* check if last port ref was dropped before tty release */
 	if (WARN_ON(port->itty))
 		return;
-	free_page((unsigned long)port->xmit_buf);
+	kfree(port->xmit_buf);
 	tty_port_destroy(port);
 	if (port->ops && port->ops->destruct)
 		port->ops->destruct(port);

-- 
2.53.0


