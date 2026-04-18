Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF3FF99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85B4B6B029C; Sat, 18 Apr 2026 07:01:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 832BB6B029E; Sat, 18 Apr 2026 07:01:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748E76B029F; Sat, 18 Apr 2026 07:01:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5EF366B029C
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:01:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09F061404E7
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:01:06 +0000 (UTC)
X-FDA: 84671384532.21.01C0D43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4C48018000A
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:01:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qRLqD8XX;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776510064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZi2Q9BcgA7e/faxHdfnP2DV55zHJcA3i6Vt2yQh9Xg=;
	b=4k4Pm8mjPMxSXXdl6LhCoRCchbNzhOgVfctCl+ixw+MKcuvbbj/MrL+Sq8/KTQLuSjfE/r
	FatwUEX8ARMb0yLZ7E/ir2zVNXeWO0Wiubq7BcQhF7YPZLcrwRzcYeqNnZm1dpaAxisLTK
	tKAvPw3L/NIV2DknJ8t7FQwkrMa6Q/A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776510064; a=rsa-sha256;
	cv=none;
	b=Zx9CxIRCbnHBKiT9YKUDToGMOdo2ze1VF8e0+N96+8UgRR0ZFmexJKuGhcmcm6UGZp0DCg
	aqdAHtuTk/UQFRaHui4cwcDQkCSGHWKdIjRF6LXFWQt4/BHh+PnghvoDutF1TTLl2TcQgw
	iGVvVkgO0sZlFCBLzSkc++M5TSY/ZsY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qRLqD8XX;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 61D1E41B63;
	Sat, 18 Apr 2026 11:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44825C2BCB7;
	Sat, 18 Apr 2026 11:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776510063;
	bh=M6q1zkEt1sbIFV6K++NJye6dlph/Y82XdwR7nYmElQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRLqD8XXobTlV3shNrjjV/Kn3npKRpbK0cLJy7y4EY11if6PfAefWSKJOf/kMBJZw
	 amNn/GjBjMO8/GgTHIIubqALfsex3oaPvaopNEovjV3/8zapxzolvtgoJpRQ+xyaB/
	 7pvGs9/uBwU5yPljkk2hklPqHQR+3iXvnxj9VKoU/PegVPAHtCaXlV2lebsfLiYyDy
	 22px77q6P666BhngIUCoxnIJyRI0ZJvnQgUBb3okM5tBA2ZY9BrV1PEVUz4XxA55wU
	 z2Mq2Bt9yQN87isK1IGmv80CcstBgeE3Iu55mcGEcgjWfSlFK8ewQYtxKER/raYeIX
	 VxtMa+ZbzrWEg==
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
Subject: [PATCH v2 51/53] selftests/mm: va_high_addr_switch.sh: drop huge pages setup
Date: Sat, 18 Apr 2026 13:55:36 +0300
Message-ID: <20260418105539.1261536-52-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4C48018000A
X-Rspamd-Server: rspam07
X-Stat-Signature: 75y4msgq6xwg9ts5kdcdc11qkqf1cxgo
X-Rspam-User: 
X-HE-Tag: 1776510064-484209
X-HE-Meta: U2FsdGVkX19u6cFu0AVSH2SuMS+IFRY1l9TVoWrWsskzId9idFddpHzipH42B7QZ2jfGONj26XL5nLhV81HzleQHJClAG7CAXijTZNAcDwkIOysUwpdj7kpfvS7qTBBEwZPR5xgQkE4DrqrIxna+MngVQDjT7pYJ7tbb1uStIAESwoRCZMSp8/zOw0TOGoiIRspYPa4EbvSvnX+vDRBrfzErxun0zELErRsTU5M+X4q4jyaTJZtsczZnFH16hqI7GspV8XXhJVPqSGLI4cQx2ZNVnGcnC2w6eFpb0EdAHRd5mKxfo33KzfkoqRFN6hrtrRfEEWKx0QdgFFiBDac65ZmlgDBdUOj/N8Hfb1/HSxjrQWgAGUqd6aFSooN82cTkx85S3gU8l/GTn6UBWWuIAo1/yS2FVKKUkeLS1i6Vuu+QBT/opEHFbFGCdfK6dchaaQXGUCI8vTCpzEEHuOiWBmVoa5yK+TJJoUS2zpZCSJjIYBBlt7XWoMjzorJtuEbk71z3G5/kX4c0tooXU0r79scXGwHhroOdxaUWF3Mjou+UUhoUA1ROcS0X3u7fe5b3AYRMhFX1GXEv0Pn7hZB1G5nXUt/KVEeF0N7BxMR5FyhMi8eqYT2AFQbrYq4u9v0VjHtnGLusaAAjI2PxqGdXIuUhJtj12pkGU0CvPP04klCi57M/oZeel81ExA3ZPqw4ZeUIumsyVhrpN/HXUhCkFMZCcxSn1XMMvfGskfOtqiSowNPgmWirud95QqWCbxc+F+3IQXQ3XxelFaHqIREoOB0vlPS+vBWq0kv0IR4IPWJ7qyxF0AEdPF5sCSMbhuZGu5s2ZTW6NXR0nQ17U7kgQi4RZFDn3WTJN8cwtDCaTuUwaeXwGwsaGY0LOPu3do2uJTrqPGvnOWMOTtRDykRyyLr+GVFw9JFszoAnhd4nDgadT/rjk/n3cFvDJXURvkMNTgSHBzmD4BxAs+ig4tM
 mBkurzwA
 Uk75Ht63e6fL2p+d1DQInfyWNheEF/sZ32CtSjDRuLlGSI9T17KV5JO4Ukc3ogrglcmYSjyAydjCGJ3pkolsMnWf8x6P4eHbUXedKuv1UGykaS/uE31EbDkVMBioDPfCBIvK7KUm6WgYuut5syzzo4+C4h9O8lCKtgtJ22kYNz034J/pS2Z/TQb4ljjUfXyPfPiXherYKlQ6Y7kyLZm5OdQwF4F+3T6dI6xcdeUzjfp7kmYdev1U0uxntM0cehrhNERL9qjeTfzwhwIY9XJ5tR6RW+rhHbs6j15OkSTIBmA6sJlWwA/tyFvTYTsZojXuWNnCI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Since va_high_addr_switch takes care of setting up huge pages, there is
no need to set them up in the va_high_addr_switch.sh wrapper script.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../selftests/mm/va_high_addr_switch.sh       | 39 +------------------
 1 file changed, 1 insertion(+), 38 deletions(-)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
index 9492c2d72634..d66c0fd3cb4d 100755
--- a/tools/testing/selftests/mm/va_high_addr_switch.sh
+++ b/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -9,7 +9,6 @@
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
-orig_nr_hugepages=0
 
 skip()
 {
@@ -77,43 +76,7 @@ check_test_requirements()
 	esac
 }
 
-save_nr_hugepages()
-{
-	orig_nr_hugepages=$(cat /proc/sys/vm/nr_hugepages)
-}
-
-restore_nr_hugepages()
-{
-	echo "$orig_nr_hugepages" > /proc/sys/vm/nr_hugepages
-}
-
-setup_nr_hugepages()
-{
-	local needpgs=$1
-	while read -r name size unit; do
-		if [ "$name" = "HugePages_Free:" ]; then
-			freepgs="$size"
-			break
-		fi
-	done < /proc/meminfo
-	if [ "$freepgs" -ge "$needpgs" ]; then
-		return
-	fi
-	local hpgs=$((orig_nr_hugepages + needpgs))
-	echo $hpgs > /proc/sys/vm/nr_hugepages
-
-	local nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
-	if [ "$nr_hugepgs" != "$hpgs" ]; then
-		restore_nr_hugepages
-		skip "$0: no enough hugepages for testing"
-	fi
-}
-
 check_test_requirements
-save_nr_hugepages
-# The HugeTLB tests require 6 pages
-setup_nr_hugepages 6
-./va_high_addr_switch --run-hugetlb
+./va_high_addr_switch
 retcode=$?
-restore_nr_hugepages
 exit $retcode
-- 
2.53.0


