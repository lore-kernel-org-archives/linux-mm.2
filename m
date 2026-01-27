Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC857D25922
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:45:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30D8C6B009B; Mon, 26 Jan 2026 21:45:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1EC6B009D; Mon, 26 Jan 2026 21:45:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D0B36B009E; Mon, 26 Jan 2026 21:45:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07CD06B009B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:45:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CAD0CC23CE
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:45:02 +0000 (UTC)
X-FDA: 84376201644.20.8ABC465
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0EC6D4000C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:45:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xo4Wlf2s;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0jnmuzCSLEAcMoftcKzgrUEP3R0cGte9hNLunPOvNN4=;
	b=E7zMIvsWzPxvKX1C22HYkPT+BrpHnJAPYlQ8IGDWp4BMkPVESN0smZ0LC2L5/l+UYUO1EH
	TAxyV3BlhXmsuOnzROVAv9VZU4NlN/nN/Tii74/eCfiOvn1/Z53mfrsbMdMHFEhbKsHIgc
	CokjtITZCvxo5kxoiSpseVDO8djCERY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481901; a=rsa-sha256;
	cv=none;
	b=vCi7O0iRuYI6+v1Z7nfK08UJMJ5z56khrYOXA7IWMyRuwEhB8Ib9aFN6PHCnmWS+l+phKm
	FjpO2T38vPawhH8EUhUMySYxLpBZOiyKtdW19VCxzDSU1911hNkbysmwb9Myr65emuCUyx
	58Vb+K3cA5GeRFeSv4FR8jUtjIA8Mdw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xo4Wlf2s;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0jnmuzCSLEAcMoftcKzgrUEP3R0cGte9hNLunPOvNN4=;
	b=xo4Wlf2st4h78zZyRTjozjqSvP2G67otMcHptD9RUQEBUHCt5kCMtTK6HiJeG9/APRhhgu
	Jf4VG+YWbC7GLvrQ10Z7/7EK5//vc9rT7vUWhMqlw+GDtG3197LpdOSk57CeIdhQ8SSUkD
	HFIMJaueXEy4M09lIcO8ICQm1zO0ICE=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v3 09/17] mm: introduce bpf_out_of_memory() BPF kfunc
Date: Mon, 26 Jan 2026 18:44:12 -0800
Message-ID: <20260127024421.494929-10-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-1-roman.gushchin@linux.dev>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0EC6D4000C
X-Stat-Signature: mygotnbg9t54xnjfjesmo6dg5ex5thkg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769481900-702376
X-HE-Meta: U2FsdGVkX18oIgpeO8xkxRTipB6DNfqwmXzRpy8yFSS0Gi8QRRSarwqCP2ahvOH31vP50iuUveQvC8YdLA2jS3YCL3CEavbiacjojjKCBxFL8PbOOHxv77nJkWEPz9Zze0f3qM4Rmioxyd0Rgf5M9q+nntuwJdTyJK616iQG8WfV+PLWzp2LfSPNS+V9WokBv7NDAB7W1f3i6vFdughNUPXPzIG+0HxZJg/Gy5P8aoFeQaTovg+YRKfthO7SgdXRtglzvwZiBY/NBGsho7GUnaURvQx2yFQ+hX29AmAc5HzI22ophV90coHlYJR9te+ndc9OHi8UvV/aaxscpHWxDSEi2Ibs59tcPwWzTt33CGCjD8NBcCwRe6+xFAR+FUeUAWULgCytAH9zjEM7kZ+3K7o3LMhuSP7b9J3CPsh/W5c9lm6r1DtTSwydTsWhHep9XpC/WlysnA9C4DwHwO5LNy9mp5mur1zczeDZ5I9e4FsyE2cY4WCq70tupdKQwCkmPqfPoWGoAR0D+ra+5K7faIA8ptJCGB809VQLlxY7w0GsMSt1HIQSzbNNmDg/MTJsamOcfgjIeU/24VmRE9OUInIZT6YBKnR5kPsKBAtWFR7Vh/d/KFgX9nyHZl021tKGbw/poj2uC2oNM12UVPH2t5WaAmWb4IKNxHYSK0E2iZCrx09JO9ZoTaAot1bCLXyLobwy0h3y1gkMOX2qmd+YAzQZFoJVbBqH0TZaDt5qCNTOUAl0h/HkXo7UmzwUnnWN0+wofYm6DJ/YQVM0sZttisoIKvhn6plh3SyO3Wyqvc9IFsBbmQ0l1vryUUBFMRH/BM8aAdf6ieFdmDnLRUGavFr/2ufwNzV+7peQoaZI0iJu648ib/6OI8+NXUwwHec2z93TTonJyPvsusv1iFlyRGZKsf0xplWtV2b36mICKW58BefZnN6JDB1dk+MAUmYQR1yU4Qdzi6/Z82dcfi8
 FGKkCeoM
 NZhRKTtCgMqxNJJxT1uGamD70maKUN4vy7AkZCiVXnGKnV07iaI1hhKDc4ezfQrjILlJu6MTHJUnpBiKlfzKat0/NlX5saVJmQPkR/YStCtXdkdH5VsNLB8hXdWOPI/BWrfbDIcIjgIvvwa0LNq+9c+XfFPpqjHlFmA4zeC5TNMUpXQD3X0yuIEwuGbCegdgnEkIeZHJgRIJFooFoVF4QwgMLMtj4xWlixob88WvFmUy5pLe4nRotJbhfGA==
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

To avoid deadlocks on the oom lock, the function is filtered out for
bpf oom struct ops programs and all tracing programs.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/oom.h |  5 +++
 mm/oom_kill.c       | 85 +++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index c2dce336bcb4..851dba9287b5 100644
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
index 09897597907f..8f63a370b8f5 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1334,6 +1334,53 @@ __bpf_kfunc int bpf_oom_kill_process(struct oom_control *oc,
 	return 0;
 }
 
+/**
+ * bpf_out_of_memory - declare Out Of Memory state and invoke OOM killer
+ * @memcg__nullable: memcg or NULL for system-wide OOMs
+ * @order: order of page which wasn't allocated
+ * @flags: flags
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
+		.gfp_mask = GFP_KERNEL,
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
@@ -1356,14 +1403,48 @@ static const struct btf_kfunc_id_set bpf_oom_kfunc_set = {
 	.filter         = bpf_oom_kfunc_filter,
 };
 
+BTF_KFUNCS_START(bpf_declare_oom_kfuncs)
+BTF_ID_FLAGS(func, bpf_out_of_memory, KF_SLEEPABLE)
+BTF_KFUNCS_END(bpf_declare_oom_kfuncs)
+
+static int bpf_declare_oom_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
+{
+	if (!btf_id_set8_contains(&bpf_declare_oom_kfuncs, kfunc_id))
+		return 0;
+
+	if (prog->type == BPF_PROG_TYPE_STRUCT_OPS &&
+	    prog->aux->attach_btf_id == bpf_oom_ops_ids[0])
+		return -EACCES;
+
+	if (prog->type == BPF_PROG_TYPE_TRACING)
+		return -EACCES;
+
+	return 0;
+}
+
+static const struct btf_kfunc_id_set bpf_declare_oom_kfunc_set = {
+	.owner          = THIS_MODULE,
+	.set            = &bpf_declare_oom_kfuncs,
+	.filter         = bpf_declare_oom_kfunc_filter,
+};
+
 static int __init bpf_oom_init(void)
 {
 	int err;
 
 	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
 					&bpf_oom_kfunc_set);
-	if (err)
-		pr_warn("error while registering bpf oom kfuncs: %d", err);
+	if (err) {
+		pr_warn("error while registering struct_ops bpf oom kfuncs: %d", err);
+		return err;
+	}
+
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
+					&bpf_declare_oom_kfunc_set);
+	if (err) {
+		pr_warn("error while registering unspec bpf oom kfuncs: %d", err);
+		return err;
+	}
 
 	return err;
 }
-- 
2.52.0


