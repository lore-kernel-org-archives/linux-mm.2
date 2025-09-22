Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6724BCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 12:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DF1F8E0008; Mon, 22 Sep 2025 08:27:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B63B8E0001; Mon, 22 Sep 2025 08:27:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2E58E0008; Mon, 22 Sep 2025 08:27:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C59A8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:27:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCEB1B857E
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:27:06 +0000 (UTC)
X-FDA: 83916810852.22.9FA2A25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 165564000A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:27:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=Yfqpe51j;
	spf=pass (imf04.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758544025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=TKplYA7PoGq5dLWvUNWzasOnKvm4A+PUborBsAxiVM0=;
	b=AtuVZddpkxwWLdwkkMeextYm9i/Wo0nLKfhLpdjT5+SgQKr3p/UKI6GTmRPJEM2wt7f6oC
	v4bd5RUSHCPDvscl76mA41x6zyzLdD5uhhAfgCqjGgd/8Se5zxex2ZAbuldkLQVEcYan2U
	ssUsQZ7MFo4/0go7h9ZDPc7goC0NnxM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=Yfqpe51j;
	spf=pass (imf04.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758544025; a=rsa-sha256;
	cv=none;
	b=NMUfdmWjqSJ25+xzTZvAdU0UPp6o1uKE22btM98GhGXuqx9fZCZ3iUhst5NUHnQhzhZgWC
	npOn9RRA7zx/DUdXBdqw4csKozJds2lHRlwHSFwtcYD/h5Un+dULupdctCnPXdSLS4+J73
	MdAHx1o73mR01WnOXcgo7tphKySHzXA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C7B506021D;
	Mon, 22 Sep 2025 12:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D6EC4CEF0;
	Mon, 22 Sep 2025 12:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758544023;
	bh=xiUh1J9UQXNTnI2lGZhy5P5VMsOMixvNygGiduLod8o=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=Yfqpe51j1Oxd6OVCe4gaU9NrSSTPt0fCKcmKbD2t14pKJhHg80s5S9kKbPAlJ9Wa8
	 zWQjuJ3ud+OrF55xVic6wSDiMjBwhnf4ivhaC3sVrQpdlEQ7bHrvbVouIdimz6nJPd
	 XPvcQnFrb+/gwTGAgufNqkGIjE+ZAkve0ikMeXMw=
Subject: Patch "minmax: add a few more MIN_T/MAX_T users" has been added to the 6.6-stable tree
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
Date: Mon, 22 Sep 2025 14:26:59 +0200
In-Reply-To: <20250922103241.16213-4-farbere@amazon.com>
Message-ID: <2025092259-swimwear-glorious-ec5f@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspamd-Queue-Id: 165564000A
X-Rspamd-Server: rspam05
X-Stat-Signature: p9h44oiw7ywzfyrzitq11j11tqoat58h
X-Rspam-User: 
X-HE-Tag: 1758544024-868883
X-HE-Meta: U2FsdGVkX19VzKxEwtUuBQaCjWSTgacNZ7bBT5pG0q9JVSz2RE+q4bDfBhyekrfHONDQKijPVtDKNfzX0CZMuBuEYL/tKNI1jtwx00NhW+/kstjNDrIj8WyE3GeIB95TOyAZRvDRm60lW0o40ojlonTJhQ+H3DubU1QRZzqT3GvHWQx78k1TXchJewEK9TCpVpTynHX18etttUSJRspnHQtTMYsErAkeDTM1WOltZ8leSSufPknrue6uCkTebHZID+mUzOOfantFc9qIbYs5+GvHZa7JL1xt7BcH2USoYlxqfJ++FZ8CbSXHjGOu1z4kmO+oA84u3lqGk2BKeCC8AVNWk/TdwsH0qsImJGXZ8vs8OFWYK7fZnzhA8qzIHVU/8yTlKYnO0RIcNNjQMrpJNN2ZeaUMCWvYzUOL+R9PPHTdku4JSIqUOIWe7AuvwqAgHxT+amxjwO6F+HRIHbIkwD+2bkrWWXUTwvNejg4AGmHpGTuHWd0rsscksf79M16RRFWQoYIZWK8YgWIooexnFNpygYN4XCdUBvzQQ55+PWPE8YfJw0qUAp5pl9rVtcPVhd/X6VAnSpHGaK/bpKCaUcrudFV+32wSE+8zUBzsdMBxRcUTCE7pFn5l1aE81Lp5jFb0hc5003ydaDVpyubxFycQYOuMmExLEcw2xu7OjcqUHsCHFQOJ7qQFn/d0hM3cx3jjG8bxVXnREY7BudOFA7qqcOc8FyS5xni8FjINacKPqDhYLWmGcvBMy5BjGmKF8IVSgxZvqByTiZMdAJf1iLpuuw/nMa7aeoOTJLVfcw0D2Tcw1KBmFPoTG75qctbhhSDXhVi1qz/sZCkCVaBqQh7g3zJn5j8/W7hq1f1q89GsW4L5obB0VTBFBJyegjp2byqoMnq2ZE1Tbr/R1Z/+lJjwT8IhahNreppIq2CPvZnPn97ALNPjO1clvjRHSORNSyD76y5d5cjyohxA9eL
 u7jMSxVA
 4gRDXGUdmpngFo95xsK4PCekz2VkkcYUpNv2yDXtP7LJg6Tyu/pyMbYPPWQrtAfxsnYhji5Nzs33uj8oxYHrUxNErYq8NWL6o9ANiwjRwFzkcpDuqY6J8HVl11X0FlJLwKOeMwQ041JCbb6AIML6U2Lh8FB60VvzoyAG7z1DDj/jwd/CNa5ZPGault0J88CRBCWttr1YQXRKgSv5ikgU8OV/8hTSmq/2refp+Mc23ozAYaMpxQiBsXxG19NXVtRVG1qSJhIUmggKnQbWL1OrjuNgF6lZ4lG6ufeJ9PuwOCsT4aFNp3XUpZgdqGuD+ILpfcD6rF8WzCYjmEAWW6cgHq6eNncMRgocNOQnAIPaargqAZ2iabhs0q9H+1M8RZGrzxa4PN5YFKWlMnL3qxIQgfCkR7iBJHaNtcb/Bxzd1sSIiGp/cYi7cIeV3WGhVsfS0u+NKjzf+9LSUSQwNqbGyfwJjWFFlpwcu3SMqmB0FapUx7i8JlOn9zmeUJzhLafT1u62A1QKD6869x1KaD28tiEVXJPkABHdDwdW+VMHKvnw8P1envGn1L7ZPA86V173k8acz7ktWQgSpuEuuDBM3DnFxsb7nupxh20XFJufb8XDMK3vzWwZbgDNQEtEZoIbmG3DI4Yc/+4j/YU6ED2eZ58Bx7kYp00KWCHn1iWTcPPZfpbVfhgJ9t3eEM/xe0SFQd436DHMTGxcRlyoSJpMnDaaoGO6cJru8EoTHzVkktptnrX9P4pwkiacBjsPc4BZBHxyyLn1geCZ+FdCWrYBTC8x+mJQHsb0shWZ8/fiv2ZsFKRSix42HpxsX+S4aUbnLqP2Or2sgsj6Vl5zAnUHPvn7yEv/GwZ4+2go7Rzp/DsbwhGSGvUr4Z8mdqqdsAzJUwb/C2XaytUs6X+uE+2x2r2yMSWjGJuiiQSadlfns9QaKT/0TN5sWcL8Y12fXmuLmA3xMKlnWcyCDnPHjeCsQnScru0+Z
 BimGc4Ee
 9U3O9dX2gFZ171ZJRBd5p60vEfF4qLmvWiVe/PkzMgg19sbvXE/gdIwF5wGQ3JnFgbnWVTVMAtbJwaeeoUxZiF8RLkT6Wk44XdDf7bEU110KDjwYIbzUxFy8JuvkFcoFeGM0AKSIYIois0ruhRE6Gtvz9EhMVXveQMHXq6hSZDqDGaEODh6vjT4BdCYzECjzj4KV2XzGVfe364mz4do4pWer2WZ25aHBOqAtCChuzgrH8tpjvCICsLgHOrYn6GSkDEmi80ZG7jbq6torAYX5qMY7jR/vKFfEt9zPD80vLoZFxlLQyuxjBm6UDerva8vNJIJrWfmcrzAUt73787AoofQRue/WJ1MPZF6siURh4rxY37nPb5m9vYJ7KsKRxrzohED3TrqH4R7oRuF0WkXU5scaoZIhwVHFrntjPgacviOfv26mVF8vNeAUQ9fNpCZELsBwauMDahXE9sebx1zO/iAEN2QXTQZD/3ox6KCdWHFz/+elRJKoPR+b2MlhCJNyfmc5KpgC03JXzEnHha5FWBZL7Ft06GDTOsbJROUWdt1dGGcD4qnIBX9ULqSxwLGrZ0Mp4RZkG8VDNdnZNCzVLH41jVTqNyOVOa/1R0Or0rAzd5J1OvGKnbD40JYFw8dWiuraSuAtWqY6gOGyi4rOysAmkrpjtUIHL/X1N56l8IPYfwCljIUAQAeuZJfAndwiJteVsV/yiriFwSdOPqKoX+k6gxztk3efxoOey5CUVWjLloN71cDGkruHEyao+3jENWGGPX77IoCHT5vy1lbqsF4+7JRvMHFqJCNRo4a0ZEIr3rI5KBojrQGd4BwLbUWqcosPOmYtnnNDM4tr+42gPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: add a few more MIN_T/MAX_T users

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-add-a-few-more-min_t-max_t-users.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=353d6d59a=farbere@amazon.com Mon Sep 22 12:34:49 2025
From: Eliav Farber <farbere@amazon.com>
Date: Mon, 22 Sep 2025 10:32:29 +0000
Subject: minmax: add a few more MIN_T/MAX_T users
To: <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <mchehab@kernel.org>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>, <dm-devel@lists.linux.dev>, <mailhol.vincent@wanadoo.fr>, <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.ne
 t>, <edu
 mazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>, <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>, <malattia@linux.it>, <hdegoede@redhat.com>, <ilpo.jarvinen@linux.intel.com>, <markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <gregkh@linuxfoundation.org>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>, <pmladek@suse.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <senozhatsky@chromium.org>, <minchan@kernel.org>, <akpm@linux-foundation.org>, <dsahern@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>, <wad@chromium.org>, <farbere@amazon.com>, <David.Laight@ACULAB.COM>, <arnd@kernel.org>, <linux-um@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.fr
 eedeskto
 p.org>, <dri-devel@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Laight <David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Message-ID: <20250922103241.16213-4-farbere@amazon.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 4477b39c32fdc03363affef4b11d48391e6dc9ff ]

Commit 3a7e02c040b1 ("minmax: avoid overly complicated constant
expressions in VM code") added the simpler MIN_T/MAX_T macros in order
to avoid some excessive expansion from the rather complicated regular
min/max macros.

The complexity of those macros stems from two issues:

 (a) trying to use them in situations that require a C constant
     expression (in static initializers and for array sizes)

 (b) the type sanity checking

and MIN_T/MAX_T avoids both of these issues.

Now, in the whole (long) discussion about all this, it was pointed out
that the whole type sanity checking is entirely unnecessary for
min_t/max_t which get a fixed type that the comparison is done in.

But that still leaves min_t/max_t unnecessarily complicated due to
worries about the C constant expression case.

However, it turns out that there really aren't very many cases that use
min_t/max_t for this, and we can just force-convert those.

This does exactly that.

Which in turn will then allow for much simpler implementations of
min_t()/max_t().  All the usual "macros in all upper case will evaluate
the arguments multiple times" rules apply.

We should do all the same things for the regular min/max() vs MIN/MAX()
cases, but that has the added complexity of various drivers defining
their own local versions of MIN/MAX, so that needs another level of
fixes first.

Link: https://lore.kernel.org/all/b47fad1d0cf8449886ad148f8c013dae@AcuMS.aculab.com/
Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pgtable.c                             |    2 +-
 drivers/edac/sb_edac.c                            |    4 ++--
 drivers/gpu/drm/drm_color_mgmt.c                  |    2 +-
 drivers/md/dm-integrity.c                         |    6 +++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 +-
 net/ipv4/proc.c                                   |    2 +-
 net/ipv6/proc.c                                   |    2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -107,7 +107,7 @@ static inline void pgd_list_del(pgd_t *p
 #define UNSHARED_PTRS_PER_PGD				\
 	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
 #define MAX_UNSHARED_PTRS_PER_PGD			\
-	max_t(size_t, KERNEL_PGD_BOUNDARY, PTRS_PER_PGD)
+	MAX_T(size_t, KERNEL_PGD_BOUNDARY, PTRS_PER_PGD)
 
 
 static void pgd_set_mm(pgd_t *pgd, struct mm_struct *mm)
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -109,8 +109,8 @@ static const u32 knl_interleave_list[] =
 	0x104, 0x10c, 0x114, 0x11c,   /* 20-23 */
 };
 #define MAX_INTERLEAVE							\
-	(max_t(unsigned int, ARRAY_SIZE(sbridge_interleave_list),	\
-	       max_t(unsigned int, ARRAY_SIZE(ibridge_interleave_list),	\
+	(MAX_T(unsigned int, ARRAY_SIZE(sbridge_interleave_list),	\
+	       MAX_T(unsigned int, ARRAY_SIZE(ibridge_interleave_list),	\
 		     ARRAY_SIZE(knl_interleave_list))))
 
 struct interleave_pkg {
--- a/drivers/gpu/drm/drm_color_mgmt.c
+++ b/drivers/gpu/drm/drm_color_mgmt.c
@@ -532,7 +532,7 @@ int drm_plane_create_color_properties(st
 {
 	struct drm_device *dev = plane->dev;
 	struct drm_property *prop;
-	struct drm_prop_enum_list enum_list[max_t(int, DRM_COLOR_ENCODING_MAX,
+	struct drm_prop_enum_list enum_list[MAX_T(int, DRM_COLOR_ENCODING_MAX,
 						       DRM_COLOR_RANGE_MAX)];
 	int i, len;
 
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1794,7 +1794,7 @@ static void integrity_metadata(struct wo
 		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 		char *checksums;
 		unsigned int extra_space = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
-		char checksums_onstack[max_t(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+		char checksums_onstack[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 		sector_t sector;
 		unsigned int sectors_to_process;
 
@@ -2073,7 +2073,7 @@ retry_kmap:
 				} while (++s < ic->sectors_per_block);
 #ifdef INTERNAL_VERIFY
 				if (ic->internal_hash) {
-					char checksums_onstack[max_t(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+					char checksums_onstack[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 
 					integrity_sector_checksum(ic, logical_sector, mem + bv.bv_offset, checksums_onstack);
 					if (unlikely(memcmp(checksums_onstack, journal_entry_tag(ic, je), ic->tag_size))) {
@@ -2638,7 +2638,7 @@ static void do_journal_write(struct dm_i
 				    unlikely(from_replay) &&
 #endif
 				    ic->internal_hash) {
-					char test_tag[max_t(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+					char test_tag[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 
 					integrity_sector_checksum(ic, sec + ((l - j) << ic->sb->log2_sectors_per_block),
 								  (char *)access_journal_data(ic, i, l), test_tag);
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2841,7 +2841,7 @@ static void stmmac_dma_interrupt(struct
 	u32 channels_to_check = tx_channel_count > rx_channel_count ?
 				tx_channel_count : rx_channel_count;
 	u32 chan;
-	int status[max_t(u32, MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES)];
+	int status[MAX_T(u32, MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES)];
 
 	/* Make sure we never check beyond our status buffer. */
 	if (WARN_ON_ONCE(channels_to_check > ARRAY_SIZE(status)))
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -43,7 +43,7 @@
 #include <net/sock.h>
 #include <net/raw.h>
 
-#define TCPUDP_MIB_MAX max_t(u32, UDP_MIB_MAX, TCP_MIB_MAX)
+#define TCPUDP_MIB_MAX MAX_T(u32, UDP_MIB_MAX, TCP_MIB_MAX)
 
 /*
  *	Report socket allocation statistics [mea@utu.fi]
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -27,7 +27,7 @@
 #include <net/ipv6.h>
 
 #define MAX4(a, b, c, d) \
-	max_t(u32, max_t(u32, a, b), max_t(u32, c, d))
+	MAX_T(u32, MAX_T(u32, a, b), MAX_T(u32, c, d))
 #define SNMP_MIB_MAX MAX4(UDP_MIB_MAX, TCP_MIB_MAX, \
 			IPSTATS_MIB_MAX, ICMP_MIB_MAX)
 


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-6.6/minmax-don-t-use-max-in-situations-that-want-a-c-constant-expression.patch
queue-6.6/minmax-make-generic-min-and-max-macros-available-everywhere.patch
queue-6.6/minmax-fix-up-min3-and-max3-too.patch
queue-6.6/minmax-add-a-few-more-min_t-max_t-users.patch
queue-6.6/minmax-improve-macro-expansion-and-type-checking.patch
queue-6.6/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-6.6/minmax-simplify-min-max-clamp-implementation.patch
queue-6.6/minmax-simplify-and-clarify-min_t-max_t-implementation.patch

