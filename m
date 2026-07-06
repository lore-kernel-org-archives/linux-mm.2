Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3BB6C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6846B00AC; Mon,  6 Jul 2026 02:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7579D6B00AD; Mon,  6 Jul 2026 02:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620066B00AE; Mon,  6 Jul 2026 02:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36F546B00AC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:20:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ABA97402BE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:07 +0000 (UTC)
X-FDA: 84957351654.14.CA3013D
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id C4BA220002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=9L42UlAi0lnEWkGneTJh/gJQ27vEegAk+CTaFEWxGWI=;
	b=xCI+JKz421l2EDOKFAulgKaHfvnSJtGZ0CN+9vvrQfUXBw9h0+Cjw45mFbC9aW/IGcZvcO
	qlZRwjklvl5yAcMTTj3FaL8NyPLyaw5Meg9T3T2H3v2ecDCMrrSCwKbbnkDIDa1jD1xpT4
	26vZftM86jvN+UcCuWrd4ediHEz4AeM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318806;
	b=I91D/Mtoo1adwVvS/ctvIaB+O2PfGsIjyiFjyVM+DYJ/qNFnud8jO9H/HgHWQ/33BZydpm
	IposlUndpQhMh644shLrSWrpHU3ErrE8AX5REkCWPD3Fx9csd10ia7pnH468kwW2VeRZpU
	rwMQIQIK5I79W9JBlg5XwXPS1mu8NYI=
X-AuditID: a67dfc5b-c45ff70000001609-0e-6a4b48fc46c2
From: Byungchul Park <byungchul@sk.com>
To: linux-kernel@vger.kernel.org
Cc: max.byungchul.park@gmail.com,
	kernel_team@skhynix.com,
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
Subject: [PATCH v19 07/40] dept: distinguish each work from another
Date: Mon,  6 Jul 2026 15:18:55 +0900
Message-Id: <20260706061928.66713-8-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTZxiGfc95z0c7ak46M86YU9ONzTl1asQ9OmPULfpG92ObWbKPH3Iy
	zqRQ0BXkw2QRFLQDdNhJcRQWxke30QZYS53gNIpQQKgWWWY3WiuTlRBXjFgkE0pHMft3Jfdz
	X/efh6fVt5kEXpuZLeszJZ2GVWJlKK5uzRzZm7bufN9LYCg+Cr7AKANTYQMGg/1bBnpvH8Pg
	abYiCEwZEBS3RzFEjC4OKgoRRC+5EJgGjTTY2gopeNQ6x0LleCGGqqCZg/Hu3RAKXGQg6h+j
	wDI6R8HolZMIIqZ0mHHfpKGywoPg+xE/DZPjdxG0ue4g+LvcScPQ6GLoqyhlITRYTcFEKwuD
	A/cR1JiN83M1dgw+k5GCgCWIob+8jprfZMH0czyYK49TMFDvw2B2DzEwO7IeXNYxDppDNxkI
	9Jxg4JeCuxzY/+hGEP5thAJbWZAGQ8cUBvu93xkwRMIIXBf+omCoo5qFslYnA3dsUQYKzNMM
	3LJ6MLSMeSnod/Vi6Kv6CcOw+2tuewqZLj6NSZPjPEWKb0VYYvvOhsjMEyMi4cbjNCly5JLG
	/n9YculxLSbX60TS8NUTipxxryHtVX6OFF3+kyO19sOkqCvEvLfhE+XWFFmnzZH1b2xLVqZ6
	3JepQxNcnsVkRQXoV7YE8bwobBQnxl8rQYoF7B1ooGPMCq+KXu+/C7xEWCE6TgWZEqTkaWFo
	uVhmOYVjwbPC22K48hsUYywkig+vn+ZiTpWQJIa7pKfO5aK19cqCRyFsEptna6gYq+dPhh/0
	4JhTFFoUYss1J/e08Lx49UcvLkeqWrSoCam1mTkZkla3cW1qfqY2b+1nBzPsaP7dLF/OfnoB
	TXr2dSKBR5o4FWzfk6ZmpJys/IxOJPK0ZonqlZV709SqFCn/iKw/uF9/WCdndaIXeKyJV214
	nJuiFg5I2XK6LB+S9f+nFK9IKEBlUrL/o82fOz8sjbYrXz/nfKfnSEWev8hVfn+n7oddWxO6
	e84mXZ0ZfDn8KD1p9q1nHPHnbuwxde3SUrXKSXifa44ocrunt7Qt7muK+3h42ZZtA9Wr1Jvx
	ieTVOxqWZtev7GhJfHffOq/vC9+bic+VXuwMOuI9c3X7bzTWH0XpYy9+sFqDs1Kl9atofZb0
	H7vvoU1qAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSfUxTZxTGfd97e++lWnPXYbxBE02NbnMRNYo5U+NH9odvdCpLluwrRm/g
	brTlQ1tEIVEppRFRDHZpiRaUMWkcLVCBqQwriIoINoKooIjVrFYJSBULBmjFotk/J7+T5zlP
	nj8ORykvymI4dWq6pEsVk1WMnJZvW2NcEiJbNMuG8mMhz3QIHnt9MnhgaKJhJJhHQ3G1k4Gw
	7SILeTUnZdDanUNDR5UDgXckD8G7CRsFpvpJGsLmFhaCY70sWAwIJt0tCKydZgp6OhopcNYZ
	MLx1vWdg4NowAsszHwNF/QYaAvZjCE75bSz039gEr7wNMpjse4Ghe3QQgd33HoOv6TCCsFUL
	Z8pqI+fW1wxMeO5QUGTpQPDnsz4KhvufIqhreYLAfS6HgeeF/1DQ5ZsJ90YCDNyyHGXgVWcx
	hiEXA6U5bhl03h5AUGIzI/A/cmMw/lXNgLWkhob6p/+y0DkQwvDYasbgqNkKXrufhvbCMhyp
	G3Gdnw22IiOOjJcYLJUNGMbsFeyGckTemY7TpKL2Aiamu2GGOE87EZkYNyMSLDdSxFQYWa8N
	BiiSW7uPlLcPMmR85D5D3KOlNGkrE8jZI+OYnPAsIfWn+tj4jb/I1yZKyeoMSbd03S55Uofn
	Ct49xO63Wx0oG11m8lEUJ/ArhdbbZ6kpZvgvhJ6esY8czc8Xagv8snwk5yi+a55wzF5ATwmf
	898KwaI/0BTT/ELhTdtxNh9xnIKPE4LXxU+Z8wSHq+ljThS/SqgKleApVkYsvYGbdCGSl6Jp
	FShanZqRIqqT42L12qTMVPX+2IS0lBoUeSf7gdCJSyjYtakZ8RxSzVDAhs0apUzM0GemNCOB
	o1TRikVfbtEoFYliZpakS9up25ss6ZvRHI5WzVZs/lHapeR/F9MlrSTtlnT/q5iLislGXy/P
	GcYrNLb4aTOSpv902Xl41rnWhIWDXd+8ERu1e7Pky67kan0FcRqq0pIQl0gMM3XsD59djakU
	XLq5P3sOVtfVuxcvSsu+ef370HfFroZ4e/XYDa9nh7p7j+O3r7q3Z+WuzrjayK33BdJH/W29
	Z249/G/BTu2v8j1V4QNrje3Rf6tofZK4fDGl04sfAI6fsMZKAwAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C4BA220002
X-Stat-Signature: thctt7yywoaoybragzmbakgqs4wttfso
X-HE-Tag: 1783318805-820692
X-HE-Meta: U2FsdGVkX19wfJUZhLuUjNOLyRzzcEx2/nR3v/Z+rQKXBnf6w8yj5jhOWPoX0/2AfN4IY8LxhHx+rz2IA2+CWOha/h1mbKis7pnMdqLcegv40WFMtVNJLWW5bQkPEyjDgtLx8TaUXUCzKSOLeFLTGV8UHTbds8Fv2hF+o3HuIxBIPpZkJOpJGgrjGZZ/wNEmVM3acjt36bImETij3XYXaO0Oc/6Gq0qvUnIFrR5nuH1HuNXq3KMUubSGMY0wVgEZEo+Vg0Iy5cJ4sX5ISFC+taHNRRnbF1TqtN3//smblI1LStcgzCPncTe/4hXqLUrg/yvUktufj5RiV19gNC/SvkUu1x/ylgfYvJjb6+DvtYXGUj1rfy1IdRN7lrIN2XR3nw8YMpiD3goMatBKSv/TgMYjX3e7Zntp5lbXHHhZFvZPXBob/qV2I/ODQaAjHVdUiT/8BWWnpbLKL49z5HCBDq6A7UeO3CYTnxPJQmQiQ7lPssw5HKmKU4su4jExe7c7WNBZi0KSxHn4G9YV80xe/PQeV+eprLEV24a/g+3OtioWimo5VWtR677t+RH6b3vVkgkgDWkbNICOzTHxar8ka0IKuuQcOU3rwht+YTzYDpq+QaGTHmYt3c8Lhr6Kb51Ds6QLz9TpDSf6O14gpH9+cpGxKNvJCOqwmY7i2RS+2LnULxU/YkF9Pz5cs75p28jTPJkJpinJn65zU6XF3fQfoabc2ezJJA3l+BSlpz+EMEwAXKItwEuAWERo9NWIKPfLb1KuYfyTjh73YO9WfK7bQCvZ96fnn0d5V9Tb245bjr16blfOQe3zQrkMk1aDNCEunpEoRAKS+0LLznFdH/X5x/SADH5kotwO+JZiJD7+4nzRvQ+xS3dxu+ccH1yHeK1t02fN+3XRnT48NTJxL5nTM7H+jYr7Ri4WXQaih3i/OObbLMUtUXuCGpNQZoM33673hCMf4UTioNqq7WbFPxl
 KMfyxtaw
 vGztZJzZBlX5A0ihbWz8rZ/3gcryubvUQPYjToOF6fCs4aD0h5W4OYGARY0+E/OuaPUtlIYF3MA9H7dzGPJNzDSw4k5joewmx9Y8H7IIhHtOJiRZLjAKg/fGpQL1QSSZnI54n8pB+itJDt8QW3hPjONkHmUd5VOL8WA7G1tPRFIUuw9fGDw+XAQol+yZAsX5zxBpS677NEguAfpw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Workqueue already provides concurrency control.  By that, any wait in a
work doesn't prevents events in other works with the control enabled.
Thus, each work would better be considered a different context.

So let dept assign a different context id to each work.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 kernel/workqueue.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c6ea96d5b716..4a4075d0697c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -55,6 +55,7 @@
 #include <linux/kvm_para.h>
 #include <linux/delay.h>
 #include <linux/irq_work.h>
+#include <linux/dept.h>
 
 #include "workqueue_internal.h"
 
@@ -3204,6 +3205,8 @@ __acquires(&pool->lock)
 
 	lockdep_copy_map(&lockdep_map, &work->lockdep_map);
 #endif
+	dept_update_cxt();
+
 	/* ensure we're on the correct CPU */
 	WARN_ON_ONCE(!(pool->flags & POOL_DISASSOCIATED) &&
 		     raw_smp_processor_id() != pool->cpu);
-- 
2.17.1


