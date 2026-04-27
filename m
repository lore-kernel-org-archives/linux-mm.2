Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F163BFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 05:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD816B0005; Mon, 27 Apr 2026 01:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AE6F6B0088; Mon, 27 Apr 2026 01:42:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5456B008A; Mon, 27 Apr 2026 01:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEFA46B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:42:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 90F7D1A077A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:42:14 +0000 (UTC)
X-FDA: 84703240188.20.A55BAE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D59ACC0002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:42:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EknsdmMD;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777268533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2CCxhRo9dzSEFztsNr/qE2E5+PiJ9THNrdHASViPKrg=;
	b=WtooGez6o6RBrUe+wK31+Y6+y/LwIb4wkFvr6codRqzi8jsawnVYvpG23KJByeHDZ50MuJ
	iIsG0ipRx1gpkUSO8l8rMX52LBtt5ZfiVpBQGzG2F3/V9n9LK2PBvgiDWg+m4b2jbkWNVt
	Anwy1oubWaCdCGZEqAVApTAefvMjXMs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EknsdmMD;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777268533; a=rsa-sha256;
	cv=none;
	b=szyWc10qPht7F/DIrwBCkAGX7ZbCuJdoqU0fU2nUc8dkM237aNuoBtmWGLkXUHn7BWrdOg
	ZVkSUdMoGjge/FutRmwG0KQGA84orxFJMNvQMiLSVsIFXXsH+WaNl+vYRRlMg2rxypOKcu
	3LuW3U82o3F4ZQCzsW4U/W+2myzwVr8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A2A94444E4;
	Mon, 27 Apr 2026 05:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F142EC19425;
	Mon, 27 Apr 2026 05:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777268531;
	bh=iipSs6v6w0TU4vM721+EG7SCFN/Hickx4k4+AOF1ykw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EknsdmMD/enifxH8VPV8H+qG6cwpocmLVCoiW7B+3U7CZljO4P8/YYBWxa1/ROzU8
	 5ciro/zNJL6+1Ekw1qf5xfG3uc+nh7aJzzgL/TZKhuVnl5kks9BGc5lwmNq5ViRa/w
	 Bf/uZ/gLam1vEH2k5RbicgvTK8CYkGZbyM7chBtwS0Qllmx/Q8HRc3P2RLDvo1t+zH
	 7Bn6D1RYgkGkRiD6Cvf8RBbVr8vT32IWvqi/NN/jFvut9fFUm+lBC67M2oAFHZNkmh
	 8LO/IZzH/MFsYY1f/VGTRljSoMJ7Qs5tz5eRiHKLMDLhjE/Nj7H1rIobveui/U+LyO
	 5elLbmHn4l2gw==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Harry Yoo <harry@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH mm-hotfixes 1/2] mm/page_alloc: return NULL early from alloc_frozen_pages_nolock() in NMI on UP
Date: Mon, 27 Apr 2026 14:42:03 +0900
Message-ID: <20260427054205.560734-2-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427054205.560734-1-harry@kernel.org>
References: <20260427054205.560734-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D59ACC0002
X-Stat-Signature: ugujxte7z61j6k63ho8enpfiu4eam1nj
X-HE-Tag: 1777268532-388145
X-HE-Meta: U2FsdGVkX1/6DS3+zX1F7FxMGlIg99p+br/bbJn6XDk7aYrA794Pz6XBuwA8sgQ3vF11VMq7Em5wl5jAqboD+sRUyjljx9cMQB6s/hPGAPZdOP6yKrE+tlMJAUzpPdDNGdqjjjUbctVWhgKq9XuGWxrVpwcPyKkBSDhFi5ggDTnW/h783gw73dtLeec2dgQjjmMHuUt0UW3zr7/L9sCirSCPOm5hhHEdiKalKoFWLv9QfLWlzWG/Lzk1Mof5OkIwYz9CqtzhUC6ysN00GsBYVPhmWdPuhULD6KRzU8qFMTswxfS02y07wXovMuXDTiqKAog+UYbcckX+ACioy4fI5O7Dh6P93G6Izo7R8m8z6l70HiceCC77FIao72o55E+HyJnCORq+RqgJaBUt8o5efJ9Dw5mnWb6CpaXk8iv2TcZGUN6MJnJKRNhbaIG8VWbBzNaTvSPxCrdfcxVD/9xuXF9SnG2PTsh0kaiJpAlJrzdbeMts044rNL327TkeecHQEgN54+lP/C5BExrrd1kaV4RWZpSeS8aDTmFhva8MdsBDIeRpIKVcTq3gl4eIL7jkx1G0tnW5ghG50BqAjXLHnMA6YvgDSuAiUQBeQUgO06CtJp5lqcrCQQf3CsYRLKI9A2+ht+e5KIsM0Nn9xF2bT8AAQnDXArqlQ5/w47pHKeOCyxhBHe67Rod2zhGUa9viuWKPW8YWS/Z3AGvUuS6FtJ2N6qM5WPPF0ZC0gl24F/nogKFuMoVdjZKkuDFvsHoZmjZ9GZ7J6gERN5vetg5hnHeGn9Ii1RI1t3xbTm8IWODuOhoMP2mQJn9N5UraZnB2phZth/Ltkx0ZUg6UUNy9HL9o/D1kl8x8yHVyzwF8l/ZTcNS8upEita9CEO22GckSNilKRfVPJJbjDDH4VdbzYXQOGDaJkIbwnqNwUK2IsDOsqrvjzQ8EL/dgoAwkXRdhhpiVwqHSx4ls7o73Zil
 a7+r62CJ
 nVKhohCW3UEJK9Gt00xiPwu8OwTF5NIr/3aLK+uKPpSgaAnLYJvKsZF5xwsNrsv3W6obK4lwfhLWfugxn4RCqdZ65oKcAn+QtzFtVKrznbbhCly3v3MY03wmiID5iziMfcMCgQqqZoiw8I3DGVjXxzpYiNITq7gTN/4cH8QpHUA72ZsA9c1qsyGppeGI4i4TVYPYBt7fmeBF1LuD5sGdLaqUwEwtome4b+vT1ZGu7DihoPir0tM3clZTVTgsNpV4hn8UlIV71+ArSzqr7Fhw+svxJwR40E4ccEN90
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On UP kernels (!CONFIG_SMP), spin_trylock() is a no-op that
unconditionally succeeds even when the lock is already held. As a
result, alloc_frozen_pages_nolock() called from NMI context can
re-enter rmqueue() and acquire the zone lock that the interrupted
context is already holding, corrupting the freelists.

With CONFIG_DEBUG_SPINLOCK on UP, the following BUG is triggered with
the slub_kunit test module:

  BUG: spinlock trylock failure on UP on CPU#0, kunit_try_catch/243
  [...]
  Call Trace:
   <NMI>
   dump_stack_lvl+0x3f/0x60
   do_raw_spin_trylock+0x41/0x50
   _raw_spin_trylock+0x24/0x50
   rmqueue.isra.0+0x2a9/0xa70
   get_page_from_freelist+0xeb/0x450
   alloc_frozen_pages_nolock_noprof+0x111/0x1e0
   allocate_slab+0x42a/0x500
   ___slab_alloc+0xa7/0x4c0
   kmalloc_nolock_noprof+0x164/0x310
   [...]
   </NMI>

Fix this by returning NULL early when invoked from NMI on a UP kernel.

Link: https://lore.kernel.org/linux-mm/ad_cqe51pvr1WaDg@hyeyoo
Fixes: d7242af86434 ("mm: Introduce alloc_frozen_pages_nolock()")
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/page_alloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 71859993dd54..23c7298d3be2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7737,6 +7737,11 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	 */
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
 		return NULL;
+
+	/* On UP, spin_trylock() always succeeds even when it is locked */
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return NULL;
+
 	if (!pcp_allowed_order(order))
 		return NULL;
 
-- 
2.43.0


