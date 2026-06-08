Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73945CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D893B6B008C; Mon,  8 Jun 2026 11:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5FE86B0092; Mon,  8 Jun 2026 11:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C76786B0093; Mon,  8 Jun 2026 11:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B519F6B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:43:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 437118C152
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:43:22 +0000 (UTC)
X-FDA: 84857164644.06.88E1734
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 755BF8000C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:43:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M5vUOTU/";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780933400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMFKUHJsuCDLxxL9diAUl5h8DMw6Qft+b9Nr7n4HRcM=;
	b=Q2vimJOyEqgn4sP2WR4lA92T2whBmnNqZ+O66s318hredI0pjSE03yg9lkGlDfO8i/gpEy
	PANP7V09rQaoMQrtdZEYQQkoKgFuz0RQHX2a7oC5YnQBZOau6qvWs6WSB+XvuWo8AuoHtY
	RSB4i/Vo3Zm2fk+7k1wI1sYsq7rDHrQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M5vUOTU/";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780933400;
	b=0o9Ra/Gc2r1lO7ukpMKkTcDK69hBH4I57xQptzLQvNiYJ3eyzZyqqR83E34xYgfPHLtQdR
	Of5qYF7UIWDg8t6CIqQa/z18/QiivxWwv1xOJu/QcFCWIzoDVnISf+UwSWNXnMGXCusvmY
	PtD7W+NDg4seh6JTmw24TC3y2SeUmFY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 81501435C0;
	Mon,  8 Jun 2026 15:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE011F00893;
	Mon,  8 Jun 2026 15:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780933399;
	bh=kMFKUHJsuCDLxxL9diAUl5h8DMw6Qft+b9Nr7n4HRcM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=M5vUOTU/7y3rWRuGH/qGFr2AfvRDyZZTUDU2FNrcktQ8pgg1BBfe2oa0NAZ3GwHpf
	 Tgh2MQ3iWGrssS+cQwky2NWwhSlBmiT6w6ateXiR46ILzX+L9LRV8aeCQvs/q4Ixnu
	 PpG9HJYPi3q02fb9CmOoE0tUNgqPMIw4UAjk3DlfMe7k8Resz/K2IsMUXF77wROazU
	 3fA/yPlhn5JVXhf+i6F19wyLVwLfkwHg4yBgcCnd2sZzD+scRo8XSASFqtFXj0lwPc
	 Tm6n/LHh4tntcifaC0VxK/s3ANE5VswGozCyGiUp7xlpiZXy3kgaTpnVhs9fcJ4TLm
	 SsWvE6y8xYyOQ==
Message-ID: <c9d98321-60be-4cf7-998c-7657d93fd683@kernel.org>
Date: Mon, 8 Jun 2026 17:43:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] mm/migrate: skip data copy for already-copied folios
To: Zi Yan <ziy@nvidia.com>
Cc: "Garg, Shivank" <shivankg@amd.com>, akpm@linux-foundation.org,
 kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, jic23@kernel.org, aneesh.kumar@kernel.org,
 nathan.lynch@amd.com, Frank.li@nxp.com, djbw@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-8-shivankg@amd.com>
 <810e9a58-9c08-4f5e-af5f-866685ca09b2@kernel.org>
 <a36348d0-73f5-4599-8d06-c9472d0b8d72@amd.com>
 <7e6a7626-5a1b-4672-91bd-85b0f4ee2ecb@amd.com>
 <7430d69a-616b-40cf-a2e8-6ef4e57b6857@kernel.org>
 <F496EB0C-B329-4A61-B4B4-0D434563281F@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <F496EB0C-B329-4A61-B4B4-0D434563281F@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 755BF8000C
X-Stat-Signature: jid4quixwsqofizrmn1wkzhys3u35486
X-Rspam-User: 
X-HE-Tag: 1780933400-223056
X-HE-Meta: U2FsdGVkX19JFqmV7TTish+KtPqhZLDk+hneaozShLPdQDm+C0lBeMR6SfQ4ny1zwWvMSCmH1bA0Lc5C4tiza8ZMHpZEwnjhUrrTTRDN94G1o+JfaSiaWQBVxAAOCpxYNeKwQyKS/Zic4RxhZbZoV2Dc6+ZQjVBUOXbAzDKwf+iyc9rxpirf90jLBnAZo0o+Q4lKTBBUSwEY2si6hOuFuJwjQvxANPX7ZFUt7qTs34cSzvdcJ5kUGrrJlvcD/Wo+XEHKo8SmOenztI4Bo2LpBXR/woCcLJI8eCxXZ6YPzgcO8deHsqrBpQpCrch6zPQHRIa9RVWwg+vN/lh+64ohEJglEfcEHitaGc7BNUitjnPiVVuh51EybR3ryANPqASbAdO1T9CaSY4I/ZnQwpnZibK932MqL1P/nCM/VVVZ5uAZ6QdIvza58+YUvfp0syLFl9Sapy4P7cTvSKWX4EG37wWdWNTrWOuL9M5YyRH3dDLUCbDXbjuNdCf3cQb7Kth12Q+qBkDR0KRAyldB3ZTI19Rd6VvgMuI3rLSprJdJ34aWW/YNClcayw0d2X/OYk27Fie3/8A6DYdjT0YTrJoFHT3MACV5AjIfklMr1TqVi+JyloOYJRlO6dvcYcL3UZcGUonZ/3sBDGLL7X5zjHGBsuoJ0p9oUYOQAIt3TwvPggZjmS0RolpXZ0y2CrY+3mM1u4mA7lEhyIh9jWGC15+qhtZ6PcHOHD34UCGokekQCrDBobX4MDzPq81uMYe8PPZcy1mEGJEQwvy9SdQDRkSAxarfOFzHhk0RWlt0WR84nK0TNcElDPftEoFqgBEaKDoOUnxjmiESQTK6+VoXBMsXa4gAe8u4dwhwAvNsbxwJmvdfY51W5lhAjsZkgeK+iTFdYBXpzbJEPenbZLz9voJHE9qjskDwetEeAchEc+oHMYXvrhNXYkSFq9hWt2eWSde+3LdS1tqHyn00709k9g3
 /avdJIjL
 hRK9Vksx46sBBxjjTcL5aVBgSyDiKw7xxp6Ul01/u3gYqU6Ucd6UUZQBS/W+dlNgK1CVM9xiGBwfnE8a0bls3IAUNeCIB0JLbn4/PqThxAv+FL6i+Cifla1ligRqNhta1PTQ7NgxAT9d59wG6wCJ56ZNrmBpps2pDg518Plcff2WiNAn/Mw1FYjARRizpYXKORhTdEaCcd2oWd/dSrDyMC14uX2xLeJRGpLWAjNfrzxE5zT/i+1cAHehjjsAmNAXrp8YLg+fNoYtufWDuWHT5+akSJXatYFvIHVjFn1o4PhgJeHLxXEXobpLwkuVeEDsR1EOLabpSAcsNUSx0osLpd7xNmC5ECynuu6iB3eGTfH3KaXoHJZz0wrot3GS2I2UxoES1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 17:41, Zi Yan wrote:
> On 8 Jun 2026, at 11:18, David Hildenbrand (Arm) wrote:
> 
>>> Sashiko Comment:
>>> Does expanding FOLIO_OLD_STATES to include BIT(2) silently corrupt anon_vma
>>> pointers on 32-bit architectures?
>>> The anon_vma pointer is packed with FOLIO_OLD_STATES inside dst->migrate_info.
>>> To separate them, __migrate_folio_extract() uses info & ~FOLIO_OLD_STATES.
>>> Since anon_vma objects are allocated from a kmem_cache with align=0,
>>> ARCH_SLAB_MINALIGN defaults to 4 bytes on many 32-bit architectures. This
>>> means a valid anon_vma pointer can legitimately end in 0x4 or 0xC (meaning
>>> bit 2 is set).
>>> When __migrate_folio_extract() masks the pointer with ~7, it will silently
>>> clear bit 2 from the anon_vma pointer. Any subsequent call to put_anon_vma()
>>> with this corrupted pointer could cause a use-after-free or a kernel panic.
>>> --
>>>
>>> #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
>>>
>>> I initially assumed this to be always 8, confusing it to be same as size of
>>> unsigned long long.
>>> But the GCC docs note that alignment can be smaller in size:
>>>
>>> https://gcc.gnu.org/onlinedocs/gcc/Alignment.html
>>> "For example, if the target machine requires a double value to be aligned on
>>> an 8-byte boundary, then __alignof__ (double) is 8. This is true on many RISC
>>> machines. On more traditional machine designs, __alignof__ (double) is 4 or
>>> even 2."
>>>
>>> If my understanding is right, Sashiko concern is valid, and I can't safely
>>> use BIT(2).
>>
>> 32bit makes this tricky indeed. And that's also the reason why
>> FOLIO_MAPPING_FLAGS is currently limited to 2 bits.
>>
>>> I see few option from here. Either I can gate batch copy for CONFIG_64BIT,
>>
>> That's a bit nasty as we'll have to special case 32bit vs 64bit.
> 
> IIRC, multithreaded copy is already gated by CONFIG_HIGHMEM, otherwise
> it needs to perform kmap_local() at each copying CPU, which complicates
> the process. Then, this code will only used for 32bit without highmem,
> I assume there will no page copy DMA on 32bit platform. Maybe it is not
> too bad to limit this to 64bit.

I'm more concerned of CONFIG_64BIT handling in the code, but if that can be
avoided easily, fine with me.

-- 
Cheers,

David

