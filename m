Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8734FEEF2E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15E156B008A; Tue,  7 Apr 2026 08:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 135B26B0096; Tue,  7 Apr 2026 08:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 072DC6B00A4; Tue,  7 Apr 2026 08:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EBA586B008A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:31:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9C9FBB23E
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:31:36 +0000 (UTC)
X-FDA: 84631695792.17.580A572
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id CAC66A0019
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:31:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tJBRVKfF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775565095; a=rsa-sha256;
	cv=none;
	b=F5Mpznu6iRMIrptE79/ZKMv/0H8KTrM4Fa1ZpdDlNKpUPvywVIceo/4UfxV2cZQsJW/PN5
	+oi70qqpTP7rmd0fiYLjqzDqqIIpH6nGaPa4405RFZWK/YwZIQKyxB8Wo7Buje/I+wD4+2
	ha6oWhppYHGWGItAM9fv/WQScur17UI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tJBRVKfF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775565094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEjfMIH6lS63OwLDQhNEDQZTo1InW3bOdQDRc1KyeWA=;
	b=6W4Pp4bbrRgQJYk7zUlOT5rX9OL+7TTnftkLm2t+m1ztDyOaBNzfZQh37AjCqbbokpO8G7
	VB2bnBT42e4wxFOU0GVDXirsFA2DQz9OWft8hOIDNoWN7zfh9eerbcy1wJtfpmGNYPMTA8
	ChfvC8eKWlnQ3E6TuEw/sFxr9tsJNdw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DDC4440BA0;
	Tue,  7 Apr 2026 12:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8B5C116C6;
	Tue,  7 Apr 2026 12:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775565093;
	bh=uXvcg5sJLC+eK03dHFNMpWZIrpXMMbGikP4S+/FgjNM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tJBRVKfF0L1uezM+e4WlIh+Fu9Bn9rNd0N+8Mx5Sa7ssA22JuTVgYp6LQnkpg35cm
	 Vm8Jrio03albqeEPQ6XLN8594llQcBb+n+pWMbTbwTrFOJFr7hlz99SEwVhNwOjYb1
	 vi3AIsJ4ueNVNursxyCpKp298ApV1r1wJ+hU1Be7B+jM980I7UG5+iPs5w1tvkXZQN
	 ctIIMltsFVcm029t4GTlsOleS5vNMVzgV6VoPjsr3N2s+y4laLgzM1zaRfWJTYqiNG
	 zQIfluOYDU8ajAZ41xLFon4dk2/gtBNFu4vo82K0jOZeG6i4gqkgVfjfJoretxuY55
	 2BeBCkALb8Zmw==
Message-ID: <e4f0923a-f2c4-497b-895b-4e83a09b2f04@kernel.org>
Date: Tue, 7 Apr 2026 14:31:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm/mprotect: special-case small folios when
 applying write permissions
Content-Language: en-US
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>,
 jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260402141628.3367596-1-pfalcato@suse.de>
 <20260402141628.3367596-3-pfalcato@suse.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260402141628.3367596-3-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: neensbcm1no6uz4o8k3kek4xebykfd4f
X-Rspamd-Queue-Id: CAC66A0019
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775565094-875305
X-HE-Meta: U2FsdGVkX18mx4h1jWwQ9UK96Miu7rFKQLvWx2VimE1VuJ/jUECB+Ecuzjmd5bZnxBgIDBLP85DqEHdLvio1XVE0uivhHVmkU3g4MNwhwAragrzDs70CKre2t9Y4aShEv7x7wqdMP7AFVo4G8cnvnCN796V97fsSIwhaxjGPQ+2g9kg2JAXklzWuJx2FqUL/TAfsQ9aE3Eb0dxnzXyvfMZS4+J8x4Cs4hqzh16NwdxRkgQUKxQ6t72H3GeUnTdF2xpNZMgp2gmk8JgCtFjP/0LyKaaOd6eAZG+Che0t/8OkchGrItZp/P3QXpZojxIUh6Dud5/hoG1vPdf9d3ANjqFeZzqzGHYm9EyF62VCSAVx05L6q2+S+zUWTLUMTIkleHFGqX2u+H8qx2lVCxoYRg+Ln1Eyxd2k3GCDkK+mVHRE1W4VkY1PNQniJ41vlhvVN+5LzfU7BR/yEtJCirUlVF1jzbVjf3kCwxCUEWC4g44Z/eYEC/v/j1a6K3+blbPMvIhSAj0/A/RRsk0ZT3z3kKJ5vp6lj92/H19gTxBLvpaJbTAXZWZwkh7FEp113YpRBC1ckyy8K0nnqA6NE4gvJ+ovsg60hjuWbdXm8cEPoWpE7IIe2HZEAPUdV9z3Kl5xKSH0nzlnn4Yj4GbD3n0p5tAtUCo8I5Si5/3s6v1BqJ0dXwHRtaxYGj+33yjik+5F2gwKCu0HWQpu0A38ScBNoCYvhJpMI++KwhMWHh4f7HKysnHcl69Vzx0EzoyYflByClwtdKkzxjAumoZrYTzvUcGBZ2T4E9UH1t+m2dlwHi4Nrh6PMBaAcCXhb7wvo1OB4Wn4gr1Db/pMBYWlBSGnAh7aRL/JIbU5KiXmts30P190sMtqXmqvO/uqcUqpLn4hSOvbuJ4BS+vksVTEbL58OtpJhwi1vg1NxrFFenl0+o1ZNRGXz0xQ5gQdYwIDIgyrQ9qEzSVaD627AeeaNxsl
 +3/QQ8TJ
 jnOeNK0y1jl/TUwcaNAUw69fiYkGUmHFR2tLUWGL7pj5d/eQvvwWzHdern0JjCA3wZVOUvxSxBXJHuEff6gGnp/QgACu5F48a6QhPNbbIctM83Gi6FOsinhVJ/fQDjWJN9Rp2OABVbKvIm0z4jHaaj7F1NhrfsCaSpn9Pscg1+r9HeDF7P7mDQ6sRfdSAQueJfYAup/uKDiYduUfeTiOp0ybL0A2bF55Ed6p4lBHs8PdNxYWJELZPtJhJI87gu3YHZrT2G56NzBBqE6JCyDRQYTnQdlzGVMbVwFNVaGqD7AOMseUwg4zwjkrqOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/2/26 16:16, Pedro Falcato wrote:
> The common order-0 case is important enough to want its own branch, and
> avoids the hairy, large loop logic that the CPU does not seem to handle
> particularly well.
> 
> While at it, encourage the compiler to inline batch PTE logic and resolve
> constant branches by adding __always_inline strategically.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Tested-by: Luke Yang <luyang@redhat.com>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Can't say I'm thrilled about these hacks, but seems to work, so

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


> +			if (likely(nr_ptes == 1)) {
> +				change_present_ptes(tlb, vma, addr, pte, 1,
> +					end, newprot, folio, page, cp_flags);
> +			} else {
> +				change_present_ptes(tlb, vma, addr, pte,
> +					nr_ptes, end, newprot, folio, page,
> +					cp_flags);
> +			}

I wonder if there's anything about this trick that ensures the compilers
will not eventually stop compiling it the way you intend. Have you talked to
compiler people? :)

> +
>  			pages += nr_ptes;
>  		} else if (pte_none(oldpte)) {
>  			/*


