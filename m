Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29A69CCA472
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3086D8E001B; Thu,  2 Oct 2025 04:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21AEA8E0007; Thu,  2 Oct 2025 04:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0481B8E001B; Thu,  2 Oct 2025 04:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E247B8E0007
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:13:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A9B251A0357
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:41 +0000 (UTC)
X-FDA: 83952460242.25.112F356
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id C1ACDA000A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=fw/GnWI+ob5biLeRQRa06lLRoD0rgXX9Xy5Y1IZDN9U=;
	b=BDGwKVB04Q5h3Hj18ZOYn6oHC9ldaGDD5Q5RQVCuaZY7jq2a0V0CLQnv99f+jr5zSH3rjf
	J4Tu6RlixriZHk4sps4Qs8LJLvhN6E5cVwNgq+FODivL7tvL7VXNA3difRXR3K5RjsZPIs
	zREy4iHYypr666L9KDa8ndSxIYmVt+g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392820; a=rsa-sha256;
	cv=none;
	b=dyOqtmXAq+OQqzpATDbuwoyvTTuswdZTF6WFNIVEM6cWgwn+XnK0EJEH0cikGaIuvtk1T6
	tGWpMLFh3PDkfxwSDi3BTs5/TQx4awAoPtbRwOnhCgGi4ekaoysKduDZPiWIp2EhA6biHw
	Ul9TZTTse1oJhKUYrj8kfSFRXx6EA04=
X-AuditID: a67dfc5b-c2dff70000001609-2e-68de340eafb4
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
Subject: [PATCH v17 15/47] dept: apply sdt_might_sleep_{start,end}() to waitqueue wait
Date: Thu,  2 Oct 2025 17:12:15 +0900
Message-Id: <20251002081247.51255-16-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0xTdxjG+Z/zP6eXtO5YXXZEF0yNTHHiJahvojO6fTlfSGYWL3Ex2qwn
	ayMXVwRlBi1a1HlhpaYQWoeVKAKthrSdkSpLRahW4mhFsChFLqVu1kqipQYR2YHpt9/7PM/7
	Pl9eMal4SqWKtXn7eV2eKkdJS7E0Lqtd/llWv2blk2EWekq9GMYSJzFMmnwiSIw/FcFUiw9B
	ZdBEgsNdSsCbpg80mAcjNFT9W4phtO4MAkvUKuTCzwl4nHyJoC7ygYCI9wSCycq9MPGgk4Qq
	cwDBxcEwCf80Cbrb149gxPgnCV2RWfBobJQGv/k0DfHgeQJsR1so+MNqQtA84BFBMPaeALsz
	W+ijwVp1jADz1ZsEDNVbhE5bPvjsz0UQ/t2M4Vq8kwJ/fw8FsaiJhmd3j1Pg7G1H4DgTJcE5
	LBgXj1/CUF3TR8PJyQQC340hAro852nod0xRoLe+pSDg7aDgoT2AocN3D4Pf0oCh03OVgsGB
	EAXJ8vkQMo4gOPcqiiCWrCPhoddGbFJzb8vKMdfouk5wjhoH4ibemRCXuHyM5MqMwnjn5SjJ
	GVwHuHdj3TTXkrRh7n4ty1U8WM41W8IizvDXExFncxZyhrY49f2KndINaj5HW8TrVmzcI9W0
	xfV4X7nkYPVdD61HZ0WnkETMMlls97Cf+sTegWczOs18xYZC4+Q0z2UWsq6z0ZkMyXQsYHuC
	X0/zHGYbe8LoJqYZM4vZ7oB1Ji9n1rK9wd/Q/zfTWHuTd0aXCHrXYAeeZgWzhi0bNQi7UiFz
	QcLWVIx9XJjH3q4PYSOS21BKI1Jo84pyVdqcrExNcZ72YOZP+blOJLxcXcn7H2+g14EfWhEj
	RkqZPLA4rFFQqqKC4txWxIpJ5Vz5nvo+jUKuVhX/yuvyd+sKc/iCVjRfjJVfyFcnD6gVzM+q
	/fxent/H6z65hFiSqkezdq3XJ141ar/T334BCzY3fZkCve7UtoytxEjf5sLs2fElq18vUnSl
	RewTw2lrrrcPTY3f2/6NW5V+ZNkh/7yYfV3arsOnGiw7YsSiLba22i1Lk+m/lGQ0v/j2MLUt
	Mz3ymLxFe2WlVz7HfyORpt11n7tZ7TpkMkQbSmSSO2tlK5W4QKNalUHqClT/AbYxAr1uAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0hTcRjG+5/z3zlzNTssq5MV1UKimyVovFRE9aVDFymEigh05aEtb7WV
	aRB4G1mWzcG0uaylNMVZzltkMhlaVproUrturYVp5swuLjG1tRl9efm9z/Pw8nx4haTkviBU
	qEg+wyuTZYlSSoRF0Vuy1wdHvpdvvOZdCi8zbRi8Y7kYblRXUZBbqxdA9z0zApc3F8H4pIEE
	daMPw7S2jYaxiXc0+KxtCArtWhKq6jMJ+Gn5Q8Fw6w8EOnc/BUVDmRhGTVcQFA8YaBh6vAtG
	XE0C8DkHCXj1y4PA1P+HgH7bRQTThQlwq7SOgsnOLhKKdN0IbrudJHy2+M36tvcIrBVZFHzS
	NJDQ0x8Mvd5RCp7p8igYsd8g4KuFAmOWVQAlBi2C7LJqCgpLajE0fnhIg314igBHoZYAc+0+
	cJkGMHRoSgl/P3+qZiEYirIJ//hMgO5uEwETpkoanpc5MJgywsDQ2SOAjxXFNEy5I8BnTIE2
	8yANzms6DPdGugTbdYgbV+djrrLuPsGpX0xTXNXNKsRN/tYibuxONsmpNf611TNKcjl157g7
	HR6K++3tozjrLyPm2ktZrqBzPddY7KS5nOa39P7NR0Rb4/lERSqv3LAtTiR/NJKBT+UHpemf
	PKQy0FX6MgoSskwka/vgmmGKWcW+fj1BBjiEWc7WXR0QBJhkOpawL+3rAjyPOche1NQTAcZM
	GNvXbZjJi5lN7Bv7JfTv5jLWbLHN6EF+vcfdgQMsYaJY9WgOoUEiI5pViUIUyalJMkViVLgq
	QZ6erEgLP56SVIv832S6MFXwAI317GpBjBBJ54jtYU65RCBLVaUntSBWSEpDxHEVDrlEHC9L
	P88rU2KVZxN5VQtaLMTSheLdh/g4CXNCdoZP4PlTvPK/SwiDQjNQ0gPl6bXOdscS3jO5vCB2
	ZaqxOeaLNXZBxM89ZbZbBu/eho95MXnu/MiJGv3dceabqzxm6+ya+nKfdVtctLJvZ7AOO4rT
	Oo95jCuiQr9fXzb8RfE489Pg0/SS1fO9c4eI55fzsuZdMEZf793etNK+Rt910nLgQPvRvYcX
	DZj1O8qbpVgll0WsIZUq2V+wmf0QSQMAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: wq6w8xeic664cr5w8yoz7ex363c3rbuj
X-Rspam-User: 
X-Rspamd-Queue-Id: C1ACDA000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392819-811786
X-HE-Meta: U2FsdGVkX1/hC4UeMI0dli/K3kjoFkLg7ycred+Hyf/GtvNLvCKoYn6BlDyGU13OwzBA0fUuTLbEly7dAzpuajCQPeNh0SL4r2bPuLcjnmKbOL4ZnxFBDFNzPd4ix8thnqh+56YB5wB71Gi0JIhvpQvZu9sE6+XpM5RDBwL6elyK4msnYj3TG13rCMx4oPNmvVec5HInPLEHTvKHPfzL5qpH/PDs6CwATvlIdgiVDQaFzUX8y1K/6EX6wD72bd0aUcFsf00H9HMSjVMCPcJgc2lkjiT/73SoWkNb4xi0YhDe4ME2f18SF0zVMOKzUM3uI5NcN2wa577TJPnVKuhskxNEWqsBLhuVx8qfyvMP8jRdvsYYZ4KIp/9TmswgEnm+9TRvADUrln99oMRQyt8ATVzv6SXx+cokX7roDmelz2+TERUDRNSBaqRQ9Zrwe8z/VW/seh2fCmGyp+YHf72vOvLYnL+vDhYBhsDVO518tYVdXQqB74n9vhFqmcxXPvc24QFFIuoQAjkLsM6Yo1khsz6CR9UpCZJcfWiHF0SIsiTA9aCzKx3alAWy9JxWBJJRO3JTg+WwPaIw/nHCseaUhDx23j0IX3zJhafU/HZ42+FEHEfWbzkqZrBX/y3gHWoZaVmmCkHLDAWvkZhu6YFYtowWruNVgTtILFAyAyZjlHDvW0oImsT8tlEbk9bxmEgdq1enZUEnAIYGhzYAkwUPlDkOzhtVIrDbdZ6bt8lN5cpEjeJRuEUd253SMkQPb5RyZszzaeanch9flKNEAlB8Wrm+dQ6KL5pLN0m91KbreVUnNKEFeGmybo243Rjn0KfwZpWzoWJ+UUjXi4L2Jj/9C+qIhCn6iRi+X+Bkj0yp8YQVDWgq3CadH8IJsDPt22zvsE4FgOJbrU2i0QaL+LILw8JoRwNQFSfAzJ1wE+DesY5RVOYyrhGPZgA7lcLhwVzuGN+ISkvPv+RUGUXMtSM
 +tQSGr0z
 f7q5gAc5RbnF8O/yjTwcs8yOJUpz9t6FGGGz7A8AH6Pi3pig60YlZPR8wQ5hdHuDEHX4TAcvd+6qp7jOQUdM/gOQbzkwBstc266ecySzq0NKEw/4q4u9T78k/se1FCJH9ZQQnGmEXgkj36Tr6lf4P+XpQupzmT83QH7JQDbGKJdYAk8k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make dept able to track dependencies by waitqueue waits.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/wait.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 09855d819418..65dd50f25e54 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -7,6 +7,7 @@
 #include <linux/list.h>
 #include <linux/stddef.h>
 #include <linux/spinlock.h>
+#include <linux/dept_sdt.h>
 
 #include <asm/current.h>
 
@@ -305,6 +306,7 @@ extern void init_wait_entry(struct wait_queue_entry *wq_entry, int flags);
 	struct wait_queue_entry __wq_entry;					\
 	long __ret = ret;	/* explicit shadow */				\
 										\
+	sdt_might_sleep_start(NULL);						\
 	init_wait_entry(&__wq_entry, exclusive ? WQ_FLAG_EXCLUSIVE : 0);	\
 	for (;;) {								\
 		long __int = prepare_to_wait_event(&wq_head, &__wq_entry, state);\
@@ -323,6 +325,7 @@ extern void init_wait_entry(struct wait_queue_entry *wq_entry, int flags);
 			break;							\
 	}									\
 	finish_wait(&wq_head, &__wq_entry);					\
+	sdt_might_sleep_end();							\
 __out:	__ret;									\
 })
 
-- 
2.17.1


