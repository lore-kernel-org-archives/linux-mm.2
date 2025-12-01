Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD6CD116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922B66B00A0; Mon,  1 Dec 2025 12:48:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC916B00A2; Mon,  1 Dec 2025 12:48:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FC9C6B00A0; Mon,  1 Dec 2025 12:48:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 50FF56B00A0
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:48:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1582E140364
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:48:48 +0000 (UTC)
X-FDA: 84171637536.18.2FF7F85
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4EE534000D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:48:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OlgLvOiT;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aApNpV/y96GsuiGhXxscelXEjRrHIOopNsyX6f8svSs=;
	b=tk0QjxS4yIk6LmHeQ8NyEWb4nS1an+fBSyWgAZDbIFX1ChYrtHUGG3jrAxOMd6A+wfzkEa
	rUE94EZNuV8h50cuuWf4n/5AzK727ZseLgcO5xUaUEgORe/JKE5E8VfI7Mgdb1tna/iDAr
	U+DPnW2yNpRfUcVgplUKPqyE9yceu5k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611326; a=rsa-sha256;
	cv=none;
	b=CK+DECj0X/KgECrqjWwT88/jPBMithDA2tkPl/Op6AH4zWcsmgQKRKT8bTyAjT51dmQTZp
	/PxcBdxhGkcqygqAHUtW3Mu4Ms8syQ6rdasoM0MFvwbIXELypV7PWmvmSL2UVku5Llpyom
	vpyaem54/orqi4FWrmYTvaAche7P350=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OlgLvOiT;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764611325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aApNpV/y96GsuiGhXxscelXEjRrHIOopNsyX6f8svSs=;
	b=OlgLvOiT+eNZUqHTHgrYF+kc+2Z4WZ+OdFDqM4pvGKickImwjJTqKVIzAFaJKHACxgCSYI
	J1p0rahp5A8fzgsKd09Bnd1HXUuJzcCFLXoJYRgMihzZQpXuKC66YTpAjkS+6H+05iQ1Wm
	12igEDpibP9aFAk2sTF2f8fkgUxB9OA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-Bpno6CU_M2GZO9HDt3xq0Q-1; Mon,
 01 Dec 2025 12:48:40 -0500
X-MC-Unique: Bpno6CU_M2GZO9HDt3xq0Q-1
X-Mimecast-MFC-AGG-ID: Bpno6CU_M2GZO9HDt3xq0Q_1764611315
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71C23180057A;
	Mon,  1 Dec 2025 17:48:35 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.66.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6E9A8180087B;
	Mon,  1 Dec 2025 17:48:25 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Cc: david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kas@kernel.org,
	aarcange@redhat.com,
	raquini@redhat.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com,
	tiwai@suse.de,
	will@kernel.org,
	dave.hansen@linux.intel.com,
	jack@suse.cz,
	cl@gentwo.org,
	jglisse@google.com,
	surenb@google.com,
	zokeefe@google.com,
	hannes@cmpxchg.org,
	rientjes@google.com,
	mhocko@suse.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Subject: [PATCH v13 mm-new 07/16] khugepaged: introduce collapse_max_ptes_none helper function
Date: Mon,  1 Dec 2025 10:46:18 -0700
Message-ID: <20251201174627.23295-8-npache@redhat.com>
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 4EE534000D
X-Stat-Signature: kyojag8stgxzc1nfg8qniz8kcyfdi8q5
X-HE-Tag: 1764611326-143782
X-HE-Meta: U2FsdGVkX1/vuf6aAFecpuSDN7iJQTeGtdaVrzRSkmtHPeQtl04zLM6/HlpPe/zSo1vNjc5cR2S9xXsqhbj1+Wd0CgV1zjFg5uAQck4XbIcP32mLA0VX0fiXv7B0mALizuS/dBQOzCQ094tYaLQJWllpW51Xzkqod6YNm7/u1NGhH5AyiRKydwLyGJG1nAZQyIwYpf6PONVRNu2F1bZbhXDAqgjJod+qjdctATVx/ExA6njvzgfiIp98ef4DiRrQnBp5samYTuRj9KzqQpzbfE1Jt6l4fbOphq7QGuttEK+jChDK3QqMOmEoUgSzFeHPvzAQgJwtW0VpVaGKYVl9pxMJf8PRzZQKK7Jf1Kq7Y+68beVZNGRkC71LpuojkCFKwKJAAsaJZ3XAScCXUqxsV/HcuHpmbKAqQnLf+X5s3Cx7UV1en+jVrPw+8LW/xKo7+0gkDdALkw9EGdbzcCfbCNZ3GAWmUFcJ5HxQ+KN/76aEXI6TAAGls46dpUUsew2m+2cU8bxnX4uv/z9+GCzIkv7n0o2vHtyAUY97vE67KEe3VBoViTBcl/c68Hr8ncbrrzoHPS8tjidCRIaolJSVXhFthqGwaRFupykZGY33NQQyVEAf8KOYknaQOOoTqdUQYCZ9LkLZF2XGd6sYCCMg0Onakplw4fN0RG8tY3n/ltMrpfHs0j1XJgGewbfFmDTtUwQBv3Plmb8QwBd+CXD9vIlJr1kcgeSCXZI1ft9FK83PWIH6u/Yj+nCqd5mP2R0yfEI+9E69IUpHSt0xoQObns34uhMlbmf28za866T4Sd1mX4LXfogZ5IBv+yaL/ybPAyFF0czCu6GM5fujqmR1yvWoujL56EU/RZfqet1y1fMazUXngleTXvV84qE77Vx9NOpCkpcR3BAEYs9+pwvQecwaBisobjNPzMmCDLZlKZtme4pQAddfh6qexFAu42frER2cy0xPh3Bvx4YeAxM
 2OoWbn2/
 jMRjLIuZ8SWaDxSYKu+fDBvIB2CmVRZ1itlwzP0owreAo/cgWUJjqHOFkdNlZL2iXgcZYeZnrP3OY9qrBivVDfB8RWvegjk7SVoIlPVKmKiRUdRWfufp0GpwYV0FVjXaUBOxf/2zI0tgVm9H2Ug1RrKDcfRp66/KAD9yAsaLeFs9ctmyZSJatZLbh37hi8vMRWDMHBG2BLv1SUhdB+x9gv348HHu9U00eZRddDrm0dcUqctnMRmQ9Q/pmXML55s7lxqRtFBR+/KTMSLEQVjx2uQlBeY+eflweoqrbzKMaRAN/e0ERh3vezb5+NSMGiHo74zegO87JNY/6ejosg4XuYtOdRaDoTc4qpbzMEz8rvkdIKYTQn2YOdpfQyPzQqD+2O9g0lqr+k6m45+Ur1x7tgW+l42wx8gpo8lQa0PjQYj1ZKnK7yVPGkXO9JnKhK9hldw/31hdluynoicM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current mechanism for determining mTHP collapse scales the
khugepaged_max_ptes_none value based on the target order. This
introduces an undesirable feedback loop, or "creep", when max_ptes_none
is set to a value greater than HPAGE_PMD_NR / 2.

With this configuration, a successful collapse to order N will populate
enough pages to satisfy the collapse condition on order N+1 on the next
scan. This leads to unnecessary work and memory churn.

To fix this issue introduce a helper function that will limit mTHP
collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
This effectively supports two modes:

- max_ptes_none=0: never introduce new none-pages for mTHP collapse.
- max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
  available mTHP order.

This removes the possiblilty of "creep", while not modifying any uAPI
expectations. A warning will be emitted if any non-supported
max_ptes_none value is configured with mTHP enabled.

The limits can be ignored by passing full_scan=true, this is useful for
madvise_collapse (which ignores limits), or in the case of
collapse_scan_pmd(), allows the full PMD to be scanned when mTHP
collapse is available.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8dab49c53128..f425238d5d4f 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -463,6 +463,44 @@ void __khugepaged_enter(struct mm_struct *mm)
 		wake_up_interruptible(&khugepaged_wait);
 }
 
+/**
+ * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
+ * @order: The folio order being collapsed to
+ * @full_scan: Whether this is a full scan (ignore limits)
+ *
+ * For madvise-triggered collapses (full_scan=true), all limits are bypassed
+ * and allow up to HPAGE_PMD_NR - 1 empty PTEs.
+ *
+ * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
+ * khugepaged_max_ptes_none value.
+ *
+ * For mTHP collapses, we currently only support khugepaged_max_pte_none values
+ * of 0 or (HPAGE_PMD_NR - 1). Any other value will emit a warning and no mTHP
+ * collapse will be attempted
+ *
+ * Return: Maximum number of empty PTEs allowed for the collapse operation
+ */
+static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
+{
+	/* ignore max_ptes_none limits */
+	if (full_scan)
+		return HPAGE_PMD_NR - 1;
+
+	if (!is_mthp_order(order))
+		return khugepaged_max_ptes_none;
+
+	/* Zero/non-present collapse disabled. */
+	if (!khugepaged_max_ptes_none)
+		return 0;
+
+	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
+		return (1 << order) - 1;
+
+	pr_warn_once("mTHP collapse only supports max_ptes_none values of 0 or %d\n",
+		      HPAGE_PMD_NR - 1);
+	return -EINVAL;
+}
+
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
@@ -550,7 +588,10 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
 	const unsigned long nr_pages = 1UL << order;
-	int max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
+	int max_ptes_none = collapse_max_ptes_none(order, !cc->is_khugepaged);
+
+	if (max_ptes_none == -EINVAL)
+		goto out;
 
 	for (_pte = pte; _pte < pte + nr_pages;
 	     _pte++, addr += PAGE_SIZE) {
-- 
2.51.1


