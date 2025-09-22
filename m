Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE45BCAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 12:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1370D8E0019; Mon, 22 Sep 2025 08:27:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7348E0010; Mon, 22 Sep 2025 08:27:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1118E0019; Mon, 22 Sep 2025 08:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7C578E0010
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:27:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E78E871FA
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:27:39 +0000 (UTC)
X-FDA: 83916812238.15.BF4335C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A358214000F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:27:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=eVGZ4LJc;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758544057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=L+5wGgoHBSBLmC5kf5qclzZ3ZS5nRsILly2ZRl1D8q8=;
	b=vToBMPpbr/+egt9kfDiBFIAxOgvG1VpOurVbwcS8B/h/Vl1sqltdKt39L4uFJbvRcH8F0/
	R9Yx5lzsk6xNEN9hJL5ruRwdf5AEwP+N+z9lMcGnzmJIJF7FYZBn6cQ/PTOrWGasWEUqvn
	6AIrEc+YAdCkIvBYXWKdtn+Cn/N8v4Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=eVGZ4LJc;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758544057; a=rsa-sha256;
	cv=none;
	b=Qsd0HZJ8XXPDP3evGtJ9kAX0o6uBHeWpBH0SWlR2zcsc+fm2Kd5kQ/e0YVOXRVRWmlpm5C
	jP1a61+2INirrmjuhVjtlRnFR2pdIwRYkCIKSivSUZItpFtZ5pFOi0QY1lhgtJDPjTPhAa
	UPhQqJ6lbLF3gFoKPJDamT4N31/UBpQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B0A5C44F92;
	Mon, 22 Sep 2025 12:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C39C4CEF7;
	Mon, 22 Sep 2025 12:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758544056;
	bh=2M21V/xsLcrSqigAVqcKHpm03u8tIM/EYLujZWD0gIM=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=eVGZ4LJctEvshZs0C8q8ZYmQahvKd0T+PVsMcEWSGH7mahyT8M9WmoT4AhQwjFila
	 9PBgMB28ZBPsZcegUe5QOh1+A9HTqEBLR62mtbnpEsgez22QL15g75GQcMD5ZqEnu/
	 zR7cVHGzBEvYrPMSV1Vuq/557yJpw3QiocTx00RA=
Subject: Patch "minmax: make generic MIN() and MAX() macros available everywhere" has been added to the 6.6-stable tree
To: David.Laight@ACULAB.COM, David.Laight@aculab.com,
	Rodrigo.Siqueira@amd.com, Xinhui.Pan@amd.com, agk@redhat.com,
	airlied@gmail.com, akpm@linux-foundation.org,
	alexander.deucher@amd.com, alexandre.torgue@foss.st.com,
	amd-gfx@lists.freedesktop.org, andriy.shevchenko@linux.intel.com,
	anton.ivanov@cambridgegreys.com, arnd@kernel.org,
	artur.paszkiewicz@intel.com, bp@alien8.de, christian.koenig@amd.com,
	clm@fb.com, daniel@ffwll.ch, dave.hansen@linux.intel.com,
	davem@davemloft.net, dm-devel@lists.linux.dev,
	dmitry.torokhov@gmail.com, dri-devel@lists.freedesktop.org,
	dsahern@kernel.org, dsterba@suse.com, edumazet@google.com,
	evan.quan@amd.com, farbere@amazon.com, gregkh@linuxfoundation.org,
	harry.wentland@amd.com, hdegoede@redhat.com, hpa@zytor.com,
	ilpo.jarvinen@linux.intel.com, james.morse@arm.com,
	jdelvare@suse.com, jejb@linux.ibm.com, jernej.skrabec@gmail.com,
	joabreu@synopsys.com, johannes@sipsolutions.net,
	josef@toxicpanda.com, keescook@chromium.org,
	krzysztof.kozlowski@linaro.org, kuba@kernel.org,
	linus.walleij@linaro.org, l@kvack.org,
	inux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-staging@lists.linux.dev,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-sunxi@lists.linux.dev, linux-um@lists.infradead.org,
	linux@rasmusvillemoes.dk, linux@roeck-us.net,
	lorenzo.stoakes@oracle.com, luc.vanoostenryck@gmail.com,
	luto@kernel.org, maarten.lankhorst@linux.intel.com,
	mailhol.vincent@wanadoo.fr, malattia@linux.it, markgross@kernel.org,
	martin.petersen@oracle.com, mchehab@kernel.org,
	mcoquelin.stm32@gmail.com, mhiramat@kernel.org, minchan@kernel.org,
	mingo@redhat.com, mkl@pengutronix.de, mripard@kernel.org,
	pabeni@redhat.com, peterz@infradead.org, pmladek@suse.com,
	qiuxu.zhuo@intel.com, richard@nod.at, rostedt@goodmis.org,
	rric@kernel.org, sakari.ailus@linux.intel.com, samuel@sholland.org,
	senozhatsky@chromium.org, shuah@kernel.org, snitzer@kernel.org,
	sunpeng.li@amd.com, tglx@linutronix.de, tony.luck@intel.com,
	torvalds@linux-foundation.org, tzimmermann@suse.de, wad@chromium.org,
	wens@csie.org, wg@grandegger.com, x86@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 22 Sep 2025 14:27:00 +0200
In-Reply-To: <20250922103241.16213-5-farbere@amazon.com>
Message-ID: <2025092200-reverb-stumble-8578@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Stat-Signature: 717ybst19j97za17xi9qws1ozz9cicby
X-Rspam-User: 
X-Rspamd-Queue-Id: A358214000F
X-Rspamd-Server: rspam04
X-HE-Tag: 1758544057-242291
X-HE-Meta: U2FsdGVkX18koOhjewblbqyzhENjzuBt/LwfxiHBMjDvuJLRf6f7WfxLML9zah8Rs/OmJm0WpraqP7CraYkxXjNwwMN9mbkWERbufx2X6MdyfsUM3gb8l8scgMk3g8jDZJ7nE7zU0Bb7n/WEO0/Hy3cLDHosaI9GXOFAfkFvtJQXrROSiAr8jsSiDYfMOJAKXRtF7aSu1scJw4DDtMhq0D+Fyz/dgMGv50sx7Eok3Zl1HxaIzA5C6Ot0NRnabbpoDsriiKhcZoFB6pklNfcWOx9qZvWWa7V1y4um7g5aTnEKRsRcYobQ1qd83KrQ5wImOCkjxg34sunhPfaCNLusZG6zLUVeImF1nRxRoxf981/vvd/x0CsXZPfcRRqTvy7P7MgylUhVoDHkOS4ZVx3dgUq3MflN2N406VXEOSfwoih6sy2xSxnWOjB6Wesrxft8Zn0yHXnP1zFWrSPJVW2eTaB04cqrur8AzaQKQW/Kb+/h6Tx9IOhnTw2lsCnigUY6rKf7S+ICnUkflAtTLmMANhi92xVuOeL2TpPgeKM2S2PdwLLkOD4yolCWvaFaX+oXIy4zv4+XyH1Pul/KhTeBiKpLCwd3Dhm5qTsOoo/j1+0wEJtTtwadXSvKqUzr4202ywqTKWTgDwc5R2p41GvTIPfKFmmjM6FbeVCm5/FofJxS6OXTmNiU3IiWsUM02xL1mHKT2uJVGlii0siFCMbvildsYdA6PEqCPddmRsstNTe7mArfKMYY/Q2koz85iHFOH/X9BIMrwXcaJ95bXWQ7iwzvGJD/GVWdgTmmy2ipngptok4ipKXSirz5iSLfiUc4JwGFFEKLF3JATLIhELEvO5ol+1yUAfU/XBElKOQf8kGDyJTlhDwiiXFTTCLZ0Kv6sbT/h8mo2HJgA69RCA+vRMXaLvjCL4Vv3jfBRARx/rEE1YSFrNGOYLvjNLu+Uhgw03O+6xYk/THwCuyoBt2
 nMrRZ5Ib
 n9RoH/Ru0+oOw0q1y9aZjGJQBHFd0fuRReW8ydpLbBPNJksBnK/FNF+QPE9CAyUP7WUtGCt68/wy6aq9/IQQTGAFUrZHlmnqyRjU8WKl0vQMY+0kF4h7HwV0BwFgbwEVRhdd+JagO/da18xkEKbHITpe0dQRN+dUUlrrxzofj6ZzmSBxSHfwnzT2BITmPZaxjSkwb8MrwQk0B10P1mxvT7Skn9QLhQv4lN6ET+PIVx+8rk5EmPkcz3X9LBCvUaz7ziAVKOHO0shHga9llXa3w4U/dkN9IcaGOusFYBydFdhdYaVT4ugEdx2YpFIpsazswWjxWL6U+n/Ons+XbGbf5AZcUwEsJU/FjWxsdT2R/6XePwLYhU84gaJd7AwqnnIWBkCZzHhod9mwHmFvzrCnUaWSnvMdazNcX3GHn/R06k133CZ/12kBV7P1k7sMpy0fX2uF2FtYAjRpKVERX/yIRPGn+YRqA/1DWFdWaoxUnD3UMHi5WohQvVnjoS5ra7S2uzkkHp4g9f6hY8PJYOBHGGf8CvE00T8yVHGL5+aZQBxtIwNX8HNFBIkHG+sWznPJruKoiiHEXd7fqY++sPNJ65GwMymND0fpW1hRMbaOg1mMECTiXJI3ku+vd7a3gpNJQGkClNLsYziZFTKPKqs1aJnWuz35X9OmQ2tbpBHxDukza2Pfyl1XSZ1YnFlF4AZgnU3PAU+vJGZqabnthLP8AzdPFzYr5Oqb6vR1g+BzPPFPQixON8LoRFmBhW2jO4Ng1gqRQ0xxgrR47kHudUtzAtsSSQViGXXVbBLGky/D6fzti9QRA8mKmto7P8obRUScuISLdsVjcS/gv40ug6gunsXZGdOEYJK9PSofXHOuz7srKoM0omXBrQHxpw1vf+wQpwbX/qVO0EeNa5vU/K8IK+praoNbMoPjNKqeM+a5kPDap01WpA6nRjWSj39wm2rhtOi9vVLUTbRwK9GQcLCNeO2kTib39
 PbXIwjfe
 630tGzOYZyEmKC2Ig69sV1/iUzO7KSNgA/nnQyFkDbJXZf9fOa8ETVz0qpjec+/JLryHMtgytWjL1alW4By9rfNymjKSjWpu0C7Ef/Y7qp3tZGSYK2I7S0KdLctROfjZ5hHWb5bfeDhl3E62e9EvLUq09TwNtpclwqYt6F2ukyGhoc54j+hi77QYmjqFvL8wZSYh0CyOhmseoJvQsQ0VASUH0VIrjoBX4hy5mpfw3k7bRk7rWG4eYoCGMUN7QgLGEnYSu1M8aqzIV7FMgboV0+YOhrUplnpAbHiYlMJAM+tJRQ1pP4VyL1jY3OWkebthd7l3P0GCoYNib0p8QkiVTY1ckRahJ226YpfVfZelz64kHf3BS+1rh64fCriZQbLLbsgz6Ahuxa22//5vJ5nASyJ6wwWtVd107cAU/VS+QPRwSo3gvsC53P9Ox+I5wx9+TEToUrodidWYQhfUtjr2TZgeJVUUYgQ8scWsyXkTPRwqgPqPuUf/jjRiNOFjY9LgI6pSCe5XdYhzigUYA+ZMG6d17VDf7cplliG88ztByYp0O2SgMcg8krJvehSzTMi7U47hWwpg+nBqdxWnIyaS4QyNBVDlo4P/saOcP/Qcccc9WcY9TLPYTIeXffJTrfbrrao4t5OAsubQ+52/Q/iATB6gbzAh0Ri+CNKvR0IBOzX8IKIwMktExZHgWu+51N9DXtwbresRVkEUcZjeM4lO60dNplLqxek0XRlTWGPOEEQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: make generic MIN() and MAX() macros available everywhere

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-make-generic-min-and-max-macros-available-everywhere.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=353d6d59a=farbere@amazon.com Mon Sep 22 12:35:15 2025
From: Eliav Farber <farbere@amazon.com>
Date: Mon, 22 Sep 2025 10:32:30 +0000
Subject: minmax: make generic MIN() and MAX() macros available everywhere
To: <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <mchehab@kernel.org>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>, <dm-devel@lists.linux.dev>, <mailhol.vincent@wanadoo.fr>, <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.ne
 t>, <edu
 mazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>, <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>, <malattia@linux.it>, <hdegoede@redhat.com>, <ilpo.jarvinen@linux.intel.com>, <markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <gregkh@linuxfoundation.org>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>, <pmladek@suse.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <senozhatsky@chromium.org>, <minchan@kernel.org>, <akpm@linux-foundation.org>, <dsahern@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>, <wad@chromium.org>, <farbere@amazon.com>, <David.Laight@ACULAB.COM>, <arnd@kernel.org>, <linux-um@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.fr
 eedeskto
 p.org>, <dri-devel@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Laight <David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Message-ID: <20250922103241.16213-5-farbere@amazon.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 1a251f52cfdc417c84411a056bc142cbd77baef4 ]

This just standardizes the use of MIN() and MAX() macros, with the very
traditional semantics.  The goal is to use these for C constant
expressions and for top-level / static initializers, and so be able to
simplify the min()/max() macros.

These macro names were used by various kernel code - they are very
traditional, after all - and all such users have been fixed up, with a
few different approaches:

 - trivial duplicated macro definitions have been removed

   Note that 'trivial' here means that it's obviously kernel code that
   already included all the major kernel headers, and thus gets the new
   generic MIN/MAX macros automatically.

 - non-trivial duplicated macro definitions are guarded with #ifndef

   This is the "yes, they define their own versions, but no, the include
   situation is not entirely obvious, and maybe they don't get the
   generic version automatically" case.

 - strange use case #1

   A couple of drivers decided that the way they want to describe their
   versioning is with

	#define MAJ 1
	#define MIN 2
	#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN)

   which adds zero value and I just did my Alexander the Great
   impersonation, and rewrote that pointless Gordian knot as

	#define DRV_VERSION "1.2"

   instead.

 - strange use case #2

   A couple of drivers thought that it's a good idea to have a random
   'MIN' or 'MAX' define for a value or index into a table, rather than
   the traditional macro that takes arguments.

   These values were re-written as C enum's instead. The new
   function-line macros only expand when followed by an open
   parenthesis, and thus don't clash with enum use.

Happily, there weren't really all that many of these cases, and a lot of
users already had the pattern of using '#ifndef' guarding (or in one
case just using '#undef MIN') before defining their own private version
that does the same thing. I left such cases alone.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/drivers/mconsole_user.c                                       |    2 
 drivers/edac/skx_common.h                                             |    1 
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c                   |    2 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h                    |   14 ++++-
 drivers/gpu/drm/radeon/evergreen_cs.c                                 |    2 
 drivers/hwmon/adt7475.c                                               |   24 +++++-----
 drivers/media/dvb-frontends/stv0367_priv.h                            |    3 +
 drivers/net/fjes/fjes_main.c                                          |    4 -
 drivers/nfc/pn544/i2c.c                                               |    2 
 drivers/platform/x86/sony-laptop.c                                    |    1 
 drivers/scsi/isci/init.c                                              |    6 --
 drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h |    5 --
 include/linux/minmax.h                                                |    2 
 kernel/trace/preemptirq_delay_test.c                                  |    2 
 lib/btree.c                                                           |    1 
 lib/decompress_unlzma.c                                               |    2 
 mm/zsmalloc.c                                                         |    2 
 tools/testing/selftests/mm/mremap_test.c                              |    2 
 tools/testing/selftests/seccomp/seccomp_bpf.c                         |    2 
 19 files changed, 41 insertions(+), 38 deletions(-)

--- a/arch/um/drivers/mconsole_user.c
+++ b/arch/um/drivers/mconsole_user.c
@@ -71,7 +71,9 @@ static struct mconsole_command *mconsole
 	return NULL;
 }
 
+#ifndef MIN
 #define MIN(a,b) ((a)<(b) ? (a):(b))
+#endif
 
 #define STRINGX(x) #x
 #define STRING(x) STRINGX(x)
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -45,7 +45,6 @@
 #define I10NM_NUM_CHANNELS	MAX(I10NM_NUM_DDR_CHANNELS, I10NM_NUM_HBM_CHANNELS)
 #define I10NM_NUM_DIMMS		MAX(I10NM_NUM_DDR_DIMMS, I10NM_NUM_HBM_DIMMS)
 
-#define MAX(a, b)	((a) > (b) ? (a) : (b))
 #define NUM_IMC		MAX(SKX_NUM_IMC, I10NM_NUM_IMC)
 #define NUM_CHANNELS	MAX(SKX_NUM_CHANNELS, I10NM_NUM_CHANNELS)
 #define NUM_DIMMS	MAX(SKX_NUM_DIMMS, I10NM_NUM_DIMMS)
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
@@ -25,7 +25,9 @@
 
 #include "hdcp.h"
 
+#ifndef MIN
 #define MIN(a, b) ((a) < (b) ? (a) : (b))
+#endif
 #define HDCP_I2C_ADDR 0x3a	/* 0x74 >> 1*/
 #define KSV_READ_SIZE 0xf	/* 0x6803b - 0x6802c */
 #define HDCP_MAX_AUX_TRANSACTION_SIZE 16
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h
@@ -22,12 +22,18 @@
  */
 #include <asm/div64.h>
 
-#define SHIFT_AMOUNT 16 /* We multiply all original integers with 2^SHIFT_AMOUNT to get the fInt representation */
+enum ppevvmath_constants {
+	/* We multiply all original integers with 2^SHIFT_AMOUNT to get the fInt representation */
+	SHIFT_AMOUNT	= 16,
 
-#define PRECISION 5 /* Change this value to change the number of decimal places in the final output - 5 is a good default */
+	/* Change this value to change the number of decimal places in the final output - 5 is a good default */
+	PRECISION	=  5,
 
-#define SHIFTED_2 (2 << SHIFT_AMOUNT)
-#define MAX (1 << (SHIFT_AMOUNT - 1)) - 1 /* 32767 - Might change in the future */
+	SHIFTED_2	= (2 << SHIFT_AMOUNT),
+
+	/* 32767 - Might change in the future */
+	MAX		= (1 << (SHIFT_AMOUNT - 1)) - 1,
+};
 
 /* -------------------------------------------------------------------------------
  * NEW TYPE - fINT
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -33,8 +33,10 @@
 #include "evergreen_reg_safe.h"
 #include "cayman_reg_safe.h"
 
+#ifndef MIN
 #define MAX(a,b)                   (((a)>(b))?(a):(b))
 #define MIN(a,b)                   (((a)<(b))?(a):(b))
+#endif
 
 #define REG_SAFE_BM_SIZE ARRAY_SIZE(evergreen_reg_safe_bm)
 
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -22,23 +22,23 @@
 #include <linux/util_macros.h>
 
 /* Indexes for the sysfs hooks */
-
-#define INPUT		0
-#define MIN		1
-#define MAX		2
-#define CONTROL		3
-#define OFFSET		3
-#define AUTOMIN		4
-#define THERM		5
-#define HYSTERSIS	6
-
+enum adt_sysfs_id {
+	INPUT		= 0,
+	MIN		= 1,
+	MAX		= 2,
+	CONTROL		= 3,
+	OFFSET		= 3,	// Dup
+	AUTOMIN		= 4,
+	THERM		= 5,
+	HYSTERSIS	= 6,
 /*
  * These are unique identifiers for the sysfs functions - unlike the
  * numbers above, these are not also indexes into an array
  */
+	ALARM		= 9,
+	FAULT		= 10,
+};
 
-#define ALARM		9
-#define FAULT		10
 
 /* 7475 Common Registers */
 
--- a/drivers/media/dvb-frontends/stv0367_priv.h
+++ b/drivers/media/dvb-frontends/stv0367_priv.h
@@ -25,8 +25,11 @@
 #endif
 
 /* MACRO definitions */
+#ifndef MIN
 #define MAX(X, Y) ((X) >= (Y) ? (X) : (Y))
 #define MIN(X, Y) ((X) <= (Y) ? (X) : (Y))
+#endif
+
 #define INRANGE(X, Y, Z) \
 	((((X) <= (Y)) && ((Y) <= (Z))) || \
 	(((Z) <= (Y)) && ((Y) <= (X))) ? 1 : 0)
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -14,9 +14,7 @@
 #include "fjes.h"
 #include "fjes_trace.h"
 
-#define MAJ 1
-#define MIN 2
-#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN)
+#define DRV_VERSION "1.2"
 #define DRV_NAME	"fjes"
 char fjes_driver_name[] = DRV_NAME;
 char fjes_driver_version[] = DRV_VERSION;
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -126,8 +126,6 @@ struct pn544_i2c_fw_secure_blob {
 #define PN544_FW_CMD_RESULT_COMMAND_REJECTED 0xE0
 #define PN544_FW_CMD_RESULT_CHUNK_ERROR 0xE6
 
-#define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
-
 #define PN544_FW_WRITE_BUFFER_MAX_LEN 0x9f7
 #define PN544_FW_I2C_MAX_PAYLOAD PN544_HCI_I2C_LLC_MAX_SIZE
 #define PN544_FW_I2C_WRITE_FRAME_HEADER_LEN 8
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -757,7 +757,6 @@ static union acpi_object *__call_snc_met
 	return result;
 }
 
-#define MIN(a, b)	(a > b ? b : a)
 static int sony_nc_buffer_call(acpi_handle handle, char *name, u64 *value,
 		void *buffer, size_t buflen)
 {
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -65,11 +65,7 @@
 #include "task.h"
 #include "probe_roms.h"
 
-#define MAJ 1
-#define MIN 2
-#define BUILD 0
-#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN) "." \
-	__stringify(BUILD)
+#define DRV_VERSION "1.2.0"
 
 MODULE_VERSION(DRV_VERSION);
 
--- a/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h
+++ b/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h
@@ -31,11 +31,6 @@
 /* A => B */
 #define IMPLIES(a, b)        (!(a) || (b))
 
-/* for preprocessor and array sizing use MIN and MAX
-   otherwise use min and max */
-#define MAX(a, b)            (((a) > (b)) ? (a) : (b))
-#define MIN(a, b)            (((a) < (b)) ? (a) : (b))
-
 #define ROUND_DIV(a, b)      (((b) != 0) ? ((a) + ((b) >> 1)) / (b) : 0)
 #define CEIL_DIV(a, b)       (((b) != 0) ? ((a) + (b) - 1) / (b) : 0)
 #define CEIL_MUL(a, b)       (CEIL_DIV(a, b) * (b))
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -277,6 +277,8 @@ static inline bool in_range32(u32 val, u
  * Use these carefully: no type checking, and uses the arguments
  * multiple times. Use for obvious constants only.
  */
+#define MIN(a,b) __cmp(min,a,b)
+#define MAX(a,b) __cmp(max,a,b)
 #define MIN_T(type,a,b) __cmp(min,(type)(a),(type)(b))
 #define MAX_T(type,a,b) __cmp(max,(type)(a),(type)(b))
 
--- a/kernel/trace/preemptirq_delay_test.c
+++ b/kernel/trace/preemptirq_delay_test.c
@@ -34,8 +34,6 @@ MODULE_PARM_DESC(cpu_affinity, "Cpu num
 
 static struct completion done;
 
-#define MIN(x, y) ((x) < (y) ? (x) : (y))
-
 static void busy_wait(ulong time)
 {
 	u64 start, end;
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -43,7 +43,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 
-#define MAX(a, b) ((a) > (b) ? (a) : (b))
 #define NODESIZE MAX(L1_CACHE_BYTES, 128)
 
 struct btree_geo {
--- a/lib/decompress_unlzma.c
+++ b/lib/decompress_unlzma.c
@@ -37,7 +37,9 @@
 
 #include <linux/decompress/mm.h>
 
+#ifndef MIN
 #define	MIN(a, b) (((a) < (b)) ? (a) : (b))
+#endif
 
 static long long INIT read_int(unsigned char *ptr, int size)
 {
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -119,8 +119,6 @@
 #define ISOLATED_BITS	5
 #define MAGIC_VAL_BITS	8
 
-#define MAX(a, b) ((a) >= (b) ? (a) : (b))
-
 #define ZS_MAX_PAGES_PER_ZSPAGE	(_AC(CONFIG_ZSMALLOC_CHAIN_SIZE, UL))
 
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -22,7 +22,9 @@
 #define VALIDATION_DEFAULT_THRESHOLD 4	/* 4MB */
 #define VALIDATION_NO_THRESHOLD 0	/* Verify the entire region */
 
+#ifndef MIN
 #define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
+#endif
 
 struct config {
 	unsigned long long src_alignment;
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -60,7 +60,9 @@
 #define SKIP(s, ...)	XFAIL(s, ##__VA_ARGS__)
 #endif
 
+#ifndef MIN
 #define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
+#endif
 
 #ifndef PR_SET_PTRACER
 # define PR_SET_PTRACER 0x59616d61


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-6.6/minmax-don-t-use-max-in-situations-that-want-a-c-constant-expression.patch
queue-6.6/minmax-make-generic-min-and-max-macros-available-everywhere.patch
queue-6.6/minmax-fix-up-min3-and-max3-too.patch
queue-6.6/minmax-add-a-few-more-min_t-max_t-users.patch
queue-6.6/minmax-improve-macro-expansion-and-type-checking.patch
queue-6.6/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-6.6/minmax-simplify-min-max-clamp-implementation.patch
queue-6.6/minmax-simplify-and-clarify-min_t-max_t-implementation.patch

