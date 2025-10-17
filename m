Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77AF8CCD19F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2DD18E0088; Fri, 17 Oct 2025 09:49:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05908E0006; Fri, 17 Oct 2025 09:49:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1BD58E0088; Fri, 17 Oct 2025 09:49:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B02358E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:49:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83E9B1DA6D5
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:12 +0000 (UTC)
X-FDA: 84007737744.23.C48A577
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8B646180006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=2GmGpWKa;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=c+/ax8IVm8HQITY/oOf9lQaTpZiFmRjyNkKKSjWTGA4=;
	b=sZYXajLMiZtByNvA7KexDLW35irzwWNHuphWJK2efUwZhHt5tCitmUnJ2k4sdHH0PaOqI+
	8PiiTB5iaiJ3FhPJKyy9zTcdBywsBqESJqQa07uE9cIuTr+Ttmz4jAkoay5hJ5vPJKYYTV
	fFqBYeNl5FOMxGrr/HCNNnZKBJzwfoA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=2GmGpWKa;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708950; a=rsa-sha256;
	cv=none;
	b=3lQFxvG5Sr9Rsjubt+AU6PNecwOm/3PFlpgVL8KC3VmS1JBIbWR5in5kilVnSTYHlIRlSD
	xQJMdFAl1L7QS2ztHpZ7MC6E+kLTOaVgexffPBvmp5fr8mn0KRK/tm/qb/ES07HDocjavs
	vjLMyu2k6Sam5Cck1A0oEsvi4AfHm0I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 940574B42F;
	Fri, 17 Oct 2025 13:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CBEC116B1;
	Fri, 17 Oct 2025 13:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708949;
	bh=tVTvontwEkFnFaSP/Yd1+iVEaBo4mmfNXkjW+7MHkWU=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=2GmGpWKaqj/TN7DoK7ta/xAO7I1YRna6yYzc3iy3XjOLB2hT9uJ3ImcSAXQamVbBz
	 gBSVRKLog00GGi8y38I3rNXrLd83rOf3KpXiLIOhIGD4iBUDIvP+hBf5g2UE68sm0J
	 NnghUJUow81W4vtjLN66ctS2fcIshMbdy0oqztKU=
Subject: Patch "minmax: fix up min3() and max3() too" has been added to the 5.10-stable tree
To: David.Laight@ACULAB.COM, David.Laight@aculab.com,
	Jason@zx2c4.com, adilger.kernel@dilger.ca, agk@redhat.com,
	airlied@linux.ie, akpm@linux-foundation.org,
	alexander.deucher@amd.com, alexandre.torgue@st.com,
	amd-gfx@lists.freedesktop.org, andriy.shevchenko@linux.intel.com,
	anton.ivanov@cambridgegreys.com, arnd@kernel.org,
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
	jejb@linux.ibm.com, jmal@kvack.org, oy@redhat.com,
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
	sakari.ailus@linux.intel.com, sashal@kernel.org, sean@poorly.run,
	sergey.senozhatsky@gmail.com, snitzer@redhat.com, sunpeng.li@amd.com,
	tglx@linutronix.de, tipc-discussion@lists.sourceforge.net,
	tony.luck@intel.com, torvalds@linux-foundation.org, tytso@mit.edu,
	tzimmermann@suse.de, willy@infradead.org, x86@kernel.org,
	xiang@kernel.org, ying.xue@windriver.com, yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 15:48:30 +0200
In-Reply-To: <20251017090519.46992-21-farbere@amazon.com>
Message-ID: <2025101730-wannabe-kilowatt-1f94@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B646180006
X-Rspamd-Server: rspam03
X-Stat-Signature: ih1x771ajqadfumqya9r3npwxgezesfo
X-HE-Tag: 1760708950-966391
X-HE-Meta: U2FsdGVkX1+pGySgZ19ChhCeEukyU/yrUERQjlD1jfqb5Cv3DHIVaEqlNH0fkzVWNWkBjS0hFdvGncnuRlWcMQWN2H0zp2v5Mf3tISFkxjPvZOA/P5DJT307c8pc0XseoJAiIglPOHwWZ6gT2K5gi+jeUlNmIYy3kPPAuvv/LMdDFfSjkbeUkO57Ids4OIq/n5uFmDTv5CXgGo6GAFNlcyNKIFnD7sAU/dsOyfAkqv7neCbDxxirKo9THKg6EN/MxI0hnNnA0Dk9qeEg9Jtaa7JTU3ZAGF9zCEYFrOmLMMWj8Nq4SlQIYpE2IAhumBZumwsY9qceJTrOVDc9N0XH0NHDWR8PizvH9UJSXSPRWSSKELflK8bUq9BCx3rRLgHUiepUex3JFd7p478SVkzNImNq3cyAPGkt7BT0dZVzcf++gUoPdnhz7KSy14O6eCeNn8gJTrYfPwKA7wpB/r39Se0+6bBcWJMACs/jO2l+pYTJpUiSYg9DZLbazvHSIU+neimLtOcKYQEl7v0GHfInNsxM00nze9LEQg44g14dYGEyJTRA10iltRl4rgGZa+Lj3zioQuHjlKAtJZ6d3zfAqeFSKayMpFXtwgZvIL1QRBB8JHrn+fBNhnCETOQZF/rDoUGixtrO/F/Diti8Ao/tHBE6EXXWyA/G1mtI0JELaM5kpibd4JHUNWP2ciKRU4MsITAEqOw8OVn5Qr+jtjGLaJo+h3ODMajXlakzhJRo0ccjyFJprYrw7zoq0jmSMfaEUZWHxTgpXXJ90e3xCdASz7PXQXInzr4jWv5PB+xr1GFb+Th02Tg4VETFZH1Axv3G9bOGUqPB8v6qUf5k9c2PnSZTzEibBY4XzKObaj1zfqD2TQHQ6Hr5ecWxnySAtL2NvXF/RuCmVSxFpGxWOQQyIVEn/BIo33B9MgkjQVdinfG/B32qACpoVe5Ub9til11byfAG/HZZFoGBiCf1h40
 Jg7xXOgT
 txicgg5DelqlVnm8iqN8t6bkMyfNcQEP9ahek1+gvJYmx6sHiy7kEgXaB73jKt+kre4E8TP3JnWsL4jmNAFvnf49Jyy03W5ANqM4qa/TtpbLywJi2Rx02Cc0rp34h5jW17HDZ7s0GQd9BVVbzvtSeqbAZdeCrc4egNhY2flafF2lPi+aaFl0p5UD+wLKLKMAkFzFiDGQt/ISCWaF+izmWcPW/wlNJfqCnxsJ22q2bEbjHhpHKwnqa7QmHkM6d+F/t0uDz+q5vjlhLuLCisMsoht+e2F03p2qpQddfWUBQTjSyr6wYpt2fILwqiNo+1ajmr1OlfVCdcnRzH/1RbRwZc+le1rHxHMQLAQFUk75Rle6Eo/t2tdgzsBZLpqc/HbZDCGUYGbHc7A+uJN11GKlBz7rtCYFSXEhy8KBZax0G/5d5Ik8+b+mht/v9eLfeIAMwRA4XqYar6YRLglHZObG65u5iql7CPwtnpcEZB8XPnSJXIbb++XcWCJ0SwfOR4n23Q7Pb4ot77CsWx+N9UrGkSYxWKHZTJDwiOdakb4pEnDXbwhyo4ANF8+ACGcjjHJxrzatOntveINFzN2QRM6ft3Gu+74UXNXtpKZzFFM9f6NBx/G4IzKPLlSsR0ed8zXC67bqnnOGyihEDMOvjpMyzvMSM0IQLz+PdTUoMvqP87/UUcZS9uh1cRt6aoPVZPiaCUm/8+WkTunkwtqDyNE2XB8ULRd4qTmjXfs3IRVGtsc2rsI3Yc9355M4omjWBp+cDDfR+iAwQDJgPhOVOMIIywwZNqT+e157lUY4G8ooAB3qS3EvFVHMGXiSLjcyAhSsyFZaYPpHapZmTxoSmASdVsF8uaWdOx0gHS/dC4rq6Pj6gzJWrZ5U893+FpX9hX0VH3Gz64Jq29ZYG/3yJwV6el2r0myjwBJyvp4RStrvqW2lzR3n9RhX55FlXf8SEuhUURODTaVxThG2I3OYqf0kVdyToIECN
 6BeRtFMg
 EVLHNFo3oiUhiYVGWLZ15jqZ1E3HFAQkQQdTvO85tsysZB4tYEJEurCPeQeSjROnhUwquInijrAOPIXqt7jjDugu7LdF1Yq8nWprreg89xaL3rtRkaqjFQNCEoJw03TU7X7/2DceKNhkF+bE4ilOeCa43VZdMQmR8GdUDL8BaW0Kz4PH4D2VrD89PHYRRYNUV9fZRtwDr77fX/N9F0SJp8Uxo4JzNTNELeM8Bia7kabnKga9Qx1ZBXR/YOWvpDNKE4MSi6a71Q9xKErk5k1Vpp2pAibuzeO3lGLgXvdR3wGXhxLHveKmGJwKYpoycAjmPz04ZHpWDPUOcit2OQ6S7x3Lk4cGr+ZDQqxBFkQrOB//h8B9oMvhvOZ/a0vuF/iYfAuanPucDAnL6eAo1ORVxrnxiJwLTxQaFxlFFMh78nvPu0dw6O7cb1hAeyG7qRdN5KwB8CzG3+YjUuLbyHAkuEAIwSOPJ/7MsaSNfjpsDCmNt55/gWT/BM/MChY7zA8/qVX9p184ukaFFa2dfVXCE0T4LVpTMTb9vAF8dUod0hg7vnwAPNyu5dq4q23OJZbEaK6HJ5akHmyP18D2Wqq+MJ0YoU6hOupBDPJa1Bix6XqqPmr1yrVZdONmHsRIEi8LvpSE4Evti29E+GpF41qJtjAsXArDo332cn8PRWng/ddDS1+jCEb4VnbRbG7FECfSUzekEWSUXzF62ct0f0vSCRzN4LNwKr8RLgIrUGGRCiRZ02mwFPEhB5u8aEFbrK0GDobDTuPHW8UzzAZjVY7sppoigMi2IZChPgC31wXVCBk5M2tDhti59LjihzpnvfA+x+0Gb/yQbUXtmnoQE2ebNd1yjPucdosEQtmFYJEaOezFa7yBWHGJ52TjgUdMlyQI5ZqQBcPyP7DX+HuuSx7fBWJFRtkVXZ5n5O5CKNWut9c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: fix up min3() and max3() too

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-fix-up-min3-and-max3-too.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:12:01 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:05:12 +0000
Subject: minmax: fix up min3() and max3() too
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Laight <David.Laight@aculab.com>, Arnd Bergmann <arnd@kernel.org>
Message-ID: <20251017090519.46992-21-farbere@amazon.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 21b136cc63d2a9ddd60d4699552b69c214b32964 ]

David Laight pointed out that we should deal with the min3() and max3()
mess too, which still does excessive expansion.

And our current macros are actually rather broken.

In particular, the macros did this:

  #define min3(x, y, z) min((typeof(x))min(x, y), z)
  #define max3(x, y, z) max((typeof(x))max(x, y), z)

and that not only is a nested expansion of possibly very complex
arguments with all that involves, the typing with that "typeof()" cast
is completely wrong.

For example, imagine what happens in max3() if 'x' happens to be a
'unsigned char', but 'y' and 'z' are 'unsigned long'.  The types are
compatible, and there's no warning - but the result is just random
garbage.

No, I don't think we've ever hit that issue in practice, but since we
now have sane infrastructure for doing this right, let's just use it.
It fixes any excessive expansion, and also avoids these kinds of broken
type issues.

Requested-by: David Laight <David.Laight@aculab.com>
Acked-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -152,13 +152,20 @@
 #define umax(x, y)	\
 	__careful_cmp(max, (x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull)
 
+#define __careful_op3(op, x, y, z, ux, uy, uz) ({			\
+	__auto_type ux = (x); __auto_type uy = (y);__auto_type uz = (z);\
+	BUILD_BUG_ON_MSG(!__types_ok3(x,y,z,ux,uy,uz),			\
+		#op"3("#x", "#y", "#z") signedness error");		\
+	__cmp(op, ux, __cmp(op, uy, uz)); })
+
 /**
  * min3 - return minimum of three values
  * @x: first value
  * @y: second value
  * @z: third value
  */
-#define min3(x, y, z) min((typeof(x))min(x, y), z)
+#define min3(x, y, z) \
+	__careful_op3(min, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
 /**
  * max3 - return maximum of three values
@@ -166,7 +173,8 @@
  * @y: second value
  * @z: third value
  */
-#define max3(x, y, z) max((typeof(x))max(x, y), z)
+#define max3(x, y, z) \
+	__careful_op3(max, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
 /**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero


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

