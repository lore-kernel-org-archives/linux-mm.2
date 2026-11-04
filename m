Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34460606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 14:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GMZW0dBR
Received: by kanga.kvack.org (Postfix)
	id 414CA6B05B1; Wed,  4 Nov 2026 09:46:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5AC6B05B2; Wed,  4 Nov 2026 09:46:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DB686B05B3; Wed,  4 Nov 2026 09:46:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 092BE6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:46:26 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79C2D12071A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:46:25 +0000 (UTC)
X-FDA: 85397712330.30.99F3DAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E03EDC0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:46:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GMZW0dBR;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793803583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XvwysgLfyIs5+DpWw1HKgaTFW31+lgpV5TFO7hfqvV4=;
	b=YXrz/CkQxKLY75QC6Cp5pDH/s9R671CxOWkB0q0Ur+PY68U4mre2XweH3vgRlB2XsIZGc4
	ACs2pP7y5XDI1qh5kdTtyu8Btk0/yRayhaTOO6+gEc0FqdNmMaJAUgjfZtgYlPZqCDBFMO
	UJ0EdcwvPPIuQvLiPI51n4l4m/cLJJE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793803583;
	b=0U7DIgDH/q0IKEyHX2s8zpjqkybNWXO+DEO+U0s6FcJc3GJ0OMZNe0WtCoZz8iVxzJJaMl
	me4V3mvtEAblXRT1chLk6ySZJhLZn+j3qNHeIvbVS01vnV0kY0uS9HaLgkbuxI7Oedi+Td
	arLtLOnMUqU5Q7ME0FNDs6EHfqkH1+0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GMZW0dBR;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22507407B0;
	Wed,  4 Nov 2026 14:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02FB1F000C1;
	Wed,  4 Nov 2026 14:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793803583;
	bh=XvwysgLfyIs5+DpWw1HKgaTFW31+lgpV5TFO7hfqvV4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GMZW0dBRIx8mvbM2KDH5Mq/dO3W2/K2tCDu3B35/dJTuD9Z5x/7s8I3oCZQnzZz9l
	 FhYKV8usOtxuEBFqs40vBPLEHiOPRUebcoIvqC3AbzVEC5tDV9avRLG4Mj/ddAc2fk
	 CQzZHnMsyuJOgDBfxWUgB+Ia3D4sFJD5rmGSkFkZJGzyCKP+AuHyP+NuD5TgLLopen
	 pnIYiBAUIsXgMOvrdcqKgb4OliCnCgRK4B2EpUpMPeV6VEwY+ASmgiunVXcDk9EYW7
	 Jtg2C8BK1OgAntrhhbw24OjOmRpacmQBVd78pWRcxIyahSg4q9Lz9fpbc3emUnlPM1
	 /+AgkxC2K+gcQ==
Date: Wed, 4 Nov 2026 14:46:17 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mm/mremap: fix accounting on a partial move
Message-ID: <autE7-oTy_W1WJ4V@gremlin>
References: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
 <20261102162304.c3585fc3fb88644118c152d7@linux-foundation.org>
 <d2efe4f22fe0ed9390e4d9224b81d78f.josef@toxicpanda.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2efe4f22fe0ed9390e4d9224b81d78f.josef@toxicpanda.com>
X-Stat-Signature: qho7d9dope9e3xzry41gdgxjqojbk4g6
X-Rspamd-Queue-Id: E03EDC0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793803583-80371
X-HE-Meta: U2FsdGVkX1+Z//S7DxoVSRyilNgRMzOibkzLlINZYyzPbMEr3hyZyRSHlOmFyKKwRAyeq7ulKjacNVJtHTSgKVqV5o7Gd6t72Ao2vMsuUrNrcLKeI/gr5alFiAxMSjoDpLcJ5WI75qfwQfScGa1i5XySYk7MfSTfmLksPuh3Aod9JxMyejHaIVoq002J82lT6l86XEPx+LljVO2JDZS+d5naHSIB+dO10x4cqwY0Fde/B7ZqFDmkdKi219thjPCTMsx47AN4Q86wd+XYiDTm/hh2bmY6gkfElg9gvzzlIPCnYnSNL1GvUoaK0+AXixd/qHf+/z3ZXQaI5TQqPIySBeaemH74bJlKVpoxiQQ5e9Ke5681iMdqgtWBSNfWSNb4WkKyls+Mv4fJ1MqbXV3GNkw4DdQn3tvmB6PPOrgfUz1v8kri/pdX08/3fcyLPKkI0cPlpzR1iQJUC8sBiyYU4kb3Co319jwBoxZkHR4Xm5+B7KEk9B39qy6XyTUR+tYkOe/MaQbVV4FotrsaGyc1gEhO/jRdUmx09aZYA6MmK+KNQMtbPP7xKqA5GQ8WgdsrUOP/lFqkE/RWWKNUtZb/fez02kmUevoWC3WbaC5g2AM9cW93QTXu62elYDuMsziwqYoPVdy4DiV5QELsJFjXbGz5byC9Jn/nIiy3YXS2FFyEHlcbmc43foj98O/iZXnTbTO1IpZfvxTeMcp6xqdbG0yq3WUJw45BlDn5kG8xdTucv+46o0i3kg9zr9BKQej7NgDjlWa7o7C5C+qbqqN0dLRTJbWxFHZUzORNV28s4e+RZFT19Bh86xtOa/llTCcNT7wHalbjgRDa1Ybjwou8l5V1MFzy5r4gTcqzpaZ2E8LUJGyzORqtUxoIQftHDweR1sjAfTCnCpr7o3m4YtH1T6SjMoOWGZD8GnzYElL44BcK3qcrreprN2OHLoDff5fMCNF2F+M4YP8jX8toLDP
 3GQbaijG
 3KEWBziA11Vp3mwcvtZznXztqOCHzZ/quXPt85x6rl/+PiJtEswQNhpNtwGQ1g/x6NCAGD1Q465SxNfBtkuai+b2+j5MDaoKfWRckCxGww6ZqvYrCCT4AcRFJ90qBjbXH8KX6FkLwoAOURGcorzfR3h2wpeCgplJXEeBCDQ+oNUmI6Ed+tgPW6tpsPFIyUJ7ipQjCJrO3GidM2PefURbaqCSFBggmcJrJM3uOfVRAuyzWmRbDH7wF3IIhFpGgMX6Z30jo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 02:32:35PM +0000, Josef Bacik wrote:
> The Committed_AS bugs need an allocation to fail during the unmap at the
> end of the move.  mremap() checks the map count and sealing before it
> gets there, so what's left is small GFP_KERNEL allocations, which in
> practice means a process that is already being OOM killed.  I only hit
> it with fault injection, so I left those with just Fixes and let the
> stable folks decide. If you want them cc'ed it's no problem to add.

Generally would prefer the fault-injection ones _not_ to be backported,
they're essentially technical fixes since to actually hit them <4 KiB
allocs would have to fail meaning OOM + fatal signal -> process dying soon
anyway so doesn't matter.

--
Cheers, Lorenzo

