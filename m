Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD3BCC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3E706B00CC; Tue, 30 Jun 2026 06:59:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15006B00CD; Tue, 30 Jun 2026 06:59:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B3E6B00CE; Tue, 30 Jun 2026 06:59:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89B316B00CC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:59:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 166908DF42
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:59:35 +0000 (UTC)
X-FDA: 84936283110.01.366C24F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7EAF81C0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:59:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NanyFOku;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782817173;
	b=dMt5EVkTwZiu8/nUzs6VWwWzyFaMiFEg0JfZVw/fzm5VShy2iVgDCz4gBHr724NOKDkx3h
	LDuJMdZ3i/+j7wtJ6HStU9GguGVfgbrBYihiCsKkx3evjx2xHEPWZgt5cB43cpu1veE5JQ
	jf83KURDoii24LEazQczhUgBuu5+8vw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782817173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udqDNDVFCOySMLOfAhXC2bToWftZ0GPwWAg1pyNOXMM=;
	b=IkqsGJjSG7YkSJUIk7MxJROk/bhSqTTg2AWisK8/eIZ3J3TlnNuaFKfFx7nbllHdzT+IHd
	lXSJMqJN7PqdhF0JAtncjffCynLSKT/LUWw/ELxQk3K/RLmOD+9fw1DKQZWtxBQNCuM4Ut
	T88bjvXz1G3pCO0Q2wqqTsX3W4QgmX0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NanyFOku;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D28D600DA;
	Tue, 30 Jun 2026 10:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385961F00A3A;
	Tue, 30 Jun 2026 10:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782817172;
	bh=udqDNDVFCOySMLOfAhXC2bToWftZ0GPwWAg1pyNOXMM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NanyFOkuNnCFD4REgVloCb2Qcv70ieoZFHA+glnEOoTfDGSW1U/DDx8oMUE+zS2Sp
	 DgmvDEy3oMXzkgJ2B9g8E75PPjHjioMBmgt09WDdrO65JYRO3Q+WAyS9Dp/wmfkjck
	 YdFb/qB8cTjmYhjXSQ/v9LQz/ASgDqkj+RmSdyAYxAkOse/s5AJkfLYDagOoOM3SMz
	 JWxJliS0qGvgbCmMqIzDh9OsIaYURy3OPl9KFwhVkB+hKup9gPdjpCqzj6cUBo48fC
	 IXOiJjMJAOuhnoI/IV/anZGDbOmTj3wcZRGg4bFg7bH4Io93W18rY3rdjqoxpZ8jHR
	 X/kBU7tjuYfOA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:59:20 +0300
Subject: [PATCH net-next 1/8] b43, b43legacy: debugfs: use kmalloc() to
 allocate formatting buffers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-drivers-net-v1-1-672162a91f37@kernel.org>
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
X-Stat-Signature: 6gaswcnr3jpsq9iqjsy8ewnon6yg6i6t
X-Rspamd-Queue-Id: 7EAF81C0003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782817173-424889
X-HE-Meta: U2FsdGVkX189/xPYQ6W3buFH+y3cIR7FEwQzf/R0XBqdr5yDZ00DVmpAzp88Z24nzpfCLYIBV7Zyg46J26ONxfz+/PlmJTcfoi11IQSljx2wSgECCcDNqoPRXi5Kpb1Nsnphpw7nF/ejm3a9HR9n7l/lG2MBSDXzgKkKngyJZRKIu2ULSfAtAz4IUOyPazEMh2fyxjD4/oKy5Oa6eX5HHpud49D2kkcGAvf/brJqDc5EptRLmYSus6FZDMKFM7yuz6sFs2yuhr0uLkRuX+5Ja3c+xta/KNUfX9lr/Hfdattuwpuhe7KguLfFPFo1KIy/ZbmE99G3bv0Weew/I/oapC66C+Ijs1U+sYTeiTmTJD9ml6ZBBeioCN2MZ9fT3u2WzunLyku3vGnRotnbSxVxnNzZGXeUzs5nN5R2k7rLU2HLcvZrDyWtk9+NB5Jzj3QBs2kMOX6DQ6tlzBiVYNM0tzToN/nlP6LQg5aPaYHLnjZHTRRS0O/uRKF+cx7yP5p+69MfoFZD0wXXeSNBpdM0odq6A+sv1uA1r4WNJnHXVWK90t05Ml+ix4g2uJsfB2OxLpxbiuOMdwc3msVhOXjRuhgY9B0iWYZK+sbs3XqXKRwFwFBE/XQoiwTzH1Hq22nEUPqdK3kJnXJ85YS8nu4hxpn/sqldz99fUpGybrpfpVkIy9C8L3Y4tqvk/o4X/EvDaJg+gyzlvrnTt8avHwSWP58lDXr5hcbqjvq/SW0gBzoi7mKnOG2tqMagpzAa6hAy7msqoOE+IEEgnlepCgiupXOSAQGuJa2UPA+IDabymKaCeBZA25eTSprc0XkGi4amGe1QeHujAVeGdwYKn1sFkMAyydy2+xJCIx0qokA7HQkkiXh34MvP85coDOhseRpFZ3cKWc1CToY+DNYS8feOD1UUBCHOd2pWJAu8biIpH8+1DkYbYG/8goW7sM7NxlpjAVMSZ86m27qwOXOjjlG
 4Ev2egD3
 Sqf00EybPQMHWw4yv/6HCtJV7ri8vxomuDSL9ziMjFXFRAmAhJwml58RAeuY/VftSb2oJGtP/cE0niCCTsuCzFncrZMlNO49Y1IoN1dctqHP00+8/NhY+HXMmIl/E/46z7esqHqWd8Dq71SJJyLt0Hxo47HRrxa3CZA/ilsgrKBDio18y6PRBbWGUefA+58wravvBBW9snGT5CPt2SUWyKA4dtvqG34ht25dKyVPPC7x4mYZ2YnBhDowXcfxhubuvSdtqA0oLVJ68nRHOLR2wh3CRtQ/2g2sUyeFAHmzNsSjrMPWBsteSTFE3CPkzpMSgLHsuuN9+pSaHOsmF/Nbp/iecmcd644a0Gvh5+oOeOHgSckUrgdNMnUZfHK6hONRHNOOL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

b43* debugfs functions allocate 16 KiB buffers for formatting debug output
text using __get_free_pages().

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object and for 16 Kib
allocation kmalloc() will anyway delegate it to buddy.

Replace use of __get_free_pages() with kmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/net/wireless/broadcom/b43/debugfs.c       | 12 +++++-------
 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 11 +++++------
 2 files changed, 10 insertions(+), 13 deletions(-)

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
index 3ad99124d522..42cce5e0402d 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -192,7 +192,6 @@ static ssize_t b43legacy_debugfs_read(struct file *file, char __user *userbuf,
 	ssize_t ret;
 	char *buf;
 	const size_t bufsize = 1024 * 16; /* 16 KiB buffer */
-	const size_t buforder = get_order(bufsize);
 	int err = 0;
 
 	if (!count)
@@ -215,7 +214,7 @@ static ssize_t b43legacy_debugfs_read(struct file *file, char __user *userbuf,
 	dfile = fops_to_dfs_file(dev, dfops);
 
 	if (!dfile->buffer) {
-		buf = (char *)__get_free_pages(GFP_KERNEL, buforder);
+		buf = kmalloc(bufsize, GFP_KERNEL);
 		if (!buf) {
 			err = -ENOMEM;
 			goto out_unlock;
@@ -228,7 +227,7 @@ static ssize_t b43legacy_debugfs_read(struct file *file, char __user *userbuf,
 		} else
 			ret = dfops->read(dev, buf, bufsize);
 		if (ret <= 0) {
-			free_pages((unsigned long)buf, buforder);
+			kfree(buf);
 			err = ret;
 			goto out_unlock;
 		}
@@ -240,7 +239,7 @@ static ssize_t b43legacy_debugfs_read(struct file *file, char __user *userbuf,
 				      dfile->buffer,
 				      dfile->data_len);
 	if (*ppos >= dfile->data_len) {
-		free_pages((unsigned long)dfile->buffer, buforder);
+		kfree(dfile->buffer);
 		dfile->buffer = NULL;
 		dfile->data_len = 0;
 	}
@@ -279,7 +278,7 @@ static ssize_t b43legacy_debugfs_write(struct file *file,
 		goto out_unlock;
 	}
 
-	buf = (char *)get_zeroed_page(GFP_KERNEL);
+	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf) {
 		err = -ENOMEM;
 		goto out_unlock;
@@ -298,7 +297,7 @@ static ssize_t b43legacy_debugfs_write(struct file *file,
 		goto out_freepage;
 
 out_freepage:
-	free_page((unsigned long)buf);
+	kfree(buf);
 out_unlock:
 	mutex_unlock(&dev->wl->mutex);
 

-- 
2.53.0


