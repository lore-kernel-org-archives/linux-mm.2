Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EFC5CD98D5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 12:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 687166B0096; Thu, 11 Jun 2026 08:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6627E6B0098; Thu, 11 Jun 2026 08:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574DB6B0099; Thu, 11 Jun 2026 08:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 486676B0096
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:46:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A1751405B9
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:46:55 +0000 (UTC)
X-FDA: 84867606390.20.2033933
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 14DF5140009
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:46:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781182013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ymPQ8m5TDO7NAs24k1Mtbd0+2Ruk6F0ynVxDYCOcYA=;
	b=tFqXxNAat1VHyqQY6f7chajk8XFurlKC0+ad+/Iz/HVqBe1GjhpqJYADxCoJbd1Q0TylYO
	mmHQSGACGY8ZUbLx7had6DL9/y8L0cS3VWAQdvcR+RCSVw+Sn7qr4a4hhucLS141jlZzoh
	IsYNZS+B3LlUBGtoQKVDTnLXk6ZncFc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781182013;
	b=dR2IfoadpxRP5kP6zFBm+lsdrQQudW8nC08ww6frRUHqXssbdvqelLP1v5mJVbiODJb9RP
	+39tb+ZTNW+Kl2tTcMgVuC8eko06bAk2+QDB8RhhWvpTNuTgrFJzEpjbvDQiLIS7l2foE2
	WlZe261LzfrLGgmEUU3TICy93cUTVAY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B33C96AF04;
	Thu, 11 Jun 2026 12:46:47 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6AC3A779A7;
	Thu, 11 Jun 2026 12:46:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qLbQFjauKmpaagAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 11 Jun 2026 12:46:46 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-hardening@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Kees Cook <kees@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH net-next v2 1/2] mm/slab: add a node-track-caller variant for kmem buckets allocation
Date: Thu, 11 Jun 2026 13:46:41 +0100
Message-ID: <20260611124642.345400-2-pfalcato@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260611124642.345400-1-pfalcato@suse.de>
References: <20260611124642.345400-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 14DF5140009
X-Stat-Signature: ux1dhm9m16bezpsfzhja8z4rmbxztsiw
X-HE-Tag: 1781182012-875485
X-HE-Meta: U2FsdGVkX185uJdg2oKlRY6KP9gH3sU8grYTuYr53P1MSxT8RJRoL1RomoAMP/aHvBuvxVurDWDiKSZ8YKeySgmhfSCT+Uv2McfeV+4z/INMTdG4xvGM6PI3De/gUpyv4D2brceGiELOhVE6u0zg4SsqbQKFSoip1OzlF60SKTjdUp3pgGwsiUk0R5P452wP7nRy20UIuRM11UREQ3S+PkF3JRGEt05LTk2DKjO/uS3eBvjZ8qJv1RtcaCniNXOo3XQbnTRAgOsVwfBBK/vVfBtcoCTPYLqOkhYfH+8bdIKpKfjyXguooF8BjPsvTFVKBWGERkE959ymY2wAu0sYRJVGWkRctNmTGYekHuXqKH227ATivTRmeaMKIuwH9uJUWw8X9NYee9V+3YfLStuS3xk8sDcpjRB3Rfwtex8/aIs/aAiCQfSOC4HbDyLAP3R7aYpuQo2qhPpUEK/v96RSB3Oi2Hs1D3q9QhNTT+Y76oj/FsmDEdFIMzzptEOR+OVi7kmybrA8RdVXs9HuZ5T56i5Ylvnw4QEb4bdR8PMDVv7RaNuSnxWpvjdgd16Ffr2M/lnuUrxVGegauLkG8UKWF6aV4bJEDSD6T1BJJZYO6EQfEE0kq4OUMM+a+/TkIKafD22vRMIMyNWwoEu3psZSJ1dbszT919Q9E3dBbYYdQKDhpIKDt2Llk3hUXypZGaCWi3ksN/NIaY4NyA1OGssOq6CSI+BxGqD7+fjT70Sjx8vMh2GRmsalA/bP2HKq6bsCDglV9o90l9FOmXQpd/CWz9vLUe2i5sDaVM55z5+GBHvSlbAFdLyq+T6M8urWvMubaHSSGs4UPSRrT4bFQU36Ei0eqBZZblDjk3P5dzpE0lAuvFCxINAFfmcE62tDzId/VEiCrK60nwz1uq0nkLcffBC/UBW1wHnG0gbPf9Km1jtT/+geaR0bYQl4cky84QsfTRdgnl15EecpnDlP9wp
 WfpLbbzm
 0NA8nFX85jR1rLP8ROxnO/VjJhu0I/xyhyfoHp85PUH3NYhJ+1eEYKEroFZyt7bBkryZb1FEFCvB/M0xzJgFYRWuy3UjYQxWbDjRCgucOKwpXBSf+Y+bAgogoQwH7+U9w1EkAB0/UsA7LmIwhh1Q3FjfAzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is required by users that want to use kmem buckets, but still
desire specifying the NUMA node.

Reviewed-by: Kees Cook <kees@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 include/linux/slab.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 7b46fa499b08..685a87d8f0c5 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -1153,8 +1153,11 @@ void *kmalloc_nolock(size_t size, gfp_t gfp_flags, int node);
 #define kmem_buckets_alloc(_b, _size, _flags)	\
 	alloc_hooks(__kmalloc_node_noprof(PASS_KMALLOC_PARAMS(_size, _b, __kmalloc_token(_size)), _flags, NUMA_NO_NODE))
 
-#define kmem_buckets_alloc_track_caller(_b, _size, _flags)	\
-	alloc_hooks(__kmalloc_node_track_caller_noprof(PASS_KMALLOC_PARAMS(_size, _b, __kmalloc_token(_size)), _flags, NUMA_NO_NODE, _RET_IP_))
+#define kmem_buckets_alloc_node_track_caller(_b, _size, _flags, _node)	\
+	alloc_hooks(__kmalloc_node_track_caller_noprof(PASS_KMALLOC_PARAMS(_size, _b, __kmalloc_token(_size)), _flags, _node, _RET_IP_))
+
+#define kmem_buckets_alloc_track_caller(_b, _size, _flags) \
+	kmem_buckets_alloc_node_track_caller(_b, _size, _flags, NUMA_NO_NODE)
 
 static __always_inline __alloc_size(1) void *_kmalloc_node_noprof(size_t size, gfp_t flags, int node, kmalloc_token_t token)
 {
-- 
2.54.0


