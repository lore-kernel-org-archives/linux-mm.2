Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8904FCCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 08:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9FC18E00CA; Tue, 14 Oct 2025 04:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50608E00AB; Tue, 14 Oct 2025 04:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F6B8E00CA; Tue, 14 Oct 2025 04:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 924FA8E00AB
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:41:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FF1CBB2F5
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:41:05 +0000 (UTC)
X-FDA: 83996074890.04.94D56BF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id C1E111C0007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:41:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ivPmnqiV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5neRTWO+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qfEVIgkQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+hcqb1bq;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760431263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oD4N98xqKoKzh5mdGTCdnVsbHNjiWYye8KSN/sZHlMo=;
	b=Z8ewBbkwRMNPZcAIBUHCBXSPHpqqac9xmOkzO7kmf+/97rqI7M96th/PY+dtJbLa8G3vcf
	4a2F64yp10YLH5h9b8/jZr+oFBMBD9Xxk96Gmjpu9DcZNhe3g7Y1PLAODo/jh40CWY7x01
	+y6WwcBwYTisjP66i+QVS3t84JWo2lw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ivPmnqiV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5neRTWO+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qfEVIgkQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+hcqb1bq;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760431263; a=rsa-sha256;
	cv=none;
	b=MHaZNbNnhaU03E1ZTHCTZhoBThxQQCTciOSaQGAtlkabO5rpMaayOIVbMBV4w/iFSa4l9x
	rujse52Y4TqOYw4xLjUHBl8o7INJ7s5EbdyBI1SDMqNruAnZWadhPx0uDz1VJgUfuUaWng
	W+khoYpjNV8F25OfVFv59z/VFnMbojw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E48A41F7B9;
	Tue, 14 Oct 2025 08:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760431261; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oD4N98xqKoKzh5mdGTCdnVsbHNjiWYye8KSN/sZHlMo=;
	b=ivPmnqiVD3lW6jQtv5IXSI6u5paQvz6x5PzlMIRpvkecw9HYw29HXFVkuA3TKyDYn1Z92E
	zLt37ChvkwBQpypkjMZRtY+aPZ0gm3UtRDtDua2d6HPvc1CHVlkJF0Y14GNE/OmW4BK65d
	o1Wto531LjdoSVYZywG0DKuSNEgR4qg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760431261;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oD4N98xqKoKzh5mdGTCdnVsbHNjiWYye8KSN/sZHlMo=;
	b=5neRTWO+ATqOjBCTRINXXRjrSI3gGlw1SSYXbB1BZqstYzTpvbUsvM/PbD5iUH/a/9M14U
	bsIHj7dks+8Q5bCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760431260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oD4N98xqKoKzh5mdGTCdnVsbHNjiWYye8KSN/sZHlMo=;
	b=qfEVIgkQ6o1sjqnc/Fe1/M8RBgZ5CyPLyFHFFahDDSqNve1L2QZemFc8anbNSIey5dmbo/
	RZBJiPu7AhwdGmcX03BlRuBWSRALYSUVqPlnTNE489bYdYOnXLMYRXTkizv6MgqmSfTo1d
	IqUyykSGOJ9ugU5dOW0ZN7RV4nBws4A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760431260;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oD4N98xqKoKzh5mdGTCdnVsbHNjiWYye8KSN/sZHlMo=;
	b=+hcqb1bqPU4mvm3h4A0Qx6ro8PLXOpwb3KsRtMV8dZ+GA22ZHLY+UKDeTKdxO4zF7epyDH
	OOVSZ/mlRdpHf8CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D04A813A44;
	Tue, 14 Oct 2025 08:41:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G1uFMpwM7mg1IAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 14 Oct 2025 08:41:00 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Tue, 14 Oct 2025 10:40:57 +0200
Subject: [PATCH] slab: fix clearing freelist in free_deferred_objects()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251014-fix-freelist-v1-1-e402301f276d@suse.cz>
X-B4-Tracking: v=1; b=H4sIAJgM7mgC/x2MQQqAIBAAvyJ7TlDRg30lOoSutRAWuxFB+Pek4
 zDMvCDIhAKjeoHxJqGjdrCDgrQtdUVNuTM444I11utCjy6MuJNc2sVoA+aUXPHQk5Ox+383za1
 9wZAMpF4AAAA=
X-Change-ID: 20251014-fix-freelist-29915edcc2f4
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
Cc: kernel test robot <oliver.sang@intel.com>, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1866; i=vbabka@suse.cz;
 h=from:subject:message-id; bh=pPl6RhapejOsMg81F6RD18xhwMoZrS5BV8bYDWQ519A=;
 b=owEBiQF2/pANAwAIAbvgsHXSRYiaAcsmYgBo7gyZePWrRv20PZ4gtsekRnTDi/+wx3O6/MQId
 xlDIfKeSv6JAU8EAAEIADkWIQR7u8hBFZkjSJZITfG74LB10kWImgUCaO4MmRsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMSwyLDIACgkQu+CwddJFiJriLwgAnf3jwUayx0cBRT96peMbd7s7WEPHx6C
 LMsjWXyIMckLoLLip3RhZfPU3p+/e2zr/i7qR0ZRuef2J156WM40iqlqlIvUBRWDb6vu9Pp2dQi
 Fueb68BrxnZNVX4pp7Yl/oNIWMKaHZvlYOKiXDdLgMdiK13YyefYBY4iW29lioG9CWzM0nVob0s
 CSenTaTXRczmjAHlU+7cG5TJ5zAUkKWJVHUAMSzBEcyTSTJgsBOC5jGeMfBdIz/b56xpIcLpxRN
 5oe/zNFWvI+cLTFDXDfcZSPb4C4q58GPQsH/31SIZw7/7ygcaB8ixJbd3NGVTmZPxE8lREJSLuV
 ITcFp8oqpJg==
X-Developer-Key: i=vbabka@suse.cz; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Stat-Signature: z7y6xftakg5s86u5zreokyrcn7qmemqy
X-Rspamd-Queue-Id: C1E111C0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760431262-590154
X-HE-Meta: U2FsdGVkX18lrOFEfc/5YRub0oXFTuuLZGGYWpJ8XBXBxy7Oe1hOkzpc/hLyU491O6iI+nHU0sz6gSEOCjv3yQJJ8uy/ks3XvymQHzdPkVQ72lWvdt+g11SOt8KZl0Ug/daio93j7QpRVUP4p3+CzvJp99P+xTo6At6Y6lHXV15/9rGgKa//5TAq0mwNtcSanSqsLekfnlq3+AK+BLKaqqqPDv06jM41g4Xy04HlwaQrnHfowggViiLbRQmgWMZ0MaF3jWl4fZZfjWDAaVAnKfnBzdrOCbqkfRZvnU6nXxHHjBRC43PXmHKUvErau/KvTP9tGKgqmSk/WPd0AXtiJ/P5eTfS0meBkD8tmCwuxgedAeDIdwmyzXwAT081bV9Rj72tzDibdJZ4CNYbLNYpiDCXmIIMlPCbygVXth3fRePYSWdl7/GAvtnfl+STZo46PVhMG4oWSNImkcVDNW2Ag8yLy6NOr+wH6HGSwPEegQSSIbAZqlumnWVBvGXNZWZK/uF5J3BD8BkcJ1Wn9Slaqc9jBEl7nnLOUdT5/DudCVxV9rDN8hul/YV1SLJ/jlXHljj001/HV933aNTjNSo8qSzv/wJyESXRjIcyNclgJGb1q5TabVZlFXFG06Hr4MLkHKtdgdiJq5gJCm93CTE6RsLQdHM6Gv9aQthX6oLIR26oXX06j6eujR2DZ3M42m3Ke5UYcWdyTOWHvCQzYaRHqCCCdD7L2ov7kTJPDteDIn80UZZgO0Wlsk6wB+tNuVTkPxNl6MzNWtnsoxxomJxC+EPtPGXNbpJiQzPUmzo/dVYcMF5bqOY+fe8ReQqjWwxPkETrCfD7oBg0OJVkeZZxRPsVHPYf2FWudcg4yzFAIFrMZ7LNrlKfGE7iehe216s2rt20dS1JZkaoAkFVXLADodooygbESheJPaIHyIusJRElK7o0Z3myCSV9zqZ+x/mA64ye5NF38FD7mef6W0U
 EgILDJB2
 ZGUflGiMqJNw8OIwQg0MG86yy2PAj1DYxvP5N/Y6z0poZzg38dYju1YLtAvtMpldyqZblqARn5nWU9ybbfB9j3J+f3Sp72q/IGUfnDEMDDJaPZCz0IUZQJynSXSNhGqPhUpQuFwnxNrdz/6O04SF/b2VGK3Y3s6vhTulcxTddK5YXxFN28APbqyamrqULUPKQ/c8EiDscgVb37JlBixcWDxx5UDf4emAHtusNfJdo6G64DvjJMtNz/v7L21IYbLlBttUtLYmgat+LqL81L/41Vrosu6+3f8/vVmmyWu1Ym5fydOwWmyTtkS2gURrEnRklKUXkwasoAlAmELm/QNNi5N31KQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

defer_free() links pending objects using the slab's freelist offset
which is fine as they are not free yet. free_deferred_objects() then
clears this pointer to avoid confusing the debugging consistency checks
that may be enabled for the cache.

However, with CONFIG_SLAB_FREELIST_HARDENED, even the NULL pointer needs
to be encoded appropriately using set_freepointer(), otherwise it's
decoded as something else and triggers the consistency checks, as found
by the kernel test robot.

Use set_freepointer() to prevent the issue.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202510101652.7921fdc6-lkp@intel.com
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
will be added to slab/for-next-fixes and sent later this week
---
 mm/slub.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b1f15598fbfd..64c17afc375b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6443,15 +6443,16 @@ static void free_deferred_objects(struct irq_work *work)
 		slab = virt_to_slab(x);
 		s = slab->slab_cache;
 
+
+		/* Point 'x' back to the beginning of allocated object */
+		x -= s->offset;
 		/*
 		 * We used freepointer in 'x' to link 'x' into df->objects.
 		 * Clear it to NULL to avoid false positive detection
 		 * of "Freepointer corruption".
 		 */
-		*(void **)x = NULL;
+		set_freepointer(s, x, NULL);
 
-		/* Point 'x' back to the beginning of allocated object */
-		x -= s->offset;
 		__slab_free(s, slab, x, x, 1, _THIS_IP_);
 	}
 

---
base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
change-id: 20251014-fix-freelist-29915edcc2f4

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


