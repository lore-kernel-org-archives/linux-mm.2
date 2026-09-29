Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38BF9CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5DB6B00AB; Tue, 29 Sep 2026 04:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9ED16B00AC; Tue, 29 Sep 2026 04:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C66BD6B00AD; Tue, 29 Sep 2026 04:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A90FD6B00AB
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:01:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3EA88C03EF
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:14 +0000 (UTC)
X-FDA: 85266054468.20.E293D22
Received: from mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id A8A8F120008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lMU0QsoY;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1IwuMSJacXuO5iuVtr1QHu3zZ5caPuzPzh2uVWiE6/U=;
	b=GV3toYZX2zDCa4uAC2KcnfOl654bX5IFh3Z8WV/lbBNJSSczVS0GSj/0W16hnM/T9ijHqw
	9VR49MvqcTQJbvVkVyiE778ZiVvaV7cUuxVPfU7F5pSXAOmz0y6I5PRkIG/VcQ+1eeuO8G
	eC76OwGsNwCryBO66dr0ktxu/y2zjE0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668870;
	b=VZDbNFJcobgBpDxlLTMMMkmH8WS4SGNYRWGb0TRlxzzDK/k9QEQh91CkygNWo3ZxtrNwqp
	GZae8u7wigaToWtB85nPiAbx9Zi2wwIsMfJXQvbQTyZ+DJD19eSDuHxW+8wpJrMKxayXh0
	+D5ZxJ+807ATk537Ek1y/QSd5kH1AnY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lMU0QsoY;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MD9qZpr2p5t9FhYsovu1Jono6fdj3Cfdqpkd+cOqNz0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790668867; v=1; x=1791273667;
 b=lMU0QsoY2KF5d6NRuq+Mo+aBVslkZ7johyeftXATLk+DG3YgeY6BpIP4M/mYbAFv7n+8C0w4
 vjOjHGNEReV8sCi8F8vfO3qxf8JXoGQpdV9cSBmN7x1cOSXKiWYWsWnAAUuNrzZPC4yXVbrK+Vb
 jRWWxUDKN4WQA//K2rjTqnjE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 737886a2c9b58270;
	Tue, 29 Sep 2026 08:01:05 +0000
X-Mizu-Trace-ID: 737886a2c9b58270
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v5 02/12] mm/sparse-vmemmap: allocate shared tail page
 array dynamically
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <36a93f95-2fb4-4310-bef2-88c12dbe7971@kernel.org>
Date: Tue, 29 Sep 2026 16:00:42 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Lance Yang <lance.yang@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <78618F09-296E-4632-A890-53351739024D@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-3-songmuchun@bytedance.com>
 <36a93f95-2fb4-4310-bef2-88c12dbe7971@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A8A8F120008
X-Stat-Signature: w5zco9d3qjto7iyc5eheh971z6wc1m9g
X-HE-Tag: 1790668870-439643
X-HE-Meta: U2FsdGVkX1/xf9sTdfwufaHgi6HsZAXhwKQi2/rstVKKyHK9tfV5a46l5F1XQBEzaXnlp5Ztf5TwdbB85hu6S1Qf6nN/yX8zpRN/NvYD43m3h0hUFJqvjxCv/KHqgq+SDoXg9ViM6CzzIJuWhBcjgHkgqe2ki4Z7+kQ7lWae4uZifMHhrCHRg5rUK6iYx4uoSuKlHdYU/svY9RQFrdeycD4/c4ldUV/c5ROi1wQhOEb9IPBbwlH2Z0iO+1OuIHRhjt0hbUFWPhCHwZJ/DjfTw071IUHZWLUAAuOwx9h34cgIKmqi2Su8E+E3GY5O0ZZX01OoUw8cHok9Z6im6eg5xaAdwimYTNMes7XDcWLhs0aPjSliHYXC/qlVZ2MM+5cUiVm5S8amrwKCrRTg5h54OJ55yj7azbFfgD7l6IssipXDE2/Y5vv6TpbcaaMoPkbVinErwSnsfcO3SoMFmbnpSzwG0InlUUM1ZGjwr3bzEzrEuJ9vVsKhegk72fOH+lP+OQGr6nTOs7oCsNIAbFSPGHmK/LYg7Gw0TR7M62YuyPFgiC/RGYQbZg8yE20BEIOcomZJoum6Vvq3lwBkR3jSjnwetu9nyRJjA70f1tLx0xLcCzKovLyQlotYw3eYZ7ooTAdT48KjLb6vDa3Q7xkoXq9GM2A7a2GuBm7+0BWSv6GnkBWnMgYt/J9fzH3ArkZqgqpGxgQ83+T2yWWYaef7593I3g15TjWYElbOdqgfsg8cHk2/ua06IfAbTRywM3Tq47ANNeMLKmgCloGJSubmjl7SPsq7fWUOuAtJqaUTT5MMov6Ho3BwXD3inbvH/kx2Ro2DYn2CZ/oQb9McZMtCHrQwDAqi6CY4sW2FmKnwiClStCvXXVqVNvmghvi8sTnT75WuPfZOKezZeuKQSBPLY27OYgWz4iK7mrbwAeQlfWqpIGutJ3Za9zhIQWzMaaJnwz4F4zpSG/Y5ITPc92R
 J7cWp2qK
 AcyrFmvu6dFz4GEqzFrleKwQWkVcoeGgcdHoDe/BFsquRWm94/SvjdEdg9G6ue1tYWNIqDArnae2GGPo0d6+k4B8O4SMgz6RsjQCpKI089s7XjofR6/k+nBHBDSCfeHuMEiSD9gV2CPegxS2JI1wr9Xw3fUh2nH9Y6dJz1B0DPOZ+t6KwI6C/husRod5hCHe0W4IVgcW1PW/eumQMcsqSll2MrTWl2ymq+nJTEwzwzQ84r80EtS/oIS0h6mTKxj+ZskYyDdHJBRCU21mNTW46rHPjUIDtqJANVs6YIZN2Y4nizB1fzwDnNMNTqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 29, 2026, at 15:21, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 9/27/26 04:54, Muchun Song wrote:
>> Commit 622026e87c40 ("mm/hugetlb: remove fake head pages") added the
>> per-zone vmemmap_tails array. Its size depends on MAX_FOLIO_ORDER, =
which
>> had been moved to mmzone.h in preparation for the array.
>>=20
>> PUD_ORDER is defined by linux/pgtable.h, which cannot be included =
from
>> mmzone.h without creating an include cycle. It was therefore =
open-coded
>> as PUD_SHIFT - PAGE_SHIFT.
>>=20
>> This removed the dependency on PUD_ORDER, but not the underlying
>> dependency on architecture page-table definitions. PUD_SHIFT is
>> generally provided by architecture page-table headers, which are not
>> guaranteed to have been included when mmzone.h is parsed.
>>=20
>> The dependency remained hidden because vmemmap_tails was originally
>> guarded by CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP. Under that =
condition,
>> MAX_FOLIO_ORDER resolves to either MAX_PAGE_ORDER or the fixed =
HugeTLB
>> limit, rather than the PUD_SHIFT-based definition.
>>=20
>> Device DAX, however, does not require CONFIG_HUGETLB_PAGE. When it is
>> converted to use section-based vmemmap optimization, MAX_FOLIO_ORDER =
can
>> resolve to PUD_SHIFT - PAGE_SHIFT while it is being used to size
>> vmemmap_tails. This would make struct zone depend on architecture
>> page-table definitions being available when mmzone.h is parsed.
>>=20
>> Replace the embedded array with a pointer and allocate it on first =
use.
>> This moves the order-count evaluation into sparse-vmemmap.c, after =
the
>> architecture page-table definitions are available, and removes the
>> dependency from mmzone.h.
>>=20
>> Removing the compile-time array also removes the original reason for
>> keeping MAX_FOLIO_ORDER and the vmemmap optimization sizing =
definitions
>> in mmzone.h. Follow-up cleanups can place each definition in the =
header
>> owned by its respective subsystem.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> v5:
>> - Add this patch to fix the RISC-V build failure under the =
configuration
>>  reported by the kernel test robot
>> ---
>> include/linux/mmzone.h |  7 +------
>> mm/sparse-vmemmap.c    | 35 +++++++++++++++++++++++++++++++----
>> 2 files changed, 32 insertions(+), 10 deletions(-)
>>=20
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index acd94cecc0d3..68807ff7f946 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -113,11 +113,6 @@
>> (VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
>> #define VMEMMAP_OPTIMIZATION_MIN_ORDER =
(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
>>=20
>> -#define __VMEMMAP_OPTIMIZATION_NR_ORDERS \
>> - 	(MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
>> -#define VMEMMAP_OPTIMIZATION_NR_ORDERS \
>> - 	(__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 ? =
__VMEMMAP_OPTIMIZATION_NR_ORDERS : 0)
>> -
>> enum migratetype {
>> MIGRATE_UNMOVABLE,
>> MIGRATE_MOVABLE,
>> @@ -1156,7 +1151,7 @@ struct zone {
>> atomic_long_t vm_stat[NR_VM_ZONE_STAT_ITEMS];
>> atomic_long_t vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
>> #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>> - 	struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
>> + 	struct page **vmemmap_tails;
>> #endif
>> } ____cacheline_internodealigned_in_smp;
>>=20
>=20
>=20
> [...]
>=20
>> struct page __ref *vmemmap_shared_tail_page(unsigned int order, =
struct zone *zone)
>> {
>> 	void *addr;
>> - 	struct page *page;
>> + 	struct page *page, **pages;
>> 	const unsigned int idx =3D order - =
VMEMMAP_OPTIMIZATION_MIN_ORDER;
>>=20
>> 	 (WARN_ON_ONCE(idx >=3D VMEMMAP_OPTIMIZATION_NR_ORDERS))
>> 		return NULL;
>>=20
>> - 	page =3D READ_ONCE(zone->vmemmap_tails[idx]);
>> + 	pages =3D READ_ONCE(zone->vmemmap_tails) ? : =
vmemmap_tails_alloc(zone);
>=20
> This reads much nicer if you handle the  =
READ_ONCE(zone->vmemmap_tails) inside
> the function.
>=20
> pages =3D vmemmap_tails(zone);

Sounds good.

>=20
> So just place the entire logic of obtaining the array in there.

No problem.

Thanks,
Muchun

>=20
>=20
> Apart from that LGTM.
>=20
> --=20
> Cheers,
>=20
> David



