Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 759D0FF886F
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 02:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFAA96B008C; Thu, 30 Apr 2026 22:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1FD6B0092; Thu, 30 Apr 2026 22:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0F5A6B0093; Thu, 30 Apr 2026 22:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C1E826B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 22:21:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D5F5C18DC
	for <linux-mm@kvack.org>; Fri,  1 May 2026 02:21:30 +0000 (UTC)
X-FDA: 84717249540.05.9ECF1C2
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8E5DC80005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 02:21:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vzRjGgtu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of li.wang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=li.wang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777602088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O2N4+x1Sn+wQRdLiVZolUUHuNzDmAcEVcLCFnksgkqM=;
	b=G1SMbey67TtgV6XU2mB46Lja8ZWq9RX8dIoWoxL0eub2CKOeuiEDMXXJzm/80S3a0+ABkq
	AHEg45LExtYX2aF6NmojnUjqrWN9ivlV5pnR+COyLaV8bCC5kx7vlawgFufoUnhqU/cI1I
	YTULGTM+6dQNiTfVzLk4gzGpWgqb5K8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777602088; a=rsa-sha256;
	cv=none;
	b=ZlOG2WTftrmAP0GocKKPhSMNs0XESjhGsfcsOGQOnJfx3sMzTegqHdsQawoKRNmFW0Ep2r
	gPCYMFXalQcT5/eRfJ5QsY4RmJGLV5/QOFDXuXvl/KzZNeW/Irqwhr1qHhcC3jv7Zdbuzd
	XgQV5o9mZjsEFrdkThIrPYemyjRRza0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vzRjGgtu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of li.wang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=li.wang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777602086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O2N4+x1Sn+wQRdLiVZolUUHuNzDmAcEVcLCFnksgkqM=;
	b=vzRjGgtuFJ1JAtGsc21WhF7K4u4Px7oOGVVXWwhcVFAaoFiF4WrwGixClRcwplk3TT/yOA
	YKlrafWQIZddgGjYIzxPPtgfc9+svL48E8wXWBqVqG+/JNkB9NSt/0BLp+9ktmyYGf4BR0
	//dM0MNYWNijWA4/VQynOLmUvtjXGQg=
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
Subject: [PATCH v2 2/2] selftests/cgroup: include slab in test_percpu_basic memory check
Date: Fri,  1 May 2026 10:20:58 +0800
Message-ID: <20260501022058.18024-3-li.wang@linux.dev>
In-Reply-To: <20260501022058.18024-1-li.wang@linux.dev>
References: <20260501022058.18024-1-li.wang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8E5DC80005
X-Stat-Signature: 9ua19kqfcy59tsa6q18izaz4f6e37jo9
X-Rspam-User: 
X-HE-Tag: 1777602088-964866
X-HE-Meta: U2FsdGVkX19i84azSFNyJH0RdTj45pnLVuEa/xw4fj0HfNYxSFn/RdAzgt97uP2+PbqoRGLc1em6ffhGLMej1Z0VS/tNQ5ZaQaNGOxxbdTQiFIqxI3EXFFmfMl8EwO02nxdDIzLa47u8CSdFNuw3zDuqAeQzi7E4CS6bTfMGx/5UoLmyqYnlkuWSw6SQn+ZBXcMB6hcJ3fjnLf6hk/jzFGYcHWTOuRxmSqfIW6+pGshCmRwnTHokEJicy22LZC5deQk3WcoEt0n84mMZEvrLUXiFMGTycbqLsGhaK/7DdiDW12hgJB5b0fZr0nG2gRxdJUrnReoVKMYoN3K2mkF7xeLk1o504lQRzMxu1g+c2rPMrgdWbayreR6hjYPiRzgJNwkvb1jWucJ4jRtSJ0zXBOCHI5JIliXc8xg/r0lWxQq7Yksh1xTP9sdK2CRFwMuhdONCmbSbzJyhL2jmBLE2psLt2U599erjY7lUKg3v0A6iucMhSoiL2Z0CtcA/sVdkoiC/IKG58NHAvrnFx0z9bwl09zbe6NW+RS/a6Z0vhzknj71KR6zoGLCReCbhZEr1ZkqzKmXv1EZXcsCxD63jvu475n0cs3X2kL7NnkXjnr9kfrsSdb+POryuZUEjUBev3/SN7QM3r6eFo2sPdgqv6+i6p2ri0PIp8HHNraC9P93DJUmJl5TCycLiT6mhEOeGBukaUVHojilRSWXlgk9rCal/b/jBbOlpWxZ60LXOr4VHt5QXntoqA/4Nf+n1vC4rMV4Yo0Y/CO/zo3m/m6E5pDn7U1nLM1NWQJr1aKd5C8YmwtgDszpdPJpR8Kimq2XhoupvGqQb9630srjYPZtDi138rJYRsQwLTbu1J+/M1P1zdd8lBKAm7sONL++TS/y6Cg6BpAsvLN7Rkl0IekIKKUpKh8B4QubFjzFWsuHnpCOGYip18PtDBKv60DBDNwRK+CBZiE0C3AjKivdoPuP
 bVDnA66i
 hLMTk8iDa6oFt5t+StAKEIGrVsx+CMTquTC5cLOcpVCTxLmQL0CWjO1JgJUk094unFGOJd3iiKQ7Hw6E3VqewqDv8eWTkIBsinWm6Jv2jopF0qnsmtCCrghdHejMmkyaIbA7wvfWWyh3PtoyWXyXheDXgEDE//nnTqNCQ1ZiB6AjE/kZLU2RDHQTu8UselIPxEB1ReFdtAiKg3EatO6LaOO2RFpNwAdSMgJSi8bCGsphIVbrGn2j7rDCzl7VGvWNRm7HU6aF7e7WBHRNSMQ8eFfCFwi+OrdanWxgwgU3X0pAhqVDcj8HvesIQiVmZQyUjzVVuaryvyyy8SPmnPdPlCXE+rGrDVm1QXat6OrGaMx4VsCsgtxQn62PYpdYUAkbe1D9sxYAo2+JTU5at2nX8WlD6uCe/jVNEkbmSGcb3zbWVL9B4Ub1rJYE1ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_percpu_basic() currently compares memory.current against only
memory.stat:percpu after creating 1000 child cgroups.

Observed failure:
  #./test_kmem
  ok 1 test_kmem_basic
  ok 2 test_kmem_memcg_deletion
  ok 3 test_kmem_proc_kpagecgroup
  ok 4 test_kmem_kernel_stacks
  ok 5 test_kmem_dead_cgroups
  memory.current 11530240
  percpu 8440000
  not ok 6 test_percpu_basic

That assumption is too strict: child cgroup creation also allocates
slab-backed metadata, so memory.current is expected to be larger than
percpu alone. One visible path is:

  cgroup_mkdir()
    cgroup_create()
      cgroup_addrm_file()
        cgroup_add_file()
          __kernfs_create_file()
            __kernfs_new_node()
              kmem_cache_zalloc()

These kernfs allocations are charged as slab and show up in
memory.stat:slab.

Update the check to compare memory.current against (percpu + slab)
within MAX_VMSTAT_ERROR, and print slab/delta in the failure message to
improve diagnostics.

Signed-off-by: Li Wang <li.wang@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Waiman Long <longman@redhat.com>
---
 tools/testing/selftests/cgroup/test_kmem.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index 249d7911306..4b579969889 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -353,7 +353,7 @@ static int test_percpu_basic(const char *root)
 {
 	int ret = KSFT_FAIL;
 	char *parent, *child;
-	long current, percpu;
+	long current, percpu, slab;
 	int i;
 
 	parent = cg_name(root, "percpu_basic_test");
@@ -379,13 +379,14 @@ static int test_percpu_basic(const char *root)
 
 	current = cg_read_long(parent, "memory.current");
 	percpu = cg_read_key_long(parent, "memory.stat", "percpu ");
+	slab = cg_read_key_long(parent, "memory.stat", "slab ");
 
-	if (current > 0 && percpu > 0 && labs(current - percpu) <
-	    MAX_VMSTAT_ERROR)
+	if (current > 0 && percpu > 0 && slab >= 0 &&
+			labs(current - (percpu + slab)) < MAX_VMSTAT_ERROR)
 		ret = KSFT_PASS;
 	else
-		printf("memory.current %ld\npercpu %ld\n",
-		       current, percpu);
+		printf("memory.current %ld\npercpu %ld\nslab %ld\ndelta %ld\n",
+			current, percpu, slab, current - (percpu + slab));
 
 cleanup_children:
 	for (i = 0; i < 1000; i++) {
-- 
2.54.0


