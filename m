Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 311D8CCD19F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89A7F8E0087; Fri, 17 Oct 2025 09:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84A0E8E0006; Fri, 17 Oct 2025 09:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73FF48E0087; Fri, 17 Oct 2025 09:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1AB8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:49:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F164F1A01D8
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:08 +0000 (UTC)
X-FDA: 84007737576.07.9885949
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1EC3E40012
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=UsZdQ3N3;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=YDVsGftE6aJuwamkz4Ur/ANosowbY0ooFVtToKnljoc=;
	b=d2CZcAXIyXX6Nr7dXHQj/dwri4g4ODmuX3ObeqljIc2Y+CoBRl2pNYxghRwlfwuJQqbyxi
	AM3ueIcMca9/WpPmU1Br8SWAtehBD6klv6ANk7mDDKHfE8stdgBybtoyxL2ax1S+z7hNme
	fQrjF1m7Aa75QxamDUxgsGWs28qPE9M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=UsZdQ3N3;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708947; a=rsa-sha256;
	cv=none;
	b=xdA1yBdIzhw3vqVaLUwQ1d3CRnxgEnQvT402XmJQf+HPuFjlrAEm6CTrGiweZYnTmk4bKh
	USbARTbl0pKHFqOJ/2moRkbckiDheOneR1LpUkkBklNtzI6bsqLaOQP1t7Jcx1qBoVznqU
	wzfIEjE8jrL4O+O/juR2c9kggl5wIDI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C3894B40F;
	Fri, 17 Oct 2025 13:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38DDC16AAE;
	Fri, 17 Oct 2025 13:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708946;
	bh=lNulQj6Pf71EV1G9N3rtKDxmU4z4cUa0H7/cVUNj/bI=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=UsZdQ3N3g1HA9IRop9e0zSxN4roBsUzfuXh2lOF7Ls0u+zs8T+DbQ/PIbdvi3tAUB
	 QmRlkdqorz+9DT4OB5ssGlIv1gvHCWHSThGhzuH1HTR44BAshXSkft+F4USe5TvZ1M
	 r5d8OpcowDu70hyNjetpCQQo/K2qgth9vKzGMuhU=
Subject: Patch "minmax: clamp more efficiently by avoiding extra comparison" has been added to the 5.10-stable tree
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
In-Reply-To: <20251017090519.46992-5-farbere@amazon.com>
Message-ID: <2025101729-giddiness-scrubbed-89be@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: quzwko5dme9km9mpnsmcsm154bnc1zf8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1EC3E40012
X-HE-Tag: 1760708946-387782
X-HE-Meta: U2FsdGVkX1/+IFTCKwV4c0GCYeIva5TeMdXyIsGzrY7uO3m9qWtlxQMwC8jzbCAKgOhUziz02+sUjelzpT4y9PPSxHq14Nya1iAiIBl2BYDGI5J7qn0o2ozquXAPF0SMiYc7cS0yT8SPqbNZvJBJmZNSwUqXB/XMBkXq+OxfpSWpjkhDH20HM/nbwYE9kuBLVW+vTx0MO9ADrRISc7JzEQwDICklhmN92uyJ59KQRNfdXORFOY8OiwW81JiOheXqueYb73KmoFgnisP96+zB+Vx0faaf9qfk/Z1KpD0ltQ75rvZqdPfj4RlXN4kKOG2NkCtxk12+Cq4zD/e8q1NEbo0NbuWLZoU+TLBdie8lmOnQRWUNYIro98Rt7H89q2q8k5Dhkph/XnJ3VIqKl4LGlGCSFAOmEs/ZfE3gkgpKZoBiIN/WR8gvmWCQZ5gsC1AbAZFrYodxwx1FdNnQhe1lSoa/fj/BXodJJ0DtqVhta4GA61m3FGA6zn67pTqVk4KSUf1dU1hOBZ5HTfgCEiraH3ZNLZb0YM1HexOJDuCGqpLa/QfBbezi6/uX88rmJxTZFPZ19ROaAY5ztGmXckG95jsXgPQPCniO72T1UPvhzY+T39hYg/6qN0SkyV7lPq4LslivCMz5ZZGTiUYs4RpqT90GRAgMOypcMERyXZz219/QsBSIfGLsfK0coplyJynq3yxbZfUHRysPb1+xThLSg/Df+VyYCr3CEL/D9Szfxe15HuIM6e8M/wGwcR5qcmtogg99+Ub3UydiFMqHVtGAn7W31Hq5TJzzdBmYcdqvTf4TGPP4GTZi1epGN9oylSsKf/aCX27C7HkE58h8fin+sKan0U/RzNOWz0c2EgLnxrj2ApUYzzWPHgWHbtKYcaSDWVEuETGF+QO5KrIQQYoMK+/Y0/gZOVLVAQFai0UtzSA7NjK5IFgKiN/PPhKGsLIGSvzMSOqrF1ZYgenbvbE
 YiLdoEXf
 BxyBnSiBYe+Vi1UugHgsxSEiIFqyPuhrJm6w0jV5bBBIEDubVERrSF+LxvkpI8bQS/1czgG+epNJJdlDMMsp9odr3JlOmsp5op9W6E9qH6pMTciJnZIIBC6/WJUxOySesf0H0HKhV3SNKr6nYs/EsmxxH/FQloqVFPgzs0MJdSL/PaisBLSO2zNBjIZJUQv/OILU3iY82PYeisHmcDwepDtX/2A2Q/Yws45SzBpYGgb5xzQdwp/HZrZbzPHcmBKBxTTFz60/XU10diIvMk6yGptke1m3HoVf3k43+SzkG17AzpTIJUs9smO4G/0zpkdmoZ/fe7OHQtLUgf1XaopYw3uFQ74UHRLQbxgbhPLj4MK06PXMCK+B8CRdwIVgyQv1lMjo22IRHT4XaOkYfCZf3v2jbF3r+F9fYOvJtUPRVC9NbdDT1iDeFdoeO1OtEB2Y+3YFOl1wDixnW1VZ1eFHOHjH1cVsVEejkTAj+4mN1xsWv9/G5+wot08AmvObroTY6DMWD1tM37oVQtuHf3RZL9fxt5wkRQMMCRnqj9UtyRASnWhcHrI7fub9K/SCR+aWYM8Z0N3a5xmP40KUKHiixbsxTyitj454Ks1jUnLb1UCF409iT/rOZ2R93190XVd/IOZXmtV2KCH1ORGdA/i8f2kZgVkbsaJU6UZSDFp/sZy/9ERghIufKigQ3Ge3bNirIoX8gk8adfDt3XMyTkYzMKyfp3ENlMEpVsqRNQjYSgP/qnd4On104BYnZHE1k5cYuxu9yWvED63DRI94ZYLSyMw7Rb12wedhOBXVwJoDSS1bDGIWrhw/r6pAg3D+yBs0enLA3kAS9xKvTvshUBSqGzlc+j8lT4agsb6WCUmbI7o4lA69Wx4y08teKIBcC4mLjEDp/nvIi7EMo3x/ACHxmiP+tKBzOAgA44qMsw68bdXmV0JeNOyKJtG7tqL9m03lbmKRxaXKmmeUSgry64VGVlMDFTqkb
 BTH7QR7W
 0qUGKRgejL0hyOuhXaV7RwcRpr5c7MYdvdzKklFYQvjG7vpzqB3WgV/8lpdh5A6TvGdcMOzJhkf580MvoHLaKu+09pvlh6C5wqvNg6WJ0oBeio4cjQLdZYL045CWg2+4st99ZV4Q9aOAH+8LT7trkkVEyDdwXaZCpH4MpsW8IHlO2ZLSRBxPXZjiGNG9Obnmy3F01W0x19F9mt8oy+BH5u51QfV5iy4tKtq5IouKaVWYqLabVOgdi73HrY078Znpqz5PVZeQ/zFRcH09N5WwqTsoqS+Wv/dsXoQU7YWpJQyxUra3WwF5EEfsIua7i1feO1ddlTTqtZTwSKe8LLvJW1tuK1LUe1cPkBNXGprtnq+FEobaX7Dma/hm9rJVxDtT7x7XV5X5/Y6j2vqHOfjNJPQZwCHUJ23iNPSY/gfOg8y4cr+KBGfjY600qZNBh+WjIMZGyUocOXlPrDo48k5wTUG6niDZwVLjXNa+Gk0EEOQMw2iuED0+A/S3JO6L3/1q4OZIV1GjUN6qZveMdVgMm+5fE2uusGSdz1zYOfcETOxmMyi0aDjgtd4iO1iNEgGpbca0xzrSnytOXTqeGlVTFu26JAHEVTWv6rYhONC5g0pe10G2Uqv2SdY8VnIuY1Z0cLfhHllp09aGyfJevI3oDDheNwTNYsRvqEzbefPV1bq9tIETGxVnVzQLru9VXRnJjoaOfqEYN9y/sxHkrrU1RLTPr4NrP5nLQGaZqGUATDEE/04yRZ2LppUGLp1xioyR6XY4kPp5u25e9Aw3oyCcZ0Prqav7mKGWQIROQfWSwkVa/f2S7uqqPJC3oTYZB+ynE/t/NFRNx5UDBIctmiFXqd/VLn7qfbLOvFGHiMppQKBIa9/5dnAy8xxKWg20VIqyoKd7X4FTlpITIOxVLF2Ihb+8ZfdTDdgkYPVR0q2mmG9LtQ009OKpK2VC2N/JPo5mN7+1NnyaPZsWZJ+kuuSUqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: clamp more efficiently by avoiding extra comparison

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-clamp-more-efficiently-by-avoiding-extra-comparison.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:07:07 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:04:56 +0000
Subject: minmax: clamp more efficiently by avoiding extra comparison
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Message-ID: <20251017090519.46992-5-farbere@amazon.com>

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 2122e2a4efc2cd139474079e11939b6e07adfacd ]

Currently the clamp algorithm does:

    if (val > hi)
        val = hi;
    if (val < lo)
        val = lo;

But since hi > lo by definition, this can be made more efficient with:

    if (val > hi)
        val = hi;
    else if (val < lo)
        val = lo;

So fix up the clamp and clamp_t functions to do this, adding the same
argument checking as for min and min_t.

For simple cases, code generation on x86_64 and aarch64 stay about the
same:

    before:
            cmp     edi, edx
            mov     eax, esi
            cmova   edi, edx
            cmp     edi, esi
            cmovnb  eax, edi
            ret
    after:
            cmp     edi, esi
            mov     eax, edx
            cmovnb  esi, edi
            cmp     edi, edx
            cmovb   eax, esi
            ret

    before:
            cmp     w0, w2
            csel    w8, w0, w2, lo
            cmp     w8, w1
            csel    w0, w8, w1, hi
            ret
    after:
            cmp     w0, w1
            csel    w8, w0, w1, hi
            cmp     w0, w2
            csel    w0, w8, w2, lo
            ret

On MIPS64, however, code generation improves, by removing arithmetic in
the second branch:

    before:
            sltu    $3,$6,$4
            bne     $3,$0,.L2
            move    $2,$6

            move    $2,$4
    .L2:
            sltu    $3,$2,$5
            bnel    $3,$0,.L7
            move    $2,$5

    .L7:
            jr      $31
            nop
    after:
            sltu    $3,$4,$6
            beq     $3,$0,.L13
            move    $2,$6

            sltu    $3,$4,$5
            bne     $3,$0,.L12
            move    $2,$4

    .L13:
            jr      $31
            nop

    .L12:
            jr      $31
            move    $2,$5

For more complex cases with surrounding code, the effects are a bit
more complicated. For example, consider this simplified version of
timestamp_truncate() from fs/inode.c on x86_64:

    struct timespec64 timestamp_truncate(struct timespec64 t, struct inode *inode)
    {
        struct super_block *sb = inode->i_sb;
        unsigned int gran = sb->s_time_gran;

        t.tv_sec = clamp(t.tv_sec, sb->s_time_min, sb->s_time_max);
        if (t.tv_sec == sb->s_time_max || t.tv_sec == sb->s_time_min)
            t.tv_nsec = 0;
        return t;
    }

    before:
            mov     r8, rdx
            mov     rdx, rsi
            mov     rcx, QWORD PTR [r8]
            mov     rax, QWORD PTR [rcx+8]
            mov     rcx, QWORD PTR [rcx+16]
            cmp     rax, rdi
            mov     r8, rcx
            cmovge  rdi, rax
            cmp     rdi, rcx
            cmovle  r8, rdi
            cmp     rax, r8
            je      .L4
            cmp     rdi, rcx
            jge     .L4
            mov     rax, r8
            ret
    .L4:
            xor     edx, edx
            mov     rax, r8
            ret

    after:
            mov     rax, QWORD PTR [rdx]
            mov     rdx, QWORD PTR [rax+8]
            mov     rax, QWORD PTR [rax+16]
            cmp     rax, rdi
            jg      .L6
            mov     r8, rax
            xor     edx, edx
    .L2:
            mov     rax, r8
            ret
    .L6:
            cmp     rdx, rdi
            mov     r8, rdi
            cmovge  r8, rdx
            cmp     rax, r8
            je      .L4
            xor     eax, eax
            cmp     rdx, rdi
            cmovl   rax, rsi
            mov     rdx, rax
            mov     rax, r8
            ret
    .L4:
            xor     edx, edx
            jmp     .L2

In this case, we actually gain a branch, unfortunately, because the
compiler's replacement axioms no longer as cleanly apply.

So all and all, this change is a bit of a mixed bag.

Link: https://lkml.kernel.org/r/20220926133435.1333846-2-Jason@zx2c4.com
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -38,7 +38,7 @@
 		__cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
 
 #define __clamp(val, lo, hi)	\
-	__cmp(__cmp(val, lo, >), hi, <)
+	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
 #define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({	\
 		typeof(val) unique_val = (val);				\


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

