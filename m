Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B16CA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 13:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801376B0099; Fri,  9 Oct 2026 09:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B0E56B009B; Fri,  9 Oct 2026 09:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6866B009D; Fri,  9 Oct 2026 09:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1256B0099
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 09:54:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 95EC1803AF
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:54:11 +0000 (UTC)
X-FDA: 85303231902.12.1AEA1EA
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf31.hostedemail.com (Postfix) with ESMTP id C2EC020005
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:54:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EDXiZDX7;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791554050;
	b=Igtk7UtKkCyXBPz7TZym1FUgGvxzjQMu/8jlswkn9WnGaxf3y7VvRhTaCppSY5WrV48U7G
	bd3d8MuwgCn54+ys+hml9a4GU1huuB57x5FkOyPFFYFQhFqjnDvAJmm1Ewd9llfewRPhoa
	25dcqEjPUE9lj993fV0C0+5uA4vAkTE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EDXiZDX7;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791554050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=71p5uQAWJGojknJOSBYU8KuAs5ErvcQvTNDLjcQGm74=;
	b=LZp7nitmY1VpVzh0F0OXZgoYYJovmMM8PsyDghX4Ta3iu7DIDrSXFhib7+tNl4/MvE4pXF
	4HWY2aQUT1sQJtX186+obW8U+/sroOloBkHIT5OIYXL4c0RorS0MYmvvcbadj2Hf1FI+aJ
	ai5HlHd6jbuE+XpPxoQWpg/0EX4jp90=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791554039; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=71p5uQAWJGojknJOSBYU8KuAs5ErvcQvTNDLjcQGm74=;
	b=EDXiZDX7+fWEtsOKVSWrY4lgWVt2eC+RjfYSDbYUa6P7A75wOtaN9iC8fFsFKDb6GgpGiMgadgvCWOPxRqE9Y7+xP259EhkKZPS6Li1C/OQq4REJ3eJMXqAR3v9Iy4BlneZK1Sl7uxHC2pT/fYmyMoOV7aaiQSXja0eH4tXpqcE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XCTcWz3_1791554036;
Received: from 30.42.72.158(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCTcWz3_1791554036 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 09 Oct 2026 21:53:57 +0800
Message-ID: <62e0ce97-1016-4f82-af38-7703c8cffefa@linux.alibaba.com>
Date: Fri, 9 Oct 2026 21:53:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memory: fix truncation removing mapped folios
To: Pedro Falcato <pfalcato@suse.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 qi.zheng@linux.dev, jack@suse.cz, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <0d2a1809fa1cfc22ad3df26ec28b2d30e5cdf3bd.1791540483.git.baolin.wang@linux.alibaba.com>
 <asjXJZap53yJWMYi@gremlin> <asjr2zCp1BVtfpTV@pedro-suse.tail5790ac.ts.net>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <asjr2zCp1BVtfpTV@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: so7rq7qimtufwcf93tftgpw4iyxw5hx4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C2EC020005
X-HE-Tag: 1791554044-168243
X-HE-Meta: U2FsdGVkX1/ODUEWEN288D96xuwbcvj0+IL8nBJ80J7Sng6tVDRRAcgBkj15kA/jUwZyGIXuZF6/+XaAHubYQ91GIr5kPlmIzy2x5c5R5RwkKzBjs8Kd42FUVDfpHO/K6A4yDX9/v5WTS+Q2651euWH85Q8lt/9MOfoLA+GBCAlwA9AhXpHzH4hrgemsjiCafi6y883TYVTvNXSWhYe+wPmeWdEnRGVUHD6deJ9iO+xnD8QH57WhHC16Ctk4EaltggyoyBBVTriOoqcIGN+pWwQ6X94mAddU7t051NJaBZwl73dEunxVnxFrH8FREWPhm64q49QVAdywTuHHRBWeCtS3j6ulcgWcnIea7scdjCqIK5gRN3Q0+0k/zNRkmIpv3KYC1hUokdAb0rqS2PZEHcudZjz5S1Nkc0p8IdJZ1G8vQ0PLcByo7uTD8issGUk2vcuPNFt8TN4eZpqSZXxaGQplphGTKRquHtLsNUSy+KDnUiIvwM2xN6i+iewnz81V9eXM8NUZCPQLqryL5riq/TsOkX0A18i71QJQXA1yYvYVHV48mMBN+dSR9DlUNCkH6Yr8LHY31z7VPATZqXmsz+F1ShQpfYegrn7SfmRHAkmNRDLkqu7CVd6XPcIB2WrfZ4X00MeCh3/LiFaySExqD2YvCT/SkK2SBRV9ij+f3YO8s38KXXufKmXauwUEjQ0UyOlWsMzVU6z8Nhv5/+R1CYSS2dCZRYHe+/GYhgxiuYa7pLVSx4dl+F5lH13Wpbo7q9zHBzMabIsVBt8oBKXw/9yWqesk/prxvOFFa7cdW9O+E1VbEgjcOduEvX6x/WQqxvcgnmLc8Bg66H4V+WKLBfwJylio/FcX3chE3AgWCJDXNPwctMCB4gjNIXR+pCcTZVtL7G6OMpjgLSJbSn3lG07/DUtrW1DStbtt0PC5dMFBcQae8/bcEg2gx0l1M0jjiIoyQegX+FonqMDbtN3
 klm83prv
 nULYKhEsALeSJ4ZHAAhIKpZ5ozxP6AULxq4R29aFuqyPQH6bxrr8FSuO6t0okj4YBxTLsm+gq0XaYMcoxRdP6BzxMa2RLKbWZAKTDFPcA7dMC+eFPn8xrtn8/pdbPteLMq4WUs5GppzAziWVc8f5Bv5tJK3z3aJkcwNHE1TXuogd40jURzSH3xOS2xzkEFiZ9M/gWm13SiSIk0bPTTnDPT3sAzLc/ovjG5rK8qV9AcnzLsmDDYCo46HRdsl8iXhE+4oV2wxT6U3hzjtjpaVTJzC65HQNYrtEPNssMqhV1Qd8g9ndIHJgWlw0GnGd/8ug/9nmL8WaeqZaD5BRDOIEogojcKOLjjz2ROMK8mqBu7yHlljjJf9AoesqlrDGEurmNO43m0wFoc2tLTV+zuo2Vps8Q/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/9/26 9:36 PM, Pedro Falcato wrote:
> On Fri, Oct 09, 2026 at 01:00:52PM +0100, Lorenzo Stoakes (ARM) wrote:
>> On Fri, Oct 09, 2026 at 06:12:03PM +0800, Baolin Wang wrote:
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 1f5d5f7d39cd..0272217ad7b0 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>
>>> @@ -2044,16 +2053,10 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>>>   	 * to ensure they are still none, thereby preventing the pte entries
>>>   	 * from being repopulated by another thread.
>>>   	 */
>>> -	if (can_reclaim_pt && direct_reclaim && addr == end)
>>> +	if (can_reclaim_pt && direct_reclaim && addr == end) {
>>> +		/* rmap changes need to be observed before e.g PTEs get zapped. */
>>> +		smp_wmb();
>>
>> What does this pair with? You should always say what in the comment.
> 
> Yep, this is missing a rmb to pair with. The diff I posted at
> https://lore.kernel.org/linux-mm/asigKktcrSY80A_2@pedro-suse.tail5790ac.ts.net/
> had one in zap_pmd_range(), which admittedly isn't the greatest. I'm not sure if
> there's a better way to do this.

I don't think we need an rmb to pair with. This is because the 
folio_mapped() check in __filemap_remove_folio() cannot be reordered 
(guarded by spinlock) with the pmd_none() check in zap_pmd_range().

We just need to guarantee that when we find a pmd_none(), the removal of 
the folio's mapping (via tlb_flush_rmaps()) is already observed.


>> rmb/wmb are generally not needed vs. acquire/release. Are you sure a wmb is
>> right here?
> 
> I don't think that works, because __folio_remove_rmap has a ton of stuff going
> on, some implying full ordering, others not. Plus you'd need to switch the pmd
> dereference to something like an smp_load_acquire().

Agree.

