Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C32FDCD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 393A86B0092; Wed, 13 May 2026 04:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344BD6B0093; Wed, 13 May 2026 04:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281EC6B0095; Wed, 13 May 2026 04:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9C26B0092
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:32:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F5E614037B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:32:11 +0000 (UTC)
X-FDA: 84761729262.05.8B83A43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id D6DF78000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:32:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b4S1fRzs;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778661130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBvkYb4fjv0CWfmKlG/834qQuk5hekjk3h3U46rjKpg=;
	b=hBFQYVFVfWXopgrrVtDjNG250cFdiwUa02xf9SIM6Mpn+spsvAmAc5ZNbzRmnAuLqI0+Wx
	QuXdurB/hzItDhD7QAktiJpz7wV3l3oj5FmeEIsMBOhPHKEcrsNoo2GUr9Nom6Xo5zD7KP
	ZXPrHkQWCIZOF8jfkFmrS/wKWfVzJ+c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b4S1fRzs;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778661130; a=rsa-sha256;
	cv=none;
	b=SUSPMNWYMFtym97Ebtk6gOJ/xk3STHLbDN4T8QlCtZFPVrJnoTKjjhU75/WXGgcJaaWqcN
	J/0wLobxNh9bdqYjzaajSrM4gB2Ux+EC+N5KQMX7Of9ChHhP3VJm3CFtC5QiJKjYP2T5kJ
	yCbO9KRUQWIOzrFVbNIMwxIjuHh96gM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B1F9142D83;
	Wed, 13 May 2026 08:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5E9C2BCB7;
	Wed, 13 May 2026 08:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778661128;
	bh=qp/Kvrjw7Oq7hxqDPSczPb7gzSG1XTgAYGfhyvfkbpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b4S1fRzs+BpoYpyi2lzBeRnk/n/Eutkx1iJx4JcHlOEVAgOQyZ5NnR1NPl/q7qJoO
	 C7zMk2y/zgvAqKk3jybr21fH4PW9duyXBucYc30yZ8xZ8l0q2fcP9SX8t3CJJBOe6E
	 FcHQlKDGnZ7p7qa3Bj9oo7i1i5WpWCuHFbKuGDeLEjKZtbXEuuiWChQKbQii4tqnqI
	 TvzXQR7qJ6t4iWSL8b/6f5d9Hk4TS3fH2vtf0Eb104G9DcBwHMtUaFenltZVcdY9V6
	 nBbz+d3RbNr8GQQP7xyDaGlrjtUjRcckR90Z9NPnuwt8k6Ub+MvMf+YHLgdpqHvpoY
	 OLb9we90YCq8w==
Date: Wed, 13 May 2026 11:31:58 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
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
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 4/8] mm/bootmem_info: remove call to
 kmemleak_free_part_phys()
Message-ID: <agQ2_upxbT_i7-6S@kernel.org>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-4-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-4-3fb0be6fc688@kernel.org>
X-Stat-Signature: er711qni4d58uxwokeyw1yin4hkcoofu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D6DF78000A
X-Rspam-User: 
X-HE-Tag: 1778661129-695840
X-HE-Meta: U2FsdGVkX1/lNDtNGuJmymp5KEg9/ou0kF3OdGe1qlT3GkTHpoEp1wlrI6F5XhJPNDUPvpmVFqGmuCnPLYG44slfknTN61kLhSSap3b3afzcFAG4K91WUK/237DUUWaUb3bhVxFIMfqtI6bhT+kTcm/MfE8AB4XcJ13hrVTXZKQUtcT/vgYHGjI+Cm0MKhspmKy2gz2cCIMCnyObDpgwyi6U3FrkJmAggdfOkm+q7asDTk4vVNfmt4izqP4lxFPoukJ9acx3QwKTjjFrOVtfNe5AiAAlwE/WpScvhYmgbLMNsX6MPQMBoL+kuniPs1WeR1Wx4PSmDc09RSf1Wzo9GyPGZQSo8vesRtBjeMbcQgcSjjxhVu0cl7sC++DAYZw7M03NFZdUQIFJYJJdwySsaqAKK6srOpG86ySg3YsgUW1e3wvPFjO5O7kVZvm0aXZYmYBeJB0WMkwhpo377RzEXJAESNddm40zja6ixnR5tOGZR8tnkT2oTtPPMb9Whc06aQY0+OFO3EVd04LvhWSmfllXvJEKQjOqy3YKP22cEgxKXZv4b4Az/RZnQBCNozmi8cxl+8AY2ZKMeOpDeUzWZpq8fjILyTEt34YnKWKJkOb+/3HX+ryML3F/3Qz/NLJoxW10H7c27v0Ispi5KRmtA0VBZX3vGeA5TtcQVhOTLVwerUtGrJnhdl/l5r5HKmuRluFvwPeo1e1w/mvhZs3cSqrbQMVSZ10fasc3hMPFLRCE6v2ymFtXqHWKL2706M8tc4a+NK/vpQoVSzL86gOifuVZ/EEZu5eG7e9ohRBLNU3L87jIA+E5peu8MQi+QgQ7SFIhuVwOixDm27uLarGoMsoY64WGMecm7tp6OLRQhS9tdp3qKnA9ppicgTAl+9WM8emMqFoy08ATIpzqJPXksr8YA+0Li1phhGCc0PUVjAnr5Lc3EKH0In4SKs2OzniRcGAgS0IBFDVVEwltj0C
 bg7MvFuv
 2CMNKwRrT/1q2Hb3H5oN9IPjp0EUQkL1oIWzgsiQirXkp/m1FEwUMp23RoUGs6vfiGCp2ngNicPKq1amEahy1qoOsaaP1kf2tC80hTmsT03nD0/KULFOhY6Jkv6+qLpS05aHEOhN8ByUJcqBKtgezFrDYZtksAla8xl9cVMBcEIXwx6LjhLoWUdAgXc37nw5z1IN++KAdNPwU5kZDMXONvm8iuG6n/s3UhswWh1EIPVuWgO2qW21ldXa4sj351RngFvCSzBETZ/kKatf59Q18fxr7FOVJ7gKjDZOv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:05:32PM +0200, David Hildenbrand (Arm) wrote:
> The call to kmemleak_free_part_phys() was added in 2022 in
> commit dd0ff4d12dd2 ("bootmem: remove the vmemmap pages from kmemleak in
> put_page_bootmem").
> 
> In 2025, commit b2aad24b5333 ("mm/memmap: prevent double scanning of memmap
> by kmemleak") started to use MEMBLOCK_ALLOC_NOLEAKTRACE when allocating
> the memmap to skip the kmemleak_alloc_phys() in the buddy.
> 
> So remove the call to kmemleak_free_part_phys(). If this would still
> be required for other purposes, either free_reserved_page() should take
> care of it, or selected users.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/bootmem_info.h | 1 -
>  mm/bootmem_info.c            | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/include/linux/bootmem_info.h b/include/linux/bootmem_info.h
> index 492ceeb1cdf8..f724340755e5 100644
> --- a/include/linux/bootmem_info.h
> +++ b/include/linux/bootmem_info.h
> @@ -82,7 +82,6 @@ static inline void get_page_bootmem(unsigned long info, struct page *page,
>  
>  static inline void free_bootmem_page(struct page *page)
>  {
> -	kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
>  	free_reserved_page(page);
>  }
>  #endif
> diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
> index 6e2aaab3dca9..74c1116626c8 100644
> --- a/mm/bootmem_info.c
> +++ b/mm/bootmem_info.c
> @@ -32,7 +32,6 @@ void put_page_bootmem(struct page *page)
>  
>  	if (page_ref_dec_return(page) == 1) {
>  		set_page_private(page, 0);
> -		kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
>  		free_reserved_page(page);
>  	}
>  }
> 
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

