Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0831C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A826B00E1; Wed, 15 Jul 2026 09:47:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDACD6B00E3; Wed, 15 Jul 2026 09:47:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18416B00E4; Wed, 15 Jul 2026 09:47:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFD506B00E1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:47:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AABDE1A0146
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:22:39 +0000 (UTC)
X-FDA: 84990773238.29.0673C7B
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf25.hostedemail.com (Postfix) with ESMTP id 80C57A000C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:22:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u29GFpsZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784114558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xzse005bRK2beF4axCqwSeS3nY/Hievh0FGpo5JbUqE=;
	b=BO0TqMYohwcAZiUwb+lBtUMQ8q0BGTY+0D1qY8brdKzOwKqm3G32WSGytT4BJdipgTmYqO
	AFO8JPAX3gex/o4DsD8rcpvs0nSLAYvgf+Fg7haM5geI1D3TrWBHj8aDMjjBLzI7pFkSj/
	BHd//vAkuJ4dlTse7/ZQfj6JEl8shdU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u29GFpsZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784114558;
	b=2aIDKM3+O43X4gc4iZhsUYkt7et/WPVXB25EYJ6MN7RsFmjfdt/WU2zoNtd/zpDFtfdR++
	MpjVfLO6vbifUxulXGv4MHgaBZqnMcy0dIasZii+cHe4l+gnZfVw2VYRMdDkgLJtiIMfmR
	7GAT7x6ElNwYE1xBP1cbIFIlrP5VpX4=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784114555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xzse005bRK2beF4axCqwSeS3nY/Hievh0FGpo5JbUqE=;
	b=u29GFpsZPTVPLgktNR0g+QLd237hye/AUK+IfIMVJB4Z63V1UVaP983BXy/sk3KjtdfDgq
	SMtP/MHsVGi9w7wkqmd4X0qYqgqnAjm17ma9mJBafVLVCkuy/flWiIx2gRe+MCp6sx6sxK
	8ypyz8fSPE+VJ2wQMO3fAt7UbGRx9kk=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 Jul 2026 11:22:33 +0000
Message-Id: <DJZ3TQV3GPDO.6AN321FGTTX@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Brendan Jackman" <brendan.jackman@linux.dev>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Brendan Jackman"
 <jackmanb@google.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/secretmem: disable under HIGHMEM
References: <20260703-secretmem-highmem-v1-1-30d5ff944664@google.com>
 <20260704192603.40aa80cf9242b77aa75e8d8d@linux-foundation.org>
 <DJQKSKCN9KIB.25WIOU9KF9CNV@linux.dev> <akpBWmnujSnj1ZEE@kernel.org>
 <503aee9e-97fc-4889-a379-3c0a5d140554@kernel.org>
In-Reply-To: <503aee9e-97fc-4889-a379-3c0a5d140554@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 80C57A000C
X-Stat-Signature: yjkogx5hswo1f5gf8mofg9uu4xp1mujw
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784114557-749200
X-HE-Meta: U2FsdGVkX1+2XZNGrR25AioVxlzUtY2lYGoaWI37xdg6cT7ChjMgRpIBBWaGJI/1yir3jJYCo7tM7CrvyA3XKIUxBOm83leFI+CLSpUjDH4R36R3emo9bx37zmy4DlkJdaxXyAta/fqwMRBOJFbIpIQD0DG0quVHrzTg79GvqCOJctaiCoCIIwhWwiB2up3W6X64Gnn1W2QENxnjcf2YDr1DONXh90eQNswx0md5FlisZWx5OtXwVT69Lf37G0BQq7fg4pOyHZr7InY8NVj0/+uvTvRr0cwQJuMMejqQ+/4lElvH+zr4c018rK5/gh4M7yldYaPUJGU7cg5NApyVuszaP68Mu4NEykD6jUxb2m+4D8B4AAoUz3IBUyEf6xxi3UT0NNGEcJVvC3U5n+GlKMB4tpj6LyhFqUyOlLnpfNNvwGaISn2VKCvG8I3Q+Haqt88Ri79+y7spj3AsHf3C4hwZk5ZAcAdLM9S/Tv7xruyQUjp6hRhJvp4vo4hV56LxpIXJskkSaZQ37PNNmZA98Ge9pdbUMvD/KXGGTMO8DGHNnLQ2eR8VvAp0GbhCkiUBDYSmQpt/rp89ccQed+/OoTMmtVDs0eVVh+V/0dOhUtV9HPukjIlaLfRZATk1xx7MFh02f95Vw9gWTjVrev60pVfD8BCxGc5udXbABEc3z5b7yv6pAgLKFcX50QHqYhLk7R4GXMc7M4mxEiYDOOEjttF8nCzlRQVHNhfIUb0GLGhvK77psOFPK6nVET7vCjv3CiZKr9LrHdLrmG6T7Spp8137Y8CtkmcFk2VajXe68xl8VjwUT63tTSEA3ZhXhRRV6A1bBQIrTSf8H90O606S/G0o/I6kyIu7EgQ4UQsZTM8iSGMOzyIsSMi+EaTi21kdNe6rFgi27svx0i9b9JJ4sBBBundh1H0bCWaqLW8eg7TiUTI5sT3PI3ya/fa/1b10izXw5pJ8HkRKEHtRgoi
 12qZSVGl
 a4sk/w1ltFvqW565FqWwGwBNWTrIi61J06yZYJq8iRBlF7fzcjftkLEuP9EHJnRmEX1fpMXZES3H+X+9bvCPuiuhghj+3HpvUIoUvC5DuSZTdw8cn25ryhg/sGHNcIKI20izMmYF8AkMO1yM8qCdufNwsGKYYkftwtwcrMPuPxibdKpd8rRupNHDQYIMzLjPiOrrKIhqIb6BfzAZkC3Z/EtYTDNzyM9z45Bq6U7z530orRt8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jul 6, 2026 at 8:42 AM UTC, David Hildenbrand (Arm) wrote:
> On 7/5/26 13:34, Mike Rapoport wrote:
>> On Sun, Jul 05, 2026 at 10:46:19AM +0000, Brendan Jackman wrote:
>>> On Sun Jul 5, 2026 at 2:26 AM UTC, Andrew Morton wrote:
>>>>
>>>> Well OK, but the secretmem code is still wrong.  The patch protects
>>>> people from hitting the bug but leaves the bug in place.  Surely it wo=
uld be
>>>> better to fix the bug?
>>>
>>> I don't think the code is wrong if highmem is disabled. Certainly
>>> there is an implicit coupling between the .c file and the Kconfig file,
>>> but we could always add a BUILD_BUG_ON(IS_ENABLED(CONFIG_SECRETMEM)) to
>>> the relevant bit of code to make it explicit.
>>>
>>>> Is that as simple as adding the folio_test_highmem() test? =20
>>>
>>> This would fix the WARN+SIGBUS but I don't think it resolves the fact
>>> that this configuration is completely untested - there are likely other
>>> functional bugs? But more importantly, I am not sure if secretmem
>>> actually does its security job if kmap_local_page() isn't a NOP. I
>>> think shipping a "security feature" that doesn't do what it says would
>>> be really terrible. (It might work totally fine, I dunno, but it would
>>> require some research and deep thinking that I don't really want to do
>>> for a configuration with no users).
>>>
>>>> Or switching to GFP_KERNEL? =20
>>>
>>> ... Oh, that's a nice idea though :)
>>=20
>> GFP_USER if anything :)
>
> Right.
>
>>=20
>> But still with kmap() and friends not being an NOP the promise "kernel d=
oes
>> not map this memory" does not hold.
>>=20
>> I think that keeping SECRETMEM and HIGHMEM mutually exclusive is
>> conceptually correct.
>
> We could even limit it to 64BIT ;)

I fear this in limbo, we have quite a wide range of opinions from "fix
the broken configuration" all the way to "disable secretmem completely on
32bit". I'm not passionately committed to any one answer but I do think
we need to pick something.

Mike's position seems to be roughly "in the middle" of the spectrum, and
(conveniently for me) happens to align with what I did in the [PATCH].
So... could we go ahead with this?

