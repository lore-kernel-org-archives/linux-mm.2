Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE266606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 02:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gfsdFogV
Received: by kanga.kvack.org (Postfix)
	id AC8FF6B0632; Thu, 12 Nov 2026 21:32:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79DB6B0638; Thu, 12 Nov 2026 21:32:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 990246B0642; Thu, 12 Nov 2026 21:32:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 751706B0632
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:32:22 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1796F401E9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:32:22 +0000 (UTC)
X-FDA: 85428521724.21.745D6A7
Received: from mta1.migadu.com (out-107.mta1.migadu.com [95.215.58.107])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5085520008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:32:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gfsdFogV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.107 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794537140;
	b=IaWacY1U5vYH1ErqiN3BfrgtntdLcy2PlYOCMsIHNmKJJCwS9BBuCzABc8ItqIjRG2OSoE
	2vuiMi7LWvJlpjNTOxpaXnVZX0L3uOiwIzZLlzoMquO0n7KWURLXVg8ZqoIUMQQ6cueGJ8
	tQ5sk7ckChIC3dUTbmIWjUDM3pn/KNc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794537140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbpLTpOGMpA+HgcOkuaLW9mLJLwh3XI+GukCg+jrEFM=;
	b=miNM6Sv3yadnWSZgYoHl1CZ6cprMMApioqRYRDcZwl/EskmSgw6Vf+0gjEH/m1tYOaFKPL
	fPtPuo60yIsjRdSdf6Rw3x6sRGiiQoQ1tgdwD6Vj8o30rJ5mnlrneT0fmesHgqxCUs4zK7
	sPPgQbLVAjWzpPHuCq+bg3yIB+8/rTI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gfsdFogV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.107 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rPYNFO6YVUN4UZ9ePQsjHDKAQ5JmLGEIdbmrTTalDLg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794537133; v=1; x=1795141933;
 b=gfsdFogVEW4Zflj3Q2WrLFOcUfh9cxOqpK21xmbi3TyuovSp4b40nuUQyrxbpUrxs+bhPWMD
 rjQ/y9uM0/wVszDfyL6CFaK7OtbQQS8GEmIwVwFXqEO0N6J65TSU3btXekNOs11CndaTtnZ7Y9W
 oQLdbD0NMIghJrjwYVhjpKOY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 92e45a4d795c9232;
	Fri, 13 Nov 2026 02:32:13 +0000
X-Mizu-Trace-ID: 92e45a4d795c9232
X-Migadu-Flow: FLOW_OUT
Message-ID: <1cd3c151-24c2-4fec-8356-99853f8d6971@linux.dev>
Date: Fri, 13 Nov 2026 10:30:46 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] mm: hugetlb: fix GFP mask propagation to CMA
To: Kefeng Wang <wangkefeng.wang@huawei.com>, muchun.song@linux.dev,
 osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org,
 azpijr@gmail.com, lance.yang@linux.dev, Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
 "Oscar Salvador (SUSE)" <osalvador@kernel.org>
References: <cover.1794379433.git.zhengqi.arch@bytedance.com>
 <1c5e8c4ae230dc238a16f2f42d65bffac6244ad3.1794379434.git.zhengqi.arch@bytedance.com>
 <7def88b4-cba5-4e8b-9e68-6069c492b582@huawei.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <7def88b4-cba5-4e8b-9e68-6069c492b582@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5085520008
X-Rspamd-Server: rspam12
X-Stat-Signature: 9qj9q7w67zf54gsnd6w1wtqojsnrzt57
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794537138-212700
X-HE-Meta: U2FsdGVkX19C8cGIHnxlpeWOLTa2cEpogKwIj3vEF/m2HrsKgQIvncPP3OEindjspC7mlvBiCXQ/sMGzv9mExFfCQpjBX+sfU5rOY5BLbkDi+vB63xZk2mR5BjPoNadsBxMQlGpH8s3YM8Bp4R0+zIR2znNuQiJxp0ltvTf4JyFBgCcCWZnBgROsnPqQssHHHiLRcf96hRyGvDGOBTysEyBPBo28c6ARdTc3ixkodfIbjWhHy69PNrH5w0xxC5C4rXlAJGFtYMB8MTwAqVSsGgz/KWJ8nk8etE8IgxI/o5zFDCSl0rXd0n+DHpZTUwCTmBvVL087hnmvcfBCWf47BdtkJqfVDDfDQf37Ryl8UsqVVXDWrjbegezAa+jWwpPQR/LWCtaCkV7aKh1Uy1sFn/ahMBACrmsB4sNkR15xBRKtCOct1NcXjKfjNMHl159gLYLdOJRxMkgxnr7ehvr5yL7kjfeZi09wwc92PiiQnC2ka1GEEczPdQRrtxack/51oI7JzKzyoxlv56vIVQJ6OJ6n24zsNGjqknGdUAlu4WhdIdJbmLuelYVhihLLDDkO+IUH1SclLvlgSaYQC0goJ9+1N7WUO3qnTc2FOMLhdQMTWQjTNEnDVrUG7c82tW/7Ir0kp+8MJzMBlZ0llZLcY0Dk015AxOgjzh7Xte5rqB9KjjZKBJm4w8IOAisT00e+/x91I9DhFJim2rnFiXfX6SSBShmk0otfAQ7w3uBK9V3FmNxJ9akTvQXA0YH1Pl3BKM8LkqahvCc4Jckp5u7UFQ//msYnQTSyIW/6POGJJ28ulNRZdR6niexglD+TGhF3TwORlUcQRkv9Wivr7BZwYD9VkFICplRLrzCnvAR/OcgKEtct7/OGyv/NimNkWZup1PEMmRTqpCYQvPp6lNezdosHJ/r0kaZIJj0fsph6/dLgLact5/zCfYkU/2nrWgXsPGDwQRgFszbTwHzLp9a
 5ghNrWXP
 SkuQr9QZ5+C5gPmeDnwWfZjqeVZkZNiZ3FjW7gzI5vKCvoRyFcN5i8bUdzI/LofLcOMxq/9jmOD2cB5bvbul2k8fjW3xn90hyDMetpBe8QwjFLugdNrM/pdalQcwBALuqOrdlBROk4+NsTZaAVu5O5E51M1FLBiw11ZxhSxzGV76STRMAedrsJQgJMHfHIPxE5NsMlFSBDJ/OB+YTH5M0n2XCDC0GTW6BtKvKvGZvX5PauWzmdohvmD6G6Q1lxMjTlTcfXgymowcFSw2iv0KVXuaRw7rW3/eFIb5DPYhGtskQrPvJ3jx8PZzrGjp3g+P6dFWsuiyoVKXxmDpAbZAoPF4J7JN8W5oe0btfSDulXDCUAAGUWq4XRN14srHndyD+RrK+QpI+kkw1vK21uygaRMneTJ51qO+Lz9KxOkgKheHO+WZCKvYjdBonoyFGkSTuMqrKM4IVHky3n1cnM6ccwiQi488vN/BqwFvtY5/pseT/ITwLRgyPWcHtzdbmB61ooMihM0QtKXiN1W0hmeMTSP7VU6b0GC+Wv2tZRxrRh2yzqgL4HZMSOm42b5mAUisAzi6sJAuW8pNYuJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/12/26 7:27 PM, Kefeng Wang wrote:
> 
> 
> On 11/11/2026 2:46 PM, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> cma_alloc_frozen_compound() uses GFP_KERNEL, allowing direct reclaim
>> during the first MPOL_PREFERRED_MANY allocation attempt even though
>> the caller clears __GFP_DIRECT_RECLAIM.
> 
> MPOL_PREFERRED_MANY is only used for the partner allocator. Without your

It's doesn't seem so.

Gigantic surplus allocations already use MPOL_PREFERRED_MANY, following
eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages"),
which predates 9bda131c6093.

alloc_buddy_hugetlb_folio
--> MPOL_PREFERRED_MANY
     --> gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
         folio = alloc_surplus_hugetlb_folio(h, gfp, mpoli->nid, nodemask);
         --> alloc_fresh_hugetlb_folio
             --> only_alloc_fresh_hugetlb_folio
                 --> alloc_gigantic_frozen_folio
                     --> hugetlb_cma_alloc_frozen_folio
                         --> cma_alloc_frozen_compound

Before 9bda131c6093, cma_alloc_folio() forwarded the caller's GFP mask.
The conversion to cma_alloc_frozen_compound() replaced it with
GFP_KERNEL, re-enabling direct reclaim during the preferred-node
attempt.

Right?

Thanks,
Qi

> patches "mm: hugetlb: add CMA support for PMD-sized pages,"
> cma_alloc_frozen_compound() is only used for huge page allocations. In
> this case, I think we don't need the gfp flag, which is why I hardcoded
> it, so there's no need for the Fixes tag; this patch should be part of
> your new feature. Maybe I missed something?
> 
>>
>> Pass the caller's GFP mask through the helper so CMA respects its
>> reclaim constraints when trying the preferred nodes.
>>
>> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Acked-by: Muchun Song <muchun.song@linux.dev>
>> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>> Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
>> ---
>>   include/linux/cma.h |  2 +-
>>   mm/cma.c            | 10 ++++++++--
>>   mm/hugetlb_cma.c    |  4 ++--
>>   3 files changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/cma.h b/include/linux/cma.h
>> index 8555d38a97b1a..4539ea5f2c4e8 100644
>> --- a/include/linux/cma.h
>> +++ b/include/linux/cma.h
>> @@ -53,7 +53,7 @@ extern bool cma_release(struct cma *cma, const 
>> struct page *pages, unsigned long
>>   struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
>>           unsigned int align, bool no_warn);
>> -struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int 
>> order);
>> +struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int 
>> order, gfp_t gfp);
>>   bool cma_release_frozen(struct cma *cma, const struct page *pages,
>>           unsigned long count);
>> diff --git a/mm/cma.c b/mm/cma.c
>> index 9ec1d1fd5dff5..a7c47c0e7d070 100644
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -933,9 +933,15 @@ struct page *cma_alloc_frozen(struct cma *cma, 
>> unsigned long count,
>>       return __cma_alloc_frozen(cma, count, align, gfp);
>>   }
>> -struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int 
>> order)
>> +struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int 
>> order, gfp_t gfp)
>>   {
>> -    gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
>> +    /*
>> +     * The only caller of cma_alloc_frozen_compound() is hugetlb, and
>> +     * hugetlb constructs its gfp mask via htlb_alloc_mask(), which 
>> already
>> +     * sets __GFP_COMP. Check here for usecases bypassing 
>> htlb_alloc_mask().
>> +     */
>> +    if (WARN_ON_ONCE(!(gfp & __GFP_COMP)))
>> +        return NULL;
>>       return __cma_alloc_frozen(cma, 1 << order, order, gfp);
>>   }
>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
>> index cd6a64986278a..3e5a30571524a 100644
>> --- a/mm/hugetlb_cma.c
>> +++ b/mm/hugetlb_cma.c
>> @@ -69,14 +69,14 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int 
>> order, gfp_t gfp_mask,
>>       }
>>       if (hugetlb_cma[nid] && node_isset(nid, *nmask))
>> -        page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
>> +        page = cma_alloc_frozen_compound(hugetlb_cma[nid], order, 
>> gfp_mask);
>>       if (!page && !(gfp_mask & __GFP_THISNODE)) {
>>           for_each_node_mask(node, *nmask) {
>>               if (node == nid || !hugetlb_cma[node])
>>                   continue;
>> -            page = cma_alloc_frozen_compound(hugetlb_cma[node], order);
>> +            page = cma_alloc_frozen_compound(hugetlb_cma[node], 
>> order, gfp_mask);
>>               if (page)
>>                   break;
>>           }
> 


