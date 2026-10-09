Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4042BCA9EBE
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 17:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 152BD6B0098; Fri,  9 Oct 2026 13:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A926B0099; Fri,  9 Oct 2026 13:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 040CE6B009B; Fri,  9 Oct 2026 13:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D429D6B0098
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:10:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 64F861A043C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:10:30 +0000 (UTC)
X-FDA: 85303726620.06.645130F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B631C1C0005
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:10:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1Nhseao;
	spf=pass (imf18.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791565828;
	b=mDmgagZCwFdcidRH5iJU+kJjZ57ut3pOp0gydGiJemFN0jil9LjIafjEEnemnegvCAmpvL
	LBxhzy2xTOoLnHcvS+mKlIbuJyFTJJv1cEGU6xdM2MCxlHVkAfZx1BH0xPB/4GX9N5w+sT
	vDaOhcoY0HmKqhpy2dowFSJvBww6yDE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1Nhseao;
	spf=pass (imf18.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791565828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kAD7jZL3WT2oDggDD/W1Uk0YnF3NERQV17t5J8hJ8+M=;
	b=Bo79gX25aUXzkuJJirAqFeDB34vn9Q3ry8iIWaoXLxEPMWyiMQpF/xBYQto8ghdEKDl7iG
	05DKItaY8h81Sf6W/xpTQZFzM5fBcUgqX1g7dL4hAg4y+vjO4QuEkoxP/8KSxR4LSwQY1h
	add2ATmB5q8gpQg8KAfyU+st8qHc9Gw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E468243F04;
	Fri,  9 Oct 2026 17:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F951F000FF;
	Fri,  9 Oct 2026 17:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791565827;
	bh=kAD7jZL3WT2oDggDD/W1Uk0YnF3NERQV17t5J8hJ8+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q1Nhseaoa+rDmPgv3RV88Xq/keczcbIu4FLYepJnBvD2cRWQ9lipkpUB7/oP4GWM2
	 FtecI4n/MNfujCQ2qyTF3wHtE8IruMwItFTLmIBKKeC3vlmY0G1hsyyVZAtoiwWou8
	 P3DbUqJp9Xmpt/k5D8+TZwqQdKWqiN19Lf+AJ3W0+6UWmvY9NsCpCPQCR2qUhmOLIC
	 8Ojr7flTBUGp+qSaJwC9QVMRhzWedJSGwa8czVneuywDeGOD4MwdC3oFvmjdVrC/MQ
	 pQQu6ro5HclX1M3k8qO/i9gCSAbnfYwfDkfc5jGddIzvabPGzItOqeLhZ1tE9Uequ/
	 TaRWxOs50oK2g==
Date: Fri, 9 Oct 2026 12:10:27 -0500
From: Rob Herring <robh@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Wandun <chenwandun1@gmail.com>, baoquan.he@linux.dev,
	m.szyprowski@samsung.com, catalin.marinas@arm.com, will@kernel.org,
	mark.rutland@arm.com, chenhuacai@kernel.org, kernel@xen0n.name,
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	alex@ghiti.fr, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	saravanak@kernel.org, akpm@linux-foundation.org,
	pasha.tatashin@soleen.com, pratyush@kernel.org,
	ruirui.yang@linux.dev, robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Subject: Re: [PATCH v7 0/9] kdump: reduce vmcore size and capture time
Message-ID: <20261009171027.GA2734758-robh@kernel.org>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
 <ar9ogXc12cLjziHS@kernel.org>
 <80af60db-8c39-461c-a488-3dfee990bce8@gmail.com>
 <askVvEPHyrhpF8aw@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <askVvEPHyrhpF8aw@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B631C1C0005
X-Rspam-User: 
X-Stat-Signature: teamowikeqogo9axdswrwkzkigshn7ih
X-HE-Tag: 1791565828-578574
X-HE-Meta: U2FsdGVkX19zcXhLB1DeemDNEMquXlpTAFSShuHPIZ8r3hEip8gExSEA3jVrTrx8UBvyRXNkr+1jlxF08aFy2qHc6pEziSQGG3i79y1uelSzUQX/mzc1rr9iiadzqD5vToPmfNtyegzMbQro4HFoL35RZ/PePPrDWIQg8JV5Z0h+nkRCDC7xNF9LALBlI4Yp4QYc6U/EHssYrCpSJo/exKfQUdGsXBeVukwtUhLj4orJXk6Jv4yRSgOS0FDsgeZRabV9TlKQjThCQ9Rg93lBkIIGiN2/ZHEEZ8kyP7s5Or19XkHnqpIXjD6UUP7aUEr0C2JN0ShzF/4vL4jLoOb8sp+h3Lc3NAvDDvl0I8FPVQW+QGQZiHyc2ldpaMcipYjs3JTBjW7+bowJT6vtbdfEyS6nMtncMVbCMQkBAGhiFd1WXergWebDiDjaUWyFrE2MpwjbN5fJNftjRyZrWsrTiK4MCoyETWIMR1n/9J/6y+WxJhfQyvMjQNzM472kp+pjn3CtU65rZBVQYoIpUt5yL+UrBZJDRubWRzwGq/H8vJHf9ySe/sLT/4CS5B6puzOaEwKtbnSW2BbD7jxYtK5MJ11z1w4OkfRqw6VkDe9Ni49Yi6Q7EybCPRD7vHrWdGEpO7P+OT+tHALrMDZg7eqzaDpzcchVuG4M82c54L6ytGgWKhXTgOHwPSO4hyMuiRkKLL2H0cNfWV6ASQ5jnQmxeU0/Pqe39G10bjnzzEhX835ZBexDvwhXw5Im60agCUeOGDIbxtry+DzV81o3GhDiuGCN5RcNEoWXz6RbfHE6O3Iw/fl1INRz5/ar3z2Dt6Wxu9GjGawNsSmBvXN+i4tbVUuaJhQH4N1Jq409oLgVc0Tp6mNmjttWMn0Eeo85lSBvTPoheYtX5n+ygkX9ey4Mk9mFzVLhMJ3hoLYGXoSi36Ik7HQlOmfKLusRRZT5SCUglf2a5mktbR3XXIedhaQ
 sjyJCkBH
 CxgyWeXXQHoRWtyzb62JAIY0yFWZLPhHvWCzWFsambjJp+pPc/Nc7IQn2KVENrsFL6+awgYqsO5j4yvb3amJ8GWu+zVbZgtTWVenZljb0WUyKJgUkyEpMy6iHO9UXtObshaa8EIZOTTXD2iW9MLAj+b0GBxA3lDWmKpUMM0jlgNDDNyNGJJBmLAsc4jvaTe6nMHeoVRmElkBxPGQwbv9/4avnPOgGx57BtsQqghXAO3DDAKZhWgs3MIIH6wJlExsSTQPzIXE2TFEnR/+/Zu+YqhiMhVKrk0Y+QRz+0p+qpBNP/fBjO+sPv24B3g2IJkfSVQKb4gjRXHow+7GuZYYAhTAD//NzXw/nurNd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 06:26:36PM +0200, Mike Rapoport wrote:
> On Fri, Oct 09, 2026 at 11:04:47AM +0800, Wandun wrote:
> > On 10/2/26 16:17, Mike Rapoport wrote:
> > > Hi Wandun,
> > > 
> > > On Tue, Sep 22, 2026 at 04:42:47PM +0800, Wandun Chen wrote:
> > >> From: Wandun Chen <chenwandun@lixiang.com>
> > >>
> > >> On SoCs that carve out large firmware-owned reserved memory (GPU,
> > >> camera ISP, ...), kdump currently dumps those carveouts as part of
> > >> system RAM even though their contents are firmware state that is not
> > >> useful for kernel crash analysis.
> > >>
> > >> This series introduces a MEMBLOCK_NODUMP flag in memblock to filter
> > >> reserved memory on DT-based architectures (arm64, riscv, loongarch).
> > >> Reserved regions are marked MEMBLOCK_NODUMP by default so kdump omits
> > >> them; reusable CMA regions are different because their pages are handed
> > >> back to the buddy allocator and may carry crash-relevant data.
> > >>
> > >> ACPI systems already filter reserved memory out of the vmcore through
> > >> their existing path; only DT-based systems currently fail to filter these
> > >> regions, which is what this series addresses. The flag lives in memblock
> > >> itself rather than in a DT-only structure, so both ACPI and DT systems
> > >> can benefit from it (suggested by Rob, thanks).
> > > 
> > Hi Mike,
> > 
> > Thanks for the review.
> > 
> > > Can you elaborate how ACPI systems filter their reserved memory?
> > 
> > In the EFI memory map, firmware carveouts are reported with the type
> > EFI_RESERVED_TYPE. This type of memory gets the nomap flag set in
> > memblock.memory (is_usable_memory() returns false in reserve_regions()
> > and mark these regions with nomap flag), during prepare_elf_headers(),
> > for_each_mem_range() filters out these nomap regions. Therefore, the
> > memory reserved on ACPI based systems will not be dumped into the vmcore.
> > 
> > I will add these description in next version.
> > 
> > > With your patches, the memblock flag becomes a part of DT-only
> > > infrastructure, so that claim that both ACPI and DT benefit from it does
> > > not hold, doesn't it?
> > 
> > You are right, the wording was misleading. Let me clarify what I meant.
> > 
> > In this series only DT marks regions as MEMBLOCK_NODUMP:
> > /reserved-memory and /memreserve/ entries are tagged in the OF
> > paths (of_reserved_mem.c, fdt.c). ACPI does not set the flag and
> > keeps filtering its reserved memory through the existing path, as
> > described above.
> > 
> > 
> > What I intended to convey is that the flag itself lives in memblock
> > rather than on the DT-only struct reserved_mem, so it is available
> > for reuse. If an ACPI system ever needed to exclude a firmware-owned
> > region from the vmcore, it could mark that region with MEMBLOCK_NODUMP
> > the same way DT does, instead of having to invent a parallel mechanism.
> > That is a future option, not something this series enables for ACPI
> > today.
> 
> So, EFI uses NOMAP for the same purpose, right?
> Why when we need a new memblock flag then?

IIUC, NOMAP implies NODUMP (for EFI and DT), but NODUMP is needed for 
some mapped (!NOMAP) regions.

Rob

