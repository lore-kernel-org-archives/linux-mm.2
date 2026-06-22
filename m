Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE5C2CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 12:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8BC6B0088; Mon, 22 Jun 2026 08:01:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B05D6B008A; Mon, 22 Jun 2026 08:01:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C73C6B008C; Mon, 22 Jun 2026 08:01:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5963E6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:01:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD77AA012E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:01:05 +0000 (UTC)
X-FDA: 84907407690.21.759B2E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 04AB0100015
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 12:01:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fp5uGzNY;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782129664;
	b=yaOy5YI9L6j6mpxTLkKkrSzwePjJg9vOWhkUnnA1EDT/FuCEoNdEOdv0l4AALZq2eAKJMD
	yXssa5u+0cw4hKcq7zq1C2vCka4esPus14wNUiXV7lt6jIqfRz4UtINyEUP9IxrDH9Wvn4
	Qr0WTPCkd6zCfY6Qgjj8mtM7pTOqp50=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fp5uGzNY;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782129664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hb+xK1K2v16uboBzyh3TzN4n8wpgYjwMIIEfcewwUJg=;
	b=ZxnwkUiszk4tweT+DgbtMVrLfVNDdvg14aj1fQxF2db2hj0HAkcFNqX6oxlbM16QWiDSbS
	lDS/Blofh+EwjfoB+EgEIks3ZPxD+yUu3CnNz2AegOnkFpZDeqLpGgb9kiTp9xayY56saZ
	/9T6W8E7lQeA/F07kzTV2635yePHPQw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7883F6001A;
	Mon, 22 Jun 2026 12:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30401F000E9;
	Mon, 22 Jun 2026 12:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782129663;
	bh=Hb+xK1K2v16uboBzyh3TzN4n8wpgYjwMIIEfcewwUJg=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=fp5uGzNY7paUzv00kCFpF+NxNCdwOOIxnW9qL4vct2NCpHuFSbM4tyq5o7aFNuUQx
	 3zM0af3z5joZrCn43s/96UJEyoSljgjaBMixwLm80KN2an3jg6+yLy/1grrDAxpCSu
	 Y5d0FiaMiFc824QPjb7SAIXhSFLzUTrVoN5WvBTGSjbYeFtoo5iWBqJfGc1/OvSBJU
	 Tt8v/3aA8QRU9dwStjFgV9Y0rciWhcf19Rzn7vQcHTw2MJR7C6gj6Eb+1LFaMSW0w5
	 QGR4uId+6WhxK9cT4M/OBKlNslhd/mAevTq6qAk69nIIjtQ3q0HEpWnVKl1qAZLAXP
	 jFiHPDTzlQ7Jw==
Message-ID: <a6f2b88a-3a99-44c3-ac49-b8d9027d483d@kernel.org>
Date: Mon, 22 Jun 2026 14:00:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc: fix KPF_KSM reported for all anonymous pages
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 ziy@nvidia.com, luizcap@redhat.com, willy@infradead.org,
 linmiaohe@huawei.com, svetly.todorov@memverge.com, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260622091539.836531-1-tujinjiang@huawei.com>
 <93e9c643-f6fb-4377-ac5a-d91e203ad1a6@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <93e9c643-f6fb-4377-ac5a-d91e203ad1a6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 04AB0100015
X-Stat-Signature: 3gcq8mta3r6bxt6akn14ki8ksyraai1d
X-HE-Tag: 1782129663-480587
X-HE-Meta: U2FsdGVkX1+LuKcZghmyhOAdDCRcK6MDTH0Spx9ogFrez2MdbnJgba2gLDM3mNy463mSoc9/dj6xnlW/s/zcKzYJ3BD3WekUaAEiUddgV1zLlvD4tcf/XlB87KFu70F+n1YYD/i6VD/BMzGAGzO8b2AeVqCzitVGcu15qesdVJYOgsqOzwEfiImpYHD5ejOFjqnX6qpdQi9pSm9awQgVTjcoNX3xLwE5Yw4ZHNotpwsSzpf/jyndGhUvoxiBp9p5buOoksj2X0jxeD3rS6kh/uL9pPSwrNxDW4Ss/9AZNU+p7gbLmVdtaC8k+vkNmx8GTdbAzBaZyB9dZHPZctpzZYBOj6Ft+2EQe8F0hqp3CYle4AVDiE06Sc1+2UaxF5QfdtqBoAGu4bhEOwTrpGZgf4IUXOTknbrXv5IFEG1Mo9wsZ5ejv/0yXBFX2Y3siXg64lFgHPtoHurRzJ5++qUxt0SjIDBg5RIuoxeYoyc8ANrxhdN7TGtYGSGtM3Ef1TtesnvFXWAXKb311kLZsMp4TeduT2bD4ZJL3VRZAK8q6fd46BrSnYdyFouc3qdTTQ39XSiO2ltXmz0OeL4zOvBSduLzB02tI6vB0ctoqT8uZJYNn4C01LH3gSt27v8r99r3dsWxbYHfVYjaIX6ptx9ePbOOMzm1nPhYFcfbyYoKrzwV21aBsbGSvZpiUSNs1tEpoT0MRtjCRKhixmCy3x+Et63BIjr+ALpV6vJ10+ExXUlSG/PzVtdY675MzYMCLI3JkvLNY6DL8ullt8vTOa5IGFCW3xc7qfXK9PrWza+cLW5pE2IRKguGu1SYjIrzH8D5/05r8iSxh62sDBKT+xihB5IdQNnLPoQ8FU0SI2XxL2mpYu3jbK90km8fcALNSuKBdA6qHGvXsmwQgjs0plf1hFU70zXn2RGC/XkrH94c/JijTIdVVUcRl9CbUCCtOU3fo2UhI+SzAa+NzE7SHd6
 RuEGoenN
 l/k+MzYJrf7Yref3QPbeK8VQbFx/cMuV6waRCinINkTy+8ctYywJfeHDRRg5f8ImbGnZ37NEQiKgDx6xyoo7NeEYlkjuv+mDjLf7H5pD/hUsLAyZ/SLxzcuOyI0ynqa+3E9fLH8NWJIBFwYrlfqEpSd0GlBNqbTvzHyTYSGAR55cEXGdX+QzNt3kE/zsPUi5jYX0z6BrCoorARxXBGt3MD4Un21iJU1J2TqKKEp9GBmw4Wi2PBtDRjiUDhRnuSldAV69fFb30CC4IOIYwE7WNOlJ8lKANJC6+54bmziI5g1ZrEudeN31ijwsoRZC7TV3W3p0GSSOacH/lxB0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/22/26 13:45, David Hildenbrand (Arm) wrote:
> On 6/22/26 11:15, Jinjiang Tu wrote:
>> Reading /proc/kpageflags for any anonymous page returns KPF_KSM set, even
>> when KSM is not in use. As a result, tools misclassify all anonymous pages
>> as KSM merged.
>>
>> In stable_page_flags(), if the page is anonymous, then use (mapping &
>> FOLIO_MAPPING_KSM) check to identify if the anonymous page is KSM page.
>> However, FOLIO_MAPPING_KSM is FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM,
>> (mapping & FOLIO_MAPPING_KSM) check returns true for all nonymous pages.
>>
>> To fix it, use FOLIO_MAPPING_ANON_KSM instead.
>>
>> Fixes: dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
> 
> Right,
> 
> #define PAGE_MAPPING_KSM       (PAGE_MAPPING_ANON | PAGE_MAPPING_ANON_KSM)
> 
> Which we later renamed to FOLIO_MAPPING_KSM.
> 
> 
> Before switching to manual flag checks, PageKsm() translated to folio_test_ksm()
> that checked whether the values actually matched:
> 
> ((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) == PAGE_MAPPING_KSM;
> 
> 
> This only affects /proc/kpageflags (well, and hwpoison inject on a weird testing
> interface), so it's not really that relevant for real workloads (debugging and
> testing).
> 
> So not sure whether we should CC:stable. Likely not.
> 
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
>>  fs/proc/page.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/proc/page.c b/fs/proc/page.c
>> index f9b2c2c906cd..cef8ded97610 100644
>> --- a/fs/proc/page.c
>> +++ b/fs/proc/page.c
>> @@ -173,7 +173,7 @@ u64 stable_page_flags(const struct page *page)
>>  		u |= 1 << KPF_MMAP;
>>  	if (is_anon) {
>>  		u |= 1 << KPF_ANON;
>> -		if (mapping & FOLIO_MAPPING_KSM)
>> +		if (mapping & FOLIO_MAPPING_ANON_KSM)
> 
> 
> Wonder whether we should just do
> 
> 		if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
> 
> To match what we have in folio_test_ksm.
> 
> (although I doubt we would reuse this flag for other purposes, likely
> it's more future proof to check it like that)
> 

And just to mention: given that this function now operates on folio+page
snapshot now, I think we could even stop doing this manual folio->mapping dance
here and just use folio_test_anon() + folio_test_ksm(), as the values cannot
change concurrently.

But that should rather be a separate cleanup (and needs double-checking).

-- 
Cheers,

David

