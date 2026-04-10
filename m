Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A598E99050
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 07:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 903D46B0005; Fri, 10 Apr 2026 03:49:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DADC6B0089; Fri, 10 Apr 2026 03:49:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818716B008A; Fri, 10 Apr 2026 03:49:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7482B6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:49:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32D218B859
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:49:25 +0000 (UTC)
X-FDA: 84641871090.29.FCE52D1
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf04.hostedemail.com (Postfix) with ESMTP id 69B344000E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:49:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Es7TBB1E;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775807363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOrxchEFccvy90Cdqy57xUzbU6na+pOudQlMDeHeP+U=;
	b=6LldlfCcRpZ5ot1bGzkm9xN5qbRreeeV75PbaoAKK6jkcgo4TBfphjT5HmbRu8VVBzkKgH
	0P1s94H3H5e9Ir0zkkWiD+wo9SDcyiqZPfldlPZbXl43Yw+SesXdOrOd54INHMdw4cZpi/
	9GAG0TCDZ0c9sNnvuyzUbCs53i2ctfc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775807363; a=rsa-sha256;
	cv=none;
	b=nRiiiIRdAbVNQy4J7v8ShqVfbOeJF5yrPrntUkzuDZWXec6IKTHINrSaJ6uzAniXW6blN0
	QUUd81N7eNWLzHwzCIuWWwCRTfP9N8rqiWoe9g8bBnmx5jywyckmmefO1ivISVsUS4++Ry
	195GxjeW3if5ptfifGuRS0JEmw5byLA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Es7TBB1E;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775807361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hOrxchEFccvy90Cdqy57xUzbU6na+pOudQlMDeHeP+U=;
	b=Es7TBB1EcvjF2i+n+1VSpjVKChww1HEtoszmPCpfyzfPg+FHGUU4bHYufZQJWqih7/IYkm
	reQajFGglsObNq4ogpi7zsgV9NgEUB9dBM59lXIrLp/4FtJoyrNBgF38c7tvvPODNGibwJ
	KV47JqWQietpkbIzsotErJbifzrwJ+k=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [RFC PATCH] mm/sparse: remove sparse_buffer
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <c4899f82-caa4-4692-bfdb-7ae4833f30cf@kernel.org>
Date: Fri, 10 Apr 2026 15:48:41 +0800
Cc: Mike Rapoport <rppt@kernel.org>,
 Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 yinghai@kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <242A2DF3-93E3-4D31-926A-03459AD3095E@linux.dev>
References: <20260407083951.2823915-1-songmuchun@bytedance.com>
 <b22f0af1-848d-45da-99b2-0c28b740e979@kernel.org>
 <70EF8E41-31A2-4B43-BABE-7218FD5F7271@linux.dev>
 <dcc3b56f-5d4c-4bb0-bfd8-49747df30f47@kernel.org>
 <adfBVc8ohLrtIe3j@kernel.org>
 <BD30B00B-76F4-4984-9B29-9668896E761F@linux.dev>
 <45BF3CAC-2E64-4CA7-A7B8-800FC90930D5@linux.dev>
 <c4899f82-caa4-4692-bfdb-7ae4833f30cf@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: fx7ucirrs7i9n8c1fakzux4i3t5tg55d
X-Rspamd-Queue-Id: 69B344000E
X-Rspam-User: 
X-HE-Tag: 1775807363-249968
X-HE-Meta: U2FsdGVkX19F0lCmodqNOtgruHez/nxAcRcalrmO12YbCW78O0A8sGYK9zmEs+axSZ7NLz+F9sE26DSuM3ha6+odapY1y1ei6pdt8bDIMtM1kkZVt1GVyyqpP4FQvJzTLnlTdjqSPQ7g/m1besOZ/OjmUnLKUXDPfb0kzd1Bd4nJUZ0jzTPGiw+RArhl0Y98rRN0C9DNQzjjh9miY+n1e7HTzPk6hrMKRtmVuaZ5A6vq6BP+6aJQadfY01uTULUkcGWZ+Rr5L4BcxtJ5A9YIJ4mbdgcKbCg5gRuyCI2OD+o2fb8wsQIklp0RoXa0tjPhRUcWkb7sGvIF/9rBGGDsVuTzTKG7L4WFFa3ZKHCWnieK4nGzPN9hOq93sgA18r1CE4tdMsfHVx0WFrBIbhaZ7sbISc0qVe78o+ChV3/sXVjcnOR9rzkgaGFWf3PPp9qhN6EZ3O3VxbaUOsL2KMQHGB9+5mlFkmJ3VsR5QMBJ4p73hskfthSydGRlyWKqm8401zd+2ZTRQwk1As33eI7xjJLsAv5GHQ2Yakh2yCNVoR4TsEP4BH7dU64w+ioZS2VitEahTbowAm2+c8r4qJuqWxr6eI8r/+7E5C4/WNK3uSjkMQ2LKsCEydyLK2vj+Y2Lt4l7CRYKoGs5g404v8S6ZYD0uro7eepK4nd/zKMphGFH7t1JqqQ4oBl4yJPZrsFu95hMXPyZ02iAXnZbKVvc2mQaouxIjkQAAPQRs1kd3EaQMkthPyO5n8z/2gv6rDcb0/V+GOD5T0w95Yy16lUnDPzOhM98WNmoTeuMgnS1cX/yQrnCgh1ESq57rE2HuBVYkUJZTMMrttqpoMLDrEb1EedFdcCvSsbN2/4WZz8bxa40FgYCJINyvPEvyGVVTdvZeug7H2lAzSWBX2rvgd1CSNf2w1AZYmB/3/cPJu4yqtYIpF94uhrTuWkdSb7vl7PuEwR51nGB/ap4tNbgr1Q
 7jgdYJn6
 r+Ld7OOiGfXRcrbylstTWx6cJBlnACMDKpkHF5OW4qocuZ+RzCrOLofqC/4Vju+ZXahfRizaeHqBjiHrAn155QGiSasCJLKemAHgWft36vylx7p+vewxIXtgCCHMpn6ECamYB3+O5IlKNNI4Cp0ncJ1ZYrmZlEgsMrjNwRk1WMQhIWA8DkjRAA6WEd+7lc/meX0FMchFFJhPdIAhynsYudL4R1Uu3yaPmFV3nKRNnwRWl94dR8SuUaObIeBPdi6Tbzrk2Ka5qo3/jQyHPDMtnw18iZtOtnWtBP6y+ovnTGoIqvANNpWf/HEg0ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 10, 2026, at 15:44, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/10/26 08:05, Muchun Song wrote:
>>=20
>>=20
>>> On Apr 10, 2026, at 11:07, Muchun Song <muchun.song@linux.dev> =
wrote:
>>>=20
>>>=20
>>>=20
>>>>=20
>>>> Hi,
>>>>=20
>>>>=20
>>>> memblock always allocates in order, so if there are no other =
memblock
>>>> allocations between the calls to memmap_alloc(), all these =
allocations will
>>>> be together and they all will be coalesced to a single region in
>>>> memblock.reserved.
>>>>=20
>>>>=20
>>>> ...
>>>>=20
>>>>=20
>>>> memmap_alloc() will be slower than sparse_buffer_alloc(), =
allocating from
>>>> memblock is more involved that sparse_buffer_alloc(), but without
>>>> measurements it's hard to tell how much it'll affect overall =
sparse_init().
>>>=20
>>> I ran a test on a 256GB VM, and the results are as follows:
>>>=20
>>> With patch:    741,292 ns
>>> Without patch: 199,555 ns
>>>=20
>>> The performance is approximately 3.7x slower with the patch applied.
>>=20
>> I also tested 512GB of data, and the results were roughly twice that
>> of 256GB, so for a 1TB machine, the memory allocation time is only a
>> few milliseconds. It seems we don=E2=80=99t need to worry about the =
3.7x
>> performance drop.
>=20
> Good. Can you incorporate all that into the patch description?
>=20

Yes. No problem.

> --=20
> Cheers,
>=20
> David


