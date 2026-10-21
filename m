Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E5E1606A332
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=KI3X0Lsv
Received: by kanga.kvack.org (Postfix)
	id 1B72C6B078F; Wed, 21 Oct 2026 16:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18DEC6B0790; Wed, 21 Oct 2026 16:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07C6E6B0791; Wed, 21 Oct 2026 16:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE6A66B078F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:17:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36CE2160694
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:17:14 +0000 (UTC)
X-FDA: 85347742788.11.DD7933F
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf31.hostedemail.com (Postfix) with ESMTP id C990520005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:17:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KI3X0Lsv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792613832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=At2A/wrqaAUfI4SKCwlEtMqC27pXN2/myITaZPv60nw=;
	b=Kh02QC4dFo5A8PnBi2pCavpbPuWTaH4LG9s0BVhGmNvvL/G1XX34yAZM96biGGin9ktqJz
	f20sRxZT7lHNTulBxJGKbL7nyC23EICl2VvRuKP+9vdopxcvA3IRJQAjt0uyW021dCEUWj
	f85q7LWFlZl9IGsCkD8ljgUopME7XKk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KI3X0Lsv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792613832;
	b=enTYA6+Xh1j+PfxHEUTeIW2tWuqSr3inrhcfCtlgYntgZCmVF0KwFO4+H3bxzNG/ycVwE5
	9zMHYlKD6I35wtvo02U9TVOgrnESPdC7ZYUHKvO5ee8fV6/Kx5/XDz+yPHGgZqEAUanA/T
	IQak20nIvuYia6C/3rJL9/NHJ8wa2Gg=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2db33db4de9so16675ad.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792613831; x=1793218631; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=At2A/wrqaAUfI4SKCwlEtMqC27pXN2/myITaZPv60nw=;
        b=KI3X0LsvpM0AreVedRt01RJTW6H9nVkkMYf92iZ+t8XQolcew3r3QYM5uQuI2Ldcaa
         iMfNQseJTflUTWV7lozZh42LMqgUgXgoGFjk+Ha9bc4OFbDH54zX5ACAgOlF9tEZbIUO
         2m2lEnNaCNiad10jnB5pkr7UwZJ3GBC2tyHGEQMxTZJzRUgUpY9Fm+RouhNHBnlZjyS4
         nMP7vGwUtAWa7n8jVJL+QEIZ07tgPP0G3oS93BFu6GiwjYNOCkbT2v/0nI2aIXXC2qdt
         4XjfFcaXC0MXPeXLUDgZN8gTLPpzpAT1Pi5MWE7Hf9iEJyaXtqPJW7sW9WtsQ6N4u4GQ
         cSCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792613831; x=1793218631;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=At2A/wrqaAUfI4SKCwlEtMqC27pXN2/myITaZPv60nw=;
        b=WGeH4qZyIsZufW0guBFMptkCfnvXwLZNz6dID9LnaBDkdHWbtEwAAHjocmL+RSJK9B
         WCTdH1mWTFfDQ1uG9eU8NFeMTHUTQ9u5r39wPigugcvsxs8krMKTxXRZsy++hzM1u7qt
         ZXgE/Ba47rZe3b5TtXe9T81DyDq0lfDeRoCWKz0VZMWCK9tapJwhG3VklwXuDfiB4GO5
         yVG9fw+c9LnS7XIUaId7nqlBXPfbiFoM0Uv93uolhrcGIL+i23YSVlRbHSaLi4qK+mgT
         FKz2KmxJPS/6mMX5zicrZHqH98qpFok0W6TMYiLL7ctb9g0Y1Uh3pLEMjaIEBqxPoGQb
         MPBg==
X-Forwarded-Encrypted: i=1; AKwUvBzpx3ZeZJRwItbgm6vsUYNCz+rF3BdRiB2AmvNbGl2uFJjSrHgut+vbx6ZWuousnZrubdqAyhQXEw==@kvack.org
X-Gm-Message-State: AFq9FYKognkWx2j2YnppDf2oEA+KS960HL0/smSV5+0/yOOzvTbzw0qE
	POuVyb7AUKR3pk9MuLezIEXpw/WmnW01aJEasOH5OXUqfPDc1Hza8tq2Em8FueX8Cw==
X-Gm-Gg: AYBFou3mgR75JIGJclfI59AhNMX3qwh9NHzhoXLzkcA7zUGsX/Jbgu6cy6YtVq9OkzI
	gN5Yo/s6NRx4ywX0mRQFNCek4I0GvVgqdAqH4g7H2B5vTbcQUZZhRmdC08VHHO6T/rTmzGld5pm
	Kbio2uODctUg4C/4bi68MjNP69uhy79pkKfi6vyNBgzU64hK5AC2E42/e7GdvjuUebG7kMagJbc
	dh1u++3oU+pYma5FwGF26FHfe3a9Cb4V60YRE8MEkLNW6jf4+sqdVWM0R97P8dzCUDwWTpD4stl
	rW7/nn5uHomvT5vZuaUagtoyhf9IpAomZCUebnbA4zd9SLF4WBW1Ll4Ad2IEbAvRA6boI1XZqOJ
	xnooqGBHb3f0+ZRgS81+CBFOF9nwDacrEJbcrETUlvBkXIMHgOl3VnPPqJOk9ZESzVw4Q5sOdtS
	ZU1WY/21W7m949vHinKRCoV3uhW8TX1aRt74inFC42P3rgCuoYFrIrrsx1McyEnOzo2HMlrbvNq
	vzwtrzjjJnivvMwg7qcJABTBEs448Cf7k49S4Dm49+QKQW0/ruGNq3zzaYSGaJ5yIIjlRXO/0hb
	XvJIWhDgaXrHmKkixUsLqg/BMu3i1e/SyjRDioQwGtpMcCiF
X-Received: by 2002:a17:903:24b:b0:2e6:d25:d874 with SMTP id d9443c01a7336-2ea6313172cmr689965ad.10.1792613830593;
        Wed, 21 Oct 2026 13:17:10 -0700 (PDT)
Received: from google.com (163.1.145.34.bc.googleusercontent.com. [34.145.1.163])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada4896c71sm927197a91.6.2026.10.21.13.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 13:17:09 -0700 (PDT)
Date: Wed, 21 Oct 2026 20:17:05 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Fred Griffoul <griffoul@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, David Woodhouse <dwmw2@infradead.org>, 
	Ackerley Tng <ackerleytng@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 06/11] iommufd: Map memory provider files
Message-ID: <atkO08eCJzLX6R58@google.com>
References: <20261014093733.90312-1-griffoul@gmail.com>
 <20261014093733.90312-7-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261014093733.90312-7-griffoul@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C990520005
X-Stat-Signature: crbx4pexzy8xb98tf8cbqe3kaqpc45z1
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792613832-402695
X-HE-Meta: U2FsdGVkX1+Z7uCu0XCRx/h2TozvG/EpaoYVqHgSPSf5ibKBXv5TZ+L2sdBo9SYWZOOpTKnMHWADCedvZ+XaBWv7Lhg1a7YcYp9+NgN6j4hZZ2NQgq+UoRYwFl41OP0UY8dzKA874qjUOFJmNxYp43RC4ifu2Bt2zb+iNZsB1899hr561soS41vP0MdKOFjBQ2xyokTvzqfIP+jAFY8MWO2Sd3Xqu/ndRWiAVlf1GxLnlZ0cTrz5D7Yvynsb89KBJPOUFU1W6yf+RioIehUnHjjfRylgdNHGpY1GZD1iW5xcGJdTdxoejC85yuZKPwEUCa9aQuueHcUr4twjprYP3wKj/ACc0S775zciKV2sknKFcDg4n0dbIB6Kc3EPHpBuzE4ud/u3qvtXvQXaghafpuhRXYLRIZPAcD/G0OZA0tf2y59zlsvPXw5BgQA53OI7j30Y02gvX9KfGkCsjiz9qBpvSzUtCLjzF7I1Atxz2ONjPZYJJ+XOYdN93JQ47KkkG3PZbaHiNLtD23AikqB9kDC7BGdvZVwmfX6t0WScVACbQgR8kO76VwwXHlZayT8H5HNpfpIhxp8TKbHrUT5Kp8R0aUirBMeEdscnP4X6NQCEd+XH0EZ7vLjdEFdY2CKfMx1ZusQdHdprtZTdBXMVYG74zkJnAqHw0dZeiMpy0s1HDDsFUlKkrgD6rcqkASOy5r3CYJGq91pJUF3YmKPK6TdSzyRtAV1Nn6Ily2D2yahjmyICR+Q2G8mfTowxVWuV4rz9zRcDxszKeh631VLMsd/mTktLkRPmStIRRnWREMGsHDiABNAWNzlbij72KmS67/bxn3v1UnJr+Rdj9gWceNGLc/y637DKpTYycB4YAB3ExXFhbjCrCrrSZYk71p7gTgtAfPClCNNPfZu6BWtEyKqmLzneYHjKUdmnkh7Ns640LTT2L8ibaISsMPnTe4WlEayT/tTIETN34tSdzox
 vyA2l2VL
 UeHpJ6SwHmjt1jg6wt9OEAmpCvRn7j37zVhSm1EUWqh9AeZkWpNyDnFfsr8cImmu8IyWnxzwc0ZV7xCiOhxdqmJSLaJiS4l0Vjon1GhjuHGgIUKZ0UFDlLNOs0hZGlnJvN1wHDproOc0AUW9iQ5w1I8O9sOe/dYd7ygvNrpVHlosBvVSraMJzBs/kcRxltubdoRow7MlZMAjKLWwmMVpizPNr8CzuDNDhS8eAZjHsOzYlCvo1jGTA9vEr7pZ9zHeXzs79Vy9W6ZOBCKFk6/hGTtdspJ7n6pGkjULcm0gw08OFigbcoox3M5bm0C7bBq8BamH6szuJn+2QiwVmNYZXXk3lT/LOJRwDpT6/KVbVDSQ171HN7Qa7sdzYik/m4WmXAGBDgWn/XOizhSsbgCYdTusNjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 14, 2026 at 09:37:28AM +0000, Fred Griffoul wrote:
>From: Fred Griffoul <fgriffo@amazon.co.uk>
>
>IOMMU_IOAS_MAP_FILE pins the pages it maps, which cannot work for a
>memory provider file: the frames may have no struct page, and the
>provider can take any of them back at any time.
>
>Accept a provider file. iommufd neither pins nor accounts its pages.
>It asks the provider for each frame when it fills a domain, and on a
>revoke it unmaps the range in every domain and maps what the provider
>backs now. A device that accesses the range in between faults. A
>revoke charges the page tables it allocates to the memory cgroup that
>mapped the file, not to the task that revoked.
>
>Each frame gets a PAGE_SIZE entry, so a partial revoke never splits a
>large IOMMU page. The next patch maps larger blocks. Holes stay
>unmapped, read-only pages are mapped without IOMMU_WRITE, and MMIO
>pages with IOMMU_MMIO. Frame 0 is refused with -EINVAL: iova_to_phys()
>returns 0 for an IOVA that is not mapped, so a revoke would take that
>page for a hole and leave it mapped.
>
>A revoke would race a dirty bitmap read and lose the dirty bits of the
>range, so provider pages and a dirty tracking domain cannot share an
>IOAS: whichever comes second fails with -EOPNOTSUPP. A provider
>mapping cannot be split by a partial unmap, and in-kernel accesses to
>it are refused.
>
>Assisted-by: Claude:claude-opus-5-5
>Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
>---
> drivers/iommu/iommufd/Kconfig        |   1 +
> drivers/iommu/iommufd/io_pagetable.c |  13 +-
> drivers/iommu/iommufd/io_pagetable.h |  27 ++-
> drivers/iommu/iommufd/pages.c        | 288 ++++++++++++++++++++++++++-
> include/uapi/linux/iommufd.h         |  11 +-
> 5 files changed, 334 insertions(+), 6 deletions(-)
>

[snip]

>+
> /* The pages are not pinned, so their domains are tracked in pages->tracker. */
> static inline bool iopt_pages_tracked(struct iopt_pages *pages)
> {
>-	return iopt_is_dmabuf(pages);
>+	return iopt_is_dmabuf(pages) || iopt_is_provider(pages);
> }
>
> static inline bool iopt_dmabuf_revoked(struct iopt_pages *pages)
>@@ -285,6 +306,10 @@ struct iopt_pages *iopt_alloc_dmabuf_pages(struct iommufd_ctx *ictx,
> 					   unsigned long start_byte,
> 					   unsigned long start,
> 					   unsigned long length, bool writable);
>+struct iopt_pages *iopt_alloc_provider_pages(struct file *file,
>+					     unsigned long start,
>+					     unsigned long length,
>+					     bool writable);
> void iopt_release_pages(struct kref *kref);
> static inline void iopt_put_pages(struct iopt_pages *pages)
> {
>diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
>index 660af3d46f5e..aa7740326ad6 100644
>--- a/drivers/iommu/iommufd/pages.c
>+++ b/drivers/iommu/iommufd/pages.c
>@@ -52,6 +52,8 @@
> #include <linux/iommu.h>
> #include <linux/iommufd.h>
> #include <linux/kthread.h>
>+#include <linux/mem_provider.h>
>+#include <linux/memcontrol.h>
> #include <linux/overflow.h>
> #include <linux/slab.h>
> #include <linux/sched/mm.h>
>@@ -238,6 +240,35 @@ static void iommu_unmap_nofail(struct iommu_domain *domain, unsigned long iova,
> 	WARN_ON(ret != size);
> }
>
>+/*
>+ * Provider pages are mapped with PAGE_SIZE entries, and may have holes.  Some
>+ * IOMMU drivers warn when asked to unmap an IOVA that is not mapped, so find
>+ * the runs that are mapped and unmap each one, without touching the holes.
>+ * iopt_provider_map() refuses frame 0, which iova_to_phys() reports for
>+ * an IOVA that is not mapped.
>+ */
>+static void iopt_provider_unmap(struct iopt_area *area,
>+				struct iommu_domain *domain,
>+				unsigned long start_index,
>+				unsigned long last_index)
>+{
>+	unsigned long iova = iopt_area_index_to_iova(area, start_index);
>+	size_t left = (last_index - start_index + 1) * PAGE_SIZE;
>+
>+	while (left) {
>+		size_t len = 0;
>+
>+		while (len < left && iommu_iova_to_phys(domain, iova + len))
>+			len += PAGE_SIZE;
>+		if (len)
>+			iommu_unmap_nofail(domain, iova, len);
>+		/* Step over the run and the hole page that ended it. */
>+		len = min(len + PAGE_SIZE, left);
>+		iova += len;
>+		left -= len;
>+	}
>+}
>+
> static void iopt_area_unmap_domain_range(struct iopt_area *area,
> 					 struct iommu_domain *domain,
> 					 unsigned long start_index,
>@@ -245,6 +276,11 @@ static void iopt_area_unmap_domain_range(struct iopt_area *area,
> {
> 	unsigned long start_iova = iopt_area_index_to_iova(area, start_index);
>
>+	if (area->provider) {
>+		iopt_provider_unmap(area, domain, start_index, last_index);
>+		return;
>+	}
>+
> 	iommu_unmap_nofail(domain, start_iova,
> 			   iopt_area_index_to_iova_last(area, last_index) -
> 				   start_iova + 1);
>@@ -1349,6 +1385,10 @@ static int pfn_reader_first(struct pfn_reader *pfns, struct iopt_pages *pages,
> 	    WARN_ON(last_index < start_index))
> 		return -EINVAL;
>
>+	/* Provider pages are read from the provider, see iopt_provider_map() */
>+	if (WARN_ON(iopt_is_provider(pages)))
>+		return -EINVAL;
>+
> 	rc = pfn_reader_init(pfns, pages, start_index, last_index);
> 	if (rc)
> 		return rc;
>@@ -1647,6 +1687,228 @@ void iopt_pages_untrack_all_domains(struct iopt_area *area,
> 	}
> }
>
>+static int iopt_provider_prot(struct iopt_area *area, u32 attrs)
>+{
>+	int prot = area->iommu_prot;
>+
>+	if (attrs & MEM_PROVIDER_ATTR_READONLY)
>+		prot &= ~IOMMU_WRITE;
>+	if (mem_provider_type(attrs) != MEM_PROVIDER_TYPE_RAM) {
>+		prot &= ~IOMMU_CACHE;
>+		prot |= IOMMU_MMIO;
>+	}
>+	return prot;
>+}
>+
>+/*
>+ * Map what the provider backs in [start_index, last_index] of the area into
>+ * @domain, and leave the holes unmapped.  Each frame is mapped with a
>+ * PAGE_SIZE entry, so that a revoke of part of a large block never has to
>+ * split a larger IOMMU page.  On failure nothing in the range is mapped.
>+ */
>+static int iopt_provider_map(struct iopt_area *area, struct iopt_pages *pages,
>+			     struct iommu_domain *domain,
>+			     unsigned long start_index,
>+			     unsigned long last_index)
>+{
>+	unsigned long base = pages->provider.start >> PAGE_SHIFT;
>+	unsigned long index = start_index;
>+	int rc;
>+
>+	lockdep_assert_held(&pages->mutex);
>+
>+	if ((1UL << __ffs(domain->pgsize_bitmap)) > PAGE_SIZE)
>+		return -EOPNOTSUPP;
>+
>+	/*
>+	 * A revoke unmaps under pages->mutex only, so it would race with a
>+	 * dirty bitmap read, and lose the dirty bits of what it unmaps.
>+	 * Provider pages are not mapped in a domain with dirty tracking.
>+	 */
>+	if (domain->dirty_ops)
>+		return -EOPNOTSUPP;
>+
>+	while (index <= last_index) {
>+		unsigned long pfn, iova, block_end, nr, i;
>+		int order = PUD_ORDER;
>+		u32 attrs;
>+		int prot;
>+
>+		rc = mem_provider_get_page(&pages->provider.att, base + index,
>+					   &pfn, &order, &attrs);
>+		if (rc == -EFAULT) {
>+			index++;
>+			continue;

Hi Fred,

Thanks for this.

With this approach, silently skipping holes during IOAS_MAP_FILE means
iommufd has no tracking of which IOVA ranges in the area are actually
mapped, which complicates unmap and could also hide a bug if a hole in
the range was not expected?

I am wondering whether the areas can track the holes, or whether we
should have areas for the mapped/unmapped ranges? This should allow
proper sanity checks when doing revoke. I am also thinking about this
from the live update point of view, where we might need to sanity check
that the backing memory of mapped regions is preserved.

Could you please CC me on v3? I'd like to follow this from the live
update IOMMU and iommufd preservation side.

https://lore.kernel.org/all/20260921004834.2601285-1-skhawaja@google.com/

Thanks,
Sami

