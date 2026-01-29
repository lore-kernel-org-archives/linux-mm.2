Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B68DD73E90
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3D66B0099; Thu, 29 Jan 2026 16:25:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2350A6B009B; Thu, 29 Jan 2026 16:25:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C1986B009D; Thu, 29 Jan 2026 16:25:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F095D6B0099
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:25:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB53DD3B58
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:53 +0000 (UTC)
X-FDA: 84386283786.16.CAC5076
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf20.hostedemail.com (Postfix) with ESMTP id E838D1C0006
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SLHFNADb;
	spf=pass (imf20.hostedemail.com: domain of 3XtB7aQgKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3XtB7aQgKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3umikqL/So8idv3VwvFYaIe6+4TeFw4VgnmENinGbaA=;
	b=rm+UV9gXyFlew293NVfWwQgGAIo8lwD0rAr2TT0ZGgF9QInRRlxLyCgHpsAsrAMLTw60io
	VYRaZ85e9TbZEurxv8RShuI/70Ba6x6reFTRWk7UnLsjXDFjZ5CYmPNfBUG//x1JToQ8/i
	RLNsbR2R2RctaJol/VivuDKm3tCh1cY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SLHFNADb;
	spf=pass (imf20.hostedemail.com: domain of 3XtB7aQgKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3XtB7aQgKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721952; a=rsa-sha256;
	cv=none;
	b=VPNNBwEQ0zc2bMLimgeFlGhsnNwL4xgILYvh8UNqHEYmF/3nRUHyMcPs0HjOc4Rp6xzRBi
	9XbKHDo6h/9m1OFh2nt8hmoVseuOGhoMULSvtMBEQuBZFc30XiYcjqx9tmlG+QtKGkPp+g
	xkSYQeo7izTdXk1XPdqALHiq6scLH3U=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a7d7b87977so12684315ad.0
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721951; x=1770326751; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3umikqL/So8idv3VwvFYaIe6+4TeFw4VgnmENinGbaA=;
        b=SLHFNADbYr5JSTNwtJOXQtVysmV63s3HWK3f+nfPX9D9AF0muxgH/mib7EFLsvEP3x
         7mBQx1W9WHK5UBY4OugGp3916BUGbrZJ3sVHL+Z4gzkz2h5fdUxH8U+oqx+L/1WbZfn4
         FS30qLI7nbMnQpLryOnJO2FuX3WUk+T3pZDs+QZmvv9nkSwQ5gJ6gKegwvbZrmnp1D3C
         i/LuqwARfrdmntikDslHKyaDJc5Z/oludvh6fTNjdBiv8VmwhOcu6u65WP0GfjPE/hJd
         Vl2q4pwQjvi8vq6hfhtRjzV3OYK5iogQIoa+K6AC98y41eqzR997CNegVXCFgAJcM2oO
         fUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721951; x=1770326751;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3umikqL/So8idv3VwvFYaIe6+4TeFw4VgnmENinGbaA=;
        b=WmAHsVDwFujAUcQIFgWic4JnwYAwHRdIC+TJVJPQHco8DuFiMFNuekfbGYJudkfRP5
         kohKRCwDskz8MHt4Z3UqStKVHK0rUZJsEKZuTEhJFxlxZR48P2BITJK6nwKdBiuoLDWb
         fFytJgS/iL/dpe/4lYmyVrGrOe2TcjPYvWQWEyYfxaUcCOdNi5mDyn30dpCte1v1eez4
         q4gLrISnJBP8L3YRXOzFDvqPSmERg0MWBhnOU5qR+WbEc3BKVU0tFKuPYLx8rIkPZ/q3
         n7n7cYHQwAqcoBw5l8n1bm65KppPjSznLcHjxQo/YxgrXzS7MGWgTB0GpkDj3I7un0pL
         H9eQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQWc8nGEGDW06pFVtPaDonsdJVHHLLVzGsdoLChyzFpVDPjURiG1phNfjNlZTw8gweKJUAjRmeOA==@kvack.org
X-Gm-Message-State: AOJu0YzoLIzVpSfwuB6ZYoktQx7VHo/5vBcCCH/LoTfTGDt2gUKqbw45
	qc7O+uZTjY8VjucsPgyMQ68zggA9EeZAynrPjVoB08OWgr4Tkia53O5f0HLGx+J7npMV4i8wqJJ
	TqVel0jcYMfb7hg==
X-Received: from plrf5.prod.google.com ([2002:a17:902:ab85:b0:2a7:6c0c:5916])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:c952:b0:295:3584:1bbd with SMTP id d9443c01a7336-2a8d8176d76mr6976645ad.41.1769721950767;
 Thu, 29 Jan 2026 13:25:50 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:55 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-9-dmatlack@google.com>
Subject: [PATCH v2 08/22] vfio: Enforce preserved devices are retrieved via LIVEUPDATE_SESSION_RETRIEVE_FD
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E838D1C0006
X-Stat-Signature: ot83kf1shi63fhgpkdt799jdd5159u6u
X-Rspam-User: 
X-HE-Tag: 1769721951-69710
X-HE-Meta: U2FsdGVkX1/vHoYRNfp6CZh8NtHh/FSYXyNTCp+jlJdfmiuMwxDx4tzVs4HczfTTr9sWZ5U75JgkLt2niGFVJpCA5V1N5kt5hm0+PrKWj8m9KBf51DWky2pjWjp85pUlMe+V7gk8soF/rQENJylko81nS73FQCxL5CizB+9WGm5Iu+r+bT3ZnctxTZ53BlI5wSLx8ddRQU9SJEErjA9TxByjOxY6xFXg8yGa8NSlkvPvJA5aaWi+7AzS8hvCUk61+Yu0cHM9qnwow0zteQWdPmT5iJCIsMeq0NQ+eZ7v8xb137wSQbiyZKAaEdaORbrrYZitjfd964duUn+3ssLzRu++Orw6xNtl1z15EVULbQLT410C+3t2DaFQxgoyAo6hhxxDNI2CHmWRlCaEspOSsD0e5CAh10I4n5I1w/aS3LcvVb+ubhy9F6mIxDy9EYl9RwIUuLWRJkolrAFKZISouPLHnpaqeFYEbzJfI9D+HRFtpNDYRddIOUX08Yrb+vVdD1kLhiOyaAve+k16lZtYGdqX+TZRdLgaa6bLEAc84TUd4ityW3S7SFhuvdhY/TSNpQXDvqZxVh42LD+Scqg0Vd9Uh7fZvmC4yCbvBPfS+yV3VwHfYGBEmSlsZQ9iJLS9dUcbWmxR8Gq+rlSNKMJtp2r0F9ynnF33qmP1nRl5fYz1f5ybAuKpBGP6GVAdspZO6SPp69+MiM4gSTfq5JSRPqCfwJVv3Oh2BVwtlPGsSHQ3mHkRc9pnzfKMAWIbViYYtuYpYUcdLIkPx2tuAxmU5hz1A3EwBNWNspOVpHEUQ7lomH6zPv7KmjOhRs4M1rXL8UWYQGmHH0iXaGcCTlGvUT5QXgR3E1o23mAiCEpzc/8rSHS/ru1fCfCvNlAwnJjkAkBqdCAuZ2RyVAlBEEntSICzZu0n1oE1xiFnyFogDW3xJJAKYyPuW17YZFX4ccitpAciP9V+RkFLpOwNULO
 X5nA7K0a
 yqXVdcOZuJJe6wJi33vXJnJ3gQBOvAfm9rWHVP3nqtudntO30B0bHAjljVDT3KItDuAdwYBpJMaEqNuF+rI5Zp2gCkI5My3kZ37UX71sSBoxgB0AnQJ8zKYGdPg0dmC2Y3TNyMoGMSteT+6vnlK4dLPqGUwE29HkTO0Z2dDmDn9buLBRfnxqmEi13DE6K30fgYgZkw9WeG2Lpgq+yJbD3DTp53fS8VMesbK6Vude1nBhuKSHseeZe3spSopNhcS8XpKCi+UaThcTYcyjvhAlrCl7C8jKFb4Rd4hniBmCthTyb8ZXCgKnh0KljFtXD+wZPyz87lgdoTyoWJbJvrO+Z2TYiZs4PXAdw+h4xTSLBayeluSAL+nCtS2b6dK8qclGxun9jeoyXF03F5AKvCOr3h1uhFf6ZZqWBKuUL6lh20LhaDgD5MhGL1ay1k5KOdvyybBcsXe5vmo0djiBw3USnSpFIbhv444yzQknBMcOfCNho94ZBKAthsbKUYJ8hMu/4yjcXE2t3ZFAsgfuHu6qHoCFTuWpYQIzc9rSTilJ5w/3GSqI9aTbyb9rSx5tKWKQgc2HsfnPSpetmpbexB1qNRRwTIxrHVFEcA/pXEG8CVbDNKCW/tPe5QtNhsDSiQySYSdAR1T++zVF0bW0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enforce that files for incoming (preserved by previous kernel) VFIO
devices are retrieved via LIVEUPDATE_SESSION_RETRIEVE_FD rather than by
opening the corresponding VFIO character device or via
VFIO_GROUP_GET_DEVICE_FD.

Both of these methods would result in VFIO initializing the device
without access to the preserved state of the device passed by the
previous kernel.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/vfio/device_cdev.c |  4 ++++
 drivers/vfio/group.c       |  9 +++++++++
 include/linux/vfio.h       | 18 ++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 935f84a35875..355447e2add3 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -57,6 +57,10 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
 	struct vfio_device *device = container_of(inode->i_cdev,
 						  struct vfio_device, cdev);
 
+	/* Device file must be retrieved via LIVEUPDATE_SESSION_RETRIEVE_FD */
+	if (vfio_liveupdate_incoming_is_preserved(device))
+		return -EBUSY;
+
 	return __vfio_device_fops_cdev_open(device, filep);
 }
 
diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index d47ffada6912..63fc4d656215 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -311,6 +311,15 @@ static int vfio_group_ioctl_get_device_fd(struct vfio_group *group,
 	if (IS_ERR(device))
 		return PTR_ERR(device);
 
+	/*
+	 * This device was preserved across a Live Update. Accessing it via
+	 * VFIO_GROUP_GET_DEVICE_FD is not allowed.
+	 */
+	if (vfio_liveupdate_incoming_is_preserved(device)) {
+		vfio_device_put_registration(device);
+		return -EBUSY;
+	}
+
 	fd = FD_ADD(O_CLOEXEC, vfio_device_open_file(device));
 	if (fd < 0)
 		vfio_device_put_registration(device);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index dc592dc00f89..0921847b18b5 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -16,6 +16,7 @@
 #include <linux/cdev.h>
 #include <uapi/linux/vfio.h>
 #include <linux/iova_bitmap.h>
+#include <linux/pci.h>
 
 struct kvm;
 struct iommufd_ctx;
@@ -431,4 +432,21 @@ static inline int __vfio_device_fops_cdev_open(struct vfio_device *device,
 
 struct vfio_device *vfio_find_device(const void *data, device_match_t match);
 
+#ifdef CONFIG_LIVEUPDATE
+static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
+{
+	struct device *d = device->dev;
+
+	if (dev_is_pci(d))
+		return to_pci_dev(d)->liveupdate_incoming;
+
+	return false;
+}
+#else
+static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
+{
+	return false;
+}
+#endif
+
 #endif /* VFIO_H */
-- 
2.53.0.rc1.225.gd81095ad13-goog


