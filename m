Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AE5660A3818
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mIRUsz35
Received: by kanga.kvack.org (Postfix)
	id BE0226B05D3; Tue, 10 Nov 2026 15:23:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB8A46B05D4; Tue, 10 Nov 2026 15:23:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA7436B05D5; Tue, 10 Nov 2026 15:23:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85DBE6B05D3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:23:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 256A11C38A7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:23:36 +0000 (UTC)
X-FDA: 85420334832.14.B272990
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 62F8FA0011
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:23:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mIRUsz35;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0sgFOBOU/MeK/Ve1kAu1Sczjtdoz1FBdFO2N0G/d7U=;
	b=SPnr2/VTZ6MiRVe4T084VBlfnDgVJRMo7lAhIpE/6HzqMq3vvqowtxPaW0/+3UOeYQ0Gcq
	emRztzooWto+GCT2tvQ06HQ3tshCIm+I+quktonc9rM56piOTvrLZ7a8hu8DgPT8kg97kC
	rySUC39xsuZEWHHK+zh3Bqm3ltX9fpA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mIRUsz35;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342214;
	b=y/PMszKTtk6FciYLpSmfa2GZFQJzxLIwBruNEd0c4fRdDkImXiKV+Fn4Htcz4ufsQXAVXJ
	3ap38RjsvryJbdd6n8gt+Bv21+/24aSA2TaH1NcDW53vk89R7fW+2JHKpDf7qVqSJ8g/Ru
	Utm3MJQPtlFA04t7KGr8+cZTANO7rnQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB5A661E5B;
	Tue, 10 Nov 2026 20:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45AF1F008A2;
	Tue, 10 Nov 2026 20:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342213;
	bh=Z0sgFOBOU/MeK/Ve1kAu1Sczjtdoz1FBdFO2N0G/d7U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mIRUsz35IV3Zi3ISOakOHgEB/jjVCWNx2VQ0duncmJDLxeCRx1HkjV9DTwpcJbc+a
	 4bBl36DU6KgcJyAgXu4CC/SGGadipP6MKFGn1wbI0ObCDkbt3kbRyDDDjO1ItT/CZG
	 ZcJdJMgONzwgBVE5SRkXNf/DRsJixuV4OFIAJoKcNKl6fuP0RijieN4T0AmYQKshtb
	 x7LrmHKVFA3quIvpQMBdNscXLVXhV5Ip4Ek111QQDBs/oZlHE6SPje5qUWG0EkGgDa
	 O7ToUcVYWDhRlm6lALnvv2V0M6Hi3/TJ/rlq6QVd0O4nJx7bcmCil7xWGAnneQVMKW
	 aDBWw6QdXdcyQ==
Message-ID: <c6348c03-294d-463a-9601-3475ce20469b@kernel.org>
Date: Tue, 10 Nov 2026 21:23:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] mm: gup: introduce gup_unshared_pages()
To: Yeoreum Yun <yeoreum.yun@arm.com>, Rik van Riel <riel@surriel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Yuan-Hao Hsu <aa9736195201@gmail.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
 <20261109-refactor_gup_fast-v3-5-2aaef02df0e1@arm.com>
 <7627c0d90188b581e7740bf8d17c8dd07b460f89.camel@surriel.com>
 <avLqwIWHa5CAbHO2@e129823.arm.com>
 <aa227fea-d22b-4c0f-bd11-bf9ec36b0767@kernel.org>
 <699499e46ace0875fd0f32052399e665c8209ea9.camel@surriel.com>
 <avN8WISVUF7u4bXl@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avN8WISVUF7u4bXl@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 62F8FA0011
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: kbi4skoyithdfzmu5wgqwxfaehsramqz
X-HE-Tag: 1794342214-871367
X-HE-Meta: U2FsdGVkX1+c6Q9fvvtYifJraQaBxbIRTlFIqqhsV9MRKsS+UobkgjvD/7Q9JNQDWfSuQ4DpmMZhinUdzRW9LgmqxAjjWu0TjBc3qqnP9+6f7LRtknVglZeiH/b/DJSG4tFeeb7ONwyMk0WHfTBFm0KhHA+5KyJ2XTh9YJP4gC7xBfI8P+3Sfwv0CgdPpu0QMG2NcRIPjRyle6yIGaIqT7VTmpyi1VmE5sm1/nvi6J0m8XYyck2ZYDT9Ot6+g00banxOMxyl39IJaSjVcNpfKuWQFxgjWJ2FSTnlUr00ONojwgjXceYiUuedDa1P16eYRFe0p1CZa9EbZRdNFI0VhwGy/NJgDAixYA+85q8HLUpvSXdNgBuwvskBN6k0VLO8+dbHHEwKmiesoYQ0iLdcPOxyKaAxxn5DgHEOhGJgDt/fDFQ+SYqhGLFpCW4d7nkU5ugpwp7yvQKwZpBcPwb1MquCaR8xQ8nULh1S1gk2VWQghLAsI3b4h/OurOVkw1GS6IAYKYuc2AQSE65qgToCO/CFl8ogI87fJloimTkuMS9yhh3QTaQHOG64MA1rWoUnls1IKRiDZyKCAI1K1cJgO0Jdz0b9M4ygy8O/o85qSuYTvI2FLeLDxEFcZxG+Vgip8x6eLr8YktibAvLznGHEKL6lMaO7zz+gO8m81tmzEfFoZCdIxPymQc0zFH3abgAF6brL9x7F+A9sau6/NpthuPQWb144wvHTQXjcYu3EYAJgdXNiuUJaZZPcfHqXeN5W021Ul4POkZ2ad+17PkBQLAWezht1Uh0DZf6nSPCcjFvkJpgUzQSeR0qRlnmsbMJBsZw0BFjGKLp2+a5SHk1sv1k7yteQ5PRpnJP3D7N2/Pj75lV52LRLlD0KiPahD2Uy6ADDGTm5pZVXnLwsbBiC18Hase9+HcKOLIJ+WYrTkyy9mNzQV0hSQP4+qhLVwJKcG4sN68opP0hrmdbLF+1
 vO4bSJzw
 dH43sD1mvCwWGYd9GlpD5j/MY9Umb+QlkS/Vni1oQ8iGC5//2YgWluAKCVlvQtc5SzbuqoFPDFV475qjN76vB6gdUCF/26qZDLow90U9t3i5ebDRHL3Z1vZ7Hv8wVVX+59Sw/+MCoYn8KWeW5NG5tLVf8qqeG8HI8/fdC9phloJ1DGXVp/kf6HJ7JOJHQBcNEtC5eo0D6fMg/PhhLo4AFGMI02NUVjVA30HrlAyaewv9Im6wS5Em0MzGe5axaXq1wWRcZjb0ROAB5/00hBIP/A0PKYqDWBQlTc/ZBa5B7bomorgQX4WYonYKeKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 21:19, Yeoreum Yun wrote:
> On Tue, Nov 10, 2026 at 02:21:18PM -0500, Rik van Riel wrote:
>> On Tue, 2026-11-10 at 14:04 +0100, David Hildenbrand (Arm) wrote:
>>>
>>> Not quite the right semantics. For pagecache folios we simply don't
>>> need
>>> unsharing in MAP_SHARED VMAs. That does not imply that these are
>>> exclusive.
>>>
>>> So it's all about "number of pages that don't need unsharing".
>>>
>> gup_no_unshare_len() ?
>>
>> a little awkward sounding, but it describes
>> what it's doing?
> 
> Hmm, Wouldn't this name be semantically much the same as keeping
> the existing gup_unshared_page(), since both essentially convey that
> no unsharing is required from GUP's perspective?
> 
> Anyway, naming is always NP-hard problem :\
> 
> 

gup_skip_unshare_pages

not sure

-- 
Cheers,

David

