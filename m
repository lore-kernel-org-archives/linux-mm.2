Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C67A9CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5C68E0084; Fri, 17 Oct 2025 09:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D868E0006; Fri, 17 Oct 2025 09:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16C968E0084; Fri, 17 Oct 2025 09:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1F3D8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:48:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB7E01398B3
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:48:56 +0000 (UTC)
X-FDA: 84007737072.03.99D3FAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 05BF04001A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:48:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=VAGVlPZh;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=Z+nCDkpUmOiyvyC+3FWkYZOq/vDObvQWNwUdH2Ay4V0=;
	b=H3Wc/vwCSmxcgTFVGkNiUIWbgJAbzkeYngT/CuL3pTdJKgUCI5zt8E2pO9JqGm/PVoXtSO
	QQ9snW0VdFJ1OwDoJtLw9pUPryNMkgo08oQEEUOLlaoPFzLamFwZdLvwlSb3YhmMJWusnA
	z2GT5ATeRvcNB5EoiviFO74JNnquBJw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708935; a=rsa-sha256;
	cv=none;
	b=JA+SoaTzlWDm47H+ErrckOEDJuZp38IJyGq+WqAWpdHdTcDVmvofbt3OAHT0Cq1LELBw+O
	On5HocFyiT3DQmHEiduwK25hFVJozNtlFha/a9CAlRETYIpk3ahbiGhHRNJAJYKQh7wiV0
	Af1Zx685En+yqWuvDpEihDO8lx3c2+Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=VAGVlPZh;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 088FD4B418;
	Fri, 17 Oct 2025 13:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C25FC16AAE;
	Fri, 17 Oct 2025 13:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708933;
	bh=5Po0jPJuYXl4UtKLQzL3J5oqgd696Ng56D52ztzrN4Q=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=VAGVlPZhSU55SWD6d8vTrJjWDjWo+VcWtuR4/3aFhCVTFzdc3YOAL53ZH0X4huMb6
	 WtCREdJOglX1WiGPbXSWDbOsDfHn2nIfk2vURwACSxs4UGSa9rgJlbrAJdmPZavaFf
	 mlAAzAvF2W+mckc+bEKDEMYxl7HvR3zQBOZ0ryeQ=
Subject: Patch "minmax: deduplicate __unconst_integer_typeof()" has been added to the 5.10-stable tree
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
	josef@toxicpanda.com, kadlec@netfilter.org, kbusch@kernel.org,
	keescook@chromium.org, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
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
	sakari.ailus@linux.intel.com, sashal@kernel.org, sean@poorly.run,
	serge@kvack.org, y.senozhatsky@gmail.com, snitzer@redhat.com,
	sunpeng.li@amd.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	tytso@mit.edu, tzimmermann@suse.de, willy@infradead.org,
	x86@kernel.org, xiang@kernel.org, ying.xue@windriver.com,
	yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 15:48:29 +0200
In-Reply-To: <20251017090519.46992-8-farbere@amazon.com>
Message-ID: <2025101729-boogieman-eatable-8d3e@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam05
X-Stat-Signature: cme9qhuna7hod9617jzm8juxxuictkma
X-Rspam-User: 
X-Rspamd-Queue-Id: 05BF04001A
X-HE-Tag: 1760708934-517854
X-HE-Meta: U2FsdGVkX1+qB+tt+ftp5OrS7D55NpWJpaYrqTSJy9glZIqnUp28V+UC0xez83aT9eWCtAqA6yPP92ebZxdkH5ohyiso+hnQtjtRDc52VvxYXoU9pf1P9P+coYHuEWjbAQOuSunrHWCOe3PUWLuVtUe55ntkbVu3DGP+1/J0cag85YYBFWrOuUtw6DNOEq4LrdTtNmnNV/VhFvqdcScpTl6ugvt3ZdwmX6wkey2HsRSr0DI/NKgKwjum4kUYgeoYJ0TTyPcomnOOhcSLHUTqHeGgKnXkP6QvKGb2EPp9KWIae5HeHX91x3MVONkXkZc95HNK/VfDYNe1m1wi50D214JMrVZIQO06r6+p7f5ZyYtcBFnvDWhHRD9nVktza6NfkW1a6cqRn3zObSNdySEZ3DbqQCCYo5iKi1fENcU+QVVth+QlkUPzDmiBpv8e21qkz1cRNpjAgkU8QsuWURte4xY7J3XZx794/U2CkL1uFgeAWlQiJ6z4OGMn7mrP9HJHmjB1OHQLYkjKbpm7MnE8UGCH+X3jryKI5Q2s5gihHa98T3DquC3F3mPYIwJA0Abuki0fAbu0oGNo32S0vf63hdrPpgLMdpxkO0SNAU4TEfK7l6zHxdzY1ova8ksT+L3goo0KQywwS/yXQB2Ls5+TSVLsBMGfLOotRViNUMdB0rTFX6ud/53bO8wjlfPYZDZf/8ErvbMVBUzeQtMFJwFvD29i/beoMt0wcvcYSHpaYRFP1JOGoIqc/o6TcKAWjROb+jYXjq4f4Uu1OijJaOQa+uoFxtGDehM+jaXly/sP81SMd+VX4vPvaTFfjIzIZbVImJeVARBApKkE16TSjolQ+rPTBSq+gbDLvFhgs4VwAoYtEYvsJV5UaTSAGqHeIArFJOlC79CLZFqrwOFfGx4jACbsbp/o6veDAmNDxpxSuNz6O0BHBto2cI7Q/8+RUx7TPyDUL2bLdqxk7KT6OsS
 RHZgDP4u
 Uj7IC9q5pzL5281iwFIOw/s3NPMGUalBuZBi5oVx+eJl6A1EdJHTWSIJyJV9DyqaPGnH1auvbR4HZyf+BjQBxYVUuj7pJ6Ze+nxgIVXl4K3iHeaUeGPoXUVpaVysjdnM3Z0T5lrLBwxQ8lIbtAjxkNQul3ad4h2L7o559GXXziXEAih9KvRadpuh7gxCEOPGy/95K11xENlNOaEvrjvcLyh40eLRQuAfYchiYrZ6GBH1vaG+IoDcdacsf5I952Bt6dDHTpJiEvS9PZkHxnrQUCebPJiQ8DhTMp3/kyWVsIrSt+p2TKIegdNDUnwtV4cvb0kVEsrSa4g6Nc+Ry7zvEQIxujrgmuRWFmI6A1OrCEMK4g51mmDASB6Jvcfl+4Fq1DeBIF/NNV+59vteqVCnVpRdI/E3YSG+iOtaL54THbDXC2vV44YS0zwEmbwO9b/vQgqIaZeb5LPpfWpomBd5gsk8Xqdo+1t+IdEsp88rgRUGU1MNzh3hUzPNJJ+JqQt6HbYXxOT8U6blqt0W0lSHWtiT4z8E1aJ1XmQE0ohleH67LTv9Fi+32n9rKaHSgCUjjgxwOuU5gIRV8Lw4RfrR54xjA01EGtQE+9+1T7TdHdLk9tLT0oIUYHkYuMMq56hH9YRe70/8QUiDJ8VjRjLIU6xV1r9VxCGht4zNdQfNEPFdmUqu6Dg/JRcvl/ukmfGLKaMcSBA5QG7vR3U32EESYm15qmBYOz/HkQzKrbWGcmLbyniNmgmIIMFD71SIayqTBCjoIi1RxuX8g9/Zj2MT7/Rtr1JKZSwt0P/kauQzxQetAjVvfxWg2bEV+UFSlnKrr0lzWiKBJOX2ohCOk7ATbqTH1Ez3WH0s0KupPeGHE8SiGewPUXTKzFUMq5tlIfv5EiiMUJxaz4PomdrvaGc+9J7EvP8TpBevXOo54VL60/TagzngojJY/OAxvrnw5kGOl8+KvajMyFyJRGdhHPpjvM/bA5+J7
 K08fCcJC
 laBdI+CavK2Xh+EmE/mSfUyfuycYHKhqOnU70089eW4LFMsA17WxKsfi9PzI1ut76fisVKXjU8M4RcuV2gtTh/v7+Jn01hoKoNeexuz61LIzQmSM+LrY9KCD/GxiHZwGrt92Vxd19aOrRGO22vk8Nf+zvzT1IUkGndSWnNRGAJm34Gepou+U7IhiIJMjX5WrDjwmynT73QaXjcYJhlXBxixHMkI+x+ztiLr7PtvLP/DoPrYLocUnhvlqAZ/hW6MIj9nKC0muXwjx3FbrjNIlLLJdhIbiWNag7eQSjPBG931Mv83RGSl/EKp0qNhZdyDL4EadgMuNMLTag8Bj92ZcUDNUukDFbaO68NGUqyeOlNvyg8S8xaHQJ8ioFeZtiqx4vwmng6aVEt4RxKTw8fkKwyayJlqpLL7ZXgNoJxz9rojYqA4JXL0QcqIpaPidVaNA3IRcvoRnDybo0/CB9rnEYfhpTxUJIIlMKzjTxwtdxEetjGFJaI/MRvl+UK1chKgko9vW2Upyf386C9iFtav4voz3zaRwQUHrtm233yLaRhcpkVFkk3VARBhARbiVem5YjTQa/HYf7Fp2tpn/n8WpU8cwFiBkDBsVL9gjDrXehriKv6e8Hq96+QSW+k3G/09FNRpakfzXDV3yHHg0+OS12zGmvTwRnS5obf8rLrBJdrYJ0qISM4bjGXST28zcexBm3DkObLHsft4LexSBDWrMxgBnsW6kviXnY7aWYllB8NttPJLIxVy+2jNpJhNNMz3f/ajjTei/hcdYGifS8wu8GoBQkMof8R3s1oMVPekhMpc6E6+HHXQsyN0c4+fOCn/Ohs+RSdN/Rot9PnRTS9Th4sEinbLVI6ZTVzNsae7gxyJzAP/SE56mHMVcGZRcBtCCVOihNE1AmHmh1xFyEA7ERZ8QVXsfw3CdLk9I2pMZKA/hYL8ApOWggUQQCBAHFT5N1fIZjocXfOE+ZmNyiflkf+aDfXCYx
 7y3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: deduplicate __unconst_integer_typeof()

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-deduplicate-__unconst_integer_typeof.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:07:56 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:04:59 +0000
Subject: minmax: deduplicate __unconst_integer_typeof()
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Message-ID: <20251017090519.46992-8-farbere@amazon.com>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5e57418a2031cd5e1863efdf3d7447a16a368172 ]

It appears that compiler_types.h already have an implementation of the
__unconst_integer_typeof() called __unqual_scalar_typeof().  Use it
instead of the copy.

Link: https://lkml.kernel.org/r/20230911154913.4176033-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_MINMAX_H
 #define _LINUX_MINMAX_H
 
+#include <linux/compiler_types.h>
 #include <linux/const.h>
 #include <linux/types.h>
 
@@ -152,27 +153,6 @@
 #define max_t(type, x, y)	__careful_cmp((type)(x), (type)(y), >)
 
 /*
- * Remove a const qualifier from integer types
- * _Generic(foo, type-name: association, ..., default: association) performs a
- * comparison against the foo type (not the qualified type).
- * Do not use the const keyword in the type-name as it will not match the
- * unqualified type of foo.
- */
-#define __unconst_integer_type_cases(type)	\
-	unsigned type:  (unsigned type)0,	\
-	signed type:    (signed type)0
-
-#define __unconst_integer_typeof(x) typeof(			\
-	_Generic((x),						\
-		char: (char)0,					\
-		__unconst_integer_type_cases(char),		\
-		__unconst_integer_type_cases(short),		\
-		__unconst_integer_type_cases(int),		\
-		__unconst_integer_type_cases(long),		\
-		__unconst_integer_type_cases(long long),	\
-		default: (x)))
-
-/*
  * Do not check the array parameter using __must_be_array().
  * In the following legit use-case where the "array" passed is a simple pointer,
  * __must_be_array() will return a failure.
@@ -186,13 +166,13 @@
  * 'int *buff' and 'int buff[N]' types.
  *
  * The array can be an array of const items.
- * typeof() keeps the const qualifier. Use __unconst_integer_typeof() in order
+ * typeof() keeps the const qualifier. Use __unqual_scalar_typeof() in order
  * to discard the const qualifier for the __element variable.
  */
 #define __minmax_array(op, array, len) ({				\
 	typeof(&(array)[0]) __array = (array);				\
 	typeof(len) __len = (len);					\
-	__unconst_integer_typeof(__array[0]) __element = __array[--__len]; \
+	__unqual_scalar_typeof(__array[0]) __element = __array[--__len];\
 	while (__len--)							\
 		__element = op(__element, __array[__len]);		\
 	__element; })


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

