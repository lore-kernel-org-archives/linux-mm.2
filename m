Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 267B7CA5FAC
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 16:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1336B045F; Tue, 20 Jan 2026 11:38:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F396B0460; Tue, 20 Jan 2026 11:38:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78AD76B0461; Tue, 20 Jan 2026 11:38:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 67BC86B045F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:38:14 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 124531A0627
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:38:14 +0000 (UTC)
X-FDA: 84352899708.24.1DFBC2A
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id 707CF18000C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:38:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=PBWERaFQ;
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768927092; a=rsa-sha256;
	cv=none;
	b=X/gpYc3Xq7gkyDxyW20wLrKmGoWkYWrz2tD3vjWLdybtShT7nq9KlFR7FI1U8WjY9bgeBX
	q3EsOkv0akoCSjBqAk0M8ynEovKjuazmEst7GT9hOoygF7MZHya+9nfqzSUS+Li4gmj7eI
	w/Ym5p4ZC/lvZUEdTO5OcBY6PKHVBac=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=PBWERaFQ;
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768927092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uG4dIlLRpoYNu59KzrWbVXbz+28v2pwQWXocJCHxcGU=;
	b=phd+KbiT8dP5aTs0m+SqtirgA/Hq3njT7y5ikgDXvfnvWVTFfAwr3RtDTlJIs12ZJP9YVL
	58b4v8hba0zV/onZiImaN6WuuXdifoR3v/FTGf3+lGMtaCw1Rkfp/cfL/zruCy4MeTGO4L
	cl7vKXh2IHGWbmmmXIpki12fHS81kBU=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4727940E016A;
	Tue, 20 Jan 2026 16:38:07 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 36TSnPP8K0ms; Tue, 20 Jan 2026 16:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1768927082; bh=uG4dIlLRpoYNu59KzrWbVXbz+28v2pwQWXocJCHxcGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PBWERaFQMr6cKuGty4zYXIhhxjMKDnwQddtlF/wpLPFF5vdC++MNsspxzFlz4m6YH
	 RY2nwPq8I3sF0i+ZYnluJqfZ6wCdAKzS7sbQWmzwVq/x9u43sLF+i77xZGgGdHpxm6
	 Z68weMpkA/aHzCJ+3NyUpgdytUceiAZ0Z73ZMqppLBQUIxteeM6UNcnTyaUUum+QvZ
	 KZjj5CJo1vQSLD9xMSnfKHVWQu34UJeEet/Jd2cPN1gNOcTtBowAtXsJ4gobG+xKz0
	 m2/7zT/8b6UFIoky/76IgVQRPh7YBprxNgn/Psl1OjGIavERK8ZaZ5ZZxBJQo6uo6A
	 SwWZOp2oS1kDWjBZyAFapbwrQk2vRhIvrypLQ3HKexV2+bP2zY3vrudJuJyBf2RrhX
	 HhSQvf8gn/2O0hjAyQvEV0HC9pTPAJFyciq2bCG4u2WjXhoC6f+xXKUKqB1E8bqoDk
	 Chvr2sltLOME0au65KEHMUqsxfpX6BZmBP2ElIpUFZlCwfRyaLZDxbi5Mfzg1/u3Ty
	 jYIyRQGzF7mgy0BfWqGqfaU+OFtazvYrCf5R24zjYBUWPKA1V/5rGtFoZKqTtlTFoU
	 GIWLQxIVfhiuB331pN6fONH5AE+k8HWx7zm8fyM38sky/kKjTvV0H9wKIpZsEck/H9
	 tbwdUVU2DCQuISPjw/tCubFY=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 8019740E0194;
	Tue, 20 Jan 2026 16:37:34 +0000 (UTC)
Date: Tue, 20 Jan 2026 17:37:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Andy Lutomirski <luto@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, peterz@infradead.org,
	dave.hansen@linux.intel.com, mingo@redhat.com, tglx@linutronix.de,
	akpm@linux-foundation.org, david@redhat.com, derkling@google.com,
	junaids@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, reijiw@google.com, rientjes@google.com,
	rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [PATCH 05/21] x86/mm/pat: mirror direct map changes to ASI
Message-ID: <20260120163728.GDaW-vSLGY1P_E0DqS@fat_crate.local>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-5-2d861768041f@google.com>
 <08338619-6aa1-4905-bdf8-bf1a90857307@intel.com>
 <DD7WQ97R8OG6.1CA5E2FU5ISMZ@google.com>
 <19e5012a-3c58-4696-9e4e-39e2b7d2b5af@intel.com>
 <DD80374YZEWM.1L31D2VUKK80C@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DD80374YZEWM.1L31D2VUKK80C@google.com>
X-Stat-Signature: gqq4ockhqxi443uaaa88r3gjhm6ch97z
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 707CF18000C
X-Rspam-User: 
X-HE-Tag: 1768927091-978413
X-HE-Meta: U2FsdGVkX1/8RsJub6aGc+0i1JJOcwSfDHfqm6Xb/bJiva7fCX91PYBcGvVj8vDVdxGObyFeEvKDG/6ylldtT+jM/r9Q1ZVzd1Ojip4EWYLK4f59vGiYDeSYelQpsOSgNP4ANFEkxGqIyPJl4Sdi/s5JNdj9KxFMd0ecdjvKVDCuATqDp7Z/vGNKm++ZGzNFOkoHp5EsPP6LDOYzpterQKA1OEGBGxUPdX86yRG1mIbZyYq8El2Fl2nfEWmbqFA30LYQjWnsH38X4uefYvb0qC+cum57cTqqdyXWy1woA5I/04WBbwiSlHadpHa7ID2mevpIjcb+No1r+BNamUzreZeV3XZI24H8kC6bzKw6CRoxVEQhOEkGhjfTJ7UwwPAg92wG7Z7GAdZQKWKVTWodvIWa9jsdsw0RsNBYQwptqOCTDmTlLZ5o9jD0AXCO+kvk/EZi524oz5Yj2w/DM8XJD/AZPe+JBwIt4la+2CIolfzsqQtVkXNT5F4Ia4QIBqkp1AuTUgdrJmNL8HEXPnAhGm86K4yjjrmqsfqnr6FiWxtC6ByhzGLATBCXDRe9M70bZW2hv0FOKFWGcnY3P5rOLrlF4yKoEpa5o5tXYDlkjr5W3q4TSRkfn8NcAesIaQh3VQWJCCyd1sbrtM6AKLQQBwee4/VhTNEXVpGIMTQCejVjUHGSUOK8+JyDsWCu4dLFbpsM4MJASdZijYm2KJx6Hmwfn2Mv1XBO6t1gdsDgh8X/q0yzCAXBx3LW288BNvh56i0hGTgfr6tJxsr8zw24sNFlUl5eyoUGj08dJfrg0jZArJt7Cb8StOEDfVyQ0gzZvCWxQ2xeD8fRW896aOdbEcv10F01pzL0t68UFTYfMAAxNCeRX6GY3HIUskAOeauk9RdtTdJynX7RwlN1jQ9K+B9hLJibRye7HtkBR2fni7uS7OZmAhSRYmz5DLsv3OOhBm/KQtEeKhViCSNZUwd
 JlGLfd6U
 xf9VJkUb+jF20iSLEIF+bKaXG7WhgqrC9BZ1ISPlEdCcwIFXp86p6zR9pWbGj2EMwMW2UuahhKMn5+TUOlvGYU2k9PzdbvDH1Xq57OSqbqQqJ2gWBoNXeLKYfwtZ+Vf5a8vqNKYBfvxpNeYF9gQO0I3IcfBs9ndkbJtDbVoDnkVotMxdo8Deqf076gCzP6JlmQAdaZdTjZmFHM9cEoPcDXnAFCf0PWIBAxz858ENplMi1E/2UyfXQrsz0rkC/mESuG1+V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 05:08:59PM +0000, Brendan Jackman wrote:
> OK, then it probably just sounds wrong to me because I'm steeped in the
> current jargon. For v2 I'll try just dropping "[un]restricted".

So AFAIU, we have two address spaces - the full one - which has *everything*
mapped in and the limited one, with things removed from it. Right?

So calling the unrestricted "the full address space" makes sense to me. I.e.,
it has *everything* in it.

And then there's the subset of the full address space which has holes in it.
Looking at Merriam Webster, it suggests those antonyms to "complete":

partial, incomplete, reduced, abbreviated, diminished.

Yahaa, they all make sense.

"partial address space" sounds good to me. "Reduced" even better. So having
the full and the reduced address space would make the nomenclature very easy,
IMO. 

Thoughts?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

