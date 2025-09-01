Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B58FCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7239C8E0037; Mon,  1 Sep 2025 07:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ACA88E000B; Mon,  1 Sep 2025 07:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F8A8E0037; Mon,  1 Sep 2025 07:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 43EDA8E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:08:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE45385EFA
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:08:57 +0000 (UTC)
X-FDA: 83840409114.11.AE5507C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id E5054C0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:08:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="I+plZ7C/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="J8/V7o8t";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="I+plZ7C/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="J8/V7o8t";
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=feUOntQoitUe7mPlmKZms9YiTw8kD3bBDWarz0bQ+B8=;
	b=UpGgMg5e1uxRgngF0x2/nLFMzBNx0GfsIrGNQMoR4l1tN84Dq7aXpgI85SwwOLRNgESef8
	7za0ZTAJiW0NfWFmrqegQ1R1bohs5R1yLA0bRMd4oizNA0wdg8olCEcTRzlPbEXDCy0dHi
	KxniOk5KVHYtEd9nebpPR7hQXUlI+5A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="I+plZ7C/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="J8/V7o8t";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="I+plZ7C/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="J8/V7o8t";
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756724935; a=rsa-sha256;
	cv=none;
	b=LAE6BWTjv5tjDNwj55LIeQX+ZhOV64CQDbQFJL8uNTmQaBRFzY6m/yu1+a9G6B+Fv67/78
	d+W0RnBoDlM+ZQINkznT/S02gV4XLsMTIut2cVbgpFIdmiw2/tPKBQRkrUEKp3sDymVBTy
	8/5dha2QaM5IBU1j1ZrvpgNUwgnkmwk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 383BC2116F;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=feUOntQoitUe7mPlmKZms9YiTw8kD3bBDWarz0bQ+B8=;
	b=I+plZ7C/i7j6SSn1V9IG+u3eTFEI5fgncxBLiuSBgfdbPBCnbjQakhASgZmVp8xFeOyarH
	llVba0qnmEKgXbsyKEGI5gM5xAqIPvyXpeatWEj8xf7d46rgiu0pi+i+GduQfNcd24JWqG
	dCnvXrVGi8AwAG0SwMa2LF3u3rIbPdE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=feUOntQoitUe7mPlmKZms9YiTw8kD3bBDWarz0bQ+B8=;
	b=J8/V7o8t0IKnVXn2OPDaVq7LyzGdfd6XpoMhRzdwYsDgYMgSe00do2GgU6OP8MHnrMUlq5
	5ZnHlczdBI4bT9AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=feUOntQoitUe7mPlmKZms9YiTw8kD3bBDWarz0bQ+B8=;
	b=I+plZ7C/i7j6SSn1V9IG+u3eTFEI5fgncxBLiuSBgfdbPBCnbjQakhASgZmVp8xFeOyarH
	llVba0qnmEKgXbsyKEGI5gM5xAqIPvyXpeatWEj8xf7d46rgiu0pi+i+GduQfNcd24JWqG
	dCnvXrVGi8AwAG0SwMa2LF3u3rIbPdE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=feUOntQoitUe7mPlmKZms9YiTw8kD3bBDWarz0bQ+B8=;
	b=J8/V7o8t0IKnVXn2OPDaVq7LyzGdfd6XpoMhRzdwYsDgYMgSe00do2GgU6OP8MHnrMUlq5
	5ZnHlczdBI4bT9AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1CCCD13A31;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kHi+BsV+tWjtDgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 11:08:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 01 Sep 2025 13:08:51 +0200
Subject: [PATCH 01/12] maple_tree: Fix check_bulk_rebalance() test locks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-maple-sheaves-v1-1-d6a1166b53f2@suse.cz>
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
X-Rspamd-Queue-Id: E5054C0009
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: j9jsmgg5omqf4zi4dokxbhi9yf69rh43
X-HE-Tag: 1756724934-8557
X-HE-Meta: U2FsdGVkX1/XMtg0I5qPAaSW/rRA02piI6WL2Ynfcy59bCZwe5F8TNOOcJEECnflI1To6jpbgEQ9eySvWMP2mF0aPAWPsh0dTOJlyfIJPYcS7lEQgpQ2mQW5Ik7USASzQ2EulxMnsCkTMACUQH0x/ricwtagP6S3G02TfRtOrLsc9giP34VZjI9Cw1CWRpUTE6yvCfLdmogEYB8J7rruU02OeRtKx+gAbv5q9/Pi7TFeQ9b7+4JG+XujM+5Pr9pgfbJWqtt5Byl6NgdXg6WHrv7Sdb01l89KlWM6Uj3VeEg2lkW7i9KSE5h4m6fmxv2iDpt+nCEWkvDpDc5lhTudZ2k0MA32OAbUx9ypzRKiXe/hTwKvhyJDZ04YWI8ILP9h/50wXokYbP2fkFTnibm2i+gCcA+bLksQcx3LjYOVU+rxNpmOuwqTU9MH4qM/ekxO1GHJIlZcDaYG1xAG7E1y5rI958CWuyU4BDVvKV81bGt19TGGNQu3p5sqh960b5yCEykvUjyNB2FYr3BK3qynjK5FmPTwfPvSG4v04s/LwPb4JL4byvqcpdc/u/8oIJq2AYaA7/Aa+CRpMXQCps1MO+TF/pe4vja6aqJ6ykqfNg4kUIOJcniTkVqMbGxZZ+oYvU+IMxBgtjv7zj46ySjuRjF1VnAwP4Hd/P4VD+b5OvXTWe4OrXBOzS+pSgwFsNUP+afmupIDVCcuj5th+7qYPzUYuXRD0diRuuz0iquk+4nmnhcBghTWtK3ufKUZ2sGyFNg+1zmbhEGASYijA1G/7lcix9+y4yk0u5e7uLewtOMayP2v8pUi5+YQBG0G+2kNItFTlksVuNWTBMCoHxJlRFb2Zg6KjGD0vvPli9RlV0d0deWdvdQnC6BTVYx6MdApSLSMOdpBnTN0OZqgklPe+v2ga6F81tRIUNHzvCE7d1bCG2rb//sgwPe0LIaGJJIz8aKCXODge8Per4ktN26
 BDsA826w
 NVYZiiP/VGeootoXWZmZ4HqpeyFVj7kgW9aMA4g55kDDmXIjOhiol3/04dbM+apFnNynx3IQritq2/ADKOB0WoBsVP/QKZkRYJJODG4DlJxbdgcWyLc/dFkWE+uIjJW/rh3p4bG7IkWwfh4z+D02GEOdbW9u2dOsT42OT/cDi5deShMIQGmzxSTIr9vAQpsS56a0QzuMtgUC1JBXqtTbLksN7p7EXCdANsKqQ0LnQ6f/2wUtSaL0pEg/0baF2uE0WwzAZPMVksFiiZfJ5YoT/5G/RY3okPVPE+2NpahkOHKQkaUpzKt3AhApoePX51gKDcEaSrfC8THmfIVvtMZz3r8IEaORb7zUvWTusU3r1TeNBKm81qKKcSLzCUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@oracle.com>

The check_bulk_rebalance() test was not correctly locking the tree which
caused issues with the sheaves testing in later patches.  Adding the
missing locks fixed the issue.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 tools/testing/radix-tree/maple.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 172700fb7784d29f9403003b4484a5ebd7aa316b..159d5307b30a4b37e6cf2941848b8718e1b891d9 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -36465,6 +36465,7 @@ static inline void check_bulk_rebalance(struct maple_tree *mt)
 
 	build_full_tree(mt, 0, 2);
 
+	mas_lock(&mas);
 	/* erase every entry in the tree */
 	do {
 		/* set up bulk store mode */
@@ -36474,6 +36475,7 @@ static inline void check_bulk_rebalance(struct maple_tree *mt)
 	} while (mas_prev(&mas, 0) != NULL);
 
 	mas_destroy(&mas);
+	mas_unlock(&mas);
 }
 
 void farmer_tests(void)

-- 
2.51.0


