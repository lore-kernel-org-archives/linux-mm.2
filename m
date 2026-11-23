Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4248F606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VM6v+3Lg
Received: by kanga.kvack.org (Postfix)
	id 34D576B05B4; Mon, 23 Nov 2026 00:17:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324846B05B5; Mon, 23 Nov 2026 00:17:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 214496B05B6; Mon, 23 Nov 2026 00:17:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAACF6B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:17:05 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F30BF1A0792
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:17:04 +0000 (UTC)
X-FDA: 85465224768.21.917C19C
Received: from mta1.migadu.com (out-19.mta1.migadu.com [95.215.58.19])
	by imf09.hostedemail.com (Postfix) with ESMTP id 08EF4140003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:17:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VM6v+3Lg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.19 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795411023;
	b=qrsCQcIVrolYsR7l93KEIb/y8CH62qwaQHQmyTbULDEpjMHhPh+I7xVw26X+z3BpJchCDm
	SaKlWiBzjWr6rDiNPItYlsHmFLl/1p8p6egIWPZoqxI4lfzEHp23nbCGfW0OrQRg4v4tdJ
	QcMZvrwvJD5aD+H9CK0Pfj3TUZdeizU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795411023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l7hTPYaQuZs5nowzDqnJXIkZEzk+2TqU+4QHS0z+lDQ=;
	b=byfjocUKmup/Nbq8m+d0U8ZCWYgOlO7CNN9zuA78Gkn88votAdQAlZt1J038TRnMLpyLX6
	qtQ/2pfJflMzkZj7A14IcbtoyVh3cE3cy2c8VB8uOgLtOaZVKnhNIf71IT2vyH5S1OTGMO
	iITndGKADUif9baDtYKoN0O7GNJ3/hQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VM6v+3Lg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.19 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2ZEKg+Jrv+kzCPhpX87e5eDbagmnSnp9jrTVnPFquSQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795411021; v=1; x=1796015821;
 b=VM6v+3LgFBxb1Ek0dfJfV0DNwZd1Ll2q4QRrjqvqSwDimdWPIbVwueCN9Wnkrkci6owpWzVe
 cImJ8qDAZycmtyTHi42ktzvUDwxV25ZVBQdaJB0J7GkbOrJHLG6FYFAZYIotcdE/eM0zIlZ5p8Z
 pS6LYlhD0JHzs9rD39qLc/zE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d9d86598382e1741;
	Mon, 23 Nov 2026 05:17:01 +0000
X-Mizu-Trace-ID: d9d86598382e1741
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: hughd@google.com,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	baolin.wang@linux.alibaba.com,
	andrealmeid@igalia.com,
	krisman@suse.de,
	linux-fsdevel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH 2/2] Documentation: tmpfs: document casefold option constraints
Date: Mon, 23 Nov 2026 13:16:29 +0800
Message-ID: <20261123051629.2547645-3-cui.tao@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261123051629.2547645-1-cui.tao@linux.dev>
References: <20261123051629.2547645-1-cui.tao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6q111w8xz89wf55itxp5w4y6ig77dpim
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 08EF4140003
X-HE-Tag: 1795411022-238272
X-HE-Meta: U2FsdGVkX18Fvi79RefKAzz/R3d2UiYZ6VpRJ0dIZ+wetVQCb9m8uVMMwRiFILGCFcU4OToZrYJj3eqyUsVFzbAkpZsBj6QpGJd991JXMkZZtjga2stEbGkvxhEwKT8G7mmv5TSnCf4NBwZLomp2lQrj4pbpV51xowNTwCxaOpHZoCVwLOarsjGq4B0rG7qg6RHGbu/LvsMwBssZsAmMEiW0ZjdqrwHAtnecDx3dSD8xYAo5fJuWb20fzdvXfq0F8KPo+Oyz772bSZgtsLOCpSWp4yw6pYmRBgHWO89oH4AnCJQnkyJ/Jiq4jCCkgoB9dXEvXwa4PSL1xqvs1Bbk8NGMFB6JPo4PWHdydYA7o9RTZ2Lp2/vFXV5k1plu2MaW7LqwiwhANudST0MAIZCpe8GC2j0l9vJCRx6qD9fl5OtFmQYJVwGhT0ALw7zvUa7fxzQFowWPZ6WR20dbasRuuqWoihrD5m3dxkUWinC+wG83vjwSJxLMFl99Q4Tru4inLy6nzoZ6Zj126M5E6+GiF4H6oMeKlN3SgWjmFehcurwN5CjAlP/23Ecx4qxz3lcvCUmXoTqEZepDBnSSg1WbnUvbqpWBJ7oBh3Nc88tkkWhyah3FQjsGegdUk/ZyNaD8X9s27tm/iKAW9ecnsmP/Yx8GNZn+lhSF8HYqqE0QLXFTrWnhpedc6uusNG0yvRxZhJphYM+pM6SITgtwnPXDPBjkf93+BenUMO40jnO5tmiX75BHKJfL812m5z6RBzkZLg+VWm4yfmIW5zaYLMjjSu/PAYPiaXdVjCjP8MHkQsMRRlsQBDAyXpRQ6G37jVx6948z6vy5D1M2P1JTRxkwnyHmBcLPwdwKJTadhrQPRpkDsG59f1ocorh9zetF5gOfqCK+NJkxOgQIg71HSCPvsKk2hajgNyf+eFXDcOQr1Yd+UwCDMlyF+XJskWcNWqzIOPG+MHJPNBa+0/T66ru
 Ot+OSkMd
 98rqjliQEJbkp/dv67BPotzQVPx+nzPu5kRzH0D5ctm1aeRFaC766HwmgaaKLA4C+eoHt0X4kEkp8GVDSgD1YPFY6YH3LynU93uJl5DhPzPYq9DM3VANQMACJ1j6ztjJFhAXVMm2MMupONPnzRr1P1Nn9h6uBGaksItHrBNnkLVv97h1HmArGhtoTemGH9aFn9jDSL64mRiayMffAtTNOPBGkOEzdRkhUEycWsomAOFWXhlGv9xay8zW8OxKFBlOCfvEUm9+Ts750b7DOj+1BgtQuURkxcX8ZJP8s9/TETKNW6v1XznfoSRq7DiJzf7i3v09yWA0LBRUdCfdEn9+GHXWfEm300AwzvnpDvLmJVNaBeflgf3eb/2Ra2GpMAtW6OZtzUY4IScVrn4roML0JdKZ3S1F21SLbw6FgVaQabLGbjJESRZkMDkv7ZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Tao Cui <cuitao@kylinos.cn>

The casefold and strict_encoding options require CONFIG_UNICODE (both
are refused without it), strict_encoding must be given together with
casefold, and availability can be probed via
/sys/fs/tmpfs/features/casefold.  None of this was documented.

Also disclose that both options only take effect at initial mount and
are ignored on remount: shmem_reconfigure() never looks at the parsed
encoding, so e.g. "remount,casefold=utf8-12.1.0" succeeds without
changing anything, the same way as the mode, uid and gid options.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/filesystems/tmpfs.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/filesystems/tmpfs.rst b/Documentation/filesystems/tmpfs.rst
index d677e0428c3f..032fa55b0411 100644
--- a/Documentation/filesystems/tmpfs.rst
+++ b/Documentation/filesystems/tmpfs.rst
@@ -253,6 +253,15 @@ strict_encoding   Enable strict encoding at this mount point (disabled by
                   and directory with names containing invalid UTF-8 characters.
 ================= ==============================================================
 
+These options require kernel support for casefolding (CONFIG_UNICODE)
+and are refused without it.  strict_encoding must be given together
+with casefold on the same mount; a mount with strict_encoding but no
+encoding fails.  Whether the running kernel supports casefold at all
+can be probed by reading /sys/fs/tmpfs/features/casefold.
+
+casefold and strict_encoding only take effect when given at initial
+mount; on remount they are ignored.
+
 This option doesn't render the entire filesystem case-insensitive. One needs to
 still set the casefold flag per directory, by flipping the +F attribute in an
 empty directory. Nevertheless, new directories will inherit the attribute. The
-- 
2.53.0


