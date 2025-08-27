Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD06AC8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 08:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8156B0366; Wed, 27 Aug 2025 04:26:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBF5C6B0368; Wed, 27 Aug 2025 04:26:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BADDE6B0369; Wed, 27 Aug 2025 04:26:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A0E5C6B0366
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:26:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 59D3F59215
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:26:39 +0000 (UTC)
X-FDA: 83821856118.16.603E412
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 18BC420002
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:26:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fWZ3VKM3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CE9USv0j;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fWZ3VKM3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CE9USv0j;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756283197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCAb571qgZEf5w34vVc+FdxmgCSPpBunGHGMPiUvzjc=;
	b=RufeGTixaF2XuiEr1885L6MuQDvPMu4Xcd4jHDidQmeyILnRTKdVBN8NKgDGELOqnu4IW9
	FuA69OENrxicNBv66KFLFG8WMnphC6fkqEz4R7v3tbxJ5vOjcaghBDSqlrAaWmHV9Uo/ep
	ffeTsLEdPnGaxNkUFeQrjFNPuS6CEL0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756283197; a=rsa-sha256;
	cv=none;
	b=or4Ah+hu73cP058RfyFfi84YFTXfwEClRn2+CjvXuXE1Q+LMge7Mw3eMGTN5AJrx1z12/S
	WxDlnO+rijNw0gM/iBGH2WS0OJ5EfJJ+WDs02+2E1pyb7fedo25XQdrLtx3eKL9YCU2mvn
	vlgpe8/P+26Xy4qGvd1Bg5434M022DE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fWZ3VKM3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CE9USv0j;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fWZ3VKM3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CE9USv0j;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 289D521F9E;
	Wed, 27 Aug 2025 08:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756283195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lCAb571qgZEf5w34vVc+FdxmgCSPpBunGHGMPiUvzjc=;
	b=fWZ3VKM3efiPGsd1PSyEMGOcyKwZKIyDvSvJ/e+klC7PTeclT2hHi7wbwMHeDuYO2D3Xzk
	731YNld4vwkApqJz9w2RKOhTD4AocxRQTND9pcyS/LqUX7jWMNzYQ0dh7jxw0eJEgZyETP
	75+0hhVlAWCAOzHxm6HvvlNjHGetoHE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756283195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lCAb571qgZEf5w34vVc+FdxmgCSPpBunGHGMPiUvzjc=;
	b=CE9USv0jQGth3V9w8477Htow3GLkk6lXsEXd/4X1MlGUXqtzVYeNBRoE27twQxqq47dfgX
	WFC2Lm65fK3C1CCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756283195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lCAb571qgZEf5w34vVc+FdxmgCSPpBunGHGMPiUvzjc=;
	b=fWZ3VKM3efiPGsd1PSyEMGOcyKwZKIyDvSvJ/e+klC7PTeclT2hHi7wbwMHeDuYO2D3Xzk
	731YNld4vwkApqJz9w2RKOhTD4AocxRQTND9pcyS/LqUX7jWMNzYQ0dh7jxw0eJEgZyETP
	75+0hhVlAWCAOzHxm6HvvlNjHGetoHE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756283195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lCAb571qgZEf5w34vVc+FdxmgCSPpBunGHGMPiUvzjc=;
	b=CE9USv0jQGth3V9w8477Htow3GLkk6lXsEXd/4X1MlGUXqtzVYeNBRoE27twQxqq47dfgX
	WFC2Lm65fK3C1CCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C85D13A31;
	Wed, 27 Aug 2025 08:26:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sKnGAjvBrmhNfgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 27 Aug 2025 08:26:35 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 27 Aug 2025 10:26:33 +0200
Subject: [PATCH v6 01/10] slab: simplify init_kmem_cache_nodes() error
 handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-slub-percpu-caches-v6-1-f0f775a3f73f@suse.cz>
References: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
In-Reply-To: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 18BC420002
X-Stat-Signature: xycx7rtdq6e9z9rtuz31nsiqcoapdyye
X-Rspam-User: 
X-HE-Tag: 1756283196-281425
X-HE-Meta: U2FsdGVkX1+K1Iaa2lmqxfa4q+kG5J5iXZgAE9e7zIF16tiM1B3TQE5bo8U45Z/+2kvHm84f0D3UOeQCeWnlSHe1WcjxFpkYvNvpuAWgvbVrk9AGfKiH1P+olNUAIMYvHpusBuZB3DoQQV7T2zsKdwUg5e/lbhPCsHpVUDaA4SSmGOkOTcwTx+cVflx6z6NcVYc6jZcqUaD18uTzS12xHd4XTd7coGbS8xf65kOHb2yRbwnF6C9T4EDb0j7Nw2I/jErznxeXRZZc0M0SPnJpkZv2WUKk2cfDT2x4Mi7fxWgIvVEVNRP1Lzx1yfz9u9H0lnw0//eExyigistGfNbEhLk2ddhp9zGQs585cKOzPmILDuktctgWb0LPX0dIy73dg+ud54AUHsCSVY0rtzRlV/WJGwNZtL7D1kva4BVeyVcMf/puogMoR3NNfVYYX+HaT0mikA1et+8VhjrIrYx6J8IpNoaImL38jjUJ8EcsMDWFLpChTuIQzESnx01STKlMvynDQFQL895bwbXUXCm2xF2PUoI90e2n/B/YDZWKwOTGpNQO3vloFJDmcIaZtH9VcU1kB7jDbAquzIOUCZWghxkzZU+B2zbc9e/CODhN7YX0NU+esJ9yFpYYcj6s4qJamzXzynbvXJA/7BzT0de68dbAFBjtI0hNWrqN/3FPxVqbCU5QvV//9aDLnl3KytGxL+IKotAB/H58UQXUsCV11wR91YYq+1c+3PFVq5Rogb/6N7yeS47oXALav4ohdHOHQxtMrNqSvITC1BcNRrC64H3FW+Flgnpi3JFV8iqqwd/fY5bK3RRlPnXYM6R5MExvPCTy48UaH5vG3RWVOFG3WYB4Km8Mb83U1FMaAtpv443+d/QznMpAT7DOTZP1b1U2d+3ZXNL43O73DaecBR6Ev4AhrIISmgui4VHGPB2I9FkwRisLI1AqczuT1tvClrgbYSxjWcJnxcAUFlL0h94
 Z/TvJd9/
 6P7SMfcxLWsL6V5AUbx60m0q1It4h5Qc1BbbbS4mU+6wPRW9vYt4w7whO/2H2i8GjURbDicy9xr7vrsGaByCBP7xhnIb96SL/djG1/ZX9zKrXQ38cjQPOBHDp39mxv9TVa2VDMxow2oxyV0uCCXuOKLx0CB3AsEa6JfyQAd+OLblPThm3zagixvXN6vZEHzJ94+uU/ieG7BQSikj3Zx4mIDq7dgcR9damW1fxPyF/7LxXClT12lk+zaOhtT7lUcwFSmHoM6zbIvJEp95QdNtdAjUQqZu263qP5xkdgRnGmgNWTNnK/Tjf+qGmXD1MQt7X9G5HVfBF1X1mMHE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We don't need to call free_kmem_cache_nodes() immediately when failing
to allocate a kmem_cache_node, because when we return 0,
do_kmem_cache_create() calls __kmem_cache_release() which also performs
free_kmem_cache_nodes().

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 30003763d224c2704a4b93082b8b47af12dcffc5..9f671ec76131c4b0b28d5d568aa45842b5efb6d4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5669,10 +5669,8 @@ static int init_kmem_cache_nodes(struct kmem_cache *s)
 		n = kmem_cache_alloc_node(kmem_cache_node,
 						GFP_KERNEL, node);
 
-		if (!n) {
-			free_kmem_cache_nodes(s);
+		if (!n)
 			return 0;
-		}
 
 		init_kmem_cache_node(n);
 		s->node[node] = n;

-- 
2.51.0


