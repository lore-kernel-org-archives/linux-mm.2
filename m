Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF2C9CCFA05
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 08:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14A2A8E000B; Sun,  2 Nov 2025 03:01:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FCBB8E0002; Sun,  2 Nov 2025 03:01:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2C058E000B; Sun,  2 Nov 2025 03:01:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0B238E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 03:01:35 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE5A11A08F9
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:01:35 +0000 (UTC)
X-FDA: 84064922550.26.360309C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0A020C0014
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:01:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f1nef/TQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762070494; a=rsa-sha256;
	cv=none;
	b=wtAQaiOqCz3p3SXFw8iG7ux1X1Lpptu33PLiG6xX/Hp7Gs7BSoIXCMrEXLjGwLUkndsrQR
	yFtTvc933TtWANtkRg0iJG3UXS3ZTdm7WDKA9XWFuHWotXIpLrOv0WgjtvvJ8IU9D61wCc
	6pqxUh1BZCGkSLbcmdeFZrBYJbsgasE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f1nef/TQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762070494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Ji5Lx1mSBU+j/1A4MD2fY9J9b6of1/4ZA10YsvMcHI=;
	b=8Gl1mIBzbmOp2vZwtnEGel4GbCOYcrl4RboAsbo5eFUMVcMsbgTjMXTY1078a8ggwbGT9R
	jvL/QhHtKZBFsFPl4PsmGhAVV9qqnargFX+CMBVfQfMB7JSTpIAUihnxXTwDSzABPyf4lm
	cYz2CeDNBVdfy58suYr24CNL4G/ZWEk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7CBB16020B;
	Sun,  2 Nov 2025 08:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536E7C4CEFB;
	Sun,  2 Nov 2025 08:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762070493;
	bh=3yq5E/X85v6vCVuKi2LScKzF5l88MwDsoXjHa+RbDfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1nef/TQhZ+F796Xeu1Yv8RCAWkBxMLpT3WZzt+UV0WqEs2aEKIoMoAXLhagtCz8s
	 mywFCKamPcczrS4bLwpwCcHhMdtrfWBFC6jlb82HEVH0+AFDzvVXT6C1AlcEoCX0aX
	 RZ8Bwl9GU+prIw3xflUKR6oa001zcgX7rAXY9SOLkjkbLYKSQ+8e9Lh7KMy7RXiDhU
	 CpLSLGZlYiIgc6xm345L+kqjhcUPsQd50DIClnoJZ+EjXTv37f/ih4nI89AN7g94Ob
	 jZANa329yv6v/RlYvvDIqAGUX8K6hOy0OfddkLC7S8kyRL5bC6+yOlJFk5ekQHFr5e
	 5n79o/rg/EXnA==
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
	Alex Williamson <alex.williamson@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>
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
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v6 07/11] vfio: Export vfio device get and put registration helpers
Date: Sun,  2 Nov 2025 10:00:55 +0200
Message-ID: <20251102-dmabuf-vfio-v6-7-d773cff0db9f@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rk3by7673qw6qmign9kx9n5wjjtych6h
X-Rspamd-Queue-Id: 0A020C0014
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1762070493-902878
X-HE-Meta: U2FsdGVkX18Y4WHBBm/hPn+KSa3zhzvCJ8mt2Fwvu4p8jboqrZwpW9m6XBbBnewG/QXK7wUDTGhkLgk9n3lb0ZSFqTJPaFwbKTbaJNdJTa3TdIJhUrrPJzfsYU8FgmCCp3TUpsrUytUnFEJTqAf7WPu2g/Q40SAEDCFVQSpdF/nfDsXBjbXLjF1ru3HnO8XQFtt4+GHRRMba+/DTA19Ul9owb+yYi97ODQVO7WYTJOQb1TJuuCZkdRj41VzdOgDBN6QPdDU9Fc8TXMa5RK0HBkZUnJiVyDzbSR4rwAx2ZmbAUUy6dapSIPjGGSY2EO3kD6D55y0U0JnHuPqguERamD/8GxbewJ1zrJ5Q7CznSdrVRHomdswco0/hpvhW/lpdz29PHu8VUNFV9b1ToSjNMgTkY+s12stpGsZhPE27rpgR3rdB3PN032shZctGUVP8YB5zfRcMtSJxIOQNEl0DEA0IRkmNmzZrPpQtAAOTAs17mr6LWH6tf4OPf8yWS2rmNJGwZV4mjd1Wmval1s7ldZcTGOo1JFKFquxdjHchInBLvTYVnRF45hTYg8OqhQhfCF4J6wtWMdT7AsOu/x0kTclr4M04JXGm16mWvkgo2+quDm+U60V1l1OjTAnK46byNoVWF1gmyVjspFgAU+RRHyOS5fTkg2/s3/CVCKDXURJjhu3J66L7Q8kdLdZPBQi9u/CEmOlJXJDJrE7/1WUZS9EO7PO12NHAgMKaLbYDdmkX/M1gCX80empWdhflpqpEsuVYUm0pCogWz3pk4o/bihv3psds0xkFVb0D1IePADeEESCfbPsR+gSzEgEI8/8AZe18M6ipcGJERtoBY4eRRvbejrnah1gpsBIokm/lRhrbzsIX5SEBydc9u4fJo/DU+1RHyZT9/yCoKBq1u5ssRhUZJNeN2TO8gDOmpQO7UpYfkegFTDtcGG3vtbRukALAb+8Nqkry3ycCnCW1OnY
 zBP7yJXk
 XIHmwoHlJNTkzULwCuDPplWdJhn9hKR+Zom2lsKePXx//fwK3TmXT6BwC7Fzox0XJKM3BvB45XG3fA2ybgErQ7QubF9THelnkRQ6vs0jTAO8/luxZhOGtlavXbD+GzU/1rB0nDvI/z8ZvS4IQSi+NNmFJ+GRYA0qWOO8WEfpziWsH8liAPwAEA4teg7MwyyDPL3yksDKJF093YV0+uXNz6CHFFlbICIRCMy3WgRLm+NG0aDIT+AC/a0P7UoxDp2sawVYj
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


