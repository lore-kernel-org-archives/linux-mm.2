Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29328CCD182
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8566B8E000E; Fri,  3 Oct 2025 09:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806CD8E0009; Fri,  3 Oct 2025 09:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CF8A8E000E; Fri,  3 Oct 2025 09:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 540008E0009
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:07:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 10A1487E98
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:07:28 +0000 (UTC)
X-FDA: 83956829376.26.59C0B3E
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf29.hostedemail.com (Postfix) with ESMTP id A553C120004
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:07:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Z5xD79pP;
	spf=pass (imf29.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0AzpApDbX8CFEbC2P7WHNPH2gra+XDIh1eSQ6GUhJZw=;
	b=mgpCG1EjDKhzjraDAwxWg/avNo+BhlXrWo1NM31HVUzZMJ4fb5a1TFpMBBL4D39SbQmqI3
	5FUvU0VTuKLdm70+lDcNOW/KpLwXXL7TgdO8+yXS1bbl+tL2sg11YkBw68ZYXoTPfyA7Mt
	nzUTmojhpnp1chrO6cSHIC2MykX0kIo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Z5xD79pP;
	spf=pass (imf29.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496846; a=rsa-sha256;
	cv=none;
	b=Xjb5Wh7rJ2wcCmUw+0ZT5DO2P10j4KCrU4FOKiAqLzngBmTajXkdwhonLOo+NU1dXidl0d
	SxgtGt3TyAy9M2DUw4w1PnfrshIDzr53NOTlrYLgSmscknJJscz+L6/Jw1iCeNxm5LrWNH
	fpTi3cNdWZPJuUmKoodW/RiwARlWR/E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496845; x=1791032845;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0AzpApDbX8CFEbC2P7WHNPH2gra+XDIh1eSQ6GUhJZw=;
  b=Z5xD79pPHd6M/jjGKzpSIqgGmt+anrYR8Q3qYbyHmAOcn6SoScnh7kkU
   880mdSEJaOQQOCmLZovfP0ybL5Rn931nM3EI7rag2IFqsJFtvKGwF/7JZ
   yw8Rn2tAwBEonMAEvtevgMSN8NUknrAhrYF2xY1DWtDSIUB8KR1UG7tHe
   mhIYgi36eIhoOT37IYXfUna2iRPVTXgycSW+QZlWKkoehHFmEH3uULqHF
   /hCZVGQncS3TceGEZsil1+DyJP3lWx6l+pOxFAv459J542ldf6AEttSlD
   WN9F7klNgRW4Uxd9MSXsHUI4x5BFbzf+4dBT3FzPCESA5ne71S+qx9CMz
   g==;
X-CSE-ConnectionGUID: 5M94BRBwSnS66mVzRApKLw==
X-CSE-MsgGUID: fIkkoo1YSaeiXfD03qJifw==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="3063657"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:07:23 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:11484]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.19.222:2525] with esmtp (Farcaster)
 id 286331e4-5516-4ed1-81e3-c1196b39067a; Fri, 3 Oct 2025 13:07:23 +0000 (UTC)
X-Farcaster-Flow-ID: 286331e4-5516-4ed1-81e3-c1196b39067a
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:07:13 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:06:47 +0000
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
CC: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Dan Carpenter <dan.carpenter@linaro.org>, "Jason A. Donenfeld"
	<Jason@zx2c4.com>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, "Pedro
 Falcato" <pedro.falcato@gmail.com>
Subject: [PATCH v2 14/19 5.15.y] minmax.h: update some comments
Date: Fri, 3 Oct 2025 13:00:01 +0000
Message-ID: <20251003130006.41681-15-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003130006.41681-1-farbere@amazon.com>
References: <20251003130006.41681-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D036UWB003.ant.amazon.com (10.13.139.172) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: qp7kjqb9uex8agftw973nhbdobtgojud
X-Rspam-User: 
X-Rspamd-Queue-Id: A553C120004
X-Rspamd-Server: rspam04
X-HE-Tag: 1759496845-398896
X-HE-Meta: U2FsdGVkX18oE2PYkDoBg9I+e4rXOWQlqCpTxeL2Q0jMqZ+wZfMgpkGvy+tLrY8bWhc0Hg5SMvh0RMjBDgi8rktYdL9rFa+jJ0BbZfuXqtcH0K29MwWHrgWGih3iJzsGwxc+Y+MzRuv2rl590DQ+NigtP5Usi8yAH9G6SFYvY0I0oPSzAvdA7uJPyfcqRa99syfG+56w3eCRx2FK1MQIbFPRi8m2joMSDgWgvYc83fJzAY5MrE0KAw816GiPPAkvxvXB+BK3/mdZZInR1xy50jAEwA0RCnpWEkWgpyHDSbqjdsP4xxw4LJ2ykchCUd0swDUcuJTIHh+zOdPdgbQwc3LZ5HbuXPU0U70N+k5P5C8l3XWbmzb4wU1xH8m1kFCjBIugujimRYR5+bX+Ewdrcu1LReTmFzu30AY6jklWuaffTK+j5AYP8cKuL+iUQEz4Z8OK5pbGI0Ceu4jfnDy7XlQZm5QDB+jrho9HIXRpq5+Y35S+UhMkytF0h1/Ft9wHhxiK6nEHLWNfWnkueLHilE/CEx8NPHGOE5LK9WL53di895b7QXZTQZSaNuChaQZBqjGxGgtoD9FjCteuQ3RECNgSQ/G6LHw9THXsX3WLNEt3vt9Mt33cGAGzTLtfACmCXcNqCBRmK+VRV6/2VNrsI5FiV9rQ1trJK50nrKDLLi82xESHLh2jfOmkNWDg7QtNKikYZUWRao//jMpcrYJp55OvpneiBhQXfy/oFV1zJIRpgkeX0WE15kCL1ZHtarU8Wm36fH/bOpx8Pa6G8xdFN9eg7K3hNezmniO1OiftbzWOhLnpxuuQxJIuEDZa61K1WCmGHaU6OkQjEH9RSbvmh+A1HWKreZmD6q2kbX+TMAVTG8CZOCuJ37WHUzjkOMGRJ1C8gcHSzr5dDgo870oOzdIm1nbNQZ5kBQOEFBWJbGJhalA3Ny94hrSQoCW646zimcy7U/5d8eSkAFjwvP8
 WiEwTKcx
 yuZ5IDMuGm+gNHp2Kc8lJPna2/NJrEC5O4x9Zfv6t6jTiIC5Ahesc0gHJLfm6B5ELAh/xd9kUBFT5QHb9PINLPsJjcZUwV0jfmUYZKRUk0bFXHQ1zrXM1q5a48lC8oGoe9KbsiDjijnTP1J1EhIMv9gp0Hz88v6zJpyXKmSEpIcagiH7AhOpZudmULZeb482khvWVmxY5RAw0e8Q2/nb48d0zRupXzAZRPzPYE2wctHzYukA2n/C4g6ziG3X6opwlrL3lPQsYL8qb2A7s6sXV0JXZ57EHpF2lR7H/gHp+0j0A9g+Pf1IklWXmp5APloWb2EYzMiFmG8ncMRzxkcoOQcLPONjY0mKz/jP7hhePwbi42v9ounh1Ta0H2GAX7w8sKHEAH9DR1HaXQ3RrZH8tz7sVkPTaGwsE8KumXPyn9z+TzVWkHelxgf+m36UPqesU2OGY9LtU07unVvO3LlpIjNwD18w45ut+BEad+dc8rMJ+3lw0kfdfdw6JwDrXMNpBTkXv+A4uf5V0JjHblaZvYCEXj1CfGpe27sQyTeepGWV+oRXnwb0JBgVr1s3CkF3UzfzyVMqWarlgR7BM8AV7wHkFSzBtm2Y8ae+/Fnr6ca/RKtLbg05TN6dtlQy4IQgki6c7do/RYrHTUuOOAO+DmlZKG6pGKUz70+SeLnzIgaYtujlhJX6tUj0dyeFOAFeB80UALbiVZtLrrbvMytbugL0lbr2eHW0+gMncaPRYxl9oEa8xcN0cFKdYsSjhzVAMIAVszkDM03YINxyFln22aNoI8Ai3Hn/78wnQv1y97qI3p8eBDgp2yk0GKoa7JSUUjNm3Us3sAUwTeAnXVzpu5b0IVR82cvNfxTjzh2TfNwllhkriugs67VdFdIlPfyqWWurma+syO15hq+1jf40/cqS1U/czuWvJpmqWLGihqF0LoILpwxPRyYf/jvd26ACrWzfcu9gpOUzgs4kMchplhua93zf0
 ikr0NxRG
 YKMKW0CWHn7T5xJuoFZXNbgDBrdC2a/VTpz5QpIbgB9c0uVOFfnTzMy5ey3pZC601IwSCuXLIFzTOL7V+midShCIB4XO82lNUdGGOZOoP0kpjw3ZyooQkixIqnHx6gnc970AUs80zmC7g9tofyybCetxYv7qdW/3GeLqYggzR50nD8exzNRzhw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 10666e99204818ef45c702469488353b5bb09ec7 ]

- Change three to several.
- Remove the comment about retaining constant expressions, no longer true.
- Realign to nearer 80 columns and break on major punctiation.
- Add a leading comment to the block before __signed_type() and __is_nonneg()
  Otherwise the block explaining the cast is a bit 'floating'.
  Reword the rest of that comment to improve readability.

Link: https://lkml.kernel.org/r/85b050c81c1d4076aeb91a6cded45fee@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 53 +++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 29 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 51b0d988e322..24e4b372649a 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -8,13 +8,10 @@
 #include <linux/types.h>
 
 /*
- * min()/max()/clamp() macros must accomplish three things:
+ * min()/max()/clamp() macros must accomplish several things:
  *
  * - Avoid multiple evaluations of the arguments (so side-effects like
  *   "x++" happen only once) when non-constant.
- * - Retain result as a constant expressions when called with only
- *   constant expressions (to avoid tripping VLA warnings in stack
- *   allocation usage).
  * - Perform signed v unsigned type-checking (to generate compile
  *   errors instead of nasty runtime surprises).
  * - Unsigned char/short are always promoted to signed int and can be
@@ -31,25 +28,23 @@
  *   bit #0 set if ok for unsigned comparisons
  *   bit #1 set if ok for signed comparisons
  *
- * In particular, statically non-negative signed integer
- * expressions are ok for both.
+ * In particular, statically non-negative signed integer expressions
+ * are ok for both.
  *
- * NOTE! Unsigned types smaller than 'int' are implicitly
- * converted to 'int' in expressions, and are accepted for
- * signed conversions for now. This is debatable.
+ * NOTE! Unsigned types smaller than 'int' are implicitly converted to 'int'
+ * in expressions, and are accepted for signed conversions for now.
+ * This is debatable.
  *
- * Note that 'x' is the original expression, and 'ux' is
- * the unique variable that contains the value.
+ * Note that 'x' is the original expression, and 'ux' is the unique variable
+ * that contains the value.
  *
- * We use 'ux' for pure type checking, and 'x' for when
- * we need to look at the value (but without evaluating
- * it for side effects! Careful to only ever evaluate it
- * with sizeof() or __builtin_constant_p() etc).
+ * We use 'ux' for pure type checking, and 'x' for when we need to look at the
+ * value (but without evaluating it for side effects!
+ * Careful to only ever evaluate it with sizeof() or __builtin_constant_p() etc).
  *
- * Pointers end up being checked by the normal C type
- * rules at the actual comparison, and these expressions
- * only need to be careful to not cause warnings for
- * pointer use.
+ * Pointers end up being checked by the normal C type rules at the actual
+ * comparison, and these expressions only need to be careful to not cause
+ * warnings for pointer use.
  */
 #define __signed_type_use(x, ux) (2 + __is_nonneg(x, ux))
 #define __unsigned_type_use(x, ux) (1 + 2 * (sizeof(ux) < 4))
@@ -57,19 +52,19 @@
 	__signed_type_use(x, ux) : __unsigned_type_use(x, ux))
 
 /*
- * To avoid warnings about casting pointers to integers
- * of different sizes, we need that special sign type.
+ * Check whether a signed value is always non-negative.
  *
- * On 64-bit we can just always use 'long', since any
- * integer or pointer type can just be cast to that.
+ * A cast is needed to avoid any warnings from values that aren't signed
+ * integer types (in which case the result doesn't matter).
  *
- * This does not work for 128-bit signed integers since
- * the cast would truncate them, but we do not use s128
- * types in the kernel (we do use 'u128', but they will
- * be handled by the !is_signed_type() case).
+ * On 64-bit any integer or pointer type can safely be cast to 'long'.
+ * But on 32-bit we need to avoid warnings about casting pointers to integers
+ * of different sizes without truncating 64-bit values so 'long' or 'long long'
+ * must be used depending on the size of the value.
  *
- * NOTE! The cast is there only to avoid any warnings
- * from when values that aren't signed integer types.
+ * This does not work for 128-bit signed integers since the cast would truncate
+ * them, but we do not use s128 types in the kernel (we do use 'u128',
+ * but they are handled by the !is_signed_type() case).
  */
 #ifdef CONFIG_64BIT
   #define __signed_type(ux) long
-- 
2.47.3


