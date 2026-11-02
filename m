Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D227F606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=b8EjWOy3
Received: by kanga.kvack.org (Postfix)
	id EA51C6B05BD; Mon,  2 Nov 2026 05:03:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7BE26B05BE; Mon,  2 Nov 2026 05:03:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9E16B05BF; Mon,  2 Nov 2026 05:03:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B978E6B05BD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:03:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5AC03C0C2C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:03:28 +0000 (UTC)
X-FDA: 85389741696.05.29D85CF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id C1295C000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:03:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=b8EjWOy3;
	spf=pass (imf10.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793613806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qsWUhK3u8xxsdLOp7S4PeHirDge8KSgZCNYY2BYGink=;
	b=PgI5ucQh1svhpyHm19ASfvlhfIOPRbiXiyvyXrbawUepMRJAg5an0cabsi4GUGIasp9yBc
	ifZCpKzjKXCh7PKo8IXLjiY5CgBtCd57Yt40TGn1SB4rw9d3neVtx+gtnA5b+PCjXDFIvz
	Myekdiqzv61K1PjDOPhPjKCoCUAkIC4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=b8EjWOy3;
	spf=pass (imf10.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793613806;
	b=pcAYL4K9MjDFWFLn+4CwMloJN3yGzX0bMESAUPQW05GI8I7FdSDmUiJdWbJtimOFh1TWZD
	yZCVPY6eN9+qFXELPaXLX0MXI8/HQS/IRNbp859F2XawYPPuRJ6S1w37es50X+cyj8UFjd
	tLoOfzHXPezctZFoMxwFxTROV6a7CPk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED9851762;
	Mon,  2 Nov 2026 02:03:22 -0800 (PST)
Received: from a081061.arm.com (unknown [10.163.156.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B23643F59E;
	Mon,  2 Nov 2026 02:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793613806; bh=HON1k1mBTpdlmMMiPcmWNkUSmFAOD7DShtnrwNyZsw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8EjWOy34JhDwaDUOj5cn+bmSD3XP+922StiAJYibForPcZSBJV6qentDC7RousFl
	 JDXcNJrghYZEBK7VGzSDLxw0FtnACrI60F5ocfB/0O0JSuFAx3e0D/KcGRSkGjSJhE
	 O/qlMSCzMTQZRQJekuUMfSqUKORwnDgl2eeCtt2A=
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
Subject: [PATCH RESEND v2 07/12] selftests/mm: mremap_test: fail on data corruption
Date: Mon,  2 Nov 2026 15:32:06 +0530
Message-ID: <20261102100211.141831-8-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102100211.141831-1-sarthak.sharma@arm.com>
References: <20261102100211.141831-1-sarthak.sharma@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1295C000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6d1yz6wqfu3njhpyfc6qejzrx4pptp4m
X-HE-Tag: 1793613806-685820
X-HE-Meta: U2FsdGVkX18kWim1ZCSC/tRi9AlDawS94mZrmUogWCdcVhq3jnL4aOUP1YuYOFFFCjSPVLp6ZB8vuSUos30rpgv7cHDLLa/1OuKagCxsALfTnnidHhwEq0SgeY/zeLcVJXapKrOsM4U4iGo7iXqr7Rpm5WVZRjzpeaN+k0BR8n2GgP1MatKWJ3TcMuNa47Y+RKv8VlUHk6K/9UCVyORcGck2NvmAn40GKaC8qZv6hnkGY5YpOZVYur6co/dQx9N+sBYbN4sMufJxJjhhRbPSZmoRITnK9FAI0YF11uMa+lC2GQnYmm/rbrfINjCjLFkbnNnYYrkZ9bHDnOypmCgSzlxMJlV5mjezqbbu6X3MZ4T8EIwC0lY8/KYBvn2DJtlUaDj+PARXhKXxOWhgNcOd8j31oxyDnuyDWmLIY6T0JT9v7g3aa6pYaFfW2sxo312mIqAMhtmfS2yV4QBXlOshIKihhFag/gZakb16818rQFZnx94Vuusp/Gu2fWkmubpkR7OCKFYWA1UDeHMrSMR9MHA/j+1ZMb0Y9XyUO/TjZg4ZbJ+NROXGuWmDi+a5U8MmmBEy8Tv0lwC9FCN6WRXcFkv1VeRTiw11sCbeC/BHroYqsIG59uErF+6qwuuNWaALstAJPy2J3IvmiMn0sNMPw5DGJFtMInvj1gypyLQ+z8X+YKWqBROU0d9jpDWfyp04+3wJEmjc965mIV1/XhO5qpJ8lvYLGRrXhS+h5vRaifEHG15MIL7mdgB+uUnGp1zD+FOkEzOqgiv/KQIs5fhxO2pBXox+XfiDzEoK2UTAtd5iOA8ubP0tLhOgAybiPTuYrQcuUWxBk62HXxWp3DwQHACm/dlPeAF0j9uHmVeKwDhm8X7W3JX4IgcX/lTg5ndjiKvDZVIpkhS3nSiv0Nxe8qzDK4v+9BxSnfPoXzexGgbbdnuSeBj0X8AixeOewsUy7siS3w9Jrm0YiZPwX7T
 YIux9pyZ
 RrRp6rU2RdZ34ZyGKMB+wmq2AFqKxQcK5HO+TQJR79oaLmi1RVJau4ZRUYyR9y5oT9Kv0BSzpIECXuG0waM8W9sSoLjq5VXPwB8zrYji3QlveeB+Htul3d/u+/JoUUgBJeeYLONR/h4iG5Z8Dr7ObagHTkrh7XrM8WcfZNYJIC0Ees/Na3umXoCw07nqGEoFxj/rniJ1Wc9BxxDLRrinft+FOdgbnR0qD1dw6YVgspx1gaLA9aQR09u/m+yOdWiadFsW8l6/H9HaorNXqUxss9VPeBaXf73Jev99qHB+2+C4y1/PQNDK+aNXF9hw0i1fmB1my
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In mremap_move_multiple_vmas_split(), if data is corrupted
after mremap, the control jumps to cleanup without marking
the test as failed.

Set success to false before moving to cleanup.

Fixes: 7d6597dfef11 ("tools/testing/selftests: explicitly test split multi VMA mremap move")
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 111cc3414073..514d2003b88d 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -682,6 +682,7 @@ static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 			if (chr != buf[j]) {
 				ksft_print_msg("page %d offset %d corrupted, expected %d got %d\n",
 					       i, j, chr, buf[j]);
+				success = false;
 				goto out_unmap;
 			}
 		}
-- 
2.53.0


