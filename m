Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80EF0CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31F3900002; Fri, 17 Oct 2025 04:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08908E0016; Fri, 17 Oct 2025 04:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4794900002; Fri, 17 Oct 2025 04:05:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABD1B8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:05:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D0C68813D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:05:54 +0000 (UTC)
X-FDA: 84006872628.03.C93480B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 774DA16000A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:05:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=yvpR5PIJ;
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760688352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=nFACm0/CdH0K05Hf+CXKZwuCwJkeABYiZmzhO30eVUQ=;
	b=xX2/zLEV1GNE9zc8c1TsuY6DYLN1EA6Fjc6DFh+HPWfF4JyVNoHzoL7z1yYjiI8C5bWoJw
	22Y4OBClgIMW53jfuBdX8AxzknPz9upkRDNMnO2xHrUObYsT/UV/VmtbJ2VEb7d5l9BJPp
	ZYF6ja1S80yVtTM61F4pf40cCGK6h5k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=yvpR5PIJ;
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760688352; a=rsa-sha256;
	cv=none;
	b=cZPi07sDXGvKlh8zy37Xvvd2GyCFw1zJgUT8LRSwDsNYyMPKCMHK48io1YiNYJN8B7UHpf
	2MYxHE8JXr6J/kitkvyFgtzmp9F8CZIXmE+Pfug4q+2G43ZYAVgD0B6uWSbVdkMfDa2RfS
	ekF7yanqfbsVNVYT0WCtu7VzKdK49iQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 66B1845792;
	Fri, 17 Oct 2025 08:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF408C4CEE7;
	Fri, 17 Oct 2025 08:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760688351;
	bh=Tzgs9nAyY51SyO39mSR4w+R/thG+h//Bm/fKTyosOrA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=yvpR5PIJ3FYApyf3Dawuz+V2d+0++37BDQiSCCA5voRVaYJOWu7qHIph0ixKDSZk2
	 kobbiTDXGB9fuxoP+Ho7iEDkvZ2/Wv/giyEHNM54vXTOxBLNnockjkdL5CaWfcOP0K
	 V9Qusd6SZTOYDOfaub90ovhHOfl+NNR5rS3wRZJc=
Subject: Patch "minmax: fix indentation of __cmp_once() and __clamp_once()" has been added to the 5.15-stable tree
To: David.Laight@ACULAB.COM, Jason@zx2c4.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@linux.ie,
	akpm@linux-foundation.org, amd-gfx@lists.freedesktop.org,
	andriy.shevchenko@linux.intel.com, anton.ivanov@cambridgegreys.com,
	bp@alien8.de, clm@fb.com, coreteam@netfilter.org, daniel@ffwll.ch,
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
	linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-staging@lists.linux.dev, linux@kvack.org,
	-stm32@st-md-mailman.stormreply.com, linux-sunxi@lists.linux.dev,
	linux-um@lists.infradead.org, linux@rasmusvillemoes.dk,
	linux@roeck-us.net, luc.vanoostenryck@gmail.com, luto@kernel.org,
	maarten.lankhorst@linux.intel.com, malattia@linux.it,
	martin.petersen@oracle.com, maz@kernel.org,
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
Date: Fri, 17 Oct 2025 10:05:10 +0200
In-Reply-To: <20251008152946.29285-5-farbere@amazon.com>
Message-ID: <2025101710-antacid-lip-fac8@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: pujia3pzzp17kyt46e51g1836rx8epqu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 774DA16000A
X-HE-Tag: 1760688352-819096
X-HE-Meta: U2FsdGVkX1+1UvHxDJpyRRzj9m8XxEIgUVSO/4JG82Cg7mEnC/YER34A601ANgdxqCscix0siNG4ljdwkE+1/oRCyQNKjQ4Kx5E0TGq5PnEUTZnQobtafPPoRiMbsK+t38iCbiH0qJBGLJfyvld1iMWc2hRdUNNjeo1R+koPljzX1EkwVM9Wjy8NluxBaVhJF7dJLVtyCvaiLcZ00xW9Z9QqZ2p40uaS5ECIR1rlX+6QM1dZfVGYZVKI0oYmt5WhUBF3Nee6VN3rAgPP3RG+oFERtI1rvim8L113J/0CRHXN8PR3jwzHWgFSSaAqlk6jsdgNipPVqVm6cFNZWpVm3knZAwlWezXBnAaSk42MDnjH5TX+rj25vZw0T89J5WctGmMuz/vf4E4N/5I9LoClvyoz2WV4X+9vE8KDndenTX/P81e63Ai0DujvPP6RteovxV0LFIZ3I6h5hmcOdgf0T7rnMtPriIpJr4rh6q3ZKcQMiowNl0QLb4srK7mtLUo6MPZAoGdmWpxOnkwi+M7QC1GwWusnADIFPYTmrU/qWHmnuuhCnih2sGONqqFn4TzAwlvuKys7YM8aHs2UJZwupV/IarnJBmuK438kPNrh+3utiR53whmQBXjSgV0fcb8WG552MfdkhnP0EPcEHTdzARLsck4bctTelFge+0yOp/Yx7tKWVJxsM4K0ZeWyyOLTYq0FQXedCIuHdg2AMKxifZsSlSUI7JlonlKixhkWD2SNKcx4tV/yg+lH8N6YMaXDMBXpBFPcYNR/ogAwkK0poc0RdQFmAEFy5oQwn5gqqvM1PZJ665koxFg73GHuJf8m55oVbw8eNHyLdA7bbUn7HBF6mbvTdJCTFbJFPkoCLN2wQqcbU6jv9e3LjQBvzDwgoDFbEc2n6KdlGxb46lTvYs/hUZPvwKxnVOKhvuD1mcqN/wOIq4M1sdWDH6MxPB4DG136BsDmlBAVqt5ZNWZ
 7iONO7Lf
 4zb0gn37gOXW/OnxQ81enXZ+FMp8tCAbHbYno+jmpBI+3uueffjF5XIS9bI7jacYSHW9RQ5d6gKITIb8gqfzmuqEfVFNxlGKXInqtiUJYpCv0hdYp0ZyrEjzn3pzGDVJsrGMi4ZBm/zRqa4YBH8DgbuJ/20ddziWOPxCz/aujSdpUOGAAIq8NDj36ZkmFycwQ/Vgw5uaj1m+2uZDtQY6fVBq2dxKM0NfTH1c71LnZ61Fr1WQj7vuVYxUVQPsAklmmaAdTZ2famkqQ7riLlE/uT0zqifqwGQt0mEI7q/lYW50OOuxMCo/c900dCui5kEKYUQrOE0aZo6+UpU9bLGAOIttYLq3CgYPvnugucZ9Cvpd8TiiWYyZZjG7lRAAUrZBkV7aHDtNFh5j/dZ3DtWJaMBWHCReqsdJ3nuHrRHHy09Ntqsw66Ja0qz65bfvFLtVyJvTx9bqYhvaaHWGk+v1gbJ36CDGlKi6sxiK2aZJLE7NATg97loFX/K7CeVIHy0YXb01xkLKgeyLtiLLmnGb7vFY7xmw+f8CzeN0jSSL9cZmcAS8yb9yR4KljSaON414PaFmSS0M1wDs2tomOSeqef6ShZWmmFlPWwoatunTJmZCGqA3jFIognQbDHFY719IsgvTugXEnQVLy5pgtnz2z1n9kdObMx+BCjjziD4ghE60Idcp9rO2m/YUJMaOVBDJrl3wW4A51h/BnPa8MF4SCUZTXF88xRmgiyp8hk/O+OkqUFjvSc1QGhDGnzCoI35bvm8mtmTnwnJXPXuQf18svrgEI7nGd6EHlrOj6QHLZ7m9BSdZbWg7+oX5dLcaVbcS7qs0pVsjSgKcPaXIyHla9bU4+dvGsXzQs5bn6ZCmbvI6i79nYkPbDynP0OQvqsMAvuMlM78FxvibBQzlHyEMSPH7p4FxGodbGoEocLMzAx5LiH+oy8MAqGq8uKPGNdjXRrgCZE4Lr0sI6UZ32+CiU8Dl0MPxj
 ZTZMB1dZ
 4kTekgFWjGfpGo6v8AQJzXqbaHKTnHY4d/OGrtkzSecq9UY+p59+ElCM5MsOK2Caj6IFERhPERWnknG9+U14feEXoeXB96BRGuOYDByfGUabQ+lJ1sqaVvbqXM00evadVSE55KWgJzawlVcLQ1iin+v493Rxv082YBOd37TibS4KKuQIa32Ge2ZiwTImhMbYZqh2JQdVSCogmYWR92L/CJAXEmuzQinq9tiDxVIWt09MosQ7S6kghh55XEW3Q8cPmyF4XKMXBzx/qZlY2TqgVcsPY2NYOraKLB2B0tqfmoJ3JYg94LJ22x7JPMOBMSqZVUbaJSAck8CGg9tvqOXMnRtYDoctvpGJ9v/IAvfrTWyeSrsLOT3T97ANT66utAweZpNnqTgItRYn2jdAu/08HXR2mErOPpHPEHJhaOG0spetiXXFc3IuWbtoRCmeeXZbQvShxytCFlgNWnw4SG5qaW8hJNP4NR5UlSxyCoqNvXyUxg8faPSeMKJkrky16CbdAWSDYl5h9xntgslRIhVL3NQlCdAAnKtrHDHtvEEy+muJS00dsIYk49KGpYhfuYpTh9kqyyW4z0a5ILSq2jf3s6RLhuVw7fE4lEYM6/eDRRCE/ICikagjJ0mp38WS0mISaBiSBBl12LyCCGCwcVp30yGE7FELE8tfbxY+hx/gVdutffZIeXr+CLiIHuChNmIx0+P7LIXsZsXIKYrqrKUavJ+EMyIRkK13/pNdRgsl08RMY+JNN5fX12mB/uyzKxIOQyqAcfVGlvyzJcFgO5whgUSpp9+UKsZ66B3IXgRpkypUo2mp/CQEZ/olWTUJIiCTAES64XsqKqfO9cKuwIGpA2V2lgB9GUNG8nZm/UvSiId9BVOI8OPTe/+xtp6jyrxQ9YnyTVRgSPY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: fix indentation of __cmp_once() and __clamp_once()

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-183616-greg=kroah.com@vger.kernel.org Wed Oct  8 17:33:08 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 8 Oct 2025 15:29:29 +0000
Subject: minmax: fix indentation of __cmp_once() and __clamp_once()
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari
 .ailus@l
 inux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <fre
 edreno@l
 ists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20251008152946.29285-5-farbere@amazon.com>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit f4b84b2ff851f01d0fac619eadef47eb41648534 ]

Remove the extra indentation and align continuation markers.

Link: https://lkml.kernel.org/r/bed41317a05c498ea0209eafbcab45a5@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -46,11 +46,11 @@
 #define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
 
 #define __cmp_once(op, x, y, unique_x, unique_y) ({	\
-		typeof(x) unique_x = (x);		\
-		typeof(y) unique_y = (y);		\
-		static_assert(__types_ok(x, y),		\
-			#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-		__cmp(op, unique_x, unique_y); })
+	typeof(x) unique_x = (x);			\
+	typeof(y) unique_y = (y);			\
+	static_assert(__types_ok(x, y),			\
+		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
+	__cmp(op, unique_x, unique_y); })
 
 #define __careful_cmp(op, x, y)					\
 	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
@@ -60,16 +60,16 @@
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({	\
-		typeof(val) unique_val = (val);				\
-		typeof(lo) unique_lo = (lo);				\
-		typeof(hi) unique_hi = (hi);				\
-		static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
-				(lo) <= (hi), true),					\
-			"clamp() low limit " #lo " greater than high limit " #hi);	\
-		static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
-		static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
-		__clamp(unique_val, unique_lo, unique_hi); })
+#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({		\
+	typeof(val) unique_val = (val);						\
+	typeof(lo) unique_lo = (lo);						\
+	typeof(hi) unique_hi = (hi);						\
+	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
+			(lo) <= (hi), true),					\
+		"clamp() low limit " #lo " greater than high limit " #hi);	\
+	static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
+	static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
+	__clamp(unique_val, unique_lo, unique_hi); })
 
 #define __careful_clamp(val, lo, hi) ({					\
 	__builtin_choose_expr(__is_constexpr((val) - (lo) + (hi)),	\


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-5.15/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-5.15/minmax-add-in_range-macro.patch
queue-5.15/minmax-deduplicate-__unconst_integer_typeof.patch
queue-5.15/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-5.15/minmax-introduce-min-max-_array.patch

