Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29D07C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 11:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 380226B0088; Thu,  6 Aug 2026 07:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357DA6B008A; Thu,  6 Aug 2026 07:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2203A6B0092; Thu,  6 Aug 2026 07:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0A626B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:49:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB0C21406F6
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:48:59 +0000 (UTC)
X-FDA: 85070673198.01.AD67911
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 02650180005
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:48:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ui9DV13V;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786016938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3z9hALdtszYjv3nQ9X0eCYQLP5osX66/8WnjWFmsgUY=;
	b=vlpsiqnVsjWs2PaIsoRWj55MDekafJ9ecj1DWPSbTq/XkMFCEOp/39oXAdw9e6JjelXlMW
	N11nqJQvmNf5+3FFH6yTg4ZV2XA+i6i7PkCgFTB7x7tBbLyA2V3H1C7tXUYOPWhp059PBq
	HldyLZQtUznaGj7aynyHbV6cJVeiFdU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786016938;
	b=IPATDUVlTv0nzga31I9G4RJPpYyQnPgVOIEp0f/iaDANmlRpTTR5huRK4ufsvtpvl4PiYk
	gnFecS6yasBzZ2tLc3DQz0F6vxXWTlT6k/GJkj4nhj3cfZhtKBobhaYjn6h3Vr0RD8ld8X
	aSZs599YRBt4765d+XqwiM0WoU8bOwE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ui9DV13V;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 221B340BA8;
	Thu,  6 Aug 2026 11:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E651F000E9;
	Thu,  6 Aug 2026 11:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786016937;
	bh=3z9hALdtszYjv3nQ9X0eCYQLP5osX66/8WnjWFmsgUY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ui9DV13VpFCqNW8mww2sLiYawA8CCjZHThoC2xD/dh4ygdQ8EpmoD0b8VIvKcHk6k
	 X9oevw7sRIK/Lf0RQWmnD+X/EPKFN1+9XftNV4jRr367BOmPupp6okdvgLw9mXddBv
	 EdzWEH7idKNWtBnNUFuuwbyZ8PmCmRfcvImVDLfNV5m755obmSei0oR4kGhpA8Z6DN
	 WdQpKVC0SRKNAoedu3cGK67X+evBvQIrs8FJ7lWvhoGTMbdUwqiEoTQ2ZJZYWsMLVs
	 4yueNqTJJD+qN5N1YnPblCSKbU1Lxhz8siDJJXk61TJwgoJhiAPxLko0KB/61l5rE9
	 7wzISa1DuEaNQ==
Message-ID: <201c2696-ff69-4c0c-8c38-de898798d21a@kernel.org>
Date: Thu, 6 Aug 2026 13:48:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/base, mm: move arch_numa.c to mm/
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Catalin Marinas <catalin.marinas@arm.com>, Danilo Krummrich
 <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, driver-core@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-riscv@lists.infradead.org
References: <20260806-arch-numa-v1-1-968ec128121e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260806-arch-numa-v1-1-968ec128121e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 02650180005
X-Stat-Signature: sgi84g9rd6rf4kds3d4ry79coboofbsb
X-HE-Tag: 1786016937-706790
X-HE-Meta: U2FsdGVkX19Tg0kx+PqRLV2E52zlTJl2K68jUBkUhsWEwIV7dgUjr4Xi20e1F4nGfqW4o58bjQm9OmQGlxbfETQmdY+B+sz2r5oo8Pgx6R5QCXvd/vzPjjpVTH3gaM3PVUSU6RQVg3ZgSWtJ+9YYZsdac1f4sRysStRAwwgirS+mxFbQulgawW/TgZPqLvPq6ii3Tipih6WlDRYx3Gr0p7nvAWdR3HPQD4y1tniP1HZp79OUySG7pm7WR/oRFDh0a4k0MXR6gxQhfLcuekDN9CLAcnwNqC42mhsq7c7j6UZEOmmJkPLkgQpNWgQbpU3bJbRw/zSrBQ+5+qNP+C5S1Uhzg7kpsbGqPVsLO3dUoWP4hCH+O79HxaiC5fGRo3C6kn6A6ZyNqkBbMRYvIWy8KCIbTGJAiZwpszSRTIm1HzNqjBTRMgRzU1/x9zAXcfrwi+BdizBpW1PFj7YIxrcNq1VFbeua2mz7D1yJyZqnbX8zTGm4XRHrjNbHtld1Lt81xrXlJyNyNUdVlieONGr80QQhTqWeky3BJwDFsA0b+0aXVmuTJ0wsTWsWIBWBHMpsLx2G4Xuj4N0WMwx7JzsykocUvaQAyrgRjBrbFKkVRIwS9lDR7iv6uAMWkuF+BMGU/UAnkxDZ/K5Ip1Najp6s2c0d5bU5sN4lUVF3dbltR/QcBjvFpy8I/2XNhQNEpAnxSCohznJm1I7nVEKj4+G4o7jhXxIbta02JSLpClRGUUUpKKlW3fkE2oAKgjLi1kJA/wfqGtpBUO6xXmP01EuICOqFUAfeMy+Hgi7sGL00PnSlQUXDmrHpO8rF7IBwSj30N8BlGC7xEPUm3C8gm5lS/obx55cZQ9SUXZbtFJBwD0W2Cc7s/PrYkYc+oCaLVVXsLb4JMMnf41vrQ23maxSjISyQR4Umy1Lbp0uop54tQi+Qi1qxDFKDKClJc89P/WDRfHnUIVW3xbvcuo8CCWA
 DcItmY3R
 FTAKEMXeA86ETc/PGG376QWkdklYQgePa8PCbnC9lJFSB7ogY9RuiogEyeK3c4akCAzfzfNL1Ot0PoMnQazY/OXQxey9r7yJAXQ5OX6IHxLLrhSn/mzyI01TriFuY16qvIpJqzdHc/djfFGLMYV+Sa4mQfd779sGCZaLumTKjjOiFGYWmsxf/xyBfX36A0GWOktIj1ozbSjpYFQZNLSxG4xcSrwGCle2rSUvF9AgT2mbAScrPAz0l1cqchx3S01Ej6rY5JOKdWgktn/CBChUQcUYIS6c8C3r10tUm0olIKNKEIRcr49c3+RAn8zfsxonxiPpy6EmDZ3YLv+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 08:58, Mike Rapoport (Microsoft) wrote:
> arch_numa.c implements boot time discovery and initialization of NUMA
> topology on architectures that select GENERIC_ARCH_NUMA (currently arm64
> and riscv).
> 
> Since this is step in the initialization of the memory management
> subsystem, it's logical to have arch_numa.c in mm/ alongside numa.c,
> numa_memblks.c and numa_emulation.c.
> 
> Move arch_numa.c to mm/ and add its F: entry to "MEMBLOCK AND MEMORY
> MANAGEMENT INITIALIZATION" in MAINTAINERS.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

