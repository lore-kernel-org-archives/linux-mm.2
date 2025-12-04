Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1315D1F9B8
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 10:55:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48CF26B0029; Thu,  4 Dec 2025 05:55:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4646F6B002A; Thu,  4 Dec 2025 05:55:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1FB6B002B; Thu,  4 Dec 2025 05:55:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BCEA6B0029
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 05:55:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 282C85BCEE
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:55:49 +0000 (UTC)
X-FDA: 84181483218.01.E6F01B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 989F24000B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:55:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VW5P673G;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764845747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OAWq0LtJH8rSgZVudDIbuwbd4Y43kGCBLP0++547tcM=;
	b=QQveQ8t2JMsvqjp1ccMt5BXFS7KatWVZVRsxNXu2JoNgu/z2TtRlqELBG7LBBSocmXzta/
	EB1NoGZiACEkyMpef2EBOMBEvCtR73SYo4ydt40OpSg5+IFd56Fny0q04ch/HAG16tMmy1
	WbW8MytyamnKhDzXE/pYOenm4c9e1Ao=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VW5P673G;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764845747; a=rsa-sha256;
	cv=none;
	b=BQOLTgv9LYJ4CVouUmh1E/U2SQTnJKO3iAbOgSzzRBpqxcekaEaDjeOzsnrH5CN6fiKkoJ
	UZOtDIL1u4X3CyUqSSCxuiUZbD8MOVatvwCzybQBsLdMbz8nxU+qgUTUsT+pdQV+Qiyrb0
	V4+JktdXdVvaas1yUjLDCuoZav9zMLc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 21A21601E9;
	Thu,  4 Dec 2025 10:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA1AC19422;
	Thu,  4 Dec 2025 10:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764845746;
	bh=y2vwFI9raDV2YvXfP8kQgQ+aoZpmsNWYPT3nrlCdWmo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VW5P673GaBh+Qi/ztsZOYHNu2q/6Id59fygY4NVFE9oTEhZ/piN0RvZ8RLRxyg2jI
	 DdgEOdicv5OPougkOi85CFWY0i/v3MZjsSXKdCHMfhZqFE4sFyL1WpMGZMy8oPEERW
	 Uwv6irjD/ceWY6yIm+6g31nkstoTJHEyPA50/XUiECxNSpKljOhZ6eGfVvcKOtoydn
	 kVIeWKCScX8EJfUXZHzpd/lIqBXPcT8l4MWMiGqFVQGZZNhCv+Sg+KDAc+Ct3mEcp/
	 MisxldTI6+mnCnX8qA7yYeSFexn8ezMFZk/CWb43mH9wYIOI9g+TBhhx1uL29c8Brj
	 T07Wtu1JiTg0g==
Date: Thu, 4 Dec 2025 12:55:38 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Guo Weikang <guoweikang.kernel@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] mm: shmem: avoid build warning for CONFIG_SHMEM=n
Message-ID: <aTFoqq034LYPPDEz@kernel.org>
References: <20251204102905.1048000-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204102905.1048000-1-arnd@kernel.org>
X-Rspamd-Queue-Id: 989F24000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: qdizxdo7i4tdj8ny6bx5csa7sauccn67
X-HE-Tag: 1764845747-37798
X-HE-Meta: U2FsdGVkX19QCNjvRvUyjpg2ir7wLvgmPqW1q7c9Hpjke9X8H6fmtSFcxf86N5o0D2+dM9ebdGsrFSGl9vTt3voTMMSz9OUe3sjCyqBvV3hACKzdQ7Fi39zF6y1CoPRRU7bxJqdxNWgal2ESGSIYLpP4pUM0FqWeT47L8aFdl9M/snKZo9WkZclZt+/QWuv3N4pliE6UMczZmXmLcnBxb8UbDqCbPYIn2gGL4fEEDsqRhWbx4WDG/o65MAud+oY8lDvwZHjFwamU4N9GuEfZ1+qURF6Agk69HT4g8cPv0cDRlnjOdZlZGxCAjpB08hmr4RDBN3Z01SIfDGMY+SR6ykzgw8PxwSomeq6cePGTuKi7YBLVhrhHM0EyzNkXHDFlahXJWogFJYB5/nCrGzUUbgnczS81pEOZeUh+g9fwUrHtndIvlMSW0Qr351OdX3F0ne6Q0mCGpaZFN3Be0wEW6XgJvaLFV3S7YxgLFGWOIQfztgyQs4d3L01nV/P5VVNi7rvieyskcktcr4CNhVUF8wdNHZc9cX3PHdxX5PLdhdyRbNAhVz7iOiJy1h7zkdVS1HlCZkzvxwxghGjB7I3vOflamFe7uEsoScJbaBlDaG3fA6vJtNPrs+2HWY7byr19cEAuSzlk7WFx6VTO3KdnrPQT4eR99I1a2q1x0QRpuYnfmJqpi3ABbkktayxd/5sZKGlZPrFejpk4k64f6CORFmK61VAd6Po4/VV0yH9xUY332GOyjWhb+VORpQ27mun5mI+2xUbC98IYDkvU48XuzAQPbXa3b2Yx/fY+D4vFFmHQ88c2BoDB8zN88OKDs/F+P5es1+y0iPdJBFAycAT9bEeiAoJ1cnTVqofMUtTpj2ZOKi+UG6yJmAPp3H6p8oOLM/nCl5JjmOXdUii3y1o8inpr9yxMoLuVkYr7Olh8mTpcBJnMwDrTY4jje5oO3mwTSjs/cVfOqtYUwTCNP6I
 Xlby188A
 8Q/9EyM8Ogzey8YxdlfVXPpLT7G8epZJviTYr39ZeC/jUEgbSWVS0GbROcqIQ0tZwxOZKFxJzLqLtOIGtADsfwDJFFzcnuAe+xIxlcoZhH8kgqQmvETGYp5eW94NO5cbaKGI932S1J3rkJKo0wNqcMmk28/fUUTtMsFI1fCvH6ytHxLedwNfAstRjMA03+SYGFLXyZWVhsrRJ5lv+JlhpsYymhnzoUtwzLAVIrztWQZh57tYslxPMc7BdtJ1hZ0MLdG8eQt5d5o8XQL7DmmpUOubDUY+D/Fm9mlG5V64fKtucvzJqwKiTxZeQJ3WW2CpDITpCIqaY3vTaNPOSH/t0LygPko9T91GxFgWagjY20LCjYY4nSSWQrBWE7YMCP5l/kL6uFMVtrlQNWFCk5xrmIGCnEhUqDv43c3t4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 11:28:59AM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The newly added 'flags' variable is unused and causes a warning if
> CONFIG_SHMEM is disabled, since the shmem_acct_size() macro it is passed
> into does nothing:
> 
> mm/shmem.c: In function '__shmem_file_setup':
> mm/shmem.c:5816:23: error: unused variable 'flags' [-Werror=unused-variable]
>  5816 |         unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
>       |                       ^~~~~
> 
> Replace the two macros with equivalent inline functions tto get the
> argument checking.
> 
> Fixes: 6ff1610ced56 ("mm: shmem: use SHMEM_F_* flags instead of VM_* flags")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> v2: make shmem_unacct_size() inline as well.

-- 
Sincerely yours,
Mike.

