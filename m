Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD192C5AD5A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 22:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662396B007B; Sun,  9 Aug 2026 18:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613A56B008A; Sun,  9 Aug 2026 18:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528D16B008C; Sun,  9 Aug 2026 18:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9936B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 18:19:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0389A1C158C
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 22:19:34 +0000 (UTC)
X-FDA: 85083148710.06.70D7FFE
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7958840005
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 22:19:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=ouv34i1w;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf01.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786313973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCth6d4HKGfZUrSI82mfMkVa2dz4/Lsd/fle9sOPtXY=;
	b=BwCvMl/sjuVB2cFpIvidzMXtQ+MG7DjtUEboD8GHeP6PbizgOKxlXUhx6VY8j+Owp+o/Zg
	xg+ygr7GIfPKNxvkqLJG9BfeOlnj0zs/IpiNq7nYfAtldesxfYncZZxiYihXtBnETSkv7c
	b62OKrBCx449gX3YdAmIZY7Q1VXvoAM=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=ouv34i1w;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf01.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786313973;
	b=ci8vU5Mlvtu/HTldFSKt3i6DzbuCLNXzADtymvoKPZL9K3D4Ud0XRnEjGqZwCjvQQujpwk
	RYnbHJbCPq0rZFatdPK2e6pC/9ATXWN0Wc7Ry+u1+gwEyePEsX4oQcdJyhADen39poY88P
	fx9x7QuSdwCGs4/7MAeqA07lR2v5xp8=
ARC-Seal: i=1; a=rsa-sha256; t=1786313956; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=NQCq8XmOE6qKoO22GjVXqQTOR2Sp+vKAmkW5pvVfbl9swnWfzKI08lhQevogBp3dxvlN4IIhAAi1tySJtyUmtP03p5zjOIVRgn3TcgBX0sh08uaHVT9Vt87Cdn3K8oTF+XoO62mbIFkr8o+OKIDQDK5bXZuzXJ3HFgaRgVHZpl8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1786313956; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=TCth6d4HKGfZUrSI82mfMkVa2dz4/Lsd/fle9sOPtXY=; 
	b=VCf4C6/taSAoFArzTNsEpCWwCs+69Ft/yY5kKM7Fm+LVA6dQqnWK4y5Ti4C4Kxyk4oCB51txZR6iasU01adNfooryf6XUTlUbJ1drFX0kEHm3CQVLNFKR0XJNyU4uIryr6zoLJgNr6GYgEo5hM99p64BZGDC9iDnM56lOGhieSQ=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1786313956;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=TCth6d4HKGfZUrSI82mfMkVa2dz4/Lsd/fle9sOPtXY=;
	b=ouv34i1wGWg+xIW6QEo3g6/D+Vn0pM/fW9jaX6lcCwZVpttuqdKa3t/gEF6OdCN1
	UZCLr7ug9QRIFZ4KZ2SXjlQZDXpT53bPnybfavafr7WaA0eIsqnBZ9Sh+P3Mb/6dtrt
	3KpqGKyOudNRI/qhJ/7uoZelGE8YXB42X+7Dj9Yo=
Received: by mx.zoho.in with SMTPS id 1786313955272460.28314754096664;
	Mon, 10 Aug 2026 03:49:15 +0530 (IST)
Message-ID: <da382f96-2da9-44ff-b1cd-1e087c93b110@zohomail.in>
Date: Mon, 10 Aug 2026 03:49:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: support splitting mappingless swapcache folios
To: Zi Yan <ziy@nvidia.com>, Kairui Song <ryncsn@gmail.com>
Cc: Kairui Song <kasong@tencent.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Nico Pache <nico.pache@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260805-b4-mappingless-swapcache-v1-0-b1d78ba257ca@zohomail.in>
 <590B3189-5B66-4ECB-84CD-7B7EF18C0E54@nvidia.com>
 <anNOroQdjQh7xmU9@KASONG-MC4> <DKIRYOJXLIYN.32KI06POZL7SY@nvidia.com>
 <anZLkwwxHdhM2M2Q@KASONG-MC4> <DKJQ3G2MCOGS.7T7QJ4TDZWG1@nvidia.com>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <DKJQ3G2MCOGS.7T7QJ4TDZWG1@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7958840005
X-Stat-Signature: kgh6ynah3fi7w1zo5z5a45ctsojdas8y
X-Rspam-User: 
X-HE-Tag: 1786313972-7166
X-HE-Meta: U2FsdGVkX1/j82X0BuPhwMbI81J0hAHSb0rJQmy3BwEF+zbVIWKH35MN9i4ZsRUKUONzB8Hn5u1v+KTDgUfy284/jVZP+/d/5k09qI8eu6Z9cMplDpzC/HRNG0XEOTiAkVfAnFjqveSdm2TEah7U5XrB1bs9SsjnpUqocFqzkfd76n+0oBXZU1ibqo30Uq1O4kw624lSPuNjgQoyDl43j90g7RCQZb24ibJEsk244+eFJKrWvpFZvJtzUKpFPYMsC7jQgS9ClICh2Tpw3NKRXSjrFvXRxoaqNaEAxHHXammBgLrcGrhTdL3LCYILY4wnYkUO1lWto7wstwSoJ8clRPlcDzpvR2DIdxgHgZ/V8nhmeCR4AC7kl534UJ/HOZHjGTYVosKWmW5OB09PG/dYkXx8WVtsYhhAIdfw/GKT5+qOHa0kBM4D8l+Zrcc+nsACr8G+Ah6i3OUHcaOYhg2bMf0oIEsKVzqjVLdbtk3Ur8hzoJNuOAi8Pi6iC8HAyghhDiI4mU96hEY6shD0r1A2uR8UMzxguviiXrtN3p/xHh5jghbZ7Ss6tZXaHZb8bluexh1xslNqamz3zPKAq3m2Qv9lrmXVMVJ2SWkszK6J0ZX/0vG5jlKGcQIJq7XrP4ZLu9use6Tzj1dSvy+TM/iDrYj5vXHeNw6kIPOb2utAuGnVNeGB/+UDIjh/350SJjfyJPAVQLJJNQSDJ4jqIMisTscd1GcXhMs0r9ePknAfK0KOm5HhqPo+f+mMgCOxCkhAYcTsqDWFOt7CqiPGQQ75FvjvHRrsNlx85Cx4/wOoEht8rJQmyUkMyC8YyHpGaY36vnV2OsjirSpW7e177IJiVvd3KMDpQQ0cHhTRVcoLiw2Fbb71wqKI0bpJOQlFhnSRaLC20VkwNVRODaUJ59ss+oZAIo6FF8yeJNcJl8cRpluz/f7XeMJXQr4BqgImCgNVGnzUpaM6Oc2/9dHAwbs
 HIt2vUSN
 tHQIydonmh04CKyoY7XvJLcZQCCxLbTzJsNrikma9ZUQ7rbsXjoP4ctkFEjBHPYRBa+Fon87tL5/ZUaiJgAt4Xi+Vk+A9v+sEwiMRm4+jLzNi/HWAylwWvAGwCOGOhta/lWZ0Y7CapLAynGRxP9jTnqNkMfJ9KPDwhyvJec5Qm3s++yYkXDNZBPRhT4LymRlP+1hXvJHWa3xftl/xzeXahYF0Cpyka3ktOiZ4k/Baz3MmtvsvCJXYTlONk4v92lrd4HyzUY/7x13XG0D2k5YjdJi1oNYnrYeGz96Jwze7rr45kqX7osab2iy/912ptm3iAEBh9+OkUJlDCYGhfFjAykvV9el9pbZfOJMXeDEhNKyBDrU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/08/26 22:32, Zi Yan wrote:
> On Fri Aug 7, 2026 at 5:22 PM EDT, Kairui Song wrote:
>>
>> Hello,
>>
>> Thanks for the reminder, I got a bit busy so delayed for a day on that
>> RFC.
>>
>> For this series I think it's functionally fine, just the split logic is
>> a bit complex to follow and we still have restriction on swap cache
>> for order 0 uniform split only. I'll have a closer look later. Also
> 
> I agree. I wonder if it is possible that a shmem in swapcache could
> enter non uniform split, folio_split(). With Patch 1,
> folio_check_splittable() will return -EINVAL, causing a WARN.
> 
> Hi Shivam,
> 
> Can you check the above issue? If it is possible, we want to avoid it.
> 
>> let me know how you think about that RFC.
> 
> Sure, will take a look.
Hi Zi,

I checked the current folio_split() callers and this does not seem
possible.

The shmem swapout path unmaps the folio before clearing folio->mapping,
with the folio locked. The non-uniform split callers either get the folio
from an address_space or from a present page-table entry, so they cannot
find a mappingless shmem folio in swapcache.

The memory-failure path uses split_huge_page_to_order(), which performs a
uniform split.

So I don't think the WARN is reachable with the current callers.

Thanks,
Shivam

