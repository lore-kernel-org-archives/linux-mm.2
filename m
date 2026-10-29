Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D5D5606A32F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 07:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aXDJX3+S
Received: by kanga.kvack.org (Postfix)
	id AAC4B6B05B1; Thu, 29 Oct 2026 03:03:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5CDA6B05B2; Thu, 29 Oct 2026 03:03:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94D0A6B05B3; Thu, 29 Oct 2026 03:03:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 79CFC6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:03:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 00AE8C0258
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:03:49 +0000 (UTC)
X-FDA: 85374773820.14.49CB7F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 685A6100006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:03:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aXDJX3+S;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793257428;
	b=KIko2XcJ7+EaMNAdzIeuOFvgQGvkS/7kk3bVtYg0Vm/nE4cNr06p1m0rHpgqwR4ZnprbxN
	SxESzfhEn0JQ+00Mb+pt3jQ/cnGaOaivu2d9UXN96V+5eV6xzUCVCM7iDQUjXuML1bR3Vp
	HNbOyizyoD6IfqG+nScIVgHCIUIVuT0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aXDJX3+S;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793257428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yl7DWqvy0CCg289e/p2GYHI3s+4vg6zhNzPzSHj/8eU=;
	b=D2w9rkC/8FKbh2oWacyzsFAOKiKnKwDQSAljMFqtNxI/vi0YiT2xvW09M0SfiMCzYTmR1y
	fYVFjsGcC5LjezlN+bNQHJLYl4oZXby7IdrfhgRwqdgfu4IApKimOclWjO5zsQm7+Up7QZ
	0zcUoJbQS0vrNT0Ap7J2Say5mDU0u98=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C680F60207;
	Thu, 29 Oct 2026 07:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86371F031EC;
	Thu, 29 Oct 2026 07:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793257427;
	bh=yl7DWqvy0CCg289e/p2GYHI3s+4vg6zhNzPzSHj/8eU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aXDJX3+S9WIGkm05gxDG+G7h6G9o1lZSrnw9kz6XyaMf8koBUlYtvUfzu1qHRZ6lb
	 WG1Xwz8z5yn7HZcnc1Oqd5EwZUfzFzd7B3AyrzdswWtVIbC/yGtzElHATIuW4X6vfF
	 QnvNdzTXm5FIk4QtITgIA/Ou4XrE7x7ydTOqixUsmjt5ZOFE9qu04vTB3GphMWSgFu
	 ugpg2oeWF4xklDA3WStjin0tc4jcUEBi+kT7f9WCnM1hvTDv274SvaZd209AH1SkTF
	 yhzciNJMM2g7i8aMhHeT9f0ULM/8icua8SuvmHAHXBxBj3riVaQ3Z2aD2v7vME9LeD
	 /bH8RVmr3dfbA==
Date: Thu, 29 Oct 2026 09:03:39 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Oscar Salvador <osalvador@suse.de>, Ira Weiny <iweiny@kernel.org>,
	Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev
Subject: Re: [PATCH 1/4] mm: generalize vmemmap remap architecture support
Message-ID: <auLvy-8djFBRadho@kernel.org>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-2-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903122128.12264-2-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 685A6100006
X-Stat-Signature: 4jndmczxinkibaxt7ustcgier3pwszat
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793257428-952006
X-HE-Meta: U2FsdGVkX1/yRiIYR1NVfU0gTQjD7M65WeUeQD24WxsFZ0RuR68gEavwOXqDK0UkAqZNX+vGIqiVoEdagrO/xdQzK6CR6KIxJRF6ZupsIPjjYpxbCOLVWXoGph3WHxEYp5EbCYgAG/M5vUgQw52qpmFaEepI6lpWZoTeXQUgidoduHCnrC4NthUuKTYlR3WFr06FL1OUip1M62JyKvSWmz73Kqt2CLNnb29BAXx3BYKr/6q8v/P4eSIIF4113RIrh2SYPi01aSW9dJTs2HsgpDvaATsfxhjmfkUx4DhfCNvmb0zmLhlVjxRCbGIq06bHG6VlR5yvHgoYDscQFJ0uJ/TI+nJSCvFh1tez8sq3aqRu71e4Ns/xrhbQMXOUxf5+SEiFx51YEwPRxA21d1/4QZYDiZT9Y2s2VbMlsYkzkJG7CJ7ORUxIfIRUPW5VCA3UpTxlxBkUp19v8dXa4HYRoqRItDRBf7MEcqJX+1wLPpizN1MJRmk82zIKQpWAqwRVs21CXuwmE7MCJiG0KjYsFwWLzOAR62mYRy+KGbCrpCkmkDob0oPrGecn/JXsf3XCbgaeQRLyi+ylSwYi9amc+2Fh39RwgPQFyb5NE4L5CT7V8NO7kAyevt248QbfP137yA84jZXbIW1khJZR3emMPATZKCki2N+MXRsvS8vCOiRS6XVRTKPPXQ6HdBW1EMBuLPirhc7aYimUmedEPXHxq/zjJ3KSIdKQcppZj0R2gfYRgieENd1vp02q0aZqBRzDRRK9GZyW+SK15+jMIrsn0N9nEvMmCGUPQNDWtA4unsUU+HS5vA5qOfz8FX+INZhpbHt3MM7VJeEf68HZmX/lEz+M3P8iKggd+8qzsf3aA3ZO6qH/nR6s6tZioNcSlAqR85/51v99u54oonXXxQWfrmzcpLaw23DSMwig/u6czslNFWhz+SJWGvSQsTL9XMX1dG0zToYov8CSkMDtuBN
 5fIG5DSU
 2DXqQ6YKiMJ4nMlgRj1m6vUeGULunKSxNr8RGJOTBHt4+VZBeJ0H0Z1gmWJwSEb/ssTUeuOD7ZB5ceCNUrcUYz1mOvh0TyzKT+bvdZiwhnL/eylzodP6IgRCfIsF9SD6EWVkEUnz4v4w3JjSoC44Gmwmaq6TcXcX4vxKpmCqV7EY15PfWE9dJOlTGXr/9+jWBHGYZc4aX+kSGmCnPCsPYhH6ToQbcon7UxxF59wG+x/S98Mjr0aLmZCvYfoQlvFoHGxP1PcahT3PrOBVgFoTWAYapXA6W0zMr5BA68Q2mbpNYZqk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Sep 03, 2026 at 08:21:24PM +0800, Muchun Song wrote:
> ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP is named after its first user, but
> the underlying requirement is not HugeTLB-specific. Generic MM only needs
> to know whether an architecture can safely remap populated vmemmap PTEs at
> run time.
> 
> Rename the architecture opt-in to ARCH_SUPPORTS_VMEMMAP_REMAP and make
> HugeTLB vmemmap optimization depend on that generic capability. This also
> prepares for FS-DAX vmemmap optimization, which relies on the same runtime
> remap support.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/loongarch/Kconfig | 2 +-
>  arch/riscv/Kconfig     | 2 +-
>  arch/x86/Kconfig       | 2 +-
>  fs/Kconfig             | 2 +-
>  mm/Kconfig             | 6 ++++--
>  5 files changed, 8 insertions(+), 6 deletions(-)

-- 
Sincerely yours,
Mike.

