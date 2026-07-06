Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45934C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAD0A6B00EA; Mon,  6 Jul 2026 02:20:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E83966B00EB; Mon,  6 Jul 2026 02:20:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6776B00EE; Mon,  6 Jul 2026 02:20:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3ECA6B00EB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:20:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 23B70168446
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:58 +0000 (UTC)
X-FDA: 84957353796.28.19C41DB
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf17.hostedemail.com (Postfix) with ESMTP id 112B140007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf17.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318856;
	b=NcLE2J1J1vc+7MNLX92BpDGEWpfMh0JraXLqDiwgH8t07T1ZWITZxY39jlG4w+5IE7E8ES
	y8s7l+TrAo1D851Zkn2sszsuZt94C6VtV9IJsnF1arv06iR/AF+k1rQLwVtGCIVyvLW6f5
	LnygG0vUqJPGHaflFyk/tgJ+vk0XeYE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf17.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=oIFhWrTGUfur20/e7SGXsAuHKeZnqEM6ZxW/2ciVAN0=;
	b=eDL/iDatHKtj0lTjr43Bqd2JxzoiC4zJF5MYzXHLjbM4ISTZQt+tQQpXEJxTpIldGBIh1v
	l48FNmmz8TcvGRsSgZoRQJyROzM42aa7x/AZwSG9kONNAtoa8FEwV+H+zbnMZu3vhE9a0P
	bw0K3SdmmI0uKHhx32VtwgZZkTZMvdc=
X-AuditID: a67dfc5b-c2dff70000001609-d4-6a4b4905193c
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
Subject: [PATCH v19 30/40] dept: make dept stop from working on debug_locks_off()
Date: Mon,  6 Jul 2026 15:19:18 +0900
Message-Id: <20260706061928.66713-31-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0xTZxjG/c75zoXaZmfVzCMmY6nZNGTqmLq8ccaRzCzfdJhd/pvLtgZO
	pKwgHrDKphlEunVTWG1kRCc3mazSUrBMYwGRtcNdvFBxsKLtBDEVLHgp0OpkdgeI/zz55b08
	efLm5WntdSaZN+QVSnKe3qhjVVg1rq5bwb69OeeV4MlUCN64xUB/SReGqUkLBov7MAN+lwOB
	2ZPAUFGCIHH2PIKA/xwNzp9LKJhoecJCxBdFUDlagiERuk3Bra6vEURHBxH8UbGfhfC1sxTs
	q29mwTPYxsGVyDQFDncGXLAeo+D7k4vgh8p9lCIjFFQ0tVNwsT6IYXooDULfVWBwjfcwEAnb
	WLC0TWFwD/czcLg6yMI/zoSSresCA70OP4bm2wEKetqaGIiVLwH/wTJlK9ZAg/1BJQPhvq8o
	OF/7HJyo+QmBLRzl4NQ5sxLyxxiGYPkdDH8NtCPotAxScNw+zoDb2c+Cb2qMgj9DExz8Gzqj
	nMVWw8Kp7jgHjx8eZeFhyzADVZNpMOloZNPTSdxcjomz2omI2aqIb+weTUpbdxHPkRBHSjuv
	caTWvZO02lNJfccoRdyN37DEHbVxpO7xCE2C/R0suXv5Mke8Pgt6N+VD1fosyWgwSfKqDZ+q
	spsTj5j8bs1u+8gAKkbm+d+iJF4U1oj/uU4wT9kTr59lVlgmBgKP6BleKLwgtpaFlbqKp4Wr
	KeKBhjI801ggvCc648fRDGPhRbEz2jPLGuE10RqNsHOmKaKjpWvWKEmpu6arqBnWCmvF6/d+
	w3MzNUli76+vz/Fi8Rd7AFuRphbNa0RaQ54pV28wrlmZXZRn2L0yc3uuGykv17B3eusZFPV/
	4EUCj3RqDaRvytEyelNBUa4XiTytW6h5afnmHK0mS1/0uSRv/0TeaZQKvGgJj3WLNK/GdmVp
	hW36QukzScqX5Kddik9KLkZ71qUfGrqbyXnvd291HqqZ93uqaZntTp/vjUL1xEbXJSnjgb24
	KbZYKOxdrclYr74Y//gg5PNW4ctN+eOrnu9LfEHfxLJz/w7zsSfy0mf6qjpM8to9E40bSGRL
	8pj9o6VqPPB+adnpI+8wpPPNv4efDQ29zC8ncp1ozLzSXul5S4cLsvVpqbRcoP8fHQuW9W4D
	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0hTcRTH/d3H787V4rIGXYyyFj3oYQVZJ4owirxpRQUhCJUjLzmfsZVp
	EKlrtN5rsUlOy1aOmitNe61aipaVFmlmWmYrWqZpWUsdPubaiv45fM73e86X88cRkdI7dJhI
	mb5XUKUrUuVYTIk3rdAsoNfHJi86vR102kPw3uWm4U1uNQUD/ToKCsvsGHzmOwzoKs7R8LQ1
	j4LG66UIXAM6BN4RMwlah58Cn6GOgf6hdgaMuQj8zjoEpiYDCW2NVSTYb+YS8Lt8DENPrQeB
	8ZMbQ353LgV91hMICjrNDHQ/jobvrvs0+Du+EtA62IvA6h4jwF19BIHPlAIXLJWBddNPDCMv
	XpKQb2xEcPFTBwme7o8IbtZ9QOC8kofhi/4WCc3uCfB6oA/DM+NxDN+bCgn4UY6hOM9JQ9Pz
	HgRFZgOCzndOAjSXyjCYiioocHy8x0BTzygB700GAkorNoLL2klBg95CBM4NTN2YBOZ8DREo
	XQQYr90nYMhqY6JKEO/VnqJ4W+Vtgte+8mHeft6O+JFhA+L7SzQkr9UH2trePpI/XLmfL2no
	xfzwQAvmnYPFFF9v4fjLR4cJ/syLBbyjoIPZvDpevDJRSFVmCqqFqxLESWX+IXrPY0nWla63
	KAdpxx1DoSKOXcI5vJfoIGN2NtfWNkQGWcZO4ypPdgZ0sYhkm8O5E9aTVNCYyG7h7N4SFGSK
	nck99Lz8yxJ2Kaf39OB/oeFcaXn136DQgH59tIgIspSN5Nr7nlB6JC5GITYkU6ZnpimUqZER
	6pSk7HRlVsSujLQKFHgn68HRM3dRf3N0DWJFSD5eAlExyVJakanOTqtBnIiUyySz5sQmSyWJ
	iuwDgipjp2pfqqCuQZNFlHySJCZOSJCyuxV7hRRB2COo/ruEKDQsBxGcKjZtnX5HiPLz88Mt
	svqYQ1cPREc9NNhCcnaTM260tIdV2fCaKeE7lt36mUjqLK1bxlDD4KMMZt+ci9uy8FpXVcRw
	pGwwbkWkGk3vUnXMPRsV88FvfVvgy1weHf7mV6zrQve8qfUHv82vjbfcU6zVF2q+mJgNq70W
	j2MrfpAgp9RJisVzSZVa8Qc5S0vSSgMAAA==
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 112B140007
X-Rspam-User: 
X-Stat-Signature: gmz13d8ajiksqrb7fnxqahkbbs1odie9
X-Rspamd-Server: rspam03
X-HE-Tag: 1783318855-495055
X-HE-Meta: U2FsdGVkX1/PZBnUT49cZUOKksiJUH83PEmWF/5hgDl5Pu4qravYbEnbAco/8gwahKjY7fuBVkO/qmvJE+AKIzXMbeJehaXZ7bRDr/CXSNTijyu7fDpGwjp0kea1fdzdP+bjh0xIZDxAxtayYiyYqC3F8M5MIdAfr1DKd0I64IzX5vQDUJnDyEGEqQsZIJ2+XXWjEdXtUHZk9zQQhJzquvRzJjQkDac77WxouNbByKaJ7F0xdRnJVEXjuX9Gi8QNMn4e5N92srDZ13FxTXcjXcOs/2fNnTseS8EnkAeeMECuzywU/IjR3oYEkaM3Y51GrgLC42sImWOZEeVDJ5Mse2Nz2LsYTYvopYDeb6aY47x9vGLto7l7WZlWLc19TgTL+88ozLCUTVAQMVG7LQcLTsY2+mz3ux9x5tt3zUD96d1XmfcYVV2NMpA8J95/Z1WIMZYKDR8Iusvj3tTzp7xn94jC4n2A8/XlO/0+tkoHMSbyIhEFIVf/3iIaD4eotrL1gENglX/gKi3TfbG96gl+wFLdpEU3I4/jU0V46kwjlJJzJs6ljhmEBwMrftyNPuj7USt+X+Caps9sbXqGxT5Rf6RZ0hGTOsNkfJLLvmgcTDROi6h02EOwpu3qJ77VnjPNjaLoP1+2UUewNXuHif4yXjYbalgb0gC/ne5g8Qbi+spZzvlwGrKidbQUbod9KPkDjx4QAp3rM/pjFizQ4x37X2JG/PlRyL4hpLJOFe49DpgRvacZW52q8LpVeZPAYn32hgZ8+nUZXAsoR4amt9E8170y4QjKgIIjJ32bckdubQfJzRWEge6G6RFfn5n/4cq1Aw0BmMm6C4coObNgTZOGR6sm+sHytTq3gfEQiZUkUXF/dKP+I8G8NgbRMzLOYznIxdQbzKr13tgFWwekrTc3FW47nCIiIA7g+YfMaNPfyddAgmZjx6NIc1nDyAuzwbQBPq32Qm6vjYsMPzKO7Lw
 ljtTHoyV
 maof9PCS0tPTGV5W2s7I5oL8ygjo+Ddk8FskvyICdNAqJwcmQCf9HYYgysStE6p3q+RqywmkfgG5M/ePzsjijM03gLkgAHUg5EirCWGl0MNDdjSIfbv1vYORnxvUeuA/Fdq/7st8g/5WPkiUTQ8bF7AgUcx9KxVeuto9X4jFD7VaseSnOyK4FfhEqKApt4IageR23FKgGdNDmdjPN8eyyoj8/eA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For many reasons, debug_locks_off() is called to stop lock debuging
feature e.g. on panic().  dept should also stop it in the conditions.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/dept.h     | 2 ++
 kernel/dependency/dept.c | 6 ++++++
 lib/debug_locks.c        | 2 ++
 3 files changed, 10 insertions(+)

diff --git a/include/linux/dept.h b/include/linux/dept.h
index f3cc7566ddf2..236e57befb13 100644
--- a/include/linux/dept.h
+++ b/include/linux/dept.h
@@ -142,6 +142,7 @@ struct dept_ext_wgen {
 	unsigned int wgen;
 };
 
+void dept_stop_emerg(void);
 void dept_on(void);
 void dept_off(void);
 void dept_init(void);
@@ -194,6 +195,7 @@ struct dept_ext_wgen { };
 
 #define DEPT_MAP_INITIALIZER(n, k) { }
 
+#define dept_stop_emerg()				do { } while (0)
 #define dept_on()					do { } while (0)
 #define dept_off()					do { } while (0)
 #define dept_init()					do { } while (0)
diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
index 048348ea64d2..007e1bc7d201 100644
--- a/kernel/dependency/dept.c
+++ b/kernel/dependency/dept.c
@@ -187,6 +187,12 @@ static void dept_unlock(void)
 	arch_spin_unlock(&dept_spin);
 }
 
+void dept_stop_emerg(void)
+{
+	WRITE_ONCE(dept_stop, 1);
+}
+EXPORT_SYMBOL_GPL(dept_stop_emerg);
+
 enum bfs_ret {
 	BFS_CONTINUE,
 	BFS_DONE,
diff --git a/lib/debug_locks.c b/lib/debug_locks.c
index a75ee30b77cb..14a965914a8f 100644
--- a/lib/debug_locks.c
+++ b/lib/debug_locks.c
@@ -38,6 +38,8 @@ EXPORT_SYMBOL_GPL(debug_locks_silent);
  */
 int debug_locks_off(void)
 {
+	dept_stop_emerg();
+
 	if (debug_locks && __debug_locks_off()) {
 		if (!debug_locks_silent) {
 			console_verbose();
-- 
2.17.1


