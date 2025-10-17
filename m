Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EBCCCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1BCF8E0054; Fri, 17 Oct 2025 09:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC3D8E0006; Fri, 17 Oct 2025 09:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A94538E0054; Fri, 17 Oct 2025 09:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94DA28E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:48:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5ACDF11858E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:48:48 +0000 (UTC)
X-FDA: 84007736736.14.06E2144
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id BFFA5C0009
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:48:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=ZUiTpU27;
	spf=pass (imf28.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708926; a=rsa-sha256;
	cv=none;
	b=8Q+eb/h0agrQL+9PO2yrbmyG0JV/bevG0kGNizDwRY+QyA/nib9ubg6RBfnEgRH+4koYcY
	4LK+m5GwcAiitqDKd8cUYsi0goRR8wF4uGy8/rH4O1SfCNrMlUdSlb+tWYA4AniG+eM4I/
	shuANIHqDBQBT8OuiPTM1eOTZCy1EOM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=ZUiTpU27;
	spf=pass (imf28.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=LIfQAWc6iDxUrEKLw7kUhty1bGxVVMj2qynqDt7n1IE=;
	b=4tKNfuZQyxZMVjz939/zF2u1GpU2nikJ6JVNhMAqdvaMWWBIs4XA6tr6TlisDdgRqmtLm8
	73O3x4UPiNxc5TFK38FOlD8dKNvhYdlUTfYc5i2meL+/Ap1vOc5uy7MxDLHy99V6RPEkm5
	UPZbNIxQXnU7+p3VDlZLyAPW3DA8pkE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D91064367;
	Fri, 17 Oct 2025 13:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BA7C116D0;
	Fri, 17 Oct 2025 13:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708925;
	bh=10r9Xtz1rDNNvILUwyhaJv5e8XY9QMUCuk0X3ZFE0ok=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=ZUiTpU27mOB3KjcvoO0braTUaFH4ae5yNaSKeLT0nR1Ya//9fJCcTVe6EcRHp6Xe4
	 V+mr9MlnOz1AsaKy4RgcHmsmpF7LGkzbasqgw12Bcb+CvCd2ba7CmuHXwcVTq1KJEu
	 m47X1B6Y5tJKREw9hbVGvnHkMwTy4hbkls7NECgI=
Subject: Patch "minmax: avoid overly complicated constant expressions in VM code" has been added to the 5.10-stable tree
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
Date: Fri, 17 Oct 2025 15:48:28 +0200
In-Reply-To: <20251017090519.46992-14-farbere@amazon.com>
Message-ID: <2025101728-trickle-valid-0eb9@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Stat-Signature: uza9xwzhc4w8cy1oxrpfaod8e8591zbm
X-Rspamd-Queue-Id: BFFA5C0009
X-Rspamd-Server: rspam09
X-HE-Tag: 1760708926-849098
X-HE-Meta: U2FsdGVkX1/LKfnO+Q06mAEwbYu/dsfMu6d5v0s1MpnfgV8MFBBhhphrDVMSAyS3hGDJG5KHwhRprA2Nrx1ROMbQtPTL/JmXHRix7DqwIYbz0zXU3ps/dgu3M65KESYs14eDWfQepacBa4HMxmP3HBYV2CHrkFvYzB9qwA/zSnaOAYHKDv+xkYyVJTSrL03ZU27NeTFRzsqZ2549ysSbPzK9yWruzRocDaJAkmMUCca592XlgaTPJ5E3YqVoMQTLIo5XylB3gWCgqYxGN8qupzn+i8mBlC0lLFhJPIWS5RBf6qUx7nPwYpnN4Rcl3tDc5CoJSdoi0fgBoau/Ke9padORntkax0n0YTfCJZTU5agIdkSvYZDMkxeI7AQjE/nIZ1cthDBGfpiq134GKnejRDyYiW4oZFHp4JDhgqJaPhjzHArrUe6bTIF/9zriEZ0DcHEj2Kd4hE4z5Fzu7mmSIraFMBXxP5dHupT7BwGsBotE1evzvpmT3ovCzDLk8wm1K1Yp0jp87mu+AnnQAp172pvIwbrezlaqZLqNxx1mEXj7AATVBqBGjIEYovob7UzWUvt8a3D/GfwO/CUd+cbsmcZ2Cejbn37lbf8Nv2XyqM7hEn6kYjvBPYoVuapRPpE/H3gVuJna/6+4/1Y0Ny9anMAxzrQZheFl5Pc0fbGBskTtBpnZ4rR5fBncVo7X30nx/vYYdEng9ro6gyX1I6PmONYMTXW6YtemAuioKzHDCgbPKZz5OSRFukscIe1wJcnwasYedOMl7g7F+EFN/zH96cFz7D/RSZHGh61XQ4t6iLC/0Qlkb9TbB6kHgt/3gtA46/cePWJv5V5xq1HHzoZVFb8IUqCR8cPpQbcjrMtrfrA0MP+voGZjzswt1UDNxnWcgSixr/3OV87aEev1Xdh9hTqToUwGXC6iEeZdC+IznbOgguzzo4ZvwALhkcB3f5JjZSA8dWyX7NxoTZrZh0m
 JRiV8CLL
 DLuGMlSNTaHPH+JrkGa7zbnXdwjXT2Et2+QM4qCo5XM1IuuErx+3fPCARAVWYfmI3KrFuWDa/ZQj/ZyYkf5L5Y6JrkAgtGi6ic9L/T2RjCTtI+c3K3ZKYzTDp9Slsk3HdKfkNRIey1L2ZFrFM2EqQYwwmsKmlgpHdkr1wdUwGoakSYjLw08raPNZ3oXOLHe7jJbmcdMzPv3UsadWyrYYnyVqCETVzQDsnSkOIKRdBwDyIitX0kPgLrhIV/hcmTRgi7rcn5Z134khR4cm7M6Tadp42pKW1odlYkMgTrNkyrkYUBe0kVgh3TozLgssv0OROwggeAEPIxFQOIV3VDtEJxB9LVFxRgwY6a1qk69qdTX9KvxQ2lrgEi++0/KPa9Mhn5qYiWbiFDHGFIjiAtjx4zcu49SKaNzfspP4FPVJVDr5lL2RLYBF24U0X5LT+PAred1YimttxdZEwQ2zajO3oLDuPPnFvzFATJaUUqOjx0XQgTXX36HID/rwSsM4peczYag2ddDUsrA39IW0uiOkuqv+4VfQXjxLscCxjgiSX22NhDO6g+eLGH9ShTnmrPKKqMYCZY/lUwYBkkD4/ySoB38YBMbZ6qfERoGzZONN7p8IgIUoOj58hmtRFbRCGwMXnudrm41gA+SdohpddsyWtqA2iE4DSSJ2ZiMxfqVJrrTlVy84FpBKet/50jBz6ldXEGv/i20IxfbLwX34mN3c3+g0atnGW+CbnoRml1SD034EiJFWsaLcl2QjlVLmaZeA095x+Kjw0QoSkAbq93nV71lWK/9wyfDyb1fHb7LTm6yxm/sfsz0UKyaKPodrPKLIIkA958mALt09lVARZJhFJ9CvnJKpTYKxBJweyH8b0jmGFkakMW+dPmKGSP1mVrEEB47P4hWd9xWo4PjPr+Kez4yRsfhsBqZWaRV0yAKybLZuiCqEq8L6oN1Uu7eDZ4nk99kuun37IvzXwFeaXs6g3l5dtmUUz
 iAIqv/sa
 sj9slDRlX/bex6DhybtWCJKE7lG1MTrezyjkA/3/Ooz7qaNmE/6PkgfsrOjCJ5bWKA2yBceAY9oinvOgCgnsnjI183pTFpJ5Qt0Z/bIRfaWNUQZzgWaR7VULKeT51GeYLql4iOZNqC1PBNVbz0OCI1A4l5aOCsXPLrMCGNqofJaNfqQo30X0xdJSbBiSy5MmmhpTfn/Hd0PH3eKWPHgJav9SvYpff04gQoykp6WsdDLZ5y/ATSWeANvQFlcmqjS7XTKJJMq/XiHrfnDpnXUC1wuT/MhaB7dTeVo1NqRmQTSJtwNLdMiLMFrvt5EjeD0bjjAToQa2x33VDSSbhUp/CM/6nv4+KNa326LasDOuLxTiAo3ox1uIizMiZ/99zWStnHpRxXlIp0nVwIMgIhp2VpSfkHgKBml4KaTEcfjmPCERXWZ7enQ+xYEhNWY4RWPkHlBtsXFV+gShivLIyMx7VolL5tuslp57kyR+I80wAsRTHlhhC3u87MKoH8nGlOvXK+0eLJTw4J2NW8mZT8xiXsmEQNWF7ZeYapzXm0rBwo7/o22Y292pWbupxZd/unTwQ5KkJ8Jgk7XURkV0kuDGoGBXqxCMtWmzqCXeSa02bM56MpS+mLEnN/QncVsG8N3dAtxWesRLaHIurkOYgBL3q/GOdWYOSGB+EqlWfU5RkIHhR0gYaL9U5lrCE3XaisP9CKRubG3fKD1yOaKUs26wNBvewvw6NrMjjtOvM06NtsbTFmUeYloVzx5/sIvq3nJSPjneGcd43MhHaAsRTbf7hHIbQaIWJUU4MaAaxxGBuw4mw6Gt1v/ZXjjcRc6nYbePsjM+O124+oSKu9yh4JLwAehNZVlrRryiwpDLk6brMMasx5yZAPthVvW9WglMajJ33eA8lsEfGoadCUyjRaC5B1Dhnu6kYn0mTO5QsTr1SgM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: avoid overly complicated constant expressions in VM code

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:09:55 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:05:05 +0000
Subject: minmax: avoid overly complicated constant expressions in VM code
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Laight <David.Laight@aculab.com>
Message-ID: <20251017090519.46992-14-farbere@amazon.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 3a7e02c040b130b5545e4b115aada7bacd80a2b6 ]

The minmax infrastructure is overkill for simple constants, and can
cause huge expansions because those simple constants are then used by
other things.

For example, 'pageblock_order' is a core VM constant, but because it was
implemented using 'min_t()' and all the type-checking that involves, it
actually expanded to something like 2.5kB of preprocessor noise.

And when that simple constant was then used inside other expansions:

  #define pageblock_nr_pages      (1UL << pageblock_order)
  #define pageblock_start_pfn(pfn)  ALIGN_DOWN((pfn), pageblock_nr_pages)

and we then use that inside a 'max()' macro:

	case ISOLATE_SUCCESS:
		update_cached = false;
		last_migrated_pfn = max(cc->zone->zone_start_pfn,
			pageblock_start_pfn(cc->migrate_pfn - 1));

the end result was that one statement expanding to 253kB in size.

There are probably other cases of this, but this one case certainly
stood out.

I've added 'MIN_T()' and 'MAX_T()' macros for this kind of "core simple
constant with specific type" use.  These macros skip the type checking,
and as such need to be very sparingly used only for obvious cases that
have active issues like this.

Reported-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Link: https://lore.kernel.org/all/36aa2cad-1db1-4abf-8dd2-fb20484aabc3@lucifer.local/
Cc: David Laight <David.Laight@aculab.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -270,4 +270,11 @@ static inline bool in_range32(u32 val, u
 #define swap(a, b) \
 	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
+/*
+ * Use these carefully: no type checking, and uses the arguments
+ * multiple times. Use for obvious constants only.
+ */
+#define MIN_T(type,a,b) __cmp(min,(type)(a),(type)(b))
+#define MAX_T(type,a,b) __cmp(max,(type)(a),(type)(b))
+
 #endif	/* _LINUX_MINMAX_H */


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

