Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B785CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10C18E012C; Tue, 12 Aug 2025 09:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0FC8E00E5; Tue, 12 Aug 2025 09:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8643D8E012C; Tue, 12 Aug 2025 09:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6DCA68E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:27:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C463140332
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:27:00 +0000 (UTC)
X-FDA: 83768181000.09.7DFA0BB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0684CA0002
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:26:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IZdmiskg;
	spf=pass (imf25.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBDY9caHiLZSBdqQj+HzWMgmCJ6zu6xj7R4xJfDcWQE=;
	b=ka3L/6OqPqXczvqwmBeH34vXbKQJaa1gLj6CB4XmAG4lrgGu/RWx5GxXlArVlUcIsC6xUJ
	/u0/9JAmRUCWYaYTlanjnQwrp32s67N4zk756/giXW3Eua6SlXY/Ghict6LExJUffVOwpO
	cwSI6nUC9GefN/4XzPdVwVwBkGmudVc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IZdmiskg;
	spf=pass (imf25.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005218; a=rsa-sha256;
	cv=none;
	b=VG9yX75HmAmNZxCIvB3FR/raW2q/MPJJWL7baAq8o9EbSvGKw/TVLmrp/kDzLINqToRNz5
	m0y8aa2zozVBfn+xKVck+LWsagJFa7q3iIwU7WHUG2BIf4K1Tq8I/x2l24Lf1PdzOZTlvN
	IUQL4eqWeFKdaG6aDhQ3aqS9OsUXX5c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005219; x=1786541219;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=svwcdRMIJEw5xAT6fmvSyI7M9DNKZMAHSataOorEZqU=;
  b=IZdmiskgb5rDGcCNmk4lW22n1/SBDCq86PwNht72yAv51OWcu8vK5VVB
   UCKld6lmNKqwVf+mYYp6vF2+dnWcOhXDN2hk161wRtuzo3lEIC/V7C4rG
   3bfAmbQ2Zq4iYl42SVQ1Hh+MO1OAOc5jOZR1pOIL4HR0ngyFQoI8sUAQ0
   N+l9rczPfaAJpWlENvqWy8ovpikSkrEJfR7pdTjAQyCP7md6YsT4c0hl9
   ahHVMhRuIlnAoi2isrXh28IpEtxlcjSAib19noAWxKaZyXqpamoy5wEXZ
   BLScwgzs3eMTxVIp/MUvlNrsVeSi135P1xZ4APwwHfF7HL+ReBLP5X0zJ
   w==;
X-CSE-ConnectionGUID: eYJxQ/W1QOWRewxyp4mYtg==
X-CSE-MsgGUID: r074Tq1+Q7u5n46cjS4phA==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60903312"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60903312"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:26:10 -0700
X-CSE-ConnectionGUID: fEBGC8HBRSeUSf2GiP4qhQ==
X-CSE-MsgGUID: dKdrPa1TQk6ZCZHGur3yuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165831361"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:25:43 -0700
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: nathan@kernel.org,
	arnd@arndb.de,
	broonie@kernel.org,
	Liam.Howlett@oracle.com,
	urezki@gmail.com,
	will@kernel.org,
	kaleshsingh@google.com,
	rppt@kernel.org,
	leitao@debian.org,
	coxu@redhat.com,
	surenb@google.com,
	akpm@linux-foundation.org,
	luto@kernel.org,
	jpoimboe@kernel.org,
	changyuanl@google.com,
	hpa@zytor.com,
	dvyukov@google.com,
	kas@kernel.org,
	corbet@lwn.net,
	vincenzo.frascino@arm.com,
	smostafa@google.com,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	andreyknvl@gmail.com,
	alexander.shishkin@linux.intel.com,
	thiago.bauermann@linaro.org,
	catalin.marinas@arm.com,
	ryabinin.a.a@gmail.com,
	jan.kiszka@siemens.com,
	jbohac@suse.cz,
	dan.j.williams@intel.com,
	joel.granados@kernel.org,
	baohua@kernel.org,
	kevin.brodsky@arm.com,
	nicolas.schier@linux.dev,
	pcc@google.com,
	andriy.shevchenko@linux.intel.com,
	wei.liu@kernel.org,
	bp@alien8.de,
	ada.coupriediaz@arm.com,
	xin@zytor.com,
	pankaj.gupta@amd.com,
	vbabka@suse.cz,
	glider@google.com,
	jgross@suse.com,
	kees@kernel.org,
	jhubbard@nvidia.com,
	joey.gouly@arm.com,
	ardb@kernel.org,
	thuth@redhat.com,
	pasha.tatashin@soleen.com,
	kristina.martsenko@arm.com,
	bigeasy@linutronix.de,
	maciej.wieczor-retman@intel.com,
	lorenzo.stoakes@oracle.com,
	jason.andryuk@amd.com,
	david@redhat.com,
	graf@amazon.com,
	wangkefeng.wang@huawei.com,
	ziy@nvidia.com,
	mark.rutland@arm.com,
	dave.hansen@linux.intel.com,
	samuel.holland@sifive.com,
	kbingham@kernel.org,
	trintaeoitogc@gmail.com,
	scott@os.amperecomputing.com,
	justinstitt@google.com,
	kuan-ying.lee@canonical.com,
	maz@kernel.org,
	tglx@linutronix.de,
	samitolvanen@google.com,
	mhocko@suse.com,
	nunodasneves@linux.microsoft.com,
	brgerst@gmail.com,
	willy@infradead.org,
	ubizjak@gmail.com,
	peterz@infradead.org,
	mingo@redhat.com,
	sohil.mehta@intel.com
Cc: linux-mm@kvack.org,
	linux-kbuild@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	llvm@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 03/18] kasan: Fix inline mode for x86 tag-based mode
Date: Tue, 12 Aug 2025 15:23:39 +0200
Message-ID: <0ee6ca89ff7617fe7a4eda63ef5cf376d609ccdd.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qc1japx76hmrieomb3p75p3tkgdze7qc
X-Rspam-User: 
X-Rspamd-Queue-Id: 0684CA0002
X-Rspamd-Server: rspam05
X-HE-Tag: 1755005217-95740
X-HE-Meta: U2FsdGVkX18BQVqoXui+34Ana1y279ODn5O3qXLom8HgvByPqnwzgdlXUNitCHHygAn5pNuKvdAhxTvVEvnndL13cHsoZrV9CIY64lf4DSLkQ1+PHkOEszzsuRQBH7J7Ff9yNoTH4bwaRkkb3TKOh0dprfY4f5VvGvpvlbKAtDlqkVlSHL2Ck0pr1LasyzugYvL+AyXybPK9+ompPx1uAS4HF/Y4kd3u8u2WTgJcH7NeglchHraHfYiHrFIUfIsSHTStDKEvVW1kC0RffiL1oG3IOVVZ4zZIoJx12mOAw+X9EdLAhzHG6xJeWlcV04FykZmqnStfbn+FCUcORmrA+Si0ZMuAeFkExGiyjZ3j8sD/2MnGDxCvOKIIBPX6NSLmKP0DvcYeqHyHwB8seB7pKdSJ+9A0Fs1H8NzDljlYWY95OAzwr2/swGPn/79TAlMhlKxBpNpdISHpfBXpWmxFcJTl0HyyvEsK0pnXPTQWop9gS6S27OYJl2cc9bwJc4FNVyKbqdYLUszS6zxx4jedSuObwyq8ILCqi037oLOpK/T3b4D9vSqTZ4brwODZ3H23WahTAHCYRx25AUrukYLecxqo5fxRJMOu7s8GtpcM0BZ3eINeswxSHigmAibHm68dd7M2LCuHEoCJufdRNWSMbjUI8pFFn3SRvxmHA2neRI3ZCMmiaCVCsPD2uSR27Gtas5Fh5/HpCk2V4VjquMeUd9Vt8j8JzGZULnrKYiUeQYyhbY16pwQacRcyokRdy91Zh7lJYSuAQ4XiXt3d643r22MmZDe7GcMhKocBIy17lK6cAnrZ1NlyTgihrJ4JTBpM2L3qJeOwetaIlm8DJvY46dFar2TEiQRp7EibgEuvQ+BeZH8T50MjljMBDE/8DNt8YQbDAkQ2XSNKWS5/JbEFpo1NpLHK0B5DQpTNY5Lco7QhUzqO43kh6RooNA6BexTvNmyAfGVI0XgMwGJBQ8c
 xPJy+Mqo
 RT+Hclw2XQWceJmQNrLdZcvwj814ZAgU6KTIxPd/0b6fL8L4a0NRezN6YvvE19ZpHKQ1wMojULPnYwmOcTPt6SWxg9oWySjsfPL+wnRGGnxgCRZLKOZ3z8yFpVrS5+DPAebai4gNClTKWxtBX26Uiw0MX0NDgjgmcY4Dbzs6HGFm/d3dWgVgOJWaqC2H7Qh62vuW+VNLrJCdDjbiNg3dm6Ef0kxEisfIW3t1yJfzs9xxQ1TVOtMF50BYGRksDyFvsBFkl
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


