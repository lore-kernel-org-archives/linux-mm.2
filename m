Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33865CD5BD0
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 503CC6B00AA; Wed, 27 May 2026 20:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41A0D6B00AB; Wed, 27 May 2026 20:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DE8B6B00AC; Wed, 27 May 2026 20:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 150416B00AA
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE4B31206E2
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:40 +0000 (UTC)
X-FDA: 84814978080.14.0CF4E78
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1209E20003
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=W9kAPBs8;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf31.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XqGfPBcF9bFjDUhWCxrpIIXmVyxEM9VuCw6U3fAvno=;
	b=eJAyuwddzlVPMFegK7RMjcc0bBaSX7vBSNcvSMIvmwyH3JMv2BzlTZNt04FaakV5C0z8b/
	oXJ1FnalV/J62Xcdhn5NkgPze+77Jsur0LFdAtznI7BUkuSk/oe1H/V4m1D99Fsvp0AYUd
	zwd0jZ0fj2vYwcvBQoCLpZ6NNABZ7tE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=W9kAPBs8;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf31.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928959; a=rsa-sha256;
	cv=none;
	b=61IgiqKhJkOoRt8VTrlYTP+jfORsRTNHsU4Enn0fEEpVoVAS+heNTrZd7Kvwyasg/0/Pnk
	RG9Z1zUOvIHs1Sja99QLC5g8X4vVp9Df9rvZPMxnqt85/AxUVYnI9KR24NMORoMZG/xSsi
	BKeTEUhAbIBDa1iFeTpyd+VZBQPrB9M=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id F1B1220B716D; Wed, 27 May 2026 17:42:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F1B1220B716D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928947;
	bh=8XqGfPBcF9bFjDUhWCxrpIIXmVyxEM9VuCw6U3fAvno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9kAPBs8LwEWBV0ebKB/ahPWQuFzeLJ6xNmCYxKujyhsamuhvAAWjEe9z72dZsEtP
	 kUds189D7aKJHbd3LE6QYUtwgD6foSF58eDpH1+s1/eKnLq5WuYzt8Hoz7lXKZV2Ts
	 rilWfX9z+RcPy4AxdmmGO1/QNhU4PO6QOAMxD7Qo=
From: Jork Loeser <jloeser@linux.microsoft.com>
To: linux-hyperv@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jason Miu <jasonmiu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kees Cook <kees@kernel.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Justinien Bouron <jbouron@amazon.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Kelley <mhklinux@outlook.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Subject: [RFC PATCH 19/20] kexec: export kexec_in_progress for modules
Date: Wed, 27 May 2026 17:42:01 -0700
Message-ID: <20260528004204.1484584-20-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6g4chwozz4yc3qpo9kt1eynqrkzfigx4
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1209E20003
X-Rspam-User: 
X-HE-Tag: 1779928958-329494
X-HE-Meta: U2FsdGVkX1/J2gk7htg/qAiZ7M9z/lERk4hAP2vbd0uLxF9BYRdgsB8QpULkVJxr2cZ+ZRQJJrLj+jm2DIzQkqh9vW00jTWgv2Dw+0p0MDyGokMF58oWKX27fWGcIeeRQYF8mA0OYOCtU2gg+uOhbhUW27FX4zr3QX/ysJe/XSEAqi4z9N7ojVpVTIBJ1WltXYMtE9OAeis45RK94/4C9lKnHNXdwvG8etSnrLRTJBWx6ntdeo6Z2OTMhciIMrIsatbtigNa7PZ+WFEMYSczsGJAZR5fi6z39axRekehzXK1u6l68yywHSVGMQ8nQnINWebkabKeTDiocWAxPUV1JpAvfxMc4Ce4Jg4q9kqj13WqffMsMrdn6RrhHNosI/8/L+KamrVylYxedH6HLvPapdndc+yN4wRowjksOZCEji1TeNynX+6VYT7k8mc3QjlRI8TmVyYTl0wPfkxZM1y8U8TRyWE7MhzFBp9JNm+/eG2LAtmN3UwyjqgFUepl/Jq6QGNDtBVQDJ08jLtFQt7CLii1oqfJey8NoSwZICztFYtoxzTh+t/w6nZeJQqCdjGsqSgXgceZDyBvUAMucNRvI8cKNVq/pjRt47aIdLzTo1N9I4JWZl8LOGUv5nugZi4zCO0rgnoiJ2mJHVsHM6/9yo5/EIQln4FGZozmCDgPaEXAjFIiEzhJQTxqZVCc10/P5RodFe9BYO6Kt12kvNfUJ0CDQTSxVv6LmGKoRjcLsAZwMgBWYX6auTWmvbNvKLIK74eC3TMiFO21YCHM/nHXnFViDjF6GlAlDr6e6BnRsNyF4zXuMvswv7z2HjGIZH/N8H0E6larn/KpnJsiQM9kHA0URrlAATeN2JY/nE6LEM4JVk9SsN5JAxhA1hVT+gem/wKXIAnBHhmPetPLBMxYHUnH4My3AiJoOK9Ma+0aG0nQrGpYFjRA4N2RotZYzbn8XLgbDSj8Cz7iDC78oBv
 sGaGhtF/
 ZFz7pDnL9H6Ce/RtODv7dJPfaE1K+EdKWETUu9bvZpDwJDGol0gDNFsi+ve3U++lELnIrqKNDaI/BVigHdaibLS+MbJOyNFBABVYeMNk5exZw/ezq6vE9pGchCFya3Hsp5SdjfyBmbJKcsiMpdNaUxMR7OTSNVvtENNXOnGBjYDWm/gkvZS715bWPz/3UM22DioZfRegs1XMaR5oaWMv1dnfj9a2avUS4vxinO7M9XITnxDt4d7KbTihS3L6hUBWx4HRAFonaDchxhcDdCSkalH7ISwkNtf21ff5e24JPuLZFJYlzkbG9wcQDPoY9wYWUsv1fMfrknRryEJ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modules that register reboot notifiers may need to distinguish a
kexec from a regular reboot.  Export kexec_in_progress so they can
check without requiring a built-in wrapper.

Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
---
 kernel/kexec_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index a43d2da0fe3e..68efbba52fbd 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -53,6 +53,7 @@ atomic_t __kexec_lock = ATOMIC_INIT(0);
 
 /* Flag to indicate we are going to kexec a new kernel */
 bool kexec_in_progress = false;
+EXPORT_SYMBOL_GPL(kexec_in_progress);
 
 bool kexec_file_dbg_print;
 
-- 
2.43.0


