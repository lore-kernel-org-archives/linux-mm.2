Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0789CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 14:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559DD6B0088; Fri, 12 Jun 2026 10:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50C966B008C; Fri, 12 Jun 2026 10:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9DE6B0092; Fri, 12 Jun 2026 10:57:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB396B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:57:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ABF5D8AFE7
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:57:15 +0000 (UTC)
X-FDA: 84871563630.14.A1429DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D02E81C000D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:57:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rf3CzbFy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781276233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yIxv2x2w6vdczAIOXCDnPxLwfAqEF3K86mcSGxHO7r0=;
	b=0Ce6lT8VjYSCR8f99bo1yTOz81mqcV4q6AUBiZ/6Cfpa3klF6vs0gnzbqZNhOeZfZ2OYDH
	5+kEghzb1ftNn/ApL9G89rXsArGlhw215vLoXVSP3pnvpY+ea4En+CDqHndUw1RhusWRqv
	MDYqpdNsrM1EMbN8VtWMFNLlfEAOUbs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rf3CzbFy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781276233;
	b=h3uu3DDALqvePz9+0C5qnzd6Xb2vdkmn/CSm4VQ/UTiLJD+jqqOyEnXCgp+pP0NlGhvQOp
	jXGD/z8PWhqKzznKv3OKCOcd8jWFvS6lJHmJh1trzavuJVKESyRJioARuTQRukoMfKSd+z
	8rVu/o//oPQ4Yk/jCeI1O1WMDbebLzU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FBF94170F;
	Fri, 12 Jun 2026 14:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2CD1F000E9;
	Fri, 12 Jun 2026 14:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781276232;
	bh=yIxv2x2w6vdczAIOXCDnPxLwfAqEF3K86mcSGxHO7r0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Rf3CzbFyxONXMuuhs+mzRR/qYqw6GVH/zROtz+VljvGNF94FHNgpCjG6XBrsWGB0r
	 f1fDeWBS9zySkkRsjGFlJieXGFFyezeV8ew00UU2N1W6OuKqESYkh3XnULyy+3SnxG
	 zJW9y/1/yebMuclt6RZVfPI/m85k4wXn6QJiWDD5rKVfqAE2ttaKwTFrHPiL+ftxQe
	 GxJ4SGl52vW9HiGiyGZNr/av50FEtCtCwcl0mc0P6AMeXLmodsbr37THCVYfRzjirM
	 mnTqJtn3W6PV+j4GMTvA3qAJ6WoQ0C73f5yfH0brY7xKJ3dNSDe3jjIz4ML4DlOxj0
	 gXa2Z1cESCRKg==
Message-ID: <fb652b0a-9c3e-48bf-a301-16d37f212aca@kernel.org>
Date: Fri, 12 Jun 2026 16:57:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: reduce NODE_RECLAIM_xxx and change to enum
To: Petr Tesarik <ptesarik@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org
Cc: Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20260612085052.59291-1-ptesarik@suse.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260612085052.59291-1-ptesarik@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D02E81C000D
X-Stat-Signature: pni93t7h6x9x3pmoauqeo1xdw6ac7eqw
X-Rspam-User: 
X-HE-Tag: 1781276233-51811
X-HE-Meta: U2FsdGVkX19EkGitDO5v3NY5WzO2JSvJwENPQOnfblWhk7jfMKIZJaJZRnvYFLzxp49C4WvnIm+Q/lRI315x8/HPyHp7sUxiMgvZtPAsHjoq/BmF/t1Vq+S0ZJNaMfKdDJJWKztaoaVqH6WR3or9VJm/1XYemTNkPU0QmvWfF6SBvA6O/DOsVllk+3nJdAodCm0Tu9sYZOKeFZXIwcJnHDGj4Qa/kEoZnjP7xzqxdHv/pqQvZ1/G+TU8hYSmQ6E631DAaCvW2m03vvqi5tbm0cVVMwcQnkzkbM+xXaGpvFOVCOHvOaO3z4AzXFYMZ2u7MpRwUolCBNg9LzhTLs4M5SSNMMYWYM8mgsgqifkfvJaRtKJ5FyvDgMrEGq+F3UeExalaMiCKpV6Wd7MawvgHz1F7XuGHZduhrE/Ts9Hr1WKhRDw5OmGhkDbuL1tU2IxvbZ3FgcHyFZgx4ZMezPDikvQ0vcn61GDp/+enF1N79yk2tyVs6EuPlAKB1Pz8OZoln7FyU+tsohOcvbhziARqRE+vMw5b6WZwpchZi1LV9eSkQ6ZqwBnI4ToSZ/fsUCHrkCcZupLchQMHQsqaHWfcMcMfdQwRk60Udh1b/5ard77GUeF2nrQnQgcQGDQl901Gar/lwiGWO0X0KOA/e26uXf6W55eQgMgQrZB5L4O92fFck0RMtluQmj4XwZffrDECCwO5F/kTRRmCnG2mrgr7VGyjtz7rt08h2GXmu60iLA2jT4mONwASY5d69G51jylDOnheJfb2695pX2gAgiC3vVl/UsqZCt6yzgIRBVWYR4Xf5yjQI0QmbMYD+v2gWmvWg3wrtatMD1esR5EEcJZV+k8DKm4S1k4F89A1wKg+uTp924q289GCrqKrTzkO4Nly4ER14wNBlqaqRibwXU2OgTt2bRny5WO6toEJBrA88vNgOj4HtcQcnlSDpo93U1ymXhQhUHHy4rpmxHWF73k
 6veltHoO
 6Yl2Z+U8FPbNUsV6+yQR5hBaKuDkJmAYEMLdMqlgF9ReGVg8bCawzUiXUNgE4rajkRHax18RZv6S5aYZNnUeRKcL/uc2Ezt95DpNjcR4LUfbeReFv6ml2mssLuSiYnn0dS2La+hM8FtfkO9BoBvOZsEnuJOArhj6SKFtNVIRZJ4dxmElv/O0KRvQZRbSuLksmMKqweQ4DtCLrSukFqZRVktgMC0v8fkAe5R+86nZL7hBQYv0pPaX+L/nCHr0reZClB7O6EgljdcIDgLUdE09jchILZFmGcHZvgZpAiPDahCaMofcsWXfPRyRpyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/12/26 10:50, Petr Tesarik wrote:
> Change node_reclaim() to return an enum indicating whether any
> pages have been reclaimed, because that's all the information
> needed by the only caller, get_page_from_freelist().
> 
> This leads to the following translation of the old macro
> identifiers to the new enum values:
> 
> - NODE_RECLAIM_NOSCAN  -> NODE_RECLAIM_NONE
> - NODE_RECLAIM_FULL    -> NODE_RECLAIM_NONE
> - NODE_RECLAIM_SOME    -> NODE_RECLAIM_SUCCESS
> - NODE_RECLAIM_SUCCESS -> NODE_RECLAIM_SUCCESS

Why not simply return the number of reclaimed pages (0 vs > 0)? I agree that a
bool is not good.

Or if that is not good enough (for some reason) return 0 (success) vs. -ENOENT?

-- 
Cheers,

David

