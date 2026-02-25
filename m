Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2071BF55449
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 03:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02CBD6B0005; Tue, 24 Feb 2026 22:59:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1CEE6B0088; Tue, 24 Feb 2026 22:59:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E28F66B008A; Tue, 24 Feb 2026 22:59:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC2D66B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 22:59:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E56E16046E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:59:19 +0000 (UTC)
X-FDA: 84481624038.05.16F20BF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6660C1A0011
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:59:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="SK/eImto";
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771991957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u91RniVAY4w/S1lsK0JgZKyctLf5bLCFqmMYO9i/oc4=;
	b=p2TXN3SEQr1eBDCBq/n+PNWlvnHL3G+ZoztWideipDckIM1i3Om5SjmiybFGWvctdKtehP
	+tN8UGnVLc8gFq+CF+dTok2n/BBUkpTZxK6nA4hRJsrAg67ji7GrPkv0fcp36djuhDVeeh
	z/0g+sCfgMF8+8c+8d72wp2nOxICaNM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771991957; a=rsa-sha256;
	cv=none;
	b=OAZNPiPE6vCk3F5M8EaQfmNR3HdqdMhDvlO5Nxg1QrYLDRWf0ihNaHxrvZHDmrVc6UNTI+
	49OpCJRBPEhIuoFcacFzxOkJBUcETFbWdr93J0lwbzB6sxZbyOzxMymWvPBkI8LJXp8Tag
	+qg7Td4T+rfWRPxQjuued+vfMSsm7wc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="SK/eImto";
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=u91RniVAY4w/S1lsK0JgZKyctLf5bLCFqmMYO9i/oc4=; b=SK/eImtoTmraU1RBu0e5YrZH5k
	Ma/Bo/nGJwG1rFxceN99IbmTc52Uia0MKxFRpVAAOTeC1HSWZLlMyn0vV/IfuKaOwPU11zw0Q647R
	5OWrjaB5WKdTumkyMeJdCxQdKCIufSePHgi3fcEVXR7wSzMpnOUzbWCuIChAKGLaawfwTBhKuquUZ
	GTfaO1FkwTMYVOKJZcgBY74IKibc+xO58VuUAoK0R2EIysoZS1ZPIzQYd27mOV8uJ2bKCdk6eEj0D
	HxseRazeb6LWtfEUFLBaOMdXFyOrdtyxkj3uumh+ZJ7O4SjF9FWynkAddoxnicZLVIgS04hhkPZqu
	agytE2gw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vv63I-00000000OwB-1kXC;
	Wed, 25 Feb 2026 03:59:08 +0000
Date: Wed, 25 Feb 2026 03:59:08 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] slab: Saturate to SIZE_MAX for allocation size overflows
Message-ID: <aZ5zjIpYZYoc-LSX@casper.infradead.org>
References: <20260225013954.work.319-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225013954.work.319-kees@kernel.org>
X-Rspamd-Queue-Id: 6660C1A0011
X-Stat-Signature: zd6ynecypppuqep5ougitccu4kidsdg8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771991956-179511
X-HE-Meta: U2FsdGVkX1+Fa6VzY7RI468T97QZ4eEcy95I/3TliRrGB2oKDlE+eWwScuB4KTxFKEsSmb7tGdAptROYVhv6f7yn/F+7xUqubi+fsrb6+KRNy/JXlkDbECkoNggjNQ7oiAebi8MMUNMLqnxGOYpxjVwQQl4k8xDHubew5qJC2nfnpGRytnbiis3MbP95foPPqP91SQlmjD2XKUBCpi7oJRutFTnLaoOL1q0hoCdyVpSrpBbBzrayBoq+Or0LwYgWiG0YqH8bEqTvbxGkzVPJgqer9FrlS44DiH+9H0M9pjhilqztqmjcdkzFPNEb10D7pvY1mWrGEMIQyGUtB1ocflDG7CJPZOAG4AcPYBEWpvHlXOPfj8Chzh4N+gjje8OlBVHDug2T92VmD6oygI61YpJQP5Fmoeur1ibGUt6k74lw9vi94lSUan6bajhxgiry7WCsOeqp6nPmL3NRRREY6UVKsk7zjlhRxmg8N96iFwgDS7VRBqvRQmkx5HXdSO3QljbFxT2SWadIOlcVM9XgtMf/xgipMwiHq01G29DAOeloCrInfFELazd8+SMhSHOTU++Emzn4Je6EB/ZVwelBiCvjBb/3efDxr0K+y1/HBKweXs0V/YZ6MQqAfCH5Wy/daOHZuOrKKFEiy/7u6LxX4yHeBi20pC54KsHsSfW6TG143rxxwVIyu1FBND16roG4YNAFb92Pf8PTjKGSc7iossl9YkI44iXtTvdJAEb7MyRpBRtwC4aHahmS0h0LafjZGjiHP/nxKNFR2rXwUcQR/AgTmjmWDOtT/6uxa0frPbP2rlxTuSP+HiNYbJqC7jnYjCOSRBpzi64xdYxeIGUG+PrA2rIS+l9y45lcczxEjIv93/i4dlJwpD3h/TPnT5H72aaKqieSfAjorM8xn8lztdwV8IbizvU1wHpJWQOlmRGYaHOPUEawhlNc4Y97DwcXm0IoGMiEVyKsnMLSvvU
 7LpfJE68
 88bRp13/iL0WiavU1UOoGpj/gl8GhiymUfcef1pDemQA9nJDdzFKSuFuqVbIhAvC6LiT9xvVotDWP4OsMk+EhiBawSSvf3LAY6lwDgeDerbnUdeA9+ruS783qxrKkRGstWpLYSTzhc5RNmVIJ7PCzitekvStbTyycQtaeRjio9mcTpsnYdgnUTQLWPejM/zjd4DeWIq3q8Xys8xsjehCMW0Vo7LTfywP4A6uxC/hbOkv5y+VmtlAMvPFfii66LOH3ogea4haKZOgyp54Kt4fNB+RvG9H2UQruJFBJHFPOJ96AtpSo0lxo7mc0LKH+rP5APGlb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 05:40:02PM -0800, Kees Cook wrote:
> +++ b/include/linux/slab.h
> @@ -1105,7 +1105,7 @@ static inline __alloc_size(1, 2) void *kmalloc_array_noprof(size_t n, size_t siz
>  	size_t bytes;
>  
>  	if (unlikely(check_mul_overflow(n, size, &bytes)))
> -		return NULL;
> +		bytes = SIZE_MAX;
>  	return kmalloc_noprof(bytes, flags);

Wouldn't this be better written as:

	return kmalloc_noprof(size_mul(n, size), flags);

(etc)


