Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEB7BEFD206
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B196B00C1; Wed, 25 Feb 2026 03:14:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8EF6B00C3; Wed, 25 Feb 2026 03:14:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DB706B00C5; Wed, 25 Feb 2026 03:14:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECB0C6B00C1
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:14:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9068658E3B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:14:46 +0000 (UTC)
X-FDA: 84482267772.02.06C5120
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9695540003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:14:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HkSXxoam;
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007284; a=rsa-sha256;
	cv=none;
	b=M2FEjTkLblr+ejRmSGw45zCd2Q6fsNkXayF3YUBhVa7zALvC8Bo3d/BShYgpC2XLGSPKG3
	MUGtBUtFRZL0P9jX9pGcgbpUSZLCIB5/5o1e1TcXZAEsRt7z2bUHwm0KT3NBGLc6YtqkDW
	PF8P+NISe2q+oxRQ1C09Y6hXKRQ3gFI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HkSXxoam;
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=re7E4sxplbVcSJsRUE0dixF3rx550iAmXm+wmG0q1R4=;
	b=shrL8s3BM95GVphnEJrxrZZLv4p40RoGh7csFmjZ92cKqJ2SNH/rI1hwmFLJjZeRX3w9Hw
	R2Xa6uOArRXqiBC/hQ9CKzD4ihrbCYZEYFNXjLlJ74GgNM4scQeEAoQUpGnowmKDF+WriK
	rvHCQMO8mVq1nVYb3R3sVjZLLIhrrRE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772007284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=re7E4sxplbVcSJsRUE0dixF3rx550iAmXm+wmG0q1R4=;
	b=HkSXxoam4ln3rHPCIJZvxMgGUlavl1ceAKeBpLNhfPntNJe8nioSvA6o/7UwMrZeXzJFFQ
	OVtEQIeOmSdpfAbvgBFdfdO9xLXBLxwOWhcIqeUW8RbxF6hAAODh+1IXpCsUsTPmZNdoyt
	Xs9LAfty1O58GRxc2igvVWvLWS024VM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-497-8STCbgGpNdSEQd8WeY9I3A-1; Wed,
 25 Feb 2026 03:14:40 -0500
X-MC-Unique: 8STCbgGpNdSEQd8WeY9I3A-1
X-Mimecast-MFC-AGG-ID: 8STCbgGpNdSEQd8WeY9I3A_1772007278
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A1281956067;
	Wed, 25 Feb 2026 08:14:37 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7C6291800465;
	Wed, 25 Feb 2026 08:14:26 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org,
	andreyknvl@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	dvyukov@google.com,
	linux-kernel@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	linux-s390@vger.kernel.org,
	hca@linux.ibm.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v5 00/15] mm/kasan: make kasan=on|off work for all three modes
Date: Wed, 25 Feb 2026 16:13:57 +0800
Message-ID: <20260225081412.76502-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 2yBfFh1CNuh0oeC6PCVz44ehsxLOpNLXaS_0G0trcG0_1772007278
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9695540003
X-Stat-Signature: hsr9w3u98ko45cymnu94ynxgfo6begtd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772007284-258293
X-HE-Meta: U2FsdGVkX1/QY2bWanZdL4HAevlg2j7mt6UxwDFRwqihv/eEVYaQniFBABF4CoYpWW+D31aku3P2tzRqMZK8VZseQUgOKusD5DeFKmC6EZZMgMhcufqrYwAJ6O0pWql5qI4L648Lo5KO0wQMM0xkMwGh19T92AyQky8WziyMiknO+9UaQUWItj9BBim4y5LgsgiL6sFGRQDrwuYlYCllEGlQMrjWS/mTBRrFw5ajH9iWqgwK+7Oazjz9jpfBpL1drbXyreiBp5BwPFmhPW3rop8HwGRoMXWbgm5a0uI4la4XsFT5/hTRhtwnAqNaM/ofb6tTt2XXk5+nMbHdGXnf4mHFOk5F9LfBzqCAuxO21xYnVxX+4JMOSWO7pNwMNfLSLBI/qd2I7v6rp8loWEqROsd2QVnAJuvt2doTQd3K5FoMmgrJ37bbxMBbs6p7krPMYic6A5t7buVGlK/MxCrsh5ZWkAN8dafU+QmEXVo4n6tzT1aJk5WTO2u3KnfTEAkTC5t66KkwnZZe70QDIR1+rFu/2QilwwcOtRkxVtDrYkhuLNFPwhnp3KYYqBONiSaQv/FVB/HIOQ1GFE9Bbj4ksKHFLPYU91WbjLsrJCuB6DDowclhfKnvKuT99GIiktRjws624LnUclUm27s//hIMhdMSnHqPsam7o7pIUt39GFWVGCZ6yvc+l4tGp37i7R1zXWa6wYfnRyq0NncRZvNOmDIWpyvj49HjvMx4hl9+7vTPn+NfPhbVxaBMoESlpoyNQebEfxTOzj3XT+iAcOh0eSQsGPKhNh8b6fjmeeSftmLvMJ/k0ptZhvbxUQmR3mNi43BOL18dRv8P/YCKQ8HXfykH6Rc5KSEg9jZ9xCI/GbPzSVMfERri7PBw4ykrkfqlGcVEJCjoVKFb/LSgp1cS/9KFBmMkCL0aeZpKC6wcvVFpu4LfMewssrWlxJYMYJWnOOMyIGNDMBRyM38UoOR
 fiPbB0fa
 eCpn3UQw71GX5cHvJe7FZu8bLZrrCHUV2Q/15dae9tLc+eacZ5qJrOTwivo4p3CPNLOxKSvSRQVvACAG2vUlZP3z0DJKHrcqjh8n899+l6Fl+ACiMqqlXkVPlwGZ23nD5J+3H7SFuYfGEbmSUDtIv+5ml1VtBHFUSWywKdY8gf9ldxaBFMqxuLyLxieKtJ5vOj7MbXj86x1y70xyIPBhMj9Ql6ZAL0korsxw9WNdi0JPvK4wlxJE3tEgcxBqLq4ojZQDXoSkJ9T5wd9S9kc7Ydw2Aydz2w5b3Adt48TZ2M4weyUM5Nmn8Xu/xdNWruYr4YX/JO5ZWIlgjw/hFeU9K15hLgXZXVbcbH7cw2ZWW8Uk9TBSjIXOLBBwS87O9Hicb7Hkg
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
while in fact it's meaningless to have kasan in kdump kernel

There are two parts of big amount of memory requiring for kasan enabed
kernel. One is the direct memory mapping shadow of kasan, which is 1/8
of system RAM in generic mode and 1/16 of system RAM in sw_tags mode;
the other is the shadow meomry for vmalloc which causes big meomry
usage in kdump kernel because of lazy vmap freeing. By introducing
"kasan=off|on", if we specify 'kasan=off', the former is avoided by
skipping the kasan_init(), and the latter is avoided by not building the
vmalloc shadow for vmalloc.

So this patchset moves the kasan=on|off out of hw_tags scope and into
common code to make it visible in generic and sw_tags mode too. Then we
can add kasan=off in kdump kernel to reduce the unneeded meomry cost for
kasan.

Note that this hasn't been supported on s390 since I am not familiar
with s390 code. Hope s390 developer will make it work.

Testing:
========
Testing is done on upstream kernel 6.19.0+:

- For generic mode, testing is taken on below systems and passed.
  - x86_64 baremetal system
  - aarch64 baremetal system
  - ppc64le baremetal system (Model 9183-22X)
  - risc-v kvm guest

- For sw_tags mode, testing is taken on below system and passed.
  - aarch64 baremetal system 

- For hw_tags mode, testing is taken on below system and passed.
  - aarch64 kvm guest with "-machine virt,mte=on -cpu max" qemu command.

Changelog:
====
v4->v5:
- Add helper __kasan_cache_shrink() in mm/kasan/generic.c so that the
  kasan_enabled() checking done in kasan_cache_shrink() which is in
  include/linux/kasan.h. This change is made in patch 1.
- Carve out the change of renaming 'kasan_arg' to 'kasan_arg_disabled'
  into a separate patch from the old patch 2.
- put the old patch 12 to earlier place as patch 4 in this sereis so
  that the ifdeffery scope embracing kasan_flag_enabled definition is
  meaningful and understandable.
- Remove the stale and incorrect comment above kasan_enabled() in the
  old patch 12.
- Add comment 'If KASAN is disabled via command line, don't initialize
  it.' to all places where kasan is initialized and kasan_arg_disabled
  is checked.
- Add document in kernel-parameters.txt to note kasan=on|off.
- Remove unneeded ARCH_DEFER_KASAN and kasan_arch_is_ready().
- All these changes are made according to reviewers' suggestion in v4,
  thanks to Andrey Konovalov, Andrey Ryabinin and Alexander Potapenko.
  

v3->v4:
- Rebase code to the latest linux-next/master to make the whole patchset
  set on top of
  [PATCH 0/2] kasan: cleanups for kasan_enabled() checks
  [PATCH v6 0/2] kasan: unify kasan_enabled() and remove arch-specific implementations

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
  cause a KASAN report info even though kasan=off is set:
- Add jump_label_init() calling before kasan_init() in setup_arch() in these
  architectures: xtensa, arm. Because they currenly rely on
  jump_label_init() in main() which is a little late. Then the early static
  key kasan_flag_enabled in kasan_init() won't work.
- In UML architecture, change to enable kasan_flag_enabled in arch_mm_preinit()
  because kasan_init() is enabled before main(), there's no chance to operate
  on static key in kasan_init().

Baoquan He (15):
  mm/kasan: add conditional checks in functions to return directly if
    kasan is disabled
  mm/kasan: rename 'kasan_arg' to 'kasan_arg_disabled'
  mm/kasan: mm/kasan: move kasan= code to common place
  mm/kasan: make kasan=on|off take effect for all three modes
  mm/kasan/sw_tags: don't initialize kasan if it's disabled
  arch/arm: don't initialize kasan if it's disabled
  arch/arm64: don't initialize kasan if it's disabled
  arch/loongarch: don't initialize kasan if it's disabled
  arch/powerpc: don't initialize kasan if it's disabled
  arch/riscv: don't initialize kasan if it's disabled
  arch/x86: don't initialize kasan if it's disabled
  arch/xtensa: don't initialize kasan if it's disabled
  arch/um: don't initialize kasan if it's disabled
  mm/kasan: add document into kernel-parameters.txt
  mm/kasan: clean up unneeded ARCH_DEFER_KASAN and kasan_arch_is_ready

 .../admin-guide/kernel-parameters.txt         |  4 +++
 Documentation/dev-tools/kasan.rst             |  2 --
 arch/arm/kernel/setup.c                       |  6 ++++
 arch/arm/mm/kasan_init.c                      |  3 ++
 arch/arm64/mm/kasan_init.c                    |  7 +++++
 arch/loongarch/Kconfig                        |  1 -
 arch/loongarch/mm/kasan_init.c                |  3 ++
 arch/powerpc/Kconfig                          |  1 -
 arch/powerpc/mm/kasan/init_32.c               |  6 +++-
 arch/powerpc/mm/kasan/init_book3e_64.c        |  4 +++
 arch/powerpc/mm/kasan/init_book3s_64.c        |  4 +++
 arch/riscv/mm/kasan_init.c                    |  4 +++
 arch/um/Kconfig                               |  1 -
 arch/um/kernel/mem.c                          |  5 +++-
 arch/x86/mm/kasan_init_64.c                   |  4 +++
 arch/xtensa/kernel/setup.c                    |  1 +
 arch/xtensa/mm/kasan_init.c                   |  4 +++
 include/linux/kasan-enabled.h                 | 10 +++----
 include/linux/kasan.h                         |  7 ++++-
 lib/Kconfig.kasan                             | 12 --------
 mm/kasan/common.c                             | 21 ++++++++++++--
 mm/kasan/generic.c                            | 16 +++++++++--
 mm/kasan/hw_tags.c                            | 28 ++-----------------
 mm/kasan/init.c                               |  6 ++++
 mm/kasan/kasan.h                              |  6 ----
 mm/kasan/quarantine.c                         |  3 ++
 mm/kasan/report.c                             |  4 ++-
 mm/kasan/shadow.c                             | 11 +++++++-
 mm/kasan/sw_tags.c                            |  7 +++++
 29 files changed, 128 insertions(+), 63 deletions(-)

-- 
2.52.0


