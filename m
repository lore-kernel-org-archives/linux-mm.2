Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD681CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 08:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 219548E0076; Fri, 22 Aug 2025 04:22:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1158E0056; Fri, 22 Aug 2025 04:22:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107838E0076; Fri, 22 Aug 2025 04:22:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E62E78E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:22:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92CDC118322
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:22:20 +0000 (UTC)
X-FDA: 83803701240.21.3A890F3
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id EE7361C0002
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:22:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OKWDngTM;
	spf=pass (imf18.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755850938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7B+ym3G57Ia0gA7b5M2w0v/DPMFIwfx3MWwyn0oTnOk=;
	b=JnKNy+oeEhStqHK4mFSkOuPBaeq2YgMSRfLo56vkdCmvwjTgm8R2HhrghFbJ3SH1avBAft
	aeweY62ajHI3qBtkAxOda/Bd7RBy1qlpzm2EFSsqqSTR1d/RKSfnlC03qtIHeM5br9+7Hd
	j5XfInkR6ZBJax9X8I77CFR0fOqoZfs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OKWDngTM;
	spf=pass (imf18.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755850938; a=rsa-sha256;
	cv=none;
	b=dQPA1XVsN0BhDAMbzj1WKQFbdmB6Hy5xr3PHlXdkTWqsQTrt3+cZYMBjM2fG+f/u1mtoNF
	I1HDecu4InLUYDVCHCtxwf7T2iXcsHpHqOqhLQ3owyNqJFndLJtTIyiz8zebrEpV1KqLXN
	D+HrGer8yzxOiROFT99BGo78KWJgI60=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-245f19a324bso17415975ad.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755850936; x=1756455736; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7B+ym3G57Ia0gA7b5M2w0v/DPMFIwfx3MWwyn0oTnOk=;
        b=OKWDngTMwLJDHs555ItZNiuJoaqTYxy4lsRs/dxd/UOBccPJSzIlEIF/qse90Ov14j
         yj73u4pZbHYxWmz016KirFPUMcfUKc8K/FMcrCtj9+YnZBrXdc+xx0baLs90eNvv6rbw
         Fw2aXpJbYrNrLZM3zJno+Cu1biu1i71R9REgr0eJrjQVu14AXXVi3HzeMXAj0YjhuElX
         TGuNxDZXGZfZkib8D5UXUb1ctKGHsHLt/P76UNGP5Vmy+rq5m+NpYtXkuYlEvtadhSaN
         zgVFI0s1kkGHCxiZT7NFG7MFtw9hzB4I4yon2Oj8ffg3UIPawEemVHYEg8D9iA9ll/Nk
         ++RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755850936; x=1756455736;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7B+ym3G57Ia0gA7b5M2w0v/DPMFIwfx3MWwyn0oTnOk=;
        b=s+JR7HHoWZYOOQNb8J54ly0+43Q2pPuGDcx/451v75IGdito/EBXNFDO9b5IT09IW2
         neB4Mx5PrwtVpZMkgE0hjFzP6yMQ8dqSR5JMY9UP78SBSAAdWGiRjDZFeDSFzRIphftY
         CJi3Y69/EgcCMUqIfX4VTiQKhw0SMYV8pD0OeydkD7azil4/k/WYvRQ2ttjKW+l8EKya
         ZA5r1f4HGOmqZnUbaBDFrEAe4/70qPYuFwiYTM3+0RTL+Bfij5R4ojq8uPflE54Bt4Wl
         nFtTVdNxbT4FrpQOLlIhveEUpG2ZpDQmntSS56M8WHAdtkaBG+1lRwL8psOhSh0Z/230
         DqBg==
X-Forwarded-Encrypted: i=1; AJvYcCX1gNtQOvc8mlfgPQGMpKA2BM9+VdnIxzMwxYCZO4COl4dXTbu5i2R0MDJ7+VDDo56EkqYy3/P/sQ==@kvack.org
X-Gm-Message-State: AOJu0YyMuAhEk0qfnsi3P+c6eUcjpz7HmHDsVLqbHncwjl500NltWgdW
	3UOE5F+yd/w2zqdPpO5vyXiBW86+IFpEBwL2bW29aNFqE28eiWkVcvIDAjUSs64lvxo=
X-Gm-Gg: ASbGncvPYUvCBCLaVUCH2e565nqDngN+BijL9QI5FxzA95J5fxra5BKTVxPaGl99QKo
	nqFNYUA0p2VxoIJWLVm04/8NchT8NX4dchyYLtjFMPIa2KHW7xWcru1Pk1oQCpXWIBmLgMljZxq
	KpOhR1LxzLd9izTiXRoJliPgKTbiZg4P12a9BnOqzTOTtoww3jZLxwPT6gbc7VyW37pUBtcx6xO
	0QjpZw21gb0SKVlI9Mssbsrbltoe2LLJCJMwNITcPHHiKA5u6YiSTvgb5699+YKNOEY7Gw3YUpA
	EM/P2TzNHUNA90d32z3xGpD+DsAAgUTN5r3P2xcbPZIgPK6IbgRUigRYbPVbHcLlJXF3koJ72qg
	RLyh7ZgNFtenL4WRUa9gj0IULAnX900lOddCAALw6uC/E+ruRkE9JaZO4Vil+5rF9Z5zmdr0=
X-Google-Smtp-Source: AGHT+IHA3KlrKcHXxuSYhV08ESuEZcmN965/xf1VGEqc9csUX32ZI75YP7zuuOvOsZxoR4o3CXJJ4A==
X-Received: by 2002:a17:902:db0c:b0:245:f2c2:650c with SMTP id d9443c01a7336-2462edeec4dmr30370225ad.18.1755850936362;
        Fri, 22 Aug 2025 01:22:16 -0700 (PDT)
Received: from [10.88.210.107] ([61.213.176.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245ed4c7489sm76648585ad.70.2025.08.22.01.22.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 01:22:15 -0700 (PDT)
Message-ID: <f1ff9656-6633-4a32-ab32-9ee60400b9b0@bytedance.com>
Date: Fri, 22 Aug 2025 16:22:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: [PATCH] memcg: Don't wait writeback completion
 when release memcg.
To: Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-mm@kvack.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 axboe@kernel.dk
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
 <20250820111940.4105766-4-sunjunchao@bytedance.com>
 <aKY2-sTc5qQmdea4@slm.duckdns.org>
 <CAHSKhtf--qn3TH3LFMrwqb-Nng2ABwV2gOX0PyAerd7h612X5Q@mail.gmail.com>
 <aKdQgIvZcVCJWMXl@slm.duckdns.org>
 <CAHSKhtdhj-AuApc8yw+wDNNHMRH-XNMVD=8G7Mk_=1o2FQASQg@mail.gmail.com>
 <aKds9ZMUTC8VztEt@slm.duckdns.org>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <aKds9ZMUTC8VztEt@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xsnfeodci8ckn5u9bgs8saw8d7175qgw
X-Rspam-User: 
X-Rspamd-Queue-Id: EE7361C0002
X-Rspamd-Server: rspam05
X-HE-Tag: 1755850937-705087
X-HE-Meta: U2FsdGVkX1+yx285wyV6dXCj4C5p89KoWjQHx4vyIXzLBLt+qiSyPUfsnbY1E9OEQJOHRcdQpo4w/pSl84MIR4/0zG1Wy2uKYzUgLFxq2Xl6p31r0TpUQt6SCS56tPaIYfPwtpblY5E0obkJak6QpUW2WeGzXW17bMs384WC3+hSRAFUn3XIReP4JmU/FGLDMNcxYj4k9sfwkZPV0CY+15ee2CsXrNG0PqfsqPVy+tAy5B3+2Q6ytgYaAbh6tP4d3gF3xpAcu1ycUjTvn9IDQU/PYCxK6W7P7GVlqk+hMtYEinxTJ4ax4YJdVphT6p0LiYe2O3yfA06kCxjAMjHksZYFuOc+o8d9rtDNluYRlqbZUunhviSce2BtS9O7aTjfDq7GeN2eGEWnhDZ2/9TgDw8q2qT/iEtgcbOCxycCXmDJy/iDj5wtB8ALUOuvsVabc6W4XP6nkowjKb6NgrFfjf9o74+i5Z3Yw+XKQJwB9r0UDuXVKv1Iv4dhvGtoZr7vLTqWh/Obfxt8x1U47gfeCL12Qv45rWBm/PNrc6n75jl8Tqs8ZZpKoX9MZffgYlw/nqwofLZiPSe7AKBHjOGUef9WK+q1FvqudWEUb6jZfPzpDhneQSWRRsGG7y3kBVvapL2YvbgLnwJA/7M4kga4adGAiMda4hshnJzwFtvlftOKuxwqiJsxJ4lar0mnjZOYNNpOAbl8+jK344/bwsi2GND7i102qVQe6S72tTSPkSQOcqCpUyxq44ijo8v/kmgiWvS4rigR12jLXWUF4Iu0m5rplQVT+GpuHitBla7ouak2aRRC5uzkZtiTDqBaQAK956Rubli8ZpzLgM8CvpvvsdMAFQSE8gGKEH2Lha5U0575Jz4oXLIlLIX7y0YsHEc24b+aFE8KeZAFnqtFJPehuIuuvnFbkP6HTg6zeck+yNpczKYEIZl4Ql6zLkZ/amvbJR/bBTSA8tbgBFLEQgG
 6bq4Wo9o
 TsQvl+X9JwET/yfUZu2ZZt1ivU/JrppS/6AY2KiTbmxAVNDOkAgJVkLWPFQVrgzKFqZjeUqe9kqi7t1dwKxTimkzlFfRB/qKU9XCv424vsKc1FQHRPasXBJL8iKeThVht6cZKVUe3/qKwsAoZ0k1snQ9th+Vef7jeBUig8fGuLXJ8emn5eGM/03w+IClsKjX9voGxz/Gi5rynqbwkKNCnNQd8Q/rzMsnSTCYnO5AWW0Objbt697J8yeqkGOg1iIJpwEePunJs36q34xH33wvJcX0Ovt5TVWYfGsyGSmtsTarWHhwsT27Q/9G3IxpwcsmeVr9zAhv1RAfXfyqtLBXixpKGwqXWPGpsoyVFMr33TpBMiEUxUpUhRnTlYYS82iy9YcOYihWIUByaKFA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/22/25 3:01 AM, Tejun Heo wrote:

Hi,

> Hello,
> 
> On Fri, Aug 22, 2025 at 02:00:10AM +0800, Julian Sun wrote:
> ...
>> Do you mean logic like this?
>>
>>      for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
>>          wb_wait_for_completion(&memcg->cgwb_frn[i].done);
>>      kfree(memcg);
>>
>> But there still exist task hang issues as long as
>> wb_wait_for_completion() exists.
> 
> Ah, right. I was just thinking about the workqueue being stalled. The
> problem is that the wait itself is too long.
> 
>> I think the scope of impact of the current changes should be
>> manageable. I have checked all the other places where wb_queue_work()
>> is called, and their free_done values are all 0, and I also tested
>> this patch with the reproducer in [1] with kasan and kmemleak enabled.
>> The test result looks fine, so this should not have a significant
>> impact.
>> What do you think?
> 
> My source of reluctance is that it's a peculiar situation where flushing of
> a cgroup takes that long due to hard throttling and the self-freeing
> mechanism isn't the prettiest thing. Do you think you can do the same thing
> through custom waitq wakeup function?

Yeah, this method looks more general if I understand correctly.

If the idea of the following code makes sense to you, I'd like to split
and convert it into formal patches.

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a07b8cf73ae2..10fede792178 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -172,13 +172,8 @@ static void finish_writeback_work(struct 
wb_writeback_work *work)

  	if (work->auto_free)
  		kfree(work);
-	if (done) {
-		wait_queue_head_t *waitq = done->waitq;
-
-		/* @done can't be accessed after the following dec */
-		if (atomic_dec_and_test(&done->cnt))
-			wake_up_all(waitq);
-	}
+	if (done)
+		done->wb_waitq->wb_wakeup_func(done->wb_waitq, done);
  }

  static void wb_queue_work(struct bdi_writeback *wb,
@@ -213,7 +208,7 @@ static void wb_queue_work(struct bdi_writeback *wb,
  void wb_wait_for_completion(struct wb_completion *done)
  {
  	atomic_dec(&done->cnt);		/* put down the initial count */
-	wait_event(*done->waitq, !atomic_read(&done->cnt));
+	wait_event(done->wb_waitq->waitq, !atomic_read(&done->cnt));
  }

  #ifdef CONFIG_CGROUP_WRITEBACK
diff --git a/include/linux/backing-dev-defs.h 
b/include/linux/backing-dev-defs.h
index 2ad261082bba..04699458ac50 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -60,13 +60,56 @@ enum wb_reason {
  	WB_REASON_MAX,
  };

+struct wb_completion;
+typedef struct wb_wait_queue_head wb_wait_queue_head_t;
+typedef void (*wb_wait_wakeup_func_t)(wb_wait_queue_head_t *wq_waitq,
+									  struct wb_completion *done);
+struct wb_wait_queue_head {
+	wait_queue_head_t waitq;
+	wb_wait_wakeup_func_t wb_wakeup_func;
+};
+
  struct wb_completion {
  	atomic_t		cnt;
-	wait_queue_head_t	*waitq;
+	wb_wait_queue_head_t	*wb_waitq;
  };

+static inline void wb_default_wakeup_func(wb_wait_queue_head_t *wq_waitq,
+										  struct wb_completion *done)
+{
+	/* @done can't be accessed after the following dec */
+	if (atomic_dec_and_test(&done->cnt))
+		wake_up_all(&wq_waitq->waitq);
+}
+
+/* used for cgwb_frn, be careful here, @done can't be accessed */
+static inline void wb_empty_wakeup_func(wb_wait_queue_head_t *wq_waitq,
+										struct wb_completion *done)
+{
+}
+
+#define __init_wb_waitqueue_head(wb_waitq, func) 	\
+	do {											\
+		init_waitqueue_head(&wb_waitq.waitq);		\
+		wb_waitq.wb_wakeup_func = func; 			\
+	} while (0)
+
+#define init_wb_waitqueue_head(wb_waitq) 	\
+	__init_wb_waitqueue_head(wb_waitq, wb_default_wakeup_func)
+
+#define __WB_WAIT_QUEUE_HEAD_INITIALIZER(name, func) {	\
+	.waitq = __WAIT_QUEUE_HEAD_INITIALIZER(name.waitq),	\
+	.wb_wakeup_func = func, 							\
+}
+
+#define __DECLARE_WB_WAIT_QUEUE_HEAD(name, func) \
+	struct wb_wait_queue_head name = 
__WB_WAIT_QUEUE_HEAD_INITIALIZER(name, func)
+
+#define DECLARE_WB_WAIT_QUEUE_HEAD(name) \
+	__DECLARE_WB_WAIT_QUEUE_HEAD(name, wb_default_wakeup_func)
+
  #define __WB_COMPLETION_INIT(_waitq)	\
-	(struct wb_completion){ .cnt = ATOMIC_INIT(1), .waitq = (_waitq) }
+	(struct wb_completion){ .cnt = ATOMIC_INIT(1), .wb_waitq = (_waitq) }

  /*
   * If one wants to wait for one or more wb_writeback_works, each work's
@@ -190,7 +233,7 @@ struct backing_dev_info {
  	struct mutex cgwb_release_mutex;  /* protect shutdown of wb structs */
  	struct rw_semaphore wb_switch_rwsem; /* no cgwb switch while syncing */
  #endif
-	wait_queue_head_t wb_waitq;
+	wb_wait_queue_head_t wb_waitq;

  	struct device *dev;
  	char dev_name[64];
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 783904d8c5ef..c4fec9e22978 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -1008,7 +1008,7 @@ int bdi_init(struct backing_dev_info *bdi)
  	bdi->max_prop_frac = FPROP_FRAC_BASE;
  	INIT_LIST_HEAD(&bdi->bdi_list);
  	INIT_LIST_HEAD(&bdi->wb_list);
-	init_waitqueue_head(&bdi->wb_waitq);
+	init_wb_waitqueue_head(bdi->wb_waitq);
  	bdi->last_bdp_sleep = jiffies;

  	return cgwb_bdi_init(bdi);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8dd7fbed5a94..999624535470 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -99,7 +99,7 @@ static struct kmem_cache *memcg_cachep;
  static struct kmem_cache *memcg_pn_cachep;

  #ifdef CONFIG_CGROUP_WRITEBACK
-static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
+static __DECLARE_WB_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq, 
wb_empty_wakeup_func);
  #endif

  static inline bool task_is_dying(void)
@@ -3909,12 +3909,7 @@ static void mem_cgroup_css_released(struct 
cgroup_subsys_state *css)
  static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
  {
  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	int __maybe_unused i;

-#ifdef CONFIG_CGROUP_WRITEBACK
-	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
-		wb_wait_for_completion(&memcg->cgwb_frn[i].done);
-#endif
  	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
  		static_branch_dec(&memcg_sockets_enabled_key);



> 
> Thanks.
> 

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>

