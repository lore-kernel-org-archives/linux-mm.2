Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7361A10FC456
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 23:22:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97CD46B0005; Wed,  8 Apr 2026 19:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92DD86B0088; Wed,  8 Apr 2026 19:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 843C96B008A; Wed,  8 Apr 2026 19:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7577F6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:22:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 11F2BB7DB6
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:22:07 +0000 (UTC)
X-FDA: 84636963894.05.0D65F59
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id E34361C000C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:22:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="IR/1uMUK";
	spf=pass (imf18.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775690525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgcYXNV9AndVyM0eXgkCwf75FkwR80fy6ED6RTnrjIA=;
	b=tgSBeoTXGmNjZxVi+H6qOB5n8gU4UW/o2UAzWKVY7D1CutLc3GtqTq41d+AVvqWIkZ1dvy
	61sF04qQh1E8W4s1i8IO+l0ZvEagyheVgSmd27eGjf4nuim/epSzNclNDY1KlR9E1+UdD4
	Zx5yMrOeldtirRo7TyZkwRR/pXhmPz0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775690525; a=rsa-sha256;
	cv=none;
	b=X3HKcBNTUQTBKly2T98cy2LNNdf9gURaEv7R/snq5EO1RKm1WtwX3bF6mPsl4m1bTlzRLw
	1Zn87VFfslUY/2pvs6ND/A+ujHEYoUtGFbqHIeOQllygnLz/FWdA3MbPjwYYgK+2vQFPOl
	esaGssJAIl+AihIsWUwyc3h+Q3pLYrI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="IR/1uMUK";
	spf=pass (imf18.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775690524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jgcYXNV9AndVyM0eXgkCwf75FkwR80fy6ED6RTnrjIA=;
	b=IR/1uMUKabZaYISG75RJO41H3JBa8rBHY+MtfSE85lTMUIdax/P3QyAq88QpcaITMiQ9Og
	fk/ZYznvWJ7qQDxh5O2+re3+l0OC6Cnq3wpVMsxcLcjhgUtSZH/3u2ThKFRAqq2Sfag106
	PrNHsEUegZo8BlPbwEi2hMWxgGzLkIo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-391-Ou9jisOEPRKsGiMinPWqKQ-1; Wed,
 08 Apr 2026 16:23:21 -0400
X-MC-Unique: Ou9jisOEPRKsGiMinPWqKQ-1
X-Mimecast-MFC-AGG-ID: Ou9jisOEPRKsGiMinPWqKQ_1775679800
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 277821800620;
	Wed,  8 Apr 2026 20:23:20 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.88.140])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D8F6C180075D;
	Wed,  8 Apr 2026 20:23:18 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v3 03/10] drivers: dax: use pgtable_has_pmd_leaves()
Date: Wed,  8 Apr 2026 16:22:58 -0400
Message-ID: <a62158b3c271b02c7a6d5502b14b2f9972b8615a.1775679721.git.luizcap@redhat.com>
In-Reply-To: <cover.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: tV1TM2BQjg7JEqo32lld8H-MRLp12jGNBtcNGgTVxXM_1775679800
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Stat-Signature: wrunmu6kmnwta7d36nai1jcxt9a4nrnr
X-Rspamd-Queue-Id: E34361C000C
X-Rspam-User: 
X-HE-Tag: 1775690524-587165
X-HE-Meta: U2FsdGVkX1/UG34ce/Q6xevUNSRA0uq0h2DG2RjviXaVcVtxB+a4Gt4MHhybhOryAPGBxzoRuN30/hS9p9EGJp1fsw43Efaj4LYn2+bmCf6I/rvIjwuEfonaCeUOOt8J8OZ4flmqk43RLsmG3szauMCEjRC5Zvc0kUP2+OXZIEiOErIdH4BHvN/B4UY/dnKHGN8XriRHem0bBRJdkpSj7YYKxpoMOR1uWWKfKhNq2JgPWAMSDzeLJDN3GMSBoJ3Vxqj44oBpNOqC2yG78AVNVwksg5em3phKw4F/QtH1MofqntW2l99JaUcfDYvcBqaKN9esmouDQC5c4QjcUi1Gq3SWF0gskCVZgySBu2A9LS6N7VRnFGPQ+6yy5q6w9jCjw3VHFNn9ZkJhl0F1l95Iv+tt8FkMTNopIjm0rnWe6J/RGo/8yJ+xUFuoecibIV4YNyRNg/fZq6ekG42j13wcLGSQGhjX4k/rJ1WiZk9zhzXDQrKJYZUPFHecLUoMsnKMH/+pUrB+L530a4zkw92MmItWmyo5eCEUdu2NWlFYPwpI7QrRAdsxDQwVLNWww/W68at4kEp+bCr01erAX0v0IPheDIuFQZ3wNlcJJMIHPCX6/vJe9XHrQTnePoCJbEWbV5NkUXsR/8Xg6DJGlyPh+RUnc1oWp6TtyCmhd9biZIM/xjSc45yTL1Loe/8C2CrNLNlFyOKmT3IvFiwpEQEw9qmNjpGxD1FOn7z97WCXrcS+OFLQjslXZLK26kyaro//aWJM7+vJRHbqzizNi48qxkfQEAfdRBvW8eg10Fsqc0rPcNEqpQ3Nel+RBuYM9yjQZ+oxFACXjBItiIHYr53+njz0Ne8oWBEC6FlU+jPXoCg+tjmCg3QZufEySpZi+6yDl06C7A67MPrG/ltCpyaAFp1mdCQ24kZAQwPuU1ky0cjEC30iDmsdTcjcBf7ozqhr+o0Dq+bnVohb8OOR5o/
 SoNXxEwR
 6UK7l3UDuCjnivscVFOUvpWCY5Gw5KeZjXfrjlzYNRkWGr6DOkyFPBEzfLqd7ix+Bd1j5aW3G4gS/uBMFOZCELZ7XnE4bxcqq5ui7KGvw307v5golFQNjiff0IKEWVjLaREZHaXMK+uUtxKFAnjpMXN02d5LnZLm5Ptqzvgf3wetySGpJqwD/QXwzanL1S0U06bTfXrP8EiIMGF5GJxAbFd0g3REmOJP7y4ILIkoQrBQBasBbeGogELS+6KPeMxdLdg/r/EkkV9Yym9BjuFT/PNxIHyGD40+6vo/0kFRy4gTDFAt6Q0p9yH4TWYUCXdcWdp4/kxrQtkpNRgkH9oNA9g/Rs/QYBR/x8+4cqdApjCm7BCCMeNUNMQArYPHKjnb8FRWbu8evBTrqYu+3sVjOYg34w6FGXpLRB5XL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dax_align_valid() uses has_transparent_hugepage() to check if PMD-sized
pages are supported, use pgtable_has_pmd_leaves() instead.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 drivers/dax/dax-private.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index c6ae27c982f4..97b577f4107b 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -119,7 +119,7 @@ static inline bool dax_align_valid(unsigned long align)
 {
 	if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
 		return true;
-	if (align == PMD_SIZE && has_transparent_hugepage())
+	if (align == PMD_SIZE && pgtable_has_pmd_leaves())
 		return true;
 	if (align == PAGE_SIZE)
 		return true;
-- 
2.53.0


