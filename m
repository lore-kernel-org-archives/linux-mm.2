Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDB9ACA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2228E0032; Mon,  1 Sep 2025 11:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9AA18E001F; Mon,  1 Sep 2025 11:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961E68E0032; Mon,  1 Sep 2025 11:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6128E001F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:04:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2277D860D0
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:04:48 +0000 (UTC)
X-FDA: 83841003456.15.B28CE6E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 16B844001A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:04:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a45UbVKo;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SbnyxtTKWg5jwngdRmLUxKAOmyXBjry9r+xRsqsuR80=;
	b=koWUEInKc9LKrx42uFJoYxLFIyYLaouUmBUvX2+GaWAePJdKj5Z8tkNI825UbaZwX+BGi8
	OvWsYTqCSpaql3SH4eFb/P+QUudvWARtOCNbQ1dEBEZ3xgwkXkDTxZJNrb7PIOOnpeB7fY
	Fbh5ZjUAFvCLm7orjmqvyGjdD9DDsLE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a45UbVKo;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739086; a=rsa-sha256;
	cv=none;
	b=V8ZahuZHPcB8YgZCpAV+7nmyZZLhuIkY/u2niMN0dgU/JbgEJD14mDdCKn8QW52LkP+Zmv
	BFbQlVqvoVS2iDAzhHxeGnjm4FuGYdXyoUjqfYCqWwPQadDqng6Klw0Sg+HzM4YuHDiI1j
	rH9GRPowPJj5W+oHQIH0sifJ8FMcxRo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SbnyxtTKWg5jwngdRmLUxKAOmyXBjry9r+xRsqsuR80=;
	b=a45UbVKoj6opWuae1DeDjkd1g99pWVvrtXfJVOaPB5IVUFCNpMkb7wV/9bEiCsR77UR1vf
	wv0B2VPmNL9tFvtjUySbUu4m7Mc0jCdI0CmGnm3sEye/gj71sh3N12IdoPCK5GAPW3TK6J
	5mz7s1B4BCNDd+bOqwHiSA1E9tuRSEo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-625-CtF_kTYGNmmX59oM8MuI7w-1; Mon,
 01 Sep 2025 11:04:43 -0400
X-MC-Unique: CtF_kTYGNmmX59oM8MuI7w-1
X-Mimecast-MFC-AGG-ID: CtF_kTYGNmmX59oM8MuI7w_1756739078
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 85A49180048E;
	Mon,  1 Sep 2025 15:04:35 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C99171800447;
	Mon,  1 Sep 2025 15:04:00 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mmc@vger.kernel.org,
	linux-arm-kernel@axis.com,
	linux-scsi@vger.kernel.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-mm@kvack.org,
	io-uring@vger.kernel.org,
	iommu@lists.linux.dev,
	kasan-dev@googlegroups.com,
	wireguard@lists.zx2c4.com,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Alex Dubov <oakad@yahoo.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Borislav Petkov <bp@alien8.de>,
	Brett Creeley <brett.creeley@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Damien Le Moal <dlemoal@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Airlie <airlied@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Doug Gilbert <dgilbert@interlog.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jesper Nilsson <jesper.nilsson@axis.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lars Persson <lars.persson@axis.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Niklas Cassel <cassel@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	SeongJae Park <sj@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Shuah Khan <shuah@kernel.org>,
	Simona Vetter <simona@ffwll.ch>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Vasily Gorbik <gor@linux.ibm.com>,
	WANG Xuerui <kernel@xen0n.name>,
	Wei Yang <richard.weiyang@gmail.com>,
	Will Deacon <will@kernel.org>,
	Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH v2 00/37] mm: remove nth_page()
Date: Mon,  1 Sep 2025 17:03:21 +0200
Message-ID: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4P8tn059HxckZ5lqQucjDTPNWIYFellGzP2VG8U7hPY_1756739078
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 16B844001A
X-Rspam-User: 
X-Stat-Signature: 8oiqynncekfpauo44kp6hjtr9q994p6c
X-Rspamd-Server: rspam09
X-HE-Tag: 1756739085-143505
X-HE-Meta: U2FsdGVkX1+jRIlPhxCfcDeWLznp+UzgArF53OvNt2u/nSlYau94wTZTuJaUQpgb7kshIQEkBqRtZvMjyf8KXtHWiArG/9UMatymqdHFoWuAyHm9Vq99KyV61UMxNBnHiYpmsCZC2TmlStkWEkZ9E52RT5lOkN7gAGRlSiTgIpjL1bYIXoMoAWLv2pLodUAdcW7SG5Mr89K/pMFHhStxdCMWDBTRu4epyu+fot0TKodduatk7Ojk+guR5E3wqBnDdd/FGpekbi0OSaqwzsSrjMOhVXci5th0/nnOI+BCVrYJO1iUGnuRBwW1I/Osn+HbRQaLjTkXqDB74pPBtsgz3svpNEiDI6Tg/egcDS4lkNj956tgCdi6AKPxkkl16Q1Oz+WPrVl01B+WMpJwIVycZDcvbGzEIJmCyZQux7pflsLIzPsyUMBz314q3kCRRU7FKDYU+4TS/qMLtJjPEctR4u4UEFwczA7ZaAgL2Nio2GlmQSIOqo4r6Mpp7L87vgO4Z7SpMrfjYHTP2RuoqykzGVo4W4UGPcDIwPvWHqQnQVeOM/f28YSXpF2Ot+UKFNf0bVoUcKTCb0bIQpp23BwuIxeKCit/dhEbdjpS8TjnIdrKPbVn/JVC2T/BDUQ75Iu9YK5ftZx4GZluG0IKaNtDKAmbX7zjy02E9vgVQuRUArcici8ix26qsgKjVvVf07/vTbXrXKeXu2kdmTZfh5D0aHGFyuvCW6BD7W2MUHqgKB3SmprHxvTqu4Fq5RL3z+rST3vPszYzTSwYy0FR4qqomU9Kb1I2Sv1i6p2yVIqoCDQLeZTLV2Lv3deJFO8LlVswFOgaS4iEccZ3Bkg0deI3yRkiHQl8MG7ku/Y2VxR4CbEzR7nhGofS16Y1UIwh92VY6nA/C7pBpe9eK5Ql+Ig++fC6M+EUoOTBJPMtaI/2H/33YFuYqCylWjq3iA8mTGHZUEzcwY5Lj5hI8VRYT8X
 FrlCH3Nd
 L4fmNjk4OR3dw0QK6MPfka6QxWlfbSWo3ywJ/jT/gUiIOjqyDqHakcGa6Ek5TBC0xF6gy0uC9True4QNeMDgazoziu5lhZdVGXl7Yv0nRUjQogD/tiBJJv4NTjIjOP8Qbmli+8wzJamkF/syaxkAhXIvwn37zVmVZu/UTyo3Smx8eRZ7wBFM29cc5DSYaaGHp/LqE4PGtnXCHPiMSIH8qkeFyExAkEjeSMFLHIlm8KBWkWY02/GiMRaqQLy0YyzR6TD/CZabH4tj6p8S3VIG0b0VHW+NRa0Qn7rjTlnEDs0u+Dc+40vQAPtZuCP2o5w2OG5PZpG7o38FgZfZZkWYaF5VOtPDsG4WC6t2YM4ee5Wxa/h6La8wuJpsqvvAobqzYuknkrOw7Z2ck3xnzRIeP8TPXMZ1snvDrWasNoSWFxVMTnDshtsVu0GYMGgw6f61nL7r2c8rtaElOffW2Q605CrE6a4/RT2J/e+A9HbYTHYZ26/ULmf9tEsNVurQD/AN8R5nY4I5juo7KWqoBb/Tai2BxbPKqQJeZmGbmnPOkj5Xzy+FiIeZGDowA/enVho9oPbF0RwbGYHVRM6EOeYoem9eh4eAQf2n9ufu5H/hjnxtNjStJ+GU9udUfkqlzX6d1RR8xMGA46zDq6dJAS4LnjDVa54jf0PjozfkM+IyIag4qy9PFrDv25f9CCFC6qjCVtg0MQFQlXXYyHJAyfBRcCgEPHTm7jHlO9CPJqP38oZc/GyrT4ojIqXT7NtLJmxGfMHMVD5MNsPrLF9AeQSVjCgwcmbehp3L6iAhtdf/s8Yjd9xz9mR6jDrNtwWBXXGoUkCGGbMUzVJThoq9eydavkfkbkwwy/OdYHoOvphXY2qq9alQSUgHmGc8woi4b3gRXziOdBrpD9csUcq+PTcSUThlI0PwuVUT//XcRDXSKTC39sssQH9q9Ioq0MFb+K0p3IsPEbroIubLIAGnpQX+HVuR7UoIT
 X3kp3yO3
 iwm11ar3IQ6TlTlv7TECJVDiV+4yPrDIaG3l/bpAYmtPZ1638K1pRfEUyQrxGjp+bXAjk3yk5/9u7dAiEHLKmReqzK3d5AouhLLGN0a+FMN0JHUT4jgCMn0ZhA2BSDoxPm42X15u5GpycPcqLVAKGJQyzKj8+2sAwqZmxGZKWcHZ6z3iYQNuwW/ux5MrComUK0LDAu0z8N4zFtyKPmkC7iuYPkK1qqCI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is based on mm-unstable.

I will only CC non-MM folks on the cover letter and the respective patch
to not flood too many inboxes (the lists receive all patches).

--

As discussed recently with Linus, nth_page() is just nasty and we would
like to remove it.

To recap, the reason we currently need nth_page() within a folio is because
on some kernel configs (SPARSEMEM without SPARSEMEM_VMEMMAP), the
memmap is allocated per memory section.

While buddy allocations cannot cross memory section boundaries, hugetlb
and dax folios can.

So crossing a memory section means that "page++" could do the wrong thing.
Instead, nth_page() on these problematic configs always goes from
page->pfn, to the go from (++pfn)->page, which is rather nasty.

Likely, many people have no idea when nth_page() is required and when
it might be dropped.

We refer to such problematic PFN ranges and "non-contiguous pages".
If we only deal with "contiguous pages", there is not need for nth_page().

Besides that "obvious" folio case, we might end up using nth_page()
within CMA allocations (again, could span memory sections), and in
one corner case (kfence) when processing memblock allocations (again,
could span memory sections).

So let's handle all that, add sanity checks, and remove nth_page().

Patch #1 -> #5   : stop making SPARSEMEM_VMEMMAP user-selectable + cleanups
Patch #6 -> #13  : disallow folios to have non-contiguous pages
Patch #14 -> #20 : remove nth_page() usage within folios
Patch #22        : disallow CMA allocations of non-contiguous pages
Patch #23 -> #33 : sanity+check + remove nth_page() usage within SG entry
Patch #34        : sanity-check + remove nth_page() usage in
                   unpin_user_page_range_dirty_lock()
Patch #35        : remove nth_page() in kfence
Patch #36        : adjust stale comment regarding nth_page
Patch #37        : mm: remove nth_page()

A lot of this is inspired from the discussion at [1] between Linus, Jason
and me, so cudos to them.

[1] https://lore.kernel.org/all/CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com/T/#u

v1 -> v2:
* "fs: hugetlbfs: cleanup folio in adjust_range_hwpoison()"
 -> Add comment for loop and remove comment of function regarding
    copy_page_to_iter().
* Various smaller patch description tweaks I am not going to list for my
  sanity
* "mips: mm: convert __flush_dcache_pages() to
  __flush_dcache_folio_pages()"
 -> Fix flush_dcache_page()
 -> Drop "extern"
* "mm/gup: remove record_subpages()"
 -> Added
* "mm/hugetlb: check for unreasonable folio sizes when registering hstate"
 -> Refine comment
* "mm/cma: refuse handing out non-contiguous page ranges"
 -> Add comment above loop
* "mm/page_alloc: reject unreasonable folio/compound page sizes in
   alloc_contig_range_noprof()"
 -> Added comment above check
* "mm/gup: drop nth_page() usage in unpin_user_page_range_dirty_lock()"
 -> Refined comment

RFC -> v1:
* "wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel
   config"
 -> Mention that it was never really relevant for the test
* "mm/mm_init: make memmap_init_compound() look more like
   prep_compound_page()"
 -> Mention the setup of page links
* "mm: limit folio/compound page sizes in problematic kernel configs"
 -> Improve comment for PUD handling, mentioning hugetlb and dax
* "mm: simplify folio_page() and folio_page_idx()"
 -> Call variable "n"
* "mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap()"
 -> Keep __init_single_page() and refer to the usage of
    memblock_reserved_mark_noinit()
* "fs: hugetlbfs: cleanup folio in adjust_range_hwpoison()"
* "fs: hugetlbfs: remove nth_page() usage within folio in
   adjust_range_hwpoison()"
 -> Separate nth_page() removal from cleanups
 -> Further improve cleanups
* "io_uring/zcrx: remove nth_page() usage within folio"
 -> Keep the io_copy_cache for now and limit to nth_page() removal
* "mm/gup: drop nth_page() usage within folio when recording subpages"
 -> Cleanup record_subpages as bit
* "mm/cma: refuse handing out non-contiguous page ranges"
 -> Replace another instance of "pfn_to_page(pfn)" where we already have
    the page
* "scatterlist: disallow non-contigous page ranges in a single SG entry"
 -> We have to EXPORT the symbol. I thought about moving it to mm_inline.h,
    but I really don't want to include that in include/linux/scatterlist.h
* "ata: libata-eh: drop nth_page() usage within SG entry"
* "mspro_block: drop nth_page() usage within SG entry"
* "memstick: drop nth_page() usage within SG entry"
* "mmc: drop nth_page() usage within SG entry"
 -> Keep PAGE_SHIFT
* "scsi: scsi_lib: drop nth_page() usage within SG entry"
* "scsi: sg: drop nth_page() usage within SG entry"
 -> Split patches, Keep PAGE_SHIFT
* "crypto: remove nth_page() usage within SG entry"
 -> Keep PAGE_SHIFT
* "kfence: drop nth_page() usage"
 -> Keep modifying i and use "start_pfn" only instead

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: x86@kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mips@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-ide@vger.kernel.org
Cc: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-mmc@vger.kernel.org
Cc: linux-arm-kernel@axis.com
Cc: linux-scsi@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux.dev
Cc: linux-mm@kvack.org
Cc: io-uring@vger.kernel.org
Cc: iommu@lists.linux.dev
Cc: kasan-dev@googlegroups.com
Cc: wireguard@lists.zx2c4.com
Cc: netdev@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: linux-riscv@lists.infradead.org

David Hildenbrand (37):
  mm: stop making SPARSEMEM_VMEMMAP user-selectable
  arm64: Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
  s390/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
  x86/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
  wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=y from qemu
    kernel config
  mm/page_alloc: reject unreasonable folio/compound page sizes in
    alloc_contig_range_noprof()
  mm/memremap: reject unreasonable folio/compound page sizes in
    memremap_pages()
  mm/hugetlb: check for unreasonable folio sizes when registering hstate
  mm/mm_init: make memmap_init_compound() look more like
    prep_compound_page()
  mm: sanity-check maximum folio size in folio_set_order()
  mm: limit folio/compound page sizes in problematic kernel configs
  mm: simplify folio_page() and folio_page_idx()
  mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap()
  mm/mm/percpu-km: drop nth_page() usage within single allocation
  fs: hugetlbfs: remove nth_page() usage within folio in
    adjust_range_hwpoison()
  fs: hugetlbfs: cleanup folio in adjust_range_hwpoison()
  mm/pagewalk: drop nth_page() usage within folio in folio_walk_start()
  mm/gup: drop nth_page() usage within folio when recording subpages
  mm/gup: remove record_subpages()
  io_uring/zcrx: remove nth_page() usage within folio
  mips: mm: convert __flush_dcache_pages() to
    __flush_dcache_folio_pages()
  mm/cma: refuse handing out non-contiguous page ranges
  dma-remap: drop nth_page() in dma_common_contiguous_remap()
  scatterlist: disallow non-contigous page ranges in a single SG entry
  ata: libata-sff: drop nth_page() usage within SG entry
  drm/i915/gem: drop nth_page() usage within SG entry
  mspro_block: drop nth_page() usage within SG entry
  memstick: drop nth_page() usage within SG entry
  mmc: drop nth_page() usage within SG entry
  scsi: scsi_lib: drop nth_page() usage within SG entry
  scsi: sg: drop nth_page() usage within SG entry
  vfio/pci: drop nth_page() usage within SG entry
  crypto: remove nth_page() usage within SG entry
  mm/gup: drop nth_page() usage in unpin_user_page_range_dirty_lock()
  kfence: drop nth_page() usage
  block: update comment of "struct bio_vec" regarding nth_page()
  mm: remove nth_page()

 arch/arm64/Kconfig                            |  1 -
 arch/mips/include/asm/cacheflush.h            | 11 +++--
 arch/mips/mm/cache.c                          |  8 ++--
 arch/s390/Kconfig                             |  1 -
 arch/x86/Kconfig                              |  1 -
 crypto/ahash.c                                |  4 +-
 crypto/scompress.c                            |  8 ++--
 drivers/ata/libata-sff.c                      |  6 +--
 drivers/gpu/drm/i915/gem/i915_gem_pages.c     |  2 +-
 drivers/memstick/core/mspro_block.c           |  3 +-
 drivers/memstick/host/jmb38x_ms.c             |  3 +-
 drivers/memstick/host/tifm_ms.c               |  3 +-
 drivers/mmc/host/tifm_sd.c                    |  4 +-
 drivers/mmc/host/usdhi6rol0.c                 |  4 +-
 drivers/scsi/scsi_lib.c                       |  3 +-
 drivers/scsi/sg.c                             |  3 +-
 drivers/vfio/pci/pds/lm.c                     |  3 +-
 drivers/vfio/pci/virtio/migrate.c             |  3 +-
 fs/hugetlbfs/inode.c                          | 36 +++++---------
 include/crypto/scatterwalk.h                  |  4 +-
 include/linux/bvec.h                          |  7 +--
 include/linux/mm.h                            | 48 +++++++++++++++----
 include/linux/page-flags.h                    |  5 +-
 include/linux/scatterlist.h                   |  3 +-
 io_uring/zcrx.c                               |  4 +-
 kernel/dma/remap.c                            |  2 +-
 mm/Kconfig                                    |  3 +-
 mm/cma.c                                      | 39 +++++++++------
 mm/gup.c                                      | 36 +++++++-------
 mm/hugetlb.c                                  | 22 +++++----
 mm/internal.h                                 |  1 +
 mm/kfence/core.c                              | 12 +++--
 mm/memremap.c                                 |  3 ++
 mm/mm_init.c                                  | 15 +++---
 mm/page_alloc.c                               | 10 +++-
 mm/pagewalk.c                                 |  2 +-
 mm/percpu-km.c                                |  2 +-
 mm/util.c                                     | 36 ++++++++++++++
 tools/testing/scatterlist/linux/mm.h          |  1 -
 .../selftests/wireguard/qemu/kernel.config    |  1 -
 40 files changed, 217 insertions(+), 146 deletions(-)


base-commit: b73c6f2b5712809f5f386780ac46d1d78c31b2e6
-- 
2.50.1


