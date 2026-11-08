Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6BDF606A321
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gq5aVxEQ
Received: by kanga.kvack.org (Postfix)
	id 2EAFD6B05BA; Sun,  8 Nov 2026 14:22:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B006B05BB; Sun,  8 Nov 2026 14:22:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7E86B05BC; Sun,  8 Nov 2026 14:22:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA6F76B05BA
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:22:31 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5DA42A80B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:22:31 +0000 (UTC)
X-FDA: 85412923302.13.2EE0984
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D9EC2C0004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:22:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gq5aVxEQ;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794165750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ft3w4NHx2XhqSXh6hSv9Ma4EbAR6Gk/3pG2daDXPnLs=;
	b=y5S83kpNKEvuUE6UmycNxu7m9I+DKVdpVd6n1oiaW482rf4IhzpF2CnjFTpxx1bA4Eq162
	xGy1TOeEu8sD8XpbnFieTQpwn6Hm88Px6bXdhyFsSBwXheUkESzjBUnFQWMBRckYOCoHo7
	y/Sbgsk1RS8zwWop0knh9M2z48EgMkM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794165750;
	b=eTqT7FCnPBmk0m8XRtKpbD5yYeodnJG+e96coxqIk+nIDavS0fOqdfmpLxclCLIfYJEvTZ
	cIB7ysHEGn2J4ZJzEidUVUgeE89Ogkjvo2Cc8X3B81mwGXQgkBcEcKT3pnsijpCJzCpewn
	BqrEFDrmu1RB5qO0nDnYWqa/mPJvFU4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gq5aVxEQ;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 619D761136;
	Sun,  8 Nov 2026 19:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB2D1F0089F;
	Sun,  8 Nov 2026 19:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794165749;
	bh=Ft3w4NHx2XhqSXh6hSv9Ma4EbAR6Gk/3pG2daDXPnLs=;
	h=From:To:Cc:Subject:Date;
	b=Gq5aVxEQjhFtWKv0iJoeNxpWJQDtUdPV5yyZ/QQuKgYj1VH6s4vQyQix6AkWVDaXK
	 EPmljqF9krYy8xFTo/OTXpWS9yrFIoZkoO4gzstKPL3LZQXkse4C0Q8ETMBdbhIBCz
	 uX9MXecOUHM9o+8vSCzCq5Vd3Coe6RgpZzjIlrIgOj0JDhT2XtODCTkgtrAdIdYBuS
	 daD4aUXMGHylY0KuETM/kXGJ8IZRuOPLMjJrH8RBHUbevI7B1dosksZvdEqqiSukb/
	 R6CbE8l/04BqlzzUCPIzlhob94f07nzHP/sNbmsUqjfkJfPqtqMcA8bjcq5JfFJUWp
	 pA2epMetNwbxw==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.18.y 0/5] mm/damon: porting fixes that cherry-pick failed on 2026-11-07
Date: Sun,  8 Nov 2026 11:22:15 -0800
Message-ID: <20261108192221.114362-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: j7ecykga66d7te7im3u7zgaxsosuz18h
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D9EC2C0004
X-Rspam-User: 
X-HE-Tag: 1794165749-45890
X-HE-Meta: U2FsdGVkX195tTIWlZv1o45BW5lUIeu31S1i4PPmg82z4q0xXKv3mc09QFz6ffIdaD103oxGUtkGfIoGkMPNr9uZKaOJ46Pgwe5CxCoGtynlODD8Sg878b6ZXinzlTGl7zDupliZ6Psq2lK5xQfWQz9uu03jOPDH6sT+OLkJrsUIhFIku2FMFdoO6oS/P29lneRhAzdOwU5k0yqgaJ5rdSA9SNJnPh78vcJ93VyfpNzlIIo3w/HOiYodn2tHjdF4HXuLKwaQEJwybP5+UrbmvmFlY3X3sT0W19kHRoPiBX4aWyCJVuZT0TEyWnDDz0pDPPJ4Vtl4Q+m/x09ER3PEtOYhyAl0KIqjZ96gy77pQ/H1KxrCtnofyBlG5cBG1KD6kU5i5sH3fOP3ZSRo8vWTotLDIFPhgUuUGvPJn6Dk/mXYkpW7PXuu9JoMayilR0c+gMDxgDkri5qu4L+hSxvOxKIPUlMHppTMKKt2ngQvPpKmjVFSYgOm6pv8ftQzX0prJ+W0XhE/Vr4V+ledHxSvMZjrenKFHJXqD1Yat6QPuammbG905swA5p119S9KZ/yyz0DXim7Ozkc6PEpGwYg1iVV3QpzCqdmk9vX5qk0zd/PPvKYx7RaOworyW6yi6501uEKy90UcP7Zy+gPkDDuhAUX1tiyYKUGWR36UT318IrAkS3bZptAuclzA2wFmGR5NsRu4kU+/CYuNtiFbNTn9Op4n3Xjsu2mIPdTcZaNhhvoErYHU2mUf7fksyz0IvPU5DLQk1ucjE9gDnmtI3d4EqtR4G75TFUNnDoMxY7yK52jNXZtfnGLYz7OG1nsOT9ppaYpiYt59mjtN1vKGUqZHZqD2O7HgUqGQxUTL6C3lN1FxLxPzAsbi6W+Kkuw4hN5S+iiljybdRi9/U2fbL34jyWj4W9MUnH4AkkMV4QmV/MtArBXvohQah+yOobhkIrxJOhWAiHLjFlT7eKsRoQc
 NKA8QP8v
 X8OT5wr+1VdZ9RzlWsV7EXAsOcSM2P2buvQ6Esuh7TjXulbppu/QC+/FSrJIge7PCKSWDuo0V56a0z5aNDhCuIEocZ+c/WkzMhPfH8VQ4auYuVSmO/fvFzrzinxALhlxkMHXOe92uAtEPcxySEeJzGZYkUEJA0NnWRuNYXGCTc2F6BJbBc6zxPZocatxLnWSrZXhxuKLi7QR0yMuTd2KgrdrqbaUlJSd2Q34SrzSzPvOOWOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Manually port five DAMON fixes that cherry-pick failed [1-5] and turned
out to really need to be picked.  Note that seven patches [6-12] that
also failed in the same day were having wrong Cc:stable@ tags, so
ignored.

Patches that this series is porting.
[1] https://lore.kernel.org/20261107050847-failed-6.18-90c2fa6adfed@kernel.org
[2] https://lore.kernel.org/20261107050851-failed-6.18-29c6084658af@kernel.org
[3] https://lore.kernel.org/20261107051039-failed-6.18-af19aff38d6f@kernel.org
[4] https://lore.kernel.org/20261107051438-failed-6.18-5695abc4e742@kernel.org
[5] https://lore.kernel.org/20261107051441-failed-6.18-bbeec2d8324d@kernel.org

Patches that also cherry-pick failed but deliverately ignored.
[6] https://lore.kernel.org/20261107050853-failed-6.18-df7d9a0f8d91@kernel.org
[7] https://lore.kernel.org/20261107051022-failed-6.18-6f276422aded@kernel.org
[8] https://lore.kernel.org/20261107051024-failed-6.18-1bfb9384ae0e@kernel.org
[9] https://lore.kernel.org/20261107051027-failed-6.18-1d2397b2c414@kernel.org
[10] https://lore.kernel.org/20261107051029-failed-6.18-cec08aad3def@kernel.org
[11] https://lore.kernel.org/20261107051032-failed-6.18-a1c7fdaf1657@kernel.org
[12] https://lore.kernel.org/20261107051034-failed-6.18-409d2ab6d982@kernel.org

Changes from RFC
- RFC: https://lore.kernel.org/20261107201001.206120-1-sj@kernel.org
- None.

SJ Park (5):
  mm/damon/core: skip applying scheme if region split for quota fails
  mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
  mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
  mm/damon/core: remove unreachable damos charge_{target,addr}_from
  mm/damon/core: filter out damos address filter-split failed region

 mm/damon/core.c             | 63 +++++++++++++++++++++++++++++++------
 mm/damon/sysfs-schemes.c    |  5 ++-
 mm/damon/tests/core-kunit.h | 16 +++++++---
 3 files changed, 66 insertions(+), 18 deletions(-)


base-commit: bd28b146e1b6b6048a00f4d240d0f6b2e1db6b3c
-- 
2.47.3

