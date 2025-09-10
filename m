Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 951C8CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 01:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3F708E0002; Tue,  9 Sep 2025 21:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC2F8E000D; Tue,  9 Sep 2025 21:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDAFD8E0002; Tue,  9 Sep 2025 21:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA4F56B000D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:53:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4263111AA5E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:53:49 +0000 (UTC)
X-FDA: 83871669378.26.F8A0C4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9446380006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:53:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WOvBDMUm;
	spf=pass (imf02.hostedemail.com: domain of trondmy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=trondmy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757469227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55wq/f1cb6s/9pF5KMJKT2HnWPh5WEA8I0kPp5UERPs=;
	b=lLU3HDB7CFcECkMHuP0K2d8S1V9Eb79BEi8CBxANV1xBV21WooRr9aA2AmybBKY/x3ir5N
	EeB4Aw2+IqWiRpkngWrhVCjModn1VIGrdy5TfpYmRidu8ye3Rk0h56E2HJ+67vJy5eKVyW
	zKYy+iob+DmWud3ZR1dq83Jlo79JTEU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WOvBDMUm;
	spf=pass (imf02.hostedemail.com: domain of trondmy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=trondmy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757469227; a=rsa-sha256;
	cv=none;
	b=FkeI9qw4el1CQHWWDSaiUkgi5Q/cFm5Sh0iqcWl3gz1/bML4+g9Kzsp189gOg2DClgH4rb
	oI49URSYeTKgOas8t405HN2EleF+RhYszd0RJHnneGB1dgjZTiDob/zsgt9psSuApaleKJ
	fbHLU3lrC470uQ1PQEyO/RGv1Cwxf0o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 24C984465D;
	Wed, 10 Sep 2025 01:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8BFC4CEF4;
	Wed, 10 Sep 2025 01:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757469226;
	bh=56bS2ap0hJvXbN/99ydP9OC4SqQB/mSQtppLSgmKJc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOvBDMUm1PlZZvHn9uAcpe7U1Tw9LEy7uQ1LlFu9/EY4tP0VzCRKGrrFziva0rjbx
	 aERK/g/ejJTr7TA7ik3vO0jtvs8i2hlBqAdFr3aG2vkcvkKZabQGZNRU8Fw4vlf+sK
	 QtUKjzoHWo1TD4+sLtCwqwpRXRr6hFX98H0mCIYoAsHahVdHHwvK7uAmnWtRqknWWD
	 mz/vPJKtJlG/c4WTZoo8hjlKl1pTeXwRp4rArGRyjlovDusQ6SWUya5aAgEdJH/CnV
	 g5juBCfQTdpwhNUuFkhNSKtrzk9NXmHpcbpDN1phJ4/Jwww/Gi7+kxIFn+txxuSEzi
	 pWRIrVq8F5s/g==
From: Trond Myklebust <trondmy@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Anna Schumaker <anna@kernel.org>
Subject: [PATCH v5 0/3] Initial NFS client support for RWF_DONTCACHE
Date: Tue,  9 Sep 2025 21:53:41 -0400
Message-ID: <cover.1757177140.git.trond.myklebust@hammerspace.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1755612705.git.trond.myklebust@hammerspace.com>
References: <cover.1755612705.git.trond.myklebust@hammerspace.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9446380006
X-Stat-Signature: zr487fdftt3i3sh74hmseksrptjhneww
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757469227-645138
X-HE-Meta: U2FsdGVkX18tgkTOJ+J07oEGnFDTsQ21y/WJEKZU7+1xlv3TZmcnU2NwbJlIj6jr8w+AvsbIK1u0pS7Xz7BXXFBbKRhwT7OK59f9CesFx4K4XOStvkEyN5ThR2b9vKWMdWN8LCzTK4g/9J7vP0Gt31k8CvpxbfCra6HivFcFta2Rrwho35w6/o9Bknf5ThvAf+qgvVgSmHy11tq5QT88+e29vw5B08m8UlCD6XKzJDTEH1xL4vrUMlMtw1+CiFP2WlTiuC8u9BfJFx3JkOEbxkqwxd2nWrVbq7sqPnD6tP0qq/0bxwjc1hqwj55UdbBW+aixH8WvQ+LG3ek2zeIsINiL/LC6wWj5jvsVHTs9Q3doudHj/4iyvpOmxsP+rxc+xhohJD8tf44SH5NbGkRtxG+Y5wOBjzmoxvyJlyhpAErduIM2Uy8Iocc6Q1KcLtNUfxhGh1G91/5pS+aEF2jQFMP51m9xpYBzygUqGz5VyBBvOJV7TgjJewCy2e7dhI0OVKzgMbrBTyrWYftGAEoSTZ4LHTdr8Uh97l3Y/N50xzbbS/CacQ1dqWd3A2hYYYPAvjZzh2VtH/HzHPFS0cF+jJi8D2IF8cTwLdY/4mFu3GmdiH7KR+P/dWwE+BGvwsn4ZXKTm6zlh1zo0ep46BvG9jzOkxjLZi6xvC2l0qFlv4MWAgbWbjAVE7QwGYdVuNGv2zx2lV3KTM/XtXoldpqc9SvmRMVySTj0RfFOdOiZ61OF8advpUlz/oTTq/qkuOS3GQGfoyGcNDqDZoN1sjj6QMc0ZqD6JbKIL23n9XoHYkGTHyKvdJ6qctf2E8YSVEkcU0q53VXE7UeCcgModJQM0jn9lvWBgeseKYil2YVLYJIKG1S71x5qlgvLK+UjF2R1rysTk2zO0gQkMWUY5j5WAG/oUonpD7+PbhcZM1UycSaPS1i5wKgBjCTX4TZmOUyo77jKouxtnuyqzbg6Zea
 qUdpCIbe
 E1ZLdYXMN8JxCifQeuAElyhLGbM7rzxza2TZcN/0m0Z+KQBgXHcuAinOwWAXAWg2cJJWWUwdNk0eZq7FBJHVEKMkAoHj3FckfW5D3jMPdjdWjPyvdImPLpZrF93hXfjfxBDdIOI9G9x4YV609ZedvmAf07utEAYC63WXnMmxKzr0JTJvp8/GR+0rd3B/MVs2zROGFXu3pc+Pnd12fRZxs6oLrIK66+UgsH0Yj6Y6DWU8SIJt2Snsr5q6KB1HktUkectTcovvv05S7yv4yo6ZJacUAw6BDYRGzETZNM6VzKjSd1cSfQzOGzt44Eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Trond Myklebust <trond.myklebust@hammerspace.com>

The main issue is allowing support on 2 stage writes (i.e. unstable
WRITE followed by a COMMIT) since those don't follow the current
assumption that the 'dropbehind' flag can be fulfilled as soon as the
writeback lock is dropped.

v2:
 - Make use of the new iocb parameter for nfs_write_begin()
v3:
 - Set/clear PG_DROPBEHIND on the head of the nfs_page group
 - Simplify helper folio_end_dropbehind
v4:
 - Replace filemap_end_dropbehind_write() with folio_end_dropbehind()
 - Add a helper to replace folio_end_writeback with an equivalent that
   does not attempt to interpret the dropbehind flag
 - Keep the folio dropbehind flag set until the NFS client is ready to
   call folio_end_dropbehind.
 - Don't try to do a read-modify-write in nfs_write_begin() if the folio
   has the dropbehind flag set.
v5:
 - Change helper function export types to EXPORT_SYMBOL_GPL

Trond Myklebust (3):
  filemap: Add a helper for filesystems implementing dropbehind
  filemap: Add a version of folio_end_writeback that ignores dropbehind
  NFS: Enable use of the RWF_DONTCACHE flag on the NFS client

 fs/nfs/file.c           |  9 +++++----
 fs/nfs/nfs4file.c       |  1 +
 fs/nfs/write.c          |  4 +++-
 include/linux/pagemap.h |  2 ++
 mm/filemap.c            | 34 ++++++++++++++++++++++++++--------
 5 files changed, 37 insertions(+), 13 deletions(-)

-- 
2.51.0


