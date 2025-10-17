Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50986CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A49508E008A; Fri, 17 Oct 2025 09:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F7FC8E0006; Fri, 17 Oct 2025 09:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C21B8E008A; Fri, 17 Oct 2025 09:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 74CF08E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:49:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3780E1401CB
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:20 +0000 (UTC)
X-FDA: 84007738080.26.0095C2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7198C2000A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=Z4Tv667f;
	spf=pass (imf13.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=hkRQvs+tjcaMr/Brm/MFRXAK5Oqsqkw9vFrK+/9N43M=;
	b=Z4smjG3xEcMTHAXW6+6bwPXGlnsG/2REdzYytBaxsA3814ioiGSxflGAaYyTOQn8etUVzc
	H/waXFGTJD8dg3TNlNT4irxvUHzGdk9kQG7JApcLp+16CVrOfXB4Ts8T07rJZnG40oP160
	TGKzJIXVbT//vygGlkUfVGlwHequJ1Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708958; a=rsa-sha256;
	cv=none;
	b=FyMeVU9TsHe1Yz27XMN84EZozNCCUPdeq6CW7o85b+Zk50DT8e4R7tIS7FrBb3BXVdtMaC
	RdLalWb5qznm6DzNpe80Ps/TYbft6oDwXt7VK82cmhqxhbwR0PveWCYEtU65sRUe/mdhsH
	skN+rezFHfA5kuCBifGzZWnFmDdZryg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=Z4Tv667f;
	spf=pass (imf13.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 83D524555D;
	Fri, 17 Oct 2025 13:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C146DC116B1;
	Fri, 17 Oct 2025 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708957;
	bh=Ua7vCzS3o009KwoPLTQB4DGIeRIPg7Y50HxDIYzrkHY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=Z4Tv667f5UNsoyLfrw8kT7YN68oXeKQt6imFGs/Kn9Gn+qDiFqGAGFVqsG0aPf1EL
	 9T/5lD4QTM19vxB9s6LQp6/mpKzrJcj4f8NKn+85bbDL2Kmx2L73KEzP8pFO9JUsFU
	 GiujvVza0TVDfwa22jt1Ague8WXkgNrILyzqRHzM=
Subject: Patch "minmax: Introduce {min,max}_array()" has been added to the 5.10-stable tree
To: David.Laight@ACULAB.COM, Jason@zx2c4.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@linux.ie,
	akpm@linux-foundation.org, alexander.deucher@amd.com,
	alexandre.torgue@st.com, amd-gfx@lists.freedesktop.org,
	andriy.shevchenko@linux.intel.com, andy.shevchenko@gmail.com,
	anton.ivanov@cambridgegreys.com, artur.paszkiewicz@intel.com,
	bp@alien8.de, brian.starkey@arm.com, broonie@kernel.org,
	bvanassche@acm.org, chao@kernel.org, christian.koenig@amd.com,
	christophe.leroy@csgroup.eu, clm@fb.com, coreteam@netfilter.org,
	daniel@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net,
	dm-devel@redhat.com, dmitry.torokhov@gmail.com,
	dri-devel@lists.freedesktop.org, dsterba@suse.com, dushistov@mail.ru,
	evan.quan@amd.com, farbere@amazon.com, fery@cypress.com,
	freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, harry.wentland@amd.com,
	hdegoede@redhat.com, herve.codina@bootlin.com, hpa@zytor.com,
	intel-linux-scu@intel.com, jack@suse.com, james.morse@arm.com,
	james.qian.wang@arm.com, jdelvare@suse.com, jdike@ad.kvack.org,
	dtoit.com@kvack.org, jejb@linux.ibm.com, jmaloy@redhat.com,
	joabreu@synopsys.com, josef@toxicpanda.com, kadlec@netfilter.org,
	kbusch@kernel.org, keescook@chromium.org, kuba@kernel.org,
	kuznet@ms2.inr.ac.ru, linux-arm-kernel@lists.infradead.org,
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org,
	linux-staging@lists.linux.dev,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-um@lists.infradead.org, linux@armlinux.org.uk,
	linux@rasmusvillemoes.dk, linux@roeck-us.net, liviu.dudau@arm.com,
	luc.vanoostenryck@gmail.com, luto@kernel.org,
	maarten.lankhorst@linux.intel.com, malattia@linux.it,
	martin.petersen@oracle.com, mchehab@kernel.org,
	mcoquelin.stm32@gmail.com, mgross@linux.intel.com,
	mihail.atanassov@arm.com, minchan@kernel.org, mingo@redhat.com,
	mripard@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
	ngupta@vflare.org, pablo@netfilter.org, peppe.cavallaro@st.com,
	peterz@infradead.org, pmladek@suse.com, qiuxu.zhuo@intel.com,
	rajur@chelsio.com, richard@nod.at, robdclark@gmail.com,
	rostedt@goodmis.org, rric@kernel.org, ruanjinjie@huawei.com,
	sakari.ailus@linux.intel.com, sashal@kernel.org, sean@poorly.run,
	sergey.senozhatsky@gmail.com, snitzer@redhat.com, sunpeng.li@amd.com,
	tglx@linutronix.de, tipc-discussion@lists.sourceforge.net,
	tony.luck@intel.com, tytso@mit.edu, tzimmermann@suse.de,
	willy@infradead.org, x86@kernel.org, xiang@kernel.org,
	ying.xue@windriver.com, yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 15:48:30 +0200
In-Reply-To: <20251017090519.46992-7-farbere@amazon.com>
Message-ID: <2025101730-mumps-protozoan-aca4@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam05
X-Stat-Signature: nkzbm6f1km7sgmtacqfqna6bsdhumzsu
X-Rspam-User: 
X-Rspamd-Queue-Id: 7198C2000A
X-HE-Tag: 1760708958-755497
X-HE-Meta: U2FsdGVkX1+BvMqs/W2zbnDpcumZzOgxePhhz6cIQvGXk4PlVVBI0yxBOKSMpK6eijSMPJoUPbdt2jSrul64tuY67S7Z+ztktIArXc3gNT+UaRXo54mfCVeH49enm+enw9KBNsCnRA8YQQ68lP5QyNx0SL40XDmLwbv1VQnBdZ6MJzSxIfxporATg2tYwq62HJO8gaFIxcoFYMVFbJOnYwlPbRcy2mIHve3cGdodNuxyNyV2U4//TmdF1X6rLhC11pGKIUHXcEh2ZEQxgw9iRezLtGmQ08NSHAD6OFKTNiMZCIoPMPKsoPIoUh4WjTy/V+s5kai7FJpi47NnqDsa5rpj7i8LPFllRKWH2G86ZgzY41fl/xfPkPbYxn5PFVuWMhc/PX8xIL8IQEgjV3YInSjpC1DRKU24S2FRSDjHBiphA1gagczTSmmQoA30HCFrqdlvY1Cyq5pfpI6JJJqp5XNsT9yMIBiYvb/Ec2jmH5ZcqqDJwTUJ6UGt/+FgJgnTJtHhQRVtCMrSyTQKZ+Wk+4Rz8Ybcxqg70MscbwAsADnXcVpMhVbarN/o6GqQIIe5Jj9rKZM8vAJs9BdEgsPdrlVcA9U5hmsPaaA5xbCZczKRiohloR8rAbHVCpDnjgCiCeq+dfWX0QXVJ9FHKUQtaW99jCkOrNFSiAp6+icd+s+3Nxpj6BvWaAXX34OzwBPPbby8nH2FSnnYM9LLdNCYTPaakisG4Xz33CYn38ToQKk9hnDrpgVKFrdM/R8U3zm3E9hz03lHNdT3kmAHdbXC9NTJQbuXoe0307xqbvDzMYF4pli3Jc2GdkIuf2zGNJiWvyZgzmaLhXaDi0h0j0Mn2XRYAd1FGOMYYkCy+l1IPvACFTwllxAraC3Kci1+7SHLPwa7gG5PRDRB4E39Mb9IRHOPdx+B9i84J9vj6SEdfryqUeWeG38vIom7Sj3OtP//sREyw+XLw/ZRrS56QBW
 QHXIDy4Q
 EwdcRv0eFfIF8xwQiqexSckyEoviWIt71rYH7egvkq55K7qNBdwxnEkw2kJnsvaJdTwzAJI+wUWgMafQJQZ9Tw2lepNrR6RSeUAXcirGRTrnkd1R92lzynVX+gYajjRYqEoDwKruJZn4yumxbGbMYX+XY+Zg6R52Y+aX+tbQmzsxfCxlyn0uYIh+L7uFkBblBtiASjuAmFCn+RtGDEydO2HQZAayS/qA8Y5898TglP6Lxd5RbtdO5w6eWSV7dI04qSVwVgw4jOhviElDO53gCI2opNBGBsAqK9VxVztb+EVq4jn/++1zoHaexNXaCtw7ELffndFSnpZMCSrPOtclw9RzOghG+ds/6FfQNnGfcojKH7pacc7Z74Vf0b2aBSjlE6f2LDl+JrWDKGGXSf3H3rtJUFXOpXxBDE1MndW8xnUrfQYw7hRIbKo4rcfr4q9QO3fTLJd6gbnahhhtNrJL6l/fC+It9uFCZ91CWSxVxvMal+oOuqN8+2niH3UpJ/Dubc9dSR8mfPBNDZyfO+fIMWrXZUEVzNpBWz+uNEPZ5zfFw95WCfM/SmPKkV6S5HwqpdIxT1FP48IUxyVArZKi7x8lISLoFRTIxlzNg7WoSOxzvvueMaYJl1pGy7h1r/PGLtpyThsOn6RT4vJ+chhGsRUalSb9TFpaSKooYp+uXHYGBKHXAls8/hpPE3wHQeemA6b1b0Uj5fG6yOkGw/t+/rnT57spTlk83tAgCIlE4XYzjup2czz46jQjSw+mtTZYZDysg8Z/SY9vK9Il61tdYI6Q5Ak+URcpQr7eWiA9RQLrMg8I/EAbtnahS57xKPLLo3Aizw8iEv2Mt8TNgQHyCYug5vpzvZR6MB3DMqiJVlMDO/jrwI+UGFWlj/HUrz6g9PNXFr5wK++2btzfhYvhACmi+uVK/haHGnQrjK9SskYGDTrOxptOfJlKMs+I7xpJph8VhVlJ8cYMu2edyVllZ21/360SI
 rypYjF0M
 R/mHdYRrydknIRtDT83mkXQ/37S7WTMoqsDYDI9XqBMFzGr+QwOclTdJr4tTCJfG3Yx3S6e7e4Jt4xA6VPpenrtgi5t9zxMkHB4wK6cG5Bvzkc5PyhMRX73q3q5NQ7yPx2BHT5UHgLofSGERZgQljdGouC9aXTFAcBGgxVG8aj+45HEz4qnVQWEvfJrHe/mkXcplRssjxCRjoy3lTg2MNPGuOqrfeix8tNyS0xw/jK7d3E63/c4O1ksiDVztjUKXdKn+hFy8qVuIJNKxvt2+Mf9u55Zwl+sdWUdtUhKtDs/pUqQAP/0slbfd1DIhIILX3f5NRWhYsPInV99l3n/6WKuQVuo8rBw/cn855vu0RTNc7fAOphY5jivtcHQUtm16VvwGP9leUCENPKKOD3K5r8f/VT39MgAI11Uhg4vDPaSX/16XFlf8+Rq42WhgyOQe/9uNsNmfjkIAbTgvlRWYYogfmUeRykCX+hRLGpfxAGGKhsSkNV8jkbw3Re+EaPsWmlPhQ3CTOjf7hOK0hQwM+BFx16aYpJClrgTuJzrKKU6eN4HG+5FLAmxEdOt9CpXeecxcrNqTMaoFY3WOpX0C7hjGQVBxiWsfLEw+g5XS3mtlE+oN7SaydxHImnSboIt59Tk9hsqIRi559wDmCK/7IhmNfZngIYcjZvioo16f4f2Jux2X3S+GEkn+iCcnHuNnX1lMExvKouPrKEVN/h9I2G4cBFZLOAG0cH4mRTWDZ8ZC84ASDiQtb6CKFr3oL4v4MOf2bsf/l6/TNJ7pj9Eyx9yMRmlao4ZGsDMFi4fuN0OK664yNsEXTvG66M5QfrAQUwv334V0tzR7ZtIqMFblXx5nnwmH4JyFZQUEf0/dh1FTbNPc9c9MF0PadJ3hGsHHOreTSgTsNfy56Rwvl6cRXuiK1t/dNKmkk+Sp6riyJ8lrFnJwRvYdenvkbuvE++j5jrmso2zX890Xp2+ES2Q2nBeEtleus
 VQ0CjzGm
 s9aeW0uFRjG9sdK/S8BmmCkMWz2eGD2KxXvYfn11UgQKLG3Vg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: Introduce {min,max}_array()

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-introduce-min-max-_array.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:07:34 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:04:58 +0000
Subject: minmax: Introduce {min,max}_array()
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <20251017090519.46992-7-farbere@amazon.com>

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit c952c748c7a983a8bda9112984e6f2c1f6e441a5 ]

Introduce min_array() (resp max_array()) in order to get the
minimal (resp maximum) of values present in an array.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20230623085830.749991-8-herve.codina@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   64 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -151,6 +151,70 @@
  */
 #define max_t(type, x, y)	__careful_cmp((type)(x), (type)(y), >)
 
+/*
+ * Remove a const qualifier from integer types
+ * _Generic(foo, type-name: association, ..., default: association) performs a
+ * comparison against the foo type (not the qualified type).
+ * Do not use the const keyword in the type-name as it will not match the
+ * unqualified type of foo.
+ */
+#define __unconst_integer_type_cases(type)	\
+	unsigned type:  (unsigned type)0,	\
+	signed type:    (signed type)0
+
+#define __unconst_integer_typeof(x) typeof(			\
+	_Generic((x),						\
+		char: (char)0,					\
+		__unconst_integer_type_cases(char),		\
+		__unconst_integer_type_cases(short),		\
+		__unconst_integer_type_cases(int),		\
+		__unconst_integer_type_cases(long),		\
+		__unconst_integer_type_cases(long long),	\
+		default: (x)))
+
+/*
+ * Do not check the array parameter using __must_be_array().
+ * In the following legit use-case where the "array" passed is a simple pointer,
+ * __must_be_array() will return a failure.
+ * --- 8< ---
+ * int *buff
+ * ...
+ * min = min_array(buff, nb_items);
+ * --- 8< ---
+ *
+ * The first typeof(&(array)[0]) is needed in order to support arrays of both
+ * 'int *buff' and 'int buff[N]' types.
+ *
+ * The array can be an array of const items.
+ * typeof() keeps the const qualifier. Use __unconst_integer_typeof() in order
+ * to discard the const qualifier for the __element variable.
+ */
+#define __minmax_array(op, array, len) ({				\
+	typeof(&(array)[0]) __array = (array);				\
+	typeof(len) __len = (len);					\
+	__unconst_integer_typeof(__array[0]) __element = __array[--__len]; \
+	while (__len--)							\
+		__element = op(__element, __array[__len]);		\
+	__element; })
+
+/**
+ * min_array - return minimum of values present in an array
+ * @array: array
+ * @len: array length
+ *
+ * Note that @len must not be zero (empty array).
+ */
+#define min_array(array, len) __minmax_array(min, array, len)
+
+/**
+ * max_array - return maximum of values present in an array
+ * @array: array
+ * @len: array length
+ *
+ * Note that @len must not be zero (empty array).
+ */
+#define max_array(array, len) __minmax_array(max, array, len)
+
 /**
  * clamp_t - return a value clamped to a given range using a given type
  * @type: the type of variable to use


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

