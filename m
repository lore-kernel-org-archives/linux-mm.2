Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE8C10F92EC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 02:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91BEA6B008A; Tue, 31 Mar 2026 22:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C9606B0092; Tue, 31 Mar 2026 22:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DF1A6B0095; Tue, 31 Mar 2026 22:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6CA136B008A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:42:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 018D3140562
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:42:24 +0000 (UTC)
X-FDA: 84608438250.03.0878372
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3946340006
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:42:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AWD8gD2y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775011343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OYzgJhPBELX+5svIaMHyyrG4VC9DWWPsk64e6cKGVmQ=;
	b=3Rf1yCIRAftxM3OYz+X3i3aONSlJrNMUH6Yu0PshTKmZfobtnlptrVuaL0QOa38SKxd9WU
	toS6wXXDspaaEGHNbUaqrMVj2q8Xggc/jL2mFbhYPSDWv2t23GssZ3Ji0DepqZyBHq6RR3
	O/+ZxvjyZernxN+Skr6my42mykGPB+U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775011343; a=rsa-sha256;
	cv=none;
	b=Ffjn6MdumstVjQQJ4MdbBXH8SU93wTfwjeGxGwLiWKSg0LqjE7YLumupYDw2srbC+gXp9I
	nc8JTwaxgMvKokIi5jtgnRM1+fw7Bm5omMRZ+juM2t5HspZw9nD92e013AMHJP/JhJpOxa
	tjE+AAagIPyp4Hjzwjzss9zjabalsK0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AWD8gD2y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775011341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OYzgJhPBELX+5svIaMHyyrG4VC9DWWPsk64e6cKGVmQ=;
	b=AWD8gD2yYWhtLaaaFtHHTzd1ZrylQ42YS7/HwqG4IQZqmc2IQngtGJ4Umql4wmBnVv8uGq
	FoOU9skiW9PmptHxqrkm7Xn6snIs6UVKy+AEph/5JmLJS6wPse+LzmOQINMandy2PiOlwv
	4cRE/oLBStgnXB9LaUJrkHWQ6y1ffDM=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH] mm/sparse: fix preinited section_mem_map clobbering on
 failure path
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <17246161-f314-45da-933a-770231ef2a49@kernel.org>
Date: Wed, 1 Apr 2026 10:41:42 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Frank van der Linden <fvdl@google.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2183487D-0CED-4BEF-84D7-4439F3386584@linux.dev>
References: <20260331113724.2080833-1-songmuchun@bytedance.com>
 <17246161-f314-45da-933a-770231ef2a49@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3946340006
X-Stat-Signature: uahm8b49h33618uss951f9b1byptxk76
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775011343-81382
X-HE-Meta: U2FsdGVkX1/HpBHtpjAhgHME2dAkVgZESpDJzBEErWFMBJ2tN8lDv4iCESARKC3Sr4ztxMP6S8n7FRaG4ioQyfyWCQVjsi7+EmUlNF92L/jMCslkm72FTaQsceZPyqcPYqAKUKQ2rK027mV0GFu7EU3IhvjOxmaroTkQrGX8QA7UkOS0bfUDCqqNqYZ8fTHYAf1MrGmXeC2pEeHVmEShK8bmDT0zLPujFNt1X/Km+yKdhDXZgplfcQLKxAztn1tFcPpsCLGg9/1d9PUjKHwY89n6R2ylzkQ49sDglc44zvXMT78Amh+Hb8f8VmzP8cKPlFPP2EsX2KrYpbPS1Z6kfqX8xQnEeAV4o8ku3B8L4CIARYI5/P5aihyaRDOXRWKMqsk2JVVifU344D6SFh4yVeGf/sLsOk0MlltkhdZQmmLW0H236Y8zghh51nl9tu1+fsrClzrA/u5DcGYbnxxWkoTa5FR6dlDq9d++ibMzxz0ySFuxkH87rOWKx1fJ6Sl2Q65w75+H5r2Al/xGT9rAt9z9nYj2Xkr190vzsHAqCL+H87TRAuJUizoc9Ha3uDjHtizg7nIuohrNdh6ub3hRJDN+LZpxqON1dcDKYVcRCKE87oQSwGGJwygJmyFlOjnjRiqKke9/sJ89cMInmGq7exevqNI7r+I9gKVMamT3FOLTGRv0fRwBXC+9OZN46N6p3C4rsTw1Fqt1ZFzJx2lWkt1CCAYMkokpQEpF6Y24keaBesFmZbW5ocu1/EuATMfBIF+MtfZCwhxBVrwFgLnBgnh9hA7Bcr0kEvGRLVLmAELOVDaIp0oN4GntIKiGiQvz8AEnJy2+8Mlxbms4tZPw/W7da1OgZkU5kpObK7y8f72V5o+UGPgma7AfmHGpqcqyk7vEfh/zb7gwbrL1m18WHPxrZjX9yrBhXI2gzATuddxajhZUDHQJeBcMXLOFz6Kc9Q5n1SIJn4YtI2UnaEl
 VayqAzZZ
 ZSTWw5+BVkrdZtwniwJP2fJHFUIS2Uzd7z1ot8jZKS+f81uQePzxLbdtc2kFSnApAIut8VS7YyXVLxJm3PSZkfzTXvIGm6uvCytvZASuM9sArZFBnpn46+9bcLKdINWUFq9YQxay2p6VrF4ukiEOuAmYEHkLQJBO5CDTKMSN2rbE1pI1coosfQ1LFh/uHY03IMkcj7BKpN2DS7B/tEqGyFunkdzPhCU4EEmmzVNsjzRjj4DmL/LDnkjrcMhtECnyFvvXKmWFkXeDXDQpCYhxhr6VToscqkqCHe0HKRiOp8pXxgQtQyeI7oyX2zGG4LIYuh+EBbyBXP6xACPI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 1, 2026, at 04:42, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 3/31/26 13:37, Muchun Song wrote:
>> sparse_init_nid() is careful to leave alone every section whose =
vmemmap
>> has already been set up by sparse_vmemmap_init_nid_early(); it only
>> clears section_mem_map for the rest:
>>=20
>>        if (!preinited_vmemmap_section(ms))
>>                ms->section_mem_map =3D 0;
>>=20
>> A leftover line after that conditional block
>>=20
>>        ms->section_mem_map =3D 0;
>>=20
>> was supposed to be deleted but was missed in the failure path, =
causing the
>> field to be overwritten for all sections when memory allocation =
fails,
>> effectively destroying the pre-initialization check.
>>=20
>> Drop the stray assignment so that preinited sections retain their
>> already valid state.
>>=20
>> Fixes: d65917c42373 ("mm/sparse: allow for alternate vmemmap section =
init at boot")
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> mm/sparse.c | 1 -
>> 1 file changed, 1 deletion(-)
>>=20
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index c2eb36bfb86d..3a14b733bf71 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -584,7 +584,6 @@ static void __init sparse_init_nid(int nid, =
unsigned long pnum_begin,
>> ms =3D __nr_to_section(pnum);
>> if (!preinited_vmemmap_section(ms))
>> ms->section_mem_map =3D 0;
>> - ms->section_mem_map =3D 0;
>=20
>=20
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.

>=20
> I have some cleanup patches lying around that cleanup that code =
heavily.
> I think I get rid of this questionable "failed to allocate" case =
entirely.

It's truly a coincidence =E2=80=94 I also have a piece of code locally
that does something similar. Since allocation failure would also
affect subsequent startup processes, I simply made it panic when
allocation fails.

    mm: panic on memory allocation failure in sparse_init_nid()

    When vmemmap pages allocation or usemap allocation fails, =
sparse_init_nid()
    currently only marks the corresponding section as non-present. =
However,
    subsequent code like memmap_init() iterating over PFNs does not =
check for
    non-present sections, leading to invalid memory access (additional,
    subsection_map_init() accessing the unallocated usemap as well).

    It is complex to audit and fix all boot-time PFN iterators to handle =
these
    partially initialized sections correctly. Since vmemmap and usemap =
allocation
    failures are extremely rare during early boot, the more appropriate =
approach
    is to expose the problem as early as possible.

    Therefore, use BUG_ON() to panic immediately if allocation fails, =
instead of
    attempting a partial recovery that leads to obscure crashes later.

    Signed-off-by: Muchun Song <songmuchun@bytedance.com>

diff --git a/mm/sparse.c b/mm/sparse.c
index 1b017026925e..bb0b86a4f3ef 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -354,19 +354,14 @@ static void __init sparse_init_nid(int nid, =
unsigned long pnum_begin,
                                   unsigned long map_count)
 {
        unsigned long pnum;
-       struct page *map;
-       struct mem_section *ms;
-
-       if (sparse_usage_init(nid, map_count)) {
-               pr_err("%s: node[%d] usemap allocation failed", =
__func__, nid);
-               goto failed;
-       }

+       BUG_ON(sparse_usage_init(nid, map_count));
        sparse_buffer_init(map_count * section_map_size(), nid);

        sparse_vmemmap_init_nid_early(nid);

        for_each_present_section_nr(pnum_begin, pnum) {
+               struct mem_section *ms;
                unsigned long pfn =3D section_nr_to_pfn(pnum);

                if (pnum >=3D pnum_end)
@@ -374,16 +369,11 @@ static void __init sparse_init_nid(int nid, =
unsigned long pnum_begin,

                ms =3D __nr_to_section(pnum);
                if (!preinited_vmemmap_section(ms)) {
+                       struct page *map;
+
                        map =3D __populate_section_memmap(pfn, =
PAGES_PER_SECTION,
-                                       nid, NULL, NULL);
-                       if (!map) {
-                               pr_err("%s: node[%d] memory map backing =
failed. Some memory will not be available.",
-                                      __func__, nid);
-                               pnum_begin =3D pnum;
-                               sparse_usage_fini();
-                               sparse_buffer_fini();
-                               goto failed;
-                       }
+                                                       nid, NULL, =
NULL);
+                       BUG_ON(!map);
                        =
memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct =
page),
                                                           PAGE_SIZE));
                        sparse_init_early_section(nid, map, pnum, 0);
@@ -391,19 +381,6 @@ static void __init sparse_init_nid(int nid, =
unsigned long pnum_begin,
        }
        sparse_usage_fini();
        sparse_buffer_fini();
-       return;
-failed:
-       /*
-        * We failed to allocate, mark all the following pnums as not =
present,
-        * except the ones already initialized earlier.
-        */
-       for_each_present_section_nr(pnum_begin, pnum) {
-               if (pnum >=3D pnum_end)
-                       break;
-               ms =3D __nr_to_section(pnum);
-               if (!preinited_vmemmap_section(ms))
-                       ms->section_mem_map =3D 0;
-       }
 }

 /*

>=20
> --=20
> Cheers,
>=20
> David



