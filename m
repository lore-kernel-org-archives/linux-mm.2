Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB9FAC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750AF6B0088; Mon, 29 Jun 2026 10:00:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FA296B008A; Mon, 29 Jun 2026 10:00:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4576B0092; Mon, 29 Jun 2026 10:00:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3102B6B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:00:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9DD4E1C4AAE
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:00:01 +0000 (UTC)
X-FDA: 84933109002.20.E57B7ED
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2038E120006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:59:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=R0gL0Yla;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GBq+qC9L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=R0gL0Yla;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GBq+qC9L;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782741599;
	b=jQyv+lJ+fwfxpEVZvGZWbouDsErmhr0SHKIhau4QpFcZT76ctXj004zz2Eb4iWtjNm+rsO
	sMNYqInTNYDSSWULU9Vb7ERI0bQ/0hMvwL8TNfX5yqVfDTcpzZi7pgDzkEIL/GAQveNJbJ
	BqO/8oZDmf28m4mxricaDpB1oyPXKY0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782741599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HXUn/skYBK8aJj8HVng3ghz4cKHlfvt0ni90/AGCenQ=;
	b=5cgJyFakfRaKjSdjEk5Th8fllqewduAsdo27EWo9hbbabsBPwxN16CJ+q7SJ/5TqGFTEOx
	K4WTOhGQmh6q5XkyqjdSfwZn2MrQ2sQRk05mEa9XvSCy0ngJsrs/rfGPex4uogh1spLKB7
	iGobLPFuj4O9vDO+1NU5yn+C4V7xmb4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=R0gL0Yla;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GBq+qC9L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=R0gL0Yla;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GBq+qC9L;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 84FF775D1E;
	Mon, 29 Jun 2026 13:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782741597; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=HXUn/skYBK8aJj8HVng3ghz4cKHlfvt0ni90/AGCenQ=;
	b=R0gL0YlaErU27oLdwRJtcQlxd8hExaP8W0ZYXPohcGCk2RZ77oieV/oxACuQo4DSX0Wcq8
	e5qpi+FBxFIXA5V7T54JzkFYGy5QHANsABnjpZFuWCkiKjJXVjLC7r4zlGnxxookJporhz
	SFyz1ejGnQwVQedHeHiP7w0XkR03gxk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782741597;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=HXUn/skYBK8aJj8HVng3ghz4cKHlfvt0ni90/AGCenQ=;
	b=GBq+qC9LnnMKy7PJxONWLO0NX2zpFPTHGOrAJ76H0F0wirU7K2Z2M/Qi5kZM2gv7px8Ns1
	aNYnJaryvJGYAdBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782741597; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=HXUn/skYBK8aJj8HVng3ghz4cKHlfvt0ni90/AGCenQ=;
	b=R0gL0YlaErU27oLdwRJtcQlxd8hExaP8W0ZYXPohcGCk2RZ77oieV/oxACuQo4DSX0Wcq8
	e5qpi+FBxFIXA5V7T54JzkFYGy5QHANsABnjpZFuWCkiKjJXVjLC7r4zlGnxxookJporhz
	SFyz1ejGnQwVQedHeHiP7w0XkR03gxk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782741597;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=HXUn/skYBK8aJj8HVng3ghz4cKHlfvt0ni90/AGCenQ=;
	b=GBq+qC9LnnMKy7PJxONWLO0NX2zpFPTHGOrAJ76H0F0wirU7K2Z2M/Qi5kZM2gv7px8Ns1
	aNYnJaryvJGYAdBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 798AC779A8;
	Mon, 29 Jun 2026 13:59:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PGSqHV16QmqebwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 29 Jun 2026 13:59:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 16F2FA10B5; Mon, 29 Jun 2026 15:59:53 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	<linux-mm@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH] mm: A second pagecache maintainer
Date: Mon, 29 Jun 2026 15:59:28 +0200
Message-ID: <20260629135927.2586391-2-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=712; i=jack@suse.cz; h=from:subject; bh=Wlqkj/oorjMa9EnEOcNnNoyUHdi8vubwtOtrQc5rEYY=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqQno/ZSspVvgc9TzEOXMyymAVJRSjVYo8WB9RT v91itTe6J6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCakJ6PwAKCRCcnaoHP2RA 2VboB/4ytD3c0dYc41o1lN9k6tAX6PnzgXuKdDgFhfsNj9Ya3U7NkT/4FGP3ancJI123p5DyRZC VPhOtouCEmKnYg2DMl58VOGTlSWEn7ZlJ48TOp4JHC6xKn5TcPG8EZAiXaYw3/CHeLorazF7tlv evIky5hyU253cEe85lAXxgDrxRcOUTR91Sj/8/15rFlcK7avu+hYsC/f27A/4fBl66V+uYiZADh eNX5s5Vna1T5n6q3L1PSZE6GrwBgJBqGKuBcoAxVVEaeibLiICZRtUvYl/QWlUC2d4DCuxB7gON 94grAo8l2eQMZQgdSavRzFETcJbU21p2qt2W2WWU9cuz4JVQ
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: xos17xnmfh9564sk4owzgibrzacukwu1
X-Rspamd-Queue-Id: 2038E120006
X-Rspamd-Server: rspam06
X-HE-Tag: 1782741598-305040
X-HE-Meta: U2FsdGVkX1/VTt/EZUOdlvlqxz4lJRf+55h7oP9Rz2M67WI225+JA9QCLd7Rp+TsAL98aqBJdaZUMWHRyeOcbbI8igyw1LCA9reJi0AqqRB1wtWY7QjoYgJA3i0QJTySTsq2g1nDPmnjXLjfWi9iT+hG0Bg9HzsCdT6Twk8BSLKxiku/oUTfeIJZsTlCIdgQjin5IpQ5A1Wi1v93lp65nbz49j/ZFJbkyVMiXAqzWr2T41b7ItitMueuRtRtZKB1NCF50TVJnBo6BfXVE8xZPsJaCm6Em86D+2kpJV4Gd/vfS5mqsEiL5QDmSzwXoBLta5JTtpXv9BEAgFFfKCVOYM/2YwexArJijGVLV5x8vY1LRC3uzcPSWsLAOP2MYMUA5M1yt2O2S+Tv9yi0lFWLuLO/v19sm7UmyPFdsnW0o4z66PJrDAII/9lMkSs+jKl8ob+nM7t1cEgZyDorUm5qvKVys8lWO6JN85EsmunBWMTbrj7+Wot/3nsfKWGPHWd2x4LCTEUZsvs27IXgUdDU3GKyJAiHy3KelpN4bGxKrMLCtieXLx8Jx3ERC0VQtPAcDE9u9YpazudmqNqWOADkZSDdqwICKdT6qYdiNVX5xq4vW0jCQpbvtj5ee9QbkMDHPRzO9JKPGi6aE6VBQ124W0DCnl4mEXvYosDEsNAi0h6x/zwbXaGIyCNN6fntWQGAAeZoYCyGq3u3WOw1LAm0G2ZTRXiVKuXyg/Cqw/7hZApBDxlN9feBJ+0CcZ8XXlCOLodVHW9FSgmTZVAo8BPXGCjwkVgwVAvs1vz7hFNXWWLtZq8zApvzctaH8XRcZxKDO4LT48oxT3e3V8hnRlLE7txd7q5vRAJNWicZUirSdfL0cbiyfApoxb7efc3As4zuSYPyNl/ZODnQqNRF0LIAxtIreDNPkQK0ChhuA0d0lE2GxJKcdYSg79vZ6U7faTcv/EAqaJM86lZkQhkJIIU
 IY7A4w05
 rQ4i4jURm1c9uU+aeqJie9S6DjuwbEt+rHxS7PTA6LDb+AzhMxCzeHM+SsRf9FtpJGl/ExhE05HpWsa9F4ZQGunz8a1WlcRtDCyRR16ixHTd4UIUYYS4sTr3ADcHCRaVNTXGk+Ad/kO1l6ZuU3xvHyOoI5Ca0w+ajxjS+taxC/oNiGG4erJx28i3ASmtzoQZfCHz/1TQFk+4Yz1nenggsJpaErglWJ0v7dthv6HFIdSVGwHYydBHX8QKLBpunk3bit9jU2AFEypLTGqSgfp99ZjSN97I4AiJEmldxmQR00kAQGkSOlOAypWVsu3EihubGN8/uno2JCPHS1FiyHPT65jEBAL/J7OHv5iVKGgwsx+I0wZVNEN3wFCGP5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As MM is slowly transitioning towards a more distributed maintainership
model, we agreed with Matthew that I will be a co-maintainer in case he
is not available.

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 15011f5752a9..7d992e288343 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20405,7 +20405,7 @@ F:	kernel/padata.c
 
 PAGE CACHE
 M:	Matthew Wilcox (Oracle) <willy@infradead.org>
-R:	Jan Kara <jack@suse.cz>
+M:	Jan Kara <jack@suse.cz>
 L:	linux-fsdevel@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Supported
-- 
2.51.0


