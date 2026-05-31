Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3357CD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 07:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C89276B0104; Sun, 31 May 2026 03:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C39B16B0106; Sun, 31 May 2026 03:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50AE6B0107; Sun, 31 May 2026 03:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A148A6B0104
	for <linux-mm@kvack.org>; Sun, 31 May 2026 03:03:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B5BA1A0397
	for <linux-mm@kvack.org>; Sun, 31 May 2026 07:03:01 +0000 (UTC)
X-FDA: 84826822962.30.35CC8BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 89190A0011
	for <linux-mm@kvack.org>; Sun, 31 May 2026 07:02:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XJHQgCOk;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780210979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hba6xOKzIlLJw5sTi2ZReL79jUmA452phwmu2dxW8ao=;
	b=PSyM9fwQGaqUzjUyvkEMuK+FpNHvKjEZe/feNbvdgolhzhXkt8GFC97UcJvHh4ekEX3AMo
	005Us/lhaHDzlNrUBWj5zdX4WMXx08NNwQmFl9rzTn08jIDB4p74+emNxIviUnwK0SRUGd
	sJMfyCtPUiWVAJaBOurXcU+KwWwG5bE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780210979; a=rsa-sha256;
	cv=none;
	b=vTTuKPaUkcmXXDHD03w7xs5kpxsiJHR28L9tfj2kehkSL+Tvt/8AZ0YwJxMmCdEP/Kus2r
	EAqIOupacl1yJMMV4+Q3gA7cyHnvbBD0FHb91hjsTnzlqWojyuJmRgH2e1hhd393+fV2hP
	Zr8nHpbLBJhoQGzIfHxlP2CiduuBugg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XJHQgCOk;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 816EC40030;
	Sun, 31 May 2026 07:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E619C1F00893;
	Sun, 31 May 2026 07:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780210978;
	bh=Hba6xOKzIlLJw5sTi2ZReL79jUmA452phwmu2dxW8ao=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XJHQgCOkc2ffB5Mm3D/Emh3q/0YrgxHxa/6NKeKvV3LlKHxB15du9+mG80y69j6Ie
	 2mGwmtRp7GEXHSwMsjCX0Mr58rNLbjH/9f5ALcz+O0MAH8ZlFfrwnkkOCVnhp2MqQE
	 E5GTfhwaggrQygApbI2xuXFtxeKQeG0y+2lZSUVZsVPNGhhZ/1dOCAZc14IAvDoXXs
	 UqDHyA4/nqjb3dLxqquM/+PEbehMuwQtCYl4vH5insW3WxwxVk/IOjGctF0PQO8Oig
	 gMm+t418m9nOHIX+b2TXBX+sq2KgOiRur4HxHomiEstv6DHcnN+Nyughee2W4q0bU+
	 ltDJcwrEEcb5g==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 31 May 2026 10:02:48 +0300
Subject: [PATCH v2 2/4] tty: amiserial: replace get_zeroed_page() with
 kzalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260531-b4-tty-v2-2-f7149947d4ef@kernel.org>
References: <20260531-b4-tty-v2-0-f7149947d4ef@kernel.org>
In-Reply-To: <20260531-b4-tty-v2-0-f7149947d4ef@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-serial@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam11
X-Stat-Signature: 6nnkdczeayihysj3kb8z9ec9n7gi5547
X-Rspamd-Queue-Id: 89190A0011
X-Rspam-User: 
X-HE-Tag: 1780210979-916566
X-HE-Meta: U2FsdGVkX197GAJuBLT/ammagrXenwhi6gygVF0T7mTl/o2hW04gI21Q8bq1PGPETqGljo+YATRQG8jhFZskPQoXKcUg5KFsujj6BnVl1KAlQPMEtXMIWC/zAScgLzBSa0Se9j9wo3xx+fhv6vivvvOENbmqTruhgtAsZzrjPeYJaCl37PMGjI43dLp/fiMnEVcyx1k/bILUijmu5FMBeeMQYAWGFlgytZZjH5vTutE/4wJy82mAHbqfsMU3tAl/rNrniBVv/5jnfBPqZ9GTlSTr8kMYPX/p3mtkVGmCHWxo1/fOvcIMW6Mh7KgM7Rv8d8dnBdgkPPuderheWlPBK6aEIek7YcDAo8rdbECLnEgQg++V0dXp0LGCKoC9frHge+gGmviZP0mP7sNyiRljkMs06w8m78lUuf1eijW6PwQphlJTgiT/0uUic5odFN0ls6risqaL+yo3lxu9e4s6Td9gPk+yvoXcNA5tcMJapDtlSvggFEwhFEj7dNavTPCCwXtge3Gu9KoAEWyLGr2ibkNvKTYGLV69mfdvPI88kh1KmcEzicXK1rd2tzOyrgOdS99VPah9eUgugAicsPlyUEuIATXu3cdhI7nQjrZkdC/fxeAWeSl+My5COiim2Gd6Ss0plD3dcKLa3ZdEPkZ4Rzs9sk7CNdcL5/VazvjHPhHpUO69DCLK8VtPdyKS9YuhYwfweh99Nr2KOk46tOAjq2LaOQOy0sdoz8Lbt1ibhu/hur6tTRBFdPQcSf+ZwytVA6rZ37gO0cLoD23sciAw+JUmo4uXY3wshWdarZnaV/MuhUM73AF4VaB/n2r2Cz/8hZ0oodkBgXp8xvguzYQ5aUryFVR8tLfrydmYbCOjJUBW80N3zHfyoZIFqW9vjy32vkf0BpgQ4UgWkPh43c4rc86OG1d5S0HvoXTbP0bTbd9ztnPkzre3REAkVBKVJijpp0u9q5uQ5CYmWEiQwd2
 49QTA9Xi
 uAAtxgBF4qSRKsZ9Dw/IOukZFJ2NkvhOZHnRAkyAsPpWMUwHRrpljXLpLz5kDa5npjIFL35CA4oolUSHvOnl+VGAsaLNYS7v2UqFmxrD4iNy3NIkFgPkowsfM+5J5v2ijzN2mdZeei41uGabQfsQx8kX1fP9ZroV1mW4hSsmitYtjtyjMHufnNN8qSoWFWzEGEmKLfaIkwirPOSl6R/1ZY+SIUW6mZU/L6vPJj1OEoIRHSMwJ5IITXiSgGMqdX3dmaiiVSbGads60uhckl1CB+H2Dc+pARlYWyIDIP5LEfNMOyVUTJEwWzY829g==
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


