Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23639CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52D7B8E0039; Thu,  2 Oct 2025 04:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43FAC8E003C; Thu,  2 Oct 2025 04:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7638E003B; Thu,  2 Oct 2025 04:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3BA08E0037
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:14:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94F59C03A8
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:25 +0000 (UTC)
X-FDA: 83952462090.21.99B30FB
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9FB761C0006
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=ctlYMnr34PxlnD1VhwaJj6+0KPXrRDGm/ZTGLpqVwb4=;
	b=Ud0oJgnvrTKvoKJVIy3XG7AccANGsYcFBB3lq7j7s3wc8nFgRLpZieVUAxPPDCZ2XhVXZh
	Z4jA91fxntP9ztp+NcXg++6PqzaGHdTYWE2GMNKy3G6HzNT3Flyfn1shyYHpSq1f1Dyq08
	lJ+zUY6uavKHkVuI1vYZlR5SgL4eQzQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392864; a=rsa-sha256;
	cv=none;
	b=dTvy0SfyAdWdjMeRKUTP5DpCqKBZX+Z702+n1UA9ZjiA+H/eLLMFpACG36o/QbD1uygWQn
	N6QilvZgM4h+PVSmLy1tKyEuWiOCZwnuxVIMRzVCt+NwS5UF/NFtpXMK1r+Bv1tiojtQHj
	XcHeIn2Fz+q6nLVofG43LoiU3OXOhGs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-d3-68de341932f9
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
Subject: [PATCH v17 44/47] dept: introduce APIs to set page usage and use subclasses_evt for the usage
Date: Thu,  2 Oct 2025 17:12:44 +0900
Message-Id: <20251002081247.51255-45-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSe0hTcRQH8H73PXNxm7WuLswGIliaxawjRQUlXIIi6J8oJEfe2nBqbWYq
	FStfaSqlSekUNHssH2UzS1uWWS7TTM0HK9RSSi3dJJlKPnNW/xw+nPPl+9dhcMkV0oNRR0YL
	2kilRk65EC421yI/d0WfKqAr1w2mZgw4JNUsEDCXZaFhodaCoOzxRQy+1aUgqDVeoqDAkIWg
	fWQWA8ONBOcYxiCn3IzB++IeAgwtHSRYSodoeGBrJeFdXzcJT/Vfaaj9vAGKkm8TYKkewKDj
	WT4F6RVVJPSVLZCgN0yR0FbXTELrs3ISJjNlUG6/RUG2fRCB8deNxcpCKVS9TELwNqMOg5Rh
	MwWdn8wIhvIKMHg9MYpB9sdCCipNOThM32tA0DTdhMFApo2G8YJ5EhJ7AsFRWkKB/aqDBEND
	H707gJ+ZzkL8tRY/viavl+YLTWf4SqMvX/z8B8abSlIp3jSeRfNFM8M4n2brxHj7hw8033hz
	huBr+oP4In0OzhdnZpN8RoKdOig94rIjTNCoYwTtpp2hLqp0cxt1ql4RW9FVReiRwzcNMQzH
	KribxXvTkGiJua9+0E5TrA9ntf7GnV7FenGVGYOk0zjbvJbrbt/otBt7gsvtsS7tCdab6y4f
	IpwWs1s56/UE7G/nOq60om6pR7S47+hvXspI2EAuaSzxX+aeiEt+dOGv3blXRitxFYkL0bIS
	JFFHxkQo1RqFvyouUh3rfzwqwoQWX+Tu+dmj1Wi87VA9YhkkdxW3efeqJKQyRhcXUY84Bpev
	Eocae1QScZgyLl7QRh3TntEIunokYwj5GvGWybNhEvakMloIF4RTgvb/FWNEHnp0IGTPi3zD
	2PrDwaelbvYB/6+9b0Z0T3ziN112T1r9LWTr8vCWOYt2ROp467lb1jV2rvGkutV1766V9Gz3
	ClmQYjQw3Crz+/J9MFipiQ2Z+tX7+P79jictnNTskbsvoDpvv+0Os/35z7Xqg+bl6RNN7Z5j
	r7kGOnX+4Wev39sG1jT9lBM6lXKzL67VKf8Ash49Ph4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTdxTG/d/7v/e2zYo3lcQbNdE0QRYiviRgjrg4E028c5vZt2XzjWbc
	0UoBbRGtcQlYGsmGExpaQguT1VhJKdBRJEOswSIERAJ3TGCzBeuwSICRzFblfS3Lvpz8zvM8
	eXI+HAmpaKO2SDR5BYIuT6VV0jIsO3HQmMqljav3ekfTYKS4E0M0UoqhptlNQ2lLNQVDTQ0I
	JqKlCN4t2Ukwta9hWDH3MBBZeM7Amq8HgVU0k+BuLSbgjWeVhpmufxBYQpM0VE0XY5h3liGw
	he0MTHcfg7mJDgrWglMEjL6dReCcXCVgsvM6ghVrDtxyeGlYGhgkocoyhODnUJCE156Y2doz
	jsBXf42GV+X3SBieTIDfo/M09Fl+oGFOrCHgbw8Nddd8FNTazQiMt5tpsNa2YGh/cZ8BcWaZ
	gIDVTEBDy+cw4Qxj6C93ELH7YqlfNoO9ykjExmsCLI0dBCw4XQw8vR3A4CxKAvvAMAUv620M
	LIf2wVpdPvQ0TDEQvGnB0DQ3SB22IP6d6UfMu7xtBG/6bYXm3T+5Eb+0aEZ85I6R5E3lsbVr
	dp7kS7yX+Dv9szS/GH1G8763dZh/4uD4ioFUvt0WZPiSh38yX2R8LfsoS9BqCgXdnkOZMnVZ
	xxB93p922fPsHi5CkZTvkVTCsWlc9aNpJs40m8yNjS2QcU5kd3DeG2EqziTbv40bEXfFeRP7
	LVcdGFvXMZvEjTRO4TjL2f3cWKWR+K9zO9fg6Vzvkcb04VD/ekbBpnOm+RKiHMnq0AYXStTk
	FeaqNNr03foctSFPc3n3N/m5LSj2Tc7vlit+RZHhY37ESpDyA7mYFFQrKFWh3pDrR5yEVCbK
	M+sDaoU8S2W4Iujyz+ouagW9H22VYOVm+fEvhUwFm60qEHIE4byg+98lJNItReh0YNwmlGUX
	FxgOn+oSzxi7X1VW5L58f/eTjHO+T/U7k69Wdz+QiSc/FKPS0coNvY4LoVWNqNv58MD2z7Jr
	HxCz+e77NfZ0hxguPZExmLCRajvVvD8F+53s6GIvuB5fD9v8hj1m5tZXUtcbYuOMNfEP6xHt
	yRd/Hf3Yl/W4qG9IifVq1b4UUqdX/QsQvzpjSQMAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: 3ug67mtdzq6gxoozxmc55atdjz6iz7q7
X-Rspamd-Queue-Id: 9FB761C0006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759392863-19323
X-HE-Meta: U2FsdGVkX1/lYWSt4fqf1f4nm855cFJ7wi26CMvYTBvt5lkSIRtcQ7Kcs2HE/TzHt67qnskDMEGWLsF9S7K8n6+V1/blvCCCs6ZPmnAcBiR7DvPmFgN1Ti1CKIyVxdBpmhcm1613P7fVuxhC6YY+85jWvVtXpvGJvmUJNLRnfQlGDxG3Zn/e2EUmcgofNCEytBunMqkkaBhDW+5wjtb4xIX3ss6I986MyAM8RzAOawEXUV607NTI3qjYYiqcVz3xZAMx9K0L+W/7NG0e1XOQnVMkusANPNMd52r6lui6Npyiq05oVVR8VGABOUJ86906WUI3sKc2Y4BCkZFEaCVk+uTmohXJFd2Pcf4rs+U3tQGNFsK+tXbUmHZuOpMy/GQnZa8HDOGmeqhZJ/2G4BV9TdHYdAiceDfK5ZpHdPaOfEqLGhlQsRYvOXVl111l78NE+UqNp50KfvS22y+xZdbwF8SQ+JffIs/hDUWry9jqz4TUr3u8qFD+uN2/fqUfLf6ej5DJzSPMRdkueM18JDXOBbUFTwpkZzPxTxJAWMl/3iqCRyRhMYCOm0EDoVeRhHbKGioF996ySaCrmB8+mCLMWAIAp3Qu91J5DDvnADAY/QfDKn/YC5JyIbVZbGE5tt6gslTWHpV4fj2Xfu8yEWM+NjITWWV87yo1Me+KUEoUM4a3cIRt4HC2E3+1n1ixG1MmIByGnZHf3KaGQfIPfU2XuIU1kcwnriryWyPvz/FqfeY1ave0TD8iRsw7+f9ZAVDkuGOJmpN5kTWyytRkVnN/PpQMR+JfiYkVNK75iROIF0d7YtF8lD2Ga3gUjDuyrwk0e0Br3ybBve1i7Z6bBnF38lEzFrJ+6MKyp/H81GUe9IQYydPfO7Je8Md1wN1RprH+7DATmGMIC2Nvl+VqB4Pi8jXaRTHBmA34FkwRR0wK/zoqYHECJy5zE3oxNKwTPNVTkg4lGjdEyY9qWQqfPEM
 vilMDxcG
 5Um58ULEyRsEEMIvb8TpuNDBjIIL12Gj0zlxTtk4R5WttQEJjS6ai1es8Nm6RDQbN5u5OO/xqOGeSBFggwZDlTuOT+JtvIzR6bDPyBQ5tLcTMkfvBqE+5ZlyUssmr/3GerV2V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

False positive reports have been observed since dept works with the
assumption that all the pages have the same dept class, but the class
should be split since the problematic call paths are different depending
on what the page is used for.

At least, ones in block device's address_space and ones in regular
file's address_space have exclusively different usages.

Thus, define usage candidates like:

   DEPT_PAGE_REGFILE_CACHE /* page in regular file's address_space */
   DEPT_PAGE_BDEV_CACHE    /* page in block device's address_space */
   DEPT_PAGE_DEFAULT       /* the others */

Introduce APIs to set each page's usage properly and make sure not to
interact between at least between DEPT_PAGE_REGFILE_CACHE and
DEPT_PAGE_BDEV_CACHE.  However, besides the exclusive usages, allow any
other combinations to interact to the other for example:

   PG_locked for DEPT_PAGE_DEFAULT page can wait for PG_locked for
   DEPT_PAGE_REGFILE_CACHE page and vice versa.

   PG_locked for DEPT_PAGE_DEFAULT page can wait for PG_locked for
   DEPT_PAGE_BDEV_CACHE page and vice versa.

   PG_locked for DEPT_PAGE_DEFAULT page can wait for PG_locked for
   DEPT_PAGE_DEFAULT page.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/dept.h       | 31 +++++++++++++++-
 include/linux/mm_types.h   |  1 +
 include/linux/page-flags.h | 76 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 104 insertions(+), 4 deletions(-)

diff --git a/include/linux/dept.h b/include/linux/dept.h
index 0ac13129f308..fbbc41048fac 100644
--- a/include/linux/dept.h
+++ b/include/linux/dept.h
@@ -21,8 +21,8 @@ struct task_struct;
 #define DEPT_MAX_WAIT_HIST		64
 #define DEPT_MAX_ECXT_HELD		48
 
-#define DEPT_MAX_SUBCLASSES		16
-#define DEPT_MAX_SUBCLASSES_EVT		2
+#define DEPT_MAX_SUBCLASSES		24
+#define DEPT_MAX_SUBCLASSES_EVT		3
 #define DEPT_MAX_SUBCLASSES_USR		(DEPT_MAX_SUBCLASSES / DEPT_MAX_SUBCLASSES_EVT)
 #define DEPT_MAX_SUBCLASSES_CACHE	2
 
@@ -390,6 +390,32 @@ struct dept_ext_wgen {
 	unsigned int wgen;
 };
 
+enum {
+	DEPT_PAGE_DEFAULT = 0,
+	DEPT_PAGE_REGFILE_CACHE,	/* regular file page cache */
+	DEPT_PAGE_BDEV_CACHE,		/* block device cache */
+	DEPT_PAGE_USAGE_NR,		/* nr of usages options */
+};
+
+#define DEPT_PAGE_USAGE_SHIFT 16
+#define DEPT_PAGE_USAGE_MASK ((1U << DEPT_PAGE_USAGE_SHIFT) - 1)
+#define DEPT_PAGE_USAGE_PENDING_MASK (DEPT_PAGE_USAGE_MASK << DEPT_PAGE_USAGE_SHIFT)
+
+/*
+ * Identify each page's usage type
+ */
+struct dept_page_usage {
+	/*
+	 * low 16 bits  : the current usage type
+	 * high 16 bits : usage type requested to be set
+	 *
+	 * Do not apply the type requested immediately but defer until
+	 * after clearing PG_locked bit of the folio or page e.g. by
+	 * folio_unlock().
+	 */
+	atomic_t type; /* Update and read atomically */
+};
+
 struct dept_event_site {
 	/*
 	 * event site name
@@ -562,6 +588,7 @@ extern void dept_hardirqs_off(void);
 struct dept_key { };
 struct dept_map { };
 struct dept_ext_wgen { };
+struct dept_page_usage { };
 struct dept_event_site { };
 
 #define DEPT_MAP_INITIALIZER(n, k) { }
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5ebc565309af..8ccbb030500c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -224,6 +224,7 @@ struct page {
 	struct page *kmsan_shadow;
 	struct page *kmsan_origin;
 #endif
+	struct dept_page_usage usage;
 	struct dept_ext_wgen pg_locked_wgen;
 } _struct_page_alignment;
 
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index d3c4954c4218..3fd3660ddc6f 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -204,6 +204,68 @@ enum pageflags {
 
 extern struct dept_map pg_locked_map;
 
+static inline int dept_set_page_usage(struct page *p,
+		unsigned int new_type)
+{
+	unsigned int type = atomic_read(&p->usage.type);
+
+	if (WARN_ON_ONCE(new_type >= DEPT_PAGE_USAGE_NR))
+		return -1;
+
+	new_type <<= DEPT_PAGE_USAGE_SHIFT;
+retry:
+	new_type &= ~DEPT_PAGE_USAGE_MASK;
+	new_type |= type & DEPT_PAGE_USAGE_MASK;
+
+	if (!atomic_try_cmpxchg(&p->usage.type, &type, new_type))
+		goto retry;
+
+	return 0;
+}
+
+static inline int dept_reset_page_usage(struct page *p)
+{
+	return dept_set_page_usage(p, DEPT_PAGE_DEFAULT);
+}
+
+static inline void dept_update_page_usage(struct page *p)
+{
+	unsigned int type = atomic_read(&p->usage.type);
+	unsigned int new_type;
+
+retry:
+	new_type = type & DEPT_PAGE_USAGE_PENDING_MASK;
+	new_type >>= DEPT_PAGE_USAGE_SHIFT;
+	new_type |= type & DEPT_PAGE_USAGE_PENDING_MASK;
+
+	/*
+	 * Already updated by others.
+	 */
+	if (type == new_type)
+		return;
+
+	if (!atomic_try_cmpxchg(&p->usage.type, &type, new_type))
+		goto retry;
+}
+
+static inline unsigned long dept_event_flags(struct page *p, bool wait)
+{
+	unsigned int type;
+
+	type = atomic_read(&p->usage.type) & DEPT_PAGE_USAGE_MASK;
+
+	if (WARN_ON_ONCE(type >= DEPT_PAGE_USAGE_NR))
+		return 0;
+
+	/*
+	 * event
+	 */
+	if (!wait)
+		return 1UL << type;
+
+	return (1UL << DEPT_PAGE_DEFAULT) | (1UL << type);
+}
+
 /*
  * Place the following annotations in its suitable point in code:
  *
@@ -214,20 +276,28 @@ extern struct dept_map pg_locked_map;
 
 static inline void dept_page_set_bit(struct page *p, int bit_nr)
 {
+	dept_update_page_usage(p);
 	if (bit_nr == PG_locked)
 		dept_request_event(&pg_locked_map, &p->pg_locked_wgen);
 }
 
 static inline void dept_page_clear_bit(struct page *p, int bit_nr)
 {
+	unsigned long evt_f;
+
+	evt_f = dept_event_flags(p, false);
 	if (bit_nr == PG_locked)
-		dept_event(&pg_locked_map, 1UL, _RET_IP_, __func__, &p->pg_locked_wgen);
+		dept_event(&pg_locked_map, evt_f, _RET_IP_, __func__, &p->pg_locked_wgen);
 }
 
 static inline void dept_page_wait_on_bit(struct page *p, int bit_nr)
 {
+	unsigned long evt_f;
+
+	dept_update_page_usage(p);
+	evt_f = dept_event_flags(p, true);
 	if (bit_nr == PG_locked)
-		dept_wait(&pg_locked_map, 1UL, _RET_IP_, __func__, 0, -1L);
+		dept_wait(&pg_locked_map, evt_f, _RET_IP_, __func__, 0, -1L);
 }
 
 static inline void dept_folio_set_bit(struct folio *f, int bit_nr)
@@ -245,6 +315,8 @@ static inline void dept_folio_wait_on_bit(struct folio *f, int bit_nr)
 	dept_page_wait_on_bit(&f->page, bit_nr);
 }
 #else
+#define dept_set_page_usage(p, t)		do { } while (0)
+#define dept_reset_page_usage(p)		do { } while (0)
 #define dept_page_set_bit(p, bit_nr)		do { } while (0)
 #define dept_page_clear_bit(p, bit_nr)		do { } while (0)
 #define dept_page_wait_on_bit(p, bit_nr)	do { } while (0)
-- 
2.17.1


