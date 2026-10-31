Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B01EC60A2627
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 20:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FosXs5Zy
Received: by kanga.kvack.org (Postfix)
	id C30476B05B1; Sat, 31 Oct 2026 16:26:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92896B05B2; Sat, 31 Oct 2026 16:26:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA7FC6B05B3; Sat, 31 Oct 2026 16:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 832A96B05B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:26:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0537C1407BA
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:24 +0000 (UTC)
X-FDA: 85384053930.17.36D6AA8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 79C48C0002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FosXs5Zy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793478383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=b0huW68ClW7zGxTajFYrPJIOdcCJij4zkacprcElp1s=;
	b=REnKx1c7WrICBeWvubXT/ZUXXZ4FRQXIuS5LD/FruRz1wF1+mxbjL71JH0+I77eOgScHlx
	CrmRLqw197cYhQ33dTYqANt9YvckvkYA9jt6y0HZQNjmpgx1WP8pYGolh6yrjl2mvJWKha
	uGXV5KCdjNmVAf6j/c0OHc83kVJ+Jl0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FosXs5Zy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793478383;
	b=tAKOzUVmgfaC8z5rGYdUrvPy4YodaxmS6vTo6PoVl+QKdhsS8RjkGnTwevrYXlIjQNh7W7
	VuiBKX11q5SNBBup8cmkcOy3D5WY/PQl2DdQ7qOk3tMpEAgjd6rCTa+3WRgJzIIgE4ntQU
	yJRJ5ibMGgZiAdsSST0JI59Yd+2LurM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A18743273;
	Sat, 31 Oct 2026 20:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163741F000C1;
	Sat, 31 Oct 2026 20:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793478382;
	bh=b0huW68ClW7zGxTajFYrPJIOdcCJij4zkacprcElp1s=;
	h=From:To:Cc:Subject:Date;
	b=FosXs5ZyY5xbW4Vt8TM/mcfwydXXh/ABN663PHVu6Pa+NXbNYlyaRNfyMpyehFD/A
	 h2tvLbUW0QyBnsb2kzHl+zNC5pELZUzqRLfYpmAdJBVNFfwu8Kppiv0b9XQfalqLbi
	 YHy83IUL8RXhX/ydUmE/IrnCDdJHPj1jiGrnrtYApjI44WR1pmekbS86EPBE6MM2H6
	 Bx/XtLng/sPM34p5dtsGwgn3KCzSgx50WoCK9Ocv5GJVzU6Dh4X3WCPNn97KXPR5v8
	 5HOG0AKD4CgNS7hLNuY68i6rILQnmi5fJCCxWPSivXzMITY8F2DwkpQ9dZ9/H5u10x
	 vxc6rQGSORdrg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/6] mm/damon: misc cleanup/improvements for core, vaddr, sysfs and tests
Date: Sat, 31 Oct 2026 13:26:07 -0700
Message-ID: <20261031202614.96036-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 79C48C0002
X-Stat-Signature: c5jtjmfh3bo7djyogwj9tp9q6qrzef1g
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793478383-911310
X-HE-Meta: U2FsdGVkX1+Kvm+v79yU/XvUbLKvU+ZorH/g6k1l3om+Ndfv9sN6W86E6n+ObFqYrJC1+benF4Y8PkLY0we3dXqF0VdSXF2kA6Kb4Qt9236Dup0A+Gf/56YmvjTmp/Pxm5XPABExeezHSHEPWnZ5bPfNsDefwbh9bL1heftUMTMv5X4uqxDxCMyRoB5iSiYXgISlhlNkF6FHpa+d34k9tsZbjNYKX3mLXPF+fvwaf5xJl9Iu/XFjMCth0NM0xZP8Tj02SmDImOROZue71/TxlMKZ2v8pKqk8FBDbdOXjnZ22eLH4FcbTVc3ZGw96ylLVT/4+c8k/RG7mcJrIGqtfTJ+ZjoL2YEBvfhEfnYm4N9bOPEYsWS/KOxGA6fr3lXUXWkAZ5OXcrfPAWzgZ09LTgKwgvM9NhBkugxGGPBpCq2MJr63jXumnL8MEPT0kCdCIwezo7YBtZQC2Xy69jf7MF2yPPUmC1qOURD97egnfzbGq9iPX4tcHUepDSqpxgJTx4EWKJQIdQEQtkKeZxZbOcH6K2tVg1j0Aj7DdrO5ArYGBmll7vE4xgJ8NOQjVYXhwMWpUyKAIzf2LIP9hrr8KbLerjuNqGDcAXYaaHQNrpJDJSmyXqgIcULuHaLFI3E/WVlD4ymriBx/rbcgKkMamIfn4woDuipxF4ta/Ov5rshk2cIKg9lyw/a/3hJb01XyuNGyA3kKOos5C0TK4S5BUIObLefUbBlBVN7yzwKSvajfKzbHmyWSKZ/ZS96VNg+67thnmvXJp0Rust+QF9Tb7m2RY3ycyHnWSf3VexqPWWArnQ95JlokyE1sAMejpKzwaAopfjMiBDF1ZDJmVLm7k/7h6FT35/3unBbVxn0N0Q29bpxL20Ps6XPa/GTkUDpO3lrsGAipVdbikdH3CBK+2VuqkliFz0/9bNKXiB4SO/VtAj/+sEmBTc3UFu3gmkg/53L7rYcdGnl7/lE1a17m
 zAqbnk3h
 LbXkRL6gZPxlFrLfTQjqXyTO6UAAMxQjA1l+tUSK0zvIVoxvZcosN6CC2lkG5/LjscxGjDoRhluF5QM3vHLQbLl8OkBHdPAYMeB4zMnK5tEA+Bj5WJOAZcPV1o8JXfsXKvRiILK0dvxX3Cse5GkuDX76M0sm2v5QjvRVwK1xVaJ7tO9PelyNkKOgIDTeFVNph0e7HRtIBW2K6Jjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Refactor code, optimize code speed, and add a missing feature support on
various areas of DAMON.

Consolidate invalid DAMOS quota charge pointers fixes into single place
in core with patch 1.  Optimize the efficiency of vaddr damos_migrate
action under filter failures with patch 2.  Implement sz_filter_passed
feature for damos_migrate action in vaddr, with patch 3.  Drop a
redundant and racy quota goal target value validation in sysfs, in favor
of that in the core layer, with patch 4.  Drop unused variables and
imports from selftests with patch 5 and 6.

SJ Park (6):
  mm/damon/core: handle invalid target in
    damos_fix_stale_charge_pointers()
  mm/damon/vaddr: advance migration attempt in folio level for filter
    out
  mm/damon/vaddr: implement sz_filter_passed for migrate_{hot,cold}
    action
  mm/damon/sysfs-schemes: drop redundant and racy zero target_value
    check
  selftests/damon/damos_apply_interval: remove unused variables
  selftests/damon: remove unused imports of os and sys modules

 mm/damon/core.c                                   | 15 ++++++---------
 mm/damon/sysfs-schemes.c                          |  3 ---
 mm/damon/vaddr.c                                  |  8 ++++++--
 .../selftests/damon/damos_apply_interval.py       |  2 --
 .../selftests/damon/sysfs_no_op_commit_break.py   |  1 -
 .../sysfs_update_schemes_tried_regions_hang.py    |  1 -
 6 files changed, 12 insertions(+), 18 deletions(-)


base-commit: de796f0221d9cfc6a468e83934b9514c43b0a4b3
-- 
2.47.3

