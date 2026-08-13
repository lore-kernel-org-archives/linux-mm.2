Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ADB6C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F32D46B0291; Thu, 13 Aug 2026 07:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0AF06B04B5; Thu, 13 Aug 2026 07:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFBFB6B04B7; Thu, 13 Aug 2026 07:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B24F56B0291
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:12:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4100F40637
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:12:44 +0000 (UTC)
X-FDA: 85095983448.03.AE3DC1B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 208C014000A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:12:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kY2wbE5r;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ira5jC9D;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v2v3Y4um;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HbbWXBnS;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786619562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aa5PQgPbsqDszH92WC8ete6hlLLGfSpkDZEGTbMUJQU=;
	b=a/ZQ5wWBHjPfds/KghwtCe4kDWsAGqFSfXN0DWfPU36U8uyJ3ol2T9b4eV82OhSTJSYogR
	70WRSkUUQyVXUHzlwlRl3cqD3F0GqW4+YX2xFrPjwauWDW+faUrTFhg1WDjMo3pVXVWqXV
	n/KTGngr3EYnOBKIb8Mz1zXteLBqUTU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kY2wbE5r;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ira5jC9D;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=v2v3Y4um;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HbbWXBnS;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786619562;
	b=MIlFReDsnJi2gMPSiKdkptreK7N2SlGVrJYrwweWOJgXG6DR9gIsZSRecp10cOgRnxX31Z
	WYfZzAO4Cr+Wc8rcAPCjaPCiJgLJbMd53Vkl+R6lr0vNM3ENo7OZfnNI4mMkJIUGMUOCj+
	U+hL0nRdVYy/vh8EkKhUnwGl6BpvOZs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A39FB82830;
	Thu, 13 Aug 2026 11:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786619556; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aa5PQgPbsqDszH92WC8ete6hlLLGfSpkDZEGTbMUJQU=;
	b=kY2wbE5r6cXe0EoMl0im0qrCP+AWhn41XgI5gPf+3V1JKAj3sQijqf/WaY3diUJaywT57k
	XUai3bMxApx/+EN/MJPpx+2IA1glnWMNjHLMP2TWLJketr0R21OEqBbWDHvyOKGJ6THA6r
	CtAII6A2yZGliaEyS2DpDilkv9KPDhE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786619556;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aa5PQgPbsqDszH92WC8ete6hlLLGfSpkDZEGTbMUJQU=;
	b=Ira5jC9Dvm6/shLPPo+mCN3mXLTgX4KAuoT9AhXa9m8PI6i1Jcy8sL/uVs66eXEw2uPxsw
	gRNxR1zBR1FxVMAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786619552; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aa5PQgPbsqDszH92WC8ete6hlLLGfSpkDZEGTbMUJQU=;
	b=v2v3Y4umHePZxuEqj+Vl7Or2jsmfXsPQEuJXVPQSgiS45ELzFwDNxXUH41ei85yIt0jDMQ
	gNx4eLnaRH5/F1/DhfPwVsIH2eqy78rwFkQeo3GAJgYFqhi8pCJeG+16uxYims+199Klrh
	6OdKH24cAOFlUCX9i5NMBjWxfnFrki0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786619552;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aa5PQgPbsqDszH92WC8ete6hlLLGfSpkDZEGTbMUJQU=;
	b=HbbWXBnS2zCjw2vuOLJyoNv0k/KWIE/HCHGaVgzox/FbbPpyBneHy7LRKzzj/Ghq/g/dm1
	UObDVcKWVfTFUyDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8FCA77DB2;
	Thu, 13 Aug 2026 11:12:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QWXbKZ+mfWrWCAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 13 Aug 2026 11:12:31 +0000
Date: Thu, 13 Aug 2026 12:12:30 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>, 
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v9 08/15] hugetlb: Use the has_hwpoisoned flag
Message-ID: <an2mYe_lClK3co6l@pedro-suse.lan>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-9-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805210557.1118966-9-willy@infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 208C014000A
X-Stat-Signature: b5mnbp96w84xicnzegniw7dqnrainze6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786619561-284225
X-HE-Meta: U2FsdGVkX19OF3RTPc4OMn8qvAhz/bTVX/A3UYfXIABcPtSjO3YNf/IP+F7v/nwz7SCbmAM8vwnFTleGcT5iVTDC+l5JbW42VD0+Yj1zwvjdU16r1rXfj+uSHbyk9jArOLO/th9LtX8h4XmCGRqdYOpqG8w67AtKmAg/1asRndIFXGfbYJqFN2r1lCrn4bajSN4fW7QiZxp2roRxp+66zRwMZ58VjsMjR5Gznfy27oBqfZlyvQ9ieVWM1lrL/8dGMIg/2nGpUSPYB+9GZtUsoTaK9Xw31ROHITXXtM/E1jtX4UN1b9XrLPVJOl5WSo6ThNPQYN0/RTO4bHln9mdKByld0ExMBT4SbY7t2Mre0hemZADKGPyE6LcC7H6JKlzZ57ttZPMvwlRwLcT237v5xJBFKDlaF7dL4DNO5nJZB7aCJ9NKxpGoVJCSd6qVruHrHdj8PVomT2OGSErWXxezgQYl0ZCLWNdRA5jT7RILvzOJH9LkBYfX+CWBiBM6GETdwoTwErF0XWv+tIb2YGwRFLK8csfqkfwuVfPhW2Hc5DNj8klKuilvi0fm3vo1QqcHP/5at4UFKzR4CwMwryToX5CFlgSEsTrmUrA0ZclbPS5iWPyWwoGILK2DmEle0KxMSMBNsgSaY7kXdY5FIFC6sCYGfV7w+vJu9DHHENA6Wh4Fh/xiJOEVYIdv6RW2ydD35WaiRaxFTipbp1vJWh5lOg6Xo7l8vNkL0/AZ7rMw74E2m05jdXHvgY9doYvF9Luyj//ClaGQYKSaM2z9ynQJKmxywLzCGYPiITNdZmrJ1/3rllvvFcseellhXjw+HvXfaME0yZT5SiUspvmgG300Xbw0wyBMPS9IaAIMJra1mXXx81n5iDgntq8rcVRK7b6zOu0zfdf39wgI+RF/khd40WmeycHUgJPSxOeE+rsHkbvnIDgKKJBl+uzQGCUc7X99p5v9FRILw5IMD8wNKWU
 fYtF5D5x
 BWMROjAIdc606UxCgXoKKTOe0OyNTF4/ye///FJoVVUJYR/FQBDdrQy8SlpVuKn1i03htirCWKRW5FnXxGfPFIksobmtV8xU8hqn33//pHLXlpnEPM1qgVKw21OaD2BA0uRHz5KVloFxAyQG7UPGjORnbxTT05l2donMmdJZVtcq1wQiIR0LzTzL7dRLh05h542Wv10ky+bbyCrp/qq5xU/lHkKyLgsXZ4BgGjSOpl0q3vNT5ozo56aj34S7uQ8S5WX64K0fqmU94ACBJgmBs38hjuif1XZyn+/8O0qb7ShZLCZYGf4/aBBoj5Ba7038Xp1vxt82N4QsmOuf0XumP7462K1W5afRFfJnyHyTrm+AurE4qPo1PAGdfD+UTqLVd6PmoW+gBi5Lm9gv5lJV7Wn7L4RP8GJ4uRyxkRRSmOYiYjAzwiMNiFm7we0CIGqdErMHos6h2Y8s99iCcokeO8y6ZIKIjxSWfj20+7B0m38YbyL4FZ4AfpbkrmtKBPL5nVkYuLq34oRCndpziHHvKzCqGqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 10:05:48PM +0100, Matthew Wilcox (Oracle) wrote:
> Other large folios use the has_hwpoisoned flag.  Convert hugetlb to match.
> This will help us use the per-page hwpoison flag in the future.
> 
> Also introduce a folio_test_huge_poison().  This has exactly the same
> meaning as folio_test_has_hwpoisoned() but can be used when we don't have
> a reference to the folio containing the page.  folio_test_has_hwpoisoned()
> can race with folio splitting / reallocation and trip the assertions
> in const_folio_flags().
> 
> This closes a gap where a page in a previously-poisoned hugetlb folio
> could be observed to not have the hwpoison bit set.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> ---  
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 9e0ca4824905..e666dd14ca0c 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -843,11 +843,15 @@ config PERSISTENT_HUGE_ZERO_FOLIO
>  config MM_ID
>  	def_bool n
>  
> +config LARGE_FOLIO
> +	def_bool n

random nit: def_bool n means the same as just bool

I can't comment on hwpoison stuff, sorry :)
-- 
Pedro

