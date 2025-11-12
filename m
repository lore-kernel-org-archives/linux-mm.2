Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4955BCD3444
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 19:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7BA8E0017; Wed, 12 Nov 2025 14:30:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50FA8E0002; Wed, 12 Nov 2025 14:30:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967318E0017; Wed, 12 Nov 2025 14:30:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 85DE58E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:30:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 59B31140628
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:30:19 +0000 (UTC)
X-FDA: 84102946158.09.691FDBC
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8265C40019
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:30:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=c2Jy0w26;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762975817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x8LOzdRF3F1ID8i/f4610zpV6s32IDb3v5xseVevQWo=;
	b=Jf4jd8F5LhjLw4DXqWkDHrdowDln6WUwzWV8AR3lTNMbQx2aqsQwWvzJPPz00mxOOnr0M2
	gjKhuzonHU9P34d1ngO6Qhf1CxoZIvzr2Uj1gd3KcvoaHR0pQODTxx1yG/X7cDLbJd9sRu
	2aZHThlryzVKn/tvvESoVG4p3ZVyxcI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=c2Jy0w26;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762975817; a=rsa-sha256;
	cv=none;
	b=mvrBCoM4540mFe5hR+gnqthq6TiE+2z7vv/oSAUg955TIxPN8H3IHvKTM9yHLZ2Ysn8hSc
	caEpLRkE5RrGzpVh6/VEIXK12EQiTUVOAq+zECzyFY2LyQf0uCXptxFfalSrbC2bWD4z5t
	jhe6ISqDy4joXYJqPYhMKbsT4gANqRA=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8b28f983333so4590385a.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762975816; x=1763580616; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x8LOzdRF3F1ID8i/f4610zpV6s32IDb3v5xseVevQWo=;
        b=c2Jy0w26jueLx4LEWQCBlNFaU2MLXrFSXVSMOQ4tYo8wHclLpg5bn+udK1myBrZ50L
         HU6wvln/lGP3bOD/P0xE9Va44lk4L+azQ88roTz8O/i1YdE3rdNFP5Yrsk0qlSnusK/E
         w5zX59MNpK/KPo/6VV0tTw3KQJbusYXHHoLij+QDcUG+qfz3fGdzKN1NTs3Uf76eK7Om
         t/ZnSM93mxjFQK7VxMM+lkfqWWAx2lSKGzgZebPTsgYO3JdVLCnfyXbx7/5oFcqv2iwz
         axo60Vvwhx+ayUZWfhEMZo5XDPTkaNkumZ5uYmkZBxRVCEiuBNOFpE3EKklcMw9Y5ABD
         mNdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975816; x=1763580616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x8LOzdRF3F1ID8i/f4610zpV6s32IDb3v5xseVevQWo=;
        b=e+bBTv+9SDv56t+h882DGNy1jmoyUOtu8Hiv0Lphu4zCnTArf4saraZUo1ssV+2set
         YH3xo0yf4Q+yWUWWjq7WIPUpM2wQ9IumSvAmBMgwmVigkgrzdkk+0TbBYCGrvGR4SYN9
         /4Gu8fXo/K4PBQplqKefXczHR2MG3TfQXd3ttzeaj6lOJKa6a3NgnLUCr7Xg8jIOECDQ
         U5lkkQMtuH/LAeTQcJROV43bcj0vkLt3fXBWITRXSuJWthcNt9sBAXUGnVsy/mslWelm
         uJyi2zUWkF8AZoVh4mNqLAIt0dFVbkumXryUywRyd6d3hiSDEsYIDCNNWhqIMZVHpeBj
         zDFg==
X-Gm-Message-State: AOJu0YwToUvqaZ5p7bQUh16zFokFV0rHMVk9EpB3A/rJ7Gg5v4eUF68w
	wl5wZf9nbUWmAJ5NHsQma5rkQEeDsimixNlbPTGaV8lIHpXf+wqBVoLr6Y5ScBoEWlXET3Sixwa
	7W6QO
X-Gm-Gg: ASbGncutxa4xYYzvmvZ/z1muFX10aY2i9Jz7FyY0Ev8nx73aQ6OYXpzFrXo4PF3pMKY
	vCNMieSGAupD01N3pixDdyHEIe2AcvBWICeDn8CkrZJmsViGwoAwP7b4p2dNYBk+d74La4vwjwz
	Cxp7mDFyOpdt/2wvyr1qq+MJsKBpwm/Yha3iFht5poSHysorTHFUKPmwwVnbbUbMJzhiMQoynAp
	MtlftJKuJHqaY92G0x9OT6Yo4pPypI300zf9FclZsdV85HEXxikJQd6gLmCmhfVPShS9QNnOcJ7
	J7Txcc/FTpOrxMgEtw9Xg/WzmXf8T9qGBDini4j1/6cGghMdqRESuAtaU9bYkm5RWhCeHTTMYuh
	XNwUwdK5KDWyw7DD0MgoUe9yxDBucEGqUhGu2/ssPQtgd+kBg8e6tFXgk9ZdXwIGrDKQz5r0224
	HdpfkTLeyFYLbAW8flDxfre9ywZteVFi+0MQy38/khJlmjFhkzz9OdFCnmXXDK2Hz7
X-Google-Smtp-Source: AGHT+IHll+IKPvcEc2EdGPBw2QQZcQZ6T6jlawQUNb6L1NrYv5cDZU0Tf0FeuJID2gzeZN1UxCbY+g==
X-Received: by 2002:a05:620a:2a0f:b0:84e:2544:6be7 with SMTP id af79cd13be357-8b29b815e49mr640273285a.65.1762975816129;
        Wed, 12 Nov 2025 11:30:16 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa0082esm243922885a.50.2025.11.12.11.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:30:15 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	kees@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	rientjes@google.com,
	jackmanb@google.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com,
	rrichter@amd.com,
	ming.li@zohomail.com,
	usamaarif642@gmail.com,
	brauner@kernel.org,
	oleg@redhat.com,
	namcao@linutronix.de,
	escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: [RFC PATCH v2 09/11] drivers/dax: add spm_node bit to dev_dax
Date: Wed, 12 Nov 2025 14:29:25 -0500
Message-ID: <20251112192936.2574429-10-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112192936.2574429-1-gourry@gourry.net>
References: <20251112192936.2574429-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8265C40019
X-Stat-Signature: wznsy3bz7b4dr58qm1o5pku3ewqqgdtc
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762975817-568449
X-HE-Meta: U2FsdGVkX18kcchSa/ODpqotc2LcISghqvwEYggPVQNKT8bIwL47hPxbD4z2UDAqukocX1c0fhf6TLuNvaWR3sAaYVvNWhHbacGOzyK6T/xWqo++CuBeD60FP5adkw4mk5VnWd1jQ6/sJAo4SfOL+0zPPjhmlIFCK1w2VYLFrWhZ62P8JBaKent9ieRW0pbOYAYNUKFH/uib5ScfWyLRbZlfjyebAETw6tX18//Z3Vrm7weh7337jBmuso5GnFNZQMt2WL4B1FRmfGGG86S/RINjQviMTe70q3uM2hUcXnztkr3TY4Kzanz/9QcN9gYRYBkNZFHQG0G56CcH0Kr1FchUsHWlhfOx7T1MkS6uwCNTgkxlzq/1WOP7UtjYboJPJlR+k7zyvJDBSAiVmgKd5hHu8fcQagZ7Q5G5IcxzLJjEdciBmH1eH6ROykM4EcQV6cXaSzajkMhNIcIjxzUSJvMclb2/1BNAmEkbCqFRLtD13p7E7RM7rMe76me717fu1i4K3XtWwi9j4vqroE1rrj0xBRKeWY3wywmVuIcojm3+TNImSAlkerPNpmSb686gcduTJ4nAVOqPYzvJFW5Sd9DbPkHLkHfQiiE1guOWp/U84Fyq4vIOMT25dmNQ2aU79p/FLML2RfH1/I0LfvNB6Duqiy10ql9ClXPuac8loWFDeBRq50n7TRhaYMw/0IY4AQWlQZd0uhOCBCImse1EMBTH8oSnLxiMXPfVQMcKvZbIh/PibzuZvdiZM1aHwFoB4jWAatZrvMIyhEZiAJQjDVIZTcPQSO1H0EVD6dbI2ouZFmVQGZVM+P6EXrzxR++B2aN6IMARaQrBMF/fLSLQUxR1Ovrdu78egfpVlecx9CDXXljUNw06XwTtmwk1Rvjz2zYasUJQhBqOixcDytxllboAlvt0DqZ89zGV2tMEFGBMEQKTBQZG5qvD+pLtN42+oX2q1kKdBAerZRyjGW8
 RsNb4xDv
 6LJWMZxk13fhNNe5JNiigcMKqCu0PVcULB7BMKQYpjJqKgP1Wsz4ZF4U8WBsk6gmgCMXXs6yXJtIgDCdi0t+liibFSVY2pos6EN25RiTTAy2hQA/FN9454o3VMHpV83xlNPoTMPcVFlDWU3MbrEGMBn6VOfEpm1geeHUqkQqUc3ZnoJjFLmdXIiRLjse+z+JnmU812Csf/5k23xbl5xACSKtJdnnvH0G2twgzxvezCrpqPmQgNVLChRpSv5m7NOL2d3vfUvFg1buSe4vwm0Xoc02wrHboV8xmfoyLB2EYN4LfNbzYz8gCRC2ILCtgQNgdcLjWiEojnCSHOZ+R2d9vN6lg9xG13fsdSaLqJERQhER800JZYTI3FE4wkgRN24lvO+bN5ac8d6ruD3ZwVB0zoP45ANG1Sbwiw2aez2bvhcI5IKk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This bit is used by dax/kmem to determine whether to set the
MHP_SPM_NODE flags, which determines whether the hotplug memory
is SysRAM or Specific Purpose Memory.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/bus.c         | 39 +++++++++++++++++++++++++++++++++++++++
 drivers/dax/bus.h         |  1 +
 drivers/dax/dax-private.h |  1 +
 drivers/dax/kmem.c        |  2 ++
 4 files changed, 43 insertions(+)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index fde29e0ad68b..b0de43854112 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1361,6 +1361,43 @@ static ssize_t memmap_on_memory_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(memmap_on_memory);
 
+static ssize_t spm_node_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+
+	return sysfs_emit(buf, "%d\n", dev_dax->spm_node);
+}
+
+static ssize_t spm_node_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t len)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	bool val;
+	int rc;
+
+	rc = kstrtobool(buf, &val);
+	if (rc)
+		return rc;
+
+	rc = down_write_killable(&dax_dev_rwsem);
+	if (rc)
+		return rc;
+
+	if (dev_dax->spm_node != val && dev->driver &&
+	    to_dax_drv(dev->driver)->type == DAXDRV_KMEM_TYPE) {
+		up_write(&dax_dev_rwsem);
+		return -EBUSY;
+	}
+
+	dev_dax->spm_node = val;
+	up_write(&dax_dev_rwsem);
+
+	return len;
+}
+static DEVICE_ATTR_RW(spm_node);
+
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -1388,6 +1425,7 @@ static struct attribute *dev_dax_attributes[] = {
 	&dev_attr_resource.attr,
 	&dev_attr_numa_node.attr,
 	&dev_attr_memmap_on_memory.attr,
+	&dev_attr_spm_node.attr,
 	NULL,
 };
 
@@ -1494,6 +1532,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	ida_init(&dev_dax->ida);
 
 	dev_dax->memmap_on_memory = data->memmap_on_memory;
+	dev_dax->spm_node = data->spm_node;
 
 	inode = dax_inode(dax_dev);
 	dev->devt = inode->i_rdev;
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index cbbf64443098..51ed961b6a3c 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -24,6 +24,7 @@ struct dev_dax_data {
 	resource_size_t size;
 	int id;
 	bool memmap_on_memory;
+	bool spm_node;
 };
 
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 0867115aeef2..3d1b1f996383 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -89,6 +89,7 @@ struct dev_dax {
 	struct device dev;
 	struct dev_pagemap *pgmap;
 	bool memmap_on_memory;
+	bool spm_node;
 	int nr_range;
 	struct dev_dax_range *ranges;
 };
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index c036e4d0b610..3c3dd1cd052c 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -169,6 +169,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		mhp_flags = MHP_NID_IS_MGID;
 		if (dev_dax->memmap_on_memory)
 			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
+		if (dev_dax->spm_node)
+			mhp_flags |= MHP_SPM_NODE;
 
 		/*
 		 * Ensure that future kexec'd kernels will not treat
-- 
2.51.1


