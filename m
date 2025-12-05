Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FEB6D2E014
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5986B00D5; Fri,  5 Dec 2025 02:19:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318026B00D7; Fri,  5 Dec 2025 02:19:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41D26B00D8; Fri,  5 Dec 2025 02:19:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91C5C6B00D7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:19:57 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64447132F9F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:57 +0000 (UTC)
X-FDA: 84184568034.05.1973BB5
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf06.hostedemail.com (Postfix) with ESMTP id 835EB18000E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:19:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=MKDKMytXRhwPdHk0hD4DPd/rcYOaEhPBKBI2SKj3rgE=;
	b=fWUDzr7algy5a2N4YZSQhVI984gzhQhct8dpccjNrwrquwXwfNcDsUPnp3UToOcqTKGYc8
	m0XhIUW5yH6xImr8aRdSiui9po01WWk+nViGW8OKuvVNDlDSJ5BrD4FZnTkPJgmump7cmh
	xY3K8ATZ/1hoc7uoSGRjdzmzYAnEwbI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919195; a=rsa-sha256;
	cv=none;
	b=WtZ6HVn6HBZumPWv9MUeEFAePJuRIy5JHIiuirvPnffy5QX8FQ6KPxfLCMmMwLIjFdbXYv
	v+LZ6olRmsPdW76e2bDIINM4lw9sk2/2m3tZ6PMW32lnKFnFU/L588TnCICVc9zFi7C9Dy
	BsjA/RxMYc2MlzFBnKSYND+GEp95z5w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-25-6932876cc6fb
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
Subject: [PATCH v18 10/42] dept: apply sdt_might_sleep_{start,end}() to wait_for_completion()/complete()
Date: Fri,  5 Dec 2025 16:18:23 +0900
Message-Id: <20251205071855.72743-11-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0hTcRiH+5/7RpPTup3ygzGKILCaWLxE96LOl8DqWwU29KTDaTIvZVB5
	SbyV1mhFnizTXOpOGbMwV0tbNJKSZra2LmYz08qVYDpxc9lc9O15fz/e5/3yMrjyE7mU0WZk
	C/oMjU5FyQn5z7l1seklcdq1DW3R8LF/kIS3BZ0EXG2RKAiJbTSUWq6Q8NxdSIDzjhlB/0Qp
	gsmgiENx+wwBIYODhhmbA4HH2YGDdK8Ag5GnYwiM3kEKLn8vIGDUdBZB9ZBIw8/+hyS4/T4E
	psE/GIQupcH1ulYKgt2vcLjh7cPB1lhIwZuJUQq6jBUU/LpLQW2hjYSelyMIakQDgqH3NgyK
	6lsoaP9spcFs2RO+QoF4+RsGxtsPMZgyNdMgdveSMNBYTcO0Vw0O8zANfVVGAizvniEYf+PF
	QDo7hEOpdSKcfXlLwiNbFwGloXEEjgcDGPRar1LwSZohIV+cJKFl2INBV3UTAR+6q2h4Zb1N
	QoO7BwPvZw8J/srorcl88esQxUvXJMQHAwbEjzcU4Xzx+fD41DeK84EJF8Xb/LUEf7MsgPEX
	umP59uo+mj/z+D3N11py+PpH3zHe0lxG8ZYxA52w6oB8Y7Kg0+YK+jWbD8tTg/ZyLNM27/g3
	lxPlo9aociRjODaeK3sxQP/nCqtIzjLFruQ8nil8lhewy7jWc0PhXM7gbG8MVzJVGSnms6nc
	E9sHapYJdgU3IlZGRAp2PecO/MD/SWM4893OCMvCudEdiLCSXcddL5+MSDm2XsYV2avQv4Ul
	3JNGD3EeKWrRnGak1Gbkpmu0uvjVqXkZ2uOrk46mW1D460wnpw8+QGPO/XbEMkg1V9F5TK1V
	kprcrLx0O+IYXLVA4dOt1SoVyZq8E4L+aKI+Rydk2VE0Q6gWK+L8x5KVbIomW0gThExB/7/F
	GNnSfBTrujWMFu5zHCE2HX7e4dsZ9Espdet27zaJPunC/fKuva6YHVHbEtOazb3bE5eNdRiy
	ZdEbmrZsP1fhMsdyCcWK05nzS56ZatTxPTmu6U3xnc6or3UDNbukg/U31BebflcuYmT72OyF
	04e+npqZnNOXlJDS5nFVGTcnLY/bW5T2R0VkpWrUq3B9luYvacPVVnEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0xScRTH+917uSALu5Krm9UstlYrH9lrp8d6/OXtYfVPq9UfRXWXJKiD
	Qm290EjT8sEGrvBdslQqk8qosYiW056YGWaZYkSamD18DJQMbf1z9jnf7znfnT8ODxfe54Tx
	JInHWHmiWCoi+QR/+9qMSGnmMsnSRmcUZKnPwMdOFwfeqawEDA1mEVB0y0iCX1/Phay6yxxo
	dKQTYL9Zg6BzKAvByKgeB7V5nAC/poELg94PXNCqEIxbGhDomjU4tNkf4WC8o8Lgd+0fEvqe
	/EKgdbpIKOxVETBguIjgilvPhd6nsdDf+ZAD4x1fMXAMexAYXH8wcFkzEfh1CVBaYQqs636Q
	MPryNQ6FWjuCcmcHDr96uxDcafiEwHI9nYQv+XdxaHEFw9uhARKatDkk9DcXYfC9loSydAsH
	ml/0ISjWaxC42y0YZFy9RYKuuI4Ac9cDLjT3jWHwUafBoKYuDjoNbgKe51dggXMDU7dngr4w
	AwuUHgy0Nx5i4DVUczdWImZEnUsw1aZ7GKN+4ycZY4kRMaM+DWIGKzNwRp0faJ94BnDmnCmF
	qXzuIRnfUCvJWIbLCOZZBc1cu+DDmIKXkYz5Sgd356a9/HWHWalEycqj1x/gx4/asrFkS0hq
	T6sdnUWm4GwUxKOpFXTOAz1ngklqId3W5sUnOJSaR5suuQM6n4dTLeF0pjd30phOxdOPLR/I
	CSaoBXSfPpc7wQJqFe3wfcP/hYbTNbXWSQ4K6FqHb5KF1Eq6NHuEk4/4ZWhKNQqVJCplYol0
	ZZQiIT4tUZIadShJVocC/2Q4NVZwHw22xNoQxUOiqQJrSoxEyBErFWkyG6J5uChU4JEulQgF
	h8VpJ1h50n75cSmrsKHZPEI0U7BlN3tASB0RH2MTWDaZlf93MV5Q2Fl0dEl9knqOLa87aVrB
	Dr45TzVPtpgWtRelaPrfl3itqze01+oiTz7euk8Ys2bLdQ9efFqaXL8rr7DE6WvtXu8OyUzV
	fQ6PcLzSh8maFjl75nYFn/fPj6iyW29vi3Ziyu6D0dde7YlLL1HOmHW8a/mijhkVm29GTHeZ
	q4psQeU/jWtFhCJeHLMYlyvEfwHk5RxMSwMAAA==
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 835EB18000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: rcej9w9phcec36rzppdc1k9355iduf96
X-HE-Tag: 1764919195-436859
X-HE-Meta: U2FsdGVkX19o3tIKCAz+8hObHuTrMnhmUIyz1WcGey/Bruk7hifn//Kw4zWIa1eLICjrzg3ESftKPx5Fcr4e6gusD8geelVNo2RRNDNIT+RA5ENeArabwFhlZhCVf/MyKQuUxscDiVefA7Iwr2e4R+dYwqnqvV7V9Y8a7r+VquouqnvcwRiNoCN6YJL8kMuKRgkoHxAhIu4ZbkrpkZfjfGXZsg4Oq26jEUrdb29GUXJnqppRG0WsvYVRGo1Ce3ay7L+8siVklRuiG9Ei1bDR9h5m7527dXr/Vb25+Up/5ElAnkK1cjrpuaJnybePsuF01dQlOVs6EkEz6ntFT8K6ESBudwsXvC8MZFA9Lf1DEvksLScaRF5S6dTIflFdQRdDV6SsX5JKlbvodvkiGsPOsXllTA656mg6bN3Th6NxENL1TovMEvM5iLkjkTrR/ZieWqtfnOkPvbsQHztJqbEstsbV8eKangtsBMtQz8568cQXaRY0wBPjupyKHW1uRYwFo08oenfaHKuZX8cCIK7IzUgyzaKgruELhgVF/WONsgPldXnL7Z+8ba90pT59EhDQVsP7YRt4z0OUvOv5Llafshl9lYMK8UpqJ03vze5dMpYRKxFeJ125S9waIAOqJ01azbA0NvtbBzFKjr9kN3tDV5PyRNy3SS1x5xYnc2S7womlw7gu8co4lkhaS+pw7YP/p0sscYRPGzg3msNUHRgn9QFXScealWs+d+LJS1p3bg5qq0rEAkaOFGPf8l9Sl57Q79tXHN2cw9puHCo8Ww/2p+XKp0bLWtXS22DHlKIpEgAI02K4IDEXKF+QcbN+PWLQGkf5YDT2j/Q847PmXQrdARmj4H+S7TvI1W4/F6tNls61lHcVR29sF5UCufzhu4kzUvjt6y0+C0d/tnzXSJjwKHXrlluqlFX4oKi8x4K3YpDyYJctb4FKvjurdoe2kjeS8gj4uzGd+sfuAiNqGSO
 fNO75Dt7
 NdhXGLsa2sr0nF3N/oXGPN+ZgkGqdwGsCtzkAvhMgh861Jx7TFGlgepQB8edaYjTY4GXxjECj5rMXSAfnO0ueJflyko4AJCMF/bOv5/RKUqIDWxg9/KnJf4l8QjMxI+q+bo45
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make dept able to track dependencies by wait_for_completion()/complete().

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/completion.h | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/linux/completion.h b/include/linux/completion.h
index fb2915676574..bd2c207481d6 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -10,6 +10,7 @@
  */
 
 #include <linux/swait.h>
+#include <linux/dept_sdt.h>
 
 /*
  * struct completion - structure used to maintain state for a "completion"
@@ -26,14 +27,33 @@
 struct completion {
 	unsigned int done;
 	struct swait_queue_head wait;
+	struct dept_map dmap;
 };
 
+#define init_completion(x)				\
+do {							\
+	sdt_map_init(&(x)->dmap);			\
+	__init_completion(x);				\
+} while (0)
+
+/*
+ * XXX: No use cases for now. Fill the body when needed.
+ */
 #define init_completion_map(x, m) init_completion(x)
-static inline void complete_acquire(struct completion *x) {}
-static inline void complete_release(struct completion *x) {}
+
+static inline void complete_acquire(struct completion *x)
+{
+	sdt_might_sleep_start(&x->dmap);
+}
+
+static inline void complete_release(struct completion *x)
+{
+	sdt_might_sleep_end();
+}
 
 #define COMPLETION_INITIALIZER(work) \
-	{ 0, __SWAIT_QUEUE_HEAD_INITIALIZER((work).wait) }
+	{ 0, __SWAIT_QUEUE_HEAD_INITIALIZER((work).wait), \
+	  .dmap = DEPT_MAP_INITIALIZER(work, NULL), }
 
 #define COMPLETION_INITIALIZER_ONSTACK_MAP(work, map) \
 	(*({ init_completion_map(&(work), &(map)); &(work); }))
@@ -75,13 +95,13 @@ static inline void complete_release(struct completion *x) {}
 #endif
 
 /**
- * init_completion - Initialize a dynamically allocated completion
+ * __init_completion - Initialize a dynamically allocated completion
  * @x:  pointer to completion structure that is to be initialized
  *
  * This inline function will initialize a dynamically created completion
  * structure.
  */
-static inline void init_completion(struct completion *x)
+static inline void __init_completion(struct completion *x)
 {
 	x->done = 0;
 	init_swait_queue_head(&x->wait);
-- 
2.17.1


