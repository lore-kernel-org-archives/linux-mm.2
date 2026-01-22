Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08316D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B5B96B0330; Thu, 22 Jan 2026 14:31:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27CCB6B0332; Thu, 22 Jan 2026 14:31:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192DF6B0333; Thu, 22 Jan 2026 14:31:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 064B96B0330
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:31:45 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9464EC334F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:31:44 +0000 (UTC)
X-FDA: 84360594528.19.FDB4E01
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id A35BE18000D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:31:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="MQC7X/ii";
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bU7E5hdUGNgGrN6Wt8qU9VMZHGCXhyylfYFNnuLISz4=;
	b=uzvcM9oBHJJhRu6MyDUjepuczquatQByoRuY/kIgD1U8sySK+kTf3YJZlaeXTo9XPKpicb
	tHSxC8XW4TCH7RiGqxpwWjXEqFJG+8pcymR4vVCoAdMgh4Qzy6Ef5yYMhmFdT3fHnwvfIf
	sdPF5ubRxnfMtuNBKb2Wenxx0jGJIrM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="MQC7X/ii";
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110302; a=rsa-sha256;
	cv=none;
	b=vsNQ1abWvdTRj20nbwyEittvNSjGKEwSQQL0/OFSGJDoLwRoWmYkMjRV78UraV48HHciL5
	mGuIA+XO2h7sP4hghVjYzJ5ffpgxIW7CHcQkTdlzYODtJwY9rjVnDPeJ7+YwxmtdTgdVVN
	kOTH90zULWcIRoWIiQr0wq2MhaBZOD4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769110302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bU7E5hdUGNgGrN6Wt8qU9VMZHGCXhyylfYFNnuLISz4=;
	b=MQC7X/iiPuP9xChCHbxulsWPllLq1a2q3JSPMu45olbU+S2rq5g1J6OnOYsvkoDPPjwIYe
	lKczT58cSom2wd0wWbuykTY5NdemnVS/AwAHXUS44ammuquPeZ03f3gdpEOZoVO3S9ayh+
	//7/16PUUvWLObUU/TqtEWubzcliLMM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-540-b4T1AuhqPImBgoIaKa1Rpw-1; Thu,
 22 Jan 2026 14:31:37 -0500
X-MC-Unique: b4T1AuhqPImBgoIaKa1Rpw-1
X-Mimecast-MFC-AGG-ID: b4T1AuhqPImBgoIaKa1Rpw_1769110292
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3E4719775A5;
	Thu, 22 Jan 2026 19:31:31 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9B7D71958DC2;
	Thu, 22 Jan 2026 19:31:22 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: npache@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
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
	zokeefe@google.com,
	rientjes@google.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH mm-unstable v14 09/16] khugepaged: skip collapsing mTHP to smaller orders
Date: Thu, 22 Jan 2026 12:28:34 -0700
Message-ID: <20260122192841.128719-10-npache@redhat.com>
In-Reply-To: <20260122192841.128719-1-npache@redhat.com>
References: <20260122192841.128719-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ahyvXJ4le3Gh9FiIPSC7mQ96jm9_8V1q4yutbLt94f4_1769110292
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Stat-Signature: mkuan4s1731rfd736yeid94ttrktex15
X-Rspamd-Queue-Id: A35BE18000D
X-Rspam-User: 
X-HE-Tag: 1769110302-418683
X-HE-Meta: U2FsdGVkX1+TBY0g3Z2RKjl7AtyfRjCAlZpqXhGsT2IhUIvWHfxyc0lChNCsHqY1WfSgeH8coIcYjHbc1q+0N2J8+7D/Y70mMjIrt3O91YtXkmoSgdceTcf9uyjS7R5zwtUp0Vasf0d5HyOckPjiXvABf6GkGgvf/9Mr7HyrCCcttn9YbJx9d1XSSJxsYkv79yA09mGDt//Ia9zdpMp/t0+KKWLnPabMuGr89hF/ZMIOCdsLwIyUZ9seRUB2J2cLhGfiYulnOqT2fdvGoXaIZq8WU9Fljg9xh9WrL86SW7RNpeBUn5TaWIncSnV7V7FZFq2wFzQH3kEewrKt0o6/otizihdFGWK6NWnJc9wSJvlAN/g0XcUw9JMwE7RbEK9T8zgmaYgbvKm7ThEGZSdk2X5ROAlKXkLl4fKITCwmIhntvSJnoiP4K0sVW56W8DswsKcKsEjwEx6It8WJPpfX4NQnKjLO0H9HyW+B8MZqRBVDXP3HRx885Q2rFayfsngqi2OlKfeA2w4WG2P2C7Q6Fk81mNAA5N2n1K7UMepFzLTq/Nmt+guy3HRsysuAbCahQK/pB5S99yoC7VN5B/tauVPuK7NIrzgd0AuVwajHBXZfPN/+veCh7yeKkx3P7y8W+TGNKABfPVJUYYeTYu207kW2kUSm6U1p0qFMj79R0TdqJZzU4kf9xUMkoLV+SJadaVTDMT7uTOqhfYh610I3myUA1OvbKTXqzzwUADnk3CAxJev/jlME7zhPEIXQwJk1zV6YnTmaRveSjJSppj1jIlT5qWJ2Kc5x0RYYpnfD/p9NF8B+syK5Qc/ADyHTMPV5r7WHwebFg4h5am8ajGdTT4ajk6oSJFzTzY8nrLRY3OuCZuPTR4+gIZ8Dpo7s2VzMApGBrtz7eDzQoG6Iz5a9IgQ1cXCQPDm4Rr4N2dhot3clekt/LAbUoDEL1PoZyuSAMhxda8jK+5/P/A1rIiY
 3X1qyaYA
 dOt43+EWA866qQatnRMMZeZrP8xSaCZPye5rfFWUBIFPXRn0h6x8iMyYf71tmN+Zv6/8ISojhN5wP+i2d6XJTcxuUm+wTaK/vjAeRFpIm/i0byk3nt9pIul3ZI6uLnITnqXDaG49oQyRU4c24o/kNP5V0YfOBnuKN3RCR+B2UBrrAuhWyscGlOEuOTvx6s1mZuatrOKRzA3zhDLriS+yXUVxhJy3QWkeNAf/NSGoqnwPlYa2reBAytu9Q2im478+7rkGrLM/mKUZaZfVdQJRj0k+dkwDXB/GxKiTW0eXqsFaiO1wvOKVzz+u69JBrMmDUMuF0Itk+/NloVdxfsYe0/KCPPB++EBEvW1fi6qQkbiUpTa/hVqRGhqgj7+kjIaCvecFY4PkYLM2+xWdnPEYbKjbCcq3saWI+HP9whw4BHiLNyUkHJBmL4ONzNW5KQnODaZ4kPDsX/TGYlklC2jV8An8rCtKwZ5ndhw34kpQub3wOdrogsr8ofMdOsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

khugepaged may try to collapse a mTHP to a smaller mTHP, resulting in
some pages being unmapped. Skip these cases until we have a way to check
if its ok to collapse to a smaller mTHP size (like in the case of a
partially mapped folio).

This patch is inspired by Dev Jain's work on khugepaged mTHP support [1].

[1] https://lore.kernel.org/lkml/20241216165105.56185-11-dev.jain@arm.com/

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 76cb17243793..8bb70e1401ad 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -639,6 +639,14 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 				goto out;
 			}
 		}
+		/*
+		 * TODO: In some cases of partially-mapped folios, we'd actually
+		 * want to collapse.
+		 */
+		if (!is_pmd_order(order) && folio_order(folio) >= order) {
+			result = SCAN_PTE_MAPPED_HUGEPAGE;
+			goto out;
+		}
 
 		if (folio_test_large(folio)) {
 			struct folio *f;
-- 
2.52.0


