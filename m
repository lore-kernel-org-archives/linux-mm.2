Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 985E1EFB7EB
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 02:52:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0016B0088; Mon, 23 Feb 2026 21:52:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B905E6B0089; Mon, 23 Feb 2026 21:52:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A71CF6B008A; Mon, 23 Feb 2026 21:52:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 927D66B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:52:47 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C2431C379
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:52:47 +0000 (UTC)
X-FDA: 84477827574.03.596CFE0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3E3671C000A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:52:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DksMoPFT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771901565; a=rsa-sha256;
	cv=none;
	b=PqeJjVRoOC4y9pHzEnetYpL3C5qPjX9OkP8cw5neByg7RYHkNGBkO3CdMxdExMXU1yZllv
	oCfnsQ6/7wwqrKlICMjtypG6DnIoVa2Cb6Jf5PWUbo5/GKDRXWJLKc9pKP+KrMlBWaTagm
	LjnmIcbchU+tfsQUjRr7vG7faaRR718=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DksMoPFT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771901565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KvdK4bKlV9p8CtqWIClX1h0DPFMJUXzNU1SYA1FO1bk=;
	b=B6i1zv4f2AZnWYbdIw8G7E/USdxBcz9/PfdFjY48Puq+kSZYBGecnGpP8BJqU7UXHKnE8n
	4UKhKJDIpUrDbFjIL54lgzl1rjmYhiilS/26653eVy5Cv8RP6Zz/nv/f4KM6RSLYxpEmqw
	ehruF0Bhzprsr1rivbZVfBf2NGZboW0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771901564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KvdK4bKlV9p8CtqWIClX1h0DPFMJUXzNU1SYA1FO1bk=;
	b=DksMoPFTLFU0MDZcEIzQTMuVlJdopLxuf5S0TW4dlLogHatVHeyfS+uCEOb/gjZZWzViSn
	SpxqMkZV4rLWyMCLGNbOkWLvFVExfkcvH2ZqhdcV6pfKaFWW9BdGbA04EFAnxajc2FdhZz
	P04F4GmOFsceotb1MvbMfR8XFNL9U2c=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-460-VLMHYQwwMwi9CxWQW8Ft8g-1; Mon,
 23 Feb 2026 21:52:41 -0500
X-MC-Unique: VLMHYQwwMwi9CxWQW8Ft8g-1
X-Mimecast-MFC-AGG-ID: VLMHYQwwMwi9CxWQW8Ft8g_1771901560
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E5E321800473;
	Tue, 24 Feb 2026 02:52:39 +0000 (UTC)
Received: from fedora (unknown [10.72.116.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC1241800348;
	Tue, 24 Feb 2026 02:52:34 +0000 (UTC)
Date: Tue, 24 Feb 2026 10:52:28 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: ming.lei@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Message-ID: <aZ0SbIqaIkwoW2mB@fedora>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: hvFk0IvQkeFunq1lElMj6jec6j37LeEC6Jg8iSEC3HI_1771901560
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3E3671C000A
X-Stat-Signature: ibqqjjikskj3cbetbxkumtco8d959fdo
X-HE-Tag: 1771901565-896646
X-HE-Meta: U2FsdGVkX18MbLmgzBtXa6Gp5K90V3gUBNzOwq5wtwxu8352WmtANAfV1mGyWHZ9Qyb8FjqxUuDnk5JHIRKDHXjO00N38NAMxBCKRW6FYYu0qA/xrrtQGhwiFEg96YW/lkqSejgEUqJGjB2KQ+IMA4ho3qo7jC4QwVojlJC6sZM/VAsxendM4d9/u+qG8xIt+VkMVDkcm951Q2LAkiHfqhy1sAIxvZhFDmgF4YjyMbXxecs2zyEYnn9blufMUyZBLKO5D2EiL39MTuYYadLNalsFT2XUxQj9oFBFWL4ri/1m7s1BxbltvOVBWGx2BCgAbwNq/hAJDlDHNrOq0sFDRkkbFwby2D5CW9RTHCNRRXg3JeCDKYcROvPAgeMpaaEdKq0ChYhdkJoQBNcUjm8bp6qSP9Sv8K/IvTKtKLBXn2R0LUvm///HBskcYxb9qtQJUqKQ8T2m2kiIWe3VD4PfPhfRZkyCGylAw3i8Vnew0hRJBQ9LitUCd02CduHP5sHVOzQGhCtivOE0Pv6IDFV1j4r0DxRtere0YEwD26ZYYqpJoDHtb2/kk5MPgMI4LxpdRQA345S/1wP/+LnHbJecyZKzN/Doq2Dr3Gj06m0ooTuaPwZS8vOrNel3Cs0cJEcrs/oSBeObl+gvc4PNPzC93CZpjKtVnF9P/XQNkKzJSpFLw+P7ofQHc0a2F6AsGpuXpaXOpqE22oEAS4lLVaURfrZg9lz8rrySZdJWbI3WztNwKZnGe69+fk67Izr0dp7m7OR6f9hh+Cd+otWx1E4YKTdFPFOMx9JxdDvEgxq4aRSoO1QxY8mb2SI0EeCo+GiRZb+ahSJiguPsMWP8FHuqW7V8ltZ60gOVaiDz/VoeZUczFj0Zde6WjmFvQkRKpSgUOzL8vRI2PTA37l5autiFTuzf9HQzelEQIDb7jR48BoB0bdNDX7LhtbIHkCULNb0YIxK3PdskfZz4XygcwJ+
 RIWiOc01
 fVUz1on8BXYyOowZU1wYglzaVYSRT3qo+98Equv/dRZfrx9LiFpRP/1sfD9x+rpr5MOUX6/vmirJkGdev18+ORMcEHygMi+fhHkpTAeR3GoSQ8m73uZBLC1m9OJ3olDGlbGnfLKrqmY6JoPZf1kpNlPkeSNkxJ2uTfanLBO/IZP0SqArl8RU6S5isN7OT3oJufjjjPHpxTbSTIjtfTbi4xE612EWsjzXkNHlZA7WcpV1T3ysN1UCaBTO2fht1ZySTNnMtjFNTERbErJP8t3BDYiEURJfDhSBtJw/vUXQEaXbgj1UP936Y5eFCc78yDv+5CzhimLkHlBGs2hyDiKRn8mJ7GA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Vlastimil and MM guys,

The SLUB "sheaves" series merged via 815c8e35511d ("Merge branch
'slab/for-7.0/sheaves' into slab/for-next") introduces a severe
performance regression for workloads with persistent cross-CPU
alloc/free patterns. ublk null target benchmark IOPS drops
significantly compared to v6.19: from ~36M IOPS to ~13M IOPS (~64%
drop).

Bisecting within the sheaves series is blocked by a kernel panic at
17c38c88294d ("slab: remove cpu (partial) slabs usage from allocation
paths"), so the exact first bad commit could not be identified.

Reproducer
==========

Hardware: NUMA machine with >= 32 CPUs
Kernel:   v7.0-rc (with slab/for-7.0/sheaves merged)

    # build kublk selftest
    make -C tools/testing/selftests/ublk/

    # create ublk null target device with 16 queues
    tools/testing/selftests/ublk/kublk add -t null -q 16

    # run fio/t/io_uring benchmark: 16 jobs, 20 seconds, non-polled
    taskset -c 0-31 fio/t/io_uring -p0 -n 16 -r 20 /dev/ublkb0

    # cleanup
    tools/testing/selftests/ublk/kublk del -n 0

Good: v6.19 (and 41f1a08645ab, the mainline parent of the slab merge)
Bad:  815c8e35511d (Merge branch 'slab/for-7.0/sheaves' into slab/for-next)

perf profile (bad kernel)
=========================

~47% of CPU time is spent in bio allocation hitting the SLUB slow path,
with massive spinlock contention on the node partial list lock:

+   47.65%     1.21%  io_uring  [k] bio_alloc_bioset
-   44.87%     0.45%  io_uring  [k] kmem_cache_alloc_noprof
   - 44.41% kmem_cache_alloc_noprof
      - 43.89% ___slab_alloc
         + 41.16% get_from_any_partial
           0.91% get_from_partial_node
         + 0.87% alloc_from_new_slab
         + 0.65% allocate_slab
-   44.70%     0.21%  io_uring  [k] mempool_alloc_noprof
   - 44.49% mempool_alloc_noprof
      - 44.43% kmem_cache_alloc_noprof
         - 43.90% ___slab_alloc
            + 41.18% get_from_any_partial
              0.90% get_from_partial_node
            + 0.87% alloc_from_new_slab
            + 0.65% allocate_slab
+   41.23%     0.10%  io_uring  [k] get_from_any_partial
+   40.82%     0.48%  io_uring  [k] __raw_spin_lock_irqsave
-   40.75%     0.20%  io_uring  [k] get_from_partial_node
   - 40.56% get_from_partial_node
      - 38.83% __raw_spin_lock_irqsave
           38.65% native_queued_spin_lock_slowpath

Analysis
========

The ublk null target workload exposes a cross-CPU slab allocation
pattern: bios are allocated on the io_uring submitter CPU during block
layer submission, but freed on a different CPU — the ublk daemon thread
that runs the completion via io_uring_cmd_complete_in_task() task work.
And the completion CPU stays in same LLC or numa node with submission CPU.

This cross-CPU alloc/free pattern is not unique to ublk. The block
layer's default rq_affinity=1 setting completes requests on a CPU
sharing LLC with the submission CPU, which similarly causes bio freeing
on a different CPU than allocation. The ublk null target simply makes
this pattern more pronounced and measurable because all overhead is in
the bio alloc/free path with no actual I/O.

**The following is from AI, just for reference**

The result is that the allocating CPU's per-CPU slab caches are
continuously drained without being replenished by local frees. The bio
layer's own per-CPU cache (bio_alloc_cache) suffers the same mismatch:
freed bios go to the completion CPU's cache via bio_put_percpu_cache(),
leaving the submitter CPUs' caches empty and falling through to
mempool_alloc() -> kmem_cache_alloc() -> SLUB slow path.

In v6.19, SLUB handled this with a 3-tier allocation hierarchy:

  Tier 1: CPU slab freelist         lock-free (cmpxchg)
  Tier 2: CPU partial slab list     lock-free (per-CPU local_lock)
  Tier 3: Node partial list         kmem_cache_node->list_lock

The CPU partial slab list (Tier 2) was the critical buffer. It was
populated during __slab_free() -> put_cpu_partial() and provided a
lock-free pool of partial slabs per CPU. Even when the CPU slab was
exhausted, the CPU partial list could supply more slabs without
touching any shared lock.

The sheaves architecture replaces this with a 2-tier hierarchy:

  Tier 1: Per-CPU sheaf             lock-free (local_lock)
  Tier 2: Node partial list         kmem_cache_node->list_lock

The intermediate lock-free tier is gone. When the per-CPU sheaf is
empty and the spare sheaf is also empty, every refill must go through
the node partial list, requiring kmem_cache_node->list_lock. With 16
CPUs simultaneously allocating bios and all hitting empty sheaves, this
creates a thundering herd on the node list_lock.

When the local node's partial list is also depleted (objects freed on
remote nodes accumulate there instead), get_from_any_partial() kicks in
to search other NUMA nodes, compounding the contention with cross-NUMA
list_lock acquisition — explaining the 41% in get_from_any_partial ->
native_queued_spin_lock_slowpath seen in the profile.

The mitigation in 40fd0acc45d0 ("slub: avoid list_lock contention from
__refill_objects_any()") uses spin_trylock for cross-NUMA refill, but
does not address the fundamental architectural issue: the missing
lock-free intermediate caching tier that the CPU partial list provided.

Thanks,
Ming


