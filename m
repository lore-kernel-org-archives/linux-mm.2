Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB29CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 14:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2F376B0088; Fri, 19 Jun 2026 10:43:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E04F6B008A; Fri, 19 Jun 2026 10:43:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CEC86B008C; Fri, 19 Jun 2026 10:43:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D86D6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:43:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C06188B5CA
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:43:17 +0000 (UTC)
X-FDA: 84896930034.24.E1B3AF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2D17840002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:43:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=buwtobMk;
	spf=pass (imf12.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781880196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EIlNsIQj0kEdipfyw8JGQsqqTUPEkGp3JCVuP8lQoQ0=;
	b=3jZv+OWFP+88KfGG0ppT7u5wNX7GXZMDjmxWdo53tkUU6J/UnY0TeIV2s4fdgJbsBXRsT4
	tGnZmZnRk44RzuH1MfP1eRjComvAfJG2lc4FWgGilKRq+XrV/Ps5ePVug8DI1WkGnyQ4HU
	eObtDmNWctgVCmQMjtYE/6+fMNezUeU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781880196;
	b=HOW5seKnRm63M7NvmXP6WbtL1TA7gTJV/K+DfwDfI5UD5cBcIh57iYqBQ2Fct/q7pt1n1s
	jlq5GnCCGXn/QNJiJhffKTD6QHadfPV1YMdt7baMZhONDHox9zuAeb+5At+gAApOJvjOkz
	g2qjg79VXEkKAPPs0UGmv+WjxC80SuE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=buwtobMk;
	spf=pass (imf12.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E793601E2;
	Fri, 19 Jun 2026 14:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDD31F000E9;
	Fri, 19 Jun 2026 14:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781880195;
	bh=EIlNsIQj0kEdipfyw8JGQsqqTUPEkGp3JCVuP8lQoQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=buwtobMkHr0DOLNc9UZX4q/YAVNcCwXujLYAR3XthpBhEGfYbwZnA/ZnRvByeDUES
	 2FCVOCqelalG++ypX+KppY6r5T4wrNrqDpKDEDyHT8O4d9kbDWwEV6BWYtFdqGB5+L
	 Y9p/IAYmPnDONSJdyy3hwExxSJyNe0jGjPsge2iCeI7w2lGGX7GR+EG5sOOUU+5DZ5
	 rmKHM7/ge3QmAvWr6PdYejC90q4QKcohKhFbzMCCo5IxI1TWEpa2Rl53TYKWXN04xs
	 S2vh6jPiCEnJfLmS3KoAu9b+i63HX0wbKeaAp7k0ZIHSYSkc2JcrrK+nPsFOpclvJd
	 UBXYkbGvDG2qA==
Date: Fri, 19 Jun 2026 15:43:10 +0100
From: Will Deacon <will@kernel.org>
To: Yu Peng <pengyu@kylinos.cn>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, lpieralisi@kernel.org,
	guohanjun@huawei.com, sudeep.holla@kernel.org
Subject: Re: [RFC] arm64: early_ioremap fails to map ACPI MADT on 64K pages
Message-ID: <ajVVfnGIq_6zt2jC@willie-the-truck>
References: <20260617060110.2846851-1-pengyu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617060110.2846851-1-pengyu@kylinos.cn>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2D17840002
X-Rspam-User: 
X-Stat-Signature: our6nzk6mhcprag1hb3bc5x4i9cfcasj
X-HE-Tag: 1781880196-134436
X-HE-Meta: U2FsdGVkX19GTJtjSm3IsnRGmadWSncyvERiiFmyaTJzGp2Mh+emIakAcFVDk69+V5MJCTNO5+8x+dEk8xIrsngvzm8/Q4jzpU5OIKCUAdvf9jzMVsmQlEyK1jkeX1lk8fGSEBPVBJMYlJSjyLllkJmg/58/vnpP1U5EXXwo/inocwyADq1EaX6a5cO8i3XTa+GsNBPj/eac5nNQNl2jOLJk6/PPIyLRIn2NefzSJBzNVhdro8KPot+HeJxyV4byDjBSYUn2nIykuIDswlg1m+ybVAwtRbuZvUJ2My3MVuwFQrFv2Rmmorl91UDhx2eq2qSxvnkwvGkEWdeo6E3hDxXtDjJUqUTi+C8NWddZaua9m96X8at2yvVD41uubOS66PI5FuKYmDYDNs+tcc0LXMl1gqXwrtnvxc0Gb68o/k1fe3JrMOKDC0RhMsfFaFeZBiaTH1JHOwWZfEq26cF65XniTKsEq9u5eRk1dhXMVLAyuifj3iLWU4KH7hVV1/CHl1ZPRhiCcLvs5xOIrQwj2/drISiSjIFfqDs12TQ7mttXAERsAeq1A+nB0NXqkXWhyn6wE72YrEjBUf6RJlHTNNumh3sWbRonugqR/2FJK9B4SEJT0iaRkqrETaQY7IP2GRepPNBk6Om04trQn+AVEIb6pASglFvmU9tU5N7PEbFd34CGfLP+nSdLcVsKUzbKOZPbCoK9S75u0H7PzDZJUeRDy4aj5ZNuZNHXDBgqTY9UkLTa4EIxcwKOgMuyd4nn9qWFzHUmcHOuXCexI42Kzi4r5TFPxAmnvns7bWGrUgqtWCcdb0mXAVmOSc5F/yS8/n0Pqoyn0W2+jHARDp3q2AmQ+lnQBqhRO7IUZ6Lhc/atTGUwUA2xh1idYmk5QqJ4Qlw8ifKOXe1f6PrX49GM2n1L83clATKi/M5Qne9ERtItODg1fqvnNmHlBO3VNPrcDNzPmee6bnZwGPrgYFX
 wNJ+/0NZ
 DQjp8VMb2U1v50VSd5aGKQ/axFfvfuzJHfc5iOw9zHsfWZ7XQGFS/m4v2AS3UyE5FeCWechXqKtRMwrAA/8XjklnJenMkm/oGXhaA4DTv8rZQVXKWNdg5T37BZhTeuWnZT29m6PXhVKQmhWVGtTmMW2b6+jvW5wuOJs3XogdDEMtFYLAD66uROBJ1NhBpPYx+z1h8IgKgtANS45k1JAFrRYhfxKqoQbHXkBB6liMTDM3nYhXaM0ZOjgFwfItYm3XY7+iikcg+Zp2ChUclY/RNwQLXc2fLem5/AC0csZAjGaHh3Fk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+arm64 ACPI maintainers

On Wed, Jun 17, 2026 at 02:01:10PM +0800, Yu Peng wrote:
> I hit an early boot failure on an arm64 system built with 64K pages while
> parsing the ACPI MADT.
> 
> The failing system reports:
> 
>   PAGE_SIZE: 64K
>   MADT physical address: 0x5a7ae018
>   MADT length: 0x32094

The MADT isn't even 4k aligned, so why does the page size matter in this
case?

> The failure happens when acpi_table_parse_madt() calls into early_memremap()
> via __acpi_map_table(). The MADT itself is smaller than 256K, but its
> placement causes the early mapping to require 5 64K pages:
> 
>   offset within 64K page = 0x5a7ae018 & 0xffff = 0xe018
>   mapped range           = PAGE_ALIGN(0xe018 + 0x32094)
>                          = PAGE_ALIGN(0x400ac)
>                          = 0x50000
>   nrpages                = 0x50000 / 0x10000 = 5
> 
> On arm64, NR_FIX_BTMAPS is currently derived from a 256K per-slot budget:
> 
>   #define NR_FIX_BTMAPS        (SZ_256K / PAGE_SIZE)
> 
> So for 64K pages, NR_FIX_BTMAPS is 4. The mapping therefore fails the
> early_ioremap() check:
> 
>   if (WARN_ON(nrpages > NR_FIX_BTMAPS))
>           return NULL;
> 
> After that, MADT parsing fails and the boot continues with symptoms such as:
> 
>   ACPI: APIC not present
>   missing boot CPU MPIDR, not enabling secondaries
>   Kernel panic - not syncing: No interrupt controller found.
> 
> A firmware change can avoid this by placing MADT so that:
> 
>   (madt_phys & 0xffff) + madt_length <= SZ_256K
> 
> However, I do not think ACPI requires such placement, so this looks like a
> kernel-side robustness issue as well, especially on large arm64 systems where
> MADT can grow with CPU topology.
> 
> One possible kernel-side change is to increase the boot-time mapping budget for
> CONFIG_ARM64_64K_PAGES, for example using a 512K per-slot budget only in that
> configuration. I do not think this should be applied unconditionally to all
> page sizes, since the arm64 early fixmap code expects the boot-ioremap range
> to stay within one PMD.
> 
> Has anyone seen similar failures on arm64 64K systems?
> 
> Would maintainers prefer treating this as a firmware layout issue, or would
> increasing the early_ioremap budget for 64K pages be acceptable?

It think it boils down to what ACPI says about the alignment of the MADT.

Lorenzo?

Will

