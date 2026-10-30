Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96FB2606A320
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OwlKgzrh
Received: by kanga.kvack.org (Postfix)
	id 903E66B00EF; Fri, 30 Oct 2026 12:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3EF6B05B1; Fri, 30 Oct 2026 12:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8E56B05B2; Fri, 30 Oct 2026 12:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DA806B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:08:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D0B0F16077E
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:08:31 +0000 (UTC)
X-FDA: 85379775222.22.E5813B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id E24821C000F
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:08:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OwlKgzrh;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793376510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9O1rcqNr1AcHekWuGfKV17r15ctpxi3BChXDoYrznuY=;
	b=mV8aYMePt6+26QFVOrUoLaNJkMzP26tNtU47Pnd/sOxJ+0gE6xrB7naxJ5SsDVDc7XgcEZ
	HTLLVl1m6OGKTWbhdSYTuIMdWzGGA+Vk/afuFKkGE9fVjdVvM1ph5lmmr5VyyBCiRZaC1V
	+CdvzSSASjW5Nz+16bmYbh550IbG6zg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793376510;
	b=FNrMEDGAVWIjf9U4IuQiwb0X1MWOoeGwTMadUa2AMenqBmr7OFF5sAkOTNBBCJptm9c5uJ
	G/+P0Ke4aMs9KaRhqs+Z1KOhy6VsVtQhLW2DJ65e/69HJXfKM1RBpX8DM+WJavThfRVwGc
	b/EToEHDcPoT0MZC5kZ2iZfbXNBczmE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OwlKgzrh;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A01843BE9;
	Fri, 30 Oct 2026 16:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C151F000C1;
	Fri, 30 Oct 2026 16:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376508;
	bh=9O1rcqNr1AcHekWuGfKV17r15ctpxi3BChXDoYrznuY=;
	h=From:Subject:Date:To:Cc;
	b=OwlKgzrhrGANdHCfoZxIoGMCdm/mn5n0ctbxVqy1/46A0Hy/078uNCQI1dWnHrJC5
	 IxXwIvjDEFYpugZEiFf9Vrj/EFk/d0oW3huRmwcPTsi+/WpIsoI5CVR+qeBq8koskm
	 ciOJHsgWP6fMA0VtLLp8IKOtmJkgdIP4JTPas6CogrEb4mGxlPwK/kovjq27Lrt6Fd
	 roOD+hmUyHhCfpMUfe9g8/kOFj9VE7oCXc7LYzsKSeP+fgD3uYqi/FfzEc+3SRckX6
	 B8+OrjSedCMU5xghbpKlt7LG2syjxELihHSFYZwgDwPh7dMTdUJnGRQ/T8Bzo1gaFq
	 WqCg23ArA57Fw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH v4 0/2] rust: add a few helpers
Date: Fri, 30 Oct 2026 17:08:02 +0100
Message-Id: <20261030-cpu-helpers-v4-0-a8d840d34837@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOLA5GoC/23M0Q6CIBiG4VtpHEeDH0HsqPtoHaD+KMupg2I15
 72Hnjirw+/bnnciAb3DQM6HiXiMLrihTyM7HkjVmr5B6uq0CTBQDLik1fikLXYj+kCZRluCzCH
 TOUli9Gjda61db2m3LjwG/17jkS/v/07klFFrSi5qzXMj8XJH32N3GnxDllCEDSv2hSFhZmqA3
 LK64OUPFhsuoNhjkTAWSlcoERUXOzzP8wcpGRv6IQEAAA==
X-Change-ID: 20260215-cpu-helpers-08efb2572487
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Yury Norov <yury.norov@gmail.com>, Yury Norov <ynorov@nvidia.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1773; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=nOQZBAdSsfqL1cwWeOH66glGnr02l9C2Oaj8/lltJyA=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq5MDnZR+MrJpkQBYypcGirQ7OgXaL5NBhnDCCk
 Smwr3g5bEKJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCauTA5wAKCRD6UCkIqsW9
 0Hk0D/97AMKt4WuL1t8JBsQPGRcurnnjoAuP/0MXdPielmXq5unkDKEZkJKuzorGn6Bc4XEs8V0
 BNRXehLDrUFMgLagO4osYDpGai1mvLYSfN5j2oghlIZm7EKcZxfPe2ZDdq/0IC1aDUNPwl2yNBv
 vRxduUVb1HMdHfJbubIHq96wiFs05rPYgfEqmTWwPXTVt7xylCvTFV2y0C02po5e+Ammotn1vGv
 lSKsfRS7jFrCCUiAQ8s/sWPNlgQDbZVgBl9xqIYX9FRRgMnmAh9syrmaQr/YxRfNv+N+2Q03NWc
 Md0VJHjDrJ7hsvZZZcZN3sggBGwPWRUjH8+O1ci7oDIrMdY7s5dQUJB3dRm5CWULqIQ1ZHNiFPu
 x/r0Pj77kGdL18KGayhlEvIlqcudXuVyChNO/ovZIdz2q0WqFz8zxpGvf8FdVtq0lZvzbbeLpCB
 uDhCn375N6ZmCVmcKM5lNmC0Nq3DEAjbfrn01nR7breaDdtXO8QATDm53T//A1Do3dCP9maubiI
 VLYU97E9ksaLGQLs8Nl6O3HC8J2PQopbQT4q96KYEAR1yUwnnyfEKugyul1vE7jM1koOmC4vgtT
 V02dxETTw+M76QnFpTKWyMNW/8d5X7Az1crIKdTRsCLicdQJ25UzGIYTtjVokgW60N4qbXyaMlF
 erj8csXKtK3fZlw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E24821C000F
X-Stat-Signature: uru7ejadnpid71hi1is7hrkgjtb3z8as
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793376509-317770
X-HE-Meta: U2FsdGVkX1+wJ9nVGPoL7cd+McCLUNDCEJEu3jWZh+lJvzb1sxmyQeZT643xKTIinnS0LVYyH35tlEyJmpVxyhKpM0rragIDoHxHEk+JTJHFi082kMSH5L68eAvrSZL7pgED8qeeixhCZYHVtAFgEEpvbekzTX/9T+4jL150u0zLxyWIesirB2c1UrVb9iX8YFhS8n8TYPzVbZ9JjRtsjm/HycTdggWCOBJaPs3Wh26sGtgzrjahk0HbhqQIxD7osjk2ZfNuz3Xt9CilIztC2SDSuSlOJdL92ybaf8nH6Jp4C1CwALaLc/DG1To7ONWd2B4vLO6nGVxkvftSH8pm3aYae+yMvTVy6vvXLRSgJdb1nDTF24TDSoz7VkXQ/Txcw75t94OH1/7UMcKoDsiriMgvbRT8leomKAHetWZGkTXOeZvXN3x+Reb01BcP4lqDKiqJG4YkAp0b9cFls4a1Pisx85dG5uCKi1M5Zx9bRKJoTV5MkdNCQeGYmc+URaC89StX+NAnSk5bNYOoyFS6J4oaoCRsKD1vQW9FikkLnOfT9RE1J3cbrefQO9cjOHBxkv/4QY/XEG8alGYz1LL8dsAuLP4BN33YJpzr0SD1yfPVnlWFCB2KTdAFj8JWFobmaOHYRYIAxiFUA/jVRbOgs9SLiipSo/gYOmEF0HGHSV1DM8+0dNx2TciFpZybY+RrYcQZe8z8r2thKmzv5sK9VZY2cV/D6fYri/ZgrGAfgMBSCgNOELWbiRNqGLyJ+04dcpNvje1c9astMYRj5B6H7b6JJ8miM3394ze/HvM/QJUpVUopb0Ck4zmHC7R70af6esvKwFZ0x1bba7CMde+Ok78bG0Naj6getdk+w79ugZ6kQfTSSPNOOYQLGLjgU5gQjHwKTEO57h883oxmC3Sx9vPOgVHpuTrDAfxNr4n/m42opqjL+FQAFGETSJbB5dDWHpVdfIit4l1ZGkOxIrS
 B+MV9Ota
 pfRxUpn9AaBY8rFGENzC1D9kaY/8jRVUacNlf8ltMrX8nfyltiQpD/59pOjRTajjNOwYyMxoUiXCffKgg21wOH02QPubCeOXB61oJzj5zKSrciI07azR3oabJU1fQxfplxR5mTbUD8UnRpiO1TgH6KIT+sjUPyJI30CVzSFvBFO6GkokgNTkcrQyOI9lHjqtAcc0GOfnXsbI5P5e6UaJguQzh/D7oyYgWgT7cr+ukzNgjDgRgUII+TLs+WQgsEazC9S1eWj3GKs7e5sfHLEx7qd4djND7SRSPyS8aLfRddEgUNP1TYaDqRM2g+9ZfpW+hZw9Z2AFUyulupO1UDPw8EnrCmvQxzExRQ1kA3I5DJ6MVf6o9+Oec/cgj5xuMoof6rVdyARcjch28cIy37eNhn8sudQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series adds a helper for obtaining information about the cpu count of
the system. It also moves the `NumaNode` struct from `alloc` to `numa`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
Changes in v4:
- Dropped patch 1 of v3 (moved to separate series).
- Rebase on v7.3.
- Link to v3: https://msgid.link/20260929-cpu-helpers-v3-0-e968ce5ee613@kernel.org

Changes in v3:
- Drop Alice tag on patch 2 due to restructuring.
- Use a relaxed load to read `nr_online_nodes` (Gary).
- Move `NumaNode` from the `alloc` module to the `numa` module in a
  new patch (Alice).
- Rebase on v7.3-rc5.
- Link to v2: https://msgid.link/20260605-cpu-helpers-v2-0-0ad227f0d91b@kernel.org

Changes in v2:
- Move helpers out of the crate root into the `cpu` and `numa`
  modules (Miguel).
- Mark Rust wrappers `#[inline]` (Alice).
- Mark the `num_possible_cpus` C helper `__rust_helper` (Dirk).
- Mention the Rust null block driver as the consumer in commit
  messages (Miguel).
- Link to v1: https://msgid.link/20260215-cpu-helpers-v1-0-fab13d817a5e@kernel.org

---
Andreas Hindborg (2):
      rust: add a wrapper for the `nr_online_nodes` C function
      rust: alloc: move `NumaNode` to the `numa` module

 rust/kernel/alloc.rs           | 30 +++-----------------
 rust/kernel/alloc/allocator.rs |  6 ++--
 rust/kernel/alloc/kbox.rs      |  4 +--
 rust/kernel/alloc/kvec.rs      |  4 +--
 rust/kernel/lib.rs             |  1 +
 rust/kernel/numa.rs            | 62 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 74 insertions(+), 33 deletions(-)
---
base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
change-id: 20260215-cpu-helpers-08efb2572487

Best regards,
--  
Andreas Hindborg <a.hindborg@kernel.org>



