Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AAC110AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 21:41:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBC916B0005; Thu, 26 Mar 2026 17:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46A66B0089; Thu, 26 Mar 2026 17:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0DD06B008A; Thu, 26 Mar 2026 17:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BD86D6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:41:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8FE09BE0C3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:41:39 +0000 (UTC)
X-FDA: 84589536318.28.8862AB3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf13.hostedemail.com (Postfix) with ESMTP id DA96E20003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:41:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RNvw3ghs;
	spf=pass (imf13.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774561297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4LE4e78gsgkE8EYpJUa3F0beKgycV3+MjQ0A8QDP9rQ=;
	b=5K8zcfRt4rqoa6KAQKLCA0cGAeGV5wy6jMAQVwlHb2N1HAvqJsRhg8SV4b2rD3HsGoe7mb
	WE7unDInnR4+1DNT/TcRvNjN80MvhnkrHIPkztpep7P8rjjiuUDgg/VTjg008nGxc3WPd8
	SABHpYr6dg4JU6qpvUpJ/9ULrQWq4d4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RNvw3ghs;
	spf=pass (imf13.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774561297; a=rsa-sha256;
	cv=none;
	b=rlV6Jstg2R8mh69tFbINM5dVC0DsfapbKtm3wD/iQpYvZC68H8w3DR497e2hVGWOApwCjt
	dg9fImi82CjM/mF23UUo/AlIWi1HOPx+s/GiDEoPHuJk/G/N5iua3zJt+eoBY5bEhDEoFY
	IbrPOyJ1MgX+Y9Aeo0ltA4MlcL59kHU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774561297; x=1806097297;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=T0dtBj3s8LT0i/Bza0Vy9gcessZjN5wbfSYVN87qrFo=;
  b=RNvw3ghs1xh+jMhhcfOKNxP2l2l6zCaw4G+g2yvavZZykuOL7zxbnWwf
   siy3mjTOYJAPleqseiMuPeiAfYY1gVdluaKWQDiJJ7OscESMMA7dny9Qf
   6iMUBjfryhYnMwJn5/5YVDuzQqEDP81kbkkUuJpJ6KGPzZlfUsZaHsOtg
   64jKO07jy2MTV/AOaQezUjR3e+WrgEPS5YfaI0qDOkkpUesrRVUmupSwn
   R+aDeUvey9pxglbtm0yapsyfad41JlLPEosRy1CzyeWDx5ei20atu2hJv
   QI06YQP1ipD+wL+AMp0dKI79ljDWfMUDnf9NzoLNV4v0ZkyiiXrA0cgpA
   Q==;
X-CSE-ConnectionGUID: si4i27R5ShaQfarimOyQyQ==
X-CSE-MsgGUID: co/JI6xbQ6KL+cZJWzPt2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="78229763"
X-IronPort-AV: E=Sophos;i="6.23,142,1770624000"; 
   d="scan'208";a="78229763"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 14:41:35 -0700
X-CSE-ConnectionGUID: VnuhCQUDSWeA2r5M7vYhQA==
X-CSE-MsgGUID: kB3d1EHlSQiPEqxLWFmaRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,142,1770624000"; 
   d="scan'208";a="255619182"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.110.122]) ([10.125.110.122])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 14:41:32 -0700
Message-ID: <67c5b4a4-fdee-425c-8383-5c9c2f32227c@intel.com>
Date: Thu, 26 Mar 2026 14:41:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce
 socket-aware weighted interleave
To: Rakie Kim <rakie.kim@sk.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: akpm@linux-foundation.org, gourry@gourry.net, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, david@kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, dave@stgolabs.net,
 alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 dan.j.williams@intel.com, kernel_team@skhynix.com, honggyu.kim@sk.com,
 yunjeong.mun@sk.com, Keith Busch <kbusch@kernel.org>
References: <20260326085501.343-1-rakie.kim@sk.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260326085501.343-1-rakie.kim@sk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DA96E20003
X-Stat-Signature: sicdknwgw4ztzzw3stn6t7k5y1pfz77t
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774561296-384719
X-HE-Meta: U2FsdGVkX184hRu5aoQYzcsa/Bb1IFXn2lAcLj4VQO9iCBuGmnQG+P3xXwHrCypem0TUchipYA1Q9uxufifTUzlXET7MXYzq0HbAGF6nNjUEN62oAgDLA1pqrqKGYETS66R90opvLLT4X1fu2esu6ANLTM4xki3diPXH6uNY0tqhR4WDkS9f2a1aeRHsrAhN4jTR+DXlFIVW2Se89inJv8oGbYpC4us7pk9ML5qOXnG5F2KbmJZy4qLk9Y7/zh/ZIbZa5vJPzPq/zsZtYsa1+YJ2rTwGdZ7aXmoR40ISfOjrFJYehBpTkEYKVw8dRiQiiDuAzG4+vq5ONcgwfNQwYjbBEsFelacsf4dshlBTmvLbbxCU1j4MGajRBNJkii8iG8miNLNMrCbTRKDyBrarsM5PPHHajmxsxSP3gfMR/7t6lnPbGpZpBI34jwsvS8rufAzbhjAG3hnyYVf9a1F1iF2b+oNiZFf07X8MPN2JSc21aDuOncWrw48yo5zeAjnbbobwzqk7ZaFjO+bLEXAm/LbxeOUy/4siGoio5CmSLD0eHqaQavBNIplAlBU8rS5EG8EoTn/ozl12dJnTIbqBV5CcQddN/s3ZJCpuxFGJCYW6j+oOwp4I24M+MCatnEgsYYbogkJFTuWbcWgldqTEBoaz4IjNA9Kwk/yo1hj3wcWPw+Drt8nWaMQA5jXI0rCE0oZd/LiSPYiJRCbgF0pANwN4wxJe1pUPxN+6xXlZC7LNLDh3Smj8ddrMux3Q61pI573ZVIkXgp6nFtZiyUNlsnh0biAFdmeVZ4C+URIn7f5yP8qhkkpDgMxPjQ93Rc2iZ1CGhBwZxSD8HBD2tLSBe9wPwzSQGvpITt1XKKpZSvCyAr4wwak+k75k/Cx9Jq9kQ79jk0fN0om9CfVxGWXF9gl38uX7xQyZ2XgJWIQODdnkzpY52Bod1O6TfK3IrgpNQQWSKuj2tFdDrH5wQb0
 EKTqZ+ej
 jTSU8bigPoSOAsb34PtSXEgOVT3U/ibEmpV9r176rhhDTAKnTtoZPTPvOWK6bPwOP35UBEOy4V7qA0DnpsUqeur2paqvyQNYA9JWGWqQcvxFasCvnW4ECJ6T2W4cxe5MSQ4dhurl1Z7av9xaJvzRFj+bPFBPRjQOA6rBIRbu+iEROEzo0BjyXcS4JEAvFWM3tV8bHNcLnNGFbeKsOzYNWVoWK1sLf1hb1MGLuBpK2MG8QgdOLNhixJfL2ncQd2BF4SCl3BhXj41X0af1FDzBpdxQw7rLfd0Ig7Scsu+j3rVlA1ikYpzOfEzQjMcj2ORUOFhr1+KcfegiX4VOb3FVWZBNJyREeze3sSBOaDDFJJWzaALQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/26/26 1:54 AM, Rakie Kim wrote:
> On Wed, 25 Mar 2026 12:33:50 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:
>> On Tue, 24 Mar 2026 14:35:45 +0900
>> Rakie Kim <rakie.kim@sk.com> wrote:
>>
>>> On Fri, 20 Mar 2026 16:56:05 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:

<--snip-->

 
> Hello Jonathan,
> 
> Thank you for the deep insight into the HMAT parser code. As you
> mentioned, considering the current state where node 1 is still
> registered as the initiator in sysfs despite the flag being 0, it
> seems highly likely that the kernel parser logic is not handling
> this specific situation gracefully.
> 
>>
>>> Because both HMAT and sysfs are exposing abnormal values, it was
>>> impossible for me to determine the true socket connections for CXL
>>> using this data.
>>>
>>>>>
>>>>> Even though the distance map shows node2 is physically closer to
>>>>> Socket 0 and node3 to Socket 1, the HMAT incorrectly defines the
>>>>> routing path strictly through Socket 1. Because the HMAT alone made it
>>>>> difficult to determine the exact physical socket connections on these
>>>>> systems, I ended up using the current CXL driver-based approach.  
>>>>
>>>> Are the HMAT latencies and bandwidths all there?  Or are some missing
>>>> and you have to use SLIT (which generally is garbage for historical
>>>> reasons of tuning SLIT to particular OS behaviour).
>>>>   
>>>
>>> The HMAT latencies and bandwidths are present, but the values seem
>>> broken. Here is the latency table:
>>>
>>> Init->Target | node0 | node1 | node2 | node3
>>> node0        | 0x38B | 0x89F | 0x9C4 | 0x3AFC
>>> node1        | 0x89F | 0x38B | 0x3AFC| 0x4268
>>
>> Yeah. That would do it...  Looks like that final value is garbage.

Hi Rakie,
So I talked to the Intel BIOS folks and apparently for devices that are not hot-plugged (with memory ranges provided in SRAT), those HMAT values are the value for end to end and not just CPU to Gen Port. That's why they look so much bigger. So there are couple things we'll have to consider:
1. Make sure that Intel, AMD, and ARM HMATs are all created the same way and this is the agreed on way to do this. Hopefully someone from AMD and ARM vendors can comment. We all should get on the same page for the CXL kernel code to work properly.

2. Add code in the CXL driver to detect whether the range is in SRAT and then skip the end to end perf calculation if that is the case. 

DJ


<--snip-->


