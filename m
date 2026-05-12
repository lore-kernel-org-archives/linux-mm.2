Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BF7CCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 12:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F2F86B0088; Tue, 12 May 2026 08:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB8B6B008A; Tue, 12 May 2026 08:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1606B008C; Tue, 12 May 2026 08:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1D56B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:24:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28C131C035A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:24:41 +0000 (UTC)
X-FDA: 84758686362.24.366F482
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id A6184A0007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:24:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g7z+LwFD;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778588679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkERFJFgNaSiBv0/ONzO+vECV2sJagltjFgKYe7DnDE=;
	b=b1YMoFmnMtPFJkieRsBOpvhlPbhM7tENuIRsI6SHVjl4YE7C8NQ8OJPMNQ0W1kAg0paJEL
	jK75uFUothpQz8C06FRnp2yv10M5lgcHiJeGouPHsyme2kiZfH/rOEmB6sopp/xK44qq/2
	/TJf1S/aYbZUhQ9oumr03LVRZ00C6Gg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g7z+LwFD;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778588679; a=rsa-sha256;
	cv=none;
	b=7c/bABho3VbfTkd1PBi20ZS81GZDXzedS/E489BqZHFkFdx7N03iw+OKP6aI6EoUvLMiVj
	izl5sIzVWd6KmqSohgvbUcE8F4AhjQgL1b1sWG+UUtleMxhaEAOe/tlGPPncHXDuoYGNcd
	xTEZNdEnMSAoDyQu0acW6upuV4/xZyU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2801860103;
	Tue, 12 May 2026 12:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F89FC2BCB0;
	Tue, 12 May 2026 12:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778588678;
	bh=0WjgXT8uGEuv2OmAhZFIdCShmadqOYqNR6SLU3pqcUo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g7z+LwFD9uRctO+XZBIgnYJ1JJ1TTPeLlWf5Hc10oJb98KOnqA+Zp4d0LyZSi9YOO
	 U2Qi8Un2g4DRRRl93DQ2kIH8Tmf/j37D9ZNSxIIuIS1OFyYmN5Qa7FQgR0/K6/aGLD
	 eVpYga7N1it0KN/yvBYTY4lmwzjVg2AExltyCati9nb5BVDJyb+LvnBMySxEUJ3T+q
	 fUF1QLdqr1J4jqqL7IFpqmuCkIqopzqK7DVb36DMqmVeYxSAnZJIHjdJFPSbcTiP6A
	 Wh/szX5KLC+7Qu2kGogmtOOpyLqgYKooKW/qiEbz5iLBemBj1LCGOanRlXBpnOPKil
	 ZOifu5xNaODQg==
Date: Tue, 12 May 2026 15:24:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
	driver-core@lists.linux.dev, Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Danilo Krummrich <dakr@kernel.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Kees Cook <kees@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Donet Tom <donettom@linux.ibm.com>, muchun.song@linux.dev
Subject: Re: [PATCH v2] drivers/base/memory: make memory block get/put
 explicit
Message-ID: <agMb-fIGsOnUKxL6@kernel.org>
References: <20260512072635.3969576-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512072635.3969576-1-songmuchun@bytedance.com>
X-Stat-Signature: wy6pxfqq68n6okr1n5nc5toczunnq583
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A6184A0007
X-Rspam-User: 
X-HE-Tag: 1778588679-841474
X-HE-Meta: U2FsdGVkX1+2mXFTE3YBPc4gMHBlA2lP4oDdgERTpeUmiBcXRs9zV9RvYc/PLHdp7LvTqO99qKMnLHIrdhdWJdqikH3mSVZuQcbgE9rdyMXO5s81Q3evh6Gd9PsEgShnIAxn40+YfWw9VLsXpdngFaz0lOgp2SeXZbzSY/r3oSsG5sJWIbMEVUfpqOqJ87ZNqSeS00mwKwehfqfJHX3h4TMzGwFa6MG0PB82HMu7qV3gds8gTCQr9KwhG4dxhHi/iO38pQNAE3blaOubMRAXk9q2U0jF3jZUMvMz1G2pm7kAbAVVPNSigIfL4ASqmB5JxRHi2g+IeV6y//FWr6up8x03oCD6sZf0+JrblA4O7a+Wl66fbvIJmpisGpdzaem5o5AKc6VdCtHFSpSEh8+XGxDi1BjIyhIduNANqAfQOIypLJFeBDSR+xiuj0Zl6DBDsq8S71SY56a5McC6Qt5v3MGpwu8BLcT4KjbPGfgXEI9Ft/SiKuuhRAtXVOtlzf5vaKu1lOE67RrlzRkPICuPacBUIfxD3bBczIVAt3lfWgX/N8d3Lj0bk8lR5hmEnA9AZgbZcOMl4a3WfjeMMdfsnLpQV0yIsaQXFKLrpqf+U0oVknUCsI4oqafyhdirk3N3kQ8znKJURsFV+zaeZzJN5C4S2VAijDTbFhGxk/4b1Jbji1w2HYiaxbVIuurKTjWmCXG/6gzFEBCEQ+6+CBwMqN39leS1/z/dUPw5R/vOvQh0DA0ipG9fpbS8bShQWvSC0o0RntAUmmUJkTQuStNn4TmmQTMU/7+g0YE29JjtwvQ94j5SLASgHQwczUuEYmLUawmX8fxk67CLjAuMjSCKsugz/BHchAvH65524svfnvvqpFPrdRvXTuAk3R+gOiZbGydjctIVB/qQSBEqOTwlYRCl2UBNa6VPEYbIN14njDvR72LjqUx5IiJQVxQ47kW8T5jx4bX8GB9lU0unVGr
 00hy/r2c
 G1OuZQTcAXfo33U0ud2kTM9bJ1W02uO89RN6rsMyOnh4gV5P5hMqX0ETXrAfc3rqubfyFGwPyGsuidj/6gVint6VFR8PoxgTsPdPQk5/OmGNYMCPJkl8XUPZld9UC2/wshhq79yTzvG2MhPUN+aHzPb3Js1ajGOu7bzBP1TjEPdv/lRUhZGeqgFZoZmyDX7WGzQ5h4Qc1rp3dATvvFHastzlW4RYbtcLjsukmOPWmfEgM718D+eYxqaiNGIXfDnIpaYEPaqELDGHSsNi+uX7bnczQlFTYa7uTQPJELJmYDy6sPfdAupqsx39QPG2NASfa+rNJmP+ZVJ07ZYvocRfepElajq8AQK+0PxToMopOrsUz2GCAdzcoLAOcXlBme/d8TQl+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 03:26:35PM +0800, Muchun Song wrote:
> Rename the memory block lookup helper to make the acquired reference
> explicit, add memory_block_put() to wrap put_device(), remove
> find_memory_block(), and use memory_block_get() as the single block-id
> based lookup interface.
> 
> This makes it clearer to callers that a successful lookup holds a
> reference that must be dropped, reducing the chance of forgetting the
> matching put and leaking the memory block device reference.
> 
> Link: https://lore.kernel.org/linux-mm/7887915D-E598-42B3-9AFE-BFFBACE8DE2D@linux.dev/#t
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Tested-by: Donet Tom <donettom@linux.ibm.com>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> Changes in v2:
> - mention the removal of find_memory_block() in the commit message
> - drop the redundant extern from the memory_block_get() declaration
> ---
>  .../platforms/pseries/hotplug-memory.c        | 14 ++-----
>  drivers/base/memory.c                         | 38 +++++++------------
>  drivers/base/node.c                           |  4 +-
>  drivers/s390/char/sclp_mem.c                  | 17 ++++-----
>  include/linux/memory.h                        |  7 +++-
>  mm/memory_hotplug.c                           |  5 +--
>  6 files changed, 35 insertions(+), 50 deletions(-)

-- 
Sincerely yours,
Mike.

