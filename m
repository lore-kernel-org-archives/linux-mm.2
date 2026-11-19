Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 283FC606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 14:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RPLWnijZ
Received: by kanga.kvack.org (Postfix)
	id 43A586B067A; Thu, 19 Nov 2026 09:30:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB8B6B067B; Thu, 19 Nov 2026 09:30:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301416B067C; Thu, 19 Nov 2026 09:30:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4E26B067A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:30:53 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8AB8380B29
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:30:52 +0000 (UTC)
X-FDA: 85452105144.07.4E1DD7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B955440008
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:30:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RPLWnijZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795098650;
	b=FoyvOY8hUYIZjNIOW4YPDllh8WgrOFB1dp/RDH9OK4jLUHcBxVHbsHZ5RhkNqgz25KRTDl
	pWNmQeK+o6fvwha/7cNg70Wxlum2ZDbr6tfQwxpigWHzCHuR7jyaPmxDwFuFOXAgmMXxKy
	FNjzuFGucvNoUOeaQYvw0x9lRK9S7pw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795098650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/C1DKA2mG967MO6KAH7vKhZoLEilrqj2aGc1tORCpc=;
	b=5jSIQQit0b18zBPAcPni8J9AtECuXe+ihoUGcddbdBu0/E/Xdjzi8x20Tcl9/MegodJKDl
	0brc0qPQi7U3bdYeHhkwi2kBaKBVcJdtmUQdToBDYn/AOIdT9NIGyIjY4pp/5OnrZSy8nA
	+pptYy+ZD+JPLV8dWGZho/iWf/Teeh8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RPLWnijZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1BE5560051;
	Thu, 19 Nov 2026 14:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2E61F000C5;
	Thu, 19 Nov 2026 14:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795098649;
	bh=l/C1DKA2mG967MO6KAH7vKhZoLEilrqj2aGc1tORCpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPLWnijZtzCfSDVs+eh1M2sc5vytM2exqsz117e2JIViupzd1Z5kY2cDMmGCrEXLm
	 K89/a3NI7zfU71LNpzrCAVDBSTrwpPlXhz96JwXu+DoNMmk8pDPTViowIXGYxmqgQr
	 1YbHUd4LH0+VZ7vI6CXy1JW3OZ2yoEdePQp+Swui9yaEwGPoeIYYSkxN7HPlJu3BYr
	 2Uo1Mqsv1l5TTZq9F8asii/mTdaW1RJI/3P0/Jr6jgwH2kJckhLOI8AstlPH1bzK6B
	 sOWym+A9iRtSsDXitybcUNmt/sJspkf4vWTAgg+dLqFgkrS1z6hjsWIqlD0QQ1sEVl
	 bGy+9pyn3dkug==
From: Christian Brauner <brauner@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH] shmem: consume the reserved xattr space despite remount
Date: Thu, 19 Nov 2026 15:30:43 +0100
Message-ID: <20261119-zahlt-mitmachen-genom-b6bca236b924@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <00461f0c866d4a4eb9f50792f0e1f3d0.1@linux-foundation.org>
References: <00461f0c866d4a4eb9f50792f0e1f3d0.1@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1352; i=brauner@kernel.org; h=from:subject:message-id; bh=sL/wvWYqiVFPhGVN8MzDddQMTa/IduVM8SQcJxF+fQw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT95xDeNdGz6uK7yDVLjl7sXlTxaOb96FvGNioqCnzbn jEu6Npb0FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjAR/d2MDN0GfObnZKq7cxxb V5u8Ttc4nd215t/UKoFrLGzs6s1ZBxj+WeRJ16ZLMLOYvg3M2Pki/9xSLs39929sr2NQ1haevUG MGwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B955440008
X-Stat-Signature: bwyc5gn6rwmqyht3sm5w1k57rekuytbx
X-HE-Tag: 1795098650-462368
X-HE-Meta: U2FsdGVkX19njA/wpPyBdPqxKI/Jq+eJwo4yHG55ALKwmCx4QJTk+jXkgQm6C6ZAGpE67BuHKSFXKFTzRbf0TCPcAG3EDxRskKF+0ODuFuLp9fjdo/adAT2AytgCsIn/YjscsBdGn7kx5o/O7QZ2bJNDNosSPj4Lcliq/paiHjUCOjbZ8QUjNIedDzTmS9DBMM3J4PrIQpt9hHXGOIAUbddOtrKURn5XPa2obCS2we9yL0qxWe15SSQE4ZSGLDPmdXvDRHpAW0XpugEQc/TxR+6xX52GYL/OEYQ4qLurEvJzjGWcL80l67t1DFsFIC78jPOnkEIpGSTUWAPAazr9cQS7kpgWVp1PmkN3AycubR2+LJPJ9BCxvn7NE8f0rXEewTb5/p+o9xVfpYJ+9UxLa+DN9hTzHYQj5r4XaegPEUPypKkBGt9KIm81mcpEsc0rvkodohG5VroDSFlgtj6nW+mDAiMaDVoMQTGaqngQKZCJjQo/3TSMr4ie4AANEfzfK+z1Hy/PYXYRFhfQzYhVNMXceMWJa/SiMKXQ2LIwpjpqLAKonZ7jTPOqUJNo8mBCDnYDZhtxcLHBPMfqh73MOS+NC9lKHY9VxBON3MlrYtvt6HCbmkIQFmHSP2/bAQK3jfS5ArApopC1Im/+tlHnJ5okJ6b8Hb+KHWZtcrIDW0iTL3vmsZ01Stwi12Iq4rmBhcRU2Zvgl1Z65e9pmsFw1iV6PiL2d8cUdc0A3RONazarxpmOCCHC4DOWVQRIVuqIGwHZOA4LXFuamHYU6dz/D67LGnYN3qZFBJCXYHvBGmoaytKbS1D9tP5/svFxLqqz8VUTEwu7dKlx05ZOueCzkusW1Ora7R0FeDZ/iy608ucurdsxom/IBCaqZ7JmaYfW0P3Rj9L8ggpvqmsMaWbGzylqljAQfCP7DpKJ2HZh5Y7NqD8w4uEQRBbZqCTkb/5nlmuxUAwk0icLiUpsyLi
 OJHka5d2
 1unXekp/KB5B54OJGQ251aBNw6GLaWYITOOuTQOVKNuNV6Pt4T+LR6rERrVHWJva14CszBmNASic/vPqkiKzjc0YYzo2BKJVMibj3BgNvBM/DNIAEJyhh50/mnaYykt26IsnHGp10OwdEdNk0MQKAYVhepk46WtS7leEq/FIYU9QR/tJBlJV0m7MpD38k12/RCRyzBdCt+yHT8KY5kC+94h3EKoV4touiWwXF5G90CT21k8uztkEk0KK5JgqyJ6mXhwjNjde2ojX6q6Wqm5gGz/PqtnbNe8VLk8ao1J+GmX42y1bdBTqsyjms/1bQj2u2KerDvwJSIUKHq5a4ThpmQha4RuxyBJWzZsy5RHTxFar27VJ3+MKTbU1l/m83FjVuOh2AW0CJTCP4BmnY7xNyOTQjSaQmS/8YbcpwF3SBaT4XTVDViU2oAZ7/pjEDUkrs9yQB/SH6Hk7l8j3maQX46ZPGdEByDAyxvjulizBLSqmCrtvBfopn6fleKs6HNdvdEa7399xwVNeMHr7UcwfGBU7Z8yhoUkxtxn8V2nqGx39xDtaaILwQKf8NwCXQY+cDiF/n6UgYuAjkjId9RSFwvQ6rxs5hFPw+krK9RLvWh+GPuxdDl8ZhE9sX2hWslgI4NmM7GZMZ3cbfvGM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 18 Nov 2026 10:23:05 -0800, Andrew Morton wrote:
> Creating a tmpfs inode can trigger WARN_ON(ispace) in shmem_initxattrs()
> when a concurrent remount sets nr_inodes=0.  With panic_on_warn enabled,
> this warning can panic the machine.
> 
> shmem_initxattrs() reserves space for the security xattrs while inode
> limits are enabled.  It later tests max_inodes again before consuming that
> reservation for each installed xattr.  If remount disables the limit
> between those steps, successfully installed xattrs leave a nonzero
> reservation behind.
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] shmem: consume the reserved xattr space despite remount
      https://git.kernel.org/vfs/vfs/c/274ae8ab278e

