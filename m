Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4497E668B1
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A8846B0093; Fri, 19 Dec 2025 23:13:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3313F6B0095; Fri, 19 Dec 2025 23:13:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B1F6B0096; Fri, 19 Dec 2025 23:13:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1307B6B0093
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:13:36 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D651FC079B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:13:35 +0000 (UTC)
X-FDA: 84238530390.17.6D7AF99
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3D5821C0002
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:13:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M/9+lxqK";
	spf=pass (imf18.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7evlJ586VgwqQZOIWkPuRy5AVJIYePbARo3wNs1uXHA=;
	b=SNb7CFLqn50Y0YF49I+9jDIvvBabC+bL2ExjpxmIIdc683iE6KxMTCf9NonSbD819QkYEp
	XXbBn/b5oTvh97x9pW0feNoblxOfHrczbhIvmNHgcYh4ZjL6S0RjjDvU/LqszOoIo89KgO
	BtNx6ZB+GBSsO5BBPeSRmwphgiSI37k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204014; a=rsa-sha256;
	cv=none;
	b=AMqa0KVt49sUsK8J59FWAb+XU/Wk7OrBCLdkvg8T8uMAgAlDAdNrieZq3AeDK1Q7cpHRP+
	YGJVgz5Yl6p3og4E6iiZk244+44GAOTdpx0dkoKmLqJqhjQOXBuswBHTg7OHJoL7VUHU7d
	Xe42a7gJRxm8O0a6/hOn/qy5Nr8gkwY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M/9+lxqK";
	spf=pass (imf18.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766204008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7evlJ586VgwqQZOIWkPuRy5AVJIYePbARo3wNs1uXHA=;
	b=M/9+lxqKjAkS2Whu6IcPHOC6uS+J6BOmEpuqgYioua9snBxaNXqlLZhjaWCnuzS2je4zrx
	ZHUdxUP8dKpFKRqfiaEjLrl7Rmc0Hd0JYC94Ckw80fDzWFSWtbsI4oBICkByRMErctY2lJ
	ND+aF6yGAOrYSKaC92M0A4oGHt89zCs=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v2 5/7] mm: introduce BPF kfunc to access memory events
Date: Fri, 19 Dec 2025 20:12:48 -0800
Message-ID: <20251220041250.372179-6-roman.gushchin@linux.dev>
In-Reply-To: <20251220041250.372179-1-roman.gushchin@linux.dev>
References: <20251220041250.372179-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: bqjgc145ekb815aski1nqfj39wx865k9
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3D5821C0002
X-Rspam-User: 
X-HE-Tag: 1766204013-76883
X-HE-Meta: U2FsdGVkX1+8VSv8q9udoySV+gCRID3O1WFAIZMBy39AZgNIrSRzCVxSAPoqP3mwjbNqQENEoatYq8ptAHFest3F07qPOzlWsStNv84hbHZISSsvXHqzRyM0JVzf80ZxduwEYH+1uiEq0BtSAx/iU9rAmVuLWcHH08pQ5vSLWzmhn07PEzLSftxhm8uIx9fQftjFYKGePuyISUuy8EkMkC/V3Nmnkb6slbOBslunAnAVGJZqhDhGmZaoKXZb6TdtV6sY7tBQcA6FvVxYqENUHCq8rNMyB7yf940AwZTadokRK2gVTScDaIQ3QGMh4aQ2Tx3Ef3aYYh5HAVl2imS/RY404jifOwObGRtD7s3GlHETojjybN16mfKnkoEDLvHxu7tBwD/LsMfK8S+v2Z3D6VxUaDKFz41bZOMUSQviU9oTKSRl5PWyOzoaX94jE7xN9tCdCFOPhqtwvTv4l+C0Qf/OgbePJvqyO1FYDSfx26lTpklBc3/iV/OpBcreexze5LvrVuK52CROrM1eZgpOn9RR2q0PhZ+gx0a4cvDdyAMPArxg79VK1hSnqBsDbaxq6ks9akgJ+TGTfz/JJ08pfUh/HLSxjG9WM+TlTB4GxwuGQNT5bA91Zaz0xJrhG0fl+sPSwEx68qdPEdD8TzdGU9Ll6UU3Vi/zn3Txb16GktxgSIEgdputLcM4PpQo2urFGNehypdlVg4KlhzULncXYC6gANNsFk+rK15MznhdRQ06hqVQPZdMl2jUONMfrGoc5HGJLFsUabDoYdiJ2HjfbF9LK44ywUq/VbRAMi1e3vXI9tAjM66gHHZMprclQHuBuaOFJRYBakDoTuTcKU5sfqRDxM29GjmBaAXxBDXix8uKhD4rTssnHgHVg+MY9Hnn2auNbig+6cRyEWYXbMwozrWz/teiIp+9ksBePC16Ix52XSL0SMOZ3isenq7eWRF4cImQu3fo/Mz+prsCdkq
 mTg9dmS2
 w8pC2ERlkrfr8Ls/IXoD/pVB5DznS1nfEHU5jqySQee32lndluH2ye//5/XqGlpsh1Jq011HkhwB8BL6P4kaKiWxz18O5svva0qLJdvzD/sF+awGaox4LJGWC8HTk1g19YKMzYO86rt7Bz37JcqW/u5kCifv8dLMhdVNSBPMXEBjXRNkKe0ntJBFZUWDFSe59ktIciQVLO/9AKKwVZWjpw6UQfdt7QgA98YsgzuLIeJ2rcxOtpaLygmu/byinVm1OFUtG
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
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/bpf_memcontrol.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index d84fe6f3ed43..858eb43766ce 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -103,6 +103,22 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
 	return mem_cgroup_usage(memcg, false) * PAGE_SIZE;
 }
 
+/**
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
@@ -137,6 +153,7 @@ BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_RET_NUL
 BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_TRUSTED_ARGS | KF_RELEASE)
 
 BTF_ID_FLAGS(func, bpf_mem_cgroup_vm_events, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_mem_cgroup_memory_events, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_usage, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_TRUSTED_ARGS | KF_SLEEPABLE)
-- 
2.52.0


