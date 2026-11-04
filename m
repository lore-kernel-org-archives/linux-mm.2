Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FD65606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 00:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n5kpqQeB
Received: by kanga.kvack.org (Postfix)
	id 405FC6B05B2; Tue,  3 Nov 2026 19:49:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7366B05B8; Tue,  3 Nov 2026 19:49:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5E06B05B9; Tue,  3 Nov 2026 19:49:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04F036B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:49:54 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B156A8245
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:49:54 +0000 (UTC)
X-FDA: 85395604308.12.B5E17FE
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0070020005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:49:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=n5kpqQeB;
	spf=pass (imf31.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793753392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
	b=QwjS70hWV5oZ2ez/K8K+WoCmDe058PZi9VXNJusxaDr5U+9ZcdV4+9DlzWBav6pONRxqG5
	Y3a5SY1oQPJcN4QYymw9VuAx8s0RRVRLX7PrQRkEI1oDdsYhTolotRH2JUj0j/srbzUdOb
	xwtpGAHmXkWtEtpqqIRhv8/S0cmAYRs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793753392;
	b=KK2cD0V7TZNOi+MBQhPD/njBAQdiKv//9aOGVevga0QA9WkLnnXBkaMezax8CMIN5igEaa
	dQbTIDKq7Mfi/TW3WUu1dDDvt4m9By5Kco4PcMLgE4Ysi7MVONugohsPPUHIjhfys/r9x1
	W5McdT+bG9eioIFs9BfReKBcVYwvIYA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=n5kpqQeB;
	spf=pass (imf31.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a06e79e152so124919b3a.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 16:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793753391; x=1794358191; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
        b=n5kpqQeBdBgh8YZbIXl6V/7GrNDXd4Arj1e7n1zJA+7fmsHZIG3UNnQzH3ywdftBb4
         ZenTFhWyo0ET99DNJ8jhhX7KSX9WGP7x/1ks5v03yMcCFO7yiKzNIOfA5CYAFnKN1gfP
         98y8AEMpFfxqDQDK6jyzPydy0L/5vnFuNjFLr6Xhw0YjL1G3kjFvRyrRZoLVZ3hCcPkZ
         Q86WtFWCEzjcmYKgJGt+Y6O0syjq84mWq6FT+v1co1/gq5C7eRIPBgIGO5ly9LZeOeCx
         M92QNyaDxuu7Yl5cOCCwluy604Mg20r+Ow4rmqR/uGQwT+rcWY1yRerpUCyIJ3rVBeLJ
         BJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753391; x=1794358191;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
        b=W8qCgGUG77x+ARua5n++funB1oZUV7biv3RIp+hPPkUwgQw1gKpWRhR43JWkRq4bfs
         OF+VxMVf8QVEZgvF9+S/H3HkU56HSA3BbCjgJGI/xxvKevTKEUGlb0ss0QmJ5yDoc0iV
         VzryYdpALXjveK9ZUZUvc0pCwy6hwn8liJA+8yyP2JP2yEoIz4EK2hqEMYvwhQH2l27I
         Hyl05FNygEEdqVD+Bfw4dQf/BOZkJ70Cs8LkmWiUf6n+5t5gSja79ggXJorO981rwu6V
         0his/fgtoTIr+hMkp8JZq6NFX4JW83Ft/vDpmJEN85ym1IOXra1SExEN6jw0WmlGZEK4
         QNpg==
X-Forwarded-Encrypted: i=1; AKwUvByPYEL0oWCExz9QETvsKZ4PAbJlGXooqCbPCdTqjmRFTrXNrpSCpaFQ2e9hKCS45YyQbD1oUkyh6g==@kvack.org
X-Gm-Message-State: APuU4Z+Jq+ax6Nxky3XxiQc626QMl824ziRxqTyRWF6lXozwOdxo1FqA
	/2oTHVJsIEjaFWv52VskoeigeOskNwtPomiPRu4WNVwwbb5C3ICJK9b0
X-Gm-Gg: AYBFou3Z1+6WUR6pmHk/6Sivlvy7bHTPpiHG4UiVNcJwDm3m9kFkNLkznBAPCc0jfp7
	xC90mDvXZ9fUB+9fB5EnuZMKDE7Xhz/gH+pIqxQBcYHm18zXvJHjHKw01+ouQge8gKXQGoQ9Zaw
	gj4/SgeoLE3ulI02KcJV/KlH+eHoUYFOWXTwfsmluGaP+MhPadhIV1iHLek/zrzgfgeUyFicBq6
	S54ZVMNAw4oAazxvVzZNz7qAVypaTB9toKDq+g4GUvWGcLqWB+SbuEet5obg5ikOIPv9F2xbofv
	z79mrqe1Glq1ln2yqj/xmxFAueYzRDoQnFbwtYQai89ugaxEEbgCjPeYckEc7zgU9JimBevH69z
	0j5H6tkztafS7J+pjz3E/AnU3yKbXBCA8tBVzQn57xeB+r+PAwF/cVW6ymUIrAhlo/vG+JxQwB0
	02SADfDBOn1YykeUQM8p+ZzW4Dy5poo4+2tY9VJqTox1WaxnFp5Cn+H3AebVAwR6sVErVjghVbF
	77NdO5Ucd2hzMT4GqeBQP3yl+7x5E2TAPFhuva0trUa9wnkTNg5Jk4LFb3WQP1Qms1DB+Fb1z6i
	sj21aiqMYBBdt1l3/Uy1N+Vmf5Gvge/O2RDmO5I=
X-Received: by 2002:a05:6a20:914b:b0:3e2:9470:5303 with SMTP id adf61e73a8af0-3e928953948mr11828504637.15.1793753391239;
        Tue, 03 Nov 2026 16:49:51 -0800 (PST)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb46440cc7sm329325a12.3.2026.11.03.16.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:49:50 -0800 (PST)
Date: Wed, 4 Nov 2026 09:49:48 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 17/34] ntfs: don't set SB_RDONLY after filesystem
 errors
Message-ID: <auqBLEvcurRZfGj6@hyunchul-PC02>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0070020005
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: ob4fgukif4zof7tquwqgc1wfuph8ksko
X-Rspam-User: 
X-HE-Tag: 1793753393-250231
X-HE-Meta: U2FsdGVkX19HpuUcY+FCcunRrch5paDq0B9TyYJkzy5Ds5EO9H3FcbCQIAI0kIOHUqUXJTjUrm1o92mJRr9NGUfELowvQ7yn8fp+F3xrnJvGm9gM0sahG3ysSy+zTaiQXVajGF4TUtVwuoq7+gCylel3LwgEgkt2K0pma9Hx60dVO89lhGLpa28JrmGGokLcpE0oAkCnGT4v5S9wKm14ob9u+OIE3SoGkezC40Xjc0iQIfXr1eIZIGQpKMco/C5nSfRWe3/HayST5u6MFdLS8jTmiKMVkabIvC8hhtMSby5n8AlEdARfce/HYLq4pee+GFd+T6/dg6iWzhb3NVx7+uLmP0SiQ4xW0uByY0T8tUE1BrlZcRwMi0qmH+z4X/XLjX0S/zwuqC+NOTXdPt3KXIdBGjsfwDHPGqIl95JVhNJp5aW4sMiVUu1FpXdgLunQkpDdSvcxtgtyVcaE6jjhf45ROzStwnN6h9G9BiXH7TtABA6hYiWVOieYhECEaANA5LZU1gBcR2n4m1kxfZV9SXxwn6AkTGdS5nmbFTtQsViDYlqBSxvga9heACPCJ5G9mY481j6zsqGDoA5ioW/B1/VlizPqDTogDoArJ9ip70uvlpmoaNcJg5JYtXT+f0Iikn8P+VxHIQpE0ac/9wW4sFD/fhOuC+/TpverGB+ftChXDGGpDVort0pVAp9gnUOGrLDECXHml4i74Ngoi3zKzYrizjlyWBO3xcmn11D/34V0dcpGf26i9CzvH6/1fchvJSns/DAEja5bvHgyxj21ZWuZ8I2zf5ew54ivirqBUH6hGzGPrK75GVzGKBzJ9YWthJRs6VmXbRbcz0ftP1jz8nxpDfmrMYjlZNTZhgzXoZxzDAkOX90E8yJmMlRhn6Hs68DVTiqwmka90v3cHeOE8aGu76HBtjaeTsMK54UQZSr1rH3CoduIf+sdRa0jDi9Pi9xfDUqiyZ5TcbJfgp8
 8TwkiRfR
 O+TTd/7WRtCkaM+N3Bt8TD4f4jWQoLrFEWxox+wAs9IPA347/bVLNwtJVL+wxTYsbWXDm2oW94gslG+ZNzsOKvb2owjwZ6mgNZuaFTnf/pIJ/TRMbqFIgCyNtphYRWHu4RPLUJ+NddFKyVxpnqyKNX0G4FDamP8ZQM00uOjDYb3TH89fXBPIuhPlsPmuiNMyFe8+EAgPk1p9HQe5VrYWzfF6a8C+S7OFCJRAMVtEqqtbK9bDkLPhTrcTSXFa985TyXcJhbXmqKmz3y7ZHVpXdOTjQWH4daHi00IWtaYzcOG1VVEgQCg89asLjgT1GQhdOE9byQz0AMLrK+TSl1F8YGxFW7KZ7RtHMmIMmYtRXcFtP/6PCROUnPK3rUswcoc2MzkJ4Nhl3h25FfeD8CnlYAZB5Inh6ufdSBvCKKbpfYr5HVou3qUMGusiVa09IRbzFUSqRo35CUH7vskK+4hLz4q2w51jklEagR9y0poS6aGPfR/3fMD5dPfBUufJfBNhC5RbEFgoGq6/1gRakPvRoFRbPzfUEA2AJjcxQJeKbgqiWsLtloZnuNWhZfR2ntFTP/5N8l8y6BKPBBhCaGYFpLieQQ01ar3/c9ANaGbdz15CZpKbXHSGAKb9A+ZYE7LynxBAcFX0VThbjuQP5gW6dE559kj+e9czBTyG2lid0733bh1HROXxdHGn/cQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 05:07:08PM +0100, Christian Brauner wrote:
> With errors=remount-ro every ntfs_error() ends up in ntfs_handle_error()
> which sets SB_RDONLY without holding s_umount. If that happens while the
> volume is frozen through bdev_freeze() thaw_super() sees a read-only
> superblock and leaves the s_writers rwsems locked so every writer hangs.
> 
> So set NV_Errors and a new NV_EmergencyRO flag instead like ext4 does.
> ntfs_emergency_state() returns EIO after a shutdown and EROFS after an
> error and the write side shutdown checks use it now. fallocate,
> ->set_acl(), FS_IOC_SETFSLABEL, FITRIM and ntfs_mft_record_free() get a
> check as well. Errors while mounting still set SB_RDONLY, nothing can
> freeze the superblock before SB_BORN.
> 
> NV_Errors already refuses a remount to read-write and since
> commit 521978c4f444 ("ntfs: sync the volume dirty bit with the recorded
> error state") the volume stays marked dirty once errors were recorded.
> But the dirty bit may not be on disk yet when the error hits and
> writeback is refused from then on. So a work item writes it right away
> because ntfs_error() can be called with mft records locked, and umount
> lets a pending one run first.
> 
> Unlinked inodes are left to chkdsk in that state. Their mft records are
> freed with direct bios while the index and bitmap updates of the
> deletion can't be written back anymore. And writing to an encrypted file
> only warns now. It called ntfs_error() which let anyone put the volume
> into the emergency state.
> 
> /proc/mounts keeps showing the volume read-write. Writes through file
> descriptors opened before the error fail with EROFS.
> 
> Fixes: 6251f0b0de7d ("ntfs: update super block operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

-- 
Thanks,
Hyunchul

