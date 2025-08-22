Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BCEBCA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63BBA440151; Fri, 22 Aug 2025 13:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6798E009D; Fri, 22 Aug 2025 13:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D543440151; Fri, 22 Aug 2025 13:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2BD8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:02:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03328160285
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:02:22 +0000 (UTC)
X-FDA: 83805011766.03.17403D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 58B54C0020
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:02:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X/RxlEh5";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755882141; a=rsa-sha256;
	cv=none;
	b=79QHtFNmLQsgAV8DQyn2SjArxqJzBT0JBRI/0DGzT4N04bG/PwRrNM0ybvjE+LjtJUB/vx
	dP7vijJ8LZYzP25K9fD1eaSnuhkaZuz6JlHYsxUqzD9udbCDSgfez+NP1cBiHRv6Fy5CTM
	tIocChcx9sCVX90DbQ+6Bwcxl0AcFS4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X/RxlEh5";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755882141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=772vGqxA65bz16ef3P0OZqzhHKKFfpAXON1zFoQmwHM=;
	b=d9ScS/9VNU9IYU7tqqQYz8i9L7aqWcHiNjkJ4R1TqwlT0KHc2LPS4M1jhxVb76IghTZgCo
	qADjJt9+2hInlorBsMMY2Gg1O4RA6x9R5H/ZRqSmuQReooNufOapJOWizyGr/VpYsFV8sj
	1jp3WkY8f8VNfwqbAulER9PYJ7lMosA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 64D49601E7;
	Fri, 22 Aug 2025 17:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EA9C4CEED;
	Fri, 22 Aug 2025 17:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755882140;
	bh=N43GnKy17u3pJmuxA0B+CvRzCGT4IjO9pWdh50KAxp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/RxlEh56SJyKzLLReKVy9zMR7Rn10sDZ2qGXdgaqLeUy++5vRLbAaO8F1sq4dW3A
	 FVPFAm1E1KDu+9/CVB8PArKdY0HRrXTU0L7mEy3QGm8oDmYlvLcPGrEnt/PdkJ5xtS
	 WPwGxZiqHYuwlyrYRxRwfpMchkAzSUix0wgYLGwYkH8uFDFTTyuMLp6fHc+1uXHfs8
	 s+X5+H1F8hdQ3OyIBGTgvD5OcC7RDayM3+Gr4vyGqAtfAsaEK49eudKcHbm56kC8gk
	 8jVNP2cdHpsMgjezsa0xbQw1c8LogFjCAJQgvfQ9Um93+KYDxx0kQzjtsDqYPIARCs
	 dvKAxgTXqd2AA==
From: SeongJae Park <sj@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 01/35] mm: stop making SPARSEMEM_VMEMMAP user-selectable
Date: Fri, 22 Aug 2025 10:02:17 -0700
Message-Id: <20250822170217.53169-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821200701.1329277-2-david@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 58B54C0020
X-Stat-Signature: 3kaou3k8se7fouib9eab33kr78757mbg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755882141-699416
X-HE-Meta: U2FsdGVkX18r5c8jffO7x22z+hHdk9PPQOMtRGm5eQGd0jNEpfd0e3rBk+TtEXykt/g8XKilsEOlH2G9tTmDUjZGZS4hi+kDv5fPv2o8c6J4fJWBt+yCKdH3f0tgmagYcjQCphqV9xaPocQ5kF2BZaeFvIa3I6hQe9cWUYcgkpp15tpL3DleVidUfqy0rV7HYGJ5Dm1JnG9zCIE1P9RvhSc389XWxXCqMxflNHG6fBlHhzkFEB4VYrPGH4c6RPoGz+9340N3GJu1HFh5opX9nu13egJccXPlG/qHtMNgF2q7+Ap97/PKqNg9OJcKJfNiIoHcCw0DdA5N18jzkVipDHR2GJaP61cOZ1AryPcXMpDeQTBIDKR9H0hT2MSbPqIkfCco9hvx2HNXJCFw9YLXywkwDQ+udFJ4F4csPMas2r2kt/3yRPqTXK4fYZ77sZVekHe69zKsZY9zjq5yWWQcbQSt3/3SC+0FOb2KwVFBRg7fj7jyiWPHJ/xe/Hsr1KcYxkXPVG0QQx8WT3YE8b7G48tsKHpJ7csc8vVqv8RvH2xfREfOemedCaeJPTV2vvJefLA6B1BilEliIDBDS5+OxUfXovywsRH4E9LBFTGjkaMUCQbC9qgIuvQqIfElHzFUPA/cjneBLbnKFW8KI4bTaEtdaHvZ0W2r9oOvqrfryFPOGtuxxA1BcjLYhotyr4VzpsIfR7JnYLjltxZ8xZN9prVO5HJ7qa247xTKCGNR1uV2tdf8BSk+2O+wuT+iZ/SYagpRmONKIb6Y/GKM47mJSZzc7MH0UtckJ1RX0u0zvW2YfoefyCoQHoneDHAp2ZWIrVY0BGmPC5Hx69mreg2v1PG4TKw3YAGrBs4be6NTtg7tO4RXdbB0MZUpCCwc/VA4klbpOM1OtPwvtZ6tlr0tc9XoxtzduXxswlmhlqFTLIa/MCfOWRu3uw0SPLkYccSmjo2qXkHCNo8/SpXHJt3
 UJE9m9K2
 j5vuRiFbdnafYlBNYjnmZXJFy504v0FOMiwrcy40FV+1L08CFxPTm8It3XXGuqFcX+GcqbSAAyEnbi5MZeGr9rXpZ3gf58GYtZ96hJJwQ/zAvObMaADrLT46Eejkuv0HuxRJgndrvu8Wwcf5Wi3m8NOS/NqutYSF0Jq7ppq4gE6ORH5XLHOd6H4hJOx8k4KPT/pfKNBnbAMT1GOophArT1/GDx2dnEanfbaI73ySwYvOdhJiJcVXM1AsSHxU6OlU0MntqoVkeHCR9+E2L/JNQ8QNTXSoBsLkJgD8vfjaNINg1OtA8/BK57pg3miZVv40UfuG8PnK/197cVZLag1b77VK0zTSyjt4aCnHU2yNikrbSTsw/CGetGpOYhuDGuze8MgazSZfQk2kYY5c0dooPUny7hYjGbbyf2tGmBp2lO+fwwAPQIn3bh7c91O2U0vjPpkwFfkibMMToalS1CnwhcHthLaVHxoiu9gudUCVrR5eVLMmCnrGilRcrRnhZkTQFt5+SXg4Mr1nDsH4EOIT2iQk2SvxSwl5l5/vJGsK1yYFAsrizbUg36VQ5hIiAHJKV812B3tnWifPGJtIqXLQqUKtiXKXMHS2NZ8m2IbCL05BT6C4fHrN4Das39ljH9L+PeFWmvW9qi0RHaS8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 22:06:27 +0200 David Hildenbrand <david@redhat.com> wrote:

> In an ideal world, we wouldn't have to deal with SPARSEMEM without
> SPARSEMEM_VMEMMAP, but in particular for 32bit SPARSEMEM_VMEMMAP is
> considered too costly and consequently not supported.
> 
> However, if an architecture does support SPARSEMEM with
> SPARSEMEM_VMEMMAP, let's forbid the user to disable VMEMMAP: just
> like we already do for arm64, s390 and x86.
> 
> So if SPARSEMEM_VMEMMAP is supported, don't allow to use SPARSEMEM without
> SPARSEMEM_VMEMMAP.
> 
> This implies that the option to not use SPARSEMEM_VMEMMAP will now be
> gone for loongarch, powerpc, riscv and sparc. All architectures only
> enable SPARSEMEM_VMEMMAP with 64bit support, so there should not really
> be a big downside to using the VMEMMAP (quite the contrary).
> 
> This is a preparation for not supporting
> 
> (1) folio sizes that exceed a single memory section
> (2) CMA allocations of non-contiguous page ranges
> 
> in SPARSEMEM without SPARSEMEM_VMEMMAP configs, whereby we
> want to limit possible impact as much as possible (e.g., gigantic hugetlb
> page allocations suddenly fails).
> 
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Paul Walmsley <paul.walmsley@sifive.com>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Cc: Alexandre Ghiti <alex@ghiti.fr>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Andreas Larsson <andreas@gaisler.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

