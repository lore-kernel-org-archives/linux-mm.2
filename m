Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01D9C109C028
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122976B0089; Wed, 25 Mar 2026 11:14:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3566B008A; Wed, 25 Mar 2026 11:14:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010116B008C; Wed, 25 Mar 2026 11:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E8A046B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:14:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA136E0D0F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:14:52 +0000 (UTC)
X-FDA: 84584932824.23.179D8AB
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf11.hostedemail.com (Postfix) with ESMTP id 28C6240019
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:14:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=CRX3aX3T;
	spf=none (imf11.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774451691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3Ov7FjiYremHpEShBz/unCCCoOiTOaqvTiJ6hyZmUE=;
	b=sJES3rbt/FJnTA1354ZbtyCeVkGkwZQRBDp/DVuHWo5pxsrAvtc+H5byAC+B68HUlUwymd
	74X7J7tHRhLsJqT18MZbik/zEiIviCoK433WRd2trGa9xHU9u6pjUcfYsKkYqLrNqSJqFe
	I6Dh21Vri5RI3W8mIUn7yNTctlokTX8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774451691; a=rsa-sha256;
	cv=none;
	b=PddQaEzClzdtQ3b179WhcqA09YPmc3XZxmIGBVIK6qL2tbs7Juc4QNUuLlxGs9Zz2ZVSM7
	NPp4q5nrRgvn+lPRoReTl9dkmnuvOK6u/L6qoR/zwMe/T8/zK+eezrdxdoDNoAcMMajJ4e
	m4PPbYQdet5CXCsTgmiHhSr/WCh2mMo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=CRX3aX3T;
	spf=none (imf11.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=T3Ov7FjiYremHpEShBz/unCCCoOiTOaqvTiJ6hyZmUE=; b=CRX3aX3Ttk456hTBtCeBHKmSaJ
	ttDysMdpK0PRepez0vQSlY2dE4WFSWNm3TywAq63zr80MuvxQwBkpUFOW5ttpVg9PYv+57v/nY+By
	b7xy9TAHN0aeDK0yuInOZeuX+fhitapaLwdEUVKwIuSOl5ZWG9oj9GMo+22qeWKEZM/biJRQyB1GD
	QJ10s3qn3/wHnahrXKkrSizpSudPNs7lGvDmh9+M/vpYFVHHfaeL4di23MPf/aCb+s7sknDjjp4qB
	DC0WAVlG1sARSzXTGbskTDUCPSXDzmOK+QMw87wAnT5Wvr/TgXWw3lNhfJq/80UXUSE5nXnXp7fon
	gOJqULRA==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5PwU-00000006S4q-21CN;
	Wed, 25 Mar 2026 15:14:46 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 85009300312; Wed, 25 Mar 2026 16:14:45 +0100 (CET)
Date: Wed, 25 Mar 2026 16:14:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>, Hao-Yu Yang <naup96721@gmail.com>,
	mingo@redhat.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <edumazet@google.com>, linux-mm@kvack.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH v2] futex: Use-after-free between futex_key_to_node_opt
 and vma_replace_policy
Message-ID: <20260325151445.GH3738010@noisy.programming.kicks-ass.net>
References: <20260313124756.52461-1-naup96721@gmail.com>
 <87a4vyihlx.ffs@tglx>
 <20260324140019.GE3738010@noisy.programming.kicks-ass.net>
 <87fr5pgp5x.ffs@tglx>
 <20260324174418.GB1850007@noisy.programming.kicks-ass.net>
 <c892e7ce-473d-41e5-aa99-b95e0366c3fd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c892e7ce-473d-41e5-aa99-b95e0366c3fd@kernel.org>
X-Rspamd-Queue-Id: 28C6240019
X-Stat-Signature: zr8wk1rcf9qsoa1yjmf9pgz3wzgjf1bz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774451689-240689
X-HE-Meta: U2FsdGVkX1+9JYVBQ0Q/6ENgXwLsdBlMSjfpDiE98R7MwjzaWNW8+NBNyVVuCBqaX41XylaQnm73gZvs6vpTYqW5Rle/sVQ5cyu4L/IPVU/OKJM/d4hkTz1yE/pUy/AX7M4Ms/a/8vxYvlJF8oDY/3LbnPPTm9ouxDRrPY8VkKOY1wtDvKlFcAF9RkopyeUDOEIkjTNgudZojYpXHAdghEz3rb6Vr+G6i4cr4h7kGhpaBpuDtg6QtWK+I4cV7Myz/AIGnNOXPRXlqmcPM1QMGM5qPkGcVMP8IZf73ud1+wcb6FotmbbRtuhsNsyy0aQ2+HK/rFJGI4al22pWr4Y0IO4/Gb0pKBxRl2telvgNdOQp0MsE8Y5FOW6tyJd7ZaoaFCtNTG+HY12oQS/LXgKx0/BKpVQMu0m0BN08JvHplSKinblDnN+p6m+QdKTXPBWYTdnE0xUI6ZlDEWP63denfRMWpVvAUmkFXRKrIIRlvWFjmZJwXO5ac0Urh/fS8yAAAfW3Ul4/AfYXZJxWW8shHsC1hJwgKxDdpl28TrnsKRGOy2nt+E5nSvcMf0NrZD/gknDR071IMPoIaffaeDVKaFYWZf+PRAU+LKcf3IOHgl5hpd9t10nvJ0yf2YfLcz6hPXA+K6jl9EYrWk389VtOZ1o80iC2BvBVJ/Qyp0GHJzey1Vdhx2nu6+YT9IT0nR3e+qfYDJftR+px3ao3jd6q0ZUkf8RNFwwLUXEhmL9GB0D4cYkNNYLG817cmsR6vu2pu+irGObBu4oIXWC6/m/duEuUK3zltcY0y2SBYNmBsWlGX5K/ADmdYaU6wvalcVGy4iTDOAuPTtqWeIAq+j/1huwdtGOKyvwOg74KjjYJbws5qd0iEutz/amyHp7Rtsly4Gcv/Fp/ct3HMFl6i7FYr3I8Bki9J2keIubSogqQ4ludItcvRi2zSFge9rdl0bSIM7MqEWnAbtnhdvxZU0p
 VMoD5f8l
 5SaqvGocI1VQOtoOQj6WMm0FiS0QvV/a/jdZf7RhH8HKBRYJlvKCcqYwH7xG9Zqzp8717EJVEl0X4ge1G15DCnncjE9KJU9QpljDy1ck4xkfDZ4f06tx4vlxnlQd4V9USii9H4w7O2MO58dznoFD5PvMmtAHUQuZ+nixECxP9HwjF+dpa2yWgAOHcWxEvnblu0KSJQ34IsBPR/8gOL2LmpAEDEF7IR5rqHtT20BAt0N6+1A2cYl9GwnOzfRZIE/arHfyjZ+pKXN8z8MtlvQr9sJK2yk0ndBa8bR4j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 09:27:41PM +0100, David Hildenbrand (Arm) wrote:
> So IIUC, futex_key_to_node_opt() looks up a VMA under RCU, without
> holding the mmap lock. Concurrent mmap-write lock is detected by using
> the mmap_lock_speculate_try_begin()/mmap_lock_speculate_retry() seqcount.
> 
> After looking up the VMA, we access the VMA policy.
> 
> vma_policy() does a straight vma->vm_policy.
> 
> What prevents the compiler here to do some load tearing while it is
> getting modified by mbind()? Or what stops the writer side to to some
> store tearing?
> 
> Shouldn't we be using at least READ_ONCE/WRITE_ONCE() etc?

Bah, at that point we might as well RCU the thing like so, I suppose.

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1026,7 +1026,7 @@ static int vma_replace_policy(struct vm_
 	}
 
 	old = vma->vm_policy;
-	vma->vm_policy = new; /* protected by mmap_lock */
+	rcu_assign_pointer(vma->vm_policy, new); /* protected by mmap_lock */
 	mpol_put(old);
 
 	return 0;
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index 4bacf5565368..6336a80e3dca 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -342,7 +342,7 @@ static int __futex_key_to_node(struct mm_struct *mm, unsigned long addr)
 	if (!vma)
 		return FUTEX_NO_NODE;
 
-	mpol = vma_policy(vma);
+	mpol = rcu_dereference_raw(vma->vm_policy);
 	if (!mpol)
 		return FUTEX_NO_NODE;


