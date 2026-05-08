Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0833CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 16:55:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C2DC6B01FF; Fri,  8 May 2026 12:55:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44BFC6B0201; Fri,  8 May 2026 12:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33AB16B0202; Fri,  8 May 2026 12:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6986B01FF
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:55:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B53EA140214
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:55:19 +0000 (UTC)
X-FDA: 84744853158.06.AC95CB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D3C47A0007
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:55:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XHfqzmeS;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778259318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YQtlp0u+sG2vviBnH9W6K4oHZICYOV4aRbxMZGpCCxI=;
	b=BjP7hs0ac9Iw2haugxpmk6dOR3hy0qcLws1BWERABSbSpQ5s7gsH0wbLPWMsuCxBJB4NaZ
	ujAEIbnFsZzD53iZisK42Vz8QCYjq98uMPcMCo1F5thrmN490vt1Ty2g2Dlw+HSR90bDrx
	IYc0cTBIJvJKnFUz3v4IX2tlntMdzMk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778259318; a=rsa-sha256;
	cv=none;
	b=jGRnpN+KEmNWGDpiqXM6PwooWGrcUetFL6ilu58pZaWR8EZ0J6Vt2tp5d48VkQenXN1iPO
	j3ZaxhB9b7OUNHuVdw6Kbd5HLE8BIOc1UACbM7VTlXTbRO56pziACzV2omx7s4tEXU+GqN
	Vi+xioUAnxT8jKLcSNqtUG5Au1gsSxE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XHfqzmeS;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2C05403C3;
	Fri,  8 May 2026 16:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486FDC2BCB0;
	Fri,  8 May 2026 16:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778259316;
	bh=YQtlp0u+sG2vviBnH9W6K4oHZICYOV4aRbxMZGpCCxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XHfqzmeSFYwl0UXAEAQkmb2d4Mqu3WMnmnaUT6Z4Sh7ccxkrn4YJaGo4xFX7GDz3s
	 qMCOma3ZrnjlpLXH3y2ZUFudIPKgTgQ6ejBbnLqEL3D2iYFSAufQ9TUR68Q++9Oqxv
	 7aCyB30nI5BJ99pdF6Xgl44z0tT9eXdlfLr7uvEnDFnvmH2DY3BLr1mJDK1apflq8P
	 r34v9wrwlubmrKDpj3hY/J+R+B6FcY4Istk0c6GrLJ0GkQy27tVgdSspVhLxS5efQd
	 w8yy++64zC0Pk65lCh40DvPgtkl/6ycsQ+91kYhDCvhje1XG21r24PEyFdJO65t8Rj
	 eZgrZFIemSoQQ==
Date: Fri, 8 May 2026 17:55:10 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH 1/6] mm: Make per-VMA locks available universally
Message-ID: <af4VPe7_T0AgMEkk@lucifer>
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429181955.0C443845@davehans-spike.ostc.intel.com>
 <a07231f7-c5a1-4de0-8d4a-459d5ecb5676@kernel.org>
 <36346c42-2557-431f-aef5-0f92b0828e76@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36346c42-2557-431f-aef5-0f92b0828e76@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D3C47A0007
X-Stat-Signature: sxmzqxxawoaxqqw9ixgp1c79fsqm4hn1
X-Rspam-User: 
X-HE-Tag: 1778259317-455708
X-HE-Meta: U2FsdGVkX19NNkICogcyUCzvVVcZ3F/ByN9EPGFJkUyDy0YV/ixiV11s8287q012w1p548fGhtN0LSpXzsOk/npODM8P3ykf4f0jZAPpbmToYlwuFNu7nJaZDU3fyu7JhQxxk98T5U6BqGy4vPRsaW5BcgH06wSGEYYfEM+hOW/JI4KovQvJEPlZxT/6+98kgq8N5edQ1QRdxVgDHkFkGAPMhXke81fWkiaqNzy+Z7yV7aLfNRUvnoK5Z9Zv4drZ7/E4Anhk66/UR8wkI2CDZg6g7BJL7S9N/Rf108IiTiMDSLLTJE8vPT40K6pVR0FzoNVnF/GZ5W0KhjefNFkeOuYvAPxUWiX2uPIec/qXxl2zfdyXc1XDHldIUfLR5/WRTq1ghNzW1fXU5pUkaymIYLbCLyiE7CI4fiFcKDL2p8h98SIPHsoCALtB/3IcGZue6oVb4+M2sUyV71YDwomfXKPGG9GnBb0MM+TR42AMUfkHA11lInoxeEVdB3TkRI9iTRWumk/EtVVnDmYb/wEts1TCHS4natQSCMQHwR+Wx+0G+lxOB4Eu+3TXezyYp8Hax+nHC5XC8UKYjTvP0vqLgjwx/ekxd39XeEBzpJtmOIK2sYVU3exiO0yCysB6X5Gji567WDEZgRTE2e5EoXtLmDtNs1UYK6hDIf8JeDWx54EPH0+F+sG83C7iDyvbqXQAg845imP5MWrofxiWNfI3+v5MrYArChEFZTGJ++2mFqSZym08AtJumxyUTqVsPUjI0pMel4gB/F9JDAC58qd0t9eKq4iXSMudJsiToy9LEdAkvbpd5PUOFuTR2UQjb4+GicEV6/LaNxMTqVFW1zPRKEmQSdme7mTQ2/a5sDY2Am1JMUZ9dltJymaon/eq+V7mx9QQ13Ri0cv6dWYPTgPAc1SHngidSkxzN0zqh9U65yaBxNZRirYWQXNuQMeCOTtR7MXUoH/6wsuldJVy/ED
 IhYjJbNx
 d1cyX/nAY0bxTx2AO3kA4o5qlqSySva0Nq5STOvXPlArK3cScCH1AYtQev1ZaVIWnS8S6sHK8gvYqQy2T7kkTFV0sPj1yjrBXucKE586K+nVg8DvGr6iWogK2Yk55u0KxHvrTgxsv7e8gkBNCRwSNIuJKKZQDTWr77U/l7rjHNqq6AJv+xJh6THYGW0yjQ7pYg9lXohLpkrwgJIIAkryqhrk5RBrWAGJtBOEtbN71uWtpf9VCRVJPWQVfPz/LjuTyc6XED/N5VsXq3hbIqBw5oVdukA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 12:58:35PM +0200, David Hildenbrand (Arm) wrote:
> On 5/8/26 12:12, David Hildenbrand (Arm) wrote:
> > On 4/29/26 20:19, Dave Hansen wrote:
> >> From: Dave Hansen <dave.hansen@linux.intel.com>
> >>
> >> The per-VMA locks have been around for several years. They've had some
> >> bugs worked out of them and have seen quite wide use. However, they
> >> are still only available when architectures explicitly enable them.
> >> Remove the conditional compilation around the per-VMA locks, making
> >> them available on all architectures and configs.
> >
> > Yes, we should really just make it now just a fixed part of the kernel design.

Agreed

> >
> >>
> >> The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
> >> when the architecture started using per-VMA locks in the fault
> >> handler. But, contrary to the naming, the Kconfig option does not
> >> really indicate whether the architecture supports per-VMA locks or
> >> not. It is more of a marker for whether the architecture is likely to
> >> benefit from per-VMA locks.
> >>
> >> To me, the most important thing side-effect of universal availability
> >> is letting per-VMA locks be used in SMP=n configs. This lets us use
> >> per-VMA locking in all x86 code without fallbacks.
> >>
> >> Overall, this just generally makes the kernel simpler. Just look at
> >> the diffstat. It also opens the door to users that want to use the
> >> per-VMA locks in common code. Doing *that* can bring additional
> >> simplifications.
> >>
> >> The downside of this is adding some fields to vm_area_struct and
> >> mm_struct.
> >
> > I'd assume most distributions would already enable it.

Yes, and I think any modern system will treat it as a necessity!

> >
> > mm_struct is very likely not a problem.

No not at all that's a lost cause :)) But also less improtant as less
propagated, obviously.

> >
> > On x86-64, the smallest size for vma_area_struct possible (make allnoconfig)
> > seems to be 68bytes. The largest size (make allyesconfig) with lockdep and all
> > that is 256bytes. Without lockdep we are at 192 bytes: independent of per-VMA locks.
> >
> > I'd expect that on most 64bit configs we usually end up with 192 bytes today.
> >
> > Given that our slab sizes are ...32/64/96/128/192/..., I guess we'd have to be
> > lucky to jump between sizes on most configs.
>
> As Vlastimil reminded me, the have separate slab caches, so they are better
> packed. So I don't think a small increase there would really be a problem.

Good to have this information also!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

