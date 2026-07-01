Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 517ABC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5A8E6B00B8; Wed,  1 Jul 2026 09:59:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0BF76B00BA; Wed,  1 Jul 2026 09:59:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 921D16B00BB; Wed,  1 Jul 2026 09:59:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69DD76B00B8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:59:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB77F1A02AD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:59:26 +0000 (UTC)
X-FDA: 84940365132.03.25B09F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2D0D2C0012
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:59:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XIvqWB/Z";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782914365;
	b=XYp1p+obQ7gsN/ZrgeldW9NxQFN9dtTnOnQhcIdp+HZF/acqr2jwRT9E6IxzzOb7xkBoIf
	CRrskIzKgMj8pYkbl36pvkcZ1VoiCBKcWG7I6ztoXONkMle3PLLFAXQMmGafl7epka4/zC
	ok0O6Ccfdxe373Ec9f70Zs/1YdnG/3g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782914365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mIRRvN16ToAQb1e9zetNytMS/So59mpcGLgkkM3oXG4=;
	b=7j9ZND/Xl8tjouoDv9hZlDom140dko0Jwl6lhO+jnpbG8ZaQDVRs7dbg2S661ELacuyaoE
	FFmWINYbCVfruDhB4z0H0jWDuz/tC4crOjXQM78taQMXlr2esm0igmQJRHBDJ2bhXDuBoM
	VRGPz8QbzxWtTJib6k1Ss7ereH2D/bA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XIvqWB/Z";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BE1943FF1;
	Wed,  1 Jul 2026 13:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5FD1F00A3A;
	Wed,  1 Jul 2026 13:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782914364;
	bh=mIRRvN16ToAQb1e9zetNytMS/So59mpcGLgkkM3oXG4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XIvqWB/Z5o8XyUWj0ZMRT8ai+tzHw2Cc40Oh8oPuE/LrY1NEYh/1YccDLCnO6z6Vm
	 wXk0d9P1z7+DC9WIuTT9MDE7agFYfq/n/vD6CUhiWXqRmROE6Gc4ocmEuRiOJm8nl4
	 YncAnhi4TUk4pyu2knTS9X1/lCFj6uiZRAswQQZNtpOnI+NWtbvrePJYQKeS+BIdZF
	 qUlchitPXgA0Ni8J92BfLDSzqne1n+AXITa7sSONDahuIHSvOneIfGMgSCQboz/UN+
	 AvEvgAwYgHKL0iu0N8GMpv8wQfMyrfK78O28+WiEQax7I/uG/xquKYWddL+Tau4/i6
	 r1ipmqnhvyc3Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 01 Jul 2026 16:59:12 +0300
Subject: [PATCH 3/4] mwifiex: debugfs: use kzalloc() to allocate formatting
 buffers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-b4-drivers-wireless-v1-3-60264cdf2efe@kernel.org>
References: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
In-Reply-To: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Brian Norris <briannorris@chromium.org>, 
 Francesco Dolcini <francesco@dolcini.it>, Jakub Kicinski <kuba@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, b43-dev@lists.infradead.org, 
 libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Stat-Signature: ud3enq66dy3ioho9ou93qc1wcqt4gx4e
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2D0D2C0012
X-HE-Tag: 1782914365-226196
X-HE-Meta: U2FsdGVkX18PVSNexlasS/gBuZni0gWSYtHuqMPmuCJQAinM1dpeoE2IwCKRDVW+1a1txQ1V1BZzeptRfKuDxU3zW39wzpSyS8V7Bnu9ZpmnVVK2+BwSvn851RZB1wvHCirA3j5o1OEzukXvtAH6OcptNLRC0fVWVxCw2a3FQCSZ9ZwQPkUMnOXqp5PcpCNzVJmoo6CGGeIURIrD1Bg2iy03B/BQicp0jfUJ1LZ1YWPYIjt1WZ5k4LEwlBVA0mIbPFUpbfobgwQ0tNXepgGbDx3IBGNkAyEG2d6RLCBsAyU9bHH5zWWlMMl1gul0N5EFyCe2pliRgoxeZoNogp6zb+J8p8CGGPC7G7e3clIjGg2ippdcOf7EgQY83fCz0h9FaCWa7AxNF1Rda+g5X3CN6UuG+z6mL3sg1HWtZb2xvw0XBG5k1nr/Edh1bCKwnh7rYFMHQ7UBzOSq/ETmTYUJWRdQX28JRCqNz3x183NYwgwDb4jVKjzwl5CxlezA5SK/Hf81fXcj9lwcfA6HfRDqFwum2+o+A93I4VS6oBNBumDgit5FfVOJRHIqKGtLK1cwLfExemmyo3ICiKQ+Oel+uIJAtqMZ8d7nKZagflyJcGNOHRtX+1gIRu4dd/4oA3wG+yR4cz/0LjRuyDlTejx1RoW6Bp9AIscUB7dKJRKnLuRGsDmwDaP3N7vWtJ27ibL0qQsuR786wfaFqSfctCsk4CnZvkN6fWktS18rpZ/8e/7VGdbKcbGPI23Vb5mMdvVpDL+O7dU/BtuYPj8y3rjpgtBXjpeN3QZBcHcZIjlcAasHTOGzOfnFSfqHgrZ0DXp6PEjcUDvKfbRJWNAmOjIgg3Z24UL7S5AgvhhWMK/872vfSrHndqIEhOl4iinYHHFKNCFfI+SGoir2JNkREAyp717YyLwyZDw5wVpXwV+UylHbh+ir4LAr05fR5mFNxGVnHCsQNPYqRuUaAW9v1Jp
 lpMT5COr
 UGsP3Ktv7Cm7m72uIrJ4l3ykKww7UCeU+7DSIUGiL5w0BsVdNG4mXX0pSrkYifk//t269VRSkN3W7ZxnWiLquCoYJ/O3vJ7c0Cs/UNm+ndU8gwCI6f5f2OH+Zms0Uu7C0KJonq39Y7MT5FuEmvYOjd2UZVhm6I0ZEcniZ1/cjIy5uqcU8/3VJueRrGyqgwGdUYuEnYrU1S4IL/JYD3jRL6qOkUd6sFkieEKrP9K66RnGddnIOVqLoFIGFSkgY2kcOrmsEQHYy7uhlmG8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mwifiex debugfs functions allocate buffers for formatting debug output
text using get_zeroed_page().

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/debugfs.c | 62 +++++++++++---------------
 1 file changed, 27 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
index 9deaf59dcb62..573768b6ad91 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/debugfs.h>
+#include <linux/slab.h>
 
 #include "main.h"
 #include "11n.h"
@@ -67,8 +68,8 @@ mwifiex_info_read(struct file *file, char __user *ubuf,
 	struct net_device *netdev = priv->netdev;
 	struct netdev_hw_addr *ha;
 	struct netdev_queue *txq;
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
-	char *p = (char *) page, fmt[64];
+	char *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	char *p = page, fmt[64];
 	struct mwifiex_bss_info info;
 	ssize_t ret;
 	int i = 0;
@@ -133,11 +134,10 @@ mwifiex_info_read(struct file *file, char __user *ubuf,
 	}
 	p += sprintf(p, "\n");
 
-	ret = simple_read_from_buffer(ubuf, count, ppos, (char *) page,
-				      (unsigned long) p - page);
+	ret = simple_read_from_buffer(ubuf, count, ppos, page, p - page);
 
 free_and_exit:
-	free_page(page);
+	kfree(page);
 	return ret;
 }
 
@@ -168,8 +168,8 @@ mwifiex_getlog_read(struct file *file, char __user *ubuf,
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) file->private_data;
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
-	char *p = (char *) page;
+	char *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	char *p = page;
 	ssize_t ret;
 	struct mwifiex_ds_get_stats stats;
 
@@ -220,11 +220,10 @@ mwifiex_getlog_read(struct file *file, char __user *ubuf,
 		     stats.bcn_miss_cnt);
 
 
-	ret = simple_read_from_buffer(ubuf, count, ppos, (char *) page,
-				      (unsigned long) p - page);
+	ret = simple_read_from_buffer(ubuf, count, ppos, page, p - page);
 
 free_and_exit:
-	free_page(page);
+	kfree(page);
 	return ret;
 }
 
@@ -247,8 +246,8 @@ mwifiex_histogram_read(struct file *file, char __user *ubuf,
 	ssize_t ret;
 	struct mwifiex_histogram_data *phist_data;
 	int i, value;
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
-	char *p = (char *)page;
+	char *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	char *p = page;
 
 	if (!p)
 		return -ENOMEM;
@@ -309,11 +308,10 @@ mwifiex_histogram_read(struct file *file, char __user *ubuf,
 				i, value);
 	}
 
-	ret = simple_read_from_buffer(ubuf, count, ppos, (char *)page,
-				      (unsigned long)p - page);
+	ret = simple_read_from_buffer(ubuf, count, ppos, page, p - page);
 
 free_and_exit:
-	free_page(page);
+	kfree(page);
 	return ret;
 }
 
@@ -383,8 +381,8 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) file->private_data;
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
-	char *p = (char *) page;
+	char *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	char *p = page;
 	ssize_t ret;
 
 	if (!p)
@@ -396,11 +394,10 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 
 	p += mwifiex_debug_info_to_buffer(priv, p, &info);
 
-	ret = simple_read_from_buffer(ubuf, count, ppos, (char *) page,
-				      (unsigned long) p - page);
+	ret = simple_read_from_buffer(ubuf, count, ppos, page, p - page);
 
 free_and_exit:
-	free_page(page);
+	kfree(page);
 	return ret;
 }
 
@@ -457,8 +454,7 @@ mwifiex_regrdwr_read(struct file *file, char __user *ubuf,
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
+	char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	int pos = 0, ret = 0;
 	u32 reg_value;
 
@@ -497,7 +493,7 @@ mwifiex_regrdwr_read(struct file *file, char __user *ubuf,
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
 
 done:
-	free_page(addr);
+	kfree(buf);
 	return ret;
 }
 
@@ -511,8 +507,7 @@ mwifiex_debug_mask_read(struct file *file, char __user *ubuf,
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *)file->private_data;
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)page;
+	char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	size_t ret = 0;
 	int pos = 0;
 
@@ -523,7 +518,7 @@ mwifiex_debug_mask_read(struct file *file, char __user *ubuf,
 			priv->adapter->debug_mask);
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
 
-	free_page(page);
+	kfree(buf);
 	return ret;
 }
 
@@ -652,8 +647,7 @@ mwifiex_memrw_read(struct file *file, char __user *ubuf,
 		   size_t count, loff_t *ppos)
 {
 	struct mwifiex_private *priv = (void *)file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
+	char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	int ret, pos = 0;
 
 	if (!buf)
@@ -663,7 +657,7 @@ mwifiex_memrw_read(struct file *file, char __user *ubuf,
 			priv->mem_rw.value);
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
 
-	free_page(addr);
+	kfree(buf);
 	return ret;
 }
 
@@ -719,8 +713,7 @@ mwifiex_rdeeprom_read(struct file *file, char __user *ubuf,
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
+	char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	int pos, ret, i;
 	u8 value[MAX_EEPROM_DATA];
 
@@ -749,7 +742,7 @@ mwifiex_rdeeprom_read(struct file *file, char __user *ubuf,
 done:
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
 out_free:
-	free_page(addr);
+	kfree(buf);
 	return ret;
 }
 
@@ -820,8 +813,7 @@ mwifiex_hscfg_read(struct file *file, char __user *ubuf,
 		   size_t count, loff_t *ppos)
 {
 	struct mwifiex_private *priv = (void *)file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
+	char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	int pos, ret;
 	struct mwifiex_ds_hs_cfg hscfg;
 
@@ -836,7 +828,7 @@ mwifiex_hscfg_read(struct file *file, char __user *ubuf,
 
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
 
-	free_page(addr);
+	kfree(buf);
 	return ret;
 }
 

-- 
2.53.0


