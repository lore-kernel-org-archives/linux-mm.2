Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B76E0CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 22:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233558E0029; Fri,  7 Nov 2025 17:50:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3258E0006; Fri,  7 Nov 2025 17:50:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05C538E0029; Fri,  7 Nov 2025 17:50:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA9BA8E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:50:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 92EA54BB33
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:50:27 +0000 (UTC)
X-FDA: 84085306494.26.465965A
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id C78BBC000F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:50:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WVZdBctD;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762555825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CwxO6b4UaIu9W6F2d/g8AaHHPWCBsuMNbHYfAmKzKTo=;
	b=WDkCYo9dfgqUhbFXxdCvBFPeo9/BMSt7HVjPTaikK+26TtmnXeERE8oG6SNbACL2Tvu/0X
	SkVypIKho8HDwjX35vgXBNAcs+ETrnSCP1Ly/mpvJEgMeteY3W1NSd0p5fNkr/3WF4jrxJ
	xHm0GVtNEIUJw59JRNWfMpwlzIj+2PM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762555825; a=rsa-sha256;
	cv=none;
	b=QZN3MQFvGsAmB14SYOjxOmCWjtc3y+keH0dScL7BtyB6LzzwcudLcQefrs1yecD4K2bcVp
	xfopASrCG8lsTm04IB4v9qtmezE+q7Z0zbqW1vhorrFvFwOM3kzOIKbaf1rBEsWncITeZt
	zX9iq34FWa26ISFeHbkDmlhDE9ec250=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WVZdBctD;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ed7024c8c5so9958031cf.3
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 14:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762555825; x=1763160625; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CwxO6b4UaIu9W6F2d/g8AaHHPWCBsuMNbHYfAmKzKTo=;
        b=WVZdBctDOFka466GImFdOKg4/te8z5SToI+5a1T2WGFQ2e1lVAWFOxAt4eWISzGX7f
         fbTqgSJDGuvKG6huI66gN6LECL3M5LHn09XYsEsXnPYj/lg4Ccgz8UkipBGdbXRX13UU
         W60DwAIvlbJ9LjZiPu9i0outprMxwXc99l1J+GIZbSUzz57pbm9kx28m89uAE0IW555q
         QK+Sgg2HZYlwn7R57zSWU0HUgzWI6K50p4X6CI5lGlslMLO9xxBBBpk+ti5kGKKyucFC
         j9l6U4GR+Df0L2WvV9J1WwuAZaqWGiCOfD/FmulLzRkEiLvrxVI6BaChUkhCq5QXev4Q
         clrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762555825; x=1763160625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CwxO6b4UaIu9W6F2d/g8AaHHPWCBsuMNbHYfAmKzKTo=;
        b=Gii8khMT0s8znIduTsrd1VKZVMhHMfJvztX1e4QheeChGSqz9NaOQjnFTHyTMlI0s1
         mKzFu6zu2+eRoDk0LBsXePr/rew/yfClv/OUBwdLbNE7nbXZA+TNOPboJ1wHlYotT2Ui
         m0Orcf3TUAcG8MBrCOcbCILpl8nORP3BRQy8p/+PxF4fmCJQ3Ce5R013a24QydexbPPW
         2Ve2+ZAV3Y9JwxxgJVB9syEW0ieo7+KOebtoYDV92sGH9JBV86qxIPe3caClMDorix1G
         qtsvZdPDevA8ut5sdql4Yf0E8sHqJSEtZ/zdXdfjxEV84OdYSBXJYAu8a3pU2zUqcWvP
         LGSw==
X-Gm-Message-State: AOJu0YxRsuLQOOOYmuME4AaUAIlpoMYE6eYSg9DBxi18ruK15DzQHMjy
	quifYvchBLwVSGPSMtPCjkNZNbhIVcwlp96lIBYpiKyNzFcsZd4FmGkDM7ByaKw4VIheSU3403e
	LsSC8
X-Gm-Gg: ASbGncvwSAv4isAt7s5k8c/GzScRs56tHr8vjawlw/bvtJIX5BQcjTHSCmNS+/E/tl2
	SCGyVGuMBJnlEchlM7EZck/VvyhnF6u6xCaKzvlD+pnc9DsSEorLcR4AL+VMmdK5Jxu8oA0p/d0
	kvd6mWacalqLRCxnDaXuxFdUlo27DfrTIbNaclNhdOZBT01C4H3Tz2y49urpsHCPDhaS4RI1/L/
	Xd4xSCRdH77bzYNR738Dw9zqbFo1BHv5EUNK0/xFw/qpYP6BBZYv7uylnm7EjhT2937uWmR5ucT
	ZD3ibeuTUs2Lg0PU2abyy19VTk9ZQ8+mp+Mdp3bMUxxwGgqxoB9cJGxlE35KJUqurpr771Amj1g
	fe0/FxSzJqW5Cuk1OkDAsUfP+9QaKF334tEEXuI9VWBFy79U274kmQYx7tNTT9FrhpI3jiVagQL
	VMZbIROg+1oGJjXFd7iOFFqLKLEEBzFWuwzBua3TjCL3qIMKEYVtbq4So/V5vtMWhe2CZ0dGnTG
	fE=
X-Google-Smtp-Source: AGHT+IGGUkY/hMvQZUDcDXSyhiDaml+qPtZeSmCY7fYoXMiela3sPEpJdPQ5lN6VWEde9PlUke632Q==
X-Received: by 2002:a05:622a:1ba9:b0:4ed:43fe:f51e with SMTP id d75a77b69052e-4eda4f8ffb3mr10117651cf.39.1762555824542;
        Fri, 07 Nov 2025 14:50:24 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eda57ad8e6sm3293421cf.27.2025.11.07.14.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 14:50:24 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
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
Subject: [RFC PATCH 7/9] drivers/dax: add protected memory bit to dev_dax
Date: Fri,  7 Nov 2025 17:49:52 -0500
Message-ID: <20251107224956.477056-8-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251107224956.477056-1-gourry@gourry.net>
References: <20251107224956.477056-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C78BBC000F
X-Stat-Signature: de5zudeywo6mjq75kew5i3tww1o9b6n6
X-Rspam-User: 
X-HE-Tag: 1762555825-825685
X-HE-Meta: U2FsdGVkX18SWuuH0Wcg5R/OH+j4LGsqFbDgu9TiTCk7651x3Q4brATFiQQA0CisPYRcRIDZW9C3/ZE2gZZFWLsPSZyGDUzOxsNQuXKY5GmX3jN/wJ6jFGQClmO/Au7Wgun+SSKk0WIvedVXjKIyXIRpGGVSjtcJVBWXxDeP+XrtgargudIw9wFvAPd3CEnDUFqzcz52EWF1LJwpVygg0aw07Xs4KyaL89gZPTFD7qs+yBlO4wjRmtChAidDOa9s2WoRKI/wdksj4RpuzueO8jcf06CWOJCOPqXKVZ/IKRzkV/c8SBv1wTVz8SMVFVrqTAt0XPLfXl3ttySCt4GsDui0SzsW/yNqaa3g5LYUYcL6BB+DioHZ1B3bg0p5g9h4RS+Alv8KiJXW55Lt2a6UTvUeOC+n1z6v0H3BHwEkoxYI62olOeiEcLMAzl6OIZ9Lt7z9/XEQ6Td574udsnQQFCJRzObzMhEhvH5U599ZAQQy9MCkeAr9HrJ7BiikN189lLKIjs5/GBcXWAP35GGr7/s3/z5zrj5xwCt4cOfHEbc+izRrO4FbneYUKhlH9h4E659LB5SjP3X3nLlyWoqJIvYskFVpiKfy4O2OpwZ4qwBXFGKQ/P+orAZIJ2HGhuV3CmfvpvtKBEcFEH7mdx1vImA/zCSl3/KG/c8oIpjTG3pNvgLBKPq4W/PZ+8xsQq+Ep8LP+rVp8KLIxnTuP4RwpJNmEh9CvlQVGzaKYi8r/bjL08ryzCPd/GnidzI0LFtPlzPASsWcAGZd5YSVC2Hae42vdlkh7CiJ7RecFPtuu3afn4y93SLkaij5yiG7z7UqizR3i67rBlL++WupxI6oX2Ny142b5h8edW6JAE5qlwTn9JmVtqKLHW+r0hhtQRpUt2Xz2ovq80/qFv9qjd9bGO+iZqsR2R8vF6F8HYm52SB1q+Ifvpv3LhK06gaTLVNoMhaoYhVOj9Vw6TMlYlb
 xLhvT4KA
 IptEAi2YJVWty7+eUlcusWceOxWk1pcrMhWMRiAmmjA0Or+mfH5qK7m+oRGHrzohifc0MCNQuCgPzkPO58WDSFc/JvFHMDbVSZwyx2z911QjXlhVgvsy+VJJnC/C5kdIyTRtxVehlAqB49eSsbC8QH/cHePMVDRN9hFJWIjCA8/xko1zb4TSzFRpIP8OvalOfWnJRlXdDgG0lBMD7rNNxwtjClNht1dt4/z9C9MQ81MZF6HhN1MKVRSGNXeF+zVvWJ6t8BpYBWIwGOZ5E9by0drIMWJjRQxwd5i1273WpTsnbTwY67IEdqNxh2mBFI6fFgXO/ZuhQ/Oou1H7WFXQ/sqDaHSLT1FiGBJpK2ril+nOL/hnd4KAhEeBWhEILvsSlQD6E9hZXVA8Nis33iJUROHxMbguAIC8zK7rlAX/HQ/zHQyM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This bit is used by dax/kmem to determine whether to set the
MHP_PROTECTED_MEMORY flags, which will make whether hotplug memory
should be restricted to a protected memory NUMA node.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/bus.c         | 39 +++++++++++++++++++++++++++++++++++++++
 drivers/dax/bus.h         |  1 +
 drivers/dax/dax-private.h |  1 +
 drivers/dax/kmem.c        |  2 ++
 4 files changed, 43 insertions(+)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index fde29e0ad68b..4321e80276f0 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1361,6 +1361,43 @@ static ssize_t memmap_on_memory_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(memmap_on_memory);
 
+static ssize_t protected_memory_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+
+	return sysfs_emit(buf, "%d\n", dev_dax->protected_memory);
+}
+
+static ssize_t protected_memory_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
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
+	if (dev_dax->protected_memory != val && dev->driver &&
+	    to_dax_drv(dev->driver)->type == DAXDRV_KMEM_TYPE) {
+		up_write(&dax_dev_rwsem);
+		return -EBUSY;
+	}
+
+	dev_dax->protected_memory = val;
+	up_write(&dax_dev_rwsem);
+
+	return len;
+}
+static DEVICE_ATTR_RW(protected_memory);
+
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -1388,6 +1425,7 @@ static struct attribute *dev_dax_attributes[] = {
 	&dev_attr_resource.attr,
 	&dev_attr_numa_node.attr,
 	&dev_attr_memmap_on_memory.attr,
+	&dev_attr_protected_memory.attr,
 	NULL,
 };
 
@@ -1494,6 +1532,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	ida_init(&dev_dax->ida);
 
 	dev_dax->memmap_on_memory = data->memmap_on_memory;
+	dev_dax->protected_memory = data->protected_memory;
 
 	inode = dax_inode(dax_dev);
 	dev->devt = inode->i_rdev;
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index cbbf64443098..0a885bf9839f 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -24,6 +24,7 @@ struct dev_dax_data {
 	resource_size_t size;
 	int id;
 	bool memmap_on_memory;
+	bool protected_memory;
 };
 
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 0867115aeef2..605b7ed87ffe 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -89,6 +89,7 @@ struct dev_dax {
 	struct device dev;
 	struct dev_pagemap *pgmap;
 	bool memmap_on_memory;
+	bool protected_memory;
 	int nr_range;
 	struct dev_dax_range *ranges;
 };
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index c036e4d0b610..140c6cb0ac88 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -169,6 +169,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		mhp_flags = MHP_NID_IS_MGID;
 		if (dev_dax->memmap_on_memory)
 			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
+		if (dev_dax->protected_memory)
+			mhp_flags |= MHP_PROTECTED_MEMORY;
 
 		/*
 		 * Ensure that future kexec'd kernels will not treat
-- 
2.51.1


