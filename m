Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8209AC88E72
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536AE6B0096; Fri, 18 Sep 2026 04:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A7066B009F; Fri, 18 Sep 2026 04:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 304206B0096; Fri, 18 Sep 2026 04:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0041D6B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:54:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FC26A05FD
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:54:17 +0000 (UTC)
X-FDA: 85226271354.02.B8E2B28
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D7F120008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:54:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oVCQU6QN;
	spf=pass (imf03.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789721655;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vs8facHpDKfFJxV5Ye3xakd4sz+h4TxqDCyAtSHH9SE=;
	b=CkcDF0iVG3ujXQaOiCkycaZzDDhT8TsQlyfWIr3JpEMaxKfp3/EEf5+/2t+4jbAkwdR9c9
	Xe3oBRgXH7zx3cLdIDmtvlQ2A+s+hn2GHv0JVdsLrvzcMnvDLyeVEoS99Phee0sgTSoTD+
	UTj6rTzmI5uuAl04/vdhDJjzKYPZSwM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789721655;
	b=2Dq069S71tN+UR3rCen80k2UKZlWF4hl0Etr6SZ9RH9R/H1sh62MVnD9P1aJMfxNl4Dpte
	Pldefk3edpdC6rXCYMZAfA+c8nA2rItRrPMbxqdR+E842zWCAhy0CqBgdxiaMefQeQuoWS
	Ylx/46mV/UisbW6Q7JqwxqG2fP3+CLM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oVCQU6QN;
	spf=pass (imf03.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 600EA60A68;
	Fri, 18 Sep 2026 08:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E42ABC4AF49;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789721653;
	bh=l2GgfsX40UJpQL1CyGaHv1TFodoR33Opdo7qAWZ0KZQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=oVCQU6QNMu8SBg+S5/FFO8AIAhCIF2gNftQd0+NAn/X8ZLRZgqA193P4Qic9v4VR1
	 hWQkoSUXIBanm6p+9b1zTeuj1nW4/6VkDFhhCANnBkpMTZ+aCVMWaarOLzRcBzi4jV
	 mJC2s6v82imYa/MlA9UZznRqUd17kvd97KOpqSXxRZF3Nbi9y7yd1+LRNUKK7Z4/NW
	 8se2Cu0WxuksMUsD+0e+qYbRHJ0jXqUSwUosKMZZRyZgJhqjhOzkrx+FzMYEq9XhNk
	 De3+y79MHQQhgrzS2bvxgVAK1p3HIXyBvzQ8aDjqkI6qE3gq80HOYnmSmiu62G7llF
	 ikptf831WvWVQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D159CC982D2;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
From: Jingxiang Zeng via B4 Relay <devnull+linuszeng.tencent.com@kernel.org>
Date: Fri, 18 Sep 2026 16:53:46 +0800
Subject: [PATCH 6/6] mm: memcontrol: clamp mem_cgroup_get_max() to the
 combined limit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-descriptive-name-v1-6-dfcfdd91b456@tencent.com>
References: <20260918-descriptive-name-v1-0-dfcfdd91b456@tencent.com>
In-Reply-To: <20260918-descriptive-name-v1-0-dfcfdd91b456@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Oscar Salvador <osalvador@suse.de>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: Jingxiang Zeng <jingxiangzeng.cas@gmail.com>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org, 
 Jingxiang Zeng <linuszeng@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789721651; l=1734;
 i=linuszeng@tencent.com; s=20260909; h=from:subject:message-id;
 bh=zhtOFhKxtUFb8xp+y1sRK9RNl80hp/9T+5xQLqfkz8g=;
 b=EL4RDYrjbrEVE0Vr7y+4cIOSQgOIfXScAu7h3KFs+GeoFED9JQADdqJOi0z5dI/RGqwmZiadl
 oD5iJCJEyvMDmM2LC4+vXp+Pk0BjC/J109Snq3XrqY5aSU7jeIHLraO
X-Developer-Key: i=linuszeng@tencent.com; a=ed25519;
 pk=6K54xRzYIRWqatrAPy86M4E0MsI92BVJBhXwz5NdC74=
X-Endpoint-Received: by B4 Relay for linuszeng@tencent.com/20260909 with
 auth_id=1017
X-Original-From: Jingxiang Zeng <linuszeng@tencent.com>
Reply-To: linuszeng@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2D7F120008
X-Stat-Signature: ifpinoboof8p9j6ag14538eii3oo5qrt
X-Rspam-User: 
X-HE-Tag: 1789721655-898999
X-HE-Meta: U2FsdGVkX1+3RLZp0pmP17JkNVZLaT6mYehccFDYr9sSCDG1DcPoFkh08SzrOY6JdmdV8bc3L8xbzCbftuC30cILLEj/DKOxLXuoICZbPt396tSx6kbGH/py2SFUw6TLTLkCWbMDHU+xexk0emfw+PO2JVENwMjwW+g5aSid8u/NBt9grUS9V2ojS6h95++gl+n/nRaQryJvs6nZVuRIOdCpj3Jl0h6LgoZabFLMLpajUJHTfqDU0v2nEIEyb+sfUAnuzdVn94iXTHLHsHaZgH+h5wEn3/92p8aJ0Sen312/RfNzfUPOtvrAY/+dxl9rYGL6C+Iv/zAweOuI73NVrgK9L1hLnHukR0uAN8nDo+w6hAtuHNaJqKZb30bzjuHZK/MzV30Wx907C9HLb72XFPkycvP+k4HlnqZVQNLL2D6fHq6FVqUMEUkdywYEYnrGlca3NRVzz5ZFhFNKIOPEhhaLL0eYmE4q9rK79l4ZOVTjJAYcqPPYDCGX6vfwwHmboOmPcWTdR+hXjCYWpOcoSTi/31HCGlDjBD0DMKSNoJ9bFiODeFpV4CqGBylpieNEeuDHim17sYSwn6E0Z9LKZ9oDmIrSZWmK2V/uBqwbFjmVx6D5teAllSqURX88N+FlW6NK1Rm6zLrX17UPmJklefYaR08ZJv6IJRmrGHq2BuzbzHsAiIwIFodDYPVAkjv1Y8WD7vc/EphyLuetO4beavjq116vyg5bwvUpP/Ycdzjpq2oGbVWvAMstug2GZWy7M1cUcKfZKxv7vJRt3h85ZaH4e584ljOJ2wgNap2mIT5Msj8pU1hsagACAgZMK5fPT7pTmy6XUnIeXUxSeiBNeMxZX7oubCNN6MXh98fjieEVSlOudZlSBqjurwEH88DSiFGPdLsinKweJ2DTI0nYqQYmB+GeZ5uXLUCuOPpVcrYO7JoymLSUKQ7H4DWU5FhPLpGnoQZD84V9HUmD0DG
 gA4cyGYn
 RBMAlK0iKHybrXf6NT4F9YPp9OVcmSmKc70fFBmTsgGhGPLZi8t0fGF3ODJXBA++sqWIqTeESzCg4JqlAkzeh9bIYAhrfsiCFMTK/79hsvq3ZSOvOg119EGLYtBiaHDHfK/1F60OBPsE/374gLTzTnWI3p9SI5JVcsEIxO4co6c2vsO7v1WMHtBwSw5EIairA+/xY1Ax71/WYAe8t1zVHkxcdEHVEmbGKmMAlEf/x8gqmv6N6nbAYFiFyi88hbuBWzp+LNdUE7PU7YTlPcVmEPpWQBSu3upej/fDwoG+FPDYTXAgTP3voSUDJ0Q2sEz48wQ1l7B5mElFxh+5hroZN+aI/v83+KRS4JyePsKRwZkDiorTOCJlcbtOOXld3MPV+tkdOKc5IzxBKu7Lo19jjfEiBiQ5FjyhKc9dlupn8/1A+BlSJgqkEFiVJIIcA6gDoZellKH06I9q8tyc0hiDiALTzPnFCXu7NRS37qTmrY/YKTWgHfqJSIhnd4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jingxiang Zeng <linuszeng@tencent.com>

mem_cgroup_get_max() reports the memory ceiling of a cgroup.  Its
default-hierarchy branch derives that ceiling from memory.max plus
memory.swap.max, which overstates the reachable total once a combined
memory+swap limit is configured: with memory.max at 32M,
memory.memsw.max at 48M and 2G of swap online it reports about 2080M.

For memcg OOM, constrained_alloc() stores that value in oc->totalpages,
and oom_badness() scales the task's oom_score_adj by
totalpages / OOM_SCORE_ADJ_MAX, so an overstated ceiling weighs
oom_score_adj far more than intended inside such a cgroup: in the
example above about forty times, enough that a task with a negative
adjustment stops being selectable at all while a positive one is picked
long before its rss would justify it.

Clamp the result to memory.memsw.max, which is what the v1 branch
already derives its ceiling from.  The limit defaults to "max", so this
changes nothing until a combined limit is configured.

Signed-off-by: Jingxiang Zeng <linuszeng@tencent.com>
---
 mm/memcontrol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9e8a176e7afb..e229de0d35e0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1919,6 +1919,12 @@ unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
 		if (mem_cgroup_swappiness(memcg))
 			max += min(READ_ONCE(memcg->swap.max),
 				   (unsigned long)total_swap_pages);
+		/*
+		 * A combined memory+swap limit caps the sum of the two, so it
+		 * is the real ceiling once it is configured.  It defaults to
+		 * "max", which leaves the value above unchanged.
+		 */
+		max = min(max, READ_ONCE(memcg->memsw.max));
 	}
 	return max;
 }

-- 
2.43.7



