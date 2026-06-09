Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56578CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 01:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3946B0005; Mon,  8 Jun 2026 21:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA45E6B0088; Mon,  8 Jun 2026 21:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBA4E6B008A; Mon,  8 Jun 2026 21:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA90A6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:26:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 580584039A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 01:26:52 +0000 (UTC)
X-FDA: 84858635064.27.0350277
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf28.hostedemail.com (Postfix) with ESMTP id B208EC000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 01:26:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NDu8XmTw;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780968410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9A9HKNDjCOFxOH9ro8orT7VGeTJr6whymC7UekT3Z6Y=;
	b=mGZUikBebaouoVXvEhg2VzdPvcdC+q/c0MDlD9T5kovOQe4X8yhoGGCG0SbyeTmNtMvnie
	qC+PJSdRCFWOu2IZtJ7htLsy4rmlNcb+g4W9hUDsX/9ZtpvtJNkakPXiZrs60Gj2Iw8cfW
	vIqht3BbYhgX6QkBZvkj8ZcXjEOunkg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NDu8XmTw;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780968410;
	b=78Bw4nwNjZI1XbkgtaTXXiz250UlIf3SEgdx6/5pJHuqV0JYHJeM7KkbmyiwcuNjIi+X9K
	fuP/rnekCS+MWCiy+DOX70ZzUT1873NSI1lzATDO2HyEKH16vizy/OzHHeVJZvpFIwVNPc
	/X3UBD1UWO1Ie4zIryCTewgbfiCZjOg=
Message-ID: <ebcbe4a8-127b-4d12-83f1-dec93f0a9c61@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780968407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9A9HKNDjCOFxOH9ro8orT7VGeTJr6whymC7UekT3Z6Y=;
	b=NDu8XmTw15FLxN75fltkeRI9h3xD8mEddL7iQKFF0S+FyoIYNJ/utCXwZr8GUH/2YsT0wj
	pRpbccaHRhf1op49DtLCG0fdEWnDrAjbmFqH/SpaisKRPguSw4+PWFb5KUmNEVgu3FF0Ab
	NUxOKJgqM1nm3HQlGBGgYy5G6eqSaSw=
Date: Tue, 9 Jun 2026 09:26:03 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 4/6] alloc_tag: add accuracy based filtering to ioctl
To: Suren Baghdasaryan <surenb@google.com>
Cc: Abhishek Bapat <abhishekbapat@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
References: <cover.1780701922.git.abhishekbapat@google.com>
 <b608a6f7d71e3b728f766dbc6dfa1d1753ddcff5.1780701922.git.abhishekbapat@google.com>
 <1ec17313-cd2b-4389-a05d-998757af30b3@linux.dev>
 <a58e659e-5f54-4511-9a29-dc921002d102@linux.dev>
 <CAJuCfpHtdd=9D68cfRp4HDHHHCZdzTNP_RH9i2D-f9tJXht56A@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpHtdd=9D68cfRp4HDHHHCZdzTNP_RH9i2D-f9tJXht56A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B208EC000C
X-Stat-Signature: 6e8e17546oiuncc8a7hnxj6pc39wtcw9
X-Rspam-User: 
X-HE-Tag: 1780968409-252020
X-HE-Meta: U2FsdGVkX183ltY0CNZMjNZl9aRJi8hlm/yiEYMNCBIxyWEeaSfYAX7di14Q1CH4KnrIdeAF13uvoujZfzQEbT81Twedh5ITkxjqQPbf9k5WKm6jXfF2u8ZvTO0EtPPFA7yMhu5cxM4Sh067SLDLp6awvB/AcYfOwghRNIvGgH0JcihXGkdt3mnS/LHHkOpu6hfIV59jIZnIm+zPhiYnFHQKuz3KJ1MUAhXDYl2QZQde1lAnYul8m6g8OEG9iR+k7/cww7J2XI7ucSoEj1stRSKc8CXnQ1P9GN8gjfdJBQyk7qHshj7V0ccdBFjVGEgOsgw5QhltRn4WM0t+TAzPHNZqsuj2Pqz9CJCWb7zRbSctGsXxerTUqNwiA+gUrPl+bGLTZnoZ5rcPYrpAIi2VkIE5cgauS4kCv11gD/PLiW6cEOdaCY0iBfzH2a/74WIEy+5hx8dYECMw+vSLzogPlZ7RQqhaY87ND69ffiWUim4e630Bs1uOi6r17BqsVz8JNKUzWUIZ1JgnDmi8rCR80MbZuSmnM7YH9qsA2au+1jnKq1WTI5te0gWRl91z8i2T7Mhd+//grzfzlarOi8Mc0P7nyupakOP9l/jv8Nnh5D9LRnMs2fTlkZEbGPGPPX+jrTsG3UXe4yYCmwlzvb7SceidpHN1d5I9rrEUa5rgsZqflnf3/EPFCeCUbjBSeY5xMRq2NnNPqL352oYXpkJUmc0sd9tBGDQKc4bB02GYPtUYMZaj+ceQ4EFpwl5XkDysI2nJhJZYrzJEqi4IesXgG0d99zkVmNejBdvX/6PVCeqSF+p9VGV71WjkmnDLWADSjZkuSeUoYOuVBYXjTFiUp860yyHfdHABFdRkAPM6VAiVykD5HgITyDjVjModLpkRiDhGTyG2XGjVDaHOiaoynuMbq5ZyD/8hQhpuVFtn1rAbOwTDKsMIbV+Y1Eduh0Sm1wZQBNze/FlDCADbGX0
 V/j6urJk
 zLI0r/gY3XnFVEhJvpZAGBz7uy8qZwdxOGXAJ0qRfXhVWsCzVyl2UAcw1iVEFhgfD4T0IZWeU7eFDJW+wgz4c6U/PD8f07XQTopBEpaKZ8yca5CVskRn3yrARXvcLxPNJ/Z0qt8qaY6KKB8iArNv0IUcJK1udVVqbdU/jKuQw5yfKMAmwNFBgj1TJ9DZqJeRP9juayFXr2De+pB5PdLMLfaaczLnRWgtrnbVpuV4Y35+jussdhrwigX+puw5fFUjdUZI8BpQV5KtCmyjPBSJX/IQitGgbyFjH0TlAZVmR9bq7JV+tKZDS9Y9NJcVVr5Ab8Dbu1IbrCT5iqV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren


On 2026/6/9 04:55, Suren Baghdasaryan wrote:
> On Mon, Jun 8, 2026 at 1:25 AM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> On 2026/6/8 14:22, Hao Ge wrote:
>>> Hi Abhishek
>>>
>>>
>>> On 2026/6/6 07:36, Abhishek Bapat wrote:
>>>> Extend the allocinfo filtering mechanism to allow users to filter tags
>>>> based on their accuracy.
>>>>
>>>> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
>>>> ---
>>>>    include/uapi/linux/alloc_tag.h | 3 +++
>>>>    lib/alloc_tag.c                | 8 ++++++++
>>>>    2 files changed, 11 insertions(+)
>>>>
>>>> diff --git a/include/uapi/linux/alloc_tag.h
>>>> b/include/uapi/linux/alloc_tag.h
>>>> index 0e648192df4d..42445bdb11c5 100644
>>>> --- a/include/uapi/linux/alloc_tag.h
>>>> +++ b/include/uapi/linux/alloc_tag.h
>>>> @@ -20,6 +20,7 @@ struct allocinfo_tag {
>>>>        char function[ALLOCINFO_STR_SIZE];
>>>>        char filename[ALLOCINFO_STR_SIZE];
>>>>        __u64 lineno;
>>>> +    __u64 inaccurate;
>>>
>>> I was wondering if it would make sense to define inaccurate as a flags
>>> field
>>>
>>> (e.g. __u64 flags with ALLOCINFO_TAG_F_INACCURATE (1 <<0)),
>>>
>>> so that only bit 0 is used today and the upper bits are reserved for
>>> future use,
>>>
>>> aligning with current kernel codebase.
>>>
>>> This design also allows for better extensibility if we need to
>>>
>>> add new flags for any reason in the future.
>>>
>>> We also need to add flag validity checks if we go this route.
>>>
>> And I've reviewed the issue reported by Sashiko, and I think it's valid.
>>
>> When we expand the allocinfo_tag_data structure
>>
>> struct allocinfo_tag_data{
>>
>>       char modname[64];
>>
>>       char function[64];
>>
>>       char filename[64];
>>
>>       __u64 lineno;
>>
>>       __u64 inaccurate;
>>
>>       __u64 bytes;
>>
>>       __u64 calls;
>>
>>       __u8 accurate;
>>     /* padding */
>>
>> }
>>
>> I think user space may see two fields related to inaccuracy.
> Yes but one field (inside allocinfo_tag) is the input parameter which
> user provides to specify the filtering criteria and the other is the
> returned tag information. It's similar to any other tag attribute
> which you can be included in the filters.
>
>> How do you like these modifications?
>>
>>
>> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
>> --- a/include/uapi/linux/alloc_tag.h
>> +++ b/include/uapi/linux/alloc_tag.h
>> @@ -20,7 +20,6 @@ struct allocinfo_tag {
>>        char function[ALLOCINFO_STR_SIZE];
>>        char filename[ALLOCINFO_STR_SIZE];
>>        __u64 lineno;
>> -    __u64 inaccurate;
>>    };
>>
>>    /* The alignment ensures 32-bit compatible interfaces are not broken */
>> @@ -40,7 +39,7 @@ enum {
>>        ALLOCINFO_FILTER_FUNCTION,
>>        ALLOCINFO_FILTER_FILENAME,
>>        ALLOCINFO_FILTER_LINENO,
>> -    ALLOCINFO_FILTER_INACCURATE,
>> +    ALLOCINFO_FILTER_FLAGS,
>>        ALLOCINFO_FILTER_MIN_SIZE,
>>        ALLOCINFO_FILTER_MAX_SIZE,
>>        __ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
>> @@ -50,16 +49,20 @@ enum {
>>    #define ALLOCINFO_FILTER_MASK_FUNCTION        (1 <<
>> ALLOCINFO_FILTER_FUNCTION)
>>    #define ALLOCINFO_FILTER_MASK_FILENAME        (1 <<
>> ALLOCINFO_FILTER_FILENAME)
>>    #define ALLOCINFO_FILTER_MASK_LINENO        (1 << ALLOCINFO_FILTER_LINENO)
>> -#define ALLOCINFO_FILTER_MASK_INACCURATE    (1 <<
>> ALLOCINFO_FILTER_INACCURATE)
>> +#define ALLOCINFO_FILTER_MASK_FLAGS        (1 << ALLOCINFO_FILTER_FLAGS)
>>    #define ALLOCINFO_FILTER_MASK_MIN_SIZE        (1 <<
>> ALLOCINFO_FILTER_MIN_SIZE)
>>    #define ALLOCINFO_FILTER_MASK_MAX_SIZE        (1 <<
>> ALLOCINFO_FILTER_MAX_SIZE)
>>
>>    #define ALLOCINFO_FILTER_MASKS \
>>        ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
>>
>> +#define ALLOCINFO_FILTER_F_INACCURATE    (1ULL << 0)
>> +#define ALLOCINFO_FILTER_FLAGS_ALL ALLOCINFO_FILTER_F_INACCURATE
>> +
>>    struct allocinfo_filter {
>>        __u64 mask; /* bitmask of the filter fields used */
>>        struct allocinfo_tag fields;
>> +    __u64 flags; /* bitmask of ALLOCINFO_FILTER_F_* */
>>        __u64 min_size;
>>        __u64 max_size;
>>    };
>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
>> --- a/lib/alloc_tag.c
>> +++ b/lib/alloc_tag.c
>> @@ -249,8 +249,6 @@ static bool matches_filter(struct codetag *ct,
>> struct allocinfo_filter *filter,
>>                   struct alloc_tag_counters *counters,
>>                   bool *fetched_counters)
>>    {
>> -    bool inaccurate;
>> -
>>        if (!filter || !filter->mask)
>>            return true;
>>
>> @@ -277,10 +275,11 @@ static bool matches_filter(struct codetag *ct,
>> struct allocinfo_filter *filter,
>>            ct->lineno != filter->fields.lineno)
>>            return false;
>>
>> -    if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
>> -        inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
>> -        if (inaccurate != !!(filter->fields.inaccurate))
>> -            return false;
>> +    if (filter->mask & ALLOCINFO_FILTER_MASK_FLAGS) {
>> +        if (filter->flags & ALLOCINFO_FILTER_F_INACCURATE) {
>> +            if (!(ct->flags & CODETAG_FLAG_INACCURATE))
> How would you filter records which have only accurate data?


Sorry, I overlooked this case.

Since allocinfo_tag_data exposes both inaccurate (from allocinfo_tag) and

accurate (from allocinfo_counter), userspace developers might mistakenly 
read

inaccurate instead of accurate when checking accuracy.

How about we add a comment to clarify?

struct allocinfo_tag {

     /* ... */

     __u64 lineno;

     /* filter criteria only; see allocinfo_counter.accurate for actual 
accuracy */

     __u64 inaccurate;

};


LGTM for the rest.


Thanks

Best Regards

Hao

> Overall I would prefer ALLOCINFO_FILTER_MASK_INACCURATE rather than
> ALLOCINFO_FILTER_MASK_FLAGS. The fact that this attribute is a
> single-bit flag is a technical detail. It's still a tag attribuite
> like file and module names and IMO deserves its own filter.
>
>
>
>> +                return false;
>> +        }
>>        }
>>
>>        if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE |
>> ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
>> @@ -318,6 +317,10 @@ static int allocinfo_ioctl_get_at(struct seq_file
>> *m, void __user *arg)
>>        if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
>>            return -EINVAL;
>>
>> +    if ((params.filter.mask & ALLOCINFO_FILTER_MASK_FLAGS) &&
>> +        (params.filter.flags & ~ALLOCINFO_FILTER_FLAGS_ALL))
>> +        return -EINVAL;
>> +
>>        if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
>>            (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
>>            params.filter.min_size > params.filter.max_size)
>>
>>
>> Thanks
>>
>> Best Regards
>>
>> Hao
>>
>>
>>> Thanks
>>>
>>> Best Regards
>>>
>>> Hao
>>>
>>>
>>>>    };
>>>>      /* The alignment ensures 32-bit compatible interfaces are not
>>>> broken */
>>>> @@ -39,6 +40,7 @@ enum {
>>>>        ALLOCINFO_FILTER_FUNCTION,
>>>>        ALLOCINFO_FILTER_FILENAME,
>>>>        ALLOCINFO_FILTER_LINENO,
>>>> +    ALLOCINFO_FILTER_INACCURATE,
>>>>        ALLOCINFO_FILTER_MIN_SIZE,
>>>>        ALLOCINFO_FILTER_MAX_SIZE,
>>>>        __ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
>>>> @@ -48,6 +50,7 @@ enum {
>>>>    #define ALLOCINFO_FILTER_MASK_FUNCTION        (1 <<
>>>> ALLOCINFO_FILTER_FUNCTION)
>>>>    #define ALLOCINFO_FILTER_MASK_FILENAME        (1 <<
>>>> ALLOCINFO_FILTER_FILENAME)
>>>>    #define ALLOCINFO_FILTER_MASK_LINENO        (1 <<
>>>> ALLOCINFO_FILTER_LINENO)
>>>> +#define ALLOCINFO_FILTER_MASK_INACCURATE    (1 <<
>>>> ALLOCINFO_FILTER_INACCURATE)
>>>>    #define ALLOCINFO_FILTER_MASK_MIN_SIZE        (1 <<
>>>> ALLOCINFO_FILTER_MIN_SIZE)
>>>>    #define ALLOCINFO_FILTER_MASK_MAX_SIZE        (1 <<
>>>> ALLOCINFO_FILTER_MAX_SIZE)
>>>>    diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
>>>> index ddc6946f56ab..cbcd12c4ef9c 100644
>>>> --- a/lib/alloc_tag.c
>>>> +++ b/lib/alloc_tag.c
>>>> @@ -249,6 +249,8 @@ static bool matches_filter(struct codetag *ct,
>>>> struct allocinfo_filter *filter,
>>>>                   struct alloc_tag_counters *counters,
>>>>                   bool *fetched_counters)
>>>>    {
>>>> +    bool inaccurate;
>>>> +
>>>>        if (!filter || !filter->mask)
>>>>            return true;
>>>>    @@ -275,6 +277,12 @@ static bool matches_filter(struct codetag *ct,
>>>> struct allocinfo_filter *filter,
>>>>            ct->lineno != filter->fields.lineno)
>>>>            return false;
>>>>    +    if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
>>>> +        inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
>>>> +        if (inaccurate != !!(filter->fields.inaccurate))
>>>> +            return false;
>>>> +    }
>>>> +
>>>>        if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE |
>>>> ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
>>>>            if (!*fetched_counters) {
>>>>                *counters = allocinfo_prefetch_counters(ct);

