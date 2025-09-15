Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FBBDCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 767E78E0023; Mon, 15 Sep 2025 09:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0FF8E000C; Mon, 15 Sep 2025 09:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B8C48E0023; Mon, 15 Sep 2025 09:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7558E000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:55:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 11AAC16066E
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:55:34 +0000 (UTC)
X-FDA: 83891632188.21.0A335F0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id CE57618000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:55:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FxtCWqvR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mTzrYONe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FxtCWqvR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mTzrYONe;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757944532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yhq37OvjM7fq00iEJul32hLecu5UF+dKNzM5S6DIT68=;
	b=8eEuBoHBkoXXYGLgdQP1vNEfJ+5MIzJYxaHhTmvbPQiAhZpipC4umDd5ICK1NEBklOHCGq
	m89NrsEqJUeMH0RfeqH7elpYPYnHhKCW1fsyh2nx7+M4OqqCyVDg30Z5We2NulFO1pBr2V
	TmHD0/Kr2F2VqvpNnKN5GMkT/4uI7yU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FxtCWqvR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mTzrYONe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FxtCWqvR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mTzrYONe;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757944532; a=rsa-sha256;
	cv=none;
	b=Sa/cRrnC9uRkEMm8MBcQAyZwlcGnGBLTUC9bS0vndiaiHRdUelQMQgTvqdGuacbz0SdWRl
	mDEW13jsgrJfdUpa8CwY1S9zU1Htp24uz7AX/6T2AZiptR4Z0YWsF9SIc73ZHqJIk80AFS
	z5EXnR6X9vRqh3vPG1cda2vrqE4ZO2o=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 988433374A;
	Mon, 15 Sep 2025 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757944510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yhq37OvjM7fq00iEJul32hLecu5UF+dKNzM5S6DIT68=;
	b=FxtCWqvR5ywVPaYtW5YFKfdfWmRJ3K6NxfiT/WISnhCdXqkcsTQJEwv3RrNpSrYU47Gm7e
	x/A6YEm0wJOi8YgJbClNr3lO9P84GIuhrzgMmQdpdZgkp6OjPvNHJm7EQAQsB84EsJgVwA
	ZGtEv1U986SydiOJ5pVIVED2PqNzr7E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757944510;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yhq37OvjM7fq00iEJul32hLecu5UF+dKNzM5S6DIT68=;
	b=mTzrYONeW8ploOIGMF5soa9ONZ78yoSDZAqUfFFlBTkBwMc33XoxrC9S0Ip2GBnqZM/3kw
	O7LDL+kk/DgRAaBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757944510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yhq37OvjM7fq00iEJul32hLecu5UF+dKNzM5S6DIT68=;
	b=FxtCWqvR5ywVPaYtW5YFKfdfWmRJ3K6NxfiT/WISnhCdXqkcsTQJEwv3RrNpSrYU47Gm7e
	x/A6YEm0wJOi8YgJbClNr3lO9P84GIuhrzgMmQdpdZgkp6OjPvNHJm7EQAQsB84EsJgVwA
	ZGtEv1U986SydiOJ5pVIVED2PqNzr7E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757944510;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yhq37OvjM7fq00iEJul32hLecu5UF+dKNzM5S6DIT68=;
	b=mTzrYONeW8ploOIGMF5soa9ONZ78yoSDZAqUfFFlBTkBwMc33XoxrC9S0Ip2GBnqZM/3kw
	O7LDL+kk/DgRAaBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 864891368D;
	Mon, 15 Sep 2025 13:55:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +FaGIL4ayGhnVgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 15 Sep 2025 13:55:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 15 Sep 2025 15:55:13 +0200
Subject: [PATCH v2 6/6] slab: don't validate slab pointer in
 free_debug_processing()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250915-slub-slab-validation-v2-6-314690fc1532@suse.cz>
References: <20250915-slub-slab-validation-v2-0-314690fc1532@suse.cz>
In-Reply-To: <20250915-slub-slab-validation-v2-0-314690fc1532@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CE57618000C
X-Stat-Signature: s9phegnw6cdiqtkaquq13xhhc5w1eriu
X-HE-Tag: 1757944531-650866
X-HE-Meta: U2FsdGVkX1+RNV5YhvsIqYZxE9PxBFZsk2Zg6Vi5+HqLSqdtBMhr3min1iEflwqwNz3O+63dWZFescg17wpY/DN9dcttSdBFPIogji63eZmFLluBcSGGVQlBRnHBJcksN0qMI0T2ULMO0VFDJ6VJpdH3hUT122/3sIzmq27/hJnlnCFN1xTkcJjom0E0qz3QAW1x6RJsiXiccOC7Uh5hNJ1jXATS1m8OhpPadrETZ+0RnQQy9II0ZEmQv/6TdIPyRJryq8e1wLi54fOHVG0/3S3f0/x81yj7qKWcOwLWETOwJBRhVRH0PSdqOQwF3PszcJ/tUlGxCtZpPYqpuQQbtaelj58CW7lK6/TJy2cfkehvDlW9bxhEXlEqNg1CiX6V17ekBwk4zu5MTN+lK0hO5utqB/DW7UrrB54dQLxGaXN+ilJ0WNSGsTFW6O8Ac28BZ+Lj2WV0sk9ZfSMwX08kjd008sm7GT2NzmYMojtKsOKC8fBeOaiUXl87pWUAfA0CG6Csxl24LjvNgel+f7k+aqwKSO0nnhBXUbCwFVmGKA+H2Wver91gzcYWq5TbqS/RoRJTb0lJaj7ifnm+a+2sZRhm0uA6oUuE17OCQ0SXb/Jo9zEpkX51/bbVeCu8lyzlFEFtix3Ne2HxpVpPgdAAsVda8kO9PgHu/AG8Jw17356MTSsYUDLpgUrfQlFpIwmF0YpP94Ajii4R32I5adkPHUQV1YJQZoBGuTbakQZHmFHv6RPbt7CocPC7ilunKU7iDir/MZN/UDRSgkEQa3GsYiYxIjlwC3qNCOCziGUT/COHioQq+zgTLCvHFeCghiBfarl51Pg8ZMccXaJKnG77mV8/Ka2I0000QdE5uFBJ0wSl8jYf7gHGUfdiY3ry82Ku2bYSitnkvMgfouMcRrOZexpxuT1ArdeCKzVGfB0MLOVV3Me4mvZa9rC3cA0Vvl0Gzn/vqqPTUQPTCVkcGxM
 q0Cl0Clg
 jK7z/+c3lUXc6sHy2bROiv16QoR4Oj9dm+L7mh1eAlpC7ev6ItXCisEUX8FVL1Xz1auwGqi+PzpJcjTwltYqDCYCD57npPlNXP1gZtOKzx2HiXxE/UdjT6HviCVDbMttxqcWeUv6eWWR+tnxFh2bzyqdQSggBoLXJjGW+GV36UEYQrWqqbogwrs3Mcm2jb5s5B73QG67pVAeI6wIZlrzqszoQRPU2McQszm6PJmgskioVlyAtq5BR88mW3koY59S+F3TunBkq41VbaCW7JDuQtPtgt4wnMOz+P38VySmxIhT3NYDORHPJSbdisv28yBeguAUF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The struct slab pointer has been obtained from the object being freed on
all the paths that lead to this function. In all cases this already
includes the test for slab type of the struct page which struct slab is
overlaying. Thus we would not reach this function if it was not a valid
slab pointer in the first place.

One less obvious case is that kmem_cache_free() trusts virt_to_slab()
blindly so it may be NULL if the slab type check is false. But with
SLAB_CONSISTENCY_CHECKS, cache_from_obj() called also from
kmem_cache_free() catches this and returns NULL, which terminates
freeing immediately.

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index e5b53d1debddd3fe0f941f579a1043a5b976e50b..6fe02b1d3fe9d4101465190ebefd6df41f887fb9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3492,11 +3492,6 @@ static inline bool free_debug_processing(struct kmem_cache *s,
 	int cnt = 0;
 
 	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
-		if (!validate_slab_ptr(slab)) {
-			slab_err(s, slab, "Not a valid slab page");
-			goto out;
-		}
-
 		if (!check_slab(s, slab))
 			goto out;
 	}

-- 
2.51.0


