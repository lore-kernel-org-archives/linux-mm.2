Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5126C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 12:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 761DE6B009F; Sun, 23 Aug 2026 08:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7392F6B00A0; Sun, 23 Aug 2026 08:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679876B00A1; Sun, 23 Aug 2026 08:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45F536B009F
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:17:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFD1B802D6
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:17:51 +0000 (UTC)
X-FDA: 85132435542.17.6898B2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 01A04120006
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:17:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=incwjgAz;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787487470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=isHahu0jRpz1uJRo3YiAtHQCbGtLanBl+0E0+Ww+aJY=;
	b=kZLoDu+1EpbY5KaJQXsut4HvUcVF6HpbwEBR1MePyTlUj5IZs0ByJIRWZ8+pdFc4jo15J8
	6k/mNAWyc7i5ES/fTIDO2SHfpnBW66u/DbckrjiDXpV152DWKwAiCBfF+hQ67ScbdhkV97
	kqIg8Oom0D3z72Ea/UUHm5WtTmKLLLs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=incwjgAz;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787487470;
	b=fIcUi5kO8PsYoV9EKTtG7AuXTy2ZGYVfkoF2Ql0OhmHbUfWmCtFAyQxg8PEGbtRR9nlp9Q
	s0b5sI4CqOjX8hn7gi3Ygo83pJcXKkz77GMRVfdMaOfZV+XEMOSyMaEme2eziulJkHe6+v
	odHIN/rAEDQhGtWTgHp6k/4tsk+UzaY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F3EC41A9B;
	Sun, 23 Aug 2026 12:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615CB1F000E9;
	Sun, 23 Aug 2026 12:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787487469;
	bh=isHahu0jRpz1uJRo3YiAtHQCbGtLanBl+0E0+Ww+aJY=;
	h=From:Subject:Date:To:Cc;
	b=incwjgAz5Ue8ij1brw1X3z2ppJxMCEPKvIC3rX+6eD2cf5WTGs4dVlnC2PKtLi5TP
	 BtSRA5GJLHQMzRwlD/TTjJBV2nWXFc1tFOFl0b/XrLncxN2MA1ulizkXqmkSLbzX0U
	 2N8k6dbYZ1MInvsdysbJBV0QIObtMDHJGZQOuyYSpOR4B32mGWI0PaftaM35oXhwzE
	 UDbdYQpGfBKVVYc+ImPluq5zlYUjhit9jaDYt+C3iCY4jBrQJgHkYulR+oL4BGIkuu
	 o/UA+3eMC9dAbBjbiP65GCJD0kL2AtYqRRnrOt7Wd0uWXSbbMjyXofMnOwKy3ff3q0
	 3IqcaSoBw6X0w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/6] userfaultfd: decouple uffd mode from VMA flags
Date: Sun, 23 Aug 2026 15:17:37 +0300
Message-Id: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMywrDIBBFfyXMukOjQgn9ldKFjzGxRFMclULIv
 9e0y3O55+zAlAMx3IcdMrXAYUsdxGUAu+g0EwbXGeQob+MkFVbvHbaIftUzYxNIpEgoYdQkHHT
 tncmHzy/5eP6Zq3mRLWfnfBjNhCbrZJdzinEr8Roj1sRFm5XgOL5rdDpBmAAAAA==
X-Change-ID: 20260823-uffd-vm-flags-v1-ee3e131b381d
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, 
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Muchun Song <muchun.song@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>, 
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 01A04120006
X-Stat-Signature: 6z11m4au6e83fc9yswn8xz8d8ne4gejs
X-Rspam-User: 
X-HE-Tag: 1787487469-541096
X-HE-Meta: U2FsdGVkX1/O/I0USsNRM+hNIoCShKjj58H/0wLkZ0w289U1M/PWRErzdFpW5QUzklHPhkE7CuFHyesKbs1urbA2r0O6iPwIf+72/zLloYTl6Z3RScQCj6HlNwxuLnspQIQtCIwdtRAxVdPeEG9jQca1/I7lL3ZakJim2shGivdAT2T8iXlkAFPmdmDq3WvJdp+iakmJBfWWqcixnJZkDzfAj/rAjs3MnsPqMOjJ/7RwVxij3rYZx+fXbuV81NHH+Ac+8mk7h3kZejVe5OnyWTSq+1e9nmvPLGLwH1v4SKYjN1JK60PVygpvepVCWc3PCYReS2ZSFsEDhR1qbwzJHPZaXtpj4I+UG4Z+18c3peDVuYFVHjE2ZKu58IxYkZ4aw7VZWmmQZ17tgK825svdWMi7G4rCRFfwys5kc07KA6bf6o6cdUQsuQdJVmH7ofyunX7vzjBRFgqkHQut/S+dhHU4WQVdfpcOABZi9JpJ+UuNJWV6mjm9PToZbzMn8ieBz+8Zstvry77PP3dK4qVrZgWp7zbH8nKhca2QyFlYBiMAqJh81KZOwqNZufL/1BdGIGIDBkNzsdCOEAlA162rt4Yxq8saSiC0WK7nzprpDOWJnbfUprJ82WEemFgnoMdIH85NnESJ1rXmoUgr3fDiJqM9GeVQSfBjf9BduF22NMCEZxyZnaXsS//ona6DA79fRA6/wxThJ7HfvWQwLSfAvM+9mQwNKft85Q/yHURgNqYuHR8aSwL48uqs9qcJXp8zX44SSKX0UvUypJNGejaxbKzfWCqhReI1a3/aqW6bQIOZx3vrZME2k2xPDZmsXTphlO5QkB2oey3r5o/SNOjAQ300QezR4FfVzdVEcyrnXSel50PE8r1uMkVyB2Ae21L/0p/K8Jq9dzwSku/M6Jg3o3deHkrBO84YdyE6DZXQKguEKvoab3v0Y738TBzMts+nAvg0HY3U/L1+Suhcmzi
 FE+4ZHX7
 6Ldg+GYnr50gmV5CApmyvrrX+DSi9fp7bhIshF5LqUrUDI8nAMYU8n+UELkZ9O9y5Ja6PWrZdDVeYUVWDkckKcFPfcYxiC9CasD2Qlr97fbuVv+tnL+oHapK9Fv0r+yrG6lu7mS2gPhP18qIase258NV7hgz8DCpqL2uL0amrRks/5OHMLKUllC4hsENHDRA2Pc71OldFHLLftxM81mIsWFznzP+rb2kG4QXg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently userfault related VMA flags have multiple meanings:
* identify VMAs that are registered with userfaultfd
* and also how exactly VMA is registered with uffd
* and also communicate kind of user fault between the page fault handler
  and handle_userfault()

Introduce an enum for user fault reasons and move the registration mode
into per VMA vm_uffd_state structure today known as vm_userfaultfd_ctx.

---
Mike Rapoport (Microsoft) (6):
      mm/gup: move gup_can_follow_protnone() to gup.c
      userfaultfd: constify VMA parameter of userfaultfd_*() helpers
      userfaultfd: use userfaultfd_*() helpers instead of open coded flag tests
      userfaultfd: rename vm_userfaultfd_ctx to vm_uffd_state
      userfaultfd: decouple fault reason from VMA flags
      userfaultfd: collapse VM_UFFD_{MISSING,WP,MINOR,RWP} into single VM_UFFD

 Documentation/mm/process_addrs.rst |   4 +-
 fs/proc/task_mmu.c                 |  18 +--
 include/linux/mm.h                 | 105 +++--------------
 include/linux/mm_types.h           |  11 +-
 include/linux/pgtable.h            |   4 +-
 include/linux/userfaultfd_k.h      | 155 ++++++++++++++-----------
 include/trace/events/mmflags.h     |  17 +--
 include/uapi/linux/userfaultfd.h   |   6 +-
 mm/gup.c                           |  39 +++++++
 mm/huge_memory.c                   |   6 +-
 mm/hugetlb.c                       |  12 +-
 mm/khugepaged.c                    |   2 +-
 mm/memory.c                        |  16 +--
 mm/mprotect.c                      |   2 +-
 mm/mremap.c                        |   4 +-
 mm/shmem.c                         |   6 +-
 mm/userfaultfd.c                   | 225 +++++++++++++++++++------------------
 mm/vma.c                           |   4 +-
 mm/vma.h                           |   6 +-
 mm/vma_init.c                      |   4 +-
 tools/testing/vma/include/dup.h    |  20 ++--
 tools/testing/vma/include/stubs.h  |   6 +-
 22 files changed, 323 insertions(+), 349 deletions(-)
---
base-commit: 4b2ae13f3393ef4b4bce0021e8762790354f369f
change-id: 20260823-uffd-vm-flags-v1-ee3e131b381d

--
Sincerely yours,
Mike.


