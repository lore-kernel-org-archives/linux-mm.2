Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57D15CCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 09:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39A8D6B0096; Fri, 16 Oct 2026 05:50:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 373F06B0098; Fri, 16 Oct 2026 05:50:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AF306B0099; Fri, 16 Oct 2026 05:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0736D6B0096
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:50:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E59191A02E9
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:50:36 +0000 (UTC)
X-FDA: 85328019672.18.A58E40F
Received: from mta0.migadu.com (out-130.mta0.migadu.com [91.218.175.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id E89091C0003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:50:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JL0N5Wr3;
	spf=pass (imf18.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.130 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792144235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIHiQO2iU+3s2dmYIz75jECCOubarC3jPXZ88NA1S0s=;
	b=3nLkQUy0XG8lNLDjZzWnyxCvY2i6qOVT+Yply/JiojgNdySkWcGg2ozw4atK0LrCL3fnJY
	LkeJGYoK6nzvgR8xrkRMAAVhlKK5lM3kddb78tW4lYm/QoOZjNRLQsU2z3tGVgLovlWWbs
	MGTZIE/uMndXXFebgOBPP8YLuxInc9s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792144235;
	b=M9fo7VgRRLgFngf01NOlIre56j9rPPJFp3Hq1ZlCjqUqbZmO8OMKHWk69iKJWua18M1FiZ
	8C1dOQYt48FyOAY/om0fj5Fv+zbbLCM0Vz4Y37wBFWUq7hwt3UEK39VJHHxnEBEm8HdMZD
	bwfDUL8M+xvjVLx8LnrichK8gT2GkmA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JL0N5Wr3;
	spf=pass (imf18.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.130 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6etTptRp+LrfSLSHwwV/0Uxy/guPz+lham75CQKW3uU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792144233; v=1; x=1792749033;
 b=JL0N5Wr3sz2OcO1RheLqCjnnHDYPVUhRaFfA3KsDXrWNrnzSi04s6//9v+EIatPrSe7MOVyT
 iG0lYLJoYp3/bdFeGqyrpwsZatGMfGB3E5WneFj3pC5wMGdRpYZUYz2w9h8NgFb8wCy2iEi6y/R
 YjZXxmr0yF0pHS2ZGa4FwcYA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1b3b6dc6d678a515;
	Fri, 16 Oct 2026 09:50:32 +0000
X-Mizu-Trace-ID: 1b3b6dc6d678a515
X-Migadu-Flow: FLOW_OUT
Message-ID: <ce35f31f-3805-47b6-a953-ba55637b4181@linux.dev>
Date: Fri, 16 Oct 2026 17:50:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] proc: Move OOM-related procfs code to fs/proc/oom.c
To: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Ye Liu <liuye@kylinos.cn>
References: <20261014-oom_procfs-v1-1-f2d75e73571e@linux.dev>
 <as9MG_BtepLV6DsC@tiehlicka> <e51c14e9-5559-4ff7-8a38-de815a8f8230@linux.dev>
 <atCw0gk77fF5ISQV@tiehlicka>
Content-Language: en-US
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <atCw0gk77fF5ISQV@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E89091C0003
X-Rspam-User: 
X-Stat-Signature: ciajw4obkcyg9eitrydttnkncejaz4fc
X-HE-Tag: 1792144234-162614
X-HE-Meta: U2FsdGVkX19RIE7MvZfgRqB1De81l1/t6EMhe8R9HYH/mhuTlBbN5npagQafIEcoKERQkXZPba06Pq/1lLKyD+s5/eeFMMor52u6QZc2lGBUCXAZtlXjALnHmO4mzz7TIxAEk/ZG37d8TqOEjosv+i/l3h6MHmu8f6L6mOYOdGbYli+zSG0D9mDEDfgT8N97cO1c5rmMruQimEkEZbtbeslMG29urmxbLgZWKsDLhqucxIHd/oBIdX77fQBHV4+HfzhPHnjhf/eEa7kivAEQaULlaC85O6CaqzUjgnXiaAgsNjXKstiGoHIwCn3tqURM/rgb1M4hjxY8cxxOpZl4dYhwvZKUZNWmXBXDFuP/sJFRXR0Butu8s+ZLVbk9hAM8Y2nL2+6TG6W2n6jHiJP5xJWPUIUyH3KX161pn1rSRv+pryM3/TiUyy1pvqd8kWyf2aZ7QQwFPJYwg6LQvjmdfuWzXcU07QlXlAjDivVnjS9rzTwNex3wWC/H8uDnCFNEA1D3ehamF0hT5VGvPcLCdO20yFPeGvdv3SSfTlhLOkIpp16MLg3F0nvzM90DB0HYeiGhUc8hjtb3QiQFHqYOZU755xvNBA7W2wOqSiyLwg9SfbiIT0O8ET7mLt5P+X5s1BDjFAkcOOZmGLOUFB3BMez7y3fuoVPwooLEu7GiZOiKv9DxOgi94kGFi8JN0nvrFFjONICN4r4M1hZ5LTpJSMXucJ+eWGr9fUAO2+0/Dc/GMIB7EmsI9Xq9RZFZjIoswIEA4hLel+D30Kvf5vUCgLKPkbqT/1QXEfNl6meQ2tGb+U585DVgEpkxWad5ojE8B9wzGB2YsoVa59wFVPIpwc6ppRlZ/Lx0M0UyHaDR/KydnrSbT7B3zNp/mJPegHkcovRdrc3IeSaDveU9cJ/vSDbwx2NKxL77XVJxm1NLgWiZQ3HWA2OdTqUM+zWONsUGsbmQIlFzPlHpubvSoQb
 LXsaU5Sn
 3eS3ZaflDOhInQ8taEZNDF95Ui6gBu2q3Z3D2ydHUax3rAjqmcwC6FcQ2vt6RFSZ3WWRaV0Tu5cnxGKNRlWtF8Kl6hgbf6tPQjVSL2aWpeNULexltFtcbw52MdC78x7akYxk4PNcCLsY3UeQ4sK4Pwe7FbLZI9oygd2t62OQCPIfBCvuapBHy7tVkbKfAjO/2eKkj3NLUKXDdqM7vibIKftQWKSagR1GQNbMO0rxb12vR+KsVaoW9gFfxczuS/pjmLCUViLXPnWNa9TwOy2ovw9zXkxtU5rptzeidrMn9wQkkbQ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/10/15 18:54, Michal Hocko 写道:
> On Thu 15-10-26 09:32:53, Ye Liu wrote:
>>
>>
>> 在 2026/10/14 17:32, Michal Hocko 写道:
>>> On Wed 14-10-26 16:54:12, Ye Liu wrote:
>>>> From: Ye Liu <liuye@kylinos.cn>
>>>>
>>>> fs/proc/base.c is a large file (~3700 lines) handling all per-process
>>>> procfs entries. The OOM score, oom_adj, and oom_score_adj interface
>>>> code is self-contained and has no dependencies on other parts of
>>>> base.c, so move it into a dedicated fs/proc/oom.c following the same
>>>> pattern as fs/proc/fd.c and fs/proc/task_mmu.c.
>>>>
>>>> This makes both files easier to read and keeps OOM-related procfs
>>>> entries together in one place.
>>>
>>> Are there plans to separate other functionality or is this one off
>>> thing?
>>> In general I am not against of moving stuff to more specialized files.
>>> An obvious downside is a review as it is quite easy to overlook a subtle
>>> change when moving so much code. Something worth undertaking if there
>>> is a bigger goal. Not so sure if this is just a one of and fs/proc/base.c
>>> still keeps other random stuff in.
>>>
>>
>> Hi Michal,
>>
>> This is a one-off move specifically for the OOM-related procfs code.
>> I don't have a broader plan to split up fs/proc/base.c at this time.
>>
>> I understand the concern about subtle changes during code moves.
>> To address that, the patch is a pure relocation with no functional
>> modifications — all function bodies are moved verbatim. 
> 
> But you do understand that I effectivelly need to redo the patch to
> confirm this is the case, right?
> 
> This is something I am not particularly thrilled to do for a single
> isolated patch without a larger plan. taks_mmu.c will remain a huge pile
> of code after this change. So what's the point for all that effort?
> 
My familiarity with fs/proc/base.c is currently limited to the OOM-related
code. Meaningfully splitting other parts of base.c would require time to
study those modules first, which I don't have available in the near term.
I may revisit a broader cleanup when I have the bandwidth to do it properly.

For now, I'd like to withdraw this patch rather than leave it hanging.

Appreciate the review.

-- 
Thanks,
Ye Liu


