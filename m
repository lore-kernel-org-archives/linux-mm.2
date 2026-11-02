Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A7D2606A333
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LUs5F0sL
Received: by kanga.kvack.org (Postfix)
	id 63ED86B05B2; Mon,  2 Nov 2026 05:02:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 616756B05B3; Mon,  2 Nov 2026 05:02:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553946B05B4; Mon,  2 Nov 2026 05:02:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 352EB6B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:02:41 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A159120C63
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:02:40 +0000 (UTC)
X-FDA: 85389739680.19.11A0A7C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3B48580004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:02:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LUs5F0sL;
	spf=pass (imf30.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793613758;
	b=3x7AIVWcxxHUtIYfUSTFn8CHe2aoHmPDHouubJtSIdZxWKwcgsrBILc9sat0dBAYnet6x7
	HsxWrcjROXEBOG5zpIw1pVLdeVKdg/x3g6vl3h2BxqCFgIRnTV29byx/g1PAlXd3VtwADz
	kd/TZbJaM+viMIO5asxTMAvS/P4TmFY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LUs5F0sL;
	spf=pass (imf30.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793613758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOgDKaBCd/uW5l3tWVac81a1JgyJkjCjE7oa9weDmqs=;
	b=DGDb9PPyorvkw1xjlBZ3xgE8gytKR+XpxyWgpbrXs8nvn0Zhzo8hnnIqQwdpGdnEuHDR6U
	xvjNM281Pr8GZQMAAQ1XMGG0BUaXSgMEm4Dr46gyaudne1wq3Mpc0Ut+l0H9BHV7tpqE75
	BVGb6OyZv3J6wJFHTLAb4vXpTYs+Rro=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 410981762;
	Mon,  2 Nov 2026 02:02:34 -0800 (PST)
Received: from a081061.arm.com (unknown [10.163.156.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 06D823F59E;
	Mon,  2 Nov 2026 02:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793613757; bh=HyPdk0n2/OF09K954RkPRG3iIDUACQY+PsIvlzDGa20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUs5F0sL+6hylMUkR+TZVfKkl10paUGcrplQiQQZ6WUfKLIjCLPhYGglP6Wb8wXTz
	 ar+3NnOPL300FWcax/3rYqdtkE0QnKJoVzemZcTwruUYy/r54YOhcITgXHWqwM/qrV
	 h/gacCCm20AoPv79aMBnztDGWfWcledNR5IdXzaM=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Park Tae-sun <ts930@dgu.ac.kr>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH RESEND v2 01/12] selftests/mm: mremap_test: remove command line options
Date: Mon,  2 Nov 2026 15:32:00 +0530
Message-ID: <20261102100211.141831-2-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102100211.141831-1-sarthak.sharma@arm.com>
References: <20261102100211.141831-1-sarthak.sharma@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B48580004
X-Stat-Signature: h4krc688k8yuzgg71rg8kroqx7sbja8k
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793613758-316949
X-HE-Meta: U2FsdGVkX1+0jFojBwbOzrNykqITGUtYEUeydKqYUvRnKTDEOGksmRgF6bXXGGyzP1enRqelo+CwVl8xIl8QVKlrvIqf9VBnnA2WfOO3EXVnPgMo6vtNcZ7HfL22Vs1+kIYmPKWfMLZe6y/LSQAsr75pf2PbxPVypHhnsggy2d+j63OcJCX9PmiiMBA3ctWnIdNcQfkMQQcrmUOu8LA2nmeTFFxzrij8gPOUaojcXGPtUEGtmoy8MD5dTIw8LhLyfx4RqGQBZgXin60UlilGXP+46K0e1kmkeA643HnYdyDXR+IFJL18QTREcWXuXTtYMhje3/FzNmxDwQt3Wjhre+l6b1nByWwdwz+L9XCcHrqXYr7mOAf9iATHgQNnGhAXBArl1nQo22tFjfkEgAsmrbxPvr/l12apiasWCIHr43lcGkF4JHr6RvKxf19fKYoliagahCdPNRikk2XWoUOjPJoB5aoSwfy4g1motGbdKGZLI5PGz6ooOwtZKfiGftZkm/ZDywgK7vdmApyDk1kTBwKv7/xcd2sNx9KYJ+8mzrwHLcmNyPlSN7dfPVtE4l8WE3NiZSI995d4Rs6waPCq5csnvb2PXMb96ojcdjoYxY0tqRDBX6IxcUvXQoPjsLP9SLC4x2SDrKzppj+l/PeTSpOVYR+kNYl41/drHYGwSWciuJHkMLAJMwF2BrE8EFh27L5hI6Pf53L2Cf+umtDbwSaix57bHJwzHhPGyqqUuqJztAHqltNAG2dBnnnUkFRypUOsMR/lvC1BNV+z/nXDMrOeGYQ9skU+igrrmGWWJpiaWw7QlJ8mcezwqg5pV1kmtJmKJaXSjsI5MmoN87A4Wx7ash4eTwyqgJc/+1OTYw1tDvjRSiFF7f6VkIhf0ZXn80+uRqTKVyNr+GiMOcf1qwVazIk8mWXeSmqYAzKbD3hZLa3QZ4+JL64XlffJhUIiv0BwItfSD3a63QK1mll
 7XIYYg9S
 RkCCsA+INjreIMEaEu1ZDNDg9Y5kMBvAlfW39h+Y5PwcXcrTEbpfivekfX0EYDZlXjrzt/+iE6Fxlc2P+ftLtpbGuhCRrMz3BqosTbLA/+Z65BXFbpUs0aMTd5TTFkxo8a6rjcylZIpYUIe5JaTVYjQLIP9vXd9py1YHSJpqpqPGeO9ilmBSHGm65GtBbPYjReeLpMk2uJT+/mldh9MGcY4wbLuNwkD3Pb0b5znyRSG+rgoTmvU6nKu3PpPIHwfh4YU8PLTxBJnSADFlxsQDEJ4uLVgPRG+vsGkfThLxm3uzjUO9KbnqjHKtxLlrcTJfbrZmF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mremap_test supports command line options for changing
the validation threshold and random pattern seed.

As part of a larger series to remove validation threshold
and randomization, remove all command line options from
the test. The test is already invoked without any
arguments in run_vmtests.sh, so no runner changes are
required.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 45 +-----------------------
 1 file changed, 1 insertion(+), 44 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 31b484517bda..15d8f7458251 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -1190,49 +1190,9 @@ static void run_mremap_test_case(struct test test_case, int *failures,
 	}
 }
 
-static void usage(const char *cmd)
-{
-	fprintf(stderr,
-		"Usage: %s [[-t <threshold_mb>] [-p <pattern_seed>]]\n"
-		"-t\t only validate threshold_mb of the remapped region\n"
-		"  \t if 0 is supplied no threshold is used; all tests\n"
-		"  \t are run and remapped regions validated fully.\n"
-		"  \t The default threshold used is 4MB.\n"
-		"-p\t provide a seed to generate the random pattern for\n"
-		"  \t validating the remapped region.\n", cmd);
-}
-
-static int parse_args(int argc, char **argv, unsigned int *threshold_mb,
-		      unsigned int *pattern_seed)
-{
-	const char *optstr = "t:p:";
-	int opt;
-
-	while ((opt = getopt(argc, argv, optstr)) != -1) {
-		switch (opt) {
-		case 't':
-			*threshold_mb = atoi(optarg);
-			break;
-		case 'p':
-			*pattern_seed = atoi(optarg);
-			break;
-		default:
-			usage(argv[0]);
-			return -1;
-		}
-	}
-
-	if (optind < argc) {
-		usage(argv[0]);
-		return -1;
-	}
-
-	return 0;
-}
-
 #define MAX_TEST 15
 #define MAX_PERF_TEST 3
-int main(int argc, char **argv)
+int main(void)
 {
 	int failures = 0;
 	unsigned int i;
@@ -1261,9 +1221,6 @@ int main(int argc, char **argv)
 
 	pattern_seed = (unsigned int) time(&t);
 
-	if (parse_args(argc, argv, &threshold_mb, &pattern_seed) < 0)
-		exit(EXIT_FAILURE);
-
 	ksft_print_msg("Test configs:\n");
 	ksft_print_msg("threshold_mb=%u\n", threshold_mb);
 	ksft_print_msg("pattern_seed=%u\n", pattern_seed);
-- 
2.53.0


