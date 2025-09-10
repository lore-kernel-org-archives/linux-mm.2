Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68440CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEF9E8E001F; Wed, 10 Sep 2025 04:02:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA10B8E001A; Wed, 10 Sep 2025 04:02:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69088E001F; Wed, 10 Sep 2025 04:02:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EEFD8E001A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:02:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B0CE13BB2D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:02:05 +0000 (UTC)
X-FDA: 83872597410.12.61796B2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 62F3718000F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:02:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LodN7bzu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+Y1JntXq;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dlC5rsgvDhfAffIlycTkJFaG9lSl4Vf5QxNcsetL14c=;
	b=MKvsemhwoH6Ma07Dh5Fbl/n3Fa49yt9XyJY3VqB1HPT1ppFjr/v2diTFyQSe0gAgyB4+9T
	V4dYGO1vd2UtrttD+57U4kk82GdzTWx6shs2uRGUtL+nRzYw6+Saaws3QDDKzNiTOX0vdD
	83OkMJYt7/a1MK1LWq2BaD79eEGhjvM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LodN7bzu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+Y1JntXq;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491323; a=rsa-sha256;
	cv=none;
	b=ZwOe/IzO+fSd4NUP/+OeCqjmHuLieZCJKyTQa6DOjetuwacC/xHuypqNKVFZUSwS7XvEKX
	iz0JKYtJvTfhjB2/YbYoiEaAwaTMljD4K911uVSYkN73yUAI1h7tD9yrOm4LpmpcGlefKT
	8NdQ0pIHjkDookfSVXnJW5FzsZkzFlU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2AC845CAE7;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dlC5rsgvDhfAffIlycTkJFaG9lSl4Vf5QxNcsetL14c=;
	b=LodN7bzutE7Li/V2EfwBNo4CuHvBVnPrKn7N0CJHxkP6oZ+sCh0VtaNamgRGLIEbFtrTwE
	dqoK3vZjGYZGlxgQbI3hFtniCG7KYYOmMENRmFlAPyfSHh/S7FPOKdp4qEN3Vb5EMXCcDy
	SFOg5lKQvKf9w2qVLXoVh65hgGJguOM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dlC5rsgvDhfAffIlycTkJFaG9lSl4Vf5QxNcsetL14c=;
	b=+Y1JntXqx0cxt+zFArNgueEShnHg/9pKpuK+RXieCuu5zrPcCctkmAIBa1hgYTY57coLkV
	gn4XLtuRcRGskUAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6605D13AFB;
	Wed, 10 Sep 2025 08:01:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OACgGEIwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:06 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:11 +0200
Subject: [PATCH v8 09/23] maple_tree: remove redundant __GFP_NOWARN
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-9-ca3099d8352c@suse.cz>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz, 
 Qianfeng Rong <rongqianfeng@vivo.com>, Wei Yang <richard.weiyang@gmail.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 62F3718000F
X-Stat-Signature: 9tabtw4nxsq9ttzixh9o14n8a9rstezr
X-HE-Tag: 1757491323-30090
X-HE-Meta: U2FsdGVkX1+HdawXdhqElUHvTOK4dTSRADStjzZuKT+iaQS+Wsov4jSbadJAJLUMWZql3cPeTOT34SPEuoOXaIrnj+tsRO/Q0jClPM0o99UNdfkV11EEJSZDgTcSSz4cKJEbv1+hSpxYNN359jRiXRCx6X8hbtuJS2MjheKiARbYzp5ggurHoJUaF3MNqGZ2YmOnTs78agk0Rret0yj03CJR4nNhFj66eB5LjCxC7WEiN5qDlYoVgZfljyKUOppgxJpQ2E1NpoiFXyacduX/MCd3iYxPZ+kWQdqmwSH9ZQW1Q+NHhpiPYc38MApmzSE/HyFyLHEIFfo52HjiQafaNOAYndz1qexYbawPiS0MMYtKUo9q2uec/lgVPirGvJOLSGEf4QC8zNZLPXt16bFoJ49K+6/Jhm6UzaUuDuFTeMfNTXZ+bmlCwgx5ONjFnyNZGZ0V03WkARIFy581KvQ3+FpePdlu+tiYZP0yq+zg66SpAK/ca0DR1OvxcNwWBZ5yBIGoeVF/OocQtJY+IFtkmL9ECk0NfqqfIJMBfWk/Iku/3DLzIln3WORO4/XA1gXJbTM5j/hXVpPHXn0wGDcxN24XJrJvp4zR+Cv68iLaiZtSYoQ0EyKaa/Go7YqUNdLuNmfJckNtBA1/l4uPMWZuQHgna+9eEBdc9qWXEHhnNsDdFXqrh+S3mcPppak66PdbHjf9mzRnH5BNeokX3mzYtjntoEWFgV01kP79Is3CyjT2OKxMuqM2PSt46e53A4JrY+0Iwnt4dYDG2iOK88KbKnS7P53am8o8RSGvk2Hyy1YcQOrXevwSgYC3CqI9zDZoVSLPl8iLyVX4PplGtGucoLqVkvnbOy+kp8UnILIr1tlDorQ3jBMIx5gm2mm4cTHNyQIKIYrooIgBUG7UWdbC+gt6WvI/P3QowRdYQhGHO+7BsgWRNCtC5NGlbXfhMa9I0auxUz1/VjeiuZpo/pH
 tTq3szkm
 08WfkLlCyBdIL4pmnWnWV8Wi9iueJw27o2Nl1SQyPDoMwi+A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qianfeng Rong <rongqianfeng@vivo.com>

Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
GFP_NOWAIT implicitly include __GFP_NOWARN.

Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
`GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
redundant flags across subsystems.

No functional changes.

Link: https://lkml.kernel.org/r/20250804125657.482109-1-rongqianfeng@vivo.com
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 lib/maple_tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index b4ee2d29d7a962ca374467d0533185f2db3d35ff..38fb68c082915211c80f473d313159599fe97e2c 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1344,11 +1344,11 @@ static void mas_node_count_gfp(struct ma_state *mas, int count, gfp_t gfp)
  * @mas: The maple state
  * @count: The number of nodes needed
  *
- * Note: Uses GFP_NOWAIT | __GFP_NOWARN for gfp flags.
+ * Note: Uses GFP_NOWAIT for gfp flags.
  */
 static void mas_node_count(struct ma_state *mas, int count)
 {
-	return mas_node_count_gfp(mas, count, GFP_NOWAIT | __GFP_NOWARN);
+	return mas_node_count_gfp(mas, count, GFP_NOWAIT);
 }
 
 /*

-- 
2.51.0


