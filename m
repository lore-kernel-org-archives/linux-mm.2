Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29487CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 23:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AAF08E00CD; Mon,  3 Nov 2025 18:15:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783298E0058; Mon,  3 Nov 2025 18:15:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BEAE8E00CD; Mon,  3 Nov 2025 18:15:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 598058E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:15:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EEE2D140344
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 23:15:06 +0000 (UTC)
X-FDA: 84070853412.17.AE0ACDF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7AE141C000A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 23:15:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jmi9OqAc;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762211705; a=rsa-sha256;
	cv=none;
	b=Ob2HU5FMmL5vSzVxiLuA7KhDhxSDGEbQHG+pkmIR/vFI8ncR2TcY/awtqZdXYW08jf/Ctl
	lVTz+UNAJcNa9gC2qTIT0vx9uG64wRmkvxgr6NfD7vSNIJ7O8hHsjKQQgIxVrwg+DKKPUL
	bKXuVl9XuisxT5oI4ltRg5c/XvxImFQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jmi9OqAc;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762211705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7JQoCcMmbgwr2pvxCFTGk+XIJ4h4+rFfLxirIJ3DSs=;
	b=zLSkP2ijKr6RRr/jsz+TbPQLxq5LddtKe0OOKhRmoGSl3YxZGovcfZ9O6wm8OQ5WLJBzpW
	uz6txseBM39hLjpkIAavZmXk9Ap36xvE9aCfFq9fsWL5Dyl8hHODFvVRUsasCUl/Sl8dZk
	FsiyJM6riZEX6WW0iHEYv5P0CQbt+hY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=K7JQoCcMmbgwr2pvxCFTGk+XIJ4h4+rFfLxirIJ3DSs=; b=jmi9OqAcLty5zGAs9Gmy1H6Kqw
	MbCZsf79T9ebEb0TNu8jzTBoZg7g8FNrJNt49fglohj0eGi7YQQLQhAKYQQoKAe2QNttu4xhgMGnz
	/3Ev/9Z2OLTjz2tEwchOA3O+Mpv67S//pg0TzV6u16wbrYJ4Z4hCULQvZUqp849H5e9DHWSw+GDso
	nRq/SkpdYES1/qi5oogdgxC4OnaMiv49HvK86iFbvTQWWqz8F5K+VFjTmgzTrnUI6J1fzT3cKbHci
	dOigqBeNWQ3dlhIqETMPXGk5P06r/F9a3b7W+Sp+SVZOIoRrFmw26YEOe9gWQa8YJ0snXbtUtlJzd
	FUXTm3+A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vG3lL-000000044bd-3k58;
	Mon, 03 Nov 2025 23:14:59 +0000
Date: Mon, 3 Nov 2025 23:14:59 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>
Subject: Re: [PATCH 1/2] mm: Add vma_start_write_killable()
Message-ID: <aQk3c0vzEeC8lotz@casper.infradead.org>
References: <20251103180348.3368668-1-willy@infradead.org>
 <20251103180348.3368668-2-willy@infradead.org>
 <CAJuCfpEGdMLxKqPZND32BZeYcpmRb7WQqBc2Qq_Z2Dk1LZEVhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpEGdMLxKqPZND32BZeYcpmRb7WQqBc2Qq_Z2Dk1LZEVhA@mail.gmail.com>
X-Rspamd-Queue-Id: 7AE141C000A
X-Rspamd-Server: rspam07
X-Stat-Signature: 6796c599zf16461ujmq5wjogjj9qj1f4
X-Rspam-User: 
X-HE-Tag: 1762211704-16369
X-HE-Meta: U2FsdGVkX19OXjqmiwoudhZ42wbPU9+l2Nqq1zOxW8gapTij/cPR50s4T30eMvQhmweO+H9iwbHeoaTgdA1HHZww0cLKyHMDBvI//CWqmz2N+aQJhIcURlI7v+unFlmYagRJjZ1hHZTmNyfNuPC1KMXrSIkRgJtdKYnMrekA+yg+iDBOM4nWKQk5ij3VmnxokHVdjDbmmG4EXQ+GE6xHSEI+HC+uYoJcKFyt6NMhbKm/JqNCGMQX6Znwa0+pyx+6ShYiHTjtNaLlxkXC+cIm5rbrdPeQvGklBCRk3CTjULcR9XI9o5VLFgc+S9l6KHvgIH69G6FwiS382FMlLPtqSSzrwwMe3+HIvwzk8PHTzMJ3F7curQdjfRhJXzYqNTpdIaRZp7FKmWyOdGmeUMnxW0iY/tKrOpbZhTdPShzVMtH3f+6lTBbyMB731i9Z+oEjM7EnADn85Lq32O5uy6JHUKXcotZ0axtmvpVwdV0EDv/FBXuoVz8DoLfbifqpRhz573xkIRv4TSo3Cdz9iSGCLVgnPNrpwRZ7XAktZqK1QYATSxQwUWA3cYe2EyNAuLr03wfMfbfyfHFbtQI8DPStvXry5iztWajeg51ORk6BnK75/snhMc0MyWSJZiAdN8N7UmIXy4X72bYGPwZ/vX8aiHzyH8E6ucL/XTLwwVIwWHps5Go5KgftUg0Yia5T/RjfTwHTl1WyD/dR1ykPlD/p+UZYOWVOx1TesCvoWVe3ysFS4JJS9p9ixiDojgP3hSEHk1lZhkmOOAfXiYz8eShy+vJmEspdPetK3bh3kUr4KCk+GNAaVqS6fCVAMC5NWX89ga6Wk9YTHjTlYirVGLDn8iavTZBONoYArJgcXkT+crnLMDx+VpWZBgKm7YkteuqjXaycpKCJW21KVYo9iFVLqgBhKRvZJc80k01DrhdaUBDDZKssTBxPm2XFRCjhg1CQHdewGdz7LkPhk4BkMT2
 S8QLJR7T
 5vLm9Wmh6WKfKsqtR+jYDL2yQLdD4eWVzHT5JwQBxxiRiSEoUrSbREkt2brKhPpGQ5uEASH/jmBYlBio825An0peDbuCNgXi2qoDkEQpd00Ah2SGsBjAepIRwlKOPV+UML1SlBuzS/QSdAV+EHI3/hTApeg2HGyfZvNTETzpVolJ44E1VaWatKX7ucwYjqhCrfSeJak/J2XJn85J4Bo7Zpc8zBs2yF20BmZkLO5T8AhKI0x6982ZS2eraf1Es0atfviaLDNSWO7AhHVEsKcpn8ve7sBRIJM4pWRGF1NBBM5ZQPrI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 01:53:44PM -0800, Suren Baghdasaryan wrote:
> > @@ -286,6 +310,9 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
> >                 { return NULL; }
> >  static inline void vma_end_read(struct vm_area_struct *vma) {}
> >  static inline void vma_start_write(struct vm_area_struct *vma) {}
> > +static inline
> > +int __must_check vma_start_write_killable(struct vm_area_struct *vma)
> > +{ return 0; }
> 
> nit: a tab for consistency with other stubs please.

No.  This is a stupid indentation style that's not in use anywhere else.
There is not one inline function in linux/mm.h that uses this formatting.
If anything, I'd correct the other stubs to match the rest of the kernel.

> Let's add a comment to list possible return values:
> 0 - the vma is not attached;
> 1 - the vma is attached with no readers;
> negative - an error code;

I considered doing that, but decided it wasn't worth doing since there
are only two callers and it's a static function.  If you feel strongly
I'll add it though.


