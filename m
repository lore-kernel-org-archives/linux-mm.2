Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8640560A3807
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GCOsEAnk
Received: by kanga.kvack.org (Postfix)
	id A888C6B05B9; Thu, 12 Nov 2026 03:55:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5FD46B05BA; Thu, 12 Nov 2026 03:55:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99AAD6B05BB; Thu, 12 Nov 2026 03:55:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A4A96B05B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:55:01 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 222F24047A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:55:01 +0000 (UTC)
X-FDA: 85425857202.28.40A5471
Received: from mta0.migadu.com (out-61.mta0.migadu.com [91.218.175.61])
	by imf06.hostedemail.com (Postfix) with ESMTP id D6F9A180004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:54:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GCOsEAnk;
	spf=pass (imf06.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.61 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794473699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bUU8aJriCj4L30614In2cmZDuMPUuAtDiWuioRCy4Ew=;
	b=SfCkaWZ4iLbq+KoONQt9yqJKHR/TH72Xt11E14V9oEzdtNAxOFD/PTEi+p6/2DRPXAC3qc
	gO8DqRbKpqgo3uSL2FirabQfZF9SrzowEXlAYxjmAuGklFrEE9SG3WrcyXsVmxWv9ZKn0P
	dSsCx0csxuEqwDLv8pIWEZAc8cpfQXg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794473699;
	b=3q6Pe97iYHg665zgCM0NPna/UDLqSFrq3z0cM6kZdyh+CKAagpsdn+aA6a6y2nsFp98Ecg
	CyAiWayGkWmACB/ZQmqCElPoTDaVKrOfjxxFlT0EEndGk2OFvhWCDj4eoVWm4BLdpLTe5m
	97qh8wJ0qyiyeTkSYO0jt8pBhYC7+SA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GCOsEAnk;
	spf=pass (imf06.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.61 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YsFJ1UStpx7QYNPW/2zE3mPvngieaVFLiicQbyvU7PY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794473696; v=1; x=1795078496;
 b=GCOsEAnkfrVVwc3xDIKSkChL0T2tbcjDklKI3DDvJGU3CIkgZ9A3Jq9G9400Yhoop1pf8WSO
 Ue12sTlUWpkut0nadfeMg6022lvCUmdhqM54Kvcw9WrT4OI2+gIIsiDl8f0yccptEp/83bEMVTN
 WUDQPbaHjr+Ld6/bG2ojuAG0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5255a3e99e026359;
	Thu, 12 Nov 2026 08:54:56 +0000
X-Mizu-Trace-ID: 5255a3e99e026359
X-Migadu-Flow: FLOW_OUT
Message-ID: <c01ec177-da44-49bc-a542-35b64554526f@linux.dev>
Date: Thu, 12 Nov 2026 16:54:47 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mglru: deactivate anon folios into the oldest
 generation
To: Barry Song <baohua@kernel.org>, Kairui Song <ryncsn@gmail.com>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261112081928.3014946-1-ridong.chen@linux.dev>
 <avV52J2rD19cjM2J@KASONG-MC4>
 <CAGsJ_4yibOkJmi9niJ8svu2NdEkZ5Qyf98VO6qMrJMa_9wGFgQ@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4yibOkJmi9niJ8svu2NdEkZ5Qyf98VO6qMrJMa_9wGFgQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D6F9A180004
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: pciuok6iph69fphurn7txpori46awigs
X-Rspam-User: 
X-HE-Tag: 1794473698-219831
X-HE-Meta: U2FsdGVkX1+N5p/O7A+kr8L9DQd29gJBMF8f/i/AcUXNkOgcwefpd8u+YsYmf0OYtSvG84+OAciXtd17YaV9Xz/qnk571U00SgBB38qOJwmIkBGlGrNEFI4NGMkhwRrQTqPjSe297GEwS87Nm1z46cQBWzu2iEt24bZ1KuZDJAsV3YXvGE7DEUX0cx+WFyt1eb6MzdCnLK3kLRsvZatkfRws+NHw47oYYlXkmY5uyZKhN4EKED3Qqe98d0JC5yGWmiB80R2HYgYJ97znl9ovB5Prx7X0b9O+KZuRXOEPS4/odk2xYtSQNkGyP8tg4/BcFey6Eze1gAIginsFO23IwqrjnfQw/d+nm5ro/uVyTIg2q1JtgfHZi3HSb8wIN3SrQVq9n60Rga9VcBvDC3z1tHTk9CwyN0i4th/15PTJk0U+3u9dNek0hem+6F69feRLYlzSvRfeGuaaZikLU5wJVY+wCp62V4LF0PgtF7rMN5JGQSsXuRnL4Lq9L5ROSom7DhP/1TKkGVYWH/e0Bfc4BQdd29tgWauBuyaSSYBzw4DuraF/NAU3fcsmzPHsAVTtnKvEWZ02MpKJOC3zpjL4CkINXENBMaJpYJKzJDqmktxBneiwYh46qnkAhQkinORJmwV/ggO4WC9YbrpKAK3zdZ2/7o0SlqnuEoLzcLeRCBK0AT0NoLfhNTMmSAIokblvNMbt7jxuLxq0VJ65xujYHZvWHDEjdeu+5svFtIvZWx69Blh8TlVMgO3TMY2IAcF/EZLCwCLCYXnn5FHXaGFw48M+EWLhFL4MawPU+sC0ckDOzDUjr2+Lj6eFMOEThJVsHNlQDIe4gGP++P1CuhCjmBVMx8cstKDwfonEF9U+JHN5ZQzIhWx1NV1D2t3Bh+x47KSjn0FXRuEynTtNBfO1YzOa4gkeiX+SakNM4oUczDOdPdNX1soVQt/lJC89rNyNhDHsZnexgKBn3FRwuWZ
 2cdquBwQ
 f0D47KOY/R9M0yF6TLdo+oZ1qr+AHeMd3N0CFJPPWGs0wjkce86P4jTXaO+pVYbUo/SvEDtqagq8LEoMjOshlzvZSai3+k3afmbLeYJegfrdmdSt4HWJd+VkVYVahYVt4NlxyXqLHWTpJuoShjrPMErUlf8SkreMrxwwY5qUJiThTt1xiebEP3+qjm2MTmvt51hi61rpmVfgAD8rofpUUmK8jTCHwNDDBylUXcaJCtt/pAfx0zvPUbm1AQzb9x0h67A7mqoTH2Nr/sdCRIkupyWt7LfgmuaFpzQYfgPXQvzrLnTJ4QqQLrgsLvnvkPCxK3W+iTP36mDRzdWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/12/2026 4:41 PM, Barry Song wrote:
> On Thu, Nov 12, 2026 at 4:38 PM Kairui Song <ryncsn@gmail.com> wrote:
> [...]
>>>   mm/folio.c | 11 ++++++++++-
>>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/folio.c b/mm/folio.c
>>> index ea3adb6a89d7..c412d9b398e4 100644
>>> --- a/mm/folio.c
>>> +++ b/mm/folio.c
>>> @@ -583,7 +583,16 @@ static void lru_deactivate(struct lruvec *lruvec, struct folio *folio)
>>>        lruvec_del_folio(lruvec, folio);
>>>        folio_clear_active(folio);
>>>        folio_clear_referenced(folio);
>>> -     lruvec_add_folio(lruvec, folio);
>>> +     /*
>>> +      * For MGLRU, lruvec_add_folio() places anon folios that are not in
>>> +      * the swap cache into the second youngest generation, which is an
>>> +      * active one. Add the folio to the oldest generation instead, like
>>> +      * lru_deactivate_file() does for clean folios.
>>> +      */
>>> +     if (lru_gen_enabled())
>>> +             lruvec_add_folio_tail(lruvec, folio);
>>> +     else
>>> +             lruvec_add_folio(lruvec, folio);
>>
>> Hi Ridong,
>>
>> One question here, why MGLRU/CLRU have to use two different ways to
>> add the folio back?  Will this cause over aggressive reclaim of the
>> folio?
> 
> I guess that is because on mglru, that is lacing a way to add the folio to
> the head of the oldest generation for anon folios while CLRU can do
> that :-)

Hi Kairui, Barry,

Thanks for taking a look.

Barry is right about the reason. With the classic LRU,
lruvec_add_folio() adds the deactivated folio to the head of the
inactive list. With MGLRU, lruvec_add_folio() can't put an anon folio
into the oldest generation at all: lru_gen_folio_seq() places a
swap-backed folio that is not in the swap cache into max_seq - 1,
regardless of its refs. The only way to reach the oldest generation is
the reclaiming path of lruvec_add_folio_tail(), and that path adds the
folio to the tail.

And you are right that this makes it more aggressive than the classic
LRU. With this patch, a deactivated folio is evicted before the folios
already in the oldest generation, while the classic LRU puts it behind
the folios already on the inactive list. It also changes file folios:
before this patch they are added to the head of the oldest generation,
the same as the classic LRU, and now they go to the tail.

So the problem in the current code is that a deactivated anon folio is
promoted into an active generation, and with this patch it goes one
step further than the classic LRU in the other direction.

-- 
Best regards
Ridong


