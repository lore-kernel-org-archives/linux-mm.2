Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7170CCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6B828E008E; Fri, 17 Oct 2025 09:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1B948E0006; Fri, 17 Oct 2025 09:49:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B0C8E008E; Fri, 17 Oct 2025 09:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9BCBC8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:49:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 350B8855D5
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:35 +0000 (UTC)
X-FDA: 84007738710.02.E54F1A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5D0BA4000E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b="k7BKk/J+";
	spf=pass (imf27.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=T95hHO/pOCUOF/uEdxSIqx1eDt1shT08jSSXk8Aky8M=;
	b=cQDHbU8chWBCy7XFnHNOQaxseSe9YonA8IbYYQAS6iewXHFaxo8BQCRz4iv9Qr5gU45N7j
	KsHrwaQJ3SFj1o7fINkCXZ/ueUqM/flgK053b+PbfHmP1mQ2vK6wXYv2YtmSIPAO7j0BnK
	WV6ASG+5NScP8232EJKM/6QiHvReXGQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b="k7BKk/J+";
	spf=pass (imf27.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708973; a=rsa-sha256;
	cv=none;
	b=ibq52Vgi+41VgqP5GGGku4gVOSn1jJmWPIwIMxXD69l5nZmOdW+HC4hiuOzFpmZ5m4/pt4
	vwp9klg2L8SkI+Pxwwhzj+o9Wz/5mWrntkytcl8XKSvqn3XRK/UmI1REFHJJFD9HVGhCR7
	LFhtqtRAtxzvbXGgXWeXZWnGnNOUYGE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A1994B43F;
	Fri, 17 Oct 2025 13:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD758C4CEFE;
	Fri, 17 Oct 2025 13:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708972;
	bh=C4SzgmKRE06gjdbVP9S3zeoEfakcGE72FYSgstJTWko=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=k7BKk/J+YheiXrEDuIn++bF+Qm4flIGkIrK7ul7+IuO5OZW88JhojCPovXU8GBaq9
	 oOLQtT3qi9nM6hefhAf8QLy9HVPd7SocYic8+sZXqMXLRlfqdSjf+Buc8uzEoO986B
	 bFHefq3pARjF1CNIScIHqzf1El9QhWpsLu9083hE=
Subject: Patch "minmax: sanity check constant bounds when clamping" has been added to the 5.10-stable tree
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
Date: Fri, 17 Oct 2025 15:48:31 +0200
In-Reply-To: <20251017090519.46992-4-farbere@amazon.com>
Message-ID: <2025101731-unholy-bulginess-e51e@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Queue-Id: 5D0BA4000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 5z93ojkag15ysdz4dw8oqg7sip1r9sik
X-HE-Tag: 1760708973-643390
X-HE-Meta: U2FsdGVkX1+MDq4SxGPmM+u4fhztf5GrAwi/maIDgwa3iDk6at6X+RG6dgcE+Q2Kk6MW3aF0l7gzLk4lhL+uM//mVKsl4m1lGP8PbcCYVIXmp2Phvsw86hq9Ur/rnwcCHmaRvjDzBkOkeCvolM0jjVjBs6ZItDg57elsHc/hMTNnePizSOD/dtH8TRNo1lSuHZYeiMQ3cFQK1rOKMRr8XxiLuQhAPyBMUlT0YqmDRJxPIN0EkrDf39EJfocDVQ+C64B5oSi1xszYvE8OXo2ea9vUSG9LFAxKRIXU+y3W7kTgY7cOULKDRd2pifGFSKjEXb1UAk9bY6iEYbauBqWDEXfcYZ8IDAcdgzYGQmtLNWYPW2SdkT5lE7LGLNA78lXEVEV0MXou1izClnTp1Ynp9pNu0Uu1xr8GW/j5D7qwqXAaKON3w2OaOfl239O8+zPbDZm8C9+HgvfmJ/HSbpJibw6k0U9AxDBOeJyACgXzZ6LqyROKf6bowfBhEY5mo2Ii+tfFKmX+iU84zNVPlY0L9jWIgJZbOwV7xJ2n/KapYXw59tKQrjynpBzXiUa551NNNdsXs/Q2ptjUdAFlihmglbZjSh4NJNy/PmaPmdYtH4yBaaqcVUYukIJiQc3l9zIxWdLUlaUuAdxXiAqOVx1tX1VAOFPf9Zyi0X3YYRGYLBhZiNpRwKEueoXdriyZjttHuQ4afGY5aX3cOZ6jLR288PmqUEQc7Os8H0Bi1xM52vnhb4Meas39lojw/o9zSyLMfHfrSs+iJtHswUys0xPn6t40/YoqMkUuSipisQbsYm3gB+c2TZZt7SI41QFT1ZXS4I27Gvp2VpRrpctTJde1TtPSX8eVyTCHlmxHwriJZ/rVA5rhE5HBZ0chxMxkF46xHQBU9Hm5c755xpMAcgZxkTQkaQc1s6BHhyY3VgaNgZlV8YeyNYEPCFXo8/M+84kriduOi4LmXgm0o/2GZh9
 buEQ2wxg
 Ewx5CpgMamIG1fqDzq6fmjMyMeoUD+6yLhda33jXWlb3+HZflnKHuVrdEw911ssiIGLvceRi9unjejSkkUddh2o0d2RsFx9GtlJFsUt4SunUgORNEdfakNJ3FPFnijaifoW/ddC1H0DrnrWiV5mveyEwFVEdacg6IDefXQxibvi7JztAOeOdYiDXjgMwnOqQ3PdlOurqKQaKpvVEqFb7z2Vj44iA2FzT0D1LNBZdxBnlM+BOh+YngCwWQB9soAEq1wE/He1UqYfaL7aPADmA9qX1LfO7SfBxOARZuxZByRP8CXsrPC5gwyzPOMjy4C308jQnmJdiMes7vmGNW5LZd86+OhQ5qfyJ/8WP9j8o0dxo3Xhvn/PDbccmrEOgv0lbZfAZmACSvtW9jh+qaNgQtVuLl+2Fwad8Al45tx+GxuPb1FAf0ob3UsCYPVN1bj+qpIbDi72y3PUjoL/OLFdWJVama011/lx1k2gDPP3F0WOrKfAIp4oPX85tidF6A/dUT4nYx+qJMSnzHkwRVipHssROv2OgQ3CmvwE7s757Z5RImGVXUlGmvsA4idNLAqZEvkbkdgxksZNCbA4gT4zgNeobXIaCZbglUXjFElnNJnSY6I0Dmy9Ie3ptKrX3swK/JBM0X57YsvHHvk6IVlfH/BdW/TFwYH1Q1lJr1J/touLqoyzXl9Gxmw4C1hKWsM6+Eiiu/xkJ/9+NbbEPRRX8d1R5RsFyoyiFbB3iHAmFhzMsXDNngohdWGuDDrQuVoT7Wk9Mb+4IiFho0kf66Z64scVG04OFH/9yhvA+skqivk6mZ/pXXKsKCpRjMTG5ws9CnsP2GXvKdmNEkpLUhriHfnSUDCaXiu6EcVDgcBjK3+Pdg3rFXOIOYMmmFiI9RCfd5rmM7gfxXAZStcHp8U1739t3+FSHu2gsvr8uTQQhgKuVW/DhKTrKatQ9CMQUC5Lfwoh1Y9W6STN/dkyHcRf+sliGF/4WR
 /8a+okSH
 10EyC/DC+2mMA71iuneXcytI70UF9vHnyVLxxMAP3DmpGZmRIsrEK4bSThcH5s2+IJ8vrObnFc+vgu9DkBZDzIi/D8MLQleGPXr+dbazLT/SK9GBd1YqNa4i7wF5zw/6Hf+WTGaGNOE6/n9Yrcq4spnL5rCvZiYVrqba+0Zh8RVyIY+4fq/3D+CUsBK+A0TBGaxZ3pHfcB7AHvH95Di1vSY5KaZSbTeW75HhuvBmUpl7RBtm10nEeriLYWxthWTwmJjDdd8ODDDQYVCGENG8aZPTe6K4oXazjE0pNQhljTYmmM8C7NGHfs+Kw2VOn27ELOa73gssTP3gLvyfZxkltB5SaRicyCAVzsh4NfAsM22TNTK8TWKOfQkLCCMiRxFQIpRQG4fmz1xOkM00PGIEkreXlbuRfM1pPGcDCKCMc+PGoGkleL3RozgTpCc7q8YLehxnOqX5PrmeGJ0YgwvDOhp7WwqvL/s7vQpg0/qe9HGppnkERYyoiLxZ8NEBMFzgT5JzWI9xC2HWy1aeSQIk2XZOVJhfViPRJixrQf8I2Cc1o4pj/kq9GcyKjajWNFntaxJEiQP8GNWRMdTHwhrt+F3p15aaWacxAtIpPQnI2Namyem8wJnnHJBI8IkMdkNtmBkewCkJi4kE0vRy1eWFb/AbDqDlp0s+n8A6AYdw5a5pcDQjOJQLQIwISad9bU/4vcIQzn1LKYcNp+ujQtx2rfiCD9x7TIfIJmbFQ4fCytgjPXD4hja1vQIjnI1qXarloa9+sEUzLDqNvMn2r/sNm2ycE0cSFg/GzDvw+KXGthqnokUGLAB+j08xL7++da0uIY9cuVpxGdgUUPeZkHjVVVX/LBfrpO67QPzVlnPWUrc0bTkovkktV2ACsPamlquTJX+z22fAvmkSPbUIvaCgw+W+cGWnyTyufVx+IMxmRfNLpHb/VJD2OQy0grgsBoCrcGC6UM9R2xEhD0XD8dUiU7fvmIkMw
 HexHak2X
 2qdVwwB8JTurcSFd34TyvSeUblXiVwLU+f9XzwDScKnF42a7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: sanity check constant bounds when clamping

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-sanity-check-constant-bounds-when-clamping.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From linux-staging+bounces-34941-greg=kroah.com@lists.linux.dev Fri Oct 17 11:08:22 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:04:55 +0000
Subject: minmax: sanity check constant bounds when clamping
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Message-ID: <20251017090519.46992-4-farbere@amazon.com>

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 5efcecd9a3b18078d3398b359a84c83f549e22cf ]

The clamp family of functions only makes sense if hi>=lo.  If hi and lo
are compile-time constants, then raise a build error.  Doing so has
already caught buggy code.  This also introduces the infrastructure to
improve the clamping function in subsequent commits.

[akpm@linux-foundation.org: coding-style cleanups]
[akpm@linux-foundation.org: s@&&\@&& \@]
Link: https://lkml.kernel.org/r/20220926133435.1333846-1-Jason@zx2c4.com
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -37,6 +37,28 @@
 		__cmp(x, y, op), \
 		__cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
 
+#define __clamp(val, lo, hi)	\
+	__cmp(__cmp(val, lo, >), hi, <)
+
+#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({	\
+		typeof(val) unique_val = (val);				\
+		typeof(lo) unique_lo = (lo);				\
+		typeof(hi) unique_hi = (hi);				\
+		__clamp(unique_val, unique_lo, unique_hi); })
+
+#define __clamp_input_check(lo, hi)					\
+        (BUILD_BUG_ON_ZERO(__builtin_choose_expr(			\
+                __is_constexpr((lo) > (hi)), (lo) > (hi), false)))
+
+#define __careful_clamp(val, lo, hi) ({					\
+	__clamp_input_check(lo, hi) +					\
+	__builtin_choose_expr(__typecheck(val, lo) && __typecheck(val, hi) && \
+			      __typecheck(hi, lo) && __is_constexpr(val) && \
+			      __is_constexpr(lo) && __is_constexpr(hi),	\
+		__clamp(val, lo, hi),					\
+		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
+			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })
+
 /**
  * min - return minimum of two values of the same or compatible types
  * @x: first value
@@ -103,7 +125,7 @@
  * This macro does strict typechecking of @lo/@hi to make sure they are of the
  * same type as @val.  See the unnecessary pointer comparisons.
  */
-#define clamp(val, lo, hi) min((typeof(val))max(val, lo), hi)
+#define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
 
 /*
  * ..and if you can't take the strict
@@ -138,7 +160,7 @@
  * This macro does no typechecking and uses temporary variables of type
  * @type to make all the comparisons.
  */
-#define clamp_t(type, val, lo, hi) min_t(type, max_t(type, val, lo), hi)
+#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
 
 /**
  * clamp_val - return a value clamped to a given range using val's type


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

