Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C63DF531E3
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 03:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F76E6B0088; Mon, 13 Apr 2026 23:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8BD6B008A; Mon, 13 Apr 2026 23:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE3F6B0092; Mon, 13 Apr 2026 23:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD4A6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 23:00:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BE0A4140383
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:00:49 +0000 (UTC)
X-FDA: 84655659018.30.6FEA8F2
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id ABB48180005
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:00:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iRwDPzSZ;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776135648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4PlymUBRhoew3U1NTZK8jxRqafzc24WW3+boeDt4A/A=;
	b=ZZ6H271u70ZYCaZBKsp/zAkF657hO5pJ6d7ICR4BNLcbB3r+loCPK+7Nj0FK2FQeJJJQhu
	tLLL4WCXmVGfgE/Sh6vhqc9+bPl9Xd3v7OJfj7+/4WaT4tyXWhaiD9eRArj7AS7RnDsJXI
	PNg1HIbnJKmB8Qkrki4L1ZmlQw4w14s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776135648; a=rsa-sha256;
	cv=none;
	b=k7AYKbwURX1pTuMWAmEILjeEFZg348oxOXlMVz2bb+493QclVmX3HrzXVNuKlnGcAUFOIn
	Jt/b1MePtHZ2zMarn79xPezisG7LyAyhIL0RkaVMIR6OCWfxgN/Gfmuv7GA7tyD/UWi+g9
	gPr1vZCNPf95Zo0Jw02FLnVb9VNQFVc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iRwDPzSZ;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776135645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4PlymUBRhoew3U1NTZK8jxRqafzc24WW3+boeDt4A/A=;
	b=iRwDPzSZORBKkVc+qfAjdg/8sbprXX/S91NOZEjG9sY6nLhmM/7OkcH+FVVdFyPabDclFz
	MyQpXLhsvkEGbaqai+jaUp2+HVQNmnygABaq8U07zcHezNt3L9GnLd10HMAFhExFPzc9PE
	rVlGd2hYbvT3N41tMq1mKLtf4kVK3BE=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 07/49] mm/mm_init: use pageblock_migratetype_init_range()
 in deferred_free_pages()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <08a82aa4-f556-4e0f-9e50-b9fe0a5fb4c1@kernel.org>
Date: Tue, 14 Apr 2026 11:00:00 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
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
Message-Id: <3FDA057D-EBFA-4016-8555-E046FA161984@linux.dev>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-8-songmuchun@bytedance.com>
 <08a82aa4-f556-4e0f-9e50-b9fe0a5fb4c1@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: ABB48180005
X-Stat-Signature: ab5mcadkhbmfagga9cexx1ej1rugzg7g
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776135647-862046
X-HE-Meta: U2FsdGVkX1+DoWbC/U8HcV8fn22Jh4kuvnQ+jaL/8h4W2UX/vDSp7FDee1DMaS0biKxORuzn9LswI/xfr/ZBI1zPXJFBU6aqa9OTCAw2DLWKjJfqJOqS7vkmoZTQH8ofuiVth/2fWQPT3f9p12KWY3j1n9Qa0Z7DKlbcI9deLyTrNjJeHM4Sd5/k4xcq893pUbhuCUi9JefdpIzmFj4vl1nQfwkRGvqIF5lT6F4L6+yIiEBngHZuTKeeIgxqJdwBvgyvba1avy1nhx0KDqxEjL319EfoA23g6V9MbepHgYp2wYcYHUPat6Ii0tmh6CteAWovkvMXwDXT/298fRl8iAwGD8p4xgmCmFFYX9Mky9RTGiwt0ljZJEDITeP34kp/8OWq/mg0JQpkHoT4CrcIbORZ897L87QfqMhVgJiBeLNfpL6o435/2KHSixImxQUGVFVXbOGVHST8z+pJEIx+X7gX/0X/4uq9cJ/Sh96P6zKrizLG7R/yWTM/HjuG96KdG35awJSPMWwlH7aUZng7o70KCp5MnkRqQpDUPCzdsT69s7jbOYtkIEHadhw1udcvWbmLZjf39luPSi70Icgyrp222Y6MUnpTCtDPF9CPUHHmyA5eFuKsd2pfKo9mXBaDW7p/qIsFGQAuD8bmSKdDniu5t368rvjVTsfVOQ4LZj1ty2wSmY4G4BCMKSxmMW8O39AAHLRKwcODthv5T0zyB7+DszkIT6twY4jzGzHqvCUhcDxe896HQTLRdu2iCfHOHhcwnYpBFNQjchJ2dw8ANnonX7JYK+HLMmvzs643rLXkpk7eNxI8+LbjesOE6Hx4bbyY2jxVUBXPd2aGEwC3EgsMVwprWV5sZouDBeAcA5uO6c1hHzwEoDvcPt0Dio6WQZRxZ1dT/oiXeExXeXmJlgu7TM1APOHz/D0kGLIXAJBG3QAlG9BfelJ+qtYuOiAUUzmwr7YQ1MgYL41/I9C
 VTh4+fwW
 FXnk8mwjSuQJ2un1VMKmrT7dBWa4HaQyv5kQkGu+tLxvMIsIMbJ1hJaUH66VZ2mTz5ndGg8Eog6nJF9skd05DUEd033l4ZXdwgP/xJvPnQkhq/XzFKAQuakubBZS4hoFW3Y8XhRyTf92u1BRp1CPV4YDYeTKu8V094u/9VYL8qxoedqejNqOZIPMgl5wjOdOzmoKGlqe8eht+EsWNn78YoxIV2dLn7pBr7RELK8AHFtuqNenIjSgWsfMDad0UdXs/qGi1HJq9a8/1/HIBV9bRdw4cYDUY00w2AcBEJQdcBRnaC2lFkZL6LGBLH2ZEzRzuiUmRXtawH4Ek9Fo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 14, 2026, at 02:54, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/5/26 14:51, Muchun Song wrote:
>> Simplify deferred_free_pages by replacing the duplicate loops for
>> initializing pageblock migratetype with a call to
>> pageblock_migratetype_init_range to simplify the code.
>=20
> "Simplify ... to simplify the code."
>=20
> Likely you can drop the last part.

OK. I'll rewrite the message.

>=20
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> mm/mm_init.c | 13 ++++---------
>> 1 file changed, 4 insertions(+), 9 deletions(-)
>>=20
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 4936ca78966c..a92c5053f63d 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -1974,13 +1974,12 @@ static void __init =
deferred_free_pages(unsigned long pfn,
>> if (!nr_pages)
>> return;
>>=20
>> + pageblock_migratetype_init_range(pfn, nr_pages, MIGRATE_MOVABLE);
>=20
>=20
> pageblock_migratetype_init_range() will align the PFN up to the next
> pageblock.

IIUC, pageblock_align(pfn) is to **round up** PFN to the next multiple =
of
pageblock_nr_pages.

>=20
> Are we sure the range we are getting called with is always aligned to
> pageblocks, such that we won't miss to initialize the first pageblock?

That means if pageblock_aligned(pfn) =3D=3D 1, then the result of
pageblock_align(pfn) is the pfn itself.

So there is no problem as you said.

Thanks,
Muchun.

>=20
> --=20
> Cheers,
>=20
> David



