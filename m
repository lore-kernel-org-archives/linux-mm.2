Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D1EFCAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6687C8E0011; Wed,  8 Oct 2025 21:07:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642568E0002; Wed,  8 Oct 2025 21:07:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57D488E0011; Wed,  8 Oct 2025 21:07:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 438028E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:07:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08ACD13BDED
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:07:24 +0000 (UTC)
X-FDA: 83976787608.18.85C7048
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4540E14000A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:07:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rIX5UnrQ;
	spf=pass (imf23.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759972042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B2IWKdpLJh/9ubGaBFyA2jjGexkUAB88JLRjzbBWHEo=;
	b=m0Nw7YfMTpv579yT5yUVvbbIeH6TygLSZlFAgqOoYFuZj41lAcEmJ6j0yw2V4rg17nFDoj
	OTpsQxauYSFlvzKHKJJsHuStc+nliYRSfNt9VtBtCrDyItHWpbCJsMP5VvB04tkRdl/eia
	S/gIJMkziqFxohEePrGZkVR4bmokujY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rIX5UnrQ;
	spf=pass (imf23.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759972042; a=rsa-sha256;
	cv=none;
	b=R9tow3Mg71SKdlUNIPM2gxfNWCNcSSSa+PtJ9cF8IN70Fm7/Ar60zSqd096FmImrdt7ADz
	mcdGwxjqGLlUexzue8TvHwUYaFRz1eS5dlKDXoKueQP+xBPs7L8M9r6u2K01SWp2t8C1t7
	q9g5cfd90W6T8Ou0XXWtLKBzzToK+E0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 34AA9451CB;
	Thu,  9 Oct 2025 01:07:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFE9C4CEE7;
	Thu,  9 Oct 2025 01:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759972041;
	bh=gOZMzGofq4mPMi4a6FfMrSXrrYqWnEJSEe2U4H+HIxI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=rIX5UnrQuVtPUja4Kq/zNxiwyTbf5s+hCzHT8aH9/VUdnNlKWh8D4mSKFL/eXwlaD
	 7z8+SEmVkcAfo9fmiSSyJ11EAUKKRJcwMVTb9iuWDWBwheam1F4EfrpnDWIzUjmitV
	 mpUbtUtSbqOH/UnhpYe9i14SkLmyq3I1gfKlnnkK+sqgEdkc4pLZ6mWhV/a0ryPI+M
	 cnqFIsiLX5CDpbNJvCwTuxPNZCjZR+B1mOV2TKr1ssRJwK/PuLD12JWWzuO1dLp+oX
	 6de792lhNHw6SaLSFK1kZpeE0QJJFPFLV/HILKfJuySwcXVffLr7XVkoyczsYsHHIo
	 /dSAJt7cVsj/Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADDA93A41017;
	Thu,  9 Oct 2025 01:07:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: update kernel-doc for MEMBLOCK_RSRV_NOINIT (was: Re: [PATCH RFC
 10/35] mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap())
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <175997202925.3661959.5694356441030280085.git-patchwork-notify@kernel.org>
Date: Thu, 09 Oct 2025 01:07:09 +0000
References: <aKyWIriZ1bmnIrBW@kernel.org>
In-Reply-To: <aKyWIriZ1bmnIrBW@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-riscv@lists.infradead.org, david@redhat.com, mpenttil@redhat.com,
 linux-kernel@vger.kernel.org, glider@google.com, akpm@linux-foundation.org,
 jackmanb@google.com, cl@gentwo.org, dennis@kernel.org, dvyukov@google.com,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org, jgg@nvidia.com,
 axboe@kernel.dk, hannes@cmpxchg.org, jhubbard@nvidia.com,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org, Liam.Howlett@oracle.com,
 torvalds@linux-foundation.org, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
 lorenzo.stoakes@oracle.com, elver@google.com, m.szyprowski@samsung.com,
 mhocko@suse.com, muchun.song@linux.dev, netdev@vger.kernel.org,
 osalvador@suse.de, peterx@redhat.com, robin.murphy@arm.com,
 surenb@google.com, tj@kernel.org, virtualization@lists.linux.dev,
 vbabka@suse.cz, wireguard@lists.zx2c4.com, x86@kernel.org, ziy@nvidia.com
X-Rspamd-Queue-Id: 4540E14000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: drn5xe8gf8nknxs49pxtpttttzb1kes4
X-HE-Tag: 1759972042-704362
X-HE-Meta: U2FsdGVkX1+Z9v51BZuEHjrwcDXmcbi5vzctsZLZPxVoD2iOCv9YlYkCQFurtXRl9nOPM7NcgaHLnt0fh/FUwVYY+czaT7MeoI0I2QHWYTMOnTA07z6S568ccTPRmeeVAj2iFHg9yVEYIuctjq7Qquk+D9SratJiQO4NlvdrXos49tZoHvm3YptQVjYwu5ILuxnHS8qEV2XXHKc16EWlGWKLLywzJvIr7akVbeb1OQL4bkcL+UmhoFazAeeHuY9uX6rC5XjN4+fynmcn8COunGRpM++U+rOd+ad5H3j2ug9A99Ett3ge8CDR61eUtY4m04NqbS0WUi15KvwsJM4hneRredfyXkspGJbNLu5hRxrmZSLDZe3s1S3JZ/+AVCBXPCpfg+Jiy1h8A4FcQizK5l9J/m3IGpTiyRgJb9k7HbxAxdogZdDBX9EVLjBg6k1JX0htRH4SvyGpYS5nUZEqxlbMOyeLSYnZlChCLFNHsb7h11psF7A38bp7SJsnkYfm6Vm/TAGySrP2rhbGEC5Xs+uiKx1wpZFZaF7lspaN0sjfSzv7ZIIXeWBImrELYWb9Nnol7KVDvlqjitSbrZrigxFpiYUAMN5/sy0uJ5Q4fAfvnJcJCAzFdMbO+rCa5zAgb5k9rWwCssvK9e3KSrJBH9vtu4oBKS1HDMMqDe0h4m+wYTfH15FdyEjTKZAA4JtlsyoiUR5+QlFuKubka2zvUUjrpoTJRRURHtuWzXObvpMalRWCIChFd8UI+fDWC8l8hRZW+mRNoxMit6F11yu7jT843xLZiiGSbRgZ98FYPJdWsbkIVX5+Cr3BBX38/hC7N7doNvON9v5jkF5+nBPJUp5TeiBxi7bXn1whadpbQfGqzscpgxejCfv/wiGnAWcd/K4CQw6PHzPWLG23X27Cd9J+9LGnR8Ik3gQcvMVhgNEi8nokrGzNzv1NjZwc8NKdC1qUERx52KWoB2A8w1d
 SMfGst/N
 9Gp4bg9IBtbSZxUsQ7nBe7qnfoSSNgaBRx5Sh8se97dIGi+inqPsNCA3LSIKaOuzXWPuEpmCdPluH2tafGnL1MirdpPuVuZTmpUeVBGxViu+zV5mk13t4Dyq93N12E0N3r9pnW7xXcaqBDxsAtvWoVT5lOufNbYdPV4eUOI2bDpkfYpg0PJgckKsY1B2CuAwbOVom4A0nxUNJ3faVfSVlP256Ee0v5Q1dEdq9zUsI3RN2KlqDfzsev/QYdGhycj4ZvJDyHChqQCwGZFM9r8gX95Rb9IZy7CSTlamQKkwW288tNz+62RY6eFK8GAftxU5Fac/JIF0f7n2/i2b7rEKtawS4Yf9q5GHQn6Z9N7msqfCOnImyJRg4OvcbJzeNpyxawFalpPdqzMylm+QmQ3m+oRWIbg/N3MJHfatwe7UH4IOINko=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (for-next)
by Mike Rapoport (Microsoft) <rppt@kernel.org>:

On Mon, 25 Aug 2025 19:58:10 +0300 you wrote:
> On Mon, Aug 25, 2025 at 06:23:48PM +0200, David Hildenbrand wrote:
> >
> > I don't quite understand the interaction with PG_Reserved and why anybody
> > using this function should care.
> >
> > So maybe you can rephrase in a way that is easier to digest, and rather
> > focuses on what callers of this function are supposed to do vs. have the
> > liberty of not doing?
> 
> [...]

Here is the summary with links:
  - update kernel-doc for MEMBLOCK_RSRV_NOINIT (was: Re: [PATCH RFC 10/35] mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap())
    https://git.kernel.org/riscv/c/b3dcc9d1d806

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



