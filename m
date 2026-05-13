Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4471DCD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 17:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7BC6B00AF; Wed, 13 May 2026 13:28:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE7A6B00B1; Wed, 13 May 2026 13:28:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4226B00B2; Wed, 13 May 2026 13:28:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD9B6B00AF
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:28:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D4661C0FE2
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:28:27 +0000 (UTC)
X-FDA: 84763080654.04.FCE43C5
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2722D4000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:28:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ezdi5CZG;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778693305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/yihlsgioa3tb/oK9ngpjlNZtNgbvgaG/p//opnvnk=;
	b=WDeEF6qofa9luZ0SReIZTqNGO7lDeTKg6X8qpi7Mv4D6i4dwr2UIHH8WgspZwjoVyYECL4
	z15cprViWxi3+MKMUUQFyESz1WPmdHMxYBKH/8k4z/bVTIddKjgVMPlF2WXJfi3DGOrLvZ
	q6iVGt4z/NKIVlWBAacp8yxqwJIR9Ws=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778693305; a=rsa-sha256;
	cv=none;
	b=kx2hDCvjGEagSG+PC0OY9pso5/fjgs16VhFtY0CGuvVjG9bQ2AR8sQ++SirSQ6LMDaFxae
	qUoflfgL1f7pJQ34zmvwczyLv6a5bh7H8WiqHrbFAtBWMsRU3/GqGCbYA3Xj+sv8pdIK90
	DUJgncmotR09Azl9igVobXJ2jqedtII=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Ezdi5CZG;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8bb09239328so58389876d6.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 10:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778693304; x=1779298104; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k/yihlsgioa3tb/oK9ngpjlNZtNgbvgaG/p//opnvnk=;
        b=Ezdi5CZGUVD8ZuVNLChJFNK+365D76zD7ncAkPsfbOLgy1Lv9bFKNWkNFsPrMfqW5X
         Heg4SgrnJqyxo0s1+ad1pRnybKDfbnPNewsu2UK4tp4UR9cNs/PZ7Yld6s2cjAi2BwEc
         8C/YLfevt9e3Vc3dR15HgnQVlyVFpF0BPbL+27CaeduuC2AS0NN4M5ez4xMLuMvIgM7T
         EUtmhWPlVjVQR4GL6UKoGiR6QtPj1rKdszUMds5mdE2fvACA9mt/82NLadIkQF68M+7P
         iUgWJv0Lk41YZcujX1NHlhq0qEuTHKV0k8vy5pgLITYAweEpI+4yBBWNk0Wt6IbUDX/V
         WnzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778693304; x=1779298104;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k/yihlsgioa3tb/oK9ngpjlNZtNgbvgaG/p//opnvnk=;
        b=ctY5UaRlqKsM8JPWZgz884p5opPzN42kpLJgOYcMLTLVJchwhHL7tDFfJRTFMsed2Y
         K0Dyn5PrYnltIHnizE6dtKjMklsGrsWy1q6QVC1ef84DRMyQfQYJiZFlbGSQEX14GzGu
         lQ9YwGX7CixhVdHAKVCUQ+kP38qZvcvFf2nuVvrG6yNUwU6HarJ6xScOF6FfP7jPiB3i
         2QLWfih0Nlyx0xq71+ORDt1FdQeBpDSc1Az60WS+zykZ6HaPHw8S3D4KMmw6kqlxKfeV
         dObW1LxUgkEi2molTa6aXQ5DOKPd38sks1q5StSAiazWHq/FbjgcuaAMmRmgFJdbhlO7
         L8qg==
X-Forwarded-Encrypted: i=1; AFNElJ/ApX98qPetTTmejC7POpJX8Bnn0wqoerecnKM0PYhagGoAIRvtt+bbfBlCRKWC7/f67Fw7ld8vbQ==@kvack.org
X-Gm-Message-State: AOJu0Yw0r2X7Sd5ofPOQ0P7GWsr+7nLCYpj3lU8WT/10NWkL+u5hmvja
	72wRiWjd8wnonP8mnTwleOejJIVEhJp8sxsnEq5C4BFEjr0mTzLGKN5YwG75s1nl7MY=
X-Gm-Gg: Acq92OHKfu/LiBnalVS+WlMDqrOHE6e66/UTUwQ7eLL40TiPdtSWP+xf3zUCG4a15ha
	Rri/druqiXTg/UrXCYPA7V2NNfDvw0c3o948T9jW8SL9jLaw4TQQGaXesUJgW5En/KZoqT759+p
	jQF8kv5Wiw2M1gakXiLSYiOlQIjIoKMooEFSHeXbF8do3Q74JWJrt4b+6GURrl9rv3DtlTRimwT
	ctXDtFF2FQCGzw08CaAY59FeRQEHEjwKR5dgCHFQ7ACqmXUC+sI2zn7i87Ir/K86VkeKHP7p4Op
	lyyfLoQjmfppZLhn+Kcyl3UlZYbZ/5JdfO3UYnWaju+vkEdb1eiGQaT/xPNeKbPqADyt47jV5Tt
	icTipj6jNszn93PTua69DydW9Zr6nVibyl9LH+73Xt8S6YhSRdiBlW5tJwON2rsTW/XCD1yq9aZ
	vQLuBRAMpozLeamrrYT5Gr58BXgX89Q1eK5NsZ1FYzZdcxd3F1Lhm7l7HRPWS8UTtJyEDvv5Lbc
	dfN/lJqLS0u
X-Received: by 2002:a05:6214:4289:b0:8c2:f420:4d60 with SMTP id 6a1803df08f44-8c7bcfed2e8mr70315806d6.38.1778693304138;
        Wed, 13 May 2026 10:28:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c90b2dc4besm1311466d6.32.2026.05.13.10.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 10:28:23 -0700 (PDT)
Date: Wed, 13 May 2026 13:28:21 -0400
From: Gregory Price <gourry@gourry.net>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, rppt@kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com,
	reijiw@google.com, Will Deacon <will@kernel.org>,
	rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
	Andy Lutomirski <luto@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Subject: Re: [PATCH v2 00/22] mm: Add __GFP_UNMAPPED
Message-ID: <agS0tVCwESC0rC9E@gourry-fedora-PF4VCD3F>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <agSkMV26nhYukbnK@gourry-fedora-PF4VCD3F>
 <DIHPURUMTESI.1LP37OYJN1N31@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DIHPURUMTESI.1LP37OYJN1N31@google.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2722D4000F
X-Rspam-User: 
X-Stat-Signature: zx4dsap9x1yzkqrqjia4rqd5dq6su8ej
X-HE-Tag: 1778693304-292085
X-HE-Meta: U2FsdGVkX18sPh87JbE5bKEQUhlLZTNF6vT+/J5BUoqGBfBI38LLaUl4t0M054Afjy+hp1E4y44nRcSj5y41kVxskB7S2Yi0LQrXXIq0nezhz36S3En+9tB3b4u4/E76zHaskawLBJMI7+mRT8PvEBZ4wzf6LOOFBJvHgL1rFyKRahJKugfZV2BoZceTHK6FM5e647X9jzfKOlRMq/sEevc9TiTOhbDGC2KVHUNP/R1rHrqKFdBnWbfPB3XkyOvawn6Ej+OVgOZnyYEpwMKmWs7f0UFBBGp606I7tqGYCs/a91TLh15a3vTjF5byyGs5k04rk7hB+5tJfLopQBmg9DBn6iF6uBuuYwysB67shiTZHQuTaCDIW+Cq90AnQkCTU2qzojeOzd5fGOkfj2eJdmLekdV2RKzh3XOBZRgcFINh9WwS1Ot3exypVJ2VqjE+Vo9EdOyAKbtkJaMUlQJvFjLAGoQYauBpF3hB1uVztiiW0FaDPWB27I95xEEPZ+0AzTZ6gaW5Mu2SPXdeZ/8TQYd73qTe51N2u4mYGSR7Doih/FWsLKFMSn0VJK/9hZCz8l5M0WvE5G8E9u3mhHyG2LGyw3RRKwlLQ9VLnieDuq0qrRtKZpi1ocrqwW9sPeqM04mWRid0dOvT2n8oRPbM/b+Y0XyRQtbmNBA2kRu1wdxWccoY2PLNTDCHoZYzk7LV+mDFANnDwG992nYh+1ZCtbA6D9NFxqvVskCunsCPYaePgAlBw11qX1Ay0fkZPOYkNIDP6qzfGnfr2gpKZ5niGLtqXB7OGiX6PgPw1siQuG4R1Sp7L4vzkFM7PTFdJK5Tub/4lh7ol8oDxTTw4uwR9VyaYQHedcnyBaxrs4rsNBTDaf8l/DFfjuoPW0gDocm3vGygt3Wz5Pu/LGVyShm9c5DUaYuyXGi2Biv5ImKJc1bjBQPyLNsWQ5krAUX2tt6aSZMT0alhG3DOo7EYlpo
 1BvuYnox
 r4gv6L8hHFeHaR9eMAiYj+Mhw9fg29eS1vKSphE7PMUXXLHrNwGlP6sm5BfniJ0Dt0LssBZl8P6mNFPF4wTworNnfEHW5T9WyH0TDa9y8be3jHi3c5W/+G+LtI2nauqmhBN7VfEIqLXXNefYVJw6qvmsSWpFOwcP22dFK7Wn0vsCxkJ0z/w1b1kalJmEQ2YedPmAeWLGtR2ClIs8BiegR60GPnOAAUSHmZny2qHZt88R9WakSMNmI7AhxzQ4g5e7+h4x4CPyITRaB59MHjWa+pDPSUKS90BjN/CJiUDwILq6kROAX0JqiPMRdnmQpt0lQ2x34S3+42lGduobGTWeut89j98h+bBDPZHs50XV83gRmNCsMz6jqXF8ptA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 05:14:20PM +0000, Brendan Jackman wrote:
> On Wed May 13, 2026 at 4:17 PM UTC, Gregory Price wrote:
> >
> > Why not simply have an unmapped migratetype, for example, and on steal
> > you convert it to movable or whatever the preference is? 
> 
> Because the fact that only one migratetype currently supports being
> unmapped is a temporary happenstance of the guest_memfd usecase. In
> general, this needs to support having unmapped variants of ~arbitrary
> migratetypes.
>

Ah I see, that tracks.  Thank you for the context.

> >
> > Unless I'm fundamentally misunderstanding something, the pattern at least
> > seems similar.
> 
> Yeah, I actually only noticed that yesterday due to your posts on that
> thread! I need to investigate it further. My assumption has always been
> that this isn't a general solution because we don't always _have_ a user
> address (e.g. for guest_memfd it's important that we can populate the
> memory via write(), so there's no user address), but it's pretty likely
> I'm missing something there.
>

Hm.  I'm not quite wrapping my head around the TLB issue fully.

If there's no kernel direct mapping, and there's no userland mapping,
the stale TLB entry comes from... the page formerly being present in the
page tables and a stale TLB entry lying about after the page is freed?

If that's the case, that sounds more like someone isn't flushing the TLB
entry correctly when the page is freed or unmapped (for a transient
mermap situation), rather than an issue to be handled by the allocator.

I think I just need to spend a little more time understanding the TLB
issue.

> 
> The reason we need to do it at the block granularity is that a TLB flush
> every time we allocate one of these pages is a performance nonstarter -
> that's actually the entire point of this series. If you can afford a TLB
> flush per allocation then you don't need __GFP_UNMAPPED for the
> guest_memfd usecase, the existing direct map removal series [0] is
> already fine.
> 

That tracks.  So whatever the case, it seems like you prefer
block-granularity map/unmap operations, rather than per-allocation.

Do you have numbers on what the cost of map/unmap on a page vs block is?

Whatever the case is - you're pushing that cost onto *someone*, so
having that data would at least let us know the value of pushing most
memory to be unmapped by default rather than the opposite.

~Gregory

