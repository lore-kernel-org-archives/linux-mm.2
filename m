Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 781E8D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE8F6B00A7; Mon,  1 Dec 2025 12:49:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7E246B00A9; Mon,  1 Dec 2025 12:49:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1EA16B00AA; Mon,  1 Dec 2025 12:49:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4436B00A7
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:49:38 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 69915131DD6
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:49:38 +0000 (UTC)
X-FDA: 84171639636.24.B701CC5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id D11D2160016
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:49:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N09tO8aa;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fOXmay0DzBzAuvqKdvZMupHsdWnxLImqSuisvTNIgdQ=;
	b=qXaBxTz06GCie0xpnYErlg6PWdYTt4Oh2zidAfmnmCDXqxw3nR8kK5YVxCrEP70Kv6XXnU
	3smaSK40Ie7BeSR5ZdioReXxjr5liUwLdtK5NFtsWwfEqVd+cDn1jXYhC5d3iz3Pd0YOR/
	7jqJmxNDWT3abwY+WMN8VBrVQOV+Ugw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N09tO8aa;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611376; a=rsa-sha256;
	cv=none;
	b=1Z7VxfFhfCO0BGLMKVwqJW29lo0fVESvGR8gZX7M/wOlngRwKWqapkX4rEG6zstePn/w5I
	aiFBA31XCIVtC1Vys5GCeP/Et5LzExSqXJHAt1wo2LGEC+zKrG32uCumEaftd7Fssyx/u6
	SwhwgbTtryvJLleRwMGQdzPGTpXObrQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764611376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fOXmay0DzBzAuvqKdvZMupHsdWnxLImqSuisvTNIgdQ=;
	b=N09tO8aaMjBwBLG7CGqw758zWrefAWc0fRF4ZPf+uhdwxscIoUrtj1Vz7AIcGBgYei4WDm
	hd+JicFu8smnUe3DLsaRAR8/Lnn/Wp61Q+ctvbdZzjCkpRUUJ04BGYmcA1J0HLOwdqfq3E
	9UwriMiE6zfgT0ZR1wvM+DzJuuywUTE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-520-NPm4btkEMLKkAmuNi3P2SQ-1; Mon,
 01 Dec 2025 12:49:31 -0500
X-MC-Unique: NPm4btkEMLKkAmuNi3P2SQ-1
X-Mimecast-MFC-AGG-ID: NPm4btkEMLKkAmuNi3P2SQ_1764611365
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E83611955D8A;
	Mon,  1 Dec 2025 17:49:24 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.66.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C16F51800451;
	Mon,  1 Dec 2025 17:49:14 +0000 (UTC)
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
Subject: [PATCH v13 mm-new 12/16] khugepaged: introduce collapse_allowable_orders helper function
Date: Mon,  1 Dec 2025 10:46:23 -0700
Message-ID: <20251201174627.23295-13-npache@redhat.com>
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: qw7pdgpamjpmpxcwaeqocz9gdc6csqjn
X-Rspam-User: 
X-Rspamd-Queue-Id: D11D2160016
X-Rspamd-Server: rspam09
X-HE-Tag: 1764611376-749961
X-HE-Meta: U2FsdGVkX18/2eEZod1B+cOmA993diZBM075qH+/brZcjywHTMycUcPVrj5dpVL5IrBbPcswL7rBCVF/82oPEWFDwsj5mafoFMi8u4DfwOSzQ9g9Xi5hLOIWC7jzklPW6/eyAdm8N71P/Vqr5/Nn9Li7wwkDI/NXZwrCr9cgwkOPtBk5oOhlk/KXuOJmWo834DEhyaEkMh8Ns9ab3BVCJo646cyXdt9mCmJvgu0p76aJGYsZa+55psIZ5TXGrPkb0vjiaY0Z2/gjZdzsODyYQWvv/b374YV1TPDbiTQEIFmkgA1GDnGwoKDn+lTH3k5mJ7UY+eDvuUn4hqGGqCUvL8W9J9cTraemilI9B9oBMc64i7VhgtNKVdtZFzmm+967HYbcB2K6DUtVt2TjbwFgrqnHACEihM6appI9n62DNLjjLCehMHuplhaA6zS/jmWfHuj+aSdlzg5DrTM7t5YRSOdEIOfQynrXT/jN+/HcFWeuwlveTSocf9w1uETd4dHbJucMzt17etBt/VQ9ka3xzWI7patPCvyMXtx6qf4jRjE9a3DeDLTplRbu4u6PTWjfVYn2xtNmLyBPgEFVO3jupw4zIGahpd/1vvyiyyIktqsa/gMNFWA+jYn7rVEU00UTavt/dtRR9yVjCN3z3uwk6tH8uBlC2H13jsFSVN34cJreWAEa82R48vOO4SkJWq+b1WtqUaM1pWFXKc94qlRgmUOh9WbEXgpALEqwHD+T/XZPORbOpWZBa6oAcSnYxws16jygu4/TDZhTILMGe0Dl0AdWpfbmWbCrRM/9ttszwksqxVjU+JjtPTJYKHblS+LGyhIIJHJbHGqp8eYhQfkaXZ2tvbKbtGMRMn6bHWcaR70qg7x3l0vVXBk64Uy8undIwNgKz91pQa2FR+n7qvfPZvEIfzZ+n/LVtKZI651fXJu9lXPmaq7Nj/tCOXCwJ6WpqehxxgKpL+Zgf7nPw83
 dCaxELBC
 bO/mlnuhRHeHGQ/Cs73Ts8k8JlIQfEHZFJgXX1CxIa32PwUnW8CeS/GwoIIsz1KP5gd4h9CrK3Qqqz3IPQLP8LycpmgEKBY9znDpIn1YVlzGSnLxrBr5fL1csBifg+TrnPsqf4GPd078pMBWoZqWddRDHC2yQuCWW/GGSUjSsYrprZHLvZejrSqxiLA==
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

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 049da0305440..33b70ca070b4 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -501,12 +501,22 @@ static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
 	return -EINVAL;
 }
 
+/* Check what orders are allowed based on the vma and collapse type */
+static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
+			vm_flags_t vm_flags, bool is_khugepaged)
+{
+	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
+	unsigned long orders = BIT(HPAGE_PMD_ORDER);
+
+	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
+}
+
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
 	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
+		if (collapse_allowable_orders(vma, vm_flags, /*is_khugepaged=*/true))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -2606,7 +2616,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!collapse_allowable_orders(vma, vma->vm_flags, /*is_khugepaged=*/true)) {
 skip:
 			progress++;
 			continue;
@@ -2912,7 +2922,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!collapse_allowable_orders(vma, vma->vm_flags, /*is_khugepaged=*/false))
 		return -EINVAL;
 
 	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
-- 
2.51.1


