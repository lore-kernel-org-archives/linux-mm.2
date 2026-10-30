Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C92F6606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 09:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kQe7uBvc
Received: by kanga.kvack.org (Postfix)
	id C129D6B05B1; Fri, 30 Oct 2026 05:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9D7B6B05B4; Fri, 30 Oct 2026 05:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65096B05B5; Fri, 30 Oct 2026 05:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 867566B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:08:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2898440639
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:08:06 +0000 (UTC)
X-FDA: 85378715772.15.763BA94
Received: from mta1.migadu.com (out-143.mta1.migadu.com [95.215.58.143])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2AE89120004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:08:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kQe7uBvc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.143 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793351283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HzETpkZCDXkShONkGAZlIV0dEoNYXp2bUggxSrX6SDs=;
	b=QcO+pJFUHtnIUNTuWJ6or69n9l0lOgOT1tE7gUoyn2ZUDu+tiviDgm6buMcQvHYYhPHO9B
	gFOm5b1CKOr1eyb/uJQBNZUR1lf/IqjSokQNZFzlaUzSH9Li5vF7f5/p4WRrxSe3jquK6I
	5JCOIPjsNWx97pakQ0/AsxZuXk97WFg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kQe7uBvc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.143 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793351283;
	b=0T55ShncbBjOa5HcDYiXgh4hLPdoH7yEayLt88rIn5+OxogPpF12rWmdxKj7YwCMMnoWwK
	7brWHSiLBmmbzjwkE4M+IvYWKdOwNqcjbVpCWRvHg+yzqMorT0N5pv/lC/O1d2+8JN+p1y
	T7IBwOIhhp+j91rmOASsW8YM6t39Nv8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8R0FqJTbDe7nC/J3cP65RdEuTA26QhIX/KSEeF9uB9k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793351281; v=1; x=1793956081;
 b=kQe7uBvcAwP5T/q3++qatgE6OzLD0cJuX7V++mn8AKNLcIDv3JCTDWuQ/Rx7ugaelAYlwcDm
 WqPxQMIGFXmswK/9hObfCucRXDQ1iqI7qTnjEOSeAM2wpjfsvuu/DatYeiPYnObf+DCHFRKBl9B
 d2N8ibJJGE/lKpnqoKuz2N1w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id b2e1111847a6cf4a;
	Fri, 30 Oct 2026 09:08:01 +0000
X-Mizu-Trace-ID: b2e1111847a6cf4a
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 04/15] mm/hugetlb: account temporary folios separately
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261028-fixes_hugetlb-v1-4-a0a033db180f@kernel.org>
Date: Fri, 30 Oct 2026 17:07:39 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mel Gorman <mgorman@suse.de>,
 Andy Whitcroft <apw@canonical.com>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dave Airlie <airlied@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Peter Xu <peterx@redhat.com>,
 Breno Leitao <leitao@debian.org>,
 Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Arnd Bergmann <arnd@arndb.de>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Gerd Hoffmann <kraxel@redhat.com>,
 linux-doc@vger.kernel.org,
 linux-arch@vger.kernel.org,
 linux-s390@vger.kernel.org,
 stable@kernel.org,
 Josef Bacik <josef@toxicpanda.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BCB80A53-031D-4479-8D2B-0291ACF92F70@linux.dev>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-4-a0a033db180f@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 2AE89120004
X-Rspam-User: 
X-Stat-Signature: q49em8dwgjgdj31dwxi6acgbhx5w8fnp
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793351282-831158
X-HE-Meta: U2FsdGVkX18xLioCL4XiCYrk/a5UCF0W3RFSOxYOMn57w025ckVgOJQe3xuMb+TuXGW4GKX5fyI7WJz+Uhyc02Yt+3x6hJ/apBDGP7HobvaYFuH2S0WYHhZpCu3LFVvP7uNiSaBl2HZn3tWn0mi4+lK1fKR9XwGRjp2+uAPypPbHes8C6pYej6EhMK/jUSJdjjzZgZaQijw8tca9gSF4wRqCxoo62+r0FAZLSAIeuB1ToKDy/dmMFvKSYV9f91akGT+oZAMLsLZvvMBAzcQs3TuYrEXmvoX1gGHgrlCLSSqCXJ4sjUjgZoWkgvSgOsdV4RF7aZUMiWV3WEb6z2lGJz7kUKdszUVyakSQOVKitjr9ajaVJMxgA/eGJuAz3DOQuuGT6YaYELLK1nRiXlYn1kw6U7DPvF1HDzeZFyEjrUyaqRiamKaNYt0QF0Y7wnZUVn5ylD4+qa5XwOBJC857/v31Vwim0xnxnUC+qQBJYPzze4poj4dIlesOW3sHtL9DvOXUDoiYjIdAXFg9qHwAhUaZg5zYGXX9mb9vbd5MNr72G25ReK0NZcNdzs5ZxNorxLgJVi31Ssg3Kj3u5pia1V3JkMzDRa2YuaSebwUEzRWBXg8aTjLHNrPoYDxkzA9TNFMRWmU8x79KPkq9JQLDJkJI/HXOGEqggkxxN0EYyZmHnnBdXNKApWrlV45FQpKnde4vdlwBVsP7DZaqID3iQtrZeqrEijzyd15NdRv+hY3nX2/27FiOq9GakLb09qp4I6VdQWK1m4SinSJnRKPsW/LRLeISXEHuL3irSvhdKOJyJDYlr/oSDxaGZq6WeKlh/LECzL9UZCcF7lkZbopQiyzyvCeFdEDHwwgQ32LIvbkgaFRY/0Gu3ItlhZC28/I2ZBGLKvIUZAONr7LH+HBGMS/8K3HQTm/QBZX63zzNIPCYNgJojFGf+uzeXJlmuo2GR+ZO5i3YlT3WaMK3AEB
 jXBxLKg3
 M99IHyOv2iUKNVVL4p4Oz1D3at6BqOypljTKURw+ds0Xn/eITWo9jQ2OoNxQp+40ZvX9pWzDFLZ1J81b9gfJJMCfYBW79K2ArXvCMdEHa23SRbCLUXKX9gYoFEid0cMkAoQYoRejx2fNA3vA91Iko7/RVEg1gpREtYiNwHBioeP0wXPjxaIVaICM/sAlCcJmQvlfx0koVN1BSWjJ8eA7yEl2ePmtl9/0Sl9tV3aDtfs2RJkUndHLiGufVGAmFG8H6V8HZOhPOHj9XmK4SLK9YGT6hyQILNWbIkOh3RpyvpSTKLHux5uUHfXLw26WHfkzUFmKfaYv1qhgzbVaNXAeuYwd5B05N1imyINtg7ou+t1Wg8NYgnRkKc2VIskKBSV+GEk/KBBDqgtVZ/vkPPpJhdMy9mcyHnpRp1eN2Pwhm/biF3aQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 29, 2026, at 04:13, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> Hugetlb migration might have to allocate a temporary folio through
> alloc_migrate_hugetlb_folio(). Such folios are currently accounted in
> "nr_huge_pages" but not in "surplus_huge_pages". =
persistent_huge_pages()
> can mistake them as persistent huge pages, as it merely calculates the
> difference.
>=20
> If set_max_huge_pages() shrinks the pool at the wrong time, it will =
turn
> hugetlb folios into surplus folios until persistent_huge_pages() =
returns
> the desired number.
>=20
> After the migration (successful or unsuccessful) either the new =
(temporary)
> folio or the old folio gets freed: this will reduce "nr_huge_pages" =
but
> not "surplus_huge_pages", to undo what was done when allocating a
> temporary folio.
>=20
> This can result in having more surplus folios than actually allocated
> folios:
>=20
>  HugePages_Total:       0
>  HugePages_Surp:        1
>=20
> =46rom then on persistent_huge_pages() returns garbage.
>=20
> To fix it, add internal temporary counters and subtract them when
> calculating persistent pool sizes. Update persistent_huge_pages() and =
add
> persistent_huge_pages_node() to make the code easier to read.
>=20
> Count migration targets and rejected surplus allocations as temporary.
> Transfer the per-node temporary count along with the temporary flag on
> migration, such that folio freeing will always do the right thing.
>=20
> Take care of calling account_new_hugetlb_folio() only after setting =
the
> folios to be temporary.
>=20
> For now, keep temporary folios in nr_huge_pages, so HugePages_Total =
and
> Hugetlb continue to include them and overcommit accounting remains
> unchanged. The new temporary counters are internal for now and are not
> exported to userspace.
>=20
> Fixes: ab5ac90aecf5 ("mm, hugetlb: do not rely on overcommit limit =
during migration")
> Cc: stable@kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


