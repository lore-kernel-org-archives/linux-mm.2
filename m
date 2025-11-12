Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77665CD3444
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 19:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D87878E0018; Wed, 12 Nov 2025 14:30:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D36F78E0002; Wed, 12 Nov 2025 14:30:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFEC98E0018; Wed, 12 Nov 2025 14:30:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AAF018E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:30:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 785534CFC0
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:30:23 +0000 (UTC)
X-FDA: 84102946326.02.AC72095
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 96A061C0014
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:30:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dplgIXBw;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762975821; a=rsa-sha256;
	cv=none;
	b=qHsvLkxVIFI4U8kSDP/eJSP3orcZdrYEljWXGRLX4+kGsdfobk+agB30iGXNNwrECAJXEd
	IlSEufs5mw6sfM5iS1cEn4euA8XUGbFpVtGiOqLpJBALlcrbGNPOg9qYIwvvxUbu6N8oar
	rOIrEiYt/QvXX/Vkz2RbBBpAZVaLgzw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dplgIXBw;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762975821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UkWGDFkxsYcV2vUuZc9I0ZRX3P3sH+nyS9DR2ZbJTF8=;
	b=yaddTGHl9/ouV32iAzcw+5vGgq43cipzQPCG/GEwdaGYxQNtYaYpaD1NiPmaTBpXF7cNn/
	HuXhBZim4slBDob9FjzypeQDao1ZiHE8M/Ys7Ha6cmV8aidntKg587ds540Xct/gRFzYTo
	Dt6H5vwdX2ckgWcGoB5RMWB7vKbe/XI=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-891667bcd82so3563685a.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762975819; x=1763580619; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UkWGDFkxsYcV2vUuZc9I0ZRX3P3sH+nyS9DR2ZbJTF8=;
        b=dplgIXBwgNPMxq3oorgUGtE3QaTodmGCx27DYwlC6XtkNtMrsaarFKhPn/9RVrLg8e
         EPLthbI6H1ECJ0NDBO3LuPh0+h11RdukhrIiXFoVJM0w/F7g2ye+cRL+aJ/IY74Hmz+7
         +g/4CHqXe/pTkUduzqGnLzVhxH9htPDg447iGsdjGY+8HbD41RP+fthU1uCjF+uhmX5g
         yvlhuf3CFzA1YZndEH8yb2mDXW8ecIXKL8s8E5Oz+d9X4YIYGbb7E2PdttKrpFdF+HBi
         qWMt8e6dwKJaZ0KTyENv8t96nXR8u3LLIFAS7Ibk6bF/7BpRX47wTXKCEwefOc9dQplv
         qzpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975819; x=1763580619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UkWGDFkxsYcV2vUuZc9I0ZRX3P3sH+nyS9DR2ZbJTF8=;
        b=ZaXkg4mvaOLODXaITk7DkS2kIFL4uI/+zERQIG8DUV/IErP0FofSyvcnfqy8APlM+9
         5HH15aC0V4eJBRsirsyOcwZLxakC7zHTIU2KQe8hZE/hXow6ucvWMu+0HrDKeq+qYQ8T
         uHlXJrWuNt1kWTXWhUjyQKhhTjqIGbVOCNKzveMzkMGCT74fmVDyNUNN1PJ+NPmxArgT
         IzJLaXGHnDBxbuUQURLF4KCd61Yt75CIxwbp4XbAlaZq119q2SJiOsHDY3XkD7QiXXvI
         tHv9Ti7ZDVj8pGS6zcY+gVxgeH8y1sWjm2Lo0fH8QW+7K2RTd65PlCyENSzxL/Z1hVp3
         SZKg==
X-Gm-Message-State: AOJu0YzJ+3iXasjhxKZ+Eg1zJMq3NPJAIxsSKp1vNHBNZYd6cPbktZLu
	uofnHuicPAQ6+8Mpc0qjREJpSaADxR0ZDlMP2nPsaKqwRZydOQaYW4dWwxIjuBF4+vi/SeM/jZY
	6beuY
X-Gm-Gg: ASbGncvbFmJkJyeP9zdBaHiAf6LpDzvX68pk5qvxvwE26AIf+XZztjmDZRvi/n7Mptd
	5I3CrH5oC8B52xB76ZCmGdWhQm3hklPjRIwJhpFhSBW5LmL442Jym1I0hb+u/3NoUoyTueYBuNm
	8mnH6kqH50fkXr0qaqYpAm0FEazDJBYFiNA71TtHKe+f6qsR2X3lkJYX3FjcdwEU7R/kt35cv2s
	EB7i97Laj9MlK2ygTcf5QQ6Ft2wdBQ0I8bzgtAxTCTN4la7mrvjiOaByI78AIPw5ALs0NQ+sMQ/
	emx+SJ3jugkDXxbtxXSlo5yft8icUXsHdJgCnFfx6nvkVhLziFpIk46EXiPdvDFpUqTjlez8aD1
	AlFxEyM/iuGEC9OpBTFWqsHCKAqXGmCMbDXxgY+eE40xE2CfDV/5wchqjxZ5JikXQOjc+7WbHS/
	LWe8qg1ucyxwgTaVma2qFedM/h1RbUfI8r6HItpD9GuNRzLDBfKAEx/F7Fxo0E1qOC
X-Google-Smtp-Source: AGHT+IHnA96vKIbRbEVDdRL2YlwlXqxXxNpoq+1tyGBGVESiKZZsfFfpRROUBFK0hifrTyISq2ufZA==
X-Received: by 2002:a05:620a:f01:b0:89d:b480:309f with SMTP id af79cd13be357-8b2ac08bd6amr88119885a.7.1762975819003;
        Wed, 12 Nov 2025 11:30:19 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa0082esm243922885a.50.2025.11.12.11.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:30:18 -0800 (PST)
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
Subject: [RFC PATCH v2 10/11] drivers/cxl: add spm_node bit to cxl region
Date: Wed, 12 Nov 2025 14:29:26 -0500
Message-ID: <20251112192936.2574429-11-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112192936.2574429-1-gourry@gourry.net>
References: <20251112192936.2574429-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 96A061C0014
X-Stat-Signature: rcdkuc1gu8xieyghb5sntp54cg7nu3oz
X-HE-Tag: 1762975821-285215
X-HE-Meta: U2FsdGVkX18rfjtJoda8kRUfovTIvmccn4KMXTh7+nGRYQliGVVASfvOlHsxdj20j7N8bPaleyHxBntsiM91kk89Shc8Pv1BPpIEVbdsMcA8STC4dc00qsn0nNNkCmtUpQnfXUuofSnlQVZOuzc0WE197lqsC0HELMaWNr+N89qK64RaRnPxZ+wDEfFaLMZbr/Zwkrccz/T7YiM3zoOPsG27jE9+yU2z4TsbEW2Zzup7eRi7Aa7llwuyaaJzi9+9AzJsQcdgnuyk42fy1PEtDK4l4jWL1iSxPJksMr1Po1AOmes3oS/gUrQZJGwPC27uNanzqBqvutzfchqHz8CdfHc4mjYzxPdZUrzH8OK3AkPOyp4tVIuE+6xbZ6lErlrQxlCRANMd+Mnf23qD9wRdPo0uLVX2jTj5uLlSE7Q51qI6y2PMzXhckouHWyGx9oV2rAcQ6MLzAJzmjgCvth5cq0FYAjBsDagmm1Ecy6gA0AlAZ3qlUmnSc2x0XMwn/0YbN3TO55bkW0gNeBp5o2mRwXu/VnooKmJhUGJw4/R7+gLhSqUO2lWYX9SceYqlISum9d36dKKY05cka1fz7h82AojmpyB1j1tt2eqSw8gf8AIhqcNuM5QLnaMHJk6Q51NeKqj6q+Z9cjlREz4hdOgOtRAWNdpyez7n8ye9IHGj3fP/vvOb8BgILZsnn7P7v/PS+f6/eZMMD0KQIw33MjIZj2EjnJqKOHBUgRJ7dgbzCaNBND3m4oylqxPJnf+L/rAZeYXkNhk3ygU96NUGz68efcOe9h3BaNQ4+dY6YbBJOxi+8UUth+PasTp2DV9Eq7mzxxDeZJRsbCY6jl8B+yc4i3f+P/Pp/zovnU6MlPMJ2zNt3171SlAKerI+rd8sMlCs5EPYnG4wSihfxLuTzOxw+iog//6npbcQlu801drN4SOHpfK69tlz+8h0wYy5Kqb4sx5+vN/8f+6AV8k3Egz
 Ior2BADi
 aH/3F4VRN9GLp5IcLjpnc8DXxTDuEB70NXnEPL3JoJpamAIgsFbldutJbig8H1RDEykPWz4d7hewRAOfQ2EDfQ/GPRbVNFOQE5mzfi6QsnyaVQCQiGScKFA030aDhyWi+mufgSSuGC1RTfzeI3GoxsuurSdWHhf8RujKF/KfiB3NtCH9werFaogjPcigsHmnBzZgR4Pzmth/QNjMB/dKIQ2LkVeCyAL1bJJWpIHlyLJsqCJSsNwqgkvSzV+S2V/QvSjjTqlevg7AEwLCCs8huWvUhqPLAUPCIc2GnrsyYtEztTNXfEuP4mJdsMdcSTdwL7VzbUK2Qqy/ceKROVF/7UMitfhG0Kw5/s9DKFbpApCZ2jslQTx1g97Wpz7AmWiz1v3Uaory6H5xeNkcJBX2xKTfBMZWjxxkjVp5BAU/tdg3th4c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add spm_node bit to cxl region, forward it to the dax device.

This allows auto-hotplug to occur without an intermediate udev
step to poke the DAX device spm_node bit.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/core/region.c | 30 ++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h         |  2 ++
 drivers/dax/cxl.c         |  1 +
 3 files changed, 33 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index b06fee1978ba..3348b09dfe9a 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -754,6 +754,35 @@ static ssize_t size_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(size);
 
+static ssize_t spm_node_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	return sysfs_emit(buf, "%d\n", cxlr->spm_node);
+}
+
+static ssize_t spm_node_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	bool val;
+	int rc;
+
+	rc = kstrtobool(buf, &val);
+	if (rc)
+		return rc;
+
+	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
+	if ((rc = ACQUIRE_ERR(rwsem_read_intr, &rwsem)))
+		return rc;
+
+	cxlr->spm_node = val;
+	return len;
+}
+static DEVICE_ATTR_RW(spm_node);
+
 static struct attribute *cxl_region_attrs[] = {
 	&dev_attr_uuid.attr,
 	&dev_attr_commit.attr,
@@ -762,6 +791,7 @@ static struct attribute *cxl_region_attrs[] = {
 	&dev_attr_resource.attr,
 	&dev_attr_size.attr,
 	&dev_attr_mode.attr,
+	&dev_attr_spm_node.attr,
 	NULL,
 };
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 231ddccf8977..ba7cde06dfd3 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -530,6 +530,7 @@ enum cxl_partition_mode {
  * @coord: QoS access coordinates for the region
  * @node_notifier: notifier for setting the access coordinates to node
  * @adist_notifier: notifier for calculating the abstract distance of node
+ * @spm_node: memory can only be added to specific purpose NUMA nodes
  */
 struct cxl_region {
 	struct device dev;
@@ -543,6 +544,7 @@ struct cxl_region {
 	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
 	struct notifier_block node_notifier;
 	struct notifier_block adist_notifier;
+	bool spm_node;
 };
 
 struct cxl_nvdimm_bridge {
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 13cd94d32ff7..968d23fc19ed 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -27,6 +27,7 @@ static int cxl_dax_region_probe(struct device *dev)
 		.id = -1,
 		.size = range_len(&cxlr_dax->hpa_range),
 		.memmap_on_memory = true,
+		.spm_node = cxlr->spm_node,
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
-- 
2.51.1


