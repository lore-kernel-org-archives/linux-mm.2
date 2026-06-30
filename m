Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1AB6C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:54:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC5676B00AD; Tue, 30 Jun 2026 05:54:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FB46B00AF; Tue, 30 Jun 2026 05:54:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3E866B00B0; Tue, 30 Jun 2026 05:54:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA956B00AD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:54:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EC5C5167F95
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:54:12 +0000 (UTC)
X-FDA: 84936118344.30.809D2EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 534B3180006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:54:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gq7GrQsd;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782813251;
	b=nwtSQdMdlkxpt/fRea9E5/wyy1zktn/rnT4qAav52bfDBCUyBFPgqX+z2G1a5GWoBmeTQR
	vtdAkiYQIDO3rwVffz8/tSI7p9xEmmhCfxdiSkQ9wO1SRoN+W9z6bzZozGXa2ApR/8TjuO
	uu33KAK+Fp2ACLSQesO1uwkfqMEz1yw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782813251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJKL9JkQxNTf1bngWq8d1w440OVqBAHr3cl1Tbqc2Ns=;
	b=5al2Jh58dOE8nSKdLItsWaF+WS0l+ChoJVFII1NyyDmI8EP11dKfzLP1x54Th13s02vZlJ
	VrNSFD7CurEUDeDAvK76IkQGWAjmH8OjYdlnQFfUaCphMlvMJ6c3vAO1nmEr6JFYusBcTV
	P0J3cs+y7/ISy9E8oAP4sZUdwmTwLA4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gq7GrQsd;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E16AF600DA;
	Tue, 30 Jun 2026 09:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361A01F00A3A;
	Tue, 30 Jun 2026 09:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782813250;
	bh=ZJKL9JkQxNTf1bngWq8d1w440OVqBAHr3cl1Tbqc2Ns=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gq7GrQsdAIvf8OlFzgPzvGNXV5ZZ5Ot4/4Ej7JU/TFVUyuIDKzMwp8B/iG9lam3bm
	 qOuGRPWOa5Fgs5wI+IzWwR1HRReJ95kH0mDBUzwxv+MdJMPYC1fFxRuOUx+sI+wMUB
	 DQ7a2EARJs6naD+scvRNybc2Z97UpUWAsJE2zzTPi/yMNGp125i9WMO4gjXh8VLbL2
	 7fnNOr0MTVQ39Mcyh73FhzYo7fqWPubFbOfNXDRF4VFWVjC39FoeEY+YR2HNMwOubg
	 VLBszS1Y7EAgO1614H6OJspiEfIFnhgQBTpnlK1h2p/QzsR1J2WSdox49rFEC1XXZI
	 OnXId6JipgNcg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 12:54:03 +0300
Subject: [PATCH v3 1/4] serial: pch: replace __get_free_page() with
 kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-tty-v3-1-a8476c66c582@kernel.org>
References: <20260630-b4-tty-v3-0-a8476c66c582@kernel.org>
In-Reply-To: <20260630-b4-tty-v3-0-a8476c66c582@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-serial@vger.kernel.org
X-Mailer: b4 0.15.2
X-Stat-Signature: htd6hmp9bhwcp3f7foug5faqe7h9ggrd
X-Rspam-User: 
X-Rspamd-Queue-Id: 534B3180006
X-Rspamd-Server: rspam02
X-HE-Tag: 1782813251-441946
X-HE-Meta: U2FsdGVkX183k8BpiOy0ou/WtTSnNambWx9dlGPEAWF3C1+03hRvU7QAklHoAtJRvM0bvls1+ZvXVZGxsIzeVl+u/hcBhA7BxGvhwINKseQQCyLknphecTnmSnjdW0RbME88S+xE0k1wiLMEoZipAHnKZQrIfyIjD82FLzNwCR1TEKAFT8189P/GCpQv2VbympO5R+YIvw0rutf1STfx03wLX/W1PqNYABdty/DnMYPPsCcgvcHPpCeRkD+Ho24OH586OeIH8wWhtgEbVxhoTmqYctu2jnqNm/6NTfKUAwzwUcqTbV/tW95z915ItPoOeq8eJhm72ArpVeJGN5jKH3sh8B1V7shynbHqESMECmXx5pc7E13UBKP444i8obf9VF8XfCcAQFYbwoBZdLayJUq5wUaO+COpk16R4zt26KkPS3TsOJTlCtgNiqKkMZdYNhXWyGxCJd9LW20UO/zBzcgCS1pFRMmqz+GJhF/1WV6Xn3RyRptKpp/FALfH+CPjzg9qz9YGSnDkbhhtpQkgmT8BrBs18vv8qgoHOl+LSjdjoxfXeCGakzLa6hOC20OGBbIbddl1xg5KRLJDQwqDitmIfgdMnntkGUgYuxTgTpI5NzKDMYqS31I6jKjr1Jas3F1w7s1T2Dj78vWG1zfZnNAlPu+S1EFYsuzxyczC35Eb1hp9wrDmKtlFTVkYvDXbSew8FOt8rqCmtLD5mqWEEAzIw7NbdT/Cj4t0PdsUTs2cW4EYbTmoorrssZ0iNx51naUOqp4E9HO+PN8WqU4gjXPb+B1hcVlN4MmtU4ltZoZ6eTwY/Nw3YkvWw4MxuEGF2p3L93yE5KAAk7oKypLKknQ4INLH4l9sApZuwRBiyQZBcWIIc8LHMy/uVEfbxqhcUHpI6LEFWQhfdiXbz2KU14OgxJx8mm2dOGP0GbfJak8LxQnBD5fmDSwZzf/Da/GJ3UiMe4lg+8W3iAeD4a5
 E4nZfgoE
 jKC5hlKaQg0kfnN7Jt9JvR3K8s8E8kgzLseEoAnf02rXY7UQxPF2iHSP5TADfqQXf+SDMTLMcpNzJs5rhyLhhdJh9zr3m7fd6ilhpIpRy3k/ZRPq5kfdFeSIpwyR1KvRxMNoxqacEMywMJCD3s+XRx3OkKnuEDYI18r/BJh6M9iJfO8XFTtwZ4uIGxJw6iOdtexYA/C0NJoEj+489LiTzyhdV+3NtebF0qxzhJIhcsKDt7LvNEbnJ0+z3OPtl72icuQqDpsl+zmRpBTZ04WghSDT4ZFw458XgkRx/FelyKXrmk9yRq2YOzSNU2w==
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
index 80e31c4d9536..5f7f073f285e 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1662,7 +1662,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	if (priv == NULL)
 		goto init_port_alloc_err;
 
-	rxbuf = (unsigned char *)__get_free_page(GFP_KERNEL);
+	rxbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!rxbuf)
 		goto init_port_free_txbuf;
 
@@ -1735,7 +1735,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 #ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
 	pch_uart_ports[board->line_no] = NULL;
 #endif
-	free_page((unsigned long)rxbuf);
+	kfree(rxbuf);
 init_port_free_txbuf:
 	kfree(priv);
 init_port_alloc_err:
@@ -1750,7 +1750,7 @@ static void pch_uart_exit_port(struct eg20t_port *priv)
 	snprintf(name, sizeof(name), "uart%d_regs", priv->port.line);
 	debugfs_lookup_and_remove(name, NULL);
 	uart_remove_one_port(&pch_uart_driver, &priv->port);
-	free_page((unsigned long)priv->rxbuf.buf);
+	kfree(priv->rxbuf.buf);
 }
 
 static void pch_uart_pci_remove(struct pci_dev *pdev)

-- 
2.53.0


