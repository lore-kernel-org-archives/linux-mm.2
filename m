Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8351CC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27CF86B00A3; Wed, 23 Jul 2025 09:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205BA6B00AE; Wed, 23 Jul 2025 09:02:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11C936B00AF; Wed, 23 Jul 2025 09:02:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 026AE6B00A3
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:02:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BAF0C5A8DC
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:36 +0000 (UTC)
X-FDA: 83695543512.14.72156C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id F0F13A0003
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M9geGo42;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753275755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+YOFkTGPNtdD0/4eUaqkvnlRctU2yUfDTbIxOnznXAs=;
	b=a44uD1koowke/i9cuTHKXbC7tsHbkQqOTg59G0Q6ZwOX0wsCLAXMWqqda1OiWfXhXV3UtL
	bsxLQrMpHerXitiDhTdOz3XaeFxUW5DXSwiEljJwgIBNVX4n++Vuhl8knooSsS/1XF2gcV
	VkjvKczmz4+FDWwt9dI0Eu/mluyY3MI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753275755; a=rsa-sha256;
	cv=none;
	b=3YtjPKHKHaJa8g6m30WX+sHOGybEruPxUBJEQsu7yb+JnAvmGs877Bbxd7+AiUdJ6h/nwW
	PRo9JFDukI26uxLbSRbrNktwgLm1BX3BWSFnWvFEw2/4cAMvUvTUV9KN4VmZfkUE/FkoFO
	B7PR7hFAEAoa4DwETuomyFa+S8PueLs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M9geGo42;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D259640BF4;
	Wed, 23 Jul 2025 13:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BF9C4CEE7;
	Wed, 23 Jul 2025 13:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753275753;
	bh=BDaDnmGJ1hOXfba5peMH/vLVvGA3352Dpn0pSCnGLcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9geGo424bXd6/uG8WL7qxlYMBC2Osxy/EUu6rWhoOMyPRB3P0sBI+IWLSoGSSu2y
	 DHoKgy21QJrxKbiT4TLE5rauohLbNtI1oJbcsqXmrSrrnDtW6q1CSvfjicb0vzsW4q
	 01nSwQFjX2ienHTrFSxXCw7XuSMUG8nXZd0FQpX9HNWnVxfDKhKwp5NjZ35b67Cdo4
	 tw9drIN8LE4pYl2eWMyH9QrLB8XG0ZtoYXJmDdICtgYVa1PwtdaJOcXtmOzkkhP3R4
	 crLQcIZlQjY6BsNh8WPH33PT3gcOF0zU5GS6aQ3pi4Cv+w+fHT6w7TaJQf5iTmpPto
	 6yR8Blx/5U8hA==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
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
Subject: [PATCH 07/10] vfio: Export vfio device get and put registration helpers
Date: Wed, 23 Jul 2025 16:00:08 +0300
Message-ID: <045df5fc463bbac4c669413fabd4d22e54b58c87.1753274085.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753274085.git.leonro@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F0F13A0003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: wgf9xxpkc98etj99jm6wt818kab7a9uk
X-HE-Tag: 1753275754-928157
X-HE-Meta: U2FsdGVkX19rZSzrGOBqT/za8txOX9ctka/WZLEzMIXYlZPU27QIEkKSf+zqlNxiiAfCay6vbP+jg21khcpstkTrtINxmR0OUrm2RgFSckNBJm02g41xyH3pquQt6yu8TC7OaPkMhtcvk1y0p+u6mvwETP1jr0Y3FpuK9s/f8OuVImWFcZJUe4JYum5ZDmK/BL5Yxw11RQd98StkcMgzDqHHvqM5A4SL7rgezMpTyacckL3VyPquueEu6SJLN3g3zhGDo0m04ldSxVOtRvMGPFy8Cqdc79zTJeeusIc76+dF6BfBXz0YB+/1HjlGqnE7bJ/nA+kD1gLXczJPORK4/6cXovrba4D1At/HrEJFiLyJcMgP0XM4XAy5rQPwlnR2QBjlFZhaaiq0Ufv7+4qwniWkABgaq9tAJri4gL4V+pc6yJMosZxYhVEOdA0LjwtNPBhynTlX5G5N6CcjQoq/l/Vv4mZBQ+v+53AlRtzkxOiZMqlTTWYUYlQc0NopJO64dhvwsXdfKvdWaBQ64xmULkN370nunAZhBKAweq4F5nCdAs9kot+gYdVm/tGz6jj0NCak+wG7mTmhNJIDTepGX0Gy3HVcg09Opy3mQnwwuVkXhMyCzWsvS4jIGW9eyE7GdGJNmrLsK4+sSoEWAbbRhbBmJR3ZbCLLo4+0gFcDylrrlMINenJ+KdEtyDm+TYfUX3QP7tXXM1RJ4YOxvKOesj4Zs1IdApGIE35Gw2aNQvkT3qI8L3BuQoFcBvR1PULJ02R+SRvq6o+gEm0bakjuQnu6ODEDMQWbcQgoCeiAKJi5gH5bBrNpA4N43dp/NMoracPfRaWhDe3J/y/ejV2PC1+jwgvzkbRsVnHr37ImzhLXxkY8hA7CC2y1N+1OWpPU2tCyiO9TKwghxnS5PmyuJYAuvFQnjT9HAaHzOwCRjKAGvh+BdHYpKihF7CVdlS8RC/kUa3I4aujpmm8is11
 vVhU9+UJ
 54jfFxX+iEHAcEOHT+rT8uH/0Rpo3QsGKUY5KItg2OuGAJQAlHkTlJYN07i8c2t43EogDI5mGfZefXG649vM+OgtlcAV3UVOsyvfm4I4LeCe4vmE+0D5l+SiIF4VhrcLDT3tX94Sdbr2CJyKRwH6aoTdAEBotBbMJIqnk/fAmHZqYYzq25pJ+fo661suKk7CtzfRLMDDTypfdhpxlVTpu2HC1GtsbpX8KxWTziIqhJURdjhoiKZ4n6OAayJNmL2/6/g00
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

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/vfio_main.c | 2 ++
 include/linux/vfio.h     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 1fd261efc582d..620a3ee5d04db 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -171,11 +171,13 @@ void vfio_device_put_registration(struct vfio_device *device)
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
index 707b00772ce1f..ba65bbdffd0b2 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -293,6 +293,8 @@ static inline void vfio_put_device(struct vfio_device *device)
 int vfio_register_group_dev(struct vfio_device *device);
 int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
+bool vfio_device_try_get_registration(struct vfio_device *device);
+void vfio_device_put_registration(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
 unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set);
-- 
2.50.1


