Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66961CAC58E
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 03:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5006B0007; Fri, 12 Sep 2025 23:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCCEF6B0008; Fri, 12 Sep 2025 23:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09756B000C; Fri, 12 Sep 2025 23:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC1D6B0007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 23:26:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B24311B135
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 03:26:29 +0000 (UTC)
X-FDA: 83882789298.23.07CEA9B
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf04.hostedemail.com (Postfix) with ESMTP id E10AC40003
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 03:26:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=s8lMUvZN;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757733987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LBPemiQvLMxvPRaP1xaM0T1pppLLfrD8DNU0toXcXBo=;
	b=p081kpUBpwBefOEE93iFbeJpbLYw0dGYzx8j68RXFehxbp3X8XTrUOTN+SwJqc1MPZcjQO
	vPqQvjy2NAoDBI5ZkdAyMVP6qGu32vK5wgdiVAsq5nDDPzmOmuyhuiJWQ0NoTzeIp9NFU0
	1WZy9X9uazgaUaLvjy6q8fwt12seCbo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=s8lMUvZN;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757733987; a=rsa-sha256;
	cv=none;
	b=AYK+tmmHUAxiymrbNBPFIcCcz1Iqd9YdhJhk/Gad3rrDbl0YB0P3cFTpkZ1jdhXKUiuTPb
	jRo4V7BrChoIJAQiPkOGUrpy8GallIdkxXynXwfhzXTlJtnFNRjWlvyNWuCcO8V+w3rp02
	FGqMpowwz7TWhDVFNjsS3iLnmba8BBQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757733984; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LBPemiQvLMxvPRaP1xaM0T1pppLLfrD8DNU0toXcXBo=;
	b=s8lMUvZNXSVQg4/b/wF+xJThTetnZEhAtxWpj7Y+zhMuUr6JFGkoBv3r4pcuL+hOebIMB65UGZI9826i4ydw0vQpYDNcuvsDmwrjtFgMWdyk2dCl1Y9553dbR4bcW/CmbmAuHJ52CkhntrbTiarBDpMYHoEy/rpD9NBS2rdV+M0=
Received: from 30.134.50.220(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wnse-95_1757733982 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 13 Sep 2025 11:26:23 +0800
Message-ID: <59ddf3bc-cfc0-40ab-ae2d-859724ef6168@linux.alibaba.com>
Date: Sat, 13 Sep 2025 11:26:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/15] mm/shmem, swap: remove redundant error handling
 for replacing folio
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>,
 Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250910160833.3464-1-ryncsn@gmail.com>
 <20250910160833.3464-10-ryncsn@gmail.com>
 <0cb2bc82-1957-4efe-8c85-8558743dcf80@linux.alibaba.com>
 <CAMgjq7Bc6r2=BcAPCeVPcVJ_hP8bXTs_pya2fWg8ZL-vTG9SAg@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7Bc6r2=BcAPCeVPcVJ_hP8bXTs_pya2fWg8ZL-vTG9SAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E10AC40003
X-Stat-Signature: npog7h14owbe53fxgxu3n6ky9mfjiayq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757733986-752220
X-HE-Meta: U2FsdGVkX18MpatwdR8P9PtwA4YSnkkIml78AAxG9bclqFMSl0BNV1YOr0+xgd/ekgLIiNTKxSuSN3nYglo8UkZTaUn5gCF/IYIcIbKk63ggVMxCOWAuYse2Chi1icn2uqCSFJXD9/BVotbBnFPU9Ryyfx5M+X5ViLqcobnkg3+cuVRMhfX4m/9Dm3i7VoWTX4iaMI1gJWu+BEHUYbND765ImId+RcDx72zie14GU85VzHPKBJ5vOLeKm/oJeN6eSStFyjxB9Qn5A/iDi/zbwlMuh78uuNvgjsO1cFefygMy8Y/pneArJMhK06muzqjwopzdWU2ZMDUBrdwmgRKdEjdh8LPZpIoNo3u8LbWLM46matk2jkLGzDHVu6zxF3Kga8qcIKoTz66MnaigAxGoMDatp6K7t0X0f0RljaSzWd3vHgig0aYTYAK4NREfJ1U1ymm7WHcH0j76Gv4kvAkaIR0v0KnjQSsR0XvZz0NzuvaEBoltptbtGKnJuqZSQg/eJZ35pJ8U4pOGNIKsj28jm9GdcTijWMWFPrtXCXcPEy4o+7qT69NkGShsQGVSe0PEsFXl5tfCd064I0jRt0R8xI7WoiVukVrNsMlNDNzaOqC5p9cdxig2F7512i4TG/pSJ6437ZqjfQN6reydz5xwKt/PamsPHCcuQa+FgYb89/0RrUH7WpHtXgIQPVm6cgwvaU/9apnD7tXJFbiu3Uvc4N+iOS+JubY8hE2PL5pabg9R5RadkosWYawafUy+zVsRZx2y8Df1LXDYl1qVB8mk5UkG1Rc8bkTCZuIRjD69yQLIKUTHCf01wPT0ekbMC53PWH66jrisiZf6QpwXcvvxt9ed9Jdzn+gwsFla9qhnUQR+RYuV+ekJD4QmJ3UeC7PmXn3mYAs89MQwy2vRsK9QytCdji+jXp2MDyBSsDS7vO4Ks4Y+82JX/Z5IADu4hlT3KoXcTAGaE0XeadCSWId
 YnP3kEbP
 symlXM+MVVX2okxuLPDE1OqP1nuNJMVHGEdJ6TZi2cuXxuLonE3Rr2tC5zh66mBsprGUKY9FzcFwKtIBk6BZ1nEdQz6unNBR2wlAawa/QXmV7UZdZJQDG8Je1lNsPq2pcT7jdJMo+gDKKAt1mc7vbDwCW0KzDFEHvXjMQHTU2T2nkjqsat1p6kxstjGnRC2sU5ea7g2eDyzOC1Bhm41ibqPQuZSp18P5Ze470AU4vanfTsjrbp5PkJ++0lU+SXrzb5YmsEyOEmiP0t5HwGO9N6SMTCZ0HkOk9a4TNQA/sTbP8GPndbx2G7Xe1+Bnq1FNrAF/xeWGBAQy+63WRpuYoIvbGn5taWcVeHHoBpK8szSv2fUkntgjtX3H9Yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/12 20:36, Kairui Song wrote:
> On Fri, Sep 12, 2025 at 4:22 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>> On 2025/9/11 00:08, Kairui Song wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> Shmem may replace a folio in the swap cache if the cached one doesn't
>>> fit the swapin's GFP zone. When doing so, shmem has already double
>>> checked that the swap cache folio is locked, still has the swap cache
>>> flag set, and contains the wanted swap entry. So it is impossible to
>>> fail due to an XArray mismatch. There is even a comment for that.
>>>
>>> Delete the defensive error handling path, and add a WARN_ON instead:
>>> if that happened, something has broken the basic principle of how the
>>> swap cache works, we should catch and fix that.
>>>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> Reviewed-by: David Hildenbrand <david@redhat.com>
>>> ---
>>>    mm/shmem.c | 42 ++++++++++++------------------------------
>>>    1 file changed, 12 insertions(+), 30 deletions(-)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 410f27bc4752..5f395fab489c 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -1661,13 +1661,13 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>>>                }
>>>
>>>                /*
>>> -              * The delete_from_swap_cache() below could be left for
>>> +              * The swap_cache_del_folio() below could be left for
>>>                 * shrink_folio_list()'s folio_free_swap() to dispose of;
>>>                 * but I'm a little nervous about letting this folio out of
>>>                 * shmem_writeout() in a hybrid half-tmpfs-half-swap state
>>>                 * e.g. folio_mapping(folio) might give an unexpected answer.
>>>                 */
>>> -             delete_from_swap_cache(folio);
>>> +             swap_cache_del_folio(folio);
>>>                goto redirty;
>>>        }
>>>        if (nr_pages > 1)
>>> @@ -2045,7 +2045,7 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
>>>        new->swap = entry;
>>>
>>>        memcg1_swapin(entry, nr_pages);
>>> -     shadow = get_shadow_from_swap_cache(entry);
>>> +     shadow = swap_cache_get_shadow(entry);
>>
>> Again, there are still some issues with the patch split. The swapcache
>> related APIs replacement should be placed in Patch 8, otherwise there
>> will be buidling errors after applying Patch 8.
>>
>> With this issue fixed:
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>
> 
> Hi Baolin
> 
> Yeah you are right, I need to move these few changes to patch 8.
> 
> BTW I also found that the WARN_ON and irq unlock needs following fix,
> the stats update need to be done with irq disabled:

Yes, indeed, I overlooked this.

> diff --git a/mm/shmem.c b/mm/shmem.c
> index 957e40caba6e..c4d491c93506 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2121,14 +2121,14 @@ static int shmem_replace_folio(struct folio
> **foliop, gfp_t gfp,
>          /* Swap cache still stores N entries instead of a high-order entry */
>          xa_lock_irq(&swap_mapping->i_pages);
>          for (i = 0; i < nr_pages; i++) {
> -               WARN_ON_ONCE(xas_store(&xas, new));
> +               WARN_ON_ONCE(xas_store(&xas, new) != old);
>                  xas_next(&xas);
>          }
> -       xa_unlock_irq(&swap_mapping->i_pages);
> 
>          mem_cgroup_replace_folio(old, new);
>          shmem_update_stats(new, nr_pages);
>          shmem_update_stats(old, -nr_pages);
> +       xa_unlock_irq(&swap_mapping->i_pages);
> 
>          folio_add_lru(new);
>          *foliop = new;


