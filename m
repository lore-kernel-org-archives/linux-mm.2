Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AA66CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABD6E8E0009; Fri,  3 Oct 2025 09:02:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94B18E0003; Fri,  3 Oct 2025 09:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AAEB8E0009; Fri,  3 Oct 2025 09:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 896068E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:02:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21885C07D9
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:02:09 +0000 (UTC)
X-FDA: 83956815978.15.2A9E753
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	by imf15.hostedemail.com (Postfix) with ESMTP id BB017A0037
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:02:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ek118Tl1;
	spf=pass (imf15.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/92zpxyjeHvGlOVhJoOGNENC+jRdBRPJKKvWmFCfMhU=;
	b=wn5mgQDezPQEPpcFXYEKlVAmSO7d16Fn7gAYKjTRQ1kAO3QWs6FbraixhcyXA3aUn8MgRG
	QRXMsSw4y11lp06oyu2e6gS4zDoi1J2vGdk1ZniSdMUoXX75Sj0DF07wNLnpq7wohfIiH+
	X2yXDkhenllXa0FLtzSPGKO3+3wFa/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496527; a=rsa-sha256;
	cv=none;
	b=JZXBD0FO4N7lhPIM0QmZK5tS9OuNOm3j38p3nfKFd7yvPgSy/3b80wgvpbjIMNPvehVqMg
	mXQ61UwRf3HgI06wzRXiJsHw3lJ1yYfqD/1Bb2CndoiWADCKj0nL3UdmbMhU9OZ4VFXaXc
	h4kmgNXMnhFntz5K6Ij8oVuosbdzA3g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ek118Tl1;
	spf=pass (imf15.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496526; x=1791032526;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=/92zpxyjeHvGlOVhJoOGNENC+jRdBRPJKKvWmFCfMhU=;
  b=ek118Tl1Ctl++rQJFYmJRjdSGrR06SHrWn/k89i5TS+rgYPm06uFof9K
   kzYugtqH15GE+R/CX7MmGyTMo3nkkM659YXIlh1+fIM3KgiTAySGC25MP
   iFKYyQKmlz93JaWTKeYEbk/6BA6haqlJrFqJ9d5SItqfV7WQOaIxYvm1D
   FVaODKCCPdv/NoT4SiJaxSQ6EnTQXuw8go+eViFqrfBcag01XC/1/+jF2
   W4CnWQi9qSHQpu3Zxb0Cfwbul7qzzqlphiqta6tGI7fhsLLfcx4TBjfjW
   YBMH+hIbpl635LJfO3St1xHDiHRz7hEPD4Ki1+9R0qw++Pgyz54mQPAwq
   Q==;
X-CSE-ConnectionGUID: RafEjVVVTqyIShPdYFqaRg==
X-CSE-MsgGUID: gTGjwIVySfCFf42Ccz7DtA==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="2963638"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:01:56 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:5896]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.21.15:2525] with esmtp (Farcaster)
 id a2369264-a95c-402e-aa2d-d6344cca8b56; Fri, 3 Oct 2025 13:01:56 +0000 (UTC)
X-Farcaster-Flow-ID: a2369264-a95c-402e-aa2d-d6344cca8b56
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:01:53 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:01:28 +0000
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
Subject: [PATCH v2 03/19 5.15.y] minmax: deduplicate __unconst_integer_typeof()
Date: Fri, 3 Oct 2025 12:59:50 +0000
Message-ID: <20251003130006.41681-4-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003130006.41681-1-farbere@amazon.com>
References: <20251003130006.41681-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D032UWA002.ant.amazon.com (10.13.139.81) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BB017A0037
X-Stat-Signature: 57uf65s1iankdnrguz9yfimp31upmqzd
X-Rspam-User: 
X-HE-Tag: 1759496526-617281
X-HE-Meta: U2FsdGVkX18sUdCPLywVwvTwBmNtWQmiBzz0FNe/JsXR/uvFxu6l3FuznMhKmN5GqEavjXGBHIEhAE8qlfVkUYR5CNzHqt7O1qQ0yAZVl1LPkWop7mb+jpP7gK7mkmhuf25iSkU04FRBnoU9yZU0GMk5GHnqpQUDAbSjqIoeQWTkrvJNHJAyN3ar1X4mTdGsvuEf/CmQD12awhBCIJxSoqRRn5zt3UCd3Jt0uy/Rm9oshfb7YPoE1qQaD040X/kafqvxBGBkzWEUcR5zQkRe47atMZX0euWJHFkACkY/iPN/ctPrCNDkgMgTSr3ulizZUGVYznY0fi2Qf8bAyEpq+4F4SNDdfIiH0AinTM5T2quUF/w0wJ9TruSh0/vnKv3g0eTL9EeDJlGaPJnKD5sU8IMsykslQbuqXdqZRPbJI+Xzd+WAeXLcEBiDwiagnL8YVqHlARp30EZMcIa8dEjC8Ml8yPu/aDiSVCxqXwSCgfWMOKwRg0EB/XMoNF2CW88B79s6LCw0bHO1xBGJmWtgKaud3MErv85NFQqW/+Um1oqaqC5EmDgPrvy3hGElKXuOEzXX9GzCvZtQKpMdCT7BZqYo/Uoq+aUwDkWHeOu8vG7V7vBSciH2FiXP44oVi0cRDCi67tss1iRvpIDGxdxcj2yixjtrXMaENLTvvXByGLU+zIim9kw2AF5R/xl6nNqIOts6wmTqpHtHyh/pJHs+j9dHddX5NPxKgTgfJtTiE+9CV2mRoY30++gqi0OnybB4EQ2PT7lCF0tmjVbwbxLMz7m+iki++ZqX40DFW+saaMoq4tKs5ZNZ3MosfnYTG+7TkHN9VDd754jWXa7kjQiZFno5k/oQB9clLYi9JJcBjW7wQsqrXw9AhiIOdflje+3LsmEJeSVycoy/a3ghxODYBVcoDYspmTeIFN3zpSn0Fgm+Tt8JilQxTE2+JRCWxcvzN4P/vOCdnBbWrS5HqmP
 zZMZrcJx
 UriDlmhAol2WEZj6Kht3RjVSrJC3i9CldSeIiUq7BIo5rrg5Y8opKHEAR8ynUXLeP6o3MM4/U6LRvr5C2H5UZtGJEcKTiqO517oMAd9QoWTLVmtlO9Oo0eSlf1/48jNqUbJRrqm85qE2qnM5Jmmnf9RUXhXcxyHINySZFmNnqNWNfnSts+ITZ+lhb3VS9xaCoeu5vKbJTFD35+XUNmxNpeMpw0fifkP/07roCuIebzRCd3Xki5ttMQgHaZv42L78y+R40+miljQLG00aV+b0fwFZPIN18Lkq+uzDr2UsMLQwxf0MhCdbFWXrV3spaPFjNBPiwwYNORT0/JPxCwvoL1HYlMNxoMFL9TsA4ZIW+JyTyHoXh4kGDxvXqHq02yI12AEJp9IZJbJDJqVZ7z4zBSU3uJPXwlBr9MXRnsXLvAEFN50wiUVHLLLxXyaxGOaXlcsYWtXkt7GOV5bH4cvtJCDPY8kZkhe0w6xgS4aBwZH5JD2RuAdLfOwekljz9vYg4dUepAD06Z9qzfC6RDnRMvuQJg5XskFdZjRz/HBm3Ic2xTENxS0Efqv1+RDxGv1B/n/xxcATQn7n3tJDdJSEmGDqWexmsAUiLFhrymhhp4tz2Ab3aHygdEbnodWPyUhinaqe6K/JBoluKgx8NCe62VCNSFO+Afyc9/guydNqCE8vABDW4kAaV6aYPvCpzXyMeN93SUxF4BQyBgoOxerCjkbY1jdMtT+LBDekLHA7UG53O2G9MEsQJ9EfJdKrPzK+Eg+g+v0cuqudPojPtZxnRUqVIfTON6IgHe4Uxsi1K/rJkj511NJIf9dOLc5SdjapoLRh8nZwuskCmaxmyF2ZD9CCQ/P+FhD+lFEAjDEKCaDfN9R3d99vGs4NnPRjNTx0NnLVKVdPZEkeR4nRGtkXnK4T/W+yZuMFccrU/vEOeGtGUDnsuNi2kyYYaP8TF6FskEdLbrMU2iRX3Ll2VdSrkAwv1td6R
 YN6gASoo
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


