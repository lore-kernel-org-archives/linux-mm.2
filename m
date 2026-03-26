Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A88C4106F316
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9A606B00C5; Thu, 26 Mar 2026 05:55:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72196B00C9; Thu, 26 Mar 2026 05:55:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89CA56B00C5; Thu, 26 Mar 2026 05:55:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50DB66B00C6
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1AA6E160C73
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:57 +0000 (UTC)
X-FDA: 84587757954.05.749DCDA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id AFDE84000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Y/qbVuo2";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UkAt+b1u;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Y/qbVuo2";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UkAt+b1u;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=ZYNjLt5Xvn50zUGtGATCsMLy5bQX1zjLpo9QXjSMpHtPuJlCJc2AtK8FFPv2b40MZtIeFp
	kyr35yxZOmZK+U+txJEmVchqjsFLVXUJhgh9Qxn1yNySaRDSc1xH1GJUNrRBCN0kkUlqwI
	c93xL0mxKIyo63J+We6IsUmLtg9FuuY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518955; a=rsa-sha256;
	cv=none;
	b=6tAj5qG9PrFg1MvH7QDtZmypzkmkSl9mf0wXQ/LvV2BXggjwkX5kh5aZCrjl68CElvUNs1
	+smdrdY0Dn1VHRI2E7WnQRDIXXHuO5aA9Ik4+En2x8lyn/0iLCUqV+1JNdqGnC2hebiBLS
	cq1hzmxn0jpEwKh7FVKrs2Ok2RDmWA0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Y/qbVuo2";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UkAt+b1u;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Y/qbVuo2";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UkAt+b1u;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 453AF5BD9F;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=Y/qbVuo2TsF3t6N5oYbim5B01JbYhSomLALeBMuonfj8yAoQ5W21Nwd0RU62zk2BHsNrJl
	clPZxzL+d1Jz6jkedXcM8NTKEb6mXi+jMyVVpDok2Ns5iUtYcCi9w1h1moZCiX2TSzTjC+
	b0QaOstfiKyakh+RWHi+1XYl8+5KCGw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=UkAt+b1u0bDeTbgAVIpagAoJVUef24MK3jBjPJMcxxY/HOm07BYbsu6rgrjo/q9DNLX5lE
	RYTcNZyUV6BK7BCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=Y/qbVuo2TsF3t6N5oYbim5B01JbYhSomLALeBMuonfj8yAoQ5W21Nwd0RU62zk2BHsNrJl
	clPZxzL+d1Jz6jkedXcM8NTKEb6mXi+jMyVVpDok2Ns5iUtYcCi9w1h1moZCiX2TSzTjC+
	b0QaOstfiKyakh+RWHi+1XYl8+5KCGw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=UkAt+b1u0bDeTbgAVIpagAoJVUef24MK3jBjPJMcxxY/HOm07BYbsu6rgrjo/q9DNLX5lE
	RYTcNZyUV6BK7BCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3B89C4A0A3;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bsuGDnECxWnKYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EF427A0C18; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 15/42] fat: Sync and invalidate metadata buffers from fat_evict_inode()
Date: Thu, 26 Mar 2026 10:54:09 +0100
Message-ID: <20260326095354.16340-57-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=858; i=jack@suse.cz; h=from:subject; bh=rtWRYYCi+3xOxheWOY6jlzCuMWKqys5cHOCNYJEuNWY=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI+VzC4YbQ9T0Z4TeuYJcjZHgbt9+t9ryNIR 3V2CHcYpCeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCPgAKCRCcnaoHP2RA 2YhHB/4vxvzXM8PjhQqlguQjvSfaMmwzwoRYgpnjUCjnzuSo/IYWrynUOLoOBVbC6S+PmQlJrE6 b5Pf4/wgb0FqVvw+X8juDydr95IBx0SAUZIu/hLCtwg6ntBeVnOoPIK8VNjqvdLA8gbHD5hKx8m 55XIOxMDGEFndABvSDT46kom2h2VpLxDa3rfAFZqBkA5aIvgD6+DPMNqkmZ6uUTdcfAmTi7mZ2U vq0CnYnmS6nw45pqdR5pdwlThY9zPP5VufYNmTOLY+IrocHv7RvMH7j9LJN8GztjhQOGqOYH+7i Tbv32pmQaeyN8kAAxNB/B+eVSRTNsG7HbRxkj05MHoQpW1PT
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: AFDE84000A
X-Stat-Signature: qo5eqyrjfi1dx39j7potdntfakx38txc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774518954-538394
X-HE-Meta: U2FsdGVkX18YpgGHp3Kxa7aSx7svrXez2MUQgc/ubWRLGZGUQJTqk5Is0ZfrFxhQMxZYvJAmndbjidNPnWJRNFOJTLUPFHtIjGS4AT8ruWiSeWb5LyoZVCouKOrWj8OuatzupI9P+t2fqsLBhYHnGRXVxUsSh5deqRYHuU6Ts341T0P26CV97r+i2m5PvpRIBmm8eRT6f0OXP7DtR82RC7ciF8sdmV/4MLSrJ/BAoYKqxq4LTi6TkbZKYvfKgHyKUK7A4PuHmY18MHVWUnUqjYk2/6kgpID+wm826V6bVJC9vxwIbIsamh2FJ78PEeSe+qzJqOXMacjFrBxxVBedC6vu+yRyJk/6DaNRLEiQ5/9Q14sRbS7FLov5jEyfRvgB0nYvlp+aYqtnsfWPIZuDmMfW5SSHWNcxMR4fnFZpJ6ar9Na+AC0eNdxHC/oXRlA06fzVxO86W0WxSKjcKgDNY0TCJl9xUNsuLI3/yCGybSuTbxamzCAes1bG5IlHKGm0reFFluf8x/LOo6HiuluO2MzYwx535z4HJtfmeaTRjRazHwwuqKE9mOS/iZA+MiF2cf2o6Wv+6hNXBmMJNk2cDB9SlSOdFnj23M3qsIsQVk4zprSNmt5QMLMj6vJ0MgAaegfgjCtTXdYxAAiIAtGNIM5zEYR4lX6uIIbBol2a61y47YjodF6hXRHnehOr6D7+OyW1aUHAi3JeitUkoie7U4sRKGqG6TZDzkfBz3q/9nW9JtDSDdnaQZs+JAPbvjEl/HxYkpXF/dVm96AMpC1gHKe78vtstYrsaFnUOosYN0Xz7727JxGlxEZogj/2ouBGUuLedeURyutDBCcNBSUyiQGgNh1JxQ5drUqSuHQtBltmj6e4Yk8ZtwDtEwRFFKAdgMdDGa8BA+YZcy8fPRb5sjnkP/DR34c+YoIMRgepaA8koW1e0uhQkW7T7FLfT9LRWjBvwWsLatPLouSYxS0
 wrFaqE77
 DS2nmQ2w+zCCK1Y1PODXfgVNEx3AKOF4HvltXao97F586yxEvoZAVPS09JEAQWJKufN3hQh2Ae62fU9X4Ha3rx6Jolpxb33PN3a8c4/uCC3K3FKs5VjGOD3QB3psuhQxtC+b7UMbZK4FFY+2/8UMU1/eheQAvEZvWUeem+ovmRNLMFdrKgvc3iBAw/+sRxePPqFSWapfiDawLj4lq1GXrVrYGsXc9KIzrsCqRTlA0rUuPSVKEnJQkANJLSD5u+y3vMyIcBnmy4dL3JQOREYPO0Z1syM5VoAwePRrIoO7xPhSwUni9Mci8SO7znBG4Xg0mMeMDFO47hnabpoDl4l4gVYO6F7W8ZkgdWfLeB/6y6nEVgoE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are only very few filesystems using generic metadata buffer head
tracking and everybody is paying the overhead. When we remove this
tracking for inode reclaim code .evict will start to see inodes with
metadata buffers attached so write them out and prune them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 3cc5fb01afa1..ce88602b0d57 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -657,8 +657,10 @@ static void fat_evict_inode(struct inode *inode)
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		fat_truncate_blocks(inode, 0);
-	} else
+	} else {
+		sync_mapping_buffers(inode->i_mapping);
 		fat_free_eofblocks(inode);
+	}
 
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
-- 
2.51.0


