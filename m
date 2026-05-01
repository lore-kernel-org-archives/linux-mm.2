Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACF96CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EF136B0096; Fri,  1 May 2026 15:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C60D6B0098; Fri,  1 May 2026 15:20:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DCCA6B0099; Fri,  1 May 2026 15:20:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F31F16B0096
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:20:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3E1C1C0111
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:19 +0000 (UTC)
X-FDA: 84719816958.02.6DD84A1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id C6488180003
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F4KjR6sO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777663217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xb2/giZWWd2hyINscaxoEoYNnNswP7F4+7wCydf367o=;
	b=6+5Xa2+BJWVC/T1OnITXam3lHQ9eQldE+ho67o2SEVjDeSe0P2EY22eE8FQEv8wZAWDbtY
	lUYXasAvUmq46OXE6RvP2o3Q6uufdq/1HTkOmm5wE3EsbX9bgoQgctRKy9c/dMo8IdpCen
	zUIlE2auPQ59rF5SOf0ZD83qHneDzaQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777663217; a=rsa-sha256;
	cv=none;
	b=xhbSqUh2k9NOysTfsT7t/e1fWrTRTQx+4NfLp51T5DHvckJhGTV/kSBCdT/8WCdcbiKqYu
	qrPfTE4zDDa5cNPi2y6x+NOcMjoxyEiRzaqa2Ok8wkfDNHDsI9f8Nc3FuNODT60RgWusoW
	rV79W2HKmDbt2f5RFPHQtUvD27cTw9s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F4KjR6sO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777663217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xb2/giZWWd2hyINscaxoEoYNnNswP7F4+7wCydf367o=;
	b=F4KjR6sONG9nsD7dffThk2Hpn24LzG0/gzWSjXAnnii+Zkj4YORzUK4jTFNptLz2Alka5G
	u+kMjVlT5qWLB/Qmdf4AlkWQz9xaqQcFSIt8CkTZcduNrfk1Z+ynQ3Jnt/ubtqrkGedqnD
	y2fjMbDUgs+z2GIKdAgSF4S37EB97GM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-7RBVcRMkMaiUK3kM9GQc1Q-1; Fri,
 01 May 2026 15:20:13 -0400
X-MC-Unique: 7RBVcRMkMaiUK3kM9GQc1Q-1
X-Mimecast-MFC-AGG-ID: 7RBVcRMkMaiUK3kM9GQc1Q_1777663211
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F222E1800473;
	Fri,  1 May 2026 19:20:10 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7971D1800345;
	Fri,  1 May 2026 19:20:07 +0000 (UTC)
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
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v4 4/9] drivers: nvdimm: use pgtable_has_pmd_leaves()
Date: Fri,  1 May 2026 15:18:46 -0400
Message-ID: <080c40bdcb145bc9162503a3e09144d444991770.1777663129.git.luizcap@redhat.com>
In-Reply-To: <cover.1777663129.git.luizcap@redhat.com>
References: <cover.1777663129.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: Fy8YYs3JS5vEAUwiEiX5ObBO3i92fHjFbCqsVaI0Tk4_1777663211
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C6488180003
X-Stat-Signature: 7zh5aoyy98inx83n9c7hkusuy59ng4n4
X-Rspam-User: 
X-HE-Tag: 1777663217-176419
X-HE-Meta: U2FsdGVkX18fBiyvJjHeERhqqRe17Fdorw260UvSJI/CgdSeZBtej0fJGByz+P6uRbsW1Ol+v9oluDseKWzCH38QDmr50OjFdCmCvTYjr6RDqUX5RseIxZMEFQ1R1H6DJ8mo3K+S6HiilyfdMekIkCjml1H2UkGV9frWjEoSXXEGW40j6MrMGTp8Lk78jIZKUXgp/Nw6RCd65g6jZ45SPtDp+CBGIaVmihojy+f6aLyiG6Oxjmzw7qNguEV5go0eaW9VINJILrfh3sPpjLdgy6ugfXailp+jSc+N6whJ5mcsiISefAHTmf6Wv6/XQDi2jbmzTSUSqV1aHMkXRzfknjrVtRHpumOCCC3X9dGwBKhWGFvp0B3i6aQ3R1LiWUejwWCchmI24HY6cBT5odJTNieyKHJDoU8du6L4XA2JbRf0ladOWDYq7jATEYD9X0CCxJjQfn5kkFG5V25Ph+zee+hVI/moPXmgqkBrifw7yFCwCIOhn1WHcBzOSYkspgXkpxh2zEamYn1ZqvAa8BVCVhdNg/fjXdG/4ysFQWJlJGWdvLPtkxKM7PFhq60KTSikPEziqFi127nt+9o1pNRZncmfaKRCE689PSNNNPLfGXQw8UdKYWlp0/WyAgMEagQyjpfYoHKK5YqNSPiUoi16Esm1YXFJauolDOi+HzTxSjXxGQ6AbApqa2fMsM4SyrlaqEQSRMugKqZm/ZjqBd8jiEejMglLoMbYjJ12OPyoS/+2fizz/416EdCNWWp1k0LzuEm08YtyGMyyFOc8mTrm/8y1p86VdS6qxi7zq2GtdTyo1Vm4XZz9/4RaCQ8xBSkuybfcVWYDPybVjO7kUd/6dhb+B16xV8gQ8TgYNYoGk3DKJzYJcSnAvDAb/wBEC3ySwW+f6vvUfIPF6m1fZ/BZOnS69HShU+q2IcLNF1bhHKfd5JDyL6aVdA3Gr0CyZFXwa1G7Qo95c/NL/ihudHn
 bp+/zP4N
 JyeA6FBOI3NAl4eixnWCORc56zkJBZ8cAp30UpnV/7Ba1TADVLHbhoxJMXujAPcAwGklxmo3g9XrLuKfagsnj/a0ZloFs3fjH3bF70wjwRxAtL9KzZ1VPSke2XbjMV6D9Y00mx5xEDhxbSgTUD6xE4pJTBvXRXXpcYHm4QRIP88HQ2swCKczGu7r4z3Uh8RILAzVOs3vSNNXlZztZR1afj/v8lI46R0+zXQ63om3YUr9eM1xFNIqybMTlPCRY9y8bXcHmox7xl4UbRWrV4RyaL+zcJeZ6sRxHvSniYr7FrKg2nvhu05LTdgVvGc5TS3w6tsYY+NA3BQUwZLmUBTanjC2Se29EaUPf5Hmfbz5IHkpS0Hh/ypktrtlec0LqGacmmQi47opEQaqf+1dkr2qAngKvNXyt6iX/iIH3
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
2.53.0


