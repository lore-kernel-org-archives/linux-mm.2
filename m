Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA4EFCAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80E578E0008; Thu,  2 Oct 2025 04:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E69F8E0007; Thu,  2 Oct 2025 04:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE8F8E0008; Thu,  2 Oct 2025 04:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 572B38E0007
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:13:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10579C03AC
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:37 +0000 (UTC)
X-FDA: 83952460074.27.C2BBCE9
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id 30913A0011
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:13:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=MKDKMytXRhwPdHk0hD4DPd/rcYOaEhPBKBI2SKj3rgE=;
	b=iDWUfcl73u8WYV58YSECL5Nnjn185CDdFtJWdZty+St/gHynD6ZqvdtkDE29euV+5emf2p
	LDcdJKCCNTqTX1qF9UBZnNLfO6IVYkvdI3wLtZ9xC/BdxosXveZtZHt3OaN+hsFBNPlqFk
	i4hlqhzNg33NBHuCPClAHbIWtrYCHEA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392815; a=rsa-sha256;
	cv=none;
	b=Cc5GMd8ABIYC2As060/870hsK878VlEroOwL6Ro1Eu70E628uZEP4lV59DsgLgQdRJAuqt
	uPiZIAm1WMIyemPGxcLOa6Gw4vur+HSeFwZgKqWAMqRkYYSnjcfgOClEraz/6uTHU4576k
	PN5bDEwF5/UWKGFe7zkEgaeEu8O4jIQ=
X-AuditID: a67dfc5b-c45ff70000001609-d0-68de340e4fa9
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
Subject: [PATCH v17 13/47] dept: apply sdt_might_sleep_{start,end}() to wait_for_completion()/complete()
Date: Thu,  2 Oct 2025 17:12:13 +0900
Message-Id: <20251002081247.51255-14-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251002081247.51255-1-byungchul@sk.com>
References: <20251002081247.51255-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSa0hTYRgH8N5z3nM2h7PTijppYawkk5wWFg+UERF0oAIrpKgPOvLQVt7Y
	zLILrXBd1EStZWqZZshIo3FsVLPC1sWcl6aWzvJa5KVykuWWadZm+e3H/3n483x4xKQsm/IX
	qxNTeE2iMl5OS7Bk2Lc01C+iWxVeYJZD2+kaDOeFAgr0D/9guNKcR8J30xQNwz3VFOQb7AgG
	TecQ3HvZjeBTjpmEN2MjNNQZMmlwmmi4cl3A0PxlkoAKYTv0lPdjyB+iwXCnmoCGsk4MRY2t
	FHwwFoqgp/YsBfd1vSIQOl4g+PGmj4DzljEMBcWdNLRartHQXfmHAl2RmwJ7TT0FLRV2DK8t
	dyjo63VQcMnZj8D4LZ8CU7qnb/SWC8O5wWoaBgqvE/Bs7CsBtl82AvRZ4yIwv3CLYOKnp/Sn
	6SMFzpwf1MZwzq3Pxpy+5TfNVRZXIu7Z1xGSs91kuYeFXSKuRDjMVRlDuLJHQwQn3L5Ac8Jo
	nohzNjWJuFKdgeSK63ZwPZm1BPd+6iMZFbBXsj6Oj1en8pqwDbES1YQ1g0h+POfo4Fs70qEq
	vwzkI2aZCNZc6qBnLHRUkl7TzHLW4Rif9jxmCVt1sZ/ymmTqF7FtzSu9nsuo2OzLudhrzASx
	A5ZXIq+lzFq2fCIL/+sMZCtMNdM9Pp68ta9+Opcxa1j9SDqRgSSenQoftt1Y9v+IhexTowPn
	IGkJmnUbydSJqQlKdXyEQpWWqD6q2J+UICDPl5SfnNz3AI3ad1kRI0ZyX6k9qEslo5Sp2rQE
	K2LFpHyeNNbYqZJJ45Rpx3hNUozmcDyvtaIAMZYvkK52HYmTMQeUKfwhnk/mNTNTQuzjr0Mm
	t3Ghc8h/SWhIdCR5t3ZYtWXTmafzbTgg2LItebxsX+axzYGWyNBtnyfDWtzfjb8ZV/9kr2vn
	k8W6qLzGpnWKd11TkYqU58MDjcEu89Xcre3LM3c7FTF7ruIgP7w/xJp2YaLj1LIPtZ3h2rfW
	FceRwXXiRvTSTwcbgoJnS2wusRxrVcpVIaRGq/wLw8+noyEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0xTdxjG9z/nf84p1ZJjRT3qErZGYjTKJqn6RtFsHxaOzrsmRuOFBk5o
	xzUtICwaQWjkvtKsgBS1YmgIrVhbb8i6kJoRN8agAt6gYg0CahmJtioWZC2LX9783ud58+T5
	8IpI6U1qmUiVkS2oMxRpMlqMxbs2F62NlD9VftvQSsKDwg4MAX8JhoarVhpK7Oco6G21IBgO
	lCB4HzSSoG2bxTCj72TAPzXIwKyzE0GNW0+C9XohAW9tn2h4ffcNAoN3hIbal4UYJs0VCOpH
	jQy8/CMBJobbKZj1jBHw8J0PgXnkEwEjHWcRzNSkwsVGBw3B7h4Sag29CC55PSSM20Lm9c6n
	CJzNZ2h4obtBQt9IJPQHJmn401BOw4S7gYB/bTSYzjgpOG/UIyi6fJWGmvN2DG3P7jDgfj1N
	wFCNngCLfScMm0cxdOkaiVC/0NW1JWCsLSJCY5wAw5V2AqbMLQz8fXkIg7kgBozdfRQ8b65n
	YNq7DmZNmdBpGWPA84sBQ+tED/WdAfHvtVWYb3HcJHjt/Rmat16wIj74UY94f1MRyWt1ofWu
	b5Lkix0n+KYuH81/DAzQvPOdCfN/NXJ8dfdavq3ew/DFvz9h9mw6LI5PFtJUuYL6m62JYmXQ
	VUZkORfkjQ/0ogLkiCxDESKOlXP2x1YyzDS7knv0aGqOo9ivOEflKBVmku36knvgXhPmhayS
	q/q1GocZszHc2J17TJgl7AbOHKzA/2dGcxZbx1xOREjv83bN6VJ2PaedLCZ0SGxCX7SgKFVG
	brpClbY+VpOqzM9Q5cUmZabbUeibzKemq28jf1+CC7EiJJsvccd4lFJKkavJT3chTkTKoiSJ
	zUNKqSRZkf+zoM48rs5JEzQutFyEZUsk2w8KiVI2RZEtpApClqD+7BKiiGUF6GSpsXRLjmvh
	3thV+RPLV9ZJk3DK123T/pRzSYd+0Pmi4+TZg/MOHHGo1Nvk8yoPlB+qu1VHWf8xVSTc+FH2
	m+/U/eRF9mf9Oy2795YtJqo/bKytaGh6my23HcVT+3YMHju9+eyKuO/jT8a1/+RlspR1r5bu
	6AkkH2/V3Etpit+/qzxGhjVKxbrVpFqj+A/gRvS4SQMAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: g9eo8u4oqnx77gmekb91zpmgj8rkkdky
X-Rspam-User: 
X-Rspamd-Queue-Id: 30913A0011
X-Rspamd-Server: rspam04
X-HE-Tag: 1759392814-290083
X-HE-Meta: U2FsdGVkX18AiTTqeEbJ5LdkQ0Eg8VVQqhBCPXCK/DwLtIJ0XBfczbNJj85VNlfq1vuHhxY0uJyjd/kYhiE7gfH9Nbig9SFdyZQ305BFVKDwYz/ii5EaC8/jIMHmIE6X5QPfim2JZJWFfhX+yXrPWr4tY1JoUswoc83i2T7HkIFhJzeNLO5SbAA8bIcAWSY/MB4UKkL50sXMI4BQej6tubl0eBbZVm3oAC5xH/nW0qh8Ut6wrf/Nbv7Tv7SHQuqUuk2/eH5EL9Q+z4Hy1jc0pQnABI/3F9Pnywrelh8yYW7sVr0aYA3cKC/yVmYOU1M0LNnYiOwUdv7S/FjEiR13VdkWKtLj3/UZzZ7y1pYjzB/GsgEaTsfTdWMppsaVLHjI0FXDJgD/ZYbT0Z2nAO12xKDJH9gaKcpQeVpwSjzEKc7KOTHx16Ba/msk7PHjm7eqwWgCAJ4vXB5Z6X18PU40G33+3Tv4I0k0+cPP3rTfxRWpW0WlfSKQr/qkD+RX2AAM2XVa9JDThDvZLA8JMkkdBGH3T5SN/Jh8g95+tYj2XDq3lfcCUy/SdBNycwDwIqKmHtyol492fDleHdr4tBUPEIHuGzqy4SM9CpHOB119Zfv3ntHzbB6Ue/pDW5H9vLkzKAd8ooUgXWG92OVQkqIpbynEkdxC6NzpleM+rpAjfOMxLMGKoPWE9V7UKnRlw8N0CB4NuWnSsFaQM5UV6tYSqi5qf2imTJiNynD99ztoJZ8SSGGU46fxnDrkNk1IurYwvIXgbl9aKego5FeFen6TFAy616AxYrL+08EiVL4ZZzv4+7rl06cDeYzaW+nMQCNnqW5rcoF+uT4jrvZD/KhuXVcShbzQXgh2WdYxaLDP8ZjXVBUj5av8tKCFJq0/+eU/9IIDZdT7zDs7Xb0VB1Eho7AzA35WOFJMep9nrbwa5j7trjM7kyIVfHOlW1RK5U9OHUyUNbQ0vPSc3OrgDgb
 PxhdHgUv
 TUjw84vLZgKe9hPc0sfZNzxJv0bbZKeMIEvTqcv/64zmIDP/PWmLXt7dZdVEChzA2/fQYJucY4RYJC7C3l2ueuB7YSN0XgQkkP0J08/p10n/AMsbV/97bUh50ANLXSMrSQvRU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make dept able to track dependencies by wait_for_completion()/complete().

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/completion.h | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/linux/completion.h b/include/linux/completion.h
index fb2915676574..bd2c207481d6 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -10,6 +10,7 @@
  */
 
 #include <linux/swait.h>
+#include <linux/dept_sdt.h>
 
 /*
  * struct completion - structure used to maintain state for a "completion"
@@ -26,14 +27,33 @@
 struct completion {
 	unsigned int done;
 	struct swait_queue_head wait;
+	struct dept_map dmap;
 };
 
+#define init_completion(x)				\
+do {							\
+	sdt_map_init(&(x)->dmap);			\
+	__init_completion(x);				\
+} while (0)
+
+/*
+ * XXX: No use cases for now. Fill the body when needed.
+ */
 #define init_completion_map(x, m) init_completion(x)
-static inline void complete_acquire(struct completion *x) {}
-static inline void complete_release(struct completion *x) {}
+
+static inline void complete_acquire(struct completion *x)
+{
+	sdt_might_sleep_start(&x->dmap);
+}
+
+static inline void complete_release(struct completion *x)
+{
+	sdt_might_sleep_end();
+}
 
 #define COMPLETION_INITIALIZER(work) \
-	{ 0, __SWAIT_QUEUE_HEAD_INITIALIZER((work).wait) }
+	{ 0, __SWAIT_QUEUE_HEAD_INITIALIZER((work).wait), \
+	  .dmap = DEPT_MAP_INITIALIZER(work, NULL), }
 
 #define COMPLETION_INITIALIZER_ONSTACK_MAP(work, map) \
 	(*({ init_completion_map(&(work), &(map)); &(work); }))
@@ -75,13 +95,13 @@ static inline void complete_release(struct completion *x) {}
 #endif
 
 /**
- * init_completion - Initialize a dynamically allocated completion
+ * __init_completion - Initialize a dynamically allocated completion
  * @x:  pointer to completion structure that is to be initialized
  *
  * This inline function will initialize a dynamically created completion
  * structure.
  */
-static inline void init_completion(struct completion *x)
+static inline void __init_completion(struct completion *x)
 {
 	x->done = 0;
 	init_swait_queue_head(&x->wait);
-- 
2.17.1


