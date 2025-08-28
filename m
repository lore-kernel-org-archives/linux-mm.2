Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1133CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4AEB6B0025; Thu, 28 Aug 2025 03:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13156B0026; Thu, 28 Aug 2025 03:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D115F6B002A; Thu, 28 Aug 2025 03:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE9866B0025
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:18:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E5E71197BC
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:18:55 +0000 (UTC)
X-FDA: 83825314230.28.CB43CB3
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 64D861C000E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:18:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i9ENF1df;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756365533; a=rsa-sha256;
	cv=none;
	b=S3iI8GevZ+llDUmOwVInu01HBz6DPnucze7sWDUH+0fl0N2BBOgfIph7vEHS4tGFBKvwJU
	mf41ocSWVvga6i9srvI9tqKzDGPfr2HcV8ogKN1sCnF7/R4mkNHeknZrEI1DxL4miVuX4b
	C4/ElEGW4TEHT3diBPR0T2/r7cOUul8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i9ENF1df;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756365533;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ACPidqQG6DQZNVxh12NaJPKP3Jkf06hyqyPjQ1p5F2E=;
	b=OmtvBeQ/PnOIsM7rOx7AyL6h93r+rV2hLd8ChUWg+Qi1NE2JBmOTYSAb3Ys2wipWYKmwG3
	FfXfMTPpg8KVLtj6yNcDyu9E3RoGL408BM8QjRYgKyNz29YRcT5yySnMd4cuENdoTWV93x
	Aaw2HvyNomlHUnZiO98KSBj0lRmoJ3U=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-afebb6d4093so95913066b.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756365532; x=1756970332; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ACPidqQG6DQZNVxh12NaJPKP3Jkf06hyqyPjQ1p5F2E=;
        b=i9ENF1dfWtYGGi+9bgJzL8tCqm3aaH5FQlnXX1SRFMjSAGUuOtJe7+BSs0uyB2OGKC
         hnJKIhe5bEyx5IDRgNLY9y/z65z07Jjlz2r8lnQrkknXCSieWeio7qj11I2E7L/FDEsb
         yv584acn+JITijytUJ3yqLnCyrOA+26GJdiwYaiWZrWa5YzsGEVLK3JsM83JZHsCFV8b
         CyTFCfFh2Vl/yIOW/DXXvxgwn+PFcoYRwD0k4Nj0NVn02ioZ5knN3rcK/BUts4j88Cbr
         I5lTaVRNHB6ys9Oc3TMnEUuvyXErYNeGENfPXnFMJit4X7ruQSxS+JlEinznVZMBT1Pi
         R9AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756365532; x=1756970332;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ACPidqQG6DQZNVxh12NaJPKP3Jkf06hyqyPjQ1p5F2E=;
        b=dKR7Y92usef4qXw1d69XwU62zM9XJCOE42VoiD7ETE1JFEkJeHuZsducdJhODKeH8x
         MGqteV4rvZYZ7ktiif+nTtB+BZn2MNFzT1NgAewEcyeteh+O5aVdYh+5Q+OSqkYvBD9r
         oAc2ZVSRbLLh5yKUv7hWTymjBeazufLaP56q5eRXnmhZE0grjN979w+8VKsW5F0Jngjl
         zW4dhRW5oQrMB11GhylmO+wz7O4/OSkrjCRwFQl1GLla7/oyumRG+EXYym8WaU2TLi5V
         g494M2MxyfUljTlFHa2yzMvAt0XVz7gm0FeVVFLW2eBiEnLAKcrfhdJOcjLSwfgO/qtS
         9T+A==
X-Forwarded-Encrypted: i=1; AJvYcCXs1wapLkS2q3s2QVPwFVOvXaOvR7zlaeCykh4YzQL3ffFUaMnQ22K6wn/3+fse73k7KFUX727Kfg==@kvack.org
X-Gm-Message-State: AOJu0YyjfwZ2LllrpO7+CcOR6e9ggg8S+nm+2aH+3JY9nPUX3uIiipDe
	xI8A85BIPnbDcWmuWl/SFB238OmNrrkNWYPXeUngukMKCv9seyDJkG8R
X-Gm-Gg: ASbGnct9r2Ud4jvQRcjpgUzttDCMQ/CKp9Au/8XOzGI8Aa2Bvg1H+gP7mA64Y4G/+Fy
	TjZQq7Gr/OQBoBm3+zMG/sM8winzw56hbD7L7CVdXWkMlsRoRy492b36fnT0Qa7fxJ1hhQoUnOA
	13A3aGKyCjphZ0FRn4HY4+V8L3Fs7qHEGCNXT6i6L1lLFDn7Pb6/U+FSQOI82o3XcLrYltwga7y
	mQYbOHxo7q7i+yxrZ7oShiBFPI7anYcYRicH6izA0KG7Pp7PY5R7wv+2z9tdkkg3JovWaTLs3O8
	t3IfKC2k4hN6+7FFEIgcCgA8gJ3uIkIPuojbW9sVoIBJpRcQeY0aSfifZvHpvBmsQi+HWYUx5Nh
	gHH4W4DPHGWN/L/GPgGWeM3EAiNUC1QnT1hw+
X-Google-Smtp-Source: AGHT+IEf18QCG44U8jBJ4evHstdtd0oL4Hr6BpN08BPT0cHmsLXVki3gbBRZpXohq9eRx3IUTA8+0Q==
X-Received: by 2002:a17:907:d2a:b0:afe:dbfb:b10e with SMTP id a640c23a62f3a-afedbfbb935mr140730666b.47.1756365531421;
        Thu, 28 Aug 2025 00:18:51 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe98ade972sm616427066b.50.2025.08.28.00.18.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Aug 2025 00:18:50 -0700 (PDT)
Date: Thu, 28 Aug 2025 07:18:50 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	SeongJae Park <sj@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 01/36] mm: stop making SPARSEMEM_VMEMMAP
 user-selectable
Message-ID: <20250828071850.kl7clyh6e75horlk@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-2-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-2-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 64D861C000E
X-Stat-Signature: jm98jx84f9dwfpcbtt6b8drs555tkprh
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756365533-848421
X-HE-Meta: U2FsdGVkX1/kqza+XugMn4ugmF/pBgDLolit81F8D10o/xXvjh039svviOgYSo37kZPELz1lEWeJhea7wnCTmERZD2Ko6iLT1+L5RDtXClJBTKZ/21nd8Z2cyGO4t0mBmnRuur8fsoebEvRWBe/jNg6dubGKPhaxAFWxZhHs24ZMb41QCJHIkQpkZwDGCAkeOUy5zM8zAxseNNBui2l+0mj6WCflmFCVEL4Y7Egbf97Gh70oEOAMsNpxLLI6QZMyQmNlr3lLfPJ6MnaMbi1iuWGaANE4hZjl8Rzyg9bGJKoYha9uhC0BBN60zvMO0KTmOe9X8UkBl4vO4R07vk481zZF6E2SGtQ2LJ/lydPZyHm1mVSOF2ZowZRdEFojccmyN8wRhBKcyp+FSV2yEqTMBw/bhvjV5fFJz8zVxQtG/NHvJN10VXOBREfFTVJplO4PZlqaTo6a7a8UPHmXO9SKaunRiOcNzrHv+zU3juo0iNFh/RluqJBhmHKbmWF7c3bYZHAHEF9TNGJlq1j3CmTwutk9HI7n5hXlOYohXn/+TfMINd1ywsIDYDDPQwa8wtZ/28E5iec55+LkI9loInbq8zWlwdB/bhiLjXPW/sBS4T2R1Tia4xlINIXPYKs7yh+ECex1ib9sHl4X9/bplxJ6CFkoOI8oG0Z8IZiwoE62xHnUJ1W/7jyJaAx7FAhI9XqFjTymHcfPrxhZrXwpgTIIsuvpZpphfOmfyL1oxvuStkODJ++L79wlFL5jCJjrh+t2A7xmEO/x31lJzCK5eMUcktHeoOrrh8/BHHnt+7932b0njDzjbbYz8yUOlZYnpSdVWVNwRyBo8DDPOF4W80tRfFtYG9mxvunR/smxUcrPZmA+R8jy/4g3ZBgA3bVwX6jlLlns05joGhVsvxolGuZ97iDZPsk1+c9jOzE+Wr0nQeIDRSuoZxqNrERTUY9NKhvKkWp+iS5l1d35AMrlL9I
 zV0yLVwj
 LxJqtLaUQJIuzBmdXUPaopfIcLt7QHbWY0Pd17N78MD2ap0vEZcgKQxHde2hV6aJ2PaJt2HgDABc4xCWgSl8djlV8oWnQZUj/iT1xBqB61EEoY0VZNnp3vK8l3OjSAAfGN/O5xF8dYPxc5QCPMpoKoA5lChzzwwJ5KrjM5pbuROj6GRFY8JDRiWuW4zzLhTRBlZN3RmLTDzkvKRrQNQm7hLBTQ1ICUDigsH+MX0dyo0BCBPLJW08EZuTZ9S29nMglRW38iLiZ9Rbl4Ea06uH8pKyK+jmUNp3SqShwKDCQMNcLwHhr70rjS77sm3kxw7c0i4LqYOIyBcSe2p0SdQowyBexpXmHXM8gOcFAC0hAuLejKDukOG1fFJ1lru1q921kqnlyyNeNsCaf6k3HoSV94omPjStiSeClcX7CX/6Bkt6qiLVwjq2xjyzw8Pj9dpGy0I6P6YgSvi60KtzcRLMG/9GJP0rN3CypHvfRKRiCKjuw1v7QZeIB5fEq79c5PobYxS/zG0dxGQSlM724buA+TeD0/ooVxgJeF9RXHIWXJdJyoGgQ1ElLIBbL1N56No3aEzkBEwM72mKkR0qPMGP0iKWi5opLs3UHB5qdPaK25KNd/+KWb4ueRgWcxJ7vkwAYVffBQx4fNbIGzPL3b3cdpOYCB+V8UwlKIFAa1dir5EjSj4uT0arUIyCzGUmgtZejffEG3/INlsLAOMJf2ZkWlGQBkixdUwCWNKu/pVt8hYrIWMFBTV34KaPVBjUUcHXCMjH7RNICm5pGiS9Kg8NXa5LXvoINQV2mjMETvfIbME0kDMnRVgEJA5nfLbt9kxQux0Na1kq2fv0wqhSw4R0hsgaU+6xLeBR0g2Ga6oXAJNwLYBiTqx8nINbRrCANm+Ua/vW3bOs3KZrar84oMyOqu233A7dtFNdZAhaA72A4PQ21kNffBBAuXKvQT0HaoqP+vJdJXgRAnZzZ7WtHVeAFiSMrVPlT
 rse23TAq
 EGBdZXV0bq5AzaBZ7DuUGBDpzjjUxO96mgcDIbJ/oNvo0CfhdUwJVsHc6K+3Go9MBe5kERpM/vk7j2KzrDsUPH8eEMXnvTGpyjI+hTlPZ7pBSJTPL5i2Og==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:01:05AM +0200, David Hildenbrand wrote:
>In an ideal world, we wouldn't have to deal with SPARSEMEM without
>SPARSEMEM_VMEMMAP, but in particular for 32bit SPARSEMEM_VMEMMAP is
>considered too costly and consequently not supported.
>
>However, if an architecture does support SPARSEMEM with
>SPARSEMEM_VMEMMAP, let's forbid the user to disable VMEMMAP: just
>like we already do for arm64, s390 and x86.
>
>So if SPARSEMEM_VMEMMAP is supported, don't allow to use SPARSEMEM without
>SPARSEMEM_VMEMMAP.
>
>This implies that the option to not use SPARSEMEM_VMEMMAP will now be
>gone for loongarch, powerpc, riscv and sparc. All architectures only
>enable SPARSEMEM_VMEMMAP with 64bit support, so there should not really
>be a big downside to using the VMEMMAP (quite the contrary).
>
>This is a preparation for not supporting
>
>(1) folio sizes that exceed a single memory section
>(2) CMA allocations of non-contiguous page ranges
>
>in SPARSEMEM without SPARSEMEM_VMEMMAP configs, whereby we
>want to limit possible impact as much as possible (e.g., gigantic hugetlb
>page allocations suddenly fails).
>
>Acked-by: Zi Yan <ziy@nvidia.com>
>Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>Acked-by: SeongJae Park <sj@kernel.org>
>Cc: Huacai Chen <chenhuacai@kernel.org>
>Cc: WANG Xuerui <kernel@xen0n.name>
>Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
>Cc: Michael Ellerman <mpe@ellerman.id.au>
>Cc: Nicholas Piggin <npiggin@gmail.com>
>Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
>Cc: Paul Walmsley <paul.walmsley@sifive.com>
>Cc: Palmer Dabbelt <palmer@dabbelt.com>
>Cc: Albert Ou <aou@eecs.berkeley.edu>
>Cc: Alexandre Ghiti <alex@ghiti.fr>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Andreas Larsson <andreas@gaisler.com>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

>---
> mm/Kconfig | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
>diff --git a/mm/Kconfig b/mm/Kconfig
>index 4108bcd967848..330d0e698ef96 100644
>--- a/mm/Kconfig
>+++ b/mm/Kconfig
>@@ -439,9 +439,8 @@ config SPARSEMEM_VMEMMAP_ENABLE
> 	bool
> 
> config SPARSEMEM_VMEMMAP
>-	bool "Sparse Memory virtual memmap"
>+	def_bool y
> 	depends on SPARSEMEM && SPARSEMEM_VMEMMAP_ENABLE
>-	default y
> 	help
> 	  SPARSEMEM_VMEMMAP uses a virtually mapped memmap to optimise
> 	  pfn_to_page and page_to_pfn operations.  This is the most
>-- 
>2.50.1
>

-- 
Wei Yang
Help you, Help me

