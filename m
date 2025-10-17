Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 803B1CCD184
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC0798E0035; Fri, 17 Oct 2025 04:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A96AD8E0016; Fri, 17 Oct 2025 04:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC068E0035; Fri, 17 Oct 2025 04:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7062B8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:05:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33E3F1605A8
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:05:49 +0000 (UTC)
X-FDA: 84006872418.19.F008EBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 486D91C0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:05:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=jfsQ3+mn;
	spf=pass (imf18.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760688347; a=rsa-sha256;
	cv=none;
	b=Q+TuGs000cE7CBiJcY9pZ4UrQ0hQeq9QExpVCyAIUggEuAEhAJX6vlyIej1+q614Cts0qf
	3rFVGpm2nfZs+EDnEfQKo34+5QFo/e/3ntCCC7NakJ2YTrjdTEUAgiwINZCO5ZV8MuovDL
	vEWT+WQ6it3fWc0JakOTHQqEvM77/ZU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=jfsQ3+mn;
	spf=pass (imf18.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760688347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=LB/0TvMzeFEvdv77urfuOb+gkcohaIUoIJl38500x0U=;
	b=GPiS5KDtXVa5sFaS+o8qBZ4wgi4a79AsXHHJMXq8zeYnyhJ8TbZ0GqcjDsnwV0cFWfiy2/
	Usx8e4X3BqEyNgEeh5lKCNu5YiXV6vGhTnjb/S50IvMyAXttt0vdnbCBtlBwbD+Y5MMLY5
	qPZqHHRWAi1CveVzcHSSn5/1lYE84lE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D658A43E61;
	Fri, 17 Oct 2025 08:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34845C4CEE7;
	Fri, 17 Oct 2025 08:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760688345;
	bh=jQhy/ox3fIOhCY7knzkIZUyacLZTGHWrr3u52zYJAkI=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=jfsQ3+mnT/1hXaKowyNh4ESs5gv7XWT4llLVtqMbxf719r6AbXjDWmR8zBVavKXTr
	 DspwYEGBxW2V4PZWTnFyaExmgP7lqPD2tc7Ax5IkWv9QpHXRROMLLI3Ym8cvq16VYc
	 dXU+JcHgFA2fnbNWSnt0GfCEyA/6Q/jr15A9yGug=
Subject: Patch "minmax: avoid overly complicated constant expressions in VM code" has been added to the 5.15-stable tree
To: David.Laight@ACULAB.COM, David.Laight@aculab.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@linux.ie,
	akpm@linux-foundation.org, amd-gfx@lists.freedesktop.org,
	andriy.shevchenko@linux.intel.com, anton.ivanov@cambridgegreys.com,
	bp@alien8.de, clm@fb.com, coreteam@netfilter.org, daniel@ffwll.ch,
	dave.hansen@linux.intel.com, davem@davemloft.net,
	dm-devel@redhat.com, dmitry.torokhov@gmail.com,
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
	linux-stm32@st-md-mailman.stormreply.co, m@kvack.org,
	linux-sunxi@lists.linux.dev, linux-um@lists.infradead.org,
	linux@rasmusvillemoes.dk, linux@roeck-us.net,
	lorenzo.stoakes@oracle.com, luc.vanoostenryck@gmail.com,
	luto@kernel.org, maarten.lankhorst@linux.intel.com,
	malattia@linux.it, martin.petersen@oracle.com, maz@kernel.org,
	mcoquelin.stm32@gmail.com, mgross@linux.intel.com,
	minchan@kernel.org, mingo@redhat.com, mripard@kernel.org,
	ngupta@vflare.org, pablo@netfilter.org, peterz@infradead.org,
	pmladek@suse.com, qiuxu.zhuo@intel.com, quic_akhilpo@quicinc.com,
	richard@nod.at, robdclark@gmail.com, rostedt@goodmis.org,
	rric@kernel.org, ruanjinjie@huawei.com, sakari.ailus@linux.intel.com,
	sashal@kernel.org, sean@poorly.run, senozhatsky@chromium.org,
	shuah@kernel.org, snitzer@redhat.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	torvalds@linux-foundation.org, tytso@mit.edu, tzimmermann@suse.de,
	wens@csie.org, willy@infradead.org, x86@kernel.org,
	ying.xue@windriver.com, yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 10:05:09 +0200
In-Reply-To: <20251008152946.29285-6-farbere@amazon.com>
Message-ID: <2025101709-handcart-hunger-c414@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Stat-Signature: m7n6bkfcao16kf4aqiqoq1b91eyyiou3
X-Rspamd-Queue-Id: 486D91C0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1760688347-338430
X-HE-Meta: U2FsdGVkX1/B5NswACySPOw9PwaBjHETV4jTVXiysjxel7p/YA4GHIDPQ5UCXbmUoO39qdCkZ7Ni1pgSgiNH+fEoqPHVk7FTDEZ/IN1U346VjXU7HUGqkETN13jhYIPeOvUTNLo5sQxcvE+63Q0tD9wttv11gLF1LFQ0v6jCti2XjuWpFQUa2R4K0l6DOD5Erofk/7GpflsFVCCgDUkTaSJ3WIHcg1ADoXER93lo5R0spYJ0AkzJl0lAAza6rZFXKReDkaARUgyT2WS7S42g9grRxJeaI7atxE2YH5G01/FHQ8jCZzIg4QQvgdx0T2TWJ987DmqnKPRBLYVxUatmhHtOXnKklGsyRFpxBV9Ewlr3ATN1Um9RFnBi0PPQ/lQg0FUcV05qvV8KmbfskN89/W4f0LgldaCJ4MMFkfc6AWjHnMLsIaBUdYtZc6CHMuspYolQVGcHKAd7ajm/B5aPdmGcp5aODsthPZMGoTE88dHmdEe2k2xdWm2LWOV+GX3KQRQ6MXKSIckJUGW3N44DfAI5NVVS+5VidQDNrEnz7Gra9E22pL7td1CqQqYB50gAbdoYl0TvmoSzy9fbPzNcFBNGiOrsv/CnS+3cpL1WpADEMN2+MRSgrrRdHlwyQ/Er+ULxjmUzt9bzkzV+s1x6drGUnbV1zMqVHftbO+F49e6aFEzkvu6tTmSOCPS28MnSZj3Mud6FrWGIqQlZxT2JFSyHWX5AhuYntUTc6Z9O0Jd/ZEkdkGXRKZACZSRdwEqd1I+Td0zoRv3gGG+rhsuqamwhcoeyZ6YXcDdaNbJAnwH+LBatVg+4obOxgu8Spi9wE/PT2ILnkSaT+1k5347KCH57bOFWGNuePH60AC9HTFdRzRZiFrVestyUCk2Kx/NhHtTkFbgpk6PHmFnP0b9Ju4YWQm/v1g8cLCrtTzizfsxC9uT2T6XYk7nLLt8JGhvH+C68ZdV8c6vzlA/tB6r
 HW7/gbBM
 jgR3oZqB9gemCA9egaU9LBuUIYML7j/ja8+EiidswZ5rM2oBxIUD002ppHYqfPoeS2g3pmjqoLbECI7E1yzpu/Skqa8MYIAz8D3pt6HtWOWqGeAmL1QORrJEtri4G8J30dB0A8VFh51AAYfAB9tTjx/p5Sou/PdtQ8EwGPEIjv5Al648h+4DV0ual1z9TBW/YD9sJKVb6cv5pcIm2/SVnuR82xRo4i7+uLWa1zZlxh00g7M48kMvx5ZV5gN9vErGLtUIWi3Cv5qqblei0TSvdNDPFgRxxw0Pnt7op4/qRVeAzna5ehLD6AuZuSMUeGs4FSdzXDSudcCu99AhsljFURIFevYFtpxLnx3nHMmNa+tErgWVSR/5WmOf17L6mgTeGcDOt21ukofGYpktpoKeIuu5TrBCPxVwJjqf0YGYirTbEn0hN6OCXvJuruZCwx2EI+tMCzo3/ISUJEN+IgsuB+nNkhugpDFI0OhsOYPvdambz1J5O8ZX2/liM6eXSexOz8KfghVokvHcxD6tuL2aenSjVfY96e5aw3h2dVLk8xhWeYsN24Zlf0IWOH5sN89ymEudMQO2pXJ3AQ3DBsAr13RcvzAidi33mAK2ObBs5agTxNpwPxX4sxONl6ZMzygj2ImMqXWEgJxK3RbK47A+EengmGum9GDCfddMr+pvyvC5jqBNzpOEcEhqudOIijHfKdXoHMBQc2vFtewQVAJn9HS1Se2m7x9QVoiOWbPbkl7HB4fhww21hnttHrF2JQi5Zk020tyOA3fr0plWlAFz2XNBbmvFSNMANQQwrrMDLtPtICr/Yr6SMS4VXYTQxGq98JaqVLg5yvEKHPJvePG3TTtFSJoQ07F1yCEORRfbi8RXo26gUUuUB7oPeqHzp9p757Mqp+cesOnU8GkZ+06n1r1eICQyjIEw9d+dcaH/a5IV8g1ujEmvyeZB6L5jawlmMims/gAmOWDTcMWbucNvBEhiCow/T
 kYA9e+ty
 rab6V5WPSAjcGi89+SbJtr/Vj4MHBDFUdK1a2eL6WCiLR+yVAkxGb2KzrRsDPRagWN4Uh+nLB3fngwZrp56QHWeClSmUneCZiXVdDvnHR59PuJv6Sn/Vv2VsoRUoFU0OwUd5DjWbgOn+vDVUOCpWPQWTRXHcdtCOzUxNmqWHYuN4dL6rBhtTbLCgX2eH4rODFp7r/FEvuDhDRnJMMgyp+KjawheKP71+G24eQQ7STLXGZxscHERb2THdlmMHESUsvPlTU+YIEg5OUyK1zIe++yUdHsxJv8ISy4o5kwsFWRFyYe9bh7sAzALsheNaf6T23cOB7S5EIUF7h1YzhQ2CUNOVLOBJysWYZzmAgVT3x7shQeVMAD26dx51fKoX5xg3BesbsotIaF0yP3ozk17jJGT2SWJo8ZWfA0FkuuAk/2SCBkaszlinJL3WzTND+ftJnLuKnySWuVuI6mOzkgsPDCEZwmPxWzgTqulsYiCJ+w8cTAPXSTSUvpcqWk4JWwL6BEehahUhq5wY8+FzmtZiQLCSu+pmdw7/o6W3LyBlxXQq/e0T7idEXu2EHtnWgLk3/vXn5Pf/u65ZFS1m5mLt+f7D9yxUPknxAcGvO6gJ4aDBnkIPibatA5/4D3P6zb5Im9Gz9K+GP87m6V5NznoubfhIQsNWsp9jkkx4s3po2LQkcqIBbcC8cRRQQdHh+wzeHwJTOR5b4UxncSf6t4gDEjEF33efgYGT11tMyDVTr4DINWLldwLvIsrydOia7Z/Av0AVXxOit0nvBQM7I/n6EPeUfBx73oSjsnpJrRqt1/637xeexdsppf2KuVPKKRyEqq0SyhaW3fD4VtJ8jtSck+W/0XLHNAtQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: avoid overly complicated constant expressions in VM code

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From linux-staging+bounces-34820-greg=kroah.com@lists.linux.dev Wed Oct  8 17:33:38 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 8 Oct 2025 15:29:30 +0000
Subject: minmax: avoid overly complicated constant expressions in VM code
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari
 .ailus@l
 inux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <fre
 edreno@l
 ists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Laight <David.Laight@aculab.com>
Message-ID: <20251008152946.29285-6-farbere@amazon.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 3a7e02c040b130b5545e4b115aada7bacd80a2b6 ]

The minmax infrastructure is overkill for simple constants, and can
cause huge expansions because those simple constants are then used by
other things.

For example, 'pageblock_order' is a core VM constant, but because it was
implemented using 'min_t()' and all the type-checking that involves, it
actually expanded to something like 2.5kB of preprocessor noise.

And when that simple constant was then used inside other expansions:

  #define pageblock_nr_pages      (1UL << pageblock_order)
  #define pageblock_start_pfn(pfn)  ALIGN_DOWN((pfn), pageblock_nr_pages)

and we then use that inside a 'max()' macro:

	case ISOLATE_SUCCESS:
		update_cached = false;
		last_migrated_pfn = max(cc->zone->zone_start_pfn,
			pageblock_start_pfn(cc->migrate_pfn - 1));

the end result was that one statement expanding to 253kB in size.

There are probably other cases of this, but this one case certainly
stood out.

I've added 'MIN_T()' and 'MAX_T()' macros for this kind of "core simple
constant with specific type" use.  These macros skip the type checking,
and as such need to be very sparingly used only for obvious cases that
have active issues like this.

Reported-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Link: https://lore.kernel.org/all/36aa2cad-1db1-4abf-8dd2-fb20484aabc3@lucifer.local/
Cc: David Laight <David.Laight@aculab.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -270,4 +270,11 @@ static inline bool in_range32(u32 val, u
 #define swap(a, b) \
 	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
+/*
+ * Use these carefully: no type checking, and uses the arguments
+ * multiple times. Use for obvious constants only.
+ */
+#define MIN_T(type,a,b) __cmp(min,(type)(a),(type)(b))
+#define MAX_T(type,a,b) __cmp(max,(type)(a),(type)(b))
+
 #endif	/* _LINUX_MINMAX_H */


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-5.15/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-5.15/minmax-add-in_range-macro.patch
queue-5.15/minmax-deduplicate-__unconst_integer_typeof.patch
queue-5.15/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-5.15/minmax-introduce-min-max-_array.patch

