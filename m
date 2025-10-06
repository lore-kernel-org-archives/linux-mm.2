Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C506CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 15:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44D6E8E000C; Mon,  6 Oct 2025 11:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424DA8E0002; Mon,  6 Oct 2025 11:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33A4E8E000C; Mon,  6 Oct 2025 11:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 219458E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 11:16:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D01C7457DF
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 15:16:58 +0000 (UTC)
X-FDA: 83968042116.20.6C98B15
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6D09B4000E
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 15:16:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JfEGVaD3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=28LwVFZv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JfEGVaD3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=28LwVFZv;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759763816; a=rsa-sha256;
	cv=none;
	b=B/ETT/OmQYoj0OWk2+XOp3FU/1Yia6od6AS7R8SV8h2P6zGO/ARGCj53DzT/8ygKimZCAK
	GqCnIcutpGVu+xa4P1u0ECBVoE+fwzigsCCbO5gRFRiQ4CAza8jQvWXr4OaXQNoPnq6n2g
	fV5pLxVq/89KRZyeaf1gkRtnbwPAUJc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JfEGVaD3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=28LwVFZv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JfEGVaD3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=28LwVFZv;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759763816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7iUrqCG2h/I1kRo24kmzmf4tFUsBJ4OjTnSbR2SFuFU=;
	b=O1h9Fnpe6E4lvDAuZOzcg8qULI1Ov0CiU8pQNQmY2JkGyZvkkf/3joKsNPz29qctAgIBtq
	N0RmwXbYT11MDbIQQ78wCLSqlDSwVzrNlQTq4JIwQy5cyX5zXEQ6j4dXuR7DLKP1jHBO7P
	s32xiAAPjx0jOpE+/bdjfWy+85AHVgA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5E5721F451;
	Mon,  6 Oct 2025 15:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759763814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7iUrqCG2h/I1kRo24kmzmf4tFUsBJ4OjTnSbR2SFuFU=;
	b=JfEGVaD3xh5+rmLVKhixC+7z96nZowCL5NScoOMVuVk/bQIwvSbew88VA/YM6Q7niHB+Ag
	Iu4Wzd3N7rR3qQ92Ba5vXEgxrsQ205qSrLwGB93NY38ApH+cRZBmIF1RaNcYvAbPjbAbLv
	ilo09AW3jes1CZK2ISoUb95Ql6t965U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759763814;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7iUrqCG2h/I1kRo24kmzmf4tFUsBJ4OjTnSbR2SFuFU=;
	b=28LwVFZvAKU+Z4+kGtMvQyiy8dMdufZOzfvwRYUH2295mE216DJt13+Aq02HqstGEILoy5
	2YhoQSZ9xhbKJMCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759763814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7iUrqCG2h/I1kRo24kmzmf4tFUsBJ4OjTnSbR2SFuFU=;
	b=JfEGVaD3xh5+rmLVKhixC+7z96nZowCL5NScoOMVuVk/bQIwvSbew88VA/YM6Q7niHB+Ag
	Iu4Wzd3N7rR3qQ92Ba5vXEgxrsQ205qSrLwGB93NY38ApH+cRZBmIF1RaNcYvAbPjbAbLv
	ilo09AW3jes1CZK2ISoUb95Ql6t965U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759763814;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7iUrqCG2h/I1kRo24kmzmf4tFUsBJ4OjTnSbR2SFuFU=;
	b=28LwVFZvAKU+Z4+kGtMvQyiy8dMdufZOzfvwRYUH2295mE216DJt13+Aq02HqstGEILoy5
	2YhoQSZ9xhbKJMCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F1DF13AAD;
	Mon,  6 Oct 2025 15:16:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id D7NJE2bd42gILAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 06 Oct 2025 15:16:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F1784A0ABF; Mon,  6 Oct 2025 17:16:53 +0200 (CEST)
Date: Mon, 6 Oct 2025 17:16:53 +0200
From: Jan Kara <jack@suse.cz>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Amir Goldstein <amir73il@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] fsnotify: Pass correct offset to fsnotify_mmap_perm()
Message-ID: <pg55elgetdhvjhda36xr63esawc3t6y6lbiesyfxhousmzmil3@rwd54tfm2jh5>
References: <20251003155238.2147410-1-ryan.roberts@arm.com>
 <uyh6y4qjuj6vcpsdnexwl2xqf2jnp6ejj7esr3g3hix66ml2zi@pqsbsjtt6apl>
 <ae61f721-3d07-4908-ad31-9c25e8b8119e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae61f721-3d07-4908-ad31-9c25e8b8119e@arm.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6D09B4000E
X-Stat-Signature: d9roosh7xsrnpftcbrgdxjhnwb35cbfb
X-HE-Tag: 1759763816-170600
X-HE-Meta: U2FsdGVkX1/kEB3a+Ej3Szw8tBzJQXeqD/0+70mbrpLKxYf89yNO5dVIx0IE8IxRnP/kuemIuNIXBYIN/+tXdGuunahRoNl0hOGS10psWDqrKiXPEw/fae/1fymvgE+IrQ/O0mw8/d2x/ByIf7MSasmY7L92m8LnmNfDsizRmzPYMO/N+MbGrGF8MkgmKrqcWHZAljbRwgTl3wHktsnLMSY4jTuNPTBLevuDj/ny+9dQyjdGEaxwh96j+g+x8VeCtTOqnA6PrErOregS0gYtQhdfsbevH8I8Ql+oLauUjLGbL8BvXYgZrA03l+KdswZJ4eeahpcbtMhD1PbxX5Wm/IBLBRYWeQY4QOr1hI+qG7yojWGCOMc8JZwY93OAGiWiK6GqGMcselNbh+5VKPouZZQxxokOV1DwyIBgIlhruP5kVtRqUnKUrIE+jjeGGvC3GpXNCS9dOcSVoQq8u9Pn7wMr06DV3Xc+pELV9KFahNGzncVgwgklnGRHFbiBQCx1ITSGQ0/smB72kHQ4TnXX3Z70Uw/5dHjLIJ9zffc4cKAxGZ5q4P3aEiIXaVyZMJHx5mbUBVbIFMvfc69Jh44fCKkR9LKmYp4mfDXPjeREOLTNTv3zLE2tjiBvGVPqb2CpepR9nU8/JIQIs6UAlBnM4soiOfql/lY/ZCu+og8TQuscVVVpPsK3JPxzksjPvuEcK83ZUbC/Mx7U7XltkXu0OHiBdjOG0Ihkw75fNOHFBSk4WjtFd3T4dw34csk5jusJAzRt9acAFuXsliaepqJqJmmyfx232aOObWxeDgZ3WLeKP85i4EEYa8tcEmWAU7u5EhL29eT9buByfwXNAV6YnGcmsz5pNeMOBHRpgICXSgPxfcOypXmLFH7OU6s3PAOvmee3850q/FPLzmhmNY8GnBrkh3jOBuvsQJEs61gG5eMYcVf+c6cmbzrVuNdUVWYt74M3yI90CWp1b3dQ4SW
 lrriw1cH
 Mo48uKuK5BNLyFEsGw8Fhve1QlGisfRDxPXnXmImluVnldAFCNR/mX2s2c7nNqSBqLuvqoNFhYiTk3WpFXratXMxIkVOWmZQO+xzWmIKQHf1QNAfQe19FXDcbtbyoNdlnvnhFuM3ZcFJuC7xG+ymd4KktdTCovZgWg06KouTxpxIXoJHRFAgEwvnv13UnAznNEx81mg3SGdMx2772qlOpTRLyYWsIjJFsZPx+x4eJnEJd0iCMrBSyxpVWR8FX2yu/FZsd4K9ijIJLBsyDbDLs538Qi4bdOYdxPyh8hNtjR9EDEfR9rQNoLcvKCpw45m2ohGpqrCvgPHhjlrLVxYvXbreLdCYqxYTiSooLkAF7kU8KHcbjMWo5pyeK/CYfSum1gk7fuYb+foKEyA0bbi9rJUJvNw3AO69BeFLAC7Xx2qdtNAwKh9fMa7T4OehuI855hPxw4pnAZk7AMbq6p2Fw5Gzw+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 06-10-25 16:04:23, Ryan Roberts wrote:
> On 06/10/2025 15:55, Jan Kara wrote:
> > On Fri 03-10-25 16:52:36, Ryan Roberts wrote:
> >> fsnotify_mmap_perm() requires a byte offset for the file about to be
> >> mmap'ed. But it is called from vm_mmap_pgoff(), which has a page offset.
> >> Previously the conversion was done incorrectly so let's fix it, being
> >> careful not to overflow on 32-bit platforms.
> >>
> >> Discovered during code review.
> >>
> >> Cc: <stable@vger.kernel.org>
> >> Fixes: 066e053fe208 ("fsnotify: add pre-content hooks on mmap()")
> >> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> >> ---
> >> Applies against today's mm-unstable (aa05a436eca8).
> > 
> > Thanks Ryan! I've added the patch to my tree. As a side note, I know the
> > callsite is in mm/ but since this is clearly impacting fsnotify, it would
> > be good to add to CC relevant people (I'm not following linux-mm nor
> > linux-kernel) and discovered this only because of Kiryl's link...
> 
> Ahh good point... Sorry I was sleepwalking through the process on Friday
> afternoon and blindly sent it to the maintainers and reviewers that
> get_maintainer.pl spat out. It didn't even occur to me that this wasn't an mm
> thing. :-|

No harm done really. The change is an obvious fix and it would find its way
to the kernel sooner or later. As I wrote above, this is just a note for
the future to think a bit about patch recipients before hitting send :) It
may help to get the patch merged faster.

								Honza

> >>  mm/util.c | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/mm/util.c b/mm/util.c
> >> index 6c1d64ed0221..8989d5767528 100644
> >> --- a/mm/util.c
> >> +++ b/mm/util.c
> >> @@ -566,6 +566,7 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
> >>  	unsigned long len, unsigned long prot,
> >>  	unsigned long flag, unsigned long pgoff)
> >>  {
> >> +	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
> >>  	unsigned long ret;
> >>  	struct mm_struct *mm = current->mm;
> >>  	unsigned long populate;
> >> @@ -573,7 +574,7 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
> >>
> >>  	ret = security_mmap_file(file, prot, flag);
> >>  	if (!ret)
> >> -		ret = fsnotify_mmap_perm(file, prot, pgoff >> PAGE_SHIFT, len);
> >> +		ret = fsnotify_mmap_perm(file, prot, off, len);
> >>  	if (!ret) {
> >>  		if (mmap_write_lock_killable(mm))
> >>  			return -EINTR;
> >> --
> >> 2.43.0
> >>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

