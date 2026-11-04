Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 328A3606A331
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xv/UWXpb
Received: by kanga.kvack.org (Postfix)
	id 5165B6B05B1; Wed,  4 Nov 2026 06:06:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C78B6B05B2; Wed,  4 Nov 2026 06:06:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DE706B05B3; Wed,  4 Nov 2026 06:06:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5496B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:06:24 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6AF29140679
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:06:23 +0000 (UTC)
X-FDA: 85397157846.08.A2A6729
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id A4D18180007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:06:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Xv/UWXpb";
	spf=pass (imf16.hostedemail.com: domain of meven29@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=meven29@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793790381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8O/Rp6nZ3ve9lS3n1SP2Ck1e4kzh3avxuWTAnkwjO20=;
	b=obif216qA//eotbAlcu5coJn7oMpa7Z5hozQfGq4fMZXdn7Jm/aJ2yRqVinUnL68TWrIZ2
	AIvcC2foqMeW6IFlHLxPgDdVoEbx4HMW8yiI1HGjHvLA41/S8sNgwKD7j1uRbLYHGoHUxX
	dvHbq4AQIlzWKAAQHhmPJK0jYgbhpic=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793790381;
	b=0BYMXouk6P+NqKOcJ18WWe3IB7l+WNt7vabAWw8kKPGiwhBbaw3JptXBNFv5bonWR8mCkl
	3BdkbwN97B4RNmHBs6n7JeKPfegSuFQApTRUZqtn8Nz8FZpRmoY9pFxasDFOP0Yth5u/av
	BH+NvNexRZlxZ9igvN1125KTsIXyHBE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Xv/UWXpb";
	spf=pass (imf16.hostedemail.com: domain of meven29@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=meven29@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so5221815e9.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 03:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793790380; x=1794395180; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8O/Rp6nZ3ve9lS3n1SP2Ck1e4kzh3avxuWTAnkwjO20=;
        b=Xv/UWXpb0GyOYwr0TFdoMmyRKfHsGOtMPCasy1FYj7WAlyDABbz4MXwBqMG6EkQjiC
         9r+q6QogP9Al+Nc+9QTI11pAv8H8Im35c0iUxiD7O5vYNE1A7TyzHvqBt3dzafqqLHEy
         uldXeAzYfLoTWQ1HxoHKO+x4INiS2UcKUiz4FOu8agqk4d3PbHp7pYOGFLBmUozO0ZbS
         x2AGAxvv0OGreMZ3G7RyU0q4gPC7CO9JaqQnszd5yGQoBmciQv2Kxh9PuwlP5wFn8mLa
         9a1Qitm/QHVa43NcFBJ/VSB61i39Usicnmw552bWnHxlqGdJ0EGpIOiFOk6eoebIv5Il
         2ZAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793790380; x=1794395180;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8O/Rp6nZ3ve9lS3n1SP2Ck1e4kzh3avxuWTAnkwjO20=;
        b=VzNaTGw43uz+sgHDziLBO7DIqz8BlD/jyRuLCEjHv0TI0wLJvrZgrQP8qH2DUhuCQd
         GcSxR4LT2xHJyU9Nwvhq+0NYqx6Ed8O4Dc3Fim8IDObAEs7I95H11fZR34eAaypddJEP
         2pJQOKhzn7CTFObHvRE+Z4vC3tJVjtCAudteJfYwzei2BsuhofvSNAWi50+2WE18Qrxq
         HzsxEVN5hdJ/FJbJ4mnCn69a65fS5tXp2ItQb0+thOo5DsLuOuLUWZaWpsNeIUt3YiUf
         J6Y5FXVl2g0Fhnku486EA1jwfzzIOmoj5lWtF1NYDrP47s2DF0wY55YhnMHKjGfifBUo
         YPzQ==
X-Forwarded-Encrypted: i=1; AKwUvBx77tTi3HpXbyqMrfKnI6pQfubwM9THbbsv9VRTHNOwHcemyd/JsyN/SctdtBpemCqazSJi/9N9wQ==@kvack.org
X-Gm-Message-State: APuU4Z9PoiquNMiolCwkrxcuX53tJd/7BO9rd3nO//5irFmz7TOMJvwr
	RjFZL1oNiEfbI3Wh9aSS/QJ7DLrTtR6UCDn8H1p3or8Q43VwWzAW7qeJNwVTIFIF
X-Gm-Gg: AYBFou3QL57f1fXg9soztYC3pxiAMZ0LGx8jCr22fjlQBXCN8BUC697ifaMXRhEh/z4
	HAGpkl7tRfptQsFV+YU5rOOLcIFs5wMoI2B5bbqjb+3L3nI3IixZfINJmOd5DsjnHiR5SlHpcYL
	Ou9tB0dEae5q8GsaAx7gAayOuUvNLwWiBfSvDbfcNrRhG9Ox9KBQCQzAzYqsBrFvnl8XeFAr56y
	PKOHHGhPbxUCGQh/S3D++y1kOaZH71tI4f5Ls5hqPpGYmVQRGCjbQ4RclLpuO/4QHfAq4MVuVvl
	TSt/eDlLvngFF/R5jli3VRvkyIUJ2159jP4p+i0XexrYzKhAu4hR4AnXRnARwXtUoYvkvagVPiB
	mKs2tvNx6xePTUfd4x8/VMbbyod+jcKX870/AobxpsaHYspVZpQTLrxij+MupYAa5KuGyC0h/C5
	Cc5YF+tO0pMmLilKoAF+2zlEK0xx4WKtP51wwmJ+zgzyj03T5sohO7gNHkFKISh0occs5y/SPUY
	D2zliot4xpC5Kgnfu3e6ePDwy8+bs/aBkXVkrpYb/1ZU0OBq0RBxHiOtQmqNZ9oDZEcZZ8SKGsD
	Net+Xw240ZBGUtDi6pYwK52mWPwtXLUKU+JE9+QPJ35b0PlovIhuQwumzAwpe8fz61brT3j1/0T
	MHQ7Pfo3y5xrsbVRIV6PFYGhA
X-Received: by 2002:a05:600c:6387:b0:4a2:150f:1605 with SMTP id 5b1f17b1804b1-4ac1904a81amr368417625e9.24.1793790380090;
        Wed, 04 Nov 2026 03:06:20 -0800 (PST)
Received: from meven-thinkpad.home (2a01cb088745e00090de407b41070a01.ipv6.abo.wanadoo.fr. [2a01:cb08:8745:e000:90de:407b:4107:a01])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fed92a753sm3704835f8f.45.2026.11.04.03.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 03:06:19 -0800 (PST)
From: =?UTF-8?q?M=C3=A9ven=20Car?= <meven29@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?q?M=C3=A9ven=20Car?= <meven@kde.org>
Subject: [RFC PATCH v2 0/3] io_uring: add IORING_OP_UTIMENSAT
Date: Wed,  4 Nov 2026 12:06:01 +0100
Message-ID: <20261104110604.126717-1-meven29@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: kj4xzmmu1nffp31f3ty8xh1axwwwesy1
X-Rspamd-Queue-Id: A4D18180007
X-Rspam-User: 
X-HE-Tag: 1793790381-892757
X-HE-Meta: U2FsdGVkX191GW2eK0mMjsUoCwSZ4jY6I/CjR9ga0Q9xMb2z5GVdoYY8HLKZiSThmZeTGHa67cskUh3vd++VircftNIQisLHURCwf0XUv7d+XpV+o2yszMiMV+pIFkABmrLmSFvI8uVLgJAea3D64EzhkZI5Kqp7PGGpvVDl4/y4Elk73nkWJCwrlVjBaCUC6X8D1Sv2Fsu5D6xAnZQg4pRHXTOSTuqNngIWaALiTUUd9ENodCxQ5fJnhm2rzhbcFFdqgFLEcAwrRZRAJbd45VMEPDc/PlkD9P7A40Uj1q8zTC6IB7Eml1NPsD3As1GBo2Xi0DLWaJ2m4PN9yYgrPyHJAm0uLrtgN+HnSpI2eyKxoonNeJqzJ5B1fRIXhmrzLm07yY3SnLXS/EiwWnsDBcFXFzwzNbiW8BmhPRqfhmHaXwMV11tH5/aT5JkRwIghxpuWVzdh0TYwCNak4Lyr59HGYFX56Uknn86IflGIqQpmT14uYZ1c82dma1oMZDXQztLywkxu0m9/IelZAIO03k1dmkDXkymd75RVqIVZL2/FJxGAPjSsC6l15FBI/QWasH6uVtZmzgUwujRNNM/tvyQ83Fp2wFYiYn5LW8f9PStsqNV9AMdueIf0ryryLPZYnLMT/I3V+3Sbqm3amwczsM36aoCbh4V8QXNz2RtYvLXt9ZZ/g+wjdfw0Kr5bg5vW8puLhiFQC0v0AKnmfWXaOX9aeNx7U/kapttFzCa/TNc0ON0MKcc7s7kpk+c9fahOGDRzqOeF7R9EmL1OnD7HtsEs9JdmZs0T+lpoZxnh1HOq5zw4n3qHWOf+aQUgJ70TKn3OEL/I+mnPDup4LYBcvCgDZSoAZOKgEnXkJJ8KlPRhVGNTpmef1/bYndCTy6b73tR4Sv45M2ifsMMaZb86tSTALDo5tF0gSZGHco8nPxLqyMiS8V+eFRbV3Hbo5gm8p/4EPsudDu3w7qGPjg3
 Ds3t6xcp
 8z6dVcS9jRlDVunyBA8h4/tTAJVpibUkF3EHwXB4LaYXZBPlEVm9uyCUBdOh2XA4tlxiipVWUbwLDGxZtbv1S1wsoznqbL+GwbujEMmox60h/WNQXk0YCLpDN3gfP/l3AO5LludYLaSfYx4xL2zwFrSKZi1XoZOm3Hg/pIFAPQE9IBLu8ra/HystNNpiRaCH7t/HuVo4R4cipj7KikyYQlXrXtb6M0wfXSKuP88eujLHyq8e+1SvbNQVyojalN68oUOho+d+bdwl7Kl0uShKpgQKQ1s0NpSvbqlpxbbPcTbHowMsrMECmoceh07fe9XZnjHI7IA+lmNGFHFBKEY/nk7sMd7rpwxyEd0Vem4cFPGtsQZJOL9MSBi25g71/fbW6MLPmSVkEdQ/LBIU5fu6L1XrXk53BN6VnewV0I3LdlRSq6vyyvrEUw99BFmohuXiPXzP3IrM9O78gE73Zb4+wppLRKC3QipuIdOrcEOObsR/3Ve0v9TizsQ3GofUj9j3LjRmlWtyJKbJy5RkR44CeaE9yP/RoNyVLHfyJmPGicUe7bsfvWFwPxrzfLYcmTRdb71Iv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Méven Car <meven@kde.org>

A file manager or cp -p that copies many files sets the times of every
copy after its last write. KDE's KIO does not use io_uring yet, but
could in the future. In a KIO prototype that copies batches of small
files through io_uring, open, create, read and write run in the ring,
but the metadata of each copy is set outside the ring, with futimens()
and, when needed, fchmod() and fchown(). On NFS and SMB each of these
calls is a round trip to the server.

In that prototype, setting the metadata from a pool of 16 threads
instead of one file at a time cut the copy of 200 files of 4 KiB by 22%
on NFS and 45% on SMB. The test copied from ext4 to an NFS 4.2 and an
SMB mount of the same machine, over loopback with a netem delay of 2 ms
each way. An opcode would give the same parallelism from the ring, and
would let a copy be one linked chain per file: WRITE, UTIMENSAT, CLOSE.

Patch 1 splits filename_utimensat() out of do_utimes_path(), so that
io_uring can pass a name imported at submission time, as it does for
mkdirat and the other path ops.

Patch 2 adds IORING_OP_UTIMENSAT with the semantics of utimensat(2).
Like the other path ops it runs from io-wq.

Patch 3 is the RFC part. On a local filesystem the handoff to io-wq
costs more than the setattr: in a qemu guest on v7.2.3, setting the
times of 2000 files on tmpfs took 6-8 ms with utimensat(2) and 19-29 ms
through the ring with patch 2 alone, 32 requests per submit. The patch
tries the request inline with LOOKUP_CACHED and trylocks, on filesystems
that declare FS_SETATTR_TIMES_NOWAIT, which only tmpfs sets. The ring
then matches the syscall (6.4-6.8 ms). ext4, xfs and btrfs cannot set
the flag, because their ->setattr() starts a journal transaction. Is a
per-filesystem flag acceptable here, or would you rather keep patch 2
alone?

IORING_OP_FCHMOD was proposed in 2024 [1] and not merged. The same
questions apply to fchmod and fchown, which a copy also needs, and a
single setattr opcode could set the mode, owner and times in one
->setattr() call. I started with the times because a copy always sets
them.

Testing: a userspace test of 30 cases (paths, AT_EMPTY_PATH on O_PATH
fds, NULL path, UTIME_OMIT, permission and read-only errors, links, copy
at submission, inline on tmpfs and punt on ramfs) passes in a qemu
guest on for-7.4/io_uring. v1 also passed on v7.2.3. A liburing helper,
test and man page will follow if the interface is acceptable.

[1] https://lore.kernel.org/io-uring/e291085644e14b3eb4d1c3995098bf4e@huawei.com/

Changes in v2:
- A NULL path now sets the times through the fd itself, like
  do_utimes_fd(), instead of a lookup of an empty name. As with
  utimensat(2), it takes no flags (-EINVAL), an O_PATH fd gives -EBADF,
  and an open file that was unlinked needs no revalidation. (Sashiko)
- Patch 3: the nowait attempt passes no delegated_inode to
  notify_change(), so a delegation gives -EWOULDBLOCK. v1 read di_inode,
  which does not build with CONFIG_FILE_LOCKING=n. (Sashiko)
- Patch 2 message: drop the wrong claim that AT_EMPTY_PATH on an O_PATH
  fd differs from the syscall.
- Not changed: the inline lookup can still call ->d_weak_revalidate()
  and audit_inode() before __vfs_utimes() returns -EAGAIN for a
  filesystem without FS_SETATTR_TIMES_NOWAIT. IORING_OP_OPENAT does the
  same lookup inline, but rarely fails after it, while here every
  request on ext4, xfs or btrfs looks the path up twice. (Sashiko)

v1: https://lore.kernel.org/io-uring/20261030123945.1704118-1-meven@kde.org/

Méven Car (3):
  fs: add filename_utimensat()
  io_uring: add support for utimensat
  io_uring: set times inline when the filesystem cannot sleep

 fs/internal.h                 |   5 ++
 fs/namespace.c                |  20 +++++++
 fs/utimes.c                   |  53 +++++++++++++----
 include/linux/fs.h            |   1 +
 include/uapi/linux/io_uring.h |   2 +
 io_uring/fs.c                 | 103 ++++++++++++++++++++++++++++++++++
 io_uring/fs.h                 |   4 ++
 io_uring/opdef.c              |   8 +++
 mm/shmem.c                    |   3 +-
 9 files changed, 187 insertions(+), 12 deletions(-)


base-commit: ecb6817b769fd7d71af2c9f446188649020b2e53
-- 
2.56.0


