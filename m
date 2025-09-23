Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C645CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 11:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90BDE8E001A; Tue, 23 Sep 2025 07:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC9A8E0001; Tue, 23 Sep 2025 07:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AB688E001A; Tue, 23 Sep 2025 07:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 645948E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:05:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18710C099E
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:05:57 +0000 (UTC)
X-FDA: 83920235154.01.D027630
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1C06F160004
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:05:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nhAHC8BB;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758625555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vjlt9tga3SN9FK4Q2RDsomoFscZPDff3fOIwjVqfPf4=;
	b=NaSPx0crEeMkWLgpeqj1eli6EoUfgRBkEjdQBl0rTxvnHUtHY2C2pluPUuzepOckOfxZsk
	F+z2FX/oDzC2CqeIygf1p/Z80DS1Z1aU5zjRtUEYJKrKuhyz8aXeJwBegs5GyzVnNRdAUL
	rn6nsxZNfR+cMfLZ2sid9CUFGo7ffmg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758625555; a=rsa-sha256;
	cv=none;
	b=wPX5jvNaUsYlSCyRI5YgMbyGAuxcuVsdcfnDMKPOOQffEj2BllY0N2gS7gIlwS15rTb9jq
	kstLjK/hDDGwh7Jvrj2nTCHno+XGKtl2zZSvPThOB7PseW8YoSzrNnC0l19wuiUwyCwKyh
	yecNwTPK/87EE9KaBBFPRwKWZw9Vxh8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nhAHC8BB;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1453C60203;
	Tue, 23 Sep 2025 11:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5525DC4CEF5;
	Tue, 23 Sep 2025 11:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758625553;
	bh=Jl9yWrfXoB6HlRJDSGLShBUSmOenZSlIlpw7U8A9fFQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nhAHC8BBPy2cKL/WQzins8Fd1YmBzRXki5uefA9FD0XsSD8cJW9gkxIK/8ce0ZVbL
	 ABo3aSudGRwx8MuA3Dh76W9fAr7MCo3d7D6knXzqXmk/McjYdCAb/OFNeY2/rOq7pF
	 Lm88FW6nMielJglIDpndjLSk6TbXTFtBylzbNgSTeJjd1imTnqYkYC/I2EcRg1vqio
	 mLaLqY0puUP98NuJM8y7G6QRolFD5OKW7udIRwgGdZD0f+QcpSyYiv7q8/dGf8C0fl
	 J2ok1gO8IzJJQtJtrIkHAmv0WtTakXpVLntUieq8lbp0wXqmJx8ndnlKxbnna/1YJi
	 FAKS5tW0B05kA==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id 40CD6F40066;
	Tue, 23 Sep 2025 07:05:52 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Tue, 23 Sep 2025 07:05:52 -0400
X-ME-Sender: <xms:EH_SaD_bPa34wZwW6SB56jNGFxlcoKL61cGJyXGAdF2gCG4yMYp2oA>
    <xme:EH_SaNWuBGQldEPI23LVFadfsgN915x9zH_lvvoaYZ-3TDUBys0YmOtrGTcFpAACK
    Bk6sf5E7JFb7r4_C7omfaBTIviI1to203sPe5Wganzehq-VCGHdDps>
X-ME-Received: <xmr:EH_SaIZgpnxTpBRlPzesbWUGbIINDVfwnOOrjukRtTbhs4gAPMAkgt2oGOqEyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeitdehjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhope
    gurghvihgusehrvgguhhgrthdrtghomhdprhgtphhtthhopehhuhhghhgusehgohhoghhl
    vgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtg
    hpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghp
    thhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhope
    hvsggrsghkrgesshhushgvrdgtiidprhgtphhtthhopehrphhptheskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:EH_SaHpJP4990kbtI5C9lLDUcVfz54a0r5GBKKtK-hvqp8--E_uTuw>
    <xmx:EH_SaP6cVWwHKLlVfFZ9IGcxzlRs3PP8AaHXAnuvUXt1aAU-PhJA0A>
    <xmx:EH_SaBWNN-1n0jEBLUCb-JvET_rybhIUuFWQBZEZk0o95PYDg9eUVA>
    <xmx:EH_SaNs6ojkFOtdu5f2LeXoFJtE0yBg5w0jEGgmMtonDe6Yk6mBqiQ>
    <xmx:EH_SaGrtLDQc9kCjrNzR6ti5Q6ko_Ll3z7XJU2ji0vGNoJOUFD94lQXQ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Sep 2025 07:05:51 -0400 (EDT)
Date: Tue, 23 Sep 2025 12:05:49 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 0/5] mm: Improve mlock tracking for large folios
Message-ID: <rdq4t27mqjmgeqhzv3iweihgtxsapahg4yyjcdt46kclawm4vp@agmxwna3lbrj>
References: <20250923110310.689126-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923110310.689126-1-kirill@shutemov.name>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1C06F160004
X-Stat-Signature: qa5c5bpyd9dkhp9czbpy4bxgia1b3shh
X-Rspam-User: 
X-HE-Tag: 1758625554-804612
X-HE-Meta: U2FsdGVkX19fq5jqYpMGD6A6mogs/kkqXm1BNDfcXk0jBbftrU4Dj1tpvz84QRnrVds2nXlkt6diDlTZGaZPFLn6bayJvs7/ZGhBgYfGv8GE/t0vTpuCy/CNy65c+Tmdxz3IEB/aNtdNnG6U4Qw14zw5bEDQYyBaFJZwAd+JYVDkGCCId+dE3z/Ky9zqiaHdUQ4VNAsMGpHMRctxnsWFLMkT2I396kana2B4GywDE2La4vbq4fMvjs85mEaL2A/AJ9a90iCAgQUvo2+JIAJlrSQIHsGilaSQvqkrS+a+tLfG2e4HKfNipVTIX+m3jUPV7Xl4bxYLNu2Z3ALFNjWl9A/bjOf2uML5ZCdtpD7ZUvy4yklaETQ5ADEzCken+hZleFZif3Ipt1eAT6gHEJJiZv/CSaLoIw0jcM6u2L/ynj7FYSNocZh3bNv601FnqMqyKE8+DoLHaqyCrkWhCdzLLg6w3/DJS58j5/lPyhXQEiIeeqtNce/DertQAP6w08FVyUDxKS+0dCricf4ksvpZtb6lIAeb97e+1uDLG6jmZJIGEviMSeW0n3iVvrg/qSuuQDWiQk49VPnBrNbBgFZXqjWTjU32ClDcLxK7Kg7j2vwCDcTvOcD6qHR0h64/qmPeE9iwBo/FcS5rypGVshNq7wrPXrGCk5MzNUh21ggQfR7v1GrI0L3/DwHFktDM6HRxABHnguwSMTvMqlh7w7yidV8gsi3VRehPG4/k8iJ9sXtbiKPTdeEVpsu6lrRSASEpdQBmjKBHXa1Tsjn4zI9XBlzrrS+CnJix8F2sr6XQC+TVblyvdskwMfhR4n4/NCjt/Smb27kySHccJIopmcL3dY0k55ULtkm5vapzwO1BAiN8KJ2auoWkzp8cL3r0PSGQSxneVmrBBQcD5f4lu/onkOAaXaQ4XKQyRjm2PA1JIjAi+lDhhdfIlpPdVIqzp8Y5+DSIbKeNFKTBkj/ZO0s
 O0GyOto1
 zm+Mkz3g0aEAHVgwjdvEJg8D3r5mFgA2Obz486YCjUQO4itSO6jg0SIkREit/MvsXnbuqdy+UAes3HTTugwHzMFJ/Uq+c12s6kWPosFzZuKRUro3xJ4/4pUxh2dxioW/obxGtlSQUwj3Z0xPO1vLmTkLk51k0/hz+gfkL5A4k99JMkE5ImrKbTbm8JLw/abNHPbMbkcIj3XzNjw9vR9V8ZubfbQA8XedDU8mx9Zkr+NKoBcYMwnqYk+SnTKfaRBB1u0YIEP6NdQ27Nz/TdRJpW+KR5xva+NiWTd8PzyLwiqMcWLc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 12:03:05PM +0100, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The patchset includes several fixes and improvements related to mlock
> tracking of large folios.

Please, disregard. I missed one patch on submission.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

