Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76A47C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DB296B00A6; Thu,  9 Jul 2026 10:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 089666B00A7; Thu,  9 Jul 2026 10:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DACD16B00A9; Thu,  9 Jul 2026 10:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8C506B00A6
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 535C31A018B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:14 +0000 (UTC)
X-FDA: 84969412668.05.BC20020
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id BB8E020005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+MvowD5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KtGhb2uuQghnzvwRekFMe5vHCrkMdKOrMY5ghfXYhj4=;
	b=UnynDRQ0xHTTU7S9DWny6AFaSt/Uk971FsONNEYl6l5YIHUsEBj3ByyhYJwLg0iTeKYhuf
	0A0dkKG4ziiOTC1f+wl3T/Sd817nxe6yvQcYCDN0x9xF3iJA0S0ElhPk9arS+Kv2uCX7Gk
	mTFY8T4daxvALSvcScUk8frxJzjtR5A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+MvowD5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605972;
	b=Zqclo/9mVLlEQCezSWz/zUKHFN1r0d8W/CBBrUlu1tlCizaf81UPRgU96CMooGYhYgrX6C
	1B3AKy8dNIIMF9ElgfdX8QPQfNhYz3Wsi0Ke2hi16rU5IbBsoHrXaC7VRQr2TA4pmwRqL7
	PBtB/cb5gD87FHcL9LUv80qKL2FqfOw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5289C61387;
	Thu,  9 Jul 2026 14:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC391F00A3A;
	Thu,  9 Jul 2026 14:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605972;
	bh=KtGhb2uuQghnzvwRekFMe5vHCrkMdKOrMY5ghfXYhj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+MvowD5sZPU2yKTHj8RKerbKJrDMh+lcYqF6jmKJLtSEq/jCVrVTbsHOiPTceZnS
	 LLgD5txxChTw2I61p4rIEe98n1XhvX8oAd2Eahx6hNVxYjvUKwDX6gY/BH+pF5pLDj
	 yoWdG/+noYkBHgsfwQbnOgvgd08Y+u86ysPfF4ZgAGDOnnR4XMPHmR6SGHM5JFr0y9
	 EAm6iiQqRIrZnPF5iJBHsp3Ljqhx0nMG2IsStUfv/gSJzboDkFri1IFR89vJMutkOk
	 SwW/143tFx17n2FqyVcqk7OWhKwyvd4N6ARs3BscAIwTDPoNGzPsGLqEqqTtekn3u0
	 IKf9O+fhLmZ3g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 19/19] Docs/ABI/damon: document probe weight file
Date: Thu,  9 Jul 2026 07:05:57 -0700
Message-ID: <20260709140600.90950-20-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uakasuuub1ujwuhbytt96sua8tbgbzp7
X-Rspamd-Queue-Id: BB8E020005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783605972-679851
X-HE-Meta: U2FsdGVkX18kqpFZzgtaOws0d8FteKf08d6inKjBI8ub8+Vwl2plRN3q6Rknn9wQfWiEGvTvbaJ939dm0s9X2+zjNuqbcwRQLBWETEcl7yapwk+7XfVkIGjetsFCaRKFBo5WRDQVr7IMpelp8EhZpAW37Rr96SkXw6JjKIxrKvIvd09xasq8cn6+0dexoB51qsZJrHf32+kenVoYcaYFrnReXgf9lKnW+W03HFY2Byno87W/6DFS144awAJC05Y+8jPs63qhN2sXekQUEiCEKIBQa19vZ5EGik0b1b0HHuK0qZa2evZwi1zCb7ivXKySepFuFzyEI2D8ZRblHmHyWbMEJ65vaiyKHCXI7LgTRvrJ1FobBNxZnJcDE41+95PMLhz+ETzdq/EeWYvmXRw92Suem/8t5F0vJJJKkpJExrOO+wodsNhlImNjjd/3FFsCo9jXI7qchDRkEiGkRICTBD0JBVbGSBvmUx3m9ebg4aKoTZQay0PRElmlujP/9z/+l65PlGxmw7IEHxXV01EAWaeTu7QQBqbVX2R0rS5iOObHDZfjHh/FJRXOTXTLmcAK5T5WXoj9jtTH1y4db0oG57rGl5HNHUmj2dX/yf+lFneRTqxnWmSU7BxoNpVqh1fQ3luSuT9PeQbR02bO4wxdxCU40wqo/ZBbrg0PsLSjDZziwb3/96LMpQbU8wsoTrt2A1zf02lY6DiLquIjLwPXEfm//7lMFy2zoeyaakJRKPbju33SQ/kRnxvxoSxhz45J+iAGxghYW5yLGrRV3AJ9QKMCZzJaa5oZRc9/XVw5exJqRIFttutNrKvBMOUpFhSaCMQzCZOReHsBY7u5d+B9FG4RHwU3ROpqFgIxtHIdpjeG+S3SWg26p+CAmrJPordAsNroWrS1Q0RetznlbCA6Sk95/9S6T43ofbW5t8ZOzHL/gVvcdLB/Bb/kKlE5kjcv9y5VsJiXm5XGrtgDxxT
 a0dB8SZA
 08lDy9V3/IYZXMqGhFWW2dayRBpKd1wWbH83AudkqqkMcBdrniGfihpAidjQQDHFE5lUCpAyOCaw3bQ7DCEyBezZNuwgC3jlKxSvGn3FGk23/cOnnhhDBW3gOjPtkEBSZbMZvVjkhV8BXcYPXnm3e9r+QkRuTW/3zc28V0I2v2eEB+BY2F6avFSxQI6mUw7m9NbMsFx97EojBGdMJr+9xgERsHb6ubMnPeg+fvhngb6buczM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added probe weight sysfs file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index dd6b5bd76e119..907a504fb64c5 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -164,6 +164,12 @@ Description:	Writing a number 'N' to this file creates the number of
 		directories for each DAMON probe named '0' to 'N-1' under the
 		probes/ directory.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/weight
+Date:		Jul 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		per-probe attribute weight.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/nr_filters
 Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

