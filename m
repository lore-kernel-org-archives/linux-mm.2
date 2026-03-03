Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B33DEDA6A4
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 16:52:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6244A6B0088; Tue,  3 Mar 2026 11:52:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1986B008A; Tue,  3 Mar 2026 11:52:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5A16B008C; Tue,  3 Mar 2026 11:52:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3502F6B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:52:20 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E556C57AE5
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:52:19 +0000 (UTC)
X-FDA: 84505344798.12.F8F9002
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 03C3718000F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:52:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=klr7DOX9;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772556738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHR9YZ1MRDzAoFsWvBCLWO/s+2nLmcJAHaJM08OxmlE=;
	b=4NB5bWlThT8ZY4zNn5KbrAb+9EbTGbKoUcYkjvPYE1asj3WcvzaX+4+NA/t4oPAlXnBASn
	erfdhSwN1WoXO0Tdij8Kxdhh+IIVvre1pQBfGQ6GX1BmoFsQigCfnx7x7I6kiPDf1RfeSv
	SB59bOmZSqHJnQLhQ/JzGGq5LbUqMeg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=klr7DOX9;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772556738; a=rsa-sha256;
	cv=none;
	b=h3/3374LTDV+qnwKJimRGICEblMthRGgqK/mXa06ee9qMabDgB4Yu36ChFi9WGwQCjgJS4
	85xKMfMFkmziS2SGxlI4XBe9oI0G5q/PF/GbNmvNHJ6j+FMHNg3wp/7BQLeF15fsDgUthz
	ROqvAKvZh8NaUqbdkWNqCIqbAlK/V1g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F1A3840579;
	Tue,  3 Mar 2026 16:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2AFC116C6;
	Tue,  3 Mar 2026 16:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772556736;
	bh=Qn6I79b9anQ0/JVDeoM+6n7E0s13tIg0fpBnemT2nlI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=klr7DOX9CHzFzm6sWy1c0fxP6yxy6lrZYqHbKtF3f+fI+MGEtwe4cZKwqrR/95Ssl
	 Aeua37APry0L/8w0eT88sD2fGPh/4VJH64DXNPH1NS855z51D11oYQRSugFIqIgO1d
	 4m7Neylvc6Tqbn2sY3axAaZTr+uJBW0Dj6jWGveoCzv4ZJu42evjOqA/KXV8C1FCm0
	 93GdR/i2wYBwLiZN6A43ZGrR9gTfLzcoTG6zxzxmN18c30/RGDtUCVBhV9u+s08KmI
	 geGMBdGXOtGXllUkOqkQJ0zKjS7kPIMVmcnsUUQaVp5vA7+B4pX73hHI4vyWeKGOJO
	 O1uScEXbqPl7A==
Message-ID: <df6d4033-0e75-4dfa-a261-3d119c61ef4f@kernel.org>
Date: Tue, 3 Mar 2026 17:52:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/13] mm/migrate_device: Make
 migrate_device_{pfns,range}() take mpfns
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com,
 willy@infradead.org, linuxppc-dev@lists.ozlabs.org,
 intel-xe@lists.freedesktop.org, jgg@ziepe.ca, Felix.Kuehling@amd.com,
 jhubbard@nvidia.com, maddy@linux.ibm.com, mpe@ellerman.id.au,
 ying.huang@linux.alibaba.com
References: <20260202113642.59295-1-jniethe@nvidia.com>
 <20260202113642.59295-4-jniethe@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202113642.59295-4-jniethe@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8ewaytmnj6qphrurxjq1msh5n66z9afm
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 03C3718000F
X-HE-Tag: 1772556737-593351
X-HE-Meta: U2FsdGVkX19CXWzTPcvGXiIE4zL+BaLofr9476AkBgonitAoC/5X3sSZaFsLdYgA2GuhBNmNvYSxJh3yr6l1amhRi3vn6gcJMtxezsWH5jPR0OL7RUY7CeAmNTMXzaoVsO//QccqKzS/wviWOr+QJyaDj608Jvi5bLAeRroco4/sm2GS5m30v8FoBEMSt5MrIsXW5qoFwELEwZl7w2vL7VX6EeLO+bpJBtyNkdgBym6jmEP3bBmt9kpPHIfSvUJO3o0Pcwrm6eqJFmVRpPXHNwc594SLS5P4uftIxeTUcIE/FfA7sdi/Xdm/tw4rrQGpOlephjn2R1RhAVWohFzfLFD0Tt4J7MQBoInpuyMB9fLA+PIQeYETvan1lP+ChLM7VsEpSSZAatgFpIGjiPv7HzeS46CRjhOV1vfBn8BTOdLw205ylUq5vLZJFws+Jthob/bwELX6tKawxop58NG/V2yI6vzlPEOOQnpJ7y8kNPt3ZalxfqhFqavlzV/N5WswQajaN3adeTAYcUbXKEOpJP45L1mgMJbPWCZB0T0lHxz1Sil898sJlIPnbFukHBD1maQ4R9sIyVgAhOdq8A4FUfbJ8V7nI79ibqnSLyAJdKNHHgEk72ciDZ14WUuASglrCT0Bli2CaODqSk8FuH8QLucz0kxItSBBKu+UUd6fGf7xOj+u4iBF+csA5tDHgs5OWtOLWpevQyc6+oFzG5K5Etgur3OSu8d4LJ/Gw7Zmg+rfMHx2LU6MUGW0wTvHfpIZYxpmgyFbWRFyl0+9tC6hg6i/81otJfLR6DRw+/FCGmDGJeg+zp9B3EF3BJjw87Ib/UlPgbb2ZM/DX33hEWAqT0i3lZJTP2m8W0U1Zxhd7in/Qrf5LNOWOZxSoW4p5vL+H7rHNJerxtex/jtrUsm3vgeYudiZRpJRgqkg5FCsQiRNXAR9CjUXuR6YAJzgh7UHyKoJ0Gp3CUrbiREgcAJ
 foqFeSz4
 XliZNN1pWy9qLum0ht3NXr0D5D3ucj/zyynyDQrEdPgCZHnJjbh+EYZcVDx5wM8ITj7jBvH44vKFIRf4z3b2J0vRE8gErhMnrJkJ79REX+CcsqokTZuIZVCe2T9FEKsaBISu6OHqMw7NNOQAkOBPS1ddlrkOEbdV+mNTTf1eutgIC+Z2FRznEx1HS5UpB25ThdS2J28L6fyLGbddITe5jPnVEcwMU4nifFaUPVbD/tISJOWPE9iOnhKSWqJFTFW/UxlEGQX4a9wacVkuI76v12DH5pi52rPiBnb38
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 12:36, Jordan Niethe wrote:
> A future change will remove device private pages from the physical
> address space. This will mean that device private pages no longer have a
> pfn.
> 
> This causes an issue for migrate_device_{pfns,range}() which take pfn
> parameters. Depending on if the device is MEMORY_DEVICE_PRIVATE or
> MEMORY_DEVICE_COHERENT will effect how that parameter should be
> interpreted.
> 
> A MIGRATE_PFN flag will be introduced that distinguishes between mpfns
> that contain a pfn vs an offset into device private memory, we will take
> advantage of that here.
> 
> Update migrate_device_{pfns,range}() to take a mpfn instead of pfn.
> 
> Update the users of migrate_device_{pfns,range}() to pass in an mpfn.
> 
> To support this change, update
> dpagemap_devmem_ops::populate_devmem_pfn() to instead return mpfns and
> rename accordingly.
> 
> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
> ---
> v2: New to series
> v3: No change
> ---

The fact that "migrate pfns" are just dressed as ordinary pfns is
confusing and error prone, especially when we suddenly have to derive
from the variable name whether something is a pfn or an mpfn ...

Something to think about would be treating migrate pfns as opaque
objects and move from misleading "unsigned long" to something like

typedef struct migrate_pfn {
	unsigned long data;
} migrate_pfn_t;

And providing proper accessors.

That would make it much clearer when passing these things around what
they are ... and the compiler can easily catch bugs.

-- 
Cheers,

David

