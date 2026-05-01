Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0156FF886F
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 02:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150C56B008A; Thu, 30 Apr 2026 22:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12D626B008C; Thu, 30 Apr 2026 22:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064EB6B0092; Thu, 30 Apr 2026 22:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB52C6B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 22:21:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B450B4014A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 02:21:25 +0000 (UTC)
X-FDA: 84717249330.22.BF4D916
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0B401100002
	for <linux-mm@kvack.org>; Fri,  1 May 2026 02:21:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pFLCKW17;
	spf=pass (imf14.hostedemail.com: domain of li.wang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777602084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBtGLtjRvE4baHy0eRK4mwql+K6PPxqXdGnpl9fPIQ0=;
	b=JTx2K73vPYnOtzlOcvpaRU3JklOzm59MMQs2s7zsXTCqILl+R58EJNe5e2nwXrU9Eiz/J8
	e507/1tHLtHSbQ1E6rrPP6r8ATL8Xr5uYSoY27XsmPIgUIywcUj81N0vz7J54s21ycg/NB
	xq/SaIBO16m+PDWt0dP5Dw+pwN7ovok=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777602084; a=rsa-sha256;
	cv=none;
	b=d2zsgCp0k9L2tgoo4MsYVjMMnY4v1FVYG6d57OQ6yylH44RlSt0L1IKHkPvA0qlN/6QG1r
	EqnPVO1M0cQBsyFvFyOft6TMxLivom9gtO00ydCYANp9QTv0AClKQgtyxPwwZhirGSu5Xf
	Lbu32L4wUoEalRGrae9z/kWTDFZ5340=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pFLCKW17;
	spf=pass (imf14.hostedemail.com: domain of li.wang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777602080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NBtGLtjRvE4baHy0eRK4mwql+K6PPxqXdGnpl9fPIQ0=;
	b=pFLCKW176QPS1YiBgSYn6EPexE20q/Nhgy7otY2RejVxCOOgcgct00JRvsqeP7snox6NOo
	L0jeV/ZbzDieXaq2pKtdp48NdkClEIMNtOl1U0wUHV6rLg5k7Gc6uwrAZwD1WqMD4u2qf8
	yRgg/5V2jD5mHAAOUVvV1ymCYwLzyc0=
From: Li Wang <li.wang@linux.dev>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Waiman Long <longman@redhat.com>,
	Christoph Lameter <cl@linux.com>,
	Shakeel Butt <shakeelb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v2 1/2] selftests/cgroup: Fix hardcoded page size in test_percpu_basic
Date: Fri,  1 May 2026 10:20:57 +0800
Message-ID: <20260501022058.18024-2-li.wang@linux.dev>
In-Reply-To: <20260501022058.18024-1-li.wang@linux.dev>
References: <20260501022058.18024-1-li.wang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0B401100002
X-Stat-Signature: hegz1qf5yayhq6kig35bzb59qwqu1jxf
X-Rspam-User: 
X-HE-Tag: 1777602083-633471
X-HE-Meta: U2FsdGVkX1+4Uvb3tFmHPUiJS/FZnPqc58zCK2QlQ50H6i4wK1Cp9VD+u3T6iSVI1FYI9vGIgMOGd5DEf125aLVUrOJrSc2KZ9VI9isAdxFeLVSNjMxaK7EMNicLb1u+VITxeKfrj5iX07BpvFjyNXMHLVFLH0hpx0PBk63oTrMpTp+D06elp9L77dX0wKI2EPPergX0QPFfvIn74aRvyCMQNhilG243sJQaTqzN1XKvhsy59mrusa3zvB7TGNdA8ygDwwTK2k9to/jRwMLz09vmeEx8t1M4BwHhVuAQkg+a+VMWTfLQO028WiRtP2CUOSTRZLEb103e0Fdl9uNHEsSvss0ju6EvlriscocSZgbNTQwnln/AlHBAMuzzqsekdlvmJG+f2GtkvMiAEwvdPkNLnF6BfJ7TfqRYGdaR8bH7Qas4O0mhNIuFcjfvTG4XJrviXuYR92iHRyqAcPL0I4iWSmxPtXZqIJGJm9ujgCRLvFRgoNR8+i1aJi5rIjUelvvu8n3b9quC5QfIr/mkezkc/f0Hei+0gQYn7vWfbZWRazTmo3nYBkMc7q42nucU37yVFVhXDVTxq6YCMjCgMP7BZzjc4MQOjct44VE27r4dRoRNvLS3dXvKquUTw/UGqDt+L8V4p25Lp7TAyR8K/iQubYeyP6F5YabQwE98cGar/tGlz8gh1JcGufqzAM1OnLbr3cI5ntV4D8k2SLKRGtFvUZLHj7Gj7SogURgB9BlrRh2ryofEklyS6ZUdyVnn2XKLBD0DvPrJlEfgxstpoRP8d7SLrlL0kydZ0QTpD1HaU6JJ1kee5gGcdmyNaf6miozjlNzNNo/sQ3R5oh0rMe1e0KnI4LKnkozrF75VHC3D27zP7ns3vViJwa4uxzIIsxnyOhjcz2FRX5H+sHur+2Jpjp3+iAX74dE9NWkJGF9KOfmtc9QIhI8urW3Dl7vhmlqrZn9LQGJj+3Bc/gW
 lUjtOiKT
 oc4rZx/9VPbSK0Pmv0c1uhYzLlzPrSmf2y4zPLig4bpVwyY3rOa/WjJaKUpLtOVrDpxxm0RnNFswNSZPTxUXfPYqkdQiDZGAfaoj9lWThkynhf8ZZt3aCVnaJstUu9ecw6EFdBj6g4wyDdnCM3hriszLZtQxQjN5YZq0mxChYH7sND2VI5lMkMUxWOJpFcXpamhtRUZ2/fi0CwKDwR8t8K03uzJIfhddTblqQwufzIcw1w5VT0CRAnUWt09Jbf3GitEivbjD5j/rIjjERLfBagY/Qq9/awm2uU5qKNf29yC8khgU3Z4gYXSIXVthO7TQ4oPmHJ1ZrqDXsbevjDPWxWmpYMlluGtnr7hm3MRKnLw9Gtn5IgA8ZNKODnZ988IkVNUldO4pcLgWj6SDyhLLxPS6W0Hvb5TAizirG+56ooWhdPV4j9Q67ga6z7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MAX_VMSTAT_ERROR uses a hardcoded page size of 4096, which assumes
4K pages. This causes test_percpu_basic to fail on systems where
the kernel is configured with a larger page size, such as aarch64
systems using 16K or 64K pages, where the maximum permissible
discrepancy between memory.current and percpu charges is
proportionally larger.

Replace the hardcoded 4096 with sysconf(_SC_PAGESIZE) to correctly
derive the page size at runtime regardless of the underlying
architecture or kernel configuration.

Signed-off-by: Li Wang <li.wang@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Waiman Long <longman@redhat.com>
---
 tools/testing/selftests/cgroup/test_kmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index eeabd34bf08..249d7911306 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -24,7 +24,7 @@
  * the maximum discrepancy between charge and vmstat entries is number
  * of cpus multiplied by 64 pages.
  */
-#define MAX_VMSTAT_ERROR (4096 * 64 * get_nprocs())
+#define MAX_VMSTAT_ERROR (sysconf(_SC_PAGESIZE) * 64 * get_nprocs())
 
 #define KMEM_DEAD_WAIT_RETRIES        80
 
-- 
2.54.0


