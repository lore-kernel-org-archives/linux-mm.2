Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51C85CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CA2A8E0011; Thu, 28 Aug 2025 04:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A14D8E000B; Thu, 28 Aug 2025 04:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 890668E0011; Thu, 28 Aug 2025 04:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7651B8E000B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:37:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4215D13A574
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:37:58 +0000 (UTC)
X-FDA: 83825513436.29.34F13D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id AFE3014000F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:37:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u4Kv9tb0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756370276; a=rsa-sha256;
	cv=none;
	b=vLeeNSgs0/jq3GzWUR607i4xtd7CSKID3tac1GOCXbvYGoPcHZAaZ53IEkQnF3i69xChLo
	7RsrxaMY2Bl4R06iaQZ0i3btn+MD4jMRzttzEwmEwrpsJ1VosvRSfIMwFq1SbSU3pZ14RC
	qNAgAOGnCVT6gGkFGcGAXbv/AJWo0w8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u4Kv9tb0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756370276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qNeXcIbDUNVZCQgqMueGfXIPkpDwNju3n2hcsJpviO8=;
	b=CpIkWPdLuEV00J9Xb8nvNcfm+3xdBTLqpfkjK1RDgH8KHGAvVrTJ3vA/THgaq1hf+r2DQG
	xYbVy90wW7TIA77raxcyqNFYyI4pfQ+At6BsNYu9iIf3vGAoNLGR0zKEqkt4WzxwyJKGQV
	VbdIgDOJN7m1W12kkiASBHEIyDaY1rg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E943C601D3;
	Thu, 28 Aug 2025 08:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836CFC4CEEB;
	Thu, 28 Aug 2025 08:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756370275;
	bh=IVLnXXvrcuUFj2BZziSgUB2XoLuFxUupzbzqW/5G2yk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u4Kv9tb0W5HJY1z7Kha4RAxr/UDU+cy25InJtGEnO3JiyN+nbkHyw+9MpLitEOa5G
	 0pSV+hVfSXm9giRO4saHh0FNbPWIN8sA2oA/bVZ8ebErMJIoJf5LF4hfU+XC82WOgd
	 o5Dgh+w2lF46YEB0ubeKLXGmDFSIt276UaYMpIYsyodQH72bNpUaPHECThHiReLcwu
	 lbXv5EztKdkS391yu76bPtHOGB6uXK2NxrE3bcXs03h3uWTI0l2Znk0+rahaBHO1Pt
	 hHaVxoPeO8aKdT7uTaRf2Ck2cSXP3LlsqOYOEOuwJLFl7J5jwbm5nIR+gc/gZJcMeT
	 tq+aaMu2hoX5A==
Date: Thu, 28 Aug 2025 11:37:37 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 13/36] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
Message-ID: <aLAVUePBQuz9D89T@kernel.org>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-14-david@redhat.com>
 <aLADXP89cp6hAq0q@kernel.org>
 <377449bd-3c06-4a09-8647-e41354e64b30@redhat.com>
 <aLAN7xS4WQsN6Hpm@kernel.org>
 <6880f125-803d-4eea-88ac-b67fdcc5995d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6880f125-803d-4eea-88ac-b67fdcc5995d@redhat.com>
X-Rspamd-Queue-Id: AFE3014000F
X-Stat-Signature: bzeh8h7qrazrubxactrpze3p4ji1bwyd
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756370276-108754
X-HE-Meta: U2FsdGVkX1+dQWFuAv/r7JPS2f29pySU1RoaEel5he/QcTAcctJbdCoCeLhVkaRGVBd11l2mkTUEQMjp/x6ZE6ctObMu8XF0aTFWp2VjYDjLrVeLb4YtpoJB+4hWLIDvp33GmqwKm9iNP/sHGJEY4NhW4bh9c0OMwzOV/yai0qjcr21lil9DhNRslohQUVrruY5t2ewzbU+0z8rMgdMLNjjp0M8q6q1hH/Hpyn1FdnbvoyLEDazhQPcA3yRaOU7Wv+cUwntJVSHMdFqmRV6sqwY4DuBj/WkIxh7BfovfKl4l4D9IwKIW4eOeSiDTros/Jb4htzWpkvgOp21LN0Id8iMtpkVPxe281xA7dUusF6bvU+Jn1pGR1mSvcUbKmD0YnFIVPSqV1fbLXMi3GmgY6VzaZxqNJ1juVt2HvBILolMxUn6f6Lrqqfy0Ibm4jgsQuvNkM6n73r1nOHdJ9h00hZxpgkRcvrt2DBMrRxRYbpF7hHsxAB1V+eiP8AyuGvyraOsdA+lh5MdDbTb+Y8jDHgNe7pQ+kNAEB3m/EOs7z6q/2cDG/mx6RQxJKVI3NXDweYm6Tj45w7J1cGZ2NdGVWSkTz2JTUGi3eukAdop11Ge6qfZDtxlNIzDn0FcjLnYzkV+Ibd/7FcXxLppuOuS/m3rSkgkvw+9mC1rtd+ryDDPgOuXVkM/V7LTC8taOYj4OhvJHxa/xOubZJRogpChlhwSDCLeIjz0MCoyBr6wVH/N2rrE5My8DnUFc0b7IAQTaZsCLcAEeEI+gD/qgPIsL16HGsSEXRkItJ5SzKJn9vgXCb9mc7rbRVvwcH2siGDNm0PzlEAqQKqiBox8QWVI+1w/sJKx8x/EerSrbPhrCd68jNLzJcFS98vNCvZ4Y4WS1s1xNG15reUm21nn78bFR1wkduKPawsXgbnDFK2au/9wiiBvtxw4o8Eh7nYBXy91qCXVkqrExp7IyKxThgjv
 3/4xL9Wh
 xFUv1u1i6NvPBxgBQeB8BmH+IJOEEPLBX9mx3LQlda1ss81kHX0Xuh7Qj2GRd/gO65M2/g0zsh/rWgPnW1+ZPIB5MQvEEs30IGKAVcBPLzv5q197vMSYn+DJ9L4wFiUPe8ifm0Q+3MbRTPWEY6hFGMUSLjPCHZ1aeRV+RpFOmkDpDGj6WxJoe+zzkcHu947a71/Tcy9tJY+zMAjPxH+Wxunua9C4X0rFlN984kYEnuQlw9MkAHmAG34Zts+Ht0X1FGMCdPNk0DRbBnoBrony1FVDJoo+jsvH1BaOmJ4NrS2ChsAq1taA59xOT45WR47eZ5CAD84lUoRQ+z8o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 10:18:23AM +0200, David Hildenbrand wrote:
> On 28.08.25 10:06, Mike Rapoport wrote:
> > On Thu, Aug 28, 2025 at 09:44:27AM +0200, David Hildenbrand wrote:
> > > On 28.08.25 09:21, Mike Rapoport wrote:
> > > > On Thu, Aug 28, 2025 at 12:01:17AM +0200, David Hildenbrand wrote:
> > > > > +	/*
> > > > > +	 * We mark all tail pages with memblock_reserved_mark_noinit(),
> > > > > +	 * so these pages are completely uninitialized.
> > > > 
> > > >                                ^ not? ;-)
> > > 
> > > Can you elaborate?
> > 
> > Oh, sorry, I misread "uninitialized".
> > Still, I'd phrase it as
> > 
> > 	/*
> > 	 * We marked all tail pages with memblock_reserved_mark_noinit(),
> > 	 * so we must initialize them here.
> > 	 */
> 
> I prefer what I currently have, but thanks for the review.

No strong feelings, feel free to add

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

