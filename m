Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CA05CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5627B8E000B; Tue,  9 Sep 2025 10:52:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50C268E0003; Tue,  9 Sep 2025 10:52:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FB1A8E000B; Tue,  9 Sep 2025 10:52:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3055E8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:52:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE85C14054B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:52:14 +0000 (UTC)
X-FDA: 83870002188.24.558D120
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 945BE20008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:52:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZfE+0tUM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wbeIJSBx;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZfE+0tUM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wbeIJSBx;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757429532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NQ9jOGPJtYrY9ZT/iPA3+VnBwmwNfrm2jKRpSJXGpz4=;
	b=1jAK9l+hVCIMImlBM5GnyuFpdeXYr/lLzoXb7VSSCY75LJv+x9akBnOr7iFFrV1qrv+zkj
	/b+sFCSBAhLbrduiJ9j+ImCvtUA5fla00APMXq6ru6lhADfqV/DGAIeSAXbPqmnR7pSR0u
	GBZD2Nx8cqq++4RtA9XcMNHcthWSICw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZfE+0tUM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wbeIJSBx;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZfE+0tUM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wbeIJSBx;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757429532; a=rsa-sha256;
	cv=none;
	b=qows+KyxkdRRvGkYth9gin9s0/7dC4zsSrGK2ieyDB9pfdABEwM6+iNFHhxjI5vMBVPdfu
	1i/ik+cU1y/hat6YIG/ivm9062o+dj3sf2/AigPLJ76Y0JCOLW+CYd4qOO+C5FqvdiZHna
	cXdkqiDJ40jNDBS5ZVyjm9epp9izWXY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B785E349B6;
	Tue,  9 Sep 2025 14:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757429529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NQ9jOGPJtYrY9ZT/iPA3+VnBwmwNfrm2jKRpSJXGpz4=;
	b=ZfE+0tUMsHAOco1NIWu8fVqQaGI6druBSVAQrNpFrq6GYE1GsF+Udp5KqRyDfP7iBuL1/7
	HpFdBnAZVICwXSpjQ5LLFHlnktiuturDngqWJ9qIkWz2ZO8URb17hjXYk+2ERSvBYw6vVc
	1d8uu/HvuxJhWzwjy6BfM8j9eSmzQpM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757429529;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NQ9jOGPJtYrY9ZT/iPA3+VnBwmwNfrm2jKRpSJXGpz4=;
	b=wbeIJSBx/54P1Q/wpoSdLd2ROsQIe/zviVK2jxgdre3zTexjK3w4waMkpSFeljpu0grEjo
	52CgLZKl7e8qc3Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757429529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NQ9jOGPJtYrY9ZT/iPA3+VnBwmwNfrm2jKRpSJXGpz4=;
	b=ZfE+0tUMsHAOco1NIWu8fVqQaGI6druBSVAQrNpFrq6GYE1GsF+Udp5KqRyDfP7iBuL1/7
	HpFdBnAZVICwXSpjQ5LLFHlnktiuturDngqWJ9qIkWz2ZO8URb17hjXYk+2ERSvBYw6vVc
	1d8uu/HvuxJhWzwjy6BfM8j9eSmzQpM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757429529;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NQ9jOGPJtYrY9ZT/iPA3+VnBwmwNfrm2jKRpSJXGpz4=;
	b=wbeIJSBx/54P1Q/wpoSdLd2ROsQIe/zviVK2jxgdre3zTexjK3w4waMkpSFeljpu0grEjo
	52CgLZKl7e8qc3Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 06D851388C;
	Tue,  9 Sep 2025 14:52:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U4LpORg/wGgzegAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 09 Sep 2025 14:52:08 +0000
Date: Tue, 9 Sep 2025 15:52:03 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Ye Liu <ye.liu@linux.dev>
Cc: Dev Jain <dev.jain@arm.com>, Hu Song <husong@kylinos.cn>, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: Use folio_nr_pages() in __free_slab()
Message-ID: <v5jeb6pbpkikzhjuno6pq65y6cdq76ucj5ebotakwpvzbmjl5h@7dtdjmqjxmp5>
References: <20250909074812.599030-1-husong@kylinos.cn>
 <c880df01-3041-4af0-b4d1-167193e8e6af@arm.com>
 <e058c588-2fa3-4763-bcc2-06b6fb6eddab@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e058c588-2fa3-4763-bcc2-06b6fb6eddab@linux.dev>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 945BE20008
X-Rspamd-Server: rspam05
X-Stat-Signature: 4y1ac1dyk5m9nira8bdbecjru1e7ux1z
X-Rspam-User: 
X-HE-Tag: 1757429532-608439
X-HE-Meta: U2FsdGVkX1+Th/w4BJCTUzzRjtz171ieHpxI2FOrpJg0heZfYa3C47KFGDn1bHnnJ09Wmx0X77vPuWnSDOYCWcUiQoDzSCCF3392mYokVKW01H3YZVAQi57L+3ugwT75vQRjc/tywPymNIpqExsAqZUnDVCgkUHGYILqdFrsfZPUaA3NJf1G6oprXA2TdgyRKcCmKcphjJ8ADTZIIY8/ys5sxDMIIx7y8hV4kJZvrYW1oFaQ7ECA8HlhEu5x8Zw19StniaG0LjCK7ROkVJzgEPtwGRgEhp+juKVoSR8RONU4PZHuF5bYx+q84dAvVOwN/qo3U/zmc8FrSKK9M/dtRHe6BX2tEPx0Hr7Le8uXJgGhhQvwmChwuMdl9f4UhYExsBH63UCybf24BKD/sXAyGgkOzMdatUGOwelmdPr6yNjEvzVcxFofL30P61j2p0+cdz0SpaBw0u9rc9LWThvgn1FSfP6OBffKCXxFMqAVCkvaQj1bVK9aSbhEP9SlQWue3cvh9Nl0hcjiuZPUkefNeTArttyepBu728pxXZhtEkf5l8yVi1wzGPw2+33G4a2O+QUPb9DmOBfXTmMyYck1ouSl/HfI/f+aH92ik/mIB5ipdCzLUM/xOk2d/XqDUVlBnuRDYGmct77stUvItX7oFJUsT69N73yXDD3yoG2XjAXXn0c0EAUgM6Swf5OwnVYHt1a6SJNvq0z2ei90kN8RoDEyE5YqecfRdhmiX+v9ziiO1hdv9PB9ULkSznIyH1QFs7oZXEkoIw41ktcDt4L/+eDPnkSpYx8CxosL0DTkDtQCyHernP2NP2rgPmF3PcURWEDnmGmGCvnnORuHB5bb1gskc6ofTCNYl4sMgOHkP4KjKWmNZiqC8ZF9i4gBNI7putwSsRNU+QH4ZmcMcXpeM/GCnJRBHUd/QoXoh3GtdbHmNaYytCRd6Su34isS54CWQRkqf+bi7dCNiPEg1tU
 6UMqWnos
 XSIGohrmw+A5Fe9OBrEMx8ZJ7UoTsx7SVrrqIBcp6iP4FxHwsQgi8KlelL18WziOvUPzYj3/YucfYcupXyg4iJ8c5jnAARJebvJRrl3chEBxjcm60xI9FEJdd0/VupibvxyT8lPC81r8RefobwRgIMkBdSDNs5S1EoPLL+XpPHCkMmrGJSvJKV32mJWSkrsTO94CCPaZWSDN+VKsR/N946yxFm2uDzHyj9egxjl7eajCwhiRB9n1ZwQ0QsQt/FyPiM1PvZZeNo6k8db8+u4xsqHOU43AecqpSXiUQw/crLOLV/IUNacG5Phjx8iiiZUh6XQ8YTUFXtciLCkGh9TtIt67sW9JMKR9KFS6qJRiev9suJV2wOwpBkqDT5rIe8W+fruwF/CzRlg01waCZKdP/zTTRvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 04:59:37PM +0800, Ye Liu wrote:
> 
> 在 2025/9/9 16:46, Dev Jain 写道:
> >
> > On 09/09/25 1:18 pm, Hu Song wrote:
> >> Use folio_nr_pages() helper instead of manual calculation (1 << order)
> >> for better code readability and maintainability.
> >>
> >> Signed-off-by: Hu Song <husong@kylinos.cn>
> >> ---
> >>   mm/slub.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index d257141896c9..eba25461641a 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2719,7 +2719,7 @@ static void __free_slab(struct kmem_cache *s, struct slab *slab)
> >>   {
> >>       struct folio *folio = slab_folio(slab);
> >>       int order = folio_order(folio);
> >> -    int pages = 1 << order;
> >> +    int pages = folio_nr_pages(folio);
> >>         __slab_clear_pfmemalloc(slab);
> >>       folio->mapping = NULL;
> >
> > I don't know, the current version is more readable to me. We literally
> > compute the order before, so we do a simple 1 << order. I'll leave it
> > to the rest.
> >
> >
> Is the reason for calculating 'order' first because it's needed later.

Yes, we use it 6 lines down.

-- 
Pedro

