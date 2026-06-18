Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E70FCD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE8726B00BB; Thu, 18 Jun 2026 05:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0356B00BC; Thu, 18 Jun 2026 05:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6026B00BD; Thu, 18 Jun 2026 05:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6007D6B00BB
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:12:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12B76166843
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:06:53 +0000 (UTC)
X-FDA: 84892453506.27.63693AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 57EA3C000E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:06:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NTPXEK1c;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781773611;
	b=B27dnn5rzQsKhLpHzGfmImN+EIdgzYF0+YxFZwZHdDm5rAUa2XBj4VKpH31QIHci7qWzvZ
	VvYyil43xJ2JKT35l8rbF97Uj4Ay/klGr+CSvMjBRi+8E8AwSEsDg5j+I4uNqqUqXifN4E
	kRh8e/0LYiv9Z+mOdJbLlAA9pPti8II=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NTPXEK1c;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781773611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mm2lCLjyWnzab/19VrsoxJklGw/Bkp1asQyZBrJBDYI=;
	b=5B3pDxgm/RNSfMlTFm3Gjz///2EpIApIbtvAL6CgbisSJ7FZB5AmekmFWxp+jbWzLfy+HA
	o9sI/oIEtovbHxNRwbJ83mckA8d71GD4wBwE45/IA7+tabidQZIbXqu6QfZjI/vmxdDKB7
	50nTFXZYZa2TfRkfpOt2D5dmSdv9nhw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD7D06012A;
	Thu, 18 Jun 2026 09:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5DA1F000E9;
	Thu, 18 Jun 2026 09:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781773610;
	bh=Mm2lCLjyWnzab/19VrsoxJklGw/Bkp1asQyZBrJBDYI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NTPXEK1coiBSBjmD8O0cGT1hnThEAQZYPGEV+zyV64VPw9bhOyvwG0t08rqMvHgS1
	 hQgDCfY0v/Ut0fEGpJ4sHxd6BZlFt1H85YSkMAekx6uICbKOihbRkK/QfFtjS522lT
	 kyZbIy9TdWpui+Y6bme8aHFIdzK618zLzld/ejX2TLQnAHHseUvFC4JsCCR47qimU9
	 RLNvVIEAnLm/qBOlFOwOAxB9Yfc9TwYvA1VIVnChBhcG8ekVj5kaD1tte635ZpPIst
	 2Ae2tVr1+0AIguIFyPElLKq5yhzxWhaIH+iqim3Z0mVWYfuCdlV2mkqeCW4hPXl552
	 jW2MZWTphKC5Q==
Message-ID: <acca377c-a308-480c-9840-4edf1a94a3a0@kernel.org>
Date: Thu, 18 Jun 2026 11:06:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero
 folio read-only
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: dave.hansen@intel.com, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, hpa@zytor.com, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, yang@os.amperecomputing.com,
 jannh@google.com
References: <3b20ad2e-bb69-44be-bad3-5efeb169c573@kernel.org>
 <20260617141547.144275-1-xueyuan.chen21@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260617141547.144275-1-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 57EA3C000E
X-Stat-Signature: 3rbrfjxfpzcbfr9t7bsoj6iizho4g5m5
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781773611-859876
X-HE-Meta: U2FsdGVkX18JxdcWxlyGAck9wV0ViLVWYYGup5bmuVLm6wXu763xBH49oB+cPx1LTQlfZFwKy1sf3df6P1XiqMUtLVP2CfY3j2S/JBHFPiXK1Y2WZfmPEwTZbXxf5ur4NQk7XFixCrNnpNkFeEySH73faaSY301g0c8fNUhdKcUkzvWK/oIerH8GzmX7T+33EoD9LjGDv9R2Id31gJSqMd7YDB3BHURGFbki0rxzqdnGMYcqsmRA9Dwfq6MevyAIdQ84f6f9+b9n6YI/wn3HfPvQHzVyk/4xLZBOfeFndph9EP3iGOWc/EF/YtsPblLxfxcCRZdncyPDqEZmZqSgGo63UFiWNsDGFxKJ/HciW3kLJrHcYHchCfGl3x5Zt0872CPz/lGnv3iNiyG+ODxuhdCOxNf+/lfR8xOQWjaauloWC2IM2q5Yo8heRuTGUqS1Qzdv7a6cWAU2Qxu+a6TmbL+j55oVR0BCUomXURMXauvtlgrvh3FQtj34PdH+qMimdRhGgGk5b8becWQ78jzfvdffEYPDxIlSOUtW65+Ewakf3VAzIcZLhRMuVOgI1u1n5Ka+SpU9uZ7nKHrzGLdYV1ViNCIFA5KhBAjH44q2IKNN15mc+gEaHyCMIgmQqnlBAtAsK4HI7I/ldAn8YDLxA9kJTMNb01W4HOyldoC+IdFsJXF4kDI1IM5N7osdbpXos5envHFrqTjoYajJVqLAf5WXt2+cgGfZPKZCLLDlS8MjgCdiEBcTIdoEBhCFCWtFkiFQnnahn14Qz78A0Qs2bMdbSZLlMP6ebitYSB5TN48sADc4uW/TziZBVCaJlvAUvsSWvYK995qY8zI2PGO3/SK6+OJtSIT77IFGEqWTM6gMLsnnROEXc4+LKjPP1cbxdMFKFk1rlybX36jp84A2qce+GDQfTQ/+45i4Fx/qsF294GeE3spEL+ZfS2O/EiCVtQoc27ZJ1/xcthPF7TU
 s9FjOAGc
 CWSQS8V2h8vmtpyY6XOvPxEOhrAb0ssiRtUONuG9/pBlk+BW6ZCfBJSUhNv0dHmrhQSd3VeHatjdXvNfJMA0zv6GuE1MYGpJOD3wvDZ+Z71cR9oqvK/StJek84iGoda0jwWzicpbhwNZZdnBAMLd9qCTKmxjYCfZvHmXbVwby3tLDhi+0800NxpkZcE31n0rwflZaWpl78SODmyk/DEpH8Qb4NxL37oYtcXs4F8wqcSXVYuRL+AgxaHIXkN1erzbwlth3Q7eRetBlyPY6NHJD8B35DNyjedd+nqViAPSlx7R9dBjFb9e1/G8BMr6E42MUOpXw1PtPOb0pOnR1d+cGYf+nAU4AIgCumrckGnsvfTu1jwZUd8NVH/dv8Jzl5qcW8wfL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 16:15, Xueyuan Chen wrote:
> 
> On Wed, Jun 17, 2026 at 01:50:08PM +0200, David Hildenbrand (Arm) wrote:
> 
> Hi, David
> 
>> Yes, kerneldoc please.
> 
> Ack.
> 
>>
>> We're adjusting the directmap, remapping a r/w page to be r/o. I think we should
>> be very clear about which transition we expect+support.
>>
>> Also, I rather hate the "set_memory" naming scheme ... "set_direct_map" is
>> clearer. Anyhow ...
>>
>> Now we are throwing a "arch_make_pages_*" into the mix.
>>
>> Should it really contain the "arch"?
>> Should it really contain the "make" ?
>>
>> Why can't we just reuse set_memory_ro and pass address+nr_pages? (highmem check?
>> Could that be moved in there?)
>>
>> Or do we want a "change_direct_map_ro()" / "remap_direct_map_ro" interface?
>>
>>
> 
> How about naming it int set_direct_map_ro(struct page *page, unsigned nr)?

To distinguish it from "set_memory*" cruft, maybe best to use "remap" or
"adjust" instead.

-- 
Cheers,

David

