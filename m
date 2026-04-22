Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1C03F9EDC5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 12:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EEF76B0088; Wed, 22 Apr 2026 08:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19FF36B008A; Wed, 22 Apr 2026 08:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068106B008C; Wed, 22 Apr 2026 08:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E50486B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:37:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9ED4C14016F
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:37:34 +0000 (UTC)
X-FDA: 84686142828.23.427DB11
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7B380140002
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:37:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oVmfbDwp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZIuUUQMj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ipDF8KV6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="we/edbk/";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776861452; a=rsa-sha256;
	cv=none;
	b=kapbxt1JHRuZkTFXyBiT/mFPkISSNPhJlY65ZhJOVXwOslqo25TUgSWN/7Ey0wOg7CmTH3
	P4s0Wgvj7XSbDfBiNM4gOaYAaBXFhp/lsnPFU4LHCcB3P4LKj0f7dMC+d6NAQ1JC6SQkhc
	bzoP0HKp5TM1GPPZOfFH4nGONPwpwv4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oVmfbDwp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZIuUUQMj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ipDF8KV6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="we/edbk/";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776861452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qXcWnkwGhj3F6eVeE5nf5juso1cNhhr6OWW3qzReMLo=;
	b=GtSNV1I+4eglc+FvXaLDUs7KUviwDV5SPAP5rM0FVfgFe6LsO/coh2kvpTLKKzycOAESiB
	I3TbdBWKFmqYoaUM3JkiZqdghSXVTSR+ffqgSxR5Oephc7gCdvY1nS5juai7rL33rd1rFt
	16WGw0boCcEnusuPzuJpWpzmfx6bYag=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF4FF5BD8E;
	Wed, 22 Apr 2026 12:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776861451; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=qXcWnkwGhj3F6eVeE5nf5juso1cNhhr6OWW3qzReMLo=;
	b=oVmfbDwpjA5q/PtMH1HnHFzLk3fUfoC9rmKRE5ucjnW4LXkcTwK55yyxqycwtju5o/q6uo
	rVyXUvktk1sEkTQCQS2cpASAE472Wg24qBAgZvbks77y993rzivcMVjt3Yo+uWY6fwC+xD
	8jBl+GqDZHpcOhJVo/p+zfcUYjo5hdg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776861451;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=qXcWnkwGhj3F6eVeE5nf5juso1cNhhr6OWW3qzReMLo=;
	b=ZIuUUQMjQCQrIwEsIwqQbNQMXlpW+/xiPZmn2DOIY/7KDOoIsoGUH9vuSnxrjTdhY3E0bn
	m/htvLAFFjuVliDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776861450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=qXcWnkwGhj3F6eVeE5nf5juso1cNhhr6OWW3qzReMLo=;
	b=ipDF8KV6d1cC4u3JN5pJuQN2NsB7DxlWOScrDdPpNQ2r1Hz7Nas5hRHEVFSHxWtsYq10fd
	KDQw1WkGnislqz4C07xU5PHmnj/Tf5zlSmYtzSlj7e8tRuR4GlIrz3p0EksK4ycIuLrgZL
	hlsElpiFAF14YjOfJ8sLUbOYGZAGn3w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776861450;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=qXcWnkwGhj3F6eVeE5nf5juso1cNhhr6OWW3qzReMLo=;
	b=we/edbk///90SFVwqGvTuJUYRlnbl/omHeOWnldVDm58cqdtRDzJnYPXYb3JqGbpKQq4W5
	l1a1UR4ns4nAn0Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 23945593AF;
	Wed, 22 Apr 2026 12:37:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yHlPBQrB6GmncwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 22 Apr 2026 12:37:30 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH] MAINTAINERS: fix regex pattern in CORE MM category
Date: Wed, 22 Apr 2026 13:37:26 +0100
Message-ID: <20260422123726.517220-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7B380140002
X-Rspamd-Server: rspam12
X-Stat-Signature: f1dquszfjqz6h64gzwn1my1uhg7te37h
X-Rspam-User: 
X-HE-Tag: 1776861452-555896
X-HE-Meta: U2FsdGVkX186JuLPDruKDc5YIWPM8nzPQYimD2qWp1DOC06h6aLbg+hB3ILdHDhO5bvbFQNf2C7sVDOr67gfEs/yHuZnLLlupP6K1PKufpUUDThxxBQdLRwodEilZ6pD26n7PT5Al10ZjhlOKNzu7jo0h4l7dKYUrVAiSBcZeFnpqwTL9Pfm+HKflzTskwqHX+7CtdnAnWOQEQOhidYEFRgJz+TMzBepEFVUF92KwyGzb0QKFpIcCVDGl0bVKWAQxQfMwDQ+3yFmqXdATWsjVoGHwCyiGHubKSIxG2GWJmE84wUg5Yj6otxfPYp/jpC0KGfDsBgvvxittJUBFDAoTWn04tVHC7WHQiB3QmILqk7ViT4DrxyG69N6OctEtMdprmPQ42Qoh3gd6TVxnCqXEAAPZ2pVqLJsL6BvcQO4ZVcLJnu151yoW/gnhp7cpc4xUBVU2uFXYs+3B2g8kA6dtyGZ96KqPti1zwiaoM0Q0V739+qR7pJ93sat54XswEU+KQXDhkHu9aUR0EP9loVCSzso9UUFbXFsCZoNkhclpt8WcKl8eNnKb0PhfaLGpTwFSWQhYud34Cho6qfiV0VVITPopv/c50S16vbeS+w4WG4BXOMehJRhbAhMUH4oL/CKUVoXaoUhtDfw4BHSscsHxflzAD9SiK5civno/8bhpdr6KziMl2n3OAsjaPkbrQoMnSCrO+ZYQpA9d2q7jbIYy2+YefRBo4JOKp4pjQ40i76nOnPrv7X/Lkk3s+45+IHbkRfhapofFg74mkdPhJL4eo9Vbmo3DqFeRK3i+tDhfLTtZMwWVE4THtXv/GYmVjmPe3RENyJN141QnlG2GPilpNOm1qJIfpR3loZ8R24wD/c/MnA792pfSvqjGKdVW/iY8huiP7W24KAGVRxoqI2xFozi5y6RPFVIjXuwdayOTtjpK6Q9XrqnCJDF6P78PvN1XLmn573H64yj8Tbu/W1
 ds1PHQVa
 7xy5EJZa46G7PZO8dHoJ9ZbAxhHFs8lBZjBHm0eTp4NjvrJnYZhQgcAldCPIrQ3m1bhcl0KmvahHgf7sQyvZG9/+pQFKovbblF7pNNLaiHOu9dn4OylD2hNd/+XI7G/JE37wz7Sq3CfJoAqk8uB/K1GA36eud7czhrNqnr0s8+rPGrgHvxDh5UtRNNyQXB/MlCx2rYOdWQYZv4qUSad2KI9n5lkvskjM/vrbdJTGW/DF+Sc24KXCIaegFh0HFafhb9GdONU/GTION2jkCXP8ChGIk4gBqFJGHJHgFZ7/tD4hsVnXOGKeefMTc6zXDA5WZ/S18lU2J+A07MTyxhG/00Pwy6EIc/rswS4UaEZGFUMcOkjE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pattern "include/linux/page[-_]*" matches every file that starts with
"page", because it's a regex and not a glob (so it has the meaning of
include/linux/page + match [-_] 0+ times).

Fix it up into a more regex-correct expression. Doing so reduces CC's
drastically in patches that touch pagemap.h (which is maintained as part of
PAGE CACHE).

As a side-effect, move linux/pageblock-flags.h explicitly under PAGE
ALLOCATOR.

Link: https://lore.kernel.org/linux-mm/20260422005608.342028-1-fmayle@google.com/
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d25342ca8aa1..224c15299acc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16804,7 +16804,7 @@ F:	mm/sparse.c
 F:	mm/util.c
 F:	mm/vmpressure.c
 F:	mm/vmstat.c
-N:	include/linux/page[-_]*
+N:	include\/linux\/page[-_][a-zA-Z]*
 
 MEMORY MANAGEMENT - EXECMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -16961,6 +16961,7 @@ S:	Maintained
 F:	include/linux/compaction.h
 F:	include/linux/gfp.h
 F:	include/linux/page-isolation.h
+F:	include/linux/pageblock-flags.h
 F:	mm/compaction.c
 F:	mm/debug_page_alloc.c
 F:	mm/debug_page_ref.c
-- 
2.53.0


