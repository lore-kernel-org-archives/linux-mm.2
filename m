Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12454CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 15:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FC348E0084; Fri, 17 Oct 2025 11:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4018E001F; Fri, 17 Oct 2025 11:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9728E0084; Fri, 17 Oct 2025 11:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A4D98E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:58:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0291A13A185
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:58:36 +0000 (UTC)
X-FDA: 84008063874.19.9F2F953
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 25B1740006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:58:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=FLtxIBv7;
	spf=pass (imf01.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760716715; a=rsa-sha256;
	cv=none;
	b=8YrDVLgrKNgcETXfxeKsidGb3jwNXzqS806l6/oUhRZ69wDETtiZ8jp9H3No3Mv/0mO30p
	wmd7kIbusObjk00OBqbOiOz6P/1yaxZorxMrHrr8MUrfMsE4SUX6mTYf11GBaY2mvuQYWv
	PmP0Cm2gnIQ5wG8mvK1gDrXEBrbvhUQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=FLtxIBv7;
	spf=pass (imf01.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760716715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AdiWHbgl6AHEx4BHfyPyYJgEU9DgWqWz/BaU0smVwgs=;
	b=H9rCXZEXbD5qaSvMIH6cSsbK+BTrp34PiBAUfBV1nFt2mr5UgmowkfGgosBPgQFC/YdqKm
	KXVQ/Q1B8xdpiAsKx4EdfhdIEK4YjRIunZXviBvCZZqik74eLd2sUdq0+yPWLsfVBdmFxn
	/nd69d71wS8wvWAfqNp8msMjgp8LS3c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E471B4078A;
	Fri, 17 Oct 2025 15:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687B5C4CEE7;
	Fri, 17 Oct 2025 15:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716713;
	bh=20X28MMOWSoptgGAWTUrviJnQniEpl6Ktq66BRGKH/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FLtxIBv7SZeCQWvR3ANCLmaMyydymZnc8EmPjl/1wQ2ZU6GZiD2nKCaUbGU/mGLlp
	 fTOdia6A6ekGANEzH++1tbYBhBm/NR7Jy2B8blUuCuIxDXrSTaYf19VuAHrRtgTE73
	 ZyIsy6hsoafgxjCLHqBFDNZjVm7M30+2G2ZqFt0Y=
Date: Fri, 17 Oct 2025 17:03:02 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Eliav Farber <farbere@amazon.com>
Cc: stable@vger.kernel.org, linux@armlinux.org.uk, jdike@addtoit.com,
	richard@nod.at, anton.ivanov@cambridgegreys.com,
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, tony.luck@intel.com, qiuxu.zhuo@intel.com,
	mchehab@kernel.org, james.morse@arm.com, rric@kernel.org,
	harry.wentland@amd.com, sunpeng.li@amd.com,
	alexander.deucher@amd.com, christian.koenig@amd.com,
	airlied@linux.ie, daniel@ffwll.ch, evan.quan@amd.com,
	james.qian.wang@arm.com, liviu.dudau@arm.com,
	mihail.atanassov@arm.com, brian.starkey@arm.com,
	maarten.lankhorst@linux.intel.com, mripard@kernel.org,
	tzimmermann@suse.de, robdclark@gmail.com, sean@poorly.run,
	jdelvare@suse.com, linux@roeck-us.net, fery@cypress.com,
	dmitry.torokhov@gmail.com, agk@redhat.com, snitzer@redhat.com,
	dm-devel@redhat.com, rajur@chelsio.com, davem@davemloft.net,
	kuba@kernel.org, peppe.cavallaro@st.com, alexandre.torgue@st.com,
	joabreu@synopsys.com, mcoquelin.stm32@gmail.com, malattia@linux.it,
	hdegoede@redhat.com, mgross@linux.intel.com,
	intel-linux-scu@intel.com, artur.paszkiewicz@intel.com,
	jejb@linux.ibm.com, martin.petersen@oracle.com,
	sakari.ailus@linux.intel.com, clm@fb.com, josef@toxicpanda.com,
	dsterba@suse.com, xiang@kernel.org, chao@kernel.org, jack@suse.com,
	tytso@mit.edu, adilger.kernel@dilger.ca, dushistov@mail.ru,
	luc.vanoostenryck@gmail.com, rostedt@goodmis.org, pmladek@suse.com,
	sergey.senozhatsky@gmail.com, andriy.shevchenko@linux.intel.com,
	linux@rasmusvillemoes.dk, minchan@kernel.org, ngupta@vflare.org,
	akpm@linux-foundation.org, kuznet@ms2.inr.ac.ru,
	yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
	fw@strlen.de, jmaloy@redhat.com, ying.xue@windriver.com,
	willy@infradead.org, sashal@kernel.org, ruanjinjie@huawei.com,
	David.Laight@aculab.com, herve.codina@bootlin.com, Jason@zx2c4.com,
	keescook@chromium.org, kbusch@kernel.org, nathan@kernel.org,
	bvanassche@acm.org, ndesaulniers@google.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-um@lists.infradead.org, linux-edac@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
	linux-hwmon@vger.kernel.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org, netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	platform-driver-x86@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-staging@lists.linux.dev, linux-btrfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
	linux-sparse@vger.kernel.org, linux-mm@kvack.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH v2 00/27 5.10.y] Backport minmax.h updates from v6.17-rc7
Message-ID: <2025101704-rumble-chatroom-60b5@gregkh>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
X-Rspam-User: 
X-Stat-Signature: djj6xr4tc6e6xrk91m356bei5dwqn6f5
X-Rspamd-Queue-Id: 25B1740006
X-Rspamd-Server: rspam09
X-HE-Tag: 1760716714-935375
X-HE-Meta: U2FsdGVkX19RjGNhXsIIexzoUnShIz/sKEyvDZQhazcmhfUy++OasquO3WzSpBvgy/vhUHfkbf3JPP0V+pRmNawGBbzEgeGmQ0SHDpJT1CwN9pk97eNYVLILOWKxwTDb13OAhLIMzVpXC/eMwjQ4WX/WNigm2a7Uyd5W/Oi1yqiyOKI+6eLcsFCcasT1dNMvygiXwMJw0lvi3eUCHn8iTnT8duodF9ZX5vIsXlhbmWXUTVR17oMchyUEwo0EQqT8GANpwAohWpiF6aRaAuskXH7k6RRKhsaoOZB4iW2hqnr7SwOSxRh8PGDm/4MTqc/gRXtPqsidk7KPiNSy/5lCBbBoIgOgLLmY0CtAYo7r6gf4nvhHS3m26WnjO4weKD2sElPg8+qU+C1UtL2S96/iJDHzJhzQcFA+eSERZS7nJNQzUFNRvw4ypy6CNjD1V4sLs/emY2NyXzAdm9LbJZnZY7jPmXdAg8OJ/J4FfYTYisWBhmxVhYQKu4Co4A0sV9+6Zg6U9m6qlU/VAQHePci++R4Hww4OQWrFdjad1EQKf2zNzQw6T9QIHrGXpGJID2Ti/APs0vQPvw5lTOMOcuiTWKFCOuxextL5+p0rEc/igjY34xfOJG0zNW7q5SM6qfvwVbkjHmt4rls2yfI4fgPJ05/ANc5sW/AlH0gJzenlnwJKNZ6cVx1gwyRlbFyHy1hI5BKzb3CJYXcFXH53upD6SCyIv7+MYg9u2plG/jMtGZDEeK8U5GvpCrh8jUXLCDxJ3npnK7kviCiihch6EM89cxUpaGEZ681gU7PertYnilCtEwZzx6TnDm8/VsCocSJMtd1kq/IK/ij100/ksTbrhrJkKNr+5RcdTD59iS8Wy/RoYSIfaX0HM1ak45+hrYEWb9QibUZXe3VtPHCo7T7ugQOlIykAJ8VfWAnapKpvMyh7AnktdMqM+7h/CHGDRye/bKM/V7FZKv+Pmk0Tlmd
 Z3pl6n+m
 arvG91Xm/eJn1gizWrZKV7YsJ7TYPz7N1P3Zgf005QKgf2L9mFwwAJlrfPCzPPBPFES6ip7PnbAe0efVB0GYrpR1BFjniIfIpIQLSOBR+8eTwqkCgcsgVW3ZmjjRO2eC87JCWmA7/MMUdfQHQ9VgQc2o/jitEuIM/QwCEB/TXQJ9vpYDKQYsVjZ1U389gpPaXd6/rTVnj3mRKY52DqKfccaPyoSccUsa56+jTfHAjb9pYOO3EkkmluuCOeWX+SBE8MVy71qKHm8lnKoLGD9ZdE0wMtLTAGbFAaCh/L6hTgC8bCeyNfzzC8aJevvpkSHafj7Du/6UdgUvTYvPjCaKMKorIz1XOFu2hLtL0lDrqM6NJm4PUBAlQyt/bTAFuV9p8DAPiySrDgxyufoKZYxkQbWhGV29xyOOVWSXiZrD2HsJVVvrVIDSpSEHTAIBV7ycoMsyj48uvLqnTV1R8N3oapIOlPfFQ5M2T2OXmjAxLmoqOOns/zh5Nvw5hMdcCbisrjX+pwqJCbto1S7NhyGtJ6/LHNIJuhK/XSrwuHpOXG/TriP01gDYUL/5EVyYiKi4X0JO6/f1pDOw0YoFG+0WczCPrjO201ricJsupcLi6VwoMZXPLlReY44uPgFPvL9mnETqJ8kRPDHWVdte0pzNW8r1+eh3PajmVbnNcgjmweYbv93tFvcZhnK/lt+QMF623o7eKd4FGwOBbrGbfnbGeWLCQlUjZE9u1U51+tUiv8Ak79vULpNAPn1o4JcPRVIKendanYM243/8mV8TWB2+cFQwqC2AN1RMeWlgok41XgpLaEtyTCwYsQKJtmeEFu+rTGtzir+JBILhvZoETC9V0iVibnMyzWkRJim9TtKSm7ML360EWNQRxSVO2AeRI/X5ibcLuvJNzNp/obgJ5coCZ9j/bb/l3P34OquG1akqW9l3y6xsWCbKOLFbDE7T5R2rcknc66w7Wp+E42OrVPmIinSUWY5i1
 3H3n1944
 3zJmPW2bMKEB/V6NjtkdQWz82Sh2XAsQTcfYzPa6rRFydeWFhKVZODx+v11KrKR609YZnqPDzY0RX1LEzz7EtG5JNW5pesQI+SnHklNwM6IAgnJhbfPxWF8M84jC/OYz1y/Dmt2x5b/TxANNuRU+rqc+prOn9wyaTQnoIYCFK/9HcX3nAAkP1OdZlqATqtKGkfqwibXZMePGpa5Jg6zMesp7woBS6ba7Id1rGxSa0RRkVduQorenmF5l86bp+Gi+VAUwU9a4WfCTLkgLrU3L5LuamAPOEj4KcyGXQv+wXiEUVzd1Y4M4+hoOgKhkmvWLol3KAno3iAYmg1CHfM5GCjU1YzK4vj+NGaqLpAWiFHhRhD8Li8zvUhhVpSZZ6xR/7sFnN223kokxWrv/tQpc24vNppqfyZlW1OJnZqOWHrLly37f6cwdmOiZkVL7x9YwxwVa47hpSrfSBXrSL9yIoEjqN8smqVnb0eU2cHKKhRdSgEP4/jno4Flpl79RuSSOI6X10eDKJgFL2yoylQe7OdF6aI5W++g8pP5LHpuIa5wfr7AsGu3+GoGirQz2xRxG9xFBiw+uyYwJDuZJq/A4UnfU/o27mSJ+bHtzfAXogd6ExmMts4bOqRdl0b6zysG6DfQpkmJSR8i96sSgMfBcX95oIKdHRcDIU9Pezdp7RblkeTXvu9oiHzphWa+8QUF1SW7n1g/cFRhsUBVBYE/tlSY3Bs4Pk/UyI0qdvJNNiMdRI3MS/zt8FHcQ/M9vKGd0AbqdLYLFbj/tFLiE18CZtEMJKimq6a2nZTxcU3v1bM4nme9ZM0In9SGuaSzi4lKoIs8OQCAWXYpu/8HaIWIR9FIhpPVBRV7fEeUeYzdbgG16N9rSEjWWPSE0IfItqoF8IAUA4L+N/gHtHf8RcjAUMTohHW2KzNvdBkSoX/xSNFEcb9i0GNvtLTqf5satMyL7wVFLAE93i3deZC5tD+tCOpr3zDTVY
 R/mCMqBP
 +1UFRdUOM55v4iXKfS+O7FobNGh+sjqIrmAus7V/Gy4PLyyUqbzTK62UAPqrY8nsf1vNCcng2Vx28OVIUIgf9jjfLg+CGFX/205u1cVzdzyDPU0qjfgIRUM7nj5/tMhRIgNgXh90oJVc5SItyP0med1TI1K86yKeCXlWcKmeg44+UdtBnPDY4YTfETvhT8LW9JqWSeJqGHTulRvn2pJgUkezpXAC0JnAiP8cHd7DVuPnt4q5ARNZMdlDslPECPAvaWjGQdPCONccilI9PfDoXJH+a0Cg3MfrSHIkQzQN4LQyOlN1NrsLcfLC0iamwzkryi8XwDSBqkRIAPYx1IjMGqO/JsG4uGiBhEzkFA08H5OSrXHnaDHEpc2u6BhOF2vKrEpuOrFap+u226z4rqexOY9l0OAq2CBFnmKjfR8VlTuDPsqqdYkowey2Ortlb3dcIlfWvWsqhHgZfC9GFVuqeTzHc+0T11js7UAI2HALIGyX32hQUbnzPe1zQEiYAWJm+GS120uR27g4xk/FiekYa+u+ixo+isUtrSJbI5q90QORHBeVai49cAM/IKx5wDv6vAoDbFOtBLt8QQJgrHrdNlSx+OgMQnE3Y8ifsTXwUFSuy9CLpcmYa+8lmsOQNYnJzvT57sCBWobSgouWIFi3BUrs105XLx9I3eQl0KMq4a7ZUSMXsgMKr6lQXp3+8akPV7LSzbAIkXAWBYe1n2pfS4MRBxTeyCBS3fs4Xw+ORVrW2DaUGCh5kdk0kuKyTZimgL58fVp/dz3CzML5yYn5jQIvmvSNxwLthjYvq1EXJ7WUX3SSFvA0VUy/qr2TpQpUOLp1s7VeZsrrcbs2UJESLCwSpd6+Iac8cjre+RCHZemCm7Ex/6ScSmhwM2O2dzcRIORja0dQtYixJpvG0luoeS5X3TQLYqm6znAOS0MZra+WfasdkQEAb3+wiS7Dqmxae6SlI0UIqotrASDY0Ae95NUStj58r
 anLrH5fm
 wMGWKw5RDMcSXSdXWemhumMmSIWX2lqssJynci4anXO2sdHxz1y+GcqQY9VNsR/S4G2Gu0ZLXEyi5E9sSRt0JJWg2RKJs7m6RfFRmCR76ll/iH6SjX4097Eui+79a/DdYg7aQ5xSG9NjLfINvkDn+CrK5AJsR4LgxSTuupfBHCUw1GvtwUX6BsMXJYLb6XQZpzpSFb3Az6oRSjlj1peIIYnyUFMCg+r/EzS7roU09QTNuDEmXpbprMQ2NiNZWnnoa59ulOpuho+XEa5GkqD3xeu5fFwZ0DUWmzbOrFGDDwFBCX8/uHL1ZQ7O01HBZvnhDIIlkk6Znv3IONv6BFmWTvWtgT58fmEbuY4Dse1qal7NgaYWjv2Ic0+zqhzhaS1rTLVqzoe7smpWqkrgpMo1HAxO06/qk4zylPtZLBgU7S9+ADavCxmOH8zO7Y37qgcXPQ+KKqRv7ckQzGvnzH/LDjBy+77h037E7afg12QBcAFs7pRc22HdmZEHdE/qwxlFmBwXrvAA2vFB7FB07Jj5ow/rwX1eGoEEJTzoPyehUzlVtxfa8jASR2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 09:04:52AM +0000, Eliav Farber wrote:
> This series backports 27 patches to update minmax.h in the 5.10.y
> branch, aligning it with v6.17-rc7.
> 
> The ultimate goal is to synchronize all long-term branches so that they
> include the full set of minmax.h changes.
> 
> - 6.12.y has already been backported; the changes are included in
>   v6.12.49.
> - 6.6.y has already been backported; the changes are included in
>   v6.6.109.
> - 6.1.y has already been backported; the changes are currently in the
>   6.1-stable tree.
> - 5.15.y has already been backported; the changes are currently in the
>   5.15-stable tree.

With this series applied, on an arm64 server, building 'allmodconfig', I
get the following build error.

Oddly I don't see it on my x86 server, perhaps due to different compiler
versions?

Any ideas?

thanks,

greg k-h

------------------------

In function ‘rt2800_txpower_to_dev’,
    inlined from ‘rt2800_config_channel’ at ../drivers/net/wireless/ralink/rt2x00/rt2800lib.c:4022:25:
./../include/linux/compiler_types.h:309:45: error: call to ‘__compiletime_assert_1168’ declared with attribute error: clamp() low limit -7 greater than high limit 15
  309 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
      |                                             ^
./../include/linux/compiler_types.h:290:25: note: in definition of macro ‘__compiletime_assert’
  290 |                         prefix ## suffix();                             \
      |                         ^~~~~~
./../include/linux/compiler_types.h:309:9: note: in expansion of macro ‘_compiletime_assert’
  309 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
      |         ^~~~~~~~~~~~~~~~~~~
../include/linux/build_bug.h:39:37: note: in expansion of macro ‘compiletime_assert’
   39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
      |                                     ^~~~~~~~~~~~~~~~~~
../include/linux/minmax.h:188:9: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
  188 |         BUILD_BUG_ON_MSG(statically_true(ulo > uhi),                            \
      |         ^~~~~~~~~~~~~~~~
../include/linux/minmax.h:195:9: note: in expansion of macro ‘__clamp_once’
  195 |         __clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
      |         ^~~~~~~~~~~~
../include/linux/minmax.h:218:36: note: in expansion of macro ‘__careful_clamp’
  218 | #define clamp_t(type, val, lo, hi) __careful_clamp(type, val, lo, hi)
      |                                    ^~~~~~~~~~~~~~~
../drivers/net/wireless/ralink/rt2x00/rt2800lib.c:3980:24: note: in expansion of macro ‘clamp_t’
 3980 |                 return clamp_t(char, txpower, MIN_A_TXPOWER, MAX_A_TXPOWER);
      |                        ^~~~~~~
In function ‘rt2800_txpower_to_dev’,
    inlined from ‘rt2800_config_channel’ at ../drivers/net/wireless/ralink/rt2x00/rt2800lib.c:4024:25:
./../include/linux/compiler_types.h:309:45: error: call to ‘__compiletime_assert_1168’ declared with attribute error: clamp() low limit -7 greater than high limit 15
  309 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
      |                                             ^
./../include/linux/compiler_types.h:290:25: note: in definition of macro ‘__compiletime_assert’
  290 |                         prefix ## suffix();                             \
      |                         ^~~~~~
./../include/linux/compiler_types.h:309:9: note: in expansion of macro ‘_compiletime_assert’
  309 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
      |         ^~~~~~~~~~~~~~~~~~~
../include/linux/build_bug.h:39:37: note: in expansion of macro ‘compiletime_assert’
   39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
      |                                     ^~~~~~~~~~~~~~~~~~
../include/linux/minmax.h:188:9: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
  188 |         BUILD_BUG_ON_MSG(statically_true(ulo > uhi),                            \
      |         ^~~~~~~~~~~~~~~~
../include/linux/minmax.h:195:9: note: in expansion of macro ‘__clamp_once’
  195 |         __clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
      |         ^~~~~~~~~~~~
../include/linux/minmax.h:218:36: note: in expansion of macro ‘__careful_clamp’
  218 | #define clamp_t(type, val, lo, hi) __careful_clamp(type, val, lo, hi)
      |                                    ^~~~~~~~~~~~~~~
../drivers/net/wireless/ralink/rt2x00/rt2800lib.c:3980:24: note: in expansion of macro ‘clamp_t’
 3980 |                 return clamp_t(char, txpower, MIN_A_TXPOWER, MAX_A_TXPOWER);
      |                        ^~~~~~~
In function ‘rt2800_txpower_to_dev’,
    inlined from ‘rt2800_config_channel’ at ../drivers/net/wireless/ralink/rt2x00/rt2800lib.c:4028:4:
./../include/linux/compiler_types.h:309:45: error: call to ‘__compiletime_assert_1168’ declared with attribute error: clamp() low limit -7 greater than high limit 15
  309 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
      |                                             ^
./../include/linux/compiler_types.h:290:25: note: in definition of macro ‘__compiletime_assert’
  290 |                         prefix ## suffix();                             \
      |                         ^~~~~~
./../include/linux/compiler_types.h:309:9: note: in expansion of macro ‘_compiletime_assert’
  309 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
      |         ^~~~~~~~~~~~~~~~~~~
../include/linux/build_bug.h:39:37: note: in expansion of macro ‘compiletime_assert’
   39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
      |                                     ^~~~~~~~~~~~~~~~~~
../include/linux/minmax.h:188:9: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
  188 |         BUILD_BUG_ON_MSG(statically_true(ulo > uhi),                            \
      |         ^~~~~~~~~~~~~~~~
../include/linux/minmax.h:195:9: note: in expansion of macro ‘__clamp_once’
  195 |         __clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
      |         ^~~~~~~~~~~~
../include/linux/minmax.h:218:36: note: in expansion of macro ‘__careful_clamp’
  218 | #define clamp_t(type, val, lo, hi) __careful_clamp(type, val, lo, hi)
      |                                    ^~~~~~~~~~~~~~~
../drivers/net/wireless/ralink/rt2x00/rt2800lib.c:3980:24: note: in expansion of macro ‘clamp_t’
 3980 |                 return clamp_t(char, txpower, MIN_A_TXPOWER, MAX_A_TXPOWER);
      |                        ^~~~~~~
make[6]: *** [../scripts/Makefile.build:286: drivers/net/wireless/ralink/rt2x00/rt2800lib.o] Error 1
make[5]: *** [../scripts/Makefile.build:503: drivers/net/wireless/ralink/rt2x00] Error 2
make[4]: *** [../scripts/Makefile.build:503: drivers/net/wireless/ralink] Error 2
make[4]: *** Waiting for unfinished jobs....

