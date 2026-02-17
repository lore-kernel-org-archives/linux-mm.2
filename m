Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B548E909AE
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 14:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEF6B6B0005; Tue, 17 Feb 2026 09:50:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7B06B0089; Tue, 17 Feb 2026 09:50:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FE066B008A; Tue, 17 Feb 2026 09:50:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CD926B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:50:42 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1FA0CC09DD
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:50:42 +0000 (UTC)
X-FDA: 84454235124.30.EB1210E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 70C821C000D
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:50:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771339840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=nMOe4RDxlvvysKllY378Tk/OsQq0qlkIMO2wJcC8mQc=;
	b=1ZlK/rrKxNP1YKxLfYy6jHTwVxDS/Q53LpPofRcuNePY1e04OPy4tdhM+aOJ6g2Dt0qNT5
	1wFhYNY5bdJqt0tR3UuCtw6kL2zEf82rh9l7FRH3VoY6C5S8D/Vhhmkdr1EJ3thQKMe7aG
	fDTJ8o7KRhQhwJmgQvdNpCcmJpj0s4w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771339840; a=rsa-sha256;
	cv=none;
	b=4TBztc8dH78a4jzBL9rc2hexIbC+ZmrXy5FWXyUTRel8iVBnmDdjMcgZrWdzhSyCirnffn
	39YjPhPpI/wMlOks2usCMLOGe7BqqtlhaOIrlGYadyNJe3/DJRytttsHYviaK1RIIzjxQv
	EU1HQWTUr/bJsGDcAHKhTgK7faz8azk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61D741477;
	Tue, 17 Feb 2026 06:50:33 -0800 (PST)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3E5A13F62B;
	Tue, 17 Feb 2026 06:50:34 -0800 (PST)
From: Dev Jain <dev.jain@arm.com>
To: lsf-pc@lists.linux-foundation.org,
	ryan.roberts@arm.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ardb@kernel.org,
	willy@infradead.org,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Dev Jain <dev.jain@arm.com>
Subject: [LSF/MM/BPF TOPIC] Per-process page size
Date: Tue, 17 Feb 2026 20:20:26 +0530
Message-Id: <20260217145026.3880286-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: sqb5we614jw638zi9kjwgs8zmky6hwht
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 70C821C000D
X-HE-Tag: 1771339840-858071
X-HE-Meta: U2FsdGVkX1/q9y3kbMbY/Bu/cejwJg179dRp/T+jyC/eYPtj40xgyk69BIOPUDsMESWaiI2jPCx3X1BQFGmBsNMeJ84mlO0JU/R2WiJl6lgHW9Crpacts3ma6bsnz5VVgFu6IQyX/rtLSfSmErj9fgpo+3oij4fxJ+8lglhQ/M0+f2wL+fy/Iz4vKSm8vM8QaQ64LE2KZhx3uYJbzABrdRwjXOjXQFVNKBIM6NaMleJI7PDNvEIZfn1tPCVOIgrRv5UkwdsOFWHZp9JCjB5IwoceEPA9Wxitt8vH/OGPDK//tMZETOjEIKLmgxbXCjLkJF6B7hvFRFTlRfP8gywPaLDns5IaER0QZEjWE5nuHVIuszLLtgTzJpkF4E9/lyiMPllzHOw4EmlxQ/MDPj9kbW3yAdwhVfWJcb581CTNAO2zpODj1DcWqQLhA3dkl7x8aUZrDpaZlBJnHnDJ15kFK+XmUQ9yRIT5Po0Y49DcFAynrsTprwYw576Ec00UtSxB3tRHWjV5n6jfXI7EMd+OkqG2F2tHzG6YKItYu0LGo6i2WY+BZMRtESOpd+SpyK3EI4qslVPbhOyexJSQN7Fa9wogkuyvjHHnW4KULTTKjL1aGXowg71uUITxbbtSvk/YFa1WacWf03JAVla6tsxzm54aZhzAhTduXmqOZA461R3flEKBTLTUOqjjvgjhYpry8EyRwNambppSwepSQqA4NICa2W4SUyKUC7hBSRIiWwlZmp5pQQ1twl1NP9OD35WhBJv4xkRifOyEMBx5nObOt/aBYYB8LpON0K/euSxOZjac3kW9kU0v9YOKIgONd3KMxxvZG6GyMZ79NrR+akmxS6d4df6K4svny1AFYxWXld1p1BfDOhfYcxhW2ZNWC3NzpCwXY0x+hTCSYQd2AbVQ6KcIxxUT4mQ+TSp8htU+ynLQQrK5UL4wBKCNePKr0hPEOH69peDQGpywKttXF7v
 pfgoZ4yS
 m6r7hUW/Tmq9DTmGD13O59v9JmIMjpJt93f5q9J5iXlyXXexfOwOtzzdFTwudWA4Si0kVlilbdLhUXx/JNYFr8VnmLNAh/r7WTlXV/nc87UGGZKv1dj7ZxCcUlaM5zJGbK22T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everyone,

We propose per-process page size on arm64. Although the proposal is for
arm64, perhaps the concept can be extended to other arches, thus the
generic topic name.

-------------
INTRODUCTION
-------------
While mTHP has brought the performance of many workloads running on an arm64 4K
kernel closer to that of the performance on an arm64 64K kernel, a performance
gap still remains. This is attributed to a combination of greater number of
pgtable levels, less reach within the walk cache and higher data cache footprint
for pgtable memory. At the same time, 64K is not suitable for general
purpose environments due to it's significantly higher memory footprint.

To solve this, we have been experimenting with a concept called "per-process
page size". This breaks the historic assumption of a single page size for the
entire system: a process will now operate on a page size ABI that is greater
than or equal to the kernel's page size. This is enabled by a key architectural
feature on Arm: the separation of user and kernel page tables.

This can also lead to a future of a single kernel image instead of 4K, 16K
and 64K images.

--------------
CURRENT DESIGN
--------------
The design is based on one core idea; most of the kernel continues to believe
there is only one page size in use across the whole system. That page size is
the size selected at compile-time, as is done today. But every process (more
accurately mm_struct) has a page size ABI which is one of the 3 page sizes
(4K, 16K or 64K) as long as that page size is greater than or equal to the
kernel page size (kernel page size is the macro PAGE_SIZE).

Pagesize selection
------------------
A process' selected page size ABI comes into force at execve() time and
remains fixed until the process exits or until the next execve(). Any forked
processes inherit the page size of their parent.
The personality() mechanism already exists for similar cases, so we propose
to extend it to enable specifying the required page size.

There are 3 layers to the design. The first two are not arch-dependent,
and makes Linux support a per-process pagesize ABI. The last layer is
arch-specific.

1. ABI adapter
--------------
A translation layer is added at the syscall boundary to convert between the
process page size and the kernel page size. This effectively means enforcing
alignment requirements for addresses passed to syscalls and ensuring that
quantities passed as “number of pages” are interpreted relative to the process
page size and not the kernel page size. In this way the process has the illusion
that it is working in units of its page size, but the kernel is working in
units of the kernel page size.

2. Generic Linux MM enlightenment
---------------------------------
We enlighten the Linux MM code to always hand out memory in the granularity
of process pages. Most of this work is greatly simplified because of the
existing mTHP allocation paths, and the ongoing support for large folios
across different areas of the kernel. The process order will be used as the
hard minimum mTHP order to allocate.

File memory
-----------
For a growing list of compliant file systems, large folios can already be
stored in the page cache. There is even a mechanism, introduced to support
filesystems with block sizes larger than the system page size, to set a
hard-minimum size for folios on a per-address-space basis. This mechanism
will be reused and extended to service the per-process page size requirements.

One key reason that the 64K kernel currently consumes considerably more memory
than the 4K kernel is that Linux systems often have lots of small
configuration files which each require a page in the page cache. But these
small files are (likely) only used by certain processes. So, we prefer to
continue to cache those using a 4K page.
Therefore, if a process with a larger page size maps a file whose pagecache
contains smaller folios, we drop them and re-read the range with a folio
order at least that of the process order.

3. Translation from Linux pagetable to native pagetable
-------------------------------------------------------
Assume the case of a kernel pagesize of 4K and app pagesize of 64K.
Now that enlightenment is done, it is guaranteed that every single mapping
in the 4K pagetable (which we call the Linux pagetable) is of granularity
at least 64K. In the arm64 MM code, we maintain a "native" pagetable per
mm_struct, which is based off a 64K geometry. Because of the guarantee
aforementioned, any pagetable operation on the Linux pagetable
(set_ptes, clear_flush_ptes, modify_prot_start_ptes, etc) is going to happen
at a granularity of at least 16 PTEs - therefore we can translate this
operation to modify a single PTE entry in the native pagetable.
Given that enlightenment may miss corner cases, we insert a warning in the
architecture code - on being presented with an operation not translatable
into a native operation, we fallback to the Linux pagetable, thus losing
the benefits borne out of the pagetable geometry but keeping
the emulation intact.

-----------------------
What we want to discuss
-----------------------
 - Are there other arches which could benefit from this?
 - What level of compatibility we can achieve - is it even possible to
   contain userspace within the emulated ABI?
 - Rough edges of compatibility layer - pfnmaps, ksm, procfs, etc. For
   example, what happens when a 64K process opens a procfs file of
   a 4K process?
 - native pgtable implementation - perhaps inspiration can be taken
   from other arches with an involved pgtable logic (ppc, s390)?

-------------
Key Attendees
-------------
 - Ryan Roberts (co-presenter)
 - mm folks (David Hildenbrand, Matthew Wilcox, Liam Howlett, Lorenzo Stoakes,
             and many others)
 - arch folks

