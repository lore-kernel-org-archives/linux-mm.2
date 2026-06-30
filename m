Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 703FAC43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575E86B00D2; Tue, 30 Jun 2026 06:59:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D346B00D4; Tue, 30 Jun 2026 06:59:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463C76B00D6; Tue, 30 Jun 2026 06:59:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 02A486B00D2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:59:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68815167FC2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:59:50 +0000 (UTC)
X-FDA: 84936283740.21.B380D27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A84384000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:59:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CQkkhZRB;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782817188;
	b=7rq7txaBXDzEqS0ha0wU6ul9CinhZor4UcZyHiR8xp9tLVoV6KmOxIldIx+EYBFLkQHHbj
	0HJhPDL19/TkkSLKHeU1xwk1/WqvOMuGw4Vvnd57XhFrLyHV0Fc4hK0+CKqbizDpxbAW7V
	mSGSPp9WYgFgzLjD434sD42NKeVet7Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782817188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbgNrbVcE6yo3qKfNUymapKPERWtTNs1YyhYIxOunlw=;
	b=VDQ10BR1wTnxkMIo2GzGAHLEv99Sn3jIZCWQiBz2xKHqw23SdZ/sF14lAadm8FTCaZikKZ
	DO+x9AGjaAC3UutZyG/Js+tZVE2fv77Xg8L022aFmNZWyZWTBTXPaoeI9W+ZPeFUHgvJQz
	LH2NqYpYi7CrTOdjczGx9DLvhfCCVlk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CQkkhZRB;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ECF9343C7C;
	Tue, 30 Jun 2026 10:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506821F00A3A;
	Tue, 30 Jun 2026 10:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782817187;
	bh=pbgNrbVcE6yo3qKfNUymapKPERWtTNs1YyhYIxOunlw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CQkkhZRBHHfobx6i8LR25033YOFT01rNrX0kyeipLKqLNF9BFgAy8s9JCwf2j/vq/
	 eS+GIvwPdBaem60TRTg8gPtQBHnvDN3UJKx+Z1n+bWbwYhFLkHQ5Q9E6reXSf0OhSX
	 7aJVtLVCY0Y8zaytM//DLEtFjwC4DZ9ubENo+sUUBFHRPy+4I3/hDOhp+osMXhQ8DE
	 Jp8OQjwqHXfE/Sf+yV97a/f2u5a2t8IYcEmoigGTJjWa0f+8BWJQqTpMmf9ZEjeBYV
	 UNKaFsEUBwWljJqmbIsS1Ki4cZFK+nk2EYxJGpveiDh6cF05HUrvteXBTqlHwXBVBJ
	 auSHAeBkZXxNQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:59:23 +0300
Subject: [PATCH net-next 4/8] libertas: debugfs: use kzalloc() to allocate
 formatting buffers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-drivers-net-v1-4-672162a91f37@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A84384000B
X-Stat-Signature: pad8s776ozpnjpwwnwg53cokqt36fksc
X-HE-Tag: 1782817188-721872
X-HE-Meta: U2FsdGVkX18GXmsw6hqTuqMnlpn+BwH5NEAVBgagKzfY5kznV6IbPVCir3tJ+1es8/I8q3Mla+1QJwAynnq+DM4A8QfGk0GVZ6rfmUDIVS0o7m86bTs2xVJU1UYaiRK9Fw+044SCZRw383+fpLfj0aSbRof9yfS4Zw1A/Sg1cn0DrDTw38GdIJ6yajjkIWZCkqIAE0yGNT7RBix3gHPUhhcETt6tBL+vcqO/IFe2X7tFCRYuwvFFX3KwkwTjy0QwsKv+zejIJY3vrIiBLk6GHHgB1H8HYZrYTAu0sj8dEKf/g0CoglelYGxmEVnZbUBTbPm/l8dL8vNVPiVWFlTQTXTKglgunR455nAl5xIrihQUjcu4+4xgkkq2MwUSmV4nCEZxn+t95datt3D3LV2KjuPMeeqJADG4sWZZ3LMcGKG8JZ4cnrBJ1N+sdJSXe4abFTt1YPRhGe9ihfKkSFkIFPsFgHcdOxMRdYNM3g9f5GP2Lfd70Bbe+L+ZNM5VzBC1CDsZ73EcZVoQk2KpeTOyTilWkUJJ1g3qelCP6bzeKpGVNut/aLO05mmT5yWbuBJ45sYziMsVJpjjjCaSyqb6l32z4mtBuOCACDD2lxlggAYLjNfZ6Lk9IEodN3xR4JQqttUascjYW3Y+APjTwDugNUGVeR37aTcxHriG/9zcK58M53rfbNTMoedC+OQY20pQYmpCdJALaFQuJK4TTTU3dnHYCAVetk6P4NxtnctDtG/lSwsqWEAg0e42aoweXemxmPeUnJ+1GqAnYo/EcIZC8L1MnuF/RiQ8uJSpCg/v97JyrW3id3eCqOu+GZ8ZbYyjH+FiZ15uS1Wz0NHJOwF7PE6h1sHrCEP+MW+itCdHLRdBHS32RyJyRtZ/DxmqGCDqC8/CMzyAIRXpSmr7nnVuG9K7pXHLK2m/2FP7KpPjHEQxUm9p+kevWnM7TvxxAdyD5vGGXNI4r9i7WAFnmS2
 2ikX0+B1
 aWs0S47kpEXnmgvTYhfaZT16w/hwiAJ+ls6Kb/pmrmogmmIPXdaHZsg+ZmqudLjfa4YO89JcfD3FYq3u+IdL/KJbB1vRqOjC2uq/BRkWqBkuBbDTl+hH7IMxEtOME0c4eUye1NzuE23u26gltvqB7Zua4PpXAeWO4sjvnmsiObRgfEnoXHZ5HaAHvdBtgdjnoaIDGMhnwjfKPlrq/dk2RuBvxfFdKUrwNKWqHYhWEkm038HxcuGXpdXyGvdiKpCFK1YFn79t62luf/+SAhwIvFT6/e8PWlc1PErQoTXvtUShc5KLkQcs69X/6heD12FfFuCMJ8eydxGF4tj+EoMWpZHx5+cObcESw07S3BpjcLSyc7vECp+V+mWYtAcdvv328NbKH
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


