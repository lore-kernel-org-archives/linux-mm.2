Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3EE1F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17E116B029E; Sat, 18 Apr 2026 07:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12EEF6B02A0; Sat, 18 Apr 2026 07:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043F46B02A1; Sat, 18 Apr 2026 07:01:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E61706B029E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:01:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3BBA213B0BB
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:01:12 +0000 (UTC)
X-FDA: 84671384784.05.FCD9265
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 78761120007
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:01:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oUf1JsJl;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776510070; a=rsa-sha256;
	cv=none;
	b=NEWWvCGoTR/mqSqHuoohQdx5edxOhc4Ie6sTja8ifzajNyqolfZey+YwXWSCBDy2o7tiKv
	dEPk7BK6c5Kr6owBUyoV0lNhkbEsokXSaj2AcwXKtlJpicnhz9LOzry3PI0of690y8E/Yi
	y1syd4q5J7ThMFDZat5Bgk4gRhhzTVA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oUf1JsJl;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776510070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIttIBoEaC5zcLx1z1bG8Fib+RILRc3eqvfvc2d3hQQ=;
	b=Uh36j9xZP9+9kmYswSymtwSOPUAXuKvLsm9ECbsZ3VFkcjZ5wvmL7j3RBL/jwNQbF7DN/i
	qBD3oeHm2IXd3lwn173uTIumqDVx+BoHLJiXhEsIfXAgt5qZXx9OeFQTkKYKvcgwi2P4B9
	XlnPiL5IsiDu10CKHqUy7kyt76wJt5w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 83EED44059;
	Sat, 18 Apr 2026 11:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB07C2BCB3;
	Sat, 18 Apr 2026 11:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776510069;
	bh=XYoR5ykBzH9ln8CEkCcM3Jpo8h2bXIFgxUkz6fxZ/LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUf1JsJlDlGVOwg3ohkg2AVYP8zRYvpQCyI6/xMXz6szqRoZGozv3mUPbiRMJtCZG
	 4BEBFXX1AESe6C4zXZyZFZx4xZ04/Q5G9ZLuIUqNmpoJk913stlnIb8gM2tewFxFga
	 DEartBWSlk0FXNJKzJbJP47Nbb0XTAmA7wYCJuIpVy86h1Y6IJrhrzQhgyM5rRxhXo
	 fdNaZd/ZPhexuhWh9/4irQQ46JRSsW3WZZbg3QvoM6Q/ylvJPSzRLzLmsJiDC9ntgl
	 FpxNIa/nehQ5M0SkwzVQ6MNFoYtfMktJij7HVB+ajbaHpDE9ZFmNOFy0hqz835OLGE
	 n8n1Sdq4TXhJQ==
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
Subject: [PATCH v2 52/53] selftests/mm: run_vmtests.sh: free memory if available memory is low
Date: Sat, 18 Apr 2026 13:55:37 +0300
Message-ID: <20260418105539.1261536-53-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 78761120007
X-Stat-Signature: 769borr3jbeadk8878x4dwikknume8bj
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776510070-294708
X-HE-Meta: U2FsdGVkX1+fXQu1ewWx7zEV+LJLqaYOQRHjsYfIFsuZhMH1YZwn4qHfoFSYP83dhzPg64Y90cV8ZEOHHI+pnQXRM3BkEbsKWqDEw4NCDRL1TFtBGSi9mbC34hQh7/jssuKplpxMOhQr5vvE7AlmIf6W2nDVQmA5xHn/JYPcTKReyGbccRofScVw/K9RCGwC1GpRixd7EXlBIE9sBjOBiYSL/q4MN100apOYkgokXp5o5THtlFugYrImxaiFFS6CHSgBWFGuo6C3tuBTCzBu82IEg6IWS+lw9djTzCn49O8P+ZGFYV0tHrSCC6jgLjEiOqjt7FyNdHQKwIQPL5P0TsLPPW8XRfLuEZ5V0I3meIrhz/wgquDnKWhEijUrsgtOwcyj6aIr6yjcjp+dlAxhQca8qFwp59daJhCSQ12LfoAuajSX+4wcpOlLc2sONFA4mn5n7UXeCi+oxRpDs+HwJzQXvhGZwoGawero69CkZ/LhNFo2OITRSXbJ5QDu+E9DIKThvSoOBrLCI3nYQjFxBAewj4a52xSfs8KKvoDaa1rfFheMFPM4grbFTUeySbuAjPmg8Xx704LSQTxDt5xb8RUQdkhROPLiAuaeRJt+8xydQM8+iXQwDQ9OXimxYI79cMrsBn9bvGbNN0VurddcGwefo2x/+NBLBZUnXGOR/z/54Srm08b/c5nJ19AyTiymEN5Nsw9gV95MEaN04PjZKQfXyHxom6QZgrq32L9i5QYNRYMjnP0U2y4JJIv6Nu0wi9+pO26HE1DDHmi1DYmlCOfSVkP4GoFR57RcuMIUvjbyJ0WWfBvETkgogeTbGBMa3pMA1rd9GDAptFtN12+qw4SsWqEvm+JR3GmHSMs0DxJNKx2tWstyn3A+yKWje/+wCHM28N+DoLqAYbuCGOWLkWS92DGhBBc8ApTM4yCNbltlSpAMEovoGQ7ZOj97EK9qEDwxCN1Hez9fVRQfhLg
 Bo9l0Hq2
 k4E6Pr7lydGiYU/bV2EXtdUo6IfrFvcTxCD2poABHZN6iYTYM8jkqAqfHLShMVnKidIZw+S+MVS1a+8ZcyvsRVRSsrGv2HoMMwsY5y5jQaGyFHRxglZX1ws5H+3wg2JddPF7+EA0WOsx2xfBYaMaRSxSuO6+i/Y3gPJOHMV2Zon3cYA9opDdrOoBOdyl7jl18HTze6UlYb0UTw65aDc+Vts220s613/Lf3t0neynek5IWHesDMfanJo2uY70frvME7AtmSak992avGC1hnjl+ZGiawJwFcSmJTjM2
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


