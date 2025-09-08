Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C39BCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AD738E0010; Mon,  8 Sep 2025 05:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75DAE8E0001; Mon,  8 Sep 2025 05:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 673BE8E0010; Mon,  8 Sep 2025 05:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4EB238E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:28:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6BC613C056
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:28:06 +0000 (UTC)
X-FDA: 83865556572.22.1EA5162
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id D50FC40012
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:28:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YKK4rjvH;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757323685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9h4BcOvxOwjHrG9H029E2+yuGVDQtSI0hF0Jbh8AA8=;
	b=KGXXKNjqibor4wRnWuz+XRLZmeUxzuDoyNoOJUFBALmFgCEeLXHqJqtTcuUUJ01gLu7QTn
	/wvtXYobG9GTv8b2p0ev5ckNtg4DeBuLG+ustElYVhUyf9TBnSEW3RS/mlAZ7yiHkCsCe7
	tRL3ww+6pP/OI7cAoXSAzQx3zvF5jPU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YKK4rjvH;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757323685; a=rsa-sha256;
	cv=none;
	b=7nz3NorpovAWO0pDOgs1N0tYQE8qSzOMaioOQ+Fh009GMFgqtF7BChZ6bQcGjc0RQb7D6H
	/ndI7qsBnFJv+w6jBJDl22Q1Q+srln5D571oQpjh/qI4U6JPbrBkI2Mn/WmLRcVr3aT8DP
	pm6svtj74vIQUk0kSLP+aSUjP6TENg8=
Message-ID: <bae1831b-decf-46bd-a264-1cf3ccaa64a2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757323682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l9h4BcOvxOwjHrG9H029E2+yuGVDQtSI0hF0Jbh8AA8=;
	b=YKK4rjvHR8VZawK48xv2K7mntDx6rWV7+SqBIHraZETqNuF8fOfhd4Y2sdUoiQqY2YB+jk
	mNgxRaoD3QRENGOklPO0EtqdTQxLshJhKJCMQLZfOR+5Nm5xMK2QlD7dGJiIZlv6NAgbag
	s8hbCIzzfMwZpwZTUYQinBbGyesZdBE=
Date: Mon, 8 Sep 2025 17:27:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] mm: skip mlocked THPs that are underused early in
 deferred_split_scan()
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>
Cc: Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 usamaarif642@gmail.com, ziy@nvidia.com, akpm@linux-foundation.org
References: <20250908090741.61519-1-lance.yang@linux.dev>
 <73c8a52c-37c5-45f4-b76e-f15267412242@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <73c8a52c-37c5-45f4-b76e-f15267412242@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: j1sydjem4z4riiigbziqhw5yg6bmt1uc
X-Rspam-User: 
X-Rspamd-Queue-Id: D50FC40012
X-Rspamd-Server: rspam01
X-HE-Tag: 1757323684-242355
X-HE-Meta: U2FsdGVkX19J6AJ9H0Lzr4Z3S7jAIymlhSJ5lHmh9vv96c3w3bbSscfBRirBVjtWHflzPbVjgIbf+sO3OtVik/LJ1bEmev+m3DYNYoOXl3g4TJjEdzI3a0sKL7SwvsVcSNHiq19gq6l7Hi8rpRRWe+Wruk9+t/kNV/vqWLIhV9SeF0I72uVItSzOXyER09YSDXx2ihfz37Lg1T5k84Yn682OEcVW8O4amvuwr5Oo1DeziMlYBaEWdU9upVmE8BIv37s8FYqyDoac+5Syh8DktwksgWR9+t6M1pL7XCyOm0Nst/IgqU6iHTej7wMRoG4ABxaCE4bJMrp/i2eE/bM/5OlfSaRu2iBhEfxl6X4lPiDfGJ+sjXawSVox/NX6IrcmaxsfaT9LWf2fwaKZHG5B395vOg8h/EzRSz6GIa58gKUADOcQMMVf0Aw+l6I6BZplvdBUsrAHd/Miv3kIbLiKxYCut9NUUVnCCoAiry2Dfkr9lSSn6wJ1ooMT3cZL0g8ACUDwXkkB56yXP4gsLt5MEGnfhxbfnOM1C9/ov0i/edChIR+DkYkOvdetBR3LMapc3LWl7MBq9kHlQlWaXgpeM++aTqrecKUaOnyrQ96ptMfHm2kfk/mhggzFkGIAJM8Q7kzu/xqrf+Y/6bM0YP2tjtbGll3ixd943TDi5nbX1/PIt0CR6NoDGSLOeZqSEyPz0ubGtKociOgJXm2YFzbWy2A1K9tM+ShlOGQMtdguC4Ev8asPF/dA8cjp9uCz764wRoeLWIWbWd3p39MMgd+1nF9ZGyMZLuXENsvo/W9h8LIr/SNPKnv/JJv0wlLYz/cqZDDcphvlPke1cBPaz3eaNhQhaEm3S70Dh4FnZYLz2OUOSjVIeefFYNMWj9G/fO0N6hh/DICHPu0glVlQPGIr7Rfmo44Ooz3jvQjNvU+8/s3SC2sYE7chSuiXNKE+s3KjseuQAIJ70+3rPbR6edm
 RT5XqmB2
 ifqswL2pH7XhgDOpc2/7ZQgUJaybrE8mVOVsFLsOtleSZFeOL+gJ3fje38yExKtY1p9KWZjXInm023GQzKDcFzEHBjCF1+lblt9o6Di2ej5pbEjGDyTwDie+OA8RD1EEHt6sCsHuwJ3r7QJdXrSqtWr6RGtBUKy8M+ikTDcHoOICDytGeckaDbgNjo5jBKSXP3A10ZLQdWqSFk7fzIyi0PBykqFgEqWD3iqWyWAfuEU3d/c+LZ1baimraJIszQ1Pw+pCoXuVHXLnUkff7SDltmpzBmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/8 17:12, David Hildenbrand wrote:
> On 08.09.25 11:07, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> When we stumble over a fully-mapped mlocked THP in the deferred shrinker,
>> it does not make sense to try to detect whether it is underused, because
>> try_to_map_unused_to_zeropage(), called while splitting the folio, 
>> will not
>> actually replace any zeroed pages by the shared zeropage.
>>
>> Splitting the folio in that case does not make any sense, so let's not 
>> even
>> scan to check if the folio is underused.
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
> 
> Feel free to drop that, I only tweaked you description :)

Well, I'd actually prefer to keep it. Thanks for setting me straight on
try_to_map_unused_to_zeropage() ;p


> 
> Acked-by: David Hildenbrand <david@redhat.com>

Cheers,
Lance


