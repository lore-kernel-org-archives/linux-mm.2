Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99FD1C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 07:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52E56B009B; Mon,  7 Sep 2026 03:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13796B009E; Mon,  7 Sep 2026 03:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9296E6B009F; Mon,  7 Sep 2026 03:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 684EB6B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:44:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4872A4B61
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:44:08 +0000 (UTC)
X-FDA: 85186177776.13.7EAF6CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 29029140002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:44:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZHcWvEz/";
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788767047;
	b=t/UUpGXfyXxnF0MwaVXgUSmNAQmMU/Qde5HtGX8AtT74/jppEgmzPVqJqZtFrvsBgGGvUf
	QflnSzAArge3X+4MTTFcjZ/3HsKN3NxM1NUhuwFh52aXR4zZ8HWrdSd03xHq64ioik3Lfg
	NiMPnHCMbpB50BTBWsBZFynksPTD2lQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZHcWvEz/";
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788767047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WqU1djRZxSt1nh3zcheMqIKq6ZNjalLZQ1iHp63Z5TM=;
	b=bSkD2gL56xnKLqtrC4grBHHakmgWztyOUOC0mPzTtrNdK3vaO8hupXXFcTxbAztsNh301M
	owW3Gs304U0csbNoQdhDtCPelHahZWu7+osIYCUo9SwCneRtDsZ5k+FWW52hri612ed8lY
	SAm+OSYyA7AFsRRXf7nR30E79GP1mTs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EEB2C4040A;
	Mon,  7 Sep 2026 07:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FD51F00A3A;
	Mon,  7 Sep 2026 07:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788767045;
	bh=WqU1djRZxSt1nh3zcheMqIKq6ZNjalLZQ1iHp63Z5TM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZHcWvEz/9PARpUHvye3I/SIP6Z73Yg08URI/RQc3JEujjcu9flHGtLT1NgG7oqJKQ
	 +aLogYYyK6bMMgHBR18vQRtetl7W3ZzwhQBrMmVtI3dyFg+RCWrySEjQgv2Ne9MzdF
	 u/trHjYliLe6lXnspu3m1rZCnmfuiiRraqapmJQtb5qKJjkBLgYglwQ4Fpq8Nwj+bx
	 0G8L+0cUU7BYK9Bd2eDrCeeAKAIHsOhRkcJ51coT9heNeqAewXUI4lzunlPnLmUiVj
	 f+cZG4E1+fnlG4NUp6+gwrTr3H9vIphufAbWB4k3PdGxSaJj+8Sf2BA4GHlJav2ubp
	 w6EeroWTPSFfg==
Message-ID: <60a8cf51-1493-4dbd-8779-8f007f6783a0@kernel.org>
Date: Mon, 7 Sep 2026 09:43:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm: minor janitorial style cleanups
Content-Language: en-US
To: Christos Skarlos <christosskarlos.kernel@gmail.com>,
 akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
 osalvador@suse.de, ljs@kernel.org, hannes@cmpxchg.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, jannh@google.com, pfalcato@suse.de, kasong@tencent.com,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, mhocko@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260905183135.20993-1-christosskarlos.kernel@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260905183135.20993-1-christosskarlos.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: nkpuzab9tyti3x5idzc8a9kcchiyongt
X-Rspamd-Queue-Id: 29029140002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788767047-139052
X-HE-Meta: U2FsdGVkX19V7leulmeHMmCmSOStSH+bLxqLXKWThpioHJVe4dee9h5k6BDtzdGT638Xn0aN5q2QB6t4M4nn+YxBdDe2JYXffnLPKB8FTDFlSks3P5MGRtmDtrorUgtHuasBZOMJLBO19pbQfy5GB2W6AdChKe5MVekDUIvVVrBgCUXV10fwjdYcrtRb0pLX9hGTZan8SI6kWomctN266IHmaUb/6R67R3OB1peZSEM7YUkKMg+MVRMk4M6hlzVnEVO8JnzDI8PmQStDNdCGh6VzLmwj5qppOnVKaHz4+s63DWtbK/YfSxu5dhiBu2CEMoslU53Rm7OoKF22ND0DTwUkbM96ICgt1g+UXgs6K/IW62JFhkoNSPM1WsqTcLLJ0e0ve/DQxsQ7pxZEWv2yjPSyhQxLMsaFbvgtPFhbeNZFUwKL+7waQhVAk7yKZfMQf8zOx1Ka+g+pqb83L+vTvKgmVwDSTbjNE2VekZD6ak5XMiTBJwnG4DGsQj/BsgJdvYpUPhB2Fs5if9tIdPiRJ2X1ooFiLvj3qWPBlBvAS7SJ2BA2EW0/mXsJCjiQ8FGynNvLwgM4eKVt3Kpuljy74KJsqnoyuuiK/lVxuWc9NWUmhP6J+5TTnthIzZ46Vdd14s/5WMkCgQwAwMTa0Cp6XtZuc0sylnecS6esV4d14P+FhmAreRmH8PPR195V/DNGM4X1ONlAoAanb9rEdnb3JwciKuql/OHBDA/Rj9mXHHNYyAjGacZ/oKhtNAU/d+aha+UI2RnIwMdvLFcSsuaPPRtYSwpGlSO951w61EgnKTBvVwkyqILPnE0LJl3yoVZQPqjBBwwQsHS2uYroSHKDkpsxM+ipA8Uz8Q7N0Op8d/RyxTX7vYFiNre2HUyx/nPYzQLRndOe9TX4QwRd4uBj1O7hvuxy64lCZf4/G6Lfk0LeXBx8damTKqTQZN9w0PfJ+/5M6yJB5ryOVDepVgM
 Fb44xR/a
 GMlxJrinlzFISRWZAY2NBRzZI8x11YhD1bB6zbw7F2W7gNiW1E/AaRxAzAf0K9yRTIhDplIm8CI2A/Tjz5f+ZJeWAGdqW9zu3ehu5dqMIuoeoZmle980RUtuFSI5COpgf/rV2W5XnOo0c1gGfvE6YPgpBz0CHE23heAcLPd3ymFMTFRUDtn+cQup03kGq3gxUdObBK1+YupeTzVWwRCvZt98v0TDeLXskeRaL8nBeVbN8Xu7juhMcFfVlkyHdS/neJaZyofuPIFB3n4sfzRinfFZUBm/HzCeKwC6Ysb8LJLOorgpyHlNe2bT6BEE/1f47+0Xa5AFkmb5zoZkZJMYYqNIIkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/5/26 20:31, Christos Skarlos wrote:
> This patch series resolves various coding style issues flagged by 
> checkpatch.pl across mmap.c , vmscan.c and hugetlb.c.

Checkpatch is meant for avoiding the issues when submitting new patches, not
to be run on the existing code to generate fixes just for the checkpatch
issues. NAK

> Changes in v2:
> - Restored filename comment at the top of mmap.c.
> - Restore <asm/...> headers in mmap.c as they are architecture-specific. 
> - Remove blank lines above VMA_ITERATORS and NODEMASK_ALLOC declarations.
> - Fixed commit message typos.
> 
> 
> Thanks for the thorough review and guidance. As a newcomer every 
> feedback and advice is really valuable to my workflow.
> 
> (Note: Apologies for the stray huge_memory.c patch included in v1 by 
> accident; this v2 series correctly focuses strictly on mmap, vmscan, and hugetlb.)
> 
> No functional changes are introduced.
> 
> Christos Skarlos (3):
>   mm/mmap: fix various coding style warnings
>   mm/vmscan: fix various coding style warnings and errors
>   mm/hugetlb: fix various coding style warnings.
> 
>  mm/hugetlb.c | 16 ++++++++++------
>  mm/mmap.c    | 12 +++++++-----
>  mm/vmscan.c  | 11 ++++++-----
>  3 files changed, 23 insertions(+), 16 deletions(-)
> 


