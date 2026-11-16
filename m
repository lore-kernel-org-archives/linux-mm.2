Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDED6606A334
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DguWC3yV
Received: by kanga.kvack.org (Postfix)
	id B4D4D6B00EF; Mon, 16 Nov 2026 05:08:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFDE66B05B0; Mon, 16 Nov 2026 05:08:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ED436B05B1; Mon, 16 Nov 2026 05:08:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 795E26B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:08:14 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C170140581
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:08:13 +0000 (UTC)
X-FDA: 85440556866.12.1762C3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2453DA0008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:08:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DguWC3yV;
	spf=pass (imf25.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794823692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xomABNJRS5DDfBS7xLxXB1ttX9vN42Q+i+1BI0PiZcg=;
	b=GuwgrBezytxySLrs/GXQ+Oa5p+Zp9GNwiEsgxGNpgM/KCIxKk9+aquL6czh/dojYG2HYMc
	ruaPXlSJ6WD/xkQZ68j5B6Bof92C91yFFpfvDDxH6qc4NcuJ70P+AzbV1GKr6UGmn2DBUm
	E600Nl7Yepc/fY52AYpMBgpcClb3NBw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794823692;
	b=uYscRc8lmSACNoMAQzcmoJjEQU3FVlr6hPnszrRyIgLW9cUICzIfTUpEtJjslcv0nsFN+t
	XRzCJQgr3NkasLyqkfr5TlkfaR24+3PKE4wNuZeWPcSblxDA/5Vle5RDBWGUR9dRuyPNuB
	owNGDFpyKb6XLOdW23yuAIXzLTqHPEY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DguWC3yV;
	spf=pass (imf25.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E333842B3F;
	Mon, 16 Nov 2026 10:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEBC1F000C4;
	Mon, 16 Nov 2026 10:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794823690;
	bh=xomABNJRS5DDfBS7xLxXB1ttX9vN42Q+i+1BI0PiZcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DguWC3yVLhDQZdYT0Ss3fhD2eGdA5SSVlW9n3iPptBfnNPe57uUf6enAe6ijWcmaz
	 YjVLnBWa9RPOSruTDJR0Bw/3MBhirdVRAwMMMJoJ2aCU4An/GS0DtPjXrbqzCxqDPx
	 NXjX5P+k/g4k0nvzZNmaC2wbs2IQGS3tTs/Ubuelnz0Bg3SnHkC0YdNPBkcBRci8nR
	 7lv+y0OOJ/6bJHg7+G3mlMqJ1XR82uprshFJqjuMp8QOJoOQsB3/mOCPzuozJNDmLX
	 zkEZsKlIaRMMroq0JiFxUbAdPShLkYVB3ZBtWQqxDX1Bb3zGNpb0IiPoNJzR202VrQ
	 LD38oJxnYN29A==
Date: Mon, 16 Nov 2026 11:08:03 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Sashiko <sashiko-bot@kernel.org>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mm/hugetlb_vmemmap: fix PMD split TLB flush race
Message-ID: <avrWA0hxiqPDmivK@localhost.localdomain>
References: <20261114112523.75208-1-songmuchun@bytedance.com>
 <20261114112523.75208-3-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114112523.75208-3-songmuchun@bytedance.com>
X-Stat-Signature: e3dwy9bqp1gw7ffsjj8jshzut5ptzgfu
X-Rspamd-Queue-Id: 2453DA0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794823692-381734
X-HE-Meta: U2FsdGVkX1+ZF6MoBP+J8swywtHKO6LEBw6QGLXuMJ1BpmAuxFp57TnX44+2HhZqdrd2UVvX71miLSSGdB2cOAANvdE5xQnDvd0DdDsdXaBNoN5mMAn2DANdPEQjQKeQzJdFgs+FnjVZPR3Sbszpzr7GzSIBPN3mXMcvdnS1l/CKhCRZLDl8p/ZqrQf2gH2SIcBtheH1vVnKixlax7D2X9D0OZ2AnrotPwryIbgyIkbZhyWjcDaSJriZSwnD/AgmqBFlDTGg0cGcv7iLynp/c+subr98+vXffc3tUKV3EUWebrZGKv4DSFRnQGaH9Xz6ir3bNZYRyTJ+GsUKo6Tzkc8JHFOMyB0ri0L44ySUEHvlNmxKS6K6wFyOfTPvqdiI2p7z9gLeLLb1GsTnmPnIIEvTPDVOj2dtl365oxFSnKZ95t8Ll/3rdwz/V2VgLtdGXunlfCmunLMi+XjOCn4LUq8AlD5OvVRNhTf3t8lYo0Vu0jv0I+GNQ9yIhvgZ3cO95zDhJrM5KUObeTfjWICDhe1s4I/286M0JJG9x/I8S80HCOqN6rQzc5HK5N+SbvLuErImS5h9o94h8WSmGFlL04Ztv5wX9B5u+1tNoKiM19UkLsOetS2KfdRddjZxdpn0akmvfsjTwEQDTDALxKbncD/zMOAWkl7FsaPvRq3xLaHpiqBI7ve7RFniapECSi9Gw6/uSWAb4DcmYAmwS40vYxiPZvEMZpirqo+9ttAst+CPuwvtPIuUC6jAXFiikAskqXnPOgAAWy7okyJCtLhabio6Dv3n5hH1YheGE4aJipPCZFIAom6ptRa2W63ycMNdp+Y60m77P3jOazUosrjuImjFaDmaUO3Raai/YcSI86wVuB8qjNtQ1qasGmGuSTmIQxFdqY9PgYucH4wHZbGmcijOSjqRq5zmfun5eM3EXea4XTMVQN6ZengDSFahf7zCw17sYZyWSwwjoCgXyah
 INASe2DD
 bPpKWU4fYQtw93+rbm7z+LhniZR7R0GQZyX8E2A13fThO4AyHTpyVdJP39P1Hn6hs7fSvPvrMS3XunJBGiARK5bBsqgQeg/f4Z7NQ7FAC6vuDv3fSyt53g4JTzeKcBcI+c4sHfkO08YN+gGIj2eJ3EOeo1cf+2FXXLM7LRhcKfJxosL+7Y4WLh7BS4dZEYFBw9AwsHfVXnVeGJQf9zQ4b7gp2FBcHQsAlcDl22kroXnP+rivOt85GGBxd09l5fStshEy7Xyz74g6yp8zCs3kevQFpaD7O0nPdvhrRnfxKs/v9V4+9dVngF8lWgxI1y8oTLYdaDVRPo+of+wnREL4d7lBV8+pf8wk5ZbRZ/g6h/J/LwSCdxlzZLH5Z2AP95WYK8O4xKX4TlnGYmBd027o+uu402UNzrhg2MFidnKhZhcvs5uGmtNdDUSv+Gb6zTlsgG65dUV3jvYMKa1DCE1l4XTxMpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 07:25:22PM +0800, Muchun Song wrote:
> Bulk HVO optimization converts vmemmap PMDs for a list of folios into
> PTE tables before issuing a single global TLB flush. After publishing
> a PTE table, a concurrent single-folio optimization can observe it and
> remap its PTEs before the deferred flush:
> 
> CPU0                             CPU1
> hugetlb_vmemmap_optimize_folios()
>   hugetlb_vmemmap_pteify_folio()
>     vmemmap_split_pmd()
>       pmd_populate_kernel()
>       /* TLB flush deferred */
>                                  hugetlb_vmemmap_optimize_folio()
>                                    vmemmap_pmd_entry()
>                                    /* sees a PTE table */
>                                    vmemmap_optimize_pte()
>                                      set_pte_at()
>   flush_tlb_all()
> 
> Modern MMUs permit overlapping TLB entries with different mapping
> granularities only when they translate to the same physical address. In
> this race, the stale PMD translation still points at the original vmemmap
> backing range while the new PTE can point at a shared or replacement
> vmemmap page for the same virtual address.
> 
> Serialize deferred PMD splitting against PTE remapping with the HVO
> rwsem. Hold it for write across the split-only pteify batch and its TLB
> flush, then downgrade it before remapping the folios' vmemmap pages.
> This guarantees that no PTE remapper can observe a newly split PMD until
> the stale PMD translations have been invalidated.
> 
> Fixes: f4b7e3efaddb ("hugetlb: batch PMD split for bulk vmemmap dedup")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/bug/linux-fbdc3410-a4cf-457e-88e6-684380fbadfe
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

