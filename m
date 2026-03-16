Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDEE1D58B37
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 05:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9496B011B; Mon, 16 Mar 2026 01:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9ABC6B011C; Mon, 16 Mar 2026 01:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69D86B011D; Mon, 16 Mar 2026 01:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B66DA6B011B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 01:13:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7DFB113C35E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:13:21 +0000 (UTC)
X-FDA: 84550757802.18.A30FF49
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7CC6280005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:13:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773637999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OtyVKpiHgwvOMDvePjA2fPbhnAqhMoIi+V/SoIKZsTM=;
	b=2nZAK/ph38zQq6572bQZTE6MsPV/jheQ63hUvWt99SBLOSMy8SBWGeCtlqZ8UEJm/qDad9
	RemxqUfjLoLlBNgsUZxHJhxrn5AokabXkIEHSh3lsBl4vOY+VY+8eXPlYwFTJsN1/vzYOx
	s/PEeZT/mtwD/WwHx+Qe+/0Fx1+iA+w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773637999; a=rsa-sha256;
	cv=none;
	b=I05W8EThS3zhIU8f+/YgYAohNtl9IU+dHh60uiW84x406ae8PlLqC+ZVVqEi0iLt9S/VzX
	ZjeSsxlyHxjYbM2/oUTjpcIrXucgOVsQooFMN0P3j+Z/hjh7QgmBCq0NPwyiGaRVAVpSRx
	vN/RKom5WyW3WsZSO6Kgr5XxFrEPD0M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-4d-69b791687819
From: Rakie Kim <rakie.kim@sk.com>
To: akpm@linux-foundation.org
Cc: gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	rakie.kim@sk.com
Subject: [RFC PATCH 3/4] mm/memory-tiers: register CXL nodes to socket-aware packages via initiator
Date: Mon, 16 Mar 2026 14:12:51 +0900
Message-ID: <20260316051258.246-4-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260316051258.246-1-rakie.kim@sk.com>
References: <20260316051258.246-1-rakie.kim@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsXC9ZZnkW7GxO2ZBk+PSVnMWb+GzeLu4wts
	FrtuhFhMn3qB0eLEzUY2i9U31zBaPN/6i9Hi593j7Bb7nz5nsVi18BqbxfGt89gttjc8YLc4
	P+sUi8XlXXPYLO6t+c9qcXLWShaLb33SFvf7HCyOrN/OZDH50gI2i9mNfYwWtyYcY7JYvSbD
	YvbRe+wOEh47Z91l91iwqdSju+0yu0fLkbesHov3vGTy2LSqk81j06dJ7B4nZvxm8dj50NKj
	t/kdm8fHp7dYPKbOrvdYv+Uqi8eZBUfYPT5vkgvgj+KySUnNySxLLdK3S+DK+HfhJ2PBDcWK
	tfcesTcwtsh0MXJySAiYSHyYcZG1i5EDzF74QRPEZBNQkji2NwakQkRAVmLq3/MsXYxcHMwC
	K1klzp/8zQySEBZIljj4YyMriM0ioCqx/mgjWJxXwFii78g5RojxmhLrNt5iAZnJCTR+2wJj
	kLAQUMm8Jx/YIcoFJU7OfAJWwiygLrF+nhBImFlAXqJ562xmkLUSAo0cEmfmP2SDGCkpcXDF
	DZYJjAKzkLTPQmifhaR9ASPzKkahzLyy3MTMHBO9jMq8zAq95PzcTYzAuF5W+yd6B+OnC8GH
	GAU4GJV4eDMObcsUYk0sK67MPcQowcGsJMK77AhQiDclsbIqtSg/vqg0J7X4EKM0B4uSOK/R
	t/IUIYH0xJLU7NTUgtQimCwTB6dUA2NPRP/DZ6uv3WQpbk67ZzWX8avfDSvX3RyZ504/mXs3
	LDqlOttAn4WZpeLkS2VLve5Vm5XjOjWFX/paMVyt3xKd8So4f+UKtqdyjvvio6f907i0zz/o
	Y0yZYE4nr2ri4jsbbjD7VEi9tJ9TlNqc9CHvCIeQyC7HDKmX7RoSthP2qr9KVb64WImlOCPR
	UIu5qDgRAH3R3NDnAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYQCG+XbOzjmuFmfL8KDZZV3MKE0s+CIpicKP6IeQIIihSw9uualt
	ahpIEyVMa2kl6WY2sSSnbTjSqZXWnJeZOEkcajkzNbvjDcu0bDMi/70878P756UwoR33pqRJ
	qawiSSwTETycV+IXvV9SZJYeaBrbAMuMtQQcGe8jYPNgBOy9rSXgneI+ALuGsglYM1QL4FT9
	TwAXRzpJOPf+MwZbJ6dwqK9wELCzvpyEbXdtXGhWvSWhXdONw/7mMgI6a1e40KapxuGC2geO
	qkOhxTHFhVajmQNvvdIRUJutBnC4sIMDa2olcKnhoQu1O8lQX9SkGSGRzpSGCq70kyjX+pWL
	Kp9+5CCT/iqBTLM3SdRVsoSjprHD6HrONwLNTA7jaOE1QpUfpjmoWHsZGR8P4KhHZyXDBVG8
	kHhWJk1nFYFHY3mS332LIGVwe8Yj5ztSBXI35wOKYuiDTMW0vzsStIjpeBadDzwoT9qXKf5l
	x/MBj8Loai5jty1h7mIjHce8+FHHdWec3sUY27NXOZ8OZtTWXuDODO3PGOqGcfemh2u+QRfs
	xkKXUj4xTf7VBYytdGJVwWg/xlgudGOM3srk1GuxQsDXrLE0/y3NGksHMD3wlCaly8VS2aEA
	ZaIkM0maERCXLDcB181VWctFjWC+P8wCaAqI1vMllgapkCtOV2bKLYChMJEnv8rqQvx4ceYl
	VpEco0iTsUoL8KFwkRf/VCQbK6QTxKlsIsumsIp/LYfy8FYBr8CKPgM5PTECLWHHugVnI5df
	nh4VGO7PylucX0r5hvO2LQOqgrjMqLyorFRTzHPszE69gx12ptzbExLCDxo8ua/qeNuJTcvr
	gi+GXvh+bceTI+bxNDwhpK0mry4npnEm40G+800gijgX0Tq3wji2OW6U7p4X+BZ0tnzq6dGq
	w0W4UiIO2osplOI/Gka6rOICAAA=
X-CFilter-Loop: Reflected
X-Stat-Signature: h9i3nomputg5whanzgyotuywamz3ih74
X-Rspam-User: 
X-Rspamd-Queue-Id: 7CC6280005
X-Rspamd-Server: rspam12
X-HE-Tag: 1773637999-328534
X-HE-Meta: U2FsdGVkX18SfcH0xsqG/NAftsh/GNk8RIjV5yUdRDWrwRNfFkkbkEQOOgyyKfG/OF3shgMd6LGruEl7huvzeFf83Ij+d1l0b3dmIWjCjPBKpGGqqSu75ogtpL3poDUy9zLfiewZU6igQmiY+ohBARgdpF5HgRrQ4E4iKjRDtzOAyCU4cC7Uc0wRrQV2LRngsn2hTcTt3dYGjxjI0pROxX08wDESyfMAJUiU7ieFrKkeGRUS384IKsOmvVu1tQlFak3fnUzLDYqiIn1uSrcIEx0iIEElkliQzQXk91IK/Yc15hjhcm6qd+XxeIXBPQwPfYKKclbwAto6/WeJ4omTngAnpRhKlC1OIWPSYHmGJ7AfQDIAxZRayytMn2Xma356upeMT+fixiWfMTrwGhPXPOeCnEAXuAbF6yc5vM2bT8jfVybPGdmBNStRRHHENXecfk230xVbZbFwrK1jZ0B1CeTRqrhxEUwPgD4Uqlcf1C6R+SLjlBLokESq9vcjGwiU0jKQMQaVVbMS+FRg7pfpK6XX9DnHPXlx6wl3PKUaeInIpZJEStgrdRY8GJriNyfYquY81q1IuY6v/wg21XmVVTyRAW7W+20vuMFaToUN4/BFLXPoQQM0hqACn5dMhiI4sT5RJlDrTm2Q7LPZKnRncZu3fj1qOUDynvtLD0C/sbPC88zUV11oBQnKfqse6WmP2DKtYLURGECXlK0fTntPu9R6w6NJMpq0YuX+2FTsDP+8TlTZifXgUQDFmYr/K1ooGzG5ILQtgT162wXadi66ISexdQVAIjoTbHusHjNnfsnOJ74+NnObsPb4cgYi77u8nGPXZeWiHMyaVxZd8fSwabqj2OGcpn/d17+E329HVdpl8VliqEYVQNiquTH1/+RW4qUnScJb5Eq3KrOidhG3ftRiwK/s2SNv8jcPzv/ylZgJtKBALMirCMB83BKeRp/ZuX02JXTKdTmINjM6VrC
 1lrC9066
 Nr+iX+EnO4aQ8qK9hb5ZMFRWik/1prwhm2R5jfZrmARQl2C2XFr3QlSI8+GLO6t58bV80PQfowOZv3lDno+hipFxwG2lqJQV7OPyTkaFBFscPtkA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CXL memory nodes appear without an explicit socket association.
Relying on plain NUMA distance does not convey which physical package
(CPU socket) they should belong to, which in turn makes locality-aware
placement ambiguous.

This change introduces a registration path that binds a CXL memory node
to a socket-aware "memory package" using an initiator CPU node. The
initiator is the CPU nid that best represents the host-side attachment
of the region (e.g., the CPU closest to the region’s target). By using
this nid to resolve the package, the CXL node is grouped with the CPUs
it actually services.

The flow is:
  - Determine an initiator CPU nid for the CXL region.
  - Register the CXL node with the package layer using that initiator.

This provides a deterministic and topology-consistent way to place CXL
nodes into the correct socket grouping, reducing the risk of inadvertent
cross-socket choices that distance alone cannot prevent.

Signed-off-by: Rakie Kim <rakie.kim@sk.com>
---
 drivers/cxl/core/region.c | 46 +++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h         |  1 +
 drivers/dax/kmem.c        |  2 ++
 3 files changed, 49 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 5bd1213737fa..2733e0d465cc 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2570,6 +2570,47 @@ static int cxl_region_calculate_adistance(struct notifier_block *nb,
 	return NOTIFY_STOP;
 }
 
+static int cxl_region_find_nearest_node(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	struct cxl_endpoint_decoder *cxled = NULL;
+	struct cxl_memdev *cxlmd = NULL;
+	int i, numa_node;
+
+	for (i = 0; i < p->nr_targets; i++) {
+		cxled = p->targets[i];
+		cxlmd = cxled_to_memdev(cxled);
+		numa_node = dev_to_node(&cxlmd->dev);
+		if (numa_node != NUMA_NO_NODE)
+			return numa_node;
+	}
+	return NUMA_NO_NODE;
+}
+
+static int cxl_region_add_package_node(struct notifier_block *nb,
+				       unsigned long dax_nid, void *data)
+{
+	int region_nid, nearest_nid, ret;
+	struct cxl_region *cxlr = container_of(nb, struct cxl_region, package_notifier);
+
+	region_nid = phys_to_target_node(cxlr->params.res->start);
+	if (region_nid != dax_nid)
+		return NOTIFY_DONE;
+
+	nearest_nid = cxl_region_find_nearest_node(cxlr);
+	if (nearest_nid == NUMA_NO_NODE)
+		return NOTIFY_DONE;
+
+	ret = mp_add_package_node_by_initiator(dax_nid, nearest_nid);
+	if (ret) {
+		dev_info(&cxlr->dev, "failed add package node (%lu), nearest_nid (%d)\n",
+			 dax_nid, nearest_nid);
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+
 /**
  * devm_cxl_add_region - Adds a region to a decoder
  * @cxlrd: root decoder
@@ -3788,6 +3829,7 @@ static void shutdown_notifiers(void *_cxlr)
 
 	unregister_node_notifier(&cxlr->node_notifier);
 	unregister_mt_adistance_algorithm(&cxlr->adist_notifier);
+	unregister_mp_package_notifier(&cxlr->package_notifier);
 }
 
 static void remove_debugfs(void *dentry)
@@ -3940,6 +3982,10 @@ static int cxl_region_probe(struct device *dev)
 	cxlr->adist_notifier.priority = 100;
 	register_mt_adistance_algorithm(&cxlr->adist_notifier);
 
+	cxlr->package_notifier.notifier_call = cxl_region_add_package_node;
+	cxlr->package_notifier.priority = 100;
+	register_mp_package_notifier(&cxlr->package_notifier);
+
 	rc = devm_add_action_or_reset(&cxlr->dev, shutdown_notifiers, cxlr);
 	if (rc)
 		return rc;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index ba17fa86d249..6b6653e31135 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -551,6 +551,7 @@ struct cxl_region {
 	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
 	struct notifier_block node_notifier;
 	struct notifier_block adist_notifier;
+	struct notifier_block package_notifier;
 };
 
 struct cxl_nvdimm_bridge {
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index c036e4d0b610..32ee66b82cd3 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -94,6 +94,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (IS_ERR(mtype))
 		return PTR_ERR(mtype);
 
+	mp_probe_package_id(numa_node);
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range range;
 
-- 
2.34.1


