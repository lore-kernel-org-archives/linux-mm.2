Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1318F3ED59
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 16:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70B4D6B009B; Sat, 11 Apr 2026 12:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B9776B009D; Sat, 11 Apr 2026 12:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55ABB6B009F; Sat, 11 Apr 2026 12:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42B1F6B009B
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 12:49:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E9EB1E375C
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:32 +0000 (UTC)
X-FDA: 84646860984.05.3D30E6D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 65AD512000B
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Wr/Rs6Wy";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775926171; a=rsa-sha256;
	cv=none;
	b=wEeI6TcHpSbveM4a9dvIj+8QvN8/EmMl5PMQvEmjOnbX4dL7kl9RzYlm6lHujwNUXMhfAn
	M4DiQS0I8wx/tDMY1LVsrz4yJ2RxLdCAALTE27xHc5lent79DjuEilMpgjb1EDHHRWnaaF
	IdJIGyZoUkqZ+fFH6JzHWb+RonwfrD4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Wr/Rs6Wy";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775926171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rdaam9BwVxK+HQPMM/xSyzd71ZxUQuLXDJfRzSuG9c=;
	b=Bt7u4IiPYcbicm9bUZdx9VlQ80DNO2t3gpBwAX2hPDwaejQPyXu3qd3J5VVhpYa81TFkQ2
	YbO4fhl+3ER37z+censsoS5lr6WkFwMYO5hrcWSZiZuB70Lck1h8O2YHzN+eVVjWY01tGb
	6USiYmOZA78a0Skc5WTFhFDNFNpbp6Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7664561333;
	Sat, 11 Apr 2026 16:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D239BC2BCAF;
	Sat, 11 Apr 2026 16:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775926170;
	bh=oBXW5uIN8lzshHczxlHFHeX8VLmiX/5T2Hz8N+WZ/sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wr/Rs6Wy+rXroP+GBVL0k5zow0g3+j6r+ujZTIX7d4alrHjgcq7ePKfaxbvIth1Wd
	 /b0H3QJM/ZofHkxD0DoK947y3Mq/wH9VC3ATuuzS2AAO0Ci/aE6imCGqdn9h0YBGfy
	 kfV9zygQjlbIYKJUqgZx4uX2+tP3qfeQ3LwGb+QnvAcD7sb/rx9y8j/97rVXGzqrWI
	 XU3wAWiL36y60295RRvfRb+Sa6IZ7L6kE9rnYqbH1LYBY3957lxScHHgWFjOzvb5iU
	 uTriMLnCjZjcNad//neox0N74cAxazkpsHN3zd3+BzCaiFXcy5VXdOXn1QV6WlBviF
	 Bo2kmeQq//a1g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.1 08/11] mm/damon/tests/core-kunit: test fail_charge_{num,denom} committing
Date: Sat, 11 Apr 2026 09:49:01 -0700
Message-ID: <20260411164908.77189-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411164908.77189-1-sj@kernel.org>
References: <20260411164908.77189-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: koacpdww45hwhjd4snjxciaduxus9fbt
X-Rspamd-Queue-Id: 65AD512000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775926171-930863
X-HE-Meta: U2FsdGVkX18G9OrWFPz+zVXZpaHpYIvcTfN+58ixQsXNqOIcPeCohxoOdhgLFYItWPszSWvFqYWZ7k7NUAm7EELvpkDcLJN03p5mfnc5TT/6bx8J+KgBE2kmcB3ZCzCRnjomD9kvw6t0JPMjwt2JFujZ4CF/TCzlyTjzkCwW/GGmSrFjSImxuAma+nv6bBoOG+XsLq1sU7XtNAV4ABHhL8tqxR3oOmO3GF7wir3OhunMK0O67ZSkNwx6vLSfAw3KJ9Pv2vmgU7EJAFfBrlQ0nWvwMdAt+SdCY6E/kGf0iuEekia39rnUq49/w4nCSo4+PeZoJdI2QJS1CrrZxK45MEiu4cmoKDqULnB0nPLWmsw6My+HlF8PZ7/TIEPWj1mp3XNL+amcm65PIyTK6kF06VxLXFqnBpwtcMDgn3FA8oiXgefMQ3eDf3xe3pnyKznvgfDZsfuZTLrezH/brl9RtGFZtfmNnHXpXmMXe5XqEbzaXm01zPUm4IGT4Zubx0rdAJ9mqevteSvQkNbeFccpz7XR0qEFrX4M1YabWOcxIt0GElOKp/FuEtEsFAzs3Cpad36s+0S2YdnTbS7RGLdMzcFkeHKRnH0UGmG+e6N+x0TRD4zdxyjxjMzceKW5dB58aglz3FP9oSvgG/GzoYqg+6sp8nvA5m2qirMeTK/SDnxeYxN6mEw7/yhkurprYBzfqtsEOiQ1gX9aFN4/i3y09vQ6hwT5TdE9i9QJ79/vvBor+/olbQPYgGIOIBpnwFXik3NLJZACbtNpUStVHAUvaYdGtTBWdaRWz6Ne+La6+2vU4G8GM9OgxqmS63Hcu7tChhmRvv+2gZvDbPuVjg1tBJNp2a38uXPeaOrXskcU5z7eDHKOOb4QnjtD4lLnaXHYSu+GDM2snZ9QceJ79jiQp/rXjfi3b2didqMryO7Yaw0JpVkwKPXSYj+/zTs2cKNEFJlbLd+K2dSgWnVltz6
 HxDcrLVj
 iNni1yRvuU6GIx0vp+MQCRRcNB1DlENo7vJJugS3rHcIGmkjrwkwrFudfLU5PtT2oYKNt9Yg90FgEKby0FFXBg/DR9X4Ytx51H1ePFBW7ku5pPm4p5jF/JG4s/pNELFTkSR7mjPG/kcNG1zwOVRXkZJ+MGEHLnalPdDGLHhk4EKPiH+lNFK8KSPilxr8KE0xmh9dqduFlbKomxY/0SNwPf+xWHfsM9G2XyXRtH+flSIV6+G+aWntYFphiV1Dzu+StYuZlCJxs3Xqwa3JfXo7OuRh2lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damos_test_commit_quotas() kunit test to ensure
damos_commit_quota() handles fail_charge_{num,denom} parameters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0030f682b23b7..1b23a22ac04c4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -694,6 +694,8 @@ static void damos_test_commit_quota(struct kunit *test)
 		.ms = 2,
 		.sz = 3,
 		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+		.fail_charge_num = 2,
+		.fail_charge_denom = 3,
 		.weight_sz = 4,
 		.weight_nr_accesses = 5,
 		.weight_age = 6,
@@ -703,6 +705,8 @@ static void damos_test_commit_quota(struct kunit *test)
 		.ms = 8,
 		.sz = 9,
 		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
+		.fail_charge_num = 1,
+		.fail_charge_denom = 1024,
 		.weight_sz = 10,
 		.weight_nr_accesses = 11,
 		.weight_age = 12,
@@ -717,6 +721,8 @@ static void damos_test_commit_quota(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, dst.ms, src.ms);
 	KUNIT_EXPECT_EQ(test, dst.sz, src.sz);
 	KUNIT_EXPECT_EQ(test, dst.goal_tuner, src.goal_tuner);
+	KUNIT_EXPECT_EQ(test, dst.fail_charge_num, src.fail_charge_num);
+	KUNIT_EXPECT_EQ(test, dst.fail_charge_denom, src.fail_charge_denom);
 	KUNIT_EXPECT_EQ(test, dst.weight_sz, src.weight_sz);
 	KUNIT_EXPECT_EQ(test, dst.weight_nr_accesses, src.weight_nr_accesses);
 	KUNIT_EXPECT_EQ(test, dst.weight_age, src.weight_age);
-- 
2.47.3

