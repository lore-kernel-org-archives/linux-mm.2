Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65562C982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82F156B0092; Fri, 18 Sep 2026 08:04:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0396B0093; Fri, 18 Sep 2026 08:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CE236B0095; Fri, 18 Sep 2026 08:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47CE76B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:04:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76FCAA478C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:04:28 +0000 (UTC)
X-FDA: 85226750616.05.183A1E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8CEC114000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:04:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JDpOapUC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789733066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p+cr/MjUTgohr00sGyu9QvyQa5Bo46JesYoZtj8PYHg=;
	b=R6KJgvigbuSesv6AOWu3PbW5ZfhEigdJXX1FLxfQOeIcgdr/ew/DUMpCU+U0S0+Wl4YhzG
	WxCJwc9+aEr1gUfJcQu2q1i/tvNa10LorOpfGxTjjlWY2kJKpUAZ4SQznu+vzKvnzcPopy
	GhfyBgolRbetfyqdKYt+6GRduVfcRfY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789733066;
	b=G/3bG2A8Qdorc6QSe1mlvrCdZuFbxSgl0w3M0eiKwz3D2pmc+LhoRqBFAeOashnfDHrbRI
	AANl5DdBTacYigJIlgUMoyeTcQWdpxOmxUHaOuSK/f2ZmlHlV/YKurYNrEuWvYEUenx6bx
	9hBfelQnbsKmCgVDbHLi/SwEx34Uqb4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JDpOapUC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BA0943D43;
	Fri, 18 Sep 2026 12:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA181F000FF;
	Fri, 18 Sep 2026 12:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789733065;
	bh=p+cr/MjUTgohr00sGyu9QvyQa5Bo46JesYoZtj8PYHg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JDpOapUC4lyxBS7OBzBbsX9la9jZguLY/7ZDWpQtqhskKwpWnVzhzdoiJGu8eL1ta
	 QA3C8nrU0b3TsjiwKgTRsd08MPw8MxrMkmv+y9KmWqMEhKBXsTg3q0gjKJUTOBvZ8C
	 rCM9nR/xfFdSAiMwGVWSv4bEiZtlBB1TUOqrtlO/r/1tzyF6dGpIYC91xK/soePw0d
	 umZ2SvIKxdiozcutJrZpumH+VoipWMw8+oDMUBOvm5hEyAb+NAWcJtgODx0n2+Sthy
	 CMero+r74dQcFLS0Q5KowSCFVVQGW3/t5RAhIRgNXJN+zvmISjxX0RaliIBx7hefCH
	 0m1uc6nZv4BVw==
Message-ID: <c57d9d3d-c007-4cf0-be9a-321e6ae62aae@kernel.org>
Date: Fri, 18 Sep 2026 13:09:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/huge_memory: simplify pgtable deposit detection
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260917161359.9ba88d2bcab42db8111130e1@linux-foundation.org>
 <20260918031905.92493-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260918031905.92493-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8CEC114000B
X-Stat-Signature: 3c44u81ebp43bmzcjsh6au5gp36qpzkm
X-HE-Tag: 1789733066-782309
X-HE-Meta: U2FsdGVkX18gppAnbSYG+zVP4R8YBZ1yWnNePuhA2Ektywk+oZ+PEa6f3QcQintI9uZ4uOcVUA6lFPB7N/MboS6R5QoR8dbgSjha9fvSkTpoa6H1VQ9C73mPT2987bRhBmdBLafjFkszkP1KQ2gqQdcy8OQOcLYCXNVOvXgQrSTycmJjHMS3YtDzVwDVaNLcrni6I9d8mA7XueWIiPFsI4nw/Fu3MDudAbft3ZSp67vRZttlLTElGY7vqWh5fE3scjcu/dLYmU+BN6wzI+P3+8uoBJ/RABuYmbaJNHiLLq0tiOVLK8I+rflkM/S2x0Xa3k9twyFcIsfPLYslK8Fv8i5Cm1SA8u7S7tAuWtVt+YNkhLhooC4Z62P0v+7ZmEMU+dIE+OqE3uLb1SluFs+z/p1yZwaau8O1zQxV7XJNQXBXlefU4Mt040higt+Lsbz0bl7FdNA2ekRvEIygFD5FSi/Nb3vu7dwafoZtZQWzi+CA6lEMrSPd+Z/lhVIUIxoKqg+V7IccdiFg/YJZBv+S2uPvJSQfB2RCiRz859rfYyshpAAKizqwHiRZWeW/RukzzbWvQWg00awaDB9V765aVhLWmahx3zF3ydDib0gOT5rd0jvMVjY2BAOf/12ETK5UFvUtwzbfR6InCFDuhk4TMjdVFK0+AhAD49pLNUb4D7/HcNtjwda/Fy2A2fOn5lEiFh+GtAPXBqKzny+jyE/G7tMWFZKLQbXfjoZ+DCXFQo1B3l1NDImQs1d2HBaNo15l/YkYLTbnn/76+Sd5yQKhg2Gr66Da+fGTb8IzfYeUrs+qQsR32nVEoabLxPKTi5v+0pS50QSHadhE9fSD2cs7/DUCBMkwKUiOE3VATgnaXSeElOumo+jSj1t/kiKVs/mOV0ovEErqGGNGrrbUnGb4WUbMJ5w4SiXqPtSll9mG9+4EYiqqZJxT0CVb77VWmSMaFkpA9eUJaxBAqVwsQIS
 TKndK4MU
 938pfS6CFZydAuwwrXJOLyJpzXkoDabFliqcjsQnSnmvwmHwTnEhD1KWR9NbWm9kfya8AQAQN6PpkE39DhhWvajhFKIge8lwmJ+mnmChLK3pDRRFaEDYfXugBzpN26MyRIvVs5nYwg6W+IvremfImcTqq8T40NVTBdjq/V09VRsiB8U5q3JKsN9i/pQtViQP/Kb2091bwFohk12KlOKRBJwxXtPI1bmz4kYelFeAhJlz4mlP73/xXWy2ip2qp3G2LYOhZ9B8Vs565alJGHfemHdbT4a3D5h9ZlX4C70w30zw5IlZ9Kf7CMsPzEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 05:19, Lance Yang wrote:
> 
> On Thu, Sep 17, 2026 at 04:13:59PM -0700, Andrew Morton wrote:
>> On Thu, 17 Sep 2026 13:40:15 +0800 Lance Yang <lance.yang@linux.dev> wrote:
>>
>>> Whether a PMD has a deposited PTE page table only depends on whether the
>>> architecture requires deposits or the VMA is anonymous.
>>>
>>> Implement this rule directly in vma_has_deposited_pgtable(), avoiding
>>> mistaking a non-anonymous raw PFN PMD for one with a deposit and attempting
>>> to withdraw a page table that was never deposited.
>>
>> A large part of my life is asking $LLM "what are the userspace-visible
>> runtime effects of this bug".  Because NOBODY EVER TELLS ME!!!
> 
> That's on me ... I trimmed too much from v1.
> 
>> This time it says "Processes using PMD-sized raw PFN mappings can
>> trigger a kernel NULL-pointer dereference when the mapping is torn
>> down", which sounds kinda important if true.
> 
> There is no known in-tree workload that triggers it, though. Mostly a
> defensive/simplifying change.

Yeah, it's not a fix.

-- 
Cheers,

David

