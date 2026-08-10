Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 263DDC5B56D
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 16:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D21C56B0096; Mon, 10 Aug 2026 12:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD2C56B0098; Mon, 10 Aug 2026 12:27:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE89D6B0099; Mon, 10 Aug 2026 12:27:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 964716B0096
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:27:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DCA0A1BFF
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:27:46 +0000 (UTC)
X-FDA: 85085890932.05.B33F785
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id 65C5440007
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:27:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ZXmcShJA;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786379264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BMpEuC5EAExmI+0zM2GMm8umjal5Myhru9XEpHEvqBI=;
	b=XfGFWB1ONUK2XLzZgKqa89h7lFjfMR2sDjbAWNN/tk/nUh7t8ujvMpE2L6/Xim/GXAYp/z
	OBvukqqlyDw9VHGK3AI/O7X7eXyV6vKX0VpvTuIi5Q5I5vgzCZVqqvQ/bdamoDeGMdN4Wo
	XPIcPW8+pqGWGyh3To1Xv/ouKw9QJjU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ZXmcShJA;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786379264;
	b=W93v1oGKbQrPIel7/XPdoOIyksA4Uaw9wGRcI+Ep2xuyHFhrihszu8SOiT/brwVOhdZxzI
	AczkV1I03Ip0bargUMIfSmtiifmUJvxWo10EJ6Cd/1bJG2Gg+dN0Yx8fxeBVIYyXvldh+s
	qztnmP99gTCNb6kXgFnOtaklFCPlL9o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=BMpEuC5EAExmI+0zM2GMm8umjal5Myhru9XEpHEvqBI=; b=ZXmcShJA5w7Why17l1Povmx9ad
	+O2K/3jFo56MiK6xwlOK8pxh3Kq19+CWYvpNJ0n9TfvDCBmd+SnQ/ShbrFpeDfubJJl65NP/7YZnA
	XZuL26aJSPgcOrn+YQ1aJm1LLZY67GU78hd1Xz625C2j+rKKltrZLj7ADfudJnbBk+nT4RKBKpi23
	xjRqfzfNAAc/zEwIggeCKbbhVPUIYN+NlHMJXBNSGuzr2zFr3of+piou/LvwSW5gP899EaggmJl3U
	c2ciZpfIdXI6exsqXvDacaE6WMfht4SiEkTIEp1Ro/iH96X1d0kISD6dL6E13pmgJ1TsLUat8oS//
	X7KJIg9A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wtSqX-002uf4-0M;
	Mon, 10 Aug 2026 16:27:29 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH 0/3] mm, swap: don't spin or flood the console on a bad
 swap entry
Date: Mon, 10 Aug 2026 09:26:48 -0700
Message-Id: <20260810-swap-v1-0-375ef0767206@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMj7eWoC/x3MQQqAIBAF0KsMf62gUlFeJVqYjTWbEoUKorsHv
 QO8B5WLcIWnB4VPqXLs8GQVIW5hX1nLAk9wxnWmt0bXK2Tt2saZNMR+DgMUIRdOcv/NOL3vB2f
 FkTNWAAAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2260; i=leitao@debian.org;
 h=from:subject:message-id; bh=nJ7VojU8wrPan7dxRkHAqS4AsX34ilWSfKk8gX6s3Bk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqefvoTekUQgxrCabVi0QHxa+ov4eLbm0XOLZss
 6XBTookhl2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCann76AAKCRA1o5Of/Hh3
 bVifD/4hAHv2SkQh53sJb6QbDtBvjjR258t7kyn8wmRhzJ+uyxNjJbwtIhpL0ddaR6e8I0M0puZ
 iw0lnClIpMRAdDNvl2Tp/W32w7X3f/VI+/lQ5ai4vXxkwo+KQUU4FBBPLOFn4W/Hw0b++C0TNjg
 bG6oM2BWf5njyPFl9sSkjhql1feKm3b5MXMm33ICghPBrMxeaEqzjuNM+xOUqAZYfB5hSLY94HP
 17EeDYnGJZiDP9OESzgJutVkTx1zldgibbBihubpWIUOZuaq5rSel9N5Txb9rR7tyN350GHi+Gk
 Hbv/4x6MEqt96EHplRvYwb/0vg7z0gqsANvDEL3MrQwxfn/kaSJNvgwxcL1Dru1I8vrY1QLHHig
 JmuvWo7/ls/MfCQJtObopFuCkfZ+GggEYv3cXbxQ3rbcZjuRl4OMtqwjuyNRo8y95Qq122KnOz/
 oGr+jsNMv0CHkiljo/7wJuBw6zLxNDKQKyv8t0w0A1mG1jYLKAuqhwwE0DkJJTSbNIm+Oda/yK9
 4CgBkrcFqKT6BMc+0g2BVf2fLaz83Im08B3Lw6qiqKKAKpHR3Ud3rtM+S9hn0HjasU/6P3Rp08l
 EzB9CDLHFBwGDhlaXkDfU5LJxmOmUWuwT+l5LZyvlJMxBROGmI1UUYAE0kwrfcnf1kKjpn3f/dz
 CicmIiewm1AI66A==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 65C5440007
X-Stat-Signature: q8basf1dcrxrkapwe1dqio6az51zwqwb
X-Rspam-User: 
X-HE-Tag: 1786379264-554627
X-HE-Meta: U2FsdGVkX1/9covnE5WiUlBCc9zaevRGVQI8vkG/5HM83VQu1g4yTMSG3wceBrc2kXLSaZPusQ8iYeEI2aMTzDFWz0RG5Vzven04PJHBZR6fRCi6tV2JCx4mt7BeCYzbiS7DZ6ODyNbPkGP7QHq1no2HAjzuE3fJ4JeCg+r++VuEVjqGPyHBBRRv3tj8Cn3nA+JqT5vYiexGAphJ6RttJwYkyWwyHfZ2d2K1kxzb0N/dz9DmU5KVs/YAf/RkAri9IcZEXFf+Q6eze/XaNpckuOoo3g4CJROSzgbgRfPg1VU7XmQ+Fki6L8k9wTuG8RfQ0ORjYRs/bgMtIhoUQiZD4mri7LORxzEblMOlbCI8DXu4HC0xsFHjbr6n0NH0eW2ytUxZ00KzkS2WKOSrD8BId04bXfV8eChADzurIQmJqK9pw25Bx0XcSFApir4/pqc/D5sWpJje0FccLUOdLhlZ61w6R1S63W8y8uf+f/txiWrM22rfjVdrbJgxTtx6oEmISLgrCTlyKz+cVtDT3R6Gxc+Ygvpu/Lwz2wc5YHUA+VrGA+kjp66EqQq1+zHkQsMxuARrIizeKjLsN+l9reDLlr1nyS4QLFyFPekETrT3tQdAnmYkg46TfTXfRh8PsSSfK3Wn7Ot3Y/mhwWUdAIe+Gt+RkDStkJfeKoov+dc2WbLci5GIJXIU8MfGSBY6tt/PsK1UVZsot7Croo6ZpD4DysB0Vq5ylinF1wdeWqOq1lPBXmbT2rV1+8EjUsMnQn7I1qtDH1dvEvmU1MHeKKtB8fTzxZUAOeYcna4Q1A4Rlh46pRknoBLREsUfsHo6Q7OPpEoyhjBuHP2uWuFbbM2hjNQu8aOGdp43IoH0XfW1gHLk36ltMKgmliq55mqpC//yDVVNCYXZee/FHVZqmqQxtrTS79K264Nwlu6ax5soBW+JYr1pW0ODu4kJrLDjnWRG0Oh1ZexlcmfegxbjBke
 cfuwgd6Z
 tyuwRHSV7YJHSKAzxe/dvI98oHUngOwzatSAFRA9WHvwKL4fmTyG9E5ArQB09CYHGdBsD5u3iUlwBh5G8jxyfaOFGf708oWaCp1hSZpzpokMWXKGP0dtniHH+3qN04iqDWwqliKmdpGWER7jLkhqyjnq8XG/Hy4czOQYNYDWWfWLo1QvyC5P5SL9SA0eV5kCYBqu+5jUbBp3NB3if5RK8dbsMLK/ksa4wej+kVNyVWxXKlRpZj5+n+Cedm0eiRUq2+Z5eBh+m8N+uXXRuwbo758bh6VCG3tBjQzwD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I've seen some machines at Meta flete that show the following type of
problem:

1) It gets some weird warning:

  BUG: Bad page map in process khugepaged  pte:f000eef300000017 pmd:00000067
  addr:00007f57c0a01000 vm_flags:20200073 anon_vma:ffff88829af7c340 mapping:0000000000000000 index:7f57c0a01

The corruption is most likely the collapse/PT_RECLAIM race fixed by
commit 366a4532d96f ("mm: fix the race between collapse and PT_RECLAIM
under per-vma lock"). But this series is not about tha.

2) Then it floods all the monitoring of the fleet, sending the same
   message in the loop, crashing the our fleet kernel monitoring
   subsystem (which is the part that I am interested in protecting)

  get_swap_device: Bad swap offset entry 3ffffffc043c5

For instance, in a host today it logged 6M in a few hours, and it is still
going forever. Two things go wrong.

1) get_swap_device() prints unconditionally, unlike print_bad_pte() next
   door which suppresses itself with is_bad_page_map_ratelimited().

1) do_swap_page() returns 0 when get_swap_device() fails, so the
   fault is retried, reads the same entry and faults again.
   Nothing in the round trip changes the PTE.

Trying to fix it in a naive way:

Patch 1 is super simple, and rate limits the two prints.

Patch 2 makes get_swap_device() return ERR_PTR(-EINVAL) for an entry
that can never name a slot on any device, keeping NULL for a device
swapoff is taking away, and converts the callers. No functional change
expected.

Patch 3 uses that to return VM_FAULT_SIGBUS instead of retrying.

---
Breno Leitao (3):
      mm, swap: ratelimit bad swap entry reports in get_swap_device()
      mm, swap: distinguish a malformed swap entry from a dying device
      mm: fail the fault on a malformed swap entry instead of retrying it

 mm/memory.c      |  7 ++++++-
 mm/mincore.c     |  2 +-
 mm/shmem.c       |  2 +-
 mm/swap_state.c  |  4 ++--
 mm/swapfile.c    | 17 ++++++++++-------
 mm/userfaultfd.c |  3 ++-
 mm/zswap.c       |  2 +-
 7 files changed, 23 insertions(+), 14 deletions(-)
---
base-commit: 6b8c8af514d739d0335f5579b585e02babe8a727
change-id: 20260810-swap-25420f9c8ba9

Best regards,
--  
Breno Leitao <leitao@debian.org>


