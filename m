Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DCAA60A2602
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hgyo74ux
Received: by kanga.kvack.org (Postfix)
	id 830EF6B05C0; Tue, 10 Nov 2026 00:02:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E19B6B05C1; Tue, 10 Nov 2026 00:02:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9936B05C2; Tue, 10 Nov 2026 00:02:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FD0F6B05C0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:19 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 93B3D808B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:18 +0000 (UTC)
X-FDA: 85418013156.13.AC6AA46
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf25.hostedemail.com (Postfix) with ESMTP id CD634A0003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hgyo74ux;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3V6XyagkKCMo9q7A38qxAw44w1u.s421y3AD-220Bqs0.47w@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3V6XyagkKCMo9q7A38qxAw44w1u.s421y3AD-220Bqs0.47w@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlBTWBMpEbDIIvafpldBklRCZ2ctie9uKxzA73glXH4=;
	b=L1VkEZHM/HEDA6DjGBzdmCNysF1NMfFL4U5cV7QTuZtZsoxkr+qrwNlJrYBhcHpSXDnidn
	dQnDP0nSATCnefd608A0/fsuMrZUUcaLjr1oicALwaGQ/Cm5s4f0ji7TBFWj1Ek2SUYyDZ
	E1TtGb200JmtbuIqxOUSVdrdppWElfM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hgyo74ux;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3V6XyagkKCMo9q7A38qxAw44w1u.s421y3AD-220Bqs0.47w@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3V6XyagkKCMo9q7A38qxAw44w1u.s421y3AD-220Bqs0.47w@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286936;
	b=UWTiTlujuP+d7IcXZ9YQCFxsXSF6AdrGiyhKDbvveLlMPxzIhABhXvVzqcVd3UqRkIPva7
	DkBVjPZLRTt1TM5P9GvtJz1nrd2VqHI/iIWtbvGeFKBatID9gHGPX8i4aJkcqb0S94CdEF
	Yd9J8MLzh6hU/9kqkM/IsGaIjlc/1rM=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c42f98f354fso137719566b.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286935; x=1794891735; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KlBTWBMpEbDIIvafpldBklRCZ2ctie9uKxzA73glXH4=;
        b=hgyo74ux9SkBjayV7foFhUKyRN0sFFaj9zzQsJIF8I7P4P2WFV9hyJ0bW+K51OEXdO
         TDhCslp1Emc9zeZs7YEi1O0aH1J4Vz7AtFfgHuNGdtoUvobydHQzXsbJ/RTNrqsWirgb
         VWTeWfGjGY8CpRLs9QgmnkYLzMPKJlj1w2jvj9VLzO8oBNn0zMxDPyqNE3OIY8oNqxR0
         22GD6yvuv1VSmR++vpf8JVIRh/sUA5QgDWzgbtk/e6aTRcJDVbWaALBaDb44ImpVaQyW
         qjBcP8iyqwDUbcXOXiy4cLcPHrkQzut26xp8lTH1BibfKwRUzC0qMPNQUsqr7vt4+lkn
         0/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286935; x=1794891735;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KlBTWBMpEbDIIvafpldBklRCZ2ctie9uKxzA73glXH4=;
        b=gnVzB4mQRJ7mNFTCfAc7k2OJp0oZEcVwK43A0ROk1g+ps+Hauvb3Pq63ZUJxWXRVBL
         LXsPoEIek0vCxrUUcCsXr0Pgv5DjmF5d6UPwqrcmGsWIeNatP2KmqFgZtIj9mn4FJXT6
         7Wzw3rxTiTQU7MfRaA4nFsqK2VAhuELuiB7aSgIZcM6PgJVqnjHKaHdL1qYs+JXhf/hb
         eCCiRY809a+QVUbFUIPfk4pc1p5bw42borNUre7Ms1VpYUsm7vzy8WQGMwNIYmOtYCEM
         FADN6CgXp4ghNTAq45/2F0hx44kYFpn5dpf5H3kBW6qlgR1MoBtetFGrMQMcrcSDC2j1
         azLg==
X-Forwarded-Encrypted: i=1; AL+hErEhKfldALdGskovaUphohpZ0+rPFl5f1V5KQRcUd9mUf89mfWp0MsqsYFhAldM+1Wjgd0pjClHNSw==@kvack.org
X-Gm-Message-State: APuU4Z8V5O6zFvTtJi8yS+C3Mb83T6ZR9J5gAJ3yg52eKTLvvtCqLu6M
	6PqrdHMxmpHqIDMYUuNuqKjQyNAEgU+s8D4usQ2W73QvJMiDOMqgr4g+i3cF/e9zvZTPinAtSN9
	69Q8h+Paz26GOqoWebw==
X-Received: from ejpg24.prod.google.com ([2002:a17:906:7c58:b0:c3f:eea3:d5e9])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3d8f:b0:c44:9a32:b27 with SMTP id a640c23a62f3a-c5049623935mr98305266b.25.1794286935134;
 Mon, 09 Nov 2026 21:02:15 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:52 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-10-tarunsahu@google.com>
Subject: [PATCH v4 09/19] liveupdate: Add feature header to struct luo_ser
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CD634A0003
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: byt9jnqn1obhwes75hrb9xtucr4wdgz4
X-HE-Tag: 1794286936-266426
X-HE-Meta: U2FsdGVkX19DwkHNTGMP72Sh6USddHcwJwplqBvdDG8NsbIemtV6Hr8+xu6g7H5QaEnddrow0Z2/NuFm/GSW6Sh49+UVjdD/8PF/OrOvk7nGWYExsHbdzlpnQpI+2td7/bAL+6N+4H/rBVTfpVfzeg6fHded4GsjC671P6jF7GOoFudeceFIVFZrlAPwucuAhxONkreE1NI0v4gzIajEjluytmP5p+P4oVH9+ufQKk3ePJlisfiVSbIxguxkRKPrxPldi/m7yBUvTLJwSsgdCwYc8Mfp5yk3Q60urfL7uQqssDTQVUf1gzNZWeeWVE8wrd2yqmo8chPBVDnCPxED4r6fthkvIaErXsQtpAruZAvxyr8G8zGWhnI/iZMgFR0T1gVxOceq9cI4yKJN1vuAlof37QcZR9sxhHXMg+tIYIlPy5DcNZ9otmpfGmEOW0pRWfJ9QepG5mjffxUUw+HGU1dQoPVxI2FlNLyMC1X0XgMAQmi1o0DX5yGBlU2ABayy6CVCXAA1aB6bdUipLT3eiACriJUOSwe/98tqK4UCruJBh8ZdindefKkECGQpzd8+YyKBeOZvwrOGBJrbemr1d/H+C+zvCpBW7EmhvrQpRq1NqFcFEI1Yu50qhaS4HfHmhd3coXyiOpClIWNwi6fiFFYm3FE5XkVLwdUYGde7i0zMRp3ssoOXFYsokqaP+3BQBRklX+H/0sWNMHqCqH8JB5b4Uz+aiASeqe2dMlIlirQTH6gZh/NgwRYJUjTNNybaaQH7ERwoZUekCS6Kns2GAty+mMDIXvOWnZs1c2X6uUq6wa9hYk+6gbChBrDnnsZTwg4/PYsabyjdNRXaQ7wbLpjZTkEDLGcQWyJex2SnVtglAv4HPWwhGdzN/ZYR3G0tfL3VVTXyrBN2pZCigVxjoML9MarCSY3vcOLbO6YOKjvlozlEMBe4D7p4p46OW77W7HzHiha7KO8IvbZy2HT
 GFakr3D1
 TGY7Y4/RDZrE6/rptOcAF2tVRIe/spllN4CaVhurEzBm7nhfObv6Oa5QJPfxetnS7XTyvRqCmNjp61ERd3NH2LsMDSHROFGrU8r0iejqOkbPen7nNl/lKrdVfCpqwjPV3EM/XWuSlhmFxDIJakZVuXn6NMhV7VSggfWiFzqOB83FW6SRi66F0SLFdpYbywxlM2nTRU1IENuVpX1j0c7GCQW7dZEcUZau14SO6OGZpUUmSvNJ8l7WKWyYzWqFjxHm/G6TeA9fP/6248n/yz/g1OsdjckbFaqG/LjLs5t5gGd0o0J1ZcDWifeU0C7YuFUwr2jqbdLRrqZRp2USOfLKAu7J2c7ZFIwVGpVkZYzec8iin+d8KEsbyYi5TKWR3cK4nv2NK4oLK+lR/lGJp7NG5Fu+7oqH2P0nxSQFXgEJyIdNuzBqhWmqTbSz/vuwwlxGTIDK4n/Blomu8xpcGtBp8NjKehqtPEgja6d8Co/QjqGbcoUvlhNX9ZNgA7pTo3aomdUrCznub7k62/al2dODQHwlQZn6pEhawxskMy0HIiDqZf9A4AbwqwxrGIP+o5KhP8j+L2V2jie3irI5U5x/+c4aVON6AT6zsuXSOfJZGa+LYyiWmsfjnTD+VKM7BgTby2KPChYH5tyJy2LqAlsHOcfsxDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

LUO and its file handlers currently rely solely on coarse-grained
compatibility strings (such as luo-v6 and memfd-v3) to validate
handed-over state across kexec. Because compatibility is checked only
at the whole-structure level, any change to a serialized structure,
even an optional additive field, requires bumping the compatibility
string and breaks live update between adjacent kernels.

Precede the centralized struct luo_ser with struct kho_ser_hdr using
DECLARE_KHO_SER. Subsystems can now evolve their serialized state at
per-feature granularity. Each subsystem groups the fields of its
serialized structure under feature indices, starting with index 0 for the
base fields. When a subsystem adds a new capability, it appends any new
fields to the end of its payload structure under a new feature index.
Retired fields are kept in place so existing field offsets never shift;
if the type or format of a field needs to change, the existing field and
feature are kept intact until retired and a new feature index with an
appended field of the new type is added. Only when a change requires a
complete break in the serialized layout or semantics that feature flags
cannot handle, a new handler can be introduced with an incremented version
number in its compatibility string.

Signed-off-by: Logan Odell <loganodell@google.com>
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/luo.h  | 64 +++++++++++++++---------------------
 kernel/liveupdate/luo_core.c | 39 +++++++++++++---------
 2 files changed, 50 insertions(+), 53 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index f1152470f71a..dfa7ea434d0d 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -9,29 +9,26 @@
  * DOC: Live Update Orchestrator ABI
  *
  * Live Update Orchestrator uses the stable Application Binary Interface
- * defined below to pass state from a pre-update kernel to a post-update
- * kernel. The ABI is built upon the Kexec HandOver framework and registers
- * the central `struct luo_ser` via the KHO raw subtree API.
+ * defined below to pass state from a source kernel to a target kernel.
+ * The ABI is built upon the Kexec HandOver framework and registers the
+ * central `struct luo_ser` via the KHO raw subtree API.
  *
- * This interface is a contract. Any modification to the structure fields,
- * compatible strings, or the layout of the `__packed` serialization
- * structures defined here constitutes a breaking change. Such changes require
- * incrementing the version number in the relevant `_COMPATIBLE` string to
- * prevent a new kernel from misinterpreting data from an old kernel.
- *
- * Changes are allowed provided the compatibility version is incremented;
- * however, backward/forward compatibility is only guaranteed for kernels
- * supporting the same ABI version.
+ * This interface is a contract. `struct luo_ser`, and the serialized state
+ * of each file handler that uses it, are preceded by `struct kho_ser_hdr`.
+ * See the KHO Serialization Feature Header ABI documentation in
+ * include/linux/kho/abi/feature.h for the header layout, the feature rules
+ * and validation.
  *
  * KHO Structure Overview:
  *   The entire LUO state is encapsulated within a single KHO entry named "LUO".
- *   This entry contains the `struct luo_ser` structure.
+ *   This entry contains a `struct kho_ser_hdr` followed by the
+ *   `struct luo_ser` payload.
  *
  * Serialization Structures:
  *   - struct luo_ser:
- *     The central ABI structure that contains the overall state of the LUO.
- *     It includes the compatibility string, the liveupdate-number, and pointers
- *     to sessions and FLBs.
+ *     The central ABI payload structure that contains the overall state of
+ *     the LUO (the liveupdate-number and physical pointers to sessions and
+ *     FLBs), preceded by `struct kho_ser_hdr`.
  *
  *   - struct luo_session_ser:
  *     Metadata for a single session, including its name and a physical pointer
@@ -40,7 +37,7 @@
  *
  *   - struct luo_file_ser:
  *     Metadata for a single preserved file. Contains the `compatible` string to
- *     find the correct handler in the new kernel, a user-provided `token` for
+ *     find the correct handler in the target kernel, a user-provided `token` for
  *     identification, and an opaque `data` handle for the handler to use.
  *
  *   - struct luo_flb_header_ser:
@@ -57,39 +54,36 @@
 #ifndef _LINUX_KHO_ABI_LUO_H
 #define _LINUX_KHO_ABI_LUO_H
 
-#include <linux/align.h>
 #include <linux/build_bug.h>
 #include <linux/kconfig.h>
 #include <linux/kho/abi/block.h>
+#include <linux/kho/abi/feature.h>
 #include <linux/kho/abi/kexec_handover.h>
+#include <linux/types.h>
 #include <uapi/linux/liveupdate.h>
 
 /*
  * The LUO state is registered under this KHO entry name.
  */
 #define LUO_KHO_ENTRY_NAME	"LUO"
-#define LUO_ABI_COMPATIBLE	"luo-v6"
-#define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
 
 /**
- * struct luo_ser - Centralized LUO ABI header.
- * @compatible:     Compatibility string identifying the LUO ABI version.
+ * struct luo_ser - Centralized LUO ABI payload.
  * @liveupdate_num: A counter tracking the number of successful live updates.
  * @sessions_pa:    Physical address of the first session block header.
  * @flbs_pa:        Physical address of the FLB header.
  *
- * This structure is the root of all preserved LUO state.
+ * This structure is the root payload of all preserved LUO state, preceded by
+ * &struct kho_ser_hdr.
  */
 struct luo_ser {
-	char compatible[LUO_ABI_COMPAT_LEN];
 	u64 liveupdate_num;
 	u64 sessions_pa;
 	u64 flbs_pa;
 };
 
-static_assert(sizeof(struct luo_ser) == 32);
-static_assert(!IS_ENABLED(CONFIG_64BIT) ||
-	      __alignof__(struct luo_ser) == 8);
+/* Register luo_ser with KHO serialization accessors */
+DECLARE_KHO_SER(luo_ser, 24, 0, 0);
 
 #define LIVEUPDATE_HNDL_COMPAT_LENGTH	48
 
@@ -98,8 +92,6 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
  * @compatible:  File handler compatible string.
  * @data:        Private data
  * @token:       User provided token for this file
- *
- * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
  */
 struct luo_file_ser {
 	char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
@@ -138,10 +130,8 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
  *
  * This structure is used to package session-specific metadata for transfer
  * between kernels via Kexec Handover. An array of these structures (one per
- * session) is created and passed to the new kernel, allowing it to reconstruct
- * the session context.
- *
- * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
+ * session) is created and passed to the target kernel, allowing it to
+ * reconstruct the session context.
  */
 struct luo_session_ser {
 	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
@@ -180,13 +170,13 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
 /**
  * struct luo_flb_ser - Represents the serialized state of a single FLB object.
  * @name:    The unique compatibility string of the FLB object, used to find the
- *           corresponding &struct liveupdate_flb handler in the new kernel.
+ *           corresponding &struct liveupdate_flb in the target kernel.
  * @data:    The opaque u64 handle returned by the FLB's .preserve() operation
- *           in the old kernel. This handle encapsulates the entire state needed
- *           for restoration.
+ *           in the source kernel. This handle encapsulates the entire state
+ *           needed for restoration.
  * @count:   The reference count at the time of serialization; i.e., the number
  *           of preserved files that depended on this FLB. This is used by the
- *           new kernel to correctly manage the FLB's lifecycle.
+ *           target kernel to correctly manage the FLB's lifecycle.
  *
  * An array of these structures is created in a preserved memory region and
  * passed to the new kernel. Each entry allows the LUO core to restore one
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 1b2bda22902d..d0f72f27001d 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -66,7 +66,7 @@
 
 static struct {
 	bool enabled;
-	struct luo_ser *luo_ser_out;
+	DECLARE_KHO_SER_HDR(luo_ser, *luo_ser_out);
 	u64 liveupdate_num;
 } luo_global;
 
@@ -83,6 +83,7 @@ early_param("liveupdate", early_liveupdate_param);
 
 static int __init luo_early_startup(void)
 {
+	DECLARE_KHO_SER_HDR(luo_ser, *fhdr);
 	phys_addr_t luo_ser_phys;
 	struct luo_ser *luo_ser;
 	size_t len;
@@ -107,17 +108,21 @@ static int __init luo_early_startup(void)
 		return 0;
 	}
 
-	if (len < sizeof(*luo_ser)) {
-		pr_err("LUO state is too small (%zu < %zu)\n", len, sizeof(*luo_ser));
-		return -EINVAL;
+	fhdr = phys_to_virt(luo_ser_phys);
+	if (len < sizeof(*fhdr) || fhdr->size > len) {
+		pr_err("LUO state size invalid (source kernel header size=%u, KHO len=%zu)\n",
+		       len >= sizeof(*fhdr) ? fhdr->size : 0, len);
+		err = -EINVAL;
+		goto out_free_ser;
 	}
 
-	luo_ser = phys_to_virt(luo_ser_phys);
-	if (strncmp(luo_ser->compatible, LUO_ABI_COMPATIBLE, LUO_ABI_COMPAT_LEN)) {
-		pr_err("LUO state is incompatible with '%s'\n", LUO_ABI_COMPATIBLE);
-		return -EINVAL;
+	err = kho_ser_validate(fhdr, luo_ser);
+	if (err) {
+		pr_err("LUO state feature validation failed: %pe\n", ERR_PTR(err));
+		goto out_free_ser;
 	}
 
+	luo_ser = kho_ser_payload(fhdr, luo_ser);
 	luo_global.liveupdate_num = luo_ser->liveupdate_num;
 	pr_info("Retrieved live update data, liveupdate number: %lld\n",
 		luo_global.liveupdate_num);
@@ -131,7 +136,7 @@ static int __init luo_early_startup(void)
 	err = 0;
 
 out_free_ser:
-	kho_restore_free(luo_ser);
+	kho_restore_free(fhdr);
 	return err;
 }
 
@@ -153,16 +158,18 @@ early_initcall(liveupdate_early_init);
 /* Called during boot to create outgoing LUO state */
 static int __init luo_state_setup(void)
 {
+	DECLARE_KHO_SER_HDR(luo_ser, *fhdr);
 	struct luo_ser *luo_ser;
 	int err;
 
-	luo_ser = kho_alloc_preserve(sizeof(*luo_ser));
-	if (IS_ERR(luo_ser)) {
+	fhdr = kho_alloc_preserve(kho_ser_size(luo_ser));
+	if (IS_ERR(fhdr)) {
 		pr_err("failed to allocate/preserve LUO state memory\n");
-		return PTR_ERR(luo_ser);
+		return PTR_ERR(fhdr);
 	}
+	kho_ser_init(fhdr, luo_ser);
 
-	strscpy(luo_ser->compatible, LUO_ABI_COMPATIBLE, sizeof(luo_ser->compatible));
+	luo_ser = kho_ser_payload(fhdr, luo_ser);
 	luo_ser->liveupdate_num = luo_global.liveupdate_num + 1;
 
 	luo_session_setup_outgoing(&luo_ser->sessions_pa);
@@ -171,16 +178,16 @@ static int __init luo_state_setup(void)
 	if (err)
 		goto exit_free_luo_ser;
 
-	err = kho_add_subtree(LUO_KHO_ENTRY_NAME, luo_ser, sizeof(*luo_ser));
+	err = kho_add_subtree(LUO_KHO_ENTRY_NAME, fhdr, fhdr->size);
 	if (err)
 		goto exit_free_luo_ser;
 
-	luo_global.luo_ser_out = luo_ser;
+	luo_global.luo_ser_out = fhdr;
 
 	return 0;
 
 exit_free_luo_ser:
-	kho_unpreserve_free(luo_ser);
+	kho_unpreserve_free(fhdr);
 	pr_err("failed to prepare LUO state: %d\n", err);
 
 	return err;
-- 
2.56.0.506.g506a7eabc5-goog


