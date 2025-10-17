Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59F47CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5FFB8E008C; Fri, 17 Oct 2025 09:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B312E8E0006; Fri, 17 Oct 2025 09:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47788E008C; Fri, 17 Oct 2025 09:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9274A8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:49:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 590CD139114
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:28 +0000 (UTC)
X-FDA: 84007738416.25.3A11E41
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id B157F180007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=o4k3XMRM;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf06.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=KPQwZYAIaCrYXbqdyn6i04//mrgvmawadjZnJbUmzg8=;
	b=nYpZnAigsB1qj+NE4VsEH/kozgahACGPMgYybZOGS7sIl+3d2RDBhY8jl9E1sv8lXOyeaN
	HNYx+8jfbT1XoleCXZFpxdD0D5csKlmItM9lTyXWcTiZzRl4NX/qwK+kUYKDQy3RwVUrWj
	JWStZlxj6qtuW4f8CN59jgSQpnYEgVg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708965; a=rsa-sha256;
	cv=none;
	b=WLYntraSAUvSJR6AYEzPJUE7EcSuFcXCTqwSXJz0eVr18j0dFYenrP2JykhnkmaDukoesn
	KqKPIULeJOo+xWrA6re54JPscpIgG6lUIJhKyJpsjnFNUMaKL6RnCFdag6QvnAQfY7myx3
	gtnAjYGrjj7lMc3l0KuU6Bf0iWPZ95g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=o4k3XMRM;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf06.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2467C64391;
	Fri, 17 Oct 2025 13:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C2BC4CEFE;
	Fri, 17 Oct 2025 13:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708964;
	bh=bOsqCp8TMdOOxRouPL0v40Hpip8fec6qVLcR2bbUelE=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=o4k3XMRMySS2bKlqoV5SYd19Rsib6i/gvPhcFvbMlaAzI0b8Ur4SEdnbSg0TTymYk
	 7bZujYKA9rw/H+XOS7UeBCG5/fHRAoMaVtstXu7OxOiugdHb8sdEdHOr3Yzdf61Qxg
	 eAoznRU3mkFGJ+bSUXEP0+1exj0r0qj4oT+FGlvo=
Subject: Patch "minmax: relax check to allow comparison between unsigned arguments and signed constants" has been added to the 5.10-stable tree
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
Date: Fri, 17 Oct 2025 15:48:31 +0200
In-Reply-To: <20251017090519.46992-13-farbere@amazon.com>
Message-ID: <2025101731-bulldog-eastcoast-8e47@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Rspamd-Queue-Id: B157F180007
X-Rspamd-Server: rspam02
X-Stat-Signature: dwij7c5kkdu7wsmaaapwywt3arq6iubu
X-HE-Tag: 1760708965-679874
X-HE-Meta: U2FsdGVkX1/L1ojMKdgHZdr58tlqtbcwuVNoe7ghrIuYaHgHlY49EcZ7mPm054xvUnskv3Os3S7i8VASEoOs5QhXfwr4Jy3WpGHOBPbdjoF22eREJXHYbjBakWIvPoJx/a91JHqpTbp9vMPqVZazO5TzobNV+GrLdraSd8lREwMF9jlGCMWZyf97YgHNd0FE3zgjupdmQiHg29Y1MIrDgoCfuMjtJpI/o2/YGLIehZ8P0glyAXr5b5IlOcRgym48qo44I9RaqTlwlWjaR21F210oNdjreTWQhlp4CmM0yM1r9QzIITpe/RVeebRnIZs69j568c0/hLb7jgf8vX0V+K2KM42oXe+Xa72mGg+TZl2dBRarHGhnuVQkUF4vIu2LIEwXfjRKUXDUJ5+WdkoHGDKgpA37BtPBozhMBnc+Sg2Bqohb017qM+9dXVQVi9fn1xvlcgrouPzuyJn01S6lrSF/AXZJoV4aeajhxNgdeULqu/HvFLd8+Oj+2Cic4nkIaAzb50UeSqrkT00ZIkKC+4IwdiAGssC7cEDeNhfZt8bSNBMND6DDVQv0vJerbtkXMXAhdMwvWWzTEcwyrs6SDjs+XlhNRUF3jJftggMURPF2+jmyCXFbbDH2vsvOWFhT3G2aUfWBkuqvtcGroNjMz0kaqWI4pZ/WhV2qH7xDEGJlyJJAFHLiNIpbxUaacMcIClge25HyXOivslOJFyUMTpt4WUopQ6y2HI7ac2r/Mo0YsNP9YAiPosM+FGJEIuntEcZLbwvGLuGpxBkFLXYyjzXF5VSoXqLXGbjLJvA46kCrB4EQe7I4ZDHswThmDOeyBFhkwzSev//Ung9ZuRgwD/pHI9sG1q9/L/6WOBjW6zJ88TPPFGJARV5TisNFyu7jzi+FHiaX9VCtZSyq7CPhjdl58y3Bg03O6WNnwrilWrSWFXkZvWDXnJOtVYis+pkmZIx5KeUccmRqxmMcoK8
 GQd4yJ8c
 jr9Jgugbm09RzwdgqyaSZpusfW1EUdI0MQMXvbPKNHw/EjH3dbCXihf4M5bHpgxYq5dn8oOco/NINQ19tyzQ1xxA3lPxiLDA6u3cwS9J43Dt62EvPRYMMoKOcAG5IQAMipORLtibzdEL2HOEFdphnQpHi8QJbec+5wzIC1R+/Pah9VoZDpAd76RXjGbmGmzhl56afIQARl1gRLedFEZkXxtb22hXR9BJ4N4lWM5Gr2vxeyJTJtAXcunUMxh1AlETqnOLCgyks93jQea6Czptayu3Egp4a6bQCj7ZAFyVK+2y+3XnRZXHRGdHp49jHEAiVgsxL+BBh9U11nnkC53AnMQx9L2XUN+pk6/+mV9tKwZ9Nghzl4poAg7b/dOi1AaZd3Vb1cg6VdOLIGqKvCFU9mastqXH1yMUUeMISpX8LH0krnMzkxe8YCsPg48++YA9XZc0d07XkwHN74qbpo+IGQ0Ahv189dHhr11tpEZjkoQoQBKDNgWCDDLAR7i1rDvUphPAdm8jxMg1ow7lnsSsdWDKyGaTo5p+oLA0/1n4fcx8ALTkK5y9PucRu02jj/PyDZ49C0a3cEqHmtt+Qx6RSgCg3Biy01E73lO/lYd/+dimWYB02yjqzF+jKCNaaNpxEcwFMnkdstYIPe7/Q88bfiy/8N9XLTaDVOYLa9k9moX66ZkvqjAuPwovKg0Vt3MDK1qIwqcoz2g80nCdBrgJgIihCQVj5ASvz73PgMA3BnGdRJRI0HqfyfhB927pvr9Q1UMrSJlk0D7PQaThTjO0QKBJaFvE1DYUVzI08gf6pzHKmcbcn72ZqPQWVvxv6uOipEqZ4pRta+XV4KfsaqbZ4aj4bn140aLlixLvUnfojvL/xwJvLBfDaVJ8g9UKb+DOeRTnN6eiNnCfP3eQ971hKyRYDsHbZP4lZ8/SShJPOMJ4jURz+DmVg2p6i/RxLkYKySb9FsDIiqczfr/DMHbg+54tq9FQn
 1hYtXKP0
 nBBxlkH0rpotUTwEpI/dcs8Rrn4Etes+YzuocS/rIKhzkDn+TnaYRBTaXWbJxhZ90HmMdjmjAUMUNSRnMaxk6FwFI5BejUHQbsoHxY0sH3Eb+Qs/mnX+T2XJSQsm4Tg9MK7asekRQQPLkwUT3SDyGqBV3Eq0gCLXr4K1W3xw+Nx+AHSkAWY7J0F87Fwr96Tz2CPRcbuVIOq994IDWoknQ3+ZL4ff0FtBSGnKtw1ruWZcWBOx+LOo92yh4fyrRxR+Et9vNwqTc5LDWUUj/V3UP0l14pIYK4U6d2GfuXbK5Ax2Z/wpUDxQ1PUB0DM3xPTEck9K8FmnirJUn6NmhAV/ItKpBAJCluX5Ns1E7PQz0auaLZrLjNWZiJMkKXHjVjHvJ8CiFiqr2ohOxezx0fG2saYfEXZqfIPuWPgVpQiPfjQp/QD7hvmi4e4/61ji93mDDyv48ZW0lmf/rrsS+NLv0g3F9aXydYh6A3NVqkzuZvnn6pfTiRrcl7P6gtL4m+zxFsFmb06m7A53GRf8DQCyZfDe2jG1BBCKR3VDgG78QuiPR0M6g11pPY6//ylrxuqtOgp5XlC2wUCilZ1lqrZC5gGikKmY7TB51+Vu4jKJJ0qcJyCL54B5mlhbn+HYa+x08uYTnWXkws3snGYiQm6txY8SYPLbF8ywvS41zo2z0EWIhcylXVg2PfzHM8pJh3PZvTy76Hxl7VQ9XiY0N4wcNJZo2FLRHWB1DFDPf5MJc/ITGJAK0vL/Y0atLHL88xza+rFBMv5qNy9ZLEQWdOSR6HxQQpuQCmL5qt7Bf9Kv02mNOIPhmpBeaY84pxCfov541hW8Vv/fGFfJL019HW4jl+0mw1Jhs9vKTZAapThABE8ebIRxMeM3sPXdpWzT8j3eEg0SCxgEPZBLEeQYspo1FdYKydsfSH/3eRPNqvBKYoRyprCtow9YcGovHbFvn9PMMKBZqy5xD4IcBMtkSy50yYqLLSJ9Q
 77xgcYPX
 KGUQ9L9pb+RqK6Hwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: relax check to allow comparison between unsigned arguments and signed constants

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-relax-check-to-allow-comparison-between-unsigned-arguments-and-signed-constants.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:09:53 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:05:04 +0000
Subject: minmax: relax check to allow comparison between unsigned arguments and signed constants
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Christoph Hellwig <hch@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20251017090519.46992-13-farbere@amazon.com>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 867046cc7027703f60a46339ffde91a1970f2901 ]

Allow (for example) min(unsigned_var, 20).

The opposite min(signed_var, 20u) is still errored.

Since a comparison between signed and unsigned never makes the unsigned
value negative it is only necessary to adjust the __types_ok() test.

Link: https://lkml.kernel.org/r/633b64e2f39e46bb8234809c5595b8c7@AcuMS.aculab.com
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
 include/linux/minmax.h |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -10,13 +10,18 @@
 /*
  * min()/max()/clamp() macros must accomplish three things:
  *
- * - avoid multiple evaluations of the arguments (so side-effects like
+ * - Avoid multiple evaluations of the arguments (so side-effects like
  *   "x++" happen only once) when non-constant.
- * - perform signed v unsigned type-checking (to generate compile
- *   errors instead of nasty runtime surprises).
- * - retain result as a constant expressions when called with only
+ * - Retain result as a constant expressions when called with only
  *   constant expressions (to avoid tripping VLA warnings in stack
  *   allocation usage).
+ * - Perform signed v unsigned type-checking (to generate compile
+ *   errors instead of nasty runtime surprises).
+ * - Unsigned char/short are always promoted to signed int and can be
+ *   compared against signed or unsigned arguments.
+ * - Unsigned arguments can be compared against non-negative signed constants.
+ * - Comparison of a signed argument against an unsigned constant fails
+ *   even if the constant is below __INT_MAX__ and could be cast to int.
  */
 #define __typecheck(x, y) \
 	(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
@@ -26,9 +31,14 @@
 	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
 		is_signed_type(typeof(x)), 0)
 
-#define __types_ok(x, y) 			\
-	(__is_signed(x) == __is_signed(y) ||	\
-		__is_signed((x) + 0) == __is_signed((y) + 0))
+/* True for a non-negative signed int constant */
+#define __is_noneg_int(x)	\
+	(__builtin_choose_expr(__is_constexpr(x) && __is_signed(x), x, -1) >= 0)
+
+#define __types_ok(x, y) 					\
+	(__is_signed(x) == __is_signed(y) ||			\
+		__is_signed((x) + 0) == __is_signed((y) + 0) ||	\
+		__is_noneg_int(x) || __is_noneg_int(y))
 
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

