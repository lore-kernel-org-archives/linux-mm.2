Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 509FA106ACDA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 355266B0005; Thu, 12 Mar 2026 15:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 302B36B0088; Thu, 12 Mar 2026 15:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3C96B0089; Thu, 12 Mar 2026 15:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0DC6B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:00:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B162BB90A9
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:00:49 +0000 (UTC)
X-FDA: 84538327818.09.3379F58
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id A518140005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:00:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Hi9a2b2Z;
	spf=pass (imf01.hostedemail.com: domain of 3XQ2zaQYKCJgK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3XQ2zaQYKCJgK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773342047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azrlEIUFQPXd0knJ73Otkr8SjGPNupTIDsw2LzFABvI=;
	b=cKEz2JuuuoqJJZrpCv49Ju8PSLaCP4m5ARqlS253gh9MtiFmWKX8KXPm+0AtWiaE22nPhq
	gFvSRLBBZNQHHpUD3sik4jKwKytnt4eZFXY1aKuwmKHL8bZO+Ed6RBsY6BYsBMYGKSl6pr
	aWuGir+/2/d0+PXYx4oIEHGpi7m+zX4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Hi9a2b2Z;
	spf=pass (imf01.hostedemail.com: domain of 3XQ2zaQYKCJgK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3XQ2zaQYKCJgK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773342047; a=rsa-sha256;
	cv=none;
	b=r7MaHDMOLDaFpKTrzCU0pz7rLbKD1t57zLYjhR5uy6maD8ISvA4PNUhtHNaD/gLumUMx31
	iFjki5Ex9PklprqkqzTLZUFsQ3B9QqGAtpDry23RPTDefdNkhLHCWUfgtwrDkh97MC45Ao
	cyj8yuTAFjCr4VvVGpMNHnF9xtEiPa4=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35a02f3b8e2so5677232a91.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773342046; x=1773946846; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=azrlEIUFQPXd0knJ73Otkr8SjGPNupTIDsw2LzFABvI=;
        b=Hi9a2b2ZFLaQuF07sefDk9vFCTRoNWCxJiAeKo5cHU4q9GnCFsxmOVsFlFEhe4fsdW
         dyTguPLaIP7fS6mBiAgbhQxHKavYIagCkUm6y3k3pONkt1JQYrP/cFZQL5dZhQg7aMSK
         M9nkxsDSDAEWUUoxEq6Xx00rvTI/8alO8O+qhGD4CxgmdplT2S0bldiS1B6XwdiMWsr7
         gsvq7lr5eFwWYd3E0+YW2eTwWxQfqal8ogP/YK1ffhPuOY+JkpeE+7L9sV2ZdBXmHykC
         8WZFXT841fOhB0k/Jl8vyk4RlH4yORt7AWQYdYvxv4A8mkiiaO5qTfOt+XtrC+1Aj3AP
         ycIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773342046; x=1773946846;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=azrlEIUFQPXd0knJ73Otkr8SjGPNupTIDsw2LzFABvI=;
        b=okShN9qE6l1R3p7H6FARGIzwlpeh3+eRCeiF5crVqf3WYf9C23XebGSRZNSB0ruaeG
         ZtijGGK/lUv2RIiIjwSRfCp29PEamVJzUfyoKAxm+n66WSf6txEM1MQK0QbNqw4ePOT2
         JTZoPPAscJdydQRnf+typDUqlkOKKa999vwvyjnzjkQ1DhpeWwDZrHzChLPKYxg52+D8
         MWLIKLr22LJnOP0DNHEv2vMM8lMe6PS6O+mOgcWpNeESGeIsszEQ9QcKjOS1iMO3blYh
         HI5JUqUG66mLPQpaPyRuPN8lN3NoTWyQw2sJCBoD7UrkeZ2W5MOPfWVXTsjb0/MnpHjB
         vG0g==
X-Forwarded-Encrypted: i=1; AJvYcCXI9rTBWI/KTMQyAB0pQ4jMxPBlyJgkVTyENO15QwTAtiMcX+CrO3HRumKSNFTzmtd2PG/EBoM0qA==@kvack.org
X-Gm-Message-State: AOJu0YzgMSRK0xAstCwMu36/SGMUBNglOYWg5dunjjcNCU8mTrZ/LOcp
	uR4+7aqLcRFgX7MkUNdZl384oYIxzftaxCdZICNLUPFnwM2wUm1W0j0WpA24seEv08kOyhJvSoj
	w359VFw==
X-Received: from pjbsy11.prod.google.com ([2002:a17:90b:2d0b:b0:359:8f94:bc6c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b10:b0:356:3ba2:122c
 with SMTP id 98e67ed59e1d1-35a21efa8cdmr623149a91.9.1773342045999; Thu, 12
 Mar 2026 12:00:45 -0700 (PDT)
Date: Thu, 12 Mar 2026 12:00:44 -0700
In-Reply-To: <CAEvNRgH1RAV0rcaUx717JcHryB6=teXYoGtEzZwGwmy3MWwOcw@mail.gmail.com>
Mime-Version: 1.0
References: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
 <20260309-gmem-st-blocks-v3-2-815f03d9653e@google.com> <aa9uiQ_KBcX7X0My@google.com>
 <CAEvNRgH1RAV0rcaUx717JcHryB6=teXYoGtEzZwGwmy3MWwOcw@mail.gmail.com>
Message-ID: <abMNXBQUpFD8W1iM@google.com>
Subject: Re: [PATCH RFC v3 2/4] KVM: guest_memfd: Set release always on
 guest_memfd mappings
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	rientjes@google.com, rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	shivankg@amd.com, michael.roth@amd.com, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	Lisa Wang <wyihan@google.com>, Nikita Kalyazin <kalyazin@amazon.co.uk>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A518140005
X-Stat-Signature: usq9mkhj15ebe6gfh7mw8itebrozc9y1
X-Rspam-User: 
X-HE-Tag: 1773342047-334198
X-HE-Meta: U2FsdGVkX1+lAdG6YEe2rw7s15HmFMy1qCd9lv0AaQPd+Yp7/IJIQHdd9XvpaszEiggSrzxEUIdT8MfyCU1Ms7fJO3zT/3NEib/xdlt2wZYq1xxMWwL9+nUUqUsYICvHooeV+tm8arWaUGss8k05dqr0CPdmgF8BGMogcjUbLA7KgVU0u9CjTHAZGSZ95IfzUGvlBcTpaprKvhidQ5cm2MOJgmgMNIMg/yQb9MO5KdlLs7c5uCSWCOintEtmbnvL5dDRDNMIeyjsY0NOlqnNy8o+t478TNRDDwC21MfsCXRnj+YdsR2KNY3AiI0hpM8Il/vebxn3AmND9T2PVFj97etyChPWpbXRUgBVozFgj/RZbAo4ji2iNfTTvBZotXB1VNJgl4dCUauQgzgskryuaUqi9ngy6/ouy4lPhfncph5njerUS4hrJtvp/UUxuPhphBphFdX/pakJrstVes80hCuuTyy6Jibg0c5crvKPhD7Y8FMgkqfUyLCcPiaFeDgc9/kJKU5MU1146quWgct5bYQCCb34jQzaY0x9xYTgmvuPBXRitIzTbS48yQVP1LArI/pP5ougnwhivo1kUqfIuZ5JbtSvmJsRCI/bx8qdVaMqKjWy/UBwgGJcQGi5jf3ba3QqROtCzVr6AXT31nFZEI2Zi/xM1i8aYjQ6Id634ZSGJbRYUs8beBnmO2tcr+VjtubaEXJ2/1S1mppdI7ooCKgfALFjbzasHCZkyjwqRNlWJYk7iOQIHgnVr/uCEi/H9mRDn2SFqfjkIeDi8IScQ3bZKFZ/hF9fk/wLNLd6yDYs1C/536LVsyFULbq7iBPNTt2XN/NAVIXfGNjscqor5YPamm9R7BG2B/cC8Ov/d+A6gxk5cFKev69h/OPcjv65nWpzJYHa7uBjo2TYbmYF8cGumF1VWEfifD38izs7X3mLv9Adv40NXVWdloDNEcSP36iO4PssqOzBhUIEL8z
 2uWhHajV
 TZJI/cSfzGTziuzAEZ5yVt0S5aqaJ8b97o+hMusqkfRQQjbCYlY7SFmcf2r47QOEqkxHN7ZST4aFoJrV8ujUTSMm+Gn/tGLWkrVsTCp5A4vwV3uvDdprf830T9h62upeFne+IZlrTFqSBkAj2hwJlya2fdw+10jQEMYg4HS1Y/T4F9LunZ6eV23KEODwEMdLBlkS0vQvBsSHlDPP6eNp1CC2dEOj+OMWlGM/fzHK1suP8lhmrxu2R3FavE8v6//UJ/QblNPMzyntbHqwsLTczoo0XBrey1r/uAOdEDGnjiq5GyhHAK5gkhe5TsbdMgL62xZ503++kddBJ4OPibKAQDyCilvNY24jzM3H0izrbJH9g46PvKGxN7m8sCqU13+Z8mF+mIJZhFWAPKGdMeWtFcIvyGXr99nSC//S/t9z+iEAKOsXFpC8LG/ZqmbP57PRiIRS1ZZ6kKXk0yX8Ha+hKiiGjtxcvu1ImTxOgVwVTcSTyy3t1cavg/EKL6IKHZDJZVsd2agiJsuAxjGV5tZMvoLHKbHWEhSFcdWSYMTNNu3tRByq70WLISzqsJU5wyL7PqFMtHvX5BRD7FtKAE6FFo3snvZXzk4C3iViH8RYmq2IP+YOd20qn8jBl6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > On Mon, Mar 09, 2026, Ackerley Tng wrote:
> > But even if that's somehow the "right" behavior, we're doing it purely by
> > accident.
> >
> > As for this patch, if we fix that bug by returning 0, then filemap_release_folio()
> > is definitely reachable by at least one flow, so I think guest_memfd also needs
> > to implement release_folio()?
> >
> 
> Is posix_fadvise() the one flow you're talking about?

No, I'm saying if we fix the memory error case, then filemap_release_folio()
likely becomes reachable.  Though there may be other cases.

> It indeed calls filemap_release_folio() through mapping_try_invalidate()
> -> mapping_evict_folio() -> filemap_release_folio().
> 
> >From Documentation/filesystems/locking.rst:
> 
>   ->release_folio() is called when the MM wants to make a change to the
>   folio that would invalidate the filesystem's private data.  For example,
>   it may be about to be removed from the address_space or split.  The folio
>   is locked and not under writeback.  It may be dirty.  The gfp parameter
>   is not usually used for allocation, but rather to indicate what the
>   filesystem may do to attempt to free the private data.  The filesystem may
>   return false to indicate that the folio's private data cannot be freed.
>   If it returns true, it should have already removed the private data from
>   the folio.  If a filesystem does not provide a ->release_folio method,
>   the pagecache will assume that private data is buffer_heads and call
>   try_to_free_buffers().
> 
> I could implement .release_folio().
> 
> Returning false seems like the easier solution, and is kind of in line
> with the documentation above. A guest_memfd folio does not have private
> data, so without private data, the private data cannot be freed.

Eh, not really, If there's no private data, then freeing it always succeeds.

> (Took me a while to notice that having private data is not the same
> as having something in folio->private, so this doesn't change even after
> the direct map removal series lands.)
> 
> Returning false is going to break shrink_folio_list(), but that probably
> won't affect guest_memfd for now.

Definitely not a problem, I'm very against putting guest_memfd pages on the
kernel's standard LRU lists.

> Returning false also breaks page_cache_pipe_buf_try_steal(). Does anyone
> more familiar with splicing know if that could affect guest_memfd?

AFAICT, also not a problem until KVM supports .splice_read().

> Returning true could also work, to indicate that the folio's private
> data has been "removed". I'd also have to do inode_sub_bytes() in
> .release_folio() then, since in mapping_evict_folio(), remove_mapping()
> doesn't call .invalidate_folio().
> 
> Then we will have to separately ensure that in truncate_error_folio(),
> guest_memfd doesn't double-deduct the folio's size from the inode. This
> should be semantically correct though, since IIUC .invalidate_folio() is
> when a folio is removed (clean or dirty), but .release_folio() is only
> for clean folios. If .error_remove_folio() returns MF_DELAYED, the
> truncation didn't happen and so there should be no call to
> .release_folio().

Before we dive deep into solutions, what's the motivation for making fstat() work?
As I asked in the cover letter:

  P.S. In future versions, please explain _why_ you want to add fstat() support,
  i.e. why you want to account allocated bytes/folios.  For folks like me that do
  very little userspace programming, and even less filesystems work, fstat() not
  working means nothing.  Even if the answer is "because literally every other FS
  in Linux works".

