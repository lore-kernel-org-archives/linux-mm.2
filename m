Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 844CFC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:20:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770B96B00BD; Thu,  3 Sep 2026 07:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748766B00BF; Thu,  3 Sep 2026 07:20:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 686566B00C0; Thu,  3 Sep 2026 07:20:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 455246B00BD
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:20:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CCA50C04C8
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:20:02 +0000 (UTC)
X-FDA: 85172206644.13.DFF16ED
Received: from mta0.migadu.com (out-91.mta0.migadu.com [91.218.175.91])
	by imf08.hostedemail.com (Postfix) with ESMTP id DAE7B160012
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:20:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.91 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788434401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AsFrEl/48MYT8zMTe5tnHUhbdfz5N1xwl6PQqIM/ie8=;
	b=kbNdDsW6PL/edutsZzo3gFX9Up1AF7XQ24X9Up7LIZv9vJMMF3Cj1GcIMFxnnWInEZAA3C
	ApLTqxbUZ9Cd3ZZ0TREG36QlEhrerorY9tOb53//WkDPDHghS4ThmLVRJxxGu845sUCgcK
	3EZ+vs105ajMwCkdeSvHVtk7plLmm0c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.91 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788434401;
	b=39eVG0iakt9nasYAVqOFgsokXcnov95ksnvwC6UURMVntsmXaLDSqjPBX3UGeWgdBnZoQE
	WAhqQYc7N7wSPCPJNOt9paBdG0j/qfNO9R33M3WrAS6qslWVarJtsNPPoYsGpbc5MOhR3Y
	ozkXe8j7cZ8lkEGoiXvygBY3ZxeNK+g=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id a78dcd8124518ee1;
	Thu, 03 Sep 2026 11:19:59 +0000
X-Mizu-Trace-ID: a78dcd8124518ee1
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hch@lst.de,
	harry@kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>,
	linux-mtd@lists.infradead.org
Subject: [PATCH 12/13] mtd: rawnand: gpmi: Don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:35 +0800
Message-ID: <20260903111836.1777265-13-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aneac3izwy1xojdbskfndcox55mhk1x8
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DAE7B160012
X-Rspam-User: 
X-HE-Tag: 1788434400-807870
X-HE-Meta: U2FsdGVkX1+tAFQoS7p8AFD6gOWqiwn5H6h0JlG0GdkhWgBS56/5J+vmoTh8M8woWejhNV6kXa8a+YmqZ5fuE1nvmB/STTXIutcVzDzjIevW3/oD96G1XxbcICF3GGNuQZwj4c7A7+ORt16i9KzfRIXF0Xzn6bB0PM/O5wvCbC8l+wwxo0Zl29VGb34MUfBxNGoB1v5tU1LmmxdDOh12ndmL0PEewpTN+RoSglikAueOjY8ij+m5dnSl2KCzreOl3MB0eqSjAEstuzqh/HV005WfWcg6LZLssYjiVUvYuZv5JiC40XwJrjnXaONNe+XfUU6WkICRT6SN7Xwtps55Lv85AkGFDMsD9N1Y5VQKqqej5oZIkndrNCqNyEx3kXuGDRlnrEfs/KZ3a8YJYYDwH7Zbn1ko4g9HZ5ec8DonGXcXHIKfH1aOhHH0yfE1ArZ33uSFx7OqM1SIDipvNRf/KmbQlAtXMwQM0MFbOkXnLm97VHXt3PTNJOiB97BjUKQcpARWUd1ryHwmOKKIniD5BcMSRVPqsYkbQr4YS2iBFRyIz0xi8OA513rmsq5PgR20LI0ct6tVBYgoTckAwzAihSmUW2it+O6Pfy7qEJfoC4nRR8qF6MEzlW3PdcvhkdQz1yeiQhtS4rkuSa9+ArpLFUJG9/mx2Tp3BmDwYPjFz2/U6HaVTKltZKELoIzGYtO54rC+4Kr5o47mQVowmFn31Nvq4e59WHYl5pZdK/pHQ7KQaH7Hod+/IRjW6fo+QLFxYe9WwCR4p2tsKHQSyWAzDUixKgpZHqerza0vv4BC8qZumY7WPbJlT3X6wZzTvnNIf2Spl9e6nhzzJCA6dtdi1M3NarHO32ReCJkx6V8LJl8krdidAEJOCm8epzA62SvVvuCDJifW/vsM66RT3v0FBdJhgLkHv/T/HNarzfMVxhd7+fG/UJ+mIXk+Z77zv9eVgvL6rQBSOLuI4DEVmGG
 A74nWO9a
 9+AT/aUyXGb7curDJfnU1t/AjPOQvEk+8oG8UK92gs8ghNFxrHzltcI4wSb9lpJr69/5fmCAnzL2KohlFBS/6VL1GWydl6G6+SLWkhkmyE7pB+X1DqqlX3auf4+/Os+dxbLFIqz2dFvCEz78/HAKmiIgLBCEWRy6YT3aiKvXnmMl/LdlUQdhyn8cXym/lbCX8OgZxChyT/K0xqgx/dSeB8id08QgsRikZHBiw3UCYchMCTzd656CXQ/syfDovCsHoUUIIak/m0TIgRrT2DP4gZU4KKlqYN1Raae4yM2vPuYWEIY6xHMpnMTz7CQ3LZWhQ1u/DKA7iM+uZyTY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dma_alloc_coherent() allocates the DMA buffer with the device's
addressing limitation in mind; the DMA core picks the zone from the
device's coherent DMA mask and ignores GFP_DMA passed by the caller.
Use GFP_KERNEL instead so the allocation may reclaim as usual for
probe-time allocations.

Cc: linux-mtd@lists.infradead.org
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index 527165ccc839..0d91950ae9fd 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -1387,7 +1387,7 @@ static int gpmi_alloc_dma_buffer(struct gpmi_nand_data *this)
 		goto error_alloc;
 
 	this->auxiliary_virt = dma_alloc_coherent(dev, geo->auxiliary_size,
-					&this->auxiliary_phys, GFP_DMA);
+					&this->auxiliary_phys, GFP_KERNEL);
 	if (!this->auxiliary_virt)
 		goto error_alloc;
 
-- 
2.54.0


