Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85D84C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 09:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89C556B00B5; Fri,  3 Jul 2026 05:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 873B86B00B6; Fri,  3 Jul 2026 05:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7632F6B00B7; Fri,  3 Jul 2026 05:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49F8D6B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:44:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F10FA04C9
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:44:26 +0000 (UTC)
X-FDA: 84946980132.01.FF6F153
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8437340006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:44:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DPLiZHb9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RFHq4t2n;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DPLiZHb9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RFHq4t2n;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783071864;
	b=t81j4z3OlNjnbhNOQ0HtTBTzRU3qQaQw2KfzrlHTUXK5tXWXKv7U6Ax2lt6uW7g7sh9Kr1
	lwZJfsgAXMaM7eibQNeQmUSam0FNwCk3bKwY1bpyovj4h6VubOEJCpYpWC7vGqqZK9tCp8
	OXbFpRhICXHSJbxeEXRBFETSKGHumBg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783071864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZvVdFC/w93Kd0pOreOXa++4p9nmwSNNQYlxhQaYUCks=;
	b=O3iZb5im42e+Ci1w0o/sIQEPKpjeZhrewesIgTl8jrJE/bqb97tUz2UDsk/mplhkDM/NCy
	9Ss2GIqNG3A1R4LzUCOYMzf22ZPwgHOcps0yaPTZE0GJnprTJhBwn2diYseaJUdqnIsxvj
	cbRwO2bW9gdOgONMY8PS3iUIgOuZ6Qk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DPLiZHb9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RFHq4t2n;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DPLiZHb9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RFHq4t2n;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 217FA747FE;
	Fri,  3 Jul 2026 09:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783071863; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZvVdFC/w93Kd0pOreOXa++4p9nmwSNNQYlxhQaYUCks=;
	b=DPLiZHb9AFizwgdPdY9ZWzKFAG1DhD3/oTe4wGbn51M13DPaair6AlbEX3LaV9XuUdBz81
	+giYBjxqeGo7J+lkc6Zx6O4HJE20nW4si+aVXHAEQ8WA+GGwEiJ96rkhulSg7xMgYxd5pN
	IRMjRKWfHWOwKHx6xE3I/LqStYDci2Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783071863;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZvVdFC/w93Kd0pOreOXa++4p9nmwSNNQYlxhQaYUCks=;
	b=RFHq4t2n78OVH5E64KJJlOEOwn4PMj+Vd75rr7m6vznsLIX71F+uh+aM1TQTPREfoDwij2
	U8TSotwPfJf9l0AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783071863; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZvVdFC/w93Kd0pOreOXa++4p9nmwSNNQYlxhQaYUCks=;
	b=DPLiZHb9AFizwgdPdY9ZWzKFAG1DhD3/oTe4wGbn51M13DPaair6AlbEX3LaV9XuUdBz81
	+giYBjxqeGo7J+lkc6Zx6O4HJE20nW4si+aVXHAEQ8WA+GGwEiJ96rkhulSg7xMgYxd5pN
	IRMjRKWfHWOwKHx6xE3I/LqStYDci2Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783071863;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZvVdFC/w93Kd0pOreOXa++4p9nmwSNNQYlxhQaYUCks=;
	b=RFHq4t2n78OVH5E64KJJlOEOwn4PMj+Vd75rr7m6vznsLIX71F+uh+aM1TQTPREfoDwij2
	U8TSotwPfJf9l0AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6DD99779AA;
	Fri,  3 Jul 2026 09:44:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vJYxF3WER2oBAgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 03 Jul 2026 09:44:21 +0000
Date: Fri, 3 Jul 2026 10:44:19 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Leon Hwang <leon.hwang@linux.dev>
Cc: linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, 
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, Alice Ryhl <aliceryhl@google.com>, 
	Douglas Anderson <dianders@chromium.org>, Gary Guo <gary@garyguo.net>, Anand Moon <linux.amoon@gmail.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH] mm/mseal: fix mseal documentation for 32-bit kernels
Message-ID: <akeDk49-pPgUDek1@pedro-suse>
References: <20260703022507.187457-1-leon.hwang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703022507.187457-1-leon.hwang@linux.dev>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 8437340006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 1duugodu3xa1twpime8oe4931ktqpmdr
X-HE-Tag: 1783071864-920707
X-HE-Meta: U2FsdGVkX1/xU3t1O36pxwL8yJ3v7xrZP19B2oJ6SrWwryCnWVyTc9dYDpnjihCv7w9o+iFpqGpvAtm/QMPqsmZ2tvlzrSrmIEqak8/xG4Ve7QKRLxmPqw8yhMe085Ct/Ea4alvh1nP3Tmk3DnI02E4X0NOIZjl4Sh8ZGsWf1YAfHrXIfKGA74zFy6IgKM35G2xe5hECyvbhh4sHt+/asu/i8IgoQCauua/6Jsh78kyNPbQv9ZPSY/uzKkT73z4DJDsUPNOTs2sQ5JctangzPWpu8p9+0hRd4+oq+VmTXazUQzHKZkGScln/6iR6CCTkm5OizrkVwqlKjT7GEPJPk/r+GDax3bbcH/xrqbUfaRr63d2GxmynnQZDKd6NK5jY7cgFotA/wFIMGgVFs0nz/BL90L81K7GhlB0h3U0kwEalbZnNp8yAI7xzQrREUif0m4+/bKHJkxBYcFKXE8c8Y3QJozngXHtQanrDTupTcChE0t9R3HsK/eVhgHz+vW/2YRwskqrCfYFcd5spB/X2RuqEZPEWDunuc2eBrAGz2XSQHEOx4jxNyle2DG9bMlsKpeojujNGLAmnhyHdYOqgpU2rhlbw6iJEMLkw0W8PmZR9SDEO6Q+hPGtBDdUSgXGruE/YCZHOr4dB1vm69kJ+5TeXNosZmla+Fj9hjBD66/IYqHAT7tQU8BCMLpFffCteW14FThFFBuJAlTTn07zLaV6rmJA3SbqD22Yz3xw5ulTYQMr3/qFd49lqZz2llNBSp9066IpYfd0jsXTSE0mQjIDrTYb54oYFgv0+KJqMRFRbupefvhzoKzM/30uIfAGnkQEqc0IyHq3AZw4fECmEgL2rQJOBNuNbjFeXDsfrYh80o+QzIY/PTQVXuJUzvU912/LQX/rVeFGyr8hVsv1b6AifIADAHgZbewQzJOwDnZBHOs/ogNsE3lAf0UBwHbrixwjV9wDwrmyAHld/ky1
 93ZU8qe1
 ckZ6u2lzv9JZcFchJyrBIsl2vam4Ebfncn+M66itnEaOHRck/EvrpeWOgprCRZi9uiMqJf/m9QfLrpod34cNO/jE+Y43hN7E4LUSdBKPc6kry2GNsPrPAwzDst74XwFm8GyCo74iB1Ph0yHGfB57WmVUlDcmOnTJDWLvBSWIkpqJ0mU0PpuN+BrkkZ5W6N3lg/QJvTz/FdrBESGabXqakjtogeJFACZZhwWyD6pPfRdvrbaemGqfKLItwxQR3xuG3PbKTKkrTJXzrJ3+uRxmWzmbUx2skmOgfb/mZ0ZH1zyLOqJlXmOPtgqzowZjoNArLgxbLOPu8qXvBYKPnGjhlgv+FURpMWq1H+cGehsHi7+9SbJXwF1UBqlNcMyEX+f/kqqKf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 10:25:07AM +0800, Leon Hwang wrote:
> mseal.o is built only for 64-bit kernels, so 32-bit kernels fall back
> to sys_ni_syscall() and return -ENOSYS rather than -EPERM.
> 
> Document the -EINTR return from mmap_write_lock_killable(), fix the
> CONFIG_MSEAL_SYSTEM_MAPPINGS typo, and describe system mappings in
> terms of VM_SEALED_SYSMAP.
> 
> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> ---
>  Documentation/userspace-api/mseal.rst | 18 ++++++++++--------
>  init/Kconfig                          |  2 +-
>  mm/mseal.c                            |  4 ++--
>  3 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/userspace-api/mseal.rst b/Documentation/userspace-api/mseal.rst
> index ea9b11a0bd89..1f1cf206670c 100644
> --- a/Documentation/userspace-api/mseal.rst
> +++ b/Documentation/userspace-api/mseal.rst
> @@ -50,8 +50,10 @@ mseal syscall signature
>           * The start address (``addr``) is not allocated.
>           * The end address (``addr`` + ``len``) is not allocated.
>           * A gap (unallocated memory) between start and end address.
> -      - **-EPERM**:
> -         * sealing is supported only on 64-bit CPUs, 32-bit is not supported.
> +      - **-EINTR**:
> +         * Interrupted while waiting for the mmap write lock.
> +      - **-ENOSYS**:
> +         * The kernel does not implement ``mseal()``.
>  
>     **Note about error return**:
>        - For above error cases, users can expect the given memory range is

Honestly, this whole thing needs to be deleted. We need a proper manpage.

> @@ -62,7 +64,8 @@ mseal syscall signature
>          memory range could happen. However, those cases should be rare.
>  
>     **Architecture support**:
> -      mseal only works on 64-bit CPUs, not 32-bit CPUs.
> +      mseal is built only for 64-bit kernels. 32-bit kernels return
> +      ``-ENOSYS``.

This LGTM.

>  
>     **Idempotent**:
>        users can call mseal multiple times. mseal on an already sealed memory
> @@ -131,20 +134,19 @@ Use cases
>  - Chrome browser: protect some security sensitive data structures.
>  
>  - System mappings:
> -  The system mappings are created by the kernel and includes vdso, vvar,
> +  The system mappings are created by the kernel and include vdso, vvar,
>    vvar_vclock, vectors (arm compat-mode), sigpage (arm compat-mode), uprobes.
>  
>    Those system mappings are readonly only or execute only, memory sealing can
> -  protect them from ever changing to writable or unmmap/remapped as different
> +  protect them from ever changing to writable or unmapped/remapped as different
>    attributes. This is useful to mitigate memory corruption issues where a
>    corrupted pointer is passed to a memory management system.

Also LGTM.

>  
>    If supported by an architecture (CONFIG_ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS),
> -  the CONFIG_MSEAL_SYSTEM_MAPPINGS seals all system mappings of this
> -  architecture.
> +  CONFIG_MSEAL_SYSTEM_MAPPINGS seals mappings marked with VM_SEALED_SYSMAP.

VM_SEALED_SYSMAP isn't meaningful to userspace.

>  
>    The following architectures currently support this feature: x86-64, arm64,
> -  loongarch and s390.
> +  loongarch, riscv, and s390.

This is also useless, every 64-bit architecture will support this.

>  
>    WARNING: This feature breaks programs which rely on relocating
>    or unmapping system mappings. Known broken software at the time
> diff --git a/init/Kconfig b/init/Kconfig
> index 5230d4879b1c..12bb39f637b1 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -2112,7 +2112,7 @@ config ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
>  	  from a kernel perspective.
>  
>  	  After the architecture enables this, a distribution can set
> -	  CONFIG_MSEAL_SYSTEM_MAPPING to manage access to the feature.
> +	  CONFIG_MSEAL_SYSTEM_MAPPINGS to manage access to the feature.
>  
>  	  For complete descriptions of memory sealing, please see
>  	  Documentation/userspace-api/mseal.rst
> diff --git a/mm/mseal.c b/mm/mseal.c
> index 9781647483d1..0464c7b94ab9 100644
> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -132,8 +132,8 @@ static int mseal_apply(struct mm_struct *mm,
>   *   addr is not a valid address (not allocated).
>   *   end (start + len) is not a valid address.
>   *   a gap (unallocated memory) between start and end.
> - *  -EPERM:
> - *  - In 32 bit architecture, sealing is not supported.
> + *  -EINTR:
> + *   interrupted while waiting for the mmap write lock.
>   * Note:
>   *  user can call mseal(2) multiple times, adding a seal on an
>   *  already sealed memory is a no-action (no error).

And this whole header needs to be deleted as well. No one's looking at
kernel code for documentation (and if they are, we did a horrendous job
at actually documenting the thing).

-- 
Pedro

