Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7AFDCA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 17:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83EC56B00AD; Mon, 18 Aug 2025 13:02:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815E46B00AF; Mon, 18 Aug 2025 13:02:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C526B00B0; Mon, 18 Aug 2025 13:02:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD1B6B00AD
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:02:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2990711886B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:10 +0000 (UTC)
X-FDA: 83790496020.28.EBA1F5D
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5149110000C
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="UQf/ux/y";
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755536528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a6r+LPu0pSFsz4Xm/eQ1z/XPznLAX+8OLgc0s/PVh14=;
	b=kdtX81dDI9weSx+MD9KPRQRhcLS7hsLLhEQsSlDBFO6z8AdD14oIwve3QxUj22nRuIJWBv
	ZJIgfL/M5NMYW5AttZl7jvWsTj9aSL1cwmcVrSoVk/ylX+Q/I5E6JA9ZVNYx3I/jvT8SgF
	BZxxTWuujK5a0HjbGUNuL/EM2ts5ijk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="UQf/ux/y";
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755536528; a=rsa-sha256;
	cv=none;
	b=nXBRGiUoEfne577qCNFLm7eefVg17R/3fDZQzBcTDqykFlv7R6Xmo3GSubkbcNZ5nJ2Edu
	sXU3wgKs8FWwQ2S86qQcNkCuM70WhrkEtHKUhPNW9YTLXaEtWLBMYUXVAah7x1/xAXy+2g
	AU8+qyK7FfI4mebsf7xxippPx4+QFjM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755536526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a6r+LPu0pSFsz4Xm/eQ1z/XPznLAX+8OLgc0s/PVh14=;
	b=UQf/ux/y+q4m6txXDXG2RhzT0g0AxXDkgQwJ8Af7N6Bmd0yDMCdgna4YuRuOSEiaZnRX4x
	VjU4YYWKAFrW3w0CP6RuXC7F4PccfTvnLX6eStoaE9l31FapcAhFtZPb+oltmQ0qGtf75b
	k5ugS/MCzTGdcS9vUtDiOPKu0aiQYiw=
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
Subject: [PATCH v1 05/14] mm: introduce bpf_get_root_mem_cgroup() bpf kfunc
Date: Mon, 18 Aug 2025 10:01:27 -0700
Message-ID: <20250818170136.209169-6-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-1-roman.gushchin@linux.dev>
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: q8god1bssjrsboqaywesz4yk9w3i86bs
X-Rspam-User: 
X-Rspamd-Queue-Id: 5149110000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1755536528-463851
X-HE-Meta: U2FsdGVkX194+zZkVhCG8E4wQliH3MgP1u9QfiOX1pP11KFhdA6Q9x0xduwd8OvXrfqcMyxY9qt1XZlQ5qIZ+zBQrPbZO2sK/OPuh6fcpSJgRrV3hpnaOBX22SxzaFHyXnI3lL2rfOGLg0wrJg+5PHAa4mVYlLjYRO8qV4jwR6mUw4yQ8DaqAD4FFD4F0zmKYAGN/UfeZqNMvYHrfa5GWZk8paiYRJ3vaKM3l6XCg/QdCNf+AHLtBUoaKVarhrF6ap9fbfER1ZUBjmgbpZT1qIxfFguQpV2ZwNgzYMCcYptzqXyT942u6iOYKcy12S5+/qLsGuboE2sKTLgLKCkn1lypQ7YOTsm8YoEwT3kssFxTs4bET7IUUOcaSgGm/c4BhKyIX/isQqz70EpO6vw+v5NGDxslUtZ+8oJGd7B+JkwdrMG78bMzfzo00ACGna3kzQYk0w7GSrTqjBXRNMMatLaxkLFCBQfc33yCnOcn9K+Yo31JCYFDGuNmpFtXRQfG0Vh7vhTuazacHphyok+oys7A7C9Y+ImE8gWnueLXS0V1kU29hi2Akjc9froCqheGOmAv+QQDKgW75iUrFhFmLMeUMmyg+GckFDgh3MkS3I1VfxVJoDxEGWsxPZR0sEFmX58zlGrCHU/fhmdQcSJesnn0WZnmob5UedV7NB/WrQQLAzhiQq7GmuVMxHxXJ71SmopQ3T+97NG6LjBsFnSJsRvvrjE9rzUkd060mXNVmzTHOvNwxWUkEEHSd0ZChU23iDB1uqaVbU9bA4+1GblY/4xJs0umitEs+5zKrPsBqgVkv9pv4Sa9f6mYITYGdPmWAXKJo4wXf78MUgGaxMVGMcJ9DlxVi2AGQGEyYtx8hSzvQ4ijWb0icHTSFdV7smqAf5ayrtomQA6syNFKR5m+dK84ghDenOy1fkzwVjV9CdhZXoVWbAzl2kXkkwz8csrTWtctgcowKiRjCbLCxHQ
 5UEXnuJM
 vizLoZ9kzt9vd5azg8i34/q56TNYBFfqoGsmnHfUPOapEpViLBk46gydfi8oyqZhDCyjieanjwObzMtUZ8ZQYTc06tKFeywco9vno8r9c3gJqvSOwEw1I9gnW7tQ2l/QJJatYxeDtBqL9pIqfa5ZLcRkEsmyzX9SqDJzSQvth0Lc2r8n46+TOFrMQDsdhuUxqcuJCF2p8y6rNh/M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a bpf kfunc to get a trusted pointer to the root memory
cgroup. It's very handy to traverse the full memcg tree, e.g.
for handling a system-wide OOM.

It's possible to obtain this pointer by traversing the memcg tree
up from any known memcg, but it's sub-optimal and makes bpf programs
more complex and less efficient.

bpf_get_root_mem_cgroup() has a KF_ACQUIRE | KF_RET_NULL semantics,
however in reality it's not necessarily to bump the corresponding
reference counter - root memory cgroup is immortal, reference counting
is skipped, see css_get(). Once set, root_mem_cgroup is always a valid
memcg pointer. It's safe to call bpf_put_mem_cgroup() for the pointer
obtained with bpf_get_root_mem_cgroup(), it's effectively a no-op.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 mm/bpf_memcontrol.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 66f2a359af7e..a8faa561bcba 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -10,6 +10,20 @@
 
 __bpf_kfunc_start_defs();
 
+/**
+ * bpf_get_root_mem_cgroup - Returns a pointer to the root memory cgroup
+ *
+ * The function has KF_ACQUIRE semantics, even though the root memory
+ * cgroup is never destroyed after being created and doesn't require
+ * reference counting. And it's perfectly safe to pass it to
+ * bpf_put_mem_cgroup()
+ */
+__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
+{
+	/* css_get() is not needed */
+	return root_mem_cgroup;
+}
+
 /**
  * bpf_get_mem_cgroup - Get a reference to a memory cgroup
  * @css: pointer to the css structure
@@ -122,6 +136,7 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
+BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
 
-- 
2.50.1


