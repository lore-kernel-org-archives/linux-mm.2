Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80817C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE706B009D; Mon, 31 Aug 2026 04:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5F76B009E; Mon, 31 Aug 2026 04:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DCF36B00A1; Mon, 31 Aug 2026 04:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 179216B009D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:47:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8FA1D803D3
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:47:40 +0000 (UTC)
X-FDA: 85160936280.08.AF5DF7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8AF74A0004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:47:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=osW0C+zL;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788166058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hgZaDb3jHysBqG5gB9RY2SL7OLUO+d0tIyfCa7KbGt8=;
	b=vlfhV2Or8Bm1YQOc/xQKtX3f7E2CMfx1hYbaOvvO6ojuO73jNadFh7gSDpZGtbLaFs/eYu
	tw4dIAA370n+GQoA1q8IqgY0F9JZplg9w7vt3YXzgbzje2nPY5eOXemN9XvoZSqXS9g5/v
	McgvlnZIQIQxSk5SGYN9jaCA5ImW5fI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=osW0C+zL;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788166058;
	b=f9pAEQYkbCVnXojiQmOE2z7mLcCUfdZ3gpYKq46Vbp/zU1d4DpQO8xxeFTiQtbFm+bCzgb
	2ZjAPb6YqKIwtJOW0nrQcNjwOSU5ni1siB/FVtDVkndGG4eQmkiiydgaQbbjfSWNPbYg/6
	BRkR/26ta0CKqDOu5WDaRCbsGulmjqE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA70941177;
	Mon, 31 Aug 2026 08:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1151F00A3E;
	Mon, 31 Aug 2026 08:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788166057;
	bh=hgZaDb3jHysBqG5gB9RY2SL7OLUO+d0tIyfCa7KbGt8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=osW0C+zLc5yaIb04oog/nGyF6+E90eFC8KRWcs8FLjK7CYAJaCJgtQYTdBco03hs/
	 RYz2owG58VuRKUUXweV35ci4IELrNDuY9A/3xGW1G9xLpmD8ItO0ZWuj1QWLd/phwY
	 0ZkYouih+GFY4Xi/kihvBtYNycjLJCe60AFuV1iaH2ItDmI8hzk6XVRfhqc6KXVVAX
	 43bPA2BB7VUii81IacrrzvxX3OJcp5qm/GtYNNVOmayLhRD7Z8h6kyoZcQ3rOBJPJM
	 watbr/h3vc6DxdX8t+6JPYC7wf2jRjlwBS/3B5oEVXXWLIoncJG94/atutv0ofGZ9M
	 ePKWhKdp1CW3w==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 41DE31980082;
	Mon, 31 Aug 2026 04:47:31 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 31 Aug 2026 04:47:35 -0400
X-ME-Sender: <xms:oj-VasIH3hqD_0nrmirlt1UyI7RSoXdG4acjCz7UYDn_DEdsUPVxpw>
    <xme:oj-Valp8yon14r5lI7GobNZVhMihyFZVf-XAg0BlidiCbsnIwNN6ON0gGzDJmkq71
    1U6w71xHz7_ffD_FmENfLA3lFKNqFIAtOop0j9EpCemumjVE2kwKbw>
X-ME-Received: <xmr:oj-Vag_7mnjrxq56rbDtStjApMTY-Kra22BSkJdP35NpVty2G40pIqFiolw>
X-ME-Proxy-Cause: dmFkZTF8AnKVRZxti1PyxKUQhgoh6fkIiLRKSDqX5+0I8QAvrjxkIUL+BQ10yr9hmtk99G
    pMpYdorUKGcR+yTaZtXLylI2S6vtx4c+chOuEgbSUZjQlPnmrZ9zCj1rF0M/Yhb12AbdNc
    BYpMQpkYUl3fVZYnEfpOD6aa73TS5tCd/nmbLMHGX4lCdQM9rLl8kA1v4wdRRCrjW+Iv8U
    MpAoosOpq/o8hsUUe67K3OOrl40WcoRYYwHbeVrayNXXWVzchIqBNGgr+6ISGiUcQ13m5N
    YaCSSLjEFub8qC9Ka1FGvDTLqHGfpp3aOXUce5CGJR8pTEpEb7ULvXQfHaLl4HgPD3AzaX
    oSUBJQbvX3eoVQE0dM0CWzCnBnKphJo3yTYs0NvARQoAtsNkrIfngil/s9r6SWIoIMS0mj
    1RmAkc7+E91fRKttvamj8f22Squa84WukcOR2snrRLHOnStRSjUvXCoU0g8yP/+/VDfwG2
    cJDXNllLwDLe139QxvJoh2nYWhloaffjY1l49Yb2dRGJf2TjxTnoV7bic0HJb6plKyg3xA
    YU596B3AAriWI39a81wNE5JoieM11LKwX5C7go3LBsdrOqopTFiNYXWQF/EZ4DBMXzUt05
    7ppsHkzY2s8/dR5kLmlKkletfSlW0IjXb5rD09wr//SvMSJ0wPohPv6gIpMA
X-ME-Proxy: <xmx:oj-Vag-q3XkirMERcMkFnT6on28mivxPArYM4sH_6O6-Spkkp5g-PA>
    <xmx:oj-Var4y3M81RqikESNXnd5XgNBApn4rSYDuo6C5FePSucGpspAJWA>
    <xmx:oj-VaiJr2lzfc1kuWvroRPTxcBOa6EmWauR_o0fMuKc3J7-JTTQoAg>
    <xmx:oj-Vaq4tYId9--hUEiVwOH3Xjvi_0Sc_5pq-ufrp8VqAONtmn_q0Bg>
    <xmx:oj-VaiXY1l-HEJ5la51w-F5_Swh6B4uO9wFv7eypD-haDG6qA6B73mIf>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Aug 2026 04:47:30 -0400 (EDT)
Date: Mon, 31 Aug 2026 09:47:29 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Nimrod Oren <noren@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Nirmoy Das <nirmoyd@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: cap min_free_kbytes recommendation at
 1 GiB
Message-ID: <apU-lExw89P-zKgD@thinkstation>
References: <20260831075635.2244437-1-noren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831075635.2244437-1-noren@nvidia.com>
X-Stat-Signature: aqxx7s5ten961q9cmhpeaqnnafdwkmxy
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8AF74A0004
X-Rspam-User: 
X-HE-Tag: 1788166058-789389
X-HE-Meta: U2FsdGVkX1/Ieyi+0xIQ6rmHpOoOz3m3Z/BJlfaRAoimUy92un+NI6PKnB20gbRiIDkRa1xIEl4+ecZVx1rgH7TpdGJdCXTBpHVV43tsXsnSIEHvIEt84CbepF/D/j9NOKs0Cxzqze1m333gGj3blqza16ZIfBM9sojmHLQqjMSi50NMRwiN5zQmUsrOAe22W8ykktS9FoN3dOnMG78HWmpWNgYwo1lf8OWRpnMOZEBuQAN3IQoy7JEhB9y8n8mp+k1mTmASgKmYDCIiuyIvpqzgP1HwclAjNPq61MDObkSc0FERg5BetOTeB1qzIveLJQXafx1I3ggzNu+i//+H/f+FT3k/tgDkGCuNTDNwPnKIJjx08J2mUIWmkXwLeMPO5D0FVaavD1xEDVG53g3CIizStexnUKnyDFF0XMzFoZMFAZht2ICZ2zYDhtixHEE4DapGgZDujMODWgIEzv1y8BCXefgDqWFcR5gVQ8rVE9H1X7nvCO9mFo1jQiO4uPsEbXBrBdQIxQmnHRYmPuurybXlz2rMjkg/vw5220Fo4ta+SsySX2R8h/gXnaxYpb+sACOG7IReLMN87XiYFXEGxFjsaSBpBf0wbbYxHYWn/zXnJwbWVMMDPat1DyaVk7NHX7McaMaRcs0bq1FH7tzWPCiJ/7yRqWw8c7GYZMTaDPk9J7CEKzJ7I6ONA7q5/9yvGZmYzlJbMX91YEyZhIuRAchy/X96pyLHH5BDjZW3mcKftb6D8hXwgyfcx1RmKeD2yjKDOQCdSuCd36AmooHp3FPY6CAZdJPKWARfU2G6lARw4pjLeVkQGyu5c9Rcw6a0/FhMfq/yc4KYvZ168cYZnvpZHSJPoWggPu2nZUWDC63jcIxImkWiRyJUfayfZi6R450AxHRKlRP2h7YRwJ4HWmVV+9KOJdno4IxdH21fCFaBmYYkK/RQ1+bK6QPjl/yt3Am5HZlhZR3SwLP1uOT
 WWX27Qcz
 fzr8zPRacKwGlnPIaBYoRxvZcyxNIB9OXp+HQr4p/V0cbzA2eOgLQ74fiBpEeTKHNsQmNMKBepIl/9gQRlSb2QjLsuXhR+lWAcZxJ/hVqFSuBxFYtjJMj7rieZ6I9uY7K3TwuhH4pSv7SMgydwX8dnOU4rpLjUxc5B2oIe6tVR//Ak1lRx/RzmAtVM4yI/MFKKcZ8nCOfb+UgmLUck14AmHskLoJ/v5dgfXPj6NfP7MfqePDACi9VA0DY/QbRhgcIoAlDHzLs/LZSj10X5qnvQHnQ4JgoKkGIYIkHrkx3qUJJ9N2XtNsLzEPW8Ryx8KHz/fpC/pS3j1leT/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 10:56:35AM +0300, Nimrod Oren wrote:
> When THP is enabled, set_recommended_min_free_kbytes() may raise
> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> With MIGRATE_PCPTYPES equal to 3, the formula accounts for 11
> pageblocks for every eligible populated zone before capping the result
> at 5% of low memory.
> 
> This is reasonable when a pageblock is 2 MiB, as on common 4 KiB page
> configurations, but scales poorly with larger base page sizes. With
> the default arm64 pageblock sizes, the contribution per eligible zone
> before the 5% cap is:
> 
>   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
>  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
>  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
> 
> Consequently, min_free_kbytes can reach excessive and unwanted levels.
> 
> Add an absolute 1 GiB cap to the recommendation, in addition to the
> existing percentage cap. This bounds the automatic recommendation to a
> sane value on systems with large pageblocks while preserving existing
> behavior for typical systems with 2 MiB pageblocks.

I am not against an upper limit for min_free_kbytes, but I think the
root cause of the problem you see is the size of the page block.

We at Meta switched to 2M page blocks on 64k ARMs recently, targeting 2M
mTHPs. A 512M pageblock is not practical.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

