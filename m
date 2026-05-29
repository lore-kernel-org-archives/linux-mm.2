Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 147ECCD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18A956B00AD; Fri, 29 May 2026 10:56:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1629E6B00AF; Fri, 29 May 2026 10:56:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0514B6B00B0; Fri, 29 May 2026 10:56:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE6B86B00AD
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:56:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC72A1C012E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:52 +0000 (UTC)
X-FDA: 84820759464.15.9A01995
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id CBC381A0009
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wu1p+8nM;
	spf=pass (imf19.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lafIJpVydn5vsyyva7GmDD1qL9lBbQkA7qOX1Aog4pQ=;
	b=pQNDZkzrZzxsR++12KJhakvElyI4Qi5oJ/NJVisE4RuPscD6xAppc/q2/81AyjOW5Wwadl
	1DkKinLouKfsFoxZGgUUD1rpkIchuhoHc2JH8SkFmbYiW9P8c3n/mrk/08bz/SY6DNmMhG
	zEErdVWJULb1Dw/LGbDDbBiJlaTUUzw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wu1p+8nM;
	spf=pass (imf19.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066610; a=rsa-sha256;
	cv=none;
	b=Bakgo20nMTkra3U8b3HaG7THLFN85te4soQzL8cbnXemjzZiC4rkLbhgmYKIpR/VlAitUk
	c5uAeYQM4Zbs2lmmEJ6qf3oLJ/qjBbjRlVXCv4LTM9GKgw6nodg4ha2LOWiGCG+wr2CEcw
	7JLNnR5NB15IMdPeCI0yAf7guA4a6sQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780066610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lafIJpVydn5vsyyva7GmDD1qL9lBbQkA7qOX1Aog4pQ=;
	b=Wu1p+8nMq+Oihx7dU7HfcWVEUYVuLgNHZ069wPyo8h21FSQaD08cLy3N3+Rm7oSNzwa2Ru
	wa7GUEqCCvopmPFB1tjaHOXMIAq3RGuhDRWNfPKf9rix9h7NLRtpuXGiz9P61xhgOkrI/e
	aUdGx+JN5EF0Xj0Vw6PO8PtI+YQ7KoA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-496-t5cjNDv5PzW9IZg1_L0_WA-1; Fri,
 29 May 2026 10:56:47 -0400
X-MC-Unique: t5cjNDv5PzW9IZg1_L0_WA-1
X-Mimecast-MFC-AGG-ID: t5cjNDv5PzW9IZg1_L0_WA_1780066604
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3ADF19560A6;
	Fri, 29 May 2026 14:56:43 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4E04430001BB;
	Fri, 29 May 2026 14:56:40 +0000 (UTC)
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
Subject: [PATCH v5 10/14] mips: move has_transparent_hugepage() out of THP guard
Date: Fri, 29 May 2026 10:55:28 -0400
Message-ID: <1e6907a0b125c1fc022f03b1085356f1c27a86f2.1780066530.git.luizcap@redhat.com>
In-Reply-To: <cover.1780066530.git.luizcap@redhat.com>
References: <cover.1780066530.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: SOD3gBDEsamyBR6GftsJT_v0HdS7VQm2kr24eEz9jTo_1780066604
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 8xm8hsmmpdmpougzgtz9ib8f6m5h3d1p
X-Rspamd-Queue-Id: CBC381A0009
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780066610-275956
X-HE-Meta: U2FsdGVkX19uNY52fZEG2ovr4Zs1XftLfXF8dGVKPuPL93uzPjlZQMdq5eVCxRrI1u8klwZI4i7qNMmz68gy0eWXUYX2hqOOTYEn70onegvi4aR7RppGOrbBCjYOfo2xjnjGj7WsdwOHkBaB8XVBVwpKHnEX0WuW/UBznjWfC9lWHsp6ydiIvzzPdMkkwLPdhBnGeF4/NyHJphOf0eJAx9JR+Jdwm9WrRM6/5AucCk/088vkvXQ+b9CoDqZm/BhZ+aocM9L9X4wE51me+2ONKCg30A+U3F5oHMX1uif4dQDAJhBYyGjGdmM5D0mzyEOFhXD/1o5dfl6d+f6667RQ0c4hLIZ/39NEi1GR1UZhblLh/MHd0dGNkSl74xciqnq0EUiBTcFJaEz6RBeQmLJNlDpfAkVq1G2zaqn4we692Pd6+6C1tdEtKZfEaLu9Baz5o8KwXQpdaKCslJ7O1aqCqdDDPaJFXU4hU5KF15B85gdtQJXlAPZtFc/WsQvWZzZlCtUBfH6D9IsXqEc6r62Z8fZGbDf7l90kq7zIWT1mcGfE6g+qm3KKDotmGrMxRBBrsM0OEQG4YjJ78k7lsLXLgitmq24lRXQ9PpAjfnJGjRUdKJ8F+SVvCDAxwRUQ0p7BXJ58MZv2QKXxr4aQA8lZ9IjrDIrnNk5rOhAuLf/yBJuwX8hd0v79wAfOO7QoJRMv84YJT6sCP0mP6YiZbykI2+myindFyfjeRVcBNtWw4dmYSo2VALZZy4lxrdfQDQwW1KRzumb7mlJTSjGSyHITF9opuyEd2fNQed2iIACrDyzAbgRQ2nFGtNVSdx8k1TldONcPtAjcFnl7jKpF65dmAjqRB+KJdWl94hcvWIwBfIU5DdXoZsLtC1BN5BAWXb8ZsapnhCtZmnIXpKwTciFsLooJJ71kez+ZyzGBp2cayy82w8/UBGciffrX2b0w4g9Oy/GzsizCKciGWX2k/uq
 xGES6HwK
 y/hqgUxyd0P9TR6/ar3DgSip9iCwYuIV6alihGunkO1GKh/X2TYSiOu1sOlkOdNzYPeRCKfH6hltDpBFGTp5dnZJvnDVa4F2yvZ44j8h49vWUH/Q5ImQ2t8oqEBaC7XO/IpacZbqbX06syt8At9bbNS+iEaMDd0rNhcVXtcEmfZj9H5mBljGt6+ldJo70vmr72ACYyoPkTO3hnLRfTE7kuGAU6CvlXMIn4NTe6aPbnnnicky+ixmLTwX1UY6gkoIXVTrjCaiUvc2TAxcXJ1IDbAwDGt5VEwjJ2YZonjCtAm3Fn5uYygRTr6ZBV65af7743iY9e3+f8fRP5gmrcx3r393SygsBkD9KPBUQOV8Q9+uJjnPBgMkKZZX4BRGTOka+stsqtW50ADAR6us=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

has_transparent_hugepage() definition is guarded by
CONFIG_TRANSPARENT_HUGEPAGE, but there's a need to use it when
CONFIG_TRANSPARENT_HUGEPAGE=n. Move the definition out of the THP guard.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 arch/mips/include/asm/pgtable.h | 6 +++---
 arch/mips/mm/tlb-r4k.c          | 4 ----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index fa7b935f947c..b038da872ec6 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -615,9 +615,6 @@ unsigned long io_remap_pfn_range_pfn(unsigned long pfn, unsigned long size);
 /* We don't have hardware dirty/accessed bits, generic_pmdp_establish is fine.*/
 #define pmdp_establish generic_pmdp_establish
 
-#define has_transparent_hugepage has_transparent_hugepage
-extern int has_transparent_hugepage(void);
-
 static inline int pmd_trans_huge(pmd_t pmd)
 {
 	return !!(pmd_val(pmd) & _PAGE_HUGE);
@@ -743,6 +740,9 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+#define has_transparent_hugepage has_transparent_hugepage
+extern int has_transparent_hugepage(void);
+
 #ifdef _PAGE_HUGE
 #define pmd_leaf(pmd)	((pmd_val(pmd) & _PAGE_HUGE) != 0)
 #define pud_leaf(pud)	((pud_val(pud) & _PAGE_HUGE) != 0)
diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index 24fe85fa169d..f4e369342a56 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -432,8 +432,6 @@ void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
 #endif
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-
 int has_transparent_hugepage(void)
 {
 	static unsigned int mask = -1;
@@ -452,8 +450,6 @@ int has_transparent_hugepage(void)
 }
 EXPORT_SYMBOL(has_transparent_hugepage);
 
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE  */
-
 /*
  * Used for loading TLB entries before trap_init() has started, when we
  * don't actually want to add a wired entry which remains throughout the
-- 
2.54.0


