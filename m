Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85F7EEDB7E3
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 09:59:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0FF16B0088; Tue,  7 Apr 2026 05:59:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1586B0089; Tue,  7 Apr 2026 05:59:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6896B008A; Tue,  7 Apr 2026 05:59:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BD03E6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 05:59:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C5845A6EF
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:59:04 +0000 (UTC)
X-FDA: 84631311408.25.2F94E15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id AF1CFC0006
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:59:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k0SN1dG0;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775555942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JTCAE1SqqNYfftRfvAv+PIMi8vDjP/1BKRYpiGnnm2Y=;
	b=mcbXuERq5NACEo83oaXtJL7RAo8wcDEeQ2zeInNdg57lxzK8FsE6k/gCTjjnDldnnmg/we
	cS4FHOkvI2y4UOVIXMppFhG8/6KZXEZWFvzjZpcT+ZpGyttenSX5on24ct5SFOh+5KyYUG
	CpaJ+ZYzE8lloP182JOKhCHrqblokWE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775555942; a=rsa-sha256;
	cv=none;
	b=29E/oXNiGHNFqHgAD0Dh/rFVTP6P3kE2L5ytM7abWippnSGw1gW4aXWlYn242y1/Xq4zr1
	1y1XlSwCj/z1UdehFYNmx1VwfIwK+efKJsj6c2pwmmrj2/9KiTSoHRjlJq8nGETQkrOX4i
	hB+SSoqFCjG1EVVQWv3s8nYIr0EKWlk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k0SN1dG0;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 24557600CB;
	Tue,  7 Apr 2026 09:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7568C116C6;
	Tue,  7 Apr 2026 09:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775555941;
	bh=YcdLZ0p4kAftv5DfA+WERS7PVAwnpqzv9HtwE5R8yVU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k0SN1dG0wR7107JPk/3Zn20hNkY9DZoJ202ozER9HWvza07qy8Epwv1EYszh62Fit
	 TB8hZ0tWfRO8M6LhmFYpcRRXjCT6uKo1tVONz+1VqUgB5n8yZ0xOjez61DPfzazIx2
	 BliRHMSXwyqQvYArfxwwD6/NfGCS8utA2uAC6iJWLZG9NUlvHZ2GPjFXTyxbL67h3f
	 MKECc/PX+vwHhQzu9wXpr6Yrm8pCTLsBGAvjx2RVEr5lHnlYPod/ZGKVY4skhg6oVm
	 Duyq5Jlp7MIqYiH4Ixp6kYwf1MOta6OGj2gFHUKo3Kjyr60Gd4LMDU03i9iHnIxjxG
	 qSiRuVTNwG4hg==
Message-ID: <710854d0-9ef8-435a-81ea-bbc0ea7aef46@kernel.org>
Date: Tue, 7 Apr 2026 11:58:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/mprotect: move softleaf code out of the main
 function
Content-Language: en-US
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>,
 jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260402141628.3367596-1-pfalcato@suse.de>
 <20260402141628.3367596-2-pfalcato@suse.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260402141628.3367596-2-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AF1CFC0006
X-Stat-Signature: aitogeda9pgsejfoa97i1brzpsos371b
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775555942-469098
X-HE-Meta: U2FsdGVkX1+H1BtfCtKWwmqwuTiPIMmYd49ZbnHS4vOTdZEQ35w4g/KF0qguYJs+erCZULFsgJPWtvDsQ+CSIkMbibQmIL1qoDi+oWX8qn5wtrbXO7UbJRSCDXq2xJOAr0S55tdeVi2oyy0HEp+cU0Aul/PTQDm39EWRSxMq+bLQ7bHzB2mSV7LBmlSg20A1i/TGGi2ramx175vmtX7FR5vwiGvIjPSD9eF8QFUlvLDz2pktdHEfltGYmaQYMBETMpV9i+84XSOxJdkPN0o8OlyYTPWTvmYBm40yZjelhp0FnNyMeYTJnE6mDsktin8Xp9DwP4vQq5y/Hiv4dBZv+i/xsDGbILsbDav9W//ilLeurghsc/FLG35uwoZPo7sfsazKvKztSmAoWAddG23367AK41+dPtrLvdlTU5nY4DHzlmfpEFcovIulD8QjfOav3HAq8lP7yH9TcYiLvoV7mUeSlKOhG53aHz8mG+N7wl3fbHIukalEeea1UkokO0u55tw45uWHMkcuA/2mBortpqlR7hlPI4k5JFNiNHM37oxj5d7BmjEaywOT2VCWEuYgU7WwRITGKiC48nLJ+pMPhCuRE80K4cAnw7nMwHpQV3tUQJ3EThDxbUtGXC0V4MAyfz/aINPIbEBFCja08P9CY81zwV83z8T29xCBxEIg7f5Ezmd2ylb/Rc0rwosB3vDz3ozW3rmKrmX9qEq/lRHLokUo/x07I8Pe9wan/aJL2OjnekPDhIWFzOeyp8R7ZgBT7aKdMDAAl2S8hrfSsZ3lLnz8xRwAydD5ZjpyMvcg893v4uqSJ064WQ19W25MLHRUmrCxb5S6gZXjBnvgpOzkBidAGVAV6p4RyV/zPCICpe4i8sch4Ckv3py3kHKOi7rL5YKn5qWTzUceGVluQWUwkLDqifjsFhxQYDHDsOrBOE/0GPoZ3zjCdj7Q7xIeRjRLagt7Crm4ZD4MhVylSFI
 fhTudcYK
 ctdS2vLdHF/OQxvqe9WLofD52aM9X7zsgxhaZd6OQDq0sIXOIxEiLFHTzckmm4t7uEf8xP3f0XthzMKOgWKRPjCQzbSJbfLVTo+NgmAgaa7Ce+PEjW7tfeuAT+wcOUguNs/0Gk74JV1mB7ru2ap/YFvjrHPG3sv5IBYxRHJhKQMEt6Ppj+OxKT68jmRDNIu6dUJd6tLNM2EKe36fraLw7j1wEXVyJwLg+Tmr8eV3JDgGNWVvtshcx0ksWmkgvhMJxPz5QpoxvLOuk3fLKL8y7jH5zpZ/3ktqGQN4PktUsb9MJlgk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/2/26 16:16, Pedro Falcato wrote:
> Move softleaf change_pte_range code into a separate function. This makes
> the change_pte_range() function a good bit smaller, and lessens cognitive
> load when reading through the function.
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Tested-by: Luke Yang <luyang@redhat.com>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


