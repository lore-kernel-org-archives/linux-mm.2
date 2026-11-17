Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F2F660A2612
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=pudUAiSd
Received: by kanga.kvack.org (Postfix)
	id 1B7096B05B9; Tue, 17 Nov 2026 02:06:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16ABC6B05BA; Tue, 17 Nov 2026 02:06:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02F386B05BC; Tue, 17 Nov 2026 02:06:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C37D36B05B9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:06:41 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25147140314
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:41 +0000 (UTC)
X-FDA: 85443728202.07.6E7E5F1
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf26.hostedemail.com (Postfix) with ESMTP id D701E140002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=pudUAiSd;
	spf=pass (imf26.hostedemail.com: domain of evers_chen@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=evers_chen@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899199;
	b=mb/adMMagIgC5tVz72HA92eqJHVE6DPazTQmYsLYFPDVwc3s7VSXWv1EbPkGRXI/yvRISR
	WDXwiahWQ5jYGzDOSZWZMSy2DzXZfge6i4A/TXFrqsSo8Iymqp1+41RUlRUorp5l7Q3TAH
	KDKy17uWDuW6tqx4YW2H49jgphaC0OU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=pudUAiSd;
	spf=pass (imf26.hostedemail.com: domain of evers_chen@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=evers_chen@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nACrQh/lUVEXvo7aMroISkZXlxFvhkHh8kUoWLWdwD8=;
	b=xhyhBQDlxctdT4MHkOZruTsIw3I10s4mUPqEXNL4lY7mAwcX1f9SDoQ64e5s8Zvfxl3vI6
	KKHEBxUP29B2zIFcAA6ArKDfwDYKIfQrUsBOTL/x7A7sNtJzGet1BuGtxnBSg+qxsiZNfG
	Kfwq9vj4hgDhis/lAQzFf0j3yAIKZkw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=nA
	CrQh/lUVEXvo7aMroISkZXlxFvhkHh8kUoWLWdwD8=; b=pudUAiSd5oX/OLw4ex
	VeoK60dUDySIAPvAu7d4Sy6ZUnsWfSmEmQtodQZNRB6rzdwaIazW8R2dsRJwkGJy
	ieb9xIqWPIB5RIjifpgZWww+nuTrNV6ArTbjTXfQXNqSkH/jUshagJbyclZj3dK5
	hpP260TcddnNlldDXJjcI0bmA=
Received: from 5219-2604 (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDn79ri_Ptqb6D_Hg--.51983S2;
	Tue, 17 Nov 2026 15:06:20 +0800 (CST)
From: Xionggui Chen <evers_chen@163.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	shuah@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xionggui Chen <chenxionggui@lanxincomputing.com>
Subject: [PATCH v2] selftests/mm: handle implicit read permissions in madv_populate
Date: Tue, 17 Nov 2026 07:06:06 +0000
Message-ID: <20261117070606.3752-1-evers_chen@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112031811.56500-1-evers_chen@163.com>
References: <20261112031811.56500-1-evers_chen@163.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDn79ri_Ptqb6D_Hg--.51983S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJrykWw1UXw4UKr17AFWrZrb_yoW8ZrWkpa
	48Jw1YvF4rJF17Aa97GF1xXrZY9Fn2yF48Zw1rWr9IvwnxKFy8Xr47KayjkryktFZ5X3Z5
	Zas8ur9Iva4DJFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j2_M3UUUUU=
X-CM-SenderInfo: xhyh22pbfkv0i6rwjhhfrp/xtbC7A4UHmr7-O7iJAAA3t
X-Rspam-User: 
X-Rspamd-Queue-Id: D701E140002
X-Stat-Signature: wsapzp8enjc78888mxgoxbfgg9jbk96j
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794899197-301212
X-HE-Meta: U2FsdGVkX19gfQecY6GqH5Ky7ATqdA8dNRqd7Yt9/nBxJ/6JuoU22WmjeLW4LQ4ntJ33e9OYJRYVsdjcmw7KE0Z+EoECbCzg/pdjzDQhi6Iq4N2yMU5dmPomz0Pye5R9zuwKU8sSFi/+UMenqVl/wQy10/A8BrEYuEZT3XzOUoEc37w9ymThBqsbqyO7G4yeBsEOyUpg5bKYcIrQCFeAh2YlYjBT5RE6oUaZ+DB+J/i/ZXs/Q5mUB/M4Tv8FKNiYqMoaR/TxMgTsF0qkXm8Pm80h07cvFVHShBl216yZ49WHeuf5r/4cOCF5xNHw7LHXOf5dIPocemG+n2vUtFz41z2SmqJBra5vx9VNBVoOkQzyglS0I4T2kB92WCSjW9luHgo4ZBEXN3elobme9Mw0dQsn2UzvdQ4Eia37LIFWQwqbhL7cokwdXJur9pkOh6alk3/roCm/VQDC+PWeUPZOup6G/rhLxyoF2AJZu3fh37+0AsN+LuoX3iaZHGVUzV79HYWzIiSwNwiZi+NSIsKPYKfzyodrmVL6OrUHjYlUYCwQwwLBxaN4wMCoRF83JSssUGgYR+S9sWDUOqshmZnZwL7QP74Gtc5IH8ChP4av1Js54eYotvduBV56kCdvP9Kwh+dN8pnt7qpZXsh124iMR91T0wc+d20+JrPbMWsaPHiJ6/jPWYV/vLGgKERmDxwYKe4caNQJCmwjD3xe75nHfL19ZdJZxeJnKVhODKjKUykbnAWciB9BobSAUL6ecPrkCAovHpAxhHQJbg7gdS1itlN1W4UCRLX4y6zyoI6V0SAJvSujM5aG0CyU1gg3SJ8PU9wOIqL53bwVySduJoIib3TfAkz1sBVfqJW2jGC8acvFfM1JO8kfCWruhSIcLhVggTRn+D9bhW4eghEWS11kuySFtACyyhE8TJCyWiP6LvBXZ3cjLQJRDQhtcOgOI16zfVjcIkSwB8Dhkv8w3rg
 4jNekBiD
 GxKqB0kbf625Rzt2tR9Wdq1hBvd95kAz+5mSHKvUiMxSrCYW7fnBNKJj3Uu2KAOBsriPxgvWbi13bHvwKnGX8k7FjWhAuTAT9vawU4HIjKMjJc/Rb4DCui2VlQBkhxlJjybcWGiE+U0SF5vMgUB1Wc4ysyOV4Is07S+GhlLpNoGcHkhluoxuNtj4bjqY8RF+U/+1Dj7LNAKBQEimDcg8fH9fnArgzWjBfwImrEzwoXvF07UTe3UDASAYPISVWWhoId/e8xKewrFJ5kjXVeBlTH4pRe8Isxx7X0E8rU0GG50oVlGXYwt9dkdxqyvuayf5Xcd525+ZC3MfDiZ0QOvoVAqEpurMSz+evBPBe9tB6Fk0am1BbvD7i5VRi7u3zDilo9JOzIKif5y+29FI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Xionggui Chen <chenxionggui@lanxincomputing.com>

The madv_populate selftest assumes that mmap(PROT_WRITE) creates a VMA
without VM_READ and expects MADV_POPULATE_READ to fail with EINVAL.

On RISC-V, commit 6c7559f22b6f ("riscv/mm: ensure PROT_WRITE leads to
VM_READ | VM_WRITE") makes the kernel set VM_READ for mappings requested
with PROT_WRITE. MADV_POPULATE_READ checks this VMA permission, so it
succeeds and the test fails incorrectly.

Adjust the expected result for RISC-V using an architecture-specific
conditional, while preserving the existing behavior on other
architectures.

On RISC-V with Linux 7.2.0, the original test fails 1 out of 16 tests,
while the updated test passes all 16 tests.

Link: https://lore.kernel.org/20261112031811.56500-1-evers_chen@163.com
Fixes: e5bfac53e310 ("selftests/vm: add test for MADV_POPULATE_(READ|WRITE)")
Signed-off-by: Xionggui Chen <chenxionggui@lanxincomputing.com>
---
Changes in v2:
- Use an architecture-specific conditional for RISC-V.
- Remove /proc/self/maps parsing.
- Remove the additional PROT_NONE test.

 tools/testing/selftests/mm/madv_populate.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/testing/selftests/mm/madv_populate.c
index 7fce5d0b622b..fa26ca2d8cf6 100644
--- a/tools/testing/selftests/mm/madv_populate.c
+++ b/tools/testing/selftests/mm/madv_populate.c
@@ -81,8 +81,13 @@ static void test_prot_write(void)
 		ksft_exit_fail_msg("mmap failed\n");
 
 	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
+#ifdef __riscv
+	ksft_test_result(ret == 0,
+			 "MADV_POPULATE_READ with PROT_WRITE\n");
+#else
 	ksft_test_result(ret == -1 && errno == EINVAL,
 			 "MADV_POPULATE_READ with PROT_WRITE\n");
+#endif
 
 	ret = madvise(addr, SIZE, MADV_POPULATE_WRITE);
 	ksft_test_result(!ret, "MADV_POPULATE_WRITE with PROT_WRITE\n");


