Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65B9760A2601
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZERdviaK
Received: by kanga.kvack.org (Postfix)
	id 8A4C06B06DE; Wed, 21 Oct 2026 07:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87CAC6B06DF; Wed, 21 Oct 2026 07:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 745A76B06E0; Wed, 21 Oct 2026 07:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7E26B06DE
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:47:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 655061C3B7D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:49 +0000 (UTC)
X-FDA: 85346459058.25.400B2CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id ABA6140004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZERdviaK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z89Kr199TcPJR9MDz9henzx13FG7NYvsmnPGn6umWUE=;
	b=SYZaHvS4ewsEwLsWAozsRjtr+EMlJfrvICxv2iZuEvBE4ihrDYMP/5pAMnyDDVW904x9Ax
	17ODh1JjayFFvGitrvhEBmdk7aLmqVtcE/phn+/uONKvXMxg+g9j2zT0/wvtdK3yRCQB/b
	CabcQGqmaBW+WEqeqnXbWm0bEZ/n4jY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZERdviaK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583267;
	b=c0KGBFNenQVpRCoUEoPZdym9Xsdw5ih2hDI29xLmp09MH8/bDDRVEHw0Fe57nr/2SsPZEv
	lJgDrkYEMYxyrhZGmYwNqWNwNnSzUZZ6tBXBkAp767Q2/ieoRDRLKGQwFSNL/6hJwh7HSx
	hkeSRqH8+VmcTCmV0b9psxdzq1Hbzs0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 46F6260DB7;
	Wed, 21 Oct 2026 11:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE5F1F000C5;
	Wed, 21 Oct 2026 11:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583267;
	bh=Z89Kr199TcPJR9MDz9henzx13FG7NYvsmnPGn6umWUE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZERdviaKNmHgJJuGJC6NDkVLli3/xqBmAyOv2hjYKFpQjnenkWC8uRFRc4vO6xIAa
	 e3Mf/zDp+MBMel8bRzZhFUBtPaGgwbb9xXbVH7LfUbDPNXp1CcXqtnz7YqIiQl2Cer
	 4+Y4yhfEkKUa97HJV2rfj370m3iQkSv/WWVLN6WjCjJY3vUGx3AR7kXLmBO5Jglyxo
	 qKAmdpgMG31r02ttWv/LQdOpg0ONxM58w7FpX1kLdtIDlGk1ACN6i9k38ygrPiFSgn
	 eylwbTi3tzWYoOfiHTM+cREEV9CqsKNt+M0PJ94H1eHX8JhQiYHDXTylteJ4w4eQxv
	 KohJS+ZwBCDHg==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 21 Oct 2026 12:46:47 +0100
Subject: [PATCH slab/for-next 06/14] kernel/fork: specify SLAB_MAY_ACCOUNT
 for thread_stack cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-6-096800aa3330@kernel.org>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, Kees Cook <kees@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ABA6140004
X-Stat-Signature: 17tusfo5zjwpr3h6hqarqtj36t1hqqxc
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792583267-966675
X-HE-Meta: U2FsdGVkX1+iKgDLAj7tFo9oIkdxUJkP6km6qulMH2DoYbGnyIjHYdpVvpo8Gu4SxS1fSzDr5VK4mQVU8oUC38l+fS8EiejxE16xKPybVKOS/Df6he2HU50DaJjTVbeHHVvRwZCOhDMnittzl2MXl04ac0EKKvhQCkBE1aLGneh59bhN9QeZWZN0/jpSMpI500XGueEEdJspiHab+1eR2pwobYuVV6xTQ09eN+gXAL9gVS14ZYOj2iYugEbjBuI/DdyLQjwnyL3Dcvr7LYfPx6vRNThmdMDIzUoXUmRm5qvbqKq1YRs9iodnDodMLNB5kmq1wNkdQUlcwAtzAvK1kxWGstZSNS3CaBIo1GTyqJRbr26D0yVzMcVIpU6QBImVzUIK5gZo9wNNl+ZoqGuvY9dvlMe1Vl/pLR5AgX+mwu4owUZapD8H84y74NMT1enw/TiQbMQ4bn3ApYxIi0e3rrru7cX+KgFMcbOge7b6ZaN38gCrSc3n+zUDAX7uC1FKjc+kTTWlWgJiE3vgPcUU33F1t3q+07/Xhg5i9g6RlyRHxb2ggnUZG2hAEL0HiPZ7YnsSLnfZrfFNw+0eRYn+83od2wzv9dKzSGnKoatDDi2Y22KTsAZP0mPWsFaBxDt/L1SuM6hZCqcAr9WW1YSUk+3UCJOaz+0V6ocobaVayW5bXl1TQHkI4KDT+aBqp9BRP5rJ6zQY4lGob8fMxeM5Ot5CMG0wlhcyefftCYvArr6ta/2lr3XchWGFKvsvXeHlxJ2JDmKpiVGu8JJ9ua3S+J3NJH6On/rRUi6bJwcvPqhPLRZNiBrRvRX6DirbaW9Ugh13xP2oCgLnoTElLSpeNbyXjH1nIXyZfoWiEwhRwv/Cjxeq3WSfAGn5HaWZ5yLu2wzDHVh8SBemv/EAOlPmBQTaTuUP6qB1Jto1c72neOXL9TVmmLEWY8WEo/BeqQ7mZkQ2yZt3hmaX4xjL35c
 acFIl0+4
 9KNGqS9mBfEN+T1hSb3myD1ZSRGNd1Peh8N9k3Yyf6nkR1LJg0HrrO2qbqy9LDHMxNSOvvUZ7eyavAK1hN01gIJdCQsZnCOzsJgPnKoTOZmhp8uAiRHdwg/UE2mdG44/CkzxMpvHPorFqKu8OOnwUjivPu/WXBZsDnaP7+Mf98+oIowvowvcPiAOwZRi1R4wh5QdQLh/JHyfAY+VU4aJHN47NcGACNvEwYrAGHCm1ZrOtbvXHJ3kgolJAEnyS0bHj75di+UbFM2YmOBWiKMdn+MfzVWHZDutzWhd+jHsE41T/pwwsXuKSJxgSgdPaWL4GJIiYUCvw9Z0g1lyGw6L1Xhl3/6G+UR3UCdYeiEKCoECerXNlhs/n744dzBdJJpW4fz7DyuJtsNtPDeInDBCDKBRdvhyd0LDhD2uhiZ3x11MpzAO63FjKqJifqY53Zsjibe7FDS79qliFgv2YdSJvqVK8bBtVeuUueLjBuMA92DA7ChmMFwP7Bwg8xg+f8fiZN00mAafoErA8vnCXZnBbFDxqS/a3bbCxLsbN7mlYA6UslfmSPDx9mUprg4kCfbRMRb6ngNHZ9zvEhA+PMmCu/1ZFTsl4JC9GocOxxzSgr04dLAPumwutVQFwCodHY18xaE4CazAfsvWVAHrOKEqfeCpYeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When THREAD_SIZE < PAGE_SIZE, thread stacks are allocated from a slab
cache with THREADINFO_GFP, which includes __GFP_ACCOUNT. Specify
SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
__GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Path (e.g. ppc64le, 64K pages, !VMAP_STACK): copy_process()
  -> dup_task_struct() -> alloc_thread_stack_node()
  -> kmem_cache_alloc_node(thread_stack_cache, THREADINFO_GFP)

Assisted-by: LLM
Cc: Kees Cook <kees@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 kernel/fork.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 416758c8a3d4..3ad31c5ae0b6 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -459,7 +459,8 @@ static void free_thread_stack(struct task_struct *tsk)
 void thread_stack_cache_init(void)
 {
 	thread_stack_cache = kmem_cache_create_usercopy("thread_stack",
-					THREAD_SIZE, THREAD_SIZE, 0, 0,
+					THREAD_SIZE, THREAD_SIZE,
+					SLAB_MAY_ACCOUNT, 0,
 					THREAD_SIZE, NULL);
 	BUG_ON(thread_stack_cache == NULL);
 }

-- 
2.54.0


