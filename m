Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A74AC43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E140B6B00D4; Thu,  2 Jul 2026 20:32:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC096B00D7; Thu,  2 Jul 2026 20:32:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDAA96B00D8; Thu,  2 Jul 2026 20:32:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92ED36B00D4
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:32:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C97DA16789A
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:25:30 +0000 (UTC)
X-FDA: 84944513220.09.B2FB562
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id D9EC980009
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:25:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="JT/KkjPI";
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783013129;
	b=8UqPn3Uo7M+i0MKa3sEPSTUuzjonNFDSA7db84OjrC3AfSXxXcN78H9bQtkA61sJnp+NoG
	QJO2hdXXTs+UojWE046dXxMdWbf5k8cW5+aI2uSuEbQI99j9Qvwa2F3c2+NDJHStHM+zo4
	qRX9EWhpnhp4B7C5ojarXLl/lhBxCuA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783013129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cBefviiafkFbe/nsc/cyLo5CV934Kk6BkNirD8bq4mc=;
	b=QlDYawJkf4h5z8eq3ApPYIf1KIqR5rryjxQiOl27zs2vnPC3C8uNHlg7LPR8wyGuEGYdMS
	p+SexKHqVm12rctlPodaYeqTxB7GyHH7YlWFOg5GbOTdxfYZopov9id+j3j1E/ZtH/Ufly
	hRLGcRKBTzfplBWLfJKRkWreuQ+9sS4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="JT/KkjPI";
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783013128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cBefviiafkFbe/nsc/cyLo5CV934Kk6BkNirD8bq4mc=;
	b=JT/KkjPIlbroq5pf5LRyfYXwKp1BWiW2eVA6PY4uphi5DTMKe2Vz0V1F5Pxt2RvVk9N+hT
	l3BdP2LYy68XPOC36lEXpITDhcbgGAMSSwSCi0wa/EC9us6dV+NDJttEnkJOrfXYUHvYRn
	04AUNKXPXNvaME2P4KfTnCvV3KZ3/dA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-8-YlzfNNoRPHuWMl6LqaNVfA-1; Thu,
 02 Jul 2026 13:25:22 -0400
X-MC-Unique: YlzfNNoRPHuWMl6LqaNVfA-1
X-Mimecast-MFC-AGG-ID: YlzfNNoRPHuWMl6LqaNVfA_1783013120
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 950071944CF2;
	Thu,  2 Jul 2026 17:25:19 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.76.7])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4486E30030D0;
	Thu,  2 Jul 2026 17:25:10 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: ljs@kernel.org,
	willy@infradead.org,
	Nico Pache <npache@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH 2/2] mm/migrate: exclude hugetlb folios from MTHP_STAT_NR_ANON accounting
Date: Thu,  2 Jul 2026 11:25:47 -0600
Message-ID: <20260702172548.37075-3-npache@redhat.com>
In-Reply-To: <20260702172548.37075-1-npache@redhat.com>
References: <20260702172548.37075-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: tyBEfGF2aRTUIU3lYGCSJz5HvXLEDneWgHM0oKiaoP0_1783013120
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: enrxntdp6ksofpc3qozc8meegqw85dbh
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D9EC980009
X-HE-Tag: 1783013128-557617
X-HE-Meta: U2FsdGVkX1+vlX+Aj3803YmY0VZdbD2uJbfnPaqMdJ1/xnLwe0Ca1sHvUZwzfgsFQgj80Xzhb6AToPiuQ7E+gO1XqAzAbwi5IxnGC/Hoq4gj8AQoJSPtWhQyJS84Hl0AkdJ53YPMfMaLgui+9U6pWJNEG/WjdmXT56DRugr/XwBXh9AmCaiRBvESvhnsjwW8okMopGb5axwR6F1VBvUHRYKYHr+48dOafMCXs4IlvdijJ+/3Xkg+1wzsg0Lw6yySPUJYi28AmylsxFFKFOtYmc3s1U+OlW9panvxOXoMBNbJL/+86tncDHioDdDzkL1+eUgt0qae7a2nzdeAeDmw9+aPTGFGuC8vT8vsIdZv1g/QViGgFH8XLIHo881wKyZ4ysCotHSGzsFCyNKQbJn66ZBb5KYlV+S64Z4C5cZHlX+mzphoCj1XfwbZvpKEUGXlAXiiw85hyTGDBOh1m9C7juvXoCsJ0VrkREz74ibZxCTtbFXRXA1FhCtY3lbSwQPbVYclRmvEMSjmivhrKDgdZTGC/bbOLpdmoyvVrWl4H2pvqnPDKRFqMeiHLgcIVn/cUY4FcQbGN4hPwzjvSUpH3X7B7ofRb2jqrQLcRUkGYIWjOIChb+BS5wGQzsZnzQzKbmPfE6v11s0YdmbPdOpGHrU2goA+Zifl3/yUd5SjxbdBre6pl9DkscXZ8nH5TNjB66RtH0chHHUDFrd/0DOcGh+uf0yGI9WyCD03zUQRPxfw0xAoqPTfv57GEFdpAN/+newW/gIhtUcY0lM1yZmpDS03pCTlfLJOZ07X1vRQwp3OttzeVu/tMegSTIXxrl8DJI/wEh1rwm0Ze+raD8CM99ldQRAH6gQm0bgyXcFtIpWYCncj7N67cPnzEupu4SUKrUP9HDeuyMAIVYWDgdIOBrOlo5JWGQ6JtDzrsnEksuUIbFb9tX83wt81HNf+SVkZcp/E12isNU2WwO04MCh
 NPcbRWSx
 E0yqEyyTr53Fq3iX1yXKNSm5gyOd2zkmtXIQACmedpmu93CENRnGxk4JPeU3sPR5xRNxMeCVa35eqeYVA5P3/10TwQspnWH3dDM+lJ74PxKSDkAYLbbAylALaOrS0Hv6PQWdNyqiz94yY5Tdzwbe9s5hr4uazpAJ5rhQW96GrrkR+kcz47SOzuHmddE+MwzOA+lf63csA265mhvmed45/9wtrQVE79VRaoVK7hgl7MLg44o4f4+oyaVlb/MZSdBbH6Txl60h/3ohQ4Ex3uGDWpkDaXTnY0K6LVWzOVh5S4nYzZmbhEF7xiU6BbHgEuuhxOal2vR22Jr49ieKZjkY2c9o36j+wdZn776FE86hP8pB/2CPB4k7NOYmA2IyvD8bC/KJ+T4KjtrjQQw7tvtDnB3I0fROIfhk9wCKPI01RdR7zYU3mM2lLz0Uez6gDZAqUaDJH7k6CmutXFuRIHvEnsTQICnE00QNBOl0w+yx9R6k2GZ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__folio_migrate_mapping() increments MTHP_STAT_NR_ANON for the
destination folio when `folio_test_anon(folio) && folio_test_large(folio)`
is true. However, hugetlb folios satisfy both conditions despite having a
completely separate accounting system; they use hugetlb_add_anon_rmap()
which does not touch mTHP stats, and their free path also bypasses the
mTHP decrement in __free_pages_prepare().

This causes MTHP_STAT_NR_ANON to be incremented on each hugetlb
migration without a corresponding decrement, permanently inflating the
nr_anon counter.

Add a !folio_test_hugetlb() check to both places in
__folio_migrate_mapping() so that only actual mTHP folios are counted.

Fixes: 5d65c8d758f2 ("mm: count the number of anonymous THPs per size")
Co-developed-by: David Hildenbrand <david@kernel.org>
Signed-off-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/migrate.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index d9b23909d716..9fd50ea25d2d 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -590,7 +590,8 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 		/* No turning back from here */
 		newfolio->index = folio->index;
 		newfolio->mapping = folio->mapping;
-		if (folio_test_anon(folio) && folio_test_large(folio))
+		if (folio_test_anon(folio) && folio_test_large(folio) &&
+		    !folio_test_hugetlb(folio))
 			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
 		if (folio_test_swapbacked(folio))
 			__folio_set_swapbacked(newfolio);
@@ -623,7 +624,8 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 	 */
 	newfolio->index = folio->index;
 	newfolio->mapping = folio->mapping;
-	if (folio_test_anon(folio) && folio_test_large(folio))
+	if (folio_test_anon(folio) && folio_test_large(folio) &&
+	    !folio_test_hugetlb(folio))
 		mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
 	folio_ref_add(newfolio, nr); /* add cache reference */
 	if (folio_test_swapbacked(folio))
-- 
2.54.0


