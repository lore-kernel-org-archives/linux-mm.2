Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B671606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 16:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BE59L+tX
Received: by kanga.kvack.org (Postfix)
	id 6E1F36B05B3; Sun, 25 Oct 2026 12:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BCCF6B05B4; Sun, 25 Oct 2026 12:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF4D6B05B5; Sun, 25 Oct 2026 12:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 295186B05B3
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 12:48:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 943571C3E18
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 16:48:22 +0000 (UTC)
X-FDA: 85361731644.28.B72DB15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 231E7180002
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 16:48:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BE59L+tX;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792946901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Q80p5MCUlafYdcYjwuOtEqPOJb6ACREJHt1LW8otA0U=;
	b=xe+xBb1rNV9fmGeB+BErGiSmmkfo0QDogJqtXZZpbiljRAHaEnK5EUHZk3r3hoJ/xrQgmf
	RaMfcgxnp66dQkKY53+BTF4cwc/ot8rtPbw2Zs/2DV3WvNZpWlRI75KNctl2rsjw+tZW5R
	0SoolduykDvJXUuSP4vKyWoNcDbBhT8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BE59L+tX;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792946901;
	b=DGhFi78I4MkgbRnB3yUe0kY0xEYDDW1u1iU+yLmiNv4Q8dWNTR80vyz8cpxLlYbNsZuwrT
	WdodBdXdpGk49v0dVBoUoy4NvLe030JIF7bwVURBDRGjgjwg9ORIltp2frH04O2zhGjY3P
	aBz0l+mFk3M7zuFbufw/dd33A9xTu30=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BB7E600AA;
	Sun, 25 Oct 2026 16:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F6E1F01825;
	Sun, 25 Oct 2026 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792946899;
	bh=Q80p5MCUlafYdcYjwuOtEqPOJb6ACREJHt1LW8otA0U=;
	h=From:To:Cc:Subject:Date;
	b=BE59L+tXgKsr6xmG/v2ova9IBI5Ez0pYWp5yRRfHpJgTtL9+iX+yTdY7eS/Xfk/w3
	 jLfAWkaugebck40qc3kL1tzD462m8fb9d9PbCdA/lv8PyLcTzF89tARN3sj0FKPrwM
	 nYiwCeVa5orPCVQfJE0AWBT8xENUJk7d0b0LZDlN6868enbv5i7EQvD2PCzSyEEEjf
	 tO23WIIWmat/Dfb7et2QEjrCRjPBBxdOjMDHEzsgnkd7iaRdkq9KWinnBkGXn0X8+c
	 gaD4QRhwd95iFVVHPgRE4ud8rrqPSCMadF1j0/kIQLo3UHmS43f1Hf44zdJZ1hYX0u
	 wZI+FrfvFOGHg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Fernand Sieber <sieberf@amazon.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/3] mm/damon: fix three race bugs in sysfs and core
Date: Sun, 25 Oct 2026 09:48:03 -0700
Message-ID: <20261025164808.152048-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 231E7180002
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: urf4tgidg5occt83a3ni46wh5d737qyi
X-HE-Tag: 1792946900-101508
X-HE-Meta: U2FsdGVkX19Ppa2ufgbCvkVXGJK4S3AgcXQqDCFMkW0YB6bKuIF6wZy/3lyKlUWlW5Xf3ZTJZxNPkjubwz5TtjOXrTmvOKb/FiK0Rr0N28A58us0JUpAXRPjfaHYJ81CgpaZdF6nF7yKXGujxhZErX8oI6ZL9UJRr4Y9SBF4PU2kESOThOPyjVif0/0oZk0S/WlAb8Ar8AIDbhN9hxf9MJIG4OCC2Y4oXBSguWXMJGPQYpKtxH9uMB2Hns+KaJcNgDsqxuMsQTGTFmQ5TS4cqrq8n/agoWE9hNAQvEbMPOjN4Y6xABM9L+6bBxb6FN4KutBhl8QzKq/9K66kOT874GA9trEr1ADHrIzP9AHXIIGy/eQA4hXeyc1xayvatt8iWsTjSPfSCmsO95D/AsBLO8GtaBamDmlwS+GCXSR3Vfxb4qq0zsP6Ulx48nfgny5WUNH7Zd7j1zf+vq6vezXSqfU/9++GS48fvZHn3XH9vYswkyQQ5RckeSf+xjOU7k/7mighslm/LMmtG3ZblC7Apx5qttZXnoH9aKOu7ErScWdAoHoPK63sYKMnWRweIxAfWy+jRJXlbJFtDaYjOC/3Atb1wdBe87Ija/K2Eovm3XxpQ+EqpRmV/uRGSDKyz37cURviSihGuVReg+9gFEW7ukoCmluNRlPRJI+xbTpbx2Fdhhe1cWmSK99TAxfrQNsiqfEvzLUoJ5yzzREHlzWKBDxMi+3wZObTkKsoiPRKk5iD8yXw26D0AiiJJyb+qkLT9Cm5TJF6XOKPc27wODcuAXKBU9uveX/4l63AMGWPz3Es6LPtSdPurQXUbiVAN2QouehUQNvu6K59C21nxIHYhslIFIjd0ovlmyZjO1YOLVGj11raaz9jnsYcGszac9rR2CmuKFIMAvLL9Dc0SSGg8L+hU+k9S2+LfE3gmA5RqI9EvibjGy4fJmg0cyTskN8NX7Mg8md3XP43P6fQY7v
 aE8aj9F+
 Wh2uLT2+hdcWhXCbYJcSAjz0eXOCC+B6msY6TwYdZOZz4igi4+R+upIBtza9c71XnUWgTFIIEMj27n3wqLl6gfkgmVvetSNWIoybyKQTPEWQ1Jt+OtPFI6UzK0YFOekEGsYD0ZPt85je1pJltBetzPECs8ISQpmTI0Owtz5aF/SX+N5r8h70Ww9Z68CHtnI10LiF6c/3W66lIWOLSRkkK2c7x/FIlDuvao5rtdK6ROBzHu7Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There are three race condition bugs in DAMON sysfs interface and the
core layer.  User impacts are not critical but better to fix sooner than
later.

Patch 1 fixes a toctou bug in DAMON sysfs interface that can mess up
DAMOS auto-tuning.  Patches 2 and 3 move static variables that can be
wrongly shared with multiple kdamonds and therefore make DAMON
monitoring results be a little more indeterministic.

Note for Andrew.  These are not urgent but better to take the hotfix
track in my humble opinion.

Changes from RFC
- RFC: https://lore.kernel.org/20261024193351.87130-1-sj@kernel.org
- Rebase to latest mm-new.
- Drop RFC tag.

SJ Park (3):
  mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_metric_store()
  mm/damon/core: move static variable last_nr_regions to damon_ctx
  mm/damon/core: move static variable rotation to damon_ctx

 include/linux/damon.h    | 10 ++++++++++
 mm/damon/core.c          | 10 +++++-----
 mm/damon/sysfs-schemes.c |  3 +++
 3 files changed, 18 insertions(+), 5 deletions(-)


base-commit: 34b81edd2a3300a88493222637ea010223c00ecd
-- 
2.47.3

