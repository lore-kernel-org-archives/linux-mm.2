Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE942CA6004
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 10:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B45496B0088; Sat, 10 Oct 2026 06:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACF0D6B008A; Sat, 10 Oct 2026 06:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996EE6B008C; Sat, 10 Oct 2026 06:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74E376B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 06:34:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0546EA84B1
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:34:18 +0000 (UTC)
X-FDA: 85306356996.25.77F9AC3
Received: from mta1.migadu.com (out-131.mta1.migadu.com [95.215.58.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id EAA57160006
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:34:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o7v6ZlxE;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.131 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791628456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2VyDxK77mq7FOSsOuc0VjLLB5/X+CTe8SCo2xbPUpo=;
	b=IUC69OffUOxyBCUP9wR1JuBY+o4u7P9G9BQqQV2KFgUWMb1MS+D30HfM+dvCWjB+BBh3h5
	SfyMHzGKw2daOlIYcRk3Y+jIqpgRUCN1VC1+Od7yoohihfRRRgnLNhqJgzOJSttYeHK+YQ
	d18wY6dfDhE9aS95ySzVSKXoQ6wNmVU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791628456;
	b=bOm6EaB3GksHb2SuRwJo2kHEMFmcpMm2WdxJ4oTq1R2a1uo/Hpva/9mUjo1caCh8ttbNKG
	1hWO1NVHDw5VpWnz+lsGx/r6rQIA7O0E6WTnWQ9CBhBqsTImylk6qe6o5Cz6s1xiwkQiXn
	hcdaANFe8+7dJ0P7yba6OPzleJGoieE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o7v6ZlxE;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.131 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=g2VyDxK77mq7FOSsOuc0VjLLB5/X+CTe8SCo2xbPUpo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791628454; v=1; x=1792233254;
 b=o7v6ZlxEAY/w3T0uAInbokQuLcImEW3tq4ieDxhluOmHWMHdYELr/fwxx8FY6ovKgcaAPvIR
 sgstR7BOlg1LcwRisOLKHZ3kZtaNkiKDvz/NSS6mpN/mOefcvCMaQLWpESuYIHQvXXBpHV2t1qN
 q8IXJ7HYo6HeXnL1zi+H6nSU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 44cd96bd31e91f15;
	Sat, 10 Oct 2026 10:34:14 +0000
X-Mizu-Trace-ID: 44cd96bd31e91f15
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v4 6/6] mm/mm_init: add zone mismatch warning during page
 init
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <asoMN5F-3qvaW5w0@kernel.org>
Date: Sat, 10 Oct 2026 18:33:59 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Ritesh Harjani <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Lance Yang <lance.yang@linux.dev>,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7E20DFEA-72C0-4417-92E3-66A077904AE5@linux.dev>
References: <20261010075755.83339-1-songmuchun@bytedance.com>
 <20261010075755.83339-7-songmuchun@bytedance.com>
 <434B0573-BF18-4413-9BDF-C5873CC13206@linux.dev>
 <asoMN5F-3qvaW5w0@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EAA57160006
X-Stat-Signature: emref86obn6c83jhbrjb7pg4hr6uez4g
X-HE-Tag: 1791628455-618191
X-HE-Meta: U2FsdGVkX1/SwG15LWgXPY/pDKn+GaXDyvOtVOmQNWDV/C2r/OAKo1Mkq+F46+igEMZmv3XC4cnlq4znwuzcVzR23GkeV+kNVf4eNx1Gm68UbagtsUjbGxA+r7rpuMcKuAGuWeVwmi1CQlA3y4CwiQqZAxrXkSD42HNmdAWh2wDqLUqbFvA3hv4qdn63aRhawW6/qwiiQu1atTSLMEGP74SU6H2A4Lr3T0Q7WLtNjZ8ATAbhY1z532Up1Gc9hH3s7iMh/+CC8ZEju4isjYdMAtybNe59a7nKIe3SVaXF0gnJmrcVmnT2KKjRF0I0RNKIBM5puPyQF9NoGI8RshnPBZFhJMcm6x3dVa40hd/2AV62yj42Q88v2knjF59TXo7IprORbPlE+8mEmbd2I99vjvHll31e/99FQGF+zM9bW7ut8yHVkm9q/z0y5F0uRax1Dr/D5XznZl4yLNjGOh59mmleVpC3VN32YkZ/2iHNL5bBnldA5rPfKG8OU31VLKPxojR7hdAAPrzG9SCqoRWfM71FCATeCB9yx4xoc4+vHj8TymW+GZr8QLRAIFHQNPxBZirMvjsaUgTtfToFWYJcbFgUfmCk2vmZHJxdfs5KLV9y/30yhq8Ii7in10Rz9Le4Hlc/TSBL0r6aMwI9IhqPYiiYFMzOzznQb8FTQ55OEXjGWOHfWHxDOikmKf7x6cCSDQrQ9JeclF/oCfbFGYt5PlXx2LXBFNPbiv6McS8uuJLagQzy4jzyWz+mljtFLoLi2v49oap7hq+mBlTcJOEPYhrI+9iUk7g/Fu3Q396ZJg4BM6EdD/8hP5ay5Tom38VK5E/BGILZ8EbdUskCX+6gU8mImgEU5qQgGv8VZjzW+A2KH4eDyo/jCbYHsixSDveAym6alyPNr1+cNGFu+bScFoFZLr3wJ59NJj1WR0UbxbPnm+ugQUpIhtK3d99cXqtxoPPsZMbPT1Bz5AXd/G2
 0uo+YBoQ
 0a4bmdBKGu9tR5Oaf1d5W6hnjaLLEPVkIWwfGP5U6tz9X27nNRJIOVW/xeNydgqmZe0Oprg6FaHmxaABJsRPleHn/dzzm7S1MiBE2jteo2Hcm5ysZLkUlSLrnb4sVe10vm34eT5tVmokXcVFBwyGaAEpBz5C2y8xGRQFOx7Jwkv5GNIK+EEB7CHLo8sJn/iI1zjx+OSOGqArixq6X9Ibqy9+FrdOKHD9tIm0c93uv6ngZAd4JcjgRzkFcr4y5HnV3aIE1Rd8SIu9x1+3pLrcQvioma5xQ8qc8oeclv3967unfz6ZxpTCwwNx+8qQYhQa6r4wDOyGDtkWHcPw4tSioZuVoMkkYDfNdVoZqaouNYrAHCyseIFYvK2gv94HJG4YiyG3K0p6wiHEjeTYzJRyzf69mnoDOXtPU5c8ssFIrnwT0e8pdL5ovSfjrfQxiddJZOu6byHQ/3hpeWwVxinCqIyFIH7x0CHyog5qmtlcCH/4l0tI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 10, 2026, at 17:58, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Sat, Oct 10, 2026 at 05:32:59PM +0800, Muchun Song wrote:
>>=20
>>=20
>>> On Oct 10, 2026, at 15:57, Muchun Song <songmuchun@bytedance.com> =
wrote:
>>>=20
>>> For vmemmap-optimized sections, tail struct pages may be backed by
>>> shared vmemmap pages. Those shared pages must carry the same page =
zone
>>> ID as the struct pages initialized for the section.
>>>=20
>>> Warn in __init_single_page() if the shared tail page has a different
>>> page_zone_id(), which would indicate inconsistent initialization.
>>=20
>> Please ignore Sashiko's report [1], both are false positive. It =
didn't
>> realize that shared vmemmap pages are initialized early before =
__init_single_page().
>=20
> I didn't realize it too when I read this first :)
>=20
> How about a short comment above vmemmap_optimization_verify_zone()?

Good point. A short comment there would be helpful.

Thanks,
Muchun

>=20
>> [1] =
https://sashiko.dev/#/patchset/20261010075755.83339-1-songmuchun%40bytedan=
ce.com?part=3D6
>>=20
>> Thanks.
>=20
> --=20
> Sincerely yours,
> Mike.



