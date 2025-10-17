Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3081CCD19F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9198E0083; Fri, 17 Oct 2025 09:48:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0618E0006; Fri, 17 Oct 2025 09:48:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B6668E0083; Fri, 17 Oct 2025 09:48:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27B1D8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:48:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4B441DB6EA
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:48:52 +0000 (UTC)
X-FDA: 84007736904.29.799A0A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 07FCCC000D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:48:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=Z5nIxx93;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf10.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=9Et3HCSP+qh8a8IOTreTotKrK7b8dHlpH2Lb8ok8esA=;
	b=iGu6HgUXJi/DWrC19mD0WrVH8P40QfyGmo6UfbcHgxy2DLYLzfEyvxURT1YMIbSqAp+v8B
	gZ2ATbOZrLdm3w7bIY8blXu2wgTBH7K1x2LuwJCjMcldZzZr3/yZPLmiwiJkEmEp3tPGYY
	gWctLKOt1VPOcN8DyyoBxuJ89W/I5ls=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=Z5nIxx93;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf10.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708931; a=rsa-sha256;
	cv=none;
	b=puURGVUtG/Kr0BujDevF0q5vgXrG6Q8h4oMK9Qadk1lDo4GtvLA3j7I8NCVGnLLOIy6YZt
	dZypqdWvKA+KCC1ahr4DMXF8ioeiJEmYyVnHvTky6pq1ysBWUAE5En/4XGVxdzwTnyyJrf
	3LSCOXo2SyoyUTHQPzPsT3WR1NIZ8OM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F2B47459E6;
	Fri, 17 Oct 2025 13:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5BFC19423;
	Fri, 17 Oct 2025 13:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708929;
	bh=vRGuHNumAUfIqaURCYuz6rvAlQsqOn3bv4UFK3IYz3o=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=Z5nIxx93UgZvWE0vQJsBIaIGcMbEltea/kMZxJNu3AXT/NUYSOF1DkXcvP2YFy+43
	 YVSoDpsyIx41/DTScrzKGsRYMeQ5zA56hQi3Bb7jKSROVp5HcxfFriISljRCwaVMmd
	 Izh3TY7OSP4SNAAhfSSW16gMUIdexEdl8ipatBl0=
Subject: Patch "minmax: add in_range() macro" has been added to the 5.10-stable tree
To: 20230206140639.538867-5-fengwei.yin@intel.com,
	David.Laight@ACULAB.COM, Jason@zx2c4.com, adilger.kernel@dilger.ca,
	agk@redhat.com, airlied@linux.ie, akpm@linux-foundation.org,
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
	jejb@linux.ibm.co, m@kvack.org, jmaloy@redhat.com,
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
	sakari.ailus@linux.int, el.com@kvack.org, sashal@kernel.org,
	sean@poorly.run, sergey.senozhatsky@gmail.com, snitzer@redhat.com,
	sunpeng.li@amd.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	tytso@mit.edu, tzimmermann@suse.de, willy@infradead.org,
	x86@kernel.org, xiang@kernel.org, ying.xue@windriver.com,
	yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 15:48:28 +0200
In-Reply-To: <20251017090519.46992-6-farbere@amazon.com>
Message-ID: <2025101727-agile-tinwork-5c96@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Rspamd-Queue-Id: 07FCCC000D
X-Rspamd-Server: rspam03
X-Stat-Signature: aqcpa1y4b93sgi93dwcsc1daemxs3adu
X-HE-Tag: 1760708930-384025
X-HE-Meta: U2FsdGVkX1/RfVQQYvRl3LLPmprqbS0rozMcWrjODBkTCZm3z1R5TLYCxuWTrFtkc6yW7wTazaQ8v9ZTQ+DBfHF8wqJoJsTNbkPqcAwoxzJWj6qzNSxA2ToQAxWTqV8sJuzLPj9O4T0TWTaZ2kW+lJPTN1zYSMnecmWtqvL1/I6XLua8wTELfi/Fm3sEwCrzxCFZdj6S1ItunqSXToH4dPoA66gG6mtEq1f183U2J0Hkf17ylIe7Ed9BIlf0nFDlzHdjmPhjm3OF1B64nNca9kxB4/rDq9Bt0ytO08cEc1TWSWrqXTYB/hQbnPPCW71sydYVO51mqFQjGwE7RMvb5/hZtP64GWQVczbtTyJg7re6RAC73RVZ7/X1L1WurI0H9aD4adC5KehU1N8LgkqIVdW3gHd0MqhsldpSsw6StM6mTNZ2UTq1d6tiL3gpWY8djDF3FLSn0vv5iMEnfSNHAeOddYN4oOnqSHs+A6SXDBrA20bVT+Vi6Psg/vETf9GvDUo6up8tRKKeuvHhItr8XAmMY0mF/rEKzvaeu0REGsEpFUXqotuXfalBzU4ExNd5fEYUp4ZCSHWhvCFrPSBFAApxq+meeIB9JxgR80Y5qOQ8FjTldh6IlfGL1+EZszGWTakuJ4GsjN6kQKO6Foi3jAPSIAiAP3+jmbJygow0Y0ct61WvhvDGpnENL2HlacFIaC+3ikbZwXfFWbXXiQ95PKuK5DWI/Da5JPWS/jTYWMC9akKbuAscnxcsQQdVjaW+RkEMIU67qp1RQHDblHIpzMm5CUub7M8OpEC/EcvDP1wlD4aZlcuR2zm53kYkBZ7DDaA5uj2gSCM13vaONr909AegSWJY+SDR4yIc0m1SMq2ecdkpL2FNffNpGeVbjB3PjNNocZYdMm+hINXMPzsuTxLiVfWDEdOb31PfnQRHtM2L45q3BnPbxZk8u1kkmwSwD7zYGlZ8vIzXsrT+9v/
 u0tZUcfq
 2/k143wHUCxDzWw/BBXnfx+wnQrR89KNTwrrOxDF7eJvh00SJBHBITXa1fUdGPqdK5ZHJQyG5tB74+sz6zllfWbLT7KL1RFex+C318uAUg7Bwdc+QZY0mCFi4H6y6bi22la6pogN6OY3u1MeO99p/K355UeCtPeWkbneIf6xhc/I2Fyjq86ftGPrLtc7Wp2qVbCyaR1PP10C7m5WJSd9KpqnSrkM29P8licFHsMvfa9JmlLh9yBtSatlo5DWigNsmlzy2NqMjNq4Yn31YKhOpQVIMlDNl+DCM/27LDOt9jDrSUtwrg9CnrJpKZTjV3iOe9lvBOpMIeJZsBQTqnRTRESH1XeO+ydXrLlrbrHCNzh+7fLwk4f5KTlwK4NuS0yeqtEoR3R9gd7osy9cbH2EKspbbpmD3EqfduabEc0s7IBIabxc4yCfPComPKf5CXy8ifkeynxc8FDK6LKJVpMOt5RZQv/ytQQjFRO0+PGITwO85QBS2OE6rmgjQ637ZGJR6/QGrPYVTJ6ec9wP5Z4EF3PsRdxvAXk9LOcdCocH2yhQlwZJ5XnboXHv/I7v7LT6x6zRB3+xykIs736B02IDjw2NHn85JWhe4lLxn2F+pZ1ordcOPc22dLRP2bPi4TrG/K6T28Z+uRfdNKRXNbwHB3bXwpIoHAq2K8LgFQCOEpvhX1jknaooPW2BTsRMeZZSYHyRAo6DAs1NSjrWoTVKPXDybFoDhOqUH/3IWLRuzLoOZPZLUZVDj/PT0Hne8BJ1qeI0a3i1TAMrCPkiTw4j5VQ9PSoBCgwGArokJcVpnzea5WnUq4wXdYSU4gy+u1LoPVY2LPiG3o2666pXWpzA8YsLFsOBdBnknYgBKLajXG0gly6UN70OZwxPijccT6rhGdnrtGv6LVeeHJcCXn86MaLJDBgjMLw4EpdFGV0qqirfVz79h2jaYeDkwgLDA8bUFoqnWLjlGsgS4P5gAVu4B0isxuMZe
 IcVWS5Ak
 +QsNVrK61WkpeL4qfWxtcOxmmODkMGBb8MCXurXne/4cR6St4/hBJXiKAasfL1kboaFJfwpcpe4d+T/aWg3KfX5Ai1cSAYhR3mSdXkuOJco1DCKEMVEs2DGTcH3QubwCL5OiPyYZUUzg8dPQQM3sXBAowVg7EOm/jldPC5rWxoZvTBnvzA4IJ2qWSuaWmQrOTi7pvL7CWJpwi59/e9QZmVgO4jJrcUttQUdbTzHlnR5bAbMB4Ms8pjoRIHeZzfvEwVPAIkpV1y0F3ZbNDi3iWw7PxubKNsPS12eSHVuDIwKzkUzITBXEtxFARAuRXLBmMJK9gGJ9iLlroklQ+v0bw9i6mnbLiUrhQ3vPQQHaHaO0kSLpxsO9wbuC38yrmbUos9VZdAoGnlXviDjPTiTfpa+0kk/02aMmJCuEI57NqySPQKSZVlQ8CunQm48j4Grh0EZ48pWXoER5qteMRp71jdpH0U+WMGgIZxJDSFd3fyScFXrsyubKlHVRhxkrwoLBEkXcIyneC7lCJ/YOb9OOfwMngwlCUD6v09+ZJs3rsEOspVF40cSGaQP/jVTPAqcv6Dz57+QbOuzeDCPWzXnzPiveX/M5FOVNkyfOXCHNBZlbDaxhr0ZkHfYMwfg92G5+mWNVRYuTBU5bLUwNiwRyLWB36e/2CQTuVzLPo+5qF+hMpXwPY99sOiwqCg44HjOA1yZBqpAlEvTFuXKliw86zMDqicdaB3aHdhLm52v+JmD3W8b6IM7fnQJ16AwbTMVOfselBjiUmPKXqTyiu6v1kNRQ3umqx5h5pFewA7gK/O3ZuQgQbbUWAzvpWmSaKsf+hcWirJnOaNhQLkNDsINtsi2hk4QcfDLVRvRjczUfAT8vviuSQrY3vsueVJs57EoDBW2INrCq1jJJVZLL/xHplIlda6rUyNeOU9/I6IibPzVZfPenzhamn2pWSjGvlYy+v2tJm3VolZSTbgJSI8GdA2qU6nM6Y
 Xj+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: add in_range() macro

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-add-in_range-macro.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:07:27 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:04:57 +0000
Subject: minmax: add in_range() macro
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Message-ID: <20251017090519.46992-6-farbere@amazon.com>

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit f9bff0e31881d03badf191d3b0005839391f5f2b ]

Patch series "New page table range API", v6.

This patchset changes the API used by the MM to set up page table entries.
The four APIs are:

    set_ptes(mm, addr, ptep, pte, nr)
    update_mmu_cache_range(vma, addr, ptep, nr)
    flush_dcache_folio(folio)
    flush_icache_pages(vma, page, nr)

flush_dcache_folio() isn't technically new, but no architecture
implemented it, so I've done that for them.  The old APIs remain around
but are mostly implemented by calling the new interfaces.

The new APIs are based around setting up N page table entries at once.
The N entries belong to the same PMD, the same folio and the same VMA, so
ptep++ is a legitimate operation, and locking is taken care of for you.
Some architectures can do a better job of it than just a loop, but I have
hesitated to make too deep a change to architectures I don't understand
well.

One thing I have changed in every architecture is that PG_arch_1 is now a
per-folio bit instead of a per-page bit when used for dcache clean/dirty
tracking.  This was something that would have to happen eventually, and it
makes sense to do it now rather than iterate over every page involved in a
cache flush and figure out if it needs to happen.

The point of all this is better performance, and Fengwei Yin has measured
improvement on x86.  I suspect you'll see improvement on your architecture
too.  Try the new will-it-scale test mentioned here:
https://lore.kernel.org/linux-mm/20230206140639.538867-5-fengwei.yin@intel.com/
You'll need to run it on an XFS filesystem and have
CONFIG_TRANSPARENT_HUGEPAGE set.

This patchset is the basis for much of the anonymous large folio work
being done by Ryan, so it's received quite a lot of testing over the last
few months.

This patch (of 38):

Determine if a value lies within a range more efficiently (subtraction +
comparison vs two comparisons and an AND).  It also has useful (under some
circumstances) behaviour if the range exceeds the maximum value of the
type.  Convert all the conflicting definitions of in_range() within the
kernel; some can use the generic definition while others need their own
definition.

Link: https://lkml.kernel.org/r/20230802151406.3735276-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230802151406.3735276-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/pageattr.c                                     |    6 +-
 drivers/gpu/drm/arm/display/include/malidp_utils.h         |    2 
 drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c |   24 +++++------
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c                      |    6 --
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c            |   18 ++++----
 fs/btrfs/misc.h                                            |    2 
 fs/ext2/balloc.c                                           |    2 
 fs/ext4/ext4.h                                             |    2 
 fs/ufs/util.h                                              |    6 --
 include/linux/minmax.h                                     |   27 +++++++++++++
 lib/logic_pio.c                                            |    3 -
 net/netfilter/nf_nat_core.c                                |    6 +-
 net/tipc/core.h                                            |    2 
 net/tipc/link.c                                            |   10 ++--
 14 files changed, 61 insertions(+), 55 deletions(-)

--- a/arch/arm/mm/pageattr.c
+++ b/arch/arm/mm/pageattr.c
@@ -25,7 +25,7 @@ static int change_page_range(pte_t *ptep
 	return 0;
 }
 
-static bool in_range(unsigned long start, unsigned long size,
+static bool range_in_range(unsigned long start, unsigned long size,
 	unsigned long range_start, unsigned long range_end)
 {
 	return start >= range_start && start < range_end &&
@@ -46,8 +46,8 @@ static int change_memory_common(unsigned
 	if (!size)
 		return 0;
 
-	if (!in_range(start, size, MODULES_VADDR, MODULES_END) &&
-	    !in_range(start, size, VMALLOC_START, VMALLOC_END))
+	if (!range_in_range(start, size, MODULES_VADDR, MODULES_END) &&
+	    !range_in_range(start, size, VMALLOC_START, VMALLOC_END))
 		return -EINVAL;
 
 	data.set_mask = set_mask;
--- a/drivers/gpu/drm/arm/display/include/malidp_utils.h
+++ b/drivers/gpu/drm/arm/display/include/malidp_utils.h
@@ -35,7 +35,7 @@ static inline void set_range(struct mali
 	rg->end   = end;
 }
 
-static inline bool in_range(struct malidp_range *rg, u32 v)
+static inline bool malidp_in_range(struct malidp_range *rg, u32 v)
 {
 	return (v >= rg->start) && (v <= rg->end);
 }
--- a/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c
@@ -305,12 +305,12 @@ komeda_layer_check_cfg(struct komeda_lay
 	if (komeda_fb_check_src_coords(kfb, src_x, src_y, src_w, src_h))
 		return -EINVAL;
 
-	if (!in_range(&layer->hsize_in, src_w)) {
+	if (!malidp_in_range(&layer->hsize_in, src_w)) {
 		DRM_DEBUG_ATOMIC("invalidate src_w %d.\n", src_w);
 		return -EINVAL;
 	}
 
-	if (!in_range(&layer->vsize_in, src_h)) {
+	if (!malidp_in_range(&layer->vsize_in, src_h)) {
 		DRM_DEBUG_ATOMIC("invalidate src_h %d.\n", src_h);
 		return -EINVAL;
 	}
@@ -452,14 +452,14 @@ komeda_scaler_check_cfg(struct komeda_sc
 	hsize_out = dflow->out_w;
 	vsize_out = dflow->out_h;
 
-	if (!in_range(&scaler->hsize, hsize_in) ||
-	    !in_range(&scaler->hsize, hsize_out)) {
+	if (!malidp_in_range(&scaler->hsize, hsize_in) ||
+	    !malidp_in_range(&scaler->hsize, hsize_out)) {
 		DRM_DEBUG_ATOMIC("Invalid horizontal sizes");
 		return -EINVAL;
 	}
 
-	if (!in_range(&scaler->vsize, vsize_in) ||
-	    !in_range(&scaler->vsize, vsize_out)) {
+	if (!malidp_in_range(&scaler->vsize, vsize_in) ||
+	    !malidp_in_range(&scaler->vsize, vsize_out)) {
 		DRM_DEBUG_ATOMIC("Invalid vertical sizes");
 		return -EINVAL;
 	}
@@ -574,13 +574,13 @@ komeda_splitter_validate(struct komeda_s
 		return -EINVAL;
 	}
 
-	if (!in_range(&splitter->hsize, dflow->in_w)) {
+	if (!malidp_in_range(&splitter->hsize, dflow->in_w)) {
 		DRM_DEBUG_ATOMIC("split in_w:%d is out of the acceptable range.\n",
 				 dflow->in_w);
 		return -EINVAL;
 	}
 
-	if (!in_range(&splitter->vsize, dflow->in_h)) {
+	if (!malidp_in_range(&splitter->vsize, dflow->in_h)) {
 		DRM_DEBUG_ATOMIC("split in_h: %d exceeds the acceptable range.\n",
 				 dflow->in_h);
 		return -EINVAL;
@@ -624,13 +624,13 @@ komeda_merger_validate(struct komeda_mer
 		return -EINVAL;
 	}
 
-	if (!in_range(&merger->hsize_merged, output->out_w)) {
+	if (!malidp_in_range(&merger->hsize_merged, output->out_w)) {
 		DRM_DEBUG_ATOMIC("merged_w: %d is out of the accepted range.\n",
 				 output->out_w);
 		return -EINVAL;
 	}
 
-	if (!in_range(&merger->vsize_merged, output->out_h)) {
+	if (!malidp_in_range(&merger->vsize_merged, output->out_h)) {
 		DRM_DEBUG_ATOMIC("merged_h: %d is out of the accepted range.\n",
 				 output->out_h);
 		return -EINVAL;
@@ -866,8 +866,8 @@ void komeda_complete_data_flow_cfg(struc
 	 * input/output range.
 	 */
 	if (dflow->en_scaling && scaler)
-		dflow->en_split = !in_range(&scaler->hsize, dflow->in_w) ||
-				  !in_range(&scaler->hsize, dflow->out_w);
+		dflow->en_split = !malidp_in_range(&scaler->hsize, dflow->in_w) ||
+				  !malidp_in_range(&scaler->hsize, dflow->out_w);
 }
 
 static bool merger_is_available(struct komeda_pipeline *pipe,
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -657,12 +657,6 @@ struct block_header {
 	u32 data[];
 };
 
-/* this should be a general kernel helper */
-static int in_range(u32 addr, u32 start, u32 size)
-{
-	return addr >= start && addr < start + size;
-}
-
 static bool fw_block_mem(struct a6xx_gmu_bo *bo, const struct block_header *blk)
 {
 	if (!in_range(blk->addr, bo->iova, bo->size))
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2131,7 +2131,7 @@ static const struct ethtool_ops cxgb_eth
 	.set_link_ksettings = set_link_ksettings,
 };
 
-static int in_range(int val, int lo, int hi)
+static int cxgb_in_range(int val, int lo, int hi)
 {
 	return val < 0 || (val <= hi && val >= lo);
 }
@@ -2162,19 +2162,19 @@ static int cxgb_extension_ioctl(struct n
 			return -EINVAL;
 		if (t.qset_idx >= SGE_QSETS)
 			return -EINVAL;
-		if (!in_range(t.intr_lat, 0, M_NEWTIMER) ||
-		    !in_range(t.cong_thres, 0, 255) ||
-		    !in_range(t.txq_size[0], MIN_TXQ_ENTRIES,
+		if (!cxgb_in_range(t.intr_lat, 0, M_NEWTIMER) ||
+		    !cxgb_in_range(t.cong_thres, 0, 255) ||
+		    !cxgb_in_range(t.txq_size[0], MIN_TXQ_ENTRIES,
 			      MAX_TXQ_ENTRIES) ||
-		    !in_range(t.txq_size[1], MIN_TXQ_ENTRIES,
+		    !cxgb_in_range(t.txq_size[1], MIN_TXQ_ENTRIES,
 			      MAX_TXQ_ENTRIES) ||
-		    !in_range(t.txq_size[2], MIN_CTRL_TXQ_ENTRIES,
+		    !cxgb_in_range(t.txq_size[2], MIN_CTRL_TXQ_ENTRIES,
 			      MAX_CTRL_TXQ_ENTRIES) ||
-		    !in_range(t.fl_size[0], MIN_FL_ENTRIES,
+		    !cxgb_in_range(t.fl_size[0], MIN_FL_ENTRIES,
 			      MAX_RX_BUFFERS) ||
-		    !in_range(t.fl_size[1], MIN_FL_ENTRIES,
+		    !cxgb_in_range(t.fl_size[1], MIN_FL_ENTRIES,
 			      MAX_RX_JUMBO_BUFFERS) ||
-		    !in_range(t.rspq_size, MIN_RSPQ_ENTRIES,
+		    !cxgb_in_range(t.rspq_size, MIN_RSPQ_ENTRIES,
 			      MAX_RSPQ_ENTRIES))
 			return -EINVAL;
 
--- a/fs/btrfs/misc.h
+++ b/fs/btrfs/misc.h
@@ -8,8 +8,6 @@
 #include <asm/div64.h>
 #include <linux/rbtree.h>
 
-#define in_range(b, first, len) ((b) >= (first) && (b) < (first) + (len))
-
 static inline void cond_wake_up(struct wait_queue_head *wq)
 {
 	/*
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -36,8 +36,6 @@
  */
 
 
-#define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
-
 struct ext2_group_desc * ext2_get_group_desc(struct super_block * sb,
 					     unsigned int block_group,
 					     struct buffer_head ** bh)
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3659,8 +3659,6 @@ static inline void set_bitmap_uptodate(s
 	set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
 }
 
-#define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
-
 /* For ioend & aio unwritten conversion wait queues */
 #define EXT4_WQ_HASH_SZ		37
 #define ext4_ioend_wq(v)   (&ext4__ioend_wq[((unsigned long)(v)) %\
--- a/fs/ufs/util.h
+++ b/fs/ufs/util.h
@@ -11,12 +11,6 @@
 #include <linux/fs.h>
 #include "swab.h"
 
-
-/*
- * some useful macros
- */
-#define in_range(b,first,len)	((b)>=(first)&&(b)<(first)+(len))
-
 /*
  * functions used for retyping
  */
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -3,6 +3,7 @@
 #define _LINUX_MINMAX_H
 
 #include <linux/const.h>
+#include <linux/types.h>
 
 /*
  * min()/max()/clamp() macros must accomplish three things:
@@ -175,6 +176,32 @@
  */
 #define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
 
+static inline bool in_range64(u64 val, u64 start, u64 len)
+{
+	return (val - start) < len;
+}
+
+static inline bool in_range32(u32 val, u32 start, u32 len)
+{
+	return (val - start) < len;
+}
+
+/**
+ * in_range - Determine if a value lies within a range.
+ * @val: Value to test.
+ * @start: First value in range.
+ * @len: Number of values in range.
+ *
+ * This is more efficient than "if (start <= val && val < (start + len))".
+ * It also gives a different answer if @start + @len overflows the size of
+ * the type by a sufficient amount to encompass @val.  Decide for yourself
+ * which behaviour you want, or prove that start + len never overflow.
+ * Do not blindly replace one form with the other.
+ */
+#define in_range(val, start, len)					\
+	((sizeof(start) | sizeof(len) | sizeof(val)) <= sizeof(u32) ?	\
+		in_range32(val, start, len) : in_range64(val, start, len))
+
 /**
  * swap - swap values of @a and @b
  * @a: first value
--- a/lib/logic_pio.c
+++ b/lib/logic_pio.c
@@ -20,9 +20,6 @@
 static LIST_HEAD(io_range_list);
 static DEFINE_MUTEX(io_range_mutex);
 
-/* Consider a kernel general helper for this */
-#define in_range(b, first, len)        ((b) >= (first) && (b) < (first) + (len))
-
 /**
  * logic_pio_register_range - register logical PIO range for a host
  * @new_range: pointer to the IO range to be registered.
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -262,7 +262,7 @@ static bool l4proto_in_range(const struc
 /* If we source map this tuple so reply looks like reply_tuple, will
  * that meet the constraints of range.
  */
-static int in_range(const struct nf_conntrack_tuple *tuple,
+static int nf_in_range(const struct nf_conntrack_tuple *tuple,
 		    const struct nf_nat_range2 *range)
 {
 	/* If we are supposed to map IPs, then we must be in the
@@ -311,7 +311,7 @@ find_appropriate_src(struct net *net,
 				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 			result->dst = tuple->dst;
 
-			if (in_range(result, range))
+			if (nf_in_range(result, range))
 				return 1;
 		}
 	}
@@ -543,7 +543,7 @@ get_unique_tuple(struct nf_conntrack_tup
 	if (maniptype == NF_NAT_MANIP_SRC &&
 	    !(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
 		/* try the original tuple first */
-		if (in_range(orig_tuple, range)) {
+		if (nf_in_range(orig_tuple, range)) {
 			if (!nf_nat_used_tuple(orig_tuple, ct)) {
 				*tuple = *orig_tuple;
 				return;
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -199,7 +199,7 @@ static inline int less(u16 left, u16 rig
 	return less_eq(left, right) && (mod(right) != mod(left));
 }
 
-static inline int in_range(u16 val, u16 min, u16 max)
+static inline int tipc_in_range(u16 val, u16 min, u16 max)
 {
 	return !less(val, min) && !more(val, max);
 }
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1588,7 +1588,7 @@ next_gap_ack:
 					  last_ga->bgack_cnt);
 			}
 			/* Check against the last Gap ACK block */
-			if (in_range(seqno, start, end))
+			if (tipc_in_range(seqno, start, end))
 				continue;
 			/* Update/release the packet peer is acking */
 			bc_has_acked = true;
@@ -2216,12 +2216,12 @@ static int tipc_link_proto_rcv(struct ti
 		strncpy(if_name, data, TIPC_MAX_IF_NAME);
 
 		/* Update own tolerance if peer indicates a non-zero value */
-		if (in_range(peers_tol, TIPC_MIN_LINK_TOL, TIPC_MAX_LINK_TOL)) {
+		if (tipc_in_range(peers_tol, TIPC_MIN_LINK_TOL, TIPC_MAX_LINK_TOL)) {
 			l->tolerance = peers_tol;
 			l->bc_rcvlink->tolerance = peers_tol;
 		}
 		/* Update own priority if peer's priority is higher */
-		if (in_range(peers_prio, l->priority + 1, TIPC_MAX_LINK_PRI))
+		if (tipc_in_range(peers_prio, l->priority + 1, TIPC_MAX_LINK_PRI))
 			l->priority = peers_prio;
 
 		/* If peer is going down we want full re-establish cycle */
@@ -2264,13 +2264,13 @@ static int tipc_link_proto_rcv(struct ti
 		l->rcv_nxt_state = msg_seqno(hdr) + 1;
 
 		/* Update own tolerance if peer indicates a non-zero value */
-		if (in_range(peers_tol, TIPC_MIN_LINK_TOL, TIPC_MAX_LINK_TOL)) {
+		if (tipc_in_range(peers_tol, TIPC_MIN_LINK_TOL, TIPC_MAX_LINK_TOL)) {
 			l->tolerance = peers_tol;
 			l->bc_rcvlink->tolerance = peers_tol;
 		}
 		/* Update own prio if peer indicates a different value */
 		if ((peers_prio != l->priority) &&
-		    in_range(peers_prio, 1, TIPC_MAX_LINK_PRI)) {
+		    tipc_in_range(peers_prio, 1, TIPC_MAX_LINK_PRI)) {
 			l->priority = peers_prio;
 			rc = tipc_link_fsm_evt(l, LINK_FAILURE_EVT);
 		}


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

