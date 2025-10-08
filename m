Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8EFDCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BC908E0016; Wed,  8 Oct 2025 11:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 046268E0002; Wed,  8 Oct 2025 11:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9E9F8E0016; Wed,  8 Oct 2025 11:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D8EFE8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:30:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8735687D71
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:30:48 +0000 (UTC)
X-FDA: 83975334576.20.E50F1DA
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6247E1C001B
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:30:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=WQqVEjVz;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf18.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/92zpxyjeHvGlOVhJoOGNENC+jRdBRPJKKvWmFCfMhU=;
	b=1q9y/vwFa0ZH8u0vE6JIl90uo7dh1OrCMnLwUZD8382dHoVK2kM0wcNtt0t+/EVXLEDfjR
	Nqmxu2wpYjBqetC7ORKQpZunwRwmBgw7i4oqw5fbm34b+Ia5/E5XbYihy3wnLYE0tjz+RG
	ngbOr+LiC/Y5SAnp82DdCG9P2qIqE5k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937446; a=rsa-sha256;
	cv=none;
	b=ibUWUbvg0Suzn1dPkEI8etTK6zqd3tE5/Hu+UBtD9i7T5HLqJ7muL2uhxJbdCz7WDA4J/r
	nMQLwvj59NnFSDN49UTVcni60WueI0IDoAfoywYY+oD3/G65KREul51SBHuLxRwFzokesk
	83V794vUQ+9+npNX4Homrvx7b+Aou3M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=WQqVEjVz;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf18.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759937446; x=1791473446;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=/92zpxyjeHvGlOVhJoOGNENC+jRdBRPJKKvWmFCfMhU=;
  b=WQqVEjVz1gQP8JcdgdV+Zh1nN/KjphcFncqfgOcOM291zj0kbHnpm7X2
   yvGPzFLe+E7Vk6rRcCApG6I5efJk9YHZ9NKR2PS/78+f3EHmDe+ugIxyp
   JItC3Bu0MC3ydQ02Z0WoX5qm8uCCgenEkk89oRKb/uiMfBN0gjRakkq3e
   LOhfONYz6RaD4iMNO8Ovmf0uHzkmN2Flq5Dlxu+l5rhvwTpGs1gqu1SCm
   omjIjftdT0OYuj1Ug6f/uTWRf21jRQEHmEJYBTqqp3mFsTOKo/VB1LAFb
   K0h26+CaNpwYHYzOhZtexJ8wR9/z7gD8LkGGOt11tnR5vUPn2CsIlsKQu
   A==;
X-CSE-ConnectionGUID: UKCBinIHRXu1RbSMKoZX4g==
X-CSE-MsgGUID: RPRMtFp2S7WrU04wLGVbHQ==
X-IronPort-AV: E=Sophos;i="6.19,213,1754956800"; 
   d="scan'208";a="4410563"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:30:43 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.38.20:57983]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.156:2525] with esmtp (Farcaster)
 id 44875d22-f92b-49db-99ac-a03489ce84c2; Wed, 8 Oct 2025 15:30:43 +0000 (UTC)
X-Farcaster-Flow-ID: 44875d22-f92b-49db-99ac-a03489ce84c2
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 8 Oct 2025 15:30:43 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 8 Oct 2025
 15:30:30 +0000
From: Eliav Farber <farbere@amazon.com>
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>,
	<rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>,
	<jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>,
	<jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>,
	<dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>,
	<dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>,
	<senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>,
	<akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
	<pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
	<jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>,
	<willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>,
	<quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>,
	<David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
	<linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>,
	<linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>,
	<linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v3 03/19 5.15.y] minmax: deduplicate __unconst_integer_typeof()
Date: Wed, 8 Oct 2025 15:29:28 +0000
Message-ID: <20251008152946.29285-4-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251008152946.29285-1-farbere@amazon.com>
References: <20251008152946.29285-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D032UWA001.ant.amazon.com (10.13.139.62) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Queue-Id: 6247E1C001B
X-Rspamd-Server: rspam02
X-Stat-Signature: m8yh48t1dhfcomct3ypcrbofh95udggq
X-HE-Tag: 1759937446-910182
X-HE-Meta: U2FsdGVkX18EBPLDOAI5fj+IBrFEqucMgd3XkiAOArz/aMaa2c88YWv+NyU0y/hu5irG0tqrnzgFcMG6xEYp6G1uRPPzkJns/v54HPI2YfGwhsCTK8dhNt7AuHx7iV1inqh/Pkt0EeL6/b3lM7OcSRV6EGmgKoCZK9H813TzCG1nnMip2pi2u+47wDpmBjn1pVxK9XHAtRuqnMoohJ7odJ99yiMztNc98LevHeCC0lJmBhNerxDeeJr487ab0YtcB2v1yPKvY1+g70U3u9mE6a53GRE8dIDGJzFEy3Qa3QUHzThDXwO/LljIvusgpFOxgByd7Um3a5Gppm5QwT8l1QzEU19Narie43RbnSb4jsDzz2HF9mhOXwt6V/xHGOsRq+HKoqKl8TJ0BoTynberIoz0uvO+Noacqta6YLLI+/wXB6wF+LVQBlRGQRhyAMQCiasN662WGAoAnrPuCZ3hAnD6nMwr1aH2PRs84qs7FXGpMtO2H3kkhrCXyVZdijHKxdJtSZ50R3PvYgnwe1IppEFPQK0qO0ecAAdYqwlwnt7q4mrpH3X8SIZTYxlrXr+IbTS0pOJ51wgXyy/3Kj/QJzdPB4OMWRyZfdHgZRfOMPD37Em8h+ENbJSbww1Dh59h40iv9d/Mi0biXzf9AyqIXIINVKvT9cvyohH0Jnql6a7fFL1cDoK/W/DQTOi1wGgybFvXTfjnrSWHjVLKRc2EZBeUBEE1gTYV08AdEbgg75Gq57DYuAE7PZg7f/S2yIPtsQF3RYkwLZ1f+kUY/kOGu4kxUeENz1CPArc4B5/VtNtM0sgQGUKlE6SiJUmYIG0OAA/evmBbzTN0jsQsNNQ9GbkMl8V0l7tcpM1+xCeTeElA9HkLSueLs8pqORX00TnBTPHzY+pVslBtNjv6bDuLFDGR1PUWDjDRiX7LK/jWDOhRcN2SFCvss3Bm617JL5+MBpJtSMI96t9s8k8LCHH
 kq3nZnbp
 27ud97bUN8x3Agu7hILxtpC1M9mRAefZjotvDGcwAmn2pITfCqMB49K74614cH3yfXvihKNjYDw9tjMbalVJiQACjDj5639xLQSQai2Pqt4hsK0/S1+h9amdeFyZsdIcqHOJNpJKHasyggipbK5/D96bdfNIUXBORt6tisTeg5hT9hHcAOUXlbjJ9rFAQTTfqhuXh2OsG4T4TzTv9lL3JA+3e+sV/mdoQ0M6L1rLG9rTulQmoiWSwjH2iqX35erZZahizSpwmKGNhX9vBJPExzjnegHf10gm1FJZIwPTnC2JhblvLlvq7ReEMKpDEyperuyHYH9pQEIam1UpO+N76S7K2SAY9l009VK6Qk2iQ7cQE36YtiFbUr71DAOmAJpMR2pAiA6c9QmEZxyIoNit+KD9F1BPwjvIUW/pbgSmpWsFb+WXTE4vdWuNeB4DXTGu0Tx+Y65iFWyAZDqpyF+8YTLB9lqhzfCcdH+wShb9xHrzmTezRi+MvXt9s5Cnnaw8/azassRNg5W75bivtK6l+Rk4t+V/0fz2N3Ov8zIESbyOW9+Do4GqqTIp85IggCQVUshj3tgyHJe1DM/DcZvrEEqwsGyd8w0T3moqPOlve8B4TKHU9fDhTX63JG8e4j4AmtHgdQHXEIawWe4x2OXHvwRyXOb03oiFHVL3M38Q3kLgv7Oqhf7qh8UsBZ1Ic9n4hPigfW1D3245mysKQcfq/vWuf+vcFSMW7c3myVZrRCOxwdoUG+lbaRaMxA4344S8JQ6O/a4rNOKhxfDqy+0GWpCiqSbGdeIE+TYWRN/JLq1aVo5RLJlyGeXza63AE7nlneJhJYEYaN1xzorR+sUlL2ZvImuFd2TkXrzO3Nvxer/iFHlr9n9I6ahbUzvFZ8TaBAmviE0p1sHDAz77Y4s8aQ/4lD71EZRH5GTMJkaFQVNSEKjA7/B0B0ZZwrLh5pIyIx0KHog2e4ftk0oM6VaYOg8wAvQef
 WnuIjJm5
 4p3xE2+mOf86hm9SumJkWwxxdJy5+bZ2Oi8pwYmJOZAX2sfQBSbkERp3uGGh68MSNKoQ24vs3uKjz1HmgdMxpdX8EohRfSqV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5e57418a2031cd5e1863efdf3d7447a16a368172 ]

It appears that compiler_types.h already have an implementation of the
__unconst_integer_typeof() called __unqual_scalar_typeof().  Use it
instead of the copy.

Link: https://lkml.kernel.org/r/20230911154913.4176033-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index aac0b7d23768..62b0c0a3cf30 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -168,27 +168,6 @@
  */
 #define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
 
-/*
- * Remove a const qualifier from integer types
- * _Generic(foo, type-name: association, ..., default: association) performs a
- * comparison against the foo type (not the qualified type).
- * Do not use the const keyword in the type-name as it will not match the
- * unqualified type of foo.
- */
-#define __unconst_integer_type_cases(type)	\
-	unsigned type:  (unsigned type)0,	\
-	signed type:    (signed type)0
-
-#define __unconst_integer_typeof(x) typeof(			\
-	_Generic((x),						\
-		char: (char)0,					\
-		__unconst_integer_type_cases(char),		\
-		__unconst_integer_type_cases(short),		\
-		__unconst_integer_type_cases(int),		\
-		__unconst_integer_type_cases(long),		\
-		__unconst_integer_type_cases(long long),	\
-		default: (x)))
-
 /*
  * Do not check the array parameter using __must_be_array().
  * In the following legit use-case where the "array" passed is a simple pointer,
@@ -203,13 +182,13 @@
  * 'int *buff' and 'int buff[N]' types.
  *
  * The array can be an array of const items.
- * typeof() keeps the const qualifier. Use __unconst_integer_typeof() in order
+ * typeof() keeps the const qualifier. Use __unqual_scalar_typeof() in order
  * to discard the const qualifier for the __element variable.
  */
 #define __minmax_array(op, array, len) ({				\
 	typeof(&(array)[0]) __array = (array);				\
 	typeof(len) __len = (len);					\
-	__unconst_integer_typeof(__array[0]) __element = __array[--__len]; \
+	__unqual_scalar_typeof(__array[0]) __element = __array[--__len];\
 	while (__len--)							\
 		__element = op(__element, __array[__len]);		\
 	__element; })
-- 
2.47.3


