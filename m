Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3170D277D0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 03:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08CC86B0088; Fri,  9 Jan 2026 22:56:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B636B0089; Fri,  9 Jan 2026 22:56:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E727B6B008A; Fri,  9 Jan 2026 22:56:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D68846B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 22:56:44 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8698D1A004B
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 03:56:44 +0000 (UTC)
X-FDA: 84314692728.21.BC83B57
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 95059140003
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 03:56:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=claGbCex;
	dkim=pass header.d=suse.com header.s=susede1 header.b=claGbCex;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf09.hostedemail.com: domain of wqu@suse.com designates 195.135.223.131 as permitted sender) smtp.mailfrom=wqu@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017403; a=rsa-sha256;
	cv=none;
	b=X594d23BFlB1oGe4BK4xPr42vew2cOO1YtL9wrKbEhTDuaC94rH7ZVEylTAi1vHLqTs7G0
	c8YkhP9slxX65csEi/pqbU8pVQhRGjyBlYVD6q+8sbObfHfp1j5ztLSYQ2EK1ON/nUXlOX
	BgouaZLFBcnTIylmuRfPpJnbPQ4Dq2A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=claGbCex;
	dkim=pass header.d=suse.com header.s=susede1 header.b=claGbCex;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf09.hostedemail.com: domain of wqu@suse.com designates 195.135.223.131 as permitted sender) smtp.mailfrom=wqu@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BkKRg0H2aQvVi5KZeNt/pJBKRmCQD8wH3dhNnd5HYJ8=;
	b=J9HmuRfWQ5roZP5taG/7+CQad81/WUEkOM3xP192g0BNF3u8WQMq6ZctEuzv8s9KknptYM
	DmUr17jgCTCUPQCJAQqgABcJrdH+Y5OAETMs+0ZC67uuFTTykcQ7vgSL0BfR0BaIWXgfEF
	5KiutLbBrPLt9EiqUhHqRMYGIsW6d5c=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CAE9E5BCE4;
	Sat, 10 Jan 2026 03:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1768017400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BkKRg0H2aQvVi5KZeNt/pJBKRmCQD8wH3dhNnd5HYJ8=;
	b=claGbCex7LJ9d9+an3htNbiT6gXsmhHjYlZ5aBITBWUazgerz1O0sgnEBo4punTP4MGjnB
	Uz1/cJyXG0MWYE8WzR/AFFZiJsMGq3Jn9CGWJImFgCfFuiq42uw9sCY5MMfA+Tq98fHp1A
	zXVrGTPRaQrKRa/bcqDjlhu5jK7+zw4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1768017400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BkKRg0H2aQvVi5KZeNt/pJBKRmCQD8wH3dhNnd5HYJ8=;
	b=claGbCex7LJ9d9+an3htNbiT6gXsmhHjYlZ5aBITBWUazgerz1O0sgnEBo4punTP4MGjnB
	Uz1/cJyXG0MWYE8WzR/AFFZiJsMGq3Jn9CGWJImFgCfFuiq42uw9sCY5MMfA+Tq98fHp1A
	zXVrGTPRaQrKRa/bcqDjlhu5jK7+zw4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 534003EA63;
	Sat, 10 Jan 2026 03:56:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f2fFBffNYWlqLgAAD6G6ig
	(envelope-from <wqu@suse.com>); Sat, 10 Jan 2026 03:56:39 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] btrfs: only use bdev's page cache for super block writeback
Date: Sat, 10 Jan 2026 14:26:18 +1030
Message-ID: <cover.1768017091.git.wqu@suse.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5x98ai4ja3t1xhq4cpqorwropry55kfz
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 95059140003
X-HE-Tag: 1768017402-881135
X-HE-Meta: U2FsdGVkX1/WLfzAvOynV6WxZyyrSeAt35//SkUMCOO52Ot+DWnGIPAVHMpSxxPbbfldBOrg+73ixprZlxXRE3gA66ZCWgY8yXiPF9GZBNZocGBSq8ZdUCF14utYsQ+B7fvMx67gNQ/UEYgGwkP7w182Zx3YN7clK4sNfdrHoA2pqIXAtESQVGo3GZEh6GUIo2yoKnssYdEYE6qMKAia1xlU4/7486X9VDHXqWxEbYa3kh1luWX2aXFwZkp5NVlqFvrug8V03vq95GLGAxSvJ3GC4Wob+cU6M0rDVe1GMPdyf8f7Pt+lCKu/YQ5g1r4pludsJtWXarioYeWPx/k1lscpQLlNZbE0Woh+jF/avpDP+SfnQqOBEx8whDLzQOkEe4tio4QMNudcrB/KhYIVe0cPEQJWUhcOb0PZRrR4H9DIohTZQja36Cakpl4elOfX+v78yRPCc62xEmXHwb2C7ACROVrUFDDmkccXmlK6Wg8z+G//aixRdsf80fgLYRnX03LmHy7rwyTqDC5G5/4x1Z85mml8AW0P+a1CL4JERaFoD3uOPt6Gpd+7GHovtuvOM6OTxbdhgkYF7rnyyiKOrjlLmahvUU5MszNZS5mEF3PMEpMwwTEySLu5y427QDRbA2J9UmhUVY0x7XAAugoPDNObbdOOOfAn8nuKSdhNyiN09ZeddNpjBafF/Ud9K2QXepznHeO1PUqx3CspOVi6tF4F66L/A/Jubx6w61fyLcE8ECRBlb/q4Yd2FT1yhsjcoYLBOQENJXR8Rp3MgS6B3vqXx5LNaz/lH9tHScktYJrqXFtj807uylt9kQPbeSipnpBzJ4/s4g6n2nGYFVW4g8EBWxWH+inHSn/ZlHyVK4xXlYANK6oQ0FyXRbMzKfCcmIaeP9SINYP6KMeDZpGVYYwZfDLklHAm4xnIE51ZpMZqigLU6w7ZNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[CHANGELOG]
v3:
- Rebased to the latest for-next
  There is minor conflicts against the recent fix on
  read_cache_page_gfp().

- Still use the folio locked flag to track writeback
  There is a patch that reduced the size of btrfs_device to exactly 512
  bytes, adding new wait and atomic is not that worthy anymore

- Delete read_cache_page_gfp() function completely
  Btrfs is the last user of that function.

v2:
- Still use page cache for super block writes
  This is to ensure the user space won't see any half-backed super block
  caused by the race between bio writes and buffered read on the bdev.

  This is exposed by generic/492 which user space command blkid may
  fail to see the updated superblock.

  This also brings a slight imbalance, that our super block read is
  always uncached, but the superblock write is always cached.

RFC->v1:
- Make sb_write_pointer() use bdev_rw_virt()
  That is the missing location that still uses bdev's page cache, thanks
  Johannes for exposing this one.

- Replace btrfs_release_disk_super() with kfree()
  There is no need to keep that helper, and such replace will help us
  exposing locations which are still using the old page cache, like the
  above case.

- Only scratch the magic number of a super block in
  btrfs_scratch_superblock()
  To keep the behavior the same.

- Use GFP_NOFS when allocating memory
  This is also to keep the old behavior.

  Although I'd say btrfs_read_disk_super() call sites are safe, as they
  are either scanning a device, or at mount time, thus out of the write
  path and should be safe.

  The sb_write_pointer() one still needs the old GFP_NOFS flag as they
  can be called when writing the super block.

Btrfs has a long history using bdev's page cache for super block IOs.
It looks even weird in the older days that we manually setting different
page flags without going through the regular dirty -> lock -> writeback
-> clear writeback sequence.

Thankfully we're moving away from unnecessary bdev's page flag
modification, starting with commit bc00965dbff7 ("btrfs: count super
block write errors in device instead of tracking folio error state"),
we no longer relies on page cache to detect super block IO errors.

But we're still using the bdev's page cache for:

- Reading super blocks
  Reading a whole folio just to grab a 4KiB super block can be
  overkilled.
  And this is the easiest one to kill, just kmalloc() and bdev_rw_virt() will
  handle it well.

- Scratching super blocks
  We can use bdev_rw_virt() to write a super block with its magic
  zeroed.

  However we also need to invalidate the cache to ensure the user space
  won't see the out-of-date cached super block.

- Writing super blocks
  We're using the page cache of bdev, for a different purpose.
  We want to ensure the user space scanning tools like blkid seeing a
  consistent content.

  If we just go the bdev_rw_virt() path, the user space read can race
  with our bio write, resulting inconsistent contents.

  So here we still need to utilize the page cache of bdev, but with
  comments explaining why we need to.

However this brings one small change:

- Device scan is no longer cached
  For mount time it's totally fine, but every time a btrfs device is
  touched, we will submit a 4K sync read from the disk.
  The cost may not be that huge though.

Qu Wenruo (3):
  btrfs: use bdev_rw_virt() to read and scratch the disk super block
  btrfs: minor improvement on super block writeback
  mm/filemap: remove read_cache_page_gfp()

 fs/btrfs/disk-io.c      | 45 +++++++++++++++----------
 fs/btrfs/super.c        |  4 +--
 fs/btrfs/volumes.c      | 74 ++++++++++++++++-------------------------
 fs/btrfs/volumes.h      |  4 +--
 fs/btrfs/zoned.c        | 26 +++++++++------
 include/linux/pagemap.h |  2 --
 mm/filemap.c            | 23 -------------
 7 files changed, 74 insertions(+), 104 deletions(-)

-- 
2.52.0


