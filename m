Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E29AE606A33E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 03:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ewmwo10n
Received: by kanga.kvack.org (Postfix)
	id 071306B05E4; Mon, 23 Nov 2026 22:59:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021F86B05E5; Mon, 23 Nov 2026 22:59:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA21E6B05E6; Mon, 23 Nov 2026 22:59:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C359A6B05E4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 22:59:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2CBC114062D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:59:34 +0000 (UTC)
X-FDA: 85468658268.21.4D567CF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 391DD80005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:59:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ewmwo10n;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795492772;
	b=fMJoWesjXjEOOM/VyZDZG4nb4MR1/xC8tEY7ygrs98qSsihdRK6l7PMM46Wae1HH4OYsje
	bntg0nIBBR1ZEvFZ1DJpqWazk5rzPZ0QlPEEPaP3FbFmxWb8rtO2IFb3s3QcLR5bBhdkBj
	vQycUkpfqRDyZFGhsxnJyazLXJU/0pY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795492772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nA83iQvRyaruX6IzmNJzRwewMB28MahrmR9i6SAS/Ug=;
	b=8RF+3zH0W9V912qHV9HCIztcyoT+bwT7H/FtMJUGCvK/ipPJtU0NS5Usq7n0oBwwrlIWq2
	ytCM6erAHgg9Tlhus/+UKLt0cyeNcFOA5sWsWGTW6YUAWmmR8m8dzS/7bpS6e7mRcRGuQh
	hnKbH7IYTSkNttD7qsXjw8i3htX1WcA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ewmwo10n;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 47E90339;
	Mon, 23 Nov 2026 19:59:28 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F05E3F86F;
	Mon, 23 Nov 2026 19:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795492771; bh=Lplv50F+7kFs92k3xJrhQB0vZA6BC/BFMbC8nKa3qaQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ewmwo10nvaWDPRnZDHJF9g3hyp3eiP7ZSNUjF5yJL2oz5MplNK0k3yrgpsLUJPBZd
	 u/CaRD4d9th4lGwA8M5d5PnIHZnbmrPM++yc1Ayr91UPjwRP9zP87WOp/sKrTulWT+
	 3X3krAWS93i/6rmQ6DyblMNt4p/Ta/Cr0B0jlPEs=
Date: Tue, 24 Nov 2026 09:29:27 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, 
	will@kernel.org, Ryan Roberts <ryan.roberts@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V3 00/14] arm64/mm: Enable 128 bit page table entries
Message-ID: <aqcypbxidjbmjhuiujg2krseuy7v4lofrlq3upl4s7yjiq6bh2@3s4jqisdrkgd>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
 <20261120190525.GC1133597@ziepe.ca>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120190525.GC1133597@ziepe.ca>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: j9ab6scgtyscu6mgtx95nmzew5uhaauf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 391DD80005
X-Rspam-User:
X-HE-Tag: 1795492772-86907
X-HE-Meta: U2FsdGVkX1+thPX0ntiCVW6PYnsWU1a12a8aKP16lLLOFDLCaaALB7ffeUwmxhlZ6lHSvvNhGTI4bf3/XWgNU8MschGSrCreH/12X7E8HPljjYv32I830dmUmwDR/qdm17ZihBrJ+MGttZA+p7aysz6tJ7dRhGVdkIKWfh5U3D2y1fjXP++OeYoQ9K+2n9wI2JGyAOveE6zXysUs3d6gXxscw34m8rS8aGM3OmbK3Hiu0iRB0uyNrfEgbXYeXSHFgMrH4Cjg11TlmJVUqFsI/RZgOAivYSMqZB3qXCGV46zIUgjFvrcENyUQviC74H50yIJ332OvvHb5DVKKv2ShxXBkmUSPMpFxBMW2Cv7BMnLU57Q41S3F+ySQHkUEVo2XT7QHbbXizeLdvefvNCoJMNBHZkIHEZLKEyUTgqQwTG/tnlr1dm/mxf4liViqb1ilBkEoCUk8aGtxqWg8KVfvIzT8gHcbTia2/CnEYJepgzIR4w9d/QxtpOsL8N9XUo2qQXr5GBGhmkYqsa8CHohdFPizyb1im0qG1tf0Kju47LXjYM4PFEOGLgte4O8Hd15jqDPvPxaH4peLYdBvoenKRRGPVswXZXO2DQqtqw6iGFwhFAf2h5yf2FVYfiW9juuVxHCiK4fmytkC9TVl+FRbnQ78O5RF6JBrA1CegxKeHNPnHwv1OhYDZLPWr+BzQdnzwdB81vdc9sas+FC4C7Dqb14ED94QqeEfR4dwTbV9oZ6eucDHaQ18a9hYR5djuFJzrfVWYtC9ysLbThN930+YnGkqIXTMlEeIGNMMLUmBMHUZsaNcMKS2VnbcLi89XkkleQk7MgMDIrrM6NQZFL5GcMCbnesgy3Gu34JjasCG2IKtuLuk+FqfJU3biNK0uQyR8Kk85E0t9hMt0UABH+PEv2hZuC8r1c7Tsj0ZHjKFaME1NRL+ks+KDKdu51kG8UZiyGILVFJMB2D1VX05Wnd
 N+EMaaIg
 sB/FqC+NqTLtLFx7v7xOu3tbRXiQkf1RtxwPnMKV1LeOdj+L0W0xAnxHeAuzhr4bjEPfwhwCkjc/83E1gbWkO1zDxpiuzJx9Y6drPBY2fFn1NIYYxwjCl5IR96j/H4dmaSCHihg/TI4lcospGvZ7SbAb/lLMhI9fzSw1LVvU4TN7UhtIL6BFjn+4/IZWfz8gHuHDUT65u/xrEipfuOTnHdUub5n5hiPpHSC4KQjDHCAoga6CQ8NoRVLwuc5ruiEvYONQ76bw5sTeNb2ADWeFOcRvH3KJ70RWiEV5a8HiwN/DnWsnnnk4IQdFJUTRHOap11vyhYLUWAwEKY7N5eq364SGDGrRZyfnlqhxYHOq0H1aruPTG1bB1U3zT64tCFNa2SdvEpGaQgYbLCOAhrrPuJZ3AMqEFRrgg9oHxGQIJmpWV0q1MWAki8Bk30dEl8NuVuemcsxpBbps+cNDkmpu+EfohC4z28DXJs4e/6kFzvcZyXtxEOW8vOUUozuX8eUE6Ne34
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 03:05:25PM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 17, 2026 at 12:35:59PM +0530, Anshuman Khandual wrote:
> > FEAT_D128 is a new arm architecture feature adding support for VMSAv9-128
> > translation system. FEAT_D128 is an optional feature from ARMV9.3 onwards.
> > arm64 platforms with FEAT_D128 enabled will now have two different memory
> > translation systems i.e VMSAv8-64 and VMSAv9-128.
> 
> Please don't forget to update arm_smmu_sva_supported()

Sure, thanks for the pointer.

Fow now will disable SVA with CONFIG_ARM_D128 enabled but later it can
be enabled back with SMMU_IDR5.D128 feature. I will probably fold back
the following change in the series.

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -205,6 +205,9 @@ bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
        unsigned long asid_bits;
        u32 feat_mask = ARM_SMMU_FEAT_COHERENCY;

+       if (IS_ENABLED(CONFIG_ARM64_D128))
+               return false;
+
        if (vabits_actual == 52) {
                /* We don't support LPA2 */
                if (PAGE_SIZE != SZ_64K)

