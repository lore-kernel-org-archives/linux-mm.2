Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FCCCCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 17:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0C056B00B4; Mon, 18 Aug 2025 13:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6D596B00B7; Mon, 18 Aug 2025 13:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10026B00B5; Mon, 18 Aug 2025 13:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA9C86B00B2
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:02:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 425891DE532
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:14 +0000 (UTC)
X-FDA: 83790496188.10.F1245CC
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9E5ED180005
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cnTHBb3v;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755536532; a=rsa-sha256;
	cv=none;
	b=4nnXMh+TSzN9Ym8GxCy4cXTcpsBwe6bx3om8n5+k5Hp4ve/4wdGRl+dIJLA9cY8QGRw+4i
	LhU4KU5NPEKniP9NbJRzZsOCxa/LbzBJUCqxgG7PmIdmdWiuP4umh3nckp4+KW32wgDvCN
	Ngty9CJRPz71fmlUtHRhdH5qAbsRnww=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cnTHBb3v;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755536532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJDVBZVxsGNSev7vCHYTiVf7Gz5dWdPKYQSXDL3bVeg=;
	b=tSSCgkwIHCjzkEDpJersPQffAFkhhs3zqt3vxrl9onwNqX1CM8hd8XE7uWtS7JyGQpDhX2
	vPnQQD/r5LjCljCXLJQA081DA3t1l/Z8CsvawH++xbX4cl4B/7c4Uio7t50dHJXgjdeo/4
	mVxk4C7ArK6dNPwITlqQ5dQUiievX+8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755536530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EJDVBZVxsGNSev7vCHYTiVf7Gz5dWdPKYQSXDL3bVeg=;
	b=cnTHBb3vfy+2gSumXKhXWxCrMLvGYp0NrdSLAlXmGwwmwjg9bLrvJBl/jNgJ6Iwhm7LZpM
	a/3hqIIZv1M0mFgr/n4N23F/a+OeyXEJ86Exhc2ysTnZOPo5s/raQHSr5UKsCJ7h8nPo59
	Um5UemvfOJunakaWWZzZQkEikHuITbg=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v1 06/14] mm: introduce bpf_out_of_memory() bpf kfunc
Date: Mon, 18 Aug 2025 10:01:28 -0700
Message-ID: <20250818170136.209169-7-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-1-roman.gushchin@linux.dev>
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9E5ED180005
X-Stat-Signature: sgynt6dd5qsi581zri55krp4t5mz9j3m
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755536532-916529
X-HE-Meta: U2FsdGVkX19wGSvnntphTeT5ueE6bxmAU49RbTWBeoYSqmB+2avuiwB3WCAZ0BA7twD7j5mEZjlSQr+MySm6+Whc3fn0OW+wiShjXvmxsw+qqjhKB23q2qfJ4q7a4+fJXuS5THJa1D7vmFwd/IzRmEiMMl1niNqr6mkkZltH4Xt/UNLbYJDq/PhFTsrcJ7nOCi9bMTj+TzdrbCdBBN8gMnVCGq44cAQrrJu1RxKVYMVMfd/O6VfKpiSSj3H+3ey84tLkrCL7ySrhaz2rwpMjArVbdFiDEM4Oucu7ZcJDUT67XJywTxNnbrjyGZqsxRN9CoZcL46paG/nJFdnMXUKTD97kMYvFvYmWc9JuZZ+4VT/yU5KdInLH9cwKhiCR69g7pFQamwy722KK+C/n/pNGRM9iXahvRQelCgmz3LJmEIzxTglOIe0GfiVJbvxsyC2FWJOz/CpudEid05aYSBXuc3tw85I0ovMfxg6P95UeBSLFk3KBbVQV6CElOx2S78A7CkUTPcFvYS9KPvtUotg0Mn4xKYpV54ax/6tWzpgOqlOwqCI3pi0QR9r0O4i7Czd6DGpm7hD0Pk/wYOX5HwyTh/64Nwz48nksbhie5/znU3p5jd/MVV76Cko2pyberOfhUeNNWEeLdqIYamX8U0b5AaY0VVEt1tCpGw5m25OGESGtmk77i1sBJlfa++1c9CAum/FDLzCIMCetlHTzrVxfdIRYqR7e1sqYCVGc4T5LQ6SA7KG4AQO7bLykSPDH5kPBsBxcuIMZAYPCfSZCOwMGkQUzuwwUz2pU6TVu72WZv/P38TdirwalaLxcYPb37oCGOPn9o30CyAzQ1MOliIGakCrCmKjM6lYYkas9K0wXly8qFHcVJqj66BiN35iATHzdKFkfNx9s+RPxzg8ddN09Z5giKdD1II7v53V0TI/oFyraVGirDLmMpb3Wr6TPQgg16Q5T4Pxgvs=
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

If the wait_on_oom_lock argument is not set, only one OOM can be
declared and handled in the system at once, so if the function is
called in parallel to another OOM handling, it bails out with -EBUSY.
This mode is suited for global OOM's: any concurrent OOMs will likely
do the job and release some memory. In a blocking mode (which is
suited for memcg OOMs) the execution will wait on the oom_lock mutex.

The function is declared as sleepable. It guarantees that it won't
be called from an atomic context. It's required by the OOM handling
code, which is not guaranteed to work in a non-blocking context.

Handling of a memcg OOM almost always requires taking of the
css_set_lock spinlock. The fact that bpf_out_of_memory() is sleepable
also guarantees that it can't be called with acquired css_set_lock,
so the kernel can't deadlock on it.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 mm/oom_kill.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 25fc5e744e27..df409f0fac45 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1324,10 +1324,55 @@ __bpf_kfunc int bpf_oom_kill_process(struct oom_control *oc,
 	return 0;
 }
 
+/**
+ * bpf_out_of_memory - declare Out Of Memory state and invoke OOM killer
+ * @memcg__nullable: memcg or NULL for system-wide OOMs
+ * @order: order of page which wasn't allocated
+ * @wait_on_oom_lock: if true, block on oom_lock
+ * @constraint_text__nullable: custom constraint description for the OOM report
+ *
+ * Declares the Out Of Memory state and invokes the OOM killer.
+ *
+ * OOM handlers are synchronized using the oom_lock mutex. If wait_on_oom_lock
+ * is true, the function will wait on it. Otherwise it bails out with -EBUSY
+ * if oom_lock is contended.
+ *
+ * Generally it's advised to pass wait_on_oom_lock=true for global OOMs
+ * and wait_on_oom_lock=false for memcg-scoped OOMs.
+ *
+ * Returns 1 if the forward progress was achieved and some memory was freed.
+ * Returns a negative value if an error has been occurred.
+ */
+__bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
+				  int order, bool wait_on_oom_lock)
+{
+	struct oom_control oc = {
+		.memcg = memcg__nullable,
+		.order = order,
+	};
+	int ret;
+
+	if (oc.order < 0 || oc.order > MAX_PAGE_ORDER)
+		return -EINVAL;
+
+	if (wait_on_oom_lock) {
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
 
 static const struct btf_kfunc_id_set bpf_oom_kfunc_set = {
-- 
2.50.1


