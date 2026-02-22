Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97791C624A6
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01AD56B00C1; Sun, 22 Feb 2026 03:50:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1CCE6B00C3; Sun, 22 Feb 2026 03:50:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1BE56B00C4; Sun, 22 Feb 2026 03:50:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C5A656B00C1
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:50:33 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C3035998A
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:33 +0000 (UTC)
X-FDA: 84471471546.13.B8C5E38
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id B9BDA120007
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Kfe7tIki;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpwyVnUix8AlXytS75zE0sxhDRGKImtyt6+A2dtIhcc=;
	b=IwVf6bfWGiKI15k91pg20RTbfTYLwe43WDJFHAI2sZQZ6h2efac1iAVHyfxOQ71MfDeBjx
	J7CvQl/SX2EYpPm62XLLZNwM3+b2THJT9IQDiKr0zeQtWXYSlO/fXYbf/dJ1aNIn7x/uuE
	VHaKkO1fI69VZ55M+Y9djNVuUaEKAgk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Kfe7tIki;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750230; a=rsa-sha256;
	cv=none;
	b=FIC+AoCP6SzxayEl02Oyu5OcaX5aQFND+cWw+jVDTnog0Dx+Ic274/rbwze3OLZhxlet6Q
	BGRj09TTT/BMp84H5Ca5BZuOX6pqXZ4p+OKaZc9O5j3mxrPZoDUqh5wgmzmwgs6slrHOCp
	3QQTQj6HzDh06W7C5rw0wDaHTmSj2JI=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-506bcb23a78so29930551cf.3
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750230; x=1772355030; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kpwyVnUix8AlXytS75zE0sxhDRGKImtyt6+A2dtIhcc=;
        b=Kfe7tIkiCWE3roBbK1TiaE0veU7AqpG9Z3gMrz8S4z5xCyE+oPVPk8xy0Hw+xv7cwt
         gPJUqtEKB8AubeZ4Pj8YHBPDEed9V2kOt1xYFBDgj3gddJ2rt3NedTRGtRC9Q9EApwQX
         ag5i7L/X/jorVgbZUtBOcArx1Gx/2H2VA7GngJ81Z7NSelGepnqyuRq4PJiReF7/9njW
         QjE4y4J3gZXmu7kms7pW/gIU6LLaqTL/veOn/wJJt/W6hv42OPlbxc4C9Au7klYC79yT
         nf2Y0dnnNZIKekDUJeEcqHyiXjyI6nzKt9xuqcb6KdEAotEK//wQFwhFDiYC1uAVL2eh
         KOyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750230; x=1772355030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kpwyVnUix8AlXytS75zE0sxhDRGKImtyt6+A2dtIhcc=;
        b=JD3vOqtoJRFacPld/dvdZx2ysvTLJ6XgfquQLsA3A0HxGSmJ9uqVm69OnnwDp8loEY
         P4QkKgUdYaDgf9bjoH9p8UZg95qm0PAIK6Llr52Htpt7BnXlolLDkRD97SKsMno/x3P6
         d/69nIRA7cH7AMWHfCB2U76OmXm9BobD4m4ac4zdUryxVh42qjVSXburw4PMzkFpBuzg
         SGCCv5d3DtGkJ6ZylF9ocrkqXBZZQFGm8EJmiyxUArc8NU6JoVHKNxtIcXWXrdoixOlE
         vWdrtmK8TR5YQnnnZv+sTVKx6Xz2QuDMQ+VNFZ+BaoKUiH3Q5cZVeYTHPHRYtkqfXnO3
         D+OA==
X-Forwarded-Encrypted: i=1; AJvYcCWBNeJqSRcu8nTbwEa/8Yc1JnU79hnMURofvwF+Hb7zGMQQkYVr7maLWYvIXVp6vjZILcRQebHiuw==@kvack.org
X-Gm-Message-State: AOJu0YySviRfqZ7L1noml2sJrriqRVyywidtM/qsSnrX/8otD1o1vTxS
	6YO0vqyI5TqoVmQv5JfiwUR4+Kiz1abz0zsZckA8L5ugevZg2xi2EcQjaINfMc97Ric=
X-Gm-Gg: AZuq6aLWHmHJV1WaHYOQtrVeVn8KoIvqn0Z3yTk/Tn3u03oHi97AB8bWXJLAqdusCLj
	1qhLoAtUfk51ka9hXuN1Uj7dN1Uir6ntPA45iEcqGRMnihac06uBkCcvMGNU9Oats+UpkLBbSSK
	/FvYH9yhknkAoiX2LVp2xp8HovPDcKqEpvF1rTMGp8FvQcV+BIBvvLd0FIHfY2/dbVAPZgK9Rel
	paA08sNntNHu/SplA217G+CdrG8AMQDW9x4svmssb30EB538rR1dVdc7GJ+8jiNOpN2uOncoPYK
	Wfmd4HD9Bg419rm781iybXAwHQo5dJ7k4GSUZbvN7KunvCylUUZbnlTyzT62ws5JNQtbc0tVfa6
	TJFG1BVbtQRlqCmxvsfklFKOYxCdPDodbkq4rXhP5BDcrqiPBXbpJYeXr8jgI8Wepf1naIXkQLj
	wd5u9A6z5fRWLPx2UyY7CJzttnUL9dbBTCc3a5JGcvKq6LiOJCULBSAvC322yZJUeVxjmr2GSTb
	bumg0r9x3qz0UU=
X-Received: by 2002:ac8:7fc5:0:b0:506:6f78:e091 with SMTP id d75a77b69052e-5070bc91781mr65950941cf.60.1771750229747;
        Sun, 22 Feb 2026 00:50:29 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:50:28 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
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
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 25/27] cxl/core: Add private node support to cxl_sysram
Date: Sun, 22 Feb 2026 03:48:40 -0500
Message-ID: <20260222084842.1824063-26-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pmrd5ptergsaioqb3rfe7jhiuth43keq
X-Rspam-User: 
X-Rspamd-Queue-Id: B9BDA120007
X-Rspamd-Server: rspam01
X-HE-Tag: 1771750230-467157
X-HE-Meta: U2FsdGVkX1/gAW3qqTJalRP+yRPYZpBkUm8OeeP/VHIMAhrPbSgVXkRhoJO26zwTkC2DjGOnvlxwR9k05HjomP/EMMXGooErHnqgoPZVttrdYKu7306tICRIETXpQQ6btZTBqaxUQvF/0f2T48kQfPoeRh08qtHhjheg8gouNEoCxJ4gQJykOBPvlvanp+FJXPit/hv/5PV7uASRnw2bhr2yhc408MoqQwfEkWNiiqc8DASJEdbeKtXLo8pU/TqEFIjPMmMTAIzIE2Dt6vUn4tWcPSiPHKjq5fGBpxMzqR6ZgG0rlqRgZUnXIIn8BHiF4YSdInR5B5kIrp4vkgVjHpnqH3vySYqu4OYlBvHwiKhliQODlVcn8tbUW/V3xlSRXUJ48pIuGBECHjYJ5SowN8cvh7se8Pd6YD1fGgaun3Kzxa7cD5eVYt86XYR3LSW1WlSHEZ1otYxMqPSuRVpegd0L2ptmWl2MwJgaCfSeNpymo97NvZEcbYpn7n2ZBd2bR6DRZ/iI3DMatzRaumMiJOK1pp8En0FO23Fw2WWBv6Yqsi3i9uOTEBh7zWtiZJdXl8Rwq1CplVTrHC1ZQiBZiUFLe4xFNANxmNVR7IamsNYfxW6RRjhRLpX11lrZcSWXCzINDDQHpI48kkgWSpS74JjZdChNzqwfPkNsl5EDAWIHg1bL2Bz9vtsyUqXqO8kBxuxC5JSAWodLswDvfPjojBm88KXkqDGjLDMauv6nIK7qAOhTXhxfJEa4XVo1CH95oMyoREfgBNXftCOFHm6idgWnSSD81cn34sphUD7EtxOxvsPmTps3ggjHwrlV/C5AQrbeyS61WET06zvSMOuaXXwhnItAJWUdpUFsmKzD/2V7UlUB/i7mGzKwAaUOMiSrmfP3gGliYphbIWDrkCrU7myiSFWlooiKS4yGaFIdBlWnn8Q5aBfa+I2Q8RJHWYJZxSZWKh0HVb18S/7EkFP
 stBYXsWX
 s00fjKO5I0y5kiRCtVnG4AMYDequZ7jN4Vj/qIwOMkDAceLFf2Fp7lnq8AT4llapmeTeERlE8jZwX72/q/+pZoEk6jsLtlDnADCJNxvtn+mCIv0Nu9ezaTddp+79IRjSI/JvYsXf6p2PLVX5pLJROKhgH0aSY/v7qewgGSK48IUayFMoHpjhtppEr/gjrH+yxNLm/XM9/2nW2z7EL/je3LKKqwGluKUlk/iAFG+ujMJKvUqRwPTdSTtWpfXHxiX4hloBh+gz39mwXzBkAY61a/65qCgc5+uZfVQldEraK1N71hEI2WircbAo379DFkxDxKPGORXutT2Jm13gVoNYwOOD2pUrMbL+MLg7YUTTQ2wgSwQG7TRDakeToHn4lBys4qNatAPnEklf+Hff1NTGHQCkwsvATksks9CdwlIhfa1lgiiU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the cxl_sysram region to support N_MEMORY_PRIVATE hotplug
via add_private_memory_driver_managed(). When a caller passes
private=true to devm_cxl_add_sysram(), the memory is registered
as a private node, isolating it from normal allocations and reclaim.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/core/core.h          |  2 +-
 drivers/cxl/core/region_sysram.c | 50 +++++++++++++++++++++++++-------
 drivers/cxl/cxl.h                |  9 ++++--
 3 files changed, 48 insertions(+), 13 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 973bbcae43f7..8ca3d6d41fe4 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -56,7 +56,7 @@ u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 		   u64 dpa);
 int devm_cxl_add_dax_region(struct cxl_region *cxlr, enum dax_driver_type);
 int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
-int devm_cxl_add_sysram(struct cxl_region *cxlr, enum mmop online_type);
+int devm_cxl_add_sysram(struct cxl_region *cxlr, bool private, enum mmop online_type);
 
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
diff --git a/drivers/cxl/core/region_sysram.c b/drivers/cxl/core/region_sysram.c
index 47a415deb352..77aaa52e7332 100644
--- a/drivers/cxl/core/region_sysram.c
+++ b/drivers/cxl/core/region_sysram.c
@@ -85,12 +85,23 @@ static int sysram_hotplug_add(struct cxl_sysram *sysram, enum mmop online_type)
 	/*
 	 * Ensure that future kexec'd kernels will not treat
 	 * this as RAM automatically.
+	 *
+	 * For private regions, use add_private_memory_driver_managed()
+	 * to register as N_MEMORY_PRIVATE which isolates the memory from
+	 * normal allocations and reclaim.
 	 */
-	rc = __add_memory_driver_managed(sysram->mgid,
-					 sysram->hpa_range.start,
-					 range_len(&sysram->hpa_range),
-					 sysram_res_name, mhp_flags,
-					 online_type);
+	if (sysram->private)
+		rc = add_private_memory_driver_managed(sysram->mgid,
+						       sysram->hpa_range.start,
+						       range_len(&sysram->hpa_range),
+						       sysram_res_name, mhp_flags,
+						       online_type, &sysram->np);
+	else
+		rc = __add_memory_driver_managed(sysram->mgid,
+						 sysram->hpa_range.start,
+						 range_len(&sysram->hpa_range),
+						 sysram_res_name, mhp_flags,
+						 online_type);
 	if (rc) {
 		remove_resource(res);
 		kfree(res);
@@ -108,10 +119,23 @@ static int sysram_hotplug_remove(struct cxl_sysram *sysram)
 	if (!sysram->res)
 		return 0;
 
-	rc = offline_and_remove_memory(sysram->hpa_range.start,
-				       range_len(&sysram->hpa_range));
-	if (rc)
-		return rc;
+	if (sysram->private) {
+		rc = offline_and_remove_private_memory(sysram->numa_node,
+						       sysram->hpa_range.start,
+						       range_len(&sysram->hpa_range));
+		/*
+		 * -EBUSY means memory was removed but node_private_unregister()
+		 * could not complete because other regions share the node.
+		 * Continue to resource cleanup since the memory is gone.
+		 */
+		if (rc && rc != -EBUSY)
+			return rc;
+	} else {
+		rc = offline_and_remove_memory(sysram->hpa_range.start,
+					       range_len(&sysram->hpa_range));
+		if (rc)
+			return rc;
+	}
 
 	if (sysram->res) {
 		remove_resource(sysram->res);
@@ -257,7 +281,8 @@ static void sysram_unregister(void *_sysram)
 	device_unregister(&sysram->dev);
 }
 
-int devm_cxl_add_sysram(struct cxl_region *cxlr, enum mmop online_type)
+int devm_cxl_add_sysram(struct cxl_region *cxlr, bool private,
+			enum mmop online_type)
 {
 	struct cxl_sysram *sysram __free(put_cxl_sysram) = NULL;
 	struct memory_dev_type *mtype;
@@ -291,6 +316,11 @@ int devm_cxl_add_sysram(struct cxl_region *cxlr, enum mmop online_type)
 	if (online_type >= 0)
 		sysram->online_type = online_type;
 
+	/* Set up private node registration if requested */
+	sysram->private = private;
+	if (private)
+		sysram->np.owner = sysram;
+
 	dev = &sysram->dev;
 
 	rc = dev_set_name(dev, "sysram_region%d", cxlr->id);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 8e8342fd4fde..54e5f9ac59dc 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -10,6 +10,7 @@
 #include <linux/bitops.h>
 #include <linux/log2.h>
 #include <linux/node.h>
+#include <linux/node_private.h>
 #include <linux/io.h>
 #include <linux/range.h>
 #include <linux/dax.h>
@@ -619,6 +620,8 @@ struct cxl_dax_region {
  * @mgid: Memory group id
  * @mtype: Memory tier type
  * @numa_node: NUMA node for this memory
+ * @private: true if this region uses N_MEMORY_PRIVATE hotplug
+ * @np: private node registration state (valid when @private is true)
  *
  * Device that directly performs memory hotplug for CXL RAM regions.
  */
@@ -633,6 +636,8 @@ struct cxl_sysram {
 	int mgid;
 	struct memory_dev_type *mtype;
 	int numa_node;
+	bool private;
+	struct node_private np;
 };
 
 /**
@@ -987,7 +992,7 @@ int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
 struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
 struct cxl_sysram *to_cxl_sysram(struct device *dev);
 struct device *cxl_sysram_dev(struct cxl_sysram *sysram);
-int devm_cxl_add_sysram(struct cxl_region *cxlr, enum mmop online_type);
+int devm_cxl_add_sysram(struct cxl_region *cxlr, bool private, enum mmop online_type);
 int cxl_sysram_offline_and_remove(struct cxl_sysram *sysram);
 u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
 #else
@@ -1011,7 +1016,7 @@ static inline struct cxl_sysram *to_cxl_sysram(struct device *dev)
 {
 	return NULL;
 }
-static inline int devm_cxl_add_sysram(struct cxl_region *cxlr,
+static inline int devm_cxl_add_sysram(struct cxl_region *cxlr, bool private,
 				      enum mmop online_type)
 {
 	return -ENXIO;
-- 
2.53.0


