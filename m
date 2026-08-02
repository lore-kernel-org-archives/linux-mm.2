Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06E48C55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 11:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B685B6B0088; Sun,  2 Aug 2026 07:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B196A6B008A; Sun,  2 Aug 2026 07:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31896B0092; Sun,  2 Aug 2026 07:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FFF06B0088
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 07:28:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0041D1404A3
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 11:28:41 +0000 (UTC)
X-FDA: 85056106842.19.7A7475B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6EE3D4000D
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 11:28:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bgj/n6JE";
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785670120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=STGiSUapaesQF2K76oCI6wHZd9Cr8woUwKiuHNgdKL4=;
	b=GYYkZ7kSErx43FZkWnwOQg9/B0cqD7JVePzhQgV669WKDmL7pvOMp8RddM36PHQ+ZoJuA8
	pj/u1QH18Um07orw+0bWH0cJY8ZbqS4k1zsOU3dbCrjjh6DntWFkWXBMkJSH6g7I008duT
	c9NpJBrp7ScxG8UnPOquDFqqFjazTOc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bgj/n6JE";
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785670120;
	b=qz9igtC0C8RPS61cxlERjjejNBvaCIBFxMj+GILHN7KCWWSlvZocy22luFW+dfje2odT8O
	IDWTr8pfrY4B0nujKV6wZUbE2LghqBzPtQbwKypBfyLVORk9UbPTlEJCeMelrHS3FXlsDJ
	00GgjvU72bs1mAt1Z/6ocJh5ieQg8Ek=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0FDF76057A;
	Sun,  2 Aug 2026 11:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723901F000E9;
	Sun,  2 Aug 2026 11:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785670119;
	bh=STGiSUapaesQF2K76oCI6wHZd9Cr8woUwKiuHNgdKL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bgj/n6JEEEDbd7ZONPgf9sWUyp2q0zCHD5DGDiLPtDCCeXXxHHnQ0MgseRuVbjK2R
	 wzUCfFQzRGWTiFuz/t9GTBfimgH4W30WZsfZh3nEYJ1o/tpHnHYujn4C6NExNR6oYu
	 POXvBVfY0egTeSd5rpRgbA+ldG/i4ioUZ2xRgSS4PmqQUCo8bat9fcxXjLfmBkgZFq
	 voXPsmDhnlt0HQGunKulmHWDB7Ickfb3LoUWTQUSdZFNh7BmCpG/a85jZc8NCcNnkq
	 A+4mNpmTgxQ8tKgyCX81yFWteNYHiTPRxSk1YPVfOx47bvbXCO/rv4HflO+AJ9CKSF
	 g0RblB7MwS/IQ==
Date: Sun, 2 Aug 2026 14:28:31 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/22] kho: make boot time huge page allocation work
 nicely with KHO
Message-ID: <am8p31hKToQ3WfMT@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6EE3D4000D
X-Stat-Signature: z8jusdaipgfa1dwj3coaeennyepe449j
X-HE-Tag: 1785670120-801793
X-HE-Meta: U2FsdGVkX1+95Y2Bsgju/2p9xNXv9ovZxBGyl/Nxe7GEqduzHcLYRGLsyr3n51uOqTDN8qve2Hu+9i7fvJ9nm8Pg7Az/oc/AX6GNUbgsqbI+dC74p9vwDEjUauZ+QO69+v9Z0U4ricaGfSJzvVmGuGmKtgJLW/Xn66rbwXWXARDkafliRKBnP7K38TsIih6mBGzxlks0IGijXrTReW6pNRl2lkNaBdZYY5MrcU2VncHpeDng96n0PaoQFITL+GKzRUs4JLdCw1bqLIAslL70it8ZkTE7hLmhEg3//JGwNdL/lz3/pd/jB6FxdTOMS3tMwRqhKut6zwYoYVMvHl6QDu8zHelTe/9P9DvBNmHs9B/jEAMJ/6XM1wNCn/BpmSwY+QEAMHM7958mlPBbg3HoYIREnaL4va1Ji6sApGGluZ8at0CpHLzu3CY1sl6KSWXjBo5QpnJiF2v7Wmo4LNC+w96Msk4PiysEQ9MhGbusUR8EyMd543T24wMtH/6t33GHy5j/TY0gVpmxH2eXDLucL+jtmVMdQoJeh1a0FCdP6LoPo4Qan7eD2Or9ytxoW864pl2AQZW4cWFPv1uDY/RDuC+QIuJlFNdm5jXmWqbHHr/Aqb6O8CtPafK2vrQy5WfXJGi8SwEEv+I0fyWpTWTcSoOnVR5qx62n8YO2MijKM3UCaPnW6Ddjgh3buavSGEP5kXFE8UggrNvzIgDw31odafsBz9TjBJINF/31xb0xyAnivyYhEe5DVK839NLR2sII+3TO/eAZLzwGEumhZTpkMspA6bIvX38hwfEN/i9fYmeVTnB3l4oA2svhZtFCm+Ey6Jtwj3tEEYdXBBRnpURxgtarLoRVYI90IprEDrH468DIec8E76dT1P8VaL9dAFQGXA1sz2xO1L6iFA2wQP8kFO9nv1M1d/PlE9iCk7fxYpmy5eozhtzpkN0ty+loMX4s/zrMw/6Oe9dO6eWCGb4
 g2twFQNJ
 tobkZlp5r8M9a+yNFueAGaoLLC/NdunSRTykjz7KhkjB3oN4z93K+08NtUooSVKQtKc72ioT8HKXh8Rs1uIA6dFFMEZaJA8eJLZxTEGIk37CV6Xr3p+mtDqEwUTLHC6pz5BHHXGyYyfhM4iJ9dbXVwIDPsG8TtwD8GlunstLmEC3T+DIWc/iLsn0JBdBDWYEXwYsTFqo79zWYeD9A9A8UAwzSJBj2pRfxlRQAl5N905shNTAuRGhh8voBQy3O+AdL9JGnDFQi6FRqa5IoG8WdLiGkEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 01, 2026 at 10:48:09AM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Hi,
> 
> Gigantic huge page allocation is somewhat broken currently with KHO.
> 
> Fix this by introducing the concept of extended scratch areas. They are
> areas that the kernel discovers on boot by walking the radix tree and
> finding free memory ranges. See patch 10 for more details.
> 
> Muchun Song (1):
>   mm/mm_init: simplify deferred_free_pages() migratetype init
> 
> Pratyush Yadav (Google) (21):
>   kho: generalize radix tree APIs
>   kho: make radix max key width more obvious
>   kho: disallow wide keys in radix tree
>   kho: return virtual address of mem_map from kho_get_mem_map()
>   kho: store incoming radix tree in kho_in
>   kho: move all memory retrieval logic to kho_mem_retrieve()
>   kho: add a struct for radix callbacks
>   kho: add callback for table pages
>   kho: add data argument to radix walk callback
>   kho: allow early-boot usage of the KHO radix tree
>   kho: allow destroying KHO radix tree
>   kho: add kho_radix_init_tree()
>   kho: expose kho_scratch_overlap() to kexec_handover.h
>   kho: initialize kho_scratch pointer earlier in boot
>   kho: initialize preserved memory map radix tree earlier
>   mm/mm_init: don't rely on memblock to get KHO scratch migratetype
>   kho: extend scratch
>   memblock: always include KHO headers
>   memblock: make HugeTLB bootmem allocation work with KHO
>   memblock: add memblock_reserved_hugetlb_size()
>   kho: exclude hugetlb memory from scratch size calculation

This is applied now to kho-scratch branch in the liveupdate repo:

https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/log/?h=kho-scratch

On top of mm-stable-6d098029de09 branch in Andrew's mm.git.

-- 
Sincerely yours,
Mike.

