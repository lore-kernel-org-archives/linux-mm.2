Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEBDDC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 19:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B13D6B0005; Sun, 28 Jun 2026 15:02:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 789716B0088; Sun, 28 Jun 2026 15:02:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69F216B008A; Sun, 28 Jun 2026 15:02:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E92F6B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 15:02:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A259F1C33A9
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 19:01:59 +0000 (UTC)
X-FDA: 84930241158.03.CFCD310
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf14.hostedemail.com (Postfix) with ESMTP id 09C0110000A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 19:01:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P2t3Fc9Y;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3pG9BagsKCOEVRXUDYSDQGDJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--souravpanda.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3pG9BagsKCOEVRXUDYSDQGDJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--souravpanda.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782673318;
	b=M49X4ASdWPuUmm4AvYeVMVI5p/8Pm3S/IjqAXraik61p2n3sNQKMr/Jm8UuJVNKnOV/CF3
	vQcAkFaY69/UYjFO8mDPFjqKSbPHSVQke1nqtbyFO5/ejBXyJ7qWFPvhZW7ttMWdT5VbeH
	NfpS13WiPKoVsCRhbRLOC1qhQg/b9nQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782673318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fHT/VH/FCGpteAy70lN8IuW/FU0GRl1Lj7eDs34tWTw=;
	b=o3Lmn1jXedtYDNWD0/8lwewAJ3XsxQ+ueHs4fNrkVk1hHJfnrZBsQw6/0L8mdKwLoCXKYn
	8XQzrYFbxY2zewhcX2wbLKQYBSDRx7U8Lo7+XA+8jNEC9sZE2gkrIpPQJzrh+8gTyrwcPl
	qcWRFMKMzTdf0jh1qCn4BJfOHBzS0b8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P2t3Fc9Y;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3pG9BagsKCOEVRXUDYSDQGDJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--souravpanda.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3pG9BagsKCOEVRXUDYSDQGDJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--souravpanda.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8478423e020so352261b3a.0
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 12:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782673317; x=1783278117; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fHT/VH/FCGpteAy70lN8IuW/FU0GRl1Lj7eDs34tWTw=;
        b=P2t3Fc9YY7I4KRw1ZtpThUTy+U9U08ZCHHC6CT4VDhiRRXDc/KTCnSWsnh16ONrg8n
         gAX1Zp9araufyZl4SvePH1FwarkVFrXjIpCyw2o8QgfDb94Fg+uht6kbWT7P9SOc82Z9
         Vnm6FTanfMpX4RB2vYdKmBTp2hajao6mcZDS0z7mdhqidW3W3NrjAoaxGTDKoO7X6+e9
         3Z8OIonHWCjx1pWDuCODtQeV2GWU5zj+RvceXR3QKanahv/senUqjYnIqcUR86X9sCrA
         gi5J+nMnX/hnhQaskfNxVq05Z/kLESBmgCmmGC3dzKG6/nJZPMDGbYQpqDzh7MzmplC/
         b20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782673317; x=1783278117;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fHT/VH/FCGpteAy70lN8IuW/FU0GRl1Lj7eDs34tWTw=;
        b=tPksg8fBHQ5O9tyF2OowzeLbD/jUSM8zT0/cdwEG1cMxHWnKN+R2UeoRhkSlDGsz1W
         V8NdX0u2JYZW0izjECbg9jv6m6CLFMHIkDYYvP4oubwaQdW9JDKKcBZcAGi8F1WWDG7X
         uQjZypFP+2QuppEkiwRKlC89QcjKFuhIL9F4qP7qXYNOFCyBHwqOWDgb/5RRw8qD2pk0
         1c14OJXL/a66t01/SFOciUwQGujs6BfuXF4Vsg8OvsWJTZ3XddojysNfpByOCwM8vOLR
         r7mL++hpNQkFnHm4tapzv5Buly88wOL/MHNu5eXkO9nVxUSU73MLQRFeDcu2wVUxh9G5
         fSbg==
X-Forwarded-Encrypted: i=1; AHgh+RqOt5MnZSt0qZzchRXN8oNazJGE80kiG6zXq8mPfgDhalc9zDkC+ZCUIFdBKQynbSAowOJA1ALzeA==@kvack.org
X-Gm-Message-State: AOJu0YwC9VHRHkIdQ6cmMBwpXpBUkKObfK5JFknFvytJGhexNMDu5Ci6
	sKExlfRFEpwe/rprZykPB7TRxgbm4fN/eMXFtbiOtwqRIjErNQIxiDdDM83JaPUyOzEuecTFtWC
	SgZtMVmFGKYSvNiG/HAaMHHVEyQ==
X-Received: from pfbcj24.prod.google.com ([2002:a05:6a00:2998:b0:845:c378:7950])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:6c8e:b0:846:2f5b:c00 with SMTP id d2e1a72fcca58-8462f5b0d5fmr2493452b3a.54.1782673316699;
 Sun, 28 Jun 2026 12:01:56 -0700 (PDT)
Date: Sun, 28 Jun 2026 19:01:55 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260628190155.3655895-1-souravpanda@google.com>
Subject: [PATCH v2] mm/hugetlb_cma: support percentage-based hugetlb_cma reservation
From: Sourav Panda <souravpanda@google.com>
To: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	rientjes@google.com, souravpanda@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 09C0110000A
X-Stat-Signature: t1xxqehutd933dcjhc6hdxs4sea3uduc
X-HE-Tag: 1782673317-380323
X-HE-Meta: U2FsdGVkX1+bmyGgnWkZRXX2Ro8/5VQVdsixAUyRilkkcq1vFWjLT80INofUy45Rp6I0S+0mVICdu8lv0nwmmc1TvXpoX2dDQcZQhFoT4dFW9CnrPyj6Zzbls0JmjB/LG72xG/i8hBfC2LLSZicRGeMMfF6TyFMf7KHSiU3wbKib68IMqVx5KbEhv6t+3NyTY9o68xm5NV8WVTMIyM4zunf8g2QW1Zy2p7QWYsyL5HmSRgQqj4+Rwgz0Sb1zlDKxO1XRfWY4e5N7yhLtiNlIYMdQbV7Jb+gyYyOXkYvU2+voDpwI3MBZ7/t2XMHQrkXSVde941C3n033yw2xdnJi1QYxJd224BK1fCsxm6F1RcxVGoV6H3erPjV6kbJ9zaclQWN6cCehtP/lf0EY9IT8h0jkRqOVMmpRUDXRRtFPoE4UamYJ1eBMfFpse0rqieAFgC1ctgP+ukWik0uU5tsI7jo4DZottfD4vlI/KcxQ+THYU8fSGDyxyO0q/h3Q3BAxIJpVAKbmmEc8gIUX/wz0eYRvCmB67b8dtD5dPF1gVvF1293mYLaBKqHExwYPpKJkVb+FsqhjN346hTC8vzAlJjmJyyDbN6ptg8flUuomyn2jh6GUarrE71k9TTMnpIu+LldVX9IaCN/JExKNcDPeuoYJEp49WNz+XvvRXeXyqxKLnGI76HfhZVL7YEkq2xuvx8nTfbY6s3iJDTz62PsyRoaOS328wI1Hsjv1hFubDryqUSrFXL8RPONCEl+xCRuRxfR4B3sjJfxxLZ3o5Zz/XblOfys5Y1kwRLrwgMqNqHuSzwqNYOimagbcrXJ0qaa9KE3eL+M4ciMUXURxlYEP0/2+xefnF4p9c57bv1HO8gH+F4JhD0gzbsRfqnrvpA8ByoandH8PZ8awoPzUonDOe7iLu2nnyJVj6QyVRHKO5Tsf1bRE7u4rDuMcnVqOYNs+qbLVuvE/PgZtdUoI0l1
 0fR8I5Lk
 9DU46QilAPfBzoxFZxGFsgGeQLXSIKRdWLqJ3Tkj4fA43qXC6I2YKXPA4M6x3brX+0qk/cJoAsO7A7tNmh9Q+Nfn6kzg4E3MtLCtOPNmJop3TAbf31EKU+6QV5FpV0u1DP0aiiOl2z1iAkHEx2aOyYvKtj2L3vvnu2Xkr/M2mkT++aR7QKGhUm+QUe2Peo15JTc1ufTN7mhhgoCjYWkbNUbw4RBSk1qif3P5KBvy83mc8Hf1/2SlPJIXGvwa8w2r4Sh2vj8RXrzho69lU2vxkPu8yATeGWyVW+DYpcb74nfVtsU6/weUBx7rawmzCxzPSVXNLIKmI1OheTu9SbgIyFw/RjaQuPqSpeSJ2DCUqPDGdNwFsTmAVel98qFnGZfNhamAtW4h8njCmrOEgGCrcAYdr0QqL/UwPezWL4FIbQHThk99fup9ana48CwtXgCyAQYDn+k8cALhOzavJHKbZSOSdWtfIxaqJRHaFDAqwgFclPZmqr1ZzyxTaSYjSQAOMWwm42aQIxpoBYw+1tXKvlkZFcwWIKRuEnrvUP7Rlx1wSjBljjpUYNjdUvzPnN0GVrsTvuOEohoPm4xSP2vfWVcOxU6n/sLwdExzTr4JswwahOi5jNnW1hATjac7TX8tiZfppnsYoAIW8p+AmKa/8hWUJQhvx81n6A3UxTWk8hinDbDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, hugetlb_cma reservation only supports absolute sizes (e.g.,
hugetlb_cma=2G or hugetlb_cma=0:1G,1:1G). This can be restrictive in
heterogeneous environments or when deploying common kernel command lines
across machines with different memory capacities.

Add support for percentage-based hugetlb_cma reservation (e.g.,
hugetlb_cma=20% or hugetlb_cma=0:20%,1:10%).

The percentage is calculated against the total memory (for global
settings) or against the node-specific memory (for node-specific
settings) using memblock APIs during early boot.

Signed-off-by: Sourav Panda <souravpanda@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606262023.IKUrn01I-lkp@intel.com/
---
Link: https://lore.kernel.org/linux-mm/20260625215900.2151690-1-souravpanda@google.com/ [v1]

v2:
- Use mul_u64_u32_div() instead of mult_frac() to avoid 64-bit division on 32-bit architectures (Reported by kernel test robot).
- Fix physical memory size truncation on 32-bit PAE by using phys_addr_t in memblock_node_memory_size() (Sashiko).
- Fix boot parameter override logic to respect standard last-one-wins precedence by clearing opposite values during parsing and clearing node-specific values when global values are parsed.
 .../admin-guide/kernel-parameters.txt         |  7 +-
 mm/hugetlb_cma.c                              | 96 ++++++++++++++++++-
 2 files changed, 97 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 5a05b48d1684..846940ce2858 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2064,8 +2064,11 @@ Kernel parameters
 	hugetlb_cma=	[HW,CMA,EARLY] The size of a CMA area used for allocation
 			of gigantic hugepages. Or using node format, the size
 			of a CMA area per node can be specified.
-			Format: nn[KMGTPE] or (node format)
-				<node>:nn[KMGTPE][,<node>:nn[KMGTPE]]
+			The size can be an absolute value (e.g., 2G) or a
+			percentage of the total memory or node memory (e.g., 20%).
+			Format: nn[KMGTPE] or nn% or (node format)
+				<node>:nn[KMGTPE][,<node>:nn[KMGTPE]] or
+				<node>:nn%[,<node>:nn%]
 
 			Reserve a CMA area of given size and allocate gigantic
 			hugepages using the CMA allocator. If enabled, the
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 7693ccefd0c6..684ffa3537d2 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -9,6 +9,9 @@
 #include <asm/setup.h>
 
 #include <linux/hugetlb.h>
+#include <linux/memblock.h>
+#include <linux/math.h>
+#include <linux/math64.h>
 #include "internal.h"
 #include "hugetlb_cma.h"
 
@@ -18,6 +21,28 @@ static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
 static bool hugetlb_cma_only __ro_after_init;
 static unsigned long hugetlb_cma_size __ro_after_init;
 
+static unsigned int hugetlb_cma_percent __initdata;
+static unsigned int hugetlb_cma_percent_in_node[MAX_NUMNODES] __initdata;
+
+#ifdef CONFIG_NUMA
+static phys_addr_t __init memblock_node_memory_size(int nid)
+{
+	struct memblock_region *reg;
+	phys_addr_t size = 0;
+
+	for_each_mem_region(reg) {
+		if (reg->nid == nid)
+			size += reg->size;
+	}
+	return size;
+}
+#else
+static phys_addr_t __init memblock_node_memory_size(int nid)
+{
+	return memblock_phys_mem_size();
+}
+#endif
+
 void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
 	WARN_ON_ONCE(!cma_release_frozen(hugetlb_cma[folio_nid(folio)],
@@ -100,14 +125,28 @@ static int __init cmdline_parse_hugetlb_cma(char *p)
 			break;
 
 		if (s[count] == ':') {
+			char *next;
+
 			if (tmp >= MAX_NUMNODES)
 				break;
 			nid = array_index_nospec(tmp, MAX_NUMNODES);
 
 			s += count + 1;
-			tmp = memparse(s, &s);
-			hugetlb_cma_size_in_node[nid] = tmp;
-			hugetlb_cma_size += tmp;
+			tmp = memparse(s, &next);
+			if (*next == '%') {
+				if (tmp > 100) {
+					pr_warn("hugetlb_cma: invalid percentage %lu for node %d\n",
+						tmp, nid);
+					break;
+				}
+				hugetlb_cma_percent_in_node[nid] = tmp;
+				hugetlb_cma_size_in_node[nid] = 0;
+				s = next + 1;
+			} else {
+				hugetlb_cma_size_in_node[nid] = tmp;
+				hugetlb_cma_percent_in_node[nid] = 0;
+				s = next;
+			}
 
 			/*
 			 * Skip the separator if have one, otherwise
@@ -118,7 +157,28 @@ static int __init cmdline_parse_hugetlb_cma(char *p)
 			else
 				break;
 		} else {
-			hugetlb_cma_size = memparse(p, &p);
+			char *next;
+
+			tmp = memparse(p, &next);
+			if (*next == '%') {
+				if (tmp > 100) {
+					pr_warn("hugetlb_cma: invalid percentage %lu\n", tmp);
+				} else {
+					hugetlb_cma_percent = tmp;
+					hugetlb_cma_size = 0;
+					for (nid = 0; nid < MAX_NUMNODES; nid++) {
+						hugetlb_cma_size_in_node[nid] = 0;
+						hugetlb_cma_percent_in_node[nid] = 0;
+					}
+				}
+			} else {
+				hugetlb_cma_size = tmp;
+				hugetlb_cma_percent = 0;
+				for (nid = 0; nid < MAX_NUMNODES; nid++) {
+					hugetlb_cma_size_in_node[nid] = 0;
+					hugetlb_cma_percent_in_node[nid] = 0;
+				}
+			}
 			break;
 		}
 	}
@@ -144,8 +204,36 @@ void __init hugetlb_cma_reserve(void)
 {
 	unsigned long size, reserved, per_node, order;
 	bool node_specific_cma_alloc = false;
+	bool has_node_specific_param = false;
 	int nid;
 
+	for (nid = 0; nid < MAX_NUMNODES; nid++) {
+		if (hugetlb_cma_size_in_node[nid] || hugetlb_cma_percent_in_node[nid]) {
+			has_node_specific_param = true;
+			break;
+		}
+	}
+
+	if (has_node_specific_param) {
+		hugetlb_cma_size = 0;
+		for (nid = 0; nid < MAX_NUMNODES; nid++) {
+			if (hugetlb_cma_percent_in_node[nid]) {
+				phys_addr_t node_gfp_mem = memblock_node_memory_size(nid);
+				u64 s;
+
+				s = mul_u64_u32_div((u64)node_gfp_mem,
+						    hugetlb_cma_percent_in_node[nid],
+						    100);
+
+				hugetlb_cma_size_in_node[nid] = s;
+			}
+			hugetlb_cma_size += hugetlb_cma_size_in_node[nid];
+		}
+	} else if (hugetlb_cma_percent) {
+		hugetlb_cma_size = mul_u64_u32_div((u64)memblock_phys_mem_size(),
+						   hugetlb_cma_percent, 100);
+	}
+
 	if (!hugetlb_cma_size)
 		return;
 
-- 
2.55.0.rc0.799.gd6f94ed593-goog


