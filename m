Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F046910F9972
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 20:25:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3B56B0099; Wed,  8 Apr 2026 16:25:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCB9E6B009D; Wed,  8 Apr 2026 16:25:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90C096B009E; Wed,  8 Apr 2026 16:25:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7B75F6B0099
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:25:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4197813A124
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:25:08 +0000 (UTC)
X-FDA: 84636517896.22.387336C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 59A8B1C0009
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:25:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=esac3LiI;
	spf=pass (imf20.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775679906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBg+N1vPihTVzt5Os9wJA+I+ybP1ihgxx5kCeaXYvp0=;
	b=f9IXu3Z5y39mnxUdWzqAnVdGtryS9v5bqH4i7zZtku2ZbpIq3VMDPoiVATX59451dDOMT8
	kPXzibpwr+sQZYBEVaL8kE8iNW5qRpnDe7XeSAH+Bumx2G8FyLk7x7RBnzkoi4mGzrh8rj
	xZ+WhhXvrIYAfUm+mxgITMYLh8la+6Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=esac3LiI;
	spf=pass (imf20.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775679906; a=rsa-sha256;
	cv=none;
	b=BlUVnlNeTDXNTlntdJ4aHmSZSGrXAMrUcvByDrujemfCE24S82Gy3hiddjvTiAM7bONDOP
	BeoRlA+2YMSubAH/T2JQidlr6kX1UhfgUJcTdeo6rZcE9MaGCXxRfGDl8RWzT3//rrkyIc
	ZSiQ5zZ3D1WBZXPzbG3t8i5I2zysAns=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775679905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TBg+N1vPihTVzt5Os9wJA+I+ybP1ihgxx5kCeaXYvp0=;
	b=esac3LiI2yQVdA9QLOO/ernwKbVyE21BH/W5HxjUYmth4jOBKuZtlqeygujpwL0LAhU7Ou
	src7Aq7gijWzHLIYKnVQUEnYJQSkh78JvU/VJjK3xKC7pGoHZJK+sRGMg1KSLqHegvA5xm
	AJQ1f6jbPTuWqmAP0i1kjzibbEetp4c=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-146-7scCV4SDNpGdAdTAdm9izg-1; Wed,
 08 Apr 2026 16:23:25 -0400
X-MC-Unique: 7scCV4SDNpGdAdTAdm9izg-1
X-Mimecast-MFC-AGG-ID: 7scCV4SDNpGdAdTAdm9izg_1775679801
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7558C1956050;
	Wed,  8 Apr 2026 20:23:21 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.88.140])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 59F8B180036E;
	Wed,  8 Apr 2026 20:23:20 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v3 04/10] drivers: nvdimm: use pgtable_has_pmd_leaves()
Date: Wed,  8 Apr 2026 16:22:59 -0400
Message-ID: <0309be4a7133ba8d043380f0c3614af764f6e3c9.1775679721.git.luizcap@redhat.com>
In-Reply-To: <cover.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: wJj_e8fWDzEcH0jvErNnGG7W2WsX2gBan_9oBSU9ICk_1775679801
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 59A8B1C0009
X-Stat-Signature: 363c9mjrhbhs5mc8c4x3cxnqmsuebka3
X-Rspam-User: 
X-HE-Tag: 1775679906-497544
X-HE-Meta: U2FsdGVkX1+ydcR/TmRB7azPUNnxPaeLjlgt5+l2UgkERYTHWFZHnwB2piK8c3XVW6XJ1bLKK+c1vAuApBR2ECqjcND8TD04CHQuUj6/ToqPqhNU6Gqhp1xN78Ud5blJAVK7i4qZQEjF7a5ECM9OTbf/Ppsp8a5RsSUe+TNwdizVevuaUIXh5Zl/7T0OvU+iPWewnAzD5a4POcZzb3BiCSwOgRyZO5UilUz7o2CKCw5zb0/J0l+lZE+pR9MiJGh/xKPrg0NWm9RAQkTcaveO2w+EoUm+2RfrTkFZ4hs5ZKKca6y0XwYilmJgIE//RyhFOXWl8cMwndL7Fl43UgcGA0GTQScbcs77R4w91MXUm5A4KMudiL8xDUQanWk1aywbrQUBFC4iNydShbS7nCUtaxhoTDydu9EgvqoCw9IAyMRiAbtDv1r1ttCeIjq9h2GGFlysswCUMX5F4hoWrBVKF71D67dbwQZ/ubIfE9erVkZ5oUudZq8dF7LZyIBz1SMoNjB8Ad/M/rFW4ccRgMdttLJHatmFwOC6piQfRHM84mFEKcO88p/VNcxLtCuAQK/8C3qjGHVra3w+fdHxeUhwuFXpttf5/JuWUdXc8uhBJMW+4ZuvaCGj4hgZiVnpv+tYTE5HatnOi9LZpMZez7KOYboGGcG4mzszZRn11tX9jLaRiIXhdKRhjNjycN8D4VB3vAlEFcQLPe2qdPJqk2PIK1rZ40DborNevxh5X9Axh8OmiYXqrd99vBiEWxrY3rP2oCHQXpBN1onphCopC7I0aUh+VCTQy9/UVddQifiMbML0Zhz5xBNSS4FZEJKxvRxfN1TojJN/2KC8O7dZALlgL56VMJQvpKjU6M1+zFInHKc+VPxvjin3Te6UKitpkI/TDjR9Yka8TMhFHC6Ysgy9N9SkXDABc4zuMy259BxhnPgKQ7YYcsjjr5mwNo9RzuaT2tzr1TtX2X3/Z9ixOIT
 5T6OoIpG
 MDRws7Wkr5bbm8moLEHKYPnJvZVFH8xmb4DoD0xhDcgUm4BPAEeVS9MJPBUMDsnZQQSLOHzdWIt6f1bnsIX9J2pUL0Z55FiPYqBhX5wI9jrUxRuL/r9tVTc0bSNsb/eVcbxIuDBrK4bV4VR+Q9rNjpMC/E27rN4lFITWBkD3PxS9K6ONVPXzBfv02e9SMOhFdBhFnNdT7AKbNFoeDN7AcB/NbE7MknSabq7SZ3yEf5IejaLmYaFXDtjNUvggiUV0cVhmlaqhnlbW4XJUwaHRtpInlQtFNNiW7IqmlJDxQIRn2Uazb9X47eTnbp7KJDlMN9qelaG80pwdGbMMI51bDemOVS1hvdDGz0SAwZHjPpbPkBRttFhDMIDzqa6VHLWDbU/Wj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nd_pfn_supported_alignments() and nd_pfn_default_alignment() use
has_transparent_hugepage() to check if THP is supported with PMD-sized
pages. Use pgtable_has_pmd_leaves() instead. Also, check for
IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) to preserve the current
implementation semantics.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 drivers/nvdimm/pfn_devs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 8fa9c16aba7e..457eb54e7ab6 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -94,7 +94,8 @@ static unsigned long *nd_pfn_supported_alignments(unsigned long *alignments)
 
 	alignments[0] = PAGE_SIZE;
 
-	if (has_transparent_hugepage()) {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    pgtable_has_pmd_leaves()) {
 		alignments[1] = HPAGE_PMD_SIZE;
 		if (has_transparent_pud_hugepage())
 			alignments[2] = HPAGE_PUD_SIZE;
@@ -109,7 +110,8 @@ static unsigned long *nd_pfn_supported_alignments(unsigned long *alignments)
 static unsigned long nd_pfn_default_alignment(void)
 {
 
-	if (has_transparent_hugepage())
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    pgtable_has_pmd_leaves())
 		return HPAGE_PMD_SIZE;
 	return PAGE_SIZE;
 }
-- 
2.53.0


