Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43468CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EC298E0003; Mon,  1 Sep 2025 05:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89BC28E0002; Mon,  1 Sep 2025 05:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763838E0003; Mon,  1 Sep 2025 05:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E2188E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:19:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 07CD685DA9
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:28 +0000 (UTC)
X-FDA: 83840133216.25.D4B9DC8
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id EFE8E100005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=TSNAVGvM;
	spf=pass (imf14.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756718366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IjlvOc7eDmq89ai1ZTLunEbTu4eGMpRVy5UBgVL+2qk=;
	b=jyWRGrPEPZnIePKo4njDXZxL+FVs74re9DBfPWTfrKKe1/Z8eYc4oyplT0Q5x0iulFdv7B
	KlEOGU5PkoMU86r6gRieVkXXXIUDC3BGHjppwz3gGRs/LCYgZd59j8lnWFb0i1WULQoKMZ
	P48Q0iF9Qmpmw8AbiWluX4XGyHJOxS8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=TSNAVGvM;
	spf=pass (imf14.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756718366; a=rsa-sha256;
	cv=none;
	b=xdnmDpmx0m9TRZN7KukUt5Ce5kPpRKckQJBE2cnvflWlbXbN9Ml1sJmEzZVTZ2auA2gSjP
	d4D0XEQXu9Z04Pkj8OI/JWo7N1tGfP0ird84rd6ZxU/Bebt1UIlCh+l2FWGLvbsT3sLBB5
	9U6VqUxA+D0ukbj1qc287cHhEmrRcso=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-afcb732eee6so713230766b.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756718364; x=1757323164; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=IjlvOc7eDmq89ai1ZTLunEbTu4eGMpRVy5UBgVL+2qk=;
        b=TSNAVGvMacvSCNP4q5wDJoaICFjPcEGnpDAcq8i22lqu3AdKlt1q1bf1rHQHFP/SqL
         mNGNFyfFNFQcpOdqe7J7mhtDzeLY7glzmQIMhQSXvcEmjfQHBjuo/7j3qOtOWvq4U6ef
         TP39XQtA1KFUoLz5INzMVOqfWLVIvjbdVSnR9POF/xofAYcDGOHsKaaK1VNuuxl7iQWj
         nEICAVCGkFdIyWKdgz3GVRnZGnvdH+sQijf/YDWu+o/OqrL3GZDxjjGQqTFKdvjwbegc
         4it/BKh/dHcKMweKunfJ3kCgco/L0TiTI3zDrRcslPRPUs2RL+qilLSTjMjB7JHoUnDb
         qFFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756718364; x=1757323164;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IjlvOc7eDmq89ai1ZTLunEbTu4eGMpRVy5UBgVL+2qk=;
        b=g/V6EblFQtdYjKHp3c3Cni/+Gkw4l3lYrmPab+GKcCX/AlOvvZn99fhhRepDGbGW8L
         KUr8N6qysIAuhYjDczpgpsms7Rs2/A2daJSq+/FzocLyS2DfR4727Aqat3lO2sgDRVUB
         hRaotcikc/QT6KULN444iROw5mf99PcGujgIefuPIxN35KARM8nSuqG+NrL5Y9D6/Coz
         7W7tq0Ug6BU+2xnZ/GDXDFB35zmh+LDUDdaVRtUXCcOmsQihSu2jbCeNf7a3mKWpyDK4
         EODTe6hE6/Cbo5Wwi4sUSudVqFfnf++v1gOjARHl9TiKCepo3O6hvC8Uhb47sDT+VdpQ
         wpMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUarW3+vJglRBMuR8J4zrlH5AY4TpWXa5mKlbKqVWT0KWQn6YdNU3h3/YGQPHwy/jYH4rb6Mjt0Cw==@kvack.org
X-Gm-Message-State: AOJu0YwocdJTt/I21giiAGKTPDwEfuFv5cPTzvsf7oVhv8liDP5DhFRR
	EwM4x28Udju5wfwqw65gqf6IQHmIPDXXA5vIXhXSgsveRb80ZZFeZ5uk1mcVVuogh8A=
X-Gm-Gg: ASbGncsBjbbAVBwEMPbvoqih8hkSlF9IQbgzOsGRo3+zxbta+vG8jQOykCJSla+5NJn
	zgqGGSlJkzEwspRwlM1L583nggYOGY/ZHwLOhmB2+DuOn9MWvE8srI3YskOrqurY77oqHiywQXl
	V/i3BJBAeqMMkk6+PhQQYFwkWil+eVXIo2hUztyZds9VCJUm6mSRfr5Pj5WmPP0uHqpkr7+yIzR
	laAQqWnHai+da1YQe9P6LEBLNUHy3LBh9ULElKPqgFIk0w+D9jdc6ffQcNmieHiZDzyZMxl5ISj
	X9UymPGK11WnCrAXGLSoF+zO8vDRELFbLbVATbagDsL5SX7zyV+UwH9GKlo9Ba3oEP+OSEnXtOC
	KTEpONjuUDM1vsiTwsc/tMYLDcS+Gu1+MRtnB8QCKBUQK4MF0xGKSw+swKgdBBvHFBikFJLsVEK
	62DP9SSobi0icNQDI6SfRBLRoHmt4zSsLJ
X-Google-Smtp-Source: AGHT+IFTes99iR4h1SIirBohNckEBvGOnxGmn6ipBhPiK9MotguUOISNLv8vVelWffxZXwdx4Lg8FA==
X-Received: by 2002:a17:907:94cd:b0:b04:2cc2:e49c with SMTP id a640c23a62f3a-b042cc31acemr254882266b.19.1756718364079;
        Mon, 01 Sep 2025 02:19:24 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b01902d0e99sm541005766b.12.2025.09.01.02.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 02:19:23 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 00/12] mm: establish const-correctness for pointer parameters
Date: Mon,  1 Sep 2025 11:19:03 +0200
Message-ID: <20250901091916.3002082-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EFE8E100005
X-Stat-Signature: ansuuzww3fh91npzexy613nenyy7g61o
X-Rspam-User: 
X-HE-Tag: 1756718365-406295
X-HE-Meta: U2FsdGVkX19hWftTG+76iZAV68/OWGVuIN8xYdjB+p0VZxNQmZi5XkcRcQU+Wg5PNVNjQpi81CgyRfanBV612Ri8mUGP9rxVDZXE/k+/6x4GdVOTXdjVonG9PypekmeN3ah/XJ8kgZYK7i1PDWukOut5k521ca+Aks2/DmMMZBZSvcDx1Ze39PSafMI7wxcRJvRFZCAUho/mpOfAbYybXWb98hKICaN7N9iwzPoHbPqA9eVe1qm+EBc4Rggho80yt3GEbZUuYFprtl65L32dnNnPiARXjxBza7zZudoE7Hyz107GZsYlN2a31CKnmv21jcyNhQurNqzIF1H5VkQD8RidrMrhNfMmekEpUMBs/1yfO2daHnrp3e1IJMNoReWCD26AwE99zPMkKoQGcS1utygjDLb+gKwRbKWxxHhXjElhYClvYsf6l15HiD2WHuPGXNP1WL7jugQkA4EAtZu5dkI8V+0c6vtQPZjeq/7FXI2pVjGmRUoX/2E0BhIdivcto4F34MPz/00UFbGeeN7lpRBQPkAQsasWje18+/E9YHLjHxUxgy1KMhVYMSC9Pw2W3vw5JdYqpiwKhKSDxSnEU/f6rYymmROaFcQV06WHCeLY2Ac1B8LmiFpz8N8d+mDDID4AqiBlxELGVQZPM/9MUduQKEYBVvtLozbvf1WYbDOtkl6Ei11D00Ze1ekk8X5zjNyI1gQxSw8BsJVu1j/BsqzzMGdqG0qjnjpPw0J/n54qOrmaI573QAaHXE05nZehuptNzSuMnRQOHh8a7+rLt5tE9jE3Z0fUOVf4pUvmSLoSp/NJSRWOsv0J51u5FwXBitBwPMmo/3nvWkOcj9vpJRH3u+lf55jwIdoqQ3seylvRLll59PytPKIR2fahXmN3MNRtyn0hT565UZ5bLsqwPpiZPpOZpcpoqj2+VhJwDdhbJbUHKMpOWHkogVUfLozA5yXzhcJUK0yf/pI6J0b
 +gP5ofUB
 m5GrLk1E/nXNWi4eGIJzZwkd/sZuhEHd4A8n5AvGt4A1P5XybfVRF7N6rSWExo8kprTHP9zFYlGnWixjlPGRpnQAPdBpq4xSQoPhDpU8eWj948jXcnr8ksJIzPiry93e4NeiReWCl6gMG4auHv8uRoHdEeZfzgbeAPUxFi2B9ziVB5UpADkxtc95REhcufqxbcxFSB00z/J2bqY1ConuFJL3XbSeDLL2iuZ74zdP+uSQlMixumSoNJ8lzvYNIk6wnoBQ5CjltF8weT8DX8uH5KtoNZgdkegn7pnurtM7vsrEFa5xv0Oc61t71YiZrMT6m0YPg2GAXFrZJ8EM5s0twaoHdLkN41gAPpT9ZHgHJF9o2TYhE55GdXpgoipINWXA6e6ophRj+QzYr9JwpXvKVPgrsdzltaX0NG8n2vxR/+FLwRk0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

This patch series systematically adds const qualifiers to pointer
parameters throughout the memory management (mm) subsystem,
establishing a foundation for improved const-correctness across the
entire Linux kernel.

Const-correctness provides multiple benefits:

1. Type Safety: The compiler enforces that functions marked as taking
   const parameters cannot accidentally modify the data, catching
   potential bugs at compile time rather than runtime.

2. Compiler Optimizations: When the compiler knows data won't be
   modified, it can generate more efficient code through better
   register allocation, code motion, and aliasing analysis.

3. API Documentation: Const qualifiers serve as self-documenting code,
   making it immediately clear to developers which functions are
   read-only operations versus those that modify state.

4. Maintenance Safety: Future modifications to const-correct code are
   less likely to introduce subtle bugs, as the compiler will reject
   attempts to modify data that should remain unchanged.

The memory management subsystem is a fundamental building block of the kernel.
Most higher-level kernel subsystems (filesystems, drivers, networking) depend
on mm interfaces. By establishing const-correctness at this foundational level:

1. Enables Propagation: Higher-level subsystems can adopt const-correctness
   in their own interfaces. Without const-correct mm functions, filesystems
   cannot mark their own parameters const when they need to call mm functions.

2. Maximum Impact: Changes to core mm APIs benefit the entire kernel, as
   these functions are called from virtually every subsystem.

3. Prevents Impedance Mismatch: Without const-correctness in mm, other
   subsystems must either cast away const (dangerous) or avoid using const
   altogether (missing optimization opportunities).

This series adds const qualifiers to pointer parameters in functions that
perform read-only operations on:
- struct page, folio, and ptdesc
- struct vm_area_struct and vm_fault
- struct mm_struct and address_space
- struct zone, lruvec, and mem_section
- Various architecture-specific mm structures

Each patch focuses on a specific header or subsystem component to ease review
and bisection.

This work was initially posted as a single large patch:
 https://lore.kernel.org/lkml/20250827192233.447920-1-max.kellermann@ionos.com/

Following feedback from Lorenzo Stoakes and David Hildenbrand, it has been
split into focused, reviewable chunks. The approach was validated with a
smaller patch that received agreement:
 https://lore.kernel.org/lkml/20250828130311.772993-1-max.kellermann@ionos.com/

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
v1 -> v2:
- made several parameter values const (i.e. the pointer address, not
  just the pointed-to memory), as suggested by Andrew Morton and
  Yuanchu Xie
- drop existing+obsolete "extern" keywords on lines modified by these
  patches (suggested by Vishal Moola)
- add missing parameter names on lines modified by these patches
  (suggested by Vishal Moola)
- more "const" pointers (e.g. the task_struct passed to
  process_shares_mm())
- add missing "const" to s390, fixing s390 build failure
- moved the mmap_is_legacy() change in arch/s390/mm/mmap.c from 08/12
  to 06/12 (suggested by Vishal Moola)

v2 -> v3:
- remove garbage from 06/12
- changed tags on subject line (suggested by Matthew Wilcox)

v3 -> v4:
- more verbose commit messages including a listing of function names
  (suggested by David Hildenbrand and Lorenzo Stoakes)

Max Kellermann (12):
  mm/shmem: add `const` to pointer parameters for improved
    const-correctness
  mm/pagemap: add `const` to pointer parameters for improved
    const-correctness
  mm/mmzone: add const to pointer parameters for improved
    const-correctness
  fs: add const to pointer parameters for improved const-correctness
  mm/oom_kill: add const to pointer parameter for improved
    const-correctness
  mm/util, s390: add const to pointer parameters for improved
    const-correctness
  parisc: add `const` to mmap_upper_limit() parameter
  mm/util, s390, sparc, x86: add const to arch_pick_mmap_layout()
    parameter
  mm/mm_types: add const to pointer parameters for improved
    const-correctness
  mm/mm_inline: add const to pointer parameters for improved
    const-correctness
  mm: add const to pointer parameters for improved const-correctness
  mm/highmem: add const to pointer parameters for improved
    const-correctness

 arch/arm/include/asm/highmem.h      |  6 +--
 arch/parisc/include/asm/processor.h |  2 +-
 arch/parisc/kernel/sys_parisc.c     |  2 +-
 arch/s390/mm/mmap.c                 |  7 ++--
 arch/sparc/kernel/sys_sparc_64.c    |  3 +-
 arch/x86/mm/mmap.c                  |  7 ++--
 arch/xtensa/include/asm/highmem.h   |  2 +-
 include/linux/fs.h                  |  7 ++--
 include/linux/highmem-internal.h    | 38 ++++++++++---------
 include/linux/highmem.h             |  8 ++--
 include/linux/mm.h                  | 48 +++++++++++------------
 include/linux/mm_inline.h           | 26 +++++++------
 include/linux/mm_types.h            |  4 +-
 include/linux/mmzone.h              | 42 ++++++++++----------
 include/linux/pagemap.h             | 59 +++++++++++++++--------------
 include/linux/sched/mm.h            |  4 +-
 include/linux/shmem_fs.h            |  4 +-
 mm/highmem.c                        | 10 ++---
 mm/oom_kill.c                       |  3 +-
 mm/shmem.c                          |  6 +--
 mm/util.c                           | 20 ++++++----
 21 files changed, 162 insertions(+), 146 deletions(-)

-- 
2.47.2


