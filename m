Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24EBFCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3A38E001D; Mon,  1 Sep 2025 04:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7745D8E0002; Mon,  1 Sep 2025 04:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663008E001D; Mon,  1 Sep 2025 04:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DBA08E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:34:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01177139C58
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:34:32 +0000 (UTC)
X-FDA: 83840020026.05.7CC5711
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8BFA71A0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:34:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fSayuxF+;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756715671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3toB/RDWBVVDFeRbPy4lA3l9ZoYBbJoHVU9tYxeAHRU=;
	b=EYR8ZsuMzgDHNVI3opr01/l87CktjWs18Yrvcd32MLrVWN8m3JFkcZ3biFEfNk3q3knZgE
	7aofzgg/O6bZZZMx52bOZzaYFEiWr9izM4g804yUVrKkEEIMQDykNkZLgMvWpyPr1UioP5
	0LICsxb/S980b7ng3F8Ds5DVzLeZmdE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fSayuxF+;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756715671; a=rsa-sha256;
	cv=none;
	b=ye6LcffqIA+tV5WnpK9sAqbUSpmA6WUQwaHrZC7z49l2/Fa5UjsgDcJ7yWovMO5sGgxp8w
	ciKSpyvvoARuQaVUVurbpaI/FVttuR8FGG+X4HiSro4VgZHslsV5qYUH6IhyOgCq+Z3eOK
	4Gfx4MZeVQQhkPsKU2SDnc62uts/wyk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D708E601DF;
	Mon,  1 Sep 2025 08:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34389C4CEF4;
	Mon,  1 Sep 2025 08:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756715670;
	bh=YniABXTMehUmrQNyxrnxV6TCLO8GP4oi7+6p/ouGAZ4=;
	h=From:To:Cc:Subject:Date:From;
	b=fSayuxF+wbFCiWZEBOUbqBm+UQcn47oEm7NsLj08ek+p9jMmQvyzqYzjypmRmiK15
	 r7F/+n5PoNJbRo2vag6G4CjffX0MWC6AacU1Zj8wOXfmeK7uLCerqcqHD7BJl8nnUZ
	 bSUZh8CJItd8xbAbt069DRXV3+ET6D/dNEDf/y+bJFvXv+IN4LBOglsgIht7e1/MqK
	 El2Mt85kX1XTMz1cUS6M3kngnw7N3fvyVf7SKcxYpuDRLtaUDvk+m7crTBb5j4QsHI
	 mV/LCqvIJxksn0Ohexg/0LNLGYqkJH8bmyIm0dVnytqm0w3SsiKuF47zBnMNk1k0aQ
	 I5TjNUc//phrA==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v2 0/4] mm/mm_init: simplify deferred init of struct pages
Date: Mon,  1 Sep 2025 11:34:19 +0300
Message-ID: <20250901083423.3061349-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 98mbgqmr31bwu9oh9nc44kaks4cugnbf
X-Rspam-User: 
X-Rspamd-Queue-Id: 8BFA71A0008
X-Rspamd-Server: rspam05
X-HE-Tag: 1756715671-732870
X-HE-Meta: U2FsdGVkX18k2l4jzgIWzclc4ICuM2S+oEJlqnMMrV6+ovCA2DXZcnwVWdtdN+xFZ6Dq/l+f25/+vyXGcqAvrVAooTedvIFYZzUYjKi8KhP4KgzHZJTaMQQNjmxsXc7wQt+7wo0RWI/4z8mym4yENud20SNuw7cANF5ffaMUf8NQy/Pm7cENVIqwGHQJqwgk19YdAtYLktPk52akr4hV7iWM5vPsWCZz2sP1wpr5e/GCMj4KEQdTe0vLMhmQokPHxYuctu25t6leVBM6kD1MkC+rFtA44Xnyq93zIcTBnIGI0Nrgse/u+bRvgdutyjpqIGD1vb4y75m70hjubfeQ/9zp25sDMb4Fhlj9+R0qB8wbrTDnfo+QJ5q5+TQJHH2LHpLZ/f33PTnENMayQaUsMj630gvSnNO5yoJqHKwUAgduDaV205djMbSzgWOcP04QGvwEbb5Nek/5rCLyJHAiMo6R/zSWldL0byr3AVDckxJtJcPf2da2u8mFJQIeb34QXnB5UtHSPLiTEr3JK2SHsjGrmGB6p9/siOnbtCcVBksSvBpcq5LLlPqNcv2lq9yu+f86Glvjty1UZubPCWzhiEtgbGbpQAbOCkei0llxsUN4Kk8Lm7Q4CxAak0L6J9nWvNfR/E5EwjS+ujjjeLn8NUK1c9hfhvRWxi5sKFMBCc9fqWe0K2K8ZHn5Hjrk+1PxoTUVecae/ft8a2KbTvyIsO7Mj0HK7wPT6Y09pbpsxazNH+2uFinbVKv1Lm74JTKTT1kf/XRncJyAB8iCn2HoC6LzP0AMGg9WUzdTUVGBLLvw0S0hj7mcCVDG20dMNS9Iv1miI9aBMKCq1hJRDUowCxS5PNooc3JBKetuS+8PMoOJVQZ8YZ6s1JJ5FbFbrmZn/HZBXx8gVlyBxGhj7BbLUrS9bG0PLEVmnn5w7sW2qs16Si6ZK+C+stK78rYS8KaQh0FEOCm+o7pu8GJEi/B
 6/nCS2WB
 fGJj3HHHDnoF+/NnEyOKjv8U6ehac3AgcE61kORyhrA3tB+LFeyuZQfyRtihjz0wxU+3uPI9KcYw6ksUNzhVgknQteqGzgiftefy9CqYAGq7vxQsYflF9eaoTSa+M/wEDVdjL8VgIHYTOCCVu7MwWizS8rvPTS/yCdLojc6lUv66rX8oR8ABWjjIU5rrfqPkgNf8xeiYF+4TZ9dUVQtA3ZUXxKxvwUNBujnWoWYE4QozRr8/jwRKaEe63kIq7r+vseZzWxLoqj2NnxfXw546DlwROIYySYuvanNSDVpVPbWkvaZ0gehRAur9XDk+9InUmaCD+GlXDKFewXgISzE7IHgjSgLr8sUWuy3Yk9l8N41+gOtsr30FkUcdBoGcBvDnQSsrn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

These patches simplify deferred initialization of the memory map.

Beside nice negative diffstat I measured 3ms (55ms vs 58ms) reduction in
the initialization of deferred pages on single node system with 64GiB of
RAM.

I don't have access to large memory machines, so I'd really appreciate
testing of these patches on them to make sure there's no regression there.

v2 changes: 
* fix "sleeping function called from invalid context" bug reported by
kbuild:
https://lore.kernel.org/all/202508251443.f2d9f77f-lkp@intel.com

v1: https://lore.kernel.org/all/20250818064615.505641-1-rppt@kernel.org

I pushed the patches to memblock tree for wider testing.
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git/log/?h=for-next

Mike Rapoport (Microsoft) (4):
  mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()
  mm/mm_init: deferred_init_memmap: use a job per zone
  mm/mm_init: drop deferred_init_maxorder()
  memblock: drop for_each_free_mem_pfn_range_in_zone_from()

 .clang-format            |   1 -
 include/linux/memblock.h |  22 -----
 mm/memblock.c            |  64 -------------
 mm/mm_init.c             | 197 +++++++++++++--------------------------
 4 files changed, 65 insertions(+), 219 deletions(-)


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.50.1


