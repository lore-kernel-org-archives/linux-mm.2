Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BB0CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 17:02:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EC4F6B0098; Mon, 18 Aug 2025 13:02:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09CAB6B00BF; Mon, 18 Aug 2025 13:02:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECEB56B00C0; Mon, 18 Aug 2025 13:02:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1E8F6B00BE
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:02:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A1461409FA
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:20 +0000 (UTC)
X-FDA: 83790496440.13.FA42110
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6DD08120010
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c9BU2ZxZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755536538; a=rsa-sha256;
	cv=none;
	b=uEcO9we8IruxjadpAVOMu7GNf//yhCXk6qQUkXGGG/WYWQ0cIv1YQpkM7IQk3Gcc6Vd8KN
	whv8SbjM6lCU8/86yU5ZhtLN2XBWqpkgx/LSv92dpMdF/EZzuds3wdE6cqZtWk/n+L3dmk
	UVwa/F34tvu3ZTuNVSW4KYgj8qlKVyw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c9BU2ZxZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755536538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mwt3OHKrQ6H4MDHsSz3qoIKrO+SSIvtmYL/lFo8ussA=;
	b=cv8ZezbvSGQWoVtgBXCgJ5YwSVGA8/h6v5nxdghB5kqSXVSsyCjcvY0XwakVV3RtpAL1ky
	2KR5syOjQcOboggsNr3kd5S6ZnsVhPj3tpOdNJnlmYd4lMVnML8T2fmDiamz3e4tRgky/c
	HZKZE51GUokbn0I99EabOLY+V71lXUw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755536537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mwt3OHKrQ6H4MDHsSz3qoIKrO+SSIvtmYL/lFo8ussA=;
	b=c9BU2ZxZSDg31TJtdgdrRnY30VLA37u2N0l2k3tuhQngnqGpEuOtjGzNcqFUWpGOsUrQC5
	4dgKOQdbOg7/I7V5T39IJlU3N2D5ZsIQhdJ+eAoQsA5lfTXIJTEaHMof7exLhQbd8Rb/Cv
	amf9TSDOqkbE68038pDGb423QpmyCEY=
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
Subject: [PATCH v1 08/14] mm: introduce bpf_task_is_oom_victim() kfunc
Date: Mon, 18 Aug 2025 10:01:30 -0700
Message-ID: <20250818170136.209169-9-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-1-roman.gushchin@linux.dev>
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DD08120010
X-Stat-Signature: fpmmaabyh7ggog8sm9kwmfuhfdfb9z44
X-HE-Tag: 1755536538-814579
X-HE-Meta: U2FsdGVkX18E3wLO0bhV5KNj6yp20WwtkYRTlGk72FUJfYpA3lsfnj2zJBAc9Vb9Vvv1I+QcuaXrSdQO9CfKHYnROyW666klEI1bNGTUQs9E9Hu++fyPBVIc7Y8RifoE9HtT2ALhoPzKhOIrWHLENqjaDGNLnWyBHX0W9BJSHehpZgdKb3FSoRcVt+g1a/2pqYTkDvGOBh0zRrRI+5HTXMNWMZwcNxkU50NUuB8SQmLHHmpfor1Ts8wIQhIJhghT3H4gJqTb3oADsC0Cw+lk9OjcYLJZFPo91ZZevnSBkqqBWtpFHt+Rxrjx7JCmGhEPAy4S84K6FHJC/M23rOQyGPn/JYJN1/HaDVCpsEVrSiqxAGObVVhhxwAQFp1+op77Y7N72b+utsCYQwiv+gj3UJRTwFotBwMKh7uT+UvXAy0pG3844st0KD03YRZcbcMih65gkdor2ogm6JScTCJsm6PCTkRhyMnlmspzr+2wSNAykWYf8ExTSsZp+VouZR/gqjVwAIBJHVEBl7DIFbqMogbm9Th6R5ICEVby2Ghhm7QnVRAoS/51javOuFKgzgC4QJoUmS2tUV6msgYRbHm5fBdE2Hf8VCj9g/5OLXAyASU8u/hh8FOJ2EmbEwBtdmXeyw4/vVEu7ZnZS44816onJgvcIe+vj6Z1dPj0I5Si6xCvGo9UrubBpGbMGccfiU2ZdNQz3WVPhNd7fhqhMTKu/QPSiy/clCo7IlDut+CXDlXeVVCBhErh0JvVPC6diPh9UhCZgZHNXLHBg+7UviVtFtUH45mV9bB3gb141Dijpo5OkuKVYImMUmVuzmJYLIBMZePUAmNY5yAMRmNWygMrroMp3i4MZao0aup6DBz/Llf/QjGouHhDQrWsCldMy72j27PDjw7Ds0/SbINbBqtu1q7oy1LSq5gmqXKgXIiFXGagbK3nniTimR+UwZKOu/tcuBqB7cAAex+9k6HuqXB
 Qyzl9dvX
 gZY1z2UTQSFNK5XrYJW9AF85THXMe1g/Z+wNJesoGu04SqgznVAlup+qVe6YU8nKBqjoUOFaanIqQ1fvtzaSoGM3Ecym+bKhdkgB6xF5t+Tcy7/FlnC8rRHYKqbraRlV386xM3EAAx522Al3xD9lz9vxaBziICuhIiTn01VW0d2PswSbnNfwFno3xFtStEfVXkgE2fQIT9Bk/9LbJaUNTrbMd+kLdX8Ju1GYxE+ZPqUaqBM8oYHqXZmgR3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Export tsk_is_oom_victim() helper as a bpf kfunc.
It's very useful to avoid redundant oom kills.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 mm/oom_kill.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 67afcd43a5f7..fe6e69dfbdba 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1388,11 +1388,25 @@ __bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
 	return ret;
 }
 
+/**
+ * bpf_task_is_oom_victim - Check if the task has been marked as an OOM victim
+ * @task: task to check
+ *
+ * Returns true if the task has been previously selected by the OOM killer
+ * to be killed. It's expected that the task will be destroyed soon and some
+ * memory will be freed, so maybe no additional actions required.
+ */
+__bpf_kfunc bool bpf_task_is_oom_victim(struct task_struct *task)
+{
+	return tsk_is_oom_victim(task);
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_oom_kfuncs)
 BTF_ID_FLAGS(func, bpf_oom_kill_process, KF_SLEEPABLE | KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_out_of_memory, KF_SLEEPABLE | KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_task_is_oom_victim, KF_TRUSTED_ARGS)
 BTF_KFUNCS_END(bpf_oom_kfuncs)
 
 static const struct btf_kfunc_id_set bpf_oom_kfunc_set = {
-- 
2.50.1


