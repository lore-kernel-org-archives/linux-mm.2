Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81014C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 00:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150AE6B0120; Mon, 17 Aug 2026 20:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 101746B0121; Mon, 17 Aug 2026 20:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03E4E6B0122; Mon, 17 Aug 2026 20:30:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D81056B0120
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:30:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6AAD6A06A0
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:30:20 +0000 (UTC)
X-FDA: 85112508600.21.322EBF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id CEECE40009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:30:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G9DmyQJl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787013018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tqpm/MsF9EtapjtjSkpZVHhqSfnCpqB9+EaiEMe+rWk=;
	b=ayja0H3AIAw2Z/SZmLg3D288K1BGG9KCrWFDFiYXsFBDrt78qZ8/kwubsQqLOfoh87iv5K
	aOEn4tKm7jY2vFpAWUGYLkDRD7iiGJTkAPk0wYrB4FXUrUxlnJhpQ03AapoPN1IWMEga+1
	4zeig9KXhSN9A4pCMci8+ZRqe0zIhSA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G9DmyQJl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787013018;
	b=IBeu+BEiot+ZNRPmI13Y1h6GYR5D0bQPkVaTiHX7XR6WMRrsgGCo0V3CXrAsCn7T6ddYaD
	lOB589g8gQuC1K7Muly3M3rMbvR1GSoV7B1H6Q68gM8zoA6IGlUEFyp0eDNAKEHh6O5Qub
	1l/t0RCmDTKD1jOSKiXSxO6AWv1WBd4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F538600C8;
	Tue, 18 Aug 2026 00:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5980B1F00A3D;
	Tue, 18 Aug 2026 00:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787013017;
	bh=tqpm/MsF9EtapjtjSkpZVHhqSfnCpqB9+EaiEMe+rWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G9DmyQJlYXMGxO+kJ58x5iAqxVtHA1mCBKq7KNZdvUlWR9XJ5HaEtnQyLfTa7O6wd
	 LzYopOaIa5luNcZ6t0F2z5rKjyAzIj30XndYk7TjG3ZCXcUij+GYhlWIuSn9rptISU
	 mftiKy/GY8GKpiUP6hHnEm6bkVa5iNFUZhZNeHVPKD8ewpOTuA039+1E+VTUK43Y5h
	 vELvAES6yBe85FPFcqP70xoeis8ECjERLaHMkidindQ1MZROLNj2Mj/gI8Ylq2u+cS
	 W1shudVIGjfNLLrOAywROLUzVmX2SL8VkMTXLT9B1eLeDArlK6NoF00A4zg5hW7yFv
	 JOw4DrvLpLjXw==
Date: Tue, 18 Aug 2026 00:30:15 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 04/26] x86/mm: split out preallocate_sub_pgd()
Message-ID: <aoOngGT0tz5T9Zkm@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-4-6f5729aa9832@google.com>
 <am0aplxsh1b16Rch@google.com>
 <DKNXIWKP5KIO.1YT877KQJN0IF@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKNXIWKP5KIO.1YT877KQJN0IF@linux.dev>
X-Stat-Signature: pbmg839mmg697hn1rjgquznrfhofdaao
X-Rspamd-Queue-Id: CEECE40009
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787013018-477468
X-HE-Meta: U2FsdGVkX183hfuoQRXCpVuuUDMATiLBUUTYFHsamtKim/YFHK+3tHngOGeSTrPy/6RPS1eboBo9sBCBXA6G+xNDtLndG0S88lFkCs8BZ/fSz/yKAiv9+dXiRzedPB7GddZgiA9giiOKGrBG0uu1Ir1Ulk6j2UH1CENkBm/2YWsO1DNvUl50CBAuHvHtAatIjW7Lc/iWiCewi9Lh0hjF2+6ikLA11JVgH1BDk6gxeZvt98FBfENVrPParThfQowGnArGDvJejmFoRVxoqmuqkK/fecRzF0DuhCwb/vrUpcZgVmeToXEvofvisTPaos3B6YeK6h/wK4ozYxlONrbJz8nefGxrCz33qD4d59RNXRO5eMYNWdqzHeR8ewqyh4H/kDiOZp9cKdhj3f7+PsjPm2ac0XIu015uCmtDo8gMHtG69QMn37qbaakMDiLfnqlTuM/NmDD3+cmryAx2lUZbu1X4zPmWShkRdr2q2u5YHR4ob6+mCIpTsOs5dJ6HjNwW6ROBwhRunQ3JehBmqmo5mN/eQHVQ10u6TZ5J+Y5rfdtxkruBJOQ4+VWsNzfafc/ROP6O90ZDeDHFlcMZ6Xoge5HSK4sto1XnsApux+TX7wWclqOkQwoY349U0ircyh0IjWJ3eMPLeZry9KFhBf4ksJU4ChlwPwjibAS9+I8jxQ0uIMlfOEc7X03t7HJgoWrCiJS9xkb0W6wMMK3sDo5imJmIkY6akUYjt2KGDOVzx974MnstfYqQsNxl4RoxaHFkSM37LqPGUab9ge0fOzXAEFl+dJkxPT0dWlKc5viF+1Z6W53Gl+sjWYBdosQOiRRstHDtCwgZUctEfDn/eGB5mOr+oGQ8s7dQPEVAt9a4biOnceWYEU4pBC+s836k29YJmJdBQx4FTCONx5Nq/37pW1EhouhnkKpGS+XVPj9iq9lNR8wbGggZIIFBxEZr/LkgE0Nik95OGFOwy7lkvKp
 qRMrb11h
 olvT/H2TbNuQWpqX80nD+8xOEuZiriLComfDuYpLPtX9sUhQQacergxncaFHsFBko3caWc6IYXXOhxMaswORJxbJVJ1rF+7cW2aT/krae+7BLTCpWdCxxVmFcgcwpobd+p0xww6BgQTNXASlNt6cU9jftyC8AoHnkPPHYVaoD0PLjH8YlWIXguAI2K2upTOyyL040H9rM8RtAI6b4jjGmlW66XbdFqt+zFFvuTfVKecAG7vWGGnzchotEQTUOV3mMh1oIkkZmBIgVwXXEkBA4dz1fIfn0Kx2W0HYBvKx+77/wsT7XKjCH2cGH4ySB03oX/Dzs08nq0fz5jPc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >> +
> >> +	/*
> >> +	 * On 4-level systems, the P4D layer is folded away and
> >> +	 * the above code does no preallocation.  Below, go down
> >> +	 * to the pud _software_ level to ensure the second
> >> +	 * hardware level is allocated on 4-level systems too.
> >> +	 */
> >> +	lvl = "pud";
> >> +	pud = pud_alloc(mm, p4d, addr);
> >> +	if (!pud)
> >> +		goto failed;
> >> +	return 0;
> >> +
> >> +failed:
> >> +	pr_warn_ratelimited("Failed to preallocate %s\n", lvl);
> >
> > Can this possibly fire more than once? IIUC we will panic right after
> > returning.
> 
> In the immediate usecase no, but once it's used for
> mm_local_map_to_user() we do actually handle failure.

Oh yeah I missed this, thanks.

