Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C59C1C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 07:17:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C30F46B0005; Mon, 13 Jul 2026 03:17:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE1EE6B0088; Mon, 13 Jul 2026 03:17:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF82B6B008A; Mon, 13 Jul 2026 03:17:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 911136B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:17:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2128A169FAE
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:17:29 +0000 (UTC)
X-FDA: 84982897818.07.799EFC6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 80FB5A0009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:17:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="he5Tv/j7";
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783927047;
	b=dwf70tKiXc8z3PCNbgrSk23uj7tccLVCrKAC+fKL5xKue+bcFMjMuLSDmIS7jQ7vqSzh3F
	lnhMVpCxNo4Whhnx+jcvxG5H1OyFLHzjhBWjEAk0ZHTRzGSbBgJrcPbz3dfHp3e7XSpwJJ
	ynzPeoAanpdbnB/twKiFSqhZS2bWWtM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="he5Tv/j7";
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783927047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fwA5EpywXnBLHbH1Cr7rvC6VIBFsJ89S1zKzZ9uxu9I=;
	b=wrmtLLT+PDz3RNIJ1vZ234Fro0RhtQDktALhNAVkW0PlI0+m3ahvhk5KkpSP41jZDuhhIr
	drCLIGi5oMfeYl5FJdbm7l1GZREnBRieA4+FeVLl3SuFsx/OlnnxihUk7g/AtVuEfGFWE+
	7saVA3vspj0RawSjb5oxcNR4LyfAgyQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 111F660018;
	Mon, 13 Jul 2026 07:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BCB1F000E9;
	Mon, 13 Jul 2026 07:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783927046;
	bh=fwA5EpywXnBLHbH1Cr7rvC6VIBFsJ89S1zKzZ9uxu9I=;
	h=From:Subject:Date:To:Cc;
	b=he5Tv/j7cf3zzOFF47BF5dVhJt/X5kCa24N3c52eT8BHbY1t0kZ4lsYFZbV9vUrhx
	 AZvs71m9CxHplrEPXkiso3D1O4Rmy+cU8viW9XHnJsbrrbOyqIjdn+rFAw7A+h7PMb
	 TKUHscFL/5MvI6sFQFSc/yeudYs3k8SLDfuYsg2lxDUcUrFMTpZ2wMaZepgCa/uXvx
	 jKwUpdXiZ6NLweDj9z8bjCYNyN3AEPOqievSC5pB7aTB+ceLStoBEqdCP1k6BzH0Ju
	 lbGrgl6zuqLu1YCxoIXEo/CxNSZEncKtqEpGGqZONcJwBKnzMTSPfhQNeNPXmiwpbe
	 Dy1O+vMvMTxzQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v2 0/5] RDMA, IB: replace __get_free_pages() with kmalloc()
Date: Mon, 13 Jul 2026 10:17:21 +0300
Message-Id: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAGRVGoC/0WOyw6CMBBFf4V07Zh2rE1w5X8YFm0ZoD4KmSLRE
 P5diiYuz819zSIRB0riVMyCaQop9HEF3BXCdza2BKFeWaBEI42S4DRw/bCgtcFjidiQMmJ1D0x
 NeG1Nl+rL6emu5Mcczw5nE4FjG32XpYxZ7kIae35vDyaV47+xw39sUiDBOo3ON7KmEs834kj3f
 c+tqJZl+QByGhutyAAAAA==
X-Change-ID: 20260610-b4-rdma-44625922fe16
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 80FB5A0009
X-Stat-Signature: md4k7ps3za6dgb8o6h1n9fto9ixbmxdf
X-HE-Tag: 1783927047-151728
X-HE-Meta: U2FsdGVkX1/ExXUhxmJbsIcJkKx2DWWAnxZm0G70X6LKgrwDZmax1yAuvH1BWl9Dslun2hpzr4nMH4zNvDLjhh+NqEwJ3qycWKHaYuy/VZ9zjNsPeyZY4uOYQmCumJT/sOEU0z7zmzZv+Glhj8WOrMSnkvVLOj0WVcqdi4yK36g1jVEpDhfQoYyzcajhBcwKa73RBi1vnP7S9D24KCyO1ad6xEYWpemUhml+mAs7FYpNh3f7uZlfxd37QsOSkKthnDAPdRnVyZBLUZLPEhWHM/8pB5xPQ8jqcbkDNYeINTbE0ojAmC7knp0295Tb5D6AMDveYduXEOYwgD/YwWQigo3GAY/nJpDWC86CCYOzYs/l2+drJ0PvhjUggEg3Cu6OX44AfiRYd5m+EE7R3GxPPpr8VvzlqCYaUbGqQ6VS/2K/1zhn/Y8K/jVxqz+HDWPvIdvXfKwSMgz3x9yYEHQ0/57aUvO1QWWk+iR563BfBSeA8A/PkGOIP7mhiOVPhqp6Va1s+/9QI/kLM9X4qdmWq2RVqUH2AXcwhrLG2lL7YsfXxADq0CGjs+IlcPOO63rYzQQO04St2cuvmCRayCKu/cw0HPsWCWjhNdStQ9GzcyVLzip7OwPm+9MkW4yn1aQ8V5G6kOJV1VgGEzCcY2GYGSIPgiJIPq53izrZ54FS8SfxeGkye5NVuiO5/gwRT+xPCwHKn89ZM8trSO2knC+yNRy0zAJ8zdMI6Dwt58LTWTXFrnfkF6ffpDQF8660O/hB4Mosai1rwyDf+SW4d2PxAYIcwtxYU2myP8mOZ/5t/pbil2NfIqknnWqZt1Z2HHLQN3sY/8+MOQVZ8tijJfCdhLYz/PmTQJe12eX/oEF5U+X88d+j4x3YYVzXD1YHELyOGm7mH7qvnJx2vqnOxvO/Q8ptLjgBMgVe4bRLZeooOqaylHfgDCSwGhQXdeme3HGV5ttw2wLhG8bTKk8aXzo
 AWP0Kcu7
 WsYuhDKVPUvaJnFZYXyj9yZcaEWp5+H4Vpgk3izwDJyW6eUDTowzxRdTwgSaWah0x4tcPISFwsndf2YTG/2n5YqqLP7yXJnS5aZkgsFB2Oz5QnvVSv6hXSaI2vNbYDTkJOWpbpxc9rUmcoDK8Fx1aGp4jMVTAHqPayGal7KF2hzlL1Hqe56UVaYNYrWZ2it+tThF7FUN2u6ciyqkRIzI3e7CwmzTiFU7qOzN/ZnqUJIhfGkV3tLIp4MygCRrzgCYAU7x4mAuRG+2RQB8phKntl+TlpL+l7AJ+kf2TW7PB40+9Xej8+8qo/RokrTiZNf+Kqk5yle18PjDLlpoqti/YJtIdl0M+/9GyvL07S1h3B1mv3q1F8BfptAFWE8tIbIpid6MMKHsLsFnrvuk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a (small) part of larger work of replacing page allocator calls
with kmalloc.

My initial intention a few month ago was to remove ugly casts [1], but then
willy pointed out that Linus objected to something like this [2] and it
looks like more than a decade old technical debt.

Largely, anything that doesn't need struct page (or a memdesc in the
future) should just use kmalloc() or kvmalloc() to allocate memory.
kmalloc() guarantees alignment, physical contiguity and working
virt_to_phys() and beside nicer API that returns void * on alloc and
doesn't require to know the allocation size on free, kmalloc() provides
better debugging capabilities than page allocator.

Another thing is that touching these allocation sites gives the reviewers
opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
another size is appropriate.

For larger allocations that don't need physically contiguous memory
kvmalloc() can be a better option that __get_free_pages() because under
memory pressure it's is easier to allocate several order-0 pages than a
physically contiguous chunk with the same number of pages.

And last, but not least, removing needless calls to page allocator should
help with memdesc (aka project folio) conversion. There will be way less
places to audit to see if the user was actually using struct page.

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/rdma

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/ 

---
v2 changes:
* add comment to keep markers for sites that need "fast and as large as
  possible" allocation helper

v1: https://patch.msgid.link/20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org

---
Mike Rapoport (Microsoft) (5):
      RDMA/umem: ib_umem_get(): use kmalloc() to allocate page array
      RDMA/mlx5: replace __get_free_page() with kmalloc()
      IB/mthca: mthca_reg_user_mr(): use kmalloc() to allocate addresses array
      IB/mthca: allocate mthca_array memory with kzalloc()
      IB/rdmavt: use kzalloc() to allocate QPN-map pages

 drivers/infiniband/core/umem.c                | 5 +++--
 drivers/infiniband/hw/mlx5/odp.c              | 6 ++++--
 drivers/infiniband/hw/mthca/mthca_allocator.c | 6 +++---
 drivers/infiniband/hw/mthca/mthca_provider.c  | 5 +++--
 drivers/infiniband/sw/rdmavt/qp.c             | 8 ++++----
 5 files changed, 17 insertions(+), 13 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260610-b4-rdma-44625922fe16

--
Sincerely yours,
Mike.


