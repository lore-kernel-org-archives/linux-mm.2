Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC845CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2819E8E0013; Thu,  6 Nov 2025 09:45:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258E98E0002; Thu,  6 Nov 2025 09:45:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F338E0013; Thu,  6 Nov 2025 09:45:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05C3B8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:45:14 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AFC77B5383
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:45:13 +0000 (UTC)
X-FDA: 84080454906.03.0E6FED8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5808C100015
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:45:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iIYqVCVW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="cJfUt/5W";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iIYqVCVW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="cJfUt/5W";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762440311; a=rsa-sha256;
	cv=none;
	b=Ggoav65oA0tWa3HFXfU+EOJd3oEvexY6mgdoF+nCWBz7jNIHpvemYaeiSdWEIMhgzqCRzd
	KAGYtpVnKE9PybzKWfdnMT2cRO1jNiKpqSrYmd4wbdjLNzUHgfRQyCZTgF4NjG2KnD05Yb
	VlJCQkzJ2beXiv8tldSvmAePdYFSTE0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iIYqVCVW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="cJfUt/5W";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iIYqVCVW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="cJfUt/5W";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762440311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nKYZuLb6Nw7zZ6Jj1iayriDsnFotAsi2YnGGy/qZxaE=;
	b=0E99sVnS2jARJRc8taal1DQJV/y+IVtKEy4lNTvWV8OpkznNWwRXnD3b0lIY9uBSvlHmfU
	y+OWJ/5Z+4jVr0cYJuyraAe+R1r0qPRPyrwWgKa06FIU8iDZ90E5nJoqBvzRCpcbfhZOEN
	3JxRXYnw1s+SEx+r621XjLxbGCczlwE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9B3741F747;
	Thu,  6 Nov 2025 14:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762440309; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nKYZuLb6Nw7zZ6Jj1iayriDsnFotAsi2YnGGy/qZxaE=;
	b=iIYqVCVW8trouxIau1Jb2p19gyPQLsOzO1T9vdE53k93FoKMpvRHjpW790I82MgSqiM7l5
	lV9viSF/+SuKgoSxNvpQGlp+lA/4cEM1bu/0spHHY+6hnOEqgK7M3qH1WUoEoJCwdWdEaY
	GELOWUe6yFpgvaxfGc5iPNviJy8PonQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762440309;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nKYZuLb6Nw7zZ6Jj1iayriDsnFotAsi2YnGGy/qZxaE=;
	b=cJfUt/5WY9dWjKauNGghYkyh6CE1i/Bw1taOd7vAPymyisRI4Wv7MWMPFElfXjs27hvHWq
	FGCwOCOTNY6308CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762440309; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nKYZuLb6Nw7zZ6Jj1iayriDsnFotAsi2YnGGy/qZxaE=;
	b=iIYqVCVW8trouxIau1Jb2p19gyPQLsOzO1T9vdE53k93FoKMpvRHjpW790I82MgSqiM7l5
	lV9viSF/+SuKgoSxNvpQGlp+lA/4cEM1bu/0spHHY+6hnOEqgK7M3qH1WUoEoJCwdWdEaY
	GELOWUe6yFpgvaxfGc5iPNviJy8PonQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762440309;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nKYZuLb6Nw7zZ6Jj1iayriDsnFotAsi2YnGGy/qZxaE=;
	b=cJfUt/5WY9dWjKauNGghYkyh6CE1i/Bw1taOd7vAPymyisRI4Wv7MWMPFElfXjs27hvHWq
	FGCwOCOTNY6308CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 52D9C13A31;
	Thu,  6 Nov 2025 14:45:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cLPwEHS0DGnJVQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 06 Nov 2025 14:45:08 +0000
Date: Thu, 6 Nov 2025 14:45:06 +0000
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
Subject: Re: [PATCH v2 2/5] mm: add atomic VMA flags, use VM_MAYBE_GUARD as
 such
Message-ID: <y6a4qchmj7jnaogx6u5a3i6lni7v54lj25ipwb7tdtakcudakr@vm6vt7eumxax>
References: <cover.1762422915.git.lorenzo.stoakes@oracle.com>
 <94935cf140e3279c234b39e0d976c4718c547c73.1762422915.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94935cf140e3279c234b39e0d976c4718c547c73.1762422915.git.lorenzo.stoakes@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5808C100015
X-Stat-Signature: u3cfe1of964ca95dscxjjpp6hcz4cs7q
X-HE-Tag: 1762440311-668499
X-HE-Meta: U2FsdGVkX19ylYMihK+RG5w8IUnxcr8LQGI1C4wLoAQ0nUOu3dDGswssg5dcgWNsniCk5ypmCHQ4TQGLN4E+RdGwdq+/16dFOrAbFArRGQVHAiEmjUM96xZFIfcv8rSpbDzRU+ymbqrx0UKaafsOrfbLFw0FKsgx3jYMi23ggMjHODshUhup1xNqicEcXaJqPRY6EIlnrP6HBk4+eHs3NcBOytbMKtV9KtrSrRbtb4/V8RkXSb9oYTN3aIMz4jgGtUmlBJHjvcFL2cRsVAfwddYYkAlFa3Xcai9+mmGLapcFGNG8/i1K6+o0An+hHxsBs890Kg4yujYFwXdZuH9Gsma5V387YhCyDc9YcWFJVY8CnBbhWvV0r7evxTJlV/3EbWhAsyAqbjS++5LllZZrl/aRif/SL/LBNVeeTs8cGxT6WzreZQDPpu8gQMu+ULPBX0q+GTx60DZ2cLXGlYf9i15vNNmgzTSihZD58qUkDByyrA9wUvH4O7DAOtnD8/yLfZQNQSza//WMqRHDxNsEqJj8y1HKgmG6SHVawf2jZ7UTYF1oTwUIpSWpDO7HpAQQ1lnY9Ra6YzsotllNUCn8hNV/Yda8jYkJ0fW/iWDTtyKSvxG+mjgYCjEHIyDnHp2Ch/nY8NhmpZGstQi9atAo5SGHap+qIiw9FIRUwIwJlDYRA6Zj7t0dXjhYLZzWF9pQflKVs49cq+WVGSOeGMSVnSxHOfN6CynbRaD8F63Yy/3odH/3GxM5Uz5fLTh6Rg/KlIGslLWn/UwJHcSdE0wdoKeCrg5+Ij3SJRFOe1zAImYRhlfoxOn74jD9k7W9RM25K+Dg9ckK1pdh2d1pUrtj9K7scPnjiojgZdqW/WS3BqHjyHlM0U3oHbui8/+jQ/BCxkUObnGSdwZF4U1BJIwVkNHvPDoICSEB4HhjHDSMrnZsmshqqpwzeAXs+0ZPz3TB0lrJSpR10n2HoAnDFlG
 G9DrhR/M
 TRbKvk0p3kqWa6V30h3GctUSlqxCjeJIZI/USiskl/qaJLIPuUzEWRIBKv4s4BmzBqNe5PbdRPHhdrqedTAjsg6O/GhvZGoJplwyszCm7FQrWLFrW0j906AfqvNDqqEBrpUDDb2wj1+jwqmg77i/r16UPZnwoQHj3J1PHVy5zgDkkNaUcvj13D3pNThZAV6BQ3Z8n8lolihtQI9YtMrhKJtFgNt2S4bGE6Bzc5a0kCcD7GHwwDov7wovhfghMS7xFT0wvki22PLTJK36xBcLYyIV5+p0/c+BjLY2dJqrARR710XEpzZdwjJT8xZLnGczperdSeCs0iI42QM3sgfoHswF1HeuhjqYlT1rN5Yhy9VeLxIgkTuwkGlbFgQr65hCgfOnAaTMFfRiB4Yo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 10:46:13AM +0000, Lorenzo Stoakes wrote:
> This patch adds the ability to atomically set VMA flags with only the mmap
> read/VMA read lock held.
> 
> As this could be hugely problematic for VMA flags in general given that all
> other accesses are non-atomic and serialised by the mmap/VMA locks, we
> implement this with a strict allow-list - that is, only designated flags
> are allowed to do this.
> 
> We make VM_MAYBE_GUARD one of these flags, and then set it under the mmap
> read flag upon guard region installation.
> 
> The places where this flag is used currently and matter are:
> 
> * VMA merge - performed under mmap/VMA write lock, therefore excluding
>   racing writes.
> 
> * /proc/$pid/smaps - can race the write, however this isn't meaningful as
>   the flag write is performed at the point of the guard region being
>   established, and thus an smaps reader can't reasonably expect to avoid
>   races. Due to atomicity, a reader will observe either the flag being set
>   or not. Therefore consistency will be maintained.
> 
> In all other cases the flag being set is irrelevant and atomicity
> guarantees other flags will be read correctly.

Probably important to write down that the only reason why this doesn't make
KCSAN have a small stroke is that we are only changing one bit. i.e we can
only have one bit of atomic flags before annotating every reader.

(Source: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/kcsan/permissive.h#n51)

> We additionally update madvise_guard_install() to ensure that
> anon_vma_prepare() is set for anonymous VMAs to maintain consistency with
> the assumption that any anonymous VMA with page tables will have an
> anon_vma set, and any with an anon_vma unset will not have page tables
> established.

Isn't that what we already had? Or do you mean "*only* set for anonymous VMAs"?

> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

With the nits below and above addressed:
Reviewed-by: Pedro Falcato <pfalcato@suse.de>

> ---
>  include/linux/mm.h | 23 +++++++++++++++++++++++
>  mm/madvise.c       | 22 ++++++++++++++--------
>  2 files changed, 37 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 2a5516bff75a..2ea65c646212 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -518,6 +518,9 @@ extern unsigned int kobjsize(const void *objp);
>  /* This mask represents all the VMA flag bits used by mlock */
>  #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
>  
> +/* These flags can be updated atomically via VMA/mmap read lock. */
> +#define VM_ATOMIC_SET_ALLOWED VM_MAYBE_GUARD
> +
>  /* Arch-specific flags to clear when updating VM flags on protection change */
>  #ifndef VM_ARCH_CLEAR
>  # define VM_ARCH_CLEAR	VM_NONE
> @@ -860,6 +863,26 @@ static inline void vm_flags_mod(struct vm_area_struct *vma,
>  	__vm_flags_mod(vma, set, clear);
>  }
>  
> +/*
> + * Set VMA flag atomically. Requires only VMA/mmap read lock. Only specific
> + * valid flags are allowed to do this.
> + */
> +static inline void vma_flag_set_atomic(struct vm_area_struct *vma,
> +				       int bit)
> +{
> +	const vm_flags_t mask = BIT(bit);
> +
> +	/* mmap read lock/VMA read lock must be held. */
> +	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
> +		vma_assert_locked(vma);
> +
> +	/* Only specific flags are permitted */
> +	if (WARN_ON_ONCE(!(mask & VM_ATOMIC_SET_ALLOWED)))
> +		return;

VM_WARN_ON_ONCE?

-- 
Pedro

