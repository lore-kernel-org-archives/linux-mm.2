Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D56FD606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 01:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sJrXa7wo
Received: by kanga.kvack.org (Postfix)
	id 046546B05B3; Thu, 26 Nov 2026 20:52:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F39576B05B4; Thu, 26 Nov 2026 20:52:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4FB86B05B5; Thu, 26 Nov 2026 20:52:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4C0E6B05B3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:52:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 956ED401F8
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:52:05 +0000 (UTC)
X-FDA: 85479223410.07.D3B2262
Received: from mta0.migadu.com (out-139.mta0.migadu.com [91.218.175.139])
	by imf19.hostedemail.com (Postfix) with ESMTP id 64B451A000A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:52:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sJrXa7wo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.139 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795744323;
	b=r1r1qp98vY0wr4ApXc+0ZZlWpZYYjsLslzOJDVf9827lYTyMd0vWIfUJSWDaOJ0JVCOMr3
	mW68t7bbpw5ckS4+VdUzeJ2vwHQn8jSEJCxgh0gORPbwGhFdHg+dJ7qW1hTLURIPOVmjux
	mOqklNmWeGPsRiXemuV1FpYzfvo5JDE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795744323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M38Po1F2mWwwG6SiyHEY6m3oa8J7m1vdN8oTJmnxVxw=;
	b=TgYk3rZwtJ3RRbTfJHdBjWZRnrk+fiM2wV5Q3DD+BHh8oxrlQlA3YnKHcUaZD3TQeGqVq3
	cN1clCQhCGN/+cHwBul9QWNGs/TGNXZvc4SKX4ES7ehnDTABIAu+m8jehhUjirggRTPF6Z
	V/DLiVpMJsgQlWcG2W9M0oU4vXU/7Ig=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sJrXa7wo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.139 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TTx/GFml7WIrvNctKrEWZFXnmABfvlFSa0Kd3jOAqTU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795744321; v=1; x=1796349121;
 b=sJrXa7wod3YzYj41Zp4LrpoAsRC4xiD/G1lytsyTcz0QIJS0vjOYNe/S4ARJX4SMFNyG4p33
 fP5IBLsTi8pQ1sXb5GWarHmqpp8RpzYbolE2B3HluoySwqr24TGyYtsuZ3+HrNpqWZCjbE8Wrdh
 S48v87EGxc2QYcWsTSwGNPH4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ce53f10fbcd95bb8;
	Fri, 27 Nov 2026 01:52:01 +0000
X-Mizu-Trace-ID: ce53f10fbcd95bb8
X-Migadu-Flow: FLOW_OUT
Message-ID: <cfc18f34-327e-4bd2-ba82-70a50d9541ed@linux.dev>
Date: Fri, 27 Nov 2026 09:51:54 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/mglru: pass a seq range to lru_gen_add_folio()
To: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>,
 Johannes Weiner <hannes@cmpxchg.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Yu Zhao <yuzhao@google.com>,
 linux-mm@kvack.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261125094056.3973331-1-ridong.chen@linux.dev>
 <20261125094056.3973331-2-ridong.chen@linux.dev>
 <CAGsJ_4x1k+-HtNU7zCPcsKwYyYfiW95+Jxrd-SvCWZm8Sq6B0A@mail.gmail.com>
 <d61f15b0-6546-4a11-a749-3c27d743df00@linux.dev>
 <CAGsJ_4wu7dXwcW3dyrqgugXR6uY86oaieprQq0RuDt+=1g55Cw@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4wu7dXwcW3dyrqgugXR6uY86oaieprQq0RuDt+=1g55Cw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 64B451A000A
X-Stat-Signature: pb61moe6t4ywwumaprksbhyds59bzhay
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795744323-285410
X-HE-Meta: U2FsdGVkX1+W1OisXgQo37hNdP1+ss2wyL8zxuXQxe79yCQXGtyEi3M14WcTeW89cZU07pHsUYHPpCrSgv6URdE+FZEpUJEqH2dsHqXnaQjNm/WLVNRafRM6TMWfce3xwQy3NyUGXfHtJ23ofOw9x6Ix3D6zHOPCPEQ3jL7Z1eWoVbB6Jyw5RUjYyb4BDBm2c943MYFKOjJCeetJb8atWQtlalyrCuYk/VlVK6ruTE6kOkxLEC2AiI1rqxinc/pLqdtSiTPXQ9wNVW6ae8meBGUwlxisnfKVKLcl/OlIkvX8k1G5TMYdfGqp0aoNZjqlM3Wh9z+PYRiuoyw8bGDQiJbFafnAHO1GHrHrLfZMV1Eg/OXN7lyiaD86s4P/WTOa7TsilZc9h5+8tdUqoHjUnGpBOImClssMnate0jUarc2TphHvjcqCHDzC8OFQCwtOHU5hS37PNt5gT2buvYZEscSHo01I/gQ+MNneXH0lb6JGjmF/fW40Q2cuEBI1mx0qwTo6jKoveVu+GWZU2jcnjZtBRMe7yJYgLQxuvsuz4Z9BkyJlmoGnMIkaZvSmldPxCnAC/chIOlu2I9bAUZcdX8Ysvp/Tkzqc00+WZ7atHEwBZ0bF05UDQKjQ2hxgcBNq8tzRyzRxFqnCsp8JOfEJbqa4ARL57NZUOUB7rb0BxZDtgxZZKOBsTpdw+jnQfJ+V7xwUMlrHSZmx21ZTneLgWvNJ96doFzFV86KAkrU8vVYg5skVOSPd2eCF0emqO7qnVBerkCeMXvYOGiJWTDC+2/b3leLLYAyF1oa1GGnwPrbo68sVZsVHIJuAdPJtRWDSxtNvDdp/XBZVWy/D9ydHiqGu+PRqLv+wSFgc8m89QR+ysFRFeiL65NgYpXTLlH71h3J5g5rVGYGSz12ci2x9UL4N11sodUcMLOMK/TUl+YxLpr2UZ1hCAZKiuOKhwDV0xhEbrddj8CYs6shLKZ5
 Et7mGs88
 OQZq0Raw6OIyBAyRITcvWcxzfZRjeKn6mm45iCP+L5UFnQikIKxQRWfO7/8aSHyM/eS11MmttleZdmu/Vj9zd2zq0zDDPf092jYHcPRGxmUPikx0r6WfA/IPqMzT20Xjd0uB93jP5/dKnyTK7rQ7n6lZj3gOyCzHP6yIr/zPYvBc25YZ29lNuOXlg2fN4MQEue58otbaorXABrg88XjFtB8fnG/DY55JJXbDDazOm5q3Tjox+p0DUYSdvLfe+9kihYoxVKjKiaeLkPOnIGbcZ6tRfdk0sIBj4IAOo42520SZm1LaQAAe4go/FH8LA7/w4y4mE4E1mlvr18otmEWg5kYsL//cei7kczt4qvHNq0XGd9g8Tx2VKGgWFP8jO2ZAd55d/OdXnaTLrJAv1AGQVX5KX6AvZ2SUjgwk8incOWJragoEYQJ4ZxpcdHR9oWmXnViz5/7zfSRvTamutN4PEkSUNXXwDq3a7J73++8towJ8KmvAZ2io6pHmnf2SEdH2gZWXmXo2wz1y/GxtaGyPGApoD3rZQx70HUoGPrJVWLOH74O2/OtwqSza3LO4qeFr2/ucX93qP1XJCRy0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/26/2026 8:47 PM, Barry Song wrote:
> On Thu, Nov 26, 2026 at 10:16 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>>
>>
>> On 11/26/2026 7:57 AM, Barry Song wrote:
>>>> +/*
>>>> + * Cap the seq to [min_seq, max_seq], see MIN_SEQ_UNBOUNDED and
>>>> + * MAX_SEQ_UNBOUNDED for no limit. With no limit and tail set, the folio is
>>>> + * added to the tail of the oldest gen.
>>>> + */
>>>
>>> Another option is to make tail and gen orthogonal, so that tail
>>> isn't necessarily tied to the oldest gen. This would be similar
>>> to the deactivate path, except that we would only need to set
>>> tail here without changing gen.
>>>
>>> Would that approach work as well?
>>>
>>
>> Yes, that works for me, and it is cleaner. tail will only pick the
>> list end, and the two callers that pass tail=true will pass
>> min_seq[type] as max_seq to keep the folio in the oldest gen, like
>> the deactivate path in patch 2. lru_gen_folio_seq() never returns a
>> seq below min_seq[type], so this gives the same result as before.
>>
>> The changes on top of v3 would be something like:
>>
>> lru_gen_add_folio() drops the if/else:
>>
>>            seq = lru_gen_folio_seq(lruvec, folio);
>>            seq = max(seq, min(min_seq, lrugen->max_seq));
>>            seq = min(seq, max_seq);
>>
>> lruvec_add_folio_tail() is outside CONFIG_LRU_GEN, so it reads
>> lrugen under the #ifdef:
>>
>> ```
>> #ifdef CONFIG_LRU_GEN
>>            int type = folio_is_file_lru(folio);
>>            unsigned long seq = READ_ONCE(lruvec->lrugen.min_seq[type]);
>>
>>            if (lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED, seq,true))
>>                  return;
>> #endif
>> ```
>>
>> fill_evictable() caps only the inactive folios:
>>
>> ```
>>            max_seq = active ? MAX_SEQ_UNBOUNDED :
>>                               READ_ONCE(lruvec->lrugen.min_seq[type]);
>>            success = lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED,
>>                                          max_seq, !active);
>> ```
>> Patch 2 stays the same.
>>
>> Does this look good to you? If so, I will send v4 with it.
> 
> Sounds good to me, thanks! I guess we can gradually move more code from
> include/linux/mm_inline.h into mm/vmscan.h such as lruvec_add_folio,
> lruvec_add_folio_tail etc.
> 
Agreed. I would prefer to keep it out of this series though, since
patch 2 is a fix with a Fixes: tag, and moving these helpers is a
cleanup that touches more callers (mm/folio.c, mm/mlock.c and
mm/vmscan.c).

David also asked for the MGLRU helpers to move out of mm_inline.h in
the MGLRU-FG v6 thread [1], so it may be better done there or on top
of it as a separate cleanup.

[1] 
https://lore.kernel.org/linux-mm/e85a2666-9722-420b-9a60-9d4251fc3d4c@kernel.org/

-- 
Best regards
Ridong


