Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72898CCD184
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF4CA8E0048; Fri, 17 Oct 2025 04:16:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7E728E0016; Fri, 17 Oct 2025 04:16:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D838E0048; Fri, 17 Oct 2025 04:16:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E8598E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:16:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 691811DFDAF
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:50 +0000 (UTC)
X-FDA: 84006900180.10.7A63F4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9692D18000C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=gXjndgCu;
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760689008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=PHuEhSEl4MRmNCzo4Ub5GpIUeSTcy95EXO8KXcEcLGY=;
	b=peBrHI326z/QKkbnZ3/rlGw1pvHIagh6LZX/ri2FSdhTJofIj81GAQD/q6H+RJAjdfnHCL
	0/28gZk4BUVpawidv7ji9eX4hCmT1ti0njq3nNEEoHSTQctOZmXK5JftzUeoEkWj2pUcYg
	PoOSavx3K8RUwrEyeXMK68Pakpt2CA8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=gXjndgCu;
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760689008; a=rsa-sha256;
	cv=none;
	b=QR4YlDqohDFiWsh+mi2mfB+wT72/mhhceou2hK34LaZcTADmpJMej3d1gSepUaNPKtRv85
	s4Is2xjZjbI/91N1txKE9qsbuHl+TEUOaHVuEvsxaWJIpQGZl8fdDv647FgOjC9JdzS5hj
	4MAEo+omUQZlkM+ADlRORT8l34lH8vk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9351B4B002;
	Fri, 17 Oct 2025 08:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67D0C4CEFE;
	Fri, 17 Oct 2025 08:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760689007;
	bh=IZp8/GMuXp6QraNcAKXUTsG2tBOrqDuZVa9XkkKMO+k=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=gXjndgCup14D+INtA6mLCK2+v5u3qEF7Mn+kggU8yY8OK293VssE4VTJ6fcOpTYn2
	 ZPc+NhWns7dzp3+03VLLsLe+AynUge9PlCpdE7uu6ssEzQky+YuevQV26hRvceGrnU
	 6KjOJKuI0Pzip6fFYffMA/J23JsJLwqJt1aINpv4=
Subject: Patch "minmax.h: simplify the variants of clamp()" has been added to the 5.15-stable tree
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
In-Reply-To: <20251008152946.29285-19-farbere@amazon.com>
Message-ID: <2025101719-art-pang-4c25@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: k77trx5wsmyg8b4cpfjs8f161ckukjm6
X-Rspamd-Queue-Id: 9692D18000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760689008-203335
X-HE-Meta: U2FsdGVkX1/rqaeii7uJuryXt613T0EkcRGjfqXd8cwiYiGPb18lSWawhl74F1+ns5U8SI1uUahySc65YhL28ntpbU3owgDB3O/MNMiy3ksjNB9xUSOm4od0RnpVKKj8uV4HeBj+MV4Vrp9mVD1FN0sExQgLngwRkNwIgtFv6CvdXjtFJ62ZslhBoBtY1oZSFjlpqXn0MIHUeDIL096weUQI1LjXOtu8iws+Da07DDBRtM8pbAy8jQbcnUH9BeBG0bev7QGBA0WdnIwgObWJWiLfpl1OMUXGo1p+a7Jlg6pOMnpsTSiDG6pF2zx47QbBOCf0t8ZOKw+F/ssTcTUuLUXMLK7qt8MUWmnyqimg1Txennnb9MKs01BgIq+/hDCHTtjjEaFujLw5oH5KLEZ2m+4nAod8BNSu/hVp3C618rmPBhXV0xiAMyTpy3GYstg7gq3sHyctYgyU1LgzQgYpZprdOBd+MRaVu0dLYmKNTi5Dws5VNbu7GnxQZZK6oe/CyjxBdgiMvsi5+KAWlA58PVSivvikaX31orTaGoGITQashtgKhsiJCRW6HUqJzoAG4+tzdkmu96+1tInt5uVJ+jmxu6mjmBHmIQbSjxwl5WE8SkuDangX2Q5/CHLlc0J4E5t2tPoiUa0/DhPG5nBN+mZDaPnoPhaN4becUs1AVZwWIb9M0zFBEJV11ut24vvIG98PfkY9X1r4/o0wE3sBNHEV+i1vzyfSoXrKxQudGRlqqBaHqXg8HFgfnPTa4EJuTemDKvaXdA3g92YQ7+mMFBbpjIDIbIgplkaU8ep/kvPr+OziE6BPsY8YoSn1MsW4dpSqn+jluqAVz2fbwFf0wOgIxNEeHAsMYvH8YSqWFUN45Q/NP+oipPtkv8HnAgToO0yFhPLhoTGvT4dML7K+x/f/YOPTXWZ1NfeNBTXzInDGaigqedTqPZavgrlUD4nIBGSZD5XSh+60LLfLjeW
 lfRRLu9D
 lfSOXARw0hleuAEXLByhDxsgCoyLdOAqtK72eb6LhJMkEWsMco25pMLDsOwDLE+FFMDo+MCnIba/28ftE9M4B5/JSzojuX4szD4l9FQR7+ksz1n0RHexvh4xgeE/gJxXiqtA+e99S6CEZ0thYcNLd9NLzLcFXntbzp7OD7iFojeS57ATUlVnIUK6bFHyeJ+YjSCwdmq6p5fBAzM4njqy+tpt5jvH5InOsP/BkB9G70TxfqbGqLxD1Zw7ByJsBqVGRO0uvL0hi/CfCZnhOVcZRN+50oIygGFLiBJXGfC5iQ7Xbb1Z+41GbtQXIx1QD1v53Q/BLBeVSM8K2m+n7yLaqcuwzHrm7g143NgUcYu3luDEQdBdSR0ORMuWRTHB3u1+HybsDx1htiuoSrZZrR3n3ZY0yHY59gc22tkqlyF8/L8hDXkVUiBc2WqnAM4607zHx0rgYdfywqSCBIveSdQ36WSvtUt9ExuwI9bdxfQzIdmi6jYRENzG1BOD/pXcAWtE4j5IVis/viACL0OFSTI4HTHv80yY8zyMyDHgiNJfe11KHEbOvPbZCHJXqiaDitkmD3pHncVfjL8UhCWtZP1HTcpRMlh6DIc9yIIWaC+Cj4dsJc8896tbbBa40b9bwlRVGFpxqL7pq2mpbbTztLrisECV64fSQBxvkJxp9I8Yf7NS/vInPxknXeAOk4guXm0kWxUb+hyimcVodNvm9ZIP9lbJdnJt9RqaijdRDoMtG95wYUEAfKf4JRoo09l3CNQsovwC1S0oV5aN+oNcIyqLcat7fU0bw+DmVIzYWCYRQsTeSAwKZdBMsYuDIRHU0xz1KWqAjgn2K1NnptMe23gmxodwSA1CQETwyOdD7IYe5rdI0KhAZMGptcE11ieb5l4SMdJEZOPvw+hYwF15AEgD8teeLZdqxjccxvWMIm3VHhFes+3DmY+KPzcs7ZtsPB5U1dgqPW5aJ7+jqJGFFnefaA2IRtphZ
 sR/QtFmk
 9n9eSTolPN3h4oaHbSM5McHBnLgvaM53mQTSwp36CmxovlOmRlaeGh/EruxgwBo4P2pqpZ/THt9xLPAoYEjM/fQT1eVsVwqxtUDD6sDxZSkQlGxrbLvTGhRyZpdJQKpjlnQ7WnvKxzM01qcGNjqLgl0T/DuEaKoHFgPkcKAVO9b+ErlV4by1zFsN+GW9a6VCgro11bg/YRaSxpjrLo0NKXL+y2slh5xnZYKKJTno/1fm4L1obHd4MaJK59PvnziG2kpCBu+IrhrKpmPiGGi0FGHAXcYu5or14PIaXC7PmcF5ML0JSPtZWC/Wks20+sFFA/iE2c9GRdZff627pAQ2E8z1m690WXiUNKXRljFwBvtb5LWHaIPDwm9RSPCjzyLZmFm1TWw3MGDP7el7TpNjg/INIeZ+NQPEutrl7hmW9ggwRuonQS5DSbZBKblmQocbe/RTLJ+ClkXa7cY61NoKjQ37bUCtY3J1LbE/eNShVuojK7QIlNAA/Kke2mF2qq8QVnNQ1c6Cgjmfu7wJfd3iDpgE3UKP9FT5EDKnOp5jWQoiwefJy2k5SUlWki+w4upzIrUxEwDaGdEF6A7n1wPm1XHSsWnU57/g3FnIIiiawV7uW5ori37g3XKeHPf1hLTogYmxZXy9MV61L0mxOnTF9Y3lubAi7R85cHL3nncRFyTSq20QzhmQmBrD4qVpL0AjCAXE4lBuFVrjoJ+rPdG2xtiR9rpWG+0No9D0cPe7qnzoZ1xrA37HyXpmHjpSz3wSUtn1fFp1Yrjb8QabT8BiMm/cUoeKbFzEBDuJP4JQBBVEZwxW1KbzCFxfImhxvEeg/gvevOQixoDjDlAGHbBiidCsYVIIb88ddsT5YngXJmF+RuaVmqGTHEhgM+9tZ9Rs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax.h: simplify the variants of clamp()

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax.h-simplify-the-variants-of-clamp.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=36971892a=farbere@amazon.com Wed Oct  8 17:35:26 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 8 Oct 2025 15:29:43 +0000
Subject: minmax.h: simplify the variants of clamp()
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari
 .ailus@l
 inux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <fre
 edreno@l
 ists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@linaro.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, "Pedro Falcato" <pedro.falcato@gmail.com>
Message-ID: <20251008152946.29285-19-farbere@amazon.com>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 495bba17cdf95e9703af1b8ef773c55ef0dfe703 ]

Always pass a 'type' through to __clamp_once(), pass '__auto_type' from
clamp() itself.

The expansion of __types_ok3() is reasonable so it isn't worth the added
complexity of avoiding it when a fixed type is used for all three values.

Link: https://lkml.kernel.org/r/8f69f4deac014f558bab186444bac2e8@AcuMS.aculab.com
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
 include/linux/minmax.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -183,29 +183,29 @@
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
-	__auto_type uval = (val);						\
-	__auto_type ulo = (lo);							\
-	__auto_type uhi = (hi);							\
+#define __clamp_once(type, val, lo, hi, uval, ulo, uhi) ({			\
+	type uval = (val);							\
+	type ulo = (lo);							\
+	type uhi = (hi);							\
 	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
 	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
-#define __careful_clamp(val, lo, hi) \
-	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
+#define __careful_clamp(type, val, lo, hi) \
+	__clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
 
 /**
- * clamp - return a value clamped to a given range with strict typechecking
+ * clamp - return a value clamped to a given range with typechecking
  * @val: current value
  * @lo: lowest allowable value
  * @hi: highest allowable value
  *
- * This macro does strict typechecking of @lo/@hi to make sure they are of the
- * same type as @val.  See the unnecessary pointer comparisons.
+ * This macro checks @val/@lo/@hi to make sure they have compatible
+ * signedness.
  */
-#define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
+#define clamp(val, lo, hi) __careful_clamp(__auto_type, val, lo, hi)
 
 /**
  * clamp_t - return a value clamped to a given range using a given type
@@ -217,7 +217,7 @@
  * This macro does no typechecking and uses temporary variables of type
  * @type to make all the comparisons.
  */
-#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
+#define clamp_t(type, val, lo, hi) __careful_clamp(type, val, lo, hi)
 
 /**
  * clamp_val - return a value clamped to a given range using val's type
@@ -230,7 +230,7 @@
  * type and @lo and @hi are literals that will otherwise be assigned a signed
  * integer type.
  */
-#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
+#define clamp_val(val, lo, hi) __careful_clamp(typeof(val), val, lo, hi)
 
 /*
  * Do not check the array parameter using __must_be_array().


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

