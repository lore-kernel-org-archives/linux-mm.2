Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4213CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 11:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E017B6B0092; Mon,  5 Oct 2026 07:07:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB27F6B0093; Mon,  5 Oct 2026 07:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC84D6B0095; Mon,  5 Oct 2026 07:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A6C626B0092
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:07:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A96E140234
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:07:56 +0000 (UTC)
X-FDA: 85288297752.20.C6501C3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 27CFCA000C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:07:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=huznAKYd;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791198474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXNS36CeUPKXmNC/8m878DvTmvUfv9rRTJEnohEfsJ0=;
	b=aqTxTIoY5lZsUjwnx8KrwmdptrdW+DJvLzDf4FPhNqs52JcsBG3NSulxvfx3N0cnMUcaDa
	BvO74yJBi7sr2gD+xgsFslwr1W0RG0xyl+lzg2a+9lHEvcUuGYZvS7WyFCdESjrM6iFwnm
	XqOIqjQKg6ZTx/gY5zwb4aG9wD0lOMU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=huznAKYd;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791198474;
	b=boa/YcEjvYObdtI9sgEgpLc09hzkdcPGlo18YYbhefH34uunq8KT5+7h9ftzazFqTkgS3k
	mCgmWQ0mwavbUnSn+IWbQMm1VmLsLGxdb6qI/ZzuFh3aZ5vsv4GtoxkNu1JxYb/jxv2ecJ
	uMkiGqAy3SX1QI7PHyH27L2+Vd+ZjA4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 81EA2152B;
	Mon,  5 Oct 2026 04:07:49 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F9B13F86F;
	Mon,  5 Oct 2026 04:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791198472; bh=OstHisGp7P6hgz4/0D89NdgTFhwBoAjGYPB++ZUdrsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=huznAKYddU0oZFKAUlCcQ1STeT/7wXvr3I03BhqGvib3xpajTRxhfLH9R4n0xbL3S
	 kIEIw7UozOwAKAYis3taxahTMvipmp7uuojl2U657r8N7zaBJ5NTsf4aP8uJ8+p+Rb
	 BYYgwF3ME4VdyiRufVFi72RJCpQxDxT6c94/F8TA=
Date: Mon, 5 Oct 2026 12:07:46 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Kristina =?utf-8?Q?Mart=C5=A1enko?= <kristina.martsenko@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-efi@vger.kernel.org,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-mm@kvack.org
Subject: Re: [RFC 00/12] arm64: Add support for TLBI domains
Message-ID: <asOE8NSHH3Jnv7AJ@arm.com>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <DLW95E2XWSVT.8W90FW4WG6K8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DLW95E2XWSVT.8W90FW4WG6K8@nvidia.com>
X-Stat-Signature: eohm98ng6cy4668sm7ndghjkctaspah4
X-Rspam-User: 
X-Rspamd-Queue-Id: 27CFCA000C
X-Rspamd-Server: rspam08
X-HE-Tag: 1791198474-327743
X-HE-Meta: U2FsdGVkX1+VnXb2Xv4tzBCfrxfyoHYMMzpbcGW57iYkP97oWKTEc+SLZf6bo6Oe5cawbTFsfEmWV1hxcdOdQnBPoiP6lZZkAEE1n4Tiw6zPsrdZRu5yBXY5ZP4Px5dlnKJJEm0BKopWPcm8XMidhR8bTU1n28FumJFbymz3MYeR3zBoerTb2O8Y079X7/DJpk76LQhyo/78CjhUR7XXh40WT/7kDMetlOY/OibxmlSl2rbvcg5cTf+aWfh6fOIfNNBlCtuxKO3iGY0YFmL95BCd0DxnZeCFz5qXCnuRVuMg6SwX+ZGDI/7zP47Ino3r9EVY0kGu0LkqIyv8rwOY5QHjer8iHcQo/Ssnvx1wvUaobDaW1pbN+7hPNeWjrmBf6XVnHRljjRYaV6HWvvBcuPdIiNEckSKjdzBPBBxHy6cozvMPJr3m9DmK/smx5xscbVwBp5LGwiftALvJygMZxCNjf8fVuxydngALGyQAtnHVXBOuUjxXW4pQL+iGq+eYnKsebgmyk12lnUlegYl2ERrGoRypLOpG8rQgQquz9ro6ghXTaSNkGcOk7za3Mhe8Vl+VWOR9Qes8GbQo4n6UAmTt7khlJnk2Ah8eMo2uHAEFsD03zfwr5wmOMmnEO/qtXiFVXTOFOPPjgcYfZqDiaijOA6nk4bP8hqXshbMLs52DQCJDMB5zZaDXlJhWUtrKEIvU+wHGYQrORJSD+6a+hy0RHnDHEMlHApQ311z0rDvCo921uO9DtNQi/WSXnQtr6PKozXQbDN/tsdpdDAZokOH2D9vlYnMiqWB662v7aUB0ucNxz/T4M21sG4CsBb6VixDb14uD9olIM6vv67TKAxFH6juJhnuzhDvTxhpju/x2hs4d8T+HZ5Shv5JAvHwOeefGyq4L2f+wVenFz3UBNRGcMYIJIBRhilSD4ovuvwBVAhfLI7RBG+0aQuEbiBqFxuTMSjOgLYd+GXKWmWU
 L1Tgj2zt
 qrSsHrfL7lSjgx9rd1gaMQnOX6ARq+oFVcvYzg6tjEdaY0v10nRfLZ6glshj22x2VfIdSgp3NxaaSW+zFdMe8b9jQ2UPL9FLaAPCO4vfz8KGjlZWSASrsI0AGRqwkUmeXB5qtvtKde5vNTswesObvlgCYoHOSsq9sYp5KH3BYU1BqIdlDi1L69+qPiQkykY06KeauwXKopI8dF66SgGSLDsQn58evXZc/lCDZvHS8bCyzCDvZ63q/LY1QvIs1lavZtlMr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 04, 2026 at 02:06:48PM -0400, Zi Yan wrote:
> On Thu Oct 1, 2026 at 7:06 AM EDT, Kristina Martšenko wrote:
> > This series allows the kernel to use TLBI domains. TLBI domains (FEAT_TLBID) is
> > an Arm architecture feature that enables a TLB invalidation to target a subset
> > of CPUs instead of the whole system. It can improve performance on systems with
> > many CPUs. TLBID is not yet part of the Arm Architecture Reference Manual but
> > some of it is described in the latest XML [1].
> >
> > The goal of this series is to send TLBI commands only to the CPUs where a
> > process has run (i.e. where its page tables have been installed). The last
> 
> IIUC, mm_cpumask() is used to store this information on x86 and other
> archs. I see you put this information in tlbid_domains of mm_context_t
> from patch 9, although in the form of tlb id domains. I wonder why not
> make arm64 also update mm_cpumask() like x86 and other archs and derive
> the tlbid domains based on mm_cpumask() and a cpu-to-domain mapping
> (added in patch 7).

One reason is that it's cheaper to compute the tlbi domains at context
switch time (bitmap-and IIRC) than working from mm_cpumask() every time
we do a TLBI.

That said, suggestions for a quick algorithm are welcome. Subject to the
race conditions Will mentioned, we could use the mm_cpumask() for a
quick check if we ever ran on that CPU and avoid recomputing the tlbi
domains.

-- 
Catalin

