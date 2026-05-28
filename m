Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A54CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 10:24:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 841F16B00B9; Thu, 28 May 2026 06:24:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A2C6B00BA; Thu, 28 May 2026 06:24:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BA3A6B00BB; Thu, 28 May 2026 06:24:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A01D6B00B9
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:24:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 04A15120786
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:24:35 +0000 (UTC)
X-FDA: 84816444552.16.C3230F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5D8F5100003
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:24:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eceMgPWs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779963874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kp8FNXKpfIDXxy/obg2faB0r2hMuUh4kHDljPd1Q9rE=;
	b=OctMp3XJkLjxWLWOerau3nDumNxX1rEhL6p/w8LtbYWQz45bZHMrufdXm2c7nXUyU+Qaxn
	Q2cIpmTRbQvOqHOQOkxZGCcDzfszpa9gfqyoLFHQW5vnf/tqVAfmDwRjX/wU7E+DmJE6o4
	Zwu14NticRWAocjPuhNl2Q34MnXusIk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eceMgPWs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779963874; a=rsa-sha256;
	cv=none;
	b=kkvqtYUfmXk9Nbm5FWUCmemXGxgr+lSXoKYWqSBQ3nQ/po5HfdzWXsbwSgXZaQiDVKC39p
	Cc5hpH25rrCSU6eRkgZfFhL+//N+B6yQu5dyaWbY24798L8pKqJa9nm6Gu4ZAL3vToYhmP
	dPjRPZnsJdtD1quTG2JE9FZ9F8qynsY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0F63605B4;
	Thu, 28 May 2026 10:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340D41F00A3C;
	Thu, 28 May 2026 10:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779963873;
	bh=kp8FNXKpfIDXxy/obg2faB0r2hMuUh4kHDljPd1Q9rE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eceMgPWsU4Oc5vFuawnPCveJrzbCB+0tKN7hwo77PWnuwIDWdwAHQW15i8rQxXFLf
	 0VV0hnTQx1m89G8N+mk8PGg+SZLqD2YjumWnvoOp9SONohaxubtLyK+z7lpzpQEjEu
	 2pFPFqB0OD/Hx5i5elYXthvWtrxrwQUwuqx2WTInASpP/f6tUIN+tKrZzJ5ZHyoATu
	 U2dpfWJsEUof2EzHCLWebkPnvWLitxizyrxLvmdZ7Nf7dCpGhVHwzj4cTb/VWO46aq
	 rGRLfTyHvPjT2MPn8rJdnnxKy0k4YwMDEyz7Z94/wRAuy/U9CYeNlLfs2gkjQaKoJm
	 vVpMSdE4W92iw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 28 May 2026 13:24:19 +0300
Subject: [PATCH 3/4] tty: serial: men_z135_uart: replace __get_free_page()
 with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-b4-tty-v1-3-9da9f7aec5f2@kernel.org>
References: <20260528-b4-tty-v1-0-9da9f7aec5f2@kernel.org>
In-Reply-To: <20260528-b4-tty-v1-0-9da9f7aec5f2@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-serial@vger.kernel.org
X-Mailer: b4 0.15.2
X-Stat-Signature: tfhg85mjsxngshtg1c3zrdzfarooxfca
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5D8F5100003
X-Rspam-User: 
X-HE-Tag: 1779963874-48899
X-HE-Meta: U2FsdGVkX18lX+t++laO9LM9j6qk9/WblcXUUPHsO6SV+rqaoUubwg4sXTs2f12MMnbQhcn5u8PnNnx3vPbX5tfMFCTos2mY6BAwXOds1E9REl13cRVEafAXtoxVqWfX+2SWrA/oown9theVao4yS5dTuCbPZJeCauHRaBNi2Ue6oxaGs3Hoj1/TcRfFHmyqRHoKUHFcKmuR4Arq1nwNbqOqvp0Qlqfe10zcqunh1yQS6bHFDiYe1qGau3HqrQrxvalHVn1YfNYxVDclnksl2YyEMFA6DZXJ7RGbt59J9erF32g7vbPGRjUVeqW9PLuuZL7e/uwoXJ+64Qkz2LGlzBJB/vfHE3AJ3Lf4fL/UVKf2yGHQ4YuPjrkM9BK7SLrVGhfMFXHQeIGMcxlm2ohiW7wVMjEvM9eME6kpZ57V5xt0oUTWL0rE1iCaBkd/Df2LcNU6SjSRCbHazvA7NCUXmJtTgs7OKfq+K+nds8uUIRPsYyYQmkIYuaI6dCU5y8xT5l3q3XYIli2kbuJ6Vq1KPGFdnqEHMXl8R7xw2ClaJn1qdKAJyVc/eBqWkDu06zPi/P7dlzYNZEDdqqRcjTHrXOnQ9wUXojtjloPFgsDKdlxttAbLcZdeed6RWbPTtSIWiSNZI5qCoUmWHuBhbZNRJjzxm9hTwyCauK3q/R6Rrh3W0lxDl+zF7nPkZ5GqBJi/Sy0IpMR7CJBJ27/XL7foESlws6ISYQV1NzrKmB1Ag7t3pOlyNc5xtez7NxzHzhd/w2BLeW9d0oVX345Ugf3c6zOOWiNHg0CnqkWdFbP93BPEAuu9Q77hHjaBeEx3mOzbq1zCBj1h4i6o5cvvywdgq25WeioPIbDmayrMKatKVi4n1Kn1xIycK1GETvgMFMb7J5yVwQcOpviWUGW0C6/QqVoo2knRMm0kz6ZrmQwURrlVQljiKcP1rgK4CvYb8hLFpocKCZGjuIlsEU84/7h
 JpKcJTGY
 HFUM0vbo4Z5AV84oeMNg/vQbrtB6d5GOKvamVg+mx3bQJTBUKfupRYFfjkusPnYyB/e0TImId66leNiZZSfMseUSI/yVNcGybulyNzRm6OUurseItEzosDhNSn+MmPd1PSxuE4wz9LCJaNywTBJaxu/3PuGNh+YJat5TVldL2LhOBSBKU4HM65OyPif735dLRDgaOZ5od8MzNyhpieLDeycKejQSmtjlvW844VbvsD9g7StEqQiDSTdDnKT+HUT3+gPEsly5e8XPmIEo5k3IFYzfy5w9xSMOZS86cRZEpAljNg2lYlF/AWfZiWQ==
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
index 6fad57fee912..9c32b01edc9e 100644
--- a/drivers/tty/serial/men_z135_uart.c
+++ b/drivers/tty/serial/men_z135_uart.c
@@ -17,6 +17,7 @@
 #include <linux/bitops.h>
 #include <linux/mcb.h>
 
+#include <linux/slab.h>
 #define MEN_Z135_MAX_PORTS		12
 #define MEN_Z135_BASECLK		29491200
 #define MEN_Z135_FIFO_SIZE		1024
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


