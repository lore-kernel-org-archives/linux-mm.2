Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8607C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09FBD6B00A7; Thu, 17 Sep 2026 21:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0501B6B00A9; Thu, 17 Sep 2026 21:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5B196B00AA; Thu, 17 Sep 2026 21:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B72FE6B00A7
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:47:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3813C16052D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:47:03 +0000 (UTC)
X-FDA: 85225194726.17.3CC27DE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 55FC180004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:47:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y003xGrf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y003xGrf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789696021;
	b=vCXETwIBu6Xc4CdBnMH31uhyI0m6fm2TSvy5+zEi5AaKqb3r4dkBiDPG6rvEO9j7Znqhpx
	CeeCr3FFpiP2OEX9dEB4xpfwAJetD2cjIme1YIx0+BCOFbzlZaba0qb4a1VLv/+gkvox/a
	S4hsD6L1cKroyatzU6DRBBe11zpyIbU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789696021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+SwbXafA/LzvEsihFnCIkLLRdyVgFILRogRhCudaRI=;
	b=x5DzXuha6bxUsYdXgI/qRpHp0tqshX3PgjQbLnQZQGTn3Em/3edbXq95Whm+/Zi/K6BdhM
	X0fMO6kMUVGvg9WphIKHAMIxGD9k75OSSED6eDC5akQwUxgv1ZiuNZUWVuTVgHPpb6UCMU
	VuLHAj6LeFUw+mqjwumJk28FrgLLCak=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789696020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z+SwbXafA/LzvEsihFnCIkLLRdyVgFILRogRhCudaRI=;
	b=Y003xGrfWdlKRWXtjaS0RyL/jM5Fc8w4Pxc+jA4jrYIDA6Yk4fLkWuvzT48PB0lGxBEGRa
	LoFWQ/Cnh/RvhK8U8c2SEeqUWJaPw3E+M0P2jvyZ30hF0sb8+OSKyUFf1bghDjfcwCw2Gv
	HWYNupR98vhWULxnQJESDt1/l3WU+Q4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-351-eFioUMoYNr-kZDjA7b9DMA-1; Thu,
 17 Sep 2026 21:46:42 -0400
X-MC-Unique: eFioUMoYNr-kZDjA7b9DMA-1
X-Mimecast-MFC-AGG-ID: eFioUMoYNr-kZDjA7b9DMA_1789695999
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A16E195E906;
	Fri, 18 Sep 2026 01:46:39 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 51B8A18004D2;
	Fri, 18 Sep 2026 01:46:34 +0000 (UTC)
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
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	dev.jain@arm.com,
	usama.arif@linux.dev
Subject: [PATCH v8 08/14] s390: move has_transparent_hugepage() out of THP guard
Date: Thu, 17 Sep 2026 21:45:29 -0400
Message-ID: <a2c5f62c812afa5b84ef16476efc99281930c124.1789695931.git.luizcap@redhat.com>
In-Reply-To: <cover.1789695931.git.luizcap@redhat.com>
References: <cover.1789695931.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: dwQ3eQclElTXqlO4fmpEs8PmWLOltateAAf2fV5NJS8_1789695999
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 55FC180004
X-Stat-Signature: 91g63muyjoo13u1zptcyfuegypcxtowf
X-Rspamd-Server: rspam01
X-HE-Tag: 1789696021-697638
X-HE-Meta: U2FsdGVkX1/fVCXXRsGwcSsK3k7OEybjhsIdAFLZijdQ193dFAySiSqmu0mUdwROBUqIxH+/DAtIaIArJ/ejCC4Hf+Hy80qbL6wxE+M+knQzUY3kRedEo5zCX+6dnbPJSdO+OPKRO1spBg50bU73UmpPDvVALtjvRdDApNhcF9NUmq3w2AUzKY4YGJ/uUklf8W87WcCzapw/VN+ZwPJtWF7pQnf2V01+2pKngEIhrMmm3DMXvJSWCFB26BEbe/7py07WD2zzPUpO7rNZ0RfbKcILHU2mHcMsTp+OcI/lZHr12O2mX4U6a5AIlrInOJ9/+iPHCg9HJqrsWV0U13dlcmpmFVnsC7xGAXDXHetJPUTMb7sv6XTMH3Dpio4wGP2G3PYWfYy39EGYWZ+MgKq+9HqddZthin1P7+jg8Fn9n1hd1yLjFcc4aGon66+x78DBP76nOCtLzYufpsMqh0Iu8s+qzbPB4kzIH9jsT7qSYW86ev5MGOMMn9z/9QYf6Wzkkyl/P/FwFo5IlgxfH/xyIl1J9kIDcLnyG7egzHnE6wyEETzuLAQ6xHrZ9LMWCWMq95N6abu6LHBjFfjR3oh6hzOBmHN/vbKaYoz3zb/FhndSun0nP4iyjVANvFzXJN+w6Bf0U3Ah5xPVkmwycc7OwMMUUhyxTWSkbiujqh/SjBZj/+k61gfm7tXtm19KHuvviG7tLPTZHanlukMhv9YSAcHJA6SM83qD2or2Fhvav6h3d6Fv6hpXYWMxF7Wl2HSZHXZ7BNSW+Pj59zMxJ3IGiX4OZ2KBhKHVnYNkmO9aefscgkFoQkDwxTBzS5GXEBdf/fNZuKQUuQcpM0AyLiKTtUZ/LMkaRNsa/35P9YRTzsnjoqoFVnRrIKUI9R1BFUvtGmM83hFqvj2V1O/36J3Ss1XKUUklAmvHAyrNwHNgv1FIoau5SUKzMo8FVT9nEHPTlLv3DtJuR7QN2GbYgf/
 455K9ZfM
 LDsMkrIBWWDM0va7kUTfGbx0TiziljmasJUPVAl4kPMHE9wpPdbFHC4IATJkCIEI8vqk551HITIsCjK18siFyJCe320MDYtc5n2a5k0OKm4jiE8CsGVoHCWE1gWY+jXzYwSFmV896s4MV1ygu3VhFZLkoN79Fk/eRec9/HFtkHsUKXTKPrMfAHbxdWRVfzokxtHIRNAYBut2+Fw/xYAqaRVLU7w2EzWFbgfosVXmdqvF+i5NmwYLKlt9dMw0PiH0zV83dz+o7VhToJ6qOC/qzIWwhh8o/KRXH30j5orDB2CpDcAbfrjhQRsg2zPAWMQA414+V8AJ2GSmgo+jJXtm+UhbErk4pcSutYPQ4Amd6Hl3bRUf3ECQFBh8InUCXQlv7gcMcpnlHXsB+64E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future commit will introduce a kernel API to allow for checking if the
CPU supports PMD-sized pages. This API will be based on the
has_transparent_hugepage() implementation but will be orthogonal to THP
and therefore must work when CONFIG_TRANSPARENT_HUGEPAGE=n.

Move its definition out of the THP guard.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 arch/s390/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 2d5c2ab06de9..e7a2bf9636b7 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1814,13 +1814,13 @@ static inline int pmd_trans_huge(pmd_t pmd)
 {
 	return pmd_leaf(pmd);
 }
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #define has_transparent_hugepage has_transparent_hugepage
 static inline int has_transparent_hugepage(void)
 {
 	return cpu_has_edat1() ? 1 : 0;
 }
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_PAGE_TABLE_CHECK
 static inline bool pte_user_accessible_page(struct mm_struct *mm, unsigned long addr, pte_t pte)
-- 
2.55.0


