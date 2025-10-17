Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FB26CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B89448E0096; Fri, 17 Oct 2025 09:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5B888E0092; Fri, 17 Oct 2025 09:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6F9F8E0096; Fri, 17 Oct 2025 09:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 923598E0092
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:50:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 530511401C0
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:50:04 +0000 (UTC)
X-FDA: 84007739928.09.EACEB91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id B508D80011
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:50:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=OPOMEN0b;
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760709002; a=rsa-sha256;
	cv=none;
	b=nl/3OSUP11Qy/JbSwaAAUn271U7xprxK63n2f/qG8O2F8cfjwG7alfjw1jPSslsXeD76W3
	pWNLVJBJ/RHanK6ipSoPVHWLZfw5FudjpAmfMhwAk0QtXP/ZCKNJ3rm6odXsJdxhdI1z5F
	txyMdilfGwEuxdZ2NQkNgLe2VIMWjvQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=OPOMEN0b;
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760709002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=RWr1PhAD573prrkRjwGQ3Jy/zhWTXvTwUWT9MBS5gGk=;
	b=WQT/W8x6OzH7kZ87wd67n86Y4N6SIOW+9BW5cBlpxsJ6lpd8KvudG0JaUlNDWbWmXVHwq2
	WrVHYjvfJMtmB3TXUa6tbISkoK1wK5AhD6SErI6XK1k09iWt1ELKKJQbo12O8rCshoHqOU
	JUSVnXaPq0OTeRTmO9xQY7e9/9XQTag=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E7DE6437C;
	Fri, 17 Oct 2025 13:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C04C16AAE;
	Fri, 17 Oct 2025 13:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760709001;
	bh=NL7dABSp/BjY/3JVk9EFS1TS/JgPiCeXawD/KomCwxQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=OPOMEN0bFmMZRVAVuU3vckMVywx3bNfqwqiaHlRLo5GtxNOMHGUkdz1caWbd/cwBo
	 MJKqzL3n+9pZBvjuku51AcamCUKfRqZizOAiWKci0Rq7DLeNppLkUcKB6v7wOwNltd
	 +um6MdrrmsBIh3kKXRDmY22aCp/VDFbOR6jjt9KI=
Subject: Patch "minmax.h: reduce the #define expansion of min(), max() and clamp()" has been added to the 5.10-stable tree
To: David.Laight@ACULAB.COM, Jason@zx2c4.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@linux.ie,
	akpm@linux-foundation.org, alexander.deucher@amd.com,
	alexandre.torgue@st.com, amd-gfx@lists.freedesktop.org,
	andriy.shevchenko@linux.intel.com, anton.ivanov@cambridgegreys.com,
	arnd@kernel.org, artur.paszkiewicz@intel.com, axboe@kernel.dk,
	bp@alien8.de, brian.starkey@arm.com, bvanassche@acm.org,
	chao@kernel.org, christian.koenig@amd.com, clm@fb.com,
	coreteam@netfilter.org, dan.carpenter@linaro.org, daniel@ffwll.ch,
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
	jdike@addtoit.com, jejb@linux.ibm.com, jmaloy@redhat.com,
	joabreu@synopsys.com, josef@toxicpanda.com, kadlec@netfilter.org,
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
	mjguzik@gmail.com, mripard@kernel.org, nathan@kernel.org,
	ndesaulniers@google.com, ngupta@vflare.org, pablo@netfilter.org,
	pedro.falcato@gmail.com, peppe.cavallaro@st.com,
	peterz@infradead.org, pmladek@suse.com, qiuxu.zhuo@intel.com,
	rajur@chels.kvack.org, io.com@kvack.org, richard@nod.at,
	robdclark@gmail.com, rostedt@goodmis.org, rric@kernel.org,
	ruanjinjie@huawei.com, sakari.ailus@linux.intel.com,
	sashal@kernel.org, sean@poorly.run, sergey.senozhatsky@gmail.com,
	snitzer@redhat.com, sunpeng.li@amd.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	tytso@mit.edu, tzimmermann@suse.de, willy@infradead.org,
	x86@kernel.org, xiang@kernel.org, ying.xue@windriver.com,
	yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 15:48:33 +0200
In-Reply-To: <20251017090519.46992-24-farbere@amazon.com>
Message-ID: <2025101733-maimed-supplier-4765@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Stat-Signature: 4fs1b46qbtnzbi6sb96gkwrtzqy1gsxo
X-Rspamd-Queue-Id: B508D80011
X-Rspamd-Server: rspam09
X-HE-Tag: 1760709002-487730
X-HE-Meta: U2FsdGVkX18tRdcVb5Oywp4cNiRas8vJS4WI9/TjzI3T6WdZYWwBPAs1rUc3G9EJUBMfysuaGfAnOAAFMlKl3ZY4KqTMgfVvKBV612RH6+8HrHYiwqqqZRAOhDXjOJUsObQ9HC378vuyN3Gfd6UupsMlIPDnPShVSL4aalx4AbmU3RnX33X9J9iMI0jprPCMOjSL8+gTXuGq9S3Jb6D/e2nITl6gIfdAoC3ZXK50dXvYaU7ehy5cIxYRJTGdd253g3BvhrXI3OpIXa33neCfAeQAi52e5JJVClPBX9pZHBSz3QOiR3jlZ/qdktKeFIH5cKOuTzoo733JRTWV3KAyPvjJJYIY0C48hypxwB8aAeE+HRiPq2McYun9lgPFK7IlAMYG6pZHzcFbs+FMl2U+lr233YdvVZPlOVCFBsk2/RVPg1ltMKfSlOmg2bRO1BNAzbyZJ3FxN3/QD4iJSegTztUKyHyITKwmAmxxg8FB8bzBM9f57hoNCQ8g7jqsBiigJBFOvRLpy8XTAXzRHOBm16FD55a+blf0URqXUAj0vbey6IbaoGSRAjtTXw3VJascuw1kL+6PKqLfadNb+9MJBzYEOGGxwPGihDBlACAmUPSHVOaTN2K9YBC0nD1AwBWqAj7bce5SLByDa2ecB9UxV92Qe/ZDtlMMCs5Zbv2ghv9n4aSRKugyeaWl/4EfQX4G8oqxtOKMX1mL3wUK5wRte5Qk5ps8fg9k8PgiHVQ5dSBWkIPGTihrgHLRcWUfjTzwsSHIHA3Cjs5feJwWfkVOaUeVqhgeySmHvs61SZch+hPsQV1F+pP1SaY+UBfDGauLVlLumUs58sGx1aWE/AuvHnREwhMp76z5LIQXBUKdLQ5tFTEQgRhJPvl2kB7lgdU3M5y854DVFkrE3EQewmIP0txL3K8gKfQb1K7HfoFSlu6HCIt8eC3gw4zEJAkVUXlFFb9hc7Sd4D/Ol80opkv
 p1GuqIeD
 D5/H39GQa1qXW+JAhIaLckxF0tzKy99nsfAfVLjDcKXYlmzoXUFzxFXJQIE4WgS4FwWsh1CVPd/AUtcYC81jqbvkOIa2091I4mTbdMDp/LohShkewbucJgOZh5D/Gg/IPC5O6pWvja1ODNBHrGtHoOt/nUTvcMuVjfxghvufSjBpFcD3sjbcisM3mrodXrkXCjo0fWCjBKsi31emNN2UUOf4djtzXpq/ryixZeu0eHJwgLgRQyrbD2xBDznNci0GhPc5RASJnOkL7GkTbXORcqCUFnJvq+ajLTojRZEB3LZSqMCd4TPiA8qK8e3iK3IRugfmFAvBnl76JMpegrk8Uht9+gQDZdFALGqdVDGUpv9dsbcBGx0JqtHRUviavbR16cSHMZ6pq2OgJoiIGxEjxJSJ3o8+Kub+AQdQpHVg8wNtZGFE0eq957SuS0n9Rl8Rx/kmNeOvlaFotZcwtWnN4zKWojfwPovdfMU0b3pr9pXqMDrh6Jpln6L8+CM8+czTNzSwsQyOZdET/qO0CFp+9+aC7gnwzWLu2N5HgrTizfmEtwbpZE2edlSu6pc5Q8y8c3dMV/+Depcvvt7c4WN2Zzkh355sx3RsxYqC6NSbHFFFJ5RkMchevIauP8WT4sL2vuIuEJqqYBx9suLuMunqkLF5PtrbpAji17KoGlBW3F66/Bu+e+bkLGkCxssoqtGS4A9yo1KVowZqQ7CEock6YFNXctHcYnlj/p4v1mD2Krn3NIk2vOk4fDJ9iuueHUGesi834Zk1gcmofwIA4nhLMpcf8dTsNR8+b/AnPM6Xq+0RvX9YCFg2Z1LTYvJXA3sGEW56FCB8kgNSqL2Y+ZC7ayPkND3wiS+CzK9FGQ9JTkkiUFdwOcVf7J/MlKldDm+OJf0OXFusQbTozix2ajXfdG8hrmp8CWee2Ixlqm6blY5XHpibFRnUZt9j0DXDBbfOLArwgYDM6QWzuMXemozbdl7WIaqvg
 DdcMjC9P
 YpTNiqHDlm4PDc0j47Q2aSAFlRJgXHGjdzUvl+o+bSmswzS08fH5qak4hQRtT43GoHlLeTwgc7oBLGQWQ9zyD/YgTYczrqGdHO5RhhsxgZRjygDGHqhu6ds0CY1C6/t/6rzUQwWzTsTJYLieqTdS6TpPx75IwgDOhBGR4nandEhmGDT65ViKOlK8Dx4D63v+wWKTH/9urGDNZMNMpSlCc3ErbSPG09pLFzcHkLZqcdiqUeclolQw55EbKA3iVXrUD/aox4j90b6LB8Bzw8k2NmtFZB878qNycVVa1ztR1UtwCTTFXBlLcW5wXyzOrUq4s0e6019LqMGjYEAChgvTIYUghE2Vh8wmIiGYOHa1V7pv1KmYeQ4DdfLB/y+K2bcAZYA/uFWR/1q9JVVWYB7MMUPcWPhNwomLXMiMDsZOW3TL0TXHZEpfe8ZY8GfXRCeVoYQKpmy0ttgSh9410tcKyutR5Av6BWO9vSs1aEVvXmIR2bYf6tQ9FzOMykT5v/FIQ7CFLpYRnb15ht5/QuaBqII3GWcXIWZNptmBvwVALfItmA6dMnSg8m5cSN4RcLNk9k7BJlLqmOjFFnIYLUuM+whvCf1bFEsRDEcnQOGnP/BUTn65LLO1k8iaY5qpe2rwOKJILc9co9uB6/nwuClnKxCZoX6IBD99ZEUT5ulvBe0+fkTingexnEpkUwycYYBB/0pvj5i7CrSWrHwC5eLdfqY+0soSqo4XgwD+Ulpis2WaCq57WlECgntD/FvmbMCOntAuZPm7mnL/jGc65VtJ+58husZs+erjn2IwVAMRapOlO+PdBNKWZoz0e/u065YL7V4SqC/14TvLa3hXvktGE0EP9Z7iqjr+IJRxDfd+spAY61m2wZ1WlO43w3rOsoVF/YzECvrmdrcdlH2p4KSOyRb+2Tb5Dk7hhgXYNw50jePXHDBjRcSxtI43kZJGhKA5Xp7KGwyKWD6Yb9VCmhyzid0l1HWxn
 HfUT4+tq
 Blh0XnVPx0+bVgVrmnSahKXnGwp0FwwBOJRh1A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax.h: reduce the #define expansion of min(), max() and clamp()

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax.h-reduce-the-define-expansion-of-min-max-and-clamp.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:12:54 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:05:15 +0000
Subject: minmax.h: reduce the #define expansion of min(), max() and clamp()
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@linaro.org>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, Pedro Falcato <pedro.falcato@gmail.com>
Message-ID: <20251017090519.46992-24-farbere@amazon.com>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit b280bb27a9f7c91ddab730e1ad91a9c18a051f41 ]

Since the test for signed values being non-negative only relies on
__builtion_constant_p() (not is_constexpr()) it can use the 'ux' variable
instead of the caller supplied expression.  This means that the #define
parameters are only expanded twice.  Once in the code and once quoted in
the error message.

Link: https://lkml.kernel.org/r/051afc171806425da991908ed8688a98@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -46,10 +46,10 @@
  * comparison, and these expressions only need to be careful to not cause
  * warnings for pointer use.
  */
-#define __signed_type_use(x, ux) (2 + __is_nonneg(x, ux))
-#define __unsigned_type_use(x, ux) (1 + 2 * (sizeof(ux) < 4))
-#define __sign_use(x, ux) (is_signed_type(typeof(ux)) ? \
-	__signed_type_use(x, ux) : __unsigned_type_use(x, ux))
+#define __signed_type_use(ux) (2 + __is_nonneg(ux))
+#define __unsigned_type_use(ux) (1 + 2 * (sizeof(ux) < 4))
+#define __sign_use(ux) (is_signed_type(typeof(ux)) ? \
+	__signed_type_use(ux) : __unsigned_type_use(ux))
 
 /*
  * Check whether a signed value is always non-negative.
@@ -71,13 +71,13 @@
 #else
   #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
 #endif
-#define __is_nonneg(x, ux) statically_true((__signed_type(ux))(x) >= 0)
+#define __is_nonneg(ux) statically_true((__signed_type(ux))(ux) >= 0)
 
-#define __types_ok(x, y, ux, uy) \
-	(__sign_use(x, ux) & __sign_use(y, uy))
+#define __types_ok(ux, uy) \
+	(__sign_use(ux) & __sign_use(uy))
 
-#define __types_ok3(x, y, z, ux, uy, uz) \
-	(__sign_use(x, ux) & __sign_use(y, uy) & __sign_use(z, uz))
+#define __types_ok3(ux, uy, uz) \
+	(__sign_use(ux) & __sign_use(uy) & __sign_use(uz))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -92,7 +92,7 @@
 
 #define __careful_cmp_once(op, x, y, ux, uy) ({		\
 	__auto_type ux = (x); __auto_type uy = (y);	\
-	BUILD_BUG_ON_MSG(!__types_ok(x, y, ux, uy),	\
+	BUILD_BUG_ON_MSG(!__types_ok(ux, uy),		\
 		#op"("#x", "#y") signedness error");	\
 	__cmp(op, ux, uy); })
 
@@ -109,7 +109,7 @@
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	BUILD_BUG_ON_MSG(!__types_ok3(val, lo, hi, uval, ulo, uhi),		\
+	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
@@ -149,7 +149,7 @@
 
 #define __careful_op3(op, x, y, z, ux, uy, uz) ({			\
 	__auto_type ux = (x); __auto_type uy = (y);__auto_type uz = (z);\
-	BUILD_BUG_ON_MSG(!__types_ok3(x, y, z, ux, uy, uz),		\
+	BUILD_BUG_ON_MSG(!__types_ok3(ux, uy, uz),			\
 		#op"3("#x", "#y", "#z") signedness error");		\
 	__cmp(op, ux, __cmp(op, uy, uz)); })
 


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

