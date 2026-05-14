Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2C36CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 22:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2664A6B0088; Thu, 14 May 2026 18:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23E136B008A; Thu, 14 May 2026 18:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105E66B008C; Thu, 14 May 2026 18:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE6616B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:26:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B02AC160E06
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:36 +0000 (UTC)
X-FDA: 84767460792.25.5552C27
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id D047F80007
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=C5P81gzs;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778797594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j39P/d5rSho/yV0JzJL6Y2jMMbUZ/GwYCZvoLGL4UKQ=;
	b=xZgT8xipPkVnyq6drJ+nABoLUJZSOLZiCUW318JyZ+hP7X7t6Esbregrf2seZjtl6Pran6
	VdAABjLo9fTaUeVriPyDPkd/BiMD+/0AZOGqjwRo4c00V31RtO5aKv1iav6jCZ1rVKV5Py
	Kg/jFmA7IvjYf0xoiRAK4PGBnkTec9U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=C5P81gzs;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778797594; a=rsa-sha256;
	cv=none;
	b=JFP4JKo3DEwaHWXfm68fX/P27sR2aiCtFnVtG/oQxOUglEOT15WR8jLdztPli+q+/PykG4
	jEbJgRwyhoNv3mzthsk1kmu9LbDcEDIT8S0uMGtrSZ9ZmWXKOrHH/+zzUdaOlqMd1hy5DW
	0MAquxr7G7i3bOqEh1I28D5lfC50nis=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50fc496c8baso80336661cf.3
        for <linux-mm@kvack.org>; Thu, 14 May 2026 15:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778797594; x=1779402394; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j39P/d5rSho/yV0JzJL6Y2jMMbUZ/GwYCZvoLGL4UKQ=;
        b=C5P81gzstYAJhaVOljY15qWReviGnbRKiLEHoIHHz1jv16+kcb0uEJgqlmm3f7WQmv
         7HNpV0FzmRJ8Qg4dewnCLZDSPjZs6NezIZ2Z+JeQ96Jijkf/EJgMeoD4IQGb1yjTNKPH
         AX8l8yfvGSHTmM9fK2FoL4+C8sJNxb/jY3KITc9xdivjwSgDDf5Cp0D3Tt4o9yo18G6z
         Pa53OUwx+IW8l6ple/qwiIicFJqKJjz6P03OMIv2J7ZNc4wVNtKHlCB8PSEGL4Q0mBbD
         OqfOiUh7qkq68fm3FemDCjgjA6XOUlw+Dv9QHbCsMHYzHOsJqwtGfPF9Le/NIJsDatwd
         cZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778797594; x=1779402394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j39P/d5rSho/yV0JzJL6Y2jMMbUZ/GwYCZvoLGL4UKQ=;
        b=ibS3gY2a2yCz6cI/jE2VEzIgc6NLTGZ6X0gAH7ZgKW7k0hoNF7mUoAjZmJzqQ3Vxv3
         bmrZH+yTG5BBk9/NlaSpYVDT7V17Spd7cpVqLI1Fn5GJqJ9CZAK5oItPDNT8vbOqBP7J
         wcBOa7twMqXNa87NKf1koBeIA1UU5YU2inhaWDdspFvtdlK4lH6xmakaxgMDgsESiU5Y
         dXMgBFWb94wwJWki+Rs8D9KPtjS1E39nHvU4x99F60XHu4Fw+U8Um2Zhx/k2ulcYe70c
         oPIzaknfvvuoPutb2vcQRtx6BjRkE0j0JLzaa0E3+bl5wXCuDdYXN0PagJUxpEP+TdRr
         y/2A==
X-Forwarded-Encrypted: i=1; AFNElJ8lnQyOc6YVEORdDPaJPbSkIDh2Q/Qvq+IkCF/R/i799qrErWAeYaaidxYectaYVVI7dV7iAPszSQ==@kvack.org
X-Gm-Message-State: AOJu0YyGjvI0tXHw0nnrYqXgiIaSNc/HYlTJJAnFoHse2dtQXIcxqRmi
	PCNGHT/ZN3l+ZPD0vIwSsN5seVQhPVsYUkoQF+lX1RYtUwDmY7GifOd8lTkd5dSYTjo=
X-Gm-Gg: Acq92OGQi8Gjau6csUI4sY/zUW+6IMoIi8a5yX8WbPV6TC5FECROPFeNR/E2rIvOiMY
	suy6q+kyCfiRU9hdK5qkomdC+RzBnRLdjf6z//HAo35PgZuaeYqZe2L9TxzP4A/nyCJMMZdV5Kd
	N4Oz8Kco19BrIJ9v1wiTCuJIobL1DI/7ln5O8dWxdsK2kwlYLsHk2L+bkfDQaJswk3cKPNxw+/l
	XW01atUztkT39Oy0+XYriuRAaizVuBKsnHqRYPDbLrrl0BcsbTZUlnpnWsq4rpkfuVnr52TpDmE
	4eIZoSwPPLsfTjIUV73U4fBf/C7cRctAsC5sxks7w4FHGZ2euuwxrrL3WV71maJI91HMYyTYPbQ
	nt4WcHuUdnHt7HcGqb+l4DKsnSyBxGejVNR7l2D4v4MzrHtIpoHPe6gNEIMFvBE9hdkrp4pq/C3
	L0MdSeca0jD+xgR3Dazb8LlY2L3VKTmj2FwOfe6mucwN6VVJTqMGriYEvVCibPbQ==
X-Received: by 2002:ac8:57cd:0:b0:50d:b33d:bc6b with SMTP id d75a77b69052e-5165a026958mr19386901cf.20.1778797593734;
        Thu, 14 May 2026 15:26:33 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456ba92fsm28671901cf.9.2026.05.14.15.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 15:26:33 -0700 (PDT)
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
Subject: [PATCH v2 01/10] liveupdate: centralize state management into struct luo_ser
Date: Thu, 14 May 2026 22:26:19 +0000
Message-ID: <20260514222628.931312-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260514222628.931312-1-pasha.tatashin@soleen.com>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D047F80007
X-Stat-Signature: smz1rs4rfix7tzupzuruy3mswpn38f8i
X-HE-Tag: 1778797594-710687
X-HE-Meta: U2FsdGVkX19U/zH/B00lNrQ4Duu8haqola0VWn6OVFdodc0H5/obpJ/5HOB9yLJju4+jVNckXzu2z+CFEMcdetyRvDw25h04JLfpBz5yr2rupunVBaOGCPA2z2IOE/5baM3/2dHdekmRNuBUNHw2GaCAR3OV9fMth5b+/8as3cfclRIrOdMknKpRGEhGCLzON2VKoQH0tFJwSomXFIDjy1mAGU1WR0zitXymZ53ixCNKmXyr78Fg3h6W4DC4BuIfPgtNum+4MvjvY/2AhlNUvuogWYq5Sqh/8WyADyyiS8MLCSPvGyCiVmbwpaqsJ1I2RUGCn5sf/4rjrPXQw4RBRJTqeEnqj/3pQA4X5CCDpMmMIsaHuVXsLsJX+3+7cpFnluI0UCCykj6gkbY4r4h+yzrVAZ8VZpw3cmEEiy0A7Yrnn6sI3ORFTREIeiJEmdQXTdkolAR5AfmPqigSqwKikPiri0FkCMZiUQOOBOXnbVud0iIJWqbRJ5/gN0FBL9PA6LG7/z/WozqDgBlfuyjUu3GlPxmRmsO3x4gUbVCqhzNUS0O7HajsoHmWIpacYLahyrsHhG5fwut0Q1pTpZVEMI+RbU2QSTANjRmr5kayVySSZLxC1vXGyUBBMVrVAHq6+RgYJ+HH2z3AP5QlFR7Ofm4cIc2rlE/CUSjjHBD8ZZNy1owoFBbrHfmYhJ9l6M/6rDlr+Wb4zlVQfYbe8wDsYXOjeb9z00wd+ac7sd6TUXtWxmLtRPj0aDFnY7NjxhPuJFlcg7SJbZ78gSCkKQQFbi3vLNFKZP3N1upZoj9lIWjVYbSqhvTpycb68eVfwptVXRBYmPE53ebI5F1YvlDvaysQMhEFNWceiK7+JYH5IEHVz49Jguh28XEfz9ZCmyeehzXRsW8sZONvshQ0i68EixLZM3MIVZcwvYvROB8PJgq5qUO/WtrQ4NwPygU6UQ2ywIpHICxI+VTtCT1VDlJ
 AzT9yzkq
 z7AaJiS0cYfmS/v6Wb7+TsQ3RAth2fJWjWMPYr6nVWSAf35U2emihL/Zu+wX+FQUQGSst4yDx/N2kGRoO+X4xWttOuHiPFEBpmrigDMso7MLQWX3lqW8wOoHbqXnziL8QffJHdMC6bTfiko1Uqh/G/RJk2tv6yvUFPPIDHtK+3lW7Dqn9HoknnspcHyzvHdcCfFuAR+Ch9Z18SGA1DPoAmDGR7UnE588Tf9cv8rSLmiMfckRBplXZgCl3S753cz+25aOd0EDd1b1+FhwwPO993d8me778PHMuG5N6svF+FNbstcDZyADkfCtZCsQUqo+w9HUFDYii7kFktrah48huaceJvV+JPhIHg6xs2JL6e+rxkFu4h5OCqCnC7ex6AyOCYqm/DUu4nm1ru32mvRlqhXvQba4+2sjSLVXNNDZrXyNv4ddGA3lahPZsj/v6TPKghRwwSvz7OlXyG7ENQceJfL1KFQ==
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

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/luo.h      | 91 +++++++++++---------------------
 kernel/liveupdate/luo_core.c     | 59 ++++++++++++++-------
 kernel/liveupdate/luo_flb.c      | 65 ++++-------------------
 kernel/liveupdate/luo_internal.h |  8 +--
 kernel/liveupdate/luo_session.c  | 57 +++-----------------
 5 files changed, 93 insertions(+), 187 deletions(-)

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
index 803f51c84275..9bd649b22029 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -82,9 +82,11 @@ early_param("liveupdate", early_liveupdate_param);
 
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
@@ -115,27 +117,29 @@ static int __init luo_early_startup(void)
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
@@ -156,7 +160,8 @@ early_initcall(liveupdate_early_init);
 /* Called during boot to create outgoing LUO fdt tree */
 static int __init luo_fdt_setup(void)
 {
-	const u64 ln = luo_global.liveupdate_num + 1;
+	struct luo_ser *luo_ser;
+	u64 luo_ser_pa;
 	void *fdt_out;
 	int err;
 
@@ -166,27 +171,45 @@ static int __init luo_fdt_setup(void)
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
index 8f5c5dd01cd0..7ccc59981297 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -159,8 +159,8 @@ static void luo_flb_file_unpreserve_one(struct liveupdate_flb *flb)
 
 static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 {
-	struct luo_flb_private *private = luo_flb_get_private(flb);
 	struct luo_flb_header *fh = &luo_flb_global.incoming;
+	struct luo_flb_private *private = luo_flb_get_private(flb);
 	struct liveupdate_flb_op_args args = {0};
 	bool found = false;
 	int err;
@@ -551,27 +551,15 @@ int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp)
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
@@ -579,53 +567,18 @@ int __init luo_flb_setup_outgoing(void *fdt_out)
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
-
-	offset = fdt_subnode_offset(fdt_in, 0, LUO_FDT_FLB_NODE_NAME);
-	if (offset < 0) {
-		pr_err("Unable to get FLB node [%s]\n", LUO_FDT_FLB_NODE_NAME);
 
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
index 875844d7a41d..4b6c18348d9b 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -81,8 +81,8 @@ extern struct rw_semaphore luo_register_rwlock;
 
 int luo_session_create(const char *name, struct file **filep);
 int luo_session_retrieve(const char *name, struct file **filep);
-int __init luo_session_setup_outgoing(void *fdt);
-int __init luo_session_setup_incoming(void *fdt);
+int __init luo_session_setup_outgoing(u64 *sessions_pa);
+int __init luo_session_setup_incoming(u64 sessions_pa);
 int luo_session_serialize(void);
 int luo_session_deserialize(void);
 
@@ -104,8 +104,8 @@ int luo_flb_file_preserve(struct liveupdate_file_handler *fh);
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
index 1caaa7886ec6..915ab9ce0f34 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -458,75 +458,34 @@ int luo_session_retrieve(const char *name, struct file **filep)
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


