Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDA30CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:50:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FCA66B0092; Wed, 30 Sep 2026 10:50:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ADB06B0093; Wed, 30 Sep 2026 10:50:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79BF66B0095; Wed, 30 Sep 2026 10:50:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 51FC96B0092
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:50:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C18401207C4
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:50:33 +0000 (UTC)
X-FDA: 85270714746.11.BA7AE26
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf22.hostedemail.com (Postfix) with ESMTP id E33DEC0005
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:50:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QKpxLYqv;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.141 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790779831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H3qtNVwOX7r6mYzIQEIi64injBAtcVX6qzz09d86hu8=;
	b=75TwxkW/dACPbMFIe6JEIdxvo6YTRWTzUalYPQtG4uc/NDM3zC/ifyvd1xtypAdGkTRbqC
	X8ITfLPFgQLERqE3MUeQJuP7oyAjsH5wJxez3JanOU97wutd6SyO/SgMjDImI6pFITnY9y
	N9Q5pDYR30pqh3RFaPr5Ti8PLEyvmJI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790779831;
	b=eWy74SRsbRudVCD3ULjb+vKuFEhgvUf0Qlh5OaIifMonc5jLs21m62le7e4JGCw6bAxeTK
	XMcpxYLJonbVmECfA2EYGGQa4g2xWv5H8/2SgDkFAOEARQiI1yg3ZRnEYctVCRZCrijus7
	eKJhmzhpWhrcBkfEDbWilWEkG+5qAvI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QKpxLYqv;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.141 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49fe8bf173aso29151465e9.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790779830; x=1791384630; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=H3qtNVwOX7r6mYzIQEIi64injBAtcVX6qzz09d86hu8=;
        b=QKpxLYqvMxlRvwOz9ykhqeZNyAzkbCwvSJyy1D3Rq6sJJSEQqmCOX8C3CoS53z2Wlx
         U6M1hBRHt/pbCyD0pOnFukTkcKRYUfJOUHHFKI6HtjcdgvZSHEir9BH98n9MzyI/siBE
         PFfCMurbnaMjGRRTzig8xzk9lU279X00DcEwBuh1wiVHHAmLJ2NtSbn1xnWdV4HEWLAQ
         CpISIEIOGMEw0BYvnEVpqZbjjKPzywbxcGxwMfaFqF9iSdFT7mwP6mH58+dG41brJZC7
         n6EIyV0ZIdOMdGh5bMowy9rMVtQ+zt5HsRYU4Qyr1R9M79Q3Z8e6xa5Z1mdYV+nNCHgh
         VRZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790779830; x=1791384630;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=H3qtNVwOX7r6mYzIQEIi64injBAtcVX6qzz09d86hu8=;
        b=yvyW5q4tGkuWgJzqyBOvZxnUgapOcJAmy/FzX16mbyAlwRjgAjRZzyuV13N8IUjgKh
         JBz5lxUrceLnaCrVE86n8VObF80koiA42I/9MDepJ5tkSLvpW6d9IMd+DBPtKFC8uH/J
         5z/GSs0FtS7tvbZSm2BB20Upg3f+Ywgp8Am/e0NhXwb9hcVgqv/MzPH3fQO/HsYt4Us0
         3H1frE2hxjRkklwx8PQO+qce1gqUEyLq8LrBpgF+Jks0NKH6VRNOWd7/2h5M03P2QMJW
         DGXRjuRvrgAawGnhyqK3PFdlL0Z2DTN3Yt3b64t2BMYbntDZ8HXfg/dBQ/4EwuJWGJcJ
         TtnA==
X-Forwarded-Encrypted: i=1; AKwUvBwSMb01U5ZSE1B1GrNBry+mnZUAvut1S1+/X/KgnM45mf+51Y6Nca/P9qBkk/+UCxUXcKQzpiX17A==@kvack.org
X-Gm-Message-State: AFuF++mcNnYfgt6byS1QwX/f4DYLhYF0aWd3Z/FT7cpMiYBzQ3id2GJl
	7F1l+mmz7ukfPjDE6yB7jh+2wNnTXYV7obhRz/+CaCEDxyKL061pGMOYb5JFjD4d0YU=
X-Gm-Gg: AYBFou0G71j8zfibEotL3weV6U5bIIV3C/oeDT7AI/Ti1juWOMzeDtrM4oGyKp0OCBm
	EgVjgLDNemYF6a++2WGn4RG60E1TFAl4CikRzEZ7XWgdSCTRNLlxISBd8eHnEWNDours5zLpXIL
	yN0+UQNDunIu1Xi1yBFdezkcWB27fl60ionAsESVBmsbtzfoya8MN5Ogu+dkgGi+odQK+ncTJy9
	pBlWYQ4c3R+FulYlf3F+ZY7ljcqgxQhG4uIDr2n1XQcmZCu5LoYFjhKaabkkuX0LUxI4D6DGUsj
	GBL1pziEQMM/tdKwjShoRLaBrhAiVI7SW6k6zjZY/AhAgv8uk0Ik3nQnI0ZxjjIXzkiVjyiqq6a
	sGZf8pI9TlR2gGv4av9I+QPicxVbrOnMVvpBxGGjdBFGfC3xSts8QqMCEvT4KLh6JASkkEiwHr7
	C9c7ZNylywKgQ1aQ49B7OuG/SapgKYr7aqFiKL8PbtS5mzIxhuhxGboI8UzY5Vo7J3AeA=
X-Received: by 2002:a05:600c:45d3:b0:4a0:c2a:485e with SMTP id 5b1f17b1804b1-4a01b130b8bmr25639735e9.33.1790779830473;
        Wed, 30 Sep 2026 07:50:30 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::7:e977])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b029edea4sm4382698f8f.22.2026.09.30.07.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 07:50:29 -0700 (PDT)
Date: Wed, 30 Sep 2026 10:50:27 -0400
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org, 
	rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	ziy@nvidia.com, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference
 with MPOL_WEIGHTED_INTERLEAVE policy
Message-ID: <ar0fURbLDPrphYMY@gourry-fedora-PF4VCD3F>
References: <20260930121154.687586-1-joshua.hahnjy@gmail.com>
 <2e3f12b7-0dac-428c-b70b-07e1f63de028@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2e3f12b7-0dac-428c-b70b-07e1f63de028@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E33DEC0005
X-Stat-Signature: 6muo6q3td48wwoicq8rxsmgfqefeyjxk
X-HE-Tag: 1790779831-126715
X-HE-Meta: U2FsdGVkX19HnKyfddPs8HnXJmyW0kXm1C/XLLXkfJ9AAouShbO2Dtw7oc9dvE+S8NCv3UPswwzu9ST5+1/+iW18DeOmLtbi1zhGhHKnwpwdJMgT6+NN8K98nriibXzE9qMkYkObhgZetljGAiHywftBeVoyw62I2dNgpwzsPQvPGI+yDzrqFtOuL/t3GkASsTqK794HqziheGc0QmPO25/VKdZBWrgBHSuPdwfIFzJhw93IbeNVTZFeAKS1xoTbya9C0uwS9xqTPPxAnklZOopFKJkuHpPrL9eagHi/ONpPOtYRbi8GRp19I0oPYG0LYOHnTTvyAjKu0QzcHCmODMhIx5vGqUM8PrHrSHPftmIxfv2H1iKRqKJct0MQ3aB+Cf5usPeQk1Z++un6/+e5bVNcoNK4I5LdRzQ6Ur5tLtt8xg4hyaeRAi8prq2W+NK8SKn2xpJAbiJ0ywEL5R/RRRZm0a2E1Sm3Ynn7bdHEpx850LPOmKgFQmZrZrEdcTlLp7VgiKVLAVo0UK68rbWOP8W9YH/T+r9617dLmsl1+4y/Gk2uNnIxPdT2s1phN5Fi0pj+9FLsQ7+lnhPbn13p8OAzveTI3RDGEFNzhZv9Lvqro2JbW1ZaRtvZ2qt8+YL/9a+K09lVCTCvippDNftiuqa+RPnh04VnqkgDXX83iuPS+F74oi6QsJ0nbyKR5quujc2rgXQOLAY54gJUy2z5LSDE9h/lEsVDOPPnXbPs+9hRa4UIMjW9XElvcbOMgE1e8MoOLftsJk95infuWhWgAZw8XSELEDInxnKBRIhZmmMpmX1nC5Tpp8l+2Dg4C4tEgD+3rYkO5DFSo9GITcGOFrA++ipNyEgQrgN35n1unEO9Ifxh8QbB/NmJee7/MX2nyMvqk8R2jZgy3B2imOpcmP5p8Bt2ixi/vZAJWaRqKX9NYNwfLufPE32n1NiZWnp+isCdLFT7OTEwUky2AoD
 A6sN9A7O
 yksbPn8nW3uFcXrDpIBi95CAztUneLpSWTyE+FodAdy/1AxlVlFPz1qN2OpVgFqaaWKrkwFkEb1mSC7clNQnIwDKjLRO6aP0Eb+zHnqjvzJju5DhqHgR6Q8P4xVoxlbaGdMR1aVZC58pDw3BgeszmpM3KVmSBr0gFTlK08CL6JaQcG30MeBF4TDyHHplzwoMWTCptdqGYpUb1ZQjLFnW8HAtdPFj1lobJYLdHA+q2AZJuCP976dEUmaZxoXnUnGwywyV8RoqM32BxkepzMWZZ0id5h3d97FFTNsYPoT3Ec0S8tg9B3hQtNy9KNTwvzMsOM4wi20b4Gs39dPRhvmGORLSOYfXHsumyk3FDAeDlW92FC82HmketIn8e26TvqEIrGEuXsdenP2X++ctliNLm810mm79/Jcbaxfi0cgR0C3l0cKMCl/EKkiSVBWw+TTtBg8OY5USJaupJUWqYKmUhandX0EVkmsNd58OW1j8+oNRuyXr3MPK4o238v+Y/pIHD2M+e1m7OvK921j0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 10:02:23PM +0800, Li Zhe wrote:
> The use case is closer to the second one, but the main motivation is not
> only startup-time performance.  The more important point is that each
> workload has its own DDR/CXL budget assigned by the workload manager.
> 

mempolicy is the wrong interface to do budget policy, you'd be better
off looking at Joshua's memcg tiered node solutions for that.

> MPOL_WEIGHTED_INTERLEAVE is useful because it lets new allocations
> follow that per-workload budget from the beginning, instead of placing
> everything on one tier first and correcting the placement later. This is
> important for workload orchestration because the workload starts from a
> placement close to its assigned DDR/CXL ratio.
> 

This however is reasonable to me - you'd prefer to spread out the cost
of initial faulting placement explicitly, rather than simply take
fallbacks when the top-tier budget becomes pressured.

i.e. w/o interleave:

[node 0       ]
^^^^^^^^^^^^^^ alloc until full
                vvvvvvvvv fallback
                [node 1          ]

in this scenario you end up with considerable hot memory
on the remote node consolidated in time-space (everything
allocated after node0 becomes full skews heavily toward
node1)

Tiering then likely takes many faults to rebalance after
you've already reached node0 limits.

w/ interleave

[node 0                                      ]
 ^^^vv^^^vv^^^vv^^^vv^^^vv^^^vv....
[node 1                                      ]

In this scenario you do an initial fill distributed by weight
and then let tiering figure it out without consolidating all
of the pressure to the point where node0 has no space left.

That said - this seems like mostly an initial-fill problem, after
you initially fill your memory, a new allocation largely implies
the memory is hot - and you probably prefer that to be local.

So while it's possible to enable this, I'm struggling to understand
the justification.  I think I would like to see numbers that demonstrate
that this is actually beneficial over the life of a workload.

~Gregory

