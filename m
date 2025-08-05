Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE33C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 06:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3DFD6B0096; Tue,  5 Aug 2025 02:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15C26B0098; Tue,  5 Aug 2025 02:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52B36B0099; Tue,  5 Aug 2025 02:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D60A66B0096
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:23:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43B3F160F89
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:23:53 +0000 (UTC)
X-FDA: 83741713146.03.95B7F0E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id E058D80004
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:23:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PCmv2yty;
	spf=pass (imf02.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754375031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YSXKdaD3IZAs8uieY7LPn8yhD3PkW5u9fBN/Is1bw+s=;
	b=D0IglTpRGzvzJ8oh+1VVSe3xrzsSXeeI5BdJsqseUHXnx7h0BgYCapREp9S0oL+l0ZYYSM
	q0nxRPQiaZOhxmIqABsHTNs9DVOozDazPAt/S6b+vFkvyX4fsXFaL5yLinnqTGT1VKok14
	xNNJbTc9HRugGkiWX2tFylI2js6j+/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754375031; a=rsa-sha256;
	cv=none;
	b=LRVMmINLbQO2cAvTQkD+6bUxH0TPT/jnIw0KvX1xbE1USLZSy2DaiamRPzA/UPSISlADiy
	kfV+dFxdvhy1yNXgIk3gv6fQS+LroA+KeSlCfedT2Mal2KZ3mGj4GcLvQveVT7zQ+CpQoY
	VvLwuo57TDoTvXi4iF3b+2GXZnBnExU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PCmv2yty;
	spf=pass (imf02.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754375030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YSXKdaD3IZAs8uieY7LPn8yhD3PkW5u9fBN/Is1bw+s=;
	b=PCmv2yty5vu7EFquIaYpY+EXp60G4vE/ND4onb6IFtdtbse5ynL3ndE4AaQAL2kbvy/5Wy
	ltRuI8rpMy+cmXrybyAhB3BGRilNISg0KmdBxo/52XLv6Z0nmVoghJN3HGfZ1lkK3Bjy5q
	1qd0T9ED5DrvAwqIf9XfDCwYDBg7eHI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-L51CUMXUOgaWzMV0lMozWg-1; Tue,
 05 Aug 2025 02:23:44 -0400
X-MC-Unique: L51CUMXUOgaWzMV0lMozWg-1
X-Mimecast-MFC-AGG-ID: L51CUMXUOgaWzMV0lMozWg_1754375023
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D3CD180045C;
	Tue,  5 Aug 2025 06:23:42 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.136])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9AF5F1956094;
	Tue,  5 Aug 2025 06:23:36 +0000 (UTC)
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
	Baoquan He <bhe@redhat.com>
Subject: [PATCH 0/4] mm/kasan: make kasan=on|off work for all three modes
Date: Tue,  5 Aug 2025 14:23:29 +0800
Message-ID: <20250805062333.121553-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: E058D80004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 13p8trjhjuejcxc6yqdhe1s9dp53uki4
X-HE-Tag: 1754375030-385759
X-HE-Meta: U2FsdGVkX1+frOFV52OG+nKnvQn76Zl1tIXaHuxTHmR8uN8JWqIm/8jsYWwSBbCoLOeK5s4Utgxccqlt3WIygn6qmYpttQ5GoY9M8/r1GF8kNMThckTdx6rafIWNJHT9PNLhhOnhLcYgH1zDz2tWT62AgkzJjGZ/SuwOegaP3MEOYhj33AiZj/PL+LWZrtkKwAMkpGXCjk/Dvz9uYuyJtAXE6mCw2LPaaL0J5+JzgSOXJo7oiqAQR0+yIY7WQVavWCMlkWH12o0mkcT7iUDQJiaTnaAyXdBu4FtXC6sgfASA6RqyQo2fuoHUZWkNUKw58cqdb8oJozjYuHP/MJdwC9M/E04mz1STJwG7CWSzFiQhDOt9CGMiJTDWOdrv0KwLJW8XE2wvVuPnwNjWa/wQz88Mpgi/cPfRybT/BWCiaDwQ3ZfsS2P1kRitSGXj8uEDhFzMJOSmhOhW6tAWN9rSidAPkkSOm/lBJomCTFZbm77IOPTsZO3ghU/pmQCU0vFrH4tG3j8VKubX1+zn0wfTlFPs+NIne5kmdjnUS+wdUZ/igbK3uAQZPdnLIp1rYy8NHF8KL5R3m8yHwh63XhCvZD4pRGHSrgS5E4SB0RPBoorH6bn9kWQYD5nR296j6/DKs7VOIq9I5IrB6hMvRWnZoZI1GbZSPAPy7lzP1eMw713Yx2y/+h07cLWpDs7ku1WzUWGTqRL0LArN7QoGBn5kBpsbSDeVTJ9S2kFMRiozHgDbv0UL+siqDS+kjCxMk0x852z9nE06Op9Q6W4Cekky4IWXuiWS+NVmY7NA3YZrNZEro023Zg9q2f6eHalvgSrf4PDAaJn+6OmECuUWlfKJU11ro5a9vstCTdumabJqDxH89pZdoaAotymWC9XU20bMRi0dl/gatN8KhkQWwdcs3dboUMxyx71KNZ8Q82r7r0gqxKNlisR3BEz6IeayEFghuZbQKh6LO3vU5Nblqpz
 z3AbbjXF
 mUbhKHgaE9WLTA6Oqedy5OkV4P6rXayYRtoyGjT0dB6dJAcx1QywGlJKWEtG5aGLrRU6JyMrFMuIROsjowP9K2dye3yrH/rBgmqmZx7XGUw7HdBUyihOfKO2y/SoqfzhRHMt+uqd6ZBU2nNEvZAkQWGVXcHnI4ZqUDknqtgVhLRoVLRXXihZSkrSysgKEtnEQSDl0FH5v/9QYImMC8puHZEVKfNz0od6AzZ0czyIyjoyGHfvhhPT9sF3ljQRAizq88RYj44lRZl8TZRdzy/SsCiu54FdOtExl8UBeEQYopjlz4Ajk1l1BrgnI7Su06tzxkcoDKJhE6cN0iHAbx8X/aQmJFdgYEgqrvSbo9y09/q5C406rHBVTMZyUQg==
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

Test:
=====
I only took test on x86_64 for generic mode, and on arm64 for
generic, sw_tags and hw_tags mode. All of them works well.

However when I tested sw_tags on a HPE apollo arm64 machine, it always
breaks kernel with a KASAN bug. Even w/o this patchset applied, the bug 
can always be seen too.

"BUG: KASAN: invalid-access in pcpu_alloc_noprof+0x42c/0x9a8"

I haven't got root cause of the bug, will report the bug later in
another thread.
====

Baoquan He (4):
  mm/kasan: add conditional checks in functions to return directly if
    kasan is disabled
  mm/kasan: move kasan= code to common place
  mm/kasan: don't initialize kasan if it's disabled
  mm/kasan: make kasan=on|off take effect for all three modes

 arch/arm/mm/kasan_init.c               |  6 +++++
 arch/arm64/mm/kasan_init.c             |  7 ++++++
 arch/loongarch/mm/kasan_init.c         |  5 ++++
 arch/powerpc/mm/kasan/init_32.c        |  8 +++++-
 arch/powerpc/mm/kasan/init_book3e_64.c |  6 +++++
 arch/powerpc/mm/kasan/init_book3s_64.c |  6 +++++
 arch/riscv/mm/kasan_init.c             |  6 +++++
 arch/um/kernel/mem.c                   |  6 +++++
 arch/x86/mm/kasan_init_64.c            |  6 +++++
 arch/xtensa/mm/kasan_init.c            |  6 +++++
 include/linux/kasan-enabled.h          | 11 ++------
 mm/kasan/common.c                      | 27 ++++++++++++++++++++
 mm/kasan/generic.c                     | 20 +++++++++++++--
 mm/kasan/hw_tags.c                     | 35 ++------------------------
 mm/kasan/init.c                        |  6 +++++
 mm/kasan/quarantine.c                  |  3 +++
 mm/kasan/shadow.c                      | 23 ++++++++++++++++-
 mm/kasan/sw_tags.c                     |  9 +++++++
 18 files changed, 150 insertions(+), 46 deletions(-)

-- 
2.41.0


