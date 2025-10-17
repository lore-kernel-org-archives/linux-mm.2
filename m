Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 269A4CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B2B1940007; Fri, 17 Oct 2025 04:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 789718E0016; Fri, 17 Oct 2025 04:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A31E940007; Fri, 17 Oct 2025 04:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 573C38E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:06:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D933911A6B5
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:06:05 +0000 (UTC)
X-FDA: 84006873090.21.AFE3C97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 21C3140012
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:06:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=Y6mHGuWQ;
	spf=pass (imf04.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760688364; a=rsa-sha256;
	cv=none;
	b=LDQklCBZL0n0g5J8NbOZ893fE2PcUcjb08UvZmWCPX/LVBgRMONzyD2AK8/Jz+dT6HsXp3
	N2gvf8lWSwymljOVWFOEEFYL8yagm4ROSAQZ69iSDnlyEhBoKjgsAOIWeJnguL/mcm0Fv1
	o7L1nROjDcaBi7+sy+R+E2ctfnZ6mYY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=Y6mHGuWQ;
	spf=pass (imf04.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760688364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=xY4MEbgCHtGFmJWZRsGNyB6dOPi52d3wgALR4029T5s=;
	b=Q+OeBlzdPdbyoFFjzhXnhtWEmDXzUFh9yVC+rW0I1500sKbxlHD86WX/TWnQzuccPQjmN0
	B16XyfSBMt6peVQ9yxr/guoKLSyuxJ+/Hjomtst2ftqXHB0mYRz9mrH3euRwS6fr74FXw7
	0kLHvPO0f7ccZPdh3sYlFk8NRHoSLHI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 091BB458E6;
	Fri, 17 Oct 2025 08:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6231CC4CEE7;
	Fri, 17 Oct 2025 08:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760688362;
	bh=owzjRvph/NPKp6B8gmKFNGdV0kzZ99gtjp1pFkr8LIQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=Y6mHGuWQZMRZl2kVl62kX1cU/q0pVYspLqG2UNb5HqyurgVahkdof7hOVSxg1Nid8
	 FDEx/1FA+ICPHmHWL/k/InExPC1F/c2MnJ4AN76f/3pLt/tn9wDx40n4gQl69YXm0K
	 q3btO+UCLJdPLsoy09uWJ5/YKHwe3eP/zmB1rAS8=
Subject: Patch "minmax: deduplicate __unconst_integer_typeof()" has been added to the 5.15-stable tree
To: David.Laight@ACULAB.COM, adilger.kernel@dilger.ca,
	agk@redhat.com, airlied@linux.ie, akpm@linux-foundation.org,
	amd-gfx@lists.freedesktop.org, andriy.shevchenko@linux.intel.com,
	anton.ivanov@cambridgegreys.com, bp@alien8.de, clm@fb.com,
	coreteam@netfilter.org, daniel@ffwll.ch, dave.hansen@linux.intel.com,
	davem@davemloft.net, dm-devel@redhat.com, dmitry.torokhov@gmail.com,
	dri-devel@lists.freedesktop.org, dsahern@kernel.org,
	dsterba@suse.com, dushistov@mail.ru, farbere@amazon.com,
	freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, hdegoede@redhat.com,
	herve.codina@bootlin.com, hpa@zytor.com, jack@suse.com,
	james.morse@arm.com, jdelvare@suse.com, jdike@addtoit.com,
	jejb@linux.ibm.com, jernej.skrabec@gmail.com, jmaloy@redhat.com,
	josef@toxicpanda.com, kadlec@netfilter.org,
	krzysztof.kozlowski@canonical.com, kuba@kernel.org,
	linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-staging@lists.linux.dev,
	linux-stm32@st-md-mailman.stormreply.com, linux-sunxi@lists.linu,
	x.dev@kvack.org, linux-um@lists.infradead.org,
	linux@rasmusvillemoes.dk, linux@roeck-us.net,
	luc.vanoostenryck@gmail.com, luto@kernel.org,
	maarten.lankhorst@linux.intel.com, malattia@linux.it,
	martin.petersen@oracle.com, maz@kernel.org,
	mcoquelin.stm32@gmail.com, mgross@linux.intel.com,
	minchan@kernel.org, mingo@redhat.com, mripard@kernel.org,
	ngupta@vflare.org, pablo@netfilter.org, peterz@infradead.org,
	pmladek@suse.com, qiuxu.zhuo@intel.com, quic_akhilpo@quicinc.com,
	richard@nod.at, robdclark@gmail.com, rostedt@goodmis.org,
	rric@kernel.org, ruanjinjie@huawei.com, sakari.ailus@linux.intel.com,
	sashal@kernel.org, sean@poorly.run, senozhatsky@chromium.org,
	shuah@kernel.org, snitzer@redhat.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	tytso@mit.edu, tzimmermann@suse.de, wens@csie.org,
	willy@infradead.org, x86@kernel.org, ying.xue@windriver.com,
	yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 10:05:10 +0200
In-Reply-To: <20251008152946.29285-4-farbere@amazon.com>
Message-ID: <2025101710-lid-subpanel-e05d@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Stat-Signature: bdyfbwqxkkuiwr4e7ms8keuf3sba97we
X-Rspamd-Queue-Id: 21C3140012
X-Rspamd-Server: rspam09
X-HE-Tag: 1760688363-131541
X-HE-Meta: U2FsdGVkX19uL6/nA72grbvstQf15aL2IhxGoc8N2N9oAQAjvwzIPXJclhz2CrbOQMkj7kKX2LJk/IwUdktuFV0S+ghMU7vroSaVNEYof4fCO87Yya+rN+LQgZuvFnqL9AcjkrKLez1oeEONEc7FgSDFlc8pm0sTqUoNnCEv50VF3gNW6rppM+Beb2YrpSwnrKWGXFf8CPD4MK6EyBd0ctloc0vQuWqwNrhnJMx3DWWQ33fuL69DHMTUT8oBmhPJ/wrG9fgRskfncjIM5lEO7XQ8IC8PckPcj82l2hWI5ykURqL2mw1wyur8MwkRzpIqttPvtGz9Wk45Eha2AfDQQnPbR10VYOtcOVt/n6vbnTygXqK22bpSumxcziyiGwJrJ4HdcS8Qsl+2zFzU/KNDDUqsJEAbUP3phMvBzx1JeOC/ay7hspoPJSXuqdSoSOca1kYjaASdvEaCKTjaf1nbvlt+KCw16e5E4PWvzzGSgj9IWpw9s77ej0Azl+9enHhdrahaW2totf1zz2g8peIcIyOU3L9fN49FOkafc2hKn2F1HxDhgvQvKezEWpkVdLOjQby507Oltvt7eESRGyqLmo6+FsOz59zQdAdSXMyYECb6ld/LMGO+KXsBksqigeT3me4uOP8WmaqKNsj27PVFmRs4v7o0N3KR1jndiya9inqaBzCUraGbAm841KJPzlFASoKOjEWrTGN98LPAM+yZCV9mp5kL0MiLKXD6cVSphA8qg0TPYA1TsZAMMUg+plyVxJ0/vpB4vIkYtIWy69n9wWIM3qXFVJPRh00YtpbwmI0uAv4neFFOipnQyTx0piVIx1aM65SCKQ09YhQyHuVfIvyl3F5aCD/WUuNz4fDnIjQ2o+ZVNBc5LLLW8v12mW9kqxZznXqX+unIqdQcEy1Q5L1hkylUJeIRcZ+n+9CyEH6dXP1Ukeri4Bn9c51U6N+Dg6o3I/HG6sutmRzrjUq
 Cms5etGk
 gThq3gHOe4uz5A0oE1bOotwioZyDIJRQyNK4+95KcRuKkk4YvYit/XIsmAWuToFhMXygLBBkbl4nRxzSXFCx0n14f7SScKeuXfwxpKKkoWDrm0cHm8p1i94HrUIAxJHVv4YPeQR88+6l2LbYgWsBVLMtYQxR1Z6RECA2HGYKp8WkaFYslY9S7HXdaKi3Z73Br9GpnQy8+eoDLlzD2KK1c3EcOGgdt+WlRTWxSuD/mCC4EunKPWKKRT/fP1bkcGvtieH7vCU5EyMkM4FztXHPQmua78fkc6UTtFuxDWeYcww1JbM705I6PwDYkSJGpe46mjEDWaneGdppnZcI8PeOEhaXTDZsvDPtxBJCQVp4AOB6Wfia0UxY/AfRHw7B5Y5qQHqXhZDAjJvft0yaCx4cpFrw/hjAC+KG07Lf7U1GjQoFupjqHit5Pb1JAFow2Gm/xCNVfwUJspLbh0WZn2DBTdu3DvJpgN09tuS9LmjtjjPK8Ztkfz6FQ9NSTrNaVQP7WCESfHN3J1bxDcZeygJuzGGC3hSShRqRZP5eLHPWavr01mMnUV40rpwXDTPyNZsuRyeM9TFwZ/bPRoNumIp249P4pfht+F3i1+5Nk3BXuIXb3ErU4/LS1yjB9VlJKeJ0kwoKZ32MG2wC1vzYM14DF2Dug8ygCT7BhFPZ/o3BROdw67Dt1AWWhGrAWo+YyT1Ji24djLAb8XlhPhdlc5+YMITAmPlDen/uIb2EYm/FJQi8Hm/o6J2dSiYLzYLNy/HxqSlSLWHtuYer6tEr2MfznSnFxZ49WVpXYyEoXLO4va0EpYr/MlNWaJDscfLbGp6OUMPXENGBrL8kXMMnB4Qu+f0C0KfciDxlpDnEYn4eGXOROHYmvjWRKpdcCgQC2Dyab4hrHRG/21fZ3eGorROyVukaI5TToFMxzWMn4mkmECXP7IVtj4HiVHcj9dgDywFj/hDBNMsUOA+Nal+Zu+J9t1NjDC1Yx
 OwqAWydk
 0QkUaPYKP1PcfJI+/v9IxBGh0PDWy7Y1l6EFnSpQKVqITsBIEa3XWTfuRImp4G8FDO/tFedIyFTHrkgT3gsGbZqg//pJMTPGHs5+dv47p4uNy3PCYPg6mp1Y5I7W4xilCpwrZm0znUr8dGVDhiaQbkz1HfEKR7XNQRvoFHR1eQwB3GpXqWGVluEWciQsXfg+Df+bEmtr2n1CWaAeGiHypHP9IlvZHz1fRIJEdHpZ55ztVaqR/m1Cv5xLjYqpn41o8Ccv7rUsWlA95i19y8sBNfehYHC2mZ1sfdi9marGS7TBCd/BUvDVJZeoC20mRNJ/SutakfasSKu1e1+haHoAANEYhfr4kfmbSLXPtP/3/zodgu8x7ey/OHOO1kGfD9PgcXlWXLmm9F9A40dW9Ab28Rv2cJuT3U1SXwFIbp89xbeJrUUVXZkeUXBAVX77wH9LYJwPygm8lsZ3lFo97YqB7zgRWyPJsNIJU4IxBTxpChm2iAGfs7n2w1yfRpEWKu7ASer/ffAPgx/t1E7EmzveXK7yvStecoVaeAqdCpMV204uexKdll+3pxxdCY/vY1clp+GiRO9ojhRfnFwykmV1z4lrJDvgTJwpVHBfl0Bey5vha0zPXlC/ONVgayj7LXmVYom8zaJ0SLw1UnuDFDFE8tLRVhT8PeX3DOHxuyECBwYlsuyEWX3g1qHh2PrxKqPpAhI7QbnD95F1dK6AH2+cyAsOX79yzwgJf9vBG9ohMRNKBKYVgASRQph8kK6I58c4DB+ruBDejfCKq+IyhS4ARc2Eh0SwPWiSppWY+KKM6P9TErUfyWoqp73B6Uen89qZOJJ5efBI6V07o+a89xmGhbY52hBz1Mw8B4E99PuMG8emDcwIiTaLIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: deduplicate __unconst_integer_typeof()

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-deduplicate-__unconst_integer_typeof.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-183615-greg=kroah.com@vger.kernel.org Wed Oct  8 17:32:08 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 8 Oct 2025 15:29:28 +0000
Subject: minmax: deduplicate __unconst_integer_typeof()
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari
 .ailus@l
 inux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <fre
 edreno@l
 ists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Message-ID: <20251008152946.29285-4-farbere@amazon.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -169,27 +169,6 @@
 #define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
 
 /*
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
-/*
  * Do not check the array parameter using __must_be_array().
  * In the following legit use-case where the "array" passed is a simple pointer,
  * __must_be_array() will return a failure.
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


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-5.15/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-5.15/minmax-add-in_range-macro.patch
queue-5.15/minmax-deduplicate-__unconst_integer_typeof.patch
queue-5.15/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-5.15/minmax-introduce-min-max-_array.patch

