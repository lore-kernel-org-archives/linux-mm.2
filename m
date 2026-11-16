Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 126FE606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 13:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Q7u+38pp
Received: by kanga.kvack.org (Postfix)
	id 32AD36B00EF; Mon, 16 Nov 2026 08:34:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B5186B05B0; Mon, 16 Nov 2026 08:34:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17CE66B05B1; Mon, 16 Nov 2026 08:34:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF41E6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:34:19 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6D84DC0981
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:34:19 +0000 (UTC)
X-FDA: 85441076238.26.4C76C62
Received: from mta0.migadu.com (out-101.mta0.migadu.com [91.218.175.101])
	by imf30.hostedemail.com (Postfix) with ESMTP id BC14380005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:34:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q7u+38pp;
	spf=pass (imf30.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.101 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794836057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFki2hBsnHrC0juVnTO+KTiVDm5TzD8rtd8Do1S8nSI=;
	b=hGhAFFLPesW4Ud8Y8JYzIG5KT7bbLSP24u16A0+zrfY4pNb5rOLLIqG0yoWaRrUsKzmM1s
	VBmpeoRlHUgemzv+j5SUa10x/p8Q3favEQWa/oPKKlDxEk06vhJEK5JkHAyrHAWanDjW1O
	0vH6YoBDJu+mmOJDGpsYTWWtfiee+V4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794836057;
	b=s6xru4rcVYhmforwZIpdatWkfxyNkB0gmff0TPgZoAy1NQMyhxp+hLvIr7CAuY3FSsPLwJ
	+B/mU8K2/JBkqKb8mBMrpCcgFUTBOiEQLHQbAxhl5bakdr3VlFFkvMizPFUqLHLeLSHLJR
	c9LD1ECiplIdFujq5jO2wwf1I/ku27E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q7u+38pp;
	spf=pass (imf30.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.101 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kFki2hBsnHrC0juVnTO+KTiVDm5TzD8rtd8Do1S8nSI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794836050; v=1; x=1795440850;
 b=Q7u+38pp5XC+YPIVqWpkLGqTyghK8TPQV2unOptiSNUh4AhOmLMHq1r0Sr0FN7S/h8riTict
 gllDCHLPvukfliGDgDN4xMqkKY4J93oGU67+rfnUBjMvgjvopCheleNoysIn3316bfsf4e90erY
 Oiug0mos7uFVG7wfHkE8FTno=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c87e77b9dcd63afd;
	Mon, 16 Nov 2026 13:34:10 +0000
X-Mizu-Trace-ID: c87e77b9dcd63afd
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so10080e87.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:34:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErG/Bu+XZT9xsqZWV16+KT5F0nh1Jh0iTrPEUGEqoFjejvzgoZHgGLX4FeJSjAMn56+6NidLINA1Sw==@kvack.org
X-Gm-Message-State: APuU4Z9poPZOePQ2gjG6Ba7Dt+oAneVsN8k5J27b0vyfliibgKnua+E2
	laOTN+QS2y3RpS9Vmgvkop9EMurqvjYFcfWvJnOyvYxYOr49ZTOfw73Swv7gCfmlvR/2lkByMyV
	n597X5oBEghrvzNfyUt5Z8QTfcuCWl5gInDUYvcCA
X-Received: by 2002:a05:6512:3087:b0:5bf:b994:6598 with SMTP id
 2adb3069b0e04-5c17d98271emr226475e87.6.1794836047954; Mon, 16 Nov 2026
 05:34:07 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116091137.94252-1-aneesh.kumar@kernel.org> <20261116091137.94252-3-aneesh.kumar@kernel.org>
In-Reply-To: <20261116091137.94252-3-aneesh.kumar@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 16 Nov 2026 13:33:31 +0000
X-Gmail-Original-Message-ID: <CA+EHjTw7QzzkQYKV3jyvW5mqZQMenTfm=kus9i87tYqACDOv0Q@mail.gmail.com>
X-Gm-Features: AclHuK93q6K13zN84KswjEKi9cVQgC-Cy80dn3a2peCMzM1qEee3TapGEGzaKvg
Message-ID: <CA+EHjTw7QzzkQYKV3jyvW5mqZQMenTfm=kus9i87tYqACDOv0Q@mail.gmail.com>
Subject: Re: [PATCH v10 02/13] mm: Zero memory during shared memory transitions
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Steven Price <steven.price@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>, 
	"T.J. Mercier" <tjmercier@google.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, dri-devel@lists.freedesktop.org, 
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: q4pc41t6wpmkbyin517zx44kui5qbk5y
X-Rspamd-Queue-Id: BC14380005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794836056-262716
X-HE-Meta: U2FsdGVkX19Q3lQC3FIaBrG4MpG86MUGONlffIDhilpFzUcwl3gKXxKK3cfNMRaoVQvOebZLO4NboZH9quq03U1u9LiTbyAUF/cK5gE/cHB/xQZHaFCD1UUj6yJ+zw6UKtuVcT4/NaGMhgs6B9pFW+lj9Nd76iteVfiujtGpbWlPaS0ZZkTIeWER16VZdWOu21WUSqjR6dSob5IiaikwFFAmhHlvCUArIcUyFFCLnPOBwYznKZ4K0NX+wdyVv/CLfXtvOtv5tMrjUbSz3SFeQnGmZ5s6vqv83aBdb1zI58fed79OaQgAoAsgwIwD1ufqtSFVAbubjS/iEBzERiXLUKPRjHtL0zuJZQRRO4xkLJ7J9Ax7+2S8zQ5QU48GL+gTXuXGCt3r0jr/0RTrBxhKNOapQIiV6Lj81zexBfJWTGWXgrYdfM2tsKbX74dtulDY23tSnRodXyZwb4TyLaLT1IM8ph9PNwtrFb3LDpmpXEugww9LnYuTpgC9XCBPSB9ZhqkGTDmiaXzGeohEclTJhNagHvkXEcvx/MYuZvAmCkF7lD33FG1rBSeJWeeRwjgTEPSMrSKLDwnh8xTrdmMqti3iUIXOwPC63L1wS1y5Ke9OgmsV9Loi+2Wrd0F5zBwAXWW6eEeU2zVnLFcVjW6RIOdnRcifGU0PndeZqK2n9/H4CtyALmIoizxKSlhgoSUuXG1r+CQNtESXnY2F1h7pJzZQ1O+dJpKOEgoInhj0EnOcidsNFojgg0g7IMN6rALe5eFq2JaRgfgtsJW2Wu4gGVW8MKvn3JIGO6U0X7VAeqvGVqbVffshxHLayaEbBO+yocd6VrVu/JZjz44nTjsDY2Q4SbNwKOstXt+SqMAdodX0qv3e9lwZW5myTx+/jy+ePRAWenKyvHMinNU3hDj6F1yoFW22h0WXj76K1R0qZoid18JrFrW1MrvsaOY55LoA/hUebWVk7W9MBjNzPXJ
 FRfMLEtR
 Q0g90x1h3Z2aizA9nSrlpdYsFAIyuA2kcUWUbcrmwlUpsimZuwPUPviPuu23G2Bk7w+ZcOTB6MhJfxCyi5tpDFqvSjWyRq9zhkUoqJ0VHC6lQF1p4SvSe8XPxfzjIQGlNkZCi6lc5oUBjmBlV9uuGXFvv/rCLgKUMaG5KHRdQWLE3URyOTvRck+TQ6ZAqvC5JGHQNoTxx1claqN2Wl5APti04dYtZtnSIsE54D8GaIB2UEobDTJF6aAur36N+eZjG1mNQbtqCt4lWZhBDtUtNApvKhPtElNBtgXyeAqZ45UW6zaxZ+Lp6tP0wh8qJqvYJ5WABEJw5Zxdidibb3GabgC3DPgkIoAw9+Co2vUaVS99FA1OdlVvwjBbi2je9gqukhT+z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Aneesh,

On Mon, 16 Nov 2026 at 09:12, Aneesh Kumar K.V (Arm)
<aneesh.kumar@kernel.org> wrote:
[...]
> Keep allocations on platforms without memory encryption on the ordinary page
> allocator path so the original GFP constraints, including __GFP_ZERO, remain
> intact. Remove post-transition memset() calls that are now redundant and
> explicitly clear allocations on paths where no transition occurs.
>
> This intentionally makes every private-to-shared transition destructive;
> callers can no longer use set_memory_decrypted() to preserve existing contents.

pKVM shares memory in place, and a guest has to be able to share
memory it has already set up, as Vincent pointed out [1]. That was one
of the primary reasons for in-place conversion in guest_memfd.

Cheers,
/fuad

[1] https://lore.kernel.org/all/avro44jUWOARFzul@google.com/

