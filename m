Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C36AFA1FE4
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 18:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E07FC6B008A; Wed, 22 Apr 2026 14:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8EC6B008C; Wed, 22 Apr 2026 14:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA7716B0092; Wed, 22 Apr 2026 14:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B4D806B008A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:47:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40DF112010C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:47:43 +0000 (UTC)
X-FDA: 84687075606.15.C163EA8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 62449C0011
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:47:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pg9rErma;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776883661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MP9Zidfne70C2EnzYkLaYupf+5+jzE+B7PuijPZ0Jo=;
	b=hsGOvw3/yIXtz28m5z7B/GxWYumJPgmbtgh/LyN1jSlsc68E0uda0cufXgTmmomThbYOl0
	minV4jYxA7ELNsXfukvyX4hgyOg6ztAuLLjU2l+2MJuiKaEqowKElWYZDGIPGnpK+Hh4Pf
	Ggp8F+K0OBp7v+fA1LcABeHWgj2wyns=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pg9rErma;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776883661; a=rsa-sha256;
	cv=none;
	b=1zD78ydEQktL0Mcnr6VOee586XzRW71S6O8geQynotFGz4N9/eEQmwP5cz4Z/4rvbFOXZI
	dG81foF0L/dFyBIbm07mziB+9utMxnDmMpjRl31bsBpHSUK1P+SgXmCj5XY1jpeeom9AlQ
	j4j4YMO3XP6vv3IKaT93Xmoh8Bj7mBQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C6F443312;
	Wed, 22 Apr 2026 18:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C007CC19425;
	Wed, 22 Apr 2026 18:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776883660;
	bh=JyVpL0hRh7RspmbLsNFTlpg/7QFk3I3or11RgPUYkD8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Pg9rErmasItlxx+XZ/hFgV6+sAPWZpnrlTYc2QtwS+P+alOZv7lW4Yn88JbE0OLmm
	 xdFd/+ako3CdS0qbw7MR8TLOdoY/ArpRjsN5bW3dkAYQ0JUnPOEjmc4IyDYhogWuAf
	 j8/zddCVT5bUYWq1tsVtCzpdLfpqp8FBr2CHFuOUgOm0gHXh2BRD6MpnHxM3UTgqMM
	 T6iry4ukW5zdx+c6U1GjkaauGODieTlV8kq6Cy4MLYI9aOsqQWeTYfIWitL0coDhp+
	 6xw7yU6UOeAp9UoPUcj25ZRvOn6pgOqgBgTZxb1yxGM02I1Fh8gJdH+0zJwz9UzGIG
	 JpAjWp4IuaiRw==
Message-ID: <7d62ff3f-de92-4d63-89e7-5774484321c1@kernel.org>
Date: Wed, 22 Apr 2026 20:47:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/5] mm/sparse-vmemmap: Fix vmemmap accounting
 underflow
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20260422081420.4009847-1-songmuchun@bytedance.com>
 <20260422081420.4009847-2-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260422081420.4009847-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 62449C0011
X-Stat-Signature: goghgqnao44c8y6frt18654q6jt1yb6p
X-Rspam-User: 
X-HE-Tag: 1776883661-344951
X-HE-Meta: U2FsdGVkX19rpQSLLGJfsPqrQfJ6cCpJ9Ro1OP0dwL+ZzkGkAWBaz8AmEg5qRdwI1scSKGD17zppVZK7xSrds6gDxpJDxFZnOh89zNb0DH2sMMi0dyvrr5Y9nXrP8rd01cjYSlPESlPGu8ZXShelM9fESN7URPqcS2VgxvCKLRKAHjf7LMdagoBuSFvg8xPKv41AgRJPkIt9B0AjbOHVxoO5Xgw7fSnZMU9mP1XW+Tbgx0D0hcgRIN085br+MWlKjeO7VC8BSx1dSh1vFU9q3LKuf0SLPEj32RwL2i5z4+XYjXT/SQ7ldb+7ECpq6Uj/4u3DQYyTwmUVWPpOcRrOZpH872hUAKHeHJMPiQDebQr+keOXHXbm8UJXjj5lPzkBm+CmPJgmsT/ssw2MAR8GtfxaEBfPVP4t4fYh45Gq04K+xDaraM4Lk1pxsjF/9Qg0ABviEYmnGm1MZKsbQildQwp9VNQwjpnQUb3qy7e7Kz/O8IeqPfKWVwQL25wL4bc+x/7s5ovs/9ICvJW/h7Qwuwi7W/ywZAcf9ba/LFxtfjOtvZtFmF4IxNF6NUL9R/OmGIMSMkeizGryde3Jzp4okCCj3A/h7+sLK9rHZ3knEgSMuESuhY9LOYoSF9AluRPG9wJuzjid8mO60VqlOgHflvtuu2Dyen/WSCJLHvNoiOG8NapDtTOvWgHlg5WC+U1426u3pxrCd2u2F+A/hfLymsEmc3Az7qrr5j95FNhAT1yl7rfZLE2o75S9xmauznfvkxuf8fIXROIiMXlYke5fb1NyyL+lgSZlccSURaS7Phxw54rCtqaXFM/K52D7yFZ82N6DRjERU5L75GqAN6eUCigeQjHzsaP/E5/YWPhVEkODoHoMeR5svpEbJDqiYjRpVT/RBaS3o6e/CVYSFVXUVyBwYVr0FCNd4gYtQaluhO7gj2rrGS4L1wrv1+aYQjBVrEoyKC6+qQolbzLLpAz
 speSq8jk
 W9GHUablz55mGqxS+yqgKmtTZrnPnxUccB/Cl9fxEVrVckkleMgj82pftcS5Otl/ptCymwjKy1CVy2RDhyt96eXjMjotJ2QZMNB14Tb8ErjvgQkGRLBsjl2dT2gX88F0oNEFESo40y6dK4ckPH+WQnLpEQHnM3KJzs9kR8nPKvtCbOuDaqqSGzl/6ORoOpxOnRPdpB/XOs3RNwjnKTAB+52W9zu7zeSGY7MXQ8lvPa2XTL+fuerZkKmZRiGHFrAziexeKWzLjBJ8zlFE0Nq9cey2tEFBhPlC62pdoPLrgaJPlGVUW5UAGzdSoig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 10:14, Muchun Song wrote:
> In section_activate(), if populate_section_memmap() fails, the error
> handling path calls section_deactivate() to roll back the state. This
> causes a vmemmap accounting imbalance.
> 
> Since commit c3576889d87b ("mm: fix accounting of memmap pages"),
> memmap pages are accounted for only after populate_section_memmap()
> succeeds. However, the failure path unconditionally calls
> section_deactivate(), which decreases the vmemmap count. Consequently,
> a failure in populate_section_memmap() leads to an accounting underflow,
> incorrectly reducing the system's tracked vmemmap usage.
> 
> Fix this more thoroughly by moving all accounting calls into the lower
> level functions that actually perform the vmemmap allocation and freeing:
> 
>   - populate_section_memmap() accounts for newly allocated vmemmap pages
>   - depopulate_section_memmap() unaccounts when vmemmap is freed
> 
> This ensures proper accounting in all code paths, including error
> handling and early section cases.
> 
> Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> ---

Much clearer, thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

