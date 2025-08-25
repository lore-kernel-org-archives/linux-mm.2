Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BD9CCA0FE8
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 16:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4522C8E0057; Mon, 25 Aug 2025 12:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402C08E0038; Mon, 25 Aug 2025 12:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1C58E0057; Mon, 25 Aug 2025 12:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 141E28E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:58:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF1F61DD76A
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:58:30 +0000 (UTC)
X-FDA: 83815888380.17.FCA2A95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 220C010000B
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:58:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K8EPeL9r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756141109; a=rsa-sha256;
	cv=none;
	b=uIGNgXocRPQT3a8XudfuaiQEYr6SqtF67ozFXRxPmfau3L2bdN/fjG1BuSpZDVTrehWi0Q
	/wp6QSNhGxCf6vgtHzBl/DX+wO/aK1O0OPMIpE8Nhzo8D3/iRWGv4SwHHR2sMZPcZ6V6xt
	h+xXagY3VaUu2JmDzZrejuZs+qYIrlM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K8EPeL9r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756141109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r72jr2fb8G7h/yyetD/U7kOQIEeXffCRdNoOrm+lHkk=;
	b=qKiTbGiT0BR8+ek8BCqhGp+8JeRiXYh0FqlqjdpvkV5z439w+0KCaFFGBcOvd8iJAhLbSI
	sVQAn1ULuWYEliuglTpE3eXSAYUmBH7hdpO9kP2h8gV6CA+kBosFPrm1g+/oR8lTHPuq5t
	kq4qn4fE7v29/7YSxLuf7p2ecU2Yt/s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4B8D43E7E;
	Mon, 25 Aug 2025 16:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF37AC4CEED;
	Mon, 25 Aug 2025 16:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756141107;
	bh=5Xs4ClQrBNPUK24yQ8tvJo62CGzQ+OUCbyk/7pv7K6g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K8EPeL9rFMK2+nBscZ78BHN9AXOnwLlio8wCQA9T4HPI2M7JTseek460vnzI7LqJC
	 TDu4NzXeMpXS8jhUa/iSAcIvRfHFDSrWxcvq7/PwB+bucaEQsHAodSxeBqU3oHbYQw
	 JfnmUaXpTgDVr5GNOQRbyvPuO31dhRIGQUncZS3uv95CJi5KIRjBjS37ASsfqMbjJV
	 FaVoAzebuKQA21fTHdob2rVKAkh6oJNsI5NIl49si6OGRBanVCOrvFPYRUxz3E2h7U
	 H5t70EO0n4A9bkEljsMG6VtFtoS+dKBxf5ZFl9Bmc3Iax0SvbwLHZzXF+Oj3qlKigt
	 vsahqKXPodl2Q==
Date: Mon, 25 Aug 2025 19:58:10 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	linux-kernel@vger.kernel.org,
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
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: update kernel-doc for MEMBLOCK_RSRV_NOINIT (was: Re: [PATCH RFC
 10/35] mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap())
Message-ID: <aKyWIriZ1bmnIrBW@kernel.org>
References: <9156d191-9ec4-4422-bae9-2e8ce66f9d5e@redhat.com>
 <7077e09f-6ce9-43ba-8f87-47a290680141@redhat.com>
 <aKmDBobyvEX7ZUWL@kernel.org>
 <a90cf9a3-d662-4239-ad54-7ea917c802a5@redhat.com>
 <aKxz9HLQTflFNYEu@kernel.org>
 <a72080b4-5156-4add-ac7c-1160b44e0dfe@redhat.com>
 <aKx6SlYrj_hiPXBB@kernel.org>
 <f8140a17-c4ec-489b-b314-d45abe48bf36@redhat.com>
 <aKyMfvWe8JetkbRL@kernel.org>
 <dbd2ec55-0e7f-407a-a8bd-e1ac83ac2a0a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbd2ec55-0e7f-407a-a8bd-e1ac83ac2a0a@redhat.com>
X-Rspamd-Queue-Id: 220C010000B
X-Stat-Signature: 8rz9ax1tthc7qxajwu9681x3x14m7eaz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756141108-408037
X-HE-Meta: U2FsdGVkX18iOzpPpWdOfCbWqMijO4n3G/U9q1bsXR4fqYcdLRUo5msj7uHw6o/pehJZBaA4nmgLoLCWPdW6sCdRcjj9/YvJoyua7bAyAWBfhv1VUb3m3lPjZDo7ML7YyIeX6Mxk5VkI0piXIafR11KQ9pzPI4QYisYhvLssjBTHJiFQw6I/HVSn0F3hirrbAQopm58QeiBkEZvN2cU2LeorYzCHA+QaDqoKgiEzasbb1zmCN+rQFjSqc+w1zDJK9u/dicHc+mOsaJ2UL7YVaRb8KdyEi4LDZPfboG7/K1kFj86nrQr3Co7kUzrnVAb5k2qZbmAxlVo+0rzzNHMEEYMOP573UcmndxKx7xzqpIzFSRxkKuVuzT8k5O+xLGS/eJ5WcBneY0qb/AEoiItCvDQ2ngm7dT0DFsv8IQjNbKyapgUmgGkkVo+2CVJqUR0xZarcbB19bnm09KrQIhbWkWbtrVBBPzHZB7w1hz6Q8vZJOpnFRqi1iCa/dB6TR0r5VX37jyPOrZxabOTpQhcz368am3RgRFedvw4K1ieweZdNMId56MoAQQimSsMqnbYk24I6N8PfoHPmK1a9POQfiAVX74Fhs68Z3PIv+DtPn6GKlwSWaVUq143tdi+d2nkPNJE4MoeGdenaqt5XR1M6lPBMOCv/o0dNqEpL4/VRK7PKdk5ZGzEnm003H6kEx76UCO97sMa+JI7tRmPqLRqAuM8vec2U8U8RyuTQbEP5uaVF0iqnCZdruU3PsxLsFkMW/QVy1bGCxgpliSR9ELiDpD5kLYsqirmEatGz65Kp2MgLSu8aXR62U9qw93GVHkpLQagaknaX+7OLO9VFbabA7EV46yJYTNQOHGZlUmY+QVEvmqKtki2sErZjeE2ov+QQrqWUjla5MZE7wbMc/mneP+gW+lwH7AAcAyQO00n0iqzimbWiIkC099PAyRiGQ2Wap9ANMvsEEP30lIPAzWu
 xssMHdQ5
 CgRl9o6Pov/dwhgijR9m96lGYxOEG4MMHbu7c50uUR/rtSUUrJQD1rzghtHs4I6QKHwt95gnlF6xMufFNrt6em1GPHU0KaAmdaijZq4RJM5FK8D1MlqOw0XLyAJzCYQcnO1gVWabUMQljqjLG0ChmGJN07x4MFZL3AFJAJPKAZe3l1sxhqsc55GMHK1ugWVvc3l5ddbHCiOrmwntKbbou+3RFq7vRa8fxJt/rp4sn/X133QKD4GMPgudoZ/+C16UHwsMcjhpdmcJO9J4D7iCRdt+Ef8UqSKtz8Qp6/jO34TTx/YY5raETGoBEVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 06:23:48PM +0200, David Hildenbrand wrote:
> 
> I don't quite understand the interaction with PG_Reserved and why anybody
> using this function should care.
> 
> So maybe you can rephrase in a way that is easier to digest, and rather
> focuses on what callers of this function are supposed to do vs. have the
> liberty of not doing?

How about
 
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index b96746376e17..fcda8481de9a 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -40,8 +40,9 @@ extern unsigned long long max_possible_pfn;
  * via a driver, and never indicated in the firmware-provided memory map as
  * system RAM. This corresponds to IORESOURCE_SYSRAM_DRIVER_MANAGED in the
  * kernel resource tree.
- * @MEMBLOCK_RSRV_NOINIT: memory region for which struct pages are
- * not initialized (only for reserved regions).
+ * @MEMBLOCK_RSRV_NOINIT: reserved memory region for which struct pages are not
+ * fully initialized. Users of this flag are responsible to properly initialize
+ * struct pages of this region
  * @MEMBLOCK_RSRV_KERN: memory region that is reserved for kernel use,
  * either explictitly with memblock_reserve_kern() or via memblock
  * allocation APIs. All memblock allocations set this flag.
diff --git a/mm/memblock.c b/mm/memblock.c
index 154f1d73b61f..46b411fb3630 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1091,13 +1091,20 @@ int __init_memblock memblock_clear_nomap(phys_addr_t base, phys_addr_t size)
 
 /**
  * memblock_reserved_mark_noinit - Mark a reserved memory region with flag
- * MEMBLOCK_RSRV_NOINIT which results in the struct pages not being initialized
- * for this region.
+ * MEMBLOCK_RSRV_NOINIT
+ *
  * @base: the base phys addr of the region
  * @size: the size of the region
  *
- * struct pages will not be initialized for reserved memory regions marked with
- * %MEMBLOCK_RSRV_NOINIT.
+ * The struct pages for the reserved regions marked %MEMBLOCK_RSRV_NOINIT will
+ * not be fully initialized to allow the caller optimize their initialization.
+ *
+ * When %CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, setting this flag
+ * completely bypasses the initialization of struct pages for such region.
+ *
+ * When %CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled, struct pages in this
+ * region will be initialized with default values but won't be marked as
+ * reserved.
  *
  * Return: 0 on success, -errno on failure.
  */

> -- 
> Cheers
> 
> David / dhildenb
> 

-- 
Sincerely yours,
Mike.

