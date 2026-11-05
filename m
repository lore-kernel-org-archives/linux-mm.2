Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3876606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aE+anxcK
Received: by kanga.kvack.org (Postfix)
	id D72516B05B4; Thu,  5 Nov 2026 16:31:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D497F6B05B5; Thu,  5 Nov 2026 16:31:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C60AF6B05B6; Thu,  5 Nov 2026 16:31:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9DA496B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:31:42 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17E92C0C15
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:31:42 +0000 (UTC)
X-FDA: 85402362444.27.A30877C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3616D100002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:31:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aE+anxcK;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=l/XBPzIruKyaT68fHsJTL6/0Y1whGy5OpPSy6WgTELw=;
	b=cug9Dyy4PfKuPwbb7J+ea6ay6U19tQ9204jZdfPaqvmacl45HYZ96FHtPnwzvxHdAzQBI/
	+rgMl7HJURAevxIci+IK8ZABp/skIfAXb3i0txF32dKudUW0OcKOnMJXNbmtTy3khXuVgi
	OHLei3cc/W0wJpyIGtPzK144nhXL3f0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aE+anxcK;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914300;
	b=RTHc6M+YjSypd70dYzKCOYJ+fWc4t7RHzyl/QSSf9vq9zMBD8lVIy3LGyc3BW9forVAjsa
	F7m6oK4T0PEpfjfnp+CP5AUiCDmMUbBCO0jqlaPx76NuVjiWI3dgmkaBBmmhUHrGmyVYUK
	jji3+uCUz7tXfy7V8x0K649U85QRia8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4864140649;
	Thu,  5 Nov 2026 21:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747CB1F0089F;
	Thu,  5 Nov 2026 21:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914298;
	bh=l/XBPzIruKyaT68fHsJTL6/0Y1whGy5OpPSy6WgTELw=;
	h=From:Subject:Date:To:Cc;
	b=aE+anxcK5DVd4PxfaPeug+8Go7oXIkkyd0cr7QF/UCjgq9jQl+bNK0q+4BhKrFU6l
	 nH9TpbM/0AmUyIRXZfMR7+ZGUYkgq1BDmA0gMwCZlN+dq+z3ta162TfttOjx4fBrgt
	 5jqDEBSY60zS13wAtaGgurmcThNfq1GYkCiTlr6kkqTQkdSz/nP1SkszH09Zyo8Vxs
	 gkd/MAkUnyzsOIfsT4YNgixR1lw3gB/K4VRz5l4xVnYXGhfODUOU8wO+APAcsQd4VM
	 pobOy+eE76XoFeivYZrQgxoRdn9FhNGDUTwlg2/ulGNDaKNWkzGWtu8Q8T+PXTf1Xg
	 PFYf3vnSp0ZNg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH 00/13] mm: continue vma_flags_t conversion
Date: Thu, 05 Nov 2026 21:30:51 +0000
Message-Id: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MSwqAMAwA0atI1gaMlQpeRVyEmtaAP1oRQby71
 eVbzNyQJKok6IobopyadFszqCzATbwGQR2zoa5qS1QRznwIfsJzYfQzh4SNpdYQW2OdgVzuUbx
 e/7UfnucF8MbcSGUAAAA=
X-Change-ID: 20261101-late-2026-vma-flags-461731a636c3
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, 
 SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
 David Rientjes <rientjes@google.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, damon@lists.linux.dev, 
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3442; i=ljs@kernel.org;
 h=from:subject:message-id; bh=dw144I8hKInR8Qv8iKnjrU9/3cK4949dnMwWVIcVGbg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLefF0a6K1vw5BxVPUqn46M6rZ32+yPLM/K3OK58Z/1t
 UlJ376qdZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiQn8Y/scXBihtmHE7PkF4
 5fTvjHX5lf8yagzLot8b3ry68ZZUJgcjw8Jnxy6ELVt+JnMKc9vFq+wXXtq4lq3/3aB8muuMQpi
 TOR8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 8fa41f1tyjgzg7ot8aw9ffcfdehttpif
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 3616D100002
X-HE-Tag: 1793914300-63427
X-HE-Meta: U2FsdGVkX1+WDzLAC3c1Wl/J9rai48KjjccjtdEaZkMJebwMpfyfBBMGNjLmL88AQlM/0cImrlUtp0+Q7o7uObZp6EuJ/SQy4MjCJ3nYBJzppThm47d17Silln1fH/TJp1y5Q5L6Wr9axrboQQg8xqVB94yQemYuGs+Plhxhq5TPwmn0gt0y4bx1sUz10C76MKrRwtIexycUirigcQ+qZmALDtlaWrN1k+HyJB6YbLZas793LfaVt/vE5j//ymrliBGQDOICl++f6Rv9nbyI4C3RQ5TkgbUlLqrmT64ZNZatVG35t9AwtSXWhOdzebq574p4CJHryc7lsMkRojkRnMyLSRZqRPMuZqrySQ4cnIBgoFYh5Bij20KeNOjsgMpCNgtZoP6UDiwEz71dYC0gJIO7as+0uH9dpu00O0pzlcGuah7NKZS0ThDXUyA2bHYRDwIsxOPer5CSHpe7x9veW5+oiRjKv73jU5XHA94R1ynWj4cuAmLuV4vhLLLQgFSRFjav1h5sPJwZtHTQt3OqwnXCOVMHZMIDC54NpoY6AhxAQexGTvwt+wTptFBAwdLxJRIMQ5Ca4VxTW74bhzvreQFfmEvC88TPTV9SO8/WQC+BtJisEqsvWkUBR2Kp0ATLxXP0zjipOk2OFAVZ0H8vV7/m42mWe1riV5L+yV73JBlxf2E4pke5HHYTZvbRTuVwvSKfMRENO7sPBOtMuScfpBbJxhrHKCst+yoNwH7KpuY9Msirx49dWkttTECeUrvm4FpAzoGHPRXhsM2bpOK0FDTKkoP874Qm7RIVMFDElNK4cVja4ZaXxpUQUUYCPOE9p/npTSzFGoj7KPZ9wGKuw9/tNTm/kep2e8WPmyM17QOjQiB4DMeH6ZOY8SBTvbt6LJSNHa9Wf9ShZUxR03jM02skyBVQpmv2Qb6LcUufwWY6+uGEmizMFEMTFFJayYvj/DcTR3FkWp5woWUj+lZ
 jm/KwaU6
 4FGsWD9Wgr9lGBVtkrzDQB2zHvrfGL6hglQKvyGZF47AKtARo7+eL1xVYnbUoUQtNIfHC5usibfLTLuBIyKVnnPi3S/iCtHa0lV0Iz27gisPZ253AxoBp1IWzOVT2f/rhJh5hxyDYqN36XsyzxtYsVnT6OghrbAH2e0SVYmYwRZdfvhzUyKLhjIJFLfSn1JKqV1BgQP2EaePwEXfJkPFCOtQxrzib+nvYgre4FCc3WDljJuDC2kBU8V4UlMNoXnbElO+4Taig83e6/rY7XxPTuxyMp2hTkk11NlhzjzC6Om2Nre2JtLcR/LULG4OcDEql6C9VxJKG5g3NCNzpEaEzLXz0uBur1WFBa7USpVd3QFt77s02VgBlkRSA0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Continue the conversion of legacy vm_flags_t flags to the new vma_flags_t
bitmap type.

Do some more core mm conversion (we really should be the first to
completely move to the new scheme :), but also update some mm-adjacent and
otherwise straightforward cases - /proc/$pid/maps and friends, the coredump
VMA dump size logic, uprobes, perf and LSM mmap/mprotect hooks.

This series only makes strictly mechanical changes to keep things gentle
during this very busy cycle.

No functional change intended.

Build tested on x86-64 (allmodconfig, each patch individually), i386,
arm64, riscv nommu and ppc64le.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Lorenzo Stoakes (ARM) (13):
      mm/gup: convert GUP code to use vma_flags_t
      mm/filemap: convert fault and readahead logic to use vma_flags_t
      mm/rmap: convert remaining VMA flag tests to use vma_flags_t
      mm/migrate: convert VMA flag tests to use vma_flags_t
      mm: convert THP VMA flag tests to use vma_flags_t
      mm/ksm: convert VMA flag tests to use vma_flags_t
      mm/madvise: convert madvise_vma_behavior() to use vma_flags_t
      mm: convert miscellaneous VMA flag tests to use vma_flags_t
      fs/proc/task_mmu: convert VMA flag tests to use vma_flags_t
      fs/coredump: convert vma_dump_size() to use vma_flags_t
      uprobes: convert VMA flag tests to use vma_flags_t
      perf: convert VMA flag tests to use vma_flags_t
      security: convert VMA flag tests to use vma_flags_t

 arch/powerpc/kvm/book3s_hv_uvmem.c | 10 ++++----
 fs/coredump.c                      | 16 ++++++-------
 fs/proc/task_mmu.c                 | 43 +++++++++++++++++-----------------
 include/linux/huge_mm.h            |  4 ++--
 include/linux/ksm.h                |  4 ++--
 include/linux/mm_inline.h          |  2 +-
 kernel/events/core.c               | 26 +++++++++++----------
 kernel/events/uprobes.c            | 12 ++++++----
 lib/test_hmm.c                     |  4 ++--
 mm/damon/vaddr.c                   |  2 +-
 mm/filemap.c                       | 24 ++++++++++---------
 mm/gup.c                           | 45 +++++++++++++++++++-----------------
 mm/hmm.c                           |  6 ++---
 mm/huge_memory.c                   | 32 +++++++++++++-------------
 mm/internal.h                      |  2 +-
 mm/khugepaged.c                    | 18 ++++++++-------
 mm/ksm.c                           | 22 ++++++++++--------
 mm/madvise.c                       | 47 ++++++++++++++++++++------------------
 mm/mempolicy.c                     |  4 ++--
 mm/migrate.c                       |  5 ++--
 mm/migrate_device.c                |  8 +++----
 mm/mmap_lock.c                     |  4 ++--
 mm/mremap.c                        |  2 +-
 mm/msync.c                         |  4 ++--
 mm/oom_kill.c                      |  4 ++--
 mm/pagewalk.c                      |  2 +-
 mm/rmap.c                          |  8 ++++---
 mm/vma.h                           |  4 ++--
 security/apparmor/lsm.c            |  2 +-
 security/integrity/ima/ima_main.c  |  2 +-
 security/ipe/hooks.c               |  2 +-
 security/selinux/hooks.c           | 14 ++++++------
 32 files changed, 202 insertions(+), 182 deletions(-)
---
base-commit: b61fa14ce6bcbba2cb9a96feea31b760226d6b43
change-id: 20261101-late-2026-vma-flags-461731a636c3

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


