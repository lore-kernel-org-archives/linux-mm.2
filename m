Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47D5F1098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95E546B00A8; Fri, 20 Mar 2026 09:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898996B00A4; Fri, 20 Mar 2026 09:42:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738876B00A6; Fri, 20 Mar 2026 09:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1C06B00A7
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22CEF888FB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:15 +0000 (UTC)
X-FDA: 84566555430.25.630AD2A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id C566214000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iT6rQM84;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cYJ+XKDg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iT6rQM84;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cYJ+XKDg;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NdEtE8Oyvh+CNSYSgrJqlRwYXjIS8z0UXo1g7uFEF70=;
	b=Mdoj9D+WnLzC8uYn8vdXF7V5t1DR3bwDGJ8GAPOwphoPwA2BreFkH+0+xkKIWCZUZJeyE5
	PWmRFq4AOCgvZkHMzp6t/eEckevKrZ39Dr8Sz1BpNim+bgxjY84HjQxlHdaEwQXppqii38
	zQvahY90Mxrhgz4TAzjQgNrYBjLejPg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014133; a=rsa-sha256;
	cv=none;
	b=A34/C/Yh7x7AT/sPvGdp2JOI7g5Efo0oIk9Hz5ng35iYH4oGzvupzvZFMWvBYBHyXobtKJ
	oCeqp5oaHZvKQujlsYFFRKx3v6BK8xP8uCkvFKu/fBjttr8u2eGWru53dXT4BBE4s2vjv2
	Ltd1LZ22GLEiOeelmsMsXfgRvrMFckc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iT6rQM84;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cYJ+XKDg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iT6rQM84;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cYJ+XKDg;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 11AD84D27B;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NdEtE8Oyvh+CNSYSgrJqlRwYXjIS8z0UXo1g7uFEF70=;
	b=iT6rQM84oA8Kt+9lJ9PF/nR7dpCMfysudtXkJXkbSURj0eNb/fEBHUtmKj4EMmXao3HcAS
	dAbdK18J8wGXAkM2u8QT4CuXP+/NMTHnBK0cBijNE8QxPr5q71FM3bnee8NOrbTy8lmBh5
	dZuOV0fGEMlgjNEwkaonmPfHd3AkD9g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NdEtE8Oyvh+CNSYSgrJqlRwYXjIS8z0UXo1g7uFEF70=;
	b=cYJ+XKDgdV6v3QxrjZOOrVZYa3kJFb7oEIKlM5re2j+ruMiWf5OZ74/p0UQ19ANJwRYH+/
	2TFbIu7ZZU75pTDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NdEtE8Oyvh+CNSYSgrJqlRwYXjIS8z0UXo1g7uFEF70=;
	b=iT6rQM84oA8Kt+9lJ9PF/nR7dpCMfysudtXkJXkbSURj0eNb/fEBHUtmKj4EMmXao3HcAS
	dAbdK18J8wGXAkM2u8QT4CuXP+/NMTHnBK0cBijNE8QxPr5q71FM3bnee8NOrbTy8lmBh5
	dZuOV0fGEMlgjNEwkaonmPfHd3AkD9g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NdEtE8Oyvh+CNSYSgrJqlRwYXjIS8z0UXo1g7uFEF70=;
	b=cYJ+XKDgdV6v3QxrjZOOrVZYa3kJFb7oEIKlM5re2j+ruMiWf5OZ74/p0UQ19ANJwRYH+/
	2TFbIu7ZZU75pTDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 06F334281A;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sYWwAZlOvWleCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AA43DA0870; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 11/41] fat: Switch to generic_buffers_fsync_noflush()
Date: Fri, 20 Mar 2026 14:41:06 +0100
Message-ID: <20260320134100.20731-52-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=720; i=jack@suse.cz; h=from:subject; bh=IYTZqBCm1tD1PPP3s+ylo8XGzMtfmmwAB1tK/qvuPJ8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU51JlOGIVmZB5084E+ZmxrpHuXL0d/KarR0R KWhQH8o2UuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OdQAKCRCcnaoHP2RA 2eFqB/0YT4QyZZ/TN3MCJ4XAocwfwh4SC9cJ/LvBXonCJnq2L09ipDxhJ7ikK2axQ3mKQ2Onhqy 5GKjBsIHa+I8bFE/mzOrffGwIgxNZo2u0MQeJJdP28TCgfvqLM0OYuavyBhYmsb+SrE5hnbOOhk 6hO+aZy8r/xKWEZOD7OXlhsCQe5rRKvcLIjkIrQoHQBakTJMyRrXXqzwJpPLwvFmIeqHAIlU7BW SKsRgwSxtrqTEUaQYUk7Xlh9KzeL0p7YKA6TM08e+ahd1+BvxTLlh5W5sWqFN9QPKaL7gX+0p7k hjy5dDJRyrp0Qj/7Q+TcMHjTBaG3XkO3H5cqoy9l02tgUZyD
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C566214000B
X-Stat-Signature: qqpkw44mcok8b57ksf4m783egdq14y7i
X-HE-Tag: 1774014132-993644
X-HE-Meta: U2FsdGVkX185TOQzndF3hLUuoka5Nr7Nrr4E4UYhgUQfD8Cq27VRsyUYbjacfAVxUShWpci6ubJruLqzoLArZvhVr5ncROmHfQDDb0UkNWqwQixu8RJVfd4R3aKfh3ByuGmlWv/EO/yfW2flarLVKZiD2nC760lbSuA0VHu7tWr3dD4bgPXKhbIICCZ36hym5H0z3SzwEGsxr5ReQw28Ce41KzyJmn6VoOLZ+HsJRZ17wMxE/y69grOR5KGMv/aIXKOhroiJN0Q7IHpQHrJt0/7ex8pXEqKYugEaQmGeOMPcxlV/c3suGBnmpB1HGAzJ6DtpcNYCH0f1POvwyqmqSXQAyhlPR9HMi7bobZhPwlbdxxdRExn0Vyb/jqB8SEq9LXXDxY/GlYu76+qLlkV3b5d9uLsWzEjO/ZIS8CYNNOA97r/nLZswiQaFtoZ5kRbs/PMhTri6j7Np8avmqMdA/Ch9ASxucOCfaF6KXuDzZrrt9CCxQBoDly2Tu0eAAiB1dzNOOR1ymlC5tGkyNowPlzyZxwSWS5b992Bu1fOkH7tUosTZBWy3EvQh2tWtlBc1rf9Gfi+0/R4/sImGoqaVe2D/zGYzXoGxivMtvuhHlYkmt0mD4Sk/8hRw42STEeudbtnVJOm7ZU+lT6YmIhIM9+THKWGHIBuipd6BLOT/d8ebpZktjXYPECrFJlBbW60sVa/T59UtVH8C6TpyVkrwMFIk9qYKrNVT6E6AFGUiGgUNWxk5XlhnlualrGacgSGDY3oZHfBoSSVTmZvsPRm751wNSh8Bu6bgJ3d2qtLpBuKioOFvhsWGTR4mv1fUte11WSOLGajJrpmfmSHtwweAK4a0+lTb00I0Bv2jO65e++XF92UnEXkYILERXC0SwwfdE3ii0xo6JK3k+mHnFQrvPAzX7p6aB91fEP22s+Qp1PmRZVNrzc0IyOkQjFKl0zRSfJWElX5DNue3ubmXlDr
 kxgedHuD
 8bJLvODL/9mhn1PoUUOTvo0Fn8luBImhldGsggdlTyS4Ncf61vBKqcLMtYSR+M/zLFKOkyCtnKQZkdhBA/NX9dehGcDF1U+lyjvqUQDwlSYUrw+C3Dxe8eiJO1DlPWAD+XN9Neicjh1j6lQVHqZVlFDyC+o+Q0I9kU/UlnD5mjX348pJqysoCQAyWEiQABc8UvuApd8YxouDLE3JS4Yp7RYhZsLuLQ7TlNtd4qiklNsM4edIqCBa4/KTuej3M/r86zFVWCvRxIfHRoCFs9BV9ZDOAel3RYSZ6/Zortvl/lNjtPM85m8kP3jeDJxJjEDfXW6qwYSZonRfxDndm3cbrNhX3iNlHkAPzZD6rnQyX/rS7dOYPB8WeVsDnEU6c8HtsUfFnx41WYUavVOs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FAT uses a list of metadata bhs attached to an inode. Switch it to use
generic_buffers_fsync_noflush() instead of __generic_file_fsync().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fat/file.c b/fs/fat/file.c
index 124d9c5431c8..1551065a7964 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -188,7 +188,7 @@ int fat_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 	struct inode *inode = filp->f_mapping->host;
 	int err;
 
-	err = __generic_file_fsync(filp, start, end, datasync);
+	err = generic_buffers_fsync_noflush(filp, start, end, datasync);
 	if (err)
 		return err;
 
-- 
2.51.0


