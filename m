Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E232FED3C3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8A816B00A9; Fri, 24 Apr 2026 08:49:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B616E6B00AE; Fri, 24 Apr 2026 08:49:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51056B00AF; Fri, 24 Apr 2026 08:49:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93D166B00A9
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:49:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5369A160157
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:49:40 +0000 (UTC)
X-FDA: 84693430920.09.537E54E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 61999A0008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:49:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KL16CErn;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777034978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yvyTD+qKBSRCChFZN/37m4WXkztG1rfCaFiDIMtki3A=;
	b=tZqZWS/lgusnhoOW+o0NL7ayg4CfZMHStGuPbzjQV0Dg0Q8myQ92MP0yNaeP3XbyCVZ7QK
	8NZMswPKTFIyEJHvTdG73M5+p7NwmVP9d78XnUesqILwpj/JYDia0RO5d3PHpY6R4yxUfY
	+ATAhUDLYOQlwCUiPZaXCcvyEJerauQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777034978; a=rsa-sha256;
	cv=none;
	b=G54d1qTjSCCKw4NTWviTOb2rMFjJ23/3jcKb+n5wt9GnXD/vsj+iIxj4uDZpUWNWhwuyeF
	ziuDoZLxOHpe1BKTt06H6bk5TLQTvh6IsEx6tC5DgPZ/CCh3lJM7/lWp4adwtYwRpNoWiG
	rvneluBlz67e6P+mJa7PqpMDkkFbcYs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KL16CErn;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5253F43E31;
	Fri, 24 Apr 2026 12:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E26C19425;
	Fri, 24 Apr 2026 12:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777034977;
	bh=fSL4TNgwdCxWuu9T8lZ6Cc8udwY/lN78cLiN9F0b0uM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KL16CErnkSvpcXhiyMROU+zxGXf6meNaDIK6qj485o7EmGxtDwExqz7mkDoEZXRUR
	 0ydIwTGx1BJpwp8LVL0NCBg9iKTDH8P/QH51U+9ZdwzNxu1rdPlM+oFdZ7/hgbpvN6
	 D9Bwt9sdhNul3yVMj+b8LkUwqDEUz9iT2nz3mb77A+Ff0cxI8M+fqcIn4FJKsL5Agn
	 NMtrjLy3L1AJZUmgB1DphEyhdYcEenRI6nWLvkYPYBmskWZ0vnVdhis2lmUBIgHHQo
	 vrqYuQQ5KrD3my2JeVHbgxtSYRv6b/nWMoY2Z2FIMij/nCyXMGpgjgF/1L3fKfkllX
	 RD6NjAMr0+N0Q==
Message-ID: <a6b2b7f2-1bbd-4c6a-866c-da473ed2e112@kernel.org>
Date: Fri, 24 Apr 2026 14:49:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
References: <2026042303-vendor-outright-b9d2@gregkh>
 <a20913f0-476c-4f56-a044-9802bb1c7f1a@kernel.org>
 <2026042431-charter-ranging-597c@gregkh>
 <e9c5cf89-fa4c-4b83-ae70-9d3c72542ee9@kernel.org>
 <20260424054143.087847e1617a84df8b501313@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260424054143.087847e1617a84df8b501313@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xyc8nid4fi3xnqdpd69ybnaaem4one33
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 61999A0008
X-Rspam-User: 
X-HE-Tag: 1777034978-218451
X-HE-Meta: U2FsdGVkX1+r/jfnUHOfuw8jC146c5w321GukNws1oC0u+BW63UeFMNnPTRpUg2yd2fSX8R6qSCB04VxBTZ1wtr+lKWczOgoQPM9HVTeIsU4aRC0rbS9l1qaxfL1XZKuyFIIKtx/ma+/RAw0j+sHEFQtJFTS3a8RcutN02+THhw8CCE4UVwEn30yHn5aCf/R8/A8Na60OwuVYr58Ti3l5iLAI+/sBVdNZApjzEEIdgg72l4srtoh0Ib4JEHil6JnkZ6FQua01m173KoEBFDaYq5BK/EyHzOnVQhzZwcM/Rilp2XsxbwFs4/qWEZX8xohvGL67friRy6Xe+uUydy+p9jnDx69k4MTFQnqZuW0hNM4Qs4SrE8bFciu9Unz3Ec9ZB+BkRbVJmzQNqGGwNkgrfiYlzFgLeUAFs+OGlDBTelYP+MzPNOtxSnQXnPXZMz8Yg2PSnrzmacSzGxMDnqHupr9X830Fu41Ml5uf6Su9FyIVk/nr3hWUmatmxhqt1dkX5Mhj1kOh6xm+eR3Lv3UPjGAvMt8UFEB/UIYSy8coPlnF6Nwazs2dSfHeqX/VF4H5KHITbVISoXlYMpk+Gl/CH3cdoc/Av8zydPO24bKWw43Xs1ovCtCTxhkF5VjcIT5czvd/4VgXELT/IxKGbIT+tL9HFVQ5SICznqkrsXCBeovRnqdAjybh7wOF4tg1V/YnI4Zre3ndlLUmgMs/f17Eqv3okwdJOAFlo88LPaHbUYSeY/UexAJ06tl6bqMV0VyfCuCx9CEFS65BICobjFRVwscmEENRm9sVNgEvOVBeE9K26twFV9O68+48xW0w+hPlM6ZbDeRqadj9XoSVFlW6n+x//zSB7sEL5EULYwRrimnZdkkaEB6KFH352JZ8oyfDFVJloyZ9WgT3wmBTuhcGZbsHy0UBvmNierxxrdGbHanYbJfp0Um7V/c5wJ+2V4mg8tcpwrwS47HW745OuO
 2jTxM4UB
 zbmK82ph0W3P1xtOMAd+5En74cdbIOHOsRkRMNygy1p7CGu2T1exfiCZBMGhtygInFAcX3hXLhP9bmbRUKzvP9pwbGGRXt/RkKNvNWB08t4v2CXUKcscYJndM6aebJ+tVYOdGETG1vt6OxbxdWeIuDmn2DKXdYX7MS1tJEUMfPT8khejhJoDQfNAHiTHqHUZKkPtj4JqCBZjnm8q79joyB6blSY/MS4Tdw6Dej+iCUzOJ9GNqYX/xILHGGtUkakXZV5WTMayI8TjuTmjU50VRbkp5VsFh2yDrmux7XWod+vDCjNOATMwIIsmeq275rynsxJf1il6OBrZODXM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 14:41, Andrew Morton wrote:
> On Fri, 24 Apr 2026 14:16:21 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>>>
>>> True, sorry, I guess people can "assist", I should have added that.
>>>
>>> If Andrew's tools automatically pick this up then:
>>>
>>> Assisted-by: David Hildenbrand <david@kernel.org>
>>
>> I think we usually use Suggested-by:, but really I was just joking :)
> 
> I thought you were gkh_clanker_t1000

That was supposed to be our tiny little secret. ;)

-- 
Cheers,

David

