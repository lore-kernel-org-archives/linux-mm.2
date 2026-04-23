Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEBA1F99340
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 07:20:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 260146B009D; Thu, 23 Apr 2026 03:20:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E9DF6B009E; Thu, 23 Apr 2026 03:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FFD36B009F; Thu, 23 Apr 2026 03:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEB336B009D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:20:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEB0AC1DA6
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:20:01 +0000 (UTC)
X-FDA: 84688971402.16.EA85ABA
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf26.hostedemail.com (Postfix) with ESMTP id EF67014000D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:19:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FeCs420m;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776928800; a=rsa-sha256;
	cv=none;
	b=IqbYDpWZb/miPzZlUggQfT7V3CZapMivMbFYQVaQdgh5oBm+AFcllFHWoPzOnxLB4c3905
	Zc+wkP5exizmKJaBMvh45FW3spcL26wJuRq/d2mneJjVWrUbbFKKSWIlYD6pMEeo3wD/V5
	f6qkD7FJvhyhSZV46KOl2dRlpeCC8Ng=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FeCs420m;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776928800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=09oxpxOGuWKX0SePBMaD4YXeqObtAU02PoTlj9Fnf0k=;
	b=GyvLw4bHBOFpo7YMSADznufDpb2iLST7dSZvLKl2TPOn6CrtmIxzEerU10LLh46V2qAnyJ
	B+4+a0gTkhjCHGG8MIeLDWMDZ97Dl+rkIv274lJOvWKUdakYCK4JSK3f/BNGnAvo/1Qcdw
	BOX4as7bV0O+rZVyS/JK+N3iUNpOekk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776928797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=09oxpxOGuWKX0SePBMaD4YXeqObtAU02PoTlj9Fnf0k=;
	b=FeCs420mu2jpW/BrZcjYwQXLHZNzE4qYONzxJBEHdRikGq/jNXkyc4GEWWEVzyZYec9fR1
	MLr1PEn5MbTgXnuuQuB+Cp8blfQoRB6C7RgtubiuL/pgGIVsirueResNnZWjW5UCMXiNf8
	02vpxadDe1ZaO7welAbNOrbjeXCxzUI=
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH] MAINTAINERS, mailmap: update email address for Qi Zheng
Date: Thu, 23 Apr 2026 15:16:28 +0800
Message-ID: <20260423071628.44044-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Stat-Signature: g1nx4gbpzeha3kswdpks1yx7au39rob4
X-Rspam-User: 
X-Rspamd-Queue-Id: EF67014000D
X-HE-Tag: 1776928799-777130
X-HE-Meta: U2FsdGVkX1++Jh/ZhQGCnA78S6tfxqbDcXAJY9vxD1rwAB7uGeJ8wE9R18T2YOrHpzJgwnv5RKrgwpWzqIJtWB3Cm15kwqxksMZ5o83a+4ZPofJMyir3kKBDoFNNad3k0tNkC7cKQO1SUSgpkq0R0QjCFzk/61IxRTaon33sF+jVtKQ2kQ6mP8/3gAlS2iOhp7xJmXEEI+yMoq9nuRno1dB/mYPms/+8+BZeCyIuqesx7UXF+1k0aVt07Vk+kloACN1Ayvcvieo4BlxeV8MgU4G8a3Eja8gSpOJOj0NOwCr07m88A5g7GFQuyQPflkhkZFANuq3zLTaSCUr23xZW4rI73cLg1yo6GU7UpJTvruuvYaNzPI2HGtfsEOkt4SWAneYcCeUZpmIN8M7wVaSE0G1c204GH99upV2WyOKs7N2eaHgxO3un/SJTcax0oA3XgShcbviDxBGqCKxU74E91pnprolBvtjwiM8SoJyaRJc7EmwjMfiOm3etjSguVmne74PlWBZZs9OdJ1GNQjy2YaptCe4J9T1Wo1edg1zhLtdjBuMkVB1DQfNk4JMtVkfnZSxeDlF8fbASFkAvbRBxGEeIs5AcpC1vlpoW1KpdYM1vJgzyAL3d8AOwwwbo+XxpEEeBdWWkk1Ta+O8EKTuxk4D1xMDMqrO4J2kBXSyhdOsgkdOgNJdRicWgZKkQpt1tjUV2AIh1YsBoaQxv/KV0glCZ9HOFPV2uVy2ntP2new8hG1Q012A9x394Hb2hxoEH2JoNSbHGo8YjgUL9KocKNuvmEjwE39RnlasnOXignLp2/3cvVIP8bGW5N7XFxGC4KEp3JoCY0edjHais2Q9KW8m+kfH+eV60vMMwd1MwA5LZepCsXoauiilwpXRuNvmRpgETHZWInRmDzelfkXd2cUYS0KyM9j33LWJbc410i3obvXmFhXQtcHNtrb/WCBZ7fwM4sWWmGZ8bL2tEzKq
 aFGRSrbK
 BJQ/mBNZnoSA2SjTRm7OtAwt//JH98rj/U5DG5tARnnv5MA+TXddWwkxxXJIrrg6M4dL8d6cUlTEJVZME3ughKnKx53qSxHcHuANSbpEbcAqcB+FFUhDlBFGaCJT17IxbuZCubLVZ8QYoWFI287yLtxQVF/pjr+wd0oiOkaNmmAd+vESDxD9zG9LWf2IY3VBJ05TShpSkj7kTJU7kcC8vW/NneKOi9pw/wLKZf8OKpndFvfdat0IpZkKX/BxUF2U+VEM7AkfVeHqO1qAjDFKmWEIHtemaURrF3jjL+REYjUAkRNDWpRUa7nKfIBLH7PSfWf6bzPD0R9aaNw68+7x/rZ/rVfA4dh1cC0UvwM/7224++IyxtFpyVWbEfDqbp6d0xD1kMv9zfPSoEANDcCHCP/ynH1oC5c+BXw5rcW5U7ZXkPO2slnmRczfEX7jlwbh61zA7EQ8VqrS6tbLugMmr7AvIgpFqwsc/45XnwOr0IK+amj1ZMJ+lTvwiivoT8lSU65YFBIKywgGp+21KFQvtg13SDClAE9b5/LxdKSHSUmuQyjsr8C4qlh+1q8NHcfn7je73bFl7w3R6yc1ICEji8JVNBODLsrTMfuiUxkrZgE/2GPDDauJf5iBF0WRo9rdHzQKEhBQyjGsbxMQU7ljon7T7WiTHfjT2Sion5Q0eaOsD5aa8/quwRepFS89ajl/euREzu6OqCcXWErz2lzqZxmKseogQXDUtjIY8N9RFxx4M5LxAxgmZVATS46hu/s4L+7TcDZtiH2QP7h6CsL7sXwhxJ91Uy7oNao7Mo1B9torqZmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Update my email address to qi.zheng@linux.dev.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 .mailmap    | 1 +
 MAINTAINERS | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/.mailmap b/.mailmap
index 9df14b3417832..92ee8b0d883b1 100644
--- a/.mailmap
+++ b/.mailmap
@@ -687,6 +687,7 @@ Punit Agrawal <punitagrawal@gmail.com> <punit.agrawal@arm.com>
 Puranjay Mohan <puranjay@kernel.org> <puranjay12@gmail.com>
 Qais Yousef <qyousef@layalina.io> <qais.yousef@imgtec.com>
 Qais Yousef <qyousef@layalina.io> <qais.yousef@arm.com>
+Qi Zheng <qi.zheng@linux.dev> <zhengqi.arch@bytedance.com>
 Quentin Monnet <qmo@kernel.org> <quentin.monnet@netronome.com>
 Quentin Monnet <qmo@kernel.org> <quentin@isovalent.com>
 Quentin Perret <qperret@qperret.net> <quentin.perret@arm.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index 891fb83ba7a9b..e95f8bfa7abf9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17044,7 +17044,7 @@ M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Johannes Weiner <hannes@cmpxchg.org>
 R:	David Hildenbrand <david@kernel.org>
 R:	Michal Hocko <mhocko@kernel.org>
-R:	Qi Zheng <zhengqi.arch@bytedance.com>
+R:	Qi Zheng <qi.zheng@linux.dev>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
@@ -24391,7 +24391,7 @@ F:	include/media/i2c/rj54n1cb0c.h
 SHRINKER
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Dave Chinner <david@fromorbit.com>
-R:	Qi Zheng <zhengqi.arch@bytedance.com>
+R:	Qi Zheng <qi.zheng@linux.dev>
 R:	Roman Gushchin <roman.gushchin@linux.dev>
 R:	Muchun Song <muchun.song@linux.dev>
 L:	linux-mm@kvack.org
-- 
2.20.1


