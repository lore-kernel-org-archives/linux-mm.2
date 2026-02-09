Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD8A0E94617
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 22:15:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116B76B0092; Mon,  9 Feb 2026 17:14:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 080E16B0099; Mon,  9 Feb 2026 17:14:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF93F6B009B; Mon,  9 Feb 2026 17:14:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB6296B0092
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:14:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86EEF160262
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:14:57 +0000 (UTC)
X-FDA: 84426324234.29.B7A1129
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id A6C8E100013
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:14:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OJB8rAer;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770675295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OiFiUMpX2KB1Jv/lqdujtPm172YWQGONs7yMm/FtBvY=;
	b=YRQbnxnmbzu27G1aRBN5Euy7B7YHa/KajgkgPjptjb8kFKat5f8FrEn7HClmh6XAcQRM3x
	TPnKWT4mTogFo7Pm6oAUcvbZ0X820MQPzmuxA8jyejKpJjwKKUaA13aEEaoR2LmmnBpSli
	VQboCHVj0YXzjD7uIyoylSO7Gwz8R8M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OJB8rAer;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770675295; a=rsa-sha256;
	cv=none;
	b=05VinpeUILCoRi/enm7PRrWtvzNwLnTj5EvD3mEr1rewYh2TSJsGQi0rvWk9zBM8+DyQsX
	0cQcfHyKDUjWYaeYi6A4jwUbBheqwrWyqA5icbQyi0TB2xFbF7WxyZWAAt2Qom4UZANHe6
	+txB53alFVw1tiGrMadqeugHSxvrxAs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770675295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OiFiUMpX2KB1Jv/lqdujtPm172YWQGONs7yMm/FtBvY=;
	b=OJB8rAerXC+XDZMFsdNeWhUDqyNEw1pSBLjGZ87u77Prnuzwnm6jwklIT7lPgMdKla/YtQ
	KOUA8yXyK72is4FtXw98Nri0CIiUzkBCzd5wuI2dnC3oiyqHlg7YvlvE26nuzbQLNBCElC
	75+UhYj2R25qBGZOE2lbCRwsU0DV4s8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-100-N0_AAJneNLm9RMcrR_haJw-1; Mon,
 09 Feb 2026 17:14:52 -0500
X-MC-Unique: N0_AAJneNLm9RMcrR_haJw-1
X-Mimecast-MFC-AGG-ID: N0_AAJneNLm9RMcrR_haJw_1770675291
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49F0F1956089;
	Mon,  9 Feb 2026 22:14:51 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.66])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1296F18003F6;
	Mon,  9 Feb 2026 22:14:49 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v2 04/11] drivers: i915 selftest: use pgtable_has_pmd_leaves()
Date: Mon,  9 Feb 2026 17:14:26 -0500
Message-ID: <5f829c4198fe72ac71e3e62426e12d475501ae51.1770675272.git.luizcap@redhat.com>
In-Reply-To: <cover.1770675272.git.luizcap@redhat.com>
References: <cover.1770675272.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: brJ9lqsE1wZwR32qKSRO55qZeas6hKZ6KoNyuwxoz8A_1770675291
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A6C8E100013
X-Stat-Signature: iexnxhjdi8fm73bfqfpc5631d3garpa4
X-Rspam-User: 
X-HE-Tag: 1770675295-907331
X-HE-Meta: U2FsdGVkX19tqV+xBMLknGcNzxEGad0AwX3WtObfp4eeNsyyI0RGFdK3BOtWK3kYHOk4AabueXa5o5JmMva1rGlswPyPAhJvRLNUPlxQ6lfAA8c4i69hG+FUdoIuzpmUAe5Mt7nuzt6B/gBilurUsIt5308np/aY0NVqYY3Com1PStv9lAohCyxp5n+HVt7OzGfXjjL6xoVuAQwimM3kPRETtsOc1RunvUPWP9Zuva9H54xzI5rnd6BzUUDRyD8rwkODEjaqf6l5YIBlJ2v187fEd5ffcJezx3fOm58kT0MyLFKtrRj9UT1Ujz+kAtWabLP7SllwzqnkbpAoaRk0JUttxl7msVa03iQ3FECrGfLwjP1MIR9U++JMmmqxdBrC1n85nBca4ffFMj3+zdp06AbX9v9S/D6bs/lsMjpMPJrMycAwMSH6uv9LH4Q7KHD3p+VR4HPr5FUHgbt4zBvGvl/L2Clqy1gHREW+tagfiK6XZJ12CooBHjz0+N4YxXKO3BeWjn/eNwDtSGHj2Ju1x/V7bHiFYsmWY51B9jW0Ajr5+ChA8wFD7uDKyWDBl1qM7+T68r+nhypU6pVQx2x/U+JwAVwB2wzL5/OT9FEDfDZD+ZOHa638LeAKvn4ixKAzMCiAPLrlmBTJRSAiSDB5JxUViFB+ertV20ALno9ynRDaPEfIjVmBbKAW69ffjheLojgEKcEBZoiMgHREMF9YDXs+TLDSur9dgxXLZckpFJo3kOvuhKJ7r6ohz+nnX+4R5PkTFo8TSld0YTlsRFIDFxxwjo+re45+44ZJTtZhVg8yz7NbsdJC9huslwjWIEc7LGtbuMa0XM1HjmMNA3XyMCCTnJG0gcu+ldwTcoEXksgsyL6u5wWdb8qaVetcouqjZWZtn6yYN6LnKn4DEYOq0JqzqGlpIgxwsZwe3tkC8+k/oSpxNWA/zE9HKTXsSWMDVtZXXPeh23neCmatpjR
 UnGs6DgQ
 xGaHmFvzHA6wX5NW9P+R0kgWNO17v4LJK+tVwebqnQP339o/TsvZ8PpbLJ7JJeU1J60lepL8iDxgZ99nkUKAvJmU9ZMkEADbU9O/unHAyTPAGGxDXNp9ZYKaAIUvlBXaO80SjJ6JEwMLPLOZQHz1ID0s7Jc5gmXKWAO17JE8ybmA5ux5Xt5MbOCyBzkkGomJDV7DcgbbZg6IhXp84QdgDDJaRF/RlF/NYXWluvaXNViAHa+Kfm+TRL2RE5YCeKTU4YGox1fUvoBkSPtdf6PT63XhC25NzPcruZoxgqQebpYnG90S4zgc/FCnCUoEcTembfyK453vWf1TK3372d6Bq/gmLiY3fi9oEXkC7v/Jl2zwY67YQoZopulDSEoXhAFo9UouN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

igt_can_allocate_thp() uses has_transparent_hugepage() to check if THP
is supported with PMD-sized pages. However, has_transparent_hugepage()
is being replaced by an API that has clearer semantics. Thus, replace
has_transparent_hugepage() with pgtable_has_pmd_leaves() and a check for
IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE), this makes the intent of the
check very clear.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 drivers/gpu/drm/i915/gem/selftests/huge_pages.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
index bd08605a1611..dcd1f1141513 100644
--- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
+++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
@@ -1316,7 +1316,9 @@ typedef struct drm_i915_gem_object *
 
 static inline bool igt_can_allocate_thp(struct drm_i915_private *i915)
 {
-	return i915->mm.gemfs && has_transparent_hugepage();
+	return i915->mm.gemfs &&
+		IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+		pgtable_has_pmd_leaves();
 }
 
 static struct drm_i915_gem_object *
-- 
2.53.0


