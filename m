Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C34C606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 21:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KO/XKzwP
Received: by kanga.kvack.org (Postfix)
	id 09C1F6B05B2; Tue, 10 Nov 2026 16:50:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0738E6B05B3; Tue, 10 Nov 2026 16:50:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECBFC6B05B4; Tue, 10 Nov 2026 16:50:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D007C6B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:50:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B934A5C94
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:50:56 +0000 (UTC)
X-FDA: 85420554912.02.AB57D01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id BA843C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:50:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KO/XKzwP";
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794347454;
	b=M/dJLnk9m7LoThPbpBt4O9k6OP025Yd4F4uKhGCyO1BJhDT27ITPfhj4jIcyYP4EpTQNmy
	LJPREDrnKU0/ECOwp868M9UPtSdiHUPlpW3XQF9yPkFGQnhvtP0WE8wRdvoLdk3lrW0cI4
	bxkokxIYR/jCD4tlk66AKYkFC0Si8ws=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KO/XKzwP";
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794347454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBjh6Hk100+KrECKKCLZMsdZH69ww17QHoFNGmE10pk=;
	b=PxhaA40NWXM+1L4MvMuoSkf69HQRsYYDPepvL0PTZ4bXD0uRKk3+KF3T6f3ZqFpyBXWKP6
	tA2bVluCgE8AehK4TkH337bFtOQri17ephTCRBFaH9D0mOSlyO93I6BbrAA36dbMI/mlgY
	OHIStPL1LsXs9f6pyt21l/DxwT3fLYM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CCC7405BD;
	Tue, 10 Nov 2026 21:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2361E1F008A1;
	Tue, 10 Nov 2026 21:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347452;
	bh=jBjh6Hk100+KrECKKCLZMsdZH69ww17QHoFNGmE10pk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KO/XKzwPaQTyl6+FijRmvYt7OfljTwf6lBoi7zd24R3KDOXd9HAGCZNC7KAYdyUYj
	 hBJJdYiiuBfGwwWCOmpZV23Q4HudsU1yoE9Rhgry0hTKqHF+nkqklf5TUTaEFUD6GW
	 niIPAXt+6OcJkFypr0b38UaCjrqEIesfHfavg1Y9gYKtIjC8fTa6yKcpG+wwc6ZeTA
	 +T2K7aictElGKSFlX8kES5nifGp4/GVkQJk7tj2mA58Dkifk7h1fG13cfBeo6mHXLD
	 iFLabsTbOzjUzu/9Krncuv56JNmgiwYwErGw5k9p1piJLK7fKkwVgKxFsoVF59iQ+M
	 jJRcPY1T7tJnQ==
Date: Tue, 10 Nov 2026 22:50:47 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: Re: [PATCH v2 04/34] ext2: don't set SB_RDONLY after filesystem
 errors
Message-ID: <20261110-kargheit-impfen-pausieren-881763d28b19@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-4-2f44f64f0b66@kernel.org>
 <5qefa4mracb3x2z4vsdejmkyyfrhdcrixmmnooz4rzwcdfoejm@mqkvixj6afwp>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5qefa4mracb3x2z4vsdejmkyyfrhdcrixmmnooz4rzwcdfoejm@mqkvixj6afwp>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BA843C0006
X-Stat-Signature: 58sniejap8uhyn966y6jiu81q1u4g1xc
X-Rspam-User: 
X-HE-Tag: 1794347454-236624
X-HE-Meta: U2FsdGVkX19hiMefLl/USKEFHhSGaiEha1GbwJdYMd7g8eEPqfVMINL8+SabcGZFa6IKWBAnW7FeAiZ5adFXF17QqCVyhKgml6No3PxVacTULqbAa7ZJ42RoFITOxb9/wweftbdJ9PDAuPmAgFjujv2RXmop2D7bWpFZ+7JAdHOQt2w+hkIYyboBnPQpSrIEUkcUHp+jAgG875Re3GQxWhd0dyE1Srzz58THfgf7yyNG0SEfiu9Su3x8cXa4vYtla7UNxpkNgoCl/XxhCZY5sFNajinlvV+zhTYCbqbpQmUTmVCBtDLGSV753p+Ubaexh3eP+bnfPoijQbpOmY4Hfb6Ju3yR/vSR+s4FO8EmQNcnw/+b+VxC8sfeNGis3iPPuZy1BVhQdL8B+D2NYCuO0uuuxwVZbmArH1wtYYiUIxtX9PsUO+BV10YsApfsJT90WrfdDBmcmot4kPLft09XISGIH4mL8keH1RO0AN6EB8dM48wOUPEDjeTQikuh6wJfryhzG/WFed5qXV8az/pq9HE8YiMsi0hP8Ce1RqPEJiTnuc5RB0Lu5XUpC0qKI1xRcDO4Dd0oFwmp4Q+MWoOd371alBnENtQ3w7G1jTqaFK9vIBu06XOWYU2U5VXHMxrF96B5WbfvxZSQd7tv8MRXEdegyES15sqqiqYkUOz38fINx2/CnqT5FHAZN8qMRjLMzPuEtPT8MQq2oOLf+ngZi8QpxfpULAlDlB11SGTh3hVVEeees7oc8gECFeVNjE3K4Iks2W4O7wITUubTUmZzywhXFtcW7fcnFNY/UJqUSvXppLveDrx2nvWVQ7YGIC0N4qvTPU0Yt/kLgE+4TdwhFUkCu6fVqu1Itb3xdevet2mlXiRNI+HwqDyU5mGKUhuE6vi1M2GyJK1OC5ExZO49YJo/cDOR/J2Z7E8c9mO8b1dKDiL/PYdGHBirNdGJDYW/9tr7iVw8O2niqKKI9JP
 LulTOnFW
 aWRIvrBmjlijGiEbW/CMepLtexgvkhmdEu4BWZOe+CCKiYkPCgI+qC24tUfLDA1hhepC8mYTCcS+evfZr1PLQkhqZCRgvkd4Otd4XUl27AQN5obIyOpkWLCqDz3HMet/S70BQLxDlKprc5maAGx9491h40fWhUjUutQQJ3CDMpAZEOtPG+enObVECa0wGbngT8EUAjpDvQ4ZhxVgG3FWuiWOzM6bJiIvJTIkdMCcqZunYqhJ523OjQ3WrT2du77K3rXz4vy4bzxcGebqVUxFO2nBQvo5xu87TeTrocWCcwOyNm4WsI8O90GH1Osm4LGI/khWgOJ+4UR5uGhYqGftew4j+ocFkjwvbTRmG6rMU+hWj3fNWdEeJQv9L3cp73y3JIWTCjRIdaqPkYrQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 10:22:07AM +0100, Jan Kara wrote:
> So shouldn't we just modify the sb_rdonly() check in sync_filesystem() to
> use also sb_emergency_ro() and don't bother with modifying individual
> filesystems?

The VFS patch I posted in v1 thread did that. I dropped it because
of jfs. jfs keeps anonymous tlocks for every allocation that writeback
hasn't committed yet. If sync_filesystem() bails after the error nothing
commits them before evict_inodes() and jfs_evict_inode() hits the
BUG_ON() for a non-empty anon_inode_list on umount.

Which is what happened before the series because the error set
SB_RDONLY. jfs_reconfigure() relies on the same sync_filesystem() call
when going read-only after the error.

jfs could commit them itself before evict_inodes() but that means a
->kill_sb() wrapper and a txQuiesce()-like walk over the global
anon_list filtered by superblock. I don't think that's worth it.

> Also if we have the check in sync_filesystem(), then freeze_super() is
> generally going to fail so this check could trigger only if
> sb_emergency_ro() was set after sync_filesystem() ran and before we called
> ->freeze_fs(). Since sb_emergency_ro() checking is pretty much guaranteed
> to be racy (it is just a best effort framework to limit damage), we
> probably don't have to bother with checking in ->freeze_fs() handlers.

Ok, I'll drop it. ext2_freeze() then writes the superblock with
EXT2_ERROR_FS in it which is fine.

> Is this really needed? All the xattr operations go through mnt_want_write()
> / mnt_want_write_file() so this should be caught in VFS...

Not the ones ecryptfs does on the lower filesystem...
Hm, maybe we should make ecryptfs get write access to the lower mount
instead and drop the xattr checks from the filesystems. Not sure.

