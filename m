Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F6DDCCA472
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D028E0002; Thu,  2 Oct 2025 04:13:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17478E0008; Thu,  2 Oct 2025 04:13:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB8398E0002; Thu,  2 Oct 2025 04:13:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A50E98E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:13:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6BEDA13ABC9
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:08 +0000 (UTC)
X-FDA: 83952458856.28.B321C65
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9871AA0004
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=GFNADJXwoEKlvnClalmiz6O1PTupBozYXxPEd8pMR5I=;
	b=H67gONfYIkeWXb3nwyQd96eF/7rXusy60Uto22djoJPhsD118AaNS5usz09h7tTW6dPoLV
	70rZRTr4V+6MyMuMkRWE3bn4y1yxARIAM9E0Ufz9Gzt9w8MgpRrt18uGRx5sc+DjlS+05A
	129qYtYI366lp0IYL9YhFE5fU6DQ0t8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392787; a=rsa-sha256;
	cv=none;
	b=QI38t0zV+pmfFAm82LGRHFg7xY9sENoV9jU7OI1H3Gh7zwDTZlp0l2cmEO3ELA1WzuLH4P
	EmaLEjkCVVhOVg32r1fEWdO62wMnUGjwyGF4Eb/mgST3yiOSVBUnSY319JwMsHyGQ2Cmy3
	VT5etEtZtkLGFs3MmVlj9f+NWSCLe8w=
X-AuditID: a67dfc5b-c2dff70000001609-41-68de340a6dd2
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
Subject: [PATCH v17 01/47] llist: move llist_{head,node} definition to types.h
Date: Thu,  2 Oct 2025 17:12:01 +0900
Message-Id: <20251002081247.51255-2-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0xTZxjHfc9539PTSs1J58ZRFi9N0IjOK1sek2UaP2zHxHjZEhLlgx7H
	iW3kYoqgLFlWHHWdwQ3ZBlnpJlipDbSiLchF3bAoXpDRUqUF5TZEJKWyGFqi0GGB+O33/P//
	/D49LK3yk6WsNvO4pMsU09WMAitCcRUfLUzu02y0NC6CrvxmDOEJIwZzjZ0Bo/N3Ap7L1Qj6
	w0YEk1NlNBgaZzBEi1tlUOItpiHY8gpB6Wg+hnFrIYLRO19AqP86gZneEQr8kTEEz5p/QDDV
	3kFDbWsfguGiOhoehccZCHnNFJT84cTQONAkA29wmoqZGCi5Gg9lpS8o+M1xnYKHlqcYrPpE
	KGv3EZge3AQz5VlwOdRBoP/uaQL1+gEZOLvvIJh4NEiBvfA5DcamMAbnUBeBmz1roeL0RQw3
	bt7HYIxOIGht+JcCX5OZgcIrdQT67DME9GWTBDqrPRhqRgIUdDQ5CFT6vRQMDgQIuNof0hD5
	KQE8584SCBQNI3C8vMBAZ3M5Bfm3LHh7mlDlukYJhs4oI9j/tCNh6k0xEiYqv6cFQ1HsLHCd
	ECrbxhjhTfgxIzy4wAuNpl6ZUPBXj0wod+YIBbdDRHDZkgTLjVFq74YDik/TpHRtrqTb8Nkh
	habfXUOOVShOdoZeIz36mz2D5CzPJfNPPLXkHd8NmphZZrjVfCDwmp7lxdwK3nX2+dyG5to+
	5Lu862b5PW43b+64F8tZFnOJvGFq52ys5D7m+yxuPK9czldfaZ7TyLlPeN9g21yuim0M4wXU
	/KZUzrtP7ZznJfwtWwAXIWU5WlCFVNrM3AxRm568XpOXqT25/uusDCeKvZv12+nUBvTK85Ub
	cSxSxyk9ib0aFRFzs/My3IhnafVi5SHbU41KmSbmfSPpsg7qctKlbDdKYLE6Xrk5ciJNxR0R
	j0tHJemYpHvXUqx8qR5Z20h31gfnLSnq76LLV+n+o3ocjrhw4s9BeTTlSJXN9M+v8Qn+XXrX
	ly3mYJ5/t/jMZByqt61RRtSHl1lHIhcTfvz/VGoSGa9f2XB07IF46ZdF+z737YPcl6ny/XXw
	2LBj//tD27a0rOs2LkvduiZlz+bbG5nanLjJtaaVl3TDvoNqnK0RNyXRumzxLYONK9hqAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0hTcRTH+923q8ltCd4eUA1GEGUFPQ69KIi6PawgSIgil17acj7azDKI
	NDcSe63BtDYrmzVEV86pkYkli2ZlsubKopy2WGbMOShXrPloK/rn8Dnf75cv54/D4JJWcg6j
	zCsU1HlylZQSEaLd68qWilYOKJZfGpVBX2knAZGxcgKqG20UlDuuk/D6fgOCwUg5gl8xMw66
	tikCJgwuGsaiH2mY6nAhqPQYcLC1lGLwwz5JQfDpdwRGf4CCqm+lBIStFxGYhsw0fHu2DUKD
	7SRM+b5i8O7nCAJrYBKDQOd5BBOVOXDL0kxBrMeNQ5XxNYLbfh8Ow/a42eIaQNBRd46CL/pW
	HLyBZHgTCVPwwniBgpCnGoNROwU15zpIuGE2ICirbaSg8oaDgLZPj2jwBMcx6K80YNDgSIdB
	6xAB3XoLFr8vnmpKBXNVGRYfwxgY77VjELXW0/Cqtp8Aa4kMzD1eEj7XmWgY96+AqZp8cDV8
	pcF3xUjA/ZCb3GRE/C/dZYKvb36A8breCYq33bQhPvbbgPixu2U4r9PH16cjYZzXNp/k73aP
	UPzvyFuK7/hZQ/AvLRx/tWcp32by0bz28Qd679oDovXZgkpZJKiXbcwUKQadjWTBbdGp3lAU
	laAnTAVKYjh2JdcVNFEJpthF3Pv3UTzBKewCrvnSEJlgnO2ex/V5liR4Frubq3Y/j+sMQ7Ay
	ThfbnpDF7CpuoNZJ/KuczzXYO//WJLGrOa+/+68uiWd0YS2mR6IaNK0epSjzinLlStWqNE2O
	ojhPeSotKz/XgeLPZD0zfvUhGvNucyKWQdIZYo/Mp5CQ8iJNca4TcQwuTRFn1vUrJOJsefFp
	QZ1/WH1CJWicaC5DSFPFOzKETAl7VF4o5AhCgaD+72JM0pwS1PRFbsGDR1yz9+w7fw3vyjh5
	KD32JqN3+c5wptuSNb099czz4abrm/dvNejXR2ZOOtL9FX0bqi++NS107Jrh0arMXX5vLAjH
	PD77g3u9MdXB6M0t2JX6ztQTybKzhsJW8ZrRgkCJ7U5geqjvnWmXJauiJZjSRth1H1l38vFh
	rZTQKOQrFuNqjfwPFrroz0gDAAA=
X-CFilter-Loop: Reflected
X-Stat-Signature: 749w8zyymcwbiw3p5of63a1wh4h7jp5m
X-Rspam-User: 
X-Rspamd-Queue-Id: 9871AA0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392786-110242
X-HE-Meta: U2FsdGVkX18aT/W3/9IagkUNwbB/s27mpRWwVYyZUynLqIqlL6LZYGVPfaCACDQ9n7ID53xce3shds9CyMkaI8vvFK0cRAA6Xj/6LSoIJeic2IKsVm70OjuO/whX8xcVTZQlveiCz6FKhlCpgpexRqBeDXzGsr1ZOW5vdGyVwdBiXdc086o5AsMxzJzT9yDzVIoC+RfZhdmQAFIdObWJTvuzaFAg2XsP3GcfsoqM15hjR4BuTlqtTY+mZcfVvrNIUqpvaAL0WjgDBnCkvWQIBq+YVWNb7yzNcp2P0xRLFRLr0juasiqkb67yU64wxlZo+LVMNxqhFk2qJNHedDBH+CywFchRFCKiTBXWh6G6vz6IKSh8HP9q1Z6cYtsi+3Id6RHv1p1k67JawUx41gHJMCKYilxGaRy3t/If3p5HrmM9K+yZ3ppqPiQDoDJ0OcYrb1xi7QDgXKIbB/fJVtLJeIjE8raC6pa6XVc8zTKKp3syFqfToFwE6/Ik0dZIthmmDJRcsibavwOYRli9KZmZWy73k5n8YYCDnxSzhKACAgfG4dRKVcGDDrslcSNrfA19xicegqH00FeCP2tCyKvS6l8XXoqK+HPnbvtfD8EP1AdMRmR2Fll0QUuqlSMB1m5T48rZ/7qbF1pocuk5FRAWPsJ99I8yfDO1jrWW+lH/LwCwihsfhNXKkQgHPpcbJfaCnw0MO64TKJyyNA5IDx8zUV6VWRf3v3PJcirk0iGuofObH9LMWeDrc9MJJ5vglcZ9LCFcsBoKBLomum4jVFHsc+TSmxYLhDAptUTtH1rYEtS+UjPMSscL0hh/rhBtKQHl+Vd1s+b7yJJfGPvGv6VaQrbVeLhJB97tnBdpIDLujJPlp8/Im/7VpzjJya6qDBd5S63m+o0k14suij2Slxi5l8gEdfTNWp7qtI8xQfjOdXDFxm7OlH+aeK39BQHNkA/vlKznmU7IfJv/nzVpwJ0
 ck9dSwRd
 uPN1zPvZJmXIjyGqpgJJyj82QIYmk7PDu2zsHOij2nTo9XHkf22DDQcCswtJTjJz+rSywzwC1JGl90o+ZB3+9b32db+49GlWvXQH9cOPGcFkjxJSBJ3B9E+z5mlQpNySrIXH3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

llist_head and llist_node can be used by some other header files.  For
example, dept for tracking dependencies uses llist in its header.  To
avoid header dependency, move them to types.h.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/llist.h | 8 --------
 include/linux/types.h | 8 ++++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/llist.h b/include/linux/llist.h
index 607b2360c938..6bcdf378ebd7 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -53,14 +53,6 @@
 #include <linux/stddef.h>
 #include <linux/types.h>
 
-struct llist_head {
-	struct llist_node *first;
-};
-
-struct llist_node {
-	struct llist_node *next;
-};
-
 #define LLIST_HEAD_INIT(name)	{ NULL }
 #define LLIST_HEAD(name)	struct llist_head name = LLIST_HEAD_INIT(name)
 
diff --git a/include/linux/types.h b/include/linux/types.h
index 6dfdb8e8e4c3..58882a3730eb 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -208,6 +208,14 @@ struct hlist_node {
 	struct hlist_node *next, **pprev;
 };
 
+struct llist_head {
+	struct llist_node *first;
+};
+
+struct llist_node {
+	struct llist_node *next;
+};
+
 struct ustat {
 	__kernel_daddr_t	f_tfree;
 #ifdef CONFIG_ARCH_32BIT_USTAT_F_TINODE
-- 
2.17.1


