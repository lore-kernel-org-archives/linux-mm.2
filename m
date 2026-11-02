Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77D2360F17FE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jRxB5Iii
Received: by kanga.kvack.org (Postfix)
	id 7531A6B061E; Mon,  2 Nov 2026 10:37:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7037E6B0649; Mon,  2 Nov 2026 10:37:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C86E6B061E; Mon,  2 Nov 2026 10:37:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1FC6B061E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:14 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B60D0A015D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:13 +0000 (UTC)
X-FDA: 85390582746.12.400C91C
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1527020005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jRxB5Iii;
	spf=pass (imf31.hostedemail.com: domain of 3Jq7oagcKCIM2pwpuzonvvnsl.jvtspu14-ttr2hjr.vyn@flex--vipinsh.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3Jq7oagcKCIM2pwpuzonvvnsl.jvtspu14-ttr2hjr.vyn@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633831;
	b=vNzeWmhSgHeaGGdY/RuFKDrivZn0TWwsH3/p8APhBTg9ozs13OTNCDBIFABra5p/Au0JZo
	EZofq05M8kHxm7rslVmuwolqqopx+whkMou3vD2EvcLf8GczbDb7gYvn9jkPqTxMjWUcFs
	F89THDyrujgkN0AnYEwAI45wRhGLVCg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=jRxB5Iii;
	spf=pass (imf31.hostedemail.com: domain of 3Jq7oagcKCIM2pwpuzonvvnsl.jvtspu14-ttr2hjr.vyn@flex--vipinsh.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3Jq7oagcKCIM2pwpuzonvvnsl.jvtspu14-ttr2hjr.vyn@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3L9pfGvMPznW7jp7Vs9w+wIM+Sxe1yFTij+KVLbvMwU=;
	b=fbdyt4n4qYcg8n9wdB3+FBffrIDkiI2F0b3ER8QwWuecmkysISh7Txr9aoWJPijj/Q5sp7
	6vKEWgvxYYgwYjfXTVhgXz+UM1mY22TXsTcs8Pu4a7W9S/veAilBfIBgKwy4c1RZsuBpFK
	oRoNBEUoH7l0C91+NAizJFDA3LN+foE=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e942b1cc86so35701765ad.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633831; x=1794238631; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3L9pfGvMPznW7jp7Vs9w+wIM+Sxe1yFTij+KVLbvMwU=;
        b=jRxB5IiiKSzhCClDx/0dbTL+k0sS9f6HKNyBYHgXarf6sS6xu48eUXpUvuovs42kHr
         ewlY8saq620LcjIEje6wFaT+0sUOu6l1y2mDwO8AbNCcd+HHwHAePo1v7NSQpJ/5fSZS
         vBOqU5P63rTQqiJo4D2M8AgZCWiqyerXG2hejO0G+2hMI06zXmoVCg0tdTRPzZfbtjKc
         CYan5kmsaNB+tm+2GCAx6m+w2jAR5B/HIC76uRDkckxUmJzu4wFY/mi+UIdA5JEfqkpy
         HpKjp67/SD7Ae5/AdbHs6lD04DmUlXadOeK+JXegWarsgbSSX/J0ZHTLdVdrsVCWcE4I
         DJMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633831; x=1794238631;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3L9pfGvMPznW7jp7Vs9w+wIM+Sxe1yFTij+KVLbvMwU=;
        b=jWpiONHHv/X+qwj1ls0oqGW6ZTR6TlTlLZyGvEcEyKOHqT9VbGTMR3xsKoj7Sll4zw
         BrUYZd1Ud/WfBoCiidcdWJMy3yevpOW4ALqcGW2/yFvHU5g7rNTwXlZhMKBQXKXCDne/
         6bTDJCXZfFDizMV3fhvGw62naiIjUfzEZlgw6ndcB/hitz3PkoPQSNKp3clMcsDPn/PM
         XJwh0J0baHagYT3JeaxgizWM1UVl8La9sSjnI2i6QJbZD25dMSBRNendZGLHtvzLFlIX
         lzsZoDnOh4k4trwJ9iK2KmXSYaw7hxNvYa2n1D2tQDI3/LH0b4cIQbyydQx1kcf0Ycdk
         igJA==
X-Forwarded-Encrypted: i=1; AKwUvBwCiNIenmci09O8p9wfSddIdkahPa95SIYmC0KMHjYfxYd5zgK7YTg4vjkpajnvvlw/Is35EreHig==@kvack.org
X-Gm-Message-State: APuU4Z+bW3bAycnQYV1/LpgDWv7UVHlCn9ERM5mGbDFtCvu+w1Ve2iJI
	wSXjva6HhzbU7Z9CfyWYXVtLJ/A95qOyq/Pkx0bqctuC4TcWZDDZGrWeo8Aqg2xY1V/PlE0bKnW
	8CiPUfYBHDA==
X-Received: from plblf11.prod.google.com ([2002:a17:902:fb4b:b0:2ea:7f9c:2ce])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:124d:b0:2e3:1bb4:6121
 with SMTP id d9443c01a7336-2eb364deeadmr90939265ad.49.1793633830638; Mon, 02
 Nov 2026 07:37:10 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:39 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-11-vipinsh@google.com>
Subject: [PATCH v6 10/27] vfio: Add API to open cdev device for Live Update restore
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 1527020005
X-Stat-Signature: ck5i38zimg57q7ixck5n5i99c8spyokp
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793633832-401954
X-HE-Meta: U2FsdGVkX1/e529pUDWEAx/jO+LH12q29p9SiwXAozAw/iJl1uFBdT9N8YB1PZ9uLSGX5VupkmqwS4rn4db+BwNvBPxbsvN70qo99/9SmGSAQvJL91FG40pO1Azi5C3OJaaBqjEek9pzSGv9CEnxPaxRY7tAacZ6WyxU7hsG4Pnr1OaY8pStCXBmn9GPEX65/3dVk8IvyVcUtYoClCmeQnA8mihE+4JxG9iD5ZUV/TYNmR/DGbD+ABk77GTrslaxVndZFyaHox5vwXFGzyewihcvI046HNNVaeyGjepF944a7bY8dYAOAPxVBFjyv7LxqD9nxAK4PRkP8HW76iwU7KptQB7i+NmD5tbb0Il8m0d2N+RV6S4GG3CMIoFus6ZG/eSiJCBvqnyIr0p4eXBCV1z1jM6lbtSOcmAxW+KQNTtsieybd3T5eiKIjCefP/jN1ZEz4oCKIOPVtXbJH7VisNMHfdBVjnCjC79sZxJ1VPNQGdRz5f1ewoHDEaKP9xOdW+ErBVKEfoU6GvQDTZDVVgTejwJWiq/uxcehZj6wawizExprvew+Rsqn07JAxjzQCFdmio1n0OnGU8lNZ6Ad7J7xWfMX86fjVH0C/m3T9S/CzsgWH8+/JdNdAiBpXdB0ILPPRfjyWkp6hw9cZXfSdUrIG6yh+1rfEsZmj3x07QE22zNMKw0aEI17ktXThzK4xiUcE4XfV2oj74ETKUqYDwctZvqAo3GxsSrSX41UVXnmlMFYVDSmB1n+Uo/cMob0V8Ope0/uaV07XvtNbeKFc5Q25gZ3Kr/Hus+em2qQo1sq+h8NxaxZRi4JEuGTLkXiRQc40abAse7nr4w1ZOMMUPzq9fssjBKO6zUdipgsVEWRgd7g2/w4/MGXABKgczns4fYxTjoaX8GdnaezeAuREkZDuXVgMFq9yQmsv9S9xzH+EMt8cDtmWm33/hjM4Iz7wcsi0VAVfaVLnP/ieag
 zRixAa5L
 /55r1N3FKfGlatyhFPLNpsv7NBHxrJfu1HZcfc8bSN5YWpKG5NgVfDW9Mu98x6ImTVRzws5yaKodJh3rXON7B3AuxispNjuUwJHyCb6d8D2Dhd5qJryszdic11CUaOUi4L+52sfE0AOWBFLnRDx98Tb9B9DSgAsJo3rHIh3UPPR4m2xInngw/PbzL61TUzk+ljvzH6c62q+F24Tb8PssxdFzMOVooBjZEDJndo8lQ8aWJoVzyqIZBEzKMwgIlG0jCI7MJxK1VRHUUZNpy1H5OnWByBdRxXwrIpg4dnMLd+qU2eeFy/5aGT0i+/d/tOPgy9rvbV61jnVv+X5eQsvNdPuQPb68/luF8dAJ8SISCxSMR8uEgKjYRoJ+uwief48AVJElQlIoJjRA5ES+N0aA7w5BuUthhB4Z5zKZdrvp7KYg2MJQKkvfE6LcDPqi/mHLsVxjtF1u7BzSKqkBWhr6hWsIaDGv8urUiVgNN76WjKSZ8FM1pd2m+QXvGPXb2FOuM13BL5+zADCGsNwNAcoPbBfw6axUH0vzObZZ6Du0UT6IreRQguL2brrnfiC9dbZnsmk4jAzTweZaEXb4feLmXtLbJl/4mlcX8u9mUz988iW8/QgPIkYu3qTDAPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

During Live Update restore, VFIO PCI driver needs to recreate the device
file context that was preserved before kexec and return it to the user.

Provide an API for VFIO Live Update to get VFIO device file. Use an
anonymous inode when creating the file, since the retrieved device file
is not opened through any particular cdev inode, and the cdev inode does
not matter in practice.

Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/device_cdev.c | 39 ++++++++++++++++++++++++++++++++++++--
 include/linux/vfio.h       |  6 ++++++
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index d83e99137e1a..38e691eceab5 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (c) 2023 Intel Corporation.
  */
+#include <linux/anon_inodes.h>
 #include <linux/vfio.h>
 #include <linux/iommufd.h>
 
@@ -20,9 +21,10 @@ void vfio_init_device_cdev(struct vfio_device *device)
 	device->cdev.owner = THIS_MODULE;
 }
 
-static int vfio_device_cdev_open(struct vfio_device *device, struct file *file)
+static int vfio_device_cdev_open(struct vfio_device *device, struct file **filep)
 {
 	struct vfio_device_file *df;
+	struct file *file = *filep;
 	int ret;
 
 	/* Paired with the put in vfio_device_fops_release() */
@@ -40,6 +42,24 @@ static int vfio_device_cdev_open(struct vfio_device *device, struct file *file)
 		goto err_put_registration;
 	}
 
+	/*
+	 * Simulate opening the character device using an anonymous inode. The
+	 * returned file has the same properties as a cdev file (e.g. operations
+	 * are blocked until BIND_IOMMUFD is called).
+	 */
+	if (!file) {
+		file = anon_inode_getfile_fmode("[vfio-device-liveupdate]",
+						&vfio_device_fops, NULL,
+						O_RDWR, FMODE_PREAD | FMODE_PWRITE);
+
+		if (IS_ERR(file)) {
+			ret = PTR_ERR(file);
+			goto err_free_device_file;
+		}
+
+		*filep = file;
+	}
+
 	file->private_data = df;
 
 	/*
@@ -51,11 +71,26 @@ static int vfio_device_cdev_open(struct vfio_device *device, struct file *file)
 
 	return 0;
 
+err_free_device_file:
+	kfree(df);
 err_put_registration:
 	vfio_device_put_registration(device);
 	return ret;
 }
 
+struct file *vfio_device_liveupdate_cdev_open(struct vfio_device *device)
+{
+	struct file *file = NULL;
+	int ret;
+
+	ret = vfio_device_cdev_open(device, &file);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return file;
+}
+EXPORT_SYMBOL_GPL(vfio_device_liveupdate_cdev_open);
+
 /*
  * device access via the fd opened by this function is blocked until
  * .open_device() is called successfully during BIND_IOMMUFD.
@@ -65,7 +100,7 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *file)
 	struct vfio_device *device = container_of(inode->i_cdev,
 						  struct vfio_device, cdev);
 
-	return vfio_device_cdev_open(device, file);
+	return vfio_device_cdev_open(device, &file);
 }
 
 static void vfio_df_get_kvm_safe(struct vfio_device_file *df)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 1c1e41de49b3..f46796b6724c 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -434,11 +434,17 @@ void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
 
 #if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
 bool vfio_file_is_bound_cdev(struct file *file);
+struct file *vfio_device_liveupdate_cdev_open(struct vfio_device *device);
 #else
 static inline bool vfio_file_is_bound_cdev(struct file *file)
 {
 	return false;
 }
+
+static inline struct file *vfio_device_liveupdate_cdev_open(struct vfio_device *device)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
 #endif /* IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV) */
 
 struct vfio_device *vfio_find_device(const void *data, device_match_t match);
-- 
2.56.0.317.g454f8302e1-goog


