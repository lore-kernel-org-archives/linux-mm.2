Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DB55CD1297
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02BB8E001C; Tue, 11 Nov 2025 04:58:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2EE8E0002; Tue, 11 Nov 2025 04:58:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2648E001C; Tue, 11 Nov 2025 04:58:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93DC28E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:58:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6705D1A04C4
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:27 +0000 (UTC)
X-FDA: 84097876254.23.4CC9F98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9AF7D18000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GNYvuyw8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762855105; a=rsa-sha256;
	cv=none;
	b=JbztsHvxNkeMQcPEExL+LOggHRee0bHwswgQLLVxJZmyqYNhV4d55zGUobDQ3rrUeyTb/x
	qBcpl5VBfznAjJOO6UFyqkQR23H4kHmfK1B8YYUdk4gGA16we0khiVYsgZqbXaQLxS0neT
	0EMV5xaIhP0Hhx0VszE/xGf1YXxK8io=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GNYvuyw8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762855105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fubu4krpOYsbqru92iffAKh/WWUg4KCC+XoMrjigKj0=;
	b=WJq3YlkGs6rc6dvs2021wjTwlZiK59Q8KF93fHEw5Htnaq08k85y4L08u3NzfWvk3+qHY6
	cdMZnvuIi3tX7vaE9GGmhQTEqpKI8N/MNsEn4iESL0xLAjidK8XihC+QWgkHVyfrHofTga
	/yYmOz2dY3hDehQgHA9I5yk4drl0GAo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CFB9F40846;
	Tue, 11 Nov 2025 09:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11781C116D0;
	Tue, 11 Nov 2025 09:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762855104;
	bh=bwei1HYhLRtewmmz8jQCKq/LKlcarzlK+hJ1OTkPqzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNYvuyw8aXUr27n96Cc7knwkTmvyjaR/Z2Gullt79hwt716GfJu1qKJDAVz3fIQfG
	 1M7gLpz68qXmXfiWqXNI7oGYTRkxCeDQajlQFu3oYFEmTN3VJ967K4+oQ9DET2VQzk
	 HXSbHFg4HMPwmJEwlYmSDRfwc9DWQK810bN7kUGB4Mqk9m9fjg9l1anz+T2UM66Ojp
	 XhsPu4tzXd+RinHFDu4bqrVzAfJKENbIiObKObI8piNdIYxG+FAWEPorfkuKQSZNXk
	 rO+E8lt3K/ZZc+gweqgkU+yre/ME/qTLBoGI7aPxHZTcqU/7sBK1JcnI7kHq+bcTmy
	 LhUa0j5B49rEA==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Cc: Krishnakant Jaju <kjaju@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v8 07/11] vfio: Export vfio device get and put registration helpers
Date: Tue, 11 Nov 2025 11:57:49 +0200
Message-ID: <20251111-dmabuf-vfio-v8-7-fd9aa5df478f@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9AF7D18000A
X-Stat-Signature: usoa5wnikgipaycec1i3ryg6389sp1iu
X-Rspam-User: 
X-HE-Tag: 1762855105-996642
X-HE-Meta: U2FsdGVkX1/EaTCeXlvYdDQKdhaVMZPSY5uRP8PvQM1Logi2TIlEFrj13JeyUafBU/arMWltxCcEqEYDl1ovkAYUjc2x4bbVPqE1Iyb8Iy3jn3YGKHCfQi6pzmJ2hSV+ZVJbCfufiqZ38cMsZJrJKdiaD1zJDPNHKjql89f3oEfjiURxGqPHwpmPGKZa5qSuV4E2VJpVV+oaEfkZJGZJIjuw+fit1nnhUaJzxWhWot/HEk8Pti4m5mlBfqVdWwZcJDTmM8TgMiuS4IRdevSqEtDkumPmBkFOZNOruJLhGfNuNYGusN7134ocZwXVM66LjPYqSr7OTVE4EYTCWWQfXrHieGCh001NQ8RXvKJ3EvNN+4TKPMJatfb9v4Sbo+JM3d6nqP7RWaPuq1IU42bf4MzNcl4hdCvWa30BMJPAxbmR2mROEtnekYBolZ1W7orXAVuQuwhVfV+Uu1kQNh2KPTyj5nAjlY6kL73Zb6TH4AJ02UD3s6C3Ak+9XQhklDSXxSMrYKjKyASBpfcBK+25tw9b/gydpJxWYz9e/cK2EBAp7aScODs9HeeU2QgVPD0lJEaAmgrRgYo86zRMUdiAQMFZjEMSYvz/9ZTIdfkF5Vm707Fx9xxsOjrI7SMrgqUFftUHfm+UTIhSnBMaf9q8B7g9vOiANHMWaop2Ft4m5egVUFCrQF6vZI6yjqlT6RpBjOJ1T4GeR9fBUlWu4Jf/iqdbUE38c5oBFTT234RgeRg+f9WQ36vwcG+i3zXAzEZik5mjOnH8cRHh8RNVo+6wv10S9XcbTJMqDm010PEowU1YpBnoXeGwaMIqWhKmHC9/HrIoLigk9vngbGf6R4QmyUSJzAyGpRuen4FNkQXJXfJjklYEJ1UI/auuIIpDA4Ot07rjJmuJsgmee6AkiJPfPL19Aw4G66yuaDtOaPA45aPcOQ03oEsHYve6YYswj9XAZGLUppj9L0B1K/0tbpp
 pk4H6cSR
 9UYK/672qaitAPo3G1f/oZn/B5bzbCprvLWCg5lQRARBb+SVU/3EEcyweUsc4zzk2k0SVfFICsL3PnOMJez+AD4DLlMj699nJ9AautuSZfPp3tbblYJvVK+jGOmBdBJXB6gmVh1mhtro+sHV6pH3HOABxwCjYea4Eqw8lrRVmMnrrtBkUkzj8OsbqWlRBh7uM45s7xppYpJYBh+v522+QLWA3MNBHk6tD39PXgyhvothrTI5sVFxOPSR0hDXSRfZJjMPn7jNcvKO6WRwqsJSfusRFRLH60XKOGAL7xTwqwfMdHX+AMguqEDCRwYc9snY0ke9ekBBzWfu8K2hC4ih19a6AAVqWpvuZtmxh5P9gzIax+Rqg0VkZhDEvcA==
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
Tested-by: Alex Mastro <amastro@fb.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
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
2.51.1


