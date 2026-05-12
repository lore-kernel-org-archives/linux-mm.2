Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC84ACD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 12:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5383F6B0088; Tue, 12 May 2026 08:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E8D36B008A; Tue, 12 May 2026 08:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FEF76B008C; Tue, 12 May 2026 08:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7546B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:51:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC91C404C5
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:51:25 +0000 (UTC)
X-FDA: 84758753730.07.0D5D84F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 86663100011
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:51:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="c/RlsusY";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rxzqObN5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="c/RlsusY";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rxzqObN5;
	spf=pass (imf14.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778590283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n52nbh98duZbiXz6dP3xRLV5JP3pfEgj9aRozhxR34E=;
	b=A91dRt3O0vsgtFL7S8HM5w1u4reR59i2F9Cs9pkpb4z3vMbAwfKoEhrymsORzWU6B03Obe
	MUTiCaRYPFg0pR8cnHyU1GVaEZ2t/G9QIbFDtqQ0sAXcDvNKLuAGPUDdX2KIDfX6/Ho5QF
	jDYh/0gQonXy2WWqiodukmWSHykpIGI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="c/RlsusY";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rxzqObN5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="c/RlsusY";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rxzqObN5;
	spf=pass (imf14.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778590283; a=rsa-sha256;
	cv=none;
	b=TZ2d3CxxNZaVOwZM6oVK4GZeZJd8UE7DPBO8Wgzrnr0f9QrI5zOrGVfJnJ2pM8XX3SWIVY
	m6/9kcjIkDlysZ4XazWEbQUxaK7RmZaRyBVLcTGQyirMevzw7LUjuKZC3SWovSfmquwrzf
	nFWeFlNK+Bk9DKVlkMJ2QM/6Y4CJUfU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DB79E6C2B2;
	Tue, 12 May 2026 12:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778590281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n52nbh98duZbiXz6dP3xRLV5JP3pfEgj9aRozhxR34E=;
	b=c/RlsusYjpJc0Whj9npQgFgFhDUsQTZ27RgdKeMxCJkkNFhNTkL8eE6CRNrS6yZsUIvFZM
	QDmVwbK3bn7xU68l70dsXKwPQYhauRvDIKUls1QhCutEF33/kGPkHhqXPCcf6S4SeXmLmu
	0EkjQztP48ez57siRoSAJ2A73iaMilQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778590281;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n52nbh98duZbiXz6dP3xRLV5JP3pfEgj9aRozhxR34E=;
	b=rxzqObN58l+TTkwlmve3Dl4zMycYYl0dvT/+QF/El+OLlqfZ9FclGRur1QyRF5ifoCBvEn
	diNWerpMcWq1jJDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778590281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n52nbh98duZbiXz6dP3xRLV5JP3pfEgj9aRozhxR34E=;
	b=c/RlsusYjpJc0Whj9npQgFgFhDUsQTZ27RgdKeMxCJkkNFhNTkL8eE6CRNrS6yZsUIvFZM
	QDmVwbK3bn7xU68l70dsXKwPQYhauRvDIKUls1QhCutEF33/kGPkHhqXPCcf6S4SeXmLmu
	0EkjQztP48ez57siRoSAJ2A73iaMilQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778590281;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n52nbh98duZbiXz6dP3xRLV5JP3pfEgj9aRozhxR34E=;
	b=rxzqObN58l+TTkwlmve3Dl4zMycYYl0dvT/+QF/El+OLlqfZ9FclGRur1QyRF5ifoCBvEn
	diNWerpMcWq1jJDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D3B62593A9;
	Tue, 12 May 2026 12:51:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2BiQMUgiA2pdLwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 12 May 2026 12:51:20 +0000
Date: Tue, 12 May 2026 14:51:19 +0200
From: Oscar Salvador <osalvador@suse.de>
To: ackerleytng@google.com
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com,
	jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com,
	mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com,
	pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org,
	rick.p.edgecombe@intel.com, rientjes@google.com,
	roman.gushchin@linux.dev, seanjc@google.com, shakeel.butt@linux.dev,
	shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com,
	Dan Williams <djbw@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] mm: hugetlb: Move mpol interpretation out of
 alloc_buddy_hugetlb_folio_with_mpol()
Message-ID: <agMiR7cStqQwkhUz@localhost.localdomain>
References: <20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com>
 <20260506-hugetlb-open-up-v2-2-826a0c5f28fc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506-hugetlb-open-up-v2-2-826a0c5f28fc@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 86663100011
X-Stat-Signature: 793xrtn7wahq5nkiyy9msoarkj3b4497
X-HE-Tag: 1778590283-729031
X-HE-Meta: U2FsdGVkX18zeMuXaS928bi6QufUJ5YelGGRxPFksQ3kfF9/XxkQHZohyfNFuQ5EHS5z8JCycj/YaOjkNs64LOCsAYJVWq0K9pUwTudDdy5jGQHBduAhXCI7Tv3BuNy+Ih2kbIdUcOcyPuA3FCd/gRGBr/glB4RBmL3Zaybd6AKJdmeok1f3t3Ch3kvd3w9Z9XXGL81tXWyk/vIhlA443+fNtOACICtOohQbU0KpXTLhqmsI2t0Jc2pkHc8fyqWpFAsWwUmRFCgB3DZJAZ/fWN2EXgp69tro1V3oNCGiMC1GPCvax9nqyK9kOG3M07ppDcKK3+fwSkTYiK3FH3BDziIn+C+WwhuZpvqbdNUtZJbaCWkehDpIhiUai+WLKE5WevYQqtgMLvcgTr7N3yO5KaTBRoCV6oPz+1gkjuV1egHiKHluI+AbITj1K5lEN/Fwf8lZfwN9r8NmLAEP+/dlyVWMFQvo4NQIaLEHfh2qzMJUNOsuRnMNxj7aoKblFnv2bF+ErN1lj78gLt/1Ya5xVCcp/aBg2pq3XwGfk6BcfMUmoli4KDbV8Ul7F0o6nxz+nptTg1VDCiWF1STlWF6tb+sAI2kK1kYB8wmcWidwSLllnWraGIKNr+tRfGmF+Lv3GFMb5KRihYNSjhFFCteHoSIlsLrQS3XGG9NeVn455SigYsslx+uOnV3I4uOK3fcpfgtKSASgTM7sm/zSp3xoccarSDUg4zcCQxRrs4vjru+wiOytSwXID5FlpmvKg0ySa35dlS5k8x/OMhOc8RFHqhoIoBdFpqEYJYtozI7BHNuWDMUIq4CCcYb2q1VOHC7RGTj5lB5vxzFzwTQMj8jpg6tB/wo2rcOtCQbxRTORNEDAd+olr11MEyFSAUIrpGxYhKT9fWt4+EM1JROYSV19bl5dveU2WR+k7+kw9taEb+f7nBJyljrG9vCguntkT86gHXhsJnePnpiw/zxenHg
 nrhxqXOq
 KTbIbCOtFCSXEtHQWTZdWZ51PjaiKabhBvddntIVlPyrM+NMK+hDV+zpoo8LY09qVTwxjS9b2Me4Z8kTAH/P8fBmzO1X/uGXoCjcnCs/UeX7IcbebQgVRPm3njoDWxS4ploW4ikXa/u9kWJSf1Yf2aX42Qorih9cmqSg/Z7xMvzeHmutnAT6BRL9loCPX8Yg41ARsnb60cvgz11WTEIGIfyEadvmd/haVv1ptzwM1o3BpyTy2e/VvLu9FJTW+G85D/FPpiCAw9zHvrQF2URUqw4FKvTz0m1TuB/R586V83z2erPg1nXCTIKK2KUpQVM8uQfkEzOGYMA3CBMIreQBErrawj5g7o7Ky5JIlUv353hIeFVUFUDaeT/qnAYztyDgF9lbe1D3uD92dHDydy50jXrwmYXs25UasV9IoIkEhh2ZOT+lqfDFsewnMkw2gEK2C3Tb/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06, 2026 at 08:54:38AM -0700, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Move memory policy interpretation out of
> alloc_buddy_hugetlb_folio_with_mpol() and into alloc_hugetlb_folio() to
> separate reading and interpretation of memory policy from actual
> allocation.
> 
> This will later allow memory policy to be interpreted outside of the
> process of allocating a hugetlb folio entirely. This opens doors for other
> callers of the HugeTLB folio allocation function, such as guest_memfd,
> where memory may not always be mapped and hence may not have an associated
> vma.
> 
> No functional change intended.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Reviewed-by: James Houghton <jthoughton@google.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

> ---
>  mm/hugetlb.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 8be246b4e6134..ea3bc405b3162 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2160,15 +2160,11 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
>   */
>  static
>  struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
> -		struct vm_area_struct *vma, unsigned long addr)
> +		struct mempolicy *mpol, int nid, nodemask_t *nodemask)
>  {
>  	struct folio *folio = NULL;
> -	struct mempolicy *mpol;
>  	gfp_t gfp_mask = htlb_alloc_mask(h);

You already get gfp_mask back in alloc_hugetlb_folio(), so maybe just
pass it here, so it is clearer to the reader that these are no different
masks.

 

-- 
Oscar Salvador
SUSE Labs

