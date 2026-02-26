Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F87DFD45F9
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFEF26B009E; Wed, 25 Feb 2026 22:26:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD68E6B009F; Wed, 25 Feb 2026 22:26:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1C56B00A0; Wed, 25 Feb 2026 22:26:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 974046B009E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:26:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 53C1D1A07C0
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:26:05 +0000 (UTC)
X-FDA: 84485169090.25.E02DBA9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5523740011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:26:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Cq61/aZM";
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772076363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hrj5LiTC77G7ZSzwqbk3lQXbCqvEX1Hq2YmAwZjmAZU=;
	b=Bhuk+MWlmigzjPgKcOpzx09rR6EiBpp3a5MWVhkmp+vJG/KStE4mJb0w65IlpFep/eouWT
	JDiKB7Sqrck6yUOHSM3MZDmsWW47lQ0x6ZQymGUqy7/nM/SQlZE2t5AyBv1UcYxN4TOyJG
	uf4JeMam90m9Du9f3+c8wT0hgX1wo3Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Cq61/aZM";
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772076363; a=rsa-sha256;
	cv=none;
	b=kOf+LKV9puGk8Ohvr9ZUETMzpWoFGq0HLPeOkaOZ2f02B6tAbIpvlpx8NSkOM1shgGtJ68
	SD57d3Mq/dTpwHfi+3TM6LraZKX77JrJNTCIk1Ng4uocSCNKt3yDlvu2kgP5GZxMC+89o4
	n8HEMXzxeoB2NB7nPXgPATRsMd3HZrs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772076362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hrj5LiTC77G7ZSzwqbk3lQXbCqvEX1Hq2YmAwZjmAZU=;
	b=Cq61/aZM53L/65ZifGwOn2bnSAT/v2xmN53MmTu09Qb5Eylzii27Rz9stWgY9fBA3k+gN6
	iVYqSTUCJB8WcsUvazkkHj/JZhBKKiaOGEd20UJ7428wdjScyOCn95D8gU3N0G5GIAZWew
	j/5CdDn6zqYkMDbnLHrywHHKOCTyoBE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-63-tf9rwXzXO3azkcbjnfdENg-1; Wed,
 25 Feb 2026 22:26:00 -0500
X-MC-Unique: tf9rwXzXO3azkcbjnfdENg-1
X-Mimecast-MFC-AGG-ID: tf9rwXzXO3azkcbjnfdENg_1772076355
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C889B195605C;
	Thu, 26 Feb 2026 03:25:54 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E844819560B6;
	Thu, 26 Feb 2026 03:25:44 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: [PATCH mm-unstable v15 09/13] mm/khugepaged: introduce collapse_allowable_orders helper function
Date: Wed, 25 Feb 2026 20:25:42 -0700
Message-ID: <20260226032542.233891-1-npache@redhat.com>
In-Reply-To: <20260226031741.230674-1-npache@redhat.com>
References: <20260226031741.230674-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QkBThL19BTxQ9nVOhdssKQ3UziTKDy4pRGpSaRheew0_1772076355
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 5523740011
X-Stat-Signature: x1w3k3mpfckybwts4u9kzmppwgro8r6w
X-HE-Tag: 1772076363-487829
X-HE-Meta: U2FsdGVkX197UOSfhdKAyaz00AjK10ual5XWl7yBZi/Sp3h4PIerD9NQXJ/kkm9kYJjpr9wKPaagJmvlxCeel+mRXLGtk4mTkoAAW6A82/wgXjLd5X2X520pcbYASt3WpQHXnbe5upCPXeZH4mnJwPF6r+N0+cx8U2TKYMnQOmX8fq8MCr2XiZ6795GhbUhdtn85zJxig3qujul2fHN7yU1KUjNJ2Co4nT8G6CJOGLOH/bksII3If3ZngcHW+c0u7TmSv+MyOr602tdqcV59NZRD0SGDLh1MoATqawitS8MeeFiseMj/oTI1oYkCXomTLUclaTMaITFo8h7hJwSaaq/80kPDApUVFNoOmtLwtwJaEL2PrJctF2eym3MocHgW9UN323PJ6Xj+36QojgmeoU99QMtncCHgo4xTtjG/OBA5qncSzHE/QmxTnTghIrENpPMnabv+h1voGC5HDbnfo2aKXeSYXLw9ytsUv9LAzliM3jG83Ctr4FrXVfYYBV8hiVcFTouVaMPSF2Su28dLNsMeT2Yla8OrUNQFm9lenxHhwgM+sHoFFRhAye16091zswjd72GxTmN1/dTJQb1SAUJPbDsiTsj987atl2ilUgGKsHp5akJbFvzMZ4axo732+orMKN6pLupiilz596uZ99u2lBsUAfw7fiubnfpa9VNwHy6dBqDpUAlKAdVUL/dynhrwH8jRzrKkpr6Vv/qSiKiywnEJyih848GI/7RcSc4uZ8AwOvKKY0Go3WuKWQlZWuJtmQXs7zE2bKCXrectsr/yIbqTVoLoZSQSiJDI0MaMX7pk0MP5dM4LmcpxCH8eeoiHv8FiUWpkkjE0J09mACqLvv8oaKUpghTBZ8F7kfAyIbKgAtUIKO72tSTQvYeKDdPgPLBSmJ3ImO3DObtM1gvRd5BaZvA96kqH69oqvahVU06oVmW7I+nhNw5xZXZw+x/Deb7urXP2OqYYV1K
 DhchFzIY
 ypCPX9S1C7zcuLov/LXzWotNZZObpi5ZgqER5QB46EEOYZ5AfLO1tc+DTdD3pDfabjQ/nSQIvLKE63EhdJ602EfouR+rGWhLW9wcn6ysKARw5UmAIdj3NMMu90kWu7b7Whm+UQSjZsWV6ctY=
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
index 2e66d660ee8e..2fdfb6d42cf9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -486,12 +486,22 @@ static unsigned int collapse_max_ptes_none(unsigned int order)
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
@@ -2637,7 +2647,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!collapse_allowable_orders(vma, vma->vm_flags, /*is_khugepaged=*/true)) {
 			progress++;
 			continue;
 		}
@@ -2949,7 +2959,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!collapse_allowable_orders(vma, vma->vm_flags, /*is_khugepaged=*/false))
 		return -EINVAL;
 
 	cc = kmalloc_obj(*cc);
-- 
2.53.0


