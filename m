Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B31ACD98C7
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 01:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B5B56B0005; Thu, 11 Jun 2026 21:18:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 966946B0088; Thu, 11 Jun 2026 21:18:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C886B008C; Thu, 11 Jun 2026 21:18:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75C9E6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:18:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C7CE1655B4
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:18:35 +0000 (UTC)
X-FDA: 84869500590.23.B5A84B6
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 492FE14000A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:18:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W6CnD78p;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781227113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njxNq3hwRVxN/lbap5PGlQkdMVNaPFVAUzcLxbSGsSA=;
	b=BQsUKswOOUXgbeslOrJsG4OtBg60WACKQW5/MTPFgCdun0A7uzogFubOb5PFgNon54GRDL
	4hPRpNviL06MyRfQmiwsoXiy6RKtxH6VPjEX1ZJISh4T3pzGZKTk4Nzce0j5yzQXvHhILU
	ePYiCFg77fMowTitcPU6I5+287QWPZo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W6CnD78p;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781227113;
	b=UgKTK1HirihC5eSJvoki1GHHNZ2k0a7FG7OLOstZPwUcpd2VaajkaEH+CO1BYA/22V+YxZ
	9c3wx0eXAwZjzq4p3klOPctrnGc2usM9L+agu7OC5A7z/h/rMZhSAptKWptSiVJ8NoZxgJ
	DWaBsqZIssNSCt0/xWZmKshtSXR4vLw=
Date: Fri, 12 Jun 2026 09:18:23 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781227111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=njxNq3hwRVxN/lbap5PGlQkdMVNaPFVAUzcLxbSGsSA=;
	b=W6CnD78pjnIJvDPa8/MfNG9GeRM11voNki5R/hxGqh244Ns3iLOCIfsArwU1EJdezYowQp
	/ug9hjNnCoSGsBJJYKqFZHOrxbQ7UE2y/H+P8EzQfDptRIU3vh6Y3ApJOvJMt+0kTolnv7
	0SACJoUjCc/14QQa3eWaVb8L6ZGUmNA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	youngjun.park@lge.com, jp.kobryn@linux.dev, usama.arif@linux.dev,
	shakeel.butt@linux.dev
Subject: Re: [RFC PATCH 2/3] mm: drop stale folio_ref_count()==1 check in
 do_swap_page reuse logic
Message-ID: <aiteX2vL2_1iZ50e@MiWiFi-R3L-srv>
References: <20260611105124.98668-1-baohua@kernel.org>
 <20260611105124.98668-3-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611105124.98668-3-baohua@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 492FE14000A
X-Stat-Signature: uxoebxpwi74adbra5p3amxo5z4orbcj9
X-Rspam-User: 
X-HE-Tag: 1781227113-832584
X-HE-Meta: U2FsdGVkX1/KxjIm15xwH1w6f6k0NsZE9971GRHPN6XlIPqbx2w6e2hEAvP5Hz1UhvQ1dUzbXoTH6EH09WiZ5fYDprqdjaukoBRMrtvOoV7avFaCTD43JJM9BRmsXRnuJBWYsYRgY8+X1+rDnHdxR+uehBHMAK/NmYEgb8hkSW3+IZlNU8Yrb3W2x098LbAd/SjZTJK/QX+QlpHcF3NwJ4MevYAKmKT+EBnFbpzVYDQFLz24Wla1Qumf7AnYew+kmWZanfKo6DUuAkXy3f/NaMQT/GAFghd6I5xCLyTJKg3paHXjHDrkGmsILaIjy5kDjvirHcYfLhZbHAwbk/jgbA/Yqi2IzWe/JYHA1L4ZX7UHZH9RAqusxHjQYIZEAfXTquzYi8YoRCVKcAPpWOphSXmqaf6Jr0PTDXTNf+rJbK99Ou//Z64X+BxRZzbEPkbaIJAQDBDJLWjQW/ob6X91glIayltFBiwdXhGgp+c9+/JMdc/WPj11vnPEy+V6lHin6O9NQgKmx7kyize2Z4tL3r0UAJ5tjefG5KYoA1/BjKfeUOJPCOK3gozRaEVdE/DYD5TF6gbAsh7iO6F5gyhrgxo8oxNCJfESp7KOfz3NgH/zKbLDpDV2Xkf4TTlQVd/lZHpUKMehUbBV7EjzQkw+0UM77gbI2XNETOJwKVvSdaQSc6IrfKoxr9nxkYIH4IqeaK1WH7NZ+Kj2ZcNlSaidlSJDC8HkTY5elpVpDasxEkSVV4xqYspuaRkYI5I0r82iQtsbGQkihf+sSMUpWqYdKXPlyJr9b5MfPtQxvCiIM3Ha8AckWw9exhAwVToCDLnUb03IY4OqDSMNa1pq26O7o7wldRvrTX9LJNshFQEIugrnxnlz9aFg+AALGcJM+Z578oLSw7j5vqsiNpJgqwV1y0d9mZyN3JMIE4rHnNA6oV6E8uizwU+ZugIxiyqE46+ZaLc9q+qnawEzwJGS9UH
 dWi9o7Fr
 My90zk9tigh3upAGJpq5G4Ni07ukYIdGyW8i1hWViNqzO350+1xp/tGv4rqwYNaOfMTIHKJIqa+MjYxEE2poYgY0z1LoXjteDD72szESJXl+rqZOMSk0Yw3moYUeHEQRF6qF/4FAdDXEjx4Fa2uDsAtJqSg8wQS0Vpw1jM5IAlBw8Bz62est0ry2ErbOgY4ovFPFdgCOLQdWm8vOh0psyHmwjTmGiTQp6F1e/LuH69GM6IfBSKVIfd1fVYAr+TV0d/wRinVuPvORS0M/af/jUHIsJD7OPFW8yFdb9EPoIG+jUUTGdx9ch/G+BvqP07cKjtrSxq6SFlKfiQY6IjYy5pgnfpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/11/26 at 06:51pm, Barry Song (Xiaomi) wrote:
> The "we just allocated them without exposing them to the swapcache"
> case no longer exists, as Kairui has routed synchronous I/O through
> the swapcache as well in his series "unify swapin use swap cache and
> cleanup flags"[1]. As a result, folio_ref_count() should never be 1
> in this path, since at least two references are held (base ref plus
> swapcache). Remove the folio_ref_count()==1 check and update the
> comment accordingly.
> 
> [1] https://lore.kernel.org/all/20251220-swap-table-p2-v5-0-8862a265a033@tencent.com/
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/memory.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 487a34377a7b..ce8ef27e7a54 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5049,12 +5049,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  
>  	/*
>  	 * Same logic as in do_wp_page(); however, optimize for pages that are
> -	 * certainly not shared either because we just allocated them without
> -	 * exposing them to the swapcache or because the swap entry indicates
> -	 * exclusivity.
> +	 * certainly not because the swap entry indicates exclusivity.
>  	 */
> -	if (!folio_test_ksm(folio) &&
> -	    (exclusive || folio_ref_count(folio) == 1)) {
> +	if (!folio_test_ksm(folio) && exclusive) {
>  		if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
>  		    !pte_needs_soft_dirty_wp(vma, pte)) {
>  			pte = pte_mkwrite(pte, vma);

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> -- 
> 2.39.3 (Apple Git-146)
> 
> 

