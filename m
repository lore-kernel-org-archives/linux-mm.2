Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5081B60A2606
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 22:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=j1U6SQv2
Received: by kanga.kvack.org (Postfix)
	id 6F7186B05B0; Mon, 26 Oct 2026 18:06:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CEB96B05B1; Mon, 26 Oct 2026 18:06:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4E56B05B2; Mon, 26 Oct 2026 18:06:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 356146B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:06:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B27384086A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:06:33 +0000 (UTC)
X-FDA: 85366162266.10.C4D57A8
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1E26940009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:06:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j1U6SQv2;
	spf=pass (imf27.hostedemail.com: domain of 35s7faggKCGERJG9V9I9FNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--skhawaja.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=35s7faggKCGERJG9V9I9FNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793052392;
	b=fDGOHbxFaZt+Y5Uep7ziPx/vVVIBnRxFFe7EPHANmwR/5uca5ZDPWEKSezBpGBlqB1Va9V
	+tVULaGVsUxKKyTTYSN6ZGoOXwJ4FPu0wCMWrflmAk7C8wB3iGavAVauz4G+BtWzkd98Hi
	3FqRlxfQpa1HcOo1enu58n9cIHvyOlQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j1U6SQv2;
	spf=pass (imf27.hostedemail.com: domain of 35s7faggKCGERJG9V9I9FNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--skhawaja.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=35s7faggKCGERJG9V9I9FNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793052392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4Disj2F29OKR5YWAXzU4pjttlvpvFspexRzVXwUoCj0=;
	b=HLygYAyMsNVu4i5oEuRCLeeOdE1I2MIiiqZwGMgLEqvd31ktS5zE8CFKJnwQbvV9fKXOkk
	q2Ky9XdDrmxDK4+r+jO7eILxQafQrUfxB/N0XN7dxdqeBqsrv/ejedZMPWvRHNIEWdO/Q8
	lp8VFzCWuVPU+n4dnQBhto7UOIdMpwI=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e60770381cso33826925ad.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793052391; x=1793657191; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4Disj2F29OKR5YWAXzU4pjttlvpvFspexRzVXwUoCj0=;
        b=j1U6SQv26PKX1gyG6sRqqpZQfi2FmPLol0XsCw+JhuA1auhX+/FHfyz+KCB+ZvbfRn
         r7KD5sHqJQxd2CYR2SDPd5kKLNEMsnY9XtJs5xwl8qwTnN1AXUfh2DRgZZHHmoQs1md4
         uJLVa4jnROb0x/L6K+I4Le5aeSlAoBIRi1Yf3SLJQBqmD+CQnblgQw4hdDUT2CWOBR8r
         AxGp5DGtspfTkp8XW84wVc9Ql9D/ug8Ozq6YhfOTdKKIk7FHa+XOPqcI641uTEzquzwS
         eSBluSHetQFs2seaub9f+FeyrP8kv5zUybBbadczGyDYjEzbs+NX7p9KyCcQl20kSAC2
         ooEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793052391; x=1793657191;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4Disj2F29OKR5YWAXzU4pjttlvpvFspexRzVXwUoCj0=;
        b=mB9ulfFSoqymWTp05kLWxhRMmsDuw0Veo0/r0SqgJVGkFU4LwgY26vJ2W3QpV0+meb
         CeuOQ3kdB8WmYA51PhWHRoou+cx6WIqSFs2ZS1DD8c163MHNkE0W6RDlyXyDS960GHfT
         7txJB37E+xluvTEXhjmbKLz29aKYIXPNT+r9aFMgrqKkAT9LRpzjpzIf8Vw5uCL7nOlX
         Wbk8cy7sZdN2J5M4nwF8y891gAlJRLh34KnmkWTIocA5U4qEPcjpz2P2+iHQrikwVxnd
         WKNPyqw65N01lunpCei16is3b7YpAspiOeQc78kZZq8HznLBpmUZ/7dK5j/WoukRsJtN
         wJjQ==
X-Forwarded-Encrypted: i=1; AKwUvBzOiV+fAfDvL/YbhLXddmJ+m85Tp0qj082nfDUFxA7hEXeQjF8+fCKfxJEisylZxF5g2jpYCmaeqA==@kvack.org
X-Gm-Message-State: AFq9FYIdZyxiwcRGx96RJQQopVs+QFZYqB4HWDnEj8PE7hQxB7FbOToN
	+eXhptEVwd2Z6eEZm3Y0bCJdeNUpBg8Mb2BiGfWCbdCjyeS+FNZ3xARM8CWlAOLtmEoVUxJFQoH
	5T0v84qA5DtQ/2Q==
X-Received: from plblk3.prod.google.com ([2002:a17:903:8c3:b0:2e5:ff91:ecf1])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3803:b0:2e9:5829:9b48 with SMTP id d9443c01a7336-2ea9c6c359dmr62263545ad.20.1793052390732;
 Mon, 26 Oct 2026 15:06:30 -0700 (PDT)
Date: Mon, 26 Oct 2026 22:05:44 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026220546.3114241-1-skhawaja@google.com>
Subject: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
From: Samiullah Khawaja <skhawaja@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: y58ghnsrqcsjw4pkk4k1dtmey75g1ecx
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1E26940009
X-Rspam-User: 
X-HE-Tag: 1793052391-335857
X-HE-Meta: U2FsdGVkX1+5WcjraNDPeCFvBEI3ziGSCU/71Y+sw3GIXk6YVRo8S0tIcYVb6Xf+Wai1yfQv1la5Gi5vZ9Re5OBwSUGk+eBLiZ53nQLxJwLzgY4kjbIg461rxmfd53y1YWZcTVI8B2E2aUaFAK31KuWkwkhB0DYwLZOp522Bu0IQcQ6tCgT7ZdwQggolwLHsPqzP3/5Jtf6Nrus1eLJlBxarE+H3DZFT1jj9NwnCD1/UiAm/4RJr7XXcLr9YIy/kCMwjXEHxXdyuSHRRpOq+wZUq9s6O+TxpTuicCI6rxrxHxslTH8qEGWU56SK7KJ57Ght5gBZYQIYdvfaZySPpUcVivMXyQX1TUqgUyMf22ugIjE0dcUUJx8fDwdg+xNSBil9Td/AlKIwfmQ+kclDD0cU1zjFMp+uIFNYji9fss49RcYA0davqDtxq/xwFPvG29Zqugi7F6ZT7hi6LSdoauhvkyba2m5PQpww3djVJ4YOp38rFBz87/eI/keDl038IRy+RV7KvnMd1HxzmhWZZMM7yZOTbtBBWCoSStA/Un0+47RR6n4khrX2HHrvkTuGeRogUW+1Yx32/J7G5qsAnGCE+Qh6bD3twdMPY2o3TPuMqA9gkK69d7ATN3+UwvGL01yP+fPJIvgmunozIpou22DyQxg1BnjeQ+VDh6i2i17FBakdhE3aCgiXutTRCaurG9FjDJq75EW69iko7RPszxplUyyOUXtoOQq4ta24AT1ni+la91kwgB1XcUWdOtaysWVykACS/3LKyScITp75rbulm2rT2J+j6Ks22ALJ6BzGZjLqydGFfHL6Rn4+0PkxRapD0L29eV1fLBV8MJ6ZhDQZ7AwpCKGiXutBHs1pix8MMjXF7hqFnDypLqIY6senmasJVbKau8oY5X2B0wj5dah9bU0BAEqamVxIAYX7lpiKf/aGUuZ3uKmPOTYq0oA070oAai3SsWitQer649te
 xGu0ayG2
 eVTOewlEng1UwdV2DF+oNNJhMKJMN84BNMc0VcZVMHPgpl2OXyz5j1MP3KzwF5TCtFJxn1kUDHWEMkMDhSfvXSDslkkPGQVwBxmyUIDeqxQ1H2H2IumFruQafJL7TVgIBB6is1tLk79FpFB6/69hRVpHMG/qbn7Nraw3BNGet5NTqi6sNs4AaQ1nelq8BzXldf1t2uOMszbuGY5qFV1Dnya7YVNc7iwOW/GN09t8BxNa9tkuAkVp5LLL/qrz6epMENqdEg4wu9rES2nTPkVfGmlaiUAPRQIAQVfBL0O/DIaf5LBJaSHK70K8+46UAl02hwBjjLehvcha/GWvq6lC62HMl7LNOrFiiuV3gr0nHXPHjAQCFLTsQyDHxAGlUbaLb7TLBHDy9KbuqdJFLV3zBtCuvBqj24pL2iDNQkOFIOK21iecHu8bKzG66RWEvHiWN4tEjeEFMed1H6WPzFGY0gGBQigRN7CuuNfUypFiydQmF1RiGvp55gD7FkrSD2tcccP+GMxdR9O8du2zKSOJs17jEIpCipH3UeaKbKRcm///+kHBITbnHQYUmhPooo8xJ5mHb9wuBoDglcMza23CKMUJzdSUQ1s4LFSfu4wDif+SPQHJ9HaU0u0TWvsqp7YYeIKcMI0pExQNzJNHgii/by2gdb3Tk22aNOsrixZMIWc4Bp4KN1cBx7dXa2acsWb7qG5QzyDXnF9KlXXE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that prevents
holes from being punched into a shmem or hugetlbfs memfd while leaving
the file fully writable.

Background
==========

Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
memfd_pin_folios() to pin the folios backing a memfd and hand them to a
device for DMA. Pinning keeps those folios allocated, but it does not
keep them in the file. If userspace later calls
fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range,
the folios are dropped from the page cache while the device continues
to use them. The pin holder is never notified, and from that point on
the device and the file silently diverge.

The existing seals only partially address this. F_SEAL_SHRINK prevents
pages from being dropped by truncation, which is why udmabuf requires
it. Hole punching, however, is only blocked by F_SEAL_WRITE and
F_SEAL_FUTURE_WRITE, and both of those also forbid writes. That makes
them unusable for memory that must stay writable, such as guest RAM or
DMA buffers, and udmabuf explicitly rejects memfds that carry them.

Proposal
========

F_SEAL_PUNCH_HOLE fills this gap. Once it is set,
fallocate(FALLOC_FL_PUNCH_HOLE) and madvise(MADV_REMOVE) fail with
-EPERM, while reads, writes and resizing are unaffected. Combined with
F_SEAL_SHRINK, it guarantees that userspace cannot remove pages from
the memfd while the memfd remains writable.

Motivation
==========

The immediate user is IOMMU live update. Before iommufd preserves a
memfd-backed mapping across kexec, it must confirm that every pinned
page still belongs to the file. Today this requires walking each mapped
page at preserve time, which is costly for large mappings. With
F_SEAL_PUNCH_HOLE and F_SEAL_SHRINK in place, iommufd can verify the
seals once at IOMMU_IOAS_MAP_FILE time and skip the walk entirely.
udmabuf can benefit in the same way. Neither user is changed in this
series.

The iommufd change that would use the seal is discussed in the IOMMU
live update series:
https://lore.kernel.org/all/arVYa_90j0oN1hnu@google.com/

Testing
=======

Patch 2 extends the memfd selftests to cover the new seal on both shmem
and hugetlbfs. Both "memfd_test" and "memfd_test hugetlbfs" pass in
QEMU.

The hugetlbfs run depends on a separately posted fix. Without it, the
run aborts in the existing SEAL-EXEC test before it reaches the new
tests:
https://lore.kernel.org/all/20261026-fixes_shmem-v1-5-703206d5fa0c@kernel.org/

Samiullah Khawaja (2):
  mm/memfd: add F_SEAL_PUNCH_HOLE
  selftests/memfd: add F_SEAL_PUNCH_HOLE tests

 fs/hugetlbfs/inode.c                       |   3 +-
 include/uapi/linux/fcntl.h                 |   1 +
 mm/memfd.c                                 |   4 +-
 mm/shmem.c                                 |   3 +-
 tools/testing/selftests/memfd/memfd_test.c | 111 ++++++++++++++++++++-
 5 files changed, 118 insertions(+), 4 deletions(-)


base-commit: 7bf01f16a4d05028fbeff4d90bab40df25142a24
-- 
2.56.0.307.g5fe7bd680c-goog


