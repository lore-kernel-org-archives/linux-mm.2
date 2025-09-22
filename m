Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 184A2CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 12:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15CED8E000A; Mon, 22 Sep 2025 08:27:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 134408E0001; Mon, 22 Sep 2025 08:27:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 071A08E000A; Mon, 22 Sep 2025 08:27:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB6CB8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:27:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7ECE0871FA
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:27:14 +0000 (UTC)
X-FDA: 83916811188.02.99846B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A7D45C0004
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:27:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=T3S6PeR4;
	spf=pass (imf10.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758544032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=UgoheBkXZXHXgyC0L8G4ugQ9wKCZuV1Zt9KgGwsQ/p4=;
	b=wXZW+TDwZ0WGfWmqY3f+L6Lasi6uvVF0OLoQQoWkVH9faK8V5BPIV4EGO50vt9e7xggHyj
	TqHF7ea7yiejStddSlvdsLdeuHZ0uiqmKNaNEipeLimVzGuhyHeH3m8ffUnqmgpCltaQ4r
	s6qpbLhB25UKl7Mq4QaCL3gujju7XcM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=T3S6PeR4;
	spf=pass (imf10.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758544032; a=rsa-sha256;
	cv=none;
	b=WvsyPTb8xdIekw2YzQ1NxarY89Kn36OYmK4j3IUTyLz/BLjq2ILUtPFQnBZEImbQlCscLH
	7ktpIuprQj6k0PZfkuIbyOunbq23rxACy/uUZkI0Qy5lrUyN5go6y1NNgmffDAnsaZ6fLa
	kuJQlKbLeQeMuE3NaoMBPCdYRLjLk18=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EA6BB402A8;
	Mon, 22 Sep 2025 12:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9979C113D0;
	Mon, 22 Sep 2025 12:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758544030;
	bh=ETZgDSgeAnuggoKdC3R7s5QdUGOaFw9qEYrwj+PQwxM=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=T3S6PeR46N0y3ffZh4wlLo++iHwIpWjXiSk+l7zC2WNVttThnfCMo3M5g+UQquH3f
	 nz33sIMaOVel3qFAgxOyeWChXXTkXan6MDnaFH6VxkOgyedxyWcKtZDXsYCgIWnN6y
	 DHwbYgJJO/Dn/dUQWRqm6jDQiXDj792r3JtcH5ps=
Subject: Patch "minmax: avoid overly complicated constant expressions in VM code" has been added to the 6.6-stable tree
To: David.Laight@ACULAB.COM, David.Laight@aculab.com,
	Rodrigo.Siqueira@amd.com, Xinhui.Pan@amd.com, agk@redhat.com,
	airlied@gmail.com, akpm@linux-foundation.org,
	alexander.deucher@amd.com, alexandre.torgue@foss.st.com,
	amd-gfx@lists.freedesktop.org, andriy.shevchenko@linux.intel.com,
	anton.ivanov@cambridgegreys.com, arnd@kernel.org,
	artur.paszkiewicz@intel.com, bp@alien8.de, christian.koenig@amd.com,
	clm@fb.com, daniel@ffwll.ch, dave.hansen@linux.intel.com,
	davem@davemloft.net, dm-devel@lists.linux.dev,
	dmitry.torokhov@gmail.com, dri-devel@lists.freedesktop.org,
	dsahern@kernel.org, dsterba@suse.com, edumazet@google.com,
	evan.quan@amd.com, farbere@amazon.com, gregkh@linuxfoundation.org,
	harry.wentland@amd.com, hdegoede@redhat.com, hpa@zytor.com,
	ilpo.jarvinen@linux.intel.com, james.morse@arm.com,
	jdelvare@suse.com, jejb@linux.ibm.com, jernej.skrabec@gmail.com,
	joabreu@synopsys.com, johannes@sipsolutions.net,
	josef@toxicpanda.com, keescook@chromium.org,
	krzysztof.kozlowski@linaro.org, kuba@kernel.org,
	linus.walleij@linaro.org, l@kvack.org,
	inux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-staging@lists.linux.dev,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-sunxi@lists.linux.dev, linux-um@lists.infradead.org,
	linux@rasmusvillemoes.dk, linux@roeck-us.net,
	lorenzo.stoakes@oracle.com, luc.vanoostenryck@gmail.com,
	luto@kernel.org, maarten.lankhorst@linux.intel.com,
	mailhol.vincent@wanadoo.fr, malattia@linux.it, markgross@kernel.org,
	martin.petersen@oracle.com, mchehab@kernel.org,
	mcoquelin.stm32@gmail.com, mhiramat@kernel.org, minchan@kernel.org,
	mingo@redhat.com, mkl@pengutronix.de, mripard@kernel.org,
	pabeni@redhat.com, peterz@infradead.org, pmladek@suse.com,
	qiuxu.zhuo@intel.com, richard@nod.at, rostedt@goodmis.org,
	rric@kernel.org, sakari.ailus@linux.intel.com, samuel@sholland.org,
	senozhatsky@chromium.org, shuah@kernel.org, snitzer@kernel.org,
	sunpeng.li@amd.com, tglx@linutronix.de, tony.luck@intel.com,
	torvalds@linux-foundation.org, tzimmermann@suse.de, wad@chromium.org,
	wens@csie.org, wg@grandegger.com, x86@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 22 Sep 2025 14:26:59 +0200
In-Reply-To: <20250922103241.16213-2-farbere@amazon.com>
Message-ID: <2025092259-oppose-platform-c13d@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A7D45C0004
X-Stat-Signature: q17em6f56ji8jxgj4gytfjdgradu8xdo
X-HE-Tag: 1758544032-349419
X-HE-Meta: U2FsdGVkX19tscoSJy1d8g127IdM0KBu6bEzI+znD8JgJMC5LuQe2rVITU1uS25+f8Wd4SWzDm3mlHGJG9r53ROiLBQQ/yjMvilzo1uIxOLpmldvSpd1haVbe8FKKlTOdcQ0zrjIKmW7yCOu7uV4k0C3GO+UwJsyBatH1rVKU26TIbHrlvzlDA1bJI8K36Zryz6KzH9Rq9SHuklW600eq9Bos+SuqFRgmZfGRoeGDzzs26rCMmhnlBXc7qg2L9ZW350By91ntsdl9RaRVylQ3QiYD3TR12//yHX7nhmpaHyyTH2SQ3XBr7WBhpGAP/PUAXbF4JV29zrC8lfIxxzHzb0WNI5n8dSts5h/8NTP1lcmL5gCT6D7Qa6JNTB0lN9qP55dONYTyxcIZnp4r+S2bNvoIRkzo35kg1r+4xxx4b88d5W2N1TBVn0i1W44Y7s0EnyQR+HmVF550qviOhBLz47ssYXEaSxb8766qyZm/2Wjh64V6EmVMsrU4gNWU4e//2DPKe2hOtjQZoNme6+e9pUgEdKsMMbOgdC4LTc+SHxzpH4P9ckzJV6ZegwDvANn62M7UZ1wlL0PDsxJqDRqNBzd3OYoF/H2o+n9Oay9NBLGesCgrt9KQZ0uNYCy4AwQAcibGwkAKi1MA9Hz2CP0lkFmyqZJYne7PqH3kg6EuNqu/soxjQWr+kp7JQUoQKi08RyfWiMbl7B3lM3PgI6qQ0wsavEMXFBa3vweemfqMEe7/hNF6HRkGqYnagnrqOFM6AykuIZBFtjkWhcaQVXK81K0glQqeD6PcgMNizE0HkCvzErqxr1nasNt+h/FXVaVFCqnKMMjnk2StbfrJiMbwtINoj08Ks+FlMuEZS8ruO9W69mpBf1pSLRnXJ/qb5Rgu7iX386fFC5sGFqZJwUp63+6YRe/6sGxKAtXD47YC7Gt430hMEtCfa8HFSfpobVVN5p+8sZENtacEUC6Avw
 Nst/MoKi
 UeBwiiXx1onYeDF54IkTrhidjP8174ggehcMQXsL9C1tZ8G9Tz8qmmf+h8fOQt+bWonk9+kr0fYqgtpx99SinrXT64pLHXpMu0h6KWjQ2J0Xw3lcCu0ZYmbfr3vKRNU36K6rbefGpV5MNbZDuAfv+F2nwfIzV40224Q3mZAlZ9xIlakCNr8Fw2dnnaR+rRRY+ip0psvRJqhiaTfQ7JGzyiJ18+X8gcDKK3hhCdmc1q9Xi5e/RKyrnFyG40QmjJJMxgYkcfpcn+n5zAgrnYc5cTdl+d3jiNvR3hYWsK9+QV1Ji7bGH8Iuxisu4joxAFk+0BrZOvD+zcaWCMulLanXEYODAispDgZ5eKZGfKsdvzOBZqCVX10jAm69GV8hm0VzXWiUVl7e0HMTrZOqjukS4F7P3+xRriEds46RDFPZu7QSVD/8MNRWO3Yqo4WfWOcB1gvFIhYq6MnqoPduuS2M09HDi1187IJvPjXMXSYlqgxjyFNFvlMEuWQRnktVo9j73QL0mpsbPca4eq/EV0x6HCkJ8GA9TyxN4Mh2V5LPrB/sZcjKPxGoIKvIUbEh2rd+RpYrHINh1/PO6dKCFMWi2RcnzTutEhtlH/Nlv0T6+qSQjvCV223RnF5fxrfdogD4pzIRZ4/e3Yv86eemMo/b9HsJBb+Pk3WCcKYCHQ5VaH7I2dDol5E7xR3FOMacIpZnrUtM1b/lDhZXiqsnGaQ6MnWO23H/hvUDJTdZzvvbATr92yp3DYbaenaAyFpt03U0fUxWhBBlaxRNbOIUnatOZ34JNA9riDjgF0mv5Q41RUuHRQ3IKTSsvbflnUhVzF4846/0MK5QojlCiQdy44Gr5MTnNQgGf089PvvapZWmdFGsUhIC0wcKayFzIPxIRaqgSUMACEXi4spoD3XYN9WlPOqCSb505ZzjcwyU3rpH6bjrpsqYocgptgfuApzzutGwl+1/AE5kKuX0nkAp6IeW0wE7MM9tY
 Z1CPv8Q2
 7JHUpkoUDmi/58jWCOZoqKHVohaotWssyPWuBG+yGVsUUKsSmuc/Re0oEEsAfBLVp/2cBjwz9mj1Nv3CLaoQFQ0VDetlu/RuzgscEd8QDVA+VhRMNUPVtDYPMOAU47uMaiGsf2wE+DXpJ8zJywXbi9FK55ePNaouCei6T5m2jnWWwsYcVc7xD5XfzHWcFj/jilN29T7s9s1eDn28N9ClMDSB+tZdpdml80Jy7YVZOQh4Rz0MfnNosawELG3TcNp649iusjrlEUVk46L7Gv0F6TQZz0Tjj1AZ4Bjr+QKVDCm5oH4sCWmhhYkZ024Sip0x5hIqyirfMY04KfPcg7h/jy1XvRLcGb/OM7DMader+nwmPhS3FjkOqBdNNI93LEYPLle/sT3/TjstAwTEciGuXNuct2+RsyDdlHoVt721k8wenPWqiIUGAV3z45Lkh3WEq7Ck1NApd1KGuPVgh2yNsQhQl2fzrL5JfZQ1GmLLiJAj2y8uksTWLoG09emnrElqH7EiJqAjEmf+33sR6VNNxJT8c4vE8aUE+ZT2OLvlyPXGw2HjHYRH4dH5NubD/bWPdcLU84Of+EAqH7PcQJU1uTdbd3BakJR66m0U6sS3oS1nEtnennE1hq47u8G0QgncydbUecJCdqgeEKKoqZb0vs9g/ArKETeA2Iu3gYkaa1uI9nuSdVAUUseGOu0WCgzCyBNLaMWbOAoh/x3wpr0sbFC5i5VK44hz+aR1yiwn8uC2QcvAQ2uTzHdskb5CXUC1sXdKQuiTTOvgvF/g6gstiqEGyFAotRMc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: avoid overly complicated constant expressions in VM code

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From linux-staging+bounces-34536-greg=kroah.com@lists.linux.dev Mon Sep 22 12:34:42 2025
From: Eliav Farber <farbere@amazon.com>
Date: Mon, 22 Sep 2025 10:32:27 +0000
Subject: minmax: avoid overly complicated constant expressions in VM code
To: <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <mchehab@kernel.org>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>, <dm-devel@lists.linux.dev>, <mailhol.vincent@wanadoo.fr>, <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.ne
 t>, <edu
 mazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>, <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>, <malattia@linux.it>, <hdegoede@redhat.com>, <ilpo.jarvinen@linux.intel.com>, <markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <gregkh@linuxfoundation.org>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>, <pmladek@suse.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <senozhatsky@chromium.org>, <minchan@kernel.org>, <akpm@linux-foundation.org>, <dsahern@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>, <wad@chromium.org>, <farbere@amazon.com>, <David.Laight@ACULAB.COM>, <arnd@kernel.org>, <linux-um@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.fr
 eedeskto
 p.org>, <dri-devel@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Laight <David.Laight@aculab.com>
Message-ID: <20250922103241.16213-2-farbere@amazon.com>

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
 include/linux/minmax.h          |    7 +++++++
 include/linux/pageblock-flags.h |    2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

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
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -41,7 +41,7 @@ extern unsigned int pageblock_order;
  * Huge pages are a constant size, but don't exceed the maximum allocation
  * granularity.
  */
-#define pageblock_order		min_t(unsigned int, HUGETLB_PAGE_ORDER, MAX_ORDER)
+#define pageblock_order		MIN_T(unsigned int, HUGETLB_PAGE_ORDER, MAX_ORDER)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-6.6/minmax-don-t-use-max-in-situations-that-want-a-c-constant-expression.patch
queue-6.6/minmax-make-generic-min-and-max-macros-available-everywhere.patch
queue-6.6/minmax-fix-up-min3-and-max3-too.patch
queue-6.6/minmax-add-a-few-more-min_t-max_t-users.patch
queue-6.6/minmax-improve-macro-expansion-and-type-checking.patch
queue-6.6/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-6.6/minmax-simplify-min-max-clamp-implementation.patch
queue-6.6/minmax-simplify-and-clarify-min_t-max_t-implementation.patch

