Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6743E7BDAC
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 13:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2518D6B00A7; Mon, 16 Feb 2026 08:33:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E6526B00A8; Mon, 16 Feb 2026 08:33:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0171A6B00A9; Mon, 16 Feb 2026 08:33:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0E9C6B00A7
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:33:01 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E952160D9E
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:33:01 +0000 (UTC)
X-FDA: 84450410562.30.149EE64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id E330F4000F
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O5LM061Q;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771248779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4n/OtfQtjsioeYiPP0I8DDYu4xaxPW0HHUIGvHq/f54=;
	b=2FNJWTvkllsRU+1qzjBZjFq+9AFQg06YNXme15s8Fq9/FnniCvPlsrPxN6FPKbLXzMgs4W
	EJ89hemEXtscH7l/yvqtiVelxwAAkQqmxa6mngXbKNFHzj8zkGq6H7ifPur9WzLY56BDGk
	xN7y8W2c36TGU2xSi6f+MK+lga4Ivqg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O5LM061Q;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771248779; a=rsa-sha256;
	cv=none;
	b=z9ndBQLeW0eIVAiIcOx8xFstUYDiDZOzygdXe4O3tbvoTcje/ftdDk1PwothTVbc/gVrDi
	D+s2r9M7VG8n+gpMNtpApIbBy7iSAFlMjlmnw4P9WKaEkhnGyvcNxB6FELmTkv2BcSbUM2
	9N4PYu3CGAVtBpb5p86ofz68puGFWSw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A66C600B0;
	Mon, 16 Feb 2026 13:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FC7C19423;
	Mon, 16 Feb 2026 13:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771248779;
	bh=RnCZFxNnhxA177tCuXFiB0/3HD/vnvQpBZpzUbgVZdc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=O5LM061Qtdc+RkTJ4/N5R8kAr7hzZ7s50jqzOBi+fEg+kC3HEm/xE24/W1+q4z3pZ
	 l03F5nAjt3apRdw2Ksa5uYkWM9RlxrZELHlHfDvaR2dmdyieuF1gYEA+CLzHG3K5Zo
	 hveIyw8RD/3Rw11fvDlzLVH7svCb4ztZUmwvqM5vkSQy7GKP3rUm2pbNk9PGNRbne6
	 0fd1Of8J6e+ko29M9dK03PakG/AyspXn8i5AyNlU0q5AwVW4IRTwdnwYBU8AVwbTHL
	 naj6c4Bp4Vqree6WggIG5GPCCMGgeKoKzUQroxtjHX3hQr3qLjqDDj+5AvdB9eEDT9
	 O9k6J8KtHhRzA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Feb 2026 14:32:07 +0100
Subject: [PATCH 11/14] xattr: support extended attributes on sockets
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-work-xattr-socket-v1-11-c2efa4f74cb7@kernel.org>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
In-Reply-To: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jeff Layton <jlayton@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
 linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, 
 netdev@vger.kernel.org, Christian Brauner <brauner@kernel.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=1672; i=brauner@kernel.org;
 h=from:subject:message-id; bh=RnCZFxNnhxA177tCuXFiB0/3HD/vnvQpBZpzUbgVZdc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWROlom75pWRtWaXcMwRHq8H2a+DPy2JfKutp7ynLSYjv
 mCC2uT7HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPJ+cbwP5+Hi/3Amr7r9hsn
 bJbv/VPY9fvWH8bTcg+465bnyf6wTWRkuKLrFzW1XyvgQgqbrm5TX2Pi5L1dpevzl3Skn2+YypD
 CCwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: E330F4000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 9y76czwmbkx7tdawtjkf7astue1ccgrk
X-HE-Tag: 1771248779-457651
X-HE-Meta: U2FsdGVkX1/cWvFGKfQUXi6Wg6K4qLlotRm3C9yxlkgMWIqFBLJOPRmkSioJkwm3EVWIAwR1nm04NsUQR48/KZhjd6zGC0eP/qATdfcMPh2FDCeyKxkpPlK0cOfEV2vHv04N5ZZfEwYXoXGL3L4BdTjxYZlJLztWGIi9Uvj4NgMVxsN0+wnpIWZ5da7cITRyAAa1RkwFSkhu+/JOI/sjSchP1mdprwaQhBOOxMeh6tNxfkML4aMqAn3fO05I/hH1pTYwxNrmUDLJfJ06Vn7FlJv3AXEjW/qcFHreDMXc3GLzxx2kz81opZ71aFdU1wDhkNQ6S/9qAz6+DawzeycKtYIHqDv19yv6rvwCguj0+82idNtcIV/7ESj9WK9j5rstmw9MjXF49bYS9G/Y1t2OHtjWcc102V14aEpx4JlTfm2MsbO/qSsDNOBKHlfRNj69VBsegA1whzKcDwbXo/ktgRuAfnn9FedmZXYJYQQaA0/cJMAnT2yekXZvdIa4OG3/gPNiGEuzrf3XSEq2EdDB1sBabRhwLelxQeNm7KCMTd540BdnbvPOJTCa/YENVC/RmJfEbLCwqIXyFZkK3UGBX5PYolUHUiJqbn4avSpxT37QmjTQQpzSDzqC7ODUqre6GYQ2BPHSeycsnmYI39GJpiaVubO4yE8jKUdf9Zv5iStc6JB5/9SetWmx7vy+15naplBtPWorNZxEM56SsryJn+XsI+0oWlfjtcxQ3IEAoDRnxrYEFHUDxCwrgMmO6t0TzQ03Q7wNE81jD6I09nlEVRUILheN9rUG2PILVUFKNOwQWZhKrdg+qLKm+QycABQ+4nCEUKdkZoslyYFepsb+22ESe1UdxLdteZAJiGqUkJytMmLGcBq9aMQPZkGTF/wO2/3nAwBCpGDMjBqSBkPHB3N6XKKZz7nAN5i5i2F+R9e7++659w9hvT9DrjoHjajgp2uT8ZnG1+Dw0dxKeJg
 ap1t/6vV
 EUrJZG1Z50Uc06gPsZjIIc7zHvvJ6LmV918LWAcXjgdODWC3OIE2XI/MxmvbSrAKoM4jPeb0h3LQU9EgfwrAU+5xdCVEQgPtdwPnhkx70IC+EqSyC44I7aGAFIgchc5zaXYDksm6cJ1n013OUiGaLT3aFD2S1CVEzS4G6L2uI4Qi7m/PxNrt1/R+6qQmBPZfXVp+cMDnI5XXYY/s/17Ylso1rtW4GFqw05uu7b0kWRVjSgFjsU+HnF4KGpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow user.* extended attributes on sockets by adding S_IFSOCK to the
xattr_permission() switch statement. Previously user.* xattrs were only
permitted on regular files and directories. Symlinks and special files
including sockets were rejected with -EPERM.

Path-based AF_UNIX sockets have their inodes on the underlying
filesystem (e.g. tmpfs) which already supports user.* xattrs through
simple_xattrs. So for these the permission check was the only thing
missing.

For sockets in sockfs - everything created via socket() including
abstract namespace AF_UNIX sockets - the preceding patch added
simple_xattr storage with per-inode limits. With the permission check
lifted here these sockets can now store user.* xattrs as well.

This enables services to associate metadata with their sockets. For
example, a service using Varlink for IPC can label its socket with
user.varlink=1 allowing eBPF programs to selectively capture traffic
and tools to discover IPC entrypoints by enumerating bound sockets via
netlink. Similarly, protocol negotiation can be performed through xattrs
such as indicating RFC 5424 structured syslog support on /dev/log.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/xattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xattr.c b/fs/xattr.c
index 5e559b1c651f..09ecbaaa1660 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -163,6 +163,8 @@ xattr_permission(struct mnt_idmap *idmap, struct inode *inode,
 			if (inode_owner_or_capable(idmap, inode))
 				break;
 			return -EPERM;
+		case S_IFSOCK:
+			break;
 		default:
 			return xattr_permission_error(mask);
 		}

-- 
2.47.3


