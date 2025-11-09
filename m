Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A111CCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 06:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE1A8E0010; Sun,  9 Nov 2025 01:54:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62F08E0003; Sun,  9 Nov 2025 01:54:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29B68E0010; Sun,  9 Nov 2025 01:54:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE3358E0003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 01:54:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A2DE1608C6
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 06:54:23 +0000 (UTC)
X-FDA: 84090154806.20.2DEB7A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id C50CA40006
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 06:54:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g4DJE34b;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762671261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPWeKyzg8BB/Y/rh4nIrXhUKH7lPMvXxfiBvVBDK/oY=;
	b=HHV68C4wkuRA11yM4Gqkfvx1+r8cyGvIBS4pkgfY/xL+pOQcAkrsaThyaUV4dek5T/GKtg
	p4FQgzsYUhBHAI2dUtvxK85RSL1RbNO5/gCRy6ye0LDfx5sOBhjp7al4TS2u/efh2mDYUk
	dN1DiRDiw2xpvFCxQgs4cx5nUzYc6zU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g4DJE34b;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762671261; a=rsa-sha256;
	cv=none;
	b=AVHmkIchc578VBtlipRp0V1GqAC2PxK6uaYJUATrtfibOP/RlZTe1aEfu/Mr4D3kkO8RtY
	NwsEr+qvc5D7vgMBCPUKz9vMG4SUA6cnzh6U6EY21Oj5NvLebCmR71Oo3nxxULtFFP8WGf
	COKWjOdqdl1UsCI45UQGaFJpnZjZJIw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 20B55601B2;
	Sun,  9 Nov 2025 06:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835B6C16AAE;
	Sun,  9 Nov 2025 06:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762671260;
	bh=3JS1OgZ14RhHt06MEdgrfvg3N/fs6BGb/Kur+DRi2oE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g4DJE34bZXgLmGCl+bPOHU3/pMacEfW6fXeyFOj4KAAaKC8vgSxqmhz+nCX5IoYly
	 /q2t44l39jqUTuoxLwsvscAUEzf46VSW+s4sloJSKvEq4sXjoSVDyP2c0IlrEbS7DZ
	 NYyv0G5d11oSBi4aWzo2zt/Y6RJNASmKFpX3FofOhaoM9OdaMpQB6Xj4LgIgNsog65
	 VYms1n0QIYM83TSiIdy0LQSgaBugIOmbuNFmiJW/9psFhVjbnZwOTrCrqqzjzBZfCX
	 tmyXuwTYZiGPZ3IM++NLq6+haE6uqZmXREDw41mogiaVbRQD5rw8YfKV/k0Hzoz0kL
	 RVSa5hJth48Wg==
Date: Sun, 9 Nov 2025 08:54:12 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftest/mm: fix pointer comparison in mremap_test
Message-ID: <aRA6lEQmmrvmj2DX@kernel.org>
References: <20251106104917.39890-1-ankitkhushwaha.linux@gmail.com>
 <fc051006-5cb2-49e1-bb27-7839837439cd@kernel.org>
 <aQyOZ6eYng-IjxS_@fedora>
 <6e07949b-d86f-46d8-a68c-9717cfb26084@kernel.org>
 <20251107160855.58891ac6df6854a3b608185f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107160855.58891ac6df6854a3b608185f@linux-foundation.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C50CA40006
X-Stat-Signature: ynx4w13pcqsmazd7fnq4roi1d66jhwj6
X-Rspam-User: 
X-HE-Tag: 1762671261-399281
X-HE-Meta: U2FsdGVkX1/do8empntisLmIco5XgDJNWF7uA2VRgnaWqL6LwCayIko9kJuyhe7wQNdEs2SFnCgit2xX2OWOnYak/9s1156z78qRVhaMLfruSPmDGr0RnhorCxVfVSOaGupGzyNq6gzPFD1VBQ4bO3l02ARWUdd0UKlU9cIaLWMJc9FEWIYDSK64/yT7GwNm7lKWeTnKCN7fyiKE93lllQ1qEuIP+YxWUyAt9UiJr5IxDozneMxf+6L7NWHHZ3ZIjuj9avX3Nx3wlSw71J8uCJVn+uZhE0z/l9zZsi7u7x3Pc6bI3rK0dPjv+p0ztX23IbBwYW/Itl1j5Zh4d5gGnYZTuve4jfVVKuz/wPbfsftn0ZmLZSaSNUwaKJTJ5/lR4ZCnJ9QAQL8lKvnhwRx3lYlhqKh2JxaPW2T0T1wV/eQzDhUAJ139xtvSLWTUZAm0ujOxUspOkRgrk/JCsIjqyPCegLN0JZwTD7sYBjVLIQ8f8m63Ch+uUufLl5A2Xrz8DH59vUdCbYe7jBZ8CnfhKwk3VBtptGS2PcwbAKdnG+qdGsG8YeP8nsgTQ6qoZHxg+azYuPKJqvLT+kdgvI7oxYUhygHAI/Aa1kCQmcxAa7DRuhA54zzlBZhw+NjjkOP7DrANkHfcLJ3ndbxxKPWCgUbC+uED4uqBP3Yo4F28+jjYG92ppeMZN89TydkE0J0qSwlGMw2ZLIAA4dRviso1fOyp502r9JOqRsBpnFLFPKicb7AS0k1i+LwbNt4LPtNgrh/B+FW7sjvHU6s9Q7ERCPPOIQUAJIzTSyMN6rkrJMqDD2I5NGkzjhFGOAxtqn8utCPcp/HZ9MA0Q/vmV4JltAzLi12wkl0td9tevD6Bd4zbxhbunQP/ghrd4ujWvNCjK4PGeuKW/LmRJXnipUtF4+QSnCnSN38uWvk1B6qEOroOZ9+810eimV6btc9Kkhv+9CwoAXaQln0P4iamkUq
 SPFZMZOy
 HJLori05pqjDOU9z2r38zEhhj29GGnx3i8YCGlFxc5S5lZvLPEgSEfmsSSKyhP3/vXgQ5+ZcY6U1LrEfoeBu4hmk/WLvebxqki4WP2p1lpomhVqOXRsTTkUNiaeN7Due1/S7SKgB1T3WtYi6sm8EdsMdyYBNSoDJI6IrJMa3R54kSCsts/Jz5HzRAkIqVF5o1ITZwdJ4+bBnjaaxQ8j1nCBPqk7oL9uRQ52kP5AWJ/MdA2WdGUXXHKJ4X+gsI2bYRI0U6ZnR0MdoH3v5WH+Ng0P9jbqz8ke/viFk1xlsfAEHeS2SNDnHi5WUOMl1q0b7zraZ6BFn7OE//ho4sak+8cRzobg9But8dQuSzxJOe6UocyyCorUYnejAk+pUkKAvUSHPNpc4O9wmPEDM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(added Nathan for clang advice)

On Fri, Nov 07, 2025 at 04:08:55PM -0800, Andrew Morton wrote:
> On Fri, 7 Nov 2025 10:27:27 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
> 
> > On 06.11.25 13:02, Ankit Khushwaha wrote:
> > > On Thu, Nov 06, 2025 at 12:18:57PM +0100, David Hildenbrand (Red Hat) wrote:
> > >> On 06.11.25 11:49, Ankit Khushwaha wrote:
> > >>> Pointer arthemitic with 'void * addr' and 'unsigned long long dest_alignment'
> > >>> triggers following warning:
> > >>>
> > >>> mremap_test.c:1035:31: warning: pointer comparison always evaluates to
> > >>> false [-Wtautological-compare]
> > >>>    1035 |                 if (addr + c.dest_alignment < addr) {
> > >>>         |                                             ^
> > >>>
> > >>> typecasting 'addr' to 'unsigned long long' to fix pointer comparison.
> > >>
> > >> With which compiler are you seeing this?
> > > 
> > > Hi David,
> > > 
> > > clang version 20.1.8 (Fedora 20.1.8-4.fc42) raised this warning.
> > > 
> > > To reproduce:
> > > 	make -C tools/testing/selftests/mm CC=clang
> > 
> > Thanks, and thanks to Lorenzo for the details.
> > 
> > Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> 
> I must say, applying this would be an unhappy life event.
> 
> 	if (void* + ulong < void*)
> 
> makes perfect sense in a world which permits void* arithmetic (ie,
> ours).  So what the heck is clang doing??
> 
> If we do
> 
> 	void *addr2 = addr + c.dest_alignment;
> 	if (addr2 < addr)
> 		...
> 
> then which statement warns, and why?

-- 
Sincerely yours,
Mike.

