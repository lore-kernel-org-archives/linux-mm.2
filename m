Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E73D606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=igojmmmq
Received: by kanga.kvack.org (Postfix)
	id 4DC316B05B7; Mon, 23 Nov 2026 10:09:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465626B05BB; Mon, 23 Nov 2026 10:09:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 353D26B05BD; Mon, 23 Nov 2026 10:09:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 096BA6B05B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:09:41 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 502B71208EF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:09:41 +0000 (UTC)
X-FDA: 85466718162.14.65AC0B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id AA0E11C0006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:09:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=igojmmmq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446579;
	b=mutEgkIJAqc/JmpxXMPWSRZ4Yy1N+0kBAwx4d3LrkJVsTjGEEiS6t/EBdlPQBdYQ9K0/pJ
	k5g6MQprLrtYFKSemyqdy6GevHUVhou6eTgNrj6rD6e/IwWp05vYySGhDbkVH3I6AEsbEU
	LksczTKWKnyOOgHtrQYA4EYICmFYT/c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvNRDUyY4oO3hgxHO0NuPWRfpq8PhLEVlUsznirVsBU=;
	b=MwRG5M1FDrbdsVrU6tebwrwJVucc1Gc3cLFSc9MHs5yW+ekKLg6BwNwveCT/vMFRpDGdf6
	4CuIiyNoynR3CiQlONc8WoH4P4+SZNVUWdrGgwqVYJCO+2Ubc49iHfmha96kFCWAFosXyI
	30XK6S0/3DMU4Fc6JHY208lVHTIY2Yg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=igojmmmq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 933E34352C;
	Mon, 23 Nov 2026 15:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE731F000CF;
	Mon, 23 Nov 2026 15:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446578;
	bh=FvNRDUyY4oO3hgxHO0NuPWRfpq8PhLEVlUsznirVsBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=igojmmmqLSK4uknxnz9CWxYOD2/nqn3UbLPVeuFZMvvtgpPnggm+tjZDag18KPL9E
	 BVQrtpmc1nXy06HnG7Tr+kSmuc5JlSgP8fa5ChlWKoSCz7bRekAQaBFg2Z92yDWk+t
	 Ss4Ewl0XH8qwmJz3l2fWvwwlmuV7m51jPsNzIwYbU9jtj6ixspcd+3W0BMs1FsPoF/
	 BrGf+UIbm9lWqt36eBgJnQOgeyM1RYNMh4Nr5KlkSI8vIGgEfjtfryDm0hXiVlyYgk
	 Sa/UREsHlb4s6KKpT6EbTGmPRVFwByUM0MijJUwxhB5hnJAmVdYkaFfQnTUUo6e4Hm
	 1VQ4+BdCKM3xw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Angelov <jasonangelov@ucla.edu>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH v3 1/3] mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS in damos_test_commit_filter()
Date: Mon, 23 Nov 2026 07:09:25 -0800
Message-ID: <20261123150929.81797-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123150929.81797-1-sj@kernel.org>
References: <20261123150929.81797-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: e6qc9j1is6p4bncidkgnksxyj3u86t8h
X-Rspamd-Queue-Id: AA0E11C0006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795446579-186881
X-HE-Meta: U2FsdGVkX18iKwma92tK7wo3MPr/8qXZzOsfmaNxrpDs3z4WVFzKDyAFu1ofDqCP9Jq7iUdyWM652inFBvC+c4JzgXbTAcVK8VhP9e5ZRrAUAkv5ArOebW/myul2P9Z/5X5PwG/01dlq4Vd0AW57d7Z7OJzJd6wQq5Bg3nuiT+Gd9v85Qf88JZpxr5+qIOrT/94S59sfF0kQu5GzcRDAnzNyskG7wD4sMqT7boJ04/yWUeDgjbvENkhUDLrcqDrT6sAKYtZ43ldq5iKXnPnGYwgVDhfydyxabvvHez0sOFgSD5ND8zMLVRS0ZX8cefcXADgdr67wJ/5Ykn+v/obenYoBVfxjzrmfuUWtExHMfm0w6efSNy8lThRIkUVMVKorrrkye2tnFpmYIIUGTSnXwhD91i9NI+iJ0bfH1duVOrZVuhPXHfkhGnIUHCMkRF4Q8efHUQsFVrW/u7GWOvthBGd7uNBquNUYa5DNS1CTOhTeoW+sZn+gwZAmr4dgjQiQuePiH5zlaPDYC25FR9oLDFsYLDm8MumJO0/0CDBpAvdEyd7KthNLEEkrQHwSInorWlCv7xLyFpiTer/yUiMc1FoJHcPhF7ziitXZXYYKForvQuHzmkCMtY4kKxNB7Vktv795/btHjhetygWWX4V58R5uXiWtGKgHRLYILehoYHhG1ZQIbJndNO47Bex3P64YcFnJpLMJ9OgwpxjlO7XKKoBA5RhU9dXapb2peW+dAW+B+Fql9QwOuNI5tRiEg+h7lezFxbhPPZkvfHkhTYRR+YaBZ7el9c9RQTRxa0hkPT8xuMm7oXDlW/S0KM2twuHrxhn9sYxkTU1mSVejxXz8cA/eLeP2crAx9RfGFZVkcl9TJ4dOVI7QUnRC2j+cX5NBqa7OY0f80sidPDUzSBkuN2fhu0Ks/VxqT5gEBBLMY1fjPqTqOlBsKOroBAegJow+SfWjqPXRREHc4rYUWYj
 BkaC4jsj
 obrr4e/jzw41eX6+FdUkyjwUsrGjxZ3EyWuihyPgh9dPgP9Dq/tH1WDmzJfjg9t6y8wWGdG8pmFUnL+taVkJYckbO54B9ecMGja87QEyKMECOZ9/RnSMnksfcm44duH71E49YtZoAu6kVvihDTndXx6HklftiVYgFw8qoeukn4uRcugHzu/27FLhs9qzJ15MAB1QOWzXJxYbxbSMF/pRKe94fd080lZRrrRL/Set3k6E0BhJCyZvl9+VjAvAdQJkK8AmIXrLR+hYjJSRbU7sRiqrjHLLWp6FD+mHtnpgO86xx+5k0pGFmJ9PBlE4N0RN1a3lbrMz9v3egl4f88i71t5yPIpvfZW0jrrBhoSngrjQhwlohK9zVLq/OT5hPUAtKVw3eDrHuO4P7yw8TKFKX0/qHmbfJkCm3tWydtxe9buXqgzShuoN21o37VUGhTvKpdy802mV7RLKm2bNZBg+wyvC8uWGbZVgYOpP0MchKupxQccoSphymVdJv6xkI/95pYFgtUqKwUu97bgxcgk7ORyIj/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Jason Angelov <jasonangelov@ucla.edu>

Add kunit tests that commit DAMOS core filter type
DAMOS_FILTER_TYPE_AGE_MS.

Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index a5ca4bfe2f0db..0eb5dcdba0ae9 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1271,6 +1271,10 @@ static void damos_test_commit_filter_for(struct kunit *test,
 	KUNIT_EXPECT_EQ(test, dst->matching, src->matching);
 	KUNIT_EXPECT_EQ(test, dst->allow, src->allow);
 	switch (src->type) {
+	case DAMOS_FILTER_TYPE_AGE_MS:
+		KUNIT_EXPECT_EQ(test, dst->range_min, src->range_min);
+		KUNIT_EXPECT_EQ(test, dst->range_max, src->range_max);
+		break;
 	case DAMOS_FILTER_TYPE_MEMCG:
 		KUNIT_EXPECT_EQ(test, dst->memcg_id, src->memcg_id);
 		break;
@@ -1304,6 +1308,22 @@ static void damos_test_commit_filter(struct kunit *test)
 		.allow = false,
 	};
 
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_AGE_MS,
+			.matching = true,
+			.allow = true,
+			.range_min = 36,
+			.range_max = 14
+			}, true);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_AGE_MS,
+			.matching = true,
+			.allow = true,
+			.range_min = 14,
+			.range_max = 36
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_ANON,
-- 
2.47.3

