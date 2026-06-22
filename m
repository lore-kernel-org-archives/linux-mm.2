Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47A2CCDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 09:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD9AE6B0093; Mon, 22 Jun 2026 05:49:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB1566B0095; Mon, 22 Jun 2026 05:49:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7DC6B0096; Mon, 22 Jun 2026 05:49:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A06076B0093
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 05:49:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33A83C2865
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:49:16 +0000 (UTC)
X-FDA: 84907075512.21.608FE59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 729EF1A0008
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:49:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ro+wwemI;
	spf=pass (imf19.hostedemail.com: domain of lpieralisi@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=lpieralisi@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782121754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jiUK4zqlgPufMf5KeLuWGqbjOdMtUleMUc6fesqkDDY=;
	b=PtgTXTC0armvANJ4ciUkZshILFblghNj8QlxK7nt66rPDtIfl13csJSThvU5J3Xrj/rW1z
	Lmr7pn3WuzbbFfOi4d5juWRUUinNXVHQpA15NzNaw++2CbXSxoY3HWtC/IFSLgOEKYrD5p
	h5w3e4V86Y0XJfnrkTZI9sPE2OKnnvc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782121754;
	b=pucbcrLTHZEDW8nLzmieyFSc8TsrK90bFJHHC9AfnMtgYb1q0RBDctNx80FeLcX41bAfdL
	7Lt8dGr16vSl1KVZvW7un5/IHrF721pQS0r9RL1TiCu2Nf2xycgex1H8eLmfReflI+WxJa
	CTHynlcjihasE1KGVE2e2kaJwJIjb3k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ro+wwemI;
	spf=pass (imf19.hostedemail.com: domain of lpieralisi@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=lpieralisi@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7459C40720;
	Mon, 22 Jun 2026 09:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E281F00A3A;
	Mon, 22 Jun 2026 09:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782121753;
	bh=jiUK4zqlgPufMf5KeLuWGqbjOdMtUleMUc6fesqkDDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ro+wwemIX5Rnl9nAhj+phv88wYwnNld218ormKKPUv87BSnNLRpu9D4ciAcUA/9aV
	 kV4TvSmy+7jhFDP2oTR+Exc2QVRYoubH/yPD+VaTIMWT8VS/+p61VDFEaJPz++o8ne
	 kE9+3EKuoxURhelikJG9QDtIfxSkA0IT0eQUNH3RkoSTQU2Zt2RTfro5W1PVopTbiG
	 o41jD0WHJSDAZsV0Qj/arNHOdzJ2xoX9m2yvWfcQ8esxEH4ixQZ71B46G1ovm8h7h/
	 jVkEtJYrAXXnNEVq2SI1M44qgHwVIrCtuDv1A8wENZIgx2URMumPdgLlDT6YI543Sf
	 g4qAHZKxjQLsg==
Date: Mon, 22 Jun 2026 11:49:07 +0200
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Hanjun Guo <guohanjun@huawei.com>
Cc: Will Deacon <will@kernel.org>, Yu Peng <pengyu@kylinos.cn>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, sudeep.holla@kernel.org
Subject: Re: [RFC] arm64: early_ioremap fails to map ACPI MADT on 64K pages
Message-ID: <ajkFE6TmwW6B/huP@lpieralisi>
References: <20260617060110.2846851-1-pengyu@kylinos.cn>
 <ajVVfnGIq_6zt2jC@willie-the-truck>
 <3cceb66d-4496-1a46-60ab-f43b0669fb71@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cceb66d-4496-1a46-60ab-f43b0669fb71@huawei.com>
X-Stat-Signature: yhdi8htnkp7hqcx857aqqineaaseuap1
X-Rspamd-Queue-Id: 729EF1A0008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782121754-878162
X-HE-Meta: U2FsdGVkX19PVymcqklXYhIFamlLa2jTagumIOLz9aCpl/t5kGInH+PV/GEvNeisC5C3MHx19rFnmouk3NiUJQjC7fw7MSBOEiB9WnKYmGS5yK52HS9difptSApA2Akqjmcr5JS7xq6WMdBGIufuZewaJ4ut7K3HPQVnjaggDbutr/fNhIMJeugomRsnsHM5u7ZAS3Qg94HxJDCrV06O0cYic7zyKmhgmJYvRo934GXXLu+R8wBtQZAfKYoUTWdmUVhbyVVz+2F2q4X0wJRFo4XRzbDJzbUOP5FPkKZI5qBwRbx3evnzvQNSnpL5gZMt57a5Yox9Y+hasmahGnhsP+1XooqN4jnqCcd7swN97XLDYB2U0xXUpqXCBKD0drLO4xG2/dsFZNeqc2FSwijoE/3kYBmqQ+4SLd5CYjse9UPEX043jAoTMuyzt4LHRsINqnhmOr0GVyImMN4AH+L19qzdgz6jd3136uqYdwgfW/tMy2nNd+gUhrQP+leAtoRPjYoJ6cnJ/XWyh4PKkkKeE89lFasMPu5aVOUNAxH66vgNe1ToJN+CYRNhb5kzVdzjxP/uyOjstrVVYtpNSgrLM8+IrHeTXl+ONFsNo1981BmueHyM17pSCD3uUDhFTzy4I3Zj040F1PG0KU70JI3P7HqLHMtF8EeABMbWf5WX42HGr289zjReRY6Eg0hHsSrS+vJk1S4JBoSD6SD7jq/sHzyH7rrhZzbCZXNMIEOZ/Ow/apnaaeabse4YbPdRoh4YON8oJ4n5s5Gn+op9o0EqsRfYo2uJhKOcFQ7eke0ig88xPxsvjk4GVC2Cc5IGClfgbJt9nJtlCG9pVp5UJYbaQTuegNoRSSC3sqttQL+xUo0gAZFSadr3soWsBafMzvZWVDUYG5JIMe+jp6oVnRJyt9POCJ6koFmAmmBm8ZcoakaGbd85R3N2V0Zpe+Cf5K5blfS+FcmpTpnrWTcQWXU
 B2inOgV7
 D6F+1PgSDsKFvkAc3QrADSAuNS7HcIf4zNZ1yA+vPf04Cb9AiWZiPRjW5bUmU8ZtRGrqLANxlco6FMuWQtoAqjCbuaCF1N9rD5UBMD9dvGnCExVk3cOHsyhVgAQmNLBg2FX/eSyIL7vSh74FmEL1eOcxV5X9mVWf7wrKPGBx49gEFI1KcsRUHhJVTQt4A1Bz1Xhf+TWlium5HPE4VSK2ndYK+hOjMJhvdWbXvi118RWP1r1YMT/jYr8FyXV8FuOFfMWP3EPSfLXpbXGiorYWDq3UiAVvht2VHQ9joe+k1qF89nN987MrnrEr6fD9lrs76W38LXDTmooybZbeA7JBVFwg28gGVNOfIOavY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 04:55:29PM +0800, Hanjun Guo wrote:
> On 2026/6/19 22:43, Will Deacon wrote:
> > +arm64 ACPI maintainers
> > 
> > On Wed, Jun 17, 2026 at 02:01:10PM +0800, Yu Peng wrote:
> > > I hit an early boot failure on an arm64 system built with 64K pages while
> > > parsing the ACPI MADT.
> > > 
> > > The failing system reports:
> > > 
> > >    PAGE_SIZE: 64K
> > >    MADT physical address: 0x5a7ae018
> > >    MADT length: 0x32094
> > 
> > The MADT isn't even 4k aligned, so why does the page size matter in this
> > case?
> > 
> > > The failure happens when acpi_table_parse_madt() calls into early_memremap()
> > > via __acpi_map_table(). The MADT itself is smaller than 256K, but its
> > > placement causes the early mapping to require 5 64K pages:
> > > 
> > >    offset within 64K page = 0x5a7ae018 & 0xffff = 0xe018
> > >    mapped range           = PAGE_ALIGN(0xe018 + 0x32094)
> > >                           = PAGE_ALIGN(0x400ac)
> > >                           = 0x50000
> > >    nrpages                = 0x50000 / 0x10000 = 5
> > > 
> > > On arm64, NR_FIX_BTMAPS is currently derived from a 256K per-slot budget:
> > > 
> > >    #define NR_FIX_BTMAPS        (SZ_256K / PAGE_SIZE)
> > > 
> > > So for 64K pages, NR_FIX_BTMAPS is 4. The mapping therefore fails the
> > > early_ioremap() check:
> > > 
> > >    if (WARN_ON(nrpages > NR_FIX_BTMAPS))
> > >            return NULL;
> > > 
> > > After that, MADT parsing fails and the boot continues with symptoms such as:
> > > 
> > >    ACPI: APIC not present
> > >    missing boot CPU MPIDR, not enabling secondaries
> > >    Kernel panic - not syncing: No interrupt controller found.
> > > 
> > > A firmware change can avoid this by placing MADT so that:
> > > 
> > >    (madt_phys & 0xffff) + madt_length <= SZ_256K
> > > 
> > > However, I do not think ACPI requires such placement, so this looks like a
> > > kernel-side robustness issue as well, especially on large arm64 systems where
> > > MADT can grow with CPU topology.
> > > 
> > > One possible kernel-side change is to increase the boot-time mapping budget for
> > > CONFIG_ARM64_64K_PAGES, for example using a 512K per-slot budget only in that
> > > configuration. I do not think this should be applied unconditionally to all
> > > page sizes, since the arm64 early fixmap code expects the boot-ioremap range
> > > to stay within one PMD.
> > > 
> > > Has anyone seen similar failures on arm64 64K systems?

First bug report I am aware of, perhaps this was papered over in FW,
MADT parsing failure is the first thing you would notice in bootstrapping
an ACPI system (FADT is not that big).

> > > 
> > > Would maintainers prefer treating this as a firmware layout issue, or would
> > > increasing the early_ioremap budget for 64K pages be acceptable?
> > 
> > It think it boils down to what ACPI says about the alignment of the MADT.
> 
> I checked the ACPI spec and it didn't require the alignment for ACPI
> tables, but in UEFI spec, it says (for aarch64):
> 
> ACPI Tables loaded at boot time can be contained in memory of type
> EfiACPIReclaimMemory (recommended) or EfiACPIMemoryNVS.
> 
> EFI memory descriptors of type EfiACPIReclaimMemory and EfiACPIMemoryNVS
> must be aligned on a 4 KiB boundary and must be a multiple of 4 KiB in
> size.
> 
> It only requires EfiACPIReclaimMemory type to be 4K aligned, not
> for each ACPI table, because ACPI tables can be packed into the
> allocated EfiACPIReclaimMemory type, correct me if I'm wrong!

I am afraid you are not wrong - we can't blame firmware (yet), this
has to be addressed.

Lorenzo

