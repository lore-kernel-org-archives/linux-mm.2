Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87FC3F30937
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 10:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF4086B0089; Thu,  5 Mar 2026 05:50:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA1E66B008A; Thu,  5 Mar 2026 05:50:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAD636B008C; Thu,  5 Mar 2026 05:50:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C71E86B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:50:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6FA81BBBD6
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:50:33 +0000 (UTC)
X-FDA: 84511690746.02.9D1109D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id EC65810000E
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:50:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ks2WnXhB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772707831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KhG9m/1nKVNbvlbE2x8YzN2aakDEcNzRzVMeo+ykMaU=;
	b=csoBk36AAMEunVuacrJD6BlEkXRXWX5MUPauIyK+axx5Y8ViNAeyXl2eSoMtcVQ8Z3FKPC
	hZ3uVV0nRpPnnwLpHafRNqTN85b4wAk7OyvFtKCShjMmfRXeY/MOLJDdD+pJKYeTpa/f7P
	JA75ElX6/lz0ypVXSfRmvwF1ifZmFcg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772707831; a=rsa-sha256;
	cv=none;
	b=Q7TZ23dr3Wt936M31U0gYBKBpTm2B+Q7KIXcfB7O67401ckXdbG8nnG82hdyAgCVZVJlRL
	qWYU+G+0oKLzoDuJVfEvhZJeFRwr6R4KWpzqxOxFdkyRVLbJLbF9T5L/+Xc3/oyqO2DwpG
	xYpWFLpwFaBiTWBByH6Tn9QI8pdpKWY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ks2WnXhB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3146061339;
	Thu,  5 Mar 2026 10:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD7BC116C6;
	Thu,  5 Mar 2026 10:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772707830;
	bh=0/QAvDFwZi+F+9QH+vbMTA5rIfdw8VEPToPzhoxxIs8=;
	h=From:To:Cc:Subject:Date:From;
	b=Ks2WnXhBZhJYCciDsJ/Fjo8g68UnOm1+2N5sQ4oKF/kGeATt0cOgG+p7IStQiz3z2
	 EaiKLpNcYuvQR0g+WTb5buzNJSSfOvUyoPW9kVP1mxiGLOY0aaIL36Y8HeRxCRWjH0
	 xPNNxHX1xyrDEsAcz9u21dlmMcxuEfinuXRzrRvtJ7zbfASMxifc8jFI1uuXm0VkKV
	 vO8JJM2Fd72GNEUcYoWCy/ySVJ/YSjCa2F7WYjhFHDQGWKarW2sHEvezQchoGe9GZ5
	 xra3AjQzJT0q+i6jzWOOPQIuXDSNX56qDPetnPGikvlCk8ESka3PTrdJXR50wB3Usv
	 cHc1r7gvVBIug==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-mm@kvack.org,
	ntfs3@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/6] mm: vma flag tweaks
Date: Thu,  5 Mar 2026 10:50:13 +0000
Message-ID: <cover.1772704455.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EC65810000E
X-Stat-Signature: yukaqfr61rhuiskuckhuj193mc4rx9mc
X-Rspam-User: 
X-HE-Tag: 1772707831-469846
X-HE-Meta: U2FsdGVkX19aX0ayhujdc8MaOpttttMUFN/WS3clWzGXrFXHsepPl+oxRVTCNn/70bbrwKALAqTZkP0IplcR+x2lq9al1XpFLlUPZeDx2PhvPIkLCyQdlxoOxKuDia9UPZn8doGrpkP9SIZFCjqmR4PBWKocDpHVBtsWrVpUJ2lze7zvrbljkoNvrFnLb684WRSQm8RDgWzVmI1uCsBsNvbIIFkrZxMHkbBGt3eCfW3iQUrCkxQtNQ85Cj8BT3z6e6l7/gwgLGmOe09Jee5QLgbu005mH89oj1v7mbs+Ps0rf+U31BOUZjw9D3FdjRKlovxECblrVKar4aNkcsAwHMudZRTs2CkhlzaZO7cUXISIyU9w4SahZG135incrwAwBBFN0jLyQxhYPyxdUIrBncceWbhaT9l44pp5+HWDG+rLKg1ZPwGGDDo1ZWaDYMS1WKlQujiqCo0PPMlEuJlM7n5sp35gaXLU0AOTF/B8aPQ7C4XCON6k7BbdTMx1FOSsLeukdnD9FA0XL+iKRrgGEbUvWRIZsL1/EvCCOC+1Yl90EBuNBVY9G4jBNHdMt0BgmWqmsCJZan/Yl9apjTg1CFW9AyotSoJ9NeqojmrSHjwYWFd0QcJoORs81sYjccQ0M3giwXnLX/3xFiaChBg0FvRGFvFhvEc6mxqELY5I6Q47IHKB4IhbidYFUyq974lDM9qi1hNdf7pEzDHv1j3C+XghR+pez9d7Ll9T10bmfrmNY6roBAohx/R29xeTqFZaRGxQv75dO5YBBY+ZGnrP6RewsNmdLu+DOAShqcr7g+Hi3yVlZ7OVCUbboSqIoX+x0Tj7ynYBlFzzJfzMfpEhT5KFeySwAGLsfTqI/8Wd1D2UG5gDqz5I/QFfWZqpA7YltwnVSBZQfzGom24vmhzbJQzoEZ1KD2bVuLwF4ZUW9wB2CCjaLLq9wb4Cwfc8IjZa4LLvsoWroRT52ZdnKoM
 MsxxQ7i0
 Ysv02cXapeqLjttGx7EGETVYKGpl0tTGPwtZL6NN3g3dWjMff48kes5CsHYXRYJC7LanZHpx8u30u8W28SLawwU85Ft2b0fPmeUfKuQSDfZkCmXqrb28Pd5eHc5hkoL6UhV4gKRbhPNAIAIZzhhGo9gDaagen6S/OoUOenMkkOeyXi/o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ongoing work around introducing non-system word VMA flags has
introduced a number of helper functions and macros to make life easier when
working with these flags and to make conversions from the legacy use of
VM_xxx flags more straightforward.

This series improves these to reduce confusion as to what they do and to
improve consistency and readability.

Firstly the series renames vma_flags_test() to vma_flags_test_any() to make
it abundantly clear that this function tests whether any of the flags are
set (as opposed to vma_flags_test_all()).

It then renames vma_desc_test_flags() to vma_desc_test_any() for the same
reason. Note that we drop the 'flags' suffix here, as
vma_desc_test_any_flags() would be cumbersome and 'test' implies a flag
test.

Similarly, we rename vma_test_all_flags() to vma_test_all() for
consistency.

Next, we have a couple of instances (erofs, zonefs) where we are now
testing for vma_desc_test_any(desc, VMA_SHARED_BIT) &&
vma_desc_test_any(desc, VMA_MAYWRITE_BIT).

This is silly, so this series introduces vma_desc_test_all() so these
callers can instead invoke vma_desc_test_all(desc, VMA_SHARED_BIT,
VMA_MAYWRITE_BIT).

We then observe that quite a few instances of vma_flags_test_any() and
vma_desc_test_any() are in fact only testing against a single flag.

Using the _any() variant here is just confusing - 'any' of single item
reads strangely and is liable to cause confusion.

So in these instances the series reintroduces vma_flags_test() and
vma_desc_test() as helpers which test against a single flag.

The fact that vma_flags_t is a struct and that vma_flag_t utilises sparse
to avoid confusion with vm_flags_t makes it impossible for a user to misuse
these helpers without it getting flagged somewhere.

The series also updates __mk_vma_flags() and functions invoked by it to
explicitly mark them always inline to match expectation and to be
consistent with other VMA flag helpers.

It also renames vma_flag_set() to vma_flags_set_flag() (a function only
used by __mk_vma_flags()) to be consistent with other VMA flag helpers.

Finally it updates the VMA tests for each of these changes, and introduces
explicit tests for vma_flags_test() and vma_desc_test() to assert that they
behave as expected.

Lorenzo Stoakes (Oracle) (6):
  mm: rename VMA flag helpers to be more readable
  mm: add vma_desc_test_all() and use it
  mm: always inline __mk_vma_flags() and invoked functions
  mm: reintroduce vma_flags_test() as a singular flag test
  mm: reintroduce vma_desc_test() as a singular flag test
  tools/testing/vma: add test for vma_flags_test(), vma_desc_test()

 drivers/char/mem.c                 |   2 +-
 drivers/dax/device.c               |   2 +-
 fs/erofs/data.c                    |   3 +-
 fs/hugetlbfs/inode.c               |   2 +-
 fs/ntfs3/file.c                    |   2 +-
 fs/resctrl/pseudo_lock.c           |   2 +-
 fs/zonefs/file.c                   |   3 +-
 include/linux/dax.h                |   4 +-
 include/linux/hugetlb_inline.h     |   2 +-
 include/linux/mm.h                 | 100 +++++++++++++++++++++--------
 include/linux/mm_types.h           |   2 +-
 mm/hugetlb.c                       |  12 ++--
 mm/memory.c                        |   2 +-
 mm/secretmem.c                     |   2 +-
 tools/testing/vma/include/custom.h |   5 +-
 tools/testing/vma/include/dup.h    |  48 ++++++++++----
 tools/testing/vma/tests/vma.c      |  58 +++++++++++++----
 17 files changed, 177 insertions(+), 74 deletions(-)

--
2.53.0

