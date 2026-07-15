Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8110EC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C42E6B00E3; Wed, 15 Jul 2026 09:48:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79C3E6B00E5; Wed, 15 Jul 2026 09:48:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4B66B00E6; Wed, 15 Jul 2026 09:48:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 401C36B00E3
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:48:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 896188017D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:48:41 +0000 (UTC)
X-FDA: 84991141242.17.69559C5
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6331F180012
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:48:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M48vlwPc;
	spf=pass (imf24.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784123320;
	b=pS/w+66EDbAOJObh0KhYroqJ7o/hFSMQfI3RyIFHTLkH1KOOrijv/CRLqgATCEJiLTmE7D
	HHuZrHpyWuPlRXSr7xYzC3tXpXc0Xlw0c+YZFCAiycRnNT2aDEBMNliCfdYXdNFiE+JKm+
	OR1IViKonigLOchj5XjpBB6IOeVvShs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M48vlwPc;
	spf=pass (imf24.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784123320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UaowcxsEzNicEwV4Y0Sxvqio5A4MwiyG/h+HfRwv7JI=;
	b=qWuh1DRZdxtEMwaMkkBn/lUUgxwmXxa+f+RaXyPiF0YWbWpU5cBI+JgbKMkOAe9Nwv1NcD
	gvmAgLIZbnZ8+Jrb37asjAY/hVqNB+fmO+d49FKFJQ/EKApkmPBQupuQfkH9xIYIU1OxO9
	5N9ecJ/jqjfis1FxXyAxc6hFq8hpCJ0=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784123313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UaowcxsEzNicEwV4Y0Sxvqio5A4MwiyG/h+HfRwv7JI=;
	b=M48vlwPcCewdYQqUp+SIFZY+lTwvLyqR4yw4SgCaQgqpM0KAPEI4pmr368jIllLjcp8cWc
	FbkD4ifKhLMxmbkn12KXP4zaUlfxWxEnUs73zv+zQ3dm37ciQAbmurSo/270yR1ZHTzoFN
	Yh31eGDAT+hYMUb0xQaVD0ZPffYk3bQ=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 Jul 2026 13:48:28 +0000
Message-Id: <DJZ6XH7C3377.1D6EIFUEK2656@linux.dev>
Subject: Re: [PATCH v3 4/4] mm/page_alloc: remove a couple of VM_BUG_ON()st
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>,
 "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>, "Clark Williams"
 <clrkwllms@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Waiman
 Long" <longman@redhat.com>, "Ridong Chen" <ridong.chen@linux.dev>, "Tejun
 Heo" <tj@kernel.org>, =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <cgroups@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
 <20260715-spin-trylock-followup-v3-4-fc4d246f705d@google.com>
 <ed4572f4-0074-45c5-993d-7b6533eddc31@kernel.org>
In-Reply-To: <ed4572f4-0074-45c5-993d-7b6533eddc31@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6331F180012
X-Stat-Signature: rw9y9eb6xfkwhd96rimjs6ogb351ndca
X-HE-Tag: 1784123317-180094
X-HE-Meta: U2FsdGVkX18jzBMl6O7pq4K6fvChTDnt5HytQGyTbCEOjEWzOWz0QrS4KeNSQ6yZOPHL5fcSuj0Jxv5anBhSXXzOuK+LAvYzbSlDyuMp1FgweJw0Qa7BLPS7XMy26/VD9flBOTMCGdC76MSRU8SUy7uqUMHiP2Mx3nvf8Lv5COaLs69Ae/bNt4EGYeqx32JoIEIVdeg7BtHipxEvxer5MuHH0FYymtzD2nRJyT/NCysCI7+syLu+54vEv5MFSwZCWO4icoun3nAlnTy6P3doltQDZax3nYAud0u/gheyh96oVJ3B6VNwqdS097G3795TP+xF0X5hCAlMrFmeAeZ5PKurQctSmSNnQRno7EIkB0d0bPHVbBOBYgTvOFWinMpTdzQMZXAIfz2rvP5Py9vlRavzjT8iDuMnxvJ8bRkZdtCYy7hJ6ArsJYwefJQgWOUfcvuuc7DCRguOnWmnBZdEKIKiOSKKnwMtc8gYOSAh0RG6rnWJ25DbZl6YubA7/baN0GOptT1nYXcQUQ316AfnbIPNX3CRyItUtX0MKZCFIWAZcf28O0FWZpXXnhXtxI9DjmD3f2s6HL6dDKKLSaCY7kkvVV82MjoD/6kQ2No3PnIj9LyUHfW+0xCH3OEYoHqdue0YLvuT7PXERhOpiMlZDb3FC43YGOau6+n9ZSQf7hkAUfO3gMUhZx+lk6dnH4RmXE+9RfaeA0Gk1zd4VHgcZ5wXE3yYcZrskgttgjZKWsBip+FhrcYvMEWx70i6gJKeR6Jgojj9v/f3Q1dIDy2bggbC2U8yCwHztehJtmRqQxkc0GfXJw/fptod9FN8QLtFM34U6AVjnChCdf9TO1146zz9nswxqvCfNGNHKh0UqZpoEsil5VCqzcZGn3XoDkMi+ojGudtDioDjr7PWo310iWsPZHc+T7QrH9SZHx5Qbzs80fyB5Gq1fdVpzvy5Bf39ZvJ+Zn0lBAp/OzT1iln
 yZWmeUUe
 95RjtPDflcY+nKgeDjx3ekRvRltSHPbrZri1WsmkKafvUK8biFke1X3OsaYoic5jSbJEaZ0kUEAs4uUYhSr5cAEMKXfrgI9MYxxCn4JcNIAfCqXEmrOfuuj7esreV/QumFcaIyZtmG4ZoXIRg0URB36TMB9ZeCHLdpoAvto0iU7Tn4tLJzWgmHcU4YPkKxeNw9ZwYmcOzaqKXsmBrNY0HjHwR2cN/Thz6sfGZp/9tclARPcDAsfoZWYj3fEu5BTWRc2fMtG0KkGwlzAyEoTlWdb6dOde4ZKK6AcsaPT4Gw3lofkoyoqlzjQrv5o+uHGoFcBw3q3YaEMvWYeinY3Yl2f2DoVbDFvYVzTJ92ojHlhdh0QU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 15, 2026 at 1:25 PM UTC, Vlastimil Babka (SUSE) wrote:
> Subject has stray 't' at the end?

Thanks - will fix if we do a v3 (otherwise Andrew, please can you amend
when you apply it?)

> On 7/15/26 13:03, Brendan Jackman wrote:
>> VM_BUG_ON() is out of favour and on the way to removal, since I recently
>> touched alloc_pages_node_noprof() I am removing that invocation, and
>> also removing the __folio_alloc_node_noprof() one for consistency. If
>> this precondition is violated, the system will soon crash anyway.
>>=20
>> Suggested-by: Zi Yan <ziy@nvidia.com>
>> Link: https://lore.kernel.org/all/7F866265-3F2E-4765-B9D4-9AB898A9C4AC@n=
vidia.com/
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>
>> ---
>>  include/linux/gfp.h | 1 -
>>  mm/page_alloc.c     | 1 -
>>  2 files changed, 2 deletions(-)
>>=20
>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>> index 4d57e9c0bf204..872bc53f32ec8 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -255,7 +255,6 @@ static inline void warn_if_node_offline(int this_nod=
e, gfp_t gfp_mask)
>>  static inline
>>  struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, =
int nid)
>>  {
>> -	VM_BUG_ON(nid < 0 || nid >=3D MAX_NUMNODES);
>>  	warn_if_node_offline(nid, gfp);
>> =20
>>  	return __folio_alloc_noprof(gfp, order, nid, NULL);
>
> Well if you want more cleanups, I can see in iommu_alloc_pages_node_sz():
>
>
>         /*
>          * __folio_alloc_node() does not handle NUMA_NO_NODE like
>          * alloc_pages_node() did.
>          */
>         if (nid =3D=3D NUMA_NO_NODE)
>                 nid =3D numa_mem_id();
>
>         folio =3D __folio_alloc_node(gfp | __GFP_ZERO, order, nid);
>
> Should we introduce folio_alloc_node() and make __folio_alloc_node()
> mm-internal, for consistency?

Ha, I literally just wrote that patch. I'm planning to do it as yet
another series as there's a little dance needed to get it all into
shape. But, also happy to just expand this one if you prefer.

Then I'm gonna add alloc_flags to the __ variant so filemap.c can set
ALLOC_UNMAPPED for AS_NO_DIRECT_MAP.

