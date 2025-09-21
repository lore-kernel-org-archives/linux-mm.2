Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60C6FCAC5A7
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 05:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EB678E0002; Sun, 21 Sep 2025 01:45:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B2B8E0001; Sun, 21 Sep 2025 01:45:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B18A8E0002; Sun, 21 Sep 2025 01:45:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EAF228E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 01:45:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63A7A1DC098
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 05:45:09 +0000 (UTC)
X-FDA: 83912169138.12.9260950
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C1154C0004
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 05:45:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cl8tO/bR";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758433507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JNXQ7XIu0fz9LKitfDfRv/5GsRWOvEXSnCvtX8rTplA=;
	b=oc920gOU6LkTa8p8kwmFtPGDmE0V649BPfcjwncA4m2LLUZK1KLA4O32s0RD/YPtcP09xq
	HHjKTN5PDqQLbbbdwUTV95YLLdFxuypVRN7Nut41755ae62UoQhFwlBLLbGVkCadfxny4O
	I20HQ8EMvcocLVe2xAdg6VmjHoseCP0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cl8tO/bR";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758433508; a=rsa-sha256;
	cv=none;
	b=z8vGQZxOY2eEf2vgqysK36JlqZ/F2Kr+FUzLT+jx1SSze0RGdoW63U4rydodBQDVREdJt5
	RVYZ0VX/6CKWN+2GrqxpRewnI0AB1AqMaOtDDDZHN61Z6LzW9Ko86bhsS4M/fGxYzvPMbY
	cTOh5su6MNCq+9UZG2MGwzeMhDoGNeE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 42D1442BAD;
	Sun, 21 Sep 2025 05:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA553C4CEE7;
	Sun, 21 Sep 2025 05:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758433506;
	bh=nwWluE/HYzt54TgZr7bT7uoFJDOTM+N37KaOXrsGYlQ=;
	h=From:To:Cc:Subject:Date:From;
	b=cl8tO/bRb/V9ewUSs4La8qYHpF4Z3+KoUTgHWBULmErJDhTF7Ix/56fjyZ5NbYHey
	 Yzzv4ucletwMmo+1u31sQpVt8TR4cPkcSaFdi6i3+UlzIFYCuNHoOkfYcZhA3YpH/5
	 BbbChUN7TmVGwECjW8b1FtMXzpt2PEbWepqoBSqCLctJleGlZcu3U1krwxKmx32cFm
	 E/A9FM2fVN+MK/GVLAlqOcSOSwPjMLVD4vTs9rJ1+vIh+oFqMrV0KvQprMriZcXnqS
	 JE03KZoBV7XjhxPmqc2RJtDfVItMEFhdO0cl2LUIYyWRII2eFJ7gW6mPIahoOwP6rC
	 I65J0fb9eQJRg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/4] kho: add support for preserving vmalloc allocations
Date: Sun, 21 Sep 2025 08:44:54 +0300
Message-ID: <20250921054458.4043761-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C1154C0004
X-Stat-Signature: gutsfgu5fxwhzjdgdmzys3j85wsd854o
X-HE-Tag: 1758433507-724410
X-HE-Meta: U2FsdGVkX187OXWyoyr2GVC1/B7Fy5ovD8WZAZ3HTTVM+mOaRh6A9+gAKj9c6fyJLagtiWp/L4fcs2mOVYQhkEjU3vEtDq4d2/QKljpqhuN64vK4HwK8Y5mUHqMp7eXtUEp3x52pU9+pb0JEH3jOymfuHo0gcSNITw9roiunVbz18qO4BFPx8lXivxaLQAbodOX3EdJY6J7Bz92HFcX6IWwMyrADXSGroDrPPXm/gwTp5VHPt60SYKUmlKw5mTnC6ARIysagdLN/FFPj6J9+mHh66V8ppT9FCfepFwWvvJYCHgtTLZSMA4dZtMYQWhAralRaDw4lDXdy3Ae5qsMPCLBWsCT/oss6cK86aov9DqRTXwTYCVVC3/Ere1w0zzHfUv+sJe+D2/TUZHcva03tuMCRUHAvonuyGuSh1Ck7HfU13w+KeAHQo5FggcSy15ntqDqMQtIBy059Tt9xbzHH2UEHUIJ0p08p+30MU5a7dVdc6anLaadd/UslwCsF4OmQfDJG5XfsauaqFntprjVOiWzw/QWOvjWbBkCmaYOaXH1XElxH4lYk2lP7+Dga+s7jy7Sivt+i3A3AZwSV5UJ6/wgYVOeY9/zVTtsjbfy/xGI/4Fr6KaHTr+/zvChp9KpceSLastxly/OO1YmTi6+pErloK2HlzujDhRejE328r+HoJm1fEZQnFzqDau1atjc/za/lCnwrzyNNB+56C+ZRmEMAuiOQTmp1CU+BsETKpyjbTxxlDqA5J+BzFJJcPXf/CLnbdguGf+ujyWl+yoQbTDPn6ftEujTwP28QkJfADybIfadnf/+X/TwMQdqYVMK1pg6jzNuV6lzClEROTD68TnVqGCFuE9W1jUdHk7QT0nLBLzLNKDCRn+xOuD7kuNeiG1UDkT6FK4T5HXWYyRmeWVOwWrQHHQfBpaDrOWMqbkCWp84KUJ0nMnEykcuZqYLFupez0vVSdFLU11onBFG
 /zZy4qpO
 oOabbixR6hCP63GaPmS/y3ujj2ge9TcL/jlH7ZcKtiLU3ei+StY9BBce6moAobRNsVlBv3D0tYHqbpMtzj8sHrCNdVuuLeh3M5ZsZ1J9tyMzcUsyLslwHez6xLfyGNfEM3eTDjELJ6mZm+CISJ/EpIPhPzOF+FmQhsVYAWX+IcNhjASoPjQwhNUyhkpFJibaFbY2hg8f006icuT0NHAhiOkFS0CUmSsVHYjTpgzCBg5t/tsEzkuqjcLedkK+AqUZLdju4RRVe78I8u/w4iZ1GDu7ihlV5mX2QP7V1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

Following the discussion about preservation of memfd with LUO [1] these
patches add support for preserving vmalloc allocations.

Any KHO uses case presumes that there's a data structure that lists
physical addresses of preserved folios (and potentially some additional
metadata). Allowing vmalloc preservations with KHO allows scalable
preservation of such data structures.

For instance, instead of allocating array describing preserved folios in
the fdt, memfd preservation can use vmalloc:

        preserved_folios = vmalloc_array(nr_folios, sizeof(*preserved_folios));
        memfd_luo_preserve_folios(preserved_folios, folios, nr_folios);
        kho_preserve_vmalloc(preserved_folios, &folios_info);

[1] https://lore.kernel.org/all/20250807014442.3829950-30-pasha.tatashin@soleen.com

v5 changes:
* rebase on mm-new of September 17
* use kho_restore_pages() in kho_restore_vmalloc(). Required to resolve
  a conflict with "kho: make sure page being restored is actually from KHO"
* use more descriptive local variable names in kho_restore_vmalloc()

v4: https://lore.kernel.org/all/20250917174033.3810435-1-rppt@kernel.org 
* rebase on mm-stable
* use 'struct kho_vmalloc' as preservation metadata instead of storing it in the first chunk
* separate KHO flags from VM_ flags
* unreserve vmalloc pages on error
* add checks for under- and overflow of preserved metadata

v3: https://lore.kernel.org/all/20250908103528.2179934-1-rppt@kernel.org
* rebase on mm-unstable

v2: https://lore.kernel.org/all/20250905131302.3595582-1-rppt@kernel.org
* support preservation of vmalloc backed by large pages
* add check for supported vmalloc flags and preserve the flags to be
  able to identify incompatible preservations
* don't use kho_preserve_phys()
* add kernel-doc

v1: https://lore.kernel.org/all/20250903063018.3346652-1-rppt@kernel.org

Mike Rapoport (Microsoft) (4):
  kho: check if kho is finalized in __kho_preserve_order()
  kho: replace kho_preserve_phys() with kho_preserve_pages()
  kho: add support for preserving vmalloc allocations
  lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in
    fdt

 include/linux/kexec_handover.h |  33 ++-
 kernel/kexec_handover.c        | 361 +++++++++++++++++++++++++++++----
 lib/test_kho.c                 |  41 ++--
 mm/memblock.c                  |   4 +-
 4 files changed, 381 insertions(+), 58 deletions(-)


base-commit: c565f9816932dc8d164bd8c69acf077840565ce7
-- 
2.50.1


