Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0978D6ACF3
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 220376B0089; Thu, 18 Dec 2025 07:02:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EDC46B008A; Thu, 18 Dec 2025 07:02:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E296B008C; Thu, 18 Dec 2025 07:02:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 029866B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:02:37 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B018EBE41E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:02:36 +0000 (UTC)
X-FDA: 84232454712.03.D8F9F2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id E099940017
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:02:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iEW+IUHe;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766059354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rNz6uG4a6bdn8IWV8d2tAVBbvKM+B1bG7nY3P4aag5I=;
	b=28sQYet1prTW+ps8gKwdeSct7Zax/ub6QL/w2SvXje7x3ai3jvBWEUXm382SFsZaW3vunr
	wX8Du8aKtBBSUErc6Dq7LaA0n41VfRC8UL1nQTHX1U4K3Or7yhGTHeHyCt4mwspEu0U1vy
	h7/9qGq+X2l+iY2hGTQ8d1kTPK0F0UA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iEW+IUHe;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766059354; a=rsa-sha256;
	cv=none;
	b=A6lQxvOet5itlQHeSfCLsuhME/dvCt0XYh3Eq3vIv8am4M4OBcxS25qI69uD+PgRgUbEoW
	PbGTXnTaHWbsnxPTjU735/chrkmVFjJKi9zUQ9j9CLUquVA8oCrURQVUtxElR8fwZ4G6Jh
	tD1OUh59KWBWrdefK/iUBbXtzpSfzLM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 40A1F60129;
	Thu, 18 Dec 2025 12:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577E6C4CEFB;
	Thu, 18 Dec 2025 12:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766059354;
	bh=RX3bRnBmhpBc13or7Zw0e7NytvYT8ZV6+njf/aHokrY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iEW+IUHegTvXC6YsIp5YDGxKhjcCFE6QWykQXEbSEO4Z1PXHYavcyeMkTg4uqJ8nZ
	 ejHYcPvuA5ASP9jFe9iZ3TwAMvle38YKKJSHnGoYwzsVRpI4urQgNRWsJNfUsyZ/5K
	 beNc8V8+rA5WLvJbhxuEcbYE5f2KPDgToQ0wuBD88hVSIPBMdic16GZbxzIFYPkDNP
	 /pDxwW1FThBGzY4cdk8jy0GOP2jGci186EFo/jq1S/Fju+VAbPS+wVNo2blJV7MlS5
	 57qKqEycr2COf62xvyJYM2MFvoPySKgD8nLAKsSwNvtMXP2Wggq2Q+Pw8keIaJvnGy
	 LxYtRqncYAJiA==
Message-ID: <83920c44-47f5-4a46-bfa7-76713197d7e4@kernel.org>
Date: Thu, 18 Dec 2025 13:02:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm/hugetlb: ignore hugepage kernel args if hugepages
 are unsupported
To: Sourabh Jain <sourabhjain@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov
 <bp@alien8.de>, Christophe Leroy <christophe.leroy@csgroup.eu>,
 Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>,
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, x86@kernel.org, linux-arm64@lists.infradead.org,
 linux-riscv@lists.infradead.org
References: <20251218114154.228484-1-sourabhjain@linux.ibm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251218114154.228484-1-sourabhjain@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E099940017
X-Stat-Signature: 3pc4up8cq1h7zpjht74khjoecdq8m7mo
X-Rspam-User: 
X-HE-Tag: 1766059354-270193
X-HE-Meta: U2FsdGVkX182s9PJeslBBBZczyVYsIKRbm3nCyMItPigP6eKxfB8nxvYnm/eEeQxkm0b6PQx55HKrw8oGYbVyyR4mPmOfebIfgj5VRbwpU1ULn520LVYN/IYwsmYM9J+0PufwDTmPWXxF1DzCy0UcztfQmOs/puu3h+QEJAmRlWJ0APmcJnC0qIAlHT+Hz0ecjOYODWxxGn6p3YMpVtY/A4GTHBAqYE0mFGUpMKyrw9LBa2YnrT/xg/5VPxMMVJfGG0+1EgmM7lDi9VjkNfquOSf60bsKuEZHpajPt8y6wVdn4FFvgTblejdcDB8Np/EoPqGz7RjDuXSSUJjlBUp916A1aL4RC10WShJ8du87hchsEAv8SxkFbqybEFcO4AFnkyY+d4axnFCxRC85qQ2WC9g3G8LORuZ3JyYe5s6fq2/RKWiRlCTiBlbmNC2KGsBbna0+sBOpbvRhUmWrWl2gLDh5t22TlHBarQKkaubNvBTPVsNVYmCfogpQns5kAaDueWJewthDcYHslUEvcX/gmNe2V/z1EiJ7pZ4hX/yzACY4n7kBhEugwsxujITYxwnFRnMgVCYykQAuAp8WFpsIOqeEw79uz0kz6CgQmW8tIB/v3xEMGW0veFogwCTwEG4qD8JLEtdmZN7/DKuCvGqbgDYZ5VHHPoAkOLsAacqg2eB4hKeAbPHn5kOnhokyxLJ21ldrcdJrLBNHEzz/i7umOMOy5f19KExejztHNuhO6GDbMGxk3RTQfa7Tj6N+KiuXVxtKf7iRUADgVq+ZRDQisUp0fsxouwWA9/tzMOXtoqSI/DV8r8Tjqp++QxdAaNCJP8R3TtRJOB/nYCKrF6KJOjget8m4P9Ar2qWXbUDS3ycRAo6xDHqowJJBslaVGx6T1Hfh7tiRTByzcTDTRFI6WId9VkLWd4UX173T9pdTgFH3QltMHXbacK76J8a0mkVJyHIBQEcjZCQD/QJR5z
 T+oDgebw
 qMS8CIBuDaBbBpa2+ybEYKYptClN7N/MT+iYH0AXP9omev2D4LgRi4f6x3CD/aNb6gvUIAQGG0aKvVWzAOabdlwkdlEfXbe+IQdQ4OFuKECcn55Fqk52XSoOUCIyGrSvCJBIXj/Dqu8ZttVkchCrIdhNN0ZA0OFX7vax6B9iziHNe+f0mSbmoMlQAVaITDTH/7F67jsESBPJmg23JXuXGrSrC8KCMqoJqgIZxFWq86hfYUPmFsm05NPHD7kuz/0qt7i+5aChmWgieIKBS4E0MWi5Y0PqEAJZs/WDQndQYLP9NTBzV226NmIx/+ibvEKlWMqfaitsf9rGIOtpYNbSVWA98xaI9c40ruovV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 12:41, Sourabh Jain wrote:
> Skip processing hugepage kernel arguments (hugepagesz, hugepages, and
> default_hugepagesz) when hugepages are not supported by the
> architecture.
> 
> Some architectures may need to disable hugepages based on conditions
> discovered during kernel boot. The hugepages_supported() helper allows
> architecture code to advertise whether hugepages are supported.
> 
> Currently, normal hugepage allocation is guarded by
> hugepages_supported(), but gigantic hugepages are allocated regardless
> of this check. This causes problems on powerpc for fadump (firmware-
> assisted dump).
> 
> In the fadump (firmware-assisted dump) scenario, a production kernel
> crash causes the system to boot into a special kernel whose sole
> purpose is to collect the memory dump and reboot. Features such as
> hugepages are not required in this environment and should be
> disabled.
> 
> For example, fadump kernel booting with the kernel arguments
> default_hugepagesz=1GB hugepagesz=1GB hugepages=200 prints the
> following logs:
> 
> HugeTLB: allocating 200 of page size 1.00 GiB failed.  Only allocated 58 hugepages.
> HugeTLB support is disabled!
> HugeTLB: huge pages not supported, ignoring associated command-line parameters
> hugetlbfs: disabling because there are no supported hugepage sizes
> 
> Even though the logs say that hugetlb support is disabled, gigantic
> hugepages are still getting allocated, which causes the fadump kernel
> to run out of memory during boot.

Yeah, that's suboptimal.

> 
> To fix this, the gigantic hugepage allocation should come under
> hugepages_supported().
> 
> To bring gigantic hugepage allocation under hugepages_supported(), two
> approaches were previously proposed:
> [1] Check hugepages_supported() in the generic code before allocating
> gigantic hugepages.
> [2] Make arch_hugetlb_valid_size() return false for all hugetlb sizes.
> 
> Approach [2] has two minor issues:
> 1. It prints misleading logs about invalid hugepage sizes
> 2. The kernel still processes hugepage kernel arguments unnecessarily
> 
> To control gigantic hugepage allocation, it is proposed to skip
> processing the hugepage kernel arguments (hugepagesz, hugepages, and
> default_hugepagesz) when hugepages_support() returns false.

You could briefly mention the new output here, so one has a before-after 
comparison.

Curious, should we at least add a Fixes: tag? Allocating memory when 
it's completely unusable sounds wrong.

[...]

> +	if (!hugepages_supported()) {
> +		pr_warn("HugeTLB: hugepages unsupported, ignoring default_hugepagesz=%s cmdline\n",
> +			s);
> +		return 0;
> +	}
> +
>   	parsed_valid_hugepagesz = false;
>   	if (parsed_default_hugepagesz) {
>   		pr_err("HugeTLB: default_hugepagesz previously specified, ignoring %s\n", s);


LGTM!

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

