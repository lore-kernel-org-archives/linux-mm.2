Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6067ACA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 04:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71FF86B009F; Tue, 29 Sep 2026 00:03:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7216B00A0; Tue, 29 Sep 2026 00:03:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E62B6B00A1; Tue, 29 Sep 2026 00:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 315D46B009F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:03:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82771C038D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:03:38 +0000 (UTC)
X-FDA: 85265455716.01.D7B3A0C
Received: from mail-yx1-f97.google.com (mail-yx1-f97.google.com [74.125.224.97])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4BF45180006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:03:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b="KcSWKr/u";
	dmarc=pass (policy=reject) header.from=broadcom.com;
	spf=pass (imf16.hostedemail.com: domain of zack.rusin@broadcom.com designates 74.125.224.97 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790654616;
	b=E36oqN73J9V7H+zFjdUoNzwr1xxeDlu5UKNYA1H9fVJk9RMFaoKoM5udHq8TPtvI48dFkw
	5n6q3uhHk7R3LSoZLLYzwcTwjxKcP0K+BVWM9Bz+A2K2bX7BVyO18WzESuatn9CRjRfq2k
	HV1TCr7YbcxSZ859ut9dE7fl+OSdYIg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b="KcSWKr/u";
	dmarc=pass (policy=reject) header.from=broadcom.com;
	spf=pass (imf16.hostedemail.com: domain of zack.rusin@broadcom.com designates 74.125.224.97 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790654616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CV8TEMBP6IF+2lIlzYCpg42JpAwpPVBphnZX2jCaOFA=;
	b=dRRxCd/rjV04Q5p4FOzwMmvI2LrxFOIuiydi2IgiPu+y1oDhBVP3lPgqShIxTUNTG1GJM2
	mbUoPiZ3S1bUXcaCM2/1Sppg23YY2bcJuULuEMMiY5W+xZiL49YOw/3it0z0xPyQG4NWf+
	OLVF3zAZyZ2i5cK0fxJ46ysEDxhAmoE=
Received: by mail-yx1-f97.google.com with SMTP id 956f58d0204a3-675617e81f9so203784d50.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:03:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790654615; x=1791259415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CV8TEMBP6IF+2lIlzYCpg42JpAwpPVBphnZX2jCaOFA=;
        b=Qloj01dElmif/prR1MFuMhoNw3EqjXT43BZUBgMU4l9RdQRSPwj4982mRfluWi5xW4
         gxu60GlY3r7p4ZP5lgfaCDH5UjtrJvlW9+6RT5iMwgg0fUJJX7dxwhqPWfrPKJIvpamr
         lOULOXUF+nbiV/pz+WR/ySltnfsd4gy+zq4pjCQA16CuNzqwwFh3VH9Tlj/qtLsCHWrq
         6QsCCsS4BrA2Imr5L8EMEt0753DhiqpSorvMQ/ORtLE2rD35Udpm46HQfFxzGN5qzqbA
         v5nQGBpdYGfCWhEJkUZHPuzRJB9wAG0/PC/3OHw49l4WAkHSPLxs9P5OXGediz1cg9Cb
         DIEQ==
X-Forwarded-Encrypted: i=1; AKwUvBwxCxk9M/+890Tz+44Vbz7G1SnSK/P+K03am08XyNkXASOpqlEL28wkEF4spWXJI/84At6GEbaYfA==@kvack.org
X-Gm-Message-State: AFq9FYI7cl/WRcBDUriKTEUDs76V1Hk5srjrzD4u231e7mLFvNTK4lu+
	Jo8Mc+IzsFyTU0bcdHL1l8iWo/kkGxDgbbztpawHo1vx4JBUWujR5OdU4xAcDqiGyXnkE73J2U3
	lRKRJxDB+i1SVS69v7gH9aQvw8adPY7dqF3wWYLtA73Lh8cRi73rWQZrcsl4zz7cQZ79IfH5yRL
	CnvY71vnwrQX+2auLj8hsdfJGomyebHqf0G5VD9tyUyh737737uIZRgwEbCWe+tQBEteEFMelDt
	WI=
X-Gm-Gg: AYBFou0y2dfaniNLKiDwXROhPXtiYEX1pBr2mxPZWvSIw+vSBbpX1VjVze5GtvZ8yy2
	aW/dpX/NJoI6Db2Lky+swZTz5oao5MQ1DCJLwunxjpEdffNuRAW/TBCefJqGvUXD6fXZwfWWnDh
	4MSoFgEH08iX3vIhGKJXAFw+QWFpEumi6RQ72kCKYX6jfYD8BYlJc0lW8a42HKFm1f/sOuoVOmr
	l3CXOfZ+vJN+Us4Z1yJvq+dbYqCehe1igSmIlc5zUBECgHqDdDGT3f/HvFWUGuHwBpA7opXeCvH
	w7iSJKKnmPVKDk47YUWutfRG0ORPP57mUVBejzxPd2ZMxz8eavHz6YQtQcZM2UMcVXLIAz4oOH7
	+P/s2iePM2HdqvyuUpZtqJm4T5J0cPoslrFR2/azeRghOHlHusOimmVtCyTHHTYDNDaEzgPZNZC
	VsONLMtGaLS1KfTItzc4daVorckG2+YJMe/rw=
X-Received: by 2002:a53:ac97:0:b0:675:6426:5a87 with SMTP id 956f58d0204a3-675642681e7mr240908d50.22.1790654615248;
        Mon, 28 Sep 2026 21:03:35 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-6755cccc846sm456520d50.13.2026.09.28.21.03.33
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 21:03:35 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33baaba6371so14197667eec.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790654613; x=1791259413; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CV8TEMBP6IF+2lIlzYCpg42JpAwpPVBphnZX2jCaOFA=;
        b=KcSWKr/uhlA/lyMrFbPiwdRLjTe0HEYN+2VBYdSZfLE/enN0fc9gVAU0jUgZwdKbbC
         xcf6IgAPI/0V7RUmjJ/Yf4zb2eoFDbNucK9TSDI2WGm/EaH0cXESzsva5yfrdHj2iCCH
         BB4i7XWAziYa0tevC02JjrJ5/cR1dZfhkLxxc=
X-Forwarded-Encrypted: i=1; AKwUvByLEPjfHHdA7IN8bOkuQNRDVe27Ft85vLFh+9SBmLVVbUwTJd4S6FURVm+CbtAjYUFAe9M8INho2Q==@kvack.org
X-Received: by 2002:a05:7301:4d0b:b0:341:d191:b838 with SMTP id 5a478bee46e88-34272562bc0mr12611784eec.31.1790654612948;
        Mon, 28 Sep 2026 21:03:32 -0700 (PDT)
X-Received: by 2002:a05:7301:4d0b:b0:341:d191:b838 with SMTP id 5a478bee46e88-34272562bc0mr12611727eec.31.1790654612252;
        Mon, 28 Sep 2026 21:03:32 -0700 (PDT)
Received: from vertex.localdomain ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-347323f5a7esm10952571eec.15.2026.09.28.21.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 21:03:29 -0700 (PDT)
From: Zack Rusin <zack.rusin@broadcom.com>
To: Kiryl Shutsemau <kas@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	virtualization@lists.linux.dev,
	bcm-kernel-feedback-list@broadcom.com,
	linux-kernel@vger.kernel.org,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bo Gan <bo.gan@broadcom.com>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>
Subject: [PATCH v2 5/6] x86/tdx: Support early sharing of kernel data
Date: Tue, 29 Sep 2026 00:02:54 -0400
Message-ID: <20260929040256.543767-6-zack.rusin@broadcom.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260929040256.543767-1-zack.rusin@broadcom.com>
References: <20260929040256.543767-1-zack.rusin@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Rspamd-Server: rspam06
X-Stat-Signature: 7xoyjtqxpixhbmet7zzz9gku8g4uj8gu
X-Rspam-User: 
X-Rspamd-Queue-Id: 4BF45180006
X-HE-Tag: 1790654616-383679
X-HE-Meta: U2FsdGVkX1+jKtchmwFrKhLmZ7rZSQgQ8oODwoHiBv46OveBoU16JyjRzg+uPrEK0G8A9mwiSR4v+AuR8BIxb1Z0CcmIH99NCFSq2ehJnoyG0jTKm1z3zdnu6jsJf+ZBYgpKGzfhrX09YQM8Rv+s7FXItobOjOFTfC9E2TTyvhdBMeBiTu6wvtVqc+YnwOQLhut3bfIX2j6wzkCFDWtxm5NhmPfPjKgGZOdZS4yiNJYuJg86dyk01EYxf3Sys2R2th6Q5WDO9YeMocME9MZuy6SuTFBrKFruQDU3S/jKhHITsjvSkiTB/aNqDHboLg+a9NxpuktdB99atIP5qKEvd3a5CeBeA1ykYbsPgl2nKVdYmq/rHWIfQm+7dxI1QHuAxAK1evANgbBmIChO4OACP2TYRoeMkfo97Ga/tWAkeJiVmVh5gp1bx0OFQltp5bdaAP8C2CrguAWP/hPp3DdrycZeiS91wBmbStZ6IwSkkQ+ezyfe3C9s5+N3BWJbImkG5EtQ+VBOErHg8IoJ7OCeOumOApDABX703fIUKokchtltFHSC4EDw9EnaCTpQ/0J7RDux5kyw1ZjXvWE5BY0Bfgn5ipGz27CKE21Yx2zUr9pLYCcUTbHvVv9k0J1M6dUcEh4ITmJ81Rzxy0xEM4byoahnDaQAAUw47mLiIwE8VMR0fXfxLOgP7h9hfkPqQUt1fH2Vuowyw73wO8LY9Wc7NvGETMqDxNc4SPWq76q8+MxujloJ4KaUzfPOdlgowhOL/320z79TCVl8wtC5FPbdRnzvUZN1TGenRlMW81sYkcJ/KfUCUwOIBL0/vIQVZuUoGqlOp/jNmXewb+hG/8IIGeMW6g9oA2ZSZz9WK2lcxzNAQDzLwUabuCkrINeAbh3H/LaR94kAQt4SEvlPP+OslGMv+c9S2tw3C55c/7iExyX3E8HY6xiuL6OKOioP9/DqZNnuD6LK8oYH7z43giQ
 zaVhfbs3
 noaiLkhFEFdR6Cef+jKlNezbuskVBtJ7P9gGOsOsqDVKIPq6/aEWtrdZZMrxEXBpOEj704xtanOBKi3r14/d3ILbc3Tx0Rj04Jj87Qp8G/VXbHUYdBa0IMEI74TCpDHfD6q1ekq/GnKa8uOAF3GulYOdYP8kzmj5Z2mi9eS/QbcEQy9uZs2c3LMZlJMkJAwDRrnnGOAlElYF+KIuyk+cKgvO9A58u7rVifMlSHTQgmz92/DExBDaU/ERuJtgcLfBaTkjeX1oK/S3RF0miUvW4Sdgw++ckCp2VHn6x8TSLtZba8t4b+HVlDdMB8dMlCcuoQ04BnbphtqQGe7XnSzSRtUFd10YI3jQjTJ9FZ/jdG76baVcHvaCREqX9TweFF1j7vtjWKqXDehudWeY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Share pages before the page allocator is available, after both their
direct-map and kernel-image mappings have been made shared. Preserve
initial contents in a private scratch page, matching the AMD early helper,
and use the existing MapGPA path and shared-page accounting.

UP per-CPU data has an image alias. Drop shared image mappings before
kexec converts their backing pages to private through the direct map.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Link: https://lore.kernel.org/r/aqqGUAX65s4LdJkr@thinkstation
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
---
 arch/x86/coco/tdx/tdx.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index f904a636d449..4a683e9eafc3 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -4,6 +4,7 @@
 #undef pr_fmt
 #define pr_fmt(fmt)     "tdx: " fmt
 
+#include <linux/cacheflush.h>
 #include <linux/cpufeature.h>
 #include <linux/export.h>
 #include <linux/io.h>
@@ -18,6 +19,7 @@
 #include <asm/paravirt_types.h>
 #include <asm/pgtable.h>
+#include <asm/sections.h>
 #include <asm/set_memory.h>
 #include <asm/traps.h>
 
 /* MMIO direction */
@@ -1006,6 +1008,23 @@ static int tdx_enc_status_change_finish(unsigned long vaddr, int numpages,
 	return 0;
 }
 
+static char tdx_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
+
+static int __init tdx_early_decrypt_page(unsigned long addr, unsigned long alias)
+{
+	void *buffer = __va(__pa_symbol(tdx_early_buffer));
+	int ret;
+
+	memcpy(buffer, (void *)addr, PAGE_SIZE);
+	clflush_cache_range((void *)addr, PAGE_SIZE);
+	early_set_page_decrypted(addr, alias);
+	ret = tdx_enc_status_change_finish(addr, 1, false);
+	if (ret)
+		return ret;
+	memcpy((void *)addr, buffer, PAGE_SIZE);
+	return 0;
+}
+
 /* Stop new private<->shared conversions */
 static void tdx_kexec_begin(void)
 {
@@ -1033,6 +1052,18 @@ static void tdx_kexec_finish(void)
 
 	lockdep_assert_irqs_disabled();
 
+	/* Drop image aliases before the direct-map walk makes pages private. */
+	addr = (unsigned long)_text;
+	while (addr < _brk_end) {
+		unsigned int level;
+		pte_t *pte = lookup_address(addr, &level);
+
+		if (pte && pte_decrypted(*pte))
+			set_pte(pte, __pte(0));
+		addr = (addr & page_level_mask(level)) + page_level_size(level);
+	}
+	__flush_tlb_all();
+
 	addr = PAGE_OFFSET;
 	end  = PAGE_OFFSET + get_max_mapped();
 
@@ -1160,6 +1191,7 @@ void __init tdx_early_init(void)
 	 */
 	x86_platform.guest.enc_status_change_prepare = tdx_enc_status_change_prepare;
 	x86_platform.guest.enc_status_change_finish  = tdx_enc_status_change_finish;
+	x86_init.paging.early_decrypt_page = tdx_early_decrypt_page;
 
 	x86_platform.guest.enc_cache_flush_required  = tdx_cache_flush_required;
 	x86_platform.guest.enc_tlb_flush_required    = tdx_tlb_flush_required;
-- 
2.53.0


