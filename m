Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73956C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72A8C6B00C4; Tue, 30 Jun 2026 06:27:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9406B00C5; Tue, 30 Jun 2026 06:27:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F1616B00C6; Tue, 30 Jun 2026 06:27:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6B26B00C4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:27:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE60D1A0427
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:27:21 +0000 (UTC)
X-FDA: 84936201882.06.9A163D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 215DF40004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:27:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GFDNMXG6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782815240;
	b=hZHbj4IBbF34+PLw0z0XVDEQ9a2y3mxbd++wF8TyMQPa3vi0XN31kbbbvaRtDslE5pVkPI
	0uk3099Ha9eG8OwQkBGl1WaBo7pdBvPd46KdRablJo9cWDiL4HDch2oX8HQe8X/WjePAuc
	b73cG+TnEpWCv8QrwtR7wtuQm0arwIU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782815240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=patmpnVmYGTOpRCqMyGDpkqFj5MsIg2HEN2E1VwU2Hc=;
	b=Q0tC5lWaSKIFFCErkhNCAuwe4ALEqEaBZPCFQTlWHuo7/1RGluC6zFoxeMQI4Wx93hEvAG
	j1nssw41kb+Q069JNMydfVTdBFnvQx4pfk0KA6VzCuW2XVnIqfu85869eAh0G8mXdQOrox
	O9f98L0ZW3kd6CXK2UdJOK3c6lf/3S0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GFDNMXG6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EBC243EC0;
	Tue, 30 Jun 2026 10:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3F41F00A3A;
	Tue, 30 Jun 2026 10:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782815239;
	bh=patmpnVmYGTOpRCqMyGDpkqFj5MsIg2HEN2E1VwU2Hc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GFDNMXG66ssR/fsB+/hwGXiru/uXpVJ/rPeKW4ReYyUg10ebLRY7d9OSbJRyrQe7J
	 S7nbUbcEnMR97DSNKEvsUtDyAtrrOlbGOpBgM+e68dI5RJlnejphJYnLrrh6LuJNU3
	 ToDrJkLWv1dRjVcprSL5eA/T7AeJDJFi8XadYWmlKwbokMjNRHc7LCYLhi6h5MTy/0
	 gIzAuNER+omqaAXhMtCI1L5J3VYZLzT4RyYexWRfeIuvhseeJRjZkeUOzwaUdMwAdj
	 B11/JvUl/hkXISvm/v+cJwAXbCm2/hesVJwTvDbxF37Khkaye09acR41UpZipCSiN9
	 K9yw9kw7/N6vg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:27:08 +0300
Subject: [PATCH 1/2] usb: host: ohci-dbg: use kmalloc() for print buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-usb-v1-1-8d547235c374@kernel.org>
References: <20260630-b4-usb-v1-0-8d547235c374@kernel.org>
In-Reply-To: <20260630-b4-usb-v1-0-8d547235c374@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mike Rapoport <rpppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-usb@vger.kernel.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 215DF40004
X-Stat-Signature: h9oe55spr41rs3b3aawggo3as7pbsosc
X-HE-Tag: 1782815239-934048
X-HE-Meta: U2FsdGVkX1+tcGPMBBVDgSTEeQSLvDtweuv7W3sOyG/fqYUwf2NVxVvk9PTFvds6LnvEeNdw3oeL//HAZJGbcV/hLdibToeJRV6j6b8LiOaNd491YRaG/lPe3ezyeesyWcSKL8FEfZyKAaui1uOwxm0VRCD6eUXeKoiCcflxUlGANMHH4eZVLNbt3rNoh7huQ2fP0laQsEE7lMClnoRK93+szgyVIIUdbwH5WdDvLu6rHdjgxIHKLmxDsLm85KFRwNL2pRpWnrqJ2TxAM9uNCTGUvQ6q3HSMZ+9hBg9Mt3T+w1WA8wlcJfV7qyqB6HBllgG1zZmKNGppRUb6cslDC68eIkLUidpgdbEzCtH3SFCgUJKXWnt4BMKn6v+htWEApWM6MNsPoEgX/rYS7YX/IseJ5DIDC+o2MaifpiuLfQfBz6J1KpTNFOJo+mrIafj1ztrn/INhtjTTEj5rthuN3bV8HGlyZj4bcPOJjS7lRK8VI3fa52gORZZ29qElx5oWHFWaTqYQWJ/C+Vnnk0PGXhvXkLaAe5RJz0Tp4c+IsU4YR4ICdvhgwfm8vI+XAbKkaFHE4Gp7KOMqow8sGTG95oSUKIFYWRlTMyIYr3zrRiJ9XZQWL8m+kfzgJg4PIsvs1jYCuBMohqpv7+twD3oWTE0Grb7iVPhCs1pTYUZNsVO7/XXCb/KwmlyMIdmm+2wCF5WfI62AQSD5Q8jmRf2nB71Ywixi4S6W+hGODWqzZ3ufR6Lxm4OWcq1TFZ+IUZRP+tLX4Rr/cVAi+JdR1WabSBrrogub4deWW9/TsfHI8V+ZV06elMPSFoSEn0hmFO+OUvkCBwvB1oRQus8p9HCWnU3sFDZ0vv/d70mkCiDtyLuG06P85igDxtuYe7+J7O6CWTLP4/O87RIC3/H70iNaom/gaeK/KOD6jMfUF/BX+KIYvB4zPtXLRFOBuMs4DAa7BUkiXo6Nyj9RZmxkpju
 E0H5M0xr
 /KVEdLK3mg/J8CB/fSZ+mIq2q3EIUV628UD0joA5iTGp+267gFPXVX5ciT+wOL/obOV/J1hh7xW/ETQmoh58eIGu7yazYPLfIgVM2jmvl2xPvin2U5EY8EB1X+WJ4yPaeiMMbo7QU8pe/bCLg31jmBJaKSRSFN+pvLCulA6tFjmwsne0HWXmb+Eu/iXjAr30+samEfzdFuUIRnTyr0g5W+k/RwzRWOf+tS9UrOdSD8UTSHWQ77dnDpeOhxczaDqiLh3ktgObsdCI1Li4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ochi-dbg allocates buffers for formatting of various dump outputs.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

While on it, make kfree() calls unconditional since kfree() can be passed a
NULL pointer.

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/usb/host/ohci-dbg.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/host/ohci-dbg.c b/drivers/usb/host/ohci-dbg.c
index 9e0e06bbc570..0a648a7d9136 100644
--- a/drivers/usb/host/ohci-dbg.c
+++ b/drivers/usb/host/ohci-dbg.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-1.0+
+#include <linux/slab.h>
 /*
  * OHCI HCD (Host Controller Driver) for USB.
  *
@@ -683,7 +684,7 @@ static int fill_buffer(struct debug_buffer *buf)
 	int ret;
 
 	if (!buf->page)
-		buf->page = (char *)get_zeroed_page(GFP_KERNEL);
+		buf->page = kzalloc(PAGE_SIZE, GFP_KERNEL);
 
 	if (!buf->page) {
 		ret = -ENOMEM;
@@ -729,11 +730,8 @@ static int debug_close(struct inode *inode, struct file *file)
 {
 	struct debug_buffer *buf = file->private_data;
 
-	if (buf) {
-		if (buf->page)
-			free_page((unsigned long)buf->page);
-		kfree(buf);
-	}
+	kfree(buf->page);
+	kfree(buf);
 
 	return 0;
 }
@@ -782,4 +780,3 @@ static inline void remove_debug_files (struct ohci_hcd *ohci)
 }
 
 /*-------------------------------------------------------------------------*/
-

-- 
2.53.0


