Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B74CEC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18B36B008C; Tue,  8 Sep 2026 07:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2406B0093; Tue,  8 Sep 2026 07:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69DB6B0095; Tue,  8 Sep 2026 07:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 901C36B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:21:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FA61A0534
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:21:06 +0000 (UTC)
X-FDA: 85190353332.25.733BCBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 62E462000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:21:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GrB21XYO;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788866464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IoqTyL+G5O6+fLL3cVLfgraMEyoqxgqBpPotfBdVQqw=;
	b=Ga5n1gmsBTaj04kWeHDXMupfmn8NUNu0qSgrfghFD5lYg6GNvrhuASIIxZzaQhrKSaU1O2
	2Co8caYoV10c1UQ2Kkdy5a4pLxKdqB+7MlELNHtbJ2S/qTfeJv9fTbjYbWSIrWDDvtM1pS
	4pWj8+BnGcntUxytjnh38mQYmPNfWaA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GrB21XYO;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788866464;
	b=5q9Vol3fsRdCx1DxB/1PjxZqCAw3hnydiwfyaUGKTp7fczUf0/XXqfbC+OCvT+tiL7LZ8e
	K6pnW7YX1NZSQxRjRvukgQMQ4ojF2Z3tayvfgFwnim/v4rEu7kOyym1W9rvAWLwx1QSrmj
	rgHqw7yY+gJHFZcgUCP3Z+rX9XygfaE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 46295404EE;
	Tue,  8 Sep 2026 11:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB5F1F00A3A;
	Tue,  8 Sep 2026 11:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788866463;
	bh=IoqTyL+G5O6+fLL3cVLfgraMEyoqxgqBpPotfBdVQqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GrB21XYOLGrBo6gxEF8O+VDQ8P6Z7IJTIEyPD1wG1Gw99Ip3jQphLMVskjjJ/q1Ia
	 NbKynFOkclfWFGjzL/ZGOj6A9B0MpoII6bIk2IMQMeQDRYFtKMRU9tUxJ1xQ8R6XhN
	 wy+hJ5Tgq+0qcKo/HXlbIKH3KURAlURNS462V+YZ3LJlrToDIY9DtyC4wV64/AhYYL
	 F15CVr74IcEypm11lfsqKgyCfH6d29iy96Wyv6dN/8FLMchUrk+YzXSYPL0GlxRixZ
	 hhPGyoW5IRAxaXfGXElFzqrAoW5JwJ8z3PYtqX0rXQUBb6XRR5zCWyXaB9s0M98V+f
	 qbnt/MWTQnd1Q==
Date: Tue, 8 Sep 2026 14:20:49 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Ghiti <alex@ghiti.fr>, Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Len Brown <lenb@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
	Will Deacon <will@kernel.org>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pm@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	loongarch@lists.linux.dev
Subject: Re: [PATCH v3 1/6] set_memory: add number of pages parameter to
 set_direct_map APIs
Message-ID: <ap_vkSK_efv7ab90@kernel.org>
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
 <20260903-execmem-set-vm-perms-v0-2-v3-1-949b64a9f755@kernel.org>
 <a98df077-3e97-4eea-8bfe-470bad9ff9e0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a98df077-3e97-4eea-8bfe-470bad9ff9e0@kernel.org>
X-Rspam-User: 
X-Stat-Signature: rh6da7yo496t3yagr7cq6oosjp5ouys1
X-Rspamd-Queue-Id: 62E462000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1788866464-758712
X-HE-Meta: U2FsdGVkX1/hENdMqfwf6SgXeVF/Y7nFKtNveyb5Z5rkcaEJiCuJrInZJ9FygWEb2/VRL3s/P5BFPPSEATqS9ZPOwJXG5/M9vJBq7I0EB6k2Es2O+UAzMf4CPV2NzRFqnpapXMoghuwGevccAL4QSntl8GFr+IV8oQQg+pftEu9FJ+um0t5UdF37HMugrI3l8G/PPP78PVnyV0jkuNqeL8x3X0QBtnhgetIKgrERLedAIl77IQCBPSuEgAGcBOTXusIRM1vg1xH1o1DAUcgmWonMreSCdtwSggtedPVlSH+zSSFc4kFNnqWm8o1Q93pDqBCPm2NqicNEs682ay1jVfA4ko2iU6n0qNxxRGjQdsVRLHM++K7cCmK3zSdWJUrLGy97eB5rtnRJuZkQ46C6CrAK2pioQkjca1SH5Rk7r5Uyi4sG0qgx/fFiA1Q7XXhoSNpEyxjauw+Le/tkNJUWXBUhmK2WPNXg2AKlAdz9Vla9aqh+aJ1RZkMLiEOsPi54/INc2SCej9/u3MK/8Y7/pC4QWVdwpGBLmj3vTzgiH+Ks6gURW2nTPtCZ8rail6mGR4Bh7+GOGxyADEMl9YlqlxSYNCBRWx4UFMhz2smXiM04zGwTIZm26aXxGC6VaS9q/MT6GHXDu5Pz+O+7iH848eAkTybKkkpmQHtLV8ouzcNiJmjSOvty7xb5m/gJx3qxb+Lob6kpqlq7OtjMZkE2JMqtkE+sbNikw9qojDZF+Ro8bSIsg+WMqSMedcHr8PMKSiA0d8rVKD8FZnQL1dJS7H2wA2mHui1cvPPs4c+vSq+6x37mRCXSWTLvPcamk0b3VsHUNRSZABW+1R2DV4o8xQK7WSOjitpt4obZ+hBvsQ1Ybyxr7WXYJHgjZg8EXaLQHfTgeCzUILnorFCVHVe5M1K8EGjckT0V3TwpStEFqXkZZDnep3Omb+qzSMGdMdky0S5x1otO5Pj/aA5Ammr
 WAwyKlKW
 oTKJ7cl+MYoUn029N25Z+OukmWIagKy3Bm0DBxNuASeHCPQnZOGwpm4lvyVe2JpKMrf6JNjVTW7olVN7IvO4+ZyiXZdqJviIgtxo17Ru1VNeyCsw4LixVfegb04Gj53QabqZJMsV+bOZNwQour/H5t6Q4aXpT41VTsnKs6SVbnuRLIp3CQql3ZS+hdTehbTHZLFhG5tbMCi4NGeZ8y1tOxn37FCqSBp9uPhsF6Teab0XTSS0qmIfvTtz5l6z9zq86q1jS6g9AaAAIST94GKoNGOU78imPPo6YadnL48EW82MX64PIse5zleAwTFU7h4TRNUf5UhdCO2J0YEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 12:38:44PM +0200, David Hildenbrand (Arm) wrote:
> On 9/3/26 11:28, Mike Rapoport (Microsoft) wrote:
> > When set_direct_map APIs were introduced by the commit d253ca0c3865
> > ("x86/mm/cpa: Add set_direct_map_*() functions") the single page
> > parameter made sense because the initial callers (vmalloc and
> > hibernation) had sets of unsorted struct pages that required changes of
> > their mappings in the direct map.
> > 
> > Since there is an increasing demand for direct map manipulation and it
> > is also desirable to be able to update larger physically contiguous
> > mappings, for example an entire large folio, extend set_direct_map APIs
> > to receive number of pages parameter.
> > 
> > As there is still only a handful of callers, change the existing
> > functions directly and update all the call sites rather than adding
> > wrappers for single page case.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> In general, LGTM.
> 
> But regarding semantics, is it well defined what happens when an update fails
> halfway through an operation?

Just like other set_memory, it bails out in the middle if anything bad
happens.
 
> I'd assume such a case cannot currently get triggered, but there is no
> documentation on what's supported and what's not. Or is there?
> 
> Imagine someone performing an update on an area that partially spans two PMDs.
> While splitting and updating the first PMD could succeed, splitting the second
> PMD could fail. What would be the end result? Rollback? Does the caller have to
> clean up?

There is no rollback in any of set_memory implementations. It's up to the
callers to cleanup the mess afterwards.
 
> I'd appreciate if we could add proper documentation with expected semantics.

I believe it's more in the scope of  "arch, mm: create a generic
set_memory/change_page_attr core" [1] work than this patchset.

I can write (or maybe even slop ;) ) a doc about set_memory/set_direct_map,
but I wouldn't want to hold this because there's not set_memory
documentation.

[1] https://lore.kernel.org/all/20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

