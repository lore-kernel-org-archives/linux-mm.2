Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A21AF9EDC5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 12:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A4E16B008A; Wed, 22 Apr 2026 08:45:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555FB6B008C; Wed, 22 Apr 2026 08:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493146B0092; Wed, 22 Apr 2026 08:45:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A91B6B008A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:45:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CDD8E1A015D
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:45:48 +0000 (UTC)
X-FDA: 84686163576.07.6600361
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3905D14000F
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:45:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WgU+ou2S;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776861947; a=rsa-sha256;
	cv=none;
	b=Yf6dItdw+eWDWlZSwd61w54upx4jwS7pU0Zmj9X6oyM5oGKEljPYGm0cebthlz/sEk74V5
	KBIxoMIpxwC7MxrbzP2wwGalnMJaAjw6dR2iPAcyAMTVLqSiq73tjo0lkTPvra8opC4JYl
	dDTZtRjbn0SZHvWOFNhGgZXITz7IAmA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WgU+ou2S;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776861947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dKWd2mgwgmf9GIaV8r5YNYUfhtI8Hq8gL9EkZ1yU7CU=;
	b=U1mhBs+vu+xJTqApsfnT6uEfPm47JZ9bTFkE6/FjBYZvPkss2rs6BCm9etamPlYx629XuN
	hWFYi3pfFfvD5ot20S+1olVWhyzUDcUg9F5EWLlJVhYpC4nrxj1pEJYTbXxCQTgk7kTD+f
	BwX/IrYKvtnaqqde4vGp/f7Ml/BOSJU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B64B6001A;
	Wed, 22 Apr 2026 12:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E3EC19425;
	Wed, 22 Apr 2026 12:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776861946;
	bh=t//Yung63aGvRWFoqirn6gDdFMuw+7zK3Jgv1nSRYs4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WgU+ou2Srb4sEDAQ/wv5TI8GNIPpd2xHkb1c1E/pU6iAcg+ucm4N3sCyUeXZ1egWE
	 rXsS607WKx49qkm7L5wfGPojnpq4QfRy78VnFm9bnLeTyWzE+57zWRpE/8GT7cGsjd
	 3uno13s/eo6mzB/Kv0B/xQDbHEQ2jc2JVI7tf6duujy+B/TC5U2Ia9389dqPIIIlvO
	 6zHDCpRVrIKulU+3tpP0mETYYQ8eeooLULsBvPIM1/mIn++9Sgw6qWCmy7TJlQ8u6R
	 ycaBLZdPQfdVlGOpUZg+wTY4gwnOkGzuYn4N8GpZgtXA2vn3E/cQ25xx/KUQS5/cYX
	 p1lD2Ucvl7vLg==
Date: Wed, 22 Apr 2026 13:45:39 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH] MAINTAINERS: fix regex pattern in CORE MM category
Message-ID: <aejC1z-mOd0zQ_GW@lucifer>
References: <20260422123726.517220-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422123726.517220-1-pfalcato@suse.de>
X-Rspamd-Queue-Id: 3905D14000F
X-Stat-Signature: 7kq7w3cksz419dgi7ptr9yjfzp8e69yd
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776861947-986984
X-HE-Meta: U2FsdGVkX1/pC5qKfiwScJA+ctcuIg5lf48YkHIfSvYkjo0263GZtWmOuf4kHmv3OHDoKhny8y58K6WFdQ2KnVWP+Edxv7PbrNyXkjseMq31yY6j2gCixiIIcKUKMvfJkBVqwugYeLs18ajyXXmH+qBTrmqn18ZpPNqnfEE3T37CJS37v+LyhOzF0/R/KYJ/xHFiBe2/MRV2+PNu+MYeiZojcTWy3kA3z78+r5r34+CSNNkrk77RWZMfscaF+jamm1QwOccZM/s0n6vZqVmQkW1hDoXhe/NGPHOqjm0mr5RNbAreHI3A6fvhqKntPBG+H/zfRgOeLbbJnhQxA5oq95/1TN7WQJxrLXY9USb/Pv4/Be5QVeJJfkrOsl8H6uz6L3ZRRI/ohjplq69ziTKmVhJ1bjzApUB5LnKUfxrMjBoMwAeNruNZccQLOy/VvMkBleQjaBK7n2BcD+NxsRQ7fPH8QoTUvn+TT1zpapBkx1w82uzfn3N0gEf6B9TWvz1a9NkeU/MFLt8l94lRdWCyoEYTgzMz1TBzS6XZArQA9sd5l9lbEC3rgJJT2Dm1SYW4amTxnPwYjQ6dDW5WbPZBHaRit+ytl+Gw5UW5XTpbYnkOBOJjrB3JqB2fXgio9gxkoeYb0NPrYDCwsgc+Ea+pisjRqRyIM+e6G1y3kLLUOlAfWe+lc0Ek6fRXPuBvfkOgTiK7yhQFQevfjhcXtTHlwpQofXf+KRkyPsCgqFBnzCiKTPO8/hUdWwr89IBjfZ0SA7e7dK0oAC4Z4Sn0TmVPkeeGFfB3AXK4XPr+RJ/dr+20cXhmSqYEK9c4jwQFd1w4dzd7uQG5F8NfnDkIbPYRW8zwarwQMPxa4eotMuVb7CW8iukvkKmV54kppD7QfThPXt9F3BJ+sHM11B6loiXu78jSb81ocKNQx02pKdeFjnM8s7oJJyZ6ZNtsIVWs8Q7LEYtjej+Z68j9V7/Dlex
 ja+Cm/qR
 4IO+iCF7Nh3ewHdvUJAV6CSGR83U1uHhIo4S9MMXlF+GULdu8SlIhBR7tdgq2xboAkX/Cuik9wSBpX/LkyL2R3FTKR8lytL7uRhpRlm9cOz4BRezeGtoBkuMk/JBjDuyld1kvrIgQBeDHpT98wswG68h6VOd7tR8hJnmSU3A3A3nU+1489EyedHHbVyZ40vn4tMgTm6nh1LIUmSX/jeFu7czgGyiL17GIlDCrIDN08rPp2NX8D1KutJyQEXOoTrbVkCRLAOeET+W/CO2rLVyCKx3MFOU832Fk7t0v6xWrZx99w52WnXEJXKWtaKMAt/H9oLIk3cU0xNoalQNMuHNbk+sep938AXqbY6Sf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 01:37:26PM +0100, Pedro Falcato wrote:
> The pattern "include/linux/page[-_]*" matches every file that starts with
> "page", because it's a regex and not a glob (so it has the meaning of
> include/linux/page + match [-_] 0+ times).
>
> Fix it up into a more regex-correct expression. Doing so reduces CC's
> drastically in patches that touch pagemap.h (which is maintained as part of
> PAGE CACHE).
>
> As a side-effect, move linux/pageblock-flags.h explicitly under PAGE
> ALLOCATOR.
>
> Link: https://lore.kernel.org/linux-mm/20260422005608.342028-1-fmayle@google.com/
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d25342ca8aa1..224c15299acc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16804,7 +16804,7 @@ F:	mm/sparse.c
>  F:	mm/util.c
>  F:	mm/vmpressure.c
>  F:	mm/vmstat.c
> -N:	include/linux/page[-_]*
> +N:	include\/linux\/page[-_][a-zA-Z]*
>
>  MEMORY MANAGEMENT - EXECMEM
>  M:	Andrew Morton <akpm@linux-foundation.org>
> @@ -16961,6 +16961,7 @@ S:	Maintained
>  F:	include/linux/compaction.h
>  F:	include/linux/gfp.h
>  F:	include/linux/page-isolation.h
> +F:	include/linux/pageblock-flags.h
>  F:	mm/compaction.c
>  F:	mm/debug_page_alloc.c
>  F:	mm/debug_page_ref.c
> --
> 2.53.0
>

