Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44AD9CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:46:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2A46B008A; Tue, 12 May 2026 03:46:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72DF6B008C; Tue, 12 May 2026 03:46:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93B236B0092; Tue, 12 May 2026 03:46:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 841076B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:46:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 450E71603CD
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:46:14 +0000 (UTC)
X-FDA: 84757984668.11.15673D7
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id 32A5AC0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:46:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YUN68iwp;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778571972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MV3zAoldwoclbqs7qOGs2hdICyTLCe/Y0G+BfFOFXqo=;
	b=JkSNnsT4mZNbd1ey90d81Q21PmQlH/nKXY08qcuD12U5Y9K/1rpu1VRaKes23Ee9vVh9so
	Tytb65PkHxBXE/5l53LrruPXwpmiCLBhQsYjec97CacIaazElputl8NUpKqkHSTgPUeO1y
	Du059lcez8m6jNRZ2uPtkzSdG1+zj4g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YUN68iwp;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778571972; a=rsa-sha256;
	cv=none;
	b=YMNgU0XQwgk7btGdyJihubkLMfYQh1y4x5f683+2gJkLUYi0Vuy1TWRkNuUg/ZkrepYNOr
	8394LY+XBzmiVLilf6tLtE69EckHnkubC0yw6Oo/0GMvxZAdU++Hd9t/MFudKDPZQIP9Ix
	tUu1bm1NeTTEN8NkueNzcXwd7O8CAHc=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4893940bb5eso31514755e9.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 00:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778571971; x=1779176771; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MV3zAoldwoclbqs7qOGs2hdICyTLCe/Y0G+BfFOFXqo=;
        b=YUN68iwpb/v4EAy52xXNNqgbHn6ObxAFVmaZWsc53nXNAyPZPgH2nSKVcX26/D9Etq
         2dlYWRPt5x16McVRk+2UgfP4x3aSPWZ2cb5GOc9IHmuVU5j4WRdD0WHL4/epIX2vde4s
         Rrw6VtYb7u6ImRqiyuewAPsVGRDDSvuN4b2aih2Q0QEIpzl6lICxzFFCOuXdi3FfbTsj
         CzzG3GIhzIwmMyNkdi/Q1hzqL1ucGY7NkUQ5GUjKVzwFnmFLo3SNAAq78qbeEGiHjgWh
         Rc1Tz7rCjThh7VCFj7lvfDtzigDZP93XHURxBdzCSwLoNP5qN6FwSHjM4HeI1LZDyg43
         I7hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778571971; x=1779176771;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MV3zAoldwoclbqs7qOGs2hdICyTLCe/Y0G+BfFOFXqo=;
        b=L5unKe3UjapBKLue98LJlzjavv1Ct22M+MDu5yCoqfdlAfYQxKWlUCHgKFdS/HEneU
         9BiFcEbK2e5IBzs1GVVYcBYteGX3Fq28d7e6PeNcYiKR3YQVUs5k3K+l8+PfKS6vtHdd
         ofK9Q/pNnirXw8ixzxyGXCZKnLOXH2XeQ0jQPHey4h1FEXb1loip5cZzKXSuuZQaG9C3
         9gQq+1wuwnic/FQo3iHVh4q8AjCD8s1UiwR16jOHLbSMsd+PRKikc0JAXibf4r3NDns8
         XGMwPyiaytnGxOHPe19oTLdv070Hxg6hQuhk13p9MMTGvmCt/t789DKC/f2z/TtZM2jI
         0IxQ==
X-Forwarded-Encrypted: i=1; AFNElJ8UX1t8LpGdxamMEyewXWCXAlWCPi29wa5zrDhp6GW2i0/2Zl8j1aZEI1k0c6bfXGcZSFIGCRywbg==@kvack.org
X-Gm-Message-State: AOJu0YyXYSMYZ4+76+STuSYTe5GXQ6daBImB1AtNdYmWF4xIQbARCnD1
	EhQFFui+WUdEZFP/TfH480Enu0q5QQ8+0ZP60wSH9JtF7tTHwDdqOWYhkrD1ObnqBFQ=
X-Gm-Gg: Acq92OFkLhyVrAaUqqI2Ikq5gMe5t2jfP6ohDsapJItm2r8dlbCt84Uc/3Cp03gFoZs
	webWjUt7Ov+pYiXulWUpM0cnj0Y4H5MfmC+O47J7CoHalHagi3ny3d9+ktq6FhqsClMmrZCRoXa
	zWWGP/5veNYR8Zlcz/dREc9obW97cf6rx6M2jVNwHUFrhF+t/k/dcw1sQ3Nev/Lj6AIi89MEQoH
	ALED/axheBCEVrbaXOKGPuhR3SkIsxcJlmSAM6vxnuDMquXFNkyozHM4kNohL3mHvvZKhZnXuXO
	WmT1k72LGlQxXdRu70UaVMiCK+4ore9jO92UdW9Fx7M3M4Me2j+g2xfeGSOMLUTmFKDSF0yQJBZ
	RPgNEPngA6ofkEUxNyWB+CW7F9k4yex3aw3IiGrIWrNzoYlpsfQdzr2YYxNAi5lEy2vhIqHKbAL
	iRNC48gWahKLlxuilR1+e58JH5cKSHNuqW6sSZ
X-Received: by 2002:a05:600c:a02:b0:48a:6798:52e9 with SMTP id 5b1f17b1804b1-48e67244c53mr274594475e9.0.1778571970739;
        Tue, 12 May 2026 00:46:10 -0700 (PDT)
Received: from localhost (109-81-80-123.rct.o2.cz. [109.81.80.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e908cb62dsm42830055e9.10.2026.05.12.00.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 00:46:10 -0700 (PDT)
Date: Tue, 12 May 2026 09:46:09 +0200
From: Michal Hocko <mhocko@suse.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 0/8] mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE (Part 1)
Message-ID: <agLawTyWlnuC9Rz1@tiehlicka>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 32A5AC0005
X-Rspamd-Server: rspam06
X-Stat-Signature: ftuiznosa8qdgs13qajwjwq34jdbten1
X-HE-Tag: 1778571971-826805
X-HE-Meta: U2FsdGVkX1/ZBNawlna9x8pDt7YztD811phJr4x0v850BqZdnywBSAt/858Wp9H8H45StQB3ZqZvOmwNykvnxIpUX7FGMS0wA0IRHBpxLauCe3mAhYYKhok3zvBKu39QmOOt0e8kj7HtzE3xwfBkNMMy/Me5/aaOUq+9TN3nuc8VyhUe05iXXZvudzP8iZodUJi3yL6AoEqJ01ryhGre2KxEs8Wm8vL9JBDCLuVZiz6q/Nh2E1GgaHNrBjoayr2P2WPJfaxcjyaSVmBdnPoxraYCY2wfcMYln0wMFh7L23btiXhedpLp0VGD/MWLgxbb2RznI/y0gcpmZTkC1Apjx1jiRPOanH3HmEuLnafOAK5nkQU+AAlLIoy5HAE+S6YUgtnRQdRSQ8ZdQokIdCAmi3RebzidBEVNFSxig6rxugcelY6IXYyI+ICOULfDRnYRQbgvFFnNMdkhrE7pBKzIj2iELjQNAnmilt7w6LHF4Ci9gWkGX13X+MwB1oPVGS4XmVCVw/tRjkaz+9sf2sUg48G9eimdgIkRMh9QRwA2kbMYRwmiituvmXDCczMO/40If18qGsxD3e9YWVg70En8bIe5m28PRVW6om+GOPmlWzng93b65pngkrcWej6rzzsn4ZnhD87ftHLo1eVBNXPlzd43ZIjxFiBZa1KvC7beqPKHYwVEydKkx19qt3cPSW5bAkjDbcjWA+e5n6krSOr1vWAVPMeGLiQ5rVLokMEPXKwpQJ2hMnUeWjE5zKminQPaMfIlivaNorCjsgAkXZnojJj0ySmtyX9yy07xx4KCVhskjbtu2Q7qX1PrHKxNHp0TNG6URm5AuIv8G07DdUEkQYEKHOKgDiRXZat81BRyn+ieGN8BWOXBTUSeqkuO5xKNnLJ81nCRxjfM1L1qfJsCt/VV8QVNkYTXbxLvXzKcxbvvV+bUiI8gz8Szkl3Lqj7m6ixWnII2Lt3tdmtyWDJ
 +GguT6Th
 Uc+8qK0QxkrCAkVXLWQtiOV+9OTjJXo7K7C078sVS1QwKq+Fq4yJUzMQyopXPYysIEfPPebKlkzWJMh+ITZcFh4HbtSYxGE1q0bZbrp6IH4fflpIPU0ZV6UfmNYuCI5rY7CLvw6H57R6Au1521ZtxHRW8yJovIWK3Nb6r1BVpl40qfE/7qTgdJY7v4nHWopo3sXtQvxpMzF70M/NYohE94Q44o2pVXg5AuhNH6Q2rtUN3YVpB9sYXZFy2xcgM6ADAgnYrpP4qJWXrZncenKf+KZU5CXFV6VSaLJTqYK/jTJOqhoLkyIhT9/6kfR3uwsKJ1YrenNitacf1UT/tCmxHE7lBV5T+AnSJSVc8Oif8MTzcAcc3GGifCQ1xw+7cjanxwnObSIdUMkRoUxbVZz09y4wDFFmWbgttWK+4kU01e9V0YHeGmQu504G747hFrVkkL337tqanWwhT/O1sOVQ4Ps/5u7rwxjZgoK8G7tOSkydT5sw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 11-05-26 16:05:28, David Hildenbrand wrote:
> We want to remove CONFIG_HAVE_BOOTMEM_INFO_NODE. As a first step,
> let's limit the remaining harm to x86 and core code, removing
> sparc, ppc and s390 leftovers, starting the stepwise removal by removing
> and simplifying some code.
> 
> Once a related x86 vmemmap fix [1] is in, we can merge part 2 that will
> remove CONFIG_HAVE_BOOTMEM_INFO_NODE entirely.
> 
> Tested on x86-64 with hugetlb vmemmap optimization in combination with
> KMEMLEAK, making sure that the problem reported in dd0ff4d12dd2 ("bootmem:
> remove the vmemmap pages from kmemleak in put_page_bootmem") does not
> reappear -- hoping I managed to trigger the original problem.
> 
> Heavily cross-compiled, but let's let build bots run on it for a bit.
> 
> [1] https://lore.kernel.org/r/20260429-vmemmap-v2-1-8dfcacffd877@kernel.org 
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> David Hildenbrand (Arm) (8):
>       sparc/mm: remove register_page_bootmem_info()
>       mm/bootmem_info: drop initialization of page->lru
>       mm/bootmem_info: stop using PG_private
>       mm/bootmem_info: remove call to kmemleak_free_part_phys()
>       mm/bootmem_info: stop marking the pgdat as NODE_INFO
>       mm/bootmem_info: stop marking mem_section_usage as MIX_SECTION_INFO
>       s390/mm: use free_reserved_page() in vmem_free_pages()
>       powerpc/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
> 
>  arch/powerpc/mm/init_64.c    |  8 --------
>  arch/s390/mm/vmem.c          |  3 +--
>  arch/sparc/mm/init_64.c      | 20 --------------------
>  include/linux/bootmem_info.h |  1 -
>  mm/Kconfig                   |  2 +-
>  mm/bootmem_info.c            | 25 ++-----------------------
>  6 files changed, 4 insertions(+), 55 deletions(-)

Good clean up. Feel free to add
Acked-by: Michal Hocko <mhocko@suse.com>
to all patches but kmemleak one which I do not feel qualified to judge.

Thanks!

-- 
Michal Hocko
SUSE Labs

