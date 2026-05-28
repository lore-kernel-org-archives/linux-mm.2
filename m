Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8D55CD6E45
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 10:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B7116B00B8; Thu, 28 May 2026 06:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F2436B00B9; Thu, 28 May 2026 06:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0FF6B00BA; Thu, 28 May 2026 06:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5762C6B00B8
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:24:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 200A61A07F2
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:24:34 +0000 (UTC)
X-FDA: 84816444468.26.B978BDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7D40BA000B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:24:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aS4ISfHm;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779963872; a=rsa-sha256;
	cv=none;
	b=pvsROIhGLMLCrxCk+zftnujct09TXMQ0X6xY7d03Pog22RHpiPSnAE7vs6SdUSnb+EHj/s
	w51hPkf9w4QTfE3/78ve8xxd1aUl7YQG/ezAqM22zY5LiSrouumftcTdHWvaEMZLnHtEGy
	GZejPrpUEd4NwTr1Qa9VpRrArJtW0Kc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aS4ISfHm;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779963872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hba6xOKzIlLJw5sTi2ZReL79jUmA452phwmu2dxW8ao=;
	b=7YkeTW56APtGaU0uC4EQW0LMMINYku5mId1nD4iyt8U5NGFe7U8/UOtUirvsUUhz0erVNg
	lcs/TRxVZEuB4s3ztBe+s9TlD9kTZJhqHigt4t028kasY07cs8ebJdmQmk8cbMSIVDtvkk
	WrfFwnH61vyhVvAR+Yx4pmAfNymu3oY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01611605AF;
	Thu, 28 May 2026 10:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EC81F000E9;
	Thu, 28 May 2026 10:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779963871;
	bh=Hba6xOKzIlLJw5sTi2ZReL79jUmA452phwmu2dxW8ao=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aS4ISfHmV41rmJIm1V2p4H0CXtXm6mS+vwe1o/vDyVvf25Lp+2s2kqqwpdfIMzvSJ
	 6A242Q1r1N+tNodnsBU3RuqGfe2qVG2PMMkFCSqzdE334gggluKXh0MhkqDE3xsFfD
	 yQNc6x5lbagyoG1RPvq64x8iVEZt7baX3wtzVPHkB2rj7z+fGZKRKC5/VbOn3u3peP
	 UZbftcffX076EExKOkRtYkiJZSbEIxEbrHNDoohGyV2honUKmfoK15EN4z76Emi/DV
	 6Dvw2OyUGXta8L4HXAUmDblHz5c1LZSIoFhmaGpyCobr1WwfsI8nytlM46Vxmao+kO
	 9rjSPjLTeKXFw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 28 May 2026 13:24:18 +0300
Subject: [PATCH 2/4] tty: amiserial: replace get_zeroed_page() with
 kzalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-b4-tty-v1-2-9da9f7aec5f2@kernel.org>
References: <20260528-b4-tty-v1-0-9da9f7aec5f2@kernel.org>
In-Reply-To: <20260528-b4-tty-v1-0-9da9f7aec5f2@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-serial@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D40BA000B
X-Rspamd-Server: rspam03
X-Stat-Signature: nckqgtoqa64bubw8a5m9mcqmc8d678q3
X-HE-Tag: 1779963872-503166
X-HE-Meta: U2FsdGVkX1/TDBYyCnH7viYxJHZJ6zjhmRz8+HqKwxC14Ehbgl72ytO74mjuuOVw/0ChWCUMGGcOGJberczgDbPsZzjzYo83yj1Vo24JAUuWud0Qs3yGz4II4WcmAEd5vp2VkltZRJE043b2WAKMpkv4v+tlzKWEaHjwT+flQEErbhsgv2Y1nG/UcuMZbvXKRoJVwYZ61FXBHBQh8Ap1UWSfnAuHpeTLBUpqcKhsDsuTvdlS58POE95mDu/6b85VaYx0dh2DnloXDZF444UBUqYkv13yZahFBjMJvByjzzLO05QWCGi9qtcNDK8mp9CtgjPlWWjCvPElL5h819/EAHsb/wMcNnIbLgAlLXbdpMoShBv+iQTZaRuIIVWqUO9GmCdIxerhCWN6fGJYGTF1DF82DGyWFRjy9MYJv6Qp9dF9w/2igzS58gKhknUlyny58hgskDTAdG1tcmqC1CtETlHw4mqKCrA8l0FfN4XXwfnHe7AKCsMmHnwiGztqe6ZSKY+84xKe1pOVrNJ45ujbmENq5dVNsNr3xAhxD0GbNu+KX9FIUlkKlhmLYFMk59y+OufF6FFjYEVIeBnWmnxrDOhl10J1ESAyRAqJeqSV+aCrbzk+ObPupc+6oKE2JO4vr01uXMBuJ5K2qaV5sQmv0IOisI/AspkTCzwkjVx4zp5d/VUXYblwYE4duTj7DVsXHz6LW6LsLOTuumWfgVo/mu8eRmqP48SJhRkiq6MrAmTkHMQeGhrpdkL0SsV06fieDSndTBri/qLlPl+A3LCucYMO7GTgLKkH2niiQZvi+YDCaRsQmm5ukrc9wNf4K8uzRcvzfNccKX/f9qJvVpLf92dYXb6EurEV/V1b9ix0nM/C/gc+CbLZvMdYMSQsLkOHg24FLxjxeSBQJ5uYmsSu6X1gnYB2Va8xutfma8pQJlQkvxSKXrow1kM68Xq3R5To2elDv9wb2vJd7XK+Ksy
 ZO5C1gy0
 k8k9TWIdyMteJ5/gmQKbqNq+yv0ZqiLOr2AybhtjkBSlKoWjx601XPUq9itCF8Pk9LHqinYfeAmMOtZvYmW5OaMkSkCsxfwFkHOf9dQ8O7VCHX2ZM4dW9xFnsBF6aK97NEaJ6SXKnZiMGDAST13Ln5s8A5gYw4rdwyhxL02/KYJ8cvyOD2HP/A30C5fR6m07stkJRgfPJwsqfVyESH4lGoxyVrYXDTFHPoxr2yKPf+cG7e18ry+LUOnJUD5ubwraHFlbipyE0Tm6YUCanY1HUbMI2oGtY1vrngMadpr46ZppJBBc+XN7Cw+Wj9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

rs_startup() allocates a transmit ring buffer that is used to buffer reads
and writes from/to serial data register.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/tty/amiserial.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 81eaca751541..28af0fd98181 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -443,23 +443,23 @@ static int rs_startup(struct tty_struct *tty, struct serial_state *info)
 	struct tty_port *port = &info->tport;
 	unsigned long flags;
 	int	retval=0;
-	unsigned long page;
+	void *buffer;
 
-	page = get_zeroed_page(GFP_KERNEL);
-	if (!page)
+	buffer = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buffer)
 		return -ENOMEM;
 
 	local_irq_save(flags);
 
 	if (tty_port_initialized(port)) {
-		free_page(page);
+		kfree(buffer);
 		goto errout;
 	}
 
 	if (info->xmit.buf)
-		free_page(page);
+		kfree(buffer);
 	else
-		info->xmit.buf = (unsigned char *) page;
+		info->xmit.buf = buffer;
 
 #ifdef SERIAL_DEBUG_OPEN
 	printk("starting up ttys%d ...", info->line);
@@ -537,7 +537,7 @@ static void rs_shutdown(struct tty_struct *tty, struct serial_state *info)
 	 */
 	free_irq(IRQ_AMIGA_VERTB, info);
 
-	free_page((unsigned long)info->xmit.buf);
+	kfree(info->xmit.buf);
 	info->xmit.buf = NULL;
 
 	info->IER = 0;

-- 
2.53.0


