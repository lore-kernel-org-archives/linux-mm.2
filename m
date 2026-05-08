Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA594CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 19:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2B66B026D; Fri,  8 May 2026 15:48:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353BF6B026F; Fri,  8 May 2026 15:48:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 242EA6B0270; Fri,  8 May 2026 15:48:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 162FF6B026D
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:48:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A8DEF8784F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:48:52 +0000 (UTC)
X-FDA: 84745290504.02.D65BFAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C02BB40006
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:48:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y8Xlwg1M;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778269730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V7RPAZ55+1HPXnkQqhWUwubd8fFGbQq1GFHTttgVJ/0=;
	b=v/cU0KDygGfkkL//Vdpl6JN/ezqDbNbOXIvR/n11SVXl3E0LyCE8eddVRwmzOQexaM2RTd
	WFGlTPuPKZJiLWmgWybIVfjT5hTHaPS5vjX/xLaZjc8kB1MPWsaTKCQ0762SR+2bDfM9Gb
	nANbjZwS+eFMmxzPQEy48JJ4ceNf0Ks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778269730; a=rsa-sha256;
	cv=none;
	b=uYizo0z5Qf3J9imWbSI8jWT/qMR1dern5ICktExu2hPRKq0MoU9f/+iOufln3hg7HUi6mU
	fkkhCXJ8TOe9GzK4FWkWCdQdPUTAjYsnLjHQayJBzFowc5TEVX472dy7fDQgzwEwt+npvL
	RsESwEMQ3vq2SXVjx0pBuKHR/jGqd1A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y8Xlwg1M;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E3A5F40D88;
	Fri,  8 May 2026 19:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FA8C2BCC9;
	Fri,  8 May 2026 19:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778269729;
	bh=eYKckCjevTstTvfrX409clPwx64nbPPG5Iv4w90sO24=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Y8Xlwg1M5NBl3ESdd/zuPKj3Io4Qy5OR1/OaZ5JgOTwdmrQ2W++lf2PGn06s9Ku8N
	 OuusMpNZ7UCztd2ObE7/NaIswGjp8z0Iqek54mOrIHMgI5LrcEZltYmdDaJ0DBogmD
	 EZnLWeLbj6e06Ufr8zAwMldPbQz1pAM+NZvXkvYTrzDJ3kIOuF1u9/YGgMehLGBuKO
	 q93wDHvhpeLRIcFAxviHGopB++NR+zKGOIaSm8rU9G66jUhxQ/6fOKWi9EZLQbHyeL
	 GXyETCvEmxSIPZKQl/sjPkqs4lw76lszD0M8w07G9cCmlmVHwpHZ7ITuk6mdmdt974
	 goooAcSszAkzA==
Message-ID: <e9e61132-902a-445f-9c4c-4d405d164e70@kernel.org>
Date: Fri, 8 May 2026 21:48:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-7-ziy@nvidia.com>
 <B1D68BA2-11D2-4053-B715-F7704ED784DA@nvidia.com>
 <3BFC4C26-1C97-40AA-B4B7-7472B9768565@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3BFC4C26-1C97-40AA-B4B7-7472B9768565@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C02BB40006
X-Stat-Signature: atdfw749hxceifor1xq9yin6dtiq85w3
X-Rspam-User: 
X-HE-Tag: 1778269730-73872
X-HE-Meta: U2FsdGVkX19vGYcp+AbJziLqJxhBOwbPod0t9e4bqCJT5Mcla1DSvvCZsQO73k8/TqrnMtblslfAf5JnNG1hMx2TBkRVVER2fF9fp1OHQI+hSbSxPhasLGAW02D263cwNjF5136v72P0QZgNGGb6YIi9Y9yeMuamjWLzQQW7FBkpsuwWWHxPDG+uIptslhJFBsbJ/opqc4Z+GN9/CaEVkjKTHOJTQVQ34jHsakBog+p3nScGXolw1kZMMbPOsNlocHKWIcynxflrwriUVmC53nEjqj+3HnYMQXPUtQ2wKZPT2wcn7/b3HgWCzFKbgpq0ESQdk1y83O6Z2DDziYZ+ns4BY8upH6lRnTpJyWCBNcF1F9ww//TNGglXdEPSCahZhu5XkIYCSs4G9TF+niTJAkOGaIU0R6rokEyndLeiAMlwX291DJ7KuyxXLwuhhZXzPEJjHRTHxkXuliWjjZQOrTmQ0dYF7vpDeUdHpHcWheN90hmwk40LS9Cq8EVQsAO3nG929/8E/M+eY7Xncf2DTu07CNeA7bSkrM3PoEFc78raKtxxxTs8rb6CxISJKmKbbmRi4uj6aYkbs4BJdq5Rfy4hRBOvUcke3U9OpcQcUDDqquL8QsHflTo8f5sJRmpv5FIKkes6a0lcav39Bwus4H8cLLvodPxns2VIgErOvRNnUySMRu3wq51PEgEBXgi+ZMpQN3UBqd1gy6Tz3msZv1qj1SGjyM2D24lBSZmqhXOM37rO/mGuR18VN4NGTFyNGOdyElEbjYy6+s1iLSESfTk8gD66uCmRXTUDCpWNxHAuzrbiIkl/GhEMi/M8ron5w2vtsJjUx9zzvirkDETu+KuHnSkV5ygVeQ1cbzJ6Mf6TR59tHDGLxQnayejtVc747j7sqQrkWBgeTmiwqxW4TiL8iCvuiU30S1ENNGgjZ0ibDBosPJylrKV51TjyNzyVPPiqaFUtlzjrFy1sj/e
 /mgT12ji
 uzDiCBYcrT+hlhcjPU0tdik1GnL+V44bvczWwJ+kdMNNYAg1I3blJxbfCl3D6hK1CDK8TTt5hR+1l80xa0nyts3hH7fJoqfMVVRrTxwKlBA+mOGdZhovxHUGydlalVcuACUkj+qYdIlQeX6tlY9rUSNTqre9OdqvXB4mJGk/iR8kw8BgfqKAoZqkXuMRaTSw9RB5hYfoOnsLLog0OSz5t+aLprzDBOYUe2edmkoxaW8iK8kNlKMMBj8apZj8qOl79c94+O40RH4QHj49iS1wKLUa8BhgrAUbSLyPHt9gn9BB5d9a1HAEpQUjAHmbQp540mjb28jlk5B064+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/30/26 17:27, Zi Yan wrote:
> On 30 Apr 2026, at 11:16, Zi Yan wrote:
> 
>> On 29 Apr 2026, at 11:35, Zi Yan wrote:
>>
>>> Change the requirement to a file system with large folio support and the
>>> supported order needs to include PMD_ORDER.
>>>
>>> Also add tests of opening a file with read write permission and populating
>>> folios with writes. Reuse the XFS image from split_huge_page_test.
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>  tools/testing/selftests/mm/khugepaged.c   | 131 +++++++++++++++-------
>>>  tools/testing/selftests/mm/run_vmtests.sh |  12 +-
>>>  2 files changed, 102 insertions(+), 41 deletions(-)
>>>
> 
> <snip>
> 
>>> -static void file_fault(void *p, unsigned long start, unsigned long end)
>>> +static void file_fault_common(void *p, unsigned long start, unsigned long end,
>>> +		int madv_ops)
>>>  {
>>> -	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ)) {
>>> +	if (madvise(((char *)p) + start, end - start, madv_ops)) {
>>>  		perror("madvise(MADV_POPULATE_READ");
>>
>> Sashiko:
>> Since madv_ops can now be either MADV_POPULATE_READ or MADV_POPULATE_WRITE,
>> will this hardcoded error message be misleading if the write fault path
>> fails?
>>
>> Answer:
>> Will send a fixup.
> 
> 
> This is the fixup:
> From 76e301cf5198f33d07492e224ec627b94902b4b6 Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Thu, 30 Apr 2026 11:22:30 -0400
> Subject: [PATCH] selftests/mm: khugepaged perror fixup.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 80b913185c643..97b8fcc490c76 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -445,7 +445,10 @@ static void file_fault_common(void *p, unsigned long start, unsigned long end,
>  		int madv_ops)
>  {
>  	if (madvise(((char *)p) + start, end - start, madv_ops)) {
> -		perror("madvise(MADV_POPULATE_READ");
> +		if (madv_ops == MADV_POPULATE_READ)
> +			perror("madvise(MADV_POPULATE_READ");
> +		else if (madv_ops == MADV_POPULATE_WRITE)
> +			perror("madvise(MADV_POPULATE_WRITE");

Alternatively, just "madvise()". It's unexpected to fail in any case and would
have to be debugged ...

-- 
Cheers,

David

