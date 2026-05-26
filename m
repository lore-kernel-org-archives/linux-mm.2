Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21AA0CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BB566B00C1; Tue, 26 May 2026 07:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8933D6B00C3; Tue, 26 May 2026 07:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AA506B00C4; Tue, 26 May 2026 07:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0966B00C1
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:37:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20BB814031B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:37:41 +0000 (UTC)
X-FDA: 84809371122.28.5187B28
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2019A40006
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:37:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qp3Tjwk3;
	spf=pass (imf17.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779795459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RepOlA7uegAkHRX0rdEAbivBLVoGLgApQvWSVyuj8bk=;
	b=CX6MZg3Wm/lTOxgDLFs6AWWRJOec4b11AV7xq4Z8ZS8y6R86F1fnIcxTn9gg7RSSJpw7nG
	1KJrXONppu4Qw2qxKDUaz9Av5kROivoaQNM8q2gNQI9aH/hlTUcVRWnioiW/C48iEnv3AP
	hbvY2aPRyJpyUD/InvpyXt9fhgSOI1Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779795459; a=rsa-sha256;
	cv=none;
	b=guNcxfQJD5S2Ftd4+APmV10z+VuIk5cQ1YJissPZ8NXAxpoD+EcizTtIYxeX1ro71+HQ9U
	Wv39cVsKBvsCA2jvag5Rs+idX0ZBOrUFGyYSSbPcFc2zaaWmeYM8t/HEqvr5jKqrwqOJQj
	xlz/BKs0Q+XqJIpEdXpDWmyUz6BTMYs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qp3Tjwk3;
	spf=pass (imf17.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5aa0cf8bca3so9527529e87.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 04:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779795457; x=1780400257; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RepOlA7uegAkHRX0rdEAbivBLVoGLgApQvWSVyuj8bk=;
        b=qp3Tjwk3CS+50aiIINih/Yw2NeeqbwlF+lCJAeML8aF0lXeMQ7WxK9og5C80AfDndH
         n4J0zF07wCImlBYRZSJX5pEe7DSeY8H6EdyScvmCBCsrHuqBvXDN+AKfa0SQdrFhmdd0
         EVJ66A4ove/21VkdKCqOcTgYi1dSXwYMPUh1nJ45xYmLz1osCO8C+cnJfpIgB60x9X3Z
         9za4Yta5qQG0n2IesCiGOxLqz6SbAPEl5npaZHJeeWLL6EdSPRbtSBvG4/VF4gc1J8mC
         g24X1oKzavhee8VVl0lf5YSqKe6clDdq7hmxT28a1EflqHq7KwlXzEWPt6USzdMhqKwh
         p4Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779795457; x=1780400257;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RepOlA7uegAkHRX0rdEAbivBLVoGLgApQvWSVyuj8bk=;
        b=O78sraEsATPTsRDaXqNIQp+2nZisFkpWXh7BcqEotlX6YmwzfWLXFkrcR8yLu15aaI
         8KLliWDcgE+aeGO4IX0zlWXi4fvb9YEd1Yp1heoqlPgEFcFPsL6FIEvq1y798BkIhuJq
         JEHrY88t5t3NfM7NLVBvJ5wGIRv7vgYUZ8jPYgjYnH9m/sCWClPbZMZ49DXUYu1kFGqg
         qodPKicBNCFfeiiuvU/mwKZ6GRRFcZtVkCR6zvoAmdNGmYZNGjMLwq0660wEfFTsETia
         z5mjXC59royqrbfrfKW0hKt0Cvhv6oFh86N8SUEz47iXkvfL80M7HrnBuVd+2L7bFXM3
         CJxw==
X-Forwarded-Encrypted: i=1; AFNElJ+Sn6jYdT/CmNouV5OC0Bo/ww1697sgfSb9GkZ0Qgbrzomhm+Ua6+4suoqH0uV6AEYnqSmhIrKRCQ==@kvack.org
X-Gm-Message-State: AOJu0Yz/TlRnG5PcaxJC2jo8WHrd3Zv9DmFFYIUmvbPVD2SNFGRIObjt
	CMfSgeBKYfRPHYcU9d+rOVJ/TFiL0AwAdlPqOlbWIaPmoPNXfAo+lzo8
X-Gm-Gg: Acq92OG+vdAwngZJLFYrlzIUHARu9ptwL31L6hElvLStB4WEAchnSuQB5myfptWyeFO
	RvvdVETcF8KUfyLeInlJqfcN/BbDuZ8FVSjMEneOkOaX/k70Yb63WU4T5DhoZkHQOy2W9rKZsI3
	Klkq1rcYofbuYccf8wqH1PkNzC4d3zwEDqiziDJF1PNVneFmdP3Cr0nBAD4S++aVnJtbroO+SNg
	5PZ6dg8PesqcdQmnVXyx992dgoUvNu0BDtb06dPU93DALNAhhEZ/PEtJjKaWcaJA0UgtL5V6bb7
	pIXvc1LrOvuIoRXlkyT8KD5dfnLgI2zkGh/PxzXmmYhDfMLQYAP74ZyFNKOr3B2X1XilH6lVhoF
	WSIvln/cvwr3PxDytI64ef27VoYpOnmeQwNP6t4sdOdRuJCyG+JlG3ZPb8+URkAPtm8/TCdmWcp
	AabrnKRDWju1ZLWVos/MZn4MNvQAC/D+L4BBVWxXMduXymL4ubur+UEUZgVN4Bgdu6zSaO
X-Received: by 2002:a05:6512:48cc:b0:5a8:87fc:2b34 with SMTP id 2adb3069b0e04-5aa323c3ee8mr3865629e87.32.1779795457167;
        Tue, 26 May 2026 04:37:37 -0700 (PDT)
Received: from [127.0.1.1] (h-62-63-197-109.NA.cust.bahnhof.se. [62.63.197.109])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa46330d9asm376332e87.59.2026.05.26.04.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 04:37:36 -0700 (PDT)
From: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Date: Tue, 26 May 2026 13:37:02 +0200
Subject: [PATCH RFC 1/3] mm, x86: support copying a folio using
 non-temporal stores
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-rfc-nt-demote-v1-1-eb9c9422daef@zptcorp.com>
References: <20260526-rfc-nt-demote-v1-0-eb9c9422daef@zptcorp.com>
In-Reply-To: <20260526-rfc-nt-demote-v1-0-eb9c9422daef@zptcorp.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
 Frank van der Linden <fvdl@google.com>, Jonathan Cameron <jic23@kernel.org>, 
 Raghavendra K T <rkodsara@amd.com>, 
 "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
 Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
 Yiannis Nikolakopoulos <yiannis@zptcorp.com>, dimitrios@palyvos.net, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-nfs@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, 
 Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>, 
 Alirad Malek <alirad.malek@zptcorp.com>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam11
X-Stat-Signature: i86ix5xzwffmugq68iutazaxubnamufk
X-Rspamd-Queue-Id: 2019A40006
X-Rspam-User: 
X-HE-Tag: 1779795458-851970
X-HE-Meta: U2FsdGVkX18w0PhzkOjGLAxlt1cEVwWIyLwshHbvyQinnqy0yY20Gc45s3YoCVx1lUpLrJR9ojL4xlsXelyeCdTwsePGiEQmpwr24+GlbrPNnqUdcNOA9bDz4QIghRqUUmageh/TOIkSMsVIWgszDByHcDa6AZ0pdq3mVj7djVu1lHJc+U/+UfYZP+hV8HUAd3zVaN0KCqyjLXd0AuhPOTKo5c1fpmH1C6LWHZo6MfQGJrBxPPyGpmOQBKulWBZcmCrxGQQ9nMoW4LYgiN7czVP52eS42W8rKDWqDDnjjokFD3mhfudRdayFa+p18enw+n941WlzjxCoS3vmWljuYyUqBe8mlblCXty+BLaomcDemk1XGmbAmtx3f2Mp0Q5kQ9uY8Gx+rPXMGyS3pL2UUkb0kHsgI+UuvZwRkrRDhRRsQnhxy6jlr0c2pms1snAbDMsfkJSn4Q7juS3f5t1wSsvBEFUse7l2VJa7Nu2I+Db21JnxMphf4KFAS10xIXR+YDslP2zSv4DFkAQGP0R5xIyaMgS71Pq5MQTByJpWFU72nr9XL1fEWw1alpOoClXb13Ll/78osOejz35uAHFA4gr5apK0Aw8ZjCCpgwzgs/GwdoBL+JtcY6dp29EHZ1d2G8Igu0YS3bywmyLT2DrgMBweZpT91tw7cnX5EqfcsicaBhzE4dgkODCbCKc7E2iWKwXmE9ZP0VOwrRhGHgA5PriakjitYsKJWLx5BIVrg0yh35ollRTHHpGYCBJv12g2AYKcpLVIrd8s3hxBZtBTu/TWNWP31llFw7EQQdWV2TaKqArsunvtOS228buvhz3sEMxX2UoC/d3SOzjd/3D7vl6V0dAWv3Z5lnmvrfJOlrHfVyyxEkOFmzZY1w/vdwr1hV9cJZyrXROdUBH1sQSy0XKiEmStj2zZyqQOXL8ONDDM8T0a6aCKV3wsItkjeX8Z1G6CcfWK9gx6VmCfplZ
 e6v1uoRn
 r0ydsYFgCeYC96txJubazUeqcQrN2WiCmD2GpYl/gANWTefWPBeuUazBLch1AwM6ka0bOj9bzyfbNRejo6ZHFZHUTaq1jqOIjLQZh2KA78o2vLTg7vpPfjjFVds5dd3wckcKabgcAv95cuUCZoXjiljLavm69IqqBcFE9MKdEDfUPuUkIBp39oY+VF+JfSDgCEob4Ux0H9eGabSBrv7U8IhLUxksCJobhpLSXJuJPftASzjgCeoZeCciamT8J+X7nPVTLmD//UXCstFafD2w3SjdXWld7+hRaNBHNLj0Pq8JKvQpPnfhQFY8mqKvcvEsB0wdNdFcoOn0CXXrsE9MejWs8LBxS5N1HPuJDhF6SxDg0keu/GggiDW1UsKH4tPRZM3e9WWjfqYB5CAmzkldR/Rtut+3D8lxIaykPeGuk6TOIT/seT2tlkwHfT1y1nlpWlH4wsUYcBHKfrH758lByRdWyjuFWQTEggjFg6YNEXzsMmrljlWxB5Zfwpr22jloOE682Sev4Vcib5COWXD8fnEyQynfm/YeT8AK4iMiVrVUT1Oo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alirad Malek <alirad.malek@zptcorp.com>

In x86, use memcpy_flushcache (that uses non-temporal store
instructions) to copy a folio. To achieve that, starting from folio_mc_copy
down to copy_mc_to_kernel, create a series of helpers (named with an _nt
suffix) that have similar behavior to the original counterparts.

Signed-off-by: Alirad Malek <alirad.malek@zptcorp.com>
Co-developed-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Signed-off-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
---
 arch/x86/include/asm/uaccess.h |  4 ++++
 arch/x86/lib/copy_mc.c         | 26 ++++++++++++++++++++++++++
 include/linux/highmem.h        | 32 ++++++++++++++++++++++++++++++++
 include/linux/mm.h             |  1 +
 mm/util.c                      | 17 +++++++++++++++++
 5 files changed, 80 insertions(+)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 367297b188c3..2d0938d3e372 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -494,6 +494,10 @@ unsigned long __must_check
 copy_mc_to_kernel(void *to, const void *from, unsigned len);
 #define copy_mc_to_kernel copy_mc_to_kernel
 
+unsigned long __must_check
+copy_mc_to_kernel_nt(void *to, const void *from, unsigned len);
+#define copy_mc_to_kernel_nt copy_mc_to_kernel_nt
+
 unsigned long __must_check
 copy_mc_to_user(void __user *to, const void *from, unsigned len);
 #endif
diff --git a/arch/x86/lib/copy_mc.c b/arch/x86/lib/copy_mc.c
index 97e88e58567b..5a2ee5c2211e 100644
--- a/arch/x86/lib/copy_mc.c
+++ b/arch/x86/lib/copy_mc.c
@@ -81,6 +81,32 @@ unsigned long __must_check copy_mc_to_kernel(void *dst, const void *src, unsigne
 }
 EXPORT_SYMBOL_GPL(copy_mc_to_kernel);
 
+/**
+ * copy_mc_to_kernel_nt - memory copy that handles source exceptions
+ * if enabled, otherwise uses non-temporal stores
+ * @dst: destination address
+ * @src: source address
+ * @len: number of bytes to copy
+ *
+ * Return 0 for success, or number of bytes not copied if there was an
+ * exception.
+ */
+unsigned long __must_check copy_mc_to_kernel_nt(void *dst, const void *src, unsigned len)
+{
+	unsigned long ret;
+
+	if (copy_mc_fragile_enabled) {
+		instrument_memcpy_before(dst, src, len);
+		ret = copy_mc_fragile(dst, src, len);
+		instrument_memcpy_after(dst, src, len, ret);
+		return ret;
+	}
+
+	memcpy_flushcache(dst, src, len);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(copy_mc_to_kernel_nt);
+
 unsigned long __must_check copy_mc_to_user(void __user *dst, const void *src, unsigned len)
 {
 	unsigned long ret;
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index af03db851a1d..a5cb435b9ffe 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -468,6 +468,32 @@ static inline int copy_mc_highpage(struct page *to, struct page *from)
 
 	return ret;
 }
+
+#ifdef copy_mc_to_kernel_nt
+static inline int copy_mc_highpage_nt(struct page *to, struct page *from)
+{
+	unsigned long ret;
+	char *vfrom, *vto;
+
+	vfrom = kmap_local_page(from);
+	vto = kmap_local_page(to);
+	ret = copy_mc_to_kernel_nt(vto, vfrom, PAGE_SIZE);
+	if (!ret)
+		kmsan_copy_page_meta(to, from);
+	kunmap_local(vto);
+	kunmap_local(vfrom);
+
+	if (ret)
+		memory_failure_queue(page_to_pfn(from), 0);
+
+	return ret;
+}
+#else
+static inline int copy_mc_highpage_nt(struct page *to, struct page *from)
+{
+	return copy_mc_highpage(to, from);
+}
+#endif
 #else
 static inline int copy_mc_user_highpage(struct page *to, struct page *from,
 					unsigned long vaddr, struct vm_area_struct *vma)
@@ -481,6 +507,12 @@ static inline int copy_mc_highpage(struct page *to, struct page *from)
 	copy_highpage(to, from);
 	return 0;
 }
+
+static inline int copy_mc_highpage_nt(struct page *to, struct page *from)
+{
+	copy_highpage(to, from);
+	return 0;
+}
 #endif
 
 static inline void memcpy_page(struct page *dst_page, size_t dst_off,
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..d07ce478582d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1644,6 +1644,7 @@ void __folio_put(struct folio *folio);
 void split_page(struct page *page, unsigned int order);
 void folio_copy(struct folio *dst, struct folio *src);
 int folio_mc_copy(struct folio *dst, struct folio *src);
+int folio_mc_copy_nt(struct folio *dst, struct folio *src);
 
 unsigned long nr_free_buffer_pages(void);
 
diff --git a/mm/util.c b/mm/util.c
index b05ab6f97e11..e09e9b5f8eee 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -749,6 +749,23 @@ int folio_mc_copy(struct folio *dst, struct folio *src)
 }
 EXPORT_SYMBOL(folio_mc_copy);
 
+int folio_mc_copy_nt(struct folio *dst, struct folio *src)
+{
+	long nr = folio_nr_pages(src);
+	long i = 0;
+
+	for (;;) {
+		if (copy_mc_highpage_nt(folio_page(dst, i), folio_page(src, i)))
+			return -EHWPOISON;
+		if (++i == nr)
+			break;
+		cond_resched();
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(folio_mc_copy_nt);
+
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
 static int sysctl_overcommit_ratio __read_mostly = 50;
 static unsigned long sysctl_overcommit_kbytes __read_mostly;

-- 
2.43.0


