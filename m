Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E54A9C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 08:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8F396B008C; Thu, 10 Sep 2026 04:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E40406B0092; Thu, 10 Sep 2026 04:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57D86B0093; Thu, 10 Sep 2026 04:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B459C6B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:49:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C21E01C233F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:49:21 +0000 (UTC)
X-FDA: 85197228522.29.9BDE3EC
Received: from mta0.migadu.com (out-193.mta0.migadu.com [91.218.175.193])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1DB0620002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:49:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eKzxXpg0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789030160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgO5d95uGJnANtOo+DNdxggvxxjoUhNNBU7RPPeq/qs=;
	b=kPM18PwS1b+UULmABuQGAyKqok5ad8lHyFRkB4Wv5ETxJJALNnfvlBgmRHQOt8icBgIB6Z
	i8ZFPjkxQw6kzO8/9W5z78BMcnXOv9lTFapWS8d9c+GLpcflm11mtqEPj5HeRYoJ16mPcO
	M6Y+xvoKR+uiQfh0YJnfeASHXJzOWMA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789030160;
	b=VoyOi0zBmyVubBlaS6tfH32k5v1sTrmGcZtY+lXi5BeBfBzWmlAd1fANOBseom7Vz4f7dD
	Cf36bw3X93FO8WC8nNC1V9VrOO1fBDMtlRv4xpPcSnZFVmL91azQl4kVyqGnj+VF3zLIC2
	oSmbf3im6SHxpbKfmHg0BT3OazdKzIE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eKzxXpg0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cKuwuIWP8qEeczDc5QlfnsAOInD0LRisQ2KVelC1a+w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789030152; v=1; x=1789634952;
 b=eKzxXpg0e1hs7CJm0Qn1KX2+hceWPwqalu45lskTdhbCW5Nulqynl++5BsJreCVTkezCZecP
 GzYgaW49lP3XNbbcYYShqGF9C7JbSoTzliszift/7eZltVl5Q6V6TJ/HcOn3L2jeo07DTKrp4U0
 RmWjPObmw1oToqhVro9EVsZU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 6767c20d1bd6aecd;
	Thu, 10 Sep 2026 08:49:12 +0000
X-Mizu-Trace-ID: 6767c20d1bd6aecd
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] mm/hugetlb: account for allowed nodes when gathering
 surplus pages
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260909074642.7308-1-yehuaisheng@open-hieco.net>
Date: Thu, 10 Sep 2026 16:48:56 +0800
Cc: osalvador@suse.de,
 linux-mm@kvack.org,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8A0F6014-4E2C-4F07-9732-2DF32418B986@linux.dev>
References: <20260909074642.7308-1-yehuaisheng@open-hieco.net>
To: Huaisheng Ye <yehuaisheng@open-hieco.net>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1DB0620002
X-Stat-Signature: p9nkuhkfsk3sjd7wnneqxobmwjm9mmhr
X-HE-Tag: 1789030156-268678
X-HE-Meta: U2FsdGVkX1+tLZKbnBkbPui2dwEAXmq5HHb7nhsCxvQ975w2M73CdSvtvpRWwRPeLDb0yjQtmulP1ZAhqVW/uyoaruAXXD8ZK07Z7ldgeMgzDQE9B+c7EM46gO+z6D8JYtp8J/HZakimhk3RjhNxrzBjlMzDzyPhgbwlx/ipzyyYGI9XInRyD+XyZpOwemeWJU0MjfTGPgj6fUAXLqrE5ZCFEomzfvRHKLePtBWyzDc/9c9l9C8bQfGEhJLtiE/H3Xh2Fs0uycsoX3ktldYnq7nQVKFyclag94SJK08hOg7ouAjvKUjCvVaKkTyKw3BwLzC2TPaxH+LpLxjck0scoHB8MV8LTx1/vrzyCL7yp/PUYnnWwDX2yXe5osTOiwJcSQ6sEUohPON++QMBL1Cs2ZAS/UaMiZL3b5q9bP3ljRxdaIKv2lAI0CsKfkk1k3G5uhwEHprH5QAdaw+i3/jgQnPgqMf4X7fzZDpXBKOBzEGfVcxY3qcJB3kvkbdedjYI0RJdABAAsgSMIWyXvcjIKvURwu59A8pzbqzJGEHsC6ZmmIpJOAo1+5GwvvA9L9eBWg6hTzxtCXsCkbEcAhr5SEqEdJ9/EwzVZKfh0w4jw03Zh7eHF2UhgsEAeJ9Li5nibY2OHzy75QLH+JK2ZpeK2tFU84zWMMBwekuRNrKjUCYyQBKE24kQQ6vUzrVYK5M2QnhB1rB2V8x81/myzu2c8eouI/YNr4s+0ernj9d7gaFVJt8pRGkTAPWRjj6KjHq9vFX13D5LlCIt9ppLxeMz9cC28uQztJXLwxFoxodRbEBhyUwNHSLOveSEmPOZ9ZjP/k0NXWEmr3wu3P97IG0WWz5X+WSAfZjlPoQV8bhsOa4c1k1ulkK5+r40Hd7WXzGnc/Ig6ThANUDd3E3TR66Te0qJ07Y1pjheLGdpeIl+ep5xBsBq+1CnZwkkETs2+Qg+s4gMqH5XAajoue6dddj
 s9fX562n
 Y1Oovzp7SOKeciZ9X9Sa5H04sxYmMgh+MkY8xW9/YGxu+msR6PCzPNxhpDhoJLJHR+T9uc6EVVKsX5TyGxaChg8WhByVqyaMgwjZ/CdCUXa18nc4Rrj+jLOL2rpyS9QM5al+lQLWvGv4AhIISqbN1S90dis2URmVKqsPTp6UaxPxLA+J2Bj1T+WTyjDqoRKuWr5PILYr7BGOvfXpO7uEHiAhdYkRIi00ix3+1ONpg094r8mr+td1NYpAv3hhCryWblKRc26qP0wcYmi8n0LjYIg2YEsFP6gQ77kRdxpwC8uVcLHPcnmIKBJ76p/6V2oezO3PG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 9, 2026, at 15:46, Huaisheng Ye <yehuaisheng@open-hieco.net> =
wrote:
>=20
> Hugetlb reservations are accounted globally, but hugetlb_acct_memory()
> also verifies that the current cpuset and MPOL_BIND policy contain =
enough
> free huge pages to add a new reservation.
>=20
> gather_surplus_pages() calculates its allocation shortfall from the =
global
> free and reserved counters. If the global pool has enough free pages, =
but
> those pages reside outside the nodes allowed by the task, it allocates =
no
> surplus pages. The subsequent allowed_mems_nr() check then rejects the
> reservation and mmap() fails with ENOMEM, even when
> nr_overcommit_hugepages permits allocating surplus pages on the =
allowed
> nodes.
>=20
> Calculate both the global shortfall and the shortfall within the =
allowed
> nodes, and allocate the larger of the two. Include surplus pages =
allocated
> outside hugetlb_lock in both calculations when rechecking after =
reacquiring
> the lock. These pages are constrained by alloc_nodemask, so they =
satisfy
> both shortages.
>=20
> Easy way to reproduce this issue with 2+ NUMA nodes system:
>=20
>  # echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepage
>  # echo 3 > =
/sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
>  # echo 1 > =
/sys/kernel/mm/hugepages/hugepages-2048kB/nr_overcommit_hugepages
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
> This fixes hugetlb mappings when, for example, a task runs with
> MPOL_BIND on Node 1 while the existing free huge pages are on Node 0.
>=20
> Similar issue also could be found in ltp if the free pages of global =
pool
> reside outside the nodes allowed by the application.
>  # cd ltp/testcases/kernel/mem/hugetlb/hugemmap/
>  # numactl --cpunodebind=3D0 --membind=3D1 ./hugemmap10
>=20
> Signed-off-by: Huaisheng Ye <yehuaisheng@open-hieco.net>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


