Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91FE61098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2FF46B0095; Fri, 20 Mar 2026 09:41:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB33F6B0098; Fri, 20 Mar 2026 09:41:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5CC6B008A; Fri, 20 Mar 2026 09:41:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D01E6B0095
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:41:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 33E121B7023
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:41:55 +0000 (UTC)
X-FDA: 84566554590.17.7FC97DD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id EA21018000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:41:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DAPLLtye;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ld8iMnlB;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7JZGRSCzVw+dnMxvlEGqz/JeWA6SU2+LFt85FuvrPTw=;
	b=eMaxmfZtOsdMN6u+4Aq8N+LThrSUdoQkEIOhreJTgvM38q8zBulOuc9D1LLxa3y3UmACL6
	057NW/6Dg8hwVPy5JX5DJHeaoO8sXW9LzWyhMapRP5x6Bo65XvirYR9NAfu2yGxXn0XqYf
	NvTivIAw4wCieNqhKvPwNzgLyUWFPOo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DAPLLtye;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ld8iMnlB;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014113; a=rsa-sha256;
	cv=none;
	b=kj5MEOSd60ik7miEtFZ6bCY/hWP6hWcmZ47YtA4ADuSk8iivXLXYZoANm9MxxK8EZEpq/R
	hueGx3OYakewCIRkgg8ZcopYJ7Bu13ifydoof/vZEvISHhvtPtN9j4so0YDRheqlVnlo5o
	A9v4Znjpcbuj6MqELhRu1vnknvZBu8o=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CB6524D1FF;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JZGRSCzVw+dnMxvlEGqz/JeWA6SU2+LFt85FuvrPTw=;
	b=DAPLLtyeGj8Mj4FG2qMIGu514EcEy0/oF8jWLsy8i1UZCVIwaI6nF0Ty9ARBCIkpNmxdVD
	UeJEAz7uc7FaIsjCZhNpt9/uQzMsSyeiuRVBiO53J6jLqnkjh3HzspmVY1cTWiIGIKu1q1
	BPfB7ZEskuYcsKCR9/RLz+Y4cZ+xEnE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JZGRSCzVw+dnMxvlEGqz/JeWA6SU2+LFt85FuvrPTw=;
	b=ld8iMnlB1gNKrPDtQADook5ngMlyzUuLnA3OOR5NiwzcFvq0b3IiJ/Jjlsoc4wXdatJuyr
	67YemWKgp5EJW/Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B32A44281C;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id POG3K5hOvWlHCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 719B3A0B39; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
	Jan Kara <jack@suse.cz>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH 04/41] ocfs2: Drop pointless sync_mapping_buffers() calls
Date: Fri, 20 Mar 2026 14:40:59 +0100
Message-ID: <20260320134100.20731-45-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1308; i=jack@suse.cz; h=from:subject; bh=ud/28G3xYrWf6hhDA8l9j5Yn2n0f8oX/rNwQdYapQHM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5vRii9H+t97Y2LO0i9U30mEMXFAbwMkKJma eYyaJh30hyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1ObwAKCRCcnaoHP2RA 2U72CAClYJt4Vp3rWQy+nuN5XC33Sf0SKvdnx/nZehF9DNrggjtZwXkB4YsJjrAnWGUsCGFF/f3 YlQANF2+LWsoMsyadCF+47yP6lp02w/qkM5CIEK3Cr11d+sJmijZvBHd2InvMAS/fiS38kL2ly/ Xx5xJml/gFauzSj7XhjW/G7aHBPA9HxXgpSOBgNx8IcQvXgYBPF8ZIIwEC3gfZadi/Pwdq3OJF9 Sjs897pgik/+X4KIFXex1RazII9Qijsh5u7RBf91D+jQ8hS6MjfUmDtalSVmETNlYdHkRtkHMhD gQ1B+JmY63Jw5VmFHLElivbTdNzPYbruznMB3TYRKmxtXbS/
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: EA21018000E
X-Stat-Signature: e1mf7i4pijbfuzcubtcnbxtfdqmi3qir
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774014112-54825
X-HE-Meta: U2FsdGVkX1/GahIjWBnMqNpcaCPduTiPVYPUTbnUSvqHlimkPYLrfnpu6p2B6GTsTlJ1BAcDK8qSfFF1L5ElDHfOZuGF/31zr1iDred+hANlzKivjg4XAtvnvMXKrgO904C8thyi+4l+004HSraQ4tCC+Ho2AyMrcZhwkU/XMDPiJ9uswetcaLeMlt+E8yH8aBmYa2H228i4OmPz35cs/jt2vqpm7RbnZxo7RXpjrnFjVjBolYQLazyq6Q8hBRMM7MP+dyXZpmaxYHyNOVnx7l8qvApwy1mhE9mPfjnU9k2IpU7sCiOBmh/7c4g6IekaY+1xTeGlYPo9IlDjIDFlbuNSOnG8w18Ptc8QGo0RMiXJztQef0Mg/rTj46zc4cZecNE6lKfcscK6wvZyn6Gk4rxO1oLcq5IBEeVEM51Oi9OiqecUY5ulTkRHk/VdS4558w8YlxmJCwHkde4fcqKGwfJbm3Q77ePRH4etLkQK9h45acReEdrMj0ewS/XsZwxq9NGNF+YyaaKqRyz83/dYH48e791wzLMD+rxXuQg1AWiFnRu4XBH3RB88D+8VaS1VKcIIjtQqz3RQiKhzgpGHaO0dKfnt96E01qBt69GJyXZUUKlIwBkwbrNid8WA7pA2BpviRHS1WMsB4pj/GiRVBugAtcGhVG2k9rp6ztTp8qQsaQ4aHUvMCHS724sqvfnkQJmspiAtRwMGdwUkOs8g1mZAklfBnyPnLffh2Ls7gykOU4/tMqhwdFo2KFe6vCpGpDk5hdIPT0Ze/weEOVjYGnq8CKsJlsLm/QzgMBnQZ84VnVgW6+qgYbyLDxeaaVsz4If1yfEvbPcT73A2mr+J2E7hk84uyRV4tG2BvTgdVzyOxOpkTeoROKtGBAIqE7HrKeWusiKIIFNmeDJDregP7HcaPR/lDduKYwb4BZJe8YDgyItCCJ/Ds+oysf4hyhayjO0K7ngpXw8VEtANuCj
 d6uk9d83
 epNkb+nfH1X0h2gC8NAvxH2dHW3wXiZpMxhhfvf2L8D4EUfpq3UfFDvX2lRrjZdcMzm8pb4hgwP2b2LYoSGfEHkTNvqqqUynNrjQTV3EeH7EArlDmqDo4QuIO9omHrVENsQRKLJMrpPC3zcU3iSNZq7cvBDApfbw5m0DIAYNnaSeRSCsL8WqvkmgefxjYElG7eE3zm+XSQjBzvAkSBCz7Kqi6xU6ud98xksCz6fgwmhi62hdYxITqUNxYJ0bMIVlYVc3OmHmk4qNU+q5/kFa6eUKzfILEf5aRupcQFOWztOo4cjm0G93Pl5ZmIw4ST5bVEu1DVaiwVs2952rE70UXjTggnImEC5gGUo0593ztGYJ1/Ii5F1h+rxFqkpWYmoKie2uF8z37bEcTQzgJWtRCmoqOuMpYCM01Wen4DmDPz0RweL3gNP1wxpdJ+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ocfs2 never calls mark_buffer_dirty_inode() and thus its metadata
buffers list is always empty. Drop the pointless sync_mapping_buffers()
calls.

CC: Joel Becker <jlbec@evilplan.org>
CC: Joseph Qi <joseph.qi@linux.alibaba.com>
CC: ocfs2-devel@lists.linux.dev
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/dlmglue.c | 1 -
 fs/ocfs2/namei.c   | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index bd2ddb7d841d..7283bb2c5a31 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3971,7 +3971,6 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
 		mlog(ML_ERROR, "Could not sync inode %llu for downconvert!",
 		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
 	}
-	sync_mapping_buffers(mapping);
 	if (blocking == DLM_LOCK_EX) {
 		truncate_inode_pages(mapping, 0);
 	} else {
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 268b79339a51..1277666c77cd 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1683,9 +1683,6 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
 	if (rename_lock)
 		ocfs2_rename_unlock(osb);
 
-	if (new_inode)
-		sync_mapping_buffers(old_inode->i_mapping);
-
 	iput(new_inode);
 
 	ocfs2_free_dir_lookup_result(&target_lookup_res);
-- 
2.51.0


