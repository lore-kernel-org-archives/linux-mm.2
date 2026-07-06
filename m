Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A7AAC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E7446B00AB; Mon,  6 Jul 2026 02:20:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BEDD6B00AC; Mon,  6 Jul 2026 02:20:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386E36B00AD; Mon,  6 Jul 2026 02:20:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 031116B00AB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:20:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A24F402C3
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:05 +0000 (UTC)
X-FDA: 84957351570.28.E6ABAFD
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6055D20002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=dTPCdcFNanAHxo4EUdMVq8XwkE0ZSTcT7U8lT/nJbi4=;
	b=ZqZaxVy1TuPBX1t7nHBM4PiRwcBC10vV3OVoToJNinL+D5Ibkyi49ejiKI9nAOF/5QxdD7
	HuNYy0QYPtlnBtxndVthnlXklMgk4QjUeLmr1n7U5hHPe9x52GWsvSoaZyyBc20CGs147c
	A/6vZWsK0ObM5K2u3pXy/RstJ75Argw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318803;
	b=itjVI0cwAr0+COCH7Prf5WOfUOC/ws2mueYnEVqAiEunCqn0KdPhdQQ4pM+nFDmqhUhrbh
	Ld5AxIiYb59pxKDsW9iVd60tq7HCktKNVIA+h8wNhqkEqJjWn/q8mtvk4lkY6I20oR5sLO
	SVgEPT5UVf119HUYlSRcsUeW8QwPTTU=
X-AuditID: a67dfc5b-c2dff70000001609-31-6a4b48fd08e4
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
Subject: [PATCH v19 08/40] dept: add a mechanism to refill the internal memory pools on running out
Date: Mon,  6 Jul 2026 15:18:56 +0900
Message-Id: <20260706061928.66713-9-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0yTdxTG/b/3NtS8KUZf0YWliTcS3TpRz4dpui/LP3OJZvuyoFGrfR3l
	phZB0BhBRBFEkVlYqDUgF5Fys9VRhE1olDJBUoWUEqlcBMqEwugKKoKu1fjtl/M85znPh8OR
	cjcdxmkTjou6BHWcgpFSUm9Iycb3eGfM150jCugfGKHBmd5Cwaw/iwJHrQnB63cGElyOByTo
	h0YYmK64hMA70ETDB7eHgN65SQSLBbEwUfAvA39WnmWgZ3aagb/1OQwUGM0UNA7eZ6Ej7yYB
	hsJxAvQ1TQS8rahiYbiyiIWFISW0mTwsuK/oKZgYy2egIW2QBfNLJw1t1mECuu9fZ+BF9Qca
	6jwuAp4/ucJCee9TAoYGXTQ4rubS4MobRVAzdZOBvsJJFp61FBOQ3lpKQVvxcqg/FziTP+Zj
	4d6DTAS+sjkKzv/3ngZ7bgsB58vuENDT14TAU2QkYN5tpWH+1iMET/54HKh42cuCzxgw6xey
	GMjJLKCgfuYWA2/qX9Jg9CthKs9Pg+HRC1alwpnPFhlcfaMaYX95BonPWU7gxiI3i4vNSdhS
	GYFLm/8hsLnqIoPNvnwWT3V1sbj993cUHukpJHBJmp7EAzl2AlvKzuwOi5J+qxHjtMmi7qsd
	B6TRXZlz9NF+Vcrg+AWUhpo3ZyMJJ/CRQo3fyX7msw3dH5nh1wku11syyMv4LwVL7hidjaQc
	yXeHC5cqcqmgEMofEqxlb1A24jiKXyNkG6TBsYzfIjjnF8lPmeGCqb7lI0v4rULtgpEIsjzg
	eT5tp4KZAm+SCBcmR5lPCyuF1koXlYdkxWhJFZJrE5Lj1dq4yE3RqQnalE2HjsSbUeDpKk4v
	7LEin+NnG+I5pAiRgeqHGDmtTk5MjbchgSMVy2Rr1++Mkcs06tSTou7Ifl1SnJhoQ6s4SrFC
	9s3cCY2c/1V9XIwVxaOi7rNKcJKwNCT1rl3dt3eDSZUV+oV95dWfyovqDpYeK3ceawzd/uMS
	/y/XZ4ylG83KO43224bDM5e9U0stVbs5W3tM+Bprj9WvnL94z3Gqle+w9kVmfCceWIG1N/5q
	b/Z0/kZtG21Ij2rddVc2fG2fMWQmIlTfNiCJVryKKsmwHYx9+P1SrSZMM6ugEqPVyghSl6j+
	H1D2IdVwAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTdxTGPffe3nu5s3rt6rxhMWqTOWKC0zj1JCMbfpl/FZ3Zh2mMyWz0
	SsubptUqyxal2IEoWqttoxVlTKqhiAgqIDYyzPDdgWyAyqvpOhkoCwOU0mttNX45+Z3zPOfJ
	+XB4WlOjiueNWTtkU5Y+Q8cKjLDmi9xEhaxKW3C0gsF82x7s7AmosC2ngcHRkXwGT14oZ1Hx
	1HCYX3VchbfarQw2V/gAe0bzAV9OeGi01UUYVBxNHI6MP+HQmQMY8TcBulocNHY0X6ex/FIO
	hf9XvmZx4MYwoLMvwKK7P4fBIe9BwBNBD4f9vy/H5z31Kox0/UNh+9ggoDfwmsJAQx6g4krH
	0yXV0XXXfyxO3P+DRrezGfCXvi4ah/t7AS81dQP6z1lZ/Nt+mcbWwBT8c3SIxdvOAyw+bzlJ
	4YtKFoutfhW23BsALPI4AIOP/RTm/nqBRVdRFYN1vVc5bBkIU9jpclDoq1qNPd4gg3ftJVT0
	3Kjr4gz0uHOpaHlGofN8PYXj3jIuuRTIS9shhpRVX6GI7aHCkvJT5UAmQg4gI6W5NLHZo+2N
	wSGa7KveRUrvDrIkNPoXS/xjxQy5UyKRM/tDFDlyP5HUneji1i7bICRtkTOMFtn02ZebBMMD
	25hqe2fy7t5nebAXri0qgDheEj+XrDWtXIxZ8VOpo2OcjrFWnC1VFwZVBSDwtNg6SzroLWRi
	wofiZqn2zCsoAJ5nxE+kAo8QG6vFxVJbSKHfZc6SfJUNbzlOXCJVhIuoGGuinidDNxk7CMUw
	qQy0xixLpt6YsXi+Od2QnWXcPX/ztswqiL6T96fwkVoYaV3eCCIPuslqTF6ZplHpLebszEaQ
	eFqnVc9NWJWmUW/RZ/8gm7Z9b9qZIZsb4WOe0c1Qr1wnb9KIqfodcrosb5dN71WKj4vfC1uF
	V+t99ZxS8sG6aSFryqnutR/Fb/xKm5QXf/Fbi+H6sjsJaJjk5qdO1/7LKwkLE3XhJXtSZ1/x
	9dce/vE3GzEOLzgtGVa4go+SOgSLHUr7vnNHeuc8rFsj+SwzU857n8b9vGIpsUsR5Vh7c/HX
	L7qtbVNT9n0TPhtIfVoo1As6xmzQL5xHm8z6NyRj8I5KAwAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6055D20002
X-Stat-Signature: 3ocdbhtkdgg5uod6e8sny3riqso6w4yt
X-HE-Tag: 1783318803-276693
X-HE-Meta: U2FsdGVkX19xJeF68GYe7DhUBplSsUbFK8x+b6xgZTfDnjxUML5h6Kghot/dshHDCBdr99J2psDLjIZmC5gQCiMo1OuHhUaxsfFZ4bGmKCRzwZF6i/ob1vPDl798q7zML7nrgdQaPoSmXD0ZysroixoHS/0VAF5DXUQF9LB7gVYoQK7Is0DLAecqo6Etr1XkMDRaTmeMKEFBi2neL5UusDnOq/p6QQnzp3qG1eGaSql2HbvG2qeDk40fIhBwHN1LDEP4f6em6hYj5/PPLBzj9miU9c3LYyu+XR7U8YNNcT9e2L2cxB0Kewa68eRSY+k301Ogn1di1bNEaXlhPac3lQXjdBPWs8t8WcwVkop2ZJW5hF7JtEX+06dBaumtEq4GLJVjcaI9GRUA7Ewc1Z0KWOB4yc5uZ+paySet8IqmJqHqja/DYOzJ6R9GuLugXuKGquYTdIumUdxcMZtg6/dqOPvCQeAoUBhMG3H678I86EvdzoRAgvF0JymBCUXZLFpprnqC5eEIO0CYtXmd+DuvJpObQGQGlQLyYxT6ycoC1YnMyf8WmHRdd9AUfmYVU3KRUA8q4OjKlOkyjEdnm/dF1bIFY06+p0lMOL6UJE9u6YMdS7HNMNdeo3yrmoro+oRxwftXNq1yd7BZmtszo6OrcClFpCFqkhaY8WdfMqvxMkEDDPEzsu3b58Fntv2MXmWhw7zyRrDIjQ8xj3XbfRCoGv1cnFa/3nTxs8G0IL8kE8VaAoSJgDiV02nmzSjRtsD2zHRpg7Pl7zqRfGcmqfL8oEN44Kl53SNaEytRh6BY+b0Efau/roH7KpBJ7BbURCnwLi1w/lschNhcEdYYQvzgq235so22l93Epp2+wRCRxfQ2jL6Mc+M3ZHD3l75MDlVEFUVr9gfY7c7WMWPC/foS+dCFrj7yxyaydNUB5zNp0xgTaFzAnPCY9I00E5kn3MsaQ0hMEEb5MKzltsk++DM
 1OVoF+mr
 JOIKcPMIl5V0JfplcprVlGDitRf1dVoXIuPX3gzWlKYrm5qdZ0JRbDu7HBQSdrWE4kVae3g1qNh2egObiD7Njjkt4gGb9P8YkYdl2hjBzSW409H5nyVW8YxK8n97zw3UZdmfgAeER9r3b6444h7aCryFQ6sUFftjBM+SpHlgZFbxyh1rYT389a+j7LEAZb6ra+yoi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dept engine works in a constrained environment.  For example, dept
cannot make use of dynamic allocation e.g. kmalloc().  So dept has been
using static pools to keep memory chunks dept uses.

However, dept would barely work once any of the pools gets run out.  So
implemented a mechanism for the refill on the lack, using irq work and
workqueue that fits on the contrained environment.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 kernel/dependency/dept.c          | 108 +++++++++++++++++++++++++-----
 kernel/dependency/dept_internal.h |  19 ++++--
 kernel/dependency/dept_object.h   |  10 +--
 kernel/dependency/dept_proc.c     |   8 +--
 4 files changed, 116 insertions(+), 29 deletions(-)

diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
index 1c4de1b55730..4b4b28ddc819 100644
--- a/kernel/dependency/dept.c
+++ b/kernel/dependency/dept.c
@@ -75,6 +75,9 @@
 #include <linux/dept.h>
 #include <linux/utsname.h>
 #include <linux/kernel.h>
+#include <linux/workqueue.h>
+#include <linux/irq_work.h>
+#include <linux/vmalloc.h>
 #include "dept_internal.h"
 
 static int dept_stop;
@@ -143,9 +146,11 @@ static inline struct dept_task *dept_task(void)
 		}							\
 	})
 
-#define DEPT_INFO_ONCE(s...) pr_warn_once("DEPT_INFO_ONCE: " s)
+#define DEPT_INFO_ONCE(s...)	pr_warn_once("DEPT_INFO_ONCE: " s)
+#define DEPT_INFO(s...)		pr_warn("DEPT_INFO: " s)
 
 static arch_spinlock_t dept_spin = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+static arch_spinlock_t dept_pool_spin = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
 /*
  * The DEPT internal engine should be cautious when using external functions
@@ -268,6 +273,7 @@ static bool valid_key(struct dept_key *k)
 
 #define OBJECT(id, nr)							\
 static struct dept_##id spool_##id[nr];					\
+static struct dept_##id rpool_##id[nr];					\
 static DEFINE_PER_CPU(struct llist_head, lpool_##id);
 	#include "dept_object.h"
 #undef OBJECT
@@ -276,14 +282,74 @@ struct dept_pool dept_pool[OBJECT_NR] = {
 #define OBJECT(id, nr) {						\
 	.name = #id,							\
 	.obj_sz = sizeof(struct dept_##id),				\
-	.obj_nr = ATOMIC_INIT(nr),					\
+	.obj_nr = nr,							\
+	.tot_nr = nr,							\
+	.acc_sz = ATOMIC_INIT(sizeof(spool_##id) + sizeof(rpool_##id)), \
 	.node_off = offsetof(struct dept_##id, pool_node),		\
 	.spool = spool_##id,						\
+	.rpool = rpool_##id,						\
 	.lpool = &lpool_##id, },
 	#include "dept_object.h"
 #undef OBJECT
 };
 
+static void dept_wq_work_fn(struct work_struct *work)
+{
+	int i;
+
+	for (i = 0; i < OBJECT_NR; i++) {
+		struct dept_pool *p = dept_pool + i;
+		int sz = p->tot_nr * p->obj_sz;
+		void *rpool;
+		bool need;
+
+		local_irq_disable();
+		arch_spin_lock(&dept_pool_spin);
+		need = !p->rpool;
+		arch_spin_unlock(&dept_pool_spin);
+		local_irq_enable();
+
+		if (!need)
+			continue;
+
+		rpool = vmalloc(sz);
+
+		if (!rpool) {
+			DEPT_STOP("Failed to extend internal resources.\n");
+			break;
+		}
+
+		local_irq_disable();
+		arch_spin_lock(&dept_pool_spin);
+		if (!p->rpool) {
+			p->rpool = rpool;
+			rpool = NULL;
+			atomic_add(sz, &p->acc_sz);
+		}
+		arch_spin_unlock(&dept_pool_spin);
+		local_irq_enable();
+
+		if (rpool)
+			vfree(rpool);
+		else
+			DEPT_INFO("Dept object(%s) just got refilled successfully.\n", p->name);
+	}
+}
+
+static DECLARE_WORK(dept_wq_work, dept_wq_work_fn);
+
+static void dept_irq_work_fn(struct irq_work *w)
+{
+	schedule_work(&dept_wq_work);
+}
+
+static DEFINE_IRQ_WORK(dept_irq_work, dept_irq_work_fn);
+
+static void request_rpool_refill(void)
+{
+	irq_work_queue(&dept_irq_work);
+}
+
 /*
  * We can use llist regardless of whether CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
  * is enabled, because NMI and other contexts on the same CPU never run
@@ -319,19 +385,31 @@ static void *from_pool(enum object_t t)
 	/*
 	 * Try static pool.
 	 */
-	if (atomic_read(&p->obj_nr) > 0) {
-		int idx = atomic_dec_return(&p->obj_nr);
+	arch_spin_lock(&dept_pool_spin);
+
+	if (!p->obj_nr) {
+		p->spool = p->rpool;
+		p->obj_nr = p->rpool ? p->tot_nr : 0;
+		p->rpool = NULL;
+		request_rpool_refill();
+	}
+
+	if (p->obj_nr) {
+		void *ret;
+
+		p->obj_nr--;
+		ret = p->spool + (p->obj_nr * p->obj_sz);
+		arch_spin_unlock(&dept_pool_spin);
 
-		if (idx >= 0)
-			return p->spool + (idx * p->obj_sz);
+		return ret;
 	}
+	arch_spin_unlock(&dept_pool_spin);
 
-	DEPT_INFO_ONCE("---------------------------------------------\n"
-		"  Some of Dept internal resources are run out.\n"
-		"  Dept might still work if the resources get freed.\n"
-		"  However, the chances are Dept will suffer from\n"
-		"  the lack from now. Needs to extend the internal\n"
-		"  resource pools. Ask max.byungchul.park@gmail.com\n");
+	DEPT_INFO("------------------------------------------\n"
+		"  Dept object(%s) is run out.\n"
+		"  Dept is trying to refill the object.\n"
+		"  Nevertheless, if it fails, Dept will stop.\n",
+		p->name);
 	return NULL;
 }
 
@@ -2957,8 +3035,8 @@ void __init dept_init(void)
 	pr_info("... DEPT_MAX_ECXT_HELD  : %d\n", DEPT_MAX_ECXT_HELD);
 	pr_info("... DEPT_MAX_SUBCLASSES : %d\n", DEPT_MAX_SUBCLASSES);
 #define OBJECT(id, nr)							\
-	pr_info("... memory used by %s: %zu KB\n",			\
-	       #id, B2KB(sizeof(struct dept_##id) * nr));
+	pr_info("... memory initially used by %s: %zu KB\n",		\
+	       #id, B2KB(sizeof(spool_##id) + sizeof(rpool_##id)));
 	#include "dept_object.h"
 #undef OBJECT
 #define HASH(id, bits)							\
@@ -2966,6 +3044,6 @@ void __init dept_init(void)
 	       #id, B2KB(sizeof(struct hlist_head) * (1 << (bits))));
 	#include "dept_hash.h"
 #undef HASH
-	pr_info("... total memory used by objects and hashs: %zu KB\n", B2KB(mem_total));
+	pr_info("... total memory initially used by objects and hashs: %zu KB\n", B2KB(mem_total));
 	pr_info("... per task memory footprint: %zu bytes\n", sizeof(struct dept_task));
 }
diff --git a/kernel/dependency/dept_internal.h b/kernel/dependency/dept_internal.h
index f5023365b3fd..051d4ee4e6e1 100644
--- a/kernel/dependency/dept_internal.h
+++ b/kernel/dependency/dept_internal.h
@@ -26,9 +26,19 @@ struct dept_pool {
 	size_t				obj_sz;
 
 	/*
-	 * the number of the static array
+	 * the remaining number of the object in spool
 	 */
-	atomic_t			obj_nr;
+	int				obj_nr;
+
+	/*
+	 * the number of the object in spool
+	 */
+	int				tot_nr;
+
+	/*
+	 * accumulated amount of memory used by the object in byte
+	 */
+	atomic_t			acc_sz;
 
 	/*
 	 * offset of ->pool_node
@@ -38,9 +48,10 @@ struct dept_pool {
 	/*
 	 * pointer to the pool
 	 */
-	void				*spool;
+	void				*spool; /* static pool */
+	void				*rpool; /* reserved pool */
 	struct llist_head		boot_pool;
-	struct llist_head __percpu	*lpool;
+	struct llist_head __percpu	*lpool; /* local pool */
 };
 
 struct dept_ecxt;
diff --git a/kernel/dependency/dept_object.h b/kernel/dependency/dept_object.h
index 0b7eb16fe9fb..4f936adfa8ee 100644
--- a/kernel/dependency/dept_object.h
+++ b/kernel/dependency/dept_object.h
@@ -6,8 +6,8 @@
  * nr: # of the object that should be kept in the pool.
  */
 
-OBJECT(dep, 1024 * 8)
-OBJECT(class, 1024 * 8)
-OBJECT(stack, 1024 * 32)
-OBJECT(ecxt, 1024 * 16)
-OBJECT(wait, 1024 * 32)
+OBJECT(dep, 1024 * 4 * 2)
+OBJECT(class, 1024 * 4)
+OBJECT(stack, 1024 * 4 * 8)
+OBJECT(ecxt, 1024 * 4 * 2)
+OBJECT(wait, 1024 * 4 * 4)
diff --git a/kernel/dependency/dept_proc.c b/kernel/dependency/dept_proc.c
index 97beaf397715..f28992834588 100644
--- a/kernel/dependency/dept_proc.c
+++ b/kernel/dependency/dept_proc.c
@@ -74,12 +74,10 @@ static int dept_stats_show(struct seq_file *m, void *v)
 {
 	int r;
 
-	seq_puts(m, "Availability in the static pools:\n\n");
+	seq_puts(m, "Accumulated amount of memory used by pools:\n\n");
 #define OBJECT(id, nr)							\
-	r = atomic_read(&dept_pool[OBJECT_##id].obj_nr);		\
-	if (r < 0)							\
-		r = 0;							\
-	seq_printf(m, "%s\t%d/%d(%d%%)\n", #id, r, nr, (r * 100) / (nr));
+	r = atomic_read(&dept_pool[OBJECT_##id].acc_sz);		\
+	seq_printf(m, "%s\t%d KB\n", #id, r / 1024);
 	#include "dept_object.h"
 #undef  OBJECT
 
-- 
2.17.1


