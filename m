Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6B46CA0FF0
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 01:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A3948E0110; Tue, 26 Aug 2025 21:55:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054BE8E0105; Tue, 26 Aug 2025 21:55:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAC688E0110; Tue, 26 Aug 2025 21:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB3338E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 21:55:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77DE11403D2
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 01:55:20 +0000 (UTC)
X-FDA: 83820870000.26.AFD4868
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A454518000B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 01:55:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0WJrdMh6;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756259718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1PdwWXYuxlv1SPStlKPFQx75A31pS8t4AfppCzpHIs=;
	b=ZLdM940iV+w91aDqdePfPlwFt4dk5iIqiDPkKt932bhnnp9svHxwnlQ/Sah5x68UsPk14d
	OsytGVOtPVYPoNEmnbqid9SPFD0CKuYpq+3ycmweXsyQ+o4Ydq6BKaerDbDcFMvqpYHqjv
	gQoWAzaYz53+O9dJJeNJWubDClZYj1c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0WJrdMh6;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756259718; a=rsa-sha256;
	cv=none;
	b=GuUYJSbOL/A/zmstOTO5ZJLvEwEK0KWKCOcX5krXUCvb9VqcdJrCxo5T/TCjpLVRdTnmJ2
	YobsjsKRHh+JdV9A11u/jO28/Xuwk5EQ3uhla+DJ+S91J5xW/ApgYf7N+k8jVQQYXIjrdV
	ghPxXJ1bAMVyHt6JNRJ/h1Wvo6oefTU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D1B043F48;
	Wed, 27 Aug 2025 01:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7AAC4CEF1;
	Wed, 27 Aug 2025 01:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756259717;
	bh=8kSO502PchRJBtbzZNCGUNI1RhzLxJ8K0FrAi8MjFDQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=0WJrdMh68pL6xIEhKiLT42vG+Nm7djlhAg7FUFOKgps1Y3YH2sGxdDBujOgJugdtq
	 HTWD5+P6LV7lpdfWMggnwyypB7eugBmlIUAIwODOX48olsgeGvU2/xbboXaC0Uniaw
	 4/NgIFbYByD6+CmmSHvSpaRntHMnh1Fi4KI6ebqQ=
Date: Tue, 26 Aug 2025 18:55:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
 bhe@redhat.com, chrisl@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] huge_mm.h: is_huge_zero_folio(NULL) should return
 false
Message-Id: <20250826185515.7fbe1821713195b170ac1b31@linux-foundation.org>
In-Reply-To: <20250826231626.218675-1-max.kellermann@ionos.com>
References: <20250826231626.218675-1-max.kellermann@ionos.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A454518000B
X-Stat-Signature: z8ni9eyh8igdo6dsxptko6rdmxoy3gdf
X-Rspam-User: 
X-HE-Tag: 1756259718-381800
X-HE-Meta: U2FsdGVkX1/WZxCURCPC7YGymjniM775U2Gncki5/3XHeTZJqxSGRcm+P0FofFK3744wnYGfS+1O24aZXoxohvW11UnjG5quXjg1a765dsoartvie64HdpNFSC1j8DvElh/GmeF6LK0o3csfKOm2RFrkaTow2I/itqkMdwkCG39Xey0W68BgFvr1RD4jQ1hkzl8LNPaZXewNPEEw2KJlqqv1UWrgOvZ2IxDDZMplonUiVAuYl+FpcLZx8z5mie05wgMqTkzVtbrG7Z+QslYe555Nqhv66Q0AJnDzz4N8xr45GBU0cSRe4N6VhRnu++aLDgdaXlWgG20GH1VOwL7koDwQo6NFEfNYqpIxzKQ6JafsVN+McGpT3V90Il8kmwFmliU+vvhnjKjIM6/1lDoNf3ICuuujR/uKf+9ZOXn2mRzMw5HbRzg9yGDTR3v2gpJ7hyZdVuMxiowRZQP9oXq0hS0R4hB1tQ92ByqIZM/Q/yp45VSnw+xcNErYmcy2gpvGoJmpXO+YMsVenEWBp4XkNXs1QGESS9OQAHcOxK6hgvkZjxikobbSsrejy7LFq+YebYr5dZR0+pI7oCBZy4bIgROQJABd81cnR3PUYXpwAyCz8fMcbOXfGG4Zbkhky2tMlLKzcYi+TbD0gz3xQbo1daJoOtBGBgLBWKpviaC8LFNIcWmYZmqocn2ZFVJBzpNXwMFTrJ6hNJtU23LrRB7V0RlvQbi/E9Ka/2AkYy1gypcOuzHCbA8EGEGsOX/73AJIlTH3fvuBKAhXbxAQgB6uSEVvMyz3D0dIiYVmaLzLo37bXImHVZC0kRiOqUSBtjoD1/xDJMg2/bYzmQfr43/mtKlCyT7YH1OLm3Nr75DUszG3874GjFW7bpENtnXPhiZrIW3nSKJjeRNw+hQndCsHEo8i9tamCJzymdSwnoIy9dDlRjWzARSFkz+8r1tH6hAzofK2A5b+jp9CLy7NHpG
 EymX7eXd
 MwW5V0OkeuisDufXRDnNs2R7Qp9ehqkuSEhz9memp7iNTsiINivUf8QILDVmVV/IBo/GUP7UA6gOKDtcyv/rpIRQOpDUKxjDRgFUVNbNGySdzr5rUoC9jKeiM3emrQuwakXjYhzqDJ6mBQDV5JETjUw0ziQBtds4ooEowKyIHEsqo1DrfziG2bgPlUjAD6IpiVfjo5vAvtzUQ71vSJukn+CRS3O+WPCOA/RJ1/cXRQ9KVtftp8M77nraTxRl2nKgcYtc2KgEa8IuFPHAgD2bXzyicZ4ttsupjZnzVnWbeWwvVuCjrBtKM46OyhZlIHoWrHySqZCJVSEu8CkVMmnoa1nCkWv/QvdSM4OZAD6LN3BlDtko=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 Aug 2025 01:16:24 +0200 Max Kellermann <max.kellermann@ionos.com> wrote:

> Calling is_huge_zero_folio(NULL) should not be legal - it makes no
> sense, and a different (theoretical) implementation may dereference
> the pointer.  But currently, lacking any explicit documentation, this
> call is legal.
> 
> But if somebody really passes NULL, the function should not return
> true - this isn't the huge zero folio after all!  However, if the
> `huge_zero_folio` hasn't been allocated yet, it's NULL, and
> is_huge_zero_folio(NULL) just happens to return true, which is a lie.

Isn't it a bug to call is_huge_zero_folio() before the huge_zero_folio
has been created?

Being a simple soul, I'm thinking

	VM_BUG_ON(!huge_zero_folio);
	VM_BUG_ON(!folio);

or similar will settle matters?

> I believe this is a negligible corner case and I don't want to add any
> overhead for this; but in debugging kernels, it may be helpful to add
> this check, therefore I put it inside an `#ifdef CONFIG_DEBUG_VM`.
> 
> This weird side effect prevented me from reproducing a kernel crash
> that occurred when the elements of a folio_batch were NULL - since
> folios_put_refs() skips huge zero folios, this sometimes causes a
> crash, but sometimes does not.  For debugging, it is better to reveal
> such bugs reliably and not hide them behind random preconditions like
> "has the huge zero folio already been created?"
> 
> ...
>
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -479,7 +479,12 @@ extern unsigned long huge_zero_pfn;
>  
>  static inline bool is_huge_zero_folio(const struct folio *folio)
>  {
> -	return READ_ONCE(huge_zero_folio) == folio;
> +	const struct folio *hzf = READ_ONCE(huge_zero_folio);
> +#ifdef CONFIG_DEBUG_VM
> +	if (hzf == NULL)
> +		return false;
> +#endif
> +	return hzf == folio;
>  }
>  

Yeah, this all seems rather ... complicated.

