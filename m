Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40738CCFA13
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 21:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813618E000C; Thu,  6 Nov 2025 16:29:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 774D08E0002; Thu,  6 Nov 2025 16:29:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B2158E000C; Thu,  6 Nov 2025 16:29:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 50D4A8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:29:29 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 082BC12BF86
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:29 +0000 (UTC)
X-FDA: 84081473658.23.A585DA3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5F4C6160002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VrlA+tye;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762464567; a=rsa-sha256;
	cv=none;
	b=bz+dsfoM338ouLg/e0N/M6TeNN84LWynnVjauBUnUsZSHdapR+FAYKfJfwmFKbCLwwKDOD
	aGN7X+1BLHlctgzpFZGiq35AFn0vqd7/NCKVonN/47tG0fEHFq1kFfUkZiZqz4VXQtdljz
	jnLQMSOP2U78O93VS0hoeX7iSsmPWQI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VrlA+tye;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762464567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6aaU6mqv/vvlvKAVhD0kXqB0iQKKcZ1RnoZvi1Wj0RE=;
	b=oOqIDeTNsfXvTsUb3XLJUKam87OvNdZJ0n251OZvGpzd2OkYrIt8mVNx/0sYKPw0PdCbrR
	Z80E6WTJBbAdyf8UoxNXoZARNWh+qiEvZlU7T2AN/roatXi9hqnBLzI1Bx8zklJaNRaLGS
	YQFRBLkT7f7fUZ5AEUkI/7m8Q0AgsTc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762464566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6aaU6mqv/vvlvKAVhD0kXqB0iQKKcZ1RnoZvi1Wj0RE=;
	b=VrlA+tyeCedsEBBquJjkZBsRHZTRhImkt3ipAWR5SaZFjuqRHXB8UAzX5DgVuv3ZTq+LzG
	nb3IjxKw/YJLAPLHCxlsAyysHpsQ3QYppUYPXqMRwsdnpCUniTE5IHUUp9gD8vBnAUMhSO
	5kL+z58uadpMlipVkEgNtyelClPV+kE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-444-V2B0wT2pOM-hyOkBya2dGQ-1; Thu,
 06 Nov 2025 16:29:23 -0500
X-MC-Unique: V2B0wT2pOM-hyOkBya2dGQ-1
X-Mimecast-MFC-AGG-ID: V2B0wT2pOM-hyOkBya2dGQ_1762464562
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8EDF1800371;
	Thu,  6 Nov 2025 21:29:21 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.101])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CD14D19560A7;
	Thu,  6 Nov 2025 21:29:20 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [RFC 05/10] drivers: nvdimm: use pgtable_has_pmd_leaves()
Date: Thu,  6 Nov 2025 16:28:52 -0500
Message-ID: <ebf1b2e8e16e7bca4e2ae9b1f995f314a4697a34.1762464515.git.luizcap@redhat.com>
In-Reply-To: <cover.1762464515.git.luizcap@redhat.com>
References: <cover.1762464515.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5F4C6160002
X-Stat-Signature: ieobdq4y911mpx7h8nr1nygg5hxscxzq
X-Rspam-User: 
X-HE-Tag: 1762464567-309397
X-HE-Meta: U2FsdGVkX190CmDwqwkT7Dxkykvb66Fo7tvcxkSiH2t1NhMtW7VApaytqxxmpADnkk5bbyU0v0gNpiVwuQzMfg6TcpXgUFysFfOtfWojG9cENq+ztor4fS+VMuF4Rf9kog25/E/D3ya5ZB1Y9V/y3noNsh0Km4AJquVeFAitMIiwMVwREMpuYjtuGPspiRiOXT6D6RauuUf6mPc0PlmrhhXlWAS4tL5tIZiMi0Yq69NxwGRt8u1A1AiVnpBitM+opRJTEyyTi0onNBGnh0NdneziMOjuuDbHmMW9/WUjg2NGBzgkAhpwdIi141texmkDCTPm6vaNL7tLIEdDXzIKxALwgST3jMvDla7BBfrkmn9TvbzvavTC1AVEAouRmkgpdyd6BMODg2naQluLqAHtHtsnj26PpwhXBnm0sT9xCS4uubM81HhhiHC588og+RgoIzedLjAv3RIEowzqxN5+/CBDgo4BXWOjshPT/kRP+XMNP6nEOny4DKbErYeuLOPGT/+35N1eY7K4sj/JFhnvLID5GVw3rcj2Yx1KgLhbOEMGImFm8Rj963lVhZSR6oM/BgBT5SbgGmhtzXKU5DQAjAZamF3AvfKssncI5PcArFiJIF2cCEQythGLmjDcnqn1W0yCwqRzKNF9VBSjaRQ6OLMt/xNZjRPSVki7P/Pj9IRGssHQHrzi4LRWjioFt9E2EUjqPh2rI41uwECIpAZSqiVW7Yjhg+nbWUbHdCywM8xqhQFYgQPL5+khdXEUQioUJIXNYVHe2aFfn8Jes42DB0pMpmM39A32nswJA+c9KHtfhPOk1SdQ72gnXDl2XnZCT8HrJhmS6N6UNB+6K5xOrKFqQ8maTt/5h6vSK+iuaAEoofTglEd09/CWOGw3LTQ+KKdXZrlP2pRVWC4/DcVOVKERP00XAbkQpKbKjCu9WhYUCR1GKO0/M0DDUIjvuoVM+YH6HUdFDSCGV7Lbrvg
 CTOZAtFP
 DDX50yAPx1rB0BdTOAhRi8VgI/6nMae369TiNMNvkWQOP1KrnuSKu6oxcg0tYY1wgm4cBohYyx4sXEhzROwYFTmZ7eoEguwIG56CIub9HIuagLFrIpG9SbngFhySJIM3M4ENsNTfYuL/R8ZYm8CRoc6wmfVnixQap9a1FX1qpfsRpqK9wn54oRaeenH9bkzQB4RcjWNWOZ5EcQw7zttwedB8tuSydnRsxxEGaLsnRsGN+VoSeE7oJxsITKkVcGMAiSYyuNPYv6mD1rAtcZT8BCJRxoDLdSEAHoO0p3ZdMiXtT85mEtyJYJfPT+2h+NRqHeHPt2aTz/w7qNO3TOdEPXmDJzfpx0F8MguKONEwCuoYG34dBTslMqugBTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nd_pfn_supported_alignments() and nd_pfn_supported_alignments() use
has_transparent_hugepage() to check if PMD-sized pages are supported,
use pgtable_has_pmd_leaves() instead.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 drivers/nvdimm/pfn_devs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 42b172fc5576..989f87f07e0c 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -94,7 +94,7 @@ static unsigned long *nd_pfn_supported_alignments(unsigned long *alignments)
 
 	alignments[0] = PAGE_SIZE;
 
-	if (has_transparent_hugepage()) {
+	if (pgtable_has_pmd_leaves()) {
 		alignments[1] = HPAGE_PMD_SIZE;
 		if (has_transparent_pud_hugepage())
 			alignments[2] = HPAGE_PUD_SIZE;
@@ -109,7 +109,7 @@ static unsigned long *nd_pfn_supported_alignments(unsigned long *alignments)
 static unsigned long nd_pfn_default_alignment(void)
 {
 
-	if (has_transparent_hugepage())
+	if (pgtable_has_pmd_leaves())
 		return HPAGE_PMD_SIZE;
 	return PAGE_SIZE;
 }
-- 
2.51.1


