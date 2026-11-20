Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 494BC606A89E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jh5GN+ux
Received: by kanga.kvack.org (Postfix)
	id 42DE76B00EF; Fri, 20 Nov 2026 13:09:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DE5B6B05B0; Fri, 20 Nov 2026 13:09:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A67B6B05B1; Fri, 20 Nov 2026 13:09:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E96686B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:09:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC79B8013D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:27 +0000 (UTC)
X-FDA: 85456284774.06.6D14B99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id DC4EC1C000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jh5GN+ux;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198166;
	b=Zr7+vY0RGLpB1RrALi+AOEfpD2LeAkT6Kbp7ir4zIamRXCLYyy6i82lbDazDOVLGo27XpQ
	Inse8zZd8ZXj98SjnQqaHy2AmOpIASJlwBQdOLAUMmg+23gYcdCGK/WiCaGndAB2IsdndD
	2Ein8Gsjf5ioblZLQ0cOACdmY9zvgfo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198166;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTsNDMBuz7zPhiY5EdCthhkTLILbhAv/FdI9gjXNQX4=;
	b=Q1IwRTVlxtr+B+JhxDxz/jQrgYtAwOrPPqfFYrDL7UK6mumfwz6JCeM/JCeyfr0KTBf34Y
	2tRYBVcnjBZqZSe7NVKQ35PTZVNS68lXDURPj19Rbwarql5f3wuA3jR3cBe8KHpGi4q76O
	1fBUehE4/ix1bTgWwrQICehASpKea/M=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jh5GN+ux;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4082362C8D;
	Fri, 20 Nov 2026 18:09:25 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198164;
	b=Pb1cNhPrLRK5o3rm/ZIOHDoo7AbwIMdH3Px69nmobYdBmOLFhjxNvYWSJO6OqsgZ2UMC
	 L2vN/krldQgsaIKf9thVmYjgqX38hHRiDexuiGFZApSrp1Z/+nbBWeqJI/jVxtR6Lf1bp
	 KwuhPewoCcsDnjztLNhfcUR/3cYUCaxzCbCCGJuCN3SkifftRSOJHoNOp3j6aB3XPlhph
	 ztyhPFC3s2STk5lzx0qnql1LzMSU9uhA/8p65k10DiTgfL1x+6VVSu0ykM8DG6XMbH7IF
	 VcLucL3ML2n6yHrnPCrT5V8bySDZ4EbNL6rYTMQNCOB59FIN4jLwadfQjwu7e5AdtyA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198164;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=NTsNDMBuz7zPhiY5EdCthhkTLILbhAv/FdI9gjXNQX4=;
	b=s5A/gAWj6Gfnyub9Nt12UKkyEZ5OgFO8amIKw2ImfhQ8yMcLbu924CAQSJdGTVIqXAt0
	 av0dHAoO1WnusCJm5I6Ar4NwZuUsLfN4qQxyCQ9NckdF5c7LC8UOWCWOyvLK/N39yurZ+
	 8nKizErlQ7UlAwEOaZE2AU/NT+hocdzL1b4kt4C+/SUrTTLqV8iyo6knCu4LL8O9mROZi
	 p5gh8HjeK5BF8laHg7hXf3VVHsvcmv+bf3vKnCcKSszCUO5Cds8n4GmJ+Kzs5pwIJHpiJ
	 zv/ht4nTrBnAWahS5c3XCv6F0ODaIzOP+lY9GXKbPwS5k6byrtHwn9lPy719fRYwe/A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9D9E01F000D0;
	Fri, 20 Nov 2026 18:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198164;
	bh=NTsNDMBuz7zPhiY5EdCthhkTLILbhAv/FdI9gjXNQX4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=jh5GN+uxVR2sfEtkcWK8V6gCtzFbIr7ZSDi3uqDtQjnOc4BRSE4HFb3FjeCsxuXvf
	 PoP8ypb1dY7FdYXdV0HX/EMeTmBaMRFhm6rf12fzO7CES7UcrJK8K4wkuQJ2WjEtsl
	 LrBfd8c042HBtziSx00+vWtfPoLFbefSc9O29y2pWHeVX/UUCEe+3iitW6nVkrociv
	 /rwVW1LF34H0vZZAugKg0GVR58A3FNiwKzC6r7w0wpW/MIM2STEy0hbTky7IoqmgUb
	 YRdMwXW73pHSmI1RRzb4tKxTvnYiRFG8M1WEmwMS6oIyKjnQw54rfgaMIN8YcFITw0
	 uQqCsfUHDYf6Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 26D6D4B8C9;
	Fri, 20 Nov 2026 18:09:17 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:08:52 -0500
Subject: [PATCH 01/60] nodemask: add node-state iterators
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-1-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=2119;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=G4ssD0bod7vgjZxwR56nCucNo1kgkEnObUnor5Z23Ok=;
 b=RjAl7uvfEf4NqVkoeEx7BN6LIu7ylgrHkEUd9mkFu97o60NZ4EyCUrePrl7IYTdG0pVE3cvIL
 Tfn22wnQtSZAtJ0uk4weMboEXWaQLw3lMEAfCsBn1GD/x5mvmm8mTel
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DC4EC1C000A
X-Stat-Signature: 7em58nz57ihmju919wnaxeogix51q9be
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795198165-657678
X-HE-Meta: U2FsdGVkX1/pHEBiLlQZZgG9xjziyDL9wABoAUQcBRXWdfTFPI7nQFlrfxMMEt7gho+j2YDHU/yie4JfWyzmknhBnh4qA7UkP0bdXbIIff/Qcva3Af7U/XN4I04iHALmnp4hqxgTKOL/uy25CMTx6/Y/e8kBlMGAY1/e/4xh5lo7NzuutNOoGWpoX9ouwIa4/5WTxsHkBGnguwcxDObNMthWl//E0NcdfUHwSe2B7A3zqPOszTrDpF4EMSly28uCnJOKbmcvf95vJBl6KRn0GYABYkEhuwqH0Cws8ahfGlB3CNTs5CRh31/i3eoPOv/n+MatZkI9EFZ58DYmYtP1gCjHy38512Z/sAtAWXwlx+Z6Q0/iPgEJ78P7sIL5qiTQvt5sTsF91Ephe6p5B5dRWN2bqCLlmqg3kbsWKIBQdPLGJdMNk9hb4uo+OZvRIWSsi3D/C7DP8ahMzg40aY3uhfDbkK8FpABYGtVWO0lSLPwWgmr5sBE8lC2FVDbC1jCzY1vCr/pcWbXlHFuRj88Z27VEpR/JkcW1g8c9z7Qd6dyi+CAZT6Oal2WxTCOjyvZKxbBwo64TljVb5BBn/Nw1+KpGsYsplaUZSkRjfRWZYOFq2XIP6HeUiPp8XnvG6Yu1JLfB7P1O4uIrZ9yAIOAoxuJBZ4SV4MibS7rBSjLkjnzgG5vCR1jOHqBvTmNkK99mzeg/UzCorl4fWDDfg5U1PZcLXAuRJaAsJ0Uh0sSsx3x62cSZySLgAQRsJ1NZhMbgvJP+8oSaVU8P27yRu9LbMjJQF6woP3m5uMaSgDvOXT39kV7CckuKXnLFkrXwbwO+HL+DDsCyPLiTd+9k8beaUdSaN25PaAVHRPezi4mA439mKpTqtSRtC0O3gE07z0XEAdlWfg50y9/7i0Nb8u6rB/szxxi7oqatZQv6dJIHQgGjKE1ubXLIcB2bJg96Am+G6ock3LZfRqkixYUlMwg
 BQtrjNJN
 TvQAeS3ON+RoSBMx7bvOJH5SxL1X9SMKSTv5PPtA6POTK8Qx/REu+PJM7arUWHiZgIIGpsmW2xRbxirbDJwg+YD1nhDr2VMOpakjm9Ghko0L7DDuFQ2qogm/moJ4bWUKn7IwMuy425Y0CNwTl9cgR84FENEa6JkS7mEhFb/P5Ji2GYv29He/1eEoz7YHHVSA2QBFAu1sByvE6IijkrOftJYfDJScjj9xXqBAAzQAAgXuoVXVUEa6z9Mxae3rsMbBPvivggig0+h4K/a5ahfbg+NKIslvWCSdmRcJImejvz3qhnsODldTLwmSFGZ/3ksft81SYs4rX8iiqHxJjYThyArKdAg5lWrzD35C22vv74vfhymJUUDJqpV+oLBvhQ6aimWiWA9iUagVWmyEW0gXUC+BTgVyyu0EiLDfuc8NnMF7tdJqXcx3p8uyraVDla11z6+EY5OQjHbbe1FY1Cq9B+NWCAeRjuB/k4xBBFuAidVMLjl6VCrMenVt1Rz96LtubLrMkdqA1TGFIpMlpY9NHlVu/bifLFxKXZ1v9yM8etTuGP1Ubmb8yYTgNQY6+M5wneK2xpl3hI9GHuScLwqGnRyM/P++dRCBTIYEW4V/UwRnBpaKaRq46B96Z9dOLZn1Zv9B/BBcVHagKf4lQC+4antutqGgblBHX6P08wBfSKzhgxpyBvKviqMXgN5OtQxmdG02APOq5d+rm/+QUqHD6Vngy5kcELLnjZSh+6iidw8NodOOzcSj7k/Dxxxu4nZFXczCMRll1S2DanQ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Add first_node_state() and next_node_state(), so callers can walk any
node state the way first_memory_node and next_memory_node walk N_MEMORY.

Add for_each_node_mask_state(), which iterates a nodemask intersected
with a node state using the bitmap intersection helpers, without a
temporary nodemask.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/nodemask.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 607373bd83ee..90bdcffa42ea 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -411,6 +411,11 @@ enum node_states {
 
 extern nodemask_t node_states[NR_NODE_STATES];
 
+/* Iterate the nodes in a mask that also belong to the specified state. */
+#define for_each_node_mask_state(node, mask, state)			\
+	for_each_and_bit(node, nodes_addr(mask),			\
+			 nodes_addr(node_states[state]), MAX_NUMNODES)
+
 #if MAX_NUMNODES > 1
 static __always_inline int node_state(int node, enum node_states state)
 {
@@ -435,6 +440,12 @@ static __always_inline int num_node_state(enum node_states state)
 #define for_each_node_state(__node, __state) \
 	for_each_node_mask((__node), node_states[__state])
 
+#define first_node_state(state)	first_node(node_states[state])
+static __always_inline unsigned int next_node_state(int nid, enum node_states state)
+{
+	return next_node(nid, node_states[state]);
+}
+
 #define first_online_node	first_node(node_states[N_ONLINE])
 #define first_memory_node	first_node(node_states[N_MEMORY])
 static __always_inline unsigned int next_online_node(int nid)
@@ -481,6 +492,12 @@ static __always_inline int num_node_state(enum node_states state)
 #define for_each_node_state(node, __state) \
 	for ( (node) = 0; (node) == 0; (node) = 1)
 
+#define first_node_state(state)	0
+static __always_inline unsigned int next_node_state(int nid, enum node_states state)
+{
+	return MAX_NUMNODES;
+}
+
 #define first_online_node	0
 #define first_memory_node	0
 #define next_online_node(nid)	(MAX_NUMNODES)

-- 
2.56.1



