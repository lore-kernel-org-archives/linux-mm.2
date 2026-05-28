Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBF6ACD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 10:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E833F6B00B5; Thu, 28 May 2026 06:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E33EC6B00B7; Thu, 28 May 2026 06:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D23726B00B8; Thu, 28 May 2026 06:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C26C66B00B5
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:24:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B23814078F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:24:32 +0000 (UTC)
X-FDA: 84816444384.07.016CE44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E4DC910000B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:24:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PiIv7JJk;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779963871; a=rsa-sha256;
	cv=none;
	b=w+YavQmrbdVDeVvzMTEyil0XFOObNlYwA7Rv6ahPwL/QflMgXGirbfxraOPx0i7lu7BOwk
	rgvueeDZ5m32QTxtJfcp3S+BNfDtMRCzFGTwPrdpV5hBKyOcc9JLxqf+PbLo3WF/ezVpwy
	xRTneCdG0n3nz+cTj5mvI9kulzzw7Jk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PiIv7JJk;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779963871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ta/0oVbpc6sVePm8yz332xjK9IjSZai84OyhZWx2wvY=;
	b=DoYmSbNzb+qv2sJZ/jMcu9rQDODLrk5tMIKF9gHCrO8nd/0E/IIqYdZrNm3haanQXCxYYI
	vxEEA6lQAVpv9Z1wLTAmnKeV4GjB0Q5EltwK4JcSCyeJf6sEXhnbQBmWPqvn16M+KzVfMQ
	SZ+8aitNgx1hXJRf+LD+k84u8aAPs20=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DAC8143FFC;
	Thu, 28 May 2026 10:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5371F00A3A;
	Thu, 28 May 2026 10:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779963869;
	bh=ta/0oVbpc6sVePm8yz332xjK9IjSZai84OyhZWx2wvY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PiIv7JJkOzo4JdxeU72/oRH7u/AvKNGTepqd7rEsNwqs2sEgiVotsfsPfCSl1kp4J
	 pFv9jfRN6QLtISOs4+3nsHUhlRZqSgFl6jhnwvYWInaEI2OHUUjPLDeIauLt31M4Jd
	 05p6IYgNa++TupD1Pp2NDGZsxX4eaUMJYKDcI3VJ57J+wHbMdNlQM1Rh6mbh6EovKb
	 wMKS/gH1advcKG0SDDtytjl53TmADFG502oUgAzm288kR3wxbRutTJL/FssL6tgn+6
	 QXYHOvf2Si4sKSeXp59dW9EmAy8fnB+zd666bOHeIiLbxWv+mDWxmpymhQCzQBbIU7
	 hNUcg3QIKI+Yw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 28 May 2026 13:24:17 +0300
Subject: [PATCH 1/4] serial: pch: replace __get_free_page() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-b4-tty-v1-1-9da9f7aec5f2@kernel.org>
References: <20260528-b4-tty-v1-0-9da9f7aec5f2@kernel.org>
In-Reply-To: <20260528-b4-tty-v1-0-9da9f7aec5f2@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-serial@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E4DC910000B
X-Stat-Signature: imau8dqkkby3y9w8d5jbxer38nd1owap
X-HE-Tag: 1779963870-778386
X-HE-Meta: U2FsdGVkX183DvyM0wKNNz0EeoJO9t45sstMTEnvMOorvsb7smBY9xG+CV2dUfs5Ye3XlNaDU3l9ppc8geI/+d9TXYujmGzBLMgEwSnFWsSGnk2QjPcx9OXm1Yh64BDs3vJ+CNE1sYy7cWJttnxU8kzK8Uw35BPg+3WU0i0U5TBnAuNo26hk33Lu0lzXSsuEFmz6Mtsgn4mldAGfcdoEPxV1TVDFn6jdVLf9WTfKfcmR97kpIrIO6qhr3KpzQLRJXs4YYQTIQGdaJ+OBhbpgABIbe80dqoz+35ZqviGF6mwhk/qlIznTQ/YUe4AUZqYSzioSkMs99+J2m2vsjghPX0Rz8Ay2ykeC+umq4/deUg7fOkAfQGym8mzgL+yDhj80mxs4XpyyM1+MveFlSB1jywg4Fv2AyZkxDIHxEhfvDGqI/37Blttzy2oQkgrknIndJFztTR0OOB6OepcDPrQaGJYgNWKMwIyH9wixi9bmPxMXp/L/KZOvk6IOAoGzBzzSojHxGdFoVLQp9+STIdnRgcGTV3cRQgjm5E0kkroKb6SEgzftfjOlfPjNzar2ySmiLxRtnnfVZlhok2al3ivrDm0/hUeKvWVUeNV4UT4BHl/pwWKC/3KWj1isR6bDQvfBkQlC8xA67W576KzcCzdTQg2GVdkOeEkyVXnKCYE26Sd6AeQfsR/4jsEykJdjZx/t6K/dKtyhX3h0JfAeKY4Lv8YWOPpZwoQezcUaCjBcHPzWQOCV6KfFp+YDzsA2uzi+sTXjP9fE3hfkTk93rznAYaT/pz5jJLp+O1RCCUALli/6zHKYBAZtwjbSqk6SrGRDRKge5qpbee6f5BtCLQHOeZGeV2J7x0u3V6ZLDNOtIX53pDK2BmdXh7Rswoay+zaxeu/Kz8Gy6kGY/OTigvhbYq/oEF8yH1SQzt1Er5xbUBaMoqk4/1SGishT/HIdscbbBfOqyCiXHpp8bHncNvy
 S1jn4iP9
 WYH0K2GNlULKo+4gW25yqW+x+PktoggFvZI3KHhai48tV2f5ow3jA732CCWtfW5I7Mtl9IRkYz1NjmbTyBl9K5qdV4Z3rsMZQBBQN+tk2pu/tXXG+6YVqmchz0OIttLQ1U2+R/RkKBEsbzYokmk7fJteAfAen+/cRFvsosRhBZgf2jCWf7UoNhTOU/ePwFfEAj0LA+KNvF5XX/6ahDNEoicDX8Wu49tjZKqAND99rA+R5WMb/BcMd38nWdrUl4qyKotBwhGaOYrSDdIrpUmrAxwm/ZYA33S88c1hSJti/66wTlQO1vYMWJQeBVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pch_uart_init_port() allocates a staging buffer for non-DMA receive path
using __get_free_page().

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/tty/serial/pch_uart.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 6729d8e83c3c..07d8cdb58912 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1655,7 +1655,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	if (priv == NULL)
 		goto init_port_alloc_err;
 
-	rxbuf = (unsigned char *)__get_free_page(GFP_KERNEL);
+	rxbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!rxbuf)
 		goto init_port_free_txbuf;
 
@@ -1728,7 +1728,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 #ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
 	pch_uart_ports[board->line_no] = NULL;
 #endif
-	free_page((unsigned long)rxbuf);
+	kfree(rxbuf);
 init_port_free_txbuf:
 	kfree(priv);
 init_port_alloc_err:
@@ -1743,7 +1743,7 @@ static void pch_uart_exit_port(struct eg20t_port *priv)
 	snprintf(name, sizeof(name), "uart%d_regs", priv->port.line);
 	debugfs_lookup_and_remove(name, NULL);
 	uart_remove_one_port(&pch_uart_driver, &priv->port);
-	free_page((unsigned long)priv->rxbuf.buf);
+	kfree(priv->rxbuf.buf);
 }
 
 static void pch_uart_pci_remove(struct pci_dev *pdev)

-- 
2.53.0


