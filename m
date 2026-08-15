Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1A8CC5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 14:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6912E6B07C8; Sat, 15 Aug 2026 10:12:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61ACC6B07C9; Sat, 15 Aug 2026 10:12:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E29D6B07CA; Sat, 15 Aug 2026 10:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29F736B07C8
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:12:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9CF51403E0
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 14:12:14 +0000 (UTC)
X-FDA: 85103693388.01.9DD6F3C
Received: from mta1.migadu.com (out-234.mta1.migadu.com [95.215.58.234])
	by imf16.hostedemail.com (Postfix) with ESMTP id 281E1180003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 14:12:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=apRKgVwn;
	spf=pass (imf16.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.234 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786803132;
	b=DpeTfDCSzoxU68xghpnUQ241SSa3uLO+qXjb6ZohbLJmd5Zk/h58nphGJUNTXa0A13ZVdK
	MJxSAesRnzuVTR7uDRRfux/7nuRntQ34iQTEX31KEkKHwqBpqC6hu+wSoF3LG3gfYSDum3
	h75mJ/1PeDv8RA2Hq3NHLAPgAIC9vl4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=apRKgVwn;
	spf=pass (imf16.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.234 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786803132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2a+7kIox3LpjcL3lG+aiTwYENb6EiavqDfrlrKZcq8=;
	b=GrppCEFRCZaiiAAOmFsvm86jfDWoAUFq79fz5QjZrV5x/SZbrh7uh04gvluP09hGn9/+l5
	iSOdjPXelah31Cm2wH5kTRABj0ALc7DrdHWw0GFp+GGdKkwbEzTh4JYbiP3Hc99C6nsz89
	uTTRmWCOut94uSKEm/yisNRU21VzT+w=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2pSAzOc521eM8MMUWAwepyHjyA8he2kR0aSHgrLA2RE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786803130; v=1; x=1787407930;
 b=apRKgVwnpwjBLROeFr/oFrOxOE0gTFF+anSENY3WQ14ZwdymuGynty0ixlUFzwSqyPXwtD0o
 qxPAVOS4SRv/hJwXSzgeWpv/O2pY6PxyFLBb3Ysr20FAvPrzrWunChQO++zN7tvDS4i2ZM1wWwi
 yeNDHqV3xIIIxOjNs+iO8yV4=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id 685b1f35c1f5c486;
	Sat, 15 Aug 2026 14:12:10 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 15 Aug 2026 15:12:09 +0100
Message-Id: <DKPKUHN1WU1B.1C1L6KZF8NEDX@linux.dev>
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Borislav Petkov"
 <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
 "Sumit Garg" <sumit.garg@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, <patrick.roy@linux.dev>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, "Andy Lutomirski"
 <luto@kernel.org>, "David Kaplan" <david.kaplan@amd.com>, "Thomas Gleixner"
 <tglx@kernel.org>, "Yosry Ahmed" <yosry@kernel.org>, "Patrick Bellasi"
 <derkling@google.com>, "Reiji Watanabe" <reijiw@google.com>, "Sean
 Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v3 21/26] mm/page_alloc: implement FREETYPE_UNMAPPED
 allocations
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
 <f29c4d91-5a6b-4949-8051-debe8c6fbffd@kernel.org>
In-Reply-To: <f29c4d91-5a6b-4949-8051-debe8c6fbffd@kernel.org>
X-Rspamd-Queue-Id: 281E1180003
X-Rspam-User: 
X-Stat-Signature: yxjou6x8zkwctoz6xw4qryjqdr8xrg6j
X-Rspamd-Server: rspam06
X-HE-Tag: 1786803131-50320
X-HE-Meta: U2FsdGVkX19yIKcjvwmuBQNHxUwSjkSBO3IF0mRBdfkyK54glzm44wPxk4autQtpjwc7e7HwgTEiGV2CA7j2L7merKqqmOXmrg65RNiaksNPsRGeFShlms7tiWlHnTygn+noj5klXT24wdWk+uccRRSxv89h/GHjBWKEHD4WsNvOSWGSTV1OU6fzSy3G2lRJG98TEVuoLAKrdkYFVi47J5dZaTA22TYIJuQgWaWzsSXFXCmE/4Nr+bbolKQS3HPQfD+LK4hcnL34hOuMjPslcXtc9gcF+KI4ECkLzWimiXVdJun9qqfA2cvXKlOyktkmCR6SyQD+yj/WeF5abEadz6jFrjinq0kNwgm+UyOa3bW3h8Wk/DpZVi19JejHwnbgt6fKQbzHvCFbIherNd4WQBd2GqEgBO76Umde8msT7dXJxWJL609IkCDSXIawW3gDClNHgFtAIN+nqENkSnHxfOD61qZ+cT0BRdqHmUwrdiOiMI8c/BRoHhfmsTytY1bTT0x3nds60wJGNHYj/JO8mCN9A2Kbr99ZLO63RWfxpoTTrj5le2hNKLL4xXgrBw63sFFcc0w4JZsBkXHsPPohUdahr1wv9SZpedR5xZi4QWFapVXJTQ7k1ByHmV+GrdbPTU2dKjzpyL5TAfPFdfVJwUt965m79i/32Pf5IKN7VtQkS/2erFMp1UeKqAfoU3DtJCIPIhMeS2JmnKSpat/UAyf0wWq87SV9tOHQtN3Yv68Rqae2mzoq22SZkrPe+Gr78Y8ZKRK7SBQMo3wyGLoIVdpbINVujssu1MhGZdPuVUhbA5W/oRmpR/Nq79VzOjujQSD/jPuQggXz1j4ArHwvGYyEOzn92g5W7DR8qt84TQVCqPE6gm0+mrKQ//YdbZyLr70UB3Vn8xUnsJlFS3R4ZBYJ+dyrSGSUPLkWBcGt9ELGySJkpfjo4JOu4f63ngT2OmdeuBGOHyH/37fx5Dk
 7Og2FpSN
 kf3w49mDpA0LH/VsoLUl4SKuVHzR2GIWFzeyPGfjmC1D2ygVLI/uIGs66y3PfA/23me9r92RYdyCOEocQrIUx7FjnvIhCr0PjPW946TxI0ZfKJqjIt3p+CFQLO1lZfh+WhhFDG5OJN/n4bW02WF+ShHxTn+yIZahygAp7W3CcyQvQ7pFy0QzdAAtrMsKsJ+kyyxT9twjD0VIq30eDR7D9Tlnq7tAtde70bwJNHvn0Q7/mkZzvrEL8tB1QIYk+aavthcgWFQSHrfZxxW/7nJOEQX+GDvbx26gWW1nquA5UoB5OSpFGUHaS+1YgiYHwRsLpq2nEpvQ2jn4WT6IHVKQsc9o931IX0DfgnUvPetMeO4KUj6E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 3, 2026 at 10:18 AM BST, Vlastimil Babka (SUSE) wrote:
>> +/*
>> + * Can pages of these two freetypes be combined into a single higher-or=
der free
>> + * page?
>> + */
>> +static inline bool can_merge_freetypes(freetype_t a, freetype_t b)
>> +{
>> +	if (freetypes_equal(a, b))
>> +		return true;
>> +
>> +	if (!migratetype_is_mergeable(free_to_migratetype(a)) ||
>> +	    !migratetype_is_mergeable(free_to_migratetype(b)))
>> +		return false;
>> +
>> +	/*
>> +	 * Mustn't "just" merge pages with different freetype flags, changing
>> +	 * those requires updating pagetables.
>> +	 */
>> +	return freetype_flags(a) =3D=3D freetype_flags(b);
>> +}
>> +
>>  /*
>>   * Freeing function for a buddy system allocator.
>>   *
>> @@ -1069,9 +1090,7 @@ static inline void __free_one_page(struct page *pa=
ge,
>>  			buddy_ft =3D get_pfnblock_freetype(buddy, buddy_pfn);
>>  			buddy_mt =3D free_to_migratetype(buddy_ft);
>
> There's a comment above this that should probably be moved to
> can_merge_freetypes() as well?

True, thanks.

