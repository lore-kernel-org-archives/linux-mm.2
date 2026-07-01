Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D46FFC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B45576B00B6; Wed,  1 Jul 2026 09:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF57F6B00B8; Wed,  1 Jul 2026 09:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 997376B00B9; Wed,  1 Jul 2026 09:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BF276B00B6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:59:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA4E5167F79
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:59:23 +0000 (UTC)
X-FDA: 84940365006.23.3D6838D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3D6D514000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:59:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gGUOfw19;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782914362;
	b=NM2jIQtO/0c4hFjVbaB1dUruL9lK0nE+pYVL+kYKAE67vAMUV7k86BrXYMD6pEE+BEdnUW
	jZ8NlCDJAIE8XnTA13AcIhl5aoxxgSm2V10Ib8upmSD7gYjT25u++XouT5S7j7B+GLXgU/
	wGQbRrsqdMSBMyPcKXZE0skTGSJdaYI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782914362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbgNrbVcE6yo3qKfNUymapKPERWtTNs1YyhYIxOunlw=;
	b=ECpOsibBvcZKazrE6diXA1TcxsFf66UxQWjTrOoXV377hXWliVcu+mHGiTuzeIL9/CZXtf
	mqiG0JC1ycVT9UD9U+nOnBp8rhkbGATpTShYkjY+nbdfgHTnTxOuFxXAPWyoGVjMyFeRwT
	mAmUNfr6oBCeea6QIG6f613ZYiLHOB0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gGUOfw19;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A33443FA7;
	Wed,  1 Jul 2026 13:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015A41F000E9;
	Wed,  1 Jul 2026 13:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782914361;
	bh=pbgNrbVcE6yo3qKfNUymapKPERWtTNs1YyhYIxOunlw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gGUOfw19z9zcXHmTyQPeHMZ4KmRV9cu3yN/lbxMHWdu8gF9losEL3o6ZHwBi/BxU2
	 snznD72FVfVJWcH2mFTphTMO83VT3/IDpoAPnQT67O7aiEa798/AYLzL0x7THSw89s
	 ZaUIn8nD0BzLkazKGbuVDI2jklc+ZKmTZ36xGs2H+PQDL72m7O9HjRS0Yp9QyT/xWq
	 1ST0Ym2b9TUEoyBPrFolW+Lx6AW24DrkLJUSRfcb0cWJdHSCiH+86gPEsSVBoWc1y0
	 kO+P5oaZX1/bVHYXJPc3AUNvXE2oCboGIVKjmQ49EuXl7K2ZWpSQTx6rxPoMHYG8b6
	 +2M4HEGWNHgXA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 01 Jul 2026 16:59:11 +0300
Subject: [PATCH 2/4] libertas: debugfs: use kzalloc() to allocate
 formatting buffers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-b4-drivers-wireless-v1-2-60264cdf2efe@kernel.org>
References: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
In-Reply-To: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Brian Norris <briannorris@chromium.org>, 
 Francesco Dolcini <francesco@dolcini.it>, Jakub Kicinski <kuba@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, b43-dev@lists.infradead.org, 
 libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3D6D514000A
X-Stat-Signature: xn34kmqy5ait36z9bsmmbgg7gsweonp1
X-HE-Tag: 1782914362-213931
X-HE-Meta: U2FsdGVkX18swVlydxWVfxbsyd40jFGVDECKP0s+y5GFzGSTAxtS5xehNxOMEOS4av4GaACRpUtYNbh1Mflp64fK4mmz+iNg4eD6T3NrT6DSxL0WR8hg6ORQNR4MrnGKqd3VyeoV7sS3pj27t5dH3OSabJlLI7Xm9bmS+5mglblvW5cathkF8pm2E7b9qXaZZuozAl+mlpVayFm5kvJgZfdFDBdMooKdQFXNRPbDdh9AMQprwUxmZKm9SpsWFEVIW2XslnoPfRN8eq1CSkxwU4EuQtghGoPftn27jLMIrDlGnrW0SZExy0hOEXuBGlUwxY3vd7syRV69CRM7Wtuv6AFAThgxjx1PjOuw0XNQ+tEYwgaDcpBD4/puQnfNBijcjAKIctEO+rwZxMqNZ9ZwY9OdRHep6LdLOjcSvpE9b1D1mSYRbv9IvjTcU0R9aaJo3HsCIS2ppYSO3gqrhIkOexMU4YqkeXOAIWQCom2RzU+/Gho7puZxE67n/QjtFaUi81WBxZYnRiwT9lO5UyFnZNuGdvLTgI6VGaBu7+Dum0AlI53FMy99ghgvPa7ZmESVbTcIpFPHLOGTxwFlhg7IfAZklTc26YNNBCgnSwy/0eSbhfxsyaKs8hAPYtPbMwq25hdQbIZWxC1KZ2zEDY4S5l6qbS1KKfKzh9T4HzBEk7bK7aJ0OXd1ubcznr+762i9JOqlQo6DjmYlK5DNkPPsPzxZ/sWFJDZuH4Xl1TLdjJm5eOxNz0ipZ5mubr3nTRhAKvdnOH05YbkCQ6YKJQ0nljcK5oNJJ0AUqF/g+kZ7MOFtwcPZiz9PUNIubmNGEpHxyPwPg8W+dXWk4ozcS/8hWQkoHuhOENte48JvyMLH41pvE5NbaKNPzIt0c51ibSreBX7m46Y+E5Jh/obLqsZnHOFlEQqMw2XkOA/UwIIX1e2Ae1iYvk2P5ttRRSmjpdVGRhGC9QXQunAYQuJZY/+
 cggZVNMh
 ggVANkeoPrDE/1C6VhTYEFjHU+C5bmj0mtfRmYC0RxbvNzGpth62RY3xkjn7ZXum5Xp53GOpVv7xBBVMZywzrTrM5Ci8nMaWvYTDT3tcYfBinwOvVO9etm/ZL1afmLZRqBT1FGhsL/bWxufkz9Dx4uu18UWnzw/iHQNN5kWgepXXwIMdjqc1fpb5PU9/eg4igEBIs69IuXbEbiXOy9wtOrYPU5q2xUlHFXwmHyV3qxn0SAvgsIrWMYa/UDIUEoC6+AVY0SGaPr6OZpgc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

libertas debugfs functions allocate buffers for formatting debug
output text using get_zeroed_page().

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
 drivers/net/wireless/marvell/libertas/debugfs.c | 39 ++++++++++---------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/debugfs.c b/drivers/net/wireless/marvell/libertas/debugfs.c
index 9ebd69134940..9428f954837a 100644
--- a/drivers/net/wireless/marvell/libertas/debugfs.c
+++ b/drivers/net/wireless/marvell/libertas/debugfs.c
@@ -35,8 +35,7 @@ static ssize_t lbs_dev_info(struct file *file, char __user *userbuf,
 {
 	struct lbs_private *priv = file->private_data;
 	size_t pos = 0;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
+	char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	ssize_t res;
 	if (!buf)
 		return -ENOMEM;
@@ -48,7 +47,7 @@ static ssize_t lbs_dev_info(struct file *file, char __user *userbuf,
 
 	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 
-	free_page(addr);
+	kfree(buf);
 	return res;
 }
 
@@ -96,8 +95,7 @@ static ssize_t lbs_sleepparams_read(struct file *file, char __user *userbuf,
 	ssize_t ret;
 	size_t pos = 0;
 	struct sleep_params sp;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
+	char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -113,7 +111,7 @@ static ssize_t lbs_sleepparams_read(struct file *file, char __user *userbuf,
 	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 
 out_unlock:
-	free_page(addr);
+	kfree(buf);
 	return ret;
 }
 
@@ -165,8 +163,7 @@ static ssize_t lbs_host_sleep_read(struct file *file, char __user *userbuf,
 	struct lbs_private *priv = file->private_data;
 	ssize_t ret;
 	size_t pos = 0;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
+	char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -174,7 +171,7 @@ static ssize_t lbs_host_sleep_read(struct file *file, char __user *userbuf,
 
 	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 
-	free_page(addr);
+	kfree(buf);
 	return ret;
 }
 
@@ -228,7 +225,7 @@ static ssize_t lbs_threshold_read(uint16_t tlv_type, uint16_t event_mask,
 	u8 freq;
 	int events = 0;
 
-	buf = (char *)get_zeroed_page(GFP_KERNEL);
+	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -261,7 +258,7 @@ static ssize_t lbs_threshold_read(uint16_t tlv_type, uint16_t event_mask,
 	kfree(subscribed);
 
  out_page:
-	free_page((unsigned long)buf);
+	kfree(buf);
 	return ret;
 }
 
@@ -436,8 +433,7 @@ static ssize_t lbs_rdmac_read(struct file *file, char __user *userbuf,
 	struct lbs_private *priv = file->private_data;
 	ssize_t pos = 0;
 	int ret;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
+	char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	u32 val = 0;
 
 	if (!buf)
@@ -450,7 +446,7 @@ static ssize_t lbs_rdmac_read(struct file *file, char __user *userbuf,
 				priv->mac_offset, val);
 		ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 	}
-	free_page(addr);
+	kfree(buf);
 	return ret;
 }
 
@@ -506,8 +502,7 @@ static ssize_t lbs_rdbbp_read(struct file *file, char __user *userbuf,
 	struct lbs_private *priv = file->private_data;
 	ssize_t pos = 0;
 	int ret;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
+	char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	u32 val;
 
 	if (!buf)
@@ -520,7 +515,7 @@ static ssize_t lbs_rdbbp_read(struct file *file, char __user *userbuf,
 				priv->bbp_offset, val);
 		ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 	}
-	free_page(addr);
+	kfree(buf);
 
 	return ret;
 }
@@ -578,8 +573,7 @@ static ssize_t lbs_rdrf_read(struct file *file, char __user *userbuf,
 	struct lbs_private *priv = file->private_data;
 	ssize_t pos = 0;
 	int ret;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
+	char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	u32 val;
 
 	if (!buf)
@@ -592,7 +586,7 @@ static ssize_t lbs_rdrf_read(struct file *file, char __user *userbuf,
 				priv->rf_offset, val);
 		ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 	}
-	free_page(addr);
+	kfree(buf);
 
 	return ret;
 }
@@ -812,8 +806,7 @@ static ssize_t lbs_debugfs_read(struct file *file, char __user *userbuf,
 	char *p;
 	int i;
 	struct debug_data *d;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
+	char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -836,7 +829,7 @@ static ssize_t lbs_debugfs_read(struct file *file, char __user *userbuf,
 
 	res = simple_read_from_buffer(userbuf, count, ppos, p, pos);
 
-	free_page(addr);
+	kfree(buf);
 	return res;
 }
 

-- 
2.53.0


