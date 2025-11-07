Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BFE8CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 22:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085448E002A; Fri,  7 Nov 2025 17:50:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034FA8E0006; Fri,  7 Nov 2025 17:50:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1128E002A; Fri,  7 Nov 2025 17:50:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C55258E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:50:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8EDE313B25E
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:50:30 +0000 (UTC)
X-FDA: 84085306620.22.EC8BB83
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id BFFDDC0012
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:50:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CF67oMh+;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762555828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=raBRVFIoxXfgYF0FkwrcuU6SyEb+VTf3BUeepNhNHyc=;
	b=JP2c6R9GHTIJ17g8oiHA9hGsmH3LQ6XJKGyQdxlehkNxW/ayOf4lF5hYyb0EnHXKGo7CAj
	6qKSFm01F4kNHKOtMbO6DIK9Ie+40id0loy1b703phmp+4ZrZaHlkgTDhMVMfwgRi7MppC
	8Uubjg3j1fgWrzP+l7vI3MK3E6D1B6g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762555828; a=rsa-sha256;
	cv=none;
	b=JBt+OX3XD+6bC2Y8qsXJOWB187Dy9PnJGw7EAlR9YbMhLvu8RgBTy9StsR42MlfWxgIU+c
	d40RX0c3R+15du/E6MCfvdd8O5WvAYi7gYk/tHiNmPvpEhfLG3yGzxlS4dLlvaG/vKJDr+
	AMzbJwevBm6pQxttRemtnFHp+BM2jT4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CF67oMh+;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-88054872394so18534766d6.1
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 14:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762555827; x=1763160627; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=raBRVFIoxXfgYF0FkwrcuU6SyEb+VTf3BUeepNhNHyc=;
        b=CF67oMh+9c6bJrNN1PvqhBBh3BXOSocBEZFUq4wWOt9Ib5XmZae9DaD30WQ9DtZQ8R
         9Nw4r7ODXDQmhHYtVPEoseuMtDLEPwhaz0mLfOPmbW4yp/6NsYKyfrYS31mheyhq/dvh
         0PhgyWhEXV6cvMYMHO7+Ijggp6C2SC5z09x3D1BfiAZIMFJLJRNqFZva1hntH3Yy+sYj
         5qC4oKRN8q+dvHcXqhtRuI4pM1LDHcZ32Q/KiSv/Ge8NJsSnY0dVv0+owVG+mrjrlBwy
         51WzLzM2r6tEmgNLqOyyKDxqxrtJwPMXxMVXEMdGvi+5/apMSVfY4pd3VSI/NF4Kacu8
         mf8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762555828; x=1763160628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=raBRVFIoxXfgYF0FkwrcuU6SyEb+VTf3BUeepNhNHyc=;
        b=qx7NvCyRgPfgigAOUiNYSydhvlrrniZIpPShUR7mWnWI9yeSJNhSQlGDWrmy3SiQ8q
         6XnexS1QeGQV8nbjKHWmFPM9Eh4nAd9DYtQwC/xSKWdixhiSVxhc4xLLtxcZAlQIv0FK
         DI4cFs7RU/sTTZGRg2XkHOwJgACAXqwED6fI5uCfMdSQIkFi0J4r0Df7uIMUNEHAByFA
         /SCW3ydpkGNBKDh5ZlNSpAuIMOSyxt3FIhRrx8vvd2EmULHL9z/HjIfxFOSjHkGIWXJF
         84dQKKVVmTbgyKtmDvNVnBvameXALT9Omr6ELuDVYcF7iuD2bVZYl8fu3J0qRfo1OTKO
         SIAQ==
X-Gm-Message-State: AOJu0YyGRe65dNQqai7nXpxdlm3na/SY4gJTQBLGiyjWPEdUqHrgWYjK
	mEnAHzwGq8mqwlZJr8GNuDLcQiwUhvdUf+dHQ4EUb3qIrQvF0JveSe1Qp+OECKmPC4IDZjTfFz3
	kc4u6
X-Gm-Gg: ASbGncuunNxNldTaq9/5a9a5WCKGFBEqRW5uo/R2Ot1IVoz6c2NHCiCB0qFRyrMH4h9
	wySeksI1KHOgXPK6L1VrZ6lXAOzlYWW0eZ72R+hEkQIT+FrxIyTL413iXlwrR4/mqp3dr6fmBE3
	Qx4PCP9dMmWymsOPailvpTfzJJ/1GgoajU47TRqxUyzzzUmk2DenqnPPNHqpxuJsge2rJTaDBmy
	jr6MpBch0vGzLW1d1pWr9jdqQxtuwb1Ug8cYmnVfAD+7hjdTyDqbIYiSojV2+tapN7WEwD8OTJj
	thpFiqD8udZcg7B1jTriHvoab8uBNJPiwPuVpcqhmvRn2U+IEN4hG0J/0TB8Cg0Tg/WkbtKFr5j
	C+R9AfNa605lGYzMGyyYK2C+VoZcdptJRpysNgRormeLda51OYu/8RhkihKYFSq4skXCGu/O0bO
	MTvesDjrYmwxw0QYpNKNfPozVCn8vdl6j2Hla95gUmW2GaUXsFSmCrBIG/ItUFl+ay
X-Google-Smtp-Source: AGHT+IFm7+5mwYzM+NrPR3r2lO2/HN8TDlNByi59dSrMG4CDuhQ9TLgCeHpdJXuwA3iY2H9OGim97w==
X-Received: by 2002:ac8:5751:0:b0:4e8:a0bf:f5b5 with SMTP id d75a77b69052e-4eda4fd4dd3mr9303801cf.73.1762555827556;
        Fri, 07 Nov 2025 14:50:27 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eda57ad8e6sm3293421cf.27.2025.11.07.14.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 14:50:27 -0800 (PST)
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
Subject: [RFC PATCH 8/9] drivers/cxl: add protected_memory bit to cxl region
Date: Fri,  7 Nov 2025 17:49:53 -0500
Message-ID: <20251107224956.477056-9-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251107224956.477056-1-gourry@gourry.net>
References: <20251107224956.477056-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zmu1scmt1asq6i14mzr4nhrn6xhctjib
X-Rspam-User: 
X-Rspamd-Queue-Id: BFFDDC0012
X-Rspamd-Server: rspam01
X-HE-Tag: 1762555828-192234
X-HE-Meta: U2FsdGVkX18iNjvf6qgUnV0/lkjBNTLDtB1eSkoRNUDRsbnZK3SGEXBLINUXy2o62gk5s2yA4DHxY9Zvrz67Wor9FyT9umJb0vgYxeeRgvJGsHelly5eI0TBrodQFblJBT3YPSHLuNQRl3tQIc73LmVaYYlkHFKX9raiQxD+5m1eLOJXrlqIV1q20rRW0MfVQniXYSvjKV2S44FtPcktlJ3oj/qb1MPKQmn/3ys2hyyCsEMv5k/LiOsUi2ebHyA+P+4XtarWFjwILrgiO0J0YjR6682c+uhA68O/fRbgetQPiZWi3nd9CNtWZ/Tc4cdUxYLcfPjDdNKEWzi3dYJAkmKnyY+m7D3SG+UmttA/tkhc5yA16yu6Ca+nf0y2sCK301mGI6xblu6ATPd4rzAL9gGLSemTBN3lqMGOzq9yci7+sfjo4fvgfjLK03mjEjiVLKhgGV2rixPFB6F5E4e2RzcvhjyW537KJfMJIuIQxsCkCcjaZNjrAAjMu/4lvZ4Y94r7aSo9fG/SJuSSsp6zXVkQ1r9FTTI1cvjbp4jXmmA8Aq8xLp7TxE9YfL4ood8iraignYS12UYEUBJqPYR4rWn0uPXUwkswwjHWzwAXKWinV1TXhPeJbGtAC2OQQ6ZlTnfmsCDFl/UU1dPCa3c53bWXh0yAlE++1C9QGVvKtEX2QoU+mmHMqdpU3BDJ3pzklY6l5kzVJSypxf+f04AErVJCIDWk5TTgoR1/wmaJuATNA3x8bZu+R7PstuDJ+hTJ58QzSi8NVOaLb7c+eM7/mPU+QUXeaZDWGeKuHSSdy6ZtXj2agAIEv4Qz8p31uRmPAWhlY0rMjn0vOpk8z7JJ43Bl1+SqEyolXZoIeyfowMkcRMH1oDFaff994XhhpsnqiGZhHy3pnNnyuBE1l0+vPfWYqSQ/o3KiMVPN/VCnqitvoXmRPviHl1iVIfPMPHtbyjJ0kSP4pGa5BgNxG48
 wV3wGlIl
 LnSt082Su4M9q2cVR7iM/5CjBsJgJiwR8ic1LCACwtB1aaKFDyFmeB+2/f4bzeffi4myNzeQr3F2CHq9gjWb8Kj6OLCoI0XXz+/NkMR6ROgAh7hx5bkmbuj8LexaFQdixmeWOJk/62jdyRlTrje20ZnGxVd2Q1fb/buNW3B6rWiSrQ0hI4PPbCuYqvGQUFhCCXESQ9/EMcrdHPhvfesYMk8HFH/pPKf+zyDlh0POQJlLoO2uzEmHPGvCBLG0WXB7ZiFyuXDN3OEgk/Voh0zDmINPlE8GLoToVY0AQ1ZFBU2IGKgt/MqdCMzjuqocTLexyoo898ksbDyW7o3ny07RSoOBf7R4DqDsvb8qdyQC0WdfIskktQ+oE8mIQeiRhWtlkL/5qsUzTO9duqm9QJSObdKDDQHvrQ9jik9wYBsQ5X8w1YJY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add protected_memory bit to cxl region.  The setting is subsequently
forwarded to the dax device it creates. This allows the auto-hotplug
process to occur without an intermediate step requiring udev to poke
the DAX device protected memory bit explicitly before onlining.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/core/region.c | 30 ++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h         |  2 ++
 drivers/dax/cxl.c         |  1 +
 3 files changed, 33 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index b06fee1978ba..a0e28821961c 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -754,6 +754,35 @@ static ssize_t size_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(size);
 
+static ssize_t protected_memory_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	return sysfs_emit(buf, "%d\n", cxlr->protected_memory);
+}
+
+static ssize_t protected_memory_store(struct device *dev,
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
+	cxlr->protected_memory = val;
+	return len;
+}
+static DEVICE_ATTR_RW(protected_memory);
+
 static struct attribute *cxl_region_attrs[] = {
 	&dev_attr_uuid.attr,
 	&dev_attr_commit.attr,
@@ -762,6 +791,7 @@ static struct attribute *cxl_region_attrs[] = {
 	&dev_attr_resource.attr,
 	&dev_attr_size.attr,
 	&dev_attr_mode.attr,
+	&dev_attr_protected_memory.attr,
 	NULL,
 };
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 231ddccf8977..0ff4898224ba 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -530,6 +530,7 @@ enum cxl_partition_mode {
  * @coord: QoS access coordinates for the region
  * @node_notifier: notifier for setting the access coordinates to node
  * @adist_notifier: notifier for calculating the abstract distance of node
+ * @protected_memory: mark region memory as protected from kernel allocation
  */
 struct cxl_region {
 	struct device dev;
@@ -543,6 +544,7 @@ struct cxl_region {
 	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
 	struct notifier_block node_notifier;
 	struct notifier_block adist_notifier;
+	bool protected_memory;
 };
 
 struct cxl_nvdimm_bridge {
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 13cd94d32ff7..a4232a5507b5 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -27,6 +27,7 @@ static int cxl_dax_region_probe(struct device *dev)
 		.id = -1,
 		.size = range_len(&cxlr_dax->hpa_range),
 		.memmap_on_memory = true,
+		.protected_memory = cxlr->protected_memory,
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
-- 
2.51.1


