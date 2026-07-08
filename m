Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 332E8C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 273EF6B0088; Wed,  8 Jul 2026 10:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24B406B008C; Wed,  8 Jul 2026 10:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18AF56B0092; Wed,  8 Jul 2026 10:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5FFE6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:11:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 878D38B5E5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:09 +0000 (UTC)
X-FDA: 84965796258.27.5F502EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A2AE61A000F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hN/SiEhT";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783519867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ko4Hdlv9loLHMeM4kMSWr4+ckWdvKkB6i/m+lF4LdTE=;
	b=ReI5UiwcddzFdtnNKXKwJU7eInks/TF2neXd+6NNKWD+oLN/0sQro//++aW97SS6IHPt2T
	/G6lZv6xVJW/wLPO6WGgprZ8y11DNJd4845CYEUggPeGI7YGNHYEMDgG49UqnjJwZ4jEv1
	o4cp0R0BXEzVvvAOAPg9XavNBYUr//s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hN/SiEhT";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783519867;
	b=1dQJShxcw3YyNGtVDmNW7ZPg5J9FsxKjQmkY6q4JtOO3N5ELpXCEpZRU7R0W8AJIjC9Jgt
	JGnz2CKWlwQbv5Mv71xkmx2KAu3fAyD9ZCkNDocJTOwIAWVT5zQsyIeMmtt3aviMFM0MH7
	m3EXJZdN7j1hopmrskq53x/GEACaO1g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 74D65402D6;
	Wed,  8 Jul 2026 14:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3D41F000E9;
	Wed,  8 Jul 2026 14:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783519866;
	bh=Ko4Hdlv9loLHMeM4kMSWr4+ckWdvKkB6i/m+lF4LdTE=;
	h=From:Subject:Date:To:Cc;
	b=hN/SiEhTywl8ROd8W5sQTNgOaPwlrPqNaKn1PwiH4xjk4c8RCtMwP5MIq/zye8n/1
	 AMsqvOw8AsRS/YWKgazxPunLd+6nmh4gofbHsSwHmtNqxVxUiGpiaqc1RjhERCEoB3
	 OPMbft3hBw5/p9OOcBLH2fqZ7UktJBuHCDUd2o40KLGzqP3xMgGBakYiJhYl1fL+MW
	 JzRE+ebX2nGw/tvXWsl1Dbsno6N2eETLR6WoUtnJVpZFXLM7/LVqz8aA6ogU78XWSS
	 YJdJrLYcpV6XVxLChmpq8+8kLJa421lxsAwHRPeYYTgdNZ0ZjE+cK4ZTyeH96wODoT
	 GsPA3y9CHNA4A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 00/10] mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE (Part 2)
Date: Wed, 08 Jul 2026 16:10:55 +0200
Message-Id: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAG9aTmoC/x3MQQqAIBBA0avErBPKLKqrRISTU80iDZUIpLsnL
 d/i/wSBPFOAsUjg6ebAzmbUZQHroe1Ogk02yEp2lZK9QOfiSefCdnPLpX2UQiGiUq0ZsDGQw8v
 Txs8/neb3/QBoG3oHZAAAAA==
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A2AE61A000F
X-Stat-Signature: 94jy8ezjbh978cxrzt3w1gcx573hai5m
X-HE-Tag: 1783519867-700666
X-HE-Meta: U2FsdGVkX18Lz3V4r3V31/MOxGbZbaYO+CGpVY5nVqOZFRIq0wMblIcPvYPWDpNMddFTfk96d+TDobRZaZgW6BUpXs3hYFtq445bG3VrCZqomT8pPuNUF2fZLGk5Y3fxyBcTClwKbOWF8ayFLWsn3VlXT4YRdz6vj0F+qUukT6tJfg95DvfvtrReQ+PtWFKClK12cKihqTm2Sh+Sr/dO+iNI3LG2lIbbqHsl+Rbro+GRGNgokvET/0cavLNUhpzEAVPOHjzjE9xuBgd6xXxjIVQhLNY6A52ILlUhrQfgHoVawhPSIf4aFTd4Wakdg5d06W9fv8MzSxpGYppc0lVjbwRJmT89evDBk9R9Te03BHyy48d6xOgzoAhvdfR3UTbKDIjVd05mekVYKSwbsXTKaDIYiZK0lOpvZOh3hBgWTqPqGv1olzsrTkj+ma+ZjPlvdhl+3wAbziFg5hn4JAhu6dv8CSKlVRyCkGy1r8pAZ/V65Z6c1umYIUYXqJrsS5EQ0sMKTjY2RnY4LJ9GO2iCklPbmfu/nmKiLj5xyPd2JFjZKtCF4K95gBr5Ey/0lE2s7exge3Aq6yrFpvGRpO1v5MaSWx++uc2P/iFG53wjkvCdazNAWNw4NbAPzlVHUu5mPnILAyuKJk5WiUhD2Mz0ei+NH7uKUrX3/+jVU3hVcZQMScink6xioNqosGIyfAYgTpnlCTJxVUbOKqMrd3rfilwXMu0rBvVwRN7zzSSQfpIt9dRLeUxJTBWcuzBKVYtRzibIn3IjulMZ86EUUa62q5mWUNrWP6lE4uF2tq0xBlXwSMIvh63nScqM5ZjqrP3JLNewIpr6HxHmMU+zfWNS4crQzR8j9yO4MLDBms+Cth4zuG/10tPtTNjT5S2OMctH/mIdjpa1mARhvHUTXLJi2tOLJe73ojXFm8iJTerHJB8yeMw5v4fELGP/ohXsutfCuvni38AgT+nTTdhItcg
 6omu+WU8
 ogHwV7ey63Y9TLpMza1nhQCwdJ905dKJF2bxg9QocOndynTLkPr1cT3nX1SNOqdwAr1QdDrMbiqNIKc1mV8xpdzbPp4e+XH5IrAytxKa88aM7JShXHFZarvidzUtffjZDTSd3wp0pyxMvDMktP3THTMMIvsL8u4bKRbMjxcDVIcDMPF0uddn2RXtk7AEZhSQa19nFXuWJnWMzR+Ku9ktVP4o1hWlUBvUOXRUL0hIwsnl7XzNJt5rudBk0JhZgbyatzFXxLmM3nw+LoKZ6aZlT5l6STA+sYKv6t3AV
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


