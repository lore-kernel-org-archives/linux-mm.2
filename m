Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CC10C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 11:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856716B00AE; Tue, 25 Aug 2026 07:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E296B00AF; Tue, 25 Aug 2026 07:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D1D6B00B0; Tue, 25 Aug 2026 07:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7116B00AE
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:20:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D43921603D4
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:20:09 +0000 (UTC)
X-FDA: 85139547738.23.74D0703
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 38944A0008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:20:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H4S9/yoy";
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787656808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FWf3P/SKIaJRRAsSvxTvo5izA5oqfXztVDKK4GY3V7o=;
	b=oJHxzWlfpoKJSLsIblEWdM+3Pm5bbTQWSnRdHTAMLzEe4r2/PAjc8WGXe+4yJUcGrz7Ufd
	AvKO5xbWSTTePuy2Qw9a0f0ZrKQ4NWq0SPjr7kuZStS/zMk1LcfVGXR9ab5nTtiyy+GBfX
	NDAvEm3ynIcUSmgHEWM0IBMkJJ97SD0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H4S9/yoy";
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787656808;
	b=5cMD/5U6YmyWlkdL0BkvPo+mDOzpDi6ox0Q2Tmx52EaqbHAfiDRwtBfWVZn0mfrLh+WVDr
	PMPXqJ8LJSOz0V2x4sPDjYQgHz0ojE/FxxdtV594euus0+Q0FHjmN3IzfcGffOBzRX3sPO
	wVdyB6Ldqe1SlJjnWpWT5oJPsiuWU/8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A4E8C6011F;
	Tue, 25 Aug 2026 11:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBDC1F000E9;
	Tue, 25 Aug 2026 11:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787656807;
	bh=FWf3P/SKIaJRRAsSvxTvo5izA5oqfXztVDKK4GY3V7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H4S9/yoy2Yjopf5gJYiLZlxYDa/LboiBgyS4EuOYw9JqJD7li/qlty74bcEQgzwtH
	 4wTenkCXmKrBVCieVML0QhQRsiBRWfj+Vo5U1ZXbrxiQjg+8+jfypo4OCeSwWIkAMZ
	 tGi4hRTou0eYuIgORrwa23WZJNaOQ2w0LPm0GiNcQKnT6h+UueNqYbGBzx2i4aBbpJ
	 tEvONlrvVtodXsR5TcH2v8srrbxYCaD/HxUG5j3Vgg3FbW++fP2cqi6mlT7pQ23/d7
	 DTlQTkMRWi3hjEddNZo4G30JKiM9m2wQEl0uhtjRtMAiRlPyva24nEyUbl9OCvsV3j
	 TdPxHX9JMazIA==
Date: Tue, 25 Aug 2026 14:19:52 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] userfaultfd: use userfaultfd_*() helpers instead of
 open coded flag tests
Message-ID: <ao16WPoLpdIdU3ID@kernel.org>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-3-3086981b33cf@kernel.org>
 <aoxdWWMEeQbcG5Pq@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoxdWWMEeQbcG5Pq@gremlin>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 38944A0008
X-Stat-Signature: 3i89oss7cro8cbue1gc4k8x963ynbgbd
X-Rspam-User: 
X-HE-Tag: 1787656808-282393
X-HE-Meta: U2FsdGVkX1+N16kw4ESfIRRUYwVh9oXMYCb+K0ZqXuLyb+Z40h289GPM5HPksULj6HvoNIbbtYV6/1+6YcOC5BxlOjRu4An+F0hLHEEaFPIflOBVCAoNfSHHCqhtz3CHK6XhN4kruHFVzQMFxeJSiqtUXieCmFTiDwc+kQRudpR2Zlga6iSdu44TgBpF03CpR6Q28icaZQrO+3fKxKGedVAza+PqzTHfISb+24Eu+4qtJ11auB3sdduWTCdp0P6zlOmvJfrZX4qQ/q2D7UnTU21KrrOV+/QV24ds7Y/0hQLlribc/B3NhD56yHmr7x6XVYT2TwdSghxTmRIVTxlUKtVbPijX0DfOixkz/PWIHs1QdrYJeXEZeXUmK4Po5DabOHgQzWf5IPYfTmmWv/k30BvZhQX7CYiIOZDyW/x1AgzGh9Kct2Ue6zNeQeYX2P7zJk3FsMUaA48jfXU2mBJRtD/CAyt6/8Luy0z2XobX6NQrfkmLfmbBIMjcJ5/9sNPa8c299nQNesSYjrHuNixKlJj4UNOe8bYLV0CJceh4QHp6VPBHe+W0z9DuiAUkLrYwKhSLEjwABMB0l/RdSeczuEcRjZ5jvRIj38O7qGY5z3AcNC2AEqALJFYMyEp+aXECbK1nbeFvjAHGpgBJytXxi4WsvCqcM7AGZvaP+FwrenZNtzXI8Cbv/Z2QILPVnWj4Pq+8ycpi5xWuqpwCmHypFosG9S6DoPal0FhUIxiKA8ivZJrSGREHLtLaUmYomYA+w5Id+onILioy4HNFMIvXdTX4upWFoEM0oZ8N0Xg2FcELlqP0dVPvYcuMp7eliQMJZ16l9MBflMQFAKEgw8AlxWbGXRMb7GTi8ZygsgLinwQn7eXKdKvouwvgzQc3vZij7cNU22v32MVYr4ZM/MXdH+9hIH6wzciRAi/IGRK8g7+ZWbuawt88whvSYRkesdAsc1hUm0zItBnyL/kSsuW
 ODampWtM
 LgYLEG0UqDgeapyKVFDe6CiyJVRogia/cWjpuAadbMWB/IYIAr2g6NmTaI9cwqiu8RoLoiUrwWfcX1x+Gk+j2nmFloLgzUYhISO1sYMmhAiqjRGoB1JN6DV9JCAzuynboMOuL5LWDPDJBrmhHX1edfKfaj31eOiQcyNs8xkZve6LyuBgnAf6Q7x9rlUenClpoXKrR8bjaKku5G9TLF24XH0eqhjhk6pLmaArQGIkKFYNMAU5HtRzyywwR5CWrBl3yWgP6fVon6gYuRsIZxRhsgYlG9wkXt1zOWXitYnWG987SJ0N9+RewKs8SYzlKGqobrZayfAyOcVvnQNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 04:10:51PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Sun, Aug 23, 2026 at 03:17:40PM +0300, Mike Rapoport (Microsoft) wrote:
> > Move userfaultfd_{missing,wp,minor,rwp}() and userfaultfd_protected()
> > ahead of uffd_disable_huge_pmd_share() and uffd_disable_fault_around()
> > and make the latter two use the helpers rather than open coded VMA flag
> > masks.
> >
> > Convert open coded VMA flag test in mfill_get_vma() to userfaultfd_wp()
> > as well.
> 
> It'd be better to do the moves and the reworks separately. We don't have a limit
> on patch count :)
> 
> >
> > With every user of the per-VMA uffd modes going through the helpers,
> > their underlying representation can be changed in the next step.
> >
> > No functional change.
> 
> There is a functional change, or at least seems to be, see below.
> 
> >
> > Assisted-by: copilot:claude-opus-5
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  include/linux/userfaultfd_k.h | 70 +++++++++++++++++++++----------------------
> >  mm/userfaultfd.c              |  2 +-
> >  2 files changed, 35 insertions(+), 37 deletions(-)
> >
> > diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> > index 3396d270b159..d8262e3dc134 100644
> > --- a/include/linux/userfaultfd_k.h
> > +++ b/include/linux/userfaultfd_k.h
> > @@ -168,42 +168,6 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
> >  	return vma->vm_userfaultfd_ctx.ctx == vm_ctx.ctx;
> >  }
> >
> > -/*
> > - * Never enable huge pmd sharing on some uffd registered vmas:
> > - *
> > - * - VM_UFFD_WP and VM_UFFD_RWP VMAs, because the write protect / access
> > - *   tracking information is per pgtable entry.
> > - *
> > - * - VM_UFFD_MINOR VMAs, because otherwise we would never get minor faults for
> > - *   VMAs which share huge pmds. (If you have two mappings to the same
> > - *   underlying pages, and fault in the non-UFFD-registered one with a write,
> > - *   with huge pmd sharing this would *also* setup the second UFFD-registered
> > - *   mapping, and we'd not get minor faults.)
> > - */
> > -static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
> > -{
> > -	return vma_test_any_mask(vma,
> > -		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
> > -					VMA_UFFD_MINOR));
> > -}
> > -
> > -/*
> > - * Don't do fault around for WP, RWP or MINOR registered uffd range.  For
> > - * MINOR registered range, fault around will be a total disaster and ptes can
> > - * be installed without notifications; for WP it should mostly be fine as long
> > - * as the fault around checks for pte_none() before the installation, however
> > - * to be super safe we just forbid it; for RWP, pre-faulted neighbours would
> > - * be indistinguishable from accessed pages in PAGEMAP_SCAN (PAGE_IS_ACCESSED)
> > - * and pollute the tracked working set, so each page must be populated by its
> > - * own fault.
> > - */
> > -static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
> > -{
> > -	return vma_test_any_mask(vma,
> > -		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
> > -					VMA_UFFD_MINOR));
> > -}
> > -
> >  static inline bool userfaultfd_missing(const struct vm_area_struct *vma)
> >  {
> >  	return vma_test_any_mask(vma, VMA_UFFD_MISSING);
> > @@ -235,6 +199,40 @@ static inline bool userfaultfd_protected(const struct vm_area_struct *vma)
> >  	return userfaultfd_wp(vma) || userfaultfd_rwp(vma);
> >  }
> >
> > +/*
> > + * Never enable huge pmd sharing on some uffd registered vmas:
> > + *
> > + * - uffd-WP and uffd-RWP VMAs, because the write protect / access tracking
> > + *   information is per pgtable entry.
> > + *
> > + * - uffd-MINOR VMAs, because otherwise we would never get minor faults for
> > + *   VMAs which share huge pmds. (If you have two mappings to the same
> > + *   underlying pages, and fault in the non-UFFD-registered one with a write,
> > + *   with huge pmd sharing this would *also* setup the second UFFD-registered
> > + *   mapping, and we'd not get minor faults.)
> > + */
> > +static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
> > +{
> > +	return userfaultfd_minor(vma) || userfaultfd_wp(vma) ||
> > +	       userfaultfd_rwp(vma);
> > +}
> > +
> > +/*
> > + * Don't do fault around for WP, RWP or MINOR registered uffd range.  For
> > + * MINOR registered range, fault around will be a total disaster and ptes can
> > + * be installed without notifications; for WP it should mostly be fine as long
> > + * as the fault around checks for pte_none() before the installation, however
> > + * to be super safe we just forbid it; for RWP, pre-faulted neighbours would
> > + * be indistinguishable from accessed pages in PAGEMAP_SCAN (PAGE_IS_ACCESSED)
> > + * and pollute the tracked working set, so each page must be populated by its
> > + * own fault.
> > + */
> > +static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
> > +{
> > +	return userfaultfd_minor(vma) || userfaultfd_wp(vma) ||
> > +	       userfaultfd_rwp(vma);
> 
> This is changing the logic.
> 
> Before we were testing only the flags, now we have:
> 
> static inline bool userfaultfd_rwp(const struct vm_area_struct *vma)
> {
> 	/*
> 	 * Callers gate PAGE_NONE usage on this; PAGE_NONE is a BUILD_BUG()
> 	 * without CONFIG_ARCH_HAS_PTE_PROTNONE, so fold to false.
> 	 */
> 	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
> 		return false;
> 	return vma_test_single_mask(vma, VMA_UFFD_RWP);
> }
> 
> I.e. adding in a CONFIG_ARCH_HAS_PTE_PROTNONE check.

Without CONFIG_ARCH_HAS_PTE_PROTNONE VMA_UFFD_RWP is hardwired to VM_NONE
so it's functionally the same ;-)
 
> BTW side-note these:
> 
> static inline bool userfaultfd_missing(const struct vm_area_struct *vma)
> {
> 	return vma_test_any_mask(vma, VMA_UFFD_MISSING);
> }
> 
> static inline bool userfaultfd_wp(const struct vm_area_struct *vma)
> {
> 	return vma_test_any_mask(vma, VMA_UFFD_WP);
> }
> 
> static inline bool userfaultfd_minor(const struct vm_area_struct *vma)
> {
> 	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
> }
> 
> Should all use vma_test_single_mask() really :)

These are changed anyway in a later patch.
 
> --
> Cheers, Lorenzo

-- 
Sincerely yours,
Mike.

