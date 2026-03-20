Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77F021098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A98686B00A4; Fri, 20 Mar 2026 09:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95C966B00A5; Fri, 20 Mar 2026 09:42:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8232D6B00A7; Fri, 20 Mar 2026 09:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54A3E6B00A5
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 21F74140201
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:15 +0000 (UTC)
X-FDA: 84566555430.24.674C5C7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id D7EB31A0015
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kKiSRak0agp/qsjTYeF0a7XGFUIh/0Ujvc9vhIKtkHc=;
	b=ewi0hobwygq72+wpj/OcELR1g+FHksr4kKkc9td657W9e+ovIVrO2nOZl02ViDIYM2FGJ1
	tdPNv3iYWcZJqZMQu3jXbs3HSJUl0lniIS0botUTqFP5vRX/x83cma0orukkmYsBGhZn95
	x0q9iCmkSMtlHjnoYDG5NR4UjK8iM2Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014133; a=rsa-sha256;
	cv=none;
	b=k//ojgq3/h2f/1UZIctyPiD+GFsWEBh4MaJ37w+Np6AYL24n91ZIgN6xKn6u+b+7jLO5Gh
	/iwixhzrHdwhslkVBCota8vuFd3brSLQ7RmW8jkZU0U3expTRmNmS9gmC3AbYxvQpZnC/m
	UZIAUL1xvX37cBvqiUHVdFZDwcBQKT0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 06EFA5BDFE;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC94A4281B;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qzzEOZhOvWlXCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 89E72A0B4E; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 07/41] exfat: Drop pointless invalidate_inode_buffers() call
Date: Fri, 20 Mar 2026 14:41:02 +0100
Message-ID: <20260320134100.20731-48-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=642; i=jack@suse.cz; h=from:subject; bh=nIoejJMaV49gDfeiiXcXv5LH7VzUz9A7WUS7gjGHtc8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5yasYuc/oVgtRi89eW1ehL7CYhut2nO3al3 BpSIY98L/yJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OcgAKCRCcnaoHP2RA 2ScCCADbyrlhHTrHVqfs8gou1Q7ALFFXsr0JYh5zHoYogEoF8DE9Jqiu+H9gM0qHvlWQ+tWtR7C DjHQgemIsDeSwPHX2oxkDCVkG5ZuMGRNDrUFlJPugTxja6qVh3isu2iwEdWeHY0EpJ5hvzAwN+q P1gmgEVBbIeMufNmfZqbea7Fh0/PR/rZ/aHEdSnkspmb8AcDn8J4sMLvECHEgYjaALc5MPLVULv y0l+2j8RCTGdgX6yqc5U660NN4lMD/sm5if6lkj0YKB8iBhH7OyMqBlOqV3lpPA/DlIh9LB/isk LlxrEz/xx1EO+3iS+2yRxEWzQlm6WcWD3SuExCvDxebUTted
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D7EB31A0015
X-Stat-Signature: 8debm3ozh66ohrxeb5hjs8a9jxfizhow
X-Rspam-User: 
X-HE-Tag: 1774014132-889717
X-HE-Meta: U2FsdGVkX1+kyzxGdIpvuNNwreuqKd1hc1q+9s5c1oPxCDHCwbyjybehVLgag5NLAiYGdAyRnxqVfUfE9luVRLBN8Mn7NnTef5xEM5ZKH1OLY+c/ztJCdvjDgSJjRnUqX4QPYoES9GAmqPBTzK6DIRbswvA5t0wqfgsL/CS5/LFhScoSAjSMDkIGwX4ovfwa/1IRXdB72YIpZwPoiFTB4vI2e2hdse/AYKee2amEigHv6hY5lfQ5XSbuZebt7zVzBUNC5ICAlBKtknzioTXocqYosr9+zilcrx/+ds0fFbFdii3OwPbjn29shiOFKgPTtAeW/mH3utEJquGr72iedXML7v0ogu75yw7FgHpH2oEB6DGj7iKH825OPf2LoxuRoCCrfK5wRzNLAWWLtH3UBQbQS310N8Hd24mtGkQVVayLk7yo147yALQZhPc6o++bI//gy+Wol7wZW5q7NQdZBshLSViS8jQYjAmVQ3bQbxX+FlpdG6l/IdjvHXFXqrjIxl0D24VmlBukHOUsQwUF1I5G46fahGXyQJHXgYoaYWBWHpDwVx7lnhOPC+TXRqW6CQuV9VIIA7jj94iLZeUkxoU5nnSvuSUDiEha3HcizcWVLS/mYGKYQASt2WfDKmvVNr9HtNLTYRNFz76jllOs1rNpqww9VPvnZkp0DKh9Zo/q9qzH/tiLr1c2aFQs014HCOsV/1mR6C0rxON3A8yGXKNoZwh6knD9rweKNOK+cZmi+2sdtNuZq9nq1RBzFmU4rfsoGK8FM/pWJikjAmlKSATTGt/qmNXJsol28RXwq9jyqkAQnH9IjWBpTLK246bO90tkHrBRZcLXsQ/0joS3fij1X9qS3iKeVOW4a3GRtugteaGuuSySUcTEoHoPQHEm/nVJvscIPEc4xPtjV9jxRp8IJR3jJnHxWK2pmmLCiQn9fNmBLPzLGrlB6AbwI9JSiplQsWjlU1i860qc0F1
 IceWwuTc
 rOn8ddarg1zzmuqJ4iMDDiPUgeN3FUId8lhyApa+UjukGN94tgbJfiqZ/aH+tkEviWLCTLUYjDeRkNGBPSbBBCR4x0d1iSmgziPxAx23aAPyIn1Ga0z5w+32hP2NnWoL5S9753TVhM8Lc9FsLiFEW9Tu9DwmHFzvYYpbaM6RL+yhhUYOlYYkc3T+HWUlVDAlQZptI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

EXFAT never calls mark_buffer_dirty_inode() and thus
invalidate_inode_buffers() never has anything to evict. Drop the
pointless call.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/exfat/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index 2fb2d2d5d503..04559b88482d 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -695,7 +695,6 @@ void exfat_evict_inode(struct inode *inode)
 		mutex_unlock(&EXFAT_SB(inode->i_sb)->s_lock);
 	}
 
-	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 	exfat_cache_inval_inode(inode);
 	exfat_unhash_inode(inode);
-- 
2.51.0


