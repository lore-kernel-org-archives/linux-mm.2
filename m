Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 270AE606A33A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Gx1eDo8h
Received: by kanga.kvack.org (Postfix)
	id C5B6E6B05B6; Fri,  6 Nov 2026 12:26:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8FE16B05B7; Fri,  6 Nov 2026 12:26:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A311D6B05B8; Fri,  6 Nov 2026 12:26:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7256B05B6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:26:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F31CDA0110
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:26:25 +0000 (UTC)
X-FDA: 85405373130.22.D27DEB2
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 285468000B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:26:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Gx1eDo8h;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793985984;
	b=BG4HD8dpv8JBkifBelbkCzXNCvgAzHAkeGuOcnIjsaol0ERD4NkLqH6D/ByJNvfqxQcVXo
	LHpJWt1fsrsFfEaVpEMWa/JW4Lb3uvsYFhnv8zTXHL5ymY08//STy++kY/b2rSOtKNvo9N
	r4TUOWvrT5crumkJ9WIt2H+Ju+nczbU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Gx1eDo8h;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793985984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p0x9++uNro13Vk87W18DExzirs+o51T454SovrEtgJc=;
	b=JYDiVWEp8nWLtXk/Av63iMOMTRbS6NzkoQYoiHZZL2scAXObyevf9Z5hA7oZjfuk9dy3p1
	66jQ/srnqUsp/6qKuU2aZ6w9f3jwN953Gh2x+tVR+V+AD5S/RpQi+7IHmZ0KfZ9SFfAssy
	J9k0whDzCeZVsipi1iWyAidWRXTisHg=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8b32bbd39d5so6045747b3.3
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 09:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793985983; x=1794590783; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p0x9++uNro13Vk87W18DExzirs+o51T454SovrEtgJc=;
        b=Gx1eDo8hy2NOO0K0oDGeS+4xIzyQQAQX3zaUUo+/nIWAdikd/Ka0lIz4oCOSwfyueT
         5PqI6FKOzaBlAD1tSElSMub44dOmIV3Jwecqivfz1ExNkDze9tceCDGqoyQokBbpI/SS
         Hov9Md/hWJjUPGyDTjv+SZLhoFesFugNCxWCz4lEktSTOjTwkkDuJ6P0FFNHQ6NwY+MT
         L5kyIYZLjRZOKQ1bi7Rc17hoANe//5hGru/ypcqa3jyIKKh+GKGnqWDGAh8O4f3kXkLC
         JTS4JO8C3hlpfi8Bewcmg0/1rauD0Wh/BrgNdJJXunYQ3eJgK7sTUboL4vLWb3itAS2e
         sbgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793985983; x=1794590783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p0x9++uNro13Vk87W18DExzirs+o51T454SovrEtgJc=;
        b=LPlfcZ+3KTtwX2o2yg201HFe1LuuAf0yK7wxz8AVFs2mWnaJxxYGgEEescPwOH9Ia3
         Vm3I+1u5jvPYb4h2SZtJXtDev7LaV591tedDk5SVBq5ew+s8ujJu9RQV6c03+L8ThjFP
         rlcWgaVq26cDHRwS0/xeYPI/hYEascQOn5iwHmcXNsFXiehg1Ibl8E83Y50XCLznY+9f
         gBR/0xn19p64MgPZztttA8q+g/KRv90cOtur1cb8KIsDTsmvGVYf+p1QX+4JM6mZR4ar
         mwrxdgUEJLuo72Sc8U0ME6fctA5Vi8lT3rJbfXVOF/oYAO2ud+az/9UoZ6z6Ol3Dmkdh
         25XA==
X-Forwarded-Encrypted: i=1; AL+hErF5S+zVPQVuA1rqZDQ4g5YY/S+rowuu5gbt350fgNepuj9MGmkpjdrtshL6XffQckqhb7CGq2JsEA==@kvack.org
X-Gm-Message-State: APuU4Z+fpuJ/CE7AHuCtWe3mjPkX5Q2P1GqKLRUQUNwt72+NBD8TYHtF
	AKwLAtXdMwwWeb+la16XmJHxKpyqccJBeYu+Blt9W4zzSWLO9CYPzv7i
X-Gm-Gg: AYBFou0uPqkNQHor6Pdh9egN+9K41sPcpgsVttmOMmR5fXtOAQ9tYpHD/XGfUv0yvTI
	NeflQD6hOC/p+h7p73qGYN99iab38bDMwggBUmZgSQtNUR8k3EkUh/u40uFUUxi2T1gak9ZUNlM
	NFq8l9tAsoccW0pLyFwwDe+c5Yi8AADr/R4MvMpw4FfFNJu0oGekQ/Tr4wojshbZIqbPabnS5qa
	HLCnAorzLnFXW3ljX0lV/1KpHPukRC+atCVRYQNCkrlFrrhr6ySG77bP+fWYeQ9RvHhy04XzPUN
	zMWE5qaC35O19vD2LegI9Qf+W2axbUzX2zoOVYgl7M6kndxCcJfbbg9uQjp6qsA+45pgSBpnsbD
	F4EhhRqv2Whpy2JHTsVaOzZCOnLh0GifoZxx5Jcp+5gLhJHv8dZar7CUUtx1+NZVvnUN14G07QJ
	OBhRUokldgG91q8LTY43w+Sc6L18L2Jncnm0ofdUek29pUhZjo/5sUM7PTG4/SE8gQxLNU499Ly
	S1cB684cKPV+zxerXSmIHcMshUvoxmcA85MdEvnPB77tYENW2jt4CaepzcYOJOnjQKnBsHT5STR
	qcOcwWD95+U/9FqqxnjdpLlWt5WLiY7fPDECLiPC1oiYF/H7/7IY4+zdzflt
X-Received: by 2002:a05:690c:660d:b0:8b3:416:b1ae with SMTP id 00721157ae682-8b3419158b5mr18015257b3.16.1793985983165;
        Fri, 06 Nov 2026 09:26:23 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67c1353e783sm2325876d50.9.2026.11.06.09.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 09:26:22 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Gregory Price <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 2/2] mm/page_alloc: only skip kswapd nodes below their kswapd watermark
Date: Fri,  6 Nov 2026 09:26:19 -0800
Message-ID: <20261106172620.318113-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106172620.318113-1-joshua.hahnjy@gmail.com>
References: <20261106172620.318113-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ixks4ha5wwqpysiw3hpp1whadsf1qzm5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 285468000B
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793985984-170716
X-HE-Meta: U2FsdGVkX19lXL9X0g+1i/Ft7nJBNKjlvvco7xRXcDQF5CcshKVGCT1+r8K127Pz4uDFQxa0DdV5tsHR9AmKcNJ6lSUZ5gzSU+bKUYXDU58yzcCH+tbaoAlkaBNhOo5L4vL58Hmz/ydUpTcddMRWO6/h5wIi6BhnAzKSolGv6v/zDkj/LFQOYWuVVqxQFznV5QPkRSfQdoKObidWstiRlsDtrewfjPZ37a6p28KV0Y1ObsKok6rI2RH2N4dfMrzYUlzUNR1E5XngQVO8EhGLiKaAYkJBMKRtfiQ4pAyCC4/bptvuTgdrUq8+n7XTa5denDrVtXhnv1hKSjZ3F0OZrhLHReHv9YGWCFStEwGWUPsGKLetpfTzmXWy/4HDFoFTyVT9b9V2XF4SnWfI4DWq5JeXMXWU84na2vFLQJjLbgo37eMgAsBnzXKAQgx5cKHGojOF7DHn8UAPfNJk6Q5JsUVFeWCe9HHZQg6/HgJBVcpIO6tmApUMCWGFZhotb7j/dThRIttce/Fv6YDpxiEzRQWKwB/HxAcyeMQ6U9xByPSmW8YAOkLIsB4lOxwQ8KEy0qD0X6X4++h+GwywyihOFIdhWWODQoUNfqTMa2YMTQ8XbZnGNx5yGloJimzyEGNPPfIfKsYcxoVi/3yXzoDNiJu7TUHFVxlOoI0gUFKyAVqiwl5B4pbd+rWR56KDUkda7Zm/dMbtNT1E/8+QOD9WgUdfYN57y9pxWDeKBUCYitARKGVDXYn80JReXtCAq6yUULr51h3MLatMIok461imIdNoKXO34YroOKpfD/P7mtjUfy9i2aj9iwrVIWptnlIyqwYY4ByvlJnLQ8KWvBvuXSR0HrpMbdu138B7L16L+0yOxk30de5UpeB+dk6RKj7C/KkuxoFtF4BsYl1PLcWL++8dSCGpBr5k45aRwWaimq8+jiuViZOC1yU0MwovCh0uR35cYuUv3HyAdnkkKkx
 ifUwC7bz
 pxyK54Djf1egGYCeJ+UU6vo3cGFneycfp93Vz2UHpf8cgOxr7ICJDOsHtE4khIWYTPNQNyffo54O6EsBZZwDJjhfdAdbN3l8ydsTRT+KOnZRduyqpp/rWupnKaiZsZrSVjQq+QFYWK28HkJrw+1okfgUNZlZFM0uBJ0pCEEPwMJI//ReNmR6aWpQAikCptmAbK+48xLpDQQONEP4ZT+2xbV4gtNNPOQNosSqhwzXxz4hDLl+T0RVvzbOzl4pv0ihrjiQJXOGslSI2vilzKebGNXHvu9TyVIs+7R6Njv6lIbjKKJ4qLZSd7IT58kDkEhR9Jbu87u1kXS2yqi4ibeg3p8/ncPhrR89iEsNLKhthq4feiAh2aExO0pVEwXRZ6kO4SXaF/KrUE0A/ghd4jo97Zth9qS+XAuicFAFv4mIfer1l4CDR0TEWrafhNDEKZnH/EyhwydNvfGWcvAsK9pwx24pS2VKmsnNza/LdklVWlZxTJtSsAZ8UT21dh6AlTugvVZmPvN9migTfh4MFhZFv7n1DARch7W11T4VOk5eZF360qvlVBLbMMmSX4FzNQF0KLFNl5kkPRRwKk8+R6PzZPtixNQbsg3gWxTHb0MSlsochsV0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to
NUMA restrictions") makes get_page_from_freelist() skip any node whose
kswapd is active to avoid piling on an already-pressured node that is
constantly churning to make free space that is immediately consumed.

But kswapd can also be woken up for order 9 requests with THP defrag
set to defer. This means that a fragmented node with plenty of free
memory will have a kswapd thread continuously spinning and preventing
order 0 pages from allocating on the node. This causes the opposite
problem of piling on pressure on all other nodes.

This behavior was observed on some Meta production workloads running on
2-NUMA systems, where processes with a preference for node0 allocations
continuously allocated order 0 pages on node1, despite node0 having
hundreds of GB of free memory.

To prevent piling pressure on any one node, only skip a node during
page allocation if the zone also fails the watermark kswapd is
reclaiming it up to. This is the high watermark, or the promo watermark
if NUMA balancing memory tiering is enabled. Make sure to mask the
reserve flags so that __GFP_HIGH / atomic requests in the slowpath
do not get a relaxed version of the check.

This preserves the existing fix to prevent piling memory on the local
node, while also preventing memory pileups on non-local nodes when
the local node has memory.

On a 2-NUMA VM with a 60G node0 and a 20G node1, with THP enabled=always
and defrag=defer, I ran a process that prefers allocating on node0.
With a fragmented node0:
- Before the patch, 66% of faults were served from node0
- After the patch, 100% of faults were served from node0

Suggested-by: Daniel Hodges <hodgesd@meta.com>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5423ff4805f84..8e8a2c8d6e6a4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3882,14 +3882,18 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		}
 
 		/*
-		 * If kswapd is already active on a node, keep looking
-		 * for other nodes that might be idle. This can happen
-		 * if another process has NUMA bindings and is causing
-		 * kswapd wakeups on only some nodes. Avoid accidental
-		 * "node_reclaim_mode"-like behavior in this case.
+		 * If kswapd is already active on a node and the zone is below
+		 * its kswapd watermark for this request, keep looking for other
+		 * nodes that might be idle. This can happen if another process
+		 * has NUMA bindings and is causing kswapd wakeups on only some
+		 * nodes. Avoid accidental "node_reclaim_mode" behavior.
 		 */
 		if (skip_kswapd_nodes &&
-		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
+		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait) &&
+		    !zone_watermark_fast(zone, order, kswapd_wmark_pages(zone),
+					 ac->highest_zoneidx,
+					 alloc_flags & ~ALLOC_RESERVES,
+					 gfp_mask)) {
 			skipped_kswapd_nodes = true;
 			continue;
 		}
-- 
2.53.0-Meta


