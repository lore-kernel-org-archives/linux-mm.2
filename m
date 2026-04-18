Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55ADFF99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F276B0298; Sat, 18 Apr 2026 07:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66D76B029A; Sat, 18 Apr 2026 07:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7CA76B029B; Sat, 18 Apr 2026 07:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 90BDC6B0298
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:00:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 637741A049E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:59 +0000 (UTC)
X-FDA: 84671384238.16.429A96F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id AAB4140009
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WUeH0vhQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776510057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yd1m2f78yDrXMiqMFIv+S4+GfV+hGzgCDXMBcoxkGss=;
	b=BtOf4yNkNZWJC7LDp11zt5mIsRy9GZRZsqSvPpoWtTTI0AgyM/HNOUVMfLbGd/tOSzN9ur
	nkeUDT2tAlc/sOavkCdPe7c0zO4ivj60UF5nTbRxCH06T1sATztSsog3eLBMCtEgGI6OQT
	wi205wocxWhJlYd5cib78dpeCOST/rs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WUeH0vhQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776510057; a=rsa-sha256;
	cv=none;
	b=IIisoi1h59kRfGhIi1K6jGcj9QK9RJf0ozeFZZOmOpMfFQmYvhUDlKwzptDohJaZ/15wlr
	Z1APMYNV/v3E4I+K2p/wz3SxeEz+Ki8WHMtc6YvDi9SRqhygMnUPe4gSix5wlOWoEyeXjm
	WklfNHfCpa+RoD3T4TVeCrY5NTUDJf4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DFB1E433D9;
	Sat, 18 Apr 2026 11:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E2DC2BCB3;
	Sat, 18 Apr 2026 11:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776510056;
	bh=c9lUlZ2MxGuh/r9cAcf/coqCUPJYBUQSQ+lZzu+qpn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUeH0vhQ4wYCu+ObVSff+bmAECrRgoug8pM3MKV3tqp8eTn0Kx7G8Rcm6EmJlbrLh
	 XPSRHVm0MLAIdd7HUZ/PwrFAJAJGTngALMhyrSzNhwmrTmKgtx3AjYeFxdoik6+p0j
	 p0rcXf9P98z2pi/R0z/K6UhgexZada2bgYHp0G+BRQwy75BoGXWsemnu0xbcVFXsBz
	 SX9HCnfxD9PeJgX6oWilJIurP0m31yaMbYXDT4944ZyOhT3YtANKTGvSoNlwe8Rz3w
	 qqq4bALUH+OJRYdykeH9wKaV5rj5I9jwk6dtSN2wfBaILjOpYBizpggY9XGB1l1n53
	 wOB+ZDS11Z1VQ==
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
Subject: [PATCH v2 50/53] selftests/mm: va_high_addr_switch: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:35 +0300
Message-ID: <20260418105539.1261536-51-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AAB4140009
X-Stat-Signature: eyqe97cqeete7rri5ssbiqbtcn4cqsge
X-HE-Tag: 1776510057-971390
X-HE-Meta: U2FsdGVkX19AWuO82VQwqI2hJdnfUnP5T7/O/LTZroliyreRTnYYVYbn6WHme34a9fj34oA5Rht4ztnDN2+1JaW0J+1+X1nCRsrUzdfB8fVpMabFHhvl72FxeHQKC4c4dRwVlS0z0T02dF9lflebafPjf+qQq9Z+vpIx+BExZiLAvvZzz6G4jWOQUtLLuJfHmkBzTjHTtNNNEEXM6n8+mWGaNb8xPnjexGCSA1PAZ/K5sk1cdHCMgTNncned5/bWM/zV65P6PiWYW7Fto1RZCPIJLV5jcEvnFDMRpYf9U8iJ8NciMK3jEMlyFGyBAy4/nNgYQXCM1/N8dPaybs6xQU5aUYEQTEa62A0LhNUbZSjCSv7smlFHQ+TpjaWiahB/AVYdpDIn0bb9dKEYXe0CHN+8gRHCF5EapEgmP0BsjFw4P6uZBUVfSSqoIuZurnYMkT1ArEIjskwt99bH/vDzaqKdxKQTOtEkRYZ9HaLwM3ZnuWhqABxDZg6B4iE6QlIYJmUoXojjql7VvHmYFaV0Gu2gj3eaxZwtBrRTRhPHIr3+lInGTuwW7asAAeM67w1c3HphtYg8i8CKgicuuFF/YB86qMs30lIi/lANXE7bznZszqWDAKbv24iiNtKaRlGX0kshTWGpt+NeqA+xiSK2JjMfkLzzFeY+U+J+9jXbV44w9wsGMxWZeUdNSlFz2M6WLw2BoPbyvW4XxIPzzyVES2KMsvdg4wMKw6a2kyludPUOTSc+DyDnCMkknzwT6nyyW0DiciIw7ftGnguGE4a8Y2TGBuDSLg7SayK+6oXysSl0qBPfcyQvWiUMzbj/zwjfElf4MC37kQ69UKyqOJ+SRbtddGOwhqNQyJmrBXaeb7atlD2fFaRLn1PG38HTWpX+czSPpNJgL5+OmbsqkIQoNlcLr4t4I25LKKCnuWEsRZw9LRodmW7oOD4ca9Ja04NKppLI+gbTIkhvPjhi0Ai
 POy2UejD
 jiliGqLjrAKdS1t7/9TDB7i7DwiX1hKP7PjiFKrncrOCzMdPFxPcZJHCbx4fmdv/X2RITBjhCwQiGJh9Z10t5BwpCmubfuHy7Ej1OsrwCNKy0k1KSKSQCARGWNTGum7AXUkYUM2FIYzRMVg9DyFIokXbqELAem1jKEPW2z/23Loi/8MQ+fOYRML6KUETqfFbvkiI/u+QRh+CzIB/pZFuchnonuqUxGyh5XayXPHyvtWHtd9cSridvTLGJFABO9IEmCFjhnS/G+4OjZV+tY3/J/BRzc0aG19KQ1J+L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

va_high_addr_switch skips HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/va_high_addr_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
index d42ad50eb2d3..4a764589f553 100644
--- a/tools/testing/selftests/mm/va_high_addr_switch.c
+++ b/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -323,7 +323,7 @@ int main(int argc, char **argv)
 	if (!supported_arch())
 		ksft_exit_skip("Architecture not supported\n");
 
-	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
+	if (hugetlb_setup_default(6))
 		run_hugetlb = true;
 
 	testcases_init();
-- 
2.53.0


