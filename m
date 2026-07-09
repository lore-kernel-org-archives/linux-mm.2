Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA1D9C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 03:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAF906B0088; Wed,  8 Jul 2026 23:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B608C6B008A; Wed,  8 Jul 2026 23:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76A66B008C; Wed,  8 Jul 2026 23:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 850596B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:54:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C5ED71C35F3
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:54:42 +0000 (UTC)
X-FDA: 84967871604.02.EA015F3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id DE14340006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:54:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="j/6D3+61";
	spf=pass (imf11.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783569281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/kFo0LXAtC4ZYBkOBpdMk3LdAwU8gmkH7ivVRb24faM=;
	b=afL63p867Iz8kA5Mpgd2faXE2EG1MaKwuIMGt+wPR6HeS0218pK0JEtzOGpaBSWA60khHF
	pHYaxlePWogAOvKsJljRVKrvq99deKTYUTPL45gulrjncIMAC6YbEgxmnR74pn1Ee4LVIb
	1W7n1+EENaqdvl+ox1+YIAgcRikhuhw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="j/6D3+61";
	spf=pass (imf11.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783569281;
	b=yDJ+KJSMmzyqfgq4orE8KpnL+ckkmjWL8N1VFDB+crEjcXcRceegHhiBWcoxnsgx/LIfno
	1MGqfsPUyrmcPu3j1S7aewGUumHYGNI6rHYz0S77/BTbxy55X5lyGIJiclNgbfG9Yf+dff
	gMVGSomOTXJfEQ6Ec/6SgbIApVlqwzQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4D9A24C0;
	Wed,  8 Jul 2026 20:54:35 -0700 (PDT)
Received: from [10.174.42.219] (unknown [10.174.42.219])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 66C873F66F;
	Wed,  8 Jul 2026 20:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783569280; bh=oTE+JmeWYAD6NTmOgsILFCPn/1/522DGucnZMSxv3kc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j/6D3+61mRTAgBHjRLQiEBVYJCJVN2AYi+leI7Q5sTXNeLuZx5nbKeuJjl+W5gDgG
	 WH9IbSjXDru6k/s9cTfnyQe7WbQ/BUUTW4mg9NPsugJD6Yp803s3T0cA3wqw8RFq2l
	 ZpIlasq3T6FoGqEfC4DNBtAbclLB5MKgEWUzOef4=
Message-ID: <cee0745b-0845-4def-9f8e-e944b1974998@arm.com>
Date: Thu, 9 Jul 2026 09:24:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm: Standardize printing for pgtable entries
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org
Cc: andriy.shevchenko@linux.intel.com, usama.arif@linux.dev,
 hughd@google.com, willy@infradead.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260708032824.969752-1-anshuman.khandual@arm.com>
 <25cde246-540f-4ab4-b541-0b7313c57954@arm.com>
 <76f24730-46de-4583-9189-ff7ba28c741d@kernel.org>
 <724a080a-bd4b-4fab-a890-c6a97ebff77f@arm.com>
 <1e6be746-44b5-485c-8adb-4a21b7a3d03d@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <1e6be746-44b5-485c-8adb-4a21b7a3d03d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DE14340006
X-Stat-Signature: uhgjp33hizybbthbrzyoekdz9jnu13be
X-HE-Tag: 1783569280-658103
X-HE-Meta: U2FsdGVkX18BJkhNd1xZbPWAtXEWllpZHZnfVSWLap7Mps7hofROWTPCXXvJgZ/kHO0GzF4+Y0st7iv9pCOoK75VnpnOr1cDeUJF+TNU5v0wjrzjzBktgpgwuYH1l3li/jl6a+bGBJ6M7TFRZyjO6fab85UHP0V8mXdiirZWrd7afpXvpi4TmPpbOidXhLOI2IzXG2GI5HUdf87xDON0g2THgDapyf7hV/VgEp6VSvV3XsLBQ7lB0STzJUDXY9qrNZ6jqNWMOOMFgJzisZtTMYkZdxdFS8YPJc8kONeWc5tFozesI7rmO4sdKu58xh9eEDcEFTv3G6V67bB3nUqE8w18bvKdP7oUG/Dkxk5qcELfue84bWnsVxtScWZjIsSTzI1lTueVGCTSQgSTu+E0Q4eVteW3IdtogNrzwf3hHIGc2Qz0gFKkuohfKPDcLrc9HAH6hNOxcmU4hno6OQ7yTQlSm06Uh1zHsuPlU+AiZ8mkICzAf1if5x4u3nfLZDGvP3CIIp6GhbyOrr2vOS585zcHR8NWmeep/5tLmQ9kdbeNlOxCfY10acbDG1pIzdQq9zoKEiSToSbXCIV+qn4mMi7fjuDb2kWcQWAoCew4eEdxKj3WMl+jtTiV51sIKY9y8Tm+86jkR9m8kcrDJUnkZ3oPn/ijh79tfhIg2djvjL2Eyd65ZEPySTQLlUj2YIMKI9bpRkuv1FJdsBy/z0ePY1k+fsWfr8VQIteCM18JxeQLW6DZPCRAyQmZGUx1dFSHDbtuDWlwGLGZoRaF3akUhWwffWWhJ0fRMk+yRD7TR9F/92tRoIJ/oK0PXtPuQAE/lA7j2aJBQiUvPwImCEft+Zb8EQ+NCbABrrumfgkiGZGjaTdpw3o6xkLY+gFOmWqoqGysfGxxb5cdYdWOLqxYzZOAdYmzGAPfELOuYlsDO+B6oPJtqcerwa7rRlXg6/1KOcsWYntmrCg/8Zqj2wU
 Bk3QC5Ai
 zZjYsdbvn8D6W9MbgPLeUpfFx+19VOlEkqHD59EI8Y5ssvsO51Lo2tV/aFOH0PPkWHEsF+u4MXTpgo5cizcIgMtyPI29tbffkBG++2hGO1hETPRX6lVH1ibir9J8sQymLl2iSzL1169E3YKlVQHfhkC6P/ZlLzr7HUlzGMwz40P61CNFjbp5sRXxRDsrCc0iTybMD1Q9CbTmTiIh6ZwtGNwyVIYK1LVcWvUUcR5WSAmrMoC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/07/26 6:28 PM, David Hildenbrand (Arm) wrote:
> On 7/8/26 14:43, Ryan Roberts wrote:
>> On 08/07/2026 12:27, David Hildenbrand (Arm) wrote:
>>> On 7/8/26 13:22, Ryan Roberts wrote:
>>>>
>>>> Not sure if it's worth doing something like this?:
>>>>
>>>> #define PTVAL_STR_MAX						\
>>>> 	(MAX(MAX(MAX(MAX(sizeof(pteval_t), sizeof(pmdval_t)), 	\
>>>> 	    	     sizeof(pudval_t)), 			\
>>>> 		 sizeof(p4dval_t)), 				\
>>>>     	     sizeof(pgdval_t)) + 1)
>>>>
>>>> Would probably save stack space for 32bit arches?
>>>
>>> Do we really care about that? This is about a corner cases error reporting right
>>> now.
>>
>> Fair enough, it just seemed like an obvious and simple (very minor) improvement.
>>
>>>
>>>>
>>>>
>>>> I think arm64 code also does pte printing, which you also need to fix up for
>>>> D128 support. Perhaps this could be moved to a header for reuse?
>>>
>>> We could do that as a second step, right?
>>
>> Sure, but why churn it twice? Anyway, no strong opinion, you're the boss :)
> 
> I'd say, if we're going to reuse this code for the arm64 pieces as well, we'd
> best send it along the arm64 pieces, and figure out where to place it for
> arm64's use right away.
> 
> If we'll defer the arm64 changes, I'd also defer deciding where we'd be moving
> it to.

Sounds better to have this printing problem taken care in generic
MM first as this change looks self contained. Subsequently rebase
D128 series as required.

