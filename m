Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0725C106F2FC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71EB16B0092; Thu, 26 Mar 2026 04:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F58D6B009E; Thu, 26 Mar 2026 04:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60BEF6B009F; Thu, 26 Mar 2026 04:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 50E7C6B0092
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:42:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1375C393F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:42:11 +0000 (UTC)
X-FDA: 84587572062.28.6D85617
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 38DA11C0010
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:42:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zf5TImpo;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774514530; a=rsa-sha256;
	cv=none;
	b=vc5cuhbQzGwgcXXLP28hbykK7CqyvkhG8VG5v8/2IEwyJp+LqkgTyqwD3TTWadlIEB3ldv
	rosivg5PHFBsf4YIYjwzuNNF+nqdscoWIa71Rh9Zp2JvryZohMp/bHD+tg8aT12O7D0OPR
	ZZu2smyZr8+tBA3/MvH9/KwbMUOZzZM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774514530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vwhiSlcHSpIZIWcHLGV+pYsugiGTNurz8MHcD08lGqM=;
	b=tIhMNn/8QmyAyYBRpFCNcRjrELpVpyV2MnjYWJrFu/M3KGugX629hUR8/wCqJXHOm0vKvj
	TCl7/rBSQcu7wxjxmjzTehEJDaR92qCzuuMxSXal0p6/S49Nlvy8JfYloX2s+aZBxFqaGv
	ZJVCBkdzfwaCXXFGJqR2yEdgkslpNPw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zf5TImpo;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D69F417A5;
	Thu, 26 Mar 2026 08:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F063C2BC87;
	Thu, 26 Mar 2026 08:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774514529;
	bh=4MXTZi02qDWDZ/7PsLgwqab9shZCnf3DgC2ixokvzH0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Zf5TImpomYw1infcDhd6sl6UsbdPtwCS3Ee6bIMuJgdbpciFcDhAXTBM8SenbNVkU
	 mbjFKHsHtbKzUM0cUrUS0VgvxH98yDpS1/9tv3IrVRJM+617P1ufRtC1RhtRw1XSQt
	 79Dq7fPojYix+HOp8ak4xDwk6IUlmxOJR22pwa5gz5+9s0OuVkb6Zi4CNkYQzen6w2
	 eQhb7ZkDP8rVCeu8QWp+IAK9wq+LhPGO5kdxNtVKXF4T3mLwWR+6lsnPeDm8Mrp3o4
	 HXqQB8cV3KrIWhnwNFqHn0m4gEKHcs7ROdpxYT0+BQYUgaxgUXygC9/gY+ANxBhw69
	 /AgGEESrWp9LA==
Message-ID: <cfe3c03d-6e46-43d8-a0bd-f60c22a4f145@kernel.org>
Date: Thu, 26 Mar 2026 09:42:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/pagewalk: fix race between concurrent split and
 refault
To: Andrew Morton <akpm@linux-foundation.org>, mboone@akamai.com
Cc: Max Boone via B4 Relay <devnull+mboone.akamai.com@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
References: <20260325-pagewalk-check-pmd-refault-v2-1-707bff33bc60@akamai.com>
 <20260325175006.1c3cae2ee50dd491a153226e@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260325175006.1c3cae2ee50dd491a153226e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 38DA11C0010
X-Stat-Signature: j7aatzsmn7zaw59qedirpbm9ee1zmtmr
X-HE-Tag: 1774514530-466669
X-HE-Meta: U2FsdGVkX18iOfElOFXSqCCKXfMlMClPObuIv6RVOHY1PBqIEZ+HpZUvSu+EfO2o6FDQMiukhJu2EUBieq3HmcFAD5xLdP0OkzTQVphSv1KxRKpky219mugF8D/d9N69OPIwxChos+N2Rg0zp2xQHC3bm/D0D8EzkKt8wszi0npNYPPf5FNfrN0wFwU9dEyAQxwDsWhtNiIR7eEhMzA+mr9pHk0xBfpnaBL5gBB+uGI3FY8u/wrpCJ+XPXBQR0+PyXJYY381QKSEjpYEF2+7ciS5zdq7StSFXrc7JmlltJkOS3TnOE2HdLwe+6UEPJ1eK66cuGjBVTi0twC5huWNDWq3fKbFoXM47CJcrGMfF7QGBG+GOPD/97kiJL0FcTL03OLWUbpsFqruLjTDtK+D+UaaPVFw8ZbExjrob4eTwRZSh7R9EfMGFHOi3D41eXY4DTwAaRSfLZxiSOENjJuBENdWrB9i+leU52OrBDuZK5GhiFLaQhaR56xar84DqhL+zTWy2i1fgLNqdaD9OMQKdwKbCcpYf/eTdCqtilcYIDagjL+Pd2iBcIbNi/ysamgWmie7xcuXeidExLgh87OTzZIR43M1rGTc2KI+9ZfN61UsxBRiEaf22OYXQpinITl+JYL0i/PK4GEaWhAHd23HC6omTEPvBcjsAnQzPkys4oA/sH/LOwcooaxInqiI4Wa5HKsIxIE7Cn8W7jCpvNIpjZ4/KJfocp2i3fosLrDye43VTkpX1+M9FFlHmzm+UGoSBH0cUYCsHu7LKfw8PmGK3VzSzDyIXJS+9n4ooxIlM0rHZ24qNHD7JW8Bp/3zF53FX8msoSmaU8CMwxOFm5LKQSkfyN7tgL7FzEr2xM9jiZoFzC++XEad5cl8uyJoXYSAa35dSvdvq81ONwwDNXEGaNZ1dxHoMhBNI0b0rGSsO2XlIef6l0mtt/3x4iL10k8qUB2H4pmRSfPm0Qown2P
 W4ivUmpS
 LM31ZWA/k5Che3pPrc3s7QNiudTmo+itPjVb0ezGs4GFgR14+YHp9S4PGag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/26/26 01:50, Andrew Morton wrote:
> On Wed, 25 Mar 2026 10:59:16 +0100 Max Boone via B4 Relay <devnull+mboone.akamai.com@kernel.org> wrote:
> 
>> The splitting of a PUD entry in walk_pud_range() can race with
>> a concurrent thread refaulting the PUD leaf entry causing it to
>> try walking a PMD range that has disappeared.
>>
>> An example and reproduction of this is to try reading numa_maps of
>> a process while VFIO-PCI is setting up DMA (specifically the
>> vfio_pin_pages_remote call) on a large BAR for that process.
>>
>> This will trigger a kernel BUG:
>> vfio-pci 0000:03:00.0: enabling device (0000 -> 0002)
>> BUG: unable to handle page fault for address: ffffa23980000000
>> PGD 0 P4D 0
>> Oops: Oops: 0000 [#1] SMP NOPTI
> 
> Thanks, updated.
> 
> AI review has a couple of questions:
> 	https://sashiko.dev/#/patchset/20260317-pagewalk-check-pmd-refault-v1-1-f699a010f2b3%40akamai.com
> 
> It flagged the same things against the v1 patch - maybe nobody checked?
> 


"could a concurrent thread collapse the PUD into a huge leaf right
before pmd_offset() is called?"

No. Collapsing while holding mmap lock etc is impossible. That's what
the comment says, if there is a PUD table, the PUD table can't go away.

Not to mention that a thing like "PUD collapse" does not exist.

"Should pmd_offset() be passed the address of the snapshot (&pudval)
instead?"

No.

"Can this loop infinitely on unsplittable PUD leaves? ... For device
memory mapped as large PUD leaves, split_huge_pud() does nothing and the
entry remains a leaf."

split_huge_pud() -> __split_huge_pud() checks "pud_trans_huge()".

pud_trans_huge() is mostly just a check for "is this a pud leaf". RiscV
checks pud_leaf(), x86 just the _PAGE_PSE bit. PPC64 with radix the
_PAGE_PTE bit.


So this will match any PUD leaves, and the code will split (here clear
the PTE) them. As long as pud_trans_huge() is properly implemented by an
architecture making use of PUD mappings. PUD support is guarded by
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD. It's really just the three
architectures above that support it.

(non-present entries might not be handled properly yet, but we don't
really support non-present entries on the pud level, so not a concern)


Great waste of 15min of my time ;)

-- 
Cheers,

David

