Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60E3EF45A08
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 18:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D9AE6B0092; Fri, 10 Apr 2026 14:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1EB6B0093; Fri, 10 Apr 2026 14:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED746B0095; Fri, 10 Apr 2026 14:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 605906B0092
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:19:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D98C11A061B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 18:19:42 +0000 (UTC)
X-FDA: 84643459404.14.E8121F0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 38B4540007
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 18:19:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vHnKeGLO;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775845181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ryyTHerE09ARrsMFF5Fvb7X1HQr89NsPb5qBnbY3n/Q=;
	b=alsenIEbvB/erbO0D+wUeL3KmuvnRa0/cLfJNb0LqEzK1GGmJkk6vRIrZWMKPl19heEmv2
	zWnfELPsURKvOYMSV91vwHhdqyR89jwDgmkj5gU6DIiCR6pC9G3q1IcIdyk+dN4IdfRG+O
	X3c+x5zzo1eZ7wKxVjb1p9XmIb0n3+Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775845181; a=rsa-sha256;
	cv=none;
	b=MEyMQdFgG+LmhFuraB7PWhxPgVXrgLVp0rf8bHm+JuTcgCGViM62Giw9sgNzsJljs8Zc2x
	lMNDTiSZHRToVtPD1ekSOuRsCUuePAN+0nXz+mLi1mAsIMjLRN13D3dkIKxLAw3uU5qtUF
	1s9mL05sQ/PUcSXrGZlBuFAk862tAGo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vHnKeGLO;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 687F847E0;
	Fri, 10 Apr 2026 11:19:34 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 883BA3F632;
	Fri, 10 Apr 2026 11:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775845180; bh=wswWxxzi+b+e63Bx29Kjg7d6BTWx3Z9Nz5swIjtgDRA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vHnKeGLObdFUaf8rjfTZjKYDlZJQDObsKUGnOfH7zl8i3+6jMZfRayrZsLLZNgTNi
	 G8xSZJNHssEubmeCoQWD8n/BAHe9gtEZ4r3r1qh6PIPRYd8urfc/JkeCZhZLmm0ioU
	 l1VMeSKcOsZFUhiopVi80bp9UKot3vz5nY0R6UIc=
Date: Fri, 10 Apr 2026 19:19:34 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Andrey Konovalov <andreyknvl@gmail.com>,
	Marco Elver <elver@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Peter Collingbourne <pcc@google.com>, Will Deacon <will@kernel.org>,
	Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v2 3/3] mm: skip KASAN tagging for page-allocated page
 tables
Message-ID: <adk_NtueSeq8BnOW@arm.com>
References: <20260324132631.482520-1-usama.anjum@arm.com>
 <20260324132631.482520-4-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324132631.482520-4-usama.anjum@arm.com>
X-Rspamd-Queue-Id: 38B4540007
X-Stat-Signature: okamg7jtts536zwi6wem373mobap7diw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775845181-886253
X-HE-Meta: U2FsdGVkX1+3jJlIp+Z/H/72Ia29OnbcoCM4o3owm5sd1FkkpxlkzqPchWzGjOj1XmWC1uvu/ryuKiZBMplB7AEHm5PU2zQ8LAw0edwIi5ItSAtj6dRBfc8iwll23YgIZvSpJkmt2u+cc/O00ZzWuzmge/XcKAIeUUSY4RljwE8j6w1ulBlDjfdgV6P2pAEXIZdsuIG/YSsUEZudK+2lnYqjXxMfBwcRZ1R75XT1qqNUYvuvQ1W5T5EVEv5VCKUF1DP5h0cd3EAKAwVUojijAK/xQa7Yt2rl7/Z+ZHd+VWbKg0cOMixTz4pZLtbsU+apeTm02z60/K/RPHOV88gBxbsPxgnNyEWXQyeb79tDNllCh0xY1npbLiFcv0HYnU3OlicNm4x3ZFlR/+UKrHV8YFoPMfUsLGZutN+lhNiqxnXA72DvfqHBKdvjGW/bust9kCNsobsOBqqzKD+XC7rENCkiTR94C+wsIG48DDi26+QmCQmpjlwaOQXkPsOztEmhd1e76xP2U8gg3Ms8UddFdH9sXdLbNbMrE5zKCokvA5UqEE28E/MyySZfubB6kImOP4RfozJxitNhH3MFNzf8/N6TN22RU/LDDOmAJ27VwTz9/VAFOKuyKbesQQEMnGNMIbgpkYegZhZiu0VusaC+zlWU8GIrr5c0ZL47d7piZOJXqqzXkM030s0x+I9VOJkesFiTpWI89KlnqWTZiMqbr9Y9sq0I2IwB8GQLx7AODj6lHibWVgI02G6lBpFitRfmZOhmKU58f7g10GMQY9e1PiC6LfSCS3GAz7jYTozkzJ3D31ABoJ1HpOXSeKKzbeOQ66fSKYvNhe4IZxVlH+ksdU/vo6dY8YW388Mo1/Y4JwfuRIDBWuydgIl/K721QZ2EKaV/tgn2MdCtuttSsQnU4vD3Vd5z0UKstglkj1125D3qFTyKNbcGzZ9CitLvvXczUiFibrL2Drckk9ZG5Rp
 n9Wzdnmj
 zAjbLMDkUcw/J9dfE8wwN4mgtg0HiUniMxR/2Tg9U/RU3ONF71B+2chVGCvvhI0DrrHeywI8jKO14UIUYXKqyVKlQmTLbgbSWu8w6cTPMIVcnZ89lWEi7kxyZiuEmPZFSbhMJhWIM0F/w9l919dvRGHCjenUaMSQ9FcdIgMtkZSG6B4UpcTcN9KYcehORuAX5CBknuuH8U7WP72mpaOCkIjuHHcjeWDVrG+MHSY9ZAsZXPMjRPPL8zs+lJLPWDE2Kmf/xmH1O068nLorePttTpKgJ2MjLermdTwYPQ2zNXetPvl+17lZYtdq8ONTV7cKysm8L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 01:26:29PM +0000, Muhammad Usama Anjum wrote:
> Page tables are always accessed via the linear mapping with a match-all
> tag, so HW-tag KASAN never checks them. For page-allocated tables (PTEs
> and PGDs etc), avoid the tag setup and poisoning overhead by using
> __GFP_SKIP_KASAN. SLUB-backed page tables are unchanged for now. (They
> aren't widely used and require more SLUB related skip logic. Leave it
> later.)
> 
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

