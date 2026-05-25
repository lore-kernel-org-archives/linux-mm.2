Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3E6DCD5BC7
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 06:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B4D26B0098; Mon, 25 May 2026 02:28:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18CAB6B0099; Mon, 25 May 2026 02:28:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2516B009B; Mon, 25 May 2026 02:28:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB7336B0098
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:28:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F693140175
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:28:30 +0000 (UTC)
X-FDA: 84804963180.07.D066D5E
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0AA12C0009
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:28:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VuZqun4P;
	spf=pass (imf22.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779690509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=acZ9/LK5EVhAjK8ZnaMSqOtU1DWY9dKNeWMugFjaoLg=;
	b=bSJ86PoAgIP97RCHoUfmbFHasi87ksU4sju6XAZeFVJXsQXRdZ3VKX1rki0sIf/AIN0RlN
	IarqCDoaGjirVUtNhXDU4QdmUbzBc4BGtViJtLLIz5/fTopfaTObcBBKoNfzlKUPv1S29n
	ow2PdkdfBBMFr/sw2jcur8ZQxBPIjCE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VuZqun4P;
	spf=pass (imf22.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779690509; a=rsa-sha256;
	cv=none;
	b=fqNarU9oKCYV6LiRlP87sF1NFJJ1PjKSOlYFR/YmUOJTfBJPZya6EXQm9cLx7ELED5jQLc
	YHtk5bJQuLMUXucUdoXXYV+dma502k9/wgjKuNqTHgDMNFJjYcLLzvrlsY6Ill+axRGQ+b
	78slPgg4To8tuTAmsj7YIsIpYY0l9fw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779690507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=acZ9/LK5EVhAjK8ZnaMSqOtU1DWY9dKNeWMugFjaoLg=;
	b=VuZqun4Pplkhr1ruJCNhwVyCRlrJ8YN5XTuCHzFwjIcN4On6My5+wO2nuTa2YcDH+R4x6j
	OjQ+8k237y/C3DS7wVCLCALfIUOCRMwX/WzkA/gCfLrA6MW2xJnKiJbNKOWvZQoDysQxv0
	8CF/cAFRfIql3lLNEgSTyZ3IVe4HdCo=
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org
Cc: kernel@xen0n.name,
	graf@amazon.com,
	shuah@kernel.org,
	loongarch@lists.linux.dev,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	George Guo <guodongtai@kylinos.cn>,
	Kexin Liu <liukexin@kylinos.cn>
Subject: [PATCH 3/7] LoongArch: Add missing linux/mm.h include in asm/io.h
Date: Mon, 25 May 2026 14:28:06 +0800
Message-Id: <20260525062810.103367-4-dongtai.guo@linux.dev>
In-Reply-To: <20260525062810.103367-1-dongtai.guo@linux.dev>
References: <20260525062810.103367-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0AA12C0009
X-Stat-Signature: ryyybn6jmae5cxuh4qgx815yeqh88em9
X-HE-Tag: 1779690508-195180
X-HE-Meta: U2FsdGVkX19vBS0NO14rHOAWxv8/ZZlUUBtx4Z9mCVj26XA8l2C0xGACXOkNeZj8U+m6VLjPi8D2IDrLQtL9EaZtZGFmum1AMsNkmJJzL172i3jiMEdKFzXbs4izt6sDefdDCNs5B2p3rlU9sada04WQgO6O4Oa8J5tjsdmf3eIDmq/UGLLgfvgHiEj4jcyurzhJ9ems6u7e5aLhKGX3cxyxwMvRfnsRbSrpZw0ePsU3Qc4UPZI15VhOIzzNyx4LV4h9xa+/AH9dCLXY+WaT1lG41SJrkXi/cql5mpP4aRA8/YLYssiZB22pktdQA7XpZNBamq6O9g/xI0jDJaNp+lAPFKHSBMgyr5Kc88QcDFAYlcaqcqg42J49XVQ9NrL9FJtikUqza3c3KLmUg31Gm8/mx4FuOrWrJoOBSXMUt9OUM0UBy231Oegcml1xSG6TQEAuVeS3zmJwgnvI+g3PtsSQ+Z75qjQUUbN0K1nYAq+uxNS3Uj7qZIzbDWsfj9naqGOXN5TJExpwocJY+Ovssk3aXD0b6dQePiydiRV1Zf7L4LaZ70xcmuRbIQRe9oQPUtuBTVgoWiJ5eNm0bVoGNAMS1CVVouTTL3hkSF+fEjNOFqxdd7FfBI8z0rXG7E6hT70VoWaWZgvWPA0lzEDM0IikKmHE/ftT9eWPsO8vSvix4hCT4weTIchfyjAJzgAI9zGivcPXBmpDmjGKF6OzITTezO1B4jKnJkigNyT44RFGGONnwwfxpGIUBr3/sSbCJ4AkGxKfXd2wlFmjSlCvsJNnZIEinjFDXz5o7ggDWsc+n3NcMxJ/A2Ok1AE67KRB2xZes+yl75rAajMYb+opc+eQxzGCRMe5g0XeYz+taPs1bvl7YnDv9Vj+wm+W3SrPTsYt5xv6uG30rqcgrX0yxb878DDUzINyjENXnHZdOub1F92ZvilHcyLXIY6QDmKv5azWci1nGoy7YV7b+K7
 pmb7pxyV
 pbnIG5I4xZD1ff42Ughzo8VXQrHRtjxVjZ5jndEc3Oax2R+iQ60dkGFafs4aAuGGQsewWX1HmEnwkHiiP5K4RcHW0jEz7SlAxYRetmeqtxNEV78inyzN6m/iZ5qFhpc8TsWznECVGV6S7Jgm4r3c77EDTffetL8bB/N/UbeN3MgspAm4pRPX79K8RVY6yygMWPH+Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

When CONFIG_KFENCE is enabled, the virt_to_phys() and phys_to_virt()
macros in arch/loongarch/include/asm/io.h expand to use offset_in_page()
and page_address(), both of which are declared in <linux/mm.h>.

Without this include, any translation unit that includes <asm/io.h> and
expands these macros with CONFIG_KFENCE=y will fail to build. This was
observed when building kernel/liveupdate/luo_session.c with
CONFIG_KFENCE=y:

  asm/io.h: error: implicit declaration of function 'offset_in_page'
  asm/io.h: error: implicit declaration of function 'page_address'

Add the missing include to fix these build errors.

Fixes: 0ca84aeaee15 ("LoongArch: Make {virt, phys, page, pfn} translation work with KFENCE")
Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 arch/loongarch/include/asm/io.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/loongarch/include/asm/io.h b/arch/loongarch/include/asm/io.h
index 0130185e0349..7ff4aa72a34a 100644
--- a/arch/loongarch/include/asm/io.h
+++ b/arch/loongarch/include/asm/io.h
@@ -13,6 +13,7 @@
 #include <asm/page.h>
 #include <asm/pgtable-bits.h>
 #include <asm/string.h>
+#include <linux/mm.h>
 
 extern void __init __iomem *early_ioremap(phys_addr_t phys_addr, unsigned long size);
 extern void __init early_iounmap(void __iomem *addr, unsigned long size);
-- 
2.25.1


