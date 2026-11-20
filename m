Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A17C606A895
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XUuf6v6R
Received: by kanga.kvack.org (Postfix)
	id B5ADA6B05B6; Fri, 20 Nov 2026 13:09:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11736B05B8; Fri, 20 Nov 2026 13:09:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 935BD6B05B8; Fri, 20 Nov 2026 13:09:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8FD6B05B6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:09:44 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B200816010F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:43 +0000 (UTC)
X-FDA: 85456285446.29.920F812
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 88B2740003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:09:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XUuf6v6R;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198181;
	b=R+kxOJHrSGWX9Sj4+WegZW0MwdcB/uoGeOTX9qYR9olJR1fNTRT7XCzin4+tcLcJ5VKBsV
	WCo+Yf1eNSmov6Z1pwvZ4sws3Fh32KyPNKikxBX8wjrmVi5PjDySZXSekYnXvbFWTIz2Nk
	ilGrJCDrcW8guC4z37vyZ5qr9xPCTck=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198181;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mk7QPfVqMmmgAD3R4zQbgdyE1K197Nq20BW8Qt7Ivvg=;
	b=6o3Dsf4Guh54CAxxTJizPArs8lGWUN+6Cslnj3AjhavCzkRLBLW5NxRdU+2wkXSvPwo7Q1
	ejMrZXkqdg4nHdb/Mxy9F+B2LJNyTp/vBFBNCo7vmSvQr6yPrs/lG9u+dHCPehwX7SxXo/
	fXkD0igY4hv9rtefiXkDFZe5Di7rmJQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XUuf6v6R;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E574346119;
	Fri, 20 Nov 2026 18:09:39 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198179;
	b=cLjR9FCv+pssdHEqlYT4qstPff0yFcwDG+RQ1KsGb+6f4/I+P8LL/4KFRA32JreZEjBB
	 gi6klBwUBJ6xwim4E1VdBHozVTb+5YAw93h+x0dYNj8f0th+N1F81lNsARPVH+AF7ngjX
	 KCGefT/y/kgxSBsw6g31WH0SAGxQXzRfa7XwEtIlhIS42qlSdIva5ObVCpnBEmJWQVVyt
	 cHdWblUeGc5+u64SRn6uTbETDXchpz6egRBqEs4zVXwDDFl7z1fIT6+VktxNW3KSk3lEH
	 d0cETtg3hwvaUCGj0fqm7flQPTYPDQykJkaBAFvsD5tKg1sstP4WtSkbzo6MfgHLJOA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198179;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=mk7QPfVqMmmgAD3R4zQbgdyE1K197Nq20BW8Qt7Ivvg=;
	b=KtS0VS4ERObgphmeHO3P1SDMoBmK6Nz3z5ep4g6HcPJLIl5U8WDgCGibJ5IrKkXX+ohg
	 gqbpu1my73hCJAsRjHEFHTDkPb+8F0FlrLfC7NeVaLrr/d2jYRO/jqMJY/zcSn/SeoQ5E
	 0aYLrVZOnpBYRYBLL9Ky8lYad+ZZG54gbBOU3BU5rz3nAkqSHXAWO4Ftp8KIQwSh9Yio8
	 HikZ9biwl3e4/ZPJcp16hGlAy+byLwTI9H8MKc5d04JJdEiOpCB2crV3VRWYEB0EOl3dP
	 77Fs5D+5WQzrF3Aicf8bynO5hrTbS33+gMZI4T4Zzs4pUjCJ8BlRB3QUEWl+AxrRm9g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B06B01F000ED;
	Fri, 20 Nov 2026 18:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198179;
	bh=mk7QPfVqMmmgAD3R4zQbgdyE1K197Nq20BW8Qt7Ivvg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=XUuf6v6RKAYyywHFhXhXEBkKQEWS+sE0WgXripvyWzwe5W+MURXtRMNDnNCqBW+Wc
	 0f8fWW3gxUBqhwl94DSGWbKvGXLrQ9hnFzv6ez3PkUbVi2kuVXAYmJxLaV9uBPeeAH
	 FTNbQ9ME8Az+mpOmkHg50g4Agzt/sggMV6LplPkNpeFgoO7QFTtjg0aRtKlPBRYPXb
	 woYp1/KJY33QTIGIp7NCVmYeP21x/qZMQkrK+huueJXthUbjEm1foMJVsMOWuie23C
	 7k9vEocxb0s6DSaY71fH5GOYz/NygkwZzuMRIxhM+7jZRlKHHpxOcWj7SVSCrvu36f
	 hrN+h0tFXPP9g==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9A5DF4B8D5;
	Fri, 20 Nov 2026 18:09:17 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:08:56 -0500
Subject: [PATCH 05/60] mm/mempolicy: keep interleave and tmpfs mount
 policies on common memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-5-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=4176;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=9bmcZ7R/82zTxF1Qtk/yGZ6mpKBsveqW+bL1srzM0FI=;
 b=rzt6Q/QHsAoNZY/tZYjwurSoHivRuidMYKiNejInoFdn5cQoQErCHIyU+a6IoDegA4QyBS/88
 XEWmHXW061WASp1v7pEQJTOmJKF7N9mx07G1qUrotuxRGHzVHQJXqtS
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bpfgy8ixbzea5z9bn6gnxe7pjjckdqad
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 88B2740003
X-HE-Tag: 1795198181-516779
X-HE-Meta: U2FsdGVkX19eTKvkqAf8o/NFSliNkdVf2JoyUDoGBANC/XVpq6FA+wDIO8G8Cefwl7rkwok00QLB/D6Suo7jK7fqcZjEB4JmHNxKtSdnxVRZKHXKHZeR0sKPhxXUb5PaWr3mRuEHl1otr4Gxb9LhpSfjNMsAB7YIGbVlsP7miGKqGtv0acMFnosh2xRVZGpIk6d7eS3q7MqQwttPDNTREtjyThi7WwjecFiCWrH1fvytTqU2/wrGp8CoBgqEKKXFTiQDCm/6yw/6h09CWpZBq8cv0ShdTikjZFrmdyaS1jDBj1BYHC6GrqjNfX6ZQK5bZlTVk8DEPacwcBBuO+cZhvQjRhiRABkKmfSEVJbwSobNUNiXN9GMGGXN2gIfeM4KDKeQUJL9t5kY5cEFVbpcyjowcE5DSi7ncp2jIz3N7GPZ4RmSnAS1OAfRUMeqmA/jhZ2fAWzJbxOJAQn68DiXnpwmZaWyl+WdTKHdTZvlUkMquYKESzFjNG90kHqZ9VKbxKPhPCnq3gvl+cVcuSx7YWQEdBgW75f4cknzIELEJw1vU5/jzIGeRQhRF6KROn50fBPTlC/3DL5i408nxIpV7DwBCw8RFEeziv8fcqR7Xuyj+TCIAzaGAXu/OZmzGPKZMty36eAmfF77BWIzLhp9ah0JRjG7G4kb+b3cAnbpmeB1oRVd8zIeR0k31EI67afhwIx/lBysHWLMhe2ltbWBM5+rgdP3y0lp2oHuMvds8tkOBtxrpAAW5jq9T8Sm2SRon6FFkzt7Mr8XqrtlKWaanVhU8/RcbmUposKnEPdAyuR9P5Zxt66Fx3pBa38eXWpJcVxrxIY6BReXBZhVvNGfpUkcFew60gx16A/UDPTUa7enZQgiEVu7kdeKbBlKBJW5QsZwAXsT68fb8PAkpUNHZOskHJzumsrBZzkEsrQIbE9M409wibSCoaz9U1Y5GvQUJjQKvaEsPvdqhpD1yND
 7ViDz0Wu
 LbG1KK1hmkJgeEhHLNmwD3aFgow5iA38oAVTWyPwQLcz+K5l33Fygn9mqmEDcA3sECBvLtAkS/tjg4yb622l/nl8Z0gJX8qGgRW2E5qQsc5bu3LMcHQS+dqhYEx+RSN1IRrWz1/cN64HXPmk8huKE6Avxnjt6YB2zoAA7XDHYw9bf3Vbobb5eyH7C6bO6jFcFxPa16WEBd49N4WGQEbTChjxBMzr0yX4Y+cGM5AlDyFNauvF76vMHAlciryl8VpZZ0q75LVEABqZpF+v0owR+v+uK+Ujy3nDllJnuD2opZ1v4P58hdC5faZon4x1IRkWvBfXmwqPFwr5ov4CMZW3lHhRGbl3Vu4dRC6fyh8nJEDSR6iz6G3Z6Rt8hZfcTy/P8wNX6NLFbHjJ24aLnFBYYqvqckjdjI6HPdSBLKeHbtzpaLqAnvvnT05InYVDBFgaNW/2tWwvEeytYcfeJBXRB1df0ssfyPzt+8n1VpIIHIwYoz4WzK6WUJy2mIEEoPDFjUYhKueLk1rBRtQSTIxy1H3NJz+2ltKoLroNMFJoOINm6epYLGYFHxRQT6/H5WK5s3zk7ro+7cbep0ix82CfHQYRSQp3t4JlhdQhAoXf0t5jSHyz8bxU5+Hb92jDP/soMTVdI2WwcTjF9G0dhXxFyR1/nZhniX5G+aJt+tjoxHMsdcz7hwC0Axe6HXRiQoaEeLCtUrMW3rDivCO0WseRJSnCi8XHenQhVvo9EcBjANRZORp5c4++INaQFBXI3tVaXXjWtPjKLnZtCuNM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Use N_MEMORY_COMMON for boot mempolicy calculations and their per-node
sysfs entries (weighted interleave weights).

Restrict the node set mpol_set_nodemask() applies to set_mempolicy()
and mbind() masks to N_MEMORY_COMMON nodes.

A tmpfs mpol= nodelist must name only N_MEMORY_COMMON nodes, and an
interleave policy without a nodelist defaults to them.

Later when an N_MEMORY node is omitted from the N_MEMORY_COMMON set,
they will be stripped from mempolicy nodemasks as they're not eligible
(similar to memoryless nodes today).

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6f800fb961ae..806577e1d48b 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -213,10 +213,10 @@ static void reduce_interleave_weights(unsigned int *bw, u8 *new_iw)
 	int nid;
 
 	/*
-	 * N_MEMORY can change while wi_state_lock is held. Remember the
-	 * nodes contributing to sum_bw so all passes use the same set.
+	 * N_MEMORY_COMMON can change while wi_state_lock is held. Remember
+	 * the nodes contributing to sum_bw so all passes use the same set.
 	 */
-	for_each_node_state(nid, N_MEMORY) {
+	for_each_node_state(nid, N_MEMORY_COMMON) {
 		node_set(nid, nodes);
 		sum_bw += bw[nid];
 	}
@@ -439,9 +439,9 @@ static int mpol_set_nodemask(struct mempolicy *pol,
 	if (!pol || pol->mode == MPOL_LOCAL)
 		return 0;
 
-	/* Check N_MEMORY */
+	/* Check N_MEMORY_COMMON */
 	nodes_and(nsc->mask1,
-		  cpuset_current_mems_allowed, node_states[N_MEMORY]);
+		  cpuset_current_mems_allowed, node_states[N_MEMORY_COMMON]);
 
 	VM_BUG_ON(!nodes);
 
@@ -2104,7 +2104,7 @@ bool apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
 	 * if policy->nodes has movable memory only,
 	 * we apply policy when gfp_zone(gfp) = ZONE_MOVABLE only.
 	 *
-	 * policy->nodes is intersect with node_states[N_MEMORY].
+	 * policy->nodes is intersect with node_states[N_MEMORY_COMMON].
 	 * so if the following test fails, it implies
 	 * policy->nodes has movable memory only.
 	 */
@@ -3398,11 +3398,11 @@ void __init numa_policy_init(void)
 
 	/*
 	 * Set interleaving policy for system init. Interleaving is only
-	 * enabled across suitably sized nodes (default is >= 16MB), or
-	 * fall back to the largest node if they're all smaller.
+	 * enabled across suitably sized common memory nodes (default is
+	 * >= 16MB), or fall back to the largest node if they're all smaller.
 	 */
 	nodes_clear(interleave_nodes);
-	for_each_node_state(nid, N_MEMORY) {
+	for_each_node_state(nid, N_MEMORY_COMMON) {
 		unsigned long total_pages = node_present_pages(nid);
 
 		/* Preserve the largest node */
@@ -3474,7 +3474,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol)
 		*nodelist++ = '\0';
 		if (nodelist_parse(nodelist, nodes))
 			goto out;
-		if (!nodes_subset(nodes, node_states[N_MEMORY]))
+		if (!nodes_subset(nodes, node_states[N_MEMORY_COMMON]))
 			goto out;
 	} else
 		nodes_clear(nodes);
@@ -3506,7 +3506,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol)
 		 * Default to online nodes with memory if no nodelist
 		 */
 		if (!nodelist)
-			nodes = node_states[N_MEMORY];
+			nodes = node_states[N_MEMORY_COMMON];
 		break;
 	case MPOL_LOCAL:
 		/*
@@ -3901,6 +3901,9 @@ static int wi_node_notifier(struct notifier_block *nb,
 
 	switch (action) {
 	case NODE_ADDED_FIRST_MEMORY:
+		/* Weighted interleave spans only common memory. */
+		if (!node_state(nid, N_MEMORY_COMMON))
+			break;
 		err = sysfs_wi_node_add(nid);
 		if (err)
 			pr_err("failed to add sysfs for node%d during hotplug: %d\n",
@@ -3932,10 +3935,7 @@ static int __init add_weighted_interleave_group(struct kobject *mempolicy_kobj)
 	if (err)
 		goto err_put_kobj;
 
-	for_each_online_node(nid) {
-		if (!node_state(nid, N_MEMORY))
-			continue;
-
+	for_each_node_state(nid, N_MEMORY_COMMON) {
 		err = sysfs_wi_node_add(nid);
 		if (err) {
 			pr_err("failed to add sysfs for node%d during init: %d\n",

-- 
2.56.1



