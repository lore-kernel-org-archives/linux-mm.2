Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C621F606A334
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YZ/IDAw5
Received: by kanga.kvack.org (Postfix)
	id DE70C6B00EF; Tue, 10 Nov 2026 07:45:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69FE6B05B0; Tue, 10 Nov 2026 07:45:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32636B05B2; Tue, 10 Nov 2026 07:45:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1EFA6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:45:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F499A0836
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:45:30 +0000 (UTC)
X-FDA: 85419180420.03.AA3FD51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0F480C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:45:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YZ/IDAw5";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794314729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SVZpaCs3v/sBrxut5K0oJJA2z/xOJJAdv8TBSqGnsnw=;
	b=XNpsXkYbYYxL/X3Hqhvm5TKttZv7JH6zm7B24VMSV3lOjRNgf1WdCUa/5gqLOSuviAS79J
	bxZx11p64LaVhxVgXFWjIypA+dbwSzFp1YN0GJBQeOPFq3eJRlI7vM2mHuZiRgTBqqUU5d
	uV2m1XnhMI9frbeipgxSnhIyOGOgMjI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YZ/IDAw5";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794314729;
	b=I9tPGKXAJA5NDXd8FOvvtGgl8wmyCmEDiLZf+AjkgvyY+5qxTvW35EuBMkKyaWznas7wde
	fyi1pF+tIdg1HJ9M5tQIl8ttxv5DLBiAwkR8aMp+QKPo990dhTmUcw3wmZvcsrSPNuZUKH
	yEZS99QVO/m+h2zYp+dhQcPGTlZ3YWo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 930EA63905;
	Tue, 10 Nov 2026 12:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF781F0089F;
	Tue, 10 Nov 2026 12:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794314728;
	bh=SVZpaCs3v/sBrxut5K0oJJA2z/xOJJAdv8TBSqGnsnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YZ/IDAw5kTQN8T16yrZOI/9JLS/BYMIEnaAYwEogjl1aOlG7sfGF3dLhC6PsdYlS9
	 EG3SB48+EZum9ANIUh09V6sJhvGXcU7WeyMuFeNETFZfnqoJQOO7B3eEwrFHm3+2np
	 XW4DfA/F6nxXvZ3byZ+jDzotl5+NhypIyEtYV5E2+bZGt/Aycjxd4RrAh9BbzFyx8X
	 mlI1I/AyolCp0EpsRQpu3UYUc9qXoab6fTonzR6MmuidTva3g/uFoCg+xKSoyHkRhM
	 wAuPHP4fD1OTuOoScAVH4cg6/ET3IxoFXgQzhRcEKzI0eYSzZ/rMcDFShiZBmt4dng
	 WOTUOQrVSZtlA==
Date: Tue, 10 Nov 2026 12:45:16 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 0/4] MAINTAINERS: remove my reviewerships, add CREDITS
 entry for THP
Message-ID: <avMRk95T26rsq4JK@gremlin>
References: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
 <avMKVYORkTQfdVB9@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avMKVYORkTQfdVB9@thinkstation>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0F480C0006
X-Stat-Signature: 3mgg4ppweknqhu3wognm6pt8uwhxgf1a
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794314728-833792
X-HE-Meta: U2FsdGVkX1/KdudfNKP9weLa37EZhvA5iXEFbe3e8iEiLNWunLLdx+OGwDnQny92UccAybwyZbB1d8I8ULqScQIIa9W8LKwi8JdFPB9c14f0Y4au2TKBDEtoLehFTXdqZrvT+r4vmje3DBAxzR8Cm1jbr22QWifY+3+cGMthsQtmen51/ZrBBaeIHhGbKAKgkiCPR8Ir3iNIa63yo+935g0pQa1DCpCePJH0GJ64b2hs4RGAQwMF+cqGkpeEEbA38caR+iip9H4SC7b2+r+HcwcCOHiL97YXhyFcLI3yUBcVO1mT3MrNPu1lAL1S701miiPk1ljhtsbPeC3rLm6TXNlnOgUdUvFiRqcQ+vuTxD3qGK5DUqpXvnQ+0vjgpW1wYoSXt35V3jQj0h3SnPdA0AtUVkHMdwrE+18zr91qcaTSw6n2Itl7t7Gn584+mi0Iquzh+fMlui55RIh8dP5njrHEEgTRzOhaNQzpNSnWSNVIdaRzOcsTwL0mEyFG6Ckv+P62OZlOg9wOtiHTvypTSjR92GwHb8Xl0106UznEqSoNGwdGOO/e0opRMMrCSlVwvBXXfTHXfDnlMo6GIqwSrn9Sqi0DqHPaMS44fRci4MzL06pZIAucjd5L8+0+8D55FhdxWMq+f6o4M7BNrhbmANN5MPMImVcqicLDuaVNptcmFtD6wAb1XATEP5yRbhUfvDPCUCmnBGAPgDTc4+rJWjQdtP2qy8lgjYraBmhGNvvsHrOgACDqJU8VC1ESN8QFP0fOTyaV+9UDtdsI1dbLbNmt6Ko5fMJFXwEJ8ISHNUZrk/OxGw9jkHhKRJq9S+IOjLimX4JqC7OdPXqBj4MpIEpwE6MJyQEkrKPpBR4uY3yi59/s/oeoiTTLOprtpdDG1GUxZPEFyqKxzPHWDnCvgjKW5lWckEl2ersbtpdRQ5w6wbwRixpLWWuYAwuXcz56ywVEEl0ikRwhgQyDbTZ
 3YiclDDO
 VWbUhN9BjF1j3zi0ygV5HaYujGWls0rNOeOasEisTbv/wyuA2Gh6WxOVNRbW0+F2appk4senChkyvvVqr0XJ/FQKAeo3APjspPX2j7mIgjIC/s/cn8nkb7t2699KRDw7UAO1rhAbjleJ/A6iqY5l5P832CPmOrgmBwJMt5uXijHQ6ih6RXK4ih2P6XSqJV3t6sufAFMiA1p83t4FCjfY+WU6llEAVnXrKxCFP9DaZDyX8neniSxB5HdNj3bd8NjML2BfzUMxX55OgXUhcTW33435vlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 12:14:18PM +0000, Kiryl Shutsemau wrote:
> On Tue, Nov 10, 2026 at 12:03:06PM +0000, Lorenzo Stoakes (ARM) wrote:
> > Given the current throughput in the kernel resulting from AI-generated
> > series, I unfortunately lack the bandwidth to generally be able to offer
> > review except in those areas I maintain.
>
> Oh. Sorry to hear this.

TBH I'm still likely to dive in here + there (just did in KSM :))

But want to do something about my inbox...

>
> Thank you for you job.
>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Thanks!


--
Cheers, Lorenzo

