Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D4E6CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D9258E0015; Wed,  3 Sep 2025 09:00:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163408E001A; Wed,  3 Sep 2025 09:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF5068E0015; Wed,  3 Sep 2025 09:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C83E78E0015
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:00:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B3AB1606D7
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:00:43 +0000 (UTC)
X-FDA: 83847948366.22.8EA56E6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id F037E18001C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:00:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LoETShIM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MyQghC5D;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LoETShIM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MyQghC5D;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904441; a=rsa-sha256;
	cv=none;
	b=wRwa5gZbwhwLs24FYZNbyIIAfdExKukYXJTm3/TW8caM7GGAFJS/ANE9JnP9Dzs7B4xkI3
	9HMuF0y75pTGsApou/cqQ5hTFZ1SNTFQ2NSrd8GbqJ62ebuLSKTKHC3CHYG2NL2nPlS6xc
	RdQSxjom+AYTwS1wxGhOVSPoMfXgOUY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LoETShIM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MyQghC5D;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LoETShIM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MyQghC5D;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GvueOpBRqUSJBVmPF3IuGLVWneYsx8iJYPivjgPVl+E=;
	b=wOxvYk/9/QwVF/umuy6tkRn8vXeu23lFa8/Bih/y3F/1EhEs3n2fenHI48zRAsgO7Cuq1Y
	nO1sBCm3KKWxzbWMZM6DzqsTp/bEKnDNzm1RsRhdRzYr5pEPiAuo7krfJBeYUDIHBoTw/s
	+qwkKDM5dr+XbJVlZt2htvCPY9Rrcxo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4F49F21227;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GvueOpBRqUSJBVmPF3IuGLVWneYsx8iJYPivjgPVl+E=;
	b=LoETShIMk0pCx5L816uJyvFy7c4G6hgcTgDNeP0wdw3yv0H1gKUdk/cqAYnCOz9H7IfMBQ
	HDr9bFcRAknhxCqHENhCd3m3YzDFv71MZmJZCdVgC1HKbU0Y75RhdAXAhziIlsleurg51T
	VNyNCxItm6H6usKuYzzlrfROk7g2Vzw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GvueOpBRqUSJBVmPF3IuGLVWneYsx8iJYPivjgPVl+E=;
	b=MyQghC5DsjfSLaNXl3OCffrJh1mZIzymp5cPWwwkaVoofGSGp5XZAZ+nQGdVjDXWQmPKlF
	PfA/Q+4MQ1QPxkDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GvueOpBRqUSJBVmPF3IuGLVWneYsx8iJYPivjgPVl+E=;
	b=LoETShIMk0pCx5L816uJyvFy7c4G6hgcTgDNeP0wdw3yv0H1gKUdk/cqAYnCOz9H7IfMBQ
	HDr9bFcRAknhxCqHENhCd3m3YzDFv71MZmJZCdVgC1HKbU0Y75RhdAXAhziIlsleurg51T
	VNyNCxItm6H6usKuYzzlrfROk7g2Vzw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GvueOpBRqUSJBVmPF3IuGLVWneYsx8iJYPivjgPVl+E=;
	b=MyQghC5DsjfSLaNXl3OCffrJh1mZIzymp5cPWwwkaVoofGSGp5XZAZ+nQGdVjDXWQmPKlF
	PfA/Q+4MQ1QPxkDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B0FB13AFB;
	Wed,  3 Sep 2025 13:00:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YPyuIdk7uGitOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 13:00:09 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 03 Sep 2025 14:59:48 +0200
Subject: [PATCH v7 06/21] slab: determine barn status racily outside of
 lock
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250903-slub-percpu-caches-v7-6-71c114cdefef@suse.cz>
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
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F037E18001C
X-Stat-Signature: m9kuiizz1ynendeeci4sfoyh9c4oadko
X-Rspam-User: 
X-HE-Tag: 1756904440-842475
X-HE-Meta: U2FsdGVkX19Mu1yJSVbGS0GYLDiOgprk/ZIw4KAN5SeROjCXr+s+zwgP441ra4TFZnpJc0Z9fSbw7pGpggrFROhQIir8eBrPWWTkRC55NuqFjUmX5hXPoQ8n416PpjrsxjYf1G4kmyG5AWzESoy1do+RBC1ISLGpJCIGZ66FyI03/Hhbqpimz2wpIWaTMJ/KtNh4mqX9cuQ5Au0fl1PmXlgByegEo++Ue/040eJ5t6pAcieMDB5JWoDcfwiiviTkh9CnUOjvIC3HK0XoaYm4rGRDJmhx33DTSb6dSt7rlwPFSQTwvsqkaspcOQ6R6cCWpHQAIpaDWwI/bUnYNY4oS3vQhTn/hgntmtrwize/kdFhtR7Fk7fCIlZZFCIT4cHryqC3HX28j7gplws4D2HgxQG2gh9C2J+yM3bYmD/Glu2v4kB8FmSZjaSfRndTJ2ZYRvmxYh80Sg+N7s+i4VRVkc/YAPOLcMYV59w+VFnE+sbWB8QxVI0f5tIJiKsS8F2TavTBNkLF0xdVJLm2fM1SMiv6L6infM7ZJXaU87RW7HkZAugpcqftRH/wn0qypl3K/hHqet6d6f/KvmsoOPoKgt+RvzsHi6yYDsL0pBroD7b2OuiH4adYbLr/u8LkAq7lanLKftAiBHlrFGAMUXnh+8vuVgnGU0iL53BON9LpVT+YYjrKnLGEkdA9ImaJ5A079cz7moAfd+l/7DTTwZSWPbgLmDLTnxqog0vqRu05w6DhXhFrMVFeJ1AH5yGVG8dx/tHkyTO3GLCoVyjPp3pQNO9oW7zwHIa86gN1CiNZX1eRwA7im0XTGYCcnQpTbPKNgw9TFep0y8XvGp4qL3PC11amB8TbmNcrQmYr03zEGk2dqzL0LU9jlQOD63G5teF5HwYmnA3ur8QePclfLDwpVY6Es2jjW2Lo+CS7cv/ZAFV/gQwkkJHdYBn/RdJFqhEcxyDl8LlqWgcVy2OSytv
 YZWTBw1i
 fbx+Er+GWRBYzTzBoERhLGHWSuNW73xlmKOEMimJ37yOodblLDxStiPwd9HhWKeiE/STGkVVeqYUERzhxcuERAZapCj18sOv3Qxi6f466lno2nE12tGC+UJqf5dNef9ERo6JR4VLk++TsxRtAXn90lChrRQk/yep/uU5CdYyR6flunE77QyKiC2Ahh/PRETFlGgUuTfBSOW55ad9r2QsSRHopCxp7MPi6FEze1TH9tgXQM0FLSDVt/ZsZgx4Oq0ymhHWZEl3HOqoRLMnY/iWwZUTHiQf5tGomy1HB0huyRgDWPfo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The possibility of many barn operations is determined by the current
number of full or empty sheaves. Taking the barn->lock just to find out
that e.g. there are no empty sheaves results in unnecessary overhead and
lock contention. Thus perform these checks outside of the lock with a
data_race() annotated variable read and fail quickly without taking the
lock.

Checks for sheaf availability that racily succeed have to be obviously
repeated under the lock for correctness, but we can skip repeating
checks if there are too many sheaves on the given list as the limits
don't need to be strict.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index c6ca9b60acd15520410ac08d252bb09e111db6f1..d078630f7211b617f390a16fa080da8a1df45355 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2801,9 +2801,12 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn)
 	struct slab_sheaf *empty = NULL;
 	unsigned long flags;
 
+	if (!data_race(barn->nr_empty))
+		return NULL;
+
 	spin_lock_irqsave(&barn->lock, flags);
 
-	if (barn->nr_empty) {
+	if (likely(barn->nr_empty)) {
 		empty = list_first_entry(&barn->sheaves_empty,
 					 struct slab_sheaf, barn_list);
 		list_del(&empty->barn_list);
@@ -2850,6 +2853,9 @@ static struct slab_sheaf *barn_get_full_or_empty_sheaf(struct node_barn *barn)
 	struct slab_sheaf *sheaf = NULL;
 	unsigned long flags;
 
+	if (!data_race(barn->nr_full) && !data_race(barn->nr_empty))
+		return NULL;
+
 	spin_lock_irqsave(&barn->lock, flags);
 
 	if (barn->nr_full) {
@@ -2880,9 +2886,12 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
 	struct slab_sheaf *full = NULL;
 	unsigned long flags;
 
+	if (!data_race(barn->nr_full))
+		return NULL;
+
 	spin_lock_irqsave(&barn->lock, flags);
 
-	if (barn->nr_full) {
+	if (likely(barn->nr_full)) {
 		full = list_first_entry(&barn->sheaves_full, struct slab_sheaf,
 					barn_list);
 		list_del(&full->barn_list);
@@ -2906,19 +2915,23 @@ barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
 	struct slab_sheaf *empty;
 	unsigned long flags;
 
+	/* we don't repeat this check under barn->lock as it's not critical */
+	if (data_race(barn->nr_full) >= MAX_FULL_SHEAVES)
+		return ERR_PTR(-E2BIG);
+	if (!data_race(barn->nr_empty))
+		return ERR_PTR(-ENOMEM);
+
 	spin_lock_irqsave(&barn->lock, flags);
 
-	if (barn->nr_full >= MAX_FULL_SHEAVES) {
-		empty = ERR_PTR(-E2BIG);
-	} else if (!barn->nr_empty) {
-		empty = ERR_PTR(-ENOMEM);
-	} else {
+	if (likely(barn->nr_empty)) {
 		empty = list_first_entry(&barn->sheaves_empty, struct slab_sheaf,
 					 barn_list);
 		list_del(&empty->barn_list);
 		list_add(&full->barn_list, &barn->sheaves_full);
 		barn->nr_empty--;
 		barn->nr_full++;
+	} else {
+		empty = ERR_PTR(-ENOMEM);
 	}
 
 	spin_unlock_irqrestore(&barn->lock, flags);

-- 
2.51.0


