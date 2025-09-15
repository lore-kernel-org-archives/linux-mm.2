Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CBE7CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5B3B8E001F; Mon, 15 Sep 2025 09:55:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0B5D8E000C; Mon, 15 Sep 2025 09:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF9F38E001F; Mon, 15 Sep 2025 09:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ACB6F8E000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:55:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F7BB13B8D2
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:55:20 +0000 (UTC)
X-FDA: 83891631600.18.3ABAA78
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2F7EEC000A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:55:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K9jI49jQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="nU/aOJJT";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K9jI49jQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="nU/aOJJT";
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757944518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6BO/XM4CY4A6MXS0It0mmWotlrINeIN+ElFGE0qvaZQ=;
	b=Oe4tiLCTLGz053xn5IWsAHNh0ybX9eh+aOLY+bCrLZrdKputzvcADVX0hCy1KgX/3wAMgm
	eGGoP7gOa0qOP/ceTuB6LDY6kNNHc3+DfEYClsomIDhd0CsaoCo02s6fd0qOa1a6ULHwNQ
	khll2f/cp73DAdg5PuWflYT60tOHLpk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K9jI49jQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="nU/aOJJT";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K9jI49jQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="nU/aOJJT";
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757944518; a=rsa-sha256;
	cv=none;
	b=JB/+xcXcgfK0tppdady/gW228Z7Z4Co/+52otCt53diPGWTwCzw+rE2hfHWeIVM4MKHNFs
	KXEsv1HsUO3aqigpbKTXD5PVYynASl3Fuuf58gBM2tphlRh1HqYz3YE/sKmsLNefHcKl2v
	Q7XHiO1rVceNMqqhh0qH2ESdK2pNj4I=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7A2FC336EB;
	Mon, 15 Sep 2025 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757944510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6BO/XM4CY4A6MXS0It0mmWotlrINeIN+ElFGE0qvaZQ=;
	b=K9jI49jQV8qPC4HDukiV/itEqObzPRcDI2cxTrbLaVmHM9c5kpjeHd3xA0WUcK7ZciLPFk
	OVZH5/WxvUsQ9kCs1PoDfPbs5jEUeu4d3SnuFRFh9hsgzZcD3XsGBbvFQyao8ltsU/H9OO
	OfUwNSfgv8RuAln/QMvHYLVpdrjxyTU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757944510;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6BO/XM4CY4A6MXS0It0mmWotlrINeIN+ElFGE0qvaZQ=;
	b=nU/aOJJTGDoOskAVdUHdJW6JZDgK3whIZwe5TfkY1F8CQeHz/dFrzI2mVGzWcP1SA0s/ex
	+A3fbK32NFrgguDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757944510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6BO/XM4CY4A6MXS0It0mmWotlrINeIN+ElFGE0qvaZQ=;
	b=K9jI49jQV8qPC4HDukiV/itEqObzPRcDI2cxTrbLaVmHM9c5kpjeHd3xA0WUcK7ZciLPFk
	OVZH5/WxvUsQ9kCs1PoDfPbs5jEUeu4d3SnuFRFh9hsgzZcD3XsGBbvFQyao8ltsU/H9OO
	OfUwNSfgv8RuAln/QMvHYLVpdrjxyTU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757944510;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6BO/XM4CY4A6MXS0It0mmWotlrINeIN+ElFGE0qvaZQ=;
	b=nU/aOJJTGDoOskAVdUHdJW6JZDgK3whIZwe5TfkY1F8CQeHz/dFrzI2mVGzWcP1SA0s/ex
	+A3fbK32NFrgguDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 65E7413AD3;
	Mon, 15 Sep 2025 13:55:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QO2bGL4ayGhnVgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 15 Sep 2025 13:55:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 15 Sep 2025 15:55:11 +0200
Subject: [PATCH v2 4/6] slab: move validate_slab_ptr() from
 alloc_consistency_checks() to its caller
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250915-slub-slab-validation-v2-4-314690fc1532@suse.cz>
References: <20250915-slub-slab-validation-v2-0-314690fc1532@suse.cz>
In-Reply-To: <20250915-slub-slab-validation-v2-0-314690fc1532@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspamd-Queue-Id: 2F7EEC000A
X-Stat-Signature: uihpyn3b33c7si7pqqcs8o1kjnfktt5y
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757944517-392775
X-HE-Meta: U2FsdGVkX186ibxdfsenzUh/ev9IqhCAgl5s57W4cSumqX94mLFDc3HUpZMAd1WOzgokIzmipXNZ08gKApEJbYF6Jo4SrAxPrzx+tbbQ2eaLAnDodxU/3aVYot0n5UKUCtOp7ffM9ZL39QhI5Qsspfs0v0urPl5upIxALNkaDHvdLWbH3swjXbJ+vhfFV+WbsT13HF3l7hNVOjOar8HNpf2/02ItQA/fY3G4q6LvBg2vjUZlyMd9S0oanfFYN5xINeW6RemtYsI5coX56Hy4C1AdNk0C++P7LHrpA4FSX0WOwAU4158ocvLKAMD6kvlqJpa+12wD03QDdboK5cAUDALbyqfjLEa4tH8wY5PBJCfBWiYW1EoXoWCG3IPW0TkdzkfKHqkWOsbgunB6EK/eXOImkz0VU6dnmaysXI2oS2jBuxu0N9QUNK5GIYtJsYUxVrWsdIedypkNnwRwwlUdqSE+mb8mQzTnkfAjD5heuh7K/T/VVS3wAOjhyFJc16oPgObipVddHVGd19Bu/lmRKyf29/BRiFdR5TDyZFWB2IozqvzLojp5Ewx6m2LGKQVi332+4SeO1pTCJwWz67ubut0pRlkbCYaDnuwgnXTwqY7LbCLrbtjMCoUj9XzadslsOYOPxDIJHw6LGJMMU8KG5OjkTMuxQT7PElF9rhjufRVbLMEM1tFNgWugkinvy1PfNO9cogzMBVr/5Jc+BR3bfPtILqgMbMwC9NEGV8LFvpydPweqwfT8KCJsbZ/wGdlIMXx+hpFvbdIMYpqe2RVVhDgSBqUee8BS9SP00vmUe8GZMu52dqGj+1E3C3x0zdBOLzP/l4BMR0gFPmAQGRPfTCYbjo5nc25/OLIuKdi4Ec9m8PovHgNDY5Tyxi5x8uh6oUxoSMEb759EbbyBaPM959G/crNxksjljtOfT4c6KwRlhtEH8x1OZT+WM76yId1tIqsel0TMMqnQhbVa0ls
 J3Ibfu7E
 /5ngJrZPDG1tDJiVd1ZDR+I1BGzfog+9dV+Hg6KG+2Z11m7IUfMjbdLhkVgE6LzCjYln1gT+j7ShTeCUGdG4+RrPgG50OeNYaM9qXP3eYSzqPHT11hm2mQ8nQFqROfe/0zqxFWReLKsbJyiS3bcG+Yf8g2szbAj7cIlaWuDpwguBmE3RJM/YUKadGop+uUVvbS0X0qxybtK8Xa5G0JxyoCqJGhTd58HzBM6LxRtMdbCK+qVJl0QIGWDKdlhVZ7i+LPrnx9oK6U6Ht1Pdgfkz5CkPH8XBPYillecqgB8pWPzPDRswYubMrzDqSckLaznwcJRIM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In alloc_debug_processing() we can call validate_slab_ptr() upfront and
then don't need to recheck when alloc_consistency_checks() fails for
other reasons.

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 6fb24010c17019ed304b4ef61f402212dd634efb..12ad42f3d2e066b02340f2c30a85422583af3c5d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1633,11 +1633,6 @@ void setup_slab_debug(struct kmem_cache *s, struct slab *slab, void *addr)
 static inline int alloc_consistency_checks(struct kmem_cache *s,
 					struct slab *slab, void *object)
 {
-	if (!validate_slab_ptr(slab)) {
-		slab_err(s, slab, "Not a valid slab page");
-		return 0;
-	}
-
 	if (!check_slab(s, slab))
 		return 0;
 
@@ -1656,6 +1651,11 @@ static noinline bool alloc_debug_processing(struct kmem_cache *s,
 			struct slab *slab, void *object, int orig_size)
 {
 	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
+		if (!validate_slab_ptr(slab)) {
+			slab_err(s, slab, "Not a valid slab page");
+			return false;
+		}
+
 		if (!alloc_consistency_checks(s, slab, object))
 			goto bad;
 	}
@@ -1667,17 +1667,15 @@ static noinline bool alloc_debug_processing(struct kmem_cache *s,
 	return true;
 
 bad:
-	if (validate_slab_ptr(slab)) {
-		/*
-		 * If this is a slab page then lets do the best we can
-		 * to avoid issues in the future. Marking all objects
-		 * as used avoids touching the remaining objects.
-		 */
-		slab_fix(s, "Marking all objects used");
-		slab->inuse = slab->objects;
-		slab->freelist = NULL;
-		slab->frozen = 1; /* mark consistency-failed slab as frozen */
-	}
+	/*
+	 * Let's do the best we can to avoid issues in the future. Marking all
+	 * objects as used avoids touching the remaining objects.
+	 */
+	slab_fix(s, "Marking all objects used");
+	slab->inuse = slab->objects;
+	slab->freelist = NULL;
+	slab->frozen = 1; /* mark consistency-failed slab as frozen */
+
 	return false;
 }
 

-- 
2.51.0


