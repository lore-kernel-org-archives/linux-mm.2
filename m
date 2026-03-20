Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4574D1098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C5786B0092; Fri, 20 Mar 2026 09:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6768C6B0093; Fri, 20 Mar 2026 09:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42ABB6B0093; Fri, 20 Mar 2026 09:41:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 213706B008C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:41:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1D12C101C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:41:48 +0000 (UTC)
X-FDA: 84566554296.16.D3BAF97
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 70DB1180015
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:41:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="gmnOpu/5";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7EEUisOI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="gmnOpu/5";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7EEUisOI;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OyM48/22ZVuruDJ69nmr7bHs73Kh7MfWTw+h4KYSv5w=;
	b=zi5AXiMb9YyE6sfDwGm2WvXzJ6MlRkTH4gMElDBK+qEDLTLkZFMWHCKymW57sqlWunxANc
	BCEzMLBbhoMVyBDVbLkBoEJ34wbmA9DxxmaGRaLwuHGdLj++dME8qrMlzvlIakv843/897
	SZ0vozA5/XW9o2pRULiEcGfisSvhl3I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="gmnOpu/5";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7EEUisOI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="gmnOpu/5";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7EEUisOI;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014106; a=rsa-sha256;
	cv=none;
	b=s09bOwPro+iey4w4/IZ88oJGdHdT4qnbX37VWmdYuaNxZ0AdpthPVjLT0MEgh0i+YFs1CI
	bzJl0ZMbR9CB9BY8GC6z+IAosqKcYyElhtRmC5uBMh+TprXyZDNdUs+fVHWCmX/+5vhVCF
	EFDSX9zUJDvuym1DE1hEfap36yjXHZw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BBE765BDEF;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OyM48/22ZVuruDJ69nmr7bHs73Kh7MfWTw+h4KYSv5w=;
	b=gmnOpu/5wdK6Qs8QbtvbcYDj86UssvLTCXCLdxFDNWepjRtnobFty6SiLwjGYtty9BapWh
	QHMBCXgf8IulnHir0YVAA+rOALLAOdikQCrC0fSxvHio0Pmhev9rXvLfCnWrFeWml+LQm2
	UJhjDX34BM1c0Hy3F1b8IqodCq7S6aM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OyM48/22ZVuruDJ69nmr7bHs73Kh7MfWTw+h4KYSv5w=;
	b=7EEUisOIHKhMaJAAlWHak2MHaKe8yHCnH6OyCJJQ7zX+wY2j2ra88EDKcPIHbCvDehXD6S
	WMYQBiUT7XByKFCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OyM48/22ZVuruDJ69nmr7bHs73Kh7MfWTw+h4KYSv5w=;
	b=gmnOpu/5wdK6Qs8QbtvbcYDj86UssvLTCXCLdxFDNWepjRtnobFty6SiLwjGYtty9BapWh
	QHMBCXgf8IulnHir0YVAA+rOALLAOdikQCrC0fSxvHio0Pmhev9rXvLfCnWrFeWml+LQm2
	UJhjDX34BM1c0Hy3F1b8IqodCq7S6aM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OyM48/22ZVuruDJ69nmr7bHs73Kh7MfWTw+h4KYSv5w=;
	b=7EEUisOIHKhMaJAAlWHak2MHaKe8yHCnH6OyCJJQ7zX+wY2j2ra88EDKcPIHbCvDehXD6S
	WMYQBiUT7XByKFCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A8EE742819;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qchCKZhOvWk8CQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 54360A0A81; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH v2 0/41] fs: Move metadata bh tracking from address_space
Date: Fri, 20 Mar 2026 14:40:55 +0100
Message-ID: <20260320131728.6449-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3705; i=jack@suse.cz; h=from:subject:message-id; bh=y6WPXhW4cDJwB9kwDgAQyXGA/gUvqttY8DQs+1VHgDU=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGDL3+qUxbG63YdnZY3I2/8ukT1OLL3KdmtUmWbxfy3Ou+ zEXw1+lnYzGLAyMHAyyYoosqyMval+bZ9S1NVRDBmYQKxPYFC5OAbiIOwfDDTaD6HZ9hcvZqnsZ ZDTtopo9beJSL0UyWs9x1H/6klVH/bLzspPbN1q9OnV7BnOvZZwYK6dj4VKePTW/3/hd/rXy0tc fR+cnl4ak1SukvpwwLaIj2J/htOfH8LlK3HNET+0J+zAt/HL5p1ie70uWMafxyXPPCzny9oym+V nXzwsKA12cGLfdWXZA5JrG+8qfNms++BVP7vR2+X55TUmonuTL+p7Lp/RqD7E0GibKXjirUnxSn 6lU6V3XiZMmKobXuGo/5glY3XYLPyIz2WniPu+DWzwjnyUZfbs02eBRnFCF3zI2z7g0ye5jn82O Oc7YeXzy2eXH3ZYZi9w9tfGjzrxJJg7LdBWD75VNbi4AAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 70DB1180015
X-Stat-Signature: whquhqogi9o9hysfewmod4ootwcc3iny
X-Rspam-User: 
X-HE-Tag: 1774014106-307393
X-HE-Meta: U2FsdGVkX18xkimwKIZm1nE1DzRP3U7hJFxQKz/e+PIFBoYQ5YSQTohMn5vvOXolRp+oVAfHWlxo1Thce01QCBhIG2WHrRzfGnvaBkZwr36L4mRcLEoSEQPFvYBmeCv49zmZZA6Lsn4MqVlpsebx2lgBwo9YYzdimlOfE9cZPuDrvWUS+CYur4jOFp6h9iiqLQp1SxAPzPQLc/gGPpXrkuv6rZwHfww1aTvqTMzgHGzbEiNn0ZLZxkS+o7w0ui3FhOPYmfiaVyokcEpVcZUkkgw11jDk4ak+Rjzghw6HcE2+CfP+0p5qiBRBmVbprEqKJBr+NhDyo6xCoviJ0b0C/fjnx6o6+VB0SP63ddKh6rBUiJWtLBwKeze3xKcXIg1DjtKPMSeGbNc7IeKVfn7j2pnfunZmMIXyHGPt1aqmGMpe1oSARemL/VKr7/WQavUMLJzA6jJw4jDF2kf/DyokVR1nVi6UaHbgvdOsc9hTc1MAIGVBlibppPT5dwFB6NHbbXPWxKR2Dwn9lCVDHU2R60Nz93pBwcaa9Suj9QOWLIxykxCcxyBcM+nhvPR48llMz2X59OVapOzpKj3jdxmxU2d60VgHWbQTneghNCglhkOBUJeyJZxldoCFx+0IqJx7rfLM4Zs/euc50ANo6tvd8AGHhVX2umFdKo1ksq41UF9eETdQsCf9JuR35pWIJQN+wVoRcDvyjEOJuBOoZG86XQtYDLYYCrUVO3LVoFLkoHLq5Wd9u1d4zGvyjRYmuPkou9Uu3zOcWEDzjDdB+v0a4VckJmKxx9dabJBhAUKzBXvhrtl8WLAtWRWak0nAVOIB7pYT+32gjAPgKGWoC3L1WgVkCrSISMRMeeERKjFXH7PY9HqvT2KtI7HnYgN+XD8eS+kZ11amw3sXF9ivlVFknG1U68BNGsTj2IaLmRiaumF63lPG6dK5Baf4aaP9shZIBd60weNd4WvEh9XjLO8
 zp+IANkb
 +RsK2wiC+gzdFWs9nuxBwwEk2FWFsqFCy5ddFtg4uvwIpu1+nzeu02+C51TjerQeJ6ukuC+2Pq43vjmUFf7nv1tCT415dnJ/AdDzRgfIHoF8cnVzsM8Ui4YgT5ni+BXGmd2GeeMEvcuPrm24hZZLtq5T44BmaSbIO3DFjUx2nO5bvpjR1INoEE6Yl2acwxNoIiW6Tx7NkJvqDE0alU1xSfUSIkvWl/Tjb104PhOV904H5Db9F4NjOezX56X/GQ7ihQiRUrFgPiDaHRyXw8YHoTlZyBqk3O2W8jEN7vdVjTsoJ4nYxZxaYofVkMFhKGAVQj3B6qbKy2U7VGQBBmUQ+oHNaS/Zt2SGLoJpcjoiMxuCDJD0vjsOu5pi+0WnrKGp3Ste/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

here is a next revision of the patchset cleaning up buffer head metadata
tracking and use of address_space's private_list and private_lock.  The patches
have survived some testing with fstests and ltp however I didn't test AFFS and
KVM guest_memfd changes so a help with testing those would be very welcome.
Thanks.

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

