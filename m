Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29E1DC4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A8CB6B00C4; Thu, 16 Jul 2026 10:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 059026B00C6; Thu, 16 Jul 2026 10:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8CA16B00C7; Thu, 16 Jul 2026 10:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B80346B00C4
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:51:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 400DA1C0025
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:51:22 +0000 (UTC)
X-FDA: 84994928004.21.FCEAE72
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 974B24000B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:51:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D0LDeiCv;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Zz+36yUziYF15DNC+aOn3O6eA/aUkcC+mnFUaLJ5lGc=;
	b=PkPLjETIZu4T0SFVvd1dQBbiHISoOBkirv6gFWDIdFavKWjiHyDBqQLPVY9+HbrUHPIMbt
	NbQ9/xzznQlJaDOj9w2u0V3v/9Euf4nDuzsBBz8Uu1qIOK1HcPYqyP3tuaAFy8ymsL2zBi
	Y/uiQMfN8cuHZBFI33pSDwB+WyK7iXc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D0LDeiCv;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784213480;
	b=v23zGqxUIeoXorx/aW830cHIhYZI6hKnTBgEd9Jw/dVqe77cxiE2jb4CfSSe6fv6t6mPGx
	BfI2z3bZrxlbB4ZOsZb/5F+aJNbJIJYekfZUP26cYhHeyBTrNzEE2CPeMeQYnDEM1cibEt
	wBJaQsmyZOlq2deh+BSyBG2/Fy4CV90=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D7BD3600B1;
	Thu, 16 Jul 2026 14:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C26E1F000E9;
	Thu, 16 Jul 2026 14:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784213479;
	bh=Zz+36yUziYF15DNC+aOn3O6eA/aUkcC+mnFUaLJ5lGc=;
	h=From:Subject:Date:To:Cc;
	b=D0LDeiCvT5iqD9YtMclprsJ7AvnZHg7GHs6EAfLO2QhyV0hIf2J4bJTCQPtwSSEYs
	 o2g+22Eehz/QPe1n4FEU34dGtWBcXwRGMIve8e2icBn3Eu1vhw10RwStIc49paCsqU
	 zdA7nZnUQNCssIe4UYt3HWDiqT/ePC6LYALmtRjHBeiIbeGiJsizjZhL+6cUAIgZJ/
	 vV7bGB3xRJOoqP02Bc0/jlKgnfMZys6osYRN/Dsv5Q4OL4uUxxltXWBU154sZ64QR7
	 R4K7WgEDAbr3eEeOJs3h+uDCVZX1YgoIdIGvsBxcpzBs2ldbZIwtFVF1fKBBBf03hM
	 DcaDqNQx3fu2A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH v2 00/10] mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE (Part 2)
Date: Thu, 16 Jul 2026 16:50:59 +0200
Message-Id: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANPvWGoC/22NQQ6CMBBFr0JmbU2pBYGV9zCEUBhgorRk2hAN4
 e5W3Lp8L/nvb+CRCT1UyQaMK3lyNoI6JdBNrR1RUB8ZlFS51KoQxrkw49yQHVyztByU0MYYrbO
 +NJce4nBhHOh1RO915Il8cPw+Ptb0a3+5q/ybW1MhRZrlHeqyyLOyuD2QLT7Pjkeo933/AMHki
 uq1AAAA
X-Change-ID: 20260428-bootmem_info_part2-4bbb445d9b3d
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-s390@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 974B24000B
X-Stat-Signature: zagrxt9qem31huqwrsg4bf43jdtjtqyi
X-HE-Tag: 1784213480-876076
X-HE-Meta: U2FsdGVkX19ohd9E7bJvmcRLAt/4duvR0httLcTmMb5rWjLeejYsHbjdaDJ+4lzI7zg/9rgWNfzqIHIGcpZreL8udsiFMUD/qI8Wsg6DCScuHzunUh9Xv6qVJZyDVJm+GuQ+cp5gO7dFDUPwyHtlzA0LlmbXFEuD0EQTylkXvIy0im/z/oNPFeyDL19LXA9bV4oDvLfaRaIOw1kQZjROIscrapdUsNkvvEor1VIxLklDQedoY+6EXEWZ7Xyx3E41VAwhRXqVn8pFpcryTrvsNdUMTBl4M7iJXRjqYGJCZ15/w7HKKXl9su9byTZ5y8+o6HzDHWpWCoIYd47ZOv3RGKM71I222WDbbFzwdwOZyIE9dV6CAR5n227xN2XC5rfAzi+nkOA9kTlLAlpN9c/9Xwu3mZVnfaHg1mhRzrcQEbAUZjc3kVUg6Bjj6mwxZKP7CS7Vle+1zApM0e04MJJLdK8Sd1rYmFk5gB9TkWI8JtYxIOIB5BQqChArEBX2zPt/jpNGfqo5FzOe7C1HbdU/fCZmyK817/0QBIdVDrvwMqxjD1d6UkT8Mc5kyealQUSc+g55fK1i9b7q06CdKq8xVOBGgDEfhfebhpAI/+rLQ5mmLlv0DRcak5TR/rhbGvMvqOL5m1b6fh6QEW788QnqSZ+BL/pPvG6ETc1U5YpzFbxGC+yA/9PkwKBRbWznJrj/c9YS4tnw0R4SqVE6At7S8Do9MOYIxabxHEv6jo3b7lM3KjLMPOuxHzN+vpRHukHqk8XYCehPgsTgle94NCyKY25e1zBwE37uC70eAK1zc9iqXlqGdVx2r15Ck+F0HutKf7E0+wz3J2MnmDGAxXd5Cx1LiIAtt4zBdmWRlIwCmImRZDoBa3qcfLhZo1JKh4TdrJK7UCEuaoBIgtdXvD2Owdflzu4/3BQy+6BRP42u8RkOZY5atou0j3gJ4OsSIzI1gabxJCTf3XnNQWnqYWu
 YxAXZdF6
 t6MjJui7X6CWM70zK7+X8tPRBZzSzxgI+VgSrGBiEMheYsAMPx5XnpgSfepbdFiRnJp0NGu5c1XWtrmB0nTdpgDu6gajtdML2VXdWL6xze0Y+x3SDMMO9kIOGpxQQ74JjnTrP+2nRV3qfw6h38QUKjAxr4gd7P6SutCjfgx78mR4LkR3+oVpqvhhG8lYvBvPXJLYddbzlqzdQ45O7Ok++tWl9ZAF9rp8g1iabVAfsFaM61rwcqBXOH/dFOMCqefE3/g/KT31r7LVsa5nsJBQjFr27ZngOMioI7EKrcrWkRpHyRoApNuur6BKTyz6SnJcEGVQWvb9nY+PXjjGsG+wvPcxUTOUBUOKAn15HQsLDon5Lu9hKz9jQcKtKaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's remove the remaining pieces of CONFIG_HAVE_BOOTMEM_INFO_NODE,
performing some smaller cleanups around freeing of reserved vmemmap
pages on the way.

Tested on x86-64 with hugetlb vmemmap optimization in combination with
KMEMLEAK. Heavily cross-compiled.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changes in v2:
- In patch #2, reverse the order of setting the page count and clearing
  PG_reserved, and modify the patch description accordingly.
- Link to v1: https://patch.msgid.link/20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org

---

David Hildenbrand (Arm) (10):
      x86/mm: drop order parameter from free_pagetable()
      mm: provide free_reserved_pages(), removing x86 variant
      s390/mm: use free_reserved_pages() in vmem_free_pages()
      mm/bootmem_info: allow calling free_bootmem_page() on pages without a bootmem_type
      x86/mm: stop marking vmemmap as SECTION_INFO
      x86/mm: stop marking page tables as MIX_SECTION_INFO
      x86/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
      mm/hugetlb_vmemmap: remove bootmem_info leftovers
      mm/sparse: remove bootmem_info.h include
      mm/bootmem_info: remove CONFIG_HAVE_BOOTMEM_INFO_NODE

 MAINTAINERS                  |   1 -
 arch/s390/mm/vmem.c          |   4 +-
 arch/x86/mm/init_64.c        | 134 ++++---------------------------------------
 include/linux/bootmem_info.h |  89 ----------------------------
 include/linux/mm.h           |   8 ++-
 mm/Kconfig                   |   8 ---
 mm/Makefile                  |   1 -
 mm/bootmem_info.c            |  72 -----------------------
 mm/hugetlb_vmemmap.c         |   8 +--
 mm/page_alloc.c              |  33 ++++++++---
 mm/sparse.c                  |   1 -
 11 files changed, 46 insertions(+), 313 deletions(-)

---

base-commit: d11ba1f570615ec8d4814d6313ee1d7075a33787

change-id: 20260428-bootmem_info_part2-4bbb445d9b3d

--

Cheers,

David


