Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95416D29FF7
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:45:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFF0F6B00AA; Wed, 14 Jan 2026 06:45:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA6826B00AD; Wed, 14 Jan 2026 06:45:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B87D46B00B0; Wed, 14 Jan 2026 06:45:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A84C46B00AA
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:45:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 484FBC1E07
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:45:14 +0000 (UTC)
X-FDA: 84330388548.16.461C137
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 752BC120009
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:45:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ejpaKTF5;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768391112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yp9a3y4/h6px0U1RjjV3jtmjs+Vrjzb6+Z1gw0QWCa4=;
	b=AYwojPMkm8Zx3TGt/CPvTbJE6m61GOJqOFw7LIGXjqrDeczfcZrOaKecjOGsNbNNdnYrLm
	ARIOakw2HA+4D/cxM/c10ChFwkqkE87GfGt9IhOnOUl9UACMhiMS35aStY/XzvQjHMGlwr
	bAwvuSqJdQDinMmqSIWCdLiUUR8K+kw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ejpaKTF5;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768391112; a=rsa-sha256;
	cv=none;
	b=gLMIOq0zaOg8j9tAw1fgzjM1B5f1wwHOl0U7YJ/62/lY802TuX/LPLVgfsASzRd/vXCkl7
	iMhV/ODEcJBy6ry81Ezs7QwCiO6oRRvsN06Tdz6M42yrCz2ma7BD21Eyh9MKMynhVGYvkH
	sr2iLEHPgAwA/pwW032M8X/fTxbjGKc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91EB7403E6;
	Wed, 14 Jan 2026 11:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E690BC4CEF7;
	Wed, 14 Jan 2026 11:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768391111;
	bh=OrkNiaxNUEu+lGj1Ua8ZuRHfos8ojsstbEnAo8mK6/I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ejpaKTF5wj0l8tNe6/yfGNMxd878p1XFtDJ9x1utClV4HTWdxti/26WUHAdwPPUM+
	 Zzovit40ew+28TEQZkoYW316dLtJgDQXvEUK7O1JkDjH7QUegR6yyX/YG3bteQCSI1
	 /nv4xRUB9zDtBM+Itz3o2p2E8C2A8jKxijpf7uoq4oQkgzYwdJa7zDL6Y7W46Ebpny
	 KeBbKSOP/wG/tqBVxfPi7TuF+U6KY12IyHSOEq9MwvfVaWwpsVDEsUfJNByFjqFSID
	 TI/+/bbvVfANMVMze7O3Iy80+umsf8ij7dpGhMHrURtp6jRBh49SIrQr2/B2T/t0vs
	 ezHntEzghbAVA==
Message-ID: <40381c7e-3f0a-4459-a287-4e098e9a4b13@kernel.org>
Date: Wed, 14 Jan 2026 12:45:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v4 4/6] mm: add folio_is_lazyfree helper
To: Lance Yang <lance.yang@linux.dev>, Vernon Yang <vernon2gm@gmail.com>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, akpm@linux-foundation.org,
 dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-5-yanglincheng@kylinos.cn>
 <78a2ab5b-5ece-4d82-a229-594fb8672108@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <78a2ab5b-5ece-4d82-a229-594fb8672108@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 752BC120009
X-Stat-Signature: zo6z7fud9fni8e4te33pjdjk6u8t4uao
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768391112-186131
X-HE-Meta: U2FsdGVkX1+kwix832jAG21kAur8C7Q+4snFUsKwC0ADcJ9EC/mtidKc9f4zWzlyzNpfIlbjgBhasyLOw4n5q8d1aF7RHBQ7zM5SyScAoilo2859BHTbC5acQPh4/MyX4wTc0ZH/HP0Q4xYGuOKefySu4E4Ckg+R1irRgS9m8UcQvwlNreIQrmLnPwkZAnXIohyYNzGfIwPPEYv98qj50B1R8at6c/WFaOnttJTu5a9KwkXyCIki9d3pYL4GkFu3GH9xxat1WBOJYlc+qytHFbIpMPz1dLHvjWr9fE22AWLDIuF8KnAb08sr5Us8DY7OUFKHZ+8nBE24kabcYYwNtItmaUuamhhsD1M6OStKMv5p55VOeXBr+3+ZnIZZbQYsic99m7th+feG+3/rVXHBQUw3y7utULRIR1VbhgxxPdl5Toned23jzz1Ts0Eb0wtFa/tuIBx9cMMSSxBb0xxsNAmE6ImBgql1Wnwl/6X18D6cxG4XNKDEusR7eEMy4nPp/GDpAvmiNyfh/KeCB1RTix4c8gpLEBWVb/oR5Ivg2QMb6/NvqoSVaVx7E55tncmJ5XinJUedcFNFy7oA89EqKySai9bqPk2CCezoxavsHnimEy8CTQyRyzmo/CqnzmvMdt760fql5YgM7zPitHgxcpaIeiKbmCOrDQSjLBglh2nzQq/qvs9ZUdiOdhohZuputL4m/IG7tLoHXzLLBb9n3N6msDZgKtgvHdefXEXtPSGJWE/fB8+iOjweyjHamtQfP8totcD9FMJD7cERSqEyzUBOa4LckyNPXKJAxWy1WdNV2iObL4pFfFh72yQdhW9dAZKcGNl+zz0Iga4kxUsKZLZTuRh/5X4NNYtRgtRymWaocUd0Q2reBCle/yfRWgqw5W/EvXXtZ4BDEuMqXmVpq1Wnos9yXenD2M1tGJx6QrQZ7PDBSKI4QZYJnFD6jhUs8HvOZvzvqRdTG78oHuV
 YWDREH1Z
 z+cX3DyWKF7yKON7Cyn5sLRp/bNo7OszZz9P/au1j9wPkTGO8EdxkI7khPR4llDUX3itJgjerSC3TF7h6FRnDF81pBfAnjlyskPUzaAxFyv7+YeWPmADmeqckRHEJDBOARjxK9rqQipNxkhdexDmo02M82hpnqVKZqBhwSav/vdXYZdPIjzSFHo6NWaqBRLxmzcjamr17X9XOiv931lxsd/kNTbQntN81IXDBnR/8Z1272ge0sxneFLGNdURSaRSwCRUJc5EVxH7i2v1Hiz0Kt/uTGaqOxjf6Uq1K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/11/26 14:41, Lance Yang wrote:
> 
> 
> On 2026/1/11 20:19, Vernon Yang wrote:
>> Add folio_is_lazyfree() function to identify lazy-free folios to improve
>> code readability.
>>
>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>> ---
>>    include/linux/mm_inline.h | 5 +++++
>>    mm/rmap.c                 | 2 +-
>>    mm/vmscan.c               | 5 ++---
>>    3 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
>> index fa2d6ba811b5..65a4ae52d915 100644
>> --- a/include/linux/mm_inline.h
>> +++ b/include/linux/mm_inline.h
>> @@ -35,6 +35,11 @@ static inline int page_is_file_lru(struct page *page)
>>    	return folio_is_file_lru(page_folio(page));
>>    }
>>    
>> +static inline int folio_is_lazyfree(const struct folio *folio)
>> +{
> 
> It's 2026, could we use bool instead of int?
> 
> Yeah, I see folio_is_file_lru() uses int but that's legacy ...

Right, and why not call the function folio_test_lazyfree() and move it 
to page-flags.h?

No strong opinion, just a thought.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

