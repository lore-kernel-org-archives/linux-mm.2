Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFDC3CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:00:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B143C8E0001; Wed,  3 Sep 2025 09:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ECFB8E0015; Wed,  3 Sep 2025 09:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4778E0001; Wed,  3 Sep 2025 09:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 75F7F8E0013
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:00:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19F871406A0
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:00:14 +0000 (UTC)
X-FDA: 83847947148.25.FC48892
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id BB251180018
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:00:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="BLRR/Z63";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yQsqdA6a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TIZH5ZxK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mRKI7iRi;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCAb571qgZEf5w34vVc+FdxmgCSPpBunGHGMPiUvzjc=;
	b=Y9EvHHtJiFJhsOXUYVKE9Kjl7loESg8w5z87O7O8Bf2oVN00yhCSH2cXHP1CTlFgaviMgD
	KTxlSBaETvo3wv9KqA+23VwjasDRT8huVoTX9/AcenYijN+KAsSwwZxFgZFsZ5FPQXNI8H
	CLgp8a5Fyj1MZJwM6OLFx8LZO0CDSHM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="BLRR/Z63";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yQsqdA6a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TIZH5ZxK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mRKI7iRi;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904412; a=rsa-sha256;
	cv=none;
	b=55BqJLpjNUrpcnEiWdAXnFh8ne6ow1qRBlfHr/VXu5y+heUateCSxE/4YaMu0e/bO6+DKE
	oOv2ZD0XPsnHnHgfYcMLACJiqosynGPI5stIbmmAjI9PmZnFf3bPJkpEka95RPV7GF8rpw
	Z1uwi6VAhe90l0hiuQxBOjV4nqX/laA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 519DF21222;
	Wed,  3 Sep 2025 13:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lCAb571qgZEf5w34vVc+FdxmgCSPpBunGHGMPiUvzjc=;
	b=BLRR/Z63uRSPDpSLnY/EA3qPOqyXZ1GSqrRQxV073ZyBznDRSTLUQu5P213sONgFw7kvzB
	bziFim3Yve/PXTTC5Jf/NprIdKOhJEs3V1TAfr3BNxMOOO4nXir4UNs6Wx6PokccHiiSu0
	ZYjrz+GljxForqFGTUsnlUARS9kt4no=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lCAb571qgZEf5w34vVc+FdxmgCSPpBunGHGMPiUvzjc=;
	b=yQsqdA6aMMO7KGp1oGRL6HzLAVpQ9SHkNbckgJ11zmsSLSg+57PIfwmHZPC+qIqlFuK0O5
	3qSZ0u2XyJz20oDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lCAb571qgZEf5w34vVc+FdxmgCSPpBunGHGMPiUvzjc=;
	b=TIZH5ZxK46TTdIt0YXWhyJN2yeTe3ZgTyXXWHsSCinGcLET4+HfQX8AIb5F8ozjKLQjaTm
	UtdUjg+FU/KCQeSsv/W5rVXnTC9QNBnkUzQKFjLXTCs/vrJZQ29y5LiW8ZJoVFtifwiYTJ
	4lN5DyblL4PhQC7n3MmU0D/jGS1+qsw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904409;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lCAb571qgZEf5w34vVc+FdxmgCSPpBunGHGMPiUvzjc=;
	b=mRKI7iRiIklOEZ/OJsa93w7/i1JjjJf0aPegWeyufpMB30i4CuN3mMTTR4poXDjnkwKGpV
	SN2jX912YUOEOsCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 361EB13ACB;
	Wed,  3 Sep 2025 13:00:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gMTvDNk7uGitOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 13:00:09 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 03 Sep 2025 14:59:44 +0200
Subject: [PATCH v7 02/21] slab: simplify init_kmem_cache_nodes() error
 handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250903-slub-percpu-caches-v7-2-71c114cdefef@suse.cz>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
In-Reply-To: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB251180018
X-Stat-Signature: dyx8j4rbdeosc7a5osm8kodn11fn71nf
X-Rspam-User: 
X-HE-Tag: 1756904411-398117
X-HE-Meta: U2FsdGVkX1+UAgtdo0k/0IFtRbM2sQCn+aRKJ3VAH/zVY5EeQTkou6b2GswxrRfltPYzRUCQUF5EOTY9A+SgJwQzzkTH+1JnrQ+OQRO+gvnEuSpsy0Kwr5bUEi8F20GC0TUorzqgLrnJsa8EOqAJKmBBDZpN0wRj4zZAp5ze+8SanCGyKS7Ip92hX2kZb4B5+vuea3E3vMu5WKqdvU80Swawkop3Cei3uCrcxPHYHeeP/nTHgLffc97UowPZv6PCa7CmhpYzAYpPKn/EUhU5Z7MNQsMqDpL0ffBtMHKO0LVKNltAfQLk8PzD6ZAKocYOzhp6S4p+4tCSEh3/VShVZX0i/g84ZDZA4b24lzJ0Hr5PbSzvjzZGB9J5hWE6CF2F4wcYNlA+yd2ECHFlv8P58mButQs0tRwSEV/867SSWoZziWx+7OYdlAPLHiY/V7dEGZCj2JVZZlGFXbf8FnoQthHUiHlREB+jqAaTD2MY7sxERYWEaEhCgyn/Q/Xa6YXK8A3dM+yWkdo1WBsT19tayJAojqKL+NOOgp1ZurCEXhxnMwQ9ndPR2EYuN7MA6dvFwU6kF0O+3le3vkzzGUdPhJr0CaoxqJMkEkbATIbs2zalOXndNVy+pviGBr3O+KLEAunJcg6VpaRNEHmTrn8Fg7OmdYuHkep+e+cTdfo20yLtGRv/TbGl8LwAhJjM6Fvv9Y1ENvsdCEI5ShiDDBsNtS1AUngbP94k7RtuqNmCQCgXmm6mmlNSn614M/DdRcD0Vwdc5/m6fFQYUbXctPgFkv3ZFE+fCG9JIDLvNLMNDTDxmOMsLy17McJ8KJpRSWVX4xbrU8igo3h/s1RtAD3p8TyqlXK7yIy23uvH8NkCc0yfFJCxhKSRki5Bx1qRQ9haandvVNLr1w0KtEmRz4JUT/Ev9OZ43tmcf6EKHQOVJ+PlaKj5N8tlWY5JO53RQ3Ib3JF7VwcoHhgqV9MYB//
 +2gIeX+O
 LSJSfD7cjZmTOKyr+Pt7+KdguL0O8EJG2a4nLzMDIp4wXT5twnY4evqozO40gAE6nwUO2gIoyO9epcJbG+XzENw/wLdOOrXh5ji9Ye8Kp4LJXK25JiJcJVtG+uqF4tTk7YBR/mdodqdrtc+W+c1uZHYYuoHVtUYGCuh0X/s9NudsLgYf9P8SBqt060PnbiBrWPfHtarD0XypMJH2JgNsjvrMjeugpAU0NnSDWAIEWdBQWCpdjIAMjlOwwElM8XM/A27NE7f5yTqPwKowWqbqjmw8u2YD4LNGBqsmksnQHQ3icca07zlDXuzT9OLZo8zLMBFMdiM/Gim+Su5I=
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


