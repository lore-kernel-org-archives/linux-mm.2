Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BA45CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:50:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC43A8E0011; Thu,  2 Oct 2025 16:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74548E0001; Thu,  2 Oct 2025 16:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62BD8E0011; Thu,  2 Oct 2025 16:50:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0F658E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:50:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D544BA6FB
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:50:40 +0000 (UTC)
X-FDA: 83954367840.04.5FE51EE
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3B9E7C000A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:50:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=LglAKWAV;
	spf=pass (imf22.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvk2RBzXwrA99Hwxay/jSQlk3gLjsVti9lJHvH/pTPQ=;
	b=BAK6nV6RgBn7ejOhV7w76qkPByJg3CMpX/OPZSnO0PsQ5oAckeIXCe+AX6TD/xbyGvAfB9
	x3QUQnqloSV5eL4x6B9o7LNIiuNMfnoigZttdY+i+InmAenECo7ddNW0lmpFuzEsDlBIfX
	1WbE+0ubUFAx2A9J1/uFQ0lEA9yqqIM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438238; a=rsa-sha256;
	cv=none;
	b=pcIZpkGvKLObpaihiSYw4YU3F+UKgiqSPDYBmNeDoJSVK9vuQCRVhQrP+rWyuJ728i+v4v
	DYDnQkXi00MehjTo5zzESDeSvA2hyeIkLKrH/PjVoTqj6Ac+HZOPRSkDzmUvRXWx93lt+5
	wXTBdq25O2ZsH0mcwFHtCovyo929+Lg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=LglAKWAV;
	spf=pass (imf22.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759438238; x=1790974238;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jvk2RBzXwrA99Hwxay/jSQlk3gLjsVti9lJHvH/pTPQ=;
  b=LglAKWAVttojWXBJWXdOhxvE7+CSwBIvLFSW1i8Wftcok+gHxDVUr4fp
   +5L7wwbjlniqewpO1elNxSoVFz1fFjkYKuIEvryjUSGL5ns1AIafAn29H
   ZWo0jxKuOSAcxPntyDxzlC4blmwZVIGIG7R2D/Mo+LhN5yZNWs0YD6Xpt
   vqBq0ZAWYy8jqZuV1E1GTaFNq0LZOjPbHxLdewcpEdZdKhD7cNeMB/kRF
   xOv3rabc9MBNHuhS+3wZEVJrFUL61arM3S/gkHCpU/kGGZVZYCO0j2iOr
   00bhVav/Dsmygdo9TqoOWbm6xuUCRUFiAQJLVHIhTcmTkyHAvxJqgAWPS
   g==;
X-CSE-ConnectionGUID: YiAweu1YTFWm7gL7sAM34g==
X-CSE-MsgGUID: cPMixKcNRUaFt+r0RIS6uw==
X-IronPort-AV: E=Sophos;i="6.18,310,1751241600"; 
   d="scan'208";a="2929522"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 20:50:28 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:22450]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.22.27:2525] with esmtp (Farcaster)
 id 8269f201-c56b-4da0-ad37-545a7d678908; Thu, 2 Oct 2025 20:50:27 +0000 (UTC)
X-Farcaster-Flow-ID: 8269f201-c56b-4da0-ad37-545a7d678908
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 20:50:26 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 20:50:00 +0000
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
Subject: [PATCH 05/19 5.15.y] minmax: avoid overly complicated constant expressions in VM code
Date: Thu, 2 Oct 2025 20:47:19 +0000
Message-ID: <20251002204733.35652-6-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204733.35652-1-farbere@amazon.com>
References: <20251002204733.35652-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D035UWA001.ant.amazon.com (10.13.139.101) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 3B9E7C000A
X-Stat-Signature: qqy5jy1r67bx37h3kddxgm69pafjoc91
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759438238-767429
X-HE-Meta: U2FsdGVkX18owBsqar/7ctAVzyomY4Cdc0MSKT91KNRyKn8tOLKxQMBdWGX71CDDkq66FyGjAme6R15fcX4HAbfwXpk2kLp94iSopeyr/vU5myOyR27if78V8RznYdAOKuPNug1CbZEl0LGjdJhLasfvGUcEGZq3cLQi2TOKV9Y7uvIrA31oaj0p7yO/O9s1AOg1dDMn1ZtrW19r9auMIX2xxCaPzH+LTPcylOl/bGPXYbCbkgwhxCEg6EZ15bghXFJbCtn9JSOuNAQhf9KOkJDLAqzSryyl3LXozNi/wgY8X3U5jJXmHSv9nOzJscEWq5GT8QZlDNt742F2dn4LlWg0vcgS0HLQeTNHfO3ojMKuMGh6yPl6rvz4+GpracsdS08GnK9g7F2VrE0dXZQDUIj5XGLKkYrIf+Yp+lZQstlpjeNpvGtnPFzarpvzfbxZx/rUi8kXTFmTRgpNAgN0Be7MQ1OQqlQmk0yH02NoPax87Oas682U9+Y/pZPAZYgYajzljzVgr75yTdkTxH+8JfJOwDRSdvsEqiRl7z6AwFO2vWiFLTySDi1e40MfwK56i3C46NIOE2frjz0a+ev2ew5wUCpQn8z0EqLRHuItRRvt8+Zf0iLENbivPIZjej7/YnKNOBFClruIdFvi9Zj9iXDKa7xedna3NAtqzdkPzSXVqisEb95Mi6xaYR2metJ4/jlEnWVqkVL6PreCzSh52K9ewb44KKGPiDxWRvfuEGYE/JLc9mehnh2Y3RaLeaFKQm3ndxA58I6w/7D2t496Q08+Lgabx1KzZ1b94UVcB+P7x+nRhCWLpfkBk3+h7ghekseePHu5Bj2xJ3Wvmix1cyQD7rwccHnQts6XByJEzjAtlbsSuBoQv/gRjqOX3sEsQRVQQ5ehkj4TvsevPxFapvcZrewQjyld89a2aP3GqhM2Lqwv79zEC+jvV3AFjHz7YbhOftRjpBIN/B8puo7
 3szj8f0l
 I0f3suNryc7Agb5oJ1WrqGXHQJTVcK684C9Hx6P8C2iU6wrvbWQuP5g3MvdSKB4Ug6wPx+oJf64YjxwtxRNYky33ZC/QZzSFytOzfgi3yLFCkBk7BzthY6FOJdNC5WbdX8RJ9XkK3T977DZSUfV1rwh4DN9hXp/fBQHyPScs8cXP50FycLGZKnhR+mR4HF90jN1xVCNfdTC0KrAPiKs5bCHYqRIoLmnO6KBgO5IVShNwhJxL3tkv81eD6z5wvnaZhFkKMfZ27SFFZ0nGjxaSDQJ902rLFhXIbEXrBNrwd3BtkYVaNJt36Y3spAUs4p1IRIXKWk/1O02ymsbTsNJ4lem/ChZr9pxfeylq4hKm2+cXaHd39c4FoNSdjv3yEuuTDekQEhIm1HWkIjilSFXx6Nx5WQa4bwrEwJKNOeJNVhJa6Gf7kTNee/oEB0BEOVb2Ew4ZwGauk3Zk3zaxLAugrFmLKO7d//QphdjRsXk1nW4AzCFL7adN7VW/1DlOP7sIzy8VS5UknlQVq7diO5OxzdKjymC69+ce5kNT+vUU24h0pN8Ubt/czfKaVDSytkLlDTiZqbHRy+uDpIj0QcTtZ5TLBoOy/DSZTXDASLqgKIGLGzKc4xx/YiGv09d0bxLSHc11WZrGgzaKPyhkMFGH6m0DJWdinaV/K9dV3LMrnYYTcJA/9mpqYJCu1Den7FGYwO2ZOSx3sKic+JKsqR4YVLJooVEcYe95WJ+RcSGgUPeieLwWa9FExaHhdnmAk/7VezFzV5+1dEKGz1VStWFj23AkL2XM5ZMSYoSTcJftfI5f8tDLtu7+FqnOe2wr2yN0YMcwQigwFzhvRCpoiEIHdZwTJRcraC1lOYOSmnwDwKBXgJ/xyPpGkWc+3xPo5mkou1qTLwBC74yYMvrE=
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


