Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABB89C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:15:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4AEE6B008C; Tue, 14 Jul 2026 08:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1FFB6B0093; Tue, 14 Jul 2026 08:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7D66B0092; Tue, 14 Jul 2026 08:15:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2A26B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 17D3980343
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:15:38 +0000 (UTC)
X-FDA: 84987277956.25.22D80B6
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3C2741A0012
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:15:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=kzZC2sC5;
	spf=pass (imf19.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784031336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTW4Mp0JJ6AVsiV1oNONd40biUPQE43rVLpkGa6ZhVA=;
	b=VvBS4mx8/v4Qm0eC1nxjcQU6836wgRdAWK40CbTbCqXwcIJ5tOrUFA2crXyl0XyyBhN4nQ
	MdyVzhQqf407X4n4tTYmi9N9alNRt5ZkB+kZZJIxiwt/WI6g1LTsF/ZC0DGYu2IGQwugz6
	YK8SBNz+gb5sP2VlrRn+V7ulAa3dpcU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784031336;
	b=0oiTUz3O9Tk6VEV3UFNpA/DQzPLjDZgp0kFbd9ALFsyqDt0e25yx+ia9XidoXi9cRoC77u
	YRnfy8FcmPb/cIFuNoVbGkYUZ/kAukTyV4vZnDVL3V7JO/4xTb142oph8BVSmoCC9QgIei
	+MY4sC7jWQhqnzcCeLW+I3EsEpTVkqA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=kzZC2sC5;
	spf=pass (imf19.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=PTW4Mp0JJ6AVsiV1oNONd40biUPQE43rVLpkGa6ZhVA=;
	b=kzZC2sC5NeUj3xvj/4OmiYy35YCivn0Y0FA7/mkxY+i64JpI3DVxZXqTIlyqc0B6RVQqXaanh
	Ne3KgVhtuzaClsPDeY29BxbpRQ83UTtXsJrUJv4awWjVWpMBroPlhjX/5U0S2HahHPlK+PoBVQn
	nF+PLe+DjkVykBypjWQ+CWQ=
Received: from TW001.hihonor.com (unknown [10.77.229.151])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4gzytp6Dl2zYl0L8;
	Tue, 14 Jul 2026 20:15:30 +0800 (CST)
Received: from TA012-1.hihonor.com (10.77.199.132) by TW001.hihonor.com
 (10.77.229.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 14 Jul
 2026 20:15:30 +0800
Received: from localhost.localdomain (10.144.5.36) by TA012-1.hihonor.com
 (10.77.199.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 14 Jul
 2026 20:15:20 +0800
From: Zicheng Wang <wangzicheng@honor.com>
To: <akpm@linux-foundation.org>, <yuanchu@google.com>
CC: <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>,
	<corbet@lwn.net>, <kasong@tencent.com>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <baohua@kernel.org>, <axelrasmussen@google.com>,
	<weixugc@google.com>, <david@kernel.org>, <ljs@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <roman.gushchin@linux.dev>,
	<muchun.song@linux.dev>, <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<willy@infradead.org>, <denghaojie@honor.com>, <baoquan.he@linux.dev>,
	<kaleshsingh@google.com>, <tjmercier@google.com>, <tao.wangtao@honor.com>,
	<zhangji1@honor.com>, <wangzhen5@honor.com>, Zicheng Wang
	<wangzicheng@honor.com>
Subject: [RFC v2 2/3] mm: memcontrol: add memory.aging cgroup v2 file
Date: Tue, 14 Jul 2026 20:15:28 +0800
Message-ID: <20260714121529.2237261-3-wangzicheng@honor.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260714121529.2237261-1-wangzicheng@honor.com>
References: <20260714121529.2237261-1-wangzicheng@honor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.144.5.36]
X-ClientProxiedBy: TW004-1.hihonor.com (10.77.232.85) To TA012-1.hihonor.com
 (10.77.199.132)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3C2741A0012
X-Stat-Signature: yb9otwawhqapg4tzrms8ct6oxru7h8bf
X-HE-Tag: 1784031335-295072
X-HE-Meta: U2FsdGVkX18zCMTsnwD4Nsp/cfZyTHiycayekk2XcEJWVuYmNR5rZhcFrhFPFh9Y4vlENHAuSEj9jp6YX+K7TiA53AzxbjvZ9aOc5yH1dfsPjw5fPizzUdJ+LHyukC2fyEUSvxiZdmmb4q8Pl0LMBk8HeH+bQ3Z6mtXw7S5ssX7QA6VOF3oZOPl6M/nsUYLs/GRtjx5Vd+jICqImQoSp5TlQrBWM/FKYVKUX9+dUu8eHAICVidTAIgS0gptX3C2ToB94fajArrkaRvkfrk7qWdJtFFpLV7rdFrrPZ5UucKTlrV0HRbMzkrEzljPXauHbiGdG7H/jRy5NgwbIbFxxJTh8Vc50fLwU3E6t5E0tYVuIaBEkNDhtlJs14X22V/vXPijEjfZMBI35X3PeUsUjnQSOwXIIrORSo5hKcY2q+cWI9enbgjt1RXwDt2SyOkRu+gL9inSrNWrT6Y0itX33YUm4WTw+m8Q9xJw5Oyana0fAgEP0Vq+R1oQL/jeNitVforPJOOO7YuNUlkwYhld8eN8IUscHvw9DJBsiggVuY6i7Q0Cvnj+00b7XN+P81Npa2uPM6sP/a4eWBJD9Y2BAY26ixeXP/T0IMuRiZRx08EfMRVEP+fnE4rZ/N8i98ozBfCqj96cDSEk3G50fXTiu9C+TbnSBgj5l8Yzj9SQgPKd9PhkxMyXmFSdB91svfL3KoF79p54EFYpj6RUU6yWE8XbsgBWWSI3fZj2Hk3kkK4duy3tZOgHc6B2DuBEEYzspk1FlXHTgqjvEf9HOxxI2rcgTErG59nhk3sW3va/M44HWAAnJr4o4q/OE0exKktMEpCgD9NfF4KezLsyNnDpO7Lt5hzTaJWMO1EZf70N//kdAEJnSuRFVfDsau3ZRxAmcmHbUTgE4lm4eH32b+iGdJKVN8XyaA+2hGoRhRhUbEdFIIDB459d+ddoqg8MtOqlYOYXmVSr28VX/wOQySc/
 Dh3Bv/xU
 BW8WUXLteXUeLS6p8F+A6GRFG1OD8/hYYpmcd/GTtnrP1KCABqdtVIzdqe2BRfUT130q/wk+SlPzMYD1GnkbjeF+KHugOYE70RICLsBzxkuWy5dCKMU7cPLcd+XUNJMj7yHZKzymX4Arr3vqu40FrjPtz7h+jQS2smdcx85NpPQFn3TNMgK0eX10/VHBGKIs+bFXbxFzJ+1U2dMzR2TuJz3fIXL2yJx0B2IZHdXTIITxnn1/B5w12uE5XkywG5lRZuM22thbC5VMx8NWxI+F0kEEcQPEOII0/l0x8fUKIciY3xJDdznpGiHn3KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a write-only memory.aging that triggers MGLRU aging (max_seq
advancement) without reclaim - the aging counterpart of memory.reclaim.
Userspace ages to rebalance the anon/file distribution across
generations, then reclaims.  This is the control half of the loop;
the observability it needs lands in the next patch.

Useful for workloads such as the Android app lifecycle, where anon
concentrates in the 2nd-youngest generation while file fills the
oldest two and gets over-reclaimed.

  echo 2 > /sys/fs/cgroup/foo/memory.aging
  echo "100M" > /sys/fs/cgroup/foo/memory.reclaim

Gated by CONFIG_LRU_GEN.  Concurrent writers race on the lruvec lock;
a caller that did not advance the window gets -EAGAIN.

Signed-off-by: Zicheng Wang <wangzicheng@honor.com>
---
 Documentation/admin-guide/cgroup-v2.rst       | 35 +++++++++++++++++++
 Documentation/admin-guide/mm/multigen_lru.rst | 13 +++++++
 mm/memcontrol.c                               | 30 ++++++++++++++++
 3 files changed, 78 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6efd0095ed99..f42ac6dddbf6 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1437,6 +1437,41 @@ The following nested keys are defined.
 	The valid range for swappiness is [0-200, max], setting
 	swappiness=max exclusively reclaims anonymous memory.
 
+  memory.aging
+	A write-only file which exists for all cgroups when
+	CONFIG_LRU_GEN is enabled.
+
+	This interface triggers MGLRU aging (generation advancement)
+	without page reclaim. It is useful for proactively rebalancing
+	the distribution of pages across generations before invoking
+	memory.reclaim, particularly for workloads (such as the Android
+	application lifecycle) where anonymous pages concentrate in
+	the youngest generations while file pages fill up the oldest
+	generation and get over-reclaimed.
+
+	The single argument is the number of generations to age, in
+	the range [1, MAX_NR_GENS]. MAX_NR_GENS is currently 4.
+
+	Example::
+
+	  echo 2 > memory.aging
+
+	Each aging pass advances both anonymous and file generations
+	simultaneously, matching MGLRU's max_seq semantics. There is
+	no way to age only one type - this is a property of MGLRU,
+	not of this interface.
+
+	Proactive aging should be followed by memory.reclaim to
+	actually free pages::
+
+	  echo 2 > /sys/fs/cgroup/foo/memory.aging
+	  echo "100M" > /sys/fs/cgroup/foo/memory.reclaim
+
+	Returns -EAGAIN if this call did not advance the generation
+	window (typically because a concurrent caller on the same
+	cgroup got there first). Returns -EINVAL if the argument is
+	missing, zero, or out of range.
+
   memory.peak
 	A read-write single value file which exists on non-root cgroups.
 
diff --git a/Documentation/admin-guide/mm/multigen_lru.rst b/Documentation/admin-guide/mm/multigen_lru.rst
index 9cb54b4ff5d9..fd8b4286014e 100644
--- a/Documentation/admin-guide/mm/multigen_lru.rst
+++ b/Documentation/admin-guide/mm/multigen_lru.rst
@@ -161,3 +161,16 @@ cold pages because of the overestimation, it retries on the next
 server according to the ranking result obtained from the working set
 estimation step. This less forceful approach limits the impacts on the
 existing jobs.
+
+Proactive aging
+---------------
+For workloads where it is useful to rebalance the distribution of
+anonymous and file pages across generations before reclaiming (for
+example, the Android application lifecycle, where an application
+that has just been backgrounded has most of its anonymous pages
+clustered in the youngest generations while file pages dominate
+the oldest), the ``memory.aging`` cgroup v2 file can be used to
+advance the generation counter without eviction. The file returns
+-EAGAIN if no advance happened, so callers can correlate with the
+``aging`` counter to verify how many passes actually took
+effect. See Documentation/admin-guide/cgroup-v2.rst.
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e42f97e004b6..c6a969b56878 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4896,6 +4896,29 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 	return nbytes;
 }
 
+#ifdef CONFIG_LRU_GEN
+static ssize_t memory_aging(struct kernfs_open_file *of, char *buf,
+			    size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	unsigned long nr_gens;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &nr_gens);
+	if (ret)
+		return ret;
+
+	if (nr_gens == 0 || nr_gens > MAX_NR_GENS)
+		return -EINVAL;
+
+	ret = lru_gen_age_memcg(memcg, nr_gens);
+	if (ret)
+		return ret;
+
+	return nbytes;
+}
+#endif
+
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
@@ -4967,6 +4990,13 @@ static struct cftype memory_files[] = {
 		.flags = CFTYPE_NS_DELEGATABLE,
 		.write = memory_reclaim,
 	},
+#ifdef CONFIG_LRU_GEN
+	{
+		.name = "aging",
+		.flags = CFTYPE_NS_DELEGATABLE,
+		.write = memory_aging,
+	},
+#endif
 	{ }	/* terminate */
 };
 
-- 
2.25.1


