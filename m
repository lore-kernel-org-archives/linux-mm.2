Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EEB9CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B612D6B0005; Mon,  8 Sep 2025 05:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B395F6B0008; Mon,  8 Sep 2025 05:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75DF8E0001; Mon,  8 Sep 2025 05:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 94F006B0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:34:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A6F986E7E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:34:08 +0000 (UTC)
X-FDA: 83865571776.09.4D0A166
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id BD870140008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:34:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iv0p7UWz;
	spf=pass (imf09.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757324046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEEBVaVKlKHbQ45HKM4XzjEJWmhD75GPFAdeX7JNCvc=;
	b=b7Pq9QXJQXti/zyGJLeAsjsHzxbN6bWe2Uo1ByfCIVKYChW2qLwvqFeSCpvjuv5KOSgSSx
	e88AXkyDKENTEKnmgg5RRcFxdE6ZfHtaa/cQ6RRGsXe41FpYJqb3mH7Re7zwWKozQotzYP
	aFJb2PsbUxv7QGOFYn/N1V+YnCcAlRs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iv0p7UWz;
	spf=pass (imf09.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757324046; a=rsa-sha256;
	cv=none;
	b=gAPJA6UtIWy5NxyYzVVy95ZFG1nBjw5VYPOHj9hLwrcaSKybiC+UQKQu2IsyRBpj06rd3k
	89v01YzUJX76WtYrINPaje9la1JABqvqfQnP4c9QKOrUD1HZn/Cb7pB83grwaoRTkpQvLK
	Ji6y228xQS7KHK0xykkOd5Q9/ab6b78=
Message-ID: <f7728a4a-7af9-4d7b-a06d-d61b697eaeef@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757324042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KEEBVaVKlKHbQ45HKM4XzjEJWmhD75GPFAdeX7JNCvc=;
	b=iv0p7UWzXnmJ44EqNPGvW4uieAmGmQyWh3pgPbGcGOi4uNxXJx28fOc9ld0xj/fRPbOds9
	UG+KamYHwAXIR4QOMYHMq7tcM0v3TC2JXl8bzW7cVVaNIGArVRF3GoAjPI0cbn4jWos9uf
	isupz2ncnCaqkJ6zGD+l350V0PCkdoE=
Date: Mon, 8 Sep 2025 17:33:57 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/slub: Refactor note_cmpxchg_failure for better
 readability
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250908071922.1062170-1-ye.liu@linux.dev>
 <aL6WTrXczZJYUoGb@hyeyoo> <c089b941-97c7-4392-828f-923e8da3510a@linux.dev>
 <aL6gMEvR8RqW7YrE@hyeyoo>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <aL6gMEvR8RqW7YrE@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: cxcp3ibxqosgnjcgom7qu1itd3wrwd86
X-Rspam-User: 
X-Rspamd-Queue-Id: BD870140008
X-Rspamd-Server: rspam01
X-HE-Tag: 1757324044-933168
X-HE-Meta: U2FsdGVkX19rUqGg9F2aVaxiuwywwr7czcHPJgrBX/LRA550iCrJhxElmP80wK2lQk6kuj8/qMGwsb6OB+zCDcMEtTBz26I2T0k2pcb2M4r8Fyt5rIgidgRX5uKGZqruEdDim5fh5vjVB3F3PQ3Nr6usFaj6tl60rBLmIu8P3gn73aAsqz+PSzQXVRueEoAqe6qd1lWN6SMeU5nWPaqi7e/SINmg2PopUB7sKl1whb3HkuHmzcflCpfb79aA+flAn31m6dFRWFaBaTBpJe2k8FZUCk026LjoGvx0tEGJSEFGV5rlpnha429B5nNwqErmJ5kV4jbJzdsLPvdFpXGJBoO+SZoUDJNKEDWCwqCDbnIBGjt3YeBJzILKTwaEMTrRzV9ZjSAJre+m26DSNRgVKgl3kdwYk8wi/HjyMGaTMg105WJmHs3rEyHoNy9hHzElHY4IBLcWUq6tC2M+trnRNv1nHRD6YjT0QPzF/KaWS6oC582mj4/LgLZxaPIPjAG/zFKKcmlEG6w31SZKsK1+fc3pFU5jCW2GjXNvNYWyYC1rpjT/VxitL15oTLB8u315HEb9ky4A7HHKHORtJLXTVx0tnw7NOitEvs7HwzkTuvLjT0pytOhAfIS8Zli/K3zYEqxtVklnNJxCk+9XO3nOToqN9SaAK49mrfqPTbX7MVmXCTHFoGfv73ewKjlENFm50KYbdbt14sxKMJKkoT9fXejxq0CClTa+y23TL1PMcUwumFyKSzYpYJzwLHlv9mQK+0dKrv69lItaNYGFu3ViTnV4CdV+N85z6oNGoYyg031f5BMLeg2bvWAOoOt7ZdZa3gZuIC1+uk8OmTOl4DIcxNeoxWGSeU8lbAfXjCgdCn02rQH+8p5HQRgNms3t8Uz8o8u+JU7gyi+cj5+iCAHxDOjpTmyBt89hrZH+Em98BjYCvO4N+f4bkF9VdWvuxz+qY4HPwB9C1tKCE/t99t2
 3hgMhw56
 zMcihAB0m0vYePrwhQM49LLuuM5lcPqPGIf+XAs7NBo6CMjDqqKvwnRejf1c/nl71ZU2eEGQep7TssLSrpXDamrLq+j7xfq1nN/9VYCyNNG1HO2AsSNnHGyFkP5yKbM44dC0PnBWSreyXFJPPKwj+NVda4H3d/w0QTVkhR6eMTHwCJCVbjg3/BAiJd5/j5ONE2Ead7cb4oZ/+rY9WzgreB6Qrfk/79eTQBuyJiOnQo0qv3RTzG7OawnpVe5eANRj+EoAr4R3kQWG3lcu1OIkyv6+RCwZE2B68XPp1Pt0sekNhWdWR4AfxfE4s4EzK8H7wPq9UjRHTAcm5c8N0GzKiSy4r8s48kJkysu5CcR7J9n7AC/ChsEkUSTcVEbQPlxckcEMsfJR/z6TloVk4zSGgHt/CO/3qRFuAcSS8nfI0A7cyIHY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/9/8 17:21, Harry Yoo 写道:
> On Mon, Sep 08, 2025 at 04:56:40PM +0800, Ye Liu wrote:
>>
>>
>> 在 2025/9/8 16:39, Harry Yoo 写道:
>>> On Mon, Sep 08, 2025 at 03:19:21PM +0800, Ye Liu wrote:
>>>> From: Ye Liu <liuye@kylinos.cn>
>>>>
>>>> Use IS_ENABLED() and standard if-else to make the code clearer.
>>>>
>>>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>>>> ---
>>>
>>> Looks good to me,
>>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>>
>>> with a nit,
>>>
>>>>  mm/slub.c | 10 ++++------
>>>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/mm/slub.c b/mm/slub.c
>>>> index 30003763d224..34853c0441a6 100644
>>>> --- a/mm/slub.c
>>>> +++ b/mm/slub.c
>>>> @@ -3064,18 +3064,16 @@ static inline void note_cmpxchg_failure(const char *n,
>>>>  
>>>>  	pr_info("%s %s: cmpxchg redo ", n, s->name);
>>>>  
>>>> -#ifdef CONFIG_PREEMPTION
>>>> -	if (tid_to_cpu(tid) != tid_to_cpu(actual_tid))
>>>> +	if (IS_ENABLED(CONFIG_PREEMPTION) && tid_to_cpu(tid) != tid_to_cpu(actual_tid)) {
>>>
>>> nit: insert newline after && as it's more than 80 columns?
>>
>> I noticed this too, but using the script ./scripts/checkpatch.pl , there were no warnings.
>>
>> $ ./scripts/checkpatch.pl 0001-mm-slub-Refactor-note_cmpxchg_failure-for-better-rea.patch 
>> total: 0 errors, 0 warnings, 22 lines checked
>>
>> 0001-mm-slub-Refactor-note_cmpxchg_failure-for-better-rea.patch has no obvious style problems and is ready for submission.
> 
> IIUC the default limit is increased to 100 characters in checkpatch
> but 80 characters is still preferred.
Thank you for your patience.
I will update the V2 version and include your Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> 
> Quoting Documentation/process/coding-style.rst:
> 
> 2) Breaking long lines and strings
> ----------------------------------
> 
> Coding style is all about readability and maintainability using commonlu
> available tools.
> 
> The preferred limit on the length of a single line is 80 columns.
> 
> Statements longer than 80 columns should be broken into sensible chunks,
> unless exceeding 80 columns significantly increases readability and does
> not hide information.
> 
> Descendants are always substantially shorter than the parent and                
> are placed substantially to the right.  A very commonly used style              
> is to align descendants to a function open parenthesis.                         
> 
> These same rules are applied to function headers with a long argument list.
> 
> However, never break user-visible strings such as printk messages because
> that breaks the ability to grep for them. 
> 
> And also quoting a commit message:
> 
> commit bdc48fa11e46f867ea4d75fa59ee87a7f48be144
> Author: Joe Perches <joe@perches.com>
> Date:   Fri May 29 16:12:21 2020 -0700
> 
>     checkpatch/coding-style: deprecate 80-column warning
> 
>     Yes, staying withing 80 columns is certainly still _preferred_.  But
>     it's not the hard limit that the checkpatch warnings imply, and other
>     concerns can most certainly dominate.
> 
>     Increase the default limit to 100 characters.  Not because 100
>     characters is some hard limit either, but that's certainly a "what are
>     you doing" kind of value and less likely to be about the occasional
>     slightly longer lines.
> 
>     Miscellanea:
> 
>      - to avoid unnecessary whitespace changes in files, checkpatch will no
>        longer emit a warning about line length when scanning files unless
>        --strict is also used
> 
>      - Add a bit to coding-style about alignment to open parenthesis
> 
>     Signed-off-by: Joe Perches <joe@perches.com>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
>>>>  		pr_warn("due to cpu change %d -> %d\n",
>>>>  			tid_to_cpu(tid), tid_to_cpu(actual_tid));
>>>> -	else
>>>> -#endif
>>>> -	if (tid_to_event(tid) != tid_to_event(actual_tid))
>>>> +	} else if (tid_to_event(tid) != tid_to_event(actual_tid)) {
>>>>  		pr_warn("due to cpu running other code. Event %ld->%ld\n",
>>>>  			tid_to_event(tid), tid_to_event(actual_tid));
>>>> -	else
>>>> +	} else {
>>>>  		pr_warn("for unknown reason: actual=%lx was=%lx target=%lx\n",
>>>>  			actual_tid, tid, next_tid(tid));
>>>> +	}
>>>>  #endif
>>>>  	stat(s, CMPXCHG_DOUBLE_CPU_FAIL);
>>>>  }
>>>> -- 
>>>> 2.43.0
>>
>> -- 
>> Thanks,
>> Ye Liu
>>
>>
> 

-- 
Thanks,
Ye Liu


