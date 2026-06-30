Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B320C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF2306B00D8; Tue, 30 Jun 2026 12:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2BD6B00D9; Tue, 30 Jun 2026 12:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C43396B00DA; Tue, 30 Jun 2026 12:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 926496B00D8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:36:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0FA224053C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:36:28 +0000 (UTC)
X-FDA: 84937132056.28.6DFD0DB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id DFF75180014
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:36:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Csm/0TAQ";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SuTooq+C;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Csm/0TAQ";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SuTooq+C;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782837386;
	b=tDwYDyDzKK/FIdpHPKVfzs904YjChktEEvhyXZHIXQCSqjEXdL8cPBXD/UVVI2qt0dbzuS
	FdTts+AS3vuIOWUUD2tiQ+vnUCBBSKigQ2ITvWaZdDB6tiSfDZzPnVrQ3PqAv71gl3C66s
	EJ1EZYKreKHNj9ULwMbGupWnBPldzyY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782837386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zwtvYcpEu3U9PLHqG7OTydVnRKJe82b04p0UFeAYHjA=;
	b=35bAxlUI7JIjoH/X+Sx/w1vyq2MYhQ8pWWOixulff4ocR77E7evibZFu70ZNU0LMQ1y2sK
	MuQ+mYIoiIfqdJuUOLlBvC/ewAk+aatNJgvj5U69sr7xYDkoerjii5/jMTKUrPxKuDBxSS
	3fKA6fOxHKll/csge8BxBldYzpDJxtM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Csm/0TAQ";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SuTooq+C;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Csm/0TAQ";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SuTooq+C;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9459571654;
	Tue, 30 Jun 2026 16:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782837384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zwtvYcpEu3U9PLHqG7OTydVnRKJe82b04p0UFeAYHjA=;
	b=Csm/0TAQDKcAqPahjvJm4t6wIygBvouh4o3HLWaKsgyk698bUArVP/FODSuGjNHcARgLTj
	CJc2gPmeHEfliGZdWDOcmZZZ0vZ9z95eXBkXNuiEMJpmpW8Tp01B9gZwKHKhDLyJoN2tn+
	chGgPP4YUFkHsmNHRAZUF9xPb+SnjMo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782837384;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zwtvYcpEu3U9PLHqG7OTydVnRKJe82b04p0UFeAYHjA=;
	b=SuTooq+CQho1YfxuTrEUMCh69pnVtR5UtZwMeH7IAZfA6dmdObdMjx1/u2fLm2dXcH2Fos
	1ruN1lCKBfY39zDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782837384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zwtvYcpEu3U9PLHqG7OTydVnRKJe82b04p0UFeAYHjA=;
	b=Csm/0TAQDKcAqPahjvJm4t6wIygBvouh4o3HLWaKsgyk698bUArVP/FODSuGjNHcARgLTj
	CJc2gPmeHEfliGZdWDOcmZZZ0vZ9z95eXBkXNuiEMJpmpW8Tp01B9gZwKHKhDLyJoN2tn+
	chGgPP4YUFkHsmNHRAZUF9xPb+SnjMo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782837384;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zwtvYcpEu3U9PLHqG7OTydVnRKJe82b04p0UFeAYHjA=;
	b=SuTooq+CQho1YfxuTrEUMCh69pnVtR5UtZwMeH7IAZfA6dmdObdMjx1/u2fLm2dXcH2Fos
	1ruN1lCKBfY39zDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E748F779A8;
	Tue, 30 Jun 2026 16:36:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GZUpNYPwQ2qifgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 30 Jun 2026 16:36:19 +0000
Date: Tue, 30 Jun 2026 17:36:18 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Thierry Reding <thierry.reding@kernel.org>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, damon@lists.linux.dev, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 12/30] mm/vma: clean up anon_vma_compatible()
Message-ID: <akPwbHbGiF1FxL6m@pedro-suse.lan>
References: <cover.1782735110.git.ljs@kernel.org>
 <5a7a07bd2a774989849b0fea84f758059ed914df.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a7a07bd2a774989849b0fea84f758059ed914df.1782735110.git.ljs@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DFF75180014
X-Stat-Signature: 7ubjf3kqord5dzaus4q8u93p5ni5gggt
X-HE-Tag: 1782837385-632273
X-HE-Meta: U2FsdGVkX18ySIo+GS9Dh9aXwNiNT6bouv5MeCx5udVYWUYLnzJFghQCSRj53Irnf79qRYH/+np/rWY0ZG4VT8f3S3Cpv8B9k6oRTDQNU9iCzvHLxu17dJgxjx6VB0NPvjiSJTnS4VEm9yoE2WZa7fWbB48fV/pfZxzaDwy62D50De2nqfOB5FvqyIaxUS68OINduoMgyNGUr4+bzhPUIU8+9W390tVXRz6PPE8IrYm1dDPKh7ZCTALuY6rXrSMbfO6nQVYmOyKzfVlS5GRkVwzJZhkId9n1J9DALDzz311PBLwUPOdwR/g4uMD4nL1MXSW1RF+vVlEFXACvlcJImDI4i4BtTaEHVRcwM2YJHfIQMr2GDqNMS2jxMMzxFaln98Yy3ZBUNOcuyZEtsMOqd1Sghahrf4uSY5jEkZli+zaiVxyDetmb49qTMQO9Ton+bfVOwMCPZvDjgdGxrF2JtSCGKhIHe0HNZemDe2UCKgoPnUBMhXWhco9LdEPu7B76HYqtNZfmwkfyW7LrgdYKD0DhHAyT+UsGD2hGa2Ld/+HMIfQ/B4R5zCmmoYBAyLnzz3OrZaPniTCU/P8e7ovGytiEkS/7yf7CjdoZThtEzGbINlC5m/8wlAKiC1NXTY3m1sHR1i/mPugpfsy+nkhfWO6VmdYtn6VsdtrS8nKfDCPiY2A6RCUgsU80gYxIfnQJ92VwIQjIXAai44udr9CRNi95495IyDWENOBg1M/TeAMHjYMAur2gdafkcdGZf9KZfFXwuG6Z4dccmcvCn7D1lL0aQDqNdr6Ihjs9FSEcfLqWOzmANHZMBUVaPD+WG5zdBMqrSqP42NDT2eHZ8B0uBhzkhT/UTHO85VA0XgT9qQwjiUrJZ3ywZ2dZICyPjymrOvuHn867kSz2Qcy8mHPx8wdUTizvai/m1HMwa/Jr++q4edHkluX9LtTuxOcVkjUS6n053B1ZqoVchB6Mzyu
 nsbUZJR0
 B07cnPe3QDkcYvpoCA36pjSFxqXrfLSy8mJo5xjy1Pq9MYSpo4ht9VZQlclTQlpHYJMCkV4uX8iIFzKnvBYq6DDOKz/08509U0mAG18PzypDbfsJTwGbNY6k9nPwPCXjZxW+nk+tPqWXWHo50g+iSFDHd8zZUivxF5dNw2THKU0on3CBGqDEknkdmsQ2NUO2RPV5zuXucs2XQQTipRWkfRywLnrVQn1DgjpM07sdVgsllV25Q3MkppShUWu5Nr/h2GzDTJIhPe0LQOuFzF5UIJsR9y/6TmDz1NiFjIOPwrZpgjz+nJLgEn75DhP7DoGoynfi1W+Fh94Nowk7jMxVfUdFf3TlsQ3+myH78cwH6sDhsdcHqnSi1z1qK8XzphTfnzEoFj8XwZRVpeGKNDTF+JSpqOu7RwilNDnM2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:23PM +0100, Lorenzo Stoakes wrote:
> Break up the existing very large conditional, add comments and use
> vma_[start/end]_pgoff() to make clearer what we're doing here.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  mm/vma.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index b60375c6c5c3..6296acecf3b7 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -1967,14 +1967,25 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
>  {
>  	vma_flags_t diff = vma_flags_diff_pair(&a->flags, &b->flags);
>  
> +	/* Ignore flags that mprotect() can change. */
>  	vma_flags_clear_mask(&diff, VMA_ACCESS_FLAGS);
> +	/* Ignore flags that do not impact merging. */
>  	vma_flags_clear_mask(&diff, VMA_IGNORE_MERGE_FLAGS);
>  
> -	return a->vm_end == b->vm_start &&
> -		mpol_equal(vma_policy(a), vma_policy(b)) &&
> -		a->vm_file == b->vm_file &&
> -		vma_flags_empty(&diff) &&
> -		b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
> +	/* Must be adjacent. */
> +	if (a->vm_end != b->vm_start)
> +		return false;
> +	/* Must have matching policy. */
> +	if (!mpol_equal(vma_policy(a), vma_policy(b)))
> +		return false;
> +	/* Must both be anon or map the same file (MAP_PRIVATE case). */
> +	if (a->vm_file != b->vm_file)
> +		return false;
> +	/* Flags must be equivalent modulo mprotect(). */
> +	if (!vma_flags_empty(&diff))
> +		return false;
> +	/* Page offset must align. */
> +	return vma_end_pgoff(a) == vma_start_pgoff(b);

Very nice.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

