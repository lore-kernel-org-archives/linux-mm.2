Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58359C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A34876B0092; Tue,  8 Sep 2026 08:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C346B0093; Tue,  8 Sep 2026 08:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AD976B0095; Tue,  8 Sep 2026 08:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7436B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:51:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED3C08062C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:15 +0000 (UTC)
X-FDA: 85190580510.09.384EDDB
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf04.hostedemail.com (Postfix) with ESMTP id 054CD40008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="X ilEwzk";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=oY79WO9f;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/2nWSyfEPgqLKOnGOcfwH34Ldvg/Kp9mnGqErks5ETo=;
	b=Pm7uNAE38akmBJ2u5haZGOT5LtOf1vJID3ybmqgO8MbaYzbcPEdck/0fKOmcxKKLjCm4iQ
	+Rbb4/LJbLznpHHvrsCN8XFuzxZSijoxP9qZBHCXHJCWuK2rJwKi2CtFsHkP2JeKuMQdDb
	X0oQNNF/50bKObSTIZdMpfk/rbrVIzc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="X ilEwzk";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=oY79WO9f;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871874;
	b=4T4FA1GJfR2zFkl4ADGWlvhhg0kCf/6GjcOqvaibcJId2IM4Q0czLP0Cpm8E44YirxHSxU
	flvCECzaeg3CKeSL1wj1weGOE3rfRO9N1Kyy1gsAqkSnTHfxzk5tzuCjVOOJJFvOTkcAqE
	/hld9hvzVIfP8zVaGKfv1qkOEWf+XXE=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 721171400094;
	Tue,  8 Sep 2026 08:51:13 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 08 Sep 2026 08:51:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788871873; x=
	1788958273; bh=/2nWSyfEPgqLKOnGOcfwH34Ldvg/Kp9mnGqErks5ETo=; b=X
	ilEwzkrENEYRRFEyV+yAMTVlvO5TJcVt3cA7Dcgm+5cdJ7QH1KYpP8D3YSinGoJG
	7lvBxkmqAIBBaQeUxmZUvbe0fICSpxy+d3QaNl+LjvWk1tFgkA3Ugy5z5oZKPzN+
	eu22wtnRyk5raXQCNmpvMUEq2gXXhTGLYZx/kMr78vW3Nsq8eNvkQV6vnN1iNl90
	vqdOq9XF4csvyhqOha0q6UaXt39Y7G5QNoC8bXLEq6WOn8gz7hsZR4SpsqpiqJTG
	ZMmTdGg3uZ7Z5ejmvOFsxr4ZOX1w/U00etABfWs08R16yyxDCP6VbdTfHZommU8b
	g+6yVhwkUuDOcLKJGc4+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788871873; x=1788958273; bh=/
	2nWSyfEPgqLKOnGOcfwH34Ldvg/Kp9mnGqErks5ETo=; b=oY79WO9fYBxdhDPXM
	lqRGhDi+Eb6yrjOT7un9vCsorGIgOWBhWxNlaBkoYg1J5V1t1XIDXCh1sgylApz+
	TwMhy/3eC4+aaqOZSbzof9z9id4hCBm3ALZhRzFgbGJjbrsB9HDubf5VDVXuclFp
	jDjn1sgtVZvpgVNpSTH6ESwF7FX85duFLII97Xw57S5rMV/I3ubtCJRY9W86dTL+
	InTmDyiRPqCyYOTGzXi5I3VhpDqSDlNi1p1wK/RZz8Is0qyvRVe9KgOqJhpttKaY
	JccXz2IRXPKMkzHwesW9a1nygc8b4eR0QfMYVqjDYf6IFcdNcdkFCZ6W7W4LQd0U
	THpGA==
X-ME-Sender: <xms:wQSgapWSw8DrwLpRzH1zNuU5rwq_h8sfrTqoQhs12WShupKlPvGB2A>
    <xme:wQSgah_gl4q6zkQM2VgWbC_v8gM3V708tXt0jsC490SxpFrNMqs_23Rcq1Htfrklr
    kgRxAK0D0oD6nYiAbewKFnzSt-aW5IHanRe-ZTTsIrBIYGrauhwQtew>
X-ME-Received: <xmr:wQSganmfXh8acn4sSNAZM7p4zQD00nMEeEeJX7f0OZ9GFddolUiETJ8PR40>
X-ME-Proxy-Cause: dmFkZTFCT83ts3xpHDuUgDdlzQtELcoAknrXBpsFepmdcEBLccwduWOOVyAuau0VlYvm49
    objBvbnGefvuHsKXiB+MOl7qErn3M4/Q7Z72R+asBFni+WG6jRYqPjjJBv1F7ovmfnEZp3
    uEJcbLADGcdxsWcYxdWct2wwV9KQaoOTpGWM7Il7/oKOILrVOp7MvqHbWAXdA0mgRBniUZ
    2M+Su4Zoe9zFbzekNirjNltohahTSfzaLbYZTkGXD/hRQ+ajqkABo2HdEn2GJrc7g0w4Iu
    PhTUexE0AKZ4j2dsA7W9i19VnbZvZZgTTujH64lpg2nDW6KlKK63jDlRsrLETwVfJ8WCO+
    yqPrlGo5qSZVhvzFOYFDGlQGrBJXzBqOW0CtEletXHyDAFOEoq/L4autahk7kMXlbsrpZ1
    3YAvhSI0WXx9ywTvFb05cwzMsIl4IRUM9UEv/dq3Y46Xi1E/H0f9T1c1V9L8gScb78+3yf
    BuduosL+mHDfRlXi0kEOESFJsqKsWW/6ztI20LWRcOJENWpgXFYTnlSPe/2pFE3zhrqZRW
    I8Py5/kG+hpBYvnEkU9HxyIHSmeTPaGK0WXoHxN7RDIZD5Ko7Z4jP762+iNwb1yC9hdU++
    t2qTrkDVR9PqYCTILPaNI2uFh0Ky5fg5SpypVF+t77k1iAB5J+aUM7MfDslg
X-ME-Proxy: <xmx:wQSgakLOekEpv3AfLFoXmk-aR3swZHqDGD2B5ds9bEd-CIWegb85kw>
    <xmx:wQSgalqHQuGfEet1D3CBXkqKH4jQWrgL4Kz0_St50Uc86KpHvX9CPA>
    <xmx:wQSgapTc9cW4mN7ZkAezdCiFW1Dk2QCAfMoltccbUKHLK5aI9Gdrlg>
    <xmx:wQSgag6NPYJWfYV8EFllnbhw20ykLAo38RkKA8bEmz6UGJd_xKjOLg>
    <xmx:wQSgamKfgJW3t0KLSnUDT0DZL1kiVgYaLRLhizYrR6r5vtBP4SxG6fkw>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 08:51:12 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	usama.anjum@arm.com,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ziy@nvidia.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	agordeev@linux.ibm.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 01/19] selftests/mm: raise the khugepaged test-case cap
Date: Tue,  8 Sep 2026 13:50:47 +0100
Message-ID: <20260908125105.1510704-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908125105.1510704-1-kirill@shutemov.name>
References: <20260908125105.1510704-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fn1ss48f9ba3639k1p9xomt993gweekt
X-Rspamd-Queue-Id: 054CD40008
X-Rspamd-Server: rspam07
X-HE-Tag: 1788871873-701400
X-HE-Meta: U2FsdGVkX19J4Wr8Ac6BOU7asFe5Wo0a8rVzatCVKhtEehR5H8NKgLtT9YNjWkZvq6BFD5hpfLcMg/w+3L7ZTEJwZbh8q+JPgfmvnObU7dqML2de+adkhWFocUJHwer5dzeLCg+B/qTYIApO8zsWYALsjqU8mUKR19asEkFORBw7bITYXJ8zFKYCQvG66Qy1lSa/p2XTZDQRxp4nEz2CG5eIKsxUn+irjg+y9NA6FJ+Vn52GlopY0wiGze0UI3Herm+0cSys6gqR4Hgqq1wOUcNYTFiwfa1z5/UuA17CvpsczMhfO644DK9KmUQp21OgNYxcOi2MLfvfDFpiuG6b77SjSAG8O9Iv2t9zhBRe4PjaFaQzRisLrZPTFGu4h6ZUqukCh5xoodhaOZXqwsVG4ky/em77OEzHaehhfmKap4DyHbx3gnJlw5+pRsDwWugQyEuENDxI7XXiwXesTFJpTB798gjr9lMnsqFaQL9PUvzxexuAVjbY2Ofh3Q8xh3BOkDUj+7xHHymkisKqLITEvW+LMhX73dIYRU5M2n6YyoCPEaeTFEEMwePBKX1gug5wWg23y608GNbwUOowQwWVIwKHeY0f2iwLhZc8dBTXtLj8KD7VPGxsI6AeObUt3lumrMgJeZ4+d0Ux0DF11KhphBBDtAsnAXp4TTx4pmr/K9djobbovzsSELm8P0A+ZdKnE7jeXoNWlY0x3S/yukhSYfP2CU4zPiqLQOwOAtr1vOYhT8tNl7APG4hAiZGGqUCGqelaNPeuIuLtUoxYHfoc5irYazjCsv5obd7Xgdh9Y+r7xafRRa1eStoDy5A/INbmJ13Of5l8wKHr5nAs4KPFm6qAjHsqHvV05SykdV40QHfrnRpoQwYu9ZFgIklNXk/dShCxvG7loS/UG9J76aWPQtYTPB+ABiDcvuSgcYrnIfYk20ZNSbm5DjDAhZ47/8SNLaJ2TDbnWyKfCjQtF6r
 wvUTmUrh
 grfU9bXykVXriU74I8OGOMx67+eAvqfZSkVqOYsXG5H0hajr5J6rBXgQrkQw0vNWpIDWD81KZyiYis1kCmVF+iPHFuA13j1M8dEGmDS1kt18sWLYHyV+VWW28/0C+tlPmwazgKDyC1xUfNHHrNARwxNUhY4460kdW21CHaEE7kQ49rVNirb6Zdz9V6k+dh4nLrbLAkJmFpdOvP1WZ49+8wzPslWEwG/aHgbtcdJf9o4MAxqSzm1hD6uyrylSYWvW0FwSOO+Oth8DtBBn0YZRn3UfHfDY2UWLcrbFS8/GYXHNd8OZ6FHTKRwU8RmfQsYliVFRV5MiRx/cpLt2ac6i9tNRH6Z4jylQG5lJ2cGlYPOAHX5TYsVMIhS/AnzV/VZ41a1Gjhke+VRBTdwjnnbXSCcR3mjmArrfEf9HWPMkcsTX5n9TkboHw9f7bRWXHnL/fbF1FdpKCkh1223BSOk2Io1mFumBwC8+EmV/N8kd8Wbqj+sM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

TEST() ends the run with "MAX_TEST_CASES is too small" when the table
fills, and the table holds 64.  A full invocation already registers 63, so
the next case added anywhere aborts the whole suite before a single test
runs.

Raise the cap to 256.  The table is a static array of small structs, so the
room costs nothing worth counting.

Assisted-by: LLM
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index f82673f5f6b4..e57016bd96fb 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1285,7 +1285,7 @@ struct test_case {
 	test_fn fn;
 };
 
-#define MAX_TEST_CASES 64
+#define MAX_TEST_CASES 256
 static struct test_case test_cases[MAX_TEST_CASES];
 static int nr_test_cases;
 
-- 
2.54.0


