Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F92C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 01:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FEA96B0098; Thu, 23 Jul 2026 21:35:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AFB26B0096; Thu, 23 Jul 2026 21:35:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C5946B0098; Thu, 23 Jul 2026 21:35:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 93C536B0095
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:35:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F3BB4025C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:09 +0000 (UTC)
X-FDA: 85021951938.10.6AF9078
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 43DEAC0006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TQuD1T99;
	spf=pass (imf28.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784856907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vWKt08g60DdFG3Icxm2Us7CxOftu08depFwjwgt6DxU=;
	b=wVU19eNN1tuMT8uCifFl+myQ5DZF1nDbbAQvMPxzOCv+EqByyvP4Vtqp/6h0qQz2TCCCr/
	ZNKGtoiwbN3XauaSmJcK+ayQoAKZEk/cl88gONTRBcGDDElBhvVNVoMU/PoaRD4uAl3DH+
	llLgn14JO1ro5fcKeQHAy5HVvGii7+I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784856907;
	b=FmYDMJQwhZcYXXpAdBojGKbcF97cDY0DKg6/2PTVLG7+MTWuo1rK972NCOKuRLhfx4u+xd
	cTvz7Q9QOgUmrNqWFKeFlL9cQhO6k9dBAaGg3/B62ZsH/G6Xobn0GhHYvvMg3jYMldQiWs
	n0IUCzmDSQtHhmLZaAxvjDdw6juQLsk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TQuD1T99;
	spf=pass (imf28.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784856906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vWKt08g60DdFG3Icxm2Us7CxOftu08depFwjwgt6DxU=;
	b=TQuD1T99utDthJlB+3dFkMRpeB44CJPN3JNwkirEHYOQwc30NNi3yu/HSVKlRiUf6dfAwC
	JEUh+iT67szBwa6gf8CqDppYOFClkMqdtu2VJGCz9gPVd5ewXiRymSHU/ufDbVc4guIXfJ
	x1cY5hTkueaPlZUbiP78lXzxXsTg/T8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-279-cG1cyqeGNnapWIvwGoKkEw-1; Thu,
 23 Jul 2026 21:35:02 -0400
X-MC-Unique: cG1cyqeGNnapWIvwGoKkEw-1
X-Mimecast-MFC-AGG-ID: cG1cyqeGNnapWIvwGoKkEw_1784856899
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7644D183130E;
	Fri, 24 Jul 2026 01:34:59 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.238])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 59A301800594;
	Fri, 24 Jul 2026 01:34:55 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	ira.weiny@intel.com,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	ljs@kernel.org,
	dev.jain@arm.com
Subject: [PATCH v6 05/14] drivers: nvdimm: use pgtable_has_pmd_leaves()
Date: Thu, 23 Jul 2026 21:34:09 -0400
Message-ID: <726742b1d017f569eaae3df1a543a18aed290988.1784856856.git.luizcap@redhat.com>
In-Reply-To: <cover.1784856856.git.luizcap@redhat.com>
References: <cover.1784856856.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: blpiqLb3k21qua6R_XmQigRuXSLj6fN9u9hDKxVAbSs_1784856899
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 43DEAC0006
X-Stat-Signature: ro6pq9odawm8tja6ffo1rr5jgnonihex
X-Rspam-User: 
X-HE-Tag: 1784856907-772758
X-HE-Meta: U2FsdGVkX1+MclAP24sSeqPj3sZ9pFs+11fOzZyc5oa6Bt3NhnLxT9HVhG1MQE940Fit1cosH5Gb1Mq49sfhom5MFDcB8az4olp9HXItB/EFmH6lCiObWppiPtylJvKc92Q5zvaWkPdbGiKe8oLfbrRZ2mqECoIzoscG95dzmL8wWVInOVRi0GyWkX/aPfZsBcHvu50e17ExykyNrhYbhtFq+AakPfLR4+AtBWGRMRIlRUg8OCUzFYcD9kzbSQK4j0SPTNY1LZ8K4S0fEPHCf7KikmtEEmU9v9ZQh56xNyRwbD6YWYUGW0URXbGaNRtGuWGtAtnFCnjoG3j+tvVuJumb/fdmjCN+iEkY/BKzKb7vLK5oNz+0xDaX26BdY317HH7oCtFRzLTb77FR9pVenKwS6PRbZmzCq1qtGxpvWazItvCV4wDhKzh3bcENrpcFtvylwY/LnNoQyVPwYE/FFKsyhFlYutWslo+IJq31Lkh35ah5rZCR+pQciSuCohWwEK+4ZzhUcAceISTCW5MDPcNuM100BADWRvdk+C9iSC4Sx0psOZlB0tQF5T0xd5Q4P3PWHpbzs3J1pwtUtLYqimCfeXtKFC0etkL72/gacqcGL9oKiiYv4+yt+xe/Ouhbm7ojtP/hMr9GI6djDQGb1uis2uitBjmusXpIoZKHpP60d/XizrJhRtm+McGUw60rMINivnAUgdsZpWptVXF7U8bswfymRusbD4kSeZ03w3wNZ3hXuwb0paukZRnroM1bP3DFTx7V8EYjg50fQc5A48zZ6MXtEL2Vyt3/wBIgEg5GZ4FoU4s1yi5UVYEpYFoTNDPz5tIuIogAImngM9uBG5/Im3yXt0kiUtdPbTe24ZcOD5B3hMcMazPKaC8CGGcyPdzw0M4LXM0Wcm855Ks+d+dmJY1AYCj5jkHse5uRX4yYDnNfHHla4rJCV0VRYbIkA3/rJOB5cCqWMQmDBPg
 YPIsoDIf
 cw+3cqYrdH1kNvcFkCLM9Q+pQ7QjUmFIhe2b0qREEDe6a7wTHfxtND+v60+cN1RxHzHNoHnAk2Q0d4Qp7hXm6K7PSKVlGe7mZIV2RIdkac8MI29q63wPNwSlgcSZBRzuQzqmBiuCJ/M1aBc+bew+jbafRK41F5amqgCVl4DgjS2aYRGdT1CztNFNjY0o94A7/LyMDrbWLe1ZznGgb39CSuzYPNdrmKUG0QYjvGomNBw2MO2zeb4zh+lHmIAmzx5lRNynJTCLDgdgfjNhWDI4iNI+nJeTnmmClx5/P9QlSkGr4i/9ojtQDVvdziPk7Q/CcNuEYDBpcSabAlyVa2q4iBuxDSkV4E60NapLYTysJehzERDJASnLuzwU3i0I6bCPpsHwtWUP2/exlw1//usBgkzIbj8XQH8Ux3FbH
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

Acked-by: Zi Yan <ziy@nvidia.com>
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
2.55.0


