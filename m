Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42442CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 19:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18E5B6B0005; Tue, 12 May 2026 15:51:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13F196B008A; Tue, 12 May 2026 15:51:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055536B008C; Tue, 12 May 2026 15:51:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E73916B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:51:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2DBCE8D922
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:51:39 +0000 (UTC)
X-FDA: 84759812718.28.AB7A72C
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf16.hostedemail.com (Postfix) with ESMTP id 64014180008
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:51:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t7ZmhpJV;
	spf=pass (imf16.hostedemail.com: domain of 3x4QDaggKCDYkcZSoSbSYggYdW.Ugedafmp-eecnSUc.gjY@flex--skhawaja.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3x4QDaggKCDYkcZSoSbSYggYdW.Ugedafmp-eecnSUc.gjY@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778615497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XMGmjrgacA7FJIZhwbjaKrLrnllX5lCbrSfU7CyJlss=;
	b=1ZGRl+fx0L0giIXi66JP9lFUofxI7cB32aN15SdyXa1ATOykOb0VzGvz9U8m9GkNXW57DT
	xOmtyhwM0cNgmPTmn/nOP6FY7HeVVqpE+FMC4FFZu4HCe7ujrFqcvHGtrCEodQOV2psf1n
	RznM3lvzHIJm0SxRtHdbIsqxHbqmq9E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t7ZmhpJV;
	spf=pass (imf16.hostedemail.com: domain of 3x4QDaggKCDYkcZSoSbSYggYdW.Ugedafmp-eecnSUc.gjY@flex--skhawaja.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3x4QDaggKCDYkcZSoSbSYggYdW.Ugedafmp-eecnSUc.gjY@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778615497; a=rsa-sha256;
	cv=none;
	b=v84sS7HI6/2u+GonLvGW+ZNdm1Xdurp9wL4SJQvL6o4//S7iY60DExebHsyGfYEJvJx0Ey
	p+XIzyrP7NEzCEWNiGRL58lJ2KOK0CNMEGKSupAtLOPVsv0InP75kAgUqm6FRAbyIpwN9b
	3ag7XlngjHLdckGH8OBde/QgKiQ+VF0=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c827c0aac70so2196020a12.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 12:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778615496; x=1779220296; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XMGmjrgacA7FJIZhwbjaKrLrnllX5lCbrSfU7CyJlss=;
        b=t7ZmhpJVlk3DTMDalHtCIUccBSQyI31/0n+CIyPgmhnJH3CoyPBkFlj6e/dwDvZi69
         OnL7FiQq262nQWRkMyuxPEQTrlz1W5g0Mmo0kJbMGToYwpAite6TLt33XOsC2I5+YUG8
         I6vDhgFaYAhpi+ZbwabkoZKhIa1uDLtssk/TnEKccDE8BwpyqzhktCp743oxZeYfneAk
         EHSP5v66Nd8+A/I5xqm1sEt8Z++JrXujLCl+Z+BXi2hJ1DkJVLDZ/nT1yp5fDcYrJe0x
         mBOL1djb9N2MYvVXHtceWU4CsauaxdydpXaMFlTjJWW6GV6v6vFlkG/Fd2esa2SuhcP8
         bKvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778615496; x=1779220296;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XMGmjrgacA7FJIZhwbjaKrLrnllX5lCbrSfU7CyJlss=;
        b=ox7clgWA/BQlTJqYGZJAeIkERq/RXhV5rJ1jMgvUkk/TUHllx95ebZCd8bNjqPWOtt
         uQ/fK0BjIZQ50fGnrY0nNWADo39kkZbMQuyZBnnMZ9EDsNuoresk+rCOi47pjHRCckuQ
         tfJxvUaCrDxcLcgK80ltfsc4boDwZSARjSzspCDyZzsxGaIpM8f84L5OLHSrx/t7hf6S
         zt7TScaYw1/7LVnvN0gqFZQKVpjDiYSe0v0kgd1KOEc1N4KDnZy7D4BhLk+YKMwlmK+r
         6Mdk8lo3ycw962zaI/gUyHtvqHI/5z5Iy095X5M5dG5J4CFwzCXAAhjbHh9UVHApDkfc
         j/dQ==
X-Forwarded-Encrypted: i=1; AFNElJ/4t3b5s3WBdgUgKFiifH2d2wiW8dBvEagV78vKkPUPQERBu84h5/8+NSDc4gxLgex0CpBx4eX9lQ==@kvack.org
X-Gm-Message-State: AOJu0YxPqZpztdRNxRd/USshM5F05EKLmRKMJACgH0YAa6v8CWUfb2ix
	7p/eWfirqWrs5bGL/dknkz2gMy1Tar7LuZ4ViDkWp+5ULtSgnHSfIzdjsR8vtqvvTbJ0pxCgY4+
	GfNsowaFlKN/BGg==
X-Received: from pfbmd2.prod.google.com ([2002:a05:6a00:7702:b0:82f:4183:2832])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2d9f:b0:82f:4725:f6d0 with SMTP id d2e1a72fcca58-83ee83ed7b2mr4983816b3a.29.1778615495829;
 Tue, 12 May 2026 12:51:35 -0700 (PDT)
Date: Tue, 12 May 2026 19:51:32 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512195135.804833-1-skhawaja@google.com>
Subject: [PATCH 0/3] kho: Add support for kunit mocking KHO restore API
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ypbxu96g819349occf7hiarwqnua9p8b
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 64014180008
X-Rspam-User: 
X-HE-Tag: 1778615497-949896
X-HE-Meta: U2FsdGVkX19MsZUnn1VpihJsJP++xON4uof6tR2dsLFKee/ROTXIJEWqNVGUwdECwTvx+KoqS99SP50E6S5yWV/apm2Q23bZO9QaVT+NP/PWC3NLEwrqAXFmLFMkKbAYf+DgJ288ae+xChmvo8E/TJTqAChvAoRTLboAdo7Beef96n9p0jVVBzoH6e9wg/CRy4zX4nAP5Zh6T9SvYIKg1AkwU3xzFn1bhNDLJXTiDCDU49RupSaOj6V3qmz2wDspl786MMYGjGVhDCrHr++AD9KMQL66Us69RSipoflZ75CFNBfdTfUA5LsVgtOF23e21eXYobTMY3zNLD2YEMjuKDH3dodaCJ83AZ2IdqLlNFVBc9ZmbVEBMOk9X93WaA2moZd2Yq6R0BtQX85tfyfbVqiLlOfAKdehgwFzux9nIbQ8K3lB/8F7Kha2T7niaGIoS23/GSb5YDj9nOZeQKIf5NTvZyBNUI6c4ta5y/tpByGPfBNmIzaOj+xw5rRCbv4OpW1lc4RUHpB3UgtC4kRyYMPuE1MqXyhul5IRw7AGW1zFblR4UwywDEtEvQNynuKuryII6nBMH30sY9frgikkwEZzJJH4KuL+CBoAoCwFi4KUuaXGmkCo7UAhgsy5UWci3bC/fc5mnD02Ya0dWNPhzFPI3jaVBqroBGwNizalVEVY4LlAHMOXaYthtgtZVwYPBwelIo1b0GPht3q6B/QqzQyWtZ1sr6KfTY5iUNZfVh4/sYbiQ9CBF009MLBA5aIHXW0Tcmva3mOWsfjH1eRT2C3YqjmuhuEQr9+8jNV3hAM8ziZOueILwzLn1zPxMTcBlCH/CbhqVrcYQFo3iWQhZHWz6vG5QqB8o2APzQ52xkUdDPo1r4iOrQhkGllwcU0b8p+hg5wV74RjDgLIPCPVi4IBMLt/hv/WZBw+XhoJ6/qcECdV4+FIu1esHFbeqKu9PqlnCv8BoVWxoPTz1jQ
 ewUbyC6Y
 lMa/dSPcOwnCMAjlEP5CXIY3+AoJ65cS9DdQw9wOkAZuM0A4OeWgcFvN7BZut1oOmbQGBgQKKCEq2tV84i1nO7pNKFrLs9m1kOW29v0eYtTUow1zkR/gQZ7ZYR+vohnTz92uVy0pIUWGL6nsDT2zF6h+Ya7pg93ktx1wvqF3cdaJ1h4iXTD/QX8Ss8v13ia+uMQX7o26uv+ySTu+ctZhwSFWWGTFZhI8P8k60DoM6OvsfnJY9BesdNX2CYu+fh1ePxBabntZPcu3Bs1UBTjCqaVREn5qVW5YVWdsSxgEokYBHRBt/+U4zVJTsgnu2nXPmTo8F0IxYt/0ZqgrwHsuMRy9pe+G2dPv9OiPKbc8gW+XQXyXII9OsPYYztaYvE/QJsRLAfdO7s0WG+tw9MrGwVF9s/mWrZzf6CyokyW6yp0DlLaY/1zOwmL1kfve9+fwvh0JR7QG/ukz94kMAHTEin96OK2KltPx+Nvc6j5dUxUp74nBPlzhdzn+CyD4JVXg90ftiqUQTFzFokgQfAgEfpsUxkQ8y+5lVMVzJyk+pj5xs44wEDA94XGuQe5mcMH+MSKwz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To write kunit tests for preservation and restoration of liveupdate
state in various subsystems without triggering the actual kexec, the KHO
restore API needs to be mocked by the test writer. The mocking is done
to allow testing of the individual components or functions in isolation.

The patch series adds the following to support kunit testing when using the KHO
API:

- Add static stub hooks to mock the KHO restore API so the restore path
  can be tested without triggering kexec.
- Add helper function that can be used by the test writer to check if
  memory is preserved in KHO tree.

Finally, it adds a KUnit test for the KHO API that verifies the allocation of
preserved memory, and the preservation/restoration of pages and folios.

KHO Kunit test run:

 KTAP version 1
 1..1
     KTAP version 1
     # Subtest: kho_test
     # module: kexec_handover_test
     1..3
     ok 1 kho_test_alloc_preserve
     ok 2 kho_test_preserve_pages
     ok 3 kho_test_preserve_folio
 # kho_test: pass:3 fail:0 skip:0 total:3
 # Totals: pass:3 fail:0 skip:0 total:3
 ok 1 kho_test

Samiullah Khawaja (3):
  kho: Add kunit static stubs
  kho: Add helper function to check if pages are preserved
  kho: Add kunit test to verify preserve/restore pages and folio

 include/linux/kexec_handover.h          |   5 +
 kernel/liveupdate/Kconfig               |  10 ++
 kernel/liveupdate/Makefile              |   1 +
 kernel/liveupdate/kexec_handover.c      |  61 ++++++++++-
 kernel/liveupdate/kexec_handover_test.c | 130 ++++++++++++++++++++++++
 5 files changed, 206 insertions(+), 1 deletion(-)
 create mode 100644 kernel/liveupdate/kexec_handover_test.c


base-commit: 9974969c14031a097d6b45bcb7a06bb4aa525c40
-- 
2.54.0.563.g4f69b47b94-goog


