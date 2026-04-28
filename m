Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2685EFF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4E76B00C6; Tue, 28 Apr 2026 16:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD266B00FD; Tue, 28 Apr 2026 16:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EA1B6B00FE; Tue, 28 Apr 2026 16:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D8006B00C6
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:48:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1F9CD1B8FA4
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:48:43 +0000 (UTC)
X-FDA: 84709153326.29.2664B55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4995218000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:48:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KtqfrHTS;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIttIBoEaC5zcLx1z1bG8Fib+RILRc3eqvfvc2d3hQQ=;
	b=MNDNZkI7TQ6CTjVPi+jtDf1AJ831gbaKH2iTbtRxzbbPEFHrlrHiNToEEa2exkXmlvLLUs
	tu4M3/jdv3NRru7e4bVhUmOzkgT1Xd3cD2B1oobRof48iZn+G4cEVw0c5PJCgaBUKl/LqB
	3GMzySpLPMot+9CXGejHrsRvrt7i4tw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KtqfrHTS;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409321; a=rsa-sha256;
	cv=none;
	b=Dko67CNnJGUR6uFmZWBWAK2l+3C46FqTBVnccx6KVdX8xzvxI+IZhyeFlfKk0jaHSyUAIQ
	P9tPxfy6ZEZPTr/pUuSwrDw4cQ1Kut4WrYYb8fJlyenrs4ZjcT8+c5KYL8pcTjBUeQBDBy
	x6PQrhFR7rpCo4aPwQU88nX/NrtNh5w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 611AF40214;
	Tue, 28 Apr 2026 20:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3441EC2BCB3;
	Tue, 28 Apr 2026 20:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409320;
	bh=XYoR5ykBzH9ln8CEkCcM3Jpo8h2bXIFgxUkz6fxZ/LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtqfrHTS9/FD20Apc6D6Tc83MdB6i2S17dvN7aBXRCPZwoTGCiyaxEQu76quQaxOH
	 EDbLBrK09yVRuVjNG96piJu6xIptkjuo5ymsEv2ot/85tUVh0hwY57HLzsg3GTz6MH
	 lUMOoawbdRHlF4zZO2qY7frcKff9DET5JqFZkx9Z1lm4VkFtjIl3Zz1US2j7MxBq/Z
	 Z8hAzlo1QqTnexXK3qBvdh0BxU5BfJPvWcK/pncK9zuT2vfQjt9rEcdbAWjWNHqZbH
	 Pjtasw+ZBZq89CI+EJYemgvjUdlBKpYoMuuUzEFJ/lWb/wVPkpa4FsWeSmKn0gpzJi
	 mBpD7G/+Ge6Uw==
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
Subject: [PATCH v3 53/54] selftests/mm: run_vmtests.sh: free memory if available memory is low
Date: Tue, 28 Apr 2026 23:42:39 +0300
Message-ID: <20260428204240.1924129-54-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e4by5mdhu7eccwwaynbonnqysy8b51nx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4995218000F
X-Rspam-User: 
X-HE-Tag: 1777409321-308868
X-HE-Meta: U2FsdGVkX187VnkdNjX5qbKFqFaTLGXLChDEqPDM0FNsHaPknAWle1Cl8n0MIVvcbzZsmf0p4w1R+SaqpeylXv8qwTNFvbVUjKfnyfWjd39sXEBxp2NZUMCMqwGTBaTRzYqqZWPTbSOj084I4RaiVdxTzMYcHj1O0U7qaBhtWff6vT0EB0gwDKPVCkfQoEcS+2ssY+L+hllhky+s2gPJeY8k3z6pBn+A38vA7kakGn9Lzk3fPFt0akWgb/ldBHnYy0pSugk9f2ziQw38BT1B7Ov5m3l7H1AbBlpCsBfPGPCQ9jxLrgMcCGfS5NbxCTReeiWprPvouZT26n6MDcFoBLvzxUw0pvpH5+OiiHJMMalDvqs/eC76oO9a0eWYmPHIQs/Bg4Qp2PqsAySgJY+Dd1+TRo+CPFnvfZaHCl+ujIs+YbIPU1cog2nr0irRPqd5DjisKTBNyxN6Vnq2TUl57p5opWwQEs2zQ4hyF/wLazK7q3DPsElUgQH+9fOO6kBuVBdqut036I04r/R8OdSWE/Jv50QGaw5ZXefcG5bOeYoTU8qbH/SAJZ6KX0G4s13D/kaeF0MRGZk2+AfSnnoPInYeb4rRyvdA0lyrR8Yb0gWSutsJaaD9Dgcs2r9guJtdhtqGyXz6xwadyR9IzHI3/cIRMqK5zVTv4sIRzI5mFyqoWyu4NqTOgMVG+wQFyIw0DMoTlVWCetVI1uKhv/WVdB7B7O+PnMoWl5pNHd696UJwcvu/+q4QElr5+P8PNuiFaY1G87W9ZmefPy0sxlv1lvZKYCgPCtmqX1tXNSCRA6VY2QLLrwQXLtTZpzM+MCc5V/7yJ/PNRjiaFSI+6AJ4kZjt63yAenWRBAUM4DHUDBqNlojg2CiPhInMX2js2F6fhgt2Dvf+9CIoIkVKrWA8Wv6KvLZAITzHlWwCdwBJKPfGWEsZzj8cpK5hdJJF3+Npe/3oMK4WpVi6sIDSKPy
 wkmrpku+
 xcXK7z4UvMInZsfmZpb8m3zfG30way66bHIaB0t8g9rFmkWXEVJghtX/2oGFGk/+1haThc9lVHzYWXHUoEXn2JIEx83zcmkiZqx5bBorOHK4YfFG56YOmXDan0oansvhjjTF2/Ka0NhWlMQNxDdvJxXQINVNis4Ffiz5W0lmHaxs8MVYHXx9VOEei117LoCeL/A7/rumFv1cX4aeXaDFWh6sAc9rWYyfGPJgS/4yH2oqZEtsyq2HO0lcXFmHgSMuHs4vF3n3W1eGQdcYfBU23cmBQfpyWo6Zn22V1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Currently when running THP and HugeTLB tests, if HAVE_HUGEPAGES is set
run_test() drops caches, compacts memory and runs the test. But if
HAVE_HUGEPAGES is not set it skips the tests entirely, even if THP tests
have nothing to do with HAVE_HUGEPAGES.

Replace the check if HAVE_HUGEPAGES is set with a check of how much memory
is available. If there is less than 256 MB of available memory, drop caches
and run compaction and then continue to run a test regardless of
HAVE_HUGEPAGES value.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/run_vmtests.sh | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index b9e520194634..b42d19036182 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -99,6 +99,9 @@ EOF
 	exit 0
 }
 
+mem_available_kb=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
+mem_available_Mb=$((mem_available_kb / 1024))
+
 RUN_ALL=false
 RUN_DESTRUCTIVE=false
 TAP_PREFIX="# "
@@ -239,15 +242,12 @@ run_test() {
 		# On memory constrainted systems some tests can fail to allocate hugepages.
 		# perform some cleanup before the test for a higher success rate.
 		if [ ${CATEGORY} == "thp" -o ${CATEGORY} == "hugetlb" ]; then
-			if [ "${HAVE_HUGEPAGES}" = "1" ]; then
-				echo 3 > /proc/sys/vm/drop_caches
-				sleep 2
-				echo 1 > /proc/sys/vm/compact_memory
-				sleep 2
-			else
-				echo "hugepages not supported" | tap_prefix
-				skip=1
-			fi
+		    if (( $mem_available_Mb < 256 )); then
+			echo 3 > /proc/sys/vm/drop_caches
+			sleep 2
+			echo 1 > /proc/sys/vm/compact_memory
+			sleep 2
+		    fi
 		fi
 
 		local test=$(pretty_name "$*")
-- 
2.53.0


