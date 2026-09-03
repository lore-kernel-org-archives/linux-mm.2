Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A125EC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55AD6B00A2; Thu,  3 Sep 2026 07:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2CFB6B00A3; Thu,  3 Sep 2026 07:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969636B00A4; Thu,  3 Sep 2026 07:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4646B00A2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:19:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E83BB1204C0
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:00 +0000 (UTC)
X-FDA: 85172204040.11.8DFC5B1
Received: from mta0.migadu.com (out-49.mta0.migadu.com [91.218.175.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id AAD0D80003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:18:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.49 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788434339;
	b=NmYh3tIclfhgse29UvTw+6wFf1ri+Wg7Dx9GvrsTuYet6/9nJuL/qN70qW+9MUArRZjfKE
	kkkB7nARWzuMktnL+gFJsYGZ6pXYEwVNJ0hcd58VvWRrgGRzq8I6SiIvkabMb0hfFvOVAk
	UDPfelh2Dm/kbVMYu5KjLXbviuONwTU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.49 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788434339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X2dZb0VDJxzaemJf41us8jOk7eLtW0E8VPabhFClWY8=;
	b=nbHQkedqYupdPmVMh64xyyoSjVwBNfwKf2gK0HV6YUL7HFz9AgYDQgbmgjc+0sG6CRDUE5
	p+fiR+GCxsqMYc6t2V69WcxA8u8A+T3INkvvoAxgOqNfh+Oh5dzIX7jzMC7k1eNyLVElI2
	FP1u6TCQ//kgp7Sg5WGBz+1vU6yY0eA=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 42ffe0522571fddf;
	Thu, 03 Sep 2026 11:18:57 +0000
X-Mizu-Trace-ID: 42ffe0522571fddf
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hch@lst.de,
	harry@kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 02/13] drm/sti: Don't use GFP_DMA when calling dma_alloc_wc()
Date: Thu,  3 Sep 2026 19:18:25 +0800
Message-ID: <20260903111836.1777265-3-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AAD0D80003
X-Stat-Signature: b5k3tbb97cx8b8bnhwts16f3x1kfqtkh
X-HE-Tag: 1788434338-154122
X-HE-Meta: U2FsdGVkX1/d9c5CFxLQ6Zw+SNChbSSfET/pkRT5KR61mXsbY2c31wlV8+nuZobda5STX68cpbzy6hQNWF9djykeDXZm+vxXCot9svv/MRvI930YkbjOGq+laiX8wvkaUOKKgZk8kBV6webqjTraCVSlgptZCqygIsyjcuQn3XOJAeWEL9rctoMGZ+CfLBiv26tD5IC1vP5ZhmN3+xb+wyGvyJ4Wx6An3kvBXvH8I+sXsxyTrabM6Y10lwFy7e6v+gcuS+r6co45WNNIfC7ozcKjOjSieOQ6TQmh/EIE6hQxCF74B3dbQeLd37JyfMGl6dnk4QhUXZN4cY/tD43/kNgO6sR1CU+Xpz7VW1aqQG5CAbjlem6sNzUhV8oq8t8I3DvRo4Z+uZkr6V17GWNm+L08GqONs3fnSnWWVdQA+MzG9wfTVlBE04Zy3iVQF+WVsKqjIgMz5ch03qnqvlPXC3kcio2ksgQqPDBCNK+a2DVBKyj0IFoNbwYI0Xd4HWG9QwWztKft4MiBu0hyvtde7kMBnOtkxwXJWkaP1O7Js16JuQR78zLa5g5rnUkgeR1G/8zUKlei9itQxtKJ7JeAZmAKqhrIwwt6V0ntWMJXo/G5sHt/Yh+VjUXxZodV0SLfmt/4av/13Wbdyyc0fjb61TQmdSjKOzy5EsgY9JFVqAjGNhUu68Fg2TI/cI8gS82PokN9fAnzQ0VYfkNkZvkokxdWSUNzmVTrVakjsAUmnTOIeCLNeQCM+cUkopLeyiK27ZEFSzlecq//OqZv01fPnPobpaRERLpQOnmYFPtK/q+0QjoG/1+LtBRRiSPNqldIXzNwbGuG+mBI4M1IZCsAaBbcRQJpllTE3t1TCmtURWDCWYpDCI3+gEEDKf5Nab61yhTJyJV8BY2Ef73LKLDc+DacQPt/k5BfAxrvAvefg3xn42yAC38EXvW+Mfv90UmYy51IdgOxAvs0kHGky2Y
 VYWkqJrp
 bq6gaS2WquuZHTXmIlBrPeRcA8eNC/n6x9k3yc3SEjKm0U8nU392s/8aikr7V2YDLEhk0+CA1REoMMmk3wGFfPeP05K8C8yB2FUQDjpcG24tdsg5lKpRk+FiFT0dj1yZ5o0ngXHhlykS4W38LmSl4sPb2zenx4q5WivjiXivHwzHp9vz2Ar8BWE5xzf/HdLmWjE8J8WxJjXzUuoRR1HyAH+A+sQ3C8ieq86wsCzu83US2404VpyMjk2hJc5LAZlhQ9RxgRxCi/FcqXYULIORQ2AfZ6DlXo5829pSJBfDlLrE07oKfA8KKvKg/Ab+hT5JwB+Ins3NLmg1tv0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dma_alloc_wc() allocates the DMA buffer with the device's
addressing limitation in mind; the DMA core picks the zone from the
device's coherent DMA mask and ignores GFP_DMA passed by the caller.
Remove the redundant GFP_DMA flag.

Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 drivers/gpu/drm/sti/sti_cursor.c | 4 ++--
 drivers/gpu/drm/sti/sti_hqvdp.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/sti/sti_cursor.c b/drivers/gpu/drm/sti/sti_cursor.c
index d0b89b28e50c..a0ec671477fd 100644
--- a/drivers/gpu/drm/sti/sti_cursor.c
+++ b/drivers/gpu/drm/sti/sti_cursor.c
@@ -240,7 +240,7 @@ static int sti_cursor_atomic_check(struct drm_plane *drm_plane,
 		cursor->pixmap.base = dma_alloc_wc(cursor->dev,
 						   cursor->pixmap.size,
 						   &cursor->pixmap.paddr,
-						   GFP_KERNEL | GFP_DMA);
+						   GFP_KERNEL);
 		if (!cursor->pixmap.base) {
 			DRM_ERROR("Failed to allocate memory for pixmap\n");
 			return -EINVAL;
@@ -380,7 +380,7 @@ struct drm_plane *sti_cursor_create(struct drm_device *drm_dev,
 	/* Allocate clut buffer */
 	size = 0x100 * sizeof(unsigned short);
 	cursor->clut = dma_alloc_wc(dev, size, &cursor->clut_paddr,
-				    GFP_KERNEL | GFP_DMA);
+				    GFP_KERNEL);
 
 	if (!cursor->clut) {
 		DRM_ERROR("Failed to allocate memory for cursor clut\n");
diff --git a/drivers/gpu/drm/sti/sti_hqvdp.c b/drivers/gpu/drm/sti/sti_hqvdp.c
index cf1ed8a33b8e..b0d66834bcbe 100644
--- a/drivers/gpu/drm/sti/sti_hqvdp.c
+++ b/drivers/gpu/drm/sti/sti_hqvdp.c
@@ -860,7 +860,7 @@ static void sti_hqvdp_init(struct sti_hqvdp *hqvdp)
 	size = NB_VDP_CMD * sizeof(struct sti_hqvdp_cmd);
 	hqvdp->hqvdp_cmd = dma_alloc_wc(hqvdp->dev, size,
 					&dma_addr,
-					GFP_KERNEL | GFP_DMA);
+					GFP_KERNEL);
 	if (!hqvdp->hqvdp_cmd) {
 		DRM_ERROR("Failed to allocate memory for VDP cmd\n");
 		return;
-- 
2.54.0


