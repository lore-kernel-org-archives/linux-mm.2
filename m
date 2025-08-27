Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31E19C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 09:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C06E8E0131; Wed, 27 Aug 2025 05:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590FF8E0105; Wed, 27 Aug 2025 05:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4585F8E0131; Wed, 27 Aug 2025 05:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2C59E8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 05:33:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9CAFD139BB7
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:33:55 +0000 (UTC)
X-FDA: 83822025630.16.2CA01A4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 462BA40005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:33:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iSyQ+7Cd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pxsRHkSO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FCcK40Sn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BCAcbEhk;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756287233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fVZaXP/TeNtrh+VE3kaBnAAVm4n90lFNvJY20uKoJY=;
	b=lZUCf3zZd6/7FS++yn6XTCDsXDBzChD+QgxUY5CaQ8zsUqwix1e6BTJxcGYxUpNZLxOpTT
	7K3c0ZZXpDggkfipO55i+dZa9EGVAcyPYt+nmJYVal+GUPtOjdJOhIOXTvd6EtCq8BRq8e
	eS7FaGajwAjycj/0klAlUE6NP8NaMXc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iSyQ+7Cd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pxsRHkSO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FCcK40Sn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BCAcbEhk;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756287233; a=rsa-sha256;
	cv=none;
	b=71RzO3K7eREaSgJD+zsJdwcRORPDmVQWPXYxoZMQIH/VJFw4/uV4z4vakCMU2fXkMIJDUf
	of9Jc/f6zmjtTWDJgd+RlIvmmZoNMh4p9Ka2s5RyH7815N2L2/2RuXsh1pd3MZC3Jfq737
	JClUpz0VEsBP2vhOfThG3EnRAHAMyjQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DE30922649;
	Wed, 27 Aug 2025 09:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756287232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8fVZaXP/TeNtrh+VE3kaBnAAVm4n90lFNvJY20uKoJY=;
	b=iSyQ+7Cdqni/XH2lpRabOhnb5AqpxFzX7THfBq3To9orSpOg6woLrEDY7q2w/5QabZrTvC
	wn0+nZ0f8wALIFbggBbjCDgsiXPePrAlaWbZPaXPOsTqNpXiyEXnlVXlrA38j7oaxdHJ+M
	Rd5gS4K3RGwxR51SdEXNMAK9ZPsuYDk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756287232;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8fVZaXP/TeNtrh+VE3kaBnAAVm4n90lFNvJY20uKoJY=;
	b=pxsRHkSOMXZY8eRr0aOlNINMhvTxx09UwsRfvPhAy7KhE5NQraeXj6uqHGw1gsBE7u4R+s
	CJ7M05dSjGODC/Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756287231; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8fVZaXP/TeNtrh+VE3kaBnAAVm4n90lFNvJY20uKoJY=;
	b=FCcK40Snw3z9kPnNWmpPGwvEqmziuQBabwqPPi4iRfy0CGZqXlTe9PGGcve1859pSHztN2
	Fe2l7Rwo+4nuiQcdfT7a0DfVVgmtL1+B8rjF2ir70oVuS9q5TPFcR9AO3QdoPMNCmcf1iF
	xJcB+TCPieP68ynABNvcbS2hvsLG2YE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756287231;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8fVZaXP/TeNtrh+VE3kaBnAAVm4n90lFNvJY20uKoJY=;
	b=BCAcbEhkklJIjK6OIOWgTUbZ8k1yUJwcWvmI1J7JEPbiD4i8S03+OrKe1T3Y6WoeSxLzC2
	OoeaNk9TeQGH7+BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D009613867;
	Wed, 27 Aug 2025 09:33:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eVV2Mv/QrmjYFgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 27 Aug 2025 09:33:51 +0000
Message-ID: <3c8cb4fe-3f75-43d5-ace2-c112812cfcb0@suse.cz>
Date: Wed, 27 Aug 2025 11:33:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 1/2] mm/page_alloc: use xxx_pageblock_isolate() for
 better reading
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>
References: <20250827021121.13645-1-richard.weiyang@gmail.com>
 <20250827021121.13645-2-richard.weiyang@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250827021121.13645-2-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 462BA40005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 61k55x9bhtwdenf61tnqmxkuxiarbzpi
X-HE-Tag: 1756287233-321864
X-HE-Meta: U2FsdGVkX1+6C7mDuUkD787JZJeL+Vl0q0Dl1+u0amFSCVjkrL+VcV8jeFrUEpOYuxVSEfyIdKPBXUbux/+7ebUxjbGQYfKnNx8osEUsWkjMwdKkOD/adahquoX/KUcJCjdfjtkSO12E8WB2imiJ+xy9Msu8W2ZEyNImKrGhNJRAmLr/SbER2vwl2GzCs5NPwZnq8u2FZqYWsZ3XiKkgarrvltK+7joPcZwGFrZzjeM3vk7V8IVN0asNH+sro1KJnMpk69H7luCRapNC2iVYd3QApbsNuVCRZHqB8esDqy4qJ1D4i+ioagZLFNFZoqp0HrCA3daLy5VqMVJwFvPpbwil8w8IcJEzNi+m2lL5fXkwBOgcrVqBZLD5H7f2hS+YSYfwKo/HK74D8qOVzO+QJxO7dVv/Q/x4+9GAngBcaRAZ/JPGt+WeaLuhORK1V7mgPmr5IHYEI8ColQhc+OwMhRYEJ6bt+ILKvQru2MrIQW51DBoF4zvJcCAM8Ft8P7crNTqBcR6+Dc50DJW2Pk668qNOersPCGr1o5uGeJa61iVpIAxRAKXcwdnsOStZj86fF3KCEoaRtsbTCU7qdad7cUPCb9gFwpgB5md6Cqo+Jro1ieBjhQiC3fUeFbkPbEwePkK/WyJ4jWuhQ5xm3wB6lU903Zwwjp9NdaXO2Y45jtNGQ9bHOwDJTBp7DXUOf5/Za9mzchTXkNyd70fCxowvy33QQP+etd+9pYvkndJTVpItOpkWpv43ZjMmZqS1RbezwqorwXqZdi6ye2oxR2yGOqSHYgNApRq6ENtMfUAbqCKty95asXqwy1TkDdbSd+9ZFBVu4zjwLiobMJXw2RM/xZaI9445zejsZxfjCi4t5u5WcLhPXjZZnqHHgrlIZEFOXQpcxd/NBkk//ZZSvW2k3lYxyQ/Jxi2q0aU5/LKfjuOOOdtfGgGnt5sulClzKbAYLufFIYSCN3OgpJEfHyI
 6D8HFopm
 avmXRX1pjpzgvli1Zm2iXkhzLqVx5BsI2Mlt/1tUrJY8H75Dj+5zAVhVYArRZ/UnL00uXa5SqDwc72BJndGaiMe5wUd9MEJ8E23rizZnZWNGBgbTHDfZFUPnlHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/25 04:11, Wei Yang wrote:
> Since commit e904bce2d9d4 ("mm/page_isolation: make page isolation a
> standalone bit"), it provides dedicated helper to handle isolation.
> 
> Change to use these helpers to be better reading.
> 
> No functional change intended.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand <david@redhat.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/page_alloc.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index baead29b3e67..e534f31a6b39 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -538,8 +538,7 @@ static void set_pageblock_migratetype(struct page *page,
>  			"Use set_pageblock_isolate() for pageblock isolation");
>  		return;
>  	}
> -	VM_WARN_ONCE(get_pfnblock_bit(page, page_to_pfn(page),
> -				      PB_migrate_isolate),
> +	VM_WARN_ONCE(get_pageblock_isolate(page),
>  		     "Use clear_pageblock_isolate() to unisolate pageblock");
>  	/* MIGRATETYPE_AND_ISO_MASK clears PB_migrate_isolate if it is set */
>  #endif
> @@ -2058,9 +2057,9 @@ static unsigned long find_large_buddy(unsigned long start_pfn)
>  static inline void toggle_pageblock_isolate(struct page *page, bool isolate)
>  {
>  	if (isolate)
> -		set_pfnblock_bit(page, page_to_pfn(page), PB_migrate_isolate);
> +		set_pageblock_isolate(page);
>  	else
> -		clear_pfnblock_bit(page, page_to_pfn(page), PB_migrate_isolate);
> +		clear_pageblock_isolate(page);
>  }
>  
>  /**


