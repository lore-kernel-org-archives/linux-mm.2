Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AC98CCD1AA
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B2D68E0045; Fri, 17 Oct 2025 04:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D1E8E0016; Fri, 17 Oct 2025 04:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B5C58E0045; Fri, 17 Oct 2025 04:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32F958E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:16:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0AE7611A6A5
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:40 +0000 (UTC)
X-FDA: 84006899760.26.9DE87FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6314D20006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=vtaKK14+;
	spf=pass (imf13.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760688998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=r4C6dFtTHEPHaJHDc2qtKIrCTPNO4IsVV3hylmF7kow=;
	b=gtK9yUulAbCgKDcOwgdmy120Gr59BhmAOVxWW3WO7gAaU9AuC72DtpVkm84wVfGmhkfuLM
	AvLZLizbVDQnHCcxph38hoTufhtAj15BpXyUIEjsdvXBZfcZNXTcLqsBw9ks/ihITVPpVq
	7DfKncP0HDbgU/0MgaX8Sh3KKY3y86E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=vtaKK14+;
	spf=pass (imf13.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760688998; a=rsa-sha256;
	cv=none;
	b=f8YfEwm4PUCDrEiBPyNbKmSS2PQfoZfkqZ878oVuMG1odZ2mWMlDFYvcXHFLSfOZQziewi
	Qs2MkPEpAdlr4unz/8T+4VOiWWObD/l+gCxfNrlKq8PJRvI9ms+PgLYXj/wvSYDcEbjgWb
	deJeSymQWeQqH1N6PyFWsNuPpW//Dbs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 858506429C;
	Fri, 17 Oct 2025 08:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E2BC4CEE7;
	Fri, 17 Oct 2025 08:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760688997;
	bh=mrVO3P49eQwci7HyE+0sEWTRAv/DZfs7tgERqKYjGd8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=vtaKK14+sB0lYRy1i41g6Ma2TU/chU+mqe8psQI3u+fEbGR75BF+XaiZMPbfysQQa
	 rZlDPrlf6mqPYttH7l6XlknXZ6mWsvJjsbJMonWBj9mUYJcN6/R4KSjIV/97MNJtaL
	 M+YDMvWsn8aXbtyijjI50cjLuVOxn9q0zuG5PbP0=
Subject: Patch "minmax: simplify min()/max()/clamp() implementation" has been added to the 5.15-stable tree
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
Date: Fri, 17 Oct 2025 10:16:17 +0200
In-Reply-To: <20251008152946.29285-11-farbere@amazon.com>
Message-ID: <2025101717-upswing-emptiness-a592@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Queue-Id: 6314D20006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: hyxhxcza3c7coh8ue5nhsyfu4s79ca67
X-HE-Tag: 1760688998-402798
X-HE-Meta: U2FsdGVkX18VudIgzesWrxODcanwXR6QedE1Sn/4d2F4B/sVzB0DYunkL5WCANpfsiBplQmAs5Le4znVGpLUETsslCdEo9DezGGkSR/uAwYGW3PjSWQ+ZliuGQNfbQnIgiTWU8KAHGTwPlaCx/jnbaC6gqdW4XuGfDeIjbODfItPiBC+h0hUYGWlMvmgqPDe425qEPsc7Yy6b/E02J0973SjLvtYaMRXKjb5q1IwaJNjwSzmK8GW3dEHiZ+JT64i7Q9z+OyrufJdOqAwva77oGe0JcqFgfLd4WSQhKEEO5jYuDb5vsT/tLpXnJmUDGiGiV/RmiTCUmsg2FJrXizfv82BeQF5ob6iSHfDb9xhVaCGdOUdqnZ1EFJTL3Pthjuq/Tsa9X8shuyprFh420l2rTbcMfq3vLR60XB+ZwdJJLJKsiDIfr0uSVXdAC0dFjgT+5drWLSWCJHtGfBNLvXiVUkLsAPB8AgtEgXZVBz9fb9KSfotSiZm9t1P7fVOZ7m/i2Dej9pIlLCxJDWfyUbaKWTqPhGuN10WVMtMhjBqKmfqUREs0gGtERoQ+Q01h2fzBc0i59Xz6MV+xUVih6iaHg9lY1TgtsRmuB+c7DcTdVq/r4On/tSdGiL6I53MWhi+ybttTZz4JjfweKtmTJ80de3qz/cBktrgQKZSKr2+YBdvvn3stGUx7vqUZV47wwgVThPBvvrcUfy02AZ98gZIZ7WubWL/C9+L/wfWm2wp80IvatLGJqBrG1aOGkgfSfFTHOMQmrTPW3nRTq9iVfqtdgSNQNN5BSe3c8Z3UMXOLGKI4MgN87aKvVu0hVfVWZ2A8oXeuhJ7/N5ydABvkG1aDMPswgnQih1o3WsZyd6Z3rr9yCD/ga98prtYwnkkTFUG+1eIKpitW0uJfllsxz9xLdrqAvbefvIl/siK6EjyHojuBSIuJx3Iac/z5QVStwClEWEH9YJIaIWQOZkPt/Y
 DiqTOmbU
 WGluO3FvtNRaS56sZnSU2oSd4SFvzy185njrwxe7K7MOPJ9NtwuwRJZ6L1vuT1s1zD8+TXlbtK6nHvuJ7Qzp6YXJ2h2FwOOyOQCOBlXkZCXlF2ayyjEdvVPPH6SCrEe+ntABSnav6Md+HHLvDm0/b+3TKbI2Z6FIAyzudNNnbR46UGitYqRzG2X9e2v8ee9ScvHfQqYOPE7WO1dgKDGGTgZf8Jh/7OeP7+gkz1uyZqtqxdqJkUHAe4h9BbnIzuwjJWM6AhNWM0KWX9yXgWGbWaI1FarxTmBIlDdHVNyvZ34KcuGa6PmeXomljN+IOyBhNcRO2Al2lbYVFmALGhN+6LHHbNQfHLExUwSUK2vUpXAeMbuOXF+WUYQPfWy8wNkE3lHYrq/lzUyIhQ524gomqFHnHtzYAI2xbkc4ScuYMhHrH7eXeIeWc0oA1ziWtYxnM/txcQxM1Fi1C7uQGDgyNBFgesRP8wdHGVvoxcte97ZjTf1aVTssIxHTPDjtjexNemjaTWK2Ae5ckowRj4w7iujNwGLBFa0mcWa0wipzeUJhQniZQqINqTm0DH8n2EDxIJDpfIWpY/PrMdFIHY0/vXWKyKW93eTSIWDuiPMdP/T2JCVOCjFoIt2qUVWGuTjjlol9EUK6ax9KPwG0dzKPTLaA02ZI/7l5SJkv0/2bO2Ik5Og9j0Wb07T9hedmq5OYxu83cCeIlbFK+FHU8poShSctkZ396+YP3yKPUKiRlPAwJpyNayLyKsQ6TeyGbqGO0sKhD/W9UZvdodaMIeDtJh8gzN51ODY8modstOQmBzfh8If1TWqmm1Nfw/3xN/n32zPPA7v4OhfVUbgntDMRcmJnm8H6OIeMQBV+a+i15R9G5VYdcHNja6Dc8cGFPZ1eh7Fl+J8sJowlHP7BdhObgGQvXlnMQB/xlGAf1a0smkxdhZDzfTzzJhpPg9Dk3Mtw/N5MW1r42lxH8TjScAQnKU5Zpi3k8
 hRIEUrcp
 TjbVXVfBDw8GitGZZskn0OZlTHWw+bZWqR9RkFCGa/VJ2ZpP7t4102y46D1Sa1eZQ3WVD5V6kDkU6jbOiM28meNrkdaJdRu5HBkZP8fvgptUvUyNiQYI4Z/mzoaATDTzJ7PebCVGE5qIYYuCW+7gD4HEnjVVWN9r3IbkPLTzEYcdwtD1VbOjat+YV62FtfCLYsHuP6+rBS8X1ZE5VpNFETmTGKP13cxog9avVTAs3f0tBVZgx1ohJosA6ZXNdkg+lGPi1SXaKPMXz+WrAlqERdvnAHGD3Dma2gv+bmCrRXyKPzzZ+hedP1Fd7s8DOkT6i6RQTAtu5t7GuqQGqWJyz8ioU+8cDqp9klpKxEpWwVatRNcM9GX7CWSDAUBN5D69LzFC9T0BWa8sfIQUAyiyUN2Vp0pYH+5NpFLtVUsOP7HmJvIjlsYx9EFajOa8Adwlv78Z0ssPDzoIzNsNZt0CDYEg3eUpYx191OPQGjDKC3sbHs93yIY5566+r7gGFpbnuBFN4FRWAIu2CjxmloYCMeZIdwEZAtjZUTTjeX5mAH0rILL3UafLg1SABww3J0nQHEKs9+Aj7A9GCMLdC1D/PHSALL48t5p6qmcyaEmxccyIERzqHNUo0VX35Cq1O+UQG7OI3U4zvnzjEoujDIFhhWAaLFG1FX2JHHLJoxsznqq45QhFRHiFXzUUOHg4+4GdyS/RdzXi7VrawK5R2GskfN1vcCOtcgUfB5naQ8cNbsIbnE+/631Xry+KQ0prmRdIWD9zRwnnZ+2DfJDDCLzqhT5jl6+P8f7a7t2uBzfOSjj6BxgjNXKCE3Q5UVkXJSMais2fSRoYSC0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: simplify min()/max()/clamp() implementation

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-simplify-min-max-clamp-implementation.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=36971892a=farbere@amazon.com Wed Oct  8 17:32:42 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 8 Oct 2025 15:29:35 +0000
Subject: minmax: simplify min()/max()/clamp() implementation
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari
 .ailus@l
 inux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <fre
 edreno@l
 ists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Laight <David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Message-ID: <20251008152946.29285-11-farbere@amazon.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit dc1c8034e31b14a2e5e212104ec508aec44ce1b9 ]

Now that we no longer have any C constant expression contexts (ie array
size declarations or static initializers) that use min() or max(), we
can simpify the implementation by not having to worry about the result
staying as a C constant expression.

So now we can unconditionally just use temporary variables of the right
type, and get rid of the excessive expansion that used to come from the
use of

   __builtin_choose_expr(__is_constexpr(...), ..

to pick the specialized code for constant expressions.

Another expansion simplification is to pass the temporary variables (in
addition to the original expression) to our __types_ok() macro.  That
may superficially look like it complicates the macro, but when we only
want the type of the expression, expanding the temporary variable names
is much simpler and smaller than expanding the potentially complicated
original expression.

As a result, on my machine, doing a

  $ time make drivers/staging/media/atomisp/pci/isp/kernels/ynr/ynr_1.0/ia_css_ynr.host.i

goes from

	real	0m16.621s
	user	0m15.360s
	sys	0m1.221s

to

	real	0m2.532s
	user	0m2.091s
	sys	0m0.452s

because the token expansion goes down dramatically.

In particular, the longest line expansion (which was line 71 of that
'ia_css_ynr.host.c' file) shrinks from 23,338kB (yes, 23MB for one
single line) to "just" 1,444kB (now "only" 1.4MB).

And yes, that line is still the line from hell, because it's doing
multiple levels of "min()/max()" expansion thanks to some of them being
hidden inside the uDIGIT_FITTING() macro.

Lorenzo has a nice cleanup patch that makes that driver use inline
functions instead of macros for sDIGIT_FITTING() and uDIGIT_FITTING(),
which will fix that line once and for all, but the 16-fold reduction in
this case does show why we need to simplify these helpers.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -35,10 +35,10 @@
 #define __is_noneg_int(x)	\
 	(__builtin_choose_expr(__is_constexpr(x) && __is_signed(x), x, -1) >= 0)
 
-#define __types_ok(x, y) 					\
-	(__is_signed(x) == __is_signed(y) ||			\
-		__is_signed((x) + 0) == __is_signed((y) + 0) ||	\
-		__is_noneg_int(x) || __is_noneg_int(y))
+#define __types_ok(x, y, ux, uy) 				\
+	(__is_signed(ux) == __is_signed(uy) ||			\
+	 __is_signed((ux) + 0) == __is_signed((uy) + 0) ||	\
+	 __is_noneg_int(x) || __is_noneg_int(y))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -51,34 +51,31 @@
 #define __cmp_once(op, type, x, y) \
 	__cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
 
-#define __careful_cmp_once(op, x, y) ({			\
-	static_assert(__types_ok(x, y),			\
+#define __careful_cmp_once(op, x, y, ux, uy) ({		\
+	__auto_type ux = (x); __auto_type uy = (y);	\
+	static_assert(__types_ok(x, y, ux, uy),		\
 		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-	__cmp_once(op, __auto_type, x, y); })
+	__cmp(op, ux, uy); })
 
-#define __careful_cmp(op, x, y)					\
-	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
-		__cmp(op, x, y), __careful_cmp_once(op, x, y))
+#define __careful_cmp(op, x, y) \
+	__careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({		\
-	typeof(val) unique_val = (val);						\
-	typeof(lo) unique_lo = (lo);						\
-	typeof(hi) unique_hi = (hi);						\
+#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
+	__auto_type uval = (val);						\
+	__auto_type ulo = (lo);							\
+	__auto_type uhi = (hi);							\
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
-	static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
-	__clamp(unique_val, unique_lo, unique_hi); })
-
-#define __careful_clamp(val, lo, hi) ({					\
-	__builtin_choose_expr(__is_constexpr((val) - (lo) + (hi)),	\
-		__clamp(val, lo, hi),					\
-		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
-			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })
+	static_assert(__types_ok(uval, lo, uval, ulo), "clamp() 'lo' signedness error");	\
+	static_assert(__types_ok(uval, hi, uval, uhi), "clamp() 'hi' signedness error");	\
+	__clamp(uval, ulo, uhi); })
+
+#define __careful_clamp(val, lo, hi) \
+	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
 
 /**
  * min - return minimum of two values of the same or compatible types


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-5.15/minmax-add-a-few-more-min_t-max_t-users.patch
queue-5.15/minmax-improve-macro-expansion-and-type-checking.patch
queue-5.15/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-5.15/minmax.h-simplify-the-variants-of-clamp.patch
queue-5.15/minmax-add-in_range-macro.patch
queue-5.15/minmax.h-move-all-the-clamp-definitions-after-the-min-max-ones.patch
queue-5.15/minmax-don-t-use-max-in-situations-that-want-a-c-constant-expression.patch
queue-5.15/minmax.h-remove-some-defines-that-are-only-expanded-once.patch
queue-5.15/minmax.h-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch
queue-5.15/minmax-simplify-min-max-clamp-implementation.patch
queue-5.15/minmax-deduplicate-__unconst_integer_typeof.patch
queue-5.15/minmax-simplify-and-clarify-min_t-max_t-implementation.patch
queue-5.15/minmax.h-add-whitespace-around-operators-and-after-commas.patch
queue-5.15/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-5.15/minmax-make-generic-min-and-max-macros-available-everywhere.patch
queue-5.15/minmax-fix-up-min3-and-max3-too.patch
queue-5.15/minmax.h-reduce-the-define-expansion-of-min-max-and-clamp.patch
queue-5.15/minmax-introduce-min-max-_array.patch
queue-5.15/minmax.h-update-some-comments.patch

