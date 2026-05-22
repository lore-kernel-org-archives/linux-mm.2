Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4635DCD5BAC
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 09:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2AA6B0099; Fri, 22 May 2026 05:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A74656B009B; Fri, 22 May 2026 05:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989AE6B009D; Fri, 22 May 2026 05:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89FE06B0099
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:07:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 551E514081F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:07:21 +0000 (UTC)
X-FDA: 84794477082.08.7C6C8DE
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id A155940005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:07:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kVMY/Otz";
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779440839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5nUM04+Oakpa9Cj4TWrMW9fEn3Kk+NVFqR1pcLe6/gg=;
	b=F1MR1260jWBe9Yi8RV+ovWbHhb+A6WeGgRE3leYyNkrnDgqe7VaneJjQ7w9HF3JzBThSEC
	vq+WUnEW9PVc1yanRZ1V5lpWwGsO5O5MQWcf+0cQOksL3PPJfE3qyCYTUJ3yXqhdGPL6S7
	CP5jff4hYvCdJ7WfRSstqGpiZd8Md/w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kVMY/Otz";
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779440839; a=rsa-sha256;
	cv=none;
	b=aR4JUQS2ut5pvzTVVPjwKwPXtLGdcB65ZqLFYc5w34YtMxz82Hu/kC5Jfoi1nA2bHwsZ+H
	qya4Ceelk36eLzu7kvX4LC0Po+T+GZG/SCtOM9uftx88NLx/kc8rraWt8rITLYZ7Uj1RvE
	QifVh54zVBJo9cKxxwAVY9NskdAkM78=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779440837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5nUM04+Oakpa9Cj4TWrMW9fEn3Kk+NVFqR1pcLe6/gg=;
	b=kVMY/OtzdFq6iqxzCMMwayWxsSWMY+CExELm4bPfWtHv+NUhZ7ovfrKPHfkEWe6tD9xP0W
	ouUAkCmWjJ7g8pcptkLRtK535VvcrcUzKHC7wTqTQB34PQjQqnqc5GwHZi5c0QCKRmS67B
	47wgP7fANk1PZvbaoaWBdmZdVMDaGiU=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 19/69] mm/mm_init: Make __init_page_from_nid() static
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <177944019670.3663073.4082076266566320906.b4-review@b4>
Date: Fri, 22 May 2026 17:06:28 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Ackerley Tng <ackerleytng@google.com>,
 Frank van der Linden <fvdl@google.com>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A8583ED6-4455-4085-BB0F-D9D903491C9A@linux.dev>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-20-songmuchun@bytedance.com>
 <177944019670.3663073.4082076266566320906.b4-review@b4>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1rs84yqki6o9rgrzzbf5f1aosxwiqcac
X-Rspamd-Queue-Id: A155940005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779440839-990703
X-HE-Meta: U2FsdGVkX18VvhbcgyJkMruBW3pg9O3XRjQwGE+GTbiorMPasDTkPoDIEhu0jZX/pRLzj+/V12h7bOqPX2CUUo5KscIqHxrveiNXMl5s+FVzep+xEBI2lqiOSEOu8NKXMnORCmutlTNyDKoaz5I8fotDDVfrN9Q0XAva5PqVTAUnKxlbaH3MY1J+NpiT1Z+hzAHcSpDGjKDwDa1VHcnrANfWS9uwtNkw5o6nemulhXTh4+8CCNnxCGVjbmHs1DKUHSu7dSzSzbeQxiztGWNtcYokfeSrWBY01Tg3wtnQ7uetseVdMtnHiiMQfceZo5j8DrKS7e1XIcnidmT3veTUlOHqxakRyDEvWQKV0sHgIrUa+6hPSfoCXbYuEpWHXQDQNS3/OCUUVketijHfWK0bLaoCubBkpLtKouG3+8+GAv8Dh0VJ1h8iJhOWUdfQXXz5/P1Lfij7QF5LWX+GqHgeXluL8eFJeMe5FTRBwqwkIeVx5Qt7y60AaUAnXqqmQKlR3fZbG+bGbcS4NY/3QLtwRYM2Bv6pZcKjy4DqYJ9o+DtZ6yfkk2vdYKYFKKoMKpvdX3JMGB4kdiIiTZfMLVYdt4CZ6QHPDU9Ml7AXFpEgPefNKigqqhBnCVTXhZ3LKFLoS+W+O61iQW8oe+iNZkeCYqhD2xdjBVsGXVSeQz2P/uKyUxG5nsKGgxH6YrFtItjKhOMCeKB1biC6ZQ8pv+ezGg9zOigDsWS2UlOBzbREZIyqsTyW4dsVU+TKtJ38gO6VcJ4SdYbK9YDxcaf2jMDa2Shv4h8HBj51Hcp9IgUcxdOh5hFLF/F855v2EppFY1s1EYATPSnOwTSsVJWiDbIY0q1QAXY3VRZhFuyXidx/y2sj7lDI8XlEqESZ5DCYzcg/kU0P9dR86u9bqFOEhinyMsxnIm4DQTQToc8DzSVilD6N+We8zoYdZDAt9rI+C+u1O9pdjrx08zz44uOxIE6
 8h6i2gWA
 YDehBCv9+tqzGx2LOXZqgp7ywCPCoGIw7h424UzZxaE7Uf2KqOxhdWXAi6RO0nR0vBuT4swtiYmrJSK0PpA6+tbe3tHToKv9FIuVb1hfzFSgx85eGJ6Z0fu2wE8+/OikQDE6BI0xLD813Gn9JXGuJpvYfowsI1ezmuOr+A5UxDDXs58w3o+UJMjsK+xSItg12AbZoFA6QjgT+jmSH5Mh0tGY0PsgmIpK7TqayLQF16rew790WNM+Q7iGtPdesrlneYvh/XdspWx/+YiUwjvOFZMnDO2arye3CvutrxUIZj87git+0V+QqdbqmiEEkH0+zkghakNleJaYGkEo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 22, 2026, at 16:56, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Wed, 13 May 2026 21:04:47 +0800, Muchun Song =
<songmuchun@bytedance.com> wrote:
>> __init_page_from_nid() no longer has external users and is only used
>> locally in mm/mm_init.c under CONFIG_DEFERRED_STRUCT_PAGE_INIT.
>>=20
>> Make it static and keep it inside that block.
>=20
> Can we just fold it into its sole caller init_deferred_page() please?

Yes. I can do that next version.

Thanks
Muchun

>=20
> --=20
> Sincerely yours,
> Mike.
>=20


