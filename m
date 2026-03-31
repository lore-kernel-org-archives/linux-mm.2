Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2997FFF60F7
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921B66B00A3; Tue, 31 Mar 2026 05:52:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AB9D6B00A4; Tue, 31 Mar 2026 05:52:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79AC96B00A5; Tue, 31 Mar 2026 05:52:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6382E6B00A3
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:52:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E9C713BD97
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:52:50 +0000 (UTC)
X-FDA: 84605894100.28.62033D1
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf28.hostedemail.com (Postfix) with ESMTP id 16738C0005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:52:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Tf57uQVh;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774950767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6C51cv3GmInVDRSzJ0o1SrLSNCpx+iw3NqPxrMXCQW0=;
	b=h+aE/YJff0RBHZWDnW/TpxAO8mjEYM5Wd8BTy07NpgYBLfiVRj0EJQlUY8OvrVyxPeIJ4c
	IbBjsQ1MTMdt+GIGL1wAdhU50aEUdH7vYi/NuE+nfsw7m6Vo6XhCUeyvs19zrlLk6Orbys
	k7N1jvzJORGQpEcIQk7p3GaBrh9VNY4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774950767; a=rsa-sha256;
	cv=none;
	b=tYjxGP/rSBSMNcsX4pLNjsTQNmg6Eo5qfVgnBm/NeyCppBe66WZcnbi6g0OmnffKVIcBur
	Dn3KGENqxbg/s9icUUdQ4S2HOBlbePgkSXuEmuHJSW5zvY2jCa8zxke64OvM4NZENNmUre
	6vPYY4JqoRkcz5gaN0Nqaf2UM6nDhI8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Tf57uQVh;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774950762; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6C51cv3GmInVDRSzJ0o1SrLSNCpx+iw3NqPxrMXCQW0=;
	b=Tf57uQVhtXU7p6W8Rdz3tcvedB/5P7PbLdiyJEuDEI7mb/f3iaY+1Zxg38K8xPaxakNA9M9QKWman+4PfgZ2KTSvRNi3Vxp5LnBbmucgl3q7/lDP8Pos2dYNIW5/m7khMCjjdSvejtHk/imcgIw1ydsNNjPsNPcpg9grnRuM67E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0X03ykpe_1774950760;
Received: from 30.74.144.129(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X03ykpe_1774950760 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 31 Mar 2026 17:52:41 +0800
Message-ID: <51d646bf-87f0-4f56-892e-4c62940458a5@linux.alibaba.com>
Date: Tue, 31 Mar 2026 17:52:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/12] mm/mglru: scan and count the exact number of
 folios
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-5-b53a3678513c@tencent.com>
 <3ef1cb78-5110-4326-bde1-d929f638b8f6@linux.alibaba.com>
 <acuBldipHM5fj_pw@KASONG-MC4>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <acuBldipHM5fj_pw@KASONG-MC4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 16738C0005
X-Stat-Signature: w7q5idytab4zd8cdzxz4o7fk7d6cr9yo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774950765-771056
X-HE-Meta: U2FsdGVkX1/jzjvnB4C05QpjrkRvjGQxcFDh1kxpHUydFKLidT75AhQ/Z8Z1v4s1qUaAJLWNSx6dsceJeUWdOX9fPMfNPW5Dz0y84ukjxQbh8RZ2/LQvpnhSBfMKqWEeEXIS7+kzGhivphcvGOf7k7M3SqsNzJHJFBCZXPp5MhYtYAAxLg9hFCTSsgrNkUcX7PlrWa5Uyvv7N/gzwqb9qGBmVAepP+hS1FX52BKuWiLCbFZhLn1NtkVfAb4JZ7g748oV8soOULZBpxDk2/lSJ1i+kpdWfUO0zx3KEWLwov9aZVgsqJxKVXgLw2CyX9Uxzc39RnC6meHltJnUqa/IW/pHDVaEEHVQkv8NgzJA9LN46GXM2MYx4iCOJUiWv70Qp9FV6J+/oQk8dVfP8BEtArIXIqCyCPThT2VucTsS64hoC91z43kQ0Z/kD0OLxeayyzSvL+ieP06HrKd04/rX2yO+nCK4MRFjXe+mnJafcG74+JxevWFJBkLMM7DPcXbkOtLCMEbPs7VNTJzSi3BziPLeiHNuffGWT5H1m3Zq0ne5NwSKl+PsXou25SKID0zIqZZV4j/W+9rI+SjEp3E8QlZqpOJN60PLEH3fOAI6/dkA9NdDX3eUVPxdTHQsWzsJibwVrOTFoNV8AE3jCte6tX1ZN8q/wxU9j7Lh0rbTXQJrVpyHB4X9D7Jgd1P8Cy+KKc+gEnzFleDd149F3TW2+SBDJmGV398EgKX8uiiYvIb0+Mr44vdx85CL5BteghLm/PaDfmOAlDF4vhs7AZa+KX4cufuUkXVtlCY3WYRSN9tZXtvkRgi03Xp5kEhuHX48MgW5yQx/PpjWjRMMiBEM/FeQy9wbHgi9c1W8deeB4qhoAJKha+TsIzaZZaSjEcRMC74tP7xGKtKXh6Nzk4XC6EThkU3nLWy55pTLEeOkZ6FT6aKjH5lz0ctrOqOtYLWyh8MAVC926nepuEyHisw
 bq7EzYKy
 FVWO+zSKqIODC10AA2LxUUGHippScKfdKtHei9F0rTYFyMsewinUQZOkPxTGGjgrZot1tJ9F9sBVktHwwmT2NYb0bjjjx5+f1IDprhn9o8tVqXpZogxqo61eTWsWlWkeafHffdcXdZtOQoFclQU7qEzI+PKlyK2t3HSpOxrqik51HzgJ/S1VTaulsCr1+0Qahb4bQRPLdAGa/2lwdKpwu4EkmAQ3pZW8JGTVuMEpDAv5vMACaJXPrGAXk/q4hDYgCA+k7othfLtgO0mw+jX/1whvspktr2upmmgI770XEHxFBTk5N3XKMBZ0JbbLQPjqhVoPDSNiiqZnHMN18FjrEmLSLZtpFVnscmUUGwgFS6qv4Lk1VBrs/7+etqBJa8eLLT5CaVAQ58ApksPImD4kQ4vMgPJaWAjRn0lg6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/31/26 5:01 PM, Kairui Song wrote:
> On Tue, Mar 31, 2026 at 04:04:30PM +0800, Baolin Wang wrote:
>>
>>
>> On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> Make the scan helpers return the exact number of folios being scanned
>>> or isolated. Since the reclaim loop now has a natural scan budget that
>>> controls the scan progress, returning the scan number directly should
>>> make the scan more accurate and easier to follow.
>>>
>>> The number of scanned folios for each iteration is always positive and
>>> larger than 0, unless the reclaim must stop for a forced aging, so
>>> there is no more need for any special handling when there is no
>>> progress made:
>>>
>>> - `return isolated || !remaining ? scanned : 0` in scan_folios: both
>>>     the function and the call now just return the exact scan count,
>>>     combined with the scan budget introduced in the previous commit to
>>>     avoid livelock or under scan.
>>
>> Make sense to me.
>>
>>>
>>> - `scanned += try_to_inc_min_seq` in evict_folios: adding a bool as a
>>>     scan count was kind of confusing and no longer needed too, as scan
>>>     number will never be zero even if none of the folio in oldest
>>>     generation is isolated.
>>
>> Yes, agree.
>>
>>>
>>> - `evictable_min_seq + MIN_NR_GENS > max_seq` guard in evict_folios:
>>>     the per-type get_nr_gens == MIN_NR_GENS check in scan_folios
>>>     naturally returns 0 when only two gens remain and breaks the loop.
>>>
>>> Also move try_to_inc_min_seq before isolate_folios, so that any empty
>>> gens created by external folio freeing are also skipped.
>>
>> This part is somewhat confusing. You probably mean the case where the list
>> of that gen becomes empty via isolate_folio(), right?
>>
>> If that's the case, the original logic would remove the empty gens produced
>> by isolate_folio() after calling try_to_inc_min_seq().
>>
>> However, with your changes, this removal won't happen until the next
>> eviction. Does this provide any additional benefits? Or could you describe
>> how this change impacts your testing?
> 
> Hi Baolin, thanks for the review.
> 
> Yeah, I also notices this issue after sending this while doing more
> self review.
> 
> So I did some test with the patch below:
> 
> static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness)
> @@ -4818,11 +4814,15 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   
>          lruvec_lock_irq(lruvec);
>   
> +       /* In case folio deletion created empty gen, flush them */
>          try_to_inc_min_seq(lruvec, swappiness);
>   
>          scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
>                                   &list, &isolated, &type, &type_scanned);
>   
> +       /* Isolation might created empty gen, flush them */
> +       try_to_inc_min_seq(lruvec, swappiness);
> +
>          lruvec_unlock_irq(lruvec);
>   
>          if (list_empty(&list))
> 
> The return value of try_to_inc_min_seq can also be dropped
> since it's no longer used, and the function call should be cheap.
> 
> After system time of build kernel using 3G memory and make -j96
> with ZRAM as swap, system time in seconds average of 12 test run each:
> 
> mm-new:
> 9136.055833
> 
> After V2:
> 8819.932222
> 
> After V2, with above patch:
> 8783.944444
> 
> After V2, without above patch but move try_to_inc_min_seq
> back to after isolate_folios:
> 8807.874444
> 
> This series is looking good, this inc_min change seems trivial
> but in theory it does have have real effect.
> 
> - Moving the try_to_inc_min_seq after isolate_folios may result in a
> wasted isolate_folios call and early abort of reclaim loop if there
> is a stalled oldest gen created by folio deletion.

Indeed.

> - Moving the try_to_inc_min_seq before isolate_folios may leave a
> empty gen after isolation. Usually it's fine because next eviction
> will still reclaim them. But before next eviction, during that period,
> new file folios could be added the oldest gen and get reclaim too
> early. That looks a real problem.
> 
> This maybe trivial since MGLRU itself also may suffer the same
> problem when the oldest gen is just too short, that's a much more
> common case (For this short oldest gen issue we can solve later).
> 
> - Having try_to_inc_min_seq both before and after isolate_folios
> seems the best choice here and somehow matches the benchmark
> result above, very close to the noise level though.
> 
> Well I only tested one cases, the cover letter described a
> larger matrix, still all good with this series and I'm not
> 100% sure how this particular change effects them, I guess
> it's still trivial.
> 
> The try_to_inc_min_seq call should be cheap enough since it's
> called only for one batch of 64 folios, and it's only reading
> a few lists for the non inc path.
> 
> How do you think that we just call it twice here?

Sounds reasonable to me.

I'm not sure if we need to split out a new patch with adding above 
message, as this patch mainly focuses on optimizing the number of folios 
being scanned.

