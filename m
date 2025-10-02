Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5534CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10B328E0024; Thu,  2 Oct 2025 04:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E0958E0022; Thu,  2 Oct 2025 04:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8DBA8E0023; Thu,  2 Oct 2025 04:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C49D88E0022
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:13:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9AA5FB8ACD
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:57 +0000 (UTC)
X-FDA: 83952460914.29.4A3069F
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id BF74CA0008
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=JUiqI60Iw8lVfta7nu3ww1/OLUvt8cdoB6792EPNA08=;
	b=RUBXjsahtfOt17QNY6aIC7yIgBefJocVoNuHkqleRCD1divyCCUS+yjS5lo2oTmVH4U8p8
	HiHQXRG/pMX2AY2elDjkZksGAkzvU9ZiT3vJv5xT9qgnCN7CLkDtKzuNhBWki5nfJ6KwZZ
	xaqqQAFiF7ABljU3KhfjqDhxbCw5lTQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392836; a=rsa-sha256;
	cv=none;
	b=dREILe/g+z8cyYgg4k6BUOSIZDxlia+bsXbhYzIpVaIvkOiaqjVECSDFSBUx4lF/F9Ucbh
	Y/oSIqa/rlywu85fP91DNKhj5o7+msDjQyo8wjiqJg+H/eeYd9FlrYIivDWY8/qymERfEk
	oepcx6iuQh6pJTKviNkbJZhwBGgkrw4=
X-AuditID: a67dfc5b-c2dff70000001609-ee-68de340feceb
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
Subject: [PATCH v17 21/47] dept: apply timeout consideration to waitqueue wait
Date: Thu,  2 Oct 2025 17:12:21 +0900
Message-Id: <20251002081247.51255-22-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSbUxTdxTG/d/7v/e2nTV3HZE7ZyJpQkjw3TBzMrdl2ZfdLzNLluwDJmq1
	N2u1gLYKVF3GSzs6N5l0g2aUTV6EVFp5aUWlAvIyq6wSW8FSlReZ2EKQaYBKZIzulm1fTn7n
	Oc95zpcjIRUhaoNEm31C0GerdEpahmWza2u2vpkxptnxmIZQYTeG2IIFg8X9MwWBJieC8ZgF
	gbk9jmHh9WMG4p0+BBVBKwnzLSs0zPTNIbBNF2KYHb9BQXw0SkDD5AoBk90lCC7Uemj4a+Ae
	CVMtYnvFN4ag01FEw7PzbSQMTq6D/vLvaJgNVhHwZwsNv9itCIrrmmlof+JlIDizTMBIhZUA
	p/tTGG+IYKhoTQa7rZgQyxQB5ZdviOcKUsE+MEjBH45KBpYndkK8Ogd8zigDoz+UY+gfC1Ew
	E7HScK3gCQPuh7cQLAxNEOD6PkKCxRvD4H4qWjofbYaaby5i6OjsxzDoraJhzBWnoDkaJsDv
	uyMmVV7CcM97mYL64SABnoG7JATKzlEfqflFcynmGz1XCd58/2+ad/3qQvxCfTHJ9z1/QfIm
	Tx5f739O80uxBzT/ey3Hlw1s5dsrRxm+2n2SN/02S/EeRzpf1zFNfLY9U/a+WtBpcwX99g8P
	yjQB2xR5rI3JtztrmQJkos8iqYRjM7jhWJA4iySrbI5/kZBpNo0Lh1+TCU5iUzjPuQiVYJL1
	b+RCwS0Jfovdy02WxlZjMJvK+UMVRILl7G7OtBRm/o3fxDlbuldzpKI+OOHHCVaw73LmFybR
	LxM9TinXVtP138LbXI8jjM8jeTVa04gU2uzcLJVWl7FNY8zW5m87nJPlRuK3NXy1vO86mgt8
	3otYCVKulQdSRzUKSpVrMGb1Ik5CKpPkBx0jGoVcrTKeEvQ5B/QndYKhF70jwcpk+a5XeWoF
	+6XqhHBUEI4J+v+nhES6oQAdSTn1aDGZ2980/snDFev0lmvDeQ51z5GXOunSB/Ono3ct6/tS
	Wu9XnhmyFf1Y1r0psOfSdNpPpR2tdE3DoRSDd4/RNh+bicyR64eSGl8Vur5Nq2suORrNtB9Y
	cztk6C38eNdx7r2RN7q+dtzMTM+/rulZ3FtctbHr5SGhxFndVOQzKrFBo9qZTuoNqn8Ac/ga
	U2kDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSe0xTZxQAcL97b797aazedExvUNQ0IRqjMDNYTnQa/zDziwY1RjFZ4qTR
	W9rxXMuYbFks0mqjm2JjS6SCBUPD2k5YC8uAlfDIyLaOQMUhKhUwHUIA8UFRXnatif+c/M4j
	J+ePw9HyJkkCp8krFLV5yhwFljLSQ7tKt69Ofaz+6ILzYxgoaWcgPGti4Ga9G4PJc0MCfXdc
	CIbDJgSvF200GJsjDCybu1mYnX/EQsTXjcAaMNPgbiyh4FXDWwyTXS8RWEZDGMonShiYcfyA
	oGLMxsLEH/therhVApHgUwruz00hcITeUhBqv4hg2ZoNt2q8GBZ7emkot/QhqB4N0jDeEG02
	dj9G4Ks7j+G/siYa+kOr4F54BsNflssYpgM3KXjWgMF+3ieBSpsZQentegzWSg8DzSMtLAQm
	lygYspopcHnSYdgxxoC/rIaK3hed+mUt2MpLqWgYp8DycysF8w4nC//cHmLAoU8CW0+/BJ7U
	VbCwNLoDIvZ86HY9ZSF41cLAneleyV4LIq+NVxji9P5KEePdZUzcVW5EFhfMiMzWltLEWBZN
	u6ZmaGLwfkNq/VOYLIT/xcQ3Z2fI3zUCudaznTRXBFliaHvIHtn5ufTTM2KOpkjUpuzJlKr7
	ysfpgib2rM1Vw+qRAV9CHCfwqYIxknEJxXGY3ywMDs7TMcfzmwTvj2OSmGnev14YCGyL+QP+
	kBC6EsYxM3yS4B+wUjHL+E8Ew8IgG7PAbxRcDe3v9sRF6/2jfiZmOZ8mGGcMVBmS2tEKJ4rX
	5BXlKjU5acm6bHVxnuZs8un8XA+KPpPj+6Vrv6HZ/v2diOeQYqUskBRUyyXKIl1xbicSOFoR
	L8usG1LLZWeUxd+K2vxT2q9zRF0nWscxirWyAyfETDmfpSwUs0WxQNS+71JcXIIejVSrPsMr
	H6hedOih+uizLwq+3L3meJtqzpK4oUPRtSj+mdWjYg+e3JbB6WQ+cnTnljeXPe6f2us7r7ec
	aP1uNaieHG9cvpDaWzUyaD+Xvuv3FKV5T1Jl8+FkF7E+T5xY410VkrGJRxKcX+07mGLyX0xX
	TfL6Y6evmj7cwD9PuD6vYHRq5Y6ttFan/B8Rux29SAMAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: zweec8eo3mxea4ne5sdxq4y9z5qjwrre
X-Rspam-User: 
X-Rspamd-Queue-Id: BF74CA0008
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392835-995057
X-HE-Meta: U2FsdGVkX1+ot8kZ+u3J522aGmAubCLh0iNzzlXQHlsfW+PXo+BWGVUX/3Kq6u+57NWZ8/e8xm2Z4R/sfxt9x7cC2AIHnH4XAuluaL2naQY+SgxOnmrasj2j1junKLa8b3wG27tVVjo5LRxEQiiJc1P5e/81TIA8EAXw38uY/lw+cME7ywDhf/hFN4TvR2+EPay9SfLMODUCyxx+SLs6OLObB4gkf/SW1ytzG7XdBQmK7Idoaf0mOUYjbUtbo6zpgdy5lryclUD1QPCfKDX14m03YWvO8natmly3C4UVwW5ilFsqhcdzZeBnAnEfO+7RNvR2piKeISEiBbZT2NDyIr+Oy086tZb01uhJvFm0wDJnFut2+V0b/CUa3QuttOfUhpNtLywC0FItAEeO8ZI+MUNnw0EM9lx+l9NYeOLcA5UHUHMb2+SWPyxvaex6KHZgR3FnXsCn+a5+rfIPajTrjvnC6jPw6FqAHhszYdU5fuDy9qu/pHhqZG7FuRMjf88Soe8mhtd8TNsB86VpOYGRSP5cwJuN/bEut4ijdYQb8lBinX6c1EfW4NwBN33js3BV8ElwhFOMSKCWCSWqfYARPLAa+njSUpNJaFoYkYtvllHix1tixa6ZpRVaygpzbg3UbtjFjDs59Ee+yEJ3cQUjX8Yq+e9PWnmqcKUYdbqDqU5UbG0pFtMbFEwi/y9y2FxrmVeUlkTCz9xEiUWqaAzTExx5UxDTwfJljaU8QFSBgCmAqmgSs3cNmab3+WOPHrkedP3VKTrxhZCKjf9UoctOcgtoNja2dtdtoOVf+fvDc6sPfw51vy6e0YCVhih8GdOJUjR0LLs0iRb7IDMtPJvINK4tB1/qpxPTBkacahJMS/uSrwmmgGf/pd6m9tUvliHZEHwUdrfqv8jrqCjUsg0luYmRy/oErI1b9QmmOpC+foi1GyFXL0y1xMB09EbTh/6jFBFV6sTNoxg600s05Mj
 vGVol1Jq
 8bG6W
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that CONFIG_DEPT_AGGRESSIVE_TIMEOUT_WAIT was introduced, apply the
consideration to waitqueue wait, assuming an input 'ret' in
___wait_event() macro is used as a timeout value.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/wait.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 65dd50f25e54..902a2e5381db 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -306,7 +306,7 @@ extern void init_wait_entry(struct wait_queue_entry *wq_entry, int flags);
 	struct wait_queue_entry __wq_entry;					\
 	long __ret = ret;	/* explicit shadow */				\
 										\
-	sdt_might_sleep_start(NULL);						\
+	sdt_might_sleep_start_timeout(NULL, __ret);				\
 	init_wait_entry(&__wq_entry, exclusive ? WQ_FLAG_EXCLUSIVE : 0);	\
 	for (;;) {								\
 		long __int = prepare_to_wait_event(&wq_head, &__wq_entry, state);\
-- 
2.17.1


