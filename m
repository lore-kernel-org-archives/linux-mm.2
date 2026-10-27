Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB98D606A327
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LX9oQFb3
Received: by kanga.kvack.org (Postfix)
	id CA1A16B0856; Tue, 27 Oct 2026 13:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C796A6B0857; Tue, 27 Oct 2026 13:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5F76B0858; Tue, 27 Oct 2026 13:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A13C6B0856
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:06:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A10A1207AB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:06:19 +0000 (UTC)
X-FDA: 85369034478.21.B349C4D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3B7FF40004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:06:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LX9oQFb3;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793120777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CIRKIW6FyjGByuy1vcj3Kaosm6T+AEo/GoygfORs3IQ=;
	b=aJq1OCtPnu9fdB2dVTbLwkNAqKE/WkeWhyOl2S8sxtzIkn7jnq4iCxH6fCVk3h5Hq3vCeq
	RMhZNg/XOFpzyuEGiFr1sqv8f/kLs7P9L6eVAW4vI+Z8U6WY8DVBECc6vciCGuP9nXv+ih
	c0CButBk/21wdl1IoQJaWMnaqiTZW2k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LX9oQFb3;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793120777;
	b=XvIW3Z1TNc4A1XoeNL/2rY2J60qTOsjxuvcWBKXPJjThSa+a+f92ALgRaGbC6OjoJV334m
	MM5MATpiZ4ppFLra/KxOwotM8zxMwZEiaXyD7hSiivAYkAQK9yjgDS7xGDkcJpHCkJojcy
	aMfbM4M28dlmY3ZT/07KJuhNieldWMw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D61871650;
	Tue, 27 Oct 2026 10:06:12 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8FEFF3F7B4;
	Tue, 27 Oct 2026 10:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793120776; bh=YfBOcf/1p0yKe28rQCyfQziZDw3iZcDMCiJAcTFH3s0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LX9oQFb3JCU/nRh3HOHfyGm75yvY2AqOJkXgl4H1OUrL+YV/yfv5t2j4NyOmkDQk9
	 wJjiz2smZNW3BasgYXW2q2tqg9DtW18Hjbi6WScVSvfUxSgq2xS9N/BwOrfVKoiH+i
	 KRo062zN72Uh7zYRswDgomQDOFjW4Mykh8WDYZzM=
Date: Tue, 27 Oct 2026 17:06:11 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Dave Hansen <dave.hansen@intel.com>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	=?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH v3 4/4] arm64/mm: fix destructor for unconstructed
 hotplug page tables
Message-ID: <auDaAw5IR-ZFvqJ5@arm.com>
References: <20261023063428.3658761-1-songmuchun@bytedance.com>
 <20261023063428.3658761-5-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023063428.3658761-5-songmuchun@bytedance.com>
X-Rspamd-Queue-Id: 3B7FF40004
X-Rspam-User: 
X-Stat-Signature: 8xqgkuq5hiath7qf5gmi9jp6iufbzxk9
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793120777-305641
X-HE-Meta: U2FsdGVkX1+hqkxkicntevrjdROBaCxYaSR0zfWXjkr8C9LlTEzzwEX97/nhf2gVOgzwTpcNztURnyGWLGveFnYvntv/rpQ2/Pozi2T3xvSo+r4xr+Xu4FGzDRpSyReo0FVhZjgnI0ymeXO+Gs04BLnHamWqRbp4qRKORg/X/7SGGZtT38Qk213u+ChzdffKKjqvlhgI0vQTr5uPRxAn5ZRO8RVxpWlxNIZHMfr9VkmrN543aS++JdaoAVjF0yude1FpgI0OmfxbYrqUPuPRVW+w1DZuVEw+vUzAmjpgfybjeClubN+z6eDP/slQbInqP0qM3n9VxTHK03WiNCtZ1pUTpFQYUotjIs2aiVgCJ6g5pdxj1epyTmilk77/vZIsGCQu5mig4dcfmueIUUi6Dm1oD/6Pk5U/z4/mwOWSHPIycMnZp2Z1Q0TGA2ko10I6w6eU524XN8tAH2rGffZlQcNU+N5Ey++F3FDDvs79sgi4b3iIcJuqZrj74M3DDTA4i7ikKbVwLhmRA9xH3qUwRYMGHhJUPcjYndp4CAD3NQzwB4jIifqUTuP2Vu8AQqy55qbM4qN2/pMGaVqJkLTWoFqG8mc/1IJvtEdPkEZA9a4bzfnmwtIc3olqnhHV9lx1b348dZ8dMAuyzMZRULnmucXxDao+7ybUNn0GqkkmQL892evM195KiUdO6zdfBKvLcvUmbXsUg5xMtPYD+LtsfqgbaOvJaMSM8PKH5an7bbO32q/bzu7ABQBBBjdYat/ObxcatZuJnDhAVB1b96X9K7bq+L5jEBL9NqepXOzjFT/AdGL2r/ZTBMbso1vrfOfTaTb9yT+lMoJJs2j1F3Eyjxt5O7FbtANHqf7+Ggro5aOc62a4tS8wM8Isex55T2Po0L17NyLQTZtRlC9rNbwlUWK6pCc/nwgd0QYJH9ODPn/sGkPuSG83J5lCavprrJ9oofgfqFq4Rso6W0u4Nl8
 AWGJDMos
 AnGqfuGQitaKljxm4e+DySSh1luHzTqq8NapuKjOFGpkG6i6fWKZWpjAEOn9rnUqzJEty3FkpdG5WcQehhze4ycT0ffXDDKTWUAFkEU7P1clsrmtAJwn0qCvYv9AN19dPyqU6fgVSlvyytIrwPNpdZGbEyq+tIg/oGPWCJxjWuEmSaFkscD9FUyGnjCnS1cJPl3Q48tnBZ18RcSODpr3DbA5r8mK5YH+L64WhQigjK9M9d/YuE3k4TOLHTO9OcyoFIJO9qHwiplBaIdAQVoHeQaasHr1YX6B0jyuPQbHNpLGpPL4U+A0vyliE1ET4srEdIXmFAMSE8yQ/3zkNZ8H/7WpTkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 02:34:28PM +0800, Muchun Song wrote:
> Commit c594b83457cc ("arm64: mm: call pagetable dtor when freeing
> hot-removed page tables") made free_hotplug_pgtable_page()
> unconditionally run the page-table destructor. This matches page tables
> allocated by the arm64 mapping code, which runs the corresponding
> constructors.
> 
> However, arm64 also uses the generic sparse-vmemmap population code.
> Runtime intermediate page tables allocated by that code do not run a
> page-table constructor. Freeing one during memory hot-remove therefore
> runs a destructor without a matching constructor and corrupts
> NR_PAGETABLE accounting.
> 
> Free intermediate page-table pages through pagetable_free(). It runs the
> destructor only for constructor-backed pages and then releases the page
> through the page-table freeing path.
> 
> Fixes: c594b83457cc ("arm64: mm: call pagetable dtor when freeing hot-removed page tables")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

