Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46703606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=b3PIHqeQ
Received: by kanga.kvack.org (Postfix)
	id 4E8A86B05B4; Fri,  6 Nov 2026 08:19:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BFFC6B05B7; Fri,  6 Nov 2026 08:19:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2516B05B8; Fri,  6 Nov 2026 08:19:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 106316B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:19:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96F0AC0D7C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:19:07 +0000 (UTC)
X-FDA: 85404749934.06.0232074
Received: from mta0.migadu.com (out-39.mta0.migadu.com [91.218.175.39])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9B7B718000B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:19:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b3PIHqeQ;
	spf=pass (imf06.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793971146;
	b=QEeb3o/ea79n018iN3ixoISL3zOtcOSjfWuI/VU4ScpZmwv0GFSuDUuMDFiP6OjOKcgE6i
	rKjpl/vRRsihdrziUswccSrRy1jyEYQxM4hlnKgYWO0aD8SSRMMJ6a88lesw/diiyEQRfc
	f2IzoqmldU9bRULNnfOgYCxPRcfZbnU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b3PIHqeQ;
	spf=pass (imf06.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793971146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=q5je5xTRpjfx4LjGIZHPjYuGaotAGI4cWt3i0iD11+Y=;
	b=V/GjLLJCZlbiw0Z3LMX3Z7tZZam0KKbu2PVqIz+HQQuJmi1TxviJpYPSn+vVsy1tQN3zsL
	81r9ugxraOhEMGnbu9YA6Pu6zcXLAYBfNKqkEC7QAcwxw7KccpRBiqGYc5hZs4lOG0BsAT
	254ojwOsJaojjBEB1RAC6pgfQpjL/HQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4zwexF7Wz01Eu+onBHbqwklyRz49GNwu5fYWiMpNDo0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793971140; v=1; x=1794575940;
 b=b3PIHqeQrojtLU4Y4VNCZ8rRt61bMFIDsLuTUcbsprTA2BhGn7Ms48fbXm2i4k5LuneFaPZL
 efns+y5W7XbtNLWmXja8lX760spiEjNqVLTfDK+0ec9BwB0YmskmQOe7C4oP0x7xojKGDPefOnz
 x3cM79fsW0CNI8761sGgxJNA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 26aa00f910ee51dc;
	Fri, 06 Nov 2026 13:19:00 +0000
X-Mizu-Trace-ID: 26aa00f910ee51dc
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: akpm@linux-foundation.org,
	dgilbert@interlog.com,
	mkp@kernel.org,
	loberman@redhat.com,
	jmeneghi@redhat.com,
	kraxel@redhat.com,
	vivek.kasireddy@intel.com,
	mst@redhat.com,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	stefanha@redhat.com,
	sgarzare@redhat.com,
	rostedt@goodmis.org,
	vdonnefort@google.com,
	mhiramat@kernel.org,
	jgg@ziepe.ca,
	kevin.tian@intel.com,
	axboe@kernel.dk
Cc: linux-mm@kvack.org,
	James.Bottomley@HansenPartnership.com,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	phasta@kernel.org,
	joro@8bytes.org,
	will@kernel.org,
	linux-scsi@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bobbyeshleman@meta.com,
	mathieu.desnoyers@efficios.com,
	robin.murphy@arm.com,
	mason@kernel.org,
	aesteve@redhat.com,
	tjmercier@google.com,
	harry@kernel.org,
	vbabka@suse.cz,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [PATCH 0/7] memcg: account the remaining uncharged kernel allocations
Date: Fri,  6 Nov 2026 21:18:22 +0800
Message-ID: <20261106131829.3228926-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9B7B718000B
X-Stat-Signature: 9nbkpqjzfceuac9xhfdxwkqqzqttsuxf
X-Rspam-User: 
X-HE-Tag: 1793971142-322957
X-HE-Meta: U2FsdGVkX1+bIkKulBRyR/4QgeJBmjjAfduA5jYnuWkKElPZpdcDPoQeeh63Fh6EoH0yXFlt1jV3ZNdtcS/qQWnCuJ+PPVNDcYIibvWGgu62tg3FoxOzhTMN10X06AzM+0Cd3iYaIn6Ied3KYgaJvosi4oymLV4g5OvbQJ8/2y2kXeSP0Ji8SeEmd6E37jync0fq4yUKW6WrVb7A7ARsTcdGW/kRaqsNXwC3gwcC1zPbqGNw5XHPiO+d3fDtAfA2Vy2EERpOlYiF0OspH/quEtrLAoxd7Pp/V4rfgsjcRn6tCX3h9S/sMegIUVOdDWWhecRhMK4MF/Pt+hUS9nBph548gmKryWTH4xSDxGEsFxs6YBcjuhkoY9GZzniOd5R/dViK3Cq9r+YHImOD+ypwQj72EZG1AwhCZ6EhZg8PpcE8WH7CSYVG2Y9oXr5Mg6J4WRmrSqIe+pBVyBXt1j8PaJYcttMzZBu6y1mp8Xjk/jdXTDmP9BAsjxRUg14WUWRqsG6yBS7jQNPzM0Nnb9VXYJCZhr7Q27N34wGzxLfaxgkDags/pFBlnZSB+xp1Z/+DnyaQiXWIxOcVnYiVOa+keJVtCUffSxJSjv49Zudmvw/gWYuno6dxf7Z7cDGwfXFbCoy3LmfOfnIkP099YVjMI978bksURI81bt4fCSfWOXYZ5SQZPlac/M/G+p+IfQ6W0XRlf+ls9S9dj6YEe+zo55kpJlxZlZfPKWt16WrMkc8iM5dRQU3UGfaBhwoB7odH42jU3OeD1GWEC/if/aIq72dv4Wl5uu8yy4Htx/n68mZw/WjGYv4Brfn7igLSmpeV2UtFp8NjZRAGLF6faqpHS86tsxISJQVeXS8UYtpAbq5g3Y8p6LgXfKY/j7K8R7G76+dvmW31NR0YOScBBb/vhm1pqUcxYafe3ufpHzz2kTf2+R0W+IElXb3wZ8MV+9pTxX7x5h/YrPQ+E7v+N5M
 N07uPmVh
 0tUw952dQnGpj5PIX2AGIEjVybY1HH1RvyCSA8/LyipP5w9x0wwuekcTLPLZ6NytHLxwFrDhVYdrozqKcCRyFuDmm9H2XP5ZAEpRyuT2xBrvmPQfvUgkg+PpDbDEcMODXU+WCzXWnsvFHCHSV9dNFVXWPvEffLbhz5r34mfTPe9prQj+OanH4IxmPIRzDWeFD19TOCoYlplsP8CLxKjhp06DvA6KIK5eS9NUHNzubn9qrgsIxNEV7ibbXzbiiV7kJrFbhlpzsSp4riJ6ppGwA0hZ2RZf4dZXZR5ogkGxSoVImqrLg1wVHGKibJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Tao Cui <cuitao@kylinos.cn>

Kernel memory that scales with user controlled input is supposed to be
charged to the memcg of the task that induces it, so that memory.max
contains the damage and the accounting is honest.  Sweeping the
interfaces that let unprivileged or delegated users drive kernel
allocations turned up seven more places where the charge is missing.
Every fix is one flag; the interesting part is who can pull the lever
and how much a pull buys.

An open sg fd reserves up to max_sectors worth of buffer, SG_MAX_QUEUE
(16) commands can be in flight per fd, and the fd count is bounded only
by RLIMIT_NOFILE.  udmabuf metadata costs about 4MB of SUnreclaim per
GB of buffer with size_limit_mb defaulting to INT_MAX.  vhost holds
roughly 150KB of resident kernel memory per SET_OWNER, and
/dev/vhost-net is handed to containers by device plugins.  A ftrace
instance allocates two full sets of per-cpu ring buffers the moment it
is created, about 1.375MB per cpu per set, gated by tracefs permissions
alone.  iommufd's hw_queue contiguity check allocates an array sized by
a u64 from userspace, frees it when the check fails, and can be
repeated in a tight loop.  io_uring still leaves the ring context, the
SQPOLL thread data, io-wq, the alloc cache arrays, the kbuf iovecs and
the registered eventfds uncharged.  The rsrc and tctx surfaces are
already charged by commit 075d5837bafc ("io_uring/rsrc: charge buffer
arrays and nodes to memcg") and commit 0b34e7b20a48 ("io_uring: charge
tctx nodes and personalities"); patches 6-7 pick up what those did not.

Verified on next-20261104 under qemu, same config with and without the
series, everything builtin: eight sg fds with 1MB reserved buffers
charge 8MB with the series and nothing without; resizing the global
trace buffer to 16MB per cpu charges 67MB against 0 before; four 512MB
udmabuf buffers charge around 8MB of metadata; sixteen vhost SET_OWNER
calls charge 4MB; 1000 io_uring rings charge 7.6MB on top of what the
in-tree charging already accounts.  All slab allocations in the series
are served by kmalloc caches, so they keep charging under the
SLAB_MAY_ACCOUNT opt-in rule queued in slab/for-next; the tracing patch
accounts page allocations, which are not affected by it.

Two in-flight series overlap but do not collide.  The dma-heap explicit
memcg charging series moves dma-buf data page charging to an explicit
path and removes __GFP_ACCOUNT from the system heap, while patch 2 here
accounts udmabuf metadata only, which that series does not see; if it
lands first, the system heap reference in patch 2 wants dropping.  The
io_uring patches sit on top of the charging Mason and Jens already
merged, and cite those commits as the in-tree predecessors.

I am sending these in one thread so the class is visible in one place.
If any of you would rather take your piece through your own tree, an
ack is all I need and I will split the series.

Tao Cui (7):
  scsi: sg and st: account the command buffer memory to memcg
  dma-buf/udmabuf: account the page array metadata to memcg
  vhost: account the per-device kernel allocations to memcg
  tracing: account ring buffer pages and trace_array metadata to memcg
  iommufd: account the hw_queue page array to memcg
  io_uring: account the ring context and SQPOLL thread data to memcg
  io_uring: account the remaining per-object allocations to memcg

 drivers/dma-buf/udmabuf.c      |  7 ++++---
 drivers/iommu/iommufd/viommu.c |  3 ++-
 drivers/scsi/sg.c              | 23 ++++++++++++++++++++---
 drivers/scsi/st.c              |  7 ++++---
 drivers/vhost/net.c            | 14 ++++++++------
 drivers/vhost/vhost.c          | 16 ++++++++++------
 drivers/vhost/vsock.c          |  5 +++--
 io_uring/alloc_cache.c         |  3 ++-
 io_uring/eventfd.c             |  2 +-
 io_uring/io-wq.c               |  4 ++--
 io_uring/io_uring.c            |  2 +-
 io_uring/kbuf.c                |  2 +-
 io_uring/rsrc.c                |  3 ++-
 io_uring/sqpoll.c              |  2 +-
 io_uring/tctx.c                |  4 ++--
 kernel/trace/ring_buffer.c     |  8 +++++++-
 kernel/trace/trace.c           |  6 +++---
 17 files changed, 73 insertions(+), 38 deletions(-)

-- 
2.43.0


