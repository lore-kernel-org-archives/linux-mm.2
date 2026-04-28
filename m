Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF813FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55FB46B00C2; Tue, 28 Apr 2026 16:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 536DA6B00C4; Tue, 28 Apr 2026 16:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44CC16B00C5; Tue, 28 Apr 2026 16:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33D4E6B00C2
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:45:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9AC512022F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:45:31 +0000 (UTC)
X-FDA: 84709145262.04.247A200
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 44CB1120002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:45:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fh9A3V+y;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShoW+mtvOdyl1QExhIaW0N6EwTQUExNdZfr6eOd51I8=;
	b=ff2TtQapf93tmNHdWy4G4WR5/N4DiwdHm+nMECwO8Ehj3eqgGkl0KxsAGVQNjYwjViJtb+
	xeQmMCTMlaKO8GsF8Z4hy8i72CkGS3mo8NyDFubw/PJ8JDTFhvNssCSy1/KEtOs8sQjVgM
	d5N0qFayDgbEINIgtpiIPm/yK12uNAg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fh9A3V+y;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409130; a=rsa-sha256;
	cv=none;
	b=X3l9ycWUrlQxBrm+gQRXf9xrSuXWszl1d1o+w55QVBe4i9yVp36qK6jE3g626p/vgX8Wbi
	f6G0HqATu7ar4IlrN3je4aPLjF3ZkrU2FzJIr5psA7xdFW/zpW12gsEP24Le2bYHwGTtey
	W/wgEybUhv+cIbfUCsNbU1nOXmOF3rE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BE6B36132E;
	Tue, 28 Apr 2026 20:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66919C2BCAF;
	Tue, 28 Apr 2026 20:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409129;
	bh=/Wvi9uebpP/hGBuUfLX+2dm76zvxNiYlkCrT9K3LAcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fh9A3V+ypXR4GS5oRIKpQ2uyi2xl8u++OvGhWngaOa12qIEfDGSBqgWfoZi1hBof1
	 Yuuj0h94pGo39vk61AUVl1FOf789apcQAHiXFIYLZV3ZDw8iWNyOKDSUpKmB/MQD5Y
	 GTI9BjMV/vQaNnGP2xoz5xYmzvDVje+KZba7CwbxO/1xu16tkCK8Pc3RkU/y9HAYkO
	 Y1SfAhDpaM85FAdkwu/aYPSdaTvgz3HoZttOwzYZKV2uAbKSk0YfedSiCyZ46Xq89i
	 239DVDEXi6HKISnYp9CNKV4iNV4QHorwTTNf3P54RhKwyYbMgN4i/ajmgkISj6s3N6
	 1m54VeTDYLneg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 24/54] selftests/mm: hugepage_settings: use unsigned long in detect_hugetlb_page_size
Date: Tue, 28 Apr 2026 23:42:10 +0300
Message-ID: <20260428204240.1924129-25-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c4tzkwodk7fkqgyfj6fbqzhbwshrahw9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 44CB1120002
X-Rspam-User: 
X-HE-Tag: 1777409130-936938
X-HE-Meta: U2FsdGVkX1/zKOnU/AVjlXZ6Kq3k0xcvupgVCIBhfAIAfbvOf87Vq7NhU7j/0v5Hkg1XWoygi1oTV1fcEFSJHPiEQGsHiYQOjWatJV+4a5dbNkMSsnqddGJj81JlMrapu/8ZkzOjGbQSkQkXbgGoo2KMcmJIwGcKK/DQN699wE5OKF6hKfgzD+CaFFM1kCXEoovOZjVNbqzIVSaWs1bZVukn49CxGRj4gz7bzU5lbA6JTbc/5dZ6y2/iZNhKlf6SE4bZyH8C1OzDXGmnTEVrT7JLEnINjOoC6tImm5ByjR2H5o6jAhJ7ILz8b7fdolyUk6uImYg1Y+3a1qOnd3vHhK+YzSQ7DdNIu+uc5VIQ4GAHCeJFJbVgPlQLbJEH31vo1wps/ALfjdbG9TxikbNEU7uxH0DKBFqdt5avf0pwBgnH+9+HkBWude043wLW4vXHs4YMgaHnueJkVnsab02YqCYIcOkEl2WAj280B0F3PzhPcfqM9FITvn7PvLs6BSO4NrcPPsF1F8LIv+OiDzIz1BHbdEMKik3i59ZScvzbvQ31aIUdUXe7vBcsoT3UYJNNyoxhnOa3YGgZAcLbty/9B+vVqd6avmEs0kTbxR6IBX4HOa7oc6E/FWvtxPELVlRBTJKCuvhEnjvRKeLmd/zrIIicEIzCddIRPibLxxmMiNgdcIQXAEvKBsEKKh/SCC8Xn/Fm5IrPwhrHno41IIu3KpVt7Wzlip3FzfbkfYdDIw3ngHAihOWeK9iFnTBKyXiqnFIhMyLDjRz6+5uyfah0o6rW9UyVnCVr922cvPpznaJO+Z4sRt/Y73pNZHYtpbjgI0yfZzblLDR0B+tz1f5RsEMXfBJ7fdoJjahxh7y7omE0eelnorHAiAr7oEa3XYEp+R9bHtQNL+kHDqU5nQXeVLJtxHXea1WgvlMfORtjiMLOM+j9Yrd0na5G/AAJ/Bx5XZttJK1ukmvQbEq5QzM
 U9IwoMvp
 FpzaXI+Ej+8M6QRDxpCGZwanyH7OoRdFMMftPHikWnr+Y8kc5HVvYFrIaiGynjZHFNhYBxHqszbHfBfOJGK+X7LdaFpS7GwFV2aLK2HXfWrfuNf2Gln6Quv3q/2vdeRZJFFIcczMmKh4DE+dgdxISxdMHFanUPvBkgmAqd5fQOq7MZeSNpFtiqKDviBia49DQKohZISKzg22LvoXVkaj388G/4bXbejzgy678xPCswUzC66nZN6RJTrko2C7fwP8MpDEz8tWB0b1kJN1tyn+hMT3Biw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

... instead of size_t to avoid type mismatch in 32 and 64 bit builds.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugepage_settings.c | 2 +-
 tools/testing/selftests/mm/hugepage_settings.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index ebaa621c45c6..8f563315b1fc 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -399,7 +399,7 @@ bool thp_is_enabled(void)
 	return mode == 1 || mode == 3;
 }
 
-int detect_hugetlb_page_sizes(size_t sizes[], int max)
+int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
 {
 	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
 	int count = 0;
diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
index 320b97e768e8..9357d07e6c1b 100644
--- a/tools/testing/selftests/mm/hugepage_settings.h
+++ b/tools/testing/selftests/mm/hugepage_settings.h
@@ -90,7 +90,7 @@ bool thp_is_enabled(void);
 
 /* HugeTLB */
 
-int detect_hugetlb_page_sizes(size_t sizes[], int max);
+int detect_hugetlb_page_sizes(unsigned long sizes[], int max);
 unsigned long default_huge_page_size(void);
 unsigned long get_free_hugepages(void);
 
-- 
2.53.0


