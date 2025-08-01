Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2397C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 08:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456566B00A3; Fri,  1 Aug 2025 04:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42E726B00A5; Fri,  1 Aug 2025 04:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B946B00A6; Fri,  1 Aug 2025 04:13:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 281706B00A3
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:13:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7A82C11E2
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 08:13:41 +0000 (UTC)
X-FDA: 83727474642.02.CE80A4F
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2BEC41A0007
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 08:13:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754036020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qg9/Gf88emidW1+zeoa5e+0A7SmTGcioQ5gaeSgRPCc=;
	b=gWiEey/fC2kEhrVXveyYJ7AEUrbhKYb4rOz9yCmdknZ73zXu2Ze6RCa6Bl0XmB+kvBgu4k
	3AhceIH6W0qzDq6ZWJfQ3qM+1S+NaeyCu58LuR39ucuwbwWJsHu4j90W4Sfr8yjKQgWTYJ
	3je/GTwonIuADpMPrCKZ2/2ETOASWLY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754036020; a=rsa-sha256;
	cv=none;
	b=AU30rtTOhO7tjvXC9VCyvaQq262lgEi/dmMFwzdky/cV/qXseu/ikhz3HIhJEHCOiS/dc+
	TNghubWr+gYuA8DpiD81HSty1F0b1gz2fJ/lfyd4SDpssu0O7QnNxfCiMCIKsUmt13niIo
	QQok0l6AkhesmfzJ4e7Z0UK5iazKVF4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4btdtf682Fz1R8pR;
	Fri,  1 Aug 2025 16:10:50 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 618931A0188;
	Fri,  1 Aug 2025 16:13:35 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 1 Aug 2025 16:13:34 +0800
Message-ID: <6feb2506-aaa6-479f-a7e3-b4503b7d6ffc@huawei.com>
Date: Fri, 1 Aug 2025 16:13:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: Support only one page_type per page
To: Matthew Wilcox <willy@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	<linux-mm@kvack.org>, Kent Overstreet <kent.overstreet@linux.dev>
References: <20240821173914.2270383-1-willy@infradead.org>
 <20240821173914.2270383-4-willy@infradead.org>
 <2d19c48a-c550-4345-bf36-d05cd303c5de@huawei.com>
 <aIwp48CTft68fssD@casper.infradead.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aIwp48CTft68fssD@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 2BEC41A0007
X-Stat-Signature: kgpgt197jt8y3hd1aohmq84adfpq79f7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754036018-218120
X-HE-Meta: U2FsdGVkX1/Ky2lDyPK75GJ3LKi79lc58+lXBHvlTSi2/nPlvcFW1L1fRvI4ZG0vFAmdiCaMRdOVg2i1iKkJvWqySznVRYL2pAqnU7PoeLVme6He1cMkh+9ainroejvBOI0yh1cr8eda4XSSs0uPREdtoyw3E4Gxvl8wkFfCCRCaxca98/53QwrhMWAXkcBH1CNtOvlL6OBtw9uzG2/Lz4uac7ysEMhynnX8Td6yPKIAZz0n31visxOcbirXphPidrF3FwR4kK/KGsYRW4ps4Jn5P0dPin5y0FmD/0/CO+RHz+wx3ruIvsrag82fWo+QmhzqYLkBjvJFRHOPJ5OGES8Adb5DCT8ucOXb4nON4nOtXJXGsUjyktV5K1Qfh/AE1z5N5tUHUtyzZDXhqFf1zf8aanFGGD22WfGmPOYBq27Q90cSubssfSRM3mpnst4J/mZhlP0u0K3HKGqgNkmyaMafvvXTep1grygR3035bSLKm61FDAaqQz52PJsUCd3McMGrt414M6oADpHd6GaqGDx+nslSv8x1s9bBE97JAvTmeGuJHEJEdZr0Ltpp6xffThgIMX1HGzkFOUY9/cKbKk39We8BqF4en3ddal9Lif0pI2vqBRQKUC2Q6Z5ZXpCD/pKnjgJ3gL5VjFh7uv5OwfWVpY+hhr3mgwdh4BrPfH8GEvTczkGP71wexv9gvq/1/tnqUKfp5ODJJdSKrLYQ2avqd9Lyxb+YVYFhBUjZKTYWTKoPMRoFklAxPrMewzA3y6uMCr2BDsRfCIJc6gvbxzCcpDmOVy59YDjqbpQJEFfRPnuy1iIFAxwukVY84TBvXR+jIDpYlfm70kg1VvHYiW/xwaRmk1HhKYvUAxcWZjAK3SIcySVjBq9sjRjCFpI0Q0aMu+fq+1+O5B2czBQLRB+WX3dDl99/xqqfVdCTbM6ghrA1UDLQNhCy92I13/zGmzqgImNaeUeVi0DK+NO
 h0znk67Q
 4tgc3IOsVMGwoA4drYvTY7vXHMKWPyuJc3yT8Etee1xQqfPLg2Scn32Lm+kne7XP2wLDdD6YCO8tiBila8hRv5xbNYA76YiQTRnTpnSzxgMfrEtAIVuRVcBHpBZEYjk0xrT6xt8TwYkEYvL6IO1S8eCU8TNPBSWfaaKar8iwKjGwqYqTVi/4YcnyW2oyP0wJzk7ZraSbb1sXP5Qa+yZsnDKREYbbMcY6INsFjxYncF58DkbLELrM7HkxyJdxPoNiTnCgGY/GqFl7v745Bi5fnFZRxoyYtM6DtenbuTySL7o8PejuKqBhNHC0kYNun+2TrVQn4bJ6rCJVeVpw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/1 10:43, Matthew Wilcox wrote:
> On Wed, Aug 28, 2024 at 11:35:28AM +0800, Kefeng Wang wrote:
>> There are some UBSAN warning about  __folio_set_##fname/__SetPage##uname,
>>
>> UBSAN: shift-out-of-bounds in ../include/linux/page-flags.h:998:1
>> left shift of 240 by 24 places cannot be represented in type 'int'
> 
> I can't reproduce this.  I know Andrew merged this patch in, but I
> tried backing it out and enabling UBSAN and it doesn't show up for me.
> Relevant part of .config:
> 
> CONFIG_ARCH_HAS_UBSAN=y
> CONFIG_UBSAN=y
> CONFIG_UBSAN_TRAP=y
> CONFIG_CC_HAS_UBSAN_BOUNDS_STRICT=y
> CONFIG_UBSAN_BOUNDS=y
> CONFIG_UBSAN_BOUNDS_STRICT=y
> CONFIG_UBSAN_SHIFT=y
> # CONFIG_UBSAN_DIV_ZERO is not set
> CONFIG_UBSAN_BOOL=y
> CONFIG_UBSAN_ENUM=y
> # CONFIG_TEST_UBSAN is not set
> 
> (I tried CONFIG_UBSAN_TRAP both on and off)

Hi Matthrew, I work on arm64, so the above OOB should occur on arm64,
I remember the OOB appears on linux-next, but I tried last kernel and
some old kernel version, but can't reproduce this too, it was too long 
ago, maybe gcc version related or some other changes...


> 
>> Changing significant bit to unsigned to fix it.
>>
>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>> index 28d2337525d1..2175ebceb41c 100644
>> --- a/include/linux/page-flags.h
>> +++ b/include/linux/page-flags.h
>> @@ -966,7 +966,7 @@ static __always_inline void __folio_set_##fname(struct
>> folio *folio)        \
>>   {                                                                      \
>>          VM_BUG_ON_FOLIO(data_race(folio->page.page_type) != UINT_MAX,   \
>>                          folio);                                         \
>> -       folio->page.page_type = PGTY_##lname << 24;                     \
>> +       folio->page.page_type = (unsigned int)PGTY_##lname << 24;       \
>>   }                                                                      \
>>   static __always_inline void __folio_clear_##fname(struct folio *folio) \
>>   {                                                                      \
>> @@ -983,7 +983,7 @@ static __always_inline int Page##uname(const struct page
>> *page)             \
>>   static __always_inline void __SetPage##uname(struct page *page)         \
>>   {                                                                      \
>>          VM_BUG_ON_PAGE(data_race(page->page_type) != UINT_MAX, page);   \
>> -       page->page_type = PGTY_##lname << 24;                           \
>> +       page->page_type = (unsigned int)PGTY_##lname << 24;             \
>>   }                                                                      \
>>
>>
>>
> 


