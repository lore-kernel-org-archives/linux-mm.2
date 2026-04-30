Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB83AFF8864
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 502D36B009D; Wed, 29 Apr 2026 23:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B3BE6B009E; Wed, 29 Apr 2026 23:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0A26B009F; Wed, 29 Apr 2026 23:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E80E6B009D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 023241A034B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:20 +0000 (UTC)
X-FDA: 84713784162.11.C74604F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5FDE140008
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cl9E+pNF;
	spf=pass (imf04.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WvD3pkBfro7vqBCJqoA01E1pLGAsEnAndZdLdIwXs4=;
	b=cJDHGETOrviPuJ446sPZ1caROoZskeeQfXKec+W5RRPsh2LOp8LgzpzSgZBjzITHSJ7PE1
	9BZFlBqlrhaj5vQJ4i1GLC7SLvNwJF31GA/swiopW4OrsksmKaU51OxQzVPYkqEYQrN2mg
	i4ro7BADjfkL3iyk9FTXNWEMu8xlcOA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519579; a=rsa-sha256;
	cv=none;
	b=E/1gI32joZtreRM7JIJeihOqj+PlG/alAqAL/ONmcfuXG8y5m9EhN597Ffrbd19StkZeFi
	22I5ZPVr2uPfNKBIXgSolfOOa4bAl36J59tWwOqghtCCPcoTGq/u8CD+jCXDHAgqBIt0ZO
	39gmVObiqPfPQGRIx9fjNRvEsDeIU+E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cl9E+pNF;
	spf=pass (imf04.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 848C844587;
	Thu, 30 Apr 2026 03:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68319C2BCB9;
	Thu, 30 Apr 2026 03:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519578;
	bh=47f6wiWNhzOqt1LxqL7cNkDmVIEiOhL3j+AXGV6BKtg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=cl9E+pNFzygSkS9LU/raL18uAT2/mdwVF0PbOkbJFVE2UnECPe1iib5UKDbz/VFiB
	 kCueQLkBhWbRQ6xkD5hfnrYJJitPDJ20v3dqbagbqe3Thwq9vPSamcXk64ppjOAWIM
	 0Odo3lSTHVNjv+zUtbfeUXCXcL5YKfO8ee7DlMznTcjH2rfmNDqS9UPzFzFor/KH8a
	 OLm6+qme5UNwIMLcImLlbQUQX7W7NQi3nQ/wDgUh9nvkufIp3vgnGETLL1SyXgrN2j
	 hnqogKGfQLce6UWx/XmYM1y2W8pzY9O+AwA1F4QkZ2h7SpSwvzzeWdQj+1RDLx16Tr
	 J5G98eNyx8p9w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9EBB3809A07;
	Thu, 30 Apr 2026 03:25:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 10/18] mm/hugetlb: Refactor code around vmemmap_walk
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751953329.2274119.9976334880562386444.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:33 +0000
References: <20260227193030.272078-10-kas@kernel.org>
In-Reply-To: <20260227193030.272078-10-kas@kernel.org>
To: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 muchun.song@linux.dev, david@redhat.com, willy@infradead.org,
 usamaarif642@gmail.com, fvdl@google.com, osalvador@suse.de, rppt@kernel.org,
 vbabka@suse.cz, lorenzo.stoakes@oracle.com, ziy@nvidia.com, bhe@redhat.com,
 mhocko@suse.com, hannes@cmpxchg.org, corbet@lwn.net, chenhuacai@kernel.org,
 kernel@xen0n.name, palmer@dabbelt.com, paul.walmsley@sifive.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5FDE140008
X-Rspam-User: 
X-Stat-Signature: 75aoiae3yrsatkxpuxjhkirkudcguj3w
X-HE-Tag: 1777519579-725952
X-HE-Meta: U2FsdGVkX189fWAqjZ8U7nEPQvvzRFoAEE+OgkcqTl62B2sEeJRc7N2mbrXI+Yd7bfy1hinNClyXAswSojGfP9JVVPpURnnBm8SAI856opf8Z+OMlfkfu4BwpOxQvnNPU8vtbC8C+saysNlOukuSXYdtcwDfkJb1ymaYBU84v8YZIv8xuafRyVu1lF3W5vEJ90PMFSDqMyBGTand3uG/zF/S0jBOtGnc3sjz4iI8rJ+ZwpK3uxP/5oThW0Z82gMIexpaZpKuw0lxhtz/S1Ap0AEbBa151xN20Jt4G7ZPFmI9CuAcEvcpHYI9u/Zh3hkI3cWJOPsHTXE/qaXmPvWYq+45NQDuWklu8ZD0KJ1HegCDrSvash4UiZjOn8ahfJsqSTR8eagiwiHvhZRC2WoAoa/bJAnIY6zp7gjvO5igQ2fD4jjxH2PO3OOJCACZCupGFdgIBnefDvZJfkfYlEYI8+Rv4zDPv+U3HtfblLE8IwLYkgHh/QdRw+jHbiW5kKyUWyar0hLKYDarUfgYFNaE0l6IZq5Sv61j+u7MulpVw1yK7N44GI/hIKNzXYFTJMZk3Fu+PtXJ5PPgNQRHm8diFZN5dbiAp+k9WPe2m+kphLNTzSv5js9BSFGo0XMD1/zHjjbWc6idp1RrS/0Oez2eQ4Z4me49PiQrZKKvcuP95Z9QpL8/GT0xztZxxFUFEVVPCrsWr2jGABzLSBiUS7N7gCf6dcE+fN3T6DQpx/2TBqIn0CIeUvDlLtUcvVi1mTR1gfUMcYwqep3TKPFjpAMC/GuDivr1eYODEK9DukVYGhosmhaD/F3AUN/perrJFtvZiqSc6QNgSL35dMHcyJaAo0zd3S3tiwSb3lNvzH6KnGgzP1KxwKfGFcf1VDxlqVrj0gUveF29ywuLvkOvkrzW6DbAKvJeHDOjYumdPqV0bOh8n7tPV0SiC0WVXpufh8rlmRRxHfYp+vTCe2NH6rf
 MWCnNRa2
 Te+t6IOSEbXPJ1SQYdy86AZBouCC60udrxE7/dvPrwcgfS/E+1vHnHFiWWjsZK2+2e81m10EyOny1MR34RKkj1j/ar9jCWeF3LsxBUvjYv2UoW4PHL8cbjbzPxPkJybsyDXpbqOW+lqfEtBHCig5S0ly5DLRayVifkVzZ0W62d++KG8bGAW2P1svdgXy6Bcxm9c9vOYJRuD5T3MpKWvG3oY+g5nPaib+VeqRYvO/Moac7/U+HY5YLYvK+8/oxT01HgTbEq65lEIAfDv2nBiCGfS2RIin1OUuAOOkhACVby1jcS6dlVe3cuwWCX1dLGaPD1TWqA4pKc9xQSVqxNbOtl8ZMNilkOF1ssE8gp6vJAhJRZKYOmdEOVQi44jKlVsnoLfTVdUOXBW1+n4e9gRdXwNL5WF86up1EMvu1C0pKh4gmwNTs2e+BlDINdcZQVhmEMPCH0snJkIG6cxZy8SXFnHaDPSUyASYSh3q3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Feb 2026 19:30:11 +0000 you wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> To prepare for removing fake head pages, the vmemmap_walk code is being
> reworked.
> 
> The reuse_page and reuse_addr variables are being eliminated. There will
> no longer be an expectation regarding the reuse address in relation to
> the operated range. Instead, the caller will provide head and tail
> vmemmap pages.
> 
> [...]

Here is the summary with links:
  - [PATCHv7,10/18] mm/hugetlb: Refactor code around vmemmap_walk
    https://git.kernel.org/riscv/c/c0b495b91a47

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



