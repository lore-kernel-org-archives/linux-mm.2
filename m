Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B43360A3803
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WWOVdO40
Received: by kanga.kvack.org (Postfix)
	id E8EB66B05B3; Fri, 20 Nov 2026 13:09:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17E06B05B4; Fri, 20 Nov 2026 13:09:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6A716B05B5; Fri, 20 Nov 2026 13:09:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 865C76B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:09:39 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 072BD160134
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:39 +0000 (UTC)
X-FDA: 85456285278.14.2273717
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D94591C0002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WWOVdO40;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf18.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198177;
	b=Sjd4zgZ+Q9zSeEDMxNboQreZhtN1ttwgQQyipbSi5AZU+9m6iTXnbxOjJ6E+Lwb4mT4fFA
	r0qDulHqYBqV+mrRzrl4ujkQSR8sWaqjWAAbwaatNeEyfheLT5UoAj2/qs/pLPyQZVLdL9
	Bwt1z336Hl4UC51H2zpZNkRQMDzzscY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198177;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ee79xbTJKgXU4YvTz1S2LPA9XzilalaBVfFAZEelRfs=;
	b=k0fve8i25AGB8O9S8rHmcaxbtWr6FLXeoaB6ZCK6TbOmWEbm1qy86F+EhRCfjZwMjSgqft
	B98X2ehlfqUTOpEiaAOsZBIAWJBpsOJ/5O0OZI8i9T67ziomMQRSQqp+zW71yxdhRZwxDO
	hc1dXXva4EZWA6/ax8EC/9JGBMkMkvM=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WWOVdO40;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf18.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6515161265;
	Fri, 20 Nov 2026 18:09:36 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198176;
	b=Ks6RQF3g+bh8/z7sdaZPoGonRNoulNq6uUYK9gf9KB7gbxqZbxqAKEygnoFzocKEVrcu
	 1j1oxu19qQMkvA0clyuLnI+U/MOl5AoTS3vOANgtWNRA1gdWa0KJQed8BjZAbSZVgMrcU
	 9LJtVpOv0R6FT+hc5Xbzg6TNC8qPtnfnlpRSb7NbYZa9OEQG2HiEj+PcaP0ziYgLAuW/5
	 KM6RnHN9JiDV1cPKp3RLuldi0BEcSlZfub5sWphol9iRr3GxHjV+/0mPphNmbcPwep87p
	 3CaxdtZSpIHM06VBuANp5NjVHG4vjM/mZxXiJVu9XJ6JvAFWZPiREPgIDuDOYlGjDug==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198176;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ee79xbTJKgXU4YvTz1S2LPA9XzilalaBVfFAZEelRfs=;
	b=MN4a4cyhs+jQVijzH89rXxU/HrbaJ9FJcawyeNWpRRKrwKMsFHiP6CZKhcQNxEOKkDhM
	 9SpFP6NpaLFNU1yXsxC0Ak7BqDl3Gzbuqmc1b8EfBuQGMd2rieERIdZLYIxdTPHRFL175
	 0hCA4JAn8wa2/Ya+bXlvCcPrbI30PIlp1EzLRmxHhhpOo35qdJ3+ZFAMFiIROw/jLk9cC
	 curZSMvlc5/YHA8YtaqsNQO/oey7wmqSccM5h/GJ0go6LqipXz4FdAX8o+G7rZHJoe14E
	 dO/L/0nLw8pmsEgOWhFSmaVfxhkrQywtdQj+j5WMDb2eD+cR9iXQ8ojm57tE57hzxng==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8847F1F000EC;
	Fri, 20 Nov 2026 18:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198176;
	bh=ee79xbTJKgXU4YvTz1S2LPA9XzilalaBVfFAZEelRfs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=WWOVdO40fTaHBd4cq2Q8ecbCKJ/CNEgQI4/h70lKo/I5tCBn9dCcLVXiW++xpeUuf
	 ujKZmFu2ibinY2UNi0SeptbBcyOmcczGx2f0G57EgyOqiWGBywDere8Sta6rwkJZS/
	 JuNOgNvmKRnXdBxk/A7+brCwYFxp2m9LJNVf6M/8+mFAxFG3ZhdwIwO1sbakDp0MXh
	 0MqsVlIacCWNt4qFUwopHOFMBjPdrNKxnCklykRgTocXJTHG2ojhevZqEjxOk+I4wL
	 I8mthG5pAiXNSk7IC8xYkdFJqYSWEXykhKUGLfnqWYOCN8AuXyHE8WxDXjNqpE9rRh
	 tdD9ZYxoqqbGw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 609BB4B8CD;
	Fri, 20 Nov 2026 18:09:17 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:08:54 -0500
Subject: [PATCH 03/60] mm: introduce the common-memory node state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-3-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=6041;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=ajsO63VrYOt1/B86M9EiwRSYqxX+EUlgXltSDFFhAuY=;
 b=i8EdEJBLCK7kYw+nGD0pd446Jpk01TMj3DEPiN/iEyXX9xSSPwHuWtf9EvwHBIGp7fpgk2j1g
 eGSAKGYzz0zCca0iN2pUlbb/I/wPDtOPtDeqTdJbPbkWAfpWma+9Zqh
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D94591C0002
X-Rspam-User:
X-Stat-Signature: ktj1seqotyx9yy5iciessdw418a6kimq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795198176-273728
X-HE-Meta: U2FsdGVkX1/jWQ6hZLyHL1ejdm2Uiiay6XNcS+3oDLhAb53zh8lTUi5tz8/jMC3sF1gMXsTWRTRp89r2GSUkuvhVv/7/vWtSwHWpQYMS7PIId/ZOyAhnLWOtiR9N1tqpHFXfAbUP6+uwZGbSm/kI7vYjD6xGSt76lQyow74r+xqgtjLZOKoWUN0rIbA03HqkWsnbAxjYlwb/yykfW+AFDIC8f1UQU67Dx7/Sz/1oTJu5SROK/1tIZoMhVW8zcf+ntQrRRaBL13AaAX7ttgBD4T90FQd8kbB2jf30TFzYXKKganzJ2pRZ/4pV3Et/efLx853SoeVMzH/ife1RN2vSCt407xINZ1XjmpxdVD79d+TBJ6OglHdZgQE9C9jjWgAi5YUCfB5WHrIGRJxLjXdRzk7ZW7O02Dcnisi/3Xw+J8A85rEuwOCBib87YEtVjQ0R42wPirVmhKAFiNtQB0XGS0Dor1lm1uLuDbMDBK8fs1qJt7oVQRDpQsoUpI7C/TJHHHC3G8seRxtpeoVLpfB4LwP0PaZ7lo6OX18Ll+NPlx7P3lDT2RsPZPb40Rs0lnG6BIwzLvv1mZcmhMM5DuZImxQCLx0k8DydGXRHXCMQ9Qb8s5jfyqeL8Ojpeg/Uppme/f4h4j3sudIDaSX69rp7zZB3wJFKu+UXgMajFbwB9O/kt3AWSqc1PkMCHdxJdsMMXfK29XNG3QomV9yDBcqRDdSySjKmKjUhswG953v21vFfDZV9cBqGpwINSvyTchPW/zaX1cdm0SaLXnQYLAz3nrmRkkvjgCfoUNlyCqm+BFK4tBnaI0wtVAFO+xPU6dwi3EyioQZ88zry17fUvz7tkfOXzom5u8/j8XQqQE9jtA71hxMn+bNEObXEOLR/9VI6cidc0ds7yBL9X5U0RJwbJjV/4NezoynTboGbefbreBbnrzLJY+LCmqnpOLfnCGAZuh3Yvr0JkHP3qTBeA8n
 f2nJunUG
 GgPtcAMwlh+dStLZDcFDv3eGSGAhzjMUyPafAbHXB9rBkdRmzrfbodBvZP04mBYLvvwb7g/ej1+kBIIxmwiJHdw5eEYEQNT6mlANvcd+uNF2jmyNIE/sVMHCiUmjav74/zEbSuxD+XREcYBo62xuE3LsI3B4+hm79Imh5b/Zh2pAEIpzbj616UWja4HtlDiU0MYRgEtqHnhF4lU5s69p5z7w+oVrUrCHczoFr0QXLXMeL/u9WevfOC8oKuq/tEYRy2I/bi3PUvj8ekEBeazN3h1VGKd/MtgEuPyfiCDpb6wJjKgMqvwszSVtCAipU8ASsmyQbE3W+JqTQ1fnRdsypFXWSEVHyObpqg9iFMaoM+HchG+gK7xbHrnrwqMudIsr7rfxL0mph5ecfQ+KNns2LztZlcGzErawRI3zRUS1TIEGe/YeMWNE1WVnuQ8oGY3YVuZXNXgFct8KZ36YjXMsA9WuXripNmW1MIFS5ETbAYDaxmjFh2/UpnZHE8fprYYAvFYzx0FUeZiALi8CXiAOFScDn8b0tfJw1wElwgCi+RNfIw2As+BqQawt/KusMrLa4COCq4ysOfLIYFX8NYJmQwW8sq0izR16xjDzk31AYj3S887bTWd/be6iq2/uv57BT7ACrAPfeG7mqUnNLkDQu3FZzJKo1ejpeY2CnOCSmThTIs8W7kahgoXCLkSYWX2Z6VO+ugxupFuOYDY5XuSgk/u6KCW3ox4Ome/RZ8/v1joLyoiG8gzWKHrHaDuqdfmLeD+GlniMWH9EYFu/m2WxG4MrVR2K37Ar5JAM7eiCEyI4vUCHhUDw+IbrmLlBbmRBPjKLE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

N_MEMORY is overloaded with two meanings:
  1) a node has memory.
  2) a node's memory is reachable via ordinary allocation or
     an arbitrary MM service may use that memory.

Allow N_MEMORY to mean #1, and introduce N_MEMORY_COMMON to mean #2.

N_MEMORY_COMMON nodes contain "common memory" capable of being managed
arbitrarily by the kernel MM based solely on zone membership. Following
commits convert relevant N_MEMORY users to N_MEMORY_COMMON.

Expose the state via `has_common_memory` so userspace can identify
the memory available to ordinary allocations and common MM services.

Add has_memory to the docs while we're here.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 Documentation/ABI/stable/sysfs-devices-node | 17 +++++++++++++++++
 Documentation/mm/physical_memory.rst        |  8 +++++++-
 drivers/base/node.c                         |  2 ++
 include/linux/nodemask.h                    |  9 ++++++++-
 mm/page_alloc.c                             |  3 +++
 5 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
index 2d0e023f22a7..0a2cf3088233 100644
--- a/Documentation/ABI/stable/sysfs-devices-node
+++ b/Documentation/ABI/stable/sysfs-devices-node
@@ -10,6 +10,15 @@ Contact:	Linux Memory Management list <linux-mm@kvack.org>
 Description:
 		Nodes that are online.
 
+What:		/sys/devices/system/node/has_memory
+Date:		December 2012
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Nodes that have memory.
+
+		This memory may or may not be reachable via standard
+		allocations, see has_common_memory for details.
+
 What:		/sys/devices/system/node/has_normal_memory
 Date:		October 2002
 Contact:	Linux Memory Management list <linux-mm@kvack.org>
@@ -29,6 +38,14 @@ Description:
 		Nodes that have regular or high memory.
 		Depends on CONFIG_HIGHMEM.
 
+What:		/sys/devices/system/node/has_common_memory
+Date:		November 2026
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Nodes whose memory ordinary allocations may use without
+		requesting the node explicitly, and that kernel memory
+		management services manage.
+
 What:		/sys/devices/system/node/nodeX
 Date:		October 2002
 Contact:	Linux Memory Management list <linux-mm@kvack.org>
diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index 2e67e8b23a99..86a7d6080535 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -168,7 +168,12 @@ nodes with particular properties as defined by ``enum node_states``:
   The node has regular or high memory. When ``CONFIG_HIGHMEM`` is disabled
   aliased to ``N_NORMAL_MEMORY``.
 ``N_MEMORY``
-  The node has memory(regular, high, movable)
+  The node has online memory (regular, high, movable).  This is a topology and
+  accounting state. Presence in this mask does not mean ordinary allocations
+  can use the node's memory. See ``N_MEMORY_COMMON``.
+``N_MEMORY_COMMON``
+  Ordinary allocations and memory management services may use the node's
+  memory.
 ``N_CPU``
   The node has one or more CPUs
 ``N_GENERIC_INITIATOR``
@@ -184,6 +189,7 @@ For example, for node 2 with normal memory and CPUs, bit 2 will be set in ::
   node_states[N_NORMAL_MEMORY]
   node_states[N_HIGH_MEMORY]
   node_states[N_MEMORY]
+  node_states[N_MEMORY_COMMON]
   node_states[N_CPU]
 
 For various operations possible with nodemasks please refer to
diff --git a/drivers/base/node.c b/drivers/base/node.c
index dcdc8626627a..cc6696d1390f 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -965,6 +965,7 @@ static struct node_attr node_state_attr[] = {
 	[N_HIGH_MEMORY] = _NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
 #endif
 	[N_MEMORY] = _NODE_ATTR(has_memory, N_MEMORY),
+	[N_MEMORY_COMMON] = _NODE_ATTR(has_common_memory, N_MEMORY_COMMON),
 	[N_CPU] = _NODE_ATTR(has_cpu, N_CPU),
 	[N_GENERIC_INITIATOR] = _NODE_ATTR(has_generic_initiator,
 					   N_GENERIC_INITIATOR),
@@ -978,6 +979,7 @@ static struct attribute *node_state_attrs[] = {
 	&node_state_attr[N_HIGH_MEMORY].attr.attr,
 #endif
 	&node_state_attr[N_MEMORY].attr.attr,
+	&node_state_attr[N_MEMORY_COMMON].attr.attr,
 	&node_state_attr[N_CPU].attr.attr,
 	&node_state_attr[N_GENERIC_INITIATOR].attr.attr,
 	NULL
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 90bdcffa42ea..c3b984105bd1 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -398,7 +398,14 @@ enum node_states {
 #else
 	N_HIGH_MEMORY = N_NORMAL_MEMORY,
 #endif
-	N_MEMORY,		/* The node has memory(regular, high, movable) */
+	/*
+	 * N_MEMORY indicates online memory exists on the node - it is used
+	 * to manage per-node meta-data and topology decisions.
+	 * N_MEMORY_COMMON indicates whether the node can satisfy arbitrary
+	 * allocations and whether a service should manage that node's folios.
+	 */
+	N_MEMORY,		/* the node has memory */
+	N_MEMORY_COMMON,	/* common pool (fallback zonelist) */
 	N_CPU,		/* The node has one or more cpus */
 	N_GENERIC_INITIATOR,	/* The node has one or more Generic Initiators */
 	NR_NODE_STATES
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 88d507f93b1a..ddb04b72a160 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -203,6 +203,7 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 	[N_HIGH_MEMORY] = { { [0] = 1UL } },
 #endif
 	[N_MEMORY] = { { [0] = 1UL } },
+	[N_MEMORY_COMMON] = { { [0] = 1UL } },
 	[N_CPU] = { { [0] = 1UL } },
 #endif	/* NUMA */
 };
@@ -211,10 +212,12 @@ EXPORT_SYMBOL(node_states);
 void __meminit node_set_memory_state(int nid)
 {
 	node_set_state(nid, N_MEMORY);
+	node_set_state(nid, N_MEMORY_COMMON);
 }
 
 void __meminit node_clear_memory_state(int nid)
 {
+	node_clear_state(nid, N_MEMORY_COMMON);
 	node_clear_state(nid, N_MEMORY);
 }
 

-- 
2.56.1



