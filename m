Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57592CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20348E0049; Fri, 17 Oct 2025 04:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1648E0016; Fri, 17 Oct 2025 04:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BFAA8E0049; Fri, 17 Oct 2025 04:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 83F428E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:16:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4CE54C05B6
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:53 +0000 (UTC)
X-FDA: 84006900306.14.511BE5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4B6341C000A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=yZp8pO+C;
	spf=pass (imf20.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760689011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=xoI1OycUcWM7QtXYmHaSyIS4e9V3U/F5LjtqbaP+WNw=;
	b=caktTDqS5SOay5nl3Fb+jru42LJHgiQZAiFAWVH3tseNLd2KiAbnEXak/mgUps2KBagLk8
	Cq1NW5yFeI9WK1XOV4javugn83wdkCv2xZWD0KFNnfKhQI3E8S+ypvKMrZIB/ZWxrIjUdf
	5XBanwAdtM2ok1SuuFVrx/PHTiSBpeM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=yZp8pO+C;
	spf=pass (imf20.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760689011; a=rsa-sha256;
	cv=none;
	b=TOmEg7vOpanhckz5jyL21ZYiyCtGVB845S0ycultnvrrfb5BO4MLi7074a3KmWbJ6IVX8v
	HmJGh12UmilI6bFdYB3d9h7IVvjCKGPuepIwTAanGfGpGJTDO+VDNmWF65hRoscE1TnpBK
	fYtVUVzRqt3uK1RSRSrm4GGk0lKqcPs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 530FF409D3;
	Fri, 17 Oct 2025 08:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC2CC4CEF9;
	Fri, 17 Oct 2025 08:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760689010;
	bh=9gnnvv3Ezt6vrJIZX/HYPKclBhyyVc53iiep71r9Gjs=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=yZp8pO+CPx9UpU2pA1zuE8HzKAfopDNSTo2jE+UQ8UwXM698oXMjTGNvRQFQ07p/v
	 bk2GH4ZeqdaYT/Qt/AXqzPoEl9YoH0t811lTNuOyWeMDgZnprJBOxuD8DYCX/K87xi
	 7RQ2H2yca89Nzja6n0WztHY4T3PZeQSoYAFw+L84=
Subject: Patch "minmax.h: remove some #defines that are only expanded once" has been added to the 5.15-stable tree
To: David.Laight@ACULAB.COM, Jason@zx2c4.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@linux.ie,
	akpm@linux-foundation.org, amd-gfx@lists.freedesktop.org,
	andriy.shevchenko@linux.intel.com, anton.ivanov@cambridgegreys.com,
	arnd@kernel.org, axboe@kernel.dk, bp@alien8.de, clm@fb.com,
	coreteam@netfilter.org, dan.carpenter@linaro.org, daniel@ffwll.ch,
	dave.hansen@linux.intel.com, davem@davemloft.net,
	david.laight@aculab.com, dm-devel@redhat.com,
	dmitry.torokhov@gmail.com, dri-devel@lists.freedesktop.org,
	dsahern@kernel.org, dsterba@suse.com, dushistov@mail.ru,
	farbere@amazon.com, freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, hch@infradead.org, hdegoede@redhat.com,
	herve.codina@bootlin.com, hpa@zytor.com, jack@suse.com,
	james.morse@arm.com, jdelvare@suse.com, jdike@addtoit.com,
	jejb@linux.ibm.com, jernej.skrabec@gmail.com, jmaloy@redhat.com,
	josef@toxicpanda.com, kadlec@netfilter.org,
	krzysztof.kozlowski@canonical.com, kuba@kernel.org,
	linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.o,
	rg@kvack.org, linux-mm@kvack.org, linux-staging@lists.linux.dev,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-sunxi@lists.linux.dev, linux-um@lists.infradead.org,
	linux@rasmusvillemoes.dk, linux@roeck-us.net,
	lorenzo.stoakes@oracle.com, luc.vanoostenryck@gmail.com,
	luto@kernel.org, maarten.lankhorst@linux.intel.com,
	malattia@linux.it, martin.petersen@oracle.com, maz@kernel.org,
	mcoquelin.stm32@gmail.com, mgross@linux.intel.com,
	minchan@kernel.org, mingo@redhat.com, mjguzik@gmail.com,
	mripard@kernel.org, ngupta@vflare.org, pablo@netfilter.org,
	pedro.falcato@gmail.com, peterz@infradead.org, pmladek@suse.com,
	qiuxu.zhuo@intel.com, quic_akhilpo@quicinc.com, richard@nod.at,
	robdclark@gmail.com, rostedt@goodmis.org, rric@kernel.org,
	ruanjinjie@huawei.com, sakari.ailus@linux.intel.com,
	sashal@kernel.org, sean@poorly.run, senozhatsky@chromium.org,
	shuah@kernel.org, snitzer@redhat.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	tytso@mit.edu, tzimmermann@suse.de, wens@csie.org,
	willy@infradead.org, x86@kern.kvack.org, el.org@kvack.org,
	ying.xue@windriver.com, yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 10:16:19 +0200
In-Reply-To: <20251008152946.29285-20-farbere@amazon.com>
Message-ID: <2025101719-basket-sanitizer-712c@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4B6341C000A
X-Stat-Signature: xn4pczbstjwqw4szyecpjappmh6u4kow
X-Rspam-User: 
X-HE-Tag: 1760689011-660995
X-HE-Meta: U2FsdGVkX18muuXB6f0Vg3a4WmOyynz+VYhd9kLZYmcdeiLJtdVf6bdAWJGsbvaJAEBzLocqTnGd6NxD6owP2bCB01jifUbfSKs2wvSeDgEHGz93bxV/TIeWO0E5mBGQxdpGA8hAP7rXDarBZAD86SLG3ME6g0lS9XJ2b48YFqRT92JaX2qkIM0TtBukY7EBZrPwtu32yPfall7prSV0Ewbu8WAgXZJdYKjdo8nahkqEpylzhtIv1R2gxQFEAQsuSDl9DoPr6VUAp/EaFrA4m762MIh3Xmm7r/eTemX9dWtG+87hjg2Yo46JfVZYk87HQS66iRUqfNjFsssTloxu8d4bq/s6cbFjAXxmkh7PU9ItKf09FoCoFQcB1z3ctncYB68vB4EEdBgmfU/8EQ7dpB1OAtWyxt6eqDtuy9O8qh91NmCLBwva8oz9ZpcTzuf1Oxt75pioQMjyLMxVRuNaKZk2wA3WFlKMSphPPyoT9BNsViWJQyMDa4gLCxDjbPgPcN+TAOJag5UvbySd0nsVEZWkvMZyrmuK/hFNTO+ADc/S9RW5dmf+WSup2h2GOQ5sb1tnWGslTM2TIkp9/Ks5f8fFy4KvutYzToZGNDX+Jpvjk00iv7QuALOwzcdnsW5m/aE442YbWhhdazqBBYcc7/Jzwa+2bKBVN9VBYjNL7r5sddilouzYLNsUeMTlXhFNy3M8NNaaI6ti3wkO7VlPV72Hme2S4qeOLm0H/P5RJWjJ2lvGsGW/0olc9L74rgPdIa4KuMItiXGYA1TREn7r6BtQmqd7zDrmTsstGyq+8+brXkmN/5gVsyhuPkEL1W6m4ExwfQOzVjYWs9BAlpfzxtF10GHXv7MANo89qX6SXxeojHDzxWyJWhXDSzhm05j2r1VNALAhnl+36I3B6ACkfnLbr3q0as82rfaQNk5LSBnMp9+XhWbyLIoQOt59pes3GH1XCyVuzV2DlpV6b5J
 xq9QWDH7
 +QEaCyskYacJgH0AjwL+PbCZGt7PHtGXS65wJmAOyaPokjYqQFhVrcCPaYpWs8lNId2WVAR0i/3vXqk1bIYzFncQenf7I3fixxCh/8XZCHPpuMk8IPmhUvQ35u3tm7hpH6jD+F/vobY7xPjRE5bvXWqlSylSKzHrCZNnnvauFQt2tfwaI+pvyVpfFgZsoEOMN+t2i+UCrh0NXQZmpAGUHDbuiF3n3yuwzAM4P3snUshSRrUb5wDpNe2DgEnwJiICoQ8XIqmG458aJOvVRJoK5Gxtv1x6yDfpOhfNSJ96GpmPQ1LqdvHoYWsCKIH/qflX+c/N8xgyycwujSXjJuaxIx3pnAzBDiUdqYPEsUCym0gGp8+fz+plTgXI3MzpHM7I87BQTeZEYcD+YpCPu6yXIzAPE0q5IHauORbh0jhnebSVnQ3uzOA9og/l5JBh2Q5mXzKy9PZQen0RxzgqHz7WBzQgM1nJ/Cps27ZKpk+5RWqyO/u7fY2fh90x9MXMf02jdL8yGxn74GN7uIIBwfCNxgzgRi5AgQFYnM7Mgq3+5mzA1qn7EMmClLSK5dOdvQhffDQCCKC1Hq1BMTFC70+ocaAmVTm1Htk/bMB9f4b7LLrjGyLsWhavATsyqBkN5FS1vwH7pOLsxUbp+FiL74of1qm0QYWhikeptMKLeuZhsPfQV2eTTbFXa4XvLBMwmJXvak8G6Rppc8GNz9jNey1KQ9+imnJOZykczH0XHCEncp9CzGp5v3ZYmxsxHQ5HPEE0ZDB7tn542noJgiX33/TjS0W1ezoFX1Ueq3kfXp4zleiGgOJn7isPpo4E2+kx6Ne30der1huyNDkd1MP61f/P4T2VCUdfm6qFNzcIHBRGtXOp7ejKgQE2YrF/aeH2SrFFVSlQKlCO/qfZ+s/8gGW05YDFwMc//X/7Uxt4gaJwccp5vlM51Zmewq6EYiIJN/bPpvAZ1ydzvsuJqjOyMM/ZnvijrxQ0B
 u4NjIHVs
 4UEUQiCgLC3IWAPdf9F9Pio5tF2+Sah2B3jzCxNwMmJ7Ny0X0vW0SgkH4v0iKQyaMO7nsW2WHrbMefPrpbmO+xDI8Ai43+Dbuq6M00Rbq6P0+2xI5kmKEzxvRvJqK+1fRqjD9Hezh8ii+fA9N5miWoPOFnp/LhZ7H7KREiz5i80kuqm98nJNFH9zvFApKHdacqflfF3Z/6LxI0/AWnkyRwxvE4ski6eyojZ4MWQR+J3bP8JBSMzj0UOPxNNtvvXWTh6IQhlWswtjt26Yrltdp1+EpGFLpFY78i51b/aONm0bcr1DUnS7QiR4oXEutK4etPNPMGh9K8oLdIn4VqpoZDbzD3MbnfYctUnmDmjb/fF+8OGInkd3xPfuxVB4b++Ylw9bIUt/ANiTXqU5TwTYAM8sjBxRqxLz/qiIRIUulGHx/FXjGu/SOf49ZSr8uRj6CpBtUkjJBd+qwQ9lEZpOf1bxjNDoFju8FBYOlK/A1vRpFUyK5slWPe5U4zmcyXPwyQgwDJ49hp4eNk24Qutcz2s3vU8HMZj6HqTJqrA1xZfBQ+xhpr/u+LkazbfDhYTpgVjIfrMK2lmjIX9iIIcXjwuscoSnxd9660v4u3r7WctdtFaO64n8NJvCqOvZeyIFaIcQt8EzZD4Iljo7sctRWrUbDYkDPduZi4ZTNhqr+4Gqlrr4aAi1scJj5PF41L1YDB7/XKkgSZvKNzSqMf7Hr7HWTcHmp7dTWY3iJZRHG9bVyqtBO9DnqAGPfp0o2g1C0kz817PX1Olr7/sIqM9G5Q3ACDok4rJskVbotXSNrGjQAig8xF+0RTb2f7dWjTwebYEco6xZz/YkTzs8J1wu9LjbVAJ34Wrx/s98ump45UsxYJKtwXMN5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax.h: remove some #defines that are only expanded once

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax.h-remove-some-defines-that-are-only-expanded-once.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=36971892a=farbere@amazon.com Wed Oct  8 17:35:37 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 8 Oct 2025 15:29:44 +0000
Subject: minmax.h: remove some #defines that are only expanded once
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari
 .ailus@l
 inux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <fre
 edreno@l
 ists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@linaro.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, "Pedro Falcato" <pedro.falcato@gmail.com>
Message-ID: <20251008152946.29285-20-farbere@amazon.com>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 2b97aaf74ed534fb838d09867d09a3ca5d795208 ]

The bodies of __signed_type_use() and __unsigned_type_use() are much the
same size as their names - so put the bodies in the only line that expands
them.

Similarly __signed_type() is defined separately for 64bit and then used
exactly once just below.

Change the test for __signed_type from CONFIG_64BIT to one based on gcc
defined macros so that the code is valid if it gets used outside of a
kernel build.

Link: https://lkml.kernel.org/r/9386d1ebb8974fbabbed2635160c3975@AcuMS.aculab.com
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -46,10 +46,8 @@
  * comparison, and these expressions only need to be careful to not cause
  * warnings for pointer use.
  */
-#define __signed_type_use(ux) (2 + __is_nonneg(ux))
-#define __unsigned_type_use(ux) (1 + 2 * (sizeof(ux) < 4))
 #define __sign_use(ux) (is_signed_type(typeof(ux)) ? \
-	__signed_type_use(ux) : __unsigned_type_use(ux))
+	(2 + __is_nonneg(ux)) : (1 + 2 * (sizeof(ux) < 4)))
 
 /*
  * Check whether a signed value is always non-negative.
@@ -57,7 +55,7 @@
  * A cast is needed to avoid any warnings from values that aren't signed
  * integer types (in which case the result doesn't matter).
  *
- * On 64-bit any integer or pointer type can safely be cast to 'long'.
+ * On 64-bit any integer or pointer type can safely be cast to 'long long'.
  * But on 32-bit we need to avoid warnings about casting pointers to integers
  * of different sizes without truncating 64-bit values so 'long' or 'long long'
  * must be used depending on the size of the value.
@@ -66,12 +64,12 @@
  * them, but we do not use s128 types in the kernel (we do use 'u128',
  * but they are handled by the !is_signed_type() case).
  */
-#ifdef CONFIG_64BIT
-  #define __signed_type(ux) long
+#if __SIZEOF_POINTER__ == __SIZEOF_LONG_LONG__
+#define __is_nonneg(ux) statically_true((long long)(ux) >= 0)
 #else
-  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
+#define __is_nonneg(ux) statically_true( \
+	(typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L)))(ux) >= 0)
 #endif
-#define __is_nonneg(ux) statically_true((__signed_type(ux))(ux) >= 0)
 
 #define __types_ok(ux, uy) \
 	(__sign_use(ux) & __sign_use(uy))


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

