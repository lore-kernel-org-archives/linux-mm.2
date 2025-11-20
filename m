Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEC53CF8575
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:29:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CAC66B00A6; Thu, 20 Nov 2025 04:29:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47B2C6B00A7; Thu, 20 Nov 2025 04:29:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B116B00A8; Thu, 20 Nov 2025 04:29:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27EA46B00A6
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:29:14 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E5E2812FEC3
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:29:13 +0000 (UTC)
X-FDA: 84130461786.15.2472214
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1C55614000D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:29:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EVDh/xTe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763630952; a=rsa-sha256;
	cv=none;
	b=wzOhSKzy+6APLB1TMib6OssGI1SE8/tqPLChpQEpgZmQY2BiAQazXjLxNwHhSGTqP8hoUv
	wDycUP9Zht0MaqXO2BfLlHH8LeAmyjMjazxJ+8a6XvVfu+xaO8Uslb+PUJ0qgIdRv1Wcum
	R9j6mqtUtJ8vIgCSyaVw0SZ2omWoENU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EVDh/xTe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7fshye6Nw1pUkt9AwYFdF07bgLxmtRtR2/ICAEfwG0g=;
	b=KFbIm7RzKo/r0WlOUiiBHvvUf11A1gmd5h+CH/upY9G1FGVJculNefyDkWubV6IgUembrI
	+FzfAv0YyYNXr2quZWAtgb1oX5m4WEXHCcBS5bFHu2YTiIaww+4o61/TH6ArqIjkPXkccn
	GcRBPk+do2diLJDE8Gt/a6RxwiJPsRQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FE7E443BD;
	Thu, 20 Nov 2025 09:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525D9C116C6;
	Thu, 20 Nov 2025 09:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630951;
	bh=DIZhqF4CFI67uI4Krwkj+IisI8FxBbklZLuwDVlXq2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVDh/xTepGGorzhsd7BiESimD+RjtPzbYQnhg/0bhJdXv75WCA1G6YBbgHx1tRYwV
	 CVBeRrTZYl2pm8FwlxXDLk/tyN4NSFPOCG6XkwBfRacBC5w7e6GG0JY1HF15Bj8AK2
	 d/h1P0CLTBbLdyFn1wSMs8EJ8d5VqPLpEYI60vswpdDWsaoGMQ0q1/aywPfbqrzlqZ
	 zI5y/F5vejzsKtyIlW6uEIFL1kIxE5QbQv2ajCTdKxL/21ItP4JbFf5VhkNzQIZpTa
	 T+5jXnSWB0+W2gugnrWtnH3Ibt7kT3/kYLaAYBBM03VbZvhC7jN+OIRiCVQDadB0xj
	 NPslBrnY4B4IQ==
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
Subject: [PATCH v9 07/11] vfio: Export vfio device get and put registration helpers
Date: Thu, 20 Nov 2025 11:28:26 +0200
Message-ID: <20251120-dmabuf-vfio-v9-7-d7f71607f371@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1C55614000D
X-Stat-Signature: mwmo6ciisya98h5b17guxhs4hc9d4in9
X-Rspam-User: 
X-HE-Tag: 1763630951-50093
X-HE-Meta: U2FsdGVkX1/menTyZsA+IRobTT1gEATlRi5ZtWn4KWaLpocq7n52SzecDElzRHKxftPYgycWeoewEcURemmqh5vl52a0scFb47uSGtWaF5z8zcAFBB3H1fNFbfREQ4CutAU26c6kH5TKr7sqfJ7p4WQ8gTJbRH9VWV1M1k5hSGXe3bvTSyKwplS6kNlQ9eJYjvV7GFeFv8nVsvlLgt0JjhCOyWYtRCWEDbyTyMt5Sf6btX7eB2NoYKA126Sola7DdYfcQs/xkQyTzKhtf+AbkQ40/u2KDBun0EUnpdQOXgoTIiOm+DwTNft1vEvfgYfEiD4p7hITxcEH9lau6EZftApzW6UjXA2lTtncbfoH4Efhnxzlf611Rjl/r2bUn6AeCP1a6uxLiNUt0QK5fH8P8cwHTzVgAFMKPZO425InwO7ITxGHw4+nDnCVZ+vU2i6nYuMdEdwrAiHW/7xnkPg5QArVCmXG6XPk0grUDrpVIxMf7YW97U556FCVo3nrEPyzjBBo0X3w1n37wxaCOlA4Q5E2fl4io7hm1jqk8iDS0qAtZX/iaD8qkJpwiBVISKFPbHZF2AYkn0aNSqYdQQCysIgogrTO6bMJyIMg+RC1kJSevUQ6yCQhx+pM208JxoAq6/CZllMxXCg9ZTZcVjzZSWSvsJXTmvcwq09w179XNWfBg0iwxLPcOd7Z7DwlQnrXUbU2z5C5ovNjrO1QQqnu65xJZ+MaMXOLKi4wWTdhstGtBiMyr74OMY+Do4MKh/q2D02ZfH3h9iyFt243E2LK9MgCZXXKwjuM2qAMNpAQQAEFPfWCszYj1TUPc/KjRR/baVq41a7y/rbl/mDVfF+CGxmqTBIs6ozzKMUYFFausItv47ZY2eoQuRznRXM+ZjWpNhw9F9MrM3tmZ40P/FQb5WqcsrMyF8C8yHEK2AW/rnqeaiNbcikklPw68al6Sezg7X7bsYN5KQ8RQzuDGNK
 DAQBfJez
 HTRR49+yGbRggBzYSsCBMerDQE18UohdG9N00ma2+z8JOSX/lEUoQffYg2Ajs01yespVdQvrZux0kE7bFrUs0mJD1blC3HsmSfIXo1NP1zA85+yn4+c+1WvtsVqVtAbJ7G8XAfhVeA07rWHglF0rTlnxIThwMg7fRMeuu1Vj3Y4+kkm9b3bMLIEF1dtMnMGzyq6ALc6m1d6EVD7bUXRYSLW4XDw==
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
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


