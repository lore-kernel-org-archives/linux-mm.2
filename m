Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBB5F606A339
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cbvfpgu8
Received: by kanga.kvack.org (Postfix)
	id D666B6B05B5; Fri, 13 Nov 2026 16:39:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA2D6B05BC; Fri, 13 Nov 2026 16:39:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDA056B05E6; Fri, 13 Nov 2026 16:39:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DE506B05B5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:39:40 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17B38400B8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:39:40 +0000 (UTC)
X-FDA: 85431412920.26.9BB5E79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 51449C0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:39:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cbvfpgu8;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794605978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQYsjuLSgqmkYc+gxSurb8uN4B+g/9xyTOSp3ZLANuo=;
	b=QrpXd32AXEFfqy1z5C0M89O+Xlt/68RtMZb18IkTyw8yYGzZCFU/mo5/ILLyzOdSTFdjUa
	ulA9l8Pw0QKpxKYq2lFaLg71YYY1hWN/1Da9vVIwAEfLtp1htJrJvboyUT/UeEhthVDACu
	NhByah0sZMTRy6McIYZi6+GI3BfRiPE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cbvfpgu8;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794605978;
	b=EAMyVxZ2N59ZmCCuQyYaunUzLHlBqH9IPkwwhYHrRvtGsU/jNp/3BAPjwoGiEUDZkadCcd
	w6PtkbJQKZqVcbT+cNRsDKaxXCngnZ4SR4vyI5knR0rxmWk5xqkS+KIAbCFPWJ9b0zUvLC
	IlwpCjBLQSdLjJ07xup5BcbxfmFb3A4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 884E6623B6;
	Fri, 13 Nov 2026 21:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B0C1F000C6;
	Fri, 13 Nov 2026 21:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794605977;
	bh=HQYsjuLSgqmkYc+gxSurb8uN4B+g/9xyTOSp3ZLANuo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cbvfpgu8tOow6Wv2h/7RSGys/vhrTWGQUnh4KqZ/MxLpfcdUf3D5uLQJDematIwO6
	 pF8ZFDoI5V9m6v0E2uv31piPTWg5RXcGhHOMnGB+I01f81xmVBupgzZAhOd1wnhrNW
	 S9hFDCZ8T/veXtk3HWrex1bO4RiSQWcnyZWnwvE2hEuQIiziMaZL8uAjJVaIED0+dX
	 8meuP51dZrUS3Vzh9kCgbv2SscDfUdKlnVIslfTnnyoRorO6NK6HfpIJ7CuQZO8P84
	 WPetnx9aM+9b3QGtptr+vAsx7A4FMTZfolDdiM/+o0o+7Pgeat5j7DADWq6BOdsgh0
	 uZwK1kSfZhR9w==
Message-ID: <a502f84a-b349-487d-94d9-aff7d9b95102@kernel.org>
Date: Fri, 13 Nov 2026 22:39:30 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/madvise: zap markers from guard regions
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Tal Zussman <tz2294@columbia.edu>, stable@vger.kernel.org
References: <20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org>
 <f8b0f20d-90dd-496d-97e9-9a232124e3e0@kernel.org> <avd8-uVPf6BSqwEQ@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avd8-uVPf6BSqwEQ@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rq8esf3591b77aikmz53y13crezzth4b
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 51449C0003
X-HE-Tag: 1794605978-165777
X-HE-Meta: U2FsdGVkX1+vIzQRWYuQ2FAa8QG9gNKcutSYvrgdIE6r2WRq3nsfrElXMnKEuxAt+rnzzU4UCHJhW1CaNeYa40dxXEL4KFEkZL+qvv9OxtD7KY4MMqj7m1sSB8g6yGuVYftwwPASqjwpI1wVYp32/xn9dHyC4wmEE5NdNeeDudxtZjCBjMZVeQBc2gyANRzu3jYdqTPjbYv4eDVXtnf+eAVgfyZSSBTQBAAlympCuIEGocHc7kKB+0JMhonH5Ue5RW2I00ZUpthB43ostVJoZhbGzRYHnCXxB0BCZ9wv+LjsY5UhiQ9dBSRR9Es0qBYKCOq8UlyOfY7Jwecb8AJVI631uUqCClIwb2F853KLKpB096nqxxgdNevSgpMamKoOq3ydyKznavtkeHx80JYx2fqAmmK8n+p5ap6Qon4NZGy4B38i4nTmQm8oAY63T4541IQgi/IEmVyDFpb7GcU7VDyLMmkdcy2V3JywDGHqbZe2RqlmLLgaE6vFUnwi6wYH078hQP/FLZef0xNnQuxpBifffEXmiWzicLDDBqSsx5T4afey1OD2KYIuProAdnF9qTBNCCtBtqYTcpU+Pze/DESSBUqdcPV0MG1EH5+TNDYFKRSfOdqhAlMKU30u/g7afCHaAbcEgxysStfFZnXOzxyzRjKug0H53KOWZdNAmu52P53uuPsv5VhAf6bU8+Spa4Lr8v62NcXWkDGnPhJa1KTOXIv40fmCjN7G8GK+jWNWmk/kDHcvxLn4z1EtDV1xnp3PeSutNjmBY/GD8n8duUtsu/p++K4fWaj89PAFSh5viGjDuYclzCogjCjjAhJLW/vNj7FrEb4muHPPwh7rbEKo8+tCy1AamojFSvD5XHBH+E8a42EuC0koSeSrhRVyckHIJsLxMYi4Vaoc04q98rfYuwqIaPSWANtUqFF04VHdM/uUSuFXz31PawjNbbPJdBsjN1CxiG4OK5Kg5km
 j+gN+nLw
 mBOIEgd//ni+FmpKq8cSHpjVUJkfK2p7zdAiRWc5v3LRdzo6rbHkW1+cqNghZ1UG+XMBsZ+q8/7fNAdBuAZ7I4HJIY/9CVZ01U4DamPWDE6eMP8dQFWR8fwaZryEC2DOsY2ln2k7g1nLAyWhfbAyUsKRQ9p/tf35qLwn77fcuYR2Iv3VnRQUvULqt0SQkDxYYjmFz9zeitT0PJ/vGz4+9Ts3bfKrIpbjzNTJLX+4kIScTJVowDVYYmCL8HOsXtTF9kcpKg2/7rwQadfnpCNST3PAPFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>>>  mm/madvise.c | 28 +++++++++++++++++++---------
>>>  1 file changed, 19 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/mm/madvise.c b/mm/madvise.c
>>> index 0214efd2a014..4f7728583207 100644
>>> --- a/mm/madvise.c
>>> +++ b/mm/madvise.c
>>> @@ -850,6 +850,19 @@ static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
>>>  	return 0;
>>>  }
>>>
>>> +static void zap_range(struct madvise_behavior *madv_behavior,
>>> +		      zap_flags_t flags)
>>
>> Two ... ;) But maybe it's consistent like that in the file, didn't check.
> 
> I'm a bit exhausted, can you or Andrew just fix up whitespace like this on
> application?
> 
> It'll be easier when I have the VMA tree.

Yeah, absolutely. I'll let Andrew pick this one.

> 
>>
>>> +{
>>> +	const struct madvise_behavior_range *range = &madv_behavior->range;
>>> +	struct zap_details details = {
>>> +		.reclaim_pt = true,
>>> +		.zap_flags = flags,
>>> +	};
>>> +
>>> +	zap_vma_range_batched(madv_behavior->tlb, madv_behavior->vma,
>>> +			      range->start, range->end - range->start, &details);
>>> +}
>>> +
>>>  /*
>>>   * Application no longer needs these pages.  If the pages are dirty,
>>>   * it's OK to just throw them away.  The app will be more careful about
>>> @@ -872,13 +885,7 @@ static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
>>>  static long madvise_dontneed_single_vma(struct madvise_behavior *madv_behavior)
>>>
>>>  {
>>> -	struct madvise_behavior_range *range = &madv_behavior->range;
>>> -	struct zap_details details = {
>>> -		.reclaim_pt = true,
>>> -	};
>>> -
>>> -	zap_vma_range_batched(madv_behavior->tlb, madv_behavior->vma,
>>> -			      range->start, range->end - range->start, &details);
>>> +	zap_range(madv_behavior, 0);
>>>  	return 0;
>>>  }
>>>
>>> @@ -1217,9 +1224,11 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
>>>
>>>  		/*
>>>  		 * OK some of the range have non-guard pages mapped, zap
>>> -		 * them. This leaves existing guard pages in place.
>>> +		 * them. This also drops any PTE markers in the range,
>>> +		 * including existing guard markers, which we reinstall on
>>> +		 * the next attempt.
>>>  		 */
>>> -		zap_vma_range(vma, range->start, range->end - range->start);
>>> +		zap_range(madv_behavior, ZAP_FLAG_DROP_MARKER);
>>>  	}
>>>
>>>  	/*
>>> @@ -1845,6 +1854,7 @@ static bool madvise_batch_tlb_flush(int behavior)
>>>  	case MADV_DONTNEED:
>>>  	case MADV_DONTNEED_LOCKED:
>>>  	case MADV_FREE:
>>> +	case MADV_GUARD_INSTALL:
>>
>> Huh why that change? Not spelled out above.
> 
> It's just the established way madvise interacts with TLB maintenance.
> 
> Anything that uses madv_behaviour->tlb has to return true here so
> madvise_init_tlb() and madvise_finish_tlb() do the right thing.

Ohhh, I see now.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

