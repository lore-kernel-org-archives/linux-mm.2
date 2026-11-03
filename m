Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70ABD606F7E1
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rRFP3lxz
Received: by kanga.kvack.org (Postfix)
	id 890106B05B1; Tue,  3 Nov 2026 05:57:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 840D86B05B2; Tue,  3 Nov 2026 05:57:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7565A6B05B4; Tue,  3 Nov 2026 05:57:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53E046B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:57:05 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F1A36A7E39
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:57:04 +0000 (UTC)
X-FDA: 85393505568.05.B53D88A
Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	by imf31.hostedemail.com (Postfix) with ESMTP id A4D2B20005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:57:00 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rRFP3lxz;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793703421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLCdQ7yyYZVSa1Z/8WV0HEWdcD0ZR8tpxoUJ6zf3iks=;
	b=F3yQaxzgI1Bx7b2DbQXO+bjlXK7/EK6eyTOzV/BEf+OnQWf+gxhsjwbUBckjkHW9RmpkDs
	q3yIPJLj+VWyyE7I9Z0DQtbm/IO48buJ+irorvTQTtecADPIWbO1LYKcknKV0SILcn6fnL
	e2+KrTBcQc0LAFLi54cRdSZCEVUUlpk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rRFP3lxz;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793703421;
	b=xLWXa7GHQA9uOkLP5HY2rgmlYGMtreRr1Ht/82O35sROpZOF4ZJOuUosTGahpfm/V6Nr5L
	6cLggIpzEdXyt2WuUiLBrq65o31gcZLutOKCKYD7/A1h0K2NYiWTLN0I2zoBOCieS5h4K1
	yi+U9fv/V4pxsCa3Zgg+0BMsW/Gt69M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xul2O4mVtDcfKlb1bMxbQAbRnQ4n0rOnY7nn3uF3ixE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793703411; v=1; x=1794308211;
 b=rRFP3lxzLCcYhU4VXfCbVJsJ05pOZzeFkA+0X5P5/DPJeMX20yfCJYCkbtSsBWD7LKsjEYWl
 3ZQ9+CA9PS5L18NwiiQl0HFwqEJ8uucBsHNpVZ/AsmQyg0DuqQOsXEJuNxfntPIjoUAEOSKddLC
 do5UpOPGNkdzCQh5o4cEOQ5s=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 6423a6be375d5d61;
	Tue, 03 Nov 2026 10:56:51 +0000
X-Mizu-Trace-ID: 6423a6be375d5d61
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 2/4] mm: hugetlb: skip CMA allocations under
 PF_MEMALLOC_PIN
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <5bc00742fe249cf09a3095abccf8889d5fa71116.1793692578.git.zhengqi.arch@bytedance.com>
Date: Tue, 3 Nov 2026 18:56:23 +0800
Cc: osalvador@suse.de,
 David Hildenbrand <david@kernel.org>,
 akpm@linux-foundation.org,
 azpijr@gmail.com,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4EC5E593-7537-4659-879C-95ECC2224D2F@linux.dev>
References: <cover.1793692578.git.zhengqi.arch@bytedance.com>
 <5bc00742fe249cf09a3095abccf8889d5fa71116.1793692578.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: 9pwijo7u7aiyui8y8a9y1gbp6eykgcmh
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A4D2B20005
X-HE-Tag: 1793703420-714437
X-HE-Meta: U2FsdGVkX19I9EhOc5QsHSHdy5nitrQxPEZy0vfYlhIrawAYwhyXtSzJVo4DNj7Djw9dX+5Qi8Qxn+ZNbrMWeGkojaUIKEDsGf7cbAETvd566cUAuUi8J4cCN8/BRi7I6GHaHNP1P27aqhK3x697Z/oKABw6IcdMNmVIFSFyhOPsjxIzyj8qihAc1nqJ2TdVzR2chEEQSvUpn6XRcjVMYW7cj461LL/VsJspMdkGrxzhmxEFDspdGa2TvN0f96QgI5BGTmk1DUBBz/i5qE5O42IiTUpESUMMy/CaHiAQtMWl9S9njxjSPa1gBHzzQ3/0Hy0QWRHLJR55iKbAcn3ORgQheHIj9Ab+0Ab6VWNUvby9sAlxxBAalmuH7rBWNyfUEv39jDYIfy4BeCrR+OHS5Cftj1r7rq6bURi8Pc4onDUfDgQ+sS2eHMvcWjQpQ0jtBez7rU/ygA2lKSu9FyNZ9DivEKBRSBcXhs/65f+MWGx6p+2RdoB2oC1WbHER3xUcMpvqTJyOaN4ghD0SUZhtK44WcEmOsZuydfACusqbSaB7qpdy2jgOgQoxPxcz6DY6Z/t99g0lDpuB2ebZRTjhWWsmBNJq2ELQBO1aWytQVFJMp89w/cmHBia0lq0YhnDFKO8+VmJeq65EvJ0G/b3YsADCF/+efYqsI038Ntg3jHDufghlJEi38wXO4uVEYXHjw9SsPW91h4rcDd41fZEyT1tGVA0fEEgUVzn+Jurt7T4/FuG/vmMMbypI5DZtISpsNKMvwi4eND66re2YHDtOHWZ9wpc6zsdtxT3bxiWaLS/SJ47DtPnHuDKiyhuY+y7yZ80apmIahxj2axrHyYeHQD/X3BNQgS6ij57rU7ZdgA7hguMNfadF08YXJ1ivC3s5wXENvI1j+BS9rfdBg+/rRcgi9Y8dJk77qNWUUdjZeSHu/GAqaiFBjfRkt+LyM57aYZqZCQuBu/6lwfTr5Ek
 X7E8R2MA
 07Z2qOruNxcJxiIrkbxsu5vYRvi3m3EAG8MOjreokzH2l9LJiJ3IeSOpbNZhB9EljakiEd9kH28H+XAfORzoxnms1u8N2v/sxWB0AYDTyrMI6tGOeSJoPdN5AIfUXxFrY9xG9XvLInm+JL3FhjzdZpnZrpTcRzzrF3O/R4qyKdGgitNdsAcf/S58pel3Ugwca6Rj3n/5VAQLW72cko1dU83BHgsC+Qx6pdRwE5MeyYH1jrjfKU2xXmrXxlQ1Tj+j5aPTvx8kSgMHYWM4ZlcpId9pklLAZf0QqxOZN5GoOV2eZhXl3noNTcOUkfF7GUKOyzJ5eAU+FsV/lkBfLzLrnilHjZeS0OHLh8rACe6ESCohnkxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 3, 2026, at 16:01, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>=20
> With gigantic overcommit enabled, a fault during long-term pinning
> can allocate a fresh HugeTLB folio from CMA despite PF_MEMALLOC_PIN.
>=20
> The folio must then be migrated before it can be pinned. However,
> fresh gigantic migration targets are not supported, so pinning fails
> when the HugeTLB pool has no suitable target, even if the original
> fault could have allocated pinnable memory outside CMA.
>=20
> Honor PF_MEMALLOC_PIN in the HugeTLB CMA allocator so the fault can
> try the non-CMA fallback, or fail when allocation is restricted to =
CMA.

Wait... I think my Acked-by got ahead of me here. :)

There seems to be a rather odd distinction that GUP is missing.

The usual reason long-term GUP must migrate a page out of a
MIGRATE_CMA pageblock is that the page was only borrowed from CMA by the
normal page allocator.  The corresponding CMA bitmap range is still
available, so a future CMA allocation relies on being able to migrate
that page away.  A long-term pin would prevent that.

However, a HugeTLB folio returned by
hugetlb_cma_alloc_frozen_folio() is different.  It is the actual CMA
allocation, not merely a movable page that happens to reside in a
MIGRATE_CMA pageblock.  Its range has already been marked allocated in
the hugetlb CMA bitmap.

Therefore, CMA cannot allocate that range again until the HugeTLB folio
is freed anyway.  Long-term pinning the folio does not seem to make the
CMA area any less available than keeping the HugeTLB folio mapped for
the same amount of time.

folio_is_longterm_pinnable() currently only sees MIGRATE_CMA and does
not distinguish these two cases.  In that light, rejecting
PF_MEMALLOC_PIN in hugetlb_cma_alloc_frozen_folio() looks like working
around an overly broad GUP classification.  It also means that
hugetlb_cma_only users will fail the fault, while other users may =
consume
a gigantic contiguous range outside the dedicated hugetlb CMA area even
when that area has free space.

Would it make more sense to fix the long-term GUP check instead, so that
an explicitly CMA-allocated HugeTLB folio is considered pinnable, while
ordinary pages merely borrowed from MIGRATE_CMA pageblocks remain =
unpinnable?

Thanks,
Muchun

>=20
> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic =
hugepages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
> mm/hugetlb_cma.c | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index 95fd2d190f0d2..dde1c866406fb 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -62,6 +62,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int =
order, gfp_t gfp_mask,
> 	if (!hugetlb_cma_size)
> 		return NULL;
>=20
> +	if (current->flags & PF_MEMALLOC_PIN)
> +		return NULL;
> +
> retry_cpuset:
> 	if (!nodemask) {
> 		cpuset_mems_cookie =3D read_mems_allowed_begin();
> --=20
> 2.54.0
>=20


