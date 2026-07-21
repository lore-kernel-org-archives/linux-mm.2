Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BD6CC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25FCA6B0093; Tue, 21 Jul 2026 14:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236AF6B0095; Tue, 21 Jul 2026 14:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1272D6B0096; Tue, 21 Jul 2026 14:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA0866B0093
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:29:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D0D71A028A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:29:13 +0000 (UTC)
X-FDA: 85013620986.22.5B6E066
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BD1B540003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:29:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gp6XbFXo;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784658551;
	b=qNJRG1F/HUFU4dj51rLX3DTmNOhFdKZG/FDbvFpKuVFY4THdgweDBnYx5oVqnljlNEGMuJ
	iGli9HzBGutWI9uGItKWDj98afzITrKqVz34fsxPgSMSVnLbp+tkB430ZwL2rLjHbzw2Be
	HrZxHpQWEbstIzdipGs59+kHfbGep1M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gp6XbFXo;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784658551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBrZiyJnberI9b7VUjJupq60gfZ6LzSJ4B4JH6KDxtA=;
	b=Bn5vIfLeKCOrKZXa3n4IkMWj1/qNXBUKeOMxmZ6v/oyloBLCJAv4S8BZPpjE2s7GgIJlb0
	3lJoOeh2BG8h3xzICYpnsSZkthx40A20+MUm+/SbZjyy7lMxtzIl8nYlozPh+1ZeKUrLlh
	6kzqsWACH0q3mkW6eoBdh31aqpkai9E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ADCEA42A71;
	Tue, 21 Jul 2026 18:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF4B1F00A3A;
	Tue, 21 Jul 2026 18:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784658550;
	bh=UBrZiyJnberI9b7VUjJupq60gfZ6LzSJ4B4JH6KDxtA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gp6XbFXomuiNUL8/5g0E38L1hLDlFPRFvPMTTyCgWQBNTqqQLQuUB+s6pzz7agr14
	 N9pISFj7Aqysz4dxYykxm6/PcBMqwymPVydn8l5doP7dGw63rtDgY3J3w7+iCd2dwn
	 raQb1OGdk1t5E2yX8S2g00aPuPp2+6dZqqd0g44YDiwH+wxLAthEItWNbjsFl8dBHx
	 8BI1icWsPCV3f/3kezXi7WgT58OOGLnXYtGTnzmvJRW4iXX8nBTXgUYu30RCoNS6wF
	 fH2kWBuFqMBANpbmNVc+7cLE+ZwcY66ZqhCCT8XuyFNX3ZeC96jda4LJGcOYbRliLw
	 lxENtlBS6t0dQ==
Date: Tue, 21 Jul 2026 21:28:56 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-mm@kvack.org, Albert Ou <aou@eecs.berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
	x86@kernel.org, Dave Hansen <dave.hansen@intel.com>,
	Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH RFC 00/18] arch, mm: create a generic
 set_memory/change_page_attr core
Message-ID: <al-6aLMJONOMfW2v@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
 <20260721171943.GEal-qLx4p5YbocQNV@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721171943.GEal-qLx4p5YbocQNV@fat_crate.local>
X-Stat-Signature: 4g4swwai6n7oafwenm3pcpjxr69rkzo1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BD1B540003
X-Rspam-User: 
X-HE-Tag: 1784658551-97910
X-HE-Meta: U2FsdGVkX18g6HzkAuMQE/JwcaTSPpSQb1RuozpcN0M3INTF32KgLqaTTBAAtlK7ecBZxUbXtMfCPWG7YobzfD0sLm24sCbzquZI8wbm9WNjXHAQUG1C0MPt4/PDveAr56BeSQTPSshpVqhwoSBVveu5LHCjBvTgQ6LuGkGwS3yGdtcFK4+hvnwhjSAWIuIC2We5UyyPVYMtmZMh38yyg3e8oGl18GA2f6IbmDyfOJ72J6eIIeo9mxYW835j7+dbCPSmwvqDuUQhZ/Eek/NaqolJgGJdPOtdagr7llL1V3eElE5v3G+OUEiZs9RHGVo0lkoARsf2/Po/RFGSqJ4bdp2QOwZzBSEqCWJa7mngPOX/sThNNBeF6c9M4k+6aNMiBUDWgTrNoXCAup8GAW9HWafGvzw+Tu25Gmw5Jiw9Pn8UkKEoTHDxgzjpVi3url8Qxx8kqd3xvzjiQVVq2h0gb0OB5GM8+42IcT1ZwM8nUlKUFA1aDoQEgg+4qrMrSnshSTP7VPUrNCU8a9/a4Y2Ls78ojI01VECJdn2+J8cjcQ6Ftnk8hKoQUpYDyHPa4FyxoLI2PyesgTvRNl5r3mpEn8852r4hz80E9FOdZ2pgD9TDoySK8RWFx5WDpIFkVuvLqleVewpQqlg+xZCxKmMAyoI0vJ9gAuHZEUHj8f0DuNMcUHqp5AzGsejYk3IkSqkVgfYXJ5iLW5Rkr4NtmmJruSqw0IzLk8aH4POJ3T7kgc3ETiGRueABJgvUojwfb9kL+3J4m+CTWtot0T9/xtJFGTnnQl2HEUlYQUea/1Vqkdj5+CBUi4cd6naUbPHy6qE6YgYqNw1Evzrd/BQneqlUjHIeIbOAFFudLeTlCVkbOgM7WetU8g2JPz67FS0aj9N2xSakuhBGG1jR7dkm+mrYYWHWAYqDPlaHb0NHtyYceauObtIKMnOKjXZ5UjtVcDsRWkNWzKEYM5lcGG7uu+E
 96Nj1gYW
 9H2v4GPUH8FovGRKWYb9vclns47VNSbIrKsD7iSrRruv5wX3YFmpT+Hlj0l6FtxodvvaoSKdHcY7vAGFMKp63pLmRtiG0g637kn9lcbDjaePfyVEnS4B6gvZyJsgwnORQXbyVTpQpYU/k5s+ZO8oRFwnczwS9wrbbYQWNtLB7HNpjqGFA67VqyQTrkCN4S4MAOUIiHM/XwDOhKgIq/pPW9yf1hKhmAe5JDfpgEBUB3e7ycN9/Xxx9b8uac7kOytdqIqy8U36V3FLRVZvu7bCXGaYVqktcJIh1cg6qen2V8vUXtOxDgky2NbBqD4l7Ezhv/AFprrFyVw9X5YA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 10:19:43AM -0700, Borislav Petkov wrote:
> On Tue, Jul 21, 2026 at 07:23:23PM +0300, Mike Rapoport (Microsoft) wrote:
> > Currently there are 6 independent implementations for set_memory and
> > set_direct_map APIs.
> 
> So with all mm/x86/CPA patches flying around, can we first agree on which tree
> is going to collect everything?

I hope all the fixes flying around will be merged before I even get to v1 :)

In any case, I'm going to wait for the fixes to settle before posting this
not as RFC. Obviously, the code movement will include all the merged fixes
then.
 
> And if I want to review patches in that area, what am I applying it ontop?
> linux-next perhaps...

This set is on top of v7.2-rc1. It includes a patch Dave took to tip and one
fix from those flying around.
 
> Let's sort out the workflow first so that we don't get lost on fruitless bug
> chases and fingerpointing.

I'll take it via the memblock tree? ;-)

> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

-- 
Sincerely yours,
Mike.

