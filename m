Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24DC7606A33E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 12:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GSqeKtqa
Received: by kanga.kvack.org (Postfix)
	id 310E76B05B5; Fri, 30 Oct 2026 08:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1BD6B05B6; Fri, 30 Oct 2026 08:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188616B05B7; Fri, 30 Oct 2026 08:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBF346B05B5
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:39:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 39BDF406B8
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:39:57 +0000 (UTC)
X-FDA: 85379249634.07.EA7CCA3
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 66E1418000B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:39:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GSqeKtqa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of meven29@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=meven29@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793363995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RUJ2gwwAbHEm4tvJt9u+cB77ZI1OokWfWjFrziXQD/Q=;
	b=eIb5afz65s7wpB/bECRkHYiPMBKPRpwgurjyzU6S2Rqxr/9jssg+oxTNqqcaljhmp3zxav
	+djFi6k+7KeI/UV1ecd9Fo1Msi9DmTMxmAft+TY2rQnEq7CjYBmonCgj8MatkP6GRXPV+c
	4CSdt8Ci4Jn5WxDyamVWtygb9cw6GX0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GSqeKtqa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of meven29@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=meven29@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793363995;
	b=X1lAqQs6/VUGqlvQcAYGuZ4ZAJW4j4P96IDShq+9qr09L5n5z1nDdA4qLGx+w0BPzrLjQb
	Uh35W5q5jNw1FdyEHbaSLf4Xf5O6lktWzxIVO459Rwa66br0IDfuxYxmrRxIjH5V/OOor0
	EY2Hodn6LpIxZyPoM90pIJljYNDfJrE=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48df4f540ebso318910f8f.3
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793363994; x=1793968794; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RUJ2gwwAbHEm4tvJt9u+cB77ZI1OokWfWjFrziXQD/Q=;
        b=GSqeKtqa45qfA4FOpqExfJhkvxSobHv/T2YBhoa1NOrvapo2Qhhs48vaSFlE/xItmV
         BDCIqwa3IoCnzrz9P4ljAof9hPODGbElUGfJQ3LEWewgR2BnGWz/emPNtUd5sGUIzMPN
         AMy+RpZ48nuv5Rf0i/XxivfidB7OhNkHXBaTpuj5VXJyor1H/hkHptb4CxAJ0mgmJVY0
         FbYEL8BdGpyWhItCheyaWtFyig8wN16ffouNHe3HiCA6avrcRU2gJO3YDwn8aG5xzyOf
         rIJZz5coj+p5TlTDC5X2jRAc41SqceyyOTWQzy+4VrxoNxxCDx36E1uktbeZ1iwpDYNs
         4k5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793363994; x=1793968794;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RUJ2gwwAbHEm4tvJt9u+cB77ZI1OokWfWjFrziXQD/Q=;
        b=eroTh37hYd8tmOsHUwH541nIUT0bupd21Z98Im3BQJvclaqJg+/wzeIuKlyFqIFEEu
         a/JGQs3q1HITmzyaxRHbwzYmG2TS6ywrCefGiuWmckQYlud3jXDgKTx+jkFfTeYGplu4
         +PfNvO1WEEHckMNFGKjUfiF39sgjYJ+ciOae/SQ3NerBSsLk6+fTCObN7gMY9KhqYet/
         7K2WCrpSj9UDgX0uQFKyHU2sew7oFPl1IrPTbVGw207Ynu3bUQ5yFYfuCQXbERSuMl1g
         AdtA+kjbd+zi5UjIJ8ZL95LuSQX1zs1PiM8O6oX4DprE15PHiGpBLVBaDoDM+ZQACNO6
         Okpw==
X-Forwarded-Encrypted: i=1; AKwUvBwhxeZjWB1rFxfDIQEVgEKswnr3YXePKgFxlmFmA6cRz/hjdMlVA/pJq/h4tDbh0coQXASJwl2aBg==@kvack.org
X-Gm-Message-State: AFq9FYLX1vt55y7w1tdy56nYdjMx9xHtcqsKIhU7HOYhi4UutzLZ1nAD
	EImCCbOudBiqwpRt83OtIoErtvtl7Umtw4/YdKo3hcx4+84u9nRNMUw9
X-Gm-Gg: AYBFou1vwOZQwyFTGDVnyeOoVrkCvqHG30D2dk5fqsJwj14dfQ5FlU4x39zEpPMZquP
	V17zYfakh3F4i9V9NRZH7aF8ah+W0Y3UBBFU3n+um0TlNsUd88SkggB/m9PNRaEvg+CilvpG5x7
	jkwDZF7LA/yM5oLNihP8L4fBRa4cl5i5818QIpIhQvB+t7m8SgT3+bCDww1P9SaT7ewyEJfDof8
	FKG9zEvc0139qPxUbVk8I5IHplLWGCpgqo+iohRfJYvcevCsiV25mONnQ4r2dN22drqPA50eFIe
	KoREedx7Jmkl9ZPP8I0de2TaaNNwBlAmww+WZbARmHDt+4E1NpjthleyohOUGUno7MdyNvyZYV6
	Se2zlWZ9xMiCjSnFc7hiNWmO/wMWmpcWEDmfPT/4kNGADJ32IwqoPvxPqqjrv8ojVLJmFhpq0W5
	Mv7dPdaoKeUxqG+W3yvJlBBUtxoN00CiCcWOCY2DueRUEvDLT9SFm0a7EaxlIxAbCNegdCtUqGb
	RNoznmhELLbe1c9uK21b/n0NahLEHBOJTyO6IDo3VRdq/cercx5nPuY+QR/kt3CtDbWDdGg2YRt
	PxvFjmEA04JYgFCQrApXK3+NkcyQkw6tznWYy+OImNbY+JoAzNc+Kb18mvsztUyPfCXDVILYGbE
	o+dr1wLHLmEuetxvpdJqg
X-Received: by 2002:a05:6000:24c5:b0:48e:d7c:4bc8 with SMTP id ffacd0b85a97d-48e6e2bdddbmr5939049f8f.7.1793363993170;
        Fri, 30 Oct 2026 05:39:53 -0700 (PDT)
Received: from meven-thinkpad.home (2a01cb088745e00090de407b41070a01.ipv6.abo.wanadoo.fr. [2a01:cb08:8745:e000:90de:407b:4107:a01])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a4csm3088971f8f.23.2026.10.30.05.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 05:39:52 -0700 (PDT)
From: "=?UTF-8?q?M=C3=A9ven=20Car?=" <meven29@gmail.com>
X-Google-Original-From: =?UTF-8?q?M=C3=A9ven=20Car?= <meven@kde.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/3] io_uring: add IORING_OP_UTIMENSAT
Date: Fri, 30 Oct 2026 13:39:42 +0100
Message-ID: <20261030123945.1704118-1-meven@kde.org>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 66E1418000B
X-Stat-Signature: 9dn7n815zufaajzrkx16rdnwwxa9i6bw
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793363995-117806
X-HE-Meta: U2FsdGVkX1+OfzhDsUfxd8aUw+BtGHzSp1l/KNqQXsXASFWVqC4feUMmEk2hs+nrzG7iZtCX5Bm/voITScbrfRTTFdE5TWNoiRTDhJ6IZOQ9kFDJM5mfjzlbYZB/q7ogwUHYPwFiknDpmXkQUChCMK3mAI27ikC0KYPqdJ7A6/9HYD1vNbBZKAvBNqnB1koWHfW0lMGnofUvKQDGGOu+Ct2dsjRjuRSjEEr5EuB91jXveGi2x7vsJc86G4Q4McC6eq3hfv9UljuTqQiyDo5fBtfHtZNUkSPi7BI2A3IZjFGjigU5ZE1z1oyHX60xGASjyWWnyKtoaLj1gvQcDixf5j4HnPfyGbV5wWHoL5FuQkzH02Q0Wwycx+JYkIbMKgj4OVPUAinCK4h/1o+/7oSRKh3GKVUtaMEsSOu62/Zj/uEYwH0CHvhdvygxVAmH4E/3u0lWeJdBSxXpQTt/mGR3kJRWAYj5G5DnOXEwp7KXCWYCSnfPgnDLqI47SuoVOU5D0sLFVSC9qEzYtfaataxPRjRoJyWbmJlhU4lU02awQklFqgQrbXdSRSDIca0+queIMAYCOKejaZ6HDMBnbwAHcR+RnGZv0hU3mBnBvyIW2EKSLL7fXTunDF+xvrQwG7x+wsVNzaYcBJ0/ewEE5ZIwTjBhdPWcWZV8LblaHnyVnsthYOvbEBOz4Sbuuw9cBBTBMAC0+q3OgY2bfTRcCzCLk4c0E0Wj2bYpSP/mWHS4QU9n0QH06iKciw8QO2q0+B7ffLAFoXuwfloABqUhsjZ0Up3lNjFopszn9vSKS+8aRCNstkI887fA5GregIO0D6deBndbUenq3sp9nEDfN5ez+tf5ZIibTcd8ZU85A59A9Rn2gMPmJP31auimnvhKi3C7yzIqrlpRGpEsQyqWYoJDeCefuZFe1f9eUe48YOpVyr8N5EIDPWBhr1qbMMH9vR6r2c5GZD0lAyrmah3cCre
 /ARa+Gjx
 VVsM2dqr18d2hAU9iYGCA0o/686SifZGYHyR4Fwb4dHyNAM+gCRn3D+tmbiYme9t8HzIIbLJjFTYLUrAdJK2vOx06Eu8uF17qj/aMV5IMRzmE9Fl/KgPXv5mTDeZhJyqbUvLlUORqk4TX+vH2+JVU1l5FAUMyQb/wigfnHw3WyoH8RkYJ9OFLI1JHB/VwBMC0KI1fuXa/yyHs50i7lc4L3Hi+5/JgeLyveiO7LOEwWGmMFm+OGZ8FyewbWXvmCtuHyFOZzqWkT30poKtiwxyeuy7p8jRDRR13RGdu1W7idK7QKFR9ItG1FcH4aYbjd4SR1pmO6FfrW7YwgSbB92HvwFDmkiDSMALuQ63ueiaOc+lKimmc5TAC0QMBdd2oN6kKyH2BdWG45SWnxkuco56JdrqCBBkCmyCs2pDQya37DtJw8Oesi+Z3878cuPgnYv6KrgrsM+TKlf6ad5w5JNJBzYJdg16Kfn5SXK1+ElXvM2ySnbTDkZvOPYqMslLBFnXBDlY74sg5GhEasOX8ojoJ8GtLKDPx3UffXwVrJuBfSQJ7N5acT6YsBjqm5uqhJmrpIYMUJ+uESU1Pz/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

Testing: a userspace test of 28 cases (paths, AT_EMPTY_PATH on O_PATH
fds, NULL path, UTIME_OMIT, permission and read-only errors, links, copy
at submission, inline on tmpfs and punt on ramfs) passes in a qemu
guest, on v7.2.3 and on for-7.4/io_uring. A liburing helper, test and
man page will follow if the interface is acceptable.

[1] https://lore.kernel.org/io-uring/e291085644e14b3eb4d1c3995098bf4e@huawei.com/

Méven Car (3):
  fs: add filename_utimensat()
  io_uring: add support for utimensat
  io_uring: set times inline when the filesystem cannot sleep

 fs/internal.h                 |   3 +
 fs/namespace.c                |  20 +++++++
 fs/utimes.c                   |  56 ++++++++++++++----
 include/linux/fs.h            |   1 +
 include/uapi/linux/io_uring.h |   2 +
 io_uring/fs.c                 | 105 ++++++++++++++++++++++++++++++++++
 io_uring/fs.h                 |   4 ++
 io_uring/opdef.c              |   8 +++
 mm/shmem.c                    |   3 +-
 9 files changed, 191 insertions(+), 11 deletions(-)


base-commit: ecb6817b769fd7d71af2c9f446188649020b2e53
-- 
2.56.0


