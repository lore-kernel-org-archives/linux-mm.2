Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 419C4CD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 07:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50D716B0106; Sun, 31 May 2026 03:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4724D6B0108; Sun, 31 May 2026 03:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 360E36B0109; Sun, 31 May 2026 03:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22C796B0106
	for <linux-mm@kvack.org>; Sun, 31 May 2026 03:03:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CABCA4045A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 07:03:02 +0000 (UTC)
X-FDA: 84826823004.12.F5D6C96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2C5631C0009
	for <linux-mm@kvack.org>; Sun, 31 May 2026 07:03:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KRX7w2WF;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780210981; a=rsa-sha256;
	cv=none;
	b=TbunH/1gVOtSMmDW30D8XM71oecHFxtu5UgdxQzkV0u2lQcyPMUrfcXgIb/e7h7MFXIY1J
	d7MTbuvWWktotkKp64W0D+I+iWSgdrvfvSObDgt03CUPrEHWhzE8iaoaMm+EVzLh+0F89K
	YCCtRt+NWTxYI7TTJGIFi7anlXz0jnM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KRX7w2WF;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780210981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YfIYXFpeOLT8zVHUHzuYoeYdkWWHFupYpwpzBCCce9Q=;
	b=fTqhi8kcnuuP5ixQmYIubaN613OrOTMZOqF3QGgDFRp5HdosBVryfj8gvyYt5CCKNQEMGL
	Um+21B27FM33oRO8raHof85k/L0YjT3WeRmEzvzVrWjQU0Nrjf7GpsjpkDsWfmt/8A1Y8/
	ANLhnArmAZSHy18CfHUE4E/aaQr7XIY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 800CF44652;
	Sun, 31 May 2026 07:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59181F00898;
	Sun, 31 May 2026 07:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780210980;
	bh=YfIYXFpeOLT8zVHUHzuYoeYdkWWHFupYpwpzBCCce9Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KRX7w2WFYviJBkkt8f7QmwdrnwqRcFeA2dtyjFi7ddPKVWmw5U7+XWKIbBHv+Tdlu
	 sD18MWXVqLVjB5/yVC63MoxCGoJLNnK6HL+CPkHGqRnPIxnemNxvUvQc/3neqINWX7
	 TlZQ1DBU9Jcl+u0N+Io58Wrs9Z1R1uhhJTEDSfomNtETyR/CwyXC6ARxQlCuB0/9ZP
	 26JT09xFNOJ5Z1DFg/Cr9GiAq/OjhNkhlDNp5wf3d/t5LdQ4KPmkFlVgcxc9l+0Fj3
	 F9lK89f17GFToCGX16ro0It07MJdu3BiPalcxzwyOVuE2wPhyFDGLYndC8Nzd2hEXj
	 5xvYdZubgeg8Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 31 May 2026 10:02:49 +0300
Subject: [PATCH v2 3/4] tty: serial: men_z135_uart: replace
 __get_free_page() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260531-b4-tty-v2-3-f7149947d4ef@kernel.org>
References: <20260531-b4-tty-v2-0-f7149947d4ef@kernel.org>
In-Reply-To: <20260531-b4-tty-v2-0-f7149947d4ef@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-serial@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2C5631C0009
X-Stat-Signature: c1qf96hwz7s6k9wu8xa18wai3bkwjobn
X-HE-Tag: 1780210981-240551
X-HE-Meta: U2FsdGVkX1/8Q4zw+zGB3Uei90+gcRULJH/+MtTePaitqN1i6oXuCkl2RAaX3xOzttOnQa/RTFFsnKnxTk1tfIoJ5rYr+oVJ8++z7uAGlE0NF59U5f5+1UHYRkEUbovpesEUVMyrWnCSY8gDiIBcAvVLrzdq6af9rl8soRaJfF1Czsw5FdD2U3iu4B5pDfkgff5Zujqfh673oEYqz7F//5yW42aazXkrQ5WJq/MydkPMmnC+dzQ6O2sLzzuMzXMzBj8jL+A7WYprHHJOPFWT2crJUC7BpsiZRFvSgP+DzahcPkU3Ayj96ilFVQGjp+H+28TVKSbDY5hoGx+2fBOhSgAuRvpshIdRro+OYLm8MxHDGnuoNxaMIrepcDMxeU5FD5LFjlc9Zj1y+fNN3RIVxeKVY54x/BFGR3TKFk1PSWV9eX9mjq8uSjMrck8fskrMHPKWpyToYDTUZ115o3/U2gygvdT9YTsho4suoEFLxTajeXMYSDu5wufvsiFjf5DQfOKUnUD7L2KKm1KMRakFlGvcX63++mxRvsP1ju31PqbErMWvkUDPpd/r16RcZ4fbSUAfCWUb+5lEu/EyH2yNIoW8GQZRR1qi62yFVbzYA4gpx/p/tXCN9yDDGgTtfQf+qjfu3uMufKA3EF0ypWMhd6BTMiHW/xYCqlYXkzw8UP1gWljCca5fAh6IqjF3J/DCw7jc/lhNclOrBDA0I6HHUuu0M6F1evBBqtcG3cUuRIs9Ok02myf4LC8W//dz00KNUPNH7sQtUnmJdWXU4ynjw7AOfG6FR175WxrlccGIaq5e5chyTLQydPqtTCcYJzh/WXer0+wKgf34AJYOd38KH4ctjW4yo5F9elmSK0u+kAKpyqRQd7LAHCbztFzqQn7gE+Am7tzoqnFg2DVh4mAaEXP3WQoxp+w1ib2MzIjLbfeotAwGJrh8pouzHsZRKbmr5UkkqHSN2wPWx7slu2v
 Bf+cjVhu
 4DuTMQuvjGbzcez9uTN2EvbklmTKiv7Vo2F7YxZzwt7pq1AYr2/ANTgvI6oB962McpIedkey3u/oWiGDy/yqOKNnRc5N+uphsoN8IO3rLS0PbKK+LI3GYdr6iCJXq2nFRlCZ7U8jIHeEV+0QzuO9vFnI8i2bRoHGkbt6HX0EmnOncUJhzmbYv8NVZt40SkILWz51/VzHb2t3YhGDWI5N10RxiYJoAx/unkxhKlxgUk0NBC18ttiIJbMx9Z2Feh1BvbllRNIJ5OrBQInNy6Sn93RFxF3339K25J2K3UMzRbsfYaxF98i/TcTRsIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

men_z135_probe() allocates a receive staging buffer filled by the
CPU via memcpy_fromio() from the device MMIO region.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/tty/serial/men_z135_uart.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/men_z135_uart.c b/drivers/tty/serial/men_z135_uart.c
index 6fad57fee912..9138fa29d301 100644
--- a/drivers/tty/serial/men_z135_uart.c
+++ b/drivers/tty/serial/men_z135_uart.c
@@ -16,6 +16,7 @@
 #include <linux/tty_flip.h>
 #include <linux/bitops.h>
 #include <linux/mcb.h>
+#include <linux/slab.h>
 
 #define MEN_Z135_MAX_PORTS		12
 #define MEN_Z135_BASECLK		29491200
@@ -811,7 +812,7 @@ static int men_z135_probe(struct mcb_device *mdev,
 	if (!uart)
 		return -ENOMEM;
 
-	uart->rxbuf = (unsigned char *)__get_free_page(GFP_KERNEL);
+	uart->rxbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!uart->rxbuf)
 		return -ENOMEM;
 
@@ -841,7 +842,7 @@ static int men_z135_probe(struct mcb_device *mdev,
 	return 0;
 
 err:
-	free_page((unsigned long) uart->rxbuf);
+	kfree(uart->rxbuf);
 	dev_err(dev, "Failed to add UART: %d\n", err);
 
 	return err;
@@ -858,7 +859,7 @@ static void men_z135_remove(struct mcb_device *mdev)
 
 	line--;
 	uart_remove_one_port(&men_z135_driver, &uart->port);
-	free_page((unsigned long) uart->rxbuf);
+	kfree(uart->rxbuf);
 }
 
 static const struct mcb_device_id men_z135_ids[] = {

-- 
2.53.0


