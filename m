Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A506606BA67
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 20:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zk3AouPO
Received: by kanga.kvack.org (Postfix)
	id 61FBC6B05B4; Sun,  8 Nov 2026 15:28:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1726B05B5; Sun,  8 Nov 2026 15:28:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BFDB6B05B6; Sun,  8 Nov 2026 15:28:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C72A6B05B4
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:28:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B25F71A02DE
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:28:09 +0000 (UTC)
X-FDA: 85413088698.13.B50B454
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2E6F5C0005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:28:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zk3AouPO;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794169688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VCC0GT+39trwZ5tv5TKEwxsqF3LcbndkKMsSu0V1BgA=;
	b=6zvzgQTQSs7sEceonP8HZ92DVDgzMwwsYAPmPo5RDa4Cw8jVkjU7+XaFHhh4R4t9RpG2S2
	ZM1oFp58UrdF/9x5SxU0dXeeatH/M/Y3n6J7GE0X985HKVQjqHIWcof7bE516UeGU4ZfSg
	jDHbUXjiuBvL64q965fb5hMFPnHW/LA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794169688;
	b=UoDarBEiWL+EqhmQRJ94KjRfwY7aNfTJy5YqzBdBFlUUQB4zU7zBjzsc2QBwwqMermi6Wt
	jcpN0njux9z1GMRo6Mp7ZcY7C8P+ZxGunuC0gGGqmH11tutaPzDZpI21F78zeU95VpUea2
	VJ1Kbo1/T1Xo+FO9V3JPDd+l3OUqQPo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zk3AouPO;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5861F44F5F;
	Sun,  8 Nov 2026 20:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0585C1F008AB;
	Sun,  8 Nov 2026 20:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794169687;
	bh=VCC0GT+39trwZ5tv5TKEwxsqF3LcbndkKMsSu0V1BgA=;
	h=From:To:Cc:Subject:Date;
	b=Zk3AouPO3OtZiNvvfPDC/JlpdAOcXBg/pmT5FDEXGMpHJBV9gAxuyjIyGrGF/C7AR
	 RoBuKhKT9MRAPQ1TbDa9t5zzxxklEEyAxQIg5S/QPW7yWBpS7NvWCfL2vP09Dt+rDM
	 ZOmwKRMZ7powC+6B/sMggVxushF+62vi8Cfs2unmI5G/1Jp9PfGZdZ+1O2wYkNTxHH
	 cQwYgCaHDdXcNTUdoKkr+J67TyW0QhFY9Bn0eTfpq2uHGnXFxxwtwaTZsi9MBByGbw
	 IhCDHSWc9N0gOiIIzVGhEnuae2XPLnTpzONtxNM0n7CWKyEX6C82HPT4yq6W5f8B2Q
	 qRl9Iy9EBrp1A==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.1.y 0/2] mm/damon: porting fixes that cherry-pick failed on 2026-11-07
Date: Sun,  8 Nov 2026 12:27:56 -0800
Message-ID: <20261108202759.117377-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ewzycj9kcftnt3xg8dtduhwhe4zesdmz
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2E6F5C0005
X-Rspam-User: 
X-HE-Tag: 1794169688-365640
X-HE-Meta: U2FsdGVkX196opf4Niz8jl26Ze8tfw8Zn7RN0vqYT43KKDFMWdWdyomHtFZ0amRqS7+4WVjgQFf7FPE2AjCkuauvr4eXiK2yXUnX1KkOA+dy3JvqAsN/jTkaVn8efmVuhDKRXUk0l5z+nS6Ir1Jt+kK1TcwvhW8x6cGJV3j8tUdYj9ry5hirpSEfjivQCpNgkdJxGxCWfw3wQEmE81hUB1xO2+I9jY2F4x97+Rid5OspnGzwfWBcjmRa94ryNYeqCXjNnHr8lvShgI0Py8+EKmRpqoD6iQOUpkK0tbeCUhFPLIKUXz6ZIF/QF7eQqbTyX1VFQb6K52dvK86LYXzIftKy3UUO8GJcUm8FjbMbp8UpJYrlamgyEf3JYyTPkPds9OwbHDCQD+vZWHGILJogBXkUjunAXyBX7CIsiLnqLKMPUl/cfohWC+y8bW6DTgp2MaEBlFnwKth21JJodxtHeYV2aqPzDQWgIAPhnJZ1YGt8IjoC9jTQN2g1NcbH9ZHi9X3ZRVP5bTEghEu+WHH8MFyAFv7XC12KjaXOo+n0ULXiUBr+l8XCrj9kpg8FpDu5HrNRjEAEqMrrFpyFvU6j8PUtBu6CHJcIDopAnMA6kE1OmOZyRPMJDmk73SIwywMamXPdKxe8GooMNhVmGEh7xYluzqg/IyfkMZp1T3IpXnv4KxsZlqGCWGRCEBs8rig/fbXM12EdYpD8S2npJZTQECLPtowvi1pAA4vbeYnQjXlSp64m/dmG8vsk9KHAAjwzP64bYZmouN2ZgbQau7ONwYpXD0YmFCo0CGHKp5stslIAf/jklWByelJlDohe554vcdE009PEFHeLmI0BA5Ucc7S5LtwiciCGFTvFNxQY1Lddbi5BYqZxEN3Chbb3mL3ZI2228upAFjQlBqeQnlgqSAUaLLQp/L4+ivEDHxSJNo6ZWUdNX4SzItFzmaJjBJM8PfQUy+KlyHgrRzUnXQc
 jZR118yu
 vw6Tjv8833BtjLjl/CFjd2fbrnWKQJV3f+Lnf3eFmEdi2Z5nBBHovIQqk80aNjC0Hrcg0pjmbwrdjLOgWTe8dEd7k960zkjQWXs4dknNPly0MipqxrZkn6Zrb3oLxZVdINl5JWPPRKbRmnhCISZf23z8lfOYOROtJeGioDC85pKppTOtEtA1z+Lhvp3LL8mT3zZqYE/4tKObKaKyiNHSoTo35Rfji8JA+P/3rHe8nI0fMfkA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Manually port two DAMON fixes that cherry-pick failed [1,2] and turned
out to really need to be picked.  Note that seven patches [3-9] that
also failed in the same day were having wrong Cc:stable@ tags, so
ignored.

Patches that this series is porting.

[1] https://lore.kernel.org/20261107054458-failed-6.1-90c2fa6adfed@kernel.org
[2] https://lore.kernel.org/20261107055454-failed-6.1-5695abc4e742@kernel.org

Patches that also cherry-pick failed but deliverately ignored.

[3] https://lore.kernel.org/20261107054658-failed-6.1-cec08aad3def@kernel.org
[4] https://lore.kernel.org/20261107054701-failed-6.1-1bfb9384ae0e@kernel.org
[5] https://lore.kernel.org/20261107054705-failed-6.1-6f276422aded@kernel.org
[6] https://lore.kernel.org/20261107054708-failed-6.1-a1c7fdaf1657@kernel.org
[7] https://lore.kernel.org/20261107054711-failed-6.1-409d2ab6d982@kernel.org
[8] https://lore.kernel.org/20261107054714-failed-6.1-1d2397b2c414@kernel.org
[9] https://lore.kernel.org/20261107054721-failed-6.1-1c3352282063@kernel.org

Changes from RFC
- RFC: https://lore.kernel.org/20261107224800.340250-1-sj@kernel.org
- None.

SJ Park (2):
  mm/damon/core: skip applying scheme if region split for quota fails
  mm/damon/core: remove unreachable damos charge_{target,addr}_from

 mm/damon/core.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)


base-commit: 718bf49618bbf78a08ab69ed0dfffa8e8f917cfa
-- 
2.47.3

