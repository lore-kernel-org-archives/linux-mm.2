Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBF3DD7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 17:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2EB6B00A8; Fri, 19 Dec 2025 12:38:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3962B6B00A9; Fri, 19 Dec 2025 12:38:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2571D6B00AC; Fri, 19 Dec 2025 12:38:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 102B46B00A9
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:38:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1D3E160272
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:38:56 +0000 (UTC)
X-FDA: 84236931072.22.F71C73E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6CAFE1C000F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:38:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=U9iFsI83;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JRFUhRwT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=U9iFsI83;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JRFUhRwT;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766165934; a=rsa-sha256;
	cv=none;
	b=AQ/taGaDQ/2XRhbT4t9yR5iHLEMBGhHwgzAqxmd/+BBfbews2vu3HpzDmXCN91nNbmrkg1
	uGDI+VyL4EAUhEV6mAa4d43WyznMcgGlypAHk4WBlrPlEevfHUTT81s0WVCHzJwtNLzs6F
	tsLha8uVBB1LvXNVPdU5hdLJfHQGu78=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=U9iFsI83;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JRFUhRwT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=U9iFsI83;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JRFUhRwT;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766165934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VGvFR7VRtSBd6YuWyK7fF4KvZ/6HteMl6uD6VpFe+m8=;
	b=4dwM2pzvj1PZPU5o/D87KO2J8URlIZhszfAqjJQY4bkUJPO+M5/Y6HSNjEEAKLMuj56Vjy
	b7PflHznWLHyAjD3k/pWF2mvszDq+OYNkPYI7XFIBkxvFQvKXNT+WFGweTqn8VrDvr/fow
	07i4pVIz581LP5GlYfpbBE6rfXN93/4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 945EA336FB;
	Fri, 19 Dec 2025 17:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766165932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VGvFR7VRtSBd6YuWyK7fF4KvZ/6HteMl6uD6VpFe+m8=;
	b=U9iFsI833t/QXgfqB0Fzc6z/4gBTEcDkzjQ5NkZcbyv5oH6XQ3S77zyAmbJW2vSNS/3Lo8
	07Lt/LWUq498CxXM4qxFui13r1ycTnuklukU1M0WMxRiMsx8H2vyW30rNNcmIa4sq5Nnmx
	E9mH49yF3UOW/hoFOg6GJ+ZnqJlXjgA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766165932;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VGvFR7VRtSBd6YuWyK7fF4KvZ/6HteMl6uD6VpFe+m8=;
	b=JRFUhRwTcZ9lSk1p7plbtnZZnSuVUwDe2zJ7smD0Dp4xQ21aupNuQacUxGKG9m/7Kio6I5
	Ahv1BHrLZVWoElCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766165932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VGvFR7VRtSBd6YuWyK7fF4KvZ/6HteMl6uD6VpFe+m8=;
	b=U9iFsI833t/QXgfqB0Fzc6z/4gBTEcDkzjQ5NkZcbyv5oH6XQ3S77zyAmbJW2vSNS/3Lo8
	07Lt/LWUq498CxXM4qxFui13r1ycTnuklukU1M0WMxRiMsx8H2vyW30rNNcmIa4sq5Nnmx
	E9mH49yF3UOW/hoFOg6GJ+ZnqJlXjgA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766165932;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VGvFR7VRtSBd6YuWyK7fF4KvZ/6HteMl6uD6VpFe+m8=;
	b=JRFUhRwTcZ9lSk1p7plbtnZZnSuVUwDe2zJ7smD0Dp4xQ21aupNuQacUxGKG9m/7Kio6I5
	Ahv1BHrLZVWoElCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 73A833EA63;
	Fri, 19 Dec 2025 17:38:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5DXnG6yNRWlTYAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 19 Dec 2025 17:38:52 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH RFC v2 0/3] tweaks for __alloc_pages_slowpath()
Date: Fri, 19 Dec 2025 18:38:50 +0100
Message-Id: <20251219-thp-thisnode-tweak-v2-0-0c01f231fd1c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKqNRWkC/32NTQ7CIBSEr9K8tRh41Zq6amLiAdyaLig8LTGBB
 hB/Gu4u4QAuZvHNZGZWCOQNBTg2K3hKJhhnC+CmATVLeydmdGFAjnuBomNxXopMsE4Tiy+SD6Z
 6hVJNrezwAKW4eLqZdx29wuV8grGYpRKd/9SjJGr0bzMJxhmnXd9r0WqkaQjPQFv1hTHn/APIn
 +UNtwAAAA==
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6CAFE1C000F
X-Stat-Signature: 7ropin7id8569nu7yab9dh9se5j3dq1i
X-Rspam-User: 
X-HE-Tag: 1766165934-23398
X-HE-Meta: U2FsdGVkX19//cSCTn6vWz/s/bAaUroeg5Fhta2gMADhX8R0Yy26Xgpq+Tne9SwGOvlQOHfCNSjs0sVG7P7YNIhv9Scy/97hwnKpwLb1Vm9AxRIA1m+uVhS6CCwcK/INvNtQ8zSqMixdozeUDNq+vxh+wnu2i4X5zygVO1ycZNjdVVw68FfzYdUtDPCaj3FJv5KANHR2ZLsJByHfmECsxdmwNNuHFMN5yRJGpkk07P5+8usbC2CQoCvX3hTqBOWQ/53aN565Qr8jDSCEQ7jtAUSZfspKldj57U9wY9X13Z41PqOzby343ByVsr1WjaDcOOg3QhvMOqDida2ziYLfLEKoPPjx27Y0dw0EDWjrfv74HrOJcFrAOqPX/dxjptu8QVcjkyD+Y25/cENlpulVKXWeEP3kivi6exzsWgIkKlFgvIB0P9xX+qOHn/qsiif0PMfu1sD6GcyfE1pFGwZhUiiy28aVLqHp5zRSsSH1tutKUMzo+Abw2aeaTL9Uguk7ZqwJuHhTLWDvr8cg/nV0RNhwzPiySYMp2nEqyaKrGrClpAE8ahn7MtSFe3Y31xMjMQO94YvnK0Bgt2d567og82vXVWscWir35oZj2C1rY864QQRgwu6e38+k20T9bsJh43FIAeGKJ9mn82aoot54BAGPmU8VINYbn4y8dcqTN+erM5uDnzsZhAMejhXBCo2bx2KuDYs5wN/ikPsnXTSFkm0kBtXz7KgAc7inSVn26RdATC5q6Pv+LvK/F6U9Aoo6WqR+Oufn5dhD2ZbU6ued6DbqewWcB3O0nPRMU1vKrudrm1hTeLI7eDgWDwkgg3ThMLqJsav12OBliFjpnZ28/9HntUhfmiG1ovPdQTplg7M6mJyWDDEL6syeOGptyDX5ktFxk4JZvikmRmnTdSHU9x+mlQ8IY1tlTkOmtV0aO7APqZgvRFCvJ4fmSZ/kfsC3JHsquNdNYWN0h7Kk9Tq
 Pfozg49U
 8V3PqiZPRU8L/R5SNgCFriaZs5kqpdHN3Z4E1D6xWmSD7RENdKpbwxC9GiDC/SuGAPgspwkNsCAHr0yuBSBRa4ogkNhoOdamXknMQfCBlvxxbjn8Y2zPSWec8265WWj+yTRJjLQTeuWBHHfB3hP9VBuHPEHIf9Ll1gI4+X8OmC+HZu4lFOJNWntfcnx/1wG8uenlvz7mH3Bef6FMwOWE5XQzaHobsHCcupVQT6UPpfx+WNrAicbAXtcYDdLnboAWLERl1U9TO9YwEMioD/v2BZABVgvjjn0kEviIDG8oxkVWomZrGLlgljBvL6mYdjZLS/Tf1e17F4nglQndrEb/r5+8qStB8WD8seCGofJSURxIvHOVhPf27STwDvW0KpAv9mwLwFsoN1s/gicSc14v4/wrJdI5rGjS3oGrY//K8SKMOvQRujxtfezBw3vZ6KyW3/bD7r/pZbVx0pOTY9pi+NaMDXCqP0W5Vbrud
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RFC, feel free to ignore until next year... Sending just in case
some feedback will materialize.

Since v1 the main motivating fix (patch 1 of v1) was sent separately:
https://lore.kernel.org/all/20251219-costly-noretry-thisnode-fix-v1-1-e1085a4a0c34@suse.cz/

In patch 2 of v1 I have proposed not to attempt reclaim for costly
__GFP_NORETRY allocations at all. Johannes suggested that we should not
change the semantics that much, so now instead we allow them all (except
with __GFP_THISNODE). The main idea that remains is that we don't decide
based on the exact compaction result anymore.

Patch 3 is a cleanup also based on a suggestion from Johannes, and Patch
4 became the obvious next step in that direction. These should be making
no functional changes.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
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

 mm/page_alloc.c | 169 ++++++++++++++++++++++++++------------------------------
 1 file changed, 77 insertions(+), 92 deletions(-)
---
base-commit: 81a5997c0d5ac4cb3ce65f1128197cb751ccd15b
change-id: 20251216-thp-thisnode-tweak-c9c2acb3a627

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


