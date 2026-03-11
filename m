Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0774A1049524
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 09:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CC516B0089; Wed, 11 Mar 2026 05:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B066B008A; Wed, 11 Mar 2026 05:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9DCB6B008C; Wed, 11 Mar 2026 05:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C82BA6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:54:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C1241B888B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:54:38 +0000 (UTC)
X-FDA: 84533322636.03.73952C1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 24443160003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:54:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pe+yqPrj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xQlVpttI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pe+yqPrj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xQlVpttI;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773222876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxiJpIkDUFuoJGi52S6NRrnTVEEE9NEolRRadyXj58w=;
	b=4Kw7CFOug7rRzXaq5MlErpWigSUP3DXWlsX4sl9O6e/tl6IJEwFIfEDD8XQE1mrOLSnLgB
	qOmQchn7MGgj11Jj5dCkDlsWnMbWNeozyfAy0ubTHri8MZJXWdqvmvo4FuKDAuoY+wmRJ3
	b+gPphrzGK4Jd96peEvelCB1UcnAdto=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773222876; a=rsa-sha256;
	cv=none;
	b=MiI2XWNdE8f6sfYd287SYeyNjazlP3kih8+tK0ThGU0Q2suI1cJBRHeATVbfWMEsC2agiM
	rvfSlckgzjgrpEwv8Z1C7CJmJv/tZ2bnZjUS+VRfqI5cAO+5TIZZ3unOAxtEGRHFXnxJE1
	XiaSek9DLMUYTtWcunTNxF2NznYUEng=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pe+yqPrj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xQlVpttI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pe+yqPrj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xQlVpttI;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 47D044D1F6;
	Wed, 11 Mar 2026 09:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773222874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sxiJpIkDUFuoJGi52S6NRrnTVEEE9NEolRRadyXj58w=;
	b=pe+yqPrjdbl4R+8tIibZZbAP74IXafLXeJDKRBPWq1i0ai9bOcTjcP6y9HIEcNWlXlA0pF
	REuNeMQtPcHya7je1lxfJb59oYn5wI8mKw9XwVGtoKqJKa/Bj2wXYmCE1wjjlzIx4sbkU7
	Pqg6+svi2U2EMvZ7yOhflRGKCHwYgAI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773222874;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sxiJpIkDUFuoJGi52S6NRrnTVEEE9NEolRRadyXj58w=;
	b=xQlVpttIzplcCI5s7qpHiSGShn1Cvtihko//2/njdvXMUXOHue8e9GSG6Mm1Hen6qkrdyS
	/bzU+AnE2RKx+BAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773222874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sxiJpIkDUFuoJGi52S6NRrnTVEEE9NEolRRadyXj58w=;
	b=pe+yqPrjdbl4R+8tIibZZbAP74IXafLXeJDKRBPWq1i0ai9bOcTjcP6y9HIEcNWlXlA0pF
	REuNeMQtPcHya7je1lxfJb59oYn5wI8mKw9XwVGtoKqJKa/Bj2wXYmCE1wjjlzIx4sbkU7
	Pqg6+svi2U2EMvZ7yOhflRGKCHwYgAI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773222874;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sxiJpIkDUFuoJGi52S6NRrnTVEEE9NEolRRadyXj58w=;
	b=xQlVpttIzplcCI5s7qpHiSGShn1Cvtihko//2/njdvXMUXOHue8e9GSG6Mm1Hen6qkrdyS
	/bzU+AnE2RKx+BAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4AF873F961;
	Wed, 11 Mar 2026 09:54:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id V0ANDtk7sWl3cAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 11 Mar 2026 09:54:33 +0000
Date: Wed, 11 Mar 2026 09:54:31 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jannh@google.com, Jason@zx2c4.com, shuah@kernel.org
Subject: Re: [PATCH v2 1/2] mm: prevent droppable mappings from being locked
Message-ID: <s5pp37sswbp4g5lw37eszhsduwcgmxbd2jufigjvlwtjzun357@ztzjh6nhhezx>
References: <20260310155821.17869-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310155821.17869-1-anthony.yznaga@oracle.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 24443160003
X-Stat-Signature: w37wmd7opaskwuqy37pgkhurbum73cyo
X-HE-Tag: 1773222875-566909
X-HE-Meta: U2FsdGVkX1+LFJFNcFH9Xk8ylPC1Mlw8thStoV+AtPbfc60upyvJwrbduid+h6IQfAok1toXacsqL766mFQaY+3N5ThfWnCPU6qh6kC+SjoAGsq8hJ/Gn+x7zJIifyDWssbtU0TIXKclW6pCjwEBexg+q5gED5EZBOZ9Lr+n/Jbx9YumdUlqnjVTZBT/7QX1YXXNeIyfbLbAtJdM6H7+djm/kYA83OoRVl0n3cYuWWWXwensEJl6fj6BUGfp5Puk/VTqAnocMmjeyG2dizXPu0lFiYjvZTVJb766eXxE1ocxQIXCoWU+BGMR+JvWvzUfMyKs1YvT3uT1mXjiV5wkiQ0pRfVjPkPtpqpDAAC1VtXjIakl9xnJRrxr9dNpWKB+MIErXbBHJl28nKMMFFk974ff9oIGOF93RjZiaNwoehX5ydXoLfAaBOWG0oSz1Gu523dilJH2XuUhamRVyuH3/6LRi7/PKh7eoYs/mRmZi7YxVaSMeQzzmkWEE4D6ity1JJJMTLc2ll9B1z0qn+SSY3UxwfOKe4rL2cN+IrPYGG8fKlJ5673r9OAsOkdPntHBtq4Sm/0hMb4uI5ik6CUtYb25uOMebFR4FWXXprXiAuufXiamgtZ3TP4NG4kHKuOa22BOjbaiUno/LG+XzAzEO2JbWyELEKNFwqk4pNul5j8jrgLxVOsqetp08fUNHehQKH9Fl1pIEFmLKt+E25X4YVfXyRaOJ49TPF8KJystJJbmlYPFelF9b3YzaTb7LCH2t6ebTKrHpMEkpVmuGvSrdunbBngBt2DBFSgfS+8Jt8IResP+0kVld96q/30wF6ILhwVQVd8bMOeLgP8aXbBD6lxtRgP7Zzc6w1F37ehAQ5tEwwudrqbQKlvG5gFMJCVDZ0JRtCSKKfsPrcgAMI0D8J92U2KTAaSrLjuGawnAHqI5DFChKOpl2ywXFXTQDcBjIHJt59o1+/j5vgTUrNL
 CANcFBvi
 TP8TTvQyHuwbfuIIHsOhU9azn7kERmJBClcLUlC0dK/mp25OXm7h3DDB/gEU3KeNqyP443I0x9IGVKT9FSQhnYgaMVOcLeWRu+j2CnYIGKLT6fPIfUojM5QceAJtFWAqdVkeEFXwlSiE/ZDx9GUCPgmK3Ewt6BF7xSNo9hTYHrnjMeOS2bAQdJY1f0XXFN+soBHieLjQJ/aKvE9ZiX8Y0HG8zu+J9O88CCnXv+wBlpPCg+Lnm4d5yy2UzRPnmsyNJ6nCQ6pP0H5iN1uOQFu17KUJoBsK9N9aCWbPkn7BLW1Jd3G8VpQtJaLt5mQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 08:58:20AM -0700, Anthony Yznaga wrote:
> Droppable mappings must not be lockable. There is a check for VMAs with
> VM_DROPPABLE set in mlock_fixup() along with checks for other types of
> unlockable VMAs which ensures this when calling mlock()/mlock2().
> 
> For mlockall(MCL_FUTURE), the check for unlockable VMAs is different.
> In apply_mlockall_flags(), if the flags parameter has MCL_FUTURE set, the
> current task's mm's default VMA flag field mm->def_flags has VM_LOCKED
> applied to it. VM_LOCKONFAULT is also applied if MCL_ONFAULT is also set.
> When these flags are set as default in this manner they are cleared in
> __mmap_complete() for new mappings that do not support mlock. A check for
> VM_DROPPABLE in __mmap_complete() is missing resulting in droppable
> mappings created with VM_LOCKED set. To fix this and reduce that chance of
> similar bugs in the future, introduce and use vma_supports_mlock().
> 
> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> ---
> v2:
>  - Implement vma_supports_mlock() instead of vma flags mask (DavidH)
>  - Add selftests (Lorenzo)
> 
>  include/linux/hugetlb_inline.h    |  2 +-
>  mm/internal.h                     | 10 ++++++++++
>  mm/mlock.c                        | 10 ++++++----
>  mm/vma.c                          |  4 +---
>  tools/testing/vma/include/stubs.h |  5 +++++
>  5 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/hugetlb_inline.h b/include/linux/hugetlb_inline.h
> index 593f5d4e108b..755281fab23d 100644
> --- a/include/linux/hugetlb_inline.h
> +++ b/include/linux/hugetlb_inline.h
> @@ -30,7 +30,7 @@ static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
>  
>  #endif
>  
> -static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
> +static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
>  {
>  	return is_vm_hugetlb_flags(vma->vm_flags);
>  }

I don't like this. In case a future backport depends on the constification
of the is_vm_hugetlb_page() argument, they'll be hardpressed to bring the
whole patch in. But it looks like we're going to do it anyway...

-- 
Pedro

