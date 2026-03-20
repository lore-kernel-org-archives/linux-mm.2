Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DE171099B3F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 20:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78C8D6B00EF; Fri, 20 Mar 2026 16:43:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73D706B00F4; Fri, 20 Mar 2026 16:43:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 605216B00F5; Fri, 20 Mar 2026 16:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5216B00EF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:43:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 224861A031F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:14 +0000 (UTC)
X-FDA: 84567616308.25.8342B78
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5563F1C0011
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X/cIC6BU";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774039392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n8lUtSKyFrk8YBBDo4AltLu8YBIJTZq8Ls8cEx7Gnqc=;
	b=uvultaVGRnniqSBKBg1CAf3Ya7t3l6h5sCP0w29b8a4SOqc0vtu+K6RYZ0j2Gt9fuplt92
	VDrt2lWLFMrz1A5FO9clY8UoiQB83EHpDLq5B9Fh88ulB3Sg61xUjr9+T7AbOVCy/6vNEt
	VNqXqIagKceMcXte9zabObLF1Veqpqc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X/cIC6BU";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774039392; a=rsa-sha256;
	cv=none;
	b=4CoUL8afRv2Q7AOJjIbfBjxec4M4fvmFxbEzgCe6pRxX0KeY9yrMsX7N0W6XEO1ZhpW9ox
	AQjb2Nqxr4fbOqB4/EM+9m8h8DmqLGx1zoTOsyubYsgrTG6WsfuFsDlXnkwYqNTnOKL9wk
	O28koGtk8EZJ2TRiiF9ElPaMX6mshto=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774039391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n8lUtSKyFrk8YBBDo4AltLu8YBIJTZq8Ls8cEx7Gnqc=;
	b=X/cIC6BUdpLFhuEx3EfN1WD4h2US8jHHd5E3wVTfGFwDqTgCPb7jIB3OpsFXV/yJmULtIn
	vNAh7ecvV6UdSP33VqaN2LGI/9ZSqPnhYnmPzxlC040yhZY3ctGUHEVWlwjzTyKqDsbBa8
	qlat9hMkNs+2qZUn3b/8tzmMDRw65sw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-326-HS4GhqznNiSV7KJMYjamvw-1; Fri,
 20 Mar 2026 16:43:06 -0400
X-MC-Unique: HS4GhqznNiSV7KJMYjamvw-1
X-Mimecast-MFC-AGG-ID: HS4GhqznNiSV7KJMYjamvw_1774039384
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9A4B180034E;
	Fri, 20 Mar 2026 20:43:03 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.65.139])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B40F4180075D;
	Fri, 20 Mar 2026 20:43:00 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Li Wang <liwan@redhat.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v2 2/7] memcg: Scale down MEMCG_CHARGE_BATCH with increase in PAGE_SIZE
Date: Fri, 20 Mar 2026 16:42:36 -0400
Message-ID: <20260320204241.1613861-3-longman@redhat.com>
In-Reply-To: <20260320204241.1613861-1-longman@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: jlKX6Ft3SwN1Jo6pej-7ph-Y7FJJElyFFvcxylo4LyE_1774039384
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5563F1C0011
X-Stat-Signature: w664owugkhjybx6iy3js1kdwmwqkc9di
X-Rspam-User: 
X-HE-Tag: 1774039392-255647
X-HE-Meta: U2FsdGVkX1/PWQG0Qh1BMNoNVoBi5pWy61SgVSmDSliKaDQKeYEPEAyYCm+BzIpHiNXsUx5Nl5ypBlIDI+9Kb9yRwJRqvq8hpWfcSdjcriIJZK2GHypqBc64Ul7P4dRnBg8KxhTErxZcqsmrYIUJFsQdkZc5jySA522shE52hZdQTKGJbo6SwxdviMEfjQDvUUkODxswP3NWeWw5w1n79kltjoe/I1db1hwrQsfLy0lRnOIz1HAfU/c9NjS+Gq7DROjKKVDGwjPtr3tCFGtVZ6kNMDEPyxDLQx3k/BppTVqP7ywZgT0M9FS90JpFPLFx/gKsvJRV49Z3WOffLnYf3qWXsV0zF5ty3KSrS7U5QKwAz1TunbdOBeT6BFuGHdsjcKthHb0plN+7iBzRyYZBvMukQzDQmuPSlH+0E5v9DtXXYVMVcKKqOOSjTxV8YYBn5DwWILC/W6/zHMp7bW8hs5P0QNTBNc04I3X1To1HEMkl80XQx0HmbAQ6WSdqAs4J6I6pobAdslE4+aWYSyxQYrgbjDOxFnU6qB0doV2WcjciKy5Lv7UBda/EuorL/iI23ZIyiH1iMLj8qh/eKF6yA2hDZSaIFCD9DS5cxuSwOom8hWAlXUrSR45Ie81wk6Mq4RdsOXa+QxxAkZLxboeZ0tBcbVfsNvCByCwHw0ngdSeqDHICgIfRpwGwkrP/goDAOORNHO1y6yPBVStGSGnvnyBvism9JgVKpY4aym92A2EBgAwy2eN1vuqa1Ttp/bc5Whh3r5juLTt/X0darm3JSqo+qjM03COjXy/j6wMM59bnnNU5MW20MxQd9qtjzX6eLGDIzdM7zh3SItwQJX/PrTTo4c8hfS2wWQF+X6VqVon5kJdQK83HL6SEbNpXPhfGfRIWrLhw+RCuxLQ/QamM5TlaS9CI5H23sFKZk0aTxbZ0qCX7EzMiSRAIICRAzfaYmyNgnzi7Ih/Qovan4iM
 hn+S2KBR
 s2NGrLsxLxohbtNYK95n5Jvrd0YrnHdizcWxdjXaCDwA+raq/IhGFuJ9931OslLRVl3mg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For a system with 4k page size, each percpu memcg_stock can hide up
to 256 kbytes of memory with the current MEMCG_CHARGE_BATCH value of
64. For another system with 64k page size, that becomes 4 Mbytes. This
hidden charges will affect the accurary of the memory.current value.

This MEMCG_CHARGE_BATCH value also controls how often should the
memcg vmstat values need flushing. As a result, the values reported
in memory.stat cgroup control files are less indicative of the actual
memory consumption of a particular memory cgroup when the page size
increases from 4k.

This problem can be illustrated by running the test_memcontrol
selftest. Running a 4k page size kernel on a 128-core arm64 system,
the test_memcg_current_peak test which allocates a 50M anonymous memory
passed. With a 64k page size kernel on the same system, however, the
same test failed because the "anon" attribute of memory.stat file might
report a size of 0 depending on the number of CPUs the system has.

To solve this inaccurate memory stats problem, we need to scale down
the amount of memory that can be hidden by reducing MEMCG_CHARGE_BATCH
when the page size increases. The same user application will likely
consume more memory on systems with larger page size and it is also
less efficient if we scale down MEMCG_CHARGE_BATCH by too much.  So I
believe a good compromise is to scale down MEMCG_CHARGE_BATCH by 2 for
16k page size and by 4 with 64k page size.

With that change, the test_memcg_current_peak test passed again with
the modified 64k page size kernel.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 include/linux/memcontrol.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 70b685a85bf4..748cfd75d998 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -328,8 +328,14 @@ struct mem_cgroup {
  * size of first charge trial.
  * TODO: maybe necessary to use big numbers in big irons or dynamic based of the
  * workload.
+ *
+ * There are 3 common base page sizes - 4k, 16k & 64k. In order to limit the
+ * amount of memory that can be hidden in each percpu memcg_stock for a given
+ * memcg, we scale down MEMCG_CHARGE_BATCH by 2 for 16k and 4 for 64k.
  */
-#define MEMCG_CHARGE_BATCH 64U
+#define MEMCG_CHARGE_BATCH_BASE  64U
+#define MEMCG_CHARGE_BATCH_SHIFT ((PAGE_SHIFT <= 16) ? (PAGE_SHIFT - 12)/2 : 2)
+#define MEMCG_CHARGE_BATCH	 (MEMCG_CHARGE_BATCH_BASE >> MEMCG_CHARGE_BATCH_SHIFT)
 
 extern struct mem_cgroup *root_mem_cgroup;
 
-- 
2.53.0


