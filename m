Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB08BD2E014
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2324A6B00E0; Fri,  5 Dec 2025 02:20:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11D826B00E6; Fri,  5 Dec 2025 02:19:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0F06B00E4; Fri,  5 Dec 2025 02:19:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C1CE76B00E0
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:19:59 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86B7659025
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:59 +0000 (UTC)
X-FDA: 84184568118.25.7C09D46
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id A39C420006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=2RZYJT4nXPz/0zunBSrL2ai9dkx+LO0+UPUASDTqCL0=;
	b=JHur4z+r5lD76COCFvyPsYkUadxq4eCsM7xyLKbKNFZvEVK0S2u7e1CwV0VstPJlY8zYBm
	1PHWKlDDEXPDdo5tWtr51xs8porJsePtktTgUOCWLyWQ5k5yULna9WY4n57Da9AOBOEl7U
	uScuO+97YJT4vEnRJ+wHNirzGGrYqRc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919198; a=rsa-sha256;
	cv=none;
	b=O97khqb6MW/6cis8AcmtHG5PF7HJxVsO2Y6qEZJe9KALcv5diIEC+ywroz+By2dvfJ4gdk
	bynOTgSGU8VBShZThF3cdoN4qA4k9H7mNVr91gt+vdfwZK2fHxMGKsbHgKQqubh1ntCu34
	b0hRrF2R2bU8oPiV3ZtSVLlohCtPGxo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-83-6932876ddb02
From: Byungchul Park <byungchul@sk.com>
To: linux-kernel@vger.kernel.org
Cc: kernel_team@skhynix.com,
	torvalds@linux-foundation.org,
	damien.lemoal@opensource.wdc.com,
	linux-ide@vger.kernel.org,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	will@kernel.org,
	tglx@linutronix.de,
	rostedt@goodmis.org,
	joel@joelfernandes.org,
	sashal@kernel.org,
	daniel.vetter@ffwll.ch,
	duyuyang@gmail.com,
	johannes.berg@intel.com,
	tj@kernel.org,
	tytso@mit.edu,
	willy@infradead.org,
	david@fromorbit.com,
	amir73il@gmail.com,
	gregkh@linuxfoundation.org,
	kernel-team@lge.com,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	mhocko@kernel.org,
	minchan@kernel.org,
	hannes@cmpxchg.org,
	vdavydov.dev@gmail.com,
	sj@kernel.org,
	jglisse@redhat.com,
	dennis@kernel.org,
	cl@linux.com,
	penberg@kernel.org,
	rientjes@google.com,
	vbabka@suse.cz,
	ngupta@vflare.org,
	linux-block@vger.kernel.org,
	josef@toxicpanda.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	jlayton@kernel.org,
	dan.j.williams@intel.com,
	hch@infradead.org,
	djwong@kernel.org,
	dri-devel@lists.freedesktop.org,
	rodrigosiqueiramelo@gmail.com,
	melissa.srw@gmail.com,
	hamohammed.sa@gmail.com,
	harry.yoo@oracle.com,
	chris.p.wilson@intel.com,
	gwan-gyeong.mun@intel.com,
	max.byungchul.park@gmail.com,
	boqun.feng@gmail.com,
	longman@redhat.com,
	yunseong.kim@ericsson.com,
	ysk@kzalloc.com,
	yeoreum.yun@arm.com,
	netdev@vger.kernel.org,
	matthew.brost@intel.com,
	her0gyugyu@gmail.com,
	corbet@lwn.net,
	catalin.marinas@arm.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	sumit.semwal@linaro.org,
	gustavo@padovan.org,
	christian.koenig@amd.com,
	andi.shyti@kernel.org,
	arnd@arndb.de,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	surenb@google.com,
	mcgrof@kernel.org,
	petr.pavlu@suse.com,
	da.gomez@kernel.org,
	samitolvanen@google.com,
	paulmck@kernel.org,
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	urezki@gmail.com,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	qiang.zhang@linux.dev,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	chuck.lever@oracle.com,
	neil@brown.name,
	okorniev@redhat.com,
	Dai.Ngo@oracle.com,
	tom@talpey.com,
	trondmy@kernel.org,
	anna@kernel.org,
	kees@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	mark.rutland@arm.com,
	ada.coupriediaz@arm.com,
	kristina.martsenko@arm.com,
	wangkefeng.wang@huawei.com,
	broonie@kernel.org,
	kevin.brodsky@arm.com,
	dwmw@amazon.co.uk,
	shakeel.butt@linux.dev,
	ast@kernel.org,
	ziy@nvidia.com,
	yuzhao@google.com,
	baolin.wang@linux.alibaba.com,
	usamaarif642@gmail.com,
	joel.granados@kernel.org,
	richard.weiyang@gmail.com,
	geert+renesas@glider.be,
	tim.c.chen@linux.intel.com,
	linux@treblig.org,
	alexander.shishkin@linux.intel.com,
	lillian@star-ark.net,
	chenhuacai@kernel.org,
	francesco@valla.it,
	guoweikang.kernel@gmail.com,
	link@vivo.com,
	jpoimboe@kernel.org,
	masahiroy@kernel.org,
	brauner@kernel.org,
	thomas.weissschuh@linutronix.de,
	oleg@redhat.com,
	mjguzik@gmail.com,
	andrii@kernel.org,
	wangfushuai@baidu.com,
	linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-modules@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	2407018371@qq.com,
	dakr@kernel.org,
	miguel.ojeda.sandonis@gmail.com,
	neilb@ownmail.net,
	bagasdotme@gmail.com,
	wsa+renesas@sang-engineering.com,
	dave.hansen@intel.com,
	geert@linux-m68k.org,
	ojeda@kernel.org,
	alex.gaynor@gmail.com,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	a.hindborg@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu,
	rust-for-linux@vger.kernel.org
Subject: [PATCH v18 13/42] dept: apply sdt_might_sleep_{start,end}() to hashed-waitqueue wait
Date: Fri,  5 Dec 2025 16:18:26 +0900
Message-Id: <20251205071855.72743-14-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTdxjF+d/7v7e3jc1uKpE7XObSxJloYGDUPDHLZvjC30XNkn3Y4jK3
	Rq7jhlJMQV6cc0DQKuJkTdplFKEg6RCqvNaXabOKGw7UWQSlmpYrWqsdIIZYGC9dV7r57Zdz
	nnNyPjwcrXnApHKSoUg0GnR6LavCqqkVTWkG00Ypo8ulAb8cZOB+hQdD5NUxDPUdThaitosK
	+GO0EoP3fDsCOXIMwdyijYYjl2MYouZ+BVgqEMTc/QisQ2YafN5fabCMB1n4MVyBYdpRgyD8
	ezZMyVcYiAWeUTA6O4nAEfyHgqDHhCBqzYMJ68v4vcWLoGk8QMNM+BGC3v4xBO7WShae1rpo
	GIlMszBgOcHC1FA9BfZKNwNDtyYQnLaZEYQeuikYmliiwG81U9DevRNkRwjHN7Bg7UqBeUeb
	Ahzla8F2e5iBx611CojZCyBwyoJhYOw+A/KNowy8GhmnwFkToqH7SVxrOtqC4acGPwtX3QMY
	ajpdDIw5Ywx4PTcZuNvujWfrzuJtOaSt5wJFjtyNssTZ4ERkccGMyPXJaZpU9ZSQhcg9lrhn
	7ZgMNguk5fgCRX64nUYu1wUUxN59gFT9NsWQntb15MzVMPVx2m7V+zmiXioWje998JUqt/fW
	cbRf5krPeDvociSz1UjJCfwm4emVCH7N/sBJxTKz/DrB55unlzmZf0foORliqpGKo/nhNYJp
	/vuEsZL/QmgYvZMIY36tEPKdoJZZzW8Rzi3+rPivdI3Q3ulJ3CvjumV0IcEafrPQWD2XKBX4
	RqUw9+ez/1e8KVxr9eFapLajpDakkQzF+TpJvyk9t8wglabvLcjvRvGHc3y79PklNOP9pA/x
	HNKuUHtKMiUNoysuLMvvQwJHa5PVk/oMSaPO0ZUdFI0FXxoP6MXCPrSaw9oU9cbZkhwN/7Wu
	SMwTxf2i8bVLccrUclSbfTYpMPaZNLiq0fR81V+d2/2KzI7gp+7ISGXR7lQmZZ/cZdsVOpS1
	JevOu65oxNT8Vl991fZB5R77hplS9brnN/YxycUkb+cv32nl7GvOb5IebN2w+cWON0oyhve4
	9ubPfpRuzj3sGPxwl1nz9k25a6Al6WBec1Fv1qPw6a3J1/9e0uLCXF3metpYqPsX41p+/mwD
	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0hTcRTH+917d+91ubithZeKFoMIAi2l5EQPKigvvZCCgiBy5CUvTqtt
	+Sgi3Vqaqelgk1qlaa7wkeajshoNI+lhumXlKNe01kycGTYTt8ym0T+Hzznf7/ly/jg0Ln0g
	WkQL6Vpena5UKUgxId6zXh+dlhcnrG4PrYB8w1no83hF8D7XTsB4IJ+Aqw11JExZ7lOQ33RZ
	BM97dQQ47tQi8IznI5gIWXAwtE0TMGXsoCAw+ZECUy6CaVsHArPTiIPL8QSHupZcDH42/iFh
	+OkYAtOAl4SyoVwCRq2FCK74LBQMPUuAEc8jEUy7BzHo/eVHYPX+wcBrz0MwZU6F8srm8Lr5
	Bwmh1904lJkcCG4MuHEYG+pH0NLxCYHtto6EryWtOPR458Hb8VESXpgukjDivIrB90YSKnQ2
	ETg7hxFcsxgR+D7YMNBXNZBgvtZEQFv/Qwqcw78x6DMbMaht2g0eq4+AVyWVWPjcsOtuFFjK
	9Fi4fMPAVP8Ig0lrDbW5GnEThmKCq2m+h3GGN1MkV3e9DnGhoBFxgWo9zhlKwu1T/yjOnWvO
	5Kpf+UkuOP6O5Gy/KgjuZSXL3bwQxLjS19Fc2xU3lbjloHhDMq8SMnj1qk1J4pSWzgvouIfO
	qnI04DnIQxagCJpl1rB97iJqhklmBetyTeIzLGOWsc1FPlEBEtM40yNn8yaLZ4UFzCH2em83
	McMEs5z1uS5iMyxh4tn60C3qX6icrW20z/ojwnNTb3CWpcxatrxgQlSCxBVoTg2SCekZaUpB
	tTZGk5qSnS5kxRw5ltaEwv9kPfO79AEK9CS0I4ZGikiJPTNWkIqUGZrstHbE0rhCJvGrVgtS
	SbIy+xSvPnZYfVLFa9rRYppQREl2HOCTpMxRpZZP5fnjvPq/itERi3LQ6a7WpdHnE8c+j50s
	Ly4U9nbFc8MbLer4wcZCR0DsXyr0lC5ftemElnHmZCXEF408s8fN10s2xAYLd92IXJLhWqM7
	pXJWyEN7Ytw6uvTS462R3+7VLJvQFuMyy8G5+5OGMnfK1x2R7/sZyospd50t2KaVtQ3WH+7M
	jOv/st2YuFBBaFKUsStxtUb5FyE0OqdLAwAA
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: A39C420006
X-Stat-Signature: 1dqgy1dqwya87e1rc5yj9sgcmw4e8w7f
X-HE-Tag: 1764919197-282667
X-HE-Meta: U2FsdGVkX18HXQW4TFBKn8/oYNLrYQ3K+rRyiNTGiNaPfTVsUyCkOnSSC9jPrHnt7lsBi+fItuuQAmv3WfAIIjmrNn3XfaK2tUO0/t5yRX5XpL9n3dWCWPiaWl+n8sI+tU2Vrt5VAh8dyXIBPhayjk4vwpf73WPbYLzNHmGlTTh14kLFiaoBGkwVXgnmV5Zs2ra9Rr1qCLV/PG9Q3geQI524p5ZE779SqSVNr9H5rr3aPlLdJR1Gg08DyEjoRLMFFU1ixxOyKCxAMYj+l/O6uCFqI+LNFh2v1DwF6DsKQtRdZpGvi96Dquv7IGbjTXCbBcEHRU5A6r1p9FU7so7o9QstppDE0mxBpRJmThkD416Z3GoTwipL5ykdFXDEA0z1fjz9a0mWNtg/pJSJ3MTaL2tdlt+2IduuJXjC49SkvruhbfjKu76uEyPOCbI76Lv05tPPsbLrQ1oCGiy3qWpFDNvEMss0M3CHd0RUipVJTD5pgKqY+EDp2BYgiRNBupV/0xe6ZXDbX4KHdGfkxusBXtAqf+0fa3omC1Sw6GspKlp/YZ05vAlhwBSbdCHyYl6LY9iLYXeuCl2GIee9thq44kb/wg886z0TacKxtz2sKi3LD70EYD95QSH9twzzLAl071QruzAhBI1/JXd5nFzVh5PlZyCxRAWa1YYooivNuSmk+4nog4+ZVeKThygqEiHAAxCHTncZxxivJc6nTxDJZPBHH/hYcJ2+c60vKoTf4sIl6nXR+IeHNmmZQ5bj/4hc68GKIhuQeg3jPpkidgA/VofLI+z/C4/B7lfY/huVObefUpcfm2sW+aqvbXFBG1qbH2mpuKpxgwkQomQtkP74rU+amSNEqhzcRWRBF31yJ116YsMTlnLtJ6fYYtYn3jjfqLW7Q0uhV8g2oCGHMREDe7TGuiKty+zUOOuPzaonQjRaplGRPJu9v2ebpEbPU/kb4DXizW9jZeDBv5GYZwL
 0IofwqQW
 bhb3WLJJ3IESoEFvkD/zvMW5R9chzVP54LynnIx6ZqyzbvDrWc6zm7G1yxZ3wJ6LtINm11ChYpFg/CH1/k6TDHPU1oJFHEPi9Ez+xdDH7oFROOeU/7jMWNH5CNrX2ZHKyQNsV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make dept able to track dependencies by hashed-waitqueue waits.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/wait_bit.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/wait_bit.h b/include/linux/wait_bit.h
index 9e29d79fc790..179a616ad245 100644
--- a/include/linux/wait_bit.h
+++ b/include/linux/wait_bit.h
@@ -6,6 +6,7 @@
  * Linux wait-bit related types and methods:
  */
 #include <linux/wait.h>
+#include <linux/dept_sdt.h>
 
 struct wait_bit_key {
 	unsigned long		*flags;
@@ -257,6 +258,7 @@ extern wait_queue_head_t *__var_waitqueue(void *p);
 	struct wait_bit_queue_entry __wbq_entry;			\
 	long __ret = ret; /* explicit shadow */				\
 									\
+	sdt_might_sleep_start(NULL);					\
 	init_wait_var_entry(&__wbq_entry, var,				\
 			    exclusive ? WQ_FLAG_EXCLUSIVE : 0);		\
 	for (;;) {							\
@@ -274,6 +276,7 @@ extern wait_queue_head_t *__var_waitqueue(void *p);
 		cmd;							\
 	}								\
 	finish_wait(__wq_head, &__wbq_entry.wq_entry);			\
+	sdt_might_sleep_end();						\
 __out:	__ret;								\
 })
 
-- 
2.17.1


