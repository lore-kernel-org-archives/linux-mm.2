Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FE6BCD6E75
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 03:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C77D76B00A4; Thu,  4 Jun 2026 23:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29026B00A5; Thu,  4 Jun 2026 23:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3F686B00A6; Thu,  4 Jun 2026 23:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A43DC6B00A4
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:34:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 762841C2776
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:34:14 +0000 (UTC)
X-FDA: 84844440828.07.1967D0E
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id BC0E2100010
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:34:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PFlTjPs2;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780630452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2YcWKgEizOcY9z0vq5q3df4Dwqk/3q2KHCFvnTeL730=;
	b=4/xo3Si0YUexLBLpCJOMPRuY1Ur/Y/oLlPbKLhGm40vRXuS0OEb5C93ELAoIjC+vIEp+Py
	hR2NSx9kd7LPrDjgWibKxvuRKnT+EMVgd8TyJR1u/PRgjNj7irVRcH4doDRNKuvsHPM8TT
	1WfrQVqeBvhcTLVarfIrMpRoRv61wsw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PFlTjPs2;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780630452;
	b=zlbTDJ633LnwUhhqtcAHhMZ9OHosber14ri9pRDVa3HR4KETmlgyTvXz8tGDN/3a5UAGOu
	U6loBvSdwGow91rjfD2tNV1CNdHzfo7srLsZWDX0tbRhL1xZ66BImRhvhOL7/49LTNn9bh
	zikj4wNemeYf4tGqi1STYeoSvhvf6vU=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-91587626a3eso182710185a.2
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 20:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780630452; x=1781235252; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2YcWKgEizOcY9z0vq5q3df4Dwqk/3q2KHCFvnTeL730=;
        b=PFlTjPs2N+JuE51GE+jaEF988p1d668BcAPa0784Xsm4ZgY8UasbY/lGJC64+Uz4Do
         oB0hVPQ8nT1HVZBjBbtYl6LeV3lX2Z/qtIG47MULhFnzX2l4FUMcpOoTxsMM5wLqtI1Y
         YX3aze+GYnpczuWIWlRP+26DDCX5cqXKw9ushIwW00s225bZCSIxh+T4IsH+8hilVFLT
         BdYrXeGZBw0QK2L4JQAHsIg4USeWA1ZWC3jgjW7DtlpaE0mrqKlzH0EwHHDH4MOcNAGY
         WCXXZ7938OCSx44yf2TwW5GfYqerUX5RxpOC57ZbJxmTiO7rEKxue0NC6YxVugWygZQv
         PesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780630452; x=1781235252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2YcWKgEizOcY9z0vq5q3df4Dwqk/3q2KHCFvnTeL730=;
        b=CYlNVb1YtzoqkxUaHk2e4r41L//yBUk5qZML2lMd7rw03N55kESaed0wgEOsuoYE6J
         bT+yKziqmYAaK79dt3WUT2fi66XLGqIggkBCUxwzgZyWziz0JVp4GwnDYKE2zLWkDHqH
         XjKm/PL9sjVPcNDZpU6dBFEnqIecM38ONc2RoHx/qgkZKVepTlRG4E++nPtWTzccSfl9
         boTYYVjXfSFedamxdAFTmjxvD9I+7G9IiOKvrkXdOGOzaUTnj5CgU2JV9NPYF0Lev8NH
         JkApNRfF1x7Un+2gWti7WZZuLLzgQqVtq40dUtlHcXkZKLuvV3Y5J2Zyki2GhvhMsZLT
         CdYw==
X-Forwarded-Encrypted: i=1; AFNElJ9mHej2okap9ygYiZihQr6g/BlazxMrzD5Rcy3liUi6tQiEB6OruBSAm4EU3njc9Dc9CMzfXjU07Q==@kvack.org
X-Gm-Message-State: AOJu0YyIHEJ8YbETxBDpvAUPB+VKMrizGqHsW9NZge67EqigblRrjY0U
	w2ngTyQPf7aoUXpTGEcH9w/O815zeZAM0mvFDC8B+Cin6wkSXptQ8xKfvlr5EZjy5NA=
X-Gm-Gg: Acq92OHg5ot5lMlv0bZ/AdE2G5RLXVkORmKKx2hXdBT3hWFlCLmIDT1WH9jvv3OeBK2
	D6KBFp8XeAksL5aBWRXDlwV93hpUftumPGy5iKFL3sENss2KEuDJR/B/sVpEvHysfZdspgWdlkC
	+obUV9dA/8J4kRxEq2vuw21MglFpMVr5/EHxRnrVG2y4eRuLJEhM+hoHKjVfwQ6f6CZbgN9fx9/
	tD5G1AznLP+J8/+5mZctOs3A6w4ZFXvLst0eTVQsmRds1UlLQsWBXk6N3iCi+rB+H+e/oitn/KT
	gHV8l5+U2tIXAM2v5jWl0fagxtHyBRxeZ2d84rWzMZBkL+aHsAQF2BIGSt5ospp6Dz8q/e44aJ9
	K40Olxfzf6jmDnCbZzN52YAG0Rk28KN5kDRkgL0yGG2JtRmpKqxDu1/NJ1BF3N28j8eSM/ceGPY
	Hr+05iem4q+V1IIyhRf9Eo4ALpwC2ikx/tGhsL5JhieL0SVWv6xs7HzPksINB2UA==
X-Received: by 2002:a05:620a:f0e:b0:915:a953:4b93 with SMTP id af79cd13be357-915a9c4b267mr362733285a.3.1780630451754;
        Thu, 04 Jun 2026 20:34:11 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a00b474sm768496585a.10.2026.06.04.20.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 20:34:10 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	jasonmiu@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	ran.xiaokai@zte.com.cn,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [RFC v1 8/9] kho: decouple vmalloc compatibility from global KHO version and update memfd
Date: Fri,  5 Jun 2026 03:32:34 +0000
Message-ID: <20260605033235.717351-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260605033235.717351-1-pasha.tatashin@soleen.com>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BC0E2100010
X-Stat-Signature: kmnk63pkrh443z5fix411i1nqtptyqsd
X-Rspam-User: 
X-HE-Tag: 1780630452-838883
X-HE-Meta: U2FsdGVkX1+w3jBJYTdQMJhrGUuoOB40KJx6YmI1XZtb5PwitVVDPoNQofoFyPW904jDjYKG9ylHjoTEcY2ByFX3B67ZLOullCeaHf8dUoR6taDxAv3ivE3swFZdZRNqrho+ckvNlGKAepLODBmnv5pTn9KcEPtHBq2oa9SgOvyvB6rmbEQT1s4ZKw2pnd+1EKJfkRn9b9PUayi4Kz/vIcgYxwkKC0BkfgbDdFjG9Qvr3GsIkskGg279k6RBvxVCweUUnAnPFWhQ9dieA50iHnf7JR7KEmWFc543Z6omj3XiCBYVEg85rlfHuc+a6GEH+TrHGT3gVtV1loPBnFr/TWYGCF8iv2/moVsZ4F1QXpzvRA0c8JJGTP1EhqcmzZVLwo+IAXNYNhOhr/+/OP518i/ijwXrCI9IX0h9uIlrj+vPtmEBN8atQMvEloiG5PAEQYZ3PPVuJhcP4iSXN5vwsdh1gaCri4flNS4pjCfxZdWUp3Q1ZbrQ7Lq9uD0OFnvs1uvba42dr6JQHtEn5qO8HYcg7kyz6TVjOP8g1JdoHBM0RR1OcU35vAO1/wDaMsxR51JvJAIxrhzurswDOhLwHIoj/9M/vxUYt3eRKbojPGbhcWOKf/2W9yMZw5CxvkT0ovm2U85XRIbXoRW4gdfszqftZD7r3QjnIHnlXoe9NDXOmen/GGQaeGWnnmGTTQeWEZriGYfX88O7sO2utrQwVsIXFH5crp9N+W07ATStPyI0OMKC7v3Da+cUoUex0TXGJ+ZCxvN99eaT3spDdFPGSCtgt7kUcxCJ0cyT31IgzQOy6sHuH7nZ7CWgscmWfsIFXGfJV6bQjMkytocQm7a1E72MrZiN+xc9U8P9W67OjMR0/RbpYAwIrzChIb5c3MB2Sqm2k+K1NIyjBci0g8VKYY+xIEO7G2MqfaRFlCqqDhi4tY2m2eDeCYVP8Z3CS30Fh4Aum4kT+ubI+7ge48j
 Gpe1nDDc
 wQSO2eycJJVasWYZM/H9hd+B7ThqrDL+NnGRkIqotfGJDjzUDJKjdep3ZzGj+alM/8psQ8E4MFFba4bEWtL2TB4xGFfWKcHZV0iFAHXK2YfM/IPzLgf1oOLk3BNtYUvZWbODqG+q4V7fnCseHQS4nvBDeOZyJJ8bBfOHetPucMmsKapToYP0V/NRGKkbzAW4jNPZkOzWA9a1H46AmwlB1ffE9qk/CUEdpz28hCIqK/greDntCnn0MIziyq2r9PrKdaNUwAUEcmys6lgpEATozQXgMHyozttQdbbwW7qxmQ+1h8u6NjD2DRWUdpty+PdOCPTwbD1GimpEZWvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Decouple the vmalloc preservation compatibility version from the global
KHO compatibility version KHO_FDT_COMPATIBLE.

Define the independent compatibility version "vmalloc-v1" for vmalloc
preservation KHO_VMALLOC_COMPATIBLE in vmalloc.h.

Integrate KHO_VMALLOC_COMPATIBLE into the composite root compatibility
string KHO_FDT_COMPATIBLE.

Additionally, update the memfd compatibility string
MEMFD_LUO_FH_COMPATIBLE to include the vmalloc compatibility dependency,
and add a static assertion to verify its length limit.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/kexec_handover.h | 4 +++-
 include/linux/kho/abi/memfd.h          | 9 ++++++++-
 include/linux/kho/abi/vmalloc.h        | 6 ++++--
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 49ac4b47cc3d..f048bc95fed3 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -10,6 +10,7 @@
 #define _LINUX_KHO_ABI_KEXEC_HANDOVER_H
 #include <linux/kho/abi/compat.h>
 #include <linux/kho/abi/radix_tree.h>
+#include <linux/kho/abi/vmalloc.h>
 
 /**
  * DOC: Kexec Handover ABI
@@ -87,7 +88,8 @@
 #define KHO_FDT_COMPAT_BASE "kho-v4"
 #define KHO_FDT_COMPATIBLE						\
 	KHO_FDT_COMPAT_BASE						\
-	KHO_SUB_COMPAT(KHO_RADIX_COMPATIBLE)
+	KHO_SUB_COMPAT(KHO_RADIX_COMPATIBLE)				\
+	KHO_SUB_COMPAT(KHO_VMALLOC_COMPATIBLE)
 
 /* The FDT property for the preserved memory map. */
 #define KHO_FDT_MEMORY_MAP_PROP_NAME "preserved-memory-map"
diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index af310c0c9fdf..24ecbf48cbe1 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -11,7 +11,9 @@
 #ifndef _LINUX_KHO_ABI_MEMFD_H
 #define _LINUX_KHO_ABI_MEMFD_H
 
+#include <linux/kho/abi/compat.h>
 #include <linux/kho/abi/kexec_handover.h>
+#include <linux/kho/abi/luo.h>
 #include <linux/kho/abi/vmalloc.h>
 #include <linux/types.h>
 
@@ -89,6 +91,11 @@ struct memfd_luo_ser {
 } __packed;
 
 /* The compatibility string for memfd file handler */
-#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
+#define MEMFD_LUO_FH_COMPAT_BASE "memfd-v2"
+#define MEMFD_LUO_FH_COMPATIBLE						\
+	MEMFD_LUO_FH_COMPAT_BASE					\
+	KHO_SUB_COMPAT(KHO_VMALLOC_COMPATIBLE)
+
+static_assert(KHO_COMPAT_ALIGN(MEMFD_LUO_FH_COMPATIBLE) <= LIVEUPDATE_HNDL_COMPAT_LENGTH);
 
 #endif /* _LINUX_KHO_ABI_MEMFD_H */
diff --git a/include/linux/kho/abi/vmalloc.h b/include/linux/kho/abi/vmalloc.h
index 87650e1dd774..1847b82e147b 100644
--- a/include/linux/kho/abi/vmalloc.h
+++ b/include/linux/kho/abi/vmalloc.h
@@ -9,13 +9,13 @@
  *
  * The Kexec Handover ABI for preserving vmalloc'ed memory is defined by
  * a set of structures and helper macros. The layout of these structures is a
- * stable contract between kernels and is versioned by the KHO_FDT_COMPATIBLE
+ * stable contract between kernels and is versioned by the KHO_VMALLOC_COMPATIBLE
  * string.
  *
  * This interface is a contract. Any modification to the structure fields,
  * compatible strings, or the layout of the serialization structures defined
  * here constitutes a breaking change. Such changes require incrementing the
- * version number in the `KHO_FDT_COMPATIBLE` string to prevent a new kernel
+ * version number in the `KHO_VMALLOC_COMPATIBLE` string to prevent a new kernel
  * from misinterpreting data from an old kernel.
  *
  * Changes are allowed provided the compatibility version is incremented;
@@ -36,6 +36,8 @@
 #include <linux/types.h>
 #include <asm/page.h>
 
+#define KHO_VMALLOC_COMPATIBLE "vmalloc-v1"
+
 /* Helper macro to define a union for a serializable pointer. */
 #define DECLARE_KHOSER_PTR(name, type)	\
 	union {                        \
-- 
2.53.0


