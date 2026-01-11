Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63BA1D2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 22:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1256E6B0088; Sun, 11 Jan 2026 17:36:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9426B0089; Sun, 11 Jan 2026 17:36:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF72E6B008A; Sun, 11 Jan 2026 17:36:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDE3E6B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 17:36:06 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66492161307
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 22:36:06 +0000 (UTC)
X-FDA: 84321142332.28.B5CE8F2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 49745100009
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 22:36:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DgDVv7+N;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768170965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=85a7PrT0zgtz96jS4pRWuysfpQ780Eq5/9sjyOwO120=;
	b=bYIXNYq4f9KkdxNzqeilo4Pz7zppxWF1keE8ABG8HDKHG3N6hj0s7pnK5gnT++fwJ7ljZl
	bfdvzFh1Fszo9tpNhruCUXVFSUUhWe1pUHsYu0GBnqiBE1w26zF2ovXRLOEAI584nzbNb1
	DU+VZBk9DCq+IzCFM+z3uVD7838iMqc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DgDVv7+N;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768170965; a=rsa-sha256;
	cv=none;
	b=Y4RG6SICd0GpQjasYAO/thpo+lU2r3s6V6Of77/aLrWMxuYkSg0M1QhY+IO8wksJKMtLPS
	nPTbFQlzRsy6MvhR01SXxpLTdbgH6T6fvQ2LqLvfndx53Jf88nTXTbZzqZph4AYs768l01
	xBxVHe3xlRXMTCZ8yHu/TsGHj+M8k/4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=85a7PrT0zgtz96jS4pRWuysfpQ780Eq5/9sjyOwO120=; b=DgDVv7+Nsz6PtaysJzaqZ6PHpD
	7eUBRGwOGYg9vHMBVIIPRyiBnuK76spGj3oXGGj4wyZX6r9oSGMmnZMYwWnWBiZ1rsCyNHXnn/f2D
	pG9odPnA+wDKBP7AaT6hVx/Qw9COSWSROCEpkSZ7f9xAUG3jNo3/Q8MyXGSwhueXWLlKS1h4mINFP
	tkajdWvGC1JmwhHglaEtAwZA+VRaFUNjOp0M1oggFAASNkZRm0WT5lB4Uyn7kVavnYAkCwaCqq7YL
	sz0+a7OdQLxR4KwcjKCIJTe2EekXRoEuSZH9JJPqycDT5s/znS4lx8ndXQg4tuCRgX8duH0UlsxPa
	j2NF+t2w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vf41z-00000002OPX-35go;
	Sun, 11 Jan 2026 22:35:31 +0000
Date: Sun, 11 Jan 2026 22:35:31 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Francois Dugast <francois.dugast@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alistair Popple <apopple@nvidia.com>, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-pci@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v4 1/7] mm/zone_device: Add order argument to folio_free
 callback
Message-ID: <aWQlsyIVVGpCvB3y@casper.infradead.org>
References: <20260111205820.830410-1-francois.dugast@intel.com>
 <20260111205820.830410-2-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260111205820.830410-2-francois.dugast@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 49745100009
X-Stat-Signature: ic1zuchwjmx6m5xefqz6x74yfxour3xg
X-HE-Tag: 1768170964-136885
X-HE-Meta: U2FsdGVkX18/L5ScrnqaqtPw+ByzpQ3fDX6gj8aay3thlC4gkP/57ZIttrszwWtD6oekB2iDRrPjN03DcchYOX4gKfYYDEtjKdyTeg+p9tC0zD0kvswxMurXPGoVDJwHsXZz/FFN2YvrWL+X6vKCur0xKU80gmtPi1skyKdnNMMq6ZU5v1wnk58ZYoVXcK1PMPqnbXJnMQBhprogTqyZtRtJjSDSc6GYwVsZryuyR+QlFlBLt4o5rYslGnE0vTWxV9b7fwfxaiaIF2h8yhvTVgaDnoXdcFA3vrXBBJCprM1z+o+Wg9WEpz/grk8+HbsMlkzJhLNCucNudx4O++HNb/GJIrrhGTvTDyeucqxAV4cekiVEjH7wsDKNsFFV60YkJUqB64o4xzDpiG6jukHg7cdWzsvkHDYGfUMmWWWRpiu09kDZjN4OiXaepylHtm2jPQMPfd6JA1zjpwmj1eP18A+qJmxUahZEhQUL3GU/Eovh1rujhlsurl9n7UhkFlt9z4Xex7Rqd+0lC7MB1IvtycjpKX5MMhFomY/JuMDRonk4P8Sk8BK3toAzjkYOF2H5WzsiaiYiP7gTn2WfhSJhWBho/eji2A7Gsa3aWQcqXyOOoJRR2ka0EJexsBb4uK6myapCENMwZTrEhWdSvvWAqcE+GQfNaAMMCDIbMcDbYBlUh1CddUrKCN6QapJzcxECCz0+AOF68cEL7K0MHnG+Ysr9g/BIMxsgr3bSqjUcpDqPj+YV/L/2/g/yLW6wVakNmoQhrw1R3vWdj0R+c77T6gQdQ8H2nEX4pe86nc5TkSPdNxfnvD9i1p1iraUhxukY7iYb9ekU7SHOn/e4EZlnOwTDLImCoE+/pHuRd8qnVvQBRW0BOu71B3hH1eyXQz/a8ovptWp3V4cBYH53+J5yMd6GgFpKG47ubAQ6pWcnk74FzMZlxq3CZPDGdcStdjrgiYyCe7FQbU6R9JA8WVT
 7m/CtzHg
 8lBFA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 11, 2026 at 09:55:40PM +0100, Francois Dugast wrote:
> The core MM splits the folio before calling folio_free, restoring the
> zone pages associated with the folio to an initialized state (e.g.,
> non-compound, pgmap valid, etc...). The order argument represents the
> folio’s order prior to the split which can be used driver side to know
> how many pages are being freed.

This really feels like the wrong way to fix this problem.

I think someone from the graphics side really needs to take the lead on
understanding what the MM is doing (both currently and in the future).
I'm happy to work with you, but it feels like there's a lot of churn right
now because there's a lot of people working on this without understanding
the MM side of things (and conversely, I don't think (m)any people on the
MM side really understand what graphics cards are trying to accomplish).

Who is that going to be?  I'm happy to get on the phone with someone.

