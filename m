Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A72ECC61DE5
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:49:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759236B00A3; Sun, 30 Aug 2026 03:49:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70A306B00A4; Sun, 30 Aug 2026 03:49:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6201A6B00A5; Sun, 30 Aug 2026 03:49:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42D3A6B00A3
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:49:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6271A3AAC
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:49:47 +0000 (UTC)
X-FDA: 85157161614.15.2327C86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0E317100002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:49:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NOx4HGWj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788076186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HuAQFZwiOZzqNfEaGbCIrZqTUyDwkDp9iUPeNuXnT0k=;
	b=Yc1M06cQ84+rMGYbTytXm6CzIrT/b8tJVxwAf6rnHlJsmI2ileKvBoko05Mfk3QEQ9KKHK
	lH3gF73dyicZ+JQfSS0AFLIcKkgAVSPdOgZUxUNf7rYeOily5HqlW/Xf8+qVKLPQsYJqUj
	nwMhO8u+rsUDdppV9HFPJKUu0Vu0tEk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NOx4HGWj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788076186;
	b=TaEnRp/Na//JLUJ0Pf9wywl0n4GWXX5czgdTT8JHGx11djToRu1KNxhImUgWezGKlIZSfx
	lNcR6Gdl+TKvUexiSguOYMWnbhOeke1bKSDdbg4IHxa/zQAyIqh/AcC68pEoCwUJwOd2Xb
	epfz7FjRLF6m54BR+gJF3NB/9NGjqYI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5533543C8C;
	Sun, 30 Aug 2026 07:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE331F00A3D;
	Sun, 30 Aug 2026 07:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788076185;
	bh=HuAQFZwiOZzqNfEaGbCIrZqTUyDwkDp9iUPeNuXnT0k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NOx4HGWjxeuC3f34ZH/BvB1br+XJ+CJKR4IxRAwWAEqdxRYw7/ImwrMEVKFpf/Kg0
	 AJode0vDl1kcX4QqspysvvD+TJYk5aQ2GZl/ZwmXIH4gkQNWcny+xwYp37F7E40tsE
	 VZnpJUN/K56Pg2Z5AJJx004ORINtZRaC3nH+H0rGRd9gCkSx3EjnUeeYv0XriMDcT/
	 RGLuYELGfmmQBecnLFSat3U2/DheEczEzej8qj+W0u8KIizfDBNepX9Si2yzIuTW/+
	 bDbogz42uOCEB8zkoZB2xUXKnSPldxToGvEjFNMuL23yN7HZJdMzAwcACVYjzLamXF
	 XManrSAy5lqLA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 30 Aug 2026 10:49:37 +0300
Subject: [PATCH 1/3] tty: port: replace get_zeroed_page() with kzalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-tty-v1-1-0cbe6170649b@kernel.org>
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
X-Stat-Signature: pab31dofpmktxjeq5nk4rz1dxtx474ur
X-Rspamd-Queue-Id: 0E317100002
X-HE-Tag: 1788076185-92278
X-HE-Meta: U2FsdGVkX18q6x0rvvZVrl2houzS60jqzOGAUVX92wTEPZEQOvGl/T0IlXZqCAWu5bbNsfD6jFJnPFdrdSWuqlJoMA7oX94wDqCDMgzf07BzS3hwhjSm3aLulW/DhbG+Xnb+yZt9sUcCZiHW5y80x+CJEA9vn+fu8j2RAPJquqP5ufZPQ+F/mdjgOl25G2/5B5fR/zZclBOfOm7ibXz4Rw7cqklcRsZ/AJAunglYAJ0/jUs+rq+qhY8OJZM3KfyMQa6acGYFZl/wKfaLDp1An1vJSwsy/PaSZ6FDUT/8egzSesxxZTG4bcXOX30F9MnGeNHE0aru5IzTKtyGFCmUqamDtUfJPctRpNYoROnWNOidxPYmZT6fvIBp6XiSZSqM8uySXnlKttLRuc+yC6ghCaqH69QlwCeJ16YYKpFXKNXuc2ogLercQzoifIoGE+qM8nBpM1MKAbk/R+WMT9RUnuDqcyjso1o9HJZExTpBcfqqn5VV2EFWcbH96eBkM5bHIVaAIL/twbDWpj9gV3HWpWJYBYxr9C2W3dPHE5XS7IHrxuWSOP67MqlAD4KTgcp1040hVRG7Kd0PFYVs/eFPLqHVJUu6acj7Hhq959Og49rUGvb0YDFMA1JbZEnNoPyv58s00CKBnASzkL++4qBNB+Ab2/2afhsrxQZyCCopnAKXoqkXUDv6WbULPot74TQFQVdoSkV72INNiU5tj8BGvGeLBAJZ2RVquZBbxplGVH9s0VobyYSWW6HRJAOoEIpga04lqf9pkfQ0PFyjTMvnvW3sLgwaiZrMCbAyOkiYii1r5xRHRXxPJdokG/4gqdKd0HfC7Eaib5zwbhreEmPLgr8El6qMqAF7VMYNoYYd13Wm45lL7V/vpxoLYPTl4tTvcMotRxAZVBW6cKVa0VB7Kwf1FlyTovM1SxRMGdEkhDQbBeZES9achjLHQz26Yu0WYSp+13BAB9kXPT3sFoo
 50nu75A7
 g7qy34fG+sNXJRy0pf/BSO2ecI893qUsad9X3VXi2Q4fmKkQVdSQI6J8JZJWx6ZWe6edtL3hW6A3qR0ErQJjpYxe0bHpi6dHv0C5Reo5RWyUcv+XuzBc/4CFaZvtjoG59pLmIKAr75Q6a2NxEcia/+gAOKBgBCpmvThM3CwuAw7GBtNxE8j4xgb1K4AJQ5c9BR2PjxgtoUJW6SOy8x4PnKP5V6JKtlJUNmnB06eyoMXp0fVT18FQbgSa43y/ZetVMw65h9X5AwfmlgIqYBbyeVeZpmK0HwjDXjXXqjkFBrjPcYKeKmQC87GMUWA==
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
index 54359310e293..44122921fc45 100644
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


