Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BB56CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 15:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A31126B000D; Mon, 24 Nov 2025 10:09:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1D56B0026; Mon, 24 Nov 2025 10:09:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F6DC6B002A; Mon, 24 Nov 2025 10:09:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3746B000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:09:55 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 439F11A0411
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:09:55 +0000 (UTC)
X-FDA: 84145835550.19.E1F2DFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id CB4AB80013
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:09:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lek3isPN;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763996993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AmmJeRshMQi+Am75NkKHbki1ugWiPb0WAnWZ/jTIddA=;
	b=SaVf36H0B8nS2GEiIPVqoIbTkC28jWDA9hLbdj03KvZrv3yIG+UJTwepllJB6YT7FStvJw
	z2a90e2opxJCowTHMc1XpRyYxWVL0GE8Ah6bzviIXZm3Nkt9kCwAl+mWHBab6v37/LAV/+
	BZE+x1YfboZTVlKS1WtPMwGFdsCT1BE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lek3isPN;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763996993; a=rsa-sha256;
	cv=none;
	b=7JhzLO1lC3pn7eHHVvUov4LEv8rkkoARlWnR/dWrJVM3Kf8bMIqVUdG3KEtxHqKPx2TmwM
	/JxIUGzZiJQ7s5Vx7CnYrN0ZKHyw8Uh7Jfcq0D+iw35v9wZVblTy2vBR3ov4tlqpfi5vkc
	NVHPyVcZa0i6WUKY5dTf9rSgCTfaMhE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D54260163;
	Mon, 24 Nov 2025 15:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A37C116D0;
	Mon, 24 Nov 2025 15:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763996992;
	bh=UuNKUt3TuSlZUnNzguJ+jbkaDA7UcbKM9pSfdm62QCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lek3isPNtIB6N3n0GIvhZdhWijDxLAVSgOvnASeFW517VlnW9/1RzyxNSlSvsN0gg
	 ZPP98kUpTQ4ugwLMNzFpUYVjFK5ZtgMyp1/H+4ixzsncuDlGl8fH146PDyVxT7VXBg
	 hLTS02x4Owpo3jPegb4cH2GGSY9kjcxtbPOABSA5sWD1tF98KDw2ksyh83nxGkk7Ka
	 LcgJ1V8OTBA8puGb3EHOzl9QdnDnkSUK/W0onoWvHiQwdOO/wo1BOwC/lZAfWIlMF8
	 QvONdvjIjRI+/UPI3JfDGImnK6JmEAW0pVAxLsu10Q343giqj6gwAqHpT8Q6kWJoLH
	 JbgmuUCJIYtWA==
Date: Mon, 24 Nov 2025 17:09:43 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 3/5] mm: introduce VM_FAULT_UFFD_MINOR fault reason
Message-ID: <aSR1NxBi9ZYoKhwT@kernel.org>
References: <20251123102707.559422-1-rppt@kernel.org>
 <20251123102707.559422-4-rppt@kernel.org>
 <ef739802-1b53-4baa-81e4-dcc674d7c1c6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef739802-1b53-4baa-81e4-dcc674d7c1c6@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CB4AB80013
X-Stat-Signature: nujcjtukdox7b84fsw8o6s9i3wtajwmg
X-Rspam-User: 
X-HE-Tag: 1763996993-781388
X-HE-Meta: U2FsdGVkX194+v+OTKbbqx3D9Xp9X8+cZmnI/aeyiiRYyDpD9jsF5VHh9r7MExJDx3eV3gBYSJbYvOnpW5qBdKwEIJUZ5EBbpeI0GHwgtm7ZFi7tF/3rwJDSxgRc3t/k858yyRIm8GdLmT7jSY5hvNLYi0sMaJR51fgVoAlKRBkxw0kTfnOM7LtfqJ8l0S1r8Vcki0hrBxkGAyKHgBiBsgkhoAhGxmsG+gx2cmguUAUVqENjmb6I09toANK8nd4PAXG0JusX2SSle7aWc/BKVhj8m75RoAsKqQB6qGDJTM5kGFg1SG8WcVO8fnMlfIOExWcqaOCwQ1W2O0amZS1XABzChEPtMDKjXN8okpC7KBiOUfXVrhLW35IZ7SERE1vSeW0ZFwg4d1Way57Z690SiCVHVsm/GK0yF9pM62tJf+LlClpV7nDscAzUT0qGRs6LKCT9HWbZnH4FlvQz+nj0hNAcA6wV7AKtZ9lwps6QcGJjIDrjQFK2i9xE4ATaL6bIBsyfPpmCRuzP3W804xo/bx72p3mC9GY85LlzGlTy1i/1i5J4bU9UaUKKC5i9+4RIllq2jW/4iZCY9WcvoupCvNbeG+9r+qu8QYgULbzMCn8mCcHLSQ60bHoDrvu9Byiz380JMbPvYwmrzcfW8O91IDbRHzBhN6dwwze8LFIrbCK3SEUxV48NPNU0CPWseXAG7OxuklDAotoj/4vqNmrnfVzRu/AFBY37Lkhk4W/rEyDaWsezcie2XTdZfB3JWiiw0viAXro0WQv+nrJB0iPkMejJfK9Zn5O7WWFzgJ525ncIlHP2rC24lPmGVQttXvsmEUlGzh8YlWJ0CZXdXZC07NHF3k4IH3ZX0FmIs5ZrceGNRmR0NuNiDfLcU82Bb4SEn0Yr5QBVvWcATuYVutErU9q0TE4u0HeGzMe6dkXFFlPEWNDlIQwNCzdfV22cH0cyGEKpIQBHVx3k8nor/9O
 Aphhj63u
 HPebl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 12:05:18PM +0100, David Hildenbrand (Red Hat) wrote:
> On 11/23/25 11:27, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > When a VMA is registered with userfaulfd in minor mode, its ->fault()
> > method should check if a folio exists in the page cache and if yes
> > ->fault() should call handle_userfault(VM_UFFD_MISSING).
> > 
> > Instead of calling handle_userfault() directly from a specific ->fault()
> > implementation introduce new fault reason VM_FAULT_UFFD_MINOR that will
> > notify the core page fault handler that it should call
> > handle_userfaultfd(VM_UFFD_MISSING) to complete a page fault.
> > 
> > Replace a call to handle_userfault(VM_UFFD_MISSING) in shmem and use the
> > new VM_FAULT_UFFD_MINOR there instead.
> > 
> > Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >   include/linux/mm_types.h | 3 +++
> >   mm/memory.c              | 2 ++
> >   mm/shmem.c               | 2 +-
> >   3 files changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 90e5790c318f..eb135369940f 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -1523,6 +1523,8 @@ typedef __bitwise unsigned int vm_fault_t;
> >    *				fsync() to complete (for synchronous page faults
> >    *				in DAX)
> >    * @VM_FAULT_COMPLETED:		->fault completed, meanwhile mmap lock released
> > + * @VM_FAULT_UFFD_MINOR:	->fault did not modify page tables and needs
> > + *				handle_userfault(VM_UFFD_MINOR) to complete
> >    * @VM_FAULT_HINDEX_MASK:	mask HINDEX value
> >    *
> >    */
> > @@ -1540,6 +1542,7 @@ enum vm_fault_reason {
> >   	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
> >   	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
> >   	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
> > +	VM_FAULT_UFFD_MINOR	= (__force vm_fault_t)0x008000,
> >   	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
> >   };
> > diff --git a/mm/memory.c b/mm/memory.c
> > index b59ae7ce42eb..94acbac8cefb 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5279,6 +5279,8 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
> >   	}
> >   	ret = vma->vm_ops->fault(vmf);
> > +	if (unlikely(ret & VM_FAULT_UFFD_MINOR))
> > +		return handle_userfault(vmf, VM_UFFD_MINOR);
> 
> If we could define VM_FAULT_UFFD_MINOR to be 0 without USERFAULTFD, we could
> optimize that check out completely on such configs.
 
It will be a bit ugly, but we can :)
 
> -- 
> Cheers
> 
> David

-- 
Sincerely yours,
Mike.

