Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30963E94626
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 02:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 925B26B009D; Mon,  9 Feb 2026 21:25:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D36C6B009E; Mon,  9 Feb 2026 21:25:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CBC46B009F; Mon,  9 Feb 2026 21:25:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 676586B009D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 21:25:39 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F0EA61A0382
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:25:38 +0000 (UTC)
X-FDA: 84426955956.02.CA22998
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf19.hostedemail.com (Postfix) with ESMTP id 28E191A000B
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:25:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XcwDBI8h;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770690337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X204tj98l8Xz4PuAgzHG5WPMc/+SwoCgN6960bpJKFk=;
	b=lVRv23fRqdLeMedDzb6oK/xx2YykfEXwQJKeYyU4Kkkkar5GiHYrNPk7rC9JDQiwkwK7ju
	KL9ECW45PSpHyRp/Oko/5KusmuAkpKB9cUrX3Rnp3sAaRmWBDfFerL8zgqXXEC5OPARHym
	8hRPvJ8sdJREWq4eDLsq6r2qqqhqY1I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XcwDBI8h;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770690337; a=rsa-sha256;
	cv=none;
	b=EjuN03QVs8ZHCT6tv/8AovsyHUs9tLmMiFEkv0H67OSNzQiyIxC54SL6ilJ483rT4sfMWS
	qwyc9DzFvHo59KuuJZ/Kyxav8A0nsmFPUPNdgopM0HxdMkL/ZhVWiFCmI1GgVZk5wJxR8u
	r4A7fL8/AtYRaaf2ArA+TS7NrM7kCfc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770690333; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=X204tj98l8Xz4PuAgzHG5WPMc/+SwoCgN6960bpJKFk=;
	b=XcwDBI8h7yzZq5bVWWy6vQCTD7E9OcfY3luzuSupE/o6jqjsRMK7UJH/YtS4UjGlU8WLfssfepwJNeJ9FN25i3+lb7Pao9i+/yoklkzjjd7e9QMIq6mfOl+/qjfN6X+elIh+FY9jwuPQZzKDgT48jxwdXrVD8EeTjYnE22NndT8=
Received: from 30.74.144.109(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WyxNktA_1770690331 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Feb 2026 10:25:32 +0800
Message-ID: <42cc23b4-4fd9-4286-8090-371cee180687@linux.alibaba.com>
Date: Tue, 10 Feb 2026 10:25:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, npiggin@gmail.com,
 linux-kernel@vger.kernel.org, kasong@tencent.com, hughd@google.com,
 chrisl@kernel.org, ryncsn@gmail.com, stable@vger.kernel.org,
 willy@infradead.org
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
 <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
 <0BC1D792-80CA-4E60-AEA0-187F73BD4723@nvidia.com>
 <bc0b6d03-4309-463d-a112-aae57cee335d@kernel.org>
 <22431471-b569-4ade-9881-387debada00b@kernel.org>
 <91F2E741-5473-4D34-ADA1-C9E6EDCBF5E0@nvidia.com>
 <546b200d-5b70-4db4-99f1-f50f6a343c10@kernel.org>
 <3E055DAD-647A-456B-9230-4DD2574D4E8E@nvidia.com>
 <4a759288-baf9-4fe6-9d16-034edf6615f0@kernel.org>
 <72534BCC-2581-4BFA-B3BC-2CC6FF1B1E7A@nvidia.com>
 <e69270cf-dac1-448c-ace8-3f789e5cdc6e@linux.alibaba.com>
 <71370B54-A462-4F72-AF82-8E076AF112FC@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <71370B54-A462-4F72-AF82-8E076AF112FC@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fuqineega6mx9euekotjgipjcubh1u3d
X-Rspamd-Queue-Id: 28E191A000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770690335-20687
X-HE-Meta: U2FsdGVkX1/dos9ROg2XLCoTraXYvmiYNywkKBswX8BuyhgSdg1dE2SMR+DYrxpumPNi1QWob6FUVAV2aJxG0BCdbQXiIywFbZXTcRusNg6nCW9QjCaC6dfCAISvvvufite7KK/rcFik/PfDEaW6Es0fE2ttOxrqLgIpQUvC9MpcR2QODKzYSE9MkHKVwK8zXVvGIoC/wLAiU/TysrA0oUqISPK3s7Bll4fVMBJT4UnwU7y5zxlaIdYL3QDNumuLErI3DcGvUwRpCqA2WZ2uDaYucHZdEMwwq5kIFFERrAH/1RCCMT8ee8z8y1jPLZg/P3L6BIJ3tOuGlQnU2+x88QiKinJLd4pJCI9/9T5PYOlXNGc+OQEYipYQ7JQniI4lfuHlbm2KwLgGC+S6+Rc0xuPlzdd0LH645ObU27bcCt1q5BPWLe3+kHrqFtkUcTJ7KR1rWu2n5uH20Ad/nDYly7ScvY4nkT/YHWfM4OI3KFVpft6McBKyEnBKTLHyeRefTjZv6OkCUUzTYNo1jsY6TV1kJLwsQm/XExnWoC8bzwbk+N+gaP169LTc23+LuIfrBTP+wVLSb79Lj5a4VxkQCJol7aNnElwydc0quGiM8mAaS0tfJJm7Mz+X9Mtq/9h5qXp+D8+BME+l2UAKeYc5eqP/QQ4PNITfYn2NPeM2w4G5FrkyDU3yTbG3z2EYt8H8bxsnd9r0G0VW1A6BHhJa9lCgG8kjcXuQXNFWabo13zUSmfkrvfh5WP8CiyJ/+H3OwJ7jRiantO/DzScdjufl+OtYeAE3kpTxuwSToElvkg40MD9BBH+X7LfnedBgzSRrvmJMesvXuv4/mg9tX1LJHeDUJp2H/HKCZERxITTGCorKIcVmX/fiVfRGGydNJiUdYc1Msvoq/PuR1GQlKFLCuLGewOfnpiSjw5nZp/EtiuToSdLHKUxln+Gszei1D/l7HDKO+NyI09tXz//p/LW
 CputMbTN
 26J4I/dMckW06asYNx90wQAZkk36kgridMxdcdGFMb89P54h4Pp0Wgt6yuxMau/IkRHPeMIh5tXTHUsk3RqjGIHkgZXW8iGtOl7eSLRMjmAdS+X+gQEudbcgM4hmKUleA38hRC+1NZ96jZHQ7BnMlRSehyNnAdjjbjw8+1ppcnHufzQYLiutl9yXC7ipILPQC85YPk7zW+d0Ert71RZAEnHmg2A/QUbOJk602I5zhozNdDVwgGF8zKl6ZEPZNNgIfgJiNQhL8l1rYVUWaLyVmHO6GRF1jvTJFF7t4j1oOEOEv/QTOlUTDWJAkMGnkFqRFdOAFrTvP1drBWlS0I5K352k5Ie0Pq3m6cAVEVsIFWOR9GOzy20QayZj0GMuZRUQ2Dew7MlvBMIg43jzkzYfyRlRGlcZvBFxY5IIrrAXmbgAGCAyCL1kzmiJDucpEPF4gUfmUjqHi33yWsG5IthQBNxYKu77mh1fYjep8ziICiTpZUeZVppTT05/UpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/10/26 10:12 AM, Zi Yan wrote:
> On 9 Feb 2026, at 20:20, Baolin Wang wrote:
> 
>> On 2/10/26 3:42 AM, Zi Yan wrote:
>>> On 9 Feb 2026, at 14:39, David Hildenbrand (Arm) wrote:
>>>
>>>> On 2/9/26 18:44, Zi Yan wrote:
>>>>> On 9 Feb 2026, at 12:36, David Hildenbrand (Arm) wrote:
>>>>>
>>>>>> On 2/9/26 17:33, Zi Yan wrote:
>>>>>>>
>>>>>>>
>>>>>>> I agree. Silently fixing non zero ->private just moves the work/responsibility
>>>>>>> from users to core mm. They could do better. :)
>>>>>>>
>>>>>>> We can have a patch or multiple patches to fix users do not zero ->private
>>>>>>> when freeing a page and add the patch below.
>>>>>>
>>>>>> Do we know roughly which ones don't zero it out?
>>>>>
>>>>> So far based on [1], I found:
>>>>>
>>>>> 1. shmem_swapin_folio() in mm/shmem.c does not zero ->swap.val (overlapping
>>>>> with private);
>>
>> After Kairui’s series [1], the shmem part looks good to me. As we no longer skip the swapcache now, we shouldn’t clear the ->swap.val of a swapcache folio if failed to swap-in.
> 
> What do you mean by "after Kairui's series[1]"? Can you elaborate a little bit more?

Sure. This patch [2] in Kairui's series will never skip the swapcache, 
which means the shmem folio we’re trying to swap-in must be in the 
swapcache.

[2] 
https://lore.kernel.org/all/20251219195751.61328-1-ryncsn@gmail.com/T/#me242d9f77d2caa126124afd5a7731113e8f0346e

> For the diff below, does the "folio_put(folio)" have different outcomes based on
> skip_swapcache? Only if skip_swapcache is true, "folio_put(folio)" frees the folio?

Please check the latest mm-stable branch. The skip_swapcache related 
logic has been removed by Kairui’s series [1].

> diff --git a/mm/shmem.c b/mm/shmem.c
> index ec6c01378e9d..546e193ef993 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2437,8 +2437,10 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>   failed_nolock:
>          if (skip_swapcache)
>                  swapcache_clear(si, folio->swap, folio_nr_pages(folio));
> -       if (folio)
> +       if (folio) {
> +               folio->swap.val = 0;
>                  folio_put(folio);
> +       }
>          put_swap_device(si);
> 
>          return error;

Without Kairui's series, this change is incorrect. Yes, only if 
skip_swapcache is true, the "folio_put(folio)" frees the folio. 
Otherwise the folio is in the swapcache, and we will not free it.

>> [1]https://lore.kernel.org/all/20251219195751.61328-1-ryncsn@gmail.com/T/#mcba8a32e1021dc28ce1e824c9d042dca316a30d7

