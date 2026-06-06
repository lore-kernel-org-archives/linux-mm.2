Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40D28CD6E75
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 03:50:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B9646B008A; Fri,  5 Jun 2026 23:50:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08EBD6B0093; Fri,  5 Jun 2026 23:50:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9E736B0005; Fri,  5 Jun 2026 23:50:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D920F6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:50:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 31CE1120365
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:50:37 +0000 (UTC)
X-FDA: 84848110914.23.4FCE2C7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0E90414000F
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:50:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="s/SzQXgD";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=17k+KsaE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="s/SzQXgD";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=17k+KsaE;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780717835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/83iEfioFt974ERLFFdypfnzGP9tlZXs6SCesUBJTCM=;
	b=MxVfnSERdaFXbjuCM0rmBWtoKtAqF2Bik47KX3NTQqthJrPyVvILwAQ9GCVL9KNs33NJ1r
	mvrOWYV8MiNSRt/hlhcMpInO0RsF0wVl85d5kOjBecxS5Jm9hnCFxjyC/0Mx9smkBbxB7N
	y8lGKpDAr1bx0C+Mh0DrQUMzlUTfc64=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="s/SzQXgD";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=17k+KsaE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="s/SzQXgD";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=17k+KsaE;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780717835;
	b=vtMOtCPfhaowO+uJ4t7ZuQQewEN1hnNcQBy7Hs/UkKW0b+SWZm5hl6N52llEaDZfuQAmcr
	kLHGcZY8xJxu42qT//Lxj2i3Lg/UUNIs7l5zhCQE4HQjVV8B+026bTiInOFOnKD8vytQGl
	qYdGS0hbZcNF5dXa2iQNuzFz+HiH7eI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4CB3975BDB;
	Sat,  6 Jun 2026 03:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717833; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/83iEfioFt974ERLFFdypfnzGP9tlZXs6SCesUBJTCM=;
	b=s/SzQXgDQeynUvzgMXrhzdTlSVabsBN0SMV1zziJI6JaapxIryL92kAWZJvrDnPNYenCEb
	gBOyFptk+QwIQtwD3YJwCTtnVhbBJKwpB4LQGqkZOC7hrS/HAfYKNEOB4YrDP1iBwIiTJR
	XGEWfrDxnt9J+3QIEMjvHV0a9zFWIEA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717833;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/83iEfioFt974ERLFFdypfnzGP9tlZXs6SCesUBJTCM=;
	b=17k+KsaEbkzK8N3myYCe77qbAyQ4bWgEXjDlPC8B1eMhAUjhhgKwihl3FumpDYPLrFCDrm
	BDFNFfrANXwmezBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717833; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/83iEfioFt974ERLFFdypfnzGP9tlZXs6SCesUBJTCM=;
	b=s/SzQXgDQeynUvzgMXrhzdTlSVabsBN0SMV1zziJI6JaapxIryL92kAWZJvrDnPNYenCEb
	gBOyFptk+QwIQtwD3YJwCTtnVhbBJKwpB4LQGqkZOC7hrS/HAfYKNEOB4YrDP1iBwIiTJR
	XGEWfrDxnt9J+3QIEMjvHV0a9zFWIEA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717833;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/83iEfioFt974ERLFFdypfnzGP9tlZXs6SCesUBJTCM=;
	b=17k+KsaEbkzK8N3myYCe77qbAyQ4bWgEXjDlPC8B1eMhAUjhhgKwihl3FumpDYPLrFCDrm
	BDFNFfrANXwmezBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 637E1779A7;
	Sat,  6 Jun 2026 03:50:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zDDOFAiZI2poQwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sat, 06 Jun 2026 03:50:32 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Karsten Desler <kdesler@soohrt.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S . Miller" <davem@davemloft.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH 0/8] Stop special-casing hugetlb mappings in get_unmapped_area
Date: Sat,  6 Jun 2026 05:49:55 +0200
Message-ID: <20260606035003.529685-1-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0E90414000F
X-Stat-Signature: snzcf3othnecdq8xz76fwj6d4dsgkn7r
X-Rspam-User: 
X-HE-Tag: 1780717834-100605
X-HE-Meta: U2FsdGVkX18nwrfi/qxCzB5KjRB+d8n0KJtwogMFCqCzNEmHCD6SI+20ycrSQajf2D8Ph25xqKdWTsneJM8zJ2PfDb8CJpwqzuDF8nqAAWqgv3KNkF9iJV4OyEXKW/C4/6c+Dt/ncwNpjw+awk8GlZAC+wlIYym/o/jX+4CJ+rX5v1a2XtErJ8VnMWoqp9p4ZhOJCIIfx+XdpjaCBqLe9C32gaBjpLZr6UpQm7Tq4zXtw7EtNrR16jZyIUmKj7J7lgDN6AHba+g28F0gxeouMa+NLH0b6EOUowoKaRaSZzDaeM2WeEhH5QePxqE5H60sd3QkeLCOwM/DlT//IBjwO+RtdboTEZkfMY9LnmEVwZ8n4izz0GvaaKKa92WL8ccAXbuIUkUOAR+J8OeMQXVsqqg7g1njFbA86/s3hBS5CgL4YV4nXLMrWnRAXMpwwbVIrMCx5eyNT68rVHFdbG15YKGS+F/K85O2fOGyKABRtRXhFIbYvKQBAfsP/MWCV1Tuz0iRSjXq+21Dm9rncoo5DzJZV6rv/wzR5jnusli3SBo7A087vfxbqowrDWNWPZpDhmWmR8iAlTvGtPCAw9Cc6v+kujl/cgEy6/WoszLFxB7d6eybMN/e1ifV/AcjG2yJ2yB+WsYK+jR2QQh+LDMbhj/p2Nswj2vjkMsMmb5Qz+Z80gq6W4fibSM19/vDCwEKYAW9VqQ5TWPu53CLl+Pdp9mBzzZjxJfQgrXsKjBb5Nlb4upvEbFXjTNsmNboolxhBon+LTPS/gpHrUsKK1vOU17NYx6QDYj/kYFxg96dC376lpyQSLvk8OWVOChjsXmwzBhLYZgLqHPJYo2bwObH4yxxDirsUy4plS3LFNo9EmHl0DL2ba9e13fl446RY5HQBYbmdLkwyC/UR/xtwBR6e7ZMUTp6Q9lyIPFabjBrO+gw/xqT8U+MpBGoeSNltL5389CvuD2Ahwy/E5hjtml
 GwiqMZeg
 SRU3BGlXN8dEQ/3Xe/JlmTgJTx2kuI7hgi8ww4nm9boaRz3dqoDfc9+KSSGWNaIo5Fv363cRBifEIsmnC/yKbgJlmv6RMUX70oLxAxfeRtldqf0RcObyVYxA28i1+lk/1P0TEp/c8YuGurjkBNHbG8KmNPVzXqBgAMSGAgd3oOUlPGpnxHAxYgD6JMryvtPoZKFZikdzeRWmrRLKxtaxWYUNLcu+skf42Fufhh76xkkMMKQiKDq5FbzBdHuGNI1eRs2IgQhBxbJLAm0htWml8k0ke9TXZ5VoeqfgFrQX+25Blf6OpuNave0zjhtlgYgYdV/vyYE3QjVEfjeQDiIzzi/PDzy2mF7ciuecanXhH8Wys1IbDk95/irIR1pGY1srH7JrGBrApEfH5vF3TS0iFMOs1l6s9X7fvPmUl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


A regression was reported on AMD 15h Family for hugetlb mappings when 'align_va_addr'
is set [1].
Historically, for hugetlb mappings we always ignored 'align_offset' in get_unmapped_area
functions, but after commit 7bd3f1e1a9ae ("mm: make hugetlb mappings go through
mm_get_unmapped_area_vmflags") that was no longer the case for x86.

While we could fix that by work it around in x86 code, the truth is that the current
functioning of hugetlb mappings with get_unmapped_area functions is a bit clumsy, and
we can do better.
This patchset aims at two things:

1) Fix regression reported in [1]
2) Stop special-casing hugetlb mappings in get_unmapped_area functions

Fixing the regression involve doing what we do for THP mappings, which is encoding
the extra padding we need for worst-case-alignment scenarios directly in the 'len'
parameter and stop using 'align_mask' for that matter.
And then, mask off the address we get from mm_get_unmapped_area_vmflags.

After that, since the set up of 'align_mask' for hugetlb mappings disappears, this
means we do not have to be hugetlb-aware down the road, and we can stop special casing
it.

The only thing to note though is that depending on the architecture, we sometimes
use 'align_mask' to do coloring for pagecache and to avoid cache aliasing.
This was ignored for hugetlb mappings, but after this patchset that is no longer the
case, so this means that 'align_mask' will be added on top of the requested length
of the mapping, making us to allocate a larger(ish) gap in the mapple tree, but
that should be harmless as most of the times that is PAGE_SIZE, and whatever
the offset is will be masked off in hugetlb_get_unmapped_area.

[NOTE]
Patch#1 is v2, since Dave Hansen was kind enough to provide some feedback
in [2] while this was still on the works.

[1] https://lore.kernel.org/linux-mm/20260527143643.GO31091@soohrt.org/
[2] https://lore.kernel.org/linux-mm/bae37c0c-f9e8-486b-a1a8-53c9dc0af8e0@intel.com/#t

Oscar Salvador (8):
  mm,hugetlb: Encode extra padding for aligning directly in
    hugetlb_get_unmapped_area
  mm/mmap: Stop special-casing hugetlb in generic_get_unmapped_area path
  arch/x86: Stop special-casing hugetlb mappings in
    arch_get_unmapped_area
  arch/s390: Stop special-casing hugetlb mappings in
    arch_get_unmapped_area
  arch/loongarch: Stop special-casing hugetlb in
    arch_get_unmapped_area_common
  arch/sparc64: Stop special-casing hugetlb mappings in
    arch_get_unmapped_area
  arch/sparc32: Rip out hugetlb from sys_sparc_32.c
  mm,hugetlb: Kill huge_page_mask_align

 arch/loongarch/mm/mmap.c         |  6 +-----
 arch/s390/mm/mmap.c              |  9 ++-------
 arch/sparc/kernel/sys_sparc_32.c | 16 +++-------------
 arch/sparc/kernel/sys_sparc_64.c | 25 ++++++-------------------
 arch/x86/kernel/sys_x86_64.c     | 15 ++++-----------
 fs/hugetlbfs/inode.c             | 25 ++++++++++++++++++++++++-
 include/linux/hugetlb.h          | 10 ----------
 mm/mmap.c                        |  4 ----
 8 files changed, 40 insertions(+), 70 deletions(-)

-- 
2.35.3


