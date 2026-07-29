Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED041C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F33A76B00F8; Wed, 29 Jul 2026 10:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0AFB6B00FC; Wed, 29 Jul 2026 10:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20486B010B; Wed, 29 Jul 2026 10:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC1436B00F8
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:44:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 26FED16066E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:05:51 +0000 (UTC)
X-FDA: 85041534102.12.060611C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6C6B12000F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:05:49 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b48irzvs;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785323149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36vCc8VcM+L87TfsrGnoD5hR3X1siACB/VnlnYWIbd4=;
	b=Z0h6rrxDg28r+0WDaKTnosI1eBkK/6gXxNosvc+IXFrv3BvyqUTwKzyCsQE+jvn+3AsUKM
	JGAyZIvAsZWtY9DnwejW3XteBIAJ+y9pKNWkyHdc6jBYznY9bmXEPa2YDsnfufZfNYoO9p
	zQLGpdtUvvd1M1fl5b53s0gecLOTOMM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b48irzvs;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785323149;
	b=44MRTRMMsGgIb3u/M1f6xSXzjRjhU8YbicG6k7c0OoAQJaXfQkjJFJ4cAB84jA3sPioGI0
	5TdNBm7LJapDkrGKSjBkdXS5rotuszejr0ww0paoidSApFFTaDgvFaRR9AWoBZmkihoBoW
	kFdP+8ggs9x5ra4P9KNDcrBpCoSR7S8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BCDE60A5E;
	Wed, 29 Jul 2026 11:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E6C1F000E9;
	Wed, 29 Jul 2026 11:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785323147;
	bh=36vCc8VcM+L87TfsrGnoD5hR3X1siACB/VnlnYWIbd4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b48irzvsg0Rb9HPmpRz1cRt988CITLctIsdsmAzYoCGHcqqDXZ2gNYuTnHHIrJbj7
	 4H2B2eH12UqMFJgYMLsCy1KZ8q4b7/HtBh+ESujT8zNC3k4hQqfRfj+yc+rkURzE4h
	 70Dn1hj1howXlSwenX2dUF2/DWVG876GsmhZQP8m1Dia942tWYnyC3PKB5EAolTNmB
	 CONyTksT7fwOidO2ekfK6pe1uDUU/xaLuhg3IVs/5z07rdUbVvn8YGTImADEAyTk9V
	 +kH3OunfyfncZZV5MjIcpVdG3+JC+QgBBibA6vztnHMkc1m9JC4YLICz4dpEmla0Jm
	 pExAKbv9xiF0g==
Message-ID: <6db0a8c0-b500-4364-be3d-d3a537c61258@kernel.org>
Date: Wed, 29 Jul 2026 13:05:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/11] mm: distinguish PTE table storage from PTE
 values
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, ryan.roberts@arm.com,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <2c19247e-bee6-45f4-a353-2fcc60db26e6@kernel.org>
 <7813b5fe-e767-442c-a356-afc1a5c567ad-agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7813b5fe-e767-442c-a356-afc1a5c567ad-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C6B12000F
X-Rspamd-Server: rspam01
X-Stat-Signature: erkb65a9fxy9whhotmipaudap6ne5mph
X-HE-Tag: 1785323149-903983
X-HE-Meta: U2FsdGVkX1/r8bW1fEzFvNyKJNGMdDsOswVfPfXSftBm/m06TyWGEVDxhux1yjgMkhTfSu1lFtenVn/KS6Tl+UolGuU8yg/Zuf8c1aIKEJPDBDRygV2SM2+AhMAWhuxMVePr1swn7QymLqpZUJlqy65/xrC1ixU+fVRoHq0gdgxyePS6sMWiY9afyIg4jo5wHjAxaRYqRTMKzCGaRyrfSM+MOOA3s+V0jnKj7plrxyCuDY0Zi2uWbzW7Pxzph66SIXzbT2KVGutRC+A06r6cOpH4p1l0sns/Wxn8k6wGZ53SX36JUSNGIlcLTKFzBxa4b8/OrEE1suqqOOGqAfMTKlc+DVQ+tnN5TyNf64FbmZgqI/7VSBKGFZsPThaVd7Gf7/AWhyFcBpstRbG7vAfRGSIwRUxbXdwJdsuuXNFYA3SCR9HRITx4DGLTNR0u1jAVKSOggbqTijI3/jqn20AXI8TyO74DyZIkc+0RKubSzMkdEJTGEWuiL0jZJnipG3mIHXbG7jVJ2e3EGM5Gj2SWu1X+/hrLYGtdVDCWItlnVyT2NM5n9xBa33Cupt8wfJDLJlrzBJJn6g9A4oiTXPU0sMwvz/E4aoiNQn0GxNCBGOt7EWTshLdzFzYnjSzQE/hh+KMje0o+VBaCzHQvV5xoGtyUklCVpzVGaZQKxlyVCN6+OEgP4ilW1+SDtm7pzegJlKLGOFEmUbpWRmmeQjuZ54cMjiHJpZUSss7w/SfJrF+Ukm7MVhRGbHNjMI/b91E8WZz+RsKSQo0kyHGp9wxC45eR+Fu1zXPOBaKBTs/g/+O2fy7j1/ameQih+X7qoCz8+Foo/q2Vix3FWeY2NsjW/Rf1VYQKx3dcIYwTt5ditk6N2YndGswukmfYQ+wXZz3OhzN4VdS4wYa0k7cgLhuic/CIBbWZe65OLCGMsqUj/qJ0g7p6zYVFYYwd2TddsWbnfgP5qA0X3pFUQaQJ4oV
 zgatMgb/
 8mMb9oJt77+hErBe+M1pmCT51BzDo4SeAQbw1PcNMM88vF9kSSse+CCk50jWMAYhwoy0/Aq7919VzGiGpzZurf5luU8vF4lNhyDCIM9nbkShh9ErfnfuTKbl1IwBAVSajYR9Zu+bn6TFswmXESqFC9n6jrguoa+4C1z5zgrd/UY77NJUoiF+4Z1CEnejyYELsdr1W89w8LgwAeDQpD+uQTk/BHGU8PN1f3JHKxyJBDYqiVdh4CMvPvgm6J/ycoyc1uPr7hUaZWLKnlsWBT0IlaVxQ2elAjSVZ3FRWVDvahQDi//GvEXcWukXj8lzZHQQyFRy0sRI1TThZnFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 12:13, Alexander Gordeev wrote:
> On Tue, Jul 28, 2026 at 09:26:06PM +0200, David Hildenbrand (Arm) wrote:
>>> The generic definition aliases hw_pte_t to pte_t, so this series preserves
>>> the representation and behaviour of every architecture. ptep_get() keeps
>>> its existing READ_ONCE() semantics and converts the stored element through
>>> __pte_from_hw(). An architecture can later define a distinct hw_pte_t and
>>> convert its PTE interfaces to make the distinction compiler-enforced.
>>> Architecture PTE implementations and most architecture code are
>>> deliberately left for those later opt-in conversions.
> ...
>> Do you have a pointer at the arm64 part, so people can get a feeling for how an
>> actual hw_pte_t implementation can look like.
> 
> May be we need the generic hw_pte_t implementation as { pte_t pte; }
> right away?

Indeed, that makes sense. We just need a way for the architecture to opt-in that
it did the conversion.

> 
> Also, can you envision a case when sizeof(pte_t) != sizeof(hw_pte_t)?
> If not, the compile-time check is worth adding.

That wouldn't work as is. We'd have to intercept ptep++ and instead have a
helper to advance the ptep pointer.

One idea for that would be to let the compiler catch that by marking hw_pte_t an
undefined struct (unknown size), such that the compiler would indicate any usage
of ptep++ properly.

That can be done when it would actually required, so as a first step having a
generic hw_pte_t would just work.

-- 
Cheers,

David

