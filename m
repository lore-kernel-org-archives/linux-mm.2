Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69057C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 17:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699196B007B; Mon, 27 Jul 2026 13:52:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6701A6B008A; Mon, 27 Jul 2026 13:52:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5608A6B008C; Mon, 27 Jul 2026 13:52:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1811B6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:52:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A71DAA0678
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:51:59 +0000 (UTC)
X-FDA: 85035299958.24.523A720
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D32594000F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:51:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cc2sRPHT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785174717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wecGDCQXBjfCFMVnfqOxk3k+NVRMuAsFJ4l2NNvx0O8=;
	b=1Aodza1jaO1dBXuqDNOi34tYck4OExedPAbzSnaa3ujcuG2pg/+txbUtAz3OwWvrcLum4W
	CoplwfAWPJfRYo5fYi/OBuZfqtRgiHD8PUVXtXiDLs2NN+TiV1uTQmaEjb7l0hK0Fc2+RL
	kXmOPy2TdmGNL6KQVeQg3B8bVPH/BtI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cc2sRPHT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785174718;
	b=EVASocbHwwDkRCECOMSmeN8WwYQA94WQBXW1k3dBoh5kKdqDuzAvXNGTkoRRHUQrPOxeP+
	QgvrhPlEHIMgaq6PbMCjnBWzlrs73xUgoLPYzeQWnfJXajmxhxfDnEt5k8MLdM516nNOWI
	AE4qiw/eiJEC/ao9CB8HGWdbwWqA5q4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 111DE40BFD;
	Mon, 27 Jul 2026 17:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1A61F000E9;
	Mon, 27 Jul 2026 17:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785174716;
	bh=wecGDCQXBjfCFMVnfqOxk3k+NVRMuAsFJ4l2NNvx0O8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Cc2sRPHTNXRKzGfG9+3lp8wXF5VfmQAbLvCtDFgO7WpDM/Ph4ZVspG7WZSLuTW5mO
	 oIavaX2DUBRi0sOwaqrXIxXVV2FTANcHPH5c4rvBzi/VKXxeGfVzjU9ntMocVoo55z
	 5osiAAN5sXkqDS4BMwJhl7VoMsjMqkYi2LjG/vyDzNkH5LifcLUsLpbJVf8XUPdwPU
	 2OYLyDfJC14kGHuyWgWoaLQIDWraUs+CEtPark3lvbUqYjgf/G1yzwuSlNlMDI1LZ4
	 gBrVYx1l8UpUVimIH0JsbkORqRswgnN2nM4RXGeuCu9HlEJNVdNgJPCeEelfNtbHzT
	 ZcDPebXtqS3fQ==
Message-ID: <d68d3f5e-7983-4e91-b3a5-a5c8dd5a01e8@kernel.org>
Date: Mon, 27 Jul 2026 19:51:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] tools/mm: add a standalone GUP microbenchmark
To: Dev Jain <dev.jain@arm.com>, Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Jonathan Corbet <corbet@lwn.net>,
 Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260716123226.197736-1-sarthak.sharma@arm.com>
 <20260716123226.197736-5-sarthak.sharma@arm.com>
 <4665dd2d-99c8-492c-a4cf-b72028317d0b@kernel.org>
 <75259d8f-1cdf-43e4-9fa4-9a2954435a96@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <75259d8f-1cdf-43e4-9fa4-9a2954435a96@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D32594000F
X-Rspam-User: 
X-Stat-Signature: yazd7ushqmtopuusuzygpg6714cxrcjg
X-HE-Tag: 1785174717-874746
X-HE-Meta: U2FsdGVkX1/Xwwzq5IGSI/2KK4InB4NZGzAQHjCvpr8FkX3idyU7hgfj0o1nLrjijyGjkBkR2BOf2cEJ6ygAENYKF4XIZDwfKwpDhU7EdPL5FmIXFJ4FUjcG+EuELkLeBbbRLbP89NN+PRb74tRRVsXSzG2DX1rbw7PJAHC5eUQyr3FAHvBLt4/yPpE9t0vq/LI7YDvPTm3GBV4EwpyOADVNJltfnfNObOVj1SPfX1XjmhOsUJgt0efqCG71AFiPCg7FeFyKP5KZt6fOToAAeFBGFsCsXFtmXikhox965cfzQzRkrLzMnDo4V7MCkOyYEDlzeu1t5Pt+JCfEqym1Usy5XsY3V9sV/O+lWDuGjEteV7ckdLn7t6gt0/x3NLvEnpy4mu3vYQ2FurHOodn73oMofrkoXNG2DX0jltB1SOJIm2mWA5g9u0q5p9qv2AfxGeLgYyUKFG9FEbQmxGty7Dh0DTkpzZ6E7YmeldHzsPbnKARjh1knxEcC6JCUChp7ksReK8QwANNUNp0+UfP90OzcCisrGZUn7ytDhBltcf92cenevIsgRSCtJ7OHa1XmRSzYOfE9lIckhLNYSgoIyM0eiCFp3q/5Kguv3bY02uZ2yFvK7YfJC45IFrgVkyL4ASjNhyHJThMH+n8lGxjU7wohMg8Jhf5hYHBQyhwQ1U8L4jTgbfiOa/CzWU/O4csceepv/J0sxA/IRpDP9v+QrmQfSb60H0XS5/eJmAlmTlZCweODshLBq37hf37/zBJ96B+GRdc6EqdT5Q6XdAd0VbuMOsyxcLvhIspcqaaXd2K7gspgWigkUZpuxPCAnFcNnX9LTStfu3nkDkHp6FQ0ruFaJPFB5w9aU7ymkLhmzVd2OPMH2ja6QW6lgqp1S+XHy7MfR8QIUtlJLybb6OWX6Qm4i0GT+nZTG8koBqs3sertzx0PyUBs3REZc+iUrq8ftwPOnnaFrOqX9y2kxZf
 +yrUQrCt
 PP25+41hLRxOqiIyyAIo6TYjoIJPG/V106NMtsXA1i6KLGtQ8QouYGdozl7QuOXLoJz2XuaiK2x7DTPIGaMhdna9u3hQ3pvOswk/ILtGC8yh/LVIp37eu9Mah0Iy+L5RkmzPVXDox49sh6Tew64vyWDd7TuAOKtWJPYKoQmE8/OvOL5Rbd/NMEVMHr92dbx0Bhf+TzGriHjBEf0UrWdZVj995RdeXCu5DHbtlslPYqpact2vV2i0L3BYjXr9FQmrABIys3xpZqew8l29nFjSwx3aSiTeGhHTw6cay5vobBy1JXNcU6MtI7C6ky6oXo5yYHC6QDIo7q6yQdjJZDQod0J8g9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/24/26 14:05, Dev Jain wrote:
> 
> 
> On 21/07/26 7:22 pm, David Hildenbrand (Arm) wrote:
>> On 7/16/26 14:32, Sarthak Sharma wrote:
>>> Add a command-line tool for benchmarking get_user_pages fast-path
>>> (GUP_FAST), pin_user_pages fast-path (PIN_FAST), and pin_user_pages
>>> longterm (PIN_LONGTERM) via the CONFIG_GUP_TEST debugfs interface.
>>>
>>> When invoked without arguments, gup_bench runs the benchmark subset
>>> of configurations covered by run_gup_matrix() in run_vmtests.sh: all
>>
>> To we really need the matrix in there? The matrix was good for selftests, but
>> not when using it as a benchmarking tool, no?
>>
>>> three GUP commands across read/write, private/shared mappings, and a
>>> range of page counts, with THP on/off for regular mappings and hugetlb
>>> for huge page mappings. Restore HugeTLB settings after each hugetlb
>>> benchmark run. Validate numeric command-line arguments instead of
>>> relying on atoi().
>>>
>>> This tool is a mix of reused and new logic. The mapping/setup path comes
>>> from selftests/mm/gup_test.c, while the default benchmark matrix matches
>>> the benchmark subset of run_gup_matrix() in run_vmtests.sh. The standalone
>>> CLI and tools/mm integration are added here and the HugeTLB setup code is
>>> shared via tools/lib/mm.
>>>
>>> Add gup_bench to BUILD_TARGETS and INSTALL_TARGETS in tools/mm/Makefile,
>>> link it against the shared tools/lib/mm hugepage helpers, and ignore the
>>> resulting binary in tools/mm/.gitignore. While here, also add the
>>> missing thp_swap_allocator_test entry to .gitignore.
>>>
>>> Add tools/mm/gup_bench.c to the GUP entry in MAINTAINERS.
>>>
>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>>> ---
>>>  MAINTAINERS          |   1 +
>>>  tools/mm/.gitignore  |   2 +
>>>  tools/mm/Makefile    |  10 +-
>>>  tools/mm/gup_bench.c | 482 +++++++++++++++++++++++++++++++++++++++++++
>>>  4 files changed, 492 insertions(+), 3 deletions(-)
>>>  create mode 100644 tools/mm/gup_bench.c
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 26b06d80ab45..7d121dee9f0f 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -17024,6 +17024,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>>  F:	mm/gup.c
>>>  F:	mm/gup_test.c
>>>  F:	mm/gup_test.h
>>> +F:	tools/mm/gup_bench.c
>>>  F:	tools/testing/selftests/mm/gup_longterm.c
>>>  F:	tools/testing/selftests/mm/gup_test.c
>>>  
>>> diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
>>> index 922879f93fc8..154d740be02e 100644
>>> --- a/tools/mm/.gitignore
>>> +++ b/tools/mm/.gitignore
>>> @@ -2,3 +2,5 @@
>>>  slabinfo
>>>  page-types
>>>  page_owner_sort
>>> +thp_swap_allocator_test
>>
>> ^ Does that belong into this patch?
>>
>>> +gup_bench
>>
>> I wonder if it makes sense to "git mv" the existing tool (only slightly fixing
>> header inclusion to make it compile), essentially removing the old benchmark.
>>
>> So it would be
>>
>> 1) Move tools, fixing up includes and removing the gup testing logic+matrix to
>>    make it compile
> 
> I like your idea, it would reduce churn. But is it okay that there will be an
> intermediate state in which gup_test is not there? Wouldn't we call this a
> "regression"?

I don't really see why that as a problem as we are effectively removing the old
test and replacing it by a new one?

In fact, while at it, we can just call the new test "gup.c", as the "_test" is
superfluous.

-- 
Cheers,

David

