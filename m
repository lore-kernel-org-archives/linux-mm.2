Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B10A9C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEF636B0092; Wed, 29 Jul 2026 12:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA0A66B0093; Wed, 29 Jul 2026 12:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967D56B0095; Wed, 29 Jul 2026 12:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 616706B0092
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:49:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6AD2C0716
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:49:19 +0000 (UTC)
X-FDA: 85042399638.06.61E8D38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 09586180002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:49:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dfcXsYDo;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785343758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=P6sqMYW+3fWf7BQRd1/m+O03fjN9PWXMCvN1kiwSpK0=;
	b=YgXRVNt6HXBFeGHFIim2kliizVSv8Hds/H2Wq+32Gaa7/bW26Qq6URkcd+zcM3F/23RUJL
	mCUFSv61B+AluECUKFqK10fjLR7Ipd1hwwms6G92il5FFvRW0qitYmROwvtgLO5bwkp6Nl
	h70e98zuQUh3rlvR88FrDq6I9BZ+XCA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dfcXsYDo;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785343758;
	b=mPca2mqsZrX+41oehdaXuuz/Ge7EJXGt4CoKgl7mrj4bscjg+bXa93BsjQu8TrGgpMVX0f
	PVTMARQiR93RY7Mfzd1BNG2ghgGZ0tJdD2FWQW7kHG+e5Hh4qygIBIV0bBkdPdOAj5+asZ
	gmvg9emDi+xBC4Z5pluGkpFp2dOJ4c8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 36305600AF;
	Wed, 29 Jul 2026 16:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE861F000E9;
	Wed, 29 Jul 2026 16:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785343756;
	bh=P6sqMYW+3fWf7BQRd1/m+O03fjN9PWXMCvN1kiwSpK0=;
	h=From:Subject:Date:To:Cc;
	b=dfcXsYDoKgj97x9XBla0BXLUUZlhyMWattOrpHNe5Ux5LpQT+osoYvpTG7cAyOndv
	 IdhDgt1BkKGHKjywoIBnLLN7Qtqw1NFpXUL8u1ibKmBSbNLEtXCT/Fa85WmokAxLaY
	 WgbPvtVgBsYcIfScaLMcMdqLW22wiAh4Gc4QN8FsgWGe9DNhUX4M8GMUdUEOna4ELX
	 b3OkVARsZMV0gwPdO6emLi8Lz4DSczQFuEd1biOnFrqrK6iQQb4exWB18dqlv15DHr
	 1oF/x3RIJzGuH3dMcMB0NNc1q6BNDoSXW1EeiRS7bbNjqC3pNGlmShuZVTreaLirz9
	 fOuqjyFzhcLLA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v3 00/15] mm/rmap: index MAP_PRIVATE file-backed folios by
 anonymous pgoff
Date: Wed, 29 Jul 2026 17:48:35 +0100
Message-Id: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOMuamoC/33OQW7DIBAF0KtErDsWEGzqrHqPKgsYDw6pZSJwS
 CrLd69xskg3WX5p5v0/s0TRU2KH3cwiZZ98GNew/9gxPJmxJ/DdmpnksuFaCLAKEprB2IEAww2
 yjxNc+uAcGI7IyQplsWErcInk/H3Dv4+PnK72TDgVsVycfJpC/N3asyh3DEOmWAn9KbWqRb2ve
 j9Vwzl9/VAcaahC7Mvnc49+tycL4IBOqlZwcrxVr0YZlOVW+bAkf2vJ1ZJdrVpda6Mb989aluU
 PIyNv4EoBAAA=
X-Change-ID: 20260711-b4-scalable-cow-virt-pgoff-a0cc0eb14bc6
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=13682; i=ljs@kernel.org;
 h=from:subject:message-id; bh=/c9brJc25kcAr0UasPn2b+SHLhF9Tnk4HFPuEeK4sFc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKy9L6kcJgaTbhXPv3S82/JjgduF7Z/7LJbEvDQ/AjXQ
 /GtK2Y2dpSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiGYIMf/hurXXq9DrCsedv
 pvxqoWWzXu0oPfbb3m5R15MHXVNE268xMmy47iO/RHK+6nnPiKW2fA5z/7+L65v17cb+ojCZ4pI
 AL1YA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 09586180002
X-Stat-Signature: cxw6ymeig693yyzu9jdyabt74ofmwzc3
X-HE-Tag: 1785343757-440668
X-HE-Meta: U2FsdGVkX18+dGK39WBLl6cLDHdgCYU904LDBiDMKfP9OsHAlgZ44Wqm2p1v4P7is3LPog2zog3fegZRIU8HBFo5JvWUUvkv6scg6EUCQATzk7sX97IIM6ZS7H1rCPryIunhqA3INMUKrYDPWGLU9pNYqmKFBm/se3m2d9vFbnHI9kagrELRFiKWl5Wp7jmnFL1j23J57ZOfctNAFn7iAgPKte+vE1MdviZZ/SF3uCm0uzRrqBZPCSa0seB3Atk+yQldLayfLZ2jtouzkKFinOwXiVgGx7Z/TEXdqYZp2HRd21ajVmEnKPwdrDqJmXpfOhCQnxCqlfykfQkXMOnRpjR0KHvUitjTTD8pYOCX2joJzGsYoza/fgDzkWhjzv/k41VW9hi/wfNsNbHki1nfo7yPHKhE9O7wO4YBDgdIJQ7qWokRpye+78h3Blw9ebS/y9viWt03g+2bFQMPQmxxFmGTMH6dwdbogJ6fCwOrCvNVvk4iCg0mUNwj/qU7xrQFU3/rrwLKQtY05z5KH91744JDd1hatB4blgQ9bg70bGo39nrFo1tG5lV6976UpzSL3YxQMSSXtoQ++JODM7l5jGeR1yjsZZG2xopjwpsUTvA6E5U72o1RuuPDKKw26NlVlFiSdXx0D7al2+LERpMYiKDF/8m7lSyDWuYDkEnnXrdJl16s3yjoyxVfZeK2eMhM01okxr5kKArlvuIZLlW4Wl8pp2KwAmItPdebV1QPtZSLDy5L9Kyjd0wdP8JJQh8ZctMNSBFANdkeLigq0ut+NqPLmFkQXB2AVFUc3GtNEdjgOA/WBaV4K1O4wgKjdTyhmx0Eh2zC4TEAi+da/8Pbg2ZCB8dCGBTVd6/kOvGGipV3kjqxjKytGsXZDsaknsOrMhljSAkVyHXd9YSjZo7YEo08bPPf6uXyfsdtXGJ6umTBukNoB03h7yCLfaBFm/tE1lxS7gUbmSbktKSq8bK
 1FoFEWg3
 VdbqBaPx84JEnXQy/+KINCNNVNgPhKALW/ukFp/3mXKB8jPZh/FH/SG/t6bZAf9qWRgr4qdJ5PlPvKjJh/sziNO7X4tETBuXJDZK3f8UutnJKWVrDcUjCDwr94+35PIPq/g+lid6IvwireCF7up8zmfykV8QGcVlCWgXh8VwYBW5y/JLIF7hKhRsOt1gJ0jbh38HcnOheJlpF2YA0mBjqVa2p0s0p3vwXilez/qo1ds37PuvlA7jdCgK/Wjn8LrTYSXh7SP5BdYx1TjGFr07SDoa9eK/PTHFYyqE1VpFzByFjyaWv9u/4Dvh1cCJeCFAxUspd2atChGCjVKR2o9e3VgRWJ6jJeE7YPB/AsP9EFhaUmA80K0jy3dRryBvrL2kCG8axKYEipbUvAXpHC8h7lD21+t+XoXJOpEpTIANBhCo49Jj8C62G7uDHCfqZNrzIUdk5lOL4ihXBrlUnTpJxw5mQ2VVtiBqicMDXpWCiinW7LljoIAGXJpSj1QcdPNc9n/CxvFibTGQFcJ8aLR0gPO//X70ZBsONLRT4A7eBZzC1aF0Nu0+TyT33TZv06o/1byAw8gDDVYU+ZfKAeM0/004t7vXSOBe2KJZb7eoSCn400PRHzfoViXZFZCxoOusnD+0GzqHiv8jmURi3goHNIN3jT8dYl8PoXdahxEr2Nxtycvi7SuZXOXhvmpbK40wnRGdcHqzTDjsSVFbvIr/f0+65KwRJ7LZaEF1vwSWQll/bQuTKNoGXCzZ+1SfiKo/zC5XScYAU1IcSif/6THyEmqg3B4R5jHryOSXhsSflTBpDDWdYubMkckdif7EC028CjuLG6Uaz++RphQYd925QPEuE7Xx0E80CMSMobmGp3GgVAK23dZAsdjrcNcJcltyGNC+2W6FiS3vBtQyRD3wIPmCluXu0in6QqclrbgHXmBjx4fQcL6fzzZOWPqyA+twQyWxYJ8zwnn3uDm+a/TNzD1NvuB4Q
 kAq5okQS
 aHEJEzb2+TedP/UShduRN7gOB0tBAjeR1Tmv277Ee+/O6N1YnP+yG1wpV33efXjIZPFK1cVnz5ZiaKoH/JT0s5v9+MzkM+Kn2iG4UkpzRk8clZBfCYqJg3LM1Z3pJn/eZ0251SQQYxvw1hNr9StndSxB77sLRiQwTHc3PAhvecZ1VZ9qetdryKnonEpF/bLsDYNhNr2SK71CVOaXJW6OFb657Al71dqaef//J/knIpI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In memory management we've managed to manufacture a great deal of confusion
around the concept of anonymous memory. We have:

1. 'Pure anon' memory - anonymous VMAs whose folios are anonymous and
   swap-backed (thus for reclaim purposes, treated as anonymous). These are
   simple enough.

2. shmem - file-backed VMAs, file-backed folios (from rmap perspective) so
   present in the page cache and mapped by an address_space object, but
   whose folios are also swap-backed (thus treated as anonymous for reclaim
   purposes).

3. MAP_PRIVATE-mapped /dev/zero - a strange beast whose VMAs have
   vma->vm_file set, but which clears vma->vm_ops to satisfy
   vma_is_anonymous(), resulting in VMAs that were mmap()'d referencing a
   file, but are in every other sense anonymous, including the folios.

4. Other MAP_PRIVATE-file backed mappings - These possess file-backed VMAs
   and have file-backed folios until CoW'd, at which point those CoW'd
   folios are anonymous.

This series fixes issues 3 and 4.

In order for us to traverse VMAs using the reverse mapping, we require two
fields - folio->mapping and folio->index. The first tells the rmap code
where to look for VMAs, and the second tells it at which offset the folio
starts within the referenced object.

For anonymous folios, folio->mapping points at an anon_vma object. For
file-backed folios, it points at an address_space. And:

* For file-backed folios folio->index is simply the page offset of the start
  of the folio within the file.

* For anonymous folios belonging to pure anon mappings, folio->index is
  equal to the anonymous page offset of the folio.

* For anonymous folios belonging to file-backed mappings (i.e. CoW'd folios
  of a MAP_PRIVATE file-backed mapping), folio->index is equal to the file
  page offset.

This series establishes a new anonymous page offset property of VMAs to
allow us to map anonymous folios at their anonymous page offset, consistent
with pure anon.

The purpose of doing so is to lay the foundations for the scalable CoW
work. This is necessary because scalable CoW looks in the maple tree for
the VMA located at folio->index << PAGE_SHIFT, before falling back to
looking up tracked remaps if necessary.

The MAP_PRIVATE file-backed case means that folio indices will very often
conflict with one another and this remap tracking becomes substantially
more contended, and of course the fast path can never be used.

This also makes it possible, in future, to unshare anonymously mapped
folios with deep fork hierarchies on remap, eliminating the need for remap
tracking in the vast majority of cases.

Similar to page offset of pure anonymous VMAs, we update the anonymous page
offset of unfaulted file-backed VMAs on remap, but do not once
CoW'd (i.e. vma->anon_vma is non-NULL).

Overall, there is little impact on mergeability, which remains exactly the same
for pure anonymous and shared file-backed mappings, with the only impact being
on MAP_PRIVATE-mapped file-backed mappings, which must now match on anonymous
page offset as well as file page offset to be merged.

To fail to merge like this would require CoW'ing the mapping, then finding
another VMA with identical file and compatible page offset to remap next
to.

This is therefore very much an edge case that should have very little
impact (and which scalable CoW may very well address in any case).

We also address the outlier case of MAP_PRIVATE-/dev/zero mappings which
have file page offset but satisfy vma_is_anonymous() by making them truly
anonymous.

This is low-risk as for anything meaningful these mappings behave
anonymously, but it is very beneficial to do so as we eliminate an odd
corner case, and those are notorious for attracting subtle bugs.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v3:
- Renamed virtual page offset to anonymous page offset across the series as
  per David and adjusted prose to reflect it.
- As part of the rename, eliminated  vma_anon_pgoff_addr() and the
  conflicting vma_[start, end]_anon_pgoff() functions by passing anon pgoff
  to the merge logic and having that figure out which page offset to use,
  significantly simplifying things.
- Introduced needs_adjacent_anon_pgoff() to be really clear about what the
  merge logic is doing.
- Passing through the anon pgoff fixes the issue Sashiko raised with shared
  file-backed mappings having incorrect anon pgoff (inconsequential but a
  wrinkle nonetheless).
- Dropped unnecessary needs_rmap_locks change in 9/15 - this checks to see
  if rmap locks need to be taken due to the range being moved
  backwards. Since both file-backed and anon page offset are updated on
  such a move, it suffices to check only the former. Updated commit message
  to reflect it.
- Sashiko complained about a couple missing .is_anon_walk entries in
  pvmw's - page_mapped_in_vma() and migrate_vma_collect_huge_pmd() -
  however neither impact anything - the field is only meaningful for
  vma_address_end() if nr_pages > 1 and neither site is impacted. Moreover,
  neither site sets pgoff either. Update the commit message to explain
  this.
- Renamed is_anon_walk to pgoff_is_anon and document that pvmw->pgoff is
  only meaningful if pvmw->nr_pages > 1.
- Highlighted the user-visible changes to /dev/zero being true-anon in the
  relevant commit message as per Yang.
- Fixed a bug in the proc-self-map-files-00[1,2].c procfs selftests - the
  code was trying to MAP_PRIVATE 'an arbitrary file' then asserts that
  file-backed procfs entries exist, but happened to choose
  /dev/zero. Updated to the guaranteed-available /proc/self/exe, as
  reported by Mark.
- Fixed an issue with drivers that intentionally mark vma->vm_ops as NULL
  (using the legacy ->mmap callback). If they do this set dummy ops, which
  is what they meant. The mmap_prepare case is fine as nobody does this
  there and this will be fixed when all drivers are finally converted to
  mmap_prepare. As reported by Sashiko.
- Added some missed VMA selftest vma_start_[anon]_pgoff() conversions in
  the merge test commit as per Sashiko.
- Various small prose/comment fixups.

v2:
- Removed incorrect assert on always-NULL folio from 7/15, as per syzbot.
- Updated 2/15 so linear_virt_page_index() checks for vma_is_anonymous() as
  well to be cautious about 'special' (VDSO, VVAR, etc.) VMAs accidentally
  being asserted when CONFIG_DEBUG_VM is set, as per Sashiko.
- Updated commit message of 9/15 to mention the subtle change in NUMA
  interleaving behaviour, as per Sashiko.
- Updated 10/15 to assert virtual page offset for adjacent VMAs for various
  VMA userland tests, as per Sashiko.
- Updated 13/15 to remove the !vma->vm_file check altogether after
  MAP_PRIVATE-/dev/zero is made pure anon in vma_start_virt_pgoff().
- Updated 12/15 to check that the /dev/zero device is a character device
  since it turns out that block and character devices have their own
  separate major/minor device number namespaces... :) as per Sashiko.
- Updated 12/15 to fix a bisection hazard where vma->vm_ops would be
  overwritten by vma_dummy_vm_ops for MAP_PRIVATE-/dev/zero, as per
  Sashiko.
- Updated 12/15 to fix another bisection hazard (...!) due to
  ordering of vma_set_anonymous(). Removed in 13/15.
- Added comments to __vm_virt_pgoff[lo, hi] fields referencing
  vma_start_virt_pgoff()'s comment to be clearer what these are as per
  Xu Xin in 1/15.
- Various typo fixes + cleanups in prose.
- Updated the cover letter to point out that the MAP_PRIVATE-/dev/zero
  issue is addressed in this series too.
https://patch.msgid.link/20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org

v1:
- Rebased onto mm-new.
- Dependent series heavily reviewed and looks highly likely to land, so
  un-RFC.
- Added explicit check for /dev/zero and removed ability for arbitrary
  mmap/mmap_prepare hooks to make themselves anonymous.
- Made MAP_PRIVATE-/dev/zero mappings truly anonymous.
- Added MAP_PRIVATE file-backed mapping merge test to selftests.
- Added a MAP_PRIVATE-/dev/zero VMA userland test to assert that the VMA
  really is made anonymous.
- Added MAP_PRIVATE-/dev/zero merge tests to selftests.
- Fixed missed virtual page index site in try_to_merge_with_ksm_page().
- Updated folio_within_range() to use virtual page offset for anon
  folio. This had no impact as it is only called for large folios at the
  moment (and MAP_PRIVATE-file backed mappings can't currently be backed by
  a large folio) but making the change now protects us for the future.
- Fixed typos etc.
https://patch.msgid.link/20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org

RFC:
https://patch.msgid.link/cover.1782745153.git.ljs@kernel.org

To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Jann Horn <jannh@google.com>
To: Pedro Falcato <pfalcato@suse.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
To: Miaohe Lin <linmiaohe@huawei.com>
To: Naoya Horiguchi <nao.horiguchi@gmail.com>
To: Rik van Riel <riel@surriel.com>
To: Harry Yoo <harry@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
To: Kees Cook <kees@kernel.org>
To: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
To: Nico Pache <npache@redhat.com>
To: Ryan Roberts <ryan.roberts@arm.com>
To: Dev Jain <dev.jain@arm.com>
To: Barry Song <baohua@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
To: Matthew Brost <matthew.brost@intel.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Rakie Kim <rakie.kim@sk.com>
To: Byungchul Park <byungchul@sk.com>
To: Gregory Price <gourry@gourry.net>
To: Ying Huang <ying.huang@linux.alibaba.com>
To: Alistair Popple <apopple@nvidia.com>
To: Peter Xu <peterx@redhat.com>
To: Xu Xin <xu.xin16@zte.com.cn>
To: Chengming Zhou <chengming.zhou@linux.dev>
To: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ljs@kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org

---
Lorenzo Stoakes (ARM) (15):
      mm/vma: introduce VMA anon page offset field and add helpers
      mm: introduce linear_anon_page_index()
      mm: abstract vma_address() and introduce vma_anon_address()
      mm: update print_bad_page_map() to show anonymous page index
      mm: introduce and use vma_filebacked_address()
      mm: propagate VMA anonymous page offset on map, remap, split + merge
      mm/rmap: track whether the page VMA mapped pgoff is anonymous
      mm: introduce and use linear_folio_page_index()
      mm/rmap: use anon pgoff to track MAP_PRIVATE file-backed anon folios
      tools/testing/vma: expand VMA merge tests to assert anon pgoff
      tools/testing/selftests/mm: test anonymous page offset merge behaviour
      mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
      mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous
      tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero is anon
      tools/testing/selftests/mm: add MAP_PRIVATE-/dev/zero merge tests

 drivers/char/mem.c                                 |   8 +-
 include/linux/mm.h                                 |  74 ++++++++--
 include/linux/mm_types.h                           |  12 ++
 include/linux/pagemap.h                            |  66 +++++++++
 include/linux/rmap.h                               |   4 +-
 mm/huge_memory.c                                   |   3 +-
 mm/internal.h                                      |  89 ++++++++----
 mm/interval_tree.c                                 |   4 +-
 mm/ksm.c                                           |   7 +-
 mm/memory-failure.c                                |   4 +-
 mm/memory.c                                        |   8 +-
 mm/migrate.c                                       |   6 +-
 mm/mremap.c                                        |   6 +-
 mm/page_vma_mapped.c                               |   6 +-
 mm/rmap.c                                          |  22 +--
 mm/userfaultfd.c                                   |   6 +-
 mm/vma.c                                           | 127 +++++++++++++---
 mm/vma.h                                           |  92 +++++++-----
 mm/vma_exec.c                                      |   2 +-
 mm/vma_init.c                                      |   1 +
 mm/vma_internal.h                                  |   1 +
 tools/testing/selftests/mm/merge.c                 | 161 +++++++++++++++++++++
 .../selftests/proc/proc-self-map-files-001.c       |   2 +-
 .../selftests/proc/proc-self-map-files-002.c       |   2 +-
 tools/testing/vma/include/dup.h                    |  87 ++++++++++-
 tools/testing/vma/shared.c                         |   3 +-
 tools/testing/vma/tests/merge.c                    |  49 +++++--
 tools/testing/vma/tests/mmap.c                     |  50 +++++++
 tools/testing/vma/tests/vma.c                      |   4 +-
 tools/testing/vma/vma_internal.h                   |   1 +
 30 files changed, 766 insertions(+), 141 deletions(-)
---
base-commit: 5093dba1014c1d7f7e247fd118f0fa8f22136046
change-id: 20260711-b4-scalable-cow-virt-pgoff-a0cc0eb14bc6

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


