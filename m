Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E850B607BB25
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZEflbQUl
Received: by kanga.kvack.org (Postfix)
	id 5909C6B05DF; Fri, 20 Nov 2026 13:10:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F0176B05E0; Fri, 20 Nov 2026 13:10:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F79A6B05E1; Fri, 20 Nov 2026 13:10:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 013A76B05DF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:47 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 925D9140134
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:47 +0000 (UTC)
X-FDA: 85456288134.25.67F73FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 681CA140004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZEflbQUl;
	spf=pass (imf26.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198245;
	b=QPmkp9ukaZ819C2CYBvjeatH2WvnYgcZOZBd311/x3EhnVaGS6HdAQSn3uOyTXoqJlDgEZ
	ozVN+3bcSoccRLJGu6vSwFQlUEdmriw/8XUnfhqefnqzQOrrFaeX35EdgGqhz5Td40OATf
	CtrZmy/ODKUrMidXLGxcR2OPjP6Gnr0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198245;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hiSbpQWW/gUTlgsWMM+m+hivzUTcJ7Oj0fNSfIqp+1A=;
	b=uRwVtIvnHqjSyPhjQd72oB8D/dG1UoktLKpmH8Wc4KXdmQ6H3nCxH+7O7RdWu8rDDFN4iC
	/8fnU5IbotElBt+/dkVOZGKdAcX35xoxHONJuivLVCGDaLbVdAQ+F8JQUzA/bMTbJcArds
	gpCCql5Pwk2Dnhd/L3a5ufyMk29JHXE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZEflbQUl;
	spf=pass (imf26.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BA9E6342F;
	Fri, 20 Nov 2026 18:10:45 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198244;
	b=gYysDezzJw76vR/bwbKRptT9Io/ajuvAMe/G4ZCtKWzLz0XUbZiFEAEhVT7vxZ/rl7Fe
	 f/ppREJCfumUE0qRntjk+QsK46nVMDKtn22h2DUqi/hV0HTEJEd4cXI1JPZWEe11EO40z
	 8/goPosNmqQFB2FptNFzN1KpVYb6bbv1W+1eVIUiJdk68sHMHqHhdTS7M+mIYlfZe07Dz
	 Isajjki21UkM8FoPTdeghojSqsZS5uvsS6DHeZ0m+BNRbmJPWLGONjPKbSLgSTcIODsF5
	 oXPzCohdhxqnBlz4LCOIDoKMPosOMLBMbYinxE0mL30JwtLPzp0uTyHso8qBCZcw/Qw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198244;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=hiSbpQWW/gUTlgsWMM+m+hivzUTcJ7Oj0fNSfIqp+1A=;
	b=mjK/Jg3FAOSLM+E75IViwd39ZM0eCgRwGxhElRQZbDn1hCMNbKcJ3Qm6SzSy4j23YA35
	 FW57864n747DM5CSQke16av4LmPMgDBh5pCoZ1cQoIVtQ8gnEQa4urkGi9P3o0J6ntNEW
	 WasLWapQYgw5IBfq9Cb0DwqQ+Rrk/koYoItP1wcPDIjhANHY2oCwqkBBtp8Futrk9gUvg
	 2V2fMajmkvW9DqsgXm1vJ5b65zzk5mDwujY3H3U5ftg8/DAbgIxxSA27x6Q/vmE8lMa9Y
	 VmV6n2ca/rG/AEC1a6A5Un0UU+YGi7S8nzRp0/znO3xFVDjRlHMmZkWedSUOYuN504A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 67D161F000CA;
	Fri, 20 Nov 2026 18:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198244;
	bh=hiSbpQWW/gUTlgsWMM+m+hivzUTcJ7Oj0fNSfIqp+1A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ZEflbQUlyFpFIlCDPqFqhM07hGBZO5dg2l1RMICjg6Ah0yTkHjK+MRKn+Zq8D3Q2E
	 xUSmNIUa7LJXfvMGry35zUnt3ibC6ZTS9x5QP/ZlqlXSgnPiTWUzotlCFS21tRza9g
	 Q4fZIobD01j+ifX0AUmgv6UC6zDmjreY3WUcvFLoBv05tCnSjC8zkyOyKcrSIf67FP
	 ZtIuh+0D9v2hO8UuQ0bgtI8X+fWH46p3q4Lh+vg8c6jNCr4Cn3ldLyW8/6moFdvZLp
	 WmuR85bP5+8z38/GnQy8DuPEq2NyrkwVtxaois3eUCCsH+Z3FuQJdhNxZObEIR4AZ4
	 U7yEbVj91MtTA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 02F0C4B945;
	Fri, 20 Nov 2026 18:09:21 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:24 -0500
Subject: [PATCH 33/60] cgroup/cpuset: ignore private nodes when matching
 OOM victims
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-33-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=1825;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=tfQy6A54qGIg5N0QwMR0J5wQcHlPo4StvKwwDY0AXzQ=;
 b=TOQv91CCE4kl6kuILhP9vhwwGPNmP5h8d1k9lUI5PYoPQsNY3N5JtGHROUurmkLEfZ7JXBtci
 YRpEP+Zs0diDRgCXyfgSRDIhjJbJuiQm1kaI1p1h+gZS7NfXp8/pkI9
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 681CA140004
X-Stat-Signature: 8gox4uu5684sy7o9boze6dswhiu6anxe
X-Rspam-User:
X-HE-Tag: 1795198245-254496
X-HE-Meta: U2FsdGVkX1/r8rpM+2JhqMClm50ty87y3wIsdECv8dLOT6loX0+sKR3obCmwAsYKGkEGB8pfvhEroPJjt2GGVS+3XySYCC9B/Vje7Hy8gNErmFNmaWjtQurxt9eRAfQAkt3IZoYhyEY9Ypj7HL5Wkj5tA7pPD6fN4fLh2e5gjPKzIMSSdtDC2+OTUgXUxk/wmtO2niC77GR9xC5hchXHfXIMY3eGolTNy9Yo++hg5k7FHPejoQcy0PMp2If8dnf/jIPHXhknoj1DVpQV9l10dnEh9/Nn0ZoyGCPmcbidbYxvGoWgiKQ0x5LI0fUnDOHKBfdvJnpVkIHWSOq3RrDU8w55h2UDp9cArkGNSnffJ5R0HpEar69yCCTilGFcJq9XGyH/LlELFFU4HV3eYen0gXHqD4Gz8uRw2WXiqRBKshlZAUkqIDytgOpSEhXG4n47bhtSSmdSm4R4T8aDCwwHSZGn6eul2N7cl8HZcpWKYfsda9ivpHHBWxHjT8CKuDr8DT4NiqVUg1UvMiqNWLr4hJPJhGlKCbdFvcx1lzXHGNNjcUxYnFN5FPnN9jWWoiVrHHY/cPnemP5oTO8Fdqcnj6QfnoROCVsTY6nMYg1DPHV1A4OOnhFiX1miSvLntkkYTGusdI+7UQAESOyoJZWEUfi/k4akWqXAy0xCyfHAQo65EEaemcu+ueMBNQUh0QjHwFmmU0Hockhi6Pv/c2nL5SkKPCBUw6Xs9J55c/Q1g6xDE/DO6gIqyazyO4J6PsDME/AIn0I0oZkj9UIBUaAek20cNPCsZTYykftU8sKI6of7Q4kOfAQi+ktNLQcI802fqeycAtLp7pLoooBHm5NYBT1ioZOTzqpIBCWPWfL9eGZkCNPzz1KwZiE9kXa2qTWs4DU7VmUuGRCkoWI8AFbEIfDqR77x+ZlTVwE5SK5PGbKAn4kAiiIEF7gyWphCG6nLQ2cWO0P32rQ9BZVJwJt
 8LZc0/Od
 5XAlfh3Cnv9WNqjqAvjrYFOzShx6dOgzIvUfY9VGh95eXS7K0V1G8t5ACNXPsg1vcEdXM8evCG8P9iqHKbC6fgvhN6vg9nmsTMPXOWoiV35yKyX5rPpCNGrHqw+W8yasKpHZCfEkYCK5MSe6qfCP03eO0hXvunrXlODEHRN0nytO9W/0rdl/PGUBa4ekAndqkjCG3E08enH0Db6/z3PESUz7SpR+zXUnSAIf8t2yB69eyJ6ZwRhb8UHbBHf7+f+PVZeQ5GnRv3usk73Q5OQ2KxZ4N1DK9EpLdFWjxwOy2S5P5QdXnNya1FIeetAPVKv7uxhbJdAOIja11jBUtz7QNGDkYb1+2hcwVBn2UPqLoEOXualGhMmg9rhQVzJkfGGSBA1CkttOSiVWNf6ZfpSB04miQwgdjjpjlsHwdURjN1Vtk6txUMw3NjxZdidNH9aJ/gvCJaYv3K/9FKiEGZXf/8llr5wUGVbK55+dEbMMnxCTV256vI1fDJNPsPBoPLFtpHt0eABnI0wW4hxSnFxJRUhLOICdfQ07W+FgPJE3qypHm9WGgSnBVocvh+LBPkc3XPz/hZBTScF34RIm+MTJQiA6PC3OV2P2tCsiEI6gLv+ePo0HqBTF992oy3uoTPPEP1lkzxyzn+/+S+ZRhQVgqM6Gdroj7tC5am0N5oDA1u4O9zz5gxcQo8tNfXXsF5csZ88BFXas7l1KsZqLZNfm9ZCIN9auRXsvLzLp3JumT78RO0PSMBXSgaNZrSpJ8JYWzKNWNNga+ro1pt3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

The OOM killer only considers a task an eligible victim if its
mems_allowed intersects the allocating task's mems_allowed. The
assumption is that a shared node means shared ordinary memory.

Private nodes break that assumption. If two cpusets partition common
memory but both allow a private node, an OOM in one could kill tasks in
the other and free nothing the allocating task can use.

Initially, private memory allocations will never invoke the OOM killer,
so only common memory pressure reaches this check.

Leave private nodes out of the intersection.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/cgroup/cpuset.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 8401b69ee3da..e20f9ccb8ab7 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4628,15 +4628,19 @@ int cpuset_mem_spread_node(void)
  * @tsk2: pointer to task_struct of some other task.
  *
  * Description: Return true if @tsk1's mems_allowed intersects the
- * mems_allowed of @tsk2.  Used by the OOM killer to determine if
- * one of the task's memory usage might impact the memory available
- * to the other.
+ * mems_allowed of @tsk2 outside private memory nodes.  Used by the OOM
+ * killer to determine if one of the task's memory usage might impact the
+ * memory available to the other.
  **/
 
 int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
 				   const struct task_struct *tsk2)
 {
-	return nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
+	nodemask_t shared;
+
+	nodes_and(shared, tsk1->mems_allowed, tsk2->mems_allowed);
+	nodes_andnot(shared, shared, node_states[N_MEMORY_PRIVATE]);
+	return !nodes_empty(shared);
 }
 
 /**

-- 
2.56.1



