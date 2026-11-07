Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CB90606D81C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 20:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IudT9GhW
Received: by kanga.kvack.org (Postfix)
	id 2B9A36B05B3; Sat,  7 Nov 2026 15:10:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26BD96B05B2; Sat,  7 Nov 2026 15:10:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134016B05B5; Sat,  7 Nov 2026 15:10:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0CDB6B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:10:13 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE0241403F3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:11 +0000 (UTC)
X-FDA: 85409414622.04.5DE4CFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5C53D100008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IudT9GhW;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794082210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KcvosEEs4C5uASYPUIJSJcPZ+WqW144BqAVvtj0NdMI=;
	b=L6j1v9eJ0BKyKuyjIBgFvXrFKG1vJOqEVHSb8E2Ahx3xchJllfFavjedxllDkxmaw84acT
	PJpI+9KdbIhNf3GHmJSu34e0aIXql6kZWMdvdYe5Q9oH+Qbb7A6OYUKe4XKSokMosFnGOX
	Y95291Ct0a1wiGfMefCBRXc12z4Efxs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794082210;
	b=x441yuu8eZ5L6eKuEwuNtQqQH6J40BZOL6vPsnXNd4zIsEG+LVYUZvf4z+RTvigR2pUf/4
	+gPY0JU4V4PwfAxt4jtZBXuNfRtsoJKjancd0/hHwM7JN3D7KwtfMpDXA1HWWQ5b8uHIb3
	gaCsvj0fd7kg93bGtWRThXxNAgsk5u0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IudT9GhW;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87213419BC;
	Sat,  7 Nov 2026 20:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153CB1F0089F;
	Sat,  7 Nov 2026 20:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794082209;
	bh=KcvosEEs4C5uASYPUIJSJcPZ+WqW144BqAVvtj0NdMI=;
	h=From:To:Cc:Subject:Date;
	b=IudT9GhWhndqHy3FqR1+Izf6avXc2zjv/IR9kPWwCH9tNrYphn/6NCI/49cR5+/a0
	 6TwTZTzxSXdHzqwsRREk8fg1FtpV47aBkAQA3MDPvdA39fOf6U04VAUh5O8SbpPp7K
	 jX6c+kQAKNKP5+hmDt9AumFD72AtJEDzrLhoZYvWzyGrla/tLU4PhFm30+CpD2Iu5O
	 TYomYie9xTmU9eg2pZb/shCd64b/ifeswFnc0yLaS6hbHsyGFljPgh2SNPPen9THt+
	 Yj/sHltHlorrI8FX7CJOMH+cTZ7abahlxNWAesAKocstZRw8yK93WgdENyKIDeJ56b
	 OjhoxfHrpyTNw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.18.y 0/5] mm/damon: porting fixes that cherry-pick failed on 2026-11-07
Date: Sat,  7 Nov 2026 12:09:56 -0800
Message-ID: <20261107201001.206120-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7otbdaae5ywqst7xm1nosqx759ab64a8
X-Rspamd-Queue-Id: 5C53D100008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794082210-865574
X-HE-Meta: U2FsdGVkX1+fLo5/vQFlnNHD0raTu597vbAIAV+hMwWVbV39/OztBbCOIXyRtFZJOwkO87qPN0qeZiRejf2DqPIbMKC8JjveSruJL/IcI8wAnxngTA9kCBObcNEdbNtfTkxan7anyTgWQj1+wC0CBeXZWJ+97MrISGz1yOV/d0hVI2qXspH7cPIJhCcm7in+1ClM5/WhBeLFAEJsT5qrqfqTHdD0B786Vdlfq4xrgOkLjENNjQHE70/X0H4wkedUUXMVh9sNs5iZuX4K8C7aVciyrBl8dQsdzSeeluKKiY717LF+T4LCaA8FEm0PWiolUBfB+XC6EDDBvmCQ+K4tjAA+Egc28F4L+nQDwpjjYQ+LR7GyRyfItl70dPoa/Gnglku9aBObzGooQ0HACRJoWllu7IBYcC2vzNs6HScNKlmq86NnXMPZOXXdIv9/plK1265ljyLpZXU3nd+8dsubxD2o+5agNLpZDL4hPUotOyWizPnDgqRX3euQOVWvgQdeKkZe7YgV5QfZGUan/aAWJX4h/gJHvms9Eb5ajpl6OGVqWnM1EHWSFOE9qubl56Bw23l7lz1ERVgFK2CxLoQ3vXCV/RaOh8Vceom3FY8SPCRcmxihqgUEPi4RxtveX/fl1yXjzHzmT7tVqG3xMcl9nIKz4IyLP1tyPS7wj+UaYnakjSdHfV+AGLoga0/whAR2/KoZ9Y3pqVUKBV2lc/vyUMeTxn3110o21OIUcFkALrA59Q2XIfRiJ794YgLxmkTBDzIplSCzldwLfquF96exKxTvJLU+o/Ij2lUrz5R+77jfeUyxZKNXUt+bX91xTQQGA0dxKtraqPQVPiLqLC46U5zqRZCS16wa7Jep7ZBMVxqfBtnIDtYuX3tgDBx0qBqBsZ4TUVuUSRT/7S1/lTljutPZORo7fqqDOOj3EW3UUFRlU4DMf6C6++URUWtpjjaSoXT4C+WYFXpsqmfSg3q
 jbTJsDBi
 jqxWdXEiTd4Mx0dxBiWOIGQn9sXmyqBmb+ji2eMmND+3sh3Wig+zrH/Qv/mT/0zCGDVPn4cmrN6bKIWACFCqQvf/P/9Gp4kzUWmidCeZhOhzKfnh0z8DHXuhR7MWoEQa4XlMRb+6sAvjAGzlfPd2GD6+P0gxXNJ6YMVoU+f2fxO79oFyMi75KkyHPlQ6vR37t+xs4dxQ6jmnHug1DXhmOw94pHIJut4NIYoBRiw1n5aAZHmI=
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


base-commit: 270830fb661321a6230f2433667a328e41b2fb7f
-- 
2.47.3

