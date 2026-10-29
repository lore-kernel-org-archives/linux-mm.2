Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F56606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 15:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kPqVAAGG
Received: by kanga.kvack.org (Postfix)
	id 362C46B05D1; Thu, 29 Oct 2026 11:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33B566B05D3; Thu, 29 Oct 2026 11:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251D36B05D4; Thu, 29 Oct 2026 11:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E66336B05D1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:47:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 547E11C3BF3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:47:39 +0000 (UTC)
X-FDA: 85376093838.30.50FA483
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 90B12C000D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:47:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kPqVAAGG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793288857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HsTZsAbnOjm+7kjd0LiVGLSB693ohnd2liVr1NWALdI=;
	b=VhUuQQceqITYOnLcoD91/z7eAXpKyjIqDlB8xZugImyMqbJWiyL0LCuLoS2BpXykMVCZLV
	UfVwjN87mCMgKlRYqzsWKUJ/S6OCdOIjEE/PO1ss8qva0aPD4qF+g2jE3ZVAw6q13+ZNqZ
	rNDihISfmFi9SK7EzBaP29NO5REuuOQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kPqVAAGG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793288857;
	b=LtcoYRlV9d2gbbAQvf8CI9LzyGq+76viTJJAgRTy0n55BTOn7kw6aaLYH+lNCYqFhp2nxE
	JSdp/IF99qJ1Husszf74xAE5gv0WeSxGGbmexLy8CABNDN2PhtwtUNihEy/NLdk8cRVBUA
	wZ++D+KdxcZ5zttpvEUB44dT708i0Qg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 182B8600E4;
	Thu, 29 Oct 2026 15:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E841F01816;
	Thu, 29 Oct 2026 15:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793288856;
	bh=HsTZsAbnOjm+7kjd0LiVGLSB693ohnd2liVr1NWALdI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kPqVAAGGkIKCU4DgEa4KGASh5IaaZBYjqWTq8XXVIa2i/LXmgfr65nhEbZis9yLma
	 pi+jmXTUv47DsPxG5kbv5ThaOO4ZlLdxrHX4IIntOTMKGQKCLEi1KT0KsW2aaKbMYN
	 quxGwRm73ICAydKIZdyG6Yc/+WaA/T+MIXJEHERZhRSuAoMfziKFFnXtz3aTxIx6ME
	 +AiXyBIDGlPd9SDiEiZs7Bschwl+ETBiEqz07BqCgYemmJVBOvU/LKGFSQ7cS28PJa
	 kqALZQQJqId41hzON38xxvnBKlUS99Ty6/F5oGkcxqbh6ctiRNeSYjhXC+IyjeNF20
	 JW6QoFxOEj8/w==
Message-ID: <3c141e6f-dd1d-4e48-bb9b-a94c0554d947@kernel.org>
Date: Thu, 29 Oct 2026 16:37:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/sparse: simplify the vmemmap alignment check
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20261029134521.62146-1-kaitao.cheng@linux.dev>
 <auNbTHXp4o_Dqww4@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auNbTHXp4o_Dqww4@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 90B12C000D
X-Rspam-User: 
X-Stat-Signature: m7e6ya58muqnw3ohs7f5y1ii639f4qzh
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793288857-953794
X-HE-Meta: U2FsdGVkX19G8jgwo4e80iecDs2gouXdqeKurXTWHvK5Ua4BidOYp11xMwUeT3+MpI4i9Bncm5JWARM+GrK7KUFJlllBzNKRGec1SBQU8SIABRvhxZ3waYGfcVjlGTo4hdEiuPmNARR3HE8YUNLUfbM+eRVrcAIaMzLMHkzdY67Sflweu52LPsA1AyLuty0qXEnpAVdiuT0ep1O1JVsdi4hXxaAYBUCF16U24VxkuA17sbfb/4RjmPsd72R4Xjv4J/oCpjHIPxPU3NKFPuir2FKk1YAhhjkl7Xx0Hk4j70z9TqiJ4flksD9FAW56K4tjXM6C5YOcd1Kh8NxIwPyPb1mH+CJDz2BdAqFohgPa0lNwfrp03Us/xMNfjT2+PTmEnyx84HQB9oyjxXEq8cMaIBQ55UL2re9+IJT1ZWGab/S6KuIcyb2xEppm6WnuYK5kJ09nw5xrOy5ij8KnRnYIpF0tFPT54KCnVxjqgzGHbWDtWiQNhhTUBExrax+dsv2c0T5BGi32MFfCacrY19yKK33m5D0gq7mma/N2dY4xnK0bJT7CIzSUWDvz6Df6hqSVsjjh5PMsp70Zfb9iHgVMLRmKm+pfivmAiJIeFJ9WHdkHANmkknGQ/SrzpUyLqt3hTypZf04TzxHQ5vl5SxUpKPHCGljauBAUAFugQ2HKKYJZnfwckOM0khnvbiFo97+vPNgHN30r+jOm0GQqn0q8gKDxr6WBdoAk6P7xFkzaNcy2Uup5zMp9VgNxZ2bMTb8NE+ey6F6N8kfAPDe4EX06xs+TmAFq587oAn1lFF5H4wqOcG8NZ2RpnutoT8nsMUCAKnsueN2vAEqj2BnUU1pZf/7L+rHSlZyi4yJe5a0UPLxQLHz3ShYxmvGlSZa11jJmNLOZo8caawrTGNSzmfhu5o+MIulPj44ZbF24qXGv6g8tgDEcue6r2mX+ytxtYKbgDdjBox5I/simqfChVQM
 DlyjatZR
 AU0/NCrGqRVKKdW9VN5mrP9QJEf62EWuG9eeRexblUZU5VkY1JOQaaCdL19oF9E0hZWANLoJgSKCHB28vqdme0FxfofuS6kj/mW8n/KoV0FEmGhQs3aaAct+jU0AA4TtSRIYGDBdo29m4TKm4xGXLgpzUk9aLRMco+blT7YjyhVgC3R4TemmRPMKErSBUYDGn6M2GzNrvL5m5pitVlOvM+tgye4jEsqcO2vhL/Qzja8mLhjApUAA49T3eFbFMrb2fTOjr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 15:44, Kiryl Shutsemau wrote:
> On Thu, Oct 29, 2026 at 09:45:21PM +0800, Kaitao Cheng wrote:
>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>
>> sparse_init() is called only once during boot, and the vmemmap alignment
>> check is outside any loop, so VM_WARN_ON_ONCE() provides no benefit over
>> VM_WARN_ON() here.
> 
> Okay, that's true. But who cares. __init section will be freed anyway.
> I don't see downside in current code.
> 
>> Use VM_WARN_ON() and fold compound_info_has_mask() into its condition,
>> preserving short-circuit evaluation.
> 
> Why? It only got harder to read, no?

This would be fine as part of some bigger rework, but standalone this cleanup is
not very attractive :)

-- 
Cheers,

David

