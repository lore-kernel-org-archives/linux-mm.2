Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D0D4CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:22:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE30800B5; Mon, 27 Oct 2025 19:22:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5BA8009B; Mon, 27 Oct 2025 19:22:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CC07800B5; Mon, 27 Oct 2025 19:22:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4488009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:22:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 028461DFED2
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:22:30 +0000 (UTC)
X-FDA: 84045470502.06.46420AF
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1388414000F
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:22:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XScDR66j;
	spf=pass (imf09.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607349; a=rsa-sha256;
	cv=none;
	b=U6xjXXM1E/kMVYh2KSCbHKwTspGN9gOpRiDmVwIjDOMe27/KhAvntYVzby/7BoAhZLZ6p5
	s3xSltP3zQFjhEa45ALtY5dMxBqemv4HjwkftngNSVY18F8ToIU3jxN6qSftKKZUeFbPLx
	wuHFL8exRMth8iejVdMiDeuRGHkK3r8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XScDR66j;
	spf=pass (imf09.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+abN6iitn2yfinJo1jnZ+CHI4w7IGfOgtbnQsSctr0o=;
	b=sG3DJqd8UtQZpBcxu8CLhyoGYMi95sLN2f1TIAckT442VUhbFTbHQCEQJDqCXlwmNcPCay
	r+3TQPPAa/DFmazltLagqyAdGDie+teftr3LGDJPm4wcCoVGXXOCgAMpNCRh0c3SowKgDm
	9T1sORfbPe0lSfqjvoSZVSyUtLFYSq8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+abN6iitn2yfinJo1jnZ+CHI4w7IGfOgtbnQsSctr0o=;
	b=XScDR66j+a3Uh1LJC+kDO2Y4ZAhtZtfxUeNRyzppoM/lkQDv71BgJWp3YFfQCGWsfagatF
	d/tHEQT6khGeiuJpSp9NrugoLmrdV51jpcXbHTlsJTJMYF3N9+ennLsNQNL/I30UEbI0g7
	xq/ub5nLqljSIW9djzibhtEWEhSS4ao=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v2 13/23] mm: introduce bpf_out_of_memory() BPF kfunc
Date: Mon, 27 Oct 2025 16:21:56 -0700
Message-ID: <20251027232206.473085-3-roman.gushchin@linux.dev>
In-Reply-To: <20251027232206.473085-1-roman.gushchin@linux.dev>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 1cxqemfxdrqzdcginc7unxuuby7m4f8p
X-Rspamd-Queue-Id: 1388414000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1761607348-231786
X-HE-Meta: U2FsdGVkX19VKV8h01FQDNcv2WAyyYaMWJnaSNr9KD4Q4vjJblNhDKZZjE/O4vIshWYbtZP2pkHlcf+WI6hm0nUxL65CRnRqz0XV0qdAcz3SAmQWtmftGo20gCYyJF47tV4j33lLL3upi5tybObMenl13bC/hAR4LaB/LS5lVvjbmkGRM52BqkRz5Ng/fjuzJy0v0WEfLJHx+xzZSoGBZq8H4OImJdQZhp2vwbu66RsB8LutDWOVGvccblebvHpRnjWA4sePsWSblc0rSp+Ub4/u8LVeVrvtoXFlegXn2YuykvVIFxpHU7oBcqRWWn7E/s+Ii2LWdooTQmdK3H/PLvy1iTKNurXPiVua6TgxTUQFDZab4j8TEPaKVOleJcPduetjGzdCwkDbXs94ATIdwMMLGqUb5wjiqVBqZk2jWy82aZKz9UCXC82vHx5PI0NnTBRQNDPRQJpcYGm5gYniPF7W64yy5vpPG+gbkjdRlm1uuDcqhHJGMMveXn/hiifJjePNbps6X14gJ1bl25863Y87qrFoaQSsBHhGiO6TP2VNO4dmtevlvQ8oX+3XpLqfR1LgvnRgnjL2BxTZpTxjYeiKSHP4XdIn/ETXAxVjcrAZ7w4lZ1SY918r0NMseKF6gga0J2UUrTQGZktdCSMhOGY4QRIT8YRIJ3xTVznai04VYyLHvPKFjn9LHwYEvwNEQCHP73fhJLIhZhcx82eqYvlHV6oy9woy5tQ7CPrFxYTVBpV6sMgrv0iVxDhbU9WsKFnA2euL5mLm+erqUKEOIYWyRULCZNu2rQlO3WPkl9dAeHeTBljVQGZk4SCaJcBIjZdn4PwQfwhaalFn6SrrCe+yV4tV67I5hkfJKxhMPPWU1tzx1kmMjA3XyRIgw9oVKDVOw9bEg6bgQHRe2k/+bl+F2SSj3/1nBYavD6z1d7JAmeCQDBfaYRZFnVzOwjI+37v3SL3Wh6Q5poNxbfg
 DRsBbPsw
 ndsRyNgM4KNd/3yiO1h2wbpf63hiG6DvELYgS82J5ZkPp2z/q+rW6bwMACwxgx2k2hExF1377CV6jfzZpMFGc7Y/KyL5Lw049WISu20zm9MdFPy/n0SHfOeBHWGkKGahPWiAnnFtNq07ha5oc4q6504NTazDVfxhv9Y3wxFBgTr/wWgiBMCdm3X7SQGQCh7Pj73YR175R2ovHxq1nZb8m06AwHo8x8/J7hOqG+FTwe5tVWD1NgmaMQDQ23Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce bpf_out_of_memory() bpf kfunc, which allows to declare
an out of memory events and trigger the corresponding kernel OOM
handling mechanism.

It takes a trusted memcg pointer (or NULL for system-wide OOMs)
as an argument, as well as the page order.

If the BPF_OOM_FLAGS_WAIT_ON_OOM_LOCK flag is not set, only one OOM
can be declared and handled in the system at once, so if the function
is called in parallel to another OOM handling, it bails out with -EBUSY.
This mode is suited for global OOM's: any concurrent OOMs will likely
do the job and release some memory. In a blocking mode (which is
suited for memcg OOMs) the execution will wait on the oom_lock mutex.

The function is declared as sleepable. It guarantees that it won't
be called from an atomic context. It's required by the OOM handling
code, which shouldn't be called from a non-blocking context.

Handling of a memcg OOM almost always requires taking of the
css_set_lock spinlock. The fact that bpf_out_of_memory() is sleepable
also guarantees that it can't be called with acquired css_set_lock,
so the kernel can't deadlock on it.

Please, note that this function will be inaccessible as of now.
Calling bpf_out_of_memory() from a random context is dangerous
because e.g. it's easy to deadlock the system on oom_lock.
The following commit in the series will provide one safe context
where this kfunc can be used.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/oom.h |  5 ++++
 mm/oom_kill.c       | 63 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index 721087952d04..3cbdcd013274 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -21,6 +21,11 @@ enum oom_constraint {
 	CONSTRAINT_MEMCG,
 };
 
+enum bpf_oom_flags {
+	BPF_OOM_FLAGS_WAIT_ON_OOM_LOCK = 1 << 0,
+	BPF_OOM_FLAGS_LAST = 1 << 1,
+};
+
 /*
  * Details of the page allocation that triggered the oom killer that are used to
  * determine what should be killed.
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 3c86cd755371..d7fca4bf575b 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1330,15 +1330,78 @@ __bpf_kfunc int bpf_oom_kill_process(struct oom_control *oc,
 	return 0;
 }
 
+/**
+ * bpf_out_of_memory - declare Out Of Memory state and invoke OOM killer
+ * @memcg__nullable: memcg or NULL for system-wide OOMs
+ * @order: order of page which wasn't allocated
+ * @flags: flags
+ * @constraint_text__nullable: custom constraint description for the OOM report
+ *
+ * Declares the Out Of Memory state and invokes the OOM killer.
+ *
+ * OOM handlers are synchronized using the oom_lock mutex. If wait_on_oom_lock
+ * is true, the function will wait on it. Otherwise it bails out with -EBUSY
+ * if oom_lock is contended.
+ *
+ * Generally it's advised to pass wait_on_oom_lock=false for global OOMs
+ * and wait_on_oom_lock=true for memcg-scoped OOMs.
+ *
+ * Returns 1 if the forward progress was achieved and some memory was freed.
+ * Returns a negative value if an error occurred.
+ */
+__bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
+				  int order, u64 flags)
+{
+	struct oom_control oc = {
+		.memcg = memcg__nullable,
+		.order = order,
+	};
+	int ret;
+
+	if (flags & ~(BPF_OOM_FLAGS_LAST - 1))
+		return -EINVAL;
+
+	if (oc.order < 0 || oc.order > MAX_PAGE_ORDER)
+		return -EINVAL;
+
+	if (flags & BPF_OOM_FLAGS_WAIT_ON_OOM_LOCK) {
+		ret = mutex_lock_killable(&oom_lock);
+		if (ret)
+			return ret;
+	} else if (!mutex_trylock(&oom_lock))
+		return -EBUSY;
+
+	ret = out_of_memory(&oc);
+
+	mutex_unlock(&oom_lock);
+	return ret;
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_oom_kfuncs)
 BTF_ID_FLAGS(func, bpf_oom_kill_process, KF_SLEEPABLE | KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_out_of_memory, KF_SLEEPABLE | KF_TRUSTED_ARGS)
 BTF_KFUNCS_END(bpf_oom_kfuncs)
 
+BTF_SET_START(bpf_oom_declare_oom_kfuncs)
+BTF_ID(func, bpf_out_of_memory)
+BTF_SET_END(bpf_oom_declare_oom_kfuncs)
+
+extern struct bpf_struct_ops bpf_psi_bpf_ops;
+
+static int bpf_oom_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
+{
+	if (!btf_id_set_contains(&bpf_oom_declare_oom_kfuncs, kfunc_id))
+		return 0;
+
+	return -EACCES;
+}
+
 static const struct btf_kfunc_id_set bpf_oom_kfunc_set = {
 	.owner          = THIS_MODULE,
 	.set            = &bpf_oom_kfuncs,
+	.filter         = bpf_oom_kfunc_filter,
 };
 
 static int __init bpf_oom_init(void)
-- 
2.51.0


