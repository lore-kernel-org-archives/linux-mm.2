Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D008ECD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00366B00A5; Wed,  3 Jun 2026 11:44:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB16A6B00A6; Wed,  3 Jun 2026 11:44:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D791D6B00A7; Wed,  3 Jun 2026 11:44:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BED976B00A5
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:44:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E9FD14041C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:44:42 +0000 (UTC)
X-FDA: 84839024004.12.8567DBC
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8FD5D10000F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:44:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VgnbIg7u;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780501480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qJs3vMWEh5lMBsn2ojdsHtSBK02MSOoqr9r9XS5tsI8=;
	b=PrClgnsWaWsSNMpMhh9phN4KUCzbbfkF7e+KlKETrQhuLgKYKBqI/Y+dJyjOD7VC9aYfIH
	fQJH8VYepBeubq3hB4bVErCdCxGLGPFSGkJGtxEWuRw4puRjcGbCKU5ph5VIRNN/4BKDVm
	VVM7e0W0+oTAtjV3D+GuT6xo2AzG+M4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VgnbIg7u;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780501480;
	b=oIa0FT+CSohpBLa2WP8oX3lOYyTPALY1A80wnGloeuQKVK6MM51Lk2XdgTXUbZuN39Ac4P
	pAOJIXOwbUNe3mhrit8gtw+MagEqiAy9qYoBSOF3x5vr4XfRMwWLlNul4T6yH4rSJOxAfD
	EOsxHTtov45uk58CSzztr06oakzPlxQ=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-9157f7c1c0eso203648885a.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780501480; x=1781106280; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qJs3vMWEh5lMBsn2ojdsHtSBK02MSOoqr9r9XS5tsI8=;
        b=VgnbIg7uCXq1hoApMPqPhQVslpyjRK0twPWpJgoja+lpH2yTFSpKNq5n5Q6xst9IZa
         i3qDDxWCHToRiMqAJEZNqhiUnibkENrap5D0LFue4LFrvolyIaqyot3IRUABmB2Jwi5G
         ilsiV1sie23iCX2J9ZNRW+9aIhj0NkTXMX5conclLPrPNSo0uWg+2Gt0KQUCCs83j6vK
         wycDF/xtrz1HCLwAjRlERSqK6lhBuPFZxZfvrDbNVf9LS9G1qryyNukA3sa1ek29Sh3o
         rWVJjgd0KdLzbcgxIcQJWI4SY3Xl61fadaYtrcAd+/3er7sq+9fKVQsS3ttFJv+TrjIX
         PZQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780501480; x=1781106280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qJs3vMWEh5lMBsn2ojdsHtSBK02MSOoqr9r9XS5tsI8=;
        b=XnoSMyqLrcNuhJ8PEF7DO5S7WMPgbIwSwQlX0yJhxg+J+/N7Q4PtdZ60B1hyuuQsIZ
         6uDw7GwPBSB7pQVqWQBwHkvjQn6THjfg74LxMoR8mERNW1xxw676/Exu2Ny1+SIklgvG
         KT8XYvRKdVXMR5r/5xVWCVYy2mQweN4P3FksDPorzNVSVR4ABD07fdNE13WqhGap30Iv
         6pwYQS0cbH8Qr5LsZ7MOSN+KF02BI4GkifNFuPNfzU6s4wRDX5nYwPGBrxL+bFCdZYAh
         t6CP3idKrz+oPHEjzOXBYs5d6hi7IfzH4ni+iSNbP3IHMibBSlVEQ9RkfQP7MVCpiwut
         oiZQ==
X-Forwarded-Encrypted: i=1; AFNElJ9kcE2KJx2P4kAnv4C/uHu7emxhOFQq3RYlg0WdE/5kpYpNT/G+gCJF0hpxa4zK5R9Aacj680O1Yw==@kvack.org
X-Gm-Message-State: AOJu0YzyhlIUPb5XMPPM5h75wK5Mkc03J873sobwt/fuNvAFSr4wWgMD
	CKO3U928bqlyB4tby/S6HA3n9N1bImdxPbY/x5vFuipgod1fHrZvEtFEe3kqKA+5Wkw=
X-Gm-Gg: Acq92OFP65WjwkAIoCA3+RwTH2DB3Q+e9Xo6kguzwftY9hi3y67ETLHZEeEDfhtLhOW
	4sv60r+KNBaz9gpTex0eV8VWcmuLpKU4RzAacUcxgGjOaQ2WzPEkhNjnJZCi2psoR/pEeNlg+AA
	SudR9g5WE7IFVkcP9EorNeNzBsR2nt7mE4ihlSzt5LiwlhhlUQHPmhC89n+u5sCXsDnmlROAYtX
	9JjWNUUPFjqE6t9UaG9iVvPm0Le29w0EuqgWcf7I6ugOuy+/XBXtU4UdDU3YaAPBW9zWXXApGKG
	yey9lzBdi7mgtGYeGbgC/Sjt7FARnH2AM1vT6ta0w8qTrSeJwqNPu6H0cumOMARoBUqVu8THZt1
	NzbG7Md5LDKJquMlBqXl3p0/6UiPp9X1ruhMteKCNl4udds+WdUa9Ga0fuRwHevcWAra/0MjxAr
	/l/SXbT2ytb/xvoHUmLkpXWquRffBoFwddlx2aQfBz54On1xVYO6PD4lnWqO1/1A==
X-Received: by 2002:a05:620a:470d:b0:915:6c4e:4c61 with SMTP id af79cd13be357-9158a6af95cmr662265185a.24.1780501479496;
        Wed, 03 Jun 2026 08:44:39 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a009fb2sm287423185a.5.2026.06.03.08.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:44:39 -0700 (PDT)
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
Subject: [PATCH v7 03/13] liveupdate: centralize state management into struct luo_ser
Date: Wed,  3 Jun 2026 15:43:52 +0000
Message-ID: <20260603154402.468928-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603154402.468928-1-pasha.tatashin@soleen.com>
References: <20260603154402.468928-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: az4obd96yjhsxinhtdsrtkqmccitqp5d
X-Rspamd-Queue-Id: 8FD5D10000F
X-HE-Tag: 1780501480-915251
X-HE-Meta: U2FsdGVkX18ousUIu+mMIxeBG17H8GOhy47bgCDEuyMwsnoYAfQ9jp3bgumHNAnwfeHz6EorYzI/NUZTYJWMU6lxsRokEr3RUfxDx1K3GXHWqYPn475ij5BP1OWgN5N9KqrEAnZqsvAj3wyH+9auAkududhe44zVOxlAlerJ5h2bXUeJ4EDCofMvgqYBlYgncVQrRhB4yrVXXOtZ92TcE8GOcsxgP2Vw7gOt15PJCYqdaz0UAOTG7BwUQ3ZFemPXFxINXEj5n8NGy33m1gzw8St1V2WT8u2QnL9ckrr2GF+U/uHjFILSexD0agGVr4YitomX6WqZwNdOygLY4mBooFhPU0+V52EjGQXZDSf61QIqUdCKMnboDbXfHmgW8oepONq1N8F0talB7YRiP4Lpcs0+k08ZmmSojgwgp3fVMOh0G5WCunuCT4fGwobhYvB1fJ/MhcZIQj+9PF3NcRR1f/TEevz4iMbzywHIseHmtSRvCsg6PGrGPOY8qGPf+8dFEJDGLZPkzs0wsfh7zUNsP9owMWawqUy/w+Su2FpmZ8IhHE+Uv4ozQ5ubPk7QYjDc3TLivMxD6jAzQxaIl/sbNBupqAMnopK+SO9Ko40Z6TzO2nrzyZjROAUlqVZNJtkfNFecLVlt+564CpY/y+8h14xEMjQEY673+kFlhiSDHuHCVyS+xM5qjgpsLbeFFrhL64ZII/uDJrDe9CAPySJn/mFX2kGTEORRJKPJxIVat46JZmcFVWAVhwpbE6FBjy19bvkV2RjeSgMYfZb4z+z7RvdhbZyXrYnoEjijkoEfidQ8AXcUWoIYp7IwFDZRSFXiRpCP+9lYQCjW53cEo8r765S9YLMULYM/hNz00OGb4cPE3IAaeR+SIOaqLnInGRpJbErLx+9ZMa7e077IfIt9GK1yVcrMEIM6x7s7ywz0eaZq3uLU3j05/lxnBFjPlCgkwqLmkkrAU0ZN7uOmTjd
 w8HM9kzI
 /CFsJROzaI3cKvlpBeCpvjdXmalcXZEFoFfO8mOqyjjpYbBh/IbX15dVfHChXxaCWZnyPd4yvQg6iErEPPQshx2j3dccFxEDM1GJhE5tlg4IJ9e00M7qIdO4dhv7qnWDsV2OSaoBZwjajcyU7NuAI3Mw06H7EHc1c3KcdFaMf3v19fNC5P8UabrMAwkAgL0c9xeyP1h2fJ/73ighpJhP5R/FU0bR98LHMrq1T35e0+9+wXM0kYgccOqB3D8lLV+CBddHcYtS0uhFElxclFT0hmNtDxtN1ghKVDUgP3qW6R4CQm5oEsOxzHylJpHYpMhvZ4jyJ695QCwYlBmRDwiBnex0yiCem8pf2wl3P9MKoJ/DC8AQ=
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

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/luo.h      | 91 +++++++++++---------------------
 kernel/liveupdate/luo_core.c     | 64 +++++++++++++++-------
 kernel/liveupdate/luo_flb.c      | 60 +++------------------
 kernel/liveupdate/luo_internal.h |  8 +--
 kernel/liveupdate/luo_session.c  | 64 ++++------------------
 5 files changed, 96 insertions(+), 191 deletions(-)

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
index 5d5827ced73c..085c0dfc1ef1 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -61,7 +61,6 @@
 #include <linux/rwsem.h>
 #include <linux/sizes.h>
 #include <linux/string.h>
-#include <linux/unaligned.h>
 
 #include "kexec_handover_internal.h"
 #include "luo_internal.h"
@@ -86,9 +85,11 @@ early_param("liveupdate", early_liveupdate_param);
 
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
@@ -119,26 +120,32 @@ static int __init luo_early_startup(void)
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
-		return err;
+		goto out_free_ser;
+
+	luo_flb_setup_incoming(luo_ser->flbs_pa);
 
-	err = luo_flb_setup_incoming(luo_global.fdt_in);
+	err = 0;
 
+out_free_ser:
+	kho_restore_free(luo_ser);
 	return err;
 }
 
@@ -160,7 +167,8 @@ early_initcall(liveupdate_early_init);
 /* Called during boot to create outgoing LUO fdt tree */
 static int __init luo_fdt_setup(void)
 {
-	const u64 ln = luo_global.liveupdate_num + 1;
+	struct luo_ser *luo_ser;
+	u64 luo_ser_pa;
 	void *fdt_out;
 	int err;
 
@@ -170,27 +178,45 @@ static int __init luo_fdt_setup(void)
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
index 8f5c5dd01cd0..5c27134ce7ba 100644
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
@@ -579,53 +565,19 @@ int __init luo_flb_setup_outgoing(void *fdt_out)
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
-
-		return -ENOENT;
-	}
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
 
-		return -EINVAL;
-	}
-
-	header_ser_pa = get_unaligned((u64 *)ptr);
-	header_ser = phys_to_virt(header_ser_pa);
+	if (!flbs_pa)
+		return;
 
+	header_ser = phys_to_virt(flbs_pa);
 	luo_flb_global.incoming.header_ser = header_ser;
 	luo_flb_global.incoming.ser = (void *)(header_ser + 1);
 	luo_flb_global.incoming.active = true;
-
-	return 0;
 }
 
 /**
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index ae58206f14ac..fe22086bfbeb 100644
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
index 47566db64598..85782c6f3d6c 100644
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
 
@@ -527,75 +524,34 @@ int luo_session_retrieve(const char *name, struct file **filep)
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


