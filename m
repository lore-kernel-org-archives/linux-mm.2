Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A879C982D2
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 10:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51E5C6B0093; Thu, 17 Sep 2026 06:04:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6896B0099; Thu, 17 Sep 2026 06:04:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 434B16B009B; Thu, 17 Sep 2026 06:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 211436B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:04:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD0E61602C9
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:04:30 +0000 (UTC)
X-FDA: 85222819500.09.BA8215E
Received: from mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id A3BEFC0002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:04:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ueSc98HZ;
	spf=pass (imf28.hostedemail.com: domain of li.wang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789639469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fabKLAC3bKr5t5Kyp0RM2pRzYxTpx/MWHp/+zdor2Eo=;
	b=OZplqINP/q3vvnMBf7Zj5W2Zs+I6515fyrPSIk0cvPTSCHlU9K7CohVpfrJX6Y3hpMJyea
	PALCJRLHN6PF+qzWKmR+SkMFaLMboyQ/qgO75q4PMspvOU/b/Cb4oxL3BodYL5xJMmbQkn
	2J3RIM97U5QZyqm2MG0J8Kh37tCMTLA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789639469;
	b=zN0pvtUAaqi8N46aFNw2b3kPYF9JaI6d4x72fXOCyJNeKm7IzED/jB+pNLCP9FEwYvrYIf
	9zmLK/neIiWtVH/d+ydtWXTNuxSrt8BKc8X6t1QX2Bb7U+0C9LCA/FgTLtVZ7J9Ls3m4Xj
	fAtXXJrtZA4+tFwRdXDwmDTr4HUsWuQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ueSc98HZ;
	spf=pass (imf28.hostedemail.com: domain of li.wang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kf4yD5Q427qFgBm9Eg16ajofX01qSgJCx3NFLn2NNWU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789639467; v=1; x=1790244267;
 b=ueSc98HZiHZXHy14wrUv9eFtrGd/x+WRTiw3LFVL5QOjOUyxFzxhXAFF35zjkNWEpDU2Ay8Q
 rpNTAUv00n2MpSQ95nOUvBCcvLiJ7u6lGvLXIbACxiS/VbGhenZCIpUkuf6/YxX1UKAzRk0qHwf
 DnGMJ3hvYXijDQe2M+QA0vKc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0b148f135692a024;
	Thu, 17 Sep 2026 10:04:27 +0000
X-Mizu-Trace-ID: 0b148f135692a024
X-Migadu-Flow: FLOW_OUT
MIME-Version: 1.0
Date: Thu, 17 Sep 2026 10:04:27 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Li Wang" <li.wang@linux.dev>
Message-ID: <52d4bc05e867f675fda9f1d5dc34769c10f371c8@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] mm/hugetlb: account for allowed nodes when gathering
 surplus pages
To: "Huaisheng Ye" <yehuaisheng@open-hieco.net>, muchun.song@linux.dev,
 osalvador@suse.de, linux-mm@kvack.org
Cc: david@kernel.org, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, "Huaisheng Ye" <yehuaisheng@open-hieco.net>
In-Reply-To: <20260909074642.7308-1-yehuaisheng@open-hieco.net>
References: <20260909074642.7308-1-yehuaisheng@open-hieco.net>
X-Stat-Signature: k83k4d1e6k8fki7jjh81siop5chzyoyb
X-Rspam-User: 
X-Rspamd-Queue-Id: A3BEFC0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789639468-641450
X-HE-Meta: U2FsdGVkX19T6Gr1Cc+/f9tK1OA06hPdyExeW0eqLDS4oyeo4l5vhGWxlrUH0YzEzJhqDH5ud5bqd8ZpJPcAb3TyfK7AwYgZlP2Nb9CUovBx8lU1bjYR7zJMw2xMUdwXmkmFcezummmuJ50oK4P7rvUwWB6aYfs7faD8UirEbG7TY3hz4X+OcLu4uHybLaAAj826hT0Ecw+ZSlJ7UdnlwD+XK8lC1PvjSFWGzp4vJh9oEOIH5MlLlWnVbF19M/pml2ztl3D2x5ECJjYqerId41Uk3DwIJuTl33WuWCZPE7tpgK4C4hb8Eq1DW8abDjKPWSgFchbDBr8Oyyl25Q0GwXoUHCAdCNMXW/J6Hjk10xFrk52gRkyLIwFB4UotTgtHJT7sx1hq6pHb2752zjbNV3L0/0SF6edmEmj3gpl0IXwPejZIdtpIeVmCo1VGG7UGs772QJBI0QnsA8ySEgo/1irqVzTwmod1aVcN4W3b9DA/53nC5j9u4wqqvsMYvdN5TJ/uPtkVkq4wNocrryL8O2ouYU1A07rBduj/F2s6p2Qjk30FeMElH+YK1kojRofWDl5XTaBEaCFQmu0GlPVuhKthHR6DINZHJBEeSx6W5GRbxOf/a7SRynpqOptOO60mu+iCExjnWWQLL3EQxUKMs88PWTjg9Tjt47gGIeXWxYphTOl1LN3evOFRyTvquuxLXKqcruzxC9c2cAyKgm9oWtKJPxKycQr9k6Co6xi2d/nwoRIUEe3tE5k0A/Oq6tKR2hYNCkYC+a70dHb6vMKBepHG5dGjsGYMuwH3ER7yn5xk81OlGg4WtbdqHzlmLjOr4oYJy1ljWUHDPIVVWspT/znxVqs8hQEQdt7ocIGbhIoDjCnzLXCbKmM/ov2+5fjqnmZ5JAC4M9Kz8Hx/fSBJ9RBxx+rfCOpbCuUbxiMwx127BMF+pu5bg2GK1NHNgVmRN0qO5mWfG0PUs9umq8T
 omNbT+Tz
 4yQTt+PWWIxnGGv6ILJ7epoMS2nRkxSIQvnRHuMnuIn9tc4jlbDZdGZdK/lJMNJVXV2+Xaqno8cVkxcaek+m/DVlzGSzEewBSiFgXsmW2ci3Aq2sVLrI//8AABISBkgeCwVqO/rfaiLACdcukxqUc7H6pb+J1L77u1wnqOWwUEuF0MD29Saer77Y/LU8+ehrcnFK+UEmvdLb/OoeqXT4UVFQnZB6stAuuUq57+yia7838fb6Hi7uwZFxdO/mlijjbQuq/QBDciAfJz9AiKjh/gq5SMReVSCNfwl7NLGy3b/Wv+KuSVsjdMS9ICnBYE2UMLj0PCTRGkZB8Fo4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hugetlb reservations are accounted globally, but hugetlb_acct_memory()
> also verifies that the current cpuset and MPOL_BIND policy contain enou=
gh
> free huge pages to add a new reservation.
>=20
>=20gather_surplus_pages() calculates its allocation shortfall from the g=
lobal
> free and reserved counters. If the global pool has enough free pages, b=
ut
> those pages reside outside the nodes allowed by the task, it allocates =
no
> surplus pages. The subsequent allowed_mems_nr() check then rejects the
> reservation and mmap() fails with ENOMEM, even when
> nr_overcommit_hugepages permits allocating surplus pages on the allowed
> nodes.
>=20
>=20Calculate both the global shortfall and the shortfall within the allo=
wed
> nodes, and allocate the larger of the two. Include surplus pages alloca=
ted
> outside hugetlb_lock in both calculations when rechecking after reacqui=
ring
> the lock. These pages are constrained by alloc_nodemask, so they satisf=
y
> both shortages.
>=20
>=20Easy way to reproduce this issue with 2+ NUMA nodes system:
>=20
>=20 # echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepage
>  # echo 3 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/n=
r_hugepages
>  # echo 1 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_overcommit_hug=
epages
>  # cd tools/testing/selftests/mm
>  # numactl --membind=3D1 ./hugetlb-mmap 2 21
>  TAP version 13
>  # [INFO] detected hugetlb page size: 2048 KiB
>  # [INFO] detected hugetlb page size: 1048576 KiB
>  # 2048 kB hugepages
>  1..2
>  # Mapping 2 Mbytes
>  Bail out! mmap: Cannot allocate memory (12)
>  # Planned tests !=3D run tests (2 !=3D 0)
>  # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>=20
>=20This fixes hugetlb mappings when, for example, a task runs with
> MPOL_BIND on Node 1 while the existing free huge pages are on Node 0.
>=20
>=20Similar issue also could be found in ltp if the free pages of global =
pool
> reside outside the nodes allowed by the application.
>  # cd ltp/testcases/kernel/mem/hugetlb/hugemmap/
>  # numactl --cpunodebind=3D0 --membind=3D1 ./hugemmap10
>=20
>=20Signed-off-by: Huaisheng Ye <yehuaisheng@open-hieco.net>

Tested-by: Li Wang <li.wang@linux.dev>


Regards,
Li Wang

