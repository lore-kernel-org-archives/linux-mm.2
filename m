Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC69C531CF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 13:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E650F6B0088; Thu, 23 Jul 2026 09:51:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3C1A6B008A; Thu, 23 Jul 2026 09:51:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D52676B0095; Thu, 23 Jul 2026 09:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB3C66B0088
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:51:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20CEBA10B6
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:51:30 +0000 (UTC)
X-FDA: 85020178740.21.2C6D726
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7A4BC18000C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:51:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YMwlds1L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3XhxiagYKCHkpbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3XhxiagYKCHkpbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784814688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oGPMnBPG8DN0GWvTrl4frHL5NuZB07lUxK+6EcBmBHI=;
	b=2c9q/iciM91vMNGO0qp8rl0Hd2g8e7mIJStsKB0ZrEpczVUUCjKiEJbYvZCkBBqvWLDa1c
	H2tXz69zzcxxIbhWXCeTTEZheL5MAS20kC94JHGtTYUxwPigOFzg5+balIFkYyrb1QdgOf
	5vT7kas7Tvi7dg0X12k7CahGzZQLClg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YMwlds1L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3XhxiagYKCHkpbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3XhxiagYKCHkpbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784814688;
	b=CLZYp2Z8DYAjzir9pvKgCL/AmBWsKNsM6fjBd0NXwNMCXt4DFuagmERxoSs+YshQiIoGBJ
	/VoHrWV7B5iqQou7hEALRrmyrPlnI3/DlgauvN6p6SYIPv6kcO9QTjwheWYT9zlyOOwX/z
	0ZtFj1HJ8gcV3asl5s1c+pFnflPurAc=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ce8a76df2dso12197935ad.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 06:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784814687; x=1785419487; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oGPMnBPG8DN0GWvTrl4frHL5NuZB07lUxK+6EcBmBHI=;
        b=YMwlds1LqXNWtJkJ5JWfOuWXJHomih6uz1pV/fcUmv4N+1Tc2vSrxOheRUTqS9XEgf
         bYQ/2zKu7TkeF/ydYxbDGFGFD/9OpF/AET9mwI0A5JNegvWRCA2vj+eaaaKY/K/+obS9
         GcJNVWxIJMWKW8vfClwYS2SsB/RIM4rsCtNgwMAU9RoAd65E0wZb/KNChNLhA79TFegl
         XKGrlz6SI+WEjfoiZWUw8moNwC3of3kCHDRNjo6JG4HLGpXoJyVD0HbOomA0EzmU4ytR
         IBlplA5GeBJWWEXAGZYY2rfNn78NO0nm5azek6E7f6OANAD5jwSxpzmOBc8PoSA/CwQP
         kSVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784814687; x=1785419487;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oGPMnBPG8DN0GWvTrl4frHL5NuZB07lUxK+6EcBmBHI=;
        b=pjP5qA38Q2VS66YX0tiWdgAz6OV397UP6LBY9BVA88J+TlpXo8jg3Vxk3TiPU29ijL
         vcJNs9RqhZaPJgQV6qFxsZV6o5yC2jxYLeYtbwyA5qHT5rvjIYDKRCjkUOahPH1HQEGm
         v9PeKdzIqj3B+YXPah1ihJzAqqO3UUP8UiAJc30fPyxqZ5tUMW3PlEZlzvHXxq43ylMf
         2/DNaYGQNUckU0JGEPpUms15nZa/yRbp3jhJKaB4/5XwHMOm+C1jUFyjRf5vigEIWZh8
         Y/6YOSKrZvjY74gPFz3MT3V3McF6Ak7UHJi5r/E8jWfTRIK5iUp/rnG7L+N62RiprmMW
         5i/Q==
X-Forwarded-Encrypted: i=1; AHgh+RoELS390U1vgLhtbFfiZcLL0Q6+hi69yIiBQ70ZRuySlmvJPwrLPijDzfxGZ3OSgZb6hJevRHfpTA==@kvack.org
X-Gm-Message-State: AOJu0Yzd30J81i0E5lXBUhvFoMpD6mSEBWd28bIijXr2mTvxZTfxkB7+
	31iZm+Qquo51BF6Gn8JdSKkraG1ZQ+Xova5MiKcoUN87G0anWLQy9QL6qYuTZ0QT04HIndZRZoc
	Wed42vw==
X-Received: from plbjz12.prod.google.com ([2002:a17:903:430c:b0:2cc:6ddb:debc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:244a:b0:2c6:9f66:d573
 with SMTP id d9443c01a7336-2cfa6b7d4c0mr39323625ad.2.1784814686615; Thu, 23
 Jul 2026 06:51:26 -0700 (PDT)
Date: Thu, 23 Jul 2026 06:51:26 -0700
In-Reply-To: <amGpEEqxoLq/Y7ZO@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20260629163337.1264881-1-hannes@cmpxchg.org> <amGpEEqxoLq/Y7ZO@yzhao56-desk.sh.intel.com>
Message-ID: <amIcXrS7nGX-adpG@google.com>
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, vishal.l.verma@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7A4BC18000C
X-Rspam-User: 
X-Stat-Signature: p7uowe8a49957fxwim93u6rizn44mrqu
X-HE-Tag: 1784814688-258442
X-HE-Meta: U2FsdGVkX18xhM4Mx59waV1rgTlp0lCwVxC6nEAVtqMvsbqGBWnL+sTakK6hU7P/Hc6SIeZEve5zBxCq8hJF7MdN65JimqUNS5HH6FDRZqVxyBqy4p6bV36kY0psOFY/WG05aBLnCAN4IcCgf/E7AyMbTsCUKqsy6N2mvQKO98uq2uZGUBJC1sp2q0NzVPi6gTrdL6BncaU89AwIw0e8N4+SSg3MJQGxkNKisefVOKpx1LdG5GlrlGjMW5KzKKdIw6YjUqZVPW5PJ4OCLBmA9BiwhET7LHf7U1qVeuGGwlnHC/a482OgQESO4AZKGEdIQk/TQq1CFwAWZhNrWaKeyNU5yVM1heD2+e9JVKma/0xscRNiNqZdulX6aItnYzfkicb5fCgqtXPZuAg2TvZ045gg11pTq0IEqtjD8uQGp0VTmp9963apEUxb/+DGBCWE79QsBBNJLyHMfOkZV41R7rfv4EhKIULLcnrjPkaINnUyDMZm5QRDzn7hTPLAgTXQWWAJ59RRvP3+imaMrR7zq1RQ96h1C9anszIIbmHrpZtLcqQfZ8dv66TieJIHt3F6ujg4P61TXmw3wUCjrAVwsuAqyxuPG3R4+ydFeDZ4m/GeLZwdCA6XVEYA/dZfpmUZSIEEa25yVlqLt/VArvrmRzuqFktwLTftJA0v7mpU7GlUhv/yfbkZgYJzSv3P9gYQqem/draCIRio5Fi71sihd0ZKabSD0irBiL9KdNUnBYxcnbprybtBNg1IOQSZdd9ynXxmyspN9pOHZr4G/nSqtZLLzqkdkHqqWuwTq5dT1V8vFYvwKUhkBDweQKyPoHwkVzdpzt+1wSp4vFMPXgeGmGw8izgk+RTrmcFyczSKdn70ws3APe26bF3l6s7pFUciezwhKCyhhnx4szSlS/2NE+UaaN9hIIicJVbsgajbsVd6OUO0vTbH3Y53lk2ZDz/PThNMDEYivo/qfiqiz71
 jEjjOcke
 0rbMO/cf3MtGsLbfWB8OWjFFOWQJftPWcYtMfZoJFx2WlwzjEb3BDxzxW71wpqKpJWaHLrwd9RRowwjtbvxZuXuw7CvsmYNFwOf+XP6gf0MHpke6RSX8KPhzYC2HxoWHoKJj/IcXIXjSuKroOqj46eItspPRQmJi6kYbRP8tPOqpp55q0Z+MLcxHxa6/BKmxkX/JbYKx1rLrWklLQI1R40lDLCyvhP2phUGSXBWxCatQRtRQnE9nzzI1/sRjR/IbIJcSh4+nkIOr+e3jvEHhUTmjRUyDnL3R/m8uC+0w2B19S//l5HdQxLSyzIUogjOMXZc3hFdwGR3NfVzWc0IqxkRIgxAVnqEfDka/d40LUgQ4ZNfXmfnxlXHlMFbcWUYb5loTCu60jJUlfdv6xCabjNTVt61+ypEMkNXKIJTabXDoKJTgwWrzoKtUiRYAhT+u0adhXw98CxCzuvh1UmSr3IQINwte9g8Ih2QnD6VQG8dsUXOVob+nZf4CC6lFHuOUSSAxJvRppslbPpDzujdBMW+q3YIhcdF+VIxw8ZfUkHKkNq6c76r7Yn4B/O4QhncTezBChYrfnMyGaM888ut28z6KIM9gdYYsnC7p9+ztFFQc/5hvdgv6tCTJcdjn+CHIjk8RMq2ZsruE9QbPuPWG1Xbgpf4mILLPqPer/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026, Yan Zhao wrote:
> On Mon, Jun 29, 2026 at 12:33:37PM -0400, Johannes Weiner wrote:
> > Neha reports that mapped shmem aren't considered for NUMA balancing,
> > noting convergence problems and bandwidth bottlenecking for cachelib
> > based workloads on tiered memory systems.
> > 
> > Looking at the code and going through the git history, this doesn't
> > actually seem intentional:
> > 
> > Commit fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault
> > VMAs") added a vma_policy_mof() gate to task_numa_work() so VMAs whose
> > policy lacks MPOL_F_MOF are skipped from NUMA balancing scans. The
> > motivation was a real usecase: Oracle was pinning shared segments with
> > mbind(MPOL_BIND) so trapping faults was both expensive and pointless.
> > 
> > The handling of NULL from vm_ops->get_policy, however, treated "user
> > explicitly opted out" the same as "user never specified anything." For
> > VMAs whose shared policy is absent - the common case for shmem - the
> > scan was disabled too.
> > 
> > This issue is old. It probably hurts less in conventional NUMA. But it's
> > very noticable on tiered systems, where entire tmpfs workingsets can get
> > stuck on lower-bandwidth memory.
> > 
> > Fix this by having vma_policy_mof() use __get_vma_policy() directly, and
> > thereby handle the fallback to task policy (-> preferred_node_policy()
> > has MPOL_F_MOF per default). Every other consumer of vm_ops->get_policy
> > already handles it this way, the scan-eligibility check was the outlier.
> > 
> > This preserves Mel's intended fix: don't scan stuff the user explicitly
> > pinned. But allow default policy vmas to participate in balancing.
> Hi,
> 
> This patch introduces a performance regression of a KVM stress test, which I
> addressed in the KVM selftest itself (see the analysis in the patch log).
> Could you share your thoughts on whether the userspace fix is the appropriate
> approach?

Yikes.  This could have meaningful "real world" impact on VMs backed with shmem,
not just on KVM's convoluted stress test.  NUMA balancing generally performs
poorly for VMs due to the higher costs of VM-Exits versus page faults, and due
to inefficiencies in the mmu_notifier interface (KVM does a full TLB shootdown
of the affected VM on every MMU_NOTIFY_PROTECTION_VMA event).

My stance is that using NUMA balancing with KVM guests is a terrible idea, and
that anyone that insists on using such a setup gets to suffer the consequences.
But in this case, IIUC, this change will "silently" enable NUMA balancing for
shmem-based KVM setups where it was previously disabled (albeit unintentionally).

I'm not fundamentally opposed to the change, but I do worry that downstream KVM
users could be in for a nasty surprise.

