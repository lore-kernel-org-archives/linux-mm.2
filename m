Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E61CC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 10:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ACBD6B0092; Thu, 17 Sep 2026 06:04:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25DF86B0093; Thu, 17 Sep 2026 06:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14D7A6B0099; Thu, 17 Sep 2026 06:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB7E26B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:04:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7EA7B802CB
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:04:28 +0000 (UTC)
X-FDA: 85222819416.07.DA90368
Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4732F140006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:04:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QVR71EpC;
	spf=pass (imf09.hostedemail.com: domain of li.wang@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789639466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ACPbDwr+1T+EFXGWZajuYln3pYOXIAuvexrw7M7PaQ=;
	b=x3ZWIFy5MEMpxUKFYxXDteAiMLloqsgdX6BWiZSOuWJSCHT59uTmC8wvdQaocIj6H2H31y
	aaY7kwKOMfiqEs1DuoKRtUnp0oIXCD61oVE2gnN86cTAu97bXtBJdSZu/bZgU2gnZ9fQJk
	vQbJf9hD1xUYSP/rUwvF7xpKwpq0+X8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QVR71EpC;
	spf=pass (imf09.hostedemail.com: domain of li.wang@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789639466;
	b=ws+LVP2zQW0hjQcIvGA564hmJpUaVl4XulGUxbvYY62RKRaozmtpT2KVFZpEb5WS/w1sSH
	8tih9VLGyBps9JGZ+XnPfZngl5BHWYMQDL+sIMYZfWwAKu7xSmd4pFgQNB+7p3wuDTg+AM
	xo3ILx9RjbjPgMUTx0ZQ1eu4bXFIDbo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=um+kB+/1dd3CrZpB7pm7ZqNd5aTE9oIXH5aBLAcW9WU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789639464; v=1; x=1790244264;
 b=QVR71EpCz0PgY6oK/noJmZH71vrf1S/sB7dtcl2QkvQmu1FQj2vEhV1XyW3oJfQGYQ4zB5Q5
 Gb3YVEXkKorYYXX/5CaB0Jxa2SwoW3Hx1DNkjJ+9t96IU+8vRWQT1Wt3RnsjKwUcA7j7U8DFxHr
 FlbtefRU/UUWFcoUVGuNtY6A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4b18fe0d830ae10e;
	Thu, 17 Sep 2026 10:04:14 +0000
X-Mizu-Trace-ID: 4b18fe0d830ae10e
X-Migadu-Flow: FLOW_OUT
MIME-Version: 1.0
Date: Thu, 17 Sep 2026 10:04:14 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Li Wang" <li.wang@linux.dev>
Message-ID: <3f7c7f35866b47158369bd526cc4a17244cbcd92@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] mm/hugetlb: account for allowed nodes when gathering
 surplus pages
To: "Huaisheng Ye" <yehuaisheng@open-hieco.net>, muchun.song@linux.dev,
 osalvador@suse.de, linux-mm@kvack.org
Cc: david@kernel.org, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, "Huaisheng Ye" <yehuaisheng@open-hieco.net>
In-Reply-To: <20260909074642.7308-1-yehuaisheng@open-hieco.net>
References: <20260909074642.7308-1-yehuaisheng@open-hieco.net>
X-Rspam-User: 
X-Stat-Signature: k83k4d1e6k8fki7jjh81siop5chzyoyb
X-Rspamd-Queue-Id: 4732F140006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789639466-421893
X-HE-Meta: U2FsdGVkX1/SXE8TFCNw0h4mfh539urv71unSrMjF53HfqtX+I7BVCmxpXqctw6LsaufLtDCZoC8ilOwCfaFvqA4PYcBvMOE7e9fzUO0LN7wZ0Z5A+b+N5Q9UuvplsNn1DczIVHrW4uDNVA1x8BUz/t8xCdvwnbgYzDr4x/4b0b3Xit5Jn/MQQyVeLMB1jTzWbn3y1xwjvze+Py3+BXY40qvJSCJjaDDaEFWTN7Bq98vPp+b9F4odhLSYNrU1Y6dIlQoPEtNM9OtaMsqs0+mDdn2SbArBmyw3e9uExtKnI5qMkeLUd06w6buk9mmQ4sHD877ucP05F2P9yuvOBLIaGlLzPyU1ZGecOk3qRTd/2Le5h4yY3vbJ16FP1v3GjnHelwVBbdLtRDWLArpY7LGpA2OqM4aaXfwxbVeCGaAnhNjuNjmr9lg+LDerZELbq/z8SmvsxxIJCOLcrNYaQ93rvzCTM5VyiCtzBWb1B+3d3ac8xiRvu1gv9IOc8q6rrDqnCd4uXmWoaYqdRdPzxZcwpEMr1C0K8Gz/iL5Tg01Uru8r7qO0n6DAxt9ZaVAt1m1tUfdKO4kmQ+ADkgyWBVPjIHR7iVtlS9cbDkZyii0oIh/4xZ/9XcwWyST7006qvsfxWiZ6iucCB7zOEeIiTcGAWdBkB7De9HD/Xp1bSX881CyBSxcqGHpnHsN2oRVmwgCMCxcHfDg9BAjxaPOsd0xgFJ2eYoXmzD3dgwXPl8b5pKBY/5WMYtnMyKJ66wCHNxIns5S++d9o51wGSaQgtfNnU6EO+gmjdKHGDRiM5TCU2N2SEyr2l7JRW9QfpUsh9wGVdGf0MC9T4GTURkImVKigY55i0ofPwQXFCRmvIdnWcKRG8HgQBEiwnv3pkDuIh5u+nCaDfITKwG6C+asSkc7tdJrvFJoXj3aO+w8SPqLZPqLiO82nlL02EHYAJGyfd1mVuvYYJQPi11WRCAA6xL
 ggaxVJAT
 bfcdOKrUW82Rp5OYj47h7NE+euBoigPtO+RmFyEbPCAfYxZYBwLsFwRZI9XIdfsazLrOJHa7OO8y4G5MTKT42UCEabGOeqKDQ1SHmU03UoW/1068PBKgD5etk2MnOJ9R3pC/YXVWlb0hvkigkup+bXFnAddi9MewB+uDpyPMYtOhvvpzB6uOt0L3qBlSffMrSn55mndqinny+2O6ChAIUz6z+SxAfXjIU9bKlyg/zySu20iLM2JXSV3FUH3SxEusDXEeTW4Kz6x2x3yhMgjP9vqll62mxasZEaKXUOXkVJCeuDqab4yiUFeVUcfodKUSuLdzsxjdREIokuSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20Hugetlb reservations are accounted globally, but hugetlb_acct_memory(=
)
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

