Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3D70106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54C266B0096; Thu, 26 Mar 2026 05:55:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CB4C6B0093; Thu, 26 Mar 2026 05:55:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31DFE6B0098; Thu, 26 Mar 2026 05:55:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F7B16B0098
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B57C41A0C73
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:06 +0000 (UTC)
X-FDA: 84587755812.24.007D7F6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 63C191C0007
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mMw9FFYi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mxnNgLTD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mMw9FFYi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mxnNgLTD;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aRkR63p1jpFA0esSQKuE1SlJEZWNddmmmMLZ5RvIZyY=;
	b=kbTw6kD/KV/+deJT7+T24rNWeXSoWEY1nTFXeReiOjSxdq7AgXiQNSSSwyEi/RxHOccCYq
	LD48UmCeEgFXgPiNT8+bfLpA4fdazpD1aKC5QHP07GGMfY/ZE+C88ZGNndOO4SHWsdAU43
	yKeS4TxVSNjBaSyjmeh/2rkwVj6hEyc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mMw9FFYi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mxnNgLTD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mMw9FFYi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mxnNgLTD;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518904; a=rsa-sha256;
	cv=none;
	b=j8UOjzP0RHLx4c5bqfmJqtthchkBj261hwYED5XI0jlIZTMOQweJ+iCuEArh7PKKAmc3Z0
	SAvIhYYyekAV4QiUvyxjCQiREgnSLwPKfWvee6mP9WmHJIJLou7MTPiQzOH8KtwmAcfx8W
	XkcV7wGBV0Vk7Ni/voBT+/mmogiLe8g=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D268A4D279;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=aRkR63p1jpFA0esSQKuE1SlJEZWNddmmmMLZ5RvIZyY=;
	b=mMw9FFYiJgTxvm2jOoucSvEKz2U7CWOrgzoVrYMEGvgYO0FGfAB2yFocxUaY+FxiEi4+sm
	fiNUs6Vwt3Yf25EW3iASny5GWdj+U/7+jMxHQxUIincKucdzTko0bFAcmnNJ8fP8Enhsb9
	yYtmoNsJNWG1SfV6u+1nH/K2lxYQ+Wo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=aRkR63p1jpFA0esSQKuE1SlJEZWNddmmmMLZ5RvIZyY=;
	b=mxnNgLTDh78L6iaUILUrTIWzmlO0FdM/XohW5IMysSSlwlXT+3PbizvPRt0y30KMYRyFzS
	audeizPvgreVrhAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=aRkR63p1jpFA0esSQKuE1SlJEZWNddmmmMLZ5RvIZyY=;
	b=mMw9FFYiJgTxvm2jOoucSvEKz2U7CWOrgzoVrYMEGvgYO0FGfAB2yFocxUaY+FxiEi4+sm
	fiNUs6Vwt3Yf25EW3iASny5GWdj+U/7+jMxHQxUIincKucdzTko0bFAcmnNJ8fP8Enhsb9
	yYtmoNsJNWG1SfV6u+1nH/K2lxYQ+Wo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=aRkR63p1jpFA0esSQKuE1SlJEZWNddmmmMLZ5RvIZyY=;
	b=mxnNgLTDh78L6iaUILUrTIWzmlO0FdM/XohW5IMysSSlwlXT+3PbizvPRt0y30KMYRyFzS
	audeizPvgreVrhAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B39D94A0A6;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id P54yK3ACxWmeYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6A209A0976; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH v3 0/42] fs: Move metadata bh tracking from address_space
Date: Thu, 26 Mar 2026 10:53:54 +0100
Message-ID: <20260326082428.31660-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4261; i=jack@suse.cz; h=from:subject:message-id; bh=OcbPNXnG/ezx6KsPDRBMMef9MCYy/KlpWJbDBHz3UEY=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQIxTA34/xtU7IgqXiNrsxzCFcUYmjrIjwuOu RDjeyFNXc6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCMQAKCRCcnaoHP2RA 2flRCADUBXWyzZCdBg87axquExTTc4wlsGjblaPAMJfU3zifFLDeVwWmLLmik7Pj8xaFEGkNv5c 7NcDloLN9y1e16RUdr3IuzqynO9S5A0uYJo6eXgwpuhZPSlqFBmpTwTCuPPQ1xzrctDqN/mUqc9 w6L1SNBE+z+S4V3uxEtqURRIo08bTJqMh0K7XajYSiscBEVomuwoFqhHlTzN6utd6Vee57pZBRU 1EQUCunm6C7HIkc5q63JnTAZnFz60X5t1BwDoxjkebaad2qFmmf1hIRpFn0/zB8u2Yxw5IdNCWN 9OLAVCh8JXchU1pisDLogFOi+h50+5jyFV+M3wstbDEipslp
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 63C191C0007
X-Stat-Signature: gpjew83w84kk1bd54bnhfh9rystb3rim
X-Rspamd-Server: rspam06
X-HE-Tag: 1774518904-590822
X-HE-Meta: U2FsdGVkX1+HtQO1lekIMdChl0iSUIjV+yvFn6/TOiUncUAXFJeo4X3J+nLE/qjW7e93C7dBtl5WlKOV/wEHuMjH0sdhL8k4Wu9v/0QsOptVyLjwM+7BVV2P24Emqk/ZGDO0IxjWucW5MGBIITNSP//eiU/MZD6e+jXtaQs7DXHLQnQLL2jm+jsu5rZMBUCg4Y6RdjXgIRb3+W2vwqkEIMSr8E3TYBbLzmHo2RA51BnaaUQSOZaEo+ofcENPRpHN6rY7uxz2+typJjODWymObAGM0cDfcTdmra7Zd90kFrMGvTvvT+qBUs28yUZBR4Y5VSFSfx7UhbebMuZk1w9ObobH+RpT5p2UA5XTN04KxEbfFpPoRS4+87eYzPD4Q4LVN48cT2LiUDPQf/Hp/1Smld6EQ0+ItoPGX7EJ2ulD973XOmjjbbx38BgBP7+lofrRmINHDk2G4S7itIUXPfWh4gTp1InMEQfdzyu9hIGF9Irkn0wD0qEQSwipQFkBIAY9wZUNxgbZ2jaCTKo1XLBig03rF7PFxKpE8b3KCNrzlSbw+A3C0Y5ACxZPPaxFODtBdXKOfTEdUbqRJVsRvcuAp+94Bcc99w48ZSaAwTsvIRJFcgYKwOk7TMYz9qDr7q8PBmx0hsqnyN2jx4MndQ+2mNduALOMySgepAwawG6v0SsXKwPhPBHlhFqxhPyt9WUUsXvDm3qsFtfTlm+NBzyopZIF3xim6eDgu8fRNL7jUoo3jfQxeNubrlr1a3IUtluQ7sntIh93k8tGTfNq8KUGUhBMtIGdfXYrtxw7b1+vL/O3d3EtwpmmbqXm98d9u1poQW8X4dYE6GuHoGPCF6Ro6QRxF2KKml87mMUd/x6t418w4aVk7if1GwWPEmQCW51IKdnNV9FotV8FchYf6a4tPsPjnx6putFgGNFIeiHNj+nlEEwcaItTgxsx89L/enPFiczESn1oQ8Ld2GEd/C/
 fihUdpwa
 Yw76puo8nn/oDejCXRrbpz7UE7qPHuy2e6BjT9Za8XqVvqXYhNj9SvCfG27R2n+SM7MmXaybXLwbCeTfPXh8QXIXi0XWKPBP0/64pBRxEQhNE0nnmrl0BSciMXUkNlToBtFrtKtQ6orXeH5MvYU8+cUvcPWpHX5rH+COolqnj05ZqWhGxi4huGgco/zb5KvAQP7HsHJtUjw+gjil3LnDs8b0RqhR0OKMnK0pKkgvGffxuGaaTxpqUvTv8+uLQOeI98QerUKUEvG8T6WfyOi8uK3pGDRTwL8+GzA1kZcG5W4VrxGMfXF2mU8yHHriQdw4ygrGg5fnLOTV4AkHpV/JsTTLsLrNSZU9yRfBK47ZZe92F0URVYKYF088FrtBy21Fwo1QI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

here is a next revision of the patchset cleaning up buffer head metadata
tracking and use of address_space's private_list and private_lock. Functionally
this should be identical to v2, most of the changes were in improving
changelogs, patch ordering, function names, etc. The patches have survived some
testing with fstests and ltp however I didn't test AFFS and KVM guest_memfd
changes so a help with testing those would be very welcome.  Thanks.

Changes since v2:
* Added Reviewed-by tags from Christoph
* Dropped the patch unifying fsync implementation in fs/libfs.c and fs/buffer.c
* Put fsync locking change into a separate commit
* Reordered series to place all fsync path modifications close together
* Improved some changelogs
* Renamed some functions based on Christoph's feedback

Changes since v1:
* Fixed hugetlbfs handling of root directory
* Reworked mapping_metadata_bhs handling functions to get the tracking
  structure as an argument so we now don't need iops method to fetch the struct
  from the inode
* Reordered patches into more sensible order
* Added patch to merge two mostly duplicate generic fsync implementations
* Added Reviewed-by tags
* Couple more minor changes that were requested during review

Original cover letter:

this patch series cleans up the mess that has accumulated over the years in
metadata buffer_head tracking for inodes, moves the tracking into dedicated
structure in filesystem-private part of the inode (so that we don't use
private_list, private_data, and private_lock in struct address_space), and also
moves couple other users of private_data and private_list so these are removed
from struct address_space saving 3 longs in struct inode for 99% of inodes.  I
would like to get rid of private_lock in struct address_space as well however
the locking changes for buffer_heads are non-trivial there and the patch series
is long enough as is. So let's leave that for another time.

 block/bdev.c                |    1 
 fs/affs/affs.h              |    2 
 fs/affs/dir.c               |    1 
 fs/affs/file.c              |    1 
 fs/affs/inode.c             |    2 
 fs/affs/super.c             |    6 
 fs/affs/symlink.c           |    1 
 fs/aio.c                    |   78 +++++++-
 fs/bfs/bfs.h                |    2 
 fs/bfs/dir.c                |    1 
 fs/bfs/file.c               |    4 
 fs/bfs/inode.c              |    9 +
 fs/buffer.c                 |  387 +++++++++++++++++---------------------------
 fs/ext2/ext2.h              |    2 
 fs/ext2/file.c              |    1 
 fs/ext2/inode.c             |    3 
 fs/ext2/namei.c             |    2 
 fs/ext2/super.c             |    6 
 fs/ext2/symlink.c           |    2 
 fs/ext4/ext4.h              |    4 
 fs/ext4/file.c              |    1 
 fs/ext4/inode.c             |    9 -
 fs/ext4/namei.c             |    2 
 fs/ext4/super.c             |    9 -
 fs/ext4/symlink.c           |    3 
 fs/fat/fat.h                |    2 
 fs/fat/file.c               |    1 
 fs/fat/inode.c              |   16 +
 fs/fat/namei_msdos.c        |    1 
 fs/fat/namei_vfat.c         |    1 
 fs/gfs2/glock.c             |    1 
 fs/hugetlbfs/inode.c        |   10 -
 fs/inode.c                  |   24 +-
 fs/minix/file.c             |    1 
 fs/minix/inode.c            |   10 +
 fs/minix/minix.h            |    2 
 fs/minix/namei.c            |    1 
 fs/ntfs3/file.c             |    3 
 fs/ocfs2/dlmglue.c          |    1 
 fs/ocfs2/namei.c            |    3 
 fs/udf/file.c               |    1 
 fs/udf/inode.c              |    2 
 fs/udf/namei.c              |    1 
 fs/udf/super.c              |    6 
 fs/udf/symlink.c            |    1 
 fs/udf/udf_i.h              |    1 
 fs/udf/udfdecl.h            |    1 
 include/linux/buffer_head.h |    6 
 include/linux/fs.h          |   11 -
 include/linux/hugetlb.h     |    1 
 mm/hugetlb.c                |   10 -
 virt/kvm/guest_memfd.c      |   12 -
 52 files changed, 360 insertions(+), 309 deletions(-)

								Honza

Previous versions:
Link: http://lore.kernel.org/r/20260303101717.27224-1-jack@suse.cz # v1
Link: http://lore.kernel.org/r/20260320131728.6449-1-jack@suse.cz # v2

