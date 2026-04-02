Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2C63D3942D
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 14:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 065116B0088; Thu,  2 Apr 2026 10:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015F66B0089; Thu,  2 Apr 2026 10:16:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46736B008A; Thu,  2 Apr 2026 10:16:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE9826B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:16:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2EDF4140374
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:16:51 +0000 (UTC)
X-FDA: 84613817022.11.D96E627
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id DFB8B1A000F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:16:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Up9f0WZi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HknQF3Mg;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Up9f0WZi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HknQF3Mg;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775139409; a=rsa-sha256;
	cv=none;
	b=q4Ulk4raK5gVZYKIDpNq2qWD6aTfZQ6M2+kdza2t3vI3XZmm9+x8LqoMqXg/mj+3qjW8ae
	5zZyfa9KDtaow7VBNbvJl3TzZBo8nuGYSOWph1jAl4xqJOkDUZdgwyumwIAe8YiwxZXUQh
	SUaJsWIrHvjx249XJhurp5wRIOLI774=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775139409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lHVLkHx+G9AsEmcMTWgCDVpEt0qDNniMJG3ECVycNqs=;
	b=vJEesUvSKoOm6ZNz+gnAjU8xUKomlk5UzTau5MCuzDEEYslW0o0KaVKq6j2e6QsV9h8wPk
	gdrt3+qByqOZ7u3HYgY3uwEVBpxGshzPbhwltu8LPeElHii4x99lODEruzJ4CmsMxndVD3
	1ohgxA223rLLuUYRnlzmgkuVtwiOMgI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Up9f0WZi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HknQF3Mg;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Up9f0WZi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HknQF3Mg;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0CD164D343;
	Thu,  2 Apr 2026 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775139407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lHVLkHx+G9AsEmcMTWgCDVpEt0qDNniMJG3ECVycNqs=;
	b=Up9f0WZiI3gHZ8dp9MBHnQOCMzVN1+h2CKw6gR3zG870b81TYNxP9Su/AQ2nC9HpLbpRT/
	WMwYKrEiD37v6RIe6/hereAXib8imy8UQOJrKMiQQU5OebWhWTbuQoeT+uoci2ZvcYx4rR
	Cs4Oy/v27AY47m8yP4KS6Fcw27Rzleo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775139407;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lHVLkHx+G9AsEmcMTWgCDVpEt0qDNniMJG3ECVycNqs=;
	b=HknQF3MgIvLV7zW68xhdn5QsluwcttaFwUQPqNxPki7pbpXvcUbBXaOuh71L0OcIMMGh6n
	cYIqQ8PP90asX7DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775139407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lHVLkHx+G9AsEmcMTWgCDVpEt0qDNniMJG3ECVycNqs=;
	b=Up9f0WZiI3gHZ8dp9MBHnQOCMzVN1+h2CKw6gR3zG870b81TYNxP9Su/AQ2nC9HpLbpRT/
	WMwYKrEiD37v6RIe6/hereAXib8imy8UQOJrKMiQQU5OebWhWTbuQoeT+uoci2ZvcYx4rR
	Cs4Oy/v27AY47m8yP4KS6Fcw27Rzleo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775139407;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lHVLkHx+G9AsEmcMTWgCDVpEt0qDNniMJG3ECVycNqs=;
	b=HknQF3MgIvLV7zW68xhdn5QsluwcttaFwUQPqNxPki7pbpXvcUbBXaOuh71L0OcIMMGh6n
	cYIqQ8PP90asX7DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 337164A0B0;
	Thu,  2 Apr 2026 14:16:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NTMuCU56zmlQDQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 02 Apr 2026 14:16:46 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Luke Yang <luyang@redhat.com>,
	jhladky@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] mm/mprotect: micro-optimization work
Date: Thu,  2 Apr 2026 15:16:26 +0100
Message-ID: <20260402141628.3367596-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DFB8B1A000F
X-Stat-Signature: ry8i8c1uaogrjma64gg5jhbh6z1ernak
X-HE-Tag: 1775139408-936413
X-HE-Meta: U2FsdGVkX1/7nfAqs9B+F+lo2V1kgrGTBVppOx9d0byBybBoHwlemzJnk4dvGHtbN2jlJloao7pwbJfp999IGt7Ji18R2VSItGwXZgoXq7mUoxhns904lgeizaImkmI56/yZy8Hcewol1IvVNu7DhlgoGxyGk72+VXCY/Zep1UIxp4OSw9xMQ6ahdYtiI1k/RjtmyIyi2wZ7erjDIfjQV/MbyER781aydRZu2BaOENJC8E5EWxVu/F21jDxUWNymXGjrjcB+GbLbqH6ICBduVJFolBHcB+NcPprsvcUfq4Uedb24DtGrQgm6dKqV1npRM4/TUJmDLJEkjP+7XySXX+zM3NRAWDABUJrkTDzRoiNkP+WSMl/z+KpBM3TF0cQRcxNmurPT0LwHh+eAH0VY6LlpmqNFZ1ng/RjrEymhE07nopvNPg8amGRarNQaU5e81HlO87k3jmu/KYXNdtZ1AOulYHyTQ+fs/dPfQgbWm5U/7GX4j1IWagTxJ4GmlWlumYcI4iwE8MGZurjmWR7bY9+twoqfCh+IrrTCv7gzR5ZOxP9ofHaI5sXkQhHVrFWM8dU/LuWY/kdcRyUSmi0xiZS212aNqiBXpLZ8ACglQJS2imQ3T1kFQDdDdOj5eQOJrP+89HiKR5fAMKqj23r7skV9DgeKP+7VjuPVTnJq/O5B+5HNjY2ROVHRIuq/nGeu+nA147FOPMoqR9pF6drin/KfxpZ5Wo0WbM9TNohRBVLQLq5OP13Lo9VBjgdFt0PeI9LoW63msTPoB6/dx/Vl52DcezZwRP8zkeZ/cLgMfSSrQw+YjY+yDdLoxQCgUM7LlFYXboaG9kjEtUDInbGmYvIAi+gzx3/QCGl9GY2Z3zfkYy3DF/doOdLOUZCOqXoZYRuCCOwv52b67rDD72meg4SeZSBf59UQiW/oDLXG79lMXR8HKJYwV2K2eaogDllLNRuA7q268U0Wt1q2M3X
 4taBa8GF
 RWXmjIOzPWvt7xZ7qX9xsVobr0rAquV3reM2H/3k7xq7mquyNGT5DGAhtoeEMdeqGBIbMKR9wdgkYIjqBgVYX9vzv/Rhz0kOwC1t6or8hJhj1LPtyIgRrhKluAf39qFYuVGWDF2MHVrgRP98ozcIlhExkTjmQY7J7VlYeuovVYu7P29oG4XOje4AnCBYbI5GANduAE0vKGFKBdKSYmXc7/lm5vzIbBLQ/FT2n9ahrmb42DlFiIsI4dly2dUxKK9WC4AO1YUak8fN4GnO9g/Mky1+V+OtWfztuP1O6uZredzZtyXWD+juTs7QtaCQogWXZ0wxl8NIbLUgoiTW1+ppQwvpPq8PvUxfMlehZjSULJb1IpAfaRqNPwqt0Le9utI7KEied0SKw+pCRsVbKLuXU5sAV5gtXEEkMhqCgb37Vuj9FpME/56rCYu+L571+25t2eNvtIKjtK8n76IaAPYdiK8bk6eAQkfb2fZ8NFgkBLrUnO4DLI4Z31AtxamzfqzPBbpG2yYYyYCvLK70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Micro-optimize the change_protection functionality and the
change_pte_range() routine. This set of functions works in an incredibly
tight loop, and even small inefficiencies are incredibly evident when spun
hundreds, thousands or hundreds of thousands of times.

There was an attempt to keep the batching functionality as much as possible,
which introduced some part of the slowness, but not all of it. Removing it
for !arm64 architectures would speed mprotect() up even further, but could
easily pessimize cases where large folios are mapped (which is not as rare
as it seems, particularly when it comes to the page cache these days).

The micro-benchmark used for the tests was [0] (usable using google/benchmark
and g++ -O2 -lbenchmark repro.cpp)

This resulted in the following (first entry is baseline):

---------------------------------------------------------
Benchmark               Time             CPU   Iterations
---------------------------------------------------------
mprotect_bench      85967 ns        85967 ns         6935
mprotect_bench      70684 ns        70684 ns         9887


After the patchset we can observe an ~18% speedup in mprotect. Wonderful
for the elusive mprotect-based workloads!

Testing & more ideas welcome. I suspect there is plenty of improvement possible
but it would require more time than what I have on my hands right now. The
entire inlined function (which inlines into change_protection()) is gigantic
- I'm not surprised this is so finnicky.

Note: per my profiling, the next _big_ bottleneck here is modify_prot_start_ptes,
exactly on the xchg() done by x86. ptep_get_and_clear() is _expensive_. I don't think
there's a properly safe way to go about it since we do depend on the D bit
quite a lot. This might not be such an issue on other architectures.

Luke Yang reported [1]:

: On average, we see improvements ranging from a minimum of 5% to a
: maximum of 55%, with most improvements showing around a 25% speed up in
: the libmicro/mprot_tw4m micro benchmark.


Link: https://lore.kernel.org/all/aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb/
Link: https://gist.github.com/heatd/1450d273005aba91fa5744f44dfcd933 [0]
Link: https://lkml.kernel.org/r/CAL2CeBxT4jtJ+LxYb6=BNxNMGinpgD_HYH5gGxOP-45Q2OncqQ@mail.gmail.com [1]

Cc: Vlastimil Babka <vbabka@kernel.org> 
Cc: Jann Horn <jannh@google.com> 
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com> 
Cc: Luke Yang <luyang@redhat.com>
Cc: jhladky@redhat.com
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

v3:
 - Collapse a few lines into a single line in patch 1 (David)
 - Bring the inlining to a higher level (David)
 - Pick up David's patch 1 ACK (thank you!)
 - Pick up Luke Yang's Tested-by (thank you!)
 - Add Luke's results and akpmify the Links: a bit (cover letter)
v2:
 - Addressed Sashiko's concerns
 - Picked up Lorenzo's R-b's (thank you!)
 - Squashed patch 1 and 4 into a single one (David)
 - Renamed the softleaf leaf function (David)
 - Dropped controversial noinlines & patch 3 (Lorenzo & David)

v1:
https://lore.kernel.org/linux-mm/20260319183108.1105090-1-pfalcato@suse.de/

Pedro Falcato (2):
  mm/mprotect: move softleaf code out of the main function
  mm/mprotect: special-case small folios when applying write permissions

 mm/mprotect.c | 218 ++++++++++++++++++++++++++++----------------------
 1 file changed, 124 insertions(+), 94 deletions(-)

-- 
2.53.0


