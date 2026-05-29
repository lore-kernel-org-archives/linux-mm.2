Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5C84CD6E4C
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037256B0088; Thu, 28 May 2026 23:21:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED3E06B008A; Thu, 28 May 2026 23:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF0F6B008C; Thu, 28 May 2026 23:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BED6C6B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:21:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C9839B18D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:12 +0000 (UTC)
X-FDA: 84819006384.25.4652A16
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8076510000E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OkyU6r+C;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780024870; a=rsa-sha256;
	cv=none;
	b=yBIteD+BrVhs8vU+SytGNwkEOcgDZG8v4rl75gul1F9JgfPqxQ8XVqL7xdkHPrvF+SoLie
	AOviHbU/z22dfQHHw1dAEOTiJEcg0fv8FxDWxjN6CxpModTRKiwxLbp8yi4VqHHgCr27xo
	OYAVaZNAE0ERfOfjnnVReTSfNOoPNX4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OkyU6r+C;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780024870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUrKJoDYrQkjTLkL3MuZp6oC7EFU1kzzmwsnuISmv5A=;
	b=8ihfuGjN3I3w9yJc2X1MYuUlnanVYqLtpaNDSCcrUHIsy2rQOd/VA+Xsg7aRy8TgrAO1K4
	0vGeItn1BqEtn4Fl+oc77yBSzMLMN+Y7ly/OPoidLzRAoMqjWtmsHFooueBi5eJKUyzYW2
	AOciHdRm/iicTPvDgqVQI0CC7pJh8VY=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8b4eb1fd5d0so162742376d6.0
        for <linux-mm@kvack.org>; Thu, 28 May 2026 20:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780024869; x=1780629669; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CUrKJoDYrQkjTLkL3MuZp6oC7EFU1kzzmwsnuISmv5A=;
        b=OkyU6r+COAa82A0/OAcWYDu33gjR1JR9gA2URZ9jvYADJOAeApiAPT/jSdxxp88ypY
         vX0ltYw8mcMYDcTQftvRGTeqKZGZ4Zh6FjCCbtExeztqB1dbt6FVrQ1Nzr2wsXsWiVIQ
         f5AuZJ4MLnY519NRR4gpXwuOGc6Gjcc2YKyIv0ItHvPji6xaXHmlvUaEvbu6dhvPaRk/
         wTzYe7JQY1agT2rN6Ss82khWssJOQhrjsXMkeEfmI5XjrwntRu5ol14dImxnwEHRZ113
         V2FOeO9QGp8bX8qzYkrJfygXiHOIhGijv/tw0UcKi4Tg3INxmemkBLQO94bn7d5gFopt
         zLUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780024869; x=1780629669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CUrKJoDYrQkjTLkL3MuZp6oC7EFU1kzzmwsnuISmv5A=;
        b=T6sHSPElnpqDDsStt4rEgOGPTmJAnJOtaNds/QORFyNWFzYfH+mcvAWSE4T0FFYSK2
         B+0svo1ypaIQalJzStNv9P3A1DREvRpZeSbubB7YZs7L+DJUDG871t5Q8GfCL8ICss1+
         in6EG3Cbc8rvnU1bnVwh7hbW/5+1XjIHD97eRqiQQ0+6QyPBAEt8Cig97EfKS/dup/9O
         ixJybjaO879EqUsvL3UHFqYiDhDEOSaSw3wSzEfu2rdkq0G54Uqt81st3x/U1Ubo+rlS
         Kq1PZO/rLleT1W2PaUL4hY217CjTejH5jgpAD+7NoO83FBAcLwIuFzbyM54Y2Me39RXD
         vHGw==
X-Forwarded-Encrypted: i=1; AFNElJ9uEOMGE+VJZY9tHFeMyESe4FkTtXfesTSAgvrnoQzpWxeaAa8GVJFl7oepHHhR6cXOrf8gZnX8Xg==@kvack.org
X-Gm-Message-State: AOJu0YxENfLPKf/4gwAkEAoT0kfo412N3/ztO8yuCo/VNEtjhh/Etbh8
	gmPWtk/uyoqFGtx/euOavssZffOctqNVAcVJm+OtTeGwCMyfkmhyOOpRMhzoptcu5Xk=
X-Gm-Gg: Acq92OEZDwXwOJsvoJCAMMU0SZWcZOFNMg3iMEsHk0eW0s4gf5gIxFC/2d617Bnr8FI
	QI6IwUJTiCRDaSyR+RlkCeWVqj4wcbYLNqaRWdkNdEaPepjfCKj6upG9NAo2bwPXjfm+YyPE7Bg
	9GEbulG1AVzV4c9Xqfwjv7kKUjmQ9vMQITnzcMVudmLnwTGyI/luuW+ZZu00vZjEXyUEQjChn9C
	k/zi3e5Jv9Ldb9Fh7on6ghAPES24cYJqgPRHn6Arwf8kjZjM/zB5rUaYixKP+AiIxkjJBUF5Zq2
	K7bwqREBdupqEmuqsIMGWvFhtRNBIe9Z23z98KdnhdLrlXxPqZ8PYuDTauvo2OLkkPh0CR89Sd8
	XhaTsR3A0HmZqZ/iTA0YU0pmoC0Z/+b2qTBgzozyYLD0xro9I7oZC8GRf2XBjCF8gY2+ElNbt2U
	fQ9bII8vYhw4eDmAt9endxh9+OHeflwfzXcz9XuIz0Rq5Tcd+8pivM59DQlFEkrw==
X-Received: by 2002:a05:6214:3d97:b0:8ba:3fc9:88ca with SMTP id 6a1803df08f44-8cce82758d4mr12346736d6.39.1780024869500;
        Thu, 28 May 2026 20:21:09 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea26d286sm1179476d6.48.2026.05.28.20.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 20:21:09 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v3 01/11] liveupdate: centralize state management into struct luo_ser
Date: Fri, 29 May 2026 03:20:56 +0000
Message-ID: <20260529032106.1505796-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
References: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8076510000E
X-Stat-Signature: m8nw4pyz8q7ezj7iymcxkb3rcgda3umq
X-HE-Tag: 1780024870-765876
X-HE-Meta: U2FsdGVkX1/2hbpG5DhGPG+ZtGTTckYbEuJC1KI12BedFUYEL7THpaS5xorVURrfs/fEpNM75H6Ub1q4kNk8sTdAL+2+YC38TL3mjcrtsDL5W5fOHJNWW56EIVF2aLAOWad6e0uyNcZBIshUc0fZxnEERRXOXzyc5THb3/V+M88MrPxhVJl4kSAZF6BCyPT+eYDwEr1uKaxAHewDt+pYsbMryt9Kc6OZv1ddYsi5tRIPdAAQFcZfYiDnDHImibCteviTk8I8HVuCkGOiohY6Cdl6I+YwJadL3S2K2d6ES6ZD6UTgYXxZ85/e0wU8GZChuF0wSfIXENwNaVSF1nlcBGsbxhvQpwRXSghrTrU+yf8xyNYcZ3iGZFOLOjDWG0JY146yrVkH8kdWI/iByDiY5e2eUiokAzrGrFLg9X58Z8O7cXIvlQ8JkEBsGKV94d8aPehZsLdW6kOI8K9CrT4MlOfyOlMvqtk/GShWgHbftj5m7toMT+ValR32KraeazIpn3Axbc17FqzxCWIl1OKa6pre3G6He5kjZU5hA7I2WXKqv8CfOW7M1dp6B9ca+Dkx5Rw8aDHUf0SpstLdDH2JAKAH1ZUoNRMS91rwciB85Rzz9Qh2CgToTXn8+lUSqFCg1d+JeztgXLUGe5Tl+kQ4h0H3O7+jG9LmzMfrRbqXcEnrUZjPOfZC6AUNmmXn4jpQmE3amY1XPZbZl+60D/xqcS4RbaAxRlJJLUkcUvByN1rO1hTFEvHxKKM4Rlmg+AjZ5eS5MgX0nWAvtH+SpTNm8Hu1mJWvoNOH9VINcElnzB8gCMZmYqOzG5Z3UHAvTWiWxzGHtws4kU/jRvpc7EN42dRCAtae6EcclQkZb8/UOcRG9KrBOnlSmXIIQm2t5pUdCH+C56cLiL6mA9K9SxurdWOQsNDx6zm+SM5Ct7W2M63CQOdc92Guh3sb0daS1iMB116+T/b041YE6y/pTLN
 HTHMSfqI
 miR8LpxTLvTaZd8uB7IiAUTHPaAsfMESEVcsxVwFmoIpnUEagc/34WNg1v8Yg+86MEi4Nc5GMLQUCCt9Orh3Pdc4FMt4Xy5UWL1qHmAeVZZyS2x/uGZfx2BZpFTZCemOPwxni7MdPLCOnQQrpx/S2BfBfp38PRYd1OE9cJKzueGV2K7NLGzm+osdSEpT/dxA7tIWVh9oS7txpXhFuVtbMtPi1gsosxcjHSbTleWIFXfo2ylcZh+pXkFPsU910dzh6UtPW8IeU11Qn4zSzjbo3Znf4bgYzg2HOj1hxt5m0OQN5dC5UMG+4J57+9UD9fGfzaf4V7rFYtJwED6DYeKH0PBzsjB6YTNna2htOV/ZiPd0Zu5EFfdtky6TlDh632qoM6/yeR2k361a33km8DBAT1+Q8TeaeAdWkO7nNdlsmSnxg/XMg7xhH+tYKe4B160chBomeLVqBAxRadE40rLsiopek4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Transition the LUO to ABI v2, which centralizes state management into a
single struct luo_ser header.

Previously, LUO state was spread across multiple FDT properties and
subnodes. ABI v2 simplifies this by placing all core state, including
the liveupdate number and physical addresses for sessions and FLB
headers into a centralized struct luo_ser.

Note that this change introduces a semantic difference: the sessions
and FLB serialization formats are no longer completely independent of
the core LUO. Their metadata (such as physical addresses for sessions
and FLB headers) is now coupled to and managed via the centralized
struct luo_ser.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/luo.h      | 91 +++++++++++---------------------
 kernel/liveupdate/luo_core.c     | 60 ++++++++++++++-------
 kernel/liveupdate/luo_flb.c      | 65 +++--------------------
 kernel/liveupdate/luo_internal.h |  8 +--
 kernel/liveupdate/luo_session.c  | 64 ++++------------------
 5 files changed, 94 insertions(+), 194 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 46750a0ddf88..1b2f865a771a 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -30,52 +30,25 @@
  *   .. code-block:: none
  *
  *     / {
- *         compatible = "luo-v1";
- *         liveupdate-number = <...>;
- *
- *         luo-session {
- *             compatible = "luo-session-v1";
- *             luo-session-header = <phys_addr_of_session_header_ser>;
- *         };
- *
- *         luo-flb {
- *             compatible = "luo-flb-v1";
- *             luo-flb-header = <phys_addr_of_flb_header_ser>;
- *         };
+ *         compatible = "luo-v2";
+ *         luo-abi-header = <phys_addr_of_luo_ser>;
  *     };
  *
  * Main LUO Node (/):
  *
- *   - compatible: "luo-v1"
+ *   - compatible: "luo-v2"
  *     Identifies the overall LUO ABI version.
- *   - liveupdate-number: u64
- *     A counter tracking the number of successful live updates performed.
- *
- * Session Node (luo-session):
- *   This node describes all preserved user-space sessions.
- *
- *   - compatible: "luo-session-v1"
- *     Identifies the session ABI version.
- *   - luo-session-header: u64
- *     The physical address of a `struct luo_session_header_ser`. This structure
- *     is the header for a contiguous block of memory containing an array of
- *     `struct luo_session_ser`, one for each preserved session.
- *
- * File-Lifecycle-Bound Node (luo-flb):
- *   This node describes all preserved global objects whose lifecycle is bound
- *   to that of the preserved files (e.g., shared IOMMU state).
- *
- *   - compatible: "luo-flb-v1"
- *     Identifies the FLB ABI version.
- *   - luo-flb-header: u64
- *     The physical address of a `struct luo_flb_header_ser`. This structure is
- *     the header for a contiguous block of memory containing an array of
- *     `struct luo_flb_ser`, one for each preserved global object.
+ *   - luo-abi-header: u64
+ *     The physical address of `struct luo_ser`.
  *
  * Serialization Structures:
  *   The FDT properties point to memory regions containing arrays of simple,
  *   `__packed` structures. These structures contain the actual preserved state.
  *
+ *   - struct luo_ser:
+ *     The central ABI structure that contains the overall state of the LUO.
+ *     It includes the liveupdate-number and pointers to sessions and FLBs.
+ *
  *   - struct luo_session_header_ser:
  *     Header for the session array. Contains the total page count of the
  *     preserved memory block and the number of `struct luo_session_ser`
@@ -109,13 +82,26 @@
 
 /*
  * The LUO FDT hooks all LUO state for sessions, fds, etc.
- * In the root it also carries "liveupdate-number" 64-bit property that
- * corresponds to the number of live-updates performed on this machine.
  */
 #define LUO_FDT_SIZE		PAGE_SIZE
 #define LUO_FDT_KHO_ENTRY_NAME	"LUO"
-#define LUO_FDT_COMPATIBLE	"luo-v1"
-#define LUO_FDT_LIVEUPDATE_NUM	"liveupdate-number"
+#define LUO_FDT_COMPATIBLE	"luo-v2"
+#define LUO_FDT_ABI_HEADER	"luo-abi-header"
+
+/**
+ * struct luo_ser - Centralized LUO ABI header.
+ * @liveupdate_num: A counter tracking the number of successful live updates.
+ * @sessions_pa:    Physical address of the first session block header.
+ * @flbs_pa:        Physical address of the FLB header.
+ *
+ * This structure is the root of all preserved LUO state. It is pointed to by
+ * the "luo-abi-header" property in the LUO FDT.
+ */
+struct luo_ser {
+	u64 liveupdate_num;
+	u64 sessions_pa;
+	u64 flbs_pa;
+} __packed;
 
 #define LIVEUPDATE_HNDL_COMPAT_LENGTH	48
 
@@ -147,15 +133,6 @@ struct luo_file_set_ser {
 	u64 count;
 } __packed;
 
-/*
- * LUO FDT session node
- * LUO_FDT_SESSION_HEADER:  is a u64 physical address of struct
- *                          luo_session_header_ser
- */
-#define LUO_FDT_SESSION_NODE_NAME	"luo-session"
-#define LUO_FDT_SESSION_COMPATIBLE	"luo-session-v2"
-#define LUO_FDT_SESSION_HEADER		"luo-session-header"
-
 /**
  * struct luo_session_header_ser - Header for the serialized session data block.
  * @count: The number of `struct luo_session_ser` entries that immediately
@@ -165,7 +142,7 @@ struct luo_file_set_ser {
  * physical memory preserved across the kexec. It provides the necessary
  * metadata to interpret the array of session entries that follow.
  *
- * If this structure is modified, `LUO_FDT_SESSION_COMPATIBLE` must be updated.
+ * If this structure is modified, `LUO_FDT_COMPATIBLE` must be updated.
  */
 struct luo_session_header_ser {
 	u64 count;
@@ -182,7 +159,7 @@ struct luo_session_header_ser {
  * session) is created and passed to the new kernel, allowing it to reconstruct
  * the session context.
  *
- * If this structure is modified, `LUO_FDT_SESSION_COMPATIBLE` must be updated.
+ * If this structure is modified, `LUO_FDT_COMPATIBLE` must be updated.
  */
 struct luo_session_ser {
 	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
@@ -192,10 +169,6 @@ struct luo_session_ser {
 /* The max size is set so it can be reliably used during in serialization */
 #define LIVEUPDATE_FLB_COMPAT_LENGTH	48
 
-#define LUO_FDT_FLB_NODE_NAME	"luo-flb"
-#define LUO_FDT_FLB_COMPATIBLE	"luo-flb-v1"
-#define LUO_FDT_FLB_HEADER	"luo-flb-header"
-
 /**
  * struct luo_flb_header_ser - Header for the serialized FLB data block.
  * @pgcnt: The total number of pages occupied by the entire preserved memory
@@ -205,11 +178,9 @@ struct luo_session_ser {
  *         in the memory block.
  *
  * This structure is located at the physical address specified by the
- * `LUO_FDT_FLB_HEADER` FDT property. It provides the new kernel with the
- * necessary information to find and iterate over the array of preserved
- * File-Lifecycle-Bound objects and to manage the underlying memory.
+ * flbs_pa in luo_ser.
  *
- * If this structure is modified, LUO_FDT_FLB_COMPATIBLE must be updated.
+ * If this structure is modified, `LUO_FDT_COMPATIBLE` must be updated.
  */
 struct luo_flb_header_ser {
 	u64 pgcnt;
@@ -231,7 +202,7 @@ struct luo_flb_header_ser {
  * passed to the new kernel. Each entry allows the LUO core to restore one
  * global, shared object.
  *
- * If this structure is modified, LUO_FDT_FLB_COMPATIBLE must be updated.
+ * If this structure is modified, `LUO_FDT_COMPATIBLE` must be updated.
  */
 struct luo_flb_ser {
 	char name[LIVEUPDATE_FLB_COMPAT_LENGTH];
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 803f51c84275..c1c290aefc76 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -57,7 +57,6 @@
 #include <linux/rwsem.h>
 #include <linux/sizes.h>
 #include <linux/string.h>
-#include <linux/unaligned.h>
 
 #include "kexec_handover_internal.h"
 #include "luo_internal.h"
@@ -82,9 +81,11 @@ early_param("liveupdate", early_liveupdate_param);
 
 static int __init luo_early_startup(void)
 {
+	struct luo_ser *luo_ser;
+	int err, header_size;
 	phys_addr_t fdt_phys;
-	int err, ln_size;
 	const void *ptr;
+	u64 luo_ser_pa;
 
 	if (!kho_is_enabled()) {
 		if (liveupdate_enabled())
@@ -115,27 +116,29 @@ static int __init luo_early_startup(void)
 		return -EINVAL;
 	}
 
-	ln_size = 0;
-	ptr = fdt_getprop(luo_global.fdt_in, 0, LUO_FDT_LIVEUPDATE_NUM,
-			  &ln_size);
-	if (!ptr || ln_size != sizeof(luo_global.liveupdate_num)) {
-		pr_err("Unable to get live update number '%s' [%d]\n",
-		       LUO_FDT_LIVEUPDATE_NUM, ln_size);
+	header_size = 0;
+	ptr = fdt_getprop(luo_global.fdt_in, 0, LUO_FDT_ABI_HEADER, &header_size);
+	if (!ptr || header_size != sizeof(u64)) {
+		pr_err("Unable to get ABI header '%s' [%d]\n",
+		       LUO_FDT_ABI_HEADER, header_size);
 
 		return -EINVAL;
 	}
 
-	luo_global.liveupdate_num = get_unaligned((u64 *)ptr);
+	luo_ser_pa = get_unaligned((u64 *)ptr);
+	luo_ser = phys_to_virt(luo_ser_pa);
+
+	luo_global.liveupdate_num = luo_ser->liveupdate_num;
 	pr_info("Retrieved live update data, liveupdate number: %lld\n",
 		luo_global.liveupdate_num);
 
-	err = luo_session_setup_incoming(luo_global.fdt_in);
+	err = luo_session_setup_incoming(luo_ser->sessions_pa);
 	if (err)
 		return err;
 
-	err = luo_flb_setup_incoming(luo_global.fdt_in);
+	luo_flb_setup_incoming(luo_ser->flbs_pa);
 
-	return err;
+	return 0;
 }
 
 static int __init liveupdate_early_init(void)
@@ -156,7 +159,8 @@ early_initcall(liveupdate_early_init);
 /* Called during boot to create outgoing LUO fdt tree */
 static int __init luo_fdt_setup(void)
 {
-	const u64 ln = luo_global.liveupdate_num + 1;
+	struct luo_ser *luo_ser;
+	u64 luo_ser_pa;
 	void *fdt_out;
 	int err;
 
@@ -166,27 +170,45 @@ static int __init luo_fdt_setup(void)
 		return PTR_ERR(fdt_out);
 	}
 
+	luo_ser = kho_alloc_preserve(sizeof(*luo_ser));
+	if (IS_ERR(luo_ser)) {
+		err = PTR_ERR(luo_ser);
+		goto exit_free_fdt;
+	}
+	luo_ser_pa = virt_to_phys(luo_ser);
+
 	err = fdt_create(fdt_out, LUO_FDT_SIZE);
 	err |= fdt_finish_reservemap(fdt_out);
 	err |= fdt_begin_node(fdt_out, "");
 	err |= fdt_property_string(fdt_out, "compatible", LUO_FDT_COMPATIBLE);
-	err |= fdt_property(fdt_out, LUO_FDT_LIVEUPDATE_NUM, &ln, sizeof(ln));
-	err |= luo_session_setup_outgoing(fdt_out);
-	err |= luo_flb_setup_outgoing(fdt_out);
+	err |= fdt_property(fdt_out, LUO_FDT_ABI_HEADER, &luo_ser_pa,
+			    sizeof(luo_ser_pa));
 	err |= fdt_end_node(fdt_out);
 	err |= fdt_finish(fdt_out);
 	if (err)
-		goto exit_free;
+		goto exit_free_luo_ser;
+
+	err = luo_session_setup_outgoing(&luo_ser->sessions_pa);
+	if (err)
+		goto exit_free_luo_ser;
+
+	err = luo_flb_setup_outgoing(&luo_ser->flbs_pa);
+	if (err)
+		goto exit_free_luo_ser;
+
+	luo_ser->liveupdate_num = luo_global.liveupdate_num + 1;
 
 	err = kho_add_subtree(LUO_FDT_KHO_ENTRY_NAME, fdt_out,
 			      fdt_totalsize(fdt_out));
 	if (err)
-		goto exit_free;
+		goto exit_free_luo_ser;
 	luo_global.fdt_out = fdt_out;
 
 	return 0;
 
-exit_free:
+exit_free_luo_ser:
+	kho_unpreserve_free(luo_ser);
+exit_free_fdt:
 	kho_unpreserve_free(fdt_out);
 	pr_err("failed to prepare LUO FDT: %d\n", err);
 
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 8f5c5dd01cd0..c8dd30b41238 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -44,13 +44,11 @@
 #include <linux/io.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/luo.h>
-#include <linux/libfdt.h>
 #include <linux/list_private.h>
 #include <linux/liveupdate.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-#include <linux/unaligned.h>
 #include "luo_internal.h"
 
 #define LUO_FLB_PGCNT		1ul
@@ -551,27 +549,15 @@ int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp)
 	return 0;
 }
 
-int __init luo_flb_setup_outgoing(void *fdt_out)
+int __init luo_flb_setup_outgoing(u64 *flbs_pa)
 {
 	struct luo_flb_header_ser *header_ser;
-	u64 header_ser_pa;
-	int err;
 
 	header_ser = kho_alloc_preserve(LUO_FLB_PGCNT << PAGE_SHIFT);
 	if (IS_ERR(header_ser))
 		return PTR_ERR(header_ser);
 
-	header_ser_pa = virt_to_phys(header_ser);
-
-	err = fdt_begin_node(fdt_out, LUO_FDT_FLB_NODE_NAME);
-	err |= fdt_property_string(fdt_out, "compatible",
-				   LUO_FDT_FLB_COMPATIBLE);
-	err |= fdt_property(fdt_out, LUO_FDT_FLB_HEADER, &header_ser_pa,
-			    sizeof(header_ser_pa));
-	err |= fdt_end_node(fdt_out);
-
-	if (err)
-		goto err_unpreserve;
+	*flbs_pa = virt_to_phys(header_ser);
 
 	header_ser->pgcnt = LUO_FLB_PGCNT;
 	luo_flb_global.outgoing.header_ser = header_ser;
@@ -579,53 +565,18 @@ int __init luo_flb_setup_outgoing(void *fdt_out)
 	luo_flb_global.outgoing.active = true;
 
 	return 0;
-
-err_unpreserve:
-	kho_unpreserve_free(header_ser);
-
-	return err;
 }
 
-int __init luo_flb_setup_incoming(void *fdt_in)
+void __init luo_flb_setup_incoming(u64 flbs_pa)
 {
 	struct luo_flb_header_ser *header_ser;
-	int err, header_size, offset;
-	const void *ptr;
-	u64 header_ser_pa;
 
-	offset = fdt_subnode_offset(fdt_in, 0, LUO_FDT_FLB_NODE_NAME);
-	if (offset < 0) {
-		pr_err("Unable to get FLB node [%s]\n", LUO_FDT_FLB_NODE_NAME);
-
-		return -ENOENT;
+	if (flbs_pa) {
+		header_ser = phys_to_virt(flbs_pa);
+		luo_flb_global.incoming.header_ser = header_ser;
+		luo_flb_global.incoming.ser = (void *)(header_ser + 1);
+		luo_flb_global.incoming.active = true;
 	}
-
-	err = fdt_node_check_compatible(fdt_in, offset,
-					LUO_FDT_FLB_COMPATIBLE);
-	if (err) {
-		pr_err("FLB node is incompatible with '%s' [%d]\n",
-		       LUO_FDT_FLB_COMPATIBLE, err);
-
-		return -EINVAL;
-	}
-
-	header_size = 0;
-	ptr = fdt_getprop(fdt_in, offset, LUO_FDT_FLB_HEADER, &header_size);
-	if (!ptr || header_size != sizeof(u64)) {
-		pr_err("Unable to get FLB header property '%s' [%d]\n",
-		       LUO_FDT_FLB_HEADER, header_size);
-
-		return -EINVAL;
-	}
-
-	header_ser_pa = get_unaligned((u64 *)ptr);
-	header_ser = phys_to_virt(header_ser_pa);
-
-	luo_flb_global.incoming.header_ser = header_ser;
-	luo_flb_global.incoming.ser = (void *)(header_ser + 1);
-	luo_flb_global.incoming.active = true;
-
-	return 0;
 }
 
 /**
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index dd53d4a7277e..9bf26c5b1495 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -79,8 +79,8 @@ extern struct rw_semaphore luo_register_rwlock;
 
 int luo_session_create(const char *name, struct file **filep);
 int luo_session_retrieve(const char *name, struct file **filep);
-int __init luo_session_setup_outgoing(void *fdt);
-int __init luo_session_setup_incoming(void *fdt);
+int __init luo_session_setup_outgoing(u64 *sessions_pa);
+int __init luo_session_setup_incoming(u64 sessions_pa);
 int luo_session_serialize(void);
 int luo_session_deserialize(void);
 
@@ -102,8 +102,8 @@ int luo_flb_file_preserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_finish(struct liveupdate_file_handler *fh);
 void luo_flb_unregister_all(struct liveupdate_file_handler *fh);
-int __init luo_flb_setup_outgoing(void *fdt);
-int __init luo_flb_setup_incoming(void *fdt);
+int __init luo_flb_setup_outgoing(u64 *flbs_pa);
+void __init luo_flb_setup_incoming(u64 flbs_pa);
 void luo_flb_serialize(void);
 
 #ifdef CONFIG_LIVEUPDATE_TEST
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 146414933977..1cad54ea8209 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -25,9 +25,8 @@
  *
  * - Serialization: Session metadata is preserved using the KHO framework. When
  *   a live update is triggered via kexec, an array of `struct luo_session_ser`
- *   is populated and placed in a preserved memory region. An FDT node is also
- *   created, containing the count of sessions and the physical address of this
- *   array.
+ *   is populated and placed in a preserved memory region. The physical address
+ *   of this array is stored in the centralized `struct luo_ser` structure.
  *
  * Session Lifecycle:
  *
@@ -91,13 +90,11 @@
 #include <linux/io.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/luo.h>
-#include <linux/libfdt.h>
 #include <linux/list.h>
 #include <linux/liveupdate.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/slab.h>
-#include <linux/unaligned.h>
 #include <uapi/linux/liveupdate.h>
 #include "luo_internal.h"
 
@@ -498,75 +495,34 @@ int luo_session_retrieve(const char *name, struct file **filep)
 	return err;
 }
 
-int __init luo_session_setup_outgoing(void *fdt_out)
+int __init luo_session_setup_outgoing(u64 *sessions_pa)
 {
 	struct luo_session_header_ser *header_ser;
-	u64 header_ser_pa;
-	int err;
 
 	header_ser = kho_alloc_preserve(LUO_SESSION_PGCNT << PAGE_SHIFT);
 	if (IS_ERR(header_ser))
 		return PTR_ERR(header_ser);
-	header_ser_pa = virt_to_phys(header_ser);
-
-	err = fdt_begin_node(fdt_out, LUO_FDT_SESSION_NODE_NAME);
-	err |= fdt_property_string(fdt_out, "compatible",
-				   LUO_FDT_SESSION_COMPATIBLE);
-	err |= fdt_property(fdt_out, LUO_FDT_SESSION_HEADER, &header_ser_pa,
-			    sizeof(header_ser_pa));
-	err |= fdt_end_node(fdt_out);
 
-	if (err)
-		goto err_unpreserve;
+	*sessions_pa = virt_to_phys(header_ser);
 
 	luo_session_global.outgoing.header_ser = header_ser;
 	luo_session_global.outgoing.ser = (void *)(header_ser + 1);
 	luo_session_global.outgoing.active = true;
 
 	return 0;
-
-err_unpreserve:
-	kho_unpreserve_free(header_ser);
-	return err;
 }
 
-int __init luo_session_setup_incoming(void *fdt_in)
+int __init luo_session_setup_incoming(u64 sessions_pa)
 {
 	struct luo_session_header_ser *header_ser;
-	int err, header_size, offset;
-	u64 header_ser_pa;
-	const void *ptr;
-
-	offset = fdt_subnode_offset(fdt_in, 0, LUO_FDT_SESSION_NODE_NAME);
-	if (offset < 0) {
-		pr_err("Unable to get session node: [%s]\n",
-		       LUO_FDT_SESSION_NODE_NAME);
-		return -EINVAL;
-	}
 
-	err = fdt_node_check_compatible(fdt_in, offset,
-					LUO_FDT_SESSION_COMPATIBLE);
-	if (err) {
-		pr_err("Session node incompatible [%s]\n",
-		       LUO_FDT_SESSION_COMPATIBLE);
-		return -EINVAL;
-	}
-
-	header_size = 0;
-	ptr = fdt_getprop(fdt_in, offset, LUO_FDT_SESSION_HEADER, &header_size);
-	if (!ptr || header_size != sizeof(u64)) {
-		pr_err("Unable to get session header '%s' [%d]\n",
-		       LUO_FDT_SESSION_HEADER, header_size);
-		return -EINVAL;
+	if (sessions_pa) {
+		header_ser = phys_to_virt(sessions_pa);
+		luo_session_global.incoming.header_ser = header_ser;
+		luo_session_global.incoming.ser = (void *)(header_ser + 1);
+		luo_session_global.incoming.active = true;
 	}
 
-	header_ser_pa = get_unaligned((u64 *)ptr);
-	header_ser = phys_to_virt(header_ser_pa);
-
-	luo_session_global.incoming.header_ser = header_ser;
-	luo_session_global.incoming.ser = (void *)(header_ser + 1);
-	luo_session_global.incoming.active = true;
-
 	return 0;
 }
 
-- 
2.53.0


