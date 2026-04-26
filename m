Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2785FF885C
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 09:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BB5C6B0092; Sun, 26 Apr 2026 05:27:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5922D6B0093; Sun, 26 Apr 2026 05:27:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4809F6B0095; Sun, 26 Apr 2026 05:27:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 396D96B0092
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 05:27:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B37F48AF71
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 09:27:20 +0000 (UTC)
X-FDA: 84700178640.28.79ADD33
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9AE56140003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 09:27:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NKfOEcpF;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777195638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4lJZQuHOoBwkCuOEzBR659IeprHDGyqMQmHH4+zCQA=;
	b=Ff+qZ7fG6/eGDLJlU5QFvdb7uweP/9Hdr6OeKqDhEzz3ybHhs2h5hT4FXtzHtOc5/LwCZK
	uGIf0ABMdLXwBVQpTIImp5mTjMRHlX7M3YcZErBV4KwkCN5AbWfa1qjTeYAC4vxnAkfc39
	a89iGlgScWT+Ar6y01ZWmESDkDEtLRg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NKfOEcpF;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777195638; a=rsa-sha256;
	cv=none;
	b=7W2WXI7soduxLeSJ3A4SDpnkjluqYy6ojs82UF9YftmpB4UdFKMV4u56B6B2UIAK1jS3Tf
	gJCZua9s7bnO9yP+TYnBxhdfrcZEs6EnZmhBeHW0oHZl4s5/D80SyEtuieiJ6fM/Lj0KjL
	FcWKrmXgeu/EdnFaSk8SN86PglfKMK4=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b23fcf90b2so88169285ad.3
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 02:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777195637; x=1777800437; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A4lJZQuHOoBwkCuOEzBR659IeprHDGyqMQmHH4+zCQA=;
        b=NKfOEcpFusVzCtBdy0YBJxfc0RNlEiBUuZFdSys5vlst5MK2adW6pmA/pQeZDbwQ05
         4t4AitvJSnxeQEGwDuPT03LWn7uK3/OHVUampnPdcljsByZGWlu+kZ2XalDCawFnmAPJ
         Uijx5x5AlQF8VqzNK0GdYu/yGJf2AQOVRqfNTdZ8eD7UZSPNJuX36V1YRSgjwOghCpO7
         3uCzJ1h3hj/T82122PWUySupIdZILJEdLafNgxp6N1LXAw1iXELm1iSisr8J9Pb3pn3w
         1PUzQIq+wW8CVjZoUa9XyPSKdP4wWaVODDyf3Bna5hO1uA8DQMTg2HZkcrKUXNOyvyMR
         ceSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777195637; x=1777800437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A4lJZQuHOoBwkCuOEzBR659IeprHDGyqMQmHH4+zCQA=;
        b=gjemU1GCNko7/q98AZqIoCjDpE5uJkq6zN6ouo456LYtKbfee/tbBJZjz6JksXmtej
         jk7rgAckBPww0Iv3uFYUzYPg5Ap4Edg0ez9sorW4unBiLBpnfxiza5yvJXy4sSCK8jb7
         gbln3disJXGZRrHppw7jHI7/g7qL9Z8j6whaKvRkwOYrBSx/74lM9sdGVtDjyZOLnRwW
         qgcRQX12wNmUQUhiFHbyf75UFu407JReaiLzV+Q3uiwk8a7yWPeTF+rJPitrV6zPeJd9
         91WYIvfv0l5TPXsQcIRd4NdIEbJ9ch3mXfc9VhOLEY4RJuXVoyOyy60S2P9HQrJTPFlN
         PLEg==
X-Forwarded-Encrypted: i=1; AFNElJ+3Hq/0SXvX8vJ+aamECIKbjAFCn4J60G4qlf9Ujh60GqJ2t3J2QbZAz7izPA8P/o8pZd1mL7mDaA==@kvack.org
X-Gm-Message-State: AOJu0YyBk3LWeHjk0a9amrMH3ZDuik8CX2xLi1NXWHgg2IZTtHbowZ6b
	EagvSlU9xgEKyjiJJTht/sD6jtXdWh2H+rsOEGmuexwoUbZF7B5pi5OO9d1dT1bsFk4=
X-Gm-Gg: AeBDievt9X0yV2MXxITxxKTK0Io/vbjfE9Xgm89c7WPL3Uh3DKtElIalhlbR3/ggYbw
	HlaywYrKRSxeT/vYMc75KoVzvQv6+uhZw7Y7ItBV77jlhlcodocPkeffChYuB666wiW1MlLdLbY
	po3yV71s23kXwGCU4J8CgTmzxB+DxX+Cl4sIT+K4u3n3rN7DAlwql1L66Njgz1KCJGk1Ty+IboU
	CdpGkW+45L0ec+ILubDfomVwcR944LLBXC1Wt5Xa48G017dutHkfPGRYBqV0wbb1NaDbDVjaNZp
	6fr0JRA9fGNEwFcElGADPdZ83gGWdTotI/PK6rVtVBSOgpoPhXHZZDlQoN9SLZgNmHXTyIG6opo
	ZIGL0TWp4CxkNOmSTGuy2d9R8FGEwAwldrFWf4+gCKYF1SXzW539g/LOF6e7qgtcCjwW8LjacXH
	QNtZdZUn+c6IV65jj2p8ByL8jN0LqR
X-Received: by 2002:a17:903:37c4:b0:2b7:abc0:3bd7 with SMTP id d9443c01a7336-2b7abc0448fmr145875755ad.9.1777195637394;
        Sun, 26 Apr 2026 02:27:17 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::34a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0caa9sm270352885ad.40.2026.04.26.02.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 02:27:17 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v7 2/6] mm/memory_hotplug: Fix incorrect altmap passing in error path
Date: Sun, 26 Apr 2026 17:26:36 +0800
Message-Id: <20260426092640.375967-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260426092640.375967-1-songmuchun@bytedance.com>
References: <20260426092640.375967-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AE56140003
X-Rspamd-Server: rspam06
X-Stat-Signature: ftqt5bsmdzc7qzyjz158n3m4bkn8t3ru
X-HE-Tag: 1777195638-911725
X-HE-Meta: U2FsdGVkX1+Dzs/tY0VpuVXhGWzPXIcy3OJ2auO5P7+jOonHmyP5yAVQDtil4wLke3w7f7yIOX/ECbJVRkxl+Xw1MH3P5/o+HeUScsjPGaiYRrbYYJ3nqIRfnefqA3GRsNdk+E0J+FqrHEvg1VhGXyuSyHFNdW2R5z8a0SBu5W5bYKQf9DXVD3zMECV1H3o4Sg7Apc6+0f18WLkqfjDImio8zfNLcxCgfsA7isedDJTWA+SdiTxruJc5Wf1x0sJLAiUug1AuA/Iu/fRQiLfaGcOqCtYTYZX+T938D8WLJAUhZTyXfd+5ppoQPxpMYTPLGoTfITFRXMIy6Q/dvfVXqd9bFtTL1Z0MJztXi/9n4Nv+i7YLZKOi2DiP6tHXmI0xcGEoUBXQDqG9m9ZdVZ4guHKKRAffbZRUHf+7K9wyqgXwafAa9E0QMsAOWrmMXshiZfXTFsHmC7igXVrIs+zi8lVg/qDSDRybmuY4IlYEQ9dfsmaD9zBh4dMv8VtS6WSCYq/O+HlUVcSvRXAeGDxN//LMw0DAOBMTkKmWuiowEZI9fciknSKbBP8WAKEm/fGlIw4Z2DS4jzmmpd/cZrhvXqRR2/bRO5ty16JoFDA7vlBfLX3eYTaF0erpVEjh0Qm4Hykz89zXkrT0Cxo3uNLoBiJlHNuiPXKX5YslqbN3t2gj6VOHbteFmriG7ogz3OqMAPyFL3Jq/1f04mCbnaU0Cn3qtZSr36hSBerS48MTX3qE1m26WArq/TfZAzT3XUKnHhacPI4MoGwIjT0osN2ptg6ao1/ELtQyB0gfwbkRkeAqJhiFmNqOHozOM0v2nyA5EmKJ1eTD8VFtzbS0X77UlUcW7BDE5JG+h/Kxt2TuDysr7poMJNGl+5lGT0tDeOY/Kf5n6ERDFyMODmeDI7mdLpC8OhY7PT5Rg22MuFPEpTQhYHkG8ntMFTm5AXfALzeGO6xwTDXJi+CB2+Pv6CF
 4l+BydGH
 CdCerILhjAq6FLbKQis4iV4oFPkK4W0XECth3qjze9Yi5Bmih//dm49hREpClyZEgQ8MYKPp+MFWgoNke3WhWUvL7SpZXS3iZ52as1jwqT+7ZWwsWq9Gu0vhmoG6/fDQz0AGWOlaU8nC11eJIW6LLJ/8Ti1yAHpajr3XUp3EN03B/xm/+cfK5rbybKZYRkq1Y+6Zf29TUSqSrm3MMYu+Xqkf4l+DS/WR6APGR8Iz8QxlXnmKxFpUk6ZBCKkhxvmER405uTRizwmXS3q597YonSDCc9JGQNV7Ejj2DhBtLeLmnTv1+Imy8D6cViV/fmbIUxRyaQGAl+v2X7B8HqSGOtSNzT4Y/hmHbiwr2Hqzc7aG1Mn0JhVFmd4cPyqRqZIO4hMI/qRKxGDlohV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In create_altmaps_and_memory_blocks(), when arch_add_memory() succeeds
with memmap_on_memory enabled, the vmemmap pages are allocated from
params.altmap. If create_memory_block_devices() subsequently fails, the
error path calls arch_remove_memory() with a NULL altmap instead of
params.altmap.

This is a bug that could lead to memory corruption. Since altmap is
NULL, vmemmap_free() falls back to freeing the vmemmap pages into the
system buddy allocator via free_pages() instead of the altmap.
arch_remove_memory() then immediately destroys the physical linear
mapping for this memory. This injects unowned pages into the buddy
allocator, causing machine checks or memory corruption if the system
later attempts to allocate and use those freed pages.

Fix this by passing params.altmap to arch_remove_memory() in the error
path.

Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory requests across memblocks")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory_hotplug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 2a943ec57c85..0bad2aed2bde 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1468,7 +1468,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, NULL);
+			arch_remove_memory(cur_start, memblock_size, params.altmap);
 			kfree(params.altmap);
 			goto out;
 		}
-- 
2.20.1


