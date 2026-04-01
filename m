Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11E5AD3514A
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 07:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51D276B0005; Wed,  1 Apr 2026 03:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F47D6B0088; Wed,  1 Apr 2026 03:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431986B0089; Wed,  1 Apr 2026 03:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 325326B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:24:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 923CA59FC9
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:24:48 +0000 (UTC)
X-FDA: 84609149856.01.C075EB5
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id B988540009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:24:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nOp9qoi3;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775028285; a=rsa-sha256;
	cv=none;
	b=LMu2MbDLiQ3R0G3j+s/58TOPiDE3LT37/dgjzJZeKlb8WKoO9jz0BsGOnoJLFyxNbGUvRR
	qbyBszXtjVHwBMC9UM9WjHQMW3DNmnAkaf3GRNYb1cMS/Z3hkoNGEvpBra8eYgVc7mwn4c
	N1G2rYt3554JjqL9ZkRYCQZSg4YicZY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775028285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBUz8w2UE+AbwbR7JZXLDoWhwvffeOU6nnCILyxmmkc=;
	b=zaa5mnVNzECnid2vqjpFBpk/HGavBSpnpgANcwCIg7NKw8hXeIGbnnMoUAva7yZCtsSbpv
	DEtelYhREXwwqguHYkH6yyVsqAid2BnVlS1t+G4JrLql8fTsYumDDf9CLN1qfTgalYRWcS
	E5y1QAs3j/OsHfe/Et4tocJfcd18tQU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nOp9qoi3;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775028278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jBUz8w2UE+AbwbR7JZXLDoWhwvffeOU6nnCILyxmmkc=;
	b=nOp9qoi3K2/azDm9AMPdcYjpHKIIft6n5Ke/8NJLYkWH0ZPwI73cpUqF37jSw2FdOscju0
	iVUuSr5IoJMMCijdyebScM7xG/uyqWVf5G8s1WW10WI1QqchBGjYmb82KoCQMRclCIWefy
	WGUrzV6w4EDIz9mQ3MOnMUVQl0RVOQ0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH] mm/sparse: fix BUILD_BUG_ON check for section map
 alignment
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <9fddd112-e304-4ce1-b3f0-a4b133fcb281@kernel.org>
Date: Wed, 1 Apr 2026 15:23:59 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Petr Tesarik <ptesarik@suse.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EAD7BE29-7136-4A20-9CF8-1198EFB8C87D@linux.dev>
References: <20260331113023.2068075-1-songmuchun@bytedance.com>
 <32789381-f860-4b60-a1e1-4c97f6ed08b1@kernel.org>
 <7C90E910-D229-4F60-A62D-E893A89D58F2@linux.dev>
 <1742503A-F912-4AB6-AAF6-6CDB06829024@linux.dev>
 <9fddd112-e304-4ce1-b3f0-a4b133fcb281@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B988540009
X-Stat-Signature: p6utgwobcsr8ryh4wrgbddyfgpn1ynfz
X-HE-Tag: 1775028283-492367
X-HE-Meta: U2FsdGVkX1+MpOV9IW4ydDdm6QlQIM/ETuAy2cS5xYRJ0TZFyzk4VPnPhBrlrsB8LrOJXN5F3Cm5vEAskgTMZ06pgE380Gy1wGbvIE7TNFWiTgQpyW0hXhTmK+qvSDgQbNYYD67Pxu7NKIfTHbGw8nkUv6/92A9nv4AXYQR/tMnPJllZcRF8TsYLrbWlhWoeV6ZWXZCfU9JOAQdZDD6cpbj5gqLm4GsrG8xYlcaINPWWeIiRHz2DYM9cHiS4XpDL6tU55d2NOmL6me0Ds8XzceCrQTog6gfElWW5tXXFLKbFkEaF6eYB3BHrU2LClN3wvADQrab1CY0bC4QTAhtwlrQp/6QLCAbQ274ly3lJtoQTTfwbpkgYWuinezTQdjjWdM+EDinjdQWb5CUxZ7cTPXYwdbnRA/5Vfe15eCEq8rLvhC/DZJ2N+pELO7rS//xJ8ShGVPMA+x7pgcQU6VZJW9XJVaCOj9jTs5MXFPBLVsyIR6hZ4V2y2wX8QiuGWdgBFRVz8n+oDi355T6XHhv8LwKJAoh/U778KHHDjmX53oeoMY+yOzK3MSvihLcVVjTSaBYmg8Wwla+bjbGO3aMfwGEOBzvgj1adcUesG1kMO1mGuKRMRZUCVtxwzunXxNlCnIhJiu7c1tXF6jyjBuh+ggoWl5R38q9g7TPSF5UTd9rulS4dOkfJd3FAvDovqNyScMCW0dhRZvz+PSv/XH/ikWou46oyk5+fMbQ3jQE9zqPK+gFB3ZcBEh61RIyrWTf87rZhdyzi70kDReIsssdsPNWmk1XmF3paBQoWQWDrQe+r9Cxv3+mjrg12k3b/fzjdEE9Vp6C7qVRG823v6VDT42CWXNWRv0yKIL4c/FFvAN+SFvXcRXODz0IYil3DoSFYB/asmj33CHIQFaCwlBAkd8xQzkO/J4L9DQnJxYJWXPGq1NVktpxFgVg01mLTzZBf7XswJeF41rv0011WF1e
 dE+y+KvP
 t9l8Zw8IExQiROOMz43fwMY/FIwQCMpSaJ3K9pTdjN/9UwnGirG6yL6Vxxc7VTJUX5glKwKAPrnYF2a7VWTjLQfIFvzw4QJBC1b9iKF6J4l4/gq4nWa9uPJ0UkUR22u63D32OCqsrmJYZLwhhqFim+GN2gQgug4a+WlMMCNHWCB8NueD8xcY8J8VtOycObxc6rDvAAXb8B1zV7Qa1zTfEDORf+kZ4zQOoTiaCTT0MLBIykflSQjeHTguYkU3tsop2yNJJrceNtRwWYGUN00NlQ84u8jpDbHP2gBupQINNeHF9R19z6lRppgxTyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 1, 2026, at 15:08, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/1/26 06:01, Muchun Song wrote:
>>=20
>>=20
>>> On Apr 1, 2026, at 10:57, Muchun Song <muchun.song@linux.dev> wrote:
>>>=20
>>>=20
>>>=20
>>>>=20
>>>>=20
>>>> If that would trigger, wouldn't the memmap of a memory section be
>>>> smaller than a single page?
>>>=20
>>> I don't think a memory section can be smaller than a page, because
>>> PFN_SECTION_SHIFT is defined as follows:
>>>=20
>>> #define PFN_SECTION_SHIFT (SECTION_SIZE_BITS - PAGE_SHIFT)
>>>=20
>>> Therefore, PFN_SECTION_SHIFT must be greater than PAGE_SHIFT. On =
powerpc,
>>> PFN_SECTION_SHIFT is 6, PAGE_SHIFT is 18 (the worst combination).
>>>=20
>>> Sorry, but I didn't understand what your concern is. Could you =
elaborate
>>> a bit more?
>>=20
>> Sorry, I misread it earlier =E2=80=94 I thought it was about the =
memory
>> section size, but it's actually about the memmap size. Let me respond
>> again to your question. On the powerpc architecture, when =
PFN_SECTION_SHIFT
>> is 6 and PAGE_SHIFT is 18, it does seem that the memmap of a memory
>> section would be smaller than a single page.
>=20
> Right, and I am saying we don't care about that and do not support it.
>=20
> For example, most vmemmap code I am aware of relies on a single =
section
> covering full pages.
>=20
> So I don't think this patch here adds any value, except faking that we
> might be supporting something we don't?

Got it.

My original motivation was simply that when I read this part of the =
code,
the comment felt a bit off to me, so I just fixed it casually. But if it
ends up creating the impression that "we might be supporting something
we don't," as you said, then I'm fine with dropping this patch.

Thanks.

>=20
> --=20
> Cheers,
>=20
> David


