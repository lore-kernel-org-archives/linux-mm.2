Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6BC8FE5211
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 11:51:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E1B66B0005; Fri, 24 Apr 2026 07:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 192236B008A; Fri, 24 Apr 2026 07:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 081126B008C; Fri, 24 Apr 2026 07:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E62CC6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:51:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 979BBA0102
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:51:52 +0000 (UTC)
X-FDA: 84693285264.22.E8D2639
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2E96218000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:51:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WtwYNfEx;
	spf=pass (imf06.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777031510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GPTaXwfQ0pC1v72UmTco14ZekCM1pyHL+NlaDMIoFPc=;
	b=8YV3hpv+SCR2mJPQJC/PZeFYJ6tbl54Xtui1KEMMB1IRlkBDNwOQ1T9ajXTel/gXB1L2Rd
	C3vgnvFaHuwuwCSNNQKihYQvcZcQO6Cfq8NTnjwnJz1BOzQIoCqFbuNnWx2RmI50+faALp
	6sbnQTsk9FUZjxzF0qgE5kRGlKJN+gE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WtwYNfEx;
	spf=pass (imf06.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777031510; a=rsa-sha256;
	cv=none;
	b=4Giqe5Uy5AaFim/6RgWhXJSoLvoCq8NcSg6ZJwZY/rjfkTmkR1LfY3MdMVlFqOeq+7N4W9
	J28ZBUXdw3U+7zDG9OZjGBWDIxQ/Ifcvtvod7xuLGl5pvptU279w3IPkm2fvqWZBYCRwVX
	3JE2TSanvH7z7lErfoZEbRZIL081qq0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777031509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GPTaXwfQ0pC1v72UmTco14ZekCM1pyHL+NlaDMIoFPc=;
	b=WtwYNfExDRDHNJodo1Pt6+HhZzPSTR8wR8+ymtag+VmiDeApi4kAYCslbLT7xNvK1I+FCB
	dTeCzwQ66dDTjFus/ESs3LnmTmU1RjCzK8a8P26qdyJ/0noL9+wx0THWuCLhuoEpsgbGe+
	bvpBr19XoVAn2sCZ/bUtsr0QYqZna1g=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-95gj4aq9MRyIImtn7vsCLQ-1; Fri, 24 Apr 2026 07:51:48 -0400
X-MC-Unique: 95gj4aq9MRyIImtn7vsCLQ-1
X-Mimecast-MFC-AGG-ID: 95gj4aq9MRyIImtn7vsCLQ_1777031507
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8acadca1ac4so216452966d6.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:51:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777031507; x=1777636307;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GPTaXwfQ0pC1v72UmTco14ZekCM1pyHL+NlaDMIoFPc=;
        b=iEfV2dQmp6pmsZI9Et42B9RqjpUIMFEejauVmm5zsD5fXZlo6uPdbB6hQPmdGfZqH5
         /AQEiHRAZndL+HUEZOvIHt1Y/Ly5U6QDqC9JPSm1VRXuWbxqVX1hjgybr6towIoNCp8A
         /vPXb+IAHjm+MNiaOi8KzV4P4GPRf4RN+gIGwTCXl5830/VDztnBVBZn4qelP0V/3emv
         G63Pmu0nbuWwtmiw60VhwkJvmoMRfa5y8eCZWBJkxiYOX4iBFEGFl1pMVSB0TbLXGvht
         ymsribHwgyEoDjzq3YJV4Iv0QAIsVrWQnOaXUJbXi4GMbVbz5A+GweeEdGt0IiTYMecN
         T1tg==
X-Forwarded-Encrypted: i=1; AFNElJ9ktM2f++RCj9smoysI1KI5w1uuoGwBGGZ+M6b7mLQB/3ABm4SIJzClTJoNVLNDvZ6A8vgC0XujWQ==@kvack.org
X-Gm-Message-State: AOJu0YzEB2kcuN4TnLIm/SLSRzF+Y62raXItR1VcHafAadJKzZmBXMFd
	/GQDVvJpXxr0Nv0pkTNsebQGhSNp6o4EQN2hzX2MfJJMagzsMk0cP2I2lGh89Oza+FaiK1D+LeL
	DxfLVuyo4DOqmXUVL4KYTEC/u+kkAc7+KchIHSvS4g2qbXa67xv3Z
X-Gm-Gg: AeBDieubku58bLXFN5wqEYHwGh3xHi51NC5ZoZZSdMG21tbDVMFJ1Caka52TBsS+nDt
	i9b2yQyV3q0lqPz3oulg8RX2DFm2DNsv4ZPhhqFbt6KDOFHzyi4GeXrOLbDomZ1q0XZBCLJW7Sa
	7ObwqQjmaq6uEReUaeYVpBwcBEQMDDC26KI7qCGC2O+Icak6tEMZK1xNY63dTmU/I4uufxkViQ8
	Ypl6xigcUIQCMKUvZxzZNaKEivMyh0xxt66i7aaSinut3D7lO37UGnXQEy/jEgINfTmBrDbcP88
	FApnUZJj8NAEo7Puw4Ytgj38Uh5G0bHYJbDou0Rb1lyhMtlE3eNgCjdM6brTg+7hC07NL60VEva
	VmInu/yUnFYQHHMFfCIlrQliXWZNaZF0/Zc62SW0uyVinVpA2Z/6qbEjX/g==
X-Received: by 2002:a05:620a:5698:b0:8eb:605f:6cd6 with SMTP id af79cd13be357-8eb605f8de1mr2383250485a.60.1777031507379;
        Fri, 24 Apr 2026 04:51:47 -0700 (PDT)
X-Received: by 2002:a05:620a:5698:b0:8eb:605f:6cd6 with SMTP id af79cd13be357-8eb605f8de1mr2383245685a.60.1777031506710;
        Fri, 24 Apr 2026 04:51:46 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d64cce76sm1958573085a.14.2026.04.24.04.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 04:51:46 -0700 (PDT)
Date: Fri, 24 Apr 2026 07:51:44 -0400
From: Peter Xu <peterx@redhat.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <aetZUOINzfTXChLL@x1.local>
References: <aeImfRrrvr3UoKtL@thinkstation>
 <aeTnlQUOOh-dHG8z@thinkstation>
 <34f75083-29a3-4860-8a6e-94551d37ac6a@kernel.org>
 <aed6fHLrIdahbdY3@thinkstation>
 <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
 <aeorZMvKwu8zKX5i@thinkstation>
 <aeoxnuGKO3uqS2kG@x1.local>
 <aeo5IPpQi7onyjTF@thinkstation>
 <aeprnnccJeyHB2rt@x1.local>
 <aes7b17nG0cXrtEd@thinkstation>
MIME-Version: 1.0
In-Reply-To: <aes7b17nG0cXrtEd@thinkstation>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RTrvdFf69wTVi7ikku9miLq4LXxDY4NdBBvjYQ-Hpss_1777031507
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pp6kuirnstazszir4sdhsrn9ir65fxab
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2E96218000B
X-HE-Tag: 1777031509-554518
X-HE-Meta: U2FsdGVkX19m54OhZCwgQHeY9cyaIoq/SZl140WlyrRTsftlvI8ZqzJqOaj33NwVotQGzoZOONbdcGn/SQD+z5pzJI+FD3GGmJL4lWLApfy1qRmZe+2tWUk4roY2m0Frt6rTLX+FhloQGbIAZ2nPUImaKu1gmP6fKd/3TbTYZqpGPWJTItwElFfMXfxGdKKFBgxawY/o9n88CriApIBH9T5O9gHOwVpVSpo9r42HW9J1lQ5JG8XhU4aVzS24h8PAecVyPIUJSEJrgaRt5cJfYlikrndxvsajmONck4TjC8SMUsgJ4S2Mi/ITpvlqxRY2aYcQI0XwAe2xnFsMBGtHyvBTvEtmcOB5rTmA0JwjOK9L7Mlw5xP0ovOkng4jICtaIGNAlsoTDrSAoPv6b4/AmMBqXaSnANSW1TF5gTJGW2lk/qt+LWVv0emBNYYEbWdZYiY9Tg1a7Rj5fTqyY0dyvI70eGymBMk+70NkQjqCAG+LqRisgtQ+7iHgPWM8rt46HdyXGWTcJhs+SL5HyqtklMwHN2tvxTNEes9e8dZueG2sCSV0714FFG/tq/r8QVl6TRILMqnOIVTVxJ34k8wN1lOsCXfQKryEIpxtkjvDWI9HRk+6mSSDga3Hd1+6tnzwNI7nFeJhOwOR8dO7tsqsHCWuQDMkc8cUu4oD80N+ZvK1WIC3AmP2dgWG77TfN1OAha8w3/Anz7gv5E2lgVzn2EZ+3pzTUYN8C+f5cuvgI6hi+kuycF8C9VR/8NTUw1swZUVdzbvezZFkF+l4+1Af4tgiYBmrIAvmiCCCMd2k1ppWuoZ8M0OrjqOcehgiDWd1LWQt7POogzRjX9U6OJiSSKeUUBRZbTjqQwJuqWaASTOhbA1Z3E5eNrKU2MDTlj7EzT/Ti3MY5TlSyCg+PSCR9liElszSjbxY8X6EtGUMYJe3JRuXqRhT6S1Otrz4lBdz1IHw6k09f4fbRnM5nMg
 yoUeEyK8
 HCnZTYm0Zp4xMJVhafsG+ZfaxMJf3Kq3EcZJWOOfiVkv3GdBPsKCsR4m1yhBN4RhHFCvll82sqpNtcup6y/sOK5JbjVPCwwhidkJSorpEh/CwOezBzkZizSkYwNhD1ZdF2g0ZOOxrE/yhyAnJlJFLtfnCSXCFLNQUDF4PEimsSByoCVZFCPR/nt9E0dciD/90DKzw9diGRPy+kZXKT6XVLH6/GdJMESkAFvWmqJycLKayt4iMwbQ+ezE7ZJAmW5CxCTQxKch5NF9s371pPCCM+BmGZcnnwVlnCZEmcSjnOpoq3R87NGBbVZHP5HOnwi5Cc8ffGIZ3jdVmetB96Hs4/0aHakDJu7V4UPjIPCY26zMn81aXJCWzU5KbZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 11:34:48AM +0100, Kiryl Shutsemau wrote:
> On Thu, Apr 23, 2026 at 02:57:34PM -0400, Peter Xu wrote:
> > On Thu, Apr 23, 2026 at 07:08:00PM +0100, Kiryl Shutsemau wrote:
> > > > - Whether read protection is required for an userspace swap system
> > > >   (e.g. did you get time to have a look at umap?)
> > > 
> > > I looked at it briefly, so I can miss details.
> > > 
> > > IIUC, in absence of read tracking it doesn't collect hotness information
> > > at all. The eviction is based on fault-in time: the oldest faulted-in
> > 
> > For example, let's imagine if we can have a per-mm idle page tracker, would
> > it work for you to collect hotness info?
> >
> > The other idea is, no matter whether we use MGLRU or legacy LRU, if we can
> > expose a better interface to share hotness info from kernel to userspace,
> > would it be possible?
> 
> I don't see how either fits our problem.
> 
> Both page_idle and the LRUs (legacy or MGLRU) track accesses on physical
> memory. We need visibility in the virtual address space domain.

Yes they are, but ACCESS bit isn't.  ACCESS bit is only about virtual
mapping or any similar mapping (like EPT's access bit).

What I described with per-mm tracking (either we call it per-mm idle page
tracking or using other interface) is about relying on ACCESS bit, not
pgtable changes using RWP.  IMHO It's more efficient and it will also
achieve your goal of VA tracking.

In your case (and also ours), if you're looking for VMs running virtual
machines, I think you need both pgtable's ACCESS bit and EPT-similar ACCESS
bit.  Here what's redundant is rmap, not ACCESS bit tracking.  When both
MMU and secondary MMU supports hardware access tracking, AFAIU it's faster
than RWP.

> 
> We don't care which physical page backs a given guest address at any
> moment. We want to know which piece of the user's dataset is cold, and
> the answer has to be indifferent to kernel actions underneath: the
> tracking must survive migration and swap-out. RWP gives us that — the

This is exactly what we hit...  that's the reason why I was trying to
propose a new API to read directly from swap (swap_access) or similar.

Btw, from another perspective, I believe we could also persist ACCESS bit
across migration or swap out.

For migration, see e.g. remove_migration_pte() has:

		if (!softleaf_is_migration_young(entry))
			pte = pte_mkold(pte);

For swap, it's different.  Normally, if an userapp would manage page
hotness, it will record the hotness within the userspace with whatever
algorithm it wants.  Then it will also survive host swap happening because
that hotness is per-VA.  It should be deduced from any hotness tracking
system it previously used to sample (and it still can be idle page
tracking, even if not efficient enough; when the VM page isn't mapped
anywhere else, rmap is pure overhead, it doesn't introduce false positives).

> uffd-wp bit is preserved across swap PTEs and migration entries, so the
> "this VA was declared cold" marker stays attached to the VA. A
> physical-side tracker loses its state the moment the folio is freed or
> replaced: a refaulted folio is a fresh object with no history.
> 
> Scaling goes the same way. Per-mm tracking of the form RWP does can
> scale with the working set. A physical-side tracker scales with all folios
> on the LRU/memcg, then needs an rmap walk per folio to map back to a
> VA — which is exactly the reason page_idle doesn't scale for this use
> case today.
> 
> There is also a cgroup-level confound: memcg hotness mixes guest memory
> with the VMM's own (worker threads, I/O buffers, vhost-user rings).
> VMA-scoped tracking is the natural unit regardless of the migration
> story.

This kind of further proved you're using shmem and you have separate
mappings.

Again, when with a per-mm idle page tracking these issue should all be
gone.  That per-mm idle page tracking needs to:

  - Ignore rmap so it's VA based
  - Still consider secondary MMUs, hence mmu young notifier needs to present
  - Work based on ACCESS bit (to leverage hardware tracking accelerations),
    rather than relying on a kernel fault to set the access mark, which
    should be more efficient.

The other thing is, could you please still answer why RWP is required for
swap impl in general?  It's not yet mentioned in the reply.

Personally I really feel like we're looking at very similar problems.  It
is a great news to me, because if you can convince me on the new api it
means our use case may likely also adopt the approach, vice versa.

It would be great to share the new interface no matter what it is, instead
of trying to push different ones.

Thanks,

-- 
Peter Xu


