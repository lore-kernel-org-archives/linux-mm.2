Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AA71CDC165
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EA976B0093; Tue,  6 Jan 2026 06:52:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C86B6B0098; Tue,  6 Jan 2026 06:52:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D54D6B00A7; Tue,  6 Jan 2026 06:52:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D28D6B0093
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:52:45 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C9231A04D0
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:52:45 +0000 (UTC)
X-FDA: 84301377090.11.B5B0ACC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9BD4340002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:52:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DQBl2eeu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9j8uBiXa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uYmvT4y3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WTw07Xrb;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767700363; a=rsa-sha256;
	cv=none;
	b=jC/FdRR2Hf8m6dM9Hml5fP7nQiJMZ8Vt2vz9ejFK4kJ4ZB0a8sBbodmN7AvkR8y7N2E6nu
	Uat3pijYYa4jvK2miFQCJTrrKBYLNBqr8u6SQ2IexBx8eRb60Ndoi1YCKMlWyTQDZWA0EO
	Twnho1pdwFCe3p6Rhm/7PdR5WW1m0lk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DQBl2eeu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9j8uBiXa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uYmvT4y3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WTw07Xrb;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767700363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8Pzqm7yBJpos/p0nM9CIYaPav19Caa+xAkFLOqfFMYo=;
	b=jNW2Y0Iit1TvzpBm6T0DeowW/MfrqnTM3Bgtsve8i9JeSfKlOX4ajjyGRI5ONwzyikaF9r
	vW1ZoxVuLnZVoKmz/UzsxKmiU7I5fbMl4PyWO2hqlcO3i49KVa5kFI1fnItMlbrMon6+Fv
	okelUTuwd753/7lYgYcIIk16mYjthCg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E8D11339E5;
	Tue,  6 Jan 2026 11:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767700361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8Pzqm7yBJpos/p0nM9CIYaPav19Caa+xAkFLOqfFMYo=;
	b=DQBl2eeuz8nYG+pjXwamht0RieJAdzQM2aA0Osf1Y/yEQYPZwWdO4sp53K8NLQDM3WqS/M
	yrh8BdVTwgOXepovhk/4nJnZRkWuOK4Of2gwPKVZ2ChTkNYLUSLDhBMUAtf/eLhVqf/Ahb
	aVEJChyPIkehy2TXOE39V5bvWCwryjc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767700361;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8Pzqm7yBJpos/p0nM9CIYaPav19Caa+xAkFLOqfFMYo=;
	b=9j8uBiXaj6ZUS6TcJ2Dz0l+FICiIE+dRrNFJsygAmqyd7dfcPqQgWqtg2biZP/IGSt1r+I
	u+HSxAeEvdYVO3Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767700360; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8Pzqm7yBJpos/p0nM9CIYaPav19Caa+xAkFLOqfFMYo=;
	b=uYmvT4y3sQTY5Zv2bOQGv8lSK4HzoUGDmUITF5HzFZZTaUdNzZun1tu/vZ4anGITtp4S3n
	93EXtxIMDNmPNi22K3mwV02gaWlEgB4jsLLvtacdqEBaXemv5kVZjsEkoCjG3owaBSPPTG
	TwGkkoDlvCfh553AbF0orEObX4Q+TdI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767700360;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8Pzqm7yBJpos/p0nM9CIYaPav19Caa+xAkFLOqfFMYo=;
	b=WTw07XrbnshBRRIKcbykeLCNrhFYOsQnzN+YAvHKCajamUfqf+bjn+m76C8MY52+Lp55CZ
	C1LFcwJ5IRfp/BDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CA7953EA63;
	Tue,  6 Jan 2026 11:52:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xoUeMYj3XGnsZwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 06 Jan 2026 11:52:40 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH mm-unstable v3 0/3] tweaks for __alloc_pages_slowpath()
Date: Tue, 06 Jan 2026 12:52:35 +0100
Message-Id: <20260106-thp-thisnode-tweak-v3-0-f5d67c21a193@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIP3XGkC/33NTQ7CIBAF4Ks0rMXAoDW48h7GBYWpJVraAMWfp
 ncX2ejCuJjFy8z7ZiYBvcVA9tVMPCYb7OByEKuK6E65M1JrcibAYMuB1zR2Yx4b3GCQxhuqC9V
 Sg9KNUDXsSC6OHlt7L+iR9D2dXIiquSI55WWuxsE/ysPEy8k/O3HKKMONlIYLA9gcwhRwrZ8FS
 /ANyJ8AvAHNeAuCt4brD7AsywuJcn5gAAEAAA==
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
X-Rspamd-Queue-Id: 9BD4340002
X-Rspamd-Server: rspam03
X-Stat-Signature: f4ena5dqnkuf3e17za3hkjj7w1mzrxcu
X-Rspam-User: 
X-HE-Tag: 1767700362-113856
X-HE-Meta: U2FsdGVkX19QbeHYu889OXZzSo9/HZqY1Lzt5qY1ugu9nuylapS+aAaUsr27lrmk0+WCBJZ7UtRCPSD+G1Q9p+bekYbN53ZKepliFKkMQ8MjbobJLUfvMTBV+t4oFuXHWe89Kl3+T8i6iD1tMhg0iRrDbPzTtDb3UWIKY9/8TYNPee0MgwLqfuizKrX/ZuB0Sr/2VJmwhmx2EZ5Ztp0R1MpLzvgn3t/3tkGVA1XMUDUkcuI/8TbXa9Soq8l3YOzBCzlvZqqNjNpDrJTg/oYnyhA8mFwJN1PkOc+40RtAyfgBcphlJjwp7N8nzUc/3/fnQ8lp4dO8/rUi2oUBaQqVO4aoYneE/TjyVVb+8R/Rpik5tTBF5EYmcPRE8eV3TwX6/epUTJMyGwfQWCUqQbS/aLZBdl6Vz3YpyCuX0VeCJwDDMigYOGC/8zjxlqBBNieHCoQDAUEE83prMxipfqoQS9G3Y+iJ4aCudZifcpSPz3LtQl5AsbgJuQrj4EdMbSF+k1nDvF07WO1RClOrZAl97ppNY7WOUiO3F0hY5khuzosdGQr+a5n6z5YMYso24RUR3Q8tAu9Y4bt/u6swIbkNUxiEdjJKM27VDPwWCU6Iv9VTo+gEI6b7taBFzyl/NnWSFIa+GVyG2filOzD+V7Xy7gd7b6L8rphOabbgZ/DAAys6AGnFIgOELmuqFAJkOBr5FA8/jLffYSjWDdcc9ZbwhNbogHluX+v8HCobtjS4yKP/O0eL7DhO6dS3qEb1DHGuAqx7n8ghd5oiO4AuOzJyO36s1QZDSLQm4Aa+dF9bjBOwZZI4vl2Gzsv01bvNT5+S6UkAMDD2BMtpdJpwD6ZI/BVBBYAqUSrZnsiApREij6pczlWj0VgDM0v3Nw6Bgn2D9GQ740NEcNDXofvgPSMaYi+Y+Ca9dJkw8N4/wigD9ftMQp6Y+wqmpJAGpOryxBF/YTk5kuNZhaiE+RM8n01
 k7ASNklr
 sjUwvtZEw2c2S1pFUoyxLbbVVHRFgFAbEYhhcFWzG8BJbbuuUurJWpW7gHU+msCb/+yHvvwNk+3fNeCXlR95dhwpjB22DgP038w86ZBgY+7ZfyJytglWp1Wy0K79jXd6/llfx5Ux354VNkAfU1Kud01tXK49l6DwyLDbHP4vlDMdgJfAIdGm+dhvZQEStMJEQojtap08wdQa9FQRQaD7PRiRBxIkf7mQmWNVS8L5xr7xrZ7YrXAOdvkX8wcalu9ZrF8Gj37ocTXf39ZggBOXHVfsA1t4bTHldcgRmmI7PdwcYf2pKOArHE8b+ZY2Z/nFZ8UKBtzVea425WZpH+taeMyKh9q2TPxO1FiREWS3Fyzm92c3FIxFmtyL2LegK+2lS15CMO9fa/Ay6Itihvrb2oq5Oaizr8+u53jH/X5zaWqbTuEjQ2Bst1Shnq92nU6L4pr3W/cpHB+61NBSpPjPg3NCmZkceHRbxhqhF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

First non-RFC of the page allocator cleanups on top of the THP
allocation fix:

https://lore.kernel.org/all/20251219-costly-noretry-thisnode-fix-v1-1-e1085a4a0c34@suse.cz/

Rebased to mm-unstable where the fix is included now.

In patch 1, in v1 (where it was patch 2) I have proposed not to attempt
reclaim for costly __GFP_NORETRY allocations at all. Johannes suggested
that we should not change the semantics that much, so now instead we
allow them all (except with __GFP_THISNODE). The main idea that remains
is that we don't decide based on the exact compaction result anymore.

Patch 2 is a cleanup also based on a suggestion from Johannes, and Patch
3 became the obvious next step in that direction. These should be making
no functional changes, while simplifying __alloc_pages_slowpath().

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
Changes in v3:
- Remove RFC tag, rebase to mm-unstable.
- Remove gfp_thisnode_noretry() in Patch 2 (per Joshua).
- Instead add gfp_has_flags() to shorten checking for multiple flags.
- Link to v2: https://patch.msgid.link/20251219-thp-thisnode-tweak-v2-0-0c01f231fd1c@suse.cz

Changes in v2:
- actual THP reclaim fix sent separately
- allow one reclaim attempt for __GFP_NORETRY allocations
- further __alloc_pages_slowpath() cleanups
- Link to v1: https://patch.msgid.link/20251216-thp-thisnode-tweak-v1-0-0e499d13d2eb@suse.cz

---
Vlastimil Babka (3):
      mm/page_alloc: ignore the exact initial compaction result
      mm/page_alloc: refactor the initial compaction handling
      mm/page_alloc: simplify __alloc_pages_slowpath() flow

 include/linux/gfp.h |   8 ++-
 mm/page_alloc.c     | 163 +++++++++++++++++++++++-----------------------------
 2 files changed, 78 insertions(+), 93 deletions(-)
---
base-commit: 186f32b9f92ad7ef6bb90d1d0e9692665cfbb69b
change-id: 20251216-thp-thisnode-tweak-c9c2acb3a627

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


