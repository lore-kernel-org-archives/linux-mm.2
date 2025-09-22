Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0454CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 06:02:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B99338E000A; Mon, 22 Sep 2025 02:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70718E0001; Mon, 22 Sep 2025 02:02:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A865C8E000A; Mon, 22 Sep 2025 02:02:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 975E88E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:02:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 353131604D7
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:02:37 +0000 (UTC)
X-FDA: 83915841954.08.AF90A6B
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf10.hostedemail.com (Postfix) with ESMTP id 794D3C0002
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:02:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MW888rvK;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758520955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mtqUfqd4lMiGo6Ala6WXTiJWCiC2KxDk241gcLH8Hc4=;
	b=7wwh2LSe3NfONvH21eJF6ALWu9zlg7+paLFxCZ6KYBj9+T7ibVJb+RQMl6TZPNglLllJHB
	6Y+Yv9txFmr9LRNIaHqG7AfKqZ05QpSzD2Mx/OjgM2zue85vW/K6exlLjunDXPLBZnqOiR
	8D92ptXdiwDXtcKR1OYn96l772h6bc0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758520955; a=rsa-sha256;
	cv=none;
	b=duGnixEf4ZzPHjPXcOHXMcnliBV+Oo8qzsbPZsST1dgFN/Gr3RRAP9BW8XRB8fr2hMhITw
	Or3msmBQXNhvAUFN9+wVr+/H3UZuF3eHQLjetng1rIfi4CAGBWL0yINVx5smVClf+rB8GL
	PCUjEw6dhznUA2wFFka/R88f+erqMec=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MW888rvK;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758520950; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mtqUfqd4lMiGo6Ala6WXTiJWCiC2KxDk241gcLH8Hc4=;
	b=MW888rvKTBHQ/rdvh2Hg2crxiFFR0268ap1aOjb4dJzILRth4Eqi/11WizkKuNViBL/5560r5wPZ42uF7jbuELza5W3BgJrEw8QKQz+uEpQ6mY3iPcIUhc3HuiYTFQS9e+QYi2f0aSICQZODTj4GqsTCxJi0neay0u8WWZQ+Zsw=
Received: from 30.74.144.144(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WoRwKND_1758520948 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Sep 2025 14:02:28 +0800
Message-ID: <392a9ca3-31ac-4447-bd44-3c656d63e4ca@linux.alibaba.com>
Date: Mon, 22 Sep 2025 14:02:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
To: Hugh Dickins <hughd@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
 lorenzo.stoakes@oracle.com, willy@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1758166683.git.baolin.wang@linux.alibaba.com>
 <9ef0e560dc83650bc538eb5dcd1594e112c1369f.1758166683.git.baolin.wang@linux.alibaba.com>
 <17d1b293-e393-4989-a357-7eea74b3c805@redhat.com>
 <4e938fa1-c6ea-43fb-abbd-de514842a005@linux.alibaba.com>
 <tombfifwrhx2n4jnj2pgcdcpj42mdv7yizkpxrppnqrtsxd5fw@epnrjqgmmy6z>
 <787dc1a4-d0b7-4559-8160-55de987beac3@linux.alibaba.com>
 <74e0af46-18a0-8c4a-5ae5-3cba69ca77bd@google.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <74e0af46-18a0-8c4a-5ae5-3cba69ca77bd@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 794D3C0002
X-Stat-Signature: zcz9yrj985e81jqfygo9i3abbyikoyz9
X-Rspam-User: 
X-HE-Tag: 1758520954-368789
X-HE-Meta: U2FsdGVkX1/3VJIFOByf0ZfXZbdkTTplJWoUP6FF7fVdoGF5J32LuuniSEb7hBbvq833uNBnus2sjFLHCx0qpVWIwYum1wZblzKCYEJCk7IFUlUJPltjh7zMShYb5taATrebFOyJhnUpDsR6wOTgGfXygEyLblwt/1UVgRcsvGC2CQPaFoN9K9ERsBzYA6WOAu0jr8zon/zpWCzqS7YWu+F3i8OkKErUep4GyyGMEBX2nvqaSeJJeq8mq447Msut91wE2eDKeVygiWC/5EeZMms/Inr/TpKgzmoKyuNpklbQH1zZEBwa3RJR2Q18ROnxo1cZPdTfyrf439DgAgsM74zfS4YMiVFhE9dNQRDp8MoLKTML1ktR60SfNJliQfoH8YbwgOQckdcI0UGtXkWIi5/AyP5dkWFPS77c9UlIbfPyZP3YIWdyg1fxSI28/jyQEI/ysED+pRsETD2k2avgExYHMmA6VFRSr6lIo+kGMdp6YaI4DZo+XLuN/y517s5PzQot0nraNm3RbAp4YRPpDA14YZ9jOg/CtdxFZDSxh0GqFM51dFdJyjPI5LxvQGkd42Opf2w+3HRDu7ezFXI4cDeh7u7c3REZXqMJ9DCyx+jozwp1iAqORX9/RU735PZT4uPjNfEiAmUwIlpXTjSUMF3ghuQQalwnUTcoIKcBzncTS6P9bpuEFCnELxbuawHoUgdLOaX1yAJwaPeOb63CK70ZjZ9NP8vv6uazh7jRi1KEZHMI1pV4nf7qOCrIP3brh+rUMq4xUZah9T4jS8LhwXfROEh7eENJ08NBUUq1rqd+nbRKXWpAzvIGoRQR54ZemJ0w/0ifo1Q3t99+YrvTcwVNLgCaQrvZcPn2rM/sAH5TYE28qgvZmohRo1J4G5B8SGMail2WN/uI/9nga+0VavfC9U4r+mbzszGURgkF6kJin/S3/6w5MQjRuLVFZ330+PeyUNCpwew6NZz4xs7
 jzwGFGbZ
 0fugi4ae53YIk1krbCwYEpY5J81vI8HW9mDTn+VmqqwNEjhhLiuizIUjGLjIh0Eg5ulL4r7PSPkRRFOQBJhrzjnFGHMPAcl4GYk8snEySAxfpjNfNfZoi9r+yN54PyOJCfFx2vv8tN2Qu6Eu2R/8SbSejmGjBDDVjOX8pT5ADujGTUtBW7KekIwO+D5SkMzDcw3RwVQsRxn9NmTedoqmnL1BPfv6Q0LDt9pPc8JCmIPDhUC2p5zE+u2sZood25CYQ54IO4V4n9/vZN6htJRAufh6vY05+Dk7E190EVn6x6BpteKo0L7a1qx7bfggb/G7GLt3xAneMiQUlC0ObkI9HwZkxkueFcFN216FLR53bDCOlCYEtaaVVIv2bS4sBJwGDQz4z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/22 13:32, Hugh Dickins wrote:
> On Fri, 19 Sep 2025, Baolin Wang wrote:
>> On 2025/9/19 09:06, Shakeel Butt wrote:
>>> On Thu, Sep 18, 2025 at 05:36:17PM +0800, Baolin Wang wrote:
>>>> On 2025/9/18 14:00, David Hildenbrand wrote:
>>>>> On 18.09.25 05:46, Baolin Wang wrote:
> ...
>>>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>>>> index f1fc36729ddd..930add6d90ab 100644
>>>>>> --- a/mm/vmscan.c
>>>>>> +++ b/mm/vmscan.c
>>>>>> @@ -701,16 +701,10 @@ static pageout_t pageout(struct folio *folio,
>>>>>> struct address_space *mapping,
>>>>>>             return PAGE_KEEP;
>>>>>>         if (!mapping) {
>>>>>>             /*
>>>>>> -         * Some data journaling orphaned folios can have
>>>>>> -         * folio->mapping == NULL while being dirty with clean buffers.
>>>>>> +         * Is it still possible to have a dirty folio with
>>>>>> +         * a NULL mapping? I think not.
>>>>>>              */
>>>>>
>>>>> I would rephrase slightly (removing the "I think not"):
>>>>>
>>>>> /*
>>>>>     * We should no longer have dirty folios with clean buffers and a NULL
>>>>>     * mapping. However, let's be careful for now.
>>>>>     */
>>>>
>>>> LGTM.
>>>>
>>>> Andrew, could you help squash these comments into this patch? Thanks.
> 
> (Myself, I would delete the comment entirely: it's justifying the change,
> which is good history to go into the commit message, but not so good in
> the final source. And we don't fully understand what to say here anyway.)
> 
>>>>
>>>>>> -        if (folio_test_private(folio)) {
>>>>>> -            if (try_to_free_buffers(folio)) {
>>>>>> -                folio_clear_dirty(folio);
>>>>>> -                pr_info("%s: orphaned folio\n", __func__);
>>>>>> -                return PAGE_CLEAN;
>>>>>> -            }
>>>>>> -        }
>>>>>> +        VM_WARN_ON_FOLIO(true, folio);
>>>
>>> Unexpected but better to use VM_WARN_ON_ONCE_FOLIO here.
>>
>> Um, I don't think it makes much difference, because we should no longer hit
>> this.
> 
> We do hit it.  Observe, there was no WARNING before in the !mapping
> case, just a pr_info in a particular instance of the !mapping case.
> We believe that instance went away with reiserfs, but that does not
> imply that there are no more !mapping cases left.
> 
> We do hit that WARNING: not often, and I've not seen it repeatedly
> (as ONCE-advisors fear), but a few cutdown examples from my testing
> appended below.

Thanks for reporting. That surprises me how that happened.

> I'm sure you'd like me to explain how it comes about: I did spend a
> while looking to do so, but then found better things to do.  By all
> means go in search of the explanation if it's worth your time: it
> might indicate a bug somewhere; but more likely it's just a race
> against code elsewhere cleaning up the folio.

Interesting. I'll try to reproduce this issue.

> The fact that it does not appear repeatedly suggests that the folio
> is successfully dealt with afterwards.  I didn't think to check at
> first, but in later runs did check back on such folios after, and
> verified that they had moved on to being freed and reused, not leaked.

No leaks, good.

> The examples I've seen have all been swapbacked, though that may
> just reflect my tmpfs swapping load.  With mapping NULLed, there's
> not much to go on: but index 0x7ff5ce103 is likely to have been
> anon, and index 0xcff more likely to have been tmpfs.
> 
> My vote is simply to delete the warning (and the comment).

Thanks for your examples and sound reasonable to me.

Andrew, could you help squash the following changes (if you need a new 
version, please let me know)? Thanks.


diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4907e255857a..aadbee50a851 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -689,16 +689,8 @@ static pageout_t pageout(struct folio *folio, 
struct address_space *mapping,
          * A freeable shmem or swapcache folio is referenced only by the
          * caller that isolated the folio and the page cache.
          */
-       if (folio_ref_count(folio) != 1 + folio_nr_pages(folio))
+       if (folio_ref_count(folio) != 1 + folio_nr_pages(folio) || !mapping)
                 return PAGE_KEEP;
-       if (!mapping) {
-               /*
-                * We should no longer have dirty folios with clean 
buffers and
-                * a NULL mapping. However, let's be careful for now.
-                */
-               VM_WARN_ON_FOLIO(true, folio);
-               return PAGE_KEEP;
-       }

         if (!shmem_mapping(mapping) && !folio_test_anon(folio))
                 return PAGE_ACTIVATE;

