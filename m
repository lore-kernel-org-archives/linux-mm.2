Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A92606A33B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=De8H26+1
Received: by kanga.kvack.org (Postfix)
	id 35A746B05B5; Thu,  5 Nov 2026 08:04:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3328D6B05BF; Thu,  5 Nov 2026 08:04:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249036B05C0; Thu,  5 Nov 2026 08:04:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 057A06B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:04:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9817C140993
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:04:22 +0000 (UTC)
X-FDA: 85401083964.18.0679C9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8E1DA4000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:04:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=De8H26+1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793883860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VGtXYc1r1fEEKTL7Yj84vITN0MZ0IiuZ0W73SGkuDDY=;
	b=wEGfz9RcVaf/6x2o/qZZ8gLAd90hlHj0Nq1L7Di2Ytw4bK51iPO3vHkaBQ3ztgEabBeevx
	GcFHj852oWZyETDTqiiVNdnsSWV8O2lU2PftQhNusEJWmPU2id/bGChcgQzF8DULkvE3DP
	HhfKwcKpJhTF9XY3W0YITcwM8spHBKo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793883860;
	b=dZ0khfyNks3GdJnUaFx+8xuVH+EpisZ/mjgN8Q5F+QVb/HN1LqMX+H/BPFbztchr7OZ2zW
	00IJgRZrDuTSNQL8subxpQOa6KfyL2LLntU77xBTtnpZ3rsmwYItaXpXqy1X7QzpNhEX5/
	7+zJ6zp+2bho5ui5Uq2Mpvvh2ekjE6E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=De8H26+1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E1DB043AC7;
	Thu,  5 Nov 2026 13:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398FD1F00A02;
	Thu,  5 Nov 2026 13:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883859;
	bh=VGtXYc1r1fEEKTL7Yj84vITN0MZ0IiuZ0W73SGkuDDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=De8H26+1gDbucw54r/u2YPNm1SP4KKNmMksc0qAHccscII4QCkaoyAETI152TklJH
	 Tet+X/3BsKz/dioEysdHlU5cIUnhLGKZ/LNjFXX6PpCp5VGnQqDXnloAn5hkE9PXfR
	 ndeKZGIKuGE+bR5EyoZ/dsUIW2d7Alk8Gyc+NxNVkpz92UKCJLF+zZS8Uk4B1YOCI5
	 P74dJov7LFjIZ4aGZXPmL56kTOvvS51CXVtcIPnwOVNiH2+KXkFq58mThJlA7RH05k
	 pgqy4CV7+y/c0xjcYV4jX7Xd8DQVeMeuB7G7TpdwaVmIPDxUE624m4DafEA25arfyE
	 ZccQTwAMKDXvw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 5580C198003A;
	Thu,  5 Nov 2026 08:04:15 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 05 Nov 2026 08:04:17 -0500
X-ME-Sender: <xms:zn7sagX0bHbqO4A4TRBYez_QTejKPgkzRwAViqmY3Q2vjo9CY_2mzw>
    <xme:zn7sam4INjcHnQFcJfTI6uG9mIag1kAX4vNpX_O9rfCMLv4fmPKeAju4Jcs99CriE
    DQa_mrCnjFsm5GYJWuJFzfMlquu0F1CVwljJtc3OnDCdL6WuZaDTHDc>
X-ME-Received: <xmr:zn7sajHIz1M1ojP4JndE-bnH5Lboc5LvmijY9MxwNCATfeQhkUyt2mKr1Ng>
X-ME-Proxy-Cause: dmFkZTGWioZ5UsUZvGXjaow1BsUGadLs8aZQdTF4UnV/07NAN/af8tN6pM/FfLXYfyZLfb
    xRpT19JopPsgAFGYsm8FzaqvOcRv05DtuUalhGCfVBg5TYHs9JXv+Q47gmOf937P2Gi3S+
    U2sfvRv8HM/m1nYX6eGi2a4miDiVYyQMuuHiidk1Rop6z5ppK7guJf5jvUfTyMXleQeyL+
    YFG9WYCksR8P+f/IoUx4Wo08VB8Mvto3/EHOpPBXbwb98JXOAs0bmRST4eO1cbxBPUkzyb
    YU+NZSxhcSt0KRFVrgpydwZFv0ufeT4P8d+qRyppjSLMzQpNREs19lQwYqTs8BowLu6Nf0
    PR/JbnTjTlqcoe9z9eXCxtppE/iBqN4lxahyvqAWND3wSza41vyy/g8b8tJb119KbVZ8CZ
    MuRhok4swEs4IKe4vdUOtIKHZ5plH23vTgaYw6PfyI344YttADPGpvH6z1snl9sRY/w6tT
    BrCIVHE4Cs5mpSXa/717IOVH1XtBwbuOkBGFH1n9JQAOTVfvpnco/Iz5sDs/mRgagaVrey
    cq6c90syhHHUbEfhX1t/E8+JdiHng3sYYvf5nhsjkohkNfCEDaVAHGUsNyVx8+QglNqqXK
    ulKWha96KxsFQer7kolLJlTQQ/AiVpLrSfhPXbnzPLT0MJ4ciPeh+uKeOiLg
X-ME-Proxy: <xmx:zn7sasRYreFG1B12dgaWNLJaMTnvJum9gmqOKA_t2ZzUrKeUn33c3Q>
    <xmx:zn7saoMA0D4Uv985DwquZetStTw113Ib0q1_tpUBZ9ajeeEzbsBWxQ>
    <xmx:zn7saseZmeGUWPdwDHpB1Rp0nFyftZwCqUaODIf3SBWPBFb_Kb9U9w>
    <xmx:zn7sarVZeG7-wD1HvalF6WI07O4X-rs7VxKwjsOGPZyZuRFNzx6Y1w>
    <xmx:zn7sat-3I3FOwm9xcmy-LlgXxJQcXUcQS1qD5nrBScIbL-4eJN9kZEQj>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 08:04:14 -0500 (EST)
Date: Thu, 5 Nov 2026 13:04:13 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: free unused page table when setting a
 huge PMD fails
Message-ID: <aux-ZdKu97JHLY96@thinkstation>
References: <20261105-khugepaged_set_pmd-v1-1-cb79ab117199@kernel.org>
 <aux9liPvdZgpKCpa@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aux9liPvdZgpKCpa@thinkstation>
X-Stat-Signature: kp15t1bk8coqewpk6cpuagqozdbhyaeh
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8E1DA4000B
X-HE-Tag: 1793883860-770902
X-HE-Meta: U2FsdGVkX1+pxfQX5ZbasRoQc9PJWdq8jHwIZDGRTdVLNJ3ramI3CNnnPsBTP2KS7BnVbPuTpuKUxnEXpDahBIOsB+N2NOmDBRMFRzFo8/vee3phG+hEMBkIBiJFTkGbBj1lLI8Iw1A93EMB5174UbRS/K/D9bkqthJHLi5oUp75vGAR0CP6awbU905ZVjvVGGQig+FxRyCBL3boDHyppW6OdtJvLXZt+qmdwHoMJBWBbrsZ+QZGNgGrRxNDjVws9O8lTWpll1JUIRTkG0XGMH+t5DW4MeV2B1QJQHWHI8yUgIbZ7OLz6ukdnUBDxUuC9HGXD4AeaxCxNsT5/Ef6eN2rN4hLNIMBGsjnKGjcsiUXW9gfBdPOE1KsUV6OWpdNLsjdJUKWYwcV/VUIRXjrQJKnwnH9ucgirhJkhogBAYUDYPsRhdN5oHAKJVAVb1bBQ74l78PvrWZadAEno5tIfrk5ubQT/0FNZe1bNQzG7tDmSKvyBSakuSzOcGhNuLzf3mO7TceFjLe364DQMEUZntt+ea1UEDXOplBzP21Um4St9Kr/Iw8GoTOffCbGsV9zHLgIvSk0N+1JtlGbcA4RRdU6P1DEwBgiGcah9IvMdkn8rrsysAg9vyKvTcEAWa7dl3dSez3gz6hFHauW7gr/2bZPWv+cZRmFWiL2BR0B+zAoS8PpqiEedhDZOQ0o7ux8wewQBr4uBC/d1Vl7JpYG7zqlYxr/HMoqtm0KHwGquK/GpAPmFrjiy/97oPi41yohQoYEljwrhRsw7neHJy7BIHmdOVvk6UAx17+HFs2rjb517rC5jLr+KoGiK811IhOdAfelez27LZDJmjq3+5UocURiAHM8Cv8EslfAAnsWhNwuTuV6luSkix9ZVhWWjv/qP7qYeIhaei7oAs68uTlnqU5oBlqcmLerYBbJLZ9xtjhBPFqBaptOAxVIFaNpP5K0pkik0B4p+aYYYYWHWZ8
 qcF9ljyE
 tb5wCY1xcWfYb68txwbvV4M0pFAUTPOqGqrcDPdKTYcvSCqpmnVeMmYAL7bwm8ZAgLSF6PKwgsZ7qzVf7IEGgqBo3wJsFE9I4AaUzBllXK+PBzyemfguRodOWtcO/r7JPLXle8UkJkuV3AJCzaR6K9D928AcbsDBeNBnb7ztN2WgptVT72x+gLfSoIcdd62/ynoWQ9vEDgvS1XqPF9UUcmJa+McXuEc791UMfCtK3Y/2ba1GHgHMPzjeFyl4dOLDLBMw2UrFh3WqN7UrCvxQL37gn0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 01:02:08PM +0000, Kiryl Shutsemau wrote:
> On Thu, Nov 05, 2026 at 01:16:05PM +0100, David Hildenbrand (Arm) wrote:
> > do_set_pmd() can allocate vmf.prealloc_pte on architectures that need a
> > deposited page table, such as PowerPC with the hash MMU. If the PMD is
> > no longer empty when it takes the PMD lock, it returns VM_FAULT_FALLBACK
> > without consuming that table.
> > 
> > Since collapse_pte_mapped_thp() uses mmap_read_lock(), a concurrent
> > userfaultfd operation can install a PTE table before taking the folio
> > lock. If that races with set_huge_pmd(), the unused preallocated table
> > is lost when its local vm_fault goes out of scope.
> > 
> > Free vmf.prealloc_pte on failure, as do_fault() already does. Successful
> > PMD installation consumes the table and clears the pointer.
> > 
> > Having to do this cleanup outside of do_set_pmd() is rather nasty, but
> > other callers depend on it already having been allocated. This needs a
> > cleanup at some point.
> 
> I hate this being outside of do_set_pmd().
> 
> What about making do_set_pmd() freeing ->prealloc_pte if it was
> allocated inside? Nothing changes for caller.
 
Or if we want to keep in set_huge_pmd() then set_huge_pmd() has to
allocate it too. At least, it makes some sense.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

