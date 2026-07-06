Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6F41C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4249E6B00B2; Mon,  6 Jul 2026 02:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC086B00B3; Mon,  6 Jul 2026 02:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3A36B00B4; Mon,  6 Jul 2026 02:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06F156B00B2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:20:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D3201C7B21
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:16 +0000 (UTC)
X-FDA: 84957352032.12.DB46AE4
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id B610420007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=U/RO/rCZhBQMm46o/VpEBYnJf74iNuUDPNP4UUKJkvw=;
	b=zB1shTWtJl4nAXXwq4U03WmQKrNswWQEdax89xwxPqJKHpeFEGZzVzMJ0owPphZOfM3X4W
	NhRW38SXKRiZlrPqQD88hnGBCuFPIyCY7pzNk9CDOKVCTJ0ep8degCdbeDAnAGKCsoyTHX
	AyPFI7ZmtCeL7Lab8iQEqij7K+TQZhg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318815;
	b=yTvTt/j99IvjGqFHz6dJk41LJ9NQ+4j6YgVyme5FlmxXQyS6u+B8L0pfKlzUu81ryiZOjS
	UzGDdJ4coCs9BvHEPNg6kbYT3fe2Ev/UzUdDkOcWKmp+nx5utvGTltSy82RABIF26JSgm+
	VvnDSZOM7eruljU66JhPBBRf6QnRFes=
X-AuditID: a67dfc5b-c2dff70000001609-ab-6a4b48fefc23
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
Subject: [PATCH v19 12/40] dept: apply sdt_might_sleep_{start,end}() to waitqueue wait
Date: Mon,  6 Jul 2026 15:19:00 +0900
Message-Id: <20260706061928.66713-13-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSXUxTdxjG/Z/vNlaPHQtHZ2RWcOrQgbrlXaaGux30QhKDGr3QbpxIsbSu
	FRQSM3AZIqNQyWBoQQpCwcqXraCgJBW2SRQ6GQMblI3PKpaP0ZR2FpC1GO9+eZ48v7wXL4NL
	B8h1jEJ1VtCo5EoZJSbEUysrtq+IPZAUlTHEwqLhLg3ZlqskdD67SIBv3oBDYSaCop4CHFwd
	bgSFw2MUzJhyEYzZLiFYLDoNZRVWClxF/1JQPjyIg3tiCMG4vgmH3rFVMN1IQU+XK6AotRDQ
	MtRKwz8mJwGGX15hUFh3H4OuGy8IWBiOhiWjGlzOAgo8fw1jkN06R0B5ViUB2YseBH/XLpGQ
	YfCR8NT2hISGlw4Mnnfn0/BHa10gu6IjwaEfR1A3XRE4xmvC4U+bEQNnXxYGN8uqEbgrvQQ8
	0tkwqPJM49BtsJPwa8NdDBqcHThU1UyRYKntp6BjbhKDx/7HGIzkTdHgLn1LgiEzD0HTbz4a
	GmerKZj/r4SCPPvX4LllpqBusR/FxPC112sR76n6Aed/1AfIP9dH8W1eI8FXXvZjfMu1QZo3
	WlJ4a802/saDCYwfcO3lLebLFG9xF9B8+fwrnJ+222m+s3ieiNtwTLwnQVAqUgXNZ/tOihO7
	Bu/QZ/JE5+2jsygD6egcJGI4djdX8lZPvGdH/gwKMsV+wjkcb/Agh7Afc1adk8xBYgZne8O4
	XJNuefABe5jLGrgTKBiGYCO4sko2iBL2C86t/+qdMoy71Whb1ogCcf1CKRZkKfs593zmERFU
	cqxVxJluN+PvBmu5hzUOQo8kRrTCjKQKVWqyXKHcvSMxTaU4v+NbdbIFBT7OdGHh+D3kfnqo
	HbEMkq2UQMz+JCkpT9WmJbcjjsFlIZLNWw4kSSUJ8rR0QaM+oUlRCtp29BFDyEIlO73nEqTs
	KflZ4bQgnBE071uMEa3LQKfiw15c+XKyqOKqP+r3tuKR9eZPRx+a4veOm8uVufHq/qh6b1rk
	T4PW0e9DzRvqfcdVpKL59pqDO5Hum8lw0QktvUnFrM5iVZKlnq3qiPCL6ZPH9nz47Eh+dNOu
	FizyO79m63oyLjyueW3skbYcxevi3s6fj85tjt3kqu72bXw9mykjtIny6G24Riv/H3RHocxt
	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0xTdxTH97v39t7bQuGm4LhxyTDNRKIRn7gTWRaWLHJRt7CYsGWZkUZu
	pLzEFpksLlpqt8IolJq2kYowHs1SmCIUELVKIIIvlMo2CVDqo9YhuCoWDI/C2pn9c/I53+85
	35w/Do1LOgWraXl+Ia/Il+VKSREh+jJJvXGZ25O9eUAnBK3mBIy7PQL4S9VDwKxfS8DZCy0k
	BCxdFGjbzgjg5sMSAobONyNwz2oRvF204KDpXiEgYOinwD8/RoFRhWDF0Y/A5DTgMDJ0HYcW
	uwqDN63LJEz1zSAwPvaQYJ5UEeCzliOo9loomLyRAi/dVwSw4nqOwcO5aQRWzzIGnp6fEQRM
	OVBb3x5cN70iYXHwPg5m4xCCXx+7cJiZfITA3j+BwPFbCQnP9B04DHsi4I9ZHwm3jL+Q8NJ5
	FoN/WkmoK3EIwHl3CkGNxYDAO+rAQN1wgQRTTRsB3Y8uU+CcWsJg3GTAoLntC3BbvQTc0ddj
	wXODUxdjwGJWY8HyNwbG369gMG+1UclNiHurqSA4W3snxmkeBEiu5VwL4hYXDIjzN6lxTqMP
	tn3TPpw71f4913RnmuQWZv8kOcdcHcHdrme5xtIFjKsa3Mh1V7uotM++FX2SyefKi3jFpk8z
	RFl3XXaqoEJ47N7T1+gk0lFlSEizzHZ2pNKHQkwy69iRkXk8xNHMGrZd5xWUIRGNM8OxbLlV
	R4SMKCad/WnUHjRommDWsrWNTAjFzA52Rp/0LjKWbW7t+S9GGJTPL9VgIZYwieyYb4DQI1Ed
	es+GouX5RXkyeW5igjInqzhffizh4OG8NhT8JuuPS1WXkH84pRcxNJKGiyF5d7ZEICtSFuf1
	IpbGpdHiuPg92RJxpqz4B15x+IDiaC6v7EUf0IQ0Rrz7az5DwhySFfI5PF/AK/53MVq4+iRa
	9eRDvy3zuWtz2c6lcGV4dUPa1vUdX2X26aM+H9JUHgn4o+bsumGv5cDEtvHIsHLbjjcVuu9e
	f9zVnebdl67Nu2yNHABzQtUGg60xdUwtbghzZkf4vmlN1lwrLVxQRT2JH9xbUHg6KS3ihTv1
	RZj51JaP3t+fHKeOb95ViZdfPX5USiizZFvW4wql7F8jiLxcSQMAAA==
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B610420007
X-Stat-Signature: 4n13tbhujkipgm668dfo8qwhsoqibkwt
X-HE-Tag: 1783318814-280754
X-HE-Meta: U2FsdGVkX1+xP8W/vVWoS9K5RsJuxfia+6aiUKEjVxKqoZWj9dw44iTXzCT7f4s31NTTCqYq+IPZHBzxbftH7QXR7yw9bEF53ASJ+eC0/zBy6qSonKAIsyxzZk9GT9/Vv9a9Z/3veoidJB2/1V0wp7vaKFENH5Nj+YcYXE3kdvJcw/2N/X1bZqcfm+eQO0XWFzJ6ranCHP876ym9SO7mfzJu3BA/gYFxYkwDAAlPbQjoTRTvjAFal3yP6h5W6RbFDdNMO4YB9VAB+My1bwb2oTaWU6Xuzk3zVzik23Blhtzj1G4Kek6ARKtThwm7d5hFmMbyDiw5yfYE3ay00fBXqwzKrjmn5BkaFM40DGqOsHuxqBHk1ItIOOE7Vx7qIlE/SZWvmPtVERZhWJGgGuf23JxD5n8gaZ0llLWyhaDTqmmCi8LxOADX9/DyTZIOxddj1RoMtJuxLNB8Ef5aRnrB2XiprjLF1h/vYzuiOUyBOXhEdMAxpxPCVPwi+1RWNxycbYx7o3YZbdIE38nXvBXsVr8zjP3cJE7+2KbDoh4cklAOxGREvVFFcvgMUizcy7nV3UMRt17WRQw2se10fqBRz03b2n2RwDSc2BG1kJWLbblgdRZ1iL+Rqtpo+nBlla9EN7UKUHBq+UG86rBhdyeMoQ+QuwG0qiyndZVA7KhwDVqINHkDz9ccmIDmjp2LTxlrqqaPV6kt94RJ3yzLid17eRD756ssjz/ZVMbBAF+wkfmnI2awjoTn0OYbUJCeIVOiPehKmhI48WE+CCCWuCQ0xpzMIiQDZs4lSVmTFZ4M3YQQ867emcx5DqcHevSeE6fkluUwcOExozPxFBKv/tDWlMg24JZNKy9FOgaNeYfdPYTCiKRbdu1CnpX7XHjQyfO8itwXnsZ3vTkQ2Drh0v9i5fIhWimu5cplGCF0J4m3bUGQDpnisS3WK8nvgKtcSL730Meg8kUekZosRiXTkVd
 Wev/HgCc
 hBNizFSO2NKPQHdZPsly+ce7hwI7f+NMeEf1ZXj5pV8hJpDliijrWSE88KruLSFmDh6+wMY61PY7E841BEFC+N7K3Be50IY9iiUM5eLYXpvuQbywzzhhPpOd5lDSrBy2u9RRhRee8a+oosAjKH9O+zXvoe83rTh/HDFzxsINUAZpCL3oNTjhcP/pUF4oI4HdYCcG4k/S/QGElGvAg+xsxBsQxSCByjL+6uLvExyCMQd4lpzTX+5gIA9ja2+7GRg/AsRjv
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
index dce055e6add3..c8f8b44060fb 100644
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


