Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68A0606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 17:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LFQWfCb+
Received: by kanga.kvack.org (Postfix)
	id C33706B05B3; Sat,  7 Nov 2026 12:26:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5ED6B05B4; Sat,  7 Nov 2026 12:26:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF33E6B05B5; Sat,  7 Nov 2026 12:26:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8316B05B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 12:26:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 690441403C8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:26:41 +0000 (UTC)
X-FDA: 85409002602.15.35ED675
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id CBA0B140005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:26:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LFQWfCb+;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794072399;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7IcOBbsRK1lvSz5KPPqKrq4qjPKV6mPpFFa7v+KC76w=;
	b=woQ4VBPFOkqe1HhX9WG97188+i/PqDjD7zZYOtjDOgb/ViHaARfQabm2k4K5g+DRG8DiXI
	ZMykwY4pcMNGF04CISEIbTFiO2NGAQAuf60vGDRVcMc7LH9eY4GV6fnYG5AnN7ySjXoTpH
	RHCi2RU05iw7M9n9S/AUiwfhYH2xSYM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LFQWfCb+;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794072399;
	b=1jt6EpFb9vqsaeeb9JakdIHzEVA5g5d1odNfvTPFCCJODhutjcEnfMUo3PoYfzOGz23KAF
	s2xes3D4OWkcWX5oe9w+Wp713iUU3ecRZVBpCG20wl06d63rRX6OiQRlhY08iK8enq6WI+
	qawGLSEliI6SA1T8Ao+M7Wt0s3CoVOc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 411E960627;
	Sat,  7 Nov 2026 17:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0291F0089F;
	Sat,  7 Nov 2026 17:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794072399;
	bh=7IcOBbsRK1lvSz5KPPqKrq4qjPKV6mPpFFa7v+KC76w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LFQWfCb+TDCXOHDgzYdYe3p2pmunlDIa+5KzbIjsJAHEh6A6COrWudykvuzowlvgt
	 ebzSlw7plEwEBfMterYJRBdSki+KJsZnYAhGY/B7vdEKHImVmnBzXfBQ+OADdw1syO
	 5s6LkdngZqgtW/66VZplxMq1ODguBlIh9VyvE0iHcv4vUxgSJ0AB/qGOym1j/mZb1l
	 vfmLKaDxgsrufbVhrD4N2i4cRkcxWuziw92JyFwSBcMcToZPH0ztvwYozLMhDmtzWI
	 dL0HJHikJ04EEd6U1Q1078UBX8AGl+Dv7yi54d+jy32mfqVeMqMB/78nJ4NsxZsRn4
	 H09gxtpJ3KfGw==
Message-ID: <sashiko-outbox-203103@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] mm/page_alloc: only skip kswapd nodes below their
 kswapd watermark
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Johannes Weiner" <hannes@cmpxchg.org>
Cc: "Gregory Price" <gourry@gourry.net>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Kairui Song" <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Barry Song" <baohua@kernel.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei
 Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261106172620.318113-2-joshua.hahnjy@gmail.com>
References: <20261106172620.318113-1-joshua.hahnjy@gmail.com>
 <20261106172620.318113-2-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 17:26:37 +0000
X-Stat-Signature: kdssn4awd3q9at6pwy6f66ew3rjcs3ad
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CBA0B140005
X-HE-Tag: 1794072399-698309
X-HE-Meta: U2FsdGVkX18uyjpC0lc/bqcgln9bujg7b9BlEA8IWRSS+tMjOMe//73cXpAlvnT0tHu9pycLf50i4XjOK85884eDbNo4o/35CJwm4timY5Gu/WqJ93GQamZEIXhVWCfsYM62FeL8IYElGlgaCiaH3T6j5VbNPfJ0ya39dXLQ+j2ggEQP9u59BhG+VjFSml+ADRL4TPul6aMMkQ8JsHqSl7JbLanw8+T9POsT3g4OLUSfan+n9JLEBRzrgeznuzFf/vCs9UPd+L0xV+nBkCM/Sb9Fm9ogZUa77+7/vzSTSvOvgESl+cPbaa2gcEvlnX2EnZYmRhpRkFuGFjDLv7vOObUOfCeBc3e5V05rlzbGyczviO3ueDKHEOwhLIV7lZM8f5/9R7jFfDyizhR5OanbmrU12HhIZ/TdL3Jsr+Fk+DQr3Pw7hbVNzSdFPrXXq+8RP3x0DiqPRrrF043FGtIWHgWg/9StB+1SJrcFn8yBgLR9kZuJlOV4nkuJZyQKgHYizww78poDtX1oeHsABCVsDcomXcJv4bzJQrmvh8F2bBykphs4NwMDbBTBhNRW7/9V1W1jNeKrNYKGihkewiulmfx1PWebvXmLnFECMStFS67AcA3NTe9qyjL6Hdo02akxpgM9Vi7jtrWlX4it0cbeEvhOUvGiR7EnsHKwXxL3dRXcWQK+hIA7qGZL0fydpwdWsFsYcNfUodrD+ZFqNTWLqmDlmQI8/lELYUoCeKyYGKojdmB4KSmsAZBDTCdJQiZZ3ehKBvszDvqn+PRNViMPXDK6s+LyHMLIu88wY+ZW89zM/17xekG3xnYf+8vdyXFxc0CKRhfSQX7BKf+UJHkxfmMnkuNjkHZi8g+KBNfeOd15VcA+3rAo+EiBqgt3zTmN8a9rZIzAzV+06UdhK+PFXIgibw/PH7EOtnirWHm0Dkj6UF8DJB4/wzzPeIA4+73qhvqjSW2DFE1onqHD2/+
 w4yzH3f5
 1W3YWoRy3gR81SiGCWRLcBueBG1/Gxn0jHkU8ZqEO8w1PZvCsBsYz0faQHgBSQvA6vsiHWXSM7Ig0g3UGGokJb7b1NSNqw+GycGjiSLfMvEszAhQNN4Ji4/HEiKdpUaoG96afDTfHY0bALCK2O2Z4j9lNHMOUIShb19jXJzo1+1OmKtRHZljaDK0OsWwlA9ZEGd8ERvwvD4Si1l5/VxgCyoJ27htrQcdAGNuKUZwe1uxeKM6M+hUxFBMTpMgml4pYe8P9gQn7Piz5xiCN6IBOijK/vKp5P0OXtcsO+W2vUBBaKbB+i6+i/S+fA5eCKcEMhgiRF8egSpG2iiYZ9ttdtgHTUx54izHeoAEWttm4N3iPFVCBgFb3H/ab32dHgkLKObYYOzqZ7Psb80fzAr6WKVr2PaXx/cU0YWk/mG8b0X2KK4cGbZ44UbFNpVnyXNGhFIPO4MPVhN6kdaCqrkd+GTK2NMinlBDZiQCO0QQo7wAoYXR57S3GMK75CjD2/iLppgHFGjdFcwZOEn1aWNhlP/u4dhRm3ulA5JQzFt6eB4IJE/yHee45HHlRPK1DG1zvv8mINy+OXbE4IDtC0/RW6PdPnwLnJxTDAyLRErMW24dlMBIi2Ula+pyY5Q9GgUvBtACr4WrNYWL1B2pd1BzfIqs6qXLVbCwJr5Rm87yO/zhiaq/2MGRGbQcnXF9R4LTkYo33KZUEK7q/FFRtgipm1H1vgn1jAXH2SzJmRkNx3tw2PesHtYxuRZLdHQaetfHvr6ECqb3t/kWaPmo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/page_alloc: missing Fixes trailer for commit 19c5fb83f2a4
--

commit e932dd681884969a67ea7579103c6a9f74477b89
Author: Joshua Hahn <joshua.hahnjy@gmail.com>

> mm/page_alloc: only skip kswapd nodes below their kswapd watermark
>
> Commit 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to
> NUMA restrictions") makes get_page_from_freelist() skip any node whose
> kswapd is active to avoid piling on an already-pressured node that is
> constantly churning to make free space that is immediately consumed.
>
> But kswapd can also be woken up for order 9 requests with THP defrag
> set to defer. This means that a fragmented node with plenty of free
> memory will have a kswapd thread continuously spinning and preventing
> order 0 pages from allocating on the node. This causes the opposite
> problem of piling on pressure on all other nodes.
>
> This behavior was observed on some Meta production workloads running on
> 2-NUMA systems, where processes with a preference for node0 allocations
> continuously allocated order 0 pages on node1, despite node0 having
> hundreds of GB of free memory.
>
> To prevent piling pressure on any one node, only skip a node during
> page allocation if the zone also fails the watermark kswapd is
> reclaiming it up to. This is the high watermark, or the promo watermark
> if NUMA balancing memory tiering is enabled. Make sure to mask the
> reserve flags so that __GFP_HIGH / atomic requests in the slowpath
> do not get a relaxed version of the check.
>
> This preserves the existing fix to prevent piling memory on the local
> node, while also preventing memory pileups on non-local nodes when
> the local node has memory.
>
> On a 2-NUMA VM with a 60G node0 and a 20G node1, with THP enabled=3Dalways
> and defrag=3Ddefer, I ran a process that prefers allocating on node0.
> With a fragmented node0:
> - Before the patch, 66% of faults were served from node0
> - After the patch, 100% of faults were served from node0
>
> Suggested-by: Daniel Hodges <hodgesd@meta.com>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

[Severity: Low]
Since this fixes the unconditional node-skipping behavior introduced in
get_page_from_freelist(), should this include:

  Fixes: 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to NUMA =
restrictions")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106172620.3181=
13-1-joshua.hahnjy@gmail.com?part=3D2

