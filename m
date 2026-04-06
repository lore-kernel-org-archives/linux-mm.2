Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E76E2F46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 380F76B00FB; Mon,  6 Apr 2026 10:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331DE6B00FD; Mon,  6 Apr 2026 10:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26EDA6B00FE; Mon,  6 Apr 2026 10:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 18CC76B00FB
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:22:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7638C1A79
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:49 +0000 (UTC)
X-FDA: 84628347258.02.15DE9F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0A47CC0008
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RVN+JTw/";
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIttIBoEaC5zcLx1z1bG8Fib+RILRc3eqvfvc2d3hQQ=;
	b=VoSx3iNEggpGXYUQ9Ki4DosuSzY+qv0SLq318r2xOzAmp7xePreR22t6xX702ylkRx9Tti
	AsL0PeoH3FgqY+5sfJX387XPRqSh6NFViPG05t6C7Uv1YfpW6f+6NK2aXuC6LbIRz3elZA
	cx2N3GfwRZsqiyR3nL2Cx0opS9lJxS8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RVN+JTw/";
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485368; a=rsa-sha256;
	cv=none;
	b=gZu8HGNpsBZEmx8ATO6U73K9JZ6z01O7eg/xfc41t28BfxqOB7avX6NgelLWlfbemdoZlS
	bUAilM2edkf0FraXYCNVuwVDx8wC3TdsGp1DsYU16aUveg15CHGB6TsFsusRZIf3C8KM2C
	45iGJE1DU9t9XiEY/uy9U1X8zfGMB9E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3913841A43;
	Mon,  6 Apr 2026 14:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB9EC4CEF7;
	Mon,  6 Apr 2026 14:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485367;
	bh=XYoR5ykBzH9ln8CEkCcM3Jpo8h2bXIFgxUkz6fxZ/LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVN+JTw/uWxfh0PVW+2wwrufGbFwIHsBNsRuK8r4mzYYR9SfsJJMPDt7+kC2G22h9
	 /jdXEHXQ78HCa2FtJAIUMNIYUd5Z/VKxdtPDVjlrXzopWagHU/Ms7r7m9shO7BNjUM
	 g+pyM8e9AonkKyL+Vmbppo0/QfyqiuUtOyQRUSQYqI6S1aNb46Lrn6bURL/XJKv7S1
	 s1joRS/5QIcLVSMRNniGpGXua98DwX71QLLTw7mPl79cQ6+gC9PXg4d4cPaUZC0XF3
	 vGukwiZTIrYoSFfZlhsMZTAcRB8a/hZ7vu1dvSlpxmb7YI6y44wwPOUGB82847exFC
	 eBjfPOZXIt+LA==
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
Subject: [PATCH 52/53] selftests/mm: run_vmtests.sh: free memory if available memory is low
Date: Mon,  6 Apr 2026 17:17:34 +0300
Message-ID: <20260406141735.2179309-53-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A47CC0008
X-Stat-Signature: wy9uenyzbgexk63k4ycp9ozun3fcnhfb
X-Rspamd-Server: rspam06
X-HE-Tag: 1775485367-967420
X-HE-Meta: U2FsdGVkX182BdNfFOdkTVv3HpC42EnH7dl3vCBfBWRVGOPMF7tolZ5khyjX5pUuopd+3BCnjT9jZok1XKFyJtYUSOMwQX4taSpe5H3eQG77LdmpUcs424GjEy9E0kqHBmY+lqaPIcWQ2/YmKizDazGCn47qHVi/qyLyl+CplmMLDRNHv9hd//QVMUqpMT3bRZDr4acGwARchzinnJnN5fAlNPKFkam7/OtdCUmVQgWQyfkQMY5oQi/LPqr4LTJCXk4Ledhxs/yjEuxABktRFU2WcRDApUAUMzFsBnHWPBRTlYxhoZc0NzCIUOmHKbWPL2iHornQvaRRJGNbJw6/Y+sy0MYCPWhBdBYEF7Efi5H2cOd62R22MMiH+DYcWmiS7PJ8DBbX6hYw/7BvFZG6qb8vA3W4Wn9h0kjNrF8sp5oC6RT9zqW/NIa1R/GedlmvXsb6r4rVUFm3ccXHxj8LiDVeA8pjsAk43iPUyneg/T42YtLBIqKDwcsNmxQ+5c/ZSArE5ts64hIa6QjIZz9BBpg07HeAMc7HXa2oOLfdN+ye+9g0hhKPIpvCDg223eFsSIk4Be8UsFlpczMr2nFJdexH6XK/V5OUDBSep/W9eYlIw1k/J499fzx1enhkPU80n9Kwfl6ZDXihKb3DGXaY0ppo12OKR8cfyeA+kER3C7IHAyXJOfTKz3BEMLvlH7v01MNcqQRUqF4c7+XDBMdj2okWPsHFHofjj6IW9VT9GljhU8qR+iB/Mybpbq2XFB4vhEHHkVgHtVOQ9JdajHDPhZbmBf6YYqNQ5bmuoTWDjZYz2lKt+DXJIeNwfr3Rh7emNPMod6tKoxaPz5qYioTJjjaspXXd4RQDC4r7Za/ndGLO5bU1qgWYen8nKy2gntHJw/Vo3XivpfoOn/3vrxTxJUfx3OrSP4adOk+xuUpJ2nluoJAVFQ9+O16FoqEelm5nNXqp12R4L9l92VwNwfK
 Utm2tqFq
 fxLU0ArxMEtfOkigzPjstOHDhn46BMMTWosny1uJB/4ALwtfgCasFvkWAAJvADA9yLAwsJ0shy2KEnAxSiwtEW03UttAzhcgjzVAtC0M6GQG6CpvaHvUkjBUs+5KAeR4aepuZ5htsN3o0rsZP4o1wWkGBnPzLS72BUYc3L7X9x+hOAWAf8oyZ9aargjYmkGzw9oLQxDqbwZz1FE+uTYGtmfBZNYdUxJySCVm2h9gprUhXUIWfDJITt7p3XLOTZoMUpV9I+k3Q+44OVOjDK8I+Dhwl/46gnk5eNNRI
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


