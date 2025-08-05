Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2564C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 02:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536996B009E; Mon,  4 Aug 2025 22:07:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E75A6B009F; Mon,  4 Aug 2025 22:07:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423C86B00A1; Mon,  4 Aug 2025 22:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3518E6B009E
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 22:07:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD09281DE6
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:07:40 +0000 (UTC)
X-FDA: 83741067480.24.5A00F3E
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf10.hostedemail.com (Postfix) with ESMTP id 074DEC000D
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:07:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of honggyu.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=honggyu.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754359659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1PM+NWDXehPzVqwBOVV6LADsSamdDH23JkMnbsddTvQ=;
	b=7czWLLisX7E4G8ckkSGpUgUAku0FQiOR9n/ufJzlIjDSRgCfCYGKSjdlbbHdHQ7az3TiKm
	NLNlozljn47AbgCJWrQQIo7K+V7DVaJg/wiNOGs4gPW4ptybel3gMYIKN+wAPaU1bTcGar
	YO0dBgEN2JE3CKW2o3PnOiQok9zmXYI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754359659; a=rsa-sha256;
	cv=none;
	b=rOe3HmTEKi4eVa+FBc2/bjoW7uiy2xkRrmdTmaG0fMsYdA5ez+Ew+18kdQBWWnGdqDSUf0
	JfgnulFYUAz55V13rbSfhaUaWrwHKWBflQ4SiBEWwjH1oTTm+lORZ2p8mMlw9hP+vJHKYl
	7W/8NVrY90yIqZNdLUmdim29ixidzco=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of honggyu.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=honggyu.kim@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-669ff7000002311f-75-68916767b781
Message-ID: <9505a27d-e6f6-4cc7-9388-f27262ddff18@sk.com>
Date: Tue, 5 Aug 2025 11:07:34 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: kernel_team@skhynix.com, damon@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: update expired description of damos_action
Content-Language: ko
To: SeongJae Park <sj@kernel.org>, Sang-Heon Jeon <ekffu200098@gmail.com>
References: <20250803174235.55846-1-sj@kernel.org>
From: Honggyu Kim <honggyu.kim@sk.com>
In-Reply-To: <20250803174235.55846-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsXC9ZZnoW56+sQMgxmHJSye/P/NanHiRYLF
	vTX/WS0Of33D5MDisXPWXXaPTas62Tw2fZrE7vFi80zGAJYoLpuU1JzMstQifbsEroz1j3oZ
	C1q0K3p2NDE2ME5V6mLk5JAQMJG4eLaTqYuRA8x+/CsZJMwrYClxbn8jO4jNIqAi8aj1AiNE
	XFDi5MwnLCC2qIC8xP1bM8BqmAXcJK5evwdmCwt4Sux+9IkJIi4iMbuzjRnEFgGKX98ynw3E
	FhIwkljxvgdsDpuAmsSVl5PA6jkFjCU+zpgL1Wsm0bW1ixHClpdo3jqbGeLkGWwSHZ8EIWxJ
	iYMrbrBMYBScheS8WUhWz0IyahaSUQsYWVYxCmXmleUmZuaY6GVU5mVW6CXn525iBIb4sto/
	0TsYP10IPsQowMGoxMN7YvmEDCHWxLLiytxDjBIczEoivDH1/RlCvCmJlVWpRfnxRaU5qcWH
	GKU5WJTEeY2+lacICaQnlqRmp6YWpBbBZJk4OKUaGFdFxG88onR7XU7QReGiupwfJdsbt736
	KzgzqMbw0jr+E1NL9T8uWSld0L1pzqbVHl7eGd06MxbnlnOb6M8uvpbiviBUJa34O+viY3JK
	SbuWR9589O/vDtveaf33LA0fV32fHalbcMxb5savhc89RD/f/GFyclfRpHhPnV6+CjV2A2nz
	s9HXw5VYijMSDbWYi4oTATMg8d1tAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsXCNUNLTzc9fWKGwd6dghZP/v9mtTjxIsHi
	8NyTrBb31vxntTj89Q2TA6vHzll32T02repk89j0aRK7x4vNMxk9Fr/4wBTAGsVlk5Kak1mW
	WqRvl8CVsf5RL2NBi3ZFz44mxgbGqUpdjBwcEgImEo9/JXcxcnLwClhKnNvfyA5iswioSDxq
	vcAIEReUODnzCQuILSogL3H/1gywGmYBN4mr1++B2cICnhK7H31igoiLSMzubGMGsUWA4te3
	zGcDsYUEjCRWvO8Bm8MmoCZx5eUksHpOAWOJjzPmQvWaSXRt7WKEsOUlmrfOZp7AyDcLyRmz
	kKyYhaRlFpKWBYwsqxhFMvPKchMzc0z1irMzKvMyK/SS83M3MQJDdlntn4k7GL9cdj/EKMDB
	qMTDe2HdhAwh1sSy4srcQ4wSHMxKIrwx9f0ZQrwpiZVVqUX58UWlOanFhxilOViUxHm9wlMT
	hATSE0tSs1NTC1KLYLJMHJxSDYxpxuILmw5+rbzx+9vVfXsOScSmisy5wfbE4/vStz/8n8w/
	YLCBW0K1ZzFvZ8KszAUaN5u9Hl51WebkqBSn+TbirYbRo0vh6udFA+0+5M2Ruqwi+6Fd4H5C
	nPc3HoPkunOnRSILLjDt/jmrQdM5UtDh5KIFM56vvL1xSuZPBWbhDc9KMj5YPmZXYinOSDTU
	Yi4qTgQAVDAKklUCAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 074DEC000D
X-Stat-Signature: zestfqocq4fbjna6g7xe91f675qt3gfa
X-Rspam-User: 
X-HE-Tag: 1754359657-658560
X-HE-Meta: U2FsdGVkX1/UqyeRQYKohV27KaeWKXwiFAGCQ0zR0FA0KnMm0DOMd+ckmEK9muGWJIWr57XAlUaXvRtIhJI6Ro8z4gE3QMvGxu+kWPNwqxhSAOjWTJJrb0p9ArZL8O+JGMiQ/czpCTfhtC5IEf1cSZrZ5tbpdEQGUqSI0506BwUwYOr+Pocr+4tDFyYev1WgbjbHVox6M8v/DaXEUdcpPQGdV/rFpX8sf08ESRkllGMW0Y7rhChkYRMHrS4WESxTSnjJv5+D9WIxdJtMgZ7wnDtbQ9aBr08gFHJeAQOEjXAjoxc5UZ+oEJUFn6ESs3z0Miafpf1sU+8rO842MW9hAhcrzOqNGNpy3uLlPu9rgUfAyuDYIivGeR1aWdmNDb+vX3ySgG4CdusGe0CUGs0jIDmxqvgqsZmZk1yMawPds+Pf3ksrfhroXdBxibrJ346197eMwug1Py8Oo7KsQrlD3j2H7lFeR5UXjE8JCYrsXx7ZyEMnW0adWcWYvCbVGQDpH8fbT7125qPykFy4ACCD7B9/A3nye2tQUYlByGNBKXPopRMYSwOInwDgYdOU9bofLFo+I8NWkGmKd6hOwg44pq/5vOfYxPByqxQBoYYZ22XqY+42edd9uYUUsolEEGkOjVXHhU0pUTJ8YjzS4GGl2tGitVntaoAmK8M3OpjdL7ap3hTi63iktKT8PTmjrfHkjMnRk/OfBLxeGAMxSr12CDbHLGco2wv9gUz55j/G6GghJGQ0ljIZzfgZ/zc8bPaLylQuHAGEs+I/qhx++qc6YZNGHSxYf/At+qsPDSAcnqdAo5TFBBO6rvffAy8V/Z9nfUL/OebHe/Gdta9gZM2sFVyom92eKk6Ga9DP2hWTovTxiFNHi+zbvoZjzFiGYk3ii3f1cVLSUhrgxfDnRey6Dwr4Wt4+4XClWmSy6fJfKR7A1o4tHF0/JEN4o7j5FzngPvUDsnhq52QYj8uwC7g
 hhO3crKP
 cUYViaDfGr+RZBQDuXVYenw+ja+NIrhDRdykoC/hGajR4y2LcWE5ip3A3IZ46d3kwaud3lWkoieyVXqbob3afq6rOaYmiCHHQ5BvbOE1XoLqHzrsFxBVAWxnRNubJadZ71D2ledDAp+w0cHiKvLIwnkbOlWrg0UUjXlWd+gq7s88oipU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On 8/4/2025 2:42 AM, SeongJae Park wrote:
> On Sun, 3 Aug 2025 22:22:05 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> 
>> Hi, SeongJae and Honggyu,
>>
>> On Sun, Aug 3, 2025 at 2:41 PM Honggyu Kim <honggyu.kim@sk.com> wrote:
>>>
>>>
>>>
>>> On 8/3/2025 2:30 PM, SeongJae Park wrote:
>>>> On Sun, 3 Aug 2025 13:43:03 +0900 Honggyu Kim <honggyu.kim@sk.com> wrote:
>>>>
>>>>> Hi SeongJae,
>>>>>
>>>>> On 8/3/2025 1:22 PM, SeongJae Park wrote:

[...snip...]

>>>>> The thing is that DAMOS_PAGEOUT call sequence is as follows.
>>>>>
>>>>>      DAMOS_PAGEOUT
>>>>>      -> damon_pa_pageout
>>>>>      -> reclaim_pages
>>>>>      -> reclaim_folio_list
>>>>>
>>>>> In reclaim_folio_list(), it sets "no_demotion = 1" in scan_control, then invokes
>>>>> shrink_folio_list().
>>>>
>>>> Thank you, this clarifies.  DAMOS_PAGEOUT doesn't demote pages even if
>>>> demotion_enabled is set.  Thank you for enlightening me.
>>>
>>> Thank you too. Glad to hear that.
>>>
>>>>
>>>> So, "reclaim" means "reclaim".  shrink_folio_list() can do demotions when
>>>> demotion_enabled is set.  I hence still don't think this patch is saying
>>>> something very wrong, and how it could be improved.  Do you have more specific
>>>> change suggestions for this patch for an improvment?
>>>
>>> I would just like to make the term "reclaim" clearer and we may be able to
>>> define what "reclaim" is.  I think we can choose between the following two
>>> different definitions.
>>>
>>> Definition 1. "reclaim" includes "pageout" and "demotion".
>>> In this case, we better clarify all the other documents that mentions about
>>> those terms.
>>>
>>> Definition 2. "reclaim" only includes "pageout", but "demotion" is out of scope.
>>> In this case, shrink_folio_list just do pageout, but "demotion" is only
>>> exceptional case so we can say the "demotion" escapes from "reclaim" logic.
> 
> I was thinking in the first way, and apparently I was simply wrong.  Now I
> think the second one is more correct, at least for {DAMOS,MADV}_PAGEOUT.
> 
> Yet another way to do the reclaim would be memory.reclaim cgroup file.  Seems
> in the case, demotion can happen since user_proactive_reclaim() doesn't set
> scan_control->no_demotion.

If so, we can't limit the meaning of reclaim into only pageout.

> 
> I didn't read the code, but apparently memory pressure-based reactive
> traditional reclaim logic would also do demotion?

Not sure about "traditional" reclaim logic but demotion logic was introduced not
a long time ago.  The meaning of demotion is meaningful only for tiered memory
system.  I remember tiered memory concept was introduced only about 2+ years
ago.

> 
> So, apparently "reclaim" can mean at least the two definitions.

Yeah, I would like to clarify the definition and make our function names clearer
for better readability.

> 
>>>
>>> We might have to clarify the term "reclaim" for those cases whether it includes
>>> "demotion" or not.  We might have to discuss with other mm developers together.
> 
> I think that could be a nice discussion.  Looking forward to.  As I previously
> mentioned, I don't think we need to have only 1:1 mapping terminologies, though
> I have no strong opinion here.
> 
> Regardless of terms, I agree there are many rooms to improve on our
> documentation.  At least DAMOS_PAGEOUT documentation may better to clarify what
> you pointed out.

I don't have strong objection now even if DAMOS_PAGEOUT uses the term "reclaim"
for now.  I think it will take some time so will leave it for now because I
cannot put this into my top priority list due to other works.

> 
>>> Thanks,
>>> Honggyu
>>
>> Because of the above thread, I got to know the details more clearly.
>> Thank you guys!
>> When the discussion of "reclaim" finishes, I'll make v2 patch as soon
>> as possible.
> 
> I don't think we need to block v2 of this patch for the discussion.  What about
> adding a note about the demotion behavior on the details comment second, e.g.,

Agreed.

> 
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -150,6 +150,8 @@ struct damon_access_report {
>    * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_OPS_PADDR
>    * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
>    * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
> + *
> + * Note that DAMOS_PAGEOUT doesn't trigger demotions.
>    */
>   enum damos_action {
>          DAMOS_WILLNEED,
> 
>>
>> However, I want to talk about a slightly different topic. How about
>> adding support demotion to DAMOS operation action?
>> Maybe we can add another action type or change implementation of DAMOS_PAGEOUT.
> 
> We actually tried to implement DAMOS_DEMOTE, but eventually decided[1] to have
> a more general action called DAMOS_MIGRATE_COLD.
> 
> Do you think there are use cases where DAMOS_MIGRATE_COLD cannot cover?
> 
>>
>> IMHO, I think we should first check whether it's possible to set
>> no_demotion in the `madvise` -> `foilo` flow we're using.
>> Since I'm still quite new to these things, I'd like to check whether
>> my idea and direction are correct.
>>
>> I can't thank you all enough for your kindness :)
> 
> The pleasure is mine :)

mine too :)

Thanks,
Honggyu

> 
>>
>> Best Regards.
>> Sang-Heon Jeon
>>
> 
> [1] https://lore.kernel.org/all/20240614030010.751-1-honggyu.kim@sk.com/
> 
> 
> Thanks,
> SJ


