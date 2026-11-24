Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE4A606A681
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 00:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=L1AGF+Op
Received: by kanga.kvack.org (Postfix)
	id 555456B05B0; Mon, 23 Nov 2026 19:04:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505996B05B2; Mon, 23 Nov 2026 19:04:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41AD86B05B4; Mon, 23 Nov 2026 19:04:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 18BFF6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:04:54 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5AB4F120A13
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 00:04:52 +0000 (UTC)
X-FDA: 85468066824.02.5B3AB66
Received: from mta1.migadu.com (out-102.mta1.migadu.com [95.215.58.102])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5918914000E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 00:04:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L1AGF+Op;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.102 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795478690;
	b=rzIFBNuV+AyRaftEZ6LDpkgzo3YlSH7NhvJSq08N2fmW2XJLYXyjnycEHuCtmrEtDoHamA
	ISURCDEKh/V8c0KfPRdA8bOD9gSjRMhFe2UY4xvdcHiCUDzjU/4NZsrf1jzigkg1UA2rnh
	5NQZvLe/RfffXB0u98UbQV2Ap3mvP1Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795478690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Vj6rX/08YHl+BRfiOlA4IKO7KmtpRoLD3xe6xszFx3w=;
	b=xCVS+hmxdufeZAXKMH6+CZdtxTr+fxSzOqRglSQqR1aetLudppog9MmuTxMIP5RqCC1p1P
	DglKxbKkwijVFuk0xwBeCMpfRdNPHpqhRkoAZBsscGnR38rKCyV7kVGTTEjsaeZPVJJ8Za
	69MHySMZm3ahpxPN1R2guagypphZiqY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L1AGF+Op;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.102 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m3O6JogaMnAWcW2J6tqEKYwa71B3rZOaHK/s4y8qPEg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795478688; v=1; x=1796083488;
 b=L1AGF+OpgYxYHFwN2ndyQIJnk7W/HiPb7d3D4ikfrBzyNJmILt7Hqw6AIhCODTSDjUbckT3H
 8KQd20FS0K2U6ZmbJ+pbr4Xd3bBC57Nbqm1MLIOgijHJBY8AR0NZQ0JKqAQNQ856ow/Po4MY6xg
 ac064SLCWN3qDLXhVFL8kuls=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 511bb6528f3e081a;
	Tue, 24 Nov 2026 00:04:48 +0000
X-Mizu-Trace-ID: 511bb6528f3e081a
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] memcg: free the private ID of a memcg that never comes online
Date: Mon, 23 Nov 2026 16:04:39 -0800
Message-ID: <20261124000439.967403-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5918914000E
X-Stat-Signature: zw8zeg13sqk1c7tid8em1f5991cr7qoj
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795478690-842828
X-HE-Meta: U2FsdGVkX189hc59CPh/HIL0GC31UYVfQzomOpop4bIKzTp3bwAF0I3zWI+k58rwWPudQkh2EjDDJilMjectA0M7tWgRQ4qi4UbKsLia+MSoHnQ4SCghF1U1rl07z0CbNz1ZPe3ROkVZ591knOTUMRnAyq+cybgiGOKs9moyiu9krfHeqGrlLXFqPHlExMyDuIXK4oSMNaj5+J2jbcoeTnwWyT4sx84oitduSxdy+r4H5hucCI4zNyHIRJyR9f7SAoBQpuYLsYez3RJh556MgCsXg8OLaZ4WIevKo8iBh3X2WWaDvAxn25qiIiF4P72kdjfYC0SPLYr4YAh3pZGDpMF/Xxk0yWJ80crlFqBLmFBoZV4umSiIK0l7qJrCjrH3O2lx+6Al0fw9DZHsHA+oO3w6McxI/1mgUZCCJGUmqtJZviFa9906xO+lAr2Wcdrm1nwDvZKeNVVC9QRpd7/oYMZvbx6xZbwiiIpCXW0VEzYciFre2FxyYoBiEklXb8s8dP9iK93cEnieP4UeZNJNzcihHJmXzsmYAzkrHeS+9/mt3DwK2BORH0ANweblrJ9x1oVX7ocb/vLl2hVNT5ygb5D5Ruj9sFXZ0rhXF6YnMAomnhTVZMCS2ZI+ju6eBOgB2zSAlJ32EqPnBLN+teO9NWUc01/73At259SBxYNwvirESUIq2kM5GSL0R3tAMNGmoGF6hwna4rrhg9L3f4ffAqe5F/HjJOqAVmY2j0AQbZVHPchMF1F6YYFF773gyItkEJeM6G2ZgJ/NfvvsAzINGw0RY0F2/U3KTQwUSayJ8lwowKS4noKTQkYuqOSR0xuMZeKYNW+5kAu/unITdIq+3QIZJy3uReW3K2Iysao5SeIouLoKkVMnONK+o5pIkwht4YX804+x0F0D1qH4mZsTgf71Uo7XchQ91Cj//nGzmwD6TnYG9BZaChOQZl9Ukc7BBm5KsdYLdGjXh8Ro4NJ
 GBNaDcQf
 lVhxkdv8AZ8ennTTrTSw+1vvYMvRP+NdL8Xx9FPY23MeqndGOltueT6GoOOC/BJzhtGSCzWzj/SFSOh6r46iz22eynAXlvOfh+iHASijVOWzzhS42CLsljFAbbsRjj0dLTBGe+ykAeDbFnD6Sy0+0RgdNIanHo0sLxjkAiQXCicanqlPSz4Tkna+Fe2zIXZZPti0YqfUc0dEG+TqOHF6qRWWyViCI4usFTzmwBd68WCVEDAdlDuG8uV2C5OjRa6Ss1qcNjKXpSRdqL1TGALHPHjX65+p+C9xU/Jrq/h4HQLzcDjaZKvEUObOG1aJc/MZed0OzyZAHdL4agJKGeQvMco6taVQQel/0wD2Lj7Hyqc4vFBk2aTEVR+XONhLTmkGuhbX9NsXuRjNwID1+eeO4GV2NujZOpijjs2Yp1dbcPYf1gr2T12EGTNWPu7Qn+7iTiodmpbdrwOFlPCMJaCWUb5GJq2PrMuIrl8ALzUqoEqPxAsM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mem_cgroup_alloc() reserves the private ID of a memcg when its css is
allocated. The ID is erased when the last reference to it is put, and
that reference is first taken in mem_cgroup_css_online(). The failure
paths of mem_cgroup_alloc() and mem_cgroup_css_online() erase the ID
themselves.

But css_create() can also fail after css_alloc() and before
online_css(): in percpu_ref_init(), cgroup_idr_alloc() or
css_rstat_init(). The memcg is then freed through mem_cgroup_css_free()
without ever coming online, and nothing erases its ID. The reserved
entry stays in mem_cgroup_private_ids for good, and each such failure
takes one of the 65,535 IDs away. With failslab failing radix tree node
allocations during mkdir, 1,500 mkdirs leaked 6 IDs this way.

Erase the ID in mem_cgroup_css_free() if the memcg never came online,
which is when (memcg->css.flags & CSS_RELEASED) will be false: it is
only set when an fully onlined memcg is released.

Fixes: 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
Cc: stable@vger.kernel.org
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/cgroup.h | 5 +++++
 mm/memcontrol.c        | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 2afb4cb2bb4f..123c713dcc91 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -449,6 +449,11 @@ static inline bool css_is_online(struct cgroup_subsys_state *css)
 	return css->flags & CSS_ONLINE;
 }
 
+static inline bool css_is_released(struct cgroup_subsys_state *css)
+{
+	return css->flags & CSS_RELEASED;
+}
+
 static inline bool css_is_self(struct cgroup_subsys_state *css)
 {
 	if (css == &css->cgroup->self) {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 091401cecf39..e7dfc96fd1b9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4545,6 +4545,13 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 	irq_work_sync(&memcg->high_irq_work);
 	cancel_work_sync(&memcg->high_work);
 	free_shrinker_info(memcg);
+
+	/*
+	 * The css_create() error path bypasses normal CSS release, leaving
+	 * CSS_RELEASED clear. Drop any private ID that is still reserved.
+	 */
+	if (!css_is_released(css))
+		mem_cgroup_private_id_remove(memcg);
 	mem_cgroup_free(memcg);
 }
 
-- 
2.53.1-Meta


