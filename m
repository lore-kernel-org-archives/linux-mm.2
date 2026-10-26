Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 891C160A2610
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=T4r7PFnC;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5IbUzN8R;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=T4r7PFnC;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5IbUzN8R
Received: by kanga.kvack.org (Postfix)
	id 8D8E86B05B3; Mon, 26 Oct 2026 09:04:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B0536B05B4; Mon, 26 Oct 2026 09:04:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6C06B05B5; Mon, 26 Oct 2026 09:04:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 515AD6B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:04:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0EE5A8104
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:04:37 +0000 (UTC)
X-FDA: 85364796594.27.2F9C086
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id CA68D20003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:04:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=T4r7PFnC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5IbUzN8R;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=T4r7PFnC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5IbUzN8R;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793019875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIswRzs/zvKVOfGAbelQflhj/nPlIN8fDFh4mSjv214=;
	b=q+rU2I7rQu6xpjQ8ccW4Paa82KqnmlVYkXMgwjfOPbAM+md0g+0mlNeorFVFy/Vua9FLCE
	qa72zaLDIgxpT5r9RBmsnXAjbOmiEQTeqvqP1mTCmz0k4RTfiKeEW5FUTdyZYmgEfBWcpa
	n4h3ODFiskbvHARpMMdHILCGgAm9F9s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=T4r7PFnC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5IbUzN8R;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=T4r7PFnC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5IbUzN8R;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793019875;
	b=8gnKsc9jOsRrYt7xTHiVKqhl9AlRuiFnstJWhoqGrr1/1X0pZFpPs4+XFUrlON9XUaCSGX
	l1OObvwrozzYl/5P28l4L0gXQ03vnV/JVdCp8ZYSheSkRTbBRd1dvJHtaTV1BqhrsMQ4dz
	4UY3zHSeBDuxaH2JFyNdKCzKzTvBzlw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 768DD22263;
	Mon, 26 Oct 2026 13:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793019874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZIswRzs/zvKVOfGAbelQflhj/nPlIN8fDFh4mSjv214=;
	b=T4r7PFnC6a6bo3FLPh2pHPasrNYwkUu22QRucY9lkw/eYVB08z666uo9MYMhM4MecGsSR7
	JnnGHD8z6p8qxSFiuieAh2BuTTT9QpxL+nXlRtJvRmHXPNupBevDs0FybktYEgVeDwN4K6
	1t4fdUqCSuCJSq+8q5XXKUjy6awn6Gk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793019874;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZIswRzs/zvKVOfGAbelQflhj/nPlIN8fDFh4mSjv214=;
	b=5IbUzN8R69d3Kd/2Ai6i59hb6GA0hs9Z8aHyYBjmv9OOVRrbCjwPPslMWrH39P+ZmOAbZf
	x4irkTqMvz3LDHCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793019874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZIswRzs/zvKVOfGAbelQflhj/nPlIN8fDFh4mSjv214=;
	b=T4r7PFnC6a6bo3FLPh2pHPasrNYwkUu22QRucY9lkw/eYVB08z666uo9MYMhM4MecGsSR7
	JnnGHD8z6p8qxSFiuieAh2BuTTT9QpxL+nXlRtJvRmHXPNupBevDs0FybktYEgVeDwN4K6
	1t4fdUqCSuCJSq+8q5XXKUjy6awn6Gk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793019874;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZIswRzs/zvKVOfGAbelQflhj/nPlIN8fDFh4mSjv214=;
	b=5IbUzN8R69d3Kd/2Ai6i59hb6GA0hs9Z8aHyYBjmv9OOVRrbCjwPPslMWrH39P+ZmOAbZf
	x4irkTqMvz3LDHCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3B83613408;
	Mon, 26 Oct 2026 13:04:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XqdMAeFP32rTXAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 26 Oct 2026 13:04:33 +0000
Date: Mon, 26 Oct 2026 13:04:31 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, SJ Park <sj@kernel.org>, Kees Cook <kees@kernel.org>, 
	Colin Cross <ccross@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 3/4] mm/madvise: preserve VMA_SOFTDIRTY_BIT when changing
 anonymous names
Message-ID: <at9ProKo5XiQ-CRW@pedro-suse.tail5790ac.ts.net>
References: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
 <20261023-fix-vma-atomic-v1-3-8ff4fae1fc85@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023-fix-vma-atomic-v1-3-8ff4fae1fc85@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Spam-Level: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CA68D20003
X-Stat-Signature: fe3jdabt93jeuf91jhsqjreakp9a64o6
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793019875-980723
X-HE-Meta: U2FsdGVkX1+2qLWwbjWdL1PRwt8dTnlmdUgPz1jMOU2/KEn8cWaTl95jKRWKRd1J+eLnWVPGmfmREkHm9dM3KHQbf4PlpR4vp2wj5uzkW9+fqcRixCi3znUF0xp/3xnYYT5gJKi6MnGn5AORQxT2lKTIDAnX1XhDORspqIxYjo6WsNjl7c0hFF9UXvqrLjzk3M1gT7unkwIsBSOuLyRAuWyA6HS6HLIASajPUCnHmbrWuR5i1jo2UQ8RVeZMStkQpyOwk6IG/L1LadZWzItwMxUSObGNaV/BpWkQk72takbTt2bBHN1hu3gz2BuD3RrwAotE6oCDEDGcAnQcEFZOkLtNPN6xXe84Z82c/88L1YL045/OIsYQFTDnN33Dv2a9qCukYV/XuyiriALDlYhiLu177mkRmwKG8kv722BF1s94tRi1ZiMkTUYJPRKOij7EcfaUmgX/feaeFxBqbZJkD7Yva4H1LIOZ+bX2NltbpjH2an+orqiF4FLIJxwZ9nfVeNcjD03vX7qOtTjDy5+snyQaCI2qXZQ/Yq2+fbeUmLN3XrmAeiNEqPU8StqWQdzXGXlTHld/jYBy17pgYdsh9l+r06oKHLmqPA90nguWHr8U/CL/qpxTGK5rz/niyX67103QkJbMZaA3jzcwpGoCeS6v2nzHB2IJH6o4ZwBccwLAn9kkpomurmSeL66/Wa1um2RHntg5BPIAojxcpnk9jMYBS97x1NxbSpAaK3dna5K5sT3cELd1XtJ5lH2RE18tK2A9VI6d9bmujMyATs9ybhU0uQ+735hQ3Ig6N3UGHC3Vr60fXkcqXKRDtX/LLGegsj+2+DQToguEZPVE3/trQl27dwj4dM2fwvtdB1a2vc0JSZzyLL5Ys8mNbI7nU5SkwN6EJCupSxhHreh+vfus5n6+cHc+dFdTxIXe1dqkfMFuWiwXyD6nFPVfvig5O5mnTNTIH5z4tVNgG9jFNWk
 lH7x/nwo
 RvfHOK1h+FO+ZUdtnkpau726/id7A5rRVRi3rQvfwbkfvCkmQLp47Bg7CAgHlJxApAXzzM74r4vfT8ZPtF+jWoivwNxKbLLHX1ekMe3ywhvlxUIy0bIix6WcxUbBRm5EjtZ2/8UQS7GlR+7D6cm1iuJcBY958G5fEuoVi+Yb968Jp2R1fb9XxicKKGmlDw6ueIH1AsPZ2/c/s2ZbzT1Sc+jTvNVBUsFwy+eWEeT9XF2g9/P6HYwatQBrCOUOmcw9ZpNNQ0BeDvl27agCzNkHBvHWzOoJIOrdF8yfDDYl2oGKfzgW/mDl0Ih/QnKhEI0zR7Ief0AXn+yBD9gDod+o2Dmq/rY2KuFP9T8HKkx0I4UaLLbL40Y7jEu0gDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 02:47:29PM +0100, Lorenzo Stoakes (ARM) wrote:
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> 
> When changing the anonymous VMA name, madvise_update_vma() calls
> vma_modify_name() to possibly merge with adjacent VMAs. We don't call
> vma_modify_flags() and consequently don't obtain the new VMA flags.
> 
> Later in the function we update the VMA flags to the stale new_vma_flags
> we obtained before. This can result in us losing the VMA_SOFTDIRTY_BIT
> flag set on a VMA we just merged with.
> 
> There is no need to update the VMA flags at all, so just exit early. This
> skips calling khugepaged_enter_vma(), but since the flags didn't change
> this is fine.
> 
> Fixes: 9a10064f5625 ("mm: add a field to store names for private anonymous memory")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> [ ljs - Minor edit of commit message, rebased ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

> ---
>  mm/madvise.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index b2e00efcaa54..e9fa4f71efea 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -177,6 +177,9 @@ static int madvise_update_vma(vm_flags_t new_flags,
>  
>  	/* vm_flags is protected by the mmap_lock held in write mode. */
>  	vma_start_write(vma);
> +	if (set_new_anon_name)
> +		return replace_anon_vma_name(vma, anon_name);

This looks non-obvious and brittle, maybe have a comment here?
Or some more clever solution.

-- 
Pedro

