Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DB35FD4609
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:25:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1E5D6B0096; Wed, 25 Feb 2026 22:25:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5926B0098; Wed, 25 Feb 2026 22:25:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0F36B0099; Wed, 25 Feb 2026 22:25:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAAF06B0096
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:25:07 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66DA816080F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:25:07 +0000 (UTC)
X-FDA: 84485166654.14.71E00E9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7FF0380008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:25:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a+AxPCvm;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772076305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xpC44Hv8Tld3RE64HDzSAIEvSppcKmy+xXlb2CxI4KA=;
	b=hW0LgCx2zW7ZHEMgTilhPmDFl3JgmP0BzR9/C/UJlixS5gpH6Ez9ZSwPBEvTEEBugbq9oV
	k/xoucoPRAzpgRAypE4V1o3TxOvZCEPM7TQCi4TUZFeDxkvzBmIT6QSkorLDJwy/4r47uO
	jBsNmStYHMoFsEfbdUm7Zp4MqMOW/xM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a+AxPCvm;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772076305; a=rsa-sha256;
	cv=none;
	b=BtlZjkm4vPpyIiYqdFqQ+6dbqkUH436rXBVnXBkoAzKycYnKllE+ZfZxRLu6eRHooN55Ne
	Yxb8TOLDndbrLJQe1M50i/tZJ8mrLg7UyZWpUnnLAFpS2JvVA2VsJNCwYPha6HAz98aBTn
	KlHd2Q2S4MMsNtW/TFOlkXMys01FkYs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772076304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xpC44Hv8Tld3RE64HDzSAIEvSppcKmy+xXlb2CxI4KA=;
	b=a+AxPCvmS0z3GbI27qSNl0jBodNvTkMq1EGvgNL6u/ZKZ4ZgFdV4MZp2QYBGCxzCZCkTtD
	VMYTItJQMWvael0E1gMlEGh0uR4gxwz/C8S84i8VlkyW92r1hPLpgNtGmHDZud1NAfSDDV
	Ay07xPjDlvDAgEBQzLmoECEvEXLOSUQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-WBzvmiF1OcGoLpjhAwkNaw-1; Wed,
 25 Feb 2026 22:25:02 -0500
X-MC-Unique: WBzvmiF1OcGoLpjhAwkNaw-1
X-Mimecast-MFC-AGG-ID: WBzvmiF1OcGoLpjhAwkNaw_1772076297
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30B191800349;
	Thu, 26 Feb 2026 03:24:57 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9C8361955F43;
	Thu, 26 Feb 2026 03:24:47 +0000 (UTC)
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
Subject: [PATCH mm-unstable v15 06/13] mm/khugepaged: skip collapsing mTHP to smaller orders
Date: Wed, 25 Feb 2026 20:24:45 -0700
Message-ID: <20260226032445.233437-1-npache@redhat.com>
In-Reply-To: <20260226031741.230674-1-npache@redhat.com>
References: <20260226031741.230674-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dZuxcqHE22g11RrNBOkKaHdO6AQ-T770gkjXFTa0PVQ_1772076297
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FF0380008
X-Rspamd-Server: rspam02
X-Stat-Signature: sf16zuo8aaq1wjmq1tnc993fcfdp6kpn
X-HE-Tag: 1772076305-890148
X-HE-Meta: U2FsdGVkX18Z6NCz4ixM2YkozPDCNdnFNq52MTUErSEUkhTY20rSc0719Fbu2sz+pFXO8Wu0Mq5iYZcurc815aOOyEKXfjNUQPzdS6hOxZgLQOmZEnVJ+wjnDB/KmoEU96IgICMnoCBUbCb1GajtnWdkC+6nZ5I5P6YLxbzYx5hw+E3wKgIAhb9dQ5NF78THXYrASU9z+y7wtOzZht7TWolYOMsJ8v6+3uyewk1gdeb/rUHWxEs8NfDMMkVuSe3w7H41DMIB+6HKQhhBNjY7Wm67GN6DQ4lr+mPLdg7a2oJZARjKdppf2Mo9HZEN5hueqf8LzyWz70hr3Pkn8nhPDpYR1h9ezAwayeiG8NGkR099gkqh7szYwkzXqrUZXatSxq0i8WB+mp1Q6e0ysXq5DefH7QxZPDScbSvHU/WaLAH6PWj6TA02JX0rXi6So0/goynzicJsqLQjOV+Kj5lFxsTz1LgXN9ec1sTi1v6h80mfdpmWDb9UqAk9pQNshsANfNuw1HStfF9ij9EDR7aCU4IMDxbEXTNiZakgpsPT2iRFRZTLzqQfNtM/NQW2bzEJ6mvCg9D1NvCvzWqCPK6+A/sKOFlVAG5CrdeWMlou5hd/bxCmuz8Irgtg75JnBTv+xQh0mofhZv61/SOC8c0sjJU2HMDmlv39XvdS5Ze5F2lo3UEKC3YraowuyyM2bdd9LYEPzxh6gpT+j5KwZG3kZgMtwSQOvabK2LCOzekGtSAu9/bdLVh3Egh5XSc/XMLEyFuBppUH1jn0imQIn0yQSGu+p7F3oD+W0FnjqDx8TtgQ8WI5+U3zHGuUJe/ykZ40ouHsr6zw0dlXsz1Hx6wKCatQ4C/sBKmlsO0r2JtmF9p+VOABCMMp84vX7o2I8N6WTvxqY3LkJ3YULn/enfqXUtsGh31cFpHjSLCGsCxmmhWloPQc4Jw2bwUTzBoCzJqPJ8FZhiiQ+aihXc91j9i
 3kMGdEdp
 /PtnM5HA6LzO+wuHhiANRr6m2syqIxPQFCi0+fVZPpZvnR01Ex+UfXgVBpQ3LgmDLWY7uskFpPGwOvAVxUveGwut4a4ev36gEAhDAMaTbMhUEa1gq/Aopifrry/SsFFIQ8F7Hoxzld7oVlMUSmfW0aecSkhevzS0pRpdxURvrSovRtmZa8NlvdsVZb5F8llhB6TiOuavtyvBW638E65xraXYy7r/KT/DEGx9epeykgGOIUYUdUC7Dxs6nSE1QHii18m+HcSIdhBUGeQfzHgUI90iXbt5C7qH/qiH+CviDJRCYgo3kkVaSqHKvllx8AilHIWqjl6lwBF2siZVApZHdL7MV8F6pCfcDxH4MkXZ0OLVWsrniQ+XrwFNPN2zoqsmYuveVu9On+VaAzehJgasIgrw6F190JQLndD75LLYQC8a2M+XFidC5Wo7yCvCriEg5y8oWlFR44b/TcBJpJ3bAxbNklM8JVHofDbuQPaEWT3rhVEVydTbCFbYaSQ==
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
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fb3ba8fe5a6c..c739f26dd61e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -638,6 +638,14 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
2.53.0


