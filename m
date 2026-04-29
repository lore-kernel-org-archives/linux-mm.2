Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD70AFF885A
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 03:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09996B0093; Tue, 28 Apr 2026 23:15:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1456B0095; Tue, 28 Apr 2026 23:15:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1DFD6B0096; Tue, 28 Apr 2026 23:15:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C04926B0093
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:15:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 671CD1A036B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:15:21 +0000 (UTC)
X-FDA: 84710127642.13.EB7E73C
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 846B01C000E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:15:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G5pTeOpl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777432519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qU5tmzrS1IaHJYw4tCQ3LolTQkEkhN4AGDqa8zVsBOY=;
	b=OPl/BHzgFsZ4/qx/Yt1JBwLtboUUDkcktvvmNZ4DLvTJxZZsB6JF3Yl0AnIFhuKwMt4fmK
	wQZOdNYUHZqFcH+cObFNlYQgmlu2WibGBrGdnlIJBwrugCPKGkJeJszp/IPwQ0RWbNnNtc
	tN13VpiyHEfVuMp6l739tS5BlInbw0c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777432519; a=rsa-sha256;
	cv=none;
	b=q2Qsa4coPALDu5XD6Xr/bWTgmm4+qKXp35WYEyKLvKRHLy5GToLCQ+ecuK7NMb/SJKxZ2m
	gLIpYS5dXowJoF4dRrHovtH+SDZAOZlQACXsnG2Qu51SF5FCOLQBs4vCQmOnQytmLMttqx
	jxIAq83PjmNKmdVbQXaMNoPkpfwVgeg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G5pTeOpl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777432517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qU5tmzrS1IaHJYw4tCQ3LolTQkEkhN4AGDqa8zVsBOY=;
	b=G5pTeOpltJII7tZbmqmbXcd2mxNQW+oQBat6cBWM+NlWV218lDA++quyRMXu+eAmQF5aQp
	FlPTaucRkiYHiUnqppywHZevYmAx7s0qfE7hjjWhHt5+KUXS54L3k96qPoRzNHqZOf/kjY
	FvOukquIXnh4VKoapeLovcgSmMrPJoQ=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 09/49] mm: panic on memory allocation failure in
 sparse_init_nid()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <afCxZ5vYDeAlzTK2@kernel.org>
Date: Wed, 29 Apr 2026 11:14:14 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <408EDCB4-7F65-4595-BE44-E23300FBD397@linux.dev>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-10-songmuchun@bytedance.com>
 <afBaMEBoR_35Fblc@kernel.org>
 <9FD13495-58E8-4183-AAC0-48E50A694ADE@linux.dev>
 <afCxZ5vYDeAlzTK2@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 846B01C000E
X-Stat-Signature: 4tbh14fefh8os7mwo9iutgsb9ud8j6c1
X-Rspam-User: 
X-HE-Tag: 1777432519-41270
X-HE-Meta: U2FsdGVkX1913Ig8KRtm8nLS4LyoGUJ/IDLl/FiIilI/H7Nru6bMSBYUp17jWRZmmeY8WtIrbhmzKDrQAf5uR+Poia8rSc/InVIaqBf50s4EqCmk1fgA94qB09+wyRqnUWbgfJ6bskFhELjCbusnUcSeUk57Ts/2qHdngup0c9js/IYMCnbXhldTUGQN/Ljkz1kHMC7itmgLzErNk8RkJkvdwXMtfGxZSCL+wnnRWbPQ3tHp6H2Yf2xkZERU/a+Xlm2I4sjb9ALxYk6nZbV3qaENTMpp+BBCvfsUEF4oYdrkRbo3+F8UweGhyMfjVEUzf7ZFkDmDRHAz2i84wG6HIGJvfJrHodpZkA+Uq10cBWSqjEb9QlS08KN+ssSmMWEZ2bb53F/WWM4uYSDnTauFroMjixcIxt0yGCv9C8b5+olwoQzTGF61LAqzYsCW4QpyRreVW3y2e5rj7KZVjKjQuAqw4WkHaRwFOY/S5kMrOgCgRgAke7NtZA2q1M7g/QtNk65AZKsvWgN9JjoAUnZfVd+T40B0h9fLqMzhQf34EHmvHBkvr9Q3IvnViBwXGdWLp4v51a7NryM0rNsg7W5Ck1GRZ0XnOxBHmQglQXNY1ag17+QKkpCMIhjEjtVUDMR4etZkjOzWvHSLco7t0ggMFMTmt0+462mHeZITXhoDzye0mZZIMxzL5lsJkW0oLx1oAjqPIeCy9hjDy6st/FufAtWMxelghoEbJhpMd+b6VdI0ijChXGEa1RMgoyA46Z+Jse5M3ixwuzS0pnL+rcaCgCCjtTAkQF15JTi7w26y66Wybdl79hX16vj514NLME740FUo7iLW4x4etdLpzoziPlAqGyDauPdITT7NfDQF64dOtRT5+LfaJC/AA8100KYGsAli9+maGBL+L1RkpMQcbSkQYLeOhqI0eZDDTI+iPugp/aggISCrinh8FBHi30t05IGoCm80pt1LDOfjBp3
 Q0WJpMee
 yfzdf4MaSzK+LYUZKARTvLpCSD+BRGD+7TpkXoa3tS9Sqt7LjTpt5Fc2Qtb8oxbJIWdJ4F8YTK+77iOqI+NOcKqS+ZupQ3Tpn6zJ8m/sDJ/c8L48v7GI3AgTlQNLVyziImVnhifCxrdfKJbTBaFtRyzD5UJWVTX4kVZnvJH0hNEcUz966n75t7DGZmgvv8X/5xcGNoOQiC055OGgOaO8IbTHaJIypkuQwzMqDfWREW3mrbNka4MpcH2wCBLERyeoUV5mslg64ao6W++VYOMtiAW2bunjR4SlIm4BOha2qkvHBdJROT0UOOv/ljyZ5et563+kmIIodEu5p/YI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 28, 2026, at 21:08, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> Hi Muchun,
>=20
> On Tue, Apr 28, 2026 at 08:13:05PM +0800, Muchun Song wrote:
>>=20
>>> On Apr 28, 2026, at 14:56, Mike Rapoport <rppt@kernel.org> wrote:
>>>=20
>>> On Sun, Apr 05, 2026 at 08:52:00PM +0800, Muchun Song wrote:
>>>> When vmemmap pages allocation or usemap allocation fails, =
sparse_init_nid()
>>>> currently only marks the corresponding section as non-present. =
However,
>>>> subsequent code like memmap_init() iterating over PFNs does not =
check for
>>>> non-present sections, leading to invalid memory access (additional,
>>>> subsection_map_init() accessing the unallocated usemap as well).
>>>>=20
>>>> It is complex to audit and fix all boot-time PFN iterators to =
handle these
>>>> partially initialized sections correctly. Since vmemmap and usemap =
allocation
>>>> failures are extremely rare during early boot, the more appropriate =
approach
>>>> is to expose the problem as early as possible.
>>>>=20
>>>> Therefore, use BUG_ON() to panic immediately if allocation fails, =
instead of
>>>> attempting a partial recovery that leads to obscure crashes later.
>>>>=20
>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>=20
>>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>>=20
>>>> ---
>>>> mm/sparse.c | 37 ++++++++-----------------------------
>>>> 1 file changed, 8 insertions(+), 29 deletions(-)
>>>>=20
>>>> diff --git a/mm/sparse.c b/mm/sparse.c
>>>> index effdac6b0ab1..5c12b979a618 100644
>>>> --- a/mm/sparse.c
>>>> +++ b/mm/sparse.c
>>>> @@ -354,19 +354,15 @@ static void __init sparse_init_nid(int nid, =
unsigned long pnum_begin,
>>>>   unsigned long map_count)
>>>> {
>>>> unsigned long pnum;
>>>> -  struct page *map;
>>>> -  struct mem_section *ms;
>>>> -
>>>> -  if (sparse_usage_init(nid, map_count)) {
>>>> -  pr_err("%s: node[%d] usemap allocation failed", __func__, nid);
>>>> -  goto failed;
>>>> -  }
>>>>=20
>>>> +  if (sparse_usage_init(nid, map_count))
>>>> +  panic("The node[%d] usemap allocation failed\n", nid);
>>>=20
>>> Please consider using memblock_alloc_or_panic() in =
sparse_usage_init(), it
>>> would simplify the code even more.
>>=20
>> Hi Mike,
>>=20
>> Should we add a new function like memblock_alloc_node_or_panic? =
Because
>> we want to allocate vmemmap pages on the same node.
>=20
> Heh, I missed the nid part :)=20
> There are a few _node_ or _nid_ allocation helpers in memblock, =
starting to
> add _nopanic for them would be overkill. Let's keep panic()s at call =
sites.

We can add a panic inside memmap_alloc() because it is used specifically =
for
memmap allocation. To some extent, this also reduces the number of =
places where
callers need to add a panic. What do you think?

Thanks.

>=20
>> Thanks.
>>=20
>>=20
>=20
> --=20
> Sincerely yours,
> Mike.



