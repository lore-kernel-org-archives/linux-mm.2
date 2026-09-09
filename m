Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 379B9C79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F7AC6B0092; Wed,  9 Sep 2026 13:33:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CEED6B0093; Wed,  9 Sep 2026 13:33:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E4D16B0095; Wed,  9 Sep 2026 13:33:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA1D06B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:33:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BFBB802C3
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:33:12 +0000 (UTC)
X-FDA: 85194919824.18.A212111
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6DACEA0002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:33:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hhGhkxbF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hhGhkxbF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788975190;
	b=ckIbTtJLSsKIwUsdcp8743/1KhKPnS7SP1Q1GeWwPmb4b31brLh35hnpPV8FVlJYXTTH9R
	yDlDJOnqgclQAy8leuqEf9xs/Tn+liWTHcbmj9qBkHh2Mm8Vk42Yfia1Cw+rzrKO2c55/s
	dhTgBSLLhr+Da81J+6QCZeK1l9Woj+w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788975190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aDg0GpWzq1Pq3pQXFSFSo5nmvCOOz/Q/krQK/wQhrPE=;
	b=54LMoTC0+FSADzmlVhepS56Q/ft690I3JJfUoK440xrxsjXfkKwVpjOaNzb4FyMMFOPUah
	0nk69KoKohfFFyFg9BJ2ftBr3Y4isGVltZhnNqBXnUFqnE01Nm1lXed5So8tES6J8Km2QO
	f2CRC0MWJ61/bnUyvkYgjpCHdypbGGA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 917DA408A8;
	Wed,  9 Sep 2026 17:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0AD1F00893;
	Wed,  9 Sep 2026 17:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788975189;
	bh=aDg0GpWzq1Pq3pQXFSFSo5nmvCOOz/Q/krQK/wQhrPE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hhGhkxbFISlcHv9SPA0uDsuBkCiT7FM/Ywv8L5DtjrH5mK8FEPRbtFXY/qfoAHX5m
	 AuC2nxFCdMlmAaaaGlvuA5LtU7PmujyXQpktKY4X6swt7Y98dNJeXk4ibKCFOb1W8l
	 Y/cUsyy8RqP1Wd9By4OtdJYUWJtKxj6+P99H61w29r3F8dDFYjcBLzKw4zeIg3Ub5F
	 BBeHlObbqaheSW6s47D/BQBHcg9lLFJ1bmtiQsoJt6nLrTIPBu7KmRGWJ31J7LkHMK
	 eCce1TAWkX/fJoaMOaoyYBXNLD2qp6feZMjf2vrI/686I9/uwObR0J9x81IWnNJP/k
	 5XnfYePZjDkWg==
Message-ID: <c1f21bf2-71e3-4537-a000-fd0e95257759@kernel.org>
Date: Wed, 9 Sep 2026 19:32:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: implement and use vma_is_faulted(), silence KCSAN
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
References: <20260909-vma-is-faulted-v1-1-3a701f48984a@kernel.org>
 <3a261c3e-4c26-41b3-b55f-5800ae1081f3@kernel.org> <aqGJx-uQjN8-DEBe@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqGJx-uQjN8-DEBe@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DACEA0002
X-Stat-Signature: fyp64jw31doyywi3jqyzxpundcfxoeum
X-Rspamd-Server: rspam01
X-HE-Tag: 1788975190-171354
X-HE-Meta: U2FsdGVkX18QQVHOCnv2dfLc3Nt09lWoLhB5pTBR12hBsH354F6e7CngUAhqBzxdSd/XDqR1ovk5ToIleX79SFbOcdLAB5ghqxpLVu4xKDIjlZJ4QY/EXyTAwZzzc9owsiQN1t9zN1cfsMcybPmwyCaBHagJproylbY/zw9GVAnCMVfe/2DYkcKhgPxbsDJGxB8KKQEZF7RxtNtDuMokAygl/FRhWI3S5w0jupbYiBsguRt5MLImVdlemwC9LLAXw625o0+N6AZlqhzu9o2/2JvqDdPKAYvHAhyU5xEfo+PVdpBucT6Qbl8CSrQmmQECxkXJme9WchSLvOoon73+FXoD6FpSLpmk5xrYMa4v88bCYfeYuHu5cXaP63N+xFqSbyUd0IoAf4QiIH+X2Dykrk0kA67cenh0C0r81LLGRKVghh2tDJfOfBD4DLnvYQ65SN0qtHJYv7N3SEQUg9bYX04dfXthYMzcd2/1Yt2VWVQfxq9Jblpg8FWG2c15DTXjijlUdoeJP8LpkScT/cQuQl3WfQsaiwCUsXk9dC7U7cMhd016myVACPZeWNOXZrsyPztWZhglxtkFLfVwVKIjFc2TFzTR8eeUYWXwm1nr7X1yn+XP7VR3PFmB0UREuLPE5UfyE19BC2HSKvGfesLdpJ1nTGgbSUdPiKvAEaPQO8Zo4sP0Th6FxJpICcgeZw5NiavjH+1KcscpXbbeWaTqOs/KAuu4eotb+Ij7y03Rvf1XrRedPtiZQEfHLMSvyaQrREgLyFg6XazRVp53k4cz4ZqovyAZxaVh43yKZOZ+kJWalqA7ccI6KW2gGXfGOeFz5EjNbNPgeCerrnXNbZ6eEKb8J9aTL+CgymyJq80Kh29mqnVFUOH+NND9qYYDaURsv/JbjtKfGBcBvzoCq1KFybzKWc7THJi9vP9enBsFobAc8wVSmQRMdmueY2JqF8gNppQqNhi69yKUwCal1jO
 Xx8XKLjz
 FkFkafodnuwpptFlGmSBq1BE4Psv901iAletJ1FqKKkxET+RVcaWmfNAipv/NbD0Crohn53cT73K4eZaI+07mUPw07QH4j3tx/8eksAa3UQwqaodj/DJb67yNxMTV0Cypokl1j80oaYIN0HcYzZFDDR61D5FqfMXRv5X//eqGW8Cf7BYKgHztcS7zz25DRtDi/optOTrGibRDokGOcU9iMeaY4WnHmtDvXrS5bKB1DUvzcnLbJ8uowYtPDgCvNCbe4Wox43Jai8L6T9GOICuItzcxxH9VDDuwo8G+7i2wsOUfJjY8HIM/mjCSrbzXFfI54UBpBEbJvMdYpeph/QGDxQh5ctfrDkn9ciBY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 18:36, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 09, 2026 at 06:24:52PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/9/26 18:14, Lorenzo Stoakes (ARM) wrote:
>>> Provide a function to abstract the common task of checking whether
>>> a VMA is faulted in or not.
>>>
>>> A VMA or mmap lock must be held when calling this function. For an attached
>>> VMA the transitions between unfaulted/faulted state are:
>>>
>>>        Transition        |              VMA/mmap Lock state
>>>  ------------------------|-----------------------------------------------
>>>    unfaulted to faulted  | write lock OR read lock + mm->page_table_lock
>>>    faulted to unfaulted  | write lock
>>>
>>> So vma_is_faulted() never provides a false positive (the lock precludes
>>> it), but if only a read lock is held, a negative result must be re-checked
>>> with mm->page_table_lock held.
>>>
>>> Detached VMAs cannot be concurrently manipulated as they are removed from
>>> the maple tree so require no guarantees.
>>>
>>> Use data_race() to silence KCSAN about non-existent data races between
>>> concurrent vma->anon_vma read/write on optimistic fault tests.
>>>
>>> Also while here, const-ify vma_is_attached(), vma_assert_stabilised() and
>>> dependants.
>>>
>>> Finally, update the core VMA merge/split, rmap, mremap, KSM and fault
>>> preparation callers which test vma->anon_vma directly to use
>>> vma_is_faulted() instead.
>>>
>>> Note that the lockless read in reusable_anon_vma() is doing more than
>>> checking whether the VMA is faulted - it is returning the anon_vma to be
>>> used on fault, so this check is not altered.
>>>
>>> There is one odd one out - file_backed_vma_is_retractable() - which holds
>>> neither a VMA nor mmap lock and is stabilised by the file rmap lock only.
>>>
>>> Therefore just add a comment to explain why the direct vma->anon_vma check
>>> is required.
>>>
>>> Reported-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
>>> Closes: https://lore.kernel.org/all/20260829100034.423064-1-trintaeoitogc@gmail.com/
>>> Closes: https://lore.kernel.org/all/20260909115723.528501-1-trintaeoitogc@gmail.com/
>>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> ---
>>
>>
>> Is vma_is_faulted() really the right thing to use when wanting to say that we
>> (likely) faulted in an anon page?
>>
>> I think that's highly confusing, considering just MAP_SHARED mappings where that
>> will never be true.
> 
> Hmm, yeah.
> 
> I mean there's nowhere you'd do this check where you weren't checking something
> that couldn't at least in theory be anon-faulted. But it's confusing vs. shared
> you're right.
> 
> vma_is_anon_faulted()?

Hm, not sure.

	vma_had_anon_fault()

Might sound better.

Alternatively:

	vma_has_anon_vma()

is the obvious thing we're checking.

	vma_might_have_anon_folios()

would be the clearest (no anon_vma -> no anon folios). But semantically that's
likely not what you want to check in the code?


The whole faulted/unfaulted terminology is a bit confusing ...

-- 
Cheers,

David

