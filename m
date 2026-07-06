Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 111E9C44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 427456B00FB; Mon,  6 Jul 2026 02:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC5C6B00FC; Mon,  6 Jul 2026 02:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A1126B00FD; Mon,  6 Jul 2026 02:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECB226B00FB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:22:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 789D91A02E4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:22:03 +0000 (UTC)
X-FDA: 84957356526.04.34DDD66
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf31.hostedemail.com (Postfix) with ESMTP id 92B3920006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:22:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf31.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=EGr5aMJWvwsK/nfJJP67zbogzNtXRiGybxvirOFZ+Yg=;
	b=g/9y3j0QS8csQ3OXqnqT0ytsGVFKaErD7oJ9qD7itpSV4Qyudoj2eagLtY/w7AMOzwHFPs
	k836AOFjAjfZcHbDo9EzElEMN7eEs/C9IS4Sc+pepE0EUGkyK0/5YByburzJApAI4SQw0G
	0gaK6TSS7fXMFlhSehK/jnil/ZQILXA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf31.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318922;
	b=0vmNdvSqdIItrYDsLorYo/MK9wpCag4zL4CHjBXMP+l3rxFoB+0oOe3WRfDmAf99LILBoW
	CG/EPpspUoMKDm/h2WFqk14CUUfYmaqTVmHiShdUnpF+dAlFLzAHFI01XwGQMkcvtCfT+/
	yJVtyp1PsMf/PgjKk0BdQ6ukUzNY5i0=
X-AuditID: a67dfc5b-c2dff70000001609-e4-6a4b498389cb
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
Subject: [PATCH v19 35/40] dept: introduce APIs to set page usage and use subclasses_evt for the usage
Date: Mon,  6 Jul 2026 15:19:23 +0900
Message-Id: <20260706061928.66713-36-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSX0xTdxzF+d37u7eXjiY31WR3+sDSqDOi6BbHvkvI5uIDV50Ji0YTfdBq
	r1JWwBQBgbgVKB1BMLVJIaNFK0hFrUjaCKLU8MeBDZLCcIACxQKrEKksjpZR0K7V+HLyyTnf
	c56+DCkdp9YxysyzgjpTrpLRYiz2x9VtK9mzL32Hp2UHDBd1YAgslmEw37HR8NbUKoLHI8UY
	JgNlCJZWTCSUtoUxLC6PicBYhCDs7EHwb/M7Gl51v0Fg9M7QUD1XhKHGZxKBf/IBBSPBeQQz
	Hb8huFLniNxV/UPDSr+bhGrjAIKr3gkSnI3FNPytv0uCy3iBBv+gmYDXzTRYip0U1JoMCHzP
	nQSU1N+hYfDVKgHjVQYCbtn3w6TVh6FPX0eAqbokKrMEGG8/IOBJ/TgGq2YjmPqHKGjyuymY
	7NVR0Kp5IQL7sz8QLD71EmCr8JFgnx6mwPk8Aa7qrmH4/fI4De1OF4aee1MEVDTfpcBjC1Mw
	0NFHQV/PYwyumhsY3PdvU9AwMkiAo/8JuUvBL5VexPxNRwvBl/75luZtl22IL9VHpHt+geS1
	jjy+oW+e5kOBv2jeGbRg/lL/Nr6tZkLEW+w5vPaRn+IdjVv4+vY5IjXhiDhZIaiUuYJ6+3fH
	xWnW7kfUmaKkc74hN6FBhq3lKJbh2J2cJ+RFH3n2ZZCKMs1+wY2OLpNRXst+zjkqfRFfzJDs
	UDxXYa3E0WANe4rrDAfflzG7kZtaNUQKDCNhk7jww18+bMZzt5o73u/ERuym1VoiylL2a25s
	oRdHNzn2eiwX8DSSHwqfcZ2No1iPJBYUcxNJlZm5GXKlamdiWn6m8lziyawMO4r8nPX86tF7
	6M3AgS7EMkgWJ4Fde9OllDw3Oz+jC3EMKVsr2bR5X7pUopDnFwjqrGPqHJWQ3YXWM1j2qeSr
	YJ5Cyp6WnxV+FoQzgvpjSjCx6zRI9+PT+JwDLS8MS6kL5dcTvvX0ZngCKYnf1JbHHK58bQ9Z
	8rOGC8JXoOaHwmd27XQ1n7771IBVpC0Z0b1s/+nCJ6xd5Lx40Jvs6mxJadg9cz9pzmwariqU
	uMbGYk5Mpxh635W1mqd+VbVp3brQf5rTZEjftH3J7KpUiFPjvt9wSIaz0+RfbiHV2fL/ASb5
	DkRvAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe2xLcRTH97v39vaulJta4hrJaDAW84px4hXPuQgh/lj4A81c1q2tahmT
	eXRV5t01aRfrxozVshXTMmYptTGPEauxzWM2VLdlY8we2dapW+Kfk8/5fs/55vxxKFxyWxBO
	yVW7OY1KppCSIkK0dp4+Wr9ydeJ0u1MI6YZD8KHRK4BanZuA7q50ArKv20kYtN7mTcc5ATyp
	SyOg+loRgsbudAS9A1YcDKUBAgZNlULo6nsvBLMOQcBVicDiMeFQX30fB/tNHQa/in+T0FbR
	icD8yUtCZquOgA7bKQRZPqsQWh+tgG+NZQIINDRjUNfTjsDm/Y2B130MwaAlCS7kOfl1yw8S
	Bl68xCHTXI3g4qcGHDpbmxDcrPyIwFWQRsJX4y0carzD4HV3BwlPzSdJ+ObJxuB7MQm5aS4B
	eJ63IcixmhD43rkw0F+6ToIlx0FAadNdIXja/Bh8sJgwKHKsgUabj4AqYx7Gn8tP3RgJ1kw9
	xpcWDMxXyzDosxUKF+UjttdwhmALnSUYa3g1SLL283bEDvSbENuVr8dZg5FvK9o7cPaIcy+b
	X9VOsv3db0jW1ZNLsM/yGPby8X6MzXgRzZZmNQjXLd4kmr+NU8iTOc20hVtFCbaKhwK1bvY+
	X81L7DAyTTmBQimGnsW0NPcIgkzSkUx9fR8e5DB6LOM87eN1EYXTNRHMKdtpImiMoLczDwI9
	KMgEPYH57DfxCxQlpmczgXsH/2VGMEXF7r85obx8zZ+DBVlCxzDvOx4TRiTKRSGFKEyuSlbK
	5IqYqdqkhBSVfN/U+J1KB+LfyXbAn3EHddWsKEc0haRDxbBoVaJEIEvWpijLEUPh0jDxxEmr
	EyXibbKU/Zxm5xbNHgWnLUejKUI6UrwqjtsqoXfIdnNJHKfmNP9djAoNP4yiDq0bcqSz/Uf/
	8udRk2eqzwxftutLrL/cmzon5EpqrBLG6Uvc0TMjXBsg5vux8Dr3rh1P85pLLD/jqjImxrWk
	KsrUTzxLjbWbC/YXR8aHH10wtqqAvux3HXfNLVBKhxjeblxfO6rsbJPekVzXPGfM0PjI7N7x
	P0NuxapV0V/kS3pPSAltgmxGFK7Ryv4AjOPYH0oDAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 92B3920006
X-Stat-Signature: go4upi4x7rjsjrkpaaw34ydbg1guh9fh
X-Rspam-User: 
X-HE-Tag: 1783318921-965457
X-HE-Meta: U2FsdGVkX1+XPwBC5g/VlZd30xFpVTpKSyUD3e4nop8W3NR8NL/LFRW0kUXkMF1Zqf3OuYecKsyg7rHdkOr5FONjZUGl83gLsOBfJ5AXNSSr5FL2wbXD38MvvHdZg86A8nCeBPhAFyNJWcT/SM/LJ9I0xE0TBF7B2quhjEHmE7KHYXDH3et4DdueMDKPhMFHH3wGEJv0rm6cO8IZrjK8j83I/gFBAlF0PVzQjW+awkrmDFHWZy8TcHWZ2cFGt6Q/FajkileasQukJQgsKe7WghWO1odISx/9eFoaCXhKwvATGof3GrXK5Puc41o94uijwRzCaub1u7nXBBMKjc7SkRBjGtkeWin/klUamhwIENgDYhhfDfSKLqe6cttVb8EEuKyCsZDub3Sw5Jz/Q8gf2EPJeYuTAKazY9XXK/LSwr8Xg0qYs0gaJp1oYwMXccSemQX5w3FZHaivyUNQ5vt22eIaD4nEq+5wT6mczEAqKs3qkg5CVVrK1uzVoLGq2w/LwPCa0dOS75gSlh76Tb0WUxnI97sBVREDCP8V9QxjuMb6fk1ublTn/C2vB84mtos9GUq7vdqUwuMeJiAo0aLTU62BK1uKwy4Ty2ykvlakii54kJ50ymcoFRw6UzFUjyl8W2YtqGCkClfr03TgPtxYCr2uhRdPuFAdAN1m8SLdxtLVJ1UfPaZi1WjVzg3m5cnSZQfkbS1Ir443myZ+MdKrEo8yPg/eRyLnAN16DjxsyuKYulUCYBKdIVHr3LLDaXyOp/kUQa79j3F2Yjv8BLYfoDhMI62FmUaELuUILvVCnnY8Cno25RMKVv7br5BqknOR8qQQMIMVP5Mt8WA7/3W2iqNJkj+iC7abCSAzOlusylXlstKb1ytsVFTlFKkiJgkYqtV6PoS9VSmS3ohTJ9EYpf5rd2K9KGcWKPorU1K+yOEe21HgP4LfugQWl+9572NbHFZTp6MkQhOd5OH2UUw
 KqFmUetv
 65m2yKktLPkfbJnoYBfxGz6YlAcbNSO3QHHIAygzc/vDklkd5ywnC397vUvIMcQOQT68L60ww9dF/qk9CYHHmQuCh8uLaqSHkHQk3ZWgfroq7SZXNyAAlNdr4DO4ZqWqb9bK5mvLBwAHndDx5HpiI9i4YvTHELnY40V6FyUVnwe6vSZ3amPMGjiVLVUGKFnsYq3XJttxdPz88JLBdtGc57wU+9l9OOgv+MxAgSdTopXb+ngrlhwXTxrX9iA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

False positive reports have been observed since dept assumes that all
the pages have the same dept class, but the class should be split since
the call paths are different depending on what the page is used for.

At least, ones for block device and ones for regular file have
exclusively different usages.

Define usage candidates like:

   DEPT_PAGE_REGFILE_CACHE /* page in regular file's address_space */
   DEPT_PAGE_BDEV_CACHE    /* page in block device's address_space */
   DEPT_PAGE_DEFAULT       /* the others */

Introduce APIs to set each page usage properly and make sure not to
interact between DEPT_PAGE_REGFILE_CACHE and DEPT_PAGE_BDEV_CACHE.
Besides that, it allows the other cases:

   interaction between DEPT_PAGE_DEFAULT and DEPT_PAGE_REGFILE_CACHE,
   interaction between DEPT_PAGE_DEFAULT and DEPT_PAGE_BDEV_CACHE,
   interaction between DEPT_PAGE_DEFAULT and DEPT_PAGE_DEFAULT.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/dept.h       | 34 ++++++++++++++-
 include/linux/mm_types.h   |  1 +
 include/linux/page-flags.h | 89 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 120 insertions(+), 4 deletions(-)

diff --git a/include/linux/dept.h b/include/linux/dept.h
index 236e57befb13..3b8faf5f04cf 100644
--- a/include/linux/dept.h
+++ b/include/linux/dept.h
@@ -19,8 +19,8 @@ struct task_struct;
 #define DEPT_MAX_WAIT_HIST		64
 #define DEPT_MAX_ECXT_HELD		48
 
-#define DEPT_MAX_SUBCLASSES		16
-#define DEPT_MAX_SUBCLASSES_EVT		2
+#define DEPT_MAX_SUBCLASSES		24
+#define DEPT_MAX_SUBCLASSES_EVT		3
 #define DEPT_MAX_SUBCLASSES_USR		(DEPT_MAX_SUBCLASSES / DEPT_MAX_SUBCLASSES_EVT)
 #define DEPT_MAX_SUBCLASSES_CACHE	2
 
@@ -142,6 +142,35 @@ struct dept_ext_wgen {
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
+	 * Do not apply usage type on request immediately but postpone
+	 * it until the next use of PG flags.  For example, if the page
+	 * is already within a PG_locked critical section, regard it as
+	 * DEPT_PAGE_DEFAULT temporarily at least until the section ends
+	 * e.g. folio_unlock() since it's still unclear which usage type
+	 * the page acts within the section.
+	 */
+	atomic_t type; /* Update and read atomically */
+};
+
 void dept_stop_emerg(void);
 void dept_on(void);
 void dept_off(void);
@@ -192,6 +221,7 @@ void dept_hardirqs_off(void);
 struct dept_key { };
 struct dept_map { };
 struct dept_ext_wgen { };
+struct dept_page_usage { };
 
 #define DEPT_MAP_INITIALIZER(n, k) { }
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5b3f54ee0d38..e25d09f3dfa9 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -220,6 +220,7 @@ struct page {
 	struct page *kmsan_shadow;
 	struct page *kmsan_origin;
 #endif
+	struct dept_page_usage usage;
 	struct dept_ext_wgen pg_locked_wgen;
 } _struct_page_alignment;
 
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 8ab39823ea31..0b0655354b08 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -204,6 +204,80 @@ enum pageflags {
 
 extern struct dept_map pg_locked_map;
 
+static inline void dept_set_page_usage(struct page *p,
+		unsigned int new_type)
+{
+	/*
+	 * Consider the page as DEPT_PAGE_DEFAULT until the next use of
+	 * PG flags e.g. folio_lock().
+	 */
+	unsigned int type = DEPT_PAGE_DEFAULT;
+
+	if (WARN_ON_ONCE(new_type >= DEPT_PAGE_USAGE_NR))
+		return;
+
+	new_type <<= DEPT_PAGE_USAGE_SHIFT;
+	new_type |= type & DEPT_PAGE_USAGE_MASK;
+	atomic_set(&p->usage.type, new_type);
+}
+
+static inline void dept_set_folio_usage(struct folio *f,
+		unsigned int new_type)
+{
+	dept_set_page_usage(&f->page, new_type);
+}
+
+static inline void dept_reset_page_usage(struct page *p)
+{
+	dept_set_page_usage(p, DEPT_PAGE_DEFAULT);
+}
+
+static inline void dept_reset_folio_usage(struct folio *f)
+{
+	dept_reset_page_usage(&f->page);
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
+	 * wait
+	 */
+	if (wait)
+		return (1UL << DEPT_PAGE_DEFAULT) | (1UL << type);
+
+	/*
+	 * event
+	 */
+	return 1UL << type;
+}
+
 /*
  * Place the following annotations in its suitable point in code:
  *
@@ -214,20 +288,29 @@ extern struct dept_map pg_locked_map;
 
 static inline void dept_page_set_bit(struct page *p, int bit_nr)
 {
+	dept_update_page_usage(p);
+
 	if (bit_nr == PG_locked)
 		dept_request_event(&pg_locked_map, &p->pg_locked_wgen);
 }
 
 static inline void dept_page_clear_bit(struct page *p, int bit_nr)
 {
+	unsigned long evt_f = dept_event_flags(p, false);
+
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
+
 	if (bit_nr == PG_locked)
-		dept_wait(&pg_locked_map, 1UL, _RET_IP_, __func__, 0, -1L);
+		dept_wait(&pg_locked_map, evt_f, _RET_IP_, __func__, 0, -1L);
 }
 
 static inline void dept_folio_set_bit(struct folio *f, int bit_nr)
@@ -245,6 +328,8 @@ static inline void dept_folio_wait_on_bit(struct folio *f, int bit_nr)
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


