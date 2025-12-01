Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EFC6D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 726FC6B0027; Mon,  1 Dec 2025 12:49:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7C56B00A3; Mon,  1 Dec 2025 12:49:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EDC36B00A5; Mon,  1 Dec 2025 12:49:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CF5F6B0027
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:49:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0771D1A036C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:49:07 +0000 (UTC)
X-FDA: 84171638334.27.B54F7A9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4709EC0016
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:49:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WLNM1dKy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611345; a=rsa-sha256;
	cv=none;
	b=JmOGRhlbRFUssXw8Z/D/BSAw6rikdNW/QzDI0gUhIAguDJiH/45MZu0gAQfktwXG9N5tac
	vOFDzRmQb07RXO1gzsFOkYXhuXQJaGXAxWErvSt3+WG6uZkm1Lp8XnfXQ7NunMg7iFSWvi
	SJKaKIyAqLhodTiA8S57zHpds+RupwQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WLNM1dKy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3gRUiF8mEp9L+AXSy6J1MD8KbO0BfUvL2BNS3sVCA0s=;
	b=RCAZZbC7fIDTSyFFps6ZwnNPYvuocJNCiMXsHt93PFuhGO+tnMvcgz979cretxTe07E1Vv
	WP74OXIRjpTzqnvbMVY0WzQbHlU352EF2n9QjWcVKqBfCFyzy8ZEzIhA/xtcVXbyq+Cok9
	En5w6Vtw3z8RCxnaruo2T0Yas8dU7x4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764611344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3gRUiF8mEp9L+AXSy6J1MD8KbO0BfUvL2BNS3sVCA0s=;
	b=WLNM1dKyQCZRrCsi+uuBjjUrlqnWeseLleBmdHUepnr90TNJc93zOkxAJJI5Tj1zD61Y6l
	tfQkztKBzd0L/VKVGkzc7t8kQsi1ISseEavKOhmZBX8VouWTTbPoS59DMTMSpkJ3nYsxJk
	BXEy9LxnTpAYMKVYV96zYazlKpb1vaA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-347-yN4PK79xO3GeDfZfbQDtcA-1; Mon,
 01 Dec 2025 12:49:02 -0500
X-MC-Unique: yN4PK79xO3GeDfZfbQDtcA-1
X-Mimecast-MFC-AGG-ID: yN4PK79xO3GeDfZfbQDtcA_1764611335
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1E0C19560A7;
	Mon,  1 Dec 2025 17:48:54 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.66.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9FBB81800451;
	Mon,  1 Dec 2025 17:48:45 +0000 (UTC)
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
Subject: [PATCH v13 mm-new 09/16] khugepaged: skip collapsing mTHP to smaller orders
Date: Mon,  1 Dec 2025 10:46:20 -0700
Message-ID: <20251201174627.23295-10-npache@redhat.com>
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4709EC0016
X-Stat-Signature: n15n44hat94ox3j8dygjpaca1mub995d
X-Rspam-User: 
X-HE-Tag: 1764611345-975973
X-HE-Meta: U2FsdGVkX1+1Y7w80IueQrZqg6/7sMqJ/qtoU3UjhfZT7+FUcx4V5Y1kd6a/EbUdwGr61Ffvw0s9oonTtYlyx1BXwCf1zAPrBRtd2W19arxe+8xhgpZoFqUmGog7AQ3bmPWLhhqhhAJh82ayohn21FfvbMnfirQtFTMfMerbevaKkX28PLtUifzxOUC5R90PmGe2HttKNHVIv7X7Wf7naR8Mr1d42mJGiihcmOJyXqT2JS2UooESli1qomLyy+Yl0BCfTZO4EIeJ/Uq5GAQR1tawc4ZdkTV6y6zU5SGu4dqwGUr3lgmx80E3ZlL5Y+gIgZGK/w/YmEkekxV4u2n7fT2lECldsNNrrZ11yPcJG62vptWER7x7ZCDVgxBN2Z2ebuHQxS+PkBZfgIJTBQBnLJrgVSj955qocgKzUqg+kWcnbNMTEc5tlkk4eKodgTCsDbwF/2RkV9+ydw0+Moc32Rrnv3Weo2NFHWY3aniIk3ssTG/lPwoMJNnpnug0ZWmEDPgGusPbP6iJkyQHchLANuw0NF8VaJgDSGKaIi+HMcF/hzB4ENxuX6UXmU2vcPLYdM6zXPIzrqM1IOcXxO0obl+cbNfHmirPJgPWuNs1MDCGR7HYNw2xMTboUK9uEDVhZae406zrtYZUZEDppKK3SgvAp+3EJrqhLXd42+O8faxbK7GS7jUdDzte3i6oFLJeGBSaxX7HvVCMsklQL/gQm++8bdBjD5CqzBVwOXhtu+8hqGUQVn+ZQGyUnKzTnPGkBNPH5heN74/ClZtEcje2gyCbaXJV4wO9y5Y2YL7+aYJ1vBnYzdcgoQWHDZlAgZfteXR4PDKvuSislKgOX4l5JykwpxxGHZbMyj7RLUbmgk2BaIVY3wvtHoXx37jCkbEZra+MRSy2wudy6jdbmLLRDmGuWO1vVZYCzsT3J3uMOtr0Tew44xryEWqPxNdWidWByyv/9orcWO/i7vxzUOu
 0NmuhqLP
 a9efmSK0i5Yx06LFpA2C2MDR0Rmv9JUGIUotvwMbMksax/qSwuB3z75NgYL5MjGBBt6ANFtVMgSzve7U+7DdyML+AIp2cHW3dOnbLPjK7YGgH3//1msICjWnE/UbDABsN2J4DS1+8+4iqHvuol+Z0oHzsYSJylI4OnfnNgupzRfD20Toj5rL20IsGJ4Zy9A7Yua6BAJWJ2K4GK+kBHs7skKeU4uF3MV/HYsw9tdodFUAdp4xvNV6kNY/sRqq6dZ0WeL/Al8nyjcgpMf0iRs9TctC2DeJ5bBIwPwpYr6kbkPVQkVu4i021Mbe8ATN0S5DIVdKTkmzLM3TA5GnEUKyy8Q6OsfR1dVlFzbHgzBIApz169ZUsMOP7Gt5ZGe6IpGtx+Hh+k4O/IIsMDzrFwSm1e3egx/DqO95lElwj5vJXjFZa20OVbqM4MXSQu2mIntfZenhDdYlqxLg8CNJyLlCNoOH/Mi+dJjIV8T6pWsUl9LDmZA662d5r8xBo8Q==
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
index b41f68bbac80..b2ea56c9bb42 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -641,6 +641,14 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 				goto out;
 			}
 		}
+		/*
+		 * TODO: In some cases of partially-mapped folios, we'd actually
+		 * want to collapse.
+		 */
+		if (is_mthp_order(order) && folio_order(folio) >= order) {
+			result = SCAN_PTE_MAPPED_HUGEPAGE;
+			goto out;
+		}
 
 		if (folio_test_large(folio)) {
 			struct folio *f;
-- 
2.51.1


