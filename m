Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 968B4CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDE128E002F; Wed,  8 Oct 2025 11:31:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4F68E0002; Wed,  8 Oct 2025 11:31:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCB0B8E002F; Wed,  8 Oct 2025 11:31:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCD6D8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:31:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 71B3E16063F
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:31:28 +0000 (UTC)
X-FDA: 83975336256.22.CB49AA5
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf03.hostedemail.com (Postfix) with ESMTP id 413D220002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:31:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Ap2I5iGg;
	spf=pass (imf03.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvk2RBzXwrA99Hwxay/jSQlk3gLjsVti9lJHvH/pTPQ=;
	b=mlQ82tl1oYGcRtv5oZDaXtPFZ4CGw3d4LHi94Ft6Y8C6hYdYl3fK3JMHIYQ5tOG3bHnUKw
	4g7D8+ETvvgpg/TsIv2vfy4J8TCXeId8RAi7Ai8K4AsoAeMYG1ZNlKRTWAG0OcAXWmOZfd
	uzKW8dfUv5HlcnqsbaR8J/Z3fSYxvRc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937486; a=rsa-sha256;
	cv=none;
	b=4wGjOM4I5YPgSXM/RNSsdPxt3+R/Vx0zdWb+PvtkClBk7QD3ZVmPblWMuCAgnmngeizgFb
	mrH8kQYuRv00WHodX+BMTyu6HRDbAm9tBiWC90b/Wwy+QbTVw8KIQBGROXs+NrU9EZcRDf
	UbmQ+V69k38ZKcFJ8/2Gtt1qPQE3UAE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Ap2I5iGg;
	spf=pass (imf03.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759937486; x=1791473486;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jvk2RBzXwrA99Hwxay/jSQlk3gLjsVti9lJHvH/pTPQ=;
  b=Ap2I5iGgvODSFOIx1csHXQrK9ym3dPjdUO2ZXlGpc/fyIKpI2CvVL3Bo
   4UDigEVLUQDugkJ68Ey7mr2cPjOqIqxdadhsl7OPFzWzEwK1y5bQ6Tcuq
   HH/Bqtzz3Qwwks5yJ650Ktj0ha/cPxnMpaR5mdPHmk4XbGx/+NYb0UPyy
   RRAy6lgznKRlBeb/OKuxYIMM/X1SnhCUbH59ho3O/r2Pg67AmQXyHMVjf
   C6h8crcaWMhHUSLq+jkFBqYYIVzJTqM0pJBZ5tOtSIjNcQEqTSFR2xfH/
   QqquTJd+v4RAuAhIMO0FWHhxu7fbwWB5Ym8XeFgBAz01S7r8OAtgnoYrn
   w==;
X-CSE-ConnectionGUID: C84d4vrqS4+tQbY5ZX7vPg==
X-CSE-MsgGUID: Smt1enfbSGyJRBqUsp38fA==
X-IronPort-AV: E=Sophos;i="6.19,213,1754956800"; 
   d="scan'208";a="4410627"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:31:25 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.21.151:44901]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.54.171:2525] with esmtp (Farcaster)
 id 71b65f11-5afc-47a3-8856-278291bee2e7; Wed, 8 Oct 2025 15:31:24 +0000 (UTC)
X-Farcaster-Flow-ID: 71b65f11-5afc-47a3-8856-278291bee2e7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 8 Oct 2025 15:31:24 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 8 Oct 2025
 15:31:11 +0000
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
CC: Linus Torvalds <torvalds@linux-foundation.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, David Laight <David.Laight@aculab.com>
Subject: [PATCH v3 05/19 5.15.y] minmax: avoid overly complicated constant expressions in VM code
Date: Wed, 8 Oct 2025 15:29:30 +0000
Message-ID: <20251008152946.29285-6-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251008152946.29285-1-farbere@amazon.com>
References: <20251008152946.29285-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D037UWC003.ant.amazon.com (10.13.139.231) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam05
X-Stat-Signature: x9ua834anokba8yb49gd5ea34fwxy13p
X-Rspam-User: 
X-Rspamd-Queue-Id: 413D220002
X-HE-Tag: 1759937486-693474
X-HE-Meta: U2FsdGVkX1872kDgiJL36VEaE0XHelNL1gSA7q0U0OwD8+5pG0QK0irTV8BfZzXNJ/+onHP7wcMT1xGxO0fXXJg2Be3rq+i27JZ0RcCcoP9GaUdPs7XvmE3qdFP/trCYXwTqE6g7a9jvzVOQDedFkpRsrp8vWcaAgJ52UlwYH2NYB/EQ8HFRgvqhRJCoRIDVnMniL2aVfNRDnulFOxdPeRPdLQ27KPx0BFVjnCY7biIj+3gPhDBygy10IJi/+aEzU8oMWdZZxrQD2qNzwlxLUjSo1c7A9vy0ptZmTU8beVlEV3rkuYyu8zEbHS5Y064XNQvLh601VCoxU5S5oSFuJCKE1jOgYjsVlWWzikAoYZ8nhe3frVyhk8G7UGWoWZ2nziQeEaeKkf9zzwOzdbv7E9XV2vefz70fdsbM60/TnZMxlT1Uyb16MM8cE4lW/qbqo+KhCC9wBhbx++NWIN4vocaWmTDUD3T2WB8pwa5ij5NKVul/58872mMAA60DLOJRkqjkki6+0T9sWwHfSxDJJwG4MmToaS6vHi7CRvaaYfpM/FZ1hlgHDRI1YeALpWXllD6gFaJUC+lBbZNod1OubeK+pqEL3CDGdIGXab9tkr/01gojhNAT6Ykl1JWOdAal2EXUFDKuxX2S/Q6QPygk6YxnaW5LT+rjuoJwYMOEsNHHasXosaMBXX5NzAp1QbaZcl1XZOPJ+ud9hgX4hby7xjUOYVxtDKN2T/I1JWF6MPeS4vjS9QwQRqvBaB9K62k3eiF+vqHVTHVQqd9G3tWfqf9K21dejvmjEaaLTCZNBq85CLQHxshvZQL0jvl2eDky5FYYu3b5/v9gVcr0ZZ+xOs6rIwAtfca2pmitpxpiFLo135KuL3mo860SMlFAoXPZbixp/7hDAMQyqWAHIHe2Z1hnBOZMwh6v2ttFwhKcyyTFFE+IB+UY3OSMsAc/5nb35SC2W/LqTa0T6o8BjsO
 nwPyQGbX
 ejvxcBq5nIMmrB3BFw/dEBS0pQ6HorUSTkGgVHXnGJiUKZV7nBzLoO73vFfhM7Du4fVByyrUwBRXK0iGpBWOxy/pKD3CZE4oVF6tYugm6YxycrBKeWszI0Mi+Kr1YMZ1eFvDx09arJD1ifBOWhW2f04EXOa7SGeaVmH8d8kFQRPn93mnCWgYsqML2TgDMPKBwF6qMwGHpoNXgWOPpapXU/l7f3Pn5nbheAJUoCvWvej5SkoVOxOohTYxgzDSCI2SiPZi6SWqR2gESyrrrybLXVzF/yQTo8c4pmZ8CS2E/o6BmquRs7wl4ntwRjquzSRaSWjfrtspNQkmmYQ+pVE7XEL++Cz4NPoC8BTjeL6i7Vtk648pFad8qZdWvh4UCm9B3ztlXL0b5mEbKu1L+1hf1jAlzZabA2opqMkEij85iiRKjRQMZYq7MSVvfTfsC/sAdsaLU1+LX1r5iidFDa0rQCXGnXdwdOSTypXwtpZ90IAMoaO6kFOmgkBg+SH1PB9shrw+IAdjYZ0s9usAy92QOrDzElpUsvsdE+UOiBxnAXFY5NNJzpwZ84dyr4acbGTzz388gfyqj8bHe0T2X72AzqXfFrCeYYqWcjbTnd+pyyEyrxD1k35/7piUCtf1DNCdk8R0rtDhj7eXL5NK4Hd4LD9u+nlHcbVch2fdCIfLnvMq5RRq7L0VDCWm4SGTJRlSAvcMEn6FntrLEtIIUMIp4Qo2MhSIJMGh5bZI7YSzHtl+VISUy4OKF0jB0bmBM31extojrPAbW3feyBF18mJpDG7GSPuOt7TTzEOuScvaERzW42f/kZ7Tkc1mGb0qO1W2hO4tMc75F4owV+AToOF7hO7s1RZ3gkNhuBDkmt3c9y8ZNl1wRbubx0Ex/EJXlALUTt4XyeJWHQ9zT0Tcu5AeqKohOul1shpsDRVTUyZxaJatXSUZ6KpbaxTjXcol6ILYjvwAfWVUANeMsNC3x6OXHPWx61KUr
 pJ/v5gFn
 CjmHPoZUXQ3zT1gQP0tcsHWy4NLHQhHOcPZNShwLLX4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 include/linux/minmax.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 2ec559284a9f..a7ef65f78933 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -270,4 +270,11 @@ static inline bool in_range32(u32 val, u32 start, u32 len)
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
-- 
2.47.3


