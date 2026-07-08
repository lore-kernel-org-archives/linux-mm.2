Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD261C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 22:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB056B0088; Wed,  8 Jul 2026 18:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AAD56B008A; Wed,  8 Jul 2026 18:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7748F6B008C; Wed,  8 Jul 2026 18:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43D536B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:12:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AAEBBC1A4E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:12:56 +0000 (UTC)
X-FDA: 84967010352.27.8326008
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id BD44AC0003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:12:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=do0JeNrN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783548774;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FIztIWscS/HPpz5Optb7qHUpRG1+FwxvOpQ1inw+sR4=;
	b=MB61Qi7GqU4OydiMs8KPxzyLjAG51Awr3IL1YvyttswGhCtXlFhfhIQafqbpydtexMOWmG
	NO6BMm9fzgfG6mFmf3caVbVQm6Fe7VqhsxgjgxxvLrt8eZNBf2Twv9y82cpctEuZtoFbg/
	MT+pLy/dSg+7JqUUPWadHEJ9wzUkypk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=do0JeNrN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783548774;
	b=l2s5+ykHOevcJVB9dPABrZexfaGtuzuq4j3wwedsfASzz2Yvoz8PMpPBbeO4lbOd8JSqMm
	SZP7NthR7CVrLnt+7Krd7QuXETiDKs+rR0GlX3fM9zPaupnEKFhXuN2p6LhkSVXyN2HDCw
	4eavjVLZDjRiU5D2e1+BRxZmmZ4JYqg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 215436001A;
	Wed,  8 Jul 2026 22:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB00AC2BCB3;
	Wed,  8 Jul 2026 22:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783548773;
	bh=QlfWMsr/unp1FpOCDzN6ULvQSscqfPZb88VSyDOp7xI=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=do0JeNrN4mAnZckCdgGD7EcRM5URU0GDSeh3DVtqgPIab5IAeAhrVg6zcix+1tbsc
	 wK+bhdyvWQz8f06aCrUaSjxDYFtcN8FGw/9c/5umKCsChM+EJuu8dHq3wd2C4oINdL
	 zxmiYUhL5zjF2dTEnvMVjOO0X5lvPK3LXPcs0y1SSQH+L6U3s62CZiolzhBP/iwOk9
	 ucuBIC+tRFLlcMQLXoRouuzWW71A827BW7izaWgNEPcSMmmS7aP218rOld0KlN6w4R
	 hilSMXgN2jQL+zIaxsRvpJVqTA3IIdYjEoxbqMTLafRxnADnbZ++7L0yL/puNNlefL
	 B7UlzK52Swhjw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F89C43458;
	Wed,  8 Jul 2026 22:12:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH v2 0/5] Fix bugs on HugeTLB folio allocation failure paths
Date: Wed, 08 Jul 2026 15:12:48 -0700
Message-Id: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGDLTmoC/33NQQ7CIBCF4as0s3YMpbaoK+9hugA6UBIsBtpG0
 3B3sYlbl/+b5JsNEkVHCa7VBpFWl1yYSvBDBXqUkyV0Q2ngjHdMsA7HxdLsFUrvg0YjnV8ioXE
 vSqiFEaIlLfnFQBGekfZDAe596dGlOcT3/mytv+vPFX/dtUaGrVJDI0/q3HTDzYZgPR11eECfc
 /4ALBKucscAAAA=
X-Change-ID: 20260706-hugetlb-alloc-failure-fixes-c7f775eca29f
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783548773; l=4922;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=QlfWMsr/unp1FpOCDzN6ULvQSscqfPZb88VSyDOp7xI=;
 b=uA4v+c/+hBaqy2XVEYcDPmBjcObfMzWV+0uyuiW1EpW6fufG/8l/TM4BkxuNzGXxPzQ+4dX88
 s9zp+6+zHKhA976o6lcYZXNR4aUxx+J2OBHw5hbdRlYtjyLTjs5EuWi
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: BD44AC0003
X-Stat-Signature: pj3dfx4jozy3z859g9h6cbef18bqi6b8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783548774-378019
X-HE-Meta: U2FsdGVkX1/ck7zzZccqGiz5FQ9j+0NGmTszazRIf1aKS1hnvtAz+WbWbNwFDoEvRGdJrDPLfptM3h2l3UDK0Ynyu85qrUH4qyPoHQLlqWgWpphPWYR2dlHR8v+WDLgouzNi0To+x0MqZ394S6jAeXCThCoOS9uqxlQPGUSbDh7b5Sn+PM07drxkuQ8lAsGsx+Bc0KYMnkeTd1Z+/uxrFFgLQs42m7/e8RWoKLcg77gZUcSW0AWAscpW+yMVUyCEivyhaoFaHTSVsdQ7/sIBy9OZbStuTRFFem20IqEhYs6XdJ8on+/DSeAsJVmdUVYwsY+8f64JI4HDckfSwyzMqQzhQYe8FGLtjBCiCwKbfzwbrnfTSvtjFF+/sruh0Go6v3DY2jRlQ5A0iRegip5p9G0XqQbp5jUA6rQWFjs9rAB0FSCVGZg3mzTWUO0QvC9a91xCGKCUKdKbCbEULxY5UUuUGtNrKs6A0dCB1h55cKvYQGQvoXuCvEmGa9ZX/I+smlJYqPcyac0OiJQfxVbTpNH9HqchwCYSMwSwIu7X6XH0Oq71ZQNOBhscTBMRDYeTs0ma2HuW11zoXnuZgYjGRJal1EFe5Su4CaPBtm7H7FDZw5qHLZaaxRWh5hdxvv7ubUj5WhL14ZQV6QDcN28+svqkUWV0t7tADEqxaqXbfTsj/uAn7YeJ0xSrFQFPOuHj+GtEm9GPAd3Jg+uY2nWlWQQDTVgNQVg9RBkf38BnMHYtQr7eboO0okvZf6g7zgsgqsDKkxU4F4azqfzEHGCNbblcsy7/yqmBxrPTGgNaeIYkxu92Pn7BMJvZDdUfZHZXaVsOCfvBCoyRsZsXXqJga6akodCryT5wm5qFjRH2XdLfURs5ha1iYKtHEsxbsibZuFWyGSEUh01i+5zliboWkQK2N6cQ+r60aHNQbDO6srYRedZ4L5X+wQIAEw5SwLLKwWmSdBKpz4nnEeSkyXi
 7R9D2hZ+
 vi668XQYEu2SdXv8JnAIraU7zY4+6AvYimrwCKU8d0Fmlq8Xf9lIVfX/kydP88rC+a3JgIoXZ9rLqNBA1E1ys1MpqPA4/k7A5QYzAop2xiCKN9GjCqfESftVNayEkoZU589BUBCv14V1DpjoJbeO3xsXAKdVke5YTh30Bg+c/AXcEHgI0kg+gBJ4utvAKc+ws2O2/ARBKWb+7jRUYhe5lcuzyyYnD8FvWcC0T81PsxBrYEoJUTF67E+WhZl8dBluZTSn7n/fAJf6G+YCFZy2HhY/A7BEEBdnxm1D87OadvInpWyk3x9OcfrqlAX7Hg5BOa1KDLCi78Yy/eKNu5vBSH9WkZodNduU8wRTd4kJf4Tgi3dTNde9VHqh8IznSd2FCK9Fbz5ZWjGe4ZEvWMumvMv0QN6Y0iGneKo5XjxLgkn1bNXVa8qk4glSduGfyrG+XxKWHEDkZ4smGhWusfB/11wEJWsci9q1Bvu8EsMF8FhRBRv2uNwWaCMv2dgCBJz8TbhESOo93NDAW9UAGrBV9YQlap/5UFtxg5aWK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When mem_cgroup_charge_hugetlb() fails (e.g. when hitting memcg limits),
the HugeTLB allocation path currently handles the errors incorrectly.

This series fixes 5 issues related to HugeTLB allocation failure paths.

Some of these issues were pointed out by Sashiko while I was working on
[1].

0. The fix for (1.) below was in v1 of this series was incomplete, because it
   fixed the case where used_hpages was not restored, but introduced another
   issue, where subpool reservations are always restored even when a subpool
   reservation was not used. I looked into this more, I believe there's a deeper
   conceptual conflict in the way hugepage_subpool_put_pages() is used. I added
   a new patch to this series, which addresses the issue.

With the additional change, (1.) now does the correct thing. It always calls
hugepage_subpool_put_pages(), which restores used_hpages, and is able to
correctly skip updating reservations as well. The other patches fall in place
after this additional patch.

1. Fix subpool usage leak on allocation failure: (Sashiko pointed this out
   in [2])

   When alloc_hugetlb_folio() fails early (e.g. buddy allocation failure or
   hugetlb cgroup charging failure) and gbl_chg == 1, the error path skips
   restoring the page to the subpool, leaking the subpool's used_hpages
   counter. Fix this by calling hugepage_subpool_put_pages()
   unconditionally if map_chg is true.

(1.) above could technically be a separate patch series, but I'm relying on that
for fix (4.) below.

2. Fix folio refcount mismatch on memcg charge failure: (Sashiko pointed this
   out in [3])

   The error path in alloc_hugetlb_folio() calls free_huge_folio() directly
   on a folio with a refcount of 1 (set via folio_ref_unfreeze() earlier).
   This triggers VM_BUG_ON_FOLIO(folio_ref_count(folio), folio) if
   CONFIG_DEBUG_VM is enabled, and can corrupt allocator state otherwise.
   Fix this by using folio_put() instead of free_huge_folio() to correctly
   drop the refcount before freeing.

While fixing the above, the reproducer (I'll send these separately) was causing
an infinite loop during allocation, unveiling issue (3.).

3. Return -ENOSPC on memcg charge failure to prevent infinite loop:

   alloc_hugetlb_folio() propagates -ENOMEM on charge failure, which maps
   to VM_FAULT_OOM. Because HugeTLB physical allocations are high-order and
   use __GFP_RETRY_MAYFAIL, the OOM killer is bypassed. Returning
   VM_FAULT_OOM leaks to the #PF handler, which cannot make progress and
   retries the faulting instruction indefinitely. Fix this by returning
   -ENOSPC instead of -ENOMEM on charge failure, which maps to
   VM_FAULT_SIGBUS, terminating the process cleanly.

And while running the reproducer, I checked this routinely

    head /sys/kernel/mm/hugepages/hugepages-2048kB/*

and found that there was a resv_hugepages leak, 1 per execution of the
reproducer, unveiling (4.) below.

4. Move memcg charge earlier to prevent reservation leak:

   When mem_cgroup_charge_hugetlb() fails, the error path historically
   bypassed vma_end_reservation(). Since the reservation had already been
   committed via vma_commit_reservation(), this left the reservation map in
   an inconsistent state, leaking resv_huge_pages when the process
   exited. Fix this by moving mem_cgroup_charge_hugetlb() earlier in
   alloc_hugetlb_folio(), before vma_commit_reservation() is called.

Testing:

+ libhugetlbfs tests pass
+ ./tools/testing/selftests/mm/ksft_hugetlb.sh passes

v1: https://lore.kernel.org/r/20260707-hugetlb-alloc-failure-fixes-v1-0-5bbd3a4b836d@google.com

The series [1] has some changes that are dependent on these fixes, so I'll wait
for your reviews before continuing on [1].

Thank you!

[1] https://lore.kernel.org/all/20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com/T/
[2] https://sashiko.dev/#/patchset/20260518-hugetlb-open-up-v3-0-e14b302477f8%40google.com?part=5
[3] https://sashiko.dev/#/patchset/20260702-hugetlb-open-up-v4-0-d53cefcccf34%40google.com?part=6

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (5):
      mm: hugetlb: Track used_hpages when getting/putting pages from subpool
      mm: hugetlb: Fix subpool usage leak on allocation failure
      mm: hugetlb: Fix folio refcount mismatch on memcg charge failure
      mm: hugetlb: Return -ENOSPC on memcg charge failure
      mm: hugetlb: Move memcg charge earlier to prevent reservation leak

 fs/hugetlbfs/inode.c    |  8 +++--
 include/linux/hugetlb.h |  4 +--
 mm/hugetlb.c            | 79 +++++++++++++++++++++++++++----------------------
 3 files changed, 52 insertions(+), 39 deletions(-)
---
base-commit: 0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
change-id: 20260706-hugetlb-alloc-failure-fixes-c7f775eca29f

Best regards,
--
Ackerley Tng <ackerleytng@google.com>



