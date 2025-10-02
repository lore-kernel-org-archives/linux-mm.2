Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7995DCAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E9E08E0020; Thu,  2 Oct 2025 04:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2A08E001C; Thu,  2 Oct 2025 04:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528DA8E0020; Thu,  2 Oct 2025 04:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 351E88E001C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:13:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF97A13AC04
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:50 +0000 (UTC)
X-FDA: 83952460620.11.63FF1E1
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id 061E4A0004
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=xr7YxQ3mDgzLlVDJz4QHuiIob5IdzD85o9Kn2I4mvjo=;
	b=DeEO6q6orI8co0CLzPnGwBfeNXUazOcbYp1mWHYOg0GosghFmWVgmWoBrKpNNqOyGoit2u
	7Rt4KnSlUPjzU4yCwh7gIqeM2L+qDf9r7lFSHDYidSUHXQ8xe4oi66kznI4dHIuGzCa45/
	BL2oNaOVbd2DT1A6LUOhrIhVZfr2Pnk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392829; a=rsa-sha256;
	cv=none;
	b=Stz9r8JL1uutUjOQKQSpLPJP3XLNTO/mi23MK+f5yiXEj7JAM8oPYcv6t722jvuJo+pFxr
	iJG/wbzFOMyUTdAYVqMVoCmxFVVCGbv44GO8gWg9ps6s5CMyQ+EwsPPvFu7UqLkRMX03vF
	0+38aLs67NZpawA940kMWAPqMWdJvDc=
X-AuditID: a67dfc5b-c45ff70000001609-ad-68de340fa989
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
Subject: [PATCH v17 19/47] dept: apply timeout consideration to wait_for_completion()/complete()
Date: Thu,  2 Oct 2025 17:12:19 +0900
Message-Id: <20251002081247.51255-20-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSfUzMcRzHfX9P97BufjvGz2O5LQzltIuPh5k//PG1kYeMDZuOftzNVXan
	h2tMTXcSeWhOVHKnOke1cmmjMqmFXKXysJt11RFd6Jo6KRR1+O+1z+f1ee/zx1tISi/Qs4Xq
	2GO8NlapkTFiStwfYAmZquhUyYsvr4VvvnQKur6lI7jSlkXCUPk4A5/rBxGY3D0MZPelUjBg
	PYegv6uaht+uXgKsPeMEZJtaEVjcLhKu52YhOFVQxkCxfQuYSqsJeGfLEUDXUyMNvlduAizG
	QgpqHjZSkD7mQ/Dk/jsCXlblMdBZ8psGx5NnFDTm3KbgRVUpDe5uJw0VzU0kOC9+QFDqvclA
	e62ZANvXbBoqHxkQGIfGaTjtqWagObeFBmPhXQIq7CYS3mTdYODHrYaJ53+lM1DZ8F0AaR3h
	MFL+nobchk7BBjn+bjhPYUP7GINL8ksQrv8yQOK0ikRc5PjC4IfDZgpfag7BD3JcAmy2x+OC
	mj4C2++cYbB9MEuAvS0tAmxJMZE4v3H7thl7xOuieY06gdcuXx8lVr3ueEsezRcnFX4y0imo
	W5iBREKOVXCekff0f/YaP1CTzLCLOKdzlJzk6WwQV5H50e+QrGMu96Zt2SRPY6M4R6HH71Bs
	MDdYVu93JOxKrsk29C8zkCsur/U7oon5S7fDny9lwznDQBqRgcQTTraIM99rQn8PZnGPbU7q
	IpKY0ZQ7SKqOTYhRqjWKUJU+Vp0UejAuxo4mamI98WvvfTTYGlmHWCGSBUhag10qKa1M0Olj
	6hAnJGXTJVG2DpVUEq3UJ/PauP3aeA2vq0NzhJRspiRsODFayh5WHuOP8PxRXvt/SwhFs1MQ
	e3dz/2eBbv0hRUjZMv08XdA0a0/wgdSxSwsjxuZXbR7alBHjnupd7NMmG9bIh9WbwoY1J06e
	X6rOvFbUKDvrXpL30/pJfm/RzOeJu3oD9Yx3x84bV1e3KzxHdrs27sarTiZFpHiuVx6viYi8
	EubtFozeWnt5a6YmcF/QLqVFu0CUK6N0KuWKJaRWp/wDORl9pSIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0hTcRTH+923o9VtSd0sMAYSlGYv49CLiqJL0EMKCv/JkZe2nFM2My0q
	TWf21AabtJWZ2RC1tK2XlSWTFrbE1npIbdlkPkqnYJuhbtk0+ufwOef74XD+OAwueUTGMApV
	tqBWyZRSSkSIdq8vTJi95pt8RbhoAXwqaCEgGCgh4HpDPQUllmskvLtXh6ArWILg94QJB23T
	JAFhnZ2GwNhXGiab7QgMTh0O9Q8KMPjV+IeCgdYRBHqvj4LyHwUEDJsvITD2mmj48WoH+Lue
	kTDp6cPg8+ggArPvDwa+lnMIwoZ0uFllpWCivQOHcv07BLe8Hhz6GyPhA/s3BM01ZynoKXuI
	g8s3Cz4Ehylo01+kwO+8jsFQIwWVZ5tJuGHSISi83UCB4YaFgKbvT2lwDoQwcBt0GNRZdkGX
	uZcAR1kVFrkvYt2fD6byQixS+jHQ332GwZi5loa3t90EmPPjwNTuIqG7xkhDyLsSJiszwV7X
	R4OnVE/APX8HuVmP+N/aKwRfa32E8dr3YYqvr6hH/MS4DvGBO4U4ry2LtK2DwzhfZD3O33EM
	Uvx48CPFN49WEvybKo6/2p7ANxk9NF/04gu9d12KaEOaoFTkCOrETaki+Uf3FzyrQpRb/bOY
	zEffmQsoiuHYNdxQcQ8xxRS7hOvsHMOnOJpdzFkv95JTjLOORdwnZ/wUz2VTOUd1/7RDsHHc
	SEPrtCNm13Jva36R/3bGcnWNLdNOVGTu8jqm90vYJE47XISVIVElmlGLohWqnAyZQpm0XJMu
	z1MpcpcfzsywoMg3mU+Frj5BAdcOG2IZJJ0pdsZ55BJSlqPJy7AhjsGl0eLUGrdcIk6T5Z0Q
	1JmH1MeUgsaGFjKEdL545wEhVcIekWUL6YKQJaj/pxgTFZOPDtptG3dbW7d4k33uUzOEx6Hs
	rK2dqp6KbbnVI8vUc7r7ml7v7w4nM/dXt+lKa4XAS0O/odr16uRAadXrhMTiLv/R82TH5lju
	yfZ4S3ka4zuhdXfE+KMuLFQmmY/HtyUze848N+5jns+xjUNsYkponnHXhzOjKW3BmFWZGaeH
	0qSERi5buRRXa2R/AUKjNwVJAwAA
X-CFilter-Loop: Reflected
X-Stat-Signature: jyiccyyphetubfspzwyuyamo7qgggy58
X-Rspam-User: 
X-Rspamd-Queue-Id: 061E4A0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392828-947784
X-HE-Meta: U2FsdGVkX1/Zc5seJAicTPxuAPJH6GYzKjsaHD7lyYZj+qW/UY0k+S+8QoGgf8sh6OdNtYgYuSy2wTu6YAfd92m8pULY88LrMTL/kBhkSG2UTxgeDdJaDKYZSDDtzcGA/kpJXaCKUczq+GOvndcu/P1FsqJRwjdWpqvz2mM4BpOuNAQxVVOQGqejqlt4HlSnO8cnRRIwbhsH26yvxTnwHA5RGo9fZW60b9ZknOfYTejJFq17viwmjTa62PKBBAuQd4QldXHDj17dWrfs2VnbYpo4lkcIe18yaJJKHZVGxekxz7QjaPF4CVUo2t1o4Qjnfz/X0ZhHXj5ibnvAknppFjUxjQhK31Tl9zbzvmD8iAle9LUA5NWYm9CN4jVqafER2gwlk9YFHF3WJU8EoB110m2ozNNgfjX5wb8X5M7l9dxzbbxGbueZR1mDfL6VdIYYcRX3kMn4pM7xRXLBpuczxkEnCaBUvYjaVzU1jLhMY+tcS3/XkGpuyY4QazYWvVqkDHOEalGIzbFnpCiOlUVPeTdQDdzFjchpRFJDrHpVgbN6xq9uJQhMy/FWrawCvqphcKVSRZWuWM+g1GOnGdvhdsD1dkz9FOKCVTWE5TmTIr1ROXQCdkACBb+4XcTVKmrQEmfNsUKQTjtuZs5iat21pAc1tAmb6kZsbl58wg9LnVVd+WDUNEsqTnUV5c5KHLiYO9DtHy3jplykTkS+8s20muoVNc2Vn5o4IsMIuyiogv+YlTFwrMc98vtYT8mTPig8mGKPJ1K1SvWLRd5eZ+OJuMQKFmaGFOtQgxaHMvc56abSnjSfn3/Oqyl2fFHoGN/7xLJ39uRRGd2LIKGWZFY5svs19f9YUhtv1crmkOb1Ygome6MtyjubtjTa36A4q8j0sDun5nCA/W6H4qEpqJu8WH2LVB4d7gAVoDcHZAD9E1/X0K8x395SYYrBIYssSwgnryhWuQioGZnPxWR9DBQ
 rLE6xKNO
 0N70XgvtYhuKHi5hEbimzgcXuNs21HfMBXdmNWvWbZVW3tEsfN3cDiZEg50t5L1AfB4R2RmyKbQycjCq2/XeEsfCLrMue8WqGTSfDW0NGd5sfQShe2UC5pDw2EO7e4kY4ohP/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that CONFIG_DEPT_AGGRESSIVE_TIMEOUT_WAIT was introduced, apply the
consideration to wait_for_completion()/complete().

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/completion.h | 4 ++--
 kernel/sched/completion.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/completion.h b/include/linux/completion.h
index bd2c207481d6..3200b741de28 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -41,9 +41,9 @@ do {							\
  */
 #define init_completion_map(x, m) init_completion(x)
 
-static inline void complete_acquire(struct completion *x)
+static inline void complete_acquire(struct completion *x, long timeout)
 {
-	sdt_might_sleep_start(&x->dmap);
+	sdt_might_sleep_start_timeout(&x->dmap, timeout);
 }
 
 static inline void complete_release(struct completion *x)
diff --git a/kernel/sched/completion.c b/kernel/sched/completion.c
index 19ee702273c0..5e45a60ff7b3 100644
--- a/kernel/sched/completion.c
+++ b/kernel/sched/completion.c
@@ -115,7 +115,7 @@ __wait_for_common(struct completion *x,
 {
 	might_sleep();
 
-	complete_acquire(x);
+	complete_acquire(x, timeout);
 
 	raw_spin_lock_irq(&x->wait.lock);
 	timeout = do_wait_for_common(x, action, timeout, state);
-- 
2.17.1


