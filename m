Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33BC7EC1423
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948AC6B013C; Tue,  3 Mar 2026 05:36:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C8166B013A; Tue,  3 Mar 2026 05:36:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA0E6B013C; Tue,  3 Mar 2026 05:36:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6572B6B0139
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:36:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30EC0B92E2
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:36:19 +0000 (UTC)
X-FDA: 84504397278.03.78CA07C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id D8F52140004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:36:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QrHVjyCH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+Ksg1TAI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QrHVjyCH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+Ksg1TAI;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rvlI42BLgG88v9mLMZEY6KwxqWwniFDDye01LEogM+U=;
	b=6ptfo/2SqiJ4GOt6tN6QGD4TTfs5pyOLTUCegvFKla1LmK5ZOZ5zdqb83i6xEwhjZ6Upn0
	JVYAOPPq8p6WvC3h2GoxwcOQ32gG+mtFX62ZzaORGM6r6h0Ii4Ey4oVGSzM3z/P6UWIFrp
	mO0fgmMfml/DWGiQAA4pYHdeFhkjSDs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534177; a=rsa-sha256;
	cv=none;
	b=4+dOtAdXdLAy8X4N9XLZ6DtDi+QS7MTePNgGCzSJC/iruKSdsZCcwsdNYB2a6Ig54TVea9
	vnzIhLffwSwEjj8a7HXa47RC7mg1JRoK7eISOK+DOGOGuf3YzqybzJz3Q5WYYRm98n0MD9
	O3iWld6xkmQGyG0NuBiFaX9Hm0kNa9Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QrHVjyCH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+Ksg1TAI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QrHVjyCH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+Ksg1TAI;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 411A83F934;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rvlI42BLgG88v9mLMZEY6KwxqWwniFDDye01LEogM+U=;
	b=QrHVjyCHgBcbxeBPQFKzXdCdl6euZbFADe5DaL9sIwDOakfMzy/9uY4/HwmQktvGguvOLn
	tE/bRB0STbZ7770Gy3gkPhgBBYeYZrJedcyNReAg/zf0i7cwePufn1Gb2N0lVIrwFA77O2
	7vNSO66eHSZNCUnaCT1rU2FyMKePCsA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rvlI42BLgG88v9mLMZEY6KwxqWwniFDDye01LEogM+U=;
	b=+Ksg1TAIazn6n/+uTkdxvVTw/ogA9Vnd1LpSdPR0RCFdDu/sjYsrxLi7wxNt/umVWz582T
	w4F6CtwIgAkm3TDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rvlI42BLgG88v9mLMZEY6KwxqWwniFDDye01LEogM+U=;
	b=QrHVjyCHgBcbxeBPQFKzXdCdl6euZbFADe5DaL9sIwDOakfMzy/9uY4/HwmQktvGguvOLn
	tE/bRB0STbZ7770Gy3gkPhgBBYeYZrJedcyNReAg/zf0i7cwePufn1Gb2N0lVIrwFA77O2
	7vNSO66eHSZNCUnaCT1rU2FyMKePCsA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rvlI42BLgG88v9mLMZEY6KwxqWwniFDDye01LEogM+U=;
	b=+Ksg1TAIazn6n/+uTkdxvVTw/ogA9Vnd1LpSdPR0RCFdDu/sjYsrxLi7wxNt/umVWz582T
	w4F6CtwIgAkm3TDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 34E8D3EA71;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wNDpDEW5pmmGFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E00C4A0B6B; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
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
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	ntfs3@lists.linux.dev
Subject: [PATCH 19/32] ntfs3: Drop pointless sync_mapping_buffers() call
Date: Tue,  3 Mar 2026 11:34:08 +0100
Message-ID: <20260303103406.4355-51-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=806; i=jack@suse.cz; h=from:subject; bh=78gO3+UDRJwzzldfnEs3JfBLvPYcMCiUADzm2KJFKww=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkuXPN5sVNbZNgPUpw40epP2DctibWzh2DnS Wqw5U1nxlyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5LgAKCRCcnaoHP2RA 2WYvB/9SuKl25yl4NLc1kRhZsUFYo7EUNYt1AQEr7OzhL8Iedk7M248nW/vrvKPw3Eub9PCFlN4 9vPMFrc8CQuxROnE+aP9P+segvusk7PFrNJrB2m+52DzCdaRoJsjksDEYEgaGRGQ1c6Dl3tCg3F kXeXPRo7NudfCTZ7wqQ79IJmrRiraLlFnnmNOduphbcUmSjLX992sIsw3GKmIRVfbYrcuBDCsMO GT8j7nUR17OGHoAw/J6GTFeMW75IKXxGHKCfE1alo+BbKIpLVWzKqUReXtai5x0eV3hKy9JvABN e5lcxdX6MG+EdxtjmgPuvw6KtwMsanp2ei6tGj/zuAq6uBDo
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D8F52140004
X-Stat-Signature: 7af5e4aosfpid5bfho4a785yhie4nxht
X-Rspam-User: 
X-HE-Tag: 1772534176-357591
X-HE-Meta: U2FsdGVkX1/k+1I6G63k5A6vNQ+beZ9tTS+CxbNsDTiTdtSWuWas/O/vuHaHJvz/HlVGvaYnu1WWYd0F48XjcdGwHkNjIUOOsIH5Ya8rg3bTlbF7MMwvEeG1MAP4KqLH1LDYWoVHIdNEth4ZEqXY3f6sdR/aGDH2PBP5CZP7gMneSYuQBm+J40CQrE+qagPNQNqbXxQA1RKNwJqA/yYItZuRSH89MswrJa3XTl5i7BMlDX8mHF8QSTmMlKrVfN4K4z46QDWVu2lfFz/ledOg4E7TtAwHoyFZpOdIy5ntS543xl/VPslSjLPvCtg+BS8inmDVpXkcKRpFoyAizgJOOgNU7CWrqoAAvXeeFFRlCieFOc9DYDEVusoGQ1n6CeW9v3gJ3BXrxEWZQ4GaPH5YzOAc9DM3VN8e2csjwEC31eaI7alE/H7J6Ri1kwSAx3eh+hfYTZnu1PUopYB+R2Fs97PFBHzJz13y/WbVuIuEKwEyXAeWFlb6WfAnogBFXP+iUuQuEg7koOCE6MwAD4AIFgFVNpnfnsiVMKy3LuTqAaNtmOWujO/0Ln9YArTRmdl/5n51tfdEMONhqi14M+TRm8uMbu/jKNHhZwgkKVA6Rz9dv2PrBltG3LfHuRCLE0Gpz+5V8a3B+kahrWie6tOnU/ohpg08rEXUasB6q9e0wy6GmTHZ028YGLXcY86gcTFcwvd61fT7nehNRRkIqGBvSkhOMlFVxsZ5IDVORPArgkPqsDoYUkWw0UnBdSF9OVmkUFLerFCvkOGWGtR1os5J+AkSzAiItJYPqLbBp/FsDjlgGqg43x0qp2ShX8BcgSyc1dpzzBWvOU/M44vvTcHs7PMgXWgmB4JV+EPdJ2uytb9qfwYi3AB+eLIJrRDTVRCbftJr4Ax4Q+UMOyfR1TWznfmLHM8OjtJ71hIQE5AEqbxWUNON1xFM7SJngc0eHGoVpo8AsHJyJ1G++IzoaIT
 Fr34ZQ72
 vQraguVLLJinF71afaagAIKZge6nh+ebgXFxCmxPJg9hRmhOA8IAR5F2Jdy+8+zqABvS+OU46W6B3r8n410XCuCFMhRRRGIeVZI8zUlt2ICdvh5I8r4dROqsfXxPoIXT1OZuuana61obSSacik654Aei+Kxk4KQFMBDZradocLUE3do5UyXLVSD2w4x0ykZKeiaFkwW0njlKBGYmwJUEc9lYGfDtWzi9cE2IN2D8xJQo5EnI7sh81e3k06zPQwJtqS1dR05b3Xo1ctMvkgCvcsz9RHzf3k+p6PxBF7tLKOh52NpgtDrPBHsgtaFkQy5UoWnAhVY0y3mTgeMdRL89YmYCTEbW0B6BIfUOe1P+CukTpKf/Hat0TgDGUG2+fTYF+TJTS4m6sMSYd4X5vXhiACmfwUBrzzqrUMBEs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ntfs3 never calls mark_buffer_dirty_inode() and thus its metadata
buffers list is always empty. Drop the pointless sync_mapping_buffers()
call.

CC: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
CC: ntfs3@lists.linux.dev
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ntfs3/file.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 7eecf1e01f74..570c92fa7ee7 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -387,9 +387,6 @@ static int ntfs_extend(struct inode *inode, loff_t pos, size_t count,
 		int err2;
 
 		err = filemap_fdatawrite_range(mapping, pos, end - 1);
-		err2 = sync_mapping_buffers(mapping);
-		if (!err)
-			err = err2;
 		err2 = write_inode_now(inode, 1);
 		if (!err)
 			err = err2;
-- 
2.51.0


