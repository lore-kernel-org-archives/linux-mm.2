Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2E5DCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F6908E000A; Mon, 22 Sep 2025 06:33:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CE438E0001; Mon, 22 Sep 2025 06:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BDAA8E000A; Mon, 22 Sep 2025 06:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 283338E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:33:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C9BE38743B
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:33:51 +0000 (UTC)
X-FDA: 83916525462.27.D5FA80F
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7DD2AC000B
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:33:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=YhS7L9H3;
	spf=pass (imf22.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758537229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ripGF9rqnm7tHR7M3YpLJcXn9QY6D+OUp0N8RCNiC7M=;
	b=MCkfk8UiTeZPFnNrKzx1dfuKWArZHHla3U9jMHPpxGs+Lxl06BPGal4r+B/zQk2SAXlTzl
	CPBdS96MlFkhNl9nnDOQzfy1f/163nAybLNgCZn6gZ3h3gnUMZTW11qOuG5zTc268bgMEi
	gY4pJhvth+roUYp7cUrTOazoH89pv9s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=YhS7L9H3;
	spf=pass (imf22.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758537229; a=rsa-sha256;
	cv=none;
	b=N0h+v8bij56CsVylsnxbOOaPg5gLm5pbgenomz+Q/kcEGzkRRZqKfRiU/pXMQSksqs18Dd
	YMm4iQ18EWfiMv+iMBnrvd5t1zCuUsaiH3OhIB7+ID/2H8/4RROiAk34g7UcnRdFwf8lrf
	OUv7rUvh7/7cir05MKuNfM7ILxVOkYI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758537229; x=1790073229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ripGF9rqnm7tHR7M3YpLJcXn9QY6D+OUp0N8RCNiC7M=;
  b=YhS7L9H3cFbVSgvINONUz2kUHhbyBzZ93h7L9+2CNhozuqA08tjJ8aTj
   rK0DKw5yg8UwpSrgSWSMBTYM+KAeYnu07u+XFX7y+xLbZX/dCsZCcE0u2
   2AAPoF6RAp+fDONhot2U6QHYpTCTVmGxk2SX0CyBPTf1mJ1FVZ8qQOe2A
   GfCPetnSFJv+BFOTfpkUmG+5oEja+UkWTxDYjR1e2sDuP5KEDaggTAFK7
   RldN7WpqKmzUiUYWXahWTViDHeqPp7AnU3x+Jd87q+8hk3c4IVarwO1dE
   1fqP2Th34+rjkoTpge3bIAr6196wqv0B6n6qZZUIOZ7IWUga1MLx+fXJD
   w==;
X-CSE-ConnectionGUID: EfS0ySD4QuiodgYBvLgJ0Q==
X-CSE-MsgGUID: iJ0xXlIjTmGXhiqi3oxuFw==
X-IronPort-AV: E=Sophos;i="6.18,284,1751241600"; 
   d="scan'208";a="2475964"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 10:33:39 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:14817]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.23.64:2525] with esmtp (Farcaster)
 id 574fc1fc-5740-4523-a02e-399120b77f10; Mon, 22 Sep 2025 10:33:39 +0000 (UTC)
X-Farcaster-Flow-ID: 574fc1fc-5740-4523-a02e-399120b77f10
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 10:33:39 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 22 Sep 2025
 10:33:13 +0000
From: Eliav Farber <farbere@amazon.com>
To: <richard@nod.at>, <anton.ivanov@cambridgegreys.com>,
	<johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>,
	<mchehab@kernel.org>, <rric@kernel.org>, <harry.wentland@amd.com>,
	<sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>,
	<alexander.deucher@amd.com>, <christian.koenig@amd.com>,
	<Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <maarten.lankhorst@linux.intel.com>,
	<mripard@kernel.org>, <tzimmermann@suse.de>, <jdelvare@suse.com>,
	<linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <wens@csie.org>, <jernej.skrabec@gmail.com>,
	<samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>,
	<dm-devel@lists.linux.dev>, <mailhol.vincent@wanadoo.fr>,
	<wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <ilpo.jarvinen@linux.intel.com>,
	<markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>,
	<gregkh@linuxfoundation.org>, <clm@fb.com>, <josef@toxicpanda.com>,
	<dsterba@suse.com>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <pmladek@suse.com>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <minchan@kernel.org>,
	<akpm@linux-foundation.org>, <dsahern@kernel.org>, <shuah@kernel.org>,
	<keescook@chromium.org>, <wad@chromium.org>, <farbere@amazon.com>,
	<David.Laight@ACULAB.COM>, <arnd@kernel.org>, <linux-um@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-sunxi@lists.linux.dev>,
	<linux-media@vger.kernel.org>, <linux-can@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-sparse@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
	<bpf@vger.kernel.org>, <stable@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, David Laight <David.Laight@aculab.com>
Subject: [PATCH 01/15 6.6.y] minmax: avoid overly complicated constant expressions in VM code
Date: Mon, 22 Sep 2025 10:32:27 +0000
Message-ID: <20250922103241.16213-2-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250922103241.16213-1-farbere@amazon.com>
References: <20250922103241.16213-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D039UWB002.ant.amazon.com (10.13.138.79) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7DD2AC000B
X-Stat-Signature: n8my6az51kwi6riybkrk8d8ibcy467kq
X-HE-Tag: 1758537229-688314
X-HE-Meta: U2FsdGVkX1+fKoYR1sFU8Z6uPsmcWbLuneil0Glw5tdGg/zYDQGxC12Lv5VRk4Qo++o0WhF/ZzLE1CFr0z63YxgyS9PXYks/6ziGsftCdz9Z9MrwE8myUiyYLtJ9KthUqHaRksWHRiZ2VwW3/7toyBeyxwDH71ojqcSsnN3ZzcJ0yx4HBkpzIH1gKAwLgMCKu1ZAmG4qwPKXnKdBII2gUjUL7CpSqsolnCrcxGhkDjryGk+dbrozaOCpQ4cdNdQbmqDlibCGbUzBQGU4KYwXdULIlVyvgevDrSHk1aJoxgvy/9TkNzNEsqfoYK17DWjkl5vwdWblSg3Twmcvhq9ZiOJ4jLSq73R3l3QJuicVGxRZTRomP411EXJ5Z+VcI9wgeVS5fp/hV7vjYUJd5l4UoErYxCykmsOgj8P8N6E/TZFKQsuhtQAKyBlM4ILsx1N4fi1GmdrOZb+Im3JY1P3lHL1aZ0nJre2BjpDI7UgVXepfSIhcRwxSPycQNdt/2vLxJgrHO9U9VPczd+oW1hsxKZOkw2pwlcWR9FyvPr/8a/v5LxN/lAgqGbWUyJD4qeTmFmNEx4eKfJnnmwl3zEETPC0q6naNe6oTdz8EG80sgoPWdcDGdD8qIqiKxYbi9sunt8qGmVlSTgp+2bHk/PSXBuBLzubXeIeQu1XNlJUrwF5V7Nhxo+RZk5WBvgEb9PD03uzkrx3/AKPg7YrjQv25NAC6hmmTM3vBGd0vMVD2xs8e4yyn/Tza6HGgPGRS4zI0DLDJl9YjwR9Zsdc4ipT7Cr0/AJd91YkMitxYuJHjmjz3f7b9w8/CCtOAjhFWk1eEDCuoIONl8XYo2hc25mBQvkyhHC0ICOf75f5napZCu/SjpWrYayKofjdaNcJx90XyDQjuF4y+7P0RACwch1o4+m8c9s62ivG09nIUencTJhkoA0z3qGd4QoaJDuprfSl+WqqfLL3Lf2b96ht/obo
 UnVQiMIy
 Jjfa5hazodtaVMTMZdsQjaxo/FJN+BIHhr2FpgI1mW29TE9HwWpFK46Qbm0N7uIp5Nw94zgqcR62fdGvEkumvVZ/8fzLSeaBcqanw5CdWx5RkQr4dYc0+xIMpHyYPEMxrjEy4eYgpa3+mmwPhvS1Ee9b1FhR4bE8jeLTmVvYDB9q+NcbDqx7brgHEUNI+t3UxmR2axTZEu/B89j1eUCa/z5H7zMiuUAVaQEbWM9qC1BSBah11iwneiy2E9dYbAEQ5/ZtMay3wNP11KI7jEYhZn85aPygjMU6wV+9Vy3GNj+9dd2pjbRoI9jrmFiOq/SfeSfL0qa/S5APpGIW0Y83GndlkRHyndifjGTLBx3XdBf/4pvSKOCvhPb8sTMnhPOsAfP8ePmR1ZKYjGIo6PSgqfKEjGw5Utn7j8yHP44wP3u9p/wc7SJ7zyIovzRotNmGYl2inPSOl/VCkSRz1dpJuh3pBZk1/9JIq6bIUnxlOaIIL6n6aP2o6MsdV3IqM7XzFeJxUAQ+YBbFtESlDKbwc+dykcFU4bbK7Ge5LW5UZ8sCDI1Crg0uHgiQzTHL5D6yZgB+IHafpb6Zbu+AJmkBhpIQrN3xZINCqNqlnzuYfpR0PuWgFmWy7U1GqDfrMVDsf85wj1qF8uPPcdhw12T1FVbdePne6cPKBv6cSw0cvyRcZhIJ94f5mxr8ol/8t3RSxfWcICNnMYYTdzkwD4nKwTkjm+TzIOmIz49ZSN0IH2ILOecO7NQ4pv85HjMQXjNUQCaELxPVu4+7Bgtr6rDh55nSY4///yLLaX5Ujs7SDY6Qk1ifMImfQHaEjwuH6qNJiPkXegtErUIJxPS5bRV0LictRt2lAmrB2AK1ZEN/nhnN8oF7TI6lcs89SnfqstK2Lc4MzOG2cJzDYAd4eCOO3Cbtk5fVjccO451cZYQ/WMjBfYj/biO+9saXWQw==
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
 include/linux/minmax.h          | 7 +++++++
 include/linux/pageblock-flags.h | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

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
diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index e83c4c095041..a4bf7f0989b2 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -41,7 +41,7 @@ extern unsigned int pageblock_order;
  * Huge pages are a constant size, but don't exceed the maximum allocation
  * granularity.
  */
-#define pageblock_order		min_t(unsigned int, HUGETLB_PAGE_ORDER, MAX_ORDER)
+#define pageblock_order		MIN_T(unsigned int, HUGETLB_PAGE_ORDER, MAX_ORDER)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
-- 
2.47.3


