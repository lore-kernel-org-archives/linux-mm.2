Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A7B8C44500
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9826B00B4; Wed,  1 Jul 2026 09:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80A76B00B6; Wed,  1 Jul 2026 09:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BD676B00B7; Wed,  1 Jul 2026 09:59:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 768F76B00B4
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:59:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3ED1140370
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:59:20 +0000 (UTC)
X-FDA: 84940364880.21.EA58A2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3D40E1C0009
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:59:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cu3l05zC;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782914359;
	b=4O34C9fCBL87FdQJ0oywUM3SuYR62TIQ4WqENtL4cLPD4HxsEEfLuZoz/pCR0wOblQVjmC
	jB6qY5EfwTVKshOzjJ/6/dDe7aN6K/AzcCawBgowVfLUchnvAOlDNJ1o3TTQZMc1BK1AmF
	4ciBdWohf0guv26Ww6X7w/a8svirPg8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782914359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHs6OlXAq+nMv2o/knd4pQu7oA8n+V4gayHSkVMilCw=;
	b=mURhdY3erVW4bx8RreR9dLVaDPgoH6vOCEOtkza6JRreTdg7EuIvmvEXsbUoaN9vT7GwYX
	WOrqNs9pVxWKX5IlYvtPzGCnBD+POwGx5ftA3fP7gESD7V+m5NovM0xUtDiR/l1kqVZvIr
	umdxhk1oK/iArIx8UjHGox7SHzdlwuQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cu3l05zC;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C247560122;
	Wed,  1 Jul 2026 13:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA281F00A3A;
	Wed,  1 Jul 2026 13:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782914358;
	bh=xHs6OlXAq+nMv2o/knd4pQu7oA8n+V4gayHSkVMilCw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cu3l05zCJydWaCb6XZleI8j4SchsHom65b6soJbENEKe9cMFPDoR05KBkYA6O0BqV
	 U/ym3E0Sw51sEY+n/5JJId5v4wFHFCXPa+hJS2OKnLkTMZ4jfnCLdHXRG4fMmMUkNb
	 374SuCaAnYJfVw+DfMSj6j6S5QtH2Dmp+M0MjO+hMgdHDY5iHQXdy7MImJ7i4sQA2E
	 STsMPyxBDpSX7NtcYjSV2Gi4BYa084wrEHJsD0AwRYS6rD6at3YLyEOfIdoJkcls49
	 Beb/26klLPEQ10mPDSUY4SukxC17acg3+oE8gSfBuh7c5ZhKWnGTskGeNSpzm+J/gI
	 3f/Pf6DR4MmUQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 01 Jul 2026 16:59:10 +0300
Subject: [PATCH 1/4] b43, b43legacy: debugfs: use kzalloc() to allocate
 formatting buffers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-b4-drivers-wireless-v1-1-60264cdf2efe@kernel.org>
References: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
In-Reply-To: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Brian Norris <briannorris@chromium.org>, 
 Francesco Dolcini <francesco@dolcini.it>, Jakub Kicinski <kuba@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, b43-dev@lists.infradead.org, 
 libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Stat-Signature: h5cjutnkbycbn3f1hg79xht841duxemh
X-Rspamd-Queue-Id: 3D40E1C0009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782914359-830822
X-HE-Meta: U2FsdGVkX1++9jYqqxqA9O6AppEi1/4HiyTuD2sKu1GCluczBEsxk55uydVLvdkCYu+5Wu5sJcn2QObwqo37x1frXS+xxUKkVEOySHRukiHts+AhZyYEgNLDVm6tinltzzzjRtm+6wwt906RXHT4HGBsddAJXM2vCp8f4D4SBL7l7+dMdq8BxPDLbGb+H7+HZ/hDzShPU+biXeFDcc5EyDtr/RcI4ZIjeWTWNk0pMBkNXRLVCaSBAV554mSaf6xkt0+Etc0wzTolLpAvueHxT9tro7XIoxKRbNIbcIq3cy5Nk5WYMuY+ql8QyBG6HgwUh/lqQjh1pp40I9Ia3qPHL3V3GK2GUWzFP7SOoiJSI7wppFHLSBEPMO3M5b/zu9CxTWnZrWAs6FyeAkiCfR8R44Zg+iawVe10LaNNuTmRQ3Qz5dtVgX98oMqzn37ktg3qWam567HBU1CuiJx0cLgdvpo4VZVUPy+wheqUzSUuaiuUL/s3GVThpaQcKymG/Vab/l6B8HIMimtcQM+U6HSmSdhol6DGbZ8tJGGxB1NF02UuTbwbQ9I5M1w2WGTObqDeGiMS60dxitntAEYzfpIiNgW/EzISrPrudi9bPB/YupfIelkDkOPwsm0Bp3HtMjzId5Oh9LpKxZeVEMDHAvjkEKL6eL6MW7e+aH5c5yKKBNt5JFA0ZIg5xmKaF0dZEXCLQRzZZ6cb1kv+V13AVNsx4FJo7r/w4j4Pa3NpXeYg/XgPa3Th4uf2RlzUT15zw6FlgV9xCCL4wCO3v+nVsB4R4fr2fz+GDkE3oMlIekEvLhr4Fjso2t/PLg45viQXC+zMfMXZH9TwvCcUN9ZO2O+M6fWkky+e6R8upct/g9Rzaazb8Id9QxU9LuE1MEIsO0RC9Pnmt3NfjgTXiLiRjS9T4H+eSzfm7gDTWV8MrFzEaF9EopwkRsAO8wP1CC88gS3wUsRU1uCvroDIiT1BqFo
 LvMN8+tQ
 439saZPxNIpxHRe7CeD29VHhaIv7kvcMy1mqZ4246a9PW70NzJkqpWpvakPrdSwRnSj2WFtYStQNT3oHJmgKBg2K+zU9cGHMNzdmCT1k+dvSjx63G66X0F64/zdycSs3wUcDsnryiydLSe547Te8/7fY9MfSS6bwlHAN96SH9k+PPQ4PW2+VpUBjQey0LG/sL7gkoBbyBguAfZd7WPTGCkt2KgmditlNr4OKlbZddy1FZjyQhrfV+5OEsh+J7rrR7jQq2wXxgG2HmkVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

b43* debugfs functions allocate 16 KiB buffers for formatting debug output
text using __get_free_pages().

kzalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object and for 16 Kib
allocation kzalloc() will anyway delegate it to buddy.

Replace use of __get_free_pages() with kzalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/net/wireless/broadcom/b43/debugfs.c       | 12 +++++-------
 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 12 +++++-------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/debugfs.c b/drivers/net/wireless/broadcom/b43/debugfs.c
index acddae68947a..31a1ff00c1a4 100644
--- a/drivers/net/wireless/broadcom/b43/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43/debugfs.c
@@ -495,7 +495,6 @@ static ssize_t b43_debugfs_read(struct file *file, char __user *userbuf,
 	ssize_t ret;
 	char *buf;
 	const size_t bufsize = 1024 * 16; /* 16 kiB buffer */
-	const size_t buforder = get_order(bufsize);
 	int err = 0;
 
 	if (!count)
@@ -518,15 +517,14 @@ static ssize_t b43_debugfs_read(struct file *file, char __user *userbuf,
 	dfile = fops_to_dfs_file(dev, dfops);
 
 	if (!dfile->buffer) {
-		buf = (char *)__get_free_pages(GFP_KERNEL, buforder);
+		buf = kzalloc(bufsize, GFP_KERNEL);
 		if (!buf) {
 			err = -ENOMEM;
 			goto out_unlock;
 		}
-		memset(buf, 0, bufsize);
 		ret = dfops->read(dev, buf, bufsize);
 		if (ret <= 0) {
-			free_pages((unsigned long)buf, buforder);
+			kfree(buf);
 			err = ret;
 			goto out_unlock;
 		}
@@ -538,7 +536,7 @@ static ssize_t b43_debugfs_read(struct file *file, char __user *userbuf,
 				      dfile->buffer,
 				      dfile->data_len);
 	if (*ppos >= dfile->data_len) {
-		free_pages((unsigned long)dfile->buffer, buforder);
+		kfree(dfile->buffer);
 		dfile->buffer = NULL;
 		dfile->data_len = 0;
 	}
@@ -577,7 +575,7 @@ static ssize_t b43_debugfs_write(struct file *file,
 		goto out_unlock;
 	}
 
-	buf = (char *)get_zeroed_page(GFP_KERNEL);
+	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf) {
 		err = -ENOMEM;
 		goto out_unlock;
@@ -591,7 +589,7 @@ static ssize_t b43_debugfs_write(struct file *file,
 		goto out_freepage;
 
 out_freepage:
-	free_page((unsigned long)buf);
+	kfree(buf);
 out_unlock:
 	mutex_unlock(&dev->wl->mutex);
 
diff --git a/drivers/net/wireless/broadcom/b43legacy/debugfs.c b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
index 3ad99124d522..a04d90d7307c 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -192,7 +192,6 @@ static ssize_t b43legacy_debugfs_read(struct file *file, char __user *userbuf,
 	ssize_t ret;
 	char *buf;
 	const size_t bufsize = 1024 * 16; /* 16 KiB buffer */
-	const size_t buforder = get_order(bufsize);
 	int err = 0;
 
 	if (!count)
@@ -215,12 +214,11 @@ static ssize_t b43legacy_debugfs_read(struct file *file, char __user *userbuf,
 	dfile = fops_to_dfs_file(dev, dfops);
 
 	if (!dfile->buffer) {
-		buf = (char *)__get_free_pages(GFP_KERNEL, buforder);
+		buf = kzalloc(bufsize, GFP_KERNEL);
 		if (!buf) {
 			err = -ENOMEM;
 			goto out_unlock;
 		}
-		memset(buf, 0, bufsize);
 		if (dfops->take_irqlock) {
 			spin_lock_irq(&dev->wl->irq_lock);
 			ret = dfops->read(dev, buf, bufsize);
@@ -228,7 +226,7 @@ static ssize_t b43legacy_debugfs_read(struct file *file, char __user *userbuf,
 		} else
 			ret = dfops->read(dev, buf, bufsize);
 		if (ret <= 0) {
-			free_pages((unsigned long)buf, buforder);
+			kfree(buf);
 			err = ret;
 			goto out_unlock;
 		}
@@ -240,7 +238,7 @@ static ssize_t b43legacy_debugfs_read(struct file *file, char __user *userbuf,
 				      dfile->buffer,
 				      dfile->data_len);
 	if (*ppos >= dfile->data_len) {
-		free_pages((unsigned long)dfile->buffer, buforder);
+		kfree(dfile->buffer);
 		dfile->buffer = NULL;
 		dfile->data_len = 0;
 	}
@@ -279,7 +277,7 @@ static ssize_t b43legacy_debugfs_write(struct file *file,
 		goto out_unlock;
 	}
 
-	buf = (char *)get_zeroed_page(GFP_KERNEL);
+	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf) {
 		err = -ENOMEM;
 		goto out_unlock;
@@ -298,7 +296,7 @@ static ssize_t b43legacy_debugfs_write(struct file *file,
 		goto out_freepage;
 
 out_freepage:
-	free_page((unsigned long)buf);
+	kfree(buf);
 out_unlock:
 	mutex_unlock(&dev->wl->mutex);
 

-- 
2.53.0


