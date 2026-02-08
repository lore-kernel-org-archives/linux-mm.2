Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B038EF06E3
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 09:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7A56B0005; Sun,  8 Feb 2026 04:49:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475596B0088; Sun,  8 Feb 2026 04:49:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357416B0089; Sun,  8 Feb 2026 04:49:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24C306B0005
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 04:49:42 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DC73D5EAB
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 09:49:41 +0000 (UTC)
X-FDA: 84420817362.12.159C265
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id CBA384000E
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 09:49:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hz7CIBWk;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770544179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkEowN9YRRoA0ZAhIH43Slxv2ZdbOspfYfzD592V+mQ=;
	b=D/ACx8rEEqNi88c/S4iRHi3g/uwZm6ZtSxIsPJ/pEZZP7itdSfmr1+WiuWcf3OgfDBOLAp
	0NSM5tG57aHndjoPqx4NbhpqUd8WTiraCe8hIVq5v1wmeSoNmxBJTfxJb8U4eN2D8O3lhp
	Xm5lZC5SPWwA4y3OqwNawtDIUwMFwQc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hz7CIBWk;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770544179; a=rsa-sha256;
	cv=none;
	b=BIoVnHG5xMKt08KeWoK/bJ05kPO37vNmzH8qgYDgHkwoM+jzTgYN+To8IKpG8dSvrqONFw
	HZWAzUMTRjkHNP1kMHqwo+mUvfox3xWdJqM13HSM+rus6+c7tDSH4GUOL9ZrcJQEPxVJEU
	Emd2hppechvlPDqEWZ6+YUnPcHFJmr0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D48AA60054;
	Sun,  8 Feb 2026 09:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649B7C4CEF7;
	Sun,  8 Feb 2026 09:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770544178;
	bh=dad1qQG14Id6LY4XasdkZA/u/K3SW5eX6EZX2zBf4BM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hz7CIBWk+BanWnWsjwmGQuuBnJ6GS1FGyOLDJGQ6voZfjDwkbQPPVzj7mof+SYYku
	 aZJZQWvuySWH9WBmsc5GVAry8qs4nFCtuWtttSVxzxoPDgpwjzYgg+xobfkrpqARR6
	 yhmN2j6+GacCPdoL8CnXX3l/J6OuHmbMtnDHR0LDesuHToOppkkaIoyoTTGoLA6SHw
	 Se/YmgMtvCoJHuiNd3WkaRPy5yyoNdl18MPxXLjXnjaiDLgepDWeYkwJmR5Bf5gNzk
	 6feyIqqMfoHSexciIygXgmQrXIAonUw05Nko9juey1Bh8uOoF6h/C1tlSGlXY+lFpb
	 wevcUFtyXv0Bw==
Date: Sun, 8 Feb 2026 11:49:27 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 01/17] userfaultfd: introduce
 mfill_copy_folio_locked() helper
Message-ID: <aYhcJy86AYesUSEe@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-2-rppt@kernel.org>
 <aYI0HmP-XZNBI-gb@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYI0HmP-XZNBI-gb@x1.local>
X-Stat-Signature: 1q988nfzkgr73gx4ysii4pf16aoxmp6z
X-Rspamd-Queue-Id: CBA384000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770544179-36676
X-HE-Meta: U2FsdGVkX1/Ap1ExgHccDSW7UQ7aiATJAWep3zvcvDLrKZQtOOPucug79aCk7G8LGMyFKK1ymlyvYN9SeRsxyAV+a5aZoo4Q3zKdkBskQKbaBn2WYxOBd42172u+NYXEENEu7oMhnkjdx8dE1Uk8PxiBenO10n0kTP6RPs3KE5480v/HqIu8p7Mr23rt+SYi+T6J3cbUTa36in/kBnQboSw8NIH3d6bZOypr+iptkJGApb++ENV0Q/7sWhvlPulKCOS2MJVtv5RRlhdLGSQ8HksWYQGT4c4RwLz6AqhOGtT4z3i73aFC6f7e/CoNAQA/h9tvGfDkL/8TxYxUkOEjdCKhzs8SctmDthRiVuI89j5cx15ABoWKbfJp2Oo+QYuUAX59qRL5E1ikmhni27mFaeXefN7ITAZmfQVet4+ARqxAmkX1izf98b8izbcTkX36jxCSnvQuXDaS0FHbm3Fj9R5V0utHPdECORFs++zt7C2eGTw9CejQa4YCWAMtan6PKZPZvYQAekn5g5jVmQJilLkrg48c+9eNAvDk8SM3fNH/ZhlTyJJ7kP5yhWti/nC6NQgZ4stOtMz5o7dOCuyt/MysSpoR8OOHWJWC5MfeEuokt+eqOaXY60dYk8HFvwm7io6KCSNHOCC7rDrTpfqrrGlFbhD4W0SQnisD8REKoVADxzpCt9GyoKLwL904csW418bCzwB1PPsZdzNvfOAz8/1WkO6WtLOpHcxlPloTD+gruaRAXgvkHMyaBC5AWuoefXEMGkz5shtqWVFniZpwLI9KAJNX1bdiQMosKkwIWXVYqmwoPKLTYmmShEhf/TM3BHOyoAhBIWz1nJDg5XgpYpyRmrz1MTZl7cXdL9+m1KI5i/qN9pmwEyqwfyEbxLhgywSjGcGzmOphErDLwBP3g/yp774jpkFRfrMw9RLW8CrWv3G5V8YFXGBG5JagNYGhojbLs0a+WXwjEee1xl3
 x4ytyWg3
 18/4IG1DTcDhCsR7HcSJ1ggr8+T/Vn3wz03+5gBOXAdbrjcvVIrW9akehbjFVpRKpECu8/edp/ih2auN1ZDYB1q1sYat4ePJIBa9C14AactVf16LVpgeeS38+JJqNUyCWVyY337SFlwXPJxYeO6klG38enCh4CGgp1ocvDs8G1un8cZQgIkw4DjY0V2jY0s7kTHCzvsDmqMUR8lm/+3Wms+Z4N7dF9jT5nVToYPpP/S3GTtnp0vucVxuh5CZw5Ywxkp/ozvjyd0SxFH8gXaS4CQsXSY4sYsozqKwqM5WJ5kjy+o2xszu3E1HTJsByC1Hq7c6hFrD1WKcv9RVs1DkCDjNRG2Agl4li5NT2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

On Tue, Feb 03, 2026 at 12:45:02PM -0500, Peter Xu wrote:
> On Tue, Jan 27, 2026 at 09:29:20PM +0200, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Split copying of data when locks held from mfill_atomic_pte_copy() into
> > a helper function mfill_copy_folio_locked().
> > 
> > This makes improves code readability and makes complex
> > mfill_atomic_pte_copy() function easier to comprehend.
> > 
> > No functional change.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> The movement looks all fine,
> 
> Acked-by: Peter Xu <peterx@redhat.com>

Thanks!
 
> Just one pure question to ask.
> 
> > ---
> >  mm/userfaultfd.c | 59 ++++++++++++++++++++++++++++--------------------
> >  1 file changed, 35 insertions(+), 24 deletions(-)
> > 
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index e6dfd5f28acd..a0885d543f22 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -238,6 +238,40 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
> >  	return ret;
> >  }
> >  
> > +static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
> > +{
> > +	void *kaddr;
> > +	int ret;
> > +
> > +	kaddr = kmap_local_folio(folio, 0);
> > +	/*
> > +	 * The read mmap_lock is held here.  Despite the
> > +	 * mmap_lock being read recursive a deadlock is still
> > +	 * possible if a writer has taken a lock.  For example:
> > +	 *
> > +	 * process A thread 1 takes read lock on own mmap_lock
> > +	 * process A thread 2 calls mmap, blocks taking write lock
> > +	 * process B thread 1 takes page fault, read lock on own mmap lock
> > +	 * process B thread 2 calls mmap, blocks taking write lock
> > +	 * process A thread 1 blocks taking read lock on process B
> > +	 * process B thread 1 blocks taking read lock on process A
> 
> While moving, I wonder if we need this complex use case to describe the
> deadlock.  Shouldn't this already happen with 1 process only?
> 
>   process A thread 1 takes read lock (e.g. reaching here but
>                      before copy_from_user)
>   process A thread 2 calls mmap, blocks taking write lock
>   process A thread 1 goes on copy_from_user(), trigger page fault,
>                      then tries to re-take the read lock
> 
> IIUC above should already cause deadlock when rwsem prioritize the write
> lock here.

We surely can improve the description here, but it should be a separate
patch with its own changelog and it's out of scope of this series.
 
> > +	 *
> > +	 * Disable page faults to prevent potential deadlock
> > +	 * and retry the copy outside the mmap_lock.
> > +	 */
> > +	pagefault_disable();
> > +	ret = copy_from_user(kaddr, (const void __user *) src_addr,
> > +			     PAGE_SIZE);
> > +	pagefault_enable();
> > +	kunmap_local(kaddr);

-- 
Sincerely yours,
Mike.

