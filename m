Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CD1EC98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EC0E6B0099; Thu, 24 Sep 2026 03:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C55D6B009B; Thu, 24 Sep 2026 03:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DA596B009D; Thu, 24 Sep 2026 03:31:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 156D96B0099
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:31:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95638120253
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:31:53 +0000 (UTC)
X-FDA: 85247836506.04.19030B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id CA16E1C000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:31:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hkx27hRc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790235111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8q2JgeXQNfzhUF8cZaw85JDPDtRQeG2PJ5xPgrb8xI=;
	b=nbmj3Jb30RPo4gyw6o/yv4ny/SbPw3lfe/LpsZabXHJ1KSom8gXKo0SwMBPrXtwqU2+DFU
	LDfVJFKiBJsZfvXiURhd2zIToLmXefJ2dj2BcJjN7JkTObagycZ2yL8oZO1F6BoNdS9NNh
	Jg9nIBsqRcZbLQinVbcpovSQmVZo8cc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hkx27hRc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790235111;
	b=VgsxM4JoODUXKG/MRxjAXo+cXfPKuW8f9mmOFYBhqZumI7NEBMop3S0Uo/NW+sBnrS6YBI
	BjfFVaCycQ52v1eY3aLM4lNq75ybvtbzkSZEaMhsM2tmUsjDGAm2pC4m19cotD4HAA3XSa
	VGpYTi6mjHnlojFIWSDGcr3k2KzqaFY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC4A0409E6;
	Thu, 24 Sep 2026 07:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62DE1F000FF;
	Thu, 24 Sep 2026 07:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790235110;
	bh=+8q2JgeXQNfzhUF8cZaw85JDPDtRQeG2PJ5xPgrb8xI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hkx27hRcSqTkoEnzeb7acRmFdXIjYpNTSJf289b+3leAYFv0xoj8yCI+7A9tt1aGO
	 5zUX9PNaPjpswp6VGyERjPAepkP8JW73ehHI0SPXMdm19L5Ov4jT9S9odhmdmuvsne
	 aroBirTZFHgD+lnRpGxqGpd1ugvrnLNQx4kH012ASoytHEuxkGxr8f9HMg4xH5CUTl
	 OYgx+qvEXaLDLgmHR/xEYTuJS/M55xcSxMCO/jQcZdT/vdEOyjkXXeDYJIt5N97GX0
	 rfvvVC6ySnjb+Cmog48Wm1J1qL9NAh+u8Giy9slS3U9fKyht66lWK/iKJ1rKtKAA6I
	 uMGfGGKVZDAFg==
Message-ID: <65b94694-d503-46c5-9f13-f0f7f8bba8d8@kernel.org>
Date: Thu, 24 Sep 2026 09:31:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: don't defer freeing kernel page tables while booting
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Vishal Moola <vishal.moola@gmail.com>, Ingo Molnar <mingo@kernel.org>,
 Lu Baolu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org, linux-mm@kvack.org,
 regressions@lists.linux.dev, linux-kernel@vger.kernel.org
References: <41a59ba9-039e-454f-8d31-f647db802ada@kernel.org>
 <20260924072819.33277-1-mikhail.v.gavrilov@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260924072819.33277-1-mikhail.v.gavrilov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6fis9n1obhptoajf1dtzde6aeuswwi1b
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CA16E1C000B
X-HE-Tag: 1790235111-507245
X-HE-Meta: U2FsdGVkX19kUrzfnNzsBS8L+yMh0qkKahEVHk00GnNDdeqErgehrRDEq79twGDcqfgmjM9inF00GuY0L0ZMG5/4IbHrI36cem/haYzmkSgcviYabyc40cYvTB2P1tF2W2aOb1BUFUWDDqfIa7eZPEJdmemfjrxNp1bhdZpLemUBM7sB29LRqgBtWulC7abasJfkqKWB5YLjsyhCjoQpojayhL1m7IZAMcMRdue8qvUnFi7OUs3BqcepUG6ea3MlwVZHR2MoT3ElZpAkPbq/dKeiWEWawytl9ElR1BhT6amHIK6WONidwk7k+uBpI2yr6/86t155CKHsUZnqjIKw+u5gkYAgQNS1LFJlwFNLP7J3pQOqgjl6tAAE7TG4Mf6g9SfCKruKF2YBUjIVmCB1KFX72q2OAXjrjEkSsu4nBOVf6dUkHgPC/pxg54qTGMypMTxiIFQMRR1Dfz210UPNHQgLJ+PuetvgM+6L+ynl2XTLtFzdRjI2nhbfcIzGBAfYRYwo53YCjikmSam3HUnBuMF7PrpA+DNOS6FmKXZJC5r0XjoxOBit1wFhoTT90k1ZzK6IVeg1M426GwYmE/N/0QuvmfPAIP7J1Jdi5hyHoapmYjPnt06HCUWq/dn69WVI19mMrzV/SoeQujHgRexX9KNh1KI6X26gM+xnKwYj+yHHV9o7bAJ4YxNd+3fsYISZm7Yl1gh1XbEmQoaV6WBW1vQli7ucDxp8A/DvJ2q3mUFdUNNtY/22QTmif8EpHqsZltFNQIbQPLyolKO2wf9MOyDL2i4lnZjR1jv0LCv9iww9YdpVaGXIyurwUy/JaI1pvezwHwrxR3XkrFs3ifdx3Sh7fe5PEPiXI0aTkzvcJjW0fOKG1u4SQAPA4o23OdSGBt1GyN9xkWCt0+pJ0IxROAklvhajWHQeHUwLj1Oop8F2WcKKrNvEkMpt7LCUP7m9MnSTHG66B66DL8SlIuu
 EqXeet44
 +3z8hFshUSL+zaoub+3kaA8vtAymaEaZqqBQoxqSoq3Ze6znHWmCGWQp7aJfSqsFiqviOP2sa7DYkUqELmbX4Jhu+mQefEd06Rm+8p8M8rEYJgYZ8QKJsgU/dZdspkXAGUz6Z7xCN3pq2ne944mmsVNfBiYodW8tNaV+BXlEyiD5tfp0fTPi2EAcZOEpyLaOU6VvNM/URH4WVyI362qrsAdyElVa9Fhc/OCruYNeanwzLWp0WKnC16rhtVrS0nqnXqTBSa9AbT3dzApb8AuYUqTl1vUw33/oB+tEYJKOGFIcvPIBt5xURKKFwylRLxLUMMjb+aW0e0+BFfm60JJVcN9Z0Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 09:28, Mikhail Gavrilov wrote:
> On 9/24/26 09:07, David Hildenbrand (Arm) wrote:
>> Should we instead simply skip the
>>
>> 	schedule_work(&kernel_pgtable_work.work);
>>
>> and rely on anybody freeing stuff later to just free that one alongside?
>>
>> That avoids throwing in more freeing handling.
> 
> Yes, that is simpler, and the early table then goes through the same
> IOMMU flush as every other one, so there is no need to reason about
> what an IOMMU can see during boot.  The only cost is that it waits on
> the list until the next kernel page table is freed after boot.

If we're worried about that actually causing problems we could drain the list at
a later part during the boot stage. I'd suspect we free something else later
already and simply drain the list ...

-- 
Cheers,

David

