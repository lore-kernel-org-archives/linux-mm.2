Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F0C0C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 10:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 794AB6B0088; Sat, 26 Sep 2026 06:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746BA6B008A; Sat, 26 Sep 2026 06:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6352F6B008C; Sat, 26 Sep 2026 06:41:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9EF6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:41:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A1CCE1A0841
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:41:24 +0000 (UTC)
X-FDA: 85255571688.17.ADD89D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id DFCD6180005
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:41:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ir0K3VQu;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790419282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TZRBqF2yMAgyYQEkKpNQPhn7mCO9yemFSVQUeDjssXc=;
	b=MoJ0LOsKBZ6c0fcwBSEuQVGKcV+gxh6jhwQT8lHxJ3pfNCE04fpvb+aKfAYq2eKjecQJ2W
	6G7n7hkp61eV7CMkyRfmog3dVIGqRTsCt2k2QES7BMfZPB9LN/Tm3Dl8TbvnKT0Hym82Xm
	J/ZLA9N59kUkpKcBgkk8YjYIpasHi7g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ir0K3VQu;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790419282;
	b=8i3DvZkoxClX4hUkkjkheJ3Zzg0ZRE1K6tBkvgqfNJ9zfiTOwyMEJxWE/vCFpvsw7AATOR
	UGN+4GgvkrUUefm3t15spxCWpOgJjKuZr7K7xeYlyuxVaujlp0Os/ogFw6bbwQa7NHHQID
	cppdhYqU0jJWpYiRrL0J8IFtwXQzU1w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 09B426020C;
	Sat, 26 Sep 2026 10:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F2D1F000FF;
	Sat, 26 Sep 2026 10:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790419281;
	bh=TZRBqF2yMAgyYQEkKpNQPhn7mCO9yemFSVQUeDjssXc=;
	h=From:Subject:Date:To:Cc;
	b=Ir0K3VQu+rpNG9WmGygjpObvd2itOXxLZnKt/4/ihMoDOen7cunLzb3YqU3wiAe7a
	 NjsUIHV2kY+lTNuqhxRJJ9TPCoVSFJed1k2aZBn3ibN6EBmXvg/e/E9CrXMcR/JPIt
	 /DfsXmhxFujrwBxSNQYcMBfeCZFW5wl3Bc9SyxST7wNcKhsj0DO3+wIH6tRos3U6xA
	 zm+faOQMvGv508ToWVBvQORwaOcNrA8XHO7SFRu9LzMb3OKm9cALiuAMQ0H6Rvo2Cr
	 ST8hIML7rskENwCmSHvLCXsbxtwB/pR9VPggLxRTUEAm3++F3il61l1+u1Pw+tfL+c
	 PamhigTv4GNMw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v3 0/6] mm: make MAP_PRIVATE-/dev/zero mappings truly
 anonymous
Date: Sat, 26 Sep 2026 11:41:05 +0100
Message-Id: <20260926-map-private-dev-zero-v3-0-d4781e84ccfc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4XNQQ6CMBCF4auQrh1T2rRFV97DuChlgEalZEoal
 XB3CytdGJf/S+abmUUkj5Edi5kRJh99GHLIXcFcb4cOwTe5meBC8wMXcLcjjOSTnRAaTPBCClB
 bqRujrWhdxfLpSNj6x8aeL7l7H6dAz+1LKtf1D5hK4GCVqZyR3KEzpyvSgLd9oI6tYhKfSvVDE
 avinKmVFkpy9aUsy/IGAqNskv8AAAA=
X-Change-ID: 20260902-map-private-dev-zero-ba36d76a2fc8
To: Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3834; i=ljs@kernel.org;
 h=from:subject:message-id; bh=fTo54dQ27lNlohXIePrTiYH+6/z9AkWMENqu+dTZcY4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2L/TUUN8nN/lnrX7ewTmPLvIYP9Cb4il+Y8aKqX+/8
 u2fGr/vQEcpC4MYF4OsmCLL8y/i+4NEwuZ1XvB3g5nDygQyhIGLUwAmotnH8M+U+b1c+1O3038/
 ilhoqYvNrdrbplbOKWPya9qtprlx5U8YGbrtdCJa50505TrzzVjlQe7v4PjpMv7C2nMPc2i0W+i
 vZgcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DFCD6180005
X-Rspam-User: 
X-Stat-Signature: xr1wtknood7xoehqji1aqfup7dnbq79x
X-HE-Tag: 1790419282-58827
X-HE-Meta: U2FsdGVkX18hQKHV+QMDNHs/slOO9QQaqYeQfsR5k0oNT1MdW+JOXieVdmQ93o/l8zHj27rWV6FnDMHsBaI/STjx5bB1OJDkHtwNq8R7/uPfVBSQWavoxOcnPTKhO4Y/l+Dnu0lU19KU40IgfmdpfSk1taekIYY5LVSnMY5jg2RELhNVikEORTDsXAMLsEeKIJBwH2cYMClERrIcAC/O4yPsICilBpf+rIu5HTvLoKVTUVq8TYKRy3F8d+MXyNHwEsPC/9KvT4jyFp5Me5lg0Id4O8OOOU6MsBRqA53NRuXshK8PV0BY+60SYlZQipYp3MO1ItSP+8lovLM2F5lzU6SK+rOzxq7GLYL4IPeG2gkI4fNGsgeVh9Xgn6xo5wbIMRNHHIlcR0BddhrM5rIHd8VP9y8mvuc1l+/x2V0G+phazhlyopO9SRvqMGii+CYkzxsp2Y9rMUKI8TJXOPyUxGHdFX4zsLouYbIxDN9IJvS/2sedBvbmkYEYs1tqS3muccVbcGdjlZFbDjlVkTTa4xAbyrE10lZ23rPI+S/CY6bbB1/VKaXjML1iO0OYLhx5T59A2YXMGgFC+AyMPOy30GLjm4Y1Ku+c3B5hzRMVrcm7Y+zS169bNkpass5TKBE/TsPlgdJxGx3h29QFVWSmX2FXTIBicPOJRCY11RXgnP3N7SQMypsobuwcDmRl4o6/0Q4uuJDVSLLTP+41qmQlGyKUOoYDROqEFAeae+A4vWX9Kc8I9a4mpo5DFkKr9dokN1q02C41++BxBOQqzTi7nqQoqSTPeG9SfUNLMj7qnIDqVotop6FIbuoNvvRIV7WvxaDz2+ECcZJg9IPle8ulpzlczKu8Vm/X9ej3il/bVFVcyK2dUWGnChhnAflBLxAsStX2U11apJXWikD/3KqwS5Dv1d66PtWXMEi4TiN+/UmE0ttMiNEJ/c7hFf9G3ZVYXll/X+wliM73VcLGBpw
 yg41igsB
 zE2KaGiTm8BxLI9hq6O18pOqsd2KUNw3SBsyFvt4hhZI2wdhp6VbltWw4rheSOPl/9gCfsZVcSYhv13h8WOqvzA8ANfwRN6TGDT6v3rvemKTZ+8BxnAkVU5K9fM2LjOABYj0rDLY5/fSHuiDtKNB3YlpgvqQ1v9iXrpe7880Wxy1BFnTecpeRnC1dc+SQSkn6xr0kSO/w4bdNLqY81+kDfMfexQo6OYB9R5VLSPLmgf9zq4+DtXYCRLtXgHRfLb9x4wAGcFzpuGId9/hAqwnx+cV8AeDqEJkxmkfX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Historically anonymous memory was obtained in linux by MAP_PRIVATE-mapping
/dev/zero.

The canonical way of doing these now is mmap() specifying MAP_PRIVATE |
MAP_ANON, but we must continue to support the legacy means of obtaining these
mappings.

As-is these mappings are an unusual edge-case - they satisfy
vma_is_anonymous() but have non-NULL vma->vm_file, and their page offset is
the offset into the /dev/zero file.

Commit 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE
file-backed anon folios") causes all other anonymous folios to be tracked
by their anon index (vma->vm_start >> PAGE_SHIFT at the point of first
fault), leaving MAP_PRIVATE-/dev/zero as the outlier.

This series remedies the situation by making MAP_PRIVATE-/dev/zero mappings
truly anonymous with !vma->vm_file and correct anonymous page offset.

It starts by bringing the memory character driver into mm/ - this file
implements /dev/zero, /dev/mem among other things and is already (as
clearly indicated by its name) within the remit of memory management.

By doing this, the file_is_dev_zero() function can be provided, internal to
mm, which allows for positive identification of these mappings.

Using this, first prevent any other mappings from mapping memory
anonymously, then make these mappings truly anonymous and eliminate all
code in the kernel that previously had to account for these strange beasts.

Finally, it adds userland VMA tests to assert the behaviour and selftests
to assert expected merge behaviour.

v3:
* Added tags (thanks David! :)
* Moved the reworked mmap_prepare vm_ops comment to 3/6 where it is introduced
  and fixed a typo in it, as per David.

v2:
* Added tags (thanks everybody!)
* Reworked comment about mappings not setting themselves anon as per David.
* Fixed up test typo as per David.
* Fixed up test close() as per David.
https://lore.kernel.org/r/20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org

v1:
https://lore.kernel.org/r/20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Lorenzo Stoakes (ARM) (6):
      mm: move drivers/char/mem.c to mm/char-mem.c
      mm: implement file_is_dev_zero() to uniquely identify /dev/zero
      mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
      mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous
      tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero is anon
      tools/testing/selftests/mm: add MAP_PRIVATE-/dev/zero merge tests

 MAINTAINERS                                        |  4 +-
 drivers/char/Makefile                              |  2 +-
 include/linux/mm.h                                 | 10 +--
 include/linux/pagemap.h                            |  3 +-
 mm/Makefile                                        |  3 +-
 drivers/char/mem.c => mm/char-mem.c                | 21 +++--
 mm/internal.h                                      | 20 +++--
 mm/shmem.c                                         |  2 +-
 mm/vma.c                                           | 39 +++++++--
 mm/vma.h                                           |  3 -
 tools/testing/selftests/mm/merge.c                 | 95 ++++++++++++++++++++++
 .../selftests/proc/proc-self-map-files-001.c       |  2 +-
 .../selftests/proc/proc-self-map-files-002.c       |  2 +-
 tools/testing/vma/include/dup.h                    | 10 ++-
 tools/testing/vma/shared.c                         |  9 ++
 tools/testing/vma/tests/mmap.c                     | 37 +++++++++
 16 files changed, 220 insertions(+), 42 deletions(-)
---
base-commit: e3b5239afe1b8f0194db7436b17c33e94c1988c4
change-id: 20260902-map-private-dev-zero-ba36d76a2fc8

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


