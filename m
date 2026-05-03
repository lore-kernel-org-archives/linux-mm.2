Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3EF0CD342C
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 10:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9747E6B0005; Sun,  3 May 2026 06:02:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FF596B008A; Sun,  3 May 2026 06:02:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EDA66B008C; Sun,  3 May 2026 06:02:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 696B86B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 06:02:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6B13C2CA6
	for <linux-mm@kvack.org>; Sun,  3 May 2026 10:01:59 +0000 (UTC)
X-FDA: 84725667558.04.18B198F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 357B22000F
	for <linux-mm@kvack.org>; Sun,  3 May 2026 10:01:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TV9LFfwM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777802518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GRNlERfy3yvo0mRY0vvGmux3ZMRHeOx1EjEt2XLRCIE=;
	b=qA5IflYE9tBC32fVa2BPGp6wtlh+VEFuuPApbun4hszGE2WCiYuHOgn4M/g5GPwYpQTjAa
	hj2ov9k3rbDXLjbmkS6Gr6A0DOJJs5BumkG8b4VP5JEPP1o9Xq9IQhLzycb1xiV5lh4yxA
	RnLWqjvW4qb4wJ9hg1bi2oUBrnHeRqE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777802518; a=rsa-sha256;
	cv=none;
	b=awxS6kDhpb83mKpzxeqYJRTEwt0+62TskCkaQXEPZQy682/ToLoEymshYO1jxlRHT/F4mO
	RojofCtrNfGx+lmA1M+6bc/JM8I/2UmpTVOiO0TzbI3vxGLmnvkDI/OEN4xsqvjIQ8kwAN
	C/aR+5q4GOaRINeugwJwDM2d9rLfX9k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TV9LFfwM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5EFAD60120;
	Sun,  3 May 2026 10:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEEFC2BCB4;
	Sun,  3 May 2026 10:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777802517;
	bh=tXOPghsTimOL2unyTOOfFn61l3RakHOcJag+q6KYp3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TV9LFfwMzE8GaeswmLI/bMn/J/TPTXZMYjybF1QacD0K+oV7PFM4QBLqrhFotPJGB
	 37VhM2H1PTjhDbGSnqTwXQkWhhRKfy4u8zDzyOiKfz42fmKm8PSK+A4H5Fj5HwiaDy
	 EGIWx+wIy3JO1vOu1B8myfjiwL7Bs5IhRFX0nXJ15DSdxl0kWB3OicNff7gf2b5tr4
	 cUptNm2AuZIj4gL+x/P0lY2ormrovtCW7Q6Y9dIX/fQK4dzDGqOnhXlr4PDoVCGH6N
	 e4kgOurDovEeWqoXrZTkCEbV9gBePB7ULNOO9slZgMm8HvyAlnLIYmOuI4N8JPwJ0A
	 KiZY2TJAIDIIQ==
Date: Sun, 3 May 2026 12:01:50 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v9 0/3] kho: add support for deferred struct page init
Message-ID: <afcdDm4aAJvNaQqH@kernel.org>
References: <20260423122538.140993-1-mclapinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423122538.140993-1-mclapinski@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 357B22000F
X-Stat-Signature: qok4pfbe6x5s8r8jdakr6h7gofhrdrz4
X-Rspam-User: 
X-HE-Tag: 1777802518-582751
X-HE-Meta: U2FsdGVkX18ZpBN8VbqlHLR+evkhQHk+dU4qKnoi9/shzNUlYaexRQybAcYX+Krs/VKjs7ZZynXjXPCqxVt4E+2NM+LS81mnIB9RSmAb0pcOR8z53ezx184J7EebYcsTfRHLsdScSvq2LkrBXlSUy5+FQvZmB8Q2hxWUDsmQnad8bL3TCy+t5QRkrTivbhNW56yXtZhACYuePD/KUFDvgVkF5Xv+34mdqVIVgldFcuyeoDiPtaGGZyLt2qSikGfGGAbxp9mhqPu1+JSplw4AptAAVc+/dcrxe5GhazC87N8nDSXUHSIyuDcG0v04FP3sD8hv4kdoZEvXNJpmTqc559YL+UFPGy4cTxFN8CUb9cRbmGceU2Fv9SGleFKv3YdTO9d+yetDfPswvbK8N5HgNfuA4bHj6I2tHeU7RE5KguNJIojpZkfd6yzLa+jNyjIvZMrbEwxS8Sf7ejRBxlm/fNfkUtcFK2T41e4mY4+GiMKJ6GcBwaQ93kTIPpPXkW+aFKeXUxrLHWCMtm8c7xH8K6uYkXbxfq6gwYH5vBngT9mWobzJi+a5eCLU66sVnOPshwaU5KUfEElZuBSvpaJ9G4LBNzxM0LyNKXITMipzhGUR2ngl77gdmSTXN8srnjdAKzA0zKMildm4RpFttPQN9RXDEMfS5pT+o5FaFSYL+YMFD/+R/i6HRH0GXSJHGk3q+8tLzsAwlBORIHit7um6Yd5kJ1r70pJN5WyxfFlzMWnjeFvNoAu9BsbKj1M+SA1ZRFPRWqRiCOXDDzL4zgu2kQTApzXSqkxaRH6Qpg6ihxnQyNsPnSaDnaFd/8jk5c1J4X6zCltiJyKwzRz2eKDWtL7iPdjwi/juj3HaGu7trRSPEOOhpm3MPZLyBhib01O7En2QldU1DQzAwSsOtEzvZev+Sfv2XC0kzE+2hHoM5cevXL+0C3TZsh0/AubTAKjCX8JKXAFL/bm+mWp/Tng
 ydeY24uR
 ZIW2BFfKYyMGjbccbPpZYbckddVuMueXz2ZkWulgukDWwnr66SWRhFJ1/62ynvnBIsOrIqeRvLQ3toFVpDo7Ex3uCOO3otZpENbb7QDBGLYa+90hAumVG6IHxDKpBe/C4TejeAcT4gPTuPMipnz4nCrZkUUIK3nz+3VBVpy3TkR+Jhq96HHHMRAYFMyKzWmbiVwSgkx7Ar5ZfW0TCfgm4vZFxT5w78WrUYJl4J3XQFJ684Ubf5KC6XAELO8YHgXv/K4xYafJ5qglwiARuDhUrLOJguw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

On Thu, Apr 23, 2026 at 02:25:35PM +0200, Michal Clapinski wrote:
> When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, struct page
> initialization is deferred to parallel kthreads that run later in
> the boot process.

This patchset breaks memblock tests:
https://github.com/linux-mm/linux-mm/actions/runs/25259346624/job/74063911769

Can you please send a fix?
 
> Michal Clapinski (2):
>   kho: fix deferred initialization of scratch areas
>   selftests: kho: test with deferred struct page init
> 
>  include/linux/memblock.h              | 21 +++++++++-
>  kernel/liveupdate/Kconfig             |  2 -
>  kernel/liveupdate/kexec_handover.c    | 52 ++++++++++++-------------
>  mm/memblock.c                         | 56 +++++++++++----------------
>  mm/mm_init.c                          | 30 +++++++-------
>  tools/testing/selftests/kho/vmtest.sh |  4 ++
>  6 files changed, 88 insertions(+), 77 deletions(-)
> 
> -- 
> 2.54.0.rc2.533.g4f5dca5207-goog
> 

-- 
Sincerely yours,
Mike.

