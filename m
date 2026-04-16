Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 651F8F8D779
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 20:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B47396B008A; Thu, 16 Apr 2026 16:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1EE46B008C; Thu, 16 Apr 2026 16:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0DBE6B0092; Thu, 16 Apr 2026 16:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9B96B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 16:25:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56D03E4B0F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 20:25:29 +0000 (UTC)
X-FDA: 84665549178.08.CC1B16D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3E5DB10000A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 20:25:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AHR6wvMJ;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776371127; a=rsa-sha256;
	cv=none;
	b=ZE7Yf23rqH94uCMfmN6cWZeh+RXRiFZliTBaQtnDPFK8R0Lene6A8eE8TXcOSwePKdhMY0
	1grOo+AUjBRkU72IP40v5PKyBWqN6ZaivQPLeFFHPwzJKvfL1u3iLcILGqbJbqVM0V0yWh
	BM4z/CWfp/LnCnCmjar3QQMonFlB7jc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AHR6wvMJ;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776371127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IcD6l1qKTpam9b7gWdjdBbC6Yn+0cPLi5Hz3PG3F1vw=;
	b=uIoQh5//kH61LTdsEGDdV+gznw55jPwhTD3W+5btRa+LHJlz8cm8emAZ1j0L/7uskqj24v
	ps5qw/UFkzc2QBhRLxVmQLVv+KWcp30PiR3yP0xBLO9ynw4R44MsjXa0l6SEWZ2B+AYPQk
	w+Z1i1r+tDrORkLl2gaSaivLPcrExF4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F5FB40120;
	Thu, 16 Apr 2026 20:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B13C2BCB5;
	Thu, 16 Apr 2026 20:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776371126;
	bh=YuGyZSQWXwJBjPNCgqxfSOMDACX3rZbbFaPcf0aYw8g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AHR6wvMJSPQziXvXkRhq2b73yD39kZq7xOmRYPKBBJHyQCyjzW3a58ni5DbmGCU9y
	 faTQaZRae+k2FeGGwyULIzMYtauY/sqSrHFBP861J94RupvPyd1LsVdnbaCefbHYSu
	 U9o8DMuscsRo0V81GCEMLqarGAwRvan92kfBulq08DXw/j5lWXmCaA3p3a+BKzIQCs
	 PPSTsloFBjzQVIXNb0cKaUZ6FXmZN+eXtHtgJ5amp4HpZE92faZzB+5CgDbsHJopWI
	 Cz0+68dtBVMYDqnmMDfv80gr++e7iXQIzK0mhO2q5ofFMlbf0hCimcFD/Uuf+QwHwM
	 ehFk3mzRpSlrg==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id DB387F4006A;
	Thu, 16 Apr 2026 16:25:24 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 16 Apr 2026 16:25:24 -0400
X-ME-Sender: <xms:tEXhaRRjgnic9kXj4-ktDIZ8mxwigb8jHg90P2SdyP_0oHetYLFDkQ>
    <xme:tEXhaaDI9IHztK1haGXz6MAE6VXMXCUTSV3hvscQ2HtkH0U4eteDT3tDyQYyuCneB
    9V-EdrskKuQzgjToOGhs7XJlkhfteH9m0OC9bK5kt4Kkc3bY_Kr>
X-ME-Received: <xmr:tEXhaTDBWTM1AZiHj6lR-OxcHgzF3tZMT50MSVNcEsNu233_tYTr5Hspwb7eWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegjeelhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeffffekgeffjefgkedvjeeggedttdeljeekhffhudeiudfhiefgudeugffhheffuden
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvg
    hrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfeei
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhg
    pdhrtghpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgtphhtthhopehljh
    hssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopehvsg
    grsghkrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhirghmrdhhohiflhgvthht
    sehorhgrtghlvgdrtghomhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:tEXhaTya-dTGLZO7X9ydBulSk16fEfuIUebJmFUXbpajHv8TChFFlg>
    <xmx:tEXhadg_bSOFD8qQFOKcr-OI4jIhE-0ucPAuKHqmcr68YCpAyi6eSw>
    <xmx:tEXhadZdP4aWhcB2xoH8SmkZ0_21LgPTS4AKrj5HVIceDQhXXIOtvw>
    <xmx:tEXhaWc-QlnTGdPIQKO4bb8vboT9JwNHe7QTK6j2E-jGlj7oiAKAaA>
    <xmx:tEXhaaBjpNEaOlo31je-7SV9sXxnfs1dPMRsLHSevixVPKJU0nVjbN0j>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 16 Apr 2026 16:25:24 -0400 (EDT)
Date: Thu, 16 Apr 2026 21:25:23 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <aeFCuLJXT8VOkzH7@thinkstation>
References: <20260414142354.1465950-1-kas@kernel.org>
 <55019037-4f1c-4d9c-83ee-3a844d8f3d5e@kernel.org>
 <ad50rPOseVa-SP_s@thinkstation>
 <aeDoqFWPFxkkNB26@thinkstation>
 <1a499781-1115-44bc-adbf-2ac3769354ca@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a499781-1115-44bc-adbf-2ac3769354ca@kernel.org>
X-Rspamd-Queue-Id: 3E5DB10000A
X-Stat-Signature: n3pxxua5bu84mu6eenkmum4y6cprrc8m
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776371127-716454
X-HE-Meta: U2FsdGVkX1+5tPdjUJsH8fkCG/BQrSZnuqHf6OSarqoy8bqBlcGQNyQiQx9jkVIyvaP8bgLwhIDSvMTkmFvyCHwIBa7FseuwOOjZFJTdYJ01hanJ3Fzv/SAhCZ6N15EeFeBtiN7XPt0rfe7NIDMn3/fVhNTD/fLha8ydE5Qw4rUsdfRHyQa+Wim+K2WllIla8bV6RGoZUEaW4a12zziIcTBHdzGhRuHNoB3zJqIq49L2j0G0AZtk5O+mVj0kkmNWGc5/xIfvRFhJ6kPX8hVsE2e03Z1ZeNEY8+zbgrrZq3wTbAOnQjlVCkjPZe6+D2jY55+6WnVXUo9GiO4hSf9BPLR6oJ2sSxYKrkh1irKbU6prV6biDslefpcsm39a0bX9gbvXpTjaCPjsRYZj81UjsBTdLZVm1gwuebdCF87DxO3jbQ4EecJX0f3W47JX7XCUrLvVwOtMu1ufhAKW1jSwfPjhsCKuC6oQ9+PsXwgmZLaAk4JQfBY+FRK01148Eq3HseTf1GCejxfzzVS6osGE3n0ZDGotGhZdIvpmrbhoAAFzraSEpApj3YodK7nuZRMHSsHYIDykX4d7/C5UueWLIuIkOg665No98cPauwLxIOJjlayCzlHEJsRZpl/VIcVpbhwhmmuPrL3VQra2ux3uqLvR/Z6Cv3h7Ssr4e/S0T9jto4ZMcjED8NoL7g43k3JowuG6j7PnWyNIreV4xrKEr8orn+Z/B//HcbaozZEoWXt4OXs1gPae6McjAOk41NpvAujV4ARvSXiSEUX3xHAYEU9XQgatWQvWpob82vsoJHvO3igpYn/+CUprY1FQo+58X3kBx4C1odOPZvjnMbwgitFSHSNceuFohEHFJ30y87nA8ztVBNd+qrgGomBaPsHrS1TBURiQZEQJx7wzhxB3FzD6jIAn4xdJv/H4mc6bpD5sD9DSaYNSvjNWnWVCyx71aUvHP9eY0bcpCM2MpOn
 ek5v6gIg
 3orRsAhLQ01rWRogtA4F/piIE9+zxVT1ClJN2VMyz244rH5SGNa+3EN31KBKzjjxFT8SqS1L34MqWiHE9ARVsdsKeY9ijpVujdzIBP0RZmtW410th5MM1B2bpGxs7nnCVqbcN5RhMCm8Yx3TKAKZLxt1AeE8TQTWUgih2hzvoLbIxGJ8pYJfn6kvjSCfIIcfYrTuKiFlkde3QwxUHD5aa+M2Cz0J0wd3PaHKofs9o3fwENxsDq5KnG3gBom38hYvF0k5AWyd4DqE+HATowVVMXgoBDvvbI4jxQe1hkLHj0TLPOus=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 08:32:19PM +0200, David Hildenbrand (Arm) wrote:
> On 4/16/26 15:49, Kiryl Shutsemau wrote:
> > On Tue, Apr 14, 2026 at 06:10:44PM +0100, Kiryl Shutsemau wrote:
> >> On Tue, Apr 14, 2026 at 05:37:50PM +0200, David Hildenbrand (Arm) wrote:
> >>>
> >>> I would rather tackle this from the other direction: it's another form
> >>> of protection (like WP), not really a "minor" mode.
> >>>
> >>> Could we add a UFFDIO_REGISTER_MODE_RWP (or however we would call it)
> >>> and support it for anon+shmem, avoiding the zapping for shmem completely?
> >>
> >> I like this idea.
> >>
> >> It should be functionally equivalent, but your interface idea fits
> >> better with the rest.
> >>
> >> Thanks! Will give it a try.
> > 
> > Here is an updated version:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git/log/?h=uffd/rfc-v2
> > 
> > will post after -rc1 is tagged.
> > 
> > I like it more. It got substantially cleaner.
> 
> I don't have time to look into the details just yet, but my thinking was
> that
> 
> a) It would avoid the zap+refault

Yep.

> b) We could reuse the uffd-wp PTE bit + marker to indicate/remember the
>    protection, making it co-exist with NUMA hinting naturally.
> 
> b) obviously means that we cannot use uffd-wp and uffd-rwp at the same
> time in the same uffd area. I guess that should be acceptable for the
> use cases we you should have in mind?

I took a different path: I still use PROT_NONE PTEs, so it cannot
co-exist with NUMA balancing [fully], but WP + RWP should be fine. I
need to add a test for this.

I didn't give up on NUMA balancing completely. task_numa_fault() is
called on RWP fault. So it should help scheduler decisions somewhat.

I think an RWP user might want to use WP too.

Do you see this trade-off as reasonable?

> But I also haven't taken a closer look at this patch set, whether you
> would already be using a PTE bit somehow (I suspect not :) )

No. I didn't want to allocate a new bit or invent some arch-specific
trick for this. This functionality is available everywhere where
PAGE_NONE exists.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

