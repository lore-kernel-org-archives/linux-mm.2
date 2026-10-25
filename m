Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0313606A321
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 12:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=lUTZwNHb
Received: by kanga.kvack.org (Postfix)
	id 1AF256B05B2; Sun, 25 Oct 2026 08:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F436B05B3; Sun, 25 Oct 2026 08:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075626B05B4; Sun, 25 Oct 2026 08:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C0126B05B2
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 08:42:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54DC8A7B94
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 12:42:02 +0000 (UTC)
X-FDA: 85361110884.17.C41BD51
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf14.hostedemail.com (Postfix) with ESMTP id D3D80100003
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 12:41:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=lUTZwNHb;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf14.hostedemail.com: domain of yaojiale02@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=yaojiale02@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792932120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jzdJu2icUPc9CnDzC7FIAa4FNFGtvGnsVmr7zsS0YHg=;
	b=TEcWkh1ILeNrb3tSRNvPD88FiAzka3IxIIEJqqHdbHmQNBM8hYy2bYDf8h1bOxzNN4w2fB
	SnWaAHJQxEyrBYaaNoH+K/YADiXkIDTQ90sMXI33tjUBpAK8mxMJ6mSJ7W/0j+mpbafCUz
	g+7rfHSCQrKV/S6su2LCPOC1soXQhUs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=lUTZwNHb;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf14.hostedemail.com: domain of yaojiale02@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=yaojiale02@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792932120;
	b=NfTArLUGLq8m1vv6DgChx9tVuhtK3YU7WFl9GUdA8mGh+DAMCpnDS4pUEGcQmVxgSIsBRD
	2+EgVOPMSMBETDqXtlSG9evm3poDvQVeE7fycVQAbGZ+2GuJsrpNAegZ/w/hG1i331nlzy
	pZYAZRAC1FYpsmS4Vov9U7k+tOM8hcg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=jz
	dJu2icUPc9CnDzC7FIAa4FNFGtvGnsVmr7zsS0YHg=; b=lUTZwNHbPI14KMm28l
	kFus1ccG7pVSpymo2FLeHADG3bdl8pom70kUMdFmR9oa5IWB3tZbJYATR6WBE53Y
	BeQREfn7/H8gMBGnFQt36lH+uVtwtu7OKrvTikQXNhr8QXxKYQLe50QQeJ8QAIn/
	/isepYwN7a0Il7LmFprXk0FBM=
Received: from pc.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDnvTzs+N1qxJALCA--.54355S2;
	Sun, 25 Oct 2026 20:41:18 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Eric Biggers <ebiggers@google.com>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/5] fs: drain in-flight DIO before buffered writes
Date: Sun, 25 Oct 2026 20:41:09 +0800
Message-Id: <20261025124115.3178287-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgDnvTzs+N1qxJALCA--.54355S2
X-Coremail-Antispam: 1Uf129KBjvJXoWrZFWktF1DWrWUXrW8tFy8uFg_yoW8Jr48pF
	98Kr4YyrnFyrZ7urn3u3W7Xw1rKr4rZ343ua17W34DKrWDXr4UXw48tF1Uuw1rAw47Xr13
	tw4FvFykWryjy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jerWrUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8A+LxWrd+O8PLgAA3w
X-Rspamd-Queue-Id: D3D80100003
X-Stat-Signature: k5syz5unia7jneyrj7d68jrmatrheahb
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792932119-49968
X-HE-Meta: U2FsdGVkX18OPwHBTgLxwjGcED8q90P5TfvF+PZMASmeyCkE8g14Q7/sWoVu8i35d+1VJv3oMZeEsA4gwUNAoBPyd20tgB42oXogrdsYrgpnk2WExkM/ek9uOGmzqbZQvStVj1ny+T0MV8iQ0imokZE7FWP3MlgN4q4LBiz/Sg+VXgNOWcZN/ZTDfrl1PIjKmnKxol+LSpBMi06wWZc4VcKSiXSP8M4//2BP+8h/6ogQx/o7mFD/7fSeVbZWojqbrDME6lq0lL1AfQbVI3BdE8JkYcWoV9676Dq5bMgyA0KEwjC1fMs5HHpTMFcPM9/oz9q7DiB6Y0GzQDaJo7UAwqbRM83rZzgvhljWhGMsEBk9SVJpEJU9bYQZ06vknrY78Vj50aBXuL3VjcbL7wzlHBso2aGA/rocw4K01zd6Q77HJ/5c1qq5J4w44tBYuVRBTQ1K3Sb0hbinN+N3RODi4i9mCiL6dvSEbYi2DxGnmqbUHxIhG2L+J5v0R1oTPXga3EYSB3QMy1WndZVdmUO9zM0/rNAm77RGwkVGWPiLxX6avby1NPKvD6vi2CLpPxNID99xl6JMkoAs6DT45XOVcrt1TBBgeVRjbweMBMkzJqoOX+7JJgx59xBhwuzzA3F90bAFnD9PmqUwF2GNNvJg/gOaeRlxWMHF+oghzv3VRJYaVIqXiMOWAc693EWBZqIQPV4t8lmqd+UItYVEw9O9NkHl3Jy83YYk+lkY9bSREL+XPJs52m1t1BMsvjAVP5fqsAEs5oe+JDsh6IuyCouVe0L3O09yyqsM5ZTqwxiGMBkB5yyi0+PqOGG3smXvbY+AHu8TDv/f65UtH1KI8KH0UD7gjDxQvbYjZiKj/R4HC6KbV6OsGH4RHjOL48CMvamB0GzQf/Gwi0My7/NBfS29NDstLovcsjR75Xwz5E3nd8hRgCeut2nPwyDrRDYhuKmbvBbBZOZV52fM26LHPBB
 6ad5o7Sp
 N7IvFztkQkhUKkSmZpNFY3Uir6/H3AllYOZ8yljtWXdHRFUN06lB76c9g38sfZ3tBxreGg9oxoDiYqnRLgeOdWCibbGaZjTtxqPi/YtMWNaXJkoP4CWUHDlqKREu2mkCNTZH10wXNu8ZsgBH1/0Y7Lhb0thOEq9iMb8MFk27tKK6UAlE8JPVHMI4rip5clmNypI6gMW0dMt7BpvKOZxeeQ+dZfJbHFFdo1aHj8CY7ZKAOcc4+SN0Rh7REJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An asynchronous direct write can remain in flight after its submitting
thread releases the filesystem's I/O submission lock. If a buffered write
dirties page cache before that direct write completes, post-I/O page-cache
invalidation can find dirty pages, report possible data corruption, and
record -EIO in the mapping error sequence.

Drain in-flight DIO before buffered writes in the generic filemap path,
F2FS, XFS, and zonefs. The filemap change also protects UDF and other
users of __generic_file_write_iter(). Keep IOCB_NOWAIT requests
nonblocking by returning -EAGAIN when a drain would be required.

The patches are separated by common code or filesystem and remain
independently buildable in series order.

Jiale Yao (5):
  filemap: drain in-flight DIO before buffered writes
  f2fs: drain in-flight DIO before buffered writes
  xfs: drain in-flight DIO before buffered writes
  xfs: drain in-flight DIO before zoned buffered writes
  zonefs: drain in-flight DIO before buffered writes

 fs/f2fs/file.c    | 13 +++++++++++--
 fs/xfs/xfs_file.c | 22 ++++++++++++++++++++++
 fs/zonefs/file.c  |  8 ++++++++
 mm/filemap.c      |  9 +++++++++
 4 files changed, 50 insertions(+), 2 deletions(-)

-- 
2.34.1


