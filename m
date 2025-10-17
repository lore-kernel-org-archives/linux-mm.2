Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB6D1CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CB058E0085; Fri, 17 Oct 2025 09:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47A268E0006; Fri, 17 Oct 2025 09:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369D58E0085; Fri, 17 Oct 2025 09:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EC9E8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:49:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8890B6D0D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:00 +0000 (UTC)
X-FDA: 84007737240.22.FF4216A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 362B1C0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:48:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=y4KcmjmU;
	spf=pass (imf10.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=o8YaNhybsgzuKxoDUBW5CiCnV6/oBDNn9TKdX56gyqk=;
	b=GVqCWg54L1J0OkVLxwLQjGRO7MputzfsDy1lu+ZtRWPpz1S1kPBReFMflQNzOInyODygG3
	dU0ZVY4WsR3MsMOlTNj9I3IQQugnkCfpMNpV2qu4CxPOdj4v14WFCb8NrYkpcDlu3rY14P
	bn2uc6Pl0t/giMNtO1zPrcb7rNxUqiE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=y4KcmjmU;
	spf=pass (imf10.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708939; a=rsa-sha256;
	cv=none;
	b=FipVEzqKgBbOh4gmKZbDW9NDk2NzutI5RN0ay6IG4CFIn0wQ5QorcPF7ng74g53a4Nef94
	bDHujwSkvQFHPbv+G5VZhDZGOkqpgR0PVNOvXg4GMrJOp6hq0iGScZFQfbQVJuQJMX1gon
	p6daRdTrpLMWZdi5llNihyZN0pcYz/g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 700AE64364;
	Fri, 17 Oct 2025 13:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7553DC16AAE;
	Fri, 17 Oct 2025 13:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708938;
	bh=K3Vod72wndBL8Jl9osf6Sjco5Cz5wu2HiJRhWmdhj5g=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=y4KcmjmUQZDYHmcorELuXEr4C7NJFHRVibhvAkRjP2jc3VZmvGmMTOrXYFez2zBRr
	 wVFQ3WD3KsNqO7f1K1B+Y91RI3LhjX9rueeCuGzIEP5IYCYnwnGmVA63UbJWqGWnox
	 OE+uvduOhKz9cpAM7VTqHG5VYts8ZZy1R3RnLqwE=
Subject: Patch "minmax: don't use max() in situations that want a C constant expression" has been added to the 5.10-stable tree
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
Date: Fri, 17 Oct 2025 15:48:29 +0200
In-Reply-To: <20251017090519.46992-18-farbere@amazon.com>
Message-ID: <2025101729-blubber-blinks-3a79@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: cw56yueqm9wpkhsd1ky9zdozrbadxbw3
X-Rspamd-Queue-Id: 362B1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760708939-72018
X-HE-Meta: U2FsdGVkX1+6G62y/VYr4J/QHhaEybVRX2F0SjVsWdWEM51WkI7Lf7DUaKU67vGAKENkYp9psW7+BcpGJAoyv7buZewyPF1RfB4qgeJX2fv3TQropMyhqfoTRDbdUKzsJ2lk+EF1sYv/xIOW9rbwaE+koOaRAAXUbmydGxrBa2I/eYz3885m8R+DepEaq+2yInI8MwQ0i/C86iPfI0wiUCSNFdczCLioq3IFyKfSx3Imd6CdhNYK+4vZurVejcuy4joAbI862BPhicUMSgApgcfiXUrO5bs4ZgdSqeyTnP35vxTNRw29xNW511nSJ7ljh3B97BGggQh4XKA1jg2XfzP5OPFl2dxBiGoUz5g03x0Of/M1j7c4lxcqGLmjuCZ3EdWmsQP1SmI/qqadQ4gZNw7RWtaPYUSDtOLNT1wx+hUWUWTP24TBcnRx/GHVMJxa272SKL7XZSbZdY9poL3osAmI6wMcIQxu/D4i/nAMU/oI2dPpSwwbBfNTgF5wLf2Hzvy8Djd0eycI7YPaFQkIhUD4EbEwZYy77bAAOUzxmmsXuL/F9LQVBzZ3NWW3vMTLpjXAud1gkat2+sBSbjUebtpIIHMZOCfGusqpNpu+c7fQ6Bpa2d4DfJ+61KwWS6psb2Ftb2srzHeFv4EARS8gDuUI2tC8i83nE1hfjAOjmrDVObvbcsJbxz47YNFwa0U2vKtHh0q5VCIJ26HCz5skuIpbZv3Rh/lf+xyVS/GkmueZPys/wDOLwg+1K6OJkhuTSQ0TteLYNCizrtt4lYiEGAwXlkIEGVOqujVN/fTlm6Uop3oAmkE2y3QMRfOEj7Byi0hHeIIDXQN87WrZModkMCH5FNIDXgXTCtVIKEZuH1tQXSehXcs4etAEKd+IeS6OaYEkaNjZViEBsQog2Bi/a8GWQ1QCikk02P6bw650n7cWUyJuhnyIJBLzKWVh2sVuDlqlzgofPnxjO9q34wE
 NqhQCsVp
 EXBOm/8C5CNPC49aUJ3VC/cUR0+DmvnxdAKCw8iSMAN8MWSWLvyj8lO+6imPSuNvVQIRwirlW/H9p1yN9T1xWlhz6MtPcw2uVA1kMbQaZr/e47OL54k4AjwV4nfMBct5TwwMOxOH5gcGF+39ockfw9Y+mY5BqWNzsTtdq2b59WDiij/Z1JF/9x6+/TkcTK0mQs9JzlcDap5x1QelOfgR2AUoWYl2NBOnsivf8aZxL/eY7f8Bfrind/sYcsXdk2sis9SJNmshlGWGCwbXXPLLqrKMsq+WE6D93wz1xP6TP/iPT8NneCseCMZ5oQZ5jt2h2pW9Re7tuGFnm/jcIbfuSSBj2e+Nh6DhP2zt90yPzG38y5c01me7dYxcsY5qxLsi9Xpo/CmGTujDuQpxbImErQLvwoXPM9fBNdECWHJebGSObK6lkyt+NzMXi8KvwA9ZK2lqO0p8Hd9odiXz/XnpUTp3bgFQjdvGNmY3NSJwZzDwHsMkrCPHubFwPJMVWSmN6XQC8jblljYfcBRwak37Y9HxHjtu+iZBentz5JLhnGT/2KkFH16dTEUJDeAfe7B0XIxncODkgfc3i5uYMutMU4Z0gw9OyPAz1d+SQsUUiR4rhC6aeN55kfqE048oymDR+fgca6jLZuBFAW5wAf7W/+jgWNk3+j/gSDBK65aVoy6iHz2LYDpgzL1IWPn0jxl5/z50LAJhnr7anXyw/Zw79mjMQ1hxYwK/f6oN7hLxv0DZuoLJMfLfaBqdNxHCmIpT17YeTEVuQXy9ligiDBLo+plF6uf7KeQDyCKPvFBbghDsTYw1C4IoltMfuQHgLLM74y6NJyHPFR+2LQhs+Ys0RoZucHL8W8W7eh9Z5e47b61rMd6fGjcVNKmBJgC2ZxDzsMguDEmPGJp832Cbhq0/0w3Nd/iLlP4ZlQiwjXlfwOUZG7Vf80kGOrPlR17vEiIxzVB7HPIUgSq3TOSrqhuk69436LqEo
 alqVn2MK
 RWOyMJYBc2U5TQMN1ICFM07RJCdImG+/Huj1oQczh+NWYiAHDc9mYzJq3cuUrX+/3nSqpj1MIwxaxc0NRXafs2g2vmXQBS0H60mEQRrdFm4TGV/6NNR5B7dMgdPM6Y2lKzWs19uq8/KR2944j2urs7XzJY6Yf1agS5BELcT0LRFMacNQqJDEiGQHD1EsLZ3XIrB/6778Q+2axCEVb4vckipWZcJmJp4FMEYiNj16Ql2s0R4USSza2lsHK8UoEOAmoIrxygyckDUoryj0Ka6m9lCaQTy3xHeTOL5F5suBtl5EU75PwS+bN+Z0K3HugSYdOkQT2VZw4vhshkODXsLhY26glUSJJGraLD+qud1BoaYX+b3eDvBtjezuiCVgUvF9gxPZ2Yv/iwMI//VpVJvSyP3+RTflbV7Yp5fIDy/2ewJhThAkUk0ePAPTCxI3PEIwbI6hlc+h0C+ErsKkoHFJp67f9UrCEhp2gjtbZrOLwW19wFmtboVUBjgUxbHUzLvH0xkQZrXPFcyuaM5R11WJg0ORxzrEQBhQXriYAOCdxeU0Xxm961d+qkgZx4EU8AEL7UlcGnCEnoOdP5Q++LBz7mCD8jFuqMLc2wIzZg/1ug0OP7R8NPjKdMlwMwqZM2FISD+ifwuyHjXEIbkoZ0uTc4NxBgHLDO3OIvCjU17TNoa3Y0Q3zoGZQns2JPlQ6pr7anyMeQO5JNgb2SxiFOUPTgqn/5tNT4Kll9+O+/5Yj3hFn0pb+TZvlImIHblDfm3156MOvwGEfJy+PuEjqCjknjKquEeMsob7SklzRbM63vYjE6iSFxe90WXc6vEZgW3tVjDEaHsxkN1ODT6wzZ/E0AUxeJzlgywdMxR9pA3anxOq5wB7twWmX7+tV025sCVY0DryhcPRaLV8yiLfKVW9wKrsSyP/6I7o9Wo8a1JOYTnADmY/O+hfD9NptOzAK4SPPSMIczEhTR8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: don't use max() in situations that want a C constant expression

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-don-t-use-max-in-situations-that-want-a-c-constant-expression.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:11:06 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:05:09 +0000
Subject: minmax: don't use max() in situations that want a C constant expression
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Laight <David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Message-ID: <20251017090519.46992-18-farbere@amazon.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit cb04e8b1d2f24c4c2c92f7b7529031fc35a16fed ]

We only had a couple of array[] declarations, and changing them to just
use 'MAX()' instead of 'max()' fixes the issue.

This will allow us to simplify our min/max macros enormously, since they
can now unconditionally use temporary variables to avoid using the
argument values multiple times.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/cyttsp4_core.c |    2 +-
 drivers/md/dm-integrity.c                |    4 ++--
 fs/btrfs/tree-checker.c                  |    2 +-
 lib/vsprintf.c                           |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/input/touchscreen/cyttsp4_core.c
+++ b/drivers/input/touchscreen/cyttsp4_core.c
@@ -857,7 +857,7 @@ static void cyttsp4_get_mt_touches(struc
 	struct cyttsp4_touch tch;
 	int sig;
 	int i, j, t = 0;
-	int ids[max(CY_TMA1036_MAX_TCH, CY_TMA4XX_MAX_TCH)];
+	int ids[MAX(CY_TMA1036_MAX_TCH, CY_TMA4XX_MAX_TCH)];
 
 	memset(ids, 0, si->si_ofs.tch_abs[CY_TCH_T].max * sizeof(int));
 	for (i = 0; i < num_cur_tch; i++) {
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1600,7 +1600,7 @@ static void integrity_metadata(struct wo
 		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 		char *checksums;
 		unsigned extra_space = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
-		char checksums_onstack[max((size_t)HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+		char checksums_onstack[MAX(HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 		sector_t sector;
 		unsigned sectors_to_process;
 
@@ -1882,7 +1882,7 @@ retry_kmap:
 				} while (++s < ic->sectors_per_block);
 #ifdef INTERNAL_VERIFY
 				if (ic->internal_hash) {
-					char checksums_onstack[max((size_t)HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+					char checksums_onstack[MAX(HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 
 					integrity_sector_checksum(ic, logical_sector, mem + bv.bv_offset, checksums_onstack);
 					if (unlikely(memcmp(checksums_onstack, journal_entry_tag(ic, je), ic->tag_size))) {
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -587,7 +587,7 @@ static int check_dir_item(struct extent_
 		 */
 		if (key->type == BTRFS_DIR_ITEM_KEY ||
 		    key->type == BTRFS_XATTR_ITEM_KEY) {
-			char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
+			char namebuf[MAX(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
 
 			read_extent_buffer(leaf, namebuf,
 					(unsigned long)(di + 1), name_len);
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1078,7 +1078,7 @@ char *resource_string(char *buf, char *e
 #define FLAG_BUF_SIZE		(2 * sizeof(res->flags))
 #define DECODED_BUF_SIZE	sizeof("[mem - 64bit pref window disabled]")
 #define RAW_BUF_SIZE		sizeof("[mem - flags 0x]")
-	char sym[max(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
+	char sym[MAX(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
 		     2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
 
 	char *p = sym, *pend = sym + sizeof(sym);


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

