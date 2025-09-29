Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFE15CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 13:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 134F78E0003; Mon, 29 Sep 2025 09:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E5DA8E0002; Mon, 29 Sep 2025 09:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F163D8E0003; Mon, 29 Sep 2025 09:57:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DCA088E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 09:57:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8FE99140383
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:57:13 +0000 (UTC)
X-FDA: 83942439546.20.777F504
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id E24A1180009
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:57:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=fhwJC0Q3;
	spf=pass (imf06.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759154232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=uP0Uvkia0TVpAjizrZ0+fDxAgxebqVmZSYAt0/2P9O0=;
	b=p31H3ICYkKwlpQRi6ix7uWBO+bn3nF3/J31XcIZi+WHb8e6cjB49JEP9onEm1O23GO3gDg
	5BoNSo08AQyaz8Pfg/M8VXSlYBqvHsoc6BtqSrAujOeAvdPUecGhY9qCxjtxBnn7srMndN
	1i07k2gIctQoN4vP7HIISN7tEkRtxyM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=fhwJC0Q3;
	spf=pass (imf06.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759154232; a=rsa-sha256;
	cv=none;
	b=ShXqDMuCDTnudCwe8UDnFsZQEyd/xe1/blOf3mUAPt7o353TkdXE4o0BWEcVUCpjB4UN/w
	WEfcF5/jqz5Zke1KI/8njwXYAk5xpDUBvLm+sQIelOWqnF50UxuoRgPq/Pyi72oRiMb9YB
	CZqPgVP7w8W2ql8BEZUfWPIJi2XuYIc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 89301448B9;
	Mon, 29 Sep 2025 13:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66218C4CEF4;
	Mon, 29 Sep 2025 13:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759154230;
	bh=Iw0YhrWhdNpS0HjSK2DGUdg/swwwBsFtqtcexgLRYao=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=fhwJC0Q3xoYO9xAtpXHEmEgtqPtaG7WyYprbrGEvIXEr1UBEoxoiDoVf0J3fUBf0S
	 FID17lhWptY3RNW9HNAlZNi0tv6xwX70LznTlXBjFeJUN+3NPDLDor44Gw6GTuddGf
	 BApVsjN1EH2JCUlxOFWZhDbmVfpV3GD8BmMzPaU0=
Subject: Patch "minmax: simplify and clarify min_t()/max_t() implementation" has been added to the 6.1-stable tree
To: David.Laight@ACULAB.COM, David.Laight@aculab.com,
	Rodrigo.Siqueira@amd.com, Xinhui.Pan@amd.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@gmail.com,
	akpm@linux-foundation.org, alexander.deucher@amd.com,
	alexandre.torgue@foss.st.com, amd-gfx@lists.freedesktop.org,
	andrii@kernel.org, andriy.shevchenko@linux.intel.com,
	anton.ivanov@cambridgegreys.com, artur.paszkiewicz@intel.com,
	ast@kernel.org, bp@alien8.de, brian.starkey@arm.com,
	christian.koenig@amd.com, clm@fb.com, coreteam@netfilter.org,
	daniel@ffwll.ch, daniel@iogearbox.net, dave.hansen@linux.intel.com,
	davem@davemloft.net, dm-devel@redhat.com,
	dmitry.baryshkov@linaro.org, dmitry.torokhov@gmail.com,
	dri-devel@lists.freedesktop.org, dsahern@kernel.org,
	dsterba@suse.com, dushistov@mail.ru, edumazet@google.com,
	evan.quan@amd.com, farbere@amazon.com, fei1.li@intel.com,
	freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, haoluo@google.com,
	harry.wentland@amd.com, hdegoede@redhat.com,
	herve.codina@bootlin.com, hpa@zytor.com, jack@suse.com,
	james.morse@arm.com, james.qian.wang@arm.com, jdelvare@suse.com,
	jejb@linux.ibm.com, jernej.skrabec@gmail.com, jmaloy@redhat.com,
	joabreu@synopsys.com, johannes@sipsolutions.net,
	john.fastabend@gmail.com, jolsa@kernel.org, josef@toxicpanda.com,
	kadlec@netfilter.org, keescook@chromium.org, kpsingh@kernel.org,
	krzysztof.kozlowski@linaro.org, kuba@kernel.org,
	linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-staging@lists.linux.dev,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-sunxi@lists.linux.dev, linux-um@lists.infradead.org,
	linux@armlinux.org.uk, linux@rasmusvillemoes.dk, linux@roeck-us.net,
	liviu.dudau@arm.com, lorenzo.stoakes@oracle.com,
	luc.vanoostenryck@gmail.com, luto@kernel.org,
	maarten.lankhorst@linux.intel.com, malattia@linux.it,
	markgross@kernel.org, martin.lau@linux.dev,
	martin.petersen@oracle.com, maz@kernel.org, mchehab@kernel.org,
	mcoquelin.stm32@gmail.com, mhiramat@kernel.org,
	mihail.atanassov@arm.com, minchan@kernel.org, mingo@redhat.com,
	mripard@kernel.org, mykolal@fb.co, m@kvack.org, ngupta@vflare.org,
	pabeni@redhat.com, pablo@netfilter.org, peppe.cavallaro@st.com,
	peterz@infradead.org, pmladek@suse.com, qiuxu.zhuo@intel.com,
	quic_abhinavk@quicinc.com, quic_akhilpo@quicinc.com,
	rajur@chelsio.com, richard@nod.at, robdclark@gmail.com,
	rostedt@goodmis.org, rric@kernel.org, ruanjinjie@huawei.com,
	sakari.ailus@linux.intel.com, samuel@sholland.org, sashal@kernel.org,
	sdf@google.com, sean@poorly.run, senozhatsky@chromium.org,
	shuah@kernel.org, snitzer@kernel.org, song@kernel.org,
	sunpeng.li@amd.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	torvalds@linux-foundation.org, tytso@mit.edu, tzimmermann@suse.de,
	wad@chromium.org, wens@csie.org, willy@infradead.org, x86@kernel.org,
	yhs@fb.com, ying.xue@windriver.com, yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 29 Sep 2025 15:56:59 +0200
In-Reply-To: <20250924202320.32333-7-farbere@amazon.com>
Message-ID: <2025092959-cocoa-slinky-85c4@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E24A1180009
X-Stat-Signature: 1htd8e5c61a8adjh3cxgnru3713bsj15
X-HE-Tag: 1759154231-340458
X-HE-Meta: U2FsdGVkX18adn76zWsVE6FKUC2E0esKGWXitlik2stSnzifLzbNmDiVU+sxj98PPhgkbbeRd8lct0HISQSKU1V9VzXnTf1YBeVKAkE6nG+twLxxJMwh77JtlE6qwu+qnvQBndsBmob2hhkZsBBCuAhsjOJwxkRLp3h8gnfPGV6C7veAHS1YLmvrMPtfWVnfdCp27F4ttVOOO7ug69fNK5Q69i+f4YxqYXDTcNx4MZqXqJ4e82fAWdXm+YXqHs+Ub3av8tlyMczSGfchk6dmsKQVQfRNaRD3KAT9TmSYpEHB/3LBlkZpbyQ3pM4kE5P5/dxqgfyP4odqIRxkbEsuZQ1K3ZwLcHOcVXsgwskgrBd7hBsou5pHbL2V02/9KXXfgt0q8OUhmGhsJgxhC87mrTkPHd6MmHn/pSJpYD5XmFce/rXir3fTENbDqRmJ8S3tCezjzpId6ES4WKwvixIv9qYZhzlB+GAJpxmXkA+5D+UJCgexXA9dRODVhfk8l2tD74bZB+H8Jv/lk0unrpQR0uTC4KN/npnaqqI49Np5ZXcXCtfM2YJH1huvZ4LZuH7/ZDJ9t3pCHBBJ/QTM7+lUOYuVtO+yeorgkg3V7fDQOEeqbLkSUktqPYDLt7p0sq0rZi4b/j9M0Dx+IFLSixI1lFPYEGp5xtxxmxLSM5Dx7eBq2KZMZs7KTpBDWnhLnv1Qyfrr2DWfHZIKw3f6jtIk//SaHWKvwA2YKSojAayQEWkLiovVGVLXE3sQAtl8M6KvYuyjvsLUbBQ5Vd+Jw2ya3xbp2tiL39eZaPG7Ownd4xG+LkQXpiPdc1dZFj6e/sUFvzCuOQs2ZnkgARHGcLAHqwFgQ1Jd7/NJZOmLFVyoKa1nHr752WgSEyfntUpZ30KvXdLZs2MLGxZCS/JUB+/X2h0PiWdBR8op1YYatK/xC05WACe+foP7gPiWgKx+YGowadQywlsOx7BjkwyK5VC
 02Vlvzbt
 A/sA+8BFgSPU2OqZT3EdQlgPj70I0EZdSwLkXuxQNitqrpOlWYKXITdh566jBI3qpqJO01l1lIZxOuDXVeswhmM5iQ9g32Rl1JyNxpoOtC3xuHbo/6psEB9/T13Pks+57PWA2Sthso2rBAZQjgklyJPpApIATpmTPQNA1UeosdhSYzyhKLMC7ngpuy08/ToCekXPf2MiVbsA2SyOBWzLSrEhfBWliZse0p1mTXFq9hc8tmcE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: simplify and clarify min_t()/max_t() implementation

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-simplify-and-clarify-min_t-max_t-implementation.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From linux-staging+bounces-34580-greg=kroah.com@lists.linux.dev Wed Sep 24 22:29:02 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 24 Sep 2025 20:23:07 +0000
Subject: minmax: simplify and clarify min_t()/max_t() implementation
To: <linux@armlinux.org.uk>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <quic_abhinavk@quicinc.com>, <dmitry.baryshkov@linaro.org>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>
 , <maz@k
 ernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>, <dm-devel@redhat.com>, <rajur@chelsio.com>, <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>, <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>, <malattia@linux.it>, <hdegoede@redhat.com>, <markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <gregkh@linuxfoundation.org>, <fei1.li@intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta
 @vflare.
 org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <andrii@kernel.org>, <mykolal@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>, <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>, <jolsa@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>, <wad@chromium.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <ruanjinjie@huawei.com>, <quic_akhilpo@quicinc.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-i
 nput@vge
 r.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Laight <David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Message-ID: <20250924202320.32333-7-farbere@amazon.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 017fa3e89187848fd056af757769c9e66ac3e93d ]

This simplifies the min_t() and max_t() macros by no longer making them
work in the context of a C constant expression.

That means that you can no longer use them for static initializers or
for array sizes in type definitions, but there were only a couple of
such uses, and all of them were converted (famous last words) to use
MIN_T/MAX_T instead.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -45,17 +45,20 @@
 
 #define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
 
-#define __cmp_once(op, x, y, unique_x, unique_y) ({	\
-	typeof(x) unique_x = (x);			\
-	typeof(y) unique_y = (y);			\
+#define __cmp_once_unique(op, type, x, y, ux, uy) \
+	({ type ux = (x); type uy = (y); __cmp(op, ux, uy); })
+
+#define __cmp_once(op, type, x, y) \
+	__cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
+
+#define __careful_cmp_once(op, x, y) ({			\
 	static_assert(__types_ok(x, y),			\
 		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-	__cmp(op, unique_x, unique_y); })
+	__cmp_once(op, __auto_type, x, y); })
 
 #define __careful_cmp(op, x, y)					\
 	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
-		__cmp(op, x, y),				\
-		__cmp_once(op, x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y)))
+		__cmp(op, x, y), __careful_cmp_once(op, x, y))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
@@ -158,7 +161,7 @@
  * @x: first value
  * @y: second value
  */
-#define min_t(type, x, y)	__careful_cmp(min, (type)(x), (type)(y))
+#define min_t(type, x, y) __cmp_once(min, type, x, y)
 
 /**
  * max_t - return maximum of two values, using the specified type
@@ -166,7 +169,7 @@
  * @x: first value
  * @y: second value
  */
-#define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
+#define max_t(type, x, y) __cmp_once(max, type, x, y)
 
 /*
  * Do not check the array parameter using __must_be_array().


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-6.1/minmax-add-a-few-more-min_t-max_t-users.patch
queue-6.1/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-6.1/minmax-add-in_range-macro.patch
queue-6.1/minmax-deduplicate-__unconst_integer_typeof.patch
queue-6.1/minmax-simplify-and-clarify-min_t-max_t-implementation.patch
queue-6.1/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-6.1/minmax-introduce-min-max-_array.patch

