Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 699DAFF886F
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5D846B0096; Tue, 28 Apr 2026 03:03:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D351E6B0098; Tue, 28 Apr 2026 03:03:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72656B0099; Tue, 28 Apr 2026 03:03:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B62876B0096
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:03:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C50C1604CA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:03:30 +0000 (UTC)
X-FDA: 84707073780.21.C9128CE
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id EA1B840008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:03:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uEMowhdT;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777359808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m65F23/62CDX/gfV+DJ/SyWW1JLoAdNRr+rVnoGxkFY=;
	b=vWNG5Ggeahjh/1lcndcE2rPGB4O616JBVgRaGvkEJkueQvJhCvF+V1sZPZ6pdyOP6BvsqH
	V/JQtmIuz5HENPXn2MRGdBBDeR/mUK3ZK/EZbgjEGRAZKKrA1o9o6io4fEttzwtd1XRrRI
	X0JLc2b3RsuCItNbpCiy4q70CxLvSiA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uEMowhdT;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777359808; a=rsa-sha256;
	cv=none;
	b=NTiYrYlo1kh/rUs90qaz3yOtLDYEI0Ra2smZxqE3hDR1eNHBlHG7HaTPt1Wphxw8AFPjCy
	qmjakVx2lC/mgc7o2teGXmuPbK/9t6cjatoh9RQVWEsvbG60WGCf5KOpwOQMfTIksuRQlR
	J54hpAfBni9zh25eIirhvvTuMa/IWNQ=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777359803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m65F23/62CDX/gfV+DJ/SyWW1JLoAdNRr+rVnoGxkFY=;
	b=uEMowhdTmYivW6Yp0mQBkEN0edND6tucf0nNvmJCZ/QVuvXHHewn1r5qXw5/JMu/dqG6wm
	rcH7y0jjypRkLS5LeeLRPQgyO9AbGnuES3UYZh2lh89R74LUQunJaKdHqwlXmG9noWSCD2
	UQh11NwUPbATYpKCGFyHnHOvZRRzuK8=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 09/49] mm: panic on memory allocation failure in
 sparse_init_nid()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <afBaMEBoR_35Fblc@kernel.org>
Date: Tue, 28 Apr 2026 15:02:14 +0800
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
Message-Id: <96DB49C7-A7C2-4F53-8321-FF4A4ECDFF95@linux.dev>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-10-songmuchun@bytedance.com>
 <afBaMEBoR_35Fblc@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: c6ys9zyd5qgnjxjwoq7ykoqu3t3pqjn5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EA1B840008
X-Rspam-User: 
X-HE-Tag: 1777359806-985429
X-HE-Meta: U2FsdGVkX1/L2j7b1k++BDc3yChAO7Bv8rXPXBphmRMttK5vs7OlHMEnqg5wNwyYN9YPFsbP3K7REjVCx9szntO2OcolSXaD+cv9gOJEy+1phXshQ5VKDiT4jBIlI/f5kRtK1/IrP+KTQDhDV1OekR0FRszwlVa9G+GrP7Z8wnNQ7KHnnNFxz21KY2ejyWfav3K1EN8oQ8skBO3bM2ivQhmQHFyQq02afAtxRuf+DeDQLWcsu2SBzNqqZ7wmUI3KVRxvk7qYLscoQk8rAFO18l/ov7AOXTdaFIZqIfcG2r6c6ZJcufbSYypeARQabsrKLVsEDPpf6m5aUVjVyGdCKw5k4+mLdBJSLqpMND6Cr7bwsK9o6IBBUwjcyhs9tPS+knFaZDVW0d17R0DURp1LtYXLDT1wUl9Q4+WsCP1R54AYb8X2mJEllQiHiSP/aYgLnuELOFnJj1HoBzRRrcPMMtzr2GkM0g4mADcZ4PuBeqsgwLRXmOiBJLMPXBp3U3PjaDL+MonUWvFxaLv9kpGj5JwZ52NF1Oqw3mDAq7+ZPx8i5G2n+RgQXWTlsPZFFWkzjMlWGSG9fO2TSDxAQbHAQhCHN9ZAykA437gAEKL+3XxJK9ewhRJta/ud+gv4VxhsEN9jEs5hBPvt73RPp88QKLvXSoU0y4663mVF/iYHQ7iV1tnwNfWO8t9ZeEjg8CCJoOXol1yIlMVj/PvIQJPK8akHWBLeyJnVwSa446oHZGuZ3+PLJN7yv7/MWeRgq4RWMtzonAfbUYIOcR9R6qrP55GDaGerHk3eWvFycePHGGbW/9I00VF9kF1X06e/G9WtGALXzK1T9uOu7VeFrqCuZW/LDtpcFHdmidH6nlnD1MotWt1Ye2D1X/jhxQvMG0tMAz6GCIsko4wNIEc4upEeeh4chJqW9/ryO/XJJAU8JICdKpKs+rx6nTM+B5SzwZIF4imTuvJvSvPSaReNNfS
 FJB6k7WV
 H2b7G/sRRFFLycBHHioa8Od/efHQu/JE8ZpZha81iKUmE7m/sukViu4U4lj0+rF5+6J/WJzJvfcHslDqbt/76tSw+GB/31FrW0TB7jpOB+qIOP6fXW8Ti08ianSxJn3ysQ+3g/5WHwazrjWuFlCVVV7/IaJ2oD7awxzhBP2hKJR4TwohwKmnO22IU7pFd9yWmkREFwansGF6+oHm7N/RoX5wBteM40A6l3GLkddG4pOSWyk3TmGBu7UWiVTN8V72FdPhEy+/VKCzf9a4fdkMhNRdC5Gb5bQJoSmMgU03LjCzMBvcVqrN6+2GTbHGWmyyo3KL7oXpfVqM20Rs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 28, 2026, at 14:56, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Sun, Apr 05, 2026 at 08:52:00PM +0800, Muchun Song wrote:
>> When vmemmap pages allocation or usemap allocation fails, =
sparse_init_nid()
>> currently only marks the corresponding section as non-present. =
However,
>> subsequent code like memmap_init() iterating over PFNs does not check =
for
>> non-present sections, leading to invalid memory access (additional,
>> subsection_map_init() accessing the unallocated usemap as well).
>>=20
>> It is complex to audit and fix all boot-time PFN iterators to handle =
these
>> partially initialized sections correctly. Since vmemmap and usemap =
allocation
>> failures are extremely rare during early boot, the more appropriate =
approach
>> is to expose the problem as early as possible.
>>=20
>> Therefore, use BUG_ON() to panic immediately if allocation fails, =
instead of
>> attempting a partial recovery that leads to obscure crashes later.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>=20
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks.

>=20
>> ---
>> mm/sparse.c | 37 ++++++++-----------------------------
>> 1 file changed, 8 insertions(+), 29 deletions(-)
>>=20
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index effdac6b0ab1..5c12b979a618 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -354,19 +354,15 @@ static void __init sparse_init_nid(int nid, =
unsigned long pnum_begin,
>>    unsigned long map_count)
>> {
>> 	unsigned long pnum;
>> - 	struct page *map;
>> - 	struct mem_section *ms;
>> -
>> - 	if (sparse_usage_init(nid, map_count)) {
>> - 		pr_err("%s: node[%d] usemap allocation failed", =
__func__, nid);
>> - 		goto failed;
>> - 	}
>>=20
>> + 	if (sparse_usage_init(nid, map_count))
>> + 		panic("The node[%d] usemap allocation failed\n", nid);
>=20
> Please consider using memblock_alloc_or_panic() in =
sparse_usage_init(), it
> would simplify the code even more.

Hi Mike,

Yes. I have several more updates for v2. Please hold off on reviewing
the current version to avoid wasting your time; I=E2=80=99ll send the =
new one
over shortly.

Thanks.=

