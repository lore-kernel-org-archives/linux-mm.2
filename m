Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5EFDCAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 12:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3F78E0017; Mon, 22 Sep 2025 08:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BBB78E0010; Mon, 22 Sep 2025 08:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8488E0017; Mon, 22 Sep 2025 08:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 106068E0010
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:27:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C46EC8765C
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:27:29 +0000 (UTC)
X-FDA: 83916811818.19.7825C9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id CBF914000D
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:27:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=JcqUJiPm;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758544048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=/sG3GUfeKJdQQup9e/nzUtUWCYFuY0pXcpT0o7R383o=;
	b=xp46Y5Rc6hxxeQsBws658bov1clZ5ZGPSXrZDLyzAWQnLWjiRtkQDBMn2CTs9Q4Tur1jPA
	vefKjP/5g+0CQH/axJ1SSCz6fGbAvjXkIHHtX8oFursABEsnGn8KQ6ZSyTfBdSsXiif1QF
	8/Ois4WP6aK/ecoXm5BrtwLKYDIo6Kc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758544048; a=rsa-sha256;
	cv=none;
	b=MMOP5cmic1LH/ZlBzQit9PNMG155phAtR2BCUuT6lSLaLQ2xghOnCAWIIvVGgpRU3jUG0A
	WsSa/XEY3hD4sT2tW//VMpz1aMRUzk53m/FqHJyItm3WYybeazf+NwqsmTp8TXpapXzpUF
	bOXDmV2M8HpQ3+TwAZj04lSWlKpwxxE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=JcqUJiPm;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DE4E843D19;
	Mon, 22 Sep 2025 12:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C696C116B1;
	Mon, 22 Sep 2025 12:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758544046;
	bh=7ocyK+3FzD6V+C25dQYZW41KRJc+fHbACGeGMEnQN5g=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=JcqUJiPmkQt1Wtj2boeGm6ynazYCaFwP45kTBA1K5E5xobdGe3n9FRj63J43/elTW
	 HCLEbRA43DsEy3HdMnu2rRRllp49AB/iHuVJ21d7sKfRruRksjsqvPf54ywINOqxuj
	 2/4brXazhZ6QCJ9bWcIIzfmWngrTXftz2POrLXmk=
Subject: Patch "minmax: simplify and clarify min_t()/max_t() implementation" has been added to the 6.6-stable tree
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
In-Reply-To: <20250922103241.16213-3-farbere@amazon.com>
Message-ID: <2025092200-backache-provolone-1ed1@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Stat-Signature: 74i3wq7mdjojsjmozacmdjukbem8ksiu
X-Rspam-User: 
X-Rspamd-Queue-Id: CBF914000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1758544047-630365
X-HE-Meta: U2FsdGVkX1/R3uGP1clPGzi5PkpnwK8Hpu+nDxUKYA26wFYT2U4U/dS+YYbtw9fIxuvFNqmQ6+/YFxHWSGhjKkrKTOO/RDpJfnl41bc8gZEd2hkyn/i/YDW6pFqVqrB/2pdlusLHaRPFtJG83NaiSVI4YsKoK6rMwNwE6yNdh9Dj2bh1GTg5ow5UPMExdzKNMCgaDiTS/LVi8Uq1IZ0NXPnozv0YYF9JukQ1+YSGmxjifms6kI1DvUYZ+EpcPDbb1snWNOSwffJSX/V/oEs3MEgW+Ws+aPJO7ahgJZic95bW5mMhbTCC8hGeSzihWJW9ZAeWu+p5GQM3kHVqSd3mQl3dBKQf/XcIf66Fi5UnedcuoUWC2DdHnCaoYowX81CU6W8db1YCFAkhfcXobtg1t5UkchfURA7b15Thqx25d+Rf9Wh27/6NGTrAOz/+5cWCTiD9ZIGBC0A92cfy23qdhHDfVzwcmfLGNBjDCpyd9uolslFtRcescLjINSocx0gI+IyYo/ioi18xhQhPDoeS9rKwPFg4ZzoNK6F0xnvV5ioj0wx0bKhTR37egwnXURNE/6yr42gSm6b0gqyPWjylmsWCJI9h7TKGAIxSbSAs+Pp9f469upKY6RLPXWXU2sxt0vihsQ60mXVuqbcz9AmDKhdjlVwAZY51bGWKjn2o/hjQ7wHGLRITqo/eTV8OdqCFQD8wz1ybFGh3XYIqlVN37zONeh0/WESe6eP5djBw0tWttCIbPiNx/7PmgHbDFcOWXVokR9Fp31QT0Lb3Vl7O+2dxpJIFxBJcmXYUs8XvoAXPuawO61b1jb42GLAL0CKEDGUo6D7kC0SYPzeo7/swPSGmgSNhg5J/04GJV5F2b4WWn7K2PTIq5OySD4ScQFjj1Jg2anmzaDflZU0DNb5rHMl9D0jhTnARJWri2/kw/7WnbwC09sxLuMNnqIMqrZwIIYXjpJkHB5k4+kLC+ly
 U/w+6pQm
 UDuUv5GdFLCtx5ua3dAUlhfI6Td6Aqg+ybIB59v0i59TcAB5uKH75bJ7uI359bmIHhvIeonkk4MggHdeZ5rAAJmqh2kh1PYyCIG2UZ0ytvo8I3NuPITr7hpQYuYZMGwt7TTIcBgeCamjq1vzNhdSUjG6M6qaary6S84tURzsHt0NtdS6qeHJEPjSY5gGLpOUF5RIzypXimynUw1KowrHbpGk6NwZmZZ3mLxRYCOtDPaUmFJZjMWT+/GwXGfiZ5O2CHkvyrc7Vncq7SnKJQ9GHcjoWoCg+fSFoq/BJgzB4O87seprRtCtxOf0moYFPyDyFEdRXKKX/Q2LGYD5dLsclfeG3x06g4h56tEt4MvHdxPZnGNi7MVF6XuJE0yovTrc+GYXugcHUAT7BI22pNx+MJotW864DGZ3jixFIGJ02IZNSeD9bdYH1RGnyAJaHv/GF3vxkNz1jbblHY9jqB1z2tHGxzLZt+JoHypiUKb1bzNIsXnEW6WlIqJiMbyuS3xYOHgVJqDgCtDmULbvSd2N6fCVWE80T1wqSgI5wjmYP2kQmoso7An0oyThXjolurYenTiRIh7HTEpwHLsMiA8pNyCJmGQ2muMEshFBnU3beppuYD3lQ0GuJfvZ05vA37K90BntKNIaMj5cRc8+4LadugPsLDWwLsfOqEd+pgTD27QA/bJ8RehUBBo4O381MDzDJkkQ5c3YvUu1NHu101vQj+t/MuL9udPaiEHnSE3Mzwpx/5D87VyDMaiwZ684L+7PA+9KQqkw0CNH5/q6fNU3LeOpRWkF/rGa2pmfl58s0HviXq7mrLcLguacwwHoawnysYr6G59nDxvs35qPuNWKXTExCic+nEIirWG/2rZkNvpfvi6TgrR4Wu/VW16w/JTORX1CT8Ram+Us6oc8c0trr0zlJKe77aiOBDjWkbAqweBUB32j9gB/82O/JR9QCOL+8Lt03P0GeQQBl6tfVetUJB2SSXpSh
 tCDvg4M+
 jrDx9exH51K/4hBrRbQkpjN/WeMyIBSg3sLWs6LZ3zKcnVSpUgHqqwx0s8R3rg4sebWR3+8Z8MNqG3ySloMxOzkes8ii+OGUBd3Hs4NQAMx68796b5VInosFdWhU+3DAIOGf8aSRZ1QClL1zkDj5Ssrz81Tq3Wu8OpvblwE3vDd9ZfuJ3RlLvEEowIlOcodBNp7u/qNTQx2QfbmbQPJzRWJ7eTuF7xyV7ikh28L7IBDCRxomUo4RpCs5120FnuD+/wFV3WVa9ISDxK9ZnZJ8vdcZfbxiLXoi3M446COQraaw+we/MAK1TEha+a7ydiAR67LaRb/Pjl3BbJD4cAotJtTgEe2zMpwM8Q4v9xvLeH/Kf7YelFMKKncJnBqi617XSy3LGx7ht7yrNmnfR3wiMlBFo7Oe9P6NH1VUM4zvbGzmvgXnkNGSmjunpC7z+CyoFK5otMM4ik3rAnnveT5WDRXrkM7Td1nLjiojk14QRdKcS3JAsWMz94QQmWH5ZvWC1bWSl0DFI073sg8w8ZeZdny5YxfWyOLh2Kcl3SqvMTLJdxfu4fmDrzKKgnieGFp9a2REeLH6SYgq//pVw6ckYyPqagXTOCIyaZZxjFkaPxQvazS3mcn7UX6RT9cJXpLp/QiBCwNFk2rORPKNu4mF50OSlsLaXI2czGmBS9i174U7sVWzatyeRg04brVbV6OGLlUsiXquvq1Cu/ds85HdY1POG++2/rbLbHD+qFgA0Pq9BZua90xkv911yQ4Ch9/bSePuSHZQW0IIxkM515FitpJoxMaGPdiLlZIsDjxCchhFsmflhgVHb3n8P0oHmTfA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: simplify and clarify min_t()/max_t() implementation

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-simplify-and-clarify-min_t-max_t-implementation.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=353d6d59a=farbere@amazon.com Mon Sep 22 12:34:24 2025
From: Eliav Farber <farbere@amazon.com>
Date: Mon, 22 Sep 2025 10:32:28 +0000
Subject: minmax: simplify and clarify min_t()/max_t() implementation
To: <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <mchehab@kernel.org>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>, <dm-devel@lists.linux.dev>, <mailhol.vincent@wanadoo.fr>, <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.ne
 t>, <edu
 mazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>, <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>, <malattia@linux.it>, <hdegoede@redhat.com>, <ilpo.jarvinen@linux.intel.com>, <markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <gregkh@linuxfoundation.org>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>, <pmladek@suse.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <senozhatsky@chromium.org>, <minchan@kernel.org>, <akpm@linux-foundation.org>, <dsahern@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>, <wad@chromium.org>, <farbere@amazon.com>, <David.Laight@ACULAB.COM>, <arnd@kernel.org>, <linux-um@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.fr
 eedeskto
 p.org>, <dri-devel@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Laight <David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Message-ID: <20250922103241.16213-3-farbere@amazon.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 017fa3e89187848fd056af757769c9e66ac3e93d ]

This simplifies the min_t() and max_t() macros by no longer making them
work in the context of a C constant expression.

That means that you can no longer use them for static initializers or
for array sizes in type definitions, but there were only a couple of
such uses, and all of them were converted (famous last words) to use
MIN_T/MAX_T instead.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -45,17 +45,20 @@
 
 #define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
 
-#define __cmp_once(op, x, y, unique_x, unique_y) ({	\
-	typeof(x) unique_x = (x);			\
-	typeof(y) unique_y = (y);			\
+#define __cmp_once_unique(op, type, x, y, ux, uy) \
+	({ type ux = (x); type uy = (y); __cmp(op, ux, uy); })
+
+#define __cmp_once(op, type, x, y) \
+	__cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
+
+#define __careful_cmp_once(op, x, y) ({			\
 	static_assert(__types_ok(x, y),			\
 		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-	__cmp(op, unique_x, unique_y); })
+	__cmp_once(op, __auto_type, x, y); })
 
 #define __careful_cmp(op, x, y)					\
 	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
-		__cmp(op, x, y),				\
-		__cmp_once(op, x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y)))
+		__cmp(op, x, y), __careful_cmp_once(op, x, y))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
@@ -158,7 +161,7 @@
  * @x: first value
  * @y: second value
  */
-#define min_t(type, x, y)	__careful_cmp(min, (type)(x), (type)(y))
+#define min_t(type, x, y) __cmp_once(min, type, x, y)
 
 /**
  * max_t - return maximum of two values, using the specified type
@@ -166,7 +169,7 @@
  * @x: first value
  * @y: second value
  */
-#define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
+#define max_t(type, x, y) __cmp_once(max, type, x, y)
 
 /*
  * Do not check the array parameter using __must_be_array().


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-6.6/minmax-don-t-use-max-in-situations-that-want-a-c-constant-expression.patch
queue-6.6/minmax-make-generic-min-and-max-macros-available-everywhere.patch
queue-6.6/minmax-fix-up-min3-and-max3-too.patch
queue-6.6/minmax-add-a-few-more-min_t-max_t-users.patch
queue-6.6/minmax-improve-macro-expansion-and-type-checking.patch
queue-6.6/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-6.6/minmax-simplify-min-max-clamp-implementation.patch
queue-6.6/minmax-simplify-and-clarify-min_t-max_t-implementation.patch

