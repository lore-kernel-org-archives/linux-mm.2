Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77400CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 13:44:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2CBC6B00C2; Mon, 11 May 2026 09:44:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E03F36B00C3; Mon, 11 May 2026 09:44:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D19E26B00C4; Mon, 11 May 2026 09:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C00176B00C2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:44:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7BF0C4011D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:44:49 +0000 (UTC)
X-FDA: 84755259498.29.69974D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 946F720018
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:44:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VPQQZ+i0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778507087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YycJbZdwrngUjrEYlEoCLAuA/+HvZI/S0n2mIKYsIvU=;
	b=JIuMDbq0hwJLo2v/S7w5oprHJxs831SfIItxJJOe28ohf4sLdE6NzWcG2ebZuCVB+44rzW
	w4qHewk7qZVXsZT29c7HYcA6gWqwUbDEhbQhcpmidpDu7g48Ei4KJd/KmrOZLY++gDsdGL
	5BDykfml8e+cPka/OHuHfLnLTUuK11U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778507087; a=rsa-sha256;
	cv=none;
	b=Z9v1NgEr1gwLrDlKQJsfJLV1dFMJnduCu7zYqjVa+UIrScgv667V0T/WgFw+Ntw42FMGXM
	b8vARVSKo19LeMryTr5G93mAw8KRge5AFoZBwwZqCO1MYKLxfknFbvE9ccuM9xdCj+xC6c
	/nmJoK86bJHLdpdWdtBVu096D2IOyVI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VPQQZ+i0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9AD7644558;
	Mon, 11 May 2026 13:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48F3C2BCB0;
	Mon, 11 May 2026 13:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778507086;
	bh=BBe4GAI/GuYPKhYZpkp1iU2VFY6Qa5H0Frz8jISJUfc=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=VPQQZ+i03zE5V0qYX1spklVsimLKMkU5UsLI7UI4NbPJYbmI0UepTG07Rut9hAWQp
	 01xmLtnJBrCX2k636dY1vqD/8egVxf5W5cKEx34gyy1/e6tEejEMmS49B2TZI0Z0xz
	 DSaWOHk7eGW+DBqG07WukoaxVLSBCOwsEOA0KQIbniMoUG7rcNiRP9sARy7d/EsBJs
	 2CPfygwPsAPSYmhoKajPOeNk/FCEq/GIZzlIdwAgQnDQ9+frDLV34PpEJBa6d5A7hV
	 HgEqb3VRFQJUlDBDxzzAxF/Xe3LQBe+HRae1i4PReyRbG8OHmqDuX7+hvp8MwnCgny
	 HLPfeUd5SsjVA==
Message-ID: <bbab2b63-59fd-4f21-b991-53ae22588704@kernel.org>
Date: Mon, 11 May 2026 15:44:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: restrict zero-page remapping to underused THP splits
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 lance.yang@linux.dev, baohua@kernel.org, dev.jain@arm.com,
 ryan.roberts@arm.com, liam@infradead.org, baolin.wang@linux.alibaba.com,
 ziy@nvidia.com, ljs@kernel.org, akpm@linux-foundation.org
References: <20260510114001.600681-1-usama.arif@linux.dev>
 <8838114e-5b6a-4f3d-932c-9e97e51216ae@kernel.org>
 <608bef55-44d1-47f1-a201-4a6bd7be137d@linux.dev>
 <574fc329-bf2d-4686-9f15-b1709432326e@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <574fc329-bf2d-4686-9f15-b1709432326e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 946F720018
X-Stat-Signature: h19iskbgbmfii4s1z5yiwgd76t6s7kfh
X-Rspam-User: 
X-HE-Tag: 1778507087-230030
X-HE-Meta: U2FsdGVkX1+lQaY8sznXFq+cMUfXOzdOdDIk277hfO063yNrdynTOxE5883bvrkUwEAMdHNQ5pRs28J2l1z4vdX2rVx6a1SOqDb6M3R/oDcLOmJI+hdUdexqrM6DP07vQdVjKRIBexKg1d1FwlanOKfttOk5aH36JjIONd/B258Br5iCn6v1fZxYVdRpjcBbWllYKUgaXJF3gfmQ+to3J1+aCBITOLgMzpUKE03qPD9yP5xHqqUQtqOUrElyzlvEF81eqKsUX/jTyOYv91t0bThxYJTYrAlPdEQQlD6nApkRogkwSlnzZ1CjIGUyC7iQmrl8st1naYxORA3a8GRJZiebEDUh6sBcxkLGzjmGW3Sai8uoE/p27zrgVrqncUq4ma+j1ehpb3TKkq4BQ1WVlR07tiwHQ6ADGAtwEbvhIcYpEI14Tvno09pf2WhoZYeEWfYnw/zYe85szlT4UiPmPv9QSCy5RfNXsRsG4NVf3b9x2OS1a2QaRWmJrum9/SexkdaJ7QF+SXFiRwoi9GSQryRpXj4d0cgqkWOsxjXULMkBNDN4jBiu7tc53uMlVHX9JlePJ4y1DblAt11nOeMfJHN249/2c/vdGn+EOe61rFBTQP7ImAWnIC4Ea2ualH8slNkoPG5rtbx0i+XQSxXU8ZZQYjl7KbCcRwxXA/AlGwtz7AWWewKOwHZeAgLirI0ucGzxFJPoVbiwZriveAg7XpOdo+Xt65kQhhnAmpo577wFTJ37Xvggnk5m3Ru465s28MqqnTYvaRAyhd5CzKo2uGF2bYjT4C6FRVu0Sz4fqYDCYGfpBqvUPA92lrc31mFgDXk0cX/gadJsZURBZF9Bkgg70UWefq8c0ubgkjMw4YU62qH19MNqTo9uDeK6HFQ/2cI29IrLjMlHIt5hjpffiVp3SXr6fUU1HZvVUju0jz7l9P5SFLUC9gRwBZ8ovpRr0THh+S28UEcAAgvEYUd
 U0VAlXz8
 RJuTlKEL4gllOikBsi4ytv8fQncP++bxFauRoyX1gkCKOo3xC2u6h3vT6KFcivdQfP4A3f5PhYVqFN5s8tZzlS2KcYB445BU41SUkOXpoC5QJYZyCZiXwgw5LUdvIb0Ov3nEEuAp2jsGKWWsAYZea5PQa+uMNBvh3T/DhHH5SNi8sSfBS4KMZa7ck5RArcQCR6FVW8KqUcgrfLPHyR6kVqYE+HswLxNiqGpOfJ8vJyAHXhasSyvZM/UZRwY+VQl4s55DoHZKPZeWgdIqy4Z1EZjoSBp3ZTcNHynwK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 15:42, David Hildenbrand (Arm) wrote:
> On 5/11/26 15:10, Usama Arif wrote:
>>
>>
>> On 11/05/2026 07:36, David Hildenbrand (Arm) wrote:
>>>
>>>
>>>
>>> Hi!
>>>
>>>
>>> Yes, but that's what the users ask for: if there is a chance to deduplicate
>>> memory, it shall be deduplicated asap.
>>>
>>>
>>> Right, the probability is low, and it would change existing semantics, breaking
>>> existing users.
>>>
>>> In addition, we would have to add large folio support for KSM, which I rather
>>> would avoid.
>>>
>>>
>>> Right, but that's what you get with KSM: bad performance if there is a chance to
>>> deduplicate :)
>>>
>>> (and bad performance from scanning overhead)
>>>
>>>
>>> It's not just the zero page, but really any page content. The zero page is
>>> currently only "special" after we added conditional support to deduplicate to
>>> the shared zeropage in KSM. The shrinker doesn't help for any other page content
>>> besides zero-filled.
>>>
>>> Further, the shrinker is something system-wide, whereby KSM is usually only
>>> enabled for selected VMAs (with some exceptions nowadays).
>>>
>>> Also note that KSM deduplicates independent of the folio size: not just THPs,
>>> but really any (large) folio. Yes, it splits large folios, but that's really
>>> just to keep the T in THP.
>>>
>>>
>>> Right, and it makes KSM more THP aware. Which is something I would avoid right now.
>>>
>>>
>>> That would change the semantics where, for example, where we expect that memory
>>> was deduplicated after a KSM run.
>>>
>>> VMs (where KSM is usually employed) are expected to be mostly backed by THPs:
>>> except where we can deduplicate memory. Skipping THPs would essentially break
>>> the main use case for KSM :)
>>>
>>> Does that make sense?
>>>
>>
>> Yes, all of above makes sense. But I feel like this means someone should not
>> set THP policy to always and enable KSM together. 
> 
> IIRC, QEMU will, as default, set MADV_HUGEPAGE and MADV_MERGEABLE :)
> 
> (KSM itself later has to be enabled manually on a system level)

Digging around, RHEL documents that one might want to consider disabling THPs
for performance:

"As KSM can reduce the occurence of transparent huge pages, you may want to
disable it before enabling THP." [1]

But that doesn't mean that some people are using that combination.

In the end "some THPs" is better than "no THPs" :)

[1]
https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/virtualization_tuning_and_optimization_guide/sect-virtualization_tuning_optimization_guide-memory-huge_pages

-- 
Cheers,

David

