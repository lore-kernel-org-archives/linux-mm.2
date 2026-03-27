Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A7A210BA431
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BCA36B00CA; Fri, 27 Mar 2026 03:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7945F6B00CB; Fri, 27 Mar 2026 03:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D0C86B00CC; Fri, 27 Mar 2026 03:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5FB9C6B00CA
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:17:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08047C4DBB
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:17:17 +0000 (UTC)
X-FDA: 84590986914.16.094F5A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 431CC1C000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:17:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BrApkn7g;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774595835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lZ73fpSYKpOcirQ+yph9ZJjmEIybj5myG7WrnuVKOBk=;
	b=LTZ2HopjWm7LfhCLcsoXfe50An37svScBwCC6D7ynsLCdVRd9mEdQlXSqga62S6Bl3nJle
	a/eNBZiMXkgG7Mr0aet0hn0436aqp+/XupW8UHW/qgZglnhvtGJzMNcu+Ql/dZ0gUB0129
	q2pMnDIGfCXV9V69RlJ4k5T4yM3mwvE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BrApkn7g;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774595835; a=rsa-sha256;
	cv=none;
	b=OHiBtHfa/4PYJbx7bFR76LxdY0DGaokfPtl7i7efiXq1T/xRnpTnRbdA/2PzntG99wTbZm
	NuXrJ1WSJxCFO4i7i4uC0/+07OWaFzLub6RLDoExv1amIa8p1p7zdhOM3FZXVhFA8zbjMT
	Tg7mXX14lVVYwCm6RwDcWtilkAM9DE8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C27543FBC;
	Fri, 27 Mar 2026 07:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AE0C19423;
	Fri, 27 Mar 2026 07:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774595834;
	bh=IUYSIF0KW3Qy7E/Goib0L6h6MkvUQflSfro+xi0ix5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BrApkn7gG8vBjF+SCfFHdfy/8oIgFR+Akh5d7BCU1Hohx54Is9QxXoNfoa9uGQ4xo
	 eflLiTJzu+tR8+wLJNWrOtLgcHXWatjoA5kp3SnT35BEGfuDE7YgLi90cne6xcF67U
	 2h6tesGWXERiMxErSowF0IgsS+5sAD+EmQRXp24N+AFOSgHCAv6Mw2EHM274kKi7Hb
	 qTEAVBhSF8GjVmtd1bfwyrtH+sRaAWotyofj4MN8LIlyhA+3yvRsT/SlQzEJT5PiSZ
	 EXe0zx0WhTbGdPXf/iCs4Pbju/YkGV9cunDQD4qzBUts4ESi1PJ6H2eHxZs+uZOUAi
	 xeuaWZkdh54lQ==
Date: Fri, 27 Mar 2026 10:17:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 09/15] userfaultfd: introduce
 vm_uffd_ops->alloc_folio()
Message-ID: <acYu77eY_brO1blK@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
 <20260306171815.3160826-10-rppt@kernel.org>
 <CADrL8HUE1iBSPPDQZ3e-1gxN0Ts9kHAzb4o5X_XqSmQy2y9dRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADrL8HUE1iBSPPDQZ3e-1gxN0Ts9kHAzb4o5X_XqSmQy2y9dRA@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 431CC1C000A
X-Stat-Signature: orxdcmr66z597kbtxyz3kac3aqyrwyod
X-Rspam-User: 
X-HE-Tag: 1774595835-278891
X-HE-Meta: U2FsdGVkX18QbIr6+9yXBBBq6YlBOQk7blXfN9UCJy9xskeqmazLWFtiXYgXoU5Hokd80lIddAZpcSFCvsVuhCYr+CueEt3sPU3O2HXlcImjUCk00Dexer3iHP5WW5xXZFE0x9XCIItNyb4GrhPzkmGaOQdnl0VUQM5gwfOmIWflEEjtE/qg2x+imhhjojm0zZgdJxo9nfeZ8dyoiUUhnJlP5ck+2eWPUft3L1XDTmbZXFfMe98rhvjSiOhVrwKasSC880kE5F6j+BnhYs4VVUO87wQnc/EQnP8PgIRbKrWFg+6v0frbtK9zMvXN/PWVx50jqV2J142hbgjvEV44+vd2CuYucqPdp0Xs/gbOI30U7Gc/hWCkDjQAEZHsYmOcIxQk760DVZMLLjcbrzICg6KyQeXoNRZrNskxcoTF7l4hnfXi2qaQstlVdQ3CjH+obWD6P3kmEj2Z/JmnxaGys5NHjgE4y+se47US8jS+lNdanA6aeuOj4Vy5FrCCxOErwwSvnIEOQX0W5gAyHwGlQVegpvpxxWgnFAOH69uH+tr7Gwkq7sWG0QT0KC7hMtHc072hQyBJ3/MmkolzOqRkVz15hxPpORAaBJ3jz7rVgvaKVTBXbO1S0OPh3YqaE3SvdgzZ1NlUc5qbqHH2qUAznCs3PuHjJTP0pb2YZGYxFZlhMpLwFG1UAWUcEjWAndAqLWSLbnkrodssbIfOkMlscyulRZP9lU1IUljfLJ/HTNOoeoi19qKN3qZiBClpOKMf51eMheSyw+Lpho/udTf8YRy7AIb9yyJgQ7T10bJfuvzVyJMkoysrHIMhR3QdRrX/bcgb71YZYRUWcm/VvCj6KScKiE8yw2w/ifg2IvePMTco5tR4xHjbqAyuO2hqEfHVs8VP0yiRcOxR3B2/+qOzaITJUB7YOyjmCyw6XjHd3qo+Dw+RP85Mm0FCs+cHhAN1vsGlT7PqMEKNSA0aJrP
 hiX+wO9a
 FbRnkhk5NZ3L4O0XTWmUTZ0quyJt/BiaHgImfSYde0aw8R7KFj/UDRbuWfxpv7hoIL3tmMq6j+Kg1Kq4NMtvlQ+cEjifGznnSJaKPeV1/1sOy0bglCzP8REbKq8Y+AKaXGe4MKBJqBZVUG+yD4KcG7m6z5Jx09+3+yfJzfxgMLJky+57YItNtkErQgBK4f/GpfR1U5hY6Uz6TL7l/uelmD7cfCx06YK9g0g0Qbz4bqXu5BV7Pce0HfySlu2qPrMixZAci3vPMIf0h6AOua80QfWJBLriDYT7bhWP7f4HLOQw2oWE3zUjp1KZIztOsAuH0psHVE1A/12WJ++C0CyMKl52wukicV2qyVQVPk4jkVMLm7odv9KZpsdiiLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 05:07:08PM -0700, James Houghton wrote:
> On Fri, Mar 6, 2026 at 9:19 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > and use it to refactor mfill_atomic_pte_zeroed_folio() and
> > mfill_atomic_pte_copy().
> >
> > mfill_atomic_pte_zeroed_folio() and mfill_atomic_pte_copy() perform
> > almost identical actions:
> > * allocate a folio
> > * update folio contents (either copy from userspace of fill with zeros)
> > * update page tables with the new folio
> >
> > Split a __mfill_atomic_pte() helper that handles both cases and uses
> > newly introduced vm_uffd_ops->alloc_folio() to allocate the folio.
> >
> > Pass the ops structure from the callers to __mfill_atomic_pte() to later
> > allow using anon_uffd_ops for MAP_PRIVATE mappings of file-backed VMAs.
> >
> > Note, that the new ops method is called alloc_folio() rather than
> > folio_alloc() to avoid clash with alloc_tag macro folio_alloc().
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Feel free to add:
> 
> Reviewed-by: James Houghton <jthoughton@google.com>

Thanks!
 
> > ---
> >  include/linux/userfaultfd_k.h |  6 +++
> >  mm/userfaultfd.c              | 92 ++++++++++++++++++-----------------
> >  2 files changed, 54 insertions(+), 44 deletions(-)
> >
> > diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> > index 66dfc3c164e6..4d8b879eed91 100644
> > --- a/include/linux/userfaultfd_k.h
> > +++ b/include/linux/userfaultfd_k.h
> > @@ -91,6 +91,12 @@ struct vm_uffd_ops {
> >          * The returned folio is locked and with reference held.
> >          */
> >         struct folio *(*get_folio_noalloc)(struct inode *inode, pgoff_t pgoff);
> > +       /*
> > +        * Called during resolution of UFFDIO_COPY request.
> > +        * Should return allocate a and return folio or NULL if allocation fails.
> 
> "Should allocate and return a folio or NULL if allocation fails."
> 
> I see this mistake is fixed in the next patch. :)

Endless rebases :)
Will try to sort it out this time :)
 
> > @@ -483,9 +498,15 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
> >                  * If there was an error, we must mfill_put_vma() anyway and it
> >                  * will take care of unlocking if needed.
> >                  */
> > -               ret = mfill_copy_folio_retry(state, folio);
> > -               if (ret)
> > -                       goto out_release;
> > +               if (unlikely(ret)) {
> > +                       ret = mfill_copy_folio_retry(state, folio);
> > +                       if (ret)
> > +                               goto err_folio_put;
> > +               }
> > +       } else if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE)) {
> > +               clear_user_highpage(&folio->page, state->dst_addr);
> > +       } else {
> > +               VM_WARN_ONCE(1, "unknown UFFDIO operation");
> 
> "Unknown UFFDIO operation. flags=%x", flags
> 
> seems a little better to me.

Yeah, why not.
 

-- 
Sincerely yours,
Mike.

