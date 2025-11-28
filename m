Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8A69D116F3
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 03:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D7AF6B0011; Thu, 27 Nov 2025 22:33:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AFEE6B0022; Thu, 27 Nov 2025 22:33:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED1F6B0023; Thu, 27 Nov 2025 22:33:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0DD6B0011
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:33:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BC7C88B15
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:33:47 +0000 (UTC)
X-FDA: 84158596494.07.C102FCA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9746D80002
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:33:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eDs/6N68";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764300825; a=rsa-sha256;
	cv=none;
	b=Js0B8gmGLAsJ+plR8ASAxEQP27a+v+WYTgLDb3iyfEZ3L/rFqQgm540axOzXOdg+asKXmP
	ZLJnMpN3904uQ+Bb/N9CBcnRBLPNaA+c0VyXSpaNgJ8zerCTq3e3K6mcax3fOwx7ASw55v
	Z27L/PHj2cB2cO99/lOoXa+pxytd2EY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eDs/6N68";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764300825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Qr0zpQpajQCRbG+sF+yGezyQgSmvvZvdStpi3agx6mY=;
	b=1w+4WEDWdHXcNdrVQZIDxou1Qvnb0RHU1sl1+4xGxRzxjDA4H3yH+sCr2hGq+a9/kiE5SF
	0YC/l83orsYrEXFV6Gs8J8GIJquKCSNc+N+CHCYozwMqefmSL8Fv17zCLinHHUGtpyahAW
	+afYorKvgwIEKTn76ZJJWunIhhTa/hw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764300824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Qr0zpQpajQCRbG+sF+yGezyQgSmvvZvdStpi3agx6mY=;
	b=eDs/6N68YxRUNvRIPPeW2oOaSU2KpQd5ei73Nm9cNiWnIkVlfvh5L/yUGl9ZS3rRG+K0J5
	jzNr3dFN8wwrwxN0JoixPFMe167WDGv2IG1tMHqrpzq2uAcMjsuAhIURW/B2jcPvqhGT5P
	+av1aVvoHt4RzDN0LWGkUNZvi1lLPpU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441-sE3kvIDuP_qIGMkVoeXVOw-1; Thu,
 27 Nov 2025 22:33:37 -0500
X-MC-Unique: sE3kvIDuP_qIGMkVoeXVOw-1
X-Mimecast-MFC-AGG-ID: sE3kvIDuP_qIGMkVoeXVOw_1764300815
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42F9F1956095;
	Fri, 28 Nov 2025 03:33:34 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1735A19560B0;
	Fri, 28 Nov 2025 03:33:23 +0000 (UTC)
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
	elver@google.com,
	sj@kernel.org,
	lorenzo.stoakes@oracle.com,
	snovitoll@gmail.com,
	christophe.leroy@csgroup.eu,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v4 00/12] mm/kasan: make kasan=on|off work for all three modes
Date: Fri, 28 Nov 2025 11:33:08 +0800
Message-ID: <20251128033320.1349620-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9746D80002
X-Stat-Signature: tzqcsnzwyo7fa5q64hdefdis96dykbmc
X-Rspam-User: 
X-HE-Tag: 1764300825-276385
X-HE-Meta: U2FsdGVkX186hpaBCZ9RU//TPbSIkeK63UTsCvU7L0NAT+/GsjBzW83ATFab/3DEeBOn23Fc/MMUP/mtWcRNbYUIxg/9Bx+RVwHBSbjBb5+VLrTUiGe92fRJK/1ohrcBXWKCU1tLc8Amxfkx1ZYKkxsLbEVpNlKl3vtr8QNzcXu/0uhRrU0SFrTmu/82ZZZFJcWuPy0j6NFYud5aFJRTxOE8FToswvkTh8zAHedZ7sj6v7Qw4qBOiept8QPSJdwZkb3FwdSKTaxiPI1tDO5NrJENfUnIzPZkuIrqVRevL/HzFwWB3iBkfTqSywnfbQDnJzpGy23lF7pX89xwHkh/vcZF7BZWXyHQG+btkdC8FY5poz5k4TEzBWemDldseBYm8FIEQP4od8Zb7SdSCfeeyLxQtnqdpreTL8ge13IynELzLZdv5E4gczOSGRcGGvaeTlHtuHLOPpuvXbZU8VNVRRhe2k7n+koWkhzmfVkSlImZFD/5tKFwNTYRoRugyJfUgHpoBcmqOPDo0WmF3ssHEwrlgZXnwJz8pyR8OvpJiaKjvWaMdFCpMugUIdWb242qI7vvOlWotZ39I6+DRibfY/blB4JM5oJnUOYwr7gzruStkJCPz6d+eSowKGvMB+9Ga8bHvME7EEpeLnHZ8UB7PtrVtdlItIvgd53aTbu0wSdAPeHIaNIzJRA+zGfknigsKTtXl9UJL+YB5LpYbCPWn9/FZA1Ew8QJo79yNiqycRsuVp75J2jjb9O6VijytlRm/6DvWaUvIj61pZjiBoh8KUiBvWHch9vI/SLcnmj+/R1q92Gh33uK6v8sYrwGroY5jinunammYw+c9peNsQqvpUy5t5KgGQ07UMiQQHPzaOIuQmz9iSl75UAb7wuJIH2a2ZIkdHJZs5jkx8xxdJmsv5LFuwOzujWalez6OXx8uZGfnFkT9v1RBggIM/wbzg0GBDqep8g+/vdxzql+5aV
 I+JnmfNB
 8y1I40dwjy9tovzu+9SWk2KWgEoVn9AR5mPRk/ksVf2eq8ZqSODTS5LfzyKnYEJKppTiz0HMzsO48nenKhwVoGjXJhVqL+OF48H+oKZqH2EuOOjvdtx20HFrqfSBmQao7NVrvnEchJ6CadyW8OG4xfQhUEW3KuwJIrUB752vj8fKk2pabZw692DcCdN1sTJrIEN+MfyQEcBlzAef/P2heD0Lu5v2ryzEXIMuvEGEriZfSN74NiTMpJkSBVVSpx8U0nsk7bm8f8prnLKaVm+4SaXYVICukSqPqS/vwspvWAZHOUJyniJKawAF8hjJqrng/GrwgodCjpoBJmnC3fXlQclmuQzp3+1q/iOj8Er+3nBpGNnsg/VnoE3+ZL+NtfIpzmq+xdmUN/FWUCEFQUHItvpefwg==
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
while in fact it's meaningless to have kasan in kdump kernel

There are two parts of big amount of memory requiring for kasan enabed
kernel. One is the direct memory mapping shadow of kasan, which is 1/8
of system RAM in generic mode and 1/16 of system RAM in sw_tags mode;
the other is the shadow meomry for vmalloc which causes big meomry
usage in kdump kernel because of lazy vmap freeing. By introducing
"kasan=off|on", if we specify 'kasan=off', the former is avoided by skipping
the kasan_init(), and the latter is avoided by not building the vmalloc
shadow for vmalloc.

So this patchset moves the kasan=on|off out of hw_tags scope and into
common code to make it visible in generic and sw_tags mode too. Then we
can add kasan=off in kdump kernel to reduce the unneeded meomry cost for
kasan.

Testing:
========
- Testing on x86_64 and arm64 for generic mode passed when kasan=on or
  kasan=off.

- Testing on arm64 with sw_tags mode passed when kasan=off is set. But
  when I tried to test sw_tags on arm64, the system bootup failed. It's
  not introduced by my patchset, the original code has the bug. I have
  reported it to upstream.
  - System is broken in KASAN sw_tags mode during bootup
    - https://lore.kernel.org/all/aSXKqJTkZPNskFop@MiWiFi-R3L-srv/T/#u

- Haven't found hardware to test hw_tags. If anybody has the system,
  please help take a test.

Changelog:
====
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

 arch/arm/kernel/setup.c                |  6 ++++++
 arch/arm/mm/kasan_init.c               |  2 ++
 arch/arm64/mm/kasan_init.c             |  6 ++++++
 arch/loongarch/mm/kasan_init.c         |  2 ++
 arch/powerpc/mm/kasan/init_32.c        |  5 ++++-
 arch/powerpc/mm/kasan/init_book3e_64.c |  3 +++
 arch/powerpc/mm/kasan/init_book3s_64.c |  3 +++
 arch/riscv/mm/kasan_init.c             |  3 +++
 arch/um/kernel/mem.c                   |  5 ++++-
 arch/x86/mm/kasan_init_64.c            |  3 +++
 arch/xtensa/kernel/setup.c             |  1 +
 arch/xtensa/mm/kasan_init.c            |  3 +++
 include/linux/kasan-enabled.h          |  6 ++++--
 mm/kasan/common.c                      | 20 ++++++++++++++++--
 mm/kasan/generic.c                     | 17 ++++++++++++++--
 mm/kasan/hw_tags.c                     | 28 ++------------------------
 mm/kasan/init.c                        |  6 ++++++
 mm/kasan/quarantine.c                  |  3 +++
 mm/kasan/report.c                      |  4 +++-
 mm/kasan/shadow.c                      | 11 +++++++++-
 mm/kasan/sw_tags.c                     |  6 ++++++
 21 files changed, 107 insertions(+), 36 deletions(-)

-- 
2.41.0


