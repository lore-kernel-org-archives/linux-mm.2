Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1CD6CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AF568E000C; Thu, 11 Sep 2025 23:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4874A8E0001; Thu, 11 Sep 2025 23:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39CDD8E000C; Thu, 11 Sep 2025 23:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1FE638E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:31:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE10FC068A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:31:17 +0000 (UTC)
X-FDA: 83879172594.10.81D7877
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1A11D180005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:31:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FeIvTeYw;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757647876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wETBaE+dYsc2nQqnQRxwAppd6Mkv5OwMkb/6jMq01AA=;
	b=imJ2iZVFThciAL2iJcBbzcXu9SIc8nCrCI4V0qMlitKUhtvDhe0m+9i1bLrjTVf4WX6/WU
	E7LDuk8g8mlkL6l7OyeNUt3tkq6Jnsr4cnxz5iKX+dWoZUh6e1xyGRgDfltTwTM2thMNxf
	eODXXk3QhF+1AmsglDNGVET0h2zmVmY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FeIvTeYw;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757647876; a=rsa-sha256;
	cv=none;
	b=726e8uyxCDy2//IOCVsBNmn40fnt44wfB6s4jfkoQBjG9EgrCAfs5kcaKn9Z5u5eVJHTnw
	4JT5OjFw9qlb/v94N5ngZLdpdUQE3AYu6sOW+2jTJ1NRbbE/nH0WEpBGZQLXq7qjw+tXzQ
	WAynl6PE9OJAEciFfJdGTiMn5RcJw70=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757647875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wETBaE+dYsc2nQqnQRxwAppd6Mkv5OwMkb/6jMq01AA=;
	b=FeIvTeYwqBizBtzX90OFvpjuNQc0hHQuoYRY50LfWw2zcenHAXeXkhNQuyLRBtk0UBYlFh
	AkD1MMJ3ZbW0zmACG9FotaFBCEpPN+hHjGgMqSGu7UgfktJB1E0vv1lJr7neFhNBOWclgX
	4yBdAdr+IWJd0KLI3XuwsNcP0NrFNSA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-263-A36zdP3KMpCQ6dV6BkoLuQ-1; Thu,
 11 Sep 2025 23:31:13 -0400
X-MC-Unique: A36zdP3KMpCQ6dV6BkoLuQ-1
X-Mimecast-MFC-AGG-ID: A36zdP3KMpCQ6dV6BkoLuQ_1757647869
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 821101944F11;
	Fri, 12 Sep 2025 03:31:08 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 79C801800451;
	Fri, 12 Sep 2025 03:30:59 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
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
Subject: [PATCH v11 11/15] khugepaged: introduce collapse_allowable_orders helper function
Date: Thu, 11 Sep 2025 21:28:06 -0600
Message-ID: <20250912032810.197475-12-npache@redhat.com>
In-Reply-To: <20250912032810.197475-1-npache@redhat.com>
References: <20250912032810.197475-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: 7u3rwut7e1s7jzxj3hb46izu3rkfbkjb
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A11D180005
X-Rspamd-Server: rspam04
X-HE-Tag: 1757647875-331595
X-HE-Meta: U2FsdGVkX1/iIBqKgQi4ysU79Yj7hnw3QF6T5KXzv5aVl7xdRtMgb9iltE345j3jW3YmjndsCnzxH6rmnxNu51b683ZQEghlUfmdsbI29Fpxg8+FyIl+sKA1vFUPUwn1IBOz/+/94HE0HbkVkbLfydCsgT3yqTh4ko9SCxfCgEQh5xEa4Ct0Fc+kjuBfALYG230nIP41Fcid0bOzCzU/kko08Qrsa/0GrXB+MuenkQQmWVml0vByHJYND4NUFpib+evZI4eGr5S984F/I8NmRxr2Qw166M40ssQYUeNKjH2fFv9M0Mh8+Ip3wLBmGLIskc3za3WYCsgB3FZuCnjJqcRUCSkJd+vLnKHKk24iG24kdymZKqTtjjwE8bId1eDnssz8oSZA0bGFqXcil/w3zoj/RoLZvJNgowQZkuWxVoMlTbKf7Yj9bebznPaIqarPi+fD1hIlOIl6I9JRDtk7vwicnv1PE6Odu6ZsGbTutG9b2pUqtRBfebuJTzB9hs0/VOVRMQBwbvtkZKfcSMAOtTlXu9UA7hPsjS+B9zIKj+6gZVbrvFEYxkpcUx6+gMwg4yURrCOWJYiH7PccGm+i3VAYSxBzg0HXaueo7IWTW4h0lc0ieQMEr5YLSsrSF5u7meGs2HuPX+HN2BWrKevAAl4QYhddr/xVDlwOluiut981/lF24vJKxbKyV8hRl5TJEpKEZ3xuKcSYOkD7UM8CPqhXf9B4SS0QJlD2FsvRdHmZIASwIbUJMIWN/D1WauShu7wFdNKy+cDe2HOcINjaAaBDb1G4iUnIErR1NxQUldRP6Z1NYNHI93YSn+lM2Ctql6R4v2lgOCR3yMBOLeeaex88N3PW8YamwDr5OYnaf/ajShE5J+3ZaTHwhAT+HAccRlHgC3XdY0IGfSolunYVS7fQlxV///WH/fFG2C769F9m/+DilSghfRt98u7QYM1Qt7Uc+IlncYBCWeiz9nm
 jTo3Fsba
 NjVCyLi/eE2HYz/ySezDmA9FrY6n2b2xDCN5fccBW5zUUcwUmsryLstyb1JuzLel/c/VLLSkE+fPM8JK/C1b8PD2fSJUCdvxTVS/IvEr/yZu+8tZRVtu6q9gTziVj7PV0Cqb9LQ3+JDNmMbpVJ1KpG2Em+kXJ9Vxtwkgi1UgX+/E4hs0RBqaaA+dxSzr+USMF4Z54R4yexlxKeCd86jDP+y8GMnIZxL1DPpKCjjUwlIOUi+Escq9m72GGpdlTT/G6WLvUSydtVRIS8V4HK0bjmkMaZF1msfPQOeRYfZlEKnlmSoHscu+dBfa+SKhZ+wWfd+OVxlOWdaG/bJzhW1DBUBNOhE4XF5jg+PpoxG4uIp2JWxL/JGncO3+mlbuYI50F4LPPzWxvY5/d+Nur43gwe0l+WkdC90fiz4KxrP2CZRRpMhQOWfCat8j/9oFsJdYQ7N9iclTiPB29u9A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add collapse_allowable_orders() to generalize THP order eligibility. The
function determines which THP orders are permitted based on collapse
context (khugepaged vs madv_collapse).

This consolidates collapse configuration logic and provides a clean
interface for future mTHP collapse support where the orders may be
different.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5b45ef575446..d224fa97281a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -485,7 +485,16 @@ static int collapse_max_ptes_none(unsigned int order)
 	else
 		max_ptes_none = khugepaged_max_ptes_none;
 	return max_ptes_none >> (HPAGE_PMD_ORDER - order);
+}
+
+/* Check what orders are allowed based on the vma and collapse type */
+static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
+			vm_flags_t vm_flags, bool is_khugepaged)
+{
+	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
+	unsigned long orders = BIT(HPAGE_PMD_ORDER);
 
+	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
 
 void khugepaged_enter_vma(struct vm_area_struct *vma,
@@ -493,7 +502,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
 	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
+		if (collapse_allowable_orders(vma, vm_flags, true))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -2557,7 +2566,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!collapse_allowable_orders(vma, vma->vm_flags, true)) {
 skip:
 			progress++;
 			continue;
@@ -2865,7 +2874,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!collapse_allowable_orders(vma, vma->vm_flags, false))
 		return -EINVAL;
 
 	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
-- 
2.51.0


