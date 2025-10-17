Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91129CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9008E002D; Fri, 17 Oct 2025 09:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA0158E0006; Fri, 17 Oct 2025 09:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C684C8E002D; Fri, 17 Oct 2025 09:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4FEE8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:48:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6293D1601B3
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:48:41 +0000 (UTC)
X-FDA: 84007736442.03.683BF00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id B1ECB40012
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:48:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=DlVOG0LF;
	spf=pass (imf04.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=A6XydWory/Jc9cMLo/FiQr2lmZdGZFFiIQGZJf9DQIc=;
	b=FyIxGDufu9nZerOp69OgVa3SZsqLdSqF3isIXfBZRUMvswkvPWwPlbiQPxmrSvALQ7/iSf
	i4f5cdTK9fWnAy6aPCt0mnlB1BrjkLBvr+bH0ktm164EFgZiFNemyC/Kbd3UJPuVS3EZwl
	emfFvA9V0lGm2dRPWxsxqBSl/ZnwyI4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=DlVOG0LF;
	spf=pass (imf04.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708919; a=rsa-sha256;
	cv=none;
	b=xUD7Qxep5PedUxablmeyWvtxd6NYxGVIQHabShpW7GI6d3h6cHaQVbtvUf7O6v7kJ/RFRC
	jTATct7ezsoqJdelXH9MvAaqUhvw5MlkYplrzA30uKiGGC1plqGBfJFe7j45/Yc9Ks7sgT
	tg9VvX5lqdaiQz5YqMrgxIR4wPRLZQI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A257464362;
	Fri, 17 Oct 2025 13:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E596CC113D0;
	Fri, 17 Oct 2025 13:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708918;
	bh=HFvkaZ13OU4BGOQBqUTMo3INNFJGT9f3SEaSy610zjY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=DlVOG0LF+hDXw1mDuswZbwrTEXok4Uz5rY7zqhIo+5QONyCT26ttXp0HCbhBezVqE
	 gyN3y+n8Hq/pJcAu1ONbY0qyQA9LAoDYE8zaV1skzsdQdsXmVGDCTUpegrwV/Nuaiv
	 g+by6nbLhXoRA24/ub279NNhx4gdNGLmGB0TvGSA=
Subject: Patch "minmax: allow comparisons of 'int' against 'unsigned char/short'" has been added to the 5.10-stable tree
To: David.Laight@ACULAB.COM, Jason@zx2c4.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@linux.ie,
	akpm@linux-foundation.org, alexander.deucher@amd.com,
	alexandre.torgue@st.com, amd-gfx@lists.freedesktop.org,
	andriy.shevchenko@linux.intel.com, anton.ivanov@cambridgegreys.com,
	artur.paszkiewicz@intel.com, bp@alien8.de, brian.starkey@arm.com,
	bvanassche@acm.org, chao@kernel.org, christian.koenig@amd.com,
	clm@fb.com, coreteam@netfilter.org, daniel@ffwll.ch,
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
	jdike@addtoit.com, jejb@linux.ibm.com, jm@kvack.org, aloy@redhat.com,
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
	sakari.ailus@linux.intel.c, om@kvack.org, sashal@kernel.org,
	sean@poorly.run, sergey.senozhatsky@gmail.com, snitzer@redhat.com,
	sunpeng.li@amd.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	torvalds@linux-foundation.org, tytso@mit.edu, tzimmermann@suse.de,
	willy@infradead.org, x86@kernel.org, xiang@kernel.org,
	ying.xue@windriver.com, yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 15:48:28 +0200
In-Reply-To: <20251017090519.46992-12-farbere@amazon.com>
Message-ID: <2025101728-aloft-underdog-2dd8@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: zdiyxdnbrs7b1onp1mow5cfctoy6b3dk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B1ECB40012
X-HE-Tag: 1760708919-640535
X-HE-Meta: U2FsdGVkX1+njLVLXa1voQP1OoDbJovv+M74R5ul9ktVJpV8885PWJwwOic54rCr9tzZ+CcosDy91kU+D7CkCfWhB1s4kSR5wzj4a4xp7PG1v2P9T3wBVSru8OZKUj0ZX0aeTbxYnrvYIEaKZdMqtJH4kfQ4DbAGY9ed951rLJ7W1CjX0Jlb8fdEGQB0B5fSOEJHQITYuHA7m69MKppAsrw76NVAMnA2/ZBsTbzqIsYzW3/sYVTDMhr5HilROWkC7eSaQcZbjpLXHTj2qsc1BbGyUeLMFJrvEWYQQQBMpNDGBADE5lRsJ2RnyMoSY454etzqYfOpUoAXiwExw5DIoOZdzNGrf8S868ZtHaf1q77IG/VkRovMUfpeu7cWx/6qH2/RzosWD1sBSlB+DFHuNvNM1GF/am5pFby3wLApmPG4uL5bdflud07/37kTgmRukIe9szwARqVOQQZ7hKeHGgIVG1rD0cWMY1PU8uR3twobNrmNwtoBIq6CsbkVEjJcHzyWws+28cxc1S0Py/W9TF8xBLuFb1Gjt3ciL5coptC9jlyWw5wEKFHjAC2QGE7+TTi1LGIWjR2qIAt3EHm7RORTaPvuxnN/8RCtlROufZ7N+bR7kMLw8UrbdeY5eJ0fOwUMQUR57qEjHu8MdNeWvxPjORPjWDMsjgiyXWPDY7O/8FqV/kIxU9JF6HaAxkhy6Tc6cEX5TvYQ/jIguSaAuxprp2LDVEMk3f4MCKeT47eDPszE9ncrL6e5cdHy6z0Bb0k340Mh9ZFrpAHaGhfsiQ2pfCAKS9nk4tIvLgFi/xiThjRVz2NzLewBvdHz4UoHpycoc+vz51CC/dei0RaR7bX6CIVmK71S+3itEa8OUci3axLDlDnMkmOd91AudihTHAZ1+PhGmQMkhwjgP2igVudgcBxiMQJcJ2oipFmg1n7gXhUTwr8Ukmg5ju56koZImy/c9dMcDGdr3+byIzz
 QoE2Vs6Y
 LMfFHQkkCrvj215Hy8LNWSFAgxgkcbuvEfx3Q5hEldnAdSVEO4wGMlb4LnJyT+REXpqW3h8FmPg5ymL1cGAihKsOyybc9XVNXFX8V9fmBrMKQbowWqF1YudB3R9K2zALN6/aOWpspGFNGkvF0uVkzW6A3LA8SEZ1cytCndC4fHvIGHLKX3lJTskmMzP3KljqHmh54H9gBeNhjmoE3CtU6hnQ8uZUlPKlvjBoCXUdhl3+n4hg1iuq1KUuMmE+8mrPp0Xa1eKBdapxWb+jPfGRlkF0TYOVhoZP89jkN2hSmj4L2ue7OvLWxQEf1wSzhHcMIkxArh1pAQt9LncUcr5vU16sB2kD8sfpXfsL0OhPaGOCgVX7krXZ7MfoGtvHfW+foZ3tvznF0R7P7ggxXtPCvm0xS3UvM21vhXRbu7mD3bOGFv83Y6SevGORnykXSoka5yRyYxL0pDUTB+ske1cYcH+Imj7DbF17JkbY6RMjpY5ARLTwLks+WdD06iPDbsJUcK7I8RI1AvbHu6OZj71wZ2vYQvU9Ng8zxwIlK8b8xZsZlBuVabDXQS2zQoRRgNKRxkEpSgWRSeEeWChwCdMwSej6mqstpaOEXHGBMHhjhXLmybRFBDui6exQHzyMTeVaxE/lSZp4loYBsjfzIB2MuxKkWIhzCXeVF2WAB8mnlIrS9Cv8qfNlr0EaEWhsn8XWb388BA0LnGhkqcdY8+IAO0Ypf9McxQ+7Vq00+4ty0MODvnn0uMWGwA5XIJk5JM7Jxm9JKe+Q+9Z2OjEd1//e0T1/Dq1X8BQC2izvtu5qGhNT95tAbE+xxmsOvmW4gK2Mxr41eoKuArT0NV5pCB4VgRkStNmo/hS23d9/F2eTtPhVi6ltXWUAWzVst1VZrleVTsJgRpCP83Zi/yGQQg9HUymN3DJPN80EcZfCvhRcSujNcuMT2k7vcNaDvGKqPecDKQ9YsV8jZSbdjjNWIyr5qsvCnsK5N
 fWqr/xro
 dUbWk8+mV7E5xNn/OrtIjhqp3J6b+IsX6HoPMnL2nV4c/IlXT5JpsFYXYmUGKdcsqI5Ojx7dZA7rA63u75vGS6TjKEl/m+slmuJz/DmZXTy87OtJ9r6/yiJVRgau6nBoJxI+63bMJYUmcXyVglTJ/2LIcZjjKfE5S0LpR7R9pfa2G7yUnp5bP5UTSZW0oWRrHqHzt0++9T0vgIqgtEgTjAdUlcYbNqZsAVqhD5/a3ssqoK8/CRhLuk6nGyE2bl7RQct93zaQp5jpaBYbHf8stSunlI673aCBIHA3GPxtgvRf4IHhtbtMTnr37KARSisUcx30jQphIaaX85i10lWvsyJBMrtaGQLjwsfGaKO+zhuAwoqN8pSCzjq5v6Lp5GI0gxsr2G86iD/MxU7fVx00ramdOozAFWTKAr9gPrlDn05I6Xk0qOl3nnoCKIMH2OwJzZBk3SaaJnArlT4nYPPJYg16DzvPqxNTDnwvADQoRJ3T6t7vnqBhKuEW5X/enH8DIENsQAo+KjtrMDlCwcwwruUBs0t2BTFGiBKjNz3hUDQRdyXVfiOYDF2C945RNR9JQumGwlCx+wdBuTKdQp1atUsHAxxqf6n8LSP/p/8PpODGtdzvNdeHBkTbWFIzLcF+D1uEXsmh2H8IvEF6gNjLfYCN2/L8yGN3D1wYXvD5AdChQ1vWSU09ebrT1FfkTTABbiylbWrcPAgwSWfzAQm7Pk3iOTfJuPV9+Q4rsDOY1+Pqt/Z+yjvSS1JU5wreXaQ9jVGLybBHljZEj4wkOn35SoMaQ0oYcvWvqfNMYj7uX8IXfllo0dy9YzQ0k3WJm0WpE7w7EshPtGNd0xgM6HDWeXw5HyNSLouKENCSpb4E3COQJYyH036M/NQmxGGzGzdbPGyq3wVUi/YQ8w2dHdqDx1g4KYhcMulnrSqu9AOMtHmUb2FcGxfUDghSQFE3icVs/aUgW77q3sorOSfMXsO2Hw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: allow comparisons of 'int' against 'unsigned char/short'

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-allow-comparisons-of-int-against-unsigned-char-short.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:08:59 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:05:03 +0000
Subject: minmax: allow comparisons of 'int' against 'unsigned char/short'
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Christoph Hellwig <hch@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20251017090519.46992-12-farbere@amazon.com>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 4ead534fba42fc4fd41163297528d2aa731cd121 ]

Since 'unsigned char/short' get promoted to 'signed int' it is safe to
compare them against an 'int' value.

Link: https://lkml.kernel.org/r/8732ef5f809c47c28a7be47c938b28d4@AcuMS.aculab.com
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
 include/linux/minmax.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -26,8 +26,9 @@
 	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
 		is_signed_type(typeof(x)), 0)
 
-#define __types_ok(x, y) \
-	(__is_signed(x) == __is_signed(y))
+#define __types_ok(x, y) 			\
+	(__is_signed(x) == __is_signed(y) ||	\
+		__is_signed((x) + 0) == __is_signed((y) + 0))
 
 #define __cmp_op_min <
 #define __cmp_op_max >


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

