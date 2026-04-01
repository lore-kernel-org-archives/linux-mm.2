Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5375D10F6FC2
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 15:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4E176B0088; Wed,  1 Apr 2026 11:01:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B248B6B008C; Wed,  1 Apr 2026 11:01:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3A956B0092; Wed,  1 Apr 2026 11:01:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93CD86B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:01:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 37AC51A091B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:01:58 +0000 (UTC)
X-FDA: 84610301916.03.EDD2132
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0101AA000F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:01:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mh+WihfS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775055716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w96wno3fxV3n6iGsgKy4qyVqxBnNmzke3AUeFlEKu2E=;
	b=STk7OuvuhPCQsf+djDqHxyJPefJ3zR5EVEqtPN3lvpid9MRFukxh2Q8Esd93f1DOyLIl14
	gvoKMmF4zqiGdpQ7MbdHPB1YadX+US1fB8ClIP9GFOql8roFq0tjJc0Te8wBoxL5Sxgf8D
	cAoYA3MkzPYx07xZIVe+sF0dFfh7Q3Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775055716; a=rsa-sha256;
	cv=none;
	b=eKJjukKhF9loX5r0hdp5pN0ce1yndQOwSGOybdxMa7hynbfshVHA4+nhQVESq9x6Q1UsBt
	xJmnJbyxQVqjGbQk0qgnC1C60NJUO0FTDylWxSZ0TKLFo2EOMaBZAAMqkthJNXmfo0F4S/
	QLh1LalUR6/zT/tDsOHM2mu3zIJhI74=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mh+WihfS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F3AF140B59;
	Wed,  1 Apr 2026 15:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB08C19423;
	Wed,  1 Apr 2026 15:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775055714;
	bh=9JZLEpC3zDudWHIVJLXbGQSpgeeegVELu5Gl6V80i4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mh+WihfSEiCSvgesd/712+rR9WlIha/ybexP05Hm3LIj7E1g8tKrnP2zASO5ruYPc
	 4lUf0Umy/Kz2FUeL3WoBaiy6NVtDAVnfuLxMb1x7zAv8jJWAlHzGUzKAkL9aDaSqAN
	 ok5e//MIuQ9DBfsR81EeP8/LhaCSORBjzTCe1KmK41I+lmwmOYMMbDLYbWXF3n3Ya6
	 caVYiK/PUoE5/4xsrzf/0UcyGCBWr7y5xVBItsN61LEuBVyV3JJnOFaUkfYi4+3FCM
	 lRpLNLNGtjVb7E6bKgMy1NdXg4m6PN6LorvtyQKcqQkRctg2UH2D1L9Tnl5Be5LP/+
	 6lD1An4AI5wow==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8CEC0F40072;
	Wed,  1 Apr 2026 11:01:53 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 01 Apr 2026 11:01:53 -0400
X-ME-Sender: <xms:YTPNaRhKVKqSMzAm3MlhB4lil-37uvZYemY_N1dY90rdXnAFMDS-fQ>
    <xme:YTPNafVN809Kct2q5l2dQHQ6TRclSqk7TRsw2nccIuk81ln0vnzf6fPmc80QYTZ6R
    GaUCDFu49rM7d1woSjME_8KMLy8jrZwn1Fj78QpSsO0WcFumiSYWNY>
X-ME-Received: <xmr:YTPNaZG4T0DtCxeJ9-8v9-lY1Fxu66sHhbWh7_6LDZ2OsACipnitU2dwYFNaAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdefgeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeeigfdvtdekveejhfehtdduueeuieekjeekvdfggfdtkeegieevjedvgeetvdehgfen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheplhgvihhtrghoseguvggsihgrnhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinh
    hugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugeskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopehvsggr
    sghkrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtohep
    mhhhohgtkhhosehsuhhsvgdrtghomh
X-ME-Proxy: <xmx:YTPNaf86fyl1J5nMy38nMrvFkQhVretANcU5EopIeKiMV7uyCWOIpQ>
    <xmx:YTPNaZ3iMiO0I51WeaaKH0yxU3K_xNbVjEc25FkC8-ERdf-ygSBunw>
    <xmx:YTPNaXni9nrv9-PBNzFlOsRnZjq61z39istSi7R_jLFF4qsx-uzxAw>
    <xmx:YTPNaf85x2mu1fJ_pUldURAVoZRp81v-xh29NW00tIdUFbNZgTUS5g>
    <xmx:YTPNaU7Vs_B4MlZzrNaxp2-mZOiQe0PtkO7FgLJAw0LksdxRRSwfRW5E>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Apr 2026 11:01:52 -0400 (EDT)
Date: Wed, 1 Apr 2026 16:01:51 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Message-ID: <ac0ym9Hkbr1SWCs1@thinkstation>
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
X-Rspamd-Queue-Id: 0101AA000F
X-Stat-Signature: dp84pcicri5g4e437nb16bkqi3c735hf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775055715-370067
X-HE-Meta: U2FsdGVkX18Dr9u3Ex3QVznbvMq/CkFTdjq/dRuun9wfYleaZz5M0qPZp1BZjfqYlf5UH7rUJ7y+TPEdcz1n29PjoaZpX4AgRdsEK//nT5zIssQxBh8DxYcDUVr2xLZDg8zkJU14d3aCy4P6QJOcf1HTd/sYYtc544ZTbvloG9UxRdfsU1e/pqfYXekNLC118KYSpHNvFR1CBEjglO2rSiXyRdiDfgcOjtkYbNdnHetSlwvKkwi1x4XOYiBiCj3FD0LXgTZCabEYRg6b1VG6YDNyysWsbHMKbIz95v/UCLf98suX8ZjCFxUZ4QzdpZc3Oa/FYAirotFDNgigOTiHIEcGwN1RLROqwt7nQT8OE0TDHyVz4zuSbsZqxcasi5SOZCJLa9BWVcyqutfNxRSZ+Gp7Lner4n57b4WYbfzH/999D1nIfpt6dhmDVkv47WPbhHF212XJT58PObarX3+kFwidhlRGi8A2uMmIhNKp7LTyiyDIKJRuwOhCk3ShFMIaHL+ZdncQ68krciLXuNuj0CbZTzGbMO6IJzyoQ62UyFJ5I8QBLNTNlHgJ3xqVXs4PXTvT1sNCihC9ARvBSnGg3EtES11s2vQ+kI2HXrvHmEGO+7Uq/NdVjkhtKlniNv5ByMOnXfo3MT+pQK/eX2pVsagCvRQJXCbLbmtqAMzpHsK9NvVhuKbkvVz7oqwnIXJ144RYVmbwLhDvFX8XrHlLmSKUkcX4mKH1BMx10nK/Xuaoz8Y26xoQTee90Cu8+/sDBrfdze/8ydCzGsPx3aMbUEZzYwV++mqmR5cLnsONRHj/NWWLW+BySOtWeDAFDR/2rcUjaCZ9TQMNmJ0KghvlnHsTUIeZg5Sj2DIXC6S2AhVTdctvHpBpbsmzocdC+bk02tQDMwki41sxX0c2+2KTP+IyaijRsNpzeS1yKMqPkyeY/bQVLFPgR/RIp3I8pczz2bU7oMFktD+fWkJfkV0
 8hhXyvyt
 qc/e+ZGtfNGG97JLUHyWfAWyzu9nJrRh2GPaapSJ2XEx3s9QOHdBke+yWMULrPGd4peOn5hXB0v81Zdx8kdo8HQ+A4w458QpGeyoSIV1mZ0OapsQoC2Mvi83WiAEygd8+RjPyTIh0t+/3ywS85VNw0k5YtzMng7GePyUsEeEv+tTP4k+DVaWtrz43Z7inJunIVrBCGT3+Zup6371xgKpFFSKIrlqDpNfLPfJ1SM+hH/ZHh7RgX7qlqfg1mYNb8l4Urauiob9KLQ8zRglzCVNWcbWYRvMZ2x19fceXW6oXHzGxzKVHGEgAe4SXQZ86QFXUE6Go7hg5EU+7+GLCJ94RGJNWpfF33OBvYG62ssnOKdU0F4NO4Ma4YucXPdTMTTVabFRP8pd//2T6kCU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 06:57:50AM -0700, Breno Leitao wrote:
> vmstat_update uses round_jiffies_relative() when re-queuing itself,
> which aligns all CPUs' timers to the same second boundary.  When many
> CPUs have pending PCP pages to drain, they all call decay_pcp_high() ->
> free_pcppages_bulk() simultaneously, serializing on zone->lock and
> hitting contention.
> 
> Introduce vmstat_spread_delay() which distributes each CPU's
> vmstat_update evenly across the stat interval instead of aligning them.

Nice idea.

> This does not increase the number of timer interrupts — each CPU still
> fires once per interval. The timers are simply staggered rather than
> aligned. Additionally, vmstat_work is DEFERRABLE_WORK, so it does not
> wake idle CPUs regardless of scheduling; the spread only affects CPUs
> that are already active
> 
> `perf lock contention` shows 7.5x reduction in zone->lock contention
> (872 -> 117 contentions, 199ms -> 81ms total wait) on a 72-CPU aarch64
> system under memory pressure.

Wow. That's huge improvement.

> 
> Tested on a 72-CPU aarch64 system using stress-ng --vm to generate
> memory allocation bursts.  Lock contention was measured with:
> 
>   perf lock contention -a -b -S free_pcppages_bulk
> 
> Results with KASAN enabled:
> 
>   free_pcppages_bulk contention (KASAN):
>   +--------------+----------+----------+
>   | Metric       | No fix   | With fix |
>   +--------------+----------+----------+
>   | Contentions  |      872 |      117 |
>   | Total wait   | 199.43ms | 80.76ms  |
>   | Max wait     |   4.19ms | 35.76ms  |
>   +--------------+----------+----------+
> 
> Results without KASAN:
> 
>   free_pcppages_bulk contention (no KASAN):
>   +--------------+----------+----------+
>   | Metric       | No fix   | With fix |
>   +--------------+----------+----------+
>   | Contentions  |      240 |      133 |
>   | Total wait   |  34.01ms | 24.61ms  |
>   | Max wait     |   965us  |  1.35ms  |
>   +--------------+----------+----------+
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

