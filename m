Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 965E4C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59DFA6B0092; Tue,  4 Aug 2026 10:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579736B0096; Tue,  4 Aug 2026 10:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48F766B0098; Tue,  4 Aug 2026 10:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10ADA6B0092
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:42:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73B08120166
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:17:21 +0000 (UTC)
X-FDA: 85063487082.26.A599F1C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B6D2F1A0002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:17:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e+8HTirE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785845839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjIAdWjZ9as7VjsGONElYdUtkq4HftQ7u1xxJBq7cTA=;
	b=rPgpmlCklRVTdhu24pduwLHVR3hWtnd1Wuo89FnqZe6dZOvL0OGoNh+njBXdAICXT4WaqQ
	mfRDIEnPpM8hhRZXUZfmCT1EvvjDdBD3GfDrlGmuR9v1RQvlZ2/xTOlUjr58Fi3Ns7vTWl
	vcXvan9HGVsQGZg1OOZ9IDk/ydbw3hc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e+8HTirE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785845839;
	b=i1iTh/5RIvJ6DEAi64VGuCQ4tRLrDjUuafXbE2OAB83zHG+Yukvw9ScGoNDD/r0n2NwZ/w
	pYFsYiBBh5oHeuoJlr0TwWNm3o7R6ivglbe72gw4eY6vprdw3Dz0DmECxhBTWjGM/oL7ll
	zBnIHfkwm+egjgfnRX6H1WW6WkaMTSI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 12D3360A59;
	Tue,  4 Aug 2026 12:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4966F1F000E9;
	Tue,  4 Aug 2026 12:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785845838;
	bh=kjIAdWjZ9as7VjsGONElYdUtkq4HftQ7u1xxJBq7cTA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e+8HTirEVHJSswDWwhadM9WMgP2w8lsiG18pttyT5hufK30y2zHjeIdGuIIgCLJh4
	 DQP3LwEmYnaIf2vlujTDrSB+QYk0QWU/N0p5HdO5ek09L+ZIafngWBeWeVt+CuBAd9
	 8HVwk7uT0BMWvKZuSeHuUE/W2WTRwBhvNQio4rrQn/jxO0qToXh8QqCJ2Zg1EKeiLf
	 MjmBLS7x7osp3Cg2QEMX3yfqFtms8xsK+XsCqvEUCTxAEMIk0B4QdtUyarBSzsL5+y
	 8fZZ12g3pPe9ytQ9a3odz2amfDVDz/F3K73oiDZobp3PZkeQvIKlYatyvsILOrOqWw
	 6XpSSA75GhZDw==
Message-ID: <22a540a9-9a48-4c77-a392-4d72a7a6b68b@kernel.org>
Date: Tue, 4 Aug 2026 14:17:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: add some missing includes to mm-local headers
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Uladzislau Rezki <urezki@gmail.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
 <8179be78-a35c-4d0f-8034-27f3154db0e7@kernel.org> <anHDNwlcBlIfC-Hv@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anHDNwlcBlIfC-Hv@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B6D2F1A0002
X-Stat-Signature: 54773h13pgxfbebhtgfi1z3an3gmaheb
X-Rspam-User: 
X-HE-Tag: 1785845839-372767
X-HE-Meta: U2FsdGVkX1+84l5/TW0l5yaL4CIxQb0cyvuDLfg+l3HRGW61e1OX8ZZXHMEG6wdZHIKgnFlY+oc9e57IsL3F7kx4mppE2V0fvFd+6eAFOxKLhrIfg8BXRuee066+PFJ2iHLdmi7v88wA7iW8M+Os/i7h22v8lh9ZdvooOuznFB1Umd2SNJNTtFlIBhG8RpENVc6gbrjV3M+Euh4a/LH3of+uRFfgLfodXbLmQIJrW3Mtxh8sGVBI50oEEreTGDEqicHH9ATX6UX6sEsI/09yjuiquSy0EPgLLG9PAVH20m8iFRiFriRQMR1ZZy8Deb4IF6ebZnO8dOqFmOGqDAgt9UajahRhsNRURKcrMwbLhSPC+aDkclpAyq5bZdUsFzLPUqGbfcC5qBbT5kjD5wA2S72MJBmXCSpTw14gs/ZykFIxCKpCggCBpZMrwH3oTm7Fw7jmPcc8zrtoog/itpo+85I5BnWfgpaKWeGYvk2dm/kzUIVRlLwbhpaHIXLWDx0EZzvgrklXuxmCEc6lI9sIotlvSC+MD7zJwRWncSJ/w1YtG4A1RQJs8Jt5hDVinK9KPZOMpl6xR3qTnVnE6X93aayz6CibrysIfzac/0tq7iX8W/hnzHVA6BUrzKDWiIz32J7TUkUGyrAzSTDwXFa8vJZn/hkyTIGwW6gO5++WTW42TGBB8CU7ENkfCQleljGbEPWim5sa0gIMyOKTXFCmtrQyLSU2SiaHNZqJ0mTNU2t3GUJJk3eEt0wddtyhihAFYWdXHMjthB211Ad8fBlRNZMwa/u6NO/CtDcNqJfmeyvs2rC08zhIQ+27kqr+FMhu+hXWkV1xpLBgLAvHECeaTOjlb1iD78UcxsRjsw3C+FnOMgI4BJ/57ajOGgTc5Oa8hN5IQYFJeNZVzaOL8xAh2lZCumKKSgOCfQKkBT+q264nRewt1udsyar7KpEGLv9EuAmRay8MwOz5X7GcC70
 cHVcUoKI
 nkSdkfE5QgRh6Y+8SM22KSoOIggXjhmvKDIkCNVM7UkNLzKFzUWSjdzoGtjMnIyxey9Tx2/unGuYmySSSjWajbJkhXMMZUWyX4aMbRTGNyjcv6iE44ug1KfFqnEvSEjJBUpv9duKeF1tjxPHp/R00OxSZNOVLUeHgmjawr2nIgMXNQ6n6uKQhDAGviK4fbkdS/1Ix0+ZCCxhVrsXZRspyIjyuv4bhxMhE4iGmIT6Nd3cu1a0C8pxl6ntsIWu+dLsnqkZNAZeD8eGuq9z8TD7GStzIrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 13:02, Lorenzo Stoakes (ARM) wrote:
> On Tue, Aug 04, 2026 at 12:45:22PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/4/26 12:08, Lorenzo Stoakes (ARM) wrote:
>>> There are a number of internal headers local to mm/ which reference
>>> functions and data types without including the relevant headers.
>>>
>>> mm/vma.h is a special case that intentionally does not include additional
>>> headers, but the others are not.
>>>
>>> This breaks tooling like clangd (which is where I noticed this), though the
>>> build is OK due to the C files including the headers happening to include
>>> required dependencies.
>>>
>>> It's better to be explicit about dependencies anyway, so add the missing
>>> includes and fix clangd as a bonus.
>>
>> I'm curious, how did you identify these? The mm/vmalloc.h is rather easy, but I wonder about
>> e.g., mm/shuffle.h including mmzone.h.
> 
> Well I got AI to look them up ;) but I pared down what it gave me to a simpler
> subset and checked everything so I don't consider myself in a state of
> slopper-sin :)
> 
> [this kind of check ideas, look things up stuff I don't consider warrants an
> Assisted-by tag btw].
> 
> The headers for everything but shuffle.h are obvious, so that's the tricky one -
> it's for pg_data_t and struct zone specifically.
> 
> How I discovered this with clangd initially was - Do something like 'C-c l g r' or
> 'C-c l g g' in emacs via LSP and it reports 'no symbols' for something I _know_ is
> compiled in.

emacs ...  there's your problem :P

Thanks for the explanation, I'm afraid this might become a whack-a-mole without
a proper way to detect this automatically. But that does not really seem doable
easily.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

