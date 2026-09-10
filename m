Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90E51C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B0F6B00A1; Thu, 10 Sep 2026 07:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E22186B00A2; Thu, 10 Sep 2026 07:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60CB6B00A3; Thu, 10 Sep 2026 07:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1BA16B00A1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:00:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22367160477
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:23 +0000 (UTC)
X-FDA: 85197558726.16.1D43E79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6C3E74000C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B3lnb8PL;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/CjaWpeoftE+Wn2hDoCKbw50T/OskJjYcBztwhRMRzs=;
	b=kRKpcxSqQDMLJ/h2LfWzCDk5wfjmKSKfGK2g4AsqD4Z7gogHmnugeM6t/Zmv0lUXKbkleX
	DoJY3jtUv31Bg1/AMQSUUYxaEYDGqtXs2lZ9FsrUAVFH6aJ8W3vFNmFeArGYeGh3BLkyH/
	BOj8UF6MaK4glTRdomoHCIHoSUyGEkc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038021;
	b=tL3J+ymzulK1bUDfW+a3g5wZ0xEHlOFxQzylF/SJRht25Ha0tRQNLkynX4iEo1xl6TtXlq
	vrGyqckMJkTsV/q1urTuKAtJ3zjtYoLlIZ37pwci9bohTf7f+HsyDyT8f2Mwk5rYykFP7s
	4ZgTALX7S2o+Id7TmPa7lVm8Wlul3XM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B3lnb8PL;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D55A74451D;
	Thu, 10 Sep 2026 11:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020371F00893;
	Thu, 10 Sep 2026 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038019;
	bh=/CjaWpeoftE+Wn2hDoCKbw50T/OskJjYcBztwhRMRzs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B3lnb8PL7M85f75exnh7h0hPNl1h1Lq61Zrk8Os+kTvDlTeUCAJYnm5mzVpXkjslJ
	 uh3UkmdWeia6McU0ViR7mHavK4KMxc47giLOXDYZf2IBsFSdFLilDFAb0OAqV/reJ3
	 ODVtoHqN0wFeWIy8nm0QLQiWsii7m6fAS6QXeBnM1YKgLrz7bhlKNCcOiTdTcpjAWh
	 SUaALEAixjO6ayZLkzj8ipS70ZI4aVMzPXjH9ykyx6zxvMbKV2J4/1KEy1KwBucqsI
	 qfJkRDJIfxqUm7ejy51Yezli/J4O0/FteUL2Dkvz+16Z73GQajYeMIoiuL5W8tMjLq
	 NDDVfoHVrX/Fg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 10 Sep 2026 14:00:05 +0300
Subject: [PATCH v2 03/13] s390/chsc_sch: Use kzalloc() for CHSC requests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-s390-cio-ready-v2-3-e931086fdde1@kernel.org>
References: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
In-Reply-To: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, 
 Peter Oberparleiter <oberpar@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Vineeth Vijayan <vneethv@linux.ibm.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 1aaxr9p5qizhpgtiygi3ocrgm1p35we4
X-Rspamd-Queue-Id: 6C3E74000C
X-HE-Tag: 1789038021-205676
X-HE-Meta: U2FsdGVkX1+dDzQeLP4HhY2ODDvhZ0YNLJMNS6b9TdCrcZYdFOZAwGo4NaTKQ5XY8zJ1GR4c/6DugIwV3X9g0gqC7DU9nvdYq35Ar+wHlHH5ftOv/m4XuXtIpJUu//3KbzY0eztDivVw3yhRHJBKwlYhag+sQsWnX05VBIKXdP/zcxhBmxaKJCuxpWjsOO2v6IiebYo+i/KuNmTxlYMmKpXoxrITHHcfUOYwZS/BAz6b9igbf+VTgIpwAxw7J72ogAblUviRLZbohYBiGaG07PyM0GbX6cddLmG5Z9Q+FrPghkGXWCkBO/nyquVnkXC8o0wztMesSL0N+N9ryNMrF2e9o89desUJswnE2+wioOspo0vNi2B0wAtNwZSjXSbAPm0wSGGB18oKc2iKPzGXDTu6RmrmICJsORx49acC5f66yt6jzfY8LsGniCLK6rN0Rw9UfRRXw09mXjY68jzeZ1hsfwt7MVAivQdwF3kKVwb6WEUCkdHCwbfi+gys3CchKi5ydRSHt5YHWwm8re6dDjF6+etPgCb6vheqUj3lJCio4edtGYkuiHmC8HSujWGDVfTpHSlOtsHCDaVlZmA6yTKfUBwjGb8chfJLeAukcknZIWIwveg8bLSZbxRBCG0OYjt/Y/eCTWnqlz9iKqTRhMLZ8WXFEG3zC0hKH1yWtpbz9FH7BRscIg76STdem5f1wfWWhVvmnat7qhxiAEwGZnGnv3Q3StyTeALOIJdClqQg5AflHNc2qH2UjPFT0PTWx5Sf3JIntJzutvA/tUixKmP5YbWDAUlhdKomaLdr01XSPgaww4RcNGBLuI1GmyGCYNX+hZeLAwKUkuLjgrTo8girG7dLLY9bjwVAIHW2p5SEso+feFRyYO3kXYzQ/atF1pYsFxQ486RqXeGeKXQ2vXBVATdqqNibwR3sXvNGSgt1+qqCP2AXxwFn3Op1Aemiw/yBb2jmQ8Qj0RGzanp
 YdmkYdYX
 VZWbpYzH2b2j02sXLXtWIH9/Oi7YT0DFAGdwzoR21d/ZZ/NIuevt2D8JLwh/gsWEGROaEVP4qtUfhnFkzhV4p/9aNG3iHJfyORjENM6acjz8OQC8cC9ryAA5IByFBzwFPVveN8w9jmh6SsjolFAzVy6dvc1/psgeg0medl+KAHBlAY3nwNJ4ejDcL7T2t34SoEeyhPxicPb+U/9P5qZ9sxDun4UaadCejWYeQzdGyTH9R4H6KdArQ7UjeQ2NewrtZBD/DLgXO6zmB81v4ivWI5JU1Ejr4Xkg/o0ah5x/bJIv7sHNW2qyognipvPPzKX+zo0GK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CHSC ioctl handlers allocate request and response areas for
CHSC commands issued on behalf of userspace.

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

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
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/chsc_sch.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
index b6cb8bb8bcc4b..c8d6871d1841e 100644
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -292,7 +292,7 @@ static int chsc_ioctl_start(void __user *user_area)
 	if (!css_general_characteristics.dynio)
 		/* It makes no sense to try. */
 		return -EOPNOTSUPP;
-	chsc_area = (void *)get_zeroed_page(GFP_DMA | GFP_KERNEL);
+	chsc_area = kzalloc(PAGE_SIZE, GFP_DMA | GFP_KERNEL);
 	if (!chsc_area)
 		return -ENOMEM;
 	request = kzalloc_obj(*request);
@@ -321,7 +321,7 @@ static int chsc_ioctl_start(void __user *user_area)
 	snprintf(dbf, sizeof(dbf), "ret:%d", ret);
 	CHSC_LOG(0, dbf);
 	kfree(request);
-	free_page((unsigned long)chsc_area);
+	kfree(chsc_area);
 	return ret;
 }
 
@@ -340,7 +340,7 @@ static int chsc_ioctl_on_close_set(void __user *user_area)
 		ret = -ENOMEM;
 		goto out_unlock;
 	}
-	on_close_chsc_area = (void *)get_zeroed_page(GFP_DMA | GFP_KERNEL);
+	on_close_chsc_area = kzalloc(PAGE_SIZE, GFP_DMA | GFP_KERNEL);
 	if (!on_close_chsc_area) {
 		ret = -ENOMEM;
 		goto out_free_request;
@@ -353,7 +353,7 @@ static int chsc_ioctl_on_close_set(void __user *user_area)
 	goto out_unlock;
 
 out_free_chsc:
-	free_page((unsigned long)on_close_chsc_area);
+	kfree(on_close_chsc_area);
 	on_close_chsc_area = NULL;
 out_free_request:
 	kfree(on_close_request);
@@ -375,7 +375,7 @@ static int chsc_ioctl_on_close_remove(void)
 		ret = -ENOENT;
 		goto out_unlock;
 	}
-	free_page((unsigned long)on_close_chsc_area);
+	kfree(on_close_chsc_area);
 	on_close_chsc_area = NULL;
 	kfree(on_close_request);
 	on_close_request = NULL;
@@ -392,7 +392,7 @@ static int chsc_ioctl_start_sync(void __user *user_area)
 	struct chsc_sync_area *chsc_area;
 	int ret, ccode;
 
-	chsc_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	chsc_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!chsc_area)
 		return -ENOMEM;
 	if (copy_from_user(chsc_area, user_area, PAGE_SIZE)) {
@@ -414,7 +414,7 @@ static int chsc_ioctl_start_sync(void __user *user_area)
 	else
 		ret = 0;
 out_free:
-	free_page((unsigned long)chsc_area);
+	kfree(chsc_area);
 	return ret;
 }
 
@@ -438,7 +438,7 @@ static int chsc_ioctl_info_channel_path(void __user *user_cd)
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *scpcd_area;
 
-	scpcd_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	scpcd_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!scpcd_area)
 		return -ENOMEM;
 	cd = kzalloc_obj(*cd);
@@ -476,7 +476,7 @@ static int chsc_ioctl_info_channel_path(void __user *user_cd)
 		ret = 0;
 out_free:
 	kfree(cd);
-	free_page((unsigned long)scpcd_area);
+	kfree(scpcd_area);
 	return ret;
 }
 
@@ -500,7 +500,7 @@ static int chsc_ioctl_info_cu(void __user *user_cd)
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *scucd_area;
 
-	scucd_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	scucd_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!scucd_area)
 		return -ENOMEM;
 	cd = kzalloc_obj(*cd);
@@ -538,7 +538,7 @@ static int chsc_ioctl_info_cu(void __user *user_cd)
 		ret = 0;
 out_free:
 	kfree(cd);
-	free_page((unsigned long)scucd_area);
+	kfree(scucd_area);
 	return ret;
 }
 
@@ -563,7 +563,7 @@ static int chsc_ioctl_info_sch_cu(void __user *user_cud)
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *sscud_area;
 
-	sscud_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sscud_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sscud_area)
 		return -ENOMEM;
 	cud = kzalloc_obj(*cud);
@@ -602,7 +602,7 @@ static int chsc_ioctl_info_sch_cu(void __user *user_cud)
 		ret = 0;
 out_free:
 	kfree(cud);
-	free_page((unsigned long)sscud_area);
+	kfree(sscud_area);
 	return ret;
 }
 
@@ -625,7 +625,7 @@ static int chsc_ioctl_conf_info(void __user *user_ci)
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *sci_area;
 
-	sci_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sci_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sci_area)
 		return -ENOMEM;
 	ci = kzalloc_obj(*ci);
@@ -662,7 +662,7 @@ static int chsc_ioctl_conf_info(void __user *user_ci)
 		ret = 0;
 out_free:
 	kfree(ci);
-	free_page((unsigned long)sci_area);
+	kfree(sci_area);
 	return ret;
 }
 
@@ -696,7 +696,7 @@ static int chsc_ioctl_conf_comp_list(void __user *user_ccl)
 		u32 res;
 	} __attribute__ ((packed)) *cssids_parm;
 
-	sccl_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccl_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccl_area)
 		return -ENOMEM;
 	ccl = kzalloc_obj(*ccl);
@@ -745,7 +745,7 @@ static int chsc_ioctl_conf_comp_list(void __user *user_ccl)
 		ret = 0;
 out_free:
 	kfree(ccl);
-	free_page((unsigned long)sccl_area);
+	kfree(sccl_area);
 	return ret;
 }
 
@@ -756,7 +756,7 @@ static int chsc_ioctl_chpd(void __user *user_chpd)
 	int ret;
 
 	chpd = kzalloc_obj(*chpd);
-	scpd_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	scpd_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!scpd_area || !chpd) {
 		ret = -ENOMEM;
 		goto out_free;
@@ -775,7 +775,7 @@ static int chsc_ioctl_chpd(void __user *user_chpd)
 		ret = -EFAULT;
 out_free:
 	kfree(chpd);
-	free_page((unsigned long)scpd_area);
+	kfree(scpd_area);
 	return ret;
 }
 
@@ -796,7 +796,7 @@ static int chsc_ioctl_dcal(void __user *user_dcal)
 		u8 data[PAGE_SIZE - 36];
 	} __attribute__ ((packed)) *sdcal_area;
 
-	sdcal_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sdcal_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sdcal_area)
 		return -ENOMEM;
 	dcal = kzalloc_obj(*dcal);
@@ -834,7 +834,7 @@ static int chsc_ioctl_dcal(void __user *user_dcal)
 		ret = 0;
 out_free:
 	kfree(dcal);
-	free_page((unsigned long)sdcal_area);
+	kfree(sdcal_area);
 	return ret;
 }
 
@@ -904,7 +904,7 @@ static int chsc_release(struct inode *inode, struct file *filp)
 	}
 	snprintf(dbf, sizeof(dbf), "relret:%d", ret);
 	CHSC_LOG(0, dbf);
-	free_page((unsigned long)on_close_chsc_area);
+	kfree(on_close_chsc_area);
 	on_close_chsc_area = NULL;
 	kfree(on_close_request);
 	on_close_request = NULL;

-- 
2.53.0


