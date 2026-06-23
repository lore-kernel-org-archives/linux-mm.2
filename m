Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 317BACD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F2236B0088; Tue, 23 Jun 2026 05:19:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A32C6B008A; Tue, 23 Jun 2026 05:19:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EADED6B008C; Tue, 23 Jun 2026 05:19:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C647C6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:19:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E401A0419
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:19:46 +0000 (UTC)
X-FDA: 84910629972.02.9423EB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4716618000C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:19:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nFVtQfvT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782206384;
	b=v557bp8CJ9cZVyYwNLZ9cRCcMOzVdN+aPiMCz26bN+FU+KwAw8DbSFe0Czl/ZleffoI8Cd
	rwh/XzlAx8hNHZPJ4GqXL48HvBr0xNvRkZ+DyM8SweMtPIuPQZs21vAvtKFSdZsFeAoBE2
	lBTrIfYLXm6GMTu7cZkujXbMztE3eG0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782206384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7/ZDlIzWUndvoYE+PX4E3AjeijBVQXYalQoydvzOzPI=;
	b=pPTslbtl0uc/vWyx6D1OLTyyNUek4a0QpR6kdn2LRTRZh9qWe/MqTHq46xbEj2YEcfmFRv
	LjCx+LcgZsdnk9Frnq/Pa+m3KlxTFFNfa0Jsdjv09SLGqJZU5TTwT/iQ6hSsmsJhJn51p6
	v+3d6LLriGA10YpXiVKm48dgZwgKtQE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nFVtQfvT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D8084047A;
	Tue, 23 Jun 2026 09:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B209F1F000E9;
	Tue, 23 Jun 2026 09:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782206383;
	bh=7/ZDlIzWUndvoYE+PX4E3AjeijBVQXYalQoydvzOzPI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nFVtQfvT9AfvbFLnnzylgEGUQnr6IMpTPOSnvSKsEpUQRT3kmxRC/9cIH8RcoicFk
	 FFqU0TxSxGw0AC734lZRcpPIckloggVgYsorxJRrlsS2F+yYMN+QASLxuKtyIpQZFJ
	 ayUlZMOQRYP1y8NlaEymDArMwbwC17WLg8f489AltFPVDiIMel21JzVgzqjP2uFfIA
	 Px5SHNV/GEBqQzro9+d4LuGKuH18tWjK2s6Q6lGt6BpxD7dYIewlVNXN0LVmoNbdKe
	 SU2nDDxT77JLiEg4l94NmZFddXYXm0Ks1tJtM96EOgZPtbo0ge5zH2lSnraykHTUTg
	 sxVHwOIeo/7+A==
Message-ID: <0b7df58d-c403-4bab-b703-1e40e64a2eee@kernel.org>
Date: Tue, 23 Jun 2026 11:19:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: David Laight <david.laight.linux@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 David Stevens <stevensd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Linus Walleij <linus.walleij@linaro.org>, Will Deacon
 <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Matthew Wilcox <willy@infradead.org>
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
 <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13>
 <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
 <87qzm2b39k.ffs@fw13>
 <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
 <87mrwon5uw.ffs@fw13>
 <CAAa6QmSeq8bbckyJk_5HFagsHfS5SXbG4y6Y-Py66eYLgvjcUg@mail.gmail.com>
 <d4926c7a-32e4-498d-be6c-ab2969c8f672@kernel.org>
 <20260623101018.789a4094@pumpkin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260623101018.789a4094@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4716618000C
X-Rspam-User: 
X-Stat-Signature: ybi3sdmsi9mmjjyzjbr9kxxsdeo86s47
X-HE-Tag: 1782206384-129570
X-HE-Meta: U2FsdGVkX1/g93YDGjXwQ+hwK9/uMWA+ReRsuNub/Nw+Sr0NFB3ltUhSO6zmf+V45JbaDhDyjgD7fBqqkbBAUWUGe2e99S9cswUPRny9SmbLcMTXAKgysD5RE1JW8R2D1HIKyWvhPOUD4EQr2j8se0kGybRvsA4z2G31WCTa3d5OttNqVkIR/cUNdLCpch7f9sX6SQkN3HVNPmGL6id08BbaNiKC+HDwG5RJATUl/YQZXhK+4dik6V6dqfJZBFZ8E/9JAemhBfLISqDLV07axhN1xqJ+YtDMJFuCZd8woA1krLivOjFYoT9O659tSgxQmTS6H9OnRWLZswdAW6Dcv4UZXE95+UpeB7i5ePjdfI+NbNgFJQrrPGe+c3wYs+SJG1lohUZaA0Tm8YWOT6N7TyxpwPhyyyTBraEi9hj5P2pytxWupJiaresB9W3BOlTt1Fr5cpYYNb2xbxt66rA8nDCHzOZOdRMKcWsvt4nP5FlpQFN6GcYZQzB9dA/x8s6Exk/ZU0L6J5j3pRgl+Fba4FrL5ksIDyLSlH1VJsK+SoczNsB1hZPve3A1Xn8F3SBSxGDzvpEwl7fc7XWzZ69ktUDJ7aUvbJwOpCmKmHHKlNxqeiwX8G+qPGY1gzUYXaVdBCyZ7n39h+ig4keq6MCAN0ocjiiBU2YaOWQlcFtkATohPu3lPVdsJyiz5hm8po/21+sjf6zRULBlVx7r4eDOWXK+y8++Vyf4e4a5YFzxlZlHLu8KtM4Sk5bLcBtRclROQHjgsAB6LAZvzqFJPjpUqoCKEHYMfOUZFA2NhrlNAKWrXNSliNdoyJrdOrll93MZAqEFr2Is/l9xGt3Aw0Hhpq1lRwJVhw9gUIdlq7pPCBYbZ6fbaDpvUCfqK8scNDN5GRXeNeAIymjfOsNMCx0OHCrrFbatngbPT+pMoMAf5sTYo9BfWJ7s5/XNSmmUZuEg4oh/Htm0aRwroU+Oif8
 yPATA8lk
 bieyLEq6q9o6dwvDY/vRCkhXnqjSFhQB9Hst5wdAqAJmp9LpYr2gK9zvLJdaPyHHFDD490G4FRl4T0xQU7I1aCPqLxAHN0WHHdbwUvyR3fOnHn5TFqWp5O3VLqJQRuE/3qUbnlZRq4tk5X2PxHx8X5pmXJfREMTNzV0kNvMxBlG1UuwbTKi4uAwx4mJFgMx5QoaH4z5X+4ZkQhYU2HGT6C2wTsTdvNumTQqcDug4lxgIvps8L/qsXxym/+y+yJTRxVfUbdWhId/EDnGiuRYB2z+qQLQ/uzoea1ajm5eFRdXLVPkCGkVHIbO4Onc39SBX2FXKaekuJOACBSISdsCGhbQBKa1GTg/k1m0OzajezK7h2YVk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/26 11:10, David Laight wrote:
> On Tue, 23 Jun 2026 09:50:00 +0200
> "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
> ...
>> There was some (hallway?) talk at LSF/MM about possibly removing direct reclaim,
>> similar to how other operating systems handle it. Now, I don't know how feasible
>> it is (I guess devil is in the detail ;) ), or any details how that would work,
>> but direct reclaim was repeatedly called out as one of the main reasons we can
>> get huge stacks.
>>
>> So I guess direct reclaim (incl. compaction) is one of the main problematic
>> pieces. Are we aware of other scenarios where we (easily) trigger consumption of
>> larger stacks?
> 
> I suspect some printk in error paths could get problematic.
> Especially if they involve direct writes to a non-trivial console
> (does that happen any more??).

Good question!

> How much stack does dump_stack() need?
> 
>> Wild idea: as a first step to test the waters, use smaller stacks on selected
>> kernel threads and disallow direct reclaim/compaction if the stack for the
>> thread is small?
> 
> Or if there isn't much stack space left?
> 
> Isn't reclaim one of the places that is actually likely to exceed the stack
> limit because it is unusual and won't be exercised at most of the kmalloc()
> call sites?
> One you get to the slow bits (especially ones that do IO) it is unlikely
> that a context-switch to a special worker thread will make much difference.
> (You might need to boost the thread priority based on the priority of the
> waiting process.)

I think that was exactly the idea of removing direct reclaim: instead of doing
reclaim yourself, you trigger another (reclaim) thread (like kswapd) and wait
for it to finish.

-- 
Cheers,

David

