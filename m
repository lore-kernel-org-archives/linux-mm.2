Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E82ABCAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E59E8E003B; Thu,  2 Oct 2025 04:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BD7C8E0038; Thu,  2 Oct 2025 04:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C348E0038; Thu,  2 Oct 2025 04:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 175668E0038
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:14:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA5FE13ABEE
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:25 +0000 (UTC)
X-FDA: 83952462090.01.E97BFE5
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf04.hostedemail.com (Postfix) with ESMTP id D0CDD4000B
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9qoBYT6wbI3DuD96QNrUKxtuEJglEVZJKtwoP0TlqlQ=;
	b=B7ao3phMw9+K8a2cASXsIsbv6G9PlflLREJhcQU6iXVGopHbIWIpKqXdUXYJjwrHnNqzlS
	RA4LUpP3qwVeCSxSs89JSTzapnKlITBYQ71V4mjbtDFPuCwf7yIRCToRrJkaWhpiTQNrOH
	nbLZ0tDBiLkXyVdrR+uILGkh8QrCnF8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392864; a=rsa-sha256;
	cv=none;
	b=vP38S0Kw0QgnxoljAay8TqgB8K9ZuBp4U/7nH8uXFPCenHbFIv6G7TR6LwCOIiRD0YiSwE
	L/11tAopsXKz/YIzTDAyQrkJXC5vIuCR9IP9DCH+ZPuVGsv+FwqoiaIvCYvlOEvGk166HB
	2XAwaMEXQxbSiX1ggl9rLdhyYAiLwN8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-14-68de3419f97f
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
	dave.hansen@linux.intel.com,
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
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v17 46/47] SUNRPC: relocate struct rcu_head to the first field of struct rpc_xprt
Date: Thu,  2 Oct 2025 17:12:46 +0900
Message-Id: <20251002081247.51255-47-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa2yLYRTH8zx9b2uUV228LjHKiGE2GTkuESSy9wsRvggRa9Y3WttKOnYR
	krELFpfp1OjWpbOlqXZsOkZR2c1lNtLZMMk2OjVbqEptYhfmrUX4cvLLec7/d54Ph5HI3eQM
	RqM9KOi0yiQFJSWkvgmlS6fHdqujyx/GgPu6HUGOc4yAn/pHNIy5HiEweLwU+C2nEfRVnUDQ
	5p0I7YN+CnytxRgumhwEON/dpaH10yiG5vwrGAr7KSgqzMJi6cNguHYPw5DFRoMlMwKKnrWR
	0GM10tB1zkBAU/crEj716il4+ziXhNuZ72gYaPdgKM0tJ6DtbjEF3RVjJLhrm0ko+NKLwDLo
	p6H3ZS6GqmzR8qzoOQkfjSYMDYOfMRS8MFPQc9ZHQ8D0iwR7KwGG0ZMUHPv2FoFpIAYG7Dbx
	cw+76fXRvK26BvMVJRWIHxnWIz4nXySnsYvmzY5DfHajj+SrrZF82f1+zJcGBkneYTtF8Y6A
	nuZLR/okfJ6vHfNPLo0QvNOzauusndK1KiFJkyrolq2Ll6pbrm444Jqcnq3fnYn8sjwUwnBs
	LOc/cYP+yw/sX3GQKXYh19ExJAlyKDuHqz7TSwZZwjbP4l61LgnyFFbJfWvoEmcYhmAjuMCP
	HcG2jF3JWbMukePKcM5eVftHEyL22zzNRJDl7Aoux5+Nx+cnc02XvURQIxHXVpbIxzeFc1m3
	isSoVNQ0hHDfbzvxuHM6V2ftIPIRa/wvbvwXN/4XNyOJDck12tRkpSYpNkqdodWkRyXsT3Yg
	8c4sR0d33UEB9/Z6xDJIMUHmjuhSy0llakpGcj3iGIkiVBZv7VTLZSplxmFBt3+P7lCSkFKP
	ZjKEYpps+fc0lZzdqzwoJArCAUH39xUzITMykdQVpzC8T+zcfNOsPRU5KeFFwvz4xWlTmri5
	jAoKSm6UNb6ucq/tW90479zMRXu9plC2Qmo2Fnc2hLXUbNpiOB6l+vC0M22VI+aNIvGCEDdM
	nX2+ZuxMXr93wLlvwdDG4cojcVSEf9QVDd6wOyWVU8MLz9fYthX3z65rKvO47uUqiBS1MiZS
	oktR/ganEuEEYwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHec9d6cRxGZ3Ksgaj6GIXsh4qulDhIejyrQgqVx7amDe2spQC
	bY6krGwxV1upKQ3bTE0rMlkMJSt11LQb6dLlskJtYpp5XWdJ1JeX3/s8P/7P8+FhcNkIOYdR
	Jx8XtcnKRDkVToTv3qBfPnvNR9VKZ/kMeJvlImBoMIeAGxVlFORUXSfhVbkDQcdQDoLhMSsO
	hpogARPGBhoGR9poCDobEOR7jDiU3c/C4EflJAU99QMITD4/BeZvWQQEbLkILN1WGr49jYO+
	jloSgt4vGLz72YvA5p/EwO86h2AiXwOFxdUUjLlf4mA2vUJwy+fF4Wul1Lzf8BGBs/QsBZ/z
	HuDQ6p8Or4cCFLwwXaCgz3MDg++VFBSddZJw02pEoC+poCD/ZhUBNZ2PafD0jGPQnm/EwFG1
	Czps3QQ05RVj0n6SdW8WWM16THq+YmC6W4vBiM1OQ3NJOwG2TAVY3a0kfCq10DDuWwXBohRo
	cHyhwXvZREB530tyiwkJw4ZLhGCvfogJhpYJSigrKEPC2KgRCYO39bhgyJO+9b0BXMiuPinc
	buqlhNGhN5Tg/FlECI3FvHDFvVyosXhpIfvJB3rv+gPhGxPERHWaqF2xKT5c1Xxna6oz4lS2
	8WAmCrDnURjDc2v4J45+LMQUt4h//34ED3Ekt4CvvthNhhjnmqL4t55lIZ7BKfkf9V7JYRiC
	U/ADv/aHyiy3li/VXyOnIqN5R6XrT0yYVG/1NREhlnGxvCGQjU35EfyL634iFINLYysKZFOT
	onn9Ayueh1jLf5bln2X5zypCuB1FqpPTkpTqxNgYnUaVnqw+FXM0JakKSQdpOzN+5REabI2r
	QxyD5NNYj8KrkpHKNF16Uh3iGVweycaXtqtkbIIyPUPUphzWnkgUdXVoLkPIZ7E794nxMu6Y
	8rioEcVUUfu3izFhczLRh8aWPRBVeFCh3fbZ3bgO254rX9072XNu4Xx3f+PchKhJfdy8q5u2
	bC5xm8/bYtpcW2MWz+zqYjtrT7ZohI0F9tPajOd7I7b7Tmc034L2nK5n9wotbOehpbFO89Xh
	w/1ZrsVc3xFFbYV5x1qHnW8zTUtN0oRFu9riBsbujAZzV8gJnUq5agmu1Sl/A2JfrD6MAwAA
X-CFilter-Loop: Reflected
X-Stat-Signature: khseud6zfawbzjz9nuk33t1gmpgrmn4h
X-Rspamd-Queue-Id: D0CDD4000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759392863-714612
X-HE-Meta: U2FsdGVkX1+KI1YYZjAbTia/rzsIN+KMCI/MDs/fOwT2pMtZtSSZOl4XnQFsAbUtax4aNS+oqMuSATt77PUwvhvdcyRHpgER2xt7s89ktb1FovtVQukLHBMzwWfuWLukoUlszQS4TfVz2XIPykGVwYaGLcCj+6Y+gje+6RwJXGOVWAJ9PU1BlsCb2Dc2CIvs+a9myRn+xj5vPF5m6ajS164eJEVDoTH02UughrR+v2I0ieMemIJFTKLGJU3y2phXE0i3jodgbZE+OBU1noYbtI7LLdytxDULW6p0dmg/Y60S7Bihzx/AMAJ2WxOvYdvdP5l2E49Mh4FnkQn/e480kkT262LmeFsKS2DZ2bjI/8Wu76d0HIFu6kF9+LxPMYoICqepmTBfhjALW66LRA6viUxRFJnwUBL/GV+BpTxmwyPqXNlRaplnafm3bsV39T6Kig0+PNMMpUhlAo4BD95A7KwvUb9RgVFgdgCw75oPM5xjw+G+mmATxKdxnvJUXCP+FZp5a9RvVlYYXvCmjVK+h1jg+SOFoxYonLwhtPrezzQkMMHKMTvYcjuj/1icYNuyPzvZm4hEDmYMHy5aqdCAHcuSz2PXnCPWJ+c0fUdCU7iuGDUUKZrdeANEZM76ZLdlJzPlkQKbGwUtyDjhtl7dr61+6I7JZxMiW7jhOyVeSEUE3Sg/Ap/qrOjv0D6jjmhFddmKuqLz9I4U4uJAvbXeMpjHb0NYMe/aHhRNi97QuVK+MpHdDYHdLNHIjV48+sQsHBqdNAavln88FoGIPMXYCTfxRXpJMpRVsY0pyZnGrUaiBzB7bgKFJXHNpIHKN176BkEjG06HSPlr/gNaF846cqsioE6lOp7UERl0V4JrcC3lDxu2ubOVDejRP/bX7cawE2pemmoD8qctnssq0RLZCQxqGEEP5ygStRHquVagWvWO3UHPuFsNQoG878uXon3nmVho6S7VYQBgvDSF79b
 UtUfmukT
 JV9eAQ7xFXj4d7P3yT0W4YWA0CBarhN54Otep4zZOvg59OMQk/Zgqv9McBdN7bakBsQbUMsFKS49NPgA5i3VQxn/opkwbs13/q95v1u7+ulppxjL0nFLHLRDGYwV0tM9HaAPbY37w1e0upXvEzz+7sX6X5ricU4+Kaf+y8qOpu10c8nFk/TAocSK0+35xwUo9Ebab1L+E9OTb1O9pS+gRtvBG/+LYQbEyvQZ4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While compiling Linux kernel with DEPT on, the following error was
observed:

   ./include/linux/rcupdate.h:1084:17: note: in expansion of macro
   ‘BUILD_BUG_ON’
   1084 | BUILD_BUG_ON(offsetof(typeof(*(ptr)), rhf) >= 4096);	\
        | ^~~~~~~~~~~~
   ./include/linux/rcupdate.h:1047:29: note: in expansion of macro
   'kvfree_rcu_arg_2'
   1047 | #define kfree_rcu(ptr, rhf) kvfree_rcu_arg_2(ptr, rhf)
        |                             ^~~~~~~~~~~~~~~~
   net/sunrpc/xprt.c:1856:9: note: in expansion of macro 'kfree_rcu'
   1856 | kfree_rcu(xprt, rcu);
        | ^~~~~~~~~
    CC net/kcm/kcmproc.o
   make[4]: *** [scripts/Makefile.build:203: net/sunrpc/xprt.o] Error 1

Since kfree_rcu() assumes 'offset of struct rcu_head in a rcu-managed
struct < 4096', the offest of struct rcu_head in struct rpc_xprt should
not exceed 4096 but does, due to the debug information added by DEPT.

Relocate struct rcu_head to the first field of struct rpc_xprt from an
arbitrary location to avoid the issue and meet the assumption.

Reported-by: Yunseong Kim <ysk@kzalloc.com>
Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/sunrpc/xprt.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index f46d1fb8f71a..666e42a17a31 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -211,6 +211,14 @@ enum xprt_transports {
 
 struct rpc_sysfs_xprt;
 struct rpc_xprt {
+	/*
+	 * Place struct rcu_head within the first 4096 bytes of struct
+	 * rpc_xprt if sizeof(struct rpc_xprt) > 4096, so that
+	 * kfree_rcu() can simply work assuming that.  See the comment
+	 * in kfree_rcu().
+	 */
+	struct rcu_head		rcu;
+
 	struct kref		kref;		/* Reference count */
 	const struct rpc_xprt_ops *ops;		/* transport methods */
 	unsigned int		id;		/* transport id */
@@ -317,7 +325,6 @@ struct rpc_xprt {
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 	struct dentry		*debugfs;		/* debugfs directory */
 #endif
-	struct rcu_head		rcu;
 	const struct xprt_class	*xprt_class;
 	struct rpc_sysfs_xprt	*xprt_sysfs;
 	bool			main; /*mark if this is the 1st transport */
-- 
2.17.1


