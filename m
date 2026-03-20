Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C57401098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 628FB6B00A1; Fri, 20 Mar 2026 09:42:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DBE16B00A3; Fri, 20 Mar 2026 09:42:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 454B36B00A1; Fri, 20 Mar 2026 09:42:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C43A6B00A1
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0546E16023D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:09 +0000 (UTC)
X-FDA: 84566555178.16.34C3C86
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id CF5F3160004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKch3cA360fq6oe1hSv7172yeidWMBNx7GuKOSTC8+c=;
	b=rdjjBXeEfVcuM5lgd8js2il97uM5wJoxTg9JqkkMEg8F7MEoohHMrahoF1bUhstyDXm+FB
	SwnF1Y7ObVr+mLcNnp1xIFRp/MlhuPTptFC63vO/UlquhKGIKoQ+VXhKY9Tt8rk0rXGAzg
	MZdKQacWYIgJwQVOZs956Jmg0b/6Cio=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014127; a=rsa-sha256;
	cv=none;
	b=y6OiLSCdBgl8S+sFWzjdTLtdJhlYBE34b1neiu/9FVTY2A7rVaVXamyE4dZQ4En+YgRVLi
	tVDl2tqBuOCvq4xusDxJDBB4rFI7BwLBU4vi5gVp8QF+vD0Ia6Opd9Og9bwKMEExNgjY6/
	5sdLT8fowRUKMyviJ4p0Mw4pt5O92uY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0464F5BDF9;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC89C42819;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6za/OZhOvWlWCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 81C92A0B4A; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-block@vger.kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	<linux-ext4@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-aio@kvack.org,
	Benjamin LaHaise <bcrl@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 06/41] ufs: Drop pointless invalidate_mapping_buffers() call
Date: Fri, 20 Mar 2026 14:41:01 +0100
Message-ID: <20260320134100.20731-47-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=595; i=jack@suse.cz; h=from:subject; bh=RkkBpF3L87rXPRrGMrmQZXeEBfTEFrhE0WIyjhBNgtA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5x1WeqiG0jNa0YkM8N4dWqoWPubtNi4LGzk SOQHx+qqECJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OcQAKCRCcnaoHP2RA 2am1CADHew0GopYyiq30ItPAhV+oZoPkZPa9CPzEQKSw4r4HN+iVRkJp3k3Q3ik4UIxQzC7hD37 Vb/61LnMaqwohPFzoteJ/pvw8TwKEid13EcbJ4kYM6jg58ZE9DROj4xBsiH8XJeyI7l1Ac7qvwg F6taZ628Locbt04Hp4gBQFB/u7b6pm5I+4zb555RJ5jHcrQMBDZlJt0u1X9WbEsJjkAAwPEf2Qq 5xI5qBVskv3riuTGkLuP+r/5jLVwODXPkVAtxSSEfAfNHnUcK2sBEovCfvW8jT+UAZYt4/Vmhub bWXbwrAfcLW1o+CUTXG/hlAtuMsHM7WZStmfM5JjWCYXoNCS
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CF5F3160004
X-Stat-Signature: hw5obpjb661yibddui4rtprjjotxff7s
X-Rspam-User: 
X-HE-Tag: 1774014126-585041
X-HE-Meta: U2FsdGVkX1+ZXRJM+tfNYma6YQwc8SoV1ZmIaajSvEG7NdbS48YAdn4C/tByr95okd2EeGOWFIJfhg4MCIR/jQ1B3zKBX/QYADWY4lvUoGzPQVtZ6XiARntWLtRlEapFJvHv9LBgyqSbEa7P0wrshRQh1q4tjJdMNVYr63WDvkxRiZBFb8/jBZwYGBFrE6uTC0QTLieNoNYWFmtYPDI8YY6b8+xCxITQfRUPvQKbAwE6ILn6X2AdORxkryBRnu7fpH72hgLhAwxeUwbgEkZ9Wlo6Q7dEozPejX+a04EogQRv5q93vcdpVjuUn2XNjkHR0pVmVaymg1TyoWNsM1X9OF1pWlFLq7Gr2cDf3GnngYeQcQdTDDWjQDqcxMxdh14/m1zlyyHRPjWZ82X+q2+ONIdjK2KBs8vbInvVWijqKbLhushMkcN0eSfufB1yoBCZaqt6+xy+4PHi/1QCelrPb9JINlv7vLJoGS8+uKMaLayGxzbJEBEdn4t6mQ45lEh9fTc+uPHAczVdDJflqqVdyC1bS28ztyXrWbtZ/8uqMxftT6BjW2m3YKo1+8fhhkg2PWkM1paLV1HCtgUvrq1Po2FMWlArryhHyHALu6DH3WRo15vidazUafczZMZHKFKYk+VwgRlstT0Gm6oQDOznc/nPBFqwxltvNuEac4/rDLxTwdtyn2YW+7W+69yuySvLGGYgwOwWBjfiH0VOSlgwPCViQN5N9V1UliM8DIi5tZvN6ElPZE4gc7H3Nvm2VB2rrrChS1JaMjnJhfx/sdFO1NzCcbRldx1H8j3F/putghbjWmbB2ubaRvYMY6U6C78HEBAp4nUPISuthVc9L9UvkKt5M0y75u7ueAvUm7ndW4wmDhj1D8bKfMpMLwdTVNzJVY9eka/ExULeq4/yGS1FOceJ1baFklIv1bUitBWtZMwM4OqFvMpJi/r6ohuBK+ToolAudrsk1aJ5PO2gah0
 CMX90UbJ
 eJdamGUqjxZV0E38LQtSwwuKdhWRekrWnaxSe4O+2JYsOQUVjX5tVVNmf1My1otRRIsu9SIKsbaklogBzu6f+TkGS3rkUTO+H+WI+tV2+UDsmBJ54zlSqQY6wEHDwWy07DiILFyE8Gh9/ztSxKPqo+3KQS3naerSgHjBD7VoA0d1HCk3PxMWUS40T36a5VIv0j81x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UFS doesn't call mark_buffer_dirty_inode() and thus
invalidate_mapping_buffers() never has anything to drop. Remove the
pointless call.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ufs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index e2b0a35de2a7..77617a31d517 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -853,7 +853,6 @@ void ufs_evict_inode(struct inode * inode)
 		ufs_update_inode(inode, inode_needs_sync(inode));
 	}
 
-	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 
 	if (want_delete)
-- 
2.51.0


