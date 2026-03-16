Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2083CF53D6D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9476B031A; Mon, 16 Mar 2026 12:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4136B031C; Mon, 16 Mar 2026 12:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6BE6B031D; Mon, 16 Mar 2026 12:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7F86B031A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:48:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C6028B2D4
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:48:36 +0000 (UTC)
X-FDA: 84552509832.05.E7267AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0B27820008
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:48:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tfDNQUax;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773679714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HMue/BtNqbapqvyup6rq06duhvxsCfM2He2oPvEiuo=;
	b=zWH9kHO+bhzC3lyswnZHEEMvdGTJjP7i6lrINoug6X1B6oxI+rWtmNvvAkoLYHSH/s68Fw
	68OFQ7j3Iu5qveS8cX88j5QcAneuusbThxaFDPgeDIjhaQNVKqez/BZOnz3SzbSjhzVvdc
	xAOmWzUS6ZGhadg7JtJf9PrZEo88o4Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tfDNQUax;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773679714; a=rsa-sha256;
	cv=none;
	b=6bDtVp39deSrvqDIhzZmDNp3aDuqvCH9lZGYjpCQ0nt0BzTYrFB1+vMRZ5KdmzlHPtKWGs
	8wf5vMWcTB5LAkZ193BeCrmyx1UZosu/0cEmynuK33Jv9whgT3cE6qSKk16jHaBfh097WD
	uHr7zKk2SJ7y48Ync7vdk71UnVY4i1c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D120C4190C;
	Mon, 16 Mar 2026 16:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3519CC19421;
	Mon, 16 Mar 2026 16:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773679712;
	bh=WuhfP0oahkZFMDr9DJw5bOig+EPYbiQxrAUeY6rjrp8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tfDNQUaxol6LRd60RlzKMPBwZeRswtt0gijLKRle/y1Gh2I8LCYZPLlSGuyVRuaXo
	 51KnhnRizLNklEFx071MubuAC2yWZkUVVvh54WEZaNBLoexRQsc2eG26lodtQXLGlM
	 oI/QKSm+xuFjQlMaAei1lExj53BlnuTkSXYqRZCwHwg9R/WwTh2j9VA8fpTX4uLXV6
	 jPdw41sY/fP161N7mgDB0lonw74jjjnDVcu//OG7HFE50IXE3C68Lf2V+z7mwJ78Uy
	 npy24JfcTGg6xdNBU+M2rp91Q0ZhlJLwe+IiGGd2raRV+o+sh90pV6lVkRhLAe5a0K
	 A9yNbLsJuqUOA==
Message-ID: <4e52f70d-e0c3-471f-8073-68c0e9bc94ca@kernel.org>
Date: Mon, 16 Mar 2026 17:48:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 09/18] mm/hugetlb: Defer vmemmap population for bootmem
 hugepages
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
 <20260227194302.274384-10-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227194302.274384-10-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0B27820008
X-Stat-Signature: w4fwpss6icb9wsfsjfo51ys6kgrs4fpf
X-Rspam-User: 
X-HE-Tag: 1773679713-343118
X-HE-Meta: U2FsdGVkX1/P8x9C+6/VI3+tVtaUsfPhJ/iYgfkftjTR3+GsUp9XUH4UY/bxlxysFql68GC/8AYCcLeTTmg2YOQyl+DsGQjAYSeN+8qAOzJudVxHNTrtMzqBX0gzckpMXCPymM0FzRcDZ+GPqR3YMzj4ZdrGAHS+kv5uZ/FuB75fdcky0tkaFEaiffq/t9Z648KTybQp4AhjhhQNtDjEfKGEzlcWTgQtWmavtauM1a3GR13/XFskmx1yMQ5yOonRbKb+NO+oXBqoizXzFfhgzO3MGWZ74s8fmFwIzOv2AOmwqdymEppvd0Vyy3WEThYgkeRCpoW2n3o6X+yF3xpuO/VmA86IhFk3EuaO4XsHQgehM3pfKT25XeKBUx/cggJaPJ+TMUBY7b70fGRCrws2MZMyxKPhw+bmJEWuPJfkmrQuXaEinl1vkvABa2IXg6IfRU+Xael4aCt7Qu2g9lu38wSjsgB4W50IlLCUavvjtul3ZLEuQ+AAMGi6zGTXE6xq8iyiao8apF5woLUQMCarWLHlUBzk9oBChSpcisElelPNoghmX4c8UkxLjpNIQ3GimPpkC96Z1P/EAfsFra1yWoQeD2bFjbX/Yr8Y0uBiuGlgbEq7FXXor8n8aHFRpmpIl88FM7kcIKnGldr7WagRwNrJJfCPQX0gINhbwYSQTUmezHh/e3MbJ+8AflwWzUeZqtHQj742vrWTrbYz/8tWWUPIH9zZTwu99NwctOqeBQDBGs0aT1WqYf5o45x9D4Gvj3Ace8Faa0Qv/6TzvtU5gZxPXzXRh+SrYn6w3KysrNf7bKYaLcR/CldUCcIJQeeihM8gYO3HXc9U8zMjBmfBDTmZJFZfPa/a5vMfcp8cOK3T9CRW+haqOf3MSxgSP2gOZbrf8r3Wu1B18xE1cIp9dbM9HQpy2hSUCOdcNj7x5ttQnxV6BxA8xvoHox9PFXU/1fdmGkPPxESMxfNMbkR
 41I1uxbo
 PQFo582nuWGoOLGCsTRSOUwk+/u4oNxpkzGFB0sw49PAAsi9R0qpbaSRgKFruIy27rCsnpuqcJIG3WMTpYBasfUaAIlhkBFFojfZ0MbDCoDqg0ty1Hyi3+CmZQkwCyJIffYWlBGfjzw0Eyaq1do3PFhOEGmyXgOFCDYZys07heqMaRmLsY38bEGdVW7Y4ZeK7gd/uQDDtUR6cXCHFMrobdNPWgOrC39fprVprL4Wv0OFa2C3b7rabRGaVCyWxEDpfetxJUff8ir24z6fqRyrRhbqvg71inTQA1D6K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 20:42, Kiryl Shutsemau (Meta) wrote:
> Currently, the vmemmap for bootmem-allocated gigantic pages is populated
> early in hugetlb_vmemmap_init_early(). However, the zone information is
> only available after zones are initialized. If it is later discovered
> that a page spans multiple zones, the HVO mapping must be undone and
> replaced with a normal mapping using vmemmap_undo_hvo().
> 
> Defer the actual vmemmap population to hugetlb_vmemmap_init_late(). At
> this stage, zones are already initialized, so it can be checked if the
> page is valid for HVO before deciding how to populate the vmemmap.
> 
> This allows us to remove vmemmap_undo_hvo() and the complex logic
> required to rollback HVO mappings.
> 
> In hugetlb_vmemmap_init_late(), if HVO population fails or if the zones
> are invalid, fall back to a normal vmemmap population.
> 
> Postponing population until hugetlb_vmemmap_init_late() also makes zone
> information available from within vmemmap_populate_hvo().

So we'll keep marking the sections as SECTION_IS_VMEMMAP_PREINIT such
that sparse_init_nid() will still properly skip it and leave population
to hugetlb_vmemmap_init_late().

Should we clear SECTION_IS_VMEMMAP_PREINIT in case we run into the
hugetlb_bootmem_page_zones_valid() scenario?

I suspect we don't care about SECTION_IS_VMEMMAP_PREINIT after boot and
can just leave the flag set. (maybe we wan to add a comment in the code?
above the vmemmap_populate() ?)

Nothing else jumped at me

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

