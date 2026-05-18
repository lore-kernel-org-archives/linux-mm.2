Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37D5CCD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 05:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FC756B0005; Mon, 18 May 2026 01:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ADA26B0088; Mon, 18 May 2026 01:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C0B6B008C; Mon, 18 May 2026 01:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44C116B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 01:01:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD8D412075F
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:01:24 +0000 (UTC)
X-FDA: 84779342088.07.E452F11
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id D80DC14000E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:01:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u1nu6tPq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779080483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tlo2znxNKON1HwKplhS/NvaV1BD9SxzqEEMSISG29kQ=;
	b=0GGH9EY/78M8QxAj8BuvvVaC5KsLKHAlwh7o3xplNWWgYnoQnffto/ZpBgxDtA+Q4O0e/z
	/bxUNKloa1BUUFm8YokaGJVNYKAa3Dt5Z2kBwexIXDVkzkc7zX2not5EbuXz/RC6cSmGNn
	MsEn/USbnm1MMKeulf3vhjtLhA2n7AU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779080483; a=rsa-sha256;
	cv=none;
	b=ie+9YssxTH6Rda+ht3ECQfkoAukjlKbtmvhkeLdMQSBqyxQ/J18VgBQY6OCVNwa35jg4JB
	1WEpVgnj9M3gDw9V39Yo6I9EDxA+4sT1VRNTCByLrK3qP1RsgAc59C8gg+TeS3kuh6fPGr
	0Vaf1CvpxGCkPbQa+Vawa9cbZwwW7Ak=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u1nu6tPq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <8c1ab541-babb-462e-b366-4555d2a09b43@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779080480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tlo2znxNKON1HwKplhS/NvaV1BD9SxzqEEMSISG29kQ=;
	b=u1nu6tPqa9rl30GPY5zmDKUsg/5PpE5pCLgXqaOaPeB01c8rdFyhMqr68AntP26KX122Ie
	KlCKElKIYNFvMUtVgIfHhBysKIVIcKzV5xPeCLUYQBrzpkvhiHPAOOqDExQAEYvr2a/CST
	59qNezxjuz+1i27rOG2ldrCk0shu7WA=
Date: Mon, 18 May 2026 13:00:49 +0800
MIME-Version: 1.0
Subject: Re: (sashiko review) Re: [PATCH v4 6/9] mm: shmem: drop
 has_transparent_hugepage() usage
To: Baolin Wang <baolin.wang@linux.alibaba.com>, luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 ziy@nvidia.com, corbet@lwn.net, tsbogend@alpha.franken.de,
 maddy@linux.ibm.com, mpe@ellerman.id.au, agordeev@linux.ibm.com,
 gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
 x86@kernel.org, dave.hansen@linux.intel.com, djbw@kernel.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <ed33dc0f-fcde-42b3-90aa-c20290b06f49@redhat.com>
 <20260517133239.26416-1-lance.yang@linux.dev>
 <6591a74c-7ef9-4614-9ae9-cb2fbed86ebf@linux.alibaba.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <6591a74c-7ef9-4614-9ae9-cb2fbed86ebf@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: D80DC14000E
X-Rspamd-Server: rspam04
X-Stat-Signature: zueq3m5nr6t4i8cj1qqrjx3j888tokb8
X-HE-Tag: 1779080482-790011
X-HE-Meta: U2FsdGVkX18KhmlYqYmJ6Eq4tf1jjS2nxwxiExbjH+BozigWSlPGCf0VgGcfKo+0nsH8luCKzz3hkkt1msBElIiEuwNmHvEMMnLoPQ2MuNJ6Pkc26cmZZ/jCy99UA8ceOiHywBi6qM27ceoA7F7BBJbtpyxQdi2ncDQrBH8i34NhYki1RPBeoI68fMV0kVOpZZouhWRL/YsuidV08w6FMWXyrmHdnZanjkV9BMhsqb+fnTbpXQszXfanFdjaJypOdJtGwIPIOLX9I6fP2HaG1N3RPIuJCcv72pM69pWVmWoeqvanw6ftiTqTAZK69I5EIWC1E7xBx/B+6Ua7Yp5x5zcqHPzC6s775HIqUBMO1IDdhmvUlJGZRqEkylqyFirvihd/AUNS2Is2SskpZWit3kpr6aeGmc6+VyyHiaSYsBXiTJ/9ziTuCpw3Bm611NbIGh3QMcjKfFfByKzs8C2d/AQ4szgzlmv0jhmOPDEXTek7xgmPhmJt0hWTk6/nRApO6kaVKb802BF6QxBAnlJAXcfq6ElaZ0TCWk8+NSU7nwVWawyMYrpiTc9vmCCZJrl783aMTBOEl12dXykm/VEzOonykDyH7IW+WMkOJJo2cPv8Apselc0Z+gMZRAkGiXXGZS7ErsgkJJeOCfGPBx+/nXmMob/BHoIGWob70l3Z0JKxWwWob90l06pp6XwKaA68fHPR1zWrgWeWCdbJwSPg94DrhAb5zZFh6YXE0vm6K4/dmYHgYRDwc6U/eyXPXrh04brAfJM8Je92yl0KzhOna3hftUWIJa0UfjCRzpcjfBn48B9vYDj2MwIpj72IQgbJoX4FJaopDSTp78ThSIcooyzs3jt2e1YApHZMG5wtkGjNfzWky4l+9gpiTMrlKTl1t2e8u0EXoq5aR9ECKy7SYl9iFASZvbhaXnlhiKrDuwTJihh8HeCbmAtoE+LP4qbMAnFs3AuwXfZWlNE1LR6
 65R2h5dI
 I8MXSpRfTMJxO9OBJSnqO+WGFOlxs6g6I3L+CU+hJTGm1Iiv7P+I2hFNnWl8z8duqsu33GWM/99LEVFE1XB2TJlMGpjDxO7j6m90yVzSZrcF+wq+9fyYzGI0Usx+TBr/2hduvwsELJIWfVxqluHW08TJjWYwtGnDlZ3N61r2xuBozVjYIOvb/S1gPEzcXnZu5EMVozhv3bveVn62KGyHApuLqMZRNlJ9FASmEfmzItBYSqfWWPQ46AK47wLosi5HcXAc+Wo+EQD5Ftmt3I4xLybw6fXtm6+YhrQB/QxAn51Sm8a+aybLaz7Uvs1XErtu+qn4ZzaIn32RhJKHV8NfrHulvtXpvskrlUoyYm7DV0xzYdLrdHwCYFdDvtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/18 11:47, Baolin Wang wrote:
> 
> 
> On 5/17/26 9:32 PM, Lance Yang wrote:
>>
>> On Wed, May 06, 2026 at 02:12:41PM -0400, Luiz Capitulino wrote:
>>> On 2026-05-01 15:18, Luiz Capitulino wrote:
>>>> Shmem uses has_transparent_hugepage() in the following ways:
>>>>
>>>> - shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in 
>>>> and
>>>>     if the CPU supports PMD-sized pages
>>>>
>>>> - shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
>>>>     the code block calling has_transparent_hugepage(), the
>>>>     has_transparent_hugepage() call is exclusively checking if the CPU
>>>>     supports PMD-sized pages
>>>>
>>>> While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
>>>> in all cases, shmem can determine mTHP size support at folio allocation
>>>> time. Therefore, drop has_transparent_hugepage() usage while keeping 
>>>> the
>>>> CONFIG_TRANSPARENT_HUGEPAGE checks.
>>>>
>>>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>>> Acked-by: Zi Yan <ziy@nvidia.com>
>>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>>> ---
>>>>    mm/shmem.c | 7 +++----
>>>>    1 file changed, 3 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>>> index 3b5dc21b323c..1948d73fb1e3 100644
>>>> --- a/mm/shmem.c
>>>> +++ b/mm/shmem.c
>>>> @@ -689,7 +689,7 @@ static int shmem_parse_huge(const char *str)
>>>>        else
>>>>            return -EINVAL;
>>>> -    if (!has_transparent_hugepage() &&
>>>> +    if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>>>>            huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>>>>            return -EINVAL;
>>>> @@ -4656,8 +4656,7 @@ static int shmem_parse_one(struct fs_context 
>>>> *fc, struct fs_parameter *param)
>>>>        case Opt_huge:
>>>>            ctx->huge = result.uint_32;
>>>>            if (ctx->huge != SHMEM_HUGE_NEVER &&
>>>> -            !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>>>> -              has_transparent_hugepage()))
>>>> +            !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>>>>                goto unsupported_parameter;
>>>>            ctx->seen |= SHMEM_SEEN_HUGE;
>>>>            break;
>>>
>>> """
>>> By dropping the has_transparent_hugepage() check, will mount -t tmpfs
>>> -o huge=always now succeed on hardware lacking PMD support?
>>>
>>> If so, since hugepage_init() still sets the 
>>> TRANSPARENT_HUGEPAGE_UNSUPPORTED
>>> flag, thp_disabled_by_hw() will unconditionally block all large folio
>>> allocations in shmem_allowable_huge_orders().
>>>
>>> Does this create an intermediate state where the mount silently succeeds
>>> but no huge pages of any size can actually be allocated?
>>>
>>> I see this is resolved later in the series by commit cd27430097e8
>>> ("mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()") and
>>> commit 641a20ae032f ("mm: thp: always enable mTHP support").
>>> """
>>>
>>> The mount -t tmpfs -o huge=always succeeding on hardware without PMD
>>> support can happen in this patch, yes. But this seems very minor, the
>>> impact seems to be someone doing bisection, landing on this patch and
>>> their reproducer is depedent on mounting tmpfs with -o huge=always on
>>> hardware without PMD size support? I can fix it if others feel strong
>>> about this.
>>>
>>>> @@ -5449,7 +5448,7 @@ void __init shmem_init(void)
>>>>    #endif
>>>>    #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>> -    if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
>>>> +    if (shmem_huge > SHMEM_HUGE_DENY)
>>>>            SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
>>>>        else
>>>>            shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was 
>>>> patched */
>>>
>>> """
>>> Also, by allowing shmem_huge to be set to SHMEM_HUGE_ALWAYS on systems
>>> without PMD support, does this incorrectly affect shmem_getattr()?
>>>
>>> shmem_getattr() relies on shmem_huge_global_enabled(), which only checks
>>> the software configuration and not hardware PMD support. Consequently,
>>> shmem_getattr() will erroneously report stat->blksize = HPAGE_PMD_SIZE
>>> to userspace.
>>>
>>> Since subsequent patches in the series do not appear to update
>>> shmem_getattr(), could this misleading block size cause userspace tools
>>> to over-allocate IO buffers on hardware where PMD-sized pages are
>>> structurally impossible?
>>> """
>>>
>>> This a real issue (albeit small one), the problem is this check in
>>> shmem_getattr():
>>>
>>>     if (shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0))
>>>         stat->blksize = HPAGE_PMD_SIZE;
>>>
>>> So, we may report HPAGE_PMD_SIZE even when PMD size is not supported.
>>> Looks like we may over-report today as well for the
>>> SHMEM_HUGE_WITHIN_SIZE case? In any case, I'll fix this.
>>
>> Well spotted.
>>
>> @Baolin looks like shmem_getattr() might already be buggy?
>>
>> shmem_huge_global_enabled() returns an order mask. For huge=always and
>> huge=within_size it can return THP_ORDERS_ALL_FILE_DEFAULT, which is not
>> PMD-only and can include smaller file mTHP orders as well ...
>>
>> So shmem_getattr() treating any non-zero mask as HPAGE_PMD_SIZE looks
>> like an over-report?
> 
> Normally, it looks fine because we always start trying from PMD-sized 
> large order if tmpfs supports large order (see commit 69e0a3b49003 ("mm: 
> shmem: fix the strategy for the tmpfs 'huge=' options")).
> 
> And the code here works for 'force' or 'always', but not so much for 
> 'within_size' or 'advise', as Hugh mentioned before[1].
> 
> Especially in 'within_size' mode, after we allow fallback to smaller 
> large orders, the logic becomes unreasonable. Although I'm not sure if 
> there's any benefit after the modification, it would make the logic 
> clearer, for example:

Ah, I see. Thanks for the explanation!

> diff --git a/mm/shmem.c b/mm/shmem.c
> index 106e4de943fb..e9f43aefdc7d 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1297,8 +1297,14 @@ static int shmem_getattr(struct mnt_idmap *idmap,
>                          STATX_ATTR_NODUMP);
>          generic_fillattr(idmap, request_mask, inode, stat);
> 
> -       if (shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0))
> -               stat->blksize = HPAGE_PMD_SIZE;
> +       orders = shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0);
> +       if (!pgtable_has_pmd_leaves())
> +               orders &= ~BIT(PMD_ORDER);
> +       if (orders) {
> +               unsigned int hi_order = highest_order(orders);
> +
> +               stat->blksize = PAGE_SIZE << hi_order;
> +       }

Yep, using the highest remaining order after filtering out unsupported
PMD/PUD orders looks better to me. That would keep the stat hint aligned
with the allocation path :D

> 
>          if (request_mask & STATX_BTIME) {
>                  stat->result_mask |= STATX_BTIME;
> 
> [1] https://lore.kernel.org/all/1524665633-83806-1-git-send-email- 
> yang.shi@linux.alibaba.com/T/#m21037b23be70fb9f7ab1965bb8b39242752594d1

Thanks, Lance

