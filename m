Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3C16C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 18:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3E36B0088; Sat, 26 Sep 2026 14:46:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B716B008A; Sat, 26 Sep 2026 14:46:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B20F6B0093; Sat, 26 Sep 2026 14:46:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46BAB6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 14:46:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABA021C38C5
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 18:46:02 +0000 (UTC)
X-FDA: 85256792964.09.321A8C6
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7D59B20004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 18:46:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b="JuvPARc/";
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf13.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790448361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZRqdnQVYOWo/r4+FEgARvCAFTE8PSP6/Q+C1nHisg48=;
	b=POq+43CJC38fBTmhkRLdQoFx8CJwr4K86iQn9a4g9Wt+pOjbGqsTkS4JhW1VHb6MCG6Qkd
	ghRS+UaUr9aP5Aqm6lWcllQHSfJVVVAc+NqIsNsjL5+XfHv85gxMciKTqvhj0sr2CZYsWh
	sME+QLCxUYj1vFke1IhWlGQZz8zKCSQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b="JuvPARc/";
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf13.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790448361;
	b=aAvHEYehbPdz7gqy9semVE8RY7u6DY9I3H2xN6CXJQuiKKQzrGNflRT6U1vTTvKfnnwG0+
	RDKMMv++NKj0gQSWgZ/DWwHWQWKv8C1Yx16LKGUXbOuHKx2ER41g3vm3m+LTdtvOpzZw0t
	GnuKHNCafUS12QP5b9BflJ5eAFpTUO4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=ZRqdnQVYOWo/r4+FEgARvCAFTE8PSP6/Q+C1nHisg48=; t=1790448360;
	x=1791053160; b=JuvPARc/zeT7q5Y07XX36q6HOXsoUA9bJMHdlRZgsnIiLmWrJi+ZRrnrlTMBY
	VMRkeQ14zWvlXlWvGAFKmdMGTq3QnX4v2B3oQ1pt6wRSqSLWST0YsmqyJDyMUfiryFtOYwlzg5X2Y
	z72iykdmz+KjtBFP7HUT4dDbFYhNx4erUqFbi26YKiHTXxoxQF7jprt8+0DmGC7UrltxUQh7/4hyY
	9PH6JBcRDz7hNqDzbXB10Ge6MqrtcxdLkKjg2IoCW7taMILv9HvQIDV3hkHRW/y10Lp+2cVIPlyW4
	dndTv3kxMMBh7piiluxrHz3oc2FwDqGs9Iz0TfBrBBt7tkqNHg==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.100)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1xAXNC-00000000zck-2x3m; Sat, 26 Sep 2026 20:43:46 +0200
Received: from dynamic-002-245-050-003.2.245.pool.telefonica.de ([2.245.50.3] helo=suse-laptop.fritz.box)
          by inpost2.zedat.fu-berlin.de (Exim 4.100)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1xAXNC-000000022yM-1ytU; Sat, 26 Sep 2026 20:43:46 +0200
Message-ID: <9b75aa51e19f9c0f5c97ac02cfc0948ab5bbf279.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 0/2] sh: mm: fix hugetlb on SH-4
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Karl Mehltretter <kmehltretter@gmail.com>, Yoshinori Sato
	 <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>
Cc: linux-sh@vger.kernel.org, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Andrew
 Morton	 <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Date: Sat, 26 Sep 2026 20:43:45 +0200
In-Reply-To: <20260926183904.76186-1-kmehltretter@gmail.com>
References: <20260926183904.76186-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 2.245.50.3
X-ZEDAT-Hint: PO
X-Stat-Signature: ao9mi8h4t9o15x7ffduhz8jkxjdgj4b4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7D59B20004
X-HE-Tag: 1790448360-345531
X-HE-Meta: U2FsdGVkX18TUdPmeoFGpRSzy2NOpR+oycCfT3jkHrHaU51EreQ/9bDhmTezWrb7NAGAVXD7khJPbpscY6MN8zoMg8+MQEhyDuHYhOMIZbOzv6lCzWonPrTbME9NWi1vaFE3GbA5c1BhiWf65L5+D2KFmSP4jpavPjYNDWZtu1q8/j2KbVl7HnSZtSzuF26qJNhqFwVpL2mepaqddq3NfjzyLVjjfewia1uA/hTTks1sZkAgGS+8gFBEk82bXcK7ZHVlcHZbJe/6hC15EpR/6d2gEvViD3aZde2z1i+Ak7RloGZIm0rvvd17qFKXxmtDV75kRjSW2g9zXddzXlQvfx+mMCjunmEwGcGzU/ZaPUe1z2gBBkzfB3v0sRxKhG7OAjQl3BVfmHdzFRhaoudW1F1MZZ6yHHO0TO/pP2f6OUGqEzsrF7ZdE1MeVlOfE9I+L7t0+2UmWdOJyGHNfpwPJ7+J+KcSnkk+ePII6ro/BwJhsJgbxeyyXHMW/Y0zTyomF2Tl08YRs4jfhFbZnM+pa7LbqoeWxiGx7EG3mAsDHEVHx7YCqK4j46hQ1cZxJyM6hO0ed2v7HvRKLlHgPT/NUHCxkdhJQZwHUUQ0l9xl9BSxzMTMqC7d90aHbjLuXVFSr7jbvIUBywvCBMVhQLD6YLFny0zbPwrIaNWbC888umBy383gr9RKk3ZoAK40eHygULmhVle3W6rVAdNW2l4ci/zI1QbQDZUc1BV3+cc1z625E0yTSFUnX7TPXXUw1rCinvs1WEhF1nRH7VVcVwUwjSgb/t8GOMXGmF2RltcNCAIX820ub3Anbd6TF5FAcL1s1JaCmINGetlRH7WtJlgaWNxOaIbYVXriGJ5e31bU9WYJuaFF6pDt02HHB9yC0R+RN27J4HaOHmvsaVqOGDODM8quV/D3W75A18LGSjfQz9X4Z0P1DwlAbPjYJCMlae152IcOOFPcCyay96tkJK7
 6sfQJebA
 3CZaNRj9dguObC15sYXAYHFgtwv2XHA/e4CJ13Chc6uArrki7+8bL13LkiywOMRbSJiP8u2+kSxKcI2w4cDkgZKY9DVvA50EBiOx3rjP5ZrsFNZOubW/tV3FANnVX69ONg2yEayvENh8vqDNIvKj3YlUBvsuzKT2haVzWig53W77mh06zcU8lscyUWveGzPHTN1amAL5gbKq5+0Afbe4ao8pnU2Ysv/rkJbM+W/xzT+iDXvAZTJfQMgqo7Evsu0Kv9JRf6tT8tUI56HDphjL6LVdHgeiucsI3q4ULVpZedngL6kC/ZQjmwqdxtUBBQR2Yc1E2IfyZNU+yB/aSqW1AJEc8CoeESQNoBJqy9VK9V+l2QsIiRdcqTiYHTyxl7O3i1NzJSrn59agGOpEhOh82+00P9Gnp+ntyxVj3XAQGBGI/FrFm3MgegVggog9JiLjmk17x8XO0OrdNmLcWORHcmh1GZeST0Jw/adCsdZjv4NnHS6fvGdgw+GVD2UCcYK1c61b2/20HSKZZWLqJYRDKCXJu8/7Yry8rarwWKBrlXc09n0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Karl,

On Sat, 2026-09-26 at 20:39 +0200, Karl Mehltretter wrote:
> Muchun Song noted in the review of the Arm hugetlb alignment fix [1]
> that SuperH has the same arch_get_unmapped_area() gap. Reproducing it
> in QEMU turned up a second, older bug that corrupts memory once the
> mappings are aligned.
>=20
> Patch 1 fixes the page size in hugetlb PTEs. pte_mkhuge() ORs the huge
> size into the base page size bits, so 64 KiB huge pages over 4 KiB
> pages are loaded into the TLB as 1 MiB pages. User writes then land in
> unrelated kernel memory. This dates back to the start of git history.
>=20
> Patch 2 aligns hugetlb mappings to the huge page size. Without it
> mmap(MAP_HUGETLB) can return an address that is not aligned to the huge
> page size, and process exit hits the BUG_ON() in
> __unmap_hugepage_range(). This is a 6.13
> regression.
>=20
> Patch 1 goes first because patch 2 alone makes the corruption reachable
> through a plain mmap(). Both are marked for stable.
>=20
> Tested on QEMU r2d (SH7751R, rts7751r2dplus_defconfig plus HUGETLBFS
> with 64 KiB huge pages, gcc 15.2) on top of fddfc3ec3179. A test init
> maps two huge pages with the default and legacy layouts and with
> MAP_FIXED, writes and reads back every 4 KiB, mprotect()s the mapping
> read-only and back, and checks a COW write in a forked child:
>=20
>   kernel          MAP_FIXED       default/legacy mmap
>   base            memory corrupt  misaligned, BUG at mm/hugetlb.c:5215
>   patch 1         pass            misaligned, BUG
>   patches 1+2     pass            pass
>=20
> SH-X2 (X2TLB) is only build tested (r7785rp_defconfig with 64 KiB huge
> pages).
>=20
> QEMU's SH-4 TLB emulation flushes only the first 4 KiB of a 64 KiB or
> 1 MiB entry when the entry is dropped [2]. Keep that in mind when
> testing hugetlb on QEMU.
>=20
> [1] https://lore.kernel.org/r/5AB6FE85-4CB9-41EF-A700-BC5E071F29F5@linux.=
dev
> [2] https://gitlab.com/qemu-project/qemu/-/issues/4598
>=20
> Karl Mehltretter (2):
>   sh: mm: replace the page size bits in pte_mkhuge()
>   sh: mm: align hugetlb mappings to the huge page size
>=20
>  arch/sh/include/asm/pgtable_32.h |  7 +++++--
>  arch/sh/mm/mmap.c                | 11 +++++++++--
>  2 files changed, 14 insertions(+), 4 deletions(-)

Thanks for the patch! This should definitely be tested on real hardware
and I think it's a good reason to test this on my SH7785LCR which wouldn't
boot on anything newer than 6.5.0.

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

