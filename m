Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E9BACA601D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 16:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0655B6B008A; Fri,  9 Oct 2026 12:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D796B008C; Fri,  9 Oct 2026 12:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95116B0092; Fri,  9 Oct 2026 12:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8C326B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:26:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4E761A0232
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:26:50 +0000 (UTC)
X-FDA: 85303616580.14.71DC7DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2FC41180007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:26:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=exb8hAae;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791563209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1NQHWvgiocrQrohPdZ3lILWGC/DaP8S52W3+7hraoY=;
	b=M53UHO1nIxGUSCnsp2M5xw0hqEtPM8VFNS0qz2sZ6ZT7psYi3si0uH0RjMf7wyT6Hizw02
	S+yrUhjuE/vd3r+wPPpGf623fR5I1tD9gUX7WHvHvy93iydFUuAhwKM9sJBpNfcxuVG1Tw
	v4L9rYVgMAsTfpFaYH75VlrXtK0iUL8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=exb8hAae;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791563209;
	b=vdc3RdHOtZYwDHMyxCWH/A8rZvtM/hmt3cqlOLPoqLiiyT4IYRp4Lzg1y6qi54HPsenh80
	gkfyHU3GwQv7UhmnpY1hR6kyFFxy9r04ByuZx3FxiX4qNntUfrgW4AcR2e15wy1gY1T90s
	io3gQ6eKKVq0WgVIxtdAhoPRzcTpUy8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BDCD942E0B;
	Fri,  9 Oct 2026 16:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A93D1F000FF;
	Fri,  9 Oct 2026 16:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791563207;
	bh=P1NQHWvgiocrQrohPdZ3lILWGC/DaP8S52W3+7hraoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=exb8hAaeBUkFUrpnnUkhqLQ5zgFgMWnN/rYINMuBzDs1GNM4i9JO2MPVFhuXRhFo0
	 bqz3igmYBv7ZBuRWS/kvuYQ5ffUaHTPuDsrkHE/UxTZ8gJOgIGsoInf5FsQ/UB7y3A
	 g6CVRHuOO5bxRC/opNlTJ4l+8W+7F8avwelRbJO07mkTvjpRefiI3V10A1GVbXs3Go
	 XiKBGRBT0rS5eYl1YAt1D6JtcC8KFP/8pAvYu+y+q/bNxjXRUhITPA1EQMMGGJt/eI
	 lisapvQarlC5G9y4IP9ryxp+vI8vfLGLmBHwRi5eyGkWEwhSa/zfu2VmAVl2fAr/CB
	 DWas7S1aHp1/A==
Date: Fri, 9 Oct 2026 18:26:36 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Wandun <chenwandun1@gmail.com>
Cc: robh@kernel.org, baoquan.he@linux.dev, m.szyprowski@samsung.com,
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
Subject: Re: [PATCH v7 0/9] kdump: reduce vmcore size and capture time
Message-ID: <askVvEPHyrhpF8aw@kernel.org>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
 <ar9ogXc12cLjziHS@kernel.org>
 <80af60db-8c39-461c-a488-3dfee990bce8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80af60db-8c39-461c-a488-3dfee990bce8@gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2FC41180007
X-Rspam-User: 
X-Stat-Signature: yfgy465fzmh3nahxd7f5o4x7d9obhaoh
X-HE-Tag: 1791563209-141480
X-HE-Meta: U2FsdGVkX1+BC89CLagXFRVHs/uEyP+cto03PpYc/lEAEmj9V8zDBZ4ekuSAN1GRW9mLPsxNkfULyAl0OkbK4oP1Jf7KOI7tGZUNOp3rqGmM1uFhWBaU5i+l5fEz8W3afVclTau0+wXvXfhfILXAhYHaizJQbYnGSu8rSn1Z7Hlu+aKgLXHqGi00L+IGcQUnszmCeNfW52V41i2sVnlgk00BQ44De9Kvl5KQLp3p11Ffrvhkzpe4FaDnUOVohJeS5ypwXOQETDasI+UwcibfZcNSsNB3E1whlkofCogODWdijzvmHHnRiEDYXQvL+plX2eD5rJeAmQ0mBAXcj+mfS9YEZObbvuX0uWj6JMVUdVgNF630oPMWQqw325vOrlW0S6SghZsTmd48K0OqcLvu/x9WfaKXG4MCLdmtcUgXTMhafLDMVmSZw25EfO+HTFsxF0WL9357SQSegWK8EBRwmxrdAdn/Ln5fJtyyLhEL9RHMGYdTZIs9rNXMX+Rh7iw8FT48QNBZkzImZ02oYU17AzxdjiG9w4JUDHgF+FMUCaFrmDDur4MmGQGIpxBXr48R0DhHGOTPQsec1RUFpdQGVNFVn7XJFvo1xBd0N/dz7rj0TDtBqWs8SGCLMPfZ6Znh/2OOzyKLlfNCNf+KrW8W2RonRndybSKRqc7DSlQrWvdYtnz0Qq8GuZQUZHXyx/E0Ir4BOI3HHPfDYKAaUgTIJbW8qwTvv0R8+S9wGriTZgbsoLBJXhjjeD2tFwU/xHv+JhLuQ1UcZI9J9M/ud9gWicV7yqCXKeYbucA1ePjpGfYft8kwTylEM7Pl8Woe/o2DRyMEfw5jGvWpM0n+q7FmeJu0L24V29sPF/+c5abIk/MTNEGu1rz/nFvkUXKVjgOlVxIvt8nOOnfKZNEaXzUhDI8YlEJmjYr6PC9Cfbr8x71dwmfd6mLhTkpMRZnyYw7J+ryyp4Gf5G04NDecZ22
 WoOmezYk
 6cn6AFVrXBOA7Alhk/kVSuKQyTjkgg5am+66X3lmrWka2YYzciO84yviRgBRhDfcJ7n6HG+rgO5xLlnsBbKu6DkxUSa5nPSSBnjfmsB3SqZKwxTZRlWiF8uBXiAVuZ9mzoBDekAn4qsRl35FBQdE9Kt3SDwBRNbxnUffxqwr8strI0eS7r8Av5Gzchj2s7Fbf2m67X+AlWTE7t7JUEGkJi18DS6FRLgODxQnUeJGWTYG2pOHg+h+LFFWsVUORW4p6/5abzvqu0GBZTf86YcWjulopR7Bm84OUsya6NJLf5Jt+l/7/B5HXz2ssSjHxNEdAzGmkJ4xTTXtfT0QhiEjgzibuz9iC2abzFUb2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 11:04:47AM +0800, Wandun wrote:
> On 10/2/26 16:17, Mike Rapoport wrote:
> > Hi Wandun,
> > 
> > On Tue, Sep 22, 2026 at 04:42:47PM +0800, Wandun Chen wrote:
> >> From: Wandun Chen <chenwandun@lixiang.com>
> >>
> >> On SoCs that carve out large firmware-owned reserved memory (GPU,
> >> camera ISP, ...), kdump currently dumps those carveouts as part of
> >> system RAM even though their contents are firmware state that is not
> >> useful for kernel crash analysis.
> >>
> >> This series introduces a MEMBLOCK_NODUMP flag in memblock to filter
> >> reserved memory on DT-based architectures (arm64, riscv, loongarch).
> >> Reserved regions are marked MEMBLOCK_NODUMP by default so kdump omits
> >> them; reusable CMA regions are different because their pages are handed
> >> back to the buddy allocator and may carry crash-relevant data.
> >>
> >> ACPI systems already filter reserved memory out of the vmcore through
> >> their existing path; only DT-based systems currently fail to filter these
> >> regions, which is what this series addresses. The flag lives in memblock
> >> itself rather than in a DT-only structure, so both ACPI and DT systems
> >> can benefit from it (suggested by Rob, thanks).
> > 
> Hi Mike,
> 
> Thanks for the review.
> 
> > Can you elaborate how ACPI systems filter their reserved memory?
> 
> In the EFI memory map, firmware carveouts are reported with the type
> EFI_RESERVED_TYPE. This type of memory gets the nomap flag set in
> memblock.memory (is_usable_memory() returns false in reserve_regions()
> and mark these regions with nomap flag), during prepare_elf_headers(),
> for_each_mem_range() filters out these nomap regions. Therefore, the
> memory reserved on ACPI based systems will not be dumped into the vmcore.
> 
> I will add these description in next version.
> 
> > With your patches, the memblock flag becomes a part of DT-only
> > infrastructure, so that claim that both ACPI and DT benefit from it does
> > not hold, doesn't it?
> 
> You are right, the wording was misleading. Let me clarify what I meant.
> 
> In this series only DT marks regions as MEMBLOCK_NODUMP:
> /reserved-memory and /memreserve/ entries are tagged in the OF
> paths (of_reserved_mem.c, fdt.c). ACPI does not set the flag and
> keeps filtering its reserved memory through the existing path, as
> described above.
> 
> 
> What I intended to convey is that the flag itself lives in memblock
> rather than on the DT-only struct reserved_mem, so it is available
> for reuse. If an ACPI system ever needed to exclude a firmware-owned
> region from the vmcore, it could mark that region with MEMBLOCK_NODUMP
> the same way DT does, instead of having to invent a parallel mechanism.
> That is a future option, not something this series enables for ACPI
> today.

So, EFI uses NOMAP for the same purpose, right?
Why when we need a new memblock flag then?
 
> Also will update these description in next verison.
> 
> Best regards,
> Wandun

-- 
Sincerely yours,
Mike.

