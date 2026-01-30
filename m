Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81722E6BF31
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 17:15:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F23C6B0088; Fri, 30 Jan 2026 12:15:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7346B0089; Fri, 30 Jan 2026 12:15:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8936B008A; Fri, 30 Jan 2026 12:15:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6935A6B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 12:15:32 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1EACCC26C9
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 17:15:32 +0000 (UTC)
X-FDA: 84389281704.02.17034F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1A19516000C
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 17:15:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C0qGplRh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769793330; a=rsa-sha256;
	cv=none;
	b=xf6+1aBDeq0ncLmDFxVIgRV2dXsqIkGfHLcS7GvdqACjS9Yl98u0ebfDOD7WsdRMcwaPw+
	1VSSAKgmyh+Tyz9tqZfMEw5jfAQ00FuQkN7OCl5PeflUm2uQHm1ZZXGjZMAEsIG5ThrATc
	LDNOL5Itv4sg4H5GTFZKuKFzUYU1PEo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C0qGplRh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769793330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hcnmKc8bbMpRZmXg4I+h7fcYjwMfX916MyVIWKZ8RX0=;
	b=R9ehpzUhwsl5Pjf1SJx+1se+8vZ2iJYW+xsgfEaHP52owq9er5oyg9Hthhtd3jXgoKtzXn
	wVjmyvSAW5+rcMQ0Hm7pspOG9QrHIHleEGRAJQX8P7nna9yCXjLwrcnCnL+DevX7V0dDvT
	QBf3gatDDllGOGcPyPRfqg6dylQR5Zs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 30EE560018;
	Fri, 30 Jan 2026 17:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791CBC4AF09;
	Fri, 30 Jan 2026 17:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769793328;
	bh=jxXn6m945TBmC6BfrDwQWKtLI1+Q7FkOv1CrhidxGy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C0qGplRhQgxRydJC66CdBXZ4Nq9ZPWd/3CILouulkFJcyhFs0MQS7DYEvxhNmJxSQ
	 J+KK0Zi1wSN7opXcGko0jIejKkvz4NYThgo7Ivklv+yWvqG+kQy8e02htmCbq3I6Po
	 N9v9sBxkMWkcfQueVOu2puCdIPzTZAK/cm2T+i3Sz08xWHmvuvOprys3k0F8pRwEOz
	 cTBs69WcVO2EUawr/FmME8FoZxKqUdZxwTFnKwWZEuGELO5gadFHrtzZV84ZhUy2Co
	 axnCufgaCogo2IPg2VrgGTVsQhA/G35Sjwl8k22tI5BiosYotDO1G1edC9hge6dfpU
	 W/VEgkhiyAQuA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7277AF4007E;
	Fri, 30 Jan 2026 12:15:27 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 30 Jan 2026 12:15:27 -0500
X-ME-Sender: <xms:L-d8aRARsuZtTmmKi1ii0TEctX7RhiqLmn-KVE7S5YeFUna9kMOAEQ>
    <xme:L-d8abPx6GSsS_-EIIJBsHAUVzTE6vB4hswr6wc1zu0bch2Z80tBliUxziHnOsRik
    L5YmmWWKjyThv0N4PmmObnIF96gWzcq3Lhzc3uu9prlz3BMXtWMRAA>
X-ME-Received: <xmr:L-d8aQNZlQUpfOm4WrQYstq4VEZciw3MGQace3pCKjNPrELws2XCPN1EoAINWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieelieduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepgedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehshhgrkhgvvghlrdgsuhhttheslhhinhhugidruggvvhdprhgtphhtthhopegrkh
    hpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohephhgrnhhn
    vghssegtmhhpgigthhhgrdhorhhgpdhrtghpthhtoheprhhivghlsehsuhhrrhhivghlrd
    gtohhmpdhrtghpthhtohepshhonhhglhhiuhgsrhgrvhhinhhgsehfsgdrtghomhdprhgt
    phhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgtphhtthhope
    gurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthho
    rghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtg
    homh
X-ME-Proxy: <xmx:L-d8acBmVSRCOlwcuQfSPvjfFYKwakiggQWFUBEznGJtbV2CZ0GPrQ>
    <xmx:L-d8aUSF01Z6B6EXFSb_k7ibeUEEhRaau-imA2rV2Zey6AiNJUYdmw>
    <xmx:L-d8aWZ3qUlUPWjhTsSVwC5M8UHrB0WBzUzSMuuMfyLeSsxjAVzaxg>
    <xmx:L-d8aZ8RBuDHu266bpPPm4Dd-kk-BRud7vllJQPwlWtowIVpH7fIBA>
    <xmx:L-d8aSJp20pzHqnSsR-cm_24rfcC76Gxcle0pOP8xK8PUiyLiNEHoRwr>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 30 Jan 2026 12:15:25 -0500 (EST)
Date: Fri, 30 Jan 2026 17:15:20 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>, 
	Song Liu <songliubraving@fb.com>, Usama Arif <usamaarif642@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: khugepaged: fix NR_FILE_PAGES and NR_SHMEM in
 collapse_file()
Message-ID: <aXzmgp84VD0Vt3KC@thinkstation>
References: <20260130042925.2797946-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130042925.2797946-1-shakeel.butt@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1A19516000C
X-Stat-Signature: o8fiiey3rj74m741zkfihsnj4e7739rm
X-HE-Tag: 1769793329-314639
X-HE-Meta: U2FsdGVkX19X+wxvCQAq3vJW6Zr+g7UMqe4JWbPYxMQfDW+sWRtVyvxBFYqcvrFc6CZjFxL2KIWzJX8MizO3pGRaC3rcMhSW+r/DPJWAPiZ7++WkMET1lwk0wa/CCpwYQPbJjGafVAlJbSnis5p+ta242BIWElIXYhVdvCnlrjEDuI8NykeVWpEnZWT8JzpbBkH0oQI+Ws0aNSeIM2a033dOYIznNaq6roCyuq2ZAnsrK6xgL5r/HUIxpX2jfEgPnQx608t91ry3dMqLcvgXwGDdYVS4GuERhN1ZTy9TPv5oJhJCgYWV19LS1tCt8xARpJuKhiMEY0s7GwpgWMYy+MaqAJ/bD2x7Gb+TOfKrGBTuwOKPKNBEWnPudPoY59h4qTdGo6CS8PTIqDTPCWeRx+ytfs7iVRc+EhzklzwTEYtqBrC4I0757POk6zwV0Wwgq4S9uEoDL6Z57nhWqiRtB/n/ylVzgIppadAq5P05Rup5qRtrd+MFmWUt6QkgzjSo1fvvHOwFdUF4GDQkGPw0RaekzK7eCd6POqF0MmIEXnGW+IcGhujFSU5PDX4lutx0I+CGTsuFXu3BUgS+jLpA7PtX89J2WPol5U7N03KrJpe+vVPamXUYCDS+V7pxYOCZ3vTBt4GGpLm2bs3u9UDqMsvSOP/RExTB9/LHrHLkNzA/VTkpeCeJezjLOvW1v9bBsnPzmoPLPw86nYO1Gq9Y8D7/Qj5jUHzYHWUr5Z90G76ZLUrirnrJkJlnWiko5qkI8xxcO54S7x7PKLCP/TgcZuwY/kjG8SJHeuZ9LLv7vBKRZOxY7MMfROqpvgNYn/YDXgHR/5feXK2b8HWNs7FlciO0smELRhRp+nVtnzBnNkC6M2Fem/t2eQAZEgwmMQQREK9aMrXZgH7wjuCG1yqnO/noClUqhgYPL+hmbCurT+7IevviGmxUQoScjs1ztIdY7vDKijAojanKmsvZ3rU
 Ux9EAC8e
 Zj17SZd6Js/idF/6/39gHpIQsqspzc0ujGxzvaZZoMLMRJdGXX7034V3J79cK3jp74Mwswi6rneEsafRoUnbvci8Z4W9E+PBv5LhgL7gs03TXTeURjYMYZS47B+27LCn8GrBZiBm4WOQ+dzN1J1uYiyDC04qc+4QtORdSKa31Gw6aLeWdL3utAaliHeUKnfl1f0gRbtMcoKEOD9p7D+u+8+prU4qCP9mn2QbJu9zlXs3IlA3p7MwOREvqJZIzyNj9szUvc305zutxJz1ebsQMz5St9L3NOmDPdOcBonjNvdyl8cDtU+9SK0nXg/Q2ZaFjWM35GMKES5wS8TwGsN3E873NjWNHv0/mvat6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 08:29:25PM -0800, Shakeel Butt wrote:
> In META's fleet, we observed high-level cgroups showing zero file memcg
> stats while their descendants had non-zero values. Investigation using
> drgn revealed that these parent cgroups actually had negative file stats,
> aggregated from their children.
> 
> This issue became more frequent after deploying thp-always more widely,
> pointing to a correlation with THP file collapsing. The root cause is
> that collapse_file() assumes old folios and the new THP belong to the
> same node and memcg. When this assumption breaks, stats become skewed.
> The bug affects not just memcg stats but also per-numa stats, and not
> just NR_FILE_PAGES but also NR_SHMEM.
> 
> The assumption breaks in scenarios such as:
> 
> 1. Small folios allocated on one node while the THP gets allocated on a
>    different node.
> 
> 2. A package downloader running in one cgroup populates the page cache,
>    while a job in a different cgroup executes the downloaded binary.
> 
> 3. A file shared between processes in different cgroups, where one
>    process faults in the pages and khugepaged (or madvise(COLLAPSE))
>    collapses them on behalf of the other.
> 
> Fix the accounting by explicitly incrementing stats for the new THP and
> decrementing stats for the old folios being replaced.
> 
> Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")

My bug survived for almost 10 years!

> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

