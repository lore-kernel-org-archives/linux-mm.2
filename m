Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E6DACD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 11:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B9E6B0092; Thu, 18 Jun 2026 07:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B476B0095; Thu, 18 Jun 2026 07:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96A356B0098; Thu, 18 Jun 2026 07:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6960E6B0092
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 07:58:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0E9D1206F7
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:50:03 +0000 (UTC)
X-FDA: 84892864686.30.B6651E0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7E2814000D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:50:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FPtyDPNS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GcHnYBeI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0jZ9sUJ3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LgeesqzD;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781783401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DHRPDHV9Pv8sUvZpUb9QmnZDAqJGJqQtUUFN6Oi3bQk=;
	b=cbMzxEASkaum7ch7ecLDaoa3oX+5gzilRNk84E7CQQhowHAok0ZPD1Iolc0zU+5H+jgcKI
	AmRdN5rUsSScN+h46O11MPLOkXE9Xo8NPiIkgA4MqqKvrrc31TY44Hs5ZUgy8dQ20/MQGs
	ocyjDGVluurrvFlK1fdlUl1+xe3tsQY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781783401;
	b=OdSK2VDcyDdoWEbJ8b+LMCbGYw2In1dvQoKLWvUO87WMnORTVBxBaz+H+cyCdeO9AXtlWL
	h3+sPdkoMp5fe0QtQbNh7wHIaPtQAazDy5GFtlrvHJJvtsNoDLWUAg6Qlr83YkOVqENZG3
	lFmNX50Dcemsc+o5PNajNDU7SgOaqQY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FPtyDPNS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GcHnYBeI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0jZ9sUJ3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LgeesqzD;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E3DF66D323;
	Thu, 18 Jun 2026 11:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781783400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DHRPDHV9Pv8sUvZpUb9QmnZDAqJGJqQtUUFN6Oi3bQk=;
	b=FPtyDPNSIIc1cDsvjJWxO12HaQT0NkjD/iytRFWQ2buI80nJtVw1UZA3ssbvidV6H936BQ
	Wg7qgzN8JBjBo0wW2GBexjqurq8nrYAl2RBs5Ge+nOH830Gd8ioU8Kr27ndwRDVNegl+3s
	pAJQnNLjMOHho8A9irWxHkptJWupzlU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781783400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DHRPDHV9Pv8sUvZpUb9QmnZDAqJGJqQtUUFN6Oi3bQk=;
	b=GcHnYBeIgaRaQC8OGkqpp+Qhp1n7Bc6FOALJ8bMRWRonWMiy+WloZtaGdd7hBmj7xM93mS
	6Rf8CYoOUqzvkWDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781783398; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DHRPDHV9Pv8sUvZpUb9QmnZDAqJGJqQtUUFN6Oi3bQk=;
	b=0jZ9sUJ3ewrGzBKdsaN9mlWD9xi/8t8CaKA8GqhX8cJVaco1kNHW0aJcVg0F+LSVC7wptS
	1rArk0stMOqrYchI5it/yLQmXNw/cIGd4JezKowIvw++RTJirX/PuPVT0cYCnCKDEY638z
	sg4U0zRnzZPfuzNFhklp7oiUayB3peo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781783398;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DHRPDHV9Pv8sUvZpUb9QmnZDAqJGJqQtUUFN6Oi3bQk=;
	b=LgeesqzDVGwDD9wkThupwtH2LyvldVzJ3G7aLXce0M0yICcXD6NaN92sPV77goTlSwz8JE
	+dXlpwVRlSPq6uDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C881779A8;
	Thu, 18 Jun 2026 11:49:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C5I8C2bbM2rMegAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 18 Jun 2026 11:49:58 +0000
Date: Thu, 18 Jun 2026 12:49:56 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/4] mm: mincore: use walk_page_range_vma() in
 do_mincore()
Message-ID: <ajPZlxq5z1hyo1kE@pedro-suse>
References: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
 <20260618092845.3905740-2-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618092845.3905740-2-wangkefeng.wang@huawei.com>
X-Rspamd-Queue-Id: 7E2814000D
X-Rspam-User: 
X-Stat-Signature: kuffzujzm9hrcrriaxmifygkuommiqcu
X-Rspamd-Server: rspam08
X-HE-Tag: 1781783401-664259
X-HE-Meta: U2FsdGVkX19Tux9ruvRVgJ/kvQOL+sf5SfvMsRwn3ldJE4OLk4V4wcaTQjslIkepSZRUop6V9ulocQ7+33V4sjsJDnSMv/h29Z10E3FvbBu/VN1Po3y90xvQedOp39v181gfzVX90U3XRwzbTJXZ+wfEtNp4oNhAyKRUAZd6f2Gqi+VEW/OKh4SRx6ONoZvqFDI1M13sm6Fzvbbeoop70bSKckzqzYjX17FlNuek+5vZvnAcKOempzrBGqFHA8Qat9dACySfuTgips0A84EnYwfRRFGRxseLJrXcoBNFJgXF8I2Dxsy+xSGdVlKlA66k4+Tbj7HqCxbyrihKRaQNlScSKGuHVYkaDRNc6qrZL3Xn19up2KKWM54UmX6koonnpGGc3eIWX3o9zF9ZKoSRcBFLUoDKUkeeHGRy1Ye+WNWXTiN2b/jGlZBOUID02DfEBnOn/tmV/Yo9y4EP/1+e+D52CTP6ADuk9vMCgAUhVD3VepgJQhJBanRAlexaye6d50va5Q4aOWET7xtGn85Liyub6DTKKDqoZqPbAPXYwDd1ErgWlqpExYT5eZwNtAogu9j5eytH7O8rAoBkgPnKmCHbwh68489OPKeEXFOCaxtYnMqcN3wERZJgITSnZLaaLil/Ta/nAfU47OyQTC5cc5B4MqRnuaqFeIv3ADJNtBlncG3B71f96y6+Zb+T1bmO6F9uMj8XwP0Vliucp4eTMgwwof8SWzUnSvxmpxJ6IIkRIQUVK+2qpSOAtiRSYQyaUHhPc/rgEeP1uGcDDGcZOx2JcNgO2oLVIvWhn2q3XyxqJITW23QkPXCDtHZar6ReEe1vyt29OuO/Hra49akB4vmJ87/s9X9pjNVOVsyqnmNkVaWfv3wCu1a0agPtvJ4om6j+JY+fKAOk+FBZVaD0ANdpVya/lLrLc9nI29MI9o+Gl00SpeXfyI2eJXGxA5f+SiiJ7uR3Csesbv80QlR
 eoMHD68h
 7fQcOm+RSmsC/uqu3aCNSad1HNqFsCu59fZCctqfL3r8n8eDLPIcWl60cTF66fgti7uZ35RhaPzn2aSl1mlxZ6K7JfDBGT6GgAuEdUGglvMVh9fG0HcIHfKuL5DmWZLX5RdOVipZmUwhopdRSRwDXf3JuBWpa1DsEYtFSSNx2Loo00nq39ISlrUnrVeckyVLj8/yRY9mdCnwxeBtGwcO5pmricQtNg9T1jjqARVE6ISY99UNNjMUkZY/4QD8yOG3JDR3ZhgjaMrpEjr9kAe5Uai6ft1fcZwQxzZdEwfLAA4ENOiC9/zjPF7ikGWJZo33rTQ8rCBBPTJApWrvDVRGrVf0Iqzot2AjH2FU0cKi6/NOEvZzKYTVvkYxSHUkJUdD6UiL7cuOlnKdXNRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please CC reviewers properly!

On Thu, Jun 18, 2026 at 05:28:42PM +0800, Kefeng Wang wrote:
> The do_mincore() uses walk_page_range() to walk the page table.
> Fortunately, the caller always passes start/end that falls within
> a single VMA, so it's safe to use the walk_page_range_vma() in
> do_mincore() to eliminate an unnecessary find_vma() lookup.
> 
> Unlike walk_page_range(), walk_page_range_vma() does not call
> walk_page_test(), which handles VM_PFNMAP by invoking ->pte_hole()

Why not? Can we fix that instead? I really don't like having this open
coded in callers. Are there callers of walk_page_range_vma() that expect
to look at PFNMAP mappings as well? From what I can see, the callers all
seem to operate on folios (and/or anonymous memory).

> to skip the page table walk. Without this check, PFNMAP PTEs
> would be treated as present by mincore_pte_range(), changing
> the returned residency status. Handle VM_PFNMAP explicitly in
> do_mincore() to preserve the original behavior.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/mincore.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 296f2e3922b5..0c6731ae6c4d 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -259,7 +259,21 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
>  		memset(vec, 1, pages);
>  		return pages;
>  	}
> -	err = walk_page_range(vma->vm_mm, addr, end, &mincore_walk_ops, vec);
> +
> +	/*
> +	 * walk_page_range_vma() does not call walk_page_test(), which
> +	 * handles VM_PFNMAP VMA by invoking ->pte_hole() to skip the
> +	 * page table walk. Without this check, PFNMAP PTEs would be
> +	 * treated as present by mincore_pte_range(), changing the returned
> +	 * residency status from the historical "not resident" to "resident".
> +	 * Handle VM_PFNMAP explicitly to preserve the original behavior.
> +	 */

This whole comment looks poised to rot very very quickly.

> +	if (vma->vm_flags & VM_PFNMAP) {
> +		__mincore_unmapped_range(addr, end, vma, vec);
> +		return (end - addr) >> PAGE_SHIFT;
> +	}
> +
> +	err = walk_page_range_vma(vma, addr, end, &mincore_walk_ops, vec);
>  	if (err < 0)
>  		return err;
>  	return (end - addr) >> PAGE_SHIFT;
> -- 
> 2.27.0
> 
> 
> 

-- 
Pedro

