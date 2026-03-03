Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2320CEC1423
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 572246B00AC; Tue,  3 Mar 2026 05:34:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FCE26B00EA; Tue,  3 Mar 2026 05:34:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35FD36B00AC; Tue,  3 Mar 2026 05:34:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2B66B008A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:34:45 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DFE4813AB02
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:34:44 +0000 (UTC)
X-FDA: 84504393288.16.ED1A79F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8CD5D1C0002
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:34:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lqMqPkPW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iVUDLfIF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lqMqPkPW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iVUDLfIF;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9UrJPHNyhUknVE32ZDrA7g1au2Fhe6ZCvxRhGCGzA8o=;
	b=ZwSUIYJQ+idSfgAo5k0l+5weGPG+YWmf76ajvTVRv/i4usKfCqQnfxztaqBlZ9iRPgVHXE
	vEiTSs49GPCyqJDbUHHfHdIdOPWzYewiIW9jOKaIhF8ONvkThbqlesq5a4tL5rjHpPCcbA
	Q4l5Y5UCH8KwXhROAFkw71X/idO3OwA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534082; a=rsa-sha256;
	cv=none;
	b=SbxrFUPFkZy0itd5uA0AlYnh0oTCxRzFDxtXItWjf1nvE5ipLrwUFXvkD+PX6jrD6ILdbv
	wSlBS/uKvO3iEgse1UCqYPae2oDPuLZVaqyYY1oqHAPwMNr+o7PGcmVdjaBC7bzQBJr+16
	ES7OIffLf6XYptteYkUWRYcnH2hGLxI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lqMqPkPW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iVUDLfIF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lqMqPkPW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iVUDLfIF;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B9D935BDEA;
	Tue,  3 Mar 2026 10:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9UrJPHNyhUknVE32ZDrA7g1au2Fhe6ZCvxRhGCGzA8o=;
	b=lqMqPkPWqfJeKYyNTobGfmlypOq9O0pVliQhFsr5dDXofPyv/b/GgGcU6Xi0yoTa2eyxwg
	7MaLvhJ8Yz3kVLaz9QCxDzLS8AbI2txjhAjrVxIobHxkHpd82eTaYE4F9+fGGgb03IFa5R
	JMNRKG4T5wTyKO+JbaEoKD/vks2FLzU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534080;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9UrJPHNyhUknVE32ZDrA7g1au2Fhe6ZCvxRhGCGzA8o=;
	b=iVUDLfIF4U9dmHoWczbJvEmbfpoB2vpfnCz4s1BvYSrIsMQE5vGrpPfqhAW9yxewyjAsDQ
	3SWPKaww46bSbjDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9UrJPHNyhUknVE32ZDrA7g1au2Fhe6ZCvxRhGCGzA8o=;
	b=lqMqPkPWqfJeKYyNTobGfmlypOq9O0pVliQhFsr5dDXofPyv/b/GgGcU6Xi0yoTa2eyxwg
	7MaLvhJ8Yz3kVLaz9QCxDzLS8AbI2txjhAjrVxIobHxkHpd82eTaYE4F9+fGGgb03IFa5R
	JMNRKG4T5wTyKO+JbaEoKD/vks2FLzU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534080;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9UrJPHNyhUknVE32ZDrA7g1au2Fhe6ZCvxRhGCGzA8o=;
	b=iVUDLfIF4U9dmHoWczbJvEmbfpoB2vpfnCz4s1BvYSrIsMQE5vGrpPfqhAW9yxewyjAsDQ
	3SWPKaww46bSbjDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A51763EA6D;
	Tue,  3 Mar 2026 10:34:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iL1IKEC5pmnJFAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4D160A0A1B; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
	Jan Kara <jack@suse.cz>
Subject: [PATCH 0/32] fs: Move metadata bh tracking from address_space
Date: Tue,  3 Mar 2026 11:33:49 +0100
Message-ID: <20260303101717.27224-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3005; i=jack@suse.cz; h=from:subject:message-id; bh=UbBPqAcv2kV/Q4CNByWNsI4Gp7M+jn4qLkYn8cP+R8A=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkMYYq5ex/qPGCddgeRA95TW6T29xG3oZcwa 9/pZCmZiICJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5DAAKCRCcnaoHP2RA 2d1UB/9/qfK53DX5rvT8+evw97coaewuS0fQW9uwuwRy19Te5htSwgwrDlxVdnAjxdPTDY832Zf OpsNY30Z32u9RG0pWG51BpraVwhf+/2MszT//06tOH7Hwn8BbdDiizKz5vq/Q2XSNU2mG95VmNt CQtLCDqJ8Af26NQdlIs1lhYbyPmKAG65aNny4KIwgSAfTQ8Kwi6k8WWtkgj2nkGnsQ6jh78QNXw a4cbhTbKSK3lEX8jT4bxbop6rZsmvNhPrUdUwKzjVmEzkHMLi+ddsFc8vlQpsBECnSaj5DoiXe+ 0AEhtReRU7oy3u6KT/zgv73jh80SHUOG0h4nkP1HWJsmjlSz
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 84xrnbtfzmqd793ozekoe58gd56tw6oc
X-Rspamd-Queue-Id: 8CD5D1C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1772534082-985327
X-HE-Meta: U2FsdGVkX1/+WMqSXkr86uvOQI4b9nr80b/IHe8wR7oDcUsSP2s/sQ1yls40SlEldKK0zrnYp2VxERlzrNCLGsEXUC+CfGLs9miAtAqkRZmemMwGxOeNDCpNq5GVapKSxWJP2vMQBJnxIOusx+aMkQQ1In6W5Cpwteh/7EqHiGOz74ndghEtXMq775UEmPDj44RC/KUUooKacQ6HsNk758jmD9uwS9zhssLC5HJhyIxFmrUdrhuxMMt78XQkyR66FTdqAIh9oSyvHOvWnzpzsIAEOUdlw8hVi+bNcgp7D1Bau/qaMhzQAtwaJwEBkB5/0uRjSooRvTxsYJTaQyrcCG/XbfgKeocZwC2jgkdy61/tr1fOsZf6Ogf2/T6HbprpI+PADz9Mn3oYpfrZkXBrvP15RCT7/bcj7VwBu1hfQKF7E1Y9c2vo5DmSHAgclSRL0qBsJNeGhM5/gX+A89yn3kAizms/svpGV8o9Alt2gFxVWG22P1OPF8MWtY1kXU1GRiy1d+OPbdH3Z6C7+RzJlkpjD7+qj2+ZOLeMFVLl2H0ZZSIws4PQiM+R4WoKMqpAtWEQaO6XSBIqBzWaCa1nmmNyeWKFyqFvDqugTzqLaPnzNVVZbLI+9GM6GlcEVNSUuLMcU7gDSgSnPkZsNuExEzC36koxTP+MBEFY/WKaDC5bcmbkKAh5N3/BATLUBSIMMe8BTO/SxmGLkfl7V05zpGeSmKUf6l3z1qJqtAjJ3jKM/H8TMHeSNoY0hipTAx7FNLF6cq70ujY4xeiSujixxI0ykDMesmMIy+UXnEPnCS+vAsjes5dY0py2qElb9rJ+JjOEotkM6jBcXY6lC3khG5d5B2nFU9ltf43I9i+OfFKtMsz+rPk5/7MIA5tD4xK+b7Tu4fp3QnTCRUHZbQR9EoNJG+EVvvo2bTeAteSs8JcnjFeIABJTtDpaSBHjMM5hW75vtXMvbvCkJ6KjZ0J
 WzC/N25q
 6xbGSwrLny5ukJbBQcPbjr+YHJDTFPGY/OyzZqpEzrCBiJXBNQ1mErBlyPNTo4AlJsMCFj0Remc62adwW2MIR1DSbeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

this patch series cleans up the mess that has accumulated over the years in
metadata buffer_head tracking for inodes, moves the tracking into dedicated
structure in filesystem-private part of the inode (so that we don't use
private_list, private_data, and private_lock in struct address_space), and also
moves couple other users of private_data and private_list so these are removed
from struct address_space saving 3 longs in struct inode for 99% of inodes.  I
would like to get rid of private_lock in struct address_space as well however
the locking changes for buffer_heads are non-trivial there and the patch series
is long enough as is. So let's leave that for another time.

The patches have survived some testing with fstests and ltp however I didn't
test AFFS, HUGETLBFS, and KVM guest_memfd changes so a help with testing
those would be very welcome. Thanks.

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

