Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CCD3CD6E51
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 07:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C13986B0102; Sun, 31 May 2026 03:02:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9D186B0104; Sun, 31 May 2026 03:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17906B0105; Sun, 31 May 2026 03:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4F46B0102
	for <linux-mm@kvack.org>; Sun, 31 May 2026 03:02:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F0021C19C8
	for <linux-mm@kvack.org>; Sun, 31 May 2026 07:02:59 +0000 (UTC)
X-FDA: 84826822878.30.5839C71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9671114000C
	for <linux-mm@kvack.org>; Sun, 31 May 2026 07:02:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OZ1T1otn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780210977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ta/0oVbpc6sVePm8yz332xjK9IjSZai84OyhZWx2wvY=;
	b=BHHP1P9xLLuArdIa69PYF7O2KGDm4IUThyCnRDSWwUyJKzALaIVONEuu4ou4hHSaNHZB5a
	aOm2wBlyJr+Nf5CGXyWeCJxKEKNO9Y/T6VXFJ+EgiYbPX6xxQoUKiRu4zcM2tXvhzdicus
	P/oHRweHqCRZeZjP3aST2DaeTsbkZDk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OZ1T1otn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780210977; a=rsa-sha256;
	cv=none;
	b=cWCZlvE8hyDgy1GDlzgqwKQtDIBOREwFcQ4ohFSRzO30/XIQOlNKJjw4Ab/nInGeZgAzuD
	Eii6x9VFl8/L+n7cFvcksAbdizbpQ6vDGOxi3Z9c8zwbxPhA+MwNRp3O5NtNAVQlXIaTmC
	IOvLqs7i7FogRY+tlBL+UCQTnud5DWs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 81D43445BD;
	Sun, 31 May 2026 07:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65AE1F00898;
	Sun, 31 May 2026 07:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780210976;
	bh=ta/0oVbpc6sVePm8yz332xjK9IjSZai84OyhZWx2wvY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OZ1T1otnLRkDs0ffpBAEw9b3XUpvTWWqBD2U38Zz4oj0D6Z2ETTgN2WT1qH705yAx
	 B2wDGw90G5SsSh0dhUMoRty+4X67W6LncfovfyrLspv73cXJK4fYOzNpHig+1Ky/TV
	 0hfI+KxxFpf1v/vFljDN3c39yVsxtVee4zqoXewkKza589kJ8PztAiiKRedMOwstfJ
	 3IHTGJaqDjmI5EmDMpV9GBEhYy1/bika6roBH8yHZVhpj8t8l9om31jevfr0/DOHl2
	 gseA8oBCg5kkAl4e4q6IfLGdjYWotKZm73AArsCqJJPxtYfz8+AmceR9uXy5SksufL
	 GcziG3wM0jWRw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 31 May 2026 10:02:47 +0300
Subject: [PATCH v2 1/4] serial: pch: replace __get_free_page() with
 kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260531-b4-tty-v2-1-f7149947d4ef@kernel.org>
References: <20260531-b4-tty-v2-0-f7149947d4ef@kernel.org>
In-Reply-To: <20260531-b4-tty-v2-0-f7149947d4ef@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-serial@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9671114000C
X-Stat-Signature: 5xswqhaz4p9bj4ujyip16jn8fohn86q1
X-Rspam-User: 
X-HE-Tag: 1780210977-832927
X-HE-Meta: U2FsdGVkX18EeCIFGN+v7UXJE7BF8z3y05N+0bTtsJ+OkQpsK7IvgwjrxkSNSfsOW76C1EjVK4HSnPTWLEOlqkuC1YjdbakZFG6Y9g+TTQH1y2o0EtF10G89cn2FHxQtiDtc9aIj6viZZ/lpKD0j2TXsnLyA+Wj/1J75dQZvg0dvOobppJTeDgk1bKEOz8aGRWLEy6Dfv8nFQoHwUEM3vBLACFgqlFn9Fc8Z9/GgJ3SRW6aKhOCXlAynpvc/dNc+u6JywIQ08NZfIBACF8NMyob69kX9ssMBbhpVG06KuweED/aZv4JXqdLPLSMRi0tjieRp+2TvCKyqmqZkAF6+NdvTmogUPC+Nd0T6mBogd8IfB+Mcy6VlvlEBft2yJoYFysLhchtWSGCe92O1qMEI18kKn0/uxe+VU/ldGBHup2r7RZqEZ5aGdv8h2qZTJIJVdhaX79Hd3YzAgdi5snlltLOQq8QqfoQnGdnWbfqNMy3ScwkPF2Dk/9pzNq+KRvS2Bl8WWJ4wtRMkoPuvDYhbTL7pakB0M3MK4Yh6zrDZBA1DAAMZU0rrmte/zFwN6bgluNzZc6lHprR+9TYV2ctpqT8HWgyunlM1slej07kRVtpMVwR26aW34Vj9j6bv7fF3y+eFWzaR8jnIhsYQqg5dDJY5eFloRyjzq6DhQXQ6CLaaVnud0+EtSr98BG21KR9cTj0MGkdmKGdzSO+6+Ad+607rMfCqwkUWHjSiTB0atINOlp4uyU/koer2wP4Ll2exA2bknRDnZ91jeO1/djdRIhzJhgVEAvtrBey+DTk9Zd8b0U77CTvXd/S8iX4a1vJ7RRuLZlOztVYlGOgKGYoWsqqEKOTt1ybU9I9PHn9Ts4b4zy6JM5LIhAhlgCqCz+iFX1oEuG6Qhpu4Y1afy10xGUIsnfm0jhu22ySQt3jq5HAPKAdAUiA/QtMMUeOfw7NN8K+M31r3wZwRuycuWa9
 22gyEFK5
 T0I3X9HMclog2fiSymLlOxKJX+109Mh5w+IOkOPgf1G+yDNe+JhOmj/mF4FkmJSrOKM8GLVAg5c23hJpkTOqTCZVfl+F6vzSbN0akEer1bIUEjOfymoMZplN+Qh6XcBUvjK0aj3yCwsZyf4jZ1UhcCG3gIYSTxPLMYVnTj3Wg/Xa9GDxC0nSox0isptK0s9BE8z0uA3i1bEERkXEp+UozF/TaIpaGcCRzQMGCB15pGOUiefqsWE0AOFge/GvZ9Sk+8ZCPp/8Pz0GuDGTWxKqim2bWtHZ+O6XYb/jLYHpsh1hXSGPn7iIkEetqtA==
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


