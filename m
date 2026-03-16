Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CD67F53D6E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A3496B02ED; Mon, 16 Mar 2026 12:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770EA6B0301; Mon, 16 Mar 2026 12:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 673C96B0309; Mon, 16 Mar 2026 12:31:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 55E386B02ED
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:31:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE6D7160311
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:31:53 +0000 (UTC)
X-FDA: 84552467706.27.D44F530
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id EE6EDC000F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:31:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bk9S8whD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773678712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIRbWDKtKNcpRy41cBty0WzRmJNX2DMXA0FO9+9q4pI=;
	b=czUImxRBz9T2lakOYEiu/B1DzQCUfHcUZgcdsVhYNGNkLBRMvAGvMdDAG/7VhfRLiDpkb8
	uPvhVsY6mAg9qwzPtK7NUIIowb80UUq0bnm0X0Hl5VwzPW3uZO1uCr/gwsnEk5h16xbtJm
	UMO63MaMGALSDz+OYL7CQt/K8AT8Iow=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773678712; a=rsa-sha256;
	cv=none;
	b=zNpYb9VV8eKO/lYiITmZMuiIl2bnf4owJDbJdRvJQEjdbfXGOMcONSuOzkP8xdP7LYfyX7
	jUBgIZF7gd/OE2Xpq6pmion2FF068fUiWUsU+XR/n0bGj1DJQ5AYi8D8pxm0CqYzKpvDpf
	jFgAgQ1Zig5M3DwBEQ/XY/Bs4rUdV1k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bk9S8whD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 27CFA403CA;
	Mon, 16 Mar 2026 16:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00A0C19421;
	Mon, 16 Mar 2026 16:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773678711;
	bh=9tTGJ8xmnCXmNkktqRH7NLuhVDHU2e7HFmvsJCGcDrU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Bk9S8whDQdEnqW8ivoY5HX7nZMwZc0L9+aRbd+FeNHoZjTq+j8OGcarcdrT1AG40R
	 nrrLY+QC/TTcjOUasLpldywlhcZfBWmtht15G8LlwCB1WxLv9OxwvdpkbqX+76nI1I
	 sjvnlEzt04Qkv3r0ZYl8hjOEgyqvC6kkELiiNLPbY6SLuXv+CRpoEZR+raUtV3KMhR
	 Znw5eCXl0BfAnswB60wy+5Uz6imrsnGy/LwDqJ8f8LzRBAESWl09x1ti+wwAfQymsm
	 jiLUPufNOanffV04CImNSB8s8lrBQUPEk8IeHdtQzKWkUwe3ttFiz+MU8LxWna40I/
	 wUcm3gK29qIWQ==
Message-ID: <488499f2-3e3f-4377-bc28-40ff7f5166ec@kernel.org>
Date: Mon, 16 Mar 2026 17:31:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 06/18] LoongArch/mm: Align vmemmap to maximal folio size
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
 <20260227194302.274384-7-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227194302.274384-7-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EE6EDC000F
X-Stat-Signature: 8zquxhbonrf6ntj9tcf7rgtb75nx8zur
X-Rspam-User: 
X-HE-Tag: 1773678711-308686
X-HE-Meta: U2FsdGVkX18/B/pVesRLUf6oIIWsmmYGNuR9eo6pn9JrCAbtwVBkwaMQKMsuffmBF1OWY8Dv7RXnH0PVX8S6YPSbCi0jhME857mBsUwxo0s3mVbGPZy6oiyj8P46d/RrjuysRUKxXMOMfQUMyyh4a0Rnu7WnmDK0IIRAhhXwwiKCEEh1xCxn0jJN7BstUE9WhJ4C25GB+rO+jN3qkdDB6czmJxRlYl9BM6ClHXlYWgj1mAbon/v2DuxyPfLOZo9tK0N4XT4fxDLMjtMMiGCr7r2v3J2ujt6W/+zY/hvd9HwUReDJnCJ9FbzUJGUqOPybYzgTUZ2erTNHzM46M1rfXedkyi2M3JAHJ2G8TlYTxo7CAdR5N0NUB02Suar5K3Lu3LU9OmdsPes/PIaAsEVD0XU/tN8zJyv0W3xgZq+0lrCa5YQgKfq47Scazb0jrK0WDwZSteVZt6s9L0llOdhRWrtwz4NZBP08b2ITBA5Cx551O2yfLmxoaoYyvZRRmQmUADuijUoPEQWCfoWwN9YZyYp2nsUOwxTTWokxCMggbcwr1nlI/oc8uA/5ItjYdWJXVetajfVxv7un8eVlUSEfLZn+5OcSIt+mCY0dkszbDY6bmqUHFtsA0feCzKWYoPj/wzcq5ZxWIWIjU4RR4CLbqT4FoDIgUqim7Hlqwb9k1i+o4cV+G2c65VtqrVCWb8lBAg8eChuJo5WJR7KabUfsf0+D+tLTX9S4vtFicGixSUthvQv0tX6usgQ6qi7GCgJuNV9PnD8zPZpYnf0GXcuDrQmXQrTVk4qvz7A2b8pAC77s0NXEJG75U/frAjyyInm7ifNmFqPXeSgdbiyfrIxM7gr1edicJAF/ABeDQ6zJL7/EPopDF+EHGePCJCfCHWueOWACUCf9qhnFTMFoaweHtHozXIvw0SzXcCoeMvbAQoqn/nYvG9sV/2fPsaRUVC/ThiiCoZ6vl81LOArpqjK
 G/QTcbea
 6c9/GLYPeL9L51faOcXrAqyufOyfK7uH6lzf9YxohWuZ/zyL/XRt/Cfq6Mx41RInEqFxJpFmxLjYwfL78cyC3peYhkocdbU7y40ER+M39nhE7qp+/KfH53cNlLOHe75q47axaXu8d3KlyRqHSFkxrXKfwvSSA5AwNtSvrDBiVzH0E+XQgNJnkyNLykHPxex2G4QbrAwh1Fdeqb76hKihy0AXH5vXHNp/tXiTuHn5uidsTqeiVg0GYqlXIq8Cawn2eEKvPqeuGAp0UOJbHlonMxinjZ5l7tGE3+lfH
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
> Align vmemmap to MAX_FOLIO_VMEMMAP_ALIGN.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

