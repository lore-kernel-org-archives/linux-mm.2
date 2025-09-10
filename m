Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB16ACAC58C
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 515878E0016; Wed, 10 Sep 2025 01:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EBB08E0001; Wed, 10 Sep 2025 01:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428EA8E0016; Wed, 10 Sep 2025 01:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2718E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:26:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF9C7C06F8
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:26:26 +0000 (UTC)
X-FDA: 83872205172.21.F2EB3E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2B6A240004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:26:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W3++ctIi;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757481985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nCgLh808zcItteVMXL9jaLEwx6dqzX8VyNuK8FSQYGc=;
	b=amShv7phER+5lV/DuiPDP2d5ZpFR7n5kieXnzrLyQiKZEXYZKvDRlbDw5n2DBE7jOKX0qC
	2xC7GP4Cn2c28L3RcMdJrZk/f0rzGpnFCHX9cOgp0LNi/JTuaFYdyGx+3xnwLRpprLMIy9
	s1LaooiHMPE/UILjOq03Dx/GnDQNE8Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W3++ctIi;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757481985; a=rsa-sha256;
	cv=none;
	b=auzui5u++RufltCfITH2zlcfGlcIdjY1EJN8mWguXQklTs9HAptZNfPm4cmxvsQ2sNjTaK
	u4TeauVfKXK166wsdMsA46rDuHPkPmB59/YUcRem3AhkgTUs+m+1k3UK6SyOD7UBdFzSTX
	3Za/HDfPx2jiCrbwIf4KwsZZCiS2h7I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AFB3041752;
	Wed, 10 Sep 2025 05:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF34CC4CEF0;
	Wed, 10 Sep 2025 05:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757481983;
	bh=bqpgnX0YeaX4gP4gTelyGSzbrLPxwuSSl4ugIJkeFPI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W3++ctIiiR7UFpzqM9AUidv9AQ1n3Dz1tKeZadPk/293ETffI9nRLBp7aQx9AFled
	 M5GCYM1B4a3jkkhLPVRESnUtwcqokI2ZK9ojJ1YPCMkJpjHT45Cl+QruyYKY3aGARs
	 FpovID2F5xbpoec1xDhgC6MFSHIrXsB7JTzFkx6nfm41N+Pm3w/y/LnuGSrU2VRkhJ
	 x7tt8kh1ACIrOtgalXRNyxNgQvord1Z8/t1JGvHRdIaRHxawPvJnDmdHHJxvC9RDqD
	 RQiYwqXBRXcawbcju2eKP99VtdepUl8ofw/258NbTAl3BVZxhNFXZSkWH5N4CtNQIn
	 DIZ8LyFL6amIQ==
Date: Wed, 10 Sep 2025 08:26:18 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@redhat.com>, iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>, kasan-dev@googlegroups.com,
	Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v6 03/16] dma-debug: refactor to use physical addresses
 for page mapping
Message-ID: <20250910052618.GH341237@unreal>
References: <cover.1757423202.git.leonro@nvidia.com>
 <56d1a6769b68dfcbf8b26a75a7329aeb8e3c3b6a.1757423202.git.leonro@nvidia.com>
 <20250909193748.GG341237@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909193748.GG341237@unreal>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2B6A240004
X-Stat-Signature: 31i6cnkwhggci5h5cytp1gq7r1zbkbww
X-HE-Tag: 1757481984-853237
X-HE-Meta: U2FsdGVkX1+3hxXXhSVD+djuuQYPydZihvFyMrWHCiLlmPJShijtHR8QZsEJ4csdVva+3H9mwsE+ExJOM754WLBbQu02ctycyCmFMmrxmqjq3NmD1mrec1nKOyozqY5jnRPPeuCalO0Xkdw4kNZz5mmmT2+wuaAxcOaFRVzXjHfPIE0HBUqcSSSwQvXxkaypa6/t99xRIp+Xlp+9fX5z+00L5lAOlubsmZeZxnoP/azjZTrePmCaiX0UGsc6Tt72NA7TP1qOvYbNEqZSuhZUpXcQxdvPjv4AjSyZyZPtpr1uaXC4C43lDrXB/xPsusoHmWq/RQjF3Lk8p+GhpTZwXwbIG3CMEfoasbtSEVRiDV7yLYDk21GJK+6qjsKOB+x0OAoYru9RAqmD+F9BBR6ydbMTQy6lFY8xJ9yBFA3Mrf4Rt8SUch9fYG7uiuDnsGPOs1kbxexbrGuHo8dQIi/0vPVyBcYdcTFht6qYgzAV74WZIVS5SXbbQqWrK8nPKeOD5NE7K/FxDEj5aEWaS29Pf7KW9VHR+zd8/HSJ3EBa3+b9PzSUkMeM7JN36syp9cNUlwBGdKvG5MJVrLG/OCvFbOBOaeYyJKxdOOPgjPWvXGnIRYXz3yb7G4oJnC3Ieud3j0oURJ++LlFjUAZGGkyAp8WootlkYF3Z7eVr2Q1lb94dhBoXoStcY9Zts+vMWo8ulQpaZZ90mNxs4J3BIjaA/4N+zH+hxgxCc0qTxAveJL2KjayR9b7cXPle1vZ+okN5G06UYayHXAZhfczMA+sqk0dVYhEdpMUZRBcfebZZtrh7t0dL3TkFpCiJjigr+xX3qM3gZctBYZEyUT6c1NZdm5uaoTCE2sLC23lNbeXX8LNymtPKauuqV9BCl8M7bFxea3EDvQwwddczzOdQLWRI0z6ZO3+G8X7Ma2ozYsxNEquuhcYL5+YIi4e5+1pu4H8OuJ1MAE3dRwevgvDoq5/
 DnQNArbt
 j4D5MqJpUbw4T5wWnOmxqfNzJ34ooIV2fKU+WJ0Vumj6axVfw+HdI9Fi2+GnI2dKNA8BvRSvWsr8OwjZTyHgUw7wLrvTyLpfzCceJmEPIQVmqsuT0cgOYkfwBcdC+E2f+JE5Pw1cIfH8w/qbzveN23KiPGkNZJ4e0utIccarxqylBAVwbXFi2koV6M6uTaB70cRZgBVUcIyilBTGb38m0XjnmjF6KEmcEa6LBBg+8ZxCS6jTjYigEfAidXX7yx1hEREQNrhLagjQIAavi4PZR+xoqdM5hlG+lAXxYPOrjvykfUYXmByAG5vkp/JcgSNeEa3dwQbIInT8DiPgU+0t+nvv+km1guKrqf+1/p4seFWUEGwiZe0yoiwq1UMYlFkQ18Dih
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 10:37:48PM +0300, Leon Romanovsky wrote:
> On Tue, Sep 09, 2025 at 04:27:31PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> 
> <...>
> 
> >  include/linux/page-flags.h         |  1 +
> 
> <...>
> 
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -614,6 +614,7 @@ FOLIO_FLAG(dropbehind, FOLIO_HEAD_PAGE)
> >   * available at this point.
> >   */
> >  #define PageHighMem(__p) is_highmem_idx(page_zonenum(__p))
> > +#define PhysHighMem(__p) (PageHighMem(phys_to_page(__p)))
> 
> This was a not so great idea to add PhysHighMem() because of "else"
> below which unfolds to maze of macros and automatically generated
> functions with "static inline int Page##uname ..." signature.
> 
> >  #define folio_test_highmem(__f)	is_highmem_idx(folio_zonenum(__f))
> >  #else
> >  PAGEFLAG_FALSE(HighMem, highmem)

After sleeping over it, the following hunk will help:

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index dfbc4ba86bba2..2a1f346178024 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -614,11 +614,11 @@ FOLIO_FLAG(dropbehind, FOLIO_HEAD_PAGE)
  * available at this point.
  */
 #define PageHighMem(__p) is_highmem_idx(page_zonenum(__p))
-#define PhysHighMem(__p) (PageHighMem(phys_to_page(__p)))
 #define folio_test_highmem(__f)        is_highmem_idx(folio_zonenum(__f))
 #else
 PAGEFLAG_FALSE(HighMem, highmem)
 #endif
+#define PhysHighMem(__p) (PageHighMem(phys_to_page(__p)))

 /* Does kmap_local_folio() only allow access to one page of the folio? */
 #ifdef CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP


> 
> Thanks
> 

