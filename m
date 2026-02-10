Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A630EA3F36
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 10:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5982C6B0005; Tue, 10 Feb 2026 05:08:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546056B0088; Tue, 10 Feb 2026 05:08:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426A66B0089; Tue, 10 Feb 2026 05:08:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2CBA76B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 05:08:06 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE2261604A7
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:08:05 +0000 (UTC)
X-FDA: 84428121330.08.87E1061
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3D0DBC0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:08:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="qHAJS5s/";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770718084; a=rsa-sha256;
	cv=none;
	b=Mt0SufSctLEyKvvTEOwe4FGJsTF/ugkrQkv3MvHwEPulzktRFyA//oKOGNATljBlCnJ/YY
	sX/0pzqFq2/9cZ4uyP1eTeGQac7GMzVjqR4zl4HpPvhz6UEzpohk2usYKzSj/3+cWsbWRm
	ALYW5cYXf9PRdftQ+whI5oTBNrfw3vo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="qHAJS5s/";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770718084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DWoaJhbhh9LSr2qIWoaa8qkMPfZNPVdj8qV+JYMSPq0=;
	b=kPRKQV/7rbgzEHbef0xX8y5yc5H6F3Fx2eHrvFqqzteidcKUihsL2u/B7bDStTfYmH7YfA
	rDpEhl0RWcPdhTnk8Ax2wBoqzIQ1cxgFiYBwXjYioq7GXcRRocjPsFATLp7ZbxRRw8zA+T
	6G4gLwu4ZLAOzdY2UJn3TsSoI5u0qMY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770718079; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=DWoaJhbhh9LSr2qIWoaa8qkMPfZNPVdj8qV+JYMSPq0=;
	b=qHAJS5s/L/TmkCCAPN7q07A6jhzCZHgLIjz2oOYxQLxe4YyzoDQ0jZhXCBR7jDnw++kfF+R/Uoqrkt7nR9YuL8xYIxsjP3Xj5gLLHMXxe8ZwgUA2kAlU1rgfnnfpN/vq6lsRlVjyin6cOM/yD1zGLunGIi7gnX93s6AhgUQywTQ=
Received: from 30.74.144.109(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WyypYqH_1770718078 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Feb 2026 18:07:58 +0800
Message-ID: <a6e73466-030f-4b9d-a0b8-502916c139f8@linux.alibaba.com>
Date: Tue, 10 Feb 2026 18:07:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [stable-6.6.y] mm: khugepaged refuses to freeze
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <gp3foqukne5ukrssvx64svhcpogmrskyyzjatofstfrl3vplrk@onxbnxdjrswu>
 <3d0f189b-faab-4452-b9cc-8f4e7a15025f@linux.alibaba.com>
 <jujsgu5ed3srhetch2pbpdrt4tnf2alodrk4nfo7idxmhsq772@lirvj7ftvxgv>
 <h3bbxn4omwe2jv32vyjou34me73x5nwg6ai57goqo2qlntq73y@ra75spa3tlzr>
 <1179320d-6bab-40a4-a7ac-dbcfbab24623@linux.alibaba.com>
 <c225864f-192c-4cf0-a5fb-411de8c22eec@kernel.org>
 <70ed2de7-3e66-4a23-85bb-e0a4c5b61088@linux.alibaba.com>
 <af21afa0-2a30-478e-ac9f-6bd431af6502@kernel.org>
 <gogfqtdrd2lfoiwfetql4v2pjehof6q42oewn2tphddobzawf4@efiyrhjyzm7o>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <gogfqtdrd2lfoiwfetql4v2pjehof6q42oewn2tphddobzawf4@efiyrhjyzm7o>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3D0DBC0005
X-Stat-Signature: 8bueuo9345f6qb9r5j1cgztcnxrij547
X-HE-Tag: 1770718082-222386
X-HE-Meta: U2FsdGVkX18N8a8Forfa1WvMLG1WNtTGbILfVjBcR4Qwi+fShejwYYo0OOqWLdYK5EiCn8rsl3ieMtrrNdGDmpPK98yJbJYovzknzeYE/j2LNzkJNoRjpAJUJA56jenQGL/CrUoXcc+jLProiKuLW4mikger/uQzRrDBjwSzhX0u9cv4ntMrBGcv4/aoQ0qYtnjQMjVdo91Q4elRkaQ7OeUamNKPA4O/ehn1EHDFt4g0wrkXNkaY5tcGyMMr0eEC40cHaeIimC3ttTBPJ1yuASTBgetCarKImz0AZJloOBqm4aYODKOreUbbk2unLyxkBF+yUfae6NTANAio4vE4vzpN/fSqweDD4n0HV4Z0dF+WYqbZcdFGFxmTc602KKWYTylOVGgitfSVhONcZYjiN1iN3Bs0azQQysSmcHLZ/JEhJJv2pFYt6Aejusriw2G7L+yQ+xoI8emL45MjGwvT6vQFgacO5y2JBfrIJGvupHGtbeqiSYGRCqrX4MfmaQfe/3UXDe6A0eUCvW6GLvvRZdqcJ2eViuHPttRazCMf2d6IgFDVtMsefSWLvd7ns0yOxE6StNIm5NmYSe8+W5DWO/OZww1puUD+QAEBN4El3MZV4PScY09hxv5KBTURLf843t9oqoa5/tHOlM1EWPg8cmblk5kY5KgBDQj07xLctaUit+2cWQadeqkOLdebXzG5fjruZHdia5kbfZjx8UBw6d2quCW+Sp7k8Qcw0IfGI7VQb6sdBDs9SyqcJSrhoPqZP2AAOYGsKGwsO42HwqjCR0nsrGKyd8tJ1pomaE8OxiEASaH4qSYf8dUbpkeH78e3I54jkJ3iJibKIx7aK5s3Le4zIVZZgkptRbHjupx6+8r9t/xRaZdzHOUNpJFNwhGpLNLOzIOsReEeUFP0PbLfW0nh2pTr3SS02T+vxutLMPlNcfUYT4C40yzUNV2xn95gH5vbj0XkeNzVu5NI2BF
 CzcEvx4l
 RK+uxFkeg254qxE4/S8o7D/zwf16S4mPncQnin7H4KFSjlyvzJs0nzPRIllZkd8eHYYaYGzCnWeiLL+6HxwJmL3lWo5FGIywnNff5AzsuORgdD64+oJVArjTSF/Fa+975YEdRyVnqmIshJUO41leGIAxYRWK5/JOED2yIow3DISXaPMHQV/mQ2AmpRcxxH3jYWQekGnLaFzsT3pVm1Wx287JUS7Gz7NQTuQcwds0HGAlCNGAnw39mHRV6vxHCriJPQzz5g1FOKLah34qk6VViz7rTqLqVKT9nI2Xd7+FUDSwjMUWWZKhalgyjo4Ac/YY6oTqxvEpatUX+DbESjolNvwlcKKY081iF+VwJ1TbaYk1uN4+dMWLdnr/CUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/10/26 11:21 AM, Sergey Senozhatsky wrote:
> On (26/02/06 10:00), David Hildenbrand (Arm) wrote:
>>>> I recall that there is a notifier when the system is preparing to
>>>> sleep (pm notifier or something). Could we simply hook into that to
>>>> tell khugepaged to suspend+resume?
>>>
>>> Do you mean “struct dev_pm_ops”, which is used to register PM callbacks
>>> for devices? However, I don’t know how to use it with a kernel thread.
>>>
>>> Also look at how kswapd does it, kswapd also uses
>>> kthread_freezable_should_stop() to check the freeze state.
>>
>> Right, mimicking what kswapd does sound reasonable!
> 
> I may be missing something, as I'm not seeing dev_pm_ops in vmscan code.
> Would something like this work?
> 
> ---
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index fa6a018b20a8..c5d89ec223d3 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -394,8 +394,12 @@ static inline int hpage_collapse_test_exit(struct mm_struct *mm)
>   
>   static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
>   {
> +	bool was_frozen;
> +	int ret = kthread_freezable_should_stop(&was_frozen);
> +
>   	return hpage_collapse_test_exit(mm) ||
> -		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
> +		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) ||
> +		was_frozen || ret;
>   }

Since the hpage_collapse_test_exit_or_disable() can be called by 
madvise_callapse(), which is not a kernel thread. So I think using the 
try_to_freeze() is enough? or pass the cc->is_khugepaged to check if 
current thread is khugepaged.

