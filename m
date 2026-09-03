Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D5D2C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 08:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64EAB6B00CB; Thu,  3 Sep 2026 04:00:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6255D6B00CC; Thu,  3 Sep 2026 04:00:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53ABC6B00CE; Thu,  3 Sep 2026 04:00:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 245F66B00CB
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:00:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2BC3A3E70
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:00:31 +0000 (UTC)
X-FDA: 85171703862.09.24E731A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id EB1EB12000F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:00:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d7iRT08p;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788422429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mH9xxi+NuX/7rAStj5yokYt3AaeJoJgJZjMceCTL2nE=;
	b=zzqhkjL304OIW8I3BWC2rGkHPsJZEydwt6vdeh9ku8NCeiwsoUKjU0kUNiADINFiaMO1my
	ezpW/E9lFMasg0ft8f5chLFiT6xJ3eMDmHFx25TAFLqYcSevg8oj94gIOlCb6GuSfoR0wr
	qvIjvhoQorBOB66DtvPGNF5iG1BmXWg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788422429;
	b=7fIZHgbPFYzorbirHK5jUI7fmKH+tCFBwp2lLomCs3mpx0E4sB0k/bc8E9XZa75muC3bUf
	0hZ+4PqnbbT7PlI6ZjGFugwvW1hjU5thYzvYQdOnijDO6qR77ByZ5EVAXU8QKrkKrrbkq1
	nILAsaVL/9iF6/KBsXAU1DVxXRPld8k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d7iRT08p;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78A66600C8;
	Thu,  3 Sep 2026 08:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359B31F000E9;
	Thu,  3 Sep 2026 08:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788422429;
	bh=mH9xxi+NuX/7rAStj5yokYt3AaeJoJgJZjMceCTL2nE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=d7iRT08pKtrpl+FS8F9XGYWGb54fjKRbJt/wm7yMpEXiokgdrv23tgEn8Dje5lFxB
	 Xpel97egrz56kjU20xZ4pk4d0TtaQ+G+af792PD36Zccz2MkZQ/aMYkK85gA3YsjAD
	 BGRwxxvOg7bPL2QDe7W6+cmgR2QlNoOo1+y7Y32T1P4YxFCmmjVSh+Osfiu3ya0Vl3
	 cjLDlkcxY70ZVR01S80kC9kcUhQt9eQobn7vu5qjlq3+4kGVEXa+xf8vBHOSGTMJfu
	 BaOO4k16B0EpfQpyBMrlzKbuzQYoQ1cUGKB4mtlyZNUKNNbue7QcTW9+WydcfQpqe7
	 hgEgZEcEaUr2g==
Message-ID: <76dd87e0-cd34-4ce2-9586-d7ff019b1fb9@kernel.org>
Date: Thu, 3 Sep 2026 10:00:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/26] mm: introduce freetype_t
To: Yosry Ahmed <yosry@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>,
 rientjes@google.com, patrick.roy@linux.dev,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski
 <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>,
 Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-13-6f5729aa9832@google.com>
 <anJmOMqCVugycC9x@google.com> <DKOLND2TRB15.2Y8DKB3ZKEYAY@linux.dev>
 <aoOomzh1ErtSeKFb@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <aoOomzh1ErtSeKFb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EB1EB12000F
X-Stat-Signature: rj7ww3brt4rn9p6eg5bdwp68ynbt8z6h
X-HE-Tag: 1788422429-447502
X-HE-Meta: U2FsdGVkX1+sArq4C9nnpfgYbjPcqXK935QPsol08jKM8yo9JJsr0O3giEPK6YFFxKr8ANtWivVaFpH77BR+DGqLN5ydIMdBldphlqw9lJiNrTmKisuOOXjbzqemC5MNsMdn0ClAwH3I5rwnmAcgIZ52V/iQKhcdJ1fa4bPG+q2H5QAOxMvrUOOF42qYwkLa/MvZptA4xQ77kJKihnrxAAQ1wFzFELgZzVnQIGEckPazKjhw68d79kjnDEM7ipSt60qQSTgt7YiUaijuFGQvaVszlZcmSrErN+tVf/lxJAKMnIdc7DOLyaFpywul1kgzO/E4SyEq6AmDijr/tMVP7kX6DfvKIz8JjPL0sffQc6SZ8IaM9YKTBt+rX3IWjLAlu41PAEjuZbh6KOtpT4NV043U3jP54sG/vIjTEJuqi39sZjNj+2GKWEEEds6JNyERKmGYzmFHlJhqcC20gVhy9frH0tQG9X9ABR6DaOKqow0hL5JjNL5C/dqT3lQOylLvq5kgwyqpdry8oihR1l5tKHPoHQcXh2wmIgiklU0YAnylU+oflMDda9a6YkCLCRq21znjG1koczlP0WE84Yy9fgES7lxUbnNJxz3hgjdyW/PyRcbQUqomsQZfeJKJKjayG/AfHSw7H/J0McktpCAFDkKygE+fgMsWxcaqfhz4FB+RBkmJ2vNHiUTF1mAMPZ9VOiQvE9gzaX4gJJ5K6ou+YuKkdMkM3+DcimquFZ/bcdR4yCbB10roDOGSTMC6hupVzzAV8wDkPRP3JY+YCpYujticwfLkkih8ck1w31OLTkmS+ayaSH3carmo/kpY4+i0iT+rggRu4n0NqZ41G0o/S5DiJcOD8/CXvwAs8gES89GO94v3RK08MSgxvZ7Cx38mYR2WT4Oc4nCIlmMFZgqW0qXuTA/kkUZsrO5TY5pP7RQDfXaDg5Pj510f7pk+4gytp//nNxPBgKM1LpgIj45
 CB7G/WkJ
 K1L4GT47ZxOJvjesGidW1eCZcOS6LSfrfEh9ITTLYsQAPDiHfJ7iaPh1rbXylM1VUmD0lso5ArpmF+rIPGF6Mp0MwynrikYoZbBqEK79122xKC42ANSgCqELnQbtnuE+0R05+i5Uk0UmWDCktPA4JfQtp0XVDHeJeNer3g3mKsZR0Ps/i6T3n38SvNes1JNHOX4QHFWU3sEFv03PjXxE6m/ATD0JBpygcxNLs0aXYRDAomj5ZZbozApFs+RwQugbzb+UupqOFR29/r/mfnn6iP0qm8NKn82GYF4rIlqUGQEg63xbcW686g3aRwYwrGFO7sCtVzQh1P9AimKI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 02:35, Yosry Ahmed wrote:
>> >> +static inline
>> >> +struct list_head *free_area_list(struct free_area *area, freetype_t type)
>> >> +{
>> >> +	int idx = freetype_idx(type);
>> >> +
>> >> +	VM_WARN_ON(idx < 0);
>> >> +	return &area->free_list[idx];
>> >
>> > Should we return NULL here if idx < 0 instead of an out of bounds
>> > access?
>> 
>> TBH my descending order of preference is:
>> 
>> 1.
>> 
>> BUG_ON(idx < 0);
>> return &area->free_list[idx];
>> 
>> 2.
>> 
>> if (WARN_ON(idx < 0)) // OR VM_WARN_ON
>>   return NULL;
>> return &area->free_list[idx];
>> 
>> 3.
>> 
>> VM_WARN_ON(idx < 0);
>> return &area->free_list[idx];
>> 
>> 4. 
>> 
>> return &area->free_list[idx];
>> 
>> But I suspect[0] Vlastimil (and Linus) would order it the exact opposite
>> way.
>> 
>> [0]: https://lore.kernel.org/all/bd36e972-8900-4476-a66b-4dc218b21a4d@kernel.org/
>> 
>> And I care more about making Vlastimil (and Linus) happy than this tiny
>> detail of the code, so I'll defer to him. The current style is a
>> compromise, but maybe it's just a compromise that makes nobody happy.
> 
> I think I prefer #2 (regardless of whether it's WARN_ON() or
> VM_WARN_ON()), let's see if anyone disagrees.

#2 can't work with VM_WARN_ON as it returns void. Otherwise if it evaluated
the cond with DEBUG_VM and hardcoded false otherwise, it would be ideal. I
don't remember why it's not.

Do the callers all handle NULL safely? In that case #2 has some merit (maybe
with WARN_ON_ONCE()) otherwise #3

