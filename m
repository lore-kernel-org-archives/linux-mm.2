Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94664CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56C6B8E0022; Mon, 15 Sep 2025 09:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51CE78E000C; Mon, 15 Sep 2025 09:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BD888E0022; Mon, 15 Sep 2025 09:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2563B8E000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:55:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EBAF11406DB
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:55:27 +0000 (UTC)
X-FDA: 83891631894.20.33F55A3
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id D933840009
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:55:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qvP7Z5tU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=g6n7DP7i;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qvP7Z5tU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=g6n7DP7i;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757944526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+hlNKe50qtnZa/ThWLJhkBfFNuIcFlBMZPRvxg4XaNI=;
	b=3EtClSySLU8Bt1JIzMXY2jQQx9VsIeY7CAP34lCuUGmYQwoDiZryYFBDRI2DY84/1UALbl
	/7GAJzwVLYdydL6Zwp/wYfqQcqrAKRpKf3Pn4Wrrg1DvVtdWc1ExYdls+vx8WPnPbVbZx7
	KzwxSpaNOXk5CeLEnE4WMEjB0ebOM7k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757944526; a=rsa-sha256;
	cv=none;
	b=b6JC0TnudLl/NWE6IIwsfTv0leYV4SfBOkDs7wrMgjD7+PdzFFGF31DTQvJ7bKbvS4FrGd
	7tJRbcdFbBeOvgV0d5oM4FX5e3QDLxa0IFwqbg1oxekFEVEhfxQoCASONR+C98CSvQcycM
	4ZfSDHU0T/q7B7OUB3Hg0kzlLVU+Cag=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qvP7Z5tU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=g6n7DP7i;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qvP7Z5tU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=g6n7DP7i;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3EE131FB3B;
	Mon, 15 Sep 2025 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757944510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+hlNKe50qtnZa/ThWLJhkBfFNuIcFlBMZPRvxg4XaNI=;
	b=qvP7Z5tUSJIzxrKUfNyp8ekIAjuqPljxl0VOCg19zNaoB4dL1Omx2ve8lpzT01PyjNnR/a
	h6nsR/nMiQjEtBGqTS16xb0tjJvgtkLqiQf9bAnagS4F2xQq+0Si2wyf3PDgT/fhwbpzFl
	fO3FXMXJpQ3CwaEgYYn3ZwHVcvTvEUw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757944510;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+hlNKe50qtnZa/ThWLJhkBfFNuIcFlBMZPRvxg4XaNI=;
	b=g6n7DP7iOfPqsOwY69tuINAVXPLgsQDC9wmn9Ujnhca+gZMxLx2S6Qy2bWtU75ypeMv00G
	uoseyltuEgck1JCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757944510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+hlNKe50qtnZa/ThWLJhkBfFNuIcFlBMZPRvxg4XaNI=;
	b=qvP7Z5tUSJIzxrKUfNyp8ekIAjuqPljxl0VOCg19zNaoB4dL1Omx2ve8lpzT01PyjNnR/a
	h6nsR/nMiQjEtBGqTS16xb0tjJvgtkLqiQf9bAnagS4F2xQq+0Si2wyf3PDgT/fhwbpzFl
	fO3FXMXJpQ3CwaEgYYn3ZwHVcvTvEUw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757944510;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+hlNKe50qtnZa/ThWLJhkBfFNuIcFlBMZPRvxg4XaNI=;
	b=g6n7DP7iOfPqsOwY69tuINAVXPLgsQDC9wmn9Ujnhca+gZMxLx2S6Qy2bWtU75ypeMv00G
	uoseyltuEgck1JCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 284761368D;
	Mon, 15 Sep 2025 13:55:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Sw0tCb4ayGhnVgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 15 Sep 2025 13:55:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v2 0/6] slab: struct slab pointer validation improvements
Date: Mon, 15 Sep 2025 15:55:07 +0200
Message-Id: <20250915-slub-slab-validation-v2-0-314690fc1532@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALsayGgC/4WNTQ6CMBCFr0JmbU1brIor72FY9GeQSQiQDjQq6
 d2tXMDNS76XfO9twBgJGW7VBhETMU1jAX2owPd2fKKgUBi01EY2SgkeVlfCOpHsQMEuRRAST50
 xjZNWBSjqHLGj1z77aAv3xMsU3/tLUr/2z2BSQoqrO1/Q1a4O3tx5ZTz6D7Q55y82cSuDtgAAA
 A==
X-Change-ID: 20250911-slub-slab-validation-0e4f559b0a1d
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Stat-Signature: 8mk4b3a1hc3p7zjqsmqskdnmkfx3bik7
X-Rspamd-Queue-Id: D933840009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757944525-159958
X-HE-Meta: U2FsdGVkX18cIJrY934kastGAuUptym1rs8+Q7bS3JnA7uZqyDM4Kphc4vDPNJjKUCZy3xpFkn7QGWtX2CIfK3SX3Tr7ucrAtlUG3SRBrx3+r6wLBpD0WR61vC8ELJE5YHYLyV140BGx70+sK9la58PJY2zArBUHLf8haA3NaWqHGjTgkENsHRrSaiLzebkEnUllB+PuVJR4QMKu1Vqf7bAt6FCZGpDagmaQ8SEXwlDqo/RC5D088N5bHZH0JWWaLhcl9mEl7rU4C2n4m4+ZxLXFKty70xxSec2vcvouHPKMoVxxfab5wXlLFuXpQvkdwRKeT+jzwn94w50zkAJDHshavCsUu60u/bwr6HYcK4OsLHBGjmrxt3bs6KaMymVniTvqBsJ9dfAxzlf2/pCZ44oPO/lqkBn9JmIK2tz8G0Mitb2TdYeAPvdEnABGXbuRHhOMmPDaQOV7Q6X74BLZ1qW3IWvE3zgBUAFM+NNelagYhE9DMhhuU0nxc3AsbNJs7FNlauzJN5rh01Xekm/yy4xDh8Rc5P1hKaORN9+yFU0kVhDirxfl93dFpuAwBPgq86sxQoXN10JSjpU4vBiUo8zmX1hSVMHeIsWfhm4R7mLRgRcUdN3A2oNVaCcO3EKHzTGuD1NCO4Qm5greCYCEvMnE8ZuD6wEaqJlmhTativ/VaBk9MBF/EtKQRbKXvGvvRBxdlYp5HsTzhnoht7wzf7XDx1FZ8qqgZ/kKcz1suMjf5z0N8qwJKENMngavIwMV2BuBd3T47ZWtqI7IhuCOWyT8cmrUVh3UTdWDqGYpoBWWYfZZ0BxMko0tuYKQJyzSESthCD3cMZvUJizJaIspHSCqI/qGw5jh3cs56/otpElwkP5ahd8qrgF4dOwFmuUvFHn3oj1S+i1lDe8ThiCjRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

See below for v2 changelog. I'm going to apply to slab/for-next

This tries to combine the goals of the first 4 patches from Matthew's
series [1] with points raised during review by Christoph and myself.
Patch 4 from [1] is taken as patch 1 here. In other cases the struct
slab pointer validation is better to move to a place where it can be
performed before touching any of the struct slab fields, rather than
removing it completely.

Further we wrap the validation in a function validate_slab_ptr() and
make the impementation use struct page instead of struct folio to be
compatible with the rest of the series [1]. With further changes towards
memdesc the implementation can change accordingly, if it will still make
sense.

The summary is that we validate pointers from the node partial list when
allocating from it or when validation is triggered from sysfs. When
freeing, we always obtain the slab pointer in a way that the page type
is tested in the process, so we don't need to validate.

Based on:
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=slab/for-6.18/fixes

[1] https://lore.kernel.org/all/20250910115507.1991829-1-willy@infradead.org/

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
Changes in v2:
- Restore remove_partial() in patch 5 (thanks to Harry)
- Add R-b's from Harry
- Change validate_slab_ptr() from static to static inline.
- In patch 5, wrap check added to alloc_single_from_partial() in #ifdef
  SLUB_DEBUG due to using slab_err() (thanks to lkp report).
- Also in patch 5, move validate_slab_ptr() under SLUB_DEBUG as it
  becomes an unused function otherwise and W=1 CC=clang complains
- Verify no warnings/errors at every step with W=1 CC=clang and
  SLUB_DEBUG either enabled or disabled.
- Link to v1: https://patch.msgid.link/20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz

---
Matthew Wilcox (Oracle) (1):
      slab: Remove dead code in free_consistency_checks()

Vlastimil Babka (5):
      slab: wrap debug slab validation in validate_slab_ptr()
      slab: move validate_slab_ptr() from check_slab() to its callers
      slab: move validate_slab_ptr() from alloc_consistency_checks() to its caller
      slab: validate slab before using it in alloc_single_from_partial()
      slab: don't validate slab pointer in free_debug_processing()

 mm/slub.c | 62 ++++++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 22 deletions(-)
---
base-commit: 41534d499e50e23571d6b9960498777d93f817ce
change-id: 20250911-slub-slab-validation-0e4f559b0a1d

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


