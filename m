Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EA00D2E016
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE1D56B00F9; Fri,  5 Dec 2025 02:20:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C69C26B00F7; Fri,  5 Dec 2025 02:20:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5C66B00F7; Fri,  5 Dec 2025 02:20:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 72F956B00F3
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:20:04 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A595132F9F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:04 +0000 (UTC)
X-FDA: 84184568328.07.E5FD90B
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf11.hostedemail.com (Postfix) with ESMTP id 57A1740002
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:20:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=+4T9G9dNgkLm8yg5EH48kAGoiXiSXUHKELiGdsiR/+g=;
	b=8UGpZCarB+tvGmmWVjlZeYo9TQCkO6Mc80OyORIw40qm9G4ZXvrxSSR8cAskb8SJzJeyMg
	RwvTWZYZy6JEZQM94QoxbUu4tWy8dQFIENJp7t5kmhdRRi5DHFNbpEw2hCSx9CM281RtQa
	KsFbCpX7nK8sJnFu4aKM3/4veyc2q+k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919202; a=rsa-sha256;
	cv=none;
	b=ce2tz3AMqjvRypC+V5cbhQP0XR/3W0+c5DFF5U9R65HEDYYLi7vLJnSO3bmBqhMpXuaAAg
	+eDZnfYZEI2Laf6+wkv2SaHb0xlDb7GPlHQOTcLGdwIPxrOWakG6x5SjdzsPfu2AhkpA4n
	iezJRgHAEO7XNq+tXmFYYI9x/bE1Q84=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-2d-693287717bab
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
Subject: [PATCH v18 27/42] dept: assign dept map to mmu notifier invalidation synchronization
Date: Fri,  5 Dec 2025 16:18:40 +0900
Message-Id: <20251205071855.72743-28-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
References: <20251205071855.72743-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTZxTHfe597gudXS6d2R7dErXGmEhgSNx2NIvZsjjvzBKXGP3gskAz
	buTG8rKivGwxvAiDIQ5kqx+AyKsVSysEcAhSveIoIjDasdAOCsjW1ZiKGEIhpRBWa/z2O+d3
	zj85yeFpzSSzjZfTzkqGNJ1ey6qwan5zQ+x3JQlyvNd1EEqL88Az62VgokDBEFgqxVDbZmFh
	vaabg4euQgyOm60IZgOlCFZCNTQU92xgWK+yc7AUnOLAWIBgw2ZHcMVZRYOlq4AC/4NFBMY5
	LwsLpnIETweOgFcpQeC/8oKF0OgYDQ1z0zR02WcQ2FoKWRj3vgl/BRZYGDJeZGHeWUvB83YW
	nCN+BBea2sLkX6Ng1uTDYLTeoSBoMnMw0uTBYMrfDf+0VHNgb33CwXSFEcPN+TEG/L4qFmYH
	f2Sg4+8BBKW9AQy2yRjosw1hGO+tZaG8/RYDM5YNBvJrVhhwKMMMDNsfYhiqvoFharSCg7Fe
	KwNzj90MdI6O0OCu/A/BL8994UOWTfQnyaK58zdKtFy1IDG0WoXEpWsXaLG4MlwWdWaL14af
	saJtuR6LjxqJ2PzTKiX2VE9zYtHdSU6s7zgnFv0+z4hNfU8psWExwHy155Tq42RJL2dJhvcP
	JalS/jArKMP1Uc6gp47NRzOxZSiKJ8J+MlA4xb7m1TUH/ZJZYQ9xu4MR3iLsIJ2XfEwZUvG0
	ML6dlAR/joi3hG+I4ukOC57Hwm7iac55iWrhQ+L7F7+K3E5a25XIdFS4bXStRlgjfEDqylYi
	kUSoiyJNwRD3amErud/ixpVIXY82mZFGTstK1cn6/XEpuWlyTty36akdKPxxpvNrX99Gi47j
	/UjgkXazWsneJ2sYXVZmbmo/Ijyt3aJ+po+XNepkXe73kiE90XBOL2X2o3d5rH1HnbCcnawR
	TuvOSmckKUMyvLYUH7UtH5mP3eKSknYNfrZQYbF2BR4byTGq4Orn1rzytx/lLTbmPDh/VJfo
	9n9qztu7c2zmiSNkPezxVATl65ti3vAmSida4389Cve+jKOVQ8GL77VFp59aOhDvdu7o+7P2
	pOsuuTx1fOcPOGN9SGG7Y2/EtDkTQhNd0a7oiS8mHRO25Z5mLc5M0e3bSxsydf8D3Z7qXW0D
	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbWxLcRTG/e+9vb0rlasWrpKgMhOy2cTmBPH2wW4ImS+YeCu72Zp1Q8t0
	QqyrZjUvmUa7UGxqa6Qbm+6FkUZtDJuyKdbQqZcqy8aEzrTrNjXx5eR3zvOcJ+fDoXBRA09M
	yXL2c4ocqVxCCgjB+iWauH2FC2QJbdVRoNMeBY/Xx4NXagcB/QEdAReqq0gYMt3kg852jgeP
	OgsIaL9eicDbr0MwMGjCQds4QsCQvoUPgeAbPhjUCEbsLQiMHXoc3O13caiqU2Pws2aYhJ7m
	HwgM730klHSrCeiznERw3m/iQ/eDFPjqvcODka7PGHT+6kVg8Q1j4HMUIhgyZkGpuTaybvxO
	wqDzGQ4lhnYEl9934fCj+x2Cupa3COxXC0j4VFyPg8s3Hl7095Hw2HCChK8dFzD4VkNCWYGd
	Bx1PehBcNOkR+F/bMdBcqSbBeNFGQOO723zo6Alj4DHqMai0rQOvxU9AW7EZi5wbcd2YDKYS
	DRYpXzAwXLuDQdBi5a+oQOyA9jTBWmsbMFb7fIhkqy5VIXYwpEdsoEKDs9riSNvc24ezx2oP
	shVtvSQb6n9JsvZfZQTbambY8uMhjD3jjGMbz3fxU1duESxN5+SyXE4xf9lOQeZTqwPt7Vyk
	eugpJfPR27giFEUx9EImFG7H/zJJxzJud3CUo+kZTO0pP68ICSicdk1nCoOnR4WJ9DbG4bkZ
	ESiKoGMYT7nqLwrpZMb/kfgXOZ2prHGMuqMiY0NnaJRFdBJTWjTAK0aCMjTGiqJlObnZUpk8
	KV6ZlZmXI1PF796TbUORb7IcCZ+5hQKulCZEU0gyTug4mCgT8aS5yrzsJsRQuCRa2CtPkImE
	6dK8Q5xizw7FATmnbEJTKUIyWbhmE7dTRGdI93NZHLeXU/xXMSpKnI/ikz+Yr4rLVcsnZYjn
	TE07Xna/dcLqkHfK4iezUw8NhrfrhrepVc76fKO1PmlgGtpqnXcv+1Hu7Gazxh1ucs90f451
	DGvH2sR9rWdTsMOr1m4Onmp4ecSnr2y0WgNxydPymt/EuxPTahI2uFy7nHUxv+t+L97YVaAR
	0/xZcudSrYRQZkoT5+IKpfQPavH1GEkDAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 57A1740002
X-Stat-Signature: 6wsjchuaqbnrbhd6jyyrch98w47hq8tx
X-Rspam-User: 
X-HE-Tag: 1764919202-996964
X-HE-Meta: U2FsdGVkX18uySzU1BgTcOaur312S7EUBX/n7S9P3D6+BGVPUD2A0f39p/c2i4EiZgsFBldLmNKn90RzyN9PS0jHW9MGo3eGLJy4eUinb+CsSxtalb0xpcA+qd0kWrWMNKFMHLCSAI3LPrYbVb7RawXZT5ZtbXRYUAUqk0lZklIAcfmTkdb9YS59d3yjm/pWC34ZRnWxfx+C+5xaltTMZd34b45fsfiMRqV0eGmSmpgTC3jGQuTwtU2/0Rq1y69L3qrObwRQZQ/wp5mQVpibmyRDM0MlKYxwyiy0FOBXQyReY3twc39hrb4bSDsc+SuSzw/DFmNwmIEeZKzkc3WcxJBm9UcGfOazmbgtyzDvYhzx/619nZOF/6RI9+mfg7ZDXwipMkLh/pXZb1z4aoOQF2VI0JXp+O/kZavIcdA9dpLA8VwkhRSck5tCqPSSMt59+mwvxO0XZbz5a+ei3lROQYAZ0bQEn4xGsrGtbeW19t7VrB3XHp5okaTyYN7KClyzdq2TF78dLr003Zkbg3V2nT4YgSQjJCPN0gg4Zd7Ah8c/JHA/7tplWU2YV5ynp5PFHW8EIfLokBsA8q9iiXEHNkL3ZrzkLYG5We+0VwAAP+myY+p6InOLsdKLvkWC+TVpWE9oSI5Wd239FHKD3FGI56G4rc4Q8ktfEMMA/VrJaafYQuF+N5mWNks7Zso7G9sz3EK1yaYMUmKKF4RER7jochIrWr4qXHsoZuFz+LXNqqCvws7uuBsVvLnCWLIlR5N8MVfC1ajKSuSgvQbsgrskWp0Xa0PRuVdHhvlj/QQAOUYXLdTRQnhWw1CiSk1U9LaRgm8dpA22kfX/grpL9D0VKJH8v2E754etCr2ctTz57fuvwZQz6aE5gKMg0aqq2YQ7sZ4o15shaQwLkqTZgkRvcCEMdTKu4YLar7XjiO2nuTWYGm3E6tX/EC510+7QzWCG2+smbJa2qLvawV2y3SO
 EjsIUSKr
 WHF6UsTS1IEHTnEn8j7Zo7Rlc6G/MwKqS90cudwDWF5iji6KEtkCcUcEZLsz+rdowMjgydCNIFhpVtGc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Resolved the following false positive by introducing explicit dept map
and annotations for dealing with this case:

   *** DEADLOCK ***
   context A
       [S] (unknown)(<sched>:0)
       [W] lock(&mm->mmap_lock:0)
       [E] try_to_wake_up(<sched>:0)

   context B
       [S] lock(&mm->mmap_lock:0)
       [W] mmu_interval_read_begin(<sched>:0)
       [E] unlock(&mm->mmap_lock:0)

   [S]: start of the event context
   [W]: the wait blocked
   [E]: the event not reachable

dept already tracks dependencies between scheduler sleep and ttwu based
on internal timestamp called wgen.  However, in case that more than one
event contexts are overwrapped, dept has chance to wrongly guess the
start of the event context like the following:

   <before this patch>

   context A: lock L
   context A: mmu_notifier_invalidate_range_start()

   context B: lock L'
   context B: mmu_interval_read_begin() : wait
   <- here is the start of the event context of C.
   context B: unlock L'

   context C: lock L''
   context C: mmu_notifier_invalidate_range_start()

   context A: mmu_notifier_invalidate_range_end()
   context A: unlock L

   context C: mmu_notifier_invalidate_range_end() : ttwu
   <- here is the end of the event context of C.  dept observes a wait,
      lock L'' within the event context of C.  Which causes a false
      positive dept report.

   context C: unlock L''

By explicitly annotating the interesting event context range, make dept
work with more precise information like:

   <after this patch>

   context A: lock L
   context A: mmu_notifier_invalidate_range_start()

   context B: lock L'
   context B: mmu_interval_read_begin() : wait
   context B: unlock L'

   context C: lock L''
   context C: mmu_notifier_invalidate_range_start()
   <- here is the start of the event context of C.

   context A: mmu_notifier_invalidate_range_end()
   context A: unlock L

   context C: mmu_notifier_invalidate_range_end() : ttwu
   <- here is the end of the event context of C.  dept doesn't observe
      the wait, lock L'' within the event context of C.  context C is
      responsible only for the range delimited by
      mmu_notifier_invalidate_range_{start,end}().

   context C: unlock L''

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/mmu_notifier.h | 26 ++++++++++++++++++++++++++
 mm/mmu_notifier.c            | 31 +++++++++++++++++++++++++++++--
 2 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index d1094c2d5fb6..2b70dce149f0 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -428,6 +428,14 @@ static inline int mmu_notifier_test_young(struct mm_struct *mm,
 	return 0;
 }
 
+#ifdef CONFIG_DEPT
+void mmu_notifier_invalidate_dept_ecxt_start(struct mmu_notifier_range *range);
+void mmu_notifier_invalidate_dept_ecxt_end(struct mmu_notifier_range *range);
+#else
+static inline void mmu_notifier_invalidate_dept_ecxt_start(struct mmu_notifier_range *range) {}
+static inline void mmu_notifier_invalidate_dept_ecxt_end(struct mmu_notifier_range *range) {}
+#endif
+
 static inline void
 mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
 {
@@ -439,6 +447,12 @@ mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
 		__mmu_notifier_invalidate_range_start(range);
 	}
 	lock_map_release(&__mmu_notifier_invalidate_range_start_map);
+
+	/*
+	 * From now on, waiters could be there by this start until
+	 * mmu_notifier_invalidate_range_end().
+	 */
+	mmu_notifier_invalidate_dept_ecxt_start(range);
 }
 
 /*
@@ -459,6 +473,12 @@ mmu_notifier_invalidate_range_start_nonblock(struct mmu_notifier_range *range)
 		ret = __mmu_notifier_invalidate_range_start(range);
 	}
 	lock_map_release(&__mmu_notifier_invalidate_range_start_map);
+
+	/*
+	 * From now on, waiters could be there by this start until
+	 * mmu_notifier_invalidate_range_end().
+	 */
+	mmu_notifier_invalidate_dept_ecxt_start(range);
 	return ret;
 }
 
@@ -470,6 +490,12 @@ mmu_notifier_invalidate_range_end(struct mmu_notifier_range *range)
 
 	if (mm_has_notifiers(range->mm))
 		__mmu_notifier_invalidate_range_end(range);
+
+	/*
+	 * The event context that has been started by
+	 * mmu_notifier_invalidate_range_start() ends.
+	 */
+	mmu_notifier_invalidate_dept_ecxt_end(range);
 }
 
 static inline void mmu_notifier_arch_invalidate_secondary_tlbs(struct mm_struct *mm,
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 8e0125dc0522..31af5ea54a0c 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -46,6 +46,7 @@ struct mmu_notifier_subscriptions {
 	unsigned long active_invalidate_ranges;
 	struct rb_root_cached itree;
 	wait_queue_head_t wq;
+	struct dept_map dmap;
 	struct hlist_head deferred_list;
 };
 
@@ -165,6 +166,25 @@ static void mn_itree_inv_end(struct mmu_notifier_subscriptions *subscriptions)
 	wake_up_all(&subscriptions->wq);
 }
 
+#ifdef CONFIG_DEPT
+void mmu_notifier_invalidate_dept_ecxt_start(struct mmu_notifier_range *range)
+{
+	struct mmu_notifier_subscriptions *subscriptions =
+		range->mm->notifier_subscriptions;
+
+	if (subscriptions)
+		sdt_ecxt_enter(&subscriptions->dmap);
+}
+void mmu_notifier_invalidate_dept_ecxt_end(struct mmu_notifier_range *range)
+{
+	struct mmu_notifier_subscriptions *subscriptions =
+		range->mm->notifier_subscriptions;
+
+	if (subscriptions)
+		sdt_ecxt_exit(&subscriptions->dmap);
+}
+#endif
+
 /**
  * mmu_interval_read_begin - Begin a read side critical section against a VA
  *                           range
@@ -246,9 +266,12 @@ mmu_interval_read_begin(struct mmu_interval_notifier *interval_sub)
 	 */
 	lock_map_acquire(&__mmu_notifier_invalidate_range_start_map);
 	lock_map_release(&__mmu_notifier_invalidate_range_start_map);
-	if (is_invalidating)
+	if (is_invalidating) {
+		sdt_might_sleep_start(&subscriptions->dmap);
 		wait_event(subscriptions->wq,
 			   READ_ONCE(subscriptions->invalidate_seq) != seq);
+		sdt_might_sleep_end();
+	}
 
 	/*
 	 * Notice that mmu_interval_read_retry() can already be true at this
@@ -625,6 +648,7 @@ int __mmu_notifier_register(struct mmu_notifier *subscription,
 
 		INIT_HLIST_HEAD(&subscriptions->list);
 		spin_lock_init(&subscriptions->lock);
+		sdt_map_init(&subscriptions->dmap);
 		subscriptions->invalidate_seq = 2;
 		subscriptions->itree = RB_ROOT_CACHED;
 		init_waitqueue_head(&subscriptions->wq);
@@ -1070,9 +1094,12 @@ void mmu_interval_notifier_remove(struct mmu_interval_notifier *interval_sub)
 	 */
 	lock_map_acquire(&__mmu_notifier_invalidate_range_start_map);
 	lock_map_release(&__mmu_notifier_invalidate_range_start_map);
-	if (seq)
+	if (seq) {
+		sdt_might_sleep_start(&subscriptions->dmap);
 		wait_event(subscriptions->wq,
 			   mmu_interval_seq_released(subscriptions, seq));
+		sdt_might_sleep_end();
+	}
 
 	/* pairs with mmgrab in mmu_interval_notifier_insert() */
 	mmdrop(mm);
-- 
2.17.1


