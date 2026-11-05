Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A1E606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IsAXF6eo
Received: by kanga.kvack.org (Postfix)
	id 6B1F46B05B9; Thu,  5 Nov 2026 11:53:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 689AD6B05BA; Thu,  5 Nov 2026 11:53:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F346B05BB; Thu,  5 Nov 2026 11:53:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9406B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:53:00 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C878160B57
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:52:59 +0000 (UTC)
X-FDA: 85401660078.14.8DEEF71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 57ECF40005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:52:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IsAXF6eo;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793897577;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRI/DkZV6dbTTbjQAyrbGlNtpsebatRCDLQei6fHCk4=;
	b=jAhbCKd/vAC8mObUTnPmwfHF/N3KXI4XLl86DA1HTBA+cYuCf+0Dlk2waXfmPp+D7lPn6X
	8VpTJxB8847Joh9M0NvS4/GhUHn6ck8LreBoKk+snpy+bzzT4AAQFFtKt575NaDt1k1auf
	qyWPayUlUfAD2b/0eZl9pyvxrJ9Bp4s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793897577;
	b=b9bvB6pXlEDSlhTYKFuu9+8L1JK1UwWwKRb2XzD+fMOnqNWWHe+UOFUJYYFzLcl1tCFhIp
	aQVR4R4xcJ5ZZPL9YQPt4YUFzobXDphuOnVwnnD4NpFzU3OFUaywS1wGVmGoiqS0xuQKp1
	NUiVFWnKiczwUOcigYZkGCl1WmpuUEs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IsAXF6eo;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 909D44146C;
	Thu,  5 Nov 2026 16:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256CF1F00A1A;
	Thu,  5 Nov 2026 16:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793897576;
	bh=fRI/DkZV6dbTTbjQAyrbGlNtpsebatRCDLQei6fHCk4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IsAXF6eoe4byQi/jxkSLQ8vVNL3PhxAWWzz4O5zLWDSKw/jIGom0f4FJ9ghfsvvwC
	 WL+5W+X59istuuNxTponFzlP3Yx1ptNXMdoSBfYLkdUBNcrz1ch8zYXc2kRQSuS4Up
	 UfAsHSvbKGR+llQ5roqFl9UI3++mGNcsq76NctSJT3wP+J57nrttbAy04v96epctyn
	 rjj/Gamt0UErYYNYxKokOdi2ms9BxSgsiUDzVcNmhaxsFkxkT9p2EWLp79THqqpF8/
	 c892/8Q9SDNr1X80xCLN3R7w8ePLGxaz+8vBRz5oL+QJlRryLSjD7vhGKToilEH7Ug
	 vLJuJ1VLhIiLA==
Message-ID: <sashiko-outbox-199552@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 14/14] irqchip/gic-v3-its: Preallocate VPE L1 tables
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QW5lZXNoIEt1bWFyIEsuViAoQXJtKQ==?= <aneesh.kumar@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Baoquan He" <baoquan.he@linux.dev>, "Mike
 Rapoport" <rppt@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>,
 =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Joerg Roedel" <joro@8bytes.org>, "Marc Zyngier" <maz@kernel.org>, "Marek
 Szyprowski" <m.szyprowski@samsung.com>, "Robin Murphy" <robin.murphy@arm.com>, "Steven
 Price" <steven.price@arm.com>, "Sumit Semwal" <sumit.semwal@linaro.org>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Thomas Gleixner" <tglx@kernel.org>, "Will
 Deacon" <will@kernel.org>, "Russell King" <linux@armlinux.org.uk>, "Benjamin
 Gaignard" <benjamin.gaignard@collabora.com>, "Brian Starkey" <Brian.Starkey@arm.com>, "John
 Stultz" <jstultz@google.com>, "Mark Rutland" <mark.rutland@arm.com>, "Radu
 Rendec" <radu@rendec.net>, "T.J. Mercier" <tjmercier@google.com>, "Madhavan
 Srinivasan" <maddy@linux.ibm.com>, "Michael Ellerman" <mpe@ellerman.id.au>, "Nicholas
 Piggin" <npiggin@gmail.com>, "Christophe Leroy" <chleroy@kernel.org>, "Ritesh
 Harjani" <ritesh.list@gmail.com>, "Shrikanth Hegde" <sshegde@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Gerald Schaefer" <gerald.schaefer@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Sven Schnelle" <svens@linux.ibm.com>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org, "H
 . Peter Anvin" <hpa@zytor.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, "K . Y . Srinivasan" <kys@microsoft.com>, "Haiyang
 Zhang" <haiyangz@microsoft.com>, "Wei Liu" <wei.liu@kernel.org>, "Dexuan
 Cui" <decui@microsoft.com>, "Long Li" <longli@microsoft.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, "Vitaly Kuznetsov" <vkuznets@redhat.com>, "Andy
 Lutomirski" <luto@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, media-ci@linuxtv.org
In-Reply-To: <20261104164555.3555725-15-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-15-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:52:53 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 57ECF40005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: huw6mr8pc4xe4jwbouconw6ike8p64rh
X-Rspam-User: 
X-HE-Tag: 1793897577-907328
X-HE-Meta: U2FsdGVkX19RxpEvYowQ/Fi8CVU6lUivEdcFAL5tZ4mdMIO5/kBH35v6jGvi6MoePLa4JJOdmaOA5EVTn/ClpYPn9J0IAlZemcWGOw8I0EbV2Hs/YjZONx4bwqQm1Qn7f4oAVc0UbAlOQAG5BQNp+neePQTwN0jmVYe+n07gprkOPGhCqNPEVwFIb+zJFn33DUzicl+qGQBQuTLzDjrFU5Vm1J0HkAFO+G8St2/740ALgHCBL2IsSVL6s6iJAdJwvdczWGrqvQrNztVaFlLwS4TSQXSeYAoLWo5iwr03UFRx+aqAXJjeh4hdlGvH25q1q+Yxcqc6YXhqavpQGcnCCs/cV1YNYiLQ62p58bL8IU2tHXmhY7tFO93S+SkhoNPJIEmtrTnmg7K8xb6tZBp2jdmxPWq2xQi231//anpYlKt5Ssihq0uBw89dHPXF2suCY/7ayodTWqiJChhGv6/68czv7UaZumziSxV3FoIoeR4UD6wktEBQEJ4Xnb7FuBEdUAS3+G7N6r2PAECtMd47bNgDSKQ1HALcAENC3PWLiqIn7rlB6CsgGk1iT+5JGTJ00yd1tzlqqe4fTAmkv9hYllxeLHd7zN0/KyQ9H9EIgY3/baR6ghbjGfh/eteJEERzA6tvHur1p0SlGhFkiDySrNRHIo0ZnFO3PHedG6f8lJmVn9F41uVUtmF+vzZsx92OdTqyTgfwGpsIsGJIP4fE+bBUSgvBMBkFe7XlmfNGRjZ/MVYhCU2nmYDbMXsCPxfHcn8NRFNkPxZ4d4omUdycu19dCzNXlMLOCdroqOjTCbO2zjU1ccApvODW2+/PVTamVbNq5BPLabVGEcolnesakDgTj73kUg5Y0BfrsNlORMKr8URJgGaA0b9npRT6fa6jOEw/om51A/YCDVMDThwYllRwueeqqo/MUTDr2hWBE50/9gwW6mhLLVoTXKHezWVN2To/t+Lkw0SHQ2c9wKj
 mcF7EMYu
 2PUMwBUkK5ke9aocqdir88MQ5K3ERGOo6LqJWfUDKCJG99a31IB7DtVZskevPhmUkZKJo6r7RJ+GbYFSEbjDLGmG0HY+X5Dh2ugMvyYbhC3r+17ZciLnUFOAZa3tMk/JpTh3yrzbdK8eEPFDqw6KdwZsSvLdFnea+VH6EhfB9UDfwrSpI8VaBJ1fmJ3PtYybnJ/LoChxlYbGMloJrWzj3YyOL3c012amt7OqtoEetP7oq8m50FrwyG7xAdhYe+i8qY670mVKJENpZStvj+gKr28qpAIxlBgo1r8d3YCgrl12x5QZflZPt1bXi485q/eT8X7sudmPDe+rvEQy4vRJH6GLQsaKZTXlS0MBDO0hphMn11SWeIaObNom4v3rn7PCna+fslrlOQ5ZiYZjHtmGVQ4f/2bXaCUcyybGFgj7hcwsmrG/n9I+Vio4jV3slCw7C1VYUCCGwkaCR9Rfq3ohA/9Rs002DsTQ2iL+1XfLlPbDMOqMRoAitPoVQr5C/m0S1iM+5dNF7AYaLDBfz9kUcmxFRHABY+UEp6cGdB09mbwUiyCbBuqzhUz+CnADPNjO/gpRkpITIEYZN3p9dZd+c0CMUC44uq6RBPokeFC3+JkudqRYCNayQEreOkXdgdBlxqrt/g5+L9JlbUY+TIkBX6+4EB8UJXG6a5Debk/2wVqFIcXdIW3IEZECNiJiU+ggDrpyFEr45BnHYFV0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] irqchip/gic-v3-its: order mismatch in allocate_vpe_l1_table() on I=
TS inherit
- [Medium] irqchip/gic-v3-its: memory leak of vpe_table_mask in allocate_vp=
e_l1_table()
--

commit d29e0b57c45efd854666ff7af1f84a27011e992c
Author: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

irqchip/gic-v3-its: Preallocate VPE L1 tables

This commit removes the GFP_ATOMIC VPE L1 table page allocation from the
CPU-starting callback by using a blocking allocation on the boot CPU,
recording the table order, and preallocating pages for secondary CPUs in the
sleepable CPU hotplug prepare stage.

> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v=
3-its.c
> index 9ad66253ab166..5628f497d389d 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c

[ ... ]

> @@ -2990,7 +3014,16 @@ static int allocate_vpe_l1_table(void)
> =20
>  	pr_debug("np =3D %d, npg =3D %lld, psz =3D %d, epp =3D %d, esz =3D %d\n=
",
>  		 np, npg, psz, epp, esz);
> -	page =3D its_alloc_pages(GFP_ATOMIC | __GFP_ZERO, get_order(np * PAGE_S=
IZE));
> +	order =3D get_order(np * PAGE_SIZE);
> +	if (use_prealloc) {
> +		if (WARN_ON_ONCE(order !=3D vpe_l1_prealloc_order))
> +			return -EINVAL;
> +
> +		page =3D gic_data_rdist()->vpe_l1_prealloc;
> +		gic_data_rdist()->vpe_l1_prealloc =3D NULL;
> +	} else {
> +		page =3D its_alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
> +	}
>  	if (!page)
>  		return -ENOMEM;

[Severity: Medium]
Does this leak gic_data_rdist()->vpe_table_mask on these error returns?

Earlier in allocate_vpe_l1_table(), when inherit_vpe_l1_table_from_rd() does
not find an existing table to inherit, vpe_table_mask is allocated:

	gic_data_rdist()->vpe_table_mask =3D kzalloc_obj(cpumask_t, GFP_ATOMIC);
	if (!gic_data_rdist()->vpe_table_mask)
		return -ENOMEM;

If inherit_vpe_l1_table_from_its() also does not find a table to inherit and
allocate_vpe_l1_table() subsequently fails because order !=3D
vpe_l1_prealloc_order or page is NULL, it returns -EINVAL or -ENOMEM without
freeing gic_data_rdist()->vpe_table_mask or clearing the pointer.

> @@ -3007,6 +3040,9 @@ static int allocate_vpe_l1_table(void)
>  	val |=3D GICR_VPROPBASER_4_1_VALID;
> =20
>  out:
> +	if (!use_prealloc)
> +		vpe_l1_prealloc_order =3D vpe_l1_table_order(val);

[Severity: High]
Can vpe_l1_prealloc_order mismatch the order computed for a secondary CPU w=
hen
the boot CPU inherits its VPE table from an ITS?

On the boot CPU, gic_init_bases() -> its_cpu_init(false) ->
its_cpu_init_lpis(false) -> allocate_vpe_l1_table(false) calls
inherit_vpe_l1_table_from_its():

	val =3D inherit_vpe_l1_table_from_its();
	if (val & GICR_VPROPBASER_4_1_VALID)
		goto out;

When the boot CPU redistributor shares a VPE table with an ITS in its affin=
ity
domain, this jumps to out: without probing GICR_VPROPBASER, and
vpe_l1_prealloc_order is computed from the inherited GITS_BASER2 value.

However, the ITS VPE table is sized by its_parse_indirect_baser(), which on=
ly
switches to a two-level indirect table when the flat table exceeds two GIC
pages and GITS_BASER_INDIRECT is supported:

	/* No need to enable Indirection if memory requirement < (psz*2)bytes */
	if ((esz << ids) > (psz * 2)) {

By contrast, when a secondary CPU in another affinity domain cannot inherit
from a redistributor or an ITS, allocate_vpe_l1_table(true) probes
GICR_VPROPBASER on the redistributor and enables indirection whenever the f=
lat
table exceeds a single GIC page:

	if (epp < ITS_MAX_VPEID) {
		int nl2;

		val |=3D GICR_VPROPBASER_4_1_INDIRECT;

For example, when the flat table is 2 * psz (or when GITS_BASER2 uses a flat
table or a different probed page size than GICR_VPROPBASER), the inherited =
ITS
table order is get_order(2 * psz) while the secondary redistributor L1 table
order is get_order(psz).

When that secondary CPU comes online, wouldn't allocate_vpe_l1_table(true) =
hit
WARN_ON_ONCE(order !=3D vpe_l1_prealloc_order), return -EINVAL, and cause
its_cpu_init_lpis() to disable GICv4 support?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104164555.3555=
725-1-aneesh.kumar@kernel.org?part=3D14

