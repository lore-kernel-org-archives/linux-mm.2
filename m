Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FD0DCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 12:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6AC28E0013; Mon, 22 Sep 2025 08:27:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1B868E0010; Mon, 22 Sep 2025 08:27:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31B28E0013; Mon, 22 Sep 2025 08:27:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACFE48E0010
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:27:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D6F2C0617
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:27:25 +0000 (UTC)
X-FDA: 83916811650.25.DD70F22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A476A18000A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:27:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=auHdNGKd;
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758544043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=GyJ5Qau0uOpVeX2DlvwO61DIwFdxOWAWMli/csIhwdI=;
	b=pmCSJMW6D0dHNnzHExXmOtG27MAr8uGGIt2ESi8t7O8ppNGEdQtoMVNcwO2ZgQMTOigjG0
	vpdiX877PZr07ac6WhQYKsZ7tMNTvZCTIGlF/wRBRCCL2eH8eq2p5Dmq4lddo8io06UomO
	/TJ1b34chBurjLD7VDT5uG7fErRS6NI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=auHdNGKd;
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758544043; a=rsa-sha256;
	cv=none;
	b=Xm2fJ+LIm2yLOTJyBk3XkACa+0kZNmA6EAYMFMVpH4osWzP3MCU61l8mYifXeYvys0bItd
	gRy734zLjUG+MmustMmsE+XUoAsE4akneHA/WOWegybVjW7H828jd+P4buS3eK2+4OBzM2
	sS7GAq6k95AxtYzGS8RfjafptLd0x6c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B091144F90;
	Mon, 22 Sep 2025 12:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883EFC4CEF7;
	Mon, 22 Sep 2025 12:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758544042;
	bh=ZMR+XjDau2hHGL69Sn0X04f7J8RJUFy2i3TYGZCRJNA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=auHdNGKdLIfbwYh8NdP2suujfhPJ8YS6L5inxw+Jk7nRnEB4aHUltR4l5O9CmTBSx
	 9egeOmiAOoV1ay8sAFv1kwXo/Hbhod87chikVjzqb4FCdyVDa0vFcGxKVGRIi3cmDb
	 OXUShv+pw1mOimuwtjJLHjrROezM5uFdfappdGfg=
Subject: Patch "minmax: improve macro expansion and type checking" has been added to the 6.6-stable tree
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
In-Reply-To: <20250922103241.16213-8-farbere@amazon.com>
Message-ID: <2025092259-dill-okay-e80c@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A476A18000A
X-Stat-Signature: ysig5t36tch6y7ztfnxcyqqn8r4umkda
X-HE-Tag: 1758544043-459393
X-HE-Meta: U2FsdGVkX1+gxX5cFhNPBGEK16G5mzUDC5Z08QJXxxl+h6TXNcpeRemzbjiqFZVHDRdEVYocG19GVAEyuWbYamu+stg8Y54QsyqV6zEPwwJVZdUVppshYiiwYEdolqBZQgZuy8LK9gF7Q9AelAHcLlS0yji3mS8zyWj7T3Tsv92Owel7drp3QPYSwc8/XluiKtVB8BRC/0mKXEoj6AYrvHj0RemkKZ1wEibq4DLFiAiCQwqlGcVWFCmpmNPg/yDMVF12FWOEK5coYKa0qr+rxvaxZuBxAKty111f0rUzWtGTnkkPv443F1vjjf343YhAUobYCa9U43OmYsI9Cf6JMQL0VqhIrckPZ05MaxXQd/hXprE5DDjPWLCljxoWmcYw6ACw9FygoDE2SI4s0r+zcq+udIFrjbdzjBv/ZQ2P7LYWBwdSbeqodnemsRhABWeN67F27X80uaIzhCrU05xTCHEQGo9Thj8eDpd6WNyFqcTIJy/6EEpXSWOOcwLgz/fkaF8umFu18mrhPWH4LYhgiShjs98q3WzOBKrAC7JU5eIln39AN8XR8hwXp8P9GLLJGcHbq/RxmTYXIX/fSvBSjjp4/0A1HkuBDzGX+OOEGEmKSqBGoNyXD2+ApoGWZ+WBiwTWNpeb9VPlev3nRG97Ze7aQv3JWOL/SphmKXeb6saLQQdIvFxiS4wUCu6IMxWaxYDQ4IK7hea8nvYipyc2WurxbU0JDzivA0yjgLtWmmYGWMuoO3YVw7dya6nxEXEelezyoFmfiiyK3UTjDgCjUtM3XLcR7Ml5MINeiP+so8CZOFTvITJ46DS41AhvqsH8Sbw2aTjj8IH6v9ddDNRAHHpCZEm1qTGIawvfAIG50rDZ0Vcz09lcFr2RBwN3v9XDs9PPAXAwdYP7owkS39vHNvJnwXwzdf5vZA2zEGFQvOExowDLT/LA0iPcsRUIm6yEzCPiiGmfpqhsqrXE7Ci
 3r9YU4rX
 i6SeD/OFZGF1/QBG8FQTzq113GpvI1DNWdI0EcOAgnolPG0vnpfruMfuR3s6Fok+stf981PLFFOwdf5wjim9/ue4YMXBZxedtoW0S80IDF8UN+jRo5zgqjh+TXffaa0zDrsC/3L/Txc6u2mJKOygWpJV5r1+YJuL1P4T3Tlql9WKSo379ykFZwBFAG7JeF65mwmc/LimB1P87j9YXBhJn/g4Wz211buSkz6IIyyqP/wXFxBIkUnjceSGfzb26jlFK8/KMXUyo6zmotlPN6cRB5stcamQj9WUZnAy6Lzx6sjyVyv7fgKUH1SK8CJ/bU1rv1PzghFG8bzY+wT6E0Wm9TpOJkZqyTSDVOkB+SzQPMZqWCjWPgrcnKoDD7lwv7kItiax+2Rdk+Y4gntvYSK7AeS31y0mf7dYpRSqsUK+K6brK0UaSe3k34AHDKndeF/Fm3hfNHyEcYV3zSFYeXJrtpMgaO7TZDc5PpqGbMfrySgOCSRiaCCVmSiwQLfyiofSYk1OcDO7UzF56DVPZTKonbgk7kiJl1nOj9rcZ8Av3+jxC5IEJ0nc+sl8n4SBfzaAY0DLNkOq2vW7pkU6nQfZofazW9FlRAkvvyq3Fp/LlqSkfO6bzakcZIzEAFxqJhNNoFh4HZ1i5gy9qLrFVc2eU5ZuuUDsD4zgYpKd0Ftb4wDxpWRmP+5bCHMpVh8wwNqprMECAjKmArSx9hUfRmN7zw28nmEOIUxOLjeagbC9kH4s/zFREh2mgHZFSDR+Qdn0fDtfbZ31TPPr6dDHa4uTakgPxkJySAn1JMnCkhU/UCFl2ASBESZ/H4lNACa1MV5SLMJXBkSDgWmyawz0W5AoEthIGRrUbaLB2sqDo2sSt9RrpyA9mCMIeazK7cYQJLmDwHLxu23Py+awWZaXJsXRq/wlZif17Vt8OIDhxyaKAMUHREUezp65enzlF7mYwpGEx4GAMbUApw/goUKdKe6O2K9xLUBZS
 jfoSGybQ
 prmVYBkgFpkazhnnRCrLO3DN0BGQrPPsKkAAjHqi8tsTopL7SEZSjvf5NtVEV7cN2tKT8HhI4m/TRJttff1LfLAUdC9ZdRr59iHGaUdWRTOOoAiJuLlvNeW1fe5r80+tf0/DO3EBR/Byo1n9DBDgVN7dHYu+eULK1g59tREb3M5ineYlET1nDoy3D/Mx1YvgepqaTeN6tBtaahhQ8mJI92dDidcOuWsBuRv7gxpGKDZDwumk98iIITz1rI83/rticZRPNmK4iuTIu39USPI3IBwXJ2O0kLvt4IEMiMwPvDk7Z4CS2jS0p6wcy8wB7XI+kMLgu9U/WARPZLg6sTIU42tpI0d3zYH34HWg9qCQs/342yAHUnWSYpnZZ7Jf5q4S70lu62SAN1wjnJJj/iAPX1nL2QUtV9FnLzfJTfrs1jNOe7DWBw3KoXn9UCTYmmYMhYJy/yaV3NhDpcgyZ0/t+ZmSTU5fb4TwS4LzPmqcAuMQJvMMQ3IpLXdttmzbm+I/gpoBiAy5HeslYP5MYLWAI6xNiFcrlLXZNw9WPZirksdXqC5yfUXW+N3VjJrXsinOBOG9tO70mO5mVHk1tReHJv7R77KRPWbQ1b1vi848osI3SYxKDp4/2YgzqXmuVAE2oKZB93BMy4BzJuSmBPIh0JIh/MKbQPYBwYc64qKBDrfV6+S0WTfpTta6IEdV21SUwGKnWvvLocH53Sa90WgQcYo8f9KF0p/6NXlx/mCDZ9f4NtTzQb4Zwk1lxuUF7SVf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: improve macro expansion and type checking

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-improve-macro-expansion-and-type-checking.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=353d6d59a=farbere@amazon.com Mon Sep 22 12:36:39 2025
From: Eliav Farber <farbere@amazon.com>
Date: Mon, 22 Sep 2025 10:32:33 +0000
Subject: minmax: improve macro expansion and type checking
To: <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <mchehab@kernel.org>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>, <dm-devel@lists.linux.dev>, <mailhol.vincent@wanadoo.fr>, <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.ne
 t>, <edu
 mazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>, <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>, <malattia@linux.it>, <hdegoede@redhat.com>, <ilpo.jarvinen@linux.intel.com>, <markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <gregkh@linuxfoundation.org>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>, <pmladek@suse.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <senozhatsky@chromium.org>, <minchan@kernel.org>, <akpm@linux-foundation.org>, <dsahern@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>, <wad@chromium.org>, <farbere@amazon.com>, <David.Laight@ACULAB.COM>, <arnd@kernel.org>, <linux-um@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.fr
 eedeskto
 p.org>, <dri-devel@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Laight <David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Message-ID: <20250922103241.16213-8-farbere@amazon.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 22f5468731491e53356ba7c028f0fdea20b18e2c ]

This clarifies the rules for min()/max()/clamp() type checking and makes
them a much more efficient macro expansion.

In particular, we now look at the type and range of the inputs to see
whether they work together, generating a mask of acceptable comparisons,
and then just verifying that the inputs have a shared case:

 - an expression with a signed type can be used for
    (1) signed comparisons
    (2) unsigned comparisons if it is statically known to have a
        non-negative value

 - an expression with an unsigned type can be used for
    (3) unsigned comparison
    (4) signed comparisons if the type is smaller than 'int' and thus
        the C integer promotion rules will make it signed anyway

Here rule (1) and (3) are obvious, and rule (2) is important in order to
allow obvious trivial constants to be used together with unsigned
values.

Rule (4) is not necessarily a good idea, but matches what we used to do,
and we have extant cases of this situation in the kernel.  Notably with
bcachefs having an expression like

	min(bch2_bucket_sectors_dirty(a), ca->mi.bucket_size)

where bch2_bucket_sectors_dirty() returns an 's64', and
'ca->mi.bucket_size' is of type 'u16'.

Technically that bcachefs comparison is clearly sensible on a C type
level, because the 'u16' will go through the normal C integer promotion,
and become 'int', and then we're comparing two signed values and
everything looks sane.

However, it's not entirely clear that a 'min(s64,u16)' operation makes a
lot of conceptual sense, and it's possible that we will remove rule (4).
After all, the _reason_ we have these complicated type checks is exactly
that the C type promotion rules are not very intuitive.

But at least for now the rule is in place for backwards compatibility.

Also note that rule (2) existed before, but is hugely relaxed by this
commit.  It used to be true only for the simplest compile-time
non-negative integer constants.  The new macro model will allow cases
where the compiler can trivially see that an expression is non-negative
even if it isn't necessarily a constant.

For example, the amdgpu driver does

	min_t(size_t, sizeof(fru_info->serial), pia[addr] & 0x3F));

because our old 'min()' macro would see that 'pia[addr] & 0x3F' is of
type 'int' and clearly not a C constant expression, so doing a 'min()'
with a 'size_t' is a signedness violation.

Our new 'min()' macro still sees that 'pia[addr] & 0x3F' is of type
'int', but is smart enough to also see that it is clearly non-negative,
and thus would allow that case without any complaints.

Cc: Arnd Bergmann <arnd@kernel.org>
Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler.h |    9 +++++
 include/linux/minmax.h   |   78 ++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 70 insertions(+), 17 deletions(-)

--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -245,6 +245,15 @@ static inline void *offset_to_ptr(const
 #define is_unsigned_type(type) (!is_signed_type(type))
 
 /*
+ * Useful shorthand for "is this condition known at compile-time?"
+ *
+ * Note that the condition may involve non-constant values,
+ * but the compiler may know enough about the details of the
+ * values to determine that the condition is statically true.
+ */
+#define statically_true(x) (__builtin_constant_p(x) && (x))
+
+/*
  * This is needed in functions which generate the stack canary, see
  * arch/x86/kernel/smpboot.c::start_secondary() for an example.
  */
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -26,19 +26,63 @@
 #define __typecheck(x, y) \
 	(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
 
-/* is_signed_type() isn't a constexpr for pointer types */
-#define __is_signed(x) 								\
-	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
-		is_signed_type(typeof(x)), 0)
-
-/* True for a non-negative signed int constant */
-#define __is_noneg_int(x)	\
-	(__builtin_choose_expr(__is_constexpr(x) && __is_signed(x), x, -1) >= 0)
-
-#define __types_ok(x, y, ux, uy) 				\
-	(__is_signed(ux) == __is_signed(uy) ||			\
-	 __is_signed((ux) + 0) == __is_signed((uy) + 0) ||	\
-	 __is_noneg_int(x) || __is_noneg_int(y))
+/*
+ * __sign_use for integer expressions:
+ *   bit #0 set if ok for unsigned comparisons
+ *   bit #1 set if ok for signed comparisons
+ *
+ * In particular, statically non-negative signed integer
+ * expressions are ok for both.
+ *
+ * NOTE! Unsigned types smaller than 'int' are implicitly
+ * converted to 'int' in expressions, and are accepted for
+ * signed conversions for now. This is debatable.
+ *
+ * Note that 'x' is the original expression, and 'ux' is
+ * the unique variable that contains the value.
+ *
+ * We use 'ux' for pure type checking, and 'x' for when
+ * we need to look at the value (but without evaluating
+ * it for side effects! Careful to only ever evaluate it
+ * with sizeof() or __builtin_constant_p() etc).
+ *
+ * Pointers end up being checked by the normal C type
+ * rules at the actual comparison, and these expressions
+ * only need to be careful to not cause warnings for
+ * pointer use.
+ */
+#define __signed_type_use(x,ux) (2+__is_nonneg(x,ux))
+#define __unsigned_type_use(x,ux) (1+2*(sizeof(ux)<4))
+#define __sign_use(x,ux) (is_signed_type(typeof(ux))? \
+	__signed_type_use(x,ux):__unsigned_type_use(x,ux))
+
+/*
+ * To avoid warnings about casting pointers to integers
+ * of different sizes, we need that special sign type.
+ *
+ * On 64-bit we can just always use 'long', since any
+ * integer or pointer type can just be cast to that.
+ *
+ * This does not work for 128-bit signed integers since
+ * the cast would truncate them, but we do not use s128
+ * types in the kernel (we do use 'u128', but they will
+ * be handled by the !is_signed_type() case).
+ *
+ * NOTE! The cast is there only to avoid any warnings
+ * from when values that aren't signed integer types.
+ */
+#ifdef CONFIG_64BIT
+  #define __signed_type(ux) long
+#else
+  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux)>4,1LL,1L))
+#endif
+#define __is_nonneg(x,ux) statically_true((__signed_type(ux))(x)>=0)
+
+#define __types_ok(x,y,ux,uy) \
+	(__sign_use(x,ux) & __sign_use(y,uy))
+
+#define __types_ok3(x,y,z,ux,uy,uz) \
+	(__sign_use(x,ux) & __sign_use(y,uy) & __sign_use(z,uz))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -53,8 +97,8 @@
 
 #define __careful_cmp_once(op, x, y, ux, uy) ({		\
 	__auto_type ux = (x); __auto_type uy = (y);	\
-	static_assert(__types_ok(x, y, ux, uy),		\
-		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
+	BUILD_BUG_ON_MSG(!__types_ok(x,y,ux,uy),	\
+		#op"("#x", "#y") signedness error");	\
 	__cmp(op, ux, uy); })
 
 #define __careful_cmp(op, x, y) \
@@ -70,8 +114,8 @@
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	static_assert(__types_ok(uval, lo, uval, ulo), "clamp() 'lo' signedness error");	\
-	static_assert(__types_ok(uval, hi, uval, uhi), "clamp() 'hi' signedness error");	\
+	BUILD_BUG_ON_MSG(!__types_ok3(val,lo,hi,uval,ulo,uhi),			\
+		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
 #define __careful_clamp(val, lo, hi) \


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-6.6/minmax-don-t-use-max-in-situations-that-want-a-c-constant-expression.patch
queue-6.6/minmax-make-generic-min-and-max-macros-available-everywhere.patch
queue-6.6/minmax-fix-up-min3-and-max3-too.patch
queue-6.6/minmax-add-a-few-more-min_t-max_t-users.patch
queue-6.6/minmax-improve-macro-expansion-and-type-checking.patch
queue-6.6/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-6.6/minmax-simplify-min-max-clamp-implementation.patch
queue-6.6/minmax-simplify-and-clarify-min_t-max_t-implementation.patch

