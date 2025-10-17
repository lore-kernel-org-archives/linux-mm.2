Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27E02CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DA588E0098; Fri, 17 Oct 2025 09:50:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762F38E0092; Fri, 17 Oct 2025 09:50:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62AB88E0098; Fri, 17 Oct 2025 09:50:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D8DB8E0092
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:50:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 293421DD45C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:50:12 +0000 (UTC)
X-FDA: 84007740264.03.F68B4B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2DEF120003
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:50:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=QQvl9e40;
	spf=pass (imf03.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760709010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=UYzw1dID8+R8ExzCg1CmFwT1K3hLj2TH9qgB3G+ibSU=;
	b=v8q84PTTnHPXyXAnkun/vYKB6O+/VlOxIRyQDZ2zAsQshFcFLm2B8H+v5tWBABYS/aHvW5
	HaNdW5hi+T/UQFN7r8E13Y8Wv5DwdUViZSdhYC5cuwNhz0pTB44uyKemIrqWfwDIBKKSdh
	RtjywN21ADdfQHPP9JULrAIcyvJujeE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=QQvl9e40;
	spf=pass (imf03.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760709010; a=rsa-sha256;
	cv=none;
	b=JNlV/a27DoAUbSSqcNzbcndvKiLtmRDESGthfPbpmRtj3gZuzE49Fx916NXzJv/56nnwGH
	RriJfY/pBI489j/i+HbNwqGEGsS9dPlMTAj7/POtBAPvCFUViUo3DuGq/Gll4z3tH7QiIn
	xznel/hdO1gaaImfXIA4kp0q+h5PVXo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3825C4B445;
	Fri, 17 Oct 2025 13:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC21C19422;
	Fri, 17 Oct 2025 13:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760709009;
	bh=aJ1FeCzYiHnuirC7SjoyZ/906lDvAeKCgeUR/M/OHDA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=QQvl9e40eoJIz5OjPU38kmBnM8TABl/ks1uGA0/Mhxs7sVliFqw8W1LB50FVBJdKi
	 bGf6SNHiQ88bIg7HeKY30IT1f9Xcp5Tw2VAZcxDk1ygRl673ogyf5L3c4fxHgrUv2z
	 07TRdIQHMElduF3J7/HcjTst+VJJcuKv7p6HT+Ps=
Subject: Patch "minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()" has been added to the 5.10-stable tree
To: David.Laight@ACULAB.COM, Jason@zx2c4.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@linux.ie,
	akpm@linux-foundation.org, alexander.deucher@amd.com,
	alexandre.torgue@st.com, amd-gfx@lists.freedesktop.org,
	andriy.shevchenko@linux.intel.com, anton.ivanov@cambridgegreys.com,
	arnd@kernel.org, artur.paszkiewicz@intel.com, axboe@kernel.dk,
	bp@alien8.de, brian.starkey@arm.com, bvanassche@acm.org,
	chao@kernel.org, christian.koenig@amd.com, clm@fb.com,
	coreteam@netfilter.org, dan.carpenter@linaro.org, daniel@ffwll.ch,
	dave.hansen@linux.intel.com, davem@davemloft.net,
	david.laight@aculab.com, dm-devel@redhat.com,
	dmitry.torokhov@gmail.com, dri-devel@lists.freedesktop.org,
	dsterba@suse.com, dushistov@mail.ru, evan.quan@amd.com,
	farbere@amazon.com, fery@cypress.com,
	freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, harry.wentland@amd.com,
	hch@infradead.org, hdegoede@redhat.com, herve.codina@bootlin.com,
	hpa@zytor.com, intel-linux-scu@intel.com, jack@suse.com,
	james.morse@arm.com, james.qian.wang@arm.com, jdelvare@suse.com,
	jdike@addtoit.com, jejb@linux.ibm.com, jmaloy@redhat.com,
	joabreu@synopsys.com, josef@toxicpanda.com, kadlec@netfilter.org,
	kbusch@kernel.org, keescook@chromium.org, kuba@kernel.org,
	kuznet@ms2.inr.ac.ru, linux-arm-kernel@lists.infradead.org,
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org,
	linux-staging@lists.linux.dev,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-um@lists.infradead.org, linux@armlinux.org.uk,
	linux@rasmusvillemoes.dk, linux@roeck-us.net, liviu.dudau@arm.com,
	lorenzo.stoakes@oracle.com, luc.vanoostenryck@gmail.com,
	luto@kernel.org, maarten.lankhorst@linux.intel.com,
	malattia@linux.it, martin.petersen@oracle.com, mchehab@kernel.org,
	mcoquelin.stm32@gmail.com, mgross@linux.intel.com,
	mihail.atanassov@arm.com, minchan@kernel.org, mingo@redhat.com,
	mjguzik@gmail.com, mripard@kernel.org, nathan@kernel.org,
	ndesaulniers@google.com, ngupta@vflare.org, pablo@netfilter.org,
	pedro.falcato@gmail.com, peppe.cavallaro@st.com,
	peterz@infradead.org, pmladek@suse.com, qiuxu.zhuo@intel.com,
	rajur@chels.kvack.org, io.com@kvack.org, richard@nod.at,
	robdclark@gmail.com, rostedt@goodmis.org, rric@kernel.org,
	ruanjinjie@huawei.com, sakari.ailus@linux.intel.com,
	sashal@kernel.org, sean@poorly.run, sergey.senozhatsky@gmail.com,
	snitzer@redhat.com, sunpeng.li@amd.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	tytso@mit.edu, tzimmermann@suse.de, willy@infradead.org,
	x86@kernel.org, xiang@kernel.org, ying.xue@windriver.com,
	yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 15:48:34 +0200
In-Reply-To: <20251017090519.46992-25-farbere@amazon.com>
Message-ID: <2025101734-evaporate-tipper-a41f@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: smw5jbbeafbuxtysgqyo7m48mrhsbptj
X-Rspamd-Queue-Id: 2DEF120003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760709009-229973
X-HE-Meta: U2FsdGVkX18ACB0PnJBxkJAPXPwiNMsTeZlfoO8WMgmD3UFUEOatk0DbIXmj5h15RcaK6X9Z+l+CHUHF7w1y7yj6IwpczVJbHBur1pKTI4Kz9y/a4x8YGP65GvnUoKD10pEvaGmTOzDgtKuuM+tSmaQzfg9klH16FflQLVYifUjKJv/nu2spz8YFM8dSnCGX2PmRd/6qIcSc2sgEjxOVqgBUgtkWPIQ5C8UGXNj1aTL2tcM1NfluhWnyMDQuPX4V90lx9L3yatSxkNqXCmxHCsdUHbDNJsBmZN0rQbEiLpzCx7M9pvjKUVuRxCond0JX2hHyR6LUR5yoWX9Ied1iU4mhq8jjsecbfzQmTIPmVby5KuHbu2A+3bDBwbhK80GOmMF4HGlbGYsOqSk4Q6xl7N8zt3R9Wg+D0pJAPqUrDrs/fB1teY/bw+sODVYYy6x5Yeq3uQQmMwxRAmcswH1zcYAFH3I+Hz4bcf29JGJYiNWT1KpNMg9u5MR0rC01pfGaSOUrQAAH2A7xoHHvwrK6YhHQYzyC0qO4wgPn7WFsFvdr14Dmvj+FOXQkycJdqnZNfBbVUmdG7IOSpOaAAPlbZns+y1/d0uP7eR9wIk0YZyLWG6/otF8Ai96UHp1MPLecu3jYpuK9DCfvwwKZ5lJr6DGOxtUiAr+49+w3IFaBemhdxZVBFWQ4iYVRouWOpUnAFnMKL+woV+CK5MDsZm8vKWZ/VTt+M9slV1m6w4CGrZijEfww1Qz0Rkoqt3OfrqpYUNWNesqbsE5Yh1cbZuzWHDtzYo5tR4Lq9Fn1nO1J2ovtJv/hE7igk/ssPKuB/cFH6+oLq9AyA7X8o3xBMrO6XzONB3ZVVxANUj6y1k6MyX+fVEego045XQZTKuu+VQDE0+OEg970ggofqdov7Fsov8DfsGP7CxCTRVJuwhjJP2bdSUbi4IQYReUbRRa6NGUXccP/ZRSy7dw3cJG+Yt8
 1PGkMjMP
 aWv1A9BNBb6UYtn6l5xzN2XGvU2JnpLtizT7hAy86fck0JSNOQKyULLo2HYUzKmBo1+4Z2bmhO+RSld6rVFzmkxahE6o4cRXzF3ieBXaRbVtylAyBhmsFS6DLxxU2owOOYjQQp41R9BEWB9ka0zYB1R5qvLUoFr+t0MKhSAIRPy/9rmtZornHPGhd7EqPrgUIUChyhSZ/QBrKMhtEQlQBBlLUj1NG1+PDTUsmbRJl2sjWZXjJN3lPwoQ07bYaDx14iWAsVYc+37BRbJKcrkuxkHQYcdhWiwXAEsrz2zmGqYwD8IXPmBgWw6bW4pui16TijtKEUOdknzB64k1C0RoDubKOyHABeSzliuMthxrTeIl8XZ8ED631YoPbodXgEfwoLqm2CysOLDi9axnWBlCTstinT7xNXuStmPkMm3zzV6yjeROrVo2V32Yr9VnIh8GIjnWdpttWX+SRgS8jm5cFdPsVpR6etPdO0qG7umjCuQEXUvjMRgZ9DJkXVuO/zpFziodxnizvwoAKJuYW5BHkz1iLRd+IJMdN9AM0kRtDap6v45SfKdIrmZFkBcytRwZhFWRLIFVGU8drMngLRQkbo92kuap2CD2RCYYggf9/GG877+TNbFqGtOVBYq5IWkAzbTMcvWtWCqblIANiUaQPq55fZWvzrzL8TfeeNAxYBF77q1xnKtBlg5eum8mWzfIqy8kE3Roc2G9314AwZjZJB5Q6Nn9UU/OXfNUkaw3ELfowKKmbusT4p+beJ7O7BRyTKwh+jr9l/zyHL+LwpDddJiiAUZsbFZHaqYeErspFw5YDdQQFgfC0MFS0AMFo9+wBamwXIqmTRlTPLyoBG1a/Ah1zR0SuV5YliCgMrH5/Sh1rg5bJ7kla1ESL5IAkPEYuywTkIYC7nlmi+DV4tkFR0GaZTR3p/Bxfo6G7UvFVJYAWye1pQ3Ez43YOhPSGCoyLnrRY+BzV0Yyu3/6cJyc5ZC1wQLoq
 YE4MeeNj
 IZ/t1RFQQW24j1TD42wQD3IhkcLPQuq8K+IN8+WEQaw4XDIi3POVNBNJ7oNF2Yfc5itgsb8k5L/4iL4n2T40F6lu3+AZ9apLp7xA2A7BM9QG9RZmOhQRDqKx0WKwOkMARkFZFSiyqXruXU/of+Zo0sHa+/SwF/rHve5UWbZg99IXqoWtc5PbPxIrj92dJdB6zyxtHkpRdwexc8JEGFjmrsLG3Y6lcVuBSHrTqMytwbtJW9BM5PTQ9KU+osIo5y9ou3Ra1/pDfuOXXVOOCyGUTSUAt1/YcXKoFRhSszZekak/f40sVSrOPKbugcvDLg8bVaNEyz5bvxCRtYiE5S2W3UYoXT/u5COozW9qGBhkmuNOwW8w3nyzKq6zzb0vvmFc3Z3NidiFaTOpZ8tSdPCXJl2JhMehnYyC56EvgjJKVJ1AQXdlF5qhe3FXPKkJLmZwRI7leNkn+l9EDf/LDt+iL+hE9mfY0WmP9mRpnFeDrgxNiVEoYfMuIeOdN5a3pMcjaw7ag8ZbMlGn37Z2EaMGd3d5hShkCg6qBga5z2LbhPKFoGBDkDsLI/T1nTw11ehBanyfNVlgPoqKKrZuBuYecSnTyLwCRYjoXFCwRSpnO9uQY/meJCwFpRalwgHIv9klhPRvkkEqyUM1JIOdDfFNBwRkh4Rf9QpslgrnWsN/xZQX/MgAvRO2nXapAhDNq0uyiCGgLrfxggMzkdDe3dKutHqpcBlSIC6jswfOhRBRD889djM75eBssExAnY6Pw8C/HyWFOMXaqttkjDd1WDI3GaMo16WGXIQn+5vXQp2mUGzeUjCQl5P08bSnsyMV8dmrwvJPG68sR5TQblnmpHbVSJ6GiP1cjYNopV3Puh7ZSVvB07d3tOL50tt3bWVsZVZ9g/04Y4kFGV29uxYZRH8f2Th9U8qXEaCadSMYfxx9+HTqoCnQu9Gba1d0saLtvSFsMj/d2XAwSR2G54zS7/S6UU7OIYENH
 oOb9UbfT
 eiDgviMNjJFMhT+DOeSaWIrZqE50rLGiosM9JLTDZl4PQSUh6O/fGCfH6UB+Vfr3eSEJv1a9rM5XCuBhw1mDzN4hR/e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax.h-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:13:15 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:05:16 +0000
Subject: minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@linaro.org>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, Pedro Falcato <pedro.falcato@gmail.com>
Message-ID: <20251017090519.46992-25-farbere@amazon.com>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit a5743f32baec4728711bbc01d6ac2b33d4c67040 ]

Use BUILD_BUG_ON_MSG(statically_true(ulo > uhi), ...) for the sanity check
of the bounds in clamp().  Gives better error coverage and one less
expansion of the arguments.

Link: https://lkml.kernel.org/r/34d53778977747f19cce2abb287bb3e6@AcuMS.aculab.com
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
 include/linux/minmax.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -106,8 +106,7 @@
 	__auto_type uval = (val);						\
 	__auto_type ulo = (lo);							\
 	__auto_type uhi = (hi);							\
-	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
-			(lo) <= (hi), true),					\
+	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
 	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-5.10/minmax-allow-comparisons-of-int-against-unsigned-char-short.patch
queue-5.10/minmax-add-a-few-more-min_t-max_t-users.patch
queue-5.10/minmax-improve-macro-expansion-and-type-checking.patch
queue-5.10/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-5.10/minmax.h-simplify-the-variants-of-clamp.patch
queue-5.10/minmax-add-in_range-macro.patch
queue-5.10/minmax.h-move-all-the-clamp-definitions-after-the-min-max-ones.patch
queue-5.10/minmax-allow-min-max-clamp-if-the-arguments-have-the-same-signedness.patch
queue-5.10/minmax-don-t-use-max-in-situations-that-want-a-c-constant-expression.patch
queue-5.10/minmax.h-remove-some-defines-that-are-only-expanded-once.patch
queue-5.10/minmax.h-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch
queue-5.10/minmax-simplify-min-max-clamp-implementation.patch
queue-5.10/minmax-deduplicate-__unconst_integer_typeof.patch
queue-5.10/minmax-simplify-and-clarify-min_t-max_t-implementation.patch
queue-5.10/minmax.h-add-whitespace-around-operators-and-after-commas.patch
queue-5.10/minmax-sanity-check-constant-bounds-when-clamping.patch
queue-5.10/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-5.10/minmax-make-generic-min-and-max-macros-available-everywhere.patch
queue-5.10/minmax-fix-up-min3-and-max3-too.patch
queue-5.10/minmax.h-reduce-the-define-expansion-of-min-max-and-clamp.patch
queue-5.10/minmax-fix-header-inclusions.patch
queue-5.10/minmax-introduce-min-max-_array.patch
queue-5.10/btrfs-remove-duplicated-in_range-macro.patch
queue-5.10/overflow-tracing-define-the-is_signed_type-macro-once.patch
queue-5.10/minmax-relax-check-to-allow-comparison-between-unsigned-arguments-and-signed-constants.patch
queue-5.10/minmax-clamp-more-efficiently-by-avoiding-extra-comparison.patch
queue-5.10/minmax.h-update-some-comments.patch

