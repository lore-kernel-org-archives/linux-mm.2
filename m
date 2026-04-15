Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F4F9F41980
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 09:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A62A46B0092; Wed, 15 Apr 2026 05:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A12F76B0093; Wed, 15 Apr 2026 05:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9287E6B0095; Wed, 15 Apr 2026 05:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8549D6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:46:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2EEFD1A03D6
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:46:16 +0000 (UTC)
X-FDA: 84660309552.13.208DC57
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3822280002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:46:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QBjm0Q98;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776246374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xd8e3J+b1LcawueW4g5SlvWwVt0JRcLEm6Lowqe8HOs=;
	b=YRDxHZC/e7e1Ga+bLbznJUj8K4NrOKJ2KWyrps1tXA+K2xKu/eDRqoKjerzDKeRkqzk+u8
	3YG5EmMrGTxe+sCsvwQeNV9JDCnEfQr+sap6OqDhcLzPK3MfocCXuXm6UYc9KCNyUEZ4MI
	qTo1zrUM/dCgDfYHH7pBtC0Oy6uBNq0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QBjm0Q98;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776246374; a=rsa-sha256;
	cv=none;
	b=fz74y+cdoszfMSusNTAgtKHfDkqNSMI6GiOdFB/mdVjhwoKy5YjIFd1Va99b2A6Kj5+SiK
	4shZckjiFdGO/qd61SYj/aP2p2jOF8DELv3QmWqIO6eSjhF774z0Pg0eZD7AC6e7Kknk7y
	q7seueohR88cOq8Fy7JKtB9tbTkXYP8=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776246371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xd8e3J+b1LcawueW4g5SlvWwVt0JRcLEm6Lowqe8HOs=;
	b=QBjm0Q98krTet/JEVaYxsXi3oRR/HslqU6S8M/huMahtsUrSqju2CsMK51OOb10zGFFiht
	b2u0G+nNTz3ItgjIOnwsT41ZtHsmuZwONXdX1Fr79WE63a+3itGIICjNzcoPxz4dZ0SVsV
	qMEIFNVptxhj8mN9y+7WGVtkDGVJfNs=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH] mm/sparse: Fix race on mem_section->usage in pfn walkers
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ad9OZAVnYvhxfh-Z@localhost.localdomain>
Date: Wed, 15 Apr 2026 17:45:30 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Charan Teja Kalla <quic_charante@quicinc.com>,
 Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9E4115F4-5787-495F-BCEE-1E9B1113E9E5@linux.dev>
References: <20260415022326.53218-1-songmuchun@bytedance.com>
 <ad9OZAVnYvhxfh-Z@localhost.localdomain>
To: Oscar Salvador <osalvador@suse.de>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3822280002
X-Stat-Signature: 1i3qhkkyc8zbtfsbx3gc5wj3jhbr6zij
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776246374-785542
X-HE-Meta: U2FsdGVkX1/3FJ18wB7p/Y5+PNxwQM5io5zPIK+mYTbjfeftSjQeOtzqE8C1SipCCs7QIaGI3pckoN3ZMZiBfQCenWkZuJdIM2KI6Tg2EC99KGUsq7PVSi8+UNu/QuEj0QFM2frA9/IhYGA7RmotdjCJgCtETCQpHtOSmS4R54V4MVySBpfYn5UWztGFXtybXzLA6gzEJDiuhY4LFoS6N9/qJx8SAWIAgw4MNqr+CXJC5wmnS1kRpKkNr2ejNDrIFuJwtHDaW3idiYG8v/SGHbTWrwKhO0bElIqcQ9k8jT9UjAFYKygyLjusaxtRCk4y+JJcuqqUfmYO+6yGQrLREBolNTfvn8KF/PiN3JwnryR/l4Eeiy+8TGLYcLrgDuUcjgaIRA9kaZrIUR6ZLVAOWl6KrBtL7/bQtV8L9TLH1wwCTxWkTkh4gkvSLLzFyktWmGQ6QcczmwsI9FGR48yjVbSHJU41kf0JhQe0aCLJ4DNB3hqRlncHsiLCGoR1qy/GRgzI0pV/+i91BjZAoK+MtJUArlCYxts+C4kICL+RWxCTK9f1Jr+l3yyzTQWnPJaV8GKMaZgXT98Ud1hxGhSg+Yswy0YIvinfs+o3LbICukcC+cV7ZzjQNQpaS9XWRHRnSzhzpiWJMR04y415aoGR4k7YH2GNo7OBUd+/pEuzibETT+XcG8slwrFMEwt65G09aGCBYPxR1v4ObkHBRMx6WJddLO+MscEWFQKD48yj4dUmoIh//GJwzOYuaKp0G9Z/Bu7lrKBomj7HiA2aEiGaug6nRMLgUYUema9Ps/dfItXGiI0COC3WncuHtJ3lUYgGELstWrKhM1uxojvpz6+IrSc1051n0Tak5PuX/G6Pq7HguoZ7khVjBc93nUU012HG/Y8fxyEen8Z7p+oZRTL4pq0w2Z0xJWX4isTQjHqagSt54kuhpN3l3ch+F16Wi/ujgMNM1zwg8fFGFeMUdYh
 AYfNmGY6
 4kEs5zkGHgP3tDVqztR/vSmwk4114rz2Ogil0HwKtA6E9sZz+sifukWXZybrpwghlXb3Kb+2N+n4O5XmtTydIiFsLz8Orn7yKeTSXyiqMPxFLyRes3sfLmH5JHcVpPqfaF+sFxyovCwKtwSa4u3eHdJ6gqDX0c1dsv476f/fAnoMXS/3c+Yjv1G03U7YK/x/FQvVQfJ2y1PrCdTo/lAjF4flvLRpiHn7zTGVOB1SP+EmwvNp2hauQk5skHg+RZGvnfdAR5XMmR96mEmGY67+Is9GiTKDB8dMC5t/O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 15, 2026, at 16:37, Oscar Salvador <osalvador@suse.de> wrote:
>=20
> On Wed, Apr 15, 2026 at 10:23:26AM +0800, Muchun Song wrote:
>> When memory is hot-removed, section_deactivate() can tear down
>> mem_section->usage while concurrent pfn walkers still inspect the
>> subsection map via pfn_section_valid() or pfn_section_first_valid().
>>=20
>> After commit 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing
>> memory_section->usage") converted the teardown to an RCU-based
>> scheme, the code still relies on SECTION_HAS_MEM_MAP becoming visible
>> to readers before ms->usage is cleared and queued for freeing.
>>=20
>> That ordering is not guaranteed. section_deactivate() can clear
>> ms->usage and queue kfree_rcu() before another CPU observes the
>> SECTION_HAS_MEM_MAP clear. A concurrent pfn walker can therefore see
>> valid_section() return true, enter its sched-RCU read-side critical
>> section after kfree_rcu() has already been queued, and then =
dereference
>> a stale ms->usage pointer.
>>=20
>> And pfn_to_online_page() can call pfn_section_valid() without its
>> own sched-RCU read-side critical section, which has similar problem.
>>=20
>> The race looks like this:
>>=20
>>  compact_zone()                    memunmap_pages
>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D                    =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>                                    __remove_pages()->
>>                                      sparse_remove_section()->
>>                                        section_deactivate():
>>                                          a) [ Clear =
SECTION_HAS_MEM_MAP
>>                                               is reordered to b) ]
>>                                          kfree_rcu(ms->usage)
>>      __pageblock_pfn_to_page
>>         ......
>>          pfn_valid():
>>            rcu_read_lock_sched()
>>            valid_section() // return true
>>            pfn_section_valid()
>>              [Access ms->usage which is UAF]
>>                                          WRITE_ONCE(ms->usage, NULL)
>>            rcu_read_unlock_sched()       b) Clear SECTION_HAS_MEM_MAP
>>=20
>> Fix this by using rcu_replace_pointer() when clearing ms->usage in
>> section_deactivate(), then it does not rely on the order of clearing
>> of SECTION_HAS_MEM_MAP.
>=20
> The fix itself does not look too intrusive and I guess it kind of =
makes
> sense when you think about the ordering issue, so if we want to be
> rock solid, why not.

You are right. Generally speaking, where RCU is used, the pointer should
be cleared first, and then the memory corresponding to the pointer =
should
be released via kfree_rcu(). Therefore, the correct sequence of use here
should be:

	WRITE_ONCE(ms->usage, NULL);
	kfree_rcu(ms->usage);

The actual code has the order reversed. To prevent such errors, the RCU
mechanism provides the rcu_replace_pointer() interface. If you look at =
its
implementation, this interface is essentially equivalent to the code =
sequence
mentioned above.

> Does it slow down operations a lot?

Regarding section_deactivate, I believe there is no functional =
difference.

>=20
> I would also point out that you rcu-protect pfn_section_valid().

rcu_dereference_sched() is equivalent to the previous READ_ONCE(), but =
for
RCU-protected resources, it is recommended to use the RCU-specific =
interfaces
to avoid having to manually account for memory ordering issues.

>=20
> Regarding the pfn_to_online_page() race, that is something that every =
now
> and then pops up, but as David said, we never seen that happening in =
the
> wild so I guess no one really made the time to look into that.

After taking a closer look at commit 5ec8e8ea8b77, it=E2=80=99s clear =
that it was
intended to resolve a race between __pageblock_pfn_to_page and =
section_deactivate.
While the issue surfaced this time due to ms->usage, I=E2=80=99m =
concerned that even
with ms->usage fixed, the underlying race condition in the execution =
path
still exists. This suggests that subsequent accesses to struct page =
might
run into similar trouble down the road.

That said, I=E2=80=99d love to hear what everyone thinks about whether =
this warrants a
full fix.

Thanks,
Muchun.

>=20
>=20
>=20
> --=20
> Oscar Salvador
> SUSE Labs


