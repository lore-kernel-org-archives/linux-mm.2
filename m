Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63870606A332
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KM9itt4L
Received: by kanga.kvack.org (Postfix)
	id 86AD26B05B2; Wed, 11 Nov 2026 01:16:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 840E26B05B3; Wed, 11 Nov 2026 01:16:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77E6E6B05B4; Wed, 11 Nov 2026 01:16:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5225B6B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:16:43 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB128401E2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:16:42 +0000 (UTC)
X-FDA: 85421829444.09.3AF0BE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2735C80007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:16:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KM9itt4L;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794377801;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JERGqFws7qn21ShXzjckTRjjEX/5sLFCO5JaN4J8wCg=;
	b=biqcBgcXpnG1gb1nXCMM5ZFLUjyGYtuafJEZpoc9Jf+P/hjzSpNYfbkmClpWV6vgmQtm0o
	uYv9Or8bmFqck3uL6siHrF1r2uKRoGXVQsGVAEGEYEckCOzQMd7lj3KnQPVP2BAC9noE0W
	lmeV/TPWKBr0jnFbJ3F25/N3+uShBQM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794377801;
	b=s7r4ZkR4BEZ97lmVQGS4VuMUnjfVXavumnHADdt0eNmnvtt1ywwq3zoqamL/XlETUrO7mA
	HdRWQmCJ81yIceWLQF07RQRlIFsxULBTMtN7ix5JDxKV49nijAg0OMQp6sKxuL2nbOhQFq
	zEK6Fp5Uvlt6IfVOqzoDB1HAT1HZBYQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KM9itt4L;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1BC4F612BF;
	Wed, 11 Nov 2026 06:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD181F00A06;
	Wed, 11 Nov 2026 06:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794377799;
	bh=JERGqFws7qn21ShXzjckTRjjEX/5sLFCO5JaN4J8wCg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KM9itt4Li+SU8W4ZUm6NUV+NH2YtdQgT3L8jEt3MPeFsmYirWnAZopelOz8bCf0pG
	 iqHmWS6HgsFtY4lfE3JD4l2pJYVw6hUULXKp5CDhwbs7ZOhfCpPygc8p4KO5K8zoas
	 99HMJRArDHIopB+FH5oO56JwJhLZa27s+v24ZNo5LSY8P15evCwp0ZxExmcxPxGGAo
	 7uq/JhmST7nQc7BgHVRrAgK1UAJkuK9Rzz9fc71C36mrNYsxsoqnjWWRRQrRAuVJH6
	 a2N0EpdzBd+a5ORwmaxcKZD5QLP5VULR8QvK7Ov6tAc4qp/loTXqiL3hdxb87ru8I0
	 gQEBag1wDFS9A==
Message-ID: <sashiko-outbox-208410@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 07/19] kho: vmalloc: Add the feature header
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mike
 Rapoport" <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org, will@kernel.org, "David
 Matlack" <dmatlack@google.com>, "Alexander Graf" <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, "Bjorn
 Helgaas" <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, gle.com@google.com, pbonzini@redhat.com, "Andrew
 Morton" <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, "Pratyush Yadav" <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, skhawaja@google.com, sagis@google.com, linux-mm@kvack.org
In-Reply-To: <20261110050202.529473-8-tarunsahu@google.com>
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-8-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 06:16:37 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2735C80007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: q6hrq36x3p7uxyuc7k9gtz963ojx6tju
X-Rspam-User: 
X-HE-Tag: 1794377801-35803
X-HE-Meta: U2FsdGVkX1+QIDrkKhJIWE+kBYSPDW6U0XaHuFXGgi1nGOqwbVFacMev6w0q1XuGmgYudpGBSyUNzX090H4Ivy7I+6YfQ1/DUyn2I/Wpi4KdSCX95gnR6jBGb6hPQ3vgFm2akyUfuZFLKj86l4gxEYL0RQNvCo0zjrc7DHAp9IRhQVelphlUHWIfBD93H2Fic43fRB1jsy+4zsq4vadjh4o/pdmuCzL2IFJoH2qlLNVPWsa/ciB5FQN+AjXet5uS60wLHoHAxGWPbtgNaNegs0m1EBqtn6HszGztmO9T8GgqioGZoFFjBKw6OHVBu6WELz+X8tNPE9SlmGdnHeryugUOpKaJEZQIKgrgQcS1TBkmnrqDBLZFQwlMO7+ilWID5ASrCFYEN0C+8mDMJP6VAqtuJJ6sDfgvJpB8Paqz++8MdCKX01OYAbGoKnaitti6hb3RZ83OH4+Rz2csFp/UtZhg6n20zIAiz+kulF4qmqVT/WRydLuUSoapBo3lPDJADDCdxFhvdcH6m2ucrSXQRYxDVMDsaWpY+WBx3/T9se9jW6YaF1bJNd+dYXuQZRwHtkImvxAkJXJonliPPQERO/YRkKIVwBU+D3ubjOCG1GJ7BcYVY1kYgSp15gZp2ak2JWjc4iIVDIk5jdVVePSlsVE7Gro3XZ+Xo7SQ4jINN/s0zlWNQzF5rHSc5OPTTwBAH/ALCpyk1bkkY6tN86LIbwc37tFTJnHiE/hvdGgvd43i1zvr12TLXeUKY8dIjUNpH48XOpvWN6dsZvvFUTPmSpbv9fu7pqRbuz6Lx/q4WgocqyghIPrQeYrO74UMorcvtLazVzPvlRSBT4iuWmclTmtyMW7QFWYrbNLqOPrmSyz9Z3qwglFXlt6mXH3d4x7kDZIuzIDKr9kcI6Whq/n06ZHPL9FuElS8tVCa8zO6ioWlAxl+OWBNIvTeF2K6xODNwwJO+1yLb4icbzIUs5c
 Hfk3nITa
 da4i1/bOJyOmMvekwnd4wH9f+FwZO9WMl81T2ZbGR3uyamUNzUOAc2ekzYx6MuCMjH1FqSa5xD0H5OwVzy7YwKpFsZwCdMkvg4tSSVa1xces+v3kD2AJvn3dFP7CISZ86k6U9jP7RUKzTsBJ/kYSGt+965taqL1wiq4/03SZKH+Pq3fX8s6rhzkroe09i07LwR4KfeM089Ow6PeWGSOu1GWVsV8WRR5ifSqDb4RXqelQYDLhxTtAZSBTqZcvdQwqMkXzjspNuhZZbYrg0bli5MSChhZUsG0LW04n4J2+fHunEqmlP6uDtxWa7qKXI61p+8S9xZkP2zLp1g6N1K65ox5+6pGjpCN1gytQJb3Hr54eM1e7Z393IJVDADAXa0qM1AOyi/xDGd9Pm4nOmvBdSuuhri1kFe+53LWJq2ukhDt8hPIn8YS7C1EdDDHzP23gjSpo/uycXBuBbbJwKZITXWlUOe6W65nxE2LLIzZqxdWrArQFZpxDXydU1mgA1Mq5drwFixmvdvFPRbc2Ni3Ta+XTBaESpoyLcfz/W1N5DPvN5yjyBI0Vut/odkvfmYQ2wMIIbo9wSy/uZzFiZiqa1eMvc8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] kho: missing DECLARE_KHO_SER_HDR() kdoc transform breaks
  kernel-doc
--

commit 5eeff1f169bf967112c6cc25130cc4d0e9b8a838
Author: Tarun Sahu <tarunsahu@google.com>

kho: vmalloc: Add the feature header

This commit registers struct kho_vmalloc with the KHO serialization feature
header mechanism and updates kho_preserve_vmalloc(), kho_unpreserve_vmalloc=
(),
kho_restore_vmalloc(), and their callers to pass typed feature header
pointers.

> diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
> index 7b49dd6d7e2af..b0597c4389732 100644
> --- a/include/linux/kho/abi/memfd.h
> +++ b/include/linux/kho/abi/memfd.h
> @@ -80,9 +80,9 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>   * @seals:     The seals present on the memfd. The seals are uABI so it =
is safe
>   *             to directly use them in the ABI.
>   * @flags:     Flags for the file. Unused flag bits must be set to 0.
> - * @nr_folios: Number of folios in the folios array.
> - * @folios:    Pointer to KHO vmalloc descriptor for the array of
> - *             struct memfd_luo_folio_ser.
> + * @nr_folios:   Number of folios in the folios array.
> + * @folios_fhdr: Pointer to KHO vmalloc descriptor for the array of
> + *               struct memfd_luo_folio_ser.
>   */
>  struct memfd_luo_ser {
>  	u64 pos;
> @@ -90,7 +90,7 @@ struct memfd_luo_ser {
>  	u32 seals;
>  	u32 flags;
>  	u64 nr_folios;
> -	DECLARE_KHOSER_PTR(folios, struct kho_vmalloc *);
> +	DECLARE_KHOSER_PTR(folios_fhdr, DECLARE_KHO_SER_HDR(kho_vmalloc, *));
>  };
> =20
>  static_assert(sizeof(struct memfd_luo_ser) =3D=3D 40);
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index 369ce411928d3..919210d7a91ab 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1382,20 +1382,20 @@ static void kho_vmalloc_unpreserve_chunk(struct k=
ho_vmalloc_chunk *chunk,
>  /**
>   * kho_preserve_vmalloc - preserve memory allocated with vmalloc() acros=
s kexec
>   * @ptr: pointer to the area in vmalloc address space
> - * @preservation: placeholder for preservation metadata
> + * @fhdr:         placeholder for preservation metadata
>   *
>   * Instructs KHO to preserve the area in vmalloc address space at @ptr. =
The
>   * physical pages mapped at @ptr will be preserved and on successful ret=
urn
> - * @preservation will hold the physical address of a structure that desc=
ribes
> - * the preservation.
> + * @fhdr will hold the preservation metadata.
>   *
>   * NOTE: The memory allocated with vmalloc_node() variants cannot be rel=
iably
>   * restored on the same node
>   *
>   * Return: 0 on success, error code on failure
>   */
> -int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
> +int kho_preserve_vmalloc(void *ptr, DECLARE_KHO_SER_HDR(kho_vmalloc, *fh=
dr))

[Severity: Low]
Does using DECLARE_KHO_SER_HDR() here and in kho_unpreserve_vmalloc(),
kho_restore_vmalloc(), and struct memfd_luo_ser break kernel-doc without a
matching CTransforms rule in tools/lib/python/kdoc/xforms_lists.py?

In kernel/liveupdate/kexec_handover.c, KernelDoc.create_parameter_list()
replaces the comma inside DECLARE_KHO_SER_HDR(kho_vmalloc, *fhdr) with '#'
and parses the parameter name as "fhdr)", causing W=3D1 builds and make
htmldocs to warn about undescribed parameter "fhdr)" and excess parameter
"fhdr" while emitting malformed ReST c:function directives.  In
include/linux/kho/abi/memfd.h, CTokenArgs.groups() splits the outer
DECLARE_KHOSER_PTR() on the inner comma of DECLARE_KHO_SER_HDR(), truncating
the struct member in the generated documentation to
"DECLARE_KHO_SER_HDR(kho_vmalloc folios_fhdr;".

Adding (CMatch("DECLARE_KHO_SER_HDR"), r"struct kho_ser_hdr \2") to
CTransforms.struct_xforms (before DECLARE_KHOSER_PTR) and
CTransforms.function_xforms in tools/lib/python/kdoc/xforms_lists.py would
avoid both issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110050202.5294=
73-1-tarunsahu@google.com?part=3D7

