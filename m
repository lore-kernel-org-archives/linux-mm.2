Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A206CFA0C2D
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9D136B0092; Wed, 15 Apr 2026 02:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74B76B0093; Wed, 15 Apr 2026 02:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB1466B0095; Wed, 15 Apr 2026 02:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A89526B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:08:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 590EDE3CB3
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:08:10 +0000 (UTC)
X-FDA: 84659759940.06.A11D7AB
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7EBAC160014
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:08:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MPiJ17Ru;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776233288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qkmui+O/6xlsFUmo6WfB3AyT/WYrnFjXuhphrajGuAw=;
	b=sME73lq9xqTp+qvOaLJpDDYYO6fqPJZmqdP3Nn1lCi6BLvUaqs7TlUesSuUevX+n+R1XdT
	2YIkW6vPcv/oXi5WKeP7YGRYblbghGScbg0zNgG+Ak/92sIItLLjjqBNgOPwU0k1/tf22q
	k5oC8j30naGi98HMXbFYrPzpbzUyxvU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MPiJ17Ru;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776233288; a=rsa-sha256;
	cv=none;
	b=EpkYQl62Or6LyUggKdikQJqznPN/pxRoWadZM+l5q2QRwAtiUy/CteJDo/XhtsqpXBR/7n
	sovBZuOFB51lChBlZuxwk37JuyHCqnksTDb4/ariPMjr6NmzZSA19f2Im0W9u09ZanmVwx
	crXpVnJsl6yXMir5jYjJevwHd4g0hQ8=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776233286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qkmui+O/6xlsFUmo6WfB3AyT/WYrnFjXuhphrajGuAw=;
	b=MPiJ17RuAuIGNOtXqwFkwLymQFIjSiqTT+2M57piZ3VK2T6EVdjuBmPk+tjInuUT8aTLNL
	gB0AX2DCS/xnlUzlxdonGB1lpdTP6oX8dR4q06Ra1rbprJ4pigmBdl+xKVY+/miLI0xZsZ
	Ck19wI4MYK3l4eB7Ij4q2DJPdA4RQGg=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH] mm/sparse: Fix race on mem_section->usage in pfn walkers
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260414224421.c030868f5960ad0115ac1668@linux-foundation.org>
Date: Wed, 15 Apr 2026 14:06:57 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
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
Message-Id: <2EDA3598-6D6E-479A-973C-92037C7EFF1F@linux.dev>
References: <20260415022326.53218-1-songmuchun@bytedance.com>
 <20260414224421.c030868f5960ad0115ac1668@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 7EBAC160014
X-Stat-Signature: ihbcq74ir5da6iccicgabwptj677r5g5
X-Rspamd-Server: rspam06
X-HE-Tag: 1776233288-305111
X-HE-Meta: U2FsdGVkX19RJjwG6kM7p+RjtmqAqMs7hhTP3Z6xoInmzVXA5SfYkv5rq1tEOWOwaXbNspeuQJjdy2KP3p5Vit+cIlRxEgsVwIX6DGeYr/N2yeBF7Ov79dgAkOV1RsNAghGVG1HpFIkmQD7oS3nN9tDqvMP2KDPR2MOWwqTt7UzR55V1qD9tr4VDx48cfvWtjAYQyfHWeyX67WfACCXZc1US0yKJS6RDBKyXVjoxazybpmKGbe53cHtwjmHhLjUHZyvewqpqpmJaih7Aj6dg2hQU32cvzCBs4HPZ/D/gtkSErciCuKLAtkGF/trIKKUvZK2KkmIWStkvGcR/RFVliZbV0EHva2B3QntjD/P1qNqetWRG4AALVBaNw+OZeHgHbtCn/Ix+IHLbzcwaH77CkmW32h2MTEr+mgHdxiAlpH7vGByNJsBFRpPEsJL3z2/PwzP2jGhkd9uSXtbLcD95OYQtTBCOxpI+QQ2FkTZTUFMfqbrvWDrtOmax54U5GOUZoj0BuAemsRQePUWGCCVPmXM+1IO9fFyxcFjKs7Pc6YqyGS2hDtJongsr1TrOLtn95gJ9pCCiani4yGwE4XUo28yWMnHRtWdl5lnehH7VVfJTQVbF2jDfdieeENdgjvM8vhHPuzYSzK1q9/5oaVfbA3ZltkS/wp/p1KdK9QkZ6se0YTcNmGnx4d4G7rdOnVKEj3LllYtuPKct7emgG2dh6mmXU4qoMMPCekxdlvUr8+jh3fqzPNg2XHcwswhzWYFBV36ZQH6rsMtU7vfH0odEiqGBWPy3svH5nUiZCfzDGq/ec9bBgQCKHlOd5cBpr12QUkXxIJAwCJAdhRN1JqEvoeFw1EZ61LyJGWNosF6XKRvmJH/rxuIQAuo/M2j8/45ZiU7RVmi7EZjBTPk19LhRJ7dP/fyVly5Cb0cQI431d5AR17zwiDxZXzXMep9ObjObZ1T90PuC7zSq1b9sjjU
 o3/ZBi+7
 KFqwGncsHkBJtnf2R9v96aAKLZrriQrn5JDkWy33jBhifme5Jp4n0q7Vqfh5purrsdauDMOGj769syz9A5SOO5rHBUEkmgPqdqXSy4rnbF/Nxu7Sd0uPolYOcqZh9pEWXB0xtI41z4z+s0FqSctF59m5qQJe7PBjmZ0K1aPmh6jOXf6p51VzxUgOdq+0v/Ls+jOt4F5g1grEw6rYzd0LOi1nNwgvx3rYCsZcgoODCSc7NJnJemuRdal6mglpgkiayFPPOTrkyPVAAHV9s3v0Gmu9ajbm4EQfdLeOdIsNWHNwXJMHLHbYvoCiGDqISfAi2jWV780KvYTy+o+DaXJXMtKtSNgHAQnq5GvOpi+xy6F9zpvM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 15, 2026, at 13:44, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Wed, 15 Apr 2026 10:23:26 +0800 Muchun Song =
<songmuchun@bytedance.com> wrote:
>=20
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
>=20
> Then what happens?  Can it oops?

Probably not, because struct mem_section_usage has no pointer members,
so there will be no dereference of a pointer. The UAF here may lead to
incorrect logic judgments later on.

>=20
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
>>=20
>> Fixes: 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing =
memory_section->usage")
>=20
> December 2023.

The probability of reordering is relatively low, and as mentioned above,
serious issues are unlikely to occur, so it will be hard to be =
discovered.

Thanks,
Muchun.

>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> This patch is focused on the ms->usage lifetime race only.
>>=20
>> ...
>>=20
>> I am not fully sure whether that reasoning is correct, or whether =
current
>> callers are expected to rely on additional hotplug serialization =
instead.
>> Comments on whether this is a real issue, and how the vmemmap =
lifetime is
>> expected to be handled here, would be very helpful.
>=20
> Thanks.  Quite a bit for consideration.
>=20
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -601,8 +601,10 @@ static void section_deactivate(unsigned long =
pfn, unsigned long nr_pages,
>>  * was allocated during boot.
>>  */
>> 	if (!PageReserved(virt_to_page(ms->usage))) {
>> - 		kfree_rcu(ms->usage, rcu);
>> - 		WRITE_ONCE(ms->usage, NULL);
>> + 		struct mem_section_usage *usage;
>> +
>> + 		usage =3D rcu_replace_pointer(ms->usage, NULL, true);
>> + 		kfree_rcu(usage, rcu);
>> 	}
>> 	memmap =3D pfn_to_page(SECTION_ALIGN_DOWN(pfn));
>> }
>=20
> This part isn't applicable to 7.0 - it depends on material I've sent =
to
> Linus for 7.1-rc1.
>=20
> So for now I'll drop this into mm-unstable to get it some runtime
> testing.  If people like this patch and we decide to proceed with it
> then I can make it a hotfix for 7.1-rcX.  But the -stable people will
> be wanting a backportable version of it, if we decide to backport,



