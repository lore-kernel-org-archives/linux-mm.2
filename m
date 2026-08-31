Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF692C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA7DC6B009D; Mon, 31 Aug 2026 10:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31506B009E; Mon, 31 Aug 2026 10:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6EC76B009F; Mon, 31 Aug 2026 10:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 769496B009D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:26:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E93F41A014E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:26:27 +0000 (UTC)
X-FDA: 85161790014.22.1B51103
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5665D1C0003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:26:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LKuV2UB2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788186386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5b7EjDYfsY4UBVu5ajlJqmnOtSzQbzeAwcctf4S77Lw=;
	b=npLAUPokK8U4MKNBSf0FuE+CRf7zgSOq0cXZyAVkJH5fXd5B0Y2lsundbO5ZxMciSNxkUx
	aBp2u3/kbPk9XSvtnLraxglgAQ/ueGW1kVGD7OfGjXTeCtyO/4BYEqUQJrbxqWz5DN6Cwj
	HYCRj1tWSIiKIC6TBlgjiLqutrpb/BY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788186386;
	b=1uuWAL+H+6nv6uQyVI2swwSJ8eGNcL2NTkM4OjeQtYymrjT+Jzg4PZG0oy/AlLzEEWJld5
	D8JOIYPZs0kP17iS8uuMQb8H0DfC0LdIR2/+NjCZbpdzcFX16qX3OwaPD06+fbPc3j29/6
	YT/MXyz/fjzh6nP/GJcPM8xP62GsNjc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LKuV2UB2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DBE54391C;
	Mon, 31 Aug 2026 14:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523A51F00A3F;
	Mon, 31 Aug 2026 14:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788186385;
	bh=5b7EjDYfsY4UBVu5ajlJqmnOtSzQbzeAwcctf4S77Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKuV2UB2InsWQ/SUpl3zP1k3HLngPLcg/I9+ug+j1Z8imWtS5NIK6UqEG+7FVmWFs
	 kUqo4iwx63rdY7RrJMvwZ/cd0FcYXRZkGLcXDa1e2554bPWFBWPzvmiSZnm8TMhlm/
	 6ocAQNk0Dh2GMEm0SkwGjsbn/1ktxNqJctJJAOp1DJ1FQnbAQ4OfxZefMYLowmwFqK
	 N7yZD/jcEgKWX6Kkk7UmiEehGVqujNfFFJb90yry5MDLS4OOvj0sHnbNsG8ShVppqO
	 ysdU/bYg+5txGldI5fLTiVv6uMue2Oo2XaOMatZlOaE1YJ8I2bF0ErwS2Ci9oQKsW/
	 gJYPhKXiASITA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/7] mm/damon/tests: use scoped_guard() for damon_test_ops_registration
Date: Mon, 31 Aug 2026 07:26:07 -0700
Message-ID: <20260831142611.77572-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831142611.77572-1-sj@kernel.org>
References: <20260831142611.77572-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5665D1C0003
X-Stat-Signature: k87wsqpgeebem4tx4m4n493hyjuf4zf8
X-Rspam-User: 
X-HE-Tag: 1788186386-906903
X-HE-Meta: U2FsdGVkX195Vw3yfg7aFndPNg41eGyeK2KNIeRhLoFVAWNVu90nnZimYx1+CqZd1oa262A6qdcdfJS5McG4qTgxbT/S6eXF4HTKmCYlItJEsp3FWtQ0Ll2l/yULObgTa1Dn2KsDtSlfA3yFQ6oD9hYTeH4wpOv5kKuKTYnamXnRLMbfXV5JkSRm2KN26iDyUXJzrj5FIiOvLbXA7J4yqXx0TXwy1nKg2nCnWTYGLpWjwBvdEf5cvR9YYU2JClZQI8Cp4KDyPaq1JIKscOtpcL2HSwQd5kRgAIXPXiRCsvuRyWxq73zRaajTE4D3uISdOARQVbkoHg+yckwB62+CKaKyHVVzi+O7a1CIaiJ+dhL4DzLeNly9RuTEQeYQqaRez9TSLiB+i0DwgMhWhHWoyXQ8DskrfZQH/VS2CpNpkAQFeqn3XBTIg8PWoCESws+McPTTKewJgF0RFRZeo27D8fOATIy2lB+hY0dZ+BJWfCWQvu6bSLxddKcSF5QgouQfTvRzsCu7SRFrzujHGWmBRUaXFXCbF/aXmF0j+idtpHxVAOf0rbP06nk3GzN6kAmbYhtQ55xLOLoH3eVPhkDt0lRbhYibR+Nm0BT0jvx6w92o5KM6FN1GT+BgR87WbIrKW7Mf1WrsOthk7D23GxWSccPwafX0U/x6tCRr+rZMavT34RhOdxh09OQprm0YAg5Nna6P6kcIRlp3+58NUlmlpIaQkc7n7WIgRTWNqoOCVgbrsaeoSCJld3J0Enha23/M7xqtTzRQz8tg1QrvArzPFVbE6iYHVOGFUOpS7uqZXhQrEED2QlJzAtJxwD6TU/yQoGthcQknVAoI3sd1eALj1/4b9gJ6kX6AsmvFgO7kodeuS4Y2zzPaETN+YJKcyh9DqUnI3YYh8l64XoYpRwmyWiHsBsgDn4sKzbD7Rh3PCD8tAIBu5RqgpbmrRV6vVxYQaMpSg+7bVy6GLFwmDkC
 UQw9YKes
 jVH9tqqYxRBYzD7G/Jt6yd9447hexxAf3Jxd2nG6x9Md5e6OqoiicxN42D1277jOeyyDRwY83WEfPJN+Wc+49M4zgk2HU82lHhOqp+5bJp8VFRnCyeobnPWj1F0GqEUS3D4tKjwtnTZ8G2puy1jWmxkkU1sz19RerozTE9EYL4Y5+GGQw9QO/iaBaJ/s5Q55kZb/SJbmZIU/d0Hn/4QwP4cNitbcjfUXjXErqFfS+T5oXXHCyheH4fbnJTxxjqJpxGoL3IRxnFG4XmsOYoQiCGLGpdlLruK7BhpzivZQ3bz89ibk5TFXzmdBUXmDSyDUOnsbtfFiJxdy7PuvkBHqHWulwjMbF5Z00ocDliPx1lHaWwNiKRTorl0K5wA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>

Replace manual mutex_lock() and mutex_unlock() calls with the
scoped_guard() macro. This simplifies the code, improves readability,
and ensures that the lock is automatically released when the scope
ends, preventing potential lock leaks in the future.

Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260815143039.17291-1-jaeyeon.lee.dev@gmail.com
- Collec R-b: from SJ.
- Rebase to latest mm-new.

 mm/damon/tests/core-kunit.h | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 65443aba03300..ec7260a3bfea8 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -434,17 +434,17 @@ static void damon_test_ops_registration(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, damon_select_ops(c, NR_DAMON_OPS), -EINVAL);
 
 	/* Registration should success after unregistration */
-	mutex_lock(&damon_ops_lock);
-	bak = damon_registered_ops[DAMON_OPS_VADDR];
-	damon_registered_ops[DAMON_OPS_VADDR] = (struct damon_operations){};
-	mutex_unlock(&damon_ops_lock);
+	scoped_guard(mutex, &damon_ops_lock) {
+		bak = damon_registered_ops[DAMON_OPS_VADDR];
+		damon_registered_ops[DAMON_OPS_VADDR] =
+			(struct damon_operations){};
+	}
 
 	ops.id = DAMON_OPS_VADDR;
 	KUNIT_EXPECT_EQ(test, damon_register_ops(&ops), 0);
 
-	mutex_lock(&damon_ops_lock);
-	damon_registered_ops[DAMON_OPS_VADDR] = bak;
-	mutex_unlock(&damon_ops_lock);
+	scoped_guard(mutex, &damon_ops_lock)
+		damon_registered_ops[DAMON_OPS_VADDR] = bak;
 
 	/* Check double-registration failure again */
 	KUNIT_EXPECT_EQ(test, damon_register_ops(&ops), -EINVAL);
@@ -452,10 +452,9 @@ static void damon_test_ops_registration(struct kunit *test)
 	damon_destroy_ctx(c);
 
 	if (need_cleanup) {
-		mutex_lock(&damon_ops_lock);
-		damon_registered_ops[DAMON_OPS_VADDR] =
-			(struct damon_operations){};
-		mutex_unlock(&damon_ops_lock);
+		scoped_guard(mutex, &damon_ops_lock)
+			damon_registered_ops[DAMON_OPS_VADDR] =
+				(struct damon_operations){};
 	}
 }
 
-- 
2.47.3

