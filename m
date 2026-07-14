Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 212A1C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94A106B00EF; Tue, 14 Jul 2026 11:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9218D6B00F1; Tue, 14 Jul 2026 11:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80FF86B00F2; Tue, 14 Jul 2026 11:15:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3BC6B00EF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D464BC03EA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:21 +0000 (UTC)
X-FDA: 84987730842.07.4C4487C
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8B8B4140013
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TKTHqQPW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3hFJWagcKCNsSFMFKPEDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--vipinsh.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3hFJWagcKCNsSFMFKPEDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/JxusoxEn+ehjTRVvbJo8Z2+RthtKj17Kn8IH4fWGXA=;
	b=1TkVnOUWzyoXujLCgvzhY7NjV8T+r+q5C2j2m+AgYuhba8cBOk/6B7ING4Gu8y7OaLPmmD
	zZ9BFgX3N8Z2Y2uNpiseAET5ivJWZ7OWvIqMqxOrVx5T1GJedy+it30SqGGive7sCFoI5L
	1QbpqV3bKJAo+F5fvq4eJpAzyJRxquo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TKTHqQPW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3hFJWagcKCNsSFMFKPEDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--vipinsh.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3hFJWagcKCNsSFMFKPEDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042118;
	b=xqBc937fzKajOzkXAQ3NLfKEXSobmbARama6NWuhdAeA395kpwrGxp45dIbCqvrdc/549s
	oFpRN1OC2/4Qw/ZUs1wFjg60POl8UG1oaRbhVK5mdYm3s+4dy9DTWW6KKgGBdDOojtGVQi
	Pqq+9vCknB3N+Z5OnGiE/lvR2D3mDgA=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-848860def2cso4614515b3a.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042117; x=1784646917; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/JxusoxEn+ehjTRVvbJo8Z2+RthtKj17Kn8IH4fWGXA=;
        b=TKTHqQPWCecw6b9cnUDZJ9e/980rwr/Nk6/x02a9JGzzuIkw5t9+Yg48LSacurl6tr
         SCBAZZtw+ltfZJHd0Y5PdzwY4r5qq7/Z/97yvWDKBZiKYJe7kUfX4mbM5Kx7ZaAx6KvK
         KhiAJ2meuNmQqVJBGdMeHElDYLRsP0KTWesaVp1XBk1o6Bf+vbkQxiPG6QCYWH5o/rq5
         HTre9W+z5k2RMGuDdhyM+hSo+2d86ucjV+KMS7+CxW0zKna3qHSQC/Yc9clqGPmRDpJ5
         ov+ozZUftmLHAfO2jlhzIwRAO2SmVWQ42rSWcKLnmuFZJ8jNFtkWH/cdMts/0gKfE0Wi
         7Ieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042117; x=1784646917;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/JxusoxEn+ehjTRVvbJo8Z2+RthtKj17Kn8IH4fWGXA=;
        b=DcvOeJNjNTzobFxXFgVBwDBpIYHbrSUFYWwByUAs06yE+Zyl5BjxuoGizgXCYNGzZh
         PCNCFqHpxPgtD7GG1Z6KnN6g/8zoAIjn5NMpU5SQnBmpSkyL+FMBzWBVtwI7FM3FWlAz
         fIkqk5U3NOy/1xv3JAnKP6eiMDHerao2XQ0BtAJEjbZEaF3Cpyw11XVuRv33QCYdrsS9
         i53WYWB/5wBmrrigDPoxW7g7EReWxMWrjDUJg85xV4hUk25v9wEjP8B3gcLxMC+fABxU
         TPxXODKLJnxzYTr0XhZJiVHd2rYnJ1gvUCl7glr+KGFoSlyisoTJSjj+lRUlVPng/KXA
         /Efw==
X-Forwarded-Encrypted: i=1; AHgh+Rq3HcsQD64auKeQb7TfKMG+4HTNUVnNGs4ifNw1yJfSAb/nLqEMPTHVByDoX3YXpZBZx9RtxtNf0A==@kvack.org
X-Gm-Message-State: AOJu0YzK3XXTgFChTiiFQuKNlHBkElf+zpqISS5+mPpy2P+Ylt0jgMrn
	pS9Fi++8pS9isbZ2kZ/zH2FVybvBKyLyrg/SZNHOmgRGaGmCPkMh5+1ysTD1Cjn6rM3K6JI37Bd
	8hw1bmNJp5Q==
X-Received: from pfbcr14.prod.google.com ([2002:a05:6a00:f0e:b0:84a:2de2:315f])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:94f5:b0:82f:2b0:2809
 with SMTP id d2e1a72fcca58-84889637281mr13764500b3a.1.1784042116875; Tue, 14
 Jul 2026 08:15:16 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:14:52 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-8-vipinsh@google.com>
Subject: [PATCH v5 07/20] vfio: Introduce vfio_find_device() helper
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vipinsh@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8B8B4140013
X-Stat-Signature: fi5djhtofum87nreg5g34uobydhbjeaf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784042118-334487
X-HE-Meta: U2FsdGVkX183xOklbnKgnft2orNF52yrkH107XY9Nma9J0gneDJnDP6XhE36N9gHv171FsM6Fdt6ZY0FjpY0Q1FIiEHCwWbECpgyslqMSd1SIUvEN4l9tKN7WDQkm33oGRtsg6ryRtYKY7ovORMGS0vlkNqj9s49cl/3/gYWQFD/tUv3lvgDe+MPBVhPolxVGVu+snwYZg09jmgUTo/aOgK/6Vqf0p/lNyoIghZHUzQBsGYqZEZQqtmB/o7girnxSjYnfp6NtMZZCfBXH1yFGmlJUD6ypJ1c5hstdY0Qs2F0gW0O1NRHOgK9iIKyD7hcAaHrwDY8RA7zXAiD7goFXP05pvV4N/8ke0Zl1XUokePfH0WIXjlxi2x/uXVSWCESEwZxVldi2vHRGfMZe96QKxtfk5tShBcFZj8/YBQ9dNoJMGj0PNd/5hn6nGOeQWjDM3at4+W2gX9f4U/0DVX1mnyyjDljaWJnZxl36i7gB84XosU5rlLkM6BxJ0ijtKEMebTIO2PPjviuRjzMr0t+/Qb+3YYWxHx+pXxDRoR6o9/yWzzgktu8Q3XNZShtNmeHjyamSQlHz7jc53h/qyIZfFv1XyK8V3WS5ZVjsYuSymqFBGlG7/FpJuQzQOpTLwTlSPh6GdkG9xUWrSHQfXe7VPEdLWI2ZDdwcJWqXtdbKE05gzwgiCSFae2mRbSC69kT56mJn2DTDTtjN4oNAazyP5vYbb1MsHcYMfRuyra8q6bO6FCQjRhcRLgCAjb7fpmtCBp0cvLwVp+jp/ZeSzpy97NYNq7WHwsd2FZ6hZE3T0JppV9WvruAuPcpM19ZSxsgW/GAT1zf+Mtx5w710/ygtfkqOoAEhXZ8oJNWXwmN7857gDee7PaNeIOA7DI+QbcQvucwtamsFnlluWBl7d2Nv1yuG+Y4Uk2YgLaacvKfNSt4OSqyjeOlUP3by85vFWlyYaRc8vcZFaFFO4NH9rM
 4r9Rkcal
 9cnoB0a6ZoID39VzO2DLNombuQsvSw+vM8kCOiFgghdo0Vx9xlIF/wD/VfDvE3DC1HlR2DC0hiEZOc41sh+lqNro7BZdn3zESJXfY632mac8XrSlf0fw114+CMJ39ylOJua5df4VffbLb7haRPuXB3PlUubB6aIKHNz3qUFqjO7kZqVPXiuK6MjZSRMqoaoFAchgJe0MrmRAMb1WaeHLB4O/XKEXQULyPClp5EBxSsn5zzZo29oJOgDhEAEiCYbY556zlVJ+IXLoAkzz7xVlYiu3EF+AFrXuMXVezlJ0jiBtufz5XFM+6CzY4las6M201HHNRg5W2BmMz6AuTPUmZvgzv95t2znxVEJzuYibHo2x5jt603eim2phw2NDmLLFCaA/Eg6W/VTUhMnu/hEOG1kGGQ1Q7QAG/rZgoTuX81HI0Cnkxibwx2DJkYBCTCLYkuGqwLAKUpyeZ+cRcFQct/NB2bbUJq3O4CQuhbOhqEcSMxuLmArJ2jdmjJ6V+yyYK9JnlLFqcKBAf129Osgb64krlywd+jNJA33eV1Q8bbPvtxwecNh7+OmZt8Sl0ir1NjhfGuiWX7Ly0jdIopSu7b6wrHWCUCXL7Pc71ue4TFtq32ay4aoMO5LJ1BsLx8I3Ov8s3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce vfio_find_device() to discover a registered vfio_device from
vfio_device_class matching user-provided criteria.

To ensure safe lifecycle handling, vfio_find_device() acquires a
registration reference (device->refcount) via
vfio_device_try_get_registration() rather than relying solely on
device.kref taken in class_find_device(). Holding only kref allows
vendor modules to unload while external callers hold device pointers,
leading to a kernel panic on release. Callers must release the device
via vfio_device_put_registration().

Additionally, move refcount_set() prior to vfio_device_add() in
__vfio_register_dev() so device->refcount is initialized before the
device is published to class lookups, avoiding registration data races.

On vfio_device_add() failure, the error path drops the initial
registration reference and waits for completion to drain any reference
taken by a concurrent lookup before returning the error to the driver.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/vfio_main.c | 64 +++++++++++++++++++++++++++++++++++++---
 include/linux/vfio.h     |  2 ++
 2 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 2437af031169..e91fd83dc58d 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -13,6 +13,7 @@
 #include <linux/cdev.h>
 #include <linux/compat.h>
 #include <linux/device.h>
+#include <linux/device/class.h>
 #include <linux/fs.h>
 #include <linux/idr.h>
 #include <linux/iommu.h>
@@ -359,17 +360,20 @@ static int __vfio_register_dev(struct vfio_device *device,
 		goto err_out;
 	}
 
-	ret = vfio_device_add(device);
-	if (ret)
-		goto err_out;
-
 	/* Refcounting can't start until the driver calls register */
 	refcount_set(&device->refcount, 1);
 
+	ret = vfio_device_add(device);
+	if (ret)
+		goto err_add;
+
 	vfio_device_group_register(device);
 	vfio_device_debugfs_init(device);
 
 	return 0;
+err_add:
+	vfio_device_put_registration(device);
+	wait_for_completion(&device->comp);
 err_out:
 	vfio_device_remove_group(device);
 	return ret;
@@ -1797,6 +1801,58 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
 }
 EXPORT_SYMBOL(vfio_dma_rw);
 
+struct vfio_device_match_data {
+	const void *data;
+	device_match_t match;
+};
+
+static int vfio_device_match_fn(struct device *dev, const void *data)
+{
+	struct vfio_device *vdev = container_of(dev, struct vfio_device, device);
+	const struct vfio_device_match_data *mdata = data;
+
+	if (mdata->match(dev, mdata->data)) {
+		if (vfio_device_try_get_registration(vdev))
+			return 1;
+	}
+	return 0;
+}
+
+/**
+ * vfio_find_device - Find a registered VFIO device matching search criteria
+ * @data: Context data passed to the @match function
+ * @match: Device match callback function
+ *
+ * Finds a registered VFIO device in the vfio_device_class matching the search
+ * criteria specified by @match.
+ *
+ * On success, this function acquires a registration reference on the matched
+ * device via vfio_device_try_get_registration(). This pins the device and
+ * prevents its vendor driver module from unloading or unbinding while the
+ * reference is held.
+ *
+ * Return: Pointer to the matching vfio_device on success, or NULL if no
+ * matching device is found. The caller MUST release the acquired registration
+ * reference using vfio_device_put_registration() when finished with the device.
+ */
+struct vfio_device *vfio_find_device(const void *data, device_match_t match)
+{
+	struct vfio_device_match_data mdata = { .data = data, .match = match };
+	struct device *device;
+
+	device = class_find_device(&vfio_device_class, NULL, &mdata, vfio_device_match_fn);
+	if (!device)
+		return NULL;
+
+	/*
+	 * Drop standard kref reference. Caller holds reference from
+	 * vfio_device_try_get_registration().
+	 */
+	put_device(device);
+	return container_of(device, struct vfio_device, device);
+}
+EXPORT_SYMBOL_GPL(vfio_find_device);
+
 /*
  * Module/class support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index cf0d941d0410..42c3a9ae3a85 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -430,4 +430,6 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
 void vfio_virqfd_disable(struct virqfd **pvirqfd);
 void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
 
+struct vfio_device *vfio_find_device(const void *data, device_match_t match);
+
 #endif /* VFIO_H */
-- 
2.55.0.795.g602f6c329a-goog


