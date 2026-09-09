Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C7FC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 23:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FAF76B0093; Wed,  9 Sep 2026 19:55:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F716B0095; Wed,  9 Sep 2026 19:55:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34EBF6B0096; Wed,  9 Sep 2026 19:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07F136B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:55:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D195D8034D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:55:49 +0000 (UTC)
X-FDA: 85195884018.09.CD65AE3
Received: from out-2z4y-a133.jellyfish.systems (out-2z4y-a133.jellyfish.systems [198.54.127.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id 11A2CA0004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:55:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b="MiiP/7R1";
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf25.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.133 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788998148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Heoq7yz2Lt0znUz0x8FD4ogNI4fraKbS8z8CtkyKBo=;
	b=2wzexHJjtyaEEfze/xisX9yNd/L6zVUZiKIOFkzgN5s0OMbG2kp68/g1XHub+8FEAduEJd
	xSbyJr/yoD5h5lsYQLkh69NSuJ8dO8XpgMtkwirbzcsvUn9jgKkkQP6+/w12B1B40qyZLI
	rKOks/HtRDhXswUNusGTOgLhvWOvT7k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788998148;
	b=sHkuw8NszhXbhnc6FrOZdqQyJihhBhkqc3tBZbpCWGLhbf9Cjrs3QHPj4DRrOA9x1HrBmU
	CfriFO2OPBta0dXRnKf+U7YzAZZCntqXrx4GUjhOcgPIWl4Gm5hLC2ldA6VMYHwj4vjodj
	iKYRid4sO7Y5E13pyQFLhRA249SILmQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b="MiiP/7R1";
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf25.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.133 as permitted sender) smtp.mailfrom=hi@tychen.cc
Received: from 192.168.5.7 (unknown [23.142.132.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hgHkQ2b05z8sXs;
	Wed, 09 Sep 2026 23:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788998144;
	bh=7Heoq7yz2Lt0znUz0x8FD4ogNI4fraKbS8z8CtkyKBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MiiP/7R1mthCanTDpN3BC1vGG4G58dvBT2e+WPLduskMqYbZx9WJQnc1MA6Sxli9Y
	 ctbQ2707GlQ1XIksxrTYxE4ZqnERp2GVmig/CRmSdLCggJOTgbS3s8uJN2bs8A8QGq
	 wvqlYSIWjQdaW7hVt1SNi6Xe22n0ZB3EMtRPLUGtvlSnaAMn1dBfoHz7W0CtCKZAF8
	 cf9w2BykeaAGC0083/cdH0M6TH7QKnAD1N/fpBH1rGHLhAVDpjvXHfB0vSSZxsAR78
	 vzUKxuMUMNfxTCnoqYL0X46CPM+hmoCsDiGiK0/6xZuDsf+CK3uvKDfrSYSyadtUyy
	 djijLI06whFjw==
From: Tianyi Chen <hi@tychen.cc>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hi@tychen.cc
Subject: Re: [PATCH v2 0/2] memblock tests: cover low-address allocations
Date: Thu, 10 Sep 2026 07:55:39 +0800
Message-ID: <178899778471.174768.9756364390429558001.memblock-v3-review@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <aqGX-ZhxsJppfNpi@kernel.org>
References: <20260906144011.848898-1-hi@tychen.cc> <178874362959.1415955.18132997964995947947.memblock-v2-0@tychen.cc> <aqGX-ZhxsJppfNpi@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 11A2CA0004
X-Stat-Signature: nge4wku8xkobw8jk8spf668enzasfa98
X-HE-Tag: 1788998147-855209
X-HE-Meta: U2FsdGVkX1+b8j4aCsAL/KT8P9SyRIook0AVyA0IKsX6iZsX3GfaUFbW791eIhwoNgAJzDhzD0J1EHkA/SzWktqHOig2Jvs12XiAJQcvdalAqxXZRZYvDpr4Q/+LgfzFXjGJ2lMYbPrjWLIS2jqlLfBDtHWPZDuBV+9P5bYllq0PiWhMdFH35c/Jy1HfMpMyfg9eJiDHEr372AfanrOZmqUW4JDBR2zyQfyeYbPa5VW3Sd0cRQ2H2+6Dwu59IBCvUNcHzwySdxqxgbXlNof/UrJuq87Kp3uv5BAccLAJplsz33SdN2nUNaiuR9rcC+4QUBC1xZ47RxyZ9BBoLb3+WDfbHavaCPrBUo/MGB3/kqJ884HdA2ViSLv9bWyarQFRPiPjDhFNM5OsY9c1ghocY/2Ls2Y9PCN6YcYTe5EhHWM17lnrqxCBgeVMnW97RYlI0XNJshZ7NB29bDvCBNdAa80lgyQu79jlMOINh9/Dm9/f2deVTJ8CMVr8F2uvCFAxqh+gBQj5PaGRWr/HmaveNkZRg4YWX00r+JxHII78c5pyWxttlZdT+amv5hD0ZOl93JtP506GUvwNL9lKXu8bdcxLHfW4uv8mxy2Sc4qkyqSGDn8FI/gorpL6nQAM8QN0jrCd8UgYrhTCW4Riqik/MXW+ZDockjZYxQt3JRpetIPf6G8gFMBF0RJphIomKzQSDKaU/c/SUWeDfIqAq0gtR3TqhpQaORrFTwo9TFmAol1QiqDpO4sAt69os6oxkihw2KlfqeFrBpHal8iGI7Xa77fYC0w4BmOLvLqdTmZP0aJWUB3VkXW8lgq4zvt/N1alAWCevMTI8YiYlqTiUveoBHt9bSIEGfdwDLdoQUa0yBFLQQZDufw8RyZNN1vj9zCLL3bu9sZrXqFMPSvgPF6S7pWcU1TtbobALo0r8U0fR49Y7si1ftN4gqYcRsSPqzuYhvBws/SrpEuT/rClIXM
 NqO3NHAe
 8IX4daus+USSj6Ze1xnGUJwmI64pS/5raTjMKrY/ue6AqWtXBAoQJ8U8CMGR+z/+gTrNyo79LryL33ok+OfKd74UhUEB1Fin/GqeStTdXHY+7LyZZmwWIgtyaFnRw/sdiEvALxps2+7PtVyTRt4rauRtugQ83gfYvvW9HIqUHLQ8kcTr8T113mt0vJoqeF76wGF+sP2465VSzDf+e+8698yXKOzpR5QXdhevVi5Dh6w1ngjroJ14jwg9iz9GJ7jwcMn1yMAnAvQHkFHqhA5ncadg1FX+ErGF9ggsB53w+dVo8mO7QUw5IIQ+ZT5lV7sS2s+lN0MPZgpTAhJg07i+fHX0FZgYQaidkf7odc5bIPL8uFD1zfBT4VLjU0TrsFEKVPqWP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

Sorry for sending v2 as a reply to v1. I have posted v3 as a separate
thread:
https://lore.kernel.org/r/cover.1788997523.git.hi@tychen.cc

I shortened the comments and README to describe the low limit and
simulated RAM alignment directly. Both patches now use Assisted-by: LLM.

I also checked the pointer casts with BUILD=32, where pointers are 32-bit
and phys_addr_t is 64-bit. The tested compiler sign-extends a direct cast
to phys_addr_t, while conversion through uintptr_t zero-extends it.
Direct casts also introduce warnings, so I retained uintptr_t to preserve
the existing conversion behavior. There are no executable code changes
from v2.

Thanks for the review,
Tianyi

