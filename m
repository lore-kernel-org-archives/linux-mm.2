Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55F50606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 08:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iNN9pxJF
Received: by kanga.kvack.org (Postfix)
	id 7B7F06B08D4; Thu, 22 Oct 2026 04:33:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769096B08D6; Thu, 22 Oct 2026 04:33:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6316B08D7; Thu, 22 Oct 2026 04:33:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 464E76B08D4
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:33:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EAC4416025F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:33:21 +0000 (UTC)
X-FDA: 85349597802.10.0CCFCD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5218240008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:33:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iNN9pxJF;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792658000;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flFPZllbaKoBIHFswczsH7CR5as1Rw0sc8rUxUyOmGI=;
	b=7kV/00Mn4yO4QQNd4dY0ccIMSuojF0gnD50EJ96ovZFs08SgBy9Ayvld9m0fJV+adYzUxz
	rql/pFlZ1A/mwS3gnNu4GIk5/wU7N4MzOSc2BurzXmZLwD6ID6d3bo0NYW4pTpw2X+r/zb
	ctwG/fcp/5hFCeno8TCmsi7B9eS87U0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792658000;
	b=0YEKFNi6aAO4JJxud/g/7Jlg7Y0dhGss0W0MXQjF5lirj4q9suh13Gpa3CL+bogWQCWyDg
	Ri2Pgh/X7iDstpxAr7kYAIP9uZgVy08dCaSvb9NqsLIE8bWiIJr1gDJrofVLk8SYXsgqTZ
	zg9JGH3xDeBysRU+zmuU22gGrlsarD8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iNN9pxJF;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B8EA3601F1;
	Thu, 22 Oct 2026 08:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E4B1F000C2;
	Thu, 22 Oct 2026 08:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792657999;
	bh=flFPZllbaKoBIHFswczsH7CR5as1Rw0sc8rUxUyOmGI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iNN9pxJF/9PFRFCBOoaXQOn8ujjifNb20yGhbn2HabesYdauaidzpm/MkGmUUFCyy
	 bE80P2WRFeGrj5ltvDXJVQQTy/i0/9MlWgJHD7XtemlXn0qec6E8ETp6L6Ieds9N30
	 1O8kDzFxKbu713xi5/fU0j2Tg1chVMArbx7aOpw+Cwmlb+hr6kRPKnE36QGLhspWoT
	 B7BpQvDA57hXsFMsy1NqMIkqcOsp9NuM+IYIckpuzqKuK7VAZEUZ3DiNl21ZzFLVHO
	 lPEl7wm2qZYg7m0XifQ38ufLdsKeh+BQdnfINwPZjZXB57PkNf9XIYopp1SrVowRjL
	 1xiGL7CycOLRA==
Message-ID: <sashiko-outbox-181183@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 7/8] of: reserved_mem: mark /reserved-memory entries
 with MEMBLOCK_NODUMP
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wandun Chen" <chenwandun1@gmail.com>, robh@kernel.org, baoquan.he@linux.dev, rppt@kernel.org, m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, chenhuacai@kernel.org, kernel@xen0n.name, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, saravanak@kernel.org, akpm@linux-foundation.org, pasha.tatashin@soleen.com, pratyush@kernel.org, ruirui.yang@linux.dev, robin.murphy@arm.com, devicetree@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, conor+dt@kernel.org
In-Reply-To: <20261021083011.2170525-8-chenwandun1@gmail.com>
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
 <20261021083011.2170525-8-chenwandun1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 08:33:17 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5218240008
X-Stat-Signature: q7bcati5ooryey4m3xd45r7b9yfru8xx
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792658000-469291
X-HE-Meta: U2FsdGVkX1+Lh1yZXI12hbnxyVboi7RFZtCJESBMF3yju7/ZcZBvigDYhFs1lgGXIqjS4UqiaWgAlplpa+P+TEwcnW5Yn7CnR7REqe4yYesFfDry5xRvlBtro9lNE6UyON2psSBqoVeUkarSmE2p6GbW8NDZdSOzwhbBfuaQs2fpeHT6i2qNvAeFEO02ZcS1oeqZbTGL/oXcDmLwbef1Txeq7UyEj5sUvw6gl7q5EezfzqEnqWm4uN6qb3YgKChQg9RzfF6ZmqF+PcaW3nVI/dGIL1ZeKU3QRcesMSETZNY0WwchQxu/8lGWeX+hWGQrEEwUIaS0VWzTbEjUYRnSgup7ABy2Wvp2VxvNOCecFvQr+LJkzS3dHIeDY9claPVCSUvz5mY+Y2uF8r6SB3j+A0QkupM8v05u+wY4rbHQ1+RW/H/cP0XMAJ4oEVq1RQqzW0INN/0BsoIzQDyX7vRpyQD1PgR12aztkfedm7k4Qjtyxs2POcV0Vm13N7R/OQuKZrZYyYKX8jg1aaILFv2M8yRoQZqgIAi7/7sMdKCB+I7lG6syWyHTloEXJL7if+ptggIvZB0WiRd8pCoNzS2lxqseTSolMee78PTruN2lnDxEkJCLe7ywhoeDAO6l7KjedQLwepX4qXbHqCk7eqakNBOP0ZOOq9fDcqUsaC81+4SFpTuX02PQZeXEFKvIuUnWQEs/2JMKSkCvBdLsnePjD9xx+DMarGNRnIhDs/KxfXuLv0HoWaq5UB75YyljW1yNsy6tDGiRfPcDTZvJnNO0MEvsI6Qm4rtrZkE0o0SWYheqyTfshuTNwDYxvQrtPDnskOVN5ISDlS7gfc59xDfNgmbqKAu5EuB6JpCLRhaNSoYSATw9WPNXrr2ZBNv61lPx7Fw4xxJxvHLIXRl+5WtHMqqE8eVd/4uY3Gau6sZmB9Hf8ZhPteNsPOdHL5ib2YdkZEzq8akSF1bXNmy2alr
 PzjZDZ4k
 kV5my4O1MkFf08LNfiLgUWFsilaLMGukf1z1REAIhA40ZP7RKbtp7kzWxiGQUKRy54kgUzgSkJIg5Cwi1nSX3PItHxU0kl3wRDlLK7G7tOeNCe0TadAM+fab82sfZH6hvt4V3Zp47hXk6SWn7GthNG1a+KIpkW2Nqx7cnIqDZNYWtTbSZGeOzIFwogbMZNbxTfHvpUsFzmIJZgNj/E/FiCdLlxG0DKthm5PfHWKsmYoQoTysBPuxUnQHB5I//6AHMLkyLGJFnBE8RvJzSHDpnBV88Yl+TzyjrJzsQ+aad/gjqN+l9eJMXGswvo1/fLYmU9WnzMChJLvfBeFEz2DZ0iCMwXTTfHBPemeKNZToQIdr5IhUPXwXKxD4nZ5L8DCAq1uVP13Vnal69nyzAZl/dmyMCyw5HnyyUHnxs5ALCncOQ+Yz3oJ4zAPe6DN8Oqjbqy1toel7TZD4kTxsmkWhsxTNhcVj9VytC/gPPPei4992/bBLOCr9WwLOQh77uca+5F9xCIgK/V5XwCEsjCePFR/MBG3TIRTiQbBZVOlrxF3f2BzFrwbcNK2qTigD4WYJt2+ucmnRHQDc/e14K9ZmUAmrj+k3VM+N0Sh+azcqiwtu3iT+J/DyqvLcOQ8YY5CbRgQsuXOD912o3j2ORSWI7SkjMO3Icw1tbwDxdHvIWOnkiajkZZrqxbR2jqDmFdgAZLP3LbIU0CHo5xLHVQzDx8knZyOqL3eHp9dFEj//kEfY6r+GuJfrcX8wfCc0WqzhKbXcLHGoj1QG7wK4MGkiTsbZGucKlOkys40JfwHDg51sybwE=
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
- [High] of: reserved_mem: unaligned memblock split in fdt_mark_reserve_mem=
_nodump()
- [Medium] of: reserved_mem: fdt_mark_reserve_mem_nodump() marks failed res=
ervations
--

commit a452b9d1fad838de511c25fe48e4541c58357355
Author: Wandun Chen <chenwandun@lixiang.com>

of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP

This commit adds fdt_mark_reserve_mem_nodump() to mark non-dumpable
reserved-memory regions in memblock.memory so kdump omits them from the
vmcore when crash dump support is enabled.

> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 8c9d6395d6a39..db2bf76000d23 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -677,6 +677,24 @@ static void __init fdt_init_reserved_mem_node(unsign=
ed long node, const char *un
>  	reserved_mem_count++;
>  }
> =20
> +void __init fdt_mark_reserve_mem_nodump(void)
> +{
> +	struct reserved_mem *rmem;
> +	int i;
> +
> +	if (!IS_ENABLED(CONFIG_CRASH_DUMP))
> +		return;
> +
> +	if (!IS_ENABLED(CONFIG_KEXEC_FILE) && !IS_ENABLED(CONFIG_CRASH_HOTPLUG))
> +		return;
> +
> +	for (i =3D 0; i < reserved_mem_count; i++) {
> +		rmem =3D &reserved_mem[i];
> +		if (rmem->size && !rmem->dumpable)
> +			memblock_mark_nodump(rmem->base, rmem->size);
> +	}

[Severity: High]
What happens here when rmem->base or rmem->size is not page-aligned, or
when rmem->size is smaller than a page?

Previously, mapped reserved-memory regions were only recorded in
memblock.reserved and did not split memblock.memory. Calling
memblock_mark_nodump() splits memblock.memory at rmem->base and
rmem->base + rmem->size, but reserved-memory regions are not guaranteed to
be page-aligned:

drivers/of/of_reserved_mem.c:early_init_dt_alloc_reserved_memory_arch() {
	end =3D !end ? MEMBLOCK_ALLOC_ANYWHERE : end;
	align =3D !align ? SMP_CACHE_BYTES : align;
	base =3D memblock_phys_alloc_range(size, align, start, end);
}

Static device tree regions without no-map can also be smaller than a page
or unaligned to the page size (for example, cfe-stub@0 in
arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi with a 0x1000 size under
16k or 64k page configurations).

When memblock.memory is split at an unaligned or sub-page boundary,
__next_mem_pfn_range() rounds each region inward to page boundaries and
skips sub-page regions:

mm/memblock.c:__next_mem_pfn_range() {
	while (++*idx < type->cnt) {
		r =3D &type->regions[*idx];
		r_nid =3D memblock_get_region_node(r);

		if (PFN_UP(r->base) >=3D PFN_DOWN(r->base + r->size))
			continue;
}

This drops any page frame straddling an unaligned split boundary from
for_each_mem_pfn_range() and the page allocator.

In addition, request_standard_resources() in arch/arm64/kernel/setup.c and
init_resources() in arch/riscv/kernel/setup.c register each mapped
memblock.memory region using memblock_region_memory_base_pfn() and
memblock_region_memory_end_pfn():

arch/riscv/kernel/setup.c:init_resources() {
		res->start =3D __pfn_to_phys(memblock_region_memory_base_pfn(region));
		res->end =3D __pfn_to_phys(memblock_region_memory_end_pfn(region)) - 1;

		ret =3D add_resource(&iomem_resource, res);
		if (ret < 0)
			goto error;
}

For a sub-page region where PFN_UP(base) >=3D PFN_DOWN(base + size), res->e=
nd
becomes smaller than res->start (or underflows when end_pfn is 0), causing
add_resource() on riscv to fail and tear down iomem_resource, and producing
an inverted or underflowed resource on arm64.

Splitting memblock.memory also splits hyp_memory[] on arm64 pkvm, where
check_range_allowed_memory() in arch/arm64/kvm/hyp/nvhe/mem_protect.c
requires checked ranges to fall within a single region:

arch/arm64/kvm/hyp/nvhe/mem_protect.c:check_range_allowed_memory() {
	reg =3D find_mem_range(start, &range);
	if (!is_in_mem_range(end - 1, &range))
		return -EINVAL;
}

Could memblock_mark_nodump() corrupt resource registration, drop straddling
pages, or break pkvm range checks when regions are not page-aligned?

[Severity: Medium]
Can fdt_mark_reserve_mem_nodump() also end up marking active kernel memory
as non-dumpable if an early static reservation failed?

During early boot in fdt_scan_reserved_mem(), __reserved_mem_reserve_reg()
logs an error if early_init_dt_reserve_memory() fails (for example, if a
static region overlaps the kernel image or initrd), but still returns 0:

drivers/of/of_reserved_mem.c:__reserved_mem_reserve_reg() {
	if (size && early_init_dt_reserve_memory(base, size, nomap) =3D=3D 0) {
		fdt_fixup_reserved_mem_node(node, base, size);
		pr_debug("Reserved memory: reserved region for node '%s': base %pa, size =
%lu MiB\n",
			 uname, &base, (unsigned long)(size / SZ_1M));
	} else {
		pr_err("Reserved memory: failed to reserve memory for node '%s': base %pa=
, size %lu MiB\n",
		       uname, &base, (unsigned long)(size / SZ_1M));
	}
	return 0;
}

Later, fdt_scan_reserved_mem_late() scans all available static nodes in
/reserved-memory and passes them to fdt_init_reserved_mem_node(), recording
them in reserved_mem[] regardless of whether the early reservation
succeeded:

drivers/of/of_reserved_mem.c:fdt_scan_reserved_mem_late() {
		if (size) {
			uname =3D fdt_get_name(fdt, child, NULL);
			fdt_init_reserved_mem_node(child, uname, base, size);
		}
}

Wouldn't fdt_mark_reserve_mem_nodump() then mark that unreserved range in
memblock.memory, causing kdump to omit memory that is actually in use by
the kernel?

> +}
> +
>  struct rmem_assigned_device {
>  	struct device *dev;
>  	struct reserved_mem *rmem;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021083011.2170=
525-1-chenwandun1@gmail.com?part=3D7

