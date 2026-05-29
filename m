Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3859CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:56:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CF7A6B00A1; Fri, 29 May 2026 10:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57FCB6B00A2; Fri, 29 May 2026 10:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BCD66B00A3; Fri, 29 May 2026 10:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 406646B00A1
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:56:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 079301A017A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:37 +0000 (UTC)
X-FDA: 84820758834.25.8798272
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 167A51C0007
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JkZ+wCM0;
	spf=pass (imf21.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066595; a=rsa-sha256;
	cv=none;
	b=NyY/gknxmSyAsuf3EM1AzS2s8FdRMHoX1bO33rDrtqIhE1B1jcNKzDEEq0E/ISX1j++IQH
	cpVmcd9YClEscH9aCI7d+h9z5GEsn1FXAjXAxOab5sqMTc4xV/bAX2dS83MU53fLLQn9cw
	fwwofbWLk0TVbqjDJ29wh+udSsDNkLU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JkZ+wCM0;
	spf=pass (imf21.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4VxSoCgoG5hrWIY9am8cHyppM99fTdgWI6dpfZI58bI=;
	b=vINxrT6jTVmmchj52X0EJJ9LC1khTrQ+JUqL5CmPDERbS0xMw2i5P3lej3N3i1rRkYjsMj
	gY8wlSuh0NetpJ+6dOtPtf6OpBCEXuohA5EXyOfj57rqI4XsFRoCUkE/dm81MY0XIoIsJ6
	M5EIhqjstF35tOWnOjGLb7l/+/BzmCQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780066594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4VxSoCgoG5hrWIY9am8cHyppM99fTdgWI6dpfZI58bI=;
	b=JkZ+wCM0OMMBc5F+onQMBx7pwbPz3ML94Wm4d7N/bYWbmIImHVrGI3bbT81IxPWBIcx8Hg
	fs+gsuXUmeQz4KPhV0jw7jXinJCLL5M8SBbBvIu7Y2m1P1CvnVTF7GbFmDoBb8iOv5WLqo
	dbi8hG8v5tsbuW5YY8s0h0dY3X+b6b0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-500-GZaLapEGOM6rD7SgUUr7yg-1; Fri,
 29 May 2026 10:56:28 -0400
X-MC-Unique: GZaLapEGOM6rD7SgUUr7yg-1
X-Mimecast-MFC-AGG-ID: GZaLapEGOM6rD7SgUUr7yg_1780066585
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D016818002C8;
	Fri, 29 May 2026 14:56:24 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8FD053002D2D;
	Fri, 29 May 2026 14:56:20 +0000 (UTC)
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
	ljs@kernel.org
Subject: [PATCH v5 05/14] drivers: nvdimm: use pgtable_has_pmd_leaves()
Date: Fri, 29 May 2026 10:55:23 -0400
Message-ID: <b6e97af337d4707f66be1a61245d745d03d85d13.1780066530.git.luizcap@redhat.com>
In-Reply-To: <cover.1780066530.git.luizcap@redhat.com>
References: <cover.1780066530.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: G1-39wPzUnB4HmDrQwpOoWGUoIFjkgKV2BUPWzFM0Ww_1780066585
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 167A51C0007
X-Stat-Signature: cmspu5qj4qu75g3x71dbgr3zgia5baxs
X-HE-Tag: 1780066594-836820
X-HE-Meta: U2FsdGVkX19sqcsi0L8+aqLVYYXNqStm5bF21sikQNTe7ssNEKzheb9w10PE23R5lANrH1uCODxaqe+kONzll7RTEcMDux4SerZfAQEFt+ytq7BkaP7p/BZhzJ3NXHkI75o2XdNMhkAJwUuvdDZ5vaQGXeNwSFlKhV8htPqe91Dkh00sQ0Dxp1cXeGmpinDmQjYns42aGN4e1srhPS/ri90Gb47WqIpEMeyMO+F12agh5P319wEAW9duH5YKuoiBdjb/9r/u+hncLNYrt3+0YHOzTHtIIFagR+tpnDiXHCFoo1YGEqB5kzJHeSGbJJ32cXoCF/lkbu7VFrDwhSR9BJqckYZ8+yUfJ8OfNGjmzd+tbeuEqqY7RKFHELoKaVu/rMVvgA3jFChUlIS9T3DIAAZPohq9h+QhfeRg19+SOgq7NgqypBmEoTFrMJVInfk0ehyGrjoad2jRCF0K7H+8bblUELHn1zr9IywFaGz3qdNK2ZlNi16x82aUY3verxsSn4hRVuoChyFY47TNon73kavbvjOM5CB3XECDjMtYptf/hHjyPoaoSQAVCb2Ut1G376R9gmxd5wWC8auIKvx281fHe7FGxIJ9og4jK01xG59RzN7miKzWzGb0/TeFUPa58VlLfcO/evgOvQEtoQJ+HaMkjy1y6IhAOxY0QVGFP/htRz3ccijC7eKWW+oOjunThEQtw42AUcMym+pPaUKdm9wBdXN+pU5KVkjnkC+RTQvXKBh/A5kQnQJlP7j6nvy4m2UuY6kcIIt1y3vsAF/8oALZqsrdnaAAOIB1Ghu0M+FGRT1go4WJYbPYSA7hv/Vzx/icZqCNLlaHGfaf+T6fH3U+GSld2ZiOtNePZxW6134ccsOVHPGZsyW4Bg02wayDFmLAMVD4RKISRjjFhpciKl8Ihakd06Uo0lt/27ctcewp9VkSl4V/qe8a5u87n/+Yj6Sg4xfVKx6jek4X0gq
 qUQGN3RA
 92E6P/IPZ1B9rdic0opFpRS84z8oabDkpUZp+8cTHq6RzsF1cndWUrM2pKid6F1gDcL4yN+Iqo3SuYecONE6tLBa+rC/hjDpj2rwA3q6Vt1nt+kz97dzPwNogGHxMVluF72H5+ASv1MlXZ4Fq7K76LJUVtA6keLVvIzpjhI6IoBSvjTPc47s7IkpVCbrD0TKygZaQt8y4b2kM0wP4D3HAN6EXw1bGzMk8KWW+urBK9c1h0z7NV2NSZhnVUU2+E4PljNe+au2titsHqNoj526nldIupw+G4+g9PdGvv5OysAwD7FfjKJIzjXkLTIG6Sr75PioPz8zgujXP9tQXGfnm4Q5xxCwC55qZM8unrzfU+IRH9Mj4hHqXnTYucPJ2bRpMRu6TMwNf0iKlm803L/XdjLBg2ab/RkMouQLg
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
2.54.0


