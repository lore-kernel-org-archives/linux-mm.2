Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02588CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 10:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6656B0088; Tue, 26 May 2026 06:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67DA86B008A; Tue, 26 May 2026 06:53:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 593EB6B008C; Tue, 26 May 2026 06:53:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DFD16B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:53:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA2051A03C7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:53:15 +0000 (UTC)
X-FDA: 84809259150.27.CB84A60
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf18.hostedemail.com (Postfix) with ESMTP id 826D71C0007
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:53:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=HGMzteVU;
	spf=pass (imf18.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779792794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ov+rk9L2rw1E2R4gtvgCjNGl58mgqEUWPTlCjYTIzck=;
	b=w9s0ROKKXWTRqXD+zFQTleTiYdLX8goaQOZCCjj2D5ljVqzXEs3B7bAZmIYex20zp2dvGO
	DOHwwDFL8P7+P22VmuvvNvq+kjWYWBSoj/DRnQN8afqYJ8y6fzcMAcMrOaJooJhcIlYzPM
	sFWQ7foQgkjTolhMLaTbOyzgB03IulA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=HGMzteVU;
	spf=pass (imf18.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779792794; a=rsa-sha256;
	cv=none;
	b=prnroEuQ1HYY/EPdmn4m1epRnby3wOJac9lG3jwKsHtUJ4UoiTRxJ0uQ4ukC2t2A1X+JHM
	7rcFBRwbWTloPJj4oOYJEGwQDkzWtFxPyZUhVfQ6sWpfaQfiOrgu6JUcVDxzmBsnuEojBd
	zff6eV0Cz4Otq3jS/M4nU2ZBuvjdgDY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Ov+rk9L2rw1E2R4gtvgCjNGl58mgqEUWPTlCjYTIzck=;
	b=HGMzteVURZvXY0Lo5+tM/YJAMN/SM92qEo06iaTeyF0bMi9LIB6LPweODVqAj0R6vbVUKedov
	ZP1/+lZ60NO7M1qO0C7HmvC6n0xo7aRH70TfFDY+HAE8282ym1oIZDBfKDyDf0A35tY01RLq4qv
	MrxoF/lL3mNSrNIZx9H8Pfc=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gPqCM13y2zKm4N;
	Tue, 26 May 2026 18:45:19 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id AA11A4056A;
	Tue, 26 May 2026 18:53:06 +0800 (CST)
Received: from [10.174.179.248] (10.174.179.248) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 26 May 2026 18:53:05 +0800
Message-ID: <65570a39-9738-44db-bd05-837b9e54faf7@huawei.com>
Date: Tue, 26 May 2026 18:53:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: update file PUD counter before
 folio_put()
To: Lorenzo Stoakes <ljs@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
	<dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, Dan Williams <djbw@kernel.org>, Alistair Popple
	<apopple@nvidia.com>, <wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
References: <20260526101355.1984244-1-yintirui@huawei.com>
 <ahV1WCxlXhOKfO_S@lucifer>
From: Yin Tirui <yintirui@huawei.com>
In-Reply-To: <ahV1WCxlXhOKfO_S@lucifer>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.248]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 826D71C0007
X-Stat-Signature: c7gdsxid6g4486c5sik11b3mignntu5c
X-HE-Tag: 1779792792-491837
X-HE-Meta: U2FsdGVkX1/CP4YFa4rLW2ITM/cZ6lzI9t/Qqzx5/8xslVr2mKQbj/ywuI7QQ6YiJjpbTTDw78CdVzKLRErTchjDjn6JN8kuKA4fPKAZuW5Mxfu7Jc9DDSjHvoUx84TyJ4Hd8jpuAPaHGFZUBTvSCE5zF7S3QpXjzBJAFvl8+/gA9gVwZz+Q/YuXsZ1A1YpMT7xSTDQRIw0xcOUoHQNdTwFr2ekF1+tBITcg0CLzozYjszERoJlyw2DZ2f13n++41z6kYnMQ8oLhavPjZ7oJkuhXfr94rLJmnqAcamfvWqQw9jpLu/gfsjlzBRTcANFlOR3PldRtuYB+ZUsT/+etEjsKIXFv2pO0hB9tzlvWKD2aqkmPTkn7q4bS9j3/hVQUgbd+aQ0WXKm6S6A1YG8/huUzJg4xBkgEAfRLfk6NvXDUJ4jYLXWI3oj6eh6Qe7MPMmQIT7LdhYGcyyPPxXDpGKRkFuH2zPi88/1U/nwq3Z+/QXsS28rbAiwzTS31nRTshMIyzriPmUZzGOHjfNIz92rvGiKpp1R1UhwylO1mxU8AU4tSi0uMlapZh7PlgKryHPk2ArcmsuAXwoTtLOyWnozpkdx6Zp7lNN/tdLa2HMuz/HnzPwhQNnBAqldafU/UaJ2uXhkijMCJYHjTCvTditg3oBYaM7kNRpfvaRYfi2AeAKpCSuAMhW91+9nLzPKPOavl6jRFRnKQW7/HRy5/96VD70pbLUewQFbqF88+hCchqYdMvlySZRk36egikEZ1KNuaa/9x4mDmBbrZHEtssJvxAvENNkaIMoNM5h9Entx75K9nMX5Bw3DMXc/o7K8kYw6ln5pcuzIl1x4ZP/XsCP8putLK5f8TrYAC/89xHQxlY98d5g18iKGwXyeRFc/FuaT/tO7O65oBBbHZqyXmx1A30lH/3gkH0KL9FVKbAqePkcuJHU1UPNw7pzPD8OZPNtffFu2oekYE4pA2D+p
 cQEE5O71
 8P2orMl12vmcpkp9if8lGJBxPHHvZhbzkOALIQMJNfPpA4ZU6ubhYV2NLg3XWN3V5yVb91/Wv80mhONzyg5Rs82l6bBcFd2DxCW1MgYFeV/mWhyZ0jOg4rI1Jk6NU97opUW4k7QZOUCmbeH+le85/1SEOlJXwT7iu+Y4a3yESc4Jm2OxnMgefoEe1TTI4DYAZWrpNns0/49ocKdB0BW+4yab1nCumOpTVmQjiMTSMDmvj2eO2TOtpccZEe6zIXqs+Ng7MnZTIkNszsCYu4Mw5JGRO96oImcbII5vSzsjHvpcfJYvteF12bk/IQBlNdtnMzEoPYQMP+YQTU5/QwS+jqM+oJokBKZtEHttN3ED6I6Nt9RsLXo/I/Y9Ho1WzOooc8gw3XPhABPktoczeDpNayRF3CsXaFshF1X5Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 5/26/2026 6:47 PM, Lorenzo Stoakes wrote:
> You sent this twice :)
>
> On Tue, May 26, 2026 at 06:13:55PM +0800, Yin Tirui wrote:
>> __split_huge_pud_locked() updates the file/shmem RSS counter after
>> dropping the PUD mapping's folio reference. If folio_put() drops the
>> last reference, mm_counter_file() can later read freed folio state via
>> folio_test_swapbacked().
>>
>> Move the counter update before folio_put().
>>
>> Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Yin Tirui <yintirui@huawei.com>
> Patch looks sane to me, so:
>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
>
> There seems to be an identical problem in __split_huge_pmd_locked() - could you
> do the same fix there?

I have already sent it as another separate patch.

https://lore.kernel.org/linux-mm/20260526101337.1984081-1-yintirui@huawei.com/T/#u

>
> Thanks, Lorenzo
>
>> ---
>>   mm/huge_memory.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index a5f4a48b7b77..9832ee910d5e 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3027,9 +3027,9 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
>>   	if (!folio_test_referenced(folio) && pud_young(old_pud))
>>   		folio_set_referenced(folio);
>>   	folio_remove_rmap_pud(folio, page, vma);
>> -	folio_put(folio);
>>   	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
>>   		-HPAGE_PUD_NR);
>> +	folio_put(folio);
>>   }
>>
>>   void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
>> --
>> 2.43.0
>>
-- 
Yin Tirui


