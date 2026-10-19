Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DFCCCCA490
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 02:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668766B00E2; Sun, 18 Oct 2026 22:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619BE6B00E4; Sun, 18 Oct 2026 22:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 507756B00E5; Sun, 18 Oct 2026 22:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 22F356B00E2
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:11:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A62AC0388
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:18 +0000 (UTC)
X-FDA: 85337748636.21.139E0C5
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id EDB7C40005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Q8AKU7LO;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792375877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YAWJPU0bKj56z57yKFJ+IjOtblegGIXvDvyM4kHd1kM=;
	b=oqLPTyucykktnQNL3nQ+/SAKDOrGKl5FkQ1morl0tJflG7UgsjIGye92gcksIP3fHhqBaw
	OgGj3Wv36IswDnFVoYwEPiYZtgxsAP9hNwwCf5/nr9u0SaS9Uhf0L1Kgvni4fcOO3CocXG
	60UZq2OlACdN1blPT1kh7uCR2m3zFfo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792375877;
	b=r6WXldzZ5GMCHUJS5JoHw+G/n3cGcaMkSgEsa3qEMNVIgppCQXfG0qDgoPyjqwWNZJycSM
	vU9gigPtaRPsx2OCL1KOrU+rbE7jkE12fNJLI53KBrUNwhCoFoI1aFOE3wVI3zIh5ZwDOJ
	EI1d9hcjvIXNuUJsd2jSe0PkGOwc+QE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Q8AKU7LO;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5eaabf28c06so1931344e0c.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 19:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792375876; x=1792980676; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YAWJPU0bKj56z57yKFJ+IjOtblegGIXvDvyM4kHd1kM=;
        b=Q8AKU7LO5FXMNnhNIo94oeIgHfaEsEiNYHtFDgpm8KW9RIEO3AM4QH/Ae9kQrDDS56
         AMuW24ZDblMXw+HX2TUWH4BwjnOWRO3v4s5xPZCzG0qvvQdtWLQlOxzwbjDQn4yNzoAq
         +7SxCl204IGd4i6jagpkqP47oKeqxWdOFeK4mHq3Kw/R9kcskNTsrbg05Q5Q64nrAI3M
         kPeQqRuPC0deFEyMijR/6c4233dFtZ93Vc3C2DnGDfSPFTo2AY7nVmxPcWrco1XKQtsj
         V7c4kBW4p0pxzoFhrCzw638ZiJhussFwdw7vZz6/11PcAV+mpMhMVyA2zrcZrsBtJbG1
         BfAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792375876; x=1792980676;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YAWJPU0bKj56z57yKFJ+IjOtblegGIXvDvyM4kHd1kM=;
        b=LZmpk5VR7YlfL2o4EfO+NvXeAb3vLxNypr0f2vl3F9yxs3C2PCeTAhgcEZIlzghFUQ
         N3RK5ZAGRdBEpc/zhyoUTFquq/jVfCmPa3tiW8t1kcCLeGIBj1vK4rGrI8aSURfL88ex
         f5i8qqQzDITQeFcA9MIs+z/AgjvRA7mfqnZksMSU7ZFZEDjhYoNEoQKXg6FmJIZRuWwP
         5f/rVN5RWwxTPiFBuV5bpM2qpdKuyADAHXzYHqDVvjtNwrm30Q2xCVtv6wa2nYIjKINi
         ev+Djw7tKryB5cFnp2qF2pkgv5yRChN3k751te81qeR5xIQFiWsp4Lb/nykCicnS4rm4
         Ca9Q==
X-Forwarded-Encrypted: i=1; AKwUvByv0eMtimH9A1tHoT03bV4tDUZBU1WMSuZqqzOM3uTc+h1lGRHcaxavP1ccSrNZp1xQCiEvC0Prmg==@kvack.org
X-Gm-Message-State: AFq9FYKaa6YyM7F94pmf0sML6BWtl0OwUABpWcmG71Xj2IU/VPvTF3XE
	Zq7FqQhChU5r48xWy9aQ4BUY106dTSsJtgvdMkfTYgBikgWe2cBT59hCi0nCAhh5vHU=
X-Gm-Gg: AYBFou2TYacfJe5QWkKKMR8dq3+aGkfD/Xix9znoeArSrvqO5Hh+pBqpbIcwR4LdIEo
	5tVZ1EG7EDDHoRp/MPqiUA16QQXr3QRwLRZ4jMhnHaqlGtMQRFhL9+SLKhgMyVViQTYaSQx/zFI
	rkLCfP5KirNmPQdUbKm4H+tV/ezrR+tpv1uWU13+XRT8fMsNQa/4mtQwFqw2fBb12C3A52bqJcO
	s8vin+YGCzPe7f/IV1zTzw5r8VO5ulIbfIOFeAyOAiNV5xlTCntTOiIFNH+P1Ya2B7xPidcGPP8
	tlzgs8CR9XD26Apc2H+NciRfDvI5jN8xNc9JsFLX15DKvIGT64D6/xdZJmuuQ4i5/yqJVHHbLGk
	pEqMxu2RSAEwwmvBbOVG8D8L4F3ec37yYFSzIWtQdkBZzK3UmyFy77tpXd/w4+MScxIpMYheSf2
	giOs3vR7hQbfZtOzAtyi5JGwpjXhja+KFdZYt4VHYL4GKiNUA8WvwcHbik4izbSHH9mAGLvaPT9
	VDpuS9JVj4TcgtzGx7Y761FKrkacXBFRvMc92wvtKZVMemgX0JiIpliWWHkDCQUIMNkkVP5grCG
	qZ13B9jc5z5ujcZ5Ie0d
X-Received: by 2002:a05:6122:4f87:b0:5ea:a21b:31c6 with SMTP id 71dfb90a1353d-5eaaa0fd89amr2353045e0c.2.1792375876111;
        Sun, 18 Oct 2026 19:11:16 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eabbd9ea2bsm4271383e0c.2.2026.10.18.19.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 19:11:15 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	kuba@kernel.org,
	enelsonmoore@gmail.com,
	bp@alien8.de,
	shuah@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vbabka@kernel.org,
	dapeng1.mi@linux.intel.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	surenb@google.com,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	elver@google.com,
	graf@amazon.com,
	lirongqing@baidu.com,
	liam@infradead.org,
	jlayton@kernel.org
Subject: [PATCH v1 0/8] kho: add read-only Kexec Handover mode
Date: Sun, 18 Oct 2026 22:11:03 -0400
Message-ID: <20261019021111.990394-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EDB7C40005
X-Stat-Signature: qcisao61npqjssh6ed3xm79dw3qr11yu
X-Rspam-User: 
X-HE-Tag: 1792375876-176692
X-HE-Meta: U2FsdGVkX19au9KiwMnoJV2NRWCk6n121mHuVGydxiJBr0LWJq6vVD0EIVMJbi1wMP59bb+uUwTv+dkFpr91SudhW4qOoMYxz9eOfXP1XDsRkb78Be9+pubTCNR5jbOou37T5YFRFV/bY9dW8F6xKs1r98MqpFmkve9PsuWJbP2xdNZ4r402Rovoxuj7+eMBN6RFdjm+vV6GKXv8zfmt49eYjoiIiBhNTA/EMSiR9MEmbXscoDjzLPnFilvUD0oyIaRtXUxW7XgovU/w3SiGNHY2qTlkKAwbu6NRGd+bsTdUZxZIzifZ154SGhLe7PtcO7xGHhGmzK9Pu/a4XtGfaVBv/0j7Uhu61WBICBYoOvLyKNci0lSfW5BZxIhMBxkEdQZBacebH4DCXH6A/v+OKu8gpkb2v3EwcmL2SiaoGk3J6eJbAvJQtbxCWSQPubfO4ez62c4cRi1wA10/7MXi5GUIfifz1gNzgYju7jkFEDuj1V2xyHyxtm1hx2hrfoEH+rq56D9CawalnGXuUk4zUVsAbuti7+VpDooHwUTKU3OOC35I9o/P7iRVbsJiplX6OZgj3ElZTmMhfA99pW2DkQVNEhCnsbH20E3lcIwpgchN2waEbRdbsw+hG2T8APDf+vp34P/IIvaa5NShX1s37K5ktTFbPzIH0dRlZP546QnFRzpRpsjFK5/5DU6bIuUyySkuUU6ZlqgypwmTL2mtESKiEF6y30hcC+8KQJbM1pjWqrJZY6PYSAQxhEVCSmPDQ2LFCnB5sxJm7mI+94UmmFZwCzoL1VDAIqndjtMPNKBhp6Y8bBBR4l/REcLXCUeNyl8Vfw1zGH5vP56/An5igNtSQhlhyZSjbQLZqERfkC9TAc7kicGPX0y1RvP4AnNqg3BXDotshyC7hmzzJ37Cxx1dRwzOgWHffb8XQqgNufMz0wQ4YYoAzLl36R1N4DpPWa2ajmP+GKA99ON8ywu
 qcKoDYK8
 wZI0/RcnETSeQTi4DxsB2RQ7vRmWdsbilSjPqTTuwHih4AMHY+zQQFBuzVNMYsR8Zu7GtGxYt4uHW1I7KKCCXSOhq8Tqt88ljhEsE14YcVzZ8GeT7ZGfUTLRvzA72ayt75Dr/SFb1W49PWtttnz4170wk1Z9qYKEDeEg+4gOyFFjWnAnVUZMLnJl1PbNibZDi3P1enCahV35gSZofEeY0cHltoak3varXR3c5QW4/Zw00UWiWH/VV9TSS3C7x8/l4M7xfWjUSUJnNyWI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces a read-only Kexec Handover mode, enabled at boot
via 'kho_ro=<pa>' pointing to the physical address of the KHO FDT.

In standard KHO, the target kernel takes ownership of preserved memory
during early boot, initializes struct pages for preserved folios, and
reclaims KHO metadata and preserved pages back into the page allocator
as they are restored.

In some scenarios (such as a caretaker, inspection kernel, firmware), a
kernel needs to inspect and consume preserved KHO subtrees, radix trees,
and serialized metadata without taking ownership of or modifying the KHO
state, leaving the preserved KHO tree intact for a subsequent kernel.
In this mode, the KHO physical memory lies outside the kernel's direct
map.

To support this cleanly without duplicating KHO traversal logic:
- Patch 1 exposes the physical address of the outgoing KHO FDT via
  /sys/kernel/debug/kho/out/fdt_phys so userspace tooling can pass it
  to a 'kho_ro=<pa>' kernel.
- Patch 2 moves the shared radix-tree key encoding and indexing,
  vmalloc flag conversion, and FDT validation and subtree lookup helpers
  to kernel/liveupdate/kexec_handover_internal.h so they can be shared
  between standard and read-only KHO.
- Patch 3 hardens kho_restore_vmalloc() by introducing
  kho_vmalloc_validate() in kernel/liveupdate/kexec_handover_internal.h
  to validate the preservation metadata header and flags before
  restoring the vmalloc area.
- Patch 4 avoids modifying ser->next and bs->head_pa in kho_block_add()
  and kho_block_set_shrink_one() when operating on an incoming block
  set, as the chain is already linked and incoming blocks must not be
  modified in KHO read-only mode.
- Patch 5 adds CONFIG_KEXEC_HANDOVER_READONLY and
  kernel/liveupdate/kexec_handover_ro.c. When booted with
  'kho_ro=<pa>', preserved KHO metadata is mapped read-only
  (PAGE_KERNEL_RO), with the FDT and radix-tree nodes mapped lazily on
  first visit and kept cached, providing read-only implementations of
  kho_retrieve_subtree(), kho_restore_vmalloc(),
  kho_ro_lookup_folio_order(), kho_ro_map_folio(), and kho_ro_unmap().
- Patch 6 updates kho_block to map incoming serialized blocks read-only
  via kho_ro_map_folio() and unmap them via kho_ro_unmap() in read-only
  KHO mode.
- Patches 7 and 8 extend test_kho and tools/testing/selftests/kho/vmtest.sh
  to test read-only KHO handover when preserved memory lies outside
  the boot kernel's initial memory range on both x86_64 and arm64.

Pasha Tatashin (8):
  kho: expose physical address of outgoing FDT
  kho: move radix tree, vmalloc, and FDT helpers to internal header
  kho: validate preservation metadata in kho_restore_vmalloc()
  kho: do not modify incoming serialized blocks
  kho: add read-only Kexec Handover mode
  kho: support read-only KHO mode in kho_block
  kho: test: support read-only KHO mode in test_kho
  selftests: kho: add read-only KHO test to vmtest.sh

 .../admin-guide/kernel-parameters.txt         |   6 +
 Documentation/admin-guide/mm/kho.rst          |   3 +
 include/linux/kexec_handover.h                |  53 ++-
 kernel/liveupdate/Kconfig                     |  16 +
 kernel/liveupdate/Makefile                    |   4 +-
 kernel/liveupdate/kexec_handover.c            | 142 +------
 kernel/liveupdate/kexec_handover_debugfs.c    |  22 +-
 kernel/liveupdate/kexec_handover_internal.h   | 171 +++++++-
 kernel/liveupdate/kexec_handover_ro.c         | 378 ++++++++++++++++++
 kernel/liveupdate/kho_block.c                 |  92 +++--
 lib/Kconfig.debug                             |   2 +-
 lib/test_kho.c                                |  68 +++-
 tools/testing/selftests/kho/arm64.conf        |   3 +
 tools/testing/selftests/kho/init.c            |  38 +-
 tools/testing/selftests/kho/vmtest.sh         | 103 +++--
 tools/testing/selftests/kho/x86.conf          |   1 +
 16 files changed, 881 insertions(+), 221 deletions(-)
 create mode 100644 kernel/liveupdate/kexec_handover_ro.c


base-commit: 27be83a12b246b6b3783e7d3ac5c378ff7520f25
-- 
2.56.0.176.g3575e65682-goog


