Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B7C8EA4FC7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 14:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EC846B0005; Mon, 23 Feb 2026 09:52:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AD106B0089; Mon, 23 Feb 2026 09:52:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D00F6B008A; Mon, 23 Feb 2026 09:52:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1506B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:52:39 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E33DF1B49C6
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:52:38 +0000 (UTC)
X-FDA: 84476012796.21.3337E31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C89A5140010
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:52:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H4yqZFpa;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771858356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLdbReDbxTZEqTpfHTCbqUSCKin7Yq9lVC2Cf81jHIk=;
	b=d/UILK6HfxIcI4uarBhZpG1Lc6n194aPOKoMnZ6kFIGPP9jPQE1gjc/qTPDR0kquAHCBvN
	S+35gIk0Nb0AnQ8RCbB1OjZWickztBpFhNhonnv81dtSlG9uMvrfiMwkhl8Rr+4smwyVbq
	YP0MfkOAIQ8xnCEUnBFxex5JE2O+2+I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H4yqZFpa;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771858356; a=rsa-sha256;
	cv=none;
	b=PMD8xPTMfwBOd4uFppuuJCYJkOarIwgABLu5slijcQLhLrsneyqllWD2aA9yLI96o9IejM
	K3zEw3Vr2O4lNF9xQOdoFYbMQbF3kXr67tPdue0BT5+5DzDKTwPiUk9bT3AUZDprBByJ20
	UiQ/Q1RX4LZwXi30k74qui8bkB1OduU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ADF8A44472;
	Mon, 23 Feb 2026 14:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52FEC116D0;
	Mon, 23 Feb 2026 14:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771858354;
	bh=UVAFpGopAm1uHGWKPm+YTJ1SMuDgyk8tqHgCMtYq+7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H4yqZFpaipymBSDijM07NWYMUzRVMGQxKSvag/WbJsRZMXu8UPpkgdYVQDK+ZmOjS
	 CQe8IAiTjs7khPJ1nlJnmZSOB5h0jRhjgvVLZ5cGZVU1pOv8frRsiEDRpqtnmbplDy
	 Lht/XzygjzffCqWtbIO99oCnpuIBgrOWGynu0ZtOvDn7md9VbLqpMR7HcuGskaJCjA
	 yxdNAgpnjq1fiWvog+AgwOVgenVeAJZW480BSTugFXQmZOe/CPWEGoEVF8Qof2ybAg
	 C7pVZtKtiygDfIIXagz4qs+RaBRL6jUCnzS9rjZ1Fe+svcwKUAHOvDvuVzzk00arpC
	 G96e2vc5zIrpA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id D183DF4006C;
	Mon, 23 Feb 2026 09:52:32 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 23 Feb 2026 09:52:32 -0500
X-ME-Sender: <xms:sGmcaW8L9wvFHE9xaKhbeX8JgZt0lnMyi9ulvqIu-cRvaG3b6rt2pA>
    <xme:sGmcaaZSaG8I5M6m1GvoKUH4LaO8U4CEWh114E5A0nNudgyzuIUKncAqQ5T_e66G-
    NOslw5KSJB8Qo6MeB8VALGBCHzEytytGzyAA_Ljg2fxngRougTPbA>
X-ME-Received: <xmr:sGmcaXFiBkUGBA_xw9Nzg3RQQEQBYqkXKxm4WowbCJKYKx2umbWxPLKBfTn14w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvfeejhedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepheegpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehvsggrsghkrgesshhushgvrdgtiidprhgtphhtthhopegurghvihgusehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhn
    rdhorhhgpdhrtghpthhtohepmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprh
    gtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepuhhs
    rghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhrtghpthhtohepfhhvughlsehgoh
    hoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:sGmcab5PzpnO5klB-RmRGOlp75eh_0ZN1UWzu3rtxmVrF0HDL3Ytmg>
    <xmx:sGmcaQvF3MOs6LmVkT3fJrDl4ASxADJy5NxGaaSRi4g9Ae-_RJtIyw>
    <xmx:sGmcaVBPXnseaXteAEKPGybiYblNvylyKEz-quFqXS1vgYJFTwH0bQ>
    <xmx:sGmcaYv9MSdgZdgG3nnKOXXoxjbQ8gJUrE_GKyyzeQp8t6KF3Wop_A>
    <xmx:sGmcaRKthHvOALCnZzC9C5_ytVbe1T1h3tw12XeJuRFen4yWwxEa5du9>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Feb 2026 09:52:30 -0500 (EST)
Date: Mon, 23 Feb 2026 14:52:25 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
Subject: Re: [PATCHv6 08/17] mm: Make page_zonenum() use head page
Message-ID: <aZxn34ebvSKFCWth@thinkstation>
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-9-kas@kernel.org>
 <e5831f0b-88c5-4a20-82b3-6e5952388132@kernel.org>
 <aYnJCnE5vooLROnu@thinkstation>
 <6afd7334-82e8-4f87-8ed3-6448e89328c2@suse.cz>
 <aZL-7mpPT_S3Paon@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZL-7mpPT_S3Paon@thinkstation>
X-Stat-Signature: tc7gkykkp6rxsomcsq5tchh49btupoa5
X-Rspam-User: 
X-Rspamd-Queue-Id: C89A5140010
X-Rspamd-Server: rspam01
X-HE-Tag: 1771858355-867099
X-HE-Meta: U2FsdGVkX1+ovljKyOeOkikGng8MjxGeci0MlFC8Rw62tImo5DpnbHQN+oFxV3SGhcL4l75ZjsskYaDlNlR+yI86WVy1XeYG3vqvOVW8UKhc1tn8GbE5/2/OEfrrfECgXjWRNRi730WI5HSUGdvJUcuG6sZBYK324Tw0O2UdkwcUfl88z0Y/bLCqra19AvOFXWYRsPgEwCJVloT4svcPATpogrmYj5l/tOfmNATO3nauhBbAz9RLwjQj8blEt+FNvb4zsyINKA/BTfKhLEHM89tKD2ELl5+qkTph/ET1P0b3OYO0tBb9C9YDYrCTXDoFgegyPqAGMBsW8NJDhKlmUrlvBDLEipNyqANjsFSe+cNKvBtPEfzvqtDZ158vRMhBBIskwkaalxhIfkH41kAnimfnm0nzBZKDGm55Hqv9SceGAhzrZYHTJo2NkCtYzhZDIXjGI/CVNgDLH8ALHc5QeNM/2xrs2LYdMgGwnfYrP168WNxrRC0mbP7DbsREeEdDA/KmT1ENKZEstypBEei3sq0j8w/KXgY3DqZRXstwKraRw/HT0fWHbDyF3LGfC2rrQ87zI24DKBX19yhc1GCFqVpLMu/21ixEQEJBmCf1JSAijMVQtGL2JKEQwWesRDzyzVXihfvkBdXfQUXA3ziF9a8cfhX294FwgS6wxc7PybR18wM1p2ktV7az236uwILhyhz6PBD2aCz/nAP0ARRNjSF6dMceW5l/Rfs3S4r8cAonXr8SDlU0uy+Z7igCIEF+gKokizycWCYgHxfoz3/IvP8zhhhJsrkeEpkE7eSqBm8/biGrKcXOvfXovofEpMCGh2WzAZ4kBN4sFZcEZFzF7O/n0/YBaf7MBDyVft6fuRu9PAIZoxybIi36rUUx24X5EA/uH4OaK/iIR3QZLo4fIerdXim/qA3IHtH5mp9XPkwyOkgI6vpugYUcSjOjpkESupLAtdzl/0JVHoTDCAc
 D9YqEuSl
 jvYxDQDkqYOoCtNxfjWvsKe5ImDnMoR/+eHhGKQKOexcEOU+ZRqTE2/w4wjlc0YbAv7EFvQh4HWKcia4b+Shac2h8QpN6A6hMfFOW/+C9G7UJOsCa4yXI0JjbvchN38xAq+x68ZihNZ9t/YPR6oke6ehNgTd5URsiLt2HYByUMagcBseW2MUu/bBCnCj0RfwDDfZRQ1zGNxOzmwtnsD2bkhDoZ8ZISlXFQpD8TRaUnO3kBBb4/6+l5vD6DlqCw0CHqpNRelbL5Eu5oyhUGwlDoH9tGjJF0stKtDCXxcIXDJE5ZkjrjX4Z+H6R8uaecn9PS437GefQ7LoZzqUkxhijVrMoBKH0e4Wowll4FTEKgU1geqZZKZ7ugXuhdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 11:30:22AM +0000, Kiryl Shutsemau wrote:
> On Tue, Feb 10, 2026 at 04:57:55PM +0100, Vlastimil Babka wrote:
> > On 2/9/26 12:52, Kiryl Shutsemau wrote:
> > > On Thu, Feb 05, 2026 at 02:10:40PM +0100, David Hildenbrand (Arm) wrote:
> > >> On 2/2/26 16:56, Kiryl Shutsemau wrote:
> > >> > With the upcoming changes to HVO, a single page of tail struct pages
> > >> > will be shared across all huge pages of the same order on a node. Since
> > >> > huge pages on the same node may belong to different zones, the zone
> > >> > information stored in shared tail page flags would be incorrect.
> > >> > 
> > >> > Always fetch zone information from the head page, which has unique and
> > >> > correct zone flags for each compound page.
> > >> > 
> > >> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > >> > Acked-by: Zi Yan <ziy@nvidia.com>
> > >> > ---
> > >> >   include/linux/mmzone.h | 1 +
> > >> >   1 file changed, 1 insertion(+)
> > >> > 
> > >> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > >> > index be8ce40b5638..192143b5cdc0 100644
> > >> > --- a/include/linux/mmzone.h
> > >> > +++ b/include/linux/mmzone.h
> > >> > @@ -1219,6 +1219,7 @@ static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
> > >> >   static inline enum zone_type page_zonenum(const struct page *page)
> > >> >   {
> > >> > +	page = compound_head(page);
> > >> >   	return memdesc_zonenum(page->flags);
> > >> 
> > >> We end up calling page_zonenum() without holding a reference.
> > >> 
> > >> Given that _compound_head() does a READ_ONCE(), this should work even if we
> > >> see concurrent page freeing etc.
> > >> 
> > >> However, this change implies that we now perform a compound page lookup for
> > >> every PageHighMem() [meh], page_zone() [quite some users in the buddy,
> > >> including for pageblock access and page freeing].
> > >> 
> > >> That's a nasty compromise for making HVO better? :)
> > >> 
> > >> We should likely limit that special casing to kernels that really rquire it
> > >> (HVO).
> > > 
> > > I will add compound_info_has_mask() check.
> > 
> > Not thrilled by this indeed. Would it be a problem to have the shared tail
> > pages per node+zone instead of just per node?
> 
> I thought it would be overkill. It likely is going to be unused for most
> nodes. But sure, move it to per-zone.

I gave it a try, but stumbled on a problem.

We need to know the zone in hugetlb_vmemmap_init_early(), but zones are
not yet defined.

hugetlb_vmemmap_init_early() is called from within sparse_init(), but
span of zones is defined in free_area_init() after sparse_init().

Any ideas, how get past this? :/

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

