Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7676ECA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D20D08E0008; Mon,  8 Sep 2025 05:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8B08E0001; Mon,  8 Sep 2025 05:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35C18E0008; Mon,  8 Sep 2025 05:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF35D8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:21:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E544140A1F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:21:47 +0000 (UTC)
X-FDA: 83865540654.05.79A2273
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 059FA40015
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:21:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h68OOl32;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yC1RG2mR;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h68OOl32;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yC1RG2mR;
	spf=pass (imf17.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757323305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NdafIhIJoNLsW9ie9RTD+oPomw+G3DtLJRgK9FrfoXM=;
	b=pjbIu2Pofht6YKDI976p+3W8Nckyi4ZbXGo51x/9VIOgeqKbFU6GMv9cqRIe0Pmfswoh3s
	PkN1lesMZh2ANdEVj54hMWMbMaHvUzWyj5g6AAl9xRu+u7TK52It7bGrA836Gsl7MacQ9Y
	B5ZesSXpi5NCB+2AZOlbAtWxsQWaITw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h68OOl32;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yC1RG2mR;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h68OOl32;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yC1RG2mR;
	spf=pass (imf17.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757323305; a=rsa-sha256;
	cv=none;
	b=mffaASCCoBwnemhoQx5Ddc9W+nhUZNjaUo/lSB8DgZs0MUIXwUkPkycElRr0iZLRiXxf4j
	MwZiZ8Wt5+lXco/azZ6/rYe+MLxhJygdtKFSGusLhrC6kYGY/1sROexg+0AezxGaSI2RFX
	qGt7LIb/aDS3alVfueH3HbSqU4WkP3o=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0A7A126738;
	Mon,  8 Sep 2025 09:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757323303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NdafIhIJoNLsW9ie9RTD+oPomw+G3DtLJRgK9FrfoXM=;
	b=h68OOl32LjQxmEzXQxwpsTVOq8bIb2glcsDE2+oFWEij5BcH8D5RMnvszSIL2SyfnNp8Kg
	t+l983mOaj2Ppuq37BO353jrRG/kaCwSn8X0HOCTuCbHBa0scflhHUCKFDtWhjNeMVmVLt
	lq68OpqqJoPYv8/WlpZ0YIQ0DN0+xqA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757323303;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NdafIhIJoNLsW9ie9RTD+oPomw+G3DtLJRgK9FrfoXM=;
	b=yC1RG2mRHdrDLu2khZDzUv9qPYFGBrCTxLrR5K/1zR/r2QU3oVNUll11TPEOlP17Ke/Keh
	oskgepi908wHJNBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757323303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NdafIhIJoNLsW9ie9RTD+oPomw+G3DtLJRgK9FrfoXM=;
	b=h68OOl32LjQxmEzXQxwpsTVOq8bIb2glcsDE2+oFWEij5BcH8D5RMnvszSIL2SyfnNp8Kg
	t+l983mOaj2Ppuq37BO353jrRG/kaCwSn8X0HOCTuCbHBa0scflhHUCKFDtWhjNeMVmVLt
	lq68OpqqJoPYv8/WlpZ0YIQ0DN0+xqA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757323303;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NdafIhIJoNLsW9ie9RTD+oPomw+G3DtLJRgK9FrfoXM=;
	b=yC1RG2mRHdrDLu2khZDzUv9qPYFGBrCTxLrR5K/1zR/r2QU3oVNUll11TPEOlP17Ke/Keh
	oskgepi908wHJNBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6225313869;
	Mon,  8 Sep 2025 09:21:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id P1fzFCagvmgTZwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 08 Sep 2025 09:21:42 +0000
Date: Mon, 8 Sep 2025 11:21:40 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
	jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/9] mm: hugetlb: convert to use more
 alloc_fresh_hugetlb_folio()
Message-ID: <aL6gJPvzXqzrVZTG@localhost.localdomain>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-2-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902124820.3081488-2-wangkefeng.wang@huawei.com>
X-Rspamd-Queue-Id: 059FA40015
X-Rspam-User: 
X-Stat-Signature: cw8kp351k7n9ob54gxexqazunbbrky95
X-Rspamd-Server: rspam09
X-HE-Tag: 1757323304-731327
X-HE-Meta: U2FsdGVkX1/WEFrvf0LBXVQITr5xHevFgXCL0nTOKP1taZTopaQ4a+a+VlVGXG1KThrRsUCgCt/NYFDn76FKQ+v0HxvKiOKZMHIjI0981er8/PGOB0OwYTo14Qcmbou+6sQdt3kYLJcXv+54f7IfcieArv87Oic4vfuQmQJdARo5/Aab1+8DbZkhl8Q17zsvBHoN8QuCAXyBcuSRpwEHhPKRwngoU1rbu+q7oiqMzQmVnPiuFQdjXsNwxgWg/1jriMIPxi2nLd/3EGRkaX+pDD52WfcOMJOMWSM3QFU1vyUT4vsID09vv8/EibWfOQH3GhEfAbHdoXhQ8DIxNeOjo+MbWMUhi5ZMRBxQr9Jey9m0LMYGrzD8RK4HxJfmpqn4Rq7YOMHgNpDw5zR+jqVJH/cuNSXn/8CoEWyV0vctNTlrLLnsaOkrbbCTGe7CVam56zNG+jilFsnKQO/1OmkjfQOBadAUaCw+upn4RqTJdkuFOOHyXxHyyPz2ex98OTozJGWfEcmw0M5+sw83gbamuxhwD+c6kIh1PWdWCYZVkSnrQ0zkviUD7QFckayhceeL/eJdul4EtFdX4Gk/7Qq18WQMjN7u6lPewypQqQZJb2wmNEDxVKTuguiOLJ/Hyn1Vfq/kAG38ncgElLjVOwk6vpG0axt3DbQ5W7RiHIUJr1ywCwqTJ5yyZxweZPSVeMiCg2sOlgTLwp4YePnPx/v2Ri2QIUxzjMqW95pizWopqxC5HLryqCEto47BNB4Ru2F+WYC7dad/5l5p0g39zWD6dsTjXsWK2TuvVAz4eMNCOFEG3zcPezCQz/6v7uCy6phUICL+XSX7JYZ7Gul3KVyMOEpTJuxFsY+79P3acNnEJOP0F9S0yp78A5sXFJde8/7Xtdq6kWf75vu+Y3fJ0Y56LZiBGUUDSjuiJQo8O5+13E3jw1xWRySfjAH2hYKx6wyglwqo8RbWv3JyS8FdAbR
 zo+pMLlE
 GClNwrkaC4W/dIWgEvYgsF0THKJeuahgytTrzrmBQeGhdqbuCjOMywGmiQ/xfVaFE2aQeb3CK94uS8AoPZj3cxm8PBoAY9QiHXCtpVfD4eLN5lhvdbOiEuriF9EF4PPhL9TctFIbVCKHjPRApUL6LFYf6fRZSaVnVK0XlCyIW7UnXNlauHso/x72zMoew/PLjP29o4ZeEOpaKrmt2gVN7O7MeiSAcNNGhrjHpUhOTxmdzReAy1pw9EZN/5+0LGIczOg2Nd0YY8XofyjntqAiFbgBtjITJidWu+0YZadfj5FxS20eCi4ukCcNsBRLfVA10b1Tv9axxiUgnWrgHGlEbufDW1rAYlc9pMEv8CgSro+kZgkE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 08:48:12PM +0800, Kefeng Wang wrote:
> Simplify alloc_fresh_hugetlb_folio() and convert more functions
> to use it, which help us to remove prep_new_hugetlb_folio() and
> __prep_new_hugetlb_folio().
> 
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

But...

>  /*
> - * Common helper to allocate a fresh hugetlb page. All specific allocators
> - * should use this function to get new hugetlb pages
> + * Common helper to allocate a fresh hugetlb folio. All specific allocators
> + * should use this function to get new hugetlb folio
>   *
> - * Note that returned page is 'frozen':  ref count of head page and all tail
> + * Note that returned folio is 'frozen':  ref count of head page and all tail
>   * pages is zero.
>   */
>  static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
> @@ -2016,14 +2002,9 @@ static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
>  {
>  	struct folio *folio;
>  
> -	if (hstate_is_gigantic(h))
> -		folio = alloc_gigantic_folio(h, gfp_mask, nid, nmask);
> -	else
> -		folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
> -	if (!folio)
> -		return NULL;
> -
> -	prep_new_hugetlb_folio(h, folio, folio_nid(folio));
> +	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
> +	if (folio)
> +		hugetlb_vmemmap_optimize_folio(h, folio);
>  	return folio;

We no longer do the accounting in the callee but in the caller, so it might be
tricky to grasp why.
I would add a comment above after the "Note that returned ..." stating that the
accounting must be done in the caller, should someone else add another call to
alloc_fresh_hugetlb_folio().
Hugetlb code is tricky enough, let us make it crystal clear.

Thanks


-- 
Oscar Salvador
SUSE Labs

