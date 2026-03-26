Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B66106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6BB66B00BA; Thu, 26 Mar 2026 05:55:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4086B00B8; Thu, 26 Mar 2026 05:55:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C47716B00BC; Thu, 26 Mar 2026 05:55:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF7EB6B00B8
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8467F13C132
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:43 +0000 (UTC)
X-FDA: 84587757366.23.924890B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3D828140009
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bFVqqd3m;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FvmZjun4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bFVqqd3m;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FvmZjun4;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=RtYgWo/Kie5wrHMzfpu0XqfUF3LP72ClWGE28wUbJjWymJAOJnCuhYVsptRTFoWE3wrUP1
	OYb8udN7UkTpAsdBigxdCqQ7DboZMKiBpCY0aWNcfmz3EwFXrAsITougkIaFQ6TL/Kyn5o
	iAb/MCHq4xyTcLTyT66k282wDef45hk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518941; a=rsa-sha256;
	cv=none;
	b=qYjh3I+/aCGcpQX3kYTiFHMC4pmASKzLCl3s5y9kfPjQwA0nGA5NT8oVzzB+ng5Q5wQzq6
	JGoWFRmI3a4lsSwDHY62yXE4yb1HBMayhsALMIWTX2osBY0o5oUPQTRKd5cCE4kAKbaBUA
	8pMKih3vDQqukfedw7cGaoLw98128PE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bFVqqd3m;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FvmZjun4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bFVqqd3m;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FvmZjun4;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5A4A74D281;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=bFVqqd3mkS6TZCNUqKZdUvzX3XT3sIaPQZMZbQWrDb+R/PAz4IXPQWQLcbdwvvXWLaVOQz
	V93+9DHQtqcYF/OsHpmcO2fiYdL+BjcHSPTI2EFPmMZPzjBRnGtf8zGIWnwkl6rxxVzyhi
	hUfxnwSkZoow8Qk3i6bZZmtoQ+8MM7c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=FvmZjun4bFJWQL+mJCBAsy1Q1FHakdV/cPo5WudGC5RfwFl3uN8vFDPWVQCHqH3WNE8bRy
	n1vYKJBBBk/te3Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=bFVqqd3mkS6TZCNUqKZdUvzX3XT3sIaPQZMZbQWrDb+R/PAz4IXPQWQLcbdwvvXWLaVOQz
	V93+9DHQtqcYF/OsHpmcO2fiYdL+BjcHSPTI2EFPmMZPzjBRnGtf8zGIWnwkl6rxxVzyhi
	hUfxnwSkZoow8Qk3i6bZZmtoQ+8MM7c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=FvmZjun4bFJWQL+mJCBAsy1Q1FHakdV/cPo5WudGC5RfwFl3uN8vFDPWVQCHqH3WNE8bRy
	n1vYKJBBBk/te3Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4FDBA4A0A8;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YN1+E3UCxWnaYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 317FDA0C68; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 21/42] affs: Sync and invalidate metadata buffers from affs_evict_inode()
Date: Thu, 26 Mar 2026 10:54:15 +0100
Message-ID: <20260326095354.16340-63-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=759; i=jack@suse.cz; h=from:subject; bh=NDPLTZYpyB8AvjWnfTi4NCpTDfiFBgirFbbT2/Tf5G4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJE8HckfhJ1pkI9JwuC2AULW5aPa2lEuXAbV pQDis2S6F+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCRAAKCRCcnaoHP2RA 2VbiB/95ZCE1f94Wxq6b164+/iIziO9sxIt004YEAXDSJ0w9PkuWxPMoH1hNLurneLBFu8bn3S4 VYbLZXklHTXzFWG/UoinssGOpBYqNKqmaN9CoXii0HYEahTNvy5zi1m0zftk/mLpUv2xwpb1gZ4 XPpuYfkc6lUxEhGXUM/kClXomGhqjl0nAywL/npEuBRHSf1jp11i0JqXsh74jSV0mUW1WAzaa7H iy8apwn4cFJj2YQw+bgkHsoZXNMPOas1E77mHN9gnULHP1bpgfykJRn0AMndI1S3FxESc3DlJ7W YYIY6ZvnOjdAyD5myabRLXxesPqeGckMzX8UK5b74y9/CiEF
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3D828140009
X-Stat-Signature: 38wikyuqzoeqpjmf54z91y8yyc1ujxiy
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774518940-790197
X-HE-Meta: U2FsdGVkX1/iWRWqjDHaRZyF2o4liEFblTpBrtmexYndrnopWdC2hZ/MHKTU7dTv6t20S4uFrw1Wti356kECskGLZpYh/usqAACtS2Zra8Ili6em89D5u35tVfPyyHjbehIBPbufJnBCXxJDY3bYP4Uth4MdC82Cf6bYqqCPK0TzwJvlhkZxGS3/7TYpd5F5ZM7YMcMGlkdo13Waqx7IBI/XjHAhsQcXrr82EaMgEvnz5ToWa7y4f4ZxM9Ip95RstY8udCgIo9EPtii9n2kylhqgcdrRjFDEftp25KiZR87vJfoK9jXUMdJppd3xNjR8FIGLObFko0lsWiIGPhtqBbC6YePa5n0JBO3mm+1KwhyTwAUqCb+D98yqkCV2PuFtXNytwy6xQJeTq5f7iqKLN+8XrsiHxP6PtFeb1dViHuKaaZVSEs1WAp3xPjSkjy+Q0TnkNq36dl83afBYhxv7BuM7WpIeVWveIeo90XztQV+sDKq41wN18sTvCzxZUa1EsYehUEg5k7Sck+Y8UJl99gqeSPSpJqVFgERszhl/GxaenypLk5akL/HlYjmoGjujFeM832POOXoOYX/MwLSFIX/ImI5o+x0/rdRb5EtQXXHeEn6vlRNEUvOJTPrzOuDO37046yfnzW1OtskqsOZuQhehQGnJH5Oq+MQZfm2fQVPEH4ZxfW7fovgJIAm2Hz+n/RhBSRtahGhN/68ne9YxsZK82u2lBdoEKvvvdEeWlgVBGtYxynpuoDZ3DcfwHdZ1JylZof04lLMUlSYsVCKybIIa5zq+H8/h9295ZwTYjpWNhLd08VcckW/RxXpRU23BmD9vwIdIlSdjJ3dkamGOP99+3BHjWhNNn+U+3+lppeF1KW9Y2dMZnhQwhSfXIbdrHEnAQDCxYWVns22Tw4nVGhauUUeTiNtAOv5fIPzNBZ8zQZh8NeyvvSYjg0bfTQsNBr4fvktJPPvar+QJOoV
 IcPF7Obv
 yUG26oXZ8X4lAAUfcd6u0QNF3ALpjMmklJvNu53GfROxECNcyMMeSVVQCa6OCdeD7Iz5x2WmbhyC8i4DyYwb3zGYhJlCc4/r0AbiVXq8RJqTaCIVpW/PCJpACsR9Fiafycp3FMJRtFEOi4BYVuCaHOu+GqL30qCXoofKat/6lHR0v8YvkhrtXeiwwkFx77PnrYZhTKCX6Pawg02dkXaDiNUZnRaqAVUBeqdTRzn803l5d3FpSsv4kevpaIlNxY1y6oTcZIC4ED2riO7nwDxBLVH8TTErpiQfE/XrsNWmkGNhOrkwICIba4oryUWYRUp6LQmQxkYYFURAbSVedKTucTXwh1JFKX/zduHND68qZbXyAICs=
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
 fs/affs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 0bfc7d151dcd..84afa862f220 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -267,6 +267,8 @@ affs_evict_inode(struct inode *inode)
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		affs_truncate(inode);
+	} else {
+		sync_mapping_buffers(&inode->i_data);
 	}
 
 	invalidate_inode_buffers(inode);
-- 
2.51.0


