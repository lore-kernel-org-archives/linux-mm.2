Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4532DC43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:59:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B7366B00D4; Tue, 30 Jun 2026 06:59:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 240146B00D7; Tue, 30 Jun 2026 06:59:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17DA66B00D8; Tue, 30 Jun 2026 06:59:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAA6E6B00D4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:59:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5FFD71C6E9D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:59:55 +0000 (UTC)
X-FDA: 84936283950.26.F296649
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A94104000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:59:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hnXL8u7D;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782817193;
	b=CijRHg96l3wzaYojINT2HP2RCOGxER2ZmIOhqwQTyaxdQY6fvZixn7ZS/5gXxpXYVhywac
	mT4NhMLyXMGUjDQBZP7S7hO6jjvwXyGIGnVVaWSpO8cw5Fxp0jsH/8g5pjZPj1JMa7AhPk
	oisDDK68Gi4uYnUjEsDKcyRhCd2/H4k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782817193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mIRRvN16ToAQb1e9zetNytMS/So59mpcGLgkkM3oXG4=;
	b=HhMawXkzfvD0/mY+d1DXsRtzB1xTZjWgUE/JnuGpPOUhXEcgQCDAxoxoCQYV8hIVUBjAob
	gFUcClaOdL5CZ5aXT9f04/99K9Z1tPvanQ25rrBpGfbdayx+/HEy8Y1+LLKqli2YrxsF9n
	NApEieMh9ed+W772pICrxO6mazmvJXo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hnXL8u7D;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 024B041711;
	Tue, 30 Jun 2026 10:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BF31F000E9;
	Tue, 30 Jun 2026 10:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782817192;
	bh=mIRRvN16ToAQb1e9zetNytMS/So59mpcGLgkkM3oXG4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hnXL8u7DMOm61ET2YFbf/5HG/UOM//MlyIUC1ghjFLWaMFK141AlmTM8FUJgs3RAn
	 RX1cWUUYGaqEsVtUipC1zlFqCjMTLg3N2LPmKOGTSgsaGmsFPT+Ms8Vlw+IEhsK8Nj
	 3MTBHNq+YJKJW9KJMD2Y+hb13ctB6uNi6q59EqSVoBp6J69Q9zlpe3ota+j8R5N6gq
	 ayMXVIE+LyBCz80hv5zKhkjroxVtZ+1iMlZhIDQEhp7t/fmsh/MArdtmfrHvN29KrU
	 LCfNiNAbWeNajuZRrNkEnu35SQ2y+pjxqnAqO8Pp9rb+Lq2NbBlVcpamK8CZv0r+EW
	 YwTjWPvrvQzJw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:59:24 +0300
Subject: [PATCH net-next 5/8] mwifiex: debugfs: use kzalloc() to allocate
 formatting buffers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-drivers-net-v1-5-672162a91f37@kernel.org>
References: <20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org>
In-Reply-To: <20260630-b4-drivers-net-v1-0-672162a91f37@kernel.org>
To: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Brian Norris <briannorris@chromium.org>, 
 Edward Cree <ecree.xilinx@gmail.com>, 
 Francesco Dolcini <francesco@dolcini.it>, 
 Manish Chopra <manishc@marvell.com>, Mike Rapoport <rppt@kernel.org>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Sudarsana Kalluru <skalluru@marvell.com>, 
 Tony Nguyen <anthony.l.nguyen@intel.com>, b43-dev@lists.infradead.org, 
 intel-wired-lan@lists.osuosl.org, libertas-dev@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-net-drivers@amd.com, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.15.2
X-Stat-Signature: 8ddwjcgo359sqonwqggb5zekiihgqqh5
X-Rspam-User: 
X-Rspamd-Queue-Id: A94104000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1782817193-612361
X-HE-Meta: U2FsdGVkX19wblJlk0nqgB65RVvgxY/SG6/auQOeI34AmYGIPQYThFdmk2M2485hZSfAHkPW3D2wuc8fpFuTNwjvaBeITHQe0PkGVPIe9m4qv6Gs9QQ50WSv+hluibMxwBeFrmKFeq8pJYj42Yfv3d5Os9k1olaqMPe+aceRjt/E9zcxYQlq+HkLgw5TCeIyG5XC5IrSAZDYrOGaZK4UQ+RoFISzVbdINzGgjNMJqeF8tB2ObkRtbHdI4wImnoDEQ95aGDSMdRA6xOhHcbkfAWkCo6VFgx0bWGPbBSvbTpVYiThMM0rMpfQbNoTVwUGq/pCBr67Q45Kk8PO5nQKUh2jwKA8UZDLtw+mVizav3LdXDOZP5INMDxAcWuk9Tlu/iIsNPx16CDSFqMgKGoLmke9he27fMeJ8UHruz7Jzg/VFX57P0zVS/5pWheoxhplaRpESjAl6pPn6zCiW7A0dCjwxIY/NKapNtTSonMEvn1599A0nWgbX/pnxU7CCUFsk3d6NL6W1sHZmnhUdFYfrylIpbXEFgyajf15l2eiPH7KAE/W9514/c+dM7k60cZI5sLEHShA9F2l0wUXmyBezttx6ss9TUOKpdsfqiGwJyZ/wPWZpbkJ8jSSC2oSvHQPlfFWAYlSnkcfEhSU9EM3k5xN3W7Xjflnj9/4s/8v7E30klwoAWwAdGncdLJEgqGlEgFVg6ZHcXk0+f/QypHsW96hiuoapkKPCh6tvRBQBKHt5gLeVKDZdASP05crk+OmhBSJn7pwd/q0wb3OHTBLsvXRqnrWQgUqL3ecNEbGWaXy5DAD7g/T+yO4a2WtktOGyL7HPevSbXcnX2KAQdWcTCuAgqI7ylN8B1/WgYkj+4R0DHSLzbu69gKm9qyLeus13jetpkipWIN5U6ZtcApezIX7Qa+UG1loMDGbngl6IPBc54jSz6fNOu9VVCS0JU4XVdCCop+lgIw2rZCXUp9E
 gTP5Alst
 CH0NjUlfBxglJ6F9ovYr5kn+OMppAXoxH+9LVfK/+2HeM9cx9ExotN07OonDmZd6ZeBmzoGwis3A22epIKlAYwNjlZubJoCM0nPiBDx6hwyTCmoumoe5/AKmLVSuNBvIiqTSomg4yCE06tPlsGaUcXFaVlvXaRte+HCRpV4/v3cF+LgouqkTcx3hklVzgQ5ssLEoDXyt4RJlaJ6nQHezF3nCnXhgvf83HuM84EzIdEBQV7wsS3PW8UssYx6tr+xrZ9V+Okj3g//x7uXGGcH2ZgkedxkL8P2b0XJ4Seg0m49/USzKLOYXa7d95enVBpiJkc7KjoKHYL/Tlsq35kl3L0SEbxdbyTZ+S8yRAsp28yi6V2J2VxB6vNlYpw3UanSdjO4+N
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


