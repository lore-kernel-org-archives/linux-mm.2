Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E015FD31A26
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 08:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3D86B0099; Wed, 14 Jan 2026 03:52:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A1F6B0098; Wed, 14 Jan 2026 03:52:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64D786B0099; Wed, 14 Jan 2026 03:52:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 539466B0096
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:52:49 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 10A048B9DE
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:49 +0000 (UTC)
X-FDA: 84329954058.12.26024E3
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 436D6C0013
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pTm6mwBp;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768380767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aGjo3d8od0EJeDwSRFttWxrOsN7h7xRi4Y20WwxuEh0=;
	b=VS08ysFt9YMzRfvWQdY9/JloFwqBlrSyCBOGl0fFdLJf5I1/WEOwbspU4zFa8ZZsMslLe4
	zf3S1TnZ4AbQhMAYsQlVRWoRvLYZbgl6Oe5VuAzvT0xgkHbxqlcECb2HKaDIALwzEOfSdr
	WFDP2RFgYqqsgDCCnaQP2hdZtQCZiN4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768380767; a=rsa-sha256;
	cv=none;
	b=Ue7Ys0xbpeh2sO6uszel1gdptrl2IZT2FnrYRQAj/dUVL11Bu7uKcN+2EMVuNOw75AvaJW
	Te86FAOeJJ6m17P6xMyFMVt313hEaeFN50f9SKOUUfUEhzeCO/3T7mJzebjUMvtZjy502S
	4l5aoqz90cPgr62Nf9H0EpEUOnU7GXg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pTm6mwBp;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ed66b5abf7so7458081cf.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 00:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768380766; x=1768985566; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aGjo3d8od0EJeDwSRFttWxrOsN7h7xRi4Y20WwxuEh0=;
        b=pTm6mwBpo6lIluv8QrCXhyG5EZ7/xGKHBK6LOMVCzdUhpa3GmT3BE4FAXqbVpbam/s
         4MxkC5Tp78Wiu07CP01XJFuemdD9ntkQHUOgFsvb0PvFL4fAtxD0bwf4L844c7Cg5vxx
         L028spRyhEtnrhjl4xLl0IS/+xq9fXTuRQ4WPe7q7aW1tP9/KgbN1xBCe2JYcQaNUClD
         oCKII2NEnMLBsHne2wUyLMc+pp33ElLyZ6c4/1NQjxgUL4l27np6QZkrVluphiQLyzUg
         WV/n+Lts0AFokB+5bW7lT4HLrZKtrBpAfZlg874SQPJT6lIPfHsOoQLgsNrilNQHchmH
         y7fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768380766; x=1768985566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aGjo3d8od0EJeDwSRFttWxrOsN7h7xRi4Y20WwxuEh0=;
        b=YPvbqrsn6IfMQH1UkDLPNgCCqrKbyHkQtiMT/02hwPUivIcZkva3wNJX3F4DWybY7v
         zhGmLLuXz1/0140hUvY+qn8yAtLL9e9zpBPzz0HNQM7KDIRKAWykdoXyjocM5Vg5Sr2N
         vWs9DQ2Ix53Y+rtkDFj8D6QHLrtIUz2EM1qGF0GPj9Qh/Y5/c+a5XLz4nBwwhU2sgSju
         GJGUiLnQX6jrEur7HQbpAIPWcF/uJ/6sD1Jp1Ec5aramtpvZzHiTMetkl+azJs2pUj1o
         jyhYi836FicpTKB9iT34Kgu2gnDKnafVLd7eCMYjvtpL0bejm0R7yYvqy/cr2OJVbWXl
         CjXw==
X-Gm-Message-State: AOJu0YwaIhdoYcMyB30Iw6laopdW++B9qbzsimP7vxNLGZ6OuLOiRe+r
	/mV3do3zYKTZuB6ts3zio56A/srt1wDJfg1vHmjuQ3A6z2eNPg/6BsMw0O2sbqI5a50Cxg0qtK2
	G/l8DFvM=
X-Gm-Gg: AY/fxX5IpKPbrmBkbaZMPs4nXQyN500oBDU/xD3cP5HkJlP4uB5r9yYSmklHxQXFTAO
	7JgNb1Wr1yCDynwq2vzYvoyPBSvoYmAzOHjVXOc2LskDb8zsYNQGJNIcYp4oGBxA4tWNmXvWnwX
	8821UBg2UiPZe+cBeKMZAocS5mWdXFhOppXbE44/pxc4AXNH81+4HOPOeaeM4a7XbbwY6Srnsbn
	R4sQqVB5YKJEJJbFvpjbn9oVv3Y9uzOD60OTFrscvs6iXlSJx/RYJ/9EFiC6uF1DEd5fkLoTJhc
	5qqxs3Xob3oifGzCliYL2iXcUsgc/zMl0E6rNXoTOIhRRwVU0NIeo8nJdzKcFm1q4D9zVPPl/Kr
	afoBwHiH+kJ58SB8nHFcrz+kSfz4FZ3lypUnWAhNUwUEupfLvZ7P5C0XUiRkbBpT9syvSy7iafU
	tYSdJnmx2gf9iQE+IprAQilYxgJCBvMstiE480VFU4wsLHmqvDxNUD2MSTlAjTcRWlRhHsuXmRl
	SM=
X-Received: by 2002:a05:622a:4087:b0:4ff:b0e0:7b66 with SMTP id d75a77b69052e-501487decb6mr24730871cf.21.1768380766023;
        Wed, 14 Jan 2026 00:52:46 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148df8759sm10131931cf.10.2026.01.14.00.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 00:52:45 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kernel-team@meta.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	david@kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	osalvador@suse.de,
	akpm@linux-foundation.org
Subject: [PATCH 7/8] dax/kmem: add sysfs interface for runtime hotplug state control
Date: Wed, 14 Jan 2026 03:51:59 -0500
Message-ID: <20260114085201.3222597-8-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114085201.3222597-1-gourry@gourry.net>
References: <20260114085201.3222597-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 436D6C0013
X-Rspam-User: 
X-Stat-Signature: jmpuifeaawwwp3tpdye8yznosr1oboa6
X-HE-Tag: 1768380767-954411
X-HE-Meta: U2FsdGVkX1+Rho/ukRC7JyQdGU73b0Kn59HaXrHMpBLMtv6VoVgkYb0qZmLw3iO4k3bL//nFxeqw/fonbjAs9hcGSnbsvdy4jopRhiGxzpWSnb9RD2IL5h3IQ1D44qIXJSAsQi8aFCeJAUPfjJe1jTYbvR/KJoVmbH60HuQPPFMsWsbdhztoFuCs0tM5t0u9gtB4lfjQ5WgEVRqsvfqh/QN6YbSDdeUz60SHZmLI9nCtbLcRQ31zOwvWNVEQiZvw6wXMRWtDuEYeQb4bybnUcszPWwUj+ZbjWV63COffsK+BVHnTDSz/VEEpTW3EWSmSlXpr+WaD48F3FruCqlQAtUKO99XoAiGK6NZm3vm5hDLsxOTCScRDWLwj1mwksDBTSrzviJWUfOxhf0bzpnL8N+7Q9P0n1o69rjAw6PBHDUnSztPkaODSzW7OggD2Sf0Z5IeFtKivd7ckEkzf7IFHzitMMKhB4xwbbgrOX1wDvdU/cMFNjdhQHT/y0pYLF5RAkl4torFUoMVrske8If0zkB0ZvIO6q25VbdCgQa6biY3hjdimaeTGaaRCduVcJEqJa9HNbNw5nGvDM8f1bGC2/6/ssHSmbnzMxUVL8lS+/Et0g/KEK61G17SuNIf3EKPgS1tbcGAdi6ZtDTd8Cu7GzS+b5I98KshS4Q6HN1jMYdH6G1HxA/HEuxKFGWn2VHkGqjSwEZ2sabbUO/ChTrE2qbL1u2mCm+GQ7FUPsqBndfxrdobiMySIzILEazcIoBg+nl1PGvJcG3mc19DdMFnDP8QWnLIuiQyRc2T1a7SvYCEZ5pQ5vc28u0arCqGHcWBGdRW3J5W56isKxiKVqJ/p6brr8SNAQTb+VOrz9gMI8/zSS8alTk7zg94sCaaTBJKPD2hNEoWDKUJAtoeAQ11dXb68eLU6fdTw6grqgRG05NCgfExaDakIWIJHx4Q7SZH40ZLTe6qxNp+U29Xt/71
 nynGmDuM
 +4an8gUKivwiEnb9qJrvhBtGcg60r44TsrdR6UkBCvhDKPJl4DZroPmCraMUuzpjSxy9dHyJin1QHHNtqkoljC016SS+u3+yUs4jbz0kgLv8CqU/bFddfdna26iuXBSvfXW37E/VDTZvzArXbuTNbNNgbiOnDwo8A5B8y3jc0Ek1xZEZH69HTjEgp5l+ceDrbxJxpkPMdpEa6q+GmPi7nVk3aaezO/Qo0A1cnHrig9XTM84WW6adPvWPynP8NqRaK9tj/KoRL6gkwkiNuN6c24E0Tfqs2dOCfsfriqrZWZ13f5xEtwfUSur6bBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The dax kmem driver currently onlines memory automatically during
probe using the system's default online policy but provides no way
to control or query the memory state at runtime. Users cannot change
the online type after probe, and there's no atomic way to offline and
remove memory blocks together.

Add a new 'hotplug' sysfs attribute that allows userspace to control
and query the memory state. The interface supports the following states:

  - "offline": memory is added but not online
  - "online": memory is online as normal system RAM
  - "online_movable": memory is online in ZONE_MOVABLE
  - "unplug": memory is offlined and removed

The initial state after probe uses MMOP_SYSTEM_DEFAULT to preserve
backwards compatibility - existing systems with auto-online policies
will continue to work as before.

The state machine enforces valid transitions:
  - From offline: can transition to online, online_movable, or unplug
  - From online/online_movable: can transition to offline or unplug
  - Cannot switch directly between online and online_movable

Implementation changes:
  - Add state tracking to struct dax_kmem_data
  - Extend dax_kmem_do_hotplug() to accept online_type parameter
  - Use add_memory_driver_managed() with explicit online_type parameter
  - Use MMOP_SYSTEM_DEFAULT at probe for backwards compatibility
  - Use offline_and_remove_memory() for atomic offline+remove
  - Add stub for dax_kmem_do_hotremove() when !CONFIG_MEMORY_HOTREMOVE

This enables userspace memory managers to implement sophisticated
policies such as changing CXL memory zone type based on workload
characteristics, or atomically unplugging memory without races against
auto-online policies.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c  | 167 +++++++++++++++++++++++++++++++++++++++++---
 mm/memory_hotplug.c |   1 +
 2 files changed, 158 insertions(+), 10 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 30429f2d5a67..6d73c44e4e08 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -44,9 +44,15 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 	return 0;
 }
 
+#define DAX_KMEM_UNPLUGGED	(-1)
+
 struct dax_kmem_data {
 	const char *res_name;
 	int mgid;
+	int numa_node;
+	struct dev_dax *dev_dax;
+	int state;
+	struct mutex lock; /* protects hotplug state transitions */
 	struct resource *res[];
 };
 
@@ -69,13 +75,15 @@ static void kmem_put_memory_types(void)
  * dax_kmem_do_hotplug - hotplug memory for dax kmem device
  * @dev_dax: the dev_dax instance
  * @data: the dax_kmem_data structure with resource tracking
+ * @online_type: MMOP_OFFLINE, MMOP_ONLINE, or MMOP_ONLINE_MOVABLE
  *
- * Hotplugs all ranges in the dev_dax region as system memory.
+ * Hotplugs all ranges in the dev_dax region as system memory using
+ * the specified online type.
  *
  * Returns the number of successfully mapped ranges, or negative error.
  */
 static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
-			       struct dax_kmem_data *data)
+			       struct dax_kmem_data *data, int online_type)
 {
 	struct device *dev = &dev_dax->dev;
 	int i, rc, mapped = 0;
@@ -124,10 +132,14 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
 		/*
 		 * Ensure that future kexec'd kernels will not treat
 		 * this as RAM automatically.
+		 *
+		 * Use add_memory_driver_managed() with explicit online_type
+		 * to control the online state and avoid surprises from
+		 * system auto-online policy.
 		 */
 		rc = add_memory_driver_managed(data->mgid, range.start,
 					       range_len(&range), kmem_name,
-					       mhp_flags, MMOP_SYSTEM_DEFAULT);
+					       mhp_flags, online_type);
 
 		if (rc < 0) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
@@ -151,14 +163,13 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
  * @dev_dax: the dev_dax instance
  * @data: the dax_kmem_data structure with resource tracking
  *
- * Removes all ranges in the dev_dax region.
+ * Offlines and removes all ranges in the dev_dax region.
  *
- * Returns the number of successfully removed ranges.
+ * Returns the number of successfully removed ranges, or negative error.
  */
 static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 				 struct dax_kmem_data *data)
 {
-	struct device *dev = &dev_dax->dev;
 	int i, success = 0;
 
 	for (i = 0; i < dev_dax->nr_range; i++) {
@@ -173,7 +184,7 @@ static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 		if (!data->res[i])
 			continue;
 
-		rc = remove_memory(range.start, range_len(&range));
+		rc = offline_and_remove_memory(range.start, range_len(&range));
 		if (rc == 0) {
 			remove_resource(data->res[i]);
 			kfree(data->res[i]);
@@ -182,12 +193,19 @@ static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 			continue;
 		}
 		any_hotremove_failed = true;
-		dev_err(dev, "mapping%d: %#llx-%#llx offline failed\n",
+		dev_err(&dev_dax->dev,
+			"mapping%d: %#llx-%#llx offline and remove failed\n",
 			i, range.start, range.end);
 	}
 
 	return success;
 }
+#else
+static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
+				 struct dax_kmem_data *data)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 /**
@@ -288,11 +306,117 @@ static int dax_kmem_do_offline(struct dev_dax *dev_dax,
 			continue;
 
 		/* Best effort rollback - ignore failures */
-		online_memory_range(range.start, range_len(&range), MMOP_ONLINE);
+		online_memory_range(range.start, range_len(&range), data->state);
 	}
 	return rc;
 }
 
+static int dax_kmem_parse_state(const char *buf)
+{
+	if (sysfs_streq(buf, "unplug"))
+		return DAX_KMEM_UNPLUGGED;
+	if (sysfs_streq(buf, "offline"))
+		return MMOP_OFFLINE;
+	if (sysfs_streq(buf, "online"))
+		return MMOP_ONLINE;
+	if (sysfs_streq(buf, "online_movable"))
+		return MMOP_ONLINE_MOVABLE;
+	return -EINVAL;
+}
+
+static ssize_t hotplug_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+	const char *state_str;
+
+	if (!data)
+		return -ENXIO;
+
+	switch (data->state) {
+	case DAX_KMEM_UNPLUGGED:
+		state_str = "unplugged";
+		break;
+	case MMOP_OFFLINE:
+		state_str = "offline";
+		break;
+	case MMOP_ONLINE:
+		state_str = "online";
+		break;
+	case MMOP_ONLINE_MOVABLE:
+		state_str = "online_movable";
+		break;
+	default:
+		state_str = "unknown";
+		break;
+	}
+
+	return sysfs_emit(buf, "%s\n", state_str);
+}
+
+static ssize_t hotplug_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t len)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+	int online_type;
+	int rc;
+
+	if (!data)
+		return -ENXIO;
+
+	online_type = dax_kmem_parse_state(buf);
+	if (online_type < DAX_KMEM_UNPLUGGED)
+		return online_type;
+
+	guard(mutex)(&data->lock);
+
+	/* Already in requested state */
+	if (data->state == online_type)
+		return len;
+
+	if (online_type == DAX_KMEM_UNPLUGGED) {
+		rc = dax_kmem_do_hotremove(dev_dax, data);
+		if (rc < 0) {
+			dev_warn(dev, "hotplug state is inconsistent\n");
+			return rc;
+		}
+		data->state = DAX_KMEM_UNPLUGGED;
+		return len;
+	}
+
+	if (online_type == MMOP_OFFLINE) {
+		/* Can only offline from an online state */
+		if (data->state != MMOP_ONLINE && data->state != MMOP_ONLINE_MOVABLE)
+			return -EINVAL;
+		rc = dax_kmem_do_offline(dev_dax, data);
+		if (rc < 0) {
+			dev_warn(dev, "hotplug state is inconsistent\n");
+			return rc;
+		}
+		data->state = MMOP_OFFLINE;
+		return len;
+	}
+
+	/* online_type is MMOP_ONLINE or MMOP_ONLINE_MOVABLE */
+
+	/* Cannot switch between online types without offlining first */
+	if (data->state == MMOP_ONLINE || data->state == MMOP_ONLINE_MOVABLE)
+		return -EBUSY;
+
+	if (data->state == MMOP_OFFLINE)
+		rc = dax_kmem_do_online(dev_dax, data, online_type);
+	else
+		rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
+
+	if (rc < 0)
+		return rc;
+
+	data->state = online_type;
+	return len;
+}
+static DEVICE_ATTR_RW(hotplug);
+
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
@@ -360,12 +484,29 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (rc < 0)
 		goto err_reg_mgid;
 	data->mgid = rc;
+	data->numa_node = numa_node;
+	data->dev_dax = dev_dax;
+	mutex_init(&data->lock);
 
 	dev_set_drvdata(dev, data);
 
-	rc = dax_kmem_do_hotplug(dev_dax, data);
+	/*
+	 * Hotplug the memory using the system default online policy.
+	 * This preserves backwards compatibility for existing users who
+	 * rely on auto-online behavior.
+	 */
+	rc = dax_kmem_do_hotplug(dev_dax, data, MMOP_SYSTEM_DEFAULT);
 	if (rc < 0)
 		goto err_hotplug;
+	/*
+	 * dax_kmem_do_hotplug returns the count of mapped ranges on success.
+	 * Query the system default to determine the actual memory state.
+	 */
+	data->state = mhp_get_default_online_type();
+
+	rc = device_create_file(dev, &dev_attr_hotplug);
+	if (rc)
+		dev_warn(dev, "failed to create hotplug sysfs entry\n");
 
 	return 0;
 
@@ -389,6 +530,8 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
 
+	device_remove_file(dev, &dev_attr_hotplug);
+
 	/*
 	 * We have one shot for removing memory, if some memory blocks were not
 	 * offline prior to calling this function remove_memory() will fail, and
@@ -417,6 +560,10 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 #else
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
+	struct device *dev = &dev_dax->dev;
+
+	device_remove_file(dev, &dev_attr_hotplug);
+
 	/*
 	 * Without hotremove purposely leak the request_mem_region() for the
 	 * device-dax range and return '0' to ->remove() attempts. The removal
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 41974a1ccb91..3adc05d2df52 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -239,6 +239,7 @@ int mhp_get_default_online_type(void)
 
 	return mhp_default_online_type;
 }
+EXPORT_SYMBOL_GPL(mhp_get_default_online_type);
 
 void mhp_set_default_online_type(int online_type)
 {
-- 
2.52.0


