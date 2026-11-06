Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B29606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p4hIGK3F
Received: by kanga.kvack.org (Postfix)
	id A8EDC6B05B0; Thu,  5 Nov 2026 21:44:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3FBE6B05B3; Thu,  5 Nov 2026 21:44:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955BE6B05B4; Thu,  5 Nov 2026 21:44:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70DF06B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:44:05 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78BE51608E9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:44:04 +0000 (UTC)
X-FDA: 85403149608.09.26F5927
Received: from mta0.migadu.com (out-224.mta0.migadu.com [91.218.175.224])
	by imf27.hostedemail.com (Postfix) with ESMTP id 86CAC40006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:44:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p4hIGK3F;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.224 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793933042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zSAnlbuhwhmUG9bBEmOB7UE9ygtoZLL5whU9bUfyqnc=;
	b=bYq2c1WHQNJ5v4EXLTZIscAPrEGJUtvWc4Io4L7NaEIalVor1pwQu+AhPEkT4Xpwf/0q36
	hm/SONovb4b0jPn1INSDA0CG39ijK/v5vG6v/IxNv8+7f9Kyub022X+RlPMdtuGVpRLS7O
	X7QtiybWW5yi1h1GxRhTi7OuJhKLFXw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p4hIGK3F;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.224 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793933042;
	b=KbOoFCnwUnvlUf4L0GptTauttwvDKIzzpzZJR5UzaJ9AlBA90gRwwrpEfzVbRETJCJeLc8
	YLgRs3g85ofX+fFT+nEGl/6H57RuhJaL+TwAnJfuUdAoccBw5o5zcEohwT09tV+1RV442J
	3fg3meKzT1D27NbekoDUy2nCsZTV2Yc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BV4jydBngbK5OT+ZHvts5CVNgLwnfznFuT39h8Pecis=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793933041; v=1; x=1794537841;
 b=p4hIGK3FvTBncEACzoquuYTKUahICVVjb+yGf0kJM0hCa8vbXeIeqBgaM5JLMbHZmxt6o5/W
 64Xh/rztiH19Yyid8rqfxTMTeIrFpa6d20K3WGt17QdWQhU8O3lmgNECf403fraDz70m9uVegTe
 x5p01mJXm2W82ZxyKfNpk+Cs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f76348987678bbc6;
	Fri, 06 Nov 2026 02:44:01 +0000
X-Mizu-Trace-ID: f76348987678bbc6
X-Migadu-Flow: FLOW_OUT
Message-ID: <1535887c-6be2-4415-b54e-2008e6e7a35c@linux.dev>
Date: Fri, 6 Nov 2026 10:43:53 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm: hugetlb: fix GFP mask propagation to CMA
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 akpm@linux-foundation.org, azpijr@gmail.com, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
 <ac2de9b321f68c1025333e92e3ce94beadcb0b6c.1793850539.git.zhengqi.arch@bytedance.com>
 <auxTwrKCeg7a3hfY@localhost.localdomain>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <auxTwrKCeg7a3hfY@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 86CAC40006
X-Stat-Signature: 65cw6neb7qarn1a7myf34a5xe3gigaxs
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793933042-394770
X-HE-Meta: U2FsdGVkX18o1X9XuC64q54lolEucA80+8bOgxGH0JRndCwcxVpY/TEYggIQT77Ng5zxNwjNNRk0jL0n2WmORICfU/WByEVaUEHgwcfqDm5l5nXLquT1gJF48ec/1lQI8iTVZdl7/4PFcqRXpDop7IZB3UQkWs+5+iP14MLCyqA9bGsoRKgykeGFIyJfz6mJ41poZXZ1Bz6dS1O0HGeUTI3Kerxh0U7SaLiOBhRr16caYgUOyd7wT3sPZtDqmq1igbNhIMakH6R3F53p1zz8Tq+4H388bhq7Kf+LTKlUX0I6MzTiMKyhp4CvxixjV5oIsmuDgiwRMLuZlUxhL0ocj37+ivwNz7iydPfdDegq6vbiQ4zE/PFcGV2Zog83fQrfK7s55RQaPW/ksbEhFWs/dKfTOm9/lxkoZY66gM5GXhxgXdJT67bdy8W40FyrQh6+DStQt/IKXWAi6g+b4geIVl0/iFYDZRywlbnCvDFr8//XvCwQYK6jH3rhTbVVeZm+bp22brhT5+hW42Hb9gy0HP2uY4EbQgbNzyOltDfEucK7rT0TKaYuakBHaipD2JC7RuEfB23dBRfob3Aq6r6PJUSNWxTwGPjNTrTELOIl27i/LyjbDvYjeWga4BHxEogNu+DGBztn+JHGNQxA1SnU4ElIowciLF16mQ7XlFdTEP1ZiznUfXi0Oz3H43TkgwaisE9XP3+9uwHKf035977QDKkwNaYdNHcedkN0PiBoXgT8Kl9o5SpsIUgRfbjuro/byvKFfHoFGJlBi4ex/RN1ZnE2xeKN2ar8m7jOrK26hMsqKYQ8Hj/58lGQ8JJT9ZCuBw8qpe5C+pwD8ByEsu+OWPr6I6364JYgt75jbdHSQb2j9deXIDLOBlEhjA1nUeiPskfqlfwe+ymNuNLA1On7FPlJmvrUeD2xUkqyGN+5frmI3EHStJAszo4yWU42AUkulK5EwHkF/hMqcg7t0aS
 yn0MOEkV
 U+2pKtbM+5C+ogXZFQMGIjJYL7m4g1qtf9S9UawO90zemBClJgvo/sRmaYLEsy1VXrMMXWS/qoWqbkR8F79Vhdr6t1ZZ3rDnjOs87bYTaY2Uhvr35TAQrRnqZIfjheHGN6aT0cEeSszToxFWwA8POXfDclrCUjRB4hag5pd925BcSmvi/sIiDBA/da+Gn7lNhHWeAXtu6My94DsnTgt11SLkc/7XWzOO2hrdK0cQh3DveH/Yr6CetMwnqmyxpQgZjuwMjdnoDlMJepMXHkxkL0OVZd3MNUfg3XlrIyp2pOAUqhvRO6HVMFCiU8Qmg7/X8Ma5K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Oscar,

On 11/5/26 6:00 PM, Oscar Salvador (SUSE) wrote:
> On Thu, Nov 05, 2026 at 12:07:45PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> cma_alloc_frozen_compound() uses GFP_KERNEL, allowing direct reclaim
>> during the first MPOL_PREFERRED_MANY allocation attempt even though
>> the caller clears __GFP_DIRECT_RECLAIM.
>>
>> Pass the caller's GFP mask through the helper so CMA respects its
>> reclaim constraints when trying the preferred nodes.
>>
>> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ...
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -933,9 +933,9 @@ struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
>>   	return __cma_alloc_frozen(cma, count, align, gfp);
>>   }
>>   
>> -struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
>> +struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order, gfp_t gfp)
>>   {
>> -	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
>> +	gfp |= __GFP_COMP | __GFP_NOWARN;
> 
> Do we really need __GFP_COMP | __GFP_NOWARN here?
> It is my understanding that all allocations coming from hugetlb are
> handled with htlb_alloc_mask(), and that should already provide
> __GFP_COMP | __GFP_NOWARN.

Right. All current callers already supply both flags through
htlb_alloc_mask().

> We might have needed it when cma_alloc_frozen_compound() constructed its
> own mask, but not it gets it from the caller, and that should have been
> done via htlb_alloc_mask() up the chain.

Right. Now that we restore GFP propagation, setting __GFP_NOWARN here is
redundant. I'll remove it.

I'd still prefer to keep __GFP_COMP so that
cma_alloc_frozen_compound() itself guarantees compound allocation,
without requiring callers to supply the flag.

What do you think?

Thanks,
Qi

> 
> So, any reason to have it here now?
> 
>   
> 


