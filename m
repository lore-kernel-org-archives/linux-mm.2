Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95392C9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 04:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504C66B0088; Mon, 28 Sep 2026 00:26:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5946B008A; Mon, 28 Sep 2026 00:26:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A47D6B008C; Mon, 28 Sep 2026 00:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06E5C6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 00:26:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6386D140B0B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:26:22 +0000 (UTC)
X-FDA: 85261884204.09.46E5EF8
Received: from mta1.migadu.com (out-203.mta1.migadu.com [95.215.58.203])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2FF3BA0004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:26:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S8uNetnj;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.203 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790569580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lvrrRB8+u1GpJmkKNNkjZdTcO/STjIHCexl1gUK1au0=;
	b=QoNF1rnFeM9VvlZVU0m9XOKRxOOcLs1YGwzZdEr7zeKR33hRWalgZi7IqQ4Pm+TGtABOz6
	K5YQdIQVxvPmy3lA9yamBlGG9YDqkft27Lw93UDhiQZm/r8Oy3IU/Jz5dBcx9hHfCyOWEm
	bGQ9UNxIIZLrmkhpSCWYZwMqPSLg6sc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S8uNetnj;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.203 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790569580;
	b=LMqmtDq1HRxXLlHwLNIfdDEKAfvU73Pxe/ywi0S+iFGtno8DamdoUrRJq3gjkRPgErZHpk
	xNJvkUG+IEmE9POcTfh34u+elluN5gF4zZqwDL2TvQ0ZGgFbROXsgy7pjixjEJhxcRMRca
	zqXVjP8pVfrtaf1yiHAqeD2QRLZWYKw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Glpk8JbMYBC+fNyg6t+G4JCTtagtnxJN0ZLKBOnTQTs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790569578; v=1; x=1791174378;
 b=S8uNetnjaT95Te3/CadF+V8u9Xec9I4jrluUa+Lx4fCtP0XIsZ0PcTQVycE5n9LQNZfJI8KL
 KeUa75lfmzj1/lrB/hPDZ9saQITMgLzpb+lgh7lazP1DkkO0W+iMoNj0CkkNWmDUCSMw9agzt4z
 w7v7g6CU4xq9hO4mNAa4UyWw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 061b4c85c7534b56;
	Mon, 28 Sep 2026 04:26:18 +0000
X-Mizu-Trace-ID: 061b4c85c7534b56
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v5 00/12] mm: Switch device DAX to section-based vmemmap
 optimization
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260927125452.0c1ec382905482841a4faef7@linux-foundation.org>
Date: Mon, 28 Sep 2026 12:25:58 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>,
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
Message-Id: <0E16642B-8180-4047-B846-40E3CC52E7D8@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260926225105.a56f29d76b2f496c8dc2dac0@linux-foundation.org>
 <FB00943F-8DB1-4BEE-BF37-701785DE2DDE@linux.dev>
 <20260927125452.0c1ec382905482841a4faef7@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Stat-Signature: kg8qsu177zfjuyuxok5w33f9zb7uys39
X-Rspamd-Queue-Id: 2FF3BA0004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790569579-621910
X-HE-Meta: U2FsdGVkX19Eay5OOEcyYcMhek4OgxKxRSwSnDnTUbBw1ZbStnq6AwoMeU+yERc8eSsPMov+jGpcP8rr6li1toPWXgmRD+4m2tgaOrx0JGRGYWtX8Ay58x1wzPh9mlaZZ0X8Lhzkhkkxxq03X09som1kW122vcENhRoB9xzRvO3EEXJtspoYTQPcOhN8jn2ZhNcG7kprTuHfKUhVKMYRlpbMq0wM1HKfzRm1kAeS3qbm0ceSdeMxPDni1o2cGKONfYD86momlnbpdMMmDrSR1/6u52JrHtKAbIrXHajwbRR4X9TQeU8PzTia+zR/bOozKp8ORtqVUdlmWYqf0omIR+/JAXWsiAZDsnO9mpVrahXV8NtAcsD/ycKxwSh/RwhZ3WDI4Ffe0fK5d7Kt04Tu2QecfORyFujv78JNe0a94Dfe9Fosofx4sKWs+Ow/swSHe+6yh4sUWoP/y2An/BovjdACT5La2RITqxc8hVN1u683wKcjbAzKAFxsF3H9GOgSuwtQtYelO7X9Ov2B7Douv5VeH6l55TA1uuWmrrU3LcuzBDYwfASQPGWUDjyWt5zjye3JYmb85xAkjFMJNKBgfBIrET0yKYJlqYcvgPDjSOfdnAEVcymVZmkE1ulRY1q3VLBOfihhEw0MVv4uE1MroYgc11amg7oZjDOgkNzA6Dg1T8ua3S1f5i/Cty0We/iInso8M80qcVZjcU94zHKAavNT/1HZXnmUGdRo3oZb/nmSSY29NtEHM/4b/iw4Yp9hqd9sRKtZgLFSF/TYSXeXVUWFJRs5CG/gDr3E1pJgJYNy3KIqy+E89N5Xk1DHIJwehTz73QMUe5qOHf+soQ4Txq1rR1ZZVyviRKs6jiKkoiPEGrnj0sVyPaUhFIiFdToKE/Blg8p7t/9hA8Ghr8OnuQ4J2r9KZi6WIg7M/BbZjUqP1g2bq1U3SN/kU25YYCoXziuK8LbeDahIeWxh8Zr
 wCPHSdFd
 eIySinWEl7bCmYRAhNYQ9ExmhuHOkMMI9feIlLrc0t8/pWCDDgG6p8JKpiCEJDeQx0q0SFc7wWDcHuoAVImw2PwCpN7jQAhHGANedb8sw5GH/2r5vDV4ETC89p88FVHMVzXrwIQz8SgPBE5N1olMQiqZXd9vwZtuapRCBF1fLJ29R+FYzRzA+7KLbkfLhwAAhtw+ObD/Qzyjm98nzuayQac3OJMi2eVMCSo91gfZniH1Z9zncepsfmCnzgjMDNhxYDNfr6/NSt/bg0wBWDd7cRWipfIlmR0j9EPYACOvXa3rsd1hKC7ean5pqcN8fHsQ95YI5YiPV40LCmnl+H6JFTwKFKfrFvn5vV1kJUaY1AgkAGDm2KRb1hb988xpfiHCnU7MaXiStxzB9tSLNYXlnmZfngg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 28, 2026, at 03:54, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Sun, 27 Sep 2026 18:51:15 +0800 Muchun Song <muchun.song@linux.dev> =
wrote:
>=20
>>=20
>>=20
>>> On Sep 27, 2026, at 13:51, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>>>=20
>>> On Sun, 27 Sep 2026 10:54:29 +0800 Muchun Song =
<songmuchun@bytedance.com> wrote:
>>>=20
>>>> After the HugeTLB conversion, optimized vmemmap state is described =
by
>>>> the memory section and the sparse-vmemmap population path can =
allocate or
>>>> reuse shared tail vmemmap pages based on that metadata. Device DAX =
still
>>>> uses the older DAX-specific population model, including a separate =
tail
>>>> vmemmap page reservation and architecture-specific logic to locate =
or
>>>> populate reusable tail pages.
>>>>=20
>>>> This series makes device DAX use the same section-based model. =
Device DAX
>>>> records the compound page order from pgmap->vmemmap_shift in =
section
>>>> metadata before vmemmap population, uses the common per-zone shared =
tail
>>>> vmemmap page, and drops the extra reserved tail page. The powerpc =
radix
>>>> path is updated to use the same shared tail-page helper, so the =
generic
>>>> and powerpc DAX paths follow the same reservation model.
>>>=20
>>> Thanks, I've updated mm-unstable to this version.
>>=20
>> Thanks.
>>=20
>>>=20
>>> Sashiko asked a thing:
>>> =
https://sashiko.dev/#/patchset/20260927025441.741633-1-songmuchun@bytedanc=
e.com
>>=20
>> Sashiko said page->refcount can overflow by incrementing it over 2.14 =
billion
>> times when mapping more than **524 TB** of DEV-DAX memory on a single =
NUMA
>> node, where the pages share the same node, order, and zone.
>>=20
>> I am not aware of any practical hardware configuration approaching =
this
>> topology today.
>>=20
>> Handling that theoretical limit would add non-trivial lifetime or
>> architecture-specific teardown complexity. Without a concrete =
hardware
>> requirement, I prefer not to over-engineer the current series. We can =
revisit
>> it when such a system or use case becomes realistic.
>=20
> OK.  Presumably it would be cheap to add a check for this craziness =
and
> return ENOSOMETHING?


Sounds right =E2=80=94 I'll send a follow-up fixup patch shortly.

Muchun,
Thanks.


