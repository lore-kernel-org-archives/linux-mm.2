Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA774606A896
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=r58BF0D8;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=15TlV9Nr;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=r58BF0D8;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=15TlV9Nr
Received: by kanga.kvack.org (Postfix)
	id DC6916B05C1; Wed, 11 Nov 2026 09:15:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78106B05C2; Wed, 11 Nov 2026 09:15:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C668E6B05C3; Wed, 11 Nov 2026 09:15:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98BEE6B05C1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:15:17 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59FB1A02ED
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:15:16 +0000 (UTC)
X-FDA: 85423035432.23.5488C7E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id D98B24000E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:15:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r58BF0D8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=15TlV9Nr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r58BF0D8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=15TlV9Nr;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794406514;
	b=0E+vDuCizbCDKwq4ewExNTzOB/y7osC+KRUoHK/AUpKIENYAsQiMPVR69LPpl83jC9N2kI
	mMysB41ASjDpZzKtPL45VR2b2Aqz9rd/qLHZkmPbjkPhRim/THTt65bZKa6VQvMscvbaVy
	XpgT4DH34fw1TrMSXbB1lldf5WeS6pE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r58BF0D8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=15TlV9Nr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r58BF0D8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=15TlV9Nr;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794406514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iEM9kPeISwrg1hp3zFsHM5gU3S8hitOkRPQJum2vFMU=;
	b=4Sa5uwcI31B7knxds9+otQMpzX8yZ7B0p/OcAhMN8G/y21iCEbS89oDFb7/Q7RrI7/Amhd
	S/LsH/pVhfriJgKXYp/de3l32Y5GeggwhCkTcM/6pQvrwosaNwA134SXAR65Aif+NB3evg
	GlotMBVMdkhb7D7sn0u6mIJoz1j+2Z0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 09F3E22A5E;
	Wed, 11 Nov 2026 14:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794406512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iEM9kPeISwrg1hp3zFsHM5gU3S8hitOkRPQJum2vFMU=;
	b=r58BF0D8W8gzgIAphVb7+yXG4Wp0CzJfQUUtsAILSsDExswBBX2Vz1DZhrqDcoIpRX0ZTt
	0gBD9RMFaruNOsM+g+SXe7YVni3W376lEjHWkMsC8cv+03B46mcbwzWMdN6eutgUbVcR1I
	skb2yG6nBdMmWTQD7PkbKOeYbn2js8w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794406512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iEM9kPeISwrg1hp3zFsHM5gU3S8hitOkRPQJum2vFMU=;
	b=15TlV9Nrfb6fbwPB+XQGAF9gQF4YSshvgg4Qr4JwuaNYvo4isPqFDJlR8PRYTR3/TFQArE
	KUe4A2NvjL7x2ZAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794406512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iEM9kPeISwrg1hp3zFsHM5gU3S8hitOkRPQJum2vFMU=;
	b=r58BF0D8W8gzgIAphVb7+yXG4Wp0CzJfQUUtsAILSsDExswBBX2Vz1DZhrqDcoIpRX0ZTt
	0gBD9RMFaruNOsM+g+SXe7YVni3W376lEjHWkMsC8cv+03B46mcbwzWMdN6eutgUbVcR1I
	skb2yG6nBdMmWTQD7PkbKOeYbn2js8w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794406512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iEM9kPeISwrg1hp3zFsHM5gU3S8hitOkRPQJum2vFMU=;
	b=15TlV9Nrfb6fbwPB+XQGAF9gQF4YSshvgg4Qr4JwuaNYvo4isPqFDJlR8PRYTR3/TFQArE
	KUe4A2NvjL7x2ZAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD61B134E5;
	Wed, 11 Nov 2026 14:15:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oMu1Jm949GpWAQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 11 Nov 2026 14:15:11 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 475D422933; Wed, 11 Nov 2026 15:15:11 +0100 (CET)
Date: Wed, 11 Nov 2026 15:15:11 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: Re: [PATCH v2 04/34] ext2: don't set SB_RDONLY after filesystem
 errors
Message-ID: <za33axmgzmuzsj3zmfeh43fkphtcsqtkhhrauwuvs7aiftelgp@dzl6z322st5f>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-4-2f44f64f0b66@kernel.org>
 <5qefa4mracb3x2z4vsdejmkyyfrhdcrixmmnooz4rzwcdfoejm@mqkvixj6afwp>
 <20261110-kargheit-impfen-pausieren-881763d28b19@brauner>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-kargheit-impfen-pausieren-881763d28b19@brauner>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Stat-Signature: pf3x7xm459uru9jm7diafx6fs1ozpwgt
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D98B24000E
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794406513-202094
X-HE-Meta: U2FsdGVkX18B6z6NL+elclJpSEXHFSsuYZLsFek8q3xtzGJO8gpSz8QJcHrHjNbgfNuh9piYb/YRL4LgEZYvvfSwoce0s5jVpW5QDOquccQ1WtUHDuJh1hWDBarCH7KhnzURj+7zPApc2kr6W1imyhLzk2t3/8Fg6vyVcEaMmT/RrxpKmBquZTO6E9p4809tfgvKNwc3gkI1AjOX6ZRfBxGqsjgzrRXS6XAayt4wF4JQ/qz53LD+vOy2OIyO0xAEYnM6QEYW/1+RA3CLgD+n/IWFdN0CNRsZqSvayvu42YpDNikAZhEnX6g6kEmf8mkpLxcLsJUn25u7Ip0nE6c5iqIjQWIaYWYjKFV8vUh1uv8yQwccXqXkGExBAJWLTc/7u1Tsi526l6tZ+hpTLGToE4BV3Up6bFYiiTFZ4X3WaSX/VtxTlcJtfuQ42YKU8u6xGPj6m9jScWq7hfEUXnERx9gOstiNEZfT7en7TcWhMNYB3IK2qbV54GBK1e18VWZJK18BBxkc846hJAn1T8BvfGQb43TuWgrmWb/dhhr8aBvF9F+zA7m6a4u3qi05Y4FzwyrXQWxE9Dc1KflJjSfOCQFsz2/Kq+wsINuqI5OArsyncMCdOfXJSxPaTbOfGJN/cNOpnymhGWd0On9zuFT2HuGk9p8SVCHgv7hTlql/G38UpD3f9x/+j+oVJrRuIOaGdHIZH2aj3NG4CBvAcZayoKAryygYLD8cP1mNNG35UA9K0f8dSEU/UNP1i42kXYAFcRk+ntQzzhghCID8F/TRXXsckzMyZcJ9CVmkBScFuku1ivvNeCdKx54wFXwR33Ws7n44IcRM1tO5HLoIQGzBSJYh9OxbcgYdcUfcvvKTIerYRob3pmWK1mabmuTQzoOEKC/z89+93OdmGFVwCK0R/sdxnatPrZufFNNG/NEqLWHwTsQ+p8jH/m28j2fi7m98lNsKxHVbtYrZB8V36vP
 TPiARekI
 vru2zSDsrAUNSXHjOQ3kAs3fl1c6dnBlXwBC3yqcj3UA2dp4bZDGS/9haT2vMaNMLzs3UDu+K/ZEq8zJd1T7fSPV+mCQ1tMooxdiMPyXe8GI03hTG70wl5PqZXciTsf0MfHeSCPaDi+3H0eCcjvuWYXfJLb08iaUU9tX9R2tqXbwORHvc7qXWtSMMdklqQ+ejS40GmYwewmVRqlAZcRYxYevs9LiW7d8Pa0SVn8tGgqHs+fenocGSXydguS3PvT/aMuH5n/JZXcsFTnygDLM0MQ+6OgI+RX6CKoMc3Zr+6xvtnHOMFrjXrhMpUfTwiJh2nKTNgcbc3Or/7sB7te5S8wO9g9Sa/0/yHSJMBZLWYopYOtiKUhddxORbTSblTZ0E11x/jVOLgXa2XOahh/xZtUy1Dc78N207G7JTXysNor/T270=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 22:50:47, Christian Brauner wrote:
> On Thu, Nov 05, 2026 at 10:22:07AM +0100, Jan Kara wrote:
> > So shouldn't we just modify the sb_rdonly() check in sync_filesystem() to
> > use also sb_emergency_ro() and don't bother with modifying individual
> > filesystems?
> 
> The VFS patch I posted in v1 thread did that. I dropped it because
> of jfs. jfs keeps anonymous tlocks for every allocation that writeback
> hasn't committed yet. If sync_filesystem() bails after the error nothing
> commits them before evict_inodes() and jfs_evict_inode() hits the
> BUG_ON() for a non-empty anon_inode_list on umount.
> 
> Which is what happened before the series because the error set
> SB_RDONLY. jfs_reconfigure() relies on the same sync_filesystem() call
> when going read-only after the error.
> 
> jfs could commit them itself before evict_inodes() but that means a
> ->kill_sb() wrapper and a txQuiesce()-like walk over the global
> anon_list filtered by superblock. I don't think that's worth it.

OK, so instead of BUGing in jfs_evict_inode(), shouldn't JFS just do
something like:

-	BUG_ON(!list_empty(&ji->anon_inode_list));
+	if (!list_empty(&ji->anon_inode_list)) {
+		WARN_ON_ONCE(!sb_emergency_ro(inode->i_sb));
+		/* This needs helper in fs/jfs/jfs_txnmgr.c */
+		TXN_LOCK();
+		list_del_init(&ji->anon_inode_list);
+		TXN_UNLOCK();
+	}

So that JFS doesn't block everybody else? Because conceptually, once sb is
marked as emergency read-only, we really want to stop writeback so letting
sync_inodes() run seems moot.

> > Is this really needed? All the xattr operations go through mnt_want_write()
> > / mnt_want_write_file() so this should be caught in VFS...
> 
> Not the ones ecryptfs does on the lower filesystem...
> Hm, maybe we should make ecryptfs get write access to the lower mount
> instead and drop the xattr checks from the filesystems. Not sure.

Argh, also NFS I assume. OK, that won't be easy to get rid of AFAICT (we
generally don't have mount available there).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

