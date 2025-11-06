Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC104CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 15:03:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F6048E0018; Thu,  6 Nov 2025 10:03:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CDB58E0002; Thu,  6 Nov 2025 10:03:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3808E0018; Thu,  6 Nov 2025 10:03:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28AC08E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:03:32 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BD7F9C0146
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:03:31 +0000 (UTC)
X-FDA: 84080501022.07.AA59BB6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7828C2001B
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:03:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wGQ+gtaT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DDexFs6t;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=01wpdMeT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oe31NF4m;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762441409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HOuwkH32wNh1jajTPykXv5BJYRoed9vUlh1FUYNSAaA=;
	b=RRH7sblDxpNmQJObPhZOVL3+n0GFTGL6Z1tqM7gSANXe5TMIK7+tYu05TWgf+4bkv1lBx2
	6G7HrBqjSucC2AuRYmSNNU5APJvxWlNtho16j5R3ehbwmJbG6nLGzH0q7+8WpPncJVkWAE
	kaf530Nl7iRgbHVBd6e+TyPI/vT+q9U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wGQ+gtaT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DDexFs6t;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=01wpdMeT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oe31NF4m;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762441409; a=rsa-sha256;
	cv=none;
	b=ZSpIGzwFwcWkSbNh7dFB4lvqk8ulSLRhuRDFHipW65Ao3m+1RGdPXrqws3EYsefUXng0XR
	7xMvRFtb5CUex9zzgE8pdPQAMpk4vbt+eLMnJERcSgWNuduz/MtUVi9MMKg1O/fBr6+L2e
	IIhKz7LDCLSASOb6ExLzqhCIaYPGO04=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F3BAD2116D;
	Thu,  6 Nov 2025 15:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762441407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HOuwkH32wNh1jajTPykXv5BJYRoed9vUlh1FUYNSAaA=;
	b=wGQ+gtaT9MVIJPxQzAJk9nHKON1QhKutJFbvCIET4Yb4/bJtMaFPPy9w5qrEdWeo6ix+p6
	fYazGMnFXb9JuT7ytDt73mBc9+LHk6ypWWhdfltInKdExHoD0amJrZVUyHXZ3Y7AhISHm+
	VGLRDpEnEcXvYCUe0cx82pgtS+0P6IY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762441407;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HOuwkH32wNh1jajTPykXv5BJYRoed9vUlh1FUYNSAaA=;
	b=DDexFs6tGKjcQ2YvkaPfgLWY1m4/M1FVIlK39uUpI+aBoiAROQYqo19U6sm5VdLFRKQLFo
	pVNwvJVw485STHDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762441406; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HOuwkH32wNh1jajTPykXv5BJYRoed9vUlh1FUYNSAaA=;
	b=01wpdMeT4QaOzQTmQOmtg8AandmWnWsQXos0e+S2FB9sjS0GXp+HMMMx81IDz9F/VzQnWB
	pEBB2oJ1GpSVbdv8zvO+zYm5xeR/EZHMJY1ocEQGKxP3Ul8N1Sz+7CbSzWv8JA4hpL+CVH
	AMSeqRac+lDfh4rOxUqXx3GhFnruiWw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762441406;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HOuwkH32wNh1jajTPykXv5BJYRoed9vUlh1FUYNSAaA=;
	b=oe31NF4mP4vowzTL73VNM7GCu03qi2RD4jLPC2Zh3f9PMX3e538CzoelHIZ11XymFz/VrB
	y69Gxa4avZC+t6AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AFF7C139A9;
	Thu,  6 Nov 2025 15:03:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3jNTJ7y4DGlKZwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 06 Nov 2025 15:03:24 +0000
Date: Thu, 6 Nov 2025 15:03:22 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v2 3/5] mm: implement sticky, copy on fork VMA flags
Message-ID: <ksk52ws4jyfihg4s6jeliqthzk44vapkjhycitsb63ujzpt7j4@pkbjovy4ad7a>
References: <cover.1762422915.git.lorenzo.stoakes@oracle.com>
 <9c9e9fb6b767556594b2cef023db01d45d8f8463.1762422915.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c9e9fb6b767556594b2cef023db01d45d8f8463.1762422915.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7828C2001B
X-Stat-Signature: 4agp74bmwy8yafsiq1f6pknunq4nybgm
X-Rspam-User: 
X-HE-Tag: 1762441409-587345
X-HE-Meta: U2FsdGVkX1/+oNDRPXkHdvuGgy5DbRE11F9Gc2b+MZ146HmwJRIMR8IbfwjQI73Ac17qt9WTa2xpqhIdLJ4GRF+D7ftiyAlNfO+gFpeAB/qW/hRQ/SW+LQimHTDJhg36GQc7/8GukPXihFARURdtQbAbVuJBK16AKWpB63raNBF/N/peH6VosLvClWYt1PLGLqbf3dC2QexlGTNsSdOhDqf8HE23YO5/tuioAQcBRoNkwpbgy0zY892sWhLoBiq8MKRhQe09RCSw6jfR1oMeBdpfnuj+5HGtMfHAzHbU4oWPKecpKtfr0U5cJP4BztK33UmGxeI2s6ibwJpElOQV1xQBdJSJvDfR1g4icGVs8ScVJvuy9UcIzGXRkjaUpGPsS8ainSw1QAtmfrP7puctHGfYkNyeYoCWn69g0CumKU1I6fgxsPo0FUNMYnS3WTsJEGhROMoee9t4iUmyYrzt9+e04hHRoPoy6Rq+eHxPsnMH+9p3HjpWl9db+DwQsh6ft422VojGPCaLhc7sptQVNFJywUA0UlmYJu6z5zTXhKSA6CkRMuTjUfpkb0VfIb3h4sH5SK1ngSs/+Jr0p8jKgnYicW2RIq606jHdYuZxXbKY5pqqztjNgqKPBGCLRmeU+ciYycygzCK/8ZQGCHYmShHw2lgqO2ODWfhMyh8MYWLZAbjX5ImqV5u8QXe1PBIoE3nAQizGzITtBQwVTpTlWYgJ3qzq905wYi+aXBE3xiohRss8G1rt8a1znfKi3y99KfDrBzFKc56kK1GEPgI5qnAM4zV2jnmRqYRYNfyYqtqk5Fx75F8s6/N3ccSp1TxO7hY9mK1icL1d/esyQ+eUOB7O9pnwapaRkjQTlkQ+NsZp+jHxqNAgzgak+R5+HaQkS7P8sLhtHAuxRekHF1VZuNWMFz4sIrd/wNqnoUJ2Vu5pwhZDjmv3sWWeJLh8W4m1MZZa1HWFrcftE4oO6av
 hvuXFV0l
 eulHiwQXpV5VtZXp8KeoIor45YR3s6kxiS1RKQoYAhsBoZ/HfL3UUe+Y1l6n2U7OFyUFP/10JZGNngKB0nFqhBQ7IRShoftmDiF21jjI9Du9jWrXlZBo76UHWM/wtcsOb46gnf63jf3asBNEDLPR0Ykh8QN77yF10e3o85On5xnpwZXVu/vveaCXi/LINHE66fZ09KkM38gDPTKdKp4cQOTFbgP+LDrcYZTnlQ7VQzYaXr0b8rfnERZol1hzTPzNxnTYTpZYpexnnqBWuStXggm4P16EXm2+4WrPPsFp/rvYh41rog+NenaZIqRg6jbrYMJEdqY6625YOBX8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 10:46:14AM +0000, Lorenzo Stoakes wrote:
> It's useful to be able to force a VMA to be copied on fork outside of the
> parameters specified by vma_needs_copy(), which otherwise only copies page
> tables if:
> 
> * The destination VMA has VM_UFFD_WP set
> * The mapping is a PFN or mixed map
> * The mapping is anonymous and forked in (i.e. vma->anon_vma is non-NULL)
> 
> Setting this flag implies that the page tables mapping the VMA are such
> that simply re-faulting the VMA will not re-establish them in identical
> form.
> 
> We introduce VM_COPY_ON_FORK to clearly identify which flags require this
> behaviour, which currently is only VM_MAYBE_GUARD.
> 
> Any VMA flags which require this behaviour are inherently 'sticky', that
> is, should we merge two VMAs together, this implies that the newly merged
> VMA maps a range that requires page table copying on fork.
> 
> In order to implement this we must both introduce the concept of a 'sticky'
> VMA flag and adjust the VMA merge logic accordingly, and also have VMA
> merge still successfully succeed should one VMA have the flag set and
> another not.

Perhaps we should separate this patch into two? It looks like we're doing two
things at once for no great reason. But it's a bit of a sticky situation...

> 
> Note that we update the VMA expand logic to handle new VMA merging, as this
> function is the one ultimately called by all instances of merging of new
> VMAs.
> 
> This patch implements this, establishing VM_STICKY to contain all such
> flags and VM_IGNORE_MERGE for those flags which should be ignored when
> comparing adjacent VMA's flags for the purposes of merging.
> 
> As part of this change we place VM_SOFTDIRTY in VM_IGNORE_MERGE as it
> already had this behaviour, alongside VM_STICKY as sticky flags by
> implication must not disallow merge.
> 
> As a result of this change, VMAs with guard ranges will now not have their
> merge behaviour impacted by doing so and can be freely merged with other
> VMAs without VM_MAYBE_GUARD set.
> 
> We also update the VMA userland tests to account for the changes.
> 
> Note that VM_MAYBE_GUARD being set atomically remains correct as
> vma_needs_copy() is invoked with the mmap and VMA write locks held,
> excluding any race with madvise_guard_install().
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Overall the patch LGTM.

Feel free to add:
Reviewed-by: Pedro Falcato <pfalcato@suse.de>

and maybe print it out on a sticker.

-- 
Pedro

