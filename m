Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B15606A88D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PsJ8kMUS
Received: by kanga.kvack.org (Postfix)
	id 981AF6B05CB; Thu, 12 Nov 2026 03:41:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932E96B05CC; Thu, 12 Nov 2026 03:41:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 821526B05CD; Thu, 12 Nov 2026 03:41:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DBD96B05CB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:41:07 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB2221A010F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:41:06 +0000 (UTC)
X-FDA: 85425822132.05.4A7A462
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1CEE4C0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:41:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PsJ8kMUS;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794472865;
	b=wB3b+kzINmEt5JMPoetZxnkyX+LZ4tf3p5M/V4PuziVJ38quE0GHvZWzljFC+s6TdeGkrt
	WXMv9ph5y8uP43PCP2Z5t4FJEFu4j9lOBF0IxpJSOCCSPDsSvBrUgfkigrNr5M1ef4k7EO
	d28zG8eLs6RhzwQzJaImhvnIjwbpG2E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PsJ8kMUS;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794472865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fthYHrOF+5dGTgn8Y4kE22m9q7Cd14oHg/PsNYTRC5E=;
	b=aX7anLEPAgoHdJl1403SSvIHOw7GMBqXPur/oWoHrXRF/ZKkU5QWg1kxFHHakfmztTInGv
	NhcEuFnQ1TlOA7qASPlvCNFfJE8T2OEENNyIrRwuMTnXc1x73/edhg/Fja/v8iVIHHjaA2
	1R1yAPk4VRoP8PKjrty0fReyFW+8RWg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5027043927;
	Thu, 12 Nov 2026 08:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB6A1F00A05;
	Thu, 12 Nov 2026 08:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794472864;
	bh=fthYHrOF+5dGTgn8Y4kE22m9q7Cd14oHg/PsNYTRC5E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PsJ8kMUSB3EGJHW5qVwks6Qbwv20bXjnqIFTIR1/ceR+LGf0okaQt5ej3o6UnAG9b
	 NgCUKP1pJLcvkSnD6BTPbnRvYTZ6/dU4ahXisnoyn+tMutkCXjlfuWiil8rMgs30tE
	 XdrjWQQgBiuz56RgSslBx2lTpeu0Z/yvVpB7hAJu67AyrU6+0bPx986QjCpCaY4lmS
	 I8XJG8lbO5ethYZ4njetFgkB1YksOYlFQMwHOTo/Gxi1cvuS38g4iPYz+DJurvIy/D
	 63hkpRkD9PzX8UJ+4XXJk9KARRtMb3MnFtGpt/bBkqjViDzamXuN+9TuRQnl9HuflR
	 AHJnt9MR5zn8w==
Message-ID: <8712ee27-85b0-4342-a3f5-7e9b4425b804@kernel.org>
Date: Thu, 12 Nov 2026 09:40:57 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: gup: allow long-term pins of CMA-allocated
 HugeTLB folios
To: Qi Zheng <zhengqi.arch@bytedance.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, azpijr@gmail.com,
 lance.yang@linux.dev, Qi Zheng <qi.zheng@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
References: <cover.1794046188.git.zhengqi.arch@bytedance.com>
 <586d6c53ab7e4c64d6e89ad3cf0cf7e07dabbfaf.1794046188.git.zhengqi.arch@bytedance.com>
 <7abb3aa1-385a-422f-86bd-7aac9661c4d8@kernel.org>
 <423c9b28-ecf2-4fab-817d-2fb326690c73@linux.dev>
 <3a1a3bb5-0b01-4f20-aa0e-74a952544b8c@kernel.org>
 <5f68ffba-9f56-4e31-9e7c-9d110f552efc@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <5f68ffba-9f56-4e31-9e7c-9d110f552efc@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zymqdujcms9qqyysi9soz6hr5bs37hpr
X-Rspamd-Queue-Id: 1CEE4C0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794472864-435582
X-HE-Meta: U2FsdGVkX195LKA7HJNewth7bS9T/t3gcup/z9//qvdtwhnjDO3K60VLZhfOv6UFNqHGxU9s8Kr60JanKIVecj3o+JaGwihY8uFnrjzIVYHCZvb0pCgarXy13LPbdqz0Dcez6zYSfUY564G82Dr2jb0xo+Ww49qU0f5a8XFVEujkSV9fxCJQCg99kviPSckShFUV6ND48Ab4HuDSJoQtTTdVInVVMU8tSFru0KrCH0IOQCyFrypzALQzEvcsWOMA8ZoHZ8tnDo3J/WgrAnofQ/1Hpxf86pIdoZtwZnmt13KnQKO3ydlOZI90WxYb7C8YDTwsbEI203f9AW+75A4yLbjjJM/SJ8kKeQG0YAgkaX6JeOh+590l0rXzJvdVNtdjGMMtiQ13ZYEGvBRFrDp2s5hzx70cjWN0wbU0Tiv2BltekcPNaqcRkarrI3QYzewkpqaRpFsi9wzDAcS0D6SsRssZH44+BDpuLQsw+iq+4CmKhkiXmAJ0PQuvdJKyW1JrfrhmHG4pFVZsnRQRLO2WS9g+mmEMA9iWi//DlWFRAuPsh+p85+fTYCbuu7ptDoHyKVrPfN2KVJgSS4QHxMJ0oXjjcbZLPaH/nArew+tFkuTolxFwtltGBP2pQQrnqdTGPdISzOwuLuNoP2JlZ4rUKf8IXt9wv1T9nHmWyM5mrQZYoTBLNViqatyA0CoSc4q/u4cwDbvhZWHUj6vOEsjCOJBSxIuExXy7aKf3An02PHjSzE9OV7GO16n8G2DdPpsnnhoa7q66i9FYG1LRSdeShX9vJG9+EZaDUGkZzjRnbgQ3MGcoQqEUvs6T120p0hqjuDjGzVJJbKVQYAJnKlvPuouinsUXlq50pWKOW5rF1JaAFZzBXLDFNRAj2CkhxRss5iTy3h0RsPoDjlJlfcF0Z6dnj768FYwKxf8KnwDE/75t0aGhD3pI7rpZXlyoxdMVIbAGiiUXH0KL589K+hl
 eFwHOYqL
 1/8JY5Qrtgs85uCC8zwihHWj5P8O32qQ44/EsfwW3tcl2t2JjcgFe0kBuvzkdwS6R83WNUT9hNSa+aywsJt5sbMAsnwdeKXShN/KnZuuHO7AoUQ5XWu/HcgFoLEWvhwz3R0wRCXoneEiERSu6/rjSGZlj7E3Jxlys0dmvdttiL8fwGyJ/dHs+q6lLXgEsa7ksIOr9KZBpK57fABMQ6PWa07CeBF0IkjOhMxTBjsIQC/j5xMb8j7Ktc9ur37aJrXmW0VMQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 11:26, Qi Zheng wrote:
> Hi David,
> 
> On 11/11/26 3:43 PM, David Hildenbrand (Arm) wrote:
>> On 11/9/26 04:10, Qi Zheng wrote:
>>>
>>>
>>>
>>
>> You resent your series way too fast.
> 
> Got it.
> 
>>
>> Now we have discussions in to threads, congratulations ;)
>>
>>> ;), got it.
>>>
>>> I moved the code to resolve a build dependency.
>>>
>>
>> Why can't that be resolved differently? What is the dependency?
> 
> The dependency is that the new check wants to use
> `folio_test_hugetlb_cma()`, which is a HugeTLB-specific inline helper
> from `include/linux/hugetlb.h`.
> 
> `folio_is_longterm_pinnable()` currently lives in `include/linux/mm.h`,
> while `include/linux/hugetlb.h` already includes `linux/mm.h`. So I
> can't simply use `folio_test_hugetlb_cma()` from `mm.h`

It's all so hacky. :)

core-mm shouldn't have to worry about hugetlb internals like
folio_test_hugetlb_cma().

>>>
>>> A generic query may need separate ownership tracking, such as an
>>> owned_bitmap recording successfully allocated pages. Its updates and
>>> lookups would also need to handle concurrency with fast GUP.
>>
>> Or simply two bitmaps? "trying allocation - allocated"
> 
> As a fix, perhaps this is a bit too complex? :(
> 
> Alternatively, we could adjust the timing for setting the bitmap, though
> this might introduce new concurrency issues.

I think we had that order reversed in the past. Likely a second bitmap would
allow us to fix it fairly easily.


-- 
Cheers,

David

