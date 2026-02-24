Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54DD0F4BB82
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 20:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39F836B0005; Tue, 24 Feb 2026 15:55:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D426B0089; Tue, 24 Feb 2026 15:55:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24F1F6B008A; Tue, 24 Feb 2026 15:55:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 136C76B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:55:45 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD13C14032D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 20:55:44 +0000 (UTC)
X-FDA: 84480556608.26.E401FE5
Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	by imf15.hostedemail.com (Postfix) with ESMTP id C2E89A0007
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 20:55:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=w6rz.net header.s=default header.b=y5Zgh8rs;
	spf=pass (imf15.hostedemail.com: domain of re@w6rz.net designates 44.202.169.39 as permitted sender) smtp.mailfrom=re@w6rz.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771966542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=605D1atgrhxBK+g/fa4UaJI857HWMWFLmIjAiil6I1I=;
	b=6zXcjZUK9SEJgXgSirIXoIync2hDiwaK7xUAEeQV1T60POraOl3drkdMhWX+9eNg8kRNFf
	77Wo8cAQQDEvZCHlfhjTjRJknjxejSXd2qlgkIjd9e8zoS0bHbpC+oKsmoZMj0fOS+BgYU
	nmmNPA19OmaiZXIDCjpd4ULw1FQE0eI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771966542; a=rsa-sha256;
	cv=none;
	b=1KTneJ2+00MZ4AAkWaakIEMNnPf6i3KnZ1FU5tscCjGawPzUfY75+dAVp2ZML8Eb0CuMkE
	6lQa1TD8TEssz3A0DMbaBcSM94ankTqCTjvtityL0HJ7jigC4IDeYVuztRCMZEXphrOwHl
	2Uh4F0FpuUOOnnHN6jCAlUOM7wuIXkk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=w6rz.net header.s=default header.b=y5Zgh8rs;
	spf=pass (imf15.hostedemail.com: domain of re@w6rz.net designates 44.202.169.39 as permitted sender) smtp.mailfrom=re@w6rz.net;
	dmarc=none
Received: from eig-obgw-6001b.ext.cloudfilter.net ([10.0.30.143])
	by cmsmtp with ESMTPS
	id umOqv9IUkCxrGuzRUvXitA; Tue, 24 Feb 2026 20:55:41 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id uzRUvqbJ9cu11uzRUv4HgT; Tue, 24 Feb 2026 20:55:40 +0000
X-Authority-Analysis: v=2.4 cv=bKYWIO+Z c=1 sm=1 tr=0 ts=699e104c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=7jLG3vr0xv3RlmufI5wA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=605D1atgrhxBK+g/fa4UaJI857HWMWFLmIjAiil6I1I=; b=y5Zgh8rsy0gArKveqbuKhkEZIt
	Z6a5DQ/DxsNIuzv0rP5sjhacVvbGEJaHaR6/s309cUj+lcdWRZH/t36PhAmJ7zEaMV1eVeDhMDyV+
	pi54uIw3TlVLgHQIJTQBlKMM7yE0Gs1jFhnAgKccaQnf+gutAa5ij9XfqQ7fUOXAc8kUtukTY14Kv
	uwgQcLJI9jED4zf5V7y2oo8ex0EOIYwQY2WZrjHTh+iXBSmyt6HTZwI6F7lcM5KTkBdZKMeFvdJap
	a07VBh9hbByd/2tAGkvy1hiMvY1/9502XXOjzU4Q/PfmgwRAwmsACU/e/aJEfv/xmV+5+xGojimje
	vMfZLk1g==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:52214 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vuzRT-00000000bqv-39S0;
	Tue, 24 Feb 2026 13:55:39 -0700
Message-ID: <5a08d5c5-a91b-458b-8434-84566387a27e@w6rz.net>
Date: Tue, 24 Feb 2026 12:55:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm: Regression with v7.0-rc1 on RISC-V
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 jackmanb@google.com, jane.chu@oracle.com, hannes@cmpxchg.org,
 willy@infradead.org, muchun.song@linux.dev, osalvador@suse.de,
 sidhartha.kumar@oracle.com, vbabka@suse.cz,
 claudiu.beznea.uj@bp.renesas.com, Mark Brown <broonie@kernel.org>,
 akpm@linux-foundation.org, pjw@kernel.org
References: <1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net>
 <13b8d60d-1209-4650-9fa5-982381c53512@kernel.org>
 <1966378802.577797.1771952827516@app.mailbox.org>
 <78D36EC1-2596-448A-A939-0A1AC7B3D1BC@nvidia.com>
 <1AB3E96B-F4CA-4B00-9078-2AC20A1A60DC@nvidia.com>
 <272A58BA-445F-46F9-8DAB-D82E43D7771A@nvidia.com>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <272A58BA-445F-46F9-8DAB-D82E43D7771A@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1vuzRT-00000000bqv-39S0
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:52214
X-Source-Auth: re@w6rz.net
X-Email-Count: 15
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKne/hb8BLrlt8xG3/WT4TjfNF0urRAFKnDxtJVU7zye3ucZm3O6MCUNBMabcIDWUuQLcsinUbhFPoMp7aunAiNLIwSzYLeNe8M94n7Zmv59Dv0b11Zl
 JeY/EO66AOJ5nu7o7JOeX1627EnLDx1MpOBJPeg7MX0F5C8juUeZtRVxYROABFDifync+vP+L0JNaA==
X-Rspamd-Server: rspam09
X-Stat-Signature: 9hg8u19zxp38u4js188zauonkjzwzx9m
X-Rspamd-Queue-Id: C2E89A0007
X-Rspam-User: 
X-HE-Tag: 1771966541-852445
X-HE-Meta: U2FsdGVkX1/6ieaYs2IcJzM26bfmNJOo+2wTBZN8zqDj8mNVnH00nJHW8rwQUgQ7Kdfsu5yDU2dOly0lV7OOW+xBVMYzHB/kw5hOFVRh2WlugyZZ0YamBM5m1TIzvfCA/MP+i4vuEX96DSnGwGtlxLm1o8I8koVaFxyHf0g6cl1vvyVH8PKw37qR7mdiXXB9bUX3JKNM0FfK6JmtkPi5HR3YVYPpChSSeRvWM/uNHp/extWPB29wI5jrAI+XOqKrrTStql0nMhxPgpQvfZS6z6T8Wk+alWvqSD0QXI6lod+Cu1LXOV04VXRJchoD24LG9P9wDptxIFI/Hxj7aeJCWGLVEHRwRuD4uSNQKUsPBQaRt6vDNba9jOxcvBi/ueH9sL+Vx1yqc54QQ7F9iUCyCG6ZrLOeBDRMvdQhrFibbGxueKIeplCC2Ghzb8+DRRF5R/WhpGFa8uTR0GHmrVtKwzKCIw4kDk0mEzq0UrdE7O2cQ2SBsxISaLouHQR8LFvTfyUioD6vrWcyun8WoZg0i9g0Fqf7b8/qbr7wKdpP5ELLYK9N7+C+KogO5QcZWsjOZuleMEKCWjxo1G5iFjcxa1QtXKjWZkaH0wcIfc99fsr+gWyFqCM/NWRyMruK+3530I7+V4UlHBRyhBnRu4UoYWPJLSSDRMxhuKGoYoupFgh3/Rd0RPei6rE1w8BNVDpPfLxmhq4oyrBn79YhPjBl4ad5o0xyzsm4T3/J66rdT4GdGACF339xJcknfoUR+5wTY4z+THw8xqBZEsaQA8dp74vWjfoQ4VA64xXKQh4+fa1u3osaYjB1a34X/V44IHaOQ4eTDUp3LVicNDnRSLLNhggspjOkLbB45kgTep9+/78bz8o8iirjLwEqH56YHn6lH+eMsMED4bMsWTpKRPIX2IMhMo4vPxWqkia+W8F3z1Bpu8DfJxQ1rK9nE0niKAuBEbvuXePYs9YUrEJWGbY
 mSseoOEi
 LF+SZleqYhkGEU3jXLfAVnwRe3SKtlc46LVhflmSXID3wDCfmq3/R9JX0PDZiT8nARsUvutUKAVb353ZFGm3/Cj5wtk2/NZjNeDIyu4wshmZZfluyu3y6FPSkhQENk775lzZx9SniCKI+lR+NTpt2Gln+SNmDugWM70qiYefo6i75TCi++WP0qAjuMtEGu1lO2v+a+gBmNGXeHa67ZSvGr5OEp+icsVYCf8ObR94wGFXN0U8mpArnUQnhiZRL7sBdpJZpf5AQtScUB44p7fOl1wE4UHvFoxu5dEJT9CHr/CHbCSKuhsymT3rjZW2w2znpVyQeQcxUDRox26W1Xcv4k7sj/KvmdyRSKCONUgZWn+GsOFOFZCY+GuNWoDnyeUMoLkwb1IaxnPFu636E9/nkSMLbPTGKImqiazH/9knBBmRT+Wxub28qrFdinuKsE4RMn6jRRSbk8UvrY0txnac9PkT2tUuKXaqrJy5aNJPB+FW6k8qdBdYjrErY9myu138JHRAXoT+vKJO1U1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 09:29, Zi Yan wrote:
> On 24 Feb 2026, at 12:17, Zi Yan wrote:
>
>> On 24 Feb 2026, at 12:14, Zi Yan wrote:
>>
>>> On 24 Feb 2026, at 12:07, David Hildenbrand wrote:
>>>
>>>>> David Hildenbrand (Arm) <david@kernel.org> hat am 24.02.2026 12:00 CET geschrieben:
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> On 2/24/26 09:37, Ron Economos wrote:
>>>>>
>>>>>> I'm getting a BUG dump during shutdown with Linux v7.0-rc1 on RISC-V.
>>>>>>
>>>>>>
>>>>>>
>>>>>> [  OK  ] Reached target shutdown.target - System Shutdown.
>>>>>>
>>>>>> [  OK  ] Reached target final.target - Late Shutdown Services.
>>>>>>
>>>>>> [  OK  ] Finished systemd-reboot.service - System Reboot.
>>>>>>
>>>>>> [  OK  ] Reached target reboot.target - System Reboot.
>>>>>>
>>>>>> [  173.985249] BUG: Bad page state in process shutdown  pfn:f8850
>>>>>>
>>>>>> [  173.985311] page: refcount:1 mapcount:0 mapping:0000000000000000
>>>>>>
>>>>>> index:0x0 pfn:0xf8850
>>>>>>
>>>>>> [  173.985336] flags: 0xffff80000000000(node=0|zone=0|
>>>>>>
>>>>>> lastcpupid=0x1ffff) CMA
>>>>>>
>>>>>> [  173.985365] raw: 0ffff80000000000 ffffffc501e21448 ffffffc600f2ae88
>>>>>>
>>>>>> 0000000000000000
>>>>>>
>>>>>> [  173.985386] raw: 0000000000000000 0000000000000000 00000001ffffffff
>>>>>>
>>>>>> 0000000000000000
>>>>>>
>>>>>> [  173.985403] page dumped because: nonzero _refcount
>>>>> So, we're freeing something from CMA in cma_release().
>>>>>
>>>>>
>>>>>
>>>>> In cma_release() we iterate all pages to decrement their refcount
>>>>>
>>>>>
>>>>>
>>>>> VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
>>>>>
>>>>>
>>>>>
>>>>> I would expect that this would fire already if there is still a page
>>>>>
>>>>> referenced.
>>>>>
>>>>>
>>>>>
>>>>> Are you running with CONFIG_DEBUG_VM=y ?
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>>
>>>>> Cheers,
>>>>>
>>>>>
>>>>>
>>>>> David
>>>> Thinking again without my computer at hand … isn‘t the call completely optimized out without CONFIG_DEBUG_VM?
>>>>
>>>>
>>>>
>>>> At least that’s what I remember.
>>> Right. Without CONFIG_DEBUG_VM=y, VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)))
>>> and is_check_pages_enabled(), which leads to free_page_is_bad()’s
>>> “page dumped because: nonzero _refcount”, are disabled.
>>>
>>> It seems to me that someone else bump the page refcount between
>>> VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn))) and free_page_is_bad().
>>>
>> Merging Ron’s reply from another thread[1]:
>>
>> “Something strange is going on. I enabled CONFIG_DEBUG_VM by itself and
>> the issue went away. Let me try CONFIG_DEBUG_PAGE_REF.”
>>
>> Looks like something is racy, since it is reproducible reliably.
>>
>> [1] https://lore.kernel.org/all/30dd1efc-9bd9-4664-999e-610d181600f9@w6rz.net/
> VM_WARN_ON() is BUILD_BUG_ON_INVALID() when CONFIG_DEBUG_VM is off. Only
> the validity of the expression is checked and no code is generated.
> So that put_page_testzero() becomes a NOP.
>
> Hi Ron,
>
> Can you check if the patch below fix the issue without CONFIG_DEBUG_VM?
>
> diff --git a/mm/cma.c b/mm/cma.c
> index 94b5da468a7d..96be62eb3713 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -1020,8 +1020,11 @@ bool cma_release(struct cma *cma, const struct page *pages,
>   		return false;
>
>   	pfn = page_to_pfn(pages);
> -	for (i = 0; i < count; i++, pfn++)
> -		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
> +	for (i = 0; i < count; i++, pfn++) {
> +		int __maybe_unused ret = put_page_testzero(pfn_to_page(pfn));
> +
> +		VM_WARN_ON(!ret);
> +	}
>
>   	__cma_release_frozen(cma, cmr, pages, count);
>
>
>
> Best Regards,
> Yan, Zi

Yes, that patch fixes the issue.


