Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E79E0CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96FFD8E0021; Thu,  2 Oct 2025 04:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91F478E001C; Thu,  2 Oct 2025 04:13:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74B008E0021; Thu,  2 Oct 2025 04:13:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5A18E001C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:13:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2EC8D1DBA9A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:53 +0000 (UTC)
X-FDA: 83952460746.05.9D366E6
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id 46D78A000D
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=UGkObL7oD/K2bAkUVhXxAs7YoFHUnPDSWQxkr9+NXKk=;
	b=35xUefSPxW2DBBjU1SD47I2fuW9RZmB59kZGUQz+AC4xDmnnf2NiwUKBttsrEJuoJvdLYN
	YlxgwEwvrsnwDLCj8mFdLShikMCrUWhzcbWaG1YjPJJa1ryZHsED4NcA/OU2eK0d3025u9
	crXwj5rgdqQwGuUr1JNwDdDVheM/wdY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392831; a=rsa-sha256;
	cv=none;
	b=wCIa+gpECCKuuAdErD3hrSNbhSwpP2nn8/1YLayUlQlBApPXlT0JJPYqSX5dc/t3Saq8Sq
	6RSYHqO5x0K59Cs7/2yMPFjbtswIAGNWH+cOR31YNo0RHalrJaoOCfNAeWP09k5mq1OR8v
	13D+yIBB7W77DSHtMAo+EPtzmPV9QyY=
X-AuditID: a67dfc5b-c45ff70000001609-cd-68de340f264e
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
Subject: [PATCH v17 20/47] dept: apply timeout consideration to swait
Date: Thu,  2 Oct 2025 17:12:20 +0900
Message-Id: <20251002081247.51255-21-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSe0hTcRQH8H73veXsNqOuKSQLiyTXgxUHkojo8YMSgiDoaZe8tOEj20yz
	CBWcWSapZaGzpWliU1M2jMqg0kw0nC6fPcwWWkpNYU1j6aip+N+H7/ly4MDhSGUuvZrTJSZL
	+kQxXsXIKbkroDyS13zRbs67HwhTnhwKhqdyEPgK37Lg8X5iocg5woBruImGf0M/CBiY/uWf
	3omDmc4uEkbzG0noGQkEl6OUgHumQgTPvj5nwfFzloAaazQU1TUR4K2ysGDq7KHhW3UJC7PO
	LfDY1UXDcFs2DdYPrQg8vU4Cis2fGcjxeRDcaGik4UvtPxraSx5R0PW8joaHAw4CnF8Haegu
	yKOhbuIBA9/7sglofGlE4K6cpqAt7xUBV8eaGLDW9jNw630ZA0WzOQzkGu9Q0Nj6x39SjYWB
	Ol8/2rUZW2xPCGx872NwrbkW4Zm/hQgb8/1q+TVJ4ixbKv471cfggs5I/KxkiMVl1gvYVh2B
	K16ME9hqucZgq7uQxeUzY+ShkGPyqFgpXpci6TftPC3X1o9koqTfzMW7rZV0BuqgryMZJ/Aa
	ofSuj120zWOZN8OvFwYHveScV/Bhgi3v+3yf5N+FCv2OjdcRxwXxe4W+7Ii5mOLDBbvbMV9X
	8NuFqqpOcmHlGqGm4dW8Zf68x/mOmrOS3yYYJ7OIhY5JJjjqQxccLLyuHqTykaIMLbEgpS4x
	JUHUxWvU2rRE3UX1mXMJVuR/kaors8efInf34WbEc0gVoOgOH9IqaTHFkJbQjASOVK1QnK7+
	rFUqYsW0S5L+XIz+QrxkaEYhHKVapdg6nRqr5M+KyVKcJCVJ+sUpwclWZ6CbERv2Fwfp7//I
	MmvOW4uTxX1vTBnB4e25lz9y5hcBarocdVfeXsmNK6NPpbS39Htdt82bsCG82BQ0mXmiSK5+
	utv+yXJmBw6TKZenp8YMrFz3oXIfbQ5lV21VRx09OdqxO3hUE/Xn4B7Lt9508zJvpF2ciLav
	TY85srTi5+sDKsqgFbdEkHqD+B/yumwFHgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0hTcRjG+5+7q9VhSR26UA2sGF0MLF660ZfoFHT5UAl281SnNpwzNrMM
	gs25Eiuz0ZRcF7M8iVtpW0aWCzMSbJktu0i5zFhmObNsy8zZmkZfXn7v8zy8PB9eBlfUkFMY
	jS5T1OsErZKSEbINy8zzJyS9UyeeNs2GV6Z6AsKhPALOVzkpyHOdI+HZDQeCjnAegoEhOw6W
	2igBw9ZGGkKDb2mIehoRFPmsODhvmTD4Uf2Hgp6H/QhsnQEKij+bCOiTTiIo6bLT8PnRGujt
	uEdC1P8Jg9c/gwikwB8MAvXHEQwXpcGlMjcFQ80tOBTbniG43OnHobs6Zt5qfIfAU5FDwcfC
	GhxaA+PhRbiPgibbCQp6fecx+FpNQWmOh4QLdisC85UqCoouuAiofX+XBl9PBIP2IisGDtd6
	6JC6CPAWlmGxfrHUzclgLzZjsdGNge36PQwGpUoanlxpJ0AyJoC9uZWEDxUlNEQ6F0G0NAMa
	HZ9o8J+2EXCjt4VcZUP8gKWA4CvdtzHe8nyY4p0XnYgf+m1FfKjcjPOWwtj6MNiH87nuQ3y5
	N0jxv8MvKd7zs5TgH5dx/Jnm+XxtiZ/mc++/oTctTZEt3ytqNVmifuHKVJm6KmBCB35Qh4sf
	XSWN6DGZj+IYjk3i3KFKeoQpdg7X1jaIj3A8O5Nzn+oazeCsdxr3yjcvHzHMRHY19/KYakQm
	2ATuab9vNC5nl3CS1Iz/OzmDc1TXj3JcTG/t9BIjrGAXc5a+XKwQyUrRmEoUr9FlpQsa7eIF
	hjR1tk5zeMGejHQXij2TdDRy5g4Kta5pQCyDlOPkvgS/WkEKWYbs9AbEMbgyXp5a0a5WyPcK
	2UdEfcYu/UGtaGhAUxlCOVm+LllMVbD7hUwxTRQPiPr/LsbETTGiWdszd+x+s/usqqDOaa/7
	fkc1vbzuwdVwRDcwWLct0dW0zMQGtDVKz69ZyoQTG7W1R3b2RJMuJU9aoRYc3qSUb6b8zby7
	bN9YVXr/tYHtOc5I0/WULTe1bRtqgtKQ8Vzil7FzPwoTVDOW1t8OusePWWs4ldxmxAq6DeYW
	zVYho0VJGNTCIhWuNwh/AZJ25gpIAwAA
X-CFilter-Loop: Reflected
X-Stat-Signature: hipwssw7w6x34p195u7ndstegcmekbz8
X-Rspam-User: 
X-Rspamd-Queue-Id: 46D78A000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392831-974979
X-HE-Meta: U2FsdGVkX1+jk8+Udex2GImumDebFoNuN46zynm7Lym5igDlYgxctF+ZlKJQpKiqmaARGHvoKchdtYcXB8N3riN0baZbgAl6DOI1Sq2jamI3PspMY90R1im4CfHDsAGOgCuQaJ3p9vkZKlhyEgNC0TZ8or3pKcewFYF7N+zBtPZ3zzgOgqqNMiG9w272z27Ub36KyMuJ7iBGVFirw9Tjsreapm86769CpxzMfBA97hHVdrirBAJLIrqYXfw/elsv8vVgcxUQpWJaT1dsPHpCaJ7XeHLmtQ+IzctpQsZHiT1xyrPBjntcvmhvxM61o1MCITaGURQbCyg81YWOSX6rO15DaVFplY0guJXhFqxl/ylcB70kg4+SY5jqp+zXxW/9vDOrNuQClJgsPmPmntJGuBl8laEf4kMq1a/k7iejxcQwk7qc52AtaBjh33L0mmkDq3ZEMQRKi5CUAsCjf7IS48S6HD9dLTWJANI9RgaltOFDLtjM/h+QZxATnKoAAeKOjG4mUTXOIwG498B4HlxgHvZsmwB2rGRSK8HMfHqgRy9HkMRP0jumoSXNtSQQsXsv/ai9VhNxRkVcU7N6eMQP4rv63dGsxYlAd6V8n0PlWYh1Ugldg2mjMppo++BiXqrKg4RSuhjyROduwci2F16tykDDIvE4i518GF2LyD62F/tDRbi/Qpyv6mdLpoHNzPDOCwiRRggE+aF+fOjbOr2KnRsd4Qo5XsFyOqr96O26EB6GMFv8r2sU2GV/YyLowowkVp9m9Lrz3Awj1I6BNT290+WlgscwxBKVvjB/Y0ze+RxlrmHIULi5pNUTVoxuB1WbeL5GzsMgpuUVR/lzoIrYQ23sW9I82vbVgDrOxaMQX0u7jJhCLI+m+YfiGp4d4JCPNa4tj+AqGPvahJEgYmDWXeMIErnh0U2sGq0e1BvvMxdh4DHab1zh/Ehiphn7cQgNxnUKUz3+wKuXfH7D6W/
 eEzufTdj
 oF+gtPQ7A3wzlu/gR4+V4NzV2njyLWrJ/JH3lKSUt5WIQyDIGTFDL24nPfIe8nMV3vwMXDOUwLImlqWI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that CONFIG_DEPT_AGGRESSIVE_TIMEOUT_WAIT was introduced, apply the
consideration to swait, assuming an input 'ret' in ___swait_event()
macro is used as a timeout value.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/swait.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/swait.h b/include/linux/swait.h
index 277ac74f61c3..233acdf55e9b 100644
--- a/include/linux/swait.h
+++ b/include/linux/swait.h
@@ -162,7 +162,7 @@ extern void finish_swait(struct swait_queue_head *q, struct swait_queue *wait);
 	struct swait_queue __wait;					\
 	long __ret = ret;						\
 									\
-	sdt_might_sleep_start(NULL);					\
+	sdt_might_sleep_start_timeout(NULL, __ret);			\
 	INIT_LIST_HEAD(&__wait.task_list);				\
 	for (;;) {							\
 		long __int = prepare_to_swait_event(&wq, &__wait, state);\
-- 
2.17.1


