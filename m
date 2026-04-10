Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D139F459F5
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9982B6B00BD; Fri, 10 Apr 2026 11:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96F3F6B00BE; Fri, 10 Apr 2026 11:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 885906B00BF; Fri, 10 Apr 2026 11:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76DFE6B00BD
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:27:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1735C58525
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:27:03 +0000 (UTC)
X-FDA: 84643024326.11.5ED5F95
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id C1DB180014
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:27:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TIXAtJbX;
	spf=pass (imf02.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4cFgle6OvvDEQMPYV4EUwy/InNyaem1K8y2fw9CmrM=;
	b=g/NcaWNXlJ9aDbAhHe3l1OiwMuX5n3S+fQOA8o6xPorndBdFn2R6j7zGX5W8aTC5GCz3o6
	eWwMBb46ravx68VFjK5VERyieSWU/z+XPtWOZ9zaAtUXm5I60Z70y057Le2f2NtYZd6ZEY
	5ppIkJomtcH/eVJibPhqGKDbJo1JQiU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834820; a=rsa-sha256;
	cv=none;
	b=cfGNrGtK+vdaOsvarlom7gfEOXWtKL33dTKVPtk+xvETtl74mFJBpf249e99KawBixbnav
	8n+C6RBgQ0LlqkT+YHaiUvEzqHKHTuAsnPvef/xJGTWEW4+j5zgXiAJg//0efua/Ki65xe
	9XC53BYl22DVMzjr0EhQDDl7lU0uikk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TIXAtJbX;
	spf=pass (imf02.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775834820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O4cFgle6OvvDEQMPYV4EUwy/InNyaem1K8y2fw9CmrM=;
	b=TIXAtJbXLmONZ1EZsNrdAjMjPefjckS2PbNS5TPl6Skys/pRTW0g2KtvGXWE7psiLkHcBL
	xLDMWJIdsL+ZdWTDFfCtFNwMbvX5at7oD4qi1Rq2dkfhfqavnyR4Ds6OZkVczrxhTrqCNh
	6WfvahwgS7VugOaBGQXDwtYvJZKs3m0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-hXcKZYmgMPylqLqcBeegsg-1; Fri, 10 Apr 2026 11:26:58 -0400
X-MC-Unique: hXcKZYmgMPylqLqcBeegsg-1
X-Mimecast-MFC-AGG-ID: hXcKZYmgMPylqLqcBeegsg_1775834818
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50b4987c698so58296331cf.0
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:26:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775834818; x=1776439618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O4cFgle6OvvDEQMPYV4EUwy/InNyaem1K8y2fw9CmrM=;
        b=qG+/GzaAMvGbGDMZpCq4olTTl63Bcq4ZSFTicxI5GBDZpevr7MRPFCVF6pWYZ8dmJ0
         Zo4WEUPTBO7ZR4hF8xaF4aIMN0EGSINpO0eERr6rzIkhb7Q4CjhB5QO51/kmnN7PJv+M
         LbHwZR2iM9xylCWndV2d6119v6JCwNh7+IMH2/kmSHcYX+o/l5fFILDVHU+DSzRSz2hk
         Kvg1wIRgWYaLQ6+X6fZAVYxrxquw6GBjKQxwDBr3mIZeRllEJjY5lmDx99CHNGp46RME
         aqovzBGAw7EFBQucohpm6rOB7AiNSSA45Rp/n+e0SWo6KB4iwciT74Y2VfWGz3RmfkcI
         ClIw==
X-Forwarded-Encrypted: i=1; AJvYcCXgm3s8zOhWyMAlmO8c0n7dp5WsyOlPnITPbSp30cuJ08rLLLyZDjZPYUWpqVmkHmYROstoZqJ1rA==@kvack.org
X-Gm-Message-State: AOJu0Yy1Hks9Hkc3UZ37rFDWJCe7lFYbXf9zcu84u8sx4sAi4+gFL1oS
	WlcJ7slqX2gv1SXhVGjQqzGZrddIc2AEh3V1ca5yUEjwMwHGkxhh2STxdlTyDNKg4w6tTf1pkOs
	B5D3OCbYq+SJF0OVw+CGfG2f7KQ9exUjJnYXudSAQhmu/LW3DDKSy
X-Gm-Gg: AeBDiesSimPd7YaeaKaUEtCSU3fvxhhfFobJpQJJBzMK3ryVNpxY+gOUPji4qb1Hvdd
	fUSNyjdjV4YoTnlzWP7vbRNlf+Km7J7sr8+fVtjUkujPpLVZyU52LI/hb0tdwWOlqyvtnL1E1WY
	BXgOq2lZt4mGW/POAxOqf4r51PfNFpoe368o2DVCf+Pf5iHx8aNMvyV0NF/0idcK2JCA2TW2bAO
	4vOe3SAAnnuAbOyovtj/0mpj4WQcGEpdcQ3uJF/jGO9LNzdEF6wTqEGurZ+Lkmy2TldufBczG6C
	oh2gotL9fWO/P34A5zTqT00wjbdJoqcIlEiaZB1bmFwCa8srR7jQSt0aP0Qp5SS2BEt+vlK+1h/
	OxbGIkal799I9EofE0crZfQeJOtkXo48MhiudcR1Df8SelTU=
X-Received: by 2002:ac8:7d8a:0:b0:50d:8324:6d24 with SMTP id d75a77b69052e-50dd6a6add7mr42027221cf.7.1775834818116;
        Fri, 10 Apr 2026 08:26:58 -0700 (PDT)
X-Received: by 2002:ac8:7d8a:0:b0:50d:8324:6d24 with SMTP id d75a77b69052e-50dd6a6add7mr42026341cf.7.1775834817255;
        Fri, 10 Apr 2026 08:26:57 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50dd53f21aasm23801201cf.10.2026.04.10.08.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 08:26:56 -0700 (PDT)
Date: Fri, 10 Apr 2026 11:26:55 -0400
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: David CARLIER <devnexen@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-ID: <adkWv9xdsyLMn9qd@x1.local>
References: <20260331134158.622084-1-devnexen@gmail.com>
 <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
 <aczOCqrCx7Xd5HIF@kernel.org>
 <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
 <ac3paYh6sPHr3EJd@kernel.org>
 <ac5yKatsMxNp4G2g@x1.local>
 <adeOIvNXFLTCXMcv@kernel.org>
MIME-Version: 1.0
In-Reply-To: <adeOIvNXFLTCXMcv@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Z0OHDV9Fe6XOQnvOK1qac7Ml2UQcEvtv_rFDoP9R-uM_1775834818
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: C1DB180014
X-Stat-Signature: uskh4udyek1n4m6t8pcwt3r76sdoyyxd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775834820-86348
X-HE-Meta: U2FsdGVkX18VMoSKenMUMfwq2DB1u6an8qorPmsLCWnDjG1FiaXd/K1hcgsdAr7Gvb7OzaDvXaamq/Ga00Er8McLfYb8HwhL+Ko5nMWomG7Fkg+zWKRhrUKnr+AwVGfMN59FCejfbtPX2r4zm/vXo6xARJizZzuBtyb5AlZfubfHpjmhXoQjula7HIHDIV1Vmk+lbs6RhdMyDy7WNOD500+4aYb9MNyGaqx7frelwjeHjMIy95K8wzEcgnuQRLl8lMWiFSmwIPcxFc3185Tc27z9QCjWqv5VWC57C/9sQ2J5HzaxzAKlhI9GbC2nTiZQsdEBFo2HRR7X8QKNjBKXknpGkVdqjgCP0j2kWSODk8cx4FU9H/pZdiTlABS/F5RktRUeRsDBkcpgeEp4+B63N73KLDpPP1A3K9p3Pjs9pxUMv9QranGe1hxRqPBDZjSL4hg23EhDGCEuevPFkoN1GZNQMiR9lXPtKG+vFaI24J79N5urwVSHvZ8gxfJwV8AG/9TL3cCOuVTVyoJol1YU6xG2Hr0IU7OVdqdZLIt67KU2D11EiUF598Pl6NtIPkc0km3ZawPW1aZwu3pks7iaMhe163RUPMsh/dgTx2E9QWdLbFnMST2K3JzUJPvRg0EsdJO3qn26dwTPYwAGVszCWQOVKbLZyJ9zO7OyZfPkmbV4w5oh4VdVC3Hy/hNrdy8Y6j2dMSXnjrlII8ojR7mF44qIo0AV6FDk1di5GkZZNUGmYCScHbyP8Sg2RzHsmXTNOBBozHRvM3Migqok8izDtV3YNfkinOy/vMF2GetV544kgAlRy+810SqpVso/CguO+Cpc9onaQYzMfyrIUnL7y199Zukmrk1R1F62KEgxWlSRJ+GdtPYYOx6g0RN7iuwrIHjJrw7c0quiqDkhk2m6YJmPYo+1in5nkEVHuOh9kNXpHcsEqC6G+W2gBF1DSsWGTgBHiLSbyrQNupBQoTR
 8c81sF67
 HTe4H/IbSBcEzQ3/DOglR35NZrnLzxYwz42hpNW/f5Rky01yyEZr/bee1EPlhOkQJ2SLGt3EZb6ruQIzc+2yJdANOj6SGsiLXI9lqN++2dMmFtpzLCn4RJaoiRI+I7srT11860gRVkXC5Qmg0Gnz50nG6yjmStwqVZHzA31/2WKGfyiEyqt1sTyAvGksEnhvAbMB+Za2no2AA93aIFjvvEKkj3Rb2cpPQZZQ9avXaKd+MXSA5sHq7QckgeDvd10zTnNG7c8ZyMgpbLufruJjawtciwB/OdWr7Zt0/uCVHMRZK7AgLkQUHnkKK4XSTKAdSmuKB9xxk7K9ext5+jZSiFTCygnYcdPWuA/lrgeaALsb8cpre8iN+uf9ZWNrEmd8v0enLQ0gbQXdXvO98WkgVx9XTd4Lgu6cocRXyFyPuLkaeLyfnKRW6Atoucw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 02:31:46PM +0300, Mike Rapoport wrote:
> Hi Peter,

Hi, Mike,

> 
> On Thu, Apr 02, 2026 at 09:42:01AM -0400, Peter Xu wrote:
> > Hi, Mike,
> > 
> > Let me also leave my comments inline just for you to consider.
> > 
> > On Thu, Apr 02, 2026 at 06:58:33AM +0300, Mike Rapoport wrote:
> > > Hi David,
> > > 
> > > It feels that you use an LLM for correspondence. Please tune it down to
> > > produce more laconic and to the point responses.
> > > 
> > > On Wed, Apr 01, 2026 at 09:06:36AM +0100, David CARLIER wrote:
> > > >   On Tue, Apr 01, 2026 at 08:49:00AM +0300, Mike Rapoport wrote:
> > > >   > What does "folio allocated from the original VMA's backing store" exactly
> > > >   > mean? Why is this a problem?
> > > > 
> > > >   Fair point, the commit message was vague here. What I meant is:
> > > > 
> > > >   mfill_atomic_pte_copy() captures ops = vma_uffd_ops(state->vma) and
> > > >   passes it to __mfill_atomic_pte(). There, ops->alloc_folio() allocates
> > > >   a folio for the original VMA's inode (e.g. a shmem folio for that
> > > >   specific shmem inode). 
> > > 
> > > I wouldn't say ->alloc_folio() allocates a folio _for_ the inode, it
> > > allocates it with inode's memory policy. Worst can happen without any
> > > changes is that the allocated folio will end up in a wrong node.
> > 
> > For shmem it's only about mempolicy indeed, but since we're trying to
> > export it as an API in the series, IMHO it would be nice to be generic.  So
> > we shouldn't assume it's only about mempolicy, we should rely on detecting
> > any context change and bail out with -EAGAIN, relying all rest checks to
> > the next UFFDIO_COPY ioctl done on top of the new mapping topology.
> 
> My point was that this is preexisting bug and that we don't need to rush
> with the complete fix that will extensively compare VMA compatibility...

Yes, I fully agree it was pre-existing.  My guess is we only didn't reach a
consensus yet on how to completely fix it, and whether we need an
intermediate fix for "a VMA suddenly changed to hugetlb" only.

>  
> > > This is still a footgun, but I don't see it as a big deal.
> > 
> > IIUC this is a real bug reported.  Actually, if my understanding is
> > correct, we should be able to easily write a reproducer by registering the
> > src addr of UFFDIO_COPY to userfaultfd too, then the ioctl(UFFDIO_COPY)
> > thread will get blocked faulting in the src_addr.  During that, we can
> > change the VMA layout in another thread to test whatever setup we want.
> > 
> > > Let's revisit it after -rc1 and please make sure to cc "MEMORY MAPPING"
> > > folks for insights about how to better track VMA changes or their absence.
> > 
> > No strong feeling here if we want to slightly postpone this fix.  It looks
> > like not easy to happen as it looks to be a bug present for a while, indeed.
> > 
> > It's just that if my understanding is correct, with above reproducer we can
> > crash the kernel easily without a proper fix.
>  
> ... but we do need a more urgent fix for the case when a VMA suddenly
> becomes hugetlb, because that could not happen before the refactoring.

Personally this is least of a concern to me. Hugetlbfs is so specially
managed in userapps, so it is even less likely to trigger the same bug with
VM_SOFTDIRTY changes or other ways.

But I understand your point.  You want to cover what your series changed on
this.  If you think this is the right way to go, I'll follow your decision.

> 
> For that, it would be enough to check that ->ops are the same before and
> after copy_from_user().
> 
> @David, do you mind to send a patch for this without waiting for rc1?
>  
> > > >   The vm_flags comparison was a secondary guard against permission/type
> > > >   changes during the window.
> > > 
> > > Permissions should be fine, they are checked in userfaultfd_register.
> > > Some other flags that don't matter to uffd operation may change during the
> > > window, though and then a comparison of vm_flags will give a false
> > > positive.
> > 
> > IMHO false positive is fine in this case when -EAGAIN will be used (which I
> > still think we should), if it only causes a retry.
> 
> I still disagree, but let's postpone this discussion for later, when David
> resends the patch that compares VMA properties.

Maybe it's because we are having different checks in mind, where you wanted
to check only the "invalid cases" but I am trying to make it fallback for
all detectable changes.

IMHO it's hard to define "invalid case" in this case, and it's also
unnecessary when a EAGAIN will be processed with another UFFDIO_COPY
attempt and we'll simply redo all the checks.  Hence relying on VMA change
would be the simplest, safest to me.

Again, I'm open to any suggestion on replacing the vma snapshot logic as
long as all possible issues got reported will be properly fixed, especially
in the latest mainline. I don't worry much on backporting yet; if this bug
existed for 10 years and nobody yet reported, to me we can always evaluate
the effort to backport or skip.  However, a proper fix in mainline is IMHO
more important.

Thanks,

-- 
Peter Xu


