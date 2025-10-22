Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E38C1CCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 06:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8108E0012; Wed, 22 Oct 2025 02:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09FF68E0002; Wed, 22 Oct 2025 02:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1EE78E0012; Wed, 22 Oct 2025 02:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E41A48E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:19:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FBD24898E
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:19:29 +0000 (UTC)
X-FDA: 84024748458.03.B55A5F8
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf12.hostedemail.com (Postfix) with ESMTP id E10E140008
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:19:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=yzcAOevm;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761113967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=meUdmos9kizDlu8CgoRudmdRK0uwEePyLqtSln8LbHo=;
	b=egkVht9w2Vl8sB9bTOo5arltPlUXCGK2+p6kHNxLKD/BcbG+muK4pojCs+NWUo7BUvmXf0
	xYoX78EGNwGpvYDsy7GtRQkBp2EumRDoKbBRRuVvDqkhAvWEiPH9XCWjLWyjWN0x3RAjyd
	jabJ1CB8imwmZq8TW+g598k9Nrut8qc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761113967; a=rsa-sha256;
	cv=none;
	b=E8Vvt4VsAIeYB3Mlo1VMW9lIunODmZFj1c6Ph4hlW3IGLvR/nQ19JU6RvP6jeRmdZZj6Ab
	celtZPMQBW2QVcQ35szJ7QJv96GAQYoJGiyIOc8xa2gQ0yQHp1liI5qJho0F7kJSBSm+Kb
	h8mRTHKhvdgRU9KJKyXp4UXOuxNjSoE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=yzcAOevm;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=meUdmos9kizDlu8CgoRudmdRK0uwEePyLqtSln8LbHo=;
	b=yzcAOevmafGW2CJiWtKvyITW2LJ0FSsPf5vlpv24nmQwx1dMBCEyfQKIG4DXZSJ14pXFJTIRQ
	Y9oDTQmdM/Pp0jz9qP+qUTHbztfrRFwn8bm2E3likMLSDkJgAYoZBFx1+qpWtRCiZfSJQTpuO8O
	YgSJIrymsljiTMHrBKJ6k7M=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4crzWN1nxqznTWP;
	Wed, 22 Oct 2025 14:18:40 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 79C4C1A0188;
	Wed, 22 Oct 2025 14:19:21 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 14:19:20 +0800
Message-ID: <b9520113-9236-4157-a4ab-fd6908f1b577@huawei.com>
Date: Wed, 22 Oct 2025 14:19:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: mte: Do not warn if the page is already tagged in
 copy_highpage()
To: Yang Shi <shy828301@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
	<syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com>, Will Deacon
	<will@kernel.org>, David Hildenbrand <david@redhat.com>
References: <20251021181353.3842660-1-catalin.marinas@arm.com>
 <CAHbLzkpd8awNe=bZVv9fTux+Fx-HT8qL4ENZ-uC4YcPjf9e=KQ@mail.gmail.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <CAHbLzkpd8awNe=bZVv9fTux+Fx-HT8qL4ENZ-uC4YcPjf9e=KQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam01
X-Stat-Signature: x9pn3bbm83u3iasj4ya4oo4bshmxusbk
X-Rspam-User: 
X-Rspamd-Queue-Id: E10E140008
X-HE-Tag: 1761113965-943278
X-HE-Meta: U2FsdGVkX1+dxRPHK76NyYRb0kqVrAUVeFi2NGVRM3SxYclrowUdKwRz4V0f/hxk//IIY+lUc7mfHdofoOvhEmc/Lis71tWM7wX5Vijtn6iSOMMHb57uGi4ZPg8vyjPGV5m+Yd01TfHVawjBHdaO6fR2ovKPNArK2tWxhVZJqSW4HueF7zXXJ8CeYZw+3zwoDpAW77ulnnOtrbHv3hkO9afoEacY6/1Df/Zv2A0pL6F0KTWdsGmcB3e0QPuZXsWsN30qKmarp9yVLZO8XNdoJA1kWlowTGYuggwIiTyPkndnGcIWZZWyYyruO1t3JoafJjvOVgsTJqdNL8RmxSSA5K4ZmW6EDgZlrf6utYVnqtjnlb3XLgQ9pmXv8iRU7oquAtXCWziG0bBP4Dz+liZ5X9YFtxK/xT5z7bYrdq+aBi9xzk9uBN1YAn75Hxp2eZ5P+IvgfVJRq6Si4Dpv6ygqILklWne4duM7KrcwHfp3gf88jeRnw6cPuAvkHZhEPwBwmmZZO1te0dRuGJ/zjdm1vVWoKPPJ2RWd+SAJ9JsX4ZY4P8UXAuRBPKZfp8+QYhtn1HyGZqDP2DIQrXqnBZV1OtIBtM5nIvammdjhui/iFmNoTSJW0QEXqcXjmiib6kSP3vEwYe0HGfdqS+DSFqfG6xK+Wadq9+vSZ2ngVI6GqkGE++gjxglApXnZoOcjOEg/dDtJGLj53rF827Sk+SqFNjFMAV7zqQxJMNC2L/XKQidpXU3SWxYkFEkzQvb87MefCixMZVbJMrhCcnvbBjUklWhaYuQTu+VlTLlwkdaJQJRqx+1K+eYQPlhhC7ymjt7mThb7Qr/kfCKY16qfZW6VrBKxUG4u6s4E9v7YBIECW3OqV1J0iINVMND2I3Su+aNxPbDIFmvQeddLKmis9Fzrf78EF5Suiz0B7LdkAQvYSQ6tqV/D4XpRCv3VjxX2KNPSeTsAWcOHRAUII1chuXS
 bVtQ4zC9
 whZa9WFqJWQhF1ZfUq63AgsjD2hYF8BmMN3DxAgxJqJRMKOvmilXkPy5xjW95QdzQ7HEjoy7XkqRWrYqHMoe67sdWNxb4sT+ugqT7REWFlOvQpz3D1PIYNiHkZEybtUplZ6Syz7GPY2lWF8IRASp50frhHSCzBe63Lqrh0qSQEP2VBfG3Ks9Nhd635lEE+2566aNFw1NlsWTNo0fsjxrNEKG6NISgKSp3i6KWWjadmflh5IsAAJ9+LIK8mWudMEwICpKcIN6GTmpe/wBD3RK9XO4KyXEc50PGy8FHErAHIBtBudsu0aJ3nN835trIWNlq42ZIkKsPUYyjq944CQOQylrUBvTeP5RUbnLP1A+rdg3irz5IPxTOGTg61N2fgiMwSMcSE/vgNzFCMgmbkdGnK7kbk+tYWm0B03ExWBMDfRHvZMXt95eE4XihEjvFmfEJ+38LGVs3PB/O4nMKQvC2vxxIfUZi7fNEFaoP3tLYIv2e0rHGCC5F/UJ4U+EDLtwXdnisF2cxB65fnrljBVp1n5x9Pbjmyvh1Sme0OlD8oa96lLS2yJxAiSbyvzd78n7LxbKJ8COhPBDXvF28NNHZ8KevHjLtL3j3NRpwx23W1VJXMrnf3j7TTkkwebrxIPTIMQbrS6z+38hgaAHu3HwTkXuHeJ6Qpat2mpJEzvYBqEmEDanHIseqCZ68Mh70jvPx/T/TuEfhESKucJaur5nzKUPjRWMHfj80x3GU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/22 3:00, Yang Shi wrote:
> On Tue, Oct 21, 2025 at 11:14 AM Catalin Marinas
> <catalin.marinas@arm.com> wrote:
>>
>> The arm64 copy_highpage() assumes that the destination page is newly
>> allocated and not MTE-tagged (PG_mte_tagged unset) and warns
>> accordingly. However, following commit 060913999d7a ("mm: migrate:
>> support poisoned recover from migrate folio"), __folio_mc_copy() is

no "__" prefix

>> called before __folio_migrate_mapping(). If the latter fails (-EAGAIN),
>> the copy will be done again to the same destination page. Since
>> copy_highpage() already set the PG_mte_tagged flag, this second copy
>> will warn.
>>
>> Replace the WARN_ON(page already tagged) in the arm64 copy_highpage()
>> with a comment.
>>
>> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>> Reported-by: syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com
>> Link: https://lore.kernel.org/r/68dda1ae.a00a0220.102ee.0065.GAE@google.com
>> Cc: <stable@vger.kernel.org> # 6.12.x
>> Cc: Will Deacon <will@kernel.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   arch/arm64/mm/copypage.c | 9 +++++++--
>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
>> index a86c897017df..40749d0a385c 100644
>> --- a/arch/arm64/mm/copypage.c
>> +++ b/arch/arm64/mm/copypage.c
>> @@ -51,8 +51,13 @@ void copy_highpage(struct page *to, struct page *from)
>>                  }
>>                  folio_set_hugetlb_mte_tagged(dst);
>>          } else if (page_mte_tagged(from)) {
>> -               /* It's a new page, shouldn't have been tagged yet */
>> -               WARN_ON_ONCE(!try_page_mte_tagging(to));
> 
> I think you should remove the WARN_ON_ONCE in the above hugetlb chunk
> too IIUC. migrate_huge_page_move_mapping() does the similar thing.
> 

Yes, it's better to remove WARN_ON_ONCE for hugetlb too.

> Thanks,
> Yang
> 
>> +               /*
>> +                * Most of the time it's a new page that shouldn't have been
>> +                * tagged yet. However, folio migration can end up reusing the
>> +                * same page without untagging it. Ignore the warning if the
>> +                * page is already tagged.
>> +                */
>> +               try_page_mte_tagging(to);
>>
>>                  mte_copy_page_tags(kto, kfrom);
>>                  set_page_mte_tagged(to);
>>


