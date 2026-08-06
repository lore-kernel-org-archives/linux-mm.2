Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6578C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 11:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9978B6B007B; Thu,  6 Aug 2026 07:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96FA16B0088; Thu,  6 Aug 2026 07:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886BA6B008A; Thu,  6 Aug 2026 07:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5EF6D6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:47:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6EFC1206EC
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:47:29 +0000 (UTC)
X-FDA: 85070669418.03.CFC2FF2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 01CC2180006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:47:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q6qHYLQb;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786016848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RD6YcKJByfHDc/oLLe63rWqQqw9cay7OOY1dqFAnW+4=;
	b=Lm7MNlYWBr27EEAbW36csEblccEjLFWBGAyITbzMeEB267pY4NMA/FVdAJNfSLvy0w4+XA
	1Wsoz7Xavr08PfPOEQqMf5m1FysknLtBS00opPQr3l8aBjxnBKMtQkWwwJF0RSgX0T/gs5
	rnj91ixtdoE5+tuZRjRI59pr/dLLvKc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786016848;
	b=MhDmqirbPPYe7ajQIWe//bvcmyprPBgptaMJV/vDgEYh9kJIvZ6y01vOzP//3shEEtqNPx
	y2BE0rCtPx6kxBhe7hi8sJ6D2Wec5Vx2SOj4ZJ4/RUjPUL6OGE/g2YT+a0l1DoYY3gO3aV
	PbO2KffTrJSJXuQczYIwfC9z8Y5/OLk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q6qHYLQb;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36D9C4024F;
	Thu,  6 Aug 2026 11:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF67C1F000E9;
	Thu,  6 Aug 2026 11:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786016847;
	bh=RD6YcKJByfHDc/oLLe63rWqQqw9cay7OOY1dqFAnW+4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q6qHYLQbqmvs+gjo6IaFmEnViBrtk5aa4swW8Op6CjZQR4yF3y+0bGEGS+1ZQUrzN
	 AvG559mt5Q7bCsonb/xBfL7TuNK18S/1NwAL2hoVL6Ypx44SV/la/XxT4lmd/QKlxw
	 eqnWPF0hbbYeFqE/YOdq8gkseE6CGICFse9pejsH24x7ycZYkTlAzbSuipFYstLLzf
	 gqG9OJ3ZN5oEvaJqcySkX2g93oOqVPD7b4i9c8mwtJwrXf6ePNa1Ku8OnA6mikOvZT
	 O3fL96GBGLBt4iykoSgodILubgw3YZSoht25HcYTzk+eSxRee1vaxujaEj8xNDNGbj
	 Repaf/6nOzaTw==
Message-ID: <70cb93fc-22d3-49fd-9103-29a4759bc39b@kernel.org>
Date: Thu, 6 Aug 2026 13:47:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: Drop pxd_ERROR()
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260806080639.1916749-1-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260806080639.1916749-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 01CC2180006
X-Rspam-User: 
X-Stat-Signature: xjtmu4ubiwkgzifpshfc1w7kzo99jqru
X-HE-Tag: 1786016847-599804
X-HE-Meta: U2FsdGVkX18N39aWoOquECl7CwrX7GpP/n1Wv1Hx4jR4E/X02LUiL8vw2IE97Lon+7zPc88Cv569TAP0bj5R5hdCzW56LZ5aIzZkzjREkO3sTvu45hfVIk9L+0+0rRpkXL9zwyJM5VnB7s8ge6oBfnP4aoge5Fslc6202lHsRFquXxkU0tf/SPnq5KKZ6RywfNLMteKdOx0Uzo/SMaMC0/eBcOCJiug0ogopPjoXfrf+MXH4cuUgs3BvRR2hbEvV+lTqp8emlF7wWF9MYzjJBHnqfMqANY3GYBwMhPH98xEQ57Y7fJed8ST9HX+qg8dUIaD8ZDqwWYldwUw+DESirjdwUDgvAypEp7mCLQPpnEB5m7X0UY8j0RuJ/aNhBAp4CCV8AUn0XAy5CzcBkgdcsIyVE+4jvN0yTRf0dawtn5lHKh9zD/+0PgQvxSv+bizU7fMag2w6YCcQcYmN8yj5kxVujCgtbAmBjncO4/NFUg0bU2QtJaXlJOQEML1VWwURaosEf96SZLppK0sbCtt0NVCLYqwBStI5GtP01dpJCtfz4NMp0Q4PdoakyfOqnlP1+BYH9ROFqPH5oSwnNSmYuS5YTsY98sdZrXfZ6Eoz2AhWL/7Ou3orHakBaDZFfgNmBye7Hfp83P+EHUzPg7YPEzuyZ62/9AbgxCPzRltVxfwQ68XYpQa6FZ6i6d2tb8PmVMc34jVWLSdJeHUx/4lSaBwzMLIsdRJPGrlt2OeRkqpVH/BlDBojT3H+p/ybTBsJ5wJe+k8n89/orksflYpi1Q30tg07ZDK93HE3ErZ6LRWInpYHeDWNVkKqPwM1n/hsUboamYlT78AbMWgICy4ivYIQNP5ll9bdpPb2n2rokoLLnKde38CwiKGwd1jpU+JLRSr8GcGoDz4pyclsta5sny6lReiuHf6vqrxZ+t+8m46h5ar9dh2q3O8kYZQq5LbFopX5ZxQglY6MtvpeuQv
 NwaJRlIb
 VtXKPX2ZsFHJtXM4stj4bEjlXeL2EgVpDie03U+HkYeZF0UwLj3qJhuE2tdx5lu9dAOQj7laTh36BywFjH8OdtuaxMQGhItU2nqFnwiP0+UoNUbsaOQrVM4wZYT+7t/KZ+YHJuuLTg3VckDVM36YAD/SnxQTXDOT75/VlYC0MIIf/65DXqYqLJxyG12sMdIEe/NrFheWYt8Cj1JYkS8uLK0C1ybNK45ObnH9rBmhAKqi14HrBCvFz8H8kDhizbvLxqq9D2S4ldbj/FGH+mkkEAc5DJNrM405h4Ti7vtVsmMzpnqVzjWWsO/EEMlW6u5XENe30e7TPVM4Tt7bXd3FoBFx/RLSEII8BQQh87pVRgBs6N+XF914PYuximfCUeUsKWEiaSrJYH2lEXG8AAJXkq4WUb1Kv2p6nAuaz1/LEUcAHfJjRl+N/31UON5DCy3qeSG0IA2H1AaPWgOwuY7m86vB1YdsDc0/m/Zp/iJMeJIFEmYkRyhhZKozX5sJxE3Gbf5Il
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 10:06, Anshuman Khandual wrote:
> pxd_ERROR() has been used in generic mm just to print the page table entry
> in pxd_clear_bad() before clearing those out with pxd_clear() later. These
> pxd_ERROR() macros have been provided by all platforms which basically did
> the same thing.
> 
> Make pxd_clear_bad() use recently added ptval_to_str() instead for printing
> page table entries thus completely dropping dependency on platform provided
> pxd_ERROR() macros which can then be dropped off. First move all required
> helpers in core MM into a header file which could then be used else where.
> 
> Although some platforms still use those macros internally as well. In which
> case just move these macros inside the platform for now.

No, just get rid of them first.

The ones in arch/sh/mm/init.c are just supid:

if (pgd_none(*pgd)) {
	pgd_ERROR(*pgd);

printing a none PGD? Stupid. :)

Then there is arch/parisc/kernel/pci-dma.c, which just open-codes
pmd_clear_bad() ?

	pmd_ERROR(*pmd);
	pmd_clear(pmd);


Anything else?

> 
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org> 
> Cc: linux-arch@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> This applies on v7.2-rc6 but after the following patch
> 
> https://lore.kernel.org/all/20260709044334.1741263-1-anshuman.khandual@arm.com/
> 
> Would it also make sense to just drop __FILE__ and __LINE__ from the output
> in pxd_clear_bad() helpers as they always print the same details regardless
> the error path and does not add much value.

Yes, drop that, it's nonsensical given that all relevant calls are from
mm/pgtable-generic.c

Thanks for looking into this!

-- 
Cheers,

David

