Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14696606A337
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=nm6f7pAc;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5YjXWal6;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=YiDhcdUU;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Pw0UcpJf
Received: by kanga.kvack.org (Postfix)
	id 35B8A6B05B1; Thu,  5 Nov 2026 06:37:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30C1B6B05B3; Thu,  5 Nov 2026 06:37:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FB7C6B05B4; Thu,  5 Nov 2026 06:37:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 03CD86B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:37:51 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 94AFE409CF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:37:51 +0000 (UTC)
X-FDA: 85400865942.29.9544256
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4BD1DA0003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:37:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nm6f7pAc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5YjXWal6;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YiDhcdUU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Pw0UcpJf;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793878669;
	b=5xc/Mh2x4XwMH7cFoo4Pi12gOAT5vpk6zKWi1a8LzIhHZODbSTC1AMPJpDt4/wPuOvxgxD
	jN27Y6pm20M84LhU4to8Pk35ru1O0cXRNV0qtaTSt0VnogMCKzx/02z+iP1Tujha8jEVAg
	Qcb9zXJSsvPb5JjlXarNQfxTXcYeIKY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nm6f7pAc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5YjXWal6;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YiDhcdUU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Pw0UcpJf;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793878669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjo5ToMs5cE4fDuDOvd5YxsZhokCc6fb7N8+ZiF0Jsw=;
	b=POG9Ac63VdDIrCUcOfgNzES//ZsE6FRNaQoel/x17WLshHUgr1PKfPN9C657WuitPZ/5mz
	qkyVpvk5GtDcqrm+U6vrfd20jURGqVoWdHzHEOAOqJmhDB0XtFvwoenAWXdFpu3eb1SKgx
	3wM3kp0L0TJ+Xe+RB6sxJAffEuqrFBU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CA7C721FAE;
	Thu,  5 Nov 2026 11:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793878668; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bjo5ToMs5cE4fDuDOvd5YxsZhokCc6fb7N8+ZiF0Jsw=;
	b=nm6f7pAcewHGaA4dnrGaq6djWoIyg/KwjizKiNYEqXZDCJKhwjl9ccnGCrgUMmTavz4CL2
	++9PEG1lccQnw4y2b5E48TmmuD7GJ94ULNAjTUUQTi60hHZ4ad5JxRgYNUyIqYwn4fNYeR
	VPNEIM7yL59gA34/5G/eOw23VD+sixk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793878668;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bjo5ToMs5cE4fDuDOvd5YxsZhokCc6fb7N8+ZiF0Jsw=;
	b=5YjXWal6urwbExGc3mbQkoIG/rakv493Bym/30L4bWfvdouQbXVruSqx0810KNzqqx5L2h
	bMH2zoUdq7UB0xCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793878667; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bjo5ToMs5cE4fDuDOvd5YxsZhokCc6fb7N8+ZiF0Jsw=;
	b=YiDhcdUUA5iz/xtqvq9Swa89TtvVgQJfitWZgBc3l9YBN89EsC17t82GSu+7u4WX5XVfiA
	mgFKD2qGvur29ZhdlXaTYNfsQVSkcsvGBG+OYLuyCvd3Rf/P40Rp4cv26QGch5KQdZRaEt
	h+D7TQPbrJDCC3UkV/R+ksxZ2assmBQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793878667;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bjo5ToMs5cE4fDuDOvd5YxsZhokCc6fb7N8+ZiF0Jsw=;
	b=Pw0UcpJfQddpPq+fNgyVZucgtJv8gc/9f0lV2IfTz9NO+ZsuLG+CB75082Lh43vPFub98O
	incrKZySM2mHSFAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C7990134F4;
	Thu,  5 Nov 2026 11:37:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VJcRJYpq7GrlcQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 05 Nov 2026 11:37:46 +0000
Date: Thu, 5 Nov 2026 11:37:45 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org, 
	jannh@google.com, lance.yang@linux.dev, qi.zheng@linux.dev, ayushr@modal.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
Message-ID: <auxqWxUfRVvxnk_n@pedro-suse.tail5790ac.ts.net>
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4BD1DA0003
X-Stat-Signature: pkrbb17xm6ntaj4j36hiwbsi879c9hon
X-Rspam-User: 
X-HE-Tag: 1793878669-539284
X-HE-Meta: U2FsdGVkX1/AdcnN+r/8BlPhh+u1sottbTASZJQRhUq2CWO+3oPArEvNFw09l9fvEf11CuUiabRx+/LGfksvQnxte/2IEscziCFuEwWk+eCajp9qSI87Mt2rrKeoSEfuejCdn+FoSMqwlroGXCLzUWvAL1NJLiamcCPH74nK2YurioTL9mpJibxqSkwUnJ6YNbBSNlKD73y4CqYshr6ppOwV5c2RYMkYAD471JZV9WcAJ8Zo3Sx/xw36pUe/Q2y4AU9MOsMaOmhPaD67H7AxJT82aLqtbHA8TEoc++jq003K0NusCxH/WeswHAd4hvdZvXR+UFO26d3VqIrRcgdUTOw1oWSs/SQduCUyZQIhS3FooVFUontBkx9+lDf+uFeY+G9Zi63rjXSerMbR3sj6+fP6G+e91x7sLnMXaV9Gx51P5p2LhVQeKbgVrJRcGef/roumrXB2DPB/yM95lTVq5RbRbiT0AamkWY0czKD0iHcKwiU4+1jmozudXdstTNcxYkIpg+bNKJ8x52yn9lX43APsXXtaItFgLW04BRHscFwMYNi/dwE5n4AikO8VoH8m1lhdIwvsUIiCN/8FG55aqsx0kgSl5QreHsTAray5BzfqRqI1gcU8UbZ2+ZBAcDqUc/Mdfhze4qp70W0DYJHhls29JXrHIdJ/qnWbCjYXJOcvNdKvqtZK1sSuBuOEuO7Plv4T86QBlcjDz/IgEXHC+Aljeng0pZtPJbU39vVELdLkELXMr+6puQJoicNvIxafP92hvRQ7qjjjAE+JBrMVZLJ8CT52+dNwoEUYmGcvhmntS1DWyxK2TEz96ETtCVYRikztMT9qiurXt1FNCR+GWzsp3m9RleTUoAflaQIXs0StUNTIUAa8CWKQ/iTFScszncApJO3gvo4y8QRp2xpIBDrwzi3ce1YNFspwljrspognfwmLuY6YiFsS6NGpGfxBqewPB7Ss8tubgzePnqI
 e8myxWK3
 JYyQcNh0X0ePHRmsWZn3TBdPtiITC4GYvmLbmWJ1mFfT0YIcPYwjibV5jB93Z8+szAyr3A3/95BUiRrEoJ8eWYs2xAzOP75vrISvwG6bevfva7x18w63j0zZ2Dwxh6uASRecDREE/fZ+yJFh0KVePNODXlG0Ibh6dWZcoq7cNtEzADccsExKtEM4/Y7q/1PNcMV5/4rEQ0ICo0+lhoU6JvmMvMAnAPGvIVufniJ6RwtFj+sE2OZpExEDelHBo3MWpT/AsNr2Flmk1mp4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 10:56:28AM +0800, Baolin Wang wrote:
> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can also race
> with concurrent page table reclamation via zap_empty_pte_table().
> 
> page_vma_mapped_walk() is used by many functions including try_to_unmap(),
> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(), remove_migration_ptes(),
> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for try_to_unmap()
> and try_to_migrate(), the other callers do not perform post-walk accounting
> checks, so the race has no observable impact on them.
> 
> For migration, the race can cause unnecessary retries. For reclaim via
> try_to_unmap(), the race can cause failure to reclaim a folio that is in
> fact already unmapped (as shown below), which may lead to unexpected OOM
> or increased refaults.

This is very handwavy. Do you have numbers? Does this actually make sense?

-- 
Pedro

