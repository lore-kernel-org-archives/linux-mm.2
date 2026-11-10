Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02258606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=jcELH4/f
Received: by kanga.kvack.org (Postfix)
	id F1EC66B05BA; Tue, 10 Nov 2026 07:48:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6AA6B05BB; Tue, 10 Nov 2026 07:48:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBE1A6B05BC; Tue, 10 Nov 2026 07:48:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABB7A6B05BA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:48:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 397D71C3988
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:48:41 +0000 (UTC)
X-FDA: 85419188442.05.5E0A9D0
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3A8C840009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:48:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="jcELH4/f";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794314919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZGhJU+UzWHjWLO2uCHz/PaJEOnJdiVDGFcBGvFMPQDM=;
	b=JMksjFOTmhCsgg9O8pdNOiRW4c0JID9nTCJNwpzUgE8gqYj5IYmA9vwIHrxLQlMCdxnlpM
	zliG+ynTYxRHicVKLX+XDk/7vzIq993RzKP0T4v0HJO3/sCXrH9Fr9H+juE9uClxrG7RQv
	WNNExCr8zfV91aCYs1H47ECPGpbubn4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794314919;
	b=nKVbfWfvo1hGsluxOb4AT2O7mUbZvj6qba7IgyTawEojQFjwSXREIHH7QWuvxEnj8A4AUs
	yfrS8XUkla2RWdjmQnOC59CQbOsdDGA7IvXdvPPyb4oi7DS+A+JFFr85xHGQzdKOG1Q4PC
	dp+GUfgTXxXth/0Gx1o16OfoyGD8rLQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="jcELH4/f";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5c9e7731b34so1394626e0c.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794314918; x=1794919718; darn=kvack.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZGhJU+UzWHjWLO2uCHz/PaJEOnJdiVDGFcBGvFMPQDM=;
        b=jcELH4/f1w1R5f6FmacOBc8kCFlqW4adTmEIlANzSCDlnxKA0UuSLqekFmETJx2CaF
         jr6cSIgv/UjgGcuFN7tCIFvPnKeccbsPXdfDms9boT8Y1p3B4ChuXKNNL2rM/2Ar7svi
         pgtn0mDyflUqYceSdE48/X5vXmeG1GkWl8zCrPkvhyFBVtmOR70SHdlhWti5CNFLYy/Y
         Rv0Ayrchta/oxTUQaCZ0kR9X2L+oeXk+biethVsjJOnMCEKCcaAknMNMQJHoSs98FZs7
         VqGropi6RuYdOa366jd+Oq9xYqgrSgLVjywYvDY1SYyDaPBCU9KNxwPePKBB7OGX8Kte
         AHjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794314918; x=1794919718;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZGhJU+UzWHjWLO2uCHz/PaJEOnJdiVDGFcBGvFMPQDM=;
        b=VltvaiYNrL6d/xp/4Se7WU7YncRlRupFx8AynMrpvPMe5grzeLokhszMhTI8fH5+Jn
         AA5Kdg9n+Piiu/iKZyeG96DhyFn6uDRZ8bhoqNXQwCrPw0qz1w/mcUK6KQ4hij+O+Qhf
         0Q2wD2dh2wOlT2dM0Djo+s4Ny8ASBpbYBhr+e5SS6Olo+IM6Rrf3cyvKy5Sz8zYkBAGX
         eyy1/mLdUgBMiWj2IHyzyglpzNatD14SFD4ASVpyW+H9BhzDAV2/jAlarCZBuJw6yGQ+
         0TWD7V+uMPM174rNGW4gm+jf8E2cmoMEdnrS4Vpl8zVJPekpURPbpax/SHgn+M+FjRMn
         DPvQ==
X-Forwarded-Encrypted: i=1; AL+hErEN0l7oDzVQBOO8Xj9+nFFlLPhSq9kLuEdiuA36KwHgjBh/L59kOSI7rhIW8ham/b657IGz0jx3qQ==@kvack.org
X-Gm-Message-State: APuU4Z8BWnUfrgJuZovz6KOss6rAj1Eic5BcD1bn4I1YZFQx+40iVeCZ
	rmy2ggFQyq4YzWD2gIEdtrxY6n7SwSMnwjGZeFQyxpe2aM18A/Z0LMbu7NRrXuBg5v0=
X-Gm-Gg: AYBFou3QS8/0ffzeUiF7uvlRzRrD+sVRV+Hj5z0l0/DfV+2zlJCz14OoBa0mtrDA+1X
	WaQXKJJl6UmbjbeCM6kcILYhsOzQyEbHa8XaDJHKub0jxKHWg/GJN+RsExGOpn0UFvxOHC8v5tT
	DdmguihRLnn1Q/8gV0kPEauPoBjQYzKAwnv8/j23josjGoiLiN/xgTR461ajSkPHT5oV2ONBud6
	xByGNObSIJA9fkb4QR8qf53jz5tyECUEZReFNTFUYaPuz5IgRYzpgj5AACg2QIcL1FBT8MshpSu
	pLNZ6eusaSUaPBy20EKEmolX2UF080QIJFweeW1SAT3grOcsMIkHSVV0Js1Ow53t9T1TGpmDduH
	xnOob7LAE5QqiwfeKdW/7bwShUwJh2EoLq7snwNkv+a+eYyxlT6Fxj+C+cLKXm/cy2k9lMbNu13
	CVplAKkrt2/VJ+/zUrobEWx834Flbbl08JUqGEk0jSNVXO7/KGZZOqyHQf0E+NnzNa22sJrXCBj
	NjHq7NGqkydpPIzf71fsxS19zfNREzXTAR/v/l2JbY3r1NOFs1PKmIjsvD4nrtfNDMNYn82lxgj
	43MpsZZi3QEosCWfcUGLJTwruo1b956t0fpvCtlTwQCkOP3hb/I1sbNL7EQpc4rczE+85fG664X
	/zelH2u6VdWNhWYiugl94ifSXISE/vl+ThGsKQO2f4CxBPZsXKG+J
X-Received: by 2002:a05:6122:32ce:b0:5ea:b972:1403 with SMTP id 71dfb90a1353d-5ee0cf152b1mr755444e0c.3.1794314918133;
        Tue, 10 Nov 2026 04:48:38 -0800 (PST)
Received: from localhost (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee0c5fd00esm1555554e0c.16.2026.11.10.04.48.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 04:48:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Nov 2026 07:48:36 -0500
Message-Id: <DMRJJX2ZSYQT.2U1TTBGE7R4RA@soleen.com>
Subject: Re: [PATCH v4 00/19] kho, liveupdate: Add feature header for
 fine-grained ABI compatibility
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
To: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>,
 <robin.murphy@arm.com>, <maz@kernel.org>, <will@kernel.org>, "David
 Matlack" <dmatlack@google.com>, "Alexander Graf" <graf@amazon.com>,
 <seanjc@google.com>, <jgg@nvidia.com>, <loganodell@google.com>,
 <arnd@arndb.de>, <dwmw2@infradead.org>, <baolu.lu@linux.intel.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, <oupton@kernel.org>, <alex@shazbot.org>,
 <gle.com@google.com>, <pbonzini@redhat.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, <kevin.tian@intel.com>, <joro@8bytes.org>
Cc: <kvmarm@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Pratyush Yadav"
 <pratyush@kernel.org>, <kexec@lists.infradead.org>, <kvm@vger.kernel.org>,
 <iommu@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
 <skhawaja@google.com>, <sagis@google.com>, <linux-arch@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <20261110050202.529473-1-tarunsahu@google.com>
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Stat-Signature: ae7kz89jrx8fcdicanzntxsdzcsc73tq
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3A8C840009
X-HE-Tag: 1794314919-225297
X-HE-Meta: U2FsdGVkX1+2Z61+/528tG699yTdfbgBbPxUq6p4ITaZDAAFRGGU7sZgrQ1J74G9ow82EDGZ4G6aWLUEXGQHzo6m/UXYlcWlmbeIwia126ntOiLCihkJCBOPeA7OWxYs5+WK3a+Z30pCwAJBD0fO5EP9igvUjLwCSjl0kTyHByTjbVgWDSS+bvzQz3JNxihD60UUgDuHi/1aJKO+VAZ+TtsCCG7h37PLdSqGKqOitRY0Yvq6P8Bg+FM5tquyRTTqsPwbaqcvuHW4L5V/vNbuWE2oy14qWpcWfpGjs7Po4uHGbK8EPDY5huney3KkBVFjZucGZdiGjmJQMxRSn2fBhyZXouMY5XOnasDvTWqPBpxLQnsMrgPS5Dax+2svbmta8mIKiRHP/7qWVU8pHbUQ3o4F7rIjC2Hew34NPIZh4B89IsLDuTzMLsUFLIGNo4fHdL505GxvcOoayx47GkZCWCxY698C/7mT8FY1quhFORJTn3oJghod3aOLREnGIspWy+no3ftT7QCjHJqW3e2s4+pIaD943vDh0Vody0YKaDMss5SwUqJ1kDMrfoKRQbjaEPa3TcczhKrIIdifAwrvYny8hXSM5aL2fqwWr3NaU4X7z8mGVA61sibYQTONdvJIinPWhcXgM4Cf0nScOUnXH0rTQC6LTwxL35Kt02CVjVLWLO0n4hI9i9nA11W7449U883AcDM/MBQaHGRtrToixZPk0mjsJloGXLiSRW/z1sx3fu2pJcZbcykpKDkcB58gAM4dGGt0BiGT+CKIjGrEMXKn69RrLkyGn3zqZz5IR0goAYWCG+sV7hv0Z32jZOFYnKcnuXx2kl12/FIf1JHuAM1FJTOiL4sNRqe9h70LJZsyTgv5p/D9AjtJbAg9a0Z51WPWZFwwz3QUZi4w1OgAZYNFkeBHyfS3HxgIIJk0z6/jDzT+nO6fsGoq7/eIlhJov5q12gM6158YlCs+NmW
 1TylCMNS
 1F2smINtUX907Bbu4iJehzn0KZ62UdwP7wbFvQCWG1dy1qeegr4BQvNuLAR3E0Pjx8m0AdITvg/YSiweW1AtrFfs/E2owYT9FAkT0NiN6clahwHj3rslZpTIoq7Fa2IkvAjMeM5uuP2yP433IQx7X3yqMM9M0/FQgcPiOTh6eYVR6UA8TUABgnkgWM3smMS/P03P2K4thUVaIOHmhDLO8CBCz1471oh/RoEcQQlhZ9OZ10ike65m1f3ZoLwcK3mOLSqiSeagw33hkJVKKO9YpYThjMEBRGRQekf9efzlle5mzFHUqh8zb3DDiBoN1taqTwmJtOIMfp3DBtAF0Q1i9IroEv6vSkN7oPXq7CGKjUIDUjmSWlbYG3MiUMjIpgS7NftpntE130atVGQw9mVWeXL+eQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 10, 2026 at 12:01 AM EST, Tarun Sahu wrote:
> This v4 of feature flags support for LUO and KHO is no longer an RFC.
> This has gone through multiple design changes over the past few months,
> and I thank everyone for providing their suggestions and reviewing it
> promptly. Below I talk briefly about the evolution of this series to set
> context and try to make it easy for everyone to review.
>
> Initially, Logan proposed the feature flags in RFC v1 [1], which tried
> to solve the problem of dependency on the compatible string. Feature
> flags introduced finer-grained compatibility. This series had three
> fields: active, supported, and required. The number of flags was limited
> and didn't have flexibility, which reduced the complexity of the patch,
> but put a limitation on the extensibility of the features.
>
> After LPC and a few design discussions, I proposed RFC v2 [2], which
> changed the flags to optional and required and converted the encoding to
> 2 bits per feature instead of having two separate variables. But This sti=
ll
> has the number of flags limited and fixed the feature header size to
> 128 bytes. Though each serialized structure is being allocated in
> multiples of PAGE_SIZE (folio order =3D 0, 1, 2...), where 128 bytes is
> not a problem, it still carries two fundamental issues: limited feature
> flags, and a fixed 128-byte memory overhead for each preserved file. In
> the future, as there are plans for moving to KHO slab, the allocation
> for serialized structures can be significantly reduced and this 128-byte
> size will be a problem again.
>
> Based on the RFC v2 discussion, this v4 (v3 [3] was intentionally ignored=
)
> moves to extensible feature flags with a variable-length flags[] array,
> avoiding the fixed 128-byte overhead and feature-count limit.
>
> Along with this, as discussed on RFC v2, v4 uses separate bit ranges for
> required and optional flags (1 bit per feature). It builds on the
> consideration that a feature in its lifetime will either be required or
> optional; it can't be toggled into the other. In the future, if such a
> need arises, a new feature flag can be introduced to replicate the
> feature as optional or required, opposite to its ancestor flag.
>
> This new layout and encoding in memory is as follows:
>
> struct kho_ser_hdr {
> 	u32 size;
> 	u16 nr_required;
> 	u16 nr_optional;
> 	u64 flags[];
> }
>
> where,
> 	flags[i] =3D (BIT_MAP(optional_features) << nr_required) |
> 		   BIT_MAP(required_features)
>
> This series introduces the feature header in the KHO subsystem, and it
> is used by serialized structures across KHO and LUO. A few of the
> serialized structures embed other serialized structures directly. To
> keep the relative offsets of fields to be same across kernels, we cannot
> have an embedded serialized structure's size changed; otherwise, direct
> casting will not be possible. To solve this, this series converts those
> embedded structures to KHOSER_PTR, which points to the memory just after
> the parent serialized structure, and allocation and preservation happen
> for the total memory (parent_ser_size + embedded_ser_size).
>
> <Iamparent>_ser {
> 	u64 a;
> 	u64 b;
> 	struct <Iamembedded>_ser e_ser;
> 	u64 d;
> }
> 	CONVERTS TO =3D=3D=3D>
>
> <Iamparent>_ser {
> 	u64 a;
> 	u64 b;
> 	DECLARE_KHOSER_PTR(e_ser, <Iamembedded>_ser);
> 	u64 d;
> }
>
> There are only two such instances: kho_vmalloc and luo_file_set_ser.
>
> This series introduces kho_ser_hdr for the following structures:
>
>   - struct kho_kexec_metadata
>   - struct kho_vmalloc
>   - struct kho_block_header_ser
>   - struct luo_ser
>   - struct luo_session_ser
>   - struct luo_file_set_ser
>   - struct luo_file_ser
>   - struct luo_flb_header_ser
>   - struct luo_flb_ser
>   - struct pci_ser
>   - struct pci_dev_ser
>   - struct memfd_luo_ser
>   - struct memfd_luo_folio_ser
>
> If you notice, this also includes the PCI ser structures. PCI LUO
> support is merged in liveupdate/next, and this series is developed on
> top of it.
>
> Each serialized structure is preceded in memory by struct kho_ser_hdr
> and registered via DECLARE_KHO_SER(name, payload_size, nr_required,
> nr_optional). Both struct kho_kexec_metadata and struct pci_dev_ser are
> explicitly marked with __aligned(8) because their largest member is a
> 32-bit integer, and 8-byte alignment is required by DECLARE_KHO_SER() so

I do not believe we need __aligned(8), because the struct immediately=20
follows the newly introduced kho_ser_hdr, which is 8-byte aligned.=20
However, we should verify that the combined size (header + payload)=20
is 8-byte aligned.

> trailing feature payloads remain 8-byte aligned across 32-bit and 64-bit
> kernels.
>
> Also, Introduce DECLARE_KHO_SER_HDR(ser_name, fhdr) which is just the
> wrapper for struct kho_ser_hdr fhdr, This makes it clear
> To which ser_name, this fhdr belongs to.
>
>
> Series structure:
>   - Patch 1 removes __packed from KHO, LUO, and memfd ABI structures and
>     asserts their natural size and 8-byte alignment under CONFIG_64BIT.
>   - Patch 2 records entry_size in struct kho_block_header_ser so the
>     incoming kernel derives the entry stride from the block header.
>   - Patch 3 converts callers that embedded struct kho_vmalloc by value
>     (memfd_luo and test_kho) to reference it via DECLARE_KHOSER_PTR so
>     struct kho_vmalloc can grow independently.
>   - Patch 4 converts struct luo_session_ser to reference
>     struct luo_file_set_ser via DECLARE_KHOSER_PTR instead of embedding
>     it by value so both structures can grow independently.
>   - Patch 5 introduces struct kho_ser_hdr, DECLARE_KHO_SER(),
>     DECLARE_KHO_SER_HDR(), and the serialization/validation helpers in
>     include/linux/kho/abi/feature.h.
>   - Patches 6-18 add the feature header to each of the 13 KHO, LUO, PCI,
>     and memfd serialized structures in independent patches.
>   - Patch 19 adds a KUnit test suite (kho_feature) covering the feature
>     header helpers.
>
> [1] https://lore.kernel.org/all/20260903023452.721732-1-loganodell@google=
.com/
> [2] https://lore.kernel.org/all/20261021152527.375070-1-tarunsahu@google.=
com/
> [3] https://lore.kernel.org/all/20261026174217.603114-1-tarunsahu@google.=
com/
>
> Tarun Sahu (19):
>   liveupdate, kho: Remove __packed from KHO, LUO and memfd ABI
>     structures
>   kho: block: Record the entry size in the block header
>   kho, memfd_luo: Reference struct kho_vmalloc via serialized pointer
>   liveupdate: Reference struct luo_file_set_ser via serialized pointer
>   kho: Add feature header for fine-grained ABI compatibility
>   kho: kexec_metadata: Add the feature header
>   kho: vmalloc: Add the feature header
>   kho: block: Add the feature header to blocks
>   liveupdate: Add feature header to struct luo_ser
>   liveupdate: Add feature header to struct luo_session_ser
>   liveupdate: Add feature header to struct luo_file_set_ser
>   liveupdate: Add feature header to struct luo_file_ser
>   liveupdate: Add feature header to struct luo_flb_header_ser
>   liveupdate: Add feature header to struct luo_flb_ser
>   PCI: liveupdate: Add feature header to struct pci_ser
>   PCI: liveupdate: Add feature header to struct pci_dev_ser
>   mm: memfd_luo: Add feature header to struct memfd_luo_ser
>   mm: memfd_luo: Add feature header to struct memfd_luo_folio_ser
>   kho: Add KUnit test for the feature header helpers
>
>  MAINTAINERS                            |   1 +
>  drivers/pci/liveupdate.c               |  99 +++----
>  include/linux/kexec_handover.h         |  15 +-
>  include/linux/kho/abi/block.h          |  21 +-
>  include/linux/kho/abi/feature.h        | 372 +++++++++++++++++++++++++
>  include/linux/kho/abi/kexec_handover.h |  11 +-
>  include/linux/kho/abi/kexec_metadata.h |  17 +-
>  include/linux/kho/abi/luo.h            | 102 ++++---
>  include/linux/kho/abi/memfd.h          |  27 +-
>  include/linux/kho/abi/pci.h            |  66 ++---
>  include/linux/kho_block.h              |   8 +-
>  kernel/liveupdate/kexec_handover.c     |  98 ++++---
>  kernel/liveupdate/kho_block.c          | 172 +++++++++---
>  kernel/liveupdate/luo_core.c           |  43 +--
>  kernel/liveupdate/luo_file.c           |  58 ++--
>  kernel/liveupdate/luo_flb.c            |  69 +++--
>  kernel/liveupdate/luo_internal.h       |   9 +-
>  kernel/liveupdate/luo_session.c        |  55 +++-
>  lib/Kconfig.debug                      |  13 +
>  lib/test_kho.c                         |  38 ++-
>  lib/tests/Makefile                     |   1 +
>  lib/tests/kho_feature_kunit.c          | 184 ++++++++++++
>  mm/memfd_luo.c                         | 183 ++++++++----
>  23 files changed, 1271 insertions(+), 391 deletions(-)
>  create mode 100644 include/linux/kho/abi/feature.h
>  create mode 100644 lib/tests/kho_feature_kunit.c

--=20
Pasha


