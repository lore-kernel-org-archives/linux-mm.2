Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74422F589AE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD17D6B0096; Thu, 23 Apr 2026 08:28:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8C06B00A2; Thu, 23 Apr 2026 08:28:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBEC66B00A3; Thu, 23 Apr 2026 08:28:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB2E86B0096
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:28:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3EEB887632
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:28:49 +0000 (UTC)
X-FDA: 84689749578.09.FB1538C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7FD7080006
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:28:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PSM3c2kn;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776947327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sG5ghfu2jFC4aldxD3kxvORSzXSDLLT86Yp0ZXVbsX0=;
	b=VzznP2nI8l/CFIhCAJ2MBBqLdX4zKPMAW1Mxdjhpr80qJR7cbehEZ1QLXAyc15ypSMgNsC
	2zg+7GzVDwwaIyCrsjIDOEmHv1rSMLdI4djluQR3a1L5DHjPKiOyq5Xr600pKHZ6mJpkGg
	9ihmmgZE1KhL1TGlJXGFzTMEJ+oSdLw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PSM3c2kn;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776947327; a=rsa-sha256;
	cv=none;
	b=8EgBfwdtezASnSnBNRe8dxgjKBpFAY5YpNZaKSB9IktzZkZtYrjw21Br7uzjczglvUA6Gr
	xUP4KU9PU2EBvSkvx1nlsbOMwTm7Pfxai3Q8d691xK5LDMY+eCbcHIeTcGP6AdU2HCBc+o
	kVfmSiuEQ/HdiBqgYmhWutBE0v+u7do=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CB5386014B;
	Thu, 23 Apr 2026 12:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0860C2BCB3;
	Thu, 23 Apr 2026 12:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776947326;
	bh=WcCQRAneXN0yo79vQq3fLMIsGEAKpO1QE2YHg9kqD7s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PSM3c2knXTOwKhpHZ3jsKxgcWqqu7WR/VLqIlkdtlTrj2urvm5dfJhR4G4fEAwZjo
	 kGacdtrfSH/1ysad2N/z3vSTegBdHt89r2CuMCwUMGEevOjAwgBojl4nZg33QoLFKH
	 MSVdvQ7LDdF+39xjy/fe37m7drmazUXXFIGGOtwPDlyHpwEVSUlpTkDalc2bZBpk+L
	 BWK2/7nhTK9cncPANlpebpoABAofbVKJkIPOPEQnibia1qF41hI0e1GhrPz4/BbnET
	 o8jFO0uZ+eW+GQhpY/qxW0JptPeYcLYpCH40hCUZ/iBdMJoZJNfJlq8vwNZxetzkf7
	 EfSR6DU0Wg+eg==
Message-ID: <25aac60c-8510-4d92-85f3-368cfe9d83ef@kernel.org>
Date: Thu, 23 Apr 2026 14:28:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 v5 2/6] mm/memory_hotplug: Fix incorrect altmap passing
 in error path
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20260423071911.1962859-1-songmuchun@bytedance.com>
 <20260423071911.1962859-3-songmuchun@bytedance.com>
 <e0ed4524-36d5-41ff-8ded-ba036d6ff6e4@kernel.org>
 <A542CA17-C6BB-4D1C-BBAB-154FA5E35B36@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <A542CA17-C6BB-4D1C-BBAB-154FA5E35B36@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: t16a9kb66neuoq1wh1dtwipitgsgieus
X-Rspamd-Queue-Id: 7FD7080006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776947327-238373
X-HE-Meta: U2FsdGVkX18bZc8n7DpvRwR/OVH+F+XZBRyJdlAJYZe7U8V/eS8fW4+QBN18UGorG+wHV8ImNcT1hnlfqK+sXYOi6VwWUs2UmzVuvD9l8kkZUiAWrkZ4d6ESAvu7GkNm2ZCuY/HMx1qebPYe8T6YJG+gcK+3lmH4DlEPuyvMchG1Ij7FZQN/NrM/PmYSgLfzv1vNTsvs1I8PgFl51J+jtjcDpeGaRei0OfNhwI4T37rnNcPXRgxfa80tLihZlbwCrGy6sIOZ/XniYTb+U4NYnfoydJ7Y8I535ebJAd8OTo0dLeyXZSoMeontu6gWKOjpF6gjfnernR4402vNxXK8sExVrdau6P/iyR9RwgduJC7C9BEc1E5DNAL1V9zwUqLfdMetaclUN2P0e9fNOfmnjUj068zBVaEfIY3qshBtNUDR+yVb5ZdGAONYnvzhsWNnuc96ya9Fx55lCkkRqwt2UMraJ6GSL3EuBPy3tmpccEIZPdMhbdBh6CKS9e7e/GlIjUqMpmlsqGZbAqAaS3Kauym9uzuAFeomWggr5wl8Cqg1otLtXuq5InoUy+aihqk9ACtN75PI3Ikfc/xwMYFCUAtoWVI1/EpO5AJgmTiE2kTpAOCusNyDtCkVTkiW2dLKu+18GH0Y1AaiCH542ld+FpFL10umh68mSEnNWDG+ccG+ilGP1XV7Y1Dnyl3iw6sbiUDTDn5mOFLR2kFiVvs5HDRFIRDb219z1rsMSGbRGbiDY0drOifpfxGSIUM55+BEfdjRxMvuNFE9uOvxBnC1NvsTqYXFlPMvrEy4Y23OiidjV1bRw/4agg953mDNaYm6y6PpnZXa6SpXfVyT2lcOEO1JN7MXX3+Rr6dK7zCqq7ey89P8CzMZIBSLjlUZFQSXFa93r9lIPEeIG8CEd5NsH66qm5uIhU8HJp8rWVebdL5K5QVdqHyjF9q7pdiAvhWa3G/8ny7wSZfM/qEBwDt
 FLGeit91
 Z5CoXAeowgsPwD2CIdd//9Db7nJGHQJg96sUYQZPrEzJhvNCK7bF8yxldsqB/o19ASuY08gQmQTQZPtK23HZ6scdUxW4nnjg4x+DYV61cH7FABRAvp1zdNStY3d9XaapPvSOVq0jzKLm3xgL8bS4B+FZkRtlWki2O7P2Y4M07EV73qhFceZX4czs+rLKHfh4bpL/KxIye79DhGVg8qqhuPhxbcXUHpgulULEaDytqyeRNX2BPxZzFnNGz74++1TcKnJp8pvGHf8vnHbyM/RbHnEntGM8oyxIgM3se7c7rcSEAj+jN7T6/bmxBeNLfBP0l9xGNHD19cD/+7UJ1N5B/45ECoc146pUc/t9e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 14:18, Muchun Song wrote:
> 
> 
>> On Apr 23, 2026, at 18:38, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 4/23/26 09:19, Muchun Song wrote:
>>> In create_altmaps_and_memory_blocks(), when arch_add_memory() succeeds
>>> with memmap_on_memory enabled, the vmemmap pages are allocated from
>>> params.altmap. If create_memory_block_devices() subsequently fails, the
>>> error path calls arch_remove_memory() with a NULL altmap instead of
>>> params.altmap.
>>>
>>> This is a bug that could lead to memory corruption. Since altmap is
>>> NULL, vmemmap_free() falls back to freeing the vmemmap pages into the
>>> system buddy allocator via free_pages() instead of the altmap.
>>> arch_remove_memory() then immediately destroys the physical linear
>>> mapping for this memory. This injects unowned pages into the buddy
>>> allocator, causing machine checks or memory corruption if the system
>>> later attempts to allocate and use those freed pages.
>>>
>>> Fix this by passing params.altmap to arch_remove_memory() in the error
>>> path.
>>>
>>> Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory requests across memblocks")
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> ---
>>> mm/memory_hotplug.c | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>> index 2a943ec57c85..0bad2aed2bde 100644
>>> --- a/mm/memory_hotplug.c
>>> +++ b/mm/memory_hotplug.c
>>> @@ -1468,7 +1468,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>>> 	ret = create_memory_block_devices(cur_start, memblock_size, nid,
>>>  					params.altmap, group);
>>> 	if (ret) {
>>> - 		arch_remove_memory(cur_start, memblock_size, NULL);
>>> + 		arch_remove_memory(cur_start, memblock_size, params.altmap);
>>> 		kfree(params.altmap);
>>> 		goto out;
>>> 	}
>>
>> Yeah, that's nasty. We should CC stable.
> 
> Make sense.
> 
>>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Thanks.
> 
>>
>>
>>
>> Should we extend the safety checks we already have on the other path?
> 
> Better to have.
> 
>>
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 2a943ec57c85..1c304468af08 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1402,6 +1402,12 @@ bool mhp_supports_memmap_on_memory(void)
>> }
>> EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
>>
>> +static void altmap_free(struct vmemmap_altmap *altmap)
>> +{
>> +       WARN(altmap->alloc, "Altmap not fully unmapped");
> 
> Should we change it to WARN_ONCE?

Was debating with myself, and yes, I think so.

> 
>> +       kfree(altmap);
>> +}
>> +
>> static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
>> {
>>        unsigned long memblock_size = memory_block_size_bytes();
>> @@ -1426,10 +1432,7 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
>>                remove_memory_block_devices(cur_start, memblock_size);
>>
>>                arch_remove_memory(cur_start, memblock_size, altmap);
>> -
>> -               /* Verify that all vmemmap pages have actually been freed. */
>> -               WARN(altmap->alloc, "Altmap not fully unmapped");
>> -               kfree(altmap);
>> +               altmap_free(altmap);
>>        }
>> }
>>
>> @@ -1460,7 +1463,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>>                /* call arch's memory hotadd */
>>                ret = arch_add_memory(nid, cur_start, memblock_size, &params);
>>                if (ret < 0) {
>> -                       kfree(params.altmap);
>> +                       altmap_free(params.altmap);
>>                        goto out;
>>                }
>>
>> @@ -1469,13 +1472,12 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>>                                                  params.altmap, group);
>>                if (ret) {
>>                        arch_remove_memory(cur_start, memblock_size, NULL);
>> -                       kfree(params.altmap);
>> +                       altmap_free(params.altmap);
>>                        goto out;
>>                }
>>        }
>>
>>        return 0;
>> -out:
>>        if (ret && cur_start != start)
>>                remove_memory_blocks_and_altmaps(start, cur_start - start);
>>        return ret;
>>
>>
>> Maybe the helper should even go into altmap code? Not sure.
> 
> I think the current changes look great as they are. While I believe this is valuable
> as a standalone cleanup, what do you think?
Makes sense. Could you do me the favor and follow up with that, on top of the fixes?

-- 
Cheers,

David

