Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B97BEF53D6E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7206B0317; Mon, 16 Mar 2026 12:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA52C6B0318; Mon, 16 Mar 2026 12:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7096B0319; Mon, 16 Mar 2026 12:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C90D96B0317
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:34:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6012714033C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:34:00 +0000 (UTC)
X-FDA: 84552473040.11.671F5A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9B97E4000F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:33:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FMChSLEt;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773678838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XkIWnOb05pafB4SBlFEuJf1zmGM6rhd+qOPyvC4k9+s=;
	b=uJDuVDXYTMF6GiPvRRnp82TOIzIf7iSvxeqETYn/0fh+uPavTzPMMTw8kIalxOy6J9O6Jx
	JA2Vk5mT8PmUPldTg7zMxuYdu3V7Spq1cT0MHDCvAgrEakK23yhIcjqkVJC9aPKeJoKWV5
	pNuG7s3qGFBKM8wJ7MU3JsWIDmuFJWc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773678838; a=rsa-sha256;
	cv=none;
	b=nujH1gz6vK1HR+5h1sLz+NZVuaKaD1pn8Qdhi9x9gLgnXNxX8suPyXLTsK6rB2s/v+QoFp
	8LJ19thOBsH3HGgBeCxKmhkd5ZuXmk6oJMTveIxd48hL8J3qCzvKntIgHhL7vxyeuLWjcy
	qPHg7VsSU82TN5fGkjjJew9ibADe2To=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FMChSLEt;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 02F2C60123;
	Mon, 16 Mar 2026 16:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B59C19421;
	Mon, 16 Mar 2026 16:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773678837;
	bh=N0DM7WgflxXMH9CI2Ekdcuzztaf1QkYHMyojhK3C5VE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FMChSLEtbpV8Fe0O1mCMgCpyyx/kSFa8HuP4jivAPKecTy2/YueOmPbbvxeDoKCvA
	 HMb/n0MANqiGuD4T+Kb4GYr6oa99D9dG2MIg6BUHoboUGXiy/pJT1iN2XHoHhq2ezq
	 U3AAY2dnSbcACPTNanXJy4wIqAuTtztUaWfbS5n5phR3V9CdkktTVAH3etZXlG3ACk
	 QugccaXFzZdvwk976B5IlJxQ0XzY00WB0GIUS9n/WbBFNDnycHSnqbz7bgnfUtkt7B
	 zTkuQu0LfnXmPjkLcA9lleK624DND6yTebw7vsQCJyBsyHFmXhvbaX881PS5NDmYKC
	 wB4PPta+kOYwA==
Message-ID: <13006181-d35b-4c1b-97fd-f1f88c3d66c9@kernel.org>
Date: Mon, 16 Mar 2026 17:33:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 08/18] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-9-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227194302.274384-9-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ujk3nmgrbkhzu91pp1x4a9k3thmpdrca
X-Rspamd-Queue-Id: 9B97E4000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1773678838-228182
X-HE-Meta: U2FsdGVkX1/OqHZlerLlja5qDO0b/8ZweDllpq1zbl0l6vXGKX62tjM33NdkQfcTVV1cTLFvsnTefvuVCdhOi3MZFp2dzyJ3sbOJRe2q1nJWDVgJXjVpYW2UwJrbB7tfq/bZrodVbnzxKbCQboac5STBKcH7g8Uy1wYXcG1GwGfCh3jXMbvKkBYUipNgo281/VXyR2bCcpZxFROcl9+Gz+BA5Q1sn4XB+OdQ0411hCWYm5rvQtMZporiuDSSPF6waMG5QEJGI1mXhZMdLntISRuMOI2pGgPYJ98z0D9b/9vCHm5aih0yIelngHsjZRhSXgPCsgD7KbFgmsMGYau150OFuxg9Jqwlb40ZBv0Z/eRQ3VShLG4QB0vXU2zWJrDAyMHi7eiuU5XwWhzrv5lcgs+TUj3KRhQgiI3Pe/uj58sB2uLppztUWMkihZg0xqimG+PiEDct4ZtGl7OOR+C+HxwRgrVZTNj/DSi7wIPRYLR/mxSbzubr1PY3dOg2qvvXWztCpOT7Bhm+vc8VtcEt9Y8kOWiQkJoTNRJy0Pe3KFZt6wIj4rEZkh1YAgkKSqkTFqqVLjqXKTZQz4QZc44gHBPM2YXm1NOFRqE/+mttDjDpqanZ8VX0gH7jG1lQryTQzSQN91GUEFQAT3l1S1pchWyoAQUlWdRIVoNFEA+Vw+cnJt482cih4DS61Qf2C1YUAGC4sQLZUmmB93ssz0zskO6Ama+0z2BIYYj6xl0Mni5l4Q/IyZE82dvmDxMrvH7Z7QBzgaEosVqmDlsoS31EyMGtOdFbmkWq/D7cKcC+6JZJG2czOnpapJ/26yRhEm3jSbqOIf2OSAphKPef9F0Cq3mCh1I4DUhj66Yj94KUOjXmuk1R3dDnRfwwiz566sYJOy6km5C/rzkXJzuwFrnHc/WYFBG4M9uypyndUty/pL3dl2v7LNEnBz4bbWcfmou62MOxao8R6TnKaRbA+da
 6UmLm8bM
 Cv0TejRwxqtEhx97+/lF9goGAoXa+gYuSZDYYcfAIzagAE/y8PFEoBcp/9d4JW0Y6xRH44194A7YXOxtykHmcFXl4tVcMZqYR0KQbDM1aN9WZ6FSCZ6/luPWHhmO5D4HgK2D23niXVmobA29md97ymDVEtjloa4yph/PMTHSWiHFGP+T2Txipj+BY4wSZrTt8FRt2xbVWRcsltcoVn2CWLP2JCVQbkuhgS8oeqv5tvMa17LQqx6ryqIuRIN+u2WOckFgN80Pr2hs1ESr2AMfP+g+Gw3WrrxYxJYa0sQ3EzQeDXW+DZ+IqVogOV0j7OfH1HPvdV8IW52kE8aM/UYn02i8+XLP40Bsvnn3f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 20:42, Kiryl Shutsemau (Meta) wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> If page->compound_info encodes a mask, it is expected that vmemmap to be
> naturally aligned to the maximum folio size.
> 
> Add a VM_WARN_ON_ONCE() to check the alignment.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/sparse.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index b5b2b6f7041b..dfabe554adf8 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -600,6 +600,11 @@ void __init sparse_init(void)
>  	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
>  	memblocks_present();
>  
> +	if (compound_info_has_mask()) {
> +		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
> +				    MAX_FOLIO_VMEMMAP_ALIGN));
> +	}

You could drop the {} or incorporate it into the VM_WARN_ON_ONCE

VM_WARN_ON_ONCE(compound_info_has_mask() &&
		!IS_ALIGNED((unsigned long) pfn_to_page(0),
			    MAX_FOLIO_VMEMMAP_ALIGN)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

