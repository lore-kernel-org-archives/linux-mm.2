Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30FF4CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 17:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22AFF8E0001; Thu, 11 Sep 2025 13:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CD0D8E000D; Thu, 11 Sep 2025 13:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE9488E0001; Thu, 11 Sep 2025 13:02:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA8E18E000B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:02:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9275A13B305
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:02:40 +0000 (UTC)
X-FDA: 83877588480.01.5AA5B9F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 23CE610000C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:02:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qhAFPYM2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YEoQNo6X;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Hy24iXSK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=andfp8yJ;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757610158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=g2ztmImEtHsUE0xBTiICNacQWE8dOeWq3duroo1FEbU=;
	b=nWmBRLiBaPYzceF/OgqA+K0MHeEBbeyyhKCclLXDYbnyCASr3FWwDTIzPEK2bfrU5HkMCm
	Lt2CT5AqCFCrLJn20YPNQISoPyTCLJB9PsohaR4/sF99r1uBEL9faVzfewbCZVi4gVaXJc
	7aiCUCdjiA+6gCzobed36ZDcdojl5b0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qhAFPYM2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YEoQNo6X;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Hy24iXSK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=andfp8yJ;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757610158; a=rsa-sha256;
	cv=none;
	b=2P+JBENDnbpde+TtaipZdSyeNVMx7avWhzOOuNP/WYTfLR/aPPVB+ik3gCU6eHeKslNKez
	gNz1TVhltughhKEyiV25Tod+m8etUBj6FnySnfkqfu+Eh1g4Ex9lyqVPtfvQZIt/ls5oij
	jN71il7qdv5M2ZX8QvLfeqqBdUTDC3c=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E965137BDA;
	Thu, 11 Sep 2025 17:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757610156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g2ztmImEtHsUE0xBTiICNacQWE8dOeWq3duroo1FEbU=;
	b=qhAFPYM2SnuLz20qxuhKWKZ0rLm5zhSjQgMRpilJI+3oELqXb1FAyR7L0l3WLUGAUQSJ4+
	jXnhjifyAnjx9rhAS/iu1HyX38WAUfzzg3AE+X0JR9n7cGFFWQe9yZZ6EZ3Nin3A+Ygbfk
	aG+noUgni1g9LTg08jrIRPCs7euWwjc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757610156;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g2ztmImEtHsUE0xBTiICNacQWE8dOeWq3duroo1FEbU=;
	b=YEoQNo6XBUIz4+RdMmKvrzyvMg0Ot/SjXNdv9sLX72iURzS+kvgW7DFerUHcDTjlYA1GLJ
	0nYtarkevwXrEDCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757610154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g2ztmImEtHsUE0xBTiICNacQWE8dOeWq3duroo1FEbU=;
	b=Hy24iXSKWvbMWXb+T1YGLxlAStGu8Rm5K7MVyaFiGwojd/43zdw/ILB2JTNNHOADyln8Ec
	wd0Hb5ovxnBTCREti1JqG6sSTSlQT9a5uE1BXCd7Gw/avBKtpG/09/BCd3js2Yfcxh0U14
	s97zbHBto2elSbZ6sJX2BuYM4/NrHeM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757610154;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g2ztmImEtHsUE0xBTiICNacQWE8dOeWq3duroo1FEbU=;
	b=andfp8yJ1dw0dwpnxFUOrF/FONl/dn5PBDVA5KT0szTfKqiaGJ4e1UX8xvU1aX0MF41lYF
	rbqFzcDyaYXnbRDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D07C613A56;
	Thu, 11 Sep 2025 17:02:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qKVIMqoAw2gUJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 11 Sep 2025 17:02:34 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 0/6] slab: struct slab pointer validation improvements
Date: Thu, 11 Sep 2025 19:02:33 +0200
Message-Id: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKkAw2gC/x2MQQqAIBAAvxJ7TtDIg30lOqy51YJYaEUQ/r2ly
 8AcZl4olJkKDM0LmW4uvCcR0zYwb5hWUhzEodOd1c4YVeLlBejVjZEDnhIoTf1irfMaTQBJj0w
 LP/92nGr9AGqWyipmAAAA
X-Change-ID: 20250911-slub-slab-validation-0e4f559b0a1d
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Stat-Signature: 56g8oj87ceypb7in3pb71mdsz97dxfnc
X-Rspam-User: 
X-Rspamd-Queue-Id: 23CE610000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1757610157-242854
X-HE-Meta: U2FsdGVkX1/dXd+O/96DupLRGRg+oC3MJO6BuzhqAcBVr98TWuHpHxZypIXD5IZMwtDBgudIpCnGvQVMmGv+qGxGmKGRK/qDRcgn2TAI5Yps0ThhWzwOu3X3/P8c5CYaR0WXpy1sQcnBUpvrDz5gAUDOCaVGyRYUovXWzR5Pt/mv/79ypyPvRdpvhveaAd3/mgBhptC5ggLxifyJ+yaiyBheCKXeuceF1AkEfZmaua8jzdieucZuUHyuRL2xxAAnqSXOE3opduTtnRirOkuiV1d9Xkat7utRmZJC2Lby08SZXkdzhzRk6pkbn4rzamYUHF40r0hPSsnKyI6ZIH+vWfwFogbyZb5bQiRy1VJKEx7+1CW2SKWYpSQrQ7z7qs6+dErrYF/9VEYbD0WqTUpk8TZ2Pq28c/ZTORv/MuC0RSZW3h7z1gBmC2vkrNS8CLRft8bO+tAPL4FcOn8195Mfjd0kc+D9tHZVt4K99akET14G/v/YJBbr+QRtt+U1Q3+a0KkMNNgV8ZPJ7KPXOttQDZwBiltQnxJ4o6dEMc1sKQoHH39hZdm+hBoCnW82dCkfEboAvRyBjMKcNGNsoczetP2keRrUDh7J6b0stGmGRwgbb5v/br6Riwey6JgwDYxk4xJUO8SRTMxwq8zEBvBr7ajnog1z5hpgENsC9p+tfyoV+/qHuzewfJp8Re2zQUvzKJwjFxIEYtTLGg7GCzbaU9jLfhScj0xdVyJXKf0xUVEQkqaml4YQimc9BI8LqpSx56l9tgP/Oz4P+o5sZ3LaJymbfBN2gVdMj2j0e/rKyZfCSXIoRO/AxcVJdAt9k3MYHkRqXXNLTOGdv09JeJUe7IiZkADXQfq3vzTw5kiA+ZN96tl1M7ESK2Wg0rEv8Bp8uNbTY/jwBxCpY+Elw486TDJLaRgVSFpiSvhOa+u632uGRnaHN1m8KYtJQ8XxtW19WKKPRygtpx5OzgEWDcm
 XshWyRVm
 D6qzriHUqqHypY3CdQkDK11nDbbeLJ3SlXpTyvs7inUzx+uv8qW3hijp+80E5ryL2DySwCtxgzIWsBVIb78aPkFActI/6OG+vXO3B8AXyM21QyYE1LZIcR754Y52b1enBNjj14+bE8ZTWBHZIc+lhbGHHc7GfrZxmq+WOtrLrI9wOAyEWLAq20UghDRrLpuR4kKC+WURFH+U+uvPRHGf4QdpeDQ3u3VonEFptbILAuYJnnvHFG3zE60mfrG/VuTvnoJaAefNLCrfwiSG0aspVKxIXpqzfBnjX5/h6ux/YCLXOaasOC0kGZDz6i/VhLPMNWSCy2/j6oZhPyeU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
allocating from it or when validation is triggered from sysfs.  When
freeing, we always obtain the slab pointer in a way that the page type
is tested in the process, so we don't need to validate.

Based on:
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=slab/for-6.18/fixes

[1] https://lore.kernel.org/all/20250910115507.1991829-1-willy@infradead.org/

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
Matthew Wilcox (Oracle) (1):
      slab: Remove dead code in free_consistency_checks()

Vlastimil Babka (5):
      slab: wrap debug slab validation in validate_slab_ptr()
      slab: move validate_slab_ptr() from check_slab() to its callers
      slab: move validate_slab_ptr() from alloc_consistency_checks() to its caller
      slab: validate slab before using it in alloc_single_from_partial()
      slab: don't validate slab pointer in free_debug_processing()

 mm/slub.c | 61 +++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 24 deletions(-)
---
base-commit: 41534d499e50e23571d6b9960498777d93f817ce
change-id: 20250911-slub-slab-validation-0e4f559b0a1d

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


