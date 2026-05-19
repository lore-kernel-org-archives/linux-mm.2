Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25A8DCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75DCE6B0093; Mon, 18 May 2026 20:19:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6983C6B0095; Mon, 18 May 2026 20:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 560BA6B0096; Mon, 18 May 2026 20:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FDF36B0093
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:19:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFA5616012A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:19:51 +0000 (UTC)
X-FDA: 84782261382.24.31F7244
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 022D414000F
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:19:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nCMQNoTk;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779149990;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cAeHGdOLrgu82gUfiirSF1My4e5ieT8knTlrJJ/srVA=;
	b=HvNACrVYBhlPx4D87326qRfrkubMt+EMTj5u1vzTnjwqffnF1Y2ZTi2Ng3NL9Usew4297n
	ziQA22/UTAkrxea2Wx0Ub1YmWmy+gJeLcNGGVuSTtGLcSLdBqMptY8RTKHGdNoE3prX/nO
	1CCdK5QygH+lWr2wUFbdi6M6YYI7PSM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nCMQNoTk;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779149990; a=rsa-sha256;
	cv=none;
	b=xUSTgwtb6O7oseEHVMMgkk65ULZ0nBSrMcfstOmYf6Hk6vf19k6Zfq+JspPBxePfRomGH4
	8wfBWwC9XR5Vo2/5cge/hwmZveuoFV5o+CQ8CxBw3o92kkfcYroGLshpN1AU01Bao2bQwM
	yoiMCmGS61j6DNWlIKRalwG6mt8Vmso=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 61F8F600CB;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08C4CC2BCB7;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779149989;
	bh=bPcX7aY0Fv5p+iHJmDPvkygslezqtdpkp18CjrGXqeo=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=nCMQNoTkbBH9DV7lNsD9JTlfRGLUNje0lB/gU+e2Hvf47l4rK4CYqyYaevaEpOYGe
	 FHX7zkfHXmIYe0NNomXVplzbbQVqBcbYr/vkg8FdLHXCwp5JhRwsAZHgIYsY5+QWqe
	 DhuAHbsYDs6Clln7iGYLIJJWmldQX/gOBbNIXuWltLpQwiLGHcpwBnZaTriu41K689
	 lWvlHRLE8UegqC4T17t5qPDkV3ETy0OQgtbMEL5co0GcnqZqPhcu+VlsSQawsCy7kq
	 PmGjLqYROK6xpOKjRVqEyJQ2iLVDGa4iqMwcXcejIeKPy4nefbCxGhzVDQwqyXyL6M
	 rFtPXPj1Q3qug==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E107ACD4F3C;
	Tue, 19 May 2026 00:19:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH v3 0/6] Open HugeTLB allocation routine for more generic
 use
Date: Mon, 18 May 2026 17:19:39 -0700
Message-Id: <20260518-hugetlb-open-up-v3-0-e14b302477f8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJusC2oC/2XO0QqDIBiG4VsJj/eHc2VtR7uP0YG5P5OVhposo
 nufBYPBDt+D7+FbiUen0ZNbthKHUXttTYrLKSOyF0Yh6GdqwijjtKQF9LPCMLRgJzQwT4CiFTU
 tq3NLryStJoedfh/io0ndOTtC6B2Kw5E2osvPVUXrsuCc5UqHXMgXugGXYNRdWasGzKUdd63XP
 li3HPci283vE/73JDKgUDMuqCw7Vnfy12q2bfsAJrdSeu0AAAA=
X-Change-ID: 20260504-hugetlb-open-up-eaba80571b09
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com, 
 jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com, 
 mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com, 
 pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org, 
 rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev, 
 seanjc@google.com, shakeel.butt@linux.dev, shivankg@amd.com, 
 vannapurve@google.com, yan.y.zhao@intel.com, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779149988; l=5617;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=bPcX7aY0Fv5p+iHJmDPvkygslezqtdpkp18CjrGXqeo=;
 b=xtN4dDlhtwURik8shZJTiObc9tr0HJGnHBGTfMUDXaOXq3Gy199/XnGMAjV9DOZqhIQQOEfLX
 X5mt6sImpmjAbMV4xcqGvQzplXhMDJurY+WAq/lDUOdeKNg9Ha3Anpk
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 022D414000F
X-Stat-Signature: f65ccyd6rhidyu31wsy81njdnwx3zt3u
X-HE-Tag: 1779149989-180721
X-HE-Meta: U2FsdGVkX18fhnkc/KR6DfHi8Aeg3sqFh21OKHcdb1nSxZhhtVLQE+6onEiJABgzTeFHhYK6qm6NhM4D6jp+N7/wPTd4AkQVl3RRzH1VeTNZpPqi/I1FO7/qD1gVvxlU634+W0QZKLnvV/DCUVKa0J28QW5h3jdMnApg1QhCLvDceqZZCfTJWCbx7VZUUUKgVP5QxL5CPy/q/IkBx263FIWHPT+yiOaEAAzGOP4tJagxBXTj+h5SlXwPqFyt9PgKHYk21fsvfzr+Z7kHCYB7UV/UyIOdPjOB231epVjQiOizGMdEPfrqx2XVsIu05TpV/6xy5Yze5SmNdbtY2nyQdgAEZZt+3K/vDZXuq6jQf0KoKhueLPh0KeBEhuAouvHlVAgOZTTp3SGJlaRmrAMZ7aLfDdECjZ1JPIw04W5f4/BxKZDEf6/+3zhbsetW7emDIqar4gs22fGMT5dtPe8rk9F4Y7no6fOGkMh+324QfvaDMdpPBIMzI/LsiiRAUnU178+NSgy1HboOoCrzlhj/bbdJii4cwoYCSoyXKyQZCwCrU1fqPMJiXebF01S2x/1goNSIIOWc6mlw/4J3oWSxLLtwYN7wPCWg8GpI6ZIO7GufrRMBnAhbGSKMcbMTCX+FJ4O1b7ylwuxctj6t0Nf+90pWSMQJREtMOS4d4GNW02QjBGAQLojH6ejXFNxZlh+WnVzw9fkg7KXAXLRyjnXb9GxkXuoUIgz13QXskaSOg+82FocsDfHorrPKbxqhah+mH22Le8Jh+h9c0r883lpL25lucxECTzKc61gQb46XdoGfOxdteJf5oURMaObn828huIUDtBd1G43XJAGKskTYbHJruEiS5HrSCl/I+WIHJ5HD+2JRfO5VAvKaxximlicxXe9v1oJ5sxwvluCZrxGbJ0kAm3eMDTBTLUujb7KyL2og/ibZiMIaJHnLEH96lk7j1JTA1xQOKYpaWEoG5ER
 0xORz5yV
 Kr7YhPsHm0gO2Bjh+O/AsnEBE291oAfGomre0t4KTT1kzW+AEAvVgcKJIvaokqFLw3TtpPTDwNIZiyBA5fu03ZPMkJIML/QF4eoEUlZ7hQE1ZRC01xhoQn+3fv3uFIOEtyZRzfsrPOzkG9rYrcEnOfVLAS9q2ndCPQK5oxUPsF+fZmHVx4RNEwYeDOCOLTUHi/AWwaGL5ejsqD5O/QDYQrULO57875sKe9k/l0auOYnw/PA5ZzJ1GJ0e45Bo7nxjRfVy064DX1ftO9lPzyxv8MhFTe5NSzgi3Zfvs/xkMDpxJ3BuIJvrH75eityeFNT5j3oj+Zu8Ns3uhM0GCLqvI2fvINQ+L/bR/SQUqD96omyWYmlx/NcaTpjkAUOjp8h+PXGaxxL/NybnHlafyJlosXddCOp/eeCqkj6WvgkXVDAPyI0Wx4J0MFPsOHbu4cPqp4lpud6LHU4i/ebg6KkE+Y0xo267iPYXuzo3ZKjgS2Ko26zMqAhSYD+Mbmg==
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

To see how hugetlb_alloc_folio() is used by guest_memfd, the most
recent patch series that uses this more generic HugeTLB allocation
routine is at [1], and a newer revision of that patch series is at
[2].

Independently of guest_memfd, I believe this change is useful in
simplifying alloc_hugetlb_folio(). alloc_hugetlb_folio() was so
coupled to a VMA that even HugeTLBfs allocates HugeTLB folios using a
pseudo-VMA.

Testing:

+ libhugetlbfs tests pass
+ ./tools/testing/selftests/mm/ksft_hugetlb.sh passes

Changes in this revision:

+ Clarified comment on when alloc_hugetlb_folio() chooses to dequeue a page
  as requested by Oscar
    + After refactoring out hugetlb_alloc_folio(), hugetlb_alloc_folio()
      just acts on alloc_flags, so I think the reason for dequeueing is
      sufficiently clear, so I dropped the comment
+ Introduced concept of an interpreted mempolicy (struct mempolicy_interpreted).
    + dequeue_hugetlb_folio() and alloc_buddy_hugetlb_folio() are actually
      operating on an interpreted mempolicy, which comprises nid, nodemask, and
      a mempolicy_mode. mempolicy_mode tells the allocation function how to
      interpret the provided nid and nodemask.
    + I think mempolicy_interpreted could be generalized further outside of
      hugetlb. I think every caller of policy_nodemask() will eventually use the
      information in interpreted mempolicy to make the allocation.
    + Let me know if this makes sense, and if I should go ahead to do more
      refactoring!

Oscar, in my responses to v2, I agreed with your idea of an allocation ctxt, but
after doing some initial refactoring, I think the ctxt isn't really an
allocation context, I felt like I was just putting all the parameters for
hugetlb_alloc_folio() into a struct to get named parameters in C.

Here's my rationale for hugetlb_alloc_folio()'s parameters:

+ hstate
+ subpool
   + I think it makes sense to explicitly provide above two as parameters since
     these are always required for allocation of a hugetlb folio. subpool can be
     NULL, but we do want the caller to explicitly pass something in so subpool
     accounting can be performed within hugetlb_alloc_folio().
+ interpreted mempolicy
   + This summarizes what node the folio should be allocated from.
+ gfp
   + gfp is used in a few ways, relating to the actual allocation and zone to
     allocate from:
       1. It was used to interpret the mempolicy, if there was something
          requested in the gfp.
       2. It is used to determine which zone to allocate from in
          dequeue_hugetlb_folio()
       3. A modified version is used in alloc_buddy_hugetlb_folio() if
          MPOL_PREFERRED_MANY, otherwise it is used as-is to allocate a hugetlb
          folio.
    + I retained gfp as a separate parameter, and not part of
      mempolicy_interpreted, because after the mempolicy is interpreted, gfp is
      no longer used in relation to mempolicy to determine which node to
      allocate on.
+ allocation flags
    + I implemented Oscar's suggestion partially in allocation flags, which will
      allow us to add more allocation knobs without adding more parameters to
      hugetlb_alloc_folio().

[1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/T/
[2] https://github.com/googleprodkernel/linux-cc/tree/wip-gmem-conversions-hugetlb-restructuring-12-08-25

RFC v1: https://lore.kernel.org/all/bb35a69a-5be9-45f5-a557-1902487a1bc2@linux.dev/
v2: https://lore.kernel.org/r/20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com

---
Ackerley Tng (6):
      mm: hugetlb: Consolidate interpretation of gbl_chg within alloc_hugetlb_folio()
      mm: hugetlb: Move mpol interpretation out of alloc_buddy_hugetlb_folio_with_mpol()
      mm: hugetlb: Move mpol interpretation out of dequeue_hugetlb_folio_vma()
      mm: hugetlb: Use error variable in alloc_hugetlb_folio
      mm: hugetlb: Move mem_cgroup_charge_hugetlb() earlier in allocation
      mm: hugetlb: Refactor out hugetlb_alloc_folio()

 include/linux/hugetlb.h        |  19 ++++
 include/uapi/linux/mempolicy.h |   2 +-
 mm/hugetlb.c                   | 246 +++++++++++++++++++++++------------------
 3 files changed, 157 insertions(+), 110 deletions(-)
---
base-commit: 4d3a2a466b8d68d852a1f3bbf11204b718428dc4
change-id: 20260504-hugetlb-open-up-eaba80571b09

Best regards,
--
Ackerley Tng <ackerleytng@google.com>



