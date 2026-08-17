Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92016C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E3C46B00F5; Mon, 17 Aug 2026 12:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7457C6B00FF; Mon, 17 Aug 2026 12:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6344E6B0100; Mon, 17 Aug 2026 12:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32B656B00F5
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:48:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B76F1140833
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:48:40 +0000 (UTC)
X-FDA: 85111345200.16.CE57218
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7D42A180007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:48:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Eh4wirmh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="x/a5xipD";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0OOXJSPA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RT94AgWl;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786985318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w3zLzmZPTjsyeCNJxTMPQyOwGFcxlb4bymJngOb4M0I=;
	b=NDSyzJM6PY98mHICSccThKME+axMNZ9bVDqQenMIBXFl6pC/XLBNU//TIryhW5Jm9CmUQm
	lIGYXPFiLt+TWED5SSwMDNRp87MdRIfCxP8lhrZ9Yl2MGD/Qz7kgojFpxSd/qZtz1+uaXb
	k/UXz6mJxQ8fO/CtVb2gwxCzhs9cqD8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786985318;
	b=cdp/CL7MqbP1q0j0IEr5C/qfOM5VDaXidbKy8GtmdfCAAg5zLi9eAAW7rCQ815iHBjSVxu
	tafOCJSqm16Of6CsLyWOe/8hL1PM9rdTtjlQPJzOP2TEYdgeEeFjLdig4HFBa/8sQ+zMZI
	7ZLRvhnFqg60onxv9BEzKAEE5s48qw4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Eh4wirmh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="x/a5xipD";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0OOXJSPA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RT94AgWl;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 03366840BC;
	Mon, 17 Aug 2026 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786985313; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w3zLzmZPTjsyeCNJxTMPQyOwGFcxlb4bymJngOb4M0I=;
	b=Eh4wirmhcatW88qg37SQqCKT4u6kSfztchn54o9nW/VyKqNgizumXLKO+CRy+7MidtwIWW
	iMtl+3/EeWgvvGAY974PBfD+rNUfIsWW5rSf89ITMqSgrvtCm3dYGw6MBdNaMqvVlxtVAz
	xEKaIO823UqlNHyQSwojB7qs+ixG408=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786985313;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w3zLzmZPTjsyeCNJxTMPQyOwGFcxlb4bymJngOb4M0I=;
	b=x/a5xipDgyFLGvK6XE/nRtUc6MTEfeJ1/+o4af+1OqxzVZmDb8ZQ8DwU9uAjSjq7x4afuC
	ihcWoR0RulW0bRBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786985309; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w3zLzmZPTjsyeCNJxTMPQyOwGFcxlb4bymJngOb4M0I=;
	b=0OOXJSPABxSA44ExlLIczk02MA3Z2jPvtNH8h14C6N+eyYK9PKpDg4moQg+kI5qp5iuv8K
	plU9ims/KnCKnsjizeg3dSdGtAuLcgzB9qBVuwgNItwLnaE+wmTu+8eO7ffBf9QqiZ64VG
	VYXQFK/6uFSDVrj25rF6p03NAbmAZPw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786985309;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w3zLzmZPTjsyeCNJxTMPQyOwGFcxlb4bymJngOb4M0I=;
	b=RT94AgWlmYM9MlGg6BqMycisJT2UJTpR5HSuvHhxMNdPB4qGhLwSRoaR1kHpU2aRjkTf9q
	UYTsjD68+tbEmEBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E181C79577;
	Mon, 17 Aug 2026 16:48:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kqKiNlw7g2ryDgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 17 Aug 2026 16:48:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 78A7CA13AA; Mon, 17 Aug 2026 18:48:28 +0200 (CEST)
Date: Mon, 17 Aug 2026 18:48:28 +0200
From: Jan Kara <jack@suse.cz>
To: Jann Horn <jannh@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/page-writeback: document folio_mark_dirty()
 locking more explicitly
Message-ID: <eref4jpa2fvzssamgks2qmt63enkfeioetj7jk57xhd2tejeio@smd77j22s2wa>
References: <20260810-set-page-dirty-warnings-v2-1-1bd40fadfacd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810-set-page-dirty-warnings-v2-1-1bd40fadfacd@google.com>
X-Rspam-User: 
X-Stat-Signature: sdm71archa613tjtcq9a99se9wbt4ko8
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7D42A180007
X-HE-Tag: 1786985318-888448
X-HE-Meta: U2FsdGVkX1+RAVhV3YUXr4UqNTo4Dm4OlNTJV25uwPZwkyQFHjaEVpMo7/ZTrJdOSPwMS4U3HJ3LTbIOTNQXLw648RpbcKAB04EHof7W8fraTmEf+Qn1G1pX+L/txJBG1ogYT/BfubWtIlxe0YtRQym0fSOn9Dj1Z+tRZ1f030Euo7utIizgEXWtlXnGejWSQ6ck+PaCIItS2kXwU7+C18ZbuEhWZTSMhUBYZPKCkZ3dRXNyaT2FD5KvUNj9fCZpUP3NuT/hj+8Qtt9IBu3FPfwuy+MiUp99TAVcfCccrcs1xVY9d1A1Q6hSrBcw730siyELDKMnxrTRj6fUfG0jtXEXv9/wbZmU5tzVtos1LkVy8hzyqlrTH1LWX4S0w4aELeaYEtp6Dff+LMipcxduL4uPdVJ48HcvUEhFVDw+qW9xTGMmFAHOIZtvptn/47bDaAvgesG2DQwVLBO0qFK7vRNXVSk6mWW2p0cUvHAQUOHUyrc+CPMzDp0of7+E55OHYE6/rTaGf4G1+iPl2OyPdO8Pzxa5wRgzAj30W7f0u5wQEfJmbynvIjxKwVW8JijxOTC3EbfO3ZrlJmx3P8FTPud/j4mkaKIjCzbIfw9hacBHzgzQA0EVjDWT2x3cfwa0UORSIxyecJxC9MbVjSK7392IABeZZK/b8aPnkTmyJ7gAQsdLNkGhPLY6TM87iF3j474IrILtWfnaR7e6o3q72v9l4fIzSCrcb7khem/v2/bjMn03tGRSBRv/8Wcs+91KDSZFfaxA7de4dKesxsOEInPP8V0HbRdn+jdqRcjAa2VuQ5l8InAupUpgAYOZH9ZPj1NUHDXfXrc1FdZhUr3TDy+PLXCDJoONZUrzUoM8B6PkrlGvkSpteloas9rCrMxBDKPZznv75ltwi7hVq5m0rxZa4A8B/ccKBhuWgXXpVik2rzIaiAEy4dRh1Vh2qbJ+V3X7tnKDiWJUZbeyFqn
 XuPX4Me4
 k/K7v8iMCwOxisPhQSiGqy91kE0Tedc7dnqwkG2D1B16IfS9r9rVmqsXINfTwEGUxZi+XLGAoJYfCDn0dsOjSjrv2mi/km5j3cR2+H/4UtzvDUEqCunxAhkCxjsJ3RVIcivE0lWIbvx2gcoNnMQpqkcxDII9WXSM8wKOkL7x31GNV5cVCjq4maxFdcMAbLBcaHbHMMD4XmPSlduLXgkGQ42+9TVVZuRs7jnAj+uDktaSMn+Y46AstrTrrTtWC8oZIkFtaA2CaDZuJUJ0ReYcjX6HS3OMlRLCa4iwpkZJEkLPrnqrLNLbFaL6kURIBghbB9L3Z0kFZeuCpefbxInkvxcxD72C5ys3ULj2du1qi+BOnifrhhv4w8KV/PM+ANl7ayKfmshmkSB/LsI51Sgkx82bTMYL/VeiX3BMsw7Mv1Gmbh4iA3CCbO6bM9gt9Y3AhHACJiG1be5XdzDaAwL8Q2gCIStg09gnVFZ6fZJ98euM5gb/mQTg9/x1LEU48gtfD9gFV2fqImLH4O0A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 10-08-26 20:10:01, Jann Horn wrote:
> We have had bugs where set_page_dirty() was used on a page from GUP without
> appropriate locking, leading to UAF, in:
> 
>  - KVM, see
>    https://lore.kernel.org/r/20260810-x86-kvm-setpagedirty-v1-1-85f180892d4f@google.com
>  - i915, see commit 0d4bbe3d407f ("drm/i915/userptr: Try to acquire the
>    page lock around set_page_dirty()").
>  - VMCI, see commit 5a16c535409f ("VMCI: Use set_page_dirty_lock() when
>    unregistering guest memory")
>  - kpc2000 staging driver, see commit b6d13bd9f2c1 ("staging: kpc2000:
>    kpc_dma: Convert set_page_dirty() --> set_page_dirty_lock()")
> 
> I think set_page_dirty() and folio_mark_dirty() need more explicit
> documentation on how they should be used with pages from GUP; so add a
> comment on top of set_page_dirty() and make the comment above
> folio_mark_dirty() more explicit.
> 
> Signed-off-by: Jann Horn <jannh@google.com>

Thanks! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes in v2:
> - reword commit message to drop references to out-of-tree drivers, and
>   instead add more examples of upstream bugs
> - Link to v1: https://patch.msgid.link/20260810-set-page-dirty-warnings-v1-1-53cad4890808@google.com
> ---
>  mm/folio-compat.c   | 1 +
>  mm/page-writeback.c | 5 +++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/mm/folio-compat.c b/mm/folio-compat.c
> index a02179a0bded..6212fdd6761a 100644
> --- a/mm/folio-compat.c
> +++ b/mm/folio-compat.c
> @@ -41,6 +41,7 @@ void set_page_writeback(struct page *page)
>  }
>  EXPORT_SYMBOL(set_page_writeback);
>  
> +/* Read the comment above folio_mark_dirty() regarding required locks! */
>  bool set_page_dirty(struct page *page)
>  {
>  	return folio_mark_dirty(page_folio(page));
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index e98748112d1e..b0ab687c83be 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2773,6 +2773,11 @@ EXPORT_SYMBOL(folio_redirty_for_writepage);
>   * in this folio.  Truncation will block on the page table lock as it
>   * unmaps pages before removing the folio from its mapping.
>   *
> + * .. DANGER::
> + *    Do not use this on a folio obtained from a function like
> + *    get_user_pages_fast() without holding appropriate locks; you might want to
> + *    use set_page_dirty_lock() or folio_mark_dirty_lock() instead.
> + *
>   * Return: True if the folio was newly dirtied, false if it was already dirty.
>   */
>  bool folio_mark_dirty(struct folio *folio)
> 
> ---
> base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
> change-id: 20260810-set-page-dirty-warnings-4000f0015394
> 
> Best regards,
> --  
> Jann Horn <jannh@google.com>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

