Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E55FC5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C0D6B0452; Tue, 18 Aug 2026 10:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7232C6B07B4; Tue, 18 Aug 2026 10:24:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 639096B07B5; Tue, 18 Aug 2026 10:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3985D6B0452
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:24:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D382840251
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:24:17 +0000 (UTC)
X-FDA: 85114610154.07.B35EE5D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 290E5C0013
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:24:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d1OKS0Z0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787063056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdnTLQo/JmtvFPoN/P8a1r2fGcYFe6HoNSfexnuyDrI=;
	b=xCzpn2wP0TGsraFLBIBtplpfccySt22kkLJ+Urb7moDkzRZN2B1tYvdEdo9hK2ZjQceFFd
	Rm7FBvmDqumiCNlKNuE3PC8Z4bW2KzhCp8YQBYro+8eSE/JmVhMaHjM0a6ZronrYkbYanr
	xhBSvgZYDVdbEa1PRdQ2e3xQsWvhGY4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d1OKS0Z0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787063056;
	b=IdubVM4oZ1blGOXLbl46e0ts3pQa5cj7DYQLhfSvzsWfqx2hDL0XXbwvjFWTIy6qpcMSAy
	gHc+Mk/NopDsX20quC72tzhH8x60hoFsxgamEr+7cF5UyGYRhwe3Ba2OQIj1hau2Q+XZYK
	RfBQOieyv1VjXbfmMj5s+ErhfuUYQZQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4330600AD;
	Tue, 18 Aug 2026 14:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFB71F000E9;
	Tue, 18 Aug 2026 14:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787063055;
	bh=qdnTLQo/JmtvFPoN/P8a1r2fGcYFe6HoNSfexnuyDrI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=d1OKS0Z0U3TyofFGmLpXX6S4zM3Mnt6Xc/k//ojKe8nA06JMjPQ1T2/6wESpnVuaW
	 kjVFCYi4MmPTP7cLLb8jg0jRy3aeJgLBXppgzdmJUl/mpLtnQUB7YGNBtqiwDai+uv
	 uU2k1twoWYIl5n4P3K9W7PLm028CNP9RhsH3UQyC3xeGDbH3FhYCG1I8DRL1lefa6F
	 chn55mS5ZaPkP6tKWoRRsz1BmWwUqdBy9/oj7SuvZN1slt8hoQZ5K2SiW3krd2FNCL
	 yx0HhfQ0z/WlJV9hjbh9oFvKfGdHbw/lv4an+xlQ8JwFcafcRuf+HJDv/Fcp9qi0eS
	 pxXA1wlF/Zftw==
Message-ID: <06664eab-cf05-4666-af37-e1b51f395d32@kernel.org>
Date: Tue, 18 Aug 2026 16:24:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/12] mm: rename pmd_to_softleaf_folio() to
 pmd_softleaf_to_folio()
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-2-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260818131202.494754-2-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 290E5C0013
X-Rspamd-Server: rspam07
X-Stat-Signature: a4fb5gg51ckmrxib8k7zoj7dmb77ot8t
X-HE-Tag: 1787063056-350364
X-HE-Meta: U2FsdGVkX1/g1/a7oUyz1CudAYEBVj29A2/3i4aeht/bWCQx6E5rMAPNVwlwNtOsWCamO7X7WbndD73RDpU6nbt62dWm+EJLbL1SSjyaCnqmxKzKaqZ2HJd/jbP1+JURr1rQwVM/pKtVGY2g67NgDHaxDElwClnWBLhQPxN31poVnA0kGZp9h2gIdvm9WDKAMUaN9bVpcFjGxD1AUSTU68l6KHkKVGqQkRLxpq/OOEEDYSmvNuHJ9AvxcIoTglpAjVr0TJbweXLygrYKWkmDAWC8o50Zlp4cR09naooYeQpC4xTZdw5qnATzwYUpuwzpHCzdj7tu64F6+fzKRYyk76gZc/NpyVwY+NEwV4aVxph14piWA+ylFO0aoihVz//G/LCG5uM3p863s0gw+c3D8pUy47BuRgDZ8NbQ//R74CV8BTPD7ps43Qj4x7pKfkGYzaGdpQplZfUZutS0qUv1d/bPjUths+2s6P8TrZCQAZggysDVZolpzlNSfGnfWznfvrskQ+qilNpemsBJRSXu45d8z+eVyjyUvYWFqVkWYweIPA14YIvmj+tJEutDYq0WLQa9BOa1xbLWV05cV26UZsqoB0E+sn9/beHJpG1Be5oNexCZaibWSfcihi7X+3bmqcT5/SBN44G36OcEQKJI4xL4IXgzGuXbdiljJkQMy9yBa4/XvQ627RAVLzNiUH8JXd/SFjvd5Hf9f+IRxTYcL88u6puoJMAfC6E2xk8Q8TEWtk6JrJuYXy9w9RwBfEg83vo/+R0+VqK8MJAZTSni5y6Dn5uRFmKYhtM+csQCy40jn87lo5Hdda3dW5BiBr62Va5chd7oHItvZU+fLlgyjd9NWMWyrh/GeIgWcMFkv0TgGxtXfTdTTAXfJmUGu9UE9ZiwZU1WjELhOJs2vMvjXvNk1aIh5K6UTCWUSJ5DztlVrASG+S914GBmseNxXyJm1PcQBkmKyZUrBPmpF4K
 shgYZozn
 eJkoojdyC+UTZBX3qvrsClHIi7KAYGjNqQhrgww9hHQW20O/f4Yp60jRmsjMBRAe/mfk6U+mxo4Lh1lwX/w4Dml/W3DJnPM2frVPzzCQkiRZCgOOJSjvNwW/LtYwlBDXtOhk+4wUzPDVfkCBbSPa9PuNeL70FZUrUJeJadu5oIHbkzsvtxR5NR6JYs6i9rDOpA6vWUM3tW+Nv/l5tsd5GoyzrSe3Rf1AMooZnHbtSWbnm/4OvxMTf07wzOdY2psGBUbTCr2muZcUkWtbZpql29/RU3Yirk6WPU8w8S6lk4KL7NIYFMGv2/8nGVMuqx3eUmXO9+QjTPBIC6EaKuMYJBrxFp8M0beVglgVoy/fxEKBuR1n+k8nLPfEnMeU5iMznePUAP1aYYBPeEjM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 15:09, Usama Arif wrote:
> pmd_to_softleaf_folio() converts the softleaf entry encoded by a PMD
> to a folio. Rename it to pmd_softleaf_to_folio() to make the conversion
> direction explicit and align it with softleaf_to_folio().
> 
> No functional change.
> 
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

