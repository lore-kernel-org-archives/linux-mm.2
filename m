Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B330C44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 15:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0844A6B00C9; Mon,  6 Jul 2026 11:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0359B6B00CB; Mon,  6 Jul 2026 11:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3FC46B00CC; Mon,  6 Jul 2026 11:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9E306B00C9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:44:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 44FBD87F27
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:44:29 +0000 (UTC)
X-FDA: 84958773858.29.2FFE0E7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3DB37180004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:44:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YX3npFWm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783352667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QtCuXPTs/0xQBoZ84al1coYi4yVh7/txmWENN/pYDxo=;
	b=LGfhrkhY2lkdXTaZUk01REGl2j+iC/4wg6/UCZlUfHDeQ6IfwZuPotTArlxQ9UiLViBawb
	ZLn9sUTUEIHSB5mVXhBMvRPtst0nBJOiYICe4ohj0mqOVbZD91Mu02t9PXkM67Of9Mbcw+
	cE/kA0OWFg8KDVEFKbthDepjnHX3HFc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YX3npFWm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783352667;
	b=QtrNwl7z1180lbKfThwc3FlxR9nFxofUuPaSlZyeOd50DQ8qcBsvG3wtVXmlzn0ubOpaDb
	dxPvaXVsiJuxLPRBJW/eQ6K1DlzjutlEshcr97iaKMyAdlnMYxaHeaxS7fXUcwCt3AdllU
	i3feWT3Kw/l2gSA2mxiqRBlb+Q2WJPE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783352666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QtCuXPTs/0xQBoZ84al1coYi4yVh7/txmWENN/pYDxo=;
	b=YX3npFWmwsBjFO+ZxEv3q8HidBDxYEKaoMqpHPuZT6HIQmS9ehP8YDdgq2LT/AP7tmddDN
	pY4ClvavdAE6nzcj1WnZZDgfgyADOQJQnGgjX8kls/StbjVvqDNG94oZtAKOyYK88uhHJi
	GbYQrSMUb7M1OPTZa2Y5o5KzmDAoLBY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-C_KETv4KPaWgJSJjxJTPfw-1; Mon,
 06 Jul 2026 11:44:22 -0400
X-MC-Unique: C_KETv4KPaWgJSJjxJTPfw-1
X-Mimecast-MFC-AGG-ID: C_KETv4KPaWgJSJjxJTPfw_1783352659
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D5DAE1955E7E;
	Mon,  6 Jul 2026 15:44:18 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.58.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1A314195604E;
	Mon,  6 Jul 2026 15:44:08 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Nico Pache <npache@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 1/8] mm/khugepaged: refactor per-scan state clearing into collapse_control_init_scan()
Date: Mon,  6 Jul 2026 09:44:48 -0600
Message-ID: <20260706154500.39178-2-npache@redhat.com>
In-Reply-To: <20260706154500.39178-1-npache@redhat.com>
References: <20260706154500.39178-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: snWRL7Rp8lI-dKqaVRBQox_8WM0rIYiy8-5gEtjHwgA_1783352659
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3DB37180004
X-Stat-Signature: a837an35dcfnix61qsxk7ezew1hjo6p4
X-HE-Tag: 1783352667-63789
X-HE-Meta: U2FsdGVkX1/YbVRAr5GumjDhqBsVT0DlGBjYRPtGqxwSfgA/ayitOpo2RGxyZszFQmqP/zk/EDE596SZzkFFfDO8SBsV4Pv7i3qA8NJdJNZuxPF//A1k+V6I02rJ00RdhA7Z1quYe/6dpkwC+xsnXuVaJa62nTJE4XvYbJss+S0XXvy7XUJ3mKP8vr+Gyo30xJ90/OoALw4Vh2A8L+Sm+rvhOFKdy84OSPmuDXGpS6yq48ovhnbfrzkacayrZQAZ/jFjmXUkku5knnSELOpsRMopgclbfF/SE+7Eh8FOZpbEjl23XqzOCuQq5j9/JAdXMl6slAyZIxZKehYyDHdT0iWw0fy1ah3UUdxA90r85FD9S5c7TwqWUj0KGvx7OLtLuQ8PcKxgspmIoN6ymqcaFen2FhreOdDvzAiHMT39yfCAvnjb2CuFLqRXjxfBS63V2CaUPeTRnixVC4Jhs2vXUpgw2AOE0hRZrAemIGI5+RHsj47oY7W83bTyXJIawAnt7fsazX1KbNI9jUGv/CJXEaAyzaeJsFzMC/deBZLBeR6HEZOYOnwEWRj22i+NlahIwUFXNfA93ytD4xAXDnFT7Ip35gHzExd8Qu1HRw9JPLJ2vpVsXnNsuWx4R6BCbiRt607OWHuk+265z+mCd39ChBpFp1LMDdVNcxEBmKu8fq9+QajUMqLorsaKbdIczv+CbUnR5DAWw+F6l04jhsAOUcZDd+F6Oa9D1Y6cEPrLQ76O8e7uyQvgQRBIOBH+kFairfAowphGJwPoz7m2RBvNK2D/unHM/ujMZbsmc9s6z19o/L6tWYZ7chgzgY9qvNrQ8BTHG6kgAHqFQSfGxOqKnVHsfDkx4uKixud+0/Gg4UhDkdwsbU1YY73GgwhvMOvD9Wi075L6+m3lL3i+pEPjEFK4KTDEvjF9V+5qe9uwF70Mc2yY1BL9gNnKsUuTVwdwviaAPCStGeSGA47wgR+
 eNJFIjTZ
 RbRPLINMMpfvmkBzEzzTrTWGpGmZ9ofii9vJBjX1Az3wnuNlVqgIG9KKVdWS/2UEokSnmVCarbUBxs9A1iZfdbKsFhleRm1V2SOcK/LvBh2cJJFJshYTsOV9fnSOifHMeFIWXi6ko7YcLg0b66wo8nYWHuFcNkc50klyKvHfQ7fGoZsquYKTFs09qzQnQJ7nVWnLx5cCafvNDrA3ViQNpuME5R44me7eBkA096BFELpG01y4LySyopIS5P+UG2ShiCAe8Fi+x3HVg1HlEkz+U8HpIoQCkxA6zkksMwvcKVWl/d9OlZiLXgmcF4uGc31FK/I1Bp3bDur65i9BQqphJEBb8YQC68+OuGhkOV/uVJBYBXWOQagpHfNveS3XOw/qd0WTs6SW0qOE8wpY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the repeated clearing of node_load, alloc_nmask, and
mthp_present_ptes into a helper to reduce duplication in
collapse_scan_pmd() and collapse_scan_file(). Althought file scans do not
current use the bitmap, they will in the future, and clearing it now is
harmless.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 617bca76db49..b3985b854e77 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -628,6 +628,17 @@ void __khugepaged_exit(struct mm_struct *mm)
 	}
 }
 
+/*
+ * collapse_control_init_scan() - initialize/reset collapse_control variables
+ * that require being cleared once per-scan.
+ */
+static void collapse_control_init_scan(struct collapse_control *cc)
+{
+	memset(cc->node_load, 0, sizeof(cc->node_load));
+	nodes_clear(cc->alloc_nmask);
+	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
+}
+
 static void release_pte_folio(struct folio *folio)
 {
 	node_stat_mod_folio(folio,
@@ -1616,9 +1627,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		goto out;
 	}
 
-	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
-	memset(cc->node_load, 0, sizeof(cc->node_load));
-	nodes_clear(cc->alloc_nmask);
+	collapse_control_init_scan(cc);
 
 	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
 
@@ -2686,8 +2695,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
 	present = 0;
 	swap = 0;
-	memset(cc->node_load, 0, sizeof(cc->node_load));
-	nodes_clear(cc->alloc_nmask);
+	collapse_control_init_scan(cc);
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))
-- 
2.54.0


