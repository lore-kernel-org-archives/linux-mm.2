Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3204D609B7
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 15:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0288D6B0005; Tue, 16 Dec 2025 10:54:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00A486B0088; Tue, 16 Dec 2025 10:54:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20286B008A; Tue, 16 Dec 2025 10:54:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D24E76B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:54:54 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D4711A0755
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:54:54 +0000 (UTC)
X-FDA: 84225782508.04.C189B3B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id EE3EA20002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:54:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XF7zk5xM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="O0/FeIOs";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XF7zk5xM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="O0/FeIOs";
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765900492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=I5L7elWzllOSIgzBzBlYKvSFsKwnjUR3w+FLumxZHmI=;
	b=7ztaKapt1Wnen/TL/TMgKoNXpvxxnDPBMB3R1QMIxnfb/TjnT1uETYJ5wUfRVNaEYPmhOH
	DhASQp5mGzixUgKsgasWJRcGuyJ9flDVxdZxI+oNVzSVjw/vqlWcEmGXBDj1Tpe6d3KciH
	ElAzE6432pR1/tBeR2g/LjeLGLpVCAc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765900492; a=rsa-sha256;
	cv=none;
	b=md5/9PxyAWEXC73p6s8WNGDPRY4E+7WwHpDXCaUOzs27n5K1Jx3TcIu/6mFvlqx8tNJcOY
	pGgAv6+unqJDehA3vEtm+s2eYqYv94r3WDgMC/RQjuB5kplZnxlepwtEQVonCvffp5/X8J
	hJZ41NFVEPlalYriRx2zzEVDl9300vU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XF7zk5xM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="O0/FeIOs";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XF7zk5xM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="O0/FeIOs";
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1A8F45BD4A;
	Tue, 16 Dec 2025 15:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765900490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=I5L7elWzllOSIgzBzBlYKvSFsKwnjUR3w+FLumxZHmI=;
	b=XF7zk5xMqufcbdc6nj7cUuUjWWUmjKqDjyHVOBl2qciU/+jbXWZsZKuT3t6MWS21WAL9Yi
	uMFLJKE+FHy6voEJEAVwOuh2wunn7GxFR/S9MTOb6v6zlchcrVnGXrPDLxHMQIkZ7/z3Ph
	/ZUdhNO2q5r8geXSu7aAWw8B7UgwXhQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765900490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=I5L7elWzllOSIgzBzBlYKvSFsKwnjUR3w+FLumxZHmI=;
	b=O0/FeIOsO3ZPJoMuuUQSF3VnjQZ0+sEJpQhgCqWzaJXBYG4xKhY/dCFcPUwDmYulAYqsEL
	gk6Uwl4f3lBo1/Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765900490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=I5L7elWzllOSIgzBzBlYKvSFsKwnjUR3w+FLumxZHmI=;
	b=XF7zk5xMqufcbdc6nj7cUuUjWWUmjKqDjyHVOBl2qciU/+jbXWZsZKuT3t6MWS21WAL9Yi
	uMFLJKE+FHy6voEJEAVwOuh2wunn7GxFR/S9MTOb6v6zlchcrVnGXrPDLxHMQIkZ7/z3Ph
	/ZUdhNO2q5r8geXSu7aAWw8B7UgwXhQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765900490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=I5L7elWzllOSIgzBzBlYKvSFsKwnjUR3w+FLumxZHmI=;
	b=O0/FeIOsO3ZPJoMuuUQSF3VnjQZ0+sEJpQhgCqWzaJXBYG4xKhY/dCFcPUwDmYulAYqsEL
	gk6Uwl4f3lBo1/Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EFD4C3EA63;
	Tue, 16 Dec 2025 15:54:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id u5knOsmAQWkSGgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 16 Dec 2025 15:54:49 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH RFC 0/2] tweaks for costly order __GFP_NORETRY reclaim
Date: Tue, 16 Dec 2025 16:54:20 +0100
Message-Id: <20251216-thp-thisnode-tweak-v1-0-0e499d13d2eb@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKyAQWkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDI0Mz3ZKMAiDOLM7LT0nVLSlPTczWTbZMNkpMTjJONDMyVwJqLChKTcu
 sABsarRTk5qwUW1sLAHFRPctpAAAA
X-Change-ID: 20251216-thp-thisnode-tweak-c9c2acb3a627
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, David Rientjes <rientjes@google.com>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Mike Rapoport <rppt@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1092; i=vbabka@suse.cz;
 h=from:subject:message-id; bh=kL9+KpDIWvIBUolkDk+Pi8uorseX2uedd2CBZveMJx0=;
 b=owEBiQF2/pANAwAIAbvgsHXSRYiaAcsmYgBpQYC/76PJHdArRDmHbWkIgUHaSpp3qlMNzWsBl
 yHDGFWp1kCJAU8EAAEIADkWIQR7u8hBFZkjSJZITfG74LB10kWImgUCaUGAvxsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMSwyLDIACgkQu+CwddJFiJqzywgAh7vmhJIt1xMY2RDH7CmN/dJgmDTqR8M
 ufZTT1a3K9bhJprNJVF7v1nET+4OI7gxBN9iLz1AlEXA0aahbkTe1/8HqB9uiVwhGLJQJ5xLtyJ
 9vrkaUqd3C85fMeVVKZCVf8/QvU68b0p9if+Cz/AaOM6kCvqOQzMh7v8DkLaAdR+atRaZVp2+1Y
 NfrwrculbI1ILmqA6LwNarXiEorxRrn3F0uiy8AAGKH+WJ6RnHXCPAAaa4O3Lkto41mF141V2qS
 cFQKg1MJvLL8Ii75Yzf9Ti8c7bCg4Zn804K9r3gXZW6f5w9sxvM4FPxZpdFeZ38lOAwbUT4s3aZ
 pOsMN+axjKA==
X-Developer-Key: i=vbabka@suse.cz; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Stat-Signature: 7uta9netbewbb6hnts6d3g3i5kaejjc8
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EE3EA20002
X-Rspam-User: 
X-HE-Tag: 1765900491-575571
X-HE-Meta: U2FsdGVkX18o7JTaRyIkUll8YZB67PpQ+gcl3TTHOVaMZi691TSpUe/CRaoI24YueUvx30HICseqtJwh8J+VJwR6T7PZ2WYXVW0KpueI/RS2q5Ek9MBS+j47ommZ7Hep5hhObpviSV5yyFAfvKe1Qj2FjXppQ5HIIwVrv0dnCo5i6ALNMxzXg+mAdCHm4iVgd1PYU+hIgJjH0vQxy4dpQrPfpCKNSfSEtxp8W1p1niSVaWfGppg9mH1Ez/4JyqlMb8qSdsWgPsj+OQNqggbaIjYS9J4wq8x1iZye+JJ2y+m6cSYBVhrQ0qlB5tXQyxT/ASKPj/Z2AIis97tFccVg0zNNMpIuCCT3u3p1yrNCWA/Dh/7dHGcXQqt+9+YFiVCCCcmElBaO+Ytx2Czi7NGIErcYNTKqQXYHXPK6VDCySGKz1uqnQNR8VtuuvQlCQPK5w7YuKiazmfHp25xc+CWGrzcQYrhoSVAk8Ws9HXiG+k4qMgJf5b8w6MHvG7HfPQarmkYW50oUnr1p9KNKB9wF0NBoQALxpo932ZWXH0AWXzGJ8XymCG1QA5lynW2H2GHjJ7QqPKZ7oPoj+x1T6EjByeD823qvV1nliJZIudkX0EkkpwmNWhFjNMsG7oMEovolFJ1vakgVa0YX/eadmWNtNH6HA/ikxV40o/OPLZFBS7OD9paGrMVetVHiYXDR/F+uLQnqA9e/UMoZHbTTLa3LVX4rK+dHS5sfrXv0gGOwgxap4mSauQqaCJdZXlsdEfvk3KvikCvC/0qieQTsVBGYaKyGw0BT2wEQEw5rUZWYMUza0oQ8RAIXIeSpKREPS1cGtIXjEuHvqayaeSrSJV/a8hRZuorG4mSaFUU513AQc42x6WYlZ/CQ1TyM9iJ2vlGtWUIqRjaNOPTzM/v9jV8xbfd+Kv8MmHmKdvDgXg4kbkTRpmho3oBZ5H/QYI5Osqx+5nJlWoOubpCY9bu4ni2
 mLVk9LyY
 ReXm7A472A3j29p+9sviEmTqDzBOE8Q6ZCQQAj5waQHuSBfWw/QITEH/EzqTkvi5IfaJmzbYE38EBM4lrwiTqYFsNOqoo4DKDHZ8yCLgrvhBKrZFoOjWC/IoAistrMjheEFbnkXMlmqS/MZPBQmsoXGr52FvtF9ZaBt4Wu9PFxqM/pakYH7opAiG3vPv4QwacJ/TapbtNGvd9OAmcXYLSz4pnEtLXv1FHoM26mRcX5YypTmEra8ov/CZ8I3SeAiFXQmxC+Hl36/Xt4lR/ELR56FT4EpfgZqq7qPtBIhxba/65yYFtB3pdAL8B69y0J35EuKhrFnbg60fyMdGAn+xuC2h96qmkTSPjpe1Cqa2cnQJo01q8WnE+hlifSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is motivated by an excessive reclaim issue we saw in a customer
workload and was associated with THP page faults and an unexpected
zone_reclaim_mode-like behavior that can happen for those.

The first patch is intended as a minimal targeted backportable fix for
the observed issue. I hope I'll be able to confirm it has fixed the
problem, but it might take some time.

The second patch is a more "let's take a step back and rethink what
we're doing here" so it's separate, as it changes a bit the semantics
of __GFP_NORETRY.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
Vlastimil Babka (2):
      mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE THP allocations
      mm, page_alloc: fail costly __GFP_NORETRY allocations faster

 include/linux/gfp_types.h |  2 ++
 mm/page_alloc.c           | 33 +++------------------------------
 2 files changed, 5 insertions(+), 30 deletions(-)
---
base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
change-id: 20251216-thp-thisnode-tweak-c9c2acb3a627

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


