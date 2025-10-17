Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FB37CCD19F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89DA48E0095; Fri, 17 Oct 2025 09:50:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 873DD8E0092; Fri, 17 Oct 2025 09:50:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78A398E0095; Fri, 17 Oct 2025 09:50:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6378D8E0092
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:50:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B4E3C01B1
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:50:01 +0000 (UTC)
X-FDA: 84007739802.12.05ECCD2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6708C1A0010
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=GdFnBKLq;
	spf=pass (imf19.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=gw7v4qg4E0WdorUdtRwqhYqRkvxLn0OnDHb/6VbJHug=;
	b=rdwLms0ASZ7SWFTS5HmikJeDDVyAWzbfdARtagM9phVRJV8qh54z0+6FXgQh+sGaC2cTFZ
	P7sETUyNX5kGjXRHu7BK6RsuZWJjVhLvcLKiI7bn4e7x9yc+IP0Gp738oeR9ijLrjqnYxT
	UCzFzpir9bfR5xBCLwH0SRlVNPPjHuI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=GdFnBKLq;
	spf=pass (imf19.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708999; a=rsa-sha256;
	cv=none;
	b=HboubBgjCtPiUuMbDFIcjRaMM3sm6dI1H2zZjnHV+bnpBP8SJRgPPgfTO2f+mZ7g0AayA4
	UQFm4EZ49YEdIHdlLXGX8/ZQZcGG/wk736pZZXfIjc+ULthbnjqBKci1IV8EgQy/88chgo
	v1cM4t3Hvz8q4fhMfxW6mfFvKL0xosg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D023436DF;
	Fri, 17 Oct 2025 13:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133B9C4CEF9;
	Fri, 17 Oct 2025 13:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708998;
	bh=JbeTxONLotsoUmGtlE2ZrdbmSRZbe9l8UZPkeUV3olA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=GdFnBKLqHQxvvfCRS1tGiWNmdF45QR+5n7uf4kfPOU5GYBP/qILxzCeToRALQL8MS
	 m+zYFVkpdBHkUgOXssgxOUwGkkVGfNVpBKtqameWvt5NQbO7qWrkuza+nSukckry2b
	 JX2ay7ftEAMBlmpMnwVBHOKhgC3CpPNVh9CZd9Xo=
Subject: Patch "minmax.h: update some comments" has been added to the 5.10-stable tree
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
Date: Fri, 17 Oct 2025 15:48:33 +0200
In-Reply-To: <20251017090519.46992-23-farbere@amazon.com>
Message-ID: <2025101733-emission-backed-1098@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: xnyeaanr3mnfd9e3e5xcgetpoa7dsw36
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6708C1A0010
X-HE-Tag: 1760708999-809631
X-HE-Meta: U2FsdGVkX189dR6VYZ/33NVia4cHXGy4R+4RDIlLPyFUeg3sICqXrH5DEgBeQWnnyVU1E45J4oRW/8YM6BpO9xgPcv2+1GF37UtBS+UI589yW785QpJBMnU3KiX34Uv9XNtWLQf6Zv7/N4BnZgkWSeVsx7bA8d5UFcIKwfwLYJ6mqtRGJ0lj6ceQB8NRazq7UZlTM85+lYhFnEdjZhLm7G7Zx+/nB2sVy7xpRL0GDKgeUInqQHIIGGuKsbZL0oTbu8len9INZzLC0FprRVzqNG40DCegBIo714EQ2jk4gnX49047KIhm2lCHbXN4kj2AJ6s1zzsjsCW+GO+s9OmXNX78j44GRwn4vQ19T3UogU7wNmAEu+oVdL9u3dJUPkDHylMdXi9z4fTjv0+3CNLEQHTzmS2OQKO62KER1g8vEoVBMCIcKO5AW4vV4fNfl5dE4CeXQ2aaE+fxVzNdAJxLrzGi1pTyVTwPafy02D987lKUxfGS5w+pz1w/MD6/Z1RI9b5KFVqMxYVR7m9KnD74LX22oN+bPRz2TaPI5X72TwBs8ZZnniJV9dDjpHY3OVYe7ukR6tX7Z6YnrxcJYaWksZJ0zRwAStnpvoutGSK+SVEATgUXftRKFpchNFlGsZihojVo6RG+Ut0d0IFB2JlhRmfFYhdtFAJTR1SU9V5L63N0BOQbRGo5c95r/fXMB0hOnM25EBj+ndqj/pErQ8TgC5lh8370WYBGMv+icXMd5qh8Lu6zTU7J/58QBK1K6vWvf+nn+aGiItcia8a/E8HqH+r0lv6a/1IaSzwJCoVTrbdDNBlR1U1rwK32EXbaKT4UKGwcVeVzfuDa+huEAH2imI9sbtOXwMkJ4/y4wn/c5OaOiiIU4u4flOWgAehsND+rCoH2DMJme0FP7gi6c4Ag6OW036gdyDjapbJgzkK+75RZGgP+32RCGGJ0ZrvjJ9TWCNS+vcx6P63EZzXJv4m
 osY4hgUc
 yxzM2rs+EITIVZM1hUbwzjz6JSZ2K7dFN4lHl4XVseMQW/EXqAyfar3y6+vdh1lgJ4/lpH0g1TZkG7uFDQa7G14U7QdX7vzqlXxob0FNa96j3peg8WW2aCLfBAp6RDOggvgnHKz1OpoAC9PtR2TMqN0Zs1J6pbmNnKZ6y67b4LohXAo9uERYQFPP4jrdGLV2X7u8O5oXo0J/CTusCbV0vsNQYiZiY/WcVDu6oJ0axN0pMuKeudhzYfbuiA3wFx8K98bV2kqValCfjSmjwNPTbvqsb8uFl9It9+7IOqXPvNmeH6AmFLhJ08ZlkxccIRngRzJCAwWfPg2ujoMMWTwP+7CjSGLEP8ri3zHnAKuYjS/flz9VF2XTgwi0Xj5PL70GVHE1aE567YVNPUSo1jVGgwo/OkrjW+2ZB0inPejpID2cewpBS97l8Ic/taWIYKcIjy5N5JZoNLD1ETYLvkzt5Umh3TDKM4Z81fLH1x3CV4fxrvA3F3hgphfQN1kvp70KcqIxRwxQTrlKFKv0s4SKAwtSMCOyXMn/NUYyUm39Wl5zhoZd6gBgQITR/rzfY7xWtpymwY/K4gC5T12UMuEl75VIA5I9CUhsXDpu7UcA07TFn8IeX+vAyN3Uw3anG2CJqh7xG2/g9yyOi8pokJldvlrl83aUM1zOToVGN7MkOi5esjR3NJMbiBlRUArgT/Ln3KN7mu/B275Zy/cCO4uBVE6SWZ6ocNzEw6ds6+MDsDOfTxv5Vhy/HyYOlnP50UKO+sGZd99IiuoUmnsBkmL3ZwBpbEEE/YwSIEho8HZleqoF1NnGusQlHipu1LgQ6yCX2lGQ4lztyMg/LrDL2ZLq7YffXnDcupmT4VaZjP14OvpUaGFhd62wqoeTCJVtwTDrCmmaEcEchYzAmflqeFRfZqFx3es9vO7OzW4HxVeqISgLQzdCGASMIhiworZ0e2BTHmUzk4MRtDcabsF4LYRNKqCX3MKd5
 VIfETgUz
 tOHEgP+hpRvi8cwfVy3kI9mDv7hgIK3juQe9tjh3ryRMSowr9mbht3eWVoVZwXs5z+ZLfYVzEU9vWkhxJ1HkzRTkv9FxcG8GH1gpzvGrVNswjudsiofzqBbVjv0u48OayftF1sKwXE1KWJvjSrs36C6C6+aCwA08hn3xU2XAtV6V1V3JLPtDfSuL5KRscEYdnXDj4WKLisA8KKmp6XfXlU/fewicMUNveUIMZzXDAvOIEESpbg0xRednRUlPD6PebeZC8+mRtgL9DphsHBA72w+0VrRepb3jLvEPmDS5tKLwcIu7qzo/sjWFo2Cc/GEZOEp+I2YjM4jDjO1ztxrjhW5vRboVk9hE6FNJ1oH6Yg5HwFi8/8JM8lvSGzj0ZmH7EuhDQT7DaPE/KMv+ufeV3T22ggmqNkT0NQwc3uxSlJH/xcBJtPzkh8qcbCBScgweIg8scTKe70WwdoOwsJwDMkRuxS25v4UjB3X0on5l5wMVx5kR9immBQ6hxHVqXgLR2aC3C+mBj+Q4eZnh3rkQ4p/6UGOliJk9+uBPGI4e9IrHBLTTgIU/akBM5fNAfdv+U1YXRBMdm1dEephOJ0YW7keub9sugZHD89Cuni6n15eyYrtvCgmRrjeJCyTs1utIWmKB7nWIZ6FXW1hK3OOhOq4bjNYDUtpFM3s26nidjkdBTVvgOhDhUguCeHK+PKFIpPvJQWM46SknanWN3FXywN7iC74Y9QQwGbVBFqgl/+beWlZo5bVDpdL13AHHkDV7lmOMD5aHjOU9gmXzZslAkVzk5l4NQ/i1giZWvgSYlbwyAObDJea0Pj9/xJc3elCiS3dODUXhco/6FhqVE02Ir4I8oPnbAwEfGk+80m0G9VcRhY4R8hnpYXID6KGbrkG+2m35jcjpUjBV7I+KHPouWiT5qdGp8vZ3FelTz5iLLwjIncXrwZQ4hWNMT/X88+0gXUj0DmG0Ffco/kv+RaMo8RjeT9R4i
 bREwzU+u
 72gwMk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax.h: update some comments

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax.h-update-some-comments.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:12:31 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:05:14 +0000
Subject: minmax.h: update some comments
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@linaro.org>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, Pedro Falcato <pedro.falcato@gmail.com>
Message-ID: <20251017090519.46992-23-farbere@amazon.com>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 10666e99204818ef45c702469488353b5bb09ec7 ]

- Change three to several.
- Remove the comment about retaining constant expressions, no longer true.
- Realign to nearer 80 columns and break on major punctiation.
- Add a leading comment to the block before __signed_type() and __is_nonneg()
  Otherwise the block explaining the cast is a bit 'floating'.
  Reword the rest of that comment to improve readability.

Link: https://lkml.kernel.org/r/85b050c81c1d4076aeb91a6cded45fee@AcuMS.aculab.com
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
 include/linux/minmax.h |   61 ++++++++++++++++++++++---------------------------
 1 file changed, 28 insertions(+), 33 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -8,13 +8,10 @@
 #include <linux/types.h>
 
 /*
- * min()/max()/clamp() macros must accomplish three things:
+ * min()/max()/clamp() macros must accomplish several things:
  *
  * - Avoid multiple evaluations of the arguments (so side-effects like
  *   "x++" happen only once) when non-constant.
- * - Retain result as a constant expressions when called with only
- *   constant expressions (to avoid tripping VLA warnings in stack
- *   allocation usage).
  * - Perform signed v unsigned type-checking (to generate compile
  *   errors instead of nasty runtime surprises).
  * - Unsigned char/short are always promoted to signed int and can be
@@ -31,25 +28,23 @@
  *   bit #0 set if ok for unsigned comparisons
  *   bit #1 set if ok for signed comparisons
  *
- * In particular, statically non-negative signed integer
- * expressions are ok for both.
+ * In particular, statically non-negative signed integer expressions
+ * are ok for both.
  *
- * NOTE! Unsigned types smaller than 'int' are implicitly
- * converted to 'int' in expressions, and are accepted for
- * signed conversions for now. This is debatable.
- *
- * Note that 'x' is the original expression, and 'ux' is
- * the unique variable that contains the value.
- *
- * We use 'ux' for pure type checking, and 'x' for when
- * we need to look at the value (but without evaluating
- * it for side effects! Careful to only ever evaluate it
- * with sizeof() or __builtin_constant_p() etc).
- *
- * Pointers end up being checked by the normal C type
- * rules at the actual comparison, and these expressions
- * only need to be careful to not cause warnings for
- * pointer use.
+ * NOTE! Unsigned types smaller than 'int' are implicitly converted to 'int'
+ * in expressions, and are accepted for signed conversions for now.
+ * This is debatable.
+ *
+ * Note that 'x' is the original expression, and 'ux' is the unique variable
+ * that contains the value.
+ *
+ * We use 'ux' for pure type checking, and 'x' for when we need to look at the
+ * value (but without evaluating it for side effects!
+ * Careful to only ever evaluate it with sizeof() or __builtin_constant_p() etc).
+ *
+ * Pointers end up being checked by the normal C type rules at the actual
+ * comparison, and these expressions only need to be careful to not cause
+ * warnings for pointer use.
  */
 #define __signed_type_use(x, ux) (2 + __is_nonneg(x, ux))
 #define __unsigned_type_use(x, ux) (1 + 2 * (sizeof(ux) < 4))
@@ -57,19 +52,19 @@
 	__signed_type_use(x, ux) : __unsigned_type_use(x, ux))
 
 /*
- * To avoid warnings about casting pointers to integers
- * of different sizes, we need that special sign type.
+ * Check whether a signed value is always non-negative.
  *
- * On 64-bit we can just always use 'long', since any
- * integer or pointer type can just be cast to that.
+ * A cast is needed to avoid any warnings from values that aren't signed
+ * integer types (in which case the result doesn't matter).
  *
- * This does not work for 128-bit signed integers since
- * the cast would truncate them, but we do not use s128
- * types in the kernel (we do use 'u128', but they will
- * be handled by the !is_signed_type() case).
- *
- * NOTE! The cast is there only to avoid any warnings
- * from when values that aren't signed integer types.
+ * On 64-bit any integer or pointer type can safely be cast to 'long'.
+ * But on 32-bit we need to avoid warnings about casting pointers to integers
+ * of different sizes without truncating 64-bit values so 'long' or 'long long'
+ * must be used depending on the size of the value.
+ *
+ * This does not work for 128-bit signed integers since the cast would truncate
+ * them, but we do not use s128 types in the kernel (we do use 'u128',
+ * but they are handled by the !is_signed_type() case).
  */
 #ifdef CONFIG_64BIT
   #define __signed_type(ux) long


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

