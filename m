Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7464ACAC5AA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 05:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3A88E000D; Thu, 25 Sep 2025 01:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3A88E0001; Thu, 25 Sep 2025 01:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92F38E000D; Thu, 25 Sep 2025 01:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98CBA8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:26:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29D6E1A02FD
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:26:47 +0000 (UTC)
X-FDA: 83926638054.12.BFAEEC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 68B1B100008
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:26:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TVj3KhY5;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758778005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vBujBdWsbGDcsrKMy5z5fPEqSKQofIDbcYcS9ANxyB0=;
	b=jLAz8BDkR1RrtwRD0b/k98J/UV5h0C3G9yaT2QxYNJdXXSrC5vmK88Fn2/auiz9JU3Fh50
	4kNbadA3f4ZKq3XFTBgbiWMZmR9aXqM9Oz3Wq9hVBmCR6IS0gI8QLzyNBnhRzjbQc1Q6kp
	u06WuQPkPV0VH+W3QS7aRFJ/AFPpkPE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758778005; a=rsa-sha256;
	cv=none;
	b=iPskTzyfIX/aevV4dsCQhz5g2G3WwjK360GC/gOOvl62yrQhtXy1jDm1xTG5s93h7Lgit2
	Jqqlzw9wX2F5no+nkziEK4NXPasy+ICRBAz+EPBUUtt4p2xE/rXAltNQln+fdztP6GrqWB
	Yt+BOHd77sMYvHe+ojNLMafdMOnAMGs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TVj3KhY5;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EEB6D43F35;
	Thu, 25 Sep 2025 05:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B14C4CEF4;
	Thu, 25 Sep 2025 05:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758778003;
	bh=BNRQR3uWduxmA/6u9Cv6/W8BxTysuUBqfh49YF/xNYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TVj3KhY5wukwzEiBt8uWRSzv7shISP8AtittLXXWK4MgDs1TJQV8RwdkT/F3DdmvD
	 p37uB4YVV1XeafMxoX7wAOAFJALpFX87iX0K8Dfdo0+WW9Uz3lvbS7yMR/vH9CwOoV
	 TmR2TxqZAmxy4H6MB72wHQq5vcQnVyVWXR1J9UtdHiRspEh1H/OrGQRZomKHxMd0G0
	 DxlIfVQDgdSRNOXQ9awsF+cnsSF7ZDZeMDMRUrbCOg/ZlJzI9rAEnYK+54oXLzJH6y
	 U1lCFDlB9Qrb5OPL6EytR3BVESAQ/Z4IO7VXTW4XLxoOC6Zudnh2akPkyc77goW9By
	 D17otkxhDaI4Q==
Date: Thu, 25 Sep 2025 08:26:18 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, pratyush@kernel.org,
	jasonmiu@google.com, graf@amazon.com, changyuanl@google.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 07/30] kho: add interfaces to unpreserve folios and
 physical memory ranges
Message-ID: <aNTSelHwg7mvs1KI@kernel.org>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-8-pasha.tatashin@soleen.com>
 <20250814132233.GB802098@nvidia.com>
 <aJ756q-wWJV37fMm@kernel.org>
 <20250818135509.GK802098@nvidia.com>
 <CA+CK2bDc+-R=EuGM2pU=Phq8Ui-8xsDm0ppH6yjNR0U_o4TMHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bDc+-R=EuGM2pU=Phq8Ui-8xsDm0ppH6yjNR0U_o4TMHg@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 68B1B100008
X-Stat-Signature: b77oc18s6ojssttxzq5t8147uoxjgqu9
X-Rspam-User: 
X-HE-Tag: 1758778005-186640
X-HE-Meta: U2FsdGVkX1+pc1iCu55hS/96jfrQ3P05wxOqA3Z/Q/mjsuK+1vnbKiVeQ8IsZykCieltDa/DreEruXQb3gHi6dKOEAi3fMeySkavYd5rF8G6/dt+0W5j6cwtaxqp1KE0oKG9z606zy9DT4E0g0TQNZ3Y7J6PBEucQ40otLLe4HAbygniIghbrvN46H1wMuFIaRy/LUaNxmuuUaRDfjVtojIwrBJHjh1p9VSrJaSAgYDfRyED+EhktTLEJHYtpaw0u8i/YHKzlDNWL9b6e7VwkmikmLpzw1aElZDi44Zp8Ue5NThh8wnqyC1mtlhlSaf2ALvdbUNjKrPjAg7k4+91rW6bvhhk8MJHLvpopcmOXllslv/PbCw8buAHJUdrDFVTKcfMHeCZPNvHSCW+S1Df8cRmhZZsrd5YIqkOWztVFZmU27xB/j1GgT60bE9g/Nyw3V4SzeePlhp6fSV9IBs8SIgRgvL5g9CZyOXMIFDBpMhBYSkvKZeF2x9bDOc+pNLLlIC5HgRQa7wb5ilW5TwqSgdS1b2YuQwaTDKJ2Cosg2VsxoNRTIzteWbUxlcMh3Pki4b0Nu3Ek9L8M1h51wDwIOPXYWV9CA0fc42GZ/nVcsDkaDVM897lXLYbTSS/ZZfaG+iZAfUu0bXmbxf+M9v9fFyeigFn2ax3DcjjlaR4Ux8khhSXQnmlQvPEsOFc29U6QqvzKl4tnc+9dM8YbPuQt8g7NewUzAKTuh9R8CGnDvDkg9O84UdqutWpTPy4cHTrXfGLYW68lD8qENoG+sw67Ti4Ezf95/WZSlC6J8kUZzGhiF87E6uEFPPDekEiENH3FkyRMkDFoZeLA09KrDIydE01G47WM7qirrFJIZQKGCU7HvGGzQyISBRNQ5I9agEW2La/QWJGuKy3C+ZC6Jty1ANhqqtw1hLf+mKaXTXrTUZdT9SyHH2ra7BWvVfb8+Q8H3PSNHgRg5k5NlOfZY0
 MgH6E1Mp
 Pdl38iT/YzkyIQfkVwTLHc4jnHWNVprpwqGHsVXBnko8CiXDlm9YuWHlxkWzTUcJtiohGpbhYuwKuMzCUobhkWeKGKUAKcPnqLO9n5Quj0PfXVnssgNAqALuASVb9bY9tARa0Vy/f+1rSbK/ixhp5/TXyxMsgHEQs+5dMXhCtJArF7S67aYiCC9cgCBCbL3h61K8NGmpuI8IJuBhdq74+9hYlsYcYVP1vPXALRQrOtQSOf0WOk8v7oaU9PQ+M8KrSuhWaN7VIBCgBi9pQfxDGoDsRolPRODCQsOyeYWZ8HomBuNxirWmKevMubMgfIPilbB/NqpAd6t3A4C34xSM5pHXVFHTMzB1mDkdKsgNlBf536INmUjTiKRJOZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 21, 2025 at 06:20:50PM -0400, Pasha Tatashin wrote:
> On Mon, Aug 18, 2025 at 9:55 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Fri, Aug 15, 2025 at 12:12:10PM +0300, Mike Rapoport wrote:
> > > > Which is perhaps another comment, if this __get_free_pages() is going
> > > > to be a common pattern (and I guess it will be) then the API should be
> > > > streamlined alot more:
> > > >
> > > >  void *kho_alloc_preserved_memory(gfp, size);
> > > >  void kho_free_preserved_memory(void *);
> > >
> > > This looks backwards to me. KHO should not deal with memory allocation,
> > > it's responsibility to preserve/restore memory objects it supports.
> >
> > Then maybe those are luo_ helpers
> >
> > But having users open code __get_free_pages() and convert to/from
> > struct page, phys, etc is not a great idea.
> 
> I added:
> 
> void *luo_contig_alloc_preserve(size_t size);
> void luo_contig_free_unpreserve(void *mem, size_t size);

Why not add them to KHO?
 
> Allocate contiguous, zeroed, and preserved memory.
> 
> Pasha

-- 
Sincerely yours,
Mike.

