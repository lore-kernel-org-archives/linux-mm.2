Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54202CA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 06:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7DBF6B000D; Mon,  1 Sep 2025 02:12:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2E726B000E; Mon,  1 Sep 2025 02:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944706B0010; Mon,  1 Sep 2025 02:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 849FC6B000D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:12:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19B99C0670
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:36 +0000 (UTC)
X-FDA: 83839662312.24.3AE92D3
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id F377640007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=fKaRMpvg;
	spf=pass (imf01.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756707154; a=rsa-sha256;
	cv=none;
	b=vgVavjXnPST+x+yuiM+CPLTuDG9noKVMKM8Z9vDoQB35VKUlzVJ753BoaLp/0Ztkh9zvlo
	GEMPYx21DXdNzwad3VC2xEQyNcioKmcwr8cCynUd2EJaLZZ85Y2ZurL7GOM5biMa/GLlZo
	uGwgAzsx7QmV4WgtGS+D+qdMF6i0MEg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=fKaRMpvg;
	spf=pass (imf01.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756707154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KpHLc7A3u13jSpGa9TNDfhEMDSTSK3zE0bmrT0DiPuA=;
	b=NOcC9+p+U7Uu0Z8rAaKo5++UTRbs+dAdgmP5isE5Cy1STBw6+57Rf05FgFiVE3AxKhltIs
	7ldtsnD2izvdyvvCDY13VlIh5+H/htmwmhumLvVd/5IqwCYAfbAnq0Xo56Y70yaxHMmxgP
	KPo0OlltT6SxvQnfJwbnPHjGkWeZnmc=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6188b72b7caso4033790a12.2
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756707152; x=1757311952; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KpHLc7A3u13jSpGa9TNDfhEMDSTSK3zE0bmrT0DiPuA=;
        b=fKaRMpvgZBFZCWH2blGekUuvhl09sFqda2R/ypMTaXC+P65LWHQZao/sCOy7E3GerV
         9YJG4pqSJON/iC4zny5brm4Z/77yz1OzgjLXjrY8JvrsP6nnujko3uyyv7kNyDa8M6td
         8d+V8OFbRRqDe2/nzikGDUX2Jc7lJ/jYWVfsi7VgkzAXRbSqYNgutCWy/k3SUwHbNZTz
         xZ+8bnDPQwYuKYNMyzIUKn1cOXupld8YM2h/oJ7grHwfAlNKWwncSe1E8s0sEOLERUVa
         +oDRGC+bPhXEC9El4ngnwunj3oX9OFnJgF/44Fh0N8govzuuviwPtEKqLhzw6bkfi0lB
         RaEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756707152; x=1757311952;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KpHLc7A3u13jSpGa9TNDfhEMDSTSK3zE0bmrT0DiPuA=;
        b=UFAUY3d/bbcW3J9/guQ6pa4bHBmw9loRXLN6r1GfJzrLkI+W/pB2l2Jx1krUXFsxs6
         Rew2KOC1HdhCAujVHIQDFcAyOaz3B+m5/hd6ysjlmlFnbdRk1kVMeiAwGia22ZC+xBg3
         XHn8Iy3y5LlFMeDkX/MDEcBljfmRUuVVFhnLPOQ/2Z5kHfThRioc/ciaVIDB99NFRu4g
         kQ3WcV19LHCi4b1H8IRwmwZsz0eiIBxWsOqmKO5ZR706NqmovUReV41cHspAuKsHg/1d
         FPmWYZOajVF5l0ZEGrPvsmBTnia74ZKQSbV5FJjCVQd8RpvY9FdCnWC21j7vvCBCJrb5
         Zd/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXKbe//QyMIfO5FACyaryq0LRWfKYpgUrEJ+/LojcGQ8rpWUHjZNksHzB/rRJ2DnV+z+7zT/r9hVQ==@kvack.org
X-Gm-Message-State: AOJu0Yz8cMzZszr2G1jPBRXAxH/zONRx1NUoY0t/lsK7vDVc17CDFWSA
	BDwNA/l0d6pa5VSoi8CCHpxInXGs6rYTUSjDYhvz3BRJWQPY88xKN+TpDPi/Clox6TA=
X-Gm-Gg: ASbGnctMrnvGBbrQNcusH6C6WLDvVFw8lq1BtaYYQriKhHDpGGyHXVWTwhaOx40sqaF
	ln1pxoI8SRX+jiKKDOq5+h01GxIJR5LIPPoO9AWifKDlMY+sLoI2f09ymHukNwb0RoTJjj5C30M
	LmlkSEusqfvtvriGR64aVOrE3Gk+Af3SC8mnQGp6sv25pbeZP29mroJf4Gy+C0iBewDcMxcCRy7
	pFOPvJWWFdOrFGs2fjxEogfwFdggRXIY/XGSnkkHrWfX7998+lyCYenfDlQpRlSNLLiJ6kDDdnJ
	pw07IIfiq/Zn45690MHclRUv+xlwSOizWL4ZnCMiyP3ddq/Nbkz98bWntECgTDuA0uJY1liAVDH
	HIyHlBjQDKTcm9lwHwLBePGkgz2KeLg2WgN1NF6XRfxvm1UztFAivp0cAhJG3X4yBxyaVSOwD8T
	pw+WyPT00Wlb1fE1hYxHxm8lM8T+q5fTUE
X-Google-Smtp-Source: AGHT+IGBFtmEnqB1bVOIv6STAyxunZzW94SmLiywCtB1sDFjhfn22FdqbPmZlx92N7ZJy9skuz+v4g==
X-Received: by 2002:a05:6402:268e:b0:61c:9193:a4c with SMTP id 4fb4d7f45d1cf-61d26987b9dmr4913122a12.1.1756707152279;
        Sun, 31 Aug 2025 23:12:32 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc231561sm6374533a12.23.2025.08.31.23.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 23:12:31 -0700 (PDT)
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
	vishal.moola@gmail.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v3 00/12] mm: add `const` to lots of pointer parameters
Date: Mon,  1 Sep 2025 08:12:11 +0200
Message-ID: <20250901061223.2939097-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F377640007
X-Stat-Signature: tuu657jnura8bnyf1getqibgd3im91kx
X-Rspam-User: 
X-HE-Tag: 1756707153-796055
X-HE-Meta: U2FsdGVkX18izw1IsfiV1DhTwowarg7JUBeey8zc60wHzZGKagfw9E7tUv4zUT57jBzWtlzo39On3PI5MjpfZhkyBOPWg98ohfC2zaQZzcjEcxKhUPWS6ILWKeKXLJRx0T3qvJewBBnPG5lknGUHSE9kRfoY0Y0eGFRKZ+bhgJI50NsiwWSKkpN5voHhmWdBrCXZFl4rACCsuSN7+EAZBDtuS1wMVMxLONsGxDuWt/+DK7c2cmFYTQkz3ok0pv5ugecwn901DR/ApWGxBHOFadzasC/Be3QcNesOXyiNaCRoGnolsydACC+n04e3Nunfw8WKOfo1WY+ioxHLmle9Hh5jrX3fd1ztKDPFbG6H7zlpVsEuIANceBeda8ap93zgd5Z6LiYAPLNGzB4XEnf796Dvig2BV1IIyADu507WyuFWAjRFIwwJxrYnapGHGmAUKK86HvoHOuy9Qy/0qfI5Oa1VdLQZaw9WhwnSk/VmV0jUyAX2NrhLdUBwYLZ8ZY7ODuJLiH/TFDMgVqUYNYWOtnY/X6twBT+OvAX9iJc3Ma/U8VtfpNtJBqiort9X3/9Xfz3bujoefFqRFYRiXu0CmGb36SmXfdX7k+fd1EmMbcmBw5kqJbn32qIV9V+h+vYgha/ApvhP3w5C8WQO689m2J5kAYsPjCa/j1I9zZlhOIkoDvvN58ulTmJGfiPmvxdFcKjJ5Knhg+GffzaI+WnDLXhciWZLLS5PH/HIyxscrAibkNul6ssLzMzf9TrlLZbgGT3vdfIwhSqurRs6TB2s6iZ1L2lS38XNI4ihJaH5J68t1nrd2M3xNPMxhwSg2DdYgk1Z70DPpXXyhTcZVZkWiGdydX9Ae/MALmxP/utLjypePdjvys/G6Ko98jn4ZFYOOJhGSdpYMh332232Rf5lOpOoFIgfLr7Ob6rTLdSW2RVMD2Mgsqlzb7wCg2V0BeewzgfbamYma5U7NxOLIU5
 ZjZAD5b/
 OjBAw6+kXlPD/SvSrPOMle9XGbcgTkWOiLq9ufgX3YWX1jgYA5R46RNmnYpr8Dwo3fTEUbMPEfJyYzn742ezUAmBZigHqb7OcJmMV+AuY+BshE0iyVE2sC/fnQExDvkDBkGgN7/iDYAPzI5SHbCpWVtWCOz9MohYcFIQSeD6FdJBIIb31369AXX+tF8fhwQXshbrekNphE4DHX3IwRTSgCi8gR0uWyeCPNIzdfRLpwhx1DPVBX4iZASHz00dTQvqEDGd5HUx3FrjSAdxrANZv5ymU+wyUf4Ax2rACpph1ZvLvs2MFDbkAQtN7+witNSVLvzCBb1j8W6Zxj/bQTRsCUHHtGWnPC1uS5iEK8VrhN/4UbTu+jUSO0Wr3oVnMBqVDksSF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

This work was initially posted here:
 https://lore.kernel.org/lkml/20250827192233.447920-1-max.kellermann@ionos.com/

.. but got rejected by Lorenzo Stoakes:
 https://lore.kernel.org/lkml/d6bf808d-7d74-4e22-ac4b-a6d1f4892262@lucifer.local/

David Hildenbrand and Lorenzo Stoakes suggested splitting the patch
into smaller chunks.  My second attempt with one smaller patch was met
with agreement:

 https://lore.kernel.org/lkml/20250828130311.772993-1-max.kellermann@ionos.com/

Now this is the rest of the initial patch in small pieces, plus some
more.

Establishing const-correctness in this low-level part of the kernel
enables doing the same in higher-level parts, e.g. filesystems.

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

Max Kellermann (12):
  mm/shmem: add `const` to lots of pointer parameters
  mm/pagemap: add `const` to lots of pointer parameters
  mm/mmzone: add `const` to lots of pointer parameters
  fs: add `const` to several pointer parameters
  mm/oom_kill: add `const` to pointer parameter
  mm/util, s390: add `const` to several pointer parameters
  parisc: add `const` to mmap_upper_limit() parameter
  mm/util, s390, sparc, x86: add const to arch_pick_mmap_layout()
    parameter
  mm/mm_types: add `const` to several pointer parameters
  mm/mm_inline: add `const` to lots of pointer parameters
  mm: add `const` to lots of pointer parameters
  mm/highmem: add `const` to lots of pointer parameters

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


