Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6FAC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 08:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECDA08E0002; Wed, 23 Jul 2025 04:03:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7F2E8E0001; Wed, 23 Jul 2025 04:03:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6BF88E0002; Wed, 23 Jul 2025 04:03:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0F5B8E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:03:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E0241A05F9
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:03:55 +0000 (UTC)
X-FDA: 83694790830.07.10E7B0B
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4E30640008
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:03:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=quicinc.com header.s=qcppdkim1 header.b=Bken3hVr;
	spf=pass (imf27.hostedemail.com: domain of quic_zhenhuah@quicinc.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=quic_zhenhuah@quicinc.com;
	dmarc=pass (policy=none) header.from=quicinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753257833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=P+/vDhWzzZpXY5cDW7/Gh1z1gwgrP2mpHSIozXcvJEc=;
	b=725RAL73zw/JGwu79NR5eF2GC+LTBGL9oYmikKRv2Rh/eb2FHD2TIYgXqnnASIfCXlIAnb
	XU6qljyh7UzMpkc6HHmHE7mtECseiJv+eQH+A8hHbG2UO3PNhcwdZ/vVMPj1WHy0NfMbEz
	CeAQELgl9nh6yTPPDZmfm44HktbNVIg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753257833; a=rsa-sha256;
	cv=none;
	b=kT8LP00IIgp43XkPjygao9kf3pTh+i6sGgfxYfHDgqYwLWWhdU5xIN7mtdtwmB0FEg4bDj
	Vy/8rkPsxf9zg0k+GhrNeml/G8//MrmrRFk4OQaOBm+UFD4WdQhHCc/ICn2eud0ABPwQH3
	dluHjGW764HNv9yB5QtBd5Ry0GjFY4M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=quicinc.com header.s=qcppdkim1 header.b=Bken3hVr;
	spf=pass (imf27.hostedemail.com: domain of quic_zhenhuah@quicinc.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=quic_zhenhuah@quicinc.com;
	dmarc=pass (policy=none) header.from=quicinc.com
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MMcTHT013546;
	Wed, 23 Jul 2025 08:03:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=P+/vDhWzzZpXY5cDW7/Gh1
	z1gwgrP2mpHSIozXcvJEc=; b=Bken3hVr/gH3J6e8o9YKyB/WI9J9n7Zc0AnBbe
	S5cl4hgYM/aWpU9elI9m6gfphT0IkhRm57QtruAFWH5IGxYBtwmjhAFB2TzDknmo
	pMVQtr+9tlLv4UCGORLHtwG7huy+rEMlYDPcirbCBfShXIggNBO1PMrB/ixU2IO7
	airvL3P+hqsMpCdMgzsCfWomHwHzqT0ujfWiqjG9San2GyDdiWGTYQv0JtEBC8/c
	rm83Rbgzo8m2YU2VHO8Skvje31KgZrIGHmHLIPHFWF787srQnbuDhTsqsQUYS2YT
	Mjol6EBIo5Lb7u1il692OnHd+sOjfLLRUksyz8YEmkGokWIg==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 481qh6phu4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Jul 2025 08:03:50 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 56N83n6Z013821
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Jul 2025 08:03:49 GMT
Received: from ap-kernel-sh01-lnx.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 23 Jul 2025 01:03:45 -0700
From: Zhenhua Huang <quic_zhenhuah@quicinc.com>
To: <kent.overstreet@linux.dev>, <rientjes@google.com>, <vbabka@suse.cz>,
        <cl@gentwo.org>, <roman.gushchin@linux.dev>, <harry.yoo@oracle.com>,
        <surenb@google.com>, <pasha.tatashin@soleen.com>,
        <akpm@linux-foundation.org>, <corbet@lwn.net>
CC: <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <quic_tingweiz@quicinc.com>,
        Zhenhua Huang
	<quic_zhenhuah@quicinc.com>
Subject: [PATCH 1/1] mm: slub: Introduce one knob to control the track of slub object
Date: Wed, 23 Jul 2025 16:03:28 +0800
Message-ID: <20250723080328.4012263-1-quic_zhenhuah@quicinc.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=CZ4I5Krl c=1 sm=1 tr=0 ts=68809766 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=COk6AnOGAAAA:8
 a=g59Dnr5a0EmcSpW2U7wA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: NyNZH3-0WF9O0-zrUAXttvL4E4TNg1kH
X-Proofpoint-GUID: NyNZH3-0WF9O0-zrUAXttvL4E4TNg1kH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDA2NyBTYWx0ZWRfX1PYBy0xpN3De
 QGDXadJqH1Wz9AEg6o9WCavkgIfsJ1akkEBLEeNqdIOFgwiqvUgLNuIvvbH/Yghjey3tnkuZb8g
 U9f1XQVkJwe5lFcr86w3QakLHyYwe0WJQJKf73joC9sUCm4Lz9DQI7YU8glWL1opwxeDQTMNwxo
 PZb9A/plXD88q6rBsv9RlXGsWXsqRLP5Dsa3s8ixwdkcEXqWFulkmC0ci9Rf9eQM8XDpf93ODog
 PqKf5i9YieExZPcdr0/UlWBhURbctF9+9H4I59bVDm1XV6fffpxrrfY8JdNU9wW6pVu2NBNqY1a
 2vM3Qhn4A/aIdsX3+CxbLsUYZYOFuOlZiPD/VRQpG9dybw8wZX+1wUVBhr09T/kqtdYmdH/UNnX
 KZ6GNL+kHnCAYJ0dJS9BjCW+ElboWsH+8qoNTsxy6SYapC8BXplDmiSbK/LKavUND0tJC+Ix
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_01,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1011 mlxscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2507230067
X-Rspamd-Queue-Id: 4E30640008
X-Stat-Signature: x4p6tdkngn8rgxkbui7i49ion7imste9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753257833-306504
X-HE-Meta: U2FsdGVkX1/Ar1jYL6vBzSPIKynudwC7az24i/Kh7/uxcSktZSMjbVTiCPeNJWSVeVNfPRsM1umBVVIvHgtNrWM04FWWGYUSaVP/2Ij/4ShUQqGgUemgFcNCQ2C9qcWpJxegozjSPJRoAUzDaxRxifAfqD7rblpgF+mNh/N+q/yXuhXiT8nRXiPr2qlMgDfm7IZm+Ty/Tb4HpgJQdQvAIVTgAd0+yjTYRcL8GGNQot0In5TnqsT3LZsEmzZQSmL2e+QWyt7qUhO8Gd0/m3ZRxnUdKUC5ALOPCl/u62qMtG7cl5DVySHOX/otQMrrvfZiXL5AV4geJTUT7uFFtcCiETJPaMBEDmPO8IjdZbeQT8B6v9vqF0Oh9ks7d74bghX8t8gP++IVV08bX5Tpl0bQbRu4v9T0O68pP2eHWF2KykHiueXGp/DfLrnZzdArRt3pXDlqMgu1D/ALuMQV3p+PiLl9K8x4tPohusYUIE0/pM0hqx35V7TvEcFaCzqiBUHwrg7r4FrMW3EVNlxgfXxQCApeGRetXB9dmL6nb4ly7il4wtJuEsRyFWge/DwgbPQwOXWSVcV7VNQRON8ghCsRA6J+sTUDxwDfLC97dilKVsvYw0Uzd7f9R7vWrtbG/n05FcWSmGpORsNc6q3aUACFDS0u6gSGKvs5Z7JjkoRPyV/lExklN+fLIxMNWFyIqSXhTTSz978EUN1fn+Pt7I2o6mmFteCVDzeK+aHnnDUHoEADfdNEMrGTILtLt4hW040+vGw2r/DCiWz3iqMOiwzAHj6VCxbQbhafA+5eTU3QFGUMe6oA+pgseRwe0MCi4Av9G7ErO2K38Z4fF/jcbwAoNKGqODZoh0fklX9guwSe3P5ETtnTKnimiK7MkIYVSjm5SWCeoqThWwk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mem profiling feature tracks both "alloc_slab_page"(page level) and slub
object level allocations. To track object level allocations,
slabobj_ext consumes 16 bytes per object for profiling slub object if
CONFIG_MEMCG is set.
Based on the data I've collected, this overhead accounts for approximately
5.7% of slub memory usage — a considerable cost.
w/ noslub  slub_debug=-
Slab:              87520 kB
w/o noslub slub_debug=-
Slab:              92812 kB

While In some scenarios, we may choose not to delve into SLUB allocation
details if initial triage indicates that SLUB memory usage is within
acceptable limits. To support this, a control knob is introduced to enable
or disable SLUB object tracking.
The "noslub" knob disables SLUB tracking, preventing further allocation of
slabobj_ext structures.

Signed-off-by: Zhenhua Huang <quic_zhenhuah@quicinc.com>
---
 Documentation/mm/allocation-profiling.rst |  7 +++++-
 include/linux/alloc_tag.h                 |  8 +++++++
 lib/alloc_tag.c                           | 26 +++++++++++++++++------
 mm/slub.c                                 | 10 ++++-----
 4 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
index 316311240e6a..9ecae74e0365 100644
--- a/Documentation/mm/allocation-profiling.rst
+++ b/Documentation/mm/allocation-profiling.rst
@@ -18,7 +18,7 @@ kconfig options:
   missing annotation
 
 Boot parameter:
-  sysctl.vm.mem_profiling={0|1|never}[,compressed]
+  sysctl.vm.mem_profiling={0|1|never}[,compressed][,noslub]
 
   When set to "never", memory allocation profiling overhead is minimized and it
   cannot be enabled at runtime (sysctl becomes read-only).
@@ -30,6 +30,11 @@ Boot parameter:
   If compression fails, a warning is issued and memory allocation profiling gets
   disabled.
 
+  The optional noslub parameter disables tracking of individual SLUB objects. This
+  approach, similar to how page owner tracking works, relies on slub_debug for SLUB
+  object insights instead. While this reduces memory overhead, it also limits the
+  ability to observe detailed SLUB allocation behavior.
+
 sysctl:
   /proc/sys/vm/mem_profiling
 
diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 8f7931eb7d16..af3c139712ce 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -134,6 +134,13 @@ static inline bool mem_alloc_profiling_enabled(void)
 				   &mem_alloc_profiling_key);
 }
 
+DECLARE_STATIC_KEY_TRUE(slub_mem_alloc_profiling_key);
+
+static inline bool slub_mem_alloc_profiling_enabled(void)
+{
+	return static_key_enabled(&slub_mem_alloc_profiling_key);
+}
+
 static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
 {
 	struct alloc_tag_counters v = { 0, 0 };
@@ -227,6 +234,7 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
 
 #define DEFINE_ALLOC_TAG(_alloc_tag)
 static inline bool mem_alloc_profiling_enabled(void) { return false; }
+static inline bool slub_mem_alloc_profiling_enabled(void) { return false; }
 static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
 				 size_t bytes) {}
 static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 0142bc916f73..b79b0d987427 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -33,6 +33,8 @@ DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 EXPORT_SYMBOL(mem_alloc_profiling_key);
 
 DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
+DEFINE_STATIC_KEY_TRUE(slub_mem_alloc_profiling_key);
+EXPORT_SYMBOL(slub_mem_alloc_profiling_key);
 
 struct alloc_tag_kernel_section kernel_tags = { NULL, 0 };
 unsigned long alloc_tag_ref_mask;
@@ -710,6 +712,7 @@ static inline void free_mod_tags_mem(void) {}
 static int __init setup_early_mem_profiling(char *str)
 {
 	bool compressed = false;
+	bool noslub = false;
 	bool enable;
 
 	if (!str || !str[0])
@@ -725,16 +728,19 @@ static int __init setup_early_mem_profiling(char *str)
 		if (kstrtobool(token, &enable))
 			return -EINVAL;
 
-		if (str) {
-
-			if (strcmp(str, "compressed"))
+		while ((token = strsep(&str, ",")) != NULL) {
+			if (strcmp(token, "compressed") == 0)
+				compressed = true;
+			else if (strcmp(token, "noslub") == 0)
+				noslub = true;
+			else
 				return -EINVAL;
-
-			compressed = true;
 		}
 		mem_profiling_support = true;
-		pr_info("Memory allocation profiling is enabled %s compression and is turned %s!\n",
-			compressed ? "with" : "without", enable ? "on" : "off");
+		pr_info("Memory allocation profiling is enabled %s compression, %s slub track and is turned %s!\n",
+			compressed ? "with" : "without",
+			noslub ? "without" : "with",
+			enable ? "on" : "off");
 	}
 
 	if (enable != mem_alloc_profiling_enabled()) {
@@ -749,6 +755,12 @@ static int __init setup_early_mem_profiling(char *str)
 		else
 			static_branch_disable(&mem_profiling_compressed);
 	}
+	if (noslub == static_key_enabled(&slub_mem_alloc_profiling_key)) {
+		if (noslub)
+			static_branch_disable(&slub_mem_alloc_profiling_key);
+		else
+			static_branch_enable(&slub_mem_alloc_profiling_key);
+	}
 
 	return 0;
 }
diff --git a/mm/slub.c b/mm/slub.c
index 31e11ef256f9..e8378b092b30 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2093,7 +2093,7 @@ prepare_slab_obj_exts_hook(struct kmem_cache *s, gfp_t flags, void *p)
 	return slab_obj_exts(slab) + obj_to_index(s, slab, p);
 }
 
-/* Should be called only if mem_alloc_profiling_enabled() */
+/* Should be called only if slub_mem_alloc_profiling_enabled() */
 static noinline void
 __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
 {
@@ -2102,7 +2102,7 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
 	obj_exts = prepare_slab_obj_exts_hook(s, flags, object);
 	/*
 	 * Currently obj_exts is used only for allocation profiling.
-	 * If other users appear then mem_alloc_profiling_enabled()
+	 * If other users appear then slub_mem_alloc_profiling_enabled()
 	 * check should be added before alloc_tag_add().
 	 */
 	if (likely(obj_exts))
@@ -2112,11 +2112,11 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
 static inline void
 alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
 {
-	if (mem_alloc_profiling_enabled())
+	if (slub_mem_alloc_profiling_enabled())
 		__alloc_tagging_slab_alloc_hook(s, object, flags);
 }
 
-/* Should be called only if mem_alloc_profiling_enabled() */
+/* Should be called only if slub_mem_alloc_profiling_enabled() */
 static noinline void
 __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 			       int objects)
@@ -2143,7 +2143,7 @@ static inline void
 alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 			     int objects)
 {
-	if (mem_alloc_profiling_enabled())
+	if (slub_mem_alloc_profiling_enabled())
 		__alloc_tagging_slab_free_hook(s, slab, p, objects);
 }
 
-- 
2.34.1


