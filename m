Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95169CCD184
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC9188E0042; Fri, 17 Oct 2025 04:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2B958E0016; Fri, 17 Oct 2025 04:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56668E0042; Fri, 17 Oct 2025 04:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF1B48E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:16:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 850531605AC
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:31 +0000 (UTC)
X-FDA: 84006899382.24.EFD6EBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D8BD516000C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b="kCuZOux/";
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760688989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=k5HBBFhnONFakMS+EkXg02XL95DzVICEQVtKnuV7ffE=;
	b=4loW7/nUM1wc4GCHdlM7KgJ5rLk6trWWzx4Bd7Li5cgc0jW0P3x4v0E9mO8G5tJLe/uYT6
	+Szm0kMmENZrnA+lbFDSrSZ9oeFtWIkszmLLgoTOkoh+B0AvQdphDO/VJm7StW5kMbY0t6
	Altrodi2kRrbu6VC0i7a0RnbgXKkK3E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b="kCuZOux/";
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760688989; a=rsa-sha256;
	cv=none;
	b=i/57BsTA4cR+niQdWpqH1nEJLsgH6oIBdJvi6A2GpXHeZFp1DmxAXTeYM7YM1BSsjox9oP
	c6mx1HT9rVdMZ+/LTgqU9wJMxHqzbGLlTCzdpLaaFspq64PhiD3WlpXbTZJowDwX7wvRjE
	d3DqTeUcar0GWDXmwN0DQMz5Z+ZwgrA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 24FFE64286;
	Fri, 17 Oct 2025 08:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D7FC113D0;
	Fri, 17 Oct 2025 08:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760688988;
	bh=zADvhOf8940hP6MoNyoip2jcGHrLI08WmDgVGaJ5ucE=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=kCuZOux/ygW+FVP+dOd5SY50dBxGILGfXe2hxa4IYAhPCUVdYXQ/OM7a6QZxDcXvM
	 DaMbHEDxG4eDvaEHAYuzt2Olkj51B20KhAcxjWdIiSZ4THQMuGVupvYjxhY/htdlk9
	 UZ4ifdB5roBgxlTZ3tianaIq2lgypX8fohtByiKM=
Subject: Patch "minmax: simplify and clarify min_t()/max_t() implementation" has been added to the 5.15-stable tree
To: David.Laight@ACULAB.COM, David.Laight@aculab.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@linux.ie,
	akpm@linux-foundation.org, amd-gfx@lists.freedesktop.org,
	andriy.shevchenko@linux.intel.com, anton.ivanov@cambridgegreys.com,
	bp@alien8.de, clm@fb.com, coreteam@netfilter.org, daniel@ffwll.ch,
	dave.hansen@linux.intel.com, davem@davemloft.net,
	dm-devel@redhat.com, dmitry.torokhov@gmail.com,
	dri-devel@lists.freedesktop.org, dsahern@kernel.org,
	dsterba@suse.com, dushistov@mail.ru, farbere@amazon.com,
	freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, hdegoede@redhat.com,
	herve.codina@bootlin.com, hpa@zytor.com, jack@suse.com,
	james.morse@arm.com, jdelvare@suse.com, jdike@addtoit.com,
	jejb@linux.ibm.com, jernej.skrabec@gmail.com, jmaloy@redhat.com,
	josef@toxicpanda.com, kadlec@netfilter.org,
	krzysztof.kozlowski@canonical.com, kuba@kernel.org,
	linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-staging@lists.linux.dev,
	linux-stm32@st-md-mailman.stormreply.co, m@kvack.org,
	linux-sunxi@lists.linux.dev, linux-um@lists.infradead.org,
	linux@rasmusvillemoes.dk, linux@roeck-us.net,
	lorenzo.stoakes@oracle.com, luc.vanoostenryck@gmail.com,
	luto@kernel.org, maarten.lankhorst@linux.intel.com,
	malattia@linux.it, martin.petersen@oracle.com, maz@kernel.org,
	mcoquelin.stm32@gmail.com, mgross@linux.intel.com,
	minchan@kernel.org, mingo@redhat.com, mripard@kernel.org,
	ngupta@vflare.org, pablo@netfilter.org, peterz@infradead.org,
	pmladek@suse.com, qiuxu.zhuo@intel.com, quic_akhilpo@quicinc.com,
	richard@nod.at, robdclark@gmail.com, rostedt@goodmis.org,
	rric@kernel.org, ruanjinjie@huawei.com, sakari.ailus@linux.intel.com,
	sashal@kernel.org, sean@poorly.run, senozhatsky@chromium.org,
	shuah@kernel.org, snitzer@redhat.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	torvalds@linux-foundation.org, tytso@mit.edu, tzimmermann@suse.de,
	wens@csie.org, willy@infradead.org, x86@kernel.org,
	ying.xue@windriver.com, yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 10:16:16 +0200
In-Reply-To: <20251008152946.29285-8-farbere@amazon.com>
Message-ID: <2025101716-query-scrabble-f91c@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: 5q43g3dh5ggryy5g3ksjcaerby5ar459
X-Rspamd-Queue-Id: D8BD516000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760688989-131563
X-HE-Meta: U2FsdGVkX1+6l7Pn4i8TQWB2lhZ3ZztYwS99WRz7YegKH4YIhCrTJlxYPWDfAWIoKaFjq/ixdyxjfj31CRk/v+Zmiss7bv/w/TNOtIeOaAUOlfya6qYD61woamica31dLl3S3s1ALKmisvrYarABOh2qs5dl0QRl3OwPaaytuHuerF6pPLqNkffKpQDtLIhz+HoOaFrktFd74PrfgGUSP4QvpguwQ9zJJTLZxM8yyyjOtiJlahsmmbwXGomPwcWxl01V9QpxrkLZIB8IPHwNmxqSZcB8D/1r9EFxscNbcQuMv5syEmCWrjMNp1F8XRdWuHpUpx0Jpan78U78j1NSUgwfhPu1qZuVp4Vnrzd/B2lkvMZbgy7neMV64lGVdWl0d1G3yDCbCu4xnimjhaySRg5uEnI6AQ0PUQWwmKHsqrknj8T+2dsyKN4viQy6MvhIhHdf5psgLTHhScPg3c0dW2L/XwtQ3UOqZMsg+9l5YYXUTAgMKM8imsjasQloZCHXpWTDZtcRl6u4uTtskGdM+/N759vRZPkPYXFszoPHXwT/8R8euO3VfoIUSUq9cnxxbnlBfvZLSH1vi13i+Nd4gbv90lo7bo2EChXcn1YzC/+OOYSeSg7PGXsCTEBixyvJ3E+1/xaZqruLEh/vmbr+QzDlViNrnUycNAWo/+PXPIb+lzK8j+Rq73Sgh4SSEQU6NhyjEdaJPJe5d+7YdporMpOCt7SP4G3wIjvBsrgKdaRK89QMfCNOTUGQAq+VN7Ly1hPWZNZK3s+gxgUI1J4AG+WlZBl+PD4/OU/VNK4ECtJ0/vs6w42t/Y7qdzrqZWJsR5ME0AsX0ng3FVEANhuBS8cQzUqTP+2H17zoXPy2EKRivkUoUSnmBNdqxcxEMYOmCp/VedHbDwfTomox+O/vr3IPjmj0XjqSlRRzqnIQkXyGBhyV/3rFSCXdNMiHhAfEzongRNupqONhsbhJCGZ
 fAAHuXb2
 7SCi5PIpmFFlXBwdgngGBC42UBMWcbdvFmx99Dh+ragFQ1OaLM1Vf4CCq3naaM51/ItgahcDkPxsAwLfR4SwF4uzAX6WMMM+rMvz11BjnYknsmriO1CCmozNp1awpyFI5dUFPiILF5q7OpNdnBmOlFuMPXcTo6fGH+dYQoIfdUISbRz6hMen8hVAq4uUDwLSpqcl0WsE1boX4JkimTc7uuIMqn1Ee7wh82gFyfbPIJXuEJQ1gMyGLu8M/Fgjb5ZAZdnCiN4hKq66TEy8kgJ7Q65z0CQ0c+LbA9I1Jd4Yl8f6dJitkeLO+gdpq/5STI1yZv5q9M7OdDLI7Hpu0H0LqPGbdR8hm+cwTweLtjbiMbjE6JeXVlLccuOiv7faOUNmJxTuRXTqP5TbN5JGCBZMSMhggqvGctxZ8sYio2tguK2GRjF9rU2fnbKLYVRVbt53l5/fDNoKdVIgpFY71wJTS6wL87mQCrSyb3N5pHWJC9qRlhzeFI3Ci0o6CGGvFzCkX/VE0+0tUVKxPXbi6M3spjq7QeVE95lEu9TF/TIZpOtv9dGQG5vToxaUyP5abB2VsR48Ytg9pfrX5TSy7Tshc4JCrTCkQgoXXNcVcq4b0cWA9Ez7IYGrOuQsDth8aCvhkqZ+2VCrQsA0c/Ve/kenSArZsPj8oahsXMyfUHbyDPpvpxKgfy0YdY9u+ZBcQ0nWXG9+LbJ0LZHTDpDR4x/oIhFG1Uph+F5167TKXhG+SHpL8j2ZULTxTf+MHzAZBU0A14wjce+W1vnxKFdqxuF4AsvniDmdzQhjuwQwLEgh6q1BP/YllPoaHa1AhOW7JpYFad2bIJHfsvSxCh7VOKLR+ONjz68HztbiYtQF09cQBMyXqWocmNk3Tf4v/0hcB8nmsqgcsW5VRJABbgDurjlpLpIfeAp/l1Fh6ZBsvOOZZ0ibxRVZWsNZBvXwyi1KkDDu/KjAOt+s/olXv4GP/Vn4r2gIFszO8
 kXp3tDVi
 sTyeZEAwCLu02t4dy2YbCLk+Ck13amNuAr814KrydzFKk++YmVqc+5BLanMob7phY/dh7X7NDeTCfaPKg8/59p+Mc1EnaLnxu2RvgTmbVHTOKPg557aO0hzNVvD+sLAKiVWPZSBW3Fc48/y7G9gT6Ep9iTNwopu/zutSZS/kA1rk0kW150pONeMMCNZ3Ri8h/09WD5xUnc/nTtgDdmgwxYqaOEsW1+m3wGHLUTEA/NaHvZXNeNoZdAHiSguqijoMnlyBiX8k3uOlnvKbO/XfmonbiEyCHZh3G7H3FZYhWxu5oxKDK5QcZXvWg9IGZCHxUUttn2Er0Pu/OqzvsywPEVjtrqXqU16pif826+P7lGf70q0gAKTOJHVF/YApCQ5kyC27vEC0YZBRUSbRTq0/pVCaBLpJb3wr4i3nDGLgcal4enVNsRJJO19lvNrrnZH8BiulQCXpSEeuBcem4qd9q8g2NWeG7NgldlS4YQaD057xKLXA8adimHVlbkmlMaSr32byAIR5J7Pd5KAUOrs72v3Yh5/JKYZaFVlQ0CyjfksBGTfcXgr/SZUJIO3XpTySmKTNvD10r2W+cDSymiQlozniXpcdiPbwH/6YzDvAjAQdOyEU192wNmwIB3CA+qisykK+BYsja5T1bJJ966JFLoxjKvOge44Lkfewt4s4/o/yxUssozYkRvXmGEIbZR7gk2vMUDDkx0w479Z2FImmfOsU3jqDzLHaqvx9ZXC1gtsiFmfcX1ZNsjPmgXP5uu1QpvMBJ7+hCWz4j2dlHRkhWTFfgXi3xwl9c9dssmG4jzET9LskUq0TiS52TX1eUc8jdWK1h79gdNKSoBLIJImeGdSdawuA4jg+Fk6YUMdqEi1J/tV215k5RQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: simplify and clarify min_t()/max_t() implementation

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-simplify-and-clarify-min_t-max_t-implementation.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=36971892a=farbere@amazon.com Wed Oct  8 17:31:56 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 8 Oct 2025 15:29:32 +0000
Subject: minmax: simplify and clarify min_t()/max_t() implementation
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari
 .ailus@l
 inux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <fre
 edreno@l
 ists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Laight <David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Message-ID: <20251008152946.29285-8-farbere@amazon.com>

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
V1 -> V2:
Use `[ Upstream commit <HASH> ]` instead of `commit <HASH> upstream.`
like in all other patches.

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

queue-5.15/minmax-add-a-few-more-min_t-max_t-users.patch
queue-5.15/minmax-improve-macro-expansion-and-type-checking.patch
queue-5.15/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-5.15/minmax.h-simplify-the-variants-of-clamp.patch
queue-5.15/minmax-add-in_range-macro.patch
queue-5.15/minmax.h-move-all-the-clamp-definitions-after-the-min-max-ones.patch
queue-5.15/minmax-don-t-use-max-in-situations-that-want-a-c-constant-expression.patch
queue-5.15/minmax.h-remove-some-defines-that-are-only-expanded-once.patch
queue-5.15/minmax.h-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch
queue-5.15/minmax-simplify-min-max-clamp-implementation.patch
queue-5.15/minmax-deduplicate-__unconst_integer_typeof.patch
queue-5.15/minmax-simplify-and-clarify-min_t-max_t-implementation.patch
queue-5.15/minmax.h-add-whitespace-around-operators-and-after-commas.patch
queue-5.15/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-5.15/minmax-make-generic-min-and-max-macros-available-everywhere.patch
queue-5.15/minmax-fix-up-min3-and-max3-too.patch
queue-5.15/minmax.h-reduce-the-define-expansion-of-min-max-and-clamp.patch
queue-5.15/minmax-introduce-min-max-_array.patch
queue-5.15/minmax.h-update-some-comments.patch

