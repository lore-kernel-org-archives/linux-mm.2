Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDCBBCCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:17:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B68D8E0011; Thu,  6 Nov 2025 09:17:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E658E0002; Thu,  6 Nov 2025 09:17:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A4388E0011; Thu,  6 Nov 2025 09:17:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 289C38E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:17:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CCE3E1A0786
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:17:29 +0000 (UTC)
X-FDA: 84080385018.16.2F00608
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 273FE180015
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:17:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TrDqHCGg;
	spf=pass (imf16.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762438648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fubu4krpOYsbqru92iffAKh/WWUg4KCC+XoMrjigKj0=;
	b=NvhvDmap3D/Ygm8ChVNm13cSRx36Qu6xEoS7Uov1zrmgNUFoBo8zGrKSPueNngQKuiyaMp
	dHHBUClmPu7D2wZhdE+HQNlCn/wtSt71m6DNw6cCyfYki/DVWOOhIV30Gwv9/5tEv0XkGn
	1+/F6K/XMG7SiTYlzQhTu1mvT1dFhzY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TrDqHCGg;
	spf=pass (imf16.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762438648; a=rsa-sha256;
	cv=none;
	b=UkSIKXUnAScUALE3mHMddeC41bf+QCkJyvgEGiu6AgkIjvsg1lbe7YpEo6PQETdbpRX+nO
	sGtP+cOL4kvyGgyyeoV9pKRH8dzsAFtASPqrffFEQ6m0wRX3eslrmcexfJHKc3yOxomYSn
	X/n/PABSSM13oFoD+JsPBnoKK+RC4rM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 88A98601F7;
	Thu,  6 Nov 2025 14:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78ABEC116C6;
	Thu,  6 Nov 2025 14:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762438647;
	bh=bwei1HYhLRtewmmz8jQCKq/LKlcarzlK+hJ1OTkPqzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrDqHCGgXOoHmIWjseyq7yOeltz2u5un40QJmWLqxTEqnJ73fQAv+rag4bVDt89hh
	 NIS/JyfwG92mjzRrs17uqcR2QFDhnIfwnlp5AEGEFRvoaH5SiFX9+M8BJlLZdrP+Lu
	 w4nz2j359fxSdtHqx4lz58EQZL6NlhxSXgT2hsPMa6bT+NrXpX8XT2NQmj16toeUKq
	 RG0IIx4VUnwzDrPnXInLFsGiJDocVXYnSAcEAL50vy8Mmp28wBFcNoFvVBuScK2riU
	 K3VAJdr1zzyGufNRSUgTj2GCrjfIpfu6Yt0dp1rYZ5yn8/6779gHmK+eIKkc+074KX
	 nyiFT56TKhmTA==
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
Subject: [PATCH v7 07/11] vfio: Export vfio device get and put registration helpers
Date: Thu,  6 Nov 2025 16:16:52 +0200
Message-ID: <20251106-dmabuf-vfio-v7-7-2503bf390699@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 273FE180015
X-Stat-Signature: nh4u1imnznqxob5wjahbt3y31ic48eyk
X-Rspam-User: 
X-HE-Tag: 1762438648-848968
X-HE-Meta: U2FsdGVkX19UDLBvUfTJsyJegnDi6WoOASTY/9pbm3z6leInVrTP2bnDxL4Ks7K66MI6jYnNGOv1JEtAk74MNoA5GvtkGrMXER3VCbF3kqHUs+svOWxHfNy0GYraUV0y/r5eFlGQw1YT6yqSr83n6QzufGjCoW9KybhvUDiar95pKKP7ZknYi4xgm3ocGl2dK0BBnoD/bpKP0tZjZZCzoqhAztyKgThBE2SjEpNMngDgSzw6XRzeDYoRs33Co7XuAM5TD244g9PhOBY2WabDoZgYsz5SXHBlC7Dir80Q03LOGxg4CFNW7XRClfc1J34sWdm8uBi723kJhYscqxqh65EzMVy44ubdhYcDf3frG1lXmSbVmhIxyKoPmJumPxaJo++dx2r4gmN5QtdvXNv2TrS4a8QtHjJEQ8PDnVydhNsg167F8AHJInq64JNOR4O8DItYeY84oqb9MSM6q4Jgxn+Ye84nzU9WeFp8XoajqrkDehN20Ri22llUtdYrtTxbe2P+QRW0KHz2KM7hHDszyOAmIwUDNmTsYpnqRfz3nHMLIW/sYzArRx6dxbYD/bWU0zaINdAlPyBVqbBSyePqmeM1csnj1CTjeY8rzUnbxoznL1Cq7GYetXwl3vB4vAUBjfsQ1/BJXF9vMrJldVEk0Oli8kQDE3+CumwswWgpbqj3PvYUoaDM9ByudwAinR3zHcSqdNe9uUHQ73lNvwvVLIohhR5Ii/6KAQLQgCKCoJ7j6pxYzqvzryfxTUgwJytVbVHG0tk2/QGGqqc59XiFLenpssZ4OqxpNoX/ixYsAsqderPMOTC0FomaDKHKaZlyf0ZkGu+LtvBFz0OYPDIZuPQUA7sASCvmS8k4d9vL7O1ZD2WgvJdVCTP7Da7OciFeMenriJxShvViBnLdDCBY4JRC2Vlp7jZ4yCz+97sXzC+LQlRlogfO0jDdU0K1PYC5hILCI3fr7fPkPij31WG
 XUl6A6J6
 cOR3sCbM6wLukXm3PUyM338IfgPPwzTAdv66Kb5qORpsu5No9KWvgmrOEcJVwnDNmehtpcRGg5hKpMFrRFmyHTGgvNP14X3stDsB188hvMc29dTWo4jvdx02MJDoxp7hRZPXoKFBW6ak+rGh2liWWqTeStaxiXCsEsrCTZfl/XlCYif6UuPRrRPvGIzwd9Xl5thdgoKEIkGiz5bkmcWmXldHcEc45pCwjp23ROyLdXJZ+HmkLx0mEwlZmS2w1tO5OjDe92hrJ3UT6NEHukCSFGOMHFOLbO7nP2iL6
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


