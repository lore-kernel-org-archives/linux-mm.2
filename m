Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59321CAC5B2
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 08:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78C78E0002; Wed, 24 Sep 2025 04:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A504F8E0001; Wed, 24 Sep 2025 04:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B3F18E0002; Wed, 24 Sep 2025 04:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE598E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:57:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30B7D11A641
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:57:52 +0000 (UTC)
X-FDA: 83923541184.01.83629FB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2B8AA4000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:57:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758704270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cXGV0okpqUEWPwKXCfr2tuHmvSgWqSUR7ptaiibITVY=;
	b=gu6b0xD0UvDAf45GmYF0X8kTPwn4I/i+vx8z3dlb4h2lv4+Gm0wsbDyl+pOAZSffLp+nSv
	fXcsUEQsiCurpGE+O/oGzbW6Ond5nqZR3ZFNN2G3RkSZHIzPPI4O94XCER9PXweexijVw4
	M2CLJ4wL60jgcKwT3I4oEiZgAuo5fmw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758704270; a=rsa-sha256;
	cv=none;
	b=TDK8qKXOldj/MZsbuwgD/CkJVXP85PCrPJP9CGpK0P/yY9g39f2jIL3dE6QKl3la7fr0ST
	PJxZICN3ml3dwA6NhOgjb59XfomZW/NqwHhlMlEw4GXcsggIU2C8Vjee1xMsYnVrDKoAx5
	w0bijE+WaBDOKZcV0ek8Ko2VLowrBwU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC73C106F;
	Wed, 24 Sep 2025 01:57:40 -0700 (PDT)
Received: from [10.164.18.52] (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5FBC53F5A1;
	Wed, 24 Sep 2025 01:57:46 -0700 (PDT)
Message-ID: <a751762a-b5ca-45c4-95c6-a5dc63231c66@arm.com>
Date: Wed, 24 Sep 2025 14:27:43 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm: convert folio_page() back to a macro
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20250923140058.2020023-1-david@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250923140058.2020023-1-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2B8AA4000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: bsqh8ixwk3ok8zbjgtfdxpeukm9ke6ar
X-HE-Tag: 1758704269-810398
X-HE-Meta: U2FsdGVkX19RLaXlKf1ZdBoBRWZ4qn7Wv2RkkpQ1sgO53+msPpNewQHM+79JzgBKOk3Rz1nNAAiVgZvrQK2aHHI9/M4yXsG0x7yN6cArdoEYUSe7tOm8Cjs0O45aJu5W+oCK55ZRYA6dC7TCa9HsviAYqJPN+m/Cxa0RCZhwg2pfJctaCOxMzV/uC1GSHN4bvO8KwDKc9oErSj+FGnupGj1Vsrz0G6Q1y4xI/35co5X/pJkmj5vWRs0mb7gbWhwLv12vZT2l70K8/vZX8vKge4TcTLeuyxa62IbmyQmeUPlqssnvAlCCsaqTtxEihZFnyjaNT6CbH4GbUnpWNdA72nfx5mzNXDXZ+3tCnvtKtoWBG1vpqje6W280+qvkXmEbr6zIzfpYDvBamYcdnleqloTvFpSI8ePIUyZOmBEUXNFmkXpXtKI8cnseNYsoExWUhXc4lu4n3ZVvkX6SUiHWW9+4Hog8Fp9cfkYaMvgT/3afLkwOEpwJp2JPuJOoUU6hUfpaCDn8dNFwRcArNL7aS7w4yNia0+ab/5TYLGMp11JDdTDyPfMTHtxlWRlotyHWhhOUI2iZ6z6PSMmOFI5Vd04h2J3ekGvUtPIX14nPHqYOBU2laVER1/aA3ua82J4P8HkLUdGHDixvHi9JUJlmtEsZs+KisA8vyPkhaABxnulIo0kMvPgWvm2RqZKBBmSNrpiojp73LDRjrpXZpELeHiWTfkWnTW4d0JSr2NburMcsFKriwUR/f05idq6JWAxJws8TqlI/xsTpn0M/y6e2w5DnJjkH/okeUncax0WuvKX0mLwSYdfEQ1GMVqWG7cT8szHbYbSKpYVaJB2k/yJRRuQkSVuSwRREMyHGWWvYej7tXqCeGzIf6F99D0vjHTKOy71jlukCKpMOi3PA6MnIu9QkS09Adqj/vYyJfcss/FQozHKxE6atq4p7t6q+iOmgfjEaUBrEaAZmEWl7FF/
 TPe5Uwok
 0gx43O5cWft4LYyfe8eimiEfXbftOKjpekqiqi6ogQfbnsDf680GtPrJXTfTIJCWEYyYhcozA3ka8gtFa0SU9gwrLEMmfEfa5pqYKGHvhdZG64cUSFdXNM9Mtnug51ICNUwKGpcJs1ldiu4UVJa7a8gBRy8UoeevrSlSDnHyPqjvadIdKL+iiWRHM00V4nsc+/lCYK76Z3LhwQXheh/kkVJfs1r7RfCPSdMkMYo7UfJrdplySFPQ6Cfn0HpYwgKbL6FGHHWzU3Ynp8IP0wgTQigS7rrMMz23+hP3WMP6+CHIzv1nGSYa7oDbngTl98OEh8NAbHikyv+45oJhGFX61fRLU+rTzwEKGHoB/KIFPNa+xzijAYKxaSdd3AtyhRJQd1Ob96PLMQFtnBlBcnpzolSG+YWtqjX+UGkwQGjcSldpNF+4yQWIhYRYYj0xU6dTqh7OQ250iFiMir17I2lg1EJxXpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 23/09/25 7:30 pm, David Hildenbrand wrote:
> In commit 73b3294b1152 ("mm: simplify folio_page() and folio_page_idx()")
> we converted folio_page() into a static inline function. However
> briefly afterwards in commit a847b17009ec ("mm: constify highmem related
> functions for improved const-correctness") we had to add some nasty
> const-away casting to make the compiler happy when checking const
> correctness.
>
> So let's just convert it back to a simple macro so the compiler can
> check const correctness properly. There is the alternative of
> using a _Generic() similar to page_folio(), but there is not a lot of
> benefit compared to just using a simple macro.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


