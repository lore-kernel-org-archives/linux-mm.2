Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C53606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 16:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H/VuAI5B
Received: by kanga.kvack.org (Postfix)
	id 91B7E6B05B1; Fri, 20 Nov 2026 11:11:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CC006B05B2; Fri, 20 Nov 2026 11:11:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2606B05B3; Fri, 20 Nov 2026 11:11:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58E946B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:11:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82FBBC0FC8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:11:12 +0000 (UTC)
X-FDA: 85455986784.06.14A748B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C9965C0008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:11:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H/VuAI5B";
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795191071;
	b=KPZXi3HpuXHDSGcgXBhDjeF9IJoD2bBVy0+VYUnqNkRKFJW9qaDNmFyZy91M/GN1K3wlnt
	9J9WioKU52dpB07FBMCj/VGPnax0XimihujxA24dbpWRs5HTCmkDfY9fhtn74spghQct+s
	dEpuA+pG37nwwlUq2C9y0IrylB/yTn0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795191071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZFb+S8Es0NvUmNBR5T6fgVNGrRH2yKZK48f5XbLVIEc=;
	b=eu8yG7Z9vg+56Io3tdjJChqKBUEnMMpVwOxU2wVPgiyKLPQtGQIQZYHizPh+X7eGjdmNJj
	mIMky+jBvnTGIKprHnpsYeM6WDRwInxVEviq0M/QT0U1WN5aFCYnVLhPDUD+C7UsDtibLy
	Irc/0rcAt8PbiwaR3aQicX0H2IiJVxI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H/VuAI5B";
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9ACC640C12;
	Fri, 20 Nov 2026 16:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A251F000C6;
	Fri, 20 Nov 2026 16:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795191069;
	bh=ZFb+S8Es0NvUmNBR5T6fgVNGrRH2yKZK48f5XbLVIEc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=H/VuAI5BtuQwQd0zk9hcNYwSPn6N63WihBmZ3f6agPjw5j6X4nhjl+xkuBInj2K3G
	 pOag/mfhsLJCuDBPE43lBZguYkWm5Q0XnOYHt8I9NqdQ+atTKMgFYlb1IaF+jtQGld
	 3sUfi6lcLYmIyXlLtnVutUfX01YNRwxTD426bjxP/ztOBKmBROpGn/s6ksznIb2w4q
	 Au1te+hWzLmOyeSjczvD2gxa37Gi2iRY6JeY1uNgS+FOo6aHN7HdwWzWJ76IhqubZC
	 I7wV52HU+JBPo3Q8L36yOGgOyjynFxkC/8obE8WBrvul2HbGE4EceWsI1QomsynUz+
	 KVYj1KF0dneuA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  robin.murphy@arm.com,  maz@kernel.org,
  will@kernel.org,  David Matlack <dmatlack@google.com>,  Alexander Graf
 <graf@amazon.com>,  seanjc@google.com,  jgg@nvidia.com,
  loganodell@google.com,  arnd@arndb.de,  dwmw2@infradead.org,
  baolu.lu@linux.intel.com,  Bjorn Helgaas <bhelgaas@google.com>,
  oupton@kernel.org,  alex@shazbot.org,  gle.com@google.com,
  pbonzini@redhat.com,  Andrew Morton <akpm@linux-foundation.org>,
  kevin.tian@intel.com,  joro@8bytes.org,  kvmarm@lists.linux.dev,
  linux-pci@vger.kernel.org,  Pratyush Yadav <pratyush@kernel.org>,
  kexec@lists.infradead.org,  kvm@vger.kernel.org,  iommu@lists.linux.dev,
  linux-arm-kernel@lists.infradead.org,  skhawaja@google.com,
  sagis@google.com,  linux-arch@vger.kernel.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/19] kho: block: Record the entry size in the block
 header
In-Reply-To: <20261110050202.529473-3-tarunsahu@google.com> (Tarun Sahu's
	message of "Tue, 10 Nov 2026 05:01:45 +0000")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-3-tarunsahu@google.com>
Date: Fri, 20 Nov 2026 16:11:01 +0000
Message-ID: <2vxz8q2n1o16.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C9965C0008
X-Rspam-User:
X-Stat-Signature: rkq5qdkthwcwthnbpjmukpdbms7p4pad
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795191070-861952
X-HE-Meta: U2FsdGVkX18VRVMyEyxsZJgcZ0C4J+QZGhcFhFs9301LIJ0xGtnv73vFH4tY2Gt0y7IL7bZl+SRsm1eLdXxPY1qiqYQlAf9oDetbvxNOTdzAjIw3c7Ro0YxkuW0OC7kD9rLgKTCL9zKGT7HPpe78T5isJngmwjFrqwnOJaJaR3clLHp2UlsChXAvasbuj+RMfSyCPrN09ZLGptykkGvlPrqDAjIfUYJUeaf48qZOIaFMBSW3jmyoKM43UiRex4Ht4Wp5U7LOyYD0SfQdgyWXcGay+qVRxQ2uNB+4Fs7UMYpqd2wBh4B34By3TGcyR1qtqbYR0ahjUukzRsr5hSiPD1P0yRjNChLRRsqSraJk2vP8NJLpvCIahFhFHW/BsiGKH1nPG7+4bHLK7AApcyk6fMJvJYc8GeZspRD0S4tlXCIpR6nAMyPccp4dL2MepMtGsQ0UmlsWT/iflwjyKTJHwqe66r2334jl1gM1AJG6uX3b6DWV2MToKprFEG2UhEOk4PSn6jT9J0NuRuJ8XGn/k/ifr6mPkH0OHOaT7nPVy3sudhGNLHhcEc9PgCSM/9uPB9jhC+kJwDL5yGlKUA+IfA3scoNMxbYyeQedimLBzduGvxbey0b27J6Ewg7v89cpx95L8T+q9qsgPlY4bLhq4N1y8X1dTt9v2PyNRrTUiVQyoxunSf1Rf1sMztUWVcTPmSEtnSp2i89KBsdCqE+uTSBkqP8h4noEH6kbUkiHZ6Iy96OqxjQR2hpS95T3KF4+A+XMipPeOf2rDc+Wy46w43PcN+P3HdSXNrFdG3UvFFCAS45p5O5fE5IJZm66/qDvrQwC+fUnu//EfyJ0IhDNFNytbnNKr7ziQ2QIvN8gHYJIyualpcgzRlvYaaJb9/jbsC3s2Idi9whs/7/cwnpPE9GygajsD+OKyP5CZlsZJI8G6Nbzpo5ZTnN+8IuKpYaxiiBQasejQY6Gvi68a9J
 VZ+cd9PZ
 DPyp3iE51R/tgP18hOZaJI/k1icE2swjzUtSNonjV06C3vQslgrOmNg+Ojx2w6PoYCQpsqTop0lS5Q1ymJTjdlNiQdt3D4FGFF5c37AK0nR6xiuJfoFxez8tBd3ktpF8zCamLDd2UI/K+y8ABdqjhKoVtOjEXaBrVR/gn8jlU2PyuzPaaKuXXFavuAo1Jxao41CY4igAix3XQszImUtRDCPY3tsO3bSpw9tcx8wkXfqsOTufsn6N38phSCssdVxbaCRceleks3gfxUgtZu1M7FmxFUznxindyGl2hF19/ZyV9MF1qZE4sX+PkJYvAy4XU8k8z6r/njTcpa+tlTwBCBwjMnk+08M/MpvL9Hqgcm3Z3YSpeBNKhqIvrYiJcO9cFmSw3G23WiNC/yqWh3BHC7pyuhNsipYDU8QAzIaJ3hPYzPh95ELaJ5TJkZuR9NFTy3G1SNfzjOiq7m4bdgzrRjgKrkv4tn6G9DsxSH4woawXT3ik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10 2026, Tarun Sahu wrote:

> Subsystems using the KHO Serialization Blocks framework currently do
> not record the serialized entry size in the block header. The entry size
> is only known to individual callers, which must track and store it in an
> owning serialized data structure. If a newer source kernel adds fields
> to an entry, the changed entry size breaks the stride when an older
> target kernel iterates over blocks.
>
> Add an entry_size field to struct kho_block_header_ser. On the outgoing
> side, record bs->entry_size into every block header during allocation.
> During restoration, derive the entry stride directly from the block
> header instead of relying on caller-supplied dimensions. The
> kho_block_set_init() interface remains unchanged. A zero entry size,
> or one that differs between blocks of a set, is rejected during
> restoration.

Yeah, I agree with David here. It makes little sense to have callers
pass in the entry size only to have it ignored (or, only used for
rejection). It would be much better to use the recorded entry size and
hand it over to callers.

>
> This change modifies the serialized layout of struct kho_block_header_ser
> and shifts the offset of serialized entries within preserved blocks.
> Bump KHO_FDT_COMPATIBLE from kho-v4 to kho-v5 so that pre-v5 and post-v5
> kernels cleanly reject mismatched handover state during boot. Also
> update the stale compatible string example in the documentation.
>
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  include/linux/kho/abi/block.h          | 10 ++++----
>  include/linux/kho/abi/kexec_handover.h |  6 ++---
>  kernel/liveupdate/kho_block.c          | 32 +++++++++++++++++++++++---
>  3 files changed, 38 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
> index 36bdbaf9b3b8..a40b0906c821 100644
> --- a/include/linux/kho/abi/block.h
> +++ b/include/linux/kho/abi/block.h
> @@ -40,9 +40,10 @@
>  
>  /**
>   * struct kho_block_header_ser - Header for the serialized data block.
> - * @next:  Physical address of the next struct kho_block_header_ser.
> - * @count: The number of entries that immediately follow this header in the
> - *         memory block.
> + * @next:       Physical address of the next struct kho_block_header_ser.
> + * @count:      The number of entries that immediately follow this header in the
> + *              memory block.
> + * @entry_size: The size in bytes of each serialized entry in the block.
>   *
>   * This structure is located at the beginning of a block of physical memory
>   * preserved across a kexec. It provides the necessary metadata to interpret
> @@ -51,9 +52,10 @@
>  struct kho_block_header_ser {
>  	u64 next;
>  	u64 count;
> +	u64 entry_size;

I think this is the wrong place to put this. This header goes before
each block, so it should only hold metadata _for this block_, not for
the whole data structure. Because if you do that, you end up having the
field present in each block, but only the first block is special and the
value is only valid there. The feature header coming later makes this
problem worse.

I think we should follow down the lines of kho_vmalloc and have a
out-of-band structure that describes the whole block set, and then each
block only holds metadata relevant to it.

So this would look like:

	struct kho_block_ser {
		DECLARE_KHOSER_PTR(first, struct kho_block_header_ser *);
		u64 entry_size;
		/* Other things like flags, size, etc... */
	};

[...]

-- 
Regards,
Pratyush Yadav

