Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33345ECD6FE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 00:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1926B0005; Wed, 11 Feb 2026 19:37:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344AE6B0089; Wed, 11 Feb 2026 19:37:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243D06B008A; Wed, 11 Feb 2026 19:37:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 14F9E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:37:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93AC1C22B9
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:37:29 +0000 (UTC)
X-FDA: 84433941018.08.5644247
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf11.hostedemail.com (Postfix) with ESMTP id DC08B4000F
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:37:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DSrUv1rc;
	spf=pass (imf11.hostedemail.com: domain of 3xiCNaQsKCI8tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3xiCNaQsKCI8tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770856647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZJpTlhiR4TRyjHrLxyY5K7IcESbEG+rqURvXdu9Kbh4=;
	b=SNjUSsjNURsnr7lBhBi1AE2wV8c1/987QpXG6ukBw3C5uamTEoFC+dkI73xJXrIGfI11CV
	qXmG6jG00RqewHwmI6wyE6ypoZlxbZddmVtXvrJ5p+3k9lN9EShe7uVj82F43ENzTRdTun
	KQoRSDkxXZxlI6RuIRKWTmSSyV5RyRA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DSrUv1rc;
	spf=pass (imf11.hostedemail.com: domain of 3xiCNaQsKCI8tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3xiCNaQsKCI8tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770856647; a=rsa-sha256;
	cv=none;
	b=KBq0iko55eHV/cVFjT5KVDMO/tva9Vj0xSggAcwKn4dqcPDpYaq2mVJwTWFf1/7QrmVqJa
	lPJHxSAhkL3SWjwa6Ai7Ftm3iHcYT8mJiPzU2HA6uHcWqgrYm4f6W4aDiUBGJX1wtLf6gw
	9OvKe12IfAKYkf/T3L5/PLpAwG0nFW8=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-824a02e4d29so487150b3a.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770856646; x=1771461446; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZJpTlhiR4TRyjHrLxyY5K7IcESbEG+rqURvXdu9Kbh4=;
        b=DSrUv1rcvs8yegrBUh7iXSlPYN+JwMJb+m4tieHLMvF39UsqAnH4FOD5GQ5Hz5XTjm
         dWbzPkujxv6gm5XIAF/eSJH9jWcHIml5RX7UKb3+OagGRH11uUISoA4wGiSdku7i4+2p
         teJa3NexW4pn7Qc7ufb9EsFjJgYP8sRFx+jLBswURvdPV0UF7asZOSjr3RKb9TtHzBg3
         umvcOiBhyl4wAR5jMaDm7Oq33rK8abfGtCKU/J0rMRpSDgBIrjOZQeVCQ2SFTWaI/55x
         RGV5UjYb1j42duBRc193sCPVTfjJ9qaAlohnqMR3HJZyvvhcvlNtCkeOsvpgngfWH2xf
         4JBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770856646; x=1771461446;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZJpTlhiR4TRyjHrLxyY5K7IcESbEG+rqURvXdu9Kbh4=;
        b=itEardxOPXyI05zh6vSUvLWoRIfGbaI8DJg3N3ammbulG0lPHCpIpzHav2O7eYkqrg
         tQU/LItPt0z4SD2vNMBhiZdowEBkQ/9jxyC9Xm9V/E8HNjeUOnZ1pCwys4+eg5zBKqun
         Hv4Bbuxr95fzukRsU2RFXfOBCqWuakDOd3jzHr08B0rA3TNrFDoC1858XH3zN7JNXR4C
         i+B769ju9zzPEoz3tY4TzJDdOLk2+VZA6hTJurz/qKVeVUyPOB00NsigYv9oZIOufrLB
         smBY+tErE+H6OAUcemH35Q1cRIAw2o0zyQQApdENhtyHccn1VXXep7mscmyEb3q18pJT
         kqeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgsoiWpKSZRCGnyWjqCUUOJ5bkdClizEmCsFFDaeUvmAnHEYUzAqg6BvnCXZjUHtmrqDLjdSYkvg==@kvack.org
X-Gm-Message-State: AOJu0YzxofNgAEzvAZB7cfN69DR5kDEBxpSw2wLaFsjSXwMoDWEHeFSC
	xYoRRtVR6o7i5J/GT4W/Fj/oF2+d8cUNBAqbuotNz6p7pDaq/h6E7GBVqOiYgAJrhRz8rTpu4ZK
	lO27r9Ep6ruCnvusnvI8ILY0keQ==
X-Received: from pfbih24.prod.google.com ([2002:a05:6a00:8c18:b0:824:b235:888c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2492:b0:821:8230:235d with SMTP id d2e1a72fcca58-824b04e5834mr661593b3a.39.1770856646414;
 Wed, 11 Feb 2026 16:37:26 -0800 (PST)
Date: Wed, 11 Feb 2026 16:37:11 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <cover.1770854662.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 0/7] Open HugeTLB allocation routine for more generic use
From: Ackerley Tng <ackerleytng@google.com>
To: akpm@linux-foundation.org, dan.j.williams@intel.com, david@kernel.org, 
	fvdl@google.com, hannes@cmpxchg.org, jgg@nvidia.com, jiaqiyan@google.com, 
	jthoughton@google.com, kalyazin@amazon.com, mhocko@kernel.org, 
	michael.roth@amd.com, muchun.song@linux.dev, osalvador@suse.de, 
	pasha.tatashin@soleen.com, pbonzini@redhat.com, peterx@redhat.com, 
	pratyush@kernel.org, rick.p.edgecombe@intel.com, rientjes@google.com, 
	roman.gushchin@linux.dev, seanjc@google.com, shakeel.butt@linux.dev, 
	shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com
Cc: ackerleytng@google.com, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DC08B4000F
X-Stat-Signature: xxifrgd7phgmx8y8rcw861jzhhg7g6om
X-Rspam-User: 
X-HE-Tag: 1770856647-127279
X-HE-Meta: U2FsdGVkX18j2zWg9LyAebhHO3ZlMuSWicZmD0qLrCiPjvls8xaY7ltd3zLvFZNopL/hH6oTJzK+Vu7m5RmJQVFDMdf5pbf5IhdSsNaj5UyudxInHTzZ0lFezMlCnVSL4GJvyYKejLuqY4aAojEhhkmih95EDNNN3fdZxwxzxIVddpsxeiTo5uexs0ydOM5q/k+NPirukCWQvHUk1Kdx2wLUtUXw8DmSqft3ArADOH5FlDEEOGA4o7zW70kv6g6iczyg3MTOVyQ1yBfgQw1vLF8VxC4XNhx68RRfCKh93u1Ga/hGeIhbeb3VhBs72FN5O5X+QVuXl3vh3FFUWObplozq4MaSuIuQE7y6iskUID3lIyDlx8LKTBvoCrTN9f/6qe4DfxdurbdXN39JXXBIa0gyfoDe1bbWYiZYqBD6k/p2rSH00SIkxCXn251rKfbWi9tIUQbU3HAJX8KH2J2YLCfMmQcwmEhoXkslUC6juh4krNI9FtPB8fFTbymUGDD9BnpoGDteeBjTgmN7P5Vffr2vwIe0XfCIcAblQwk/IBtd4Ocdsyf96oJtAFbLlbRlGJPWmZoAMU2zwQDhJQwz4Yul824IJ+obx1UAMkwldJGaZDtTtJFcYpx2r3Nx5o5YJGikKRJFb2FD5Ydwhzf/3doDpOt05kojIyyTTuMeUMnbVv7I1nDnnZXEJYj17N1yS5C1Cw6W9i6thOsX0OONlGH8dgOQS0YfJSyW232036vE93hIWH3C0eIe+47JakjF957SbZsdItFfByzOFpdABIMOdGNnwyWj/TWVGmXrxSbDdtXG7BYZZSC5aCdb3XtOi6W8SaYBAO4dqky5QEJFn5+NY+rOxHxzgjs9wyT3IawzHtd4SZLRm1sq1BdYJIZF9RpfXOWGgUrxgqPqGt2IT+AgfKNLNQgx5wrT5nKzAIdGGVYPlKUn+8Z3ESOadHK8YEssXDYMpOEAkw3GKL3
 pAUBIMXC
 8fpFv6JG8oWjqQnAFdoASi756YlmlGbPEHc4PPnyLnFjavI6nmGtsKdWshP/vZ25XtKZ4eS6zvumwbboe1ZIXOfAopMxtFf2PXtLBYcGhTbiwW+gydwE2wp7qrP2nYLx+XeKe13wnNgRlKhai4RX8ACOa0bnbqzyXq/EjFo3FzsUFfeK1CQXiU61BLr0bCV5KWROFjYzpwSTi/MYwJCkmxwe3Q5nUKSlaNWmVQW9OzRIYuovwb39YJCMpjYn1vlpWlVPMgBHpvGFhVSi3vzAxhz/U7648sbVVWf2MQWgc6va7Tm7R/xdn73wyRN4as6QZCzKLCwRAJb2XlSj1+bYgQRCAHWyMYGBppnkeXRa3uiv/xlmmSOvWI7JYUNiwa+xNf0QXV554UEXv14UkQ9OUEUUo1ITcktHnVuDmDL6/ozw8/PMFsd94SH+wxrONsFmaybvIsT8WL2jo+xRcOasHpwN8bzjdrzux3lyUYg9KplPi1duHB+wJfh62C0XOex7Z6zftD+Xo0QOKMMzzkPR5W6lPTYJyX5hQFNMZkaIDJuMSdvYk/7iOyBJjAYeL+OhhuhzIol0EU2CnS51Ku8aIrKZjOYS4d13MXijcPXhZMtb4PU38ACW2VaPEY4nrL+xO1WrtyJGCMv1/R8BElCLEenZFuHjRaBfFTWOyOwuLbQSqupZkDknYX7SPGggiLy/EgUaPZY/UyOufHExGSrV1H7Sa6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

The motivation for this patch series is guest_memfd, which would like
to use HugeTLB as a generic source of huge pages but not adopt
HugeTLB's reservation at mmap() time.

By refactoring alloc_hugetlb_folio() and some dependent functions,
there is now an option to allocate HugeTLB folios without providing a
VMA. Specifically, HugeTLB allocation used to be dependent on the VMA
to

1. Look up reservations in the resv_map
2. Get mpol, stored at vma->vm_policy

This refactoring provides hugetlb_alloc_folio(), which focuses on just
the allocation itself, and associated memory and HugeTLB charging
(cgroups). alloc_hugetlb_folio() still handles reservations in the
resv_map and subpools.

Regarding naming, I'm definitely open to alternative names :) I chose
hugetlb_alloc_folio() because I'm seeing this function as a general
allocation function that is provided by the HugeTLB subsystem (hence
the hugetlb_ prefix). I'm intending for alloc_hugetlb_folio() to be
later refactored as a static function for use just by HugeTLB, and
HugeTLBfs should probably use hugetlb_alloc_folio() directly.

I would like to get feedback on:

1. Opening up HugeTLB's allocation for more generic use
2. Reverting and re-adopting the try-commit-cancel protocol for memory
   charging

To see how hugetlb_alloc_folio() is used by guest_memfd, the most
recent patch series that uses this more generic HugeTLB allocation
routine is at [1], and a newer revision of that patch series is at
[2].

Independently of guest_memfd, I believe this change is useful in
simplifying alloc_hugetlb_folio(). alloc_hugetlb_folio() was so
coupled to a VMA that even HugeTLBfs allocates HugeTLB folios using a
pseudo-VMA.

[1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/T/
[2] https://github.com/googleprodkernel/linux-cc/tree/wip-gmem-conversions-hugetlb-restructuring-12-08-25

Ackerley Tng (7):
  mm: hugetlb: Consolidate interpretation of gbl_chg within
    alloc_hugetlb_folio()
  mm: hugetlb: Move mpol interpretation out of
    alloc_buddy_hugetlb_folio_with_mpol()
  mm: hugetlb: Move mpol interpretation out of
    dequeue_hugetlb_folio_vma()
  Revert "memcg/hugetlb: remove memcg hugetlb try-commit-cancel
    protocol"
  mm: hugetlb: Adopt memcg try-commit-cancel protocol
  mm: memcontrol: Remove now-unused function mem_cgroup_charge_hugetlb
  mm: hugetlb: Refactor out hugetlb_alloc_folio()

 include/linux/hugetlb.h    |  11 ++
 include/linux/memcontrol.h |  21 +++-
 mm/hugetlb.c               | 228 +++++++++++++++++++++----------------
 mm/memcontrol.c            |  77 ++++++++-----
 4 files changed, 212 insertions(+), 125 deletions(-)


base-commit: db9571a66156bfbc0273e66e5c77923869bda547
--
2.53.0.310.g728cabbaf7-goog

