Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B468CCD19F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 609718E008D; Fri, 17 Oct 2025 09:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B32D8E0006; Fri, 17 Oct 2025 09:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C96C8E008D; Fri, 17 Oct 2025 09:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AA258E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:49:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 051BC56C9B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:30 +0000 (UTC)
X-FDA: 84007738542.21.F11DB45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5541B40004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=yqxmbqhU;
	spf=pass (imf27.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=b/WKteETKlx4UVPhThMSLhvGVPiy33dH8OLrdpXYLYA=;
	b=Bqs5G43Aw7YkAddM17RL4bYV85dIz7/jJz4ULgk3DIKJVAckt+Up2s6pZP5YtQnwYtrNXK
	a0vs3ohMkjipRhfS1+sg+K8Cylt0hB0nCKZxVf22yg+jhkmlq86yysIbrvl2Qxt0qvo7D7
	t00rnOnQBFXK1DJflR64+tTyXsuMpkg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=yqxmbqhU;
	spf=pass (imf27.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708969; a=rsa-sha256;
	cv=none;
	b=2WuhFGEAodDSzRHZIRiFnMQCRbm1t2jJja1gmirVROyUa63s4/AMLp/6v75A6iZsRyiInc
	90frr6skfLnxGMp2kK2rJ/C2ihLG7LIYybHBDsW17fh+GzY4NE/9LboCiJBXOvMaSR34ND
	HPLWs4GJDN1erx6IYE9oEUG09Nd85js=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B68196436C;
	Fri, 17 Oct 2025 13:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9BDC4CEFE;
	Fri, 17 Oct 2025 13:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708968;
	bh=AXLQbIpyqBEyGxGkGpyjpB8PhkgTtFqjbG86wloeB2M=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=yqxmbqhU7Dn2HCy1bkSgzeLXKO4ric/nqqoNtScWtY2TiedRGdgf80qDK/YCbLrvW
	 IfY1WEOiCiL8yfo5PoNzofMqcGQu/GZcXm7b3J/KOIjhfnMNX5k26xlfcaQlJ9I/ot
	 aMXMN7ghK0WAjsQI71lH1wvqQb4ZGI2z8dhWEx6c=
Subject: Patch "minmax: make generic MIN() and MAX() macros available everywhere" has been added to the 5.10-stable tree
To: David.Laight@ACULAB.COM, David.Laight@aculab.com,
	Jason@zx2c4.com, adilger.kernel@dilger.ca, agk@redhat.com,
	airlied@linux.ie, akpm@linux-foundation.org,
	alexander.deucher@amd.com, alexandre.torgue@st.com,
	amd-gfx@lists.freedesktop.org, andriy.shevchenko@linux.intel.com,
	anton.ivanov@cambridgegreys.com, artur.paszkiewicz@intel.com,
	bp@alien8.de, brian.starkey@arm.com, bvanassche@acm.org,
	chao@kernel.org, christian.koenig@amd.com, clm@fb.com,
	coreteam@netfilter.org, daniel@ffwll.ch, dave.hansen@linux.intel.com,
	davem@davemloft.net, dm-devel@redhat.com, dmitry.torokhov@gmail.com,
	dri-devel@lists.freedesktop.org, dsterba@suse.com, dushistov@mail.ru,
	evan.quan@amd.com, farbere@amazon.com, fery@cypress.com,
	freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, harry.wentland@amd.com,
	hdegoede@redhat.com, herve.codina@bootlin.com, hpa@zytor.com,
	intel-linux-scu@intel.com, jack@suse.com, james.morse@arm.com,
	james.qian.wang@arm.com, jdelvare@suse.com, jdike@addtoit.com,
	jejb@linux.ibm.com, jmaloy@redhat.com, jo@kvack.org,
	abreu@synopsys.com, josef@toxicpanda.com, kadlec@netfilter.org,
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
	mripard@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
	ngupta@vflare.org, pablo@netfilter.org, peppe.cavallaro@st.com,
	peterz@infradead.org, pmladek@suse.com, qiuxu.zhuo@intel.com,
	rajur@chelsio.com, richard@nod.at, robdclark@gmail.com,
	rostedt@goodmis.org, rric@kernel.org, ruanjinjie@huawei.com,
	sakari.ailus@linu.kvack.org, x.intel.com@kvack.org,
	sashal@kernel.org, sean@poorly.run, sergey.senozhatsky@gmail.com,
	snitzer@redhat.com, sunpeng.li@amd.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	torvalds@linux-foundation.org, tytso@mit.edu, tzimmermann@suse.de,
	willy@infradead.org, x86@kernel.org, xiang@kernel.org,
	ying.xue@windriver.com, yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 15:48:31 +0200
In-Reply-To: <20251017090519.46992-17-farbere@amazon.com>
Message-ID: <2025101731-gong-handrail-375e@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: zsr8jdugijgtpxey9mf9c8cwsyze63x1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5541B40004
X-HE-Tag: 1760708969-329390
X-HE-Meta: U2FsdGVkX18tgqCk+hMMsPXE9V1chZ10jSi3N5WPw3JNv1btQEjXUsw9aQbqM6XgAc0mX16ZklBb4cMUAQmT3FVO4hDXubdCmqSHVpUQo4DoEami28nFhIIXdfRfgqkqvtJvDy/B8/5mQaTEhc11OdRGWd3Jmr7K/S2fXI1gvM31BSMjkIdOx1aLgyWDDgcZTITXeOUu0k/FsVAQmsO1YCoNAsbi2YnpnZQo3ickz6m3GXVREXQAwnRgRMC+vovzv8zLNhMU0P/WgndPzml7oDDld3DlYNcHQcMwwdWs8aD7i58UVlmPdHDHHZvGIwewpc9vT0MnqudMWgeEUyQZHOwLRbLznagIljKiymJFvaCuDrrAV5jVfOEZunvDlHRVdMLmkqo9KMT0qJszeF8KP2lqTZkrrwSzKNjiDKsIZuCoDWPCz9D49HYD7+/pc0ZOIbhbpjtEXLvLr4PZTZo2V+3zBcObkNdMSq7NKG49gQeaX4OTyRaKOawxYiMLojKYSjClQjAs+oan4GO2vDjpMg+8Ky/yrWQdRcdPgGXRUPMUvlUqIxajJcZnmPl3lI9cF4qArx8aXeY8FoaGeb8zecoeJGe9O2pUS0L2LvAG3BrI7PGul/7/OvgkZQKFzJRjgNpeT+LAExgLI7/5BymW9zR7r5APFrBdzrIF9Qi9lIENPWU3lLk17QtM7adoyt8GmUx6e/il3feoFpfxxrFgeiIvgSvMyKexb7993ySdLNWdiM9wWymqzY3Z1Taq3C+IfFobThtY1S94lJuxuvuRS4mdAZ5kmnmOe8s5tg47zINiESCDHZFIt9aPrTuTMcJDmFIPXMIs2fu2G/vVb8qc9KOI6OIEgwcNk2CGrMZadNGKTLkNdzoe5kxwmc8RtwsZiHT2Xonpxs4dQG5GdHnh1pVil3U0SErAOUwGOv3n9BpU8NfLRVfG1NYPeBGKs1wHeIgWzvtbpcc3NpRaa6b
 GuMDzlAV
 +jVjFMTjdBfqQ0WsZmGALW7dA5uNnl8n4v8rHm4Y5p1IkNsSlrK1Lsz0Ysf+kxIlAjvWOquuvgP3Ii4abqyT0rznInFMVm+qxOAnDwjjgyfGpb2kBPTIgZ/dx9AP9WseeKIQD2iYT0x9ZOCjN6U9ifS6/66zzUA7xZqz8Upnm4PbVM4JIjLHsERJafvvdXPP0TJzLILAeW/J9FSZURFQ98MQclvWVzE4NZUOm0Hn2nKg14jNEV4WEmAdHOxR5SB7oB3VcbiaHDXIwk1gAZfuRPXtFOw/mpzKPiCpd2kuqNFr5EWs/3dJbuioWCmb83y92GQTsck2MGtmdPa9JG+pN1argx6l2pRKXKRyNkhthvD2eOoVGUpfhVdbna8h//G5mYTnZvjUPUGa4L5zz3puiGFVumHyiIHnOP/8mOR70k2AJ9HEy13y0Q3++/FwPLKbhk+nlEjwBxfHEhzWnyHqRNoFHPVMRWKia51LNrT/1QDicGjP5DiwMcdYPNir5YctAWoH1UQe/GQK1VouZZ6vYosYgaqyLFbAG8UI1SXM5l3pqXzd3J/A9Kb+9snoqNOyoDzRXu8DclcDhdArshRd+/Yc+wBZGTBeZUFNpicrJESQNzGjuQ3KozsVMzDD6Ho8OIhZWtrb0+j5vrySGk5e4RVc9K9wcjSlgBP/zz1LdiMmvRszmi32X3HMShIXZuUFuX1QnppxKD6oXm1LqPHfosJn/Xso4AgnAU3mXB7Vr8Rc3lmp0cxL3jfNBqNyG8sg3d9ntome6zJmqYQeiFIlhXkRbrc8eYTGlNQZRCio1KgFxIxD0oz6qCBAivr9c89DNCSxNHOLF3GITxE4Dg0xwacyHcXc1DK5FX5S5Ro82uQ9C747F7F2LcZo9dWwz4dXZ6ucH13by5ZXlSX/9IyE7GvkYs1vfnWax31MTSHZJP26REXDfqSz9aTh2DKe6mTgVDk7Mad1HGpkWaRfyI39S59bJpSPv
 ZF1vLgh+
 HgTa0BAzmhD6mnUfQcLm33yRCYCIZxvVARuSlW4OT6kWu8TtWYMJNicRgKWN2qV7iK+OT5GFngMPVQ2LeM1vCIO9PCJ0kjDbetw7Kw4qHyV9+EPxnpbjhnGI4SdEYOkgTDZH1OnEyN4ctniO68aifySJPZXgztSUGNFkBofj4f1fp/33fCNNx4llkVvZDTuHpnKLJra6HGoCboTFMbN9kGT3DzTK0UGi8BvYgpWBTCx1rae/SqzvuVbDxbLQjz4xjDIGb3Evps/6/bzA9FGEqb0VChsMEfhnQ4qPn1dgO2l0Ae9WJyUqKJTWogbBiK7YGLK+aNM9goenbzTd2MW2kbjIXERmXONhpbHDv7fL5CzY+6UOzgXM50Vp/M3neO097UrcYy4kcO1l3OD66gd/80Y4cIJrClrQmMNfiDX6QLHfF0lxIAcG3axxAxnbBGuAePBTDXeT4eK047l6tvttErozJ5Uo8je7DRzcMvIXgp/hbhnYcMFvLu3ckIy9XrVvuKDgN3Ft9a990cLQQAwuZOJDNOgv2dta4usHpO1Exh+GFFxszS2GdrRjOEZL1MjT/ziImI4axEBF2cBd0j2LLGlN4ed+PSxGb/Kj1T18YknaHr133dhBq2c3pz7hsIl22/XyY6ad6pDXldIZt/IEOI7a0l8OTCDEdw/j7PDN7Xw/x9EDRQ6EngA8bQ8ezS9OEZ3bKsDtgxMu5SuqEpHyc69DNVMIoaB6SVI+UF89ainoUz2Yjyl2f8SsQZMqprZEXgyALEszAXCMIvqef9XBEyN6tGZdg9raXTGssRYFPIKsewbASAsLH8QRaHveKlI2gTRrmRux9S1pjbB3kIP94Iaqf2CFUpYQ4fo9FFG6xKZSr2M/Jvv9xghI/iLw7LWRkfJ5zsOicOr4WVZhTwBa8n6pkt+zTk2trLwETv+mYnE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: make generic MIN() and MAX() macros available everywhere

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-make-generic-min-and-max-macros-available-everywhere.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:10:56 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:05:08 +0000
Subject: minmax: make generic MIN() and MAX() macros available everywhere
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Laight <David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Message-ID: <20251017090519.46992-17-farbere@amazon.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 1a251f52cfdc417c84411a056bc142cbd77baef4 ]

This just standardizes the use of MIN() and MAX() macros, with the very
traditional semantics.  The goal is to use these for C constant
expressions and for top-level / static initializers, and so be able to
simplify the min()/max() macros.

These macro names were used by various kernel code - they are very
traditional, after all - and all such users have been fixed up, with a
few different approaches:

 - trivial duplicated macro definitions have been removed

   Note that 'trivial' here means that it's obviously kernel code that
   already included all the major kernel headers, and thus gets the new
   generic MIN/MAX macros automatically.

 - non-trivial duplicated macro definitions are guarded with #ifndef

   This is the "yes, they define their own versions, but no, the include
   situation is not entirely obvious, and maybe they don't get the
   generic version automatically" case.

 - strange use case #1

   A couple of drivers decided that the way they want to describe their
   versioning is with

	#define MAJ 1
	#define MIN 2
	#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN)

   which adds zero value and I just did my Alexander the Great
   impersonation, and rewrote that pointless Gordian knot as

	#define DRV_VERSION "1.2"

   instead.

 - strange use case #2

   A couple of drivers thought that it's a good idea to have a random
   'MIN' or 'MAX' define for a value or index into a table, rather than
   the traditional macro that takes arguments.

   These values were re-written as C enum's instead. The new
   function-line macros only expand when followed by an open
   parenthesis, and thus don't clash with enum use.

Happily, there weren't really all that many of these cases, and a lot of
users already had the pattern of using '#ifndef' guarding (or in one
case just using '#undef MIN') before defining their own private version
that does the same thing. I left such cases alone.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/drivers/mconsole_user.c                                       |    2 
 drivers/edac/skx_common.h                                             |    1 
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c                   |    2 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h                    |   14 ++++-
 drivers/gpu/drm/radeon/evergreen_cs.c                                 |    2 
 drivers/hwmon/adt7475.c                                               |   24 +++++-----
 drivers/media/dvb-frontends/stv0367_priv.h                            |    3 +
 drivers/net/fjes/fjes_main.c                                          |    4 -
 drivers/nfc/pn544/i2c.c                                               |    2 
 drivers/platform/x86/sony-laptop.c                                    |    1 
 drivers/scsi/isci/init.c                                              |    6 --
 drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h |    5 --
 include/linux/minmax.h                                                |    2 
 kernel/trace/preemptirq_delay_test.c                                  |    2 
 lib/btree.c                                                           |    1 
 lib/decompress_unlzma.c                                               |    2 
 lib/zstd/zstd_internal.h                                              |    2 
 mm/zsmalloc.c                                                         |    1 
 18 files changed, 37 insertions(+), 39 deletions(-)

--- a/arch/um/drivers/mconsole_user.c
+++ b/arch/um/drivers/mconsole_user.c
@@ -71,7 +71,9 @@ static struct mconsole_command *mconsole
 	return NULL;
 }
 
+#ifndef MIN
 #define MIN(a,b) ((a)<(b) ? (a):(b))
+#endif
 
 #define STRINGX(x) #x
 #define STRING(x) STRINGX(x)
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -36,7 +36,6 @@
 #define I10NM_NUM_CHANNELS	2
 #define I10NM_NUM_DIMMS		2
 
-#define MAX(a, b)	((a) > (b) ? (a) : (b))
 #define NUM_IMC		MAX(SKX_NUM_IMC, I10NM_NUM_IMC)
 #define NUM_CHANNELS	MAX(SKX_NUM_CHANNELS, I10NM_NUM_CHANNELS)
 #define NUM_DIMMS	MAX(SKX_NUM_DIMMS, I10NM_NUM_DIMMS)
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
@@ -25,7 +25,9 @@
 
 #include "hdcp.h"
 
+#ifndef MIN
 #define MIN(a, b) ((a) < (b) ? (a) : (b))
+#endif
 #define HDCP_I2C_ADDR 0x3a	/* 0x74 >> 1*/
 #define KSV_READ_SIZE 0xf	/* 0x6803b - 0x6802c */
 #define HDCP_MAX_AUX_TRANSACTION_SIZE 16
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h
@@ -22,12 +22,18 @@
  */
 #include <asm/div64.h>
 
-#define SHIFT_AMOUNT 16 /* We multiply all original integers with 2^SHIFT_AMOUNT to get the fInt representation */
+enum ppevvmath_constants {
+	/* We multiply all original integers with 2^SHIFT_AMOUNT to get the fInt representation */
+	SHIFT_AMOUNT	= 16,
 
-#define PRECISION 5 /* Change this value to change the number of decimal places in the final output - 5 is a good default */
+	/* Change this value to change the number of decimal places in the final output - 5 is a good default */
+	PRECISION	=  5,
 
-#define SHIFTED_2 (2 << SHIFT_AMOUNT)
-#define MAX (1 << (SHIFT_AMOUNT - 1)) - 1 /* 32767 - Might change in the future */
+	SHIFTED_2	= (2 << SHIFT_AMOUNT),
+
+	/* 32767 - Might change in the future */
+	MAX		= (1 << (SHIFT_AMOUNT - 1)) - 1,
+};
 
 /* -------------------------------------------------------------------------------
  * NEW TYPE - fINT
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -32,8 +32,10 @@
 #include "evergreen_reg_safe.h"
 #include "cayman_reg_safe.h"
 
+#ifndef MIN
 #define MAX(a,b)                   (((a)>(b))?(a):(b))
 #define MIN(a,b)                   (((a)<(b))?(a):(b))
+#endif
 
 #define REG_SAFE_BM_SIZE ARRAY_SIZE(evergreen_reg_safe_bm)
 
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -23,23 +23,23 @@
 #include <linux/util_macros.h>
 
 /* Indexes for the sysfs hooks */
-
-#define INPUT		0
-#define MIN		1
-#define MAX		2
-#define CONTROL		3
-#define OFFSET		3
-#define AUTOMIN		4
-#define THERM		5
-#define HYSTERSIS	6
-
+enum adt_sysfs_id {
+	INPUT		= 0,
+	MIN		= 1,
+	MAX		= 2,
+	CONTROL		= 3,
+	OFFSET		= 3,	// Dup
+	AUTOMIN		= 4,
+	THERM		= 5,
+	HYSTERSIS	= 6,
 /*
  * These are unique identifiers for the sysfs functions - unlike the
  * numbers above, these are not also indexes into an array
  */
+	ALARM		= 9,
+	FAULT		= 10,
+};
 
-#define ALARM		9
-#define FAULT		10
 
 /* 7475 Common Registers */
 
--- a/drivers/media/dvb-frontends/stv0367_priv.h
+++ b/drivers/media/dvb-frontends/stv0367_priv.h
@@ -25,8 +25,11 @@
 #endif
 
 /* MACRO definitions */
+#ifndef MIN
 #define MAX(X, Y) ((X) >= (Y) ? (X) : (Y))
 #define MIN(X, Y) ((X) <= (Y) ? (X) : (Y))
+#endif
+
 #define INRANGE(X, Y, Z) \
 	((((X) <= (Y)) && ((Y) <= (Z))) || \
 	(((Z) <= (Y)) && ((Y) <= (X))) ? 1 : 0)
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -14,9 +14,7 @@
 #include "fjes.h"
 #include "fjes_trace.h"
 
-#define MAJ 1
-#define MIN 2
-#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN)
+#define DRV_VERSION "1.2"
 #define DRV_NAME	"fjes"
 char fjes_driver_name[] = DRV_NAME;
 char fjes_driver_version[] = DRV_VERSION;
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -126,8 +126,6 @@ struct pn544_i2c_fw_secure_blob {
 #define PN544_FW_CMD_RESULT_COMMAND_REJECTED 0xE0
 #define PN544_FW_CMD_RESULT_CHUNK_ERROR 0xE6
 
-#define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
-
 #define PN544_FW_WRITE_BUFFER_MAX_LEN 0x9f7
 #define PN544_FW_I2C_MAX_PAYLOAD PN544_HCI_I2C_LLC_MAX_SIZE
 #define PN544_FW_I2C_WRITE_FRAME_HEADER_LEN 8
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -757,7 +757,6 @@ static union acpi_object *__call_snc_met
 	return result;
 }
 
-#define MIN(a, b)	(a > b ? b : a)
 static int sony_nc_buffer_call(acpi_handle handle, char *name, u64 *value,
 		void *buffer, size_t buflen)
 {
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -65,11 +65,7 @@
 #include "task.h"
 #include "probe_roms.h"
 
-#define MAJ 1
-#define MIN 2
-#define BUILD 0
-#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN) "." \
-	__stringify(BUILD)
+#define DRV_VERSION "1.2.0"
 
 MODULE_VERSION(DRV_VERSION);
 
--- a/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h
+++ b/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h
@@ -31,11 +31,6 @@
 /* A => B */
 #define IMPLIES(a, b)        (!(a) || (b))
 
-/* for preprocessor and array sizing use MIN and MAX
-   otherwise use min and max */
-#define MAX(a, b)            (((a) > (b)) ? (a) : (b))
-#define MIN(a, b)            (((a) < (b)) ? (a) : (b))
-
 #define ROUND_DIV(a, b)      (((b) != 0) ? ((a) + ((b) >> 1)) / (b) : 0)
 #define CEIL_DIV(a, b)       (((b) != 0) ? ((a) + (b) - 1) / (b) : 0)
 #define CEIL_MUL(a, b)       (CEIL_DIV(a, b) * (b))
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -277,6 +277,8 @@ static inline bool in_range32(u32 val, u
  * Use these carefully: no type checking, and uses the arguments
  * multiple times. Use for obvious constants only.
  */
+#define MIN(a,b) __cmp(min,a,b)
+#define MAX(a,b) __cmp(max,a,b)
 #define MIN_T(type,a,b) __cmp(min,(type)(a),(type)(b))
 #define MAX_T(type,a,b) __cmp(max,(type)(a),(type)(b))
 
--- a/kernel/trace/preemptirq_delay_test.c
+++ b/kernel/trace/preemptirq_delay_test.c
@@ -31,8 +31,6 @@ MODULE_PARM_DESC(burst_size, "The size o
 
 static struct completion done;
 
-#define MIN(x, y) ((x) < (y) ? (x) : (y))
-
 static void busy_wait(ulong time)
 {
 	u64 start, end;
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -43,7 +43,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 
-#define MAX(a, b) ((a) > (b) ? (a) : (b))
 #define NODESIZE MAX(L1_CACHE_BYTES, 128)
 
 struct btree_geo {
--- a/lib/decompress_unlzma.c
+++ b/lib/decompress_unlzma.c
@@ -37,7 +37,9 @@
 
 #include <linux/decompress/mm.h>
 
+#ifndef MIN
 #define	MIN(a, b) (((a) < (b)) ? (a) : (b))
+#endif
 
 static long long INIT read_int(unsigned char *ptr, int size)
 {
--- a/lib/zstd/zstd_internal.h
+++ b/lib/zstd/zstd_internal.h
@@ -36,8 +36,6 @@
 /*-*************************************
 *  shared macros
 ***************************************/
-#define MIN(a, b) ((a) < (b) ? (a) : (b))
-#define MAX(a, b) ((a) > (b) ? (a) : (b))
 #define CHECK_F(f)                       \
 	{                                \
 		size_t const errcod = f; \
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -126,7 +126,6 @@
 #define ISOLATED_BITS	3
 #define MAGIC_VAL_BITS	8
 
-#define MAX(a, b) ((a) >= (b) ? (a) : (b))
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
 #define ZS_MIN_ALLOC_SIZE \
 	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))


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

