Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F0B5C88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 20:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AE346B00C9; Sat, 12 Sep 2026 16:29:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05FB26B00CA; Sat, 12 Sep 2026 16:29:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8F936B00CB; Sat, 12 Sep 2026 16:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C283B6B00C9
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 16:29:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B871014052D
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:29:21 +0000 (UTC)
X-FDA: 85206250122.19.224D70A
Received: from mail-wr2-f11.google.com (mail-wr2-f11.google.com [74.125.225.75])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0C33240006
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:29:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YKcfYXft;
	spf=pass (imf27.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.75 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789244960;
	b=kaXVQvyVaukakps6ouONxDf4VjpUy/pXq57WklCd5lC74e64UOXfcKK/i9i8WRoSuBJXRs
	jnwU+blAtDCAp3sjTrI5yDeKx16LIGEFiDKJFKrLpIwGiNwgPEBmyzs2+LKHyjMKNm8A8/
	hVqU3J/E/va5VERuu5OjJN6/4oKWCQw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YKcfYXft;
	spf=pass (imf27.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.75 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789244960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=csmfesBA8dGwPUVlvGofpRltARmcJI/ixlG1I95VhFk=;
	b=vaHvqhqi1dBq7Xie+JQnIAvW1I9mszKFaqx8tH+pY8/8jnPQTX/NBcbfkVRC//yTYWiryf
	m873e/72MI79J/Mt5eT93m8InJUqy4vU6RAwwg771cyt2T7GyLfp5WAjrKP7IO0YFOZvMx
	QbTmp7/5XhupyNRI7jDCbfq6CQOZnpo=
Received: by mail-wr2-f11.google.com with SMTP id ffacd0b85a97d-486e4e15deaso549348f8f.0
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 13:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789244958; x=1789849758; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=csmfesBA8dGwPUVlvGofpRltARmcJI/ixlG1I95VhFk=;
        b=YKcfYXftQjMfe/FMRMDnJfCWTEvSyX6sm2mEWoyNjiXLt8UzZha1riIsvlVIFbT6T2
         fuDqthi5FzpLy+spKkzEUUfoX8hJ8JpnQiL71KYIcXLn9bsztgOf4qjYsgMlhOSAiwOl
         xU7HHOnaf+/wTa30PBXb7b8N3O+P/PryGaB6opvEDoZ02zXYTm47hEprV2V2jX1x+jTj
         0oBXqDyU4YAxnSd6nwrzmRKw28SBCF5qqYYzR9f/SzywNWd1ppNNYUlvvMBJU6Phsxd6
         Lmf3FDrQ46GyRihp8KtQpqNnYmIbruJ54LQpYqIkCsurWqUwkaHoIjqOS4uc3iWXdBva
         cyvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789244958; x=1789849758;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=csmfesBA8dGwPUVlvGofpRltARmcJI/ixlG1I95VhFk=;
        b=HXBTNRehfuDFVZ3FlIAIqVk4YWUS1Cf0n+tj8HCjnpVphMB49e2T01ethVOPSxYLJT
         wvX2FyLwEx121EWBRQkWdCdin7+nk2Q7FcLKW2EUD6JLpbI5mvICgf67S8A7dVJXY2pO
         YrxwGlQpJOoGmlZxqOIgoLxoyn+hyssUrIlxw4fVT1e45ucgBu/bwXbH8VS5v7I1ZURd
         K/4061xvVWCR3OFelSSdra/wNf5lyYsQq44sw2OX8RQxi6S/BjD2wyBsZQWFtLwsLHzE
         rMTscJtpWMsdiflCnm/T39W3WUlglrIlnC/2CLznvl6wQpqnPmbY3Lw4JZ7NbKd3h9ZX
         7CQA==
X-Forwarded-Encrypted: i=1; AKwUvByeppxRp4oxeGpANnbZqrQud/HPtUyEu6E95tC/7LRAhdVdWB1l89507MIDdoEo9yOlh7amkC5oyA==@kvack.org
X-Gm-Message-State: AFuF++l1dq/h6LAdTlFvxKMC4JDJzT6Tz9qF+ZsPh5Ny4ZnZ0OFNUbq7
	nhFahtMEkaK0FN3lzEaPRHCSubhjaCPFTMRT/gVL8ptoiRW0GYGHpG6Q
X-Gm-Gg: AYBFou2GPrrEooVWip3ys+pEZNplk5fYjcfW18Ep3MKGHdP43ggh/ZnrdMicjuSV5VO
	OtHCaCAnn1R1Gd5DFINjwTF+RsxX4Gv6LyikBBIKMIVrj5QuQO9WrXAR9FUcX5IfmfOR2RG0j3J
	TYtPrMg69rOgojJWFZoLGO9iejTCCIm22j/lP162GTQ5qKbQuvGiJE8xbrAJR5BrQLqQP41jJHA
	PK7tZD+tLbkXMrEpu8UV6VD02Yqc4mzqT1HvPChqBfQSyLL3IPyLt2qYs9yZnvweC+8JC34qbHI
	wijx0RBKIM/KE9u85YMihzPT5U21KfPEeb2w5YQLW50LRauwUGXDtE1yBHvqKhiafabWVyPcbxp
	X7BkP0b5q5o2o9M4kze0bfnf1hiPXPZPbynkSAnvF1cERhzYqggoy5T9azCRVk3j7wSH04PcT1j
	qNhb3k0oqJUD4S0uLPJ14NQ5GI5bOTyc0Rde8kGLM29mp8PJRO47/pxMbjBEgU5sxqYlWNMr26i
	rV2OqVS2dwx5wDAUV7xEwc01MwU8oRHsai4UDJUx5R1Pwe7PwJostjEW49weMoj88Zu5gZK8p+Y
	6LQuLm1ZCBSFm6fHlU8MIY0LWac++fdakCAl4WoEc3Uldz+vh0/pxqv5ADM=
X-Received: by 2002:a05:600c:c493:b0:49d:2607:4ada with SMTP id 5b1f17b1804b1-49e619bf31cmr192931035e9.14.1789244958264;
        Sat, 12 Sep 2026 13:29:18 -0700 (PDT)
Received: from jaeyeonlee.telekom.ip (2a02-8388-4003-3780-a532-8e05-d6c6-f4a0.cable.dynamic.v6.surfer.at. [2a02:8388:4003:3780:a532:8e05:d6c6:f4a0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26c39086sm238050975e9.10.2026.09.12.13.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 13:29:17 -0700 (PDT)
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
To: akpm@linux-foundation.org,
	shuah@kernel.org,
	david@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2] selftests/mm: skip khugepaged file tests if mkfs.xfs is unavailable
Date: Sat, 12 Sep 2026 22:29:03 +0200
Message-ID: <20260912202903.16157-1-jaeyeon.lee.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0C33240006
X-Rspam-User: 
X-Stat-Signature: abg8r7y6sy9rt88tuikujs45nrr4qfxy
X-HE-Tag: 1789244959-716417
X-HE-Meta: U2FsdGVkX19RUjYiDkFutRQ9mP4kCkj4n07FHEL/SPHOxX3/q3jGXFjkmohNQ35zykW1zZLBw0qQH/3C/WdyS44Mq8+J57Vs23DV+kgZUdmi+JOf5C+lovNcJeZ066EPmx7txEBQuAixkAz0JVQEYttRwGm207iJv/QFNWTeJwnER4RCn13D3IRM+vpjl+U6Ey8oxUByTmbiYYW7ZSw8fYAGJ7x+rWu3zRkJajIwCLzX0Qn5iVHrYI/mh/2tjMOp+2CFeVK6awxI87UEicKTZwtZNgDxBA0mf+jGgDVos2ferOUP1JRwU0DP0TPsxr1c5fZa+w174wHjvLFTCQPbhbK2I6qLZ5GOoIm0PuG8CGTQx8FpgmOl2Gsw5PyQg0276VKwIxygNa7gnwNM/PW6P8qjABEjqGvmMUVPYIjDaowenPbTYrNbylqkfgtvTkElIdAvOyXA2KXrS5KhdFMPFt91RnECCG9+dC5EAiPg7Z2HmuTmhH4k1xo+rZjvNK95nTRc3G+E5n/WSCyVmpjStwcPO3QXtjy96HGS0dfMpVHnG0U2cC0KdF0nMTSRSuaXZndAqM6QCfd3tcb0u0Xo8zE/Jr2bnxP+9SLH+U1BdDG4hVxR0rajHRt+WLKgUA3pkUiopUtfvqVoGGE2+w0m8iHhDvQ+nRyPNQGKUVSb8Q/MslIBmjhVb0lJN5yKsy4KrTUpUxTf0lW3Zb+BYxSRC6yNNkpHDvPI+E/Zw7biJzyPS/xXZSkN0VhgCIAl8vVAcpHDI09myp28BChFxteTE++rB/Oeb3USpZlGITthL/GCcbitoswc33PCWzRVIIVn2ZBF7gW8Kg1vQ3TxjRv75db0SCeOGqPv5vFw+lG7TQW6jzfqjO/otHWE8ZQcc8r8sqlSBCgd1Jr9NQgH6e6/ianaMXfjUvxtLM9OeZrs0AkcOaEBu1mpE9uHnl1sWD4SDBkpWm1Os6G1HI/dYGL
 VN9W6fOq
 NAMn+c/BRMFvekhzhokjmxp/wa7IHUgLfHzwSQOa5RO+xHMFqrKDK73Ib3CeTFPiiYYv//3au/F894tDZ2K6FeS4jkgeSwqREHYe1RyPZvf6ep08ssoatlp9bI2VP3KddMSQTT4U+CZSguykkAkXpT4i/yR435o1qCMCHTpjBc0Da/gI7r8FbHSRCDQToSUuSNW1eVo1JN4DrR0mnQ9i7kTUAtINsXBXyzWNs+Ot1IejnGfhJS1yHYcP/OZbgfIKQXCGB7eS7xsy6JIndnFY2d5/PfRvjc+Eii7pzU3nMbsMGk0WT57/v/5LUFsvkOWg3VUI0/M+JX5hnns1ciBvVJnIuslUJPWBYHRMCrpDLyJUf1szadX2TAxTvyZCsbpw5pzorkcMq8g3wIieZyQcfGvEZijtHKei9oquRW4OaEcXN1dde/Q9fUOWEBLhtMyLU4nGZi/jJBEysYzg5f91B1VXoJuL8tshHiUwjpxOTv0ycs36bhV9F34oj+H9zj+N+4wiIjJ15vdrNAMydoLcNDmNc0xL2Vo8Wv4zP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The XFS setup for ./khugepaged all:file checks that the kernel supports
XFS but not that mkfs.xfs is installed. When CONFIG_XFS_FS=y and
xfsprogs is missing, mkfs.xfs and mount both fail, but
SPLIT_HUGE_PAGE_TEST_XFS_PATH is assigned from mktemp -d and stays set.
The test then runs against plain tmpfs and six subtests fail.

The script already has a skip path for this test, but it never runs
because the path variable is always set. Assign
SPLIT_HUGE_PAGE_TEST_XFS_PATH only once mkfs.xfs and mount have both
succeeded, and remove the image and directory otherwise.

Suggested-by: Zi Yan <ziy@nvidia.com>
Assisted-by: LLM
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
---
Changes in v2:
- Attempt mkfs.xfs and mount and fall back if either fails, rather than
  only checking whether mkfs.xfs exists (Zi Yan)
- Fix Assisted-by tag format

v1: https://lore.kernel.org/linux-mm/20260911124517.63714-1-jaeyeon.lee.dev@gmail.com/

 tools/testing/selftests/mm/run_vmtests.sh | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d09f9f6a384e..b870d21c055a 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -417,11 +417,15 @@ if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
     if test_selected "thp"; then
 	if grep xfs /proc/filesystems &>/dev/null; then
 	    XFS_IMG=$(mktemp /tmp/xfs_img_XXXXXX)
-	    SPLIT_HUGE_PAGE_TEST_XFS_PATH=$(mktemp -d /tmp/xfs_dir_XXXXXX)
+	    XFS_DIR=$(mktemp -d /tmp/xfs_dir_XXXXXX)
 	    truncate -s 314572800 ${XFS_IMG}
-	    mkfs.xfs -q ${XFS_IMG}
-	    mount -o loop ${XFS_IMG} ${SPLIT_HUGE_PAGE_TEST_XFS_PATH}
-	    MOUNTED_XFS=1
+	    if mkfs.xfs -q ${XFS_IMG} && mount -t xfs -o loop ${XFS_IMG} ${XFS_DIR}; then
+	        SPLIT_HUGE_PAGE_TEST_XFS_PATH=${XFS_DIR}
+	        MOUNTED_XFS=1
+	    else
+	        rmdir ${XFS_DIR}
+	        rm -f ${XFS_IMG}
+	    fi
 	fi
     fi
 fi
-- 
2.43.0


