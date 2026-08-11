Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1736C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:22:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93AB66B00A4; Tue, 11 Aug 2026 13:22:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876076B00A5; Tue, 11 Aug 2026 13:22:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 716A26B00A6; Tue, 11 Aug 2026 13:22:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4782E6B00A4
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:22:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CCCCCA0C0D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:22:20 +0000 (UTC)
X-FDA: 85089657240.02.DE195AF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id C5D8E4000E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:22:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1xlo+BCK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Q4VURrZY;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bd+8qYLR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MfMAzA9W;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786468939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EUWDIMOaWkkZ34vTL0P5w65MWLRcwsv0a9IIngxYwbo=;
	b=bfWAdYArISAfvS5Eq+w4Fw3KHQN87osjGzjlFwISFiip7D0a3tJ8FZ9hRaXGzeBo7YhZ//
	TgQsXg21KJlwA7OB+51xlZNhKWMTi48903amhpJYfR+W0ohv6ZGD5Yv9FQuouSEDYyzKDW
	yGu+Hogc6ZEvDWfVyUPYpVRz7lTgCsI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786468939;
	b=nA0RhIu8MLL+bn09fDcL+4Ntn6pYQegWiug5JltMA0D7Z8UVlyWzwcX9Z93L+pMv6slrCr
	TcWe3+iJC2VMZ6qJJqC3A2/+XIfkc/63X6bu4+mJv/v7Wqi+lkpX6kCfUeGTlUgPNDTerd
	hDQM6EQJjCzQ9rtWxF3Pnfof3uL/nHY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1xlo+BCK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Q4VURrZY;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bd+8qYLR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MfMAzA9W;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5AFE73E55;
	Tue, 11 Aug 2026 17:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786468933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EUWDIMOaWkkZ34vTL0P5w65MWLRcwsv0a9IIngxYwbo=;
	b=1xlo+BCKuzPUeATdc1lYO65EpAOYxmXHYpTU3QgKLOzpIxJzW1YOmAUYV5SnoKnL1H3mDs
	LdTMMSLNmO8VVq+afCBWCVXr2KI4+W8tGFfGThRu44FX4fjzS/1Xl3ehkBpL+6rSoyTYQy
	iL5QhLCWmyFb3BG4O/SP7tEVUdNc2Gs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786468933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EUWDIMOaWkkZ34vTL0P5w65MWLRcwsv0a9IIngxYwbo=;
	b=Q4VURrZYYhoUAi4PXeSfZqe0r9pOaHv1mVFIbiG3NrIdRQOgeDCS1CN+0LvwJmdAYNC1lJ
	tITS5xNMd5UrjtBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786468929; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EUWDIMOaWkkZ34vTL0P5w65MWLRcwsv0a9IIngxYwbo=;
	b=bd+8qYLR0ax7RsQ9UZPbkJVPKOr1rISn4SuqYkOrCJSu82UAjNoUnegDD49Xi4NWnQ3adp
	aRJNXS6ADXjasBTf3HUQ8mDZ1+Cv0om+GM3LB03bIpHBg69TXvYNtR9EZa0LMgkv3I0jI8
	G40W62HqS4FoSneIZQ4V21WSsuvcaEk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786468929;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EUWDIMOaWkkZ34vTL0P5w65MWLRcwsv0a9IIngxYwbo=;
	b=MfMAzA9WUH9Yz/1e6eTsggrqTWCgImowndjBl5BncnGeYNd8I+8CpbQtNoPas+EBcWAraa
	AHOg4GjeoY+2pCCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 68159779BF;
	Tue, 11 Aug 2026 17:22:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U/gHFkBae2r4TAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 11 Aug 2026 17:22:08 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] mm: replace custom ratelimiting logic
Date: Tue, 11 Aug 2026 18:21:54 +0100
Message-ID: <20260811172156.356053-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: qtjk66d179s557exko6tareicc11hrxg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C5D8E4000E
X-HE-Tag: 1786468938-36381
X-HE-Meta: U2FsdGVkX1/H3KC5JaA0Rl/AZU9pidrgM7QIcEqfqnYh/M9+qpuNLw5nHK7saZcXcAZnSYjy64/btbt4xWvf0yEs0c59OvD7b6X+DtdAwv6xdrBCdAAr2CRCucF2X5P5w5btk1+i2TBvpG8En/HyG3GyH0+jLQrxRzz0Dxxsc8lwtLJcrPa58qz/XglaFJOF16T86ssW3WGCLIHp5gwcd4ML+w22K7M3EEnVJv7r88XVWUnLRO0EcOAFWgLsENe6dlsIAmcpH/FSBDP0bjjo5ObKnlDSzOP3shXQ5jRpf7x2SYZCcueHap7lKkew9zqVAIqjQCnYj6mg/Gg56tv2JnXuCnMaZWKCc1PaH/V2CnGKijG6BgxjWMVJ3/pz8Qocdk5PDIuRYsf1qjQ9kqX2MvSkX2esG2DGfxIoxiUacFO6fyqP4lQtahwCP/FcWnJKN2uUMswqqV0QrmicxqKh8tXGO2Is642MtuA8LTYzAiSEkQla7CIZrRmYadouksK2IjX3cUIrTOkKMZ7dUCpYPMJfmCT7FFYJoV1/yvseOh1wF6oyn3WeN42FTBxAXXCuHx8CoaU2CW81fDFYH4InO3dUb4Xhm2wluHVrZJGf5iGm7/qzWDEwuEJmlFrPUOWgJh426dojgddCqGwOd53PmjUg3zycvEr++TgwInUhNbYKj9QEwYwdI/gRShg27cv0kbI4pCadSW1dRtY1V9MsdAINDvaF+Pg93/r0arUgA2u6BcRNxNkipaIiAqXehDVN66gTNXr08S4UQ9to2CVPbwUgB9NWtMRS2BMF+WB1nj+2Z3s55I4vS6mUPGac+ra+wnEtIb8+tvDRmU3/ptb2vRqeC+wn6Ho+8tf1vKQNnSP9DkFwZg4r6RrK/rTBWjWJyI4pKUuVBKdmXOMXLMU5F9XxdoJk6R/6NhHwtET04NTJ7CoJPz7CZa4cOtpRvgl6QhcOZ91oojGcTw7JpKp
 j5iMgN8n
 dT1YECho8qoy6LZz4Yh0KgqI6+9TAwVAEgZaBkoWzZN1F+ygBmMPo0OFSnlJEwvMlThoEg+xjEV7cN0LXPNbNDwrOjnP+i9GHBZEsfywu6hDvR75dMUX4CAkocZ0MAkoWqXODU4j8LnC1APd53wInBskp+KD0T2M5oo3B4QejTlnRzRc3ltHJLoUONJb0Xq2mzhVnnIopogxkaoJVmU99fCarByswNY8hVILgDTv7bJxY0ULAFJN/4H6zG4M2KliZOppVj6tghY0Gp6wweZtk6aGdcySUwnPYtI0bl5q7BzDpQfCGt7qsjdHcBOK9jO5QIt6WHeP6YaOnsUtkdr+j7TRCz6I6WXdC4AihcDKdvaAx4K8G4HmwcP463pHs952l34vtbe0E+wiVhQO07VkUr6Xe0DFAiRszMl9RBGjFqw3LAP+jtuqU9jKS3BUTtPM4Pj/JLgaK52oKdI+vtVD9Rm7yUfcQghZ7FpAnZp3lYvmfLx5/tB4Fq5wq6vwuFLBaXbvKGg413HvLaP++RqTv/kiYR+rVB43lvBOYHXawiXr0WQAs5EXZAotR3Urzm7Fq2xak5pxRYSm2Dvfk9mQMT39PT5dzbTCi8kgeAhvFUUVU5luTpjc3WHpWjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kernel has a perfectly cromulent and mostly-equivalent variant in
lib/ratelimit.c that can be used.

To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

Pedro Falcato (2):
  mm: replace custom bad page map ratelimiting logic
  mm/page_alloc: replace custom bad page ratelimiting logic

 mm/memory.c     | 30 +++---------------------------
 mm/page_alloc.c | 28 +++++-----------------------
 2 files changed, 8 insertions(+), 50 deletions(-)

-- 
2.55.0


