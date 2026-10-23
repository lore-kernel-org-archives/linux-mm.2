Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B68A606A324
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=vCdHe2g2;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+jvISlXK;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=vCdHe2g2;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+jvISlXK
Received: by kanga.kvack.org (Postfix)
	id BDDBA6B0BA6; Fri, 23 Oct 2026 13:17:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8EAE6B0BA8; Fri, 23 Oct 2026 13:17:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7F5A6B0BA9; Fri, 23 Oct 2026 13:17:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DF566B0BA6
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:17:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F00B480145
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:17:53 +0000 (UTC)
X-FDA: 85354548426.14.088C4FE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id AA0648000C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:17:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vCdHe2g2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+jvISlXK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vCdHe2g2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+jvISlXK;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792775872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XukA89Q9BDkd0XtBh2gSl1FnwMloWguuCBheAa68ykw=;
	b=eOPZxGiMbwJGrb471fMHR9TLUS7/YpnzaLKRHIkRpxVoWsErmMa276cNhGmEBDprdBrAB0
	MCmLukvImZfJeoevCrOttCT3tmzNnOPwe5b+fAng07CTHtCB14qgpU34QlI4oLDQvhKWOp
	5SmKTQgyhAPCY0y5RucJfAuNI/qr+fM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vCdHe2g2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+jvISlXK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vCdHe2g2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+jvISlXK;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792775872;
	b=b7XNW3SG7MJRRTUljfXQDdIsUREnyjbat79nuLhFkeTf/v3/eyjHD+S4wmS5N0eyKZsc1+
	4thfagfk+pqGTqOMft+jdGHx1mN6GLnNwrjkVyXf9VqJWWNIfBBJclXYqi4CFoUGai9Ftp
	popiB5URBvLzL6BqNZC5ac5nfoCNzBE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 215DA1F76C;
	Fri, 23 Oct 2026 17:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792775870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XukA89Q9BDkd0XtBh2gSl1FnwMloWguuCBheAa68ykw=;
	b=vCdHe2g20uTYZTpiEzNLppFWchd8VyMkM1DHEGXwMrpeg4DbRGsEhQ630nUcaQIy7s3eya
	KEa6Fw7SfXIZLqNVqYWr7vP9+b6ka8t8DnDO+6q/utbkH2D5hI01sM2j8niDsxM30n2ruo
	pdMnkBXhZtmBiyTfIgUtuoIYWD1Dt8E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792775870;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XukA89Q9BDkd0XtBh2gSl1FnwMloWguuCBheAa68ykw=;
	b=+jvISlXK3WIo6Q5Pi1FehViuMkWMKuJFt8x02SWULTXNth4JhX10w56wAyJ4JA2cpH+FNf
	LHoSA4avmdjqvJDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792775870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XukA89Q9BDkd0XtBh2gSl1FnwMloWguuCBheAa68ykw=;
	b=vCdHe2g20uTYZTpiEzNLppFWchd8VyMkM1DHEGXwMrpeg4DbRGsEhQ630nUcaQIy7s3eya
	KEa6Fw7SfXIZLqNVqYWr7vP9+b6ka8t8DnDO+6q/utbkH2D5hI01sM2j8niDsxM30n2ruo
	pdMnkBXhZtmBiyTfIgUtuoIYWD1Dt8E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792775870;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XukA89Q9BDkd0XtBh2gSl1FnwMloWguuCBheAa68ykw=;
	b=+jvISlXK3WIo6Q5Pi1FehViuMkWMKuJFt8x02SWULTXNth4JhX10w56wAyJ4JA2cpH+FNf
	LHoSA4avmdjqvJDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ABEF8133F6;
	Fri, 23 Oct 2026 17:17:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XCS7FryW22opPAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 23 Oct 2026 17:17:48 +0000
Date: Fri, 23 Oct 2026 18:17:42 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Imre Kaloz <kaloz@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	"Mike Rapoport (IBM)" <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v3 4/4] mm: pass the number of PTEs to move_pte()
Message-ID: <atuU4Ig51wvNt2eD@pedro-suse.tail5790ac.ts.net>
References: <cover.1792609488.git.kaloz@kernel.org>
 <2bc50d2a6829b49ee909e5bb943244859661a40b.1792609488.git.kaloz@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bc50d2a6829b49ee909e5bb943244859661a40b.1792609488.git.kaloz@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Rspamd-Queue-Id: AA0648000C
X-Stat-Signature: jpoz5szfhcdmhch5y4yjkpfsr5xh4qo1
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792775871-673227
X-HE-Meta: U2FsdGVkX18gUvW422LbumoeoC8h6irsO4fm6ZkpxB7pwMPi/jroG1y42d2xmOk/3DLzUEvQautbaIeHm9VVQVQDwve+8RRxpWJ6FUL7taTmQg1Ervt30YIld+dCP1id2Ge/HRpircZzgTCKhhSowi02TlHYYDYThw9OobjOTrogdhp2yy6JZW0rAPeUNF1jn1EtOkgd6m3v4MpkawuOfO41xi/1ibYa827wCy4andYQg6KLzHj7WpjRI8ciUcLrU2a9RrHrlGye1FAcr0Ohr/2PJ9P1NfwEIUL8awZ7hZN3PN7k3qMviXslW5UYNglJxFPlMG18gYIVNta2l9jn7q/DM1lQw5q1m3gyu3ocu6A/AR4amJAx7AG8AOi/RhCGuz1aPUEvu5GrUSpjgX4MU2npCQaDVsv7Ud8EgR3WIx1CmmekHTwETXm5B2W6fWw3Le0XbPu3Y5Ay/FAb40BiV9S25kSQuHayI8OqX2aJlUm6BAv1wCFIT7DYVYWszSwxihPvR3DNZCfg9NGxKihs3xFu0+20YKABdnDUIzh1ZAvOEIO7KHjWD09gGSKuDlmVNZQ5dJP375Rhys0JOtDegoInO3T9DgDqYRr8hRd4fG9RgodxVmykkqzvGrkyDTg1qtH/+IHjCwuxBwFCTlE6T880xgOHZPUWzftd8IOCGXrrp53zQiNDDt8kc0ASCfrT9DS+gAHrB7j/49JBVcx5Ggbp/45euCM7TAPfTj9Qo6KNJFW0Ae0D93zbPXeviIDqwUHlDW7CG31q4DQDDgMrxLg9+J5/JSYmWKFTymsedtigtoyXiOk+/yxQ45tDuwSQIRGEhTv11RTMdwq/y/otBBHik2Zm2UQ6zREsgpBCqLyQkjhh6cx2HwQA+ukVqhvcrd20HAeMlYqCczZHXreqao3u+KoK/x9d7apBWYNHbon1yOmV5fq1bxDL7X7XflmCTrSvtymwPgzrscIV3mz
 3SVOACE8
 S7U2pEhnARNAcNfXngVJRQ3L0RJV2agPXgKq0DxtY2QKKspZUEnrL452d15I6YVGfCsdEfZMGV6dqxZ2iIcIs9b+PruP2MLCftfXgcXxu9bn/ytCIgzP0ZZVGltZmr2c8xcyarEnDosfshlGXM9XqxYntLDcW5YPqvj3u9uvcJk31qJqRq68ntw16gVgRNYEJNdIDFwomC3dSC7PAYGXF+ZOeWZ91g9uxQnYG/cURJ0vzpeWhSOJPD506m/BV2NzTUTBS1Y4NR7Ikdv727TFKingIRf4osDYdJm/Y40saVyu7409Htcs7uDfZddN9YdurOmmnoM79VX5OcUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 01:33:40AM +0200, Imre Kaloz wrote:
> Since commit f822a9a81a31 ("mm: optimize mremap() by PTE batching"),
> move_ptes() moves a batch of PTEs mapping consecutive pages of a folio
> at a time, but calls move_pte() once per batch with the first PTE
> only. sparc64, the only architecture that overrides move_pte(), flushes
> from the D-cache the page that PTE maps when the move changes its
> colour, so the other pages of a batch would keep lines of the old
> colour. This cannot happen today only because sparc64 has no
> pte_batch_hint(), and mremap_folio_pte_batch() then never batches.
> 
> Pass nr_ptes to move_pte(), as get_and_clear_ptes() takes it. The
> generic version ignores it, and sparc64 flushes every page of the
> batch.
> 
> Signed-off-by: Imre Kaloz <kaloz@kernel.org>
> ---
>  arch/sparc/include/asm/pgtable_64.h | 16 +++++++++-------
>  include/linux/pgtable.h             |  2 +-
>  mm/mremap.c                         |  2 +-
>  3 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
> index 1430489b9ac5..9ca787b3cbfe 100644
> --- a/arch/sparc/include/asm/pgtable_64.h
> +++ b/arch/sparc/include/asm/pgtable_64.h
> @@ -946,21 +946,23 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
>  	set_pte_at((mm), (addr), (ptep), __pte(0UL))
>  
>  #ifdef DCACHE_ALIASING_POSSIBLE
> -/* This flushes only the page the PTE maps, so it relies on move_ptes()
> - * calling it for one PTE at a time, which the default pte_batch_hint()
> - * guarantees.
> +/* The nr PTEs map consecutive pages of one folio and all move by the
> + * same offset, so either every page of the batch aliases or none does.
>   */
>  #define __HAVE_ARCH_MOVE_PTE
> -#define move_pte(pte, old_addr, new_addr)				\
> +#define move_pte(pte, old_addr, new_addr, nr)				\

The \ is now misaligned (at least according to my email client), perhaps you
can fix it up :)

The only nit I have is regarding the function's name.  move_pte with a nr is
no longer really move_pte, move_ptes() is the calling function's name... Yuck.

Also it seems a bit overengineered at this point, move_pte() returns a pte
that sparc never modifies.

>  ({									\
>  	pte_t newpte = (pte);						\
>  	if (tlb_type != hypervisor && pte_present(pte)) {		\
>  		unsigned long this_pfn = pte_pfn(pte);			\
> +		unsigned int i;						\
>  									\
>  		if (pfn_valid(this_pfn) &&				\
> -		    (((old_addr) ^ (new_addr)) & (1 << 13)))		\
> -			flush_dcache_page_all(current->mm,		\
> -					      pfn_to_page(this_pfn));	\
> +		    (((old_addr) ^ (new_addr)) & (1 << 13))) {		\
> +			for (i = 0; i < (nr); i++)			\
> +				flush_dcache_page_all(current->mm,	\
> +					pfn_to_page(this_pfn + i));	\

Is there no way to pass nr_ptes directly to flushing code?

Anyway,

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

