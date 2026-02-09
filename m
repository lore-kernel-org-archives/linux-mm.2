Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B7C6E94616
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 22:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EC466B00A1; Mon,  9 Feb 2026 17:15:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 855A56B009E; Mon,  9 Feb 2026 17:15:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6616B00A0; Mon,  9 Feb 2026 17:15:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 588AB6B009D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:15:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2BC7A1A024F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:15:04 +0000 (UTC)
X-FDA: 84426324528.25.7D3DA50
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 502B040015
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:15:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bW4AYiIx;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770675302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zhOcvH5cMErbpuFO1qD4X5xOtlaPVDROEke9rfA1j/w=;
	b=Wx0+tPY5eVFzeURENBW6PTeAuetCjB+yke3uUMh/hWn1KiToJkiU7XDV4QfwqJwv01i4aj
	k66/5R4iE1Y/yzDsDIW3gGZiGTa8D+sLvvkLBllziv7B4ZKfPp1ArpMN/IYpBe96Qi7JAD
	aREo/0lx2OqoiyYilvw4eBSuRP9HFGM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bW4AYiIx;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770675302; a=rsa-sha256;
	cv=none;
	b=tXwi9v3xo1QUrRKkIr793bCh+or/0TsLZvfJwtByJnimZg6wtCRRyiw+tSfA/TqZnByl4B
	ihnpJE29SZd6QevRsL/EtrctCiNqJJ6P/h4FkT6xrwKffrvyWmQg6eraLC2ALAiMUVeh0s
	jcG/rCGnUbNyGdrp+ijWgmjD+XecYns=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770675301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zhOcvH5cMErbpuFO1qD4X5xOtlaPVDROEke9rfA1j/w=;
	b=bW4AYiIxHlbnmBW540yRyckr6ZgapFAt8LtD65sPNVa28SapGTg/MVh6vt/cbaEo6T1jXd
	9yRp7TNTV7t9s0FMqfb0XXewWUuXGGpVvdpN4TL6E6WPA//VEmN7WeRmrVsXdFSCB51Cme
	pcOWtw8xPA59FHB/pZyaxKHfDiJ7uAc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-445--ENewiPxMw6ecghvTqURYA-1; Mon,
 09 Feb 2026 17:14:57 -0500
X-MC-Unique: -ENewiPxMw6ecghvTqURYA-1
X-Mimecast-MFC-AGG-ID: -ENewiPxMw6ecghvTqURYA_1770675295
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C93D71800465;
	Mon,  9 Feb 2026 22:14:55 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.66])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B554918003F6;
	Mon,  9 Feb 2026 22:14:54 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v2 07/11] mm: shmem: drop has_transparent_hugepage() usage
Date: Mon,  9 Feb 2026 17:14:29 -0500
Message-ID: <66846ee3aec32c04d20bc7e0e823ba21d4ef278c.1770675272.git.luizcap@redhat.com>
In-Reply-To: <cover.1770675272.git.luizcap@redhat.com>
References: <cover.1770675272.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: uETA0r-qXHXy1qLcZHwGSLOgjGdk1OlWhW8UTnQv4Eo_1770675295
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 1qq534id8zg5z4cmrfu6wroicgmp8yqg
X-Rspamd-Queue-Id: 502B040015
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770675302-895657
X-HE-Meta: U2FsdGVkX19nwOE3iZn1ocqGClLv1VA1uIPt0+AioJsPKt9P5w+II+Jpgba3pI5RZqOn5EeHCo+hW0KR+qMow8yQNk9KQ5wNYS//nGG9jsuj5lZGHkCm+oK6EKwVXou9mJiSgdTH9aHMa6B+O1s5+SD1SAdHxKpfkLJW6ZccqMc3y4cH8LzzjZtJWM32ssvZr9mHQ8wVPxuzlS+dZw0HH+VspcVPPoAlvP6J4ikbREs85X1KiAsG5PzTMpH0QIJU4+zRlz4Oww5KsU3oy79IioaKOdFnEZs1cAf8z0pjg/cmcjypFTNJqeNqyJKLtXJqsG6dw2aw938IcXbyiIA8a780tT+YiLGoqcSdZboiB48FiDfR0t2XwDfEXpaz07pf6IZ1TB9Ye+dkgQkjwLF6qV+diNMxpmdWVwuWrnM6eRWhGc1VwFQQiTeKScBDDp5fpfPKPTAdSPRaJws34yz3jl8f/k5vdpFMZeNHegI/u+6gaxdfmKMlIBS4QuVC20+vWUIQbdqPtZlO1XqeBKkTKUswFFxlvyeaLj616qEVdw8piYRXjMnH5PkPoCj0Nromg6ShaxSbBWIaX+JwVEySuze687GfQOZXPQUZDZDYohiJINgd5gVaP7ZBWy60NVDO8u+MZlZu+CyQtAWfoAUTrfi0Tc6VdFI0ovjcfOX4sPEznsAGAKIsUJqhodT4m7TtRDh+aO5WHcrdcVZ9UTxoV6senIKlJwarjRiWmhgCj2opaVKTV3TS9Hpc2jxvsEOOIm6/cznws/Embrsf/+dmWSfLWIeRzZYnO0Fx2WjrSmh3tbDdtN/i6KRulHMEE1LeDAK+zcxYPcHD93IhP4gSQ9go0WtmPL5eLU97brJJU2+48HQPqZ/FhQ1khhZztGBDYCQClNH8tRwOhFp/bJ5ljNbq+HOAqs276k73skSzSQnJpWpzwEJaO/esqOndve093Oofao1n5ZdGOKcV5i4
 ycdAnQ+e
 RqhXG3k+Oj/YgPxrR/fI11uA/Dr4qfwvpTcdKkd1WnbeGXmaY5ohMr0VbnTLb2fDA8uCX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shmem performs two kinds of has_transparent_hugepage() usage:

1. shmem_parse_one() and shmem_init(): since the calls to
   has_transparent_hugepage() are protected by #ifdef
   CONFIG_TRANSPARENT_HUGEPAGE, this actually checks if the CPU supports
   PMD-sized pages. This is irrelevant for shmem as it supports mTHP

2. shmem_parse_huge(): This is checking if THP is enabled and on
   architectures that implement has_transparent_hugepage(), this also
   checks if the CPU supports PMD-sized pages

While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled,
shmem can determine mTHP size support at folio allocation time.
Therefore, drop has_transparent_hugepage() usage while keeping the
CONFIG_TRANSPARENT_HUGEPAGE checks.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/shmem.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 79af5f9f8b90..32529586cd78 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -689,7 +689,7 @@ static int shmem_parse_huge(const char *str)
 	else
 		return -EINVAL;
 
-	if (!has_transparent_hugepage() &&
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
 		return -EINVAL;
 
@@ -4678,8 +4678,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_huge:
 		ctx->huge = result.uint_32;
 		if (ctx->huge != SHMEM_HUGE_NEVER &&
-		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-		      has_transparent_hugepage()))
+		    !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 			goto unsupported_parameter;
 		ctx->seen |= SHMEM_SEEN_HUGE;
 		break;
@@ -5463,7 +5462,7 @@ void __init shmem_init(void)
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
+	if (shmem_huge > SHMEM_HUGE_DENY)
 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
 	else
 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
-- 
2.53.0


