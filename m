Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A101ECCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B5B8E0047; Fri, 17 Oct 2025 04:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEF508E0016; Fri, 17 Oct 2025 04:16:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE658E0047; Fri, 17 Oct 2025 04:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C4F038E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:16:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 793E647989
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:47 +0000 (UTC)
X-FDA: 84006900054.17.6E657E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B09224000A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=daVcSHm5;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760689005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=bgMZmf+d/qaGsmrDSKwF/HITPtRbYm5jU+ToqyEHxBk=;
	b=cC/l8F/wqHbx4crom3pibGUqfLw1hg8kKvvT8qRmIjrzXVDW+9+eFOJIhrtRxTqQhA8xye
	Em6KcUrvGGigtJy1Ap0LePXIX5Kh8Zh3Rii+4MXvAujaG1AaFWuQSaUiLoYJNhhpJQk1yd
	fa+vLeWk/DO+nbwAHmB8uEdThH4BHWQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760689005; a=rsa-sha256;
	cv=none;
	b=qQsLVdzDYDFED3ztiRR9WsY1sJ9a88+nlFhbr5gv0xXhJpRnWm9p29am2rQs0+FkQ2RZhk
	07iNVfziNdT3GSE3Q8YS9S/dGYmHZDbIgcIr5ifI7Fq/RQc4k52UjW2AqQ1esY+dH+MCQH
	lujGD+IG8VCGgXp48KDdCaEHB7OopJ0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=daVcSHm5;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ABDA8408A4;
	Fri, 17 Oct 2025 08:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2580C113D0;
	Fri, 17 Oct 2025 08:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760689004;
	bh=XVW9NIvXp1hS/9tGbMXCN9TMnSFkQHV7b1vOO7dDr3E=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=daVcSHm5AHpBnrm14qlbg+YvNEBHO5c+8vIbRtiGemu8USnwmPelxljoB8Tjp8yqU
	 EAMlMwelPpfcAZCRqIliTnp5L3+T7siZC7SNbk8xCrcSLIDPtfevZv7YpZwiKrd7fP
	 oYlTtBlTMRsZ7aYGK6WYp+4b92rAHu8rTAqP0feo=
Subject: Patch "minmax.h: move all the clamp() definitions after the min/max() ones" has been added to the 5.15-stable tree
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
Date: Fri, 17 Oct 2025 10:16:18 +0200
In-Reply-To: <20251008152946.29285-18-farbere@amazon.com>
Message-ID: <2025101718-starboard-abreast-c762@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam05
X-Stat-Signature: bufy3chpm1ek1toupq9qudq3a4pnhijc
X-Rspam-User: 
X-Rspamd-Queue-Id: B09224000A
X-HE-Tag: 1760689005-37428
X-HE-Meta: U2FsdGVkX18WYuZhjzTstp8b0vZXAdbSxSfl8w0PqhsTJImuhv6ANFcGTfgortA3vUpMvy1By6VK+D6JN3FW6LGt49XiMnZjQPrFMzUfhKRdxtFcmHrkHabwqmunfoyOETW/z9cSRmEENVA7cZ11JpTd3Okn3NVEgxUyy4kUEzA+umznYq2nkD3nGwyovca3EKBtYizhiAKBqJccpO6pu1UjW7AY5Tk8sCupX7nSP+QiG81eQRZ5HxuccknE3eIcbEx1R/NjdPo64Eeqj2ZpIAIFEbTtH9O5T2+YcZPQsBBgDFZ558nGvkKh07dcTe811iDWbYqIS3RxywzPstg048x5tcz914apmomfWoNGQUu3nO8plDebHPXwsQr4nWjgSSE2sK0dYXik1ghjpexaXmJ5cfJrlPQnlP3MVPogkthnTp8D1XcSVusQFtatRL1Hq+EF/nA+rrhiHbAiF4woruX8NcrsqbYeC3WCpTnoj1TXJrr+ngs8+24KhpfzosE3sXvBXxeHd08nYaL8LAvMzFQbKrNxlPhKmE48waF92Qvtey2fEI1L6pQzlwyxBTw8kbiCL3ppTEuUENomWxg5n0parnXlCn3hOfv7iWff2CO6OxJhGvSQfuYbm477koWVgtO9T+CMDmUB+pKPyX107BuFyyTceRu6ioulBeAKrlzqmYrBs+sUc6CSAA8QxCjpsnr4CbhDZe+bxu97OIdg0lUvxtE8Us3yXP8CF50prKW1zVSkWNN9gfxVFznJYVY9hhKjSCn/S7GJDVbA9WH+SACLR70c95ruuo2CxT5RSLmsJOH0xr1B4LRZINssEsoPtC++TMs0jVpunJTrzL7p00R8JKrcTsMuskGZiqhdUOLEjVeStpEMiUqsKJBg+NC3HwPMZRLBWg5wtqWUZpHvGeWNYhxNUbT1CfykfWK/IlYA34I4gRofcrp9c3DWSjph9O1iFJ7pi59EpABEa+S
 XcKiKCjA
 ZvRENwjGHNkP9OHFJ83HD7vJjwbaFoiLhqZp7qcvu0s2osieP1COc0LdokCiLkAr8DNSLRbJV35V/gRvJ/9grCO7ugcjU2j5JxdNVEZ6DdA47RlSqc/IznV0bkVgzZm1NJ56yoDgpGJ4i5ElZ9L6T6Xe75gurT/Cg2MzLAfDgtZa/6LnHS/gGaEniALxfwy4rK9ELcLo+c2wA2a1fJE3jB3RC93r8wsGglWHmOpkoHJu0RFaxjcTlbPpXtkPV0LSoTG78ljKsmgyBUhdQDEU3jLRqwFL1pU6367hJ3WJVQERFU4k5bpZ5iOtH/58D5vdrj/jnBc04jfXAvePdcxwzj4qzzrHBxMpFG5cUuBTBpFBWS0rj/Yz5R6kChja9L9aT3C0Ww+omaN8mLkJSqBTAfCOkgpiA9fyC1zU8sOkYBOs5iElxrTlTuoluGlTrywqS6H6twReMOpdcRcMB+JR302vUfptGnUjlDQ/Ps9jruNyvZ8eHMzoRZgqw6r/jM5m8JELGhxs1LOnqDRXX7bb6+HMAmO3qqqsc2Fo7T76B4waSJPMU58/ZnrsabeBefUTxJPdnAXteX+LJf5VSzTKnkqJvtyymddzJS201VjN2jzbk8Shsp1kJOcW5eKn9iBec96BeugZH79j/TuVhk42G4OBXR2PYkxdhDNC1FRtFzIRzVgLag29n6UwGUn0DT5TzuCkFbsDyE93uv+bRKa72Bz7rPo9g/oYUfxUVRYOVWvfCpkL4Vp3s/OGowxDFDbqUZ5CrRWAUK4XG5NCNdlJSJlmZcxaQgVMVaHiyomLATLPdc9dQqn1OBiFBEy84tMYOVgxUYCLwvMch2UhfhFcA9m7dfcEUg41XSbUUbta1zdQFUnUDmY7DAcMkx849F1h1RIHa0IkAgKW4MgTFTrMDdnxMZ3r5LGm9mb17LnCxDz4CyW6Yox3BW3ga29UdZuzdXQ1xdVWUZZH+RTgr/VacXRxPvKwF
 8zu9sfIZ
 /mfYBvoS7eULwa2wOaVeCwuO0bpwwqzBYF/xthAQQvz/5CzU2KKcPoqVhLcTtJHz7zld5IWBXioElIezNkOlsWYeJxTCAe14G8NgneZ/cSuDmLwpPC1+ypQ+0bf2UkzYqRdjbEAq19FWcs+RJCFuYAj6sIyawUyekkGYc7M9q0Cfox8JqmXG6LmBorpC8OWzsMxs9KzmEnGeHBga8u9wKPgf55p5CnEbsl/D3OLlwIUMI4JxjnrMoWiU6N1k36+ZWLSriFmX2r6G1aPjRrF5FkUHfcDIvGGZjQsA5p/Flo2bCYTOpbO3cQrDaouyjCqetHAafw5qPnDFRriDGypMuL4SyhjMxAIA4ALt1rtpLw3IGC8mTt6St1ZpsvSGr6P+WqtEOihnlcMwy+P7zAw4aO6+b2fLBg6T7XxBFP4ALaRZKiV8tJQiMjqbKN7acsa51Q22sItpS7nl44AexKXPdsqP1CHgeUwkAcye+tovjq/Ixy6ZaKWmS0GbdUWP+AGmAq7k8QPSUHFnaXhYXD3FerD4qnkJvsabBqznM3SeT0zy1NXWYm9ljjvNQ3YtQrhbGBoDI5Z8RTxbF5JOg5MpKtNg2mN5Jkz13ywa3QQWft0fHCGymBktZyLAVPpudaJaG9lGNBWSamXVWufZDkBkl418A8QaIXt8RCywJpb79zlHRcsZ/+nUVQEJbecdmzzorav6byrw649+Y5HQFC1zhAFz7/C2QNNTio7xDciwcvdpusqNmiyQqVx74fnc9OZ3zZ5hkQQ5HOw4toIkdnE2AyrfRM0Y/doh3J8flkg+dRL8leSIN6qCNX1JzzF1sN2bbCVu5wDz8BC3xusolvjjqwdbodbzaarXDnsrmwWaeygCWioV7dyoUD1RTaMH9dhX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax.h: move all the clamp() definitions after the min/max() ones

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax.h-move-all-the-clamp-definitions-after-the-min-max-ones.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=36971892a=farbere@amazon.com Wed Oct  8 17:35:11 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 8 Oct 2025 15:29:42 +0000
Subject: minmax.h: move all the clamp() definitions after the min/max() ones
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari
 .ailus@l
 inux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <fre
 edreno@l
 ists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@linaro.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, "Pedro Falcato" <pedro.falcato@gmail.com>
Message-ID: <20251008152946.29285-18-farbere@amazon.com>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit c3939872ee4a6b8bdcd0e813c66823b31e6e26f7 ]

At some point the definitions for clamp() got added in the middle of the
ones for min() and max().  Re-order the definitions so they are more
sensibly grouped.

Link: https://lkml.kernel.org/r/8bb285818e4846469121c8abc3dfb6e2@AcuMS.aculab.com
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
 include/linux/minmax.h |  109 ++++++++++++++++++++++---------------------------
 1 file changed, 51 insertions(+), 58 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -99,22 +99,6 @@
 #define __careful_cmp(op, x, y) \
 	__careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
 
-#define __clamp(val, lo, hi)	\
-	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
-
-#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
-	__auto_type uval = (val);						\
-	__auto_type ulo = (lo);							\
-	__auto_type uhi = (hi);							\
-	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
-		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
-		"clamp("#val", "#lo", "#hi") signedness error");		\
-	__clamp(uval, ulo, uhi); })
-
-#define __careful_clamp(val, lo, hi) \
-	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
-
 /**
  * min - return minimum of two values of the same or compatible types
  * @x: first value
@@ -171,6 +155,22 @@
 	__careful_op3(max, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
 /**
+ * min_t - return minimum of two values, using the specified type
+ * @type: data type to use
+ * @x: first value
+ * @y: second value
+ */
+#define min_t(type, x, y) __cmp_once(min, type, x, y)
+
+/**
+ * max_t - return maximum of two values, using the specified type
+ * @type: data type to use
+ * @x: first value
+ * @y: second value
+ */
+#define max_t(type, x, y) __cmp_once(max, type, x, y)
+
+/**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero
  * @x: value1
  * @y: value2
@@ -180,6 +180,22 @@
 	typeof(y) __y = (y);			\
 	__x == 0 ? __y : ((__y == 0) ? __x : min(__x, __y)); })
 
+#define __clamp(val, lo, hi)	\
+	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
+
+#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
+	__auto_type uval = (val);						\
+	__auto_type ulo = (lo);							\
+	__auto_type uhi = (hi);							\
+	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
+		"clamp() low limit " #lo " greater than high limit " #hi);	\
+	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
+		"clamp("#val", "#lo", "#hi") signedness error");		\
+	__clamp(uval, ulo, uhi); })
+
+#define __careful_clamp(val, lo, hi) \
+	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
+
 /**
  * clamp - return a value clamped to a given range with strict typechecking
  * @val: current value
@@ -191,28 +207,30 @@
  */
 #define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
 
-/*
- * ..and if you can't take the strict
- * types, you can specify one yourself.
- *
- * Or not use min/max/clamp at all, of course.
- */
-
 /**
- * min_t - return minimum of two values, using the specified type
- * @type: data type to use
- * @x: first value
- * @y: second value
+ * clamp_t - return a value clamped to a given range using a given type
+ * @type: the type of variable to use
+ * @val: current value
+ * @lo: minimum allowable value
+ * @hi: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of type
+ * @type to make all the comparisons.
  */
-#define min_t(type, x, y) __cmp_once(min, type, x, y)
+#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
 
 /**
- * max_t - return maximum of two values, using the specified type
- * @type: data type to use
- * @x: first value
- * @y: second value
+ * clamp_val - return a value clamped to a given range using val's type
+ * @val: current value
+ * @lo: minimum allowable value
+ * @hi: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of whatever
+ * type the input argument @val is.  This is useful when @val is an unsigned
+ * type and @lo and @hi are literals that will otherwise be assigned a signed
+ * integer type.
  */
-#define max_t(type, x, y) __cmp_once(max, type, x, y)
+#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
 
 /*
  * Do not check the array parameter using __must_be_array().
@@ -257,31 +275,6 @@
  */
 #define max_array(array, len) __minmax_array(max, array, len)
 
-/**
- * clamp_t - return a value clamped to a given range using a given type
- * @type: the type of variable to use
- * @val: current value
- * @lo: minimum allowable value
- * @hi: maximum allowable value
- *
- * This macro does no typechecking and uses temporary variables of type
- * @type to make all the comparisons.
- */
-#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
-
-/**
- * clamp_val - return a value clamped to a given range using val's type
- * @val: current value
- * @lo: minimum allowable value
- * @hi: maximum allowable value
- *
- * This macro does no typechecking and uses temporary variables of whatever
- * type the input argument @val is.  This is useful when @val is an unsigned
- * type and @lo and @hi are literals that will otherwise be assigned a signed
- * integer type.
- */
-#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
-
 static inline bool in_range64(u64 val, u64 start, u64 len)
 {
 	return (val - start) < len;


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

