Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FA3CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 12:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A97B8E0113; Tue, 12 Aug 2025 08:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15A688E00E5; Tue, 12 Aug 2025 08:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049238E0113; Tue, 12 Aug 2025 08:50:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E36B38E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:50:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 94960135C3F
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:03 +0000 (UTC)
X-FDA: 83768087886.02.BBA1FD6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id ADFE716000D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EJDx4oT9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755003001; a=rsa-sha256;
	cv=none;
	b=KAZm4x6nn01AEUkRMEQnuHXn6zfKEz0YLwijlWJDGAHR4XABGgGLkw2/gF9AtIreItMp+Q
	Y5tPnA4wY2vi9nuvEDaHHjj8VInyGKFGtX4bpBue3uRipjZUPGRJOvmQfnNDLcbEdiSgv/
	UsGBdq71pcQPKh9LQFWTC/FvwG0ZbaU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EJDx4oT9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755003001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3ZE38hmpc99A2k7OXVLbkRVM4tCEFDqNHUDB9CwwXLA=;
	b=phWeEGlISzA/av/sBcwS4bZmels2JDQhocTkeORDAcGvDxd5w+8RMcKjcdQxrEjIGlRa1L
	dFr21rWfatptyTN8Fdc+GS6h/qBS+EI2rYlz04nqu5mcLJ/GLQFsxbaaNRnZ9QpVHyD97z
	wBdYV9+qDWdCzUkQ9Z8rSnwD/5CfvjQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755003001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3ZE38hmpc99A2k7OXVLbkRVM4tCEFDqNHUDB9CwwXLA=;
	b=EJDx4oT9M4eTfPu95YmyX4ELP3DiDC8v+hMlHzCTseOT/D8pk6KUf2jI8O5oBVDR9FQcH6
	5lTLes9idYdj1lU8G+irHUvNepJJ3RLTePu1GIgob4JGHHWA1BOthDiTrM++IP0lrpo5Ip
	534ToHaoG5FZ6QBLdDqRhWX0nZZJy+U=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-o8yLrza-Pk6ODkq5WeTjFQ-1; Tue,
 12 Aug 2025 08:49:55 -0400
X-MC-Unique: o8yLrza-Pk6ODkq5WeTjFQ-1
X-Mimecast-MFC-AGG-ID: o8yLrza-Pk6ODkq5WeTjFQ_1755002993
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C3BB119560AF;
	Tue, 12 Aug 2025 12:49:51 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CCF6730001A1;
	Tue, 12 Aug 2025 12:49:44 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
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
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v2 00/12] mm/kasan: make kasan=on|off work for all three modes
Date: Tue, 12 Aug 2025 20:49:29 +0800
Message-ID: <20250812124941.69508-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: ADFE716000D
X-Stat-Signature: e9kbi5ioqnjei6hdndjhp4yg6dxauw1e
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1755003001-781188
X-HE-Meta: U2FsdGVkX19/WJ8+c7pfr5K0XxH9LUl61ugYWBnaUYygB+ExwIDC7GRKekCl92WJDSGIAi/JIdgTYwGkX2eoDGN8Bhs3W5xnfACZ2zCZeJtJzaBomLd5x/0KAnYwnDNbS2iBKWZKUq2+dnUxFs85foOzKF4jd9ruXNrkJpYIc1NKWuVVEsiOb5nxHN1z9jN5aEt4uSGlmx+3lMEnBBX5UGf9v23QodgfCAZu+NEc4BFE7vZmSXXjIx8d+02lhT2LtRvZJ58kvdxlidQwOwF0IPU4WtlnJN69kmCY3yWsULqUFGL+dLqx/ozCwQyvKo3fsbApMQ5UXJ0IfXJZhejeV0Y7OvuZpVZe8WoclL6XxHVgm9cbeJcir66bkDKabWRsNsQALD9udVUxyiY0bUpks/Ie2jiN3BHTA7iVtw8ahWDjOo0vo6Tz97UmLBNbtB5hsEABTeUyXeQtuZOQXl1uBk9szLo8SFlG0b690hVU/u/9Tb4V7ywmUr+bszkZ3xFb8GADVjaVvW1zOZ12aCRPmJd0GAF8xiuc0zcInO0bj79/bVo9JAd6utI2MHy4dDhE8fS1eM0G2cV+7kaot/hixsWtY3sGmsGYuYj8prOMW+BG+ssaclW/5wzb/fwerYB9ucR2HwHKMXSCu+fYPhneYmLXwoGUfyufTCxSunTBBl282srN8c+OxpbK/64JxmLFhwWGz5uPlij5SIlYSlgh5YpD+HUaJcuRkAE7sgqcYwc9lrl5v92l7mmaHAZ6+DXaX+EjqrNxihGGvqbxt9UKusaWU4vyqXDRQ1FaFFxaPVttL6npctnHy/xg28vlBPp4a6nbcfnTcpJyo9Ou12tJJq5v86lylwP0EjL0V6lOr5J1TX3D2duDcCkbfeOPnyBbdG9jR9lZsOhNZ6RKlEG0QbVqo5mqN0xrmbat58oTtBwyAdswUhNbkjST+ki3T7UoXBR4unwSflPxOk44QcL
 rfGqwGp4
 rVAAQQuWu4rHY9p12axrlNRrIhZ8v2y4f6VyuQ6S3yhDntg54/WQtw5qkqmdM1DyRWcGndLw1vEEqYZ1VyD9O1X08mZjnUh9xp9JpcPwJogSEC5+DF2SsntqBkkgp2JO/e8SYVTJS7jJqb9iJ1pdYktPNNeeWTwCTIKL13VkimzT9bc8UktxiOqvH6Nm6kN4GRxPxEYdsYhOchdsFQzqLmcLMaevgaKEWhee+B/6BnO4Q05q20X3FVWoNLbYiTTXxbmqfoLqvoJ0E3/p4tszTmqesHfMOSLJ6D/H2QBjS4gmkngPXaSIpJFzZJHzv/0JasLPOwSBGFSughjL2yPKZF0uuMH3JzaGotzLiM06L0fp3OYb/GhBtLSb8M+WgswM0zgpT
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
v1->v2:
- Add __ro_after_init for __ro_after_init, and remove redundant blank
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
 arch/um/kernel/mem.c                   |  6 +++++
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
 21 files changed, 165 insertions(+), 47 deletions(-)

-- 
2.41.0


