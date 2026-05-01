Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2EB8CD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B90B6B0092; Fri,  1 May 2026 15:20:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486676B0096; Fri,  1 May 2026 15:20:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D7096B0093; Fri,  1 May 2026 15:20:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1836E6B008C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:20:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D9BDE1A0227
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:13 +0000 (UTC)
X-FDA: 84719816706.29.892497D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0094440006
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U0rYMVZR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777663212; a=rsa-sha256;
	cv=none;
	b=PvF8gP1nPPDHzC4+kF7aqc5+MjhlADdMDqnoNeNLSOaMIn8L416oUFlo2yTb/uNJNNbXhN
	9/IoenhSy5s7qLJ0Kx4RbLYfl2QcsQPLgxaB9LyWEoRGqhOU3E8ipexf6udAjXCBfDSehF
	q21BIpUi8VaWNPW+M44lN8TZ/mho+e4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U0rYMVZR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777663212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wm/3tKpS1+bbbkiWPW54qthE5IZvUCs3az7WMfHFyEE=;
	b=FTQUc3eOorKy+1+vbi/FNzJT1Dd9+VzmHImBwrdsDgumkgOagDwCHZbMq22Dqdq8OyrjDy
	u/SsgrSE4nNwpGQnXbxO+Y4snN6tDzrbjchVZSOLoqD46IEqMF3hCapM+hLKPpjDWUp4tg
	uvhf1iRP7dEglytDCFrnkDb0tHUzleI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777663211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wm/3tKpS1+bbbkiWPW54qthE5IZvUCs3az7WMfHFyEE=;
	b=U0rYMVZRbnMp4siOV19W8vwH3kwTBVSiX1HCBpbeJ8UZi51zt1I9hoqTfjU0VzlOjF/Bsl
	l49IpTB13CU91p/tELcosWCZM5rIsxTREU12BEu4vPEx/rzPj8J6E3STW6Ib0Ky9sQ+1GD
	z+1kzQ+JnSF+1fpXogismz5hdTZ0/TA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-EPxmSzN4OfyvKHGpT8koQQ-1; Fri,
 01 May 2026 15:20:06 -0400
X-MC-Unique: EPxmSzN4OfyvKHGpT8koQQ-1
X-Mimecast-MFC-AGG-ID: EPxmSzN4OfyvKHGpT8koQQ_1777663204
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B63AD19560B5;
	Fri,  1 May 2026 19:20:03 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4CD791800577;
	Fri,  1 May 2026 19:20:00 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v4 2/9] mm: introduce pgtable_has_pmd_leaves()
Date: Fri,  1 May 2026 15:18:44 -0400
Message-ID: <2a0bae00cdd2b6ef6b962610b523ebfc97806ba7.1777663129.git.luizcap@redhat.com>
In-Reply-To: <cover.1777663129.git.luizcap@redhat.com>
References: <cover.1777663129.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: JiodZwbLGMJ88JAGixeRYCLcqWI7JvyLc5jFHfk_diI_1777663204
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: a5eg4nryhc8tfqyakpj9gfjictksfhb8
X-Rspam-User: 
X-Rspamd-Queue-Id: 0094440006
X-Rspamd-Server: rspam07
X-HE-Tag: 1777663211-798700
X-HE-Meta: U2FsdGVkX1+72Shsy+z6HlCD570WzuxfabnTFGGDq5wtjLmug8aTjszQnUmbBAUBPAhrGaHv2e2tDmtm1TFzqrqhXfk1Nv8OBnQsMsCJKMFVCQHiH1z1fR6SkDG+yFxM6wyzQGTdi46lbLU6UZW9iGFgG1jRMa84A9gZS6HkUCk1yLsHk0Ms0iEVhYC0dnqglnmCRomp1F4vnPZ6lxo2HrIcwnIZSYFNqeA4EI+T1IKw6t3j1v5IbJTYG3iXMAjGVeCWdYmVWKoV01VWYL680dIHmXzGD3YXOyBSnzk50pJxr+x1fxTXC5TLnA8AcuGphkSpOsr5uLges9tTq2XKXJhc3zdRdh5Wsu/68+63tUHqhCoatLhvN0DpdH7cxY81/8Ik6Y+E/OhY2ZnV6x7Qsw86YMo8/l86YWud57zz6MTdc54hsxAvwEjfzojRZ788TvplHo8tMScTfi7jQqWBytDvAzYL2q5Wuu/aYWPUcY1tROu7QiJONypcqdIhvpyisL2iFvXFHB7Bde+cc46JztoJHN3XHY9ZpzqQ+owT04RJ3RILRVy2RfYgjegTDsNI8cjJUw5f96P56zlJB1z94pMupO9yhOJOcMJytWZm/r4Y5mILzwXWGDM4lj04RB53VjoDRpBBMCcdWbcPT0fF67ZY1XB2/uUA5NYLsA1DwTALKnRY17Yw5Dg5mMYsh+NX7QwYXMWHrEmRiTaPmDHAGT4BlCkqB6wgtmUcR/MglQhd+rVWo9+x4+R+Ud6sM6DwQJ6pZCWmo5M50nOkIZnbk1lZhtjHTPeDweYJwEFNVHYcyohIb0jXmnFSPoiiBRTE7izRPgljDQrCDeax72YUELHbOv/LevAcwZE/l8IHiV2pSu5sqRGDljBZfMcEIrGsy8xBFdthuKurYZQxcJob04RyuOmn6FgPA/St9IIcPWKTFtiDY04wwOfZxdevLs58B7etzsryYTaDqssgpsi
 0WdBwQvG
 KN/QexHK0nAGQ6xlASZET4SCAZ7bXeJnK6u93olos1/3bqtFiBVCmH4fiMwLd3IJKieCjP/esZXQI25HU/o6tncAIaFvv1nuQsg/EZNHjXmS4W+HRhWbqN7evK8Lk7SwaJoaT0j55rSMZ6dcncIhXTenYTvUn0fVFGONGDO5SMiTxK8loy1mBQE3US4rQ9WGoeRY7khlnVc8vn4YS6LGyAEQr7AoW3qHK6Coq3mPo/QvfV8S1wBDoOdQ0mRMKifJI4UrUQRYRP9SYX0xxdDKij/GcbUQU8ZTqeyrmLiCQQQ4IKd60QSvlaDc2nhQ4NYPzawTbuMnwRb0wHkrBK00jCDePJNynwDWSCzgsxcIHrRzDepfhx7GjAjv3PBocqC9hkFq+utD/y3Z5mwU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, we have two helpers that check for PMD-sized pages but have
different names and slightly different semantics:

- has_transparent_hugepage(): the name suggests it checks if THP is
  enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
  implements this helper, it actually checks if the CPU supports
  PMD-sized pages

- thp_disabled_by_hw(): the name suggests it checks if THP is disabled
  by the hardware, but it just returns a cached value acquired with
  has_transparent_hugepage(). This helper is used in fast paths

This commit introduces a new helper called pgtable_has_pmd_leaves()
which is intended to replace both has_transparent_hugepage() and
thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
it returns true if the CPU supports PMD-sized pages and false otherwise.
It always returns a cached value, so it can be used in fast paths.

The new helper requires an initialization step which is performed by
init_arch_has_pmd_leaves(). We call init_arch_has_pmd_leaves() early
during boot in start_kernel() right after parse_early_param() but before
parse_args(). This allows early_param() handlers to change CPU flags if
needed (eg. parse_memopt() in x86-32) while also allowing users to use
the API from __setup() handlers.

The next commits will convert users of both has_transparent_hugepage()
and thp_disabled_by_hw() to pgtable_has_pmd_leaves().

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 include/linux/pgtable.h | 15 +++++++++++++++
 init/main.c             |  1 +
 mm/memory.c             |  9 +++++++++
 3 files changed, 25 insertions(+)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a..b365be3516bf 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2243,6 +2243,21 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
 	}
 }
 
+#ifdef CONFIG_MMU
+DECLARE_STATIC_KEY_TRUE(__arch_has_pmd_leaves_key);
+static inline bool pgtable_has_pmd_leaves(void)
+{
+	return static_branch_likely(&__arch_has_pmd_leaves_key);
+}
+void __init init_arch_has_pmd_leaves(void);
+#else
+static inline bool pgtable_has_pmd_leaves(void)
+{
+	return false;
+}
+static inline void __init init_arch_has_pmd_leaves(void) { }
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
diff --git a/init/main.c b/init/main.c
index 96f93bb06c49..eea7c5bdddf7 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1053,6 +1053,7 @@ void start_kernel(void)
 	print_kernel_cmdline(saved_command_line);
 	/* parameters may set static keys */
 	parse_early_param();
+	init_arch_has_pmd_leaves();
 	after_dashes = parse_args("Booting kernel",
 				  static_command_line, __start___param,
 				  __stop___param - __start___param,
diff --git a/mm/memory.c b/mm/memory.c
index ea6568571131..90b2d9e84320 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -164,6 +164,15 @@ __setup("norandmaps", disable_randmaps);
 
 unsigned long highest_memmap_pfn __read_mostly;
 
+DEFINE_STATIC_KEY_TRUE(__arch_has_pmd_leaves_key);
+EXPORT_SYMBOL(__arch_has_pmd_leaves_key);
+
+void __init init_arch_has_pmd_leaves(void)
+{
+	if (!has_transparent_hugepage())
+		static_branch_disable(&__arch_has_pmd_leaves_key);
+}
+
 void mm_trace_rss_stat(struct mm_struct *mm, int member)
 {
 	trace_rss_stat(mm, member);
-- 
2.53.0


