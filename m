Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F12BECAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 19:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C968E0005; Tue, 16 Sep 2025 15:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4276A8E0001; Tue, 16 Sep 2025 15:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312EC8E0005; Tue, 16 Sep 2025 15:55:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3B88E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:55:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA041B729B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:55:49 +0000 (UTC)
X-FDA: 83896168818.11.E4D88D2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8FB134000B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:55:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BSNlb0hg;
	spf=pass (imf27.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758052547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCWQw5QvSmhTl1IZYTa8tC4TyGgvx1ILki+95+TRCAw=;
	b=orfCmCodHMwi/q5Y0IHIT+YRs9vmAYbpOmY5xps41Dt5+UrN7FSJGBv1H9Nl8X1Pz1EEve
	gcdWOEjc8kAfABz+NjksjENfV0K4a+s2T3/6Hkzb9Qt46ku9WHNXscV5evGzCf6NdZZhZf
	mi6ENJnr8VLwvSz0E/p1sr0E1G0w6bQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758052547; a=rsa-sha256;
	cv=none;
	b=LPCMMQspZ7T4aA82je0kUxwOm7VShMUfqlC8KfgMq75ha17CkJ06xpAfVq89GPlRiEaPU3
	tlc+VlwxIhrIvOxlqPCYlTbycXdqI8KBtOqVqo6anr6MmETLZK2wv4qLYiwzOyN5Y5RovE
	YbmRTgeXPkP//EJHADArH2lJEMQyjCc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BSNlb0hg;
	spf=pass (imf27.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758052547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LCWQw5QvSmhTl1IZYTa8tC4TyGgvx1ILki+95+TRCAw=;
	b=BSNlb0hgjT0Rj4DzDa/CNhq7xrRJ+X6+4ziYbPeOxQR+00Qo/YmaIeVE8I8+U4N1RtvSs0
	EXITX0gzDEGd4uJq0Rnnmu7duafacSveJqw+OzoywPTVO1X4S2iLSjHqWgnAQ9vgpXYjLT
	LVybbqZtDJc9qZucNMKU2D1B8HMrPjc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-xQvDVDKpPfuzJRL0xkZ8Dg-1; Tue, 16 Sep 2025 15:55:43 -0400
X-MC-Unique: xQvDVDKpPfuzJRL0xkZ8Dg-1
X-Mimecast-MFC-AGG-ID: xQvDVDKpPfuzJRL0xkZ8Dg_1758052543
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-82e5940eeefso67651385a.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:55:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758052543; x=1758657343;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LCWQw5QvSmhTl1IZYTa8tC4TyGgvx1ILki+95+TRCAw=;
        b=UmA9x7jTE8KEkc+LJWQwJ3EY0qjeiWnE20Zk3l1a+GV8aJb5DkugVI4n/ijLtI97Tw
         ACRQMuYHnTSdmmeGD89BP/Jyq3ngdJzsnp82NB/2lbR7mmC9jTPxxWPZ1wQh/Lv5OWfn
         FyOAUsWAeP9HLRFfKHz4JLukg8j8ZErg8eTgr3nFHup2CIWYHgQ3c4DpyFFrzyK7IT0j
         1i0icYV5Gy9/uwJN16ujjXEbdGzkRunwnzQDbymEjnnQkHU/XIXjjYBU3E6bntj8uA13
         /qLcAfH6eXjYJMUtSy8nsz1Db8om5HBZBzlvTcIGyoIbEBOHT138Zfwbl+88UfTiqSOE
         DQbg==
X-Forwarded-Encrypted: i=1; AJvYcCUkjvH4xkSXg+qB1LfaiBeVEYTAuge3qRX9wDiBtm59ClNLhZiPBhXlufq/ZdFa4J/hD21LvZXw3g==@kvack.org
X-Gm-Message-State: AOJu0YxcfKGNxCtMnM/EHYev4Uf90Axm6wBCtO56bN3KNiab8W6yt7Rs
	s6gfRMU1xtV3+ePIwGw7lnFtMNAFDwYcthfoIPrWhmDTe1c9BZLp2fz5gQjoyfHeBij2rFRqFHa
	w8MjzMgtOzCLdxNfPqZvG30DGYSWrshlopATgEaXYOJbkRrfKtm+j
X-Gm-Gg: ASbGncvYyO/05vTCHIhd7WdhoqW/hYzqqKw7tThCC6Lxq+vJD1NdFqeDNUrS/DFzP9S
	qq6DVZRaY+xu35IvFPrE6F4j4rsbL4o+nSfjsSgK0Oqt4AjeIugyRwhZaDjNh57HGQFHr8RVf0h
	E1SLWB532lN19iBzIqHYEVZUuKEc5vCi7p8FkhcDSl+ZxRfjzfCknK37TTzI2gJ3HsoNotGbbwi
	1PQkctDcVAU2kFPRnKQ9LrjPhGTVAZFvi7Rpm6sbJZU+DtQURyHlRg8WGOsEHBQWlr6DewkJ4kf
	ZsomhIrbZD2GyqPW9kJBlpjyNJaWWUWR
X-Received: by 2002:a05:620a:a1d5:20b0:7f3:c6ab:e836 with SMTP id af79cd13be357-82b9c840587mr328402685a.18.1758052542991;
        Tue, 16 Sep 2025 12:55:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXCQVo06N/gkUqltuP4pDESRP+ZzHDPZ/4dTJPxZGrBFajWf3gdDStG1/Z5hNR6CAGkrK8Gg==
X-Received: by 2002:a05:620a:a1d5:20b0:7f3:c6ab:e836 with SMTP id af79cd13be357-82b9c840587mr328399085a.18.1758052542407;
        Tue, 16 Sep 2025 12:55:42 -0700 (PDT)
Received: from x1.local ([174.89.135.121])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-82aeb24fcebsm269020385a.56.2025.09.16.12.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 12:55:41 -0700 (PDT)
Date: Tue, 16 Sep 2025 15:55:29 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
	Muchun Song <muchun.song@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aMnAscxj_h42wOAC@x1.local>
References: <aaaca9d4-b8df-45b8-a3a4-a431c99f26c7@lucifer.local>
 <CAJuCfpHN6vpDx+UNPEzJgZ_qD9USTJZ_+yZzQg2BpF_aRpufYw@mail.gmail.com>
 <982f4f94-f0bf-45dd-9003-081b76e57027@lucifer.local>
 <cda7c46b-c474-48f4-b703-e2f988470f3b@amazon.com>
 <aGVu1Isy-R9RszxW@kernel.org>
 <aGWMsfbayEco0j4R@x1.local>
 <aGbCbW7hUf3a2do2@kernel.org>
 <289eede1-d47d-49a2-b9b6-ff8050d84893@redhat.com>
 <aGfsaIIzHWfjcNFd@x1.local>
 <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
MIME-Version: 1.0
In-Reply-To: <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9FtMVluCPJI0hJuaQ0CYw2wlllvOnoEOrz7WGY8ZPMU_1758052543
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: tfnkr9st5gr5fpq1afmd1ey6ey6ajxxf
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FB134000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1758052547-713197
X-HE-Meta: U2FsdGVkX1+5hTvTPQhAi899Y7pQxJUd3oOhpeef/IEsLAfK0F1ozZg+A+FSUTZ4Wad/SULSFUlrdffsHut/4w001zoTdgIiH3rdXbHs0sGfWIc1PigAMFmBvND8Vqqa59vplDaYnZ+cD75D73G5M6z2PFpIIxCJpQR3QW4XFEjRtdvVHTnoc6yVfy5Sy/4ZqO1Kk/FjSObpOK6J4VLDI7yXhc2DNn9Tj9mBuKKrGNnvHQQsfUUrsvv5GE3PDQ27BWNehGOhw3zggesGN0UnVnJcn81dfhXRpbQoKa3iRyxx7iU6ww6XBTYZBVDWBOBm73NjykvprwNQNxUiPOU6Nukzm096irCyrdwsici9w7AejUBp6XsjMZGPeHZZvbFkiX3QGvtds2th6OiPdsUKAX9pAAmd3fx+XYRIo9FOTD7BILBVTZrnaY7bkxsibLzy9/uTFEfZbkMWHApFuEs5RZPN/+hTMD9Kfo0hcb5+qjc/Pm0bJn7AifWz+bQORx74fZp52aVSFfoXOCA2O87GVRQZP3IBpaztQhyW8eG7vAGdA9s+6Qeli0bmjmYai9pwOweG2jOrDaCTHpUIbPnCHP5mcl65VRpJv6S3v5beIDE0y8xO8M9zUznSsgg2h+U9vkrZpc2hDFm7Ura3DiYVfE8r7UyRnLIjZPDcPWPdgqX+cMl+JGHYkMgUPqItyKiEPDYaxFxviOmU5D7SK6+ee3/qu3P6TC6Fd6KyAumPfnBLM3easTfO5iAJ3vfCGSyH8rTXyJr6B8qWG/FQIaq+jsLUilo1MpYumCCBk1/G+9QODGKG6Fl5YyYzPX5uzLAGOSBA7bOWUvrCGG+PbOmPmDTYPW0BaiXL2IF/+1T3FhulS1c4wAQjsk3U2jvwqfYn8QcjBzjaFm7WEdJt+ueKsTdom1wTbmpBO9Uei8X+/lMtIlb7NVKSqL+XsSIqASktGNeHwqx2Guv12OAUugB
 swkgTCX5
 zruoviAhzCfDIdfEttgEWtkzan5SkL8IPtKWPI6LrBcyL6Rc6HmqjwJN4ehfYmAqjPpYR4fzz9R6kDnEa+yhxnUgBp8RPVM+0B+i6RhLgHKg21UEMiZihU4zUH3qxXItMo/bPaBcfrRJz5ok/WPPFOjDHBfq550XAXz1JCXgG0RzOysHijm93CBCZHT5xmFdCQ1xuCzi/Fz9fFEX0gjOhF3SRlxd1kj5KmWbNuj+WalrbF8NmYwnHkfGV3gwIB2kYeWl1jOfbugFXz/XTyfvKQ++z2KlJtLi3A0HbAzhRLNDy2fTAAFXKLFat2d+NAO0fqVnBluhRqpdEO2L8N+29Pe+v74334hYDx7xvo+tHTl0l5NdzyAL0BoAiSEzwEXJvHalIFq1LvDsIJ3cNGo3k9gUM2vgqsOJ/d8z4//0QwkTj2kf1nJ+6D4uu6mEUgx3nDj+UM2YqlxUDEpeqXDR9hErqlWh0DRwTNoI7HVVgo9EavooGBm5u5ydr+4WzCkbqJqLkGnB9UW6pxEPDM0KnGDbZhhZzqRrdI6Bfwnk3nMfC9SliDQJOWxjRMtfPb+ycg0EyzFEq5gFqrzYntyJ2XS4VHtqEFKFZxERCacBTeh+CQhUztmFI/fdiKyoUr0OyOBHJT4Ayhqfq+Z95t31SPoemg6jrKVdcaO0k1jNuzPAn6mSGU2cXczYxZCi119Dhkb8nz/XktiXd9U5BnkeDsmoikA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 04, 2025 at 03:39:32PM -0400, Liam R. Howlett wrote:
> * Peter Xu <peterx@redhat.com> [250704 11:00]:
> > On Fri, Jul 04, 2025 at 11:34:15AM +0200, David Hildenbrand wrote:
> > > On 03.07.25 19:48, Mike Rapoport wrote:
> > > > On Wed, Jul 02, 2025 at 03:46:57PM -0400, Peter Xu wrote:
> > > > > On Wed, Jul 02, 2025 at 08:39:32PM +0300, Mike Rapoport wrote:
> > > > > 
> > > > > [...]
> > > > > 
> > > > > > > The main target of this change is the implementation of UFFD for
> > > > > > > KVM/guest_memfd (examples: [1], [2]) to avoid bringing KVM-specific code
> > > > > > > into the mm codebase.  We usually mean KVM by the "drivers" in this context,
> > > > > > > and it is already somewhat "knowledgeable" of the mm.  I don't think there
> > > > > > > are existing use cases for other drivers to implement this at the moment.
> > > > > > > 
> > > > > > > Although I can't see new exports in this series, there is now a way to limit
> > > > > > > exports to particular modules [3].  Would it help if we only do it for KVM
> > > > > > > initially (if/when actually needed)?
> > > > > > 
> > > > > > There were talks about pulling out guest_memfd core into mm, but I don't
> > > > > > remember patches about it. If parts of guest_memfd were already in mm/ that
> > > > > > would make easier to export uffd ops to it.
> > > > > 
> > > > > Do we have a link to such discussion?  I'm also curious whether that idea
> > > > > was acknowledged by KVM maintainers.
> > > > 
> > > > AFAIR it was discussed at one of David's guest_memfd calls
> > > 
> > > While it was discussed in the call a couple of times in different context
> > > (guest_memfd as a library / guest_memfd shim), I think we already discussed
> > > it back at LPC last year.
> > > 
> > > One of the main reasons for doing that is supporting guest_memfd in other
> > > hypervisors -- the gunyah hypervisor in the kernel wants to make use of it
> > > as well.
> > 
> > I see, thanks for the info. I found the series, it's here:
> > 
> > https://lore.kernel.org/all/20241113-guestmem-library-v3-0-71fdee85676b@quicinc.com/
> > 
> > Here, the question is whether do we still want to keep explicit calls to
> > shmem, hugetlbfs and in the future, guest-memfd.  The library-ize of
> > guest-memfd doesn't change a huge lot on answering this question, IIUC.
> 
> Can you explore moving hugetlb_mfill_atomic_pte and
> shmem_mfill_atomic_pte into mm/userfaultfd.c and generalizing them to
> use the same code?
> 
> That is, split the similar blocks into functions and reduce duplication.
> 
> These are under the UFFD config option and are pretty similar.  This
> will also limit the bleeding of mfill_atomic_mode out of uffd.

These are different problems to solve.

I did propose a refactoring of hugetlbfs in general years ago.  I didn't
finish that.  It's not only because it's a huge amount of work that almost
nobody likes to review (even if everybody likes to see landing), also that
since we decided to not add more complexity into hugetlbfs code like HGM
there's also less point on refactoring.

I hope we can be on the same page to understand the problem we want to
solve here.  The problem is we want to support userfaultfd on guest-memfd.
Your suggestion could be helpful, but IMHO it's orthogonal to the current
problem.  It's also not a dependency.  If it is, you should see code
duplications introduced in this series, which might not be needed after a
cleanup.  It's not like that.

This series simply resolves a totally different problem.  The order on
solving this problem or cleaning things elsewhere (or we decide to not do
it at all) are not deterministic, IMHO.

> 
> 
> 
> If you look at what the code does in userfaultfd.c, you can see that
> some refactoring is necessary for other reasons:
> 
> mfill_atomic() calls mfill_atomic_hugetlb(), or it enters a while
> (src_addr < src_start + len) to call mfill_atomic_pte().. which might
> call shmem_mfill_atomic_pte() in mm/shmem.c
> 
> mfill_atomic_hugetlb() calls, in a while (src_addr < src_start + len)
> loop and calls hugetlb_mfill_atomic_pte() in mm/hugetlb.c

Again, IMHO this still falls into hugetlbfs refactoring category.  I would
sincerely request that we put that as a separate topic to discuss, because
it's huge and community resources are limited on both developments and
reviews.

Shmem is already almost sharing code with anonymous, after all these two
memory types are the only ones that support userfaultfd besides hugetlbfs.

> 
> The shmem call already depends on the vma flags.. which it still does in
> your patch 4 here.  So you've replaced this:
> 
> if (!(dst_vma->vm_flags & VM_SHARED)) {
> ...
> } else {
>         shmem_mfill_atomic_pte()
> }
> 
> With...
> 
> if (!(dst_vma->vm_flags & VM_SHARED)) {
> ...
> } else {
> ...
>         uffd_ops->uffd_copy()
> }

I'm not 100% sure I get this comment.  It's intentional to depend on vma
flags here for shmem.  See Andrea's commit:

commit 5b51072e97d587186c2f5390c8c9c1fb7e179505
Author: Andrea Arcangeli <aarcange@redhat.com>
Date:   Fri Nov 30 14:09:28 2018 -0800

    userfaultfd: shmem: allocate anonymous memory for MAP_PRIVATE shmem

Are you suggesting we should merge it somehow?  I'd appreciate some
concrete example here if so.

> 
> So, really, what needs to happen first is userfaultfd needs to be
> sorted.
> 
> There's no point of creating a vm_ops_uffd if it will just serve as
> replacing the call locations of the functions like this, as it has done
> nothing to simplify the logic.

I had a vague feeling that you may not have understood the goal of this
series.  I thought we were on the same page there.  It could be partly my
fault if that's not obvious, I can try to be more explicit in the cover
letter next if I'm going to repost.

Please consider supporting guest-memfd as the goal, vm_ops_uffd is to allow
all changes to happen in guest-memfd.c.  Without it, it can't happen.
That's the whole point so far.

> 
> > However if we want to generalize userfaultfd capability for a type of
> > memory, we will still need something like the vm_uffd_ops hook to report
> > such information.  It means drivers can still overwrite these, with/without
> > an exported mfill_atomic_install_pte() functions.  I'm not sure whether
> > that eases the concern.
> 
> If we work through the duplication and reduction where possible, the
> path forward may be easier to see.
> 
> > 
> > So to me, generalizing the mem type looks helpful with/without moving
> > guest-memfd under mm/.
> 
> Yes, it should decrease the duplication across hugetlb.c and shmem.c,
> but I think that userfaultfd is the place to start.
> 
> > 
> > We do have the option to keep hard-code guest-memfd like shmem or
> > hugetlbfs. This is still "doable", but this likely means guest-memfd
> > support for userfaultfd needs to be done after that work.  I did quickly
> > check the status of gunyah hypervisor [1,2,3], I found that all of the
> > efforts are not yet continued in 2025.  The hypervisor last update was Jan
> > 2024 with a batch push [1].
> > 
> > I still prefer generalizing uffd capabilities using the ops.  That makes
> > guest-memfd support on MINOR not be blocked and it should be able to be
> > done concurrently v.s. guest-memfd library.  If guest-memfd library idea
> > didn't move on, it's non-issue either.
> > 
> > I've considered dropping uffd_copy() and MISSING support for vm_uffd_ops if
> > I'm going to repost - that looks like the only thing that people are
> > against with, even though that is not my preference, as that'll make the
> > API half-broken on its own.
> 
> The generalisation you did does not generalize much, as I pointed out
> above, and so it seems less impactful than it could be.
> 
> These patches also do not explore what this means for guest_memfd.  So
> it is not clear that the expected behaviour will serve the need.
> 
> You sent a link to an example user.  Can you please keep this work
> together in the patch set so that we know it'll work for your use case
> and allows us an easier way to pull down this work so we can examine it.
> 
> Alternatively, you can reduce and combine the memory types without
> exposing the changes externally, if they stand on their own.  But I
> don't think anyone is going to accept using a vm_ops change where a
> direct function call could be used.

While I was absent, Nikita sent a version that is based on the library
code.  That uses direct function calls:

https://lore.kernel.org/all/20250915161815.40729-3-kalyazin@amazon.com/

I think it's great we have the other sample of implementing this.

I believe Nikita has no strong opinion how this will land at last, whatever
way the community prefers.  I prefer this solution I sent.

Do you have a preference, when explicitly there's the other one to compare?

> 
> > Said that, I still prefer this against
> > hard-code and/or use CONFIG_GUESTMEM in userfaultfd code.
> 
> It also does nothing with regards to the CONFIG_USERFAULTFD in other
> areas.  My hope is that you could pull out the common code and make the
> CONFIG_ sections smaller.
> 
> And, by the way, it isn't the fact that we're going to copy something
> (or mfill_atomic it, I guess?) but the fact that we're handing out the
> pointer for something else to do that.  Please handle this manipulation
> in the core mm code without handing out pointers to folios, or page
> tables.

Is "return pointers to folios" also an issue now in the API?  Are you
NACKing uffd_get_folio() API that this series proposed?

> 
> You could do this with the address being passed in and figure out the
> type, or even a function pointer that you specifically pass in an enum
> of the type (I think this is what Lorenzo was suggesting somewhere),
> maybe with multiple flags for actions and fallback (MFILL|ZERO for
> example).

I didn't quickly get it.  I appreciate if there's some more elaborations.

Thanks,

-- 
Peter Xu


