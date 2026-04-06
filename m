Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ACD4F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2EA16B00F9; Mon,  6 Apr 2026 10:22:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06776B00FB; Mon,  6 Apr 2026 10:22:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D43AD6B00FC; Mon,  6 Apr 2026 10:22:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C30B36B00F9
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:22:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7BA531A0430
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:44 +0000 (UTC)
X-FDA: 84628347048.11.FE8E506
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 75DD340009
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QAJP+Jhd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZi2Q9BcgA7e/faxHdfnP2DV55zHJcA3i6Vt2yQh9Xg=;
	b=ICL0ef5ClDB0y0gH8dpQUa75SlCDmGFt8UWFxyPDon9NUwNTyy4J2aJAZvM4TdNdBsG4mp
	Rww2DbjrJ1nnTaLSbAL+VXdSkpTr8fMAKiLoHPB0hI+dRstIFndg1QQFEbTy63dOCcjFE7
	XFhmhOIf0v6K23iTRXrYt2NiRZ9MB64=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485362; a=rsa-sha256;
	cv=none;
	b=uZGfRQYTF818OVNEU64yiSk8cayn7qC3tKk/NIjzbsOIyviDOQy3cfQ/ppB4nqMAshjVT3
	jvs19mEh641f8P2/M+Y2gL4i99FWKaojrlLHzMOWY2j6JFtWvexsRmZIinUkvYapvDuqU2
	ZxOn3GTogncY8Rzt0Yy/sC1sGOoIOrs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QAJP+Jhd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7111D435B5;
	Mon,  6 Apr 2026 14:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E00C4CEF7;
	Mon,  6 Apr 2026 14:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485361;
	bh=M6q1zkEt1sbIFV6K++NJye6dlph/Y82XdwR7nYmElQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QAJP+JhdtSkCNKhsErENZZU8T6LZDngJhrwYigw/W0evwsKLji1rs8q4lLoyEO6hT
	 8tp9/XthNoGL/C6m6fcXdrDrU5SOn1iAZ5CI4W3r27OZejYyOw1ohrA+ERF2umOK1Z
	 81q/FcO2T8MUFOQzwabh8CM0E35mpGsSfYJaDjby3rtxcIy2T15+VzSB2NFkKRGC91
	 tuCKCrFHXbuOYfzk3Xviwf4Gx0+elZ8cfLapXD8Havt+ulJdxev68326nNOLZBAOLC
	 EzwPUEHUXxLZrkYCNRLr6b/3Iv/hfl8svR38nMVvUqopiaJKnOUxt/2ELr9inpVo+Y
	 6Gqnrs7o4N5Jw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 51/53] selftests/mm: va_high_addr_switch.sh: drop huge pages setup
Date: Mon,  6 Apr 2026 17:17:33 +0300
Message-ID: <20260406141735.2179309-52-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 75DD340009
X-Stat-Signature: xo51rzbgb6hk3znhab69bdtrdpk38ybu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775485362-976381
X-HE-Meta: U2FsdGVkX1+/6j1qbZq4zUE1uMt538UQ/2a6pmrITrLYSfNbBoBNNQxV+5rF4qKhF/Y60WRo8zoNZsAtN8EWM8mo3Iz0oWlxbZYvrstkq6IrcIDc+C2AOm3dTYijcrIcsBt2E6AIWWzpQsIg98v/j/gzkx861F1Wjwi1NaKEGdpb/LlMIsmCi4LydlwJT5K5Z5yHhg/UlMzpenP7NSB5r167ylYufYDS3rKoJUAAVUbIpjR3Czhu1+CXb02nvGVRWx2IFI3v/xQffcqlcw9Ho0is9x5fahHdWesD8j9fvOyDQ+ZTo+PwU23sgpmggfWGgL0JX2YA632zvZIMAEA5dOGkoVMeYceKsRdMpytLzkyjBv7b8r0/NGXMApIcessB8tLpNnyduvNtnnx5c1OnlKGKdLTSmAa2zCrOhSxizG8rUqLOLTitgssfR97Iym5bZHcsC+nur5IixET7aF8Hi+tOAHTZ6q+yFHhnP2e+e3z3aU1k6gEW4+ya7Nq3W9G5hQ/jWG6ZJY0oFEB+BbZPmvtEwI2L5Pe1M6/WUEaLj+A+irv9vXKT0w9OV2QO/xJoWcWcAA+gTlwcfaWIUnTQMhyW9cMbNgcX6K8uh7XeyHx13UuUq8Tpm5BMVuh3a+pgGcK8/BBNHgpcOPgVvMWAHshik3x3gHYDIyUXT8Ku6avyyYrLUWu1yXX2AEn6N2DSBTLqClI1z71+65IvRcNK4ZITrFUSPoUuGSM5dROK8u1FFFT/PczQsj+xAQu83tcQY5naOX/DroB1L3soqXR87CmcoTnftRYdNo1+SOcVTYU2yQOm2NmeVBTTxKeSeWjoA64YCKuHRz5FmyXxUm6M6P2mCZwAxFqttgAa+GWfWtVB0laEGahv3Q2Ae8xlwIALVAajRC+cd54Cth/n5yQECJuCUrbOBIaoIP/2mkCXEE/Hbw7CVa18GwsaWGxAiDyNoQ91GET4TjXatjV4+mg
 cZbJgw8I
 HnZiy23BgHaKEiZeZEolepDLuxMR9hRwidLbAYU1Gtpu4SjYdCs1F7iXS2uy/AwXTrqZt5GVPpkUctWlzXd2XfpnLrZegQY5RlM94dNGY5tbvtEYXlxHAnErTaPgVLrIdrJXpo53cbB5Zt+DXyJ6U07LOlFsj2deqngUtf7wG1FYgO9AECDdAZnlXeB5nABoPvZq/APe36m65AAjz1/cn6n7JXEbmAHGzrVyXO5YNy/ra9LzK7RMfMfnfWmDk9VC7hEOMRYLCWzRfp8O9YUwumQA4hbPifphKxdryqLcuSQuBtPsAzUx6F2uCttJsXDToYaKm
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


