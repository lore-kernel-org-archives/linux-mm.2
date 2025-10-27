Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19122CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57EB8800B3; Mon, 27 Oct 2025 19:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52E848009B; Mon, 27 Oct 2025 19:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41D90800B3; Mon, 27 Oct 2025 19:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4AA8009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:22:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D0BC913A574
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:22:22 +0000 (UTC)
X-FDA: 84045470124.12.8FBCD7C
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1510C40005
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:22:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gB4ypSMQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=o7ByHM6pY3dwFpR4UtrzDg2GMclAcsB3OodRq+P8j4Q=;
	b=heUSUlOQJd5JotGH7h0R4ZfR1IVR4mb2i2muETfzdH6877QLT0s9s32cnJ2u/wgHBPVSed
	DgF9SCGN4YxgyNxhZ3oxpjKL8GlymJKBUjzpkphYjQniyHiscPHPOtb4XbHGE/Uaakt6AD
	m2HVxSPqbrISXHlbtTLdm5pOcJEXiqo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607341; a=rsa-sha256;
	cv=none;
	b=GdGdwDyM9hqcJM0h8nWt2Jn6hFvrOBJE1fTEJEWrGtDymjt5u4dpd1uisuISufIeeByPST
	SBTQ3xrIiI9Yh3212oyPEhOhSQuOurUZsKDyy7JXF7DAa19BgerQPIKEDE7+WEaCQlCo1n
	ciQkgSpRayiTUqij1maCe5ALKFi6xhQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gB4ypSMQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=o7ByHM6pY3dwFpR4UtrzDg2GMclAcsB3OodRq+P8j4Q=;
	b=gB4ypSMQDUypAYKV6HJ2XH2WemmIfiZB0UwMhQh9wTXb8BbGcyiiR1K9n9hpLOKXNWEkwP
	nhyxWRKMYpek8xquzwYKQrw/M7A8GEGbUtzSP7j/uuts8Rz78K6a8p5MdvlijJYhcsgACc
	Mix3hlPaeGpHRHuDTGBqMGLQcM0R6kg=
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
	Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 11/23] mm: introduce BPF kfunc to access memory events
Date: Mon, 27 Oct 2025 16:21:54 -0700
Message-ID: <20251027232206.473085-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: tuqrbuurz394hcpuj7c4gkjpwk8dsuao
X-Rspam-User: 
X-Rspamd-Queue-Id: 1510C40005
X-HE-Tag: 1761607340-367343
X-HE-Meta: U2FsdGVkX1/q222h22um5yzjI91SIsZmRhInxahGNylPO5rQ+YQV1+TTMvMw2DmnKWt5Vu704IpbnBLxA/whscrEoSwnvgN86MW+6VGkNzAi6W1pKiYS9kXUhH490BXsQcHhSsuluTjrDdmKuMCtG/0X4ZOsVVov+s8LlTUA3meFlgihuStEPKnsUd9dbxmGSu62ByvSMDcIsFrzQ4YbQNy+8fb4H9DA7xMTcesNbOVjahfNtK+33X+F/zFqxDfPNxroRPqKTj5QKVLeSQ/qpEwqBBGiZXPNPcWwI6bJPUe+/5e0rQIeKShP+k2TvdlBI8VnXSeZHrRZBFKBQkcmXkkHKF50PYj6aiHtfUaOqYq3KXjdoxAWboP2ayheh3Jms5mY91G3Uc6fNEG8RBwVCq+o/YsnQP18Nrk7YcFzFgksyzT3W0o6wRIpjy+p7AaVXtXhrE9zweY3C+9WFxUWEUC1mkjVVUIdoSfTQsyVKWV/uVW8HGPabnoQQGbsyHgDvcemdC6RY0Id6g19nEMBKGH6xO4SPI30fij+i2QKITz4zg7o3AG4oeSDa8oWnsfdwCZPUhl8chRJ1k00d3WLuzNAKgvxoRNCAdo3gt7jaq/n5wba5n49o5dCvX1CeVm9+78AQysJ2H8T88OMkyh+iBSoyEMQtOKztXsRW+f8jaHqeJJJSV4K4Hg8QzXuLOP0ZQVRyQCK912E+fjMyIkfzwH+T1cRoHD76fS5qyOtHUUxje1/yKkxn7YwbFfFMvWt7sjdM42OkFkZENOKPHbNqkERJuwgA3+kBvfOuWlQOl9uIU9+XBVIH50uu121bYGswS8rubHd7DFNhVCWCIpeboQuc/Hs6hOIPxov5M/q1VCJOGbFsFJU0xehr102Ug3E6GcJbPfCT5rNGS8+sXIJma2ujcanyG6gass36Xmspx14kakrQ0BMbXxK8c+/fruP8hz6T0rFm3zod1QF/P/
 yQhV3bfN
 oEyepdt7Zbck3De2BYpmh41dI3KqVHy0N9aTOQhdJ7Fk0t/C/33cALytmsDU6cDIKR/JgfUOhkko06NwOpkKyC6tKiSI2OpHGu7AMe3sge5tdsgoY+LlRL3sbwn0ozR01jLfMO1j6DipFU+qjMRxBOAMEy/LKGiYoWcDm4jWP7pUWFUGiUaIW2r+xDFNZxQDk8pSZdi0Md1kf4OVvvHUdyaxi4xfEfZulM68RuEJ1rpIMxe9PppBRtneybNaOjWXYEU+K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: JP Kobryn <inwardvessel@gmail.com>

Introduce BPF kfunc to access memory events, e.g.:
MEMCG_LOW, MEMCG_MAX, MEMCG_OOM, MEMCG_OOM_KILL etc.

Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
---
 mm/bpf_memcontrol.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 387255b8ab88..458ad022b036 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -99,6 +99,23 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
 	return page_counter_read(&memcg->memory);
 }
 
+/**
+ * bpf_mem_cgroup_events - Read memory cgroup's page state counter
+ * bpf_mem_cgroup_memory_events - Read memory cgroup's memory event value
+ * @memcg: memory cgroup
+ * @event: memory event id
+ *
+ * Returns current memory event count.
+ */
+__bpf_kfunc unsigned long bpf_mem_cgroup_memory_events(struct mem_cgroup *memcg,
+						enum memcg_memory_event event)
+{
+	if (event >= MEMCG_NR_MEMORY_EVENTS)
+		return (unsigned long)-1;
+
+	return atomic_long_read(&memcg->memory_events[event]);
+}
+
 /**
  * bpf_mem_cgroup_page_state - Read memory cgroup's page state counter
  * @memcg: memory cgroup
@@ -133,6 +150,7 @@ BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_ACQUIRE | KF_RET_NULL | KF_RCU)
 BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
 
 BTF_ID_FLAGS(func, bpf_mem_cgroup_vm_events, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_mem_cgroup_memory_events, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_usage, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_TRUSTED_ARGS | KF_SLEEPABLE)
-- 
2.51.0


