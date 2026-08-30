Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 025FFC61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 08:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16CF16B008C; Sun, 30 Aug 2026 04:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 145566B0092; Sun, 30 Aug 2026 04:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033046B0095; Sun, 30 Aug 2026 04:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D93616B008C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:10:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 464B712028E
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:10:52 +0000 (UTC)
X-FDA: 85157214744.12.5C6D2C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9CBE114000C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:10:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c9AxY/NF";
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788077450;
	b=IR5vokG+Ag4JY+lzOq/lxJEwBVFrZ1jizGO5I9CB8dR1HwqCILIiJjxpdcmFfEVJZgdlEI
	RwksUu0YqZLioH5WqSx67eMicBkXIyj74xa33tSHbpg/z0VTeZasBiHwpvzxL49esBJ6im
	VBBwfbH5EvAIzbz97msn2hf/4ZYjEcw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788077450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=456eTZH5re1mOwITP+CRrgyuiPJU5C7OnY/8nFx1ZDY=;
	b=nLLaMaLgkrykUglj55MZ4LUAz6jRIeYZAUylfZeti36OdRTzgpcl3uydBLphUiDdftzd5V
	T+gAADNMsCjWRD9k1ROuIJwaqgl2m1i4E9smI8SJZpnXtqjPcUyPn+ugXTMyLSw/Hv2pfI
	T5HIrR2w17Nm5pdFgwk8nImUgrXEF30=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c9AxY/NF";
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C51AA43E1E;
	Sun, 30 Aug 2026 08:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B971F00A3D;
	Sun, 30 Aug 2026 08:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788077449;
	bh=456eTZH5re1mOwITP+CRrgyuiPJU5C7OnY/8nFx1ZDY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=c9AxY/NFrk6YmMBtpXsB16Y8Vbd1+0AaacjabFZF0pnRDfVFy5Hmi2G6IDmZ9ghe1
	 qI7dOUiPZ4DEYk+Jroe6RyVwkh/zPP/sbJTzoC3zJuHiUCLnPW6U+1uFYfP9pTLQ73
	 izAsxvlg1XaJBB/3ahyXgXqogbE9+Y9fkZfDEw7pjb7f7/DG5uUZrWbVYNoTRPbsgC
	 meTIUd7SUJXTdoBOr99jIZfPUG4n4BgzjvQjTtwK5co9DnDlHg1kQrkmnhaBRJ6IBc
	 vFKoEf/sQnNy2S0/Vb1xiFjoJykWxEYA/7pdejplhy2d3sLlgYiF/CBdIyzmMb0khh
	 yAHkcVEJZYFMw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 30 Aug 2026 11:10:37 +0300
Subject: [PATCH 1/4] USB: usbfs: replace __get_free_page() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-usb-v1-1-aa349c302246@kernel.org>
References: <20260830-usb-v1-0-aa349c302246@kernel.org>
In-Reply-To: <20260830-usb-v1-0-aa349c302246@kernel.org>
To: Chas Williams <3chas3@gmail.com>, Duncan Sands <duncan.sands@free.fr>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Johan Hovold <johan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 accessrunner-general@lists.sourceforge.net, 
 linux-atm-general@lists.sourceforge.net, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9CBE114000C
X-Stat-Signature: xdjdr8ssi8dtzoj9z65uhbqh4qha5cx5
X-HE-Tag: 1788077450-945360
X-HE-Meta: U2FsdGVkX19Vjhpx5aG6neyLlwVrCgtOw2nBv9Qi+ehIFaJPZdg/F6QxN7TjDAjgFhYXZkMJ0qc6v6NqKbgD0RlBdWOwPD1VR4eYv3V9H7rB4/TASzccw8JLgC+iWIK3Xg0ygAZOgJOKv+5TfLkxvKJZ9bCuLv0FHl+IJ1hBYKA1FT82e9XZM5xt3gfprS5Uwx6XEtOIfSZf7fFzdyRftePSGVMIvkHV0D8DSfjYxl8ZfaOjqG+Mqol6Y0TAwf9HVFPrvAa4wTWxeEefnR+26XEmsCLFNSx+U1m50P5r8guYBe5cEw10mroKFgBfxvHj5piK0ngw2qJRm8AZD9jGBjqalkGthPHJnqqPFYZ/+5Z3jAluZkfgdBnl4O08RRzIYuPGrrKCRwmSMjK+Qow9h4Hi+v+PqlUxnnTVfo+qQKak3cbtiWoUQfc6s6HDt6Y/uYWawQGynX21RIwE29PvXku9fIdJbfew9BFgGPQnbQDLvIiOfKSnMrVe2rxwrbIFCJjsMTv1l0ZRi8Ms6v3IKtRI6fjVrMIx1fbaX7JXh2V0Febj8h3UTuT+iZ+09cf3mxkq0vnsc3PRJB9VDfyv0XE+B5LkNtRjhk1Yzh7/J47TvLfbt2k359DaWnofF81yaHeBLOBvBbDQocxHkqWdU9fAHmiZ0J7PzZ8ZqJzNpNpdZHGCjcQvTkBFNd6AztYB/IS3qnnsOPsPP3Y1QbswGQZ7Tq2DDuzlN+GXnZ1qyGutO2kIPRDqRBuRopWVXjaWrSe1kFrwq1NHEA4QYg6GzBYSq74E+TkqNxiYg1QBtjAF2Xxm42FMEHZy8qRWqfCOlLZCGhmoIFu+zpO6WntZkZESxkZIVZk2BswE6YpLNU81EOO9yTdG8E71K2sQbRZnbw7/DHH2sOn/uq4y5Ck3VYrumY78TGXAP/TB6rrCqbv4MjXbwcc7BiqWesmDupJN5C1GywzM5PHpFYCfF34
 106KLz91
 tbvhYPqdA420Pa8CEr8dbRCY624Dc6eRy3Q67GHlKpmEaoEpjFjBTRSsIsRADYeTIghYS4gWo5hP1XvWn2mKpc+4xNTHy8Dpgc/40cqleV5rGlE4XimQwNlx9QlT/DKy4jJ2DAfXWDEBRgshU3uY3c2hbYzgAFzhn5nJIVQ8I/l93xAAqBa8tYc2F56K8RqjqIOv9ghD5lxMuhO++5B+AioSG0McFzWE9l3X0nWzobd54/p9cwrAOiuJgFWHZ/3oEPPBud46+EolZ9TQXVQz7OQ5pCBLD+Zry2DTsSsvK8xEqCPzYNbvWyQnxfnwIzqBXI3yC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

do_proc_control() allocates a temporary buffer for the data stage of a
control transfer issued from userspace.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/usb/core/devio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 101cb9425480..9a7cc7cdf00b 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1190,7 +1190,7 @@ static int do_proc_control(struct usb_dev_state *ps,
 		return ret;
 
 	ret = -ENOMEM;
-	tbuf = (unsigned char *)__get_free_page(GFP_KERNEL);
+	tbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!tbuf)
 		goto done;
 	urb = usb_alloc_urb(0, GFP_NOIO);
@@ -1265,7 +1265,7 @@ static int do_proc_control(struct usb_dev_state *ps,
  done:
 	kfree(dr);
 	usb_free_urb(urb);
-	free_page((unsigned long) tbuf);
+	kfree(tbuf);
 	usbfs_decrease_memory_usage(PAGE_SIZE + sizeof(struct urb) +
 			sizeof(struct usb_ctrlrequest));
 	return ret;

-- 
2.53.0


