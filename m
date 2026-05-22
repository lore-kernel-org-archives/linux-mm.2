Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35734CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 12:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D17B6B0093; Fri, 22 May 2026 08:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482CC6B0095; Fri, 22 May 2026 08:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3721C6B0096; Fri, 22 May 2026 08:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2526F6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:37:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C510891956
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:37:57 +0000 (UTC)
X-FDA: 84795007794.20.BFA351C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B060E4000E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:37:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WJA7Ko6M;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779453475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oiJv/a8IQvKH3BGEIllrwFReWEQqkFFSGDh6mgtKt0s=;
	b=wt/FfmTHINESeDGwN4lqeVnrTpKOw6bF6txC4cmOrVsql66P9Lslr4zPe14WLnZRNd6TX9
	2hEJhdPuU8Xro6VQqJ3PHG/TEzN5OvIg5i8yzRy2vUWkwGsxN7v3FkOPKxC6IpR00hx2YN
	cgG1a4rzsi14K4VDPdR8cEOJRvoNkgU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WJA7Ko6M;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779453475; a=rsa-sha256;
	cv=none;
	b=PnAdIjZUiWKd/dFG10GboU6JnSiJzSjQZBr6cuNGy02crDGdNBtlOR7vZE9Cj0cPQk93xm
	wC8TvSk2rvUTw7AQqqPbt1QloFhuoJgoqMOqmoGswyC0tEoQaMRJaJcwcTEUNtnvEQnEoR
	sUH0bqm+X1/Z2mkibM/qcC8nUfi0S18=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2C0F43BA9;
	Fri, 22 May 2026 12:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FAD1F00A3D;
	Fri, 22 May 2026 12:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779453474;
	bh=oiJv/a8IQvKH3BGEIllrwFReWEQqkFFSGDh6mgtKt0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WJA7Ko6MEnn/NoFQ65dN1/M8ZExiJ8RoGFC656Dd+5KAHsEI9+U9A6OZLTONMFbsw
	 tIcZw2dbzydgoAb2nNDFzgAnIa9WHQL5usPWgbDf7hjEdGHPcoMKBeFoEirX5A8pmJ
	 ++dqGyVU3992xYuBmJbB3lUCrzfbX3bv3mkb2QxRAVM8D+a6eIp4cSjeD1LYSFLVbt
	 7Uc9z8L9JX2JVczmO8z4BsgP9yfQISz6JGBbf8QnqX41pbtp5WwAfQJI5qDHSGy7ql
	 Vs2g5fwJx5y42SZbgMFgjrI+t04zWsIc670pSnjHrsiQNuvYtirMevCR5OFH2pzEcC
	 S6U+pyJ7WJDJA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3CE66F40089;
	Fri, 22 May 2026 08:37:53 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 22 May 2026 08:37:53 -0400
X-ME-Sender: <xms:IU4QaphcTgCOcXPDNUt_nU2yvQjDK1DSI5aLupDUWdyiUIP4dQU-4A>
    <xme:IU4QarqHY9EXT-cMd_Yb4B8Z6Vfh07DrBKfo76qpyv_lguSTG4xL0TwSiGFRTwUSW
    a6_wpWSM2V9fUugVLQiNr5mJzi1JGNfIva61MQGnPywtXp6IFeIn_uH>
X-ME-Received: <xmr:IU4QauqrQFYvgB7RUMJQ9bvgzYGn68sFNbAuV1EfSfCLLEk3QTrEMLpE6fbjhA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduhedtudelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtugfgjgesthekre
    dttddtjeenucfhrhhomhepmfhirhihlhcuufhhuhhtshgvmhgruhcuoehkrghssehkvghr
    nhgvlhdrohhrgheqnecuggftrfgrthhtvghrnhepiefgvddtkeevjefhhedtudeuueeike
    ejkedvgffgtdekgeeiveejvdegtedvhefgnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghrsh
    honhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvghr
    nhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepgeeipd
    hmohguvgepshhmthhpohhuthdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprh
    gtphhtthhopehpvghtvghrgiesrhgvughhrghtrdgtohhmpdhrtghpthhtohepuggrvhhi
    ugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrdhorhhgpd
    hrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopehvsggr
    sghkrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhirghmrdhhohiflhgvthhtse
    horhgrtghlvgdrtghomhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:IU4Qah6CkvLPQpsYe3YHk8keE6O6mSJBIUzG29b5c9n-vbt1f0DrUQ>
    <xmx:IU4Qal2qPAW53qP3BFrBIcKEsvbumY4Ft0Fv0lpYzmEbtWoFHk0z9Q>
    <xmx:IU4QatkzZzFw_sbV_Vq6K-aF99ZCGWjQNWu0Wmkva9773VHZfhqIsw>
    <xmx:IU4QauiXqnAnp1CnDIsvgg4CDgPdcglFJ35pWva-S2styYPJYqXDLQ>
    <xmx:IU4Qak0wVrxnos-gIhB6hx6oacQXSfR35IiG2bd6-lIRpSHDEvwgQrKj>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 08:37:52 -0400 (EDT)
Date: Fri, 22 May 2026 13:37:51 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org, 
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com, 
	ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com, 
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, sj@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 14/14] Documentation/userfaultfd: document RWP working
 set tracking
Message-ID: <ahBMtyua-5v8GyxS@thinkstation>
References: <cover.1778254670.git.kas@kernel.org>
 <0b6f87fd4809245f9eebee73f34e2fb14230330c.1778254670.git.kas@kernel.org>
 <agQZiTUQNviaGIim@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <agQZiTUQNviaGIim@kernel.org>
X-Rspamd-Queue-Id: B060E4000E
X-Stat-Signature: cc96gdath86pkwgccoudfzhyowiubpz7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779453475-398147
X-HE-Meta: U2FsdGVkX195sR2kFvUcAGwBKun7bVc48apuiFjj1I9ULgKnINiHBMP5OE53AxvTIE2bAVxpG7ZSEdAetiMoW1KbWttEE3GVpMoRLMBklzqXrmp4HN0rVCis0yZkqWbDlsIIAlyMEFUy0qvDkezdrgaKp8qJ3gjdYDnAqPRXjwhZI6DnZDhxcofRkrikCJw6Rg0BxCpn5FGzFeyNRMqYCBBlhEj1tnyhXVKnYBvA1QE4g1NO4+5Ass7m/Y6/S7tJs1puex1nWcy1uSOCiZt8NHykVBXGOB52FnM2R4edr6pqQeUOzaYypk+XFW/BGX1m4uH/MV2gfFJjXTUlhEmaLJ+ISXwchTVeqlX6omYuW5ItQH/fwJvjYEDWFIaqDONCFYRvUA2F0KrPj2VmyImEypJ8OzZm+HMaLwsuPSMfdJG6GR0I48Njt8Lq+T66C95C7tZTNNPQkq6FNGsAkAX1PrbtbT17SxdcP4CcdAmHOOcFuiNeZuMecJRXkndfZMlP9gFNSQeitGNspjZkfDjBeD7hFoq/pSmGAwYfkoxoriTBDQ+QhEXRcrTCl1cH+hqvefIJ8tRdiv1bBmIh3ouX4QfpQLx+acq3E8QgLp8vo6D+ZxIQoBg8Oz7wniwgJTUZ6QnOVQp8DngitrM1s6t5HAiqHXX3ce9qW9tJCM8ILTe5V3oVKoDLXBlQQHNpJU4gh3FTYE4xiTe+iZ0eIkq0nnTLoyGSMEeDb4yFkcvMC4jzjIluLT1Uu5k6W38CxjjIkkvQXUoneJtbrRUfF7u+ZyWejRqMlZx0odDqE+m5RYzNPfJic1rmxrQaMhBzm2rhg6tER4gt3JmCQkjZ5lmvyKxz+REY9jD1U3PU0pYBlcJ8hdnhqYSsWuXlqD+CZgBJtU+AMizraV4UmTwt+XhXFlHuRDKGHp59iWKQ0uOGW1TxzdkegPk90wuwjQzYlnZ6HC3RciKQM6tp9bgzH6A
 NaXg55Zo
 tTMtZZmNuV4Y48LmcaxTBd9RIGpxNcFeE9eN4enPCqKxEjExBaWrEwzFhrc4xXl6sanjY4x4Z7EI7+T66Wol7WQnAvaQ04T2ybtO4cyuTpQNdWo0v4dQX2vARgOTAWUCV0Zq/mX5EOHYy7QPgbhCOfgyyc3jMjWVChUdb/KKs9s/OzKTJiquwsQ0NfrvggoAHDtXlhZ4KzNOhKEc8NPutwx2DlXuOdRJgxQ+pvbN40zTN4ISYVTqD77c18Oym8QMb5dEN8iiYzMf7LwbS8ov6eQRciq8t8BbSVZ8ZF7mJQ7VrTahSk9Y1bv5BkHyf4kaps3SL/N/xUM3w1aY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:26:17AM +0300, Mike Rapoport wrote:
> On Fri, May 08, 2026 at 04:55:26PM +0100, Kiryl Shutsemau (Meta) wrote:
> > Add an admin-guide section covering UFFDIO_REGISTER_MODE_RWP:
> > 
> >   - sync and async fault models;
> >   - UFFDIO_RWPROTECT semantics;
> >   - UFFD_FEATURE_RWP_ASYNC;
> >   - UFFDIO_SET_MODE runtime mode flips.
> > 
> > It also covers typical VMM working-set-tracking workflow from detection
> > loop through sync-mode eviction and back to async.
> 
> We'd also need man page update at some point :)

Will add a patch for man-pages in v3.

> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Assisted-by: Claude:claude-opus-4-6
> > ---
> >  Documentation/admin-guide/mm/userfaultfd.rst | 226 ++++++++++++++++++-
> >  1 file changed, 220 insertions(+), 6 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/mm/userfaultfd.rst b/Documentation/admin-guide/mm/userfaultfd.rst
> > index 1e533639fd50..5ac4ae3dff1b 100644
> > --- a/Documentation/admin-guide/mm/userfaultfd.rst
> > +++ b/Documentation/admin-guide/mm/userfaultfd.rst
> > @@ -275,16 +275,16 @@ tracking and it can be different in a few ways:
> >    - Dirty information will not get lost if the pte was zapped due to
> >      various reasons (e.g. during split of a shmem transparent huge page).
> >  
> > -  - Due to a reverted meaning of soft-dirty (page clean when uffd-wp bit
> > -    set; dirty when uffd-wp bit cleared), it has different semantics on
> > -    some of the memory operations.  For example: ``MADV_DONTNEED`` on
> > +  - Due to a reverted meaning of soft-dirty (page clean when the uffd bit
> > +    is set; dirty when the uffd bit is cleared), it has different semantics
> > +    on some of the memory operations.  For example: ``MADV_DONTNEED`` on
> >      anonymous (or ``MADV_REMOVE`` on a file mapping) will be treated as
> > -    dirtying of memory by dropping uffd-wp bit during the procedure.
> > +    dirtying of memory by dropping the uffd bit during the procedure.
> >  
> >  The user app can collect the "written/dirty" status by looking up the
> > -uffd-wp bit for the pages being interested in /proc/pagemap.
> > +uffd bit for the pages being interested in /proc/pagemap.
> >  
> > -The page will not be under track of uffd-wp async mode until the page is
> > +The page will not be under track of userfaultfd-wp async mode until the page is
> >  explicitly write-protected by ``ioctl(UFFDIO_WRITEPROTECT)`` with the mode
> >  flag ``UFFDIO_WRITEPROTECT_MODE_WP`` set.  Trying to resolve a page fault
> >  that was tracked by async mode userfaultfd-wp is invalid.
> > @@ -307,6 +307,220 @@ transparent to the guest, we want that same address range to act as if it was
> >  still poisoned, even though it's on a new physical host which ostensibly
> >  doesn't have a memory error in the exact same spot.
> >  
> > +Read-Write Protection
> > +---------------------
> > +
> > +``UFFDIO_REGISTER_MODE_RWP`` enables read-write protection tracking on a
> > +memory range. It is similar to (but faster than) ``mprotect(PROT_NONE)``
> > +combined with a signal handler; unlike ``mprotect(PROT_NONE)``, RWP only
> > +traps accesses to *present* PTEs, so accesses to unpopulated addresses in a
> > +protected range fall through to the normal missing-page path. It uses the
> > +PROT_NONE hinting mechanism (same as NUMA balancing) to make pages
> > +inaccessible while keeping them resident in memory. Works on anonymous,
> > +shmem, and hugetlbfs memory.
> > +
> > +This is designed for VM memory managers that need to track the working set
> 
> This feature? Or RWP mode?

RWP.

> > +of guest memory for cold page eviction to tiered or remote storage.
> > +
> > +**Setup:**
> > +
> > +1. Open a userfaultfd and enable ``UFFD_FEATURE_RWP`` via ``UFFDIO_API``.
> > +   Optionally request ``UFFD_FEATURE_RWP_ASYNC`` as well — it requires
> > +   ``UFFD_FEATURE_RWP`` to be set in the same ``UFFDIO_API`` call.
> > +
> > +2. Register the guest memory range with ``UFFDIO_REGISTER_MODE_RWP``
> > +   (and ``UFFDIO_REGISTER_MODE_MISSING`` if evicted pages will need to be
> > +   fetched back from storage).
> > +
> > +**Feature availability:**
> > +
> > +RWP is built on top of two kernel primitives: a spare PTE bit owned by
> > +userfaultfd (``CONFIG_HAVE_ARCH_USERFAULTFD_WP``) and arch support for
> 
> Please spell out architecture.

Ack.

> > +present-but-inaccessible PTEs (``CONFIG_ARCH_HAS_PTE_PROTNONE``). When both
> > +are available on a 64-bit kernel, the build selects
> > +``CONFIG_USERFAULTFD_RWP=y`` and the ``VM_UFFD_RWP`` VMA flag becomes
> > +available.
> > +
> > +``UFFD_FEATURE_RWP`` and ``UFFD_FEATURE_RWP_ASYNC`` are masked out of the
> > +features returned by ``UFFDIO_API`` when the running kernel or architecture
> > +cannot support them — for example 32-bit kernels (where ``VM_UFFD_RWP`` is
> > +unavailable), kernels built without ``CONFIG_USERFAULTFD_RWP``, and
> > +architectures whose ptes cannot carry the uffd bit at runtime (e.g. riscv
> > +without the ``SVRSW60T59B`` extension). ``UFFDIO_API`` does not fail;
> > +unsupported bits are simply absent from ``uffdio_api.features`` on return.
> > +VMMs should inspect the returned ``features`` after ``UFFDIO_API`` and fall
> 
> Lets s/VMM/Callers/.
> Although RWP is designed for VMMs, it's not limited to them and I expect
> other use-cases will be coming along.

Okay.


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

