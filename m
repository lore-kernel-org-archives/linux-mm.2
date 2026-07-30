Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20931C55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 12:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7155B6B0088; Thu, 30 Jul 2026 08:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69FA56B008C; Thu, 30 Jul 2026 08:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567C16B0092; Thu, 30 Jul 2026 08:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1A06B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:15:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC17EA0125
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:15:11 +0000 (UTC)
X-FDA: 85045337622.13.2BC69CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0F592C0011
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:15:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W7dYlENP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785413710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GO3MAPLZ58UAJfUkayqBJgVx+OCH4aJ9j6/WFudsDTE=;
	b=OIsfD09z7CVTTag3jaEMaYEYDjI04ioTayGb1QFc2WWBnqO/q1FqLojwBERGGs7yImFkes
	DCZn6TAITlaFaFYzN46/RJIHxpcdHuM3334dSRYws8V8oejlkiUDoFvkuciBMvBhTSW7WV
	/K/FB9W7+bQg8h+yn2TpJ3Lgy9KoWiQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W7dYlENP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785413710;
	b=iM98Oo/GE9rs3fJYHFHg4O53nHGjLFGxqhr0aAoEDiDcW3HT+vdAM3nGuHr/AyfBD5RiDD
	ngZfrimc181YYcS8eKxiVFzzfoXwqUzNHQzllPdGp/sjJiqLKKbaGuPzNYGSqNOHCurbHW
	u1Drpqzk2FZzk7Q8XsBzUfXF126uCzo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 18A0C4033D;
	Thu, 30 Jul 2026 12:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16591F000E9;
	Thu, 30 Jul 2026 12:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785413709;
	bh=GO3MAPLZ58UAJfUkayqBJgVx+OCH4aJ9j6/WFudsDTE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W7dYlENPHsm+RpYYudbiJxzcKUekCHVHGwTGC8JNy9xGQPT094yGwrUGkWC+YVqMh
	 KlFQWGzGENRlZ6Y6z9/+cwe/xipnPWpPkt6k8jM7FX2bqroTNR19fZPVlkCdXgmkyc
	 Y50XRFJWPIt6+9RXcS7L1/ehoFUe2Phv4fZCG5li1OTQKEZeIB6E0dbEAe7KVUi83G
	 4+ivy0qkH6a0qheNK9FioZRDAA6ouuJP/w+IdBP96Mxjx8KFjht7+osLdaXsWjkHyQ
	 V5mKGCc0QefX791p6rsCek2VEpP+IYD2i3CPEoKUni7qAOhyrwCuWwtQHtoogGFVcQ
	 R+jD7Jo4S0PiQ==
Message-ID: <06b93266-d395-422a-9267-850c59b9f207@kernel.org>
Date: Thu, 30 Jul 2026 14:15:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm/khugepaged: extract young page check into
 collapse_is_referenced() helper
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Usama Arif <usama.arif@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260715025941.1571316-1-npache@redhat.com>
 <20260715025941.1571316-3-npache@redhat.com>
 <ffb091ee-affe-41b2-939c-6437dd9cc13e@kernel.org>
 <20260730075217.qulyrc5s7olumqzp@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260730075217.qulyrc5s7olumqzp@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0F592C0011
X-Rspam-User: 
X-Stat-Signature: 896n73d15ter6s6yqgx5kgzcorwcnghq
X-HE-Tag: 1785413709-553004
X-HE-Meta: U2FsdGVkX1+u8CN/OCKhhpQ7kK3JE1vcuM9WqICTXWF5QHzzQuKuERrsvZ29OgnBfoYKFkufS90l79sgd9SHRQpmdZyiAArfvn9Rb7xhL1UxrridoD63lYWK3daLjda1b1ouJc+UL4hk3pW0AqfDQt/aYSS99Q/Y0JIIHoEpPrPjlgZQozWpBmWkNdTVFQYw6bOcpJ+uKxqAKy+1eKWJHeudYgJX6/0uu/0exHqdm8Ge8ShRoD5/rIDJsksPOvjKjFUinSzMjrGBXio1QPHN4+T6zAbCxOKQ+8WrlmruZqioic8PgferiCfx4CsjeNe2EMaHoCSLYj8X6oZ9Tvemnkep8b6edOV4BJNEAjDmiHrdGuPOc1PAd6CV4qqDPRuxbZcXc5RE7OIjmtm+uRY4gSItArqKNVnR9Ve+LkyqJHny874I5tpVP0Kfn0iFB+fEVxAzZ2WOs70DhA6bMzusVsCvZQjWQhEa6tDH1oYcYt4JNvDbgzOlKZ9+JobFJ11v1H7wCLO7A4LL10s17wuTynVR0Kh+z5yB7Vh68JeDbbVKa3kWSz9W90DzQP16HItbcIKglEQ5J6H7mH3O7ZXwUL1qzPtnPsFgrltpKb+iyPq4ikjn4bCyXZIr4DvCrR/h559gj6agF2dI/4RORN/RD0v+bBasL1eQewg82eH6Ju6r8IBJ+OZBd7ppLsi1G73x6wZGq9fPDSltEBVJsStUmeUtX4axabEYMleqYVq5o5fz7AhaUtKl09RUMA3hR7T1ZAgJp0EqT1xr3vF0BMbpW2gD9uqiQU6A2m5nuy4OCUUkgKnYCkUDVpZjNnDlGHVxwjJZRFhPbsoJplukXPv3X9l17hml/BBgiFwonTJif8Fs5kcF7Vo2rJIi8Cirl6214Onu+RBj3DFOys/IjAbNhQ19ks8+a54mBIsrv0h17rIYZED8kAKe7bn1sD+RZKq6YRtdjBHoYfLLNfp4/ns
 4vRIerhi
 AEcRv4tNGn1q1h68IyUmJY/kZdztPJU6YEtzA7fOQjtxTo0ZdSK72CkOrTS9wSB94lWlE9TUJxtJJ31YQcYNxqklSZAdEPPLTlh4RTUIDLhTNf+F0UOQ9GUl9n0tzJaPbUNyG5q4S+72M5SE7BIjT2ic/jV2xeOZOZ59BN7zzHqF64pSYaCTK1gPsn9uEaj/H+mdM0np/aRIX4dti8ijcII1h/n8i7jyZAbKexT922eeQAeqd3tZTRUaEj/0Oug9p8DYhGix1AixBsPRkmSX1yMVkldI4lpN2BDhQwOg4rGDj6t1Q6tnU4mh+ixt83M0+Xo3tSN8ThcFuBPoiTwgZuJgo8cIyViSoA9aJnqjafMsGbxlhdD5Mj4IjrHd5fizEL1U1NXvj/avbcFPhyDuw+sTJeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 09:52, Wei Yang wrote:
> On Wed, Jul 29, 2026 at 11:47:00AM +0200, David Hildenbrand (Arm) wrote:
>> On 7/15/26 04:59, Nico Pache wrote:
>>> This change deduplicates the "is this PTE/folio referenced enough to be
>>> considered for a collapse" condition that was repeated in both
>>> __collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
>>> a single inline helper function.
>>>
>>> Also move the comment and use it as the function header. While we are at
>>> it, updated the comment to clarify that a young pte is a recently accessed
>>> one.
>>>
>>> Acked-by: Usama Arif <usama.arif@linux.dev>
>>> Signed-off-by: Nico Pache <npache@redhat.com>
>>> ---
>>
>> Also, do we really need this (badly named :) ) helper given that there will only
>> be a single invocation after #5?
>>
> 
> Hi, David
> 
> I see collapse_is_referenced() is invoked by collapse_scan_pmd() and
> __collapse_huge_page_isolate() after applying the whole series.
> 
> I didn't see #5 refactor this out. Or I missed something?

Looks like I was daydreaming when skimming #5 :D

-- 
Cheers,

David

