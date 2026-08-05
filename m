Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDE35C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE4506B008A; Wed,  5 Aug 2026 12:21:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABB876B0092; Wed,  5 Aug 2026 12:21:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D1756B0093; Wed,  5 Aug 2026 12:21:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 700596B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:21:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5183C1A0537
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:21:49 +0000 (UTC)
X-FDA: 85067731938.11.5D2F9C3
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf27.hostedemail.com (Postfix) with ESMTP id E78364000A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:21:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=kRQbcFGX;
	spf=pass (imf27.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785946907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYMoNgzZlL39hMDdf5hIWUsu6zdYs8UUMRGfuY5VR7g=;
	b=wJfquAUMC9jwoLhoXH+ZKYIJk3mPaUtIkCSeKAlJMIiOE2k541nhEp3pe0FksHBkIYz0gV
	gKD/dPvR6PZW26JaBQwCWJtD5veLxoJhmfdsKtE3JouHja3CpXmSrdyBkWdo39PM8VBn73
	JanIB4DGojXv6PAr9QJl7+nCOq2tlCw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785946907;
	b=Lg4Xzlynfw6debvlt54E/o7rk7vOEF576eD183WxQjmn4tmxMWN5/zkM1n5BmTvq8eGwTf
	UcbtgLaUgxzOyB5b3iW/lZXPK2oWRt7hHpvjdyd1/ExonsvY//s8kvOd7VlzOUPkBG6Wer
	99x9SVZrdbdJHlRkc9iE1AY7T69B4wk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=kRQbcFGX;
	spf=pass (imf27.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=PYMoNgzZlL39hMDdf5hIWUsu6zdYs8UUMRGfuY5VR7g=;
	b=kRQbcFGXjpjH5pjrNS8BUiPc4XI+UukSaeVQhvVkQk5W7gsK7Gk9QT6tXoOjaU
	7kMl1c2mUTYUXvPruzVBLDQcPvaww9NyRl9Jpy8f3QMVQNTAFwsctbWSxKX4lr8A
	6yFpAiEwpqUVE7TKB4eB+VowDtSbsk6OuiFK6OqE9C7hQ=
Received: from [198.18.0.1] (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgBHFCgEY3NqfpN3Kw--.23303S2;
	Thu, 06 Aug 2026 00:21:25 +0800 (CST)
Message-ID: <a27c1872-c4bd-4f3f-b2b8-d34e2f055411@163.com>
Date: Thu, 6 Aug 2026 00:21:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/ksm: validate KSM rmap items before hwpoison kill
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 "Lorenzo Stoakes (Arm)" <ljs@kernel.org>
Cc: xu.xin16@zte.com.cn, chengming.zhou@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Longlong Xia <xialonglong@kylinos.cn>
References: <20260803151151.3472893-1-xialonglong2025@163.com>
 <72f017f2-89c5-4e4a-9ce3-ab79f70b04a0@kernel.org>
From: Longlong Xia <xialonglong2025@163.com>
In-Reply-To: <72f017f2-89c5-4e4a-9ce3-ab79f70b04a0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgBHFCgEY3NqfpN3Kw--.23303S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Wr13Ary3Gr13tF4rZF45Awb_yoW7XFWrpa
	ykAa4DGrW8tw1a9ryxZw4q9ryYvwn8Ja10yF47Aa4avas0qwsFyF45Jwn8uayrt3W8G3sa
	qr47CFsxCFyrtFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UsvttUUUUU=
X-Originating-IP: [240e:46c:1000:421:34db:efe:597b:d439]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC2wVRSmpzYwWVAAAA3v
X-Rspamd-Queue-Id: E78364000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: i9bo65ibapnitc9y4sq8r7zfjchedi5j
X-HE-Tag: 1785946902-222679
X-HE-Meta: U2FsdGVkX1/f9IQgWa/w08JyKVSApS8zJr4zbkBYxyXAtvUKTliGix51Od/V+SFzwTy1LAoN9rODeg592d3cMfYkW4QqIAWt5XQTGjqGINyGrxQnPYkvMoxni9/Lh6Q/QPFVxDdb2c2HrkKEKUfVpipZdbLdpCBVaBFDPfgKAJ8KsQWzm4xdzr/8Wrut6UryZ5wYP2UhGqh8b3z6BppTILbrKXHPTngJ5qAYIIsOZ6OM33DVkXNH+GT3Pg5DR5huCicI1lJYIfoqKV3YkWgus4OFiITP5/tJh2YwnA4EkGbIs115lxhZWQAD5KEh9moscuMxQRPrNrZ0pxZaeJJ5kYspraZztc5wQaosH6reU7yg/tFhGzDq0YdmblV+N5UF6weLYrPvtg58vD6OCV97O2/SP2fVz9n2YO23x2t/gxPsWz9z+G8n8aNXx++7lm3WqhEzEJe9eJQqwS3bR1weuNd4pQadfm+CHILs/DcLga4Fc5OIrKVnV3k/RGrNF1y998/D6RKzCSj7tjdmfJ4wCuSntvTjCooKZZmR7vhKWZI7aWqyKksMGle+lDlljhJpEiyVX9SYcnuL/l+bzFz+O5XCOGNK/lGdAGZ8500hSd4JSJYj/5mhtHJpFZB2QSQQw/YRD3nwGJa7HOBxix59Y86BIimZWq6IoQEiuikfIFa7yE9LcCba4hpbcM+RradqlvZcQZ1e6c0kbaPICCCKJsV9xccT8oUc8+JNiiFMXjGKcZtQmNyo0AYHtM5skpp+5BvBZEE/IfXjC3vKUCfkCLshF9bSO+WeIvqUK0HHPFmCWAlPKgLLL6Uh9IUFgE4nLd3Lh3k83A5cEjq2xGDsItIgfeCJluy+5iow0nFFs6+0dW9YYqPguOoeb+S0RpU4VIjQdiXmxAf/D9HgfYsClzY5ZWyyy1zG5v1leEV0dD+zdhG+7vtNHMvVQCtzuBNV6F75vINZ3TQ7sGWI2ap
 7v91QjPO
 /SBGaxLdTN4eR9XwjCromhOaDhGUQXxT2J2TCt3KBLjMRuSgzYJ/u0/F08lAPslVcEamCnqZi9wm1V8eeFFPi6S44T7ubw1MbsajzhmyK/4OkKDH2Y2EeY86flzG6QXCDKhS4UtSKYla8F/w8eZMRyCsmoz1AFwnefzgSitMGwrciKg0mXbZ+tuccdac4si7L6xT8lsuZ1bPBsLh75zSip6h+UMNQY2SHGQRNxGcLgKkOnKO8M4cetweyZLs8uqM7uNbeHrkLUay20PtGFmAlgjiGmPeyK5pQ0EXSLFC/W9rRe8bK0DA4elCQdq7oEJHHpbpaAl0L+V+g2YeiSiF7HCOktpBsjIA6ax6lpjYCGhLyQ5oFrT2Hjwt6c+teENUHxtufJp+S0naht7k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

   Hi David,

   Thanks for the review and for suggesting this approach.

   I will send v2 shortly with your Suggested-by tag.

   Thanks,
   Longlong

在 2026/8/5 20:19, David Hildenbrand (Arm) 写道:
> On 8/3/26 17:11, Longlong Xia wrote:
>> From: Longlong Xia <xialonglong@kylinos.cn>
>>
>> collect_procs_ksm() walks the stable-node rmap list and queues an
>> early kill for every task whose mm appears on the anon_vma chain.
>>
>> That rmap item can be stale by the time memory failure handles the
>> poisoned KSM page.  A VMA may have been split, unmapped or remapped
>> after the rmap item was recorded, so matching only vma->vm_mm can send
>> SIGBUS with an address that no longer maps the poisoned page.
>>
>> Check that the saved address still belongs to the VMA and that
>> page_vma_mapped_walk() still finds the poisoned page there before
>> adding the task to the kill list.
>>
>> Fixes: 4248d0083ec5 ("mm: ksm: support hwpoison for ksm page")
>> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
>> ---
>>   mm/ksm.c | 27 +++++++++++++++++++++++++--
>>   1 file changed, 25 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index 7d5b76478f0b..bc4b2dd894d8 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -3222,6 +3222,27 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>>   }
>>   
>>   #ifdef CONFIG_MEMORY_FAILURE
>> +static bool ksm_rmap_item_mapped(const struct page *page,
>> +				 struct vm_area_struct *vma,
>> +				 unsigned long addr)
> Two tab indent on second parameter line
>
> 	struct vm_area_struct *vma, unsigned long addr)
>
>> +{
>> +	struct page_vma_mapped_walk pvmw = {
>> +		.pfn = page_to_pfn(page),
>> +		.nr_pages = 1,
>> +		.vma = vma,
>> +		.address = addr,
>> +		.flags = PVMW_SYNC,
>> +	};
>> +
>> +	if (addr < vma->vm_start || addr >= vma->vm_end)
>> +		return false;
>> +	if (!page_vma_mapped_walk(&pvmw))
>> +		return false;
>> +	page_vma_mapped_walk_done(&pvmw);
>> +
> We have page_mapped_in_vma(). So I wonder whether we can find a way to
>
> 1) Modify to just work with KSM (CCing Lorenzo)
>
> Maybe it already does. I'm confused as so often.
>
> Looking at the existing caller collect_procs_anon(), it's really only called
> on anon folios. Could it already be called on KSM folios? What would happen
> in that case? (does it just work because folio->index is still what we expect)
>
> 2) Do the following
>
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index d7670ba4147bf..7eeb3c336cfe9 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -342,6 +342,27 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>   }
>   
>   #ifdef CONFIG_MEMORY_FAILURE
> +static unsigned long page_mapped_in_vma_at_address(const struct page *page,
> +               struct vm_area_struct *vma, unsigned long addr)
> +{
> +       const struct folio *folio = page_folio(page);
> +       struct page_vma_mapped_walk pvmw = {
> +               .pfn = page_to_pfn(page),
> +               .nr_pages = 1,
> +               .vma = vma,
> +               .address = addr,
> +               .flags = PVMW_SYNC,
> +       };
> +
> +       if (addr < vma->vm_start || addr >= vma->vm_end)
> +               return -EFAULT;
> +       if (!page_vma_mapped_walk(&pvmw))
> +               return -EFAULT;
> +       page_vma_mapped_walk_done(&pvmw);
> +out:
> +       return pvmw.address;
> +}
> +
>   /**
>    * page_mapped_in_vma - check whether a page is really mapped in a VMA
>    * @page: the page to test
> @@ -355,21 +376,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>   unsigned long page_mapped_in_vma(const struct page *page,
>                  struct vm_area_struct *vma)
>   {
> -       const struct folio *folio = page_folio(page);
> -       struct page_vma_mapped_walk pvmw = {
> -               .pfn = page_to_pfn(page),
> -               .nr_pages = 1,
> -               .vma = vma,
> -               .flags = PVMW_SYNC,
> -       };
> +       const unsigned long addr = vma_address(vma, page_pgoff(folio, page), 1);
>   
> -       pvmw.address = vma_address(vma, page_pgoff(folio, page), 1);
> -       if (pvmw.address == -EFAULT)
> -               goto out;
> -       if (!page_vma_mapped_walk(&pvmw))
> +       if (addr == -EFAULT)
>                  return -EFAULT;
> -       page_vma_mapped_walk_done(&pvmw);
> -out:
> -       return pvmw.address;
> +       return page_mapped_in_vma_at_address(page, vma, addr);
>   }
>   #endif
>
>
>> +	return true;
>> +}
>> +
>>   /*
>>    * Collect processes when the error hit an ksm page.
>>    */
>> @@ -3237,13 +3258,13 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>>   	if (!stable_node)
>>   		return;
>>   	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
>> +		unsigned long addr = rmap_item->address & PAGE_MASK;
> Can be const.
>
>>   		struct anon_vma *av = rmap_item->anon_vma;
>>   
>>   		anon_vma_lock_read(av);
>>   		rcu_read_lock();
>>   		for_each_process(tsk) {
>>   			struct anon_vma_chain *vmac;
>> -			unsigned long addr;
>>   			struct task_struct *t =
>>   				task_early_kill(tsk, force_early);
>>   			if (!t)
>> @@ -3253,7 +3274,9 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>>   			{
>>   				vma = vmac->vma;
>>   				if (vma->vm_mm == t->mm) {
>> -					addr = rmap_item->address & PAGE_MASK;
>> +					if (!ksm_rmap_item_mapped(page, vma,
>> +								  addr))
> jut put that onto a single line, please: easier to read.
>
>> +						continue;
>>   					add_to_kill_ksm(t, page, vma, to_kill,
>>   							addr);
>>   				}
>


