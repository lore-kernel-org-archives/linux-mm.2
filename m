Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E2C7C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 04:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8506B008C; Tue,  8 Sep 2026 00:01:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A87C6B0092; Tue,  8 Sep 2026 00:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1B86B0093; Tue,  8 Sep 2026 00:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E42EC6B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 00:01:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 84EFD1C206C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:01:54 +0000 (UTC)
X-FDA: 85189246548.18.E272EBF
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf07.hostedemail.com (Postfix) with ESMTP id 66C5940008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:01:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=M9oOdwWt;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788840112;
	b=oIet7zQsXXS6A+P0KgdHgBm5HpbpOSTjkp9ORbFW4iwMx4kr9ALFSPeb+FGFTONl5kDysG
	OIAEA158MsPFfkMXJeNpoyNktmvMMSewlKDyEyrvCh4eOtgoL+eD+gMVPAj65QpJE0/FLS
	F/95Z/W67YiVIfUWNXsZTYxTnAoWUew=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788840112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Najs9RGCkB+xTfIo5Ipvni0lhIFU34DcqdN/H9GY20E=;
	b=q+sMfZ3u4FG1pEBwUbEJWRH/IgjOfGlyyi65pOTrrX86kLZbvyvhEgRoH3hqVN7hLNxN3K
	bxS2AVFwW9RtPGn57BeHj5HJZN5gvZDnyJTEF5uaTeFyBJt+FtQJ2m83qtCZ2rQ8NCe4xc
	Adwa2AAE6oHymXDSHuX3KV3kS5YXYAY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=M9oOdwWt;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788840108; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=Najs9RGCkB+xTfIo5Ipvni0lhIFU34DcqdN/H9GY20E=;
	b=M9oOdwWtCAnh0m0XULvaX+L3CM8yp1ebQIvTYvIIvHvPYbgSUhg0uLLXDSrpvOG8ogRYFsjXF9HNlaW376vnR537N2xlD3qwizEeVZHpW07TX9MHgsQpuR5JVucd5XDNJMVgOzVyq1Ik/FbiLZ4lqDCW/ddVwOl8ICtM9MYo2CQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XAaJnml_1788840106;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAaJnml_1788840106 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 08 Sep 2026 12:01:47 +0800
Message-ID: <31494361-406e-4874-8a2c-2c6f5cee5321@linux.alibaba.com>
Date: Tue, 8 Sep 2026 12:01:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: mglru: clear the reference counter for rejected
 folios
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: Barry Song <baohua@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
 ljs@kernel.org, ridong.chen@linux.dev, hebaoquan@kylinos.cn,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <8e4db9a298c5ea6ccb192e274caed5b96f0cf022.1788751143.git.baolin.wang@linux.alibaba.com>
 <ap9zPPughaSlfXM2@fedora>
 <CAGsJ_4wn5ArqhG9w7gJY7X4G+Lg6=1teCb70dzPdN0k+5H8MbQ@mail.gmail.com>
 <67d9bbcf-2991-4867-8afb-14bad1cebf8d@linux.alibaba.com>
In-Reply-To: <67d9bbcf-2991-4867-8afb-14bad1cebf8d@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 66C5940008
X-Stat-Signature: y1j8bohnah8rs5bt5ribsy3qjuf3gazc
X-HE-Tag: 1788840111-517632
X-HE-Meta: U2FsdGVkX18NR/jFugZwD4WZP0vN4iMjONYaAHv56LPbc3l56DyNbH2ngHFsrk4xFX+q7y/uwRUcm/V+ZhcT36jh+E/6jqBBIUyzXwLyJPS/lULY1S6jFJuPzZhcsSW8DfuZKvUGw30z8/tG8SHKSR1h0pFQdIqMTzNCTJr9LUS5bIrVS5S285C4I0jl63HePlS3UxZOeNPj8396pUw1c3gRpbLtum/8lIAUqXi1YFLBBJdVMRq5u5Uu0BewIn9xnEVrBcT3MDpVI55WfsMr6xbve9XdwUjTBlgaLTLtGDQ5d639TPg7Mk/m4mbkvWltxZb8AcgJ0BUKZp5DHH6fXhvmZ5/GXaePccpLGzUmaqQEPiFvxlKymwSVRfp/AHVPBefWQ7iCsPdGn6SrdG1tBo/OqiipbIH+yp5fJsewqwicuhKFCk/GZ6z7/PbjsT/dGFULYY8joWWQcJER1BsNoxEFJj3WTvaSl3uaMklwuOnuI7PwdE5Q+sU7O+9qWeNYf5RpuOHNysoon0qZTHITvc8nehJorz1wqto1f4MMKi71GVL1G/djWrr7PD3tWTNNpGe7kahml2rXf4jdAWy5K70NU9p4oEw4y57vIysPZhblAecdQI4PMy4yWlYLOHbnarSMoSHiVLtrmKXPmnciIahCPhKTQKV/uGGGNqCPDx/SY7eTp+RayszscYuWN0qQZC1uShdb67p/JZ/dli1kKmM3xW50zNMY50ilJfw1zJZ3GiZC4HZxFSe1pD8oIW35pVMD/ZX9iN/mFPVhCEcIGKXKz6SgrPOBGfTEp18peTemAUjlkrLeYqAfSHgeF/uiXq+zWlwG5l9z3xbHZ8IMkvrki+Daq2M0Zl8lC8LiIYTQ4adhuni6WDDXm8ANI3lDz9xOaxtR2CkIpPMeyGJMEo/AygIJmevNjwHbFwVTr2eC0FgDQjRsDONEAgOn1fa0I49CoULRBIsNkYC4UV2
 j7F3EhQm
 2GlOPUJjfCqFq+0Ye0HnO8/kcaH0PLUhQnZCRDpwIzBWWLVjKs/0/EG+RTqEaZOG7zsIP3ArvHqKPRU9QK6KkzP8/vxfLzXLwRI8SDuomVKFLzmamVLQc/GW8oGjihN3DfbOljchEeRbgmAHVW+MFMy7Fk3byKkKMRSCNMr3c7lQXuEHBHYBVh+MnZMx3LKtdcSbV5dlnfSgrE5nyLt75DmOrVQFtPdv6hzJxik9cEj4j8kUYTTbmQI1iW89oUl6tlp0XUSNYHKzriL2mZeI5De0YrQu+FBIW1WGBrla/HPe0aXpm02iyNQQGsE9iTUsXAvyDRy40j9+cjLnU8Ayd59HPL9Yre8/OPZ7/fc/IQdcKIOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 11:03 AM, Baolin Wang wrote:
> 
> 
> On 9/8/26 10:34 AM, Barry Song wrote:
>> On Tue, Sep 8, 2026 at 10:30 AM Baoquan He <baoquan.he@linux.dev> wrote:
>>>
>>> Hi Baolin,
>>>
>>> On 09/07/26 at 11:25am, Baolin Wang wrote:
>>> ......snip...
>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>> index 40d3f1b48a74..42c0a09938ab 100644
>>>> --- a/mm/vmscan.c
>>>> +++ b/mm/vmscan.c
>>>
>>> Well, this seems to be based on Andrew's mm-new branch. I usually track
>>> mm-unstable branch. Maybe the subject should be marked as below?
>>> [PATCH mm-new] mm: mglru: clear the reference counter for rejected
> 
> ACK.
> 
>>>
>>>> @@ -5021,10 +5021,11 @@ static int evict_folios(unsigned long 
>>>> nr_to_scan, struct lruvec *lruvec,
>>>>                }
>>>>
>>>>                /* don't add rejected folios to the oldest generation */
>>>> -             if (lru_gen_folio_seq(lruvec, folio, false) == 
>>>> min_seq[type]) {
>>>> -                     folio_set_lru_refs(folio, 0);
>>>> +             if (lru_gen_folio_seq(lruvec, folio, false) == 
>>>> min_seq[type])
>>>>                        folio_set_active(folio);
>>>> -             }
>>>> +
>>>> +             /* See the comments on LRU_REFS_FLAGS */
>>>> +             folio_set_lru_refs(folio, 0);
>>>
>>> This looks like a great catch, while the code change could bring issue.
>>>
>>> Because move_folios_to_lru() relies on folios' flags to decide their new
>>> generation. You just cleared it before move_folios_to_lru(). This is no
>>> problem for rejected folios that are determined to be put into the
>>> oldest generation. But for those rejected folios that are determined to
>>> be promoted, this could be wrong. E.g currently gen window is 4, and a
>>> folio is referenced, lru_gen_folio_seq() decides its new gen as 1, which
>>> is the 2nd oldest generation. While folio_set_lru_refs(folio, 0) clear
>>> referenced bit, this causes it being put into the oldest generation in
>>> move_folios_to_lru(), this is not expected.
> 
> Yes. As I discussed with Barry earlier, lru_gen_folio_seq() also needs 
> to be reconsidered regarding whether it should rely on PG_referenced [1].
> 
> For commit 6cbdd9726fb5, we didn't discuss the impact on rejected folios 
> either. Before commit 6cbdd9726fb5, if rejected folios did not have 
> PG_active set by shrink_folio_list(), evict_folios() would set PG_active 
> on these rejected folios.
> 
> [1] https://lore.kernel.org/linux-mm/20260901220430.79810-1- 
> baohua@kernel.org/
> 
>> The original code looks quite weird. It even prioritizes folios
>> that won't be promoted by `PG_active`. Do we need to change all
>> the cases just to call `PG_active`?
> 
> Yes. Regarding this concern, I plan to change back to the original 
> behavior:
> 
>      /* See the comments on LRU_REFS_FLAGS */
>      folio_set_lru_refs(folio, 0);
> 
>      /* don't add rejected folios to the oldest generation */
>      if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
>          folio_set_active(folio);
> 
> What do you think?

Just FYI, after above changes, the performance improvement on zram is no 
longer obvious either. I think this also answers Kairui's earlier 
question about why I saw a performance improvement (which seems related 
to commit 6cbdd9726fb5). Also, there is no obvious performance 
regression either.

zram swap:
		w/o patch	w/ patch
sys time:	1666.5s		1628.5s


