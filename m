Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1448ECD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 795C66B0093; Tue, 12 May 2026 03:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76D316B0095; Tue, 12 May 2026 03:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A94A6B0096; Tue, 12 May 2026 03:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9926B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:25:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0343B1603D1
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:25:51 +0000 (UTC)
X-FDA: 84757933344.12.55A33B6
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id C0CAB1C0007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:25:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CernQuon;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778570750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KleV71sGLoSIpfimzX+Um4L/dQ6PAAx/tc+TAvzuzrM=;
	b=mzV9opEdwoff9hCwX/lJkOS8gAJ8Xv/WdNsOEj6rNdu9cmNIJyNJnoa1Ptdi/3ax201wlE
	CrmZLeoH5dTLMbqo6kQgQRinbpt8uVwLZhaP6x/KFhC/e84vSkiQfPGE60JSgBjoA7pH/T
	lGRVYrySCLxC7/jRg6DJkRQP/GxFCPA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778570750; a=rsa-sha256;
	cv=none;
	b=A/LI3XkTrmi41SfN0iun3vQb76V+9jNLkPX3xGqDYgFTnKo+elQG2p2dz6qcbSAOdhnxiz
	RWFt6n+tUxrSCr0QrmQJT7yBkPfPgHS5CSVhZZ21CCjOZ9fr6UUU/0KT3ixb6lAlOI14hE
	TdYo9mymZY/l0FicUUvehdtDKy7jnKo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CernQuon;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778570747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KleV71sGLoSIpfimzX+Um4L/dQ6PAAx/tc+TAvzuzrM=;
	b=CernQuonrtrcVA2MC7fNDHHIbGhU1HcTungbtLCMIta9xw0yA8bkoeWkccIPdG6zmIQasQ
	tPlnFy9nQDmaZdx1tKxz4rVtOdNjCmHJN5pHH0kzenPKlNp2X88jet4kLFchRad51zy88b
	1FcHh3iaOY76S3uX79+iVXurv5RUGPs=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH] drivers/base/memory: make memory block get/put explicit
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <943c5cd9-0796-45f5-9f8d-cb7e44457961@linux.ibm.com>
Date: Tue, 12 May 2026 15:25:14 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 linux-mm@kvack.org,
 driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <ACADAE38-650D-43D6-8000-891B59850499@linux.dev>
References: <20260511111800.2181785-1-songmuchun@bytedance.com>
 <943c5cd9-0796-45f5-9f8d-cb7e44457961@linux.ibm.com>
To: Donet Tom <donettom@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C0CAB1C0007
X-Stat-Signature: z4eze7yrbznfym9f1qk9mb64kob6iqap
X-Rspam-User: 
X-HE-Tag: 1778570749-192167
X-HE-Meta: U2FsdGVkX19/0/28RUjEmU2QU0mztKWNsgYE4Q5BQbc87lrwd1E+cN5mD56kq0YIxBRFgE340R8tP3NdenM0WiB3lgzo0OMKHhvNsS1ss++5X51EUKsGoXC5WjuFNUFBW7SKE4d9PUjcOcsp1vWtC/Coz8An7k8mkGjG/kxph4eE/UC0VDLlD0ItkBcCvZO8IE5dmNuvNOZrL+hOMwyJgjX2A24OYPyED1kG3nYtV0WkisVhY3YZ87euG9Z6fQGwV47IylptlCmOOLzTqc+ogKMVlh+8ONayh1iVSVTSzP7zYksb+F6h3RCCkVvOSllpVV0FM4293WH7w18kGREHkHD+xLBZz3FsRPPtdeQWEdB6r2c9QfhQhwpQ+JMgqtcMyyeNQPmQto1YJg7bXdevwTRdZ6GRAAPxFOVT+Ex2OaMoYuyas9o3gIl6Dz3mDfmS0v22xwU+MIKq9pFoJYNLGa2g4VvaqqwHImSqqygrwHShOkUXCIyDEdnBu8vJ5h0+HEKRBbHGlNEQ9zGZpNI8/ITrZYimFlvCkP7ZvGx/baoompdLP5ZKrnkNmLuGkfgdWzWXeZ6wL0RlNLAWWxsZBYpy4KyD24r1F28tRsizpI4oaKZxtum2kTnPQsoffzs3Hcw4RIhRbemf8UmMnsLSlzDuxuKDC4Ks3DqlTaQwgmdWkAJROoBc5xEYlhOl8bJvIFqIlGSumhUl2JIQDBIG1GtziNcDWoPm0FHW4wZ193OgxCtnHQb7ZXwehS0PokZR+5OC0Q9BF0AL/0BtlmvtkCptO0V14FPDopS8vW5LHH8pnSpSiuX3L63raMfGT/JeC7kG3ekf7Fdx27EvcZlTaNh1xxFAEUT3PQmsPFYfjeslV6innqTpQATXV7+V0DuIuwdDvk9207BhTl/RH2sy+aq72lepz0/5eDjBbiIlxwaxS8fy76t2MqIfVVteaEhYbIOunoSQS5WEInEMMqE
 5xVQeaXJ
 O8KylNuiuyRQegsakqKRCPg+LzOjvyu2RRjRCaOf3oEpMCXy/1wML5PtbdV49BECW2FskJjrr25tsXU053iGu4pUaXz/ezSLop5RHXJe6rusFP4f71684LZjzlaTtvF11pIvg1Zuw4impjayrNqMJjvPsqbceynehAaLTY1TqYUvi5etWc6qpI0c2u//zPRWPb2cwrEWhht3FlQzqEmi5ArcXXD7BqaJli7LF/s11oyw3UCO3LWAIEIQ+w766Bh8IJsLCC63hHJJODFTKSia70B3P3v6FlSZ6rWPUEZO0ewPXs7tMrvoqR/XVVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 12, 2026, at 14:52, Donet Tom <donettom@linux.ibm.com> wrote:
>=20
> On 5/11/26 4:48 PM, Muchun Song wrote:
>=20
>> Rename the memory block lookup helper to make the acquired reference
>> explicit, add memory_block_put() to wrap put_device(), and collapse =
the
>> redundant section-number wrapper into a single block-id based lookup
>> interface.
>>=20
>> This makes it clearer to callers that a successful lookup holds a
>> reference that must be dropped, reducing the chance of forgetting the
>> matching put and leaking the memory block device reference.
>>=20
>> Link: =
https://lore.kernel.org/linux-mm/7887915D-E598-42B3-9AFE-BFFBACE8DE2D@linu=
x.dev/#t
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>>  .../platforms/pseries/hotplug-memory.c        | 14 ++-----
>>  drivers/base/memory.c                         | 38 =
+++++++------------
>>  drivers/base/node.c                           |  4 +-
>>  drivers/s390/char/sclp_mem.c                  | 17 ++++-----
>>  include/linux/memory.h                        |  7 +++-
>>  mm/memory_hotplug.c                           |  5 +--
>>  6 files changed, 35 insertions(+), 50 deletions(-)
>=20
>=20
>=20
> Hi
>=20
> I did some basic DLPAR memory add/remove tests on PowerPC with this =
patch, and it is working fine.
>=20
> Initial memory
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> []# cat /proc/meminfo |grep -i MemTotal
> MemTotal:       205169920 kB
>=20
> After Add
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
> []# cat /proc/meminfo |grep -i MemTotal
> MemTotal:       247112960 kB
>=20
> After Remove
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> []# cat /proc/meminfo |grep -i MemTotal
> MemTotal:       173729024 kB
> []#
>=20
> Tested-by: Donet Tom <donettom@linux.ibm.com>


Really thanks for your testing.

Thanks,
Muchun.=

