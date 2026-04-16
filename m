Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F68F8A17B
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 13:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4D5A6B0005; Thu, 16 Apr 2026 09:49:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C244F6B0089; Thu, 16 Apr 2026 09:49:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3AAD6B008A; Thu, 16 Apr 2026 09:49:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A54F86B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:49:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D3A513BC19
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:49:27 +0000 (UTC)
X-FDA: 84664551174.04.BF035C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0569B14000F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:49:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="AqlOLz/H";
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776347365; a=rsa-sha256;
	cv=none;
	b=Mro1PezVIONM+hij/uC2/9fMz3et+oEJtACJaU6HnkAJVQ7XVjfgaMWobmiqNrIEdq+pqv
	qVROG203RjQZ97imTJFs9JsB23Lj6U2gUipMeozRZGqBvof27yjGUa+qx6BOBCFlIZlEjg
	5NM2bBv3H/w67L4vFVVMLxec0ckaudg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="AqlOLz/H";
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776347365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xtcoMO9jHtEP3yLE7/Y92txuSkxJiRIIoeq9mhml/sk=;
	b=4gK61dcTySG2k6OL8Q6bZ1Do5X5T5TqQIu76oJ3Dbk0r+UYmA4CnFrY6bGGH7aNcDaKBDx
	oEb03Ue3GmvsE/xoMrlzEOejLZsD14r0wQv76t5+WvksvFfs5plCif21DRiELYtGbtKrj7
	X82smJ/XjX6aO4BFu7dG99NL0GKtwRY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9120E43213;
	Thu, 16 Apr 2026 13:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4327C4AF09;
	Thu, 16 Apr 2026 13:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776347363;
	bh=s3RYvsEfI9ZdxhsabL5/svtqvt3W5lr9R3yghTmr/gA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AqlOLz/HXz7hqXJps/IG3FaK45yw4Z0YqpDgxczLEUlMgLP/IaXrmJbUuoShfRQLv
	 vftvKRCapRZ2NnHiAPar2EyWyd1TLgt1Ko3HP26W9UXE3KJe6nOTTqAu5ayiqwWDuc
	 XpRqOEFJHtFkpoOhcRVFGqeTGm9UPhn1W3sRBs3gJTk8qtriK2XhdZZeKMO8eAnMRX
	 RrWZK4z6KQSDAFWR9ri0eyK6s9sh+oS1BWmgHMXfV+x8F0JKGr4LT1pzYeU6dSS+QX
	 NTH+dc5QJnfsEaf5J7JTMdMnLxrBMEYV49XhLFbHvE6l6N4y5OIU6WW/oMpYggnVxf
	 X/zDR59vHkmWA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 10D1DF4006A;
	Thu, 16 Apr 2026 09:49:22 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 16 Apr 2026 09:49:22 -0400
X-ME-Sender: <xms:4ejgaSIYoDKvzxgPhCYw9DPRyWu3jwC0TpDUBp2Y_WPBEvYW4NkgmQ>
    <xme:4ejgaZZzLX6dOeyn967dwC6gkgLyv9vcgNA6uPCwoD_vHRVb7RcfCwDmoAjJ9YVqE
    08pcZZq3c1LOn1mJr8ufEayJfWseVOwMDmPX8U7mXRxDeX49F70Dak>
X-ME-Received: <xmr:4ejgae6P2292B6joISlFkUr1uSQIblLQ826adWwScn_jixogzy7A9WlfZMDvEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegjeduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgeehudelheevjefftdeuheegudfhieeutdegjedukeefffeugeevvefhteejuefh
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkh
    gvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeef
    iedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhr
    ghdprhgtphhtthhopehpvghtvghrgiesrhgvughhrghtrdgtohhmpdhrtghpthhtoheplh
    hjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepvh
    gsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgrmhdrhhhofihlvght
    thesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:4ejgaSJVJZNJGoZKWD6T5M5NCXLkDUW8HAqvk7UxjtI2XNWxSUR8Nw>
    <xmx:4ujgacZ3_iV3ApOrNQMeV55o3dk_kAFG7wtgo-r3D52O-xdB1xB3sg>
    <xmx:4ujgaSwCvAmjEpSOSI1Euf8uiFljZZ1F2wZxHEPu8tpaRo64t5cn4w>
    <xmx:4ujgaQV7QWSdaLPXVIHy_TozBtgAeyudvkqy14pgSHWIZEzajtLLfQ>
    <xmx:4ujgaeYmb7YFAUc8ewO2iFBH8S_30cSSVTvrTPJ_T_QqPAxdKtfbGI7L>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 16 Apr 2026 09:49:20 -0400 (EDT)
Date: Thu, 16 Apr 2026 14:49:14 +0100
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
Message-ID: <aeDoqFWPFxkkNB26@thinkstation>
References: <20260414142354.1465950-1-kas@kernel.org>
 <55019037-4f1c-4d9c-83ee-3a844d8f3d5e@kernel.org>
 <ad50rPOseVa-SP_s@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad50rPOseVa-SP_s@thinkstation>
X-Rspamd-Queue-Id: 0569B14000F
X-Stat-Signature: ioyhiita7f4xd4y3g9djiam9c1dg34f7
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776347364-513641
X-HE-Meta: U2FsdGVkX197wmdaBdkdw+m/aSHXqUItdO+TBHmSOYRtLBXmfLyYivanxWRETg5HZ40sf5XXR/8iI3SYb6b07tbu67z9UBxCH//3Erzhyym8oz7JEnPfK25Xy9G3dStlC1NMHrcqNptmHuIfZUOhZNvBj2Sb6MvTUUa5co2SIhLy/nIqNnPnsEty04f2ybpzsAAv5ERJ0Yiabyb/F6h5tUcFY0zfkPUfLEPmuEvcAv9WBU59ZhmYsAmJCiguq2G12WUPnUJnD8wF+oWZxTD0CQxw5D2sVuEEb3Fn+OQRigIxgJ5CpW8eoptWwhzTrn9VmaubWri7V2QR1E/x9e8ce78JH5jn9ZctT/pz/UtpyMYFOrrfQu478eXDy5PK+SB3/kl2zBQlQCL8isYg2idOaN3HP4r1GibdoDmchbyuXEVenqw1WbSvEQIn7qmBPDLLVRUtg/RBoyv3h7b70L91MYC0PzgzBX/6/jEFVd+N6cIK/okl+cwc9Gb2x9vdE0Z+QlRrB/lCOAo/rsfrjFpT08Xl1/KEkjRlfKLzNOKBevgks4eBrj1VB/f85T5eC4J4t9P7lBsiCx7cOlEFk0607LIEc4K2yypmDJHpL+NuHZGlxAQgjBt/VLuRV0vX9qWOQJKHy42Y2b6fmE4KSIGfoJXNDlzEE67ZV9in1SnS92UCEObgP+zzk0gqMKQWpYhrLXjY2DS8kB0+2FDZdU/EisCRDwo+1E+eGkQwhLyPZhMvdPahpH1tudAobShbW/o+AMGeGhUs0f2aQ3wdaQQSjf9CpsrJYvO8NSq1Ck25W3O9AUAQVbvuVT7298li/4wP7xrm/eXgPvJrN8cU7CxftwH+M/LY6m9PkG3WgvC8pjksDXH0YlSHws/+sgwxhaKQU8UEZjRYcSr8RUoIhbEa1K7WLkXjnvzt1SGbcF0sljCIltO/ANTOaGpassz9o8DJ2dHKD2O+6Gog8+XKeFQ
 Xak4gyBI
 Gq0VUfsW0PZceyNZEk/q2kIc1NTnQWU/cMvk4GLuAixtRR4Y6BQ9wMB/IKYnfjkDBFsKzRksr8O2F/3CozPycLZf64R8/bUarcRB31k95Uzu42ak9LVXdLOBvk84ho1ry1jmIHhQRxBsZoAy8i+j1hvq7XK58AvPebyB/Ak/5wWmDvFqfd3y8I0xzJfU8Mc8AFk9N1Dklz0us4jHsTU4RJwyaN8zgkDYgfTPOFwVns2BxQZHWmVHJ6Bzp35JNSCImow8AfK+GnVwlgboG5sp04VzV0PfIG0BV2r9Yr0sihbS2+c6PcCJ0/GAN7QrFwdQTcAxnPvKdUNnnSyg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 06:10:44PM +0100, Kiryl Shutsemau wrote:
> On Tue, Apr 14, 2026 at 05:37:50PM +0200, David Hildenbrand (Arm) wrote:
> > On 4/14/26 16:23, Kiryl Shutsemau (Meta) wrote:
> > > This series adds userfaultfd support for tracking the working set of
> > > VM guest memory, enabling VMMs to identify cold pages and evict them
> > > to tiered or remote storage.
> > > 
> > > == Problem ==
> > > 
> > > VMMs managing guest memory need to:
> > > 1. Track which pages are actively used (working set detection)
> > > 2. Safely evict cold pages to slower storage
> > > 3. Fetch pages back on demand when accessed again
> > > 
> > > For shmem-backed guest memory, working set tracking partially works
> > > today: MADV_DONTNEED zaps PTEs while pages stay in page cache, and
> > > re-access auto-resolves from cache. But safe eviction still requires
> > > synchronous fault interception to prevent data loss races.
> > > 
> > > For anonymous guest memory (needed for KSM cross-VM deduplication),
> > > there is no mechanism at all — clearing a PTE loses the page.
> > > 
> > > == Solution ==
> > > 
> > > The series introduces a unified userfaultfd interface that works
> > > across both anonymous and shmem-backed memory:
> > > 
> > > UFFD_FEATURE_MINOR_ANON: extends MODE_MINOR registration to anonymous
> > > private memory. Uses the PROT_NONE hinting mechanism (same as NUMA
> > > balancing) to make pages inaccessible without freeing them.
> > 
> > I would rather tackle this from the other direction: it's another form
> > of protection (like WP), not really a "minor" mode.
> > 
> > Could we add a UFFDIO_REGISTER_MODE_RWP (or however we would call it)
> > and support it for anon+shmem, avoiding the zapping for shmem completely?
> 
> I like this idea.
> 
> It should be functionally equivalent, but your interface idea fits
> better with the rest.
> 
> Thanks! Will give it a try.

Here is an updated version:

https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git/log/?h=uffd/rfc-v2

will post after -rc1 is tagged.

I like it more. It got substantially cleaner.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

