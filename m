Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0721606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 08:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Jski2Vet
Received: by kanga.kvack.org (Postfix)
	id E91566B05B5; Wed, 18 Nov 2026 03:12:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1A5B6B05B6; Wed, 18 Nov 2026 03:12:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2FEF6B05B7; Wed, 18 Nov 2026 03:12:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AAA646B05B5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:12:14 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 275B31205C0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:12:14 +0000 (UTC)
X-FDA: 85447522188.29.713227D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 67935180004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:12:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Jski2Vet;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794989532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jA+oDJSVCbC1D4MaARjc1w8poFChMuVZsc8cn6/jQ0=;
	b=7bc4EBjrxGk8SoVljY0o/NCzD/KKkSlEMEIxAIRWIqbypVoW9NcXXw3YXp7SCj5U2uWvPb
	yyrujraAw7XVwQH6h0azynhM5MV2M3EUwMz9QiDYvVh8juSBkJsBsJyg+FAJHEAjp/heEJ
	TCvA3KjSGLM11UcGJ7f5VF6Db5Mj+OU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794989532;
	b=7GoGqp43ML8pL62arTxygHlQV48dy91ppAkMlKhHifib03jhcYRPQNpwuBZm8HgRtuJnSv
	XlFQSMHhBurktvTyg/TsC70q9EN8Li1D4QRKqUEy8yIwO2GUWA2oZKea/7ne4FH5iiHfYt
	VNKIGws7yXDKh9U5dp5sOMut9ODOjZ0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Jski2Vet;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A41961F6E;
	Wed, 18 Nov 2026 08:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D041F000C6;
	Wed, 18 Nov 2026 08:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794989531;
	bh=/jA+oDJSVCbC1D4MaARjc1w8poFChMuVZsc8cn6/jQ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Jski2Vetfb3GPph7EA2pyQWzTuAe3AfpSXVb3sYMOMfmAIp12Tx2RaYWgcJx0DUjh
	 bB/RZzhuHlnf0nxPso1pZ2GuJBFa+bJ25OXtTyStnzkIn3DBXDAtEGfMhy9Cx/dXel
	 u+CREOLcs1EtGTN9F0qbSA32aXVuunQ2U+nWNDBA=
Date: Wed, 18 Nov 2026 00:12:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: cxg <evers_chen@163.com>
Cc: sashiko-reviews@lists.linux.dev, david@kernel.org, shuah@kernel.org,
 ljs@kernel.org, linux-mm@kvack.org, Xionggui Chen
 <chenxionggui@lanxincomputing.com>
Subject: Re: [PATCH v2] selftests/mm: handle implicit read permissions in
 madv_populate
Message-Id: <20261118001210.582cf89e7479c9786e726486@linux-foundation.org>
In-Reply-To: <138084c8-e177-42fb-b37d-7e8342ef309c@163.com>
References: <20261112031811.56500-1-evers_chen@163.com>
	<20261117070606.3752-1-evers_chen@163.com>
	<sashiko-outbox-220290@kernel.org>
	<138084c8-e177-42fb-b37d-7e8342ef309c@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: px7yfgy9fd8z95jz69rsy4syypy8yzjm
X-Rspam-User: 
X-Rspamd-Queue-Id: 67935180004
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794989532-42085
X-HE-Meta: U2FsdGVkX1+em9G9C9MwplV01RAlqPljhrI4khWiDjRZqHbQTADIOlXRFZSojXDrwcomi3sfVDQZgm7Kb+Gmh6V2ZDcxdMLRDZvFfbQhpYEN28gmWX6u4uYSSvMaYgHYIntyyhq6UnYnY53RUK/286ibgce/olcZISkG3m9b7/Qwrc/sXm661ipuwMjsRa0Ucfcd1nmiL2dwg5kFqoPqdNeqtxyjfQMq7fMdGsAlPk7xn/kRNrazAkmNS5QEx8/rlrLHCaMRuSg2RPQwm23bpeD9WWHGQFYepJ/biobryEQViO/N3GdSrKsTZNgG/qKRrN+xOUiZVvUB0Ea2j440/VKKwlPtF6hUGPaGQt5D+o3thK4Jiz6ZpSheCFllUv2lYsEx1SONsSmXNoWTfq4uXssv5BVTMqpclgUDCJDDviqBilu3rSyvQoF/8rTJmJxO9CxOda9QIfxBEAIO8OLSorLKt5b02IVTlPU5eYxZL9bn33U4Dhcw2+/c2kJAN0mfnEHX1U29Dc7TOpMF5P5cb4gOspcoFrAbTHrgDapqvxYgEIuWzGRnqnB+NL2twe5dGX8Wyemg1m6uFeans3tFTfeBKe81BssZcpYylbe07J9iHG97DJLpCQNPYrWW00y2+6/HAug5M5T5brQcY4skLG4BHURDwdr4riqVnJ/7dWGkvWSYTQMoRjcDNkwsxk0wKTCkljf0ui0E44O9Csmjt8ZlD1YXr/OH/lDgBOUp0IXy8LL7kM1RqBH1ZcQPMklvJ2z6all4TXtSeT7ZUcQPnYs71G9/QNf4xPsoPh4pWQ3A87427NEOUTkU0NcNDlPYUM7gHo2YaMGQn2VPSWm2s0SNkSRNWCw7OHbZgPVq5MnKQrGccYxkn7sLD+0tXDDgmTx7pq5fjIQIPv+mLVZEM3kx9M9EYd5srmDtCbe3MjDqEW+Y5Wp+rCvj87s03jdMA/1t5gkymYiGfVRDqPH
 dznEGiz7
 Gp75JViUgmlvrSjCohYko/iTsS6ViYRl8/yBBzHrFF1cQu7f+krNHpwDPlc3Tl+d7RyoKb5LxpvoEHmvkjuwYNJYd8quOauwNGkZ0EtLos2VXF9oe9+o35/1EIZpksuGdf/AMPaFa5mqOpHR3Q2PHfx0/7Ple4Q/G0vOK8XpllXzVHlOxWPHS8IHRF7qzEmxbkOR7nLNJV3BJHJs7Z9x3UsAwxWuS06g8L2pei7ZcUl4SAiAfbh3NxC7ZGbqhXGEj1WsduBPfoLc3crp3yvCBHNmfSPxrC3wigqTswzuEjfAIbS5xTub4MhdhZQNRkh+AIBAo3rcOGzHpGGHFw3NFPW4TCpD4nm54Ih9wDf9Ge4I6Sr6M6wAYUNjEH1iZXOEAzKwljfQlyMhbalzlQnvPVJiqaZ44a89DR2sCFy6VhLqVrFE5a1y8RcxKwDs4eQcONawCFGSvdqZ2g54=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 18 Nov 2026 16:03:38 +0800 cxg <evers_chen@163.com> wrote:

> I noticed that the Fixes tag in the patch currently in mm-new points to 
> the original selftest commit.
> 
> Since the test failure was introduced by the RISC-V VMA permission 
> change, the Fixes tag should instead be:
> 
> Fixes: 6c7559f22b6f ("riscv/mm: ensure PROT_WRITE leads to VM_READ | 
> VM_WRITE")
> 
> Could you please update the Fixes tag in mm-new?

No probs.


From: Xionggui Chen <chenxionggui@lanxincomputing.com>
Subject: selftests/mm: handle implicit read permissions in madv_populate
Date: Tue, 17 Nov 2026 07:06:06 +0000

The madv_populate selftest assumes that mmap(PROT_WRITE) creates a VMA
without VM_READ and expects MADV_POPULATE_READ to fail with EINVAL.

On RISC-V, commit 6c7559f22b6f ("riscv/mm: ensure PROT_WRITE leads to
VM_READ | VM_WRITE") makes the kernel set VM_READ for mappings requested
with PROT_WRITE.  MADV_POPULATE_READ checks this VMA permission, so it
succeeds and the test fails incorrectly.

Adjust the expected result for RISC-V using an architecture-specific
conditional, while preserving the existing behavior on other
architectures.

On RISC-V with Linux 7.2.0, the original test fails 1 out of 16 tests,
while the updated test passes all 16 tests.

Link: https://lore.kernel.org/20261117070606.3752-1-evers_chen@163.com
Link: https://lore.kernel.org/20261112031811.56500-1-evers_chen@163.com
Fixes: 6c7559f22b6f ("riscv/mm: ensure PROT_WRITE leads to VM_READ | VM_WRITE")
Signed-off-by: Xionggui Chen <chenxionggui@lanxincomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>

 tools/testing/selftests/mm/madv_populate.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/mm/madv_populate.c~selftests-mm-handle-implicit-read-permissions-in-madv_populate
+++ a/tools/testing/selftests/mm/madv_populate.c
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
_


