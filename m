Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA518606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 23:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=X3AxTvhb
Received: by kanga.kvack.org (Postfix)
	id C48C96B00EF; Thu, 29 Oct 2026 19:16:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD2936B05B1; Thu, 29 Oct 2026 19:16:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE9386B05B2; Thu, 29 Oct 2026 19:16:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79A226B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:16:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E0B1DA806A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:16:35 +0000 (UTC)
X-FDA: 85377225150.17.B0A0331
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 12B0F1C0002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:16:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=X3AxTvhb;
	spf=pass (imf18.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793315794;
	b=kwGXMSbiPQnQvsd2v8DashFAzncLj6gcCt/XJrhScKQSQtvpI6emzKCApp1VrxOFY9rJTd
	zVA2/8NmJiNGOGlxJp18uDVNLOUbKbQahtsUDrHhSvFww7geoeCne4gU9xw3XwidOzK9c8
	KJRxbDeymF0qBjUx2JDqgqdqkOQ5XTA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=X3AxTvhb;
	spf=pass (imf18.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793315794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fmE280TvwYgL1SpHpcTgt7nw3en3MelpBcz6M9OOWk=;
	b=EOnbJRMQ4ugZiNtvZmJNnMy7dogEJXM9oL07IAj4SOO1pA81wUWKH4InZtzdfmxzJv3nut
	uEivs1OKcUDeHoZdNMEEdXWYBzP+Rl4WLrSKDf1t3jPHR916pBtPswDeLbHjq9lQMqJSlS
	nTus+u8ggzOWTIcTev374NCPx2qR4AM=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e9f6a16afcso13335ad.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793315793; x=1793920593; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3fmE280TvwYgL1SpHpcTgt7nw3en3MelpBcz6M9OOWk=;
        b=X3AxTvhb5qG+EtmPzOjjnI8+3MO02mO9hfrcsjQ4p9Bx3q/mTiYtFz5RL7hQa1u8Ll
         p6ADnwJg6lwxn/i3+nXi7PdRewp5bM/pHwFWFzQyhd9t68mYw/IF8+foDsDXBPjJQRO4
         dW5Wus8cxTBmGsZiF7RrY7+DWRCdO9VywEiaGaywZUW2/k7V/Zydfup/WV5Wgk78T/pP
         0IYDdOxm3sWqX+YfCkSLVkFY//A4fc6yOkahOBi5LcMoFY1TkaPwM521zNryOXjgIbN3
         WRq5kG6D90DVXX4ycVOqLnmKn+Me5TyHmXI+eX99T7K+GelB0P0fSGzv9OnjKkUk272I
         npkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793315793; x=1793920593;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3fmE280TvwYgL1SpHpcTgt7nw3en3MelpBcz6M9OOWk=;
        b=GDTPmwYndqdwOVyP5lC5PVaeFK/v95xAnFx/BZrdr3nM51fzPxRegFYyoSHchhAg9f
         jHJhFZxEq7lwyYwb1lN39xMYM3oLystMtXYiL6jFM31grnla/NP3AZqVFBFBOc+uWasM
         aenE955z8hVcIH2paPsVSpBoO+BHx/YNqrlh/cuhnUcm9BghDOzoNGLaIVWw686A2Wn6
         q2rgKrQBe0cPjLCXhXZnPLmDaniEmrgWig811au6flK8uhIVffOIJv4sv0UbXCdlWa0a
         yUeXcOOO7fJ4RHiyIzIICKzaMywJJq2MS4hgTHf8Itgu/heQ2LH6RC3zWT4RjhuyURXC
         ngcQ==
X-Forwarded-Encrypted: i=1; AKwUvBxT6OPfHqj/DDW4IGUGvtFWb53AVRrQL8ivOQYV38FVloEoXoQYUXaz6Q5lSldr8WJVwCJOct4Smw==@kvack.org
X-Gm-Message-State: AFq9FYLLzEdKl3a/EWt4EX35FgtL5EFOZ/kHo9yK15kV81/m0n+c1tCh
	GOOE4NTDHhzY4DEvD3FCFW8+by8FsXozY+bE3ipar5baDGyJNW/Njsoh2qEB/LJh/Q==
X-Gm-Gg: AYBFou0qOXJcganeNfxdgMmOywqIn+ZM5P/rbj9Q0zKHZ3ls4/sPNghOZhEnkLb+7t8
	F0N8FZ+Kq6QZULsV93uRKwM7ETyyyQ743DfWInWIS1sqgBOY4gdySWhf03ZApn9cu3veflfVfmO
	jJjtviXWRikw1nZYNMEkMSCKAPkueeQNUop9d5oolCqN50xKaQrgGlBZPi1d8h9yzRSPxez1CNv
	977E5Zm98+3pkFdp7lMhgh6Cs3KSohxsYOslUrhWM+9S8Xja7dO9feTbg3yWosgLK8qClos1eTl
	otx7cO3L/MJFDVQnhzmn25Xs4XpLZZQRwDrBMQ3WTl9+CrSKjCvd/4kPqPIxFloVkZN8RO834hT
	rISqjNtmMwc2b0iY9F6yQGljwrUnTi0/yMW0QMuChwujHgfPke9NNI1w3P/a6kU2FIFVC0SzKGq
	nlZTqvyJ3YuXtnEoQzgyv20EYBX8Xw7+vqKJaMo1bDqRwYM1btZbaHEGmTJQAyIB4ZZAx4EiHdn
	vnnVhvEr1u+sqVT1amjZfI5O97XqCvLKy+xAS2lygGtj7jZ0y0CCwTAZHmmIUZPLsL7aJkW11fc
	czH9Xrt5GQmt5aPL0B/40fmOasb+55UFKuPYGnjLbX/ER+J+9YXUxzcjyBSQwQl/mwS1b4Of3Vh
	gWESFx/bCU6nHXs+qWOuhug==
X-Received: by 2002:a17:902:d2ce:b0:2eb:188a:1c06 with SMTP id d9443c01a7336-2eb1ec12e12mr7097365ad.9.1793315792099;
        Thu, 29 Oct 2026 16:16:32 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae84542a13sm1362240a91.5.2026.10.29.16.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 16:16:30 -0700 (PDT)
Date: Thu, 29 Oct 2026 23:16:27 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
Message-ID: <auPKfqh_YjRU9Ui3@google.com>
References: <20261026220546.3114241-1-skhawaja@google.com>
 <CALCETrXNEWQNPjtuHnTfVFOafeJ7APXq288Cq16Q5adDNYx9+A@mail.gmail.com>
 <auEksxfAi9lHFXmT@google.com>
 <CALCETrXDY2e8x2kdr-FQvFLs-Y7FwNozXGDvqqM6yvVA7QLV3g@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrXDY2e8x2kdr-FQvFLs-Y7FwNozXGDvqqM6yvVA7QLV3g@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 12B0F1C0002
X-Stat-Signature: qjz33qz5kh66zq67g5qjhbseqsa5kamn
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793315793-997271
X-HE-Meta: U2FsdGVkX192WzLyXASgjqGDThtCYXUKf+6VZSyh081OLVinklh7CsYOOREy8Xv4JPbJbnSQkizU75SmS9YmEjM3i8+SjAh6KCL32E3G2/DB0H8ZukWpuFZcLbatcgA+TxeV9s2RngSdKHnSNTZDI/hrh3FwTaDcLDEV+WXuxGfe2RSgCaA+dV657xiit3SibkGZf39yBo//nie9zaEd5AELjaBt5IKgBi5R++HfhmpxUKSwkxTpgU2A/j/XT2LWFGTKKBuFbH2OAqTOPC+1cv3VgLEJSvBXca84/WwCbnWdOOkNuZUZBveWtuLCU9j3tmOuBATsPIw8Qj5Eojz7WmLP/Vv2uzdtrz7FI/Eg5RlGTyNsSyM64eOGLuoy1RiZ7h3ZiEBtyzuyBsjwXXYDrn+cCwvPIxP7rnx+raxgMLL5A28cS1DJCp5BmTLUV+Lt2tgUOo/S35BrV740u8SBBFxTm9GzcNbBY+e8Aoi/7BcmakeaxxXaDlTZ/GurQH77ofFPVBnJITcu+XeztUAZd++k7EChcoacaKV8yZveoRVimr3zVCzpNoYRzaEbCLBhbp9gO7OhK3nUsBOUNDRsfnPBQQe5fYq26bdBgDAlQWksZYd6hMVRv1MJDN1TLF15Tz3BkHYp77VgXdUo5OxsNpcw8ttdBUoII/F97glk92NwhmQ3fl95O1NoPWasckXwRyzI8CoCyLcIw8VWw2gZGanxf63ShX3f8OJ044cYmrHDmQ9zROBgDfDn2dhKgdvDsLj3oSU8br9x7sgg6YeR3KWNAQP7rOwHTtQqwprb1aqMawcSMJYiwohbs8U8vaAKyWXRhhgbswdB0QGIEB1EnUtr0RGL22DvzDYUGyoUeisjK029/u6bVPHPKNqwnahkyNdy80e6eg9QLqKODtL88i4FOENvNDWYkPJ8tbOnB4q2XYpKsmF3hWxzj1p7h2qCktj6okOySBpszjjyi/E
 w0dDVBqg
 CkluwSeJOLfhWs6fRU1yKhPdkRAWQ8/nwbpyYQATyimOflYUgJXCIn8UplsnRWW+Pn5rBTkbye2L79+rs4GE9ImutPWep3aApZBrETUV2wRb47ZfgL4lRzpQH1jbxtMwyZr0JIbMvpEuhtBCG4QCabxcMSotJO97tux5imw/nUDApEgK1GrC8azfHwEBp43w1s4oEyjem1GGtVAB68X1/V1NzDKjlKHehJLLGZ7sP9WNkEa61J+vgFV3mbgtjuskMqvM0tlZFrMarGjY7wy/Bc4s5d9jzBaOYZLou1LZKd6Uzawm+icTcPsxtlpR0yyG1JH0DDqfUxwXwEunyDcbMqBFWoJxz6sVMGBI4VkvRzt5Ayf8FMNWy+w+PfpWZv8Ap/sTlGayqJGafYcmuK2t1mQrgri0c4IGyKW79Thuj+gMJMU+IXQO4MrSWV9ZtuATKG1P/+vxeHUbECxquMnfnzOTBXs37TTxUvc35SXxACwUJE49JnIk2NrNihX5oOTWIIWFNR+g88JgZ9ZE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 08:57:29PM -0700, Andy Lutomirski wrote:
>On Tue, Oct 27, 2026 at 3:55 PM Samiullah Khawaja <skhawaja@google.com> wrote:
>>
>> On Mon, Oct 26, 2026 at 03:46:34PM -0700, Andy Lutomirski wrote:
>> >On Mon, Oct 26, 2026 at 3:06 PM Samiullah Khawaja <skhawaja@google.com> wrote:
>> >>
>> >> This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that prevents
>> >> holes from being punched into a shmem or hugetlbfs memfd while leaving
>> >> the file fully writable.
>> >>
>> >> Background
>> >> ==========
>> >>
>> >> Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
>> >> memfd_pin_folios() to pin the folios backing a memfd and hand them to a
>> >> device for DMA. Pinning keeps those folios allocated, but it does not
>> >> keep them in the file. If userspace later calls
>> >> fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range,
>> >> the folios are dropped from the page cache while the device continues
>> >> to use them. The pin holder is never notified, and from that point on
>> >> the device and the file silently diverge.
>> >>
>> >> The existing seals only partially address this. F_SEAL_SHRINK prevents
>> >> pages from being dropped by truncation, which is why udmabuf requires
>> >> it. Hole punching, however, is only blocked by F_SEAL_WRITE and
>> >> F_SEAL_FUTURE_WRITE, and both of those also forbid writes. That makes
>> >> them unusable for memory that must stay writable, such as guest RAM or
>> >> DMA buffers, and udmabuf explicitly rejects memfds that carry them.
>> >>
>> >> Proposal
>> >> ========
>> >>
>> >> F_SEAL_PUNCH_HOLE fills this gap. Once it is set,
>> >> fallocate(FALLOC_FL_PUNCH_HOLE) and madvise(MADV_REMOVE) fail with
>> >> -EPERM, while reads, writes and resizing are unaffected. Combined with
>> >> F_SEAL_SHRINK, it guarantees that userspace cannot remove pages from
>> >> the memfd while the memfd remains writable.
>> >
>> >How does this solve the problem?  F_SEAL is about a userspace
>> >contract, and if there are existing users of the APIs in question, it
>> >makes very little sense to start making those users fail because they
>> >haven't taken the appropriate seal.
>>
>> It doesn't change any existing behaviour, nothing starts failing for
>> users that don't set the seal, and drivers wouldn't require it. It's
>> opt-in. Userspace that wants the guarantee seals the memfd, and a
>> kernel user that pins it can check for the seal and rely on the pages
>> staying in the file. For example, the iommufd live update path could
>> skip verifying the pinned pages at preserve time when the seal is
>> present,
>> and do the full check otherwise.
>
>Can you clarify the API you're proposing and the issue?  It seems to
>me like the user is expected to preserve HWPT state by creating a
>memfd, then using some new API to tell the driver to "persist" its
>state into the memfd (possibly by binding its existing state as folios
>into the memfd)?  And userspace is supposed to seal the memfd against
>growing and shrinking but not against writes?
>
>What if the user writes to the file?  What if the user populates
>pages/folios into the file before using it to preserve HWPT?  What if
>the user mmaps the file?
>
>Have I understood this correctly at all?  Why does memfd make sense?
>If the goal is to attach a bunch of pre-existing pages to a file so
>that the page preservation machinery can preserve them, wouldn't it
>make more sense to have a handoverfd mechanism where the kernel can
>make a handoverfd that stores its purpose and logically represents
>some pages but does *not* allow read or write or fallocate or any
>other user operation that actually acts on the data or its memory
>layout?
>

Not quite. Let me elaborate my use case.

For live update we need to preserve HWPT (iommu domain) so the devices
can continue to do DMA during live update. Domains are preserved by
preserving page tables and relevant data structures using KHO.

To make sure that the devices can only DMA to preserved memory, the user
preserves the memfds (into KHO) that are mapped in the preserved hwpts.
During iommufd preservation we need to check that the memory backing the
iommu mappings is preserved. We do this by checking if the mapped memfd
is preserved, but if the memfd had a hole punched into it before its
preservation then the punched pages will not be preserved. For this we
need to do a complete page table walk and test each page separately.

A punch hole seal, before the memfd preservation, allows iommufd to
optimize the validation path and avoid doing full page walks.

The HWPTs are not preserved into memfd; the memfds are mapped into HWPT
and we need to make sure that the mapped memfd has not mutated and the
pages mapped from it are preserved. Also it is ok if the user writes to
the file or mmaps it.

>>
>> https://lore.kernel.org/all/arVYa_90j0oN1hnu@google.com/
>> >
>> >Would it make more sense for the drivers in question to set some flag
>> >(refcount?) on the file to block hole punching?  Or perhaps to have
>> >the hole punch code notice that it's trying to punch out a folio that
>> >is pinned or otherwise referenced and to refuse to do it?
>>
>> The pins already keep the memory alive while it's used for DMA; the
>> problem is only that the page silently stops being part of the file.
>> Refusing to punch pinned folios on every file would change behaviour for
>> existing users: fallocate() would start failing whenever a page is
>> pinned, even briefly by O_DIRECT. A flag set on the file by long-term
>> pinners would avoid the short-term case, but it would still make punches
>> start failing for existing users of those drivers, which is why I went
>> for an opt-in seal.
>
>Wait a moment here.  Given my comments above, I'm not sure this is
>relevant to this patchset, but...
>
>As far as I know, right now, a program can open a file, register some
>of its pages with io_uring or RDMA, and then use io_uring or RDMA to
>write to those pages later.
>
>And another program can open that same file and use fallocate to punch a hole.
>
>And then the first program thinks it's reading into the file, and it
>ends up not reading into the file.  Which makes the hole punch
>operation rather different from the write-zeros operation that it's
>supposed to be a fancy version of.
>
>Now this doesn't sound like a security problem per se, since the
>offending hole-puncher needed write access (admittedly that write
>access is only needed at hole punch time, not in the indefinite future
>when weird behavior happens).  But this whole sequence seems highly
>suspect to me.
>
>Are you *sure* it wouldn't make sense for a GUP'd or similar reference
>(whether pinned or not) to *actually preserve that folio's status as
>part of the file*?  Or maybe for there to be an extra pin bit to do
>this?  Because the current behavior is pretty strange.  And I'm not at
>all convinced that anyone would really object if the kernel prevents
>hole-punching a range with an active GUP, especially if this behavior
>is restricted to writable GUPs.
>
>I admit that truncate seems slightly different in the sense that it
>seems more likely that someone would be annoyed by an inability to
>truncate a file.  But still, truncate does have the same issue.  Maybe
>extending a file could notice that there is still a folio covering the
>newly extended range and stick that back into the file?  Seems messy.

For live update either approach works. If pinned pages cannot be punched
or truncated, iommufd can rely on that directly and the seal is not
needed. I went with an opt-in seal only to avoid changing existing
behaviour. If folks are fine with blocking punch hole and truncate on
pinned pages, I can send patches for that instead.

>
>
>-- 
>Andy Lutomirski
>AMA Capital Management, LLC

Thanks,
Sami

