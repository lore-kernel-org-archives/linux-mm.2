Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FFF1F53D70
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 803476B0312; Mon, 16 Mar 2026 12:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DAD56B0314; Mon, 16 Mar 2026 12:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E6D36B0315; Mon, 16 Mar 2026 12:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3BA6B0312
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:31:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27E38C1952
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:31:01 +0000 (UTC)
X-FDA: 84552465522.07.84DD467
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4242480003
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:30:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lS0PsNXH;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773678659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KAsWhvFBN90fk0P8o0uitVlupNWubaaR1bvz/qcOZfE=;
	b=yoxYLAqIX6LzQqLh6qPsA0POQVAsQEwPWBuZKexOpfQ60wHUeNm9k68FMBDumGZ8VirRo+
	Qx8R/jTwzxr0s0rtI6VyaLK7suJzVXKfy2/MS3DFMo5o0kpqhWwB6buR4U/kl78OnLCYUO
	+O6qBF0uhPBDqPhvZ+72gV8YzqVhn7w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773678659; a=rsa-sha256;
	cv=none;
	b=SLkzeZi2Iho56CBM6n+v+OQbSIRw+biXzYRKI/ubMkJWoSloEzFQginZtqLwsaEZleL/Px
	7knyRfj+5tvBq2zD1grfWNn2pfPgnO51wQUn2AEoSGcoZeUuoMrsxuBVNGImJTIS5orHym
	EpvRJPgv6Mi6pHxdQDKHjtFxfwj1IyA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lS0PsNXH;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CED5441B8;
	Mon, 16 Mar 2026 16:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961D6C19421;
	Mon, 16 Mar 2026 16:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773678658;
	bh=CvqhlbZ6pZRpmgYEengTiRdk2wqsmPtfd4AlTRX6XAQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lS0PsNXH9/7mKjFbl7P6BYXKU5yTyrWNZZgvFNT4ECWzUajz0KDb7gPKpFteZGR3F
	 xd0gnK4HNCVXh9YpkBomXUnaGgldp1N6Rgf8QdFarxvNkGe6W4L9e0UWPDkWcrgBr1
	 6YbftjhWSFs9ocW1Ak31uKAKbdPErLg7x9IGs6ryGTEwqny4xCRIi4C/M2iZOLX0ld
	 I1hCgyfHQGxJk+lopAMeHCpqY1kTYSNWnOxYeXL0B+8TZ2oztbYTDOeXzuT/AbE3Cm
	 JWAojxIDMDmnmBOnAWUQ41bnzyxd/N0ZFQOzZW7WR9rTWTsLFwV9NPP46L9zsQ+dsN
	 2Uz8Da6DiL9bA==
Message-ID: <02c62e7b-9ece-4334-8312-52d635dc6171@kernel.org>
Date: Mon, 16 Mar 2026 17:30:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 05/18] riscv/mm: Align vmemmap to maximal folio size
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-6-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227194302.274384-6-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4242480003
X-Stat-Signature: hdmsqb8ugfyup5beg6s6zrj66x4nnwb3
X-Rspam-User: 
X-HE-Tag: 1773678659-487228
X-HE-Meta: U2FsdGVkX1+nXqMd3HmmNKn8t8dloTrw5rfOLc0YhO7jYXBRv1l0tsfC8Xw4wb/hy6Bh+2cijsa78oEZjxUoKsbQJK0jw0auGrNqHqNNZ33+SxX6JYXMpjg+TDWN3znJcEIuyDQ5Aigfgz+fMKes2WqiNmxQnFv4QIIz6T6OIQqZIQyAdwejxPIxnnt1CDhl2m6G830FkvhPO5j4fMjiaqMS6ol55wNQjEuY+Rrt/J4TSCe70T89Nv2ha7Lx32qENL5bZK2qCl3SrMXEwnZkfIQ0CZIt9EvUcl9pCz/aPGKWXpJhErW4MA1lNXuX+BvGte3ixjqzLuFqKAMeMN2LNLzR5zlOEN0p1r570GUF4xmBTwhE/9a6sNOUDB34YwGYzjK51NqKACP9gYBCt4akj160y9M9gOeb2ELXU02dkhZz3mMQPTlT+2Go62mF6b09y1JGHSdtJOp2eCzZCRbjSGkE97OwqQHMNoeUi2Pc9jr+HCUyN7BG6s7uwOWHXKL0mkG93xRyis29awzDpQLw0qmsD1T2SbCV0w/Ch4gafnWfwodDpf6N1DVJ4AGZTcuNUFzqpIsGS6PIkHdwNGhbyRLB4oRXiVCRcUUgDR5tFikunv03fUFL59BW8PA6EFKuy6S4utW4ZnV9JyO/PIYVMrwvRaU6pUjXlYmEVAqPzy4ZBjyJZXYmrNrrTctf/s1ex3gXjWRGeqBt5WFlfTRekj3QEVoF/1YEwxnCJ07k5bLS7f0rk3tXcW03VpPJjWz+vrUQdhbXJQmg94Hpbb/AfUfAyKDJK88hZXrNT8cUAu9a82glVsztuNxPCajSrzCZMGkz/YmV8KVs8NuuIXW5I6QnT3QmhXq+62vjGgdWlaNqE8VGKljH+eUfW9ssZxKS8X6vlFmIh39b7efF5SZu/JtrUNijL1f/R1roZtH1p5oz1TzK0yp4OpAtSI3aEbSBInJAUgozZ5dqqapzwxp
 iIKr3Ybv
 4d4uS1r5bQbXmB/40SO7O7zkIZH0tHxxfaELd75/q8NjTuf/ZqI737y0CQX1f26ifuW1cjo72uY0Bet64p9ZQfQuEwDN3HlzGJKDoiOEt1iY6aPlfXDK3Qe6kZqKy65cOm42f0g0gUkJN6mlGiJLb7TjDQJp4HiE6f+4UzOHNSpDX1s2Mwfw9mO6p0chSPu63CtxFTg09Desf0u2zIL/7AR8themuKzYqW+n0uhWuM2MoQ2dpsf0pCRiSWzKnQ59+rVZ3MzYKCNGCdaz5tObhoS54Vsh1994GBEcj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 20:42, Kiryl Shutsemau (Meta) wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
> struct pages of the head page to be naturally aligned with regard to the
> folio size.
> 
> Align vmemmap to the newly introduced MAX_FOLIO_VMEMMAP_ALIGN.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

