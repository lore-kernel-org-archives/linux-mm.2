Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B6B2CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:48:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2567B8E000A; Fri, 17 Oct 2025 09:48:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 207438E0006; Fri, 17 Oct 2025 09:48:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6928E000A; Fri, 17 Oct 2025 09:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F26158E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:48:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8799CC0193
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:48:34 +0000 (UTC)
X-FDA: 84007736148.17.5890163
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9867E80013
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:48:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=geDc2iCZ;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=9rW2Q0Blw7Adku9sXTiD9ouZyVSq86OMut3vIa3kXvw=;
	b=mKWjWzEwRzOdChuX92R+MhUaiyfpwg6a8UsPaTvqq9AbCGbe0+dA13fPaOQys0bJqDaWci
	sJVTmUnU5utLbARivvvYtc0NESS+8UYrlCX1vNz8hcA6bF6w6z6vIcApY3u5xyG5qysmEX
	Ue9Nvrxdi2xO5P3MNl8YdUeV3pQppR8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=geDc2iCZ;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708912; a=rsa-sha256;
	cv=none;
	b=wLnKf4DRf5R2LUDnf/CciDtBpB9BS6Oaj5nXNwf8UUfXrv4EqCfkN597wY3nehTwqjQl44
	Y5cPoHhLOrSIFDIwHsRMzO0h4m1pdNp8szArW08UziV7UNHdXG0O//HfJa9UWta2NCYRvY
	eCvX4W+m7tmLbLAU1oZuEGGQorORsRk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 317AB4597D;
	Fri, 17 Oct 2025 13:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00E6C4CEE7;
	Fri, 17 Oct 2025 13:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708911;
	bh=U5rI6jYEm/hebyL7q5VHjDrSgx3DOa/8Xq1mYhcV3sc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=geDc2iCZaiiH7/CSUypz4O9I5saDR5an2Eg++KxC8Hq7g8IcRp597KfqnToeoir6V
	 xge/WwSeEjp3RxzrcnE5Cy423LnZtgz6ZfL4FOcq2lmukly5ea6Lavkp3UVXVIKFLG
	 g3yZ+gFrdzFeY4zNZ5z82ZnOI/Ec3n+iFfp0BoS4=
Subject: Patch "btrfs: remove duplicated in_range() macro" has been added to the 5.10-stable tree
To: David.Laight@ACULAB.COM, Jason@zx2c4.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@linux.ie,
	akpm@linux-foundation.org, alexander.deucher@amd.com,
	alexandre.torgue@st.com, amd-gfx@lists.freedesktop.org,
	andriy.shevchenko@linux.intel.com, anton.ivanov@cambridgegreys.com,
	artur.paszkiewicz@intel.com, bp@alien8.de, brian.starkey@arm.com,
	bvanassche@acm.org, chao@kernel.org, christian.koenig@amd.com,
	clm@fb.com, coreteam@netfilter.org, daniel@ffwll.ch,
	dave.hansen@linux.intel.com, davem@davemloft.net,
	dm-devel@redhat.com, dmitry.torokhov@gmail.com,
	dri-devel@lists.freedesktop.org, dsterba@suse.com, dushistov@mail.ru,
	evan.quan@amd.com, farbere@amazon.com, fery@cypress.com,
	freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, harry.wentland@amd.com,
	hdegoede@redhat.com, herve.codina@bootlin.com, hpa@zytor.com,
	intel-linux-scu@intel.com, jack@suse.com, james.morse@arm.com,
	james.qian.wang@arm.com, jdelvare@suse.com, jdike@addtoit.com,
	jejb@linux.ibm.com, jmaloy@redhat.com, joabreu@synopsys.com,
	johan@kvack.org, nes.thumshirn@wdc.com, josef@toxicpanda.com,
	kadlec@netfilter.org, kbusch@kernel.org, keescook@chromium.org,
	kuba@kernel.org, kuznet@ms2.inr.ac.ru,
	linux-arm-kernel@lists.infradead.org, linux-erofs@lists.ozlabs.org,
	linux-mm@kvack.org, linux-staging@lists.linux.dev,
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
	sakari.ailus@linux.intel.com, sashal@kerne.kvack.org,
	l.org@kvack.org, sean@poorly.run, sergey.senozhatsky@gmail.com,
	snitzer@redhat.com, sunpeng.li@amd.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	tytso@mit.edu, tzimmermann@suse.de, willy@infradead.org,
	x86@kernel.org, xiang@kernel.org, ying.xue@windriver.com,
	yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 15:48:27 +0200
In-Reply-To: <20251017090519.46992-3-farbere@amazon.com>
Message-ID: <2025101727-garnet-vegan-53e8@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: nhajipd5sh1ne95ttc97kzpz5q9hoyuj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9867E80013
X-HE-Tag: 1760708912-637602
X-HE-Meta: U2FsdGVkX1/xbZK7VnUfsn9EbMlyUNyy1ocRxxcfksW9sCwEeMxb5DKwTkqqss92wVRkv74gwJv3RbZvWa1eKJ0BGA+fiovZmUrWKjydY1KFax+FkwGLuZMka9UiqGkuPLfFA9dY1k1NbmvMhQWsfjB/C1F6uHjfg+yLK9V3TlXMVVygfqd+485sSh+YJmHI/aRXYFMiL9IGrksfUiVZZjGcVDMfES5fiWG14mQhbwRIHdbrs4E2IDj3r+PaKURyInVkLToMDITcOkTD3fIh3YtSvsKI+gCCvkpzqupIUIxqxhTWqLqhpdrgLWy68whh0GWqb9v3GNGqXWCW0DqdLjBKBkXtoIKMtpehr9uFXOXXipYdB12AincVj02osvQRvoBZdHHGlLtd/H1dcRiOrYq5ORtleGG4DAPxzMk/HAATk9v/EqZjFpA3Gbjt7PQWPmB+I07LPJ9AX8fTNHmdSViafjh4Ji0bLp63OptzVTm/lWrFpHzUV/V7Vcjbvh1eo6zEZrPjzPKGsBrxsce7M3Mw/8qyXywiJ7p3OF0i2S0v/6F32rBopDLgAnkGtwl6v2QCnwS239SY6UzJE3Rdg/jOddTWjCPm5YAtrTnCAU+0GJTAh29ANgIIMco+mUxSbWA+tN3gnp9HfUMVTAVvtwLDb1oANSarq6y5p1Iha8lQ6kYUdrzuPjde1ZeXGggeYQkpGcJzmjYGmk9CxN2TN1dShVGkU3BBinXwCxXJW5oGmfIiPAVMI8JAoFF7DhKnppRe2ORmbr875BELC62ENm0xqMHsIYT8KObtt0W5Y3pHPoHkFQwRtq+ywZ3rSVHDgyhS0IZsmNaHf5WkqolHrEMLL5JLVckU2q0DgR6g43uJ6VMFBZ7v62W5R4tM+Vu0xNcjWZx7dMuJvJEnjX9kcKCtvQsJod+KW91zqr6XjfEq/KmsH6OhXvcBm6R6+jw2oBHHYZsjagH79AidG+Z
 o+weVszE
 uG3VKm65kUbnBTJqD90HdwK+mBuW4mjKN8pTu/qf3C1tX85hIusJVhY1+gURg7vqCIrwrnrY5H1IZAmma4J14z7/bpR+ShpSE7EQ68P0KiOWdc5UzpmvJu2X+MI/s92hOyzDKwwPZkgYigWLkKt5o5qOzyB3uXWCI8M+iSuZn9V0fLR5m7DfDgE55KR2wgPEwhfygz5XEf2oPKKhlmb7l4RXkKFOt0yF2Zx8J/4ikfk3WLhMD/6gXeogzVx4pjsuwjDXFSmCM6IJQbpytLQNSRoFD4zkr0tzSZU4xpm2a1v2vTCU0XcHau3ymkXQxo3EK3dDwAN0lCAb1w4BtyTUC/2N8Yu6LAVm83oyhoDxZhs4MLAmYBgD1lRu6n7wWkn9y9nsvIhl72S1uz3/NrGrVnvP9gjIDkvntZGcS/i+BcQN46hMKtxWOSQDMKPE6pYHluRoaYyG2EXFBCYjq2KQ4yc4jqwbufxeJ7A66z78lE4L2ACqpLgyWODo7Vubf3EP/WsYo4z86JCVNgp/we5P8fD9/n/o4AwL4hZkx8hbmY6GZs2FwoN9s0U2J6fCzK4g/DByOKyfPp3Myt1ySoasWDrl2oQXAapACSq5pfrnZTJIB0azrzBO7NsWjMIawofIA7wOF4wPAG3SDueQt4igSP9u7dc+UlAD68ZZiiCXFnBeZMLntMo1yYIF7WWszDP9Q7Asfa1VrteQentgRyS5X9vg0Ev9q9XcErSm4tfm51jFnZMpEDmf5BZlglN1oC9b/B9ZVuV4Ox/al9a2p2Z4cnmgbwVcukbtxzIgsvWbY+73rguX//vfP17GKGv0KNZFOMrrQOEmekaGQd95V9jcVM0qxR7vm6QlRQI4EW653T2OquVOLd7l3fl9e7ciGfwRjMgQtSMzuwEBGuBX3Ne1PceHON8V8NdoQdqxIVS2Gox0Akv0MUUswN/bNl8h5TR+W+GksZuRZ4gnPeFpeNkmKcPux2yDP
 DOGJtZDV
 L22iif1LsKgdadElYfpMGattlZ86HU4TFjKCarfWYbz+ySZai3J0nehVbeOYN/jso9zyN+/A+9wm6UhStRxg292d0hZP7t318N5UAjomrql72k1btCOucQuDrbzL5YoAUEulG30CtL9laXNtn+VkAIe58lqDblA5aNEnia1PN6WcnT6TFY/0jBjSKlvSiPVweTxgdoWUzWaDWizrBPBOro0BZbnwPqhXus3a+Boan9QtZaQn3AnOmDiflXSOXjBX5CDatV7nucyDRHZOh+bb5G1FihviijnRjLNCcM+Nc7uI6nVexrtWw+0Op4YfiM/pRyYGWRAh89S7il7UalqT7lUxDwzcqhYZQeP8sTmXdv8IkLgCt5JOHZ10kE+mRlSTZty3cI/KvsSdXFILusO4SbBV/OXq7kW4w9bCeniBz8UesQDvkImVzUfXMYXWTuIwIROqjBMVN92Vb7vkOJ+NkVnrpXGKdzvcMXdCDI2JnALKsxcTDyWBvtVj6BoKjIaRlXKkau+Yf5fUZMI7XWnatVuhSEsQloU0hWTMggKqIqwoIPQDfjdaOWsj1dyv2Mdv/89IT3zcRTC/oY+eIiCve5f23GAUHV66K198J9MiEgKs/0UyCwjmKAWwHAsdVSVT5DYBhLX4EmY5Rj3B15ZP6rohMWv5vSyrwmm5LQzTCeNFsPKomrGEdMsTPfMbDi6XDyuNmD7Gtd7DzkJ/Yhgjp6YTdwms+fCrFrIYb3xaJcuxIdkH61jk0InPva5mo02oguppuxWZuawQ3hOtMDmA+dQPOYyioC7hffTSj8V1X2ynxASJX0UJ5EZAXbY7XHwPMoWggMZNkhxXbNYRujRrVRoyREfwIdM1zpbZIET98ryxDlXJVMsYAzPbVbCY0c4Sp8emWVxWgkiND7H4m8+6FMhBH/eZtdTXGSeCNTcUuDk5MSCqb/xFi02hx0uSiPcog8WNVMZKJ9tcIDTW6973ffjZ5a2k7
 xo+/r6we
 tU6ufgbTUKMAI4Eew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    btrfs: remove duplicated in_range() macro

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     btrfs-remove-duplicated-in_range-macro.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-186267-greg=kroah.com@vger.kernel.org Fri Oct 17 11:08:02 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:04:54 +0000
Subject: btrfs: remove duplicated in_range() macro
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Message-ID: <20251017090519.46992-3-farbere@amazon.com>

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit cea628008fc8c6c9c7b53902f6659e040f33c790 ]

The in_range() macro is defined twice in btrfs' source, once in ctree.h
and once in misc.h.

Remove the definition in ctree.h and include misc.h in the files depending
on it.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.h     |    2 --
 fs/btrfs/extent_io.c |    1 +
 fs/btrfs/file-item.c |    1 +
 fs/btrfs/raid56.c    |    1 +
 4 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3597,8 +3597,6 @@ static inline int btrfs_defrag_cancelled
 	return signal_pending(current);
 }
 
-#define in_range(b, first, len) ((b) >= (first) && (b) < (first) + (len))
-
 /* Sanity test specific functions */
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 void btrfs_test_destroy_inode(struct inode *inode);
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -13,6 +13,7 @@
 #include <linux/pagevec.h>
 #include <linux/prefetch.h>
 #include <linux/cleancache.h>
+#include "misc.h"
 #include "extent_io.h"
 #include "extent-io-tree.h"
 #include "extent_map.h"
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -9,6 +9,7 @@
 #include <linux/highmem.h>
 #include <linux/sched/mm.h>
 #include <crypto/hash.h>
+#include "misc.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -13,6 +13,7 @@
 #include <linux/list_sort.h>
 #include <linux/raid/xor.h>
 #include <linux/mm.h>
+#include "misc.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "volumes.h"


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

