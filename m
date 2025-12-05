Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8343D2E014
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A1C36B00EF; Fri,  5 Dec 2025 02:20:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42B7B6B00F3; Fri,  5 Dec 2025 02:20:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22F9B6B00F4; Fri,  5 Dec 2025 02:20:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9EC6B00EF
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:20:04 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C29041404CB
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:03 +0000 (UTC)
X-FDA: 84184568286.28.89AB0AE
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf12.hostedemail.com (Postfix) with ESMTP id DB78140003
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919202; a=rsa-sha256;
	cv=none;
	b=Myar3xAegz+AMcJl8AgiZXFUL4ncec7YQKQFoDdGsmELBK4yCB4QqmJ0KQbjzwXpRIenwb
	qZsmhYOyj2qu2U94/URJPCJxrrCmwBQ21dHH0591TynAXGtDtHKj9DQMnC2ur3lph5Kjro
	IQ/TCG7kNYagZbZRVJnQPVvAaTUK3gE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=sqKCUYvTEL0QfEQLLHtpn7/BP7cPLb8G8O66py6Jf8Y=;
	b=R8U3bzcm2coBoILqlF6eFIXTPlimVv8JwOO3BNcq0tzwL7SjNyzKJ8peQpr/coN1kDV1vT
	uNv7QLdKCGjETIDFvo5xJBrMOTEGIoLk3aSCPvofqi1g/nYK917lua3qb9iVktSjNEM+wj
	lL/+i35UVI4KX1jWtqzRtnaPbnNky2g=
X-AuditID: a67dfc5b-c45ff70000001609-0f-6932877193dc
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
Subject: [PATCH v18 26/42] cpu/hotplug: use a weaker annotation in AP thread
Date: Fri,  5 Dec 2025 16:18:39 +0900
Message-Id: <20251205071855.72743-27-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSX0xTZxjG+c75zulpQ+ehmHCELJomymIiA4PkNdGNC5OdJSabcReGXYzG
	nozGAtoKCNEIQUQJOmBpG+iU2m6dGwVqURFEx59RcCiUAVIRqCfBIqmIQQoCRQbddvfL8zzv
	7+plSMUIFctosk4LuiyVVknLsGw20rrnVOleTWK/bweM+6YoeFrUjuGnRgcNa+ZmCXga6hD4
	gpcQLK2aSShpWcewsPxcAoYiBMbBKhK8nj9IeOf8QEOgax6BQZyiwTRThGHOXo5gpvsLGF18
	jWDNeAJqrU00rD4ZIOGGOEHCbfckgpcVd0gYmvoIhoNzNLxx0jD4OIDgmrkKgX/sAQHFtkYa
	jNdcGFpetEpgMBAiYNxYRYDP7sfQV2ElwHgrBsymYgIM9fcJeGwbx2Av3AkhMQnWLdngrpuW
	wMQPBgwNswMUPJp8SkHAX0WDr+ciBa5n3QgWhkUCHOV+Ei61BjFUXx+nodx5h4JJxzoFheYl
	CjztfRT8XefB0DjtJaDP3YvhUc1vOFXNL5VcxbzjugPxC78Uk3xJxQatBEdo/sGiBfN/WTn+
	58srBF/5ZA/fUjMh4S2uHP7Cn7MU33RzN29rmyH4G/NBih8LHPw6KU12QC1oNbmC7tPP0mUZ
	3f126uQL6RlDvUgWopCkDEkZjk3mxPvVZBliwtxXo9+MaTae83qXyU3eyu7gmq74qTIkY0h2
	aDtXunx1o5Aw0exhbhRtTjC7kxv+MBY2ytkU7seHU8S/9u1cnbM9rJFu5IbRlTAr2H1cbdlS
	WMmxNilX2mX972Ab13HTiyuQ3IIifkcKTVZupkqjTU7IyM/SnEk4np3pQhvPZj8X+vYemvcc
	7UQsg5SR8va8JI2CUuXq8zM7EceQyq3y19pEjUKuVuUXCLrs73Q5WkHfieIYrIyR713MUyvY
	71WnhROCcFLQ/d8SjDS2EKUeCwZPbamOcqTfHYg2x+2XvD9uRr4ec3Is3G1OjMgTX60eeTgd
	dUixIr413J6Miajc97E43fP54eFd7oyUXabzebNHv0nbgkMW061GT7y64OzIm09eVs792rqA
	osi4e2s5Hfqv3MeietPwEWmx05biik9exqaChre1bc3v5F8qsT5DlbSb1OlV/wAtETepaAMA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0iTcRTG+793V4uXNfDFPlgju4GaXQ/dKPrQSze6QaVIrnzJ5TTZylph
	eWm5VslabJbTMssROtPULqtWYiWVZa5Vk3LpYi1Fa1GaeF0z6Mvhd87znIfz4TC45DYZwSjS
	DwqqdLlSRokI0aZledEZ+fMV864aloBOewLaO3wkfMhpIKC/T0dAcbWNglHLXRp0tZdIeO7O
	JaD1ZiWCjn4dgoFhCw5ae5CAUWMTDX2Dn2gw5SAIOpoQmJ1GHNpaH+Ngq8/B4HfNGAU9T34h
	MHl9FBR25xAQsJ5FUOS30ND9bC1873hAQtDzDQP3n14EVt8YBr6GfASj5lS4UlYXWjf/pGD4
	9RscCk2tCK56PTj86u5EUN/0GYHjRi4FXw23cXD5JsO7/gAFL0xnKPjuLMbgRw0FpbkOEpyv
	ehCUWIwI/B8dGORdq6bAXFJLgL3zPg3OnhEM2s1GDCprN0KH1U9As6EMC50bct0KB0thHhYq
	XRiYqh5gMGitoFeVI35AW0DwFXV3MF77dpTibZdtiB8eMiK+rzwP57WGUPukN4DzJ+sO8+XN
	vRQ/1P+e4h1/Sgn+ZRnHXz89hPHnX0fz9iIPvXl1vGh5sqBUZAqq2JVJopRnLVYyozPsiKnK
	i2ejEVqPGIZjF3LNRWo9CmModhbX1jaIj7OUncbVnfOTeiRicNYVyeUPFoQEmpnCbuDcaNxC
	sFHcu7GP9DiL2cXchUc+bJw5NpKrrGn4FxMWmpvcQ/9Ywi7irugHSAMSlaIJFUiqSM9MkyuU
	i2LUqSmadMWRmL0H0mpR6JmsWSPn76E+19pGxDJINknccDhOISHlmWpNWiPiGFwmFfcq5ykk
	4mS55qigOrBbdUgpqBvRVIaQhYvX7RCSJOw++UEhVRAyBNV/FWPCIrKRRbM1a8LOxDWBh9js
	yOT7XYnToxbOrNpeM9+7c/2p9kDWBq5F6uHKN7o++e2ap8EvJ7s82/BZ8T1JzJxtK5a+sb1t
	3x+ccVyqbY6dWBS97pJXcFtONVZHrAh3FVw8PeNLdrFr5WTl3jPdCxI6t8jWHIvak2ralaFL
	GG5xZtnjPAa9jFCnyOPm4iq1/C/j3+wqSAMAAA==
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DB78140003
X-Stat-Signature: 797dna3japto71egk6h63dkf5q7u1sar
X-Rspam-User: 
X-HE-Tag: 1764919201-975839
X-HE-Meta: U2FsdGVkX19vTSeZiOzbOhEj5coCqWzoUmJISmwjFwUQ4iVIgapsDk8hnqjcDMxCyPvjyj5LXu7zaalCFHVFPPQV+gbspNKWoCBKL+tQzEwAKrn7lbBWXRlM4i03vKFzfjCHEQf2o740x5Ckeu9RAJYheLsEtSyb3XzlaU80CrslUz6m4vGGJ93IBV+S57Kp9BkwJ/55RWkw3Q4uWIKW2GIkZ0CLmWCF+KfCnIs/D2/r43SaGj5blB+LRJz5Xha/4aCIrtynoY/YqnIwrOuiD+IColq/O7f3SO++d96zn+S1M1p2j3ZxNafYxg67wf87mlL3KJ2voGDm9suHi0ishrle1qzwRDV2aJBOllTHUcE89sC6qUHQgdxg42Lwujsfumz0BZE8IogAiOmbxxgPwpOBdqELhFXt2L/mQxonPewqdDfDHDBgZfJdHc5PgU4nkYVaH7lHWSEbJQQefk/m6Uz2dpNfgn8g0bUzK7LWCvYjKifpqYaoYCw/ZJk4B9byfybtrTeQv/2rE+40ws9+QJpYu9G5wdIgmWxe6Iur0Am1/3i7BG1ZuuOnrmIKF4npyoKV87y+Vl3B1wMCS2rqOh2Keg2xsxZ3DXfkMDdmNp5TMF65XeYuOTHuQWmiQgypkjAVkp10Pa3XAxrKeOlp+yF/vMyrFzcwYdEOZIipIYocT6hMkI2ypvI31d5mir6uJdR+1Udf427lec7aP4GjNU3iS46Es+ws555V303jkA25eL22DAp9IlRaHPqAr3X0iGewErAAhLmQpCgiBoBwh5d9zpNSV2L0v0uU4+LZLJH2U9e61BwaBkaxxHVB71kBIEeGYg0zUDjS8bm1VHE9nZWw9yjvv8CJUskECcJdPjAS2MrFnIbL9bLU9GxkhK0bZuh6eql7sGOfmux+HPWv3PeuyMGyLooPjj0PC9M31UIyTeK9IZzCy2aVGsr+HvGpkTHz2wci93jSYSj5Dty
 DTNnWa0a
 gdJVFFpz2eZq68p0qmIWz7ne7ypmNEQyXQ+q98xj+OLcpGl0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cb92173d1f0 ("locking/lockdep, cpu/hotplug: Annotate AP thread") was
introduced to make lockdep_assert_cpus_held() work in AP thread.

However, the annotation is too strong for that purpose.  We don't have
to use more than try lock annotation for that.

rwsem_acquire() implies:

   1. might be a waiter on contention of the lock.
   2. enter to the critical section of the lock.

All we need in here is to act 2, not 1.  So trylock version of
annotation is sufficient for that purpose.  Now that dept partially
relies on lockdep annotaions, dept interpets rwsem_acquire() as a
potential wait and might report a deadlock by the wait.

Replace it with trylock version of annotation.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 kernel/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index b674fdf96208..06ec3ae1446e 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -538,7 +538,7 @@ int lockdep_is_cpus_held(void)
 
 static void lockdep_acquire_cpus_lock(void)
 {
-	rwsem_acquire(&cpu_hotplug_lock.dep_map, 0, 0, _THIS_IP_);
+	rwsem_acquire(&cpu_hotplug_lock.dep_map, 0, 1, _THIS_IP_);
 }
 
 static void lockdep_release_cpus_lock(void)
-- 
2.17.1


