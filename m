Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2630ACCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 763388E0094; Fri, 17 Oct 2025 09:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713B58E0092; Fri, 17 Oct 2025 09:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6025A8E0094; Fri, 17 Oct 2025 09:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6768E0092
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:49:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F197C01AF
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:57 +0000 (UTC)
X-FDA: 84007739634.12.CE55AC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 718B840011
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=C10tlWho;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708995; a=rsa-sha256;
	cv=none;
	b=vmjNrdFGxv4sA6zKNV5sbiXihHdCjxCKLnbAGmMunPIByChC/2iAT9FvKXIwd/BCeDFIxj
	AKZc6rdffIxrIq/FNW7TsppmRMWMr2NCTmD+8nRMbqoytaXPHApZHFiHHBWmNhZdZx+llH
	RbmFvBAvdgKsJkmHsbQPW1I8Nu3RCGo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=C10tlWho;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=fGLjEyziNQY0t8OuTOf14gTDEe9OuRJYmVpLqP1D/bQ=;
	b=UhzR04XDszlQTgc8ozOvZ1itOlpTDgzPfS/8tLlJ67OvyNi2Ju3s4Xxi7KMF2CgVy19MaJ
	0Hbj/R0JWT9j8vlIl9aZdeKk7+NReaoWuTU9n0p38QHz1iBn2B+8XGVBy7u1LwjRdbWve3
	3OUvEXE13r2oN5hzG5mjvsrvCCeQCo8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CD7756439F;
	Fri, 17 Oct 2025 13:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3DBC4CEF9;
	Fri, 17 Oct 2025 13:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708994;
	bh=F9kKa6fDv6W6DAexXH+72tvBSrNTOp0cDLlFnkl5LpM=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=C10tlWholbNt7hAMJQkwYG1//GR7rnXYOHf2JPpSCGbvRlge0OcxtPgF8WcoDwuN4
	 +Llji6TepGPPrE9qAHX+CJUwpY8kpbnq0XwoKazDqb/Rvm5t22BPHjRo/BlCDR4YGn
	 o3KyxMNbGaCQGid3u12ArUsgCX2hBmVKxfV5f36U=
Subject: Patch "minmax.h: simplify the variants of clamp()" has been added to the 5.10-stable tree
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
In-Reply-To: <20251017090519.46992-27-farbere@amazon.com>
Message-ID: <2025101733-suitably-supervise-b758@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 718B840011
X-Stat-Signature: 4gso919rn9iia7hziyz7suahti68nstx
X-HE-Tag: 1760708995-660238
X-HE-Meta: U2FsdGVkX187xBo3AOB0rSflBpbMaxgrnzEb+b3PY9Vvm/sLVTNQnY9lkdHOvfBn0vMHfSSUD2NKF5RDWdu6hhu40Y9ZtTafhrIguqn7gwD0h0Jhey9TgbUO8VDmMkDb5sgcjbMmd4LE9a8rPJatxH4C1G/SKFrp1KCKM87nay+UrUFVDZMJ/+eR5Yca2sP4jGo9LbR1hl8mno1x62FHwccTNF/5MQw/eakSQduwW5w/4sbVvSoFBadV05K/b996b3kTbt2GZnuJUIa62d0tRX+gr+KRn6vKl8gzXJleT+D0lvayYWpc3z4EVx1oW6DZ0BgdSbu0NS/WLp762VIdGHyvUBJWWbVWqgp+oX+TTUcWLjWEQ8mZpQTvMgXqCju6aTJlijezsmjpOS2ZGM/4NkHyFSOXQlG68nxNiK4GfYjzrU1VxC5MDP9zKrBW5tM3aLjlRTY9H5wDSx9gLkkF5pf5LZFxY7WAbRDB1HYnKTZs126rjQO4TKGZLYlB1MTM7dBmQfjy/POcwN3bWsUhT4zMyo5k0IJII0aK1gK072fCJNe35q8CUeNNW4RcDsF0+FBPDYSO2HrywTIbbTBzcrEFOokCdYNC1ZdSa89WW8N4ds24hYU6TtrdhTEugU7TJ7B/oyn1d69R9zr3Ib1KimB/Yf/d7OvkFu+SjtKLu7j5W9OTowWCTgqe9aipQTIvTZYqwyBtFHTyQS20HpifZcRzlWi8CTCi2vLOEhui96ejtmOsFGQ3yNAVd8Bl1gNUxLToX6YzsboxCoyHdR4EI45FyyRWc3fLv5+CT4y7sITq3uLmXIeuIbfFShA+N96Qnwws2HCkDqLrKlSPXevtz+OOHsZqBOrvDTIvGOdQLxZ0vDYsImjcZP7KAfUUJR3tLSdf6msY326tN0gR6BWaADqzp2x+lm5dUcubvNUcWeJ7Q9dEb45PCHrPPAiu6DezDSrBirkMPiwg9D4w6mH
 usdt4ELu
 lb1xWobnApYWpTYtjJb/H0K0GlPZoaGj3NosP/eUsQO/bQW1wMgc2ikVdtTgY15Z3g4CPCTKMigD3XMdr6BJFJjzp5egVzZGy8h/ZvJJfycUdg2dD+vmULbhQ92cUgPzrMaxPf/swoNbZHWc4qdhNtT5aMM+VcXgL7AMRBwrT4XE3PVhzU3NYbmoWkcaB3FkHq4W+yna5KOz+vzr4Ho1+vT4C9fhowRFeoYdQLt0qiPGhC3V8TyQEFAyHSFd3COI4559O6xBuuqZYWRYucHIn8i4tx10jLbAo9UH+ztF7Rcz0KFRfdPQIk0zkdOlCkfIV4h5E3NdiKgFPEng81xFRpiz2f22HgOgM6YbWvPgumHbWFOMsr+9PDd5ve1JUVnlRjQiyVFN+TI8loOsh162SIDJSuedaVd569RzRCeM+jTyiHx9t7IbZ2cFdvdroZatC1byGm5k7G0STzbQpJ1EqIQ8cLqhDg+jbi/ZXzGXBrvIwkJjP+RlNFfafq+M+F+Oisjr9R++caynXSMZTIhOIrvY7PdHIaT5i/B/6edY+m35jaXZ9gLqlrKJcaqFKcArDO6YaRrUaFN/Spc5Hjgf3QsLjDYSg4Jbmx6FDdfJIXz4HjKcZLzjhYaj5RRCFNS9AfuF4Xe+pX8inC9FFeWzBLX3P1D+AC1GT6o4JOLIj74dZaVhM6umCnBNZesnP5CVKdJLwq/yEPqRjnXKnMoNadUzdtyteD5jQ/HAKVNhRt1Zq+CR8FNa6vJh8leL/Cp+qhAMjEPEURtGxxRt6Xa9e4KUFesCtEqDdz/4Feoa578TF1Qwee5G8MC7jxDxMjt7bb2n70ydfzB95bWM647/lJNhdg+g5LzGGt7edwx+Ar8S0hJwFt91qswikPmO2EHGUZfPvqaI/eaFedu9Wtr1sje7+JPnd4tmLCaNEA9a/UX/MD5lNYor3/Mc04EWFThGAnReCs6NScMN/P8NMFBFXl1gti+Nm
 K8d8ya4v
 B4oM6oWI81aXNLcQ2JkGtFfj//My7/ixKWYIlGb+KSqeRIchnxpvO/jyHmI7iQWHkfrx1HgqUM0pNnuOJkqZoWprOgXsBelWxYR8lCYQ0l4Sz1UVVpSX6xRcIy2e3CfgT8by4HlFfheAux0+9ye2ocwNiDwvYgJ5SRMufaN2JQaARmHX4HhvIlV+crfUDgg9J5JnlSeVaTvrZ3SPJXN2mAdweXaVkCMPXLgdhoflr+1jDdROjLG1h+UqhbYps+23CS8P2z5Qz6Z5KL58zkrRZ7BNXgWFW0sjwRPG1tcqZuOiT/gpZyjdVIz1iMy9thAsDUkqXzxxVXBdK/TvDjQJD11Evyk5wQL2kYj1EqcVkwMzVxcbAwJZ19TD4NsuPbAKAKt8lwxvd445tqpkgwNzkWJLZgL/ip/N8AOHJZRy29fhqpVPz1+dEQeq0+87bU0GZO/LcbgMHHpovPAdg4A8212xowdH+ewkUTd2J3m46zlBDhGxVrkrVEbjOrwJVD+wivH37eiNY5XqJfizNPnm0GSNstA+XaTyM+ma5D4G2QX7JqUqBtcV0fTSLuWo06kjDbz2V2PPC32+xfT+/7of0M6Mm/+U/m1FUuGFfeW2cx9e+4n1MiXN801Q/rCTPiKp00Noqo9KcMbmlgZmclVdFPaABDodQF6QYxZQxhdOo1EDYYmK8MKhidLk3KGoeR3JWujXItflc7flwvSyJFHjzeAiF1BKx4/VO0gAu+eYApsikpTe/ukafv4eOhsd8kVEjNEa2rKkHR00T5ve1c7mg1OvSg0rBPS6fOaTPo0TMyw+9889schJvelzDKXSwMxL3cBR4/2e+5bF0JpOonS78ycoJR3/UThydD3Cey1ZcoPghq7Z3il3JHrAI7zD880LXHcsMAVvNqZYkhIy2oFIleIURrGMiwvxhI8kgS1YLjAxFou5ALTw/JKkRY/+gIvFnCVQ2fjPGLLe6Zp8Yges5GmbhuxRp
 Urp+vxya
 Y+B+xYt/OhVTdapN+pWmnNnm6xq7jUslWw5W2c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax.h: simplify the variants of clamp()

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax.h-simplify-the-variants-of-clamp.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:13:55 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:05:18 +0000
Subject: minmax.h: simplify the variants of clamp()
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@linaro.org>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, Pedro Falcato <pedro.falcato@gmail.com>
Message-ID: <20251017090519.46992-27-farbere@amazon.com>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 495bba17cdf95e9703af1b8ef773c55ef0dfe703 ]

Always pass a 'type' through to __clamp_once(), pass '__auto_type' from
clamp() itself.

The expansion of __types_ok3() is reasonable so it isn't worth the added
complexity of avoiding it when a fixed type is used for all three values.

Link: https://lkml.kernel.org/r/8f69f4deac014f558bab186444bac2e8@AcuMS.aculab.com
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
@@ -183,29 +183,29 @@
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
-	__auto_type uval = (val);						\
-	__auto_type ulo = (lo);							\
-	__auto_type uhi = (hi);							\
+#define __clamp_once(type, val, lo, hi, uval, ulo, uhi) ({			\
+	type uval = (val);							\
+	type ulo = (lo);							\
+	type uhi = (hi);							\
 	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
 	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
-#define __careful_clamp(val, lo, hi) \
-	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
+#define __careful_clamp(type, val, lo, hi) \
+	__clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
 
 /**
- * clamp - return a value clamped to a given range with strict typechecking
+ * clamp - return a value clamped to a given range with typechecking
  * @val: current value
  * @lo: lowest allowable value
  * @hi: highest allowable value
  *
- * This macro does strict typechecking of @lo/@hi to make sure they are of the
- * same type as @val.  See the unnecessary pointer comparisons.
+ * This macro checks @val/@lo/@hi to make sure they have compatible
+ * signedness.
  */
-#define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
+#define clamp(val, lo, hi) __careful_clamp(__auto_type, val, lo, hi)
 
 /**
  * clamp_t - return a value clamped to a given range using a given type
@@ -217,7 +217,7 @@
  * This macro does no typechecking and uses temporary variables of type
  * @type to make all the comparisons.
  */
-#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
+#define clamp_t(type, val, lo, hi) __careful_clamp(type, val, lo, hi)
 
 /**
  * clamp_val - return a value clamped to a given range using val's type
@@ -230,7 +230,7 @@
  * type and @lo and @hi are literals that will otherwise be assigned a signed
  * integer type.
  */
-#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
+#define clamp_val(val, lo, hi) __careful_clamp(typeof(val), val, lo, hi)
 
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

