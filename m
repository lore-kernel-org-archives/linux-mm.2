Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83287C44512
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 00:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0195C6B00AD; Thu, 16 Jul 2026 20:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32FA6B00AE; Thu, 16 Jul 2026 20:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFA306B00AF; Thu, 16 Jul 2026 20:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 972856B00AD
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:30:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8FC1803AA
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:30:34 +0000 (UTC)
X-FDA: 84996387588.21.3D2418A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4F58D140011
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:30:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SHxLEGKU;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784248233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KyQzh9cAgWHiv+f51XfecFAFsLqN9MeOR+zzeRidaFs=;
	b=JxWM2zWkhOwjQuVtkRT8HnH8eyxgSMzBZreny2tk7qGMOzJ5VfuycNjwRvHdHk4Y+tP6sz
	HjLVtUXJJ4NLT2+9WmN47lL/Anv1IKLgiwwuknxO+jEwLsoqrX1GUPc40MmCrbtll0DNo7
	NN3JDHSrJ994CMek2rUdobXb67t3bas=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SHxLEGKU;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784248233;
	b=Vt15c9PPUUsJPVvZhP2MZ5j3Yh2etC4iEkMTmsDS+gWIPeGW6D7hQ6yhF90ZekxGD5ffVf
	HjevEizHm9Y6169Jk/T+L5/9IWNLtIuWqMXH0wG16xPjm3FTPGjvgi9rMDyqb1VxUnlNPD
	dWQkcwqXykaXBLXFCMs8jOT/VzZmwSQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3EDE60A5E;
	Fri, 17 Jul 2026 00:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF641F00A3A;
	Fri, 17 Jul 2026 00:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784248232;
	bh=KyQzh9cAgWHiv+f51XfecFAFsLqN9MeOR+zzeRidaFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SHxLEGKUEqPS/uTbTfuN0+qoZkrJv6a4zhRpq3omfyZC+J08m/+oglJROCBSlTPzj
	 GKfzXuVdY+UrmQ0QmzR+DcJ1sz88rBYUBXIRhoDmTzBz/lqVDQi70d5TENIWU5/qWA
	 wNqIyFi4BR0LKY3XxamQaNoR/KSHKrc+4Ms8ahKc5vkqBByi9J1sebsrFO9yLwwQWE
	 qp3OH09VIleBYy7kqp2GfgU+uw9f/j14TPaRWPY1yco9K/FETGTKjbhqrfkVg+V6Kk
	 1v/BWQhr3AkWothaxP5dv0O1hvWwDwFGT//y4AiT2iYwO42eWM0mVjDlIa+LdbxUWi
	 6Ks/fxHQlMIpg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/7] mm/damon/core-kunit: check region count before testing in split_at()
Date: Thu, 16 Jul 2026 17:30:16 -0700
Message-ID: <20260717003022.119437-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717003022.119437-1-sj@kernel.org>
References: <20260717003022.119437-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4F58D140011
X-Stat-Signature: 6q18zmsyaqjdiuuj8ed489eombtbmaus
X-HE-Tag: 1784248233-968331
X-HE-Meta: U2FsdGVkX1+H5ubDS5v4tIcpU5BC9cAlA0bmHdSX3Fw6N1rR/ofx/jTRp7h/dGFY3OzzX86BRLf0R3Kl8INLNTY99XxlyTHzVvAsxA2Z17Vhlxm60GR7opNGs2DCp3BwPSCDrnV6kW3n3KdGfJmLt0g8kZHgelqqWEgNEWUP1Wy7/HpHFz8tsCIpzw+UN6FgkbBYvxETJ5VYNoDzrG2Js6Bzm3uJGYvnQDK97rfroSseO2/jxilef9q2tDciNnsBq1bg86Ym6feKaEKYh3YI29DS2Ayfo+TgbTIb9AiKZvrpcLAgS/EhjGhimcWpuGtchKCq45fNzqmgaRaxejxwK76iL99Fc/c4vwC09LrbN1V92btacKGVL5HsKYQmFf+/sfM/NnJFcsoHCIl7SZXou7jkcH1imby/8/ejB7CS+l3JKX1J+9hCteCtVsIS6IpYhNilXvlwUigWgf3dPYTDdJrSx+n7EwjhUK/YHFrbyl9P6gotrE7f4I0ZH3OuEyDhsKObaqgyl1tX8MjKz94lI8ahZh/oyz8OhGG7Z/h9/rCAo/UYo7PlRlVPX0DWANtqG9JGwi6J9nyMv+dxpiaZ8ZCpkBgXaUCNgJffqILHdOGAb2wM5U/RdbUxe//wY/FhspsImRcR3B5vR12RCUP3EBK1WHX0icDkeCJ5Gsth91VXg41NPtY8RRp7AVI+2zi5cY6XJ7iKqXlTVhfE/KuUbD2In96jpoQLZnzsCOBJ4ZXEJrpJ3xjLEQfWsWo569ncTpS95njSI5Or7JeNelGvVswwg0nuFdApGtCLBmSMl4KyCpNsIrgpYA0kqtRSAeWCQcdP7R0LF2zT7cLO3VLaPo3B+jO7EFXDxD/qPm8D1jn2en3USLWtYp9zt38vOqE+ww0Xx+VgiZlkRIhBqMY54SUr7uSp8HWOyTx4/Ps5IS0Wi+l747UpEvrykdJeQyxKu6VSP0wnWt7t6qmICCd
 NVVn7fpP
 hku35nl8sXJd5lssVuCKY45XrlHOKniVRLn+QAyItGuWOYzzacriqrikLR3Z0NB03zq5z4UTAjEZ5tVN91M209fWyxWOTcSHdIxhzjBogObjmZw/09mfJV+2R7M4b+nt9x9zVl3VvI8RLd34ljfo6Kpr/+n2jT5kmpI7t2PoA0u8ec3qQiOcbOgpd1V4E30zRGm4iRf3v4F6xWmNTCVni7jg1QMZME0Snoh0xiIXtHFwj8P1Xsr5LfIQUx1YmTberssIrHFTz94IonJS76J63xNR+uQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_split_at() test next region that is assumed to be created by
damon_split_region_at() invocation.  But the split might fail.  In this
case, the succeeding test may dereference invalid pointers returned by
damon_next_region().

The invalid pointer may not cause a really bad user impact, because of
the implementation detail.  It would only read wrong contents in the
belonging damon_target struct.  Depending on the future change of the
offset from the link header to the accessing field, this could also be
really dangerous, though.  Still, the realistic user impact would be
limited.  It would affect only test run setups.

Fix it by testing if the number of regions was also changed as expected
and exit early for the failure.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260714142352.100478-1-sj@kernel.org

Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index eba643762132f..322a295ac2cec 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -155,6 +155,10 @@ static void damon_test_split_at(struct kunit *test)
 	r->age = 10;
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	if (damon_nr_regions(t) != 2)
+		goto out;
+
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 25ul);
 
@@ -166,6 +170,7 @@ static void damon_test_split_at(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
 
+out:
 	damon_free_target(t);
 }
 
-- 
2.47.3

