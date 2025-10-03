Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3D9DCCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC7B8E000C; Fri,  3 Oct 2025 09:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C438E0003; Fri,  3 Oct 2025 09:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 344508E000C; Fri,  3 Oct 2025 09:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1DFB08E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:03:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 914AFBB74E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:03:12 +0000 (UTC)
X-FDA: 83956818624.10.ACAA786
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3344B8000E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:03:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ONLuCUo7;
	spf=pass (imf30.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvk2RBzXwrA99Hwxay/jSQlk3gLjsVti9lJHvH/pTPQ=;
	b=IalA0WX3FX4HFK8yJ9zzx9+f+9PWf4jj1uwNdhuU4tlBe+qh2klrCZ6ouCWU4fm1WDNAtp
	6Mk+t6sKZid9kPa1b7knm83LbqRJEM0oG7hxFpEENpo8UXLwLeEZ9YEsfV5g6BJnMsT19v
	Bc+G5Tj5Pijc+Dhudz4P111a3DVG3XI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496590; a=rsa-sha256;
	cv=none;
	b=JoEvhD+z5IufF5sie2KX6lgg6bfSuKkQ46XGoortt9TC2S1d7S05rdKi4r7z4v3bUUAT92
	M0uMTCB9NgiVEKboVxCM00j+mb/xAqauhqP0HYBQBRTopFSkz0XGXy6fVVtQs0bxpEotnD
	3V1+HK9QEya+5xQ45UrlhNfXR46e74U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ONLuCUo7;
	spf=pass (imf30.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496590; x=1791032590;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jvk2RBzXwrA99Hwxay/jSQlk3gLjsVti9lJHvH/pTPQ=;
  b=ONLuCUo71OqpN0mVMHq17OOMi/5xeVksbpuu43zxK53ZTplFCg3YwF4s
   9DI1KAKpiS6ajfnBQwJpaGrj0E+bBBnPouBz3Jc038G45Ll2iK2COf6Wy
   WlBUayQ5sFzHyTQfb4CdIyTKVEQntwu+O28FSaXNPe7+eC0XBZYfQlySG
   GweCL6mNUVBnkyHigQTbD4iGFxKv64GUAVUE0x/1P4JBdClkgFbDfeB/b
   GZoh/R663z3KGhBOt44vVNmRryqnKjDLYiBrXk9ncEdHcanyxpsXPt96L
   innUxct6549292HNjciQipA2xH57kI61IM17q/Z/Gs8dbACfbHEYE9dyS
   Q==;
X-CSE-ConnectionGUID: MwIUxTVmTm2YN8SyUS1pbQ==
X-CSE-MsgGUID: jal+YITiTyelbtfVkZKBgg==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="3064009"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:02:59 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:7814]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.44.161:2525] with esmtp (Farcaster)
 id 64d906d2-0ad8-49c2-b23a-b923a61bb69a; Fri, 3 Oct 2025 13:02:59 +0000 (UTC)
X-Farcaster-Flow-ID: 64d906d2-0ad8-49c2-b23a-b923a61bb69a
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:02:57 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:02:31 +0000
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
Subject: [PATCH v2 05/19 5.15.y] minmax: avoid overly complicated constant expressions in VM code
Date: Fri, 3 Oct 2025 12:59:52 +0000
Message-ID: <20251003130006.41681-6-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003130006.41681-1-farbere@amazon.com>
References: <20251003130006.41681-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D043UWA002.ant.amazon.com (10.13.139.53) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3344B8000E
X-Stat-Signature: mhyftp939uepaph5uzypusw5ji9ebyde
X-Rspam-User: 
X-HE-Tag: 1759496589-456518
X-HE-Meta: U2FsdGVkX1+L3wlQo8psapG3OofJMAZgVQI318uGIxYZExjKCI8+j/sscL9LW6Jqlzh/fyaDaJKju+QuhgBz4yUhSbEiKKfw5pfR2/le64e2B1WSMl66puXx3W9JJg+T05sTQWVCxvDb0LsSKJ9bv2cjPdKs6MeqRgrkbt3nhUIxEj+HUNMbk/48E0eKeDdr/LyX9PwgNim+KscJoCLh4ampWSfMnJEZgkMnYTUB+ZsGkq6xDY6MkEC7bScJl5pt1fs3ZuDSD1GKbsa8MREHQC3oh/RQJq0LlI3udMPOUbU2BdpnkpImmKg0/cO6SKLf28Ttb/WvlA9rHPwLunTIHDMsP1pc/nYLW7HDOPduAFvrol0LZsXtyp/mK8cZ5TmuzqYPOsf43pT1S1/a1pyhXkfbU3QbfSlgrEY00ZCEWb9Cso5ieVJGdbt7O93nrvpYtOqWHXUctsFA6zR1goxfsbM8hM4TENHNQzsWLfKfi1ynbCoNYFtWpLxxXNCWSZwZMQcKf9Vu0upzPRY4x9VgJDDfpmtOQbyKsyHHXtKnZLtVX0SAsR3wUOggxASySmDQM+fHXIhCgg3XciPkQUOLjsEdYThKp8SLnUg/7rQKPJw/6Dd/SW5QvkqRIzp2gWnVW2bne9FR8NMafGBYbrzW+f3hl2/zLATAEIuPc6t56FWc2gWTmV/jnchrw9Qbg2LGcOqnuq2NAZaJlNvcws6LO/Y0SfFWYnpdFlpsqo9f+71yNCYai46NA23RaOUVKLGxi0ki4ckXmSkifOacgxHYar+8dMJg77mw0vo64z42WQJTEMCBu0PDoPp6tZUP+85LrMp6ZyuM0if0lodiQg/L8ucnzXJa1nBwLa/AQh2Z3MDnCRRNz5ViMlEnVCti6+xSN6ySItF/uNwQ2hFSYZUm6E+BsNn+1bJoMBgCet3S6PDG2ETRReOtntGZDwciY1tUykvqOjrn2jEAVJrRf/1
 aGAvaW7I
 a076Ny78+BlhjHxBD1ieReDcN/UO3DVfb5Gvs8FkkU7yuH6L+GkVg1eiAYoePZ2mZIayZfXa0KM0Iyv7VIPII93IxTQ5pcFWP4ma6ZvgqVERY6Iq6LZsIDDGluBDlF4HehI5zformh0SdPvT57jxvslAbs2OWzuoqr+hW+5csDOOQKmvAQrkQpkdxDEVyC/w/+2H6M+72/04YCzjrLre9GB27JanLb1DEQi5TB3L3lqKCKD8hgYJd8uKJUTFEfv4UqY+lhuPozTKlBRJTw2JxeTKl3Ak2KHbT5CNxCPO1f9ATiSUHu+QvcyRRj4JUMr+mUeTykvsD2hgQvjAJJd7kmoGco/9zIf3SupP6so9buF6pDU8B/I2KjspqR3gbwRSI0FYEyv84ByQ0SdsPXRAl8toxV86YJlTYajdWVdkr9ncZLI59JSdZH5H/TixKZuOyIdpk7GPi4P9eMuL2JZXk59na06GFrbZSzva3KGStCgDMXqUIhj6i+0eg+CMjiFs4L0mYTCWGE353a/nTqVAZk4Q70fnQudDWD3/AfZjjWcjYBhv7iPczAJPxH3vCR+GJPrGJw9xc58u4hRPG9bCTIIDxaFfrD2JOuDL70CYfqOmQ0gy+MQkye9beOOybX6yeZUqX6FKXC3gsJNdOdm5j49a/zXFW1bWxfW7M/nj4EPY2NMriYLoQKzUNppxi4u8AMK0x2oZmuwK47M9tn8iy+Ej+Mg97QZm16Z4edH12DKBS4zs3yGNoy48gKeS4KljhJEx7Gls6DCrzyvWpuOBtKw1ujfmbqm275Xepjozgt/JkZwZ+IvlqTm2bkQ9sGqznC4WCKsSOIcHzK2OLQ+JCpqJpkxVK1cGrF5TTifzW99gA3PZzA5gQHDttTzrxjy9PxRL3vnJnFDj9HBo=
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


