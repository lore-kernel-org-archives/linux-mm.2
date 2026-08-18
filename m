Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA666C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C748C6B0469; Tue, 18 Aug 2026 06:08:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4B046B046E; Tue, 18 Aug 2026 06:08:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37B96B0469; Tue, 18 Aug 2026 06:08:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 694B66B0469
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:08:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E472F1A0BEE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:08:37 +0000 (UTC)
X-FDA: 85113965874.03.ACA1630
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2471C180005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:08:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=YBOGYUwO;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787047716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=R6QECPvjuHnzWoy68tQycu/tvoKdkiIsFj22ZtQoL9w=;
	b=5LyN88w55dwG0oiD+ZVeG5aEU5Rqog8YFyxdmi9OngYIZI03p9MoOmsExsy8XbX60jI6Np
	1ZskmJWWe5LDgWtGkhJuByaTenxnfc4oCX0m08PXMJsGTrXJlo2e37yUxWlsFeTP8K/j3T
	Vrq1DX+Rg1wOCS8txEdJGDmwdoDWbxU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=YBOGYUwO;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787047716;
	b=GYdo/95vktgWJMN2+muZOfZNB2cjooXrhCah7HtMCqKL2wTYqcQ4OxD4JVC4ZhSPP+dKqP
	Um6m7/qdxu3nLXp+dkD5y0jTVX8/KNKiG1762vDSAJFYtEmGpSNZXtZWTArEpjvTUoE/Ru
	dZ3LT2Anl5NAhY3w/yYTT4JR5Lfw5qo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=R6QECPvjuHnzWoy68tQycu/tvoKdkiIsFj22ZtQoL9w=; b=YBOGYUwOyBZAQnT9YSZhWh+OKb
	+VvM6EvZqlyaya736wv/HKh4jxVIhWWlEDWpL0Ys4V601J7GkV5LLW/wKPyxWFS4vSqOZyy5riYB/
	TFgnuCcpS8Zp29uz+Lt2AVAZxpD+hWSeI+h5jiqDukP4NpPUBdriA4bJQwisKyXdu7WBQV7cJSRUC
	Twc/b43n6xwM469iKSPBxogbgfNZj4JVszAjFPGPaGWU9GxhJuDw5hMy7RjBNlJf8m+Oi6x8tzMfr
	7INf3As29XenBUwxwSzBQh3HEljmm34qTfXvE17fRkJ8Ljdw3mGX5A1AcjflYPi1NbfOrinla2ChW
	/0aADtVw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wwGju-008wGE-0G;
	Tue, 18 Aug 2026 10:08:15 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v3 0/2] mm, swap: don't spin on a bad swap entry
Date: Tue, 18 Aug 2026 03:06:22 -0700
Message-Id: <20260818-swap-v3-0-d3fa52598a59@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJ4uhGoC/13MTQ6CMBBA4as0s2bMMED5WXkP46KUAboB0pKqI
 dzdQFyo25e8b4Mg3kmARm3gJbrg5gkalSUK7GimQdB10ChgYk1VShgeZkEucqa+tlVrakgULF5
 69zyZ2z1RMLqwzv51qjE96h8QUyTMykJ6KnXJpK+dtM5Ml9kPcAiRv6/sczES5kZzYa1pOyM/1
 77vb1CeMIPPAAAA
X-Change-ID: 20260810-swap-25420f9c8ba9
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=4282; i=leitao@debian.org;
 h=from:subject:message-id; bh=EpRekKeJErc7riNVvzlHY4uk5Q+1vBOCn/GZz1HUxJs=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqhC8HdheuIRdy8cccDbH5livISsOm7LqZewDOA
 kGie1OrtY6JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaoQvBwAKCRA1o5Of/Hh3
 bbS/EACLHmfM1kpeEcqpyG0wiicw7JowaCWTHzM5xk1jZcH98yp8UMEF+XxTvcL+IeLNbgISVrI
 GZ4Yg1yRuEdCHQr9oo/OeXWzb9gYERqaS+hCQOA86mLKZePipWHc2Wcqk7JDgyCbgETKehYV6Ch
 IKqrk5nj4q1CdoGeShz4uUoB1YxXQwXwX6NqTATW950lROXLroR8RO1ZTDdrxoHxRtKmMu9V8c2
 xoJnwBoBGRoRlHPoYGMtRzDlzXKrPe4PhC3B1wKfY6hA1iUonucx734eZzFMuT7HUOO+tlg0tow
 avdb6dHag00l54nmfHZHRFh7c3yKWWC9d2o2ZsvFcRP4/gZhHjFyLqqKJrLJPIZO9nIrtAn1sVg
 WNrNTMTmugrqUyG1quAwJJ/jEijM7lAUJIiNuukoZYV5eYG6TqiTU4tKcm+ou7m2qrp2GjnCS04
 cCZ8aVjK13WDSkvTSioA2xE/kpKFUCbNkmZaXMsj7mg4OG8Y1q+4kZi5XDPSRk/ZzaRcsLQoNC/
 8hPMeIC/afLCf+elN4ruqM9PtJcY+05VRfBw2dk0gGOxA9OGahkfRMx6ni7ihe8HVrQMZVHlRgo
 Ab77Rgz7ZHCWO79JIQ1zEQQnqu5xItooAI7PHAQquvsT8eFnxVezI4/pcfk7f9G2jD3dvmH03xU
 2DUc044qWXTwQVA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: wjxqmzfsp34c3zm3q1joykuyp1nty9fo
X-Rspamd-Queue-Id: 2471C180005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787047715-840627
X-HE-Meta: U2FsdGVkX19s3h3qU6oFaAyN3WHuFvRVYYD9l44mkQrV7Fd5/QI3IZuhIvohOSfldxgJ40KhINtpz751ACi5f/m2EQ4N4ldc/4HQn69WZu/noHPyBFKGBovdKKbvvL2C3MF53NBaZVcSExvs/7Q+DTEg3PRBnSTtRpHnsqbvF2sqZRlBGoqDYjGaL6i5Pf4U3Bo1yLsrheSq3z6F2zfz7qn0/Tl8TFlimuLb7dkWj8WHWcPAHjXElDwuhFM4MyqW8pSGoH7cKVO2AvS4mrNR9hWkcW1dpVf4ncz9aVyZBTXy6CNoe+ayUVLUQRXMXVOGmg8DeegVuDJUed9YXyx/8zziW9YuxFMcUXs/KAiDFTj+wXFtNn0GCmc7jw3G1iP6s5bLU/jrpX95Pu/As8G5ZgITT6Aetmg+xPFHpkZtdS3anoAULNOU3NqUuOvE888lETsz8XozYMS6QSyZSiocy9S14zdm4GPkB2ScbGkX2+AvOHRUEStfQXE1Axl4dZmH6uAHyPGJVtRshn4UfzyRxIfePBwt8sM7kUitY93yiGTlhq/Oz87Wdu8utsHYN9vdVQwef+9n1UYQ1Px5WuzEWV4GhNG5d1d88rs8e+ahHJdCCKWYLULCwYjOVZbXvfrbr6YFCnAn7brG9tGh91LrR3MXXG+1LJidK3wXSHw5qowuuFTIcVoLguGvTOPKvf9GyNbRQcOqFEUJiyxW+icK08KVy4M890BukQK9n0oLAiChlpaEMPoKxUpt8F5LMI3fcpYjZfjA3YmGxlvbRFqextG+ZIVqT08UUgIv/6B5GPcMfnzavIj+o0RK+CyyxNxIN/En/JWOkWO4hNU/gI+NXqi7GRLrnginAIgiw+MDdbT1vx83BcCtxpE5B9kRtze0rD57M/5wPyn1ZBnfcevxPMOS76+0AAfkGvZiZfga80dCs+PmWnfr6rpITvvb6QsrRy7ipy5Eh24ayiQtT31
 DsIyG1yr
 HT5vnm03489zMYB0iogfFGMCqXW2nDPMFwV5SmjAYuY99RHWxVGNUmJbfrZXrfJ+r8MCsE7V9gOXF7iQu+xN62HXt15jluD1EfHBY6JP0kMUVF68NjA+SKf3HAvi49YY9qzIJoCf1U1DJX6ZpsySqhQHb4ACEXwf4PuECRrx+bcOS4TOm1c+MX3l8Vw+z241F+j9XYGMxPPNSo4Ar1dWzHJTnzBMhMqdmwGQJk93JoYtYvaKbXsWBOSQ/evzu/xmAf7TcrEoqRNnulzFzg9QLXTl/bzjCttGjV92Ua1TkG68pzpQFL+pQDBNsWDZwgm5ce9nUOHarjssh1aFpaAWHtqQ3Loin40UaNSO9FoN7YPNT5PkfiDD0UWkEn7jeYAXdhqDnyW64wPqqsxknNFDly8RB2pd8OtYTGuaW+1IPZtiBxNZhLRHBlQAnr3dpPVV7E+0Tl+cYiwKncgtsa30ql+tWv778I5rThnEFoz2RFra/y0jvKpKyC3NlU/gcWQibLqYHPpHeli6/jiDrv3ZDdobwRP1e2DsMar/TRH7JFqHmTQsq7b0vk144aQhVPr9A8pSquJBFvZjuZLRMErkFez+1z1LtQKGa4hwuOK2tSM0Cj1OArTfr79PquXBEOTyD9HW9UN/ZD6w7mT2WjWkgtl8bAJ9SSZaQPtybEOhSKGcuXNU2P6eEZKE4mJTXEtAgx5gXpZn2MV3afItsrdI3VwiJAcYShBXRJgOW+k62sIdtnEzWH1L8X40WXHMGCOOl96EVd3JiSqjh8GPv52p3Co8/XrVGqPoaUKMQNKRLI0lgEAhyoGd6K3rDm4SKdXT1OBU9D4ugQsMJpMJ/tnPpGPRRuA/u+6E1QqwA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I've seen some machines at Meta fleet that show the following type of
problem:

1) It gets some weird warning:

  BUG: Bad page map in process khugepaged  pte:f000eef300000017 pmd:00000067
  addr:00007f57c0a01000 vm_flags:20200073 anon_vma:ffff88829af7c340 mapping:0000000000000000 index:7f57c0a01

The corruption is most likely the collapse/PT_RECLAIM race fixed by
commit 366a4532d96f ("mm: fix the race between collapse and PT_RECLAIM
under per-vma lock"). But this series is not about this one.

2) Then the fault never makes progress. do_swap_page() returns 0 when
   get_swap_device() fails, so the fault is retried, reads the same
   entry and faults again. Nothing in the round trip changes the PTE,
   and the same line comes out on every pass:

  get_swap_device: Bad swap offset entry 3ffffffc043c5

Patch 1 makes get_swap_device() return ERR_PTR(-EIO) for a malformed
entry, keeping NULL for a device swapoff is taking away, and converts
the callers. No functional change expected.

Patch 2 uses that to return VM_FAULT_SIGBUS instead of retrying.

The rate limiting patch that used to open this series was split out and
posted on its own as a backportable hotfix [1], per Andrew's request. It
should land first: patch 1 here touches the lines next to it in
get_swap_device(). This patch will probably conflict with [1], but the
merge should be trivial, given the only change in [1] is the
addition of the __ratelimited() suffix. 

	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);

I am happy to respin, in case you prefer

[1] https://patch.msgid.link/20260818-swap_part_one-v1-1-a4fc58119fc0@debian.org

---
Changes in v3:
- Split the rate limiting patch out and posted it separately as a
  hotfix, with a Fixes: tag and cc:stable (Andrew)
- Drop the si = NULL dance in do_swap_page() and move_pages_ptes(), and
  let the paths that drop the reference skip an error pointer instead
  (Barry)
- Link to v2: https://patch.msgid.link/20260813-swap-v2-0-4a625ccabdae@debian.org

Changes in v2:
- Rate limit swap_dup_entry_direct()'s print too (Andrew)
- Drop "in get_swap_device()" from patch 1's subject, it now covers all
  three prints
- Return ERR_PTR(-EIO) rather than ERR_PTR(-EINVAL) for a malformed
  entry; -EINVAL is too soft for a corrupt page table (David)
- Document the malformed entry case in get_swap_device()'s kerneldoc,
  in patch 2 instead of patch 3 (David)
- Reword patch 2's changelog, "an entry that can never name a slot on
  any device" was unclear (David)
- Link to v1: https://patch.msgid.link/20260810-swap-v1-0-375ef0767206@debian.org

To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Jann Horn <jannh@google.com>
To: Pedro Falcato <pfalcato@suse.de>
To: Hugh Dickins <hughd@google.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
To: Chris Li <chrisl@kernel.org>
To: Kairui Song <kasong@tencent.com>
To: Kemeng Shi <shikemeng@huaweicloud.com>
To: Nhat Pham <nphamcs@gmail.com>
To: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
To: Youngjun Park <youngjun.park@lge.com>
To: Peter Xu <peterx@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosry@kernel.org>
To: Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

---
Breno Leitao (2):
      mm, swap: distinguish a malformed swap entry from a dying device
      mm: fail the fault on a malformed swap entry instead of retrying it

 mm/memory.c      |  9 ++++++---
 mm/mincore.c     |  2 +-
 mm/shmem.c       |  2 +-
 mm/swap_state.c  |  4 ++--
 mm/swapfile.c    | 14 +++++++++-----
 mm/userfaultfd.c |  4 ++--
 mm/zswap.c       |  2 +-
 7 files changed, 22 insertions(+), 15 deletions(-)
---
base-commit: 6b8c8af514d739d0335f5579b585e02babe8a727
change-id: 20260810-swap-25420f9c8ba9

Best regards,
--  
Breno Leitao <leitao@debian.org>


