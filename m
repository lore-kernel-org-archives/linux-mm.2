Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13C08CCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 15:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58C6D8E0058; Mon, 13 Oct 2025 11:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D718E004E; Mon, 13 Oct 2025 11:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 405598E0058; Mon, 13 Oct 2025 11:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CB1F8E004E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:26:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4AC846F37
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:26:49 +0000 (UTC)
X-FDA: 83993468538.03.126C250
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 38E8A40004
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:26:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hU07OA84;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760369208; a=rsa-sha256;
	cv=none;
	b=k63dP+6aW/lm13RjIVakyyvq4YQrTwa+LH2GqV9J4aHzEeAxOOlEXV15bSq8nkhS6rRcfh
	M3A4A//v6+ZNCjcMhzHoAgk7SswMvZQuckXqfdDOfwE9pmO+JHQjkmIcAZdGFhlVwNuxuV
	RHSbge/+5a1NPGcFqkoNjGBbBgwRWto=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hU07OA84;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760369208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x5sb5uq/QfHH+px3Sqs7BMMOULprNB6FIHBlJIEYBVo=;
	b=wxCKvLma8Ih2ahkrJSGP2rodaJHD3mJZldb98jSGv7Isy2DMGH7BRvWSPtitUIuwGZVeID
	osT145NEL9geeeJ9FcL0wpoEMMHl0OUtpSw0PVYpoiSNnJYYdPnppI/4sb8DoByY8pXwFU
	4PLCv9uWBCwasTUXEwSqYiSa+ZMNJPY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4811A48B41;
	Mon, 13 Oct 2025 15:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B086DC16AAE;
	Mon, 13 Oct 2025 15:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760369207;
	bh=OVKSxkqNx5xaHu4z7h221RNhnqfR95e6/sS/QJ/Ow+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hU07OA840mPC8nIqDvgUkFrQK1ylpRq/rsqQrQaGDWaU03D7b8rgS3C97iQw/udUl
	 3NSnEHDvngRAdFmBJfNS7DNAnurv0IHuFVBDZLtMSBtETwHHX8BXIUoAhPWaKPHSc0
	 xM8SfkIqhTuNdMCdYE+VTrovdZdQcGFBwT/w5wBViNdvqRNCNA7CdasIYxwsWBiM7m
	 UfQ+BnlGr0iCYXnIupzJo8tqWsZqvYSRQPl/qKkl6/9Wc5hIUYS2PypcMAqHoBzSGr
	 QIgMeIeDDVN+ZjQL8jPW4Jne8q0FQEzaiy5qqboSnOQBau+WHNsuw1rLos6pADSeBY
	 Zywx646Qcxvmw==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v5 6/9] vfio: Export vfio device get and put registration helpers
Date: Mon, 13 Oct 2025 18:26:08 +0300
Message-ID: <67fc8a91a1a047c83455721d28058a1cc86b003f.1760368250.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1760368250.git.leon@kernel.org>
References: <cover.1760368250.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a7knxyg1dy76a7jxmyaz1k8f1x48gudq
X-Rspamd-Queue-Id: 38E8A40004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760369208-429732
X-HE-Meta: U2FsdGVkX1+Rp8QpsuxdC1Sy4meWpoaV5r1VhfbLZOmT3TdyrnDDpC/EDvVZM+AR7BmKYx3W7bQUm5boKmVn/94t6OWZRa4MDpSoHbB6FqFkQpSBhFswtNqrLO9eNPI5uCToFkAoBhkn3GuVzSUy5EYTRIiSjonSV4xA7nZzswJVLwLnF8as4F6dwJSEhwA0YsVV8DoqKIT/H8v5KU6WYrIewEPKTNUMq5XTQxcTV3x9qhZTegz0G7a0icYva+8Vg1NNPWgXKp+SupWSygFKCUrfc362nJepCMniyLH140Wa5TCjBKWsYtGfcpSjVXTs0E8kZY02BsdSJsh9rilH+dlZw6AcS3k61LWVwgILOr18yaYgLhgKI2YxywWNUo480sc2t4NGTE6VGutV9DihVnepRACimsCIBO/0DXqnxbA/6bftuZ/DbnTUB6JMZLl/oeQKUKje+z8FOJ0Vg0+B6wO1Aub9lAQm1yUGD7HHghDN2vyobsYKgbbOrBTNa39oEqHN+PJOz1ec+YyBkZkHjEpoYihUb0ZluH1ED4PPbzS6Q1dBVSinR0cNZYwZe09NPTiscq3W38Z2iWtpOaMJ1pyEEw4OCd9HST0GFdOjeheULP6VpVKGLUngNqvdsJo3LIrPVgFzIwA3YDA8u1E9rV7sXBTiwEF8c/qrKhg6FmtZP4WhbrcQDPMAKTBa2jjVkzpRDeScP6MMkzfL5pfRinMJeTrM8w3q0aKsh0b+LCtAiacW2bChvV6BwlC+yPwGj1NFrO0y7lhzefWOOK8fasF6FALwCm4f4Gol+k7R3foXepN69zoCzXWDaLOYagBJWheonzeZEkfOMJf7zRLGDE6QferTRnw8t813QlaLOShBFiyiIc0L7ZiI5o5aaCRxb0TKOkvzYdx8gB1T60G2TLuP/0oo6Bb5eTRiaoqomZekxFKvpKj6QPP93nKDvV8w1MLPkEkJyxQbBnjJPQS
 KG9GrMzu
 p+TWBFOrkpM+Br4Ykgzd6JjqTyTezQR8VJ6mXZ+gMobfAJs2jdWfwxspR3vRsXX8yPmkNsq/qzsZT9HrSmxwSMMgQFG6Se2vLusyZfw4eG+I/Xi4x4m22TJgfV6OQ2hyGe+H5/g/RCc3blWgtzFHSF7L++rsSV8aaKvics0nCMIdujh4cCNSP9qVWng/b09lWmc8JohFM2LENbzEYfex4oib/LxA9RJH57ncIzGXoJfliWPaUY4pFv8PyYSvgFHqhf6ECZxWhzQzLKWrTvcneoju9bg23/fXpExh5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vivek Kasireddy <vivek.kasireddy@intel.com>

These helpers are useful for managing additional references taken
on the device from other associated VFIO modules.

Original-patch-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/vfio_main.c | 2 ++
 include/linux/vfio.h     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 38c8e9350a60..9aa4a5d081e8 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -172,11 +172,13 @@ void vfio_device_put_registration(struct vfio_device *device)
 	if (refcount_dec_and_test(&device->refcount))
 		complete(&device->comp);
 }
+EXPORT_SYMBOL_GPL(vfio_device_put_registration);
 
 bool vfio_device_try_get_registration(struct vfio_device *device)
 {
 	return refcount_inc_not_zero(&device->refcount);
 }
+EXPORT_SYMBOL_GPL(vfio_device_try_get_registration);
 
 /*
  * VFIO driver API
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index eb563f538dee..217ba4ef1752 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -297,6 +297,8 @@ static inline void vfio_put_device(struct vfio_device *device)
 int vfio_register_group_dev(struct vfio_device *device);
 int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
+bool vfio_device_try_get_registration(struct vfio_device *device);
+void vfio_device_put_registration(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
 unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set);
-- 
2.51.0


