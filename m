Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26BCC87FCF
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 08:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95D6F6B008C; Mon, 28 Jul 2025 04:40:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90FF16B0092; Mon, 28 Jul 2025 04:40:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FDFC6B0095; Mon, 28 Jul 2025 04:40:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 712306B008C
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 04:40:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E58A71A014A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:40:19 +0000 (UTC)
X-FDA: 83713026558.15.1E9D453
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3B77D40008
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:40:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=S8+76Hp8;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf11.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753692018; a=rsa-sha256;
	cv=none;
	b=AoKbME7vP9JGcGxFSy8stqhAgd5JF/0JZUAZiCAsY2s9l9Yph044Xc5IK1OCzAzfwCA7Cx
	NVkSxxuFc3WUM2IT0d5GytvMy6f5db4hcPlzfW37LfGuGSr1QKaYeTv8CkKNdJlBa9os0t
	nMeeVtmKl2rBDZjczkij8KQ1AUFu37g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=S8+76Hp8;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf11.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753692018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zkiIDNJ189UN3Gvigro6HmhFmr3/xqt0rx4GudPl97g=;
	b=hwDbKAukaKgwPMPLmvIP2QlQgte5Wp/41vjOnAIPIFq4adouLqIj8xYe1WwJa95yrF8QvU
	w0GyXW7r/n22g5UMdcxGpfaMtKY75wCx9p+oF3mlcLDrk+z6oMvaFrtOQkKeIEOmq49IjG
	yw+2dshpsjSGuwVoVax84/l41ejBZY0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=zk
	iIDNJ189UN3Gvigro6HmhFmr3/xqt0rx4GudPl97g=; b=S8+76Hp8/WS9fIVESB
	XjqzjYH3q5dvVgttmr85KXXmZkxQv/Fc7tP6X/PEQclJaJW1leuYolTz4fzc3QGh
	I9O54yDiJP9u6z0xuvBlBMMBl+L556ix+mYS6KtqPknJ2qUUuZGHKNtKc6OY80u0
	FY1gdO3Ye056LnWIzNN/offTU=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAH9a9hN4doAzUWCQ--.8415S4;
	Mon, 28 Jul 2025 16:40:03 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: willy@infradead.org,
	akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v1 2/2] mm/filemap: Skip non-uptodate folio if there are available folios
Date: Mon, 28 Jul 2025 16:39:52 +0800
Message-ID: <20250728083952.75518-3-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250728083952.75518-1-chizhiling@163.com>
References: <20250728083952.75518-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgAH9a9hN4doAzUWCQ--.8415S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7tFy8WrWDCry7uw4fZry3twb_yoW8Zw1kpF
	WagwnF93srXFy8Can7AwnruF4Ig39Yyay5Gry5KF95Awn8X3sa9ryIvF15t3W7AryrZr1I
	qr1Fy340vanYv3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jDtxfUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBgBSYnWiHLinmMQAAsu
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3B77D40008
X-Stat-Signature: q77fbx6gg9h73u1x5n189qgnt9c7oaxu
X-Rspam-User: 
X-HE-Tag: 1753692016-983159
X-HE-Meta: U2FsdGVkX1/Z1UdjMr45wdVuODvRv+0z7kmfbhb2N9AzCZ7L8MSWDZ7SiuhaXQYEsUQGgbGuip+cWBBJk/nEKnRpsH0NWtCJNekv5YpX6Pt2GcxtBBdx9C85echdLc74VS7T1K2lYtb+j6JyWWUFvBgDG8DPGACyfZq5RnLiKciXAmHtDS8AEX22ZapdnvndyEtTXuyqE0P2hX38Peh2pLXXY667cFUIRx73IjKfis2d3B6HtR19bThfuQ9nuYy+vSnRBTrGedRWhSjhGHbQQOf5oGQvo/kIFOX4yHM5lwxy6N0BBgQCdY4eNh+vQIaE222NAa1qHdzC0xCFPvsMrQgxqHXCgecXqGx1dsM9s3b3EZpljOL20MUw5OdQ8vbLirf29sN0WGVRxMVehhSYp0XTuZz4H6Md54pSdZ+SIgTGqPJTEXNWTt5RQZG1RP2snU2+Mn0RQRdZ2fJJbMfL65+ENe10GCNCXU2zGjmCeaBcJk0HRR2zMSlAnoHS8J/OYDptcY4rSIBdaUpmDABbhu0fwiG/TWDzzhHsiIt3oB/hX/N8as7eN3UyqCyC3wVEYyQF9P4kaLjE4Kv3OJSkJ50r3G4VNpm/F58UhFtVKgDUi8yhOFinPvLWnZXMTw/dPRgOd79fQryCxqiQWiyw/3JRrX2rjKm5gy3SdcBWBpvEiY6Vm+DXQEIbvX1lqZjp8vedw/Qgj89tqYGYTWofbh+kZsBPBQSceF8YZUEd/eRuTCD+zxgYFXT45JfOv4Wl+HxQlhi54jShGt8UfEOuP7szZ1S6qVqxrsF0nlYQ1Otj+H8eKSyriQHhQ1JEJbcIKiMTjOkDviqxCqJGemjosRHwcOvaVM5QrN/91huZzH094u186FrgIR8vbhXuN3kb23kW1+1OWniPu6PhBj06C35BSRlf2xYh5CNsxgP9ocBSmL8jjwWLvnvTHHdhV0JoqGxMO8uW6H19YzdkqCy
 eiVqbzGj
 CV38NPt0B1eKPPLebDUpM/KDp6VuTvTBczbjIKkgm7EQswYu8aqIKELyBNDz+rk+EMfrAaWJfOzdPAuR0/htUd2o41DZMq/UX8iluDvFFkAstz79pqBb7XTrh3NpkReib5eeGTNKE4+dfD0KvqEVyDV1ObWNvYxCOxAOIR05FMTXPKmsDHRHNcUjh4V52WjchrIGe4FetkS3sweyByYiHc0dFoxV/HDc6Z6ezNO4KsyGuWIzsyB8iuWUPtw8ZDFWJ1Tizm92EMO0BeytNw09A7/7kXweS2e6Lf3qokyXRpfj1dFL6FTslQTJszoNhZ6T4Kfn5SRBQt2yagn6hXIRBuMv+B1qaQB4PbhgvThSoQaRf/kfhUfX/uipdaqo3T4336+13t8jh4ovIREjh+TrtlrAwdzcekNThqFcgRmq5hNZ4FBGdG4WyI3x+vqni1UbP6uFdFpL1eCPJS9rlomSSUjeeG1aw176PLV5YFNLQ1tGVAHR6Ua+9qb0Lvo5c6tTBhvGI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

When reading data exceeding the maximum IO size, the operation is split
into multiple IO requests, but the data isn't immediately copied to
userspace after each IO completion.

For example, when reading 2560k data from a device with 1280k maximum IO
size, the following sequence occurs:

1. read 1280k
2. copy 41 pages and issue read ahead for next 1280k
3. copy 31 pages to user buffer
4. wait the next 1280k
5. copy 8 pages to user buffer
6. copy 20 folios(64k) to user buffer

The 8 pages in step 5 are copied after the second 1280k completes(step 4)
due to waiting for a non-uptodate folio in filemap_update_page.
We can copy the 8 pages before the second 1280k completes(step 4) to
reduce the latency of this read operation.

After applying the patch, these 8 pages will be copied before the next IO
completes:

1. read 1280k
2. copy 41 pages and issue read ahead for next 1280k
3. copy 31 pages to user buffer
4. copy 8 pages to user buffer
5. wait the next 1280k
6. copy 20 folios(64k) to user buffer

This patch drops a setting of IOCB_NOWAIT for AIO, which is fine because
filemap_read will set it again for AIO.

The final solution provided by Matthew Wilcox:
Link: https://lore.kernel.org/linux-fsdevel/aIDy076Sxt544qja@casper.infradead.org/

Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 mm/filemap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 00c30f7f7dc3..d2e07184b281 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2623,9 +2623,10 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
 			goto err;
 	}
 	if (!folio_test_uptodate(folio)) {
-		if ((iocb->ki_flags & IOCB_WAITQ) &&
-		    folio_batch_count(fbatch) > 1)
-			iocb->ki_flags |= IOCB_NOWAIT;
+		if (folio_batch_count(fbatch) > 1) {
+			err = -EAGAIN;
+			goto err;
+		}
 		err = filemap_update_page(iocb, mapping, count, folio,
 					  need_uptodate);
 		if (err)
-- 
2.43.0


