Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FBDECCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34728E008F; Fri, 17 Oct 2025 09:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4268E0006; Fri, 17 Oct 2025 09:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95DCC8E008F; Fri, 17 Oct 2025 09:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D8EF8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:49:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49A4F84EE6
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:38 +0000 (UTC)
X-FDA: 84007738836.14.415B719
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B023414001A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=GzjvAXg0;
	spf=pass (imf26.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=1OHIt/7SZCfyq58Eb4Ug7CxstFzY9ZJJc87uBs50aH8=;
	b=a/K8HyeTsckoovYaSEWDpPaL+yLK1OthbNdTlgccYajCOW0xz9l62/eg6xqqG/9QWD1g4/
	jvyPclV/NHc/9Ek6WjE9lxCGf83KX5oaoJPCRNI0ETG31txMYy9uAAvmCsyIsbVbuzYYrc
	qXHhM/B8l3dLW/V16nSZxisEs0Ny9P4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=GzjvAXg0;
	spf=pass (imf26.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708976; a=rsa-sha256;
	cv=none;
	b=sC0olKxun4bRLLX8ulAkNYsyA3s6OfsCKiW5BpBw0CUaf61spYaR/e763vK2JYMmhQEWQh
	BBumtxrTwKFxFbYYKs4n+qlbLamjCreSqroS0hU0tkVT53pjs5RHCktquLoNHlGuZIVYfW
	AU2V1POR4N6bCG8nrGhdJApXa3qZihs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 073AF64373;
	Fri, 17 Oct 2025 13:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F734C4CEFE;
	Fri, 17 Oct 2025 13:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708975;
	bh=9jtFB6fkH633w/YRDC8I2ktI4eHtEAnV+wCzYr95A4M=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=GzjvAXg02LWr6Hgn9Mk6jnGgQBgndpo2MW6lKpgTalnAXOP4qF2TqVghjcLoS9KgF
	 UgEbQWKuIUKACxXxYpn2eroSt2X+aNvSoo1UlOFYG/A0SgopT0ToU/6DlZJ//3/gfa
	 095t/GPCVLEuCZga9x813pFQ2L/T2hhYv42xUJAE=
Subject: Patch "minmax: simplify and clarify min_t()/max_t() implementation" has been added to the 5.10-stable tree
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
In-Reply-To: <20251017090519.46992-16-farbere@amazon.com>
Message-ID: <2025101731-payback-eradicate-6385@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: x1jcchruu8zydz1yrk66h7ksokjpjxfx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B023414001A
X-HE-Tag: 1760708976-942229
X-HE-Meta: U2FsdGVkX1+e6nvdGta9FZyiA1xhXt6FR7fIJNzFSiixE6P7YBif/ovAiiAxK91pSPe6QNjxzgwN/PXCbswwF5xUVKcq4kbyRTdHZne3rmbzcNfk0GZiU/bRb59qJOrzI/u17OCLSoUkWD84W9cjlbDgese4xfC4G2QwFAukWeiYZwAIKX3fpKEeto+zfjg7xsu0mqVeCPbb1p6WwbAjfzHjilL89nY+kMItfETfHkVHgXSE5MKwns6tjXOPOL9tYF+bC+VmnuZpEkVIt17FcQm4PcDk6/BOZI0vARsOw1rFlPRzkkbc27Uwa7Ng8wM/sc+Z7u5N57+H0+YRAfvEb2vhOiIGhIC/myR2BlVR/bEET+VpEvb0gBvyLMMrsemM9N+E2m/epD1Pp8gKbs/gtV3GlSArykls6NgKKsiH4/TgevuzMnJcFSYBle/9Te2WckVJqWYfF0k1GJF05KB6+7h1b+e94xPlSnDo2UbcY7u6WwL0FPZl2NOGmhPbXcusX4t31zccf5Q61WN3cW3UC5vBKFwrmgMNr9o3xlt9UKRRWAvjBtXixQISw4wGK+jwLoEmlwnZjg4Sh43rXzcVY2GVqMtb1nbvh+P824BKvmLWFf3oFEdGyrdGhF25Fk3jQB/vlvmiTaHHue7E+LmmRkDgwaM2JhAuFnlMEgMi/Lnhfo5A6SyoJ7bPvNu3t4/1g8tnmPRhEQAhtMwrZiX//witVNYym1DT/wSPYOiPKccsioL8qbqSteZ1SKvtM0MGDZSvPj483k7fKGINdd7p2uStp3IWvjPpstxOdkYcQOi4/8T4J+ysjs4sbHtvurt4Cz/Kw4rXIA8bqPwp5nvAF5rXqtq0d+DYBdxTsHunxOLpVyZPlgUJqlNxO7UelJOnZhJGvypKs8VsOV/oSqlvTRZRmzv/iyrz5or3GWYJ4mhJeL+sWJJxWiRhca3xuCpz8VLb5ehDjk5BWz9azs0
 H7krxUfx
 QSGmGkdAyQ5+ZuCzpIVtyi70p+Q1bh+t2SK6MAFygARGBi6LN2pbmG97DpRPjFhGkqnr4orPi0FRfb14aTEF81dDHx5we3e0/XrRqXzYPYrCr/g39qmbHazH2ylNZvWzHyHbi92FOXnuwvPDjyHafSAjMFDW4xreYTI6CrUpruqBZV2qskLzXZbRNu1Sg/3xIbJJCIfUEJUIGUkWEwnsM1lPz/zFOhuK+/dCmAsiVRS9HNwtA6w+uNCBUJ7mFUxom+6M36GuAfvmo/v11mrYH5Ue+WAenGFGUzau9eMKxXhT1HAAxi2ah+5omGffSiyG3YD7JKdm4rUICdLYbs+JjSCg5GY0IZhBo+fDT4ocFX5uryIU9Pd65E+olO2ftj1k4F99S3PGxPYVs522nn4epYegiJSMhP/T+crDZVwaSS4+50LjecuE0R90Fu8gzWmA+HBxjEzDXNL/rWPXNhSshOQrbWj1huOXny08/FEDM4fgixKKdcAAy47xKV+ziHFwEc0vt2lvnyHnUMzUWyA+PxhuwpY1LmPM1Elh399yZtfnEhWK9zixs8iMVm1ShhAo2+58hZtGOhMSXBHCo7K44eTnDtbeebXTFyKJ91vJ3dPM5UXn/od2ES9XWkvCDc5H2wCOF4WdfDyiwsnaA+F61Fm+2NBHZAAAq3pv/6MolFGRiOX0el9YVPbPzvx7oEoXJzV87HNaWyyPMfiTs4cuu5OB8WXK2zvWUMR+uAZzEqseOYSjfbFsO2wf4GzC/3fBg80VLzkCViEfFYP8GygYZU61Ey3pRRSuMqrJm70xursmtNfCC2qM3+txQrb2GZynYrcMw7LlztdHDROCF2zLP37b3TvGtv3Cnwf1uYlp74q3NH8nGdOqh+FAuuEwiMsZzRwinkwjCstXW+DolzxjH+WibcNkye0qgRWs5VJuZkOS/odOQtmUSjBPGki/zSiQxEv2J5QN8uA1fqBA+ypRvZGUjGgGo
 3pcGoh1/
 yP5XFtKjq1KA3ILj5vbs0sjEuY7HdorwCbOnhXxqJBnhO3b2CK6LKG+PPwp9Jav80h649WLtG2s9A/5aZ9Q63/3xhdKp55VqfaxbKFOFy+7yKQCTobTgVpUROtwerwj4HodFZ2eDOleZQXwsw7VkGp0NEDDaZR9/nTBOpwNq6Cwko13gO7pvyp9iF7Jf5PIT0dfTml72YQJYSE1SA0xlYFLwQMFP33NZC/q/dmrVguKJ5AffGeHEiHD9PRRN2WOTpolZNSiWOSLN9WZ1xev5QzKA3RgpkNskbMZBvcQoTB8xgpLoXZ95iHmhbKLyDqRjPwNuVXidj0MM0zdkllC8j7Be+5TwYt7pcUX/9Z3Lqu63l9nXrWJ3Sgg2FQ28Mj5v7e5eglaJK98g1VT80j5y9aMU93/B/Twr1WnTGycdt4bHtxgqklwOWEVt9ANzR/jZiQLckvxqFrcmASlkKUE5axKMR81k8afU+RkNotoE7hSIIhIAnpKkizFTkRT1f1BUs1TYxvNQRA6TNYFZk3bTbIFwPjYAPblfKyhJvJ7kv5MIfUdhWH9Q8Cua2XqhcBBhktib28Lv4n3rZcHjvIzvJV53B/JSwA3RMcKPcKdmQUgNZt/gpNDHRwFa9/3Cq9TIW06OyqjK4YG+4GXf/uMVy5HWqzMGuHMfSKG52MoemhYwyLUHK4zmuKjp8/eAE7BCXXjCnYHW4qX4M8k5xUTiqCTmnHwzBbb3Ap8rOxtBZkHVsLYoW1ppcsgqUJc79LUpfhkTP8r0NsM18xI5QBAj4xRt1QzmHz1uUTvClhjlmKgkYsXMeaK28LHqStyjnZVzhdv2wp1GqjRfY8KeV8S0DmHak/FavA3WL+vOBTnj9ib4IVQVvGosYU+kkSI+0ipvwmLMISK1vll0G3yNtKEibT+pl81ip+RF34Rn7PcUwcPxr2jEs1Ilyo0oLUgkpb5xm3lL5Ghwk7TzBjQXJpt3spyx2HJbC
 BD6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: simplify and clarify min_t()/max_t() implementation

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-simplify-and-clarify-min_t-max_t-implementation.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:10:34 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:05:07 +0000
Subject: minmax: simplify and clarify min_t()/max_t() implementation
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Laight <David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Message-ID: <20251017090519.46992-16-farbere@amazon.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 017fa3e89187848fd056af757769c9e66ac3e93d ]

This simplifies the min_t() and max_t() macros by no longer making them
work in the context of a C constant expression.

That means that you can no longer use them for static initializers or
for array sizes in type definitions, but there were only a couple of
such uses, and all of them were converted (famous last words) to use
MIN_T/MAX_T instead.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -45,17 +45,20 @@
 
 #define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
 
-#define __cmp_once(op, x, y, unique_x, unique_y) ({	\
-	typeof(x) unique_x = (x);			\
-	typeof(y) unique_y = (y);			\
+#define __cmp_once_unique(op, type, x, y, ux, uy) \
+	({ type ux = (x); type uy = (y); __cmp(op, ux, uy); })
+
+#define __cmp_once(op, type, x, y) \
+	__cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
+
+#define __careful_cmp_once(op, x, y) ({			\
 	static_assert(__types_ok(x, y),			\
 		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-	__cmp(op, unique_x, unique_y); })
+	__cmp_once(op, __auto_type, x, y); })
 
 #define __careful_cmp(op, x, y)					\
 	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
-		__cmp(op, x, y),				\
-		__cmp_once(op, x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y)))
+		__cmp(op, x, y), __careful_cmp_once(op, x, y))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
@@ -158,7 +161,7 @@
  * @x: first value
  * @y: second value
  */
-#define min_t(type, x, y)	__careful_cmp(min, (type)(x), (type)(y))
+#define min_t(type, x, y) __cmp_once(min, type, x, y)
 
 /**
  * max_t - return maximum of two values, using the specified type
@@ -166,7 +169,7 @@
  * @x: first value
  * @y: second value
  */
-#define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
+#define max_t(type, x, y) __cmp_once(max, type, x, y)
 
 /*
  * Do not check the array parameter using __must_be_array().


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

