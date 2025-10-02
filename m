Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DD75CCA472
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF5008E0012; Thu,  2 Oct 2025 04:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2DE28E0008; Thu,  2 Oct 2025 04:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884FD8E0012; Thu,  2 Oct 2025 04:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0D88E0008
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:13:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17A98160366
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:21 +0000 (UTC)
X-FDA: 83952459402.19.5A06544
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2D71DA0008
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=H0OM+mqe2IZ6rIbRfth+Iqbg6ezAmt3ugzSCHQKthUs=;
	b=1JO8Sd3Q1xOBxE4rVP2UTTvj6Za/56bSBfOQujdM4GBKKYOfZv5h3PEhQBQvFIE9UI3fLR
	vf9sN1idDKQZK1gC4UC/Pxh+SEPVcMhCuUET3KKG8RVOePSMBmmxmZ6m+U9YCAmXKHMvVh
	p8EUCSCDNP5Fr0JzYo3PKS+JA0uICc8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392799; a=rsa-sha256;
	cv=none;
	b=DZpiH/N5AH8iWaFJEQ+p6bS9Zn7Mhva5pa5KdLDEp4FedC6c8BhaVaBIU/wi4mVf7fBUS4
	21VFsoG2/u8fFJ5LTsnv9L88roV9dxh16zI3T88s4ocMO1jTCA68HuyE3OAzposfDWMnlE
	PH6ITEKttHHI6JE7ipb2tgbmmF2dE10=
X-AuditID: a67dfc5b-c2dff70000001609-d9-68de340c9c0c
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
Subject: [PATCH v17 06/47] dept: add proc knobs to show stats and dependency graph
Date: Thu,  2 Oct 2025 17:12:06 +0900
Message-Id: <20251002081247.51255-7-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSX0xTdxQHcH/3/n63paPJXXXjjpnNVIn/mbi6nIfN7GGZ1weXRXxxPswG
	bmwVWtcqyDKTOltkA2PtbJ1UXAuTFamCrSiFgoiw2SChiGI1baFmwgiQJoRi+GdXML59Ts73
	nPNyxLQsRDLFas0xQadRFsgZCZZMpju3piuiqm1z1mwYPNWBITFdhuFyg5uB4I16BEOJMgSv
	5u00mHxJDIuWv0Vg67fQMH5/CkHliF0EY927YHKolUAyMkrB05kJBP92nEGwaDsCf1R7GXDG
	IjS8NDfR8DgRZyBgLWfA8XMbgSq7BcHpmgYGbFUeDL7hFhH0jy9QELZZKKj37IEeczUFtpsZ
	YL/4HwXW660UzNZeE8HDmjCGWkMWvHBVimAhlgNJhxYi56wYbkz2EQhEBwmMj1gYGPqnlMAd
	w7AIPM+6EUw/jlHgrhihoawlgaHt+WZwlv6J4dKVMAP+tgCGgZbLDFQ0NhGIupMEDPZXBIId
	PQQe1QcxNIyGKAhU1mHoa7lOIDYcIl/m86ZHiwzvvuJG/PycBfHTV0/TvMmcKu9PxGne6C3m
	5xJPGL5txoH5871beV9lRMQ7PMd5Y9ck4b2uTXyNf4zinVMJ8u2W7ySf5wsF6iJB98nOgxLV
	XWsjPhr94sTFO7sNyJvzK0oTc6yCu1Tnpd66y++jl8yw67lQaHbZq9g1nPfsCFkyzfas5gb7
	tyx5JbuX8zc/wEvGbBb3+6hx2VJ2Bzc/Z6bf7PyYq2/sWHYa+xk3EOtZzshSGVPcmLorSWX+
	SuOqXM3ozcAH3D1XCJuR1IFWXEMytaaoUKkuUGSrSjTqE9l52kIPSv1b7cmFA81oKpjbiVgx
	kqdLg1kRlYwoi/QlhZ2IE9PyVdKDrrBKJs1Xlvwo6LTf644XCPpO9KEYyzOk22eK82XsIeUx
	4YggHBV0b7uUOC3TgPZ2FY0mt9ddLfl6V3OOsTU+nlu6Y/9Au/VM73N/U3Xe2Qed8T3d+4fd
	Q69NO53lzlO7M9/PuJD5y0ZD6PCKwY/Os7dr9RryTm/FBUXeRMNa9w+2sfccvtcGeeG7a9vF
	8cDDDbfks1/99NuEtqYvl/vmU9u+6IEXrdryNYoutji8rn1BjvUqZc4mWqdX/g/Ingh0awMA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSfUwTdxgH8P3urndHQ8mlI/GULSPdCIYNlAX1iTpjZhZuSyCLi5LolnGZ
	l7VCi7aIoCED2gLRvdRmbRnVWUEqQgeF4pApk4BrVCBQiy9RClaRQgCbbLyE8lILi/88+Tx5
	vnny/PHQuLRNtIlWqPIFtYrPlZFiQpy5S5scnTYi3zq0GR6WdhEwN1tJwPlmBwmVrb+JYLCp
	EcHoXCWChSUrDvqOMAErRjcFs4tPKQh3uhGYPUYcHG2lGPznXCVhqudfBCb/GAmWyVICgvYf
	EVSPWymY/CcdZkZviCDsC2DwaH4agX1sFYOxrgoEK+YcuFjjImGpfwAHi2kQwSW/D4cJZ2TY
	5h5B0FlfRsJLwzUcvGMxMDQXJOGu6SwJM57zGLxykmAr6xTBBasRgba2mQTzhVYCOp79RYFn
	ahmDYbMRg8bWDBi1jxPQa6jBIvdFUi0bwGrRYpEygYHpjxsYLNobKOirHSbAXpIA1n6vCJ7X
	V1Ow7E+FsC0P3I0BCny/mAhomhkQ7TUhbkH/M8E1uP7EOP39FZJz/O5A3FLIiLjZOi3O6Q2R
	tmc6iHM610murnea5EJzD0iuc95GcPdqWO5cfzLXUe2jON3fT6gvdx4S7z4i5CoKBPWWPdli
	+S2Tkzg28kmhpf3zEuRKPYOiaJZJY2/f7MDXTDKJ7OPHi+uOZeJZ10/jojXjTO877EPPR2t+
	m9nP3rx+h1gzwSSwVQHduiXMNnYpZMD/3/ke2+jsWncUs531+nvXM9JIRh/UYQYktqG3GlCs
	QlWg5BW521I0OfIilaIw5bs8ZSuK/JK9ePncdTTrTe9GDI1k0RJPgk8uFfEFmiJlN2JpXBYr
	ya4flkslR/iiU4I671v1iVxB043iaEK2QfJFlpAtZb7n84UcQTgmqN9MMTpqUwnKfBmWnm3P
	igv10AfbvwoWf21Pv2sJqPZRyvkPyv2fue9Iho5/2nJgwHnl+Wn6/VO/fvNhuzYmi3o3I8a7
	g/phhF+8+vFk4pYAlqLmM452W0LXNh7ucyVVONyFtuSLl3V5ZlO+s68WKEVZMPlSfu298vgW
	/f1dVcUvEpVxDWpyv4zQyPnUJFyt4V8DzIimIUcDAAA=
X-CFilter-Loop: Reflected
X-Stat-Signature: 4fept4qr4uz4drqyk35d3fp4hcirjco8
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D71DA0008
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392798-468215
X-HE-Meta: U2FsdGVkX1+LSM0DB3MdEdSLDuLWrd+yJdv50AEoG2zVQ4meY6FsQ21fX+eB5iO76Kk3d99gI/Doj8P4LBY0E3jClB7O68JY073EJe712dnNjtna/8IM+6i0WxkTyXHWnWmby/BeaD6ZJkSN1rBJg9CqR50UAIsfA7QCO1MlCcifVJOUWbpFEAdx+UrnJspa1bU67J8v/MGrfDwcQBtpRhlJ0/E98PW6r/EdTq1tialgccihdiJn9krX2yAlXRL6HKdxLFDPVQ9BIYsdz+wii80nxmUy6tND0x5DBBPJnrUPlc0Vs8lp1WIwhFqNTISpKnaZ2wwXQpG8xUgK9CewCZQf6usvud0cU1+eBRSIBO9AQLfd+b2ecHl9nXhprMNdeWj32sNjPcDgLifquxXOzhIQva3xCzcPNjenBaM8zYfgosttxNUXcOk4DCIoV8vBsAsR0TdFg6VtMHwJ30qM7/M/YNjqEwLhL4qX4G3k8e2pMhdpJCKrTOhCiCYsjSaq0IrCSnOwC7dEC1lTl/3rH9fJUQhhwO5fiU3Rnt7Hgy8BQRz1myuFRhtzK/H7exsBrEcqVK6CbSNoOCE2m46L4X54hASLXJwaPSIc87FKz7t2TDLqZmjgdv+5c1Dh/5d8VWeJ386hYwYWxigdFqQdzDuHGExBEjnaj5EdI75JYJbtENnny/et4W+IY/7KuD3jG04OJw+s4ZIUfQPnt5urydnoC+bxLB7Xl9VwVNYANEp8l82xXo6D9pIdo4HdA3s94tKeCe1DgDll71pNkF82hmaYdDkhoiBfkaYVFPVlqF6a1CEqtCthhFK5Nuhyx/8TGUeOiA4jEOUiygtuSZBxK4win6UR3uR10nftgrOLtRlxiJSjWMmbmuELPcHwiTx8rI8JnlDKBJA4VaYOUSoNHNelMi7vKy0I0XP2FUpKdskn1DcQtHZsKt/gPmXRiCRWUImQjp0Yw+vPupfmkna
 I9VzhAg7
 qH7AROQ3gOeAZHmr+owjDjOaXTS1gzXFEQnfH4FzlnawKHmOLYLSSKKbnpl5djxdIX+airxh3RBAj9bGUufdN2wxKxDqnaJEoicuOyoBlw43hX6w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It'd be useful to show dept internal stats and dependency graph on
runtime via proc for better information.  Introduce the knobs.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 kernel/dependency/Makefile        |  1 +
 kernel/dependency/dept.c          | 50 +++-------------
 kernel/dependency/dept_internal.h | 54 +++++++++++++++++
 kernel/dependency/dept_proc.c     | 96 +++++++++++++++++++++++++++++++
 4 files changed, 160 insertions(+), 41 deletions(-)
 create mode 100644 kernel/dependency/dept_internal.h
 create mode 100644 kernel/dependency/dept_proc.c

diff --git a/kernel/dependency/Makefile b/kernel/dependency/Makefile
index b5cfb8a03c0c..92f165400187 100644
--- a/kernel/dependency/Makefile
+++ b/kernel/dependency/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_DEPT) += dept.o
+obj-$(CONFIG_DEPT) += dept_proc.o
diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
index cbb036e8cc1d..dfe9dfdb6991 100644
--- a/kernel/dependency/dept.c
+++ b/kernel/dependency/dept.c
@@ -75,6 +75,7 @@
 #include <linux/dept.h>
 #include <linux/utsname.h>
 #include <linux/kernel.h>
+#include "dept_internal.h"
 
 static int dept_stop;
 static int dept_per_cpu_ready;
@@ -265,46 +266,13 @@ static bool valid_key(struct dept_key *k)
  *       have been freed will be placed.
  */
 
-enum object_t {
-#define OBJECT(id, nr) OBJECT_##id,
-	#include "dept_object.h"
-#undef OBJECT
-	OBJECT_NR,
-};
-
 #define OBJECT(id, nr)							\
 static struct dept_##id spool_##id[nr];					\
 static DEFINE_PER_CPU(struct llist_head, lpool_##id);
 	#include "dept_object.h"
 #undef OBJECT
 
-struct dept_pool {
-	const char			*name;
-
-	/*
-	 * object size
-	 */
-	size_t				obj_sz;
-
-	/*
-	 * the number of the static array
-	 */
-	atomic_t			obj_nr;
-
-	/*
-	 * offset of ->pool_node
-	 */
-	size_t				node_off;
-
-	/*
-	 * pointer to the pool
-	 */
-	void				*spool;
-	struct llist_head		boot_pool;
-	struct llist_head __percpu	*lpool;
-};
-
-static struct dept_pool pool[OBJECT_NR] = {
+struct dept_pool dept_pool[OBJECT_NR] = {
 #define OBJECT(id, nr) {						\
 	.name = #id,							\
 	.obj_sz = sizeof(struct dept_##id),				\
@@ -334,7 +302,7 @@ static void *from_pool(enum object_t t)
 	if (DEPT_WARN_ON(!irqs_disabled()))
 		return NULL;
 
-	p = &pool[t];
+	p = &dept_pool[t];
 
 	/*
 	 * Try local pool first.
@@ -369,7 +337,7 @@ static void *from_pool(enum object_t t)
 
 static void to_pool(void *o, enum object_t t)
 {
-	struct dept_pool *p = &pool[t];
+	struct dept_pool *p = &dept_pool[t];
 	struct llist_head *h;
 
 	preempt_disable();
@@ -2108,7 +2076,7 @@ void dept_map_copy(struct dept_map *to, struct dept_map *from)
 	clean_classes_cache(&to->map_key);
 }
 
-static LIST_HEAD(classes);
+LIST_HEAD(dept_classes);
 
 static bool within(const void *addr, void *start, unsigned long size)
 {
@@ -2140,7 +2108,7 @@ void dept_free_range(void *start, unsigned int sz)
 	while (unlikely(!dept_lock()))
 		cpu_relax();
 
-	list_for_each_entry_safe(c, n, &classes, all_node) {
+	list_for_each_entry_safe(c, n, &dept_classes, all_node) {
 		if (!within((void *)c->key, start, sz) &&
 		    !within(c->name, start, sz))
 			continue;
@@ -2216,7 +2184,7 @@ static struct dept_class *check_new_class(struct dept_key *local,
 	c->sub_id = sub_id;
 	c->key = (unsigned long)(k->base + sub_id);
 	hash_add_class(c);
-	list_add(&c->all_node, &classes);
+	list_add(&c->all_node, &dept_classes);
 unlock:
 	dept_unlock();
 caching:
@@ -2951,8 +2919,8 @@ static void migrate_per_cpu_pool(void)
 		struct llist_head *from;
 		struct llist_head *to;
 
-		from = &pool[i].boot_pool;
-		to = per_cpu_ptr(pool[i].lpool, boot_cpu);
+		from = &dept_pool[i].boot_pool;
+		to = per_cpu_ptr(dept_pool[i].lpool, boot_cpu);
 		move_llist(to, from);
 	}
 }
diff --git a/kernel/dependency/dept_internal.h b/kernel/dependency/dept_internal.h
new file mode 100644
index 000000000000..6b39e5a2a830
--- /dev/null
+++ b/kernel/dependency/dept_internal.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Dept(DEPendency Tracker) - runtime dependency tracker internal header
+ *
+ * Started by Byungchul Park <max.byungchul.park@gmail.com>:
+ *
+ *  Copyright (c) 2020 LG Electronics, Inc., Byungchul Park
+ *  Copyright (c) 2024 SK hynix, Inc., Byungchul Park
+ */
+
+#ifndef __DEPT_INTERNAL_H
+#define __DEPT_INTERNAL_H
+
+#ifdef CONFIG_DEPT
+#include <linux/percpu.h>
+
+struct dept_pool {
+	const char			*name;
+
+	/*
+	 * object size
+	 */
+	size_t				obj_sz;
+
+	/*
+	 * the number of the static array
+	 */
+	atomic_t			obj_nr;
+
+	/*
+	 * offset of ->pool_node
+	 */
+	size_t				node_off;
+
+	/*
+	 * pointer to the pool
+	 */
+	void				*spool;
+	struct llist_head		boot_pool;
+	struct llist_head __percpu	*lpool;
+};
+
+enum object_t {
+#define OBJECT(id, nr) OBJECT_##id,
+	#include "dept_object.h"
+#undef OBJECT
+	OBJECT_NR,
+};
+
+extern struct list_head dept_classes;
+extern struct dept_pool dept_pool[];
+
+#endif
+#endif /* __DEPT_INTERNAL_H */
diff --git a/kernel/dependency/dept_proc.c b/kernel/dependency/dept_proc.c
new file mode 100644
index 000000000000..97beaf397715
--- /dev/null
+++ b/kernel/dependency/dept_proc.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Procfs knobs for Dept(DEPendency Tracker)
+ *
+ * Started by Byungchul Park <max.byungchul.park@gmail.com>:
+ *
+ *  Copyright (C) 2021 LG Electronics, Inc. , Byungchul Park
+ *  Copyright (C) 2024 SK hynix, Inc. , Byungchul Park
+ */
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/dept.h>
+#include "dept_internal.h"
+
+static void *l_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	/*
+	 * XXX: Serialize list traversal if needed. The following might
+	 * give a wrong information on contention.
+	 */
+	return seq_list_next(v, &dept_classes, pos);
+}
+
+static void *l_start(struct seq_file *m, loff_t *pos)
+{
+	/*
+	 * XXX: Serialize list traversal if needed. The following might
+	 * give a wrong information on contention.
+	 */
+	return seq_list_start_head(&dept_classes, *pos);
+}
+
+static void l_stop(struct seq_file *m, void *v)
+{
+}
+
+static int l_show(struct seq_file *m, void *v)
+{
+	struct dept_class *fc = list_entry(v, struct dept_class, all_node);
+	struct dept_dep *d;
+	const char *prefix;
+
+	if (v == &dept_classes) {
+		seq_puts(m, "All classes:\n\n");
+		return 0;
+	}
+
+	prefix = fc->sched_map ? "<sched> " : "";
+	seq_printf(m, "[%p] %s%s\n", (void *)fc->key, prefix, fc->name);
+
+	/*
+	 * XXX: Serialize list traversal if needed. The following might
+	 * give a wrong information on contention.
+	 */
+	list_for_each_entry(d, &fc->dep_head, dep_node) {
+		struct dept_class *tc = d->wait->class;
+
+		prefix = tc->sched_map ? "<sched> " : "";
+		seq_printf(m, " -> [%p] %s%s\n", (void *)tc->key, prefix, tc->name);
+	}
+	seq_puts(m, "\n");
+
+	return 0;
+}
+
+static const struct seq_operations dept_deps_ops = {
+	.start	= l_start,
+	.next	= l_next,
+	.stop	= l_stop,
+	.show	= l_show,
+};
+
+static int dept_stats_show(struct seq_file *m, void *v)
+{
+	int r;
+
+	seq_puts(m, "Availability in the static pools:\n\n");
+#define OBJECT(id, nr)							\
+	r = atomic_read(&dept_pool[OBJECT_##id].obj_nr);		\
+	if (r < 0)							\
+		r = 0;							\
+	seq_printf(m, "%s\t%d/%d(%d%%)\n", #id, r, nr, (r * 100) / (nr));
+	#include "dept_object.h"
+#undef  OBJECT
+
+	return 0;
+}
+
+static int __init dept_proc_init(void)
+{
+	proc_create_seq("dept_deps", S_IRUSR, NULL, &dept_deps_ops);
+	proc_create_single("dept_stats", S_IRUSR, NULL, dept_stats_show);
+	return 0;
+}
+
+__initcall(dept_proc_init);
-- 
2.17.1


