Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2600CCF9E0
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 07:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16ED28E000D; Wed, 22 Oct 2025 03:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11F3C8E0002; Wed, 22 Oct 2025 03:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00DC68E000D; Wed, 22 Oct 2025 03:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E05258E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:47:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 78A9B1A04A0
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:47:36 +0000 (UTC)
X-FDA: 84024970512.07.A577F6A
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3C61440007
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:47:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gYHUrw+E;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761119254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+qvTFZ8jw1vc9BmwmZE7CbJfZv05rrBieJVcIWZoxI=;
	b=vL+mZIL3fh66CeOHY0zBDap1PFtdCxabvwo37evLTWc/EKMQqsUqsvhfl8lZZUQWeiT4to
	al6AkRAb/8b/VTjuQs0kHW6YliDCdgo8QJR+qDV7aQ+T5oU2clmfQD12VIgLAb2/cOUK0r
	L1P7sK/lJ6APLuzzPkiAP9F1s8IXRrk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gYHUrw+E;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761119254; a=rsa-sha256;
	cv=none;
	b=v8Z7QtNjkLbc1yQA/TqLDVdsEge5cZKHumB31HdWW+mImQHL6ebHeU+YQ6u1I+/yHglGZi
	XbzUdOxvkTDzQKWf74PXMVwJ2OiMe6aO4u9veYr5z/LB9C0bzMlnrmKA653QlTVzZfjvDI
	zN3NtJJsZ7LZseEGKp7wfozxqf3lhD0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761119250; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=H+qvTFZ8jw1vc9BmwmZE7CbJfZv05rrBieJVcIWZoxI=;
	b=gYHUrw+EOv0Qwen4ZbP71MLbCn23m6DO7FQo6cDrxEpMgM6O/0UGoKGDazipr7Q+/Q6h/bFMuf58gkS+A0ffL5CNR/o1G594vEuxckejMQNMk21CSgmH2LXALEfv5r/cpXCczDnO8UUZKgv9WVagSIhAlvUfrOLZXn5o34WQ40U=
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wqm-W--_1761119248 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Oct 2025 15:47:28 +0800
Message-ID: <6d67cbbf-a609-491e-a0c3-a3d5fd782966@linux.alibaba.com>
Date: Wed, 22 Oct 2025 15:47:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: fix THP allocation size check and fallback
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Hugh Dickins <hughd@google.com>, Dev Jain <dev.jain@arm.com>,
 David Hildenbrand <david@redhat.com>, Barry Song <baohua@kernel.org>,
 Liam Howlett <liam.howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Mariano Pache <npache@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20251021190436.81682-1-ryncsn@gmail.com>
 <65f4dd0b-2bc2-4345-86c2-630a91fcfa39@linux.alibaba.com>
 <CAMgjq7D_G=5bJe_Uj11sHV2qCyu-Z-3PZu7QuZyPEhuFiE63wQ@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7D_G=5bJe_Uj11sHV2qCyu-Z-3PZu7QuZyPEhuFiE63wQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3C61440007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tjykg79wb16a8rtuanwy3tq4hkjeh7h9
X-HE-Tag: 1761119252-84547
X-HE-Meta: U2FsdGVkX1+LwZ+nQUqgIKFphg337TuLJfITBEcShly8qQts1wlxzd3HMlminSvdOplbY+u8BqEQNshXgk3mocBD+M0CkD+Cld+GSiFHLoZNkP8l0RE+CNKw9gOIwQNwqapLJoSBKNU59CF0vAscvitKPOO+E11FFc1m1m5j+k9Q7JTsLmmbFMlv42hBW+7+r/6vfCmeC0LKWvEnJ1iBgluibseJ/Np1GNjtwG51AwcZOzDtxMR8Dw/KRp0AMJRBKXc1TzUfDW5LM490XrWrixZXImyUnKv4y4NX8Qo3Yz+JDaKh5848EXLncApv2U0BXexRZu4GEnMK0YR1AzGYc7iv6Cr0jElhEF2MLCfIzhFZivz3MAV1eoU3g1SfqGVmuPS0RKqf1UmwJaNB/lSA6D2BuJDWS99wkT/k7GFRlTbOnJhuUgFbgTJSAvdKP0Ii37fRbVw+qo1QadOz1FqdmMQS9hIsM4dAO3EKXryKT1WUZHg9eP/G5VJm+yqgYDwRNs+cs19munlNGVzlqeLEt3gVrqTFIciIkEPIVZ/dVJ31ClsHO3LzS5+7NL87cyS8z4yiDklzgnbGgCXcZS2SOHs7VG/GRgGI0nE3iiZFEbYMk7cfm1m90s5O1wWoGYIJGHDiY31tjIexB4qfVlO4YByp0zGgSrBsQFfPEwqSDq3ipEX/YZ68Ix0WpKTPN5GouyvCFnyyrbOXdjBwlxKMtnTjnMDfdVOcgdXiklB/XqgBWMgfLsz7Nfmas5FMlN5RHOx3Ql8xw4ekcAHWweNP7lLM5VwdxEYbdzAp2vEhMH8kFknWPj6rkBJXHwrxBxWci2EyijN5zNtC0Cw5YH1iynjo3oaQMkrMNnK6C+meGC4Dq3LyNbvo38qOkF+6z90FY45XFzvZflcq2EpqnzQp5g053k/vDesiRgvc40DeRCE0KpE3NHOb87aOi6pXfPt+rWXPleWzZPxjKdNTHwj
 /SbLpgMp
 XMUf+Y1w/Ig+7b6CmVKWMMT/taVoq8Agx50/fo7K6FsFeJg8cs2kRlu6JASOX5jnf/Ji0Z24WcWxHgRhczVI9SAY8zguY4SUGMH4yQayEnhpy3bjVjfeVn81pcyL5vNltOn5rcFv3xqKwncvi/pPcfOTvrXCbCheBKMNeEoWUbstwEGFTvRI3RYXy2YWVnYkqaoSuJQXeFO/TB68Rr2rwftzP2TRh3z8UFVdlp7agApyfJ9OzirG/TLwK8MYlu14yR3JurkzuVmse3V8Zu+zXfEj+nQKmnFznj8FPjGl3nCjd3MibUIplF2K/6IR4j0+GSobeMsJsJtlYwgKdGJ7nuBLgglVUV4WiTHDR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/22 13:48, Kairui Song wrote:
> On Wed, Oct 22, 2025 at 9:25 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>>
>>
>> On 2025/10/22 03:04, Kairui Song wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> There are some problems with the code implementations of THP fallback.
>>> suitable_orders could be zero, and calling highest_order on a zero value
>>> returns an overflowed size. And the order check loop is updating the
>>> index value on every loop which may cause the index to be aligned by a
>>> larger value while the loop shrinks the order.
>>
>> No, this is not true. Although ‘suitable_orders’ might be 0, it will not
>> enter the ‘while (suitable_orders)’ loop, and ‘order’ will not be used
>> (this is also how the highest_order() function is used in other places).
> 
> Maybe I shouldn't mix the trivial issue with the real issue here,
> sorry, my bad, I was in a hurry :P.
> I mean if suitable_orders is zero we should just skip calling the
> highest_order since that returns a negative value. It's not causing an
> issue though, but redundant.

I think compiler can optimize this(?).

>>> And it forgot to try order
>>> 0 after the final loop.
>>
>> This is also not true. We will fallback to order 0 allocation in
>> shmem_get_folio_gfp() if large order allocation fails.
> 
> I thought after the fix, we can simplify the code, and maybe reduce
> the call to shmem_alloc_and_add_folio to only one so it will be
> inlined by the compiler.
> 
> On second thought some more changes are needed to respect the
> huge_gfp. Maybe I should send a series to split the hot fix with clean
> ups.

Yes, I've considered simplifying this, but it would require more 
changes, making it less readable compared to how it is now. Of course, 
if you have a better approach, feel free to try cleaning it up in 
another thread.

> But here the index being modified during the loop do need a fix I
> think, so, for the fix part, we just need:
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 29e1eb690125..e89ae4dd6859 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1895,10 +1895,11 @@ static struct folio
> *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>                  order = highest_order(suitable_orders);
>                  while (suitable_orders) {
>                          pages = 1UL << order;
> -                       index = round_down(index, pages);
> -                       folio = shmem_alloc_folio(gfp, order, info, index);
> -                       if (folio)
> +                       folio = shmem_alloc_folio(gfp, order, info,
> round_down(index, pages));
> +                       if (folio) {
> +                               index = round_down(index, pages);
>                                  goto allocated;
> +                       }
> 
>                          if (pages == HPAGE_PMD_NR)
>                                  count_vm_event(THP_FILE_FALLBACK);

Good catch. I've fixed one similar issue with commit 4cbf320b1500 ("mm: 
shmem: fix incorrect aligned index when checking conflicts"), but I 
missed this part. Please resend the bugfix patch with a correct commit 
message and remove the cleanup changes.

