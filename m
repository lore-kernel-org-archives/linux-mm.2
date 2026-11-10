Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C50C606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 08:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kz4mJA3V
Received: by kanga.kvack.org (Postfix)
	id 912056B00EF; Tue, 10 Nov 2026 03:46:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2D66B05B0; Tue, 10 Nov 2026 03:46:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1996B05B1; Tue, 10 Nov 2026 03:46:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4AE696B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:46:12 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7224120699
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:46:11 +0000 (UTC)
X-FDA: 85418577342.10.BB8D9CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0C103180002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:46:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kz4mJA3V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794300370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kzDpiOPCxE3syjEocoBNFMBhB3mxClwKZCD3lTLHyOY=;
	b=z5Q5HzAnI0NiLmZEt6kSwMwYNs0hekN/j6rvTqzod6YSPTMaDia+0VXexDt2YlJeEAVUWP
	anlZn4IMsGKmXE3mxrhfZnBcbtcjbkKFtwBsEdGmd+6WY++Edcg2wHS2Ih12jQtFRbo0Kz
	wteTsz0NKwg/9JODi4ghPji+PVwxxEs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794300370;
	b=vJ0PPBB8D6m0EP7H9bvV3BmHPnR1DxphW2JGvFqdPF2n46jrqM9/hHNK9DN6Ors6IQMz0O
	Gq6PuchkGiZ7Lg1AsAn9yhFK7XKiUE3s2Ut0HIXjGXnaqEFRo2xJ01FiExk4wQsbivRBFg
	ja6WAINUxByOj0hL5vviet1LWc0/WxE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kz4mJA3V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 421D4404AF;
	Tue, 10 Nov 2026 08:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143C01F008A2;
	Tue, 10 Nov 2026 08:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794300369;
	bh=kzDpiOPCxE3syjEocoBNFMBhB3mxClwKZCD3lTLHyOY=;
	h=Date:From:Subject:To:Cc;
	b=kz4mJA3VzYTLurNga9EVNoFtdUkZCWkNqZJR0koAqWmy0dT7rPa22Q6vRxvd+pF8d
	 oZ5qLNnHqhoq/OjV/jTCkPGg6wVT/o7C4+qbYGKt9wD8Yh9V1/FSPZgrVfMSP54EeE
	 Np4tpgh4NuMj9gVYrA5X3dk9NDb4gqf/Nj1hHk93jRzutkTR0XRCN1taA/bDq/efDE
	 fx9lcXhE5Xdjg5ESfpX0udFVT0IoL3OOoTT+6sug1OTn/X1Q2IGZ9O6Gth5tTPWvCb
	 iugLUCYyVP8foX58b6glP8xxrOEk6IdpxJxvbF5BCbU5icibjcMUxY+Bf+zpzdYQdD
	 c86zDMPSqm6HA==
Message-ID: <717f8bde-96fc-42e8-8f69-a31a8a8d6f0f@kernel.org>
Date: Tue, 10 Nov 2026 09:46:04 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [GIT PULL] page allocator hotfixes for 7.4-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 "Gregory Price (Meta)" <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n9ra1i6maw5niyimqo9beo4uf6ddnazg
X-Rspam-User: 
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0C103180002
X-HE-Tag: 1794300369-558353
X-HE-Meta: U2FsdGVkX1/ZVSJm2CYCJu1aKWRnQCJXdC5jtNkX8dGELhtHkDaSEMjPsrmRm+TZQIGRBYlH4cuK6ENGRL1g9TD5mSVsxVPfYY1MhfspVawSfZTjUy1zYOmKh3/gEinwMVqwWeinlobHJE/OexuYXk/69aSToqr7LI+BSEOWNfAJhUGp1GLOqxjyqQRIWo55It6Q992Dr7Z3h60cF6NwLg1XkgW1T0OGqFWPwS614PV0Ccnob7CIixQQeMrQg2Jk3qt24UT2ekJmSr6xCZMksafMcmPLVGqjmAvZfYhbMVEoX7m1ohqWYf3GJBEhi4A2pY9sdpx+Ksu5KBeGS93LA/K7KgZwX3aKLzufFwyfHcsUlIh09EXQ0ynoiPsE3nrBJuw6sdpU2dzQ6z5ESkGzEhc3kFnV9++RNc7g2gVS8/ZN4nd3vkThTz9Ph0u6J4E8+x4eN8yBQ64EBv3dZ+v6dZqOaGoBOifCnTeZ2L+BaI2onjR+YrtS/ca4z6S5/2SC54RM8LRfdc8B9cDRfDmsJ2spweMOKLNkybcgZJZ+g9N0GUk+ETdpwimRpAABAmyj0XHp8HgQO3BcXctBQtHPZAYk8GYOdliKoM/3/BFi/W5aaBavEOf2jvl1ztiIPA/u3WcIbUDYB35Xvl7H3ubLANUSGXAczLOeeEXocJG141VHTOezBrHZQK7jSySCAOyHOnz7KAqkocxBzWEbgNY5fFiIBh8RQNdkddja3dw+hfoYCEgkJHZd4hciPHOd4Zkvy+e7zExM1FQkbwJfSTUVbJ/c3R6+bqKkd1hqKNRq/+7LdweeAgIKrFJHyWtuEsvdv27eqwbnbJQL41Rybg9ZD7+LCBKdxe8B2e4VMcyL1y7pLPhl1xDhK4fkl0fpT04GH+iVGfc23U3kFimBYaP5YTqASXdJ9pJsRTY9oR4KvXCMqNHo9iOQ6pxVVT2WAV5pAqGjlzp6121ViQK2Oqf
 c8JUYJLJ
 6thi81Byhyskdqj1XH9Q/hQS1LaTnlcQd+vWk0eYZjVEsOSRHlmnv2DaMgjHEEvgDamskEBt8kzwYVcS17AgV0WBLdUBbG343o0fBP3HasTpcgVhKyiB+xE1fCvEmkiHsC7jtnWW30QhW8klAHp2SRZmsdE+YeEVRnIiNN7IFhQOBIwCMWMAu/DYu90cHgmSmsbKIOJGL6w2bdVZswHq+Ek+0F4dXPJgSQ8Afy3/e4zrRdhxtK0slLpCBDVNHd6ylIf4eRJxs4MxAhDX3UV0ILjW7Qc3Gkm/lumv2jhHK9uUfhUvoXHQYw7OlGKmWtPjwRkYa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Linus,

please pull the latest page allocator hotfixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mm/page_alloc.git tags/page_alloc-for-7.4-rc2

The page allocator tree has been created as part of the mm maintenance
transition. Commits from there should be reaching you via David's mm
integration tree eventually, but for now it's part of spreading the effort
of dealing with the (AI) hotfixes.

In this case the AI hotfixes came from Josef, but since Gregory has been
working in the area (hotplug races with page allocator) for a while and
there was an overlap, we tried to combine the better versions of both.

Thanks,
Vlastimil

======================================

- Stable hotfixes for various races of page allocator's reading of zonelists
  and memory hotplug activity. These can result in BUGs, allocation failures
  or allocations from wrong nodes. (Gregory Price, Josef Bacik)

- Stable hotfixes for bugs free_pages_nolock(), page_frag allocation, page
  isolation, that can trigger WARNs, degraded operation or infinite loop
  (Josef Bacik)

----------------------------------------------------------------
The following changes since commit 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4:

  Linux 7.4-rc1 (2026-11-01 13:26:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mm/page_alloc.git tags/page_alloc-for-7.4-rc2

for you to fetch changes up to 2122887b04f3f2d76daa80055c2c273926032fa0:

  mm/page_alloc: remove the zone_spans_pfn() check from get_pfnblock_bitmap_bitidx() (2026-11-10 09:19:09 +0100)

----------------------------------------------------------------
page allocator hotfixes for 7.4-rc2

----------------------------------------------------------------
Gregory Price (Meta) (11):
      mm/page_alloc: reset can_retry_reserves when the slowpath restarts
      mm/page_alloc: detect zonelist rebuilds from memory hot-add
      mm/mmzone: read the zoneref slot once in zonelist_zone()
      mm/page_alloc: snapshot the preferred zone against shrink rebuilds
      mm/mmzone: read each zoneref slot once when filtering by nodemask
      mm/page_alloc: retry allocations that raced with a zonelist rebuild
      mm/hugetlb: retry the pool walk when the zonelist is rebuilt
      mm/page_alloc: retry alloc_contig_pages() when the zonelist is rebuilt
      mm/mempolicy: read the zoneref slot once in mempolicy_slab_node()
      mm/mmzone: remove zonelist_node_idx()
      mm/page_alloc: don't undo another isolation in alloc_contig_range

Josef Bacik (6):
      mm/page_alloc: keep the pagesets of an empty zone
      mm, page_alloc: pass zone pointer to trace_reclaim_retry_zone
      mm/page_alloc: clear ->private of deferred free pages
      mm: page_frag: refill the cache for large fragments
      mm: page_isolation: do not take slab pages for free
      mm/memory_hotplug: resize zones under their seqlock

Vlastimil Babka (SUSE) (1):
      mm/page_alloc: remove the zone_spans_pfn() check from get_pfnblock_bitmap_bitidx()

 include/linux/mmzone.h     |   9 +---
 include/trace/events/oom.h |   8 ++--
 mm/hugetlb.c               |  13 +++--
 mm/memory_hotplug.c        |  51 +++++++++++++-------
 mm/mempolicy.c             |   6 ++-
 mm/mmzone.c                |  11 +++--
 mm/page_alloc.c            | 116 +++++++++++++++++++++++++++++++++------------
 mm/page_alloc.h            |  19 ++++++++
 mm/page_frag_cache.c       |  21 ++++----
 mm/page_isolation.c        |   7 +++
 10 files changed, 185 insertions(+), 76 deletions(-)


