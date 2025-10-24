Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A11CCD193
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 01:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CA268E0029; Thu, 23 Oct 2025 21:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0F88E0002; Thu, 23 Oct 2025 21:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE868E0029; Thu, 23 Oct 2025 21:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 012BA8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:32:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9596D1A0C5D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:32:07 +0000 (UTC)
X-FDA: 84031281894.13.9E58142
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf07.hostedemail.com (Postfix) with ESMTP id 923DD40008
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:32:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761269525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4QbywnMBqJyZ8JOSXXetdEI79E0Z13W7yUSZhBZIuY=;
	b=wxRtkPmr6NxAwp1OKePok3cHHQC3jxvxAUaZ8s+iZ4AOuiMTSK/4r5x0+oUwq5VLfWrQ/w
	Xl4zUy+B0ZqhxYz/EV4N0Tzte8pkSpRgByAKZFIqYavl4YkliUQ8EthgHpHW1ON9H25U8P
	/TtiE4NeyS2W1gFYlVCPA+987n+lJho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761269525; a=rsa-sha256;
	cv=none;
	b=mTyjXdpAfi1zkg2XIYpnahk2Kur0zXB3t0LjpNqhM2umJlPF5nVnxrpKYnUG70ztN0nY8g
	ABbqySXTSKXO6lm040xgCPq9vURzdldHM/2GoRRi8Pm42j7ryOxPxq8vH3dJEtVMlO9+F7
	aMXH1X4fpVlCK74Ft6dzQB8xypUUS6k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ct5333dSYzvX5H;
	Fri, 24 Oct 2025 09:31:27 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 95B8218048E;
	Fri, 24 Oct 2025 09:32:00 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 24 Oct 2025 09:31:59 +0800
Message-ID: <da44c205-917b-4bc0-a54f-a32a6d94285a@huawei.com>
Date: Fri, 24 Oct 2025 09:31:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] mm: cma: add cma_alloc_frozen{_compound}()
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
	Muchun Song <muchun.song@linux.dev>, <linux-mm@kvack.org>,
	<sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
References: <20251023115940.3573158-1-wangkefeng.wang@huawei.com>
 <20251023115940.3573158-6-wangkefeng.wang@huawei.com>
 <20251023181211.5884d84bd48d3d5ef9448741@linux-foundation.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20251023181211.5884d84bd48d3d5ef9448741@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: 923DD40008
X-Rspamd-Server: rspam02
X-Stat-Signature: enqo7n1aywqhicmziaax3y51ye5fsr5o
X-HE-Tag: 1761269524-990009
X-HE-Meta: U2FsdGVkX19Er6gkhr/81vxjPV2I9Qf3OyPUztzxtbFQA6fTmjlwDz+d7fEx3yiZ490HQ/xbLmgOds6Dw0J4mUQuyEnU13/i4bl7qJMx1sjR/W87yCWLVlH3uqguYDoXP7V93czT5LP62tgBubi5uirttapJuymQVld3bxjlWAUQwwdmmKe7mwC23D586tzp7HegG8ir3Cq6XHjUZAOyCk73Amka+BfPs8sQq6a2OizOdv3sFt0SMe6DcwTViguXTtzJQhMur3nkAOU9VY1VVAw4qskIBWc1CvH1f8SnwYHlrg9c2rWkTxu28reBzn8TMSbXBOTWdsVnbzy1/YM+G4lqLlk+iHtgKVhgCkks08lKxah2CChp3Bj/4jhazX9DE5jswwvXerF/GfsLXQwIYItKlEsX9ePD7xyedJdZxS4aKNg9HoGzY9b8TvdjXHmYE3xNf0OtDE3ADmHtZKutFvJkXjkgL9bFJ9khhXoLOatMdtt5NAsmtat1i6lmyvQ7SaGBMHJogO3S39PtkVZHbwIzWjwGE0xTJqgxrCn1UlM3x65yqdzIB2phTcrdDZgDDj9v7xlo8dPGxCAyWUj1jVPQIWX7UcYI+ScvSZb0geM7EYQa5JJB6G1EGPCm7Ig7Ib1SKWXKbb5qQSYWWOiSu+ExkS47cHWpWYd99uJEHmGBtsux/CFWkG6SafIq/u42LE1u8J/at36i77WFf1/aUTWrfOCbzUGkmu7mx5Nc1kInF1aJU44gG+xCYKf24rJGQD0CTaoaOUDwfaISZE9p5vlRQTZv7jEOOfEugJR3KniJGvfBQhQ36cQD/TkLmi/JR01DAUqKcF94wIt7qTYoilVvQmnq5WAQ08ERtoSUo3FGOawZOwtG4ASqM2vnQDHMINytfj5s7tl4xAvKbWmKGZIXMcg/1iG5CaRlcyldiJV3p/nwb9gZbU49kO9jdvWlCnifuAi3+kCd3rNkiEd
 artBKobd
 BGSdD0kAKssTSIBq44WNxdF1hcapYU0b6bHIES+ibV52mABhxxvxfflJ18mfJcZ49zOD1JiIODBx6CPM5fWLYLqpQfptZyRT/97c6Nc1AG6crGFEMa4v30PNGaqoIN4uWLlxgDC2UJoDMcfSqTIwnRB6rzbUz3M1FkAZwCVITeh6lfSHFxqghu7LN3hirbsEhnPM5wVwd3LCIHIYRwFxt32EZtflqFwcFiR3SVcJXUb+lyvkA2uErPmguiCSu3uuCw5Fqjw9wl9w6qEvDo6WqUEqdCySSfjCXfLbN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/24 9:12, Andrew Morton wrote:
> On Thu, 23 Oct 2025 19:59:39 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> 
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -515,13 +515,6 @@ static inline void set_page_refcounted(struct page *page)
>>   
>>   static inline void set_pages_refcounted(struct page *page, unsigned long nr_pages)
>>   {
>> -	unsigned long pfn = page_to_pfn(page);
>> -
>> -	if (PageHead(page)) {
>> -		set_page_refcounted(page);
>> -		return;
>> -	}
>> -
>>   	for (; nr_pages--; pfn++)
>>   		set_page_refcounted(pfn_to_page(pfn));
>>   }
> 
> pfn is undefined here.
> 
> I could fix, but what you sent clearly wasn't what you tested, so I'll
> drop this version of this series.
> 
> 

I do make some test with or without "hugetlb_cma= cmdline", which will
allocate gigantic from hugetlb_cma_reserve or by alloc_contig_range but
make a mistake when rebase this, sorry about that.


