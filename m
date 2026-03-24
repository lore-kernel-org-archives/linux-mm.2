Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C06D0F54AD0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314616B0088; Tue, 24 Mar 2026 11:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C57F6B0089; Tue, 24 Mar 2026 11:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3DA6B008A; Tue, 24 Mar 2026 11:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 093926B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:43:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8BD71B71E6
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:43:58 +0000 (UTC)
X-FDA: 84581377356.13.174233D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6845EC0008
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:43:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bW8IdZEm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZrthvwxJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bW8IdZEm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZrthvwxJ;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774367036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xKf0tFZ8m3RzqmDEZLBOwfFpYbl6YfWlvEft7j5ZCD4=;
	b=b0fHAdfROoV2/KXiPJXK02fxenVsjj7PzvxYnlaZLTymhUOOQRxwtuNs1U6jct8KGWk6rF
	Aiq0wiiMH+zu4E6TyFUxDkbqcfE0kT7B1eU0n372lIL+4usz29VsaPKz4u6711u0wkvsEt
	CnAakk7ECJrb7bobJ4pwyoybt0qn/4U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774367036; a=rsa-sha256;
	cv=none;
	b=mXDWJ0NlTrF9aVtGp6qaJappaflBgZ2ftaEF1VGyeqCd9n060220W6QhLEWiH2lTObgmLt
	rs9yngoPg4OKG+13BBO6oy1VfNfvAvHKEwWvtk/fHeki61cxAWAQa8zDNvahp5gs9M6L50
	bK00pawnRssxIkuJd014eAm3nBUYPkw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bW8IdZEm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZrthvwxJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bW8IdZEm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZrthvwxJ;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5B25B5BD47;
	Tue, 24 Mar 2026 15:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774367034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=xKf0tFZ8m3RzqmDEZLBOwfFpYbl6YfWlvEft7j5ZCD4=;
	b=bW8IdZEmAZm9qHpTj+bzSvwiRXvmbs6ZMHwfxNS2vRQgPbaIBrenmu/NWCFdBFIPZgKasn
	qmp+dXeZLThvDaoi459H0HtOpGa+NCbmmWSeEP5IewluHORdiEa0KFT6XZ0m2yigzLvawh
	DfQnQZ/3XF18lbKryq5ZI7q5aDDzLUU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774367034;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=xKf0tFZ8m3RzqmDEZLBOwfFpYbl6YfWlvEft7j5ZCD4=;
	b=ZrthvwxJOPYDUm4ikbaOrMth0kzJvDc24rtMeohRAqUXAz4/P1KNdEWdN1sf3jxA6Kn9xA
	LQb5nWSjM0sLn0Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774367034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=xKf0tFZ8m3RzqmDEZLBOwfFpYbl6YfWlvEft7j5ZCD4=;
	b=bW8IdZEmAZm9qHpTj+bzSvwiRXvmbs6ZMHwfxNS2vRQgPbaIBrenmu/NWCFdBFIPZgKasn
	qmp+dXeZLThvDaoi459H0HtOpGa+NCbmmWSeEP5IewluHORdiEa0KFT6XZ0m2yigzLvawh
	DfQnQZ/3XF18lbKryq5ZI7q5aDDzLUU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774367034;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=xKf0tFZ8m3RzqmDEZLBOwfFpYbl6YfWlvEft7j5ZCD4=;
	b=ZrthvwxJOPYDUm4ikbaOrMth0kzJvDc24rtMeohRAqUXAz4/P1KNdEWdN1sf3jxA6Kn9xA
	LQb5nWSjM0sLn0Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8252243EF5;
	Tue, 24 Mar 2026 15:43:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dHF2HDmxwmnUNgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 24 Mar 2026 15:43:53 +0000
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
Subject: [PATCH v2 0/2] mm/mprotect: micro-optimization work
Date: Tue, 24 Mar 2026 15:43:40 +0000
Message-ID: <20260324154342.156640-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Stat-Signature: tskudn7ewyeewkoufj7499rixtmay9ry
X-Rspamd-Queue-Id: 6845EC0008
X-Rspam-User: 
X-HE-Tag: 1774367036-343966
X-HE-Meta: U2FsdGVkX18IP4eI2odzE8f5sAQMAG19uQAbyacJf4wyPMVd5Wa0/HOu3mME/E0qobv8m3topcc4iQM+I5Ve+7gJyeIxtTd145jmpPQ6YkmxfI65M31gaT1x6Bd1UdZ3iw+gYZEtUnKpNpe+/ica2nD4sffvhiwcxyMtilW26FAiUjpYUTM3/zc/DdwAvsiTQk+LYpL0OCkk72+H/R1u+oIT/1paoRE/jrrBWQ8dGjvh3FchD8f+8xs7tvr2et6mBrCWIZBMEsdqqIAbHX48z0sR1EI3bIStc4WcxN2Qkncj6m8uPUeIy5h9q3F2GkJhZnX6FZt2Ps6aGkDmE592kf7lA43e+J/KN/ubUSEV4LAKeETHonHcqrcsEvFTNzvI7QDYWajy4qTKXpY3ApINd3zAGN9SkQ2JTMluoHs7GhJpGfG7Dj9W6ovVNHmxaab5mLfJU91esNPDYq3KZWM0jL5CgTJVAEtW2ZQ9NyjKCPU38SUvAEP1aRqAi72wrMaG1ExrpQNtcq+mm4f/7bh8gZfYtK1JEK7XctC56rybaxrlKPC3VmLoGbHcCTG4/8YWtSYJ1AniRsevit4y3hRCz02m5MU5t4Fhom7DVs6Dlh4MPfn2jqimq9EGdnMACyxEk3y5V+SGiKB8FWDSTiSBtUpj03hi7RIf31plmju1G4ouGoT6cr3X4UTp6fFWrh9/t19qurVmIQTNsd+6qjhXlSzrQaTf5XgoJmsrVQjA2nYJhY84Qd7/KuoUvbM97i56vqAnH87XHkAcyiRsv37N6SmyQsU+tZsIxasVGSkMGfGQ2xARhLehhGEEGBvGGYBzh6ebcNPqPc0Ljg33FGSy6qn2BWKgKCT5UuRwAZXskc+aAU8t9FSH7FzGcJj3XiB+tqqozkUespNApuaOftLtofklKt9P35wyCk7hqiUwE4wAIuF7XPzXyUVdO7krJLlPUOyk3hXDFZp2BSQ+67h
 Gft1cvrh
 gV8acysBxo0J6yhq+Oyx0UhTtrOrLdXVypIM0kVMhdkNXQarrPo1KGyp+89tqbN3lUq4XHDP+2lPrph/BYcHHjlD07NudBGG/rQ04eEe4z9iQFXdMbJkz657pFHKpM+T8gQEqPEOwF8pllxBKydwcQMfJw/xpW1Ki4+9u5F616UXSfUhkKiTykFaZN8kg6fxWWQy7Xlxy/mAzJSrZ0uoj2bCElgZbmkKaW5gu7sOYGcxkm8CZJ6krDDlYJAfHEEdF9Bn1XfnW4yoYZwv/uKTrwrzq5+cduYe9yGI/7K62K/mNfmKeC5fQhRqyAi+oH+6bA5gLTar4UfZS88iI83nhHbI78fVWVQPsqzeA40S6jQZJ5n3bOn8nKFapoybYNqa8zP+cRxIgNQQ1Dylrvu3cKWSRo02bgT92/dvDLPyo1uMNMVKdjOuFVj8whsfb8qA6A+qgA08UP2nHAb66GivFVOnN8YXlcb4QR2xR/qNE9XNqV03AQv3oIEEdXA==
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
mprotect_bench      73374 ns        73373 ns         9602


After the patchset we can observe a 14% speedup in mprotect. Wonderful
for the elusive mprotect-based workloads!

Testing & more ideas welcome. I suspect there is plenty of improvement possible
but it would require more time than what I have on my hands right now. The
entire inlined function (which inlines into change_protection()) is gigantic
- I'm not surprised this is so finnicky.

Note: per my profiling, the next _big_ bottleneck here is modify_prot_start_ptes,
exactly on the xchg() done by x86. ptep_get_and_clear() is _expensive_. I don't think
there's a properly safe way to go about it since we do depend on the D bit
quite a lot. This might not be such an issue on other architectures.


[0]: https://gist.github.com/heatd/1450d273005aba91fa5744f44dfcd933
Link: https://lore.kernel.org/all/aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb/

Cc: Vlastimil Babka <vbabka@kernel.org> 
Cc: Jann Horn <jannh@google.com> 
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com> 
Cc: Luke Yang <luyang@redhat.com>
Cc: jhladky@redhat.com
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

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

 mm/mprotect.c | 146 ++++++++++++++++++++++++++++----------------------
 1 file changed, 81 insertions(+), 65 deletions(-)

-- 
2.53.0


