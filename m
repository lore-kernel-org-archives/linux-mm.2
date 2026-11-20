Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9536C6076C4A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dUvCsQ4K
Received: by kanga.kvack.org (Postfix)
	id A57E36B0612; Fri, 20 Nov 2026 13:17:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F6E6B0614; Fri, 20 Nov 2026 13:17:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE346B0612; Fri, 20 Nov 2026 13:17:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 639AF6B0612
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:17:14 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8CF380138
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:17:13 +0000 (UTC)
X-FDA: 85456304346.29.D490D1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C43EEA0004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:17:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dUvCsQ4K;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198631;
	b=Up968hC8ttgqCt+6jRSsaXWvd5rFzza+LSSBsJth7n7TxKnmn2PhAFdgRtjcpwd9digRNS
	MyWCpZVb8SH/ZhZpVeIdbzz+rkgQIJHXOhQo+8pRgjOVkiqC0m4iOvVihCMv3jzzGTiPB4
	busxxqP08Z11xUC31h1klqqRggE0Fqs=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198631;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CKVNPICIuJeHboZhs5//ylGkrISPeWolkQPQ1hYsQP0=;
	b=elDYrTaGxZclS08DbNzHHvxbzWTJLwL1h54dMO/79BxCeCPMlpERcP+hDDWAg7Pepi+diU
	QJsxUdrumdCFRqu29xuEm/YjIdVBrqWYm/fgrN7cILum3KjyBJgYPybNCG5MHIVK/Twysh
	q6pBiS1Sn3mkqNBw56iinjQvFr5TbcI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dUvCsQ4K;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CFE93633D6;
	Fri, 20 Nov 2026 18:10:02 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198202;
	b=cdyLUEEyJMgMd169rVZBNL73X6uH/V1pbNoZTaPaebFdXaBaiuCeY1ix9HxgesXz+OqP
	 dmRE9LDdi8MCcGwNN5mX3Msa6Xra4HgS7oc+thfk1nxjtlGNO/iWjnQwe+rK+KYu7Wk+D
	 Cowe+x09dsG2Nv5WmQZp6HR2hrsM3v0PbGUcflt0rdZiMPzOctji8MZkYlDLtUTOCjSBd
	 2kzLUHwHA3NVmQGIVsi1O9GgNdeN1+wPvSYQoEtDqRWKOaHFVoxo8lO69TDn6T6QQZAFy
	 BhW7n89g2ct2vHY1PLSL9XlGiKx8cfdOWlW9hozU476Rj/vgXN4Km720yrIysNw7G4g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198202;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=CKVNPICIuJeHboZhs5//ylGkrISPeWolkQPQ1hYsQP0=;
	b=UD+DgpOhajsT+NBcGaFmkuOjplV3M0dx0ol2vR5qRS7cVKBcSfw2AedxLrBctIMBqH8O
	 HXKyIZU8Yh0lCOB+tNinQjrOR2NJ3xAXQc3FLso9cJwTH8sxkl+es1pqEXqdxGcIXFg9S
	 Usd0rSL52s8qBX9RsP5ESjch3Zw3oR+1a9yBLdnf/eRvsVuUS4Km2y1jqep6w+vZypyR6
	 Ws7IMXQm0IdemLZER7HbHqOAa0o3chPMgtIUlssx1Cvtk+nTE+pd4GFpLhXKFEuuypmR/
	 f/ZMsGW8cUst+GUobHR8KFZ5zVoAyQWNhj/+qLOjOkgje1dbHn0mI+8gxrhZP2zU69w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6A3E51F00A19;
	Fri, 20 Nov 2026 18:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198202;
	bh=CKVNPICIuJeHboZhs5//ylGkrISPeWolkQPQ1hYsQP0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=dUvCsQ4KCIcpChtNknOroiBFXxiIbcefIJIqj/b3RNA8/RmynFBbKMTQIug3X2CsP
	 7PIK3HXvziA+JoefEvi4nwphMSQmdxIjznb9TC8xfLAFwAHhMEP0MnP+xUapW5ywHG
	 OZzZgblF9glc24eHwbVOSdVTbd5tpW3I7MY+k4eBC8TLppNdgS4TU03PjhjxZXXMqD
	 O40wvFph0oDiEt5AOdDozOkoq2PrOiQydAZiRyV0DZMLLdaEwZOKevZghL33UOITHB
	 HpTs/givE1RnIa6cq+nfnGpNI+E7+5MX17ju8SxvOmKkv8iXIKEm4hN2vrhm2qyWIK
	 dIIrjXmb0TjoA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6A6794B8F1;
	Fri, 20 Nov 2026 18:09:18 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:03 -0500
Subject: [PATCH 12/60] mm/vmscan: restrict reclaim to common memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-12-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=2825;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=FtLUhP0wFF5GfqO7k4obSm/pRyOe/gBL2Z3quyWtR6I=;
 b=zwlm1U/LcEdr9egylwJhEu7nOZaUODHcksIlsiJlCATY4Fbl78/BXLfyNjSKWv3UDT+qsBfSZ
 piPbYWcP1rrCCLgsKDDw4afKb7rTwG3CyQeRdlVm7Foh4LeK1/sZgiM
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Stat-Signature: anu8mpg64kxk3rfm8q8seexmcnmmb7o3
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C43EEA0004
X-HE-Tag: 1795198631-950174
X-HE-Meta: U2FsdGVkX1+5TCVrqhxGh3+n3ED1+eYIzSt4R7eUdjY7HGcxKc+6DOf2T6DMJtrH6gbVHNrtmwDN5ZBSqRjcZppEHITUnnPS9V8kvgL8WLtp7y5Q9mrrKbmeL82jFVthx7nSMYNiR2aws/L+rejJHY+yDc4YWRLeWtiWTr7Iw5R/RKFShEpQuZZcVCgnswQubcvxdOmQLWs/3K1Jup6yXKo8eGWn/ht1NI2gu1pIAi/KWXJnc1/WIwHbsG9QUmnnQWsuFaSy/j3JE/LTTpxf/oTXeDpLMQEjLe5VmhqwicCMizXUyJA+Y7fIYE7SGcCK7zf6QgQ1EL4A3CzuQbol5y+bdlfR97YdaPsUxOofBt0t95GqkXJSyp6dltuBLQEhUjYMUwymRUrFhF4l645+tMMPVblwYlN3xMIIfLg95lJj3ghrOAAkUisc9XM6NqX5PtRyhLriLONuKbhoTfdl0/PpnV0z0t/7ek5ykRSvQr7+neRjf8gQhPqcpxXxsqnnx4lc1bDWooYOMTT+Sm1LMZNhhuRDN6r42qS7MOVi40RIAo3qQQfnLpT5vamb/RZ5hN73pSv4c54ElFO+h1924eZE9YBY7pMW9f31Kw2kfKSFn18a7sm3s3gSLKc79E9EbKcGbwqptNQYlwqfjTzjaFNHVaSVzRku1bj/6P8IrgYjW6gckRFLN60Cv4oBdSuKYz3txZCOg+PZO8/M4jIcWR+RRuKvbW2ZvXpFdFMSgXItuPUF+hzG+m1pY9HfN0mKrO3/TyHMehm4npIyTqz5b7ioeVeU8T99feOGMNJ8bSZzX8GwIZV9H4AFQXlZFwwltFAFldoLFXzKt8wOqCFsS148ueG/sW3chLNu8vkXDAe8ZV4QZiKU17XF23sGeTiHLDCsljC8f2IxDCPHMtMD7idivIKdJUC6JnMrwjnF6r8wGwfFey6RTd5Pi7d6T6f8F1aTHp+A3UVyi1aGLYC
 QPlMB3Ih
 ue9KRkyLZeik3itme1FSVS/LvVwxLL6xiAYDB1fFAx4SWUwpJFwi1oGkACPeGrnzvEXj1yPjHpqYpSjMGBKrZEfjrhYwFFshpVCypwiQY/LniSWTjj0FK1F1Na0vPxNN/9ZFWl9+gqBhWBdG6uGV9sUqvjJ3qEKOn7FKaHmzyfsveU41lUJ9kNBem6ewwWIwCP4anHijv0nlxSBlFoj3iSYQtNoCLOQIV4qe1b2tyxf58BvUZX8d6nxgKCX83tr8wdk9WQAF4rD/HuDlwpSKoQ00BEqfG5XUoD0LtPPRh/B11kWq3BW/jYj2fbBMBEDncFbbu5ESq6HYh/NpIJXpqWVq77ciMi8pT448pkpGbJUop0XWPcoPSpr1O+TUKKzbFfSD25l58oDFTvHl7ozvMgB0cFZajpqG2TY1SYfmN35QaNWskAzyoqAyTRf2a3TG7iXKI+pTEOw4MJlIM08ommf2Xmgdmwe7ABBsO4qiJ461YcA33CWjHV1UsO8HG8FO2HyOkRVWq7QgFupxMMTeljiuo67kTNYmfHr+Uc0YpMW6FedbMZ2f0h+KKXPMrARPKA/+veaL1Hn/ng6PjUivLe29h99bxp9aazw5o/UNa6NzAja4PPlm2HoRXEhFFzdxLx4SktU3PceW3xWt+VyU0PJuOpkrWazL/PvFerDWgQfZ3n/rts+pMQz500K6lYpkVLbbZF/9HmBFD1Usge5UV/bv1cIdaMEd3JiI1Sw/UIiJDC4Gm62V/T8AMMESPvJymh6z0mwvyhL/kkbc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Reclaim serves the ordinary allocation domain.

Restrict it to N_MEMORY_COMMON:
  - start kswapd only on common nodes, at boot or hotplug.
  - walk common nodes when MGLRU's debugfs interface iterates or
    validates nodes, using first_node_state() and next_node_state() in
    place of first_memory_node and next_memory_node.

Direct reclaim serves an allocation from its own zonelist, so it is left
alone.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/memory_hotplug.c |  3 ++-
 mm/vmscan.c         | 12 ++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 1d3d1792074c..a599fcad65d3 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1222,7 +1222,8 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	/* reinitialise watermarks and update pcp limits */
 	init_per_zone_wmark_min();
 
-	kswapd_run(nid);
+	if (node_state(nid, N_MEMORY_COMMON))
+		kswapd_run(nid);
 	kcompactd_run(nid);
 
 	if (node_arg.nid >= 0)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bc7579d47f9b..5b53e0391d80 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5729,7 +5729,7 @@ static void *lru_gen_seq_start(struct seq_file *m, loff_t *pos)
 	do {
 		int nid;
 
-		for_each_node_state(nid, N_MEMORY) {
+		for_each_node_state(nid, N_MEMORY_COMMON) {
 			if (!nr_to_skip--)
 				return mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 		}
@@ -5754,13 +5754,13 @@ static void *lru_gen_seq_next(struct seq_file *m, void *v, loff_t *pos)
 
 	++*pos;
 
-	nid = next_memory_node(nid);
+	nid = next_node_state(nid, N_MEMORY_COMMON);
 	if (nid == MAX_NUMNODES) {
 		memcg = mem_cgroup_iter(NULL, memcg, NULL);
 		if (!memcg)
 			return NULL;
 
-		nid = first_memory_node;
+		nid = first_node_state(N_MEMORY_COMMON);
 	}
 
 	return mem_cgroup_lruvec(memcg, NODE_DATA(nid));
@@ -5832,7 +5832,7 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
-	if (nid == first_memory_node) {
+	if (nid == first_node_state(N_MEMORY_COMMON)) {
 		const char *path = memcg ? m->private : "";
 
 #ifdef CONFIG_MEMCG
@@ -5935,7 +5935,7 @@ static int run_cmd(char cmd, u64 memcg_id, int nid, unsigned long seq,
 	int err = -EINVAL;
 	struct mem_cgroup *memcg = NULL;
 
-	if (nid < 0 || nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY))
+	if (nid < 0 || nid >= MAX_NUMNODES || !node_state(nid, N_MEMORY_COMMON))
 		return -EINVAL;
 
 	if (!mem_cgroup_disabled()) {
@@ -7907,7 +7907,7 @@ static int __init kswapd_init(void)
 {
 	int nid;
 
-	for_each_node_state(nid, N_MEMORY)
+	for_each_node_state(nid, N_MEMORY_COMMON)
  		kswapd_run(nid);
 	register_sysctl_init("vm", vmscan_sysctl_table);
 	return 0;

-- 
2.56.1



