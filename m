Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA65606A327
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 08:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wa8zah/B
Received: by kanga.kvack.org (Postfix)
	id 4AF846B00EF; Sun, 15 Nov 2026 03:56:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4875E6B05B0; Sun, 15 Nov 2026 03:56:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39DC56B05B1; Sun, 15 Nov 2026 03:56:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 122326B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 03:56:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95DD5A8201
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 08:56:39 +0000 (UTC)
X-FDA: 85436747718.08.10376B5
Received: from mta0.migadu.com (out-117.mta0.migadu.com [91.218.175.117])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6F0081A0002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 08:56:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wa8zah/B";
	spf=pass (imf19.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.117 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794732997;
	b=6aTM2QhQUcy2R3hh9VLtmXlGvVl+biJIxlckahCT9zoxdRhHMH1Dv3ZXyUPSeNpJGzVdpV
	G1faKWN1iTaHMMfirj0cbc/ocxpRq1Cgv9djs1ODwbg9J7m+v9bFEuyUDrbvMsN8Oxjdsm
	MfeYBzkuNJjc0KQ+vvVFRFx2POLo4+I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wa8zah/B";
	spf=pass (imf19.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.117 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794732997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EIEaJi7O1+E/vAyp7gWUtcsPh4fKYZk8jULGdKld6LY=;
	b=nyFXTC16P2gKMbMgD3fZjdoWtif9iblQY9aHBOdTGaEj6uQFjf/Ab1Br+JrDLFim3IHglR
	aH/udcKeyf6Pmnulubf5CjvWRbkanVIAlPLlJMVRefZ6plCzddIWET2Q6XVnY+4RTx24i3
	9kuVLk04rhaDVySxVqRzuLGa+6BPH7U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=21+fkMMqv9ioo8p23KKS2p4sNO5hkMmWorH5aoezr/Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794732996; v=1; x=1795337796;
 b=wa8zah/BvLG8PwnznUaZxBsB6POh0xzqGrQVJUxEEZQFG0J5CgoaFppz8s0epEVzYm4m3CI7
 wVsc0XBQ2p++BTMG+lMNR+KriQlkAFiVFIqXW7nwRkqgLTunzi3+eHMzMaWhbQbbXTVLzPw908k
 MNT1pzo1lLMJuMDLgRvBdC/E=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 55d94d9b38c6f810;
	Sun, 15 Nov 2026 08:56:35 +0000
X-Mizu-Trace-ID: 55d94d9b38c6f810
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 2/3] mm/page_ext: support early allocation for SPARSEMEM
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <90DD8319-BE49-4355-8CFF-36B7AA9BA4EA@linux.dev>
Date: Sun, 15 Nov 2026 16:56:08 +0800
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
Message-Id: <76423A5A-0658-44B1-912F-EA3AFE54FE77@linux.dev>
References: <20261114104150.58424-1-songmuchun@bytedance.com>
 <20261114104150.58424-3-songmuchun@bytedance.com>
 <20261114222344.e65dbc73bf2c9276@chrisdown.name>
 <90DD8319-BE49-4355-8CFF-36B7AA9BA4EA@linux.dev>
To: Chris Down <chris@chrisdown.name>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: 8sr84n88hpj6btx5g4p9eqjyu5uene8m
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6F0081A0002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794732997-892518
X-HE-Meta: U2FsdGVkX1/V4xCYYeQjHZEWRtldk3s+SbtB5oWUnq9GsEyktLdZJh7uomusfQvHAUIMYe6aln41ZMsLjANXtU9cWwx+xLWgJQ5B7CR2Pf6bnOciKxBHXySxE7RFcG+0Dp1laoOCoSepidYYsl8olUpcndjMuAOOar1eMR16zjIxD0rA5mNiGcC6fb/BI0PDfS/PlgvPdgyu9cj3BGTzCj0HNFLUIJ77QwkjZFpQSE0vwW5bQ//AuFjs6zfqU6G3DejgmLh2IRkBSx/91vTT2DIMf3CIMSfvgaUg1/IYZWcvabqmft2vclQqxuQPo4JeWGcVG0FNUUGEr+4cdahNBZE+rCGUn+n2K8vOW/hArx7dhl/qVBvSIqi4j3QEz52edbQNswmwrq1Hub5A47Fi9Jr5WrkPfRSgXH1X8Z6eIJuozDW28ZuoZyVYz/KjE25a8qvxqDgjaZUabBpIEU1e7mNXaz4bq39y2U59USoew+W8EgT9Ph9QZ8UfIfx5AN8UzMZtFqctFDV5QyacbS1i20N+FaYSpKskKGWXaCHrwEljiM/yRCuw8hCba6RNCau8spZFEt5/rdiUbnyMUCDjX2kl8zr2pKDNAyCWxBjKeKwJiozpb6srGvAjUMQK9+Pco52mzLRed3/csHeIMBLNiuUIbm8tE+oRKo8lkKAbLWhUvNf7zsnljoo4Mi5LKRM7sp3QGjp0kc4QGBIFDzAVKySWZnWGtOPlR9R3+Lo9nO5a22C6lAzz9ad4rhGgeqGlbgl+CDL2RQQuJnb4GjKdIWUsXo94EGqRvTN3xSSDzTgrF1gbvHhrtfebdvIbvHFpYlQNfP5ql19XFCYFyYagdAQZmeepYQ3Q6Bg8pTwIJob1BzLBGf/NCjhMXN+h/utkhrva8uE/jC5OBhd/GXgFAj2aMXew1Nk+hJf+/ejXD/TJJqjspKd0j6HnbYH2ESdi0Gp1jvu0CBRBfH0Lpk9
 OUv+zqKl
 Mfha7s9in5pPBZx65q6B/vSG8tW2fQl4Fo3z65XqjNSEdm+sMcSsoXvG2/ahROUwLP/2T/2VtDIseGEHAsN2VGGNaehC6ThhZ5OkkxdzbL4hes9BHPjRd3XIZ9uE57FbvsCYkoNBH59TLeCKDnZ/hgno+Xg1t1d8gypZtdwfMdAKpJwAWVaJHJCGNAfSEo4JT/pFF/DE7myRaLVil2qWz6yPS2gyPJXuA8x4Y7HN9O79P4oT1TgJtm0eUXVclyqxsbnE0/ouwnovrh9tk5gAI7ttXjS8CXTaC7ZBsmKBzQp+e5wOkLqgbNjCCVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 15, 2026, at 14:44, Muchun Song <muchun.song@linux.dev> wrote:
>=20
>=20
>=20
>> On Nov 15, 2026, at 14:23, Chris Down <chris@chrisdown.name> wrote:
>>=20
>> Hi Muchun,
>=20
> Hi,
>=20
>>=20
>> This looks good to me in general, I only have a few small things.
>=20
> Thanks for taking a look.
>=20
>>=20
>> Muchun Song writes:
>>> -	/*
>>> -	 * page_owner must be initialized after buddy is ready, and also =
after
>>> -	 * slab is ready so that stack_depot_init() works properly
>>> -	 */
>>> -	page_ext_init_flatmem_late();
>>=20
>> Not a big deal, but this means that on FLATMEM the init callbacks now =
run
>> after vmalloc_init() rather than straight after kmem_cache_init(). I =
can't
>> see anything that depends on the old place, but FLATMEM isn't what =
the
>> patch is about, so it'd be good to say in the changelog that this =
moves.
>=20
> Sure. The new behavior is aligned with the non-FLATMEM case. It should =
be fine.
>=20
>>=20
>>> +	if (!slab_is_available()) {
>>> +	addr =3D memblock_alloc_try_nid(size, PAGE_SIZE, 0,
>>> +				      MEMBLOCK_ALLOC_ACCESSIBLE, nid);
>>=20
>> Maybe this should pass __pa(MAX_DMA_ADDRESS) as min_addr, like
>> alloc_node_page_ext() does, so that the tables stay out of ZONE_DMA =
when
>> there's room elsewhere?
>=20
> Make sense.
>=20
>>=20
>>> +	page =3D virt_to_page(addr);
>>> +	if (PageReserved(page)) {
>>> +		memmap_boot_pages_add(-nr_pages);
>>> +		kmemleak_free_part_phys(__pa(addr), table_size);
>>> +		free_reserved_area(addr, addr + table_size, -1, =
"page_ext");
>>> +	return;
>>=20
>> free_reserved_area() prints "Freeing page_ext memory" when it's given =
a
>> name, and this runs once for every section, so offlining a few =
gigabytes
>> would put dozens of those in the log. I think it should pass NULL =
instead.
>=20
> Good point. I'll pass NULL in v2.
>=20
>>=20
>> Did you manage to get this branch to run, by the way? KMSAN is the =
only
>=20
> No. I only verified that the KMSCN kernel boots successfully.
>=20
>> user of need_early, and from a quick check offlining a memory block =
on a
>> KMSAN kernel fails with EBUSY, presumably because the metadata pages =
can't
>> be migrated, so I couldn't exercise it myself.
>=20
> I'll exercise this code on this path and report back.

I exercised this branch with a non-KMSAN kernel by temporarily setting
page_owner_ops.need_early =3D true. Offlining a boot memory block =
succeeded,
nr_memmap_boot_pages decreased by 576 pages, and the kernel logged:

    Freeing page_ext memory: 2304K

A subsequent kmemleak scan completed without reports or kernel warnings.

I could not exercise the branch with KMSAN enabled. During the
memblock-to-buddy handoff, kmsan_memblock_free_pages() retains the first
two of every three same-order blocks as shadow and origin backing, and
only releases the third block to the buddy allocator. The retained =
metadata
pages are not migratable. On this x86 setup, every ordinary boot memory
block therefore contains KMSAN metadata pages, and memory offlining =
fails
with -EBUSY before the MEM_OFFLINE notification is sent. Consequently,
page_ext_callback() never reaches this branch.

Thanks,
Muchun

>=20
>>=20
>> Once the changelog and the log message are fixed, please feel free to =
add:
>>=20
>> Reviewed-by: Chris Down <chris@chrisdown.name>
>=20
> Thanks for your review.
>=20
> Muchun
>=20
>>=20
>> Thanks!
>>=20
>> Chris



