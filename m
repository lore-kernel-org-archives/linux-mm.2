Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC5AFED2F6
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 09:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1B396B0089; Thu, 12 Mar 2026 05:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B87C6B008A; Thu, 12 Mar 2026 05:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BAE66B008C; Thu, 12 Mar 2026 05:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 77E1D6B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:12:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2401CC30D7
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:12:20 +0000 (UTC)
X-FDA: 84536844840.07.A359D0F
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 552B11C000F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:12:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YtBfQLkr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of seven.yi.lee@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=seven.yi.lee@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773306738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sZaIDNiBTsN9aL3bUzrKNeXVeD+/QF1qmzkDXQhoczs=;
	b=pXpbRLilfvf3MHiTrpJCF6KDXqXWX6nIC0O0iqaAtBpy8gGJLmV3P6qkIqX/qPAUmv6TCd
	WvKJgPUYqcQaoH9wiy1ub0l+QkSQ6XNCeLzHP2RUlm45j/I5t7dsYzCQGdUTpGTU8cj+Dg
	KV56P3IWhnUeUx7ocvCA2z1eMXMN7N8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773306738; a=rsa-sha256;
	cv=none;
	b=szZx0PfS+9yfciOqli0F9DDJFYuAiCUxPMSl8mfMLAipfPdcOb83C6SY0LcwsaLxqAbX7L
	VWdwHU7z7Au3L4PW6UCLMKQ0cBbd3IOx4djua0CU1TwalAc/yLtWU203Hvzd6fETBVxBjy
	gjtuSTv4w1K4tDHcctQTMuCpZxcLrAY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YtBfQLkr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of seven.yi.lee@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=seven.yi.lee@gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8298fad2063so469999b3a.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773306737; x=1773911537; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sZaIDNiBTsN9aL3bUzrKNeXVeD+/QF1qmzkDXQhoczs=;
        b=YtBfQLkrKOKq6daMr1Cbr0sJ8j+Z45aJDRelWflqC1A3SwwfN/thcFP0TmEwKI2Auk
         /jtuAnMdloJh7jQa9zBGWNNpSHi2k6Nm5V3Ca+uMGc/MtJbGKGRWOBQrsPxbiorlO1FW
         CxCpRyquhX0nuNyS+b5BitzRClyGad3/zlXT9JklO3yHd9ui92qIrOn+glzJR1RcW+Wr
         /OruPdaFtQDDaEcPXgbT/7sDcsT25o7uyTIygu9liL1l6gFJpg8T2AarVA+CWpdrQcZk
         OADfhuzdyEFCnCIUH+pmKaZk7Ol/sgqTin5+RlRHbm+K7dxgMw/rGZU5ANvusH7ErACp
         gWDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773306737; x=1773911537;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZaIDNiBTsN9aL3bUzrKNeXVeD+/QF1qmzkDXQhoczs=;
        b=oix/iznmJAzStV9qLXQ/ZGPKNIeULhqYMCWWrgaQOJpcgjfvHPYQc7JQQCWtI9LRVQ
         P8/9mj6zCd0O6n6gb/pb+A9zNcl5VJh+pY9RMpDhJ9/DQ9bUMUxcVKRd2LibbMVXpn4l
         N4ud81sCx7LnBRZZu0nlo73IRp4nhC+GaNFIT/zEjeETb6xd8ii3mQL0r+MQteW68ltk
         5MCO7MeyhAKNkRr/KjMTbrIfr699UNcfGF41alW1HEvZl6ByMYDcf9I3baXzD6lJ1wrC
         Mr+FrfbnzF5mvzOcuH8uQdily91BHUeUMXZNjWva8KbyUerUtVjYo3xXIzEc2TKjqwvr
         nyiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNTny8hH92omLsx+8FWlWPaGiwBh/RoTJhQjbeNIkD05FhDt7jQXJpanAZ2inGtiGx9fars+678g==@kvack.org
X-Gm-Message-State: AOJu0Yy6adRVMa/P5latxBxf2S77yCDsiJyGyPTnGa2gRJuOlJBUs4qL
	h7R/mPxcIi0W9p2vvakDG/JipU8QPaFsZY13Gv1EN9d1PrPEIZrHXPBv
X-Gm-Gg: ATEYQzxt0l8lY3UciGYZvBcg6Ti0A5I0PsHQhB0osVt7K0L++TRJqi1SVPkKz2f6ZcV
	AV2EnozxENht/NGzobCMqqhPJYuZ2zOictYgzRcVEipTi/8Bg0bFs6KXL7yMpULp8TiLJwWln2c
	7o0mj0087hCd+RCfQwUfpnynkwBL2psZJKpPGj+kYzzb0rHV5wAtUZ6ywqzPwbJ5jD3VvRZqU/u
	wWACYNKGIhgU5XwFfokrCSybfvh5MH9sg7V5LhgmPVaVii6+giQv90EcmNZehQRTboE6i9i5wx0
	0VgwLIL9cV5bRiUEAmqHkV5DUPWTh8/jgvDxytNfVBzi0YWXEWk2YVuYsty2TMzrh4QybUUH8gC
	bHw6+XyVZLvyIoLyZ2RhP6nfBkEKhwMrjQQyHG5ITXBhAI+KR+eattVSo/i0fuPZBF0LHBlRvhO
	oN1y+U0lyXz68kBJ27XehBz9f7tFlIBquKPngyzjXnUXQB1AWPwr380YZVczxDIP0Xkwh7
X-Received: by 2002:a05:6a00:ab08:b0:827:32d7:668f with SMTP id d2e1a72fcca58-829f6e7897amr5024122b3a.6.1773306737021;
        Thu, 12 Mar 2026 02:12:17 -0700 (PDT)
Received: from Yee-680G4.lan (n11212047001.netvigator.com. [112.120.47.1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a0734199csm2299470b3a.36.2026.03.12.02.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 02:12:16 -0700 (PDT)
From: YeeLi <seven.yi.lee@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	dan.j.williams@intel.com,
	ying.huang@linux.alibaba.com,
	linux-mm@kvack.org,
	joshua.hahnjy@gmail.com
Cc: linux-kernel@vger.kernel.org,
	Jonathan.Cameron@huawei.com,
	linux-cxl@vger.kernel.org,
	dave.jiang@intel.com,
	yeeli <seven.yi.lee@gmail.com>
Subject: [PATCH] mm/mempolicy: add sysfs interface to override NUMA node bandwidth
Date: Thu, 12 Mar 2026 17:12:07 +0800
Message-Id: <20260312091207.2016518-1-seven.yi.lee@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 552B11C000F
X-Stat-Signature: zs1nkoybfc7z61atowjxxmys9en7ib3d
X-Rspam-User: 
X-HE-Tag: 1773306738-181820
X-HE-Meta: U2FsdGVkX1+lyJn/i4ZEGJi9A+Z3FJ4rdXJnvVKsfTDU+3KDAeL5yEB/SHfI43PhcB1LgbWUqQ/N4vavatyeP0hO/dkhZgBKZQFUHG5dBtnGy5+3paWHhQwkzrKd+dF5c6HoW2tDO0sZJGup1br/0Dog94t/lhF9EA2wgfXK224gyVBM8gwtXLx6VXCfujBjqQJKwgznjMMwD47wSmHQ6PoEimgCCkn1cP3//yHmcII7Xx9YuX5PFa9DI36+bUInLswdHnbxrqpJ7xdFmJUy8d7wb9dnYCiRRN+rLthO4Jbifopa3AnOzWpurY5BxuButnWHkhboPZZAdg6x4EHgTqpjTiHpOg+fdUDecnYu8V2E3akfN0aaapUuuK/ZxKT3DnVPfwMBm4hiAM66Q8n/uotycDlHoV4PnRVxy8jDhL86uwCnQBe0IaenRAwyZDUMYyJ65ihElXVtbdnUQewaHbxNd7T7XLFjLhEFrJN0csbhmVJGcTHPP9i+ZLRLkW5qDCjYdWekoZEaSh/TjmH6DGiODyIF4u/Ln+ieyxEuz7dhNxEjbXss9aSkE1pZrcqQ/OdLZnxitvWurWOU23z5aB8oGT7u+APmRUVM+ZQw0RD/7bmBCDpa1E4u3BIkQ5sHeR73IAbO6uc+ckAPJTpU7dfOXKq83kVdujDkaIzWQTjaR9S32ZCAeRQE6sxuFcJROT9/yhiJpP7rbhKEACd1TxswlQMhUdhCX34DPxN2daRe2f8Vkr/icN+yD+NU/ifH0IzFd6V9uxS94i86btIdd5UqMUMo0mFDft2TuWi6+FhopMrY9x0/21Io0Fx3wx0/hAJohbM4YuYCBCm76tkKX0WGR8nWoKDP2aAHT/ExbAm5Igk4kvN7uWByLHMv/qG9qlCiMvyHfk3lDOAmBZB936/jxd2mYKfA+AxN3oCpMFTyItSuse/wxoP/1CuvxkKD8Ua4vZ5jMlnGMr3QUYm
 qSPnLuil
 WCmUO0Jv0gEnYK08T9muEJUEFS6IooadYIqgP14qBtEkeTmuheaKzrczEPrV1EiSUNm1ASw9/3Qe/3hMrY6zT0zELZ7XV/aRrd3eDVm1qjxzIY916FgFp6GPQEm8YEHGTRf51WBow3d4JuKzETk17MZ4wHi93XCYQ3kej34Iu0lW+UukPELk/ncqKgrbJ0UaVsiH+J6eUSXlcE7XaZIUYPCIHdV2uArDldoB3+9F6onCkAyGGgRppLTmO5aBCKdCB58LvL7cl0Y4mNVJdh9aVM0QAjPj0uFJND8GK/zJ2PEY/rn2cEKaYQaAYdXQmx9ukLYQGED3ubSY4K9L3Mq1zfurayCVguXJAIs9+QLeyHQ3vQ9Pqq5ZXKFZWPn7FJ9eiQonl5XtF7dv5cS5SFMILt1PPbd2kBSy+fZifhieNmTH085FvdxkKgW3RE8x9dytdoXXGnPhkSINnJ1Lx5p1iSNws2X1MipbqaKezNmVSSAFw8n9DUHiQwqe7KEBR+4ZkBXshvWxjhKAf03rLEQDathb8L2Iy9AB7jRRfZPrf5cnBVKmS9fOhdANECTIvymXQROSuPsk+sJ+25t9/BBuQb+QOBo2N4cbvNx5YTkMeRpq2JR2PCMglJQ5l1l2BBiaAMFz8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: yeeli <seven.yi.lee@gmail.com>

Automatic tuning for weighted interleaving [1] provides real benefits on
systems with CXL support. However, platforms that lack HMAT or CDAT
information cannot make use of this feature.

If the bandwidth reported by firmware or the device deviates from the
actual measured bandwidth, administrators also lack a clear way to adjust
the per-node weight values.

This patch introduces an optional Kconfig option,
CONFIG_NUMA_BW_MANUAL_OVERRIDE (default n), which exposes node bandwidth
R/W sysfs attributes under:

  /sys/kernel/mm/mempolicy/weighted_interleave/bw_nodeN

The sysfs files are created and removed dynamically on node hotplug
events, in sync with the existing weighted_interleave/nodeN attributes.

Userspace can write a single bandwidth value (in MB/s) to override both
read_bandwidth and write_bandwidth for the corresponding NUMA node. The
value is then propagated to the internal node_bw_table via
mempolicy_set_node_perf().

This interface is intended for debugging and experimentation only.

[1] Link:
https://lkml.kernel.org/r/20250505182328.4148265-1-joshua.hahnjy@gmail.com

Signed-off-by: yeeli <seven.yi.lee@gmail.com>
---
 mm/Kconfig     |  20 +++++++
 mm/mempolicy.c | 148 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 168 insertions(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index bd0ea5454af8..40554df18edc 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1441,6 +1441,26 @@ config NUMA_EMU
 	  into virtual nodes when booted with "numa=fake=N", where N is the
 	  number of nodes. This is only useful for debugging.
 
+config NUMA_BW_MANUAL_OVERRIDE
+	bool "Allow manual override of per-NUMA-node bandwidth for weighted interleave"
+	depends on NUMA && SYSFS
+	default n
+	help
+	  This option exposes writable sysfs attributes under
+	  /sys/kernel/mm/mempolicy/weighted_interleave/bw_nodeN, allowing
+	  userspace to manually set read/write bandwidth values for each NUMA node.
+
+	  These values update the internal node_bw_table and can influence
+	  weighted interleave auto-tuning (if enabled).
+
+	  WARNING: This is intended for debugging, development, or platforms
+	  with incorrect HMAT/CDAT firmware data. Overriding hardware-reported
+	  bandwidth can lead to suboptimal performance, instability, or
+	  incorrect resource allocation decisions.
+
+	  Say N unless you are actively developing or debugging bandwidth-aware
+	  memory policies.
+
 config ARCH_HAS_USER_SHADOW_STACK
 	bool
 	help
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 68a98ba57882..0b7f42491748 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -226,6 +226,7 @@ int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
 
 	bw_val = min(coords->read_bandwidth, coords->write_bandwidth);
 	new_bw = kcalloc(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
+
 	if (!new_bw)
 		return -ENOMEM;
 
@@ -3614,6 +3615,9 @@ struct iw_node_attr {
 struct sysfs_wi_group {
 	struct kobject wi_kobj;
 	struct mutex kobj_lock;
+#ifdef CONFIG_NUMA_BW_MANUAL_OVERRIDE
+	struct iw_node_attr *bw_attrs[MAX_NUMNODES];
+#endif
 	struct iw_node_attr *nattrs[];
 };
 
@@ -3855,6 +3859,128 @@ static int sysfs_wi_node_add(int nid)
 	return ret;
 }
 
+#ifdef CONFIG_NUMA_BW_MANUAL_OVERRIDE
+static ssize_t bw_node_show(struct kobject *kobj,
+			    struct kobj_attribute *attr,
+			    char *buf)
+{
+	struct iw_node_attr *node_attr;
+
+	node_attr = container_of(attr, struct iw_node_attr, kobj_attr);
+
+	/*A Node without CDAT or HMAT*/
+	if (!node_bw_table)
+		return sprintf(buf, "N/A\n");
+
+	if (!node_bw_table[node_attr->nid])
+		return sprintf(buf, "0\n");
+
+	return sprintf(buf, "%u(MB/s)\n", node_bw_table[node_attr->nid]);
+}
+
+static ssize_t bw_node_store(struct kobject *kobj,
+			     struct kobj_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct iw_node_attr *node_attr;
+	unsigned long val = 0;
+	int ret;
+	struct access_coordinate coords = {
+		.read_bandwidth = 0,
+		.write_bandwidth = 0,
+	};
+
+	node_attr = container_of(attr, struct iw_node_attr, kobj_attr);
+
+	ret = kstrtoul(buf, 0, &val);
+
+	coords.read_bandwidth = val;
+	coords.write_bandwidth = val;
+
+	if (ret)
+		return ret;
+
+	if (val > UINT_MAX)
+		return -EINVAL;
+
+	ret = mempolicy_set_node_perf(node_attr->nid, &coords);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static int sysfs_bw_node_add(int nid)
+{
+	int ret;
+	char *name;
+	struct iw_node_attr *new_attr;
+
+	if (nid < 0 || nid >= nr_node_ids) {
+		pr_err("invalid node id: %d\n", nid);
+		return -EINVAL;
+	}
+
+	new_attr = kzalloc(sizeof(*new_attr), GFP_KERNEL);
+	if (!new_attr)
+		return -ENOMEM;
+
+	name = kasprintf(GFP_KERNEL, "bw_node%d", nid);
+	if (!name) {
+		kfree(new_attr);
+		return -ENOMEM;
+	}
+
+	sysfs_attr_init(&new_attr->kobj_attr.attr);
+	new_attr->kobj_attr.attr.name = name;
+	new_attr->kobj_attr.attr.mode = 0644;
+	new_attr->kobj_attr.show = bw_node_show;
+	new_attr->kobj_attr.store = bw_node_store;
+	new_attr->nid = nid;
+
+	mutex_lock(&wi_group->kobj_lock);
+	if (wi_group->bw_attrs[nid]) {
+		mutex_unlock(&wi_group->kobj_lock);
+		ret = -EEXIST;
+		goto out;
+	}
+
+	ret = sysfs_create_file(&wi_group->wi_kobj, &new_attr->kobj_attr.attr);
+
+	if (ret) {
+		mutex_unlock(&wi_group->kobj_lock);
+		goto out;
+	}
+	wi_group->bw_attrs[nid] = new_attr;
+	mutex_unlock(&wi_group->kobj_lock);
+	return 0;
+
+out:
+	kfree(new_attr->kobj_attr.attr.name);
+	kfree(new_attr);
+	return ret;
+}
+
+static void sysfs_bw_node_delete(int nid)
+{
+	struct iw_node_attr *attr;
+
+	if (nid < 0 || nid >= nr_node_ids)
+		return;
+
+	mutex_lock(&wi_group->kobj_lock);
+	attr = wi_group->bw_attrs[nid];
+
+	if (attr) {
+		sysfs_remove_file(&wi_group->wi_kobj, &attr->kobj_attr.attr);
+		kfree(attr->kobj_attr.attr.name);
+		kfree(attr);
+		wi_group->nattrs[nid] = NULL;
+	}
+	mutex_unlock(&wi_group->kobj_lock);
+}
+#endif
+
 static int wi_node_notifier(struct notifier_block *nb,
 			       unsigned long action, void *data)
 {
@@ -3868,9 +3994,22 @@ static int wi_node_notifier(struct notifier_block *nb,
 		if (err)
 			pr_err("failed to add sysfs for node%d during hotplug: %d\n",
 			       nid, err);
+
+#ifdef CONFIG_NUMA_BW_MANUAL_OVERRIDE
+		err = sysfs_bw_node_add(nid);
+		if (err)
+			pr_err("failed to add sysfs bw_node%d: %d\n",
+			       nid, err);
+#endif
 		break;
+
 	case NODE_REMOVED_LAST_MEMORY:
 		sysfs_wi_node_delete(nid);
+
+#ifdef CONFIG_NUMA_BW_MANUAL_OVERRIDE
+		sysfs_bw_node_delete(nid);
+#endif
+
 		break;
 	}
 
@@ -3906,6 +4045,15 @@ static int __init add_weighted_interleave_group(struct kobject *mempolicy_kobj)
 			       nid, err);
 			goto err_cleanup_kobj;
 		}
+
+#ifdef CONFIG_NUMA_BW_MANUAL_OVERRIDE
+		err = sysfs_bw_node_add(nid);
+		if (err) {
+			pr_err("failed to add sysfs bw_node%d during init: %d\n", nid, err);
+			goto err_cleanup_kobj;
+		}
+#endif
+
 	}
 
 	hotplug_node_notifier(wi_node_notifier, DEFAULT_CALLBACK_PRI);
-- 
2.34.1


