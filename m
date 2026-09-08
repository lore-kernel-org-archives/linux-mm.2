Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82EC0C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A1BD6B00A1; Tue,  8 Sep 2026 08:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5794F6B00A2; Tue,  8 Sep 2026 08:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A56F6B00A3; Tue,  8 Sep 2026 08:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3DA6B00A1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:51:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D4B1140602
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:25 +0000 (UTC)
X-FDA: 85190580930.28.B1DA628
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf28.hostedemail.com (Postfix) with ESMTP id A3B33C0002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="O HlOW9F";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=D+TmJw7y;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2NXsxc1jX9htzyVHYrKvKVtGcWKt3qidVIHJ/7B4Lgg=;
	b=MHvUCWy4Bt9g5nNv28EwjjRvDjt/ZEwYPCWTZGplWXagx0WAK9jTSH3A9x6zfpRVvYHYHx
	zZd3ubLTmD2YiLOmd7x8I80JgGbTVrhS2P4tQR9PrivlT2Qo/bTBlibkE5J/i9am+06BTX
	htjpxhAC8iawmzTdhKLnQg1ywrJRNas=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="O HlOW9F";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=D+TmJw7y;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871883;
	b=upgjPCZ1TTNuh0k3skJNglRfpE6bE7pta3mvr/6ASOl2LWN78Y9pVZmyK33WJjRCp4PgKm
	ibnufBMSNecK0y8MyanLRpMBOuH0plPUwTJTyUgKddFd0L0ltDi640B8+V4n000lZujtjR
	R5AGV88tP8HiosgDZCqrsciHmPI5Ea4=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3B58F14000A1;
	Tue,  8 Sep 2026 08:51:23 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 08 Sep 2026 08:51:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788871883; x=
	1788958283; bh=2NXsxc1jX9htzyVHYrKvKVtGcWKt3qidVIHJ/7B4Lgg=; b=O
	HlOW9FoPmv5SmA7W/80F/F5LXr0PBqsP2hgc7nWPGmTkhwme5n9kcJQTZQWhGAZm
	NphFC0KfvpsskTgU3LcpKTc5yXy3eM5qUwvDIz93gMxS1ZptIKnlKt1r9nA+UqM9
	9PNfKTzCaNJIx5pamHDHEAixJiiIffpdsjf5zvZCC8elihH72G38TnenqmuNmE4e
	8fJxbTE+Y0iYRbWRXZPHV2NkzaRPNF4BaOahYyKILb8vCzC0ppFy/iWk2tEk34Dn
	Ka+JbhqPhHm+hxzy3vgSNfd2+stVMTbyGPC5UVck2SLW54nLToYS6tL3CUTfrrA3
	lSpEjketdIgfSeuQGa7VA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788871883; x=1788958283; bh=2
	NXsxc1jX9htzyVHYrKvKVtGcWKt3qidVIHJ/7B4Lgg=; b=D+TmJw7yA9/y4DV9N
	iA1tBh9DIBHlfyIXtkM3me0AMveeoaXnNqmsAs/9i/6Sfsvyx8T2jdcxP+Fk4v9o
	wg/ISd+LfEKf9bXtoumvY/iBBqQSx0ck2r3GUBIOQCFRYQXsqzcf1S8cesAWkQZg
	VbOeI1XcvwMKIVtw+BkcXfoDur/irHh8QG8sf008n9kh5QSKUIwGXp1lz2PNBzKR
	/CLYZV0tGV/rK3VgOS9qd1ZpMl4qrLzH7rq1Kd5ljsroKGG66IPq+81ub5/SJ1H/
	DGSfPDKw3phNrdPlhS7AKctzkjo8F0N5yRPJsBDWMLLdGZP8zub8XBNlkUXc7o1b
	sJ8FA==
X-ME-Sender: <xms:ywSgasvYORdrMqcnTkprEQe5UZXWVbhzcy6TlIsdoC5WFx1OKaY-mA>
    <xme:ywSgah1J0Cvl6SPnY0ubwW2kDCTR9ZNPriJtRlm-05ML5GxZd1tfpY_HSF-xAe18T
    TtyhqJ2BQWFObQ7FnbgCgmNth4AyfJWosp74e4cZKYh0EoTWNHifUHH>
X-ME-Received: <xmr:ywSgap-H34DLJTODeTo3yRjo2eselhRizeZF6AxAMsNbky2q08n7hWqW29I>
X-ME-Proxy-Cause: dmFkZTGuvEMc9jYu2f0uyTmUF7l0J7NybVdULRlrJFmokmmiolg4yH1+7h97U05D2w+OYm
    AZhWoHmMPT2EsIB4AC7PxRFoqN+CF4x8etMK41ayTMd5Tw55ZxqvSYpb69cNUy0p/dfOGv
    05P0JRk7g5kt5eTL1k2cO9e1oUb7lrROdNyUSbigYjG7Zs/tNKx+L8+9HHw+CSw5cJpWIQ
    j2DrX13NeCZvnLN36sWkEk/U0EX1Q1izKAtzdjMuXhus4PGMhEw3kJKafKZkgCRsnWRxXR
    Wv8osDa5aTh9mnjCTFnYcP83hQ8y7tmPYrDENim+Q79mFJR5sJUGN5QsCu80CUB5y6e4FH
    2bU7+Z1C/ZBs95vtrfpBNs3fYgoa7TxgB+J4T7MnHULHrY3HKy5QG/NyXdQGKctluDNtCm
    eUSUl24PKe5TOi4Wa1oA5GZOBNaqq1b2z6QzlJFEwTl91ijbDGpXvkkxpFJrcPnfTBVpYW
    vpt2cD2n1OIRqQX2pWGGJvnOGq0XehYPEkvO5cytepuAkFC8GzVmHHsqDR4n6jxIbiOSas
    P8shOONYnFFmhKFTvYk0yuitB8jX1e3akpUlI7nPOk8xH2k9LKejsDXNuk55xKtVw3PPpF
    j2m99WZGHOkyNmkBh5fGqyj4Blnx9BI5f988Vuyw1L+IHdDSNxVej40fvDFg
X-ME-Proxy: <xmx:ywSganDK94xyQxDZLTrtveqKO_Ktl67yQur5yvXbolXkz-VxUEDr8A>
    <xmx:ywSgavA6c64D7xzaJJuZmc0aF8oxsJxWCFCxpYQc_evdNfV5zrpzgg>
    <xmx:ywSganIXU4ezER-BV3D8iXAN-C45pQ8RVEvc0V5sCmceftvIOIwbKQ>
    <xmx:ywSgapQRe2IKIT-GY17GywJPdjUv5oVu3xOFWoIzrSbjUizmRMtOEw>
    <xmx:ywSgatcOGnuYHwQ0lpHlwd9TF5wDeUgwV3H4sjNIoFZnY0OFVQfhCVTq>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 08:51:22 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	usama.anjum@arm.com,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ziy@nvidia.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	agordeev@linux.ibm.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 06/19] selftests/mm: stop khugepaged during the MADV_COLLAPSE cases
Date: Tue,  8 Sep 2026 13:50:52 +0100
Message-ID: <20260908125105.1510704-7-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908125105.1510704-1-kirill@shutemov.name>
References: <20260908125105.1510704-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A3B33C0002
X-Stat-Signature: yry6diyxaeepu6t8pnsnfcztb6rbz5gy
X-Rspam-User: 
X-HE-Tag: 1788871883-617767
X-HE-Meta: U2FsdGVkX197LuXnXm9gQ4JSl2KNFXVA3GXne5B42Nw1MDeQZUuB1I4FfLmykBl75DClyWLx2rc+wF7uABKdPpJ2WKc46ouz2ZhNSojtKm6DfLHsA/QnNfCLK/gwCDMuwMK1EfD3RZHh9f8Rzh08o2Lbc4pGNDWax+lhFAORxGYEy4qKxtl492cHUD1bXuCdYUhGxPhtvaxpO/P+z7siI1lqsxndMlG9LwCUQlaOKF7deSe2fyiBFpy+YGTq/WyKATxdAJoJZqOrWnVQiZXFnAmV9vah53JocnRk66rj858swb2Jo9qaAkcI2+KU1kElpevv1/W9r2o92+UtFEtyVztTp8jZ3Co5PLC57JZCK94vccUZczoUDeHbW9bjzoJ5iiCzHTsKeKYDSm1ZViguoSRxKpiqVG2t7mvIQ1mTYPsmVXt6lVji49bAAavTbZrcmTuYMB+6bNArPwGJnHcmE3b3DdBfkYXMlY5WqIJSVkVD7jY7lGF2L7A60s303wh1QcFFcKVaDGWKFtIR3jy4mI0lIaHzeRxOf7mN/TtHO9BT/oCgAxBdReQlFHoUT3uQQSra//J7XYEAxbAqoGpzg33oxM5in1caaOfPTuTs5yOf09vpaWYDQoJ8VUq+OnzWX4V+1Sf5F/mL7CW6sVYy0KkRpUOvmrLRbUlmrt6cqSsDcr6oGASFr0+c8Qj9AJpAtuMW/Tga67Y0k3pZOl6kvSEj+54H23bqNhIFSR0//8jFbk4nGfIp6IcCOuiOEnv/jjNwf6F7sqfd+Ha1oU1m2O0uN9s5CUDuPB+1iycdF30GYn7myaVkoaLtMAfOgY40tuanpOm9tQotqnDfoOZShlwFRV/NP0UVJPsjRTzqClIcA3jrxZ0W2zrnP6g2EnBCa8jd+HtELV17h8SIM+MAWg07r1Hq5UrEE3LIG6Suhk2mfcpgHYQwaD/V0cepXBL6Kl1yuseNENZOLRapebF
 ++T7XF1y
 eDXv+S9Zcx3gpav/PiugbdyuFt24marX72gQDFYLIDdm8vj0mvCeLLPCUSaZzTCSUBgOdKI8FJ+c3IkXaKwZfNCcEDK2OnvlaqF7Op+z4rAgZlkzLqcwbLJ9FxQ6IjyQIbmI2Kn7LxtBhku1ZiFLn+T4Tt1NPVuIfBn2eQEGAT+KYGAMP/P5HY/lK09P5s74ebrba4nI8d3TRkc4XAX4tjBM9cn6jeRTbjAQ+ZFIyaUhu7riW7gntBkqdBry/lYtsw/7WTycjB1MgD+IAq+fR8ezCQuzFlMz9Yfq+ILVIDuGSaUdpeZHsyYTanArztCp34et9IouhNFGhiOpSu+7DZslpeXZd27bfGr3DXks6wGaUUyrT04BYA5DLEWue2AcGQOrGA7Eq/3jieYATSwOg2a1QWDSBdfLv0KkCp1UULBnlqt5C1H/3yAnfZ2xqYuHOsHKoyKOZooJ6J3IEK9yJHdbQJ/rHaYlNiLMadDsdnz6qbPBa51NaE0tPgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

__madvise_collapse() turns THP off before each MADV_COLLAPSE, both to keep
khugepaged out of the range and to prove MADV_COLLAPSE ignores the setting.
It clears the global controls only, which is no longer enough.  A per-order
control overrides them, and -s, which makes the cases fault in folios of
one order, leaves that order's control at "always".  khugepaged then
collapses the very range the case is working on, and the case fails on a
collapse that was interfered with rather than refused.

Clear the per-order controls too, setting them to "inherit" rather than
"never": khugepaged honours the global never and stays out, while
MADV_COLLAPSE on shmem still finds an order to build.

Fixes: 9f0704eae8a4 ("selftests/mm/khugepaged: enlighten for multi-size THP")
Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 398430c33872..e9bc8fe8a1f8 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -533,8 +533,8 @@ static bool is_anon(struct mem_ops *ops)
 static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 			       struct mem_ops *ops, bool expect)
 {
-	int ret;
 	struct thp_settings settings = *thp_current_settings();
+	int ret, i;
 
 	ksft_print_msg("%s...", msg);
 
@@ -547,9 +547,16 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 	/*
 	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
 	 * ignores /sys/kernel/mm/transparent_hugepage/enabled
+	 *
+	 * "inherit" rather than "never" so that MADV_COLLAPSE on shmem still
+	 * finds an order to build.
 	 */
 	settings.thp_enabled = THP_NEVER;
 	settings.shmem_enabled = SHMEM_NEVER;
+	for (i = 0; i < NR_ORDERS; i++) {
+		settings.hugepages[i].enabled = THP_INHERIT;
+		settings.shmem_hugepages[i].enabled = SHMEM_INHERIT;
+	}
 	thp_push_settings(&settings);
 
 	/* Clear VM_NOHUGEPAGE */
-- 
2.54.0


