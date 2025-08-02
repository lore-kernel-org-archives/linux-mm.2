Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C682C87FC9
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 16:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56646B0088; Sat,  2 Aug 2025 12:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07676B0089; Sat,  2 Aug 2025 12:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91D456B0092; Sat,  2 Aug 2025 12:58:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 819A66B0088
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 12:58:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44A9A114AAA
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 16:58:29 +0000 (UTC)
X-FDA: 83732425938.10.5729116
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf02.hostedemail.com (Postfix) with ESMTP id A20B08000B
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 16:58:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CFz4ra0H;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754153907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H9BerpmcmHXgA4n6P8Lfh3Ui4Ass+HD7EIy/kZR0358=;
	b=2D8mYN0L1pUimsAirPGwHAD99nKNMm1YQfjvC/EcHV3PGB7c+5lz1jp805L6MZKuHT+Bbq
	ljgZiO05833aoFY5Kfe4bTdwRp/N8nF6vJ6Sxcx1egfaIAb9QaHEKosNnmSavuwCsNlNj9
	HPFpqcxpURKthZGjrLO+9v95/JFbIHQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754153907; a=rsa-sha256;
	cv=none;
	b=mZkSBwAI10T5SrE0L2UWsfy++AkAqXgbUriO8jFkCSe+tCO+H2cL8b102AsDhuN4DKVMxu
	BNPlA9fp7PYc9me745/j0RhSvYMOSiDJNDB1e0KvEbrRySjvJGQFSRPZXqafqkSAfUbLlj
	a8N320xs8nq5DfOtSU+ZwRwGyrNj5cQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CFz4ra0H;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id D77DAA526FC;
	Sat,  2 Aug 2025 16:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092CAC4CEEF;
	Sat,  2 Aug 2025 16:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754153906;
	bh=QkfgJx+v+j5j666EMkLWa+Ni4oABKMVRYbpkq1C5Pqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFz4ra0HgVtSHcTAmcCVXD1C0hJaB9hvr3xAMPT1lFdqYKFzv5l1n8Gd49YPYUC4v
	 5ePJZ5qAxyAaqjrOInDLRUoZLmt+fwQt4JiacdHetK1hakwV6M5E8EzM5CFnuo8kBd
	 2B03gB2jJ9hUwnx1dq9Zic3uTT2GmBXd4X3Td8rS2vLeusz3yaTVT0cCY25lPitBu+
	 xrhlxZbGO3/Tca8nMtwk1zl1GGi51zOFomT6eR5LfI2Quw9EsYkrO3pHNDi5yfG1xn
	 foAQUtJ6RxHZdOYCVSWHmofNPlZkMNDxJHqV1Vv/4LnakrhKwyu4vSTnLm4n+ZNxs6
	 WT6s8nWY7srrQ==
From: SeongJae Park <sj@kernel.org>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 0/2] mm/damon/vaddr: support stat-purpose DAMOS filters
Date: Sat,  2 Aug 2025 09:58:23 -0700
Message-Id: <20250802165823.7277-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1754135312.git.pyyjason@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A20B08000B
X-Stat-Signature: ifdxj3fh3hkwig4x5p5ghyaay5mocig1
X-Rspam-User: 
X-HE-Tag: 1754153907-865874
X-HE-Meta: U2FsdGVkX18Pl17YPDfc+nStVxg5fvVX5soEZ3TDhWwYNQ8BqRbDcqYcPkOFlbm1SZI9bxsQCpx7L6eizMxj2jiwOSJmecJuuZmIxSUI/B/ol5B5DUc4aDaHeJmBBplzfGhkxdSe6vDl4yMFkYrWcX/pPp/PV7+H97LIt7gEN+FSM3t4BQio6/AibxL9D5Z8gIBSh5Q4P1Piow02xBi9tHeUgkaTLwo/s65Eb3M8lPPL26E50zRmGH4SGxvg1O0bHKR5FmZGXwvVp9n7ROsC7//TnG15HqLX/30ImXPeUsQE7KpfjSCgxPBKz2KvrGrvZ9A7N/GDV9jADvZ5DIwSSHeVYe/1XV4MaNP5T3tLcfU1AeerxYdRfKcHD08FVngFBiwbN/HtbNHL8BMRi3V1UTGwhqN8YdTWBHp1W7GZt4ldZy+cEogvI+vycu2lE/527MJELf3iIRsKkHivYPA6BFlmDJIHxSDP2SfSDlAMGVDmlrdwjVBd9HFr+AYoVwxNlvyAxPfYpPKdS3GJkolyDK7SoTzH6xt0TiylCy5EVktSaGMM7k/88PcG4Vi67kI9DbchD12dGePx1z2xfODgWQ2FjEK5TRhMsd2ZBd7VuE03BbHFIv2xzKFCeXTaKE6lNsbD5P+jLtHrevwcuqIbTEsFDYJvP01t1q/K3daTJ6axHn6AREmbyULKtPj5/Xfkz3sXmQnLzPVdjEyz41fOdC9RcdzZJrEbg0ofG0LyOGo6nQPuAzBIZZ1pPY3BuNAcPAd8EPSRx2ZcUH/SR6xgKlqkqUS1jBf5WI6NDQ5/nwH0VBYJREJ7PFpPGk5DUkued12A9iiNcomsBlL1ZOyCiiCHXKzDHy3PZ5qJIWHx9VKqqt4Ec1+D50F+A06aw85aXcjW11OzVKYYsH9E2H4r4CH7VPC5NUOrEtsHe4joTT1UOIGMZz+If97QBjJJIPz+ebhu5ftPXgsTEaFqLgA
 MKxVVp7c
 vVZQDgvNFa1o4zPaV/XUafY+8XpQd5Qu/4C3KMuP7NLOC7idGTmi4BWYdJpR0SGFb3TEo8Kk7wctUCvQCRI+B8bm02bo7lOzgdE1az8zp5KoWZETgtEcwJcTAyxYtFLB9M/ravrDBFweUao7rtr5d2IiJ3x4RCg0G6GacrJ3Ed6fyqnhGQRBLwGlxTzHrIep0F3Mq7/4iicKiqk8VvOQ6FojftsuX4Bk+joGIshgKpB3tq8c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  2 Aug 2025 11:52:44 +0000 Yueyang Pan <pyyjason@gmail.com> wrote:

> Extend DAMOS_STAT handling of the DAMON operations sets for virtual
> address spaces for ops-level DAMOS filters.
> 
> Functionality Test
> ==================
> I wrote a small test program which allocates 10GB of DRAM, use 
> madvise(MADV_HUGEPAGE) to convert the base pages to 2MB huge pages
> Then my program does the following things in order:
> 1. Write sequentially to the whole 10GB region
> 2. Read the first 5GB region sequentially for 10 times
> 3. Sleep 5s
> 4. Read the second 5GB region sequentially for 10 times
> 
> With a proper damon setting, we are expected to see df-passed to be 10GB
> and hot region move around with the read
> 
> $ # Start DAMON
> $ sudo ./damo/damo start "./my_test/test" --monitoring_intervals 100ms\
> 1s 2s

On v2, I also suggested adding indentation here, same to the outputs of the
commands.  But, this is too trivial, so I wouldn't request a new version.

[...]
> Revision History
> ================
> Changes from v3 [3]:
> - Fix some naming issues and improper text in cover letter raise by SJ.

All looks good to me, I gave my Reviewed-by: tags to all patches.  Thank you
for doing this great work, Pan!


Thanks,
SJ

[...]

