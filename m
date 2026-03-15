Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3C3610854B8
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 01:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 772516B0088; Sat, 14 Mar 2026 21:06:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71FAB6B0089; Sat, 14 Mar 2026 21:06:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D9E6B008A; Sat, 14 Mar 2026 21:06:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B6D76B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 21:06:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B58751B8D75
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 01:06:33 +0000 (UTC)
X-FDA: 84546507066.05.0B448B6
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 15CC8C0006
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 01:06:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cBSq3R1c;
	spf=pass (imf22.hostedemail.com: domain of rientjes@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773536792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=breDgvR98s/9To7zMmpKVC/JH/4VMjY7A6WXWrwfXbg=;
	b=hgkftag+WLBZSRR4opak0iy6VhKi1rTVkeKMCUZ/6gtVq/RVEFnBiqUR57yvN8oxPkYKW+
	yTNcgUZZQSkTgSiQHwCUuNVMBcmS3Rcw0aTJ8ihMuTPIv/oAXjmvEJvUsRfSx/w/iXTuE+
	H3OwOYbaC2hn32JKwSFMfxFeQ6AS84A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773536792; a=rsa-sha256;
	cv=none;
	b=Pq51bpirR8NODuIEE97PbbQXbvqu9eEN2seYp7MlN6AJE0pyO1IpJbAj7IC0Ryw2PWwrZF
	61LBXDKY+hfs4WPTN5rrzZKCAiwTNA3CsuVXRxHs1ix0Bj3eWR2w0RWXtdP9O0UuWqYBQ0
	LjbMG6ZRzWtmvUj0KHknQSyU3czLKnY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cBSq3R1c;
	spf=pass (imf22.hostedemail.com: domain of rientjes@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2aeab6ff148so56975ad.1
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 18:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773536791; x=1774141591; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=breDgvR98s/9To7zMmpKVC/JH/4VMjY7A6WXWrwfXbg=;
        b=cBSq3R1cdQliEGewJODpj5bP1EfF0vOXxlERsVinl3RB3ukXJ1JyYIFLZSsQSQvL+g
         ZfpU/2qSDX3i5ByJkCXAvi0/5ZdD3cbB49l69Rbqre91d3Mebcf1hx4r3Bmwx4uEsWDQ
         jUEDUy9uuroCkZVVH/hawUw09C0IO4RDk4YEuT97rueeIuPIny+2i+FF6W4xheHFIOKq
         HTa7+rwbNUVylzAqicwRdaN4f2quQBlyt7pMkyEpNaHI1cEY2VRD85MaLSYN8np6Z0ZD
         DQv+0bHeCxj0LOFjgWKQBeBDYyL0oUEy59Vz5EjPiAakgQAsi2Zp6FRNINNsvt6Nr/dO
         W1lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773536791; x=1774141591;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=breDgvR98s/9To7zMmpKVC/JH/4VMjY7A6WXWrwfXbg=;
        b=D0pcuaGUpO5bR6ZkI3eSKWoJOBZK0VeEpXZY4Lwpf1DlhE+eM0ZYhPuU/BPkWLH08j
         AWOIs0jnJanc277zcIEO/8ZAB5viOgeQnzH3lTByE0+cmypga/OGWrJBk7ld2q3w5xCW
         vR9ISiVkaAict2d4DO04eHBFuUX8YUFB+fAtBS2BtxerSBXuQGwwT4SYO8FRQHYob5oE
         1N4QT7A6JAmXZTSW9bUEWCI/4s7R9uinWAhsv6l4NiXFZGn2DaMKOU280kNnJlV/AfQS
         8F2iBisOz4dTebYmQiT4uKcyP5r8vWw+JTxZYtZ5M30m06igWV2ix1RNmRBOj8IFy75Z
         nqkg==
X-Gm-Message-State: AOJu0YxwA8DQK5vfQ3yMrKt/JRlegQ2ETQ2MQ6EgoHiUcN0EbpncBUwg
	Km+JM+4D8VhzyGouScH8xNiRiAZDj5GBYn+pt2iYHci19uYyaSbuLzdxWvCctfvcqg==
X-Gm-Gg: ATEYQzwTOmSudZo93JNHrt7NMoN6UrLfaMalTey0EFs9uWpmocRWZ+dDVdRRJM6sQ4G
	ipkqsQNpLJHyAWuCaJ1D86OpTOAY3ZgtqlXyojfdhtrJQox/o7YfNyRWXVyT7UJq+J0PxLWaHHn
	+kjE1QkTE3FTaju70A+geh8neXvKQRWwCt8rBIPI4GjfBhuBxszx5+EmkR1uLpcy+EHmwd+pIhK
	K1ilCpQaAyM79SNwA3vd4UX1LGR8IrKzkK1abNc3MjEUl/Jx3y6mwQ3hh9CC7VoOoAFJPYEUouE
	pNanH93MWvFvfBjYCOSO8PfcSaxeODX4apRr9ErnBIyc3BaGsYLouViPqcPLnaG9pnYFihdmGIj
	e1f/baI3f8vqFjBvBk6UBDZ+I+kdvOnDr/nleUGIez8Qfat5ozJ/papOrI1SEe6loA8QmRjYVy9
	a3/Uok16hfhLRoLSZ8Km5VHYpw1lFgVCwaQlbLldkXAh1B3p+x8Ofc6TubY6M0PP+R9VyETDBgK
	r4TMXxdVA5T7kYXWS7ajGij9SZsDjitVuuPTGQ1SVbHYCQWL8t/rQ==
X-Received: by 2002:a17:902:e849:b0:2a7:6c4e:5914 with SMTP id d9443c01a7336-2b042087e19mr2365515ad.6.1773536790052;
        Sat, 14 Mar 2026 18:06:30 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:f531:45b8:548c:e004] ([2a00:79e0:2eb0:8:f531:45b8:548c:e004])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a07287ef8sm10728741b3a.29.2026.03.14.18.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 18:06:28 -0700 (PDT)
Date: Sat, 14 Mar 2026 18:06:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Alexander Graf <graf@amazon.com>, 
    "Andersen, Tycho" <Tycho.Andersen@amd.com>, 
    Anthony Yznaga <anthony.yznaga@oracle.com>, 
    Baolu Lu <baolu.lu@linux.intel.com>, David Hildenbrand <david@kernel.org>, 
    David Matlack <dmatlack@google.com>, James Gowans <jgowans@amazon.com>, 
    Jason Gunthorpe <jgg@nvidia.com>, Mike Rapoport <rppt@kernel.org>, 
    Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
    Pasha Tatashin <tatashin@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
    Praveen Kumar <kpraveen.lkml@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
    Vishal Annapurve <vannapurve@google.com>, 
    "Woodhouse, David" <dwmw@amazon.co.uk>
cc: linux-mm@kvack.org, kexec@lists.infradead.org
Subject: [Hypervisor Live Update] Notes from March 9, 2026
Message-ID: <2c094579-77d8-7de1-0a49-9138aeb69e84@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 15CC8C0006
X-Stat-Signature: 6itfes9fi9pka587wqb1t734z5pnc4s5
X-Rspam-User: 
X-HE-Tag: 1773536791-390447
X-HE-Meta: U2FsdGVkX18qXgWIHpSouY8HfN/sNWh6qZhwXrnA66TgAjyDGTw3nVOJtXm/a+2qe4cxVGiX5EgEAdiONDVLtghOL24Ys/d/j2OV0CC1ow11V8hwEp72gKL/5+IeqfRpD0aLS+NKrjI4iNBWGzRtJ1EqX4JLZ5HgPsSfmaEprosuSbb+vM5TPW0qCbuW4hEo44R2DbXVgvQoCG5AxSJD7Wu3i4RzMHoVwLOMiQhwp8S57vKVuqsr/k9UcHmeycjqRhaB1pugjaGr6anspx2S4GS0iGSZAsRIDu0joh4YaoSOVwD3gFnjoXON3jtzlQRmpDLEW5zZYqDzjWLeQKtq54LpEHwHNaJJ5Wv8+S6E90L/sMy8CxXgT86KT7PXYX6v6q+Nrpt4YMybhNel46BwBcwbD5gb0Ub4v5BEQjUPBhmIwbWnwYFGDrzPfeZgyKYZtHITO5IjkrBZBM83L2C7sc7EF7rh9eTzKy1gk0S3A6X/B9w2ZEqdKpK6A0C9IwnNPx4fh6epCxhDtWadgHKp9PVCuKD09ZrZYjxnQkGWdQNxZotWsYJ74MawG//eA8VIFYMEZSS+nolBtzohCgwGU/I8OYh16XD7OisPxuXiWCFvWWyqR6XjSExrJ+EVolBdWrw6CtGbqhoOelCGe4gxEkpHCn4GAEuWUsdcZnSDJLRcb1Sk2F5qkXJhJw+qR3z9UYblH9uBpyN8a37gl1PO24UE8dz2EOGpg+81KhDh/IK7F8McBNSO+F1bcloVNEa0iGWFtsRS/YLgC6H2IyyuuRz+mclaUcmKtjHODgZVYJVw/pMXl5MF3QPONsHMcaW/J/I8VqLmU6DGa03llzRFBoIWL5yhpB726ak8quX9+BcQc98bK15U4k+EMDEqGKWsn/6IZOYqbenVY7h3qg4t6f8ClHkz71R0h2i3wpOuI5TkNq3rUlZ1iPDwttjgNmnvFRp4OYYfRU2jOzii3NF
 mmLDZBLK
 u0oepwzTusilMvSj7PRax7ZirGcUDa2ZStEWRW6xFDW62njt+EyZxN+FoTNtciHpIVfAO8vOenDFNJEnn+qIedGfCEnoYo9jRVLWHIr0GncITA+ycSqv/9Lz6m32q2sReq+gkpfY+aRIN6O0Bn6vAfHF8Kqz1boocLsLcp2vTS4sJOlHS6JEoUJoMFxpzSQAw9gDlNep5Vk45i3F3pGN3FI3v/oDpuEA13yB56h+S0Ipk90up5wcRWn5AgcUsMOB+tGuw0WyltAN0E6cxnkqBI7E9HsScsfLAKGZI3Er00Pl4ctCuVAHS6JUo1l7ZRW+PeEG7c8inZeo1fkH8LIY+S20EGRRH+UdFLLdv2b5b4Ws14flxQudqrD2m4hFMPwQ86c9518/31zUe8VU0En1P4W4LpdsZAElO3gnIvyIcrjid1QY7NCFLBrlSPsZmM6FjLgvZ50VN+GQEwpFFueTgU3CDFcf6pj+/tEA6Ag0hiKq9SjQNjqDPGBCFVaoMu2IZVWPOn/cZYI2n0SafcwomhWwobUj9/X6et1n+EYzxuyqvpGugUkwQg6L+uaVgZ81UA3AuIhdYVWJnOjy9qOTjyYetUlBRHeqrIKrCG4FhFqWDHQaEAwNtsxueMs4TPSGsQkwbwFeOrgXWaryxeDwgely9PXWzEzHTKOBO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, March 9.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Pasha updated on stateless KHO: it's now in Andrew's tree and ready to go 
for the next merge window.  He noted that deferred struct page 
initialization was being worked on as a next step and then attention will 
shift to optimizing start up performance.  We want to make sure KHO is not 
the long pole.

Pratyush noted that there is a weird interaction between HVO, sparse init, 
and KHO.  HugeTLB pages must be allocated before sparse init but when in 
KHO boot we are in scratch only which wouldn't allow for allocating such 
large amounts of memory.  Pasha noted that there is an exception available 
where we can ensure that memory is coming from the preserved tree.  
Pratyush said we should parse the bitmaps and make the memblock 
reservations but we don't set the order in struct page, then turn off 
scratch and do the hugepage allocation and then parse the bitmap again to 
set the orders.

----->o-----
We briefly talked about KHO enlightenment for ASI which wasn't deemed to 
be super urgent.  ASI can be merged without KHO enlightenment so this 
could be a later extension.

----->o-----
Pasha noted that he received some comments from Pratyush on the luod 
design[1] that he would be iterating through.  We welcomed anybody else to 
continue to provide feedback as well directly on the doc.  Pasha discussed 
with Jork and there will be a three-way meeting that will determine what 
the intercept will be with systemd.

We discussed versioning support and when the timelines for landing the 
support would be.  Pasha suggested that we would need this when we start 
making strong guarantees about supporting live update from version to 
version.  Pratyush was working on HugeTLB preservation support ahead of 
this.

----->o-----
Pratyush updated on HugeTLB preservation support and how it would be split 
into multiple parts.  Part one is selftests that he sent out to the 
mailing list for review.  He is currently blocked on the ordering issue 
mentioned above.  Pratyush suggested upstream code review from upstream 
HugeTLB experts would be very useful on the list.  We discussed handling 
this at the next Linux MM Alignment Session on Wednesday, March 18.

----->o-----
David Matlack is prepping v3 of the VFIO support.  He was working on 
preserving VFIO file descriptors but not preserving a lot of the device 
state itself.  A question arose upstream about userspace being aware that 
we're in this development phase where files are preserved but not 
everything on the device is preserved.  He didn't see a long-term need for 
a UAPI that expresses that it's saving bits and pieces of a device or 
letting userspace control what the kernel preserves and what it does not 
preseve.  He was thinking of doing this under CONFIG_EXPERIMENTAL.

----->o-----
Sami received some feedback for IOMMU persistence but otherwise no major 
updates.  There were some patches sent from Intel that would be a small 
dependency for hitless replacement that Sami is looking at.

----->o-----
Pasha brought up plans for the next steps for live update while keeping 
CPUs running through the reboot, which will be a long-term discussion.  
This will need to involve KVM folks in the upstream discussion.  Jason 
said it would be very useful to demonstrate kexec live update with a very 
simple VM with no VFIO.  David suggested a KVM selftest would be useful 
for this type of demo.

----->o-----
Next meeting will be on Monday, March 23 at 8am PDT (UTC-7), everybody is
welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - luod design feedback and intersection with systemd; implementation and
   next steps
 - improving KHO and boot time performance, including deferred struct page
   initialization
 - HugeTLB preservation support including selftests
   + debrief discussion from Linux MM Alignment Session
 - VFIO patch series review from the list 
 - phase 1 of IOMMU persistence patch series, then phase 2 status and
   updates
 - hitless replacement for iommu domains and patches from Intel
 - guest_memfd HugeTLB enlightenment: conversion support, HugeTLB support
   without restructuring, and HugeTLB support with restructuring
 - later: versioning support for luod to negotiate
 - later: ordering issues when disabling interrupts based on feedback from
   Nvidia
 - later: update on PCI preservation series and next steps
 - later: KHO enlightenment for ASI

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1] https://tinyurl.com/luoddesign

