Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63A03CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 04:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE4CB6B008C; Tue,  2 Jun 2026 00:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95456B0480; Tue,  2 Jun 2026 00:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86626B048B; Tue,  2 Jun 2026 00:41:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A369E6B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:41:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C397120841
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:41:25 +0000 (UTC)
X-FDA: 84833723730.20.F61EDDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9EDC9C0004
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:41:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fVVCf76D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780375283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5iTAXR5bbzIxHxlJbNzCQ0CqrWCPbLprw+Rivi0AdWo=;
	b=M0gEYIBhXkdAqJkqTUfz/v9Gntb26V4znseVoUQbD29FSFLRWG3aukD7dh/FDOZO7++yRF
	dwvFRXYyaa/jR1p6famREg/wlbJKLj0d82QanfgMqqr70AOjMMn9t28/iw1krnS1dFDzXq
	a7rqMZCw0kCqBEHJLNQ5ANQ9DZhQ3lE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fVVCf76D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780375283;
	b=cyMvoDG9wgn5mG0J+KQbETwD1L9GDq/i5MQeMaPSjUu66neZC25W3kE4vRChLylXttC21E
	y34iYyoRBNRgq89zfjHAGUTmbus8JCViw78IQ7+v4iFZoU4Q8QsQC9264lNNeO4z78bArq
	QNpA3oFiLoTFJDldm2zdGcN3rMTqgHM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6D4E42A7B;
	Tue,  2 Jun 2026 04:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227081F00893;
	Tue,  2 Jun 2026 04:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780375282;
	bh=5iTAXR5bbzIxHxlJbNzCQ0CqrWCPbLprw+Rivi0AdWo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fVVCf76Dx7vvRtOjppgGy1UPYStuohI+uy9DWtC+LjMgaEMLbdvFewnh94OAL+CM2
	 pCOKO3Nnfhfp4QVVVFHJ7pGlC0pcRPQSBoK+8qI+lMS8vE1L9za9TMoAEhapGCyg9z
	 oSOX6UXAQ0qI8lZdcWzGnsDHIE/3SlXVTvbbZnLLGgJsb+q9w7gAY3CfUe/oXsaq3F
	 IKCnC0jDUA164OuR9mISVXoVORX5ONpBDuDwwi+L6+sBtk7/0MupCBLirVc0R3mesL
	 YLqI48YwygT3VSDU6XtM8NAwITqzxDNVTMAKliil4c0o+GhGmZTerIkNtW6sdsl3Fh
	 evYO5/MHJ+rmg==
Date: Tue, 2 Jun 2026 06:41:14 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>, WANG Xuerui <kernel@xen0n.name>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 1/5] mm/sparse-vmemmap: provide generic
 vmemmap_set_pmd() and vmemmap_check_pmd()
Message-ID: <ah5e6i8EfoLUnyn2@localhost.localdomain>
References: <20260601084845.3792171-1-songmuchun@bytedance.com>
 <20260601084845.3792171-2-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601084845.3792171-2-songmuchun@bytedance.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9EDC9C0004
X-Stat-Signature: tmcrffk1omz71u31rep48na97xqq9job
X-Rspam-User: 
X-HE-Tag: 1780375283-985723
X-HE-Meta: U2FsdGVkX18Pzf9qqUjcP8T4mnO+kzaF2Ipgxyg5fAUL5lCPGCiY7QWchjSCrnsyheIwmwAMgeOsP+CzwCqW94Lj3n2MOwO6WgvUUCZc1/d5WcjTJK/77B0x66yb7I9ht3Bh9wB3zQnwRAxGagmFjpGFjqYxPk42Q5VGUy40wsJKrW4lFApFM+4LsXbMXKwbHlZNKlGxwdGbbNLg8ez7yzZ7ZmLfQgaQ05c919cAOiil5ckHqhN2uhE3iEVqCx4OIbN9tL15KUbo6Ij2lfCd7txpSS/G7BE7rDDxaZH2bQG0MTaaKcIurkBimp1DervNJk5cI0Iox/Z66d/QfRR+w7TV4bQJnMAdAQ0zL52XjDE3gGPSPlj3iVOwXF1IzRy17384rIT33jhueYIBdYyTst/SF0pBo2rdqE0eNdlX7u0myNpBtr30P7Hq1kCpFkwjTds1JFnQQFNCCXwvyMelzawodubkYpUjpfvkLHm3WxRPujaEqjyW4Dg2hxt2vBGqF2Y1rnKg2m8HVndTIepdw6npawoxwTmcVfUg8GO2j657zaKmIaDIe/yPVbSvs5KekgQfOzW/EPvvIm1sHECR8bJSOoksiz3h/FazCcyj17Dw380/7lPPANt6uFn4tGmqhOuq/P5hRL0rCLliQ3Cyv1m70QTwwA3AMXMQaml90Iw2uBal5EnVt1hgY7UpwHojtkTIkdxOkNHQbOH/Ap8cnFupNO/kdCHx+C67GB2IOTnoJCEwH8H+UnXrCC5Vy1LSPqy0OGyAbqmh+5vELKAYmfdmnzJfFzinjAYnvVQFC1778huSewgok8bROBSp71kT0nMiN1haiwjS8DVFuuYyo4zpavcMiec58OT1vFB/0lcMbLOp92bkF9FjHug6hr34/xgQ5qcl8RfJLnM+qCnmafQMgKzI+64ohJcluakGHUmoNfQc4pbyaRT1Ez3FmVjcC9jSPKCMTMgitslS0Hk
 3Br9f25G
 qRa9lcxvK0Pv8WrioVsxF+ld5xXW0CMhi4+FoNtg65efzLguTy1aE20dDT73Av4h8KJCml0my5SQFZJHjX4LPq5ojZrWECxEJS6iWPe+2Op/sdttY9PxO4i+gkfOL/CG2YEYDwB0N9PdEEvSvvxZZMDZ07Z7dpF///B/5ca8OSsOwS8IWAuAlFKvOI1G8QrGr76GzBTHP52yesG7hds9xtxnK1vOhu04moEkaRXpur4/d+/M0E2lWjmvvdChmpZDL9D4DppVZLAPx9b0//fxJibBz3v9mOTXq1DOTfzZSqxz2QCT1TjuHM2EZ7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 04:48:40PM +0800, Muchun Song wrote:
> The two weak functions are currently no-ops on every architecture,
> forcing each platform that needs them to duplicate the same handful
> of lines.  Provide a generic implementation:
> 
> - vmemmap_set_pmd() simply sets a huge PMD with PAGE_KERNEL protection.
> 
> - vmemmap_check_pmd() verifies that the PMD is present and leaf,
>   then calls the existing vmemmap_verify() helper.
> 
> Architectures that need special handling can continue to override the
> weak symbols; everyone else gets the standard version for free.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

