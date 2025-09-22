Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3E16CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 12:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3802C8E0001; Mon, 22 Sep 2025 08:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3572B8E0010; Mon, 22 Sep 2025 08:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2996E8E0001; Mon, 22 Sep 2025 08:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1657A8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:27:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CBABB1DFBF3
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:27:22 +0000 (UTC)
X-FDA: 83916811524.02.D111EC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id ECD63180015
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:27:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=V84LpWZQ;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758544040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=Pwq0vWU6SAmNT/gybZVo6jTf2T0D2gqkZ0je4XfPAB8=;
	b=5D2fZMOh1n9muqfe7uk46ABx2rvFF1N3a9EEzejNWkWAInB2BlelIR3QUCe7BljlxNJ/Vv
	uVXItVVWTHERjk/OjxEqHYEQwBLXTNmIdsYRjQ2jec/dJSGvhOrkDTqmMRGNVo0ULdFqBz
	OtifUL8v3/6Od1Ql4yZ1omi+beC1FIs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758544040; a=rsa-sha256;
	cv=none;
	b=fsEPQEwsT/BJ94kHhdOuVPeISLjDtb0J7oO4c4P/fsVq2CRHWBFgBZJ2L+3w1v9NPlJ08S
	a3HCtSwiJTgAVWp6PINESOnYZqgnA4eA75lADa3URVi6qkyK/M+FBOyr0z3GbrWtcQI0lb
	flXlPOgvCa1wT1WZiXnrWQ49meH1Uu4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=V84LpWZQ;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ECE1744F9F;
	Mon, 22 Sep 2025 12:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162ECC4CEF7;
	Mon, 22 Sep 2025 12:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758544038;
	bh=92DBN3bMcFz8vIRdBZNpPrekIoZC1bozepvmjOs0AUA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=V84LpWZQKz0fN+oNTS7CQG+5BaEaSfOrRCwA02aLtlfFAJAXI3Lfnb55+cE1RtZAe
	 TuEEGyHcpkKxuUx+8hQ8++E0yiQ/OlSgOmgOy0cGiSqN/PNkCtehWG2L8Un/Zz4F8E
	 QXWtUhRm+hUsIfl9CZn9LmoqUgFDEnD6xm89KgqM=
Subject: Patch "minmax: fix up min3() and max3() too" has been added to the 6.6-stable tree
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
	luc.vanoostenryck@gmail.com, luto@kernel.org,
	maarten.lankhorst@linux.intel.com, mailhol.vincent@wanadoo.fr,
	malattia@linux.it, markgross@kernel.org, martin.petersen@oracle.com,
	mchehab@kernel.org, mcoquelin.stm32@gmail.com, mhiramat@kernel.org,
	minchan@kernel.org, mingo@redhat.com, mkl@pengutronix.de,
	mripard@kernel.org, pabeni@redhat.com, peterz@infradead.org,
	pmladek@suse.com, qiuxu.zhuo@intel.com, richard@nod.at,
	rostedt@goodmis.org, rric@kernel.org, sakari.ailus@linux.intel.com,
	samuel@sholland.org, senozhatsky@chromium.org, shuah@kernel.org,
	snitzer@kernel.org, sunpeng.li@amd.com, tglx@linutronix.de,
	tony.luck@intel.com, torvalds@linux-foundation.org,
	tzimmermann@suse.de, wad@chromium.org, wens@csie.org,
	wg@grandegger.com, x86@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 22 Sep 2025 14:26:59 +0200
In-Reply-To: <20250922103241.16213-9-farbere@amazon.com>
Message-ID: <2025092259-reprocess-reward-329d@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Stat-Signature: 33a1u6m9xb9fj8nzc3itbbi4wgdtecgu
X-Rspamd-Queue-Id: ECD63180015
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758544039-85140
X-HE-Meta: U2FsdGVkX1+WqnuyJFG7iFpsdYcsOhy3G1lo3DA212ecUEuSx8pdnJL7GoLhEn6oCVfHXqFVqB5Uf4PHE54GYoPD0r+W08h4RybUarlmb3feGiSPTf2z0QKi3LCWCPKjb1t/GW2OQKMW4kdk73FowSXZ/Y2mDKSNf2218sYQikzBWpMTLz5CMMvaj23TUbnoQC/x3qgUtRejW/iF+1Doi1zNwpbgxxcZAitXhBrLMJg0Cxwo1R5iua291oNg7qifMSHXcreMntjhn0pPlZm++tYfkUSyZvT/BZp+dbem/dBFUqFQdRBfEpU40hpHU1/hupMKDJG3D7uuXwu3gYHVwXvEF4EX/3I6/j/+QfRImW9j64QDKd0OGZWUDQOr88S2eQ5ryD4jvZh/TtR1IjdibJ70JCkAEuS2sdgv7rv2jo6EEg+HUAEUxqaimqjEn038qI3ZHLyvmJGvz+iL1vvXC3IB4o8Lx03UalVZ1s3FwsNVazJmo/0HZ10JW/LOmLhiVbcND6BMze+seb99ql5pKJmC22W3nsXFPDp9ZIIBd5T+yd5y1Y+ZrwRrGdlR/iNNQ4nfzBEAr1sciP5QeYgsFqLqc8+nKv4Ns3L81/8qlFgGG8oqHls4iBTgVkIOxgay6j7zxR9xyBmh63Pp1+1HXj493NKxkWjs9xGiek3CLAGcUFGJxcnUBzf9GFawYLUkDXNTqL3NTjw4MJKO703rTUgKIrbO+08x/LtT8nGA2bgVBSB6+wQgaSQ76wguQfOF2ccpl65/Ib9pBymXRWOKp48x8Z0idnxB4SfnDwss49yIX5FCpXSr+wJNliJRth6Z6eQ6axJV77eYFPko2JfwpSLCU6oc32w/nf3Ro0Oa/Z8qgZRp9VELaIG9iHsIkA/9JJV6MPp+txQoPzLPNhGoZ39OfeeVq0gkiK4ujx0A3YE+kA4JZHwOIMgapMu/EKVJZqPYPPCy7K8Ze+8cE6H
 dijs1hGt
 8R78tR8uzUHCn1wouLHq75KcwpBQIJasKorK/L79sqkXIVaOA3mfQYFDi/9emfOJtekiiTQMaI1eYkwf45e0WS4CKyirYAJ+rBM5SWhjxDlb/KAza6b/UKcL+/kfK8VWFtrMy5hRvMkTB5mV4t+rHDGbwWHacMyQZRc8RnKr3P7XiQ2JzV3gcJdVbSykQ68qLX8GmkZQl9DvGDyu180pyIy/uPLahDpxwN612FOv43m3tT3q+zEjHY2nPyCY8OG6yI+AKAjk8pnaJNmXOt6hL/Ds8dIV8Z7yeaUuSdslJrKsMVIMy37Cj5vb1F5sDZOAKdC8S9+qrOdboSpJNqF/2Ms44vW1ySFBNlvM00MKroIFz3DB88ALod+Dgwz4VNn2L45spyXLjztfd+4KqgxuLgncHhZUYr43XUgmRrOSjieLNnpHj/w+mjHPrJrwUwwDeYOWfczzqstw6NqFlmd03S/ggQmiJJh9DDkXbRycS36h2H2pleowygfQ7CLdjgmjK8Ygsr0VeXlvo6PRt0PcDXh4Pa7VCqXQ1eS7hBUMlDidja58R8cMDNsz75kgfLdFsw4uxnD91q5zJHRrMw3h7ClIehJX7WF5JWJZHKr3bHBvSb/unge916yjj1/X6Fj/c8Qp7E+fThmFbqjXVxxN+R4g7YsCEN8Wy5h/RccyCSau2WsYr1d1VpzEnmFcvTCpHk2YBFlMN1wImMF8k356PZ63wS55hm9DY2dkUUmSmlk8J8+q7ty9Z4wc9p0oUV0mTolnO+ILB6h9kfoCl9DCE/Bpu+v+7XAvInQcCfAuqcIKzXvyWAfiX5iKlRBpgG8A+mJl74tFDD86ybAp579byAcMIOcxowzzyCCAGLMbukmiFJ2JQkxViOXdmewUPKFXFqOb5AZLp4UGhTc3gvWL7rSmygV7tbgLnqcUtuQeIjdjXO64iPd+A60CNJcJfPvr8ihJTqHIEJuFZFTm/341gW/6fhFwN
 BP44GrEa
 zxsbofFKebk6BcJwpJr3ARnBuuTaNC4YJ4Mmsei+OeNRNB544UXdit9O1DdkZ33Kt3Q9ScDDzFS/lqdG5lza/Pbda/VKSx+UGN9NMz6KICoIgf1mAG5y8jQi9id/JNsjctAKEonBRDtH5qyjQrvhPkl5SNl7ZGgw/+P24vqjx1RhvFwCx/0r6p7zZz/+q/+6rCLQCWqbzkt+kUlQb3Psmf5MEjlyIiETUAvGUl3OiICb4f/d/PkxK63wTAKfODYnFb+bNbVO0WISkZ0YJ1kCY7O24UDVyb+T7yr9yYEpLpZ8NanlUKsOoQdnvvA/lxH9BnK6QqignKwvEBvHZ2OTyJXRn7Rexk23K7AmynIwwgTe2UE4oGIhb2iDmw/DJaCOcjUIfILkR65/cYExCqigjRJ7OAEYvzYsU45cKKmU8Y+z3ZbsMvG2AEJ+97xjPS3+nXrTrbtRDk+p3xg3v2PsIXSzt7paFeM5tDyhbT6+aUH5mjLWwHsU+ysTFxNneK7FW8Y5i7s0TkbVlqbLdmjJbSSH6+I9JZpC9i6Y+EyFAiJaVvn7ITrio3holy+9r1kdTfp322UmC239QIZ+1tWBzVWg4g3lgD8AGOBfR3RZlVAddzK8kB02dQT9fMl47RxkXKL875S39F2yt8g6eUI5ygZ4WlbmPZkJrVZsFKw9/Sty9sY0WoYL7yZtGtlLsUq0lbewQLEfFo7TaIb17o8AtSM2IXffZHBCPV+3HiUDKs16SbExw9DBbBXn7bcSx/F4wiL2lQ0r9oY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: fix up min3() and max3() too

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-fix-up-min3-and-max3-too.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=353d6d59a=farbere@amazon.com Mon Sep 22 12:37:42 2025
From: Eliav Farber <farbere@amazon.com>
Date: Mon, 22 Sep 2025 10:32:34 +0000
Subject: minmax: fix up min3() and max3() too
To: <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <mchehab@kernel.org>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>, <dm-devel@lists.linux.dev>, <mailhol.vincent@wanadoo.fr>, <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.ne
 t>, <edu
 mazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>, <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>, <malattia@linux.it>, <hdegoede@redhat.com>, <ilpo.jarvinen@linux.intel.com>, <markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <gregkh@linuxfoundation.org>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>, <pmladek@suse.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <senozhatsky@chromium.org>, <minchan@kernel.org>, <akpm@linux-foundation.org>, <dsahern@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>, <wad@chromium.org>, <farbere@amazon.com>, <David.Laight@ACULAB.COM>, <arnd@kernel.org>, <linux-um@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.fr
 eedeskto
 p.org>, <dri-devel@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Laight <David.Laight@aculab.com>
Message-ID: <20250922103241.16213-9-farbere@amazon.com>

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

queue-6.6/minmax-don-t-use-max-in-situations-that-want-a-c-constant-expression.patch
queue-6.6/minmax-make-generic-min-and-max-macros-available-everywhere.patch
queue-6.6/minmax-fix-up-min3-and-max3-too.patch
queue-6.6/minmax-add-a-few-more-min_t-max_t-users.patch
queue-6.6/minmax-improve-macro-expansion-and-type-checking.patch
queue-6.6/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-6.6/minmax-simplify-min-max-clamp-implementation.patch
queue-6.6/minmax-simplify-and-clarify-min_t-max_t-implementation.patch

