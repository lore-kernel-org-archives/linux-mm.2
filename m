Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0177CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 18:06:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35EE76B049B; Mon,  1 Jun 2026 14:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F936B049D; Mon,  1 Jun 2026 14:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FE836B049E; Mon,  1 Jun 2026 14:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 039F76B049B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:06:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B25D1627C4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 18:06:10 +0000 (UTC)
X-FDA: 84832122900.24.3128F9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0C3A01C000E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 18:06:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GZpNh+px;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780337169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MPIfI9k2oAu7CLM7hdDN2drmWMIEsFegPNxwh6nEkHY=;
	b=Zb/MyRmTGusqZxt5UkRWAVoUcnWPQrTl/aV/CRRvIZUK/5NQEnud4C0p/87nDTS25jN9e7
	pLrNA6BXb23Sw6FPPWd4QGquN2Fu+9uDtnudS7Jf9xO5RC94LMX9GWeCPOG0iuKtuexlpX
	Kl0cZW0Xa3qbWFcO2CgbSCYJKmuJ814=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GZpNh+px;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780337169;
	b=4pEfFcqM3KovyLnp8mW8UhVG+vruCW1JgiodfDs757rERGEEmRneF0J4jT1822w4juF+EP
	rAJbntgckL+cqUCxlQ9T4ovzG95787YFqZsYuAC0epCqTa25ph6lh6QAkIGcYGGyG4JN9m
	A4lfp0ydsZa1Bnv4aOH4lyV/IjBXDf0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82954600AA;
	Mon,  1 Jun 2026 18:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B1F1F00898;
	Mon,  1 Jun 2026 18:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780337168;
	bh=MPIfI9k2oAu7CLM7hdDN2drmWMIEsFegPNxwh6nEkHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GZpNh+pxAYEE2fyC60cEj1j/k/7WKOtv6elnviyPut51Cp3Bwg83O+8rFr+aw9//L
	 NUHhdBp+BdH0mdlnvLB3IXWW/SAasUb2Iz+wEjh+MA2eQbSqqwQ6qIVMFjzyzVAwGi
	 PtdtKFQaS6HeqTCYPfjQo3NlXgFy7YTAuWzQbVxPiY81kZRB9ue35+nKj2rNQxSeFJ
	 Eux/po7Go3RMxO2L8q38ORR/f3OzfWHqdETnIoOrZT0ssYSDchjxlUOpqRRgxo7mbL
	 SPWstnIweCSymw20ncdWUtJY9Vov2pU3k8KWH2TAqYnsRNhuL+fWIncxX3D77zDEQ/
	 /WOzowHtk1QXg==
Date: Mon, 1 Jun 2026 19:06:02 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>, 
	David Hildenbrand <david@kernel.org>, stable@vger.kernel.org, 
	Sashiko AI review <sashiko-bot@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	Arnd Bergmann <arnd@arndb.de>, Andrei Vagin <avagin@gmail.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/6] fs/proc/task_mmu: use huge_page_size() in
 pagemap_scan_hugetlb_entry()
Message-ID: <ah3J7SHzUajlY5rA@lucifer>
References: <20260529172331.356655-1-kas@kernel.org>
 <20260529172331.356655-3-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529172331.356655-3-kas@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 3y1f4an8gqfihhy7henz9gn7qeepzb4x
X-Rspamd-Queue-Id: 0C3A01C000E
X-HE-Tag: 1780337168-78983
X-HE-Meta: U2FsdGVkX19/0+H30oot5sgLiHa7TTS7W3bwkDu4lv5l8EEqeTgYlTc3zuI1V67qKssQxNjyFmprNXGHCB6PZFpSu/y5Ky3ZmBGNVyHJTLJMFBpY/APMbPS44hmjAldg559ND+TSULyLssIwz81LxpP9brzHgTAR4OhJ6SZheUEntRPc9rLmCNJLb4weXO8u1B/lYBjOPCbowCH7eKb+4HEBWPXUgFCk89IBQkbbQYvjygbkUbKS/Q6z36gKIQ341JNQtIHL2GRMuyeBniaMEAqRS8aXrtCvoCXH/A3LjIpRithxIHm3cUfB0N4sWVFdtTkvUA3qc9/A8P44qUMWt6hTlDnRcW6CnVasB/umhgxc7a67pi4F9B/cBUJVFWClmM+QYJePN36U80J8jaawCFSRLDMVQIVlZ+0gCiVavWJOmV/wbz3zQ0wJMjBNatfoaD1aeeR99IbSqgYesJGOOYvE/x1UG2FnsiAcXJRMXIO54Fx2gV5Car7mWyBHVRcoHDK7kWsthY+OIaoBgf8UR0TXKpYhWVPrNXw5G+UIVkLeSYHhCiKujPtuVpN3zEkaeYNZKZJkofiyLkQCYO6Xg9LPNfpFDAVUZPhd5zBlraCJBKHOA9pbfZeBQldACzlEkmMnR6ZO7G8wo+XMJtutY6KHJU11SQ/8FuuJpzKp5QuRhf8QlYwxExwPTixH9CQO/0IfrjkbwclGHhXKC0h0011T1bi7/eaz1srLTXLDhGfpVp6LQm4eLSZQph89Xh1E3e+BsYxQ7+vY1b4l+IAPVb5htKQCRVQVlHsFA7q52ozJ9jbNDfVtVKmAdqXZuJfzjKKHb6yazPe96n7M5w2r6MyhL7d8BAR5Y89dTiCFmWhlokVRPEyKKGUw8/sx0DhPAFRlOTgorBCaG3K0JawcSzk7igEkxRtVi38b2SaMcvfKcoQQr/eN9QS11myMXXY4f0J2JDimStc5C214qzV
 nUJWwInV
 potC9hDInny1b8TplP/+q5UEbeMFIgAOUtKjhtnFGdZLQXRHcwQmZuYSO3LZ7x8gy8UqVd0nA1LEq4DS7hxiXbFUki9jULHWwNS9ziZqS6Z2LeGfin72FNrh1p9BFefG6R/hJk8bXGBvdHTd39kg1KrjstKXj9lxnl25JPljZl0W46sg+D+pwVqpC/kxAdcWH05z6Ozd8aBRp/4DUv9Ov1SuXG99kgR6kWYe79eNDDLlTFEkN3MnzWdVq0NobPZIaYc+0owlvaXIIas88cRsrElkawd2mrWagMdYXxsj5wnvCIYNWbeMhECsFo+dZG3sgzGFe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 06:23:26PM +0100, Kiryl Shutsemau (Meta) wrote:
> The partial-page check compares against HPAGE_SIZE (PMD_SIZE), which
> is wrong for gigantic hugetlb hstates (e.g. 1G). The walker hands the
> callback a huge_page_size()-sized range, never start + HPAGE_SIZE, so
> the comparison always declares it partial and aborts the WP. Compare
> against the actual hstate's page size.
>
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> Cc: stable@vger.kernel.org
> Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  fs/proc/task_mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e21a38ac745b..1489c67e88f7 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -2960,7 +2960,7 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
>  	if (~categories & PAGE_IS_WRITTEN)
>  		goto out_unlock;
>
> -	if (end != start + HPAGE_SIZE) {
> +	if (end != start + huge_page_size(hstate_vma(vma))) {
>  		/* Partial HugeTLB page WP isn't possible. */
>  		pagemap_scan_backout_range(p, start, end);
>  		p->arg.walk_end = start;
> --
> 2.54.0
>

