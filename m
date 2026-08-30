Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7525BC61DE2
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CB3A6B0098; Sun, 30 Aug 2026 03:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A22B6B0099; Sun, 30 Aug 2026 03:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B90A6B009B; Sun, 30 Aug 2026 03:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 493126B0098
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:48:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B512C120150
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:48:08 +0000 (UTC)
X-FDA: 85157157456.11.9378FA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 02BD62000A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:48:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XXZjfJn/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788076087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OUSBuPbkgvvs7WqRcGgbke6rpMilgaQ3CVPiWBPYFtU=;
	b=grp7f5AzJQKSkQZn3m0FTXxAkEaYA7+BYQ4QZ+A5Ofb60rD+3HQhD9zo6208Cu37rve4Ml
	qLL2W0fK7RPN7QsAyzPeVShp/QKjNX/f5wEA/z6mur0SFJxCHS9lsy/5q5FdPDFrvLYDUF
	s12SVZxoOzAXrGyublWxCSYfU3oFOD8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XXZjfJn/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788076087;
	b=KO0HhmgpYlcp8mmlE3NbWQ5zdS/8JulAXXIIWpxmRNRr3IB+iPSBKLXZb/EZOrFxisdFoi
	IJnHcPt2iU2mckgVdlFDaZ7Rfr4ARizxtXuUDoZGbVm2H4zGGWx28hyeNHDr2R9HY5aQHO
	Fo1J/UGMzqURGfkuNM0IZ5gcxi0A8V4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3791843C76;
	Sun, 30 Aug 2026 07:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1DB1F00A3D;
	Sun, 30 Aug 2026 07:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788076085;
	bh=OUSBuPbkgvvs7WqRcGgbke6rpMilgaQ3CVPiWBPYFtU=;
	h=From:Subject:Date:To:Cc;
	b=XXZjfJn/l9reN3sv2uNRKT5zpSYocUtRxKxv0hFlqrV2qAEv3KArYO1bQ5PW/ZzXH
	 +6kirRWN0MtdcbEr5t8AcnRqqDN66u266Jz0y749SjJeez9cY1jd8xVH+zOXVcsSxm
	 NcWySLa70EOYMctxt31QjbYGu6nLpYSWa94OkoknlcjRT99gYC8/e3M0BDRsRXw8c1
	 cfK8mDOHqBmw+Vbj+guW2u5KC6quklkb6MC7Xhw1DQ4T8CGy41suH4Ce++HEwiMPGC
	 1uQU3w+ur5AR/DGX88A29qzh3rDHzoaB9MRDS/t/K9w32a77MxjoBFVTMOBOaxewBa
	 33LT3VS739U6w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/4] char/misc: replace page allocator calls with
 k[mz]alloc()
Date: Sun, 30 Aug 2026 10:47:57 +0300
Message-Id: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWM0QrCMAwAf2Xk2chsxU5/RXxo08xFsEqiIoz9u
 +18vOO4GYxV2ODUzaD8EZNHqbDbdEBTLFdGyZXB9e7QD+6I1SrexQgz0Z69D2EYM9T+qTzKd32
 dL3+2d7oxvdqgFSkaY9JYaGpqxbD1sCw/fME+7YgAAAA=
X-Change-ID: 20260829-char-misc-dcc4e33778fd
To: Arnd Bergmann <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>, 
 Eli Billauer <eli.billauer@gmail.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Michal Simek <michal.simek@amd.com>, Ritu Agarwal <rituagar@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.17-dev
X-Stat-Signature: utxz6ny89brzy7ihb4er65ciwft7ysep
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 02BD62000A
X-Rspam-User: 
X-HE-Tag: 1788076086-130761
X-HE-Meta: U2FsdGVkX1/h7vpQGapqweFM2mzX7jVstCoUKOPo5doBzcPtUPHVJbYzU+/B16KMIyErAcV/TorzQy/Os6QKX5q1gU8e1P/C+nO7ZR0uMI8eJ8Jv3FbUUZpz23q86MEZ8SNyqDgH/5d+5ktfYct1Ns8SKEppVguSW86/PLJXkP/0hs1GmQVFZBf1gLnq99MTQKNX7JpBXxKyF0NzJ0he8CAwMMrvQcQdRoORu7CCW2JfCXnD7B6NIdlYKXzobpdQFtsn/rVbElgHjdSU5WooZAcOenLq5OSZnDqZJAgTZrnry3BkD87eZGSMP5Go/Kxxvx5jZn0KTyFYr1VDJO0t+TqpXMo2VhnVqrDLjwei84qdIDtWeNuOXXb9+0FKWQJKVgCpPH21D/PtwSE23lb2+EWOs4YUMIIWdEKyxiiAA4eFKXKuOhSQGJunZiRr0ugLQ0n5G6QMBlNj2IB5XldcbE2n0GTdiYBEp0HX80V8Jy/9Y8b2uxrRkBPS4iM98wrS98Npu4ce4R/jQ8i8HAWeTiab20HLhTKaoGUqv7/NfsCeE+nHoPid7JaGH6rtCrBlaYUwjGHS2kmRPMNWbSuvtrccmsrASDvsPykH1mQIV1bmXqc7GMyRqQDjVAs1E1UkTK7IaYjwwGKBSMv7Gl0mS4RcyiLsHurPlFdOtutRXQyOzOiNDyXjdHtTF23ZKdYEVDcAktXpeZWdiKmXHc12iUdlazUqlEpyCKMaNSdK5w0lOCGMtDrVm1yapNL4dGX+kZohL/7/ejIoEGAicGcw9LrAHCAPk9iRdTKSAbfzRck620RYKOXikwO5ELEz0GDhwjPjIuJ9LFGcLgMI8TQakfhtOsidSJu0mAEnvnby6kIfKafY8xo/3Jv3eNmMvJWbw3W0KSF1UsbPhycM0B3PLh9pulWl9GMRjxMst/KAwD4GFWVSoQO1ixsv1Mw7CgGWu6dx6ttVrLBWt/j8P0K
 3ZDCYy/1
 SWmzmN5JnsDkEtvF5+bBviAeEdyH5L6+SLzilF1D4RK2h6MbPX8tE/v56npcDQuLFPn/Z9v5SX8qD15UABkRooBZRTEwR7v+Q9dxRRFSmJss6G90gtiJWJgYTOl3N6IO/WaXk2Z5Iq8Tqi9culpMmSDlDLIoMwJsI4GAM/a0kZc8lm5LFjTQOSwQu0ZoKSgnukCASlCngAw1qBYJzgiw3J7APaZhU0Q4KE4XVSLFndbPa5QT62H54JwNqxNkNVOvrpftLY0K3kLgi93085kA7tXJgGPaKSN4AkiGJrOMr+MRZUyhy1oQPT5/tCBsZZ32rNjkvNd59JqncMXA+pkvz4a3+EA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a (small) part of larger work of replacing page allocator calls
with kmalloc.

My initial intention a few month ago was to remove ugly casts [1], but then
willy pointed out that Linus objected to something like this [2] and it
looks like more than a decade old technical debt.

Largely, anything that doesn't need struct page (or a memdesc in the
future) should just use kmalloc() or kvmalloc() to allocate memory.
kmalloc() guarantees alignment, physical contiguity and working
virt_to_phys() and beside nicer API that returns void * on alloc and
doesn't require to know the allocation size on free, kmalloc() provides
better debugging capabilities than page allocator.

Another thing is that touching these allocation sites gives the reviewers
opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
another size is appropriate.

For larger allocations that don't need physically contiguous memory
kvmalloc() can be a better option that __get_free_pages() because under
memory pressure it's is easier to allocate several order-0 pages than a
physically contiguous chunk with the same number of pages.

And last, but not least, removing needless calls to page allocator should
help with memdesc (aka project folio) conversion. There will be way less
places to audit to see if the user was actually using struct page.

The patches are deliberately kept small: each one deals with a single
driver or subsystem and with a single type of allocation, so that every
conversion can be reviewed, and if needed reverted, on its own.

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/

Note that the xillybus 'salami' buffer in xillybus_core.c is left alone: it
is allocated with __GFP_DMA32 which kmalloc() does not support.

---
Mike Rapoport (Microsoft) (4):
      char: xilinx_hwicap: replace page allocator calls with k[mz]alloc()
      char: xillybus: replace __get_free_pages() with kmalloc()
      misc: ibmvmc: replace get_zeroed_page() with kzalloc()
      platform: goldfish: pipe: replace __get_free_page() with kmalloc()

 drivers/char/xilinx_hwicap/xilinx_hwicap.c | 18 +++++++++---------
 drivers/char/xillybus/xillyusb.c           | 25 +++++++------------------
 drivers/misc/ibmvmc.c                      |  6 +++---
 drivers/platform/goldfish/goldfish_pipe.c  | 22 ++++++++++------------
 4 files changed, 29 insertions(+), 42 deletions(-)
---
base-commit: 1b78070aaef63512688aebfbc82365ef9d6660f1
change-id: 20260829-char-misc-dcc4e33778fd

--
Sincerely yours,
Mike.


