Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 735B8CD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 12:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C1C86B008C; Thu, 11 Jun 2026 08:21:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7728C6B0092; Thu, 11 Jun 2026 08:21:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A386B0093; Thu, 11 Jun 2026 08:21:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E4EC6B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:21:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EACCB1A0622
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:21:58 +0000 (UTC)
X-FDA: 84867543516.23.0FDE6DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2EC7F10000D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:21:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fbpkLaAU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781180517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uG/oiGe08GlbvOXLBMnHpg/vQFnYJfTe59/7gdd1dCo=;
	b=N8EIgCdSvOZFOfp8o8NNdk2GYWMtBKCKoQMpKkLr9tWumkOQ+zsVAz7C9GvTI8bDCZqRTe
	wW1xN1vTDe6j+jGrjDthwmz+Uy/vLKolz42VAkcruMPsYg07m2TgMJZksKHkuDLZvTLnd0
	WDE6Hju/GPiCWNMvXuJzCjr0TdrtQPc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fbpkLaAU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781180517;
	b=FTXNgpIPNbvUGT30c0XYL8urlhy7vseTnqsiyXjU6jfkWN1sLbNk/u4uiVCGKk2ByUa6Y4
	rhRXwSitvLPXhyKb5TG2f65wUJ/Jnui464Wl7vIyAmO+S/nuzTWBFXTipLuI022z/0aCRQ
	nCl8gKFhrOiSiBVFM01lcRILHx9Dz60=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DEF26001A;
	Thu, 11 Jun 2026 12:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD611F00893;
	Thu, 11 Jun 2026 12:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781180516;
	bh=uG/oiGe08GlbvOXLBMnHpg/vQFnYJfTe59/7gdd1dCo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fbpkLaAUNB5lDGQL5XNJOaEhHZC8SrUA6FP+YYfXO1mF0LhjRwfV80QyGDS7dypXs
	 VTvtMO9Pxww8G7urP/7Bxty6xRBLgkmY6Pg6LBD6ZFblw3+O62YaQdLK4Dm+j+sEmY
	 NriZAlA0t3jmY17Y6yFOS94bJAn5yM+1tKyUdKIEyqQxtiay4BkYuq+C43jkohmB1L
	 adSMXsevafXL+VS8tfCPDR/n8pxUMRCQgnX9JCqGlo/IJhI4S4SJ+jk2UztjSM9M7C
	 DNAOQ9wuzIZXfsmi5GBGAdtOWxZNmY0Wn6UdyYS3KUtOXbBfDT1vIjtnrpTul2NqPy
	 iE3LRC6MNYDKw==
Message-ID: <d943a03e-bf28-4086-8907-5a24665fb2f5@kernel.org>
Date: Thu, 11 Jun 2026 14:21:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero
 folio read-only
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, xueyuan.chen21@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, hpa@zytor.com, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, yang@os.amperecomputing.com, jannh@google.com,
 dave.hansen@intel.com
References: <8c36a91d-288f-4ffb-b2ec-41e3ef789d72@kernel.org>
 <20260611115817.59353-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260611115817.59353-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: yzu76maqp1ek7qyprimh8mtey6pxed1c
X-Rspamd-Queue-Id: 2EC7F10000D
X-HE-Tag: 1781180517-398279
X-HE-Meta: U2FsdGVkX1+HzJeXc6rT4n5Udw3gWqSaka0572CE+C4DjjZenkulovPqLSt6HPBC1iInJXicJ+mSuKopfMjicyHAYDMKfbh8ZfO/jO527xw1WY0IoiO/MOdF4Zqhpw41vwY4gpDAym7oOFMUUpJg8BFR+SBOshd37UDyhx6k2JNtY3kEv1hVGFQ7739CfRCIzA0WZo6ar3smkn2VQIO7V5tUdSEsr06kJBCTSLyuNIS9qVTAWufE5PIQyj3MCy9yY02RlTTf1oCRnM3/649i5gYbaMgQHeXDOiWf8jz0AosBSXCY4LtypiauWPdukOjrRsFdQoEk6sJuajJHLRaS+JZ/clxvls+l7ihTG1eFmqrtfLbRNysndMM3Ec+AIq/XUXOycetRKuF44OIjrFAivr+7xyxLn1rbrnpPD41zytvfiAaXyjIVUEyS9j6k6ZB6Vv7HGS9Avto5VbRHNmC//HVYpQt2bqruRJEfx7+tE2RukrA7kXxT46+DkuSVZEk0kTQvTMm8+vaKqSs2fwzeODqJGpzbKXfXK3Umhr2Yzs+F9AxW0Bn1Oa8IoFDqXhIL4rhjbPjeuykFPgO8+EINuen2dpfPi/kBvZZBY29XrV6L1WV8haG3Z98cOVYLIoZMHCqbVMMY3FDLz8rrwJopq9OtOq9G+oOKOo1LKPygeyoOaCfvtM5ytu1y+v9BDdZZgGu7PuN2p7HOcBymonWFZ3bAvNnZcLmVtHJ2j1ovu2LLom1KeLw2DTjJl6+Zc3jwitpV5YPqgp5g1+cFMv85frhhuQa0cUybbT3BjhY5bSGkXF74EWuHKJwJxouCU1kA8DnJ8jKeuELP3UhLAW3xcnB4/8BgtNsNkVNWplhiiqJX4VUc6MbcV7nrBt344Q8saSdNooZkIasoURM0dKxL/HVXyTOqO5yp4tFwmzhloUNm6Onn3OBaDAkq2BsVZQx3lTi17d9+/z3fWg4WOsj
 TjnjpIGU
 uBsWXCj0Eog1ylu0yorEn8nAytyqFhQEKpkGacSlG9Iaoahr/IvGazlIhp9XNGTIC7eftQkJz/4HZnM5ro8MztHYThz9uGmMwcQJuW7Hv+nJ6DOgVzvdeglBSTAu5PTRhnIiuk2yTDofZSsB4ON/lLDF5YfNmu3dyxa/YIlvjmoI8j4GKG9gkhhlqBxBPVqNvwxUr1NVNhEHGRG9Bf7jFTTy32CJaHm6d47XKodR4WIcNnpN9erVioJhiLXsdeyR44Ga0gM1rtG7DL/EFYHngpxfnWR9Wr+FOK047+/ZDPhhWvkiUtkFaXnaFgts4ZF0JD0O9c0xtcaILyxbSsJCRv6w5RPCVyGG6RdlbKD5ITQTuY7Nyl13JmImyiRdhVH6LJY0D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 13:58, Lance Yang wrote:
> 
> On Thu, Jun 11, 2026 at 01:28:58PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/10/26 04:15, Lance Yang wrote:
>>>
>>>
>>> Right, this came from the RFC v1 discussion[1]. David preferred a page-
>>> range helper for possible future non-folio callers, not something folio-
>>> only.
>>>
>>> Of course, we could also add a folio wrapper on top of that if needed :)
>>
>> Best to document that as part of the patch description: we don't really expect
>> to have a lot of read-only folios in the near future (zero page is rather
>> special; maybe it won't even be a folio in the future).
> 
> Ah, good to know, thanks. Will spell that out in RFC v3.
> 
> Maybe something like this?
> 
> The huge zero page is pretty special case, and maybe it won't even be a
> folio in the future. Since read-only folios are unlikely to become a
> common thing, a page-range helper is the cleaner fit.

Right. And if read-only folios in FSes become a real thing, we can always add
infrastructure for that.

-- 
Cheers,

David

