Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6A560F17E1
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=h8vtXMwB
Received: by kanga.kvack.org (Postfix)
	id A11E76B0620; Mon,  2 Nov 2026 10:37:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99B9E6B0649; Mon,  2 Nov 2026 10:37:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72A826B0647; Mon,  2 Nov 2026 10:37:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AE486B0647
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C5EB740100
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:11 +0000 (UTC)
X-FDA: 85390582662.25.EAB8E9A
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0BAAB140005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=h8vtXMwB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3JK7oagcKCIE0nunsxmlttlqj.htrqnsz2-rrp0fhp.twl@flex--vipinsh.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3JK7oagcKCIE0nunsxmlttlqj.htrqnsz2-rrp0fhp.twl@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uG7rE7VtaZNVuMuLVIq/vVqSMDnx3FJ/eSjGr3CevQ8=;
	b=JfxKhhPVIEXkaDFJdRZy5fhoumZaE5vqunZh6NklhtaOpgUaK/Xl6jP2dflZaSvsGQHoeq
	9pv5qvMbVZJJf3AhoIjlKZlM2BRjxwTyvmBe2aAs9uAJV3smYngOxedsTqiBlz4RNPPo9w
	QnS4q1tE86VxZMyRD7CbfSSeAnMWMD4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=h8vtXMwB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3JK7oagcKCIE0nunsxmlttlqj.htrqnsz2-rrp0fhp.twl@flex--vipinsh.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3JK7oagcKCIE0nunsxmlttlqj.htrqnsz2-rrp0fhp.twl@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633830;
	b=xXhAW54f3A+ZaCeAWFVPyZw4OqHGmw6boYrDOuK/nEB966VCj+5ASTY8UBjH32pSWDPfL7
	KpCwuw9+KWDYOzKQiZ3Py5IP8+G8wmp5jQSgeibAqKk5LkLv/ilY5LbVHhrxFqkcgJwP1i
	8h+evS6ijJimPPXqvhXXZuCXKOQC2Po=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e8ba4757baso29580685ad.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633829; x=1794238629; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uG7rE7VtaZNVuMuLVIq/vVqSMDnx3FJ/eSjGr3CevQ8=;
        b=h8vtXMwBw8oRy3noAnuzqgQIbmCvkghCQnaNCCoQobDHJasZtY7me2WzeXgude4jkF
         BJhsXKygieu5jjaZAqgP9c8wfKwi8d8T3jyMlelriQFLIGMknvxzpSWbDaIQBYSX5Xnf
         eYRW2YEvi4dF+qEoiU9jTkAufWI2KVxnFW1Zml6F7ZV4pOcJAlLIQrzrVWHK1vG0PPgB
         RPkBOq//6FChskKKfcUhRFXlj0Yx35KUwuqeUvlYidEZD9cx2Tje48JJiD4aN6zZ67BW
         XrtSdsMqd55KOxTjP0lZSPbpH81W3JqfRi5IhfUCCtYGdgZ+XBLOLoG0TTBGYRXfJCmP
         itPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633829; x=1794238629;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uG7rE7VtaZNVuMuLVIq/vVqSMDnx3FJ/eSjGr3CevQ8=;
        b=J/F5ml9BwhhOl+NrZ4MYmIeKd1aksWU5XG3jHI6xXSa8SuDcgY3KD1NeXs3QlgCfyY
         NnSWcmFobLL+ktu9uOltQjMXiMnZYzxkBawYbNSCj5Jpr30J1eA6AxwBcf0rIns5BbVx
         Bxu+wJ/hI+p2JQcgMo0FR65yiORXK56ZYYmy6DgLnKlVBAtrJ0q+5JfIWMDh6/DT5Ngr
         3gTlfTamZm4zOM7eZigfd5qQd/c3IBo2TpW8z3yyowcq1MnmsFAeePF5FU/Ek4aujhqk
         UXu/k0q7iOXiwRf0x92pMl7HlMxWl3yLvefbRg4aJ9o+EqjlocnpmNb8yOUJbxNZW9b4
         oR/Q==
X-Forwarded-Encrypted: i=1; AKwUvBxRLbwBXf9JO9yUTUYcsI8v5X6v3qEbhG8aKgQGMMmPv/Y7jmBpC862imFNYV7xAgcY8ym+wvzbEw==@kvack.org
X-Gm-Message-State: APuU4Z8ZHTgVitD7rrWevhW7dZ+7AnIZBOz5VBXPRN2bEB2iXpTlxcV/
	EsPa4ZQgKyHDN19lanu28hc2xRJoaPJuddL6E3fIqP0XBsfafZLH7MUBy0Zjnb3ClpSz+FAML/t
	ypq+Ti0Z6fg==
X-Received: from plct12.prod.google.com ([2002:a17:902:d28c:b0:2e5:712c:5c7])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea02:b0:2e9:2a1a:8b69
 with SMTP id d9443c01a7336-2eb364f1986mr88587545ad.55.1793633828399; Mon, 02
 Nov 2026 07:37:08 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:37 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-9-vipinsh@google.com>
Subject: [PATCH v6 08/27] vfio: Introduce vfio_find_device() helper
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0BAAB140005
X-Stat-Signature: 6eocew1m8ky78xkp414krkacc7xikgtx
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633829-162137
X-HE-Meta: U2FsdGVkX18Qc1BKtZl40IHXbSnTVN14HS9tU7hGAv928N34Gbl1kh+9vQFTwdv3wWHnuqBa1EEKlTxyeBzf9g268cTbsBzNFP9d7ZzoPupRT0B5i5T/xmpuV2xRBcOO+NPHx5O9BijKeaoYIeExWFcAlKkNQMNJXZaH+BNlY073BwMQiVEagzJJbHF0vLCD6SIynIpEKmEKKgGoJ1MHXlWyzbS9GGUspIaw4iJg30wpt1AplaMQJM+fts9Kq2FBnrC6NuE86xfqfg0FqTXlo7K+MxBgrMxCVV8hEobA8UiDFIpBcztrfvALl6IA3kvAQLDmnJa9TOCIQbKFBxqzPYsn4ssjVXW61LrJribc3JkOvx9EiF7UnpMFRCLzVIwHYgVnt3jJaeeiQvsAiR7B8YpNUAzRl/vcklwIRbIrwvVyPixODo7JGcbCt7TIRyBDAhUR8iQxFmP7e7BmtnQEF45jVmmaXvincLHsyUcgZSU0zEbyl0DKN9s6VZtrBFJQrxb3P7YpxlKs/n7J8qZ3WooN0WnFK6FPDEsaVh8/f98yNERkYZbQKk2YHCt0wHyPUGsxii1a0RWsOcuWjU5D1Oy7A2GDtuEgnEalwkYzSFB1x+DoDFsa9SteNt/SA2/zkL1lcMxNKYdoLxwBuz/ycZCbhaeh2Wr7aRkhRsu3gE2UGykYhTlSZh2LrkiB4s/58WRhBJ4u7DyBTPj0kBAPfe0kdjNa65Z2QTsWshwhCza0ssFKVwvv1RJ2ca6ZsGAaxe16Fej5GRnVFZLaGqj9WASg082VrEBIpULxT9Np5B3a1iyqsHoXCxU7A50CC+FX64uTEoYz8Uf102K8cWzdU2PoUCCwFjwmgPHjt1rkrbJhSB2F7FRVNAvicOJbIsknIxj+wWZUwleFKYea1wS9YV/G82Ix3knNJZHpKR/KKnPKe3hio4GjzG93WCclUXeDF5fU84bb8MoZsyufnbE
 ByFg1ObU
 32NSgmkkhLFo4AnBIj1S+4Exxs8DmbJAIsD37EehyRXB4N+Hj9RvrNlxy2RgRmJtXJYTSF0Vtm+PPC08tPlrO0hlRgLF8dd7WaqKcfDLaKLNRQpQtzHmwTOyiy1+1QRMqZHLVMjtNsbkxcW4GrYCFbOQz7t/yWfieSiUgRQqjHq5iZ5sb0OrtqZxRhL9XWF/fZvJen/HgjDq0uCoIMXgd86R2n4Px8LCqgq8McSkRDkqrbL3I3zksTkkp1IxYOZGM2NY2VAQjV+TJyoKi9vYovcVGrFMbwA7zyFRiNeEA3c/QFRrLbmu26W+wH5n7PDCj5G1u7/Q/llwi5we5wjO5BYMgOJEjEta++8PTajQdLhBxB2rW9eUMXi1r3oV38lGszDRh3Ker8llUmBDlYHUXfPS15/w/fJmA0IBdiJIr3rGFCvFU2EwfHtiBkHz3VeTKK68eVWmzGzkjB9f3+KMAPDRbVUQuH6/3Fn60tGB5Wodt4jVFTuUlGfaMlOQKFLHb5AbTvlWcwTvVtBzJR8JXnSUy19JM9+P1EM7ApvFsoxtHB/ihOkV9RrXvODbuoKoJWjk+oSQ+3epdMKHvnZd5e2bd6gRtF9GnVDCw/QrdvlVuJcz9ej94+DReKxZ16ihKSz0POcI2m+3SWm/RfXBOmdZ7aNorWy7tIfws8NC3TINbs/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 291460102cd1..00b3bc0c5339 100644
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
@@ -383,17 +384,20 @@ static int __vfio_register_dev(struct vfio_device *device,
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
@@ -1845,6 +1849,58 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
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
index 3cfbf1d73479..1c1e41de49b3 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -441,4 +441,6 @@ static inline bool vfio_file_is_bound_cdev(struct file *file)
 }
 #endif /* IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV) */
 
+struct vfio_device *vfio_find_device(const void *data, device_match_t match);
+
 #endif /* VFIO_H */
-- 
2.56.0.317.g454f8302e1-goog


