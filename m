Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C0D3C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAC4B6B00CD; Mon,  6 Jul 2026 02:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E83906B00CE; Mon,  6 Jul 2026 02:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFCF36B00CF; Mon,  6 Jul 2026 02:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 93FF56B00CD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:20:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 18B0B1A02EB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:32 +0000 (UTC)
X-FDA: 84957352704.04.5A0EE6E
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2A3D020002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:20:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783318830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=GYcjzlTIOlZP3QZuzXKJbkX9X1t9OWfOQ/saEp/btr4=;
	b=YbMkMeSo0asoxTuwxFzBstLuDQzrS4Xng0VyzCAvPHdwe2jQHMtrU1kBdl9JrYIa8ddWCl
	ChA5GJO45p6rX5GPcr4FnHX53k8WnbRizC34uZ8EkC8JdQtGYOtAvfSIOQU7M67ipuw56g
	8tVjFxgi7IIdAGFKkP5AEt8OQ2JgGx8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf13.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783318830;
	b=oTEKqloNT79Tji2zaNKJXegXQl/o5rrNCLbCHNxt77ajOxo3teuJewHvrU/aXDFX6b7faX
	gxGghKgQaMlmuCvXHa22BeGALuq9tYxJ9rcUKFoKFUcV9UHOyz0kV1fdR89IlFXplrOI06
	VSO/g4PrXl74wa2vhNwF4kPdOX+1Y+E=
X-AuditID: a67dfc5b-c2dff70000001609-80-6a4b4900ffba
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
Subject: [PATCH v19 19/40] dept: apply timeout consideration to hashed-waitqueue wait
Date: Mon,  6 Jul 2026 15:19:07 +0900
Message-Id: <20260706061928.66713-20-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260706061928.66713-1-byungchul@sk.com>
References: <20260706061928.66713-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0xTdxjG+Z/zP5dW6o6V6MEtw3TxMowXiJc3cc767WzGRKPGxJlgM05G
	sVxSFIFkDTDcHDddt5YFh0KQWmlhtUREBR2oWIuQAlpLbVWUFQyXzcJApYMVyL793ud58uT9
	8LCk3EetYNWpx0VtqkqjoKVYOhpZtZ74YnfyJm9TDPieD1DgeJKPwVVvQTDx7ikDhjwExm49
	CR7XbRIM/QM0lL3OwzDrHyTANDBDwLDx77BmcCF4YCiioTK/hYKAt4UAY4UdQ/dwiACfUR8+
	ryyHc2VDBBjqbhIQ6o+DdssgA8MBPQ32vnsIrMUBEuyv3BS0eNdB1fcXMbQ3vSSg98ZvNBTb
	rlLwzDpLQY/FhaGj3YGh5kk3AQ2dD0n4eSyAoK9shIG81moM5jdlFLRXLgNbQTkD+kCQgau3
	TyEIXpzE8KjvJoJbp18Q8HvgDgk15lEK7FY3DU7/OANu/QUaOhudDDjfOwl4WTrKQLBihgJD
	6DQNtjeXaMgbf45g+m34qQlLLQ11/7qRUilYz1uRMFHzHSnUdIzQwvt/HtPC9XI/IxTc8jJC
	pf2EUHB3lBIazLFCdfNrQrDX/kgL9qCeEaqmh0jB526mhbGuLkZw/DqN9648LP0sUdSoM0Xt
	xs+PSpOmivaklzJZf9p+onJRP1WIJCzPbeYvGS+gQsTOs2l235xMc2t4j+cdOcdR3Eq+oSQQ
	jktZkuuN4YtNJXjOWMod5EODZ+Z7MLeKHzEFiTmWcVt5y9QQvdAfw1tsf8wXScJ6fahiPiPn
	tvBP/7qPFzLVEv5yc+wCR/OtZg8+i2SVKKIWydWpmSkqtWbzhqTsVHXWhq/TUuwovDnTt6Gv
	mlDQtb8NcSxSRMpA+WWynFJlZmSntCGeJRVRstVrdyfLZYmq7BxRm5agPaERM9rQhyxWLJfF
	T55MlHPfqI6Lx0QxXdT+7xKsZEUuSrk2qOvpyc9pjf3lesSnS6K3X5OT+YvO+d8+2Hasayrh
	THHk4UadWeKJ/6FBt52MXqs54gvtOnvQEaQ++PjoR1NFu8aVCZOO8Z26maxCX/knh7yuxTkH
	9jgWOZVZLyrw6h3x7ka9fEc/3F9cWn3KX1JXfzK35/KYdGeEq/dGx7N0nQJnJKniYklthuo/
	rFnXM28DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0hTcRTH+93XrqvVZRldtOegkh5WkHHKiKKgS6XUHxHUHzny0uabrSyD
	HnONVlrN0SY1tWW6QpeuaZbJaCjZw0TNMsuWSdMUNWNpY25zbUH/HD7nfL/ny/nj0Li4gYyh
	5VkneUWWNENCCQlhcqJ6XYjbl7bhpTERtJoL8KXfTUKPyknA1KSWgJJaKwVB0xMBaO23SHj1
	MZ+AzppqBP1TWgRevwkHTWOIgKC+VQCTvj4BGFQIQo5WBMYuPQ69nc9xsNarMPhtm6FgtMWD
	wDDgpqB4REXAhKUQwe0hkwBGXuyB8f4mEkKuHxh8/DOGwOKewcDtvIwgaEyHO+V14XXjLwr8
	7R04FBs6EdwdcOHgGfmGoL71KwLHg3wKBnWPceh2z4X3UxMUvDYUUDDeVYLBTxsF5nwHCV1v
	RxGUmvQIhj47MFDfq6XAWGonoPHbMwF0jQYw+GLUY1BtT4J+yxABbbpyLHxu2PVoIZiK1Vi4
	DGNgeNiEgc9SJdhRiTiv5jrBVdU1YJzmXZDirGVWxPmn9YibrFTjnEYXblvGJnDuUt1prrJt
	jOKmpz5QnOOPmeDelLNcxZVpjCtqX8c13nYJDuw8ItyWymfIc3nF+u0pQpm3ICnnuuDMoK2I
	vIgGyKuIpllmE2sJHbyKomiKWcX29vrwCEczy9i6a0Nhi5DGme6lbKHlGhER5jOH2MCPG2SE
	CWYFO2bxYBEWMZvZau8wFWGWWcpW25z/gqLC85pA6T+PmElg+yZeEjokNKNZVShanpWbKZVn
	JMQr02V5WfIz8cezM+0o/E2Wc4Gip2iye08zYmgkmSOCHXvTxKQ0V5mX2YxYGpdEi1bG7UsT
	i1KleWd5RfYxxakMXtmMYmlCslC09zCfImZOSE/y6Tyfwyv+qxgdFXMRmVJvGq6k7D+WsEys
	1QfvL99yILbivn9jh/mXN84ze/7yTZ9kOS3bD/U1FAziM78XqBn54vNNgcINu4QNvvb0J7vX
	ixXlR+MaX/QULZEld1doxd9L+k6rti7a3bGm4r3f9c4WE1/Wk+t2KY+aT6XEzltrtcc6c3x8
	yOZN1DnrPZ8khFIm3bgaVyilfwH0aI66SQMAAA==
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2A3D020002
X-Stat-Signature: 834ss49e36tdwr3gqgokk8p1zsthqfs4
X-HE-Tag: 1783318829-425912
X-HE-Meta: U2FsdGVkX1/0VcWC1ojmsfUPf+4x6sbeHX+IMg3/PQMsn+DpRPN/AS9tbhszETjhBKa1m+s3Uv6/NW3SaA0thz4qMHEw2rjgecgHVXJO+JYCSn8j0HZsnxKRPyEi8bXksZDeCdCGVjImT/1b00EEhqU3a2JMdTTvhA34ElSkg5gfOYh7iuNQrY2yMBYOV4f9gz5qEIWfmFfNhjwzKa6ParMOUU/SZpGw/y7PRg404Xkz3ekz71eh3rN+SOq5fodeGTiIovhBtY42EJKfmjYvKRbUHNlHlTNW+MdzBuyl7zVSJ2ulvigDZzcGVQRUPoWsroq5Vu3N06Dg+EkUWxRX4JfrHHtgkYQHSZR7uqsdapQ4PJlFY3wuRiDWjemox5l9is1vxihQUes2lrFhBLgVcv9hnPeh34b6fgVgLcmEQCBTEh/nAVN6oPwUL94qU4P+jx5reMwe0ejzTMp/b2F13T8aWmHLstTZ1X1XrN/55KJYGHODeg/NK/5aYpR3JLKzUtwsxAuru2QM8sd3ahXDTX6mnWn75EUmi/CfCugLUT6vv7L7hUWLpFlinryGKLiRigkl0CXoA3gFpnn1/qf6ho+Oh7YPkYCcJJaXiOgQFNtf5d879lvrZ8Tq0zqnRJqhxVdpB7L6YPseiN9xoOUluMUzaX1h2wr6yZTFfu3cGFH3p9GujTtzQGJZhsgKui4xXKOzC4k3Us7hHtGsFPWHDJXWRNVUt/F3beIhjru4j251mN4mW4VANn6UB6RSdBhkI1LnZA99k58arqcIUcKK4SplGruWG5FEjaNJKvKEcOCHRfeOKw0zReK/sq5mczO4MrLzD35aVmnGE/24Ww9KEIeXVF4j+D0Z8p+X+FYmTEdPeOMIEL4VYkcZv/Kq+KqL3v2Hi20mfzxs4aD5/+IZfXNYELP6cnWxelbLMSEr33BP/uxuLQoLKKkAjLoMi0gQKDK+eDjLbDzJ2yMyOmT
 4XEJ+41I
 NP8PFYFlY8bytdnAR6ocIs0d3Jaa6X4qWCMFjwhun9s7JqNZD9bgkyamqudJq42YeHsirPs3zZR0HC9cQnJSvTeuudBanWZrfQv+YMLDkaOC2nFsKCarDJIkGC0qTDVprOnfD7dLfScfA6VoST7pn45O+eE/U1ZITmUNgf4bhBkSvKP4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that CONFIG_DEPT_AGGRESSIVE_TIMEOUT_WAIT was introduced, apply the
consideration to hashed-waitqueue wait, assuming an input 'ret' in
___wait_var_event() macro is used as a timeout value.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/wait_bit.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/wait_bit.h b/include/linux/wait_bit.h
index 179a616ad245..9885ac4e1ded 100644
--- a/include/linux/wait_bit.h
+++ b/include/linux/wait_bit.h
@@ -258,7 +258,7 @@ extern wait_queue_head_t *__var_waitqueue(void *p);
 	struct wait_bit_queue_entry __wbq_entry;			\
 	long __ret = ret; /* explicit shadow */				\
 									\
-	sdt_might_sleep_start(NULL);					\
+	sdt_might_sleep_start_timeout(NULL, __ret);			\
 	init_wait_var_entry(&__wbq_entry, var,				\
 			    exclusive ? WQ_FLAG_EXCLUSIVE : 0);		\
 	for (;;) {							\
-- 
2.17.1


