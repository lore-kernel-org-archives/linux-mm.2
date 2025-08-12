Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D081CA0EDC
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 16:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098E18E0167; Tue, 12 Aug 2025 12:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41EB8E00B0; Tue, 12 Aug 2025 12:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB72A8E0167; Tue, 12 Aug 2025 12:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BEECD8E00B0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:21:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 800C7C03DE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:21:36 +0000 (UTC)
X-FDA: 83768620992.25.048CDD2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id DB33B40005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:21:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gpPVVMLP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9WvZBY+0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gpPVVMLP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9WvZBY+0;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755015693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lf4UXJNFktuHhLrkAqGviaiOGJGDRn0u7MGzFHCiLBI=;
	b=t3bakb4S2bI1BT27NisnrsSqEq/lsLAnF7wBYKU26//s//xjgo/CXNU9761woxW5u7CKB8
	O35qK9n9ZA5SuI8dRxDFd2jSBiSGAyl0Z9tiPz/Z7nHfdPsAe+swblCCYEk1KmZb6bNrUo
	WGr65kKPxv4aDnBmGO/ZeOdFrGdSyf4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gpPVVMLP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9WvZBY+0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gpPVVMLP;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9WvZBY+0;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755015693; a=rsa-sha256;
	cv=none;
	b=NsSgGX61OyZMfVWZnKcxzQQP9Csi3gh0x/r3Lwy1Dc8jwsxXlDfrMnIqb8+GZYddP+n11s
	0H9ZSO3Vn/tfdvvIN9lYipHdDHkYF4XEOO2rLuaGAP437mcWH/AvFKIIzOLqOk2OuPzpBc
	pBVFZYmCGn186uiZqSgrCPv0zLTcBe0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1E62A1F390;
	Tue, 12 Aug 2025 16:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755015691; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lf4UXJNFktuHhLrkAqGviaiOGJGDRn0u7MGzFHCiLBI=;
	b=gpPVVMLPhDFut0H+ebndSd81pOCSzFedUQF3wAy8DW3FBq8NbhZe0Yiz1ot72foS7v/cf7
	mt7eOUV/IV4bn2zx3HT82cpnnmlyiw5cPjWWGS+EufwfXFecXvjiP3ngBO8c3l4ptHEXpr
	xEe/Wc/vWyqI4Z2GO8K/+xycIxJCb6U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755015691;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lf4UXJNFktuHhLrkAqGviaiOGJGDRn0u7MGzFHCiLBI=;
	b=9WvZBY+0egmTrc77DcmH/Z9uHpoX1aX7wT4n9HJws1/sOTpuX8E6sEpa2tgyRPbqdNjuIg
	rdC0Z8lAc8E163Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755015691; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lf4UXJNFktuHhLrkAqGviaiOGJGDRn0u7MGzFHCiLBI=;
	b=gpPVVMLPhDFut0H+ebndSd81pOCSzFedUQF3wAy8DW3FBq8NbhZe0Yiz1ot72foS7v/cf7
	mt7eOUV/IV4bn2zx3HT82cpnnmlyiw5cPjWWGS+EufwfXFecXvjiP3ngBO8c3l4ptHEXpr
	xEe/Wc/vWyqI4Z2GO8K/+xycIxJCb6U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755015691;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lf4UXJNFktuHhLrkAqGviaiOGJGDRn0u7MGzFHCiLBI=;
	b=9WvZBY+0egmTrc77DcmH/Z9uHpoX1aX7wT4n9HJws1/sOTpuX8E6sEpa2tgyRPbqdNjuIg
	rdC0Z8lAc8E163Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 889E21351A;
	Tue, 12 Aug 2025 16:21:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z5MsHgpqm2iCbgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 12 Aug 2025 16:21:30 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH v2 1/3] testing/radix-tree/maple: Hack around kfree_rcu not existing
Date: Tue, 12 Aug 2025 17:21:22 +0100
Message-ID: <20250812162124.59417-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Stat-Signature: d57qaj4ye634ixhw8zdakuzzfo468eku
X-Rspam-User: 
X-Rspamd-Queue-Id: DB33B40005
X-Rspamd-Server: rspam05
X-HE-Tag: 1755015692-842938
X-HE-Meta: U2FsdGVkX18iCZOsYkqwdfkIW6FSh5WSug/ClCDETIzjNm6YvuBYNhEcGIGbA8lu59rzHFXGv3C5V23+h5SsYIhr+PP3BD/vK2ZX7eny6reUnBHHWBCb8f3Y88tySrP5cLZF551w4Uv1Bfg6fxQsZz566FiajlIbrSqWmIILpaVdLIsnDUnq0Rj7EKjLgOKVyTMrA/rgJiaGU1oTxvtBWXVUVpx8++kGUpwz5BYy+Pdw4OMH01srLVEUKFMp3s8AZynQo2sffRtbSlx1cJw2hYW7kgp2uvLdWxBpVRPLxgwMS/XGA5ipp1oAYTGsWLbKotzZunwBZyCcv0BoR3Q6cy3B2qE49u0EWpAcvr2vgZF7kp4RJcrglWgd9PjsRNgqfjx3khV8+pBTZQyA4wqNSV3/c2PW7nvGZqlm2Fx60qEp718VfSUVsMqcqWwCyQ/+qwcnT+2SqzAri4vJTKNPyHiiWfOyoITmDmMsKINFT/8Ar2Jd5UkCv8yOxQEFLoonCziCOfb9sZjkBCz/eJaYRGBXwdyLiQmZsGp7uKjVpNX3ttXFitRyO3oXUHNHxdkUsOoSkOrVNPJ7uzsJ0CozVn3XACrGZy9yF3lD3WkZUxIRjctwlxJDNKugWK1zZdjDU02uNb7tPrxGN5BCxfA8z+zoiSLOUO2xrRy2JdURiY/qczykv1QJwF7MsQEdrzkeddSm11z7A6RNSFrEsYA/09wVoUGZDd7c8KdizK9VV94qMyPfcXSuvD6+L0n7abzVVutVqwPUhpaWY8xAflQ3uxb4jRwNrZw1CnHDEO1AZxmEIlSizBEDDJy6elJvDAxTzEacB51Sl4k/0Tu40zRRyKQcwPIT9z7vjdyUSV/nqDHrGmYnP5Q7Osm1bDRKrnXlB5KBZqSkeLA1Oe8EzmVV2iRe6WFf/t4/qmmUwgjmMTpAlNIdwHUlTtqIaLmBgrtoEggjOXhVL03Vem5Rv67
 G7jOwB0x
 mpPHgE8hzkERNcBee53c2MkFfA3rseVcElMZ6n1UyFvL21BJwWziOf/8Sl5pXGVHZa78COCxpCt9t+hA4Bp7vw9kV0jG2BCk/pPNvlyKqMGID0NeBRgR9+uG9TlNBk85RPwObaxEnL+RV9z5On1y7a8MuQcW1WqZl4ePkAErP8eZvILT/EcW8mFRL1Hrpnibw80d3lqhw+A0TSyQI7wnf1TDCvPr512m93aYEyPWD6PIwLRlJ5QeMDCJsZqMa6qJC0ByOgBXW4LUGPwpCgVU9FzfwP6B8dDZQ3jXxeByF/4WqYoS6bzI6hrSowjKt2eqcoK0TddGqg26fuZx7SMyCGvxEnRTDBPVxjyJ9wDTO8lpaN9I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

liburcu doesn't have kfree_rcu (or anything similar). Despite that, we
can hack around it in a trivial fashion, by adding a wrapper.

This wrapper only works for maple_nodes, and not anything else (due to
us not being able to know rcu_head offsets in any way), and thus we take
advantage of the type checking to avoid future silent breakage.

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
v2:
 - Move kfree_rcu hack to maple-shared.h, to fix userland VMA tests, per
   Lorenzo

 tools/testing/shared/maple-shared.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/shared/maple-shared.h b/tools/testing/shared/maple-shared.h
index dc4d30f3860b..572cd2580123 100644
--- a/tools/testing/shared/maple-shared.h
+++ b/tools/testing/shared/maple-shared.h
@@ -9,5 +9,20 @@
 #include <stdlib.h>
 #include <time.h>
 #include "linux/init.h"
+#include <linux/maple_tree.h>
+
+static inline void free_node(struct rcu_head *head)
+{
+	struct maple_node *node = container_of(head, struct maple_node, rcu);
+
+	free(node);
+}
+
+static inline void kfree_rcu_node(struct maple_node *node)
+{
+	call_rcu(&node->rcu, free_node);
+}
+
+#define kfree_rcu(ptr, memb) kfree_rcu_node(ptr)
 
 #endif /* __MAPLE_SHARED_H__ */
-- 
2.50.1


