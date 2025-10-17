Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A1EDCCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5D8900003; Fri, 17 Oct 2025 04:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56C58E0016; Fri, 17 Oct 2025 04:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C43DF900003; Fri, 17 Oct 2025 04:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A6A238E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:05:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 537A5479CC
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:05:57 +0000 (UTC)
X-FDA: 84006872754.04.B5040F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8FE8FA0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:05:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=JcEpuLh2;
	spf=pass (imf25.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760688355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=Bng1/1BVXUk1NKCno716V5LgVGQ1BNvdNFZ4NcMDgJ0=;
	b=Kcjlu6ECYwfRJ//xc66vpaEDTE1rr4H2Uaq7TsW9SrR7QTvM4OJG6r1QrQbpECVh9y3p/7
	hpUm3O/I02UZKdOOHRF78KjMiw2X0SDAQdlLjI6pYLYFj2I2M8kW4XbFQ+YZQgCeWw8sbC
	ytUr+7aGDZbqC/8tMx1hI8uOjUjFSYE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=JcEpuLh2;
	spf=pass (imf25.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760688355; a=rsa-sha256;
	cv=none;
	b=DZBTVfNHUipXrVaQ7nWsT6ha+ixGU4j91rj9mc48DVwZWJv7NxiSuMurimVOY2qRJFbwie
	dH+4JHwFYUAWs5MuIt0JiVS2JVWmQ8IRVC2l2lm8Lr9dfS20q4YSjZDNEEMNYY0f0DGC/y
	Wlfv6CFY4K+vxilBF6guUM4pLB92ZEI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 782DD45A8B;
	Fri, 17 Oct 2025 08:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA077C4CEFE;
	Fri, 17 Oct 2025 08:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760688354;
	bh=YOfE2dusPxaWBKd8nlIpPYnwK35lY1FgnMY8GHpw1To=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=JcEpuLh21dmJKWXrm44O7oJmNoJlFlyi6s6Dm4FuBhtcupBDvQfT65Prt1n2HtDBS
	 xBwgoRWEMXdLoAOER/yaeb8+GPzvm2l22izBRaXSxpokwLD2+iwF22GcUPcwpdXo/6
	 7LDHOeaqaB3dcdM5iV5xAE+D8EaLIejXTBoGK9B8=
Subject: Patch "minmax: Introduce {min,max}_array()" has been added to the 5.15-stable tree
To: David.Laight@ACULAB.COM,adilger.kernel@dilger.ca,agk@redhat.com,airlied@linux.ie,akpm@linux-foundation.org,amd-gfx@lists.freedesktop.org,andriy.shevchenko@linux.intel.com,andy.shevchenko@gmail.com,anton.ivanov@cambridgegreys.com,bp@alien8.de,broonie@kernel.org,christophe.leroy@csgroup.eu,clm@fb.com,coreteam@netfilter.org,daniel@ffwll.ch,dave.hansen@linux.intel.com,davem@davemloft.net,dm-devel@redhat.com,dmitry.torokhov@gmail.com,dri-devel@lists.freedesktop.org,dsahern@kernel.org,dsterba@suse.com,dushistov@mail.ru,farbere@amazon.com,freedreno@lists.freedesktop.org,fw@strlen.de,gregkh@linuxfoundation.org,hdegoede@redhat.com,herve.codina@bootlin.com,hpa@zytor.com,jack@suse.com,james.morse@arm.com,jdelvare@suse.com,jdike@addtoit.com,jejb@linux.ibm.com,jernej.skrabec@gmail.com,jmaloy@redhat.com,josef@toxicpanda.com,kadlec@netfilter.org,krzysztof.kozlowski@canonical.com,kuba@kernel.org,linus.walleij@linaro.org,linux-arm-kernel@lists.infradead.org,linux-mm@kvack.org,linux-stagin
 g@lists.
 linux.dev,linux-stm32@st-md-mailman.stormreply.com,linux-sunxi@lists.linux.dev,linux-um@lists.infradead.org,linux@rasmusvillemoes.dk,linux@roeck-us.net,luc.vanoostenryck@gmail.com,luto@kernel.org,maarten.lankhorst@linux.intel.com,malattia@linux.it,martin.petersen@oracle.com,maz@kernel.org,mcoquelin.stm32@gmail.com,mgross@linux.intel.com,minchan@kernel.org,mingo@redhat.com,mripard@kernel.org,ngupta@vflare.org,pablo@netfilter.org,peterz@infradead.org,pmladek@suse.com,qiuxu.zhuo@intel.com,quic_akhilpo@quicinc.com,richard@nod.at,robdclark@gmail.com,rostedt@goodmis.org,rric@kernel.org,ruanjinjie@huawei.com,sakari.ailus@linux.intel.com,sashal@kernel.org,sean@poorly.run,senozhatsky@chromium.org,shuah@kernel.org,snitzer@redhat.com,tglx@linutronix.de,tipc-discussion@lists.sourceforge.net,tony.luck@intel.com,tytso@mit.edu,tzimmermann@suse.de,wens@csie.org,willy@infradead.org,x86@kernel.org,ying.xue@windriver.com,yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 10:05:10 +0200
In-Reply-To: <20251008152946.29285-3-farbere@amazon.com>
Message-ID: <2025101710-unclamped-refract-c17a@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: g843mxqw8nt9yx4739czdkfwsdz7rnec
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8FE8FA0006
X-HE-Tag: 1760688355-20165
X-HE-Meta: U2FsdGVkX1+sld9mRJ/6BcyMWsrXK6oBF3QLcLKOZi/P8OxhsvS9g8CTZKiXgMMOFdVniRdggoLDfjsqO616HbbUZ+uFIv5ozKl4qeagRIuy/xlM8JTo1YSzyUV2wJfF+5BgdP439c6C+kmLLbUucWKy6330J2YYtYxUhQrKMTEl2Melg5WK5Iwyp6LhTB47FNNFB/kFZHWFxM2cBeziH5oWxtRidIQxFNopQK/Xvy/H1p6P6g719TKYBv7f7uVE5q/nEHZOf1l7Ya7NDwCEFUg80yShqV9nXd9vVa5d06YShvPJPAgcuEHm81P1NDpVmyKViAu0kZSrcdnNI7MzjFt+3oqapzBx40fLMpeEu9JMgjWr4ojewDBWDqRrF89UqLIo6TVf+jsXys+GsVz8Ryzs2l+BgakwntahbxxlYZ6aUeGZbGcu1wQa6bFZT4fxNJC6n2Ifz0IMl2B7N1o6CrP7IldeQTyxoB9QCbhTvknmaObSnItR2rcpbkfoi0D9JD+OTxk93ABLaGx7B8muf1blW/QzXmU94Xa3w87ZrsASJteGRyAY6TxyrCTh+SjiQzd9cCNE3NzN7c2wU1TG8Zf0TpskSkPfjzJYl/amxdXxnWBqE5/htuPGwah/JKdmCvozq1TVERTD3xJgTK5yevwxoJgmmPqf7nup/ys4DKJR10auK7WTXDYiYXZ1/XtPVcSuQbPbSP636qL/88n8+GQhnpGkgdWcgf04Y/kpugKzuV/1Css6Zf+rcuo1xDPQSM+vLkNX4caMqPEeZk63p3ay1R+3r09qMfNIiDYNKkUDKU4MQn5nUY+M6+nnj1h7eYexFyXZQtDDz/Svwfgu+Y0e6VEcUv/wc62kgLBwX3MhIz1fFq4R2cJaWLwkHpc4u9pUVd/Au4lTOZwW3cEkXhqiIgOrrrc4TdSFar0sgPESrIKWBBqrI3ZYOnngo7L2QYHg6vfzgbMdQOl4SwX
 daeQtLAy
 Tl8+q1FFxUuXgJbpt0W4qJ5RZe3B45UJVm0qT7lePASpz3oQAYB9IGBNC+NXXdBQeB5x4ekDOt4bE/yeYcaUR3yRwlWt4OSY7vM2aHAEORuL7F9GaVIIh+LkgH//mOenai/Rut027kzucKjc5p/TfHCGFD3klfwkH/V8GZS0A7kjt1+cYewqRwicZOn1vRQK3H2N4lKjQR/8K4zzzzJe57NhNtjIPclHWRlrznQHG5BLC77lJSEBAMYtgVp+yCRB63ROdAx70jm5nRmeOuIevA25Ge2BGUepc9zxENasbDOzHNXGQuGIseisrrxU+MQaZC4vSULChzqvfDYe0KAtW9v89bpYgbb4RoHotIIyODEti6dXGDUGtU3CQ9vRqr9g3xIlAckjIIKBMFtPlDBVOlypCZRHVJPWKEUtSLL5FIOawl+thqwFNsoClz/i71YzJswsNgARJewKL5jPOd4LX6HrrV7jej31jvcplc21ee7OId9YL3LCqV7C+7n/3oMT4v0z6SGVOtX2zN4vc7qFQAlRCtqB73jTgCjk7ImrwhD7Ra/2SKAX/X/OHMZA6CghN/DD4zv37jX67EfRpMU3AcgYFpHsTpq2NI73zB6tynpA36kw/Ikt9G8wL7GsraIt1vbbecGuDuoKcW6RaqxjybHLQmKwPN1Qn8e5DzKNc6LBql2f9TDV8BtmRQqU3V51JUwttCMB1qDavpjZfzN70uXXjxftQEL4PcxigEmGSBwyHTvueTH/mjTxEfa8w5RMrfOyc8wAirgW38hWZUFMg6Dq0CqpkHea1Btq74mBfjTb9XaEGAbjaCGlLFmT83LMdNJtNVQd79mLcTKPPjjOYRWAQaC3omwX/ofd8kLJNzB7vJrN40L+VYMmRp7aTYI3nAjYSHM6T2utG/JfrgkG8B13ql6Pj8P4a6H1D20T6SwCATg1F4wMhPZJlXs8vTn76gxAdzing4zl7ykCNBIrm/6zICP5q
 u84mSR+F
 yyw5ZzF4f9Oh4+o69mKP9gEbuLGvNsRGeHZFvdZr2934BUwjsoFLRkUbnPXwbiRHdGgUWP0SpP5u0tb27Jp6ASI4yMDeYEMVC+QpmckuRcTZ2kAUCU5PzjVEny1zyhOVZHzrC8okkde3xAPOSG5F0kBM00tD06tE6tIeIJxP1/0AqT8yLneLkl/J0WQ85M5OE2u2qRfaLl4ShD6LJPJJgcA8qk40D+ZI4NThNxco3VgQdaXpo/mppN7YOLZiSvLt3QMj6HdNYIMwfWiOc1v0yu83D++/69nw18PtgJolv3szKdjcvfo4JO2tK+0+r6h2S3JoGoll+BIR70FcNa2ejcKPtSjYEFX5a75HKnKNQsf/5R8VYfILKd6/LuEuEqekQYfQXIPP5vrtrAXBu0L72rzjzry+aiQy9nBVo8aSF4lU5QsziaKNuMrlM4v1hQ+Cq4WIJV0/E8F+SEzWoYzv9+4JtgFiIAAm+8MZB12teZugeOqo2USN0cVGhy1+HIgZoB/18kx+cbl2dQtoOh6dHSm6mgCFnS4scMvD2ZmDYDfgOrcPlt4eOh4qHV/lHkdweFmlaDNxIY4l3/iDJQPF/DucdybYNLIY76fow/bdlHsq0MMJFSOUhhhizaWkSKvWQ3oeoz9ksjIpUl0czSNeTL6R05H8Vn2H9YvpTLrOP9v8ND3fy0qM5p0Qp4dygiV2qar1c0y5g8Q3xYqDJKhdSL15Acm4cXX8uFsE49QncDSKr0WqA6ImEEjRL55bdud2LU/Eso0iyrZrmmW1+ivgoCUvUBjgDWetg+BQKmk9S60abFY8yqWC0/M7k+0HPykzu/2FCPw4HKZN0UCCHdvf08sf1BPBZbsUH2ozGsN6+KgncIXjOxIoLbFZEJSgfN/qnX1AV70qQ7c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: Introduce {min,max}_array()

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-introduce-min-max-_array.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-183614-greg=kroah.com@vger.kernel.org Wed Oct  8 17:31:31 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 8 Oct 2025 15:29:27 +0000
Subject: minmax: Introduce {min,max}_array()
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari
 .ailus@l
 inux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <fre
 edreno@l
 ists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <20251008152946.29285-3-farbere@amazon.com>

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit c952c748c7a983a8bda9112984e6f2c1f6e441a5 ]

Introduce min_array() (resp max_array()) in order to get the
minimal (resp maximum) of values present in an array.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20230623085830.749991-8-herve.codina@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   64 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -168,6 +168,70 @@
  */
 #define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
 
+/*
+ * Remove a const qualifier from integer types
+ * _Generic(foo, type-name: association, ..., default: association) performs a
+ * comparison against the foo type (not the qualified type).
+ * Do not use the const keyword in the type-name as it will not match the
+ * unqualified type of foo.
+ */
+#define __unconst_integer_type_cases(type)	\
+	unsigned type:  (unsigned type)0,	\
+	signed type:    (signed type)0
+
+#define __unconst_integer_typeof(x) typeof(			\
+	_Generic((x),						\
+		char: (char)0,					\
+		__unconst_integer_type_cases(char),		\
+		__unconst_integer_type_cases(short),		\
+		__unconst_integer_type_cases(int),		\
+		__unconst_integer_type_cases(long),		\
+		__unconst_integer_type_cases(long long),	\
+		default: (x)))
+
+/*
+ * Do not check the array parameter using __must_be_array().
+ * In the following legit use-case where the "array" passed is a simple pointer,
+ * __must_be_array() will return a failure.
+ * --- 8< ---
+ * int *buff
+ * ...
+ * min = min_array(buff, nb_items);
+ * --- 8< ---
+ *
+ * The first typeof(&(array)[0]) is needed in order to support arrays of both
+ * 'int *buff' and 'int buff[N]' types.
+ *
+ * The array can be an array of const items.
+ * typeof() keeps the const qualifier. Use __unconst_integer_typeof() in order
+ * to discard the const qualifier for the __element variable.
+ */
+#define __minmax_array(op, array, len) ({				\
+	typeof(&(array)[0]) __array = (array);				\
+	typeof(len) __len = (len);					\
+	__unconst_integer_typeof(__array[0]) __element = __array[--__len]; \
+	while (__len--)							\
+		__element = op(__element, __array[__len]);		\
+	__element; })
+
+/**
+ * min_array - return minimum of values present in an array
+ * @array: array
+ * @len: array length
+ *
+ * Note that @len must not be zero (empty array).
+ */
+#define min_array(array, len) __minmax_array(min, array, len)
+
+/**
+ * max_array - return maximum of values present in an array
+ * @array: array
+ * @len: array length
+ *
+ * Note that @len must not be zero (empty array).
+ */
+#define max_array(array, len) __minmax_array(max, array, len)
+
 /**
  * clamp_t - return a value clamped to a given range using a given type
  * @type: the type of variable to use


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-5.15/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-5.15/minmax-add-in_range-macro.patch
queue-5.15/minmax-deduplicate-__unconst_integer_typeof.patch
queue-5.15/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-5.15/minmax-introduce-min-max-_array.patch

