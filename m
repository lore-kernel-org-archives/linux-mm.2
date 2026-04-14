Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07AB8F531F6
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 06:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38A9F6B0088; Tue, 14 Apr 2026 02:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33B306B008A; Tue, 14 Apr 2026 02:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22A476B0092; Tue, 14 Apr 2026 02:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EB5E6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 02:58:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 916D888C65
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:58:02 +0000 (UTC)
X-FDA: 84656256804.02.FB55089
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7D912140011
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:58:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=b3vj09nF;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776149880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lwTuR2PhVEgSCyjQCwvbuby19x0diy657rvwRBEtIr0=;
	b=vOGGDWj71zpujZEuP9Ujis2ugYLR7zSut8/dWKissqkv1F26KLvdqiGVM8SmMBLapbho5z
	zhNagmX/q9zh92piMOBjGU0ZHmgdELlRRWzZzSR/strpPJKjkByYLplA5ETWyr9lC1SK4k
	8rN9raV1RZgVTcR6CG2TFdxCqWxIaJQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=b3vj09nF;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776149880; a=rsa-sha256;
	cv=none;
	b=tSogPqOhqO5H11+EphoKyiEoS6xfxEvA3ibioNY8DkU9jZsbu6nsz9tqCDYS9BtM++YO6A
	dh6mTZ3GXciOuXtthLZpGSAKzM/ifpADS3xUFtUD/Kzpk019RlkY4XsyQvJ5rLm6m2CKUs
	1f4E8sFKnno3eIyw2TR2Gh+yRGx3emo=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488b00ed86fso53979075e9.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 23:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776149879; x=1776754679; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lwTuR2PhVEgSCyjQCwvbuby19x0diy657rvwRBEtIr0=;
        b=b3vj09nFbOYxwoi10QMtdq1gIluzijDD5gXDIJ9TyszFymnvB6qoj7CnFAevlxjNFe
         KS+qVIa2Lnz7x087fkbPiB8/o5lD8i9+AhOr9xNJorqsf6RXpgkiI2DFwc68w+JpR8jN
         LEBX02bAD2TVopbSuxZyn+U3jcGNBlYnMgdTW+LftAW2V9u0QYszYnTaD7rOBkZQLqFm
         lub1wp6lGpRQ2aIDAWisI2jPRoIMoOoyj3kma2JmGnXzb8sx/QinTGM0d+kYVJTRsYah
         MCqQX9QFeoOG7MuZvj/5CJW7yoYNcg0ABy4PCruzfWOcOL5AJ+5bECQg5OXe/rRF/Fke
         fQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776149879; x=1776754679;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lwTuR2PhVEgSCyjQCwvbuby19x0diy657rvwRBEtIr0=;
        b=YwyGL3r3jkeMSY0gEzOIyIbIu1QvsQ27RAXAZzWrhQfOt4QD6YI/vi2exh8W/6JqTy
         TLLPJJ/ps8svOBHGJ4WwkHoNbUlt5DPCJ1Yq6qKNd3pcRazsiilPOljqYrz45in+Y1GH
         N+2eiih5wYgA1BetWeQgM9+e48lsXkQ8m+DrOXhinqzOwoBPzkZ8NJYcfY2+WsKxABu3
         iv1xUDgTmkYzs7MNiYbRAZGAsOSrJbADRaKsa0FXfFtzWToHYzOtyPn8Fe1bPSXMxTPx
         UkOlV8B1uDMCA8KCqUh0Un0WaJaYkmh222E3BV6jFjLwf3N3LcmzX/OxzYvSrsiX2yej
         dwrw==
X-Forwarded-Encrypted: i=1; AFNElJ9YqZYcvPVlnfwPb4piHW24zyX4u8dGrkszbzH0IclWFvGsgki1f35LljofJWDPmzdI1FxhS9LuWw==@kvack.org
X-Gm-Message-State: AOJu0YyUkNDYxPS4tqLER1bHQnRnn48hk5SGQDDigKO4clfp7CAEMQUi
	mKY75iB73inL6OKEDgPnmNcVrYGXiBHqAkVM3rjCQpH7HR3DTu5bIE3nk1YTP6KJWDw=
X-Gm-Gg: AeBDietq2Sc87HIE8Dy4cZZw2NvdqPQ8O1bKjxQAM+N0c4yc1Z/r4lCLtcvzC4/Q5sE
	tH6zN13AKtnjE1j7AWIpIaeOxfugFh4DZvZTLkylPRe1Bc3R3Zo510EoIIokxhmHOFmsmaTSV8T
	XbEx5Fqg4gYWo1GbQDJOlAobQ72y2gACHrxApVQBDBrObmf2Ildn4aQbaABsI4lkt2IxI4teX9P
	xnyznvRlYbe6f/X213tUbvUY3p9lBE2bu0wISsRKT2UdUvaVbuh/37y0hdDjsThvnb4QffbduPg
	whEGMD5+90oAdAnj58RobTNeTGM45VYH3KYEgPhRxIBL4C8865xfF1P2N1z4T3HoLc7z9/gYdWS
	xINS6frGe4GpUVdAV3dnfRojzJrC1i2ztGD+Xg/MrKNqqQRP0qoIdbJd5KlIAzr1M+0PdOGCFJO
	CgaZ/Yg2vonRrfiMHnBsdD1g7bQ20ZAVyJYISpxzyGIQh4
X-Received: by 2002:a05:600c:a413:b0:488:a639:b787 with SMTP id 5b1f17b1804b1-488d67f39admr162085275e9.11.1776149878711;
        Mon, 13 Apr 2026 23:57:58 -0700 (PDT)
Received: from localhost (109-81-29-22.rct.o2.cz. [109.81.29.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488ee018b34sm28791895e9.13.2026.04.13.23.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 23:57:58 -0700 (PDT)
Date: Tue, 14 Apr 2026 08:57:57 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [RFC 0/3]  mm: process_mrelease: expedited reclaim and auto-kill
 support
Message-ID: <ad3ldU4DZxga_J2L@tiehlicka>
References: <20260413223948.556351-1-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413223948.556351-1-minchan@kernel.org>
X-Rspam-User: 
X-Stat-Signature: rgr9419zyjw13tr4dgsqbjp4z8nj6t4f
X-Rspamd-Queue-Id: 7D912140011
X-Rspamd-Server: rspam09
X-HE-Tag: 1776149880-654921
X-HE-Meta: U2FsdGVkX1+FwBrxI0gaoe/2KofS1sNY8adTslHu8LfTLgiWo4H1qXSHxmarJNfWSMv2ravxA2L/x/XrdJ2nH+BiMc1bjPytQ0QCtDCPvAmRZ578VScVz5CAa6umsUptdpJGl9Rd6Z85/YkfqNthoui9Tz60JTEflX1AHE15mz3C+1+P6GJ5pn1/9wDBkXRIt8OL2ehp6GLmmWJbpH81Ui0U+lAuCNXnFkbs7Glh5O3yv3pkKBvmYHsF1wM1in8CE4R/uQx+3nlTE3ZMelGhEMOhxGQR8C/dMl1QeIT3kicXrTGXfe1sDAcXQzRk+987d5k6xN4U0hnNcqL4nGMnE0s0yzKrn1rgqVmuCBfq2TaaPv+sIbdmJudJ1Q6xr+znUH6lhmn30xkm16z81msj8686w63Sidln6H+32Z00cVe2h90NOin3GPJYiz6eYvpwqjBTiHqE+Na/UuoT1JWa9cgz8q77bJo5YZK61KjEjzPdELI9HsU3919A4iCmv237lMksL4cExB/mn+hsOHxftUX8+2rHYkVaLWWib75CXjyNnXHzjK2/s0Kd3LhEpy51a5NeHXoXyucve9ehbhMq/7gqbBWxBYDXPMM/IzaPQiNwtGIRPJRZzYPOy82Po+WuZZP5CzeLCpEmiQ8CDmeFQJPo1w3+Zz9QFtHgKrwFS+mGu8RhyMcU9to7aUBtjVw5YCe91pbVWhRBee4Bfj6t4Njp/fwk8PVfOZYkIrdh9FP4K4KZeNTfJJKLGyMe6bLjZcyrDoM0C04yCY2RoSVJKFX+aCkbffjraQtEB/j9m44C/A3eLP4IcESBYzhQIdYeynz+PWgh/UGpwRZyk5YrA0iyCM3LBUzE8e9hyv25sxqIUa8y7sYWBkyTkrINr6ibExWEsmce/lDlt+RXIxuI7dR+18Nz2fOzZgFpea//8IwPV4+cyCSVZZjhS1X57dKR7AJ04NUTuz0mggSE6lR
 6G+td1Ee
 1U0+jUz2AUVAz2qi5d4rVkcHWmAks81lc3hoO1Fxy4R9gYpL+7m2C9a/M1QA/vOsnLNmui64aP2pIJnlHr0KDPF1fkHTIkCsfxsfg2B+U/9Srwu4A+Isu+zrZF6R8UeerJT8dsS1ijoezUNPt8ITpQO/KMCA0gsrbX5ceFs652ub0Z3Y2olDqaXsaQbXw0C4cd1aHshNs7sairpooPUsyrL2JXgDrkknfHJSBJExRxJx3+NBMlTqVBZwEUZWecEmreFKK62CpIoPOjQpwLiE3X3nfs2o4i2EUw1yP3G2hfMZx1JZhnk7GQrT9k+zE9dN9G3AXUi/rsf/g4TrMusl+JKuZWe0dxfBHAQJjF3M0WxTivz/VMAVje7FqU1BEX6Wu+kyTZx0r8beudc0YyCG1CNTBUoghxD0USKar0UF8HasjeaqTBqHK1PhmhSmBqWtzEIfXrUoEbunytwVQE8WcFMKWh9Bvdx0zH5Ou26qWVr9hyhI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 13-04-26 15:39:45, Minchan Kim wrote:
> This patch series introduces optimizations to expedite memory reclamation
> in process_mrelease() and provides a secure, race-free "auto-kill"
> mechanism for efficient container shutdown and OOM handling.
> 
> Currently, process_mrelease() unmaps pages but leaves clean file folios
> on the LRU list, relying on standard memory reclaim to eventually free
> them. Furthermore, requiring userspace to send a SIGKILL prior to
> invoking process_mrelease() introduces scheduling race conditions where
> the victim task may enter the exit path prematurely, bypassing expedited
> reclamation hooks.
> 
> This series addresses these limitations in three logical steps.
> 
> Patch #1: mm: process_mrelease: expedite clean file folio reclaim via mmu_gather
> Integrates clean file folio eviction directly into the low-level TLB
> batching (mmu_gather) infrastructure. Symmetrically truncates clean file
> folios alongside anonymous pages during the unmap loop.

Why do we need to care about clean page cache? Is this a form of
drop_caches?

> Patch #2: mm: process_mrelease: skip LRU movement for exclusive file folios
> Skips costly LRU marking (folio_mark_accessed) for exclusive file-backed
> folios undergoing process_mrelease reclaim. Perf profiling reveals that
> LRU movement accounts for ~55% of overhead during unmap.

OK, but why is this not desirable behavior fir mrelease?

> Patch #3: mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
> Adds an auto-kill flag supporting atomic teardown. Utilizes a dedicated
> signal code (KILL_MRELEASE) to guarantee MMF_UNSTABLE is marked in the
> signal delivery path, preventing scheduling races.

Could you explain why those races are a real problem?
-- 
Michal Hocko
SUSE Labs

