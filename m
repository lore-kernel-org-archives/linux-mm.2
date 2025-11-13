Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BC10CD8C9A
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 16:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EBFA8E0006; Thu, 13 Nov 2025 11:12:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C6C8E0002; Thu, 13 Nov 2025 11:12:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38AAD8E0006; Thu, 13 Nov 2025 11:12:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 27C4D8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:12:24 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C21E1BC82A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:12:23 +0000 (UTC)
X-FDA: 84106076166.23.556AADE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 55D7F140016
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:12:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2mE03IR2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="MXPz51/N";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2mE03IR2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="MXPz51/N";
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763050341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9WZzM1qgOW7FW2V5s9/sNf+huVF6LA0jwcovxLpeozY=;
	b=NDY3QN/sSvrAqAeKe5Wfaay/DZWJJt/4Thozo5wngtrv6POBo3HgnUjDjIuUdcwWm+QU8Z
	Pc5DGCUCXSIxpVr/9nXXekff4HWDGH2IDy+IDG2+yWBnymZWPzoZ3DlsE53UjOmjzAN0RX
	I16qxq5aWzmXBPdfH5yzcMVgTP9l698=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2mE03IR2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="MXPz51/N";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2mE03IR2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="MXPz51/N";
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763050341; a=rsa-sha256;
	cv=none;
	b=3guw5pUOn/AKWvKADqvvHF48q83ljzPMhp7WOa6AIlOhn5M7+Tw18trXcGMes6XjGnfQgl
	nRknFpZNmO9s2ABBOGkTrJpsF9b18nYjWv8Tp38XBYSAUEMhp+2213hWGBPL3W2rr14h8M
	4T0xfLbCeLQxgNulDLporqgFH3gZOVg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 403E21F395;
	Thu, 13 Nov 2025 16:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763050339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9WZzM1qgOW7FW2V5s9/sNf+huVF6LA0jwcovxLpeozY=;
	b=2mE03IR2k1SQ54QsXbKZ0JeUlhGDpmiyZDISXzuKSXqF2B9bKiq9tS69GKBeEMCtcNG6JG
	bBPE/SzM7qnR2TrTCSWrqYAOX5PlMATV3XTtU1nUfYuF5OeVQGI2l6S9VezagM9oyvUewZ
	mTYKSLosKqoUC4vAwiqxRbBPBOkf5wo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763050339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9WZzM1qgOW7FW2V5s9/sNf+huVF6LA0jwcovxLpeozY=;
	b=MXPz51/NGs7BSYMDwKGaJjjm7j1EYD74M61/JlOvSXZdIrGE/jgF2vnwFYHy59QX9DJJeU
	f4z6D0EBycJSHCCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763050339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9WZzM1qgOW7FW2V5s9/sNf+huVF6LA0jwcovxLpeozY=;
	b=2mE03IR2k1SQ54QsXbKZ0JeUlhGDpmiyZDISXzuKSXqF2B9bKiq9tS69GKBeEMCtcNG6JG
	bBPE/SzM7qnR2TrTCSWrqYAOX5PlMATV3XTtU1nUfYuF5OeVQGI2l6S9VezagM9oyvUewZ
	mTYKSLosKqoUC4vAwiqxRbBPBOkf5wo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763050339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9WZzM1qgOW7FW2V5s9/sNf+huVF6LA0jwcovxLpeozY=;
	b=MXPz51/NGs7BSYMDwKGaJjjm7j1EYD74M61/JlOvSXZdIrGE/jgF2vnwFYHy59QX9DJJeU
	f4z6D0EBycJSHCCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 269073EA61;
	Thu, 13 Nov 2025 16:12:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CbQbCWMDFmkQDAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 13 Nov 2025 16:12:19 +0000
Message-ID: <f58a2fcb-2306-4c27-a20c-11ac953c1b5d@suse.cz>
Date: Thu, 13 Nov 2025 17:12:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mempool_alloc_bulk and various mempool improvements v3
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 Eric Biggers <ebiggers@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251113084022.1255121-1-hch@lst.de>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251113084022.1255121-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 55D7F140016
X-Stat-Signature: qe9tdz1wria4t578giazjmh1sfumky15
X-Rspam-User: 
X-HE-Tag: 1763050341-458345
X-HE-Meta: U2FsdGVkX184rjokiyGIimwXm9EqqZu+/2scu+zgDhXkc72v0fEeiBeqJJ4bvj+FET+ssSz+yjKaKNTkYYT9b38yavmPJpNZiXNK/V0RyOI1NQ9Nsj3A0SQR797/h4t/9gl5v85ow6WE57AhqsFJuD9mX/9ngYR+uTcGSb0dV3NO2ZuP+7C8Hb5xvWSKcDb9z1ZQ5yheV51dg4ILwCHYfc1v/s9rMZKn6eVGNj/111t/SnBGMLmJy1ogr1tjLLr4OTWz6eQWd8x+bLlfULJHf5vy4/xzR3EIWmQ4RIHK4EqSykw+XjTWSDI7s2uXEY9+jnY9iAUMqTVI15/MBlZcHoVsb8vNSreOgLpc5ncoG53tbuZ9KB2b5T76Fg89pnAW90LIN7mskIIYQ//KxEjkoStuHQpbLvcscGxvLA3weuTyLi/VvRgUVdy582E0TQxklTj71rW/MnrgBupMdDLJxK30hWWUbO036bUb6iSSXaOtCzFRgT0PSZqzSnhVnbVUrRvJd2OscK6JuPRpgkspRVubflKpVTeP2ouGhl+n/gsYEMNgNPDBSGxgq+oPyV2Yt9O43EzdQv7S5eQZqPw8mGyP0hREQve4HDO1oanpiEewoetCmDgmQzzYO6wlZTp9oY/ncEYo2z89S71LsA3sbpSfLp1aEnjBTU+TW/YHDF0TbQ4EuQHCxI5JVVxpubDQDjIppxgSeCZ5doPxgPpsX/7CKsLS6p8GNkGOWl3oV+WGCADwFZPxK8T+iqd9fGmbZEMPLdco1H6C9aVl8q/hf5Qz7WsBtiMQeRZzSp4Kim0AFuoV6Bd1PBlTDQcIh5vxSYV62WLUojRNyPp7+CTjP0cYJg6TL1ih1FE6X2wqajQ84BdxDkFO4T4Ah/8pq+ThebXSwhOtz4/3PDPWJvKSNvY+KUv89VXBGuQfpyod7dpwKrm9xrmlrBLcq9TTRE0y34Yifg7k6tMh7rRhns7
 gcYDZW7x
 xfxyfAmEtjgyvSrSmZwd0mMLNewRZyX1FNzt33x0F2Dcbd//VAI4cy4v1uNwZKxQvaCsjarSTbCwQ2UelD/tvwMpc4A9j+ri9XrOdWXUxxd3Dy7VDTLL4oVtaj02XvJuwxwshM1f2Y//RHXK2tTqb2MCxAQPyF46YeLXS+LqrnzBfMnjmnbIQ3RyZQ4K0O8nz05yspDZZEBNS929cSwbLWrpE+QNXEDb5Kb4S9CDLu5iwGIN0VdJNv2wfcO2aEn83MkBYl5PLqg28yKJhjk+I5enB5EnGJSMw5tfux2T+ilJTTHXc59lBri5sdHuGx3paCbAP9o35ijJCU76xq5AGw2HeYX9nLf8+Uphdtkiav4P8OtE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/13/25 09:39, Christoph Hellwig wrote:
> Hi all,
> 
> this series adds a bulk version of mempool_alloc that makes allocating
> multiple objects deadlock safe.
> 
> The initial users is the blk-crypto-fallback code:
> 
>   https://lore.kernel.org/linux-block/20251031093517.1603379-1-hch@lst.de/
> 
> with which v1 was posted, but I also have a few other users in mind.
> 
> Changes since v2:
>  - improve the alloc_pages_bulk documentation a bit
>  - drop the not needed race fix again
>  - drop the gfp_mask argument to mempool_alloc_bulk to reduce misuse
>    potential
>  - add an allocated argument to mempool_alloc_bulk
>  - drop the caller_ip handling that was already not required since the
>    last version
>  - add a few more mempool cleanups

LGTM now.
Since mempool is now part of SLAB in MAINTAINERS, added to slab/for-next.
Thanks!
> Changes since v1:
>  - fix build for !CONFIG_FAULT_INJECTION
>  - improve the kerneldoc comments further
>  - refactor the code so that the mempool_alloc fastpath does not
>    have to deal with arrays
>  - don't support !__GFP_DIRECT_RECLAIM for bulk allocations
>  - do poll allocations even if not all elements are available
>  - s/elem/elems/
>  - use a separate failure injection know for the bulk allocator
> 
> diffstat:
>  include/linux/fault-inject.h |    8 
>  include/linux/mempool.h      |   58 ++----
>  mm/mempool.c                 |  401 ++++++++++++++++++++++++++-----------------
>  mm/page_alloc.c              |   15 +
>  4 files changed, 289 insertions(+), 193 deletions(-)

