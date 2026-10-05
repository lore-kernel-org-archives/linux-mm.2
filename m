Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2CD3CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 13:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E43226B0088; Mon,  5 Oct 2026 09:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF3CF6B008C; Mon,  5 Oct 2026 09:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D09B46B0092; Mon,  5 Oct 2026 09:06:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4E116B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 09:06:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D3F6140263
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 13:06:25 +0000 (UTC)
X-FDA: 85288596330.14.1F273F2
Received: from mail-ed2-f32.google.com (mail-ed2-f32.google.com [74.125.228.96])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8B8B640006
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 13:06:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TFajk0Eg;
	spf=pass (imf04.hostedemail.com: domain of paul.dolan.dev@gmail.com designates 74.125.228.96 as permitted sender) smtp.mailfrom=paul.dolan.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791205583;
	b=FEJcEqNMXJY6QpyKkV1KSyeW6QIJDQO7VK8Je5n9/iQJwTZLwxXntB4fNukRh6VMXG6/jS
	xQcUnnOLFzJ9PzuIBlPiqxxij3wWmr7Uu3WDGapJumz1qhZ5btMyofAM4cBsjCRn/r8G92
	fIuKoU9RnosuLAjyElMyOo4UzgHXdJI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TFajk0Eg;
	spf=pass (imf04.hostedemail.com: domain of paul.dolan.dev@gmail.com designates 74.125.228.96 as permitted sender) smtp.mailfrom=paul.dolan.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791205583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BjL2pXlHfuAQFc/3GOIX7IQe1y00mLqM+xdgaQa2Gmw=;
	b=p0OPIUydpwLZtdpl69qyZ96WgNBDK98xpXlfde3QjIkB0Id0wf7amRYQiclblR3RMwIGeb
	VSe7Ywm7SF8ptQPxJjvBAjJHKlAX3IeEs8otymllHmSKdQafohmLCecETvc6VdyD2V9lq2
	3GqhYwBoxOkpl16ieMnFEv0IAkeKFKY=
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6acae8342d2so2358755a12.3
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 06:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791205582; x=1791810382; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BjL2pXlHfuAQFc/3GOIX7IQe1y00mLqM+xdgaQa2Gmw=;
        b=TFajk0EgY7/d1EN4ox5EPXoxmLqYHXu9G9dUJfb9nS/J70cV4xw7NPXI9hyqSxLa28
         cTIodPwR1DHvl+Yc5aRKV1dnrrAFYy9r8P/obpEftIXK8Qxa57KcdTV+a7KvKcF7U4W0
         Yrpgfi5dXYx6Pq8fVo2npyt+xI3Uo+n5s7uxL6HGYClpaInKFM1JCdUdxxJ5ZNz4OM78
         +LpV/GK8ixi/YOO0xiQ0F+nvrP0cFbynYaLMjrv5DsHG2xPm/3QUXUKPfByKlTrqDB34
         1YQO+60ramuc3AMg9UntMZk7Ecr+qreXV78EdTJhGcD0Dqjc3AkzhL3fgm8OWxJYSEq1
         P66Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791205582; x=1791810382;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BjL2pXlHfuAQFc/3GOIX7IQe1y00mLqM+xdgaQa2Gmw=;
        b=FeUs2fGU6ODyfzRAyklcMW5f4LT4qR6rCeCINPjq/cSVGti3zejZpaPvbQymgLk/l9
         +t8ycRreOM4Zjfz2BXCbZ22ak5GMVq/gSe1GaBUe95gdCs+qkat2JYyTFzo3xkylvzl/
         uOO9vJ+HTv5kzSgJfzMpZzrY/jGu4OliYtQLd1ny59qvntTZSry47pRCYbf6iT3vaP1j
         VdAaOzrf0VSKdmAY2ZZqRkcHl6Ry2pfCudIAh9dxqHmOVRIFFtCMRNzPg1W/gbFozuyA
         Jx6paPzbOutQuF1wQ84Cqxz7+cIfAyzdsHUMPFbb9lzA7p/ro83xyjSNx2SeqeK/FWTK
         hL+w==
X-Gm-Message-State: AFq9FYITS/UHBk8BNt5DPTBb1qGBZaoiYfPjfEHY+e5qDczpW2TW/Ogd
	0J/vTmjtVJD8sBKRNR+jvUz3ROeLgaNYu6ylsB4K+tSL0wAgtu1u43SsAoLeMA==
X-Gm-Gg: AYBFou2+ygaIiPXurQoDl3Ftq09K7p7LdITBcTv0Atw8b907VZg8rw440vderNyFRB+
	xYkOYoLy7vgBwPp/vXGLFd0y6gLgbmIfFk++blo4nUCDi4CbdZEdpdQTLNhhqZDxt5A2KtBbMh0
	ppr6KQ5ehxTxrmOwtRtt63/Jc+AofHOJMeWjB7ZsRHYA6RBWg0CQ2qCbV7y0ISfiAfxWU9CCHCc
	k3EwMCFYUg9y1NmEHeRKgWx72wIgqjDLzuAvweWmhsGMCXdheTAhQdhBeoPMFSP6clRn4N3rbWT
	Oc6z0QzC5h3Mylh0ZisJW9GbPmywpXr5UnAT/7b5/09JUCB+DejJR6ltdWx429MEYB0kxoWOIQN
	hnGAO5Uw7ZIZwUQIWb8oNfx3s/+YFTe56s8CX8QByXeyu56D2vkVEUBrVWWGpdXHgvvZAKTOwPl
	EUZgg/5LSclRrO+EySRoAeEJQKDL2UXRPKjutVpcIuq6BmClGAjad3ci9lO6mxl4V926DmqyApk
	/cizecHTQ==
X-Received: by 2002:a05:6402:378e:b0:6ac:934e:a9d6 with SMTP id 4fb4d7f45d1cf-6af9e022bcamr9401777a12.5.1791205581824;
        Mon, 05 Oct 2026 06:06:21 -0700 (PDT)
Received: from fedora ([51.37.100.165])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6afb005a424sm3390647a12.0.2026.10.05.06.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 06:06:20 -0700 (PDT)
From: Paul Dolan <paul.dolan.dev@gmail.com>
To: keescook@chromium.org,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paul Dolan <paul.dolan.dev@gmail.com>
Subject: [PATCH RESEND] selftests/exec: reject zero as power-of-two alignment
Date: Mon,  5 Oct 2026 14:06:12 +0100
Message-ID: <20261005130612.162824-1-paul.dolan.dev@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8B8B640006
X-Rspam-User: 
X-Stat-Signature: kdwbeiwg9a8xu1yp4eha8nag1c6n1em9
X-HE-Tag: 1791205583-259171
X-HE-Meta: U2FsdGVkX18nWvzwceZMFdP5goqd2hzek5z9r4qv3a64L1/e3cV6LAcAxwTsC3/l7xQA5r/kEDAEe48zurqSwVGiYYoQon50R9rLFzI4SEdJ/qwSUlmzvGNZYZ/uPBq3ETXa6LxrFIb8MxfgiC2aQfWDGmWS9XR35tAvd9EFMEya15Z8vxwcFm5EpaYqnUbq7Dz3NWzfOsorRw0ylMbv1QDMS68uMXcuaEjaho/y4tSW7124f2UbtNGSm0iZ8LZCIaCSYHlcWi2ThbOaILbXb1tKQr4FQgiFel+2pFBUDmq54NBiY1K52MTecaueQMemZHgFZEH1B8kwmjBbLuzixTf/92xERrnzkVOC/cD+TqnB/azlAZVrVR6Jn4J8bZ8f7pDR1ionl0lmBWGR/gKQD2XmjmXYK8OtqiIjo87thUEy4O7+MYEWL1nvNQlARBOi8ecxUnGtOt60MuCuJNyhqbc+w1t3bBR8iQ76zvbYavoHOCP17UOTFKPO4YkTKt7FxcZx3tDVMnEOzcDfwTdNw6ShtCP9wbtCSaJPOf/dyQNlcmBgt9PI5ZopJld/JcALm91i/8rdHAZds1l8qLObRREpftBfs0QEB8OuLQyRAGocVjF4MixubaGQB1z/wboOSdtAddwSV1iq1zXZiSypJGq88HBDvL4T9M1PefV5z1ZrVdiGNXuA+KkEblZREWIZo/cVfpK3ACAS7L3XHY5sH+UJAHL+cdkKP8WGXHikR0eSf6Ia0chLrWnbq/iGllGpVdsxCkONyQCamghL3aI9yP2HdWEkMs9zt1D0U9nkGn4wFQcR45DQwc6oSaH+1frBDiOu8rhQVEFFSuvAGYbovyB53j5WL+kd8lNuBNCIgQ+eSsTJHLYipVqSSZnFcSQk3MSd3CuGywbKbixmlBtiu1G9kSpsw/I00QS691MpmZQ6bJSTVn87QOqlHe92QLl9e3CNxJBvs0D3I92CM1e
 npN9uevI
 xQpxp2vxVniwD0KUIraFaDdX3XSwkYjCTgNpjsbDVpUBMRCLzluEnxmUNj2n0wzl217GDbVMludd6QhZeE4v3Ud2n0SclbLLwAWGOsMmiNWyYvoN2CzvmR9SFYW6qJc8RfGZSAbR9c1giLDXJUYxhFnw4zxFo1D0PhOQPOycGwWgbUAC4AlUibm0ERleXMoMQkvoeFn+4AEufvnxUfbkIzCqQ89SMVpH1UgoeMPV8QTzB5AU/KwhUu5zfwQskXz+x1LxzU2vOTPcU4fhtvBuK+ObK5gMPKbVXH7scBFkbRUyHHBvjEPOMLR3yDaPU5AzIOpOQShlZkhcd0LZpoT27WG1gEOHmJ9GcrajJn6jFqXoQbVUvG1839YQVtcQgQH+iKIhJhSu1L7y90xstatiQ1NJKSAqRBvFDdwnz6Kl/bakNEwU6W4k6zXMwuozY5MmndBeQsbglqIoYTkEyL79x9bwQl7/37blp96oJCkhZFEzMgZE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The load_address test reports whether an alignment was found separately
from whether that alignment is a power of two. However, the usual
x & (x - 1) check also evaluates to zero when x is zero, causing a
missing alignment to be reported as a power of two.

Require the alignment to be non-zero when reporting the power-of-two
result.

Fixes: b57a2907c9d9 ("selftests/exec: Build both static and non-static load_address tests")
Signed-off-by: Paul Dolan <paul.dolan.dev@gmail.com>
---
 tools/testing/selftests/exec/load_address.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/exec/load_address.c b/tools/testing/selftests/exec/load_address.c
index 55fd3732f029..e279d85e8f19 100644
--- a/tools/testing/selftests/exec/load_address.c
+++ b/tools/testing/selftests/exec/load_address.c
@@ -92,9 +92,10 @@ int main(int argc, char **argv)
 
 	/* Is the alignment sane? */
 	pow2 = extracted.alignment & (extracted.alignment - 1);
-	ksft_test_result(pow2 == 0,
-			 "Alignment is%s a power of 2: %#llx\n",
-			 pow2 == 0 ? "" : " NOT", extracted.alignment);
+	ksft_test_result(extracted.alignment != 0 && pow2 == 0,
+		"Alignment is%s a power of 2: %#llx\n",
+		extracted.alignment != 0 && pow2 == 0 ? "" : " NOT",
+		extracted.alignment);
 
 	/* Is the load address aligned? */
 	misalign = extracted.load_address & (extracted.alignment - 1);
-- 
2.55.0


