Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E92FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 13:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85E426B00AF; Tue, 30 Jun 2026 09:03:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836676B00B1; Tue, 30 Jun 2026 09:03:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7258A6B00B2; Tue, 30 Jun 2026 09:03:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F06D6B00AF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:03:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E08F4A04DD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:03:13 +0000 (UTC)
X-FDA: 84936594666.12.C013D79
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf31.hostedemail.com (Postfix) with ESMTP id 10EFA20006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:03:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Rlx1uRfb;
	spf=pass (imf31.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782824592;
	b=t7B/NjTydctMz8s1Q0XQfOolPqqVH4C59I0oyQSztcGifTpEEt4J1MWvbvwzHrSMm6IDLb
	X90KrUvsebR/by3vbRIfPW8BlgTk2KnQH8kDhkduj+lC0IogIFFUjL5W7R1lHhKvHwfliX
	ZHz4TIRwpRLA/UMuWz1RT4XzFr7mjLU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782824592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3gdtD0uSCiAIlNZn+1RTzu5l2zkwsL/Gs7YEvXjMsVg=;
	b=Trq94IwoSR8xWg87+K0mnDhj5280eOp8i8U3fVKtOErTftGueJZX9hl8A42IFgG7rfTEN1
	A5DXx6nxMzJ6iafgPu1KVkTwf3bR7FHJB/U95dlHXaQMSSp36ewNWSGwav81eN8LPG9y3W
	5aH9bSsAg68+qEIysJlQK26WcGJogCM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Rlx1uRfb;
	spf=pass (imf31.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-39b26e2ad5eso3078421fa.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782824591; x=1783429391; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3gdtD0uSCiAIlNZn+1RTzu5l2zkwsL/Gs7YEvXjMsVg=;
        b=Rlx1uRfbkVozyEv/E6ujXuWrNmF+Bj0e3X0ySHH/T1+nWpel8X/OBHrRKpseAbYfN2
         3yOO319L0IropKip/PAIrvJk1H1pQ/esE4A5YmwRUkwyLfEtq2Iv8X1CYbENE5detkF/
         pLtmkjqyXwoPjXMvFzya2+CvJJOgelPnbJ764OasaqjqxMd2pgYtvwgdx7xtv3Put1lm
         BYWJ8HpPzcfjBRvM//y0hgUjFrqUKeLUm67EHL3zU3W4+tY3WKzT0zegTVSgZPuBRDBd
         79TVkfZ0NMM849n1FFVrl5UQfLVJFw90kxfOktt5cv33V5UTglbDzeJPeUXxgH+R6t8D
         w/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782824591; x=1783429391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3gdtD0uSCiAIlNZn+1RTzu5l2zkwsL/Gs7YEvXjMsVg=;
        b=oi/cdJY9/t4DfDHNPyTNy5uNgSS4GZ0crbvxhkuI+NRQfIcr7MuxhZMbM1Jp5sbK4K
         u7nKxFtgmlqYy7kq7vGHN0FYsA2dv5Vv9m3ajFKqnellSRNoerTt9RuWFKwyCnC/zIYg
         micqznjlshhKe1584D6weBwd5Md84kox2RhXhVmQo2B5+P/9hVq5BaXUAelG3S5/wg74
         I5Up9tiwLejrQstAyXEbQUVapqyuIY8prYJ7YsKTGh8mhe8MS6gaBxN9rXpJ09fdFHG4
         KuvaAOtKz1naAcJBQRDpHGtnzp9MeX2ptlmhM1N7i0HfjXJ4ohRlwrTvdQkXonGZPBCR
         XJRg==
X-Forwarded-Encrypted: i=1; AHgh+RoTp0+MGmZ65O4UywQdBxB+iXMwOoLYB4buNRv+lOcgD7Q1OKTfGADsFSb/EKGvuYy9kmlE37dUJQ==@kvack.org
X-Gm-Message-State: AOJu0Yx9+PhiSnhrFvkn3bghaFxXiVADe4QPS0+VSnzlknKPH6K1f5+e
	Wh4Pa13eMjM4Kgc5+dqd8THcrEtqMTv9q0/QGX5LTbCpuS/HdGYq2XQB
X-Gm-Gg: AfdE7ckrr+oFvSAo8Mt5g/s77caTb0f9l57JUEpygEwNYSC1o0QYZh4srbvtvvuD3gQ
	/YBk+iZmS8+wMRL9sEYer3ZXfuweuA1mCDP2JNFzYBgqfEHZEUn5YPw7X0+oWLbtvBvxi/Ofi9f
	duFrZh5YiTpcjHgKusIxz3rGzxgz0MRnQ71e0jed4VQB3Umsnm9DrE2hiJoHs4i2cJQ1uE4X2dt
	80TvDuIsiounI3z9iLWYrJSOMqUbg9FS497rbWoUt6oGAXIL5Wk3f9VeSpFYmf8ZWo2NbnyegJt
	C+Zn4glv6JLrt9Kdysv04s3c460vGunufNv9DmDcpYPT3yeSqLxbue//5EnKEp6on7hYrjlxSP5
	aCvi3fWG1TFMkoJMHf3h4S/lKugd6ZGa2Br3xCqa4JACDmspsmGVPSlj9Aj1MIDfW26c88uKZ89
	tHUp8Dibv89yToxWXDKn24xJlEvQYABNCU4QOiEPySYJO7yd1vIuB76rSZu9r3sIXP6ExjPzl4z
	l431d8=
X-Received: by 2002:a2e:bd83:0:b0:39a:e29b:790d with SMTP id 38308e7fff4ca-39b1dffbb41mr8707321fa.36.1782824590328;
        Tue, 30 Jun 2026 06:03:10 -0700 (PDT)
Received: from debian.localdomain (95-25-158-125.broadband.corbina.ru. [95.25.158.125])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39b1da4d241sm5301431fa.32.2026.06.30.06.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 06:03:07 -0700 (PDT)
From: Igor Putko <igorpetindev@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Igor Putko <igorpetindev@gmail.com>
Subject: [PATCH v2] mm/damon/vaddr: remove redundant RCU lock
Date: Tue, 30 Jun 2026 16:02:53 +0300
Message-ID: <20260630130253.3843-1-igorpetindev@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629165349.4260-1-igorpetindev@gmail.com>
References: <20260629165349.4260-1-igorpetindev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 10EFA20006
X-Stat-Signature: ubm8w8zia4k31h1tkenhdu4conri1zxu
X-HE-Tag: 1782824591-876442
X-HE-Meta: U2FsdGVkX1/c8OqXCzAM10NvAhCTgOUbuzOOgE4VJkJRC1UmLdR9yDR/UL3ovy7BB+9Hml5qPgM+CVAvg9io4A1Br5E45jNyVwgBp8B6SzdRkqaUb1JzhCfmSPCMQvCt+FgKXFEQGMOu5Q515a+lIaiklPQbCENdS8ajF/vxGTlj188tGk7d1R2HJRUz2MKUlOX6O6uzBjfC2nnTfUDT7WPQYU+B3OtRP/Spx1RSqRpVbgOy5lloMjfcuP+WJqNssI+zW6MdN5cTsiAvORxe23Bnj5LXt024AEU3pX8UnUd+jEgq1H033KjbmCY7Z4SA6bEnuZhIPOuUMvem95PY8goD4nISsw9U/X6eixXGjnl4AyBFA+BSa6wVb6FRupWnRP3cpGXoSRASpr1ps0weqCtxquni7OEXS+HZoiqbC1DHGPNLz1we2GUuBUS3d+PQgnHJl7f/pFDi6th7hH966cbntvVjIeGvTpxZpjYN+epinR+Eg68WuXZiD8YmmVEpeYctynGeSc/kwBFWwj05vIkqNzB26D3VRdbk46XUSLsm7al11FMX2ReOssr2WXF4xVtR9Y3opGxJT27qYex9tuuMnKG79xlK29famcXEmIlD89pw39/0HJ5UwKwHnsfN5tNNRAJXUjoP/5judLScqSz+LKuE25MgqRvepWMI2gRP0XZ/PNGe4BEZRrlSIkCzxXop7ApC8LWWaX1UblpIFywIeQ7ZoqbD5eTc1jtKKCEAqDODTlWad6aSTPImXobAQl7sIPQ2rOgwNrooYacWxl90CskbT8+UGi81+pe/gz6xrWb3AQzhiuCz00Jeseu9cWnNByndKllfY2AyagkyIMe1/u4t9iv6z5yfR5DIo/i2WW7kILs2Y5xvukw3VSncKbJPzEcE6Qple2D7fk+vScWXxJWf7lsy1un9+7Mau2I6zh/2P/rw599l+Q5C0bqiYSh2SwlNltSBfsk2+Mz
 oe9S21d5
 //rua7oeuTBYf/E85u2owFhIa5ADX1sRVeV0WlGEJrM4pr3+sRKf4wjsjkmV1i2itkqXjEUE00QQrFvhSJb55+5eC9tBSe+sW9ayQF+6p3OY+QmV3S31XV0g1rkP7s9pSVTfll25XkSN6H5qDqR3p7zOHDfQAVVIPxHKE/Imcp5whss5PtcKzR/TJhL6IbEGoYTPUZhJlWk4+h1UfWf9BT5tTV2CkOQJdqcLyln+St7bOToO+V89ir5Ol84R/1GCx7EO0Y8D4rhpwkQp21ad6Pfwx2JE90lDqCxEdsVf0LLFYb5XiQUdWvvgZZRDnLhdkvJZ+10YZpUBS4HkS01QlVjlI02bsOBx3PgzhDip3goyVHsMu/c3TV1jwalSWbwB3gC+nP/uyyU7+gLhHcbTCIhOV7lRkReMMnIsH8HPmBmrpR89WJY1To3x0Tt+J7yFkc1fnscskDzmuCAQtDi+KRe+egQ8cme7i38kny45WSvpI7t4TURKC2prG5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__damon_va_three_regions() is called only by damon_va_three_regions(),
which already holds mmap_read_lock(). Since mmap_read_lock() is held,
the maple tree and VMA list are protected from concurrent changes.
Remove the unnecessary rcu_read_lock() and rcu_read_unlock() calls.

Signed-off-by: Igor Putko <igorpetindev@gmail.com>
---
 mm/damon/tests/vaddr-kunit.h | 2 ++
 mm/damon/vaddr.c             | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/tests/vaddr-kunit.h b/mm/damon/tests/vaddr-kunit.h
index 563fbc7e3..70cb7825e 100644
--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -81,7 +81,9 @@ static void damon_test_three_regions_in_vmas(struct kunit *test)
 	if (__link_vmas(&mm.mm_mt, vmas, ARRAY_SIZE(vmas)))
 		kunit_skip(test, "Failed to create VMA tree");
 
+	rcu_read_lock();
 	__damon_va_three_regions(&mm, regions);
+	rcu_read_unlock();
 
 	KUNIT_EXPECT_EQ(test, 10ul, regions[0].start);
 	KUNIT_EXPECT_EQ(test, 25ul, regions[0].end);
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d27147603..345b89b5d 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -84,7 +84,6 @@ static int __damon_va_three_regions(struct mm_struct *mm,
 	 * If this is too slow, it can be optimised to examine the maple
 	 * tree gaps.
 	 */
-	rcu_read_lock();
 	for_each_vma(vmi, vma) {
 		unsigned long gap;
 
@@ -105,7 +104,6 @@ static int __damon_va_three_regions(struct mm_struct *mm,
 next:
 		prev = vma;
 	}
-	rcu_read_unlock();
 
 	if (!sz_range(&second_gap) || !sz_range(&first_gap))
 		return -EINVAL;
-- 
2.47.3


