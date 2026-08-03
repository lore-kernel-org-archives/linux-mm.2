Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 876A7C5516F
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 05:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBEAB6B007B; Mon,  3 Aug 2026 01:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D477E6B0088; Mon,  3 Aug 2026 01:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10BF6B008A; Mon,  3 Aug 2026 01:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97D186B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 01:33:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20D521C0B2E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 05:33:56 +0000 (UTC)
X-FDA: 85058841672.30.D431559
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id EA7A71C0004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 05:33:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bUaz5LgE;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785735232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MuLECA5wEc+VuT7fskiCgEgJaLOrznwzNQPZMRxjVd4=;
	b=pRx8uFAeploxXPLNRza1SFxfzuunamzmhlxBSaJ6+TptWYXV+5bN0lH58xtPJfLQ7TgZLp
	PQovumshAJs8ecKIo4QJh7l3iXSu/mqO2cOoXkBb9eYRoAS7pRApjqwIYpvUUXeKhYwuxK
	r9LGIYY1r32/FD8z5zhU311BrymrYKU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bUaz5LgE;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785735232;
	b=p47BzqWwOoPdDBRoNqf+0TFbsJ2mBTT0K3vKlFsehKyBnUiRIo4ySFMyeb+02701FSY62v
	CWAw4xm2xzNPoo04r3JRJAIQ/vi5AUbl8kTpI+0VfhWn7itd04LA7CzSxp3eZ99M1hDHcg
	ft753tpu2vFZNaMU9wIAY1yoF94caC0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785735227; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MuLECA5wEc+VuT7fskiCgEgJaLOrznwzNQPZMRxjVd4=;
	b=bUaz5LgE//bVKlBxQ2ks+Ju2tLXNl+0IwXCP+oXSi4Rdm4wpR3IwMtuTP3Lwlno5+Fvb6Kt3OiFD+YBEA0GvU5hOExZqFed5AN6AAJ9D5tV0WHT2GExBoqTCIN5kZl+lZsfUvFvuihOX9KMXvOCSmlXdwrNBe3ZeBmYWeZevny8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X8FRsN3_1785735224;
Received: from 30.74.144.148(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8FRsN3_1785735224 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 03 Aug 2026 13:33:45 +0800
Message-ID: <e9ad4f78-b4c6-42a7-a746-069739db00b8@linux.alibaba.com>
Date: Mon, 3 Aug 2026 13:33:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 3/6] mm/mglru: improve readability of
 isolate_folios()
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com,
 david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
 linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com,
 mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 stevensd@chromium.org, weixugc@google.com, yuanchu@google.com,
 chenridong@xiaomi.com, zhangbo56@xiaomi.com, wangzicheng@honor.com,
 lianux.mm@gmail.com
References: <20260731083843.37811-1-baohua@kernel.org>
 <20260731083843.37811-4-baohua@kernel.org>
 <9692264d-74a0-4a69-9d57-49a8c90cf41d@linux.alibaba.com>
 <CAGsJ_4yxJyOaNTfVWxeTH0PVED0fgExOod4ay3pRVYjFcf+BZg@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4yxJyOaNTfVWxeTH0PVED0fgExOod4ay3pRVYjFcf+BZg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EA7A71C0004
X-Rspamd-Server: rspam01
X-Stat-Signature: dnhacfauuyheu8mf7wtgah8xb7ufdmzd
X-HE-Tag: 1785735230-8794
X-HE-Meta: U2FsdGVkX1+Lo07kKn1vz0I+YA01umRT8G0U04A82DsZD18ENG/eOItZeegJ1N7xyBQHUS38nIYXz02tegGyW1qx3xnrh4RNuLfapgC/FQK4H/5vG+ypgtQNrjOgU0MXpfsZ82XRUPKX+UVa3PCtHNINDubuUJQbQCKj+LlNcIHjMS/m3fx2KTU08NjK8+TC9JKF/57FE80Sq4ULgqP/NiyFFv9DkOK7+kNXlEJSQx4O7nK+Pe+DtW8PL7ubWKyNxKsAG/eyze0/Wo7/+Tdn5QZWJJI/oSZqnS6ytBRen6gUbqa6eJQP48qvoJ0Wxz1HPcZnXy/TktXenUTGacUKfUNfRCtG2rrWTHtPY/gBFh2qAXgSj+KraYSIjHzT1ntEGQ0Ex73pBThE/uA9zxMifb+UoOVXe6JDRo+gQak96HETxRzjRGqWgwQyrXWwf7CmWTHV55qHU1DkATKFD31zosHn6jyQVKIwFKGqL7hXmJTlGELomjs3pFCjquG1U++mckPm71aESkBXB5zgWLjkmZPTIikCUQRpheV6T9VY+e5J/uMXFo8iT/qnedzxvA3FRt+PBQ4YKMmU+oZL9MPx4xcwmNZlW9cgAXaeYZa3Ts2P8yAa/npAT6a3/bB5M7Bye5Fj2uTrn+pi3OP1nD84ce6W8WwuQwmzIEMcX5twQAm975l/mboeUxOFPvaJgW2SuJnQSzYXVQ1cdegn4v97YbdDibk9ShLiynf3qKrBMptDo2E6ELJM93MKz//mVSpKkTCIxA9lGAkdwBjvbySh9OwOHtYWIHSXr+RAAdfYapxyo9kOX9Udl15gasnEX3IC2iZbmQvx6Iaf9QOoR3XAeL0cESereDxodpJNtyCogUXuwOUYfNJgj8s1c2pJa7HfaBske1rRERFiMQKs83XGgv7trIhJ5CS9ajcRIo/Jktrogzus/RxwOmAFbLElv6wWaRUkVAnPrG2p57/NqkA
 l8Rm/yeN
 7Chp4mhlob2WDfh2lH9HJ9nocsK237MNx77e5KIUJllFWfN0XMnnnlqp04Lz+3QktZFTCKkf3o+sDkB9DWnB2MsVMn/srkq0RmsTZ/7LB/Q5DiQToiMR7v9HcsNG+BLk55lTKjH0o4Aana0Q+4zAaAKFIy8X3lxbn5wgctVX9o/XyeyjFjN+HhkACDe2xE2VaITjed0Kh7JwvvI4OyKVmN/XMaUnZNh7+sNB4LfnVG7gIPXC+H+1Xf9NZW1qQ26an8ckZStjj1IYJrMlKeJov/zXawEPqkP5ZEI+pCfFn/XLlCKQ/+tB2FArBNdH/d0GHtBcu/Hm1rMcv6ngJq+RPYs4v+ePthFFqdxKy1y0LesabbV5F9Wwvy7a/MPSOVBL0hTeQrXRixZRg9PKfi7zgvktHRCeUWP860zGAZb5gRzEzhjYZhVotbty5XFAaqZycA1CguoPG4PFVCO1cnYYkbL1JyWowfJ86olTUIIv/P7zGlA2R644rYRZyaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/3/26 12:46 PM, Barry Song wrote:
> On Mon, Aug 3, 2026 at 11:22 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>>
>>
>> On 7/31/26 4:38 PM, Barry Song (Xiaomi) wrote:
>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>
>>> The for_each_evictable_type() loop in isolate_folios()
>>> is misleading: it does not actually iterate over each
>>> evictable type. Instead, get_type_to_scan() selects the
>>> type to scan, while the iterator `i` merely bounds the
>>> number of attempts.
>>>
>>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>>> Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
>>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>>> ---
>>
>> Good cleanup. Some comments below.
>>
>>>    mm/vmscan.c | 47 +++++++++++++++++++++++++++--------------------
>>>    1 file changed, 27 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 31947fa60f18..0038f33aa318 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -4828,35 +4828,42 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
>>>        return positive_ctrl_err(&sp, &pv);
>>>    }
>>>
>>> +static inline bool is_single_type_reclaim(int swappiness)
>>> +{
>>> +     return swappiness == MIN_SWAPPINESS ||
>>> +            swappiness == SWAPPINESS_ANON_ONLY;
>>> +}
>>> +
>>>    static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>>                          struct scan_control *sc, int swappiness,
>>>                          struct list_head *list, int *isolated,
>>>                          int *isolate_type, int *isolate_scanned)
>>>    {
>>> -     int i;
>>> -     int total_scanned = 0;
>>> +     bool single_type = is_single_type_reclaim(swappiness);
>>>        int type = get_type_to_scan(lruvec, swappiness);
>>> +     int total_scanned = 0, scanned, tier;
>>> +     bool tried = false;
>>
>> The tried' is a bit confusing. How about 'type_fallback_allowed'? Or
>> other more readable variable name?
>>
>> In addition, the 'single_type' variable can be removed, and just
>> initialize 'type_fallback_allowed' directly:
>>
>> bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
> 
> 
> Yep. It seems we can simply use type_fallback_allowed and drop
> tried entirely:

Thanks. That's what I meant:)

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1ffd96c87bc2..358388b49a70 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4840,10 +4840,9 @@ static int isolate_folios(unsigned long
> nr_to_scan, struct lruvec *lruvec,
>                            struct list_head *list, int *isolated,
>                            int *isolate_type, int *isolate_scanned)
>   {
> -       bool single_type = is_single_type_reclaim(swappiness);
> +       bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
>          int type = get_type_to_scan(lruvec, swappiness);
>          int total_scanned = 0, scanned, tier;
> -       bool tried = false;
> 
>   retry:
>          tier = get_tier_idx(lruvec, type);
> @@ -4861,9 +4860,9 @@ static int isolate_folios(unsigned long
> nr_to_scan, struct lruvec *lruvec,
>           * We are running out of the current reclaim type. Fall back to
>           * the other type if allowed.
>           */
> -       if (!tried && !scanned && !single_type) {
> +       if (type_fallback_allowed && !scanned) {
>                  type = !type;
> -               tried = true;
> +               type_fallback_allowed = false;
>                  goto retry;
>          }


