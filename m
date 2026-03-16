Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68ABDF506E1
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF7DC6B02C3; Mon, 16 Mar 2026 10:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCF886B02C4; Mon, 16 Mar 2026 10:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDBE66B02C5; Mon, 16 Mar 2026 10:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF8E66B02C3
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:47:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F26DAC16EA
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:47:37 +0000 (UTC)
X-FDA: 84552204954.18.9DC8163
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 031144000F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:47:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fBoPKg5a;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773672456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HksiW8mwUIUUZeVN3IsR12TYHuTJXhGFLqIwf5UAG7k=;
	b=KZjkfTVVmS3NDedqqFKpxsQKl8R7GwHTkatdgC3fNrR+sLgrh+eGH8SYl1byZbq/KIPgGQ
	0qY4breZEUfpeA7Tg0k85hYN/hDl5Do1GlfeLyqjhuh5gn6i07qGmHXLfoLLkKWt6PeRll
	k+Oiyv7UxhaXdMBIdwDdIZsJoGsouZY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773672456; a=rsa-sha256;
	cv=none;
	b=jxsnvz7rHZGhpMvbPAJzFHaFbo4cmbOxg65ZSBjuX5iSBSOGY5HjOwEC9JoPyoN8INs/Ly
	oHh3BVdRc/ZazahEvoJasytU0vwuEs2F5ch1XOl2vPxuEXVxQWy6utG5ZiKx9mQPXBqoqT
	NkxvvruDwUMsWbECksGOqLnTL7BBhPM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fBoPKg5a;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 680A56012B;
	Mon, 16 Mar 2026 14:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73DEC2BC87;
	Mon, 16 Mar 2026 14:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773672455;
	bh=SWyWovQpZcRYDA2RTZfFVXcBgJf/dKBAYGsO0cjwpR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fBoPKg5akPio74rsRGXjA5HYsmf0U0scEYxrF9JlUrnKHGrjoBxvJmuqAcLCHgUoS
	 IFCj8Q6ofjLHnZu+caNKOvyGbzv4zt5yp93PoYG0JqtHPeAHRWXKG7bs4UrW91MZHc
	 AOTUOG75P0LPx53kTgiD9zdeSjGIjxfzeut773v0jtaoImyzhRkvHh9a/Uzr51SXfi
	 gokr/3PW4cHZn0v/iCNUutyK7CIsTQk80ZURS3qpuz7koF3Fd9qNvUkuVpQG0yN/9k
	 uONkj8w6MwBSTEMqIXQ4bc8ZhtmCxRAk5iXQW6PEviYet3WsvklRl6FBuzmcJmE6t0
	 4z2vm0eSfUFwA==
Date: Mon, 16 Mar 2026 14:47:24 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>, 
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, 
	linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 01/15] mm: various small mmap_prepare cleanups
Message-ID: <c7e16d31-ce30-456c-aba7-aaa6dd781b19@lucifer.local>
References: <cover.1773346620.git.ljs@kernel.org>
 <56372fe273f775b26675a04652c1229e14680741.1773346620.git.ljs@kernel.org>
 <CAJuCfpEsCrFEYNkkTfRLGojGOYAAx1=WOojOhpBb_=WZBr6bnQ@mail.gmail.com>
 <CAJuCfpHcjFU1r7ixiJM4b_a5HTesxBmW6DiCreaWpJ8DLM5haQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpHcjFU1r7ixiJM4b_a5HTesxBmW6DiCreaWpJ8DLM5haQ@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: cj3997k8oirffyeybz6yj5gtmusgynzk
X-Rspamd-Queue-Id: 031144000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1773672455-198136
X-HE-Meta: U2FsdGVkX19rSAyqeKnefwwFFsx0MMWyrOtZhDJkmm/FnKGTk4LC8TtmkBpevXZRZJs3BlXoI3fJPXmVmUP+DxHqXm1uvBNEnqBnfO39AB2WaCqLnOdPPC7XrKXRFYMrjzj2PLNFvLrnuPG+RxEWB88+ATUp1gw4b/gbS8lBhvfYB8WP0XDUk3j+xNW2VuLWl18N0wzDXGLYOM1grGUdaHdHgadxwEyEgGS5hIpCObR1EZM2vbJOvsLVf//ctYCj0NIAUrtQE4A06PL3lgaHeXOA8WEoNy3V/yZs5HeiQqb7+W3gZw0rwWxtWgsjYU/dp85e2SFupY0SGVrD4yg+dpHTFEfn1bMNAPbhOrd8rBCjThj2cv6P4GYPfCn/K35JSilJ/nw284Uvgf05O62sIFDekVuoK9eRTyoYdeiFt1tA52eG/ZOSedxXmZKDwfYUl/a7XNoD+C6nO8pYcrffgHWutEpcGvPwv7QEdQdVtlzAQC33eDzE1q2A+m6uGrz0eYThwfHL5D3ZSL7WbbbQr6DS6xI7bl8TQdtonOy34qhmgTnJ/KS3vjSfCHqF/rAQ4yEOsFnGoYzSDgJJRlMkrFqQtIecNy96ikCc+skA67OwLWZldUpka+x6crI/P2AH5dixwnOfDbMT8kZKgYZI04mCTWn7vwKool8AuSLqDToocE/hfZuEuva0cC4UqWplubmjAk6jjF0FJiuMXtOkFFB1nhETFJgjUuzi6HbM+j+1KA7GdS3LpqsxU/5rvX4+QPQtkXG7za/+fgYKHpK3+hKMx02qOyjL8OuE/GVAVRYb/fUyaMqoR5z2/nNG534PSJuq0z2JnuR9OTRfEyJMBVtTkwOM3zlFcOn76sv3HPHIBH0X3fydEnj28vk+08w86khpVZirWBOQ/1k8VGonPu6fd+WwE1itYvGzbjprg3DjOixZrriRAfUDC8LmnIA7XwCRorO2hfzQF6YpWqS
 Jgj4UOOo
 U8QWG/eM/npUkZlgouanDFVJB/B1UwIWXS6sOQ6zt47vIWwbUnp2VKbEd5gA/ofCFW0rPMjIoORCB605jgT9Qz1RYdE38vyCOJ53hr6TWw+ADcB5RUWPPFtDyByDhTjk/nxJbLvXv7GWuHLcUcK0s6ob3tMziP5FGi7ki3JHNpFV3Yw3S6qz6K4R7jmkttQpsWXtzH7UunEZypLpPrNI+LRU/KJ3PScuB+Ra07MfmvDNXGktz21yvPJdmaSm0CRJ5giPon1Z31ObW83s+GrE2OtUJMfcJNoLFKcnVgRTwT6W8iIvASlaePj5Hc7g1AsB27kjxGBpNjhq3Jusr5QUsj+Qc8n36dYqOYscB9Kp4bgebgOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 15, 2026 at 04:06:48PM -0700, Suren Baghdasaryan wrote:
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -4116,10 +4116,10 @@ static inline void mmap_action_ioremap_full(struct vm_area_desc *desc,
> > >         mmap_action_ioremap(desc, desc->start, start_pfn, vma_desc_size(desc));
> > >  }
> > >
> > > -void mmap_action_prepare(struct mmap_action *action,
> > > -                        struct vm_area_desc *desc);
> > > -int mmap_action_complete(struct mmap_action *action,
> > > -                        struct vm_area_struct *vma);
> > > +int mmap_action_prepare(struct vm_area_desc *desc,
> > > +                       struct mmap_action *action);
> > > +int mmap_action_complete(struct vm_area_struct *vma,
> > > +                        struct mmap_action *action);
> > >
> > >  /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
> > >  static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
> > > diff --git a/mm/internal.h b/mm/internal.h
> > > index 95b583e7e4f7..7bfa85b5e78b 100644
> > > --- a/mm/internal.h
> > > +++ b/mm/internal.h
> > > @@ -1775,26 +1775,32 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
> > >  void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
> > >  int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
> > >
> > > -void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn);
> > > -int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned long addr,
> > > -               unsigned long pfn, unsigned long size, pgprot_t pgprot);
> > > +int remap_pfn_range_prepare(struct vm_area_desc *desc,
> > > +                           struct mmap_action *action);
> > > +int remap_pfn_range_complete(struct vm_area_struct *vma,
> > > +                            struct mmap_action *action);
> > >
> > > -static inline void io_remap_pfn_range_prepare(struct vm_area_desc *desc,
> > > -               unsigned long orig_pfn, unsigned long size)
> > > +static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc,
> > > +                                            struct mmap_action *action)
> > >  {
> > > +       const unsigned long orig_pfn = action->remap.start_pfn;
> > > +       const unsigned long size = action->remap.size;
> > >         const unsigned long pfn = io_remap_pfn_range_pfn(orig_pfn, size);
> > >
> > > -       return remap_pfn_range_prepare(desc, pfn);
> > > +       action->remap.start_pfn = pfn;
> > > +       return remap_pfn_range_prepare(desc, action);
> > >  }
> > >
> > >  static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
> > > -               unsigned long addr, unsigned long orig_pfn, unsigned long size,
> > > -               pgprot_t orig_prot)
> > > +                                             struct mmap_action *action)
> > >  {
> > > -       const unsigned long pfn = io_remap_pfn_range_pfn(orig_pfn, size);
> > > -       const pgprot_t prot = pgprot_decrypted(orig_prot);
> > > +       const unsigned long size = action->remap.size;
> > > +       const unsigned long orig_pfn = action->remap.start_pfn;
> > > +       const pgprot_t orig_prot = vma->vm_page_prot;
> > >
> > > -       return remap_pfn_range_complete(vma, addr, pfn, size, prot);
> > > +       action->remap.pgprot = pgprot_decrypted(orig_prot);
>
> I'm guessing it doesn't really matter but after this change
> action->remap.pgprot will store the decrypted value while before this
> change it was kept the way mmap_prepare() originally set it. We pass
> the action structure later to mmap_actpion_finish() but it does not use
> action->remap.pgprot, so this probably doesn't matter.

Yeah it doesn't really matter either way.

Cheers, Lorenzo

