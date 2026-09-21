Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 869C3C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AF4E6B00D3; Mon, 21 Sep 2026 05:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486686B00D7; Mon, 21 Sep 2026 05:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39B276B00D9; Mon, 21 Sep 2026 05:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 173F56B00D3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:13:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 950EAC05BC
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:13:05 +0000 (UTC)
X-FDA: 85237205130.14.AA7DD34
Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6ECA61C0003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:13:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h1CwbFmm;
	spf=pass (imf20.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789981983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=V0czgAR2vkVFW/86Mpw3S4F0MdOCajXQILqu8vqAQ/o=;
	b=SjIbQqnEnKhKr7rEc5XvTPRGiJYawJTmcoVH3EwCXEvatJPI6yWjR3RGP2XZeLpgC4G2R0
	yBLm5h3Hf28OJSxWyPhRIFsitIJPzPm2/d+NSuRNMMNzse3Ycu1ygz8MKHgdQcYrAohf/o
	rUIcfqXxPyDiitt7R/cZh9N+MA3fauQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789981983;
	b=dVmgJdiNC7KXUolz1vZ/6VQQIZwJqukxehVVk02iUbNhA9r0gOOIFXDLizhcyDADMQeaU1
	Sg+5OmdBPDkSNFtkh1oyW1LrZHx12+RbXbI9CJybO01X0ZP4bgYQzeeytw+KRWw/QSjSGi
	Sivq4dEymCtnAFLua09NIC3aSI19TQs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h1CwbFmm;
	spf=pass (imf20.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TDH3vD9yd/dcLeLc/jAleyN9Qqat0NKvlnxsmihr/nM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789981982; v=1; x=1790586782;
 b=h1CwbFmmpll9Q7aI6HpACAo7/eqEd5FKAV6XZ7oS+IMPr2B/1EcGG7pKtz1QyGViCaFufY02
 TDARzFETiVuov/zV4x50qJzRSr7l3LTqFwZ1JBDNT2rppo8yFrYztpQpB8xGEOE8N3foPl68cro
 htpI9UGhPNjKAJZ+0vMngRHc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2b44032c6d1bb854;
	Mon, 21 Sep 2026 09:13:02 +0000
X-Mizu-Trace-ID: 2b44032c6d1bb854
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Subject: [PATCH 0/2] mm: fix hugetlb NR_HUGETLB accounting on folio
 migration
Date: Mon, 21 Sep 2026 17:12:33 +0800
Message-Id: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBBG4avIrA04CqntVYqIib86pWjJRBHEu
 5u2y2/x3kGKIFB6ZAcFbKKyzAmcZ+Snbh5hpE+msihtcWdrhiWYaR0R367V2EUY2BvXFXt2rqb
 UfQIG2X/PZ/O3ru4FH78jOs8LfbIOGnUAAAA=
X-Change-ID: 20260916-for-hugetlb_state-e671831c1bb8
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Chris Down <chris@chrisdown.name>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>
Cc: hongfu.li@linux.dev, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789981974; l=2043;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=TDH3vD9yd/dcLeLc/jAleyN9Qqat0NKvlnxsmihr/nM=;
 b=5SGaDRkirvqoNfdMgtlmPP3KU7kwjMhLUgb1e9QeRVHp4qxVn0rMhMIy01kpGfZMAOiVKtDaM
 UQcucSy2UbUDTzf5P+f6znaJUZyoTauMnD0nLr015Eh7OBzV75pTBiG
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: xr7wfaa9i1tp6oa4odouhzmn5abq69rs
X-Rspamd-Queue-Id: 6ECA61C0003
X-HE-Tag: 1789981983-575758
X-HE-Meta: U2FsdGVkX1+vwjtrUv+dVe96h/T2nfAKcMTDTfrDH1fvl7dhheZEmN/hSCnsRHXBizOYZOCSrV+Eket8Do3caJyrnUtX6NKipDoVa41179qEMM5c69KuMJwCdHWd2NHoOvHEdA6ZsGB1FZLYxQct5pV/8Oc//6OB5r/dxwqHsBEERN863UMWT8iHM59D4S/7zJq7njd6hhalt/4IwdG1aIKNknNRE2vDC0Pjj85x+2xhy1Kg6bR02GT2qSBxdckbVTt4MLq9Bhhpq/WX0MlNvstjGWIsqi9p7hEcC8Lx9hpXZnNVIe4+AbJHuBuuQhdRGvy/v4wcVmXHnEh2ts8payzkYmbYNhh4Egp1UYg388y9gAYmiee5D1awtLkniHwBVa0Q06suxPMn+6NJdii/IkacdzULQDDEyHxJxd6wqnv4yVy1NosvfPD0fzE7GxhWHNIusOWYL/s0vlZkeTkXS+7kpw9ozz5LJkXl7jbKkSqU7KrjZSQbNjTjoSEXCqGLjcV7ViU9ztLwjs3mSNDtlclS/KcoUQ1Le2u2rUixv85s+z3pjAszW65YO9qXireeRmKfYNvYQPhOhdfqDKtULB0K1kU1R137hij7rCVY0iBpBnLLdYEsaCIjkPEaeXzlBmDL0aacUd4+l5Dof8Kr4Au9p6gpprmTEF2bdDpw/JZkDqipDqIlQN7YYiJlXl8pjYouwbl44DPeFpVANEhYSoedp8LFMvGAGKiRQFLISb5eKS5K7GOCaIkiYs+AThDH6giMk8uaCjNAEPn0dPYZRwvi2KCfjoebUUmEwnAzObg3HOmYnYyNIRJ55fDhoFJ6d8uyUjgVW+iUAvQd0MJwL0Qb0a8zcbIex33XCe/GJMaAerRoQ1GzOCmkGrogf9Ht6RGmFJJCVN9Cd2jCj6pRuwB8bK28/gGDJsju9vIYGEVC/chSIDNYyABuCbm90ULjUue4VYEGxKhLEZFkH7L
 mfYOmnaK
 dYINCbstz4Pn8BDHI/3W6eewOlaH6fto+nh+cXuPXKkQ16KsD/M7nI0MhrTa3ltvqR4uWVnGU9DORAQ9yUwcYv0eXi7DAte43wQMghYfzxOoZjISauYO4wYX5mYlWpbnIPZtzzwCRLfo5Ss0i0zZ/SsNO8xZ04DVajuvbZRyloL7n1d3NhsxbyYhFvzHLJ16WRAdV4zJvWZWeAzixl/CtKhUVb519aIzqMOYY/yvRN0KaxUp/jNVmDPjvM4YZVTc3n7/4BDyn2WShjYmUG0tqceaTnneb5JWRmn9ECSUUbNoL378Du3O5uyXEjwXN/eocd8hs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugeTLB counters added by 05d4532b60e3 ("memcg/hugetlb: add hugeTLB
counters to memcg") are maintained in two per-node places:
  - the per-node vmstat counter NR_HUGETLB, exposed as nr_hugetlb in
    /proc/vmstat;
  - the per-node memcg lruvec stat, exposed via memory.numa_stat.

Both are accounted against the folio's node, and both drift when a
hugetlb folio is migrated, though in different ways.

A migration target folio is allocated by alloc_hugetlb_folio_nodemask()
and inherits the old folio's state without ever being accounted, while
the old folio is freed right after and its free is accounted. That
alone loses vmstat accounting: the target node has no matching increment
for the decrement on the old node, so /proc/vmstat's nr_hugetlb shrinks
by nr_pages per migration. Patch 1 accounts the folio where it is
obtained, so the increment pairs with the free in free_huge_folio() on
the successful as well as the failed migration path. The memfd page
cache preallocation helper has the same asymmetry and is fixed in the
same patch.

The per-node lruvec stat breaks differently. mem_cgroup_migrate()
moves the charge to the new folio and drops the old folio's memcg data,
so the old folio's free right after migration skips the memcg per-node
decrement; the count stays attributed to the old node for the rest of
the charge's life, and the target folio never gets an increment on its
new node. Patch 2 moves that per-node accounting alongside the charge
in mem_cgroup_migrate().

---
Hongfu Li (2):
      mm/hugetlb: account migration target folio in per-node NR_HUGETLB vmstat
      mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb folio

 mm/hugetlb.c    | 35 +++++++++++++++++++++++------------
 mm/memcontrol.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 12 deletions(-)
---
base-commit: b08a65b93426d86e3f354d655d6225397b591877
change-id: 20260916-for-hugetlb_state-e671831c1bb8

Best regards,
--  
Hongfu Li <lihongfu@kylinos.cn>


