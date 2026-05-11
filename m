Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4CDACD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:34:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C4706B0139; Mon, 11 May 2026 12:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44DFE6B013A; Mon, 11 May 2026 12:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33D066B013B; Mon, 11 May 2026 12:34:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA586B0139
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:34:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E7C3F8AECA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:38 +0000 (UTC)
X-FDA: 84755687436.09.D27836F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 47D2E4000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rnI+fDIR;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RkjwIhoge/GGm7idHo4aIsaQtAUHNxPudgCfC+qSYyA=;
	b=s/LSOjEWxjpyfot/L0jZoabdx3VNEA7RXIi9f4yBCqOgESw9sptvdiHWjM2TYnaOOWbmrP
	gCXH12l6Ej23m4GsPaK5XysY8VK8BBiwnRCIoTGaN7xNsV14nZ9/913KyidcQMDw7Pss8b
	NZDWOgLbsf6NR2SnRq+AkanSjCdZtX0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rnI+fDIR;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517277; a=rsa-sha256;
	cv=none;
	b=TOwO+LOHHDx2z5H+n0jVPSpdrW5YgDa16KJA2vA/ov9J1z0iI6Af0NLnWuhJTPsQNgoK/M
	huQxO2T3mRt7Vgc87+COLc27pnqAd9YZck8NJIbg0tdyVdibtA1VEG9fVDlFrxxyCgp0zd
	SnwJSNq7aEfBuKsaNiC+jtpn32txsds=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C36A260103;
	Mon, 11 May 2026 16:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79249C2BCB0;
	Mon, 11 May 2026 16:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517276;
	bh=cC+xeN8LxFcFNLizRYxYZtV3Kwl2xV99NyAd74E1Kcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnI+fDIR/5JJw0kynRF9ZemaGluf5lMGI8mSRiat5jxVTNPyRzJFONCgBKMTYMHXx
	 kVqOmdTXG0ZfZK1FwG0NePMK2RtznAAjZkEZxJ8jp5boBAeavkW7regVKErgZMnE9V
	 uBKtxpCo1tRYVvs085puXBeakH4YNu7rO7SBagErC+sdlXOMd5c9edSL0oCde4t4Pv
	 b/29dfN8KAXIl9VL8orDskje82FF7gVbBStB8NuO7UddsNRFcMNOdNKkPLp5enkrAo
	 tOWIlR8qh4wenV7ADd7HD626cKyhGemsTO447Pkr3K8rVDmkAvMqkg7TILzx52Im1s
	 pomg5ED7lk2GA==
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
	Li Wang <li.wang@linux.dev>,
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
Subject: [PATCH v4 53/55] selftests/mm: va_high_addr_switch.sh: drop huge pages setup
Date: Mon, 11 May 2026 19:28:37 +0300
Message-ID: <20260511162840.375890-54-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: raj7o7z9pr6f7y89opkynj756gitf4ne
X-Rspamd-Queue-Id: 47D2E4000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778517277-619004
X-HE-Meta: U2FsdGVkX19Hu40V5JStgJUpadBs5VhKEEOtoVwrm2UwfIlib6E44T4Tb3W6oZSi4zZVS08d5337cb24kU2exxnjgavooIgkhou8crj2L7800+DMdzRoU6mIwf5BxVOiIiTdQqQkLrUgRtD6CXIhd+VaV71oJr6+4Gne/YSLnR6nF4KdZDHUEl5NucYOTTa8RJKc6SeHpiP41Y5cTB7gbsxYfmMDhJzPccH2YxkdRO8gzkWLwSX7Flw/iwpY9NU4lQor+o3XeegzVs1bZkxNAKlmT5ar0SWeRRBnL1/XrmvD3HbWTfIu2dbRF2J4Onq5an6Fx95WyZyxBbekbp+rIhu8CvWs5Z205mFgp8zM76jyKRRmJX5ZJtBccQKRCnlzN+HmtQ1Q6+CNUHYvjyZYDlMakFJvP7+njTJgjmqLu/NZ/pI9COlvyC+LTaYa2ntOMYdmcSCHwlLRLpjXIBxz1DP8k00j+ilxAKBLF/ctD3N54xqEFcat9uVZXMINVOVUbn880FBeBkJskV4DUw2+oZSC9rQ3X4y0Nleek7IPeum7RkX3jfqKf/ThArT26egpKVmMzWCou7PLoAogBPm2aRvuoDC32Y0Omdn4iiJvbOIGMPy76Xf+0bjXvR9/FgoWPid4+Hk46GdNdxIkgmMMCtQxa3gAn9VIf0w1HP2Ttq9/gTOwsMireULTyC7D7eK5K3hlLbPucmTEJ247pTYphOTMU28H/Q/HKO5cAazzSDuVpDjBrvi4iwhTNiKFo9r9Q7qYAy9ToC9UniByodUllUKj1MsYZIZqeCGJquQeOyj2M2z9qfiow9Eaux+8BLUlNDB8SEpWwpzljcpqwvavHk9Vo74nSecMFz/JhGCBYA5+7OykZh0mIdtEgVbThyoHF9RVa9jhBeW/ENzaXgeaeZvi6bOg59C1hPBjasPY+o4OLJtlMb2gyiMKmDvevFZRTcKSQp6sSZR7EFoz8YZ
 IcUhYd6C
 bu0xXC17n0Ke9tcGX15v15eNSYbig0IgV6F2fqbwzRr/i4UVdKsAZLPjrD1uspbNjcQuBnu0LUWZLHS4fq3qd1daijZq/a1/a6a29TXqS1bk/sG34fcgZ2weH+YrvJIkwo605P3zllVukFlQvPp/a3vY/UJMHccpINN1sKbbYYS8Q5xhFIRU3L1jOuZmphfWKMwefOtRCOwzNA2w3R4GKxUTQO+2fdTieCFJPJoGbdxHWavU/5lQLGUNNwrTsZcklU9bCQgHCUo1NXtGe43sm/C62LTAog6EQNBSV2wFNnkUNjnBqBMsUNl6XaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Since va_high_addr_switch takes care of setting up huge pages, there is
no need to set them up in the va_high_addr_switch.sh wrapper script.

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../selftests/mm/va_high_addr_switch.sh       | 41 +------------------
 1 file changed, 1 insertion(+), 40 deletions(-)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
index 9492c2d72634..01c15fe3c799 100755
--- a/tools/testing/selftests/mm/va_high_addr_switch.sh
+++ b/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -9,7 +9,6 @@
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
-orig_nr_hugepages=0
 
 skip()
 {
@@ -77,43 +76,5 @@ check_test_requirements()
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
-retcode=$?
-restore_nr_hugepages
-exit $retcode
+./va_high_addr_switch
-- 
2.53.0


