Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D6DC8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCB208E006F; Mon, 25 Aug 2025 16:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA36B8E0038; Mon, 25 Aug 2025 16:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABA008E006F; Mon, 25 Aug 2025 16:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3818E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:26:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4486A1A0573
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:26:38 +0000 (UTC)
X-FDA: 83816412876.27.CB883A4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1B22EA0008
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:26:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="XcD7z2+/";
	spf=pass (imf25.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBDY9caHiLZSBdqQj+HzWMgmCJ6zu6xj7R4xJfDcWQE=;
	b=NkN0Nydc4cGTijAP5zWjktY9tSZATwPfY5Vlfnt+EHenciDO3/ZCEpraeLkiOOCJ9FOod+
	6kppNZnOFVOEcqtbbns6JYFKaBLSJ4vxMtXqOmca6EggxVpa1NRxJmpD3t2QLUvx9KNbkR
	G3/hRI6j/HlsVX4rnc+eHXyGn1d/p5Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="XcD7z2+/";
	spf=pass (imf25.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153596; a=rsa-sha256;
	cv=none;
	b=N4gQBv9xXuMrm2xo0RDoMtkky8jDYO0VI8+/J5r+UKxVo66RKvEwwK7cebHESd+oDzrrRx
	4gpOBNX13d8Zeo+epNL1qv9djGoma/k0Ho6Ahe/kxgm4h5nsEu8+YGOj/Wmmgjdlrm1Tq8
	z3V5TyTNqa1efzKMf+WkB+CxNmmS+gM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756153596; x=1787689596;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=svwcdRMIJEw5xAT6fmvSyI7M9DNKZMAHSataOorEZqU=;
  b=XcD7z2+/rv6eIklzKZ4d7R+2ufggwpmHDaEbrd/pb11jATPDqoQSZHf8
   3PFj/PO9br5821mY4dycsfeyijM9jy3ZT+X5lfiHmddfYtD2ax8NQHhi/
   0xjBOoOz9sm+GKb9XHytiTMIrh+HhheziX2JU5mp6DHKHC/uOgLSIcjLi
   rJNEkv8jGGUb04LbjpNd0G5XxTc6JibEt/8o7t2gKg3vxnO4QiSli15ky
   57KF8LeUEz9oBHm6XUaBRxwXY5D7y12kofbGpNXTxW2Zp/HGDS1j6NZ+u
   hZ/1cY6odnaJXsxKc7xqwR+dmRGM8LnfJgzGUBcAq/gdSvqcKHQe30k2s
   A==;
X-CSE-ConnectionGUID: zYp6EU+MSPmwZuGfr9xi2Q==
X-CSE-MsgGUID: QNsfifCBQteNpT87vbyHjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68970366"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68970366"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:26:34 -0700
X-CSE-ConnectionGUID: iIqUDEsESZCpnMn6v7RjVA==
X-CSE-MsgGUID: 2PEh8pueQKehSA2GUwmUug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169779925"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.6])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:26:15 -0700
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: sohil.mehta@intel.com,
	baohua@kernel.org,
	david@redhat.com,
	kbingham@kernel.org,
	weixugc@google.com,
	Liam.Howlett@oracle.com,
	alexandre.chartre@oracle.com,
	kas@kernel.org,
	mark.rutland@arm.com,
	trintaeoitogc@gmail.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	joey.gouly@arm.com,
	samitolvanen@google.com,
	joel.granados@kernel.org,
	graf@amazon.com,
	vincenzo.frascino@arm.com,
	kees@kernel.org,
	ardb@kernel.org,
	thiago.bauermann@linaro.org,
	glider@google.com,
	thuth@redhat.com,
	kuan-ying.lee@canonical.com,
	pasha.tatashin@soleen.com,
	nick.desaulniers+lkml@gmail.com,
	vbabka@suse.cz,
	kaleshsingh@google.com,
	justinstitt@google.com,
	catalin.marinas@arm.com,
	alexander.shishkin@linux.intel.com,
	samuel.holland@sifive.com,
	dave.hansen@linux.intel.com,
	corbet@lwn.net,
	xin@zytor.com,
	dvyukov@google.com,
	tglx@linutronix.de,
	scott@os.amperecomputing.com,
	jason.andryuk@amd.com,
	morbo@google.com,
	nathan@kernel.org,
	lorenzo.stoakes@oracle.com,
	mingo@redhat.com,
	brgerst@gmail.com,
	kristina.martsenko@arm.com,
	bigeasy@linutronix.de,
	luto@kernel.org,
	jgross@suse.com,
	jpoimboe@kernel.org,
	urezki@gmail.com,
	mhocko@suse.com,
	ada.coupriediaz@arm.com,
	hpa@zytor.com,
	maciej.wieczor-retman@intel.com,
	leitao@debian.org,
	peterz@infradead.org,
	wangkefeng.wang@huawei.com,
	surenb@google.com,
	ziy@nvidia.com,
	smostafa@google.com,
	ryabinin.a.a@gmail.com,
	ubizjak@gmail.com,
	jbohac@suse.cz,
	broonie@kernel.org,
	akpm@linux-foundation.org,
	guoweikang.kernel@gmail.com,
	rppt@kernel.org,
	pcc@google.com,
	jan.kiszka@siemens.com,
	nicolas.schier@linux.dev,
	will@kernel.org,
	andreyknvl@gmail.com,
	jhubbard@nvidia.com,
	bp@alien8.de
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 03/19] kasan: Fix inline mode for x86 tag-based mode
Date: Mon, 25 Aug 2025 22:24:28 +0200
Message-ID: <98d2c875da80331a51a5c61e8a67ca43fc57cbd3.1756151769.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kjsj15tag9ruw5mj5iiupsirgoyfgbnq
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B22EA0008
X-Rspamd-Server: rspam05
X-HE-Tag: 1756153595-354283
X-HE-Meta: U2FsdGVkX1+28e9T95WSLxOodDrfiaoMWbsyNSDRH78QboG9RwHLTy8RgeYnoTC9/9ZcOsUDioGeoXSvzvdc8Vk0lS2xEFqFeg4gCP0CUZwu0NgHMT9lAR21U3TuDJXkNty/8izBApw+YuiUPzA89Fs8NkH28eyLFaVpwb0CkJkGJUB93Z99SPjJYLgGq9qA/jqcYMeTW3eG3nUVKuoRJPFg20dEsC0q5yhMbXgDC8cjdPBSK3CXrICOqR5JhlO/Sq4NU+6AmDgdRhziJbmmZ4KUonDFjoMAWeCXH2I5SBjrNB0THSYgzxkzoIztMdHWVGTMPRKbH8+01BsOOShoH1uD7LiWL0NCm8BdVgaifG9hEnrqnldh0rUsRtGNowe/5z1U5lr4RsJ68B5Sq9LMRVikT/0fzphu24BuMG8u5boOUEgjMDwT8EMeWJ1A5DFumdhiLt3wf66zD4mIyZGkWSOEKVZaEO9UdgwOs7MKvOJSIHOfrD2l1bUx+a/0Zti2w4KxtTt+FhCzhnAtjEZIy/e+BSMLfJBkjTk9IonKmjqWJJ8wucRbyNQdxO+Tdy+Ss5SQuz+7wrmzoLRnyROFXhYfqBW9id8rqHGjrKxiwoZ7iz9jQUJ0U6LDkdWwNk/h6K/42Ar4cnl2lyKl2of7gWYLcZIpZCGMmcV3clxQnyol5XyUQ1MVgnq1NWlRJZ361Y+Z9gr49eyQH5g6DnB4UHJb6f5C46kPSo0Rb2LXLIIxHlpePnuYqSxJBADFnEDaBH/dqLR/ezxeEWK6Q7dJyKqKzuaM8ads8bmQa5pVOiIaJa1gpYLWC/bwloR03PrCCbbcqkJghbBerKiLwdR2YIbNmWyqfXU6XG1eajVgdr8RarxVZKGBgdADIWo5SNdUttNwNJza4EKrBhMV7FygihVTrrKzDlZsPjqjEvI+jo8KtvL6eKyXu7lYn/m5jPXnCB5gZNNrdvF28AUy5PE
 3RjnSU9c
 X8YHKauu2E6NrDiK+OYphuGhCsCUmBEPP/nHim1alOlZIgZaSxXlI7+37EGB/QGa8ZxT4l/ZEkra637pGScM2f5RlBUlGqlSxWEVgccUCg3SbuPeHtGRfWokrj5PumSWojg02Hh3TvzTRXpDe930FaLXBPbLTyPMsl50h68GFGBW+HGoOYtUnI82b0uPrMKr1dgM2eqITc4NilH2U4VcgxE4uznxxJx9/Kl9DVqhdwHwkqcAZQMcljGOXw6sE3ww/IMRc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The LLVM compiler uses hwasan-instrument-with-calls parameter to setup
inline or outline mode in tag-based KASAN. If zeroed, it means the
instrumentation implementation will be pasted into each relevant
location along with KASAN related constants during compilation. If set
to one all function instrumentation will be done with function calls
instead.

The default hwasan-instrument-with-calls value for the x86 architecture
in the compiler is "1", which is not true for other architectures.
Because of this, enabling inline mode in software tag-based KASAN
doesn't work on x86 as the kernel script doesn't zero out the parameter
and always sets up the outline mode.

Explicitly zero out hwasan-instrument-with-calls when enabling inline
mode in tag-based KASAN.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v3:
- Add this patch to the series.

 scripts/Makefile.kasan | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/Makefile.kasan b/scripts/Makefile.kasan
index 693dbbebebba..2c7be96727ac 100644
--- a/scripts/Makefile.kasan
+++ b/scripts/Makefile.kasan
@@ -76,8 +76,11 @@ CFLAGS_KASAN := -fsanitize=kernel-hwaddress
 RUSTFLAGS_KASAN := -Zsanitizer=kernel-hwaddress \
 		   -Zsanitizer-recover=kernel-hwaddress
 
+# LLVM sets hwasan-instrument-with-calls to 1 on x86 by default. Set it to 0
+# when inline mode is enabled.
 ifdef CONFIG_KASAN_INLINE
 	kasan_params += hwasan-mapping-offset=$(KASAN_SHADOW_OFFSET)
+	kasan_params += hwasan-instrument-with-calls=0
 else
 	kasan_params += hwasan-instrument-with-calls=1
 endif
-- 
2.50.1


