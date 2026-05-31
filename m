Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1576CD6E57
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 17:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB1CE6B0162; Sun, 31 May 2026 13:23:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62B76B0163; Sun, 31 May 2026 13:23:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D518A6B0164; Sun, 31 May 2026 13:23:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C1CE06B0162
	for <linux-mm@kvack.org>; Sun, 31 May 2026 13:23:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5622AC207A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 17:23:21 +0000 (UTC)
X-FDA: 84828386202.30.668034D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 79F57A0002
	for <linux-mm@kvack.org>; Sun, 31 May 2026 17:23:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ca1RH1W0;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780248199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vWAGQnAYKVkZZw1sMg+oHC1jQ2+XzJrS7x/6sJVGKqo=;
	b=4nJ3Zc1Qlgbqln1c/Ga2vU2ukNQ4gw6zgViM/b0ocAJINa9NdMyBu+iaTliw5pQzuZUZE2
	ACDgeTeu0IgcjrehmpL64gEvOCIjLMGnRZ/dpTO11U2SKbcOoE1K+KFw6019COvht/f80V
	gzlql/rCNTzsql4ihdve8CqFjWSH/DE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ca1RH1W0;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780248199; a=rsa-sha256;
	cv=none;
	b=NDkIi6iVb40OYD805B5/j4IoHNVvMX5xKGYlXEOjjR+FoB53g79rKDwgTOolKCz5i1wG+h
	rsLU5ZUB0Ym7iAi/ewm24T2S0K0Q+6H28Tvv/st5pCZsqBgAQ0QKPlJ0GG/p1mdVjhCkby
	/PG8IMYIA0ffofa5ntm4HdpGJayjyks=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CB6944575;
	Sun, 31 May 2026 17:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F5A1F00893;
	Sun, 31 May 2026 17:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780248198;
	bh=vWAGQnAYKVkZZw1sMg+oHC1jQ2+XzJrS7x/6sJVGKqo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ca1RH1W0Wxcxr79uTWniFeOlpGbGmfBugPJpJujCYKxlu04bclqmTJNhVHw7h9pB+
	 DHKoSm+5eMNlOfS/0BdWb3P+ZgZyY7Es1yP2ZxfcQowENGTcH+IJ+/WvGTev9AG9vv
	 nvKrx7mP71hNGkog1Z7MvYiva/eGZgzKNAw/+od3xHgc+OgsMy/YQKRDCpvZ4tPdEh
	 kbQk2nqBMU4DR7RCFpG+etqh6ctPzXYT+SgqxXXPFhe5PAmzvFoACgwHTJXe35yd+w
	 7/gykJ+mTXClHcsc1jWX034jHy6qVDn62L0Go4TnuMhshnHWcFGfFEAvzg7wXxZZMb
	 0w2gujZezj1ZQ==
Message-ID: <e3b8216a-f5d3-4697-8573-459cfc4aea47@kernel.org>
Date: Sun, 31 May 2026 19:23:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
References: <2026042303-vendor-outright-b9d2@gregkh>
 <20260424063817.552a894d4b5bfa4de40792fa@linux-foundation.org>
 <d17188e3-a710-44a5-984e-689a127d4c1d@kernel.org>
 <20260526173550.927ba4ba517e9af5a6d2c6bf@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526173550.927ba4ba517e9af5a6d2c6bf@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 61cpqog9ig1eh4oxasamutjdk4qndsbp
X-Rspam-User: 
X-Rspamd-Queue-Id: 79F57A0002
X-HE-Tag: 1780248199-23783
X-HE-Meta: U2FsdGVkX1+TG60pPuNfQ84tg2s1C5KcpqfNYy2vXEN5HS1ljP4NZpGsQkF2apAFS+9CBKWmTKXqQncDmQRV8N0JEvHeRSo2nyFOsyeUbK0yDxplhYw8gDk/6+NT1Whjaqc9M4JPYZ8It9sRuR7rTNP0tZSR/9CbrDqfsC9MRAbFG2IIMlXCPvXjX5iLIdRKcBkqwqZqMdn4rloRnj9eycYuK11g1Nq3TANdPokckLMk3wGw4z+mCoryHkHsokAGuJcWNTRn/qzpGhgh3uIgextvCaeNN5CgYRbmwnBZGEanht+2gAxb95/cLu9BXuFUfHJ1k9H1Xcq576cHzLdszxECdTmHdmA2/R9ZnFK+Ues64C4QA83ZGqP+97H4lZoaUxeZ3NRUM4HrlyLUOBCYsXzouwudz7zW7uZ4fmi9tlhrUy9B1leVP0YJaWHnQ0MgTy9iflpDovKzwMlssK2Y3VM6AjpG/TfVrX1Xkq/kzUUNpOjqiK8uHhIcsIOYDRgQxz0QCs4/pIhnY8A2XRL0Cahnty0dcgZaDy14MAblp37/jAyAVx54O5OYis62CtE66VUyWB829M1Rbap3T31/Ti2ebwYcvzsoleKt1bVX1WY95wzKXpnbRxowd0EsTHsvakJ18kOxan95jWqwnfKhF/hzaLKdxPClJpCR0+bsL788gME0KZtJL0I9Udx+D8wpkXGMyOYtk2xQPLKJJ1aeKbwiwJxCOB9IiCF4pAdy8p3ilSJmyPvEdJc/vBwkQlUj5TetVJS2f+f7/8mVnc7rq5JZOgdHieZopf4pBKNtXNm7xZs0At3VnBxlFA6ZEOMQfKQFg6ItXyj2ZxVCdAGorx1qlTu9hOe8AEMcTDfX8ITayV2hmuQtIjk0FJwmSMKRgDc00a5UyUYq+zt1+b9sdQgcAfyOnFuaXtrQNePLU9Qfb8nsaM/tgkyAooLZUK9k1Nj9n2qMs0ZZfheNbSv
 yT7nFoi2
 +1FWTsFG/oBO0KmwDUxPvJiG5n7CIq8hjt8+Z7L4nY7PyKbXI9UYlwHFQKcluwGKm+nhH6rtlJ4id8Es6NFl1sOXoxc85omLKGKofQN3t+f3lYX5J1I2yzxpMOyCewLcFiVLHD2YGjQ2M4+/UBS8lWXxfQFHIbIXw4JkksTwKIPAinQItWeusUVCbp3rCFJIs5of2TXEvPaGldmFH/FeVyuVjkHMyFXQULLOYcJ24GjHu2iWpVizyxTot6+zcz1eT8UJvo4Lz4FORZ652Fd3hgkRW6FZ/3fih+tmZbKQNvgiViq+WuPumTKg+SMKztzXad3JNED8J9piPy1lezjOcfyhf49XwPlZb08s6psHhsAUwWZJazeiFsi3coz73vfu3SC+gKPZxbyoNiADyXjO/SGh81hmvNXH4Qtxrt9z0VJC0rmxCqZ6WVN7IcG5n2Zj7ZLQhyLTn4Zr6yaCdcCAlzGE+vscHAzdPR+wCpnYkNxKFnBqKOch6wfcyMqZJMrD3ICo9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/27/26 02:35, Andrew Morton wrote:
> On Fri, 24 Apr 2026 16:19:32 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> On 4/24/26 15:38, Andrew Morton wrote:
>>>
>>>
>>> Battle of the bots?
>>> 	https://sashiko.dev/#/patchset/2026042303-vendor-outright-b9d2@gregkh
>>
>> It references the
>>
>> 	if (pages && !(flags & FOLL_PIN))
>> 		flags |= FOLL_GET;
>>
>> I'm not sure if there is actual NOMMU code that triggers it. For example,
>> uprobes uses that pattern, but I suspect that that's not a thing on NOMMU.
>>
>>
>> Probably best to just squash:
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index ad9ded39609c..44bd28cf6e00 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -1988,6 +1988,9 @@ static long __get_user_pages_locked(struct mm_struct *mm,
>> unsigned long start,
>>         if (!nr_pages)
>>                 return 0;
>>
>> +       if (pages && !(foll_flags & FOLL_PIN))
>> +               foll_flags |= FOLL_GET;
>> +
>>         /*
>>          * The internal caller expects GUP to manage the lock internally and the
>>          * lock must be released when this returns.
> 
> Nothing happened.
> 
> Should we proceed with this as-is?

No let's squash what I provided. Probably a resend would be best. If greg is too
busy I can give it a try tomorrow.

-- 
Cheers,

David

