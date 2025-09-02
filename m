Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8178FCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45708E000F; Tue,  2 Sep 2025 09:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF5D48E0002; Tue,  2 Sep 2025 09:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD6A8E000F; Tue,  2 Sep 2025 09:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B74338E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:41:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D23283F62
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:41:19 +0000 (UTC)
X-FDA: 83844421878.10.5E261A1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 66B5E8000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:41:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C366B2kF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=c8YOn2Wt;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C366B2kF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=c8YOn2Wt;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756820477; a=rsa-sha256;
	cv=none;
	b=Q6wA84NKP2OkaN+DG9dQOgcLGJTz9lPHiilh0fm6221kwnePjihhmecew/DipIARDFXeg1
	99htbuZXDqZLUnk6TkcdMW7CnhmAD1fMjppxEUaur3c3an4O4TOvf6d1G+yTV1k7PH2v39
	dkamyTZ8fLi79OxoYWqhIkk3cHp85wM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C366B2kF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=c8YOn2Wt;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C366B2kF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=c8YOn2Wt;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756820477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AhOTfgygnk23brwzYKfsgKlsXFSLIcGbgvQqte8GedY=;
	b=INAOu0eN1Ql5R+e3iFQSd/A67koBnBQ1Wy3weGGUwInrYUFjQCl81fdyn6Brh5p1Mmg7Da
	cjgtk3cbUrv6iikKpP9bLFypHA6BweLs61dGEr+3UKZph03QEnXBsSYBunFHiGpT6tNVpE
	QUsrlFqasw6a9qAgsj/uSe9Ap1/+Sl8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C1A731F38E;
	Tue,  2 Sep 2025 13:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756820475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AhOTfgygnk23brwzYKfsgKlsXFSLIcGbgvQqte8GedY=;
	b=C366B2kFcPZ+d4ABXG9d7/JZfdkttWp3hQADsbYoVlwRsy5OhaB4SRfW3XPprc/AdqnkhR
	sX/jtmLiP/tba/OOcMja3xuRKYBL265ho6XHzTVl03NyvFMMvRdjp6UutU5m9pLVNItrH1
	F5eUBx/zaNKSkEG3pPbQFXDfZDP5WSk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756820475;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AhOTfgygnk23brwzYKfsgKlsXFSLIcGbgvQqte8GedY=;
	b=c8YOn2WtFkxrYyvtLWKR91DZtpdVFvqyiVu0FoeIz83yqeYbRidpJLNnXqmb8DgyEfPYnB
	0HBC2Fqj0j5oYYCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756820475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AhOTfgygnk23brwzYKfsgKlsXFSLIcGbgvQqte8GedY=;
	b=C366B2kFcPZ+d4ABXG9d7/JZfdkttWp3hQADsbYoVlwRsy5OhaB4SRfW3XPprc/AdqnkhR
	sX/jtmLiP/tba/OOcMja3xuRKYBL265ho6XHzTVl03NyvFMMvRdjp6UutU5m9pLVNItrH1
	F5eUBx/zaNKSkEG3pPbQFXDfZDP5WSk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756820475;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AhOTfgygnk23brwzYKfsgKlsXFSLIcGbgvQqte8GedY=;
	b=c8YOn2WtFkxrYyvtLWKR91DZtpdVFvqyiVu0FoeIz83yqeYbRidpJLNnXqmb8DgyEfPYnB
	0HBC2Fqj0j5oYYCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D06F113882;
	Tue,  2 Sep 2025 13:41:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rT11L/rztmifYAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 02 Sep 2025 13:41:14 +0000
Date: Tue, 2 Sep 2025 14:41:08 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: do not assume file == vma->vm_file in
 compat_vma_mmap_prepare()
Message-ID: <ngqpybolf2e2gp266k7vkehzg2xrbng2proq3jv3quurk32wzm@j7d3je7im4fj>
References: <20250902104533.222730-1-lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902104533.222730-1-lorenzo.stoakes@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 66B5E8000D
X-Stat-Signature: d9n71f9omjf3pq48j5mc5bbtpgqk67mb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756820477-756422
X-HE-Meta: U2FsdGVkX18u37++FlmisKzrCC7hTDIgQ1Os7vlDN6d5g0A3H+XckfCaI2pe32laE2vVFnP/C/q5xtJB+zzbSYpAMjF93Fvk8fIh1AYYE1aarlxp3/j6arS035IWQU11kjI1vuOo85WZUbFnp0E1+swJlFwV+wY/dK0xFlnsq41phxBS5qPlSmWaZZYhHm64PKzJfUkknZVjqotfY3IJvxTFWtflvXmNM0lpVYwSn00QoEYXU38cek+6AmT80cCP7law3mgqW8wO0H1qTJ4BRrKLLTc6jWidFxuyog/S88UKILKnAoNnWpveHJeWlIJlFcGglRjWwsXlcAanshOyaSHRLexLgU3t+LnqNYYqC5DXDuDeNd9H9o0kNi0+b3e/ODbNUIdRLuN5b9kZtpPavfPA0gEp0litMlrNEy0gZgQnkb9WaqH+o9n7QXcV3fYt7ppCDvsO7B5Ddg9V6N+1Vfsdr7bItpppBAnRs5scnZ3vBIeuYNLA52J7fUIwsNpazq7M15rr3nyCWzI/UR9NsfB0xVKCq8T08wlzSA35W0uAkVDxi79+RGB1UdCwS8N9eN+kOmw7vJKC4GhCNMNMirzFkfVv8J24TmEcSJf7FhqIE8xFNGNIaVtnU5RY6wZEPtSQc6giUsIkmRYiK/5JD8YOk4NfqzZPPkrJHXyaldFEHOI0rxbLR2Z+ASIb3Vr39MmHqWGY9gQRjsLNDthN02DQdZC1V1hLIJOqGCEL5RxkpHpCm4N1TMse4byLpNrjWALpNvHPQNdKfNIeO5nz4vdgHp+uDMIXYaPF6qog4tBC+h/mBmbL7YF9UlZm6JGstxBWO1Wiqvl1raVA89M8kNGuo5XtCqhphqihma/8upXgI9dj2CKj9S021UMwFSqH81mcpZ3z2uGvDtN+0E86O5N19t8rOgDdgVJl2zvbWF6An6wmlGokmcPGuTRItnmCTRd4vyRIsov40j584Eb
 KbbeCAhH
 Fqs6JgyZ1IWCzG/jD4VaB2j3MHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 11:45:33AM +0100, Lorenzo Stoakes wrote:
> In commit bb666b7c2707 ("mm: add mmap_prepare() compatibility layer for
> nested file systems") we introduced the ability for 'nested' drivers and
> file systems to correctly invoke the f_op->mmap_prepare() handler from an
> f_op->mmap() handler via a compatibility layer implemented in
> compat_vma_mmap_prepare().
> 
> This invokes vma_to_desc() to populate vm_area_desc fields according to
> those found in the (not yet fully initialised) VMA passed to f_op->mmap().
> 
> However this function implicitly assumes that the struct file which we are
> operating upon is equal to vma->vm_file. This is not a safe assumption in
> all cases.
> 
> This is not an issue currently, as so far we have only implemented
> f_op->mmap_prepare() handlers for some file systems and internal mm uses,
> and the only nested f_op->mmap() operations that can be performed upon
> these are those in backing_file_mmap() and coda_file_mmap(), both of which
> use vma->vm_file.
> 
> However, moving forward, as we convert drivers to using
> f_op->mmap_prepare(), this will become a problem.
> 
> Resolve this issue by explicitly setting desc->file to the provided file
> parameter and update callers accordingly.
> 
> We also need to adjust set_vma_from_desc() to account for this fact, and
> only update the vma->vm_file field if the f_op->mmap_prepare() caller
> reassigns it.
> 
> We may in future wish to add a new field to struct vm_area_desc to account
> for this 'nested mmap invocation' case, but for now it seems unnecessary.
> 
> While we are here, also provide a variant of compat_vma_mmap_prepare() that
> operates against a pointer to any file_operations struct and does not
> assume that the file_operations struct we are interested in is file->f_op.
> 
> This function is __compat_vma_mmap_prepare() and we invoke it from
> compat_vma_mmap_prepare() so that we share code between the two functions.
> 
> This is important, because some drivers provide hooks in a separate struct,
> for instance struct drm_device provides an fops field for this purpose.
> 
> Also update the VMA selftests accordingly.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

LGTM, thanks!

-- 
Pedro

