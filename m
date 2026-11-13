Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9CD0606A890
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lQZMDQ4M
Received: by kanga.kvack.org (Postfix)
	id CD29B6B05CB; Fri, 13 Nov 2026 16:26:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA9CF6B05CC; Fri, 13 Nov 2026 16:26:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98D86B05CD; Fri, 13 Nov 2026 16:26:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FF716B05CB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:26:43 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0372912019E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:26:42 +0000 (UTC)
X-FDA: 85431380286.12.E5E44E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E6833120005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:26:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lQZMDQ4M;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794605201;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6XYL3m7pR3XD5gcmbX6twLNHi5++AAkwL0wMnUcMCNQ=;
	b=vLML/e8vmuXa5PxJdIPW5oElOx6MRd/0DPkE/xIte8CPHsI/Fuf37u9O25t0IM2grrKGbe
	CcvOL3KIS9jk6klLXLhz2dbxVs7YTZO/FUnbDd1iSnlWkCgoW2ls4dOeT/coko4MMoMsWH
	6olWXxShkKM6NksShCndVsVqbrmGMi8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794605201;
	b=WVZQs/E1uoDR8c1ils4RtNRzF8d/fsQDMiUNIyrgHosNu1LNF5yQbsI8chZR7t6QhDLQ9/
	UE5DEMCWyTV1hOLZ3LujIWkm1yJ3YHViBZUiTFal+5uKEC6ujpiH8B8Mi4f34FPBIiPLez
	C2de2WvAquv8ObdPnLQRWUu/jnevWbM=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lQZMDQ4M;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ABF66634FD;
	Fri, 13 Nov 2026 21:26:39 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794605199;
	b=zwVYN0MwUAH0RUFiuR4FaGH706a2K0w3E6C5TV24J7debfJgLpzfnJpGWOD9DHevCZq1
	 TO/lWr96llMbb4DNONPjT6zHjzAaHAD5PuzNPN1C2vb9OInq1IpAn0DgIGtkFxQJbuA/U
	 9gTbgpQBVP0XPT0/t8JYcB0hvASqR9WKBixYaqYZy3MVz0BKQGU3zOYgezVJYgqea9eQQ
	 sxECD2kvLsyskQr8HaOeXXtGyvvhbvDUFe+8lqxYymONeGweran61baKg7UKxJFeS+ISe
	 DxzaAWFSmdtsS/eAbpd0eT1hxBd6AZbIUy/NdHOCcMh1xW/VUAG9Nfc6hD1lpvTuU6Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794605199;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=6XYL3m7pR3XD5gcmbX6twLNHi5++AAkwL0wMnUcMCNQ=;
	b=aW32Z7rjGn5BlKbLe5edI+84i/LHwQY3e0O4evm5OGuCxV6SgoZ2z9WDN0W3DvWPN42H
	 3jET9XXtjuQCJlGi1fJOos4Xg/ug24o1t8cSpZjcXhuxvZZ44ayB9D2DG0M5wZFIJP/50
	 sIY601oXoq/pVpanBolTXgtD9UiwbA3QlPQ9YYeYpiMIjlOyuINAVOjcLblCBMHsYKxAr
	 E/ksmG4T6svmr+s9nccknhJXH682fzVDTBwyQKHYgpRpKlhw6waVBsjgxdWX/dKy6UgGB
	 eRaApUMoi/ggo/W9bUH4qD0VDTv9NpWzexDRLPZLxXlN+wqW5kS5FSL1RLJ1gaXGAfQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 73F451F000C5;
	Fri, 13 Nov 2026 21:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794605199;
	bh=6XYL3m7pR3XD5gcmbX6twLNHi5++AAkwL0wMnUcMCNQ=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=lQZMDQ4MTntkn55cSd4mrJU1tc44GgQmig8hNnszUECieY07GJNb8EgAhtS4PpZN3
	 LQZTdWR1YAywc7ZOKsRDwjS/DEYU00xmM5RhuYLi8hsp9Rs/ZWEaOyMy44hRy5KnAU
	 OcF+jyttVaAAmtwXVBmd5Ku26GEm7WOvfebgy2Af4csez949LgPcxWvMnEEh49SQ7U
	 CnrHTRBLJySnHhdeXOIVo6NOxPZ+HYzLIR2ZaIGg7cPvkh+EDqCxKvMutrs9K/pf7N
	 BqxU7wD0xE2RX5GfYtubs16Pyk8lMFZNdCdFBgjPBhqABEeO8TCIAfWawaH5IlGn0F
	 4sptIQ3bLthsw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C658249B12;
	Fri, 13 Nov 2026 21:26:35 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH RFC 0/8] mm/huge_memory: clean up and speed up large folio
 splitting
Date: Sat, 14 Nov 2026 05:26:16 +0800
Message-Id: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDS0NT3eLyxALdkowC3eKCnMwSXYM0C7MkU1OTJBOjVCWgpoKi1LTMCrC
 B0UpBbs5KsRDB4tKkrNTkEpBRUGVFqYWlQOtKIGpja2sBcGOPo4wAAAA=
X-Change-ID: 20260915-swap-thp-split-0f86b554b42e
To: linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794605194; l=3345;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=/AbmnhDe2IJOrI78TkMUD1kXfK1J0O/e9ZtX3/CBXHc=;
 b=ZvIY7X4nvjD93wMA1BdYlQtatOQkZhI09urInLIAqNDsnRzPPbovJU2IFJM/8GMfgHOgpdduy
 bFeZZpGL/5QDNi+NWOuQeujVOGwfqIr1SpMs/ffdtk2+JnI4XBof3iu
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 7wufy1ufx9ktbe8a7x63ny1ih6n1t3yx
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E6833120005
X-HE-Tag: 1794605200-589501
X-HE-Meta: U2FsdGVkX1+mvkfJrMa/MkvMUxk+D4R60cmC7PQ5elEZNlmRPK4WYaa7An4p4p30CPJRf8QDtQc7ZTvSNURiw6as0mHBr/eLUUruVf3scnAQov4s6zK3+aFiISIKqR12c1PqZPsLb9mSQVvBqMgx41OKMC+hgFus5vEu1l79RGdg3BtCd/IjbmppBP4daGxi3fhiNaNWQBKOEw85UMoHP68uIp1V3w0arlunE5Ve8IsfsB27GV1ND11kP6nJKVQPRlIorgxfEu8cyfcP8Kgup+98W0WvBk4O0mPReA0jaKL8UKcEEmbQXi3Ml6aPSxUMq06N9oV9HeV/DnwmLQGyI5Ohwn72WRwvYFyzyhVtP+LpJY2JCcK40BnxyxptYM34oS9szLiyjEbFBVvx2DkJJxb2tq65zzr6lPXxxtpbgpctlRJsxIiawPEyGneDfiUKW4vOpccHQeLVJZv15TUWKSIV9yynR1BOxNEAn7NPcO9cSyotRgNJpflqttwEjLIvQGqkwXdjXWXecEh76eeyrYEiFbp8CISikUcl1zRIDW8GohJwHODZr1FEyDz03Du53Cd3Cf0nEffylPhD+i+6U6VFIYdW8KRimX1Fn7Zxk1/m15PALOb9snyvz1kRWP4PQJbK2KcKcTntCgDKT5uM/ofNZrdz4RQrKSTSXWDMRnhqcqXmWP5RxzeTPhCrgcP6XO1HG5Stg5UklohJzqa8xU/UForRe+v4fiWlWB4Uc5Kt81CmEFVK9Vq/cyj9DwAJGqh8z/vyNHhSja5eOG6fWHZZXsP+36l7+WjfMCp6sTdEkjYymfZuAAvRSVvQ8icY4KV8ilJpR6z19HlGL2PKvPbwRHWTRkwnmSNUOhQHOiA6cgc48ODXBjCekH2h9fSFot5/gcXi2E8Pz9Dar2IFPImxRIEhR11eU6oWE5m5HNrWBTojC8nN8qzSeis1QeEx4md0SjmmwkNGMpfN0C8
 uFJjYO4Q
 F0tLIv0Pvp/h9mflqX184Oh2JXgOy/ZsSNFXkOVyZoWhQcstL+EDvI23REX2DNS5w8hR9ff8ymkRzu+lJ0L7jJ1YdOqF71gZra1Bxj5RdVukOd5k6JfW6BECnz4cOL6qgPCmp2TcyxUkDPYR+m0WA7Faw4JbHrvO1JRTVFiHJsx8mWIWPhWXXg9J1v/+qTiiwdhPqS/dtvr5TizE0gsGJA6vKEBl6hc38nicfu4HzhlPF9xBYYK+swAAYW/EK+tEQN6g4+Xj3+Q3/VY+IoGq8i4bs0xv+V7JvJqefNjdvEtpnObpMpAr5uRIaOrv840DH4zEB3hwM5COG+EaJmvD20pgUEQafEczMl5bjUH5ypfOR6x3GwoASGcEdgWCxg3jwfB7G9uiuvmA7VUfW30nPFbaBSO9LUli8OKWtZbMBGf227rg4zxJbhv37CiL5kN0+m5T+qFyNEz4s0mABJPsd6p8w9Y+yfcY3Klo8rUz2hNKDDMD0EQhDZpYO3RFOsa0Yj8TJ/8XgNI0A6XY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi all,

This series slghtly cleans up the large folio split path and reduces
its overhead: uniformly splitting PMD sized file folios to order 0
is over 20% faster.

I realize this might not be the best time for pushing more optimizations,
but I am posting this as an early RFC as it adds two helpers, folio_prev()
and xas_prev_canonical(), and uses them to walk the after-split folios
in reverse, saving a few local variables, avoiding a for-loop pitfall [1],
and publishing the folios with a single Xarray walk.

Walking backwards also changes the order the pieces are put on the LRU or
the reclaim list: they are now in ascending order instead of descending,
which is the actually intended order. The effect was not very
measurable though.

New code is mostly the two helpers and an Xarray selftest. The change to
mm/huge_memory.c is LOC-neutral.

Worth noting (not part of the series): I found these useful while
preparation for supporting all kinds of folio splitting folios in the
swap cache. I also tried to get rid of lruvec lock for the splitting,
or at least decouple the lock and reduce lock scope of it. It turns out,
not cleanly doable at this moment, and the main blocker is: MGLRU.
MGLRU will read a folio's size without holding a ref, solely depending
on the LRU lock to stabilize. To improve this, another rework of MGLRU's
reclaim progress is needed (which will also cover the problem fount by
the MGLRU-FG series that MGLRU sometime have a higher contention than
CLRU on reclaim isolation).

Testing
=======

Split overhead on a 32 vCPU x86-64 KVM guest, 31 GiB RAM, 4K base
pages, 2M THP.  Split a 1 GiB shmem file (512 PMD-sized folios)
uniformly to order 0 through /sys/kernel/debug/split_huge_pages and
time that single write with bash's `time`.  Medians over 12
interleaved rounds per kernel

Test script:
   mount -t tmpfs -o size=2G,huge=always tmpfs /mnt
   fallocate -l 1G /mnt/big
   time echo /mnt/big,0x0,0x40000,0 > /sys/kernel/debug/split_huge_pages
   rm -f /mnt/big
   umount /mnt

Result:
                        Before        After
real                    17 ms        13 ms   (-24%)
sys                     17 ms        13 ms   (-24%)

End to end test showed no regression.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
Kairui Song (8):
      mm: add folio_prev()
      xarray: add xas_prev_canonical()
      mm/huge_memory: avoid an unnecessary folio size reading
      mm/huge_memory: walk the after-split file folios in reverse order
      mm/huge_memory: publish split folios by walking backwards
      mm/huge_memory: rearrange split routine handling for better optimization
      mm/huge_memory: walk the after-split anon folios in reverse order
      mm/huge_memory: walk the folios reversely for the release loop

 include/linux/mm.h     |  23 +++++++++++
 include/linux/xarray.h |  49 +++++++++++++++++++++++
 lib/test_xarray.c      |  97 +++++++++++++++++++++++++++++++++++++++++++++
 lib/xarray.c           |   8 ----
 mm/huge_memory.c       | 105 +++++++++++++++++++++++++------------------------
 5 files changed, 222 insertions(+), 60 deletions(-)
---
base-commit: fae273e48c398c56b819151a607a6c8792dadef0
change-id: 20260915-swap-thp-split-0f86b554b42e

Best regards,
--  
Kairui Song <kasong@tencent.com>



