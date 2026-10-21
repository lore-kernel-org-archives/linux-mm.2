Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C720606A33D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 13:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mt3hXrxe
Received: by kanga.kvack.org (Postfix)
	id AB3676B0248; Wed, 21 Oct 2026 09:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64B06B0249; Wed, 21 Oct 2026 09:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B156B024A; Wed, 21 Oct 2026 09:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 796F26B0248
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:23:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7C5BC055C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:23:12 +0000 (UTC)
X-FDA: 85346699424.30.BD2D39B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5CECD4000E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:23:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mt3hXrxe;
	spf=pass (imf01.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792588991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAAU30bwGvhgKc2fcWmaPUnM+q1nxRImGaxZJ4BonqU=;
	b=vez8rCkBEH1JQYY5tv7W/YuuNbs+3gB1ZyhpzsZkvWynSH+yUhMUhYcZOhZe2CzYoHfAum
	CeJWzzVD02MJxY0YW9vddtD+UG4oMGVP0SLAIJRH66lTohrCVuK6q1eUrEEnEQBo2YyOND
	CPhOAfnWtcl5WYxNPMPAuTdNgeSL7Ys=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mt3hXrxe;
	spf=pass (imf01.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792588991;
	b=1jJgFFVmE/c0dz5q9uB99ezRO9fcAFO/Qz3HWOPuEVYpXiZ56RPeh09+WHvmYt91cO0mPX
	E5kYqQ0ZrI7HOvPZZ3ySngX16cYZc5q9NaXUbFudGl58796W4Ibh5AIZnfEefTYYJTek+F
	CM47z94KGuT19ecU4OJYRParyXoGS6Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 89ACA601F1;
	Wed, 21 Oct 2026 13:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039AE1F000C4;
	Wed, 21 Oct 2026 13:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792588990;
	bh=pAAU30bwGvhgKc2fcWmaPUnM+q1nxRImGaxZJ4BonqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mt3hXrxeKJoJfLibADZIcsXR7rI+NO9d5jFB7CsWQi7wKkA7Ivi+NuujoLsu6N0Sj
	 xeAk+R1NrRVYx1sYEncPNYK1tOB4gOmoV/soXvOeMmPj9evSIL4UZE8ME5ru4NQo5h
	 rdmao/ez90tKUwo3/XUgCH2iLLiz95UkX5/e2YrP1miGaCfo8O/R8cfIYLVig3VVnr
	 r1iNDVPFLS7bpM7kU7EAqqH+8hkxOiLRbqqi3tb+hZaOnZwWSQEHk7khqjrR4q7t3A
	 S0lU2etMBYUN25UboD24fjrlEjMmDt+fIwEsaB4T+GmpTzCmxcQVMevggk/I2FaJ6K
	 4dRr3m+UTBq7A==
Date: Wed, 21 Oct 2026 08:23:08 -0500
From: Rob Herring <robh@kernel.org>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: baoquan.he@linux.dev, rppt@kernel.org, m.szyprowski@samsung.com,
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
	chenhuacai@kernel.org, kernel@xen0n.name, pjw@kernel.org,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	saravanak@kernel.org, akpm@linux-foundation.org,
	pasha.tatashin@soleen.com, pratyush@kernel.org,
	ruirui.yang@linux.dev, robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Subject: Re: [PATCH v9 0/8] kdump: reduce vmcore size and capture time
Message-ID: <20261021132308.GB3667411-robh@kernel.org>
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021083011.2170525-1-chenwandun1@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5CECD4000E
X-Stat-Signature: 9ustt7gm6fk9i6x95pjakt73ah6q999t
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792588991-359761
X-HE-Meta: U2FsdGVkX19WjlHo/VjL7rYpNosqSRlJR1b9QQO7XrmuwcyFxwP+46jPezi4BnB6NbwSRHqk7c2Dx9O5rJcWneNtAc8zSgNPHIs01hJQWTe3ATKFh3r1n0D95oxF7FhhT2t0PH8nWQUnZ0tr6XtiDsydnuSCNsP6CFLmIryZPHFuAk31w7TtZXrzPZNB6lUAz0IQwyNgtL2+nSSRSTsoCUKm+bJsnvbNZJEKBKEEDyDSOSpt47qGCdK0HDP2/qsNrg3Sq+7NkuvxUf7fNixVPhwH8Xh9hAJmhSVi9PolE8n8ktYAn/DhRDYvkRQCWbT8FqeB8MDBb9uKhH0wthAu7k+7SnqKeMFyMPDcPwVFcukupZdMAZsGuxUdQXUzquJ/UsSxbUtKEvJytXiED1SDDj/76KMBUWKWevHWzTm8BOQ2nv+M/9DtJArd9LV34APUZzQ9qe4Slpw1MRevUK/V7NusX44gHbXgKIrbk45AZwPrEEcYwUgT/QBFySVZLj2dkzPfvvL3vIT5iP6UX1WNY90rEnHuKhoYjC8xeZ1g222CtqylXYvmsHb/R/R3Tp9oLrLHsUaUDJsHdjPE9sxXH+l0Td5IF0qS/UFae1YLwWOyBW1hceBisey1sq9zMRc+KdSwgVpXz9gS67O4yxDbd7HVr121StK+7D1nnecMzoeSJGpQUBWl1KuL0n1mMKgPLLAODQ25JtnXlnDFPysfX+kTbKyhEHMWrjlkjE1nGCjq6hlkhptc8lcM4Z4xgGLw/2V6pvQsWsctmWlkOFqMdcv8oJ0/DLbGzuDUt0EkCPGxt9iojz3bYSNBRxqWbgdXw/RhjnIMvHrkYm4JXL8LAtdnbLkbbetij5l1p7JWStOuAxTvTX8f06ePaTgBf6C8YYDmZWpf/a5OcUaEZR/dpfEO2hy/JokCx3gprcAOxOFcJUVR5nPrUIZIExO9NzZHCaglmIoUdq+nCOTfSu6
 ky7u9vLD
 jhk2LJ8ulkR5GFOxEWZvX/swc0CUDGkqBYHtIZ3LisPkDiJ/OnuRGjSp5/hUVhWI/5SXEOwn7/aQ2a/0cZD8LexzPj1JWe1/2HAYEVNSHTXJNGsx7Q5f9gFrIwzmPU3B0lioIHDB7h146r1JUUWLGEM0Crp7NEnODdDmZUiDDdXxdV9eHZuUFiTbrNw+MXwBZ5YPz6Lr5Pl2DS5F0AfjegmJq1JKobszMU0e/HxbtdS77SbbGf4mJ1/3sxW8Sl6nuWTo/eXr2GS3n/UIqXN/+A4DPwzWIBoTi51tQLf9bRQjbq9k1g5iaRnM91LecmZgH648fR04J0F/pccIfwCdjb8ikazfMUmu+3BzdwcVGqJ8hmAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 04:30:03PM +0800, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> On SoCs that carve out large firmware-owned reserved memory (GPU,
> camera ISP, ...), kdump currently dumps those carveouts as part of
> system RAM even though their contents are firmware state that is not
> useful for kernel crash analysis.
> 
> ACPI systems already filter reserved memory out of the vmcore through
> their existing path: firmware reports those carveouts as unusable in
> the EFI memory map, they get MEMBLOCK_NOMAP set in memblock.memory
> (is_usable_memory(), efi-init.c), and the ELF header builder has
> always skipped nomap regions; only DT-based systems currently fail
> to filter these regions, which is what this series addresses.
> 
> This series introduces a MEMBLOCK_NODUMP flag (suggested by Rob) in
> memblock to filter reserved memory on DT-based architectures. A new
> flag is needed because MEMBLOCK_NOMAP can only express regions without
> a linear mapping, while MEMBLOCK_NODUMP can filter regions that are
> linearly mapped. Reserved regions are marked MEMBLOCK_NODUMP by default
> so kdump omits them; reusable CMA regions are different because their
> pages are handed back to the buddy allocator and may carry crash-relevant
> data.

There is little point in continuing to send new versions until Mike 
agrees with MEMBLOCK_NODUMP being added. You didn't answer him on v7.

Also, I intend to apply this[1] before any further reserved memory 
changes which will greatly simplify the code.

Rob

[1] https://lore.kernel.org/all/20261015082315.56876-1-m.szyprowski@samsung.com/

