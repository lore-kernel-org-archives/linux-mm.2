Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7078C606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 02:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CVShjB8q
Received: by kanga.kvack.org (Postfix)
	id 7DA8A6B0B57; Wed, 25 Nov 2026 21:05:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1D16B0B59; Wed, 25 Nov 2026 21:05:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C86E6B0B5A; Wed, 25 Nov 2026 21:05:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D9CC6B0B57
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:05:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B715B1C498F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:05:48 +0000 (UTC)
X-FDA: 85475629176.06.FC9083D
Received: from mta0.migadu.com (out-49.mta0.migadu.com [91.218.175.49])
	by imf23.hostedemail.com (Postfix) with ESMTP id A8550140009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:05:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CVShjB8q;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.49 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795658747;
	b=JW+nKNIOMprScK70+Br30AzBpNUc8XPPzQu/O8jKbPNk+S5KaGNxkxNebKHejy+ML/hr5L
	DvQTDTkD/21vlvszlL3AEMwB/ta9jv9xapQGnlZVK92S+j7np/notySuNDKZUPiNuses+d
	4kwcQBpkUdx0dho9aX18OoFX+DUdv8k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795658747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WtwI+c9ObEOaIfdXp9STes6sTUCSWn6KexSqCuHMD30=;
	b=gJcYJ5qh5abf3esqdiKxHenDMEfmIgYSzKCThjRhnFQZjkRfsOQJylty3s5Tnr0Z6c8cuQ
	HPHuyJv8njuJ2ORwqi6K7tfgQk16d3ibGdIUI/KLOHHhkt9O4m2eX7q4rWpLmI4p36tLHk
	8IkCwJunqjgB+ocy1zlbrw9fDwEJnxQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CVShjB8q;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.49 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WtwI+c9ObEOaIfdXp9STes6sTUCSWn6KexSqCuHMD30=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795658745; v=1; x=1796263545;
 b=CVShjB8qQ7qAzh4mixJMxw40VAJKpj/4y1j0cDUIt5JjbLW+kd+JJpU2nVTYjJHjX733+0ip
 3kK9o+dOF/dvt+y9VU6UGV2PyBPNTgNBnCPqRVdtLtxnXM6/zgazAZfnIO3VzAMyFVJ5wB5Bx7s
 WTNj1msmqmOkk8SfzKfwyU/Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bcad4ddb13afde49;
	Thu, 26 Nov 2026 02:05:24 +0000
X-Mizu-Trace-ID: bcad4ddb13afde49
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 03/21] mm/hugetlb: always mark new page cache folios
 migratable
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-3-db27fd2f71a8@kernel.org>
Date: Thu, 26 Nov 2026 10:04:25 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jinmeng Zhou <jinmengzhou22@gmail.com>,
 Hongfu Li <lihongfu@kylinos.cn>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Dave Airlie <airlied@redhat.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Gerd Hoffmann <kraxel@redhat.com>,
 Mike Rapoport <rppt@kernel.org>,
 Mel Gorman <mel@csn.ul.ie>,
 Dave McCracken <dave.mccracken@oracle.com>,
 Andy Whitcroft <apw@shadowen.org>,
 Adam Litke <agl@us.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>,
 Lance Yang <lance.yang@linux.dev>,
 James Houghton <jthoughton@google.com>,
 Yang Shi <shy828301@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>,
 Gregory Price <gourry@gourry.net>,
 Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Byungchul Park <byungchul@sk.com>,
 Alistair Popple <apopple@nvidia.com>,
 Wanpeng Li <liwanp@linux.vnet.ibm.com>,
 Andi Kleen <ak@linux.intel.com>,
 Kenneth W Chen <kenneth.w.chen@intel.com>,
 Hugh Dickins <hugh@veritas.com>,
 Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>,
 Joern Engel <joern@logfs.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Michal Hocko <mhocko@suse.cz>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
 "Kirill A. Shutemov" <kirill@shutemov.name>,
 Sasha Levin <sasha.levin@oracle.com>,
 Guillaume Morin <guillaume@morinfr.org>,
 Wanpeng Li <liwp.linux@gmail.com>,
 linux-mm@kvack.org,
 Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@osdl.org>,
 linux-doc@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C615E9EC-BE52-4F33-86D4-4FE7F911EEAC@linux.dev>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
 <20261125-hugetlb_fixes_2-v1-3-db27fd2f71a8@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User:
X-Stat-Signature: 1krc6gqs4kf6j6pxy15b49x1k3tg6kh6
X-Rspamd-Queue-Id: A8550140009
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795658746-726587
X-HE-Meta: U2FsdGVkX1+U/gFvDCjO0TGXSnZ6zlcJknJDAHnMuDBRJpRapZfE0xe8RyRy1boOlgRaq+UUD2fAkyE6YDO2fdBCW5jM9LfEXzStKzsVowgImk6E2LnMcQnoddeSd3WuprsXu8LYANJDvywBdZpvvsRAj1uNRHhqzbr97X2O0JfDmkPXa8qvocEzRUPdqDisV3olyzgNBrPRpPtBVPJR/XBieQfdpZi0z7IA+pqjKs7n7QwpE6m8PgPSmhxEprN3xcTsyOk4xOhAC6mduq6eTLL6nXKtLQhRapywid/xe63bBPzOxB5gYKPYJYOgyt8cvuemQjh3IQfhVaG2URCnqTfI6amJHd2s9WZXeYb9lSGyYRE8YPG/qHVcJm6lygPJOG9EcVe+OLZsLTAhmEoMPPicnGsFYGIDCFpnRlXnCwRK6gJpJyfk2AeJSSXWbBiR8/KXSIQEm01yi4wLcV0nEopxK+68mAKoiC6NU+EZL2rf/Lh080poMbEgJAh+7bnCrAjrQ0KSyJb37w1S2GtvAltxfeEv+42Tc4yKT8epypbaBKnkXSPcwOUiR6Uw2KZ/HkDg2mA3eMTtmln/NIM2CYupnMZS8UqZ6+H/tv9ITlUL3aIgWlL9Q8BLnK8RCe7iqSXjAhoBgKMKJAiYNRy6hza7382pq70yZ5Jm/bNkFJjAr6iELdBz4UIdeiBGJuYJhp3cHvbK6SukUCcX0hqzFTCEyiBmLOmkoe7+wJI07xQq8J1mmUAmxHhh1OCnAl+tB4yG5zSY8Bo3o0rYn3COqFLlayQU7PjHz+KfwywENOrpduNA0By5KzUyeeM6Jr96NM6hXTGt1FPIJhKuiQy1ituZf9fUFEUt8+Ognhxpmb7v2LVF0sgFatD9HVccgbl4dYjdQfzJX8jjmh8nNoITTSDSuhMUdbaXPTFz8W2laVelwTwof4CDZjEJXbcqRhJIqq8bxMyV8A8TIhm8S2y
 o2742UKd
 eo8Qa1hOL+/x0J/OHokdxckw4sx97cSqBP+BFao1iaK3wc8az5yec6Zt51X/dAQH83A8aGgwabf3IEVKfQvx4e03Ww4QrzuR5nq441kDtWuqF1GnyAKueQgvcBARFieX0zzlTOkZ+hbXDAwg6M0FZfCaHU3hilja5f7gArIH29dNfnIOgdfNP0FEW9L/xP330/n5D8BXCXxSprGOKpMMf7wkPiSsWcpt4t6EaHDMsiR8VzPN4K7cEZikRQ81RADpxFWbD6qVJNeq8G8aIJ0O+eZbrETp76zahEJJU1Hw99OLS/NjP2Z+jaLTWH6YrFaIaZVMIKUUiBJizmXwipre3DehFZO36471YfeygXXelGg/d4jsaHCDzkWvlDEhg3TSa6JkujLpGZHtUz5EYqiYVX2d6p0IMFT8+PaQdyHwvqSQRs3mi/MmRDtLqsSjlfqBP8FFuRFWVHuASQOHf5ARI9mQ8cRb2RJEbDqc/0hlZ7suq5nEzSujohIscabU2V22t5AL6+j+ZM3MkwOJ61irtY4u33FDHp0xVm04eLGznPCE6tZPECADhG19KjpW8ykwW969KnxLNAyJ+o8BECA8wzWDIydJqHnG0IpKTSiB3IObDFnc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 26, 2026, at 06:33, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> hugetlb_no_page() and hugetlb_mfill_atomic_pte() only set
> hugetlb_migratable for a new folio once they installed the PTE.
>=20
> If they back out after adding the new folio to the page cache, for
> example because the PTE changed or is no longer empty, the folio will
> stay in the page cache without the migratable flag set.
>=20
> Later faults will find it as an existing folio and never reset the =
flag.
> Such a folio can never be isolated for migration, which breaks memory
> offlining, alloc_contig_range(), longterm pinning and memory failure
> handling.
>=20
> Worse, if the folio is not longterm pinnable, because it resides in
> ZONE_MOVABLE or CMA, memfd_pin_folios() and the longterm GUP path =
retry
> forever on -EAGAIN. memfd_pin_folios() cannot even be killed, which =
will
> be fixed independently.
>=20
> Let's fix it by setting hugetlb folios migratable whenever (1) a new
> anon folio gets mapped; or (2) a new folio was added to the page =
cache,
> like hugetlbfs_fallocate() already does.
>=20
> This has low urgency.
>=20
> Fixes: cb6acd01e2e4 ("hugetlbfs: fix races and page leaks during =
migration")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>



