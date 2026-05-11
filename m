Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7800CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49DEE6B013F; Mon, 11 May 2026 12:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44DFB6B0140; Mon, 11 May 2026 12:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316736B0141; Mon, 11 May 2026 12:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1726B013F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:34:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D85C61C0237
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:45 +0000 (UTC)
X-FDA: 84755687730.17.AD44687
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id EE7B880002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CqQoS4p5;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VvsNFav8bvMwV9HTpx+BiGyMZz7RIkkfuhK6Sa7y508=;
	b=e1DLC1UBj0CLVPR2xdBwx+zg+cS7Cj3tlM6jQMPCMFh0/QdCuwS8MWAmyA8x05mHoq3TGS
	kK5dOuFON8zl16ge1cSDpj/7NyorSKgFyp5HgEw7v4iuD0oUa3qdtqinQIcwaembXJ8dFJ
	cj0QluNCWdDIXpvr7bprWTjF8z7sIbk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517284; a=rsa-sha256;
	cv=none;
	b=aNkpCWl0a6X2r4U3pfNvrJIQvOOIDhaNj+LScQUh6QNUyxKj9kZhqxdzgadRa50+iY2L5l
	jml4+h8tsUhX+kWah4olmv9pc2ag12MCypkH0EXG9Yl2WCD9/kPPxFXKp5Zfss+RmtFuTv
	cKeZVJCWPCEaLk1ttp0CQXNkuTO410M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CqQoS4p5;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C6A54085D;
	Mon, 11 May 2026 16:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D12C2BCB0;
	Mon, 11 May 2026 16:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517283;
	bh=n1Mt8JH9EyCnyBzZcz1MIZxUn1KdveQ6qfX1RYPTiWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CqQoS4p5tW9HVD4XPxHSg/gAlG2XaypPm2PrMmUzY6X55im8LnY3+lUCSgJ7ZDwo3
	 LoLnGxNlNEIg9hKTisEqTciVrRWrcBSpj4exLr/eZdjPyQiEopS8tJkjuxJjgiBqQI
	 9lfMHbLIWa4KPzPinpAJfDYwW1yHNzL0/GBL7YGetqegMADsOqENOdnFTw1Ur4CrnT
	 yPsKfjHX7coLiwl+pf+Y/Vqn64DBJuYpehRJtciNY3YedLC21olEdJ45VLrR39UYBg
	 kJmMn8LGeG2ENPW79PAlXuI5bjOxaHpF3mGcQANhnxkQptnPqIwNm4XEcKpqHAGdvO
	 K+htcfm7FMVZA==
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
Subject: [PATCH v4 54/55] selftests/mm: run_vmtests.sh: free memory if available memory is low
Date: Mon, 11 May 2026 19:28:38 +0300
Message-ID: <20260511162840.375890-55-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EE7B880002
X-Stat-Signature: m4dw9rqe7dycff4px4y39uf9quuu4xmf
X-Rspam-User: 
X-HE-Tag: 1778517283-99523
X-HE-Meta: U2FsdGVkX1+RNNeKQw+yHyHZwzb7gB9fttl6H+gqUdFIHTWUf+1ASFf0e4aZFekcLDqffJN6V7CzOwawiRfPc/toxIopfi8fSX47W+sLEVXCZ8/ryMOljQlk5BJCzJSCnE56xlDQnkDAWX3S7rH1WuzI0aKMKTNvWcz11IuRd+CqOcNx7a0bQshCiZPH15Mr7LP7vLDfbmogF8vDwHe776/jOen3Lq0hJLGGYtE8caV22D/V7aPRftloezaa3pmomLVzyPLBv3UANz3xjSrrIMNqpCfOQTnqqKVd+GOFaM0N9/oZPF3HbGbNo0vX3AIEwVCfmP0HKB31E+HskYWVn9eG1Hh7/J43Uk0y9/mnGeaE+XwpKCGfYyYObqEwPpXXY5c/6TcHiFFTXpaTcBfR0E8al7DYzhXLUaW9YcTtIaQqWKIfCI8aJ0YIS5tjf2MwKBOePl/CMS3eWAcvxXYIX6l7B9LgYZOXr01TnBWouEl8wSLL7IA5e9dBpVHTJ8LwXtUtlFkL+o+OQxe40HJU/H/rR3wUAjLRC173srSb/cVL1KCPGDQD1peRCSM+PQan3oQmp2oCx9bdsuoMkDATz5lA4UGFPd0NDganOVu4rDxPIMkkRo94JJoHAHtwhGKTASzlZ+kud0lQHs0vB5YZgTm6B7i7+oer98XAksC3d8yWPJNMWBV45S02xvz0HCAa/OplSXPYfDOxEQR/9ed7AXq28xTNtn9qEKVWTl82lv2W99gF24SbX6d45az7VCsQoGiLRB7YwAORpFT1VDDxm2KRjGlj6HvAuq2eHIR4AyrKZAbXIJl2XwPXtZuiNTgBtdaAsWwDEqA5xLfOzs1vo4OxBZDmPDGkl9NQkRqNJV7G4Pe7D2yS377OUCl2v7awFZ2h4AYASw9LTR93u1B3xfrk9d0V5XQUsqSWLc71tbQAqrYGqRECe270bOW/OG+G8IUsqq0XnpvJFDXjp70
 3gVPWaPF
 i5GDfRcu4fFM0HxJcmOkpHmPxOBCmfsEumtWLNrD2KE7/NssdH8SEEMHUI0845emgJrz/GmyGk6VQQmfJC2l9wmG5aJWOD59vKO5aqwd/Ki9Ff/PIOXzskfe3m3//388cKOr+5qw/JxPFVNR82cJXFW8v7/Uz6rdBLbB1dJ9n4lWVLUB8TgX7PLFGAJj2c5TB4bHzsRNj2fl3P5Y3MFdjl5qTgLn3AHeWtwGH9WLGlcTX1aiHk7/tNNwZV/L/GM2EqXh1Q1Z9ZScQD2iaS142ZwoQWPrKeoJxTz2MiHzmZeduEGU18qqZnNBaJJDS7iA2XxdsL+zBPWKjNOvz5ApEBQKtsoQkvW9pEBoaW8fmhpJkiFl3cvV3e0AeOIDDUdXKggOeEfzaL+Gq23ZsiKViClw7A0DaTGp9+lAN
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

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/run_vmtests.sh | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index b9e520194634..45298157b155 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -234,19 +234,17 @@ pretty_name() {
 # Usage: run_test [test binary] [arbitrary test arguments...]
 run_test() {
 	if test_selected ${CATEGORY}; then
-		local skip=0
-
 		# On memory constrainted systems some tests can fail to allocate hugepages.
 		# perform some cleanup before the test for a higher success rate.
 		if [ ${CATEGORY} == "thp" -o ${CATEGORY} == "hugetlb" ]; then
-			if [ "${HAVE_HUGEPAGES}" = "1" ]; then
+			mem_kb=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
+			mem_Mb=$((mem_kb / 1024))
+
+			if (( $mem_Mb < 256 )); then
 				echo 3 > /proc/sys/vm/drop_caches
 				sleep 2
 				echo 1 > /proc/sys/vm/compact_memory
 				sleep 2
-			else
-				echo "hugepages not supported" | tap_prefix
-				skip=1
 			fi
 		fi
 
@@ -255,12 +253,8 @@ run_test() {
 		local sep=$(echo -n "$title" | tr "[:graph:][:space:]" -)
 		printf "%s\n%s\n%s\n" "$sep" "$title" "$sep" | tap_prefix
 
-		if [ "${skip}" != "1" ]; then
-			("$@" 2>&1) | tap_prefix
-			local ret=${PIPESTATUS[0]}
-		else
-			local ret=$ksft_skip
-		fi
+                ("$@" 2>&1) | tap_prefix
+                local ret=${PIPESTATUS[0]}
 		count_total=$(( count_total + 1 ))
 		if [ $ret -eq 0 ]; then
 			count_pass=$(( count_pass + 1 ))
-- 
2.53.0


