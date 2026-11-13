Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44926606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=yrjLoZTa
Received: by kanga.kvack.org (Postfix)
	id 2B5046B067C; Thu, 12 Nov 2026 22:56:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265466B067D; Thu, 12 Nov 2026 22:56:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17BEC6B067F; Thu, 12 Nov 2026 22:56:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F26346B067C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:56:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6AEC5405A0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:56:42 +0000 (UTC)
X-FDA: 85428734244.19.712D35D
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf13.hostedemail.com (Postfix) with ESMTP id B18C820003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:56:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=yrjLoZTa;
	spf=pass (imf13.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794542200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c3IsyqkDIWcFoAWUz+a4O451BRWK6BgsPtMgW9Nvv/E=;
	b=lYnyPm+XqDqMhAUsWoq0kpBvCgVC75JUZYaOkrXbRKqidCZhrpF78uY+31mJyjKaoT44xO
	vBnaLMTBsg1hhv7G7YJI4+bpPMEp+Tn8aR5Y7VCLGGuGwDivfFpkMv4NojzBZVWy0fEL5g
	vYCMLeyiUE0i3HoV2q+ACdBuTAPKeUg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794542200;
	b=tz5G1sY9cCAROiuJMqjxpgLZlEuYAh4hiBgsJhHubd5AEGOcOamvOEkWVZj3e8KRPN8p1A
	PKwkXQQwDYEG1q9cssnqZYpu3JC9f5kwYD+9NGpaN+wNpse3u2t5eDeiMu3K5JzsLjdB+6
	NVOwtceNiTpA2a40lFAFMznfTVejucg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=yrjLoZTa;
	spf=pass (imf13.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=c3IsyqkDIWcFoAWUz+a4O451BRWK6BgsPtMgW9Nvv/E=;
	b=yrjLoZTab8mWtUhjvpXJDdI+67sJG0vF3QRBhGDCSAvQnHTaOUj159iBcHJs9yXApHa//OCW3
	BFD4bl5CWqX8S9DyjgNrCIqW+FA2Uybergz+T4pSQZO+W+MlTr27JWcOZU6chYRYuIBJZZsUTxZ
	wQgHHRHZgOtw1tG8GWPL0lw=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jQk230vZYzpStp;
	Fri, 13 Nov 2026 11:55:55 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id B63EB40579;
	Fri, 13 Nov 2026 11:56:35 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 13 Nov 2026 11:56:34 +0800
Message-ID: <9b46d8e0-104e-4659-8dec-67eb6f059dac@huawei.com>
Date: Fri, 13 Nov 2026 11:56:33 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] mm: hugetlb: fix GFP mask propagation to CMA
To: Qi Zheng <qi.zheng@linux.dev>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>, <akpm@linux-foundation.org>,
	<azpijr@gmail.com>, <lance.yang@linux.dev>, Qi Zheng
	<zhengqi.arch@bytedance.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<stable@vger.kernel.org>, "Oscar Salvador (SUSE)" <osalvador@kernel.org>
References: <cover.1794379433.git.zhengqi.arch@bytedance.com>
 <1c5e8c4ae230dc238a16f2f42d65bffac6244ad3.1794379434.git.zhengqi.arch@bytedance.com>
 <7def88b4-cba5-4e8b-9e68-6069c492b582@huawei.com>
 <1cd3c151-24c2-4fec-8356-99853f8d6971@linux.dev>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <1cd3c151-24c2-4fec-8356-99853f8d6971@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Stat-Signature: k5nonyfpcj4fmactszbzrsmb8fua56ub
X-Rspamd-Queue-Id: B18C820003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794542199-509549
X-HE-Meta: U2FsdGVkX1/AagUJ61pKvjqKmzHgHuuIX628yX20q5idsSbUmGIqp3ExX7ac8cRtOnlPFbNHjBl+hBbyUykFuTG4FO6n88tnRUElgHzIYOlf4LtcO9V9VVVbtZwgEjFDLeNVoLH3D7DxA3Wb91ccObIBZUJHVE+/1+YrhT8Ledc8Dgt2wlXq819iXYcPbZuowT3g9nWqeuUebtbP0gC117tDNsTLjKNLYCdAq8qoJLdqv4TmF3j3Ja/pgQ78KrX94GCW/VeuTxn8kQcqH/o3qggMbbQrjN27aZQo/39Ff9CACXgVpGbb1vLTo9RtPJEPpPl1cLIDnu52CK8L7PD1iQxYBQbFu/ulI4S8nMmXp7X+LtD8xhV1mmHS1c/TsbNMiv0rPrSIM9Drp4kZQsHbTv4AsidAFS488Bu6Lx/z8ODW4jCmWvTSO18UtXV6eC2Y8uFi3s3ba9CwYypRh19bJNIAFgTaBpplvgirwH66yeAeTSIhlB1I4y+/FOBcdrvSRvi9puVvbXC9C1/e6378Ybra++P8cotiPiiDik9ulGCuaOCXEwXtfKLOrfQH3I2CFwlX1wBfw6AUyn5r9aktnIfxrTAouBumqJsSgxsoJlkYjt1oSzG2zmNKyIx9pJvGqIs2x56JEJ+GCbF6QtkjbC5+CSvxvfc8YCub/NCJxWBml+TnbPnFfNC2EnQDfxftMVnbRsfqbh5jKfdsQ2hsiGl2tYAIeraR8of67EDJV7AXxzSjypk02rEQLInojIijJoE1m/ZkyW996v5sCqF0FgoY33ZXB748BLZqoUMWH2QCfofMze0abAGkyCotOa/Fgv1v5hwR+xH19Fqpk2l4gEhq/vHuyk+tebfE/uZcVcjCXcXEZJ2R4+GNDLH4qf0WDIPIQYYN1Y0IY8MNQA13OG0LwZq/dIk/coZUJNaJSLkmotyVe2zkuBDrwMXIR1g/XkhkE66TbP4xSuNlx6c
 PI8bNRFu
 wzIhKj5nHY4vAVWIhc/T1ERTrDRCcH6PXlMMaAvo+QxP9o7pvLITruFWyaBAkjUNLOAESZ02KRY815HsdJKW6zaYzO9BHt3vJb3meYMV+kqt8qYdlNU7wSWwUySdWMjfr/d4sBxgJk0GUNneso0d5r9kNLGsj+sdj5MA5SeM/wRUORZgAteu5D0mnvKY7n2b+0AYESA+uz50LeeTyBFRPtyXgSTHk6qFs6cLabEszFR17ZkwjD6NnZEwxSS++ZXigCJklpxgsauEVtQ4l/d/6Fhh8GUQQ36giiB35WhRqtYm/Tt91VU8Qrir+OX5UjejcjAqzpXvS6cY3idjwUbbpcB5pCpck5mZt9DZtS/qZesUNEg5U/g01qGMJPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/13/2026 10:30 AM, Qi Zheng wrote:
> 
> 
> On 11/12/26 7:27 PM, Kefeng Wang wrote:
>>
>>
>> On 11/11/2026 2:46 PM, Qi Zheng wrote:
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>
>>> cma_alloc_frozen_compound() uses GFP_KERNEL, allowing direct reclaim
>>> during the first MPOL_PREFERRED_MANY allocation attempt even though
>>> the caller clears __GFP_DIRECT_RECLAIM.
>>
>> MPOL_PREFERRED_MANY is only used for the partner allocator. Without your
> 
> It's doesn't seem so.
> 
> Gigantic surplus allocations already use MPOL_PREFERRED_MANY, following
> eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages"),
> which predates 9bda131c6093.
> 
> alloc_buddy_hugetlb_folio
> --> MPOL_PREFERRED_MANY
>      --> gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
>          folio = alloc_surplus_hugetlb_folio(h, gfp, mpoli->nid, nodemask);
>          --> alloc_fresh_hugetlb_folio
>              --> only_alloc_fresh_hugetlb_folio
>                  --> alloc_gigantic_frozen_folio
>                      --> hugetlb_cma_alloc_frozen_folio
>                          --> cma_alloc_frozen_compound
> 
> Before 9bda131c6093, cma_alloc_folio() forwarded the caller's GFP mask.
> The conversion to cma_alloc_frozen_compound() replaced it with
> GFP_KERNEL, re-enabling direct reclaim during the preferred-node
> attempt.

Oh, I forgot about that commit. The naming and some of the comments are 
misleading because alloc_buddy_hugetlb_folio/alloc_surplus_hugetlb_folio
can allocate both buddy and gigantic folios (which can be allocated from
CMA).

Maybe rename alloc_buddy_hugetlb_folio to hugetlb_alloc_surplus_folio,
or other names...

