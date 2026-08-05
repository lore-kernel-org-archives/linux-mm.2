Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49CE1C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 421866B009D; Wed,  5 Aug 2026 05:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0EE6B009E; Wed,  5 Aug 2026 05:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E7926B00A1; Wed,  5 Aug 2026 05:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00BE36B009D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:48:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72FC91A041C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:48:59 +0000 (UTC)
X-FDA: 85066741998.14.5DFFC8E
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	by imf02.hostedemail.com (Postfix) with ESMTP id 449B68000C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:48:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=yandex-team.ru header.s=default header.b=sc8OhmLP;
	spf=pass (imf02.hostedemail.com: domain of d-tatianin@yandex-team.ru designates 178.154.239.136 as permitted sender) smtp.mailfrom=d-tatianin@yandex-team.ru;
	dmarc=pass (policy=none) header.from=yandex-team.ru
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785923337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=w3V7sfmWLggUmQu9ZRjliJsNs4NKeoQcp6wRpWpznBc=;
	b=iobyHlhXSDDjrazrmRVvrFA7mUXY5zkh0Bj51ZowwloC5XA4stjRAQwgKPktPws209nxfX
	1mWNR5un1+nuJPRoW6CC3n1aREc37C1IOcyetHpjj13tDY4K9941FvrmPDDbBieuh5x0Cb
	Db86fH5cdhex1h0wtkbm6fqorg0NIf0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785923337;
	b=IlMVGvMGbHcfLOmAGkhWtkbU2Xw+ILaSd5yNkR6sONGc6Pd6STBPshgBpQN4I7x1UxFz5/
	PM461nq/qvX3TTh1qr6x55shIg4VFe70hwgM6H2miaUXQ9yHCNBSCAiGVrli1tLpX+zHGN
	T+7m6kXUVxfw+FTfWqJDTIpP3zMx/es=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=yandex-team.ru header.s=default header.b=sc8OhmLP;
	spf=pass (imf02.hostedemail.com: domain of d-tatianin@yandex-team.ru designates 178.154.239.136 as permitted sender) smtp.mailfrom=d-tatianin@yandex-team.ru;
	dmarc=pass (policy=none) header.from=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net [IPv6:2a02:6b8:c11:43a8:0:640:574d:0])
	by forwardcorp1b.mail.yandex.net (postfix) with ESMTPS id 874B1808E1;
	Wed, 05 Aug 2026 12:48:53 +0300 (MSK)
Received: from i101646577.yandex-team.ru (unknown [2a02:6bf:8080:43c::1:39])
	by mail-nwsmtp-smtp-corp-canary-81.sas.yp-c.yandex.net (smtpcorp) with ESMTPSA id lmErQB23hCg0-cG0RyIly;
	Wed, 05 Aug 2026 12:48:52 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1785923332;
	bh=w3V7sfmWLggUmQu9ZRjliJsNs4NKeoQcp6wRpWpznBc=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=sc8OhmLPz7+seM305BniVNbQHKGkHFF8xJGHDIByfwGJskh5qeWNca8Fgqb1D0ecs
	 X/Z/gZgFJqYLz2iWEoY38gCCndFux78xIKoZIOu0NGyQz/kV4caqUJcD6OvAgcGtZd
	 0cxxv3wlCann1+83k/HGWaEYx18PohSKkzVdzN9Q=
From: Daniil Tatianin <d-tatianin@yandex-team.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Hao Li <hao.li@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Daniil Tatianin <d-tatianin@yandex-team.ru>
Subject: [RFC PATCH 0/3] mm/slub: allow capping the order kvmalloc() uses for kmalloc()
Date: Wed,  5 Aug 2026 12:48:40 +0300
Message-ID: <20260805094843.292134-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 449B68000C
X-Rspam-User: 
X-Stat-Signature: s7c7h71iumc75j91aj4to7qso5uoryui
X-HE-Tag: 1785923337-662234
X-HE-Meta: U2FsdGVkX18uh+dAJ7WwK0vz032enhoshOSACWlwNtUXCk1Lj81Xoqjebef1rMVVBqy3t+lswlPxn7ipauCajhuyV1V0Krs5yGpTrq+yUTJde81C1ublWttXQ7M8u6+EA6hBxYzVU2I2VnXAb+DbxBbsHRpW9w3iqlhTI1lf4wGwwwph3dTnE76/azBTDOeDCfpo1kjenbmY2Ef3Sx+s8iw1wn0MHXymISVZWCNFtAW8UqScaiNmbq9YjGDzFiO3WYXSSrdpaGAIUc8QPSzIy4XlGGZj3+QRuhG6MXpQiH3qNkb5MmrIezolwCzwFLJkwVNNiL1PBwQRd1XIgHJ7NpKb7aSomZD17+wbe2Cb+WiUjOfN3nQ2L/8fuckGQXkZmyxgkqAhIi/3t/V58RGXZxsuLCR/XvT2YU/SOOgxy7YvnR+kF5vF98mNwi7qR30ejw2IHGqjALqSEE3dSEUG4kGWOgFDsV/aJrEBpVbwZ3yteu/5Xr6o7//A3obD+imiwYYMtHNhFwkAobRidcFEGfBmlVoZ1iLlQA2g2s6s65ja0o5HtfTaxZuTPBeXb+NbwCk/1D/Qv3al0Koq5N1oOiq9ePGennUVrfLXUH64FdosE9ni8lB5W0FX4QerEAcwDso7K8xJftDWG9K1BxHWlG/3E1WJRfpDpTSzbZIJNksz7ka6XxNHLHJdcUUltDpwJd/8WalFNVu4ENIIwSsTjhp3xAf+ZRG9Zr1OeFUHy1in+iokErzZFWLrCQxLJzLZnoX7DwaSV+4PTHWQBorNIi1T2SbuHyKHvi5i0R6hzuGgBugUa/5VF2KF2dpAyEgeyzA3PfCSyQupHF7O+RL5fVNoqPCk0gHk4KnpUs++bxcR0GvnohpShTsbBhtWPxacWjcnJurWMRDYRSgwo8A5j2EHZfMmtl39KEKHQ1b9Ag0sHOdFcrHpcYGcXOfenkeS7Oj4oXWP0yJdPVpDjJv
 MLiK5CG0
 aCDB0Fkrwr3wXsiliNQHtWhkUMiEVOos1sBnNxSCcOZELfcZnpCIUwqlqgv7gdSzZcfY4Xcehd7B7znrnqBbjQkFlziAL/ggA+xqcEofLRPUDaQqAadtHHozjtiXX128CanP3xXbfiRQQcNehhvKb7QNjBzicPaMR/x+BeknOdAKi0oXurXtKOrZdCn2py+QE8JiQYb8Rp0ijOW8GbdKFUtbBDtmZqCSfuQwEwau6EqTQVM88pDYR8BQFidIGqsQ8vftIw+dylWvcU4to+XC3psNGxLj9Bi14MGaqU0BYZ6QKeM8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

By calling kvmalloc() rather than kmalloc(), a caller states that it does
not require physically contiguous memory.  For the vast majority of those
callers the contiguity is not an optimization they can observe at all, yet
the attempt to obtain it is paid for by the whole system in buddy
fragmentation and background reclaim/compaction work.

Commit 46459154f997 ("mm: kvmalloc: make kmalloc fast path real fast
path") made the kmalloc() attempt much cheaper by dropping
__GFP_DIRECT_RECLAIM, which removed the synchronous stall.  It did not
remove the attempt itself, and the attempt still takes the zone lock,
still steals pageblocks when it succeeds, still raises
pgdat->kswapd_order, and still ends up waking kcompactd for allocations
that are served by vmalloc() a moment later.

Individual callers can be converted to vmalloc(), and that is the better
fix where it applies, but it does not scale: in practice each offender is
found only after it has hurt a production machine.  One example is
xt_jumpstack_alloc(), which issues one kvmalloc_node() per possible CPU on
every iptables/ip6tables table replace, while holding the per-address
family xt mutex.  On a 192 CPU machine a single reload is therefore 192
order-6 allocations, and the 384 below are just two of them, a little over
two minutes apart, on a 6.6 based kernel:

    ================================================================
    COUNT: 384 | PID COMM: ip6tables | ORDER: 6 | GFP: 0x52cc0
    FIRST SEEN : 2026-06-02 13:31:16.378
    LAST SEEN  : 2026-06-02 13:33:27.921  (Span: 131.543 sec)
    FLAGS      : IO | FS | DIRECT_RECLAIM | KSWAPD_RECLAIM | NORETRY
    ----------------------------------------------------------------
        __alloc_pages+0x5
        __kmalloc_large_node+0x82
        __kmalloc_node+0xc3
        kvmalloc_node+0x48
        xt_replace_table+0x95
        __do_replace+0xd3
        do_ip6t_set_ctl+0x38f
        nf_setsockopt+0x5b
        rawv6_setsockopt+0x54
        do_sock_setsockopt+0xae
        __sys_setsockopt+0x79
        __x64_sys_setsockopt+0x25
        do_syscall_64+0x37
        entry_SYSCALL_64_after_hwframe+0x78

On that kernel each of those entered direct compaction with the xt mutex
held, which is what made it visible.  That call site, and the ruleset blob
allocation next to it, have since been converted to vmalloc() in our tree,
and 46459154f997 addresses that shape of stall generically, so this series
is not asking for that incident to be fixed again.  It is about the callers
of the same shape that are still there: the veth path quoted further down
is one that 46459154f997 deliberately does not cover, and it is unlikely to
be the only one.

Patch 1 adds a vm.kvmalloc_max_contig_order sysctl capping the order
kvmalloc() will ask the page allocator for.  Requests above the cap go
straight to vmalloc(), which is the path they would have taken had the
kmalloc() attempt failed, so no semantics change.  Requests small enough
for a kmalloc cache to serve are never diverted.

Patch 2 adds a kvmalloc_forced_vmalloc counter to /proc/vmstat so that the
effect of a given setting is observable.

Patch 3 adds a KUnit suite covering both, including the invariant that the
lower bound on the sysctl is what keeps cache sized requests out of
vmalloc().

The default is MAX_PAGE_ORDER, i.e. current behavior, so this is entirely
opt-in and all three patches are gated behind CONFIG_KVMALLOC_ORDER_LIMIT.

Some things I am explicitly unsure about and would like opinions on:

 - Where does the kmalloc()/vmalloc() crossover point belong?  Callers
   whose size is always large do not need kvmalloc() at all and should
   simply call vmalloc(), which is how the netfilter sites above were
   fixed in our tree.  The class this series is aimed at is the other one:
   callers whose size is only known at runtime, is usually small, and is
   occasionally huge.  Those cannot be converted to vmalloc() without
   penalizing the common small case, so for them the crossover point has
   to live inside kvmalloc().  Today that point is fixed at "always try
   kmalloc() first".  This series makes it a global tunable.  It could
   equally be a compile time constant or a per callsite hint.  I have no
   strong opinion on which is right, only that the current value is too
   generous.

 - Order versus size units for the sysctl.  Orders match the mechanism
   being protected and give MAX_PAGE_ORDER as a natural "off" value, but
   an order valued sysctl under vm/ is unusual, and both ends of the
   accepted range end up being arch dependent.

 - __GFP_RETRY_MAYFAIL callers are currently subject to the cap like
   everyone else.  There is a reasonable argument that the flag is already
   the "I really do want contiguity" annotation and should be exempt.
   Only 7 call sites in the tree use it today.  They were deliberately not
   exempted, because that flag is also what keeps those call sites in
   direct reclaim and direct compaction after 46459154f997, and in
   practice they are not rare.  Container churn creating veth pairs
   produced this over twelve days on a single machine:

    ==================================================================
    TOTAL COUNT : 4948  =>  [ Order 7 (x4948) ]
    TIME SPAN   : 2026-05-22 13:03:27.119 --> 2026-06-03 11:40:27.303
    GFP         : 0x446dc0
    FLAGS       : IO | FS | DIRECT_RECLAIM | KSWAPD_RECLAIM | RETRY_MAYFAIL
    ------------------------------------------------------------------
        __alloc_pages
        __kmalloc_large_node
        __kmalloc_node
        kvmalloc_node
        veth_dev_init
        register_netdevice
        veth_newlink
        __rtnl_newlink
        rtnl_newlink
        rtnetlink_rcv_msg
        netlink_rcv_skb
        netlink_unicast
        netlink_sendmsg
        __sock_sendmsg
        __sys_sendto
        __x64_sys_sendto
        do_syscall_64
        entry_SYSCALL_64_after_hwframe

   Every one of those is a 512 KiB contiguous request, made by a caller
   that does not need contiguity, from inside a sendto() syscall, and each
   one is still entitled to reclaim and compact synchronously on a current
   kernel.  Exempting __GFP_RETRY_MAYFAIL would make the cap a no-op here,
   so the series treats the sysctl as an administrative override that
   supersedes caller hints, in the same spirit as the other allocation
   policy knobs under vm/.  If the consensus is that the flag must be
   honored, the exemption is a one line change.

 - The counter only accounts allocations the limit diverted, so it stays at
   zero until the limit is lowered below its MAX_PAGE_ORDER default.  It
   therefore cannot answer "what should I set this to?" ahead of time, which
   still needs tracing kvmalloc() directly, or lowering the limit on a
   canary machine and reading the counter there.  If a per order histogram
   would be a better answer to that question, say so and I will add one.



Daniil Tatianin (3):
  mm/slub: allow capping the order kvmalloc() uses for kmalloc()
  mm/slub: count kvmalloc() allocations forced to vmalloc()
  mm/slub: add KUnit coverage for the kvmalloc order limit

 Documentation/admin-guide/sysctl/vm.rst |  35 +++++
 MAINTAINERS                             |   1 +
 include/linux/vm_event_item.h           |   3 +
 lib/Kconfig.debug                       |  15 ++
 lib/tests/Makefile                      |   1 +
 lib/tests/kvmalloc_kunit.c              | 184 ++++++++++++++++++++++++
 mm/Kconfig                              |  22 +++
 mm/slab.h                               |   4 +
 mm/slub.c                               |  93 +++++++++++-
 mm/vmstat.c                             |   3 +
 10 files changed, 354 insertions(+), 7 deletions(-)
 create mode 100644 lib/tests/kvmalloc_kunit.c


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff

