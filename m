Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3F9F1039892
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:09:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09F4C6B00D0; Fri, 27 Feb 2026 15:09:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 077846B00D2; Fri, 27 Feb 2026 15:09:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB8D96B00D4; Fri, 27 Feb 2026 15:09:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF8906B00D0
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:09:12 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C5D2C2E5D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:09:12 +0000 (UTC)
X-FDA: 84491325744.25.39BDC15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id CF21140004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:09:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P+U9FbqK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772222949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Vvf+Q0fyJ0WZ546dSDkkC4qI/jyE57BnwDyTXGB58lE=;
	b=gEmINTA/b3dYi6mge51sDYrg0Oj2PIwS5aCLvNtpQ1/8NzYYkD5olvQiASXpT1kLk+FfbL
	2tSwFqkamGRx16MFEkrTul4cDPibI8r9CcG7WlyFX9pE+paHV3EXgGOHvzIxQMQ5NJoW15
	cAmrlNp6WH+jliqVqGS56yn8HLpY4BA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P+U9FbqK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772222949; a=rsa-sha256;
	cv=none;
	b=hi1APuvEoiqHXi7pL1n/hIVtogeAV+JYim2DLQ8lEfTQHaXSkAxwP/ILw8O3ewTuxsPnRA
	lbHHZ2VlMKSIHeKEE0Xtk5XmupbNTCNUlYMAe4Mt4CADslXAIaSz1EETd1Y9JWLUKaRkr1
	5+Bc6fbA/iFkX6xbUjtQUlLswGOMAk8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C2E336013C;
	Fri, 27 Feb 2026 20:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E88C116C6;
	Fri, 27 Feb 2026 20:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772222948;
	bh=uHYxem2rcFuwlV7scbCWwSyUtQMuMwhNJjysCrEHJOo=;
	h=From:To:Cc:Subject:Date:From;
	b=P+U9FbqKF3CgiBsEPqPexZzZ93XmAcCqzSbUwaOX1Y8siePI12ijG2mxzI5YIf0mL
	 /ms5mDjzZ41zbR+y1lyjSjd5si16Ajj3yoCRxi8QeNf7VJlp5WbLWxR/Cm1nnjaTYO
	 IOJj8irdOEN+aJhdaLJh+fKK7+dKb7KlCCDxdNslqcoGrctiSrHy1YeE9LnRXJRhDK
	 ivNZRpe0JCZ8M0dux5O/xFyufs7KMwSQdWCOqjqmQAjFgGIXu0NS+l21cUs4WBsHt5
	 gFLiipJYdZxphu1iU6VvsVMrLyOefgdnpc25102oxNzG5Kz3JMlEpdrlW7fczulnx6
	 d9eorSp6XyA4Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "linux-mm @ kvack . org" <linux-mm@kvack.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Llamas <cmllamas@google.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v1 00/16] mm: cleanups around unmapping / zapping
Date: Fri, 27 Feb 2026 21:08:31 +0100
Message-ID: <20260227200848.114019-1-david@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CF21140004
X-Stat-Signature: 335qyr5xmtthoxkai3r7d15jx1mscin6
X-Rspam-User: 
X-HE-Tag: 1772222949-380731
X-HE-Meta: U2FsdGVkX1+eYqq61NzYMqe4E/lyaYU3ERVgOhNOn0/KNyqa9nR6CDO/aNz9UX6GrN+QG6/sQ+vIQwFS6Jj5KaBFWcA5Rn0ZQxuZv99NSgNn3EhgmU7Q54dh7HrXmEvzInOCvsuYS6vXL2mbj7CVqLRQXZCsJWZcg3UW1fpDBoGUZy3bKevYMXInnz+CrqI/GmKqWBiElZXNG9jGKpl3Hs69gRmZRq6GX12Po4MLi//PhISEyldgENX2JxC68Lf0nQSKMZMrXRqjE7BiwtcNcn7UmSq017XuUDC1+eAkp2OKya/9Z/xjlvbhysXBTy2k3IItg4D68b0l1Tp9Z2WC4wO4M5k5wXji7qTCmcN9AO/l2H4J5RFeP7HUxukPpy1xRvqzqeyBTeYDZZkmry1wnJyZCD/m205ujDj5N4g/weAnbNZzZsixR+dP5d+Xe90o2wEfS/S07/JMN1RAy+L4Ht6hKCVOu9A/zs6qIMs/asfxLD2Ne0sRFIslI9fkIsbVP3Yg/kebuLGa8Tm6VPzISfnPrw5ue5K/ytVo9zVwHz5GX/tjrDXD3nHaGWHCAXtGGGn45E7/6rm/vrFFeOg0yd341KUK+9YW4zwLxCpNHYrp+Lxs726kiTUJeDZGoo3/3+80jHX7SQl2yT12l2RY9wbuyRBAB/f6+EIWuXTn6U5zrlEIJhk73oMz/73l/YJyeL72HlFYDnc+FA9pnxlpEeVR9uDuVe3FtL6NP0Z4/aCi8L/UgeQ0C5eDS4J4Ywdx9v1aksqDRWRLtjyThJ8nlLpJjGiZA38Ol410EphM15rf3GiwtXKPEeg0avL7DgQdy3Dk6XXfs2BJzLZ+/6lFAucD0vjndUjGLNGWKfthC+LXlIjlxZV6OqBSUag9+Op1kWsPuZIRkiKg/QwToW9wBtNL5zjsurd77TMBhX4EQFwTjTxCojzg6UmbLYEH6WNvQjqQFBYlk/gw0pFVJ9I
 sQ3HYXTP
 HXoNBRYY0AO1ec+gImnc4PUAItABw70EGE4w5yop3PXQTDRp/YAHqm7dWx4CuOD6gcvD1JdxMCoCAzCTDS/Yn+ME/Fk1Iu4VbZNR0MTzP6p/1rJJ8Hla+6qSDPHurHL2C+y5jJ5bVrtXz9Ec3knxdQVhNOJsheHlCH2/si1arn939peQQXVxztKMcmaexuNufR6lNz675w3S3SQUg4WTBPJdjFHYhZI0GNqnM8XkF1DXPxzER6DqKf49yJtlCcecAtxbNEJHPBqfGcBdfI3e6ag2ug9ynO3qRgys5mtNBPWPtolMpKoxkSLqKAvPi11/rsEBe9Qas+7XIhiLDCB08QE4O1XAYfraBymzND0Lk4HgLLrrYtCw9j7cNPQapJDl9Qzbeot/zP7SbELJoV1iuTP++OaCr5tikRbP1fOlfyHd5xQvIuihRR5MQD9/J59jiMLCpI/vv9CUeuA9VtFmNRwbcgc21i+fe92/RSO+P+g72bqpvxS06z7IkpFojMdjDq9ZNNxkoHQqlvHDDjOL1Wwya/e0iPkkSg22Sh6j0mi5DAWxMvZkfLmHqgbVFuDKL6yt/fHjOrfJup/OxDCchdeZ036JLTf/mLzhXOFva2/20Ng0vi0JhkU9Ogk52qntiMgaM37I+Nb7G12WDSerHX1SqpT/rusX5lrkWddLoD9HTGhaN6qhfnAiD0i9RmNxoBsO8qDoERAgqciqme0dZmkSD/fZJiDtmzcrzPjfxo8L6Skflcuh2CuSQuIKhzvzVd66S8HLbu6FBHqfrhtF6KdIr8MmhmGnX21j8eRDY5YaI0J26LqDItLeY90OC0q0XXgfOoWwRjQiP9uVZInlI7ecVHVEcSqimy24j8GVeTHG8MeXhWP5ZY99ZzBehZ6aGNl1/YzWUJYmlC+qgOiR/Gb6iQyDr2TwjNQ/DQO0A0pRv8Y7ZxRUUhhDdyPyO10H43OgWs5ORvgxGSRcoBBJBbrLQ+EfW
 2MNQmrwg
 N0vipAG4LlxDo41ms/4eX+7kEyrdwa2nln8pr000UWiFRytD2X2GJrvIicKsYhZ4WA4yl0ild/dma6RRZGee9XYhM9QbRciE06Q/PmkaGL0IE6jPJceoKymwVD5QXIJdETpxhDW7wrxxzy4NxqHHmEPwPLvi4Hiaqvd2BGqtROlmkudR4Sm+Z6haIg3wOm/7XsaccZawa6XTayZqHHHDxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A bunch of cleanups around unmapping and zapping. Mostly simplifications,
code movements, documentation and renaming of zapping functions.

With this series, we'll have the following high-level zap/unmap functions
(excluding high-level folio zapping):
* unmap_vmas() for actual unmapping (vmas will go away)
* zap_vma(): zap all page table entries in a vma
* zap_vma_for_reaping(): zap_vma() that must not block
* zap_vma_range(): zap a range of page table entries
* zap_vma_range_batched(): zap_vma_range() with more options and batching
* zap_special_vma_range(): limited zap_vma_range() for modules
* __zap_vma_range(): internal helper

Patch #1 is not about unmapping/zapping, but I stumbled over it while
verifying MADV_DONTNEED range handling.

Patch #16 is related to [1], but makes sense even independent of that.

[1] https://lore.kernel.org/r/aYSKyr7StGpGKNqW@google.com

The CC list is already long enough. As these are simple changes to
drivers/arch code, I'm only CCing maintainers of all changes but only
reviewers of the MM bits.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Arve Hjønnevåg" <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Miguel Ojeda <ojeda@kernel.org>

Cc: linuxppc-dev@lists.ozlabs.org
Cc: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linux-sgx@vger.kernel.org
Cc: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-rdma@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: linux-perf-users@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: rust-for-linux@vger.kernel.org
Cc: x86@kernel.org


David Hildenbrand (Arm) (16):
  mm/madvise: drop range checks in madvise_free_single_vma()
  mm/memory: remove "zap_details" parameter from zap_page_range_single()
  mm/memory: inline unmap_mapping_range_vma() into
    unmap_mapping_range_tree()
  mm/memory: simplify calculation in unmap_mapping_range_tree()
  mm/oom_kill: use MMU_NOTIFY_CLEAR in __oom_reap_task_mm()
  mm/oom_kill: factor out zapping of VMA into zap_vma_for_reaping()
  mm/memory: rename unmap_single_vma() to __zap_vma_range()
  mm/memory: move adjusting of address range to unmap_vmas()
  mm/memory: convert details->even_cows into details->skip_cows
  mm/memory: use __zap_vma_range() in zap_vma_for_reaping()
  mm/memory: inline unmap_page_range() into __zap_vma_range()
  mm: rename zap_vma_pages() to zap_vma()
  mm: rename zap_page_range_single_batched() to zap_vma_range_batched()
  mm: rename zap_page_range_single() to zap_vma_range()
  mm: rename zap_vma_ptes() to zap_special_vma_range()
  mm/memory: support VM_MIXEDMAP in zap_special_vma_range()

 arch/powerpc/platforms/book3s/vas-api.c |   2 +-
 arch/powerpc/platforms/pseries/vas.c    |   2 +-
 arch/s390/mm/gmap_helpers.c             |   2 +-
 arch/x86/kernel/cpu/sgx/encl.c          |   2 +-
 drivers/android/binder/page_range.rs    |   4 +-
 drivers/android/binder_alloc.c          |   2 +-
 drivers/comedi/comedi_fops.c            |   2 +-
 drivers/gpu/drm/i915/i915_mm.c          |   4 +-
 drivers/infiniband/core/uverbs_main.c   |   6 +-
 drivers/misc/sgi-gru/grumain.c          |   2 +-
 include/linux/mm.h                      |  23 ++-
 kernel/bpf/arena.c                      |   3 +-
 kernel/events/core.c                    |   2 +-
 lib/vdso/datastore.c                    |   2 +-
 mm/internal.h                           |   7 +-
 mm/interval_tree.c                      |   5 -
 mm/madvise.c                            |  24 +--
 mm/memory.c                             | 217 ++++++++++++------------
 mm/oom_kill.c                           |  15 +-
 mm/page-writeback.c                     |   2 +-
 net/ipv4/tcp.c                          |   7 +-
 rust/kernel/mm/virt.rs                  |   4 +-
 22 files changed, 162 insertions(+), 177 deletions(-)


base-commit: df9c51269a5e2a6fbca2884a756a4011a5e78748
-- 
2.43.0


