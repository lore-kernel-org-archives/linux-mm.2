Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1973C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 15:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D2876B007B; Fri, 24 Jul 2026 11:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 982EB6B0088; Fri, 24 Jul 2026 11:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872426B008A; Fri, 24 Jul 2026 11:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 594F46B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:32:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDBC014038F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:32:51 +0000 (UTC)
X-FDA: 85024062942.02.FFB4B5E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id BFEEE4000F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:32:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2LOVYft9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ngn5ZFPe;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2LOVYft9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ngn5ZFPe;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784907170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MgLR94cnov6/P8Yl4U/7T81H0kr3VMn5Pq5dQ8bzHh8=;
	b=0JwRw7lV5cq39U7HdB5BH6BacQYL9pwmfsrKa0XxssAYrS3iY90vVgkuSWUxCR1P45kROk
	0cbr0Vb3bMTgQbUvxLuf/HDFrv1hqo6Rc6mrMg4kkk8TbKa/g3ZqyVk56I+kK8xqiv6mU5
	Ld3AKfLyEx2GB+kFwwpAQPbvnh2g6Tc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2LOVYft9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ngn5ZFPe;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2LOVYft9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ngn5ZFPe;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784907170;
	b=H6l0nuFqHgIHLh2Js3yPrpR7nix3ozgrs63TcmmacdRKGX0Kjc9tN+Y65bC6K+Y6RBshsc
	mj8pURsR8beIQX4fhaMLCLstRJylbFAuOFkj25p9g7wVnJbodbd2AZerisBvd51KQNiEEh
	CSOV4BkSVIJz2S5TVhN1AwBxgTe6LYY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 401727BA2C;
	Fri, 24 Jul 2026 15:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784907168; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MgLR94cnov6/P8Yl4U/7T81H0kr3VMn5Pq5dQ8bzHh8=;
	b=2LOVYft95wMJIyhJa6PZSbwOiNmbFFPbcqUTuJ8eG3N/5dEfFfS1xnrE15U2j40DHgjDmq
	6SVMdKicnUTzPnTNepl6LS43ziFb719IQZ/YpmgYwEQMWN5wsTERRtQjRxILqRY7bav/0w
	AiPtTwFDpTdCdCi2BNy9lyN9DKbBWuU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784907168;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MgLR94cnov6/P8Yl4U/7T81H0kr3VMn5Pq5dQ8bzHh8=;
	b=ngn5ZFPemuxkfH460JBtHk6gBgwLnC/4m+F/Wm5dLwshckWwMM8hRMhkcYUYLvLbPxDwRh
	a99cvpioZ+OPOGDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784907168; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MgLR94cnov6/P8Yl4U/7T81H0kr3VMn5Pq5dQ8bzHh8=;
	b=2LOVYft95wMJIyhJa6PZSbwOiNmbFFPbcqUTuJ8eG3N/5dEfFfS1xnrE15U2j40DHgjDmq
	6SVMdKicnUTzPnTNepl6LS43ziFb719IQZ/YpmgYwEQMWN5wsTERRtQjRxILqRY7bav/0w
	AiPtTwFDpTdCdCi2BNy9lyN9DKbBWuU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784907168;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MgLR94cnov6/P8Yl4U/7T81H0kr3VMn5Pq5dQ8bzHh8=;
	b=ngn5ZFPemuxkfH460JBtHk6gBgwLnC/4m+F/Wm5dLwshckWwMM8hRMhkcYUYLvLbPxDwRh
	a99cvpioZ+OPOGDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C990E779BA;
	Fri, 24 Jul 2026 15:32:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KCyrLZ2FY2ozGgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 24 Jul 2026 15:32:45 +0000
Date: Fri, 24 Jul 2026 16:32:43 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Usama Arif <usama.arif@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/5] mm/parisc: constify ptep_get() argument
Message-ID: <amOEUZlp1BxYh6_t@pedro-suse>
References: <20260724102017.141532-1-pfalcato@suse.de>
 <20260724102017.141532-4-pfalcato@suse.de>
 <0fd713a8-e4ab-4c07-b36e-79dd138b4a86@linux.dev>
 <amNzLXuwflIZFKtI@casper.infradead.org>
 <253f7ac0-205b-42f1-9fb5-d19eceb581b6@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <253f7ac0-205b-42f1-9fb5-d19eceb581b6@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BFEEE4000F
X-Stat-Signature: ntw7exwf8qghmhifheundzru5b5wre5t
X-HE-Tag: 1784907169-321684
X-HE-Meta: U2FsdGVkX1+AMU9/tibOlerMM2/ynLVXceW7A2+1uES37J9AqGM2jDNDF8IOWbuUUFV9+WCINsj+s6suQhd9/MS5cXZAosJViiX3NJkuMhoSVdbLKVkf5CE1+KA7t1g3fXx1Hmv2r21z2NNPyU8mG4HkertoJoh5jVrdnoKpVHZ573VHohnOhkCe8oTKZ2fM6I90VH6NeqwEu1WnkuNOMT8uahoJOPAEQsH+TjD4vQTPBcx3D45N55Xpb474lXcL0I7XfGrEEyIWoZ7Rnvwn8fpvyQV2LEM5+O5VM51DYvOWvaKvkjqItM0ZNNbBJcgApy/1fRSsQhjKmyjD7X4D0TCNL2DIiNtoDz1WJpWEo3ujCD+glVXgbDUF1g6JP1XY9ZctLsdtF0C2jPWIQkO6dtpl9kcWDQwIHdwINl04ilnwOEoYE3vb61Ud+kdkJMLNjyttCBOu6eVhBlU27pEsDnEG18Fu+wPBEXGMU7+b56YUfQ22JNb8gucSI/ogbejWPA1g9/PwpWM/8+uFAfJvBwT+q18Jg/j9jrn/PdcbCHyU7Uo44DOXDty16vgjYMHdvngLBbaC27fZCr2q2i0vez5iS2787tTFFsVBeWA+dhUNs7yonM+JOobENatfUdTsPFlwdfMuyCNR2g9xXJuu38YzOY2e26UYecO/9bNgncTOjeRBbsdz4YrTiR4SF9aomUc7zaIk1k56uKbetoGohW30JtY/q//MjuYNVj45aDMrHcU6gsCBTvIDpSvRxRmhG2P4YQkIhHMIpPJenFswWCi6VU/ibF8rAVtk5l4/ZFCaIh8c5UfMzUKcrbcr94EBDsshqan1P72xngibO2c1xfr4GUz5YWwM9DLTWEl9wYOloRmJPVSxADbJEFU5a90QwJ5Tdx57G4fVtsyfjmqTiAg46tkP4+g19+FjF0J9QV1Fpz+y0KfFKuz5oOLd+lCP0g6Az/8yTVNLg07R6hW
 86nQDoad
 G/Ppc4gcpl5uE/eiSyK1kIsTaSAIcA1xFz2kPpIVBiF6RQ3lUs3CJM6n/UeZokikaiVxryP10SqvTVAK8cId5YCFzXW+AcNBdaZPtp3yu6wkjn4wBFZIRqll0xSJf2EIlHe+aTqFiH+5EAQZjcsDCiGIodp4AtWytbocG4ylgjS0T4RwsDng4UpuWxFlMiz/DCkheYUrAq5MPl5b92vGQXjON3/hgOEKbsUNWIdKzUNMRAjbVXtdNtCWGWByDp/IIrnzxjFfGa4RUIoFzYNq4G/fG0e1MEV3h1OSItfUfvwSUI/owC01lTl9H+zJlrCNAcBoVnP+mgAttbEiEzmonk04/DaRUaX4QK5Ti2WXLhceIa3qFwy3LWusLH67k/fRKPZ0OCiov+fTbqVT7QOuy1sEQt1ylPenqRJkiOt7vjqcK0OQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 04:03:44PM +0100, Usama Arif wrote:
> 
> 
> On 24/07/2026 15:14, Matthew Wilcox wrote:
> > On Fri, Jul 24, 2026 at 02:36:59PM +0100, Usama Arif wrote:
> >>
> >>
> >> On 24/07/2026 11:20, Pedro Falcato wrote:
> >>> ptep_get() does not need write access to the PTE.
> >>>
> >>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> >>> ---
> >>>  arch/parisc/include/asm/pgtable.h | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >> hmm I think you might break build bisectibility if
> >> you separate out the patches, you should squash patch 3 and 4,
> >> with patch 1.
> > 
> > I don't see how this breaks bisectability.  Can you elaborate on what
> > you think would break?
> 
> Patch 1 does:
> 
> -static inline pte_t ptep_get_lockless(pte_t *ptep)
> +static inline pte_t ptep_get_lockless(const pte_t *ptep)
>  {
>  	return ptep_get(ptep);
>  }
> 
> 
> ptep_get() takes a non-const arg till patch 3 for example for parsic.
> I don't think you can pass a const variable to non const function arg?
> 
> So parsic won't compile in patch 1 and 2, powerprc wont compile
> for patches 1, 2 and 3..

Aha, yes, nice catch! I'll have to rethink that. Maybe squashing the patches
would be the cleanest way forward.

FWIW, the vast majority of architectures aren't doing funny things on
ptep_get(). E.g PA-RISC, loongarch only define these so they can use it in
their own asm/pgtable.h. I'd really like to delete these but I can't tell
if they are *actually* required.

With those gone only PPC 8xx and generic would need to be squashed (arm64 also
defines its own version of ptep_get_lockless()).


-- 
Pedro

