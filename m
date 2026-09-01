Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E5DCC624A4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 693BD6B00D2; Mon, 31 Aug 2026 23:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61DE76B00D4; Mon, 31 Aug 2026 23:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50BFF6B00D5; Mon, 31 Aug 2026 23:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CACF6B00D2
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:13:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E301C02D1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:34 +0000 (UTC)
X-FDA: 85163723148.23.7D757D1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id A3C7F40004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FvxY+dvE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788232412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIfvMfZyaWvl4SXEvl5wZrxucNW79v3GPJFsRYX4w4M=;
	b=IT70vb2vtL7LYQL0xxjARJll08I6mN0/UQo9JFdamtroOswpW7DKgSApUUd5msgj8eAst8
	Ys5c8armeYGdfVoQ2vJnGn727WGrmPwm6SsjWOERoKhBR4oJlD27q4U6AN8ke4RcZPgbsS
	M5QGN+EEgG86Jg5zqqwHE+3SXCga0rc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FvxY+dvE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788232412;
	b=P2EtO2SFLWEbpj/OPBjgUFMWFbWTbrndR6eLfz7kve+oMpyWIDSD7vMyIXK12WRVwV3jFF
	HZ4G551CR6qMZbLc22Sin0BQ4QLzAwdAjMrsboyxRCawsPh7u0LuR82GjlY62OuuyPqNk2
	AIe5LOX+bPluy4vu2kD+P+YuAVKPlNQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788232412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TIfvMfZyaWvl4SXEvl5wZrxucNW79v3GPJFsRYX4w4M=;
	b=FvxY+dvEJM1cpA/WAlCL3Wi01cUYlhAxuCGTKPlWsXHgJhsBBFGBCVL9tmxLDOdEJhi/Sb
	CpeXSUXRVRbF84uwRKgLX5ZzcwLxbhdkfb9wZf7aIxtGzd/jSA1DLt8xHJJLoh0kS9cWXz
	yMWOwXFHsDLHudpydBGBI2C2YJuMiZI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-kyslgUdCMcmyuoL2_hzZ4A-1; Mon,
 31 Aug 2026 23:13:28 -0400
X-MC-Unique: kyslgUdCMcmyuoL2_hzZ4A-1
X-Mimecast-MFC-AGG-ID: kyslgUdCMcmyuoL2_hzZ4A_1788232405
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 178AD192E255;
	Tue,  1 Sep 2026 03:13:25 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9944518005B7;
	Tue,  1 Sep 2026 03:13:21 +0000 (UTC)
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
Subject: [PATCH v7 11/14] x86: move has_transparent_hugepage() out of THP guard
Date: Mon, 31 Aug 2026 23:12:15 -0400
Message-ID: <9f8cc58ebe0f8365952e2c528f547e1321e1a23d.1788232334.git.luizcap@redhat.com>
In-Reply-To: <cover.1788232334.git.luizcap@redhat.com>
References: <cover.1788232334.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 8ZOK_t4_-BHheMhbIjw_EPmogbf3h54qub3G-R0D4i8_1788232405
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A3C7F40004
X-Stat-Signature: 7kje4prce6x6qs5igqtgeycxzcpaiagw
X-Rspam-User: 
X-HE-Tag: 1788232412-341328
X-HE-Meta: U2FsdGVkX1/6ImZaM0rJTf8Fl8xdtyJrKYy7urw5tBUmgJtzRHJgVG9jUY3ODl4QrkmjRcpxALpB/lrM5eRTO10i2ScRaxEt6+SM8QOXmy5lfbxWUK6XJ+teR/liK51iKFq7g1sxiiBgM5W3kfo7+ZKEiiSMhJpK1/LZMMzbKpNIXflmTEnOi2O3/j33MtIiBSongP3JFp8jkbWjl1yh6RoHxT3SXinTDZhMv6jqeUfX1FP2dxs7e94yMnfRTi6ztufhLRB/uMiJMV59A31ZnjMFmlsFKflyQcSLnWrIXAjbN1vROQxSE5DSQxFOMTqg4xHk47yUPtsMfAyKOBIgUuFDXHfT7uIJ4xN3j7V2sm0Em+Xjn8m2/I8mWpZx5GIFK0cX2UlXZ10qLa2WkLGUTME72QvSvNDWiovNQXo7eZoC558XNN5PP1wndGRf1unJewTmsoe4I8Rv764wpLCt/rzzRyS9qfQxcdzJwkDMGo+ct9FFv1/VjxG2XmqAefeK0bP1GADYsREtDrYks8JsZNjSfUpK/EZunHdFQhdSD17k4LCgTSZx/o1AA/0/p5lUac5fbHKGHVYuT2c4UlOr67BcQsSHM2hbzEw+w4+GDqS228OmGbc892YbpoKIb/Fp+kvhFIkx4+ub43XfsPBm7gWInOW4LydqBrKK7A48DSob1e82HR098zF+aNhie/LuulsiGey8FT5DeotaRm4qGHehIRiW1cIIyMom9nuY4pt16Mw/N4iEqj8zxiCm+iJnBqRSo7Gveqwkf5SG7KGQ/ClFTooVU9gHAamU++vLFT4XFwRlqw/VlC5lHD1UljVVhZ697+z4iYXsktVIQa267YDyy8Now4pXjsElBnTFngwTns5fTMsUm6DkdqXh3dDAsoeP6V32LMhahtZMyUYDwa9CFKAmAaDWW+rDTh8fBDxH+tLeSwwtsIQ7Jh7FnUHhrR0Gmzehwz3KdgHfv/b
 Fyy/TStA
 Qa/c91J+P4HH+nDphDd8Rq5J08YrTPsspk1h7pqVvKaTomMka95UFnfv4/+Lf5kbI9TCIX9U8PeQVwk3TuAoc5e6RRXnqfpf5F0xeM9LQxirMHjSp/8syOBGhe9sJfF12a+EljPHo6qszMRpD6mkIm4A5uEFGXB23L1AXfpZykZhToU91sYH4KIQzuUMgIU82ROY9cJnHaOcIgeRVugica6FUFYdJRreSMcip7MaC7kyxid2leW7ftYgcTSfBCdbyu6xkC2L9+BE4iHfzBGJNEkxZjTCIZLXkrpH5RYgDV0S/V4JkXC+c7am7D7FQWv51opAyCdK1uQqcFQBwMxoI8q6ykXRjKxlQiETpSsvIoj6f4DHF9h+jVARY5Bx2Ij/9YByWzmddZ+YpH9E=
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
 arch/x86/include/asm/pgtable.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index d5f4917c1edc..f207e5268918 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -306,12 +306,6 @@ static inline int pud_trans_huge(pud_t pud)
 }
 #endif
 
-#define has_transparent_hugepage has_transparent_hugepage
-static inline int has_transparent_hugepage(void)
-{
-	return boot_cpu_has(X86_FEATURE_PSE);
-}
-
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
 static inline bool pmd_special(pmd_t pmd)
 {
@@ -337,6 +331,12 @@ static inline pud_t pud_mkspecial(pud_t pud)
 #endif	/* CONFIG_ARCH_SUPPORTS_PUD_PFNMAP */
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+#define has_transparent_hugepage has_transparent_hugepage
+static inline int has_transparent_hugepage(void)
+{
+	return boot_cpu_has(X86_FEATURE_PSE);
+}
+
 static inline pte_t pte_set_flags(pte_t pte, pteval_t set)
 {
 	pteval_t v = native_pte_val(pte);
-- 
2.55.0


