Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80873606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 06:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pi/7Vgk/
Received: by kanga.kvack.org (Postfix)
	id 840D06B05BD; Sun, 15 Nov 2026 01:45:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F1966B05BE; Sun, 15 Nov 2026 01:45:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707786B05BF; Sun, 15 Nov 2026 01:45:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6EA6B05BD
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:45:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D1FE91C3D48
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:45:21 +0000 (UTC)
X-FDA: 85436416842.01.F414505
Received: from mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id B828FC0004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:45:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pi/7Vgk/";
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794725120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hy9lM7OviU25g29M4jtdgfdBG7/TUKoGJ32oQNZu2Rk=;
	b=Oa5kJgmWmRtw4519nUBav0DnD9fkOU69tzodtr9HX2JKG/Gin/1AdW8DuuATfqbPBPEoiK
	EfJqG+SjZNpkqQ++sBbXFJWaXWB/qDYEaTixroq7/w8pxP+gVm8WJkJrDpm+BVEvb8P9Xz
	ukvsHSLbR2gTBJMDM0JcKEk1XvCZz/c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794725120;
	b=yNGer3gRMCHQyeDJe0zbpRyshzn9M76O67jDrFqeEljbe81XKHu6q14aOVAjSOhNB2hVn4
	EKm7/AdCWl95YXGJPCY/CaxdR5YonkjAZn4eqpYPVj8CaPoJTHSpVtVV/+CaH9pVhJQbRh
	7feKyg/FgTw2pOjcyF8ielbzeDUToIg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pi/7Vgk/";
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5XwkqcHFhPzVcZzlFSKG0JJJqOr0gHJXncGteFyJ/mA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794725118; v=1; x=1795329918;
 b=pi/7Vgk/vReb8RlEMiv3d7thFIcJAVGv1rywzYoz+LpmJdUTWrjcsvBySOGJz0YTLpCSZxyW
 1xF6iADHJjmvvy6H8rYGb+5+1V6imgFGwVuVWkqngD01ZotbUyughQEEOu19omZzq0/bjArPChf
 3m/3Tu9qfjr7ApiL5j6oucv8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 84e8d21794d04bb6;
	Sun, 15 Nov 2026 06:45:15 +0000
X-Mizu-Trace-ID: 84e8d21794d04bb6
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 2/3] mm/page_ext: support early allocation for SPARSEMEM
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261114222344.e65dbc73bf2c9276@chrisdown.name>
Date: Sun, 15 Nov 2026 14:44:45 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>,
 Sang-Heon Jeon <ekffu200098@gmail.com>,
 Mostafa Saleh <smostafa@google.com>,
 Ketan <ketan.kishore@oss.qualcomm.com>,
 Usama Arif <usama.arif@bytedance.com>,
 kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <90DD8319-BE49-4355-8CFF-36B7AA9BA4EA@linux.dev>
References: <20261114104150.58424-1-songmuchun@bytedance.com>
 <20261114104150.58424-3-songmuchun@bytedance.com>
 <20261114222344.e65dbc73bf2c9276@chrisdown.name>
To: Chris Down <chris@chrisdown.name>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 1dzgpehd3xrka419bn6zgzto5pmu7rkq
X-Rspamd-Queue-Id: B828FC0004
X-Rspam-User: 
X-HE-Tag: 1794725119-44143
X-HE-Meta: U2FsdGVkX18VQRhQ0tkd2ZdDs/Hnz4pBORmlZkNxx02cRoYtMXUPErAAFmsQOHnFMMuDPz49Kso8xR13DkrRUBNpx7HWs6XQ4anwnOwgzVZpzRZ5JxJUi5FxQSTSOr8BFZfCHfMNXJXOn8qDSkbpQTQ8iSibVQ+b1BR01IIn3m3MgKW96dWQdtoa4qUYYk8S50//Nix9l8jZPqy/u0WPv7S60VQsg4h9Ruf0uzdKMwfBGI/TcQuVAGY+Rjsw8ZwzrTTK9HQe/4Nphax6zYvsZLCMyF9R+riyMBvTXDoyR1EAAwhJ7VC4eF+O2BHBtfCFSpTFOsleE6qamLfwFMTiBtlVnN2fi7H9sbNJNkXqErTULC0IqJzOhUVp0kEGZKn38Kto74qELxbOCjiY0dgau40CJKSZGnpz5Gg1ZK9BjKCZLufIGOtZz1oGaa4rY3jZsWi9HyTayDaPBYSjR2PXiCqOD9L/MUY6t8K+p4jkHAeuG9BqiD4mVdz9Q8ICClrXBDReqy3Q65YXQfyurIngZff1/ZF9VvCCdXFsAH5z+6/hnrXoR+lfmaCmY+etyKjiLVGeoaQI1/JYdMc9DZnH4lRsJN6pPAuGeJ/dnZk+t0NnzAwKLwQ5b0C/BQjOF08vLa/a67ZfNpFFqaeZVpGvGyyI5FMPLMVdSQx0damPiLLn31x32+eli0UQpfCAiOFbbsH8FnUoxfAuzDPleUIYV1ZHhDnutL5uEsawlLdNp6cr53HMUDEkn5drdY85Oegu9v3pND+l8tJoUs0X/+HM8ghJAsQXwuIZFhf1ukDgbPhZl9AdXXZU8NHVgIJTklA8dhRha02P0ckzgkwEB2V2R9pu62b2JhntF5FzRoMdRozwict7/X2SBfH6eySbt8EI3IltQ+vpm+eUyTFHmlbvum39iJQWDKctQn2m8fbJJSoM9Mpgp5U9gY2oaimoYFKEJnVFgsm+2l5DED19QcS
 FQyvsL++
 7x1Bxoivsjb7s5dR7oYC5VSz6GozWRJUK+o9QX0dR/orP19FP1pJsw0tUF/9Uopy4q+g8S3ls34mA5lco1cW64bKjILu99cuV0FWdGey4pVoXDcy7JS7pZL3l/lS6dK8bgMnIPR7vdO+zlVKbr188H917J3qvPO0xmaC/4/KkWTi3JZknP7GDbPF+HXfh4aGjWiljZZFr88DAnytNhbEzJjJ4v4Ju9CecnDlrEddCZnjndCKLDGKSUPWwhvjEpS9VGEZgCXaxBMP6ea1M5nRunR3Nc8Uw/sC8vaIDXorG2LzotnPgUrYoHzebdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 15, 2026, at 14:23, Chris Down <chris@chrisdown.name> wrote:
>=20
> Hi Muchun,

Hi,

>=20
> This looks good to me in general, I only have a few small things.

Thanks for taking a look.

>=20
> Muchun Song writes:
>> -	/*
>> -	 * page_owner must be initialized after buddy is ready, and also =
after
>> -	 * slab is ready so that stack_depot_init() works properly
>> -	 */
>> -	page_ext_init_flatmem_late();
>=20
> Not a big deal, but this means that on FLATMEM the init callbacks now =
run
> after vmalloc_init() rather than straight after kmem_cache_init(). I =
can't
> see anything that depends on the old place, but FLATMEM isn't what the
> patch is about, so it'd be good to say in the changelog that this =
moves.

Sure. The new behavior is aligned with the non-FLATMEM case. It should =
be fine.

>=20
>> +	if (!slab_is_available()) {
>> +		addr =3D memblock_alloc_try_nid(size, PAGE_SIZE, 0,
>> +					      MEMBLOCK_ALLOC_ACCESSIBLE, =
nid);
>=20
> Maybe this should pass __pa(MAX_DMA_ADDRESS) as min_addr, like
> alloc_node_page_ext() does, so that the tables stay out of ZONE_DMA =
when
> there's room elsewhere?

Make sense.

>=20
>> +	page =3D virt_to_page(addr);
>> +	if (PageReserved(page)) {
>> +		memmap_boot_pages_add(-nr_pages);
>> +		kmemleak_free_part_phys(__pa(addr), table_size);
>> +		free_reserved_area(addr, addr + table_size, -1, =
"page_ext");
>> +		return;
>=20
> free_reserved_area() prints "Freeing page_ext memory" when it's given =
a
> name, and this runs once for every section, so offlining a few =
gigabytes
> would put dozens of those in the log. I think it should pass NULL =
instead.

Good point. I'll pass NULL in v2.

>=20
> Did you manage to get this branch to run, by the way? KMSAN is the =
only

No. I only verified that the KMSCN kernel boots successfully.

> user of need_early, and from a quick check offlining a memory block on =
a
> KMSAN kernel fails with EBUSY, presumably because the metadata pages =
can't
> be migrated, so I couldn't exercise it myself.

I'll exercise this code on this path and report back.

>=20
> Once the changelog and the log message are fixed, please feel free to =
add:
>=20
> Reviewed-by: Chris Down <chris@chrisdown.name>

Thanks for your review.

Muchun

>=20
> Thanks!
>=20
> Chris


