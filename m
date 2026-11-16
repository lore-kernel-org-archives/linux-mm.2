Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEDF3606A335
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 08:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YKadq6xx
Received: by kanga.kvack.org (Postfix)
	id C4B796B00EF; Mon, 16 Nov 2026 03:56:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFC4B6B05B0; Mon, 16 Nov 2026 03:56:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11EC6B05B1; Mon, 16 Nov 2026 03:56:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9064E6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:56:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED58A12075F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:56:33 +0000 (UTC)
X-FDA: 85440376266.21.439B990
Received: from mta0.migadu.com (out-241.mta0.migadu.com [91.218.175.241])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9F47A1A0002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:56:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YKadq6xx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.241 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794819392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TCOAmNe0BEFi8mKC+0PAv0vRnH09iyDNA3a8Nshj+co=;
	b=6ry2lr1639xbPDUn3BkMtxjahMzzfppyIuSEXK+49C8fur6E9O+5LbNTme1kruo5cnZ1fr
	ztm2cidkqFRqwuka0ZogdSHHF6Z0ljUsTc8CiesYH9B0nxAAejxusAkNEQzVfXP+MCnPk9
	Bx0WZuK3rQdfagKrQu4F6IT/Fx1O7wY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794819392;
	b=YhI6LgDFMCaYWaEr8AC1D2+eKHON7rsZEYjZamqbSyozZPwoOPbW98f14es7P44zhWpBPh
	d5xxvd2IqKnvtyzFC89LyzCNBZDwV7QXTazkv5Q6pzCMWU4RflbBWvhEnLJh/Xm4sxK0At
	uZGGuTl7qTIqtU72ICr7TlJAweR6g8c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YKadq6xx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.241 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7lolab2zVmmIzQhOdTNrMQkrZuGsVRndTA3iq4cS6mY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794819390; v=1; x=1795424190;
 b=YKadq6xxRABnupfUM1Y3hNWq3Al7M1iv5OqCAbAfNTk17YILf3ZqtW36B6X1MXCCt1kkg91T
 6eHvksBn9PAi9rKa8wc5E1tikQsyX9npBRPn46zM/d8prnXNJ6tKrMyplef8SF2GgP+mcVSv6Oi
 g6mYlUnstFLAeQrKREmEXLfI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 17b6a22d7d497bc4;
	Mon, 16 Nov 2026 08:56:30 +0000
X-Mizu-Trace-ID: 17b6a22d7d497bc4
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Mon, 16 Nov 2026 16:56:11 +0800
Subject: [PATCH] selftests/mm: protection_keys: use _exit() in aarch64
 ptrace tracee
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-for-pkey-exit-v1-1-ca4c76b32ff7@kylinos.cn>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqAIBBA0avIrBtQF0JdJVqkjjUFFVpRRHfPa
 vkW/1+QKDIlqMQFkXZOPE8ZqhDg+nbqCNlng5baKCVLDHPEZaQT6eAVZShN8EY7Yz3kZokU+Ph
 +dfM7bXYgt74TuO8HcVaD73EAAAA=
X-Change-ID: 20261109-for-pkey-exit-0f96fd62c6bd
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: hongfu.li@linux.dev, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794819387; l=2106;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=I343t2uR4wEtG+HLyp6H7kkFFFvE00XGS9N9j96x0BE=;
 b=WBYHvXmoxaPSzAUK9OsLYlPhQpq9V9t4iR/GbU7w7PSrNgs3/neeELXubmCtAzFBv88Jh67QB
 PJu87aQrbGhB3pKMntsmZzL9gPjVeV+SRoEasVfYnMQ81Pr6WhKMFkM
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Stat-Signature: a9sptnenuagt8b799ii7ifhzpdxy51ur
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9F47A1A0002
X-HE-Tag: 1794819391-445844
X-HE-Meta: U2FsdGVkX19ABOhzVbp3XRrfmQgLOcrLl/OMJYc8gN98E+CFbCjFzu1Yw1W1+wH8EgSCeUT0dIbmEUvVtrmAKPIAsAthkMqxGavm8oJ3nY2op2A7NauF9MEps0sUXchoojMCyswURkiPpfU7vR1gXdVWb6FXoLLuxeBg52t7TrYztbVY9qon+88Cq/Hvj9uqObgfq0sRkYAiXSdOpr5+bFSPoJb3rQCKiMU6TTPE8lIOX/hC1F9RLgCvX6mAgq9Qx5Msd3ZNQN320YuY9BjOJZJFxw3dPzIH0kzWLb/pF23Itfkz8Mlh7f+Pw0hQQ2qxDpqOcCJgAVOD4/IV7oT0a7LDWkhyEuIoT3AHTtdZuihf6IwNX2e2D4wZvrAjfcBpyqL2+CvefuYx8SEzgzk70y0AAQ5dpyvsYDOxq29Kd0kk198+1Yhf8eLH2T3Bm8B5NzdQZrPBUez8+Bhy06uSP80uJxC+HfdnEU9bLJ2aHxJFoEGQaSM0GGCJhnIuyopnpPxWoK3RIQzkNQ4PfVQvpY0licjSktM3HjQrnI9TmyTbs4LHKA4LWtehJaptZKjiEXhZxIpIUP7CDnp9V64y+SiBH+KjYtD7+B4BXYD+wKrDaRDIFuMZnyRzg93r/a0hwMPjHI/JG1FeCJqVLKR78VGB0odYMtzm7bFyIP8l8vwCuzdLIYr6nVlaLxnygSocPo93nMUWxnsvwSM0q1SXHW6kn10cKzTihGLk878ZvKr6vb+/Inqq0aHBN/YjLV5ieGykJeWOlP/ZsiqCxs2raxDT4ah+TZJAWdPfEImN9JgaPqN6AOQ3teFYBRf9131xpWdmyYsAtA8TG3CfTBla+lOAyOqFTyWu2U9DxPQ7bLSFLHDxR0nzzzFNdPSIZLmwtBERxetX0xDVzRuqMCj9zdcfnMjMC4oA/YbwTGmiuPOu9C3G+E8lGCnp6LDLqSGOvLR7WtbkuhMXbkuttfE
 edFxLysX
 hiFB7OHxPlgIqcaP485E7FliePbPglMiWw2ROB46HJkltPWUDIoKhB2bjeKbHp0lfPXC5FgIfn8FDBFZMx9oX8j8LVEBhsVLothT7nWmZIQ5p94hkCJrfzk+dhaPCNp5RNR8X/fzaWQ84zQRym7Av/7q/RTwEicIL5s+hW4fwDfqZkGOCpm0/2LV1CDM1SEMc3HXIMtAMnH/MWaMhiuhkWN9OZGcsEz7T4GgSRJ+e3BMpFBt7VAu+XoAT8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hongfu Li <lihongfu@kylinos.cn>

Commit 25356081894d ("selftests/mm: protection_keys: use library code
for HugeTLB setup") replaced the exit() calls in the x86 version of
test_ptrace_modifies_pkru() with _exit(), but missed the aarch64
version, which still calls exit() from the tracee.

When the test runs as root, hugepage_save_settings() registers
hugepage_restore_settings_atexit() with atexit(). The tracee inherits
the atexit list across fork(), so its exit() runs
hugepage_restore_settings_atexit() in the child. That handler calls
hugetlb_restore_settings(), which writes nr_hugepages back to the saved
original value while the test is still running. If the saved original
value is 0 (or otherwise leaves fewer than the two free huge pages
needed by the next allocation), subsequent iterations fail in
malloc_pkey_hugetlb() when mmap(MAP_HUGETLB) returns MAP_FAILED.

Use _exit() in the aarch64 tracee as well, matching x86.

This was found by code inspection with AI assistance. No POE-capable
arm64 hardware was available, so test_ptrace_modifies_pkru() was not
runtime-tested; the change has only been compile-tested with an arm64
cross-compiler.

Fixes: 25356081894d ("selftests/mm: protection_keys: use library code for HugeTLB setup")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/mm/protection_keys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index 5dece144ab95..a0f51be3fcbc 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -1530,11 +1530,11 @@ static void test_ptrace_modifies_pkru(int *ptr, u16 pkey)
 		 * checking
 		 */
 		if (__read_pkey_reg() != new_pkey)
-			exit(1);
+			_exit(1);
 
 		raise(SIGSTOP);
 
-		exit(0);
+		_exit(0);
 	}
 
 	pkey_assert(child == waitpid(child, &status, 0));

---
base-commit: 2c5dafa7f289d760f4492260b0988029aab478b0
change-id: 20261109-for-pkey-exit-0f96fd62c6bd

Best regards,
--  
Hongfu Li <lihongfu@kylinos.cn>


