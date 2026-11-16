Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41393606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K2+7tRLz
Received: by kanga.kvack.org (Postfix)
	id 4C4756B00EF; Mon, 16 Nov 2026 04:51:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476776B05C6; Mon, 16 Nov 2026 04:51:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38DF96B05C7; Mon, 16 Nov 2026 04:51:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 157256B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:51:05 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9AB6E140899
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:51:04 +0000 (UTC)
X-FDA: 85440513648.04.16B25FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E61FE40005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:51:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K2+7tRLz;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822663;
	b=32Q4QhMe4eSbbw2beWtdwRNDiYnXIKbLb/fwIITC2nsC3YRtlipoeeF8epW+hRM+m4fz3v
	PwbA+9XuFwFkeJntqoiTTI7u8FpX6I9o3YeAQM1W/ybkCjcY+L5iOhWyHWDIg/0ZHkM/pJ
	Yax8IdKUKfT4RuFGwefKLI0JFhX2J/8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K2+7tRLz;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8aRGBcpvx8xM7mxQtHaidBWPdNvahzYjZNEX0jkJ1yE=;
	b=fPa2itdkb1xwEP+f++lATJzcFdyl+ZDcrSGmbFIYLbaZKFTTzwyUWmSl4SGQsq/yZRN+8v
	eylO08UPOaTo5ATRKOLIEvK+BIR+2Fy10ebcDx9I6/iGQr9yuJvZWejNdYhFWuLUTEZhVP
	2KWF0VHjfs8RDIVvN9tdn3HRMFbSspM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A26C4133F;
	Mon, 16 Nov 2026 09:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609D61F000C4;
	Mon, 16 Nov 2026 09:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822662;
	bh=8aRGBcpvx8xM7mxQtHaidBWPdNvahzYjZNEX0jkJ1yE=;
	h=From:Subject:Date:To:Cc;
	b=K2+7tRLzUA1vHpSh9Z4eYxrLSWLfx3VxiAtV+I2wsfPNb9ufsZBXDAGRXgVgW5eVT
	 7EPd2127puPa6m8jR0gUbbLngHeCTt0SNmH9jNftFfvciTpnZOwt9ZFB8xaifyNx5I
	 6T4/eGhfCJ4f1ugyPqE8JW8/pgNBj81vq/a0P4QMlvX9rDmpcnRbSLEfn3OZwjS09o
	 Ffj8QthI/KmMMkRMsxQrY2bpnNRJNH0bSetX/pu6Ptvz0r4Eeu9O8UNelZBCix0Dko
	 77WqR1fbWuPXsEef+M7YM+E7QUpfT9xgzJUFuXdxSrgNBt3AgthI6/SanCUbgR5X4y
	 DYCuvs09giVyg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/3] fs: pre-existing fixes for the SB_RDONLY series
Date: Mon, 16 Nov 2026 10:28:29 +0100
Message-Id: <20261116-work-fs-sb_rdonly-fixes-v1-0-95a25ce917ad@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/z2M2QrCMBBFf6XMsxOaoK36KyKSZWKjksqMK6X/b
 qLg47nLmUCIEwlsmwmYHknSmAvoRQN+sPlImEJhMK3ptNYdPkc+YxQUd+Aw5ssbY3qRYOiXfmP
 6uG7dCsr7yvQtynm3/7Hc3Yn8rerqwlkhdGyzH2pUxSqK+otVHcA8fwDm31WGpAAAAA==
X-Change-ID: 20261116-work-fs-sb_rdonly-fixes-d74c927f80b5
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.com>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1425; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jeCsQzF34oL0Arvs8F9B2uJQSCX+EzbT3qRU+Rbsju8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9uvi7fE9w7bmpcv5J82/1za9S4FUrcTJtdFY06i+ct
 14hJSyuo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCLiSxn+p61423H1yuqphyNy
 CypNQ07uYf2rs/yuFLtD9f/+bZMLtzEyTOL9teBm7yq3mqbpzbY+BsIR898sTkj0CjXjaTy2tLW
 IFQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: gp5go4pe5bzhtbuqxk55bdq3ei9kuhfy
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E61FE40005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794822662-590926
X-HE-Meta: U2FsdGVkX19V0IaKl7k60DXU9YJW5VpwhCvKkgHy3Sb0F2ENUPmU73zJEAFYTpASKefu6vjwo3fWYthErLga0TYJK9TLecvKBOFRQQ7pf/0q2pDe9lN4J66vtc/wypydaj342wMkt/qDY53er/CAmgki9Dboq0Syjh292pUujxS4BVq2nhsYnEeq1dNH211iYQ+phjVmbRExuLestci2G2b+OMiFR8PUNrSlxCq9bBxdZt5KZgDwQCd/1UB9RaCMO0OGqGJ5JXIHn+VaEFz7Wkgy5aBFqR1SdRgP3YHlyv0m/fDIEveGyqp+1AJmJyk3oK81GtHi6Mo3coGLtjPHqFUhS5n9El8/akzTnErMzBV6oA1c6F440up+EUqac0liTxHj17njdcygwJ+u0nGfPXrebv03fRNphiSOToMgZbMMDxTUsC65WqD2oGEXktcntxuc6hGs3uRVJJVFc9G0jbTqbd/5+TzC0ZtxE3SpN1GjjfB3gqXMtGFUvGGS+GJji5SbgHXqzBkIhM1bYoViFCsa8K8GnWTlxkJq/YoNy3SKp7yDUrMsOWdrO65foDW98Sx7k6G1fu8+VAKhw6s0a+KBRbAYBvW/tCtaIfGT5nOZ6v3r37UFatPK+dnvMsK2/3vmEKn+2ZikUmcfSM/jaXliDFTnoaFMESWdPh1hEq4gmEAPecBYN96AKPokfD8l+3vtSQRe9Wfz92Zx3Hpyhe2K1gs8YsiLHDvnkp4OH3Fi6ZeSD/GlfH9UWESWp7CRmeu/ySC3tzxOepA111BEY8rtRcY605oVNSpgBTJ0PgO/C5CH9lv5gLJzpkBlAxIWmo4m7LfC03odHS9Dm2VyyI/v5FuqXUA/2J+n2ZxnSHfxqVGzk25TEmYmc5+nWw8IOVs2JBKHlfSpLq+5siUEozeBm2HE0OVE85vC+v6sBm1m6amcTbNYWHBIDvvOT8DkwN//1jsVbPct9sS4PjR
 11E2FOjH
 f8iUeutPCqk95+1FVamTWRrvHN1H6/43vUFnbXYEQmRW+047xc7cbMiJP/1wG2c5RxMfzu988Fe92WNQaTkZSoRzA4UaCQp+eQptcX3EU+4sLlQuawIwqt6s4GGnrl1M6Y6ukTwca7pSj4Dwg4BsfQDDLggXQW3bgfaJ4EhPH4pKXJrCaKTsH+Q3H/B/C1NQXutM8PMYA/hRepgVUXHPSduQoCn+ZVeX4rhMEq4O7eSo2mxdCtOMCKYB2wKFjIhYkrYqZx8CavkvtqmJaNs7wMdHd9mGiHTM337Q6g9sU4xo+8tRnIjQLmr0hvLR6O15XA64sfwzsAYCsO+k9Jr8lBbbQf6zht6lP2VA/y2j8cLxtbgyI2+R7P/uGALCjJXsf8ZNhVExIooa4rE2Zj7NtID+gJTEegRok+KdJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Three fixes for pre-existing bugs that came up during review of the
SB_RDONLY series (cf. [1]). They don't depend on it and are all tagged
for stable. I'll put them in front of the series in vfs-7.5.super.

- gfs2 hits the BUG_ON() in gfs2_quota_cleanup() on a remount to
  read-only after a withdraw during mount. The withdraw work was never
  queued so SDF_JOURNAL_LIVE stays set.

- exfat marks the volume clean at umount or on a remount to read-only
  after a shutdown with EXFAT_GOING_DOWN_NOSYNC although it may be
  inconsistent.

- jfs takes a negative inode size from disk as is. A symlink with one
  is treated as a fast symlink and jfs_iget() writes out of bounds.

[1]: https://patch.msgid.link/20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (3):
      gfs2: don't BUG when remounting read-only after a withdraw during mount
      exfat: keep the volume marked dirty after a shutdown
      jfs: refuse inodes with a negative size

 fs/exfat/super.c     | 3 ++-
 fs/gfs2/incore.h     | 1 +
 fs/gfs2/ops_fstype.c | 5 +++++
 fs/gfs2/util.c       | 9 ++++++++-
 fs/gfs2/util.h       | 1 +
 fs/jfs/jfs_imap.c    | 4 ++++
 6 files changed, 21 insertions(+), 2 deletions(-)
---
base-commit: c339f4010dea8b0d754f84ace70cd1b089878ef8
change-id: 20261116-work-fs-sb_rdonly-fixes-d74c927f80b5


