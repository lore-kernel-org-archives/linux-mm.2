Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B60CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566248E0020; Wed, 20 Aug 2025 01:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D208E0011; Wed, 20 Aug 2025 01:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 405278E0020; Wed, 20 Aug 2025 01:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29CC18E0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:35:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAA2F160333
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:35:17 +0000 (UTC)
X-FDA: 83796022674.08.553EA81
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 397FA1C0004
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:35:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aY4XQFUC;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755668116; a=rsa-sha256;
	cv=none;
	b=I1zcOVUHOKVGGPswSHDGoVziYgZdxP1oTi5PkQUQUeBFKLOanoQHQ5Wji4NtDRNRvX9wQG
	QpH8iEwf8lYRhe2X51tCi17bGyjRM/gmvVwVNR51nfwK4negdmMpTXhvWicqFQi7kHLELG
	u0dGtF2v0eS+ssDQulnXK6jxIf22BJ4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aY4XQFUC;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755668116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=z74jlNhSBHrs3/SSQ+V392Z6lfqsJ86AC9wBk3eVnUU=;
	b=qrShN8ik9jui98g1rGhqeD73BkJ8+Pu2NZHkziVc2dAVZUvzuISuub7AC/n25qNHN0vW62
	X65jqR3SAQNGrjKfnCEbgNuXFMqix21Ntk2+Qt+nLnA5+H/3niHhLgSDe0vSZfqQfv/+3L
	s8oxziqSo3eU2CPuTKaw/ncV+iVsrQM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755668115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=z74jlNhSBHrs3/SSQ+V392Z6lfqsJ86AC9wBk3eVnUU=;
	b=aY4XQFUCJ01P46c2r5ImsnXXfauvIj4EL5mDuXOkO885HsdwFKnBxCb+wMVahnluprlejq
	HeGl1Kedwj0MRwStQUzM5YP74j2N3u61vHtdgQZI+1e2ult0NE9wqY2ttBLSn7xs6O6FI1
	PX1mfqCiwza8KqpjXaNbgzP2sI9gHsg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-502-2hNAHMbvMa2UgQhFl-leGA-1; Wed,
 20 Aug 2025 01:35:14 -0400
X-MC-Unique: 2hNAHMbvMa2UgQhFl-leGA-1
X-Mimecast-MFC-AGG-ID: 2hNAHMbvMa2UgQhFl-leGA_1755668112
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 38944197753E;
	Wed, 20 Aug 2025 05:35:11 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.99])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3145B19560B0;
	Wed, 20 Aug 2025 05:35:02 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: ryabinin.a.a@gmail.com,
	andreyknvl@gmail.com,
	glider@google.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	sj@kernel.org,
	lorenzo.stoakes@oracle.com,
	elver@google.com,
	snovitoll@gmail.com,
	christophe.leroy@csgroup.eu,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three modes
Date: Wed, 20 Aug 2025 13:34:47 +0800
Message-ID: <20250820053459.164825-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 397FA1C0004
X-Stat-Signature: 14asgk5gfkt9mxyu9kfgzm4iq8toixtb
X-Rspam-User: 
X-HE-Tag: 1755668116-500688
X-HE-Meta: U2FsdGVkX19XkxIUSEZBRlQMzZsjk4LhrMC6xt1zYnN4CPjIfjGG7nWtln4qAE5a7l10fKLzU/HB7G13Mr6CEFZu5xJgok1zQ/PrjxQTrgR4wRtgiYGtP6SGvZsa06+ojzmjlJ2qaEbJTc1GAXb+btJ3vZ6b0Axec2LZhCqAb2ay60GqT6Hl/mxx5DXNvX0ArIXV+2PTnu/urY935LlnozQzUjVRzpLMzFU5PwqrhrUTLMbs7DaiuUYg4E7GrgE6Iv3kf1dDa3l7PbGa821Jov1RDvJ8m5oE59jPdqHBXugwrhDsZ/zOsannBslYBtPs7kwCtzfZKFR7dQXzoh4Xh7u0W7R1kkp6Vl2DMZdTZGOhCcIJ4GXNaxK1gCiItOhmRg6Da96j+db7IiaXmS3zs/o0QX43HLlk1UCBIeA5jw8ck3KsNzC/YOIF4njfmvv4sH5u/qn2AaOMiDQE44GhqvdKcsS/OUJcd3lF/Vu+UAsnXnTQ18BCJ/0wdprV69ki7+DRC0MasTUYaeig/fVN0QkGQNJPTsZJTOaoKounW0SYaEiXscE9KkKqyc5jCecs+mTrOUqkowCXtnUe0dDJXpvF7yajrRhXcf/nAPFzfuk42pf3ZarN6N1a4KGtlluL1nv/EqP3Ouv0zpU76VAYMSceZhbLjipPgcFJg/eihzsrXS6bXQgtf67b1UWs00uWx0vZLmeC21aST8J/WM2CD0b8mom1PoOO1Rl8p8VaOV7QCLIr6F2xXvQeGA71I/MvCcOyAbZQuuCk3DI+BqW+wTZ9RcY+6wXWDdtQ66A3IKHowxMdnS8SXqi4AHkG+ZIS7C88tRkw9N3lu0LARGWAqhyx3YgM6lgYIudNL3+9Paf9IAAdayVOzmMRULtPrUOI52Msy56xa/a3ZAlcWg1MpNppTaUBB6I3Azkexz7Dc/mmVOA2ELTbcP+8yQmWelTn7nVTJKm0UVRQaazNRe5
 5h+J2pQG
 FnRL+bfLGQMieRBx9sGYNjy3MDzBZu+UgsdHLlf1MSF36Olwrtnnr7G4VL7hG0qsjGXyp3nK4a5f+Rwk6DYEThHWr74bLGc7HVk0AXZ8CiEsWgOkgZMXbhXhtwPQxyzCWvqTO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently only hw_tags mode of kasan can be enabled or disabled with
kernel parameter kasan=on|off for built kernel. For kasan generic and
sw_tags mode, there's no way to disable them once kernel is built.
This is not convenient sometime, e.g in system kdump is configured.
When the 1st kernel has KASAN enabled and crash triggered to switch to
kdump kernel, the generic or sw_tags mode will cost much extra memory
for kasan shadow while in fact it's meaningless to have kasan in kdump
kernel.

So this patchset moves the kasan=on|off out of hw_tags scope and into
common code to make it visible in generic and sw_tags mode too. Then we
can add kasan=off in kdump kernel to reduce the unneeded meomry cost for
kasan.

Changelog:
====
v2->v3:
- Fix a building error on UML ARCH when CONFIG_KASAN is not set. The
  change of fixing is appended into patch patch 11. This is reported
  by LKP, thanks to them.

v1->v2:
- Add __ro_after_init for kasan_arg_disabled, and remove redundant blank
  lines in mm/kasan/common.c. Thanks to Marco.
- Fix a code bug in <linux/kasan-enabled.h> when CONFIG_KASAN is unset,
  this is found out by SeongJae and Lorenzo, and also reported by LKP
  report, thanks to them.
- Add a missing kasan_enabled() checking in kasan_report(). This will
  cause below KASAN report info even though kasan=off is set:
     ==================================================================
     BUG: KASAN: stack-out-of-bounds in tick_program_event+0x130/0x150
     Read of size 4 at addr ffff00005f747778 by task swapper/0/1

     CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.16.0+ #8 PREEMPT(voluntary)
     Hardware name: GIGABYTE R272-P30-JG/MP32-AR0-JG, BIOS F31n (SCP: 2.10.20220810) 09/30/2022
     Call trace:
      show_stack+0x30/0x90 (C)
      dump_stack_lvl+0x7c/0xa0
      print_address_description.constprop.0+0x90/0x310
      print_report+0x104/0x1f0
      kasan_report+0xc8/0x110
      __asan_report_load4_noabort+0x20/0x30
      tick_program_event+0x130/0x150
      ......snip...
     ==================================================================

- Add jump_label_init() calling before kasan_init() in setup_arch() in these
  architectures: xtensa, arm. Because they currenly rely on
  jump_label_init() in main() which is a little late. Then the early static
  key kasan_flag_enabled in kasan_init() won't work.

- In UML architecture, change to enable kasan_flag_enabled in arch_mm_preinit()
  because kasan_init() is enabled before main(), there's no chance to operate
  on static key in kasan_init().

Test:
=====
In v1, I took test on x86_64 for generic mode, and on arm64 for
generic, sw_tags and hw_tags mode. All of them works well.

In v2, I only tested on arm64 for generic, sw_tags and hw_tags mode, it
works. For powerpc, I got a BOOK3S/64 machine, while it says
'KASAN not enabled as it requires radix' and KASAN is disabled. Will
look for other POWER machine to test this.

In v3, I only built UML kernel successfully w and w/o CONFIG_KASAN
setting with LKP's testing steps.
====


Baoquan He (12):
  mm/kasan: add conditional checks in functions to return directly if
    kasan is disabled
  mm/kasan: move kasan= code to common place
  mm/kasan/sw_tags: don't initialize kasan if it's disabled
  arch/arm: don't initialize kasan if it's disabled
  arch/arm64: don't initialize kasan if it's disabled
  arch/loongarch: don't initialize kasan if it's disabled
  arch/powerpc: don't initialize kasan if it's disabled
  arch/riscv: don't initialize kasan if it's disabled
  arch/x86: don't initialize kasan if it's disabled
  arch/xtensa: don't initialize kasan if it's disabled
  arch/um: don't initialize kasan if it's disabled
  mm/kasan: make kasan=on|off take effect for all three modes

 arch/arm/kernel/setup.c                |  6 +++++
 arch/arm/mm/kasan_init.c               |  6 +++++
 arch/arm64/mm/kasan_init.c             |  7 ++++++
 arch/loongarch/mm/kasan_init.c         |  5 ++++
 arch/powerpc/mm/kasan/init_32.c        |  8 +++++-
 arch/powerpc/mm/kasan/init_book3e_64.c |  6 +++++
 arch/powerpc/mm/kasan/init_book3s_64.c |  6 +++++
 arch/riscv/mm/kasan_init.c             |  6 +++++
 arch/um/kernel/mem.c                   |  7 ++++++
 arch/x86/mm/kasan_init_64.c            |  6 +++++
 arch/xtensa/kernel/setup.c             |  1 +
 arch/xtensa/mm/kasan_init.c            |  6 +++++
 include/linux/kasan-enabled.h          | 18 ++++++-------
 mm/kasan/common.c                      | 25 ++++++++++++++++++
 mm/kasan/generic.c                     | 20 +++++++++++++--
 mm/kasan/hw_tags.c                     | 35 ++------------------------
 mm/kasan/init.c                        |  6 +++++
 mm/kasan/quarantine.c                  |  3 +++
 mm/kasan/report.c                      |  4 ++-
 mm/kasan/shadow.c                      | 23 ++++++++++++++++-
 mm/kasan/sw_tags.c                     |  9 +++++++
 21 files changed, 166 insertions(+), 47 deletions(-)

-- 
2.41.0


