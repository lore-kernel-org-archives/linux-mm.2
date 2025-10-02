Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49405CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 000668E002D; Thu,  2 Oct 2025 04:14:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3588E0031; Thu,  2 Oct 2025 04:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 947908E002D; Thu,  2 Oct 2025 04:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 704608E002D
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:14:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32261C02B2
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:21 +0000 (UTC)
X-FDA: 83952461922.21.629A87A
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf07.hostedemail.com (Postfix) with ESMTP id 99E9A40006
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=r8zak7aipRIB37uUTpP1Cxu2EcuPdiK57odtSWP76d0=;
	b=tfBp38G4MpnXBvisITqxz05hR8yolPUK14bxK/lGdE6OXxeLv3GYbDEQ1I6/b5jugm35zG
	dVWJA6mf9Ro1JVz0km8CIPxsufULuBscm4k1M/Iq93QUuSZxCHGVkzMaQv/BdoGU71U7LF
	QBUbsmuK11WuORYpMe72gCGRoOMVBhU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392859; a=rsa-sha256;
	cv=none;
	b=TKuS8p4J3D3lVxI+1GH0PNLloy3F48PV3coubalPskWzYpIckQck9UYf07oFfsXoRpzxMs
	srktWp2Jd25aRQJXoTGv2ncKWtOr0lQZ2E5jAwYprioMZD2j3Yomwvw9iaFSY/mUz1nDp5
	61mhrgRWG2qSVItQ7FVjDBUR/OrNP5I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c2dff70000001609-a1-68de341392f4
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
Subject: [PATCH v17 34/47] dept: make dept stop from working on debug_locks_off()
Date: Thu,  2 Oct 2025 17:12:34 +0900
Message-Id: <20251002081247.51255-35-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTZxTHfe597m2pNrt2LFzRRG1GSHDTjeE8ySbBL3rjB98Tk+3DaOyN
	bYSi5X2LS4VWGlCs1dLIi+PFQdU6a6tmoF2AQaN02DIQqha0GxQJAhm2kIFYW4xfTn7nd/7n
	fDpCUjJEJQqVqjxerZJlSWkRFk2tavg8Pm1E8YXz1koYPNWOIRzSY6i9aaVBb79EwfxiDQm6
	1giGJaNLABGnC0FVn5GE17a3NEz+OYvAFBilYaJ7FwzNvUKwVHUMfml00LDY6yHBbPIieGkr
	Q3DbNYLAaSmhYcxwh4SB8AwND00VNEz11RIwbaOhvsRJQeuLNgH4q4wEPG8OYnAbGgkwT9BQ
	dSsBasylRLS8JMB04x4BfzX5MTRrkqCmt5+CSH0OuK6PC2D4nAmD/Uk3gtBAgADrmSAJ9n8H
	KXA+3QQNp69g0C+FEIxYIxRoauYp8La7Kbg57iPA7XqA4WH1VQyethsUBF74KJirXAve82cp
	8BnGEFyYDiJoDs8IwPKfmYLg49NEhpyb11Vi7prjLsFZL1sRt7hgRFzo11KS0xmirdZRyC2E
	H9NcTyPLtVYPCzjtH08FXL09n9N2TVGcw5LCNd2fILiG2TC1b8t3om/lfJaygFdvSc8UKdor
	WgTHA+Iiv2MUa1DdynIUJ2SZNLbl7x6yHAmX+WLvzzFNM8msz/c/GeN4ZgPrOBukYkwy7nXs
	YN9nMf6Y2c+W6FqWM5hJYrv0/9AxFjNfs89G6/D78+vZ67b25Uxc1PcH3MtewmxldTNaohyJ
	ohlzHGvS3CPeL6xhOyw+bEDierTiGpIoVQXZMmVW2mZFsUpZtPlITrYdRd+t+eSb739Hs96D
	nYgRIukqsTdpWCGhZAW5xdmdiBWS0nhxpsWvkIjlsuIfeXXOD+r8LD63E60VYmmCOHWuUC5h
	jsry+GM8f5xXf5gSwrhEDUpmkmYGPvkpOW9Est9zIqQtO9S5STMutxaVlQ7cmf4toydz267B
	HZ/unDYu7hjaaUxJqI5M+vVluoz8gkdjS4lNqZMrJrr31bX2V+pONqh7nl2S1c4t+K+6u7Zv
	LHxecWXIc7Dtq/SOB75Sked1R7rKlnpgdTW595sm9e7+j/a8PbxOinMVsi9TSHWu7B2T/5/+
	agMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0hTYRjHe895z8XV6rCkDhkVAwvCLoLVg0VlBDsURX0pKCiXHdrQTdnM
	MjK8jUZXG82lyzSlZc5sbRqZLIapUMtq2Y3cssnSIk0qp3hvE/ry8Hv+/9+H58PDkrImagmr
	1maLOq0yQ05LsGTv5qI1C5O+qNa7nAg+FHgwhIeNGG4+qKfB6Cyj4E2DHUFP2IhgdMJKgqF5
	BsOUqYOB4bFuBmbcHQhKfSYS6hsLCPjrmKbh57M/CMzBEA2WHwUYhmyXEJT3WRn40a6AwZ4W
	CmYC/QR8HBlAYAtNExDynEcwVZoOldUuGiY6X5NgMb9BcDsYIOG7I1I2dnxB4K4tpOFbSRMJ
	XaH58C48RMNz80UaBn03CfjloKGq0E1BhdWEoKjmAQ2lFU4MzV+fMOD7OUmAv9REgN25B3ps
	fRi8JdVE5L6I9XAxWC1FRGR8J8B8v4WAMVsdAy9r/Bhs+fFg7eyioLe2nIHJYCLMVGVCh72f
	gcBVM4aGwdfUdjMSRg1XsFDnekQIhrdTtFB/qx4JE+MmJAzfKSIFQ0lkfTYwRArFrlPCHe8A
	LYyH39OCe6QKCy+qeeFa5xqhuTzACMVPPzP7kg9JthwXM9Q5om7d1lSJynPxLpMVlJ72u0I4
	H1XMvYBYlueS+Oud5y6gGJbmVvGfPo2RUY7lVvCuy31UlEnOu5T/4EuI8kJuP19ouDvrYC6e
	bzP20lGWchv57lAFjjLPLeftDs+sExPJu4Le2VzGbeANQ8VECZJUoTl1KFatzdEo1Rkb1urT
	Vbla9em1aZkaJ4o8ky1v8tpjNNylaEUci+TzpL74gEpGKXP0uZpWxLOkPFaaWutXyaTHlbln
	RF3mUd3JDFHfiuJYLF8s3XVQTJVxJ5TZYrooZom6/y3BxizJR0nSrBtUYtmxmuq9Z/ms5MxN
	Sbf+7Fi5uXLr/jafc/e6e764w+N2g/Js3rJ34ZY0rX2uX73AO7LzkC/71cdFB47UNDnyfo+2
	pban9bu6yZ0ewz5NwhNLXErOHk69zd/ubhKTKXNjg+bF1GBIobAqDqeEUhIsKyrxdG/ZSd08
	4xY51quUiatJnV75DxGTf51IAwAA
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 99E9A40006
X-Stat-Signature: weybnh44q5cos1y4pc6whmjzif77jxw5
X-Rspam-User: 
X-HE-Tag: 1759392858-805022
X-HE-Meta: U2FsdGVkX19i9naYogpteVkpQnk6wP4BUTWWQfn12Nqh1a9URnq4lgugEZyhn7W19mjyk+6T1dWEnsVbNL6trCHtbDz1IAseWFKuYTaxpa9ggBN+picEdfTz2kx8HkjEhO/+WRKxY+skFfUU/yk7CeHv7NRfksjEubwHHBC546Y2X394E6osuFXqmC+UIK7x2YqpX0Mo8pDcjR+wrbkiQH7603wSJb3wEJYxliIEQUYOh8t+9xmdi6VifKetjNMI0xKdPP3wb6IopU+cn4kqZB4gaHyJGsU44dZ7PIAIBZ64uEla/azNGhezpzkiukVFNx77EZUWZ+H52tpKuN4hlbkfHZT5rWLSfFTP95PHnJQVVcgmoH2moMwzEnewiq3EJhotfPPiGuKsOnkZtj093kMdon1Tt4UWJG1MrGWIKOC36nLUavXcbKtKLa+USJVdYqh1/5mxGFpB/NHWljgUUZJrpYo6DopXekcerJU9pM1KGcedLy+78Y671ZEJrcRIxVhB8V/qKrj/NXi9N01oiJ1EvuOQrhJOTzRUtwgge0NeC8P81xyf0RSSPOR+xUN03wsgKjJye84lbcF3u4ONBfOQseFV7oyMoBj6uNGWR4EpdOUFZubnvFa/hoaLtjSR47FKxWiOVImsdTaDhk4uB1+fhUH3RTQsTz+g1c+jGCg+Hfv9qf00esgLEW3FiM37EVm7SctV/skQKwL4ET4uWkhCCqVL9rLGYJZEzuASn79aUIdFC7XCo4G8fFVGSmrN6twAvCRu7k+Su7EY7n1TbCJqNZjSzzu68bUfmsXnYgdFwwmdJ9raeiKkbMxycRPppB7p+aO/zuLLzAIkowTsPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 8b4d97fc4627..b164f74e86e5 100644
--- a/include/linux/dept.h
+++ b/include/linux/dept.h
@@ -390,6 +390,7 @@ struct dept_ext_wgen {
 	unsigned int wgen;
 };
 
+extern void dept_stop_emerg(void);
 extern void dept_on(void);
 extern void dept_off(void);
 extern void dept_init(void);
@@ -442,6 +443,7 @@ struct dept_ext_wgen { };
 
 #define DEPT_MAP_INITIALIZER(n, k) { }
 
+#define dept_stop_emerg()				do { } while (0)
 #define dept_on()					do { } while (0)
 #define dept_off()					do { } while (0)
 #define dept_init()					do { } while (0)
diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
index a0eb4b108de0..1de61306418b 100644
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


