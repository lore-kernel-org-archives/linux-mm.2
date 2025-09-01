Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB8BACA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:09:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3D848E0038; Mon,  1 Sep 2025 07:09:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE5D8E000B; Mon,  1 Sep 2025 07:09:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C04198E0038; Mon,  1 Sep 2025 07:09:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC5DD8E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:09:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 797C013AD1E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:03 +0000 (UTC)
X-FDA: 83840409366.24.104F469
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3FA98A000D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JXEC2JSP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tLWW5Zdr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JXEC2JSP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tLWW5Zdr;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0KRBIhNrsFaoYAcvZ0YP3W0XTTeCHuYd9glX8HrySn4=;
	b=3KXtLFepRuRICQp0oHDRPjOuvBh5d5sCRBNtyCbX1OIWvQaMAZ/ezxKeF6nktGZe0ckDCs
	Od1kATtE8qkwKsPGz40RNh7i41XOfsbb+JL5xTgMB5NAg6CVp7aYMTmny7dYQ/SIYtfvxU
	ycCO+x0E5Wzp6jOtJA3jy2aIDSKnmsA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756724941; a=rsa-sha256;
	cv=none;
	b=BEcrAzla5HLrbHjMmmuHqWargGVerVUSQhWJUgdtTCKY+3yNmlIM0ZgEC1/aGDrjpa/8Nm
	0mrrHjwjyap216/AkotHiNrAM5MskEKn7a6OcgS2lLXm7qBR0xGYspmpp9nPVPR4iHLvXp
	xGeg55wQeFhx7JfXPK2OYV/wSvXDnus=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JXEC2JSP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tLWW5Zdr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JXEC2JSP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tLWW5Zdr;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6468321170;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0KRBIhNrsFaoYAcvZ0YP3W0XTTeCHuYd9glX8HrySn4=;
	b=JXEC2JSPbAhghivVpT57oMvEpSklUDeXYRyjnFw0yUL2Adv/0jqVqXd2LWyEmhUOcI4tih
	ZMQbFVXtHX0pF+8GRqc3eqZxtij3l+T7pVjwLQz/NMQHpjXgV+cCY03UrogQ1HnMuCbGT5
	/5h+ITU1KJDdjzwLJBK7VPpbCCmOYSE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0KRBIhNrsFaoYAcvZ0YP3W0XTTeCHuYd9glX8HrySn4=;
	b=tLWW5ZdrYhhfSA1+rqSGfXbeA1LfUrViBljw5vxy5N1FPEKGTU2x0WFIZNtd1pwF6R0Vti
	I5BJONZ3T2iTqDBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0KRBIhNrsFaoYAcvZ0YP3W0XTTeCHuYd9glX8HrySn4=;
	b=JXEC2JSPbAhghivVpT57oMvEpSklUDeXYRyjnFw0yUL2Adv/0jqVqXd2LWyEmhUOcI4tih
	ZMQbFVXtHX0pF+8GRqc3eqZxtij3l+T7pVjwLQz/NMQHpjXgV+cCY03UrogQ1HnMuCbGT5
	/5h+ITU1KJDdjzwLJBK7VPpbCCmOYSE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0KRBIhNrsFaoYAcvZ0YP3W0XTTeCHuYd9glX8HrySn4=;
	b=tLWW5ZdrYhhfSA1+rqSGfXbeA1LfUrViBljw5vxy5N1FPEKGTU2x0WFIZNtd1pwF6R0Vti
	I5BJONZ3T2iTqDBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4A2C013A7C;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uMHJEcV+tWjtDgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 11:08:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 01 Sep 2025 13:08:53 +0200
Subject: [PATCH 03/12] maple_tree: use percpu sheaves for maple_node_cache
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-maple-sheaves-v1-3-d6a1166b53f2@suse.cz>
References: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
In-Reply-To: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Matthew Wilcox <willy@infradead.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, 
 Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, 
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3FA98A000D
X-Stat-Signature: p1wssfs3xiriuutyohge9k74n64qe784
X-HE-Tag: 1756724940-889353
X-HE-Meta: U2FsdGVkX193f85zifXbXw5hcH8R1UY99HkRJJh3fTT7OwRzA3BKHDF1dmj1i1Qgu26eWOR4z2/sqUxdkn2/KeZ0fiETkIkM1q6/fCxJ3E7g0TMYxULvUjEd4uAqchMzE/r+b2xNarp67/7fD52Ocf8tzecpzNLx6vqovNs0lOjJyLALNPDzz5D1PsLGFPiOXVSf0B5ps66Hcq29IOHhd2zISXHV0rfaHR9EBuP2il1Ie45BayIofT+jseFr0q1rgUkoHJubP6co8iHfkEjbP6xKg+7YVSYXhZQwL6yo9YlP0BTkqMN6RmjWeej0zxUa5kDWdfa+JJNqJU9+7eNwhE8EHJ7JSxTawsqaw62/E0TZdHPR/Zx4Kcbk+o2m55wnmPSviUGeCzjWV0jFy1tR3o2IJ7ePVRUxu+MTcjBP2Pm0WcnGzHpLkSVdfjtbyY64Q697Wvqrz0IvWJmzgKYKPwwaYQW8b+deTV7KDhgYjkJAy66HSPXkwFjyXYqkvntWygjGnAutiew00PQ8d/VlMQpvPEukSladc0XQGyTIyGNPBMp8RQwhaAjGmtqBf5WUydcpdDzkk1CptEEGBqhnP01DWQKmnml/hWTImFR2KuM9BlxNiF/O8F07DEGNf86o7rVN5cFLWO4h2lQHWr6urYnSjkY5C9bF2ff0LmveDkDVEowrb7EhofDZWzNZY2kgsBdkoRXIzytWo7jdW6bde+VFA/CosmvAmdWnhs2gmYpDgdJMJhkHnR453w20Sga00XiUUAq6a42RWCF3vggs/tz4WItMLE/iG+oS0B35r/QwbroAsH8VyVzMcLUSYSDV5HGQ7hCagRVsJ14Xem4Am+mLhfeQgCEcz4c4AtQSuU8ME22EHcrSoTGuR80qVhS28dT8cdLPWLV2WZibfsU4Y5/MM6Cr59OlF8utWCvyjuOTLIS5a5aCPSh99+6j7SMDpHR/cr+rF2KoBwxlKl+
 9oPngOkC
 3ZxiLRpZz3NFG13Y++g8NnjF4ktKcIhY4SE2J4+FvzE8wV9r9CrcZvkzqdXI0Wmav9Q1DI38cjLEMXOYKyLLBPHz/XTQ+cQJNqn7KFvmL6MbA1sQ1Som0uFxti2XYX7oG0tDMU0Dw5nXf2pGlbpJnVSrcVmoBU7/qoe9nwaWFq8b8+U0LcANiNvQ+/eMvhzYkrFEsASZGKclPuq0MJaP48VhcDYdOkvtLVpIXKnAl9P8ndjnChaxnwiT8FI6+giAHcDBjj/5CfLcB112ie/lZUIe5abEuzPRKec/SfMCCFjApRZCAp0x94HiYYU5KLBRU1MQz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Setup the maple_node_cache with percpu sheaves of size 32 to hopefully
improve its performance. Note this will not immediately take advantage
of sheaf batching of kfree_rcu() operations due to the maple tree using
call_rcu with custom callbacks. The followup changes to maple tree will
change that and also make use of the prefilled sheaves functionality.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
---
 lib/maple_tree.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index b4ee2d29d7a962ca374467d0533185f2db3d35ff..a0db6bdc63793b8bbd544e246391d99e880dede3 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -6302,9 +6302,14 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 
 void __init maple_tree_init(void)
 {
+	struct kmem_cache_args args = {
+		.align  = sizeof(struct maple_node),
+		.sheaf_capacity = 32,
+	};
+
 	maple_node_cache = kmem_cache_create("maple_node",
-			sizeof(struct maple_node), sizeof(struct maple_node),
-			SLAB_PANIC, NULL);
+			sizeof(struct maple_node), &args,
+			SLAB_PANIC);
 }
 
 /**

-- 
2.51.0


