Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6715CC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:19:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 573866B00A5; Thu,  3 Sep 2026 07:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523F36B00A6; Thu,  3 Sep 2026 07:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43AB76B00A7; Thu,  3 Sep 2026 07:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 19F956B00A5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:19:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 83D791204BC
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:20 +0000 (UTC)
X-FDA: 85172204880.19.6E67A4A
Received: from mta1.migadu.com (out-96.mta1.migadu.com [95.215.58.96])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7EDF7100005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.96 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788434358;
	b=ptOE973BjnlWUWlt5LD8XoSpHuiScSNCLInLWcT0bk6xKyqMfT1SIMEllW8ZADhMHS2SOv
	fiH3/OsbJePIzdzKrGamCqqCzmazytcFsXIhH5Pe8mXubR6DtHaRm9GN+qZmEr1m72gplz
	kfpsCD2+x4l945zeHDxXiESUX9EkHuM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788434358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fCmMCDHCb46jYJ0zMvCmrWqttG6AB5Mog8kGIgGA/0o=;
	b=BBb5jKjy2iH4MBjqok0L3WWsG2DY5vW3/aFGGTY8P+CtKa1gd76/+L/muNhj+URhg1TjAF
	IBpF4CXLun4GyjuWSGbXSVEuCJZDOYkS+oYOG5wPn9Xs3XNSCGIgtXeh212EDNBHCxqTPh
	pWyfjK5eLK0twZB4abnGOPC2gxGj5js=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.96 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id c3b095fa7e51e4a4;
	Thu, 03 Sep 2026 11:19:17 +0000
X-Mizu-Trace-ID: c3b095fa7e51e4a4
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hch@lst.de,
	harry@kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 05/13] fbdev: fsl-diu-fb: Don't use GFP_DMA when calling dmam_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:28 +0800
Message-ID: <20260903111836.1777265-6-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7EDF7100005
X-Stat-Signature: pwsr7muskhgqqd46yhygby91aeopc4oj
X-HE-Tag: 1788434358-775822
X-HE-Meta: U2FsdGVkX19uYwjF/W/vvzBBD1cIwFcHPyiT4hRlBYp0L4NQHUp2XQpKKUSkdFDdrZ6g0vv1MdWc2QkzL7v2spaoJmrnlBOJWYbp/Fvl0+ju2rh2X4DAx5HJZV702Rp+3fNIFr6QyHNEr/p7mvHsqozoMqNB0axbGz1bymaPSEcewpzw3RfGYeG8MxxUFJeWKmAmtYPuRYLRU9ZYMS93vnk5detufJBSMXdIko9V2Y999YTQnEGwtcMJHepgJMBWPcb/bEwY8uAYnQTDXfhC/oKb6rsN9+HjquXvrCnpmAs3wFLBkSWFnX5JgX4u9QzX/6Zer464FhtGLzDmN5lzO28zeDDpgIjRUDkCX/+M51FEcnO+Wp3wCetMkUwpcg/K80JDfuvjrgbipNf+/r+tX33PwnDYoZQEuMwc73FPfm2nJHPdcZmSyI0WQhd/fxQ76FpnpL2tcAtDVJB8EZspCtiNnHFNxoP0IWNJIEvNnXQB+nEallvqQq8ohR6N9/zv/z+G2r4KsNHz1p861RK9CRpHrDu8ewB0n4WxkIxfSs9SodR35K/sM1fX+x7lSQcT3Rv782FAFtgONdYH7LsQ0klKiCLgLPQwlL/JYzRqKst4k4DB+JdNBn4mxX5PllJBzdWGAic9uYhcVSyUlD13QtI+oc0Ek5lJCjXz3tosDNxc1eV2/ub5sC0j4o62aO80vTHI4XWoIAvy6I9WVqPPNKA+gkh8bB2B+1ui4/BD2msuZi4QV8tQuBiIlFoPLXk6ywScemY9eenD8IPWtykvYOJ1jlbUyi5QN0ISx0D9yo6NQ1xgWjVbijda+8X192XhqcULUUidtxYA5q29TARY6UxuEfsF14mGYNqs1fy4JVpB9k2UxFRW1Fb4d8R28H/Hwn9bEsPt+I4kkC3xxzaz7+92u8gHKi1qNR/nh756DiokZ48kQTC5PMo/gBg8/TBzRQv/l+tQOtn/wy+NDh/
 q5wczQmL
 rDbwVurVmOvz341Org2ypWgnSB+SpfRHnZaNV2afVSq8ZgqYZfBEJlSUIUHn/jnooCGbBIm9O5UulVM/ZEGZXttKWekbcmYvyH6ICVJXV868UUgvHKPd5Ary+AGLDaagwDak0IDLyaWCDmnywbIEIQ2YmaKAH1QFaKR7CCGHBsXJURKsposOmdnsHoZX99N1U8FN3R7awKcBf3vmHPB5jEgBXFop/uOmcvXW/flyC0MwlUp4pN3/pm0suMqdvGTKYps7xcevalIQUk4F4aA0uGCHQOB9g0HRAWkWmgVsRFii8mJSjI/5FKcnf9fbjGzs8wcar
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dmam_alloc_coherent() allocates the DMA buffer with the device's
addressing limitation in mind; the DMA core picks the zone from the
device's coherent DMA mask and ignores GFP_DMA passed by the caller.
Remove the redundant GFP_DMA flag.

Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 drivers/video/fbdev/fsl-diu-fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/fsl-diu-fb.c b/drivers/video/fbdev/fsl-diu-fb.c
index b71d15794ce8..d7ed007915c1 100644
--- a/drivers/video/fbdev/fsl-diu-fb.c
+++ b/drivers/video/fbdev/fsl-diu-fb.c
@@ -1690,7 +1690,7 @@ static int fsl_diu_probe(struct platform_device *pdev)
 	int ret;
 
 	data = dmam_alloc_coherent(&pdev->dev, sizeof(struct fsl_diu_data),
-				   &dma_addr, GFP_DMA | __GFP_ZERO);
+				   &dma_addr, __GFP_ZERO);
 	if (!data)
 		return -ENOMEM;
 	data->dma_addr = dma_addr;
-- 
2.54.0


