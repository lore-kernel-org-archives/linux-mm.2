Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C7B6606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 10:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SjGcpl8L
Received: by kanga.kvack.org (Postfix)
	id 41EF66B06B6; Wed, 21 Oct 2026 06:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F6356B06B8; Wed, 21 Oct 2026 06:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30BE16B06B9; Wed, 21 Oct 2026 06:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1C16B06B6
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:51:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DFC9C1A049F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:51:15 +0000 (UTC)
X-FDA: 85346316510.10.F112DDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1F7441C0004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:51:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SjGcpl8L;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792579874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pv/mWp8e32UIW/KhC7RMCBsIZF7VkdvId6YoZeXvbL8=;
	b=T8EQRnMUQMDTVlG70ngiMKrkGtRAww2ocuknGtyBy1LvptNVBOsqYBHCVFNlXdNHqMTEph
	7h9GjzN3w2rNjA+eNiKk6/9o4srnDaDBbVuqd/n4YwX4hb1fYtKRnXrrrPICsQi/PsGOvR
	EQWw3omhmqPwPqaz26Z4gjKlhrgtXBQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792579874;
	b=aobe/Iy1S9vIv8gTtHvr2oqVVkHIHTu+B5OKMC1msqrCfR/5+7uT20T5dGe9/fAVZzu4Gw
	Vh7K3EVrq/XFwXkKr3WEhWzbaXRNFqsTV9iHRqwc5abb00va5m7eJ40Wue2LxguxRzfIkt
	rj/CeXSRwwzKN6p2yD3Xwqagvx0V2H0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SjGcpl8L;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A3437601FD;
	Wed, 21 Oct 2026 10:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8FB1F000C9;
	Wed, 21 Oct 2026 10:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792579873;
	bh=pv/mWp8e32UIW/KhC7RMCBsIZF7VkdvId6YoZeXvbL8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=SjGcpl8LZWnLPQ4NhFcS4lP8VNZ3Dq4g+UwoYE5SMjabraUbfmpFaTB+6jX2UzclR
	 yF1gQ4GKMWzFsfP/8/6qiaFCNXinU7Js67IotpXsL2/fOIJCb0f0BcnK4Kp76bOaI9
	 H83Sq9JjWwabNYGIZhpRozC1V9eogjaLLKXsVPKV1hRCCw++drsq7msrGGqET87kb1
	 +CnqV1RuhZMVZCQAXCZWyh5KwZ/V1pYKeJi28kQ9OpMk/0QUB2U7n+vKXmlAOxw6kt
	 78AOJktL2CmwllxwiXMi0Lm7pjagRTSaC5xH03aEk7WCmEqaWPt4MMcMvPWyvIbVf6
	 ViGcjVMionarg==
From: Christian Brauner <brauner@kernel.org>
To: viro@zeniv.linux.org.uk, 
 Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: jack@suse.cz, willy@infradead.org, hughd@google.com, 
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, 
 syzbot+399510418a0b0cf1fc29@syzkaller.appspotmail.com
In-Reply-To: <20261016171718.243099-1-ngocthang2710.1999@gmail.com>
References: <20261016171718.243099-1-ngocthang2710.1999@gmail.com>
Subject: Re: [PATCH] fs: annotate lockless file position updates in
 sendfile
Message-Id: <20261021-bemessen-kilometer-ortseinfahrt-907210419f27@brauner>
Date: Wed, 21 Oct 2026 12:51:06 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=900; i=brauner@kernel.org;
 h=from:subject:message-id; bh=k6klOoG1mIa9pd9DWLIybiterbHzOaQ9v13BkaR/ILI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTdmCnz4Oyjt8tfxv1ln8J2+M788mpnr5In058G+Z88y
 ZeSm8/v3VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRm8KMDG37q6XkX0y8q3Nz
 oUCJ95KpV/asmjExc8FtHtvoeEGVRWoM/8vX+V2pVZ1U9vKBhvGEoIvh7TcqJtednJjz7dpZybB
 ERT4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1F7441C0004
X-Stat-Signature: sjxx4d6rdycwh1jwawhjemqjjgebedse
X-Rspam-User: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792579874-763016
X-HE-Meta: U2FsdGVkX1/lzJmMsBsN+O63MkU6RA6xr2oFR5T82BEK4A8qxVuacNIqTSJxTeW7seFmvjLP94cBUQs++2OlL19bux5CTNddwy6oyoW+ciFiYMBN/5O8OqyQ4hvsTzN5xDsiJLnaEd+JOJmokusAaZNhk099Z7/KeAHIwZ2BT41+8GAW81ei9YCRLhOrzcbnjrJ0woxJsn1fL1NKNcjsigqeLiDHaAyVkz7/+M4JDT6asWRwqd9y31SaDc+TKYhbff9HMuhPzIE5M6ebC9glj7b3pHql4RSpJHeH3yxMIfQOQrJDNZl6zGA7fEqUuqFojQjgqhvjdcz7qnH2s5Kd0tPztle517lgF9ZsHnwNZCUS9pIpPl/OAXLt1jhE7ihmgNN1VQp+VhY6MdHClLdDV0irw+enaHmDhYlKl57gRJVXuU+4+GssHif7uJWEcpyLA/ZfxSKbo5MDJ8EbWwiL0vI7u/Bx3V8dsrronuz7Fb++P0oAahe0SYX3S+Oal/WsOcx3//+Bhh+4uT9d7BqU8X9VZFnyDUNp0c3jLsXELsmNrpFobMBVdQ9rfCfeN0qgOeoxsqvSU2Y8HqL6yYG3NF74L36CDTWx/r0+9kT08GGyN4O90lLJjB9Bg5ExENU0+kZjpTBS/mcYoH4DdDeIO0YV+198XIx+8/KkGkZeTZ/Q/c/17T4ThuATvkEBpwnyYc98UDdizQVXl423nypVDv8VpAdyWjkYhucm9IvfL1LuwGqXfr/qdF6nKJ/8S4kYspxVnFihsdiBB2DDvsZR9LFpAk/w4T0Eu6ywhPWTpSooCj5Xx8YABjDCFOx6Cd4/DzYOc1hQeDYf26FAtFxkrgBtWxGKCQSYxO/7HccGoAdQApUNxOXxARbRUaeFJevTGJJq1W+KEL4tq/6qbh8iD1dMXkIvMKC5RjP9ZHvUexGg3xI6tBuf9FWFi9qPoCrCawKNsoxDRXN3CUIDyGG
 DkCDnKvq
 WsC+1Rl8vGVtdxU0+B+p5wnOwyIJ3yeEF4g0VySMXnxMIERZ3DngGQAESbv5l1bOscKat/j07yY6OsG/FBciF6TONLRJwQRSuaaTsS6BDOpURYXCkgXg4uXiq5BcTkGq5SKaWcCt9djjXNGlT3iaQ1OY27Ax8UFYHvJjgVYatjvR7BCGgjkrGW33GtfW6JSX94FOogfAHhkoE2pbOtVp69/zAGZy71LVEdQpUHoaMqIhJNbLgQbCXWaOJg7qltNwxkZYzz9NyXc2I8VfpWSJj0K4s4a6f/BtX5yeNwiH4Aqcq2xLKnQGieQO7cT9AJQ11jXmCFA8aYv+pF9sh3pyc9FFABnPLUivQwuqn345+cerAivzyH4806tFJXfUWifWr7Vgux7IUmIm2KZySE0bJ2zsTmHATMVWnzd+xd4pXWaXe/YU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 17 Oct 2026 00:17:18 +0700, Nguyen Ngoc Thang wrote:
> fs: annotate lockless file position updates in sendfile

Applied to the vfs-7.5.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.5.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.5.misc

[1/1] fs: annotate lockless file position updates in sendfile
      https://git.kernel.org/vfs/vfs/c/f43bd96c7258


